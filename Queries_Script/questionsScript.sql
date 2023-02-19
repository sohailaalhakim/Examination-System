-- 1- create Questions table.
-- todo: add cascade on delete and cascade on update
DROP TABLE IF EXISTS dbo.question_choices
DROP TABLE IF EXISTS dbo.questions
CREATE TABLE questions(
	id INT IDENTITY,
	content NVARCHAR(200) NOT NULL,
	correct_ans CHAR(1) NOT NULL CHECK (correct_ans IN('a', 'b', 'c', 'd')),
	ques_type CHAR(3) NOT NULL CHECK (ques_type IN('T/F', 'MCQ')),
	course_id INT,
	A NVARCHAR(100),
	B NVARCHAR(100),
	C NVARCHAR(100),
	D NVARCHAR(100),
	CONSTRAINT ques_id_pk PRIMARY KEY (id),
	CONSTRAINT course_id_fk FOREIGN KEY (course_id) REFERENCES courses(id) ON UPDATE CASCADE  ON DELETE CASCADE
);

GO

-- 2- create Choices table.
--CREATE TABLE question_choices(
--	id INT IDENTITY,
--	question_id INT NOT NULL,
--choice CHAR(1) NOT NULL,
--	choice_contnet NVARCHAR(100) NOT NULL,
--	CONSTRAINT comp_id_quest_id_pk PRIMARY KEY(id,question_id),
--	CONSTRAINT question_id_fk FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE ON UPDATE CASCADE
--);

GO

-- 3- create Courses Table
--DROP TABLE IF EXISTS dbo.courses
--CREATE TABLE courses(
--	id INT IDENTITY,
--	name NVARCHAR(200) NOT NULL,
--	CONSTRAINT course_id_pk PRIMARY KEY(id),
--);

-- 4- Add relation forigin key with Courses table.

GO
-- Questions Stored Procedure
-- 1- Add New Question
-- Add choices to a question
DROP PROCEDURE IF EXISTS dbo.PROC_addChoicesToQuestions
GO
--CREATE PROC [dbo].[PROC_addChoicesToQuestions] 
--	@questionId INT,
--	@ch1 NVARCHAR(100),
--	@ch2 NVARCHAR(100),
--	@ch3 NVARCHAR(100),
--	@ch4 NVARCHAR(100)
--AS
--	BEGIN TRY
--		DECLARE @quesType AS CHAR(3)
--		SELECT @quesType=ques_type FROM questions WHERE id=@questionId
--    	IF EXISTS(SELECT ques_type FROM questions WHERE id=@questionId)
--			IF (@quesType = 't/f')
--				BEGIN
--            		INSERT INTO question_choices(question_id, choice_contnet, choice)
--				VALUES(@questionId, 'T', 'a'),(@questionId, 'F', 'b'),(@questionId, NULL, 'c'),(@questionId, NULL, 'd')
--				END
--			ELSE
--				BEGIN
--            		INSERT INTO question_choices(question_id, choice_contnet, choice)
--				VALUES(@questionId, @ch1, 'a'),(@questionId, @ch2, 'b'),(@questionId, @ch3, 'c'),(@questionId, @ch4, 'd')
--            END
--		ELSE 
--			BEGIN
--        		SELECT 'Question does not exist.' AS 'errorMessage'
--			END
--    END TRY
--	BEGIN CATCH
--		SELECT ERROR_MESSAGE() AS errorMessage
--	END CATCH

GO
-- todo check if correct answer existed at choices
DROP PROCEDURE IF EXISTS dbo.PROC_addNewQuestion
GO
CREATE PROCEDURE  [dbo].[PROC_addNewQuestion]
    @courseId INT,
	@content NVARCHAR(200),
	@type CHAR(3),
	@correctAns CHAR(1),
	@ch1 NVARCHAR(100)=NULL,
	@ch2 NVARCHAR(100)=NULL,
	@ch3 NVARCHAR(100)=NULL,
	@ch4 NVARCHAR(100)=NULL  
AS
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM courses WHERE id=@courseId)
			BEGIN
            	SELECT 'Course do not exist' AS 'message'
            END
		ELSE
			BEGIN
				IF (@type = 'mcq')
					BEGIN
                		INSERT INTO questions(course_id, content, ques_type,correct_ans, A, B, C, D)
						VALUES(@courseId, @content, @type, @correctAns, @ch1, @ch2, @ch3, @ch4)
					END
        		ELSE
					BEGIN
                    	INSERT INTO questions(course_id, content, ques_type,correct_ans, A, B)
						VALUES(@courseId, @content, @type, @correctAns, 'T', 'F')
                    END
			END			
	END TRY
	BEGIN CATCH
	 SELECT ERROR_MESSAGE() AS errorMessage
	END CATCH

GO


EXECUTE PROC_addNewQuestion @courseId=1, @content="is that is true?", @type='T/F', @correctAns='a',@ch1='ddd',@ch2='ddd',@ch4='fff',@ch3='fddd'  


-- 2- Update A Question
DROP PROCEDURE IF EXISTS dbo.PROC_updateChoicesOfAQuestion
GO
--CREATE PROC [dbo].[PROC_updateChoicesOfAQuestion]
--	@questionId INT,
--	@ch1 NVARCHAR(100),
--	@ch2 NVARCHAR(100)=NULL,
--	@ch3 NVARCHAR(100)=NULL,
--	@ch4 NVARCHAR(100)=NULL
--AS
--	BEGIN TRY
--		DECLARE @quesType AS CHAR(3)
--		SELECT @quesType=ques_type FROM questions WHERE id=@questionId
--    	IF EXISTS(SELECT * FROM questions WHERE id=@questionId)
--		BEGIN
--        	IF (@quesType = 'mcq')
--				BEGIN
--					DECLARE @id INT
--					SELECT * INTO #temp FROM question_choices qc WHERE qc.question_id=@questionId

--					DECLARE @counter INT
--					SET @counter = 1
--					WHILE EXISTS(SELECT * FROM #temp t)
--					BEGIN
--                    	SELECT TOP 1 @id=id FROM #temp t

--						IF (@counter = 1)
--							BEGIN
--                        		UPDATE question_choices
--								SET choice_contnet = COALESCE(@ch1, choice_contnet) 
--								WHERE id=@id
--							END
--						ELSE IF (@counter = 2)
--							BEGIN
--                        			UPDATE question_choices
--									SET choice_contnet = COALESCE(@ch2, choice_contnet) 
--									WHERE id=@id
--							END
--						ELSE IF (@counter = 3)
--						BEGIN
--                        		UPDATE question_choices
--								SET choice_contnet = COALESCE(@ch3, choice_contnet) 
--								WHERE id=@id
--						END
--						ELSE
--						BEGIN
--                        		UPDATE question_choices
--								SET choice_contnet = COALESCE(@ch4, choice_contnet) 
--								WHERE id=@id
--						END
--						SET @counter = @counter + 1

--						DELETE #temp WHERE id=@id
--                    END
            			
--				END
--        END	
--		ELSE 
--			BEGIN
--        		SELECT 'Question does notddd exist.' AS 'errorMessage'
--			END
--    END TRY
--	BEGIN CATCH
--		SELECT ERROR_MESSAGE() AS errorMessage
--	END CATCH

GO
DROP PROCEDURE IF EXISTS dbo.PROC_updateAQuestion
GO
CREATE PROC [dbo].[PROC_updateAQuestion]
	@questionId INT,
	@content NVARCHAR(200),
	@courseId INT=NULL,
	@type CHAR(3)=NULL,
	@correctAns CHAR(1)=NULL,
	@ch1 NVARCHAR(100)=NULL,
	@ch2 NVARCHAR(100)=NULL,
	@ch3 NVARCHAR(100)=NULL,
	@ch4 NVARCHAR(100)=NULL  
AS
BEGIN TRY
		IF NOT EXISTS (SELECT * FROM questions q WHERE id=@questionId)
			BEGIN
            	SELECT 'Question does not exist' AS 'errorMessage'
            END
		ELSE IF (@courseId IS NOT NULL AND NOT EXISTS(SELECT * FROM courses WHERE id=@courseId))
			BEGIN
        	    SELECT 'Course does not exist' AS 'errorMessage'
			END
		ELSE
			BEGIN
				IF (@type = 'mcq') BEGIN  
                	UPDATE questions SET content=@content,
					ques_type=COALESCE(@type, ques_type),
					course_id=COALESCE(@courseId, course_id),
					correct_ans=COALESCE(@correctAns, correct_ans),
					A=COALESCE(@ch1, A),
					B=COALESCE(@ch2, B),
					C=COALESCE(@ch3, C),
					D=COALESCE(@ch4, D)
					WHERE id = @questionId
                END
				ELSE 
					BEGIN
                    	UPDATE questions SET content=@content,
						ques_type=COALESCE(@type, ques_type),
						course_id=COALESCE(@courseId, course_id),
						correct_ans=COALESCE(@correctAns, correct_ans),
						A=COALESCE('T', A),
						B=COALESCE('F', B),
						C=NULL,
						D=NULL
						WHERE id = @questionId
                    END
			END			
	END TRY
	BEGIN CATCH
	 SELECT ERROR_MESSAGE() AS errorMessage
	END CATCH

GO	

EXECUTE PROC_updateAQuestion @questionId=1, @courseId=1, @content="is that false?", @type='t/f', @correctAns='a',@ch1='ddd',@ch2='ddd',@ch4='fff',@ch3='fddd'  


-- 3- Delete A Question By Id
DROP PROCEDURE IF EXISTS dbo.PROC_deleteAQuestion
GO
CREATE PROC [dbo].[PROC_deleteAQuestion]
	@questionId INT
AS
BEGIN TRY
		IF NOT EXISTS (SELECT * FROM questions q WHERE id=@questionId)
			BEGIN
            	SELECT 'Question does not exist' AS 'errorMessage'
            END
		ELSE
			BEGIN
        		DELETE questions 
				WHERE id = @questionId
			END			
	END TRY
	BEGIN CATCH
	 SELECT ERROR_MESSAGE() AS errorMessage
	END CATCH

EXECUTE PROC_deleteAQuestion 1

-- 4- Select A Question By Id
DROP PROCEDURE IF EXISTS dbo.PROC_getQuestionById
GO
CREATE PROC [dbo].[PROC_getQuestionById]
	@questionId INT
AS
	BEGIN TRY
        SELECT q.*, c.course_name
		FROM questions q, courses c
		WHERE q.course_id = c.id AND q.id=@questionId
	END TRY
	BEGIN CATCH
	 SELECT ERROR_MESSAGE() AS errorMessage
	END CATCH

EXEC PROC_getQuestionById 2
