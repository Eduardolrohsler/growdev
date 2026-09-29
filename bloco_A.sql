/* BLOCO A - 1
	Aqui foi feito uma pesquisa com uma ordem de buscar todos os pedidos com a condição 'Delivered', e então usei o comando de ordernar por ordem
	decrescente, para deixar os ultimos entregues como primeiros, e limitei em 20 se não iria aparecer todos os pedidos já entregues.
*/

select * from olist_orders_dataset
where	order_status = 'delivered'
order by order_delivered_customer_date DESC
limit 20

/* BLOCO A - 2
	Aqui utilizei o 'inner join' para juntar as tabelas, e fazer uma consulta buscando o mesmo nome de categoria nas duas tabelas.
*/

select *
from olist_products_dataset as p
inner join product_category_name_translation as t
on p.product_category_name = t.product_category_name
where t.product_category_name = 'cama_mesa_banho';


/* BLOCO A - 3
	Aqui utilizei o 'SELECT DISTINCT' um método de select para mostrar apenas os resultados distintos da coluna de tipos de pagamento.
*/

select distinct payment_type
from public.olist_order_payments_dataset;


/* BLOCO A - 4
	Aqui usei o 'where' para filtrar apenas os produtos com mais de 10000g(10kg), e o 'order by' para ordernar do numero mais alto(mais pesado)
	ao numero mais baixo(mais leve).
*/

select *
from olist_products_dataset
where product_weight_g > 10000
order by product_weight_g desc