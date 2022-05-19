##### DDL #####
# create
CREATE TABLE employee(
empid NUMBER(10) NOT NULL,
empname CHAR(25) NOT NULL
);

CREATE TABLE employee(
empid NUMBER(10) NOT NULL,
empname CHAR(25) NOT NULL,
CONSTRAINTS empPK PRIMARY KEY (empid)
);
-- 제약조건


CREATE TABLE employeeskill(
empid NUMBER(10) NOT NULL,
skillid NUMBER(10) NOT NULL,
skilllevel NUMBER(10) NOT NULL,
CONSTRAINTS empskillPK PRIMARY KEY (empid, skillid)
);

CRAETE TABLE employeeskill(
empid NUMBER(10) NOT NULL,
skillid NUMBER(10) NOT NULL,
skilllevel NUMBER(10) NULL,
CONSTRAINTS empskillPK PRIMARY KEY (empid, skillid),
CONSTRAINTS empFK FOREIGN KEY (empid) REFERENCES employee (empid),
CONSTRAINTS skillFK FOREIGN KEY (skillid) REFERENCES skill (skillid)
);
-- 외래키 제약조건

CRAETE TABLE employeeskill(
empid NUMBER(10) NOT NULL,
skillid NUMBER(10) NOT NULL,
skilllevel NUMBER(10) NULL,
CONSTRAINTS empskillPK PRIMARY KEY (empid, skillid),
CONSTRAINTS empFK FOREIGN KEY (empid) REFERENCES employee (empid) ON DELETE CASCADE,
CONSTRAINTS skillFK FOREIGN KEY (skillid) REFERENCES skill (skillid) ON UPDATE CASCADE
);
-- employee 테이블에서 한 레코드가 삭제되면 해당하는 empid 가진 employeeskill 테이블의 레코드도 자동 삭제 on delete cascade




# alter
ALTER TABLE employee ADD CONSTRAINTS empPK PRIMARY KEY (empid);

ALTER TABLE employeeskill ADD CONSTRAINTS skillPK PRIMARY KEY (empid, skillid);
-- composite PK 설정

ALTER TABLE employeeskill ADD CONSTRAINTS skillFK FOREIGN KEY (skillid) REFENCES skill (skillid);
-- 외래키 설정



# alter, add
ALTER TABLE project ADD CONSTRAINTS projectcheckdates CHECK (start < end);




# drop
DROP TABLE employee;
-- 테이블 영구히 삭제

ALTER TABLE employee DROP CONSTRAINTS empFK;
-- empFK라는 제약조건만 삭제




# SQL view
CREATE VIEW salesdepartment AS
	SELECT *
	FROM employee
	WHERE deptid = (SELECT deptid FROM department WHERE = deptname = 'sales');





##### DML #####
# insert
INSERT INTO employee (empid, empname) VALUES (1, 'John');


# update
UPDATE employee SET phone = '010-1234-6789' WHERE empid = 1;

UPDATE employee SET deptid = 4 WHERE empname LIKE 'LEE%';
-- empname이 LEE로 시작하는 사람

UPDATE employee SET deptid = 3;
-- 조건이 없으면 모든 데이터에 일괄 적용



# delete
DELETE FROM employee WHERE empid = 1;

DELETE FROM employee WHERE empname LIKE 'LEE%';

DELETE FROM employee;
-- 모든 레코드 일괄 삭제



# select
SELECT empname FROM employee WHERE empid = 1;

SELECT empname FROM employee;
-- 특정 열만 조회

SELECT empid, empname FROM employee;
-- 선택한 열만 조회

SELECT * FROM employee;
-- 모든 레코드 조회

SELECT DISTINCT deptid FROM employee;
-- unique 값만 반환


