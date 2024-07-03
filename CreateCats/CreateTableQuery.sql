USE [TestDB]
GO

/****** Object:  Table [dbo].[Category]    Script Date: 7/13/2021 2:04:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[ParentId] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Category] ADD  CONSTRAINT [DF_Category_ParentCategoryId]  DEFAULT ((0)) FOR [ParentId]
GO

ALTER TABLE [dbo].[Category] ADD  CONSTRAINT [DF_Category_Active]  DEFAULT ((1)) FOR [Active]
GO
