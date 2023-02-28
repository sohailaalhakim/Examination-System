DROP TABLE IF EXISTS Department
CREATE TABLE Department
(
Dept_Id INT PRIMARY KEY IDENTITY,
Dept_Name VARCHAR(20) NOT NULL ,
Dept_Phone NUMERIC,
Dept_Location VARCHAR(50),
Dept_Manager INT,
Manager_HireDate DATE DEFAULT GETDATE()
CONSTRAINT dept_manager_fk FOREIGN KEY (Dept_Manager) REFERENCES Instructors(ins_id) ON UPDATE CASCADE  ON DELETE SET NULL
)

ALTER TABLE dbo.Department
	DROP Dept_ID  -- COLLATE Latin1_General_CI_AS
	-- CONSTRAINT DF_Department_Manager_HireDate DEFAULT NULL
GO

GO



--INSERT INTO Department(Dept_Id,Dept_Name, Dept_Phone, Dept_Location, Dept_Manager)
--VALUES(3,'Cloud','12444','Smart',3)

----------------------------------------------------------------------
-- [1] ----- Select -------
CREATE PROC getDept @id INT
AS
BEGIN TRY
	SELECT * FROM Department D
	WHERE D.Dept_Id = @id
END TRY
BEGIN CATCH
	select'This id is not found'
END CATCH

--Calling
getDept 1


-- [2] ------ Insert ------
CREATE PROC addDept @id INT,
					@name VARCHAR(20),
					@phone INT = NULL,
					@location VARCHAR(50) = NULL,
					@Dmanager INT =NULL,
					@hireDate DATE =NULL
AS
BEGIN TRY
	INSERT INTO Department
	VALUES(@id,@name,@phone,@location,@Dmanager,@hireDate)
END TRY
BEGIN CATCH
		select'Dublicated id '
END CATCH

-- Calling
addDept 4,'PD',012555,'Smart',6


-- [3] ------ Update ------
CREATE PROC updateDept @id INT, 
					  @name VARCHAR(20),
					  @phone INT = NULL,
					  @location VARCHAR(50) = NULL,
					  @Dmanager INT,
					  @hireDate DATE =NULL
AS
IF EXISTS(SELECT d.Dept_Id FROM Department d WHERE d.Dept_Id= @id)
	BEGIN
		UPDATE Department 
			SET Dept_Name = @name,
				Dept_Phone = @phone,
				Dept_Location = @location,
				Dept_Manager = @Dmanager,
				Manager_HireDate = @hireDate
		WHERE Dept_Id = @id
	END 
ELSE
	SELECT 'This id is not found'

--Calling
updateDept 44,'aws',2012302,'Alex',7



-- [4] ------ Delete ------
CREATE PROC deleteDept @id INT
AS

IF EXISTS(SELECT d.Dept_Id FROM Department d WHERE d.Dept_Id= @id)
	BEGIN
		DELETE FROM Department
		WHERE Dept_Id = @id
	END 
ELSE 
	SELECT 'this id is not found'


--Calling
deleteDept 5



--report 1
Create PROC [dbo].[departmentStudents] @dept_id INT
AS
IF EXISTS(SELECT * FROM department WHERE Dept_Id = @dept_id)
BEGIN 
IF EXISTS(SELECT s.Dept_id,D.Dept_Id FROM students s, department D WHERE s.Dept_id=D.Dept_Id AND D.Dept_Id=@dept_id)
BEGIN
SELECT s.* FROM students s, department d 
WHERE s.Dept_id=D.Dept_Id AND D.Dept_Id=@dept_id
END
ELSE
SELECT 'no students in this department'
END
ELSE
SELECT 'department does not exist' AS 'result'
GO
