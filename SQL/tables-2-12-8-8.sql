GO
/****** Object:  Table [dbo].[item_status]    Script Date: 08/08/2012 10:08:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[item_status](
	[item_id] [int] IDENTITY(1,1) NOT NULL,
	[item_key] [varchar](20) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[item_status] [int] NOT NULL,
	[item_summary] [text] COLLATE Chinese_PRC_CI_AS NOT NULL,
	[item_priority] [int] NOT NULL,
	[item_tester] [int] NOT NULL,
	[item_reporter] [int] NOT NULL,
	[item_completed] [int] NULL,
	[item_comment] [text] COLLATE Chinese_PRC_CI_AS NULL,
	[item_timestamp] [datetime] NOT NULL CONSTRAINT [DF_item_status_item_timestamp]  DEFAULT (getdate()),
	[item_created] [bit] NOT NULL,
	[item_timeframe] [int] NULL,
	[item_frn_user_id] [int] NOT NULL,
 CONSTRAINT [PK_item_status] PRIMARY KEY CLUSTERED 
(
	[item_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF

GO
/****** Object:  Table [dbo].[item_status_type]    Script Date: 08/08/2012 10:20:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[item_status_type](
	[ist_id] [int] IDENTITY(1,1) NOT NULL,
	[ist_name] [varchar](20) COLLATE Chinese_PRC_CI_AS NOT NULL,
 CONSTRAINT [PK_item_status_type] PRIMARY KEY CLUSTERED 
(
	[ist_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF