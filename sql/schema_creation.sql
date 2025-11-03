-- Digital Attendance Management System
-- Schema Creation Script
-- Group 5: Jack Lin, Joshua Tony-Erwin, Olashubomi Rufai, Oloto Arni, That Suon

-- Supertype: User (Base type for all users)
CREATE TYPE user_t AS OBJECT (
  userId NUMBER,
  name VARCHAR2(100),
  email VARCHAR2(100),
  role VARCHAR2(20),
  createdAt DATE,
  updatedAt DATE,
  MEMBER FUNCTION hasValidEmail RETURN CHAR,
  MEMBER FUNCTION roleTag RETURN VARCHAR2
) NOT FINAL;
/

-- Subtype: Student UNDER User
CREATE TYPE student_t UNDER user_t (
  studentId NUMBER,
  status VARCHAR2(10),
  issuedAt DATE,
  MEMBER FUNCTION isValidForScan RETURN CHAR,
  OVERRIDING MEMBER FUNCTION roleTag RETURN VARCHAR2
);
/

-- Subtype: Instructor UNDER User
CREATE TYPE instructor_t UNDER user_t (
  instructorId NUMBER,
  coursesTaught NUMBER,
  MEMBER FUNCTION hasCourses RETURN CHAR,
  OVERRIDING MEMBER FUNCTION roleTag RETURN VARCHAR2
);
/

-- Subtype: Administrator UNDER User
CREATE TYPE administrator_t UNDER user_t (
  adminId NUMBER,
  permission VARCHAR2(20),
  MEMBER FUNCTION canManageDevice RETURN CHAR,
  OVERRIDING MEMBER FUNCTION roleTag RETURN VARCHAR2
);
/

-- Program (ORDER method)
CREATE TYPE program_t AS OBJECT (
  programId NUMBER,
  faculty VARCHAR2(100),
  programName VARCHAR2(100),
  durationYears NUMBER,
  studentCount NUMBER,
  MEMBER FUNCTION isLargeProgram RETURN CHAR,
  ORDER MEMBER FUNCTION compare (rhs IN program_t) RETURN INTEGER
);
/

-- Course (MAP method)
CREATE TYPE course_t AS OBJECT (
  courseId NUMBER,
  code VARCHAR2(16),
  title VARCHAR2(100),
  codeWithTitle VARCHAR2(140),
  MAP MEMBER FUNCTION map_key RETURN VARCHAR2
);
/

-- Classroom
CREATE TYPE classroom_t AS OBJECT (
  roomNumber NUMBER,
  buildingName VARCHAR2(25),
  MEMBER FUNCTION showClassLocation RETURN VARCHAR2
);
/

-- Device
CREATE TYPE device_t AS OBJECT (
  deviceId NUMBER,
  serialNum VARCHAR2(40),
  status VARCHAR2(16),
  registeredAt DATE,
  MEMBER FUNCTION isConnected RETURN CHAR
);
/

-- CourseSection
CREATE TYPE course_section_t AS OBJECT (
  sectionId NUMBER,
  sectionCode VARCHAR2(8),
  startOn DATE,
  endOn DATE,
  sectionCapacity NUMBER,
  currentEnrollment NUMBER,
  courseRef REF course_t,
  classroomRef REF classroom_t,
  MEMBER PROCEDURE setSeatCount (newCap IN NUMBER),
  MEMBER FUNCTION seatsLeft RETURN NUMBER
);
/

-- CourseSession
CREATE TYPE course_session_t AS OBJECT (
  sessionId NUMBER,
  classDate DATE,
  startTime VARCHAR2(5),
  endTime VARCHAR2(5),
  sessionState VARCHAR2(10),
  sectionRef REF course_section_t,
  MEMBER FUNCTION isOpenNow RETURN CHAR
);
/

-- Enrollment (Association: Student ↔ CourseSection)
CREATE TYPE enrollment_t AS OBJECT (
  enrollmentId NUMBER,
  status VARCHAR2(12),
  enrolledAt DATE,
  droppedAt DATE,
  grade VARCHAR2(2),
  studentRef REF student_t,
  sectionRef REF course_section_t,
  MEMBER FUNCTION isActive RETURN CHAR
);
/

-- AttendanceRecord
CREATE TYPE attendance_record_t AS OBJECT (
  attendanceId NUMBER,
  status VARCHAR2(8),
  recordedAt DATE,
  createdBy REF device_t,
  sessionRef REF course_session_t,
  studentRef REF student_t,
  MEMBER FUNCTION isPresent RETURN CHAR
);
/