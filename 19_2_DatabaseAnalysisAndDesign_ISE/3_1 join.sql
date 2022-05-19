CREATE TABLE student(
student_id NUMBER(10) NOT NULL,
name VARCHAR2(100) NOT NULL,
address VARCHAR2(100),
phone VARCHAR2(40),
CONSTRAINTS studentPK PRIMARY KEY (student_id)
);

INSERT INTO student VALUES (201412001, 'Mr. Kim', 'Junggu', '0101112');
INSERT INTO student VALUES (201412002, 'Mr. Park', 'Itaewon', '0101113');
INSERT INTO student VALUES (201412007, 'Mr. Lee', 'Incheon', '09876');



CREATE TABLE course(
course_id NUMBER(10) not null,
name_course VARCHAR2(100) not null,
CONSTRAINTS coursePK PRIMARY KEY (course_id)
);

INSERT INTO course VALUES (1, 'Programming');
INSERT INTO course VALUES (2, 'Calculus');
INSERT INTO course VALUES (3, 'Operation Research');
INSERT INTO course VALUES (4, 'Data Mining');


CREATE TABLE grade(
student_id NUMBER(10) NOT NULL,
course_id NUMBER(10) NOT NULL,
grade_val CHAR(1),
CONSTRAINTS gradeFKstudent FOREIGN KEY (student_id) REFERENCES student(student_id),
CONSTRAINTS gradeFKcourse FOREIGN KEY (course_id) REFERENCES course (course_id)
);
-- gradeFKstudent라는 이름의 외래키 제약조건 설정
-- grade 테이블의 student_id는 student 테이블의 student_id를 참조한다


INSERT INTO grade VALUES (201412001, 1, 'A');
INSERT INTO grade VALUES (201412001, 2, 'B');
INSERT INTO grade VALUES (201412001, 4, 'A');
INSERT INTO grade VALUES (201412002, 2, 'A');
INSERT INTO grade VALUES (201412002, 4, 'B');
INSERT INTO grade VALUES (201412007, 3, 'B');




# join
SELECT student.student_id, student.name, course.name_course, grade.grade_val
FROM student, course, grade 
WHERE student.student_id = grade.student_id AND course.course_id = grade.course_id;



# grade 테이블에 PK를 주려면?
-- composite pk
ALTER TABLE grade ADD CONSTRAINTS gradePK PRIMARY KEY (student_id, course_id);
or
-- surrogate key (grade_id)
