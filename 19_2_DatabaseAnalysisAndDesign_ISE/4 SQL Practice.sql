/* 시퀀스, 트리거 */
-- employee 테이블 생성
CREATE TABLE employee(
emp_id NUMBER(6) NOT NULL,
emp_name VARCHAR2(15) NOT NULL,
emp_address VARCHAR2(15) NOT NULL,
CONSTRAINT empPK PRIMARY KEY (emp_id)
);

-- 데이터 삽입
INSERT INTO employee (emp_id, emp_name, emp_address) VALUES (201901, 'jack', 'seoul korea');
INSERT INTO employee (emp_id, emp_name, emp_address) VALUES (201902, 'mike', 'incheon korea');
INSERT INTO employee (emp_id, emp_name, emp_address) VALUES (201903, 'david', 'seoul korea');
INSERT INTO employee (emp_id, emp_name, emp_address) VALUES (201904, 'lee', 'incheon korea');
INSERT INTO employee (emp_id, emp_name, emp_address) VALUES (201905, 'han', 'busan korea');


-- department 테이블 생성
CREATE TABLE department(
dept_id NUMBER(6) NOT NULL,
dept_name VARCHAR2(15) NOT NULL,
CONSTRAINT deptPK PRIMARY KEY (dept_id)
);


-- department 테이블에 대한 시퀀스 생성
CREATE SEQUENCE dept_seq START WITH 19001;
-- dept_seq라는 이름의 시퀀스를 생성한다. 
-- 시퀀스는 19001로부터 시작한다. 
-- 시퀀스를 사용함으로 자동적으로 유니크 값을 발생시키고 PK로 사용 가능



-- 트리거
-- 트리거는 특정한 상황이 발생되면 자동적으로 실행되는 프로시져
-- 트리거를 발동시켜 시퀀스가 실행
CREATE OR REPLACE TRIGGER dept_id_trigger
BEFORE INSERT ON department
FOR EACH ROW
BEGIN
SELECT dept_seq.NEXTVAL
INTO:new.dept_id
FROM dual;
END;
/
-- dept_id_trigger라는 이름의 트리거 생성
-- department 테이블에 적용
-- dept_seq.NEXTVAL로 19001부터 1씩 증가
-- dept_id에 위의 시퀀스 결과 값을 대입



-- 시퀀스, 트리거 생성 이후 데이터 삽입
INSERT INTO department (dept_name) VALUES ('accounting');
INSERT INTO department (dept_name) VALUES ('sales');
INSERT INTO department (dept_name) VALUES ('marketing');
INSERT INTO department (dept_name) VALUES ('research');

SELECT * FROM department;
-- 테이블 조회 해보면 입력 안한 dept_id에 값이 모두 들어가있음
-- 19001로부터 1씩 증가해가며 입력됨




-- 시퀀스, 트리거 연습
CREATE TABLE salary(
sal_id NUMBER(6) NOT NULL,
emp_id NUMBER(6) NOT NULL,
dept_id NUMBER(6) NOT NULL,
sal_date DATE NOT NULL,
sal_val NUMBER(10) NOT NULL,
sal_bonus NUMBER(10) NULL,
CONSTRAINT salPK PRIMARY KEY (sal_id),
CONSTRAINT empFK FOREIGN KEY (emp_id) REFERENCES employee (emp_id),
CONSTRAINT deptFK FOREIGN KEY (dept_id) REFERENCES department (dept_id)
);


CREATE SEQUENCE sal_seq START WITH 1;

CREATE OR REPLACE TRIGGER sal_id_trigger
BEFORE INSERT ON salary
FOR EACH ROW
BEGIN
SELECT sal_seq.NEXTVAL
INTO:new.sal_id
FROM dual;
END;
/

INSERT INTO salary (emp_id, dept_id, sal_date, sal_val, sal_bonus) VALUES (201901, 19001, DATE'2019-09-17', 1000, 500);
INSERT INTO salary (emp_id, dept_id, sal_date, sal_val, sal_bonus) VALUES (201902, 19001, DATE'2019-09-17', 1200, 300);
INSERT INTO salary (emp_id, dept_id, sal_date, sal_val, sal_bonus) VALUES (201903, 19002, DATE'2019-09-17', 1300, 600);
INSERT INTO salary (emp_id, dept_id, sal_date, sal_val, sal_bonus) VALUES (201904, 19002, DATE'2019-09-17', 1300, 800);
INSERT INTO salary (emp_id, dept_id, sal_date, sal_val) VALUES (201905, 19002, DATE'2019-09-17', 1300);
UPDATE salary SET sal_bonus=0 WHERE emp_id=201905 AND dept_id=19002;


SELECT * FROM salary;





/* 날짜 형식 */
-- DATE 형식 입력하고 싶다면
DATE'1900-01-01' 형태로 입력
-- 텍스트를 날짜 형식으로 변환
TO_DATE('26-01-1991','DD-MM-YYYY')




/* SELECT문 데이터 조회 */

-- 데이터 추가 삽입
INSERT INTO employee (emp_id, emp_name, emp_address) VALUES (201906, 'test', 'jeju korea');
INSERT INTO department (dept_name) VALUES ('testing');

-- 데이터 삽입 후 수정
INSERT INTO salary (emp_id, dept_id, sal_date, sal_val, sal_bonus) VALUES (201906, 19005, DATE'2019-10-02', 2000, 450);
SELECT * FROM salary;

UPDATE employee SET emp_name='park' WHERE emp_id=201906;
SELECT * FROM employee;


-- employee 테이블에서 emp_address가 seoul로 시작하는 직원 모두 조회
SELECT * FROM employee WHERE emp_address LIKE 'seoul%';

-- employee 테이블에서 emp_address에 eo가 들어가는 직원 모두 조회
SELECT * FROM employee WHERE emp_address LIKE '%eo%';

-- employee 테이블에서 emp_address에 korea로 끝나는 직원 모두 조회
SELECT * FROM employee WHERE emp_address LIKE '%korea';

-- department 테이블에서 dept_name이 ing로 끝나는 모든 부서 조회
SELECT * FROM department WHERE dept_name LIKE '%ing';

-- department 테이블에서 dept_name에 es 들어가는 모든 부서 조회
SELECT * FROM department WHERE dept_name LIKE '%es%';



/* ORDER BY 정렬 */
-- 오름차순, 1->9, a->z, 과거->현재
SELECT * FROM employee ORDER BY emp_name ASC;

SELECT * FROM salary ORDER BY sal_date ASC;

-- 내림차순, 9->1, z->a, 최근->과거
SELECT * FROM employee ORDER BY emp_name DESC;

SELECT * FROM salary ORDER BY sal_date DESC;




/* 내장함수 */
SELECT COUNT(*) as nums_emp FROM employee;
-- employee의 모든 레코드 수를 nums_emp라는 칼럼명으로 불러옴

SELECT MIN(sal_val) Min_Sal, MAX(sal_val) Max_Sal, AVG(sal_val) Mean_Sal, STDDEV(sal_val) STD_Sal FROM salary;
-- salary 테이블에서 sal_val의 최소값, 최대값, 평균, 표준편차를 불러옴


SELECT emp_id, TO_CHAR(sal_val, '$9,999.99') Salary FROM salary;
-- salary 테이블에서 sal_val의 값을 $와 ,와 .00 형식으로 변환 후 Salary라는 칼럼명으로 읽음

SELECT emp_id, TO_CHAR(sal_val, '$9,999.99') Salary, TO_CHAR(sal_date, 'YYYY-MM') Year_Month FROM salary;

-- TO_CHAR() 함수는 숫자나 날짜 데이터를 문자로 변환
예시
SELECT TO_CHAR(1210.73, '$9,999.99') FROM DUAL;
SELECT TO_CHAR(21, '000099') FROM DUAL;
SELECT TO_CHAR(sysdate, 'YYYY/MM/DD') FROM DUAL;
SELECT TO_CHAR(sysdate, 'Month DD, YYYY') FROM DUAL;






/* GROUP BY, HAVING */
-- having은 groupby에 대한 조건문
SELECT dept_id, COUNT(*) nums_emp FROM salary GROUP BY dept_id;

SELECT dept_id, AVG(sal_val) Mean_Sal FROM salary GROUP BY dept_id HAVING AVG(sal_val) >= 1000;

SELECT dept_id, MAX(sal_val) Max_Sal FROM salary GROUP BY dept_id HAVING MAX(sal_val) >= 2000;

SELECT dept_id, MIN(sal_val) Min_Sal FROM salary GROUP BY dept_id HAVING MIN(sal_val) <= 1000;




/* JOIN */
-- department와 salary 테이블 join
SELECT d.dept_id, d.dept_name, COUNT(s.dept_id) nums_emp FROM salary s, department d WHERE s.dept_id = d.dept_id GROUP BY d.dept_id, d.dept_name;
-- department 별 salary를 받는 인원수 카운트

SELECT d.dept_id, d.dept_name, AVG(s.sal_val) Mean_Sal FROM salary s, department d WHERE s.dept_id = d.dept_id GROUP BY d.dept_id, d.dept_name HAVING AVG(sal_val) >= 1000;
-- sal_val의 평균이 1000 이상인 부서의 평균 sal_val

SELECT d.dept_id, d.dept_name, MAX(s.sal_val) Max_Sal FROM salary s, department d WHERE s.dept_id = d.dept_id GROUP BY d.dept_id, d.dept_name HAVING MAX(sal_val) >= 2000;

SELECT d.dept_id, d.dept_name, MIN(s.sal_val) Min_Sal FROM salary s, department d WHERE s.dept_id = d.dept_id GROUP BY d.dept_id, d.dept_name HAVING MIN(sal_val) <= 1000;



/* SUBQUERY (Non-Correlated) */
-- 괄호 안의 서브쿼리를 실행할 때 바깥의 쿼리문과 연결된 것이 없음
SELECT e.emp_name FROM employee e, salary s WHERE s.emp_id = e.emp_id AND s.dept_id IN(SELECT dept_id FROM department WHERE dept_name LIKE '%ing%');

SELECT e.emp_name FROM employee e, salary s WHERE s.emp_id = e.emp_id AND s.dept_id NOT IN(SELECT dept_id FROM department WHERE dept_name LIKE '%ing%');

SELECT e.emp_name, d.dept_name FROM employee e, salary s, department d WHERE s.emp_id = e.emp_id AND s.dept_id = d.dept_id AND s.dept_id IN(SELECT dept_id FROM department WHERE dept_name LIKE '%ing%');

SELECT e.emp_name, d.dept_name FROM employee e, salary s, department d WHERE s.emp_id = e.emp_id AND s.dept_id = d.dept_id AND s.dept_id NOT IN(SELECT dept_id FROM department WHERE dept_name LIKE '%ing%');



/* SUBQUERY (Correlated) */
-- 괄호 안의 서브쿼리 수행을 위해 바깥의 쿼리값을 가져와야 함
SELECT e.emp_name, d.dept_name, s.sal_val FROM employee e, salary s, department d WHERE s.emp_id = e.emp_id AND s.dept_id = d.dept_id AND s.sal_val > (SELECT AVG(sal_val) FROM salary WHERE dept_id = s.dept_id);

SELECT e.emp_name, d.dept_name, s.sal_val FROM employee e, salary s, department d WHERE s.emp_id = e.emp_id AND s.dept_id = d.dept_id AND s.sal_val < (SELECT AVG(sal_val) FROM salary WHERE dept_id = s.dept_id);

SELECT e.emp_name, d.dept_name, s.sal_val FROM employee e, salary s, department d WHERE s.emp_id = e.emp_id AND s.dept_id = d.dept_id AND s.sal_val = (SELECT AVG(sal_val) FROM salary WHERE dept_id = s.dept_id);




/* INNER JOIN ON */
SELECT e.emp_name, d.dept_name, s.sal_val FROM employee e, salary s, department d WHERE s.emp_id = e.emp_id AND s.dept_id = d.dept_id AND s.sal_val = (SELECT AVG(sal_val) FROM salary WHERE dept_id = s.dept_id);

SELECT e.emp_name, d.dept_name, s.sal_val FROM employee e INNER JOIN salary s ON s.emp_id = e.emp_id INNER JOIN department d ON s.dept_id = d.dept_id WHERE s.sal_val = (SELECT AVG(sal_val) FROM salary WHERE dept_id = s.dept_id);


SELECT e.emp_name, d.dept_name, s.sal_val FROM employee e INNER JOIN salary s ON s.emp_id = e.emp_id INNER JOIN department d ON s.dept_id = d.dept_id WHERE s.sal_val >= 1300;


/* LEFT OUTER JOIN ON */
-- employee 테이블 기준 left outer
SELECT e.emp_name, d.dept_name, s.sal_val FROM employee e
LEFT OUTER JOIN salary s ON s.emp_id = e.emp_id
LEFT OUTER JOIN department d ON s.dept_id = d.dept_id;

-- department 테이블 기준 left outer, emp, sal 테이블에서 공란 발생
SELECT e.emp_name, d.dept_name, s.sal_val FROM department d
LEFT OUTER JOIN salary s ON s.dept_id = d.dept_id
LEFT OUTER JOIN employee e ON s.emp_id = e.emp_id;



/* RIGHT OUTER JOIN ON */

SELECT e.emp_name, d.dept_name, s.sal_val FROM employee e
RIGHT OUTER JOIN salary s ON s.emp_id = e.emp_id
RIGHT OUTER JOIN department d ON s.dept_id = d.dept_id;

SELECT e.emp_name, d.dept_name, s.sal_val FROM department d
RIGHT OUTER JOIN salary s ON s.dept_id = d.dept_id
RIGHT OUTER JOIN employee e ON s.emp_id = e.emp_id;



/* FULL OUTER JOIN ON */
SELECT e.emp_name, d.dept_name, s.sal_val FROM employee e
FULL OUTER JOIN salary s ON s.emp_id = e.emp_id
FULL OUTER JOIN department d ON s.dept_id = d.dept_id;

-- 행 삭제 후 재조회
DELETE FROM salary WHERE emp_id = 201905;

SELECT e.emp_name, d.dept_name, s.sal_val FROM employee e
FULL OUTER JOIN salary s ON s.emp_id = e.emp_id
FULL OUTER JOIN department d ON s.dept_id = d.dept_id;




/* Q1 */
-- Show the employee name, department and salary from three tables. Sort ascending by employee name and 
descending by salary.

SELECT e.emp_name name, d.dept_name department, TO_CHAR(s.sal_val, '$9,999.00') salary 
FROM employee e, department d, salary s
WHERE e.emp_id = s.emp_id AND d.dept_id = s.dept_id;

SELECT e.emp_name name, d.dept_name department, TO_CHAR(s.sal_val, '$9,999.00') salary 
FROM employee e, department d, salary s
WHERE e.emp_id = s.emp_id AND d.dept_id = s.dept_id
ORDER BY e.emp_name ASC;

SELECT e.emp_name name, d.dept_name department, TO_CHAR(s.sal_val, '$9,999.00') salary 
FROM employee e, department d, salary s
WHERE e.emp_id = s.emp_id AND d.dept_id = s.dept_id
ORDER BY s.sal_val DESC;


/* Q2 */
-- Show the employee id, name, total salary (salary+bonus) and salary date from three tables. Sort descending by salary 
value and use having to filter out the salary that is higher or equal than 1900.


SELECT e.emp_id, e.emp_name, s.sal_date, TO_CHAR(SUM(s.sal_val + s.sal_bonus), '$9,999.00') tot_sal
FROM employee e, department d, salary s
WHERE e.emp_id = s.emp_id AND d.dept_id = s.dept_id
GROUP BY s.sal_date, e.emp_id, e.emp_name ORDER BY tot_sal DESC;


SELECT e.emp_id, e.emp_name, s.sal_date, TO_CHAR(SUM(s.sal_val + s.sal_bonus), '$9,999.00') tot_sal
FROM employee e, department d, salary s
WHERE e.emp_id = s.emp_id AND d.dept_id = s.dept_id
GROUP BY s.sal_date, e.emp_id, e.emp_name
HAVING SUM(s.sal_val + s.sal_bonus) >= 1900
ORDER BY tot_sal DESC;


/* Q3 */
-- Show the employee id, name, department, year and month of the salary and total salary received (+bonus) from three 
tables. Sort descending by total salary value and use IN and subquery to filter the department id which is like ‘%ing’


SELECT e.emp_id id, e.emp_name name, d.dept_name dept, TO_CHAR(s.sal_date, 'YYYY-MM') year_month, TO_CHAR(SUM(s.sal_val + s.sal_bonus), '$9,999.00') tot_sal
FROM employee e, department d, salary s
WHERE e.emp_id = s.emp_id AND d.dept_id = s.dept_id
IN(SELECT dept_id FROM department WHERE dept_name LIKE '%ing')
GROUP BY s.sal_date, e.emp_id, e.emp_name, d.dept_name
ORDER BY tot_sal DESC;





/* create a VIEW */
/*In this example, we’re going to create a view as an alias to show all the employee who work in the accounting 
department with their salary information converted and provided for each year-month.
In this example, our user doesn’t have any privilege to create the view, so we need to grant create view to the user.*/


SELECT e.emp_id, e.emp_name, d.dept_name dept, TO_CHAR(s.sal_date, 'YYYY-MM') year_month, TO_CHAR(SUM(s.sal_val + s.sal_bonus), '$9,999.00') tot_sal
FROM employee e, department d, salary s
WHERE e.emp_id = s.emp_id AND d.dept_id = s.dept_id AND d.dept_id = 19001
GROUP BY s.sal_date, e.emp_id, e.emp_name, d.dept_name
ORDER BY tot_sal DESC;

-- 위의 예시를 VIEW로 보고 싶으나 현 유저는 권한이 없음

disc;
conn system/abc;
GRANT CREATE VIEW TO user_1;
-- user_1에게 VIEW를 만들 수 있는 권한 부여

disc;
conn user_1/abc;



CREATE VIEW AccDeptSalary AS
SELECT e.emp_id, e.emp_name, d.dept_name dept, TO_CHAR(s.sal_date, 'YYYY-MM') year_month, TO_CHAR(SUM(s.sal_val + s.sal_bonus), '$9,999.00') tot_sal
FROM employee e, department d, salary s
WHERE e.emp_id = s.emp_id AND d.dept_id = s.dept_id AND d.dept_id = 19001
GROUP BY s.sal_date, e.emp_id, e.emp_name, d.dept_name
ORDER BY tot_sal DESC;
-- 위와 똑같은 내용을 AccDeptSalary라는 이름의 view에 저장


SELECT * FROM AccDeptSalary;
-- view를 불러오면 저장된 내용대로 테이블을 불러옴
