use data_base;
drop table categorias;
#---------------------CREAR TABLAS -----------------------------
create table CATEGORIAS 
(
   Id_Categoria			int     primary key          not null,
   Nombre_Categoria 	varchar(20)                  not null,
   Descripcion			varchar(65)                  not null
);
describe categorias;



create table PRODUCTOS 
(
   Id_Producto			    int		 not null,
   Nombre_Producto  	    varchar(50)     not null,
   Id_Categoria			    int	            not null,
   Fecha_Vencimiento		Date,
   Cantidad_por_Unidad		varchar(25)		not null,
   Precio_por_Unidad		decimal(5,2)    not null,
   Unidades_en_Existencia	int	            not null,
   Unidades_Pedidas		    int             not null,
   Nivel_de_Nuevo_Pedido 	int             not null,
   Suspendido 			    varchar(1)		not null
);


show tables;
drop table lugares;
create table LUGARES (
   ID_LUGAR             int            not null,
   LUG_ID_LUGAR         int,
   NOMBRE_LUGAR         VARCHAR(26),
   TIPO_LUGAR           VARCHAR(26)  );

create table CLIENTES 
(
   Id_Cliente			int			    not null,
   Codigo_Cliente  	     varchar(10)    not null,
   Nombre_Compañía		varchar(50)		not null,
   Direccion			varchar(50)		not null,
   Id_Lugar			    int             not null,
   Codigo_postal		varchar(15),
   Telefono			    varchar(20)		not null,
   Fax				    varchar(20)
);

CREATE TABLE EMPLOYEES 
(
  EMPLOYEE_ID                   dec(6, 0)    NOT NULL, 
  FIRST_NAME                    VARCHAR(20) NOT NULL, 
  LAST_NAME                     VARCHAR(25) NOT NULL, 
  EMAIL                         VARCHAR(25) NOT NULL, 
  PHONE_NUMBER                  VARCHAR(20), 
  HIRE_DATE                     DATE         NOT NULL, 
  JOB_ID                        VARCHAR(10) NOT NULL, 
  SALARY                        decimal(8, 2), 
  COMMISSION_PCT                decimal(2, 2), 
  MANAGER_ID                    decimal(6, 0), 
  DEPARTMENT_ID                 decimal(4, 0), 
  ID_LUGAR_NACE                 decimal(5, 0), 
  ID_LUGAR_VIVE                 decimal(5, 0), 
  ID_LUGAR_TRABAJA              decimal(5, 0) 
) ;

create table PEDIDOS
(
   Id_Pedido		int		   not null,
   Id_Cliente  	    int		   not null,
   EMPLOYEE_ID		int		   not null,
   Fecha_Pedido		Date       not null,
   Fecha_Entrega	Date       not null,
   Fecha_Envio		Date,	
   Valor_Envio		dec(6,2)   not null,
   Id_Destinatario	int		   not null,
   Forma_Pago		varchar(1) not null
);

create table DETALLES_PEDIDOS
(
   Id_pedido		int                 not null,
   Id_Producto		int                 not null,
   Precio_Unidad	dec(5,2)		    not null,
   Cantidad		    int			        not null,
   Descuento 		dec(2,2)		    not null
);

create table DEPARTAMENTOS 
(DEPARTMENT_ID   INT not null,
DEPARTMENT_NAME  varchar(20) not null,
MANAGER_ID  int not null);


#//---------------AGREGAR RESTRICCIONES ----.--------------
ALTER TABLE Productos  
ADD CONSTRAINT  productos_PK_Id_producto primary key (Id_producto);
ALTER TABLE categorias  
ADD CONSTRAINT  categorias_PK_Id_categoria primary key (Id_categoria);


ALTER TABLE Productos
ADD CONSTRAINT  prod_Fk_cat_Id_categoria foreign key (Id_categoria) REFERENCES CATEGORIAS (Id_Categoria);

ALTER TABLE Productos 
ADD CONSTRAINT producto_ck_suspendido check (Suspendido IN ('N','S'));

#//------------------------------
ALTER TABLE LUGARES
  ADD CONSTRAINT PK_LUGARES PRIMARY KEY (ID_LUGAR);
ALTER TABLE LUGARES
  ADD CONSTRAINT CKC_TIPO_LUGAR_LUGARES CHECK (TIPO_LUGAR IS NULL OR TIPO_LUGAR IN ('P','C'));
#//-----------------------------------------------------------------------------------------
ALTER TABLE CLIENTES
  ADD CONSTRAINT CLIENTES_PK_Id_Cliente PRIMARY KEY (Id_Cliente); 
ALTER TABLE CLIENTES
 ADD constraint CLIENTES_FK_LUG_Id_lugar foreign key (ID_LUGAR) references LUGARES(ID_LUGAR);
#//------------------------------------------------------------------------------------------
ALTER TABLE DEPARTAMENTOS
 ADD constraint PK_DEPART PRIMARY KEY (DEPARTMENT_ID);
#//-----------------------------------------------------------------------------------------

ALTER TABLE employees MODIFY COLUMN DEPARTMENT_ID INT NOT NULL;
ALTER TABLE employees MODIFY COLUMN ID_LUGAR_NACE INT NOT NULL;
ALTER TABLE employees MODIFY COLUMN ID_LUGAR_VIVE INT NOT NULL;
ALTER TABLE employees MODIFY COLUMN ID_LUGAR_TRABAJA INT NOT NULL;
ALTER TABLE employees MODIFY COLUMN EMPLOYEE_ID int not null;

ALTER TABLE employees ADD
 constraint PK_EMPLOYEE primary key (EMPLOYEE_ID);
ALTER TABLE employees ADD
 constraint EMP_DEPT_FK foreign key(DEPARTMENT_ID ) references DEPARTAMENTOS (DEPARTMENT_ID );
ALTER TABLE employees ADD
 constraint EMP_FK_LUG_ID_LUGAR_NACE foreign key (ID_LUGAR_NACE) references lugares(ID_LUGAR);
ALTER TABLE employees ADD
 constraint EMP_FK_LUG_ID_LUGAR_TRABAJA foreign key (ID_LUGAR_TRABAJA) references lugares(ID_LUGAR);
ALTER TABLE employees ADD 
 constraint EMP_FK_LUG_ID_LUGAR_VIVE  foreign key (ID_LUGAR_VIVE) references lugares (ID_LUGAR);
ALTER TABLE employees ADD 
 constraint EMP_MANAGER_FK foreign key (MANAGER_ID) references EMPLOYEES (EMPLOYEE_ID);
 ALTER TABLE employees ADD 
 constraint EMP_SALARY_MIN CHECK (salary > 0);
 
#----------------------------------------------------------------------------------------------

ALTER TABLE PEDIDOS ADD(
constraint PEDIDOS_PK_Id_Pedido PRIMARY KEY (Id_Pedido),
constraint PED_FK_CLI_Id_Cliente FOREIGN KEY (Id_Cliente) REFERENCES CLIENTES (Id_Cliente),
constraint PED_FK_EMP_Id_emp FOREIGN KEY (employee_id) REFERENCES EMPLOYEES (employee_id),
constraint PEDIDOS_CK_Forma_Pago CHECK (Forma_Pago IN ('E','C')));

#-----------------------------------------------------------------
ALTER TABLE detalles_pedidos ADD(
CONSTRAINT DET_PED_PK_Id_ped_Id_Prod PRIMARY KEY (Id_pedido, Id_Producto),
CONSTRAINT DET_PED_FK_pedidos_Id_pedido FOREIGN KEY (Id_pedido) REFERENCES PEDIDOS (Id_pedido),
CONSTRAINT DET_PED_FK_pedidos_Id_Producto FOREIGN KEY (Id_Producto) REFERENCES PRODUCTOS (Id_Producto));

#--------POBLAR BASE DE DATOS ------------------------------------------------

select *from data_base.categorias;
select *from data_base.departamentos;
ALTER TABLE departamentos MODIFY MANAGER_ID INT NULL;
ALTER TABLE lugares CHANGE LUG_ID_LUGAR ID_LUGAR_PADRE INT;
ALTER TABLE CLIENTES ADD COLUMN ID_CONTACTO int;

###ARCHIVO_EMPLOOYES#####

select *from data_base.employees;
DESC EMPLOYEES;

ALTER TABLE employees MODIFY  HIRE_DATE VARCHAR(20);
ALTER TABLE employees MODIFY  COMMISSION_PCT VARCHAR(5);


#BORRAR CONSTRAINT
alter table employees drop constraint EMP_MANAGER_FK;
 alter table employees drop constraint                   EMP_FK_LUG_ID_LUGAR_VIVE;
 alter table employees drop constraint				  EMP_FK_LUG_ID_LUGAR_TRABAJA;
alter table employees drop constraint              EMP_FK_LUG_ID_LUGAR_NACE;
ALTER TABLE employees MODIFY DEPARTMENT_ID INT NULL;


-- 1) Normaliza el texto a 'YYYY-MM-DD' dentro de la misma columna VARCHAR
UPDATE employees
SET HIRE_DATE = DATE_FORMAT(
  STR_TO_DATE(REGEXP_REPLACE(TRIM(HIRE_DATE), '[^0-9/]', ''), '%d/%m/%Y'),
  '%Y-%m-%d'
)
WHERE HIRE_DATE IS NOT NULL AND HIRE_DATE <> '';

ALTER TABLE employees MODIFY HIRE_DATE DATE;

## HACER EL CAMBIO DE COMA A PUNTO
UPDATE data_base.employees
SET COMMISSION_PCT = NULLIF(REPLACE(TRIM(COMMISSION_PCT), ',', '.'), '');
ALTER TABLE employees MODIFY COMMISSION_PCT decimal(4,2);


###PRODUCTOS

ALTER TABLE productos ADD COLUMN ID_PROVEDOR int;
ALTER TABLE productos MODIFY Fecha_Vencimiento  VARCHAR(20) null;
ALTER TABLE productos MODIFY  Precio_por_Unidad VARCHAR(5);

UPDATE productos
SET Fecha_vencimiento = DATE_FORMAT(
  STR_TO_DATE(REGEXP_REPLACE(TRIM(Fecha_vencimiento), '[^0-9/]', ''), '%d/%m/%Y'),
  '%Y-%m-%d'
)
WHERE Fecha_vencimiento IS NOT NULL AND Fecha_vencimiento <> '';
ALTER TABLE productos MODIFY Fecha_Vencimiento DATE;

## HACER EL CAMBIO DE COMO A PUNTO
UPDATE data_base.productos
SET precio_por_unidad = NULLIF(REPLACE(TRIM(precio_por_unidad), ',', '.'), '');
ALTER TABLE  data_base.productos MODIFY precio_por_unidad decimal(5,2);


###pedidos
ALTER TABLE pedidos MODIFY  Fecha_pedido VARCHAR(20) null;
ALTER TABLE pedidos MODIFY  Fecha_Entrega VARCHAR(20) null;
ALTER TABLE pedidos MODIFY  Fecha_Envio VARCHAR(20)null;
ALTER TABLE pedidos MODIFY  Valor_Envio VARCHAR(20);

UPDATE pedidos
SET Fecha_pedido = DATE_FORMAT(
  STR_TO_DATE(REGEXP_REPLACE(TRIM(Fecha_pedido), '[^0-9/]', ''), '%d/%m/%Y'),
  '%Y-%m-%d'
)
WHERE Fecha_pedido IS NOT NULL AND Fecha_pedido<> '';

UPDATE pedidos
SET Fecha_Entrega = DATE_FORMAT(
  STR_TO_DATE(REGEXP_REPLACE(TRIM(Fecha_Entrega), '[^0-9/]', ''), '%d/%m/%Y'),
  '%Y-%m-%d'
)
WHERE Fecha_Entrega IS NOT NULL AND Fecha_Entrega<> '';

UPDATE pedidos
SET Fecha_Envio = DATE_FORMAT(
  STR_TO_DATE(REGEXP_REPLACE(TRIM(Fecha_Envio), '[^0-9/]', ''), '%d/%m/%Y'),
  '%Y-%m-%d'
)
WHERE Fecha_Envio IS NOT NULL AND Fecha_Envio<> '';    
SELECT * FROM data_base.pedidos;

ALTER TABLE pedidos modify Fecha_Pedido DATE;
ALTER TABLE pedidos modify Fecha_Entrega DATE;
ALTER TABLE pedidos modify Fecha_Envio DATE;

## HACER EL CAMBIO DE COMO A PUNTO
UPDATE data_base.pedidos
SET valor_envio = NULLIF(REPLACE(TRIM(valor_envio), ',', '.'), '');
ALTER TABLE  data_base.pedidos MODIFY valor_envio decimal(7,2);


## detalle pedidos

ALTER TABLE detalles_pedidos MODIFY Precio_Unidad VARCHAR(5);
ALTER TABLE detalles_pedidos MODIFY DESCUENTO VARCHAR(5);
UPDATE data_base.detalles_pedidos
SET Precio_unidad = NULLIF(REPLACE(TRIM( Precio_unidad), ',', '.'), '');
ALTER TABLE  data_base.detalles_pedidos MODIFY  Precio_unidad decimal(10,2);

UPDATE data_base.detalles_pedidos
SET descuento = NULLIF(REPLACE(TRIM(descuento), ',', '.'), '');
ALTER TABLE  data_base.detalles_pedidos MODIFY descuento decimal(5,2);

select *from data_base.employees;
update productos set Fecha_Vencimiento = NULL
 WHERE id_producto= 26;

update productos set Fecha_Vencimiento = NULL
 WHERE id_producto= 75;

## pruebas
describe categorias;
describe lugares;
describe employees;
describe clientes;
describe detalles_pedidos;
describe pedidos;
describe departamentos;
describe productos;

SELECT
  CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'data_base'
  AND TABLE_NAME  = 'detalles_pedidos';
  
  #cantiodad total de empleados
  create view vista_total_empleados as
  select count(*) as total_empleados
  from employees;
  
  
  
  #empleados sin departamento
CREATE VIEW vista_empleados_sin_departamento AS
SELECT COUNT(*) AS empleados_sin_departamento
FROM employees
WHERE DEPARTMENT_ID IS NULL;



SELECT COUNT(*) AS empleados_apellido_m
FROM employees
WHERE last_name LIKE 'M%';

SELECT COUNT(*) AS empleados_sin_comision
FROM employees
WHERE commission_pct IS NULL OR commission_pct = 0;


SELECT fecha_pedido, COUNT(*) AS cantidad_pedidos
FROM pedidos
GROUP BY fecha_pedido
ORDER BY fecha_pedido;



select Nombre_Producto, Nombre_Categoria
 from productos, categorias
 where productos.id_categoria = categorias.id_categoria;



select nombre_categoria, count(*) as cantidad
from productos as p, categorias as c
where p.Id_Categoria= c.id_categoria
GROUP BY 1;


select count(*) from detalles_pedidos;
select * from detalles_pedidos;

#consultas
#1.Cantidad de productos por categorías.
SELECT                      
  c.Id_Categoria,                       
  c.Nombre_Categoria,                   
  COUNT(p.Id_Producto) AS total_productos
FROM categorias as c
JOIN productos as p
  ON p.Id_Categoria = c.Id_Categoria     #clave=clave
GROUP BY c.Id_Categoria, c.Nombre_Categoria
ORDER BY total_productos DESC;


#2. Porcentaje de pedidos por forma de pago


SELECT
case
    WHEN p.Forma_Pago IN ('E') THEN 'Efectivo'
    WHEN p.Forma_Pago IN ('C') THEN 'Crédito'
    ELSE 'Otro'
  END AS forma_pago,
  COUNT(*) AS pedidos,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS porcentaje
FROM pedidos AS p
GROUP BY forma_pago
ORDER BY porcentaje DESC;



#3. cantidad de pedidos por fecha año

SELECT 
    YEAR(fecha_pedido) AS año_del_pedido, 
    COUNT(Id_pedido) AS total_pedidos
FROM pedidos
GROUP BY YEAR(fecha_pedido);

# 4.  Cantidad de pedidos atendidos por los empleados. 
SELECT 
    em.employee_id,
    em. FIRST_NAME,
    COUNT(p.Id_pedido) AS total_pedidos
FROM
    pedidos AS p
right join  employees as em
  ON p.EMPLOYEE_ID = em.EMPLOYEE_ID    #clave=clave
GROUP BY p.EMPLOYEE_ID, em.FIRST_NAME;

#5. Cantidad de empleados por departamento

select  
  DEPARTMENT_ID as departamento,
  count(employee_id) as cantidad_empleados
 from employees as em
 group by em. DEPARTMENT_ID;
#### ahora ponemos el nomre del departamento, entonces tenemos que unir la de empleados y departamentos

select  
  d.DEPARTMENT_ID,
  d.DEPARTMENT_NAME,
  count(employee_id) as cantidad_empleados
 from employees as em
right join  departamentos as d
  ON d.DEPARTMENT_ID = em.DEPARTMENT_ID    #clave=clave
GROUP BY  d.DEPARTMENT_name
ORDER BY cantidad_empleados desc;

#6. Nombre del producto más vendido.

select
  Id_Producto as productoss,
  sum(Cantidad) as cantidad_total
  from detalles_pedidos as dp
 group by dp.Id_Producto;
 
 ####
 select
  p.nombre_producto,
  dp.Id_Producto,
  sum(Cantidad) as cantidad_total
  from detalles_pedidos as dp
  join  productos as p
   ON p.Id_Producto= dp.Id_Producto    
GROUP BY   dp.Id_Producto
ORDER BY cantidad_total DESC
LIMIT 1;

# 5 productos mas vendidos 
 select
  p.nombre_producto,
  dp.Id_Producto,
  sum(Cantidad) as cantidad_total
  from detalles_pedidos as dp
  join  productos as p
   ON p.Id_Producto= dp.Id_Producto    #clave=clave
GROUP BY   dp.Id_Producto
ORDER BY cantidad_total DESC
LIMIT 5;


#Nombre del producto más solicitado.
SELECT 
  p.Nombre_Producto AS producto,
  COUNT(dp.Id_Producto) AS cantidad_pedidos
FROM detalles_pedidos AS dp
JOIN productos AS p 
  ON dp.Id_Producto = p.Id_Producto
GROUP BY p.Id_Producto, p.Nombre_Producto
ORDER BY cantidad_pedidos DESC
LIMIT 1;

# Top de los cinco productos más solicitados.
SELECT 
  p.Nombre_Producto AS producto,
  COUNT(dp.Id_Producto) AS cantidad_pedidos
FROM detalles_pedidos AS dp
JOIN productos AS p 
  ON dp.Id_Producto = p.Id_Producto
GROUP BY p.Id_Producto, p.Nombre_Producto
ORDER BY cantidad_pedidos DESC
LIMIT 5;

#8. Top de los cinco mejores clientes.

SELECT 
  c.Id_Cliente, Codigo_Cliente,
  c.Nombre_Compañía AS cliente,
  ROUND(
    SUM(dp.Cantidad * dp.Precio_Unidad * (1 - dp.Descuento)),2) AS total_comprado
FROM pedidos AS p
JOIN clientes AS c
  ON p.Id_Cliente = c.Id_Cliente
JOIN detalles_pedidos AS dp
  ON dp.Id_Pedido = p.Id_Pedido
GROUP BY c.Id_Cliente, c.Nombre_Compañía
ORDER BY total_comprado DESC
LIMIT 5;



#10. Cantidad de empleados cuyo lugar de residencia y detrabajo coincide con su lugar de nacimiento.
select  count(*) as empleados_coinciden
from employees
where id_lugar_nace = ID_LUGAR_TRABAJA
 and  ID_LUGAR_VIVE= ID_LUGAR_TRABAJA;

#11. cantidad de productos por mes

SELECT 
    month(fecha_pedido) AS mes_del_pedido, 
    COUNT(Id_pedido) AS total_pedidos
FROM pedidos
GROUP BY month(fecha_pedido)
order by mes_del_pedido;

#Top cinco de los empleados con los salarios más altos en la compañía.

select 
 employee_id,FIRST_NAME,salary
 from employees
 order by salary desc
 limit 5;

#14. Valor de la nómina de la compañía.

select sum(
  CASE 
     WHEN COMMISSION_PCT IS NULL then salary
     ELSE salary + salary * COMMISSION_PCT
  END) AS Nomina_compañia
 from employees;
 
 
##15. Valor de la nómina por departamento.

select  em.DEPARTMENT_ID, DEPARTMENT_NAME, sum(
  CASE 
     WHEN COMMISSION_PCT IS NULL then salary
     ELSE salary + salary * COMMISSION_PCT
  END )AS Nomina_compañia
from employees as em
join departamentos as d
on em.DEPARTMENT_ID = d.DEPARTMENT_ID
group by DEPARTMENT_ID;



##16. Porcentaje de comisión por empleado.

select employee_id, first_name,
 case 
   when COMMISSION_PCT is null then 0
   else COMMISSION_PCT*100
end as porcentaje
from employees

# Mostrar el nombre y apellido de los empleados, junto con el nombre del lugar correspondiente, para aquellos casos en
#que el lugar de residencia, de trabajo y de nacimiento del
#empleado sea el mismo.
;
select  FIRST_NAME, LAST_NAME, ID_LUGAR_NACE 
from employees
where id_lugar_nace = ID_LUGAR_TRABAJA
 and  ID_LUGAR_VIVE= ID_LUGAR_TRABAJA;
#####
SELECT em.FIRST_NAME,
       em.LAST_NAME,
       em.ID_LUGAR_NACE,
       lug.NOMBRE_LUGAR AS Lugar_comun
FROM employees AS em
JOIN lugares AS lug
  ON em.ID_LUGAR_NACE = lug.ID_LUGAR
WHERE em.ID_LUGAR_NACE = em.ID_LUGAR_TRABAJA
  AND em.ID_LUGAR_VIVE = em.ID_LUGAR_TRABAJA;




