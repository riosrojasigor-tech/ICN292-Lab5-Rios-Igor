# ICN292 - Laboratorio 5: Entregable SQL

**Estudiante:** Igor Rios · **Fecha:** noviembre de 2026
**Curso:** ICN-292 Sistemas de Información para la Gestión - Segundo Semestre 2026 - Campus Vitacura

Construcción de la base de datos `andesbike` de la cadena de tiendas Andes Bike en MySQL 8. El script crea las cuatro tablas (`tiendas`, `vendedores`, `bicicletas` y `ventas`) con sus claves primarias, foráneas y restricciones, carga los datos oficiales y ejecuta las diez consultas pedidas.

## Contenido del repositorio

| Archivo | Descripción |
|---|---|
| `ICN292-Lab5-Rios-Igor.pdf` | Informe: portada y las 10 consultas, cada una con su código y su captura |
| `ICN292-Lab5-Rios-Igor.docx` | El mismo informe en Word |
| `ICN292-Lab5-Rios-Igor.sql` | Script completo: creación de tablas, carga oficial y consultas 1 a 10 |
| `ICN292-Lab5-Rios-Igor-diagrama.png` | Modelo entidad–relación obtenido con *Database > Reverse Engineer* |

## Cómo reproducir

Probado en **MySQL Server 8.0** con **MySQL Workbench 8.0**.

1. Abrir MySQL Workbench y conectarse a la instancia local.
2. Abrir el script con *File > Open SQL Script* y elegir `ICN292-Lab5-Rios-Igor.sql`.
3. Ejecutar el script completo con *Query > Execute (All or Selection)* (`Ctrl + Shift + Enter`). El script empieza con `DROP DATABASE IF EXISTS andesbike;`, así que se puede correr varias veces desde cero.
4. Revisar los resultados en las pestañas de *Result Grid*. Ninguna consulta modifica los datos, así que se pueden correr en cualquier orden.
5. Para ver el diagrama: *Database > Reverse Engineer...*, elegir la base `andesbike` y terminar el asistente.

**Nota:** la carga oficial tiene 4 tiendas, 8 vendedores, 8 modelos y 18 ventas (35 unidades). Las 18 ventas suman 16.969.650.
