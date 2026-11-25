import json, re, sys
from pathlib import Path

POR_DEFECTO = re.compile(r"^(HTTP Request|Code|If|Edit Fields|Set|Postgres|Gmail|Webhook|Execute Workflow|Switch|Merge)\d*$")
EMAIL = re.compile(r"[\w.+-]+@[\w-]+\.[\w.]+")
PERMITIDOS = ("@test.com", "@example.com", "@ejemplo.com", "santi@mil.com")
errores = []

for archivo in Path(".").rglob("*.json"):
    texto = archivo.read_text(encoding="utf-8")
    try:
        flujo = json.loads(texto)
    except json.JSONDecodeError:
        continue
    if not isinstance(flujo, dict) or "nodes" not in flujo:
        continue

    for nodo in flujo["nodes"]:
        if POR_DEFECTO.match(nodo["name"]):
            errores.append(f"{archivo}: nodo con nombre por defecto '{nodo['name']}'")

    es_alertas = any(n["type"] == "n8n-nodes-base.errorTrigger" for n in flujo["nodes"])
    if not es_alertas and not flujo.get("settings", {}).get("errorWorkflow"):
        errores.append(f"{archivo}: no tiene Error Workflow asignado")

    reales = [e for e in EMAIL.findall(texto) if not e.lower().endswith(PERMITIDOS)]
    if reales:
        errores.append(f"{archivo}: contiene {len(reales)} email(s) que no son de prueba")

if errores:
    print("❌ Problemas encontrados:")
    for e in errores:
        print(" -", e)
    sys.exit(1)

print("✅ Todos los flujos pasan la revisión")