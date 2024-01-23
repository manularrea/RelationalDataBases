use Ejercicio2
go

--- 1. ¿Qué provincias y tipos de vías tienen cero accidentes mortales a 30 días en 2015?

/*Esta consulta combina la información de las tablas Accidente, Provincia y TipoVia mediante dos JOIN INNER. Luego, filtra 
los resultados para que solo incluyan los accidentes que ocurrieron en 2015 y no tuvieron víctimas mortales en los siguientes 30 días.*/

SELECT 
	p.provincia AS 'Provincia', 
	tp.tipo_via AS 'Tipo de vía'
FROM Accidente AS a
JOIN Provincia AS p ON a.id_provincia = p.id_provincia
JOIN TipoVia AS tp ON a.id_tipo_via = tp.id_tipo_via
WHERE a.anio = 2015 AND a.accidentes_mortales_30_dias = 0;


--- 2. Obtén las provincias de “Andalucía” con más de 25 fallecidos en vías interurbanas en 2014.

/*Esta consulta combina la información de las tablas Accidente, Provincia, TipoVia y Comunidad mediante tres JOIN INNER. 
Luego, filtra los resultados para que solo incluyan los accidentes que cumplen con los siguientes criterios:
Ocurren en Andalucía, ocurren en 2014, tienen más de 25 fallecidos y ocurren en vías interurbanas. La consulta utiliza la
cláusula DISTINCT para eliminar los resultados duplicados.*/

SELECT DISTINCT 
	p.provincia AS 'Provincia'
FROM Accidente AS a
JOIN Provincia AS p ON a.id_provincia = p.id_provincia
JOIN Comunidad AS c ON p.id_ccaa = c.id_ccaa
JOIN TipoVia AS tp ON a.id_tipo_via = tp.id_tipo_via
WHERE (c.ccaa = 'Andalucía' OR c.id_ccaa = 1)
AND a.anio = 2014
AND a.fallecidos > 25
AND (tp.tipo_via = 'Interurbana' OR tp.id_tipo_via = 'A');


--- 3. ¿Cuál es la Comunidad Autónoma con más accidentes con víctimas en 2015?

/*La consulta utiliza dos JOIN para combinar la información de las tablas Accidente, Provincia y Comunidad.
Filtra los accidentes que ocurrieron en 2015, agrupa los accidentes por comunidad autónoma, cuenta el número 
de accidentes con víctimas para cada comunidad autónoma Y devuelve la comunidad autónoma con el mayor número de accidentes con víctimas.
Se ordenan de forma descendente y se limita la salida a 1 registro (el primero)*/

SELECT TOP(1) 
	c.ccaa  AS 'Comunidad Autónoma' FROM Accidente AS a 
JOIN Provincia AS p ON a.id_provincia = p.id_provincia
JOIN Comunidad AS c ON p.id_ccaa = c.id_ccaa
WHERE a.anio = 2015
GROUP BY c.ccaa
HAVING COUNT(a.accidentes_con_victimas) > 0 
ORDER BY COUNT(a.accidentes_con_victimas) DESC;

--- 4. ¿Cuál es el número medio de heridos no hospitalizados por año? Redondea el resultado sin decimales

/*La consulta agrupa los accidentes por año y luego calcula el promedio del número de heridos no hospitalizados para cada año.
La consulta utiliza la cláusula ROUND() para redondear el resultado a cero decimales.*/

SELECT 
	a.anio AS 'Año', 
	ROUND(AVG(a.heridos_no_hospitalizados), 0) AS 'Promedio de heridos no hospitalizados' 
FROM Accidente AS a
GROUP BY (a.anio);


--- 5. ¿Cuál es la combinación de año, provincia y tipo de vía con más heridos hospitalizados?

/*La consulta hacer dos JOIN para acceder al nombre de la provincia y la descripcion de tipo de via. 
Luego ordena los accidentes por el número de heridos hospitalizados, de mayor a menor. Y devuelve la primera fila de
resultados, que corresponde a la combinación de año, provincia y tipo de vía con más heridos hospitalizados.*/

SELECT TOP(1) 
	a.anio AS 'Año', 
	p.provincia AS 'Provincia', 
	tp.tipo_via AS 'Tipo de vía'
FROM Accidente AS a
JOIN TipoVia AS tp ON tp.id_tipo_via = a.id_tipo_via
JOIN Provincia AS p ON p.id_provincia = a.id_provincia
ORDER BY a.heridos_hospitalizados DESC;

--- 6. ¿Qué Comunidades Autónomas tienen más de 200 fallecidos en 2015?

/*Esta consulta usa dos JOIN para acceder a las descripciones. Luego, filtra los accidentes que ocurrieron en 2015. 
Agrupa los accidentes por comunidad autónoma. Suma el número de fallecidos para cada comunidad autónoma y devuelve las comunidades 
autónomas con más de 200 fallecidos.
La consulta utiliza la cláusula HAVING para filtrar los resultados y solo incluir las comunidades autónomas con más de 200 fallecidos*/

SELECT 
	c.ccaa AS 'Comunidad Autónoma' 
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN Comunidad as c ON p.id_ccaa = c.id_ccaa
WHERE a.anio = 2015 
GROUP BY c.ccaa
HAVING SUM(a.fallecidos) > 200;

--- 7. ¿Cuál es la provincia que "peor conduce en vías urbanas" (en número de accidentes con víctimas) en 2015?
--- ¿Y en vías interurbanas?

/*Esta consulta usa dos JOIN para acceder a las descripciones. Luego, filtra los accidentes que ocurrieron en 2015 y que 
se produjeron en vías urbanas. Luego, agrupa los accidentes por provincia, cuenta el número de accidentes con víctimas para cada provincia
y devuelve la provincia con el mayor número de accidentes con víctimas.
La consulta utiliza la cláusula TOP(1) para limitar el resultado a una sola provincia, la que tiene más accidentes con 
víctimas en vías urbanas en 2015.*/

SELECT TOP (1) 
	p.provincia AS 'Provincia que peor conduce en vías Urbanas', 
	SUM(a.accidentes_con_victimas) AS 'Número de accidenetes con víctimas'
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
WHERE tp.tipo_via = 'Urbana' AND a.anio = 2015
GROUP BY p.provincia
ORDER BY SUM(a.accidentes_con_victimas) DESC;

/*La consulta es similar a la anterior, pero filtra los accidentes que se produjeron en vías interurbanas.*/

SELECT TOP (1)
	p.provincia AS 'Provincia que peor conduce en vías Interurbanas', 
	SUM(a.accidentes_con_victimas) AS 'Número de accidenetes con víctimas'
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
WHERE tp.tipo_via = 'Interurbana' AND a.anio = 2015
GROUP BY p.provincia
ORDER BY SUM(a.accidentes_con_victimas) DESC;


--- 8. Obtén un listado de las provincia que empiezan por la letra “C” y ordena las descripciones de forma descendente.

/*La consulta Selecciona todas las provincias de la tabla Provincia, Luego, utiliza la cláusula LIKE para seleccionar 
las provincias que empiezan por la letra "C" y ordena las provincias por descripción, de forma descendente (alfabeticamente)*/

SELECT 
	p.provincia AS 'Provincias que empiezan por la letra C'
FROM Provincia AS p 
WHERE p.provincia LIKE 'C%'
ORDER BY p.provincia DESC


--- 9. Haz un ranking con las tres provincias que tienen el mayor número de heridos totales 
--- (heridos hospitalizados + heridos no hospitalizados) en vías interurbanas en 2015.

/*Esta consulta hacer dos JOIN para acceder a las descripciones. Luego, filtra los accidentes que ocurrieron en 2015 y que 
se produjeron en vías interurbanas. Agrupa los accidentes por provincia, calcula el número total de heridos para cada provincia.
Ordena las provincias por el número total de heridos, de mayor a menor y devuelve las tres primeras provincias.*/

SELECT TOP (3) 
	p.provincia AS 'Provincia', 
	SUM(a.heridos_hospitalizados + a.heridos_no_hospitalizados) AS 'Heridos totales'
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
WHERE tp.tipo_via = 'Interurbana' AND a.anio = 2015
GROUP BY p.provincia
ORDER BY SUM(a.heridos_hospitalizados + a.heridos_no_hospitalizados) DESC;


--- 10. Calcula la diferencia entre 2014 y 2015 de la proporción de heridos hospitalizados y no hospitalizados 
--- de la Comunidad Autónoma de "Asturias" en vías interurbanas.

/*Esta consulta saca el porcentaje de heridos hospitalizados y no hspitalizados para cada año. Muestra en pantalla las proporciones 
para que se pueda identificar si aumentó o disminuyó respecto al año anterior. */

SELECT
    a.anio AS 'Año',
    p.provincia AS 'Provincia',
    c.ccaa AS 'Comunidad Autónoma',
    CONCAT(CAST((SUM(a.heridos_no_hospitalizados) * 100.0) / (SUM(a.heridos_hospitalizados) + SUM(a.heridos_no_hospitalizados)) AS DECIMAL(10, 2)), '%') AS 'Proporción de heridos no hospitalizados',
    CONCAT(CAST((SUM(a.heridos_hospitalizados) * 100.0) / (SUM(a.heridos_hospitalizados) + SUM(a.heridos_no_hospitalizados)) AS DECIMAL(10, 2)), '%') AS 'Proporción de heridos hospitalizados'
FROM Accidente AS a
JOIN Provincia AS p ON p.id_provincia = a.id_provincia
JOIN TipoVia AS tp ON tp.id_tipo_via = a.id_tipo_via
JOIN Comunidad AS c ON c.id_ccaa = p.id_ccaa
WHERE tp.tipo_via = 'Interurbana' AND p.provincia = 'Asturias'
GROUP BY a.anio, p.provincia, c.ccaa;

-- Otra opción de solución
/*Esta consulta muetsra en pantalla directamente la diferencia de las proporciones de heridos horpitalizados y no hospitalizados, 
donde porcentajes positivos significa que aumentaron en 2015 respecto a 2014 y porcentajes negativos, que diminuyeron*/

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
