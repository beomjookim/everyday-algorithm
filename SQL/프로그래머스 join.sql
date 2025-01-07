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

-- 주문량이 많은 아이스크림들 조회하기
-- limit 3를 해주려고 하는데, ANSI에 따르면 fetch first 3 rows only를 시전해야 하지만 MySQL이기에 limit.

with grouped_first_half as (select flavor, sum(total_order) total from first_half group by flavor),
grouped_july as (select flavor, sum(total_order) total from july group by flavor)
select h.flavor from grouped_first_half h join grouped_july j on h.flavor = j.flavor
order by h.total + j.total desc limit 3
 
-- 조건에 맞는 도서와 저자 리스트 출력하기
with econ_books as (select book_id, author_id, published_date from book where category = '경제')
select b.book_id, a.author_name, substring(b.published_date, 1, 10) from econ_books b join author a on b.author_id = a.author_id 
order by published_date

-- 그룹별 조건에 맞는 식당 목록 출력하기
with review_count as (select member_id, count(*) review_count from rest_review group by member_id order by review_count desc limit 1)
select p.member_name, r.review_text, substring(r.review_date, 1, 10) review_date
from rest_review r join member_profile p on r.member_id = p.member_id
where r.member_id = (select member_id from review_count)
order by review_date, r.review_text
  
-- 없어진 기록 찾기
select animal_id, name from animal_outs where animal_id not in (select animal_id from animal_ins)
order by animal_id
 
-- 있었는데요 없었습니다
select i.animal_id, i.name from animal_ins i join animal_outs o on i.animal_id = o.animal_id
where i.datetime > o.datetime order by i.datetime
 
-- 오랜 기간 보호한 동물(1)
select name, datetime from animal_ins 
where animal_id not in (select animal_id from animal_outs) 
order by datetime limit 3
 
-- 보호소에서 중성화한 동물
select i.animal_id, i.animal_type, i.name 
from animal_ins i join animal_outs o on i.animal_id = o.animal_id
where i.sex_upon_intake != o.sex_upon_outcome
order by i.animal_id
 
-- 상품 별 오프라인 매출 구하기
-- 매우 좋은 문제. 거의 대부분 잡았지만, count(*) 부분에서 틀렸다. count(distinct user_id) 이렇게 좀 더 세심하게 봐줘야 함.

with joined_21 as (select user_id from user_info where joined between '2021-01-01' and '2021-12-31'),
total_21 as (select count(*) total from joined_21)
select extract(YEAR from sales_date) year, extract(month from sales_date) month, count(distinct user_id), round((count(distinct user_id)/(select total from total_21)),1)
from online_sale where user_id in (select user_id from joined_21) group by year, month
order by year, month

-- 위의 코드마저도, 최적화를 위해서 몇가지가 필요하다.

-- 1(1) 단순히 count(*)를 위해 만든 CTE 제거해버리기
-- 1(2) 또한 단순히 하나의 값만을 위해서 CTE를 쓴 경우, CROSS JOIN을 해주는 것도 방법이다.
-- 2 order by 의 뒷부분처럼, year, month의 별칭을 쓴 경우 일부 DBMS에서는 별칭처리된 값들을 기준으로 진행하지만, 일부 DBMS에서는 또 그렇지 않을 수 있다. 그러므로 CTE로 따로 빼주는 게 보편적인 관점에서 봤을 때 훨 나음.

WITH joined_21 AS (
    SELECT user_id 
    FROM user_info 
    WHERE joined BETWEEN '2021-01-01' AND '2021-12-31'
),
total_users AS (
    SELECT COUNT(*) AS total 
    FROM joined_21
),
purchased_users AS (
    SELECT 
        EXTRACT(YEAR FROM sales_date) AS year,
        EXTRACT(MONTH FROM sales_date) AS month,
        COUNT(DISTINCT user_id) AS distinct_users
    FROM online_sale
    WHERE user_id IN (SELECT user_id FROM joined_21)
    GROUP BY EXTRACT(YEAR FROM sales_date), EXTRACT(MONTH FROM sales_date)
)
SELECT 
    p.year, 
    p.month, 
    p.distinct_users AS purchased_users,
    ROUND((p.distinct_users * 1.0) / t.total, 1) AS purchased_ratio
FROM purchased_users p
CROSS JOIN total_users t
ORDER BY p.year, p.month;
