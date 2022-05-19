##### table manipulation #####
# create a table
create table test(
testid number(10) not null,  -- not null 조건은 반드시 해당 열에 값이 입력돼야 함
testname varchar2(100) not null,
constraints testpk primary key (testid)
-- testpk라는 이름의 제약조건 생성, 내용은 testid 열을 primary key 설정
);

describe test;



# modify a table schema
alter table test add (testdate date not null);
-- test 테이블에 testdate라는 열을 추가, testdate는 date 형식에 not null일 것
alter table test modify (testname varchar2(40));
-- test 테이블의 testname 열을 varchar2(40) 조건으로 수정

describe test;



# delete a table
drop table test;
-- test라는 테이블 통째로 삭제

select * from tab;
-- 조회 가능한 모든 테이블 조회






##### data manipulation #####
# insert data
create table test(
testid number(10) not null,
testname varchar2(100) not null,
constraints testpk primary key (testid)
);


insert into test values (1, 'TOEFL');
-- test 뒤에 (열 이름) 안쓰면 모든 열에 데이터 입력

insert into test (testid, testname) values (2, 'IELTS');
-- (열 이름) 쓰면 특정 열에만 입력




# select data
select * from test;
-- test 테이블의 모든 레코드 조회

select testname from test;
-- test 테이블의 testname 열의 값들 조회

select testname from test where testid = 1;
-- where문으로 조건을 걸어줌
-- test 테이블로부터 가져오니 조건은 testid를 걸고 조회는 testname을 하는게 가능




# update data
update test set testname = 'TOEIC' where testid = 1;
-- test 테이블에 testname을 'TOEIC으로 업데이트, 조건은 testid = 1인 레코드
select * from test;




# delete data
delete from test where testid = 1;
-- test 테이블에서 testid = 1인 레코드 삭제
select * from test;





#### rollback, commit #####
-- commit이란, 트랜잭션(insert, update, delete)을 확정하고 저장
-- rollback이란, ctrl + z와 같은 기능으로 트랜잭션들을 이전 commit까지로 되돌림


# rollback ex.
create table test(
testid number(10) not null,
testname varchar2(100) not null,
constraints testpk primary key (testid)
);

insert into test values (1, 'TOEFL');
insert into test values (2, 'IELTS');
update test set testname = 'TOEIC' where testid = 1;
update test set testname = 'TOEIC';
delete from test where testid = 1;

select * from test;

rollback;
-- 여기서 롤백하면 트랜잭션들 다 날라감
-- test 테이블 생성한 시점에 commit 됨, 그 이후의 것들 다 날라감
select * from test;
-- 레코드들 다 날아가고 테이블만 살아있음



# commit ex.

insert into test values (1, 'TOEFL');
insert into test values (2, 'IELTS');
commit;
-- commit을 해주면 sql 껐다 켜도 그대로 저장돼있음
-- commit은 DDL, DCL을 수행하면 자동으로 적용


# commit syntax
show autocommit;
-- autocommit 여부 조회
set autocommit on;
set autocommit off;
-- 켜고 끌 수 있음





##### constraint #####
-- 제약조건은 테이블을 생성할 때 넣어주거나, 후에 alter table로 수정해줄 수 있다

# not null
특정 컬럼에 값이 항상 들어가도록 하는 조건
create table test(
testid number(10) not null
);
or
alter table test modify (testid number(10) not null);

# unique
해당 열에 들어갈 값이 모든 테이블에 대해 unique 한 값이도록 제약
create table test(
testid number(10) unique
);
or
alter table test modify (testid number(10) unique);


# primary key
테이블의 주키, 주키를 통해 레코드들을 구별함
create table test(
testid number(10) unique,
constraints testpk primary key (testid)
);
or
alter table test add constraints testpk primary key (testid);


# foreign key
테이블 간을 연결해주는 키
create table testplace(
testID number(10) not null,
constraints testIDFK foreign key (testID) references test (testid)
-- testIDFK라는 이름의 제약조건 생성
-- 조건 내용은 testID 열을 외래키로 지정하는 것
-- 해당 값은 test 테이블의 testid로부터 가져옴
);
or
alter table testplace add constraints testIDFK foreign key (testID) references test (testid);


# check
테이블의 각 레코드가 조건을 만족하는지를 검사해줌
create table users(
gender char(1),
constraints checkgender check (gender in ('M', 'F'))
);
or
alter table users add constraints checkgender check (gender in ('M', 'F'));

insert into users (gender) values ('M');
insert into users (gender) values ('F');
insert into users (gender) values ('X');


# default
레코드의 기본값을 미리 설정해줌
create table users(
gender char(1),
birthdate date default '01-JAN-1900'
);
or
alter table users modify (birthdate date default '01-FEB-1950');
