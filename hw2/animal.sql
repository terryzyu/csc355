-- Drop all the tables to clean up
DROP TABLE Animal;

-- ACategory: Animal category 'common', 'rare', 'exotic'.  May be NULL
-- TimeToFeed: Time it takes to feed the animal (hours)
CREATE TABLE Animal(
  AID       NUMBER(3, 0),
AName VARCHAR2(30) NOT NULL,
ACategory VARCHAR2(19),  
TimeToFeed NUMBER(4,2),  
  CONSTRAINT Animal_PK  PRIMARY KEY(AID)
);


INSERT INTO Animal VALUES(1, 'Galapagos Penguin', 'exotic', 0.5);
INSERT INTO Animal VALUES(2, 'Emperor Penguin', 'rare', 0.75);

INSERT INTO Animal VALUES(3, 'Sri Lankan sloth bear', 'exotic', 2.5);
INSERT INTO Animal VALUES(4, 'Grizzly bear', 'common', 3.5);
INSERT INTO Animal VALUES(5, 'Giant Panda bear', 'exotic', 1.5);
INSERT INTO Animal VALUES(6, 'Florida black bear', 'rare', 1.75);

INSERT INTO Animal VALUES(7, 'Siberian tiger', 'rare', 3.5);
INSERT INTO Animal VALUES(8, 'Bengal tiger', 'common', 2.75);
INSERT INTO Animal VALUES(9, 'South China tiger', 'exotic', 2.25);

INSERT INTO Animal VALUES(10, 'Alpaca', 'common', 0.25);
INSERT INTO Animal VALUES(11, 'Llama', NULL, 3.25);

--A
SELECT AName FROM Animal WHERE TIMETOFEED < 2;

--B
SELECT AName, TIMETOFEED FROM Animal WHERE ACategory = 'rare' ORDER BY TIMETOFEED;

--C
SELECT AName, ACategory FROM Animal WHERE AName LIKE '%bear%';

--D
SELECT AName, ACategory FROM Animal WHERE ACategory IS NULL;

--E
SELECT DISTINCT ACategory FROM Animal WHERE TIMETOFEED <= 2.2 AND TIMETOFEED > 1;

--F
SELECT AName FROM Animal WHERE AName LIKE '%tiger%' AND ACategory != 'common';

--G
SELECT MIN(TIMETOFEED), MAX(TIMETOFEED) FROM Animal;

--H
SELECT AVG(TIMETOFEED) FROM Animal;

--EC1
SELECT * FROM Animal WHERE TIMETOFEED = (SELECT MAX(TIMETOFEED) FROM Animal);

--EC2
SELECT * FROM Animal WHERE TIMETOFEED <= (SELECT AVG(TIMETOFEED) * 1.25 FROM Animal) ORDER BY TIMETOFEED;