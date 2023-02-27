
--==========================================================
-- Create table student --
--==========================================================
CREATE TABLE students(
	Std_id INT IDENTITY,
	Fname VARCHAR(200) NOT NULL,
	Lname VARCHAR(200)  NULL,
    	age INT,
	email VARCHAR(200) NULL,
	Street VARCHAR(200) NULL,
	Zip_code VARCHAR(200) NULL,
	phone VARCHAR(200) NULL,
	password INT,
	Dept_id INT,
	supervise_id INT,
	CONSTRAINT Std_id PRIMARY KEY(Std_id),
    	CONSTRAINT topic_course_id FOREIGN KEY (Dept_id) REFERENCES Department(Dept_Id) ,
	CONSTRAINT supervise_id FOREIGN KEY (supervise_id) REFERENCES Instructors(Ins_Id)
);
--==========================================================
-- Select All Students PROCEDURE --
--==========================================================
DROP PROCEDURE IF EXISTS selectAllStudents
GO
CREATE PROCEDURE selectAllStudents
AS
BEGIN TRY
SELECT * FROM students 
END TRY
BEGIN CATCH
print 'select topic faild'
END CATCH
--Calling 
GO
EXECUTE selectAllStudents
--==========================================================
-- SELECT  Student by id PROCEDURE --
--==========================================================
DROP PROCEDURE IF EXISTS selectStudentById
GO
CREATE PROCEDURE selectStudentById
  @Std_id INT 
AS
BEGIN TRY
SELECT s.*
FROM students s
WHERE s.Std_id=@Std_id
END TRY
BEGIN CATCH
print 'select student faild'
END CATCH
--Calling
EXECUTE selectStudentById 3


--==========================================================
-- insert new student PROCEDURE --
--==========================================================
DROP PROCEDURE IF EXISTS insertStudent
GO
CREATE PROCEDURE insertStudent 

   @Fname NVARCHAR(20)=NULL,
   @Lname NVARCHAR(20)=NULL,
   @age INT=NULL,
   @email NVARCHAR(20)=NULL,
   @Street NVARCHAR(20)=NULL,
   @city NVARCHAR(20)=NULL,
   @Zip_code INT=NULL,
   @phone NVARCHAR(20)=NULL,
   @password NVARCHAR(20)=NULL,
   @Dept_id INT=NULL,
   @supervise_id INT=NULL
AS
BEGIN
BEGIN TRY
INSERT INTO students 
VALUES(@Fname,@Lname,@age,@email,@Street,@city,@Zip_code,@phone,@password,@Dept_id,@supervise_id)
END TRY
BEGIN CATCH
PRINT 'Insert into student faild, the error'
END CATCH
END
--Calling
EXECUTE insertStudent 'walid','essam',50,'waleed@gmail.com','algalaa','mansoura',200,'01065183989','123',1,1

--==========================================================
-- update Students table by id PROCEDURE --
--==========================================================

DROP PROCEDURE IF EXISTS updateStudent
GO
CREATE PROCEDURE updateStudent 
   @Std_id INT,
   @Fname NVARCHAR(20)=NULL,
   @Lname NVARCHAR(20)=NULL,
   @age INT=NULL,
   @email NVARCHAR(20)=NULL,
   @Street NVARCHAR(20)=NULL,
   @city NVARCHAR(20)=NULL,
   @Zip_code INT=NULL,
   @phone NVARCHAR(20)=NULL,
   @password NVARCHAR(20)=NULL,
   @Dept_id INT=NULL,
   @supervise_id INT=NULL
AS
BEGIN
BEGIN TRY 
IF NOT EXISTS(SELECT * FROM students WHERE Std_id=@Std_id)
        PRINT 'The student is not exist'
ELSE
BEGIN
UPDATE students
SET Fname=COALESCE(@Fname,Fname),
    Lname=COALESCE(@Lname,Lname),
	age=COALESCE(@age,age),
	email=COALESCE(@email,email),
	Street=COALESCE(@Street,Street),
	city=COALESCE(@city,city),
	Zip_code=COALESCE(@Zip_code,Zip_code),
	phone=COALESCE(@phone,phone),
	password=COALESCE(@password,password),
	Dept_id=COALESCE(@Dept_id,Dept_id),
	supervise_id=COALESCE(@supervise_id,supervise_id)

WHERE Std_id=@Std_id
END
END TRY
BEGIN CATCH
PRINT 'update student failed'
END CATCH
END
--Calling
EXECUTE updateStudent 7,@email='walid@gmail.com'

--------------------------------
--SP delete topic by id
DROP PROCEDURE IF EXISTS deleteStudent
GO
CREATE PROCEDURE deleteStudent 
  @id INT
AS
BEGIN
BEGIN TRY
IF NOT EXISTS(SELECT * FROM students s WHERE s.Std_id=@id)
       BEGIN
	   PRINT 'Student is not exist'
	   END
ELSE
    BEGIN
    DELETE students WHERE Std_id=@id
    END
END TRY
BEGIN CATCH
PRINT 'Faild delete student'
END CATCH
END

---Callig
EXECUTE deleteStudent 11

--================================================================--
-- [Report] SELECT  Student grades In All Courses by id PROCEDURE --
--================================================================--
DROP PROCEDURE IF EXISTS gradesInAllCoursesById
GO
CREATE PROCEDURE gradesInAllCoursesById
  @Std_id INT 
AS
BEGIN TRY
SELECT s.Fname+' '+s.Lname AS [FULL Name],c.course_name,cs.grade
FROM  courses_students cs ,courses c ,students s
WHERE cs.student_id=@Std_id AND c.id=cs.course_id AND s.Std_id=@Std_id
END TRY
BEGIN CATCH
print 'select student faild'
END CATCH
--Calling
EXECUTE gradesInAllCoursesById 2
