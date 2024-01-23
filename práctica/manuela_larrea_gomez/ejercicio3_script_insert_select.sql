use Ejercicio2
go


/*==============================================================*/
/* Table: Comunidad                                             */
/*==============================================================*/

INSERT INTO dbo.Comunidad(id_ccaa, 
						  ccaa)
SELECT DISTINCT id_ccaa, ccaa 
FROM accidentes
GO

/*==============================================================*/
/* Table: Provincia                                             */
/*==============================================================*/

INSERT INTO dbo.Provincia(id_provincia, 
						  provincia, 
						  id_ccaa)
SELECT DISTINCT id_provincia, 
				provincia, 
				id_ccaa 
FROM accidentes


/*==============================================================*/
/* Table: TipoVia                                                   */
/*==============================================================*/
INSERT INTO dbo.TipoVia(id_tipo_via, 
						tipo_via)
SELECT DISTINCT id_tipo_via, 
				tipo_via 
FROM accidentes


/*==============================================================*/
/* Table: Accidente                                             */
/*==============================================================*/

INSERT INTO Accidente(anio, 
					  id_tipo_via,
					  id_provincia,
					  accidentes_con_victimas, 
					  accidentes_mortales_30_dias, 
					  fallecidos, 
					  heridos_hospitalizados, 
					  heridos_no_hospitalizados)
SELECT DISTINCT ano, 
				id_tipo_via, 
				id_provincia, 
				accidentes_con_victimas, 
				accidentes_mortales_30_dias, 
				fallecidos, 
				heridos_hospitalizados, 
				heridos_no_hospitalizados 
FROM accidentes
