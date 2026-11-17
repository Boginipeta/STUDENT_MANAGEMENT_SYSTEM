create database student_project;
use student_project;

create table students (
student_id int auto_increment primary key,
name varchar(100),
age int,
gender varchar(100)
);
insert into students(name, age, gender) values
('Arjun', 22, 'Male'),
('Nayana', 21, 'Female'),
('Divya', 20, 'Female');
select * from students;

create table courses (
course_id int auto_increment primary key,
course_name varchar(100),
credits int
);
insert into courses(course_name, credits) values
('Database Systems', 4),
('Python Programming', 3),
('Statistics', 4),
('Machine Learning', 5);
select * from courses;

create table enrollment(
enroll_id int auto_increment primary key,
student_id int,
course_id int,
enroll_date date,
unique(student_id, course_id),
foreign key(student_id) references students(student_id)
);
insert into enrollment(student_id, course_id, enroll_date) values
(1, 1, '2024-01-15'),
(1, 2, '2024-01-16'),
(2, 1, '2024-01-15'),
(3, 3, '2024-01-20');
select * from enrollment;

create table exams (
exam_id int auto_increment primary key,
student_id int,
course_id int,
exam_date date,
foreign key(student_id) references students(student_id),
foreign key(course_id) references courses(course_id)
);
insert into exams (student_id, course_id, exam_date) values
(1, 1, '2024-02-20'),
(1, 2, '2024-02-21'),
(2, 1, '2024-02-20'),
(3, 4, '2024-02-25');
select * from exams;

create table result (
result_id int auto_increment primary key,
exam_id int,
marks int,
grade char(2),
foreign key(exam_id) references exams(exam_id)
);
insert into result (exam_id, marks, grade) values
(5, 85, 'A'),
(6, 78, 'B'),
(7, 95, 'A'),
(8, 65, 'C');
select * from result;

-- list all students
select * from students;

-- show all courses
select * from courses;

-- students enrolled in 'Database Syatems'
SELECT 
    s.student_id,
    s.name,
    c.course_name
FROM students s
JOIN enrollment e
    ON s.student_id = e.student_id
JOIN courses c
    ON e.course_id = c.course_id
WHERE c.course_name = 'Database Systems';

-- count total students enrolled in each course
SELECT 
    c.course_name,
    COUNT(e.student_id) AS total_students
FROM courses c
LEFT JOIN enrollment e
    ON c.course_id = e.course_id
GROUP BY c.course_name;

-- display exam marks with student  course
SELECT
    s.name,
    c.course_name,
    e.exam_date,
    r.marks,
    r.grade
FROM students s
JOIN exams e
    ON s.student_id = e.student_id
JOIN courses c
    ON e.course_id = c.course_id
JOIN result r
    ON e.exam_id = r.exam_id;
    
-- highest scoring student
SELECT
    s.name,
    c.course_name,
    r.marks
FROM students s
JOIN exams e
    ON s.student_id = e.student_id
JOIN courses c
    ON e.course_id = c.course_id
JOIN result r
    ON e.exam_id = r.exam_id
WHERE r.marks = (
    SELECT MAX(marks)
    FROM result
);

-- students not enrolled in any course
SELECT
    s.student_id,
    s.name
FROM students s
LEFT JOIN enrollment e
    ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

-- courses with no exams conducted 
SELECT
    c.course_id,
    c.course_name
FROM courses c
LEFT JOIN exams e
    ON c.course_id = e.course_id
WHERE e.exam_id IS NULL;

-- average marks per course
SELECT
    c.course_name,
    AVG(r.marks) AS average_marks
FROM courses c
JOIN exams e
    ON c.course_id = e.course_id
JOIN result r
    ON e.exam_id = r.exam_id
GROUP BY c.course_name;

-- students with grade 'A'
SELECT
    s.name,
    c.course_name,
    r.marks,
    r.grade
FROM students s
JOIN exams e
    ON s.student_id = e.student_id
JOIN courses c
    ON e.course_id = c.course_id
JOIN result r
    ON e.exam_id = r.exam_id
WHERE r.grade = 'A';

-- list exams conducted in February 
SELECT
    exam_id,
    student_id,
    course_id,
    exam_date
FROM exams
WHERE MONTH(exam_date) = 2;

-- convert marks to auto grade
SELECT
    exam_id,
    marks,
    CASE
        WHEN marks >= 90 THEN 'A'
        WHEN marks >= 80 THEN 'B'
        WHEN marks >= 70 THEN 'C'
        WHEN marks >= 60 THEN 'D'
        ELSE 'F'
    END AS auto_grade
FROM result;

-- show student with most enrollments
SELECT
    s.student_id,
    s.name,
    COUNT(e.course_id) AS total_enrollments
FROM students s
JOIN enrollment e
    ON s.student_id = e.student_id
GROUP BY s.student_id, s.name
ORDER BY total_enrollments DESC
LIMIT 1;