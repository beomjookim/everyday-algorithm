-- 특정 기간동안 대여 가능한 자동차들의 대여비용 구하기
-- SQL의 실행 순서에 따라, FROM - JOIN - WHERE - GROUP BY - HAVING - SELECT - ORDER BY에서

-- select보다 앞에 있으면 별칭을 쓸 수가 없음. 그러나 having은 모종의 이유로 쓸 수 있음. order by 도 당연히 가능.

with discount_rates as (
    select car_type, discount_rate from car_rental_company_discount_plan 
    where car_type in ('SUV', '세단') and duration_type = '30일 이상'),
unavailable_ones as (select distinct car_id from car_rental_company_rental_history 
                   where start_date <= '2022-11-30' and end_date >= '2022-11-01')
select c.car_id, c.car_type, round((30 * c.daily_fee) * (100 - d.discount_rate) / 100) fee
from car_rental_company_car c join discount_rates d on c.car_type = d.car_type
where round((30 * c.daily_fee) * (100 - d.discount_rate) / 100) between 500000 and 2000000 and c.car_id not in (select car_id from unavailable_ones)
order by fee desc, c.car_type, c.car_id desc

-- 5월 식품들의 총매출 조회하기
select o.product_id, p.product_name, sum(o.amount) * p.price total_sales 
from food_order o join food_product p on p.product_id = o.product_id
where o.produce_date between '2022-05-01' and '2022-05-31'
group by o.product_id, p.product_name
order by total_sales desc, o.product_id




