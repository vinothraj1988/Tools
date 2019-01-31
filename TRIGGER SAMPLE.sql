--CREATE TABLE Employee_Demo
--(
-- Emp_ID int identity,
-- Emp_Name varchar(55),
-- Emp_Sal decimal (10,2)
--)

--Insert into Employee_Demo values ('Amit',1000);
--Insert into Employee_Demo values ('Mohan',1200);
--Insert into Employee_Demo values ('Avin',1100);
--Insert into Employee_Demo values ('Manoj',1300);
--Insert into Employee_Demo values ('ganesh',1500);

--create table Employee_Demo_Audit
--(
-- Emp_ID int,
-- Emp_Name varchar(55),
-- Emp_Sal decimal(10,2),
-- Audit_Action varchar(100),
-- Audit_Timestamp datetime
--) 


CREATE TRIGGER trgAfterInsert on Employee_Demo
FOR INSERT 
AS
insert into Employee_Demo_Audit
		(Emp_ID,Emp_Name,Emp_Sal,Audit_Action,Audit_Timestamp)
select  Emp_ID , Emp_Name , Emp_Sal , 'New Record', getdate() from inserted;


CREATE TRIGGER trgAfterUpdate ON dbo.Employee_Demo
FOR UPDATE
AS
insert into Employee_Demo_Audit
		(Emp_ID,Emp_Name,Emp_Sal,Audit_Action,Audit_Timestamp)
select  Emp_ID , Emp_Name , Emp_Sal , 'Update Record', getdate() from inserted;

CREATE TRIGGER trgAfterDelete ON dbo.Employee_Demo
FOR  DELETE
AS
insert into Employee_Demo_Audit
		(Emp_ID,Emp_Name,Emp_Sal,Audit_Action,Audit_Timestamp)
select  Emp_ID , Emp_Name , Emp_Sal , 'Deleted Record', getdate() from deleted;


SELECT * FROM Employee_Demo_Audit
SELECT * FROM Employee_Demo

