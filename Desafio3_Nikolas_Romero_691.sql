-- Crear la tabla Usuarios
CREATE TABLE Usuarios (
    id serial PRIMARY KEY,
    email VARCHAR(255),
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    rol VARCHAR(255)
);
​
-- Insertar 5 usuarios
INSERT INTO Usuarios (email, nombre, apellido, rol)
VALUES
    ('usuario1@example.com', 'Juan', 'Pérez', 'administrador'),
    ('usuario2@example.com', 'María', 'López', 'usuario'),
    ('usuario3@example.com', 'Pedro', 'Gómez', 'usuario'),
    ('usuario4@example.com', 'Ana', 'Rodríguez', 'usuario'),
    ('usuario5@example.com', 'Carlos', 'Martínez', 'usuario');
​
-- Crear la tabla Posts
CREATE TABLE Posts (
    id serial PRIMARY KEY,
    título VARCHAR(255),
    contenido TEXT,
    fecha_creacion TIMESTAMP,
    fecha_actualizacion TIMESTAMP,
    destacado BOOLEAN,
    usuario_id BIGINT
);
​
-- Insertar 5 posts
INSERT INTO Posts (título, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES
    ('Título del Post 1', 'Contenido del Post 1', ('2023-10-20 10:30:00'), ('2023-10-20 22:30:00'), true, 1),
    ('Título del Post 2', 'Contenido del Post 2', ('2023-10-21 10:30:00'), ('2023-10-21 22:30:00'), true, 1),
    ('Título del Post 3', 'Contenido del Post 3', ('2023-10-22 10:30:00'), ('2023-10-22 22:30:00'), false, 2),
    ('Título del Post 4', 'Contenido del Post 4', ('2023-10-23 10:30:00'), ('2023-10-23 22:30:00'), false, 3),
    ('Título del Post 5', 'Contenido del Post 5', ('2023-10-24 10:30:00'), ('2023-10-24 22:30:00'), false, NULL);
	
-- Crear la tabla Comentarios
CREATE TABLE Comentarios (
    id serial PRIMARY KEY,
    contenido TEXT,
    fecha_creacion TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT
);
​
-- Insertar 5 comentarios
INSERT INTO Comentarios (contenido, fecha_creacion, usuario_id, post_id)
VALUES
    ('Comentario 1', ('2023-10-20 11:30:00'), 1, 1),
    ('Comentario 2',('2023-10-21 11:30:00'), 2, 1),
    ('Comentario 3', ('2023-10-22 11:30:00'), 3, 1),
    ('Comentario 4', ('2023-10-23 11:30:00'), 1, 2),
    ('Comentario 5', ('2023-10-24 11:30:00'), 2, 2);
​
-- Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al título y contenido del post.
SELECT u.nombre, u.email, p.título, p.contenido
FROM Usuarios u
INNER JOIN Posts p ON u.id = p.usuario_id;
​
-- Muestra el id, título y contenido de los posts de los administradores. El administrador puede ser cualquier id
SELECT p.id, p.título, p.contenido
FROM Usuarios u
INNER JOIN Posts p ON u.id = p.usuario_id
WHERE u.rol = 'administrador';
​
--Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.
SELECT u.id, u.email, COUNT(p.id) AS cantidad_de_posts
FROM Usuarios u
LEFT JOIN Posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email
HAVING COUNT(p.id) >= 0
ORDER BY u.id;
​
--Muestra el email del usuario que ha creado más posts:
​
SELECT u.email
FROM Usuarios u
LEFT JOIN Posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email
ORDER BY COUNT(p.id) DESC
LIMIT 1;
​
--Muestra la fecha del último post de cada usuario. Utiliza la función de agregado MAX sobre la fecha de creación.
​
SELECT u.id, u.email, MAX(p.fecha_creacion) AS fecha_ultimo_post
FROM Usuarios u
LEFT JOIN Posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email
ORDER BY u.id;
​
--Muestra el título y contenido del post (artículo) con más comentarios.
SELECT p.título, p.contenido
FROM Posts p
LEFT JOIN (
    SELECT post_id, COUNT(id) AS cantidad_de_comentarios
    FROM Comentarios
    GROUP BY post_id
) c ON p.id = c.post_id
ORDER BY c.cantidad_de_comentarios DESC
LIMIT 1;
​
--Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
--de cada comentario asociado a los posts mostrados, junto con el email del usuario
--que lo escribió.
​
SELECT p.título AS titulo_post, p.contenido AS contenido_post, c.contenido AS contenido_comentario, u.email
FROM Posts p
LEFT JOIN Comentarios c ON p.id = c.post_id
LEFT JOIN Usuarios u ON c.usuario_id = u.id;
​
-- Muestra el contenido del último comentario de cada usuario.
SELECT u.id, u.email, c.contenido AS último_comentario
FROM Usuarios u
LEFT JOIN (
  SELECT c1.usuario_id, c1.contenido
  FROM Comentarios c1
  WHERE c1.fecha_creacion = (SELECT MAX(c2.fecha_creacion) 
							 FROM Comentarios c2 
							 WHERE c2.usuario_id = c1.usuario_id)
) c ON u.id = c.usuario_id;
​
​
-- Muestra los emails de los usuarios que no han escrito ningún comentario:
SELECT u.email
FROM Usuarios u
LEFT JOIN Comentarios c ON u.id = c.usuario_id
GROUP BY u.email
HAVING COUNT(c.id) = 0;
