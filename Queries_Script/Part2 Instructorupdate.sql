
  -- Procedure For Displaying all Instructors--
   DROP PROCEDURE IF EXISTS  selectAllInstructors
GO
CREATE PROCEDURE selectAllInstructors
AS
BEGIN TRy
SELECT * FROM Instructors 
END TRY

BEGIN CATCH
 PRINT 'the error is'+ ERROR_MESSAGE()
END CATCH
-----calling Select  -----
EXEC  selectAllInstructors

------------------------------------
  --GET Instructor By Id
   DROP PROCEDURE IF EXISTS  GETInsByID
GO
  CREATE PROCEDURE GETInsByID ( @Id INT)
  AS
  BEGIN try
  IF (SELECT COUNT(*) FROM Instructors i WHERE i.Ins_Id =@id) = 0
   SELECT('the instructor you select is not here') AS message
  ELSE
    (SELECT  * FROM Instructors i WHERE i.Ins_Id=@Id)
 END try
 BEGIN CATCH
 PRINT 'this Error is ' +ERROR_MESSAGE()
 END CATCH

---Calling get By Id ---
 EXEC GETInsByID 2

 ---------------------------------------------------
 -- INSERT  PROC
 DROP PROCEDURE IF EXISTS addINSTRUCTOR
GO
 CREATE PROCEDURE addINSTRUCTOR(@id  INTEGER,
                                          @first_name   NCHAR(10),
                                          @last_name     NCHAR(10),
										  @age          INT,
										  @email      VARCHAR(25),
										  @street     NCHAR(10),
										  @City       NCHAR(20),
										  @zip_Code    CHAR(10),
										  @password    CHAR(20),
                                          @salary        DECIMAL(10, 2),
										  	@Dept_Id          INT )
AS
  IF (SELECT COUNT(*) FROM Instructors i WHERE i.Ins_Id =@id) = 0
        BEGIN 
		
            INSERT INTO Instructors
            VALUES     ( @id,
                         @first_name,
                         @last_name,
                        @age,  
						@email,
						@street,
						@City,
						@zip_Code,
						@password,
						@salary,
						@Dept_Id
						)
       EnD
	 Else
    BEGIN try
          SELECT('this instructor is already exists')
    End  try
	   BEGIN CATCH
	  
		 SELECT 'You are in the CATCH block and the error is '+ERROR_MESSAGE() AS message
		
		END CATCH
	 ------calling Insert   ---------
EXEC addINSTRUCTOR  5,rodaina,ezz,25,'rody123@gmail.com',jji,mans,88890648,yyu834,8000,50

SELECT * FROM Instructors i


-----------------------------------------------

--Updating Instructor
 DROP PROCEDURE IF EXISTS UpdateInstructor
GO

CREATE PROCEDURE UpdateInstructor( @Id  INT, 
                                              @first_name   NCHAR(10),
                                           @last_name     NCHAR(10),
										  @age          INT,
										  @email      VARCHAR(25),
										  @street     NCHAR(10),
										  @City       NCHAR(20),
										  @zip_Code    CHAR(10),
										  @password    CHAR(20),

                                          @salary        DECIMAL(10, 2),
										  	@Dept_Id          INT
)
AS
BEGIN
DECLARE @Rowcount INT =0
BEGIN TRY  
SET @Rowcount = (SELECT COUNT(1) FROM Instructors i  WHERE i.Ins_Id=@Id)
IF (@Rowcount>0)
 BEGIN
   BEGIN TRAN

UPDATE  Instructors 
SET 
                         Ins_Id=@Id,
                        Fname= @first_name,
                       Lname=  @last_name,
                       age= @age,  
						email=@email,
						street=@street,
						 City=@City,
						Zip_Code=@zip_Code,
					  	 password=@password,
						salary=@salary,
				    Dept_Id=@Dept_Id
					WHERE Ins_Id = @Id
COMMIT TRAN
END

ELSE
SELECT('the instructor that you try to update is not exists ') AS ERRORMSG
END TRY

BEGIN CATCH

  PRINT 'the Error is'+ ERROR_MESSAGE()
END CATCH
END
-----calling Update ------
EXEC UpdateInstructor 2,'ALLi','ahmed',30,'ALI@gmail.com',sharm,REDSEA,23349778,TKG1256,7700,30


SELECT * FROM Instructors i
--Deleting
 DROP PROCEDURE IF EXISTS DeleteIns
GO
CREATE PROCEDURE DeleteIns (@Id INT)
AS
BEGIN 
  DECLARE @Rowcount INT=0
       BEGIN  TRY

       SET @Rowcount = (SELECT COUNT(1) FROM Instructors i  WHERE i.Ins_Id=@Id)
                IF (@Rowcount>0)
                         BEGIN
                                BEGIN  TRAN
                                  DELETE FROM Instructors WHERE Ins_Id=@Id
                                 COMMIT TRAN
                           END

						   ELSE
						   SELECT('This instructor in Not exists to delete it') AS ERRORMSG
        END TRY


      BEGIN CATCH
       PRINT 'the Error Is'+ERROR_MESSAGE()
	   ROLLBACK TRAN
      END CATCH
END	   
----calling Delete----
EXEC  DeleteIns 600

