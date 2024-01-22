use Ejercicio2
go

--- 1. ¿Qué provincias y tipos de vías tienen cero accidentes mortales a 30 días en 2015?
SELECT p.provincia, tp.tipo_via
FROM Accidente AS a
JOIN Provincia AS p ON a.id_provincia = p.id_provincia
JOIN TipoVia AS tp ON a.id_tipo_via = tp.id_tipo_via
WHERE a.anio = 2015 AND a.accidentes_mortales_30_dias = 0;

--- 2. Obtén las provincias de “Andalucía” con más de 25 fallecidos en vías interurbanas en 2014.
SELECT DISTINCT p.provincia
FROM Accidente AS a
JOIN Provincia AS p ON a.id_provincia = p.id_provincia
JOIN Comunidad AS c ON p.id_ccaa = c.id_ccaa
JOIN TipoVia AS tp ON a.id_tipo_via = tp.id_tipo_via
WHERE (c.ccaa = 'Andalucía' OR c.id_ccaa = 1)
AND a.anio = 2014
AND a.fallecidos > 25
AND (tp.tipo_via = 'Interurbana' OR tp.id_tipo_via = 'A');

--- 3. ¿Cuál es la Comunidad Autónoma con más accidentes con víctimas en 2015?
SELECT TOP(1) c.ccaa FROM Accidente AS a 
JOIN Provincia AS p ON a.id_provincia = p.id_provincia
JOIN Comunidad AS c ON p.id_ccaa = c.id_ccaa
WHERE a.anio = 2015
GROUP BY c.ccaa
HAVING COUNT(a.accidentes_con_victimas) > 0 
ORDER BY COUNT(a.accidentes_con_victimas) DESC;

--- 4. ¿Cuál es el número medio de heridos no hospitalizados por año? Redondea el resultado sin decimales
SELECT a.anio, ROUND(AVG(a.heridos_no_hospitalizados), 0) AS 'Promedio heridos no hospitalizados' 
FROM Accidente AS a
GROUP BY (a.anio);

--- 5. ¿Cuál es la combinación de año, provincia y tipo de vía con más heridos hospitalizados?
SELECT TOP(1) a.anio, p.provincia, tp.tipo_via
FROM Accidente AS a
JOIN TipoVia AS tp ON tp.id_tipo_via = a.id_tipo_via
JOIN Provincia AS p ON p.id_provincia = a.id_provincia
ORDER BY a.heridos_hospitalizados DESC;

--- 6. ¿Qué Comunidades Autónomas tienen más de 200 fallecidos en 2015?
SELECT c.ccaa AS 'Comunidad Autónoma' 
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN Comunidad as c ON p.id_ccaa = c.id_ccaa
WHERE a.anio = 2015 
GROUP BY c.ccaa
HAVING SUM(a.fallecidos) > 200;

--- 7. ¿Cuál es la provincia que "peor conduce en vías urbanas" (en número de accidentes con víctimas) en 2015? ¿Y en vías interurbanas?SELECT TOP (1) p.provincia AS 'Provincia que peor conduce en vías Urbanas', SUM(a.accidentes_con_victimas) AS 'Número de accidenetes con víctimas'
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
WHERE tp.tipo_via = 'Urbana' AND a.anio = 2015
GROUP BY p.provincia
ORDER BY SUM(a.accidentes_con_victimas) DESC;

SELECT TOP (1) p.provincia AS 'Provincia que peor conduce en vías Interurbanas', SUM(a.accidentes_con_victimas) AS 'Número de accidenetes con víctimas'
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
WHERE tp.tipo_via = 'Interurbana' AND a.anio = 2015
GROUP BY p.provincia
ORDER BY SUM(a.accidentes_con_victimas) DESC;

--- 8. Obtén un listado de las provincia que empiezan por la letra “C” y ordena las descripciones de forma descendente.SELECT p.provincia AS 'Provincias que empiezan por la letra C'FROM Provincia AS p WHERE p.provincia LIKE 'C%'ORDER BY p.provincia DESC--- 9. Haz un ranking con las tres provincias que tienen el mayor número de heridos totales (heridos hospitalizados + heridos no hospitalizados) en vías interurbanas en 2015.SELECT TOP (3) p.provincia AS 'Provincia', SUM(a.heridos_hospitalizados + a.heridos_no_hospitalizados) AS 'Heridos totales'
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
WHERE tp.tipo_via = 'Interurbana' AND a.anio = 2015
GROUP BY p.provincia
ORDER BY SUM(a.heridos_hospitalizados + a.heridos_no_hospitalizados) DESC;

--- 10. Calcula la diferencia entre 2014 y 2015 de la proporción de heridos hospitalizados y no hospitalizados de la Comunidad Autónoma de "Asturias" en vías interurbanas.
SELECT
    a.anio AS 'Año',
    p.provincia AS 'Provincia',
    c.ccaa AS 'Comunidad Autónoma',
    CONCAT(CAST((SUM(a.heridos_no_hospitalizados) * 100.0) / (SUM(a.heridos_hospitalizados) + SUM(a.heridos_no_hospitalizados)) AS DECIMAL(10, 2)), '%') AS 'Proporción de heridos no hospitalizados',
    CONCAT(CAST((SUM(a.heridos_hospitalizados) * 100.0) / (SUM(a.heridos_hospitalizados) + SUM(a.heridos_no_hospitalizados)) AS DECIMAL(10, 2)), '%') AS 'Proporción de heridos hospitalizados'
FROM
    Accidente AS a
JOIN
    Provincia AS p ON p.id_provincia = a.id_provincia
JOIN
    TipoVia AS tp ON tp.id_tipo_via = a.id_tipo_via
JOIN
    Comunidad AS c ON c.id_ccaa = p.id_ccaa
WHERE
    tp.tipo_via = 'Interurbana' AND p.provincia = 'Asturias'
GROUP BY
    a.anio, p.provincia, c.ccaa;



-- Otra opción de solución

SELECT 
CONCAT((
SELECT
(SUM(a.heridos_no_hospitalizados) *100) / SUM(a.heridos_hospitalizados + A.heridos_no_hospitalizados)
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
JOIN Comunidad AS c ON c.id_ccaa = p.id_ccaa
WHERE tp.tipo_via = 'Interurbana' AND p.provincia = 'Asturias' AND a.anio=2015
GROUP BY a.anio, p.provincia, c.ccaa
)
-
(
SELECT
(SUM(a.heridos_no_hospitalizados) *100) / SUM(a.heridos_hospitalizados + A.heridos_no_hospitalizados)
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
JOIN Comunidad AS c ON c.id_ccaa = p.id_ccaa
WHERE tp.tipo_via = 'Interurbana' AND p.provincia = 'Asturias' AND a.anio=2014
GROUP BY a.anio, p.provincia, c.ccaa
), '%') AS 'Diferencia de proporción de heridos no hospitalizados'


SELECT 
CONCAT((
SELECT
(SUM(a.heridos_hospitalizados) *100) / SUM(a.heridos_hospitalizados + A.heridos_no_hospitalizados)
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
JOIN Comunidad AS c ON c.id_ccaa = p.id_ccaa
WHERE tp.tipo_via = 'Interurbana' AND p.provincia = 'Asturias' AND a.anio=2015
GROUP BY a.anio, p.provincia, c.ccaa
)
-
(
SELECT
(SUM(a.heridos_hospitalizados) *100) / SUM(a.heridos_hospitalizados + A.heridos_no_hospitalizados)
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
JOIN Comunidad AS c ON c.id_ccaa = p.id_ccaa
WHERE tp.tipo_via = 'Interurbana' AND p.provincia = 'Asturias' AND a.anio=2014
GROUP BY a.anio, p.provincia, c.ccaa
), '%') AS 'Diferencia de proporción de heridos hospitalizados'
