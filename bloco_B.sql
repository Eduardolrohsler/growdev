/* BLOCO B - 1
	Utilizei o 'inner join' para juntar as tabelas dos produtos e vendedores na tabela de pedidos para fazer a busca dos preços, categoia e 
	a cidade do vendedor
*/

select 
	p.product_category_name AS categoria,
	i.price AS valor_item,
	olist_sellers_dataset.seller_city AS cidade_vendedor
from	olist_order_items_dataset as i
inner join	olist_products_dataset as p
on		i.product_id = p.product_id
inner join	olist_sellers_dataset 
on		i.seller_id = olist_sellers_dataset.seller_id;

/* BLOCO B - 2
	Aqui o 'inner join' fez a junção da tabela pedidos com a tabela clientes com a condição de mostrar apenas os pedidos onde a data de entrega
	era maior que a data prevista.
*/

select 
    o.order_id,
    o.order_status,
    o.order_delivered_customer_date as data_entrega_real,
    o.order_estimated_delivery_date as data_estimada,
    c.customer_city,
    c.customer_state
from	olist_orders_dataset as o
inner join	olist_customers_dataset as c 
on	o.customer_id = c.customer_id
where	o.order_delivered_customer_date > o.order_estimated_delivery_date;

/*  BLOCO B - 3
	Aqui o 'inner join' fez a junção das tabelas de pedidos com a tabela de pagamentos, fazendo com que retorne apenas os registros com pagamentos,
	o 'select' filtrou para aparecer apenas as informações mais relevantes.
*/

select
	o.order_id,
	o.order_status,
	p.payment_type as forma_pagamento,
	p.payment_installments as parcelas,
	p.payment_value as valor_pago
from	olist_orders_dataset as o
inner join	olist_order_payments_dataset as p
on o.order_id = p.order_id;

/* BLOCO B - 4
	Com o 'left join' o select ainda apresenta todos os produtos, mesmo que não tenha uma tradução dele.
*/

select
	p.product_id,
	p.product_category_name as categoria_portugues,
	t.product_category_name_english as categoria_ingles
from	olist_products_dataset as p
left join	product_category_name_translation as t
on	p.product_category_name = t.product_category_name;

/* BLOCO B - 5
	Neste utilizei o 'inner join' para juntar as tabelas dos pedidos, clientes, vendedores e itens com a condição de aparecer na pesquisa apenas
	se o vendedor e o cliente forem do mesmo estado, o distinct serve para não duplicar os pedidos, ja que pode haver mais de um item em cada
	pedido.
*/

select distinct
	o.order_id,
	c.customer_state as estado_cliente,
	s.seller_state as estado_vendedor,
	c.customer_city as cidade_cliente,
	s.seller_city as cidade_vendedor
from	olist_orders_dataset as o
inner join	olist_customers_dataset as c
on	o.customer_id = c.customer_id
inner join	olist_order_items_dataset as i
on	o.order_id = i.order_id
inner join	olist_sellers_dataset as s
on	i.seller_id = s.seller_id
where	c.customer_state = s.seller_state