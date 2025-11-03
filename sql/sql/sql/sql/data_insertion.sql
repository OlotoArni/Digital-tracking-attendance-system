-- Digital Attendance Management System
-- Sample Data Insertion Script

-- 3.1. Student Data
INSERT INTO students VALUES (student_t(1001, 'That Suon', 'that@yorku.ca', 'Student', SYSDATE-60, SYSDATE-1, 5001, 'Active', SYSDATE-365));
INSERT INTO students VALUES (student_t(1002, 'Jack Lin', 'jack@yorku.ca', 'Student', SYSDATE-120, SYSDATE-5, 5002, 'Active', SYSDATE-200));
INSERT INTO students VALUES (student_t(1003, 'Olashubomi Rufai', 'Olashubomi@yorku.ca', 'Student', SYSDATE-90, SYSDATE-2, 5003, 'Expired', SYSDATE-400));
INSERT INTO students VALUES (student_t(1004, 'Joshua Tony', 'Joshua@yorku.ca', 'Student', SYSDATE-80, SYSDATE-2, 5004, 'Expired', SYSDATE-500));
INSERT INTO students VALUES (student_t(1005, 'Oloto Ami', 'oloto@yorku.ca', 'Student', SYSDATE-70, SYSDATE-2, 5005, 'Expired', SYSDATE-600));

-- 3.2. Instructor Data
INSERT INTO instructors VALUES (instructor_t(2001, 'Prof. Marina Erechtchoukova', 'marina@yorku.ca', 'Instructor', SYSDATE-900, SYSDATE-2, 3001, 2));

-- 3.3. Administrator Data
INSERT INTO administrators VALUES (administrator_t(3002, 'Sam Brook', 'sam@yorku.ca', 'Administrator', SYSDATE-500, SYSDATE-1, 4001, 'Device'));

-- 3.4. Programs Data
INSERT INTO programs VALUES (program_t(5001, 'Liberal Arts and Professional Studies', 'ITEC', 4, 220));
INSERT INTO programs VALUES (program_t(5002, 'Lassonde', 'ENG', 4, 95));
INSERT INTO programs VALUES (program_t(5003, 'Science', 'DATA SCI', 2, 130));

-- 3.5. Courses Data
INSERT INTO courses VALUES (course_t(6001, 'ITEC4220', 'Database Management Systems', NULL));
INSERT INTO courses VALUES (course_t(6002, 'ITEC4010', 'Systems Analysis and Design', NULL));
INSERT INTO courses VALUES (course_t(6003, 'ITEC4101', 'Business Integration Technologies', NULL));

-- 3.6. Classrooms Data
INSERT INTO classrooms VALUES (classroom_t(2110, 'DB'));
INSERT INTO classrooms VALUES (classroom_t(204, 'ACW'));
INSERT INTO classrooms VALUES (classroom_t(310, 'ACE'));

-- 3.7. Devices Data
INSERT INTO devices VALUES (device_t(8001, 'SN-A1', 'Connected', SYSDATE-50));
INSERT INTO devices VALUES (device_t(8002, 'SN-A2', 'Disconnected', SYSDATE-40));
INSERT INTO devices VALUES (device_t(8003, 'SN-A3', 'Connected', SYSDATE-35));

-- 3.8. CourseSections Data
INSERT INTO course_sections
SELECT course_section_t(7001, 'A', DATE '2025-09-01', DATE '2025-12-15', 50, 2, REF(c), REF(cl))
FROM courses c, classrooms cl
WHERE c.courseId = 6001 AND cl.roomNumber = 2110 AND cl.buildingName = 'DB';

INSERT INTO course_sections
SELECT course_section_t(7002, 'B', DATE '2025-09-01', DATE '2025-12-15', 35, 1, REF(c), REF(cl))
FROM courses c, classrooms cl
WHERE c.courseId = 6002 AND cl.roomNumber = 204 AND cl.buildingName = 'ACW';

INSERT INTO course_sections
SELECT course_section_t(7003, 'A', DATE '2025-09-01', DATE '2025-12-15', 40, 0, REF(c), REF(cl))
FROM courses c, classrooms cl
WHERE c.courseId = 6003 AND cl.roomNumber = 310 AND cl.buildingName = 'ACE';

-- 3.9. CourseSessions Data
INSERT INTO course_sessions
SELECT course_session_t(9001, DATE '2025-09-15', '09:00', '10:30', 'Open', REF(cs))
FROM course_sections cs WHERE cs.sectionId = 7001;

INSERT INTO course_sessions
SELECT course_session_t(9002, DATE '2025-09-22', '09:00', '10:30', 'Open', REF(cs))
FROM course_sections cs WHERE cs.sectionId = 7001;

INSERT INTO course_sessions
SELECT course_session_t(9003, DATE '2025-09-15', '13:00', '14:30', 'Open', REF(cs))
FROM course_sections cs WHERE cs.sectionId = 7002;

-- 3.10. Enrollments (Student-Section) Data
INSERT INTO enrollments
SELECT enrollment_t(10001, 'Active', SYSDATE-10, NULL, NULL, REF(u), REF(cs))
FROM students u, course_sections cs
WHERE u.userId = 1001 AND cs.sectionId = 7001;

INSERT INTO enrollments
SELECT enrollment_t(10002, 'Active', SYSDATE-8, NULL, NULL, REF(u), REF(cs))
FROM students u, course_sections cs
WHERE u.userId = 1002 AND cs.sectionId = 7001;

INSERT INTO enrollments
SELECT enrollment_t(10003, 'Active', SYSDATE-7, NULL, NULL, REF(u), REF(cs))
FROM students u, course_sections cs
WHERE u.userId = 1001 AND cs.sectionId = 7002;

-- 3.11. AttendanceRecord Data
INSERT INTO attendance_records
SELECT attendance_record_t(11001, 'Present', SYSDATE, REF(d), REF(sess), REF(u))
FROM devices d, course_sessions sess, students u
WHERE d.deviceId = 8001 AND sess.sessionId = 9001 AND u.userId = 1001;

INSERT INTO attendance_records
SELECT attendance_record_t(11002, 'Late', SYSDATE, REF(d), REF(sess), REF(u))
FROM devices d, course_sessions sess, students u
WHERE d.deviceId = 8001 AND sess.sessionId = 9001 AND u.userId = 1002;

INSERT INTO attendance_records
SELECT attendance_record_t(11003, 'Absent', SYSDATE, REF(d), REF(sess), REF(u))
FROM devices d, course_sessions sess, students u
WHERE d.deviceId = 8003 AND sess.sessionId = 9003 AND u.userId = 1001;

COMMIT;