-- 평균 일일 대여 요금 구하기
-- 기본적으로 값들을 가져오는 거니까 select from을 쓰고, where로 조건 달아주고.
-- 가져온 열을 avg라는 집계 함수(agg function)를 통해 하나의 값으로 만들어 줌.
-- 그리고 그 값을 소숫점 이하 0번째 자리까지 반올림해야 하므로 round(,0) 이렇게 해주고.
-- 그리고 as 키워드로 열의 이름 바꿔주고.

-- * SQL 평문에서는 대소문자 구분 없다.

-- 내 답안

select round(avg(daily_fee), 0) as average_fee from car_rental_company_car where car_type='SUV'

-- 3월에 태어난 여성 회원 목록 출력하기

-- 새로운 기술들을 많이 배웠는데,
-- 1 해당 컬럼의 데이터의 슬라이싱:
-- str인 경우 슬라이싱이 가능하다. substring(뭐시기, 시작 (1부터 시작) 인덱스, 개수) 이렇게 하는 것 같다.
-- 그러나, 주어진 값은 date라는 데이터 타입을 갖고 있으므로 저렇게 해줄 수 없다.
-- 오히려 date의 경우 이를 해주는 방식이 따로 있는데, 이게 month(date_of_birth) = 03 이렇게 해주는 것이다. 신기.

-- 2 조건 여러 개를 동시에 적용하는 법
-- 그냥 where 뒤에 여러개 and 로 묶어주면 된다.

-- 3 조건 절에서 null이 아닌 값만 꺼내는 법
-- where tlno is not null

-- 4 만들어진 데이터 오름차순 정렬
-- order by <대상 열> asc

-- 5 값 새로이 바꿔주기
-- date_format(date_of_birth, '%y-%m-%d')
-- 이렇게 하면 date_of_birth의 date 데이터들이 string으로 바뀌면서, 저 꼴을 따르게 된다.
-- %Y: 네자리 연도, %y: 두자리 연도
-- %M: 영어 약칭, %m: 두자리 숫자
-- %D: 요일 표시, %d: 두자리 숫자

-- 6 별칭 as
-- select 뒷 부분에, 변환된 녀석 as something 이렇게 하면 변환된 녀석의 수식이 아니라 as 뒤의 이름으로 열 이름이 바뀌는데, 이 as를 그냥 없앨 수도 있다.

-- 내 답안

select member_id, member_name, gender, date_format(date_of_birth, '%Y-%m-%d') date_of_birth from member_profile where tlno is not null and gender = 'W' and month(date_of_birth) = 03 order by member_id

-- 흉부회과 또는 일반외과 의사 목록 출력하기
-- 1 "CS" 혹은 "GS"인 녀석 찾기:
-- where mcdp_cd in ("CS", "GS")

-- 2 2개 이상의 조건으로 정렬하기
-- 그냥 컴마로 이어주면 됨. 순서는 큰틀 먼저.

-- 내 답안

select dr_name, dr_id, mcdp_cd, date_format(hire_ymd, "%Y-%m-%d") hire_ymd from doctor where mcdp_cd in ("CS", "GS") order by hire_ymd desc, dr_name

-- 인기있는 아이스크림
select flavor from first_half order by total_order desc, shipment_id

-- 강원도에 위치한 생산공장 목록 출력하기
select factory_id, factory_name, address from food_factory where substring(address, 1, 3) = '강원도' order by factory_id

-- 12세 이하인 여자 환자 목록 출력하기
-- tlno가 null이면 null이라는 값을 출력하라는데 어떻게 하지? 디폴트는 아무 값도 없는 것.

-- 이렇게 조건문을 쓰기 위해서는 mySQL 전용의 if 구문이 있고, 더 보편적으로는 case 구문이 있다.
-- CASE WHEN TLNO IS NULL THEN 'NULL' ELSE TLNO END AS TLNO
-- CASE WHEN ~ IS ~ ELSE 이거고 아래는 IF 구문이다
-- IF(TLNO IS NULL, 'NULL', TLNO) AS TLNO

-- 조건에 맞는 도서 리스트 출력하기
select book_id, date_format(published_date, '%Y-%m-%d') published_date from book where year(published_date) = '2021' and category = '인문' order by published_date

-- 어린 동물 찾기
-- where에서 아닌 조건을 찾는 건, != 활용.

select animal_id, name from animal_ins where intake_condition != "Aged" order by animal_id

-- 동물의 아이디와 이름
select animal_id, name from animal_ins order by animal_id

-- 여러 기준으로 정렬하기
select animal_id, name, datetime from animal_ins order by name, datetime desc

-- 상위 n개 레코드
-- n개만 꺼내고 싶다! 이러면 limit n 써주면 된다.
select name from animal_ins order by datetime limit 1

-- 조건에 맞는 회원수 구하기
select count(user_id) from user_info where 20 <= age and 29 >= age and year(joined) = '2021'

-- 잔챙이 잡은 수 구하기
-- NULL 여부를 구하는 건, is NULL 이라고 표현함. 그리고 count(id) 이렇게 할 필요없이 count(*) 하면 됨.

select count(*) fish_count from fish_info where length is NULL

-- 가장 큰 물고기 10마리 구하기
select id, length from fish_info order by length desc, id limit 10

-- 대장균의 크기에 따라 분류하기 1
select id, if (size_of_colony > 1000, 'HIGH', if (size_of_colony > 100, 'MEDIUM', 'LOW')) size from ecoli_data order by id

-- 특정 형질을 가지는 대장균 찾기
-- 비트 연산자를 사용하는 법은 걍 일반대로 두고 &, | 이런 거 써주면 그만.
select count(*) count from ecoli_data where not (genotype & 2) and (genotype & 5)

-- 부모의 형질을 모두 가지는 대장균 찾기
-- 새로운 테크닉을 찾았는데, 여러 개의 원본 테이블을 참조해야 할 때, from 뒤에 a, b 이렇게 타겟팅을 함.
select a.id, a.genotype genotype, b.genotype parent_genotype from ecoli_data a, ecoli_data b where a.parent_id = b.id and a.genotype & b.genotype = b.genotype order by id

-- 모든 레코드 조회하기
select * from animal_ins order by animal_id

-- 오프라인/온라인 판매 데이터 통합하기
-- 1 그냥 유사하게 생긴 두 개의 테이블을 단순히 세로로 이어붙이고 싶을 때, union 활용.

-- 2 그리고 ANSI 에서는 to_char(column, 'yyyy-mm-dd') 이렇게, MySQL에서는 date_format(column, '%Y-%m-%d').

with combined as (
    select 
        date_format(sales_date, '%Y-%m-%d') sales_date, 
        product_id, 
        user_id, 
        sales_amount 
    from 
        online_sale 
    where 
        sales_date between '2022-03-01' and '2022-03-31'
    union
    select 
        date_format(sales_date, '%Y-%m-%d') sales_date, 
        product_id, 
        null user_id, 
        sales_amount 
    from 
        offline_sale 
    where 
        sales_date between '2022-03-01' and '2022-03-31'
)
select 
    * 
from 
    combined
order by 
    sales_date, 
    product_id, 
    user_id

-- 과일로 만든 아이스크림 고르기
SELECT F.FLAVOR 
FROM FIRST_HALF F 
JOIN ICECREAM_INFO I ON F.FLAVOR = I.FLAVOR 
WHERE F.TOTAL_ORDER > 3000 
AND I.INGREDIENT_TYPE = 'fruit_based' 
ORDER BY F.TOTAL_ORDER DESC;

-- 서울에 위치한 식당 목록 출력하기
select r.rest_id, i.rest_name, i.food_type, i.favorites, i.address, round(avg(r.review_score),2) score 
from rest_info i join rest_review r on i.rest_id = r.rest_id
where substring(i.address, 1, 2) = '서울'
group by r.rest_id
order by score desc, favorites desc

-- 조건에 부합하는 중고거래 댓글 조회하기
SELECT B.TITLE, B.BOARD_ID, R.REPLY_ID, R.WRITER_ID, R.CONTENTS, LEFT(R.CREATED_DATE,10) AS CREATED_DATE 
FROM USED_GOODS_BOARD B JOIN USED_GOODS_REPLY R
WHERE LEFT(B.CREATED_DATE,7) = '2022-10' 
ORDER BY R.CREATED_DATE, B.TITLE

-- 재구매가 일어난 상품과 회원 리스트 구하기
select user_id, product_id from online_sale 
group by user_id, product_id having count(sales_date) > 1 
order by user_id, product_id desc

-- 역순 정렬하기
SELECT NAME, DATETIME FROM ANIMAL_INS ORDER BY ANIMAL_ID DESC

-- 아픈 동물 찾기
SELECT ANIMAL_ID, NAME FROM ANIMAL_INS WHERE INTAKE_CONDITION = "Sick"

-- 동물의 아이디와 이름
select animal_id, name from animal_ins order by animal_id

-- 여러 기준으로 정렬하기
select animal_id, name, datetime from animal_ins order by name, datetime desc

-- 상위 n개 레코드
select name from animal_ins order by datetime limit 1

-- 업그레이드 된 아이템 구하기
with rare_items as (select item_id from item_info where rarity = 'rare')
select i.item_id, i.item_name, i.rarity 
from item_tree t join item_info i on i.item_id = t.item_id 
where t.parent_item_id in (select item_id from rare_items)
order by i.item_id desc

-- Python 개발자 찾기
select id, email, first_name, last_name from developer_infos where skill_1 = "Python" or skill_2 = "Python" or skill_3 = "Python" order by id

-- 특정 물고기를 잡은 총 수 구하기
select count(id) as fish_count 
from fish_info i join fish_name_info n 
on i.fish_type = n.fish_type 
where n.fish_name = 'bass' or n.fish_name = 'snapper'

-- 대장균들의 자식의 수 구하기
-- Left join을 써야만 하는 부분이 있음. 
-- inner는 교집합, left는 왼쪽 테이블 기준, right은 오른쪽 테이블 기준.
with parents as (select parent_id id, count(*) cnt from ecoli_data where parent_id is not null group by parent_id)
select e.id, case when p.cnt > 0 then p.cnt else 0 end child_count 
from ecoli_data e left join parents p on e.id = p.id
