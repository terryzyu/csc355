DROP TABLE STUDENT CASCADE CONSTRAINTS;
CREATE TABLE STUDENT(
	ID		CHAR(3),
	Name		VARCHAR2(20),
	Midterm	NUMBER(3,0) 	CHECK (Midterm>=0 AND Midterm<=100),
	Final		NUMBER(3,0)	CHECK (Final>=0 AND Final<=100),
	Homework	NUMBER(3,0)	CHECK (Homework>=0 AND Homework<=100),
	PRIMARY KEY (ID)
);
INSERT INTO STUDENT VALUES ( '445', 'Seinfeld', 85, 90, 99 );
INSERT INTO STUDENT VALUES ( '909', 'Costanza', 74, 72, 86 );
INSERT INTO STUDENT VALUES ( '123', 'Benes', 93, 89, 91 );
INSERT INTO STUDENT VALUES ( '111', 'Kramer', 99, 91, 93 );
INSERT INTO STUDENT VALUES ( '667', 'Newman', 78, 82, 83 );
INSERT INTO STUDENT VALUES ( '888', 'Banya', 50, 65, 50 );
SELECT * FROM STUDENT;

DROP TABLE WEIGHTS CASCADE CONSTRAINTS;
CREATE TABLE WEIGHTS(
	MidPct	NUMBER(2,0) CHECK (MidPct>=0 AND MidPct<=100),
	FinPct	NUMBER(2,0) CHECK (FinPct>=0 AND FinPct<=100),
	HWPct	NUMBER(2,0) CHECK (HWPct>=0 AND HWPct<=100)
);
INSERT INTO WEIGHTS VALUES ( 30, 30, 40 );
SELECT * FROM WEIGHTS;
COMMIT;

SET SERVEROUTPUT ON;









declare
    midw NUMBER; --midterm weight
    finw NUMBER; --final weight
    hww NUMBER; --homework weight
    letterGrade CHAR(1);
    average NUMBER; --stores average at end
    
    CURSOR SCORE IS
        SELECT Midterm, Final, Homework
        FROM STUDENT;
    
begin
    SELECT MidPct, FinPct, HWPct
    INTO midw, finw, hww
    FROM WEIGHTS;
    
    dbms_output.put_line('Weights are ' || midw || ', ' || finw || ', ' || hww);
    
    FOR student IN (SELECT ID, Name, Midterm, Final, Homework FROM STUDENT) 
    LOOP
        average := ((student.Midterm * midw + student.Final * finw + student.Homework * hww)/100);
        IF(average >= 90) THEN
            letterGrade := 'A';
        ELSIF(average >= 80) THEN
            letterGrade := 'B';
        ELSIF(average >= 65) THEN
            letterGrade := 'C';
        ELSE
            letterGrade := 'F';
        END IF;
            
        dbms_output.put_line(student.ID || ' ' || 
                             student.Name || ' ' || 
                             average || ' ' ||
                             letterGrade);
    END LOOP;

end;

/
