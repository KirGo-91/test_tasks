/*Задание 1 - задачи по SQL.
Имеются две таблицы. Таблица заказов = orders. В каждом заказе только 1 товар. Уникальный ключ - order_id. 
Таблица цен и наименований товаров = items. Уникальный ключ - item_id, update_date.
В данной таблице содержится история о свойствах товара, действующих с определенного момента.
Например, вторая строка в таблице говорит нам о том, 
что item_id = 2 с момента времени 2022-01-11 называется Карандаш 1H.*/

CREATE TABLE orders
(
    order_id Int,
    user_id Int,
    item_id Int,
    order_date date
)

INSERT INTO orders
VALUES 
(1,           1,           1,           '2022-07-01'),
(2,           2,           2,           '2022-02-01'),
(3,           1,           3,           '2022-05-01'),
(4,           3,           2,           '2022-07-01'),
(5,           2,           1,           '2022-04-01'),
(6,           1,           1,           '2022-06-01')

CREATE TABLE items
(
    item_id Int,
    item_name varchar,
    price Int,
    update_date date
)

INSERT INTO items
VALUES
(1,           'Ручка гелевая',           10,           '2022-02-01'),
(2,           'Карандаш 1H',             2,            '2022-01-11'),
(1,           'Ручка шариковая',         10,           '2022-05-15'),
(3,           'Ластик',                  5,            '2022-05-01'),
(3,           'Ластик',                  8,            '2022-07-01'),
(2,           'Карандаш 1HH',            3,            '2022-05-01'),
(1,           'Ручка шариковая',         5,            '2022-07-01'),
(2,           'Карандаш 1H',             7,            '2022-06-01')

--Задача.1 Выведите список user_id, которые сделали 2 заказа и более после 2022-03-01.

select user_id
from orders
where order_date > '2022-03-01'
group by user_id
having count(order_id) >= 2

--Задача 2. Выведите состояние товаров ((item_id, item_name, price) на определенную дату - 2022-06-01.

select item_id, item_name, price
from (select *,
	   coalesce(lead(update_date) over (partition by item_id order by update_date), '2100-01-01') as next_update
	   from items
) as t1
where update_date <= '2022-06-01'
and next_update > '2022-06-01'

--Задача 3. Выведите список order_id и item_name только тех заказов, 
--где купленный товар был по цене больше 3

select o.order_id, i.item_name
from orders o
join 
( select *,
        coalesce(lead(update_date) over (partition by item_id order by update_date), '2100-01-01') as next_update
  from items
) as i 
on o.item_id = i.item_id
and o.order_date >= i.update_date
and o.order_date < i.next_update
and i.price> 3