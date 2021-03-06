# Oracle 10g XE 설치



# cmd 실행
'sqlplus' 입력
user-name: system
password: abc
# system은 기본관리자 계정



# 사용자 생성
create user user_1 identified by abc;
-- user_1이라는 이름의 사용자를 생성, 비밀번호는 abc

grant connect to user_1;
grant resource to user_1;
-- user_1에게 connect와 resource에 대한 권한 부여, 필수!




# 사용자 연결/해제
disc
-- 현재 연결된 사용자로부터 로그아웃
conn user_1;
--user_1 사용자로 로그인




# 테이블 생성
create table student( -- 테이블 이름이 student
id number(6),           -- id 열 생성, 6자리 정수
name varchar2(20),    -- name 열, 20자리 텍스트
gender char(1),         -- gender, 1자리 텍스트
address varchar2(20)
);

describe student;
-- student 테이블 스키마 // 열 이름, isNull?, Type



# insert
insert into student(id, name, gender, address) values (201901, 'Jackie', 'M', 'China');
/* student 테이블의 (id, name, gender, address) 열에 각각
values 뒤의 값들을 삽입 */

insert into student(id, name, gender, address) values (201902, 'Isabella', 'F', 'Spain');
insert into student(id, name, gender, address) values (201903, 'Sofia', 'F', 'Turkey');
insert into student(id, name, gender, address) values (201904, 'Jisung', 'M', 'Korea');

# select
select id, name from student;
-- student 테이블의 id, name 열의 레코드 조회
