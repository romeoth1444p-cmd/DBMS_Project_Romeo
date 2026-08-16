DROP DATABASE IF EXISTS school_management_system;
CREATE DATABASE school_management_system;
USE school_management_system;

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id      INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    date_of_birth   DATE         NOT NULL,
    gender          VARCHAR(10)  NOT NULL CHECK (gender IN ('Male', 'Female', 'Other')),
    email           VARCHAR(100) NOT NULL UNIQUE,
    phone           VARCHAR(15)  DEFAULT NULL,
    enrollment_date DATE         NOT NULL DEFAULT (CURRENT_DATE)
);

CREATE TABLE teachers (
    teacher_id      INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50)   NOT NULL,
    last_name       VARCHAR(50)   NOT NULL,
    email           VARCHAR(100)  NOT NULL UNIQUE,
    department      VARCHAR(50)   NOT NULL,
    hire_date       DATE          NOT NULL,
    salary          DECIMAL(10,2) NOT NULL CHECK (salary > 0)
);

CREATE TABLE courses (
    course_id       INT AUTO_INCREMENT PRIMARY KEY,
    course_name     VARCHAR(100) NOT NULL,
    credits         INT          NOT NULL CHECK (credits BETWEEN 1 AND 6),
    semester        VARCHAR(20)  NOT NULL DEFAULT 'Fall',
    teacher_id      INT          DEFAULT NULL,
    CONSTRAINT fk_courses_teacher
        FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE enrollments (
    enrollment_id   INT AUTO_INCREMENT PRIMARY KEY,
    student_id      INT  NOT NULL,
    course_id       INT  NOT NULL,
    enrollment_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    grade           VARCHAR(2) DEFAULT NULL CHECK (grade IN ('A', 'B', 'C', 'D', 'F') OR grade IS NULL),
    CONSTRAINT fk_enrollments_student
        FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_enrollments_course
        FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT uq_student_course UNIQUE (student_id, course_id)
);

INSERT INTO teachers (first_name, last_name, email, department, hire_date, salary) VALUES
('Anita',   'Sharma',   'anita.sharma@school.edu',   'Mathematics', '2015-06-01', 62000.00),
('Rajiv',   'Malhotra', 'rajiv.malhotra@school.edu', 'Science',     '2012-08-15', 68000.00),
('Priya',   'Menon',    'priya.menon@school.edu',    'English',     '2018-01-10', 54000.00),
('Suresh',  'Bhandari', 'suresh.bhandari@school.edu','Computer Science','2019-03-20', 71000.00),
('Kavita',  'Rai',      'kavita.rai@school.edu',     'Mathematics', '2020-09-05', 58000.00),
('Deepak',  'Gurung',   'deepak.gurung@school.edu',  'Social Studies','2016-11-11', 51000.00),
('Nisha',   'Thapa',    'nisha.thapa@school.edu',    'Science',     '2014-04-22', 66000.00),
('Alok',    'Verma',    'alok.verma@school.edu',     'Computer Science','2021-07-01', 73000.00);

INSERT INTO students (first_name, last_name, date_of_birth, gender, email, phone, enrollment_date) VALUES
('Arjun',   'Karki',    '2008-03-14', 'Male',   'arjun.karki@student.edu',   '9800011111', '2023-04-01'),
('Sita',    'Adhikari', '2008-07-22', 'Female', 'sita.adhikari@student.edu', '9800022222', '2023-04-01'),
('Manish',  'Shrestha', '2007-11-05', 'Male',   'manish.shrestha@student.edu','9800033333','2023-04-02'),
('Puja',    'Basnet',   '2008-01-19', 'Female', 'puja.basnet@student.edu',   '9800044444', '2023-04-02'),
('Bikash',  'Tamang',   '2007-09-30', 'Male',   'bikash.tamang@student.edu', '9800055555', '2023-04-03'),
('Sunita',  'Lama',     '2008-05-12', 'Female', 'sunita.lama@student.edu',   '9800066666', '2023-04-03'),
('Rohan',   'Poudel',   '2007-12-25', 'Male',   'rohan.poudel@student.edu',  '9800077777', '2023-04-04'),
('Anjali',  'Khadka',   '2008-02-08', 'Female', 'anjali.khadka@student.edu', '9800088888', '2023-04-04'),
('Kiran',   'Magar',    '2007-08-17', 'Male',   'kiran.magar@student.edu',   '9800099999', '2023-04-05'),
('Rita',    'Bista',    '2008-06-29', 'Female', 'rita.bista@student.edu',    '9800010101', '2023-04-05');

INSERT INTO courses (course_name, credits, semester, teacher_id) VALUES
('Algebra II',            4, 'Fall',   1),
('Physics I',              4, 'Fall',   2),
('English Literature',     3, 'Fall',   3),
('Introduction to Python', 4, 'Spring', 4),
('Calculus',               4, 'Spring', 1),
('World History',          3, 'Fall',   6),
('Chemistry',               4, 'Spring', 7),
('Database Systems',       3, 'Spring', 8);

INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES
(1, 1, '2023-08-01', 'A'),
(1, 4, '2024-01-15', 'B'),
(2, 1, '2023-08-01', 'B'),
(2, 3, '2023-08-02', 'A'),
(3, 2, '2023-08-01', 'C'),
(3, 4, '2024-01-15', 'A'),
(4, 3, '2023-08-02', 'A'),
(4, 6, '2023-08-03', 'B'),
(5, 2, '2023-08-01', 'D'),
(6, 4, '2024-01-15', 'A'),
(7, 5, '2024-01-16', 'B'),
(8, 6, '2023-08-03', 'C'),
(9, 7, '2024-01-16', NULL),
(10, 8, '2024-01-17', NULL);

SELECT student_id, first_name, last_name, date_of_birth, enrollment_date
FROM students
WHERE date_of_birth > '2007-12-31'
ORDER BY enrollment_date DESC
LIMIT 5;

SELECT c.course_id, c.course_name, COUNT(e.student_id) AS total_students
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.student_id) >= 2
ORDER BY total_students DESC;

SELECT teacher_id, first_name, last_name, department, salary
FROM teachers
WHERE salary > (
    SELECT AVG(salary) FROM teachers
)
ORDER BY salary DESC;

SELECT c.course_name, c.semester, t.first_name, t.last_name, t.department
FROM courses c
INNER JOIN teachers t ON c.teacher_id = t.teacher_id
ORDER BY c.semester, c.course_name;

SELECT s.student_id, s.first_name, s.last_name, c.course_name, e.grade
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN courses c ON e.course_id = c.course_id
ORDER BY s.student_id;

UPDATE students
SET email = 'arjun.karki.new@student.edu'
WHERE student_id = 1;

DELETE FROM enrollments
WHERE student_id = 5 AND course_id = 2;


 