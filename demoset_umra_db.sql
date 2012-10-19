/****** Object:  Table [dbo].[Snapshots]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Snapshots](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[description] [varchar](255) NOT NULL,
	[timestamp_start] [datetime] NOT NULL,
	[timestamp_end] [datetime] NULL,
	[status] [varchar](255) NULL,
 CONSTRAINT [PK_Snapshots] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Relationships]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Relationships](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[type] [varchar](100) NOT NULL,
	[id_object_parent] [bigint] NOT NULL,
	[id_object_child] [bigint] NOT NULL,
 CONSTRAINT [PK_Relationships] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_Relationships] ON [dbo].[Relationships] 
(
	[id_object_child] ASC,
	[id_object_parent] ASC,
	[type] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Objects]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Objects](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_snapshot] [bigint] NOT NULL,
	[type] [varchar](255) NOT NULL,
	[source] [varchar](255) NOT NULL,
 CONSTRAINT [PK_Objects] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_Objects] ON [dbo].[Objects] 
(
	[id_snapshot] ASC,
	[source] ASC,
	[type] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ObjectAttributes]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ObjectAttributes](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_object] [bigint] NOT NULL,
	[is_key] [bit] NOT NULL,
	[is_show] [bit] NOT NULL,
	[attribute_name] [varchar](255) NOT NULL,
	[attribute_value] [varchar](500) NULL,
 CONSTRAINT [PK_ObjectAttributes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_ObjectAttributes] ON [dbo].[ObjectAttributes] 
(
	[id_object] ASC,
	[attribute_name] ASC,
	[attribute_value] ASC,
	[is_key] ASC,
	[is_show] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Notifications]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Notifications](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[description] [varchar](255) NOT NULL,
	[type] [varchar](50) NOT NULL,
	[mail_to] [varchar](255) NOT NULL,
	[mail_cc] [varchar](255) NULL,
	[mail_bcc] [varchar](255) NULL,
	[mail_from] [varchar](255) NOT NULL,
	[mail_subject] [varchar](max) NOT NULL,
	[mail_body] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Log]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[timestamp] [datetime] NOT NULL,
	[description] [varchar](255) NOT NULL,
	[type_operation] [varchar](100) NOT NULL,
	[status_operation] [varchar](255) NULL,
	[status_script] [varchar](500) NULL,
	[user_operator] [varchar](50) NULL,
	[object_managed_primary] [varchar](255) NULL,
	[object_managed_secondary] [varchar](255) NULL,
 CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[JobVariables]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JobVariables](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_job] [bigint] NOT NULL,
	[variable_name] [varchar](255) NOT NULL,
	[variable_value] [varchar](max) NOT NULL,
 CONSTRAINT [PK_JobVariables] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Jobs]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Jobs](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_task] [bigint] NOT NULL,
	[type] [varchar](100) NOT NULL,
	[timestamp_created] [datetime] NOT NULL,
	[timestamp_start] [datetime] NULL,
	[timestamp_end] [datetime] NULL,
	[status] [varchar](max) NULL,
	[umra_project] [varchar](255) NOT NULL,
	[closed] [bit] NOT NULL,
 CONSTRAINT [PK_Jobs] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Cache_table_users]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cache_table_users](
	[source] [varchar](255) NULL,
	[dn] [varchar](max) NULL,
	[attribute_1] [varchar](max) NULL,
	[attribute_2] [varchar](max) NULL,
	[attribute_3] [varchar](max) NULL,
	[attribute_4] [varchar](max) NULL,
	[attribute_5] [varchar](max) NULL,
	[attribute_6] [varchar](max) NULL,
	[attribute_7] [varchar](max) NULL,
	[attribute_8] [varchar](max) NULL,
	[attribute_9] [varchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Cache_table_groups]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cache_table_groups](
	[source] [varchar](255) NULL,
	[dn] [varchar](max) NULL,
	[attribute_1] [varchar](max) NULL,
	[attribute_2] [varchar](max) NULL,
	[attribute_3] [varchar](max) NULL,
	[attribute_4] [varchar](max) NULL,
	[attribute_5] [varchar](max) NULL,
	[attribute_6] [varchar](max) NULL,
	[attribute_7] [varchar](max) NULL,
	[attribute_8] [varchar](max) NULL,
	[attribute_9] [varchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Cache_table_dn_sAMAccountName]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cache_table_dn_sAMAccountName](
	[source] [varchar](255) NULL,
	[distinguishedName] [varchar](500) NOT NULL,
	[sAMAccountName] [varchar](100) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Batches]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Batches](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[description] [varchar](255) NULL,
	[timestamp_created] [datetime] NOT NULL,
	[timestamp_schedule] [datetime] NULL,
	[timestamp_start] [datetime] NULL,
	[timestamp_end] [datetime] NULL,
	[limit_execute_run] [int] NOT NULL,
	[allow_auto_run] [bit] NOT NULL,
	[closed] [bit] NOT NULL,
 CONSTRAINT [PK_Batches] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Staging_table]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Staging_table](
	[field_0] [varchar](max) NULL,
	[field_1] [varchar](max) NULL,
	[field_2] [varchar](max) NULL,
	[field_3] [varchar](max) NULL,
	[field_4] [varchar](max) NULL,
	[field_5] [varchar](max) NULL,
	[field_6] [varchar](max) NULL,
	[field_7] [varchar](max) NULL,
	[field_8] [varchar](max) NULL,
	[field_9] [varchar](max) NULL,
	[field_10] [varchar](max) NULL,
	[field_11] [varchar](max) NULL,
	[field_12] [varchar](max) NULL,
	[field_13] [varchar](max) NULL,
	[field_14] [varchar](max) NULL,
	[field_15] [varchar](max) NULL,
	[field_16] [varchar](max) NULL,
	[field_17] [varchar](max) NULL,
	[field_18] [varchar](max) NULL,
	[field_19] [varchar](max) NULL,
	[field_20] [varchar](max) NULL,
	[field_21] [varchar](max) NULL,
	[field_22] [varchar](max) NULL,
	[field_23] [varchar](max) NULL,
	[field_24] [varchar](max) NULL,
	[field_25] [varchar](max) NULL,
	[field_26] [varchar](max) NULL,
	[field_27] [varchar](max) NULL,
	[field_28] [varchar](max) NULL,
	[field_29] [varchar](max) NULL,
	[field_30] [varchar](max) NULL,
	[field_31] [varchar](max) NULL,
	[field_32] [varchar](max) NULL,
	[field_33] [varchar](max) NULL,
	[field_34] [varchar](max) NULL,
	[field_35] [varchar](max) NULL,
	[field_36] [varchar](max) NULL,
	[field_37] [varchar](max) NULL,
	[field_38] [varchar](max) NULL,
	[field_39] [varchar](max) NULL,
	[field_40] [varchar](max) NULL,
	[field_41] [varchar](max) NULL,
	[field_42] [varchar](max) NULL,
	[field_43] [varchar](max) NULL,
	[field_44] [varchar](max) NULL,
	[field_45] [varchar](max) NULL,
	[field_46] [varchar](max) NULL,
	[field_47] [varchar](max) NULL,
	[field_48] [varchar](max) NULL,
	[field_49] [varchar](max) NULL,
	[field_50] [varchar](max) NULL,
	[field_51] [varchar](max) NULL,
	[field_52] [varchar](max) NULL,
	[field_53] [varchar](max) NULL,
	[field_54] [varchar](max) NULL,
	[field_55] [varchar](max) NULL,
	[field_56] [varchar](max) NULL,
	[field_57] [varchar](max) NULL,
	[field_58] [varchar](max) NULL,
	[field_59] [varchar](max) NULL,
	[field_60] [varchar](max) NULL,
	[field_61] [varchar](max) NULL,
	[field_62] [varchar](max) NULL,
	[field_63] [varchar](max) NULL,
	[field_64] [varchar](max) NULL,
	[field_65] [varchar](max) NULL,
	[field_66] [varchar](max) NULL,
	[field_67] [varchar](max) NULL,
	[field_68] [varchar](max) NULL,
	[field_69] [varchar](max) NULL,
	[field_70] [varchar](max) NULL,
	[field_71] [varchar](max) NULL,
	[field_72] [varchar](max) NULL,
	[field_73] [varchar](max) NULL,
	[field_74] [varchar](max) NULL,
	[field_75] [varchar](max) NULL,
	[field_76] [varchar](max) NULL,
	[field_77] [varchar](max) NULL,
	[field_78] [varchar](max) NULL,
	[field_79] [varchar](max) NULL,
	[field_80] [varchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Tasks]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tasks](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_batch] [bigint] NOT NULL,
	[hash_unique] [varchar](100) NULL,
	[type] [varchar](100) NOT NULL,
	[description] [varchar](255) NOT NULL,
	[timestamp_created] [datetime] NOT NULL,
	[timestamp_schedule] [datetime] NULL,
	[timestamp_start] [datetime] NULL,
	[timestamp_end] [datetime] NULL,
	[allow_auto_run] [bit] NOT NULL,
	[status] [varchar](255) NULL,
	[closed] [bit] NOT NULL,
 CONSTRAINT [PK_Tasks] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Tags]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tags](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[description] [varchar](255) NOT NULL,
	[keywords] [varchar](255) NULL,
	[category] [varchar](255) NULL,
	[date_created] [datetime] NULL,
	[is_active] [bit] NULL,
 CONSTRAINT [PK_Tags] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TagPermissions]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TagPermissions](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_tag] [bigint] NOT NULL,
	[type] [varchar](50) NOT NULL,
	[name] [varchar](255) NOT NULL,
	[allowed] [bit] NOT NULL,
 CONSTRAINT [PK_TagPermissions] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_TagPermissions] ON [dbo].[TagPermissions] 
(
	[id_tag] ASC,
	[type] ASC,
	[name] ASC,
	[allowed] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TagObjects]    Script Date: 10/19/2012 14:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TagObjects](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_tag] [bigint] NOT NULL,
	[type] [varchar](50) NOT NULL,
	[name] [varchar](255) NOT NULL,
	[date_start] [datetime] NULL,
	[date_end] [datetime] NULL,
	[is_active] [bit] NULL,
 CONSTRAINT [PK_Tag_objects] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_TagObjects] ON [dbo].[TagObjects] 
(
	[id_tag] ASC,
	[name] ASC,
	[type] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[StringToTable]    Script Date: 10/19/2012 14:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[StringToTable]
(
@inputString nvarchar(max),
@separator char (1)
)
RETURNS @ResultTable TABLE ( [String] nvarchar(max) )
AS
BEGIN

    DECLARE @stringToInsert nvarchar (max) 

    WHILE LEN(@inputString) > 0
    BEGIN
        SET @StringToInsert      = LEFT(
                                @inputString,
                                ISNULL(NULLIF(CHARINDEX(@separator, @inputString) - 1, -1),
                                LEN(@inputString)
                                )
                                )
        SET @InputString = SUBSTRING(@InputString,

                                     ISNULL
                                     (NULLIF
                                     (CHARINDEX(@separator, @InputString),
                                     0),
                                     LEN(@InputString)) + 1,
                                     LEN(@InputString))

        INSERT INTO @ResultTable
        (
        [String]
        )
        VALUES
        (
        @StringToInsert
        )

        END

    RETURN
END
GO
/****** Object:  View [dbo].[Staging_table_9]    Script Date: 10/19/2012 14:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_9]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_80]    Script Date: 10/19/2012 14:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_80]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65, field_66, field_67, field_68, field_69,
	field_70, field_71, field_72, field_73, field_74, field_75, field_76, field_77, field_78, field_79,
	field_80
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_8]    Script Date: 10/19/2012 14:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_8]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_79]    Script Date: 10/19/2012 14:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_79]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65, field_66, field_67, field_68, field_69,
	field_70, field_71, field_72, field_73, field_74, field_75, field_76, field_77, field_78, field_79
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_78]    Script Date: 10/19/2012 14:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_78]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65, field_66, field_67, field_68, field_69,
	field_70, field_71, field_72, field_73, field_74, field_75, field_76, field_77, field_78
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_77]    Script Date: 10/19/2012 14:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_77]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65, field_66, field_67, field_68, field_69,
	field_70, field_71, field_72, field_73, field_74, field_75, field_76, field_77
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_76]    Script Date: 10/19/2012 14:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_76]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65, field_66, field_67, field_68, field_69,
	field_70, field_71, field_72, field_73, field_74, field_75, field_76
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_75]    Script Date: 10/19/2012 14:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_75]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65, field_66, field_67, field_68, field_69,
	field_70, field_71, field_72, field_73, field_74, field_75
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_74]    Script Date: 10/19/2012 14:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_74]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65, field_66, field_67, field_68, field_69,
	field_70, field_71, field_72, field_73, field_74
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_73]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_73]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65, field_66, field_67, field_68, field_69,
	field_70, field_71, field_72, field_73
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_72]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_72]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65, field_66, field_67, field_68, field_69,
	field_70, field_71, field_72
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_71]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_71]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65, field_66, field_67, field_68, field_69,
	field_70, field_71
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_70]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_70]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65, field_66, field_67, field_68, field_69,
	field_70
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_7]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_7]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_69]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_69]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65, field_66, field_67, field_68, field_69
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_68]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_68]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65, field_66, field_67, field_68
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_67]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_67]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65, field_66, field_67
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_66]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_66]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65, field_66
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_65]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_65]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64, field_65
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_64]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_64]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63, field_64
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_63]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_63]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62, field_63
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_62]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_62]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61, field_62
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_61]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_61]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60, field_61
FROM Staging_table
GO
/****** Object:  View [dbo].[Staging_table_60]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_60]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59,
	field_60
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_6]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_6]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_59]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_59]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58, field_59
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_58]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_58]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57, field_58
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_57]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_57]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56, field_57
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_56]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_56]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55, field_56
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_55]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_55]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54, field_55
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_54]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_54]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53, field_54
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_53]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_53]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52, field_53
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_52]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_52]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51, field_52
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_51]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_51]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50, field_51
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_50]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_50]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49,
	field_50
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_5]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_5]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_49]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_49]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48, field_49
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_48]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_48]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47, field_48
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_47]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_47]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46, field_47
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_46]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_46]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45, field_46
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_45]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_45]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44, field_45
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_44]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_44]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43, field_44
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_43]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_43]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42, field_43
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_42]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_42]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41, field_42
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_41]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_41]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40, field_41
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_40]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_40]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39,
	field_40
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_4]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_4]
AS
SELECT     field_0, field_1, field_2, field_3, field_4
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_39]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_39]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38, field_39
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_38]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_38]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37, field_38
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_37]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_37]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36, field_37
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_36]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_36]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35, field_36
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_35]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_35]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34, field_35
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_34]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_34]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33, field_34
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_33]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_33]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32, field_33
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_32]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_32]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31, field_32
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_31]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_31]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30, field_31
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_30]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_30]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29,
	field_30
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_3]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_3]
AS
SELECT     field_0, field_1, field_2, field_3
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_29]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_29]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_28]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_28]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_27]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_27]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_26]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_26]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25, field_26
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_25]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_25]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24, field_25
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_24]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_24]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23, field_24
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_23]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_23]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22, field_23
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_22]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_22]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21, field_22
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_21]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_21]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20, field_21
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_20]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_20]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19,
	field_20
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_2]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_2]
AS
SELECT     field_0, field_1, field_2
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_19]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_19]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_18]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_18]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_17]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_17]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_16]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_16]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15, field_16
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_15]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_15]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14, field_15
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_14]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_14]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13, field_14
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_13]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_13]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12, field_13
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_12]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_12]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11, field_12
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_11]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_11]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10, field_11
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_10]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_10]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9,
	field_10
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_1]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_1]
AS
SELECT     field_0, field_1
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_0]    Script Date: 10/19/2012 14:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_0]
AS
SELECT     field_0
FROM         dbo.Staging_table
GO
/****** Object:  StoredProcedure [dbo].[spTask_update]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTask_update]
	@id_task bigint,
	@description varchar(255),
	@allow_auto_run bit,
	@timestamp_schedule datetime
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_task > 0 AND LEN(@description) > 0 AND LEN(@allow_auto_run) > 0 BEGIN
		UPDATE Tasks
		SET description = @description,
		allow_auto_run = @allow_auto_run
		WHERE id = @id_task
		
		IF LEN(@timestamp_schedule) > 0 BEGIN
			UPDATE Tasks 
			SET timestamp_schedule = @timestamp_schedule
			WHERE id = @id_task
		END
	END

	SELECT @id_task AS 'id_task'
END
GO
/****** Object:  StoredProcedure [dbo].[spTask_start]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTask_start]
	@id_task bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_task > 0 BEGIN
		UPDATE Tasks
		SET timestamp_start = GETDATE()
		WHERE id = @id_task
	END

	SELECT @id_task AS 'id_task'
END
GO
/****** Object:  StoredProcedure [dbo].[spTask_jobs_get]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTask_jobs_get]
	@id_task bigint,
	@closed bit
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_task > 0 BEGIN
		SELECT j.id,
		j.umra_project,
		j.type,
		j.timestamp_created,
		j.timestamp_start,
		j.timestamp_end,
		j.status,
		j.closed
		FROM Jobs j
		WHERE j.id_task = @id_task
		AND j.closed = @closed
		ORDER BY j.timestamp_created
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTask_hash_unique]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTask_hash_unique]
	@id_task bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_task > 0 BEGIN
		DECLARE @hash_unique varchar(255)
		
		SET @hash_unique = (SELECT SUM((HASHBYTES( 'MD5', 
		t.description + 
		t.type +
		j.type +
		j.umra_project + 
		jv.variable_name +
		jv.variable_value)*1) & 0xFFFFF) as 'hash'
		FROM Tasks t
		INNER JOIN Jobs j ON j.id_task = t.id
		INNER JOIN JobVariables jv ON jv.id_job = j.id
		WHERE t.id = @id_task
		GROUP BY t.id)
	
		UPDATE Tasks
		SET hash_unique = @hash_unique
		WHERE id = @id_task
		
		DECLARE @id_task_duplicate bigint
		SET @id_task_duplicate = (SELECT id FROM Tasks 
		WHERE hash_unique = @hash_unique
		AND NOT id = @id_task
		AND closed = 0)
		
		IF @id_task_duplicate > 0 BEGIN
			DELETE FROM Tasks WHERE id = @id_task
			
			DECLARE @id_jobs_duplicate TABLE (id bigint)
			INSERT INTO @id_jobs_duplicate
			SELECT id FROM Jobs WHERE id_task = @id_task
			
			DELETE FROM JobVariables WHERE id_job IN (SELECT id FROM @id_jobs_duplicate)
			DELETE FROM Jobs WHERE id IN (SELECT id FROM @id_jobs_duplicate)
		END
	END
	
	SELECT @id_task AS 'id_task'
END
GO
/****** Object:  StoredProcedure [dbo].[spTask_get]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTask_get]
	@id_task bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_task > 0 BEGIN
		SELECT t.id,
		t.type,
		t.description,
		t.timestamp_created,
		t.timestamp_schedule,
		t.timestamp_start,
		t.timestamp_end,
		t.allow_auto_run,
		t.status,
		t.closed,
		(SELECT COUNT(j.id) FROM Jobs j
		WHERE j.closed = 0 
		AND j.id_task = t.id) AS 'jobs-open',
		(SELECT COUNT(j.id) FROM Jobs j
		WHERE j.closed = 1
		AND j.id_task = t.id) AS 'jobs-closed'
		FROM Tasks t
		WHERE t.id = @id_task
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTask_finish]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTask_finish]
	@id_task bigint,
	@status varchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @task_jobs_open int
	SET @task_jobs_open = 
	(SELECT COUNT(j.id) 
	FROM Jobs j
	INNER JOIN Tasks t ON j.id_task = t.id
	WHERE t.id = @id_task
	AND j.closed = 0)
	
	IF @id_task > 0 AND @task_jobs_open = 0 BEGIN
		UPDATE Tasks
		SET timestamp_end = GETDATE(),
		status = @status,
		closed = 1
		WHERE id = @id_task
	END

	SELECT @id_task AS 'id_task'
END
GO
/****** Object:  StoredProcedure [dbo].[spTask_close]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTask_close]
	@id_task bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_task > 0 BEGIN
		DECLARE @id_jobs TABLE (id bigint)
		
		INSERT INTO @id_jobs
		SELECT Jobs.id FROM Jobs
		WHERE Jobs.id_task = @id_task
	
		UPDATE Jobs
		SET closed = 1,
		timestamp_end = GETDATE()
		WHERE id IN (SELECT id FROM @id_jobs)
		
		UPDATE Tasks
		SET closed = 1,
		timestamp_end = GETDATE()
		WHERE id = @id_task
	END

	SELECT @id_task AS 'id_task'
END
GO
/****** Object:  StoredProcedure [dbo].[spTask_add]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTask_add]
	@id_batch bigint,
	@type varchar(100),
	@description varchar(255),
	@allow_auto_run bit,
	@timestamp_schedule datetime
AS
BEGIN
	SET NOCOUNT ON;
	
	IF LEN(@id_batch) > 0 AND LEN(@description) > 0 AND LEN(@type) > 0 BEGIN
		INSERT INTO Tasks (id_batch, type, description, allow_auto_run) 
		VALUES (@id_batch, @type, @description, @allow_auto_run)
		SELECT CONVERT(varchar, SCOPE_IDENTITY()) AS id_task
		
		IF NOT @timestamp_schedule IS NULL BEGIN
			DECLARE @id_task bigint
			SET @id_task = (SELECT CONVERT(varchar, SCOPE_IDENTITY()))
			UPDATE Tasks 
			SET timestamp_schedule = @timestamp_schedule
			WHERE id = @id_task
		END
	END
	ELSE BEGIN
		SELECT '0' AS 'id_task'
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_objectattribute_add]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_objectattribute_add]
	@id_object bigint,
	@attribute_name varchar(255),
	@attribute_value varchar(500),
	@column_index int,
	@column_index_key int,
	@column_index_show int
AS
BEGIN
	DECLARE @max_length_attribute_value int
	SET @max_length_attribute_value = 500

	DECLARE @is_key bit
	DECLARE @is_show bit
	
	IF @id_object > 0 AND LEN(@attribute_name) > 0 AND (LEN(@attribute_value) < @max_length_attribute_value OR @attribute_value IS NULL) BEGIN	
		SET @is_key = 0
		IF @column_index = @column_index_key BEGIN
			SET @is_key = 1
		END
		
		SET @is_show = 0
		IF @column_index = @column_index_show BEGIN
			SET @is_show = 1
		END
		
		INSERT INTO ObjectAttributes (id_object, attribute_name, attribute_value, is_key, is_show)
		VALUES(@id_object, @attribute_name, @attribute_value, @is_key, @is_show)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_match_attributes]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_match_attributes]
	@initials varchar(255),
	@firstname varchar(255),
	@middlename_birth varchar(255),
	@middlename_partner varchar(255),
	@lastname_birth varchar(255),
	@lastname_partner varchar(255),
	@attribute_name varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot bigint
	SET @id_snapshot = (SELECT MAX(id) FROM Snapshots)

	DECLARE @firstname_start_end varchar(255)
	DECLARE @firstname_start_3 varchar(3)
	DECLARE @firstname_end_3 varchar(3)
	DECLARE @lastname_birth_start_end varchar(255)
	DECLARE @lastname_birth_start_4 varchar(4)
	DECLARE @lastname_birth_end_4 varchar(4)
	DECLARE @lastname_partner_start_end varchar(255)
	DECLARE @lastname_partner_start_4 varchar(4)
	DECLARE @lastname_partner_end_4 varchar(4)
	DECLARE @replace_chars varchar(255)
	DECLARE @replace_char varchar(1)
	DECLARE @replace_char_target varchar(255)
	DECLARE @match_rank TABLE (result varchar(255), score bigint) 

	SET @replace_chars = '###########################'
	SET @replace_char = '#'
	SET @replace_char_target = '[^0-9''"&$@/\<>!*,.()-_ ]'
	SET @replace_char_target = '[a-z]'

	SET @firstname_start_end = CASE	WHEN LEN(@firstname) < 3 THEN @firstname
		ELSE LEFT(@firstname, 2) + LEFT(@replace_chars, LEN(@firstname) - 3) + RIGHT(@firstname, 1)	END
	SET @lastname_birth_start_end = CASE WHEN LEN(@lastname_birth) < 3 THEN @lastname_birth
		ELSE LEFT(@lastname_birth, 2) + LEFT(@replace_chars, LEN(@lastname_birth) - 3) + RIGHT(@lastname_birth, 1) END
	SET @lastname_partner_start_end = CASE WHEN LEN(@lastname_partner) < 3 THEN @lastname_partner
		ELSE LEFT(@lastname_partner, 2) + LEFT(@replace_chars, LEN(@lastname_partner) - 3) + RIGHT(@lastname_partner, 1) END

	SET @firstname_start_end = REPLACE(@firstname_start_end, @replace_char, @replace_char_target)
	SET @lastname_birth_start_end = REPLACE(@lastname_birth_start_end, @replace_char, @replace_char_target)
	SET @lastname_partner_start_end = REPLACE(@lastname_partner_start_end, @replace_char, @replace_char_target)

	INSERT INTO @match_rank
	SELECT DISTINCT oa_key.attribute_value, 100 
	FROM Objects o
	INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa.attribute_name = @attribute_name
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa_key.is_key = 1
	WHERE ((oa.attribute_value LIKE '%[^a-z]' + @initials + '[^a-z]%')
	OR (oa.attribute_value LIKE @initials + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @initials))	
	AND ((oa.attribute_value LIKE '%[^a-z]' + @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @firstname))
	AND ((oa.attribute_value LIKE '%[^a-z]' + @middlename_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE @middlename_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @middlename_birth))	
	AND ((oa.attribute_value LIKE '%[^a-z]' + @lastname_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE @lastname_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @lastname_birth))
	AND LEN(@lastname_birth) > 1
	AND LEN(@middlename_birth) > 1
	AND LEN(@firstname) > 1
	AND LEN(@initials) > 1

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT result, SUM(score) AS 'rank' FROM @match_rank GROUP BY result ORDER BY SUM(score) DESC
		RETURN	
	END
	
	INSERT INTO @match_rank
	SELECT DISTINCT oa_key.attribute_value, 100 FROM Objects o
	INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa.attribute_name = @attribute_name
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa_key.is_key = 1
	WHERE ((oa.attribute_value LIKE '%[^a-z]' + @initials + '[^a-z]%')
	OR (oa.attribute_value LIKE @initials + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @initials))	
	AND ((oa.attribute_value LIKE '%[^a-z]' + @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @firstname))
	AND ((oa.attribute_value LIKE '%[^a-z]' + @middlename_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE @middlename_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @middlename_partner))	
	AND ((oa.attribute_value LIKE '%[^a-z]' + @lastname_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE @lastname_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @lastname_partner))
	AND LEN(@lastname_partner) > 1
	AND LEN(@middlename_partner) > 1
	AND LEN(@firstname) > 1
	AND LEN(@initials) > 1

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT result, SUM(score) AS 'rank' FROM @match_rank GROUP BY result ORDER BY SUM(score) DESC
		RETURN	
	END

	INSERT INTO @match_rank
	SELECT DISTINCT oa_key.attribute_value, 95 FROM Objects o
	INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa.attribute_name = @attribute_name
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa_key.is_key = 1
	WHERE ((oa.attribute_value LIKE '%[^a-z]' + @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @firstname))
	AND ((oa.attribute_value LIKE '%[^a-z]' + @middlename_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE @middlename_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @middlename_birth))	
	AND ((oa.attribute_value LIKE '%[^a-z]' + @lastname_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE @lastname_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @lastname_birth))
	AND LEN(@lastname_birth) > 1
	AND LEN(@middlename_birth) > 1
	AND LEN(@firstname) > 1

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT result, SUM(score) AS 'rank' FROM @match_rank GROUP BY result ORDER BY SUM(score) DESC
		RETURN	
	END	
	
	INSERT INTO @match_rank
	SELECT DISTINCT oa_key.attribute_value, 95 FROM Objects o
	INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa.attribute_name = @attribute_name
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa_key.is_key = 1
	WHERE ((oa.attribute_value LIKE '%[^a-z]' + @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @firstname))
	AND ((oa.attribute_value LIKE '%[^a-z]' + @middlename_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE @middlename_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @middlename_partner))	
	AND ((oa.attribute_value LIKE '%[^a-z]' + @lastname_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE @lastname_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @lastname_partner))
	AND LEN(@lastname_partner) > 1
	AND LEN(@middlename_partner) > 1
	AND LEN(@firstname) > 1

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT result, SUM(score) AS 'rank' FROM @match_rank GROUP BY result ORDER BY SUM(score) DESC
		RETURN	
	END		

	INSERT INTO @match_rank
	SELECT DISTINCT oa_key.attribute_value, 90 FROM Objects o
	INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa.attribute_name = @attribute_name
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa_key.is_key = 1
	WHERE ((oa.attribute_value LIKE '%[^a-z]' + @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @firstname))
	AND ((oa.attribute_value LIKE '%[^a-z]' + @lastname_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE @lastname_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @lastname_birth))
	AND LEN(@lastname_birth) > 1
	AND LEN(@firstname) > 1

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT result, SUM(score) AS 'rank' FROM @match_rank GROUP BY result ORDER BY SUM(score) DESC
		RETURN	
	END

	INSERT INTO @match_rank
	SELECT DISTINCT oa_key.attribute_value, 90 FROM Objects o
	INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa.attribute_name = @attribute_name
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa_key.is_key = 1
	WHERE ((oa.attribute_value LIKE '%[^a-z]' + @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @firstname))
	AND ((oa.attribute_value LIKE '%[^a-z]' + @lastname_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE @lastname_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @lastname_partner))
	AND LEN(@lastname_partner) > 1
	AND LEN(@firstname) > 1

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT result, SUM(score) AS 'rank' FROM @match_rank GROUP BY result ORDER BY SUM(score) DESC
		RETURN	
	END

	INSERT INTO @match_rank
	SELECT DISTINCT oa_key.attribute_value, 85 FROM Objects o
	INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa.attribute_name = @attribute_name
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa_key.is_key = 1
	WHERE ((oa.attribute_value LIKE '%[^a-z]' + @firstname_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE @firstname_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @firstname_start_end))
	AND ((oa.attribute_value LIKE '%[^a-z]' + @middlename_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE @middlename_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @middlename_birth))		
	AND ((oa.attribute_value LIKE '%[^a-z]' + @lastname_birth_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE @lastname_birth_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @lastname_birth_start_end))
	AND LEN(@lastname_birth_start_end) > 1
	AND LEN(@middlename_birth) > 1
	AND LEN(@firstname_start_end) > 1

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT result, SUM(score) AS 'rank' FROM @match_rank GROUP BY result ORDER BY SUM(score) DESC
		RETURN	
	END

	INSERT INTO @match_rank
	SELECT DISTINCT oa_key.attribute_value, 85 FROM Objects o
	INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa.attribute_name = @attribute_name
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa_key.is_key = 1
	WHERE ((oa.attribute_value LIKE '%[^a-z]' + @firstname_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE @firstname_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @firstname_start_end))
	AND ((oa.attribute_value LIKE '%[^a-z]' + @middlename_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE @middlename_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @middlename_partner))		
	AND ((oa.attribute_value LIKE '%[^a-z]' + @lastname_partner_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE @lastname_partner_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @lastname_partner_start_end))
	AND LEN(@lastname_partner_start_end) > 1
	AND LEN(@middlename_partner) > 1
	AND LEN(@firstname_start_end) > 1

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT result, SUM(score) AS 'rank' FROM @match_rank GROUP BY result ORDER BY SUM(score) DESC
		RETURN	
	END

	INSERT INTO @match_rank
	SELECT DISTINCT oa_key.attribute_value, 80 FROM Objects o
	INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa.attribute_name = @attribute_name
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa_key.is_key = 1
	WHERE ((oa.attribute_value LIKE '%[^a-z]' + @firstname_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE @firstname_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @firstname_start_end))		
	AND ((oa.attribute_value LIKE '%[^a-z]' + @lastname_birth_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE @lastname_birth_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @lastname_birth_start_end))
	AND LEN(@lastname_birth_start_end) > 1
	AND LEN(@firstname_start_end) > 1

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT result, SUM(score) AS 'rank' FROM @match_rank GROUP BY result ORDER BY SUM(score) DESC
		RETURN	
	END

	INSERT INTO @match_rank
	SELECT DISTINCT oa_key.attribute_value, 80 FROM Objects o
	INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa.attribute_name = @attribute_name
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o.id
		AND o.id_snapshot = @id_snapshot
		AND oa_key.is_key = 1
	WHERE ((oa.attribute_value LIKE '%[^a-z]' + @firstname_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE @firstname_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @firstname_start_end))		
	AND ((oa.attribute_value LIKE '%[^a-z]' + @lastname_partner_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE @lastname_partner_start_end + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @lastname_partner_start_end))
	AND LEN(@lastname_partner_start_end) > 1
	AND LEN(@firstname_start_end) > 1

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT result, SUM(score) AS 'rank' FROM @match_rank GROUP BY result ORDER BY SUM(score) DESC
		RETURN	
	END

	SELECT result, SUM(score) AS 'rank' FROM @match_rank GROUP BY result ORDER BY SUM(score) DESC

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get_types]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get_types]
	@id_snapshot bigint
AS
BEGIN
	SET NOCOUNT ON;

	IF LEN(@id_snapshot) > 0 BEGIN
		SELECT DISTINCT
		o.type,
		o.type
		FROM Objects o
		WHERE o.id_snapshot = @id_snapshot
		ORDER BY o.type
	END

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get_sources]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get_sources]
	@id_snapshot bigint
AS
BEGIN
	SET NOCOUNT ON;

	IF LEN(@id_snapshot) > 0 BEGIN
		SELECT DISTINCT
		o.source,
		o.source
		FROM Objects o
		WHERE o.id_snapshot = @id_snapshot
		ORDER BY o.source
	END

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get_relationships]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get_relationships]
	@is_key bigint = 1,
	@id_snapshot bigint = 0,
	@type_relationship varchar(50) = 'member'
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_snapshot = 0 BEGIN SET @id_snapshot = (SELECT MAX(id) FROM Snapshots) END
	
	IF @is_key = 1 BEGIN
		SELECT
		oa_parent.attribute_value,
		oa_child.attribute_value
		FROM Relationships r
		INNER JOIN Objects o_parent ON o_parent.id = r.id_object_parent
			AND o_parent.id_snapshot = @id_snapshot
			AND r.type = @type_relationship
		INNER JOIN ObjectAttributes oa_parent ON oa_parent.id_object = o_parent.id
			AND oa_parent.is_key = 1
			AND o_parent.id_snapshot = @id_snapshot
		INNER JOIN Objects o_child ON o_child.id = r.id_object_child
			AND o_child.id_snapshot = @id_snapshot
			AND r.type = @type_relationship
		INNER JOIN ObjectAttributes oa_child ON oa_child.id_object = o_child.id
			AND oa_child.is_key = 1
			AND o_child.id_snapshot = @id_snapshot
		ORDER BY oa_parent.attribute_value, oa_child.attribute_value
	END
	ELSE BEGIN
		SELECT
		oa_parent.attribute_value,
		oa_child.attribute_value
		FROM Relationships r
		INNER JOIN Objects o_parent ON o_parent.id = r.id_object_parent
			AND o_parent.id_snapshot = @id_snapshot
			AND r.type = @type_relationship
		INNER JOIN ObjectAttributes oa_parent ON oa_parent.id_object = o_parent.id
			AND oa_parent.is_show = 1
			AND o_parent.id_snapshot = @id_snapshot
		INNER JOIN Objects o_child ON o_child.id = r.id_object_child
			AND o_child.id_snapshot = @id_snapshot
			AND r.type = @type_relationship
		INNER JOIN ObjectAttributes oa_child ON oa_child.id_object = o_child.id
			AND oa_child.is_show = 1
			AND o_child.id_snapshot = @id_snapshot
		ORDER BY oa_parent.attribute_value, oa_child.attribute_value
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get_objects_type]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get_objects_type]
	@id_snapshot bigint,
	@type varchar(255)
AS
BEGIN
	SET NOCOUNT ON;

	IF LEN(@type) > 0 BEGIN
		SELECT DISTINCT TOP 1000
		o.id,
		oa.attribute_value,
		o.source,
		o.type
		FROM Objects o
		INNER JOIN ObjectAttributes oa ON oa.id_object = o.id 
			AND oa.is_show = 1
			AND o.id_snapshot = @id_snapshot
			AND o.type = @type
		ORDER BY oa.attribute_value
	END

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get_objects_source]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get_objects_source]
	@id_snapshot bigint,
	@source varchar(255)
AS
BEGIN
	SET NOCOUNT ON;

	IF LEN(@source) > 0 BEGIN
		SELECT DISTINCT TOP 1000
		o.id,
		oa.attribute_value,
		o.source,
		o.type
		FROM Objects o
		INNER JOIN ObjectAttributes oa ON oa.id_object = o.id 
			AND oa.is_show = 1
			AND o.id_snapshot = @id_snapshot
			AND o.source = @source
		ORDER BY oa.attribute_value
	END

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get_objects_attributes_columns]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get_objects_attributes_columns]
	@id_snapshot bigint,
	@source varchar(255),
	@type varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @cols NVARCHAR(2000)
	
	SELECT @cols = STUFF((
	SELECT DISTINCT '],[' + oa.attribute_name
	FROM ObjectAttributes oa
	INNER JOIN Objects o ON o.id = oa.id_object
	WHERE o.id_snapshot = @id_snapshot
	AND o.type = @type
	ORDER BY '],[' + oa.attribute_name
	FOR XML PATH('')
	), 1, 2, '') + ']'
	
	DECLARE @query NVARCHAR(4000)
	
	IF NOT @source IS NULL BEGIN
		SET @query = N'SELECT '+
		@cols +'
		FROM
		(SELECT o.id, oa.attribute_name, oa.attribute_value
		FROM ObjectAttributes oa
		INNER JOIN Objects o ON o.id = oa.id_object
			AND o.id_snapshot = ' + CONVERT(varchar, @id_snapshot) + '
		WHERE o.source = ''' + @source + '''
		AND o.type = ''' + @type + ''') p
		PIVOT
		(
		MAX([attribute_value])
		FOR attribute_name IN
		( '+
		@cols +' )
		) AS pvt
		ORDER BY id'
	END
	ELSE BEGIN
		SET @query = N'SELECT '+
		@cols +'
		FROM
		(SELECT o.id, oa.attribute_name, oa.attribute_value
		FROM ObjectAttributes oa
		INNER JOIN Objects o ON o.id = oa.id_object
			AND o.id_snapshot = ' + CONVERT(varchar, @id_snapshot) + '
		WHERE o.type = ''' + @type + ''') p
		PIVOT
		(
		MAX([attribute_value])
		FOR attribute_name IN
		( '+
		@cols +' )
		) AS pvt
		ORDER BY id'	
	END

	EXECUTE(@query)

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get_objects]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get_objects]
	@id_snapshot bigint,
	@wildcard varchar(100)
AS
BEGIN
	SET NOCOUNT ON;

	IF LEN(@wildcard) > 0 BEGIN
		SELECT DISTINCT TOP 1000
		o.id,
		oa_show.attribute_value,
		o.source,
		o.type
		FROM Objects o
		INNER JOIN ObjectAttributes oa_show ON oa_show.id_object = o.id 
			AND oa_show.is_show = 1
			AND o.id_snapshot = @id_snapshot
		INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
			AND o.id_snapshot = @id_snapshot
		WHERE oa.attribute_value LIKE '%' + @wildcard + '%'
		ORDER BY oa_show.attribute_value
	END
	ELSE BEGIN
		SELECT DISTINCT TOP 1000
		o.id,
		oa_show.attribute_value,
		o.source,
		o.type
		FROM Objects o
		INNER JOIN ObjectAttributes oa_show ON oa_show.id_object = o.id 
			AND oa_show.is_show = 1
			AND o.id_snapshot = @id_snapshot
		INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
			AND o.id_snapshot = @id_snapshot
		ORDER BY oa_show.attribute_value	
	END

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get_object_relationships_parent]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get_object_relationships_parent]
	@id_object bigint
AS
BEGIN
	SET NOCOUNT ON;

	WITH relationships_parent (
		id,
		type,
		id_object_parent, 
		id_object_child, 
		level_relation) AS
	(
		SELECT
		r.id,
		type,
		r.id_object_parent,
		r.id_object_child,
		0 as level_relation
		FROM Relationships r
		WHERE id_object_child = @id_object

		UNION ALL

		SELECT
		r_parent.id,
		r_parent.type,
		r_parent.id_object_parent,
		r_parent.id_object_child,
		pr.level_relation + 1 AS level_relation
		FROM Relationships r_parent
		INNER JOIN relationships_parent pr ON r_parent.id_object_child = pr.id_object_parent
	)

	SELECT DISTINCT
	CONVERT(varchar, r_p.id) + '-' + CONVERT(varchar, r_p.level_relation) as 'id',
	CONVERT(varchar, r_p.id_object_parent) as 'id_object_parent',
	o_parent.type,
	oa_parent_show.attribute_value,	
	r_p.type,
	CONVERT(varchar, r_p.id_object_child) as 'id_object_child',
	o_child.type,
	oa_child_show.attribute_value,
	r_p.level_relation	
	FROM relationships_parent r_p
	INNER JOIN Objects o_parent ON o_parent.id = r_p.id_object_parent
	INNER JOIN ObjectAttributes oa_parent_show ON oa_parent_show.id_object = o_parent.id	
	INNER JOIN Objects o_child ON o_child.id = r_p.id_object_child
	INNER JOIN ObjectAttributes oa_child_show ON oa_child_show.id_object = o_child.id
	WHERE oa_child_show.is_show = 1
	AND oa_parent_show.is_show = 1	
	ORDER BY level_relation, oa_parent_show.attribute_value, oa_child_show.attribute_value

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get_object_relationships_child]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get_object_relationships_child]
	@id_object bigint
AS
BEGIN
	SET NOCOUNT ON;

	WITH relationships_child (
		id,
		type,
		id_object_child, 
		id_object_parent, 
		level_relation) AS
	(
		SELECT
		r.id,
		r.type,
		r.id_object_child,
		r.id_object_parent,
		0 as level_relation
		FROM Relationships r
		WHERE id_object_parent = @id_object

		UNION ALL

		SELECT
		r_child.id,	
		r_child.type,
		r_child.id_object_child,
		r_child.id_object_parent,
		pr.level_relation + 1 AS level_relation
		FROM Relationships r_child
		INNER JOIN relationships_child pr ON r_child.id_object_parent = pr.id_object_child
	)

	SELECT DISTINCT
	CONVERT(varchar, r_c.id) + '-' + CONVERT(varchar, r_c.level_relation) as 'id',
	CONVERT(varchar, r_c.id_object_child) as 'id_object_child',
	o_child.type,
	oa_child_show.attribute_value,
	r_c.type,
	CONVERT(varchar, r_c.id_object_parent) as 'id_object_parent',
	o_parent.type,
	oa_parent_show.attribute_value,
	r_c.level_relation
	FROM relationships_child r_c
	INNER JOIN Objects o_child ON o_child.id = r_c.id_object_child
	INNER JOIN ObjectAttributes oa_child_show ON oa_child_show.id_object = o_child.id
	INNER JOIN Objects o_parent ON o_parent.id = r_c.id_object_parent
	INNER JOIN ObjectAttributes oa_parent_show ON oa_parent_show.id_object = o_parent.id
	WHERE oa_child_show.is_show = 1
	AND oa_parent_show.is_show = 1
	ORDER BY level_relation, oa_child_show.attribute_value, oa_parent_show.attribute_value

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get_object_attributes]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get_object_attributes]
	@id_object bigint
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_object > 0 BEGIN
		SELECT DISTINCT
		oa.attribute_name,
		oa.attribute_value
		FROM ObjectAttributes oa
		INNER JOIN Objects o ON o.id = oa.id_object
		WHERE o.id = @id_object
		AND LEN(oa.attribute_value) > 0
		ORDER BY oa.attribute_name
	END
	ELSE BEGIN
		SELECT NULL, NULL
	END

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get_details_relationships]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get_details_relationships]
	@id_snapshot bigint
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT 
	o.source + '-' + r.type as 'id',
	o.source,
	r.type,
	COUNT(r.id) AS 'count'
	FROM Snapshots s
	INNER JOIN Objects o ON o.id_snapshot = s.id
		AND o.id_snapshot = @id_snapshot
	INNER JOIN Relationships r ON r.id_object_parent = o.id
		AND o.id_snapshot = @id_snapshot
	GROUP BY o.source, r.type
	ORDER BY o.source, r.type

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get_details_objects]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get_details_objects]
	@id_snapshot bigint
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT 
	o.source + '-' + o.type as 'id',
	o.source,
	o.type,
	COUNT(o.id) AS 'count'
	FROM Snapshots s
	INNER JOIN Objects o ON o.id_snapshot = s.id
		AND o.id_snapshot = @id_snapshot
	GROUP BY o.source, o.type
	ORDER BY o.source

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get_delta_relationships]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get_delta_relationships]
	@id_snapshot bigint,
	@id_snapshot_delta bigint
AS
BEGIN
	SET NOCOUNT ON;

	IF LEN(@id_snapshot) > 0 AND LEN(@id_snapshot_delta) > 0 BEGIN
		SELECT
		CONVERT(varchar, r.id) as 'id',
		CONVERT(varchar, o_parent.id) as 'id_parent',
		CONVERT(varchar, o_child.id) as 'id_child',
		oa_parent_key.attribute_value,
		o_parent.source,
		o_parent.type,
		r.type,
		oa_child_key.attribute_value,
		o_child.source,
		o_child.type
		FROM Relationships r
		INNER JOIN Objects o_child ON r.id_object_child = o_child.id 
			AND o_child.id_snapshot = @id_snapshot
		INNER JOIN ObjectAttributes oa_child_key ON oa_child_key.id_object = o_child.id 
			AND oa_child_key.is_key = 1
		INNER JOIN Objects o_parent ON r.id_object_parent = o_parent.id 
			AND o_parent.id_snapshot = @id_snapshot
		INNER JOIN ObjectAttributes oa_parent_key ON oa_parent_key.id_object = o_parent.id 
			AND oa_parent_key.is_key = 1

		FULL JOIN (SELECT r.type,
			oa_parent_key.attribute_value as 'attribute_value_parent',
			o_parent.source as 'source_parent',
			o_parent.type 'type_parent',
			oa_child_key.attribute_value as 'attribute_value_child',
			o_child.source as 'source_child',
			o_child.type as 'type_child'
			FROM Relationships r
			INNER JOIN Objects o_child ON r.id_object_child = o_child.id 
				AND o_child.id_snapshot = @id_snapshot_delta
			INNER JOIN ObjectAttributes oa_child_key ON oa_child_key.id_object = o_child.id 
				AND oa_child_key.is_key = 1
			INNER JOIN Objects o_parent ON r.id_object_parent = o_parent.id 
				AND o_parent.id_snapshot = @id_snapshot_delta
			INNER JOIN ObjectAttributes oa_parent_key ON oa_parent_key.id_object = o_parent.id 
				AND oa_parent_key.is_key = 1) left_delta ON left_delta.attribute_value_parent = oa_parent_key.attribute_value
					AND left_delta.source_parent = o_parent.source
					AND left_delta.source_child = o_child.source
					AND left_delta.type_parent = o_parent.type
					AND left_delta.type_child = o_child.type
					AND left_delta.attribute_value_child = oa_child_key.attribute_value
					
		WHERE left_delta.attribute_value_parent IS NULL
		AND left_delta.attribute_value_child IS NULL
		
		ORDER BY oa_parent_key.attribute_value, oa_child_key.attribute_value
	END

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get_delta_objects]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get_delta_objects]
	@id_snapshot bigint,
	@id_snapshot_delta bigint
AS
BEGIN
	SET NOCOUNT ON;

	IF LEN(@id_snapshot) > 0 AND LEN(@id_snapshot_delta) > 0 BEGIN
		SELECT
		CONVERT(varchar, o.id) as 'id',
		oa_key.attribute_value,		
		o.source,
		o.type
		FROM Objects o
		INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o.id 
			AND o.id_snapshot = @id_snapshot
			AND oa_key.is_key = 1
		FULL JOIN (SELECT oa.attribute_value, 
			o.source, 
			o.type 
			FROM Objects o
			INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
			AND o.id_snapshot = @id_snapshot_delta
			AND is_key = 1) left_delta ON left_delta.attribute_value = oa_key.attribute_value
				AND left_delta.source = o.source
				AND left_delta.type = o.type
		WHERE left_delta.attribute_value IS NULL
		ORDER BY oa_key.attribute_value
	END

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get_delta_objectattributes]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get_delta_objectattributes]
	@id_snapshot bigint,
	@id_snapshot_delta bigint
AS
BEGIN
	SET NOCOUNT ON;

	IF LEN(@id_snapshot) > 0 AND LEN(@id_snapshot_delta) > 0 BEGIN
		SELECT DISTINCT
		CONVERT(varchar, o.id) + '-' + CONVERT(varchar, oa.id) as 'id',
		CONVERT(varchar, o.id) as 'id_object',
		oa_key.attribute_value,
		o.source,
		o.type,
		oa.attribute_name,
		oa.attribute_value,
		left_delta.attribute_name as 'delta_name',
		left_delta.attribute_value as 'delta_value'
		FROM Objects o
		INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
			AND NOT oa.attribute_value IS NULL
			AND o.id_snapshot = @id_snapshot
		INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o.id 
			AND o.id_snapshot = @id_snapshot
			AND oa_key.is_key = 1

		INNER JOIN (SELECT oa_key.attribute_value as 'attribute_value_key', 
			o.source,
			o.type,
			oa.attribute_name, 
			oa.attribute_value 
			FROM Objects o
			INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
				AND NOT oa.attribute_value iS NULL
				AND o.id_snapshot = @id_snapshot_delta
			INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o.id
				AND o.id_snapshot = @id_snapshot_delta
				AND oa_key.is_key = 1) left_delta ON left_delta.attribute_value_key = oa_key.attribute_value
					AND left_delta.attribute_name = oa.attribute_name
					AND left_delta.source = o.source
					AND left_delta.type = o.type

		WHERE NOT left_delta.attribute_value = oa.attribute_value
		ORDER BY oa_key.attribute_value, oa.attribute_name

	END

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_finish]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_finish]
	@id_snapshot bigint,
	@status varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	ALTER INDEX ALL ON Objects
	REORGANIZE
	
	ALTER INDEX ALL ON ObjectAttributes
	REORGANIZE

	ALTER INDEX ALL ON Relationships
	REORGANIZE
	
	IF LEN(@id_snapshot) > 0 AND LEN(@status) > 0 BEGIN
		UPDATE Snapshots
		SET timestamp_end = GETDATE(),
		status = @status
		WHERE id = @id_snapshot
		
		SELECT @id_snapshot as 'id_snapshot'
	END
	ELSE BEGIN
		SELECT '' AS 'id_snapshot'
	END	

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_delete]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_delete]
	@id_snapshot bigint
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @obsoleteid_object TABLE (id bigint)

	INSERT INTO @obsoleteid_object
	SELECT id
	FROM Objects
	WHERE id_snapshot = @id_snapshot

	DELETE FROM ObjectAttributes
	WHERE id_object IN (SELECT id FROM @obsoleteid_object)

	DELETE FROM Relationships
	WHERE id_object_child IN (SELECT id FROM @obsoleteid_object)

	DELETE FROM Relationships
	WHERE id_object_parent IN (SELECT id FROM @obsoleteid_object)
	
	DELETE FROM Objects 
	WHERE id_snapshot = @id_snapshot	

	DELETE FROM Snapshots 
	WHERE id = @id_snapshot
	
	SELECT @id_snapshot
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_cleanup]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_cleanup]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @obsoleteid_snapshot TABLE (id bigint)
	DECLARE @obsoleteid_object TABLE (id bigint)

	INSERT INTO @obsoleteid_snapshot
	SELECT id
	FROM Snapshots
	WHERE NOT id IN (SELECT TOP 10 id FROM Snapshots ORDER BY timestamp_start DESC)
	ORDER BY timestamp_start DESC
	
	INSERT INTO @obsoleteid_snapshot
	SELECT s.id
	FROM Snapshots s
	WHERE s.id NOT IN (SELECT id_snapshot FROM Objects)

	INSERT INTO @obsoleteid_object
	SELECT id
	FROM Objects
	WHERE id_snapshot IN (SELECT id FROM @obsoleteid_snapshot)

	DELETE FROM ObjectAttributes
	WHERE id_object IN (SELECT id FROM @obsoleteid_object)

	DELETE FROM Relationships
	WHERE id_object_child IN (SELECT id FROM @obsoleteid_object)

	DELETE FROM Relationships
	WHERE id_object_parent IN (SELECT id FROM @obsoleteid_object)
	
	DELETE FROM Objects 
	WHERE id_snapshot IN (SELECT id FROM @obsoleteid_snapshot)	

	DELETE FROM Snapshots 
	WHERE id IN (SELECT id FROM @obsoleteid_snapshot)
	
	SELECT * FROM @obsoleteid_snapshot
END
GO
/****** Object:  StoredProcedure [dbo].[spNotifications_get]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNotifications_get]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT id,
	description,
	type
	FROM Notifications
END
GO
/****** Object:  StoredProcedure [dbo].[spNotification_save]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNotification_save]
	@description varchar(255),
	@type varchar(255),
	@mail_to varchar(255),
	@mail_cc varchar(255),
	@mail_bcc varchar(255),
	@mail_from varchar(255),
	@mail_subject varchar(MAX),
	@mail_body varchar(MAX),
	@id bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id > 0 BEGIN
		IF LEN(@description) > 0 BEGIN
			UPDATE Notifications
			SET description = @description
			WHERE id = @id
		END	
		IF LEN(@type) > 0 BEGIN
			UPDATE Notifications
			SET type = @type
			WHERE id = @id
		END
		IF LEN(@mail_to) > 0 BEGIN
			UPDATE Notifications
			SET mail_to = @mail_to
			WHERE id = @id		
		END
		IF LEN(@mail_cc) > 0 BEGIN
			UPDATE Notifications
			SET mail_cc = @mail_cc
			WHERE id = @id		
		END
		IF LEN(@mail_bcc) > 0 BEGIN
			UPDATE Notifications
			SET mail_bcc = @mail_bcc
			WHERE id = @id		
		END				
		IF LEN(@mail_from) > 0 BEGIN
			UPDATE Notifications
			SET mail_from = @mail_from
			WHERE id = @id		
		END
		IF LEN(@mail_subject) > 0 BEGIN
			UPDATE Notifications
			SET mail_subject = @mail_subject
			WHERE id = @id		
		END
		IF LEN(@mail_body) > 0 BEGIN
			UPDATE Notifications
			SET mail_body = @mail_body
			WHERE id = @id		
		END
				
		SELECT @id AS 'id_notification'
	END
	ELSE BEGIN
		INSERT INTO Notifications (description, type, mail_to, mail_cc, mail_bcc, mail_from, mail_subject, mail_body) 
		VALUES (@description, @type, @mail_to, @mail_cc, @mail_bcc, @mail_from, @mail_subject, @mail_body)
		SELECT CONVERT(varchar, SCOPE_IDENTITY()) AS 'id_notification'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spNotification_get_type]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNotification_get_type]
	@type varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF LEN(@type) > 0 BEGIN
		SELECT id
		FROM Notifications
		WHERE type = @type
	END
	ELSE BEGIN
		SELECT '0' AS 'id'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spNotification_get]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNotification_get]
	@id_notification bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_notification > 0 BEGIN
		SELECT id, 
		description,
		type,
		mail_to,
		mail_cc,
		mail_bcc,
		mail_from,
		mail_subject,
		mail_body
		FROM Notifications
		WHERE id = @id_notification
	END
	ELSE BEGIN
		SELECT '0' AS 'id',
		'' AS 'description',
		'' AS 'type',
		'' AS 'mail_to',
		'' AS 'mail_cc',
		'' AS 'mail_bcc',
		'' AS 'mail_from',
		'' AS 'mail_subject',
		'' AS 'mail_body'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spNotification_delete]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNotification_delete]
	@id_notification bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_notification > 0 BEGIN
		DELETE FROM Notifications WHERE id = @id_notification
		SELECT @id_notification AS 'id_notification'
	END
	ELSE BEGIN
		SELECT '0' AS 'id_notification'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spLog_get_all]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLog_get_all]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT l.id,
	l.timestamp,
	l.description,
	l.type_operation,
	l.status_operation,
	l.status_script,
	l.user_operator,
	l.object_managed_primary,
	l.object_managed_secondary
	FROM Log l
	ORDER BY l.timestamp DESC
END
GO
/****** Object:  StoredProcedure [dbo].[spLog_get]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLog_get]
	@id bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id > 0 BEGIN
		SELECT l.id,
		l.timestamp,
		l.description,
		l.type_operation,
		l.status_operation,
		l.status_script,
		l.user_operator,
		l.object_managed_primary,
		l.object_managed_secondary
		FROM Log l
		WHERE l.id = @id
		ORDER BY l.timestamp DESC
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spLog_add]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLog_add]
	@description varchar(255),
	@type_operation varchar(100),
	@status_operation varchar(255),
	@status_script varchar(255),
	@user_operator varchar(50),
	@object_managed_primary varchar(255) = NULL,
	@object_managed_secondary varchar(255) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @object_managed_primary_SAM varchar(50)
	DECLARE @object_managed_secondary_SAM varchar(50)
	
	IF LEN(@object_managed_primary) > 0 BEGIN
		SET @object_managed_primary_SAM = (SELECT TOP 1 c.sAMAccountName
		FROM Cache_table_dn_sAMAccountName c
		WHERE c.distinguishedName = @object_managed_primary)
		
		IF LEN(@object_managed_primary_SAM) > 0 BEGIN
			SET @object_managed_primary = @object_managed_primary_SAM
		END
	END
	
	IF LEN(@object_managed_secondary) > 0 BEGIN
		SET @object_managed_secondary_SAM = (SELECT TOP 1 c.sAMAccountName
		FROM Cache_table_dn_sAMAccountName c
		WHERE c.distinguishedName = @object_managed_secondary)
		
		IF LEN(@object_managed_secondary_SAM) > 0 BEGIN
			SET @object_managed_secondary = @object_managed_secondary_SAM
		END
	END	
	
	IF LEN(@description) > 0 AND LEN(@type_operation) > 0 AND LEN(@status_operation) > 0 BEGIN
		INSERT INTO Log (description, type_operation, status_operation, status_script, user_operator, object_managed_primary, object_managed_secondary) 
		VALUES (@description, @type_operation, @status_operation, @status_script, @user_operator, @object_managed_primary, @object_managed_secondary)
		SELECT CONVERT(varchar, SCOPE_IDENTITY()) AS id_log
	END
	ELSE BEGIN
		SELECT '0' AS 'id_log'
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[spJobvariable_add]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spJobvariable_add]
	@id_job bigint,
	@variable_name varchar(255),
	@variable_value varchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_job > 0 BEGIN
		INSERT INTO JobVariables (id_job, variable_name, variable_value) 
		VALUES (@id_job, @variable_name, @variable_value)
		SELECT CONVERT(varchar, SCOPE_IDENTITY()) AS id_jobvariable
	END
	ELSE BEGIN
		SELECT '0' AS 'id_jobvariable'
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[spJob_start]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spJob_start]
	@id_job bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_job > 0 BEGIN
		UPDATE Jobs
		SET timestamp_start = GETDATE()
		WHERE id = @id_job
	END

	SELECT @id_job AS 'id_job'
END
GO
/****** Object:  StoredProcedure [dbo].[spJob_jobvariables_get]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spJob_jobvariables_get]
	@id_job bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_job > 0 BEGIN
		SELECT id,
		variable_name,
		variable_value
		FROM JobVariables
		WHERE id_job = @id_job
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spJob_finish]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spJob_finish]
	@id_job bigint,
	@status varchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_job > 0 BEGIN
		UPDATE Jobs
		SET timestamp_end = GETDATE(),
		status = @status,
		closed = 1
		WHERE id = @id_job
	END

	SELECT @id_job AS 'id_job'
END
GO
/****** Object:  StoredProcedure [dbo].[spJob_add]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spJob_add]
	@id_task bigint,
	@type varchar(100),
	@umra_project varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_task > 0 BEGIN
		INSERT INTO Jobs (id_task, type, umra_project) 
		VALUES (@id_task, @type, @umra_project)
		SELECT CONVERT(varchar, SCOPE_IDENTITY()) AS id_job
	END
	ELSE BEGIN
		SELECT '0' AS 'id_job'
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[spBatches_get_auto]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBatches_get_auto]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT id, 
	description,
	timestamp_created,
	timestamp_schedule,
	timestamp_start,
	timestamp_end,
	limit_execute_run,
	allow_auto_run,
	closed
	FROM Batches
	WHERE closed = 0
	AND allow_auto_run = 1
	AND (timestamp_schedule < GETDATE() OR timestamp_schedule IS NULL)
	ORDER BY timestamp_schedule, timestamp_created
END
GO
/****** Object:  StoredProcedure [dbo].[spBatches_get]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBatches_get]
	@closed bit
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT b.id, 
	b.description,
	b.timestamp_created,
	b.timestamp_schedule,
	b.timestamp_start,
	b.timestamp_end,
	b.limit_execute_run,
	b.allow_auto_run,
	b.closed,
	(SELECT COUNT(t.id) FROM Tasks t
	WHERE t.id_batch = b.id 
	AND t.closed = 0) AS 'tasks-open',
	(SELECT COUNT(t.id) FROM Tasks t
	WHERE t.id_batch = b.id
	AND t.closed = 1) AS 'tasks-closed'	
	FROM Batches b
	WHERE b.closed = @closed
	ORDER BY b.timestamp_created DESC
END
GO
/****** Object:  StoredProcedure [dbo].[spBatch_update]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBatch_update]
	@id_batch bigint,
	@description varchar(255),
	@limit_execute_run int,
	@allow_auto_run bit,
	@timestamp_schedule datetime
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_batch > 0 AND LEN(@description) > 0 BEGIN
		UPDATE Batches
		SET description = @description,
		limit_execute_run = @limit_execute_run,
		allow_auto_run = @allow_auto_run
		WHERE id = @id_batch
		
		IF LEN(@timestamp_schedule) > 0 BEGIN
			UPDATE Batches 
			SET timestamp_schedule = @timestamp_schedule
			WHERE id = @id_batch
		END
	END

	SELECT @id_batch AS 'id_batch'
END
GO
/****** Object:  StoredProcedure [dbo].[spBatch_tasks_get_auto]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBatch_tasks_get_auto]
	@id_batch bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_batch > 0 BEGIN
		SELECT t.id,
		t.type,
		t.description,
		t.timestamp_created,
		t.timestamp_schedule,
		t.timestamp_start,
		t.timestamp_end,
		t.allow_auto_run,
		t.status,
		t.closed
		FROM Tasks t
		WHERE t.closed = 0
		AND t.id_batch = @id_batch
		AND t.allow_auto_run = 1
		AND (t.timestamp_schedule < GETDATE() OR t.timestamp_schedule IS NULL)
		ORDER BY t.timestamp_schedule, t.timestamp_created
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spBatch_tasks_get]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBatch_tasks_get]
	@id_batch bigint,
	@scheduled_due bit,
	@closed bit
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_batch > 0 BEGIN
		IF @scheduled_due = 0 BEGIN
			SELECT t.id,
			t.type,
			t.description,
			t.timestamp_created,
			t.timestamp_schedule,
			t.timestamp_start,
			t.timestamp_end,
			t.allow_auto_run,
			t.status,
			t.closed,
			(SELECT COUNT(j.id) FROM Jobs j
			WHERE j.closed = 0 
			AND j.id_task = t.id) AS 'jobs-open',
			(SELECT COUNT(j.id) FROM Jobs j
			WHERE j.closed = 1
			AND j.id_task = t.id) AS 'jobs-closed'
			FROM Tasks t
			WHERE t.id_batch = @id_batch
			AND t.closed = @closed
			ORDER BY t.timestamp_created
		END
		ELSE BEGIN
			SELECT t.id,
			t.type,
			t.description,
			t.timestamp_created,
			t.timestamp_schedule,
			t.timestamp_start,
			t.timestamp_end,
			t.allow_auto_run,
			t.status,
			t.closed,
			(SELECT COUNT(j.id) FROM Jobs j
			WHERE j.closed = 0 
			AND j.id_task = t.id) AS 'jobs-open',
			(SELECT COUNT(j.id) FROM Jobs j
			WHERE j.closed = 1
			AND j.id_task = t.id) AS 'jobs-closed'
			FROM Tasks t
			WHERE t.id_batch = @id_batch
			AND t.closed = @closed
			AND (t.timestamp_schedule < GETDATE() OR t.timestamp_schedule IS NULL)
			ORDER BY t.timestamp_created		
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spBatch_start]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBatch_start]
	@id_batch bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_batch > 0 BEGIN
		UPDATE Batches
		SET timestamp_start = GETDATE()
		WHERE id = @id_batch
	END

	SELECT @id_batch AS 'id_batch'
END
GO
/****** Object:  StoredProcedure [dbo].[spBatch_get]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBatch_get]
	@id_batch bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT b.id, 
	b.description,
	b.timestamp_created,
	b.timestamp_schedule,
	b.timestamp_start,
	b.timestamp_end,
	b.limit_execute_run,
	b.allow_auto_run,
	b.closed,
	(SELECT COUNT(t.id) FROM Tasks t
	WHERE t.id_batch = b.id 
	AND t.closed = 0) AS 'tasks-open',
	(SELECT COUNT(t.id) FROM Tasks t
	WHERE t.id_batch = b.id
	AND t.closed = 1) AS 'tasks-closed'	
	FROM Batches b
	WHERE b.id = @id_batch
END
GO
/****** Object:  StoredProcedure [dbo].[spBatch_finish]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBatch_finish]
	@id_batch bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @batch_tasks_open int
	SET @batch_tasks_open = 
	(SELECT COUNT(Tasks.id) 
	FROM Tasks
	WHERE id_batch = @id_batch
	AND Tasks.closed = 0)	
	
	IF @id_batch > 0 AND @batch_tasks_open = 0 BEGIN
		UPDATE Batches
		SET timestamp_end = GETDATE(),
		closed = 1
		WHERE id = @id_batch
	END

	SELECT @id_batch AS 'id_batch'
END
GO
/****** Object:  StoredProcedure [dbo].[spBatch_close]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBatch_close]
	@id_batch bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_batch > 0 BEGIN
		DECLARE @id_tasks TABLE (id bigint)
		DECLARE @id_jobs TABLE (id bigint)
	
		INSERT INTO @id_tasks
		SELECT Tasks.id FROM Tasks
		WHERE Tasks.id_batch = @id_batch
		
		INSERT INTO @id_jobs
		SELECT Jobs.id FROM Jobs
		WHERE Jobs.id_task IN (SELECT id FROM @id_tasks)
	
		UPDATE Jobs
		SET closed = 1,
		timestamp_end = GETDATE()
		WHERE id IN (SELECT id FROM @id_jobs)
		
		UPDATE Tasks
		SET closed = 1,
		timestamp_end = GETDATE()
		WHERE id IN (SELECT id FROM @id_tasks)
		
		UPDATE Batches
		SET closed = 1,
		timestamp_end = GETDATE()
		WHERE id = @id_batch
	END

	SELECT @id_batch AS 'id_batch'
END
GO
/****** Object:  StoredProcedure [dbo].[spBatch_add]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBatch_add]
	@description varchar(255),
	@limit_execute_run int,
	@allow_auto_run bit,
	@timestamp_schedule datetime
AS
BEGIN
	SET NOCOUNT ON;
	
	IF LEN(@description) > 0 BEGIN
		INSERT INTO Batches (description, limit_execute_run, allow_auto_run) 
		VALUES (@description, @limit_execute_run, @allow_auto_run)
		SELECT CONVERT(varchar, SCOPE_IDENTITY()) AS id_batch
		
		IF NOT @timestamp_schedule IS NULL BEGIN
			DECLARE @id_batch bigint
			SET @id_batch = (SELECT CONVERT(varchar, SCOPE_IDENTITY()))
			UPDATE Batches 
			SET timestamp_schedule = @timestamp_schedule
			WHERE id = @id_batch
		END
	END
	ELSE BEGIN
		SELECT '0' AS 'id_batch'
	END	

END
GO
/****** Object:  StoredProcedure [dbo].[spTags_get_object]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_get_object]
	@object_dn varchar(MAX),
	@is_active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @name varchar(255)
	SET @name = (SELECT sAMAccountName 
		FROM Cache_table_dn_sAMAccountName 
		WHERE distinguishedName = @object_dn)	
	
	IF LEN(@name) > 0 BEGIN	
		SELECT 
		t.id,
		t.description, 
		t.keywords,
		t.category,
		t.is_active
		FROM Tags t
		INNER JOIN TagObjects t_o ON t_o.id_tag = t.id
		WHERE t_o.name = @name
		AND t.is_active = @is_active
		AND t_o.is_active = @is_active
	END
	ELSE BEGIN
		SELECT 
		'' AS 'id', 
		'' AS 'description', 
		'' AS 'keywords',
		'' AS 'cetagory',
		'' AS 'is_active'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_get]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_get]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT DISTINCT 
	t.id, 
	t.description, 
	t.keywords,
	t.category,
	t.is_active
	FROM Tags t
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_save]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_save]
	@description varchar(255),
	@keywords varchar(MAX),
	@category varchar(255),
	@id bigint = 0,
	@is_active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id > 0 BEGIN
		IF LEN(@description) > 0 BEGIN
			UPDATE Tags
			SET description = @description
			WHERE id = @id
		END
		IF LEN(@keywords) > 0 BEGIN
			UPDATE Tags
			SET keywords = @keywords
			WHERE id = @id		
		END
		IF LEN(@category) > 0 BEGIN
			UPDATE Tags
			SET category = @category
			WHERE id = @id		
		END
		UPDATE Tags SET is_active = @is_active WHERE id = @id
		SELECT @id AS 'id_tag'
	END
	ELSE BEGIN
		INSERT INTO Tags (description, keywords, category, is_active) 
		VALUES (@description, @keywords, @category, @is_active)
		SELECT CONVERT(varchar, SCOPE_IDENTITY()) AS 'id_tag'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_permissions_get_type]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_permissions_get_type]
	@type varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF LEN(@type) > 0 BEGIN	
		SELECT
		t_p.id,
		t_p.id_tag,
		t_p.name,
		t_p.allowed
		FROM TagPermissions t_p
		WHERE t_p.type = @type
		ORDER BY t_p.name
	END
	ELSE BEGIN
		SELECT 
		'' AS 'id',
		'' AS 'id_tag',
		'' AS 'name',
		'' AS 'allowed'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_permissions_get_name]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_permissions_get_name]
	@name varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF LEN(@name) > 0 BEGIN	
		SELECT
		t_p.id,
		t_p.id_tag,
		t_p.type,
		t_p.allowed
		FROM TagPermissions t_p
		WHERE t_p.name = @name
		ORDER BY t_p.name
	END
	ELSE BEGIN
		SELECT 
		'' AS 'id',
		'' AS 'id_tag',
		'' AS 'type',
		'' AS 'allowed'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_permissions_get]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_permissions_get]
	@id_tag bigint
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_tag > 0 BEGIN
		SELECT
		t_p.id,
		t_p.name,
		t_p.type,
		t_p.allowed
		FROM TagPermissions t_p	
		WHERE t_p.id_tag = @id_tag
		ORDER BY t_p.name
	END
	ELSE BEGIN
		SELECT 
		'' AS 'id', 
		'' AS 'name',
		'' AS 'type',
		'' AS 'allowed'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_permission_remove]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_permission_remove]
	@id_tagpermission bigint
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_tagpermission > 0 BEGIN
		DELETE FROM TagPermissions WHERE id = @id_tagpermission
	END
	ELSE BEGIN
		SELECT '0' AS 'id_tagpermission'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_permission_add]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_permission_add]
	@id_tag bigint,
	@name_input varchar(255),
	@type varchar(255),
	@allowed bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_tag > 0 AND LEN(@name_input) > 0 AND LEN(@type) > 0 BEGIN
		DECLARE @name varchar(255)
		SET @name = (SELECT sAMAccountName 
			FROM Cache_table_dn_sAMAccountName 
			WHERE distinguishedName = @name_input)
		
		IF @name = NULL BEGIN SET @name = @name_input END

		DECLARE @id_tagpermission bigint
	
		SET @id_tagpermission = (SELECT t_p.id 
			FROM TagPermissions t_p
			WHERE t_p.name = @name 
			AND t_p.id_tag = @id_tag
			AND t_p.type = @type
			AND t_p.allowed = @allowed)
	
		IF @id_tagpermission IS NULL BEGIN
			INSERT INTO TagPermissions (id_tag, type, name, allowed) 
			VALUES (@id_tag, @type, @name, @allowed)
			SELECT CONVERT(VARCHAR, SCOPE_IDENTITY()) AS 'id_tagpermission'
		END
	END
	ELSE BEGIN
		SELECT '0' AS 'id_tagpermission'
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_objects_get]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_objects_get]
	@id_tag bigint,
	@type varchar(255)
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_tag > 0 BEGIN
		IF @type = 'user' BEGIN
			SELECT DISTINCT
			t_o.id, 
			c_u.attribute_1,
			c_u.attribute_2,
			c_u.attribute_3,
			c_u.attribute_4,
			c_u.attribute_5,
			c_u.attribute_6,
			c_u.attribute_7,
			c_u.attribute_8,
			c_u.attribute_9,
			t_o.date_start,
			t_o.date_end
			FROM Cache_table_users c_u
			INNER JOIN Cache_table_dn_sAMAccountName c ON c.distinguishedName = c_u.dn
			INNER JOIN TagObjects t_o ON t_o.name = c.sAMAccountName
			WHERE t_o.id_tag = @id_tag
			AND t_o.type = @type
			AND t_o.is_active = 1
		END
		IF @type = 'group' BEGIN
			SELECT DISTINCT
			t_o.id, 
			c_g.attribute_1,
			c_g.attribute_2,
			c_g.attribute_3,
			c_g.attribute_4,
			c_g.attribute_5,
			c_g.attribute_6,
			c_g.attribute_7,
			c_g.attribute_8,
			c_g.attribute_9,
			t_o.date_start,
			t_o.date_end
			FROM Cache_table_groups c_g
			INNER JOIN Cache_table_dn_sAMAccountName c ON c.distinguishedName = c_g.dn
			INNER JOIN TagObjects t_o ON t_o.name = c.sAMAccountName
			WHERE t_o.id_tag = @id_tag
			AND t_o.type = @type
			AND t_o.is_active = 1
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_get]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_get]
	@id_tag bigint,
	@name varchar(255),
	@type varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_tag > 0 AND LEN(@name) > 0 AND LEN(@type) > 0 BEGIN
		SET @name = (SELECT sAMAccountName
			FROM Cache_table_dn_sAMAccountName
			WHERE distinguishedName = @name)
					
		SELECT 
		t_o.id
		FROM TagObjects t_o
		WHERE t_o.name = @name
		AND t_o.type = @type
		AND t_o.id_tag = @id_tag
	END
	ELSE BEGIN
		SELECT '0' AS 'id'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_disable]    Script Date: 10/19/2012 14:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_disable]
	@id_tagobject bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_tagobject > 0 BEGIN
		UPDATE TagObjects SET is_active = 0 WHERE id = @id_tagobject
		SELECT @id_tagobject
	END
	ELSE BEGIN
		SELECT '0' AS 'id_tagobject'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_add]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_add]
	@id_tag bigint,
	@name varchar(255),
	@type varchar(255),
	@date_start datetime = NULL,
	@date_end datetime = NULL,
	@is_active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @date_start = '' BEGIN SET @date_start = NULL END
	IF @date_end = '' BEGIN SET @date_end = NULL END
	
	IF @id_tag > 0 AND LEN(@name) > 0 AND LEN(@type) > 0 BEGIN
		DECLARE @id_tagobject bigint
		
		SET @name = (SELECT sAMAccountName
			FROM Cache_table_dn_sAMAccountName
			WHERE distinguishedName = @name)
		
		SET @id_tagobject = (SELECT id 
			FROM TagObjects
			WHERE name = @name
			AND id_tag = @id_tag
			AND type = @type)
	
		IF @id_tagobject > 0 BEGIN
			UPDATE TagObjects SET is_active = 1 WHERE id = @id_tagobject
		END
	
		IF @id_tagobject IS NULL AND LEN(@name) > 0 BEGIN
			INSERT INTO TagObjects (id_tag, type, name, date_start, date_end, is_active) 
			VALUES (@id_tag, @type, @name, @date_start, @date_end, @is_active)
			SELECT CONVERT(varchar, SCOPE_IDENTITY()) AS 'id_tagobject'
		END
		ELSE BEGIN
			SELECT '0' AS 'id_tagobject'
		END
	END
	ELSE BEGIN
		SELECT '0' AS 'id_tagobject'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_get]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_get]
	@id_tag bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_tag > 0 BEGIN
		SELECT 
		t.id, 
		t.description, 
		t.keywords,
		t.category,
		t.is_active
		FROM Tags t
		WHERE id = @id_tag
	END
	ELSE BEGIN
		SELECT '0' AS 'id', 
		'' AS 'description', 
		'' AS 'keywords',
		'' AS 'category',
		'' AS 'is_active'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_disable]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_disable]
	@id bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id > 0 BEGIN
		UPDATE TagObjects SET is_active = 0 WHERE id_tag = @id
		UPDATE Tags SET is_active = 0 WHERE id = @id
		SELECT @id AS 'id_tag'
	END
	ELSE BEGIN
		SELECT '0' AS 'id_tag'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshots_get]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshots_get]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT id,
	description,
	timestamp_start,
	timestamp_end,
	status
	FROM Snapshots
	ORDER BY timestamp_start DESC

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_table_user_attributes_groups_managedby]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_table_user_attributes_groups_managedby]
	@object_dn varchar(255)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT oa_key.attribute_value,
	c_g.attribute_1,
	c_g.attribute_2,
	c_g.attribute_3,
	c_g.attribute_4,
	c_g.attribute_5,
	c_g.attribute_6,
	c_g.attribute_7,
	c_g.attribute_8,
	c_g.attribute_9
	FROM Objects o_g
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o_g.id AND oa_key.is_key = 1
	INNER JOIN Cache_table_groups c_g ON c_g.dn = oa_key.attribute_value
	INNER JOIN Relationships r_managedby ON r_managedby.id_object_parent = o_g.id
	INNER JOIN Objects o_m ON r_managedby.id_object_child = o_m.id AND o_m.type = 'group' AND r_managedby.type = 'managedBy'
	INNER JOIN Relationships r_member ON r_member.id_object_parent = o_m.id
	INNER JOIN Objects o_u ON r_member.id_object_child = o_u.id AND o_u.type = 'user' AND r_member.type = 'member'
	WHERE oa_key.attribute_value = @object_dn 
	AND o_u.id_snapshot = (SELECT MAX(id) FROM Snapshots)
	AND o_m.id_snapshot = (SELECT MAX(id) FROM Snapshots)
	AND o_g.id_snapshot = (SELECT MAX(id) FROM Snapshots)
	AND o_g.type = 'group'
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_table_snapshot_manager_groups_costs]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_table_snapshot_manager_groups_costs]
	@object_dn_manager varchar(255),
	@attribute_name_cost varchar(255),
	@id_snapshot bigint = 0
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_snapshot = 0 BEGIN SET @id_snapshot = (SELECT MAX(id) FROM Snapshots) END
	
	SELECT DISTINCT
	oa_key.attribute_value,
	c_g.attribute_1,
	c_g.attribute_2,
	c_g.attribute_3,
	c_g.attribute_4,
	c_g.attribute_5,
	c_g.attribute_6,
	c_g.attribute_7,
	c_g.attribute_8,
	c_g.attribute_9,
	COUNT(r_m.id) as 'count',
	SUM(CONVERT(bigint, oa_cost_g.attribute_value)) as 'cost'
	FROM Objects o_g
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o_g.id 
		AND oa_key.is_key = 1
		AND o_g.id_snapshot = @id_snapshot
	INNER JOIN ObjectAttributes oa_cost_g ON oa_cost_g.id_object = o_g.id
		AND o_g.id_snapshot = @id_snapshot
	INNER JOIN Cache_table_groups c_g ON c_g.dn = oa_key.attribute_value
	INNER JOIN Relationships r_m ON r_m.id_object_parent = o_g.id
		AND o_g.id_snapshot = @id_snapshot
	INNER JOIN Objects o_u ON o_u.id = r_m.id_object_child
		AND o_u.id_snapshot = @id_snapshot
	INNER JOIN Relationships r_managedby ON r_managedby.id_object_parent = o_u.id
		AND o_u.id_snapshot = @id_snapshot
	INNER JOIN Objects o_m ON o_m.id = r_managedby.id_object_child
		AND o_m.id_snapshot = @id_snapshot
	INNER JOIN ObjectAttributes oa_m_key ON oa_m_key.id_object = o_m.id	
		AND oa_m_key.is_key = 1
		AND o_m.id_snapshot = @id_snapshot
	WHERE oa_m_key.attribute_value = @object_dn_manager
	AND r_m.type = 'member'
	AND oa_cost_g.attribute_name = @attribute_name_cost
	GROUP BY oa_key.attribute_value, c_g.attribute_1, c_g.attribute_2, c_g.attribute_3, c_g.attribute_4, c_g.attribute_5,
	c_g.attribute_6, c_g.attribute_7, c_g.attribute_8, c_g.attribute_9
	HAVING SUM(CONVERT(bigint, oa_cost_g.attribute_value)) > 0

	UNION
	
	SELECT DISTINCT
	'id-total',
	'Total',
	'Total',
	'Total',
	'Total',
	'Total',
	'Total',
	'Total',
	'Total',
	'Total',
	COUNT(r_m.id) as 'count',
	SUM(CONVERT(bigint, oa_cost_g.attribute_value)) as 'cost'
	FROM Objects o_g
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o_g.id 
		AND oa_key.is_key = 1
		AND o_g.id_snapshot = @id_snapshot
	INNER JOIN ObjectAttributes oa_cost_g ON oa_cost_g.id_object = o_g.id
		AND o_g.id_snapshot = @id_snapshot
	INNER JOIN Cache_table_groups c_g ON c_g.dn = oa_key.attribute_value
	INNER JOIN Relationships r_m ON r_m.id_object_parent = o_g.id
		AND o_g.id_snapshot = @id_snapshot
	INNER JOIN Objects o_u ON o_u.id = r_m.id_object_child
		AND o_u.id_snapshot = @id_snapshot
	INNER JOIN Relationships r_managedby ON r_managedby.id_object_parent = o_u.id
		AND o_u.id_snapshot = @id_snapshot
	INNER JOIN Objects o_m ON o_m.id = r_managedby.id_object_child
		AND o_m.id_snapshot = @id_snapshot
	INNER JOIN ObjectAttributes oa_m_key ON oa_m_key.id_object = o_m.id	
		AND oa_m_key.is_key = 1
		AND o_m.id_snapshot = @id_snapshot
	WHERE oa_m_key.attribute_value = @object_dn_manager
	AND r_m.type = 'member'
	AND oa_cost_g.attribute_name = @attribute_name_cost
	
	ORDER BY 'cost'

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_table_snapshot_manager_group_users]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_table_snapshot_manager_group_users]
	@object_dn_manager varchar(255),
	@object_dn_group varchar(255),
	@id_snapshot bigint = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_snapshot = 0 BEGIN SET @id_snapshot = (SELECT MAX(id) FROM Snapshots) END
	
	SELECT DISTINCT
	oa_u_key.attribute_value,
	c_u.attribute_1,
	c_u.attribute_2,
	c_u.attribute_3,
	c_u.attribute_4,
	c_u.attribute_5,
	c_u.attribute_6,
	c_u.attribute_7,
	c_u.attribute_8,
	c_u.attribute_9
	FROM Objects o_u
	INNER JOIN ObjectAttributes oa_u_key ON oa_u_key.id_object = o_u.id 
		AND oa_u_key.is_key = 1
		AND o_u.id_snapshot = @id_snapshot
	INNER JOIN Cache_table_users c_u ON c_u.dn = oa_u_key.attribute_value
	INNER JOIN Relationships r_managedby ON r_managedby.id_object_parent = o_u.id
	INNER JOIN Objects o_m ON o_m.id = r_managedby.id_object_child
	INNER JOIN ObjectAttributes oa_m_key ON oa_m_key.id_object = o_m.id 
		AND oa_m_key.is_key = 1
		AND o_m.id_snapshot = @id_snapshot
	INNER JOIN Relationships r ON r.id_object_child = o_u.id
	INNER JOIN Objects o_g ON o_g.id = r.id_object_parent
	INNER JOIN ObjectAttributes oa_g_key ON oa_g_key.id_object = o_g.id 
		AND oa_g_key.is_key = 1
		AND o_g.id_snapshot = @id_snapshot
	WHERE oa_m_key.attribute_value = @object_dn_manager
	AND oa_g_key.attribute_value = @object_dn_group
	ORDER BY oa_u_key.attribute_value
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_table_relationships_report]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_table_relationships_report]
	@attribute_name_1 varchar(100),
	@attribute_name_2 varchar(100) = NULL,
	@attribute_name_3 varchar(100) = NULL,
	@attribute_name_4 varchar(100) = NULL,
	@min_percentage float = 50,
	@id_snapshot bigint = 0,
	@type_object_role varchar(100) = 'user',
	@type_relationship varchar(100) = 'member'
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_snapshot = 0 BEGIN SET @id_snapshot = (SELECT MAX(id) FROM Snapshots) END

	DECLARE @name_role varchar(100)
	DECLARE @count_role float
	DECLARE @name_relationship varchar(100)
	DECLARE @fill_percentage float
	
	DECLARE @table_temp table(name_role varchar(100), count_role int, name_relationship varchar(100), fill_percentage float)

	DECLARE c_role CURSOR FOR
	SELECT DISTINCT
	oa_1.attribute_value + ISNULL(oa_2.attribute_value, '') + ISNULL(oa_3.attribute_value, '') + ISNULL(oa_4.attribute_value, ''),
	COUNT(o.id)
	FROM Objects o
	INNER JOIN ObjectAttributes oa_1 ON oa_1.id_object = o.id 
		AND oa_1.attribute_name = @attribute_name_1
		AND o.id_snapshot = @id_snapshot
		AND o.type = @type_object_role
	LEFT JOIN ObjectAttributes oa_2 ON oa_2.id_object = o.id 
		AND oa_2.attribute_name = @attribute_name_2 
		AND NOT @attribute_name_2 IS NULL
		AND o.id_snapshot = @id_snapshot
		AND o.type = @type_object_role
	LEFT JOIN ObjectAttributes oa_3 ON oa_3.id_object = o.id 
		AND oa_3.attribute_name = @attribute_name_3 
		AND NOT @attribute_name_3 IS NULL
		AND o.id_snapshot = @id_snapshot
		AND o.type = @type_object_role
	LEFT JOIN ObjectAttributes oa_4 ON oa_4.id_object = o.id 
		AND oa_4.attribute_name = @attribute_name_4 
		AND NOT @attribute_name_4 IS NULL
		AND o.id_snapshot = @id_snapshot
		AND o.type = @type_object_role
	GROUP BY oa_1.attribute_value, oa_2.attribute_value, oa_3.attribute_value, oa_4.attribute_value
	HAVING COUNT(o.id) > 1
	OPEN c_role;
	
	FETCH NEXT FROM c_role
	INTO @name_role, @count_role
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		IF NOT @name_role IS NULL 
		BEGIN
	
			DECLARE c_relationships CURSOR FOR
			SELECT DISTINCT
			oa_r_show.attribute_value,
			ROUND(CONVERT(float, COUNT(oa_r_show.attribute_value)) / @count_role * 100, 2)
			FROM Objects o
			INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = o.id 
				AND oa_key.is_key = 1 
				AND o.id_snapshot = @id_snapshot
			INNER JOIN ObjectAttributes oa_1 ON oa_1.id_object = o.id 
				AND oa_1.attribute_name = @attribute_name_1
			LEFT JOIN ObjectAttributes oa_2 ON oa_2.id_object = o.id 
				AND oa_2.attribute_name = @attribute_name_2 
				AND NOT @attribute_name_2 IS NULL
			LEFT JOIN ObjectAttributes oa_3 ON oa_3.id_object = o.id 
				AND oa_3.attribute_name = @attribute_name_3 
				AND NOT @attribute_name_3 IS NULL
			LEFT JOIN ObjectAttributes oa_4 ON oa_4.id_object = o.id 
				AND oa_4.attribute_name = @attribute_name_4 
				AND NOT @attribute_name_4 IS NULL
			INNER JOIN ObjectAttributes oa_match_role ON oa_match_role.id_object = o.id 
				AND oa_match_role.is_key = 1	
			INNER JOIN ObjectAttributes oa_match_authorization ON oa_match_authorization.attribute_value = oa_match_role.attribute_value
				AND oa_match_authorization.is_key = 1
			INNER JOIN Objects o_match ON o_match.id = oa_match_authorization.id_object 
				AND o_match.id_snapshot = @id_snapshot
			INNER JOIN Relationships r ON r.id_object_child = o.id 
				AND r.type = @type_relationship
			INNER JOIN Objects o_r ON o_r.id = r.id_object_parent 
				AND o_r.id_snapshot = @id_snapshot
			INNER JOIN ObjectAttributes oa_r_show ON oa_r_show.id_object = o_r.id 
				AND oa_r_show.is_show = 1
			WHERE oa_1.attribute_value + ISNULL(oa_2.attribute_value, '') + ISNULL(oa_3.attribute_value, '') + ISNULL(oa_4.attribute_value, '') = @name_role
			GROUP BY oa_r_show.attribute_value
			HAVING ROUND(CONVERT(float, COUNT(oa_r_show.attribute_value)) / @count_role * 100, 2) > @min_percentage
			ORDER BY ROUND(CONVERT(float, COUNT(oa_r_show.attribute_value)) / @count_role * 100, 2) DESC
			OPEN c_relationships;
			
			FETCH NEXT FROM c_relationships
			INTO @name_relationship, @fill_percentage
			
			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO @table_temp (name_role, count_role, name_relationship, fill_percentage)
				VALUES (@name_role, @count_role, @name_relationship, @fill_percentage)
			
				FETCH NEXT FROM c_relationships
				INTO @name_relationship, @fill_percentage
			END
			
			CLOSE c_relationships
			DEALLOCATE c_relationships	
			
		END

		FETCH NEXT FROM c_role
		INTO @name_role, @count_role
	END
	
	CLOSE c_role
	DEALLOCATE c_role
	
	SELECT
	name_role,
	count_role,
	name_relationship,
	fill_percentage
	FROM @table_temp
	ORDER BY name_role
	
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_table_group_attributes_managedby_users]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_table_group_attributes_managedby_users]
	@object_dn varchar(255),
	@id_snapshot bigint = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_snapshot = 0 BEGIN SET @id_snapshot = (SELECT MAX(id) FROM Snapshots) END

	SELECT oa_u_key.attribute_value,
	c_u.attribute_1,
	c_u.attribute_2,
	c_u.attribute_3,
	c_u.attribute_4,
	c_u.attribute_5,
	c_u.attribute_6,
	c_u.attribute_7,
	c_u.attribute_8,
	c_u.attribute_9
	FROM Objects o_u
	INNER JOIN ObjectAttributes oa_u_key ON oa_u_key.id_object = o_u.id 
		AND oa_u_key.is_key = 1
		AND o_u.id_snapshot = @id_snapshot
		AND o_u.type = 'user'
	INNER JOIN Cache_table_users c_u ON c_u.dn = oa_u_key.attribute_value
	INNER JOIN Relationships r_member ON r_member.id_object_child = o_u.id
	INNER JOIN Objects o_g ON o_g.id = r_member.id_object_parent 
		AND r_member.type = 'member' 
		AND o_g.type = 'group'
		AND o_g.id_snapshot = @id_snapshot
	INNER JOIN Relationships r_managedby ON r_managedby.id_object_child = o_g.id
	INNER JOIN Objects o_m ON o_m.id = r_managedby.id_object_parent 
		AND r_managedby.type = 'managedBy' 
		AND o_m.type = 'group'
		AND o_m.id_snapshot = @id_snapshot
	INNER JOIN ObjectAttributes oa_m_key ON oa_m_key.id_object = o_m.id AND oa_m_key.is_key = 1
	WHERE oa_m_key.attribute_value = @object_dn
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_start]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_start]
	@description varchar(255),
	@status varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF LEN(@description) > 0 AND LEN(@status) > 0 BEGIN
		INSERT INTO Snapshots (description, status) 
		VALUES (@description, @status)
		SELECT CONVERT(varchar, SCOPE_IDENTITY()) AS id_snapshot
	END
	ELSE BEGIN
		SELECT '' AS 'id_snapshot'
	END	

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_relationships_add_staging_vertical]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_relationships_add_staging_vertical]
	@id_snapshot bigint,
	@type varchar(255),
	@source_parent varchar(255),
	@source_child varchar(255),
	@column_index_parent int,
	@object_type_parent varchar(255),
	@column_index_child int,
	@object_type_child varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @sql varchar(MAX)
	DECLARE @table_temp table (field_key varchar(MAX), field_related varchar(MAX), id_object_parent int, id_object_child int)
	
	DECLARE @key varchar(MAX)
	DECLARE @key_related varchar(MAX)
	DECLARE @id_object_parent bigint
	DECLARE @id_object_child bigint

	IF LEN(@source_parent) > 0 AND LEN(@source_child) > 0 BEGIN
		SET @sql = 'SELECT DISTINCT 
		s_t.field_' + CONVERT(varchar, @column_index_parent) + ', 
		s_t.field_' + CONVERT(varchar, @column_index_child) + ', 
		o_parent.id, 
		o_child.id
		FROM Staging_table s_t
		INNER JOIN ObjectAttributes oa_parent ON oa_parent.attribute_value = s_t.field_' + CONVERT(varchar, @column_index_parent) + '
		INNER JOIN Objects o_parent ON o_parent.id = oa_parent.id_object 
		AND o_parent.id_snapshot = ' + CONVERT(varchar, @id_snapshot) + '
		AND o_parent.source = ''' + @source_parent + '''
		AND o_parent.type = ''' + @object_type_parent + '''
		INNER JOIN ObjectAttributes oa_child ON oa_child.attribute_value = s_t.field_' + CONVERT(varchar, @column_index_child) + '
		INNER JOIN Objects o_child ON o_child.id = oa_child.id_object  
		AND o_child.id_snapshot = ' + CONVERT(varchar, @id_snapshot) + '
		AND o_child.source = ''' + @source_child + '''
		AND o_child.type = ''' + @object_type_child + '''
		WHERE oa_parent.is_key = 1
		AND oa_child.is_key = 1'
	END
	ELSE BEGIN
		SET @sql = 'SELECT DISTINCT 
		s_t.field_' + CONVERT(varchar, @column_index_parent) + ', 
		s_t.field_' + CONVERT(varchar, @column_index_child) + ', 
		o_parent.id, 
		o_child.id
		FROM Staging_table s_t
		INNER JOIN ObjectAttributes oa_parent ON oa_parent.attribute_value = s_t.field_' + CONVERT(varchar, @column_index_parent) + '
		INNER JOIN Objects o_parent ON o_parent.id = oa_parent.id_object 
		AND o_parent.id_snapshot = ' + CONVERT(varchar, @id_snapshot) + '
		INNER JOIN ObjectAttributes oa_child ON oa_child.attribute_value = s_t.field_' + CONVERT(varchar, @column_index_child) + '
		INNER JOIN Objects o_child ON o_child.id = oa_child.id_object  
		AND o_child.id_snapshot = ' + CONVERT(varchar, @id_snapshot) + '
		WHERE oa_parent.is_key = 1
		AND oa_child.is_key = 1'
	END
	
	INSERT INTO @table_temp
	EXEC(@sql);
	
	DECLARE staging_cursor CURSOR FOR
	SELECT field_key, field_related, id_object_parent, id_object_child
	FROM @table_temp
	OPEN staging_cursor;

	FETCH NEXT FROM staging_cursor 
	INTO @key, @key_related, @id_object_parent, @id_object_child

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @id_object_parent > 0 AND @id_object_child > 0 BEGIN
			INSERT INTO Relationships (type, id_object_parent, id_object_child)
			VALUES (@type, @id_object_parent, @id_object_child)
		END

		FETCH NEXT FROM staging_cursor 
		INTO @key, @key_related, @id_object_parent, @id_object_child																
	END
	CLOSE staging_cursor
	DEALLOCATE staging_cursor	
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_relationships_add_staging_horizontal]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_relationships_add_staging_horizontal]
	@id_snapshot bigint,
	@type varchar(255),
	@source_parent varchar(255),
	@source_child varchar(255),
	@column_index_parent int,
	@object_type_parent varchar(255),
	@column_index_child int,
	@object_type_child varchar(255),
	@keys_related_separator varchar(1)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @sql varchar(MAX)
	DECLARE @table_temp table (field_key varchar(MAX), field_related varchar(MAX), id_object_parent bigint)
	
	DECLARE @key varchar(MAX)
	DECLARE @keys_related varchar(MAX)
	DECLARE @id_object_parent bigint
	DECLARE @id_object_child bigint

	IF LEN(@source_parent) > 0 AND LEN(@source_child) > 0 BEGIN
		SET @sql = 'SELECT DISTINCT 
		s_t.field_' + CONVERT(varchar, @column_index_parent) + ', 
		s_t.field_' + CONVERT(varchar, @column_index_child) + ', 
		o_parent.id
		FROM Staging_table s_t
		INNER JOIN ObjectAttributes oa_parent ON oa_parent.attribute_value = s_t.field_' + CONVERT(varchar, @column_index_parent) + '
		INNER JOIN Objects o_parent ON o_parent.id = oa_parent.id_object 
		AND o_parent.id_snapshot = ' + CONVERT(varchar, @id_snapshot) + '
		AND o_parent.type = ''' + @object_type_parent + '''
		AND o_parent.source = ''' + @source_parent + '''
		AND oa_parent.is_key = 1'
	END
	ELSE BEGIN
		SET @sql = 'SELECT DISTINCT 
		s_t.field_' + CONVERT(varchar, @column_index_parent) + ', 
		s_t.field_' + CONVERT(varchar, @column_index_child) + ', 
		o_parent.id
		FROM Staging_table s_t
		INNER JOIN ObjectAttributes oa_parent ON oa_parent.attribute_value = s_t.field_' + CONVERT(varchar, @column_index_parent) + '
		INNER JOIN Objects o_parent ON o_parent.id = oa_parent.id_object 
		AND o_parent.id_snapshot = ' + CONVERT(varchar, @id_snapshot) + '
		WHERE oa_parent.is_key = 1'
	END
	
	INSERT INTO @table_temp
	EXEC(@sql);
	
	DECLARE staging_cursor CURSOR FOR
	SELECT field_key, field_related, id_object_parent
	FROM @table_temp
	OPEN staging_cursor;

	FETCH NEXT FROM staging_cursor 
	INTO @key, @keys_related, @id_object_parent

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF LEN(@source_parent) > 0 AND LEN(@source_child) > 0 BEGIN
			DECLARE r_cursor CURSOR FOR
			SELECT o.id
			FROM StringToTable(@keys_related, @keys_related_separator) s_t
			INNER JOIN ObjectAttributes oa ON oa.attribute_value = s_t.string
			INNER JOIN Objects o ON o.id = oa.id_object
			WHERE o.source = @source_child
			AND o.type = @object_type_child
			AND o.id_snapshot = @id_snapshot
			AND oa.is_key = 1
		END
		ELSE BEGIN
			DECLARE r_cursor CURSOR FOR
			SELECT o.id
			FROM StringToTable(@keys_related, @keys_related_separator) s_t
			INNER JOIN ObjectAttributes oa ON oa.attribute_value = s_t.string
			INNER JOIN Objects o ON o.id = oa.id_object
			WHERE o.id_snapshot = @id_snapshot
			AND oa.is_key = 1
		END
		
		OPEN r_cursor;
		
		FETCH NEXT FROM r_cursor
		INTO @id_object_child
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @id_object_parent > 0 AND @id_object_child > 0 BEGIN
				INSERT INTO Relationships (type, id_object_parent, id_object_child)
				VALUES (@type, @id_object_parent, @id_object_child)
			END
			
			FETCH NEXT FROM r_cursor
			INTO @id_object_child
		END
		CLOSE r_cursor
		DEALLOCATE r_cursor

		FETCH NEXT FROM staging_cursor 
		INTO @key, @keys_related, @id_object_parent
	END
	CLOSE staging_cursor
	DEALLOCATE staging_cursor	
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_relationships_get]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_relationships_get]
	@is_key bit = 1,
	@is_active bit = 1,
	@type_object_parent varchar(50) = 'group',
	@type_object_child varchar(50) = 'user'
AS
BEGIN
	SET NOCOUNT ON;

	IF @is_key = 1 BEGIN
		SELECT DISTINCT
		c_g.distinguishedName,
		c_u.distinguishedName,
		t_o_group.date_start,
		t_o_group.date_end,
		t_o_user.date_start,
		t_o_user.date_end
		FROM TagObjects t_o_group
		INNER JOIN TagObjects t_o_user ON t_o_user.id_tag = t_o_group.id_tag
			AND t_o_user.type = @type_object_child
			AND t_o_user.is_active = @is_active
			AND t_o_group.type = @type_object_parent
			AND t_o_group.is_active = @is_active
		INNER JOIN Tags t ON t.id = t_o_group.id_tag
			AND t.is_active = @is_active
		INNER JOIN Cache_table_dn_sAMAccountName c_g ON c_g.sAMAccountName = t_o_group.name	
		INNER JOIN Cache_table_dn_sAMAccountName c_u ON c_u.sAMAccountName = t_o_user.name
		WHERE (t_o_group.date_start < GETDATE() OR t_o_group.date_start IS NULL)
		AND (t_o_group.date_end > GETDATE() OR t_o_group.date_end IS NULL)
		AND (t_o_user.date_start < GETDATE() OR t_o_user.date_start IS NULL)
		AND (t_o_user.date_end > GETDATE() OR t_o_user.date_end IS NULL)
		ORDER BY c_g.distinguishedName, c_u.distinguishedName
	END
	ELSE BEGIN
		SELECT DISTINCT
		t_o_group.name,
		t_o_user.name,
		t_o_group.date_start,
		t_o_group.date_end,
		t_o_user.date_start,
		t_o_user.date_end
		FROM TagObjects t_o_group
		INNER JOIN TagObjects t_o_user ON t_o_user.id_tag = t_o_group.id_tag
			AND t_o_user.type = @type_object_child
			AND t_o_user.is_active = @is_active
			AND t_o_group.type = @type_object_parent
			AND t_o_group.is_active = @is_active
		INNER JOIN Tags t ON t.id = t_o_group.id_tag
			AND t.is_active = @is_active			
		INNER JOIN Cache_table_dn_sAMAccountName c_g ON c_g.sAMAccountName = t_o_group.name	
		INNER JOIN Cache_table_dn_sAMAccountName c_u ON c_u.sAMAccountName = t_o_user.name			
		WHERE (t_o_group.date_start < GETDATE() OR t_o_group.date_start IS NULL)
		AND (t_o_group.date_end > GETDATE() OR t_o_group.date_end IS NULL)
		AND (t_o_user.date_start < GETDATE() OR t_o_user.date_start IS NULL)
		AND (t_o_user.date_end > GETDATE() OR t_o_user.date_end IS NULL)			
		ORDER BY t_o_group.name, t_o_user.name
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_keywords_find]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_keywords_find]
	@keywords varchar(255),
	@category varchar(255) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	IF LEN(@keywords) > 0 BEGIN
		SELECT 
		t.id, 
		t.description, 
		t.keywords,
		t.category,
		t.is_active
		FROM Tags t
		WHERE keywords = @keywords
		AND (t.category = @category OR @category IS NULL)
	END
	ELSE BEGIN
		SELECT '0' AS 'id',
		'' AS 'description',
		'' AS 'keywords',
		'' AS 'category',
		'' AS 'is_active'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_get_permissions]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_get_permissions]
	@name varchar(255),
	@type varchar(50) = NULL,
	@is_active bit = 1
AS
BEGIN
	SET NOCOUNT ON;

	IF LEN(@name) > 0 BEGIN	
		DECLARE @id_snapshot bigint
		SET @id_snapshot = (SELECT MAX(id) FROM Snapshots)
		
		DECLARE @id_object bigint
		SET @id_object = (SELECT o.id FROM Objects o
			INNER JOIN ObjectAttributes oa ON oa.id_object = o.id
				AND o.id_snapshot = @id_snapshot
				AND oa.is_key = 1
			WHERE oa.attribute_value = @name)

		IF @id_object > 0 BEGIN		
			DECLARE @table_member table (id varchar(255), id_object_parent varchar(255), type_parent varchar(50),
				attribute_value_parent varchar(255), type_relation varchar(50),	id_object_child varchar(255),
				type_child varchar(50),	attribute_value_child varchar(255),	level_relation varchar(50))
			
			INSERT @table_member
			EXEC spSnapshot_get_object_relationships_parent @id_object
			
			IF LEN(@type) > 0 BEGIN
				SELECT t.id, 
				t.description, 
				t.keywords,
				t.category,
				t.is_active
				FROM Tags t
				INNER JOIN TagPermissions t_p_allow ON t_p_allow.id_tag = t.id
					AND t_p_allow.allowed = 1
					AND t_p_allow.type = @type
					AND t_p_allow.name IN (SELECT attribute_value_parent FROM @table_member)
				WHERE t.is_active = @is_active
				AND
				(SELECT t_p_deny.allowed
				FROM TagPermissions t_p_deny
				WHERE t_p_deny.type = t_p_allow.type
				AND t_p_deny.allowed = 0
				AND t_p_deny.name IN (SELECT attribute_value_parent FROM @table_member)) IS NULL
			END
			ELSE BEGIN		
				SELECT t.id, 
				t.description, 
				t.keywords,
				t.category,
				t.is_active,
				t_p_allow.type
				FROM Tags t
				INNER JOIN TagPermissions t_p_allow ON t_p_allow.id_tag = t.id
					AND t_p_allow.allowed = 1
					AND t_p_allow.name IN (SELECT attribute_value_parent FROM @table_member)
				WHERE t.is_active = @is_active
				AND
				(SELECT t_p_deny.allowed
				FROM TagPermissions t_p_deny
				WHERE t_p_deny.type = t_p_allow.type
				AND t_p_deny.allowed = 0
				AND t_p_deny.name IN (SELECT attribute_value_parent FROM @table_member)) IS NULL
			END
		END
		ELSE BEGIN
			IF LEN(@type) > 0 BEGIN
				SELECT t.id,
				t.description,
				t.keywords,
				t.category
				FROM Tags t
				INNER JOIN TagPermissions t_p_allow ON t_p_allow.id_tag = t.id
					AND t_p_allow.allowed = 1
					AND t_p_allow.type = @type
					AND t_p_allow.name = @name
				WHERE 
				(SELECT t_p_deny.allowed
				FROM TagPermissions t_p_deny
				WHERE t_p_deny.type = t_p_allow.type
				AND t_p_deny.allowed = 0
				AND t_p_deny.name = @name) IS NULL	
			END
			ELSE BEGIN
				SELECT t.id,
				t.description,
				t.keywords,
				t.category,
				t_p_allow.type
				FROM Tags t
				INNER JOIN TagPermissions t_p_allow ON t_p_allow.id_tag = t.id
					AND t_p_allow.allowed = 1
					AND t_p_allow.name = @name
				WHERE 
				(SELECT t_p_deny.allowed
				FROM TagPermissions t_p_deny
				WHERE t_p_deny.type = t_p_allow.type
				AND t_p_deny.allowed = 0
				AND t_p_deny.name = @name) IS NULL
			END					
		END
	END
	ELSE BEGIN
		SELECT '0' AS 'id',
		'' AS 'description',
		'' AS 'keywords',
		'' AS 'category',
		'' AS 'type'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_objects_add_staging]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_objects_add_staging]
	@id_snapshot bigint,
	@type varchar(255),
	@source varchar(255),
	@column_index_key int,
	@column_index_show int
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_object bigint
	DECLARE @field_key varchar(500)
	
	DECLARE @attribute_name_0 varchar(255)
	DECLARE @attribute_name_1 varchar(255)
	DECLARE @attribute_name_2 varchar(255)
	DECLARE @attribute_name_3 varchar(255)
	DECLARE @attribute_name_4 varchar(255)
	DECLARE @attribute_name_5 varchar(255)
	DECLARE @attribute_name_6 varchar(255)
	DECLARE @attribute_name_7 varchar(255)
	DECLARE @attribute_name_8 varchar(255)
	DECLARE @attribute_name_9 varchar(255)
	DECLARE @attribute_name_10 varchar(255)
	DECLARE @attribute_name_11 varchar(255)
	DECLARE @attribute_name_12 varchar(255)
	DECLARE @attribute_name_13 varchar(255)
	DECLARE @attribute_name_14 varchar(255)
	DECLARE @attribute_name_15 varchar(255)
	DECLARE @attribute_name_16 varchar(255)
	DECLARE @attribute_name_17 varchar(255)
	DECLARE @attribute_name_18 varchar(255)
	DECLARE @attribute_name_19 varchar(255)
	DECLARE @attribute_name_20 varchar(255)
	DECLARE @attribute_name_21 varchar(255)
	DECLARE @attribute_name_22 varchar(255)
	DECLARE @attribute_name_23 varchar(255)
	DECLARE @attribute_name_24 varchar(255)
	DECLARE @attribute_name_25 varchar(255)
	DECLARE @attribute_name_26 varchar(255)
	DECLARE @attribute_name_27 varchar(255)
	DECLARE @attribute_name_28 varchar(255)
	DECLARE @attribute_name_29 varchar(255)
	DECLARE @attribute_name_30 varchar(255)	
	DECLARE @attribute_name_31 varchar(255)
	DECLARE @attribute_name_32 varchar(255)
	DECLARE @attribute_name_33 varchar(255)
	DECLARE @attribute_name_34 varchar(255)
	DECLARE @attribute_name_35 varchar(255)
	DECLARE @attribute_name_36 varchar(255)
	DECLARE @attribute_name_37 varchar(255)
	DECLARE @attribute_name_38 varchar(255)
	DECLARE @attribute_name_39 varchar(255)
	DECLARE @attribute_name_40 varchar(255)
	DECLARE @attribute_name_41 varchar(255)
	DECLARE @attribute_name_42 varchar(255)
	DECLARE @attribute_name_43 varchar(255)
	DECLARE @attribute_name_44 varchar(255)
	DECLARE @attribute_name_45 varchar(255)
	DECLARE @attribute_name_46 varchar(255)
	DECLARE @attribute_name_47 varchar(255)
	DECLARE @attribute_name_48 varchar(255)
	DECLARE @attribute_name_49 varchar(255)
	DECLARE @attribute_name_50 varchar(255)
	DECLARE @attribute_name_51 varchar(255)
	DECLARE @attribute_name_52 varchar(255)
	DECLARE @attribute_name_53 varchar(255)
	DECLARE @attribute_name_54 varchar(255)
	DECLARE @attribute_name_55 varchar(255)
	DECLARE @attribute_name_56 varchar(255)
	DECLARE @attribute_name_57 varchar(255)
	DECLARE @attribute_name_58 varchar(255)
	DECLARE @attribute_name_59 varchar(255)
	DECLARE @attribute_name_60 varchar(255)	
	DECLARE @attribute_name_61 varchar(255)
	DECLARE @attribute_name_62 varchar(255)
	DECLARE @attribute_name_63 varchar(255)
	DECLARE @attribute_name_64 varchar(255)
	DECLARE @attribute_name_65 varchar(255)
	DECLARE @attribute_name_66 varchar(255)
	DECLARE @attribute_name_67 varchar(255)
	DECLARE @attribute_name_68 varchar(255)
	DECLARE @attribute_name_69 varchar(255)
	DECLARE @attribute_name_70 varchar(255)	
	DECLARE @attribute_name_71 varchar(255)
	DECLARE @attribute_name_72 varchar(255)
	DECLARE @attribute_name_73 varchar(255)
	DECLARE @attribute_name_74 varchar(255)
	DECLARE @attribute_name_75 varchar(255)
	DECLARE @attribute_name_76 varchar(255)
	DECLARE @attribute_name_77 varchar(255)
	DECLARE @attribute_name_78 varchar(255)
	DECLARE @attribute_name_79 varchar(255)
	DECLARE @attribute_name_80 varchar(255)	
	
	DECLARE @attribute_value_0 varchar(MAX)
	DECLARE @attribute_value_1 varchar(MAX)
	DECLARE @attribute_value_2 varchar(MAX)
	DECLARE @attribute_value_3 varchar(MAX)
	DECLARE @attribute_value_4 varchar(MAX)
	DECLARE @attribute_value_5 varchar(MAX)
	DECLARE @attribute_value_6 varchar(MAX)
	DECLARE @attribute_value_7 varchar(MAX)
	DECLARE @attribute_value_8 varchar(MAX)
	DECLARE @attribute_value_9 varchar(MAX)
	DECLARE @attribute_value_10 varchar(MAX)
	DECLARE @attribute_value_11 varchar(MAX)
	DECLARE @attribute_value_12 varchar(MAX)
	DECLARE @attribute_value_13 varchar(MAX)
	DECLARE @attribute_value_14 varchar(MAX)
	DECLARE @attribute_value_15 varchar(MAX)
	DECLARE @attribute_value_16 varchar(MAX)
	DECLARE @attribute_value_17 varchar(MAX)
	DECLARE @attribute_value_18 varchar(MAX)
	DECLARE @attribute_value_19 varchar(MAX)
	DECLARE @attribute_value_20 varchar(MAX)
	DECLARE @attribute_value_21 varchar(MAX)
	DECLARE @attribute_value_22 varchar(MAX)
	DECLARE @attribute_value_23 varchar(MAX)
	DECLARE @attribute_value_24 varchar(MAX)
	DECLARE @attribute_value_25 varchar(MAX)
	DECLARE @attribute_value_26 varchar(MAX)
	DECLARE @attribute_value_27 varchar(MAX)
	DECLARE @attribute_value_28 varchar(MAX)
	DECLARE @attribute_value_29 varchar(MAX)
	DECLARE @attribute_value_30 varchar(MAX)
	DECLARE @attribute_value_31 varchar(MAX)
	DECLARE @attribute_value_32 varchar(MAX)
	DECLARE @attribute_value_33 varchar(MAX)
	DECLARE @attribute_value_34 varchar(MAX)
	DECLARE @attribute_value_35 varchar(MAX)
	DECLARE @attribute_value_36 varchar(MAX)
	DECLARE @attribute_value_37 varchar(MAX)
	DECLARE @attribute_value_38 varchar(MAX)
	DECLARE @attribute_value_39 varchar(MAX)
	DECLARE @attribute_value_40 varchar(MAX)
	DECLARE @attribute_value_41 varchar(MAX)
	DECLARE @attribute_value_42 varchar(MAX)
	DECLARE @attribute_value_43 varchar(MAX)
	DECLARE @attribute_value_44 varchar(MAX)
	DECLARE @attribute_value_45 varchar(MAX)
	DECLARE @attribute_value_46 varchar(MAX)
	DECLARE @attribute_value_47 varchar(MAX)
	DECLARE @attribute_value_48 varchar(MAX)
	DECLARE @attribute_value_49 varchar(MAX)
	DECLARE @attribute_value_50 varchar(MAX)
	DECLARE @attribute_value_51 varchar(MAX)
	DECLARE @attribute_value_52 varchar(MAX)
	DECLARE @attribute_value_53 varchar(MAX)
	DECLARE @attribute_value_54 varchar(MAX)
	DECLARE @attribute_value_55 varchar(MAX)
	DECLARE @attribute_value_56 varchar(MAX)
	DECLARE @attribute_value_57 varchar(MAX)
	DECLARE @attribute_value_58 varchar(MAX)
	DECLARE @attribute_value_59 varchar(MAX)
	DECLARE @attribute_value_60 varchar(MAX)
	DECLARE @attribute_value_61 varchar(MAX)
	DECLARE @attribute_value_62 varchar(MAX)
	DECLARE @attribute_value_63 varchar(MAX)
	DECLARE @attribute_value_64 varchar(MAX)
	DECLARE @attribute_value_65 varchar(MAX)
	DECLARE @attribute_value_66 varchar(MAX)
	DECLARE @attribute_value_67 varchar(MAX)
	DECLARE @attribute_value_68 varchar(MAX)
	DECLARE @attribute_value_69 varchar(MAX)
	DECLARE @attribute_value_70 varchar(MAX)
	DECLARE @attribute_value_71 varchar(MAX)
	DECLARE @attribute_value_72 varchar(MAX)
	DECLARE @attribute_value_73 varchar(MAX)
	DECLARE @attribute_value_74 varchar(MAX)
	DECLARE @attribute_value_75 varchar(MAX)
	DECLARE @attribute_value_76 varchar(MAX)
	DECLARE @attribute_value_77 varchar(MAX)
	DECLARE @attribute_value_78 varchar(MAX)
	DECLARE @attribute_value_79 varchar(MAX)
	DECLARE @attribute_value_80 varchar(MAX)						

	DECLARE staging_cursor CURSOR FOR SELECT 
	field_0, 
	field_1, 
	field_2, 
	field_3, 
	field_4, 
	field_5, 
	field_6, 
	field_7, 
	field_8, 
	field_9,
	field_10,
	field_11,
	field_12,
	field_13,
	field_14,
	field_15,
	field_16,
	field_17,
	field_18,
	field_19,
	field_20,
	field_21,
	field_22,
	field_23,
	field_24,
	field_25,
	field_26,
	field_27,
	field_28,
	field_29,
	field_30,
	field_31,
	field_32,
	field_33,
	field_34,
	field_35,
	field_36,
	field_37,
	field_38,
	field_39,
	field_40,
	field_41,
	field_42,
	field_43,
	field_44,
	field_45,
	field_46,
	field_47,
	field_48,
	field_49,
	field_50,
	field_51,
	field_52,
	field_53,
	field_54,
	field_55,
	field_56,
	field_57,
	field_58,
	field_59,
	field_60,
	field_61,
	field_62,
	field_63,
	field_64,
	field_65,
	field_66,
	field_67,
	field_68,
	field_69,
	field_70,
	field_71,
	field_72,
	field_73,
	field_74,
	field_75,
	field_76,
	field_77,
	field_78,
	field_79,
	field_80
	FROM Staging_table
	OPEN staging_cursor;

	FETCH NEXT FROM staging_cursor INTO 
	@attribute_name_0, 
	@attribute_name_1, 
	@attribute_name_2, 
	@attribute_name_3,
	@attribute_name_4,
	@attribute_name_5,
	@attribute_name_6,
	@attribute_name_7,
	@attribute_name_8,
	@attribute_name_9,	
	@attribute_name_10,
	@attribute_name_11,
	@attribute_name_12,
	@attribute_name_13,
	@attribute_name_14,
	@attribute_name_15,
	@attribute_name_16,
	@attribute_name_17,
	@attribute_name_18,
	@attribute_name_19,
	@attribute_name_20,
	@attribute_name_21,
	@attribute_name_22,
	@attribute_name_23,
	@attribute_name_24,
	@attribute_name_25,
	@attribute_name_26,
	@attribute_name_27,
	@attribute_name_28,
	@attribute_name_29,
	@attribute_name_30,
	@attribute_name_31,
	@attribute_name_32,
	@attribute_name_33,
	@attribute_name_34,
	@attribute_name_35,
	@attribute_name_36,
	@attribute_name_37,
	@attribute_name_38,
	@attribute_name_39,
	@attribute_name_40,
	@attribute_name_41,
	@attribute_name_42,
	@attribute_name_43,
	@attribute_name_44,
	@attribute_name_45,
	@attribute_name_46,
	@attribute_name_47,
	@attribute_name_48,
	@attribute_name_49,
	@attribute_name_50,
	@attribute_name_51,
	@attribute_name_52,
	@attribute_name_53,
	@attribute_name_54,
	@attribute_name_55,
	@attribute_name_56,
	@attribute_name_57,
	@attribute_name_58,
	@attribute_name_59,
	@attribute_name_60,
	@attribute_name_61,
	@attribute_name_62,
	@attribute_name_63,
	@attribute_name_64,
	@attribute_name_65,
	@attribute_name_66,
	@attribute_name_67,
	@attribute_name_68,
	@attribute_name_69,
	@attribute_name_70,
	@attribute_name_71,
	@attribute_name_72,
	@attribute_name_73,
	@attribute_name_74,
	@attribute_name_75,
	@attribute_name_76,
	@attribute_name_77,
	@attribute_name_78,
	@attribute_name_79,
	@attribute_name_80
	
	FETCH NEXT FROM staging_cursor INTO 
	@attribute_value_0, 
	@attribute_value_1, 
	@attribute_value_2, 
	@attribute_value_3,
	@attribute_value_4,
	@attribute_value_5,
	@attribute_value_6,
	@attribute_value_7,
	@attribute_value_8,
	@attribute_value_9,
	@attribute_value_10,
	@attribute_value_11,
	@attribute_value_12,
	@attribute_value_13,
	@attribute_value_14,
	@attribute_value_15,
	@attribute_value_16,
	@attribute_value_17,
	@attribute_value_18,
	@attribute_value_19,
	@attribute_value_20,
	@attribute_value_21,
	@attribute_value_22,
	@attribute_value_23,
	@attribute_value_24,
	@attribute_value_25,
	@attribute_value_26,
	@attribute_value_27,
	@attribute_value_28,
	@attribute_value_29,
	@attribute_value_30,
	@attribute_value_31,
	@attribute_value_32,
	@attribute_value_33,
	@attribute_value_34,
	@attribute_value_35,
	@attribute_value_36,
	@attribute_value_37,
	@attribute_value_38,
	@attribute_value_39,
	@attribute_value_40,
	@attribute_value_41,
	@attribute_value_42,
	@attribute_value_43,
	@attribute_value_44,
	@attribute_value_45,
	@attribute_value_46,
	@attribute_value_47,
	@attribute_value_48,
	@attribute_value_49,
	@attribute_value_50,
	@attribute_value_51,
	@attribute_value_52,
	@attribute_value_53,
	@attribute_value_54,
	@attribute_value_55,
	@attribute_value_56,
	@attribute_value_57,
	@attribute_value_58,
	@attribute_value_59,
	@attribute_value_60,
	@attribute_value_61,
	@attribute_value_62,
	@attribute_value_63,
	@attribute_value_64,
	@attribute_value_65,
	@attribute_value_66,
	@attribute_value_67,
	@attribute_value_68,
	@attribute_value_69,
	@attribute_value_70,
	@attribute_value_71,
	@attribute_value_72,
	@attribute_value_73,
	@attribute_value_74,
	@attribute_value_75,
	@attribute_value_76,
	@attribute_value_77,
	@attribute_value_78,
	@attribute_value_79,
	@attribute_value_80
		
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @column_index_key = 0 BEGIN SET @field_key = @attribute_value_0 END
		IF @column_index_key = 1 BEGIN SET @field_key = @attribute_value_1 END
		IF @column_index_key = 2 BEGIN SET @field_key = @attribute_value_2 END
		IF @column_index_key = 3 BEGIN SET @field_key = @attribute_value_3 END
		IF @column_index_key = 4 BEGIN SET @field_key = @attribute_value_4 END
		IF @column_index_key = 5 BEGIN SET @field_key = @attribute_value_5 END
		IF @column_index_key = 6 BEGIN SET @field_key = @attribute_value_6 END
		IF @column_index_key = 7 BEGIN SET @field_key = @attribute_value_7 END
		IF @column_index_key = 8 BEGIN SET @field_key = @attribute_value_8 END
		IF @column_index_key = 9 BEGIN SET @field_key = @attribute_value_9 END
		IF @column_index_key = 10 BEGIN SET @field_key = @attribute_value_10 END
		IF @column_index_key = 11 BEGIN SET @field_key = @attribute_value_11 END
		IF @column_index_key = 12 BEGIN SET @field_key = @attribute_value_12 END
		IF @column_index_key = 13 BEGIN SET @field_key = @attribute_value_13 END
		IF @column_index_key = 14 BEGIN SET @field_key = @attribute_value_14 END
		IF @column_index_key = 15 BEGIN SET @field_key = @attribute_value_15 END
		IF @column_index_key = 16 BEGIN SET @field_key = @attribute_value_16 END
		IF @column_index_key = 17 BEGIN SET @field_key = @attribute_value_17 END
		IF @column_index_key = 18 BEGIN SET @field_key = @attribute_value_18 END
		IF @column_index_key = 19 BEGIN SET @field_key = @attribute_value_19 END
		IF @column_index_key = 20 BEGIN SET @field_key = @attribute_value_20 END		
	
		IF LEN(@field_key) > 0 AND LEN(@source) > 0 AND LEN(@type) > 0 BEGIN
			INSERT INTO Objects WITH(TABLOCK) (id_snapshot, source, type) 
			VALUES (@id_snapshot, @source, @type)
			
			SET @id_object = (SELECT CONVERT(VARCHAR, SCOPE_IDENTITY()))
			
			EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_0, @attribute_value_0, 0, @column_index_key, @column_index_show
			EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_1, @attribute_value_1, 1, @column_index_key, @column_index_show
			EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_2, @attribute_value_2, 2, @column_index_key, @column_index_show
			EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_3, @attribute_value_3, 3, @column_index_key, @column_index_show
			EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_4, @attribute_value_4, 4, @column_index_key, @column_index_show
			EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_5, @attribute_value_5, 5, @column_index_key, @column_index_show
			EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_6, @attribute_value_6, 6, @column_index_key, @column_index_show
			EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_7, @attribute_value_7, 7, @column_index_key, @column_index_show
			EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_8, @attribute_value_8, 8, @column_index_key, @column_index_show
			EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_9, @attribute_value_9, 9, @column_index_key, @column_index_show
			
			IF LEN(@attribute_name_10) > 0 BEGIN
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_10, @attribute_value_10, 10, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_11, @attribute_value_11, 11, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_12, @attribute_value_12, 12, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_13, @attribute_value_13, 13, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_14, @attribute_value_14, 14, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_15, @attribute_value_15, 15, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_16, @attribute_value_16, 16, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_17, @attribute_value_17, 17, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_18, @attribute_value_18, 18, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_19, @attribute_value_19, 19, @column_index_key, @column_index_show
			END
			IF LEN(@attribute_name_20) > 0 BEGIN
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_20, @attribute_value_20, 20, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_21, @attribute_value_21, 21, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_22, @attribute_value_22, 22, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_23, @attribute_value_23, 23, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_24, @attribute_value_24, 24, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_25, @attribute_value_25, 25, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_26, @attribute_value_26, 26, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_27, @attribute_value_27, 27, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_28, @attribute_value_28, 28, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_29, @attribute_value_29, 29, @column_index_key, @column_index_show
			END
			IF LEN(@attribute_name_30) > 0 BEGIN
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_30, @attribute_value_30, 30, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_31, @attribute_value_31, 31, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_32, @attribute_value_32, 32, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_33, @attribute_value_33, 33, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_34, @attribute_value_34, 34, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_35, @attribute_value_35, 35, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_36, @attribute_value_36, 36, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_37, @attribute_value_37, 37, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_38, @attribute_value_38, 38, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_39, @attribute_value_39, 39, @column_index_key, @column_index_show
			END
			IF LEN(@attribute_name_40) > 0 BEGIN
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_40, @attribute_value_40, 40, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_41, @attribute_value_41, 41, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_42, @attribute_value_42, 42, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_43, @attribute_value_43, 43, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_44, @attribute_value_44, 44, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_45, @attribute_value_45, 45, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_46, @attribute_value_46, 46, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_47, @attribute_value_47, 47, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_48, @attribute_value_48, 48, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_49, @attribute_value_49, 49, @column_index_key, @column_index_show
			END
			IF LEN(@attribute_name_50) > 0 BEGIN
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_50, @attribute_value_50, 50, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_51, @attribute_value_51, 51, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_52, @attribute_value_52, 52, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_53, @attribute_value_53, 53, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_54, @attribute_value_54, 54, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_55, @attribute_value_55, 55, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_56, @attribute_value_56, 56, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_57, @attribute_value_57, 57, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_58, @attribute_value_58, 58, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_59, @attribute_value_59, 59, @column_index_key, @column_index_show
			END
			IF LEN(@attribute_name_60) > 0 BEGIN
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_60, @attribute_value_60, 60, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_61, @attribute_value_61, 61, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_62, @attribute_value_62, 62, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_63, @attribute_value_63, 63, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_64, @attribute_value_64, 64, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_65, @attribute_value_65, 65, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_66, @attribute_value_66, 66, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_67, @attribute_value_67, 67, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_68, @attribute_value_68, 68, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_69, @attribute_value_69, 69, @column_index_key, @column_index_show
			END
			IF LEN(@attribute_name_70) > 0 BEGIN	
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_70, @attribute_value_70, 70, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_71, @attribute_value_71, 71, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_72, @attribute_value_72, 72, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_73, @attribute_value_73, 73, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_74, @attribute_value_74, 74, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_75, @attribute_value_75, 75, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_77, @attribute_value_76, 76, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_77, @attribute_value_77, 77, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_78, @attribute_value_78, 78, @column_index_key, @column_index_show
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_79, @attribute_value_79, 79, @column_index_key, @column_index_show
			END
			IF LEN(@attribute_name_80) > 0 BEGIN
				EXEC spSnapshot_objectattribute_add @id_object, @attribute_name_80, @attribute_value_80, 80, @column_index_key, @column_index_show
			END
		END
				
		FETCH NEXT FROM staging_cursor INTO 
		@attribute_value_0, 
		@attribute_value_1, 
		@attribute_value_2, 
		@attribute_value_3,
		@attribute_value_4,
		@attribute_value_5,
		@attribute_value_6,
		@attribute_value_7,
		@attribute_value_8,
		@attribute_value_9,
		@attribute_value_10,
		@attribute_value_11,
		@attribute_value_12,
		@attribute_value_13,
		@attribute_value_14,
		@attribute_value_15,
		@attribute_value_16,
		@attribute_value_17,
		@attribute_value_18,
		@attribute_value_19,
		@attribute_value_20,
		@attribute_value_21,
		@attribute_value_22,
		@attribute_value_23,
		@attribute_value_24,
		@attribute_value_25,
		@attribute_value_26,
		@attribute_value_27,
		@attribute_value_28,
		@attribute_value_29,
		@attribute_value_30,
		@attribute_value_31,
		@attribute_value_32,
		@attribute_value_33,
		@attribute_value_34,
		@attribute_value_35,
		@attribute_value_36,
		@attribute_value_37,
		@attribute_value_38,
		@attribute_value_39,
		@attribute_value_40,
		@attribute_value_41,
		@attribute_value_42,
		@attribute_value_43,
		@attribute_value_44,
		@attribute_value_45,
		@attribute_value_46,
		@attribute_value_47,
		@attribute_value_48,
		@attribute_value_49,
		@attribute_value_50,
		@attribute_value_51,
		@attribute_value_52,
		@attribute_value_53,
		@attribute_value_54,
		@attribute_value_55,
		@attribute_value_56,
		@attribute_value_57,
		@attribute_value_58,
		@attribute_value_59,
		@attribute_value_60,
		@attribute_value_61,
		@attribute_value_62,
		@attribute_value_63,
		@attribute_value_64,
		@attribute_value_65,
		@attribute_value_66,
		@attribute_value_67,
		@attribute_value_68,
		@attribute_value_69,
		@attribute_value_70,
		@attribute_value_71,
		@attribute_value_72,
		@attribute_value_73,
		@attribute_value_74,
		@attribute_value_75,
		@attribute_value_76,
		@attribute_value_77,
		@attribute_value_78,
		@attribute_value_79,
		@attribute_value_80
	END
	CLOSE staging_cursor
	DEALLOCATE staging_cursor	

END
GO
/****** Object:  StoredProcedure [dbo].[spTags_relationships_snapshot_right]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_relationships_snapshot_right]
	@is_key bit = 1,
	@id_snapshot bigint = 0,
	@type_object_cache varchar(50) = 'group'
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_snapshot = 0 BEGIN SET @id_snapshot = (SELECT MAX(id) FROM Snapshots) END

	DECLARE @table_tag_relationships table (name_group varchar(255), name_user varchar(255),
		date_start_group datetime, date_end_group datetime, date_start_user datetime, date_end_user datetime)
	INSERT INTO @table_tag_relationships
	EXEC spTags_relationships_get @is_key
	
	DECLARE @table_snapshot_relationships table (name_group varchar(255), name_user varchar(255))
	INSERT INTO @table_snapshot_relationships
	EXEC spSnapshot_get_relationships @is_key

	IF @is_key = 1 BEGIN
		SELECT
		s_r.name_group + '-' + s_r.name_user as 'id',
		s_r.name_group,
		s_r.name_user
		FROM @table_tag_relationships t_r
		RIGHT JOIN @table_snapshot_relationships s_r ON t_r.name_group = s_r.name_group
			AND t_r.name_user = s_r.name_user
		WHERE t_r.name_group IS NULL
		AND t_r.name_user IS NULL
		AND s_r.name_group IN
		(SELECT c_g.distinguishedName FROM TagObjects t_o
		INNER JOIN Cache_table_dn_sAMAccountName c_g ON c_g.sAMAccountName = t_o.name
		AND t_o.type = @type_object_cache)
	END
	ELSE BEGIN
		SELECT
		s_r.name_group + '-' + s_r.name_user as 'id',
		s_r.name_group,
		s_r.name_user
		FROM @table_tag_relationships t_r
		RIGHT JOIN @table_snapshot_relationships s_r ON t_r.name_group = s_r.name_group
			AND t_r.name_user = s_r.name_user
		WHERE t_r.name_group IS NULL
		AND t_r.name_user IS NULL
		AND s_r.name_group IN
		(SELECT c_g.sAMAccountName FROM TagObjects t_o
		INNER JOIN Cache_table_dn_sAMAccountName c_g ON c_g.sAMAccountName = t_o.name
		AND t_o.type = @type_object_cache)	
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_relationships_snapshot_left]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_relationships_snapshot_left]
	@is_key bit = 1,
	@id_snapshot bigint = 0
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_snapshot = 0 BEGIN SET @id_snapshot = (SELECT MAX(id) FROM Snapshots) END

	DECLARE @table_tag_relationships table (name_group varchar(255), name_user varchar(255),
		date_start_group datetime, date_end_group datetime, date_start_user datetime, date_end_user datetime)
	INSERT INTO @table_tag_relationships
	EXEC spTags_relationships_get @is_key
	
	DECLARE @table_snapshot_relationships table (name_group varchar(255), name_user varchar(255))
	INSERT INTO @table_snapshot_relationships
	EXEC spSnapshot_get_relationships @is_key

	SELECT
	t_r.name_group + '-' + t_r.name_user as 'id',
	t_r.name_group,
	t_r.date_start_group,
	t_r.date_end_group,	
	t_r.name_user,
	t_r.date_start_user,
	t_r.date_end_user
	FROM @table_tag_relationships t_r
	LEFT JOIN @table_snapshot_relationships s_r ON t_r.name_group = s_r.name_group
		AND t_r.name_user = s_r.name_user
	WHERE s_r.name_group IS NULL
	AND s_r.name_user IS NULL
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_relationships_snapshot_common]    Script Date: 10/19/2012 14:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_relationships_snapshot_common]
	@use_ad_cache bit = 1,
	@id_snapshot bigint = 0
AS
BEGIN
	SET NOCOUNT ON;

	IF @id_snapshot = 0 BEGIN SET @id_snapshot = (SELECT MAX(id) FROM Snapshots) END

	DECLARE @table_tag_relationships table (name_group varchar(255), name_user varchar(255),
		date_start_group datetime, date_end_group datetime, date_start_user datetime, date_end_user datetime)
	INSERT INTO @table_tag_relationships
	EXEC spTags_relationships_get @use_ad_cache
	
	DECLARE @table_snapshot_relationships table (name_group varchar(255), name_user varchar(255))
	INSERT INTO @table_snapshot_relationships
	EXEC spSnapshot_get_relationships @use_ad_cache

	SELECT
	t_r.name_group + '-' + t_r.name_user as 'id',
	t_r.name_group,
	t_r.name_user
	FROM @table_tag_relationships t_r
	INNER JOIN @table_snapshot_relationships s_r ON t_r.name_group = s_r.name_group
		AND t_r.name_user = s_r.name_user
END
GO
/****** Object:  Default [DF_Snapshots_timestamp]    Script Date: 10/19/2012 14:30:25 ******/
ALTER TABLE [dbo].[Snapshots] ADD  CONSTRAINT [DF_Snapshots_timestamp]  DEFAULT (getdate()) FOR [timestamp_start]
GO
/****** Object:  Default [DF_Log_timestamp]    Script Date: 10/19/2012 14:30:25 ******/
ALTER TABLE [dbo].[Log] ADD  CONSTRAINT [DF_Log_timestamp]  DEFAULT (getdate()) FOR [timestamp]
GO
/****** Object:  Default [DF_Jobs_timestamp_created]    Script Date: 10/19/2012 14:30:25 ******/
ALTER TABLE [dbo].[Jobs] ADD  CONSTRAINT [DF_Jobs_timestamp_created]  DEFAULT (getdate()) FOR [timestamp_created]
GO
/****** Object:  Default [DF_Jobs_closed]    Script Date: 10/19/2012 14:30:25 ******/
ALTER TABLE [dbo].[Jobs] ADD  CONSTRAINT [DF_Jobs_closed]  DEFAULT ((0)) FOR [closed]
GO
/****** Object:  Default [DF_Batches_timestamp_created]    Script Date: 10/19/2012 14:30:25 ******/
ALTER TABLE [dbo].[Batches] ADD  CONSTRAINT [DF_Batches_timestamp_created]  DEFAULT (getdate()) FOR [timestamp_created]
GO
/****** Object:  Default [DF_Batches_limit_execute_run]    Script Date: 10/19/2012 14:30:25 ******/
ALTER TABLE [dbo].[Batches] ADD  CONSTRAINT [DF_Batches_limit_execute_run]  DEFAULT ((0)) FOR [limit_execute_run]
GO
/****** Object:  Default [DF_Batches_allow_auto_run]    Script Date: 10/19/2012 14:30:25 ******/
ALTER TABLE [dbo].[Batches] ADD  CONSTRAINT [DF_Batches_allow_auto_run]  DEFAULT ((0)) FOR [allow_auto_run]
GO
/****** Object:  Default [DF_Batches_closed]    Script Date: 10/19/2012 14:30:25 ******/
ALTER TABLE [dbo].[Batches] ADD  CONSTRAINT [DF_Batches_closed]  DEFAULT ((0)) FOR [closed]
GO
/****** Object:  Default [DF_Tasks_timestamp_created]    Script Date: 10/19/2012 14:30:25 ******/
ALTER TABLE [dbo].[Tasks] ADD  CONSTRAINT [DF_Tasks_timestamp_created]  DEFAULT (getdate()) FOR [timestamp_created]
GO
/****** Object:  Default [DF_Tasks_closed]    Script Date: 10/19/2012 14:30:25 ******/
ALTER TABLE [dbo].[Tasks] ADD  CONSTRAINT [DF_Tasks_closed]  DEFAULT ((0)) FOR [closed]
GO
/****** Object:  Default [DF_Tags_date_created]    Script Date: 10/19/2012 14:30:25 ******/
ALTER TABLE [dbo].[Tags] ADD  CONSTRAINT [DF_Tags_date_created]  DEFAULT (getdate()) FOR [date_created]
GO
/****** Object:  Default [DF_Tags_is_active]    Script Date: 10/19/2012 14:30:25 ******/
ALTER TABLE [dbo].[Tags] ADD  CONSTRAINT [DF_Tags_is_active]  DEFAULT ((1)) FOR [is_active]
GO
/****** Object:  Default [DF_TagObjects_is_active]    Script Date: 10/19/2012 14:30:25 ******/
ALTER TABLE [dbo].[TagObjects] ADD  CONSTRAINT [DF_TagObjects_is_active]  DEFAULT ((1)) FOR [is_active]
GO
