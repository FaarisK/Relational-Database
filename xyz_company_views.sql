
USE xyz_company;

-- View 1: Average salary per employee
CREATE OR REPLACE VIEW v_AvgMonthlySalary AS
SELECT EmpID,
       ROUND(AVG(Amount),2) AS AvgMonthlySalary
FROM   Payroll
GROUP  BY EmpID;

-- View 2: Rounds passed per applicant/job
CREATE OR REPLACE VIEW v_RoundsPassed AS
SELECT ip.PersonID AS ApplicantID,
       i.JobID,
       COUNT(*)      AS RoundsPassed
FROM   Interview_Participant ip
JOIN   Interview i  ON i.InterviewID = ip.InterviewID
WHERE  ip.Role = 'INTERVIEWEE'
  AND  ip.Grade >= 60
GROUP  BY ip.PersonID, i.JobID;

-- View 3: Items sold per product type
CREATE OR REPLACE VIEW v_ItemsSoldByType AS
SELECT p.ProdType,
       SUM(s.Qty) AS TotalItems
FROM   Sale s
JOIN   Product p ON p.ProductID = s.ProductID
GROUP  BY p.ProdType;

-- View 4: Part purchase cost per product
CREATE OR REPLACE VIEW v_PartCostPerProduct AS
SELECT b.ProductID,
       SUM(b.QtyPerProd * vpp.UnitPrice) AS TotalPartCost
FROM   BOM b
JOIN   Vendor_Part_Price vpp ON vpp.PartID = b.PartID
GROUP  BY b.ProductID;

SELECT * FROM v_AvgMonthlySalary LIMIT 5;
SELECT * FROM v_RoundsPassed      LIMIT 5;
SELECT * FROM v_ItemsSoldByType   LIMIT 5;
SELECT * FROM v_PartCostPerProduct LIMIT 5;
