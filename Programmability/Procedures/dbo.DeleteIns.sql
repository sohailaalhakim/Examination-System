SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeleteIns] (@Id INT)
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
        END TRY


      BEGIN CATCH
       PRINT 'the Error Is'+ERROR_MESSAGE()
      END CATCH
END	 
GO