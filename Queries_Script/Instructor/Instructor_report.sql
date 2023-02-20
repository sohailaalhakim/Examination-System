DROP TABLE IF EXISTS courses_students
GO
CREATE TABLE courses_students(
	id INT IDENTITY,
	course_id INT,
	student_id INT,
	CONSTRAINT id_course_student_pk PRIMARY KEY (id),
	CONSTRAINT cs_course_id_fk FOREIGN KEY (course_id) REFERENCES courses(id) ON UPDATE CASCADE  ON DELETE SET NULL,
	CONSTRAINT ci_student_id_fk FOREIGN KEY (student_id) REFERENCES students(Std_id) ON UPDATE CASCADE ON DELETE SET NULL
);
GO

-- create procedure that takes the instructor ID and returns the name of the courses that he teaches and the number of student per course.


DROP PROCEDURE IF EXISTS dbo.PROC_getInstructorCourses
GO
CREATE PROCEDURE  [dbo].[PROC_getInstructorCourses]
    @instructorId INT 
AS
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM Instructors i WHERE i.Ins_Id=@instructorId)
			BEGIN
            	SELECT 'Instructor does not exist' AS 'errorMessage'
            END
		ELSE
			BEGIN
				SELECT COUNT(s.Std_id) AS '#OfStud', c.course_name, i.Fname + i.Lname AS 'Name' FROM students s, courses c, Instructors i, courses_students cs
				WHERE cs.course_id = c.id AND cs.student_id = s.Std_id AND i.Ins_Id = c.instructor_id AND c.instructor_id = @instructorId
				GROUP BY c.course_name, i.Fname, i.Lname
			END			
	END TRY
	BEGIN CATCH
	 SELECT ERROR_MESSAGE() AS errorMessage
	END CATCH

	GO
	EXEC PROC_getInstructorCourses 2
	GO