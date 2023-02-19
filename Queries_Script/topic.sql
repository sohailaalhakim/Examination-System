-- create table topic
CREATE TABLE topic(
	id INT IDENTITY,
    course_id INT,
	topic_name NVARCHAR(200) NOT NULL,
	CONSTRAINT topic_id_pk PRIMARY KEY(id),
    CONSTRAINT topic_course_id FOREIGN KEY (course_id) REFERENCES courses(id) ON UPDATE CASCADE  ON DELETE CASCADE
);
------------------------------
-- SP  select all topic
DROP PROCEDURE IF EXISTS selectTopic
GO
ALTER PROCEDURE selectTopic
AS
BEGIN TRY
SELECT * FROM topic 
END TRY
BEGIN CATCH
print 'Select topic faild'
END CATCH
--Calling 
EXECUTE selectTopic
-----------------------------
-- SP select topic by course id 
DROP PROCEDURE IF EXISTS selectTopicById
GO
CREATE PROCEDURE selectTopicById
  @course_id INT 
AS
BEGIN TRY
SELECT t.* , c.course_name
FROM topic t , courses c
WHERE t.course_id=@course_id AND c.id=@course_id
END TRY
BEGIN CATCH
print 'Select topic faild'
END CATCH
--Calling
EXECUTE selectTopicById 13
-------------------------------
--SP insert new topic
DROP PROCEDURE IF EXISTS insertTopic
GO
CREATE PROCEDURE insertTopic 
   @course_id INT, @topic_name NVARCHAR(200)
AS
BEGIN TRY
IF NOT EXISTS(SELECT * FROM topic t WHERE t.course_id=@course_id)
      PRINT'This Course id is not exist'
INSERT INTO topic
VALUES(@course_id,@topic_name)
END TRY
BEGIN CATCH
PRINT 'Insert into topic faild'
END CATCH
--Calling
EXECUTE insertTopic 11,'Pointers'
--------------------------------
--SP update topic
DROP PROCEDURE IF EXISTS updateTopic
GO
CREATE PROCEDURE updateTopic 
   @id INT,
   @course_id INT=NULL,
   @topic_name NVARCHAR(200)=NULL
AS
BEGIN
BEGIN TRY 
IF NOT EXISTS(SELECT * FROM topic WHERE id=@id)
        PRINT 'The topic is not exist'
ELSE IF @course_id IS NOT NULL AND NOT EXISTS(SELECT * FROM courses c WHERE c.id=@course_id)
        PRINT 'The Course is not exist'
ELSE
BEGIN
UPDATE topic
SET course_id=COALESCE(@course_id,course_id),
    topic_name=COALESCE(@topic_name,topic_name)
WHERE id=@id
END
END TRY
BEGIN CATCH
PRINT 'Update topic failed'
END CATCH
END
--Calling
EXECUTE updateTopic 5,12,'Loops and Functions'
--------------------------------
--SP delete topic by id
DROP PROCEDURE IF EXISTS deleteTopic
GO
CREATE PROCEDURE deleteTopic 
  @id INT
AS
BEGIN
BEGIN TRY
IF NOT EXISTS(SELECT * FROM topic WHERE id=@id)
       BEGIN
	   PRINT 'Topic is not exist'
	   END
ELSE
    BEGIN
    DELETE topic WHERE id=@id
    END
END TRY
BEGIN CATCH
PRINT 'Faild delete topic'
END CATCH
END

---Callig
EXECUTE deleteTopic 6
------------------------------------