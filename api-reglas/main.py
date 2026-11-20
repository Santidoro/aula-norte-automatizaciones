from fastapi import FastAPI

app = FastAPI()

CURSOS = [
    {"id": 1, "nombre": "Excel", "precio": 120},
    {"id": 2, "nombre": "Inglés", "precio": 180},
    {"id": 4, "nombre": "Marketing digital", "precio": 160},
]

@app.get("/cursos")
def listar_cursos():
    return CURSOS


@app.post("/validar-interesado")
def validar_interesado(datos: dict):
    faltan = []
    for campo in ["nombre", "email", "curso"]:
        valor = datos.get(campo)
        if not valor or not str(valor).strip():
            faltan.append(campo)
    return {"ok": len(faltan) == 0, "faltan": faltan}
