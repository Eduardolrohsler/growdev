/* BLOCO D - 1
	aqui o comando with criou uma tabela temporaria para mim fazer a subquery, com a cláusula having para comparar uma consulta com a outra
	e trazer a que tem um total gasto maior que a média
*/

with gastos_por_cliente as (
	select
		c.customer_id,
		sum(p.payment_value) as total_gasto
	from	olist_customers_dataset as c
	inner join	olist_orders_dataset as o
	on	c.customer_id = o.customer_id
	inner join	olist_order_payments_dataset as p
	on	o.order_id = p.order_id
	group by	c.customer_id
)
select
	customer_id,
	total_gasto
from	gastos_por_cliente
where	total_gasto > (select avg(total_gasto) from gastos_por_cliente)
order by total_gasto desc;

/* BLOCO D - 2
	Utilizei o where not exists com a tabela de produtos, itens de pedido e avaliação. a subconsulta busca qualquer registro onde o produto
	foi avaliado, se não retornar nenhuma linha ele é apresentado na query.
*/

select
	p.product_id,
	p.product_category_name as categoria
from	olist_products_dataset as p
where not exists (
	select 
	from	olist_order_items_dataset as i
	inner join	olist_order_reviews_dataset as r
	on	i.order_id = r.order_id
	where	i.product_id = p.product_id
);

/* BLOCO D - 3
	Usei o count distinct para contar quantas categoria unicas cada vendedor vendeu, aplicando o filtro para aparecer apenas quem vendeu
	no mínimo 5 categorias.
*/

select
    i.seller_id,
    count(distinct p.product_category_name) as total_categorias
from	olist_order_items_dataset i
inner join	olist_products_dataset p 
on	i.product_id = p.product_id
where	p.product_category_name is not null
group by	i.seller_id
having count(distinct p.product_category_name) > 5
order by	total_categorias desc;

/* BLOCO D - 4
	Aqui utilizei o having com o group by para comparar as somas, onde listava apenas os pedidos em que o frete era maior que o valor do produto.
*/

select
	order_id,
	sum(price) as total_itens,
	sum(freight_value) as total_frete
from	olist_order_items_dataset
group by	order_id
having	sum(freight_value) > sum(price)
order by	total_frete








