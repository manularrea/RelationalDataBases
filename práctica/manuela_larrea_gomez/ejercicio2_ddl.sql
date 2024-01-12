create database Ejercicio2
go

use Ejercicio2
go

/*==============================================================*/
/* Table: Comunidad                                             */
/*==============================================================*/
create table Comunidad (
   id_ccaa              int                  identity,
   ccaa                 nvarchar(40)         not null,
   constraint PK_COMUNIDAD primary key (id_ccaa)
)
go


/*==============================================================*/
/* Table: "Provincia"                                           */
/*==============================================================*/
create table Provincia (
   id_provincia         int                  identity,
   provincia            nvarchar(40)         not null,
   id_ccaa              int                  not null,
   constraint PK_PROVINCIA primary key (id_provincia)
)
go

/*==============================================================*/
/* Junction Table: ProvinciaVia                                 */
/*==============================================================*/
create table ProvinciaVia (
   id                   int                  identity,
   id_provincia         int                  not null, 
   id_via               int                  not null, 
   constraint PK_PROVINCIAVIA primary key (id)
)
go

/*==============================================================*/
/* Index: ProvinciaVia                              */
/*==============================================================*/
create index IndexProvinciaVia on ProvinciaVia(
id ASC
)
go

/*==============================================================*/
/* Table: Via                                                   */
/*==============================================================*/
create table Via (
   id                   int                  identity,
   id_tipo_via          nvarchar(1)          not null,
   tipo_via             nvarchar(40)         not null,
   constraint PK_VIA primary key (id)
)
go

/*==============================================================*/
/* Index: IndexViaId                                            */
/*==============================================================*/
create index IndexViaid on Via (
id ASC
)
go

/*==============================================================*/
/* Table: Accidente                                             */
/*==============================================================*/
create table Accidente (
   id                             int            identity,
   id_via                         int            not null,
   accidentes_con_victimas        int            not null,
   accidentes_mortales_30_dias    int            not null,
   anio                           int            not null, 
   fallecidos                     int            not null,
   heridos_hospitalizados         int            not null,
   heridos_no_hospitalizados      int            not null,
   constraint PK_ACCIDENTE primary key (id)
)
go

/*==============================================================*/
/* Index: IndexAccidenteId                                      */
/*==============================================================*/
create index IndexVAccidenteid on Accidente (
id ASC
)
go

alter table Provincia
   add constraint FK_PROVINCIA_REFERENCE_COMUNIDAD foreign key (id_ccaa)
      references Comunidad (id_ccaa)
go

alter table Accidente
   add constraint FK_ACCIDENTE_REFERENCE_VIA foreign key (id_via)
      references Via (id)
go

alter table ProvinciaVia
   add constraint FK_PROVINCIAVIA_REFERENCE_PROVINCIA foreign key (id_provincia)
      references Provincia (id_provincia)
go

alter table ProvinciaVia
   add constraint FK_PROVINCIAVIA_REFERENCE_VIA foreign key (id_via)
      references Via (id)
go