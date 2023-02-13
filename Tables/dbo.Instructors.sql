CREATE TABLE [dbo].[Instructors] (
  [id] [int] NOT NULL,
  [name] [nchar](10) NULL,
  [age] [int] NULL,
  [Salary] [float] NULL,
  [st_id] [nchar](10) NULL,
  CONSTRAINT [PK_Instructors] PRIMARY KEY CLUSTERED ([id])
)
GO