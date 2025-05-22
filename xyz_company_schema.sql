/* create / switch to the project schema */
-- 1) Kill the old schema completely
DROP DATABASE IF EXISTS xyz_company;

-- 2) Re‑create it and make it the default
CREATE DATABASE xyz_company;
USE xyz_company;


/* ---------- PERSON + PHONE ---------- */
CREATE TABLE Person (
  PersonID      INT          AUTO_INCREMENT PRIMARY KEY,
  FirstName     VARCHAR(25)  NOT NULL,
  LastName      VARCHAR(25)  NOT NULL,
  Age           TINYINT      CHECK (Age < 65),
  Gender        CHAR(1),
  AddressLine1  VARCHAR(60),
  AddressLine2  VARCHAR(60),
  City          VARCHAR(30),
  State         CHAR(2),
  Zip           CHAR(5)
);

CREATE TABLE PersonPhone (
  PersonID     INT          NOT NULL,
  PhoneNumber  VARCHAR(20)  NOT NULL,
  PRIMARY KEY (PersonID, PhoneNumber),
  FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

/* ---------- DEPARTMENT ---------- */
CREATE TABLE Department (
  DeptID    INT         AUTO_INCREMENT PRIMARY KEY,
  DeptName  VARCHAR(40) NOT NULL
);

/* ---------- EMPLOYEE / CUSTOMER / APPLICANT ---------- */
CREATE TABLE Employee (
  PersonID  INT PRIMARY KEY,
  RankTitle VARCHAR(40),
  Title     VARCHAR(40),
  HireDate  DATE,
  DeptID    INT,
  FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
  FOREIGN KEY (DeptID)   REFERENCES Department(DeptID)
);

CREATE TABLE Customer (
  PersonID       INT PRIMARY KEY,
  PreferredRepID INT,
  FOREIGN KEY (PersonID)       REFERENCES Person(PersonID),
  FOREIGN KEY (PreferredRepID) REFERENCES Employee(PersonID)
);

CREATE TABLE Applicant (
  PersonID INT PRIMARY KEY,
  FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

/* ---------- SUPERVISION + DEPT HISTORY ---------- */
CREATE TABLE Supervision (
  SupervisorID  INT NOT NULL,
  SubordinateID INT NOT NULL,
  StartDate     DATE NOT NULL,
  EndDate       DATE,
  PRIMARY KEY (SupervisorID, SubordinateID, StartDate),
  FOREIGN KEY (SupervisorID) REFERENCES Employee(PersonID),
  FOREIGN KEY (SubordinateID) REFERENCES Employee(PersonID)
);

CREATE TABLE Emp_Department_History (
  PersonID  INT NOT NULL,
  DeptID    INT NOT NULL,
  StartDate DATE NOT NULL,
  EndDate   DATE,
  PRIMARY KEY (PersonID, DeptID, StartDate),
  FOREIGN KEY (PersonID) REFERENCES Employee(PersonID),
  FOREIGN KEY (DeptID)   REFERENCES Department(DeptID)
);

/* ---------- JOBS, APPLICATIONS, INTERVIEWS ---------- */
CREATE TABLE Job (
  JobID       INT AUTO_INCREMENT PRIMARY KEY,
  Description VARCHAR(80),
  PostedDate  DATE,
  DeptID      INT NOT NULL,
  FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

CREATE TABLE Application (
  PersonID  INT NOT NULL,
  JobID     INT NOT NULL,
  ApplyDate DATE,
  PRIMARY KEY (PersonID, JobID),
  FOREIGN KEY (PersonID) REFERENCES Applicant(PersonID),
  FOREIGN KEY (JobID)    REFERENCES Job(JobID)
);

CREATE TABLE Interview (
  InterviewID   INT AUTO_INCREMENT PRIMARY KEY,
  JobID         INT NOT NULL,
  InterviewTime DATETIME,
  FOREIGN KEY (JobID) REFERENCES Job(JobID)
);

CREATE TABLE Interview_Participant (
  InterviewID INT NOT NULL,
  PersonID    INT NOT NULL,
  Role        ENUM('INTERVIEWER','INTERVIEWEE') NOT NULL,
  Grade       TINYINT,
  PRIMARY KEY (InterviewID, PersonID),
  FOREIGN KEY (InterviewID) REFERENCES Interview(InterviewID),
  FOREIGN KEY (PersonID)    REFERENCES Person(PersonID)
);

/* ---------- PRODUCTS, SITES, SALES ---------- */
CREATE TABLE Product (
  ProductID INT AUTO_INCREMENT PRIMARY KEY,
  ProdType  VARCHAR(40),
  Size      VARCHAR(20),
  ListPrice DECIMAL(10,2),
  Weight    DECIMAL(10,2),
  Style     VARCHAR(30)
);

CREATE TABLE Site (
  SiteID   INT AUTO_INCREMENT PRIMARY KEY,
  SiteName VARCHAR(40),
  Location VARCHAR(60)
);

CREATE TABLE Sale (
  SaleID     INT AUTO_INCREMENT PRIMARY KEY,
  SiteID     INT NOT NULL,
  SalesmanID INT NOT NULL,
  CustomerID INT NOT NULL,
  ProductID  INT NOT NULL,
  SaleTime   DATETIME,
  Qty        INT DEFAULT 1,
  FOREIGN KEY (SiteID)     REFERENCES Site(SiteID),
  FOREIGN KEY (SalesmanID) REFERENCES Employee(PersonID),
  FOREIGN KEY (CustomerID) REFERENCES Customer(PersonID),
  FOREIGN KEY (ProductID)  REFERENCES Product(ProductID)
);

/* ---------- VENDORS, PARTS, BOM ---------- */
CREATE TABLE Vendor (
  VendorID     INT AUTO_INCREMENT PRIMARY KEY,
  VendorName   VARCHAR(60),
  Address      VARCHAR(80),
  AccountNum   VARCHAR(20),
  CreditRating SMALLINT,
  WS_URL       VARCHAR(120)
);

CREATE TABLE Part (
  PartID   INT AUTO_INCREMENT PRIMARY KEY,
  PartName VARCHAR(40),
  Weight   DECIMAL(8,2),
  Style    VARCHAR(30)
);

CREATE TABLE Vendor_Part_Price (
  VendorID  INT NOT NULL,
  PartID    INT NOT NULL,
  UnitPrice DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (VendorID, PartID),
  FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID),
  FOREIGN KEY (PartID)   REFERENCES Part(PartID)
);

CREATE TABLE BOM (
  ProductID  INT NOT NULL,
  PartID     INT NOT NULL,
  QtyPerProd INT NOT NULL,
  PRIMARY KEY (ProductID, PartID),
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
  FOREIGN KEY (PartID)    REFERENCES Part(PartID)
);

/* ---------- PAYROLL ---------- */
CREATE TABLE Payroll (
  EmpID     INT NOT NULL,
  TxnNumber INT NOT NULL,
  PayDate   DATE NOT NULL,
  Amount    DECIMAL(10,2),
  PRIMARY KEY (EmpID, TxnNumber),
  FOREIGN KEY (EmpID) REFERENCES Employee(PersonID)
);
