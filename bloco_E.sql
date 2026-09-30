/* BLOCO E - 1
	Defini as regras utilizando o case, when, else e end. e fiz a comparação das datas para saber se a entrega foi no prazo, adiantada ou atrasada.
	o where foi para retornar apenas os pedidos já entregues e nao dar nenhum conflito com os pedidos que ainda não foram.
*/

select
	order_id,
	order_delivered_customer_date as data_entrega_real,
	order_estimated_delivery_date as data_estimada,
case
		when	order_delivered_customer_date < order_estimated_delivery_date then 'Adiantado'
		when	order_delivered_customer_date = order_estimated_delivery_date then 'No prazo'
		else	'Atrasado'
	end as	status_prazo
from	olist_orders_dataset
where	order_status = 'delivered'
and	order_delivered_customer_date is not null 
and order_estimated_delivery_date is not null; 

/* BLOCO E - 2
	utilizei o case when para categorizar os clientes em ouro, prata e bronze com o total gasto por eles. 
*/

select
	o.customer_id,
	sum(p.payment_value) as total_gasto,
case
		when	sum(p.payment_value) >= 4000 then 'Ouro'
		when	sum(p.payment_value) >= 2000 then 'Prata'
		else 'Bronze'
	end as faixa_cliente
from 	olist_orders_dataset as o
join	olist_order_payments_dataset as p
on	o.order_id = p.order_id
where	p.payment_value is not null
group by	o.customer_id
order by	total_gasto desc;

/* BLOCO E - 3
	Aqui o case when foi pra classificar os produtos por peso, o where para retornar apenas os produtos onde a coluna de peso não está vazia.
*/

select
	product_id,
	product_category_name as categoria,
	product_weight_g as peso_gramas,
case
	when	product_weight_g < 20000 then 'Leve'
	when	product_weight_g < 30000 then 'Médio'
	else	'Pesado'
	end as faixa_peso
from	olist_products_dataset
where	product_weight_g is not null
order by	peso_gramas desc;

/* BLOCO E - 4
	Case when na coluna de payment_installments para classificar em pagamento à vista, parcelado e o parcelado longo
*/

select
	order_id,
	payment_type,
	payment_installments as parcelas,
	payment_value as valor,
case
	when	payment_installments = 1 then 'À vista'
	when	payment_installments > 6 then 'Parcelado longo'
	else 'Parcelado'
	end as tipo_parcelamento
from	olist_order_payments_dataset
where	payment_installments is not null



	


	
