CREATE TABLE [dbo].[Students] (
  [id] [int] IDENTITY,
  [name] [nvarchar](50) NOT NULL,
  CONSTRAINT [PK_Students] PRIMARY KEY CLUSTERED ([id])
)
GO