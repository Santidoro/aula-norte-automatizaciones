# Flujos de Aula Norte

Mapa de los flujos de n8n del proyecto. Cada **servicio** hace una sola cosa y lo llaman otros flujos con *Execute Workflow*.

## Entradas

| Flujo | Disparador | Qué hace |
|---|---|---|
| Interesado · Form | Form Trigger | Recibe el formulario web, llama a *Guardar interesado · lógica* y muestra "¡Gracias!" o el error. |
| Interesado · API | Webhook POST `aula-norte-interesado` (Header Auth) | Recibe interesados desde otros sistemas, llama a la misma lógica y responde 200 `{ok, id}` o 400 `{ok, error}`. |

## Lógica

| Flujo | Qué hace |
|---|---|
| Guardar interesado · lógica | Normaliza → valida datos → busca el curso → guarda en `interesados`. Registra el resultado en el log. Devuelve `{ok, id}` o `{ok, error}`. |
| Calificador | Clasifica a cada interesado como caliente / tibio / frío con un LLM. |

## Servicios

| Servicio | Entrada | Salida |
|---|---|---|
| Servicio · Normalizar contacto | `nombre`, `email`, `telefono` (+ cualquier otro campo) | Los mismos campos limpios: nombre en Título, email en minúsculas, teléfono solo dígitos o `null`. |
| Servicio · Registrar evento | `flujo`, `evento`, `ok`, `interesado_id` | Inserta una fila en `log_ejecuciones` y devuelve su `id`. |

## Programados y alertas

| Flujo | Disparador | Qué hace |
|---|---|---|
| Resumen diario HTML | Schedule 9:00 | Corre el Calificador, busca los interesados de las últimas 24 h ordenados por temperatura y manda un email HTML (también si hay 0). |
| Alertas Aula Norte | Error Trigger | Cuando un flujo asignado falla: avisa por Telegram (flujo, nodo, error, link) y registra el error en el log. |

## Asistente (RAG)

| Flujo | Qué hace |
|---|---|
| Cargar reglamento | Trocea el reglamento (500/50) y lo guarda con embeddings en el Simple Vector Store. |
| Asistente de reglamento | Chat que responde solo con el reglamento. Si no está, dice "No lo sé, te paso con una persona." |

## Reglas de diseño

- **Un servicio, una tarea.** Si dos flujos necesitan lo mismo, se convierte en servicio.
- **Contrato fijo.** Las respuestas siempre son `{ok, id}` o `{ok, error}`.
- **Reintentos solo para fallos temporales.** Retry On Fail (3 intentos, 2 s) en HubSpot y OpenAI. Un error de datos (4xx) no se reintenta.
- **Todo error avisa y queda registrado.** Los flujos importantes tienen *Alertas Aula Norte* como Error Workflow.
