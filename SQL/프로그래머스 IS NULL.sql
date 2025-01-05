-- 경기도에 위치한 식품창고 목록 출력하기
select warehouse_id, warehouse_name, address, 
case when freezer_yn is null or freezer_yn = 'N' then 'N' else 'Y' end freezer_yn
from food_warehouse where substring(address,1,3) = '경기도' order by warehouse_id
 
-- 이름이 없는 동물의 아이디
select animal_id from animal_ins where name is null order by animal_id
 
-- 이름이 있는 동물의 아이디
select animal_id from animal_ins where name is not null order by animal_id
 
-- NULL 처리하기
select animal_type, case when name is null then "No name" else name end name, sex_upon_intake from animal_ins
 
-- 나이 정보가 없는 회원 수 구하기
select count(*) users from user_info where age is null
 
-- ROOT 아이템 구하기
select i.item_id, item_name from item_tree t join item_info i on i.item_id = t.item_id 
where parent_item_id is null
 
-- 업그레이드 할 수 없는 아이템 구하기
-- 매우 특이한 게, 서브쿼리 내에 null이 포함되어 있으면 오작동한다.

-- 그래서 서브쿼리 내에는 null을 불포함해야 한다.

with parents as (select distinct parent_item_id parent_id from item_tree where parent_item_id is not null)
select item_id, item_name, rarity from item_info where item_id not in (select parent_id from parents)
order by item_id desc
 
-- 잡은 물고기의 평균 길이 구하기
with no_null as (select case when length is null then 10 else length end length from fish_info)
select round(avg(length),2) average_length from no_null
