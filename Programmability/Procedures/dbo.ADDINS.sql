SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

 CREATE PROCEDURE [dbo].[ADDINS] (@id  INTEGER,
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

        BEGIN TRY

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
       EnD TRY
	   BEGIN CATCH
		  PRINT 'the error is '+ERROR_MESSAGE();
		
		END CATCH
GO