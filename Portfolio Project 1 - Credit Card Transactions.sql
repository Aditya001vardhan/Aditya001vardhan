
-- 1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends; 

with cte as (
select city,sum(amount)as total_amount
from credit_card
group by city 
order by total_amount desc
limit 5
)
select *,total_amount/(select sum(amount) from credit_card ) * 100 as precent
from cte

-- 2- write a query to print highest spend month and amount spent in that month for each card type

with cte as (
select card_type,sum(amount) as total_amount,month(transaction_date)as mo,year(transaction_date)as yo
from credit_card
group by card_type,month(transaction_date),year(transaction_date)
),
cte2 as (
select *,
dense_rank() over (partition by card_type order by total_amount desc) as rnk
from cte
)
select *
from cte2
where rnk = 1;

-- 3- write a query to print the transaction details(all columns from the table) for each card type when
	-- it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type);

with cte as (
select *,
sum(amount) over (partition by card_type order by transaction_date) as cumulative
from credit_card
),
cte2 as (
select *,
dense_rank () over(partition by card_type order by cumulative desc ) as rnk 
from cte
where cumulative >= 1000000
)
select *
from cte2 
where rnk = 1;

-- 4- write a query to find city which had lowest percentage spend for gold card type

dought

with cte as (
select city,card_type,sum(amount) as total_amount
from credit_card
where card_type = "gold"
group by city,card_type
order by total_amount 
)
select *,(total_amount/(select sum(Amount) as trans_amount from credit_card where card_type = "gold"))* 100 as percent
from cte

-- 5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)

select * from credit_card;

with cte1 as (
select city,exp_type,sum(amount) as total_amount 
 from credit_card
 group by city,exp_type
 ),
 cte2 as (
select city, max(total_amount)  as highest_expense,min(total_amount) as lowest_expense 
from cte1 
group by city
)
select c1.city,
max(case when total_amount = highest_expense then exp_type end) as highest_expense_type,
min(case when total_amount = lowest_expense then exp_type end) as lowest_expense_type
from cte1 c1
inner join cte2 c2 on c1.city= c2.city
group by c1.city
order by c1.city;

-- 6- write a query to find percentage contribution of spends by females for each expense type
dought

select * from credit_card;

with cte as (
select exp_type,sum(amount)as avg_total
from credit_card
where gender = "F"
group by exp_type
)
select *,(avg_total/(select sum(amount) from credit_card)) * 100 as percent
from cte  


-- 7- which card and expense type combination saw highest month over month growth in Jan-2014

select * from credit_card;

with cte as (
select card_type,exp_type,sum(amount) as total_amount,month(transaction_date)as mo ,year(transaction_date)as yo 
from credit_card
group by card_type,exp_type,month(transaction_date),year(transaction_date)
),
cte2 as (
select *,
lag(total_amount) over (partition by card_type,exp_type order by yo,mo) as lag_amount
from cte
)
select *,total_amount-lag_amount as growth
from cte2
where mo = 1 and yo = 2014 
order by growth desc 
limit 1;

-- 8- during weekends which city has highest total spend to total no of transcations ratio 

select * from credit_card;

select city,sum(amount) as total,count(*) as total_no_of_trans,
sum(amount) / count(*) as ratio
from credit_card
where weekday(transaction_date) in('6','0')
group by city
order by ratio desc
limit 1;
