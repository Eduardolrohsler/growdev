/* BLOCO I - 1
	Essa consulta utiliza uma tabela temporaria para calcular o faturamento total por vendedor e estado, o partition by estado ele reinicia a 
	contagem para cada estado, o ::numeric é para evitar os bugs.
*/

with faturamento_vendedor as (
    select 
        s.seller_state as estado,
        s.seller_id,
        sum(p.payment_value::numeric) as faturamento_total
    from olist_sellers_dataset s
    join olist_order_items_dataset i on s.seller_id = i.seller_id
    join olist_orders_dataset o on i.order_id = o.order_id
    join olist_order_payments_dataset p on o.order_id = p.order_id
    where o.order_status = 'delivered'
      and p.payment_value is not null
    group by 1, 2
)
select 
    estado,
    seller_id,
    faturamento_total,
    rank() over (
        partition by estado 
        order by faturamento_total desc
    ) as posicao_ranking
from faturamento_vendedor
order by estado, posicao_ranking;

/* BLOCO I - 2
	A tabela temporaria agrupa o faturamento mensal de cada vendedor, e a função sum, over, partition by calcula o faturamento de mes a mes
	para cada vendedor.
*/

with faturamento_mensal_vendedor as (
    select 
        i.seller_id,
        to_char(o.order_purchase_timestamp::timestamp, 'yyyy-mm') as mes,
        sum(p.payment_value::numeric) as faturamento_mes
    from olist_order_items_dataset as i
    join olist_orders_dataset as o 
	on i.order_id = o.order_id
    join olist_order_payments_dataset as p 
	on o.order_id = p.order_id
    where o.order_status = 'delivered'
      and o.order_purchase_timestamp is not null
      and p.payment_value is not null
    group by 1, 2
)
select 
    seller_id,
    mes,
    faturamento_mes,
    sum(faturamento_mes) over (
        partition by seller_id 
        order by mes
    ) as faturamento_acumulado
from faturamento_mensal_vendedor
order by seller_id, mes;

/* BLOCO I - 3
	Na tabela temporaria tem a soma de cada vendedor de cada estado, na principal consulta partition by estado ele calcula o faturamento total
	do estado, a receita do vendedor é dividida pelo total de seu estado e multiuplicada por 100, o nullif previne os erros de divisão.
*/

with faturamento_vendedor as (
    select 
        s.seller_state as estado,
        s.seller_id,
        sum(p.payment_value::numeric) as faturamento_vendedor
    from olist_sellers_dataset s
    join olist_order_items_dataset i on s.seller_id = i.seller_id
    join olist_orders_dataset o on i.order_id = o.order_id
    join olist_order_payments_dataset p on o.order_id = p.order_id
    where o.order_status = 'delivered'
      and p.payment_value is not null
    group by 1, 2
)
select 
    estado,
    seller_id,
    faturamento_vendedor,
    sum(faturamento_vendedor) over (partition by estado) as faturamento_total_estado,
    round(
        (faturamento_vendedor / nullif(sum(faturamento_vendedor) over (partition by estado), 0)) * 100, 
        2
    ) as pct_participacao
from faturamento_vendedor
order by estado, pct_participacao desc;

/* BLOCO I - 4
	
*/
