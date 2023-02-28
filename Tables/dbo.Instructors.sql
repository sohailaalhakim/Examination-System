CREATE TABLE [dbo].[Instructors] (
  [Ins_Id] [int] NOT NULL,
  [Fname] [nchar](10) NULL,
  [Lname] [nchar](10) NULL,
  [age] [int] NULL,
  [email] [varchar](25) NULL,
  [street] [nchar](10) NULL,
  [City] [nchar](20) NULL,
  [Zip_Code] [char](10) NULL,
  [password] [char](20) NULL,
  [salary] [numeric] NULL,
  [Dept_Id] [int] NOT NULL,
  CONSTRAINT [PK_Instructors] PRIMARY KEY CLUSTERED ([Ins_Id])
)
GO