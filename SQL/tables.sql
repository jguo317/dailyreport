SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[projects]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[projects](
	[project_id] [int] IDENTITY(1,1) NOT NULL,
	[project_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_projects] PRIMARY KEY CLUSTERED 
(
	[project_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[teams_to_users]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[teams_to_users](
	[ttu_id] [int] IDENTITY(1,1) NOT NULL,
	[ttu_frn_team_id] [int] NOT NULL,
	[ttu_frn_user_id] [int] NOT NULL,
 CONSTRAINT [PK_teams_to_users] PRIMARY KEY CLUSTERED 
(
	[ttu_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user_access]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[user_access](
	[ua_id] [int] IDENTITY(1,1) NOT NULL,
	[ua_frn_user_id] [int] NOT NULL,
	[ua_username] [varchar](50) NOT NULL,
	[ua_password] [varchar](50) NOT NULL,
 CONSTRAINT [PK_user_access] PRIMARY KEY CLUSTERED 
(
	[ua_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[teams]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[teams](
	[team_id] [int] IDENTITY(1,1) NOT NULL,
	[team_name] [varchar](50) NOT NULL,
	[team_send_email] [bit] NOT NULL,
	[team_send_email_from] [varchar](50) NULL,
	[team_send_email_to] [varchar](500) NULL,
	[team_send_email_subject] [varchar](50) NULL,
	[team_send_email_cc] [varchar](5000) NULL,
 CONSTRAINT [PK_teams] PRIMARY KEY CLUSTERED 
(
	[team_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[reports]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[reports](
	[report_id] [int] IDENTITY(1,1) NOT NULL,
	[report_frn_p_id] [int] NOT NULL,
	[report_details] [varchar](5000) NOT NULL,
	[report_jira] [varchar](50) NULL,
	[report_frn_user_id] [int] NOT NULL,
	[report_timeframe] [float] NOT NULL,
	[report_timestamp] [datetime] NOT NULL CONSTRAINT [DF_reports_report_timestamp]  DEFAULT (getdate()),
	[report_progress] [int] NOT NULL,
	[report_block] [varchar](5000) NULL,
 CONSTRAINT [PK_reports] PRIMARY KEY CLUSTERED 
(
	[report_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[project_status]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[project_status](
	[ps_id] [int] IDENTITY(1,1) NOT NULL,
	[ps_version] [varchar](100) NULL,
	[ps_frn_p_id] [int] NOT NULL,
	[ps_details] [text] NULL,
	[ps_status] [varchar](10) NULL,
	[ps_release] [datetime] NOT NULL,
	[ps_timestamp] [datetime] NOT NULL CONSTRAINT [DF_project_status_ps_timestamp]  DEFAULT (getdate()),
	[ps_frn_user_id] [int] NOT NULL,
	[ps_item_total] [int] NOT NULL,
	[ps_item_open] [int] NOT NULL,
	[ps_item_closed] [int] NOT NULL,
	[ps_item_tested] [int] NOT NULL,
 CONSTRAINT [PK_project_status] PRIMARY KEY CLUSTERED 
(
	[ps_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[project_owners]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[project_owners](
	[po_id] [int] IDENTITY(1,1) NOT NULL,
	[po_frn_user_id] [int] NOT NULL,
	[po_frn_p_id] [int] NOT NULL,
 CONSTRAINT [PK_project_owner] PRIMARY KEY CLUSTERED 
(
	[po_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[users]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[user_fname] [varchar](50) NOT NULL,
	[user_lname] [varchar](50) NOT NULL,
	[user_email] [varchar](50) NOT NULL,
	[user_timestamp] [datetime] NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
