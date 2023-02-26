-- 1- create Exam table.
DROP TABLE IF EXISTS dbo.exams_questions
DROP TABLE IF EXISTS dbo.exams
CREATE TABLE exams( 
	id INT IDENTITY,
	exam_name NVARCHAR(100) NOT NULL,
	duration INT NOT NULL,
	exam_date DATE NOT NULL,
	full_mark INT NOT NULL,
	course_id INT,
	CONSTRAINT exam_id_pk PRIMARY KEY (id),
	CONSTRAINT course_id_exam_fk FOREIGN KEY (course_id) REFERENCES courses(id) ON UPDATE CASCADE  ON DELETE CASCADE
);

CREATE TABLE exams_questions(
	id INT IDENTITY,
	exam_id INT NOT NULL,
	question_id INT NOT NULL,
	score INT,
	CONSTRAINT exam_quest_pk PRIMARY KEY (id),
	CONSTRAINT exam_id_ques_fk FOREIGN KEY (exam_id) REFERENCES exams(id),
	CONSTRAINT exam_id_ques_id_fk FOREIGN KEY (question_id) REFERENCES questions(id) ON UPDATE CASCADE  ON DELETE CASCADE
);

GO

DROP PROCEDURE IF EXISTS dbo.PROC_generate_exam
GO
CREATE PROCEDURE  [dbo].[PROC_generate_exam]
	@examName NVARCHAR(100),
    @courseId INT,
	@duration INT,
	@date DATE,
	@fullScore INT,
	@tfNum INT,
	@mcqNum INT
AS
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM courses WHERE id=@courseId)
			BEGIN
            	SELECT 'Course do not exist' AS 'message'
            END
		ELSE
			BEGIN
			INSERT INTO exams (exam_name, duration, exam_date, full_mark, course_id)
			VALUES (@examName, @duration, @date, @fullScore, @courseId);

			DECLARE @examId INT
			SET @examId = SCOPE_IDENTITY()

			INSERT INTO dbo.exams_questions(exam_id, question_id)
			SELECT TOP(@tfNum) @examId, q.id
			FROM questions q
			WHERE q.ques_type = 't/f'
			ORDER BY NEWID()

			INSERT INTO dbo.exams_questions(exam_id, question_id)
			SELECT TOP(@mcqNum) @examId, q.id
			FROM questions q
			WHERE q.ques_type = 'mcq'
			ORDER BY NEWID()

			SELECT q.* FROM exams_questions eq, questions q, exams e
			WHERE eq.exam_id = e.id AND eq.question_id = q.id AND eq.exam_id = @examId
			END		
	END TRY
	BEGIN CATCH
	 SELECT ERROR_MESSAGE() AS errorMessage
	END CATCH

	GO
	EXECUTE PROC_generate_exam @examName='programming',
								@courseId = 1
							  ,@duration = 45
							  ,@date = '2023-02-19'
							  ,@fullScore = 50
							  ,@tfNum = 3
							  ,@mcqNum = 7

-- create Exam_Answer Table
DROP TABLE IF EXISTS dbo.exam_answers
CREATE TABLE exam_answers( 
	id INT IDENTITY,
	exam_id INT NOT NULL,
	question_id INT NOT NULL,
	student_id INT NOT NULL,
	answer NCHAR(1) NOT NULL,
	std_score INT,
	CONSTRAINT exam_answers_id_pk PRIMARY KEY (id),
	CONSTRAINT exam_id_exam_answers_fk FOREIGN KEY (exam_id) REFERENCES exams(id),
	CONSTRAINT ques_id_exam_answers_fk FOREIGN KEY (question_id) REFERENCES questions(id) ON UPDATE CASCADE  ON DELETE CASCADE,
	CONSTRAINT student_id_exam_answers_fk FOREIGN KEY (student_id) REFERENCES students(Std_id) ON UPDATE CASCADE  ON DELETE CASCADE
);


-- Exam Answers Stored procedure
DROP PROCEDURE IF EXISTS dbo.PRO_examAnswers
GO
CREATE PROCEDURE  [dbo].[PRO_examAnswers]
    @examId INT,
	@student_id INT,
	@questionId INT,
	@ans NCHAR(1)
AS
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM exams WHERE id=@examId)
			BEGIN
            	SELECT 'Exam do not exist' AS 'errMessage'
            END
		ELSE IF NOT EXISTS (SELECT * FROM questions q WHERE id=@questionId)
		BEGIN
            SELECT 'Question does not exist' AS 'errMessage'
        END
		ELSE IF NOT EXISTS (SELECT * FROM students s WHERE s.Std_id=@student_id)
			BEGIN
            	SELECT 'Student does not exist' AS 'errMessage'
            END
		ELSE
			BEGIN	
				INSERT INTO exam_answers (exam_id, question_id, student_id, answer)
				VALUES (@examId, @questionId, @student_id, @ans);
			END		
	END TRY
	BEGIN CATCH
	 SELECT ERROR_MESSAGE() AS errorMessage
	END CATCH


	EXEC PRO_examAnswers @examId = 1
						,@student_id = 2
						,@questionId = 5
						,@ans = 'B'


-- Exam Correction Stored procedure
DROP PROCEDURE IF EXISTS dbo.PROC_examCorrect
GO
CREATE PROCEDURE  [dbo].[PROC_examCorrect]
    @exam_id INT,
	@student_id INT,
	@course_id INT
AS
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM exams WHERE id=@exam_id)
			BEGIN
            	SELECT 'Exam do not exist' AS 'errMessage'
            END
		ELSE IF NOT EXISTS (SELECT * FROM students s WHERE s.Std_id=@student_id)
			BEGIN
            	SELECT 'Student does not exist' AS 'errMessage'
            END
		ELSE IF NOT EXISTS (SELECT * FROM courses c WHERE c.id=@course_id)
		BEGIN
            SELECT 'Course does not exist' AS 'errMessage'
        END
		ELSE
			BEGIN	
				DECLARE @score INT

				SELECT @score = COUNT(*) FROM exam_answers ea
				INNER JOIN exams e ON e.id = ea.exam_id
				INNER JOIN questions q ON ea.question_id = q.id
				WHERE ea.student_id = @student_id AND ea.exam_id = @exam_id AND q.correct_ans = ea.answer

				UPDATE courses_students SET grade = @score WHERE student_id = @student_id AND course_id = @course_id 
			END		
	END TRY
	BEGIN CATCH
	 SELECT ERROR_MESSAGE() AS errorMessage
	END CATCH


	EXEC PROC_examCorrect @exam_id = 7
						 ,@student_id = 7
						 ,@course_id = 11
			
			
DROP PROCEDURE IF EXISTS dbo.PROC_getStudentAnswerWithModel
GO
CREATE PROCEDURE  [dbo].[PROC_getStudentAnswerWithModel]
    @exam_id INT,
	@student_id INT,
	@course_id INT
AS
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM exams WHERE id=@exam_id)
			BEGIN
            	SELECT 'Exam do not exist' AS 'errMessage'
            END
		ELSE IF NOT EXISTS (SELECT * FROM students s WHERE s.Std_id=@student_id)
			BEGIN
            	SELECT 'Student does not exist' AS 'errMessage'
            END
		ELSE IF NOT EXISTS (SELECT * FROM courses c WHERE c.id=@course_id)
		BEGIN
            SELECT 'Course does not exist' AS 'errMessage'
        END
		ELSE
			BEGIN	
				SELECT q.content, q.correct_ans, ea.answer AS 'student_ans' FROM exam_answers ea
				INNER JOIN exams e ON e.id = ea.exam_id
				INNER JOIN questions q ON ea.question_id = q.id
				WHERE ea.student_id = @student_id AND ea.exam_id = @exam_id AND q.correct_ans = ea.answer
			END		
	END TRY
	BEGIN CATCH
	 SELECT ERROR_MESSAGE() AS errorMessage
	END CATCH
	

	
	EXEC PROC_getStudentAnswerWithModel @exam_id = 7
						 ,@student_id = 7
						 ,@course_id = 11