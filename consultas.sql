-- Aula Norte · 12 consultas de práctica (Semana 3)
-- Molde: SELECT qué columnas | FROM qué tabla | WHERE qué condición

-- 1. Nombre y precio de todos los cursos
SELECT nombre, precio FROM cursos;

-- 2. Cursos que cuestan más de 130
SELECT nombre FROM cursos WHERE precio > 130;

-- 3. Nombre y email de todos los interesados
SELECT nombre, email FROM interesados;

-- 4. Cursos del más barato al más caro
SELECT nombre, precio FROM cursos ORDER BY precio;

-- 5. Precio del curso Excel avanzado (texto entre comillas simples)
SELECT precio FROM cursos WHERE nombre = 'Excel avanzado';

-- 6. Cursos sin fecha de comienzo (IS NULL, no "= NULL")
SELECT nombre FROM cursos WHERE comienza IS NULL;

-- 7. Cuántos interesados hay
SELECT COUNT(*) AS total FROM interesados;

-- 8. Cursos activos que cuestan menos de 160
SELECT nombre FROM cursos WHERE activo = true AND precio < 160;

-- 9. Cursos del más caro al más barato
SELECT nombre, precio FROM cursos ORDER BY precio DESC;

-- 10. Cada interesado con el nombre de su curso (JOIN une las dos tablas)
SELECT interesados.nombre AS interesado, cursos.nombre AS curso
FROM interesados
JOIN cursos ON interesados.curso_id = cursos.id;

-- 11. Subir el precio de Marketing digital a 160 (UPDATE siempre con WHERE)
UPDATE cursos SET precio = 160 WHERE nombre = 'Marketing digital';
SELECT nombre, precio FROM cursos;   -- verificar que solo cambió esa fila

-- 12. Interesados sin curso
SELECT nombre FROM interesados WHERE curso_id IS NULL;
