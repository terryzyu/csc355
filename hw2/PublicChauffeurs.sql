DROP TABLE PublicChauffeurs;

CREATE TABLE PublicChauffeurs(
	LicenseNumber VARCHAR2(6) NOT NULL, --Stores internal license, 6 digits
	Renewed DATE, --Query can be fomatted to MM/YYYY
	Status  VARCHAR2(15) NOT NULL, --e.g. ACTIVE, SUSPENDED, SURRENDER
	StatusDate DATE NOT NULL, --MM/DD/YYYY
	DriverType VARCHAR2(20) NOT NULL, --e.g. Taxi, Horse-Drawn Only, Livery Only
	LicenseType VARCHAR2(25) NOT NULL,--e.g. PERMANENT, TRAINEE 
	OriginalIssueDate DATE, --MM/DD/YYYY
	Name VARCHAR2(40) NOT NULL, --Stores first, middle, last
	Sex VARCHAR2(6) NOT NULL,   --Male, Female, Unknow
	ChauffeurCity VARCHAR2(30) NOT NULL, --City Name, full name
	ChauffeurState VARCHAR2(2) NOT NULL, --2 letter ID
	RecordNumber VARCHAR2(11) NOT NULL,--##-########

	CONSTRAINT PC_PK
		PRIMARY KEY(RecordNumber), 

	CONSTRAINT IssueDate
		CHECK (Status IN('ACTIVE', 'DECEASED', 'DENIED', 
						'EXPIRED LICENSE', 'HOLD', 'INACTIVE', 
						'PENDING', 'REVOKED', 'SURRENDER', 'SUSPENDED')),

	CONSTRAINT RecordFormat
		CHECK (REGEXP_LIKE(RecordNumber, '^\d{2}-\d{8}'))
        
);

INSERT INTO PublicChauffeurs VALUES('103040',TO_DATE('FEB-18', 'Mon-YY'),'ACTIVE',CURRENT_DATE,'Taxi','PERMANENT',CURRENT_DATE,'BASKOTA BISHNU PRASAD','MALE','CHICAGO','IL','15-05916035');
SELECT * FROM PublicChauffeurs