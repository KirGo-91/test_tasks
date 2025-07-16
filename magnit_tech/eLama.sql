/*Задание 3.
В таблице webinar.csv находится список посетителей вебинара, который прошел 1 апреля 2016 г.
Нужно вывести тех посетителей, кто впервые зарегистрировался в еЛаме (users.csv) после вебинара,
и для каждого из них посчитать сумму его пополнений в системе (transactions.csv).
Под посетителем вебинара мы понимаем один email.*/



SELECT w.email, 
	   SUM(fund) AS fund
FROM elama_webinar w
JOIN
(
  SELECT *,
         MIN(date_registration) OVER (PARTITION BY email) AS first_reg
  FROM elama_users
) AS u 
ON u.email=w.email
AND DATE(u.first_reg) >= '2016-04-01'   
LEFT JOIN
(
  SELECT user_id, 
  		 SUM(price) AS fund
  FROM elama_transactions
  GROUP BY user_id
) AS t 
ON t.user_id = u.user_id
GROUP BY w.email