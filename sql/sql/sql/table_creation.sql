-- Digital Attendance Management System
-- Table Creation Script

-- Create object table for students objects
CREATE TABLE students OF student_t (
  userId PRIMARY KEY
);

-- Create object table for instructor objects
CREATE TABLE instructors OF instructor_t (
  userId PRIMARY KEY
);

-- Create object table for administrator objects
CREATE TABLE administrators OF administrator_t (
  userId PRIMARY KEY
);

-- Create object table for program objects with PK constraints
CREATE TABLE programs OF program_t (
  CONSTRAINT pk_program PRIMARY KEY (programId)
);

-- Create object table for Course objects and ensure no duplicate course codes
CREATE TABLE courses OF course_t (
  CONSTRAINT pk_course PRIMARY KEY (courseId),
  CONSTRAINT uq_course_code UNIQUE (code)
);

-- Create object table for classroom objects with composite primary key
CREATE TABLE classrooms OF classroom_t (
  CONSTRAINT pk_classroom PRIMARY KEY (roomNumber, buildingName)
);

-- Create object table for device objects
CREATE TABLE devices OF device_t (
  CONSTRAINT pk_device PRIMARY KEY (deviceId)
);

-- Create object table for CourseSections objects
CREATE TABLE course_sections OF course_section_t (
  CONSTRAINT pk_section PRIMARY KEY (sectionId),
  SCOPE FOR (courseRef) IS courses,
  SCOPE FOR (classroomRef) IS classrooms
);

-- Create object table for CourseSession objects
CREATE TABLE course_sessions OF course_session_t (
  CONSTRAINT pk_session PRIMARY KEY (sessionId),
  SCOPE FOR (sectionRef) IS course_sections
);

-- Create object table for Enrollment objects
CREATE TABLE enrollments OF enrollment_t (
  CONSTRAINT pk_enrollment PRIMARY KEY (enrollmentId),
  SCOPE FOR (studentRef) IS students,
  SCOPE FOR (sectionRef) IS course_sections
);

-- Create object table for AttendanceRecord objects
CREATE TABLE attendance_records OF attendance_record_t (
  CONSTRAINT pk_att PRIMARY KEY (attendanceId),
  SCOPE FOR (createdBy) IS devices,
  SCOPE FOR (sessionRef) IS course_sessions,
  SCOPE FOR (studentRef) IS students
);