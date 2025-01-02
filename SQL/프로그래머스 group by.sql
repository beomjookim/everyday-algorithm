-- 자동차 대여 기록에서 대여중/ 대여 가능 여부 구분하기

-- 진짜 생각할 거리를 많이 던져 준 좋은 문제다.

-- 1 각각의 차가 여러번 등장한다.
-- 그래서 distinct를 쓰든, group by를 쓰든 해서 중복되는 엘리먼트들을 쳐내줘야 하는데,
-- distinct의 경우 select에 해당하는 모든 아이들을 포함해야 하므로 이 문제를 푸는 데에 적절하지 않다.
-- 그래서 group by로 묶어줬다.

-- 2 대여중 혹은 대여 가능: 만약 값이 between 이면 넣고, 아니면 마는 방식인데, between 이라는 함수 활용.

-- 3 그리고 '대여중'인 '대여 가능' 이거 두개를 선택해야 하는데, 각각의 car_id에 해당하는 수많은 내역 중에 지금 저 날짜에 대여중이라면 대여중, 아니면 가능을 넣어주는 거다. 즉, 대여중이 하나라도 있으면 대여중을, 대여 가능 밖에 없으면 대여 가능을 넣어줘야 한다. 그걸 구현하는 방법으로 CTE를 써서 대여 중이 한번이라도 있으면 car_id를 포함하는 테이블을 만듦으로써 이를 활용하는 식으로 진행했다.

-- 4 저렇게 테이블을 만들고 나면, 이걸 활용할 때 어쩔 수 없이 또 (select 어쩌고)를 쓰는 방식의 서브쿼리를 써야 하는데, 그게 싫으면 with의 테이블 안에 값을 넣어줘도 될 것 같다. 그치만 이후에 join을 배우면 좀 더 쉽게 풀 수 있지 않을까 싶다.

-- 결과적으로 내 코드는

with availability_table as (select car_id from car_rental_company_rental_history where '2022-10-16' between start_date and end_date)
select car_id, case when car_id in (select car_id from availability_table) then '대여중' else '대여 가능' end availability 
from car_rental_company_rental_history
group by car_id 
order by car_id desc

-- 대여 횟수가 많은 자동차들의 월별 대여 횟수 구하기

-- 이 문제는 참 골치 아픈 문제였다.
-- 8월부터 10월까지의 대여횟수가 5회 이상인 차들의 id를 확보해야 했고, 해당 차들의 레코드들을 월별로 나눠줘야 했다. 그래서 두 개의 테이블을 생성해서 이 둘을 활용했다.
-- with로 두 개 이상의 테이블을 만들 때는 ,로 구분해주고, with는 한번만 써주고.
-- 또 month() 형태는 ansi에 위배되므로 extract(month from)의 형태로 바꿔줘야 한다.
-- 그리고 where는 테이블 형성 과정에서 영향을 미치기 때문에, 이미 만들어진 테이블에 대해서 활용할 수 있는 aggregate function을 사용할 수 없다. 그래서 group by의 having 절 안에서 이를 활용해주면 그만이다.
-- 내 코드는

with targets as (select car_id, count(*) count from car_rental_company_rental_history where start_date between '2022-08-01' and '2022-10-31' group by car_id having count(*)),
monthly_count as (select car_id, extract(month from start_date) month from car_rental_company_rental_history where start_date between '2022-08-01'and '2022-10-31')
select mc.month, mc.car_id, count(*) records 
from monthly_count mc join targets as t1 on mc.car_id = t1.car_id where t1.count >= 5
group by mc.car_id, mc.month order by mc.month, mc.car_id desc

-- 저자 별 카테고리 별 매출액 집계하기
-- 여러모로 골치 아프지만, 잘 묶어서 생각하다보면 잘 풀 수 있다.

with jan_sales as (select book_id, sum(sales) total_sales from book_sales where sales_date between '2022-01-01' and '2022-01-31' group by book_id),
book_w_author_name as (select b.book_id, b.category, b.author_id, b.price, b.published_date, a.author_name from book b join author a on b.author_id = a.author_id)
select b.author_id, b.author_name, b.category, sum(j.total_sales*b.price) total_sales from jan_sales j join book_w_author_name b on j.book_id = b.book_id
group by b.author_id, b.category
order by b.author_id, b.category desc

-- 식품분류별 가장 비싼 식품의 정보 조회하기
with max_table as (select category, max(price) max_price from food_product group by category having category in ('과자', '국', '김치', '식용유'))
select f.category, m.max_price, f.product_name from food_product f join max_table m on f.category = m.category where m.max_price = f.price order by m.max_price desc

-- 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
-- varchar의 일부도 속했는지 여부를 확인하는 방법은, <해당 varchar> like "%시트%" 이렇게 표현해주면 됨.

with yes_options as (select * from car_rental_company_car where options like '%시트%')
select car_type, count(*) cars from yes_options group by car_type order by car_type
