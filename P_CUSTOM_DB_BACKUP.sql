-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,VINOTH RAJ>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- EXEC Proc_backup_DB @name='LynxSystem_Parallel',@path='D:\',@mode='backup'
-- EXEC Proc_backup_DB @name='LynxSystem_Parallel',@path='D:\',@mode='restore'
-- =============================================
CREATE PROCEDURE P_CUSTOM_DB_BACKUP 
	 @name VARCHAR(50) = NULL, -- database name  
	 @path VARCHAR(256) = NULL,
	 @mode varchar(50) = NULL 
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @fileName VARCHAR(256) -- filename for backup  
	DECLARE @fileDate VARCHAR(20) -- used for file name

	IF @mode != NULL
       BEGIN
		 IF(@mode = 'backup')
		 BEGIN
		       SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) + REPLACE(CONVERT(VARCHAR(20),GETDATE(),108),':','')
			   SET @fileName = @path + @name + '_' + @fileDate + '.BAK'  
			   BACKUP DATABASE @name TO DISK = @fileName  
		 END

		 IF(@mode = 'restore')
		 BEGIN
			RESTORE DATABASE LynxSystem_Parallel 
			FROM DISK = @Path
			WITH Recovery
		 END
       END

END

GO
