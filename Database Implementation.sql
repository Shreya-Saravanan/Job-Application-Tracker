 
CREATE DATABASE jobapplicant;
USE jobapplicant; 

 
-- DATABASE CREATION
---------------------------------- 

----Create table Address 

---------------------------------- 

CREATE TABLE Address ( 
AddressID varchar(50) PRIMARY KEY, 
Street varchar(50) NOT NULL, 
City varchar(50) NOT NULL, 
State varchar(50) NOT NULL, 
Zipcode bigint NOT NULL,
Country varchar(50) NOT NULL, 
CONSTRAINT CHK_Zipcode CHECK (Zipcode >= 1000 AND Zipcode <= 99999) 
); 
 
--------------------------------------------- 

----Create table CompanyInformation 

--------------------------------------------- 

CREATE TABLE CompanyInformation ( 
CompanyID varchar(50) PRIMARY KEY, 
AddressID varchar(50) NOT NULL, 
CompanyName varchar(255) NOT NULL, 
Industry varchar(255) NOT NULL, 
ContactEmail varchar(255) NOT NULL, 
ContactPhone bigint NOT NULL, 
CONSTRAINT FK_Address_CompanyInformation  
FOREIGN KEY (AddressID)  
REFERENCES Address(AddressID), 
CONSTRAINT UQ_CompanyName  
	UNIQUE (CompanyName, ContactEmail, ContactPhone) 
); 

 
--------------------------------------------- 

----Create table Recruiters 

--------------------------------------------- 

CREATE TABLE Recruiters ( 
RecruiterID varchar(50) PRIMARY KEY, 
CompanyID varchar(50) NOT NULL UNIQUE, 
FirstName varchar(255) NOT NULL, 
LastName varchar(255) NOT NULL, 
Email varchar(255) NOT NULL, 
Phone bigint NOT NULL, 
CONSTRAINT FK_CompanyInformation_Recruiters  
FOREIGN KEY (CompanyID)  
REFERENCES CompanyInformation(CompanyID) 
); 

--------------------------------------------- 

----Create table JobApplicant 

--------------------------------------------- 
 
CREATE TABLE JobApplicant ( 
ApplicantID varchar(50) PRIMARY KEY, 
AddressID varchar(50) NOT NULL, 
FirstName varchar(255) NOT NULL, 
LastName varchar(255) NOT NULL, 
Email varchar(255) NOT NULL Unique, 
PhoneNumber bigint NOT NULL, 
CONSTRAINT FK_Address_JobApplicant  
FOREIGN KEY (AddressID)  
REFERENCES Address(AddressID) 
);  

-------------------------------------------------- 

----Create table Education History 

-------------------------------------------------- 

Create table EducationHistory(
EducationID varchar(50) primary key, 
Degree varchar(255) not null, 
Institution varchar(100) not null, 
FieldOfStudy varchar(100) not null
); 

--------------------------------------------------- 

----Create table ApplicantEducation 

--------------------------------------------------- 

CREATE TABLE ApplicantEducation ( 
ApplicantEducationID varchar(50) PRIMARY KEY, 
ApplicantID varchar(50) NOT NULL, 
EducationID varchar(50) NOT NULL, 
GraduationYear int NOT NULL, 
CONSTRAINT FK_Applicant_JobApplicant  
FOREIGN KEY (ApplicantID)  
REFERENCES JobApplicant(ApplicantID), 
CONSTRAINT FK_Education_EducationHistory  
FOREIGN KEY (EducationID)  
REFERENCES EducationHistory(EducationID), 
CONSTRAINT CHK_GraduationYear CHECK (GraduationYear >= 1900 AND GraduationYear <= YEAR(GETDATE())) 
); 

-------------------------------------- 

----Create table Skill 

-------------------------------------- 

CREATE Table skill( 
SkillID varchar(50) primary key, 
SkillName varchar(255) not null
); 

------------------------------------------------ 

----Create table ApplicantSkills 

------------------------------------------------  

CREATE TABLE ApplicantSkills ( 
ApplicantSkillID varchar(50) PRIMARY KEY, 
ApplicantID varchar(50) NOT NULL, 
SkillID varchar(50) NOT NULL, 
CONSTRAINT FK_Applicant_JobApplicant_ApplicantSkills  
FOREIGN KEY (ApplicantID)  
REFERENCES JobApplicant(ApplicantID), 
CONSTRAINT FK_Skill_Skill  
FOREIGN KEY (SkillID)  
REFERENCES Skill(SkillID)  
); 

------------------------------------------------- 

----Create table ApplicantProfile 

-------------------------------------------------- 

CREATE TABLE ApplicantProfile (  
ProfileID varchar(50) PRIMARY KEY,  
ApplicantID varchar(50) NOT NULL,  
Summary varchar(255) NOT NULL,  
ProfilePicture varchar(100) NOT NULL,  
CONSTRAINT FK_Applicant_JobApplicant_ApplicantProfile   
FOREIGN KEY (ApplicantID)   
REFERENCES JobApplicant(ApplicantID)   
); 

--------------------------------------------- 

----Create table DocumentType 

--------------------------------------------- 

CREATE Table DocumentType (
DocumentTypeID varchar(50) primary key, 
DocumentType varchar(50) not null
); 

---------------------------------------------------- 

----Create table ApplicantDocumentes 

---------------------------------------------------- 

CREATE TABLE ApplicantDocuments (  
ApplicantDocumentID varchar(50) PRIMARY KEY,  
ApplicantID varchar(50) NOT NULL,  
DocumentTypeID varchar(50) NOT NULL,  
DocumentPath varchar(255) NOT NULL,  
CONSTRAINT FK_Applicant_JobApplicant_ApplicantDocuments   
FOREIGN KEY (ApplicantID)   
REFERENCES JobApplicant(ApplicantID),  
CONSTRAINT FK_DocumentType_DocumentType   
FOREIGN KEY (DocumentTypeID)   
REFERENCES DocumentType(DocumentTypeID)   
); 

--------------------------------------------------- 

----Create table JobListings 

--------------------------------------------------- 

CREATE TABLE JobListings ( 
JobID varchar(50) PRIMARY KEY, 
JobTitle varchar(100) NOT NULL, 
Description varchar(1000) NOT NULL, 
Location varchar(100) NOT NULL, 
SalaryRange bigint NOT NULL, 
EmployeeType varchar(255) NOT NULL, 
ExperienceLevel varchar(255) NOT NULL, 
CompanyID varchar(50) NOT NULL, 
RecruiterID varchar(50) NOT NULL, 
CONSTRAINT FK_CompanyInformation_JobListings  
FOREIGN KEY (CompanyID)  
REFERENCES CompanyInformation(CompanyID),  
CONSTRAINT FK_Recruiters_JobListings  
FOREIGN KEY (RecruiterID)  
REFERENCES Recruiters(RecruiterID)  
); 

--------------------------------------------------- 

----Create table Application Status 

--------------------------------------------------- 

CREATE table ApplicationStatus (
ApplicationStatusID varchar(50) primary key, 
StatusDescription varchar(255) not null
); 

------------------------------------------- 

----Create table AppliedJob 

------------------------------------------- 

CREATE TABLE AppliedJobs ( 
ApplicationID varchar(50) PRIMARY KEY, 
ApplicantID varchar(50) NOT NULL, 
JobID varchar(50) NOT NULL, 
ApplicationStatusID varchar(50) NOT NULL, 
ApplicationDate DATETIME DEFAULT GETDATE() NOT NULL, 
CONSTRAINT FK_Applicant_JobApplicant_AppliedJobs 
FOREIGN KEY (ApplicantID)  
REFERENCES JobApplicant(ApplicantID), 
CONSTRAINT FK_JobListings_AppliedJobs  
FOREIGN KEY (JobID)  
REFERENCES JobListings(JobID), 
CONSTRAINT FK_ApplicationStatus_AppliedJobs  
FOREIGN KEY (ApplicationStatusID)  
REFERENCES ApplicationStatus(ApplicationStatusID)  
); 

------------------------------------- 

----Create Saved Jobs 

------------------------------------- 

CREATE TABLE SavedJobs ( 
SavedID varchar(50) PRIMARY KEY, 
ApplicantID varchar(50) NOT NULL, 
JobID varchar(50) NOT NULL, 
CONSTRAINT FK_Applicant_JobApplicant_savedJobs  
FOREIGN KEY (ApplicantID)  
REFERENCES JobApplicant(ApplicantID), 
CONSTRAINT FK_JobListings_SavedJobs  
FOREIGN KEY (JobID)  
REFERENCES JobListings(JobID),
constraint UQ_applicant_savedJobs Unique (ApplicantID,jobID)
); 

------------------------------------ 

----Create Interview 

------------------------------------ 

CREATE TABLE Interview ( 
InterviewID varchar(50) PRIMARY KEY, 
ApplicationID varchar(50) NOT NULL, 
InterviewDate date NOT NULL, 
CONSTRAINT FK_AppliedJobs_Interview  
FOREIGN KEY (ApplicationID)  
REFERENCES AppliedJobs(ApplicationID) 
); 

-- INSERT DATA INTO TABLE
-- Address table 

INSERT INTO Address (AddressID, Street, City, State, Zipcode, Country) 
VALUES 
('1', '123 Tech Lane', 'San Francisco', 'CA', 94105, 'USA'), 
('2', '456 Finance Street', 'New York', 'NY', 10001, 'USA'), 
('3', '789 Science Avenue', 'Los Angeles', 'CA', 90001, 'USA'), 
('4', '101 Innovation Blvd', 'Seattle', 'WA', 98101, 'USA'), 
('5', '202 Research Road', 'Austin', 'TX', 78701, 'USA'), 
('6', '303 Development Drive', 'Chicago', 'IL', 60601, 'USA'), 
('7', '404 Design Court', 'Boston', 'MA', 02101, 'USA'), 
('8', '505 Marketing Street', 'Denver', 'CO', 80201, 'USA'), 
('9', '606 Strategy Lane', 'Atlanta', 'GA', 30301, 'USA'), 
('10', '707 Analytics Avenue', 'Dallas', 'TX', 75201, 'USA'), 
('11', '808 Data Drive', 'Miami', 'FL', 33101, 'USA'), 
('12', '909 Information Road', 'Phoenix', 'AZ', 85001, 'USA'); 


-- CompanyInformation table 

INSERT INTO CompanyInformation (CompanyID, AddressID, CompanyName, Industry, ContactEmail, ContactPhone) 
VALUES
('C1', '1', 'Tech Solutions Inc.', 'Technology', 'info@techsolutions.com', 1234567890), 
('C2', '2', 'Finance Experts LLC', 'Finance', 'info@financeexperts.com', 9876543210), 
('C3', '3', 'Science Innovations Co.', 'Science', 'info@scienceinnovations.com', 5556667777), 
('C4', '4', 'Innovation Hub Ltd.', 'Technology', 'info@innovationhub.com', 1112223333), 
('C5', '5', 'Research Systems Corp.', 'Research', 'info@researchsystems.com', 9998887777), 
('C6', '6', 'Development Solutions Ltd.', 'Technology', 'info@developmentsolutions.com', 3332221111), 
('C7', '7', 'Design Creations Inc.', 'Design', 'info@designcreations.com', 4445556666), 
('C8', '8', 'Marketing Dynamics Ltd.', 'Marketing', 'info@marketingdynamics.com', 7778889999), 
('C9', '9', 'Strategy Innovators Co.', 'Strategy', 'info@strategyinnovators.com', 2221113333), 
('C10', '10', 'Analytics Systems Inc.', 'Analytics', 'info@analyticssystems.com', 6665554444), 
('C11', '11', 'Data Solutions Corp.', 'Technology', 'info@datasolutions.com', 8887776666), 
('C12', '12', 'Information Technologies Ltd.', 'Technology', 'info@infotech.com', 5554443333); 
 

-- Recruiters table 

INSERT INTO Recruiters (RecruiterID, CompanyID, FirstName, LastName, Email, Phone) 
VALUES 
('R1', 'C1', 'Alex', 'Johnson', 'alex.johnson@techsolutions.com', 1112223333), 
('R2', 'C2', 'Emily', 'Smith', 'emily.smith@financeexperts.com', 4445556666), 
('R3', 'C3', 'Michael', 'Miller', 'michael.miller@scienceinnovations.com', 7778889999), 
('R4', 'C4', 'Jessica', 'Williams', 'jessica.williams@innovationhub.com', 2221113333), 
('R5', 'C5', 'Daniel', 'Davis', 'daniel.davis@researchsystems.com', 6665554444), 
('R6', 'C6', 'Sophia', 'Martin', 'sophia.martin@developmentsolutions.com', 8887776666), 
('R7', 'C7', 'Ethan', 'Taylor', 'ethan.taylor@designcreations.com', 5554443333), 
('R8', 'C8', 'Ava', 'Anderson', 'ava.anderson@marketingdynamics.com', 3332221111), 
('R9', 'C9', 'Noah', 'Moore', 'noah.moore@strategyinnovators.com', 6665554444), 
('R10', 'C10', 'Olivia', 'White', 'olivia.white@analyticssystems.com', 9998887777), 
('R11', 'C11', 'Liam', 'Brown', 'liam.brown@datasolutions.com', 7778889999), 
('R12', 'C12', 'Emma', 'Jones', 'emma.jones@infotech.com', 4445556666); 


-- JobApplicant table 

INSERT INTO JobApplicant (ApplicantID, AddressID, FirstName, LastName, Email, PhoneNumber) 
VALUES 
('A1', '1', 'Michael', 'Williams', 'michael.williams@email.com', 5556667777), 
('A2', '2', 'Jessica', 'Davis', 'jessica.davis@email.com', 8889990000), 
('A3', '3', 'Ryan', 'Johnson', 'ryan.johnson@email.com', 3334445555),
('A4', '4', 'Emily', 'Miller', 'emily.miller@email.com', 6667778888), 
('A5', '5', 'Daniel', 'Smith', 'daniel.smith@email.com', 1112223333), 
('A6', '6', 'Sophia', 'Anderson', 'sophia.anderson@email.com', 4445556666), 
('A7', '7', 'Ethan', 'Taylor', 'ethan.taylor@email.com', 7778889999), 
('A8', '8', 'Ava', 'Martin', 'ava.martin@email.com', 2221113333), 
('A9', '9', 'Noah', 'Moore', 'noah.moore@email.com', 5554443333), 
('A10', '10', 'Olivia', 'White', 'olivia.white@email.com', 9998887777), 
('A11', '11', 'Liam', 'Brown', 'liam.brown@email.com', 6665554444), 
('A12', '12', 'Emma', 'Jones', 'emma.jones@email.com', 7778889999); 
 

-- EducationHistory table  

INSERT INTO EducationHistory (EducationID, Degree, Institution, FieldOfStudy) 
VALUES 
('E1', 'Bachelor of Science', 'University of Tech', 'Computer Science'), 
('E2', 'Master of Finance', 'Finance University', 'Finance'), 
('E3', 'Bachelor of Science', 'Science College', 'Physics'), 
('E4', 'Master of Business Administration', 'Innovation Institute', 'Business Administration'), 
('E5', 'Bachelor of Arts', 'Arts Academy', 'Graphic Design'), 
('E6', 'Master of Engineering', 'Engineering School', 'Mechanical Engineering'), 
('E7', 'Bachelor of Science', 'Technology College', 'Information Technology'), 
('E8', 'Master of Public Health', 'Health Sciences Institute', 'Public Health'), 
('E9', 'Bachelor of Business Administration', 'Business School', 'Marketing'), 
('E10', 'Master of Arts', 'Arts Institute', 'Creative Writing'), 
('E11', 'Bachelor of Engineering', 'Engineering College', 'Electrical Engineering'), 
('E12', 'Master of Psychology', 'Psychology Institute', 'Psychology'); 


-- ApplicantEducation table 

INSERT INTO ApplicantEducation (ApplicantEducationID, ApplicantID, EducationID, GraduationYear) 
VALUES 
('AE1', 'A1', 'E1', 2022), 
('AE2', 'A2', 'E2', 2020), 
('AE3', 'A3', 'E3', 2021), 
('AE4', 'A4', 'E4', 2019), 
('AE5', 'A5', 'E5', 2023), 
('AE6', 'A6', 'E6', 2022), 
('AE7', 'A7', 'E7', 2021), 
('AE8', 'A8', 'E8', 2020), 
('AE9', 'A9', 'E9', 2019), 
('AE10', 'A10', 'E10', 2021), 
('AE11', 'A11', 'E11', 2022), 
('AE12', 'A12', 'E12', 2020); 


-- Skill table 

INSERT INTO Skill (SkillID, SkillName) 
VALUES 
('S1', 'Java'), 
('S2', 'Financial Analysis'), 
('S3', 'Data Science'), 
('S4', 'Graphic Design'), 
('S5', 'Mechanical Engineering'), 
('S6', 'Marketing'), 
('S7', 'Creative Writing'), 
('S8', 'Electrical Engineering'), 
('S9', 'Public Health'), 
('S10', 'Psychology'), 
('S11', 'Information Technology'), 
('S12', 'Business Administration'); 

-- ApplicantSkills table 

INSERT INTO ApplicantSkills (ApplicantSkillID, ApplicantID, SkillID) 
VALUES 
('AS1', 'A1', 'S1'), 
('AS2', 'A2', 'S2'), 
('AS3', 'A3', 'S3'), 
('AS4', 'A4', 'S4'), 
('AS5', 'A5', 'S5'), 
('AS6', 'A6', 'S6'), 
('AS7', 'A7', 'S7'), 
('AS8', 'A8', 'S8'), 
('AS9', 'A9', 'S9'), 
('AS10', 'A10', 'S10'), 
('AS11', 'A11', 'S11'), 
('AS12', 'A12', 'S12'); 

-- ApplicantProfile table 

INSERT INTO ApplicantProfile(ProfileID, ApplicantID, Summary, ProfilePicture) VALUES ('AP1', 'A1', 'Experienced software engineer with a focus on Java development', ENCRYPTBYPASSPHRASE('ProfilePicture','michael_williams.jpg')) 
INSERT INTO ApplicantProfile(ProfileID, ApplicantID, Summary, ProfilePicture) VALUES ('AP2', 'A2', 'Master of Finance graduate specializing in financial analysis', ENCRYPTBYPASSPHRASE('ProfilePicture','jessica_davis.jpg')) 
INSERT INTO ApplicantProfile(ProfileID, ApplicantID, Summary, ProfilePicture) VALUES ('AP3', 'A3', 'Physics enthusiast with a keen interest in research', ENCRYPTBYPASSPHRASE('ProfilePicture','ryan_johnson.jpg')) 
INSERT INTO ApplicantProfile(ProfileID, ApplicantID, Summary, ProfilePicture) VALUES ('AP4', 'A4', 'MBA graduate passionate about business administration', ENCRYPTBYPASSPHRASE('ProfilePicture','emily_miller.jpg')) 
INSERT INTO ApplicantProfile(ProfileID, ApplicantID, Summary, ProfilePicture) VALUES ('AP5', 'A5', 'Creative graphic designer with a unique vision', ENCRYPTBYPASSPHRASE('ProfilePicture','daniel_smith.jpg')) 
INSERT INTO ApplicantProfile(ProfileID, ApplicantID, Summary, ProfilePicture) VALUES ('AP6', 'A6', 'Mechanical engineer with a love for innovation', ENCRYPTBYPASSPHRASE('ProfilePicture','sophia_anderson.jpg')) 
INSERT INTO ApplicantProfile(ProfileID, ApplicantID, Summary, ProfilePicture) VALUES ('AP7', 'A7', 'Information technology professional with diverse skills', ENCRYPTBYPASSPHRASE('ProfilePicture','ethan_taylor.jpg')) 
INSERT INTO ApplicantProfile(ProfileID, ApplicantID, Summary, ProfilePicture) VALUES ('AP8', 'A8', 'Public health advocate dedicated to community well-being', ENCRYPTBYPASSPHRASE('ProfilePicture','ava_martin.jpg')) 
INSERT INTO ApplicantProfile(ProfileID, ApplicantID, Summary, ProfilePicture) VALUES ('AP9', 'A9', 'Marketing specialist with a strategic mindset', ENCRYPTBYPASSPHRASE('ProfilePicture','noah_moore.jpg')) 
INSERT INTO ApplicantProfile(ProfileID, ApplicantID, Summary, ProfilePicture) VALUES ('AP10', 'A10', 'Creative writer exploring the world of storytelling', ENCRYPTBYPASSPHRASE('ProfilePicture','olivia_white.jpg')) 
INSERT INTO ApplicantProfile(ProfileID, ApplicantID, Summary, ProfilePicture) VALUES ('AP11', 'A11', 'Electrical engineer passionate about sustainable energy solutions', ENCRYPTBYPASSPHRASE('ProfilePicture','liam_brown.jpg')) 
INSERT INTO ApplicantProfile(ProfileID, ApplicantID, Summary, ProfilePicture) VALUES ('AP12', 'A12', 'Psychology expert focused on understanding human behavior', ENCRYPTBYPASSPHRASE('ProfilePicture','emma_jones.jpg')) 

-- DocumentType table 

INSERT INTO DocumentType (DocumentTypeID, DocumentType) 
VALUES 
('DT1', 'Resume'), 
('DT2', 'Cover Letter'), 
('DT3', 'Transcript'), 
('DT4', 'Portfolio'), 
('DT5', 'Certification'), 
('DT6', 'Reference Letter'), 
('DT7', 'Research Paper'), 
('DT8', 'Design Samples'), 
('DT9', 'Project Report'), 
('DT10', 'Publication'), 
('DT11', 'Health Certificate'), 
('DT12', 'Writing Samples'); 


-- ApplicantDocuments table 

INSERT INTO ApplicantDocuments(ApplicantDocumentID, ApplicantID, DocumentTypeID, DocumentPath) VALUES ('AD1', 'A1', 'DT1', ENCRYPTBYPASSPHRASE('DocumentPath','michael_williams_resume.pdf')) 
INSERT INTO ApplicantDocuments(ApplicantDocumentID, ApplicantID, DocumentTypeID, DocumentPath) VALUES ('AD2', 'A2', 'DT2', ENCRYPTBYPASSPHRASE('DocumentPath','jessica_davis_cover_letter.pdf')) 
INSERT INTO ApplicantDocuments(ApplicantDocumentID, ApplicantID, DocumentTypeID, DocumentPath) VALUES ('AD3', 'A3', 'DT3', ENCRYPTBYPASSPHRASE('DocumentPath','ryan_johnson_transcript.pdf')) 
INSERT INTO ApplicantDocuments(ApplicantDocumentID, ApplicantID, DocumentTypeID, DocumentPath) VALUES ('AD4', 'A4', 'DT4', ENCRYPTBYPASSPHRASE('DocumentPath','emily_miller_portfolio.pdf')) 
INSERT INTO ApplicantDocuments(ApplicantDocumentID, ApplicantID, DocumentTypeID, DocumentPath) VALUES ('AD5', 'A5', 'DT5', ENCRYPTBYPASSPHRASE('DocumentPath','daniel_smith_certification.pdf')) 
INSERT INTO ApplicantDocuments(ApplicantDocumentID, ApplicantID, DocumentTypeID, DocumentPath) VALUES ('AD6', 'A6', 'DT6', ENCRYPTBYPASSPHRASE('DocumentPath','sophia_anderson_reference_letter.pdf')) 
INSERT INTO ApplicantDocuments(ApplicantDocumentID, ApplicantID, DocumentTypeID, DocumentPath) VALUES ('AD7', 'A7', 'DT7', ENCRYPTBYPASSPHRASE('DocumentPath','ethan_taylor_research_paper.pdf')) 
INSERT INTO ApplicantDocuments(ApplicantDocumentID, ApplicantID, DocumentTypeID, DocumentPath) VALUES ('AD8', 'A8', 'DT8', ENCRYPTBYPASSPHRASE('DocumentPath','ava_martin_design_samples.pdf')) 
INSERT INTO ApplicantDocuments(ApplicantDocumentID, ApplicantID, DocumentTypeID, DocumentPath) VALUES ('AD9', 'A9', 'DT9', ENCRYPTBYPASSPHRASE('DocumentPath','noah_moore_project_report.pdf')) 
INSERT INTO ApplicantDocuments(ApplicantDocumentID, ApplicantID, DocumentTypeID, DocumentPath) VALUES ('AD10', 'A10', 'DT10', ENCRYPTBYPASSPHRASE('DocumentPath','olivia_white_publication.pdf')) 
INSERT INTO ApplicantDocuments(ApplicantDocumentID, ApplicantID, DocumentTypeID, DocumentPath) VALUES ('AD11', 'A11', 'DT11', ENCRYPTBYPASSPHRASE('DocumentPath','liam_brown_health_certificate.pdf')) 
INSERT INTO ApplicantDocuments(ApplicantDocumentID, ApplicantID, DocumentTypeID, DocumentPath) VALUES ('AD12', 'A12', 'DT12', ENCRYPTBYPASSPHRASE('DocumentPath','emma_jones_writing_samples.pdf'))  

-- JobListings table 

INSERT INTO JobListings (JobID, JobTitle, Description, Location, SalaryRange, EmployeeType, ExperienceLevel, CompanyID, RecruiterID) 
VALUES 
('J1', 'Software Engineer', 'Developing innovative software solutions', 'San Francisco', 95000, 'Full-Time', 'Mid-Level', 'C1', 'R1'), 
('J2', 'Financial Analyst', 'Conducting in-depth financial analysis', 'New York', 105000, 'Full-Time', 'Mid-Level', 'C2', 'R2'), 
('J3', 'Research Scientist', 'Leading scientific research projects', 'Los Angeles', 90000, 'Full-Time', 'Senior', 'C3', 'R3'), 
('J4', 'Innovation Specialist', 'Driving innovation initiatives', 'Seattle', 100000, 'Full-Time', 'Senior', 'C4', 'R4'), 
('J5', 'Graphic Designer', 'Creating visually stunning designs', 'Austin', 80000, 'Full-Time', 'Entry-Level', 'C5', 'R5'), 
('J6', 'Mechanical Engineer', 'Designing and testing mechanical systems', 'Chicago', 95000, 'Full-Time', 'Mid-Level', 'C6', 'R6'), 
('J7', 'Marketing Manager', 'Strategizing and executing marketing campaigns', 'Boston', 110000, 'Full-Time', 'Senior', 'C7', 'R7'), 
('J8', 'IT Specialist', 'Managing and optimizing information technology systems', 'Denver', 90000, 'Full-Time', 'Mid-Level', 'C8', 'R8'), 
('J9', 'Public Health Analyst', 'Analyzing public health data and trends', 'Atlanta', 95000, 'Full-Time', 'Mid-Level', 'C9', 'R9'), 
('J10', 'Digital Marketing Coordinator', 'Coordinating digital marketing activities', 'Dallas', 85000, 'Full-Time', 'Entry-Level', 'C10', 'R10'), 
('J11', 'Content Writer', 'Creating engaging and informative content', 'Miami', 80000, 'Full-Time', 'Entry-Level', 'C11', 'R11'), 
('J12', 'Electrical Engineer', 'Designing electrical systems and components', 'Phoenix', 100000, 'Full-Time', 'Mid-Level', 'C12', 'R12');  

-- ApplicationStatus table 

INSERT INTO ApplicationStatus (ApplicationStatusID, StatusDescription) 
VALUES 
('AS1', 'Pending'), 
('AS2', 'Approved'), 
('AS3', 'Rejected'), 
('AS4', 'Interview Scheduled'), 
('AS5', 'Offer Extended'), 
('AS6', 'Offer Accepted'), 
('AS7', 'Withdrawn'), 
('AS8', 'In Progress'), 
('AS9', 'On Hold'), 
('AS10', 'Cancelled'), 
('AS11', 'Pending Approval'), 
('AS12', 'Completed'); 

-- AppliedJob table 

INSERT INTO AppliedJobs (ApplicationID, ApplicantID, JobID, ApplicationStatusID) 
VALUES 
('APP1', 'A1', 'J1', 'AS1'), 
('APP2', 'A2', 'J2', 'AS2'), 
('APP3', 'A3', 'J3', 'AS3'), 
('APP4', 'A4', 'J4', 'AS4'), 
('APP5', 'A5', 'J5', 'AS5'), 
('APP6', 'A6', 'J6', 'AS6'), 
('APP7', 'A7', 'J7', 'AS7'), 
('APP8', 'A8', 'J8', 'AS8'), 
('APP9', 'A9', 'J9', 'AS9'), 
('APP10', 'A10', 'J10', 'AS10'), 
('APP11', 'A11', 'J11', 'AS11'), 
('APP12', 'A12', 'J12', 'AS12'); 

-- SavedJobs table 

INSERT INTO SavedJobs (SavedID, ApplicantID, JobID) 
VALUES 
('SJ1', 'A1', 'J2'), 
('SJ2', 'A2', 'J1'), 
('SJ3', 'A3', 'J3'), 
('SJ4', 'A4', 'J4'), 
('SJ5', 'A5', 'J5'), 
('SJ6', 'A6', 'J6'), 
('SJ7', 'A7', 'J7'), 
('SJ8', 'A8', 'J8'), 
('SJ9', 'A9', 'J9'), 
('SJ10', 'A10', 'J10'), 
('SJ11', 'A11', 'J11'), 
('SJ12', 'A12', 'J12'); 

-- Interview table 

INSERT INTO Interview (InterviewID,ApplicationID,InterviewDate)
VALUES
('I1','APP1','2024-01-25'),
('I2','APP2','2024-02-10'),
('I3','APP3','2024-02-20'),
('I4','APP4','2024-03-10'),
('I5','APP5','2024-03-25'),
('I6','APP6','2024-04-05'),
('I7','APP7','2024-04-20'),
('I8','APP8','2024-04-05'),
('I9','APP9','2024-05-20'),
('I10','APP10','2024-05-05'),
('I11','APP11','2024-05-20'),
('I12','APP12','2024-05-05');

 
 

USE jobapplicant 

 
 

SELECT * FROM dbo.EducationHistory eh  

select * from dbo.Address a  

select * from dbo.ApplicantDocuments ad  

select * from dbo.ApplicantEducation ae  

select * from dbo.ApplicantProfile ap  

select * from dbo.ApplicantSkills as2  

select * from dbo.ApplicationStatus as2  

select * from dbo.AppliedJobs aj  

select * from dbo.CompanyInformation ci  

select * from dbo.DocumentType dt  

select * from dbo.EducationHistory eh  

select * from dbo.Interview i  

select * from dbo.JobApplicant ja  

select * from dbo.JobListings jl  

select * from dbo.Recruiters r  

select * from dbo.SavedJobs sj  

select * from dbo.skill s  

 
 

-- Table level check constraint to make sure that the recruiter in job listing belongs to the company that the listing was posted from 

CREATE FUNCTION dbo.CheckRecruiterCompany ( 
@recruiterID varchar(50), 
@companyID varchar(50) 
) 
RETURNS BIT 
AS 
BEGIN 
DECLARE @result BIT 

SET @result = CASE 
WHEN EXISTS ( 
SELECT 1 
FROM Recruiters R 
WHERE R.RecruiterID = @recruiterID 
AND R.CompanyID = @companyID 
) THEN 1 
ELSE 0 
END 

RETURN @result 

END; 

-- Alter the JobListing table to add a CHECK constraint based on the function 

ALTER TABLE JobListings 
ADD CONSTRAINT CheckRecruiterCompanyInfo 
CHECK ( 
dbo.CheckRecruiterCompany(RecruiterID, CompanyID) = 1 
); 

 
-- Insert data to test

INSERT INTO JobListings (JobID, JobTitle, Description, Location, SalaryRange, EmployeeType, ExperienceLevel, CompanyID, RecruiterID) 
VALUES 
('J14', 'Software Engineer', 'Developing innovative software solutions', 'San Francisco', 95000, 'Full-Time', 'Mid-Level', 'C1', 'R2') 


-- Table level check constraint to check if a phone number is valid 

CREATE FUNCTION dbo.IsValidPhoneNumber ( 
@PhoneNumber VARCHAR(50) 
) 
RETURNS BIT 
AS 
BEGIN 
DECLARE @IsValid BIT 

SET @IsValid = CASE 
WHEN LEN(@PhoneNumber) >= 10 AND @PhoneNumber NOT LIKE '%[^0-9]%' 
THEN 1 
ELSE 0 
END 

RETURN @IsValid 

END; 


-- Table level check constraint to check if an email address is valid 

CREATE FUNCTION dbo.IsValidEmail ( 
@EmailAddress NVARCHAR(255) 
) 
RETURNS BIT 
AS 
BEGIN 
DECLARE @IsValid BIT 

SET @IsValid = CASE 

WHEN @EmailAddress LIKE '%_@__%.__%' 
THEN 1 
ELSE 0 
END 

RETURN @IsValid 

END; 


-- Add table-level check constraints for phone number and email 

ALTER TABLE dbo.Recruiters  
ADD CONSTRAINT CheckValidPhoneNumberForRec 
CHECK (dbo.IsValidPhoneNumber(Phone) = 1); 
 

ALTER TABLE dbo.JobApplicant  
ADD CONSTRAINT CheckValidPhoneNumberForAppl 
CHECK (dbo.IsValidPhoneNumber(PhoneNumber) = 1); 


ALTER TABLE dbo.JobApplicant  
ADD CONSTRAINT CheckValidPhoneNumberForComp 
CHECK (dbo.IsValidPhoneNumber(PhoneNumber) = 1); 


ALTER TABLE dbo.Recruiters  
ADD CONSTRAINT CheckValidEmailForRec 
CHECK (dbo.IsValidEmail(Email) = 1); 


ALTER TABLE dbo.JobApplicant  
ADD CONSTRAINT CheckValidEmailForAppl 
CHECK (dbo.IsValidEmail(Email) = 1); 


ALTER TABLE dbo.CompanyInformation  
ADD CONSTRAINT CheckValidEmailForComp 
CHECK (dbo.IsValidEmail(ContactEmail) = 1); 

 
-- Insert data to testing  

INSERT INTO JobApplicant (ApplicantID, AddressID, FirstName, LastName, Email, PhoneNumber) 
VALUES 
('A45', '12', 'Michael', 'Williams', 'michael.williams.com', 555667);


-- Table level check constraint to check if a date is not in the past
CREATE FUNCTION dbo.fn_CheckFutureDate (@dateToCheck DATE)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT;

    -- Check if the date is not in the past
    IF @dateToCheck >= GETDATE()
        SET @result = 1; -- True
    ELSE
        SET @result = 0; -- False

    RETURN @result;
END;


-- Alter the table and add a check constraint using the function
ALTER TABLE Interview
ADD CONSTRAINT CHK_InterviewDate CHECK (dbo.fn_CheckFutureDate(InterviewDate) = 1);


-------------------------------------------------------------- 

-----------Created view for Company Job Statistics View 

-------------------------------------------------------------- 

 

CREATE VIEW CompanyJobStatisticsView AS 
SELECT 
CI.CompanyID, 
CI.CompanyName, 
JL.JobID, 
JL.JobTitle, 
JL.Location, 
JL.SalaryRange, 
JL.EmployeeType, 
JL.ExperienceLevel, 
COUNT(AJ.ApplicationID) AS ApplicationCount 
FROM 
CompanyInformation CI 
JOIN JobListings JL ON CI.CompanyID = JL.CompanyID 
LEFT JOIN AppliedJobs AJ ON JL.JobID = AJ.JobID 
GROUP BY 
CI.CompanyID, 
CI.CompanyName, 
JL.JobID, 
JL.JobTitle, 
JL.Location, 
JL.SalaryRange, 
JL.EmployeeType, 
JL.ExperienceLevel; 



 

-------------------------------------------------------------- 

-----------Created view for Applicant Details 

-------------------------------------------------------------- 

 

Select * from applicantDetailsView;
CREATE VIEW applicantDetailsView AS 
SELECT 
JA.ApplicantID, 
JA.FirstName, 
JA.LastName, 
JA.Email, 
JA.PhoneNumber, 
AD.Street, 
AD.City, 
AD.State, 
AD.Zipcode, 
AD.Country, 
EH.Degree, 
EH.Institution, 
AE.GraduationYear, 
S.SkillName, 
AP.ProfilePicture, 
AP.Summary, 
JL.JobTitle, 
JL.Description, 
JL.Location, 
JL.SalaryRange, 
JL.EmployeeType, 
JL.ExperienceLevel, 
CI.CompanyName, 
COUNT(DISTINCT AJ.JobID) AS JobCount, 
COUNT(DISTINCT AJ.ApplicantID) AS ApplicantCount 
FROM 
JobApplicant JA 
JOIN Address AD ON JA.AddressID = AD.AddressID 
LEFT JOIN ApplicantEducation AE ON JA.ApplicantID = AE.ApplicantID 
LEFT JOIN EducationHistory EH ON AE.EducationID = EH.EducationID 
LEFT JOIN ApplicantSkills AS ASK ON JA.ApplicantID = ASK.ApplicantID 
LEFT JOIN Skill S ON ASK.SkillID = S.SkillID 
LEFT JOIN ApplicantProfile AP ON JA.ApplicantID = AP.ApplicantID 
LEFT JOIN AppliedJobs AJ ON JA.ApplicantID = AJ.ApplicantID 
LEFT JOIN JobListings JL ON AJ.JobID = JL.JobID 
LEFT JOIN CompanyInformation CI ON JL.CompanyID = CI.CompanyID 
GROUP BY 
JA.ApplicantID, 
JA.FirstName, 
JA.LastName, 
JA.Email, 
JA.PhoneNumber, 
AD.Street, 
AD.City, 
AD.State, 
AD.Zipcode, 
AD.Country,
EH.Degree, 
EH.Institution, 
AE.GraduationYear, 
S.SkillName, 
AP.ProfilePicture, 
AP.Summary, 
JL.JobTitle, 
JL.Description, 
JL.Location, 
JL.SalaryRange, 
JL.EmployeeType, 
JL.ExperienceLevel, 
CI.CompanyName; 

 

-------------------------------------------------------------- 

-----------Created view for Recruiters see applicant status 

-------------------------------------------------------------- 

CREATE VIEW JobApplicationStatusView AS 
SELECT 
    AJ.ApplicationID, 
    JA.FirstName, 
    JA.LastName, 
    JL.JobTitle, 
    AJ.ApplicationStatusID, 
    AS_Alias.StatusDescription, 
    AJ.ApplicationDate 
FROM 
    AppliedJobs AJ 
JOIN 
    JobApplicant JA ON AJ.ApplicantID = JA.ApplicantID 
JOIN 
    JobListings JL ON AJ.JobID = JL.JobID 
JOIN 
    ApplicationStatus AS_Alias ON AJ.ApplicationStatusID = AS_Alias.ApplicationStatusID; 
 

 
---------------------------------------------------- 

-----DECRYPTION FOR APPLICANT DOCUMENT(DOCUMENTPATH) 

------------------------------------------------------ 

Select convert(varchar(200), DECRYPTBYPASSPHRASE('DocumentPath', DocumentPath)) AS DECRYPT_DocumentPath, * from ApplicantDocuments 
 

---------------------------------------------------- 

-----DECRYPTION FOR APPLICANT PROFILE(DOCUMENTPATH) 

------------------------------------------------------ 

Select convert(varchar(200), DECRYPTBYPASSPHRASE('ProfilePicture', ProfilePicture)) AS DECRYPT_ProfilePicture, * from ApplicantProfile 