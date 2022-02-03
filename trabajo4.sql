-- 1 cargar base de datos 
psql -U postgres supermercado < unidad2.sql

select * from cliente;

-- 2 realizando la primera operacion de compra de 5 producto
begin transaction;

insert into compra(cliente_id, fecha)
values(1, now());
--agregando detalle de compra
insert into detalle_compra(producto_id, compra_id, cantidad)
select 9, max(id), 5 from compra;
--otra forma
insert into detalle_compra(producto_id, compra_id,cantidad)
values (9,(select id from compra order by fecha desc limit 1),5);

-- actualizando el stock de producto
update producto set stock = stock-5 where id=9;

--verificando el stock del producto 9
select id, descripcion, stock, precio from producto where id=9;

commit;

-- 3 usuario02 quiere realizar una compra
--primero consultamos si existe stock para cada producto
select  id, descripcion, stock from producto where id=1;
select  id, descripcion, stock from producto where id=2;
select  id, descripcion, stock from producto where id=8;

-- otra forma de consultar

select  id, descripcion, stock from producto where id in (1, 2, 8);

-- no es posible realizar la transaccion el producto 8 no posee stock

--Realizando las siguientes operaciones:
-- a) Deshabilitar el AUTOCOMMIT
begin trasaction;
\set AUTOCOMMIT off
-- b) Insertar un nuevo cliente
insert into cliente (nombre, email) 
values ('pepe', 'pepe@hotmail.com'); 
-- c) Confirmar que fue agregado en la tabla cliente
select * from cliente;
select id, nombre, email from cliente where nombre='pepe';
-- d) Realizar un ROLLBACK
rollback;
-- e) Confirmar que se restauró la información, sin considerar la inserción del punto b
select * from cliente;
-- f) Habilitar de nuevo el AUTOCOMMIT

\set AUTOCOMMIT ON 


