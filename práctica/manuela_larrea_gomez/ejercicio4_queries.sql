use Ejercicio2
go

--- 1. �Qu� provincias y tipos de v�as tienen cero accidentes mortales a 30 d�as en 2015?
SELECT p.provincia, tp.tipo_via
FROM Accidente AS a
JOIN Provincia AS p ON a.id_provincia = p.id_provincia
JOIN TipoVia AS tp ON a.id_tipo_via = tp.id_tipo_via
WHERE a.anio = 2015 AND a.accidentes_mortales_30_dias = 0;

--- 2. Obt�n las provincias de �Andaluc�a� con m�s de 25 fallecidos en v�as interurbanas en 2014.
SELECT DISTINCT p.provincia
FROM Accidente AS a
JOIN Provincia AS p ON a.id_provincia = p.id_provincia
JOIN Comunidad AS c ON p.id_ccaa = c.id_ccaa
JOIN TipoVia AS tp ON a.id_tipo_via = tp.id_tipo_via
WHERE (c.ccaa = 'Andaluc�a' OR c.id_ccaa = 1)
AND a.anio = 2014
AND a.fallecidos > 25
AND (tp.tipo_via = 'Interurbana' OR tp.id_tipo_via = 'A');

--- 3. �Cu�l es la Comunidad Aut�noma con m�s accidentes con v�ctimas en 2015?
SELECT TOP(1) c.ccaa FROM Accidente AS a 
JOIN Provincia AS p ON a.id_provincia = p.id_provincia
JOIN Comunidad AS c ON p.id_ccaa = c.id_ccaa
WHERE a.anio = 2015
GROUP BY c.ccaa
HAVING COUNT(a.accidentes_con_victimas) > 0 
ORDER BY COUNT(a.accidentes_con_victimas) DESC;

--- 4. �Cu�l es el n�mero medio de heridos no hospitalizados por a�o? Redondea el resultado sin decimales
SELECT a.anio, ROUND(AVG(a.heridos_no_hospitalizados), 0) AS 'Promedio heridos no hospitalizados' 
FROM Accidente AS a
GROUP BY (a.anio);

--- 5. �Cu�l es la combinaci�n de a�o, provincia y tipo de v�a con m�s heridos hospitalizados?
SELECT TOP(1) a.anio, p.provincia, tp.tipo_via
FROM Accidente AS a
JOIN TipoVia AS tp ON tp.id_tipo_via = a.id_tipo_via
JOIN Provincia AS p ON p.id_provincia = a.id_provincia
ORDER BY a.heridos_hospitalizados DESC;

--- 6. �Qu� Comunidades Aut�nomas tienen m�s de 200 fallecidos en 2015?
SELECT c.ccaa AS 'Comunidad Aut�noma' 
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN Comunidad as c ON p.id_ccaa = c.id_ccaa
WHERE a.anio = 2015 
GROUP BY c.ccaa
HAVING SUM(a.fallecidos) > 200;

--- 7. �Cu�l es la provincia que "peor conduce en v�as urbanas" (en n�mero de accidentes con v�ctimas) en 2015? �Y en v�as interurbanas?SELECT TOP (1) p.provincia AS 'Provincia que peor conduce en v�as Urbanas', SUM(a.accidentes_con_victimas) AS 'N�mero de accidenetes con v�ctimas'
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
WHERE tp.tipo_via = 'Urbana' AND a.anio = 2015
GROUP BY p.provincia
ORDER BY SUM(a.accidentes_con_victimas) DESC;

SELECT TOP (1) p.provincia AS 'Provincia que peor conduce en v�as Interurbanas', SUM(a.accidentes_con_victimas) AS 'N�mero de accidenetes con v�ctimas'
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
WHERE tp.tipo_via = 'Interurbana' AND a.anio = 2015
GROUP BY p.provincia
ORDER BY SUM(a.accidentes_con_victimas) DESC;

--- 8. Obt�n un listado de las provincia que empiezan por la letra �C� y ordena las descripciones de forma descendente.SELECT p.provincia AS 'Provincias que empiezan por la letra C'FROM Provincia AS p WHERE p.provincia LIKE 'C%'ORDER BY p.provincia DESC--- 9. Haz un ranking con las tres provincias que tienen el mayor n�mero de heridos totales (heridos hospitalizados + heridos no hospitalizados) en v�as interurbanas en 2015.SELECT TOP (3) p.provincia AS 'Provincia', SUM(a.heridos_hospitalizados + a.heridos_no_hospitalizados) AS 'Heridos totales'
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
WHERE tp.tipo_via = 'Interurbana' AND a.anio = 2015
GROUP BY p.provincia
ORDER BY SUM(a.heridos_hospitalizados + a.heridos_no_hospitalizados) DESC;

--- 10. Calcula la diferencia entre 2014 y 2015 de la proporci�n de heridos hospitalizados y no hospitalizados de la Comunidad Aut�noma de "Asturias" en v�as interurbanas.
SELECT
    a.anio AS 'A�o',
    p.provincia AS 'Provincia',
    c.ccaa AS 'Comunidad Aut�noma',
    CONCAT(CAST((SUM(a.heridos_no_hospitalizados) * 100.0) / (SUM(a.heridos_hospitalizados) + SUM(a.heridos_no_hospitalizados)) AS DECIMAL(10, 2)), '%') AS 'Proporci�n de heridos no hospitalizados',
    CONCAT(CAST((SUM(a.heridos_hospitalizados) * 100.0) / (SUM(a.heridos_hospitalizados) + SUM(a.heridos_no_hospitalizados)) AS DECIMAL(10, 2)), '%') AS 'Proporci�n de heridos hospitalizados'
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



-- Otra opci�n de soluci�n

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
), '%') AS 'Diferencia de proporci�n de heridos no hospitalizados'


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
), '%') AS 'Diferencia de proporci�n de heridos hospitalizados'
