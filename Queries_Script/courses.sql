
---------------------------------------
-- SP select all courses
CREATE PROCEDURE selectCourses 
AS
BEGIN 
BEGIN TRY
SELECT * FROM courses 
END TRY 
BEGIN CATCH
PRINT 'Faild to select courses'+ERROR_MESSAGE()
END CATCH
END
--Calling
EXECUTE selectCourses
--------------------------------

CREATE PROCEDURE selectCourseById 
  @id INT 
AS
BEGIN
BEGIN TRY
SELECT * FROM courses c
WHERE c.id=@id
END TRY
BEGIN CATCH
PRINT  'Faild to select courses'+ERROR_MESSAGE()
END CATCH
END
EXECUTE selectCourseById 13
----------------------------------
--SP insert new course
alter PROCEDURE insertCourses 
     @course_name NVARCHAR(200)
AS
BEGIN
BEGIN TRY
INSERT INTO courses 
VALUES(@course_name)
END TRY
BEGIN CATCH
PRINT 'Insert into courses faild, the error'+ERROR_MESSAGE()
END CATCH
END
--Calling
EXECUTE insertCourses 'Soft Skills'
-------------------------------------
-- SP update course
alter PROCEDURE updateCourses
  @id INT,
  @course_name NVARCHAR(200)
AS
BEGIN
BEGIN TRY
IF NOT EXISTS(SELECT * FROM courses WHERE id=@id)
        PRINT'Course is not exist'
ELSE
UPDATE courses
SET  course_name = @course_name
WHERE id = @id;
END TRY
BEGIN CATCH
PRINT 'Error updating courses'+ERROR_MESSAGE()
--THROW;
END CATCH;
END
--Calling
EXECUTE updateCourses 11,'c++'
----------------------------------
-- SP delete course by id 
create PROCEDURE deleteCourseById
     @id INT
AS
BEGIN TRY
IF NOT EXISTS (SELECT*FROM courses WHERE id=@id)
       BEGIN
	   PRINT 'Course is not exist'
	   END
ELSE
       BEGIN
       DELETE courses WHERE id=@id
       END
END TRY
BEGIN CATCH
PRINT 'Faild delete courses, the error'+ERROR_MESSAGE()
END CATCH
--Calling
EXECUTE deleteCourseById 10
