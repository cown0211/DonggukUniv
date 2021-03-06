
-- select 조건문, 부등호, and/or
SELECT empname FROM employee WHERE deptid = 3;

SELECT empname FROM employee WHERE deptid < 7 OR deptid > 12;

SELECT empname FROM employee WHERE deptid = 9 AND salarycode <= 3;



-- in / not in / range
SELECT empname FROM employee WHERE deptid IN (4,8,9);
=
SELECT empname FROM employee WHERE deptid = 4 OR deptid = 8 OR deptid = 9;


SELECT empname FROM employee WHERE deptid NOT IN (4,8,9);


SELECT empname FROM employee WHERE salarycode BETWEEN 10 AND 45;
=
SELECT empname FROM employee WHERE salarycode >= 10 AND salarycode <= 45;



-- wildcard % and _
SELECT empid FROM employee WHERE empname LIKE 'LEE%';
-- %는 여러 글자수를 말함
-- 위의 결과는 LEE1, LEEIA, LEEGJGN 등을 모두 반환함

SELECT empid FROM employee WHERE phone LIKE '010-1234-____';
-- _는 한 글자만 가능
-- 위의 결과는 010-1234-5678, 010-1234-1252과 같은 방식



-- order by
SELECT * FROM employee ORDER BY empname ASC;
-- employee의 모든 레코드를 empname 기준으로 오름차순 정렬

SELECT * FROM employee ORDER BY empname DESC;
-- employee의 모든 레코드를 empname 기준으로 내림차순 정렬



-- 내장함수
SELECT COUNT(*) FROM employee;
-- 모든 레코드 수 반환

SELECT MIN(hours) AS minimumhours, MAX(hours) AS maximumhours, AVG(hours) AS averagehours
FROM project WHERE projectid > 7;



-- group by
SELECT deptid, COUNT(*) AS numberofemployee
FROM employee
GROUP BY deptid;
-- deptid를 기준으로 묶어버리므로 numberofemployee도 deptid의 레코드 수를 반환해줌



-- having
SELECT salespersonid, salespersonlastname, SUM(saleamount) AS totalsales
FROM sales
GROUP BY salespersonid, salespersonlastname
HAVING SUM(saleamount) >= 10000;
-- having 절이 조건절이 되어 totalsales가 10000 이상인 경우에만 반환함



-- subquery
SELECT empname FROM employee WHERE deptid IN (SELECT deptid FROM department WHERE deptname LIKE 'account%');
-- 쿼리 안에 괄호로 처리되어 쿼리가 또 들어가는걸 서브쿼리라고 함

SELECT empname FROM employee AS e WHERE empsalary > 
(SELECT AVG(empsalary) FROM employee WHERE deptid = e.deptid)



-- join
SELECT empname, deptname
FROM employee AS e, department AS d
WHERE e.deptid = d.deptid;
-- employee 테이블과 department 테이블로부터 deptid가 같은 것을 기준으로 empname과 deptname을 반환


SELECT empname, deptname
FROM employee e INNER JOIN department d ON e.deptid = d.deptid
WHERE d.deptname NOT LIKE 'account%';
-- inner join = 교집합

SELECT empname, deptname
FROM employee e LEFT OUTER JOIN department d ON e.deptid = d.deptid
-- e를 기준으로 가져옴
-- deptid를 기준으로 e를 다 살려 가져옴 

SELECT empname, deptname
FROM employee e RIGHT OUTER JOIN department d ON e.deptid = d.deptid
-- 위와 정반대로, d를 기준으로 가져옴
-- 따라서 deptname은 모두 가져오게 되고, empname에 공란 생길 수 있음

SELECT empname, deptname
FROM employee e FULL OUTER JOIN department d ON e.deptid = d.deptid
-- 양측에서 모두 가져오기 때문에 양측 모두 공란 발생
