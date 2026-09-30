/* BLOCO C - 1
	Aqui agrupei as vendas por estado utilizando o 'group by' e fiz a somatória com a função 'sum' para calcular o faturamento total,
	'order by' apenas para ficar mais arrumado.
*/

select 
    c.customer_state as estado,
	sum(i.price) as faturamento_total
from	olist_customers_dataset as c
inner join	olist_orders_dataset as o 
on	c.customer_id = o.customer_id
inner join	olist_order_items_dataset as i 
on	o.order_id = i.order_id
group by	c.customer_state
order by	faturamento_total desc;

/* BLOCO C - 2
	Fiz a junção da tabela de itens na tabela de vendedores, 'group by' para agrupar por vendedor e 'sum' para fazer o faturamento total
	'limit 10' para aparecer apenas 10 resultados.
*/

select
	i.seller_id,
	s.seller_city as cidade_vendedor,
	s.seller_state as estado_vendedor,
	sum(i.price) as faturamento_total
from	olist_order_items_dataset as i
inner join	olist_sellers_dataset as s
on	i.seller_id = s.seller_id
group by
	i.seller_id,
	s.seller_city,
	s.seller_state
order by faturamento_total desc
limit 10;

/* BLOCO C - 3
	Aqui o inner join relacionou as tabelas de produtos aos itens vendidos, calculando a quantidade, faturamento total e o ticket médio,
	group by para agrupar por categoria.
*/

select
	p.product_category_name as categoria,
	count(i.product_id) as total_itens_vendidos,
	sum(i.price) as faturamento_total,
	avg(i.price) as ticket_medio_item
from	olist_order_items_dataset as i
inner join	olist_products_dataset as p
on	i.product_id = p.product_id
where p.product_category_name is not null
group by p.product_category_name
order by ticket_medio_item desc;

/* BLOCO C - 4
	Com o inner join foi feito a junção da tabela de pedido e de avaliações, foi feito uma média utilizando o avg, having avg fez com que
	filtrasse apenas quem tinha uma média inferior a 3, com o round foi possivel deixar as notas melhores visualmente.
*/

select
    i.seller_id,
    count(distinct r.review_id) as total_avaliacoes,
    round(avg(r.review_score), 2) as nota_media
from	olist_order_items_dataset as i
inner join	olist_order_reviews_dataset as r 
    on	i.order_id = r.order_id
group by	i.seller_id
having avg	(r.review_score) < 3
order by	nota_media asc;

/* BLOCO C - 5
	Utilizando o count foi possivel contar o total de pedidos e também agrupá-los por cada forma de pagamento usando o group by.
*/

select
	p.payment_type as forma_pagamento,
	count(distinct p.order_id) as total_pedidos
from	olist_order_payments_dataset as p
where	p.payment_type is not null
group by p.payment_type
order by total_pedidos desc

/* BLOCO C - 6
	Agrupei a tabela categorias por grupos e fiz a média de peso em gramas utilizando o round/avg, que ajuda a arredondar a média e deixar melhor
	visualmente.
*/

select
	p.product_category_name as categoria,
	round(avg(p.product_weight_g), 2) as peso_medio_gramas
from olist_products_dataset as p
where p.product_category_name is not null
group by p.product_category_name
order by peso_medio_gramas desc;

/* BLOCO C - 7
	Liguei as tabelas de produtos, pedidos e pagamentos com o inner join
	com o round/avg consegui fazer a media de parcelas deixando melhor visualmente ficando separados por categoria.
*/

select
	p.product_category_name as categoria,
	round(avg(pay.payment_installments), 2) as media_parcela
from	olist_products_dataset as p
inner join	olist_order_items_dataset as i
on	p.product_id = i.product_id
inner join	olist_order_payments_dataset as pay
on	i.order_id = pay.order_id
where p.product_category_name is not null
group by p.product_category_name
order by media_parcela desc;







	
