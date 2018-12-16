DROP TABLE ENROLLMENT CASCADE CONSTRAINTS;
DROP TABLE SECTION CASCADE CONSTRAINTS;

CREATE TABLE SECTION(
 SectionID 	CHAR(5),
 Course	VARCHAR2(7),
 Students	NUMBER DEFAULT 0,
 CONSTRAINT PK_SECTION 
		PRIMARY KEY (SectionID)
);

CREATE TABLE ENROLLMENT(
 SectionID	CHAR(5),
 StudentID	CHAR(7),
 CONSTRAINT PK_ENROLLMENT 
		PRIMARY KEY (SectionID, StudentID),
 CONSTRAINT FK_ENROLLMENT_SECTION 
		FOREIGN KEY (SectionID)
		REFERENCES SECTION (SectionID)
);
 
INSERT INTO SECTION (SectionID, Course) VALUES ( '12345', 'CSC 355' );
INSERT INTO SECTION (SectionID, Course) VALUES ( '22109', 'CSC 309' );
INSERT INTO SECTION (SectionID, Course) VALUES ( '99113', 'CSC 300' );
INSERT INTO SECTION (SectionID, Course) VALUES ( '99114', 'CSC 300' );


SET SERVEROUTPUT ON;


CREATE OR REPLACE TRIGGER maxStudents
BEFORE INSERT ON ENROLLMENT
FOR EACH ROW
DECLARE
    numStudents NUMBER;
BEGIN

    BEGIN
        SELECT Students INTO numStudents FROM Section WHERE SECTION.SECTIONID = :new.SECTIONID;
    END;
    
IF numStudents >= 5 THEN --The reason it's >= 5 is cause the table pulls old data before doing the trigger
    RAISE_APPLICATION_ERROR(-20200, 'Section is full');
    ELSE
        UPDATE SECTION SET STUDENTS = numStudents + 1 WHERE SECTIONID = :new.SECTIONID;
    END IF;
END;
/


CREATE OR REPLACE TRIGGER deletion
AFTER DELETE ON ENROLLMENT
FOR EACH ROW
DECLARE
    sectionNumber CHAR(5);
BEGIN
   sectionNumber := :old.sectionID;
 UPDATE SECTION SET STUDENTS = (STUDENTS - 1) WHERE SECTIONID = sectionNumber;
END;
/

CREATE OR REPLACE TRIGGER NoChanges
BEFORE UPDATE ON ENROLLMENT
BEGIN
RAISE_APPLICATION_ERROR(-20201, 'Update is not allowed ENROLLMENT');
END;
/

COMMIT;

INSERT INTO ENROLLMENT VALUES ('12345', '1234567');
INSERT INTO ENROLLMENT VALUES ('12345', '2234567');
INSERT INTO ENROLLMENT VALUES ('12345', '3234567');
INSERT INTO ENROLLMENT VALUES ('12345', '4234567');
INSERT INTO ENROLLMENT VALUES ('12345', '5234567');

INSERT INTO ENROLLMENT VALUES ('12345', '6234567');


SELECT SectionID FROM ENROLLMENT WHERE StudentID = '1234567';

DELETE FROM ENROLLMENT WHERE StudentID = '1234567';

UPDATE Enrollment
SET StudentID = '7654321'
WHERE StudentID = '4234567';


SELECT * FROM SECTION;
SELECT * FROM ENROLLMENT;