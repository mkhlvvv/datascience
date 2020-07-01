select 
extract (year from order_date),
extract (month from order_date),
segment,
sum (sales) as "sales"
from public.orders
group by 1,2,3
order by 1,2