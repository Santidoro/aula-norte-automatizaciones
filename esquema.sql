-- Aula Norte · esquema de la base (Supabase / Postgres)
-- Semana 3 · plan IA & Automatización

-- Tabla de cursos
CREATE TABLE cursos (
  id        SERIAL PRIMARY KEY,
  nombre    TEXT NOT NULL,
  precio    NUMERIC(10,2) NOT NULL,
  comienza  DATE,                          -- puede estar vacía: curso sin fecha todavía
  activo    BOOLEAN NOT NULL DEFAULT true
);

-- No puede haber dos cursos con el mismo nombre
ALTER TABLE cursos ADD CONSTRAINT cursos_nombre_unico UNIQUE (nombre);

-- Tabla de interesados (los llena el flujo "Guardar interesado")
CREATE TABLE interesados (
  id         SERIAL PRIMARY KEY,
  nombre     TEXT NOT NULL,
  email      TEXT NOT NULL UNIQUE,           -- un interesado por email
  curso_id   INT REFERENCES cursos(id),      -- foreign key: solo cursos que existen
  mensaje    TEXT,
  creado_en  TIMESTAMPTZ DEFAULT now()
);
