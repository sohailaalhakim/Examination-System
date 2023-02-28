SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[UpdateInstructor]( @Id  INT, 
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
END TRY
BEGIN CATCH

  PRINT 'the Error is'+ ERROR_MESSAGE()
END CATCH
END
GO