-- Digital Attendance Management System
-- Table Creation Script

CREATE TABLE students OF student_t (
  userId PRIMARY KEY
);

CREATE TABLE instructors OF instructor_t (
  userId PRIMARY KEY
);

CREATE TABLE administrators OF administrator_t (
  userId PRIMARY KEY
);

CREATE TABLE programs OF program_t (
  CONSTRAINT pk_program PRIMARY KEY (programId)
);

CREATE TABLE courses OF course_t (
  CONSTRAINT pk_course PRIMARY KEY (courseId),
  CONSTRAINT uq_course_code UNIQUE (code)
);

CREATE TABLE classrooms OF classroom_t (
  CONSTRAINT pk_classroom PRIMARY KEY (roomNumber, buildingName)
);

CREATE TABLE devices OF device_t (
  CONSTRAINT pk_device PRIMARY KEY (deviceId)
);

CREATE TABLE course_sections OF course_section_t (
  CONSTRAINT pk_section PRIMARY KEY (sectionId),
  SCOPE FOR (courseRef) IS courses,
  SCOPE FOR (classroomRef) IS classrooms
);

CREATE TABLE course_sessions OF course_session_t (
  CONSTRAINT pk_session PRIMARY KEY (sessionId),
  SCOPE FOR (sectionRef) IS course_sections
);

CREATE TABLE enrollments OF enrollment_t (
  CONSTRAINT pk_enrollment PRIMARY KEY (enrollmentId),
  SCOPE FOR (studentRef) IS students,
  SCOPE FOR (sectionRef) IS course_sections
);

CREATE TABLE attendance_records OF attendance_record_t (
  CONSTRAINT pk_att PRIMARY KEY (attendanceId),
  SCOPE FOR (createdBy) IS devices,
  SCOPE FOR (sessionRef) IS course_sessions,
  SCOPE FOR (studentRef) IS students
);