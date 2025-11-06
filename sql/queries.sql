-- Digital Attendance Management System
-- SQL Queries for Demonstration

-- 1. MAP method (Course.map_key) with ORDER BY VALUE(c)
SELECT VALUE(c)
FROM courses c
ORDER BY VALUE(c);

-- 2. ORDER method (Program.compare)
SELECT VALUE(p)
FROM programs p
ORDER BY VALUE(p);

-- 3. Supertype method override
SELECT s.name, s.roleTag() AS tag FROM students s
UNION ALL
SELECT i.name, i.roleTag() AS tag FROM instructors i
UNION ALL
SELECT a.name, a.roleTag() AS tag FROM administrators a;

-- 4. Validate student scan eligibility (Student.isValidForScan)
SELECT e.enrollmentId,
    TREAT(DEREF(e.studentRef) AS student_t).name AS student_name,
    TREAT(DEREF(e.studentRef) AS student_t).isValidForScan() AS ok_to_scan
FROM enrollments e;

-- 5. Sections with remaining seats (CourseSection.seatsLeft)
SELECT cs.sectionId,
    cs.sectionCode,
    DEREF(cs.courseRef).title AS course_title,
    cs.seatsLeft() AS seats_left
FROM course_sections cs;

-- 6. Open now sessions for a given course code
SELECT s.sessionId, s.classDate, s.startTime, s.endTime
FROM course_sessions s
WHERE s.isOpenNow() = 'Y'
  AND DEREF(s.sectionRef).courseRef IS NOT NULL
  AND DEREF(DEREF(s.sectionRef).courseRef).code = 'ITEC4220';

-- 7. Attendance taken by a connected device (Device.isConnected)
SELECT a.attendanceId,
    DEREF(a.createdBy).serialNum AS device_sn,
    DEREF(a.sessionRef).sessionId AS session_id,
    a.status
FROM attendance_records a
WHERE DEREF(a.createdBy).isConnected() = 'Y';

-- 8. Present students' names for a session
SELECT a.attendanceId,
    TREAT(DEREF(a.studentRef) AS student_t).name AS student_name
FROM attendance_records a
WHERE a.status = 'Present'
  AND DEREF(a.sessionRef).sessionId = 9001;

-- 9. Enrollment status + course code/title (multi-hop DEREF)
SELECT e.enrollmentId,
    e.status,
    DEREF(DEREF(e.sectionRef).courseRef).code AS course_code,
    DEREF(DEREF(e.sectionRef).courseRef).title AS course_title
FROM enrollments e;

-- 10. Programs labeled as large (Program.isLargeProgram)
SELECT p.programId, p.programName, p.studentCount, p.isLargeProgram() AS large
FROM programs p
ORDER BY VALUE(p);

-- 11. Classroom description from Section (Classroom.showClassLocation)
SELECT cs.sectionId,
    DEREF(cs.classroomRef).showClassLocation() AS location
FROM course_sections cs;

-- 12. Instructor(s) who currently teach courses (Instructor.hasCourses)
SELECT i.instructorId,
    i.name,
    i.hasCourses() AS has_courses
FROM instructors i;

-- 13. PROFESSOR'S QUERY
-- Find IDs and names of students who attended classes of section A of ITEC4220 course.
SELECT DISTINCT
    a.studentRef.studentId,
    a.studentRef.name
FROM attendance_records a
WHERE a.sessionRef.sectionRef.courseRef.code = 'ITEC4220'
    AND a.sessionRef.sectionRef.sectionCode = 'A';