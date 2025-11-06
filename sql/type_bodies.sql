-- Type Body Implementations
-- Student Type Body
CREATE TYPE BODY student_t AS
  MEMBER FUNCTION isValidForScan RETURN CHAR IS
  BEGIN
    IF status = 'Active' AND issuedAt <= SYSDATE THEN
      RETURN 'Y';
    ELSE
      RETURN 'N';
    END IF;
  END;

  OVERRIDING MEMBER FUNCTION roleTag RETURN VARCHAR2 IS
  BEGIN
    RETURN '[STUDENT #' || studentId || '] ' || name;
  END;
END;
/

-- Instructor Type Body
CREATE TYPE BODY instructor_t AS
  MEMBER FUNCTION hasCourses RETURN CHAR IS
  BEGIN
    IF NVL(coursesTaught, 0) > 0 THEN 
      RETURN 'Y'; 
    ELSE 
      RETURN 'N'; 
    END IF;
  END;

  OVERRIDING MEMBER FUNCTION roleTag RETURN VARCHAR2 IS
  BEGIN
    RETURN '[INSTR ' || instructorId || '] ' || name;
  END;
END;
/

-- Administrator Type Body
CREATE TYPE BODY administrator_t AS
  MEMBER FUNCTION canManageDevice RETURN CHAR IS
  BEGIN
    IF permission IN ('Device', 'Full') THEN 
      RETURN 'Y'; 
    ELSE 
      RETURN 'N'; 
    END IF;
  END;

  OVERRIDING MEMBER FUNCTION roleTag RETURN VARCHAR2 IS
  BEGIN
    RETURN '[ADMIN ' || permission || '] ' || name;
  END;
END;
/

-- Program Type Body
CREATE TYPE BODY program_t AS
  MEMBER FUNCTION isLargeProgram RETURN CHAR IS
  BEGIN
    IF NVL(studentCount, 0) >= 100 THEN 
      RETURN 'Y'; 
    ELSE 
      RETURN 'N'; 
    END IF;
  END;

  ORDER MEMBER FUNCTION compare (rhs IN program_t) RETURN INTEGER IS
  BEGIN
    IF self.studentCount < rhs.studentCount THEN 
      RETURN -1;
    ELSIF self.studentCount > rhs.studentCount THEN 
      RETURN 1;
    ELSE
      IF self.programName < rhs.programName THEN 
        RETURN -1;
      ELSIF self.programName > rhs.programName THEN 
        RETURN 1;
      ELSE 
        RETURN 0;
      END IF;
    END IF;
  END;
END;
/

-- Course Type Body
CREATE TYPE BODY course_t AS
  MAP MEMBER FUNCTION map_key RETURN VARCHAR2 IS
  BEGIN
    RETURN UPPER(code) || ' - ' || NVL(title, '');
  END;
END;
/

-- Classroom Type Body
CREATE TYPE BODY classroom_t AS
  MEMBER FUNCTION showClassLocation RETURN VARCHAR2 IS
  BEGIN
    RETURN buildingName || ' / Rm ' || roomNumber;
  END;
END;
/

-- Device Type Body
CREATE TYPE BODY device_t AS
  MEMBER FUNCTION isConnected RETURN CHAR IS
  BEGIN
    RETURN CASE WHEN status = 'Connected' THEN 'Y' ELSE 'N' END;
  END;
END;
/

-- CourseSection Type Body
CREATE TYPE BODY course_section_t AS
  MEMBER PROCEDURE setSeatCount (newCap IN NUMBER) IS
  BEGIN
    sectionCapacity := newCap;
  END;

  MEMBER FUNCTION seatsLeft RETURN NUMBER IS
  BEGIN
    RETURN NVL(sectionCapacity, 0) - NVL(currentEnrollment, 0);
  END;
END;
/

-- CourseSession Type Body
CREATE TYPE BODY course_session_t AS
  MEMBER FUNCTION isOpenNow RETURN CHAR IS
  BEGIN
    RETURN CASE WHEN sessionState = 'Open' THEN 'Y' ELSE 'N' END;
  END;
END;
/

-- Enrollment Type Body
CREATE TYPE BODY enrollment_t AS
  MEMBER FUNCTION isActive RETURN CHAR IS
  BEGIN
    RETURN CASE WHEN status = 'Active' THEN 'Y' ELSE 'N' END;
  END;
END;
/

-- AttendanceRecord Type Body
CREATE TYPE BODY attendance_record_t AS
  MEMBER FUNCTION isPresent RETURN CHAR IS
  BEGIN
    RETURN CASE WHEN status = 'Present' THEN 'Y' ELSE 'N' END;
  END;
END;
/