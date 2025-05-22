-- Remove any rows that may duplicate keys from earlier tests
DELETE FROM Sale;
DELETE FROM Site;
DELETE FROM Vendor_Part_Price;
DELETE FROM Vendor;
DELETE FROM BOM;
DELETE FROM Part;
DELETE FROM Product;
DELETE FROM Interview_Participant;
DELETE FROM Interview;
DELETE FROM Application;
DELETE FROM Job;
DELETE FROM Applicant;
DELETE FROM Payroll;
DELETE FROM Supervision;
DELETE FROM Emp_Department_History;
DELETE FROM Employee;
DELETE FROM Customer;
DELETE FROM PersonPhone;
DELETE FROM Person;
DELETE FROM Department;


USE xyz_company;

/* ---- Departments ---- */
INSERT INTO Department VALUES
(1,'Marketing'),
(2,'Engineering');

/* ---- People + Email ---- */
ALTER TABLE Person ADD COLUMN Email VARCHAR(60);

INSERT INTO Person (PersonID,FirstName,LastName,Age,Gender,Email)
VALUES
(1,'Ali','Rehman',30,'M','ali@xyz.com'),
(2,'Hellen','Cole',29,'F','hellen@xyz.com'),
(3,'Sara','Khan',27,'F','sara@xyz.com'),
(4,'Bob','Lee',45,'M','bob@xyz.com');

INSERT INTO PersonPhone VALUES (2,'555‑2000'),(3,'555‑3000');

/* ---- Employees ---- */
INSERT INTO Employee VALUES
(1,'Senior','Engineer','2022-01-10',2),
(4,'Sales','Rep','2021-06-15',1);

/* Salary for E14 */
INSERT INTO Payroll VALUES
(1,8001,'2025-03-31',6000.00),
(1,8002,'2025-04-30',6200.00),
(4,9001,'2025-04-30',3500.00);

/* Supervisor chain for E3 */
INSERT INTO Supervision VALUES (1,4,'2022-07-01',NULL);

/* Emp has worked in ALL depts for E11 */
INSERT INTO Emp_Department_History VALUES
(1,1,'2022-01-10', '2022-06-30'),
(1,2,'2022-07-01', NULL);

/* ---- Customers ---- */
INSERT INTO Customer (PersonID,PreferredRepID) VALUES (2,4);

/* ---- Applicants ---- */
INSERT INTO Applicant VALUES (2),(3),(4);   -- note: 4 is employee+applicant

/* ---- Jobs ---- */
INSERT INTO Job (JobID,Description,PostedDate,DeptID) VALUES
(11111,'Consultant','2025-04-01',1),   -- Marketing, April
(12345,'Junior Dev','2025-04-15',2),   -- Engineering, April
(22222,'Marketing Asst','2011-01-10',1);  -- **Marketing in Jan 2011 for E2**

/* ---- Applications ---- */
INSERT INTO Application VALUES
(2,11111,'2025-04-05'),
(3,12345,'2025-04-20'),
(4,12345,'2025-04-22');   -- employee applying (E8)

/* ---- Interviews for job 11111 (Hellen Cole) ---- */
INSERT INTO Interview VALUES
(501,11111,'2025-04-07 10:00'),
(502,11111,'2025-04-08 10:00'),
(503,11111,'2025-04-09 10:00'),
(504,11111,'2025-04-10 10:00'),
(505,11111,'2025-04-11 10:00');

-- Interviewee grades ≥60 (passes 5 rounds, avg>70)
INSERT INTO Interview_Participant VALUES
(501,2,'INTERVIEWEE',75),(502,2,'INTERVIEWEE',80),
(503,2,'INTERVIEWEE',78),(504,2,'INTERVIEWEE',82),
(505,2,'INTERVIEWEE',85);

-- Ali Rehman is interviewer
INSERT INTO Interview_Participant (InterviewID,PersonID,Role) VALUES
(501,1,'INTERVIEWER'),(502,1,'INTERVIEWER'),(503,1,'INTERVIEWER'),
(504,1,'INTERVIEWER'),(505,1,'INTERVIEWER');

/* ---- Products & Parts ---- */
INSERT INTO Product VALUES
(200,'Widget','M',300.00,2.5,'Modern'),
(201,'Gadget','S',250.00,1.8,'Classic');

INSERT INTO Part VALUES
(300,'Gear',1.2,'Steel'),
(301,'Cup',3.5,'Plastic');

/* ---- Vendor & Pricing ---- */
INSERT INTO Vendor VALUES
(400,'Acme Parts','123 Main','AC‑100','350','http://acme/api');

INSERT INTO Vendor_Part_Price VALUES
(400,300,15.00),
(400,301,10.00);

/* ---- BOM ---- */
INSERT INTO BOM VALUES
(200,300,4),
(201,301,2);

/* ---- Sites & Sales ---- */
INSERT INTO Site VALUES
(500,'OnlineStore','Dallas');

-- Bob Lee sells both product types (>200$)
INSERT INTO Sale (SiteID,SalesmanID,CustomerID,ProductID,SaleTime,Qty) VALUES
(500,4,2,200,'2025-05-01 12:00',3),
(500,4,2,201,'2025-05-02 12:00',2);
