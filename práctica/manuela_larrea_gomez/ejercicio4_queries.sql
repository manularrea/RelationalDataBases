use Ejercicio2
go

--- 1. �Qu� provincias y tipos de v�as tienen cero accidentes mortales a 30 d�as en 2015?

/*Esta consulta combina la informaci�n de las tablas Accidente, Provincia y TipoVia mediante dos JOIN INNER. Luego, filtra 
los resultados para que solo incluyan los accidentes que ocurrieron en 2015 y no tuvieron v�ctimas mortales en los siguientes 30 d�as.*/

SELECT 
	p.provincia AS 'Provincia', 
	tp.tipo_via AS 'Tipo de v�a'
FROM Accidente AS a
JOIN Provincia AS p ON a.id_provincia = p.id_provincia
JOIN TipoVia AS tp ON a.id_tipo_via = tp.id_tipo_via
WHERE a.anio = 2015 AND a.accidentes_mortales_30_dias = 0;


--- 2. Obt�n las provincias de �Andaluc�a� con m�s de 25 fallecidos en v�as interurbanas en 2014.

/*Esta consulta combina la informaci�n de las tablas Accidente, Provincia, TipoVia y Comunidad mediante tres JOIN INNER. 
Luego, filtra los resultados para que solo incluyan los accidentes que cumplen con los siguientes criterios:
Ocurren en Andaluc�a, ocurren en 2014, tienen m�s de 25 fallecidos y ocurren en v�as interurbanas. La consulta utiliza la
cl�usula DISTINCT para eliminar los resultados duplicados.*/

SELECT DISTINCT 
	p.provincia AS 'Provincia'
FROM Accidente AS a
JOIN Provincia AS p ON a.id_provincia = p.id_provincia
JOIN Comunidad AS c ON p.id_ccaa = c.id_ccaa
JOIN TipoVia AS tp ON a.id_tipo_via = tp.id_tipo_via
WHERE (c.ccaa = 'Andaluc�a' OR c.id_ccaa = 1)
AND a.anio = 2014
AND a.fallecidos > 25
AND (tp.tipo_via = 'Interurbana' OR tp.id_tipo_via = 'A');


--- 3. �Cu�l es la Comunidad Aut�noma con m�s accidentes con v�ctimas en 2015?

/*La consulta utiliza dos JOIN para combinar la informaci�n de las tablas Accidente, Provincia y Comunidad.
Filtra los accidentes que ocurrieron en 2015, agrupa los accidentes por comunidad aut�noma, cuenta el n�mero 
de accidentes con v�ctimas para cada comunidad aut�noma Y devuelve la comunidad aut�noma con el mayor n�mero de accidentes con v�ctimas.
Se ordenan de forma descendente y se limita la salida a 1 registro (el primero)*/

SELECT TOP(1) 
	c.ccaa  AS 'Comunidad Aut�noma' FROM Accidente AS a 
JOIN Provincia AS p ON a.id_provincia = p.id_provincia
JOIN Comunidad AS c ON p.id_ccaa = c.id_ccaa
WHERE a.anio = 2015
GROUP BY c.ccaa
HAVING COUNT(a.accidentes_con_victimas) > 0 
ORDER BY COUNT(a.accidentes_con_victimas) DESC;

--- 4. �Cu�l es el n�mero medio de heridos no hospitalizados por a�o? Redondea el resultado sin decimales

/*La consulta agrupa los accidentes por a�o y luego calcula el promedio del n�mero de heridos no hospitalizados para cada a�o.
La consulta utiliza la cl�usula ROUND() para redondear el resultado a cero decimales.*/

SELECT 
	a.anio AS 'A�o', 
	ROUND(AVG(a.heridos_no_hospitalizados), 0) AS 'Promedio de heridos no hospitalizados' 
FROM Accidente AS a
GROUP BY (a.anio);


--- 5. �Cu�l es la combinaci�n de a�o, provincia y tipo de v�a con m�s heridos hospitalizados?

/*La consulta hacer dos JOIN para acceder al nombre de la provincia y la descripcion de tipo de via. 
Luego ordena los accidentes por el n�mero de heridos hospitalizados, de mayor a menor. Y devuelve la primera fila de
resultados, que corresponde a la combinaci�n de a�o, provincia y tipo de v�a con m�s heridos hospitalizados.*/

SELECT TOP(1) 
	a.anio AS 'A�o', 
	p.provincia AS 'Provincia', 
	tp.tipo_via AS 'Tipo de v�a'
FROM Accidente AS a
JOIN TipoVia AS tp ON tp.id_tipo_via = a.id_tipo_via
JOIN Provincia AS p ON p.id_provincia = a.id_provincia
ORDER BY a.heridos_hospitalizados DESC;

--- 6. �Qu� Comunidades Aut�nomas tienen m�s de 200 fallecidos en 2015?

/*Esta consulta usa dos JOIN para acceder a las descripciones. Luego, filtra los accidentes que ocurrieron en 2015. 
Agrupa los accidentes por comunidad aut�noma. Suma el n�mero de fallecidos para cada comunidad aut�noma y devuelve las comunidades 
aut�nomas con m�s de 200 fallecidos.
La consulta utiliza la cl�usula HAVING para filtrar los resultados y solo incluir las comunidades aut�nomas con m�s de 200 fallecidos*/

SELECT 
	c.ccaa AS 'Comunidad Aut�noma' 
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN Comunidad as c ON p.id_ccaa = c.id_ccaa
WHERE a.anio = 2015 
GROUP BY c.ccaa
HAVING SUM(a.fallecidos) > 200;

--- 7. �Cu�l es la provincia que "peor conduce en v�as urbanas" (en n�mero de accidentes con v�ctimas) en 2015?
--- �Y en v�as interurbanas?

/*Esta consulta usa dos JOIN para acceder a las descripciones. Luego, filtra los accidentes que ocurrieron en 2015 y que 
se produjeron en v�as urbanas. Luego, agrupa los accidentes por provincia, cuenta el n�mero de accidentes con v�ctimas para cada provincia
y devuelve la provincia con el mayor n�mero de accidentes con v�ctimas.
La consulta utiliza la cl�usula TOP(1) para limitar el resultado a una sola provincia, la que tiene m�s accidentes con 
v�ctimas en v�as urbanas en 2015.*/

SELECT TOP (1) 
	p.provincia AS 'Provincia que peor conduce en v�as Urbanas', 
	SUM(a.accidentes_con_victimas) AS 'N�mero de accidenetes con v�ctimas'
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
WHERE tp.tipo_via = 'Urbana' AND a.anio = 2015
GROUP BY p.provincia
ORDER BY SUM(a.accidentes_con_victimas) DESC;

/*La consulta es similar a la anterior, pero filtra los accidentes que se produjeron en v�as interurbanas.*/

SELECT TOP (1)
	p.provincia AS 'Provincia que peor conduce en v�as Interurbanas', 
	SUM(a.accidentes_con_victimas) AS 'N�mero de accidenetes con v�ctimas'
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
WHERE tp.tipo_via = 'Interurbana' AND a.anio = 2015
GROUP BY p.provincia
ORDER BY SUM(a.accidentes_con_victimas) DESC;


--- 8. Obt�n un listado de las provincia que empiezan por la letra �C� y ordena las descripciones de forma descendente.

/*La consulta Selecciona todas las provincias de la tabla Provincia, Luego, utiliza la cl�usula LIKE para seleccionar 
las provincias que empiezan por la letra "C" y ordena las provincias por descripci�n, de forma descendente (alfabeticamente)*/

SELECT 
	p.provincia AS 'Provincias que empiezan por la letra C'
FROM Provincia AS p 
WHERE p.provincia LIKE 'C%'
ORDER BY p.provincia DESC


--- 9. Haz un ranking con las tres provincias que tienen el mayor n�mero de heridos totales 
--- (heridos hospitalizados + heridos no hospitalizados) en v�as interurbanas en 2015.

/*Esta consulta hacer dos JOIN para acceder a las descripciones. Luego, filtra los accidentes que ocurrieron en 2015 y que 
se produjeron en v�as interurbanas. Agrupa los accidentes por provincia, calcula el n�mero total de heridos para cada provincia.
Ordena las provincias por el n�mero total de heridos, de mayor a menor y devuelve las tres primeras provincias.*/

SELECT TOP (3) 
	p.provincia AS 'Provincia', 
	SUM(a.heridos_hospitalizados + a.heridos_no_hospitalizados) AS 'Heridos totales'
FROM Accidente AS a
JOIN Provincia as p ON p.id_provincia = a.id_provincia
JOIN TipoVia as tp ON tp.id_tipo_via = a.id_tipo_via
WHERE tp.tipo_via = 'Interurbana' AND a.anio = 2015
GROUP BY p.provincia
ORDER BY SUM(a.heridos_hospitalizados + a.heridos_no_hospitalizados) DESC;


--- 10. Calcula la diferencia entre 2014 y 2015 de la proporci�n de heridos hospitalizados y no hospitalizados 
--- de la Comunidad Aut�noma de "Asturias" en v�as interurbanas.

/*Esta consulta saca el porcentaje de heridos hospitalizados y no hspitalizados para cada a�o. Muestra en pantalla las proporciones 
para que se pueda identificar si aument� o disminuy� respecto al a�o anterior. */

SELECT
    a.anio AS 'A�o',
    p.provincia AS 'Provincia',
    c.ccaa AS 'Comunidad Aut�noma',
    CONCAT(CAST((SUM(a.heridos_no_hospitalizados) * 100.0) / (SUM(a.heridos_hospitalizados) + SUM(a.heridos_no_hospitalizados)) AS DECIMAL(10, 2)), '%') AS 'Proporci�n de heridos no hospitalizados',
    CONCAT(CAST((SUM(a.heridos_hospitalizados) * 100.0) / (SUM(a.heridos_hospitalizados) + SUM(a.heridos_no_hospitalizados)) AS DECIMAL(10, 2)), '%') AS 'Proporci�n de heridos hospitalizados'
FROM Accidente AS a
JOIN Provincia AS p ON p.id_provincia = a.id_provincia
JOIN TipoVia AS tp ON tp.id_tipo_via = a.id_tipo_via
JOIN Comunidad AS c ON c.id_ccaa = p.id_ccaa
WHERE tp.tipo_via = 'Interurbana' AND p.provincia = 'Asturias'
GROUP BY a.anio, p.provincia, c.ccaa;

-- Otra opci�n de soluci�n
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
