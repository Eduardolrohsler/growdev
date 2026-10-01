/* BLOCO G - 1
	Aqui criei uma view para poder fazer consultas futuras sem que altere no banco de dados original. 
*/

create view vw_pedidos_completos as
select
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    c.customer_id,
    c.customer_city,
    c.customer_state,
    i.product_id,
    i.seller_id,
    s.seller_city,
    s.seller_state,
    i.price,
    i.freight_value,
    p.payment_type,
    p.payment_installments,
    p.payment_value
from olist_orders_dataset o
inner join olist_customers_dataset c
    on o.customer_id = c.customer_id
inner join olist_order_items_dataset i
    on o.order_id = i.order_id
inner join olist_order_payments_dataset p
    on o.order_id = p.order_id
inner join olist_sellers_dataset s
    on i.seller_id = s.seller_id;

	
	-- Comando para usar pra consultar a tabela view
select * from vw_pedidos_completos;


/* BLOCO G - 2
	Aqui criei uma tabela view com a nota média e volume de avaliações, podendo ser consultado com um simples comando select, sem alterar
	nenhum dado do banco de dado original
*/

create view vw_avaliacoes_categoria as
select
    p.product_category_name as categoria,
    count(distinct r.review_id) as volume_avaliacoes,
    avg(r.review_score) as nota_media
from olist_order_items_dataset i
inner join olist_products_dataset p
    on i.product_id = p.product_id
inner join olist_order_reviews_dataset r
    on i.order_id = r.order_id
where p.product_category_name is not null
group by p.product_category_name;


	-- Comando para usar pra consultar a tabela
select * from vw_avaliacoes_categoria order by nota_media asc;
