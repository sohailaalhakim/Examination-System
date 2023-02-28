-- Reports 
-- Create stored procedure that takes course ID and returns its topics 
DROP PROCEDURE IF EXISTS reportForTopic
GO
CREATE PROCEDURE reportForTopic
  @course_id INT 
AS
BEGIN
BEGIN TRY
IF NOT EXISTS(SELECT * FROM topic t WHERE t.course_id=@course_id)
  PRINT 'This course is not exist'
ELSE
SELECT T.topic_name 
FROM topic t 
WHERE t.course_id=@course_id
END TRY
BEGIN CATCH
print 'Select topic faild'
END CATCH
END
--Calling
EXECUTE reportForTopic 25
---------------------------------------------
--Create stored procedure that takes exam number and returns the Questions in it and chocies [freeform report]
DROP PROCEDURE IF EXISTS reportForExamQues
GO
CREATE PROCEDURE reportForExamQues
  @exam_id INT 
  AS
  BEGIN 
  BEGIN TRY
  IF NOT EXISTS(SELECT * FROM exams e WHERE e.id=@exam_id)
    PRINT 'This exam is not exist'
  ELSE
  SELECT q.id,q.content , q.A , q.B , q.C, q.D
  FROM questions q , exams e ,exams_questions eq
  WHERE e.id=eq.exam_id AND  eq.question_id =q.id
  END TRY
  BEGIN CATCH
  print 'Select topic faild'
  END CATCH
  END
-- Calling
  EXECUTE reportForExamQues 7
 ---------------------------------------------
--Report that takes exam number and the student ID then returns the Questions in this exam
--WITH the student answers. 
DROP PROCEDURE IF EXISTS reportForStudentAns
GO 
CREATE PROCEDURE reportForStudentAns
    @exam_Id INT, @student_Id INT 
AS
BEGIN 
BEGIN TRY
	SELECT q.content , ea.answer
	FROM questions q , exam_answers ea,exams e,students s 
	WHERE ea.question_id=q.id  AND ea.student_id =s.Std_id AND e.id=ea.exam_id AND e.id=@exam_Id AND s.Std_id=@student_Id
END TRY
BEGIN CATCH
PRINT 'Select Report faild'
END CATCH
END
  EXEC  reportForStudentAns 7,4

  -----------
 --Another solution to last report PROC
  DROP PROCEDURE IF EXISTS reportForStudentAnss
GO 
CREATE PROCEDURE reportForStudentAnss
    @exam_Id INT, @student_Id INT 
	AS

	BEGIN 
	BEGIN TRY
	SELECT q.content , ea.answer
	FROM questions q , exam_answers ea,exams e,students s 
	
	WHERE ea.question_id=q.id  AND ea.student_id =s.Std_id AND e.id=ea.exam_id AND ea.id=@exam_Id AND ea.student_id=@student_Id
END TRY
	 BEGIN CATCH
  print 'Select Report faild'
  END CATCH
  END
  EXEC  reportForStudentAnss 5,4


