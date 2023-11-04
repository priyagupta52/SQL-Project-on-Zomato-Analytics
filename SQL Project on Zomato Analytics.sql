
------------------CREATING ZOMATO TABLE SCRIPT----------------------

select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;



---(Q1) what is total amount each customer spent on zomato ?---


select a.userid, sum(b.price) as total_amt_spent
from sales a inner join product b
on a.product_id = b.product_id
group by a.userid






---(Q2) How many days has each customer visited zomato?---
Select userid, count(distinct created_at ) as distinct_days
from sales
group by userid;






---(Q3) what was the first product purchased by each customers---
select * from
(select *, rank() over (partition by userid order by created_at) rnk from sales) a where rnk =1








---(Q4) what is the most purchased item on the menu and  how many times was it purchased by all the customers ---
select userid, count(product_id) cnt from sales where product_id =
(select top 1 product_id from sales 
group by product_id 
order by count(product_id) desc)
group by userid





---(Q5)  which item was most popular for each customer?---
select * from
(select*, rank() over(partition by userid order by cnt desc) rnk from 
(select userid, product_id, count(product_id) cnt from sales 
group by userid, product_id)a)b
where rnk = 1




--- (Q6) Which item was purchased first by customer after they become a member ? ---
select * from
(select c.*, rank() over(partition by userid order by created_at) rnk from 
(select a.userid , a.created_at , a.product_id, b.gold_signup_date from sales a
inner join goldusers_signup b
on a.userid = b.user_id
and created_at >= gold_signup_date)c)d where rnk=1;





--- (Q7) Which item was purchased just before customer became a member? ---
select * from
(select c.*, rank() over(partition by userid order by created_at DESC) rnk from 
(select a.userid , a.created_at , a.product_id, b.gold_signup_date from sales a
inner join goldusers_signup b
on a.userid = b.user_id
and created_at <= gold_signup_date)c)d where rnk=1;







---(Q8) what is total orders and amount spent for each member before they become a member ?---

select userid, count(created_at) order_purchased, sum(price) total_amt_spent from
(select c.*, d.price from
(select a.userid , a.created_at , a.product_id, b.gold_signup_date from sales a
inner join goldusers_signup b
on a.userid = b.user_id
and created_at <= gold_signup_date)c inner join product d on c.product_id = d.product_id)e
group by userid;




---(Q9)Rank all the transactions of the customers---
select *, rank() over(partition by userid order by created_at) rnk from sales;







 







