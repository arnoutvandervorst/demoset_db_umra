USE [UMRA]
GO
/****** Object:  Table [dbo].[Cache_table_dn_sAMAccountName]    Script Date: 07/01/2014 14:39:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cache_table_dn_sAMAccountName](
	[source] [nvarchar](255) NULL,
	[distinguishedName] [nvarchar](1000) NOT NULL,
	[sAMAccountName] [nvarchar](100) NOT NULL,
	[objectSID] [nvarchar](255) NULL,
	[objectGUID] [nvarchar](100) NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Cache_table_dn_sAMAccountName_objectSID] ON [dbo].[Cache_table_dn_sAMAccountName] 
(
	[objectSID] ASC
)
INCLUDE ( [distinguishedName]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cache_table_ad]    Script Date: 07/01/2014 14:39:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cache_table_ad](
	[source] [nvarchar](255) NOT NULL,
	[type] [nvarchar](255) NOT NULL,
	[dn] [nvarchar](1000) NULL,
	[attribute_1] [nvarchar](1000) NULL,
	[attribute_2] [nvarchar](1000) NULL,
	[attribute_3] [nvarchar](1000) NULL,
	[attribute_4] [nvarchar](1000) NULL,
	[attribute_5] [nvarchar](1000) NULL,
	[attribute_6] [nvarchar](1000) NULL,
	[attribute_7] [nvarchar](1000) NULL,
	[attribute_8] [nvarchar](1000) NULL,
	[attribute_9] [nvarchar](1000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BatchLog]    Script Date: 07/01/2014 14:39:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BatchLog](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_batch] [bigint] NOT NULL,
	[id_log] [bigint] NOT NULL,
 CONSTRAINT [PK_BatchLog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Batches]    Script Date: 07/01/2014 14:39:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Batches](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[description] [nvarchar](255) NULL,
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
/****** Object:  Table [dbo].[Attributes]    Script Date: 07/01/2014 14:39:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attributes](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Attributes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fnIsBSN]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fnIsBSN] (@bsn varchar(50))
returns bit
as
begin
	DECLARE @isBSN bit = 0
	DECLARE @intBSNlengte int = 0
	DECLARE @intTeller int = 0
	DECLARE @intTeller2 int = 0
	DECLARE @intSom bigint = 0
	DECLARE @numControleSom numeric(18,6)

	SET @intBSNlengte = LEN(@bsn)
	SET @intTeller2 = @intBSNlengte SET @intTeller = 1 SET @intSom = 0

	WHILE @intTeller <= @intBSNlengte
	BEGIN
		SET @intSom = (CONVERT(bigint, SUBSTRING(@bsn, @intTeller, 1)) * 
		CASE WHEN @intTeller2 = 1
			THEN -1
			ELSE @intTeller2
		END
		)
		+ @intSom
		SET @intTeller = @intTeller+1
		SET @intTeller2 = @intTeller2-1
	END

	SET @numControleSom = CONVERT(numeric(18,6), @intSom) / CONVERT(numeric(18,6), 11)

	IF FLOOR(@numControleSom) = CEILING(@numControleSom) AND @intBSNlengte IN (8,9)
	BEGIN
		SET @isBSN = 1
	END
	ELSE
	BEGIN
		SET @isBSN = 0
	END
	
	RETURN @isBSN

end
GO
/****** Object:  UserDefinedFunction [dbo].[fnElfProef]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnElfProef] (@input_number bigint)
RETURNS BIT
AS
BEGIN
	DECLARE @i bigint = 0
	DECLARE @total bigint = 0
	WHILE @i < 9 BEGIN
		SELECT @i = @i+1
		SELECT @total = @total+(@i*(@input_number%10))
		SELECT @input_number = @input_number/10
	END
	IF (@total%11) = 0 BEGIN
		RETURN 1
	END
	RETURN 0
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnEditDistance]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnEditDistance](@s1 nvarchar(3999), @s2 nvarchar(3999))
RETURNS int
AS
BEGIN
 DECLARE @s1_len int, @s2_len int
 DECLARE @i int, @j int, @s1_char nchar, @c int, @c_temp int
 DECLARE @cv0 varbinary(8000), @cv1 varbinary(8000)

 SELECT
  @s1_len = LEN(@s1),
  @s2_len = LEN(@s2),
  @cv1 = 0x0000,
  @j = 1, @i = 1, @c = 0

 WHILE @j <= @s2_len
  SELECT @cv1 = @cv1 + CAST(@j AS binary(2)), @j = @j + 1

 WHILE @i <= @s1_len
 BEGIN
  SELECT
   @s1_char = SUBSTRING(@s1, @i, 1),
   @c = @i,
   @cv0 = CAST(@i AS binary(2)),
   @j = 1

  WHILE @j <= @s2_len
  BEGIN
   SET @c = @c + 1
   SET @c_temp = CAST(SUBSTRING(@cv1, @j+@j-1, 2) AS int) +
    CASE WHEN @s1_char = SUBSTRING(@s2, @j, 1) THEN 0 ELSE 1 END
   IF @c > @c_temp SET @c = @c_temp
   SET @c_temp = CAST(SUBSTRING(@cv1, @j+@j+1, 2) AS int)+1
   IF @c > @c_temp SET @c = @c_temp
   SELECT @cv0 = @cv0 + CAST(@c AS binary(2)), @j = @j + 1
 END

 SELECT @cv1 = @cv0, @i = @i + 1
 END

 RETURN @c
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnStringToTable]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnStringToTable]
(
	@string_input nvarchar(max),
	@separator char (1)
)
RETURNS @table_result TABLE 
	(string_value nvarchar(max), 
	string_index bigint)
AS
BEGIN
    DECLARE @string_insert nvarchar (max) 
	DECLARE @counter bigint = 0

    WHILE LEN(@string_input) > 0
    BEGIN
        SET @string_insert = LEFT(@string_input,ISNULL(NULLIF(CHARINDEX(@separator, @string_input) - 1, -1),LEN(@string_input)))
        SET @string_input = SUBSTRING(@string_input,ISNULL(NULLIF(CHARINDEX(@separator, @string_input),0),LEN(@string_input)) + 1,LEN(@string_input))
        INSERT INTO @table_result (string_value, string_index) 
        VALUES (@string_insert, @counter)
        SET @counter = @counter + 1

        END

    RETURN
END
GO
/****** Object:  Table [dbo].[NTFS2dbCollectionShares]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NTFS2dbCollectionShares](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NULL,
	[description] [nvarchar](500) NULL,
	[unc_path] [nvarchar](500) NULL,
	[status] [nvarchar](500) NULL,
	[is_active] [bit] NOT NULL,
	[col_id] [bigint] NULL,
 CONSTRAINT [PK_NTFS2dbCollectionShares] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Notifications]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notifications](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[description] [nvarchar](255) NOT NULL,
	[type] [nvarchar](50) NOT NULL,
	[date_created] [datetime] NULL,
	[is_active] [bit] NOT NULL,
	[mail_to] [nvarchar](255) NOT NULL,
	[mail_cc] [nvarchar](255) NULL,
	[mail_bcc] [nvarchar](255) NULL,
	[mail_from] [nvarchar](255) NOT NULL,
	[mail_subject] [nvarchar](max) NOT NULL,
	[mail_body] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Log]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[timestamp] [datetime] NOT NULL,
	[description] [nvarchar](255) NOT NULL,
	[facility_level] [int] NOT NULL,
	[severity_level] [int] NOT NULL,
	[type_operation] [nvarchar](100) NOT NULL,
	[status_operation] [nvarchar](255) NULL,
	[status_script] [nvarchar](500) NULL,
	[user_operator] [nvarchar](50) NULL,
	[object_managed_primary] [nvarchar](500) NULL,
	[object_managed_secondary] [nvarchar](500) NULL,
 CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JobVariables]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobVariables](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_job] [bigint] NOT NULL,
	[variable_name] [nvarchar](255) NOT NULL,
	[variable_value] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_JobVariables] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Jobs]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Jobs](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_task] [bigint] NOT NULL,
	[type] [nvarchar](100) NOT NULL,
	[timestamp_created] [datetime] NOT NULL,
	[timestamp_start] [datetime] NULL,
	[timestamp_end] [datetime] NULL,
	[status] [nvarchar](max) NULL,
	[umra_project] [nvarchar](255) NOT NULL,
	[closed] [bit] NOT NULL,
 CONSTRAINT [PK_Jobs] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Objects]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Objects](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_snapshot] [bigint] NOT NULL,
	[id_type] [bigint] NOT NULL,
	[id_source] [bigint] NOT NULL,
 CONSTRAINT [PK_Objects] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Objects_id_snapshot] ON [dbo].[Objects] 
(
	[id_snapshot] ASC
)
INCLUDE ( [id_type],
[id_source]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectsid_validate]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_objectsid_validate]
(
	@name nvarchar(1000)
)
RETURNS integer
AS
BEGIN
	DECLARE @is_valid int = 0
	
	IF CHARINDEX('010500000000000',@name,0) > 0 BEGIN
		SET @is_valid = 1
	END
	
	RETURN @is_valid
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_attribute_datetime]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_attribute_datetime]
(
	@attribute_value nvarchar(1000)
)
RETURNS datetime
AS
BEGIN
	DECLARE @attribute_value_datetime datetime

	SET @attribute_value_datetime = 
	CONVERT(datetime,(CASE @attribute_value
		WHEN 'Never' THEN GETDATE()+10000
		WHEN '00:00 01/01/1601' THEN GETDATE()+10000
		ELSE @attribute_value
	END),101)

	RETURN @attribute_value_datetime
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnRemoveNonAlphaCharacters]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[fnRemoveNonAlphaCharacters](@Temp nvarchar(1000))
Returns nvarchar(1000)
AS
Begin

    Declare @KeepValues as nvarchar(50)
    Set @KeepValues = '%[^a-z]%'
    While PatIndex(@KeepValues, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@KeepValues, @Temp), 1, '')

    Return @Temp
End
GO
/****** Object:  Table [dbo].[Sources]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sources](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_Sources] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Snapshots]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Snapshots](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[description] [nvarchar](255) NOT NULL,
	[timestamp_start] [datetime] NOT NULL,
	[timestamp_end] [datetime] NULL,
	[status] [nvarchar](255) NULL,
	[is_finished] [bit] NOT NULL,
 CONSTRAINT [PK_Snapshots] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SecureConfig]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SecureConfig](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[is_active] [bit] NOT NULL,
	[domain] [nvarchar](255) NOT NULL,
	[username] [nvarchar](100) NOT NULL,
	[variable] [nvarchar](100) NOT NULL,
	[value] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_SecureConfig] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Staging_table]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staging_table](
	[field_0] [nvarchar](max) NULL,
	[field_1] [nvarchar](max) NULL,
	[field_2] [nvarchar](max) NULL,
	[field_3] [nvarchar](max) NULL,
	[field_4] [nvarchar](max) NULL,
	[field_5] [nvarchar](max) NULL,
	[field_6] [nvarchar](max) NULL,
	[field_7] [nvarchar](max) NULL,
	[field_8] [nvarchar](max) NULL,
	[field_9] [nvarchar](max) NULL,
	[field_10] [nvarchar](max) NULL,
	[field_11] [nvarchar](max) NULL,
	[field_12] [nvarchar](max) NULL,
	[field_13] [nvarchar](max) NULL,
	[field_14] [nvarchar](max) NULL,
	[field_15] [nvarchar](max) NULL,
	[field_16] [nvarchar](max) NULL,
	[field_17] [nvarchar](max) NULL,
	[field_18] [nvarchar](max) NULL,
	[field_19] [nvarchar](max) NULL,
	[field_20] [nvarchar](max) NULL,
	[field_21] [nvarchar](max) NULL,
	[field_22] [nvarchar](max) NULL,
	[field_23] [nvarchar](max) NULL,
	[field_24] [nvarchar](max) NULL,
	[field_25] [nvarchar](max) NULL,
	[field_26] [nvarchar](max) NULL,
	[field_27] [nvarchar](max) NULL,
	[field_28] [nvarchar](max) NULL,
	[field_29] [nvarchar](max) NULL,
	[field_30] [nvarchar](max) NULL,
	[field_31] [nvarchar](max) NULL,
	[field_32] [nvarchar](max) NULL,
	[field_33] [nvarchar](max) NULL,
	[field_34] [nvarchar](max) NULL,
	[field_35] [nvarchar](max) NULL,
	[field_36] [nvarchar](max) NULL,
	[field_37] [nvarchar](max) NULL,
	[field_38] [nvarchar](max) NULL,
	[field_39] [nvarchar](max) NULL,
	[field_40] [nvarchar](max) NULL,
	[field_41] [nvarchar](max) NULL,
	[field_42] [nvarchar](max) NULL,
	[field_43] [nvarchar](max) NULL,
	[field_44] [nvarchar](max) NULL,
	[field_45] [nvarchar](max) NULL,
	[field_46] [nvarchar](max) NULL,
	[field_47] [nvarchar](max) NULL,
	[field_48] [nvarchar](max) NULL,
	[field_49] [nvarchar](max) NULL,
	[field_50] [nvarchar](max) NULL,
	[field_51] [nvarchar](max) NULL,
	[field_52] [nvarchar](max) NULL,
	[field_53] [nvarchar](max) NULL,
	[field_54] [nvarchar](max) NULL,
	[field_55] [nvarchar](max) NULL,
	[field_56] [nvarchar](max) NULL,
	[field_57] [nvarchar](max) NULL,
	[field_58] [nvarchar](max) NULL,
	[field_59] [nvarchar](max) NULL,
	[field_60] [nvarchar](max) NULL,
	[field_61] [nvarchar](max) NULL,
	[field_62] [nvarchar](max) NULL,
	[field_63] [nvarchar](max) NULL,
	[field_64] [nvarchar](max) NULL,
	[field_65] [nvarchar](max) NULL,
	[field_66] [nvarchar](max) NULL,
	[field_67] [nvarchar](max) NULL,
	[field_68] [nvarchar](max) NULL,
	[field_69] [nvarchar](max) NULL,
	[field_70] [nvarchar](max) NULL,
	[field_71] [nvarchar](max) NULL,
	[field_72] [nvarchar](max) NULL,
	[field_73] [nvarchar](max) NULL,
	[field_74] [nvarchar](max) NULL,
	[field_75] [nvarchar](max) NULL,
	[field_76] [nvarchar](max) NULL,
	[field_77] [nvarchar](max) NULL,
	[field_78] [nvarchar](max) NULL,
	[field_79] [nvarchar](max) NULL,
	[field_80] [nvarchar](max) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Staging_log]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staging_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[timestamp] [datetime] NOT NULL,
	[message] [nvarchar](1000) NOT NULL,
 CONSTRAINT [PK_Staging_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Variables]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Variables](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[description] [nvarchar](255) NULL,
	[project_scope] [nvarchar](500) NULL,
	[value] [varchar](4000) NULL,
 CONSTRAINT [PK_Variables] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Types]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Types](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_Types] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tasks]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tasks](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_batch] [bigint] NOT NULL,
	[hash_unique] [nvarchar](100) NULL,
	[type] [nvarchar](100) NOT NULL,
	[description] [nvarchar](255) NOT NULL,
	[timestamp_created] [datetime] NOT NULL,
	[timestamp_schedule] [datetime] NULL,
	[timestamp_start] [datetime] NULL,
	[timestamp_end] [datetime] NULL,
	[allow_auto_run] [bit] NOT NULL,
	[status] [nvarchar](255) NULL,
	[closed] [bit] NOT NULL,
 CONSTRAINT [PK_Tasks] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TagValidation]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TagValidation](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_tag] [bigint] NOT NULL,
	[id_type] [bigint] NOT NULL,
	[validation_date] [datetime] NOT NULL,
	[validated_by] [nvarchar](500) NOT NULL,
	[is_valid] [bit] NOT NULL,
 CONSTRAINT [PK_TagValidation] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tags]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tags](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_type] [bigint] NULL,
	[date_created] [datetime] NULL,
	[description] [nvarchar](400) NOT NULL,
	[keywords] [nvarchar](400) NULL,
	[category] [nvarchar](400) NULL,
	[activity] [nvarchar](400) NULL,
	[task] [nvarchar](400) NULL,
	[duration_hour] [int] NOT NULL,
	[delay_hour] [int] NOT NULL,
	[is_active] [bit] NOT NULL,
	[direct_provision] [bit] NOT NULL,
	[validation_required] [bit] NOT NULL,
	[block_pending_validation] [bit] NOT NULL,
	[validation_interval_days] [bigint] NOT NULL,
 CONSTRAINT [PK_Tags] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TagPermissions]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TagPermissions](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_tag] [bigint] NOT NULL,
	[id_type_permission] [bigint] NOT NULL,
	[id_type_name] [bigint] NOT NULL,
	[date_created] [datetime] NULL,
	[name] [nvarchar](1000) NOT NULL,
	[is_allowed] [bit] NOT NULL,
 CONSTRAINT [PK_TagPermissions] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TagObjectTimers]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TagObjectTimers](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_tagobject] [bigint] NOT NULL,
	[id_type] [bigint] NOT NULL,
	[date_start] [datetime] NULL,
	[date_end] [datetime] NULL,
 CONSTRAINT [PK_TagTimers] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TagObjectTimers_id_tagobject] ON [dbo].[TagObjectTimers] 
(
	[id_tagobject] ASC
)
INCLUDE ( [id_type],
[date_start]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TagObjects]    Script Date: 07/01/2014 14:39:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TagObjects](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_tag] [bigint] NOT NULL,
	[id_type] [bigint] NOT NULL,
	[name] [nvarchar](1000) NOT NULL,
	[date_created] [datetime] NULL,
	[date_start] [datetime] NULL,
	[date_end] [datetime] NULL,
	[is_active] [bit] NOT NULL,
 CONSTRAINT [PK_Tag_objects] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TagObjects_id_tag] ON [dbo].[TagObjects] 
(
	[id_tag] ASC
)
INCLUDE ( [id],
[id_type],
[name],
[date_start],
[date_end],
[is_active]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TagObjects_id_tag_id_type] ON [dbo].[TagObjects] 
(
	[id_tag] ASC,
	[id_type] ASC
)
INCLUDE ( [name],
[date_start],
[date_end],
[is_active]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Staging_table_9]    Script Date: 07/01/2014 14:39:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_9]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_80]    Script Date: 07/01/2014 14:39:30 ******/
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
/****** Object:  View [dbo].[Staging_table_8]    Script Date: 07/01/2014 14:39:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_8]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_79]    Script Date: 07/01/2014 14:39:30 ******/
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
/****** Object:  View [dbo].[Staging_table_78]    Script Date: 07/01/2014 14:39:30 ******/
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
/****** Object:  View [dbo].[Staging_table_77]    Script Date: 07/01/2014 14:39:30 ******/
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
/****** Object:  View [dbo].[Staging_table_76]    Script Date: 07/01/2014 14:39:30 ******/
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
/****** Object:  View [dbo].[Staging_table_75]    Script Date: 07/01/2014 14:39:30 ******/
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
/****** Object:  View [dbo].[Staging_table_74]    Script Date: 07/01/2014 14:39:30 ******/
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
/****** Object:  View [dbo].[Staging_table_73]    Script Date: 07/01/2014 14:39:30 ******/
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
/****** Object:  View [dbo].[Staging_table_72]    Script Date: 07/01/2014 14:39:30 ******/
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
/****** Object:  View [dbo].[Staging_table_71]    Script Date: 07/01/2014 14:39:30 ******/
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
/****** Object:  View [dbo].[Staging_table_70]    Script Date: 07/01/2014 14:39:30 ******/
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
/****** Object:  View [dbo].[Staging_table_7]    Script Date: 07/01/2014 14:39:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_7]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6, field_7
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_69]    Script Date: 07/01/2014 14:39:30 ******/
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
/****** Object:  View [dbo].[Staging_table_68]    Script Date: 07/01/2014 14:39:30 ******/
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
/****** Object:  View [dbo].[Staging_table_67]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_66]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_65]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_64]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_63]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_62]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_61]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_60]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_6]    Script Date: 07/01/2014 14:39:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_6]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5, field_6
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_59]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_58]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_57]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_56]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_55]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_54]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_53]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_52]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_51]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_50]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_5]    Script Date: 07/01/2014 14:39:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_5]
AS
SELECT     field_0, field_1, field_2, field_3, field_4, field_5
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_49]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_48]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_47]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_46]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_45]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_44]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_43]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_42]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_41]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_40]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_4]    Script Date: 07/01/2014 14:39:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_4]
AS
SELECT     field_0, field_1, field_2, field_3, field_4
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_39]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_38]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_37]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_36]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_35]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_34]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_33]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_32]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_31]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_30]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_3]    Script Date: 07/01/2014 14:39:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_3]
AS
SELECT     field_0, field_1, field_2, field_3
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_29]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_28]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_27]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_26]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_25]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_24]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_23]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_22]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_21]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_20]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_2]    Script Date: 07/01/2014 14:39:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_2]
AS
SELECT     field_0, field_1, field_2
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_19]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_18]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_17]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_16]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_15]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_14]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_13]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_12]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_11]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_10]    Script Date: 07/01/2014 14:39:31 ******/
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
/****** Object:  View [dbo].[Staging_table_1]    Script Date: 07/01/2014 14:39:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_1]
AS
SELECT     field_0, field_1
FROM         dbo.Staging_table
GO
/****** Object:  View [dbo].[Staging_table_0]    Script Date: 07/01/2014 14:39:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Staging_table_0]
AS
SELECT     field_0
FROM         dbo.Staging_table
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_object_count_chart]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_object_count_chart]
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @cols nvarchar(MAX) = STUFF((
	SELECT N',' + QUOTENAME(y)
	FROM (SELECT DISTINCT t.description AS y FROM Tags t) AS Y
	ORDER BY y FOR XML PATH('')),1, 1, N'');

	DECLARE @sql nvarchar(MAX) = N'SELECT *
	FROM (SELECT t.description, t_o.id as qty
	FROM Tags t
	INNER JOIN TagObjects t_o ON t_o.id_tag = t.id
	WHERE t_o.is_active = 1) AS D
	PIVOT(COUNT(qty) FOR description IN(' + @cols + N')) AS P;';

	EXEC sp_executesql @sql;
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_objecttimers_cleanup]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_objecttimers_cleanup]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @obsoleteid_tagobjecttimer TABLE (id bigint)
	DECLARE @expiredid_tagobjecttimer TABLE (id bigint)
	
	INSERT INTO @obsoleteid_tagobjecttimer
	SELECT
	t_o_t.id
	FROM TagObjectTimers t_o_t
	LEFT JOIN TagObjects t_o ON t_o.id = t_o_t.id_tagobject
	WHERE t_o.id IS NULL
	
	DELETE FROM TagObjectTimers
	WHERE id IN (SELECT o.id FROM @obsoleteid_tagobjecttimer o)
	
	INSERT INTO @expiredid_tagobjecttimer
	SELECT
	t_o_t.id
	FROM TagObjectTimers t_o_t
	INNER JOIN TagObjects t_o ON t_o.id = t_o_t.id_tagobject
	WHERE t_o.is_active = 0
	AND t_o_t.date_end IS NULL
	
	UPDATE TagObjectTimers
	SET date_end = GETDATE()
	WHERE id IN (SELECT o.id FROM @expiredid_tagobjecttimer o)
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_categories_get]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_categories_get]
	@tag_is_active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT DISTINCT
	DENSE_RANK() OVER (ORDER BY t.category) as 'id',
	t.category
	FROM Tags t
	WHERE (t.is_active = @tag_is_active OR @tag_is_active IS NULL)
	AND NOT t.category IS NULL
	AND LEN(t.category) > 0	

END
GO
/****** Object:  StoredProcedure [dbo].[spTag_update]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_update]
	@id bigint,
	@description nvarchar(400),
	@keywords nvarchar(400),
	@category nvarchar(400),
	@activity nvarchar(400),
	@task nvarchar(400),
	@duration_hour int = 0,
	@delay_hour int = 0,
	@is_active bit = 1,
	@direct_provision bit = 1,
	@validation_required bit = 0,
	@block_pending_validation bit = 0,
	@validation_interval_days bigint = 0
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE Tags
	SET [description] = @description,
	keywords = @keywords,
	category = @category,
	activity = @activity,
	task = @task,
	duration_hour = @duration_hour,
	delay_hour = @delay_hour,
	is_active = @is_active,
	direct_provision = @direct_provision,
	validation_required = @validation_required,
	block_pending_validation = @block_pending_validation,
	validation_interval_days = @validation_interval_days
	WHERE id = @id
	
	SELECT CONVERT(nvarchar, @id) AS 'id_tag'
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_permission_remove]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_permission_remove]
	@id_tagpermission bigint
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM TagPermissions WHERE id = @id_tagpermission
	SELECT @id_tagpermission
END
GO
/****** Object:  StoredProcedure [dbo].[spVariables_get]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spVariables_get]
	@name nvarchar(500) = NULL,
	@project_scope nvarchar(500) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
	v.id,
	REPLACE(v.name,'%','') as 'name',
	v.value,
	v.description,
	v.project_scope
	FROM Variables v
	WHERE (v.name = @name OR (v.name = '%' + @name + '%') OR @name IS NULL)
	AND (@project_scope IN (SELECT t.string_value FROM fnStringToTable(v.project_scope,',') t) OR v.project_scope IS NULL OR @project_scope IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[spTask_update]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTask_update]
	@id_task bigint,
	@description nvarchar(255),
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
/****** Object:  StoredProcedure [dbo].[spTask_start]    Script Date: 07/01/2014 14:39:33 ******/
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
/****** Object:  StoredProcedure [dbo].[spTask_jobs_get]    Script Date: 07/01/2014 14:39:33 ******/
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
/****** Object:  StoredProcedure [dbo].[spTask_hash_unique]    Script Date: 07/01/2014 14:39:33 ******/
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
		DECLARE @hash_unique nvarchar(255)
		
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
/****** Object:  StoredProcedure [dbo].[spTask_get]    Script Date: 07/01/2014 14:39:33 ******/
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
/****** Object:  StoredProcedure [dbo].[spTask_finish]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTask_finish]
	@id_task bigint,
	@status nvarchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @task_jobs_open int = (SELECT COUNT(j.id) 
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
/****** Object:  StoredProcedure [dbo].[spTask_close]    Script Date: 07/01/2014 14:39:33 ******/
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
/****** Object:  StoredProcedure [dbo].[spTask_add]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTask_add]
	@id_batch bigint,
	@type nvarchar(100),
	@description nvarchar(255),
	@allow_auto_run bit,
	@timestamp_schedule datetime
AS
BEGIN
	SET NOCOUNT ON;
	
	IF LEN(@id_batch) > 0 AND LEN(@description) > 0 AND LEN(@type) > 0 BEGIN
		INSERT INTO Tasks (id_batch, type, description, allow_auto_run) 
		VALUES (@id_batch, @type, @description, @allow_auto_run)
		SELECT CONVERT(nvarchar, SCOPE_IDENTITY()) AS id_task
		
		IF NOT @timestamp_schedule IS NULL BEGIN
			DECLARE @id_task bigint
			SET @id_task = (SELECT CONVERT(nvarchar, SCOPE_IDENTITY()))
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
/****** Object:  StoredProcedure [dbo].[spTag_enable]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_enable]
	@id_tag bigint
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE Tags SET is_active = 1 WHERE id = @id_tag
	
	SELECT @id_tag AS 'id_tag'
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_disable]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_disable]
	@id_tag bigint
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE Tags SET is_active = 0 WHERE id = @id_tag
	
	SELECT @id_tag AS 'id_tag'
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_add]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_add]
	@description nvarchar(400),
	@keywords nvarchar(400),
	@category nvarchar(400),
	@activity nvarchar(400),
	@task nvarchar(400),
	@duration_hour int = 0,
	@delay_hour int = 0,
	@is_active bit = 1,
	@direct_provision bit = 1,
	@validation_required bit = 0,
	@block_pending_validation bit = 0,
	@validation_interval_days bigint = 0
AS
BEGIN
	SET NOCOUNT ON;

	IF LEN(@description) > 0 BEGIN
		INSERT INTO Tags ([description], keywords, category, activity, task, is_active, direct_provision, duration_hour, delay_hour,
			validation_required, block_pending_validation, validation_interval_days) 
		VALUES (@description, @keywords, @category, @activity, @task, @is_active, @direct_provision, @duration_hour, @delay_hour,
			@validation_required, @block_pending_validation, @validation_interval_days)
		
		DECLARE @id_tag bigint = (SELECT SCOPE_IDENTITY())
		
		SELECT CONVERT(nvarchar, @id_tag) AS 'id_tag'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshots_get]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshots_get]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
	s.id,
	s.[description],
	s.timestamp_start,
	s.timestamp_end,
	s.[status]
	FROM Snapshots s
	ORDER BY timestamp_start DESC

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_types_get]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_types_get]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
	t.id,
	t.name
	FROM Types t
	ORDER BY t.name

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_type_get]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_type_get]
	@type nvarchar(255),
	@id_type bigint OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SET @id_type = (SELECT id FROM Types WHERE name = @type)
	
	IF @id_type IS NULL AND LEN(@type) > 0 BEGIN
		INSERT INTO Types (name) VALUES (@type)
		SET @id_type = (SELECT SCOPE_IDENTITY())
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_start]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_start]
	@description nvarchar(255),
	@status nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF LEN(@description) > 0 AND LEN(@status) > 0 BEGIN
		INSERT INTO Snapshots ([description], [status]) 
		VALUES (@description, @status)
		SELECT CONVERT(nvarchar, SCOPE_IDENTITY()) AS id_snapshot
	END
	ELSE BEGIN
		SELECT '' AS 'id_snapshot'
	END	

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_sources_get]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_sources_get]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
	s.id,
	s.name
	FROM Sources s
	ORDER BY s.name

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_source_get]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_source_get]
	@source nvarchar(255),
	@id_source bigint OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SET @id_source = (SELECT id FROM Sources WHERE name = @source)
	
	IF @id_source IS NULL AND LEN(@source) > 0 BEGIN
		INSERT INTO Sources (name) VALUES (@source)
		SET @id_source = (SELECT SCOPE_IDENTITY())
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_remove]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_remove]
	@id_tagobject bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	DELETE FROM TagObjectTimers WHERE id_tagobject = @id_tagobject
	DELETE FROM TagObjects WHERE id = @id_tagobject
	
	SELECT @id_tagobject
END
GO
/****** Object:  Table [dbo].[Relationships]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Relationships](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_type] [bigint] NOT NULL,
	[id_object_parent] [bigint] NOT NULL,
	[id_object_child] [bigint] NOT NULL,
 CONSTRAINT [PK_Relationships] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Relationships_id_object_child] ON [dbo].[Relationships] 
(
	[id_object_child] ASC
)
INCLUDE ( [id_object_parent]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Relationships_id_object_parent] ON [dbo].[Relationships] 
(
	[id_object_parent] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Relationships_id_type] ON [dbo].[Relationships] 
(
	[id_type] ASC
)
INCLUDE ( [id_object_parent],
[id_object_child]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Relationships_id_type_id_object_parent] ON [dbo].[Relationships] 
(
	[id_type] ASC,
	[id_object_parent] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_attributes_get]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_attributes_get]
	@name_attributes nvarchar(500) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
	a.id,
	a.name
	FROM Attributes a
	WHERE (a.name IN (SELECT string_value FROM fnStringToTable(@name_attributes, ',')) OR @name_attributes IS NULL)
	ORDER BY a.name

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_attribute_get]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_attribute_get]
	@attribute nvarchar(255),
	@id_attribute bigint OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SET @id_attribute = (SELECT id FROM Attributes WHERE name = @attribute)
	
	IF @id_attribute IS NULL AND LEN(@attribute) > 0 BEGIN
		INSERT INTO Attributes(name) VALUES (@attribute)
		SET @id_attribute = (SELECT SCOPE_IDENTITY())
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spSecureConfig_get]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSecureConfig_get]
     @Variable nvarchar(255),
     @Domain nvarchar(255),
     @Username nvarchar(100)
AS BEGIN
     SET NOCOUNT ON;

     SELECT
     sc.value
     FROM SecureConfig sc
     WHERE sc.variable = @Variable
     AND sc.domain = @Domain
     AND sc.username = @Username
     AND sc.is_active = 1
END
GO
/****** Object:  StoredProcedure [dbo].[spNTFS2dbCollectionShares_get]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNTFS2dbCollectionShares_get]
	@is_active bit = NULL,
	@name nvarchar(255) = NULL,
	@description nvarchar(255) = NULL,
	@id bigint = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
	n_s.id,
	n_s.name,
	n_s.description,
	n_s.unc_path,
	n_s.status,
	n_s.is_active
	FROM NTFS2dbCollectionShares n_s
	WHERE (n_s.is_active = @is_active OR @is_active IS NULL)
	AND (n_s.name = @name OR @name IS NULL)
	AND (n_s.description = @description OR @description IS NULL)
	AND (n_s.id = @id OR @id IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[spNTFS2dbCollectionShare_save]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNTFS2dbCollectionShare_save]
	@name nvarchar(255),
	@description nvarchar(500),
	@unc_path nvarchar(500),
	@status nvarchar(500),
	@is_active bit = 1,
	@col_id bigint = 0,
	@id bigint = 0
AS
BEGIN
	SET NOCOUNT ON;

	IF @id > 0 BEGIN
		IF LEN(@description) > 0 BEGIN
			UPDATE NTFS2dbCollectionShares
			SET description = @description
			WHERE id = @id
		END
		IF LEN(@name) > 0 BEGIN
			UPDATE NTFS2dbCollectionShares
			SET name = @name
			WHERE id = @id
		END
		IF LEN(@unc_path) > 0 BEGIN
			UPDATE NTFS2dbCollectionShares
			SET unc_path = @unc_path
			WHERE id = @id
		END
		IF LEN(@status) > 0 BEGIN
			UPDATE NTFS2dbCollectionShares
			SET status = @status
			WHERE id = @id
		END
		IF @col_id > 0 BEGIN
			UPDATE NTFS2dbCollectionShares
			SET col_id = @col_id
			WHERE id = @id
		END
		
		UPDATE NTFS2dbCollectionShares
		SET is_active = @is_active
		WHERE id = @id

		SELECT @id AS 'id_ntfs2dbcollectionshare'
	END
	ELSE BEGIN
		DECLARE @id_existing bigint = 0
		SET @id_existing = (SELECT n_s.id FROM NTFS2dbCollectionShares n_s WHERE unc_path = @unc_path)
	
		IF @id_existing > 0 BEGIN
			UPDATE NTFS2dbCollectionShares
			SET description = @description,
			status = @status,
			name = @name,
			is_active = @is_active,
			col_id = @col_id
			WHERE id = @id_existing
			SELECT CONVERT(nvarchar, @id_existing) AS 'id_ntfs2dbcollectionshare'
		END
		ELSE BEGIN
			INSERT INTO NTFS2dbCollectionShares(name, description, unc_path, status, is_active, col_id) 
			VALUES (@name, @description, @unc_path, @status, @is_active, @col_id)
			
			DECLARE @id_ntfs2dbcollectionshare bigint
			SET @id_ntfs2dbcollectionshare = (SELECT SCOPE_IDENTITY())
			SELECT CONVERT(nvarchar, @id_ntfs2dbcollectionshare) AS 'id_ntfs2dbcollectionshare'
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spNTFS2dbCollectionShare_delete]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNTFS2dbCollectionShare_delete]
	@id_ntfs2dbcollectionshare bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_ntfs2dbcollectionshare > 0 BEGIN
		DELETE FROM NTFS2dbCollectionShares WHERE id = @id_ntfs2dbcollectionshare
		SELECT @id_ntfs2dbcollectionshare AS 'id_ntfs2dbcollectionshare'
	END
	ELSE BEGIN
		SELECT '0' AS 'id_ntfs2dbcollectionshare'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spNotifications_get]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNotifications_get]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT id,
	[description],
	[type]
	FROM Notifications
END
GO
/****** Object:  StoredProcedure [dbo].[spNotification_save]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNotification_save]
	@description nvarchar(255),
	@type nvarchar(255),
	@is_active bit,
	@mail_to nvarchar(255),
	@mail_cc nvarchar(255),
	@mail_bcc nvarchar(255),
	@mail_from nvarchar(255),
	@mail_subject nvarchar(MAX),
	@mail_body nvarchar(MAX),
	@id bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id > 0 BEGIN
		UPDATE Notifications
		SET [description] = @description,
		[type] = @type,
		is_active = @is_active,
		mail_to = @mail_to,
		mail_cc = @mail_cc,
		mail_bcc = @mail_bcc,
		mail_from = @mail_from,	
		mail_body = @mail_body,
		mail_subject = @mail_subject
		WHERE id = @id
				
		SELECT @id AS 'id_notification'
	END
	ELSE BEGIN
		INSERT INTO Notifications ([description], [type], is_active, mail_to, mail_cc, mail_bcc, mail_from, mail_subject, mail_body) 
		VALUES (@description, @type, @is_active, @mail_to, @mail_cc, @mail_bcc, @mail_from, @mail_subject, @mail_body)
		SELECT CONVERT(nvarchar, SCOPE_IDENTITY()) AS 'id_notification'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spNotification_get_type]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNotification_get_type]
	@type nvarchar(255),
	@is_active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT id
	FROM Notifications
	WHERE [type] = @type
	AND (is_active = @is_active OR @is_active IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[spNotification_get]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNotification_get]
	@id_notification bigint,
	@is_active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT id, 
	[description],
	[type],
	is_active,
	mail_to,
	mail_cc,
	mail_bcc,
	mail_from,
	mail_subject,
	mail_body
	FROM Notifications
	WHERE id = @id_notification
	AND (is_active = @is_active OR @is_active IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[spNotification_delete]    Script Date: 07/01/2014 14:39:33 ******/
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
/****** Object:  StoredProcedure [dbo].[spLog_get]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLog_get]
	@id bigint = NULL,
	@count_top bigint = 500,
	@count_months_past bigint = NULL,
	@filter_type_operation_in nvarchar(255) = NULL,
	@filter_type_operation_ex nvarchar(255) = NULL,
	@filter_user_operator_in nvarchar(255) = NULL,
	@filter_user_operator_ex nvarchar(255) = NULL,
	@filter_object_managed nvarchar(255) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT TOP (@count_top)
	l.id,
	l.timestamp,
	l.description,
	l.facility_level,
	l.severity_level,
	l.type_operation,
	l.status_operation,
	l.status_script,
	ISNULL(c_operator.sAMAccountName,l.user_operator) as 'user_operator',
	ISNULL(c_primary.sAMAccountName,l.object_managed_primary) as 'object_managed_primary',
	ISNULL(c_secondary.sAMAccountName,l.object_managed_secondary) as 'object_managed_secondary'
	FROM Log l
	LEFT JOIN Cache_table_dn_sAMAccountName c_operator ON c_operator.objectSID = l.user_operator
	LEFT JOIN Cache_table_dn_sAMAccountName c_primary ON c_primary.objectSID = l.object_managed_primary
	LEFT JOIN Cache_table_dn_sAMAccountName c_secondary ON c_secondary.objectSID = l.object_managed_secondary
	WHERE (l.id = @id OR @id IS NULL)
	AND (l.type_operation LIKE '%' + @filter_type_operation_in + '%' OR @filter_type_operation_in IS NULL)
	AND (l.user_operator LIKE '%' + @filter_user_operator_in + '%' 
		OR c_operator.sAMAccountName LIKE '%' + @filter_user_operator_in + '%'
		OR @filter_user_operator_in IS NULL)
	AND (NOT l.type_operation LIKE '%' + @filter_type_operation_ex + '%' 
		OR c_operator.sAMAccountName LIKE '%' + @filter_user_operator_ex + '%'
		OR @filter_type_operation_ex IS NULL)
	AND (NOT l.user_operator LIKE '%' + @filter_user_operator_ex + '%' OR @filter_user_operator_ex IS NULL)
	AND (l.object_managed_primary LIKE '%' + @filter_object_managed + '%' 
		OR l.object_managed_secondary LIKE '%' + @filter_object_managed + '%'
		OR c_primary.sAMAccountName LIKE '%' + @filter_object_managed + '%'
		OR c_secondary.sAMAccountName LIKE '%' + @filter_object_managed + '%'
		OR @filter_object_managed IS NULL)
	AND (DATEDIFF(month,l.timestamp,GETDATE()) < @count_months_past OR @count_months_past IS NULL)
	ORDER BY l.timestamp DESC
END
GO
/****** Object:  StoredProcedure [dbo].[spLog_add]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLog_add]
	@description nvarchar(255),
	@type_operation nvarchar(100),
	@facility_level int,
	@severity_level int,
	@status_operation nvarchar(255),
	@status_script nvarchar(255),
	@user_operator nvarchar(50),
	@object_managed_primary nvarchar(255) = NULL,
	@object_managed_secondary nvarchar(255) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @object_managed_primary_sid nvarchar(255)
	DECLARE @object_managed_secondary_sid nvarchar(255)
	DECLARE @user_operator_sid nvarchar(255)
	
	IF LEN(@object_managed_primary) > 0 BEGIN
		SET @object_managed_primary_sid = (SELECT TOP 1 c.objectSID
		FROM Cache_table_dn_sAMAccountName c
		WHERE c.distinguishedName = @object_managed_primary
		OR c.sAMAccountName = @object_managed_primary)
		
		IF LEN(@object_managed_primary_sid) > 0 BEGIN
			SET @object_managed_primary = @object_managed_primary_sid
		END
	END
	
	IF LEN(@object_managed_secondary) > 0 BEGIN
		SET @object_managed_secondary_sid = (SELECT TOP 1 c.objectSID
		FROM Cache_table_dn_sAMAccountName c
		WHERE c.distinguishedName = @object_managed_secondary
		OR c.sAMAccountName = @object_managed_secondary)
		
		IF LEN(@object_managed_secondary_sid) > 0 BEGIN
			SET @object_managed_secondary = @object_managed_secondary_sid
		END
	END
	
	IF LEN(@user_operator) > 0 BEGIN
		SET @user_operator_sid = (SELECT TOP 1 c.objectSID
		FROM Cache_table_dn_sAMAccountName c
		WHERE c.distinguishedName = @user_operator
		OR c.sAMAccountName = @user_operator)
		
		IF LEN(@user_operator_sid) > 0 BEGIN
			SET @user_operator = @user_operator_sid
		END
	END
	
	IF LEN(@description) > 0 AND LEN(@type_operation) > 0 AND LEN(@status_operation) > 0 BEGIN
		INSERT INTO Log (description, facility_level, severity_level, type_operation, status_operation, status_script, user_operator, object_managed_primary, object_managed_secondary) 
		VALUES (@description, @facility_level, @severity_level, @type_operation, @status_operation, @status_script, @user_operator, @object_managed_primary, @object_managed_secondary)
		SELECT CONVERT(nvarchar, SCOPE_IDENTITY()) AS id_log
	END
	ELSE BEGIN
		SELECT '0' AS 'id_log'
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[spJobvariable_add]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spJobvariable_add]
	@id_job bigint,
	@variable_name nvarchar(255),
	@variable_value nvarchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_job > 0 BEGIN
		INSERT INTO JobVariables (id_job, variable_name, variable_value) 
		VALUES (@id_job, @variable_name, @variable_value)
		SELECT CONVERT(nvarchar, SCOPE_IDENTITY()) AS id_jobvariable
	END
	ELSE BEGIN
		SELECT '0' AS 'id_jobvariable'
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[spJob_start]    Script Date: 07/01/2014 14:39:33 ******/
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
/****** Object:  StoredProcedure [dbo].[spJob_jobvariables_get]    Script Date: 07/01/2014 14:39:33 ******/
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
/****** Object:  StoredProcedure [dbo].[spJob_finish]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spJob_finish]
	@id_job bigint,
	@status nvarchar(MAX)
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
/****** Object:  StoredProcedure [dbo].[spJob_add]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spJob_add]
	@id_task bigint,
	@type nvarchar(100),
	@umra_project nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_task > 0 BEGIN
		INSERT INTO Jobs (id_task, type, umra_project) 
		VALUES (@id_task, @type, @umra_project)
		SELECT CONVERT(nvarchar, SCOPE_IDENTITY()) AS id_job
	END
	ELSE BEGIN
		SELECT '0' AS 'id_job'
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[spCache_object_delete]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCache_object_delete]
	@name_object nvarchar(1000)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF LEN(@name_object) > 0 BEGIN
		DELETE FROM Cache_table_ad WHERE dn = @name_object
		DELETE FROM Cache_table_dn_sAMAccountName WHERE distinguishedName = @name_object
		SELECT @name_object
	END
	ELSE BEGIN
		SELECT '' AS 'name_object'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spCache_dn_sAMAccountName_objects_add]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCache_dn_sAMAccountName_objects_add]
	@file_input nvarchar(500),
	@source nvarchar(500),
	@name_object nvarchar(500) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @sql_exec nvarchar(MAX)
	SET @sql_exec = 'BULK INSERT Cache_table_dn_sAMAccountName
		FROM ''' + @file_input + '''
		WITH
		(
		FIELDTERMINATOR =''\t'',
		ROWTERMINATOR = ''\n'',
		DATAFILETYPE = ''widechar''
		)'
	
	IF NOT @name_object IS NULL BEGIN
		DELETE FROM Cache_table_dn_sAMAccountName
		WHERE distinguishedName = @name_object
	END

	EXEC (@sql_exec)
	
	UPDATE Cache_table_dn_sAMAccountName
	SET [source] = @source
	WHERE [source] IS NULL

END
GO
/****** Object:  StoredProcedure [dbo].[spCache_ad_objects_add]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCache_ad_objects_add]
	@file_input nvarchar(1000),
	@source nvarchar(500),
	@type nvarchar(500),
	@name_object nvarchar(1000) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @sql_exec nvarchar(MAX)
	SET @sql_exec = 'BULK INSERT Cache_table_ad
		FROM ''' + @file_input + '''
		WITH
		(
		FIELDTERMINATOR =''\t'',
		ROWTERMINATOR = ''\n'',
		DATAFILETYPE = ''widechar''
		)'
	
	IF NOT @name_object IS NULL BEGIN
		DELETE FROM Cache_table_ad
		WHERE dn = @name_object
	END

	EXEC (@sql_exec)
	
	UPDATE Cache_table_ad
	SET [type] = @type
	WHERE [type] IS NULL OR [type] = ''
	
	UPDATE Cache_table_ad
	SET [source] = @source
	WHERE [source] IS NULL OR [source] = ''

END
GO
/****** Object:  StoredProcedure [dbo].[spBatchLog_add]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBatchLog_add]
	@id_batch bigint,
	@id_log bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO BatchLog (id_batch, id_log)
	VALUES (@id_batch, @id_log)
	
	SELECT CONVERT(nvarchar,SCOPE_IDENTITY()) AS 'id_batchlog'
END
GO
/****** Object:  StoredProcedure [dbo].[spBatches_get_auto]    Script Date: 07/01/2014 14:39:33 ******/
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
/****** Object:  StoredProcedure [dbo].[spBatches_get]    Script Date: 07/01/2014 14:39:33 ******/
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
/****** Object:  StoredProcedure [dbo].[spBatch_update]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBatch_update]
	@id_batch bigint,
	@description nvarchar(255),
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
/****** Object:  StoredProcedure [dbo].[spBatch_tasks_get_auto]    Script Date: 07/01/2014 14:39:33 ******/
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
/****** Object:  StoredProcedure [dbo].[spBatch_tasks_get]    Script Date: 07/01/2014 14:39:33 ******/
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
/****** Object:  StoredProcedure [dbo].[spBatch_start]    Script Date: 07/01/2014 14:39:33 ******/
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
/****** Object:  StoredProcedure [dbo].[spBatch_get_log]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBatch_get_log]
	@id_batch bigint
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
	INNER JOIN BatchLog b ON b.id_log = l.id
	WHERE b.id = @id_batch
	ORDER BY l.timestamp DESC
END
GO
/****** Object:  StoredProcedure [dbo].[spBatch_get]    Script Date: 07/01/2014 14:39:33 ******/
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
/****** Object:  StoredProcedure [dbo].[spBatch_finish]    Script Date: 07/01/2014 14:39:33 ******/
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
/****** Object:  StoredProcedure [dbo].[spBatch_close]    Script Date: 07/01/2014 14:39:33 ******/
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
/****** Object:  StoredProcedure [dbo].[spBatch_add]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBatch_add]
	@description nvarchar(255),
	@limit_execute_run int,
	@allow_auto_run bit,
	@timestamp_schedule datetime
AS
BEGIN
	SET NOCOUNT ON;
	
	IF LEN(@description) > 0 BEGIN
		INSERT INTO Batches (description, limit_execute_run, allow_auto_run) 
		VALUES (@description, @limit_execute_run, @allow_auto_run)
		SELECT CONVERT(nvarchar, SCOPE_IDENTITY()) AS id_batch
		
		IF NOT @timestamp_schedule IS NULL BEGIN
			DECLARE @id_batch bigint
			SET @id_batch = (SELECT CONVERT(nvarchar, SCOPE_IDENTITY()))
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
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_group_count]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_group_count]
(
	@id_snapshot bigint
)
RETURNS bigint
AS
BEGIN
	DECLARE @snapshot_group_count bigint = 0
	DECLARE @id_snapshot_l bigint = @id_snapshot
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')

	IF @id_snapshot_l = 0 SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots)

	SET @snapshot_group_count = (SELECT COUNT(o.id) 
		FROM Objects o
		INNER JOIN Snapshots s ON s.id = o.id_snapshot
		WHERE id_type = @id_type_o_group 
		AND o.id_snapshot = @id_snapshot_l
		AND s.is_finished = 1)
	
	RETURN ISNULL(@snapshot_group_count,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnNearestElfProefNumber]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnNearestElfProefNumber](@input_number bigint)
RETURNS bigint
BEGIN
	DECLARE @counter bigint = 0
	WHILE @counter < 100000
	BEGIN
		IF (SELECT dbo.fnElfProef(@input_number + @counter)) = 1 BREAK
		SET @counter = @counter + 1
	END

	RETURN @input_number + @counter
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_objects_inactive]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_objects_inactive]
(
	@id_tag bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @tag_objects nvarchar(MAX)
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')
	DECLARE @id_type_o_user bigint = (SELECT id FROM Types WHERE name = 'user')	

	SELECT @tag_objects = STUFF((SELECT ',' + t_o.name + '(' + t_t_o.name + ')'
	FROM TagObjects t_o
	INNER JOIN Types t_t_o ON t_t_o.id = t_o.id_type
	WHERE t_o.id_tag = @id_tag
	AND t_o.is_active = 0
	AND t_o.id_type <> @id_type_o_group
	AND t_o.id_type <> @id_type_o_user
	FOR XML PATH('')),1,1,'')
	
	RETURN ISNULL(@tag_objects,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_objects_active]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_objects_active]
(
	@id_tag bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @tag_objects nvarchar(MAX)
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')
	DECLARE @id_type_o_user bigint = (SELECT id FROM Types WHERE name = 'user')	

	SELECT @tag_objects = STUFF((SELECT ',' + t_o.name + '(' + t_t_o.name + ')'
	FROM TagObjects t_o
	INNER JOIN Types t_t_o ON t_t_o.id = t_o.id_type
	WHERE t_o.id_tag = @id_tag
	AND t_o.is_active = 1
	AND t_o.id_type <> @id_type_o_group
	AND t_o.id_type <> @id_type_o_user
	FOR XML PATH('')),1,1,'')
	
	RETURN ISNULL(@tag_objects,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_objectid_dn]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_objectid_dn]
(
	@id_object bigint
)
RETURNS nvarchar(1000)
AS
BEGIN
	DECLARE @object_dn nvarchar(1000)
	SET @object_dn = (SELECT TOP 1 c.distinguishedName FROM TagObjects t_o
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = t_o.name
		WHERE t_o.id = @id_object)

	RETURN ISNULL(@object_dn,'')
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_get]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_get]
	@id_input bigint,
	@id bigint OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SET @id = @id_input
	
	IF @id IS NULL OR @id = 0 BEGIN
		SET @id = (SELECT MAX(s.id) FROM Snapshots s WHERE s.is_finished = 1)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_finish]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_finish]
	@id_snapshot bigint,
	@status nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	SET @id_snapshot_l = @id_snapshot
	IF @id_snapshot_l = 0 BEGIN SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots) END	
	
	ALTER INDEX ALL ON Objects
	REORGANIZE
	
	ALTER INDEX ALL ON ObjectAttributes
	REORGANIZE

	ALTER INDEX ALL ON Relationships
	REORGANIZE
	
	DBCC SHRINKDATABASE(0)
	
	IF LEN(@id_snapshot_l) > 0 AND LEN(@status) > 0 BEGIN
		UPDATE Snapshots
		SET timestamp_end = GETDATE(),
		status = @status,
		is_finished = 1
		WHERE id = @id_snapshot_l
		
		SELECT @id_snapshot_l as 'id_snapshot'
	END
	ELSE BEGIN
		SELECT '' AS 'id_snapshot'
	END	

END
GO
/****** Object:  Table [dbo].[ObjectAttributes]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ObjectAttributes](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[id_object] [bigint] NOT NULL,
	[id_attribute] [bigint] NOT NULL,
	[is_key] [bit] NOT NULL,
	[is_show] [bit] NOT NULL,
	[attribute_value] [nvarchar](1000) NULL,
 CONSTRAINT [PK_ObjectAttributes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_id_attribute] ON [dbo].[ObjectAttributes] 
(
	[id_attribute] ASC
)
INCLUDE ( [id_object],
[attribute_value]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ObjectAttributes_id_object] ON [dbo].[ObjectAttributes] 
(
	[id_object] ASC
)
INCLUDE ( [id_attribute],
[attribute_value]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_validation_overdue]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_validation_overdue]
(
	@id_tag bigint
)
RETURNS bigint
AS
BEGIN
	DECLARE @overdue_interval bigint

	SET @overdue_interval = (SELECT DATEDIFF(DAY,(SELECT MAX(t_v.validation_date) FROM TagValidation t_v WHERE t_v.id_tag = @id_tag),GETDATE()) - 
		(SELECT TOP 1 t.validation_interval_days FROM Tags t WHERE t.id = @id_tag))
	
	RETURN ISNULL(@overdue_interval,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_validation]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_validation]
(
	@id_tag bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @tag_validation nvarchar(MAX)

	SELECT @tag_validation = STUFF((SELECT ',[' + ISNULL(c.sAMAccountName,t_v.validated_by) + '(' + CONVERT(nvarchar,t_v.is_valid) + ')' + ':' + CONVERT(nvarchar,t_v.validation_date) + ']'
	FROM TagValidation t_v
	LEFT JOIN Cache_table_dn_sAMAccountName c ON t_v.validated_by = c.objectSID
	WHERE t_v.id_tag = @id_tag
	ORDER BY t_v.validation_date DESC
	FOR XML PATH('')),1,1,'')
	
	RETURN ISNULL(@tag_validation,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_users_inactive]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_users_inactive]
(
	@id_tag bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @tag_users nvarchar(MAX)
	DECLARE @id_type_o_user bigint = (SELECT id FROM Types WHERE name = 'user')

	SELECT @tag_users = STUFF((SELECT ',' + ISNULL(c.sAMAccountName,t_o.name)
	FROM TagObjects t_o
	LEFT JOIN Cache_table_dn_sAMAccountName c ON t_o.name = c.objectSID
	WHERE t_o.id_tag = @id_tag
	AND t_o.is_active = 0
	AND t_o.id_type = @id_type_o_user
	FOR XML PATH('')),1,1,'')
	
	RETURN ISNULL(@tag_users,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_users_active]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_users_active]
(
	@id_tag bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @tag_users nvarchar(MAX)
	DECLARE @id_type_o_user bigint = (SELECT id FROM Types WHERE name = 'user')

	SELECT @tag_users = STUFF((SELECT ',' + ISNULL(c.sAMAccountName,t_o.name)
	FROM TagObjects t_o
	LEFT JOIN Cache_table_dn_sAMAccountName c ON t_o.name = c.objectSID
	WHERE t_o.id_tag = @id_tag
	AND t_o.is_active = 1
	AND t_o.id_type = @id_type_o_user
	FOR XML PATH('')),1,1,'')
	
	RETURN ISNULL(@tag_users,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_user_count_active]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_user_count_active]
(
	@id_tag bigint
)
RETURNS bigint
AS
BEGIN
	DECLARE @tag_user_count bigint
	DECLARE @id_type_o_user bigint = (SELECT id FROM Types WHERE name = 'user')

	SET @tag_user_count = (SELECT COUNT(id) 
		FROM TagObjects t_o
		WHERE (t_o.id_tag = @id_tag OR @id_tag = 0)
		AND t_o.is_active = 1 
		AND id_type = @id_type_o_user)
	
	RETURN ISNULL(@tag_user_count,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_timers_overdue]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_timers_overdue]
(
	@id_tag bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @tag_timers nvarchar(MAX)

	SELECT @tag_timers = STUFF((SELECT ',' + '[' + t_t_o_t.name + ':' + ISNULL(c.sAMAccountName,t_o.name) + '(' + CONVERT(nvarchar,DATEDIFF(hour, t_o_t.date_start, GETDATE())) + ')' + ']'
	FROM TagObjectTimers t_o_t
	INNER JOIN TagObjects t_o ON t_o_t.id_tagobject = t_o.id
	INNER JOIN Tags t ON t.id = t_o.id_tag
	INNER JOIN Types t_t_o_t ON t_o_t.id_type = t_t_o_t.id
	LEFT JOIN Cache_table_dn_sAMAccountName c ON t_o.name = c.objectSID
	WHERE t_o.id_tag = @id_tag
	AND t_o.is_active = 1
	AND (DATEDIFF(hour, t_o_t.date_start, GETDATE()) > t.duration_hour AND t.duration_hour > 0)
	FOR XML PATH('')),1,1,'')
	
	RETURN ISNULL(@tag_timers,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_timers_active]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_timers_active]
(
	@id_tag bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @tag_timers nvarchar(MAX)

	SELECT @tag_timers = STUFF((SELECT ',' + '[' + t_t_o_t.name + ':' + ISNULL(c.sAMAccountName,t_o.name) + '(' + CONVERT(nvarchar,DATEDIFF(hour, t_o_t.date_start, GETDATE())) + ')' + ']'
	FROM TagObjectTimers t_o_t
	INNER JOIN TagObjects t_o ON t_o_t.id_tagobject = t_o.id
	INNER JOIN Types t_t_o_t ON t_o_t.id_type = t_t_o_t.id
	LEFT JOIN Cache_table_dn_sAMAccountName c ON t_o.name = c.objectSID
	WHERE t_o.id_tag = @id_tag
	AND t_o.is_active = 1
	FOR XML PATH('')),1,1,'')
	
	RETURN ISNULL(@tag_timers,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_timer_count_delta]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_timer_count_delta]
(
	@id_tag bigint,
	@delta_hours bigint
)
RETURNS bigint
AS
BEGIN
	DECLARE @tag_timer_count nvarchar(MAX)

	SELECT @tag_timer_count = (SELECT COUNT(t_o_t.id) 
		FROM TagObjectTimers t_o_t
		INNER JOIN TagObjects t_o ON t_o.id = t_o_t.id_tagobject
		WHERE DATEDIFF(hour, t_o_t.date_start, GETDATE()) > @delta_hours
		AND t_o.id_tag = @id_tag)
	
	RETURN @tag_timer_count
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_permissions_direct_active]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_permissions_direct_active]
(
	@id_tag bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @tag_permissions nvarchar(MAX)

	SELECT @tag_permissions = STUFF((SELECT ',' + '[' + t_t_p.name + ':' + t_p.name + ']'
	FROM TagPermissions t_p
	INNER JOIN Types t_t_p ON t_p.id_type_permission = t_t_p.id
	LEFT JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = t_p.name
	WHERE t_p.id_tag = @id_tag
	AND c.objectSID IS NULL
	AND t_p.is_allowed = 1
	FOR XML PATH('')),1,1,'')
	
	RETURN ISNULL(@tag_permissions,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_object_count_active]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_object_count_active]
(
	@id_tag bigint
)
RETURNS bigint
AS
BEGIN
	DECLARE @tag_group_count bigint
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')
	DECLARE @id_type_o_user bigint = (SELECT id FROM Types WHERE name = 'user')

	SET @tag_group_count = (SELECT COUNT(id) 
		FROM TagObjects t_o
		WHERE (t_o.id_tag = @id_tag OR @id_tag = 0)
		AND t_o.is_active = 1 
		AND id_type <> @id_type_o_group
		AND id_type <> @id_type_o_user)
	
	RETURN ISNULL(@tag_group_count,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_groups_inactive]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_groups_inactive]
(
	@id_tag bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @tag_groups nvarchar(MAX)
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')

	SELECT @tag_groups = STUFF((SELECT ',' + ISNULL(c.sAMAccountName,t_o.name)
	FROM TagObjects t_o
	LEFT JOIN Cache_table_dn_sAMAccountName c ON t_o.name = c.objectSID
	WHERE t_o.id_tag = @id_tag
	AND t_o.is_active = 0
	AND t_o.id_type = @id_type_o_group
	FOR XML PATH('')),1,1,'')
	
	RETURN ISNULL(@tag_groups,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_groups_active]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_groups_active]
(
	@id_tag bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @tag_groups nvarchar(MAX)
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')

	SELECT @tag_groups = STUFF((SELECT ',' + ISNULL(c.sAMAccountName,t_o.name)
	FROM TagObjects t_o
	LEFT JOIN Cache_table_dn_sAMAccountName c ON t_o.name = c.objectSID
	WHERE t_o.id_tag = @id_tag
	AND t_o.is_active = 1
	AND t_o.id_type = @id_type_o_group
	FOR XML PATH('')),1,1,'')
	
	RETURN ISNULL(@tag_groups,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_group_count_active]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_group_count_active]
(
	@id_tag bigint
)
RETURNS bigint
AS
BEGIN
	DECLARE @tag_group_count bigint
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')

	SET @tag_group_count = (SELECT COUNT(id) 
		FROM TagObjects t_o
		WHERE (t_o.id_tag = @id_tag OR @id_tag = 0)
		AND t_o.is_active = 1 
		AND id_type = @id_type_o_group)
	
	RETURN ISNULL(@tag_group_count,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_user_count]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_user_count]
(
	@id_snapshot bigint
)
RETURNS bigint
AS
BEGIN
	DECLARE @snapshot_user_count bigint = 0
	DECLARE @id_snapshot_l bigint = @id_snapshot
	DECLARE @id_type_o_user bigint = (SELECT id FROM Types WHERE name = 'user')

	IF @id_snapshot_l = 0 SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots)

	SET @snapshot_user_count = (SELECT COUNT(o.id) 
		FROM Objects o 
		INNER JOIN Snapshots s ON s.id = o.id_snapshot
		WHERE id_type = @id_type_o_user 
		AND o.id_snapshot = @id_snapshot_l
		AND s.is_finished = 1)
	
	RETURN ISNULL(@snapshot_user_count,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_typeid_name]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_typeid_name]
(
	@id_type bigint
)
RETURNS nvarchar(1000)
AS
BEGIN
	DECLARE @type_name nvarchar(1000)
	SET @type_name = (SELECT t.name FROM Types t WHERE t.id = @id_type)

	RETURN @type_name
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_sourceid_name]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_sourceid_name]
(
	@id_source bigint
)
RETURNS nvarchar(500)
AS
BEGIN
	DECLARE @source_name nvarchar(500)
	SET @source_name = (SELECT s.name FROM Sources s WHERE s.id = @id_source)

	RETURN @source_name
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnCache_object_count]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnCache_object_count]
(
	@source nvarchar(255)
)
RETURNS bigint
AS
BEGIN
	DECLARE @cache_object_count bigint = 0

	SET @cache_object_count = (SELECT COUNT(c.objectSID) 
		FROM Cache_table_dn_sAMAccountName c
		WHERE (c.source = @source OR @source IS NULL))
	
	RETURN ISNULL(@cache_object_count,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_type]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_objectid_type]
(
	@id_object bigint
)
RETURNS nvarchar(500)
AS
BEGIN
	DECLARE @object_type nvarchar(500)
	SET @object_type = (SELECT TOP 1 t_o.name FROM Objects o
		INNER JOIN Types t_o ON t_o.id = o.id_type
		WHERE o.id = @id_object)

	RETURN ISNULL(@object_type,'not-found')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectdn_id]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_objectdn_id]
(
	@object_dn nvarchar(1000)
)
RETURNS bigint
AS
BEGIN
	DECLARE @id_object bigint
	SET @id_object = (SELECT TOP 1 o_a.id_object FROM ObjectAttributes o_a
		INNER JOIN Objects o ON o.id = o_a.id_object 
			AND o.id_snapshot = (SELECT MAX(id) FROM Snapshots WHERE is_finished = 1)
		WHERE o_a.attribute_value = @object_dn
		AND o_a.is_key = 1)

	RETURN ISNULL(@id_object,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectattributes_get_unique]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnSnapshot_objectattributes_get_unique] 
(
	@id_snapshot bigint = 0,
	@attribute_names nvarchar(500) = NULL,
	@char_separator nvarchar(5) = '-'
)
RETURNS @table_result table (
	attribute_value nvarchar(1000))  
AS
BEGIN
	DECLARE @id_snapshot_l bigint
	SET @id_snapshot_l = @id_snapshot
	IF @id_snapshot_l = 0 BEGIN SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots WHERE is_finished = 1) END
	
	INSERT INTO @table_result
	SELECT DISTINCT
	o_a_0.attribute_value + 
	CASE
		WHEN o_a_1.attribute_value IS NULL THEN ''
		ELSE @char_separator + o_a_1.attribute_value
	END +
	CASE
		WHEN o_a_2.attribute_value IS NULL THEN ''
		ELSE @char_separator + o_a_2.attribute_value
	END +
	CASE
		WHEN o_a_3.attribute_value IS NULL THEN ''
		ELSE @char_separator + o_a_3.attribute_value
	END
	FROM 
	ObjectAttributes o_a_0
	LEFT JOIN ObjectAttributes o_a_1 ON o_a_1.id_object = o_a_0.id_object
		AND o_a_1.id_attribute = (SELECT a.id FROM Attributes a WHERE a.name = (SELECT t.string_value FROM fnStringToTable(@attribute_names,',') t WHERE t.string_index = 1))
	LEFT JOIN ObjectAttributes o_a_2 ON o_a_2.id_object = o_a_0.id_object
		AND o_a_2.id_attribute = (SELECT a.id FROM Attributes a WHERE a.name = (SELECT t.string_value FROM fnStringToTable(@attribute_names,',') t WHERE t.string_index = 2))
	LEFT JOIN ObjectAttributes o_a_3 ON o_a_3.id_object = o_a_0.id_object
		AND o_a_3.id_attribute = (SELECT a.id FROM Attributes a WHERE a.name = (SELECT t.string_value FROM fnStringToTable(@attribute_names,',') t WHERE t.string_index = 3))
	WHERE o_a_0.id_attribute = (SELECT a.id FROM Attributes a WHERE a.name = (SELECT t.string_value FROM fnStringToTable(@attribute_names,',') t WHERE t.string_index = 0))
			
	RETURN 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_sid]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_objectid_sid]
(
	@id_object bigint
)
RETURNS nvarchar(500)
AS
BEGIN
	DECLARE @id_attribute_objectsid bigint
	SET @id_attribute_objectsid = (SELECT id 
		FROM Attributes
		WHERE name = 'objectSID')

	DECLARE @object_sid nvarchar(255)
	SELECT @object_sid = o_a.attribute_value FROM ObjectAttributes o_a
		WHERE o_a.id_object = @id_object AND o_a.id_attribute = @id_attribute_objectsid

	RETURN @object_sid
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_show]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_objectid_show]
(
	@id_object bigint
)
RETURNS nvarchar(1000)
AS
BEGIN
	DECLARE @object_show nvarchar(1000)
	SELECT @object_show = o_a.attribute_value FROM ObjectAttributes o_a
		WHERE o_a.id_object = @id_object
		AND o_a.is_show = 1

	RETURN @object_show
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_relationships_parent]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_objectid_relationships_parent]
(
	@id_object bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @relationships_parent nvarchar(MAX)

	SELECT @relationships_parent = STUFF((SELECT '[' + 
	t.name +
	':' +
	ISNULL(o_a.attribute_value,'') +
	']'
	FROM Relationships r
	INNER JOIN ObjectAttributes o_a ON o_a.id_object = r.id_object_parent
	INNER JOIN Types t ON t.id = r.id_type
	WHERE r.id_object_child = @id_object
	AND o_a.is_key = 1
	FOR XML PATH('')),1,1,'[')	
	
	RETURN ISNULL(@relationships_parent,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_relationships_child]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_objectid_relationships_child]
(
	@id_object bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @relationships_child nvarchar(MAX)

	SELECT @relationships_child = STUFF((SELECT '[' + 
	t.name +
	':' +
	ISNULL(o_a.attribute_value,'') +
	']'
	FROM Relationships r
	INNER JOIN ObjectAttributes o_a ON o_a.id_object = r.id_object_child
	INNER JOIN Types t ON t.id = r.id_type
	WHERE r.id_object_parent = @id_object
	AND o_a.is_key = 1
	FOR XML PATH('')),1,1,'[')	
	
	RETURN ISNULL(@relationships_child,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_key]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_objectid_key]
(
	@id_object bigint
)
RETURNS nvarchar(1000)
AS
BEGIN
	DECLARE @object_key nvarchar(1000)
	SELECT @object_key = o_a.attribute_value FROM ObjectAttributes o_a
		WHERE o_a.id_object = @id_object
		AND o_a.is_key = 1

	RETURN @object_key
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_attributes_all]    Script Date: 07/01/2014 14:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_objectid_attributes_all]
(
	@id_object bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @object_attributes nvarchar(MAX)
	
	SELECT @object_attributes = STUFF((SELECT '[' + a.name +
	':' + ISNULL(o_a.attribute_value,'') +
	']'
	FROM ObjectAttributes o_a
	INNER JOIN Attributes a ON a.id = o_a.id_attribute
	WHERE o_a.id_object = @id_object
	FOR XML PATH('')),1,1,'[')
	
	RETURN @object_attributes
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_attributes]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_objectid_attributes]
(
	@id_object bigint,
	@name_a nvarchar(500),
	@char_separator nvarchar(1)
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @object_attributes nvarchar(MAX)
	
	SELECT @object_attributes = STUFF((SELECT @char_separator + o_a.attribute_value
	FROM ObjectAttributes o_a
	INNER JOIN Attributes a ON a.id = o_a.id_attribute
	INNER JOIN fnStringToTable(@name_a,',') t ON t.string_value = a.name
	WHERE o_a.id_object = @id_object
	ORDER BY t.string_index
	FOR XML PATH('')),1,1,'')
	
	RETURN @object_attributes
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_relationship_count]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_relationship_count]
(
	@id_snapshot bigint
)
RETURNS bigint
AS
BEGIN
	DECLARE @snapshot_group_count bigint = 0
	DECLARE @id_snapshot_l bigint = @id_snapshot
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')

	IF @id_snapshot_l = 0 SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots)

	SET @snapshot_group_count = (SELECT COUNT(r.id) 
		FROM Relationships r
		INNER JOIN Objects o ON r.id_object_parent = o.id
		INNER JOIN Snapshots s ON s.id = o.id_snapshot
		AND o.id_snapshot = @id_snapshot_l
		AND s.is_finished = 1)
	
	RETURN ISNULL(@snapshot_group_count,0)
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_delete]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_delete]
	@id_snapshot bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	SET @id_snapshot_l = @id_snapshot
	IF @id_snapshot_l = 0 BEGIN SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots) END	

	DECLARE @obsoleteid_object TABLE (id bigint)

	INSERT INTO @obsoleteid_object
	SELECT id
	FROM Objects
	WHERE id_snapshot = @id_snapshot_l

	DELETE FROM ObjectAttributes
	WHERE id_object IN (SELECT id FROM @obsoleteid_object)

	DELETE FROM Relationships
	WHERE id_object_child IN (SELECT id FROM @obsoleteid_object)

	DELETE FROM Relationships
	WHERE id_object_parent IN (SELECT id FROM @obsoleteid_object)
	
	DELETE FROM Objects 
	WHERE id_snapshot = @id_snapshot_l	

	DELETE FROM Snapshots 
	WHERE id = @id_snapshot_l
	
	SELECT @id_snapshot_l
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_cleanup_reset]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_cleanup_reset]
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM ObjectAttributes
	DBCC CHECKIDENT(ObjectAttributes,RESEED,0)
	DELETE FROM Relationships
	DBCC CHECKIDENT(Relationships,RESEED,0)
	DELETE FROM Attributes
	DBCC CHECKIDENT(Attributes,RESEED,0)
	DELETE FROM Types
	DBCC CHECKIDENT(Types,RESEED,0)
	DELETE FROM Sources
	DBCC CHECKIDENT(Sources,RESEED,0)
	DELETE FROM Snapshots
	DBCC CHECKIDENT(Snapshots,RESEED,0)
	DELETE FROM Objects
	DBCC CHECKIDENT(Objects,RESEED,0)
	DELETE FROM Staging_table
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_cleanup]    Script Date: 07/01/2014 14:39:34 ******/
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
	WHERE NOT id IN (SELECT TOP 2 id FROM Snapshots ORDER BY timestamp_start DESC)
	ORDER BY timestamp_start DESC
	
	INSERT INTO @obsoleteid_snapshot
	SELECT s.id
	FROM Snapshots s
	WHERE s.id NOT IN (SELECT id_snapshot FROM Objects)
	
	INSERT INTO @obsoleteid_snapshot
	SELECT s.id
	FROM Snapshots s
	WHERE s.is_finished = 0

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
	
	DBCC SHRINKDATABASE(0)
	
	SELECT * FROM @obsoleteid_snapshot
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_objectdn_id]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_objectdn_id]
(
	@object_dn nvarchar(1000)
)
RETURNS bigint
AS
BEGIN
	DECLARE @cache_object_count bigint = (SELECT dbo.fnCache_object_count(NULL))
	IF @cache_object_count = 0 RETURN -1

	DECLARE @id_object bigint
	SET @id_object = (SELECT TOP 1 t_o.id FROM TagObjects t_o
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = t_o.name
		WHERE c.distinguishedName = @object_dn)

	RETURN ISNULL(@id_object,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectsid_id]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_objectsid_id]
(
	@object_sid nvarchar(1000)
)
RETURNS bigint
AS
BEGIN
	DECLARE @id_attribute_objectsid bigint
	SET @id_attribute_objectsid = (SELECT TOP 1 id 
		FROM Attributes
		WHERE name = 'objectSID')

	DECLARE @id_object bigint
	SET @id_object = (SELECT TOP 1 o_a.id_object 
		FROM ObjectAttributes o_a
		INNER JOIN Objects o ON o.id = o_a.id_object
		INNER JOIN Snapshots s ON s.id = o.id_snapshot
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = o_a.attribute_value
		WHERE c.objectSID = @object_sid 
		AND o_a.id_attribute = @id_attribute_objectsid
		AND s.is_finished = 1)

	RETURN ISNULL(@id_object,0)
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_relationships_snapshot_right]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_relationships_snapshot_right]
	@id_tagobject bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
	DECLARE @id_attribute_sid bigint
	EXEC spSnapshot_attribute_get 'objectSID', @id_attribute_sid OUTPUT
	DECLARE @id_type_r_member bigint
	EXEC spSnapshot_type_get 'member', @id_type_r_member OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT
	
	SELECT
	CONVERT(nvarchar,t_o_group.id) + '-' + CONVERT(nvarchar,t_o_user.id) as 'id',
	oa_group_key.attribute_value,
	oa_user_key.attribute_value
	FROM TagObjects t_o_group
	INNER JOIN TagObjects t_o_user ON t_o_group.id_tag = t_o_user.id_tag 
		AND t_o_group.id_type = @id_type_o_group
		AND t_o_user.id_type = @id_type_o_user
		AND (t_o_group.is_active = 0 OR t_o_user.is_active = 0)
	INNER JOIN ObjectAttributes oa_group_sid ON oa_group_sid.attribute_value = t_o_group.name
		AND oa_group_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_group ON o_group.id = oa_group_sid.id_object
		AND o_group.id_snapshot = @id_snapshot_l
	INNER JOIN ObjectAttributes oa_user_sid ON oa_user_sid.attribute_value = t_o_user.name
		AND oa_user_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_user ON o_user.id = oa_user_sid.id_object
		AND o_user.id_snapshot = @id_snapshot_l
	INNER JOIN Snapshots s ON s.id = o_user.id_snapshot
	INNER JOIN Relationships r ON r.id_object_parent = o_group.id
		AND r.id_object_child = o_user.id
		AND r.id_type = @id_type_r_member
	INNER JOIN ObjectAttributes oa_group_key ON oa_group_key.id_object = r.id_object_parent
		AND oa_group_key.is_key = 1
	INNER JOIN ObjectAttributes oa_user_key ON oa_user_key.id_object = r.id_object_child
		AND oa_user_key.is_key = 1
	AND (t_o_group.id = @id_tagobject OR t_o_user.id = @id_tagobject)
	AND NOT t_o_group.name IN
	(SELECT t_o_group_active.name FROM TagObjects t_o_group_active
	INNER JOIN TagObjects t_o_user_active ON t_o_group_active.id_tag = t_o_user_active.id_tag 
		AND t_o_group_active.id_type = @id_type_o_group
		AND t_o_user_active.id_type = @id_type_o_user
		AND t_o_group_active.is_active = 1
		AND t_o_user_active.is_active = 1
		AND t_o_user_active.name = t_o_user.name)
	AND s.is_finished = 1
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_relationships_snapshot_left]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_relationships_snapshot_left]
	@id_tagobject bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
	DECLARE @id_attribute_sid bigint
	EXEC spSnapshot_attribute_get 'objectSID', @id_attribute_sid OUTPUT
	DECLARE @id_type_r_member bigint
	EXEC spSnapshot_type_get 'member', @id_type_r_member OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT
	
	SELECT
	CONVERT(nvarchar,t_o_group.id_tag) + '-' + t_o_group.name + '-' + t_o_user.name as 'id',
	oa_group_key.attribute_value,
	t_o_group.name,
	t_o_group.date_start,
	t_o_group.date_end,
	oa_user_key.attribute_value,	
	t_o_user.name,
	t_o_user.date_start,
	t_o_user.date_end
	FROM TagObjects t_o_group
	INNER JOIN TagObjects t_o_user ON t_o_group.id_tag = t_o_user.id_tag 
		AND t_o_group.id_type = @id_type_o_group
		AND t_o_user.id_type = @id_type_o_user
		AND t_o_group.is_active = 1
		AND t_o_user.is_active = 1
	INNER JOIN ObjectAttributes oa_group_sid ON oa_group_sid.attribute_value = t_o_group.name
		AND oa_group_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_group ON o_group.id = oa_group_sid.id_object
		AND o_group.id_snapshot = @id_snapshot_l
	INNER JOIN ObjectAttributes oa_group_key ON oa_group_key.id_object = o_group.id
		AND oa_group_key.is_key = 1
	INNER JOIN ObjectAttributes oa_user_sid ON oa_user_sid.attribute_value = t_o_user.name
		AND oa_user_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_user ON o_user.id = oa_user_sid.id_object
		AND o_user.id_snapshot = @id_snapshot_l
	INNER JOIN ObjectAttributes oa_user_key ON oa_user_key.id_object = o_user.id
		AND oa_user_key.is_key = 1
	LEFT JOIN Relationships r ON r.id_object_parent = o_group.id
		AND r.id_object_child = o_user.id
		AND r.id_type = @id_type_r_member
	WHERE r.id_object_parent IS NULL
	AND (t_o_group.id = @id_tagobject OR t_o_user.id = @id_tagobject)
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_link]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_link]
	@id_tagobject bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @cache_object_count bigint = (SELECT dbo.fnCache_object_count(NULL))
	
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT		
	
	IF @cache_object_count > 50 BEGIN
		UPDATE t_o
		SET name = c.objectSID
		FROM TagObjects t_o
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.sAMAccountName = t_o.name
		WHERE t_o.id = @id_tagobject
		AND (t_o.id_type = @id_type_o_group OR t_o.id_type = @id_type_o_user)

		UPDATE t_o
		SET name = c.objectSID
		FROM TagObjects t_o
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.distinguishedName = t_o.name
		WHERE t_o.id = @id_tagobject
		AND (t_o.id_type = @id_type_o_group OR t_o.id_type = @id_type_o_user)
		
		UPDATE t_o
		SET name = c.objectSID
		FROM TagObjects t_o
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.objectGUID = t_o.name
		WHERE t_o.id = @id_tagobject
		AND (t_o.id_type = @id_type_o_group OR t_o.id_type = @id_type_o_user)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_get]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_get]
	@id_tag bigint,
	@name nvarchar(500),
	@type_object nvarchar(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_o bigint
	EXEC spSnapshot_type_get @type_object, @id_type_o OUTPUT
				
	SELECT 
	t_o.id
	FROM TagObjects t_o
	WHERE t_o.name = @name
	AND t_o.id_tag = @id_tag
	AND (t_o.id_type = @id_type_o OR @type_object IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_timer_start]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_timer_start]
	@id_tagobject bigint,
	@type_timer nvarchar(100)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_t bigint
	EXEC spSnapshot_type_get @type_timer, @id_type_t OUTPUT
	
	DECLARE @id_tagobjecttimer bigint = (SELECT id FROM TagObjectTimers WHERE id_tagobject = @id_tagobject AND id_type = @id_type_t)
	
	IF @id_tagobjecttimer IS NULL BEGIN
		INSERT INTO TagObjectTimers (id_tagobject, id_type, date_start, date_end)
		VALUES (@id_tagobject, @id_type_t, GETDATE(), NULL)
	END
	ELSE BEGIN
		UPDATE TagObjectTimers
		SET date_start = GETDATE(),
		date_end = NULL
		WHERE id = @id_tagobjecttimer
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_timer_end]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_timer_end]
	@id_tagobject bigint,
	@type_timer nvarchar(100)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_t bigint
	EXEC spSnapshot_type_get @type_timer, @id_type_t OUTPUT
	
	UPDATE TagObjectTimers 
	SET date_end = GETDATE()
	WHERE id_tagobject = @id_tagobject
	AND id_type = @id_type_t
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_relationships_get_details]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_relationships_get_details]
	@id_snapshot bigint = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get @id_snapshot, @id_snapshot_l OUTPUT

	SELECT
	s_s_o.name + '-' + t_s_r.name as 'id',
	s_s_o.name,
	t_s_r.name,
	COUNT(s_r.id) as 'count'
	FROM Relationships s_r
	INNER JOIN Types t_s_r ON t_s_r.id = s_r.id_type
	INNER JOIN Objects s_o ON s_r.id_object_child = s_o.id
		AND s_o.id_snapshot = @id_snapshot_l
	INNER JOIN Sources s_s_o ON s_s_o.id = s_o.id_source
	GROUP BY s_s_o.name, t_s_r.name

END
GO
/****** Object:  StoredProcedure [dbo].[spTag_get_details]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_get_details]
	@id_tag bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
	t.id, 
	t.[description], 
	t.keywords,
	t.category,
	t.activity,
	t.task,
	t.duration_hour,
	t.delay_hour,
	t.is_active,
	t.direct_provision,
	t.validation_required,
	t.block_pending_validation,
	t.validation_interval_days,	
	dbo.fnTag_user_count_active(t.id) as 'users',
	dbo.fnTag_group_count_active(t.id) as 'groups',
	dbo.fnTag_object_count_active(t.id) as 'objects'
	FROM Tags t
	WHERE id = @id_tag
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_objectattribute_add]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_objectattribute_add]
	@id_object bigint,
	@id_attribute bigint,
	@attribute_value nvarchar(1000),
	@is_key bit = 0,
	@is_show bit = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id_object > 0 AND @id_attribute > 0 AND (LEN(@attribute_value) < 1000 OR @attribute_value IS NULL) BEGIN
		INSERT INTO ObjectAttributes (id_object, id_attribute, is_key, is_show, attribute_value)
		VALUES(@id_object, @id_attribute, @is_key, @is_show, @attribute_value)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_object_get_attributes]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_object_get_attributes]
	@id_object bigint
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
	a.name,
	oa.attribute_value
	FROM ObjectAttributes oa
	INNER JOIN Attributes a ON a.id = oa.id_attribute
	INNER JOIN Objects o ON o.id = oa.id_object
	WHERE o.id = @id_object

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_objects_search]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_objects_search]
	@id_snapshot bigint = 0,
	@name_attribute nvarchar(255),
	@attribute_value nvarchar(1000)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @id_snapshot_l bigint
	SET @id_snapshot_l = @id_snapshot
	IF @id_snapshot_l = 0 BEGIN SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots) END

	SELECT
	CONVERT(nvarchar,o.id) + '-' + CONVERT(nvarchar,oa_search.id) as 'id',
	o.id,
	oa_show.attribute_value,
	a_search.name,
	oa_search.attribute_value,
	s_o.name,
	t_o.name
	FROM Objects o
	INNER JOIN Snapshots s ON s.id = o.id_snapshot
	INNER JOIN Types t_o ON t_o.id = o.id_type
	INNER JOIN Sources s_o ON s_o.id = o.id_source
	INNER JOIN ObjectAttributes oa_show ON o.id = oa_show.id_object
		AND oa_show.is_show = 1
	LEFT JOIN ObjectAttributes oa_search ON o.id = oa_search.id_object
	LEFT JOIN Attributes a_search ON a_search.id = oa_search.id_attribute
	WHERE o.id_snapshot = @id_snapshot_l 
	AND (a_search.name = @name_attribute OR @name_attribute IS NULL)
	AND oa_search.attribute_value LIKE '%' + @attribute_value + '%'
	AND s.is_finished = 1
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_objects_get_details]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_objects_get_details]
	@id_snapshot bigint = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get @id_snapshot, @id_snapshot_l OUTPUT

	SELECT
	s_s_o.name + '-' + t_s_o.name as 'id',
	s_s_o.name as 'source',
	t_s_o.name as 'type',
	COUNT(s_o.id) AS 'count'
	FROM Objects s_o
	INNER JOIN Sources s_s_o ON s_s_o.id = s_o.id_source
	INNER JOIN Types t_s_o ON t_s_o.id = s_o.id_type
	WHERE s_o.id_snapshot = @id_snapshot_l
	GROUP BY s_s_o.name, t_s_o.name

END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectattribute_get]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnSnapshot_objectattribute_get] 
(
	@id_snapshot bigint = 0,
	@attribute_name nvarchar(500) = NULL
)
RETURNS @table_result table (
	id_object bigint,
	id_attribute bigint,
	attribute_value nvarchar(1000))  
AS
BEGIN
	DECLARE @id_snapshot_l bigint
	SET @id_snapshot_l = @id_snapshot
	IF @id_snapshot_l = 0 BEGIN SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots) END

	INSERT INTO @table_result
	SELECT
	o.id,
	oa_0.id_attribute,
	oa_0.attribute_value
	FROM ObjectAttributes oa_0
	INNER JOIN Objects o ON o.id = oa_0.id_object AND o.id_snapshot = @id_snapshot_l
	INNER JOIN Snapshots s ON s.id = o.id_snapshot
	WHERE oa_0.id_attribute IN
		(SELECT id FROM Attributes WHERE name = @attribute_name)
	OR @attribute_name IS NULL
	AND s.is_finished = 1
			
	RETURN 
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_relationships_add_staging_vertical]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_relationships_add_staging_vertical]
	@id_snapshot bigint,
	@type nvarchar(255),
	@column_index_parent int = 0,
	@column_index_child int = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @sql nvarchar(MAX)
	DECLARE @table_temp table (field_key nvarchar(1000), field_related nvarchar(1000), id_object_parent int, id_object_child int)
	
	DECLARE @key nvarchar(1000)
	DECLARE @key_related nvarchar(1000)
	DECLARE @id_object_parent bigint
	DECLARE @id_object_child bigint
	
	DECLARE @id_type bigint
	EXEC spSnapshot_type_get @type, @id_type OUTPUT

	SET @sql = 'SELECT DISTINCT 
	s_t.field_' + CONVERT(nvarchar, @column_index_parent) + ', 
	s_t.field_' + CONVERT(nvarchar, @column_index_child) + ', 
	o_parent.id, 
	o_child.id
	FROM Staging_table s_t
	INNER JOIN ObjectAttributes oa_parent ON oa_parent.attribute_value = s_t.field_' + CONVERT(nvarchar, @column_index_parent) + '
		AND oa_parent.is_key = 1
	INNER JOIN Objects o_parent ON o_parent.id = oa_parent.id_object 
		AND o_parent.id_snapshot = ' + CONVERT(nvarchar, @id_snapshot) + '
	INNER JOIN ObjectAttributes oa_child ON oa_child.attribute_value = s_t.field_' + CONVERT(nvarchar, @column_index_child) + '
		AND oa_child.is_key = 1
	INNER JOIN Objects o_child ON o_child.id = oa_child.id_object  
		AND o_child.id_snapshot = ' + CONVERT(nvarchar, @id_snapshot) + ''
	
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
			INSERT INTO Relationships (id_type, id_object_parent, id_object_child)
			VALUES (@id_type, @id_object_parent, @id_object_child)
		END

		FETCH NEXT FROM staging_cursor 
		INTO @key, @key_related, @id_object_parent, @id_object_child
	END
	
	CLOSE staging_cursor
	DEALLOCATE staging_cursor	
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_table_objects_exclusive]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_table_objects_exclusive]
	@id_tag bigint,
	@name_exclusive nvarchar(1000),
	@id_type nvarchar(255),
	@tag_is_active bit = 1,
	@object_is_active bit = 1,
	@is_overdue bit = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @id_type_o bigint
	EXEC spSnapshot_type_get @id_type, @id_type_o OUTPUT
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT

	SELECT
	t_o.name
	FROM TagObjects t_o
	INNER JOIN Tags t ON t_o.id_tag = t.id
	WHERE (t_o.is_active = @object_is_active OR @object_is_active IS NULL)
	AND ((ISNULL(t_o.date_start, GETDATE() - 1000) < GETDATE() AND ISNULL(t_o.date_end, GETDATE() + 1000) > GETDATE() AND @is_overdue = 0)
	OR (ISNULL(t_o.date_end, GETDATE() + 1000) < GETDATE() AND @is_overdue = 1)
	OR @is_overdue IS NULL)
	AND t_o.id_type = @id_type_o
	AND t_o.id_type <> @id_type_o_group
	AND (t.is_active = @tag_is_active OR @tag_is_active IS NULL)
	AND t_o.id_tag = @id_tag
	AND t_o.name NOT IN
	(SELECT t_g_delta.name FROM TagObjects t_g_delta
	INNER JOIN TagObjects t_u_delta ON t_g_delta.id_tag = t_u_delta.id_tag
	WHERE t_g_delta.id_tag <> @id_tag
	AND t_g_delta.id_type = @id_type_o
	AND t_g_delta.id_type <> @id_type_o_group
	AND (t_g_delta.is_active = @object_is_active OR @object_is_active IS NULL)
	AND t_u_delta.id_type = @id_type_o_user
	AND t_u_delta.name = @name_exclusive)
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_table_objects]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_table_objects]
	@id_tag bigint,
	@type_object nvarchar(255) = NULL,
	@object_is_active bit = 1,
	@is_overdue bit = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @id_type_o bigint
	EXEC spSnapshot_type_get @type_object, @id_type_o OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT

	SELECT
	t_o.id,
	t_o.name,
	t_t_o.name,
	t_o.date_start,
	t_o.date_end
	FROM TagObjects t_o
	LEFT JOIN Types t_t_o ON t_t_o.id = t_o.id_type
	WHERE t_o.id_tag = @id_tag
	AND (t_o.is_active = @object_is_active OR @object_is_active IS NULL)
	AND (t_o.id_type = @id_type_o OR @type_object IS NULL)
	AND (t_o.id_type <> @id_type_o_group AND t_o.id_type <> @id_type_o_user)
	AND ((ISNULL(t_o.date_start, GETDATE() - 1000) < GETDATE() AND ISNULL(t_o.date_end, GETDATE() + 1000) > GETDATE() AND @is_overdue = 0)
	OR (ISNULL(t_o.date_end, GETDATE() + 1000) < GETDATE() AND @is_overdue = 1)
	OR @is_overdue IS NULL)	
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_table_users]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_table_users]
	@id_tag bigint,
	@object_is_active bit = 1,
	@is_overdue bit = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @id_type_o bigint
	EXEC spSnapshot_type_get 'user', @id_type_o OUTPUT

	SELECT
	c_o.dn,
	c_o.attribute_1,
	c_o.attribute_2,
	c_o.attribute_3,
	c_o.attribute_4,
	c_o.attribute_5,
	c_o.attribute_6,
	c_o.attribute_7,
	c_o.attribute_8,
	c_o.attribute_9
	FROM TagObjects t_o
	INNER JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = t_o.name
	INNER JOIN Cache_table_ad c_o ON c_o.dn = c.distinguishedName
	WHERE (t_o.is_active = @object_is_active OR @object_is_active IS NULL)
	AND ((ISNULL(t_o.date_start, GETDATE() - 1000) < GETDATE() AND ISNULL(t_o.date_end, GETDATE() + 1000) > GETDATE() AND @is_overdue = 0)
	OR (ISNULL(t_o.date_end, GETDATE() + 1000) < GETDATE() AND @is_overdue = 1)
	OR @is_overdue IS NULL)
	AND t_o.id_type = @id_type_o
	AND t_o.id_tag = @id_tag
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_table_permissions_direct]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_table_permissions_direct]
	@id_tag bigint,
	@type_permission nvarchar(255) = NULL,
	@is_allowed bit = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_p bigint
	EXEC spSnapshot_type_get @type_permission, @id_type_p OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT

	SELECT
	t_p.id,
	t_p.name,
	t_t_n.name,		
	t_t_p.name,
	t_p.is_allowed
	FROM TagPermissions t_p
	INNER JOIN Types t_t_p ON t_p.id_type_permission = t_t_p.id
	INNER JOIN Types t_t_n ON t_p.id_type_name = t_t_n.id
	WHERE (t_t_p.id = @id_type_p OR @type_permission IS NULL)
	AND (t_p.is_allowed = @is_allowed OR @is_allowed IS NULL)
	AND t_p.id_tag = @id_tag
	AND t_p.id_type_name <> @id_type_o_group
	AND t_p.id_type_name <> @id_type_o_user

END
GO
/****** Object:  StoredProcedure [dbo].[spTag_permission_link]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_permission_link]
	@id_tagpermission bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @cache_object_count bigint = (SELECT dbo.fnCache_object_count(NULL))
	
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT		
	
	IF @cache_object_count > 50 BEGIN
		UPDATE t_p
		SET name = c.objectSID
		FROM TagPermissions t_p
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.sAMAccountName = t_p.name
		WHERE t_p.id = @id_tagpermission
		AND (t_p.id_type_name = @id_type_o_group OR t_p.id_type_name = @id_type_o_user)

		UPDATE t_p
		SET name = c.objectSID
		FROM TagPermissions t_p
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.distinguishedName = t_p.name
		WHERE t_p.id = @id_tagpermission
		AND (t_p.id_type_name = @id_type_o_group OR t_p.id_type_name = @id_type_o_user)
		
		UPDATE t_p
		SET name = c.objectSID
		FROM TagPermissions t_p
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.objectGUID = t_p.name
		WHERE t_p.id = @id_tagpermission
		AND (t_p.id_type_name = @id_type_o_group OR t_p.id_type_name = @id_type_o_user)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_objects_link]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_objects_link]
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @cache_object_count bigint = (SELECT dbo.fnCache_object_count(NULL))
	
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT		
	
	IF @cache_object_count > 50 BEGIN
		UPDATE t_o
		SET name = c.objectSID
		FROM TagObjects t_o
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.sAMAccountName = t_o.name
		WHERE (t_o.id_type = @id_type_o_group OR t_o.id_type = @id_type_o_user)

		UPDATE t_o
		SET name = c.objectSID
		FROM TagObjects t_o
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.distinguishedName = t_o.name
		WHERE (t_o.id_type = @id_type_o_group OR t_o.id_type = @id_type_o_user)
		
		UPDATE t_o
		SET name = c.objectSID
		FROM TagObjects t_o
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.objectGUID = t_o.name
		WHERE (t_o.id_type = @id_type_o_group OR t_o.id_type = @id_type_o_user)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_relationships_snapshot_right]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_relationships_snapshot_right]
	@filter_group nvarchar(1000) = NULL,
	@filter_user nvarchar(1000) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
	DECLARE @id_attribute_sid bigint
	EXEC spSnapshot_attribute_get 'objectSID', @id_attribute_sid OUTPUT
	DECLARE @id_type_r_member bigint
	EXEC spSnapshot_type_get 'member', @id_type_r_member OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT
	
	SELECT
	CONVERT(nvarchar,t_o_group.id_tag) + '-' + CONVERT(nvarchar,t_o_group.id) + '-' + CONVERT(nvarchar,t_o_user.id) as 'id',
	oa_group_key.attribute_value,
	oa_user_key.attribute_value
	FROM TagObjects t_o_group
	INNER JOIN TagObjects t_o_user ON t_o_group.id_tag = t_o_user.id_tag 
		AND t_o_group.id_type = @id_type_o_group
		AND t_o_user.id_type = @id_type_o_user
		AND (t_o_group.is_active = 0 OR t_o_user.is_active = 0)
	INNER JOIN ObjectAttributes oa_group_sid ON oa_group_sid.attribute_value = t_o_group.name
		AND oa_group_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_group ON o_group.id = oa_group_sid.id_object
		AND o_group.id_snapshot = @id_snapshot_l
	INNER JOIN ObjectAttributes oa_user_sid ON oa_user_sid.attribute_value = t_o_user.name
		AND oa_user_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_user ON o_user.id = oa_user_sid.id_object
		AND o_user.id_snapshot = @id_snapshot_l
	INNER JOIN Relationships r ON r.id_object_parent = o_group.id
		AND r.id_object_child = o_user.id
		AND r.id_type = @id_type_r_member
	INNER JOIN ObjectAttributes oa_group_key ON oa_group_key.id_object = r.id_object_parent
		AND oa_group_key.is_key = 1
	INNER JOIN ObjectAttributes oa_user_key ON oa_user_key.id_object = r.id_object_child
		AND oa_user_key.is_key = 1
	AND NOT t_o_group.name IN
	(SELECT t_o_group_active.name FROM TagObjects t_o_group_active
	INNER JOIN TagObjects t_o_user_active ON t_o_group_active.id_tag = t_o_user_active.id_tag 
		AND t_o_group_active.id_type = @id_type_o_group
		AND t_o_user_active.id_type = @id_type_o_user
		AND t_o_group_active.is_active = 1
		AND t_o_user_active.is_active = 1
		AND t_o_user_active.name = t_o_user.name)
	WHERE r.id_object_parent IS NULL
	AND (oa_group_key.attribute_value LIKE '%' + @filter_group + '%' OR @filter_group IS NULL)
	AND (oa_user_key.attribute_value LIKE '%' + @filter_user + '%' OR @filter_user IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_relationships_snapshot_left]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_relationships_snapshot_left]
	@filter_group nvarchar(1000) = NULL,
	@filter_user nvarchar(1000) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
	DECLARE @id_attribute_sid bigint
	EXEC spSnapshot_attribute_get 'objectSID', @id_attribute_sid OUTPUT
	DECLARE @id_type_r_member bigint
	EXEC spSnapshot_type_get 'member', @id_type_r_member OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT
	
	SELECT
	CONVERT(nvarchar,t_o_group.id_tag) + '-' + t_o_group.name + '-' + t_o_user.name as 'id',
	oa_group_key.attribute_value,
	t_o_group.name,
	t_o_group.date_start,
	t_o_group.date_end,
	oa_user_key.attribute_value,	
	t_o_user.name,
	t_o_user.date_start,
	t_o_user.date_end
	FROM TagObjects t_o_group
	INNER JOIN Tags t ON t.id = t_o_group.id_tag
	INNER JOIN TagObjects t_o_user ON t_o_group.id_tag = t_o_user.id_tag 
		AND t_o_group.id_type = @id_type_o_group
		AND t_o_user.id_type = @id_type_o_user
		AND t_o_group.is_active = 1
		AND t_o_user.is_active = 1
	INNER JOIN ObjectAttributes oa_group_sid ON oa_group_sid.attribute_value = t_o_group.name
		AND oa_group_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_group ON o_group.id = oa_group_sid.id_object
		AND o_group.id_snapshot = @id_snapshot_l
	INNER JOIN ObjectAttributes oa_group_key ON oa_group_key.id_object = o_group.id
		AND oa_group_key.is_key = 1
	INNER JOIN ObjectAttributes oa_user_sid ON oa_user_sid.attribute_value = t_o_user.name
		AND oa_user_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_user ON o_user.id = oa_user_sid.id_object
		AND o_user.id_snapshot = @id_snapshot_l
	INNER JOIN ObjectAttributes oa_user_key ON oa_user_key.id_object = o_user.id
		AND oa_user_key.is_key = 1
	LEFT JOIN Relationships r ON r.id_object_parent = o_group.id
		AND r.id_object_child = o_user.id
		AND r.id_type = @id_type_r_member
	WHERE r.id_object_parent IS NULL
	AND (oa_group_key.attribute_value LIKE '%' + @filter_group + '%'
		OR @filter_group IS NULL)
	AND (oa_user_key.attribute_value LIKE '%' + @filter_user + '%' 
		OR @filter_user IS NULL)
	AND (DATEDIFF(DAY,(SELECT MAX(t_v.validation_date) FROM TagValidation t_v WHERE t_v.id_tag = t.id),GETDATE()) >
		t.validation_interval_days 
		OR t.validation_required = 0 
		OR t.validation_required IS NULL 
		OR t.block_pending_validation = 0
		OR t.block_pending_validation IS NULL)
	AND ((SELECT TOP 1 t_v.is_valid FROM TagValidation t_v WHERE t_v.id_tag = t.id ORDER BY t_v.validation_date DESC) = 0
		OR t.block_pending_validation = 0
		OR t.block_pending_validation IS NULL
		OR t.validation_required = 0
		OR t.validation_required IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_relationships_snapshot_common]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_relationships_snapshot_common]
	@filter_group nvarchar(1000) = NULL,
	@filter_user nvarchar(1000) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
	DECLARE @id_attribute_sid bigint
	EXEC spSnapshot_attribute_get 'objectSID', @id_attribute_sid OUTPUT
	DECLARE @id_type_r_member bigint
	EXEC spSnapshot_type_get 'member', @id_type_r_member OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT
	
	SELECT
	CONVERT(nvarchar,t_o_group.id_tag) + '-' + t_o_group.name + '-' + t_o_user.name as 'id',
	oa_group_key.attribute_value,
	t_o_group.name,
	oa_user_key.attribute_value,
	t_o_user.name
	FROM TagObjects t_o_group
	INNER JOIN TagObjects t_o_user ON t_o_group.id_tag = t_o_user.id_tag 
		AND t_o_group.id_type = @id_type_o_group
		AND t_o_user.id_type = @id_type_o_user
		AND t_o_group.is_active = 1
		AND t_o_user.is_active = 1
	INNER JOIN ObjectAttributes oa_group_sid ON oa_group_sid.attribute_value = t_o_group.name
		AND oa_group_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_group ON o_group.id = oa_group_sid.id_object
		AND o_group.id_snapshot = @id_snapshot_l
	INNER JOIN ObjectAttributes oa_group_key ON oa_group_key.id_object = o_group.id
		AND oa_group_key.is_key = 1
	INNER JOIN ObjectAttributes oa_user_sid ON oa_user_sid.attribute_value = t_o_user.name
		AND oa_user_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_user ON o_user.id = oa_user_sid.id_object
		AND o_user.id_snapshot = @id_snapshot_l
	INNER JOIN ObjectAttributes oa_user_key ON oa_user_key.id_object = o_user.id
		AND oa_user_key.is_key = 1
	INNER JOIN Relationships r ON r.id_object_parent = o_group.id
		AND r.id_object_child = o_user.id
		AND r.id_type = @id_type_r_member
	WHERE (oa_group_key.attribute_value LIKE '%' + @filter_group + '%'
		OR @filter_group IS NULL)
	AND (oa_user_key.attribute_value LIKE '%' + @filter_user + '%' 
		OR @filter_user IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_permissions_link]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_permissions_link]
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @cache_object_count bigint = (SELECT dbo.fnCache_object_count(NULL))
	
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT	
	
	IF @cache_object_count > 50 BEGIN
		UPDATE t_p
		SET name = c.objectSID
		FROM TagPermissions t_p
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.sAMAccountName = t_p.name
		WHERE (t_p.id_type_name = @id_type_o_group OR t_p.id_type_name = @id_type_o_user)

		UPDATE t_p
		SET name = c.objectSID
		FROM TagPermissions t_p
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.distinguishedName = t_p.name
		WHERE (t_p.id_type_name = @id_type_o_group OR t_p.id_type_name = @id_type_o_user)
		
		UPDATE t_p
		SET name = c.objectSID
		FROM TagPermissions t_p
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.objectGUID = t_p.name
		WHERE (t_p.id_type_name = @id_type_o_group OR t_p.id_type_name = @id_type_o_user)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_permissions_get_direct]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_permissions_get_direct]
	@name_input nvarchar(500),
	@type_permission nvarchar(50) = NULL,
	@tag_is_active bit = 1,
	@is_allowed bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_p bigint
	EXEC spSnapshot_type_get @type_permission, @id_type_p OUTPUT

	SELECT
	t.id,
	t.[description]
	FROM TagPermissions t_p
	INNER JOIN Tags t ON t.id = t_p.id_tag
	WHERE (t_p.id_type_permission = @id_type_p OR @type_permission IS NULL)
	AND (t_p.is_allowed = @is_allowed OR @is_allowed IS NULL)
	AND (t.is_active = @tag_is_active OR @tag_is_active IS NULL)
	AND (t_p.name = @name_input)
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_overview_chart]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_overview_chart]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
	dbo.fnTag_user_count_active(0) AS 'Tag users',
	dbo.fnSnapshot_user_count(0) AS 'Snapshot users',
	dbo.fnTag_group_count_active(0) AS 'Tag groups',
	dbo.fnSnapshot_group_count(0) AS 'Snapshot groups'
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_overview]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_overview]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
	t.id,
	t.[description],
	dbo.fnTag_groups_active(t.id) as 'groups_active',
	dbo.fnTag_group_count_active(t.id) as 'count_groups',
	dbo.fnTag_objects_active(t.id) as 'objects active',
	dbo.fnTag_object_count_active(t.id) as 'count_objects',
	dbo.fnTag_user_count_active(t.id) as 'count_users'
	FROM Tags t
	ORDER BY t.[description]
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_table_objects]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_table_objects]
	@type_object nvarchar(255) = NULL,
	@tag_is_active bit = 1,
	@object_is_active bit = 1,
	@is_overdue bit = 0
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE @id_type_o bigint
	EXEC spSnapshot_type_get @type_object, @id_type_o OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT	

	SELECT
	t_o.id,
	t_o.id_tag,
	t_o.name,
	t_t_o.name,
	t_o.date_start,
	t_o.date_end
	FROM TagObjects t_o
	INNER JOIN Tags t ON t.id = t_o.id_tag
	INNER JOIN Types t_t_o ON t_t_o.id = t_o.id_type
	WHERE (t_o.is_active = @object_is_active OR @object_is_active IS NULL)
	AND (t_o.id_type = @id_type_o OR @type_object IS NULL)
	AND (t_o.id_type <> @id_type_o_group AND t_o.id_type <> @id_type_o_user)
	AND (t.is_active = @tag_is_active OR @tag_is_active IS NULL)
	AND ((ISNULL(t_o.date_start, GETDATE() - 1000) < GETDATE() AND ISNULL(t_o.date_end, GETDATE() + 1000) > GETDATE() AND @is_overdue = 0)
	OR (ISNULL(t_o.date_end, GETDATE() + 1000) < GETDATE() AND @is_overdue = 1)
	OR @is_overdue IS NULL)		
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_table_groups]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_table_groups]
	@id_tag bigint,
	@object_is_active bit = 1,
	@is_overdue bit = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT

	SELECT
	c_o.dn,
	c_o.attribute_1,
	c_o.attribute_2,
	c_o.attribute_3,
	c_o.attribute_4,
	c_o.attribute_5,
	c_o.attribute_6,
	c_o.attribute_7,
	c_o.attribute_8,
	c_o.attribute_9
	FROM TagObjects t_o
	INNER JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = t_o.name
	INNER JOIN Cache_table_ad c_o ON c_o.dn = c.distinguishedName
	WHERE (t_o.is_active = @object_is_active OR @object_is_active IS NULL)
	AND ((ISNULL(t_o.date_start, GETDATE() - 1000) < GETDATE() AND ISNULL(t_o.date_end, GETDATE() + 1000) > GETDATE() AND @is_overdue = 0)
	OR (ISNULL(t_o.date_end, GETDATE() + 1000) < GETDATE() AND @is_overdue = 1)
	OR @is_overdue IS NULL)
	AND t_o.id_type = @id_type_o_group
	AND t_o.id_tag = @id_tag
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_timers_chart]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_timers_chart]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
	t.id,
	t.[description],
	dbo.fnTag_timer_count_delta(t.id,0) as '0',
	dbo.fnTag_timer_count_delta(t.id,100) as '100',
	dbo.fnTag_timer_count_delta(t.id,250) as '250',
	dbo.fnTag_timer_count_delta(t.id,500) as '500',
	dbo.fnTag_timer_count_delta(t.id,750) as '750',
	dbo.fnTag_timer_count_delta(t.id,1000) as '1000',
	dbo.fnTag_timer_count_delta(t.id,2000) as '2000',
	dbo.fnTag_timer_count_delta(t.id,3000) as '3000',
	dbo.fnTag_timer_count_delta(t.id,4000) as '4000',
	dbo.fnTag_timer_count_delta(t.id,5000) as '5000',
	dbo.fnTag_timer_count_delta(t.id,6000) as '6000',
	dbo.fnTag_timer_count_delta(t.id,7000) as '7000',
	dbo.fnTag_timer_count_delta(t.id,8000) as '8000',
	dbo.fnTag_timer_count_delta(t.id,9000) as '9000',
	dbo.fnTag_timer_count_delta(t.id,10000) as '10000'
	FROM Tags t
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_permissions_cleanup]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_permissions_cleanup]
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @cache_object_count bigint = (SELECT dbo.fnCache_object_count(NULL))
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT

	IF @cache_object_count > 50 BEGIN
		DECLARE @obsoleteid_tagpermission TABLE (id bigint)
		INSERT INTO @obsoleteid_tagpermission
		SELECT
		t_p.id
		FROM TagPermissions t_p
		LEFT JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = t_p.name
		WHERE c.distinguishedName IS NULL
		AND dbo.fnSnapshot_objectsid_validate(t_p.name) = 1
		
		INSERT INTO @obsoleteid_tagpermission
		SELECT
		t_p.id
		FROM TagPermissions t_p
		WHERE dbo.fnSnapshot_objectsid_validate(t_p.name) = 0
		AND (t_p.id_type_name = @id_type_o_group OR t_p.id_type_name = @id_type_o_user)
		
		DELETE FROM TagPermissions
		WHERE id IN (SELECT p.id FROM @obsoleteid_tagpermission p)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_objects_cleanup_soft]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_objects_cleanup_soft]
AS
BEGIN
	SET NOCOUNT ON;
	
	EXEC spTags_objects_link
	EXEC spTags_permissions_link
	
	DECLARE @cache_object_count bigint = (SELECT dbo.fnCache_object_count(NULL))
	
	IF @cache_object_count > 50 BEGIN
		DECLARE @obsoleteid_tagobject TABLE (id bigint)
		INSERT INTO @obsoleteid_tagobject
		SELECT
		t_o.id
		FROM TagObjects t_o
		LEFT JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = t_o.name
		WHERE c.distinguishedName IS NULL
		AND dbo.fnSnapshot_objectsid_validate(t_o.name) = 1
		AND t_o.is_active = 1
		
		UPDATE TagObjects
		SET is_active = 0
		WHERE id IN (SELECT o.id FROM @obsoleteid_tagobject o)
	END
	
	EXEC spTags_objecttimers_cleanup
	EXEC spTags_permissions_cleanup
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_objects_cleanup_hard]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_objects_cleanup_hard]
AS
BEGIN
	SET NOCOUNT ON;
	
	EXEC spTags_objects_link
	EXEC spTags_permissions_link
	
	DECLARE @cache_object_count bigint = (SELECT dbo.fnCache_object_count(NULL))
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT

	IF @cache_object_count > 50 BEGIN
		DECLARE @obsoleteid_tagobject TABLE (id bigint)
		INSERT INTO @obsoleteid_tagobject
		SELECT
		t_o.id
		FROM TagObjects t_o
		LEFT JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = t_o.name
		WHERE c.distinguishedName IS NULL
		AND dbo.fnSnapshot_objectsid_validate(t_o.name) = 1
		
		INSERT INTO @obsoleteid_tagobject
		SELECT
		t_o.id
		FROM TagObjects t_o
		WHERE dbo.fnSnapshot_objectsid_validate(t_o.name) = 0
		AND (t_o.id_type = @id_type_o_group OR t_o.id_type = @id_type_o_user)
		
		DELETE FROM TagObjects
		WHERE id IN (SELECT o.id FROM @obsoleteid_tagobject o)
		
		DECLARE @duplicateid_tagobject TABLE (id bigint)
		INSERT INTO @duplicateid_tagobject
		SELECT
		t_o.id
		FROM TagObjects t_o
		INNER JOIN Tags t ON t.id = t_o.id_tag
		AND NOT t_o.id IN
		(SELECT MIN(t_o_d.id)
		FROM TagObjects t_o_d
		WHERE t_o_d.id_tag = t_o.id_tag
		GROUP BY t_o_d.name)
		
		DELETE FROM TagObjects
		WHERE id IN (SELECT d.id FROM @duplicateid_tagobject d)		
	END

	EXEC spTags_objecttimers_cleanup
	EXEC spTags_permissions_cleanup
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_relationships_not_in_tags]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_relationships_not_in_tags]
	@is_active bit = NULL,
	@keywords nvarchar(400) = NULL,
	@category nvarchar(400) = NULL,
	@activity nvarchar(400) = NULL,
	@task nvarchar(400) = NULL,
	@o_parent_filter nvarchar(1000) = NULL,
	@o_child_filter nvarchar(1000) = NULL
AS BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
	DECLARE @id_attribute_sid bigint
	EXEC spSnapshot_attribute_get 'objectSID', @id_attribute_sid OUTPUT
	DECLARE @id_type_r_member bigint
	EXEC spSnapshot_type_get 'member', @id_type_r_member OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT

	DECLARE @table_relationships_snapshot TABLE (id_relationship bigint, id_object_parent bigint, id_object_child bigint)
	INSERT INTO @table_relationships_snapshot
	SELECT
	r.id,
	o_parent.id,
	o_child.id
	FROM Relationships r
	INNER JOIN Objects o_parent ON r.id_object_parent = o_parent.id
	INNER JOIN Objects o_child ON r.id_object_child = o_child.id
	WHERE o_parent.id_snapshot = @id_snapshot_l
	AND o_child.id_snapshot = @id_snapshot_l
	AND o_parent.id_type = @id_type_o_group
	AND o_child.id_type = @id_type_o_user
	AND r.id_type = @id_type_r_member
	AND (dbo.fnSnapshot_objectid_key(o_parent.id) LIKE '%' + @o_parent_filter + '%'
		OR dbo.fnSnapshot_objectid_show(o_parent.id) LIKE '%' + @o_parent_filter + '%'
		OR @o_parent_filter IS NULL)
	AND (dbo.fnSnapshot_objectid_key(o_child.id) LIKE '%' + @o_child_filter + '%'
		OR dbo.fnSnapshot_objectid_show(o_child.id) LIKE '%' + @o_child_filter + '%'
		OR @o_child_filter IS NULL)

	DECLARE @table_relationships_tag TABLE (id_object_parent bigint, id_object_child bigint)
	INSERT INTO @table_relationships_tag
	SELECT
	o_group.id,
	o_user.id
	FROM TagObjects t_o_group
	INNER JOIN TagObjects t_o_user ON t_o_group.id_tag = t_o_user.id_tag 
		AND t_o_group.id_type = @id_type_o_group
		AND t_o_user.id_type = @id_type_o_user
		AND t_o_group.is_active = 1
		AND t_o_user.is_active = 1
	INNER JOIN ObjectAttributes oa_group_sid ON oa_group_sid.attribute_value = t_o_group.name
		AND oa_group_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_group ON o_group.id = oa_group_sid.id_object
		AND o_group.id_snapshot = @id_snapshot_l
	INNER JOIN Cache_table_dn_sAMAccountName c_group ON c_group.objectSID = t_o_group.name
	INNER JOIN ObjectAttributes oa_user_sid ON oa_user_sid.attribute_value = t_o_user.name
		AND oa_user_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_user ON o_user.id = oa_user_sid.id_object
		AND o_user.id_snapshot = @id_snapshot_l
	INNER JOIN Cache_table_dn_sAMAccountName c_user ON c_user.objectSID = t_o_user.name
	INNER JOIN Relationships r ON r.id_object_parent = o_group.id
		AND r.id_object_child = o_user.id
		AND r.id_type = @id_type_r_member
	INNER JOIN Tags t ON t_o_group.id_tag = t.id
	AND (t.is_active = @is_active OR @is_active IS NULL)
	AND (t.keywords IN (SELECT string_value FROM fnStringToTable(@keywords, ','))
		OR @keywords IN (SELECT string_value FROM fnStringToTable(t.keywords, ','))
		OR @keywords = t.keywords
		OR @keywords IS NULL)
	AND (t.category = @category OR @category IS NULL)
	AND (t.activity = @activity OR @activity IS NULL)
	AND (t.task = @task OR @task IS NULL)

	SELECT
	r_s.id_relationship,
	dbo.fnSnapshot_objectid_key(r_s.id_object_parent) as 'object_parent_key',
	dbo.fnSnapshot_objectid_show(r_s.id_object_parent) as 'object_parent_show',
	dbo.fnSnapshot_objectid_key(r_s.id_object_child) as 'object_child_key',
	dbo.fnSnapshot_objectid_show(r_s.id_object_child) as 'object_child_show'
	FROM @table_relationships_snapshot r_s
	LEFT JOIN @table_relationships_tag r_t ON r_s.id_object_parent = r_t.id_object_parent 
		AND r_s.id_object_child = r_t.id_object_child
	WHERE r_t.id_object_parent IS NULL
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_relationships_duplicate]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_relationships_duplicate]
AS BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
	DECLARE @id_attribute_sid bigint
	EXEC spSnapshot_attribute_get 'objectSID', @id_attribute_sid OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT	
	
	SELECT DISTINCT
	DENSE_RANK() OVER (ORDER BY dbo.fnSnapshot_objectid_key(o_group.id),dbo.fnSnapshot_objectid_key(o_user.id)) as 'id',
	dbo.fnSnapshot_objectid_key(o_group.id) as 'group_key',
	dbo.fnSnapshot_objectid_show(o_group.id) as 'group_show',
	dbo.fnSnapshot_objectid_key(o_user.id) as 'user_key',
	dbo.fnSnapshot_objectid_show(o_user.id) as 'user_show'
	FROM TagObjects t_o_g
	INNER JOIN ObjectAttributes oa_group_sid ON oa_group_sid.attribute_value = t_o_g.name
		AND oa_group_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_group ON o_group.id = oa_group_sid.id_object
		AND o_group.id_snapshot = @id_snapshot_l
	INNER JOIN TagObjects t_o_u ON t_o_g.id_tag = t_o_u.id_tag
	INNER JOIN ObjectAttributes oa_user_sid ON oa_user_sid.attribute_value = t_o_u.name
		AND oa_user_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_user ON o_user.id = oa_user_sid.id_object
		AND o_user.id_snapshot = @id_snapshot_l
	INNER JOIN TagObjects t_o_g_delta ON t_o_g_delta.name = t_o_g.name
	INNER JOIN TagObjects t_o_u_delta ON t_o_u_delta.name = t_o_u.name
	WHERE t_o_g.id_type = @id_type_o_group
	AND t_o_u.id_type = @id_type_o_user
	AND t_o_g_delta.id_type = @id_type_o_group
	AND t_o_u_delta.id_type = @id_type_o_user
	AND t_o_g_delta.id_tag = t_o_u_delta.id_tag
	AND t_o_g_delta.id_tag <> t_o_g.id_tag
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_table_validations]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_table_validations]
	@is_valid bit = 1,
	@validated_by nvarchar(400) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
	t_v.id_tag,
	t_v.id_type,
	ISNULL(dbo.fnSnapshot_objectid_show(dbo.fnSnapshot_objectsid_id(t_v.validated_by)), t_v.validated_by),
	t_v.validation_date
	FROM TagValidation t_v
	WHERE (ISNULL(dbo.fnSnapshot_objectid_show(dbo.fnSnapshot_objectsid_id(t_v.validated_by)), t_v.validated_by) = @validated_by OR @validated_by IS NULL)
	AND (t_v.is_valid = @is_valid OR @is_valid IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_permissions_get]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_permissions_get]
	@name_input nvarchar(1000),
	@type_permission nvarchar(50) = NULL,
	@tag_is_active bit = 1,
	@is_allowed bit = 1
AS
BEGIN
	SET NOCOUNT ON;
		
	DECLARE @id_object_input bigint = dbo.fnSnapshot_objectdn_id(@name_input)
	DECLARE @name_input_sid nvarchar(255) = dbo.fnSnapshot_objectid_sid(@id_object_input)
	DECLARE @id_type_r_member bigint
	EXEC spSnapshot_type_get 'member', @id_type_r_member OUTPUT
	DECLARE @id_type_p bigint
	EXEC spSnapshot_type_get @type_permission, @id_type_p OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	DECLARE @id_attribute_sid bigint
	EXEC spSnapshot_attribute_get 'objectSID', @id_attribute_sid OUTPUT

	SELECT DISTINCT
	t.id,
	t.[description]
	FROM TagPermissions t_p
	INNER JOIN Tags t ON t.id = t_p.id_tag
	WHERE (t_p.id_type_permission = @id_type_p OR @type_permission IS NULL)
	AND (t_p.is_allowed = @is_allowed OR @is_allowed IS NULL)
	AND (t.is_active = @tag_is_active OR @tag_is_active IS NULL)
	AND (t_p.name = @name_input_sid
	OR t_p.name IN
	(SELECT c.objectSID
	FROM Cache_table_dn_sAMAccountName c
	INNER JOIN ObjectAttributes oa_sid ON oa_sid.attribute_value = c.objectSID 
		AND oa_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o ON o.id = oa_sid.id_object 
		AND o.id_snapshot = @id_snapshot_l
		AND o.id_type = @id_type_o_group
	INNER JOIN Relationships s_r ON s_r.id_object_parent = o.id
		AND s_r.id_type = @id_type_r_member
	WHERE s_r.id_object_child = @id_object_input))

END
GO
/****** Object:  StoredProcedure [dbo].[spTags_objects_timer_get]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_objects_timer_get]
	@type_object nvarchar(50) = NULL,
	@type_timer nvarchar(50) = NULL,
	@is_overdue bit = 0,
	@tag_is_active bit = 1,
	@object_is_active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_t bigint
	EXEC spSnapshot_type_get @type_timer, @id_type_t OUTPUT
	DECLARE @id_type_o bigint
	EXEC spSnapshot_type_get @type_object, @id_type_o OUTPUT
	
	SELECT
	t_o.id,
	t.id,
	t.[description],
	ISNULL(dbo.fnSnapshot_objectid_show(dbo.fnSnapshot_objectsid_id(t_o.name)), t_o.name),
	t_t_o.name,
	t_t_o_t.name,
	t.duration_hour,
	DATEDIFF(hour, t_o_t.date_start, GETDATE()) as 'duration_hour_used'
	FROM TagObjects t_o
	INNER JOIN Types t_t_o ON t_t_o.id = t_o.id_type
	INNER JOIN TagObjectTimers t_o_t ON t_o_t.id_tagobject = t_o.id
	INNER JOIN Types t_t_o_t ON t_t_o_t.id = t_o_t.id_type
	INNER JOIN Tags t ON t.id = t_o.id_tag
	WHERE (t_o.id_type = @id_type_o OR @type_object IS NULL)
	AND (t_t_o_t.id = @id_type_t OR @type_timer IS NULL)
	AND (t.is_active = @tag_is_active OR @tag_is_active IS NULL)
	AND (t_o.is_active = @object_is_active OR @object_is_active IS NULL)
	AND (DATEDIFF(hour, t_o_t.date_start, GETDATE()) > t.duration_hour AND t.duration_hour > 0 OR @is_overdue = 0 OR @is_overdue IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_permission_add]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_permission_add]
	@id_tag bigint,
	@type_permission nvarchar(255),
	@type_name nvarchar(500),
	@name nvarchar(1000),
	@is_allowed bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_p bigint
	EXEC spSnapshot_type_get @type_permission, @id_type_p OUTPUT	
	DECLARE @id_type_n bigint
	EXEC spSnapshot_type_get @type_name, @id_type_n OUTPUT
	
	DECLARE @id_tagpermission bigint = (SELECT TOP 1 t_p.id 
		FROM TagPermissions t_p
		WHERE t_p.name = @name
		AND t_p.id_tag = @id_tag
		AND t_p.id_type_permission = @id_type_p
		AND t_p.id_type_name = @id_type_n
		AND t_p.is_allowed = @is_allowed
		ORDER BY t_p.id)

	IF @id_tag > 0 AND @id_tagpermission IS NULL AND LEN(@name) > 0 AND @id_type_p > 0 AND @id_type_n > 0 BEGIN
		INSERT INTO TagPermissions (id_tag, id_type_permission, id_type_name, name, is_allowed) 
		VALUES (@id_tag, @id_type_p, @id_type_n, @name, @is_allowed)
		SET @id_tagpermission = (SELECT SCOPE_IDENTITY())
		
		EXEC spTag_permission_link @id_tagpermission
		
		SELECT @id_tagpermission
	END
	SELECT '0'
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_objects_timer_get]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_objects_timer_get]
	@id_tag bigint,
	@type_object nvarchar(50) = NULL,
	@type_timer nvarchar(50) = NULL,
	@is_overdue bit = 0,
	@object_is_active bit = 1,
	@tag_is_active bit = 1
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE @id_type_t bigint
	EXEC spSnapshot_type_get @type_timer, @id_type_t OUTPUT
	DECLARE @id_type_o bigint
	EXEC spSnapshot_type_get @type_object, @id_type_o OUTPUT

	SELECT
	t_o.id,
	t.id,
	t.[description],
	ISNULL(dbo.fnSnapshot_objectid_show(dbo.fnSnapshot_objectsid_id(t_o.name)), t_o.name),
	t_t_o.name,
	t_t_o_t.name,
	t.duration_hour,
	DATEDIFF(hour, t_o_t.date_start, GETDATE()) as 'duration_hour_used'
	FROM TagObjects t_o
	INNER JOIN Types t_t_o ON t_t_o.id = t_o.id_type
	INNER JOIN TagObjectTimers t_o_t ON t_o_t.id_tagobject = t_o.id
	INNER JOIN Types t_t_o_t ON t_t_o_t.id = t_o_t.id_type
	INNER JOIN Tags t ON t.id = t_o.id_tag
	WHERE (t_o.id_type = @id_type_o OR @type_object IS NULL)
	AND (t_t_o_t.id = @id_type_t OR @type_timer IS NULL)
	AND (t.is_active = @tag_is_active OR @tag_is_active IS NULL)
	AND (t_o.is_active = @object_is_active OR @object_is_active IS NULL)
	AND (DATEDIFF(hour, t_o_t.date_start, GETDATE()) > t.duration_hour AND t.duration_hour > 0 OR @is_overdue = 0 OR @is_overdue IS NULL)
	AND t.id = @id_tag
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_table_permissions]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_table_permissions]
	@id_tag bigint,
	@type_permission nvarchar(255) = NULL,
	@is_allowed bit = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_p bigint
	EXEC spSnapshot_type_get @type_permission, @id_type_p OUTPUT
	
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT

	SELECT
	t_p.id,
	ISNULL(dbo.fnSnapshot_objectid_show(dbo.fnSnapshot_objectsid_id(t_p.name)), t_p.name),
	t_t_p.name,
	t_p.is_allowed
	FROM TagPermissions t_p
	INNER JOIN Types t_t_p ON t_p.id_type_permission = t_t_p.id
	AND (t_t_p.id = @id_type_p OR @type_permission IS NULL)
	AND (t_p.is_allowed = @is_allowed OR @is_allowed IS NULL)
	AND t_p.id_tag = @id_tag
	AND t_p.id_type_name = @id_type_o_group

END
GO
/****** Object:  StoredProcedure [dbo].[spTag_table_validations]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_table_validations]
	@id_tag bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
	t_v.id,
	t_v.id_tag,
	t_v.id_type,
	ISNULL(dbo.fnSnapshot_objectid_show(dbo.fnSnapshot_objectsid_id(t_v.validated_by)), t_v.validated_by),
	t_v.validation_date
	FROM TagValidation t_v
	WHERE t_v.id_tag = @id_tag
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_table_user_attributes_groups_managedby]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_table_user_attributes_groups_managedby]
	@object_dn nvarchar(1000)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
	DECLARE @id_object_user bigint = dbo.fnSnapshot_objectdn_id(@object_dn)
	DECLARE @id_type_r_managedby bigint
	EXEC spSnapshot_type_get 'managedBy', @id_type_r_managedby OUTPUT
	DECLARE @id_type_r_member bigint
	EXEC spSnapshot_type_get 'member', @id_type_r_member OUTPUT	

	SELECT
	c_g.dn,
	c_g.attribute_1,
	c_g.attribute_2,
	c_g.attribute_3,
	c_g.attribute_4,
	c_g.attribute_5,
	c_g.attribute_6,
	c_g.attribute_7,
	c_g.attribute_8,
	c_g.attribute_9
	FROM Cache_table_ad c_g
	WHERE c_g.type = 'group' 
	AND	(c_g.dn IN
	(SELECT oa_key.attribute_value FROM Relationships r
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = r.id_object_parent
		AND oa_key.is_key = 1
	INNER JOIN Objects o ON o.id = oa_key.id_object
	WHERE r.id_object_child = @id_object_user 
	AND r.id_type = @id_type_r_managedby
	AND o.id_snapshot = @id_snapshot_l)
	OR c_g.dn IN
	(SELECT oa_key.attribute_value FROM Relationships r
	INNER JOIN Relationships r_managedby ON r_managedby.id_object_child = r.id_object_parent
		AND r_managedby.id_type = @id_type_r_managedby
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = r_managedby.id_object_parent
		AND oa_key.is_key = 1
	INNER JOIN Objects o ON o.id = oa_key.id_object
	WHERE r.id_object_child = @id_object_user 
	AND r.id_type = @id_type_r_member
	AND o.id_snapshot = @id_snapshot_l))
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_table_snapshot_manager_groups_costs_chart]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_table_snapshot_manager_groups_costs_chart]
	@object_dn_manager nvarchar(1000),
	@name_a_cost nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT

	DECLARE @id_object_manager bigint = dbo.fnSnapshot_objectdn_id(@object_dn_manager)
	DECLARE @id_type_r_member bigint
	EXEC spSnapshot_type_get 'member', @id_type_r_member OUTPUT
	DECLARE @id_type_r_manager bigint
	EXEC spSnapshot_type_get 'manager', @id_type_r_manager OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT

	CREATE TABLE #table_group_costs (id_object bigint, attribute_value nvarchar(255))
	INSERT INTO #table_group_costs
	SELECT 
	oa.id_object, 
	oa.attribute_value 
	FROM ObjectAttributes oa 
	INNER JOIN Objects o ON o.id = oa.id_object 
		AND o.id_snapshot = @id_snapshot_l
	INNER JOIN Attributes a ON oa.id_attribute = a.id
		AND a.name = @name_a_cost
	WHERE ISNUMERIC(oa.attribute_value) = 1

	DECLARE @cols NVARCHAR(MAX) = STUFF((
	SELECT N',' + QUOTENAME(y)
	FROM (SELECT DISTINCT
	c_g.attribute_2 AS y
	FROM Relationships r_member
	INNER JOIN Relationships r_manager ON r_manager.id_object_parent = r_member.id_object_child
		AND r_manager.id_type = @id_type_r_manager
		AND r_member.id_type = @id_type_r_member
		AND r_manager.id_object_child = @id_object_manager
	INNER JOIN Objects o_parent ON o_parent.id = r_member.id_object_parent
		AND o_parent.id_type = @id_type_o_group
		AND o_parent.id_snapshot = @id_snapshot_l
	INNER JOIN ObjectAttributes oa_parent_key ON oa_parent_key.id_object = r_member.id_object_parent
		AND oa_parent_key.is_key = 1
	INNER JOIN #table_group_costs oa_parent_cost ON oa_parent_cost.id_object = r_member.id_object_parent
	INNER JOIN Cache_table_ad c_g ON c_g.dn = oa_parent_key.attribute_value
		AND c_g.type = 'group') AS Y
	ORDER BY y FOR XML PATH('')),1, 1, N'');

	DECLARE @sql NVARCHAR(MAX) = N'SELECT *
	FROM (SELECT
	c_g.attribute_2,
	CONVERT(int,oa_parent_cost.attribute_value) as qty
	FROM Relationships r_member
	INNER JOIN Relationships r_manager ON r_manager.id_object_parent = r_member.id_object_child
		AND r_manager.id_type = ' + CONVERT(nvarchar,@id_type_r_manager) + '
		AND r_member.id_type = ' + CONVERT(nvarchar,@id_type_r_member) + '
		AND r_manager.id_object_child = ' + CONVERT(nvarchar,@id_object_manager) + '
	INNER JOIN Objects o_parent ON o_parent.id = r_member.id_object_parent
		AND o_parent.id_type = ' + CONVERT(nvarchar,@id_type_o_group) + '
		AND o_parent.id_snapshot = ' + CONVERT(nvarchar,@id_snapshot_l) + '
	INNER JOIN ObjectAttributes oa_parent_key ON oa_parent_key.id_object = r_member.id_object_parent
		AND oa_parent_key.is_key = 1
	INNER JOIN #table_group_costs oa_parent_cost ON oa_parent_cost.id_object = r_member.id_object_parent
	INNER JOIN Cache_table_ad c_g ON c_g.dn = oa_parent_key.attribute_value
		AND c_g.type = ''group'') AS D
	PIVOT(SUM(qty) FOR attribute_2 IN(' + @cols + N')) AS P;';

	EXEC sp_executesql @sql;

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_table_snapshot_manager_groups_costs]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_table_snapshot_manager_groups_costs]
	@object_dn_manager nvarchar(1000),
	@name_a_cost nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT

	DECLARE @id_object_manager bigint = dbo.fnSnapshot_objectdn_id(@object_dn_manager)
	DECLARE @id_type_r_member bigint
	EXEC spSnapshot_type_get 'member', @id_type_r_member OUTPUT	
	DECLARE @id_type_r_manager bigint
	EXEC spSnapshot_type_get 'manager', @id_type_r_manager OUTPUT	
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT	
	
	DECLARE @table_group_costs TABLE (id_object bigint, cost_value nvarchar(255))
	INSERT INTO @table_group_costs
	SELECT 
	s_oa.id_object,
	s_oa.attribute_value
	FROM fnSnapshot_objectattribute_get(0,@name_a_cost) s_oa
	WHERE ISNUMERIC(s_oa.attribute_value) = 1
	
	SELECT
	c_g.dn,
	c_g.attribute_1,
	c_g.attribute_2,
	c_g.attribute_3,
	c_g.attribute_4,
	c_g.attribute_5,
	c_g.attribute_6,
	c_g.attribute_7,
	c_g.attribute_8,
	c_g.attribute_9,
	COUNT(r_member.id),
	CONVERT(nvarchar,SUM(CONVERT(decimal,oa_cost.cost_value)))
	FROM Relationships r_member
	INNER JOIN Relationships r_manager ON r_manager.id_object_parent = r_member.id_object_child
		AND r_manager.id_type = @id_type_r_manager
		AND r_member.id_type = @id_type_r_member
		AND r_manager.id_object_child = @id_object_manager
	INNER JOIN Objects o_parent ON o_parent.id = r_member.id_object_parent
		AND o_parent.id_type = @id_type_o_group
		AND o_parent.id_snapshot = @id_snapshot_l
	INNER JOIN ObjectAttributes oa_parent_key ON oa_parent_key.id_object = r_member.id_object_parent
		AND oa_parent_key.is_key = 1
	INNER JOIN @table_group_costs oa_cost ON oa_cost.id_object = r_member.id_object_parent
	INNER JOIN Cache_table_ad c_g ON c_g.dn = oa_parent_key.attribute_value
		AND c_g.type = 'group'
	GROUP BY c_g.dn, c_g.attribute_1, c_g.attribute_2, c_g.attribute_3, c_g.attribute_4, c_g.attribute_5,
		c_g.attribute_6, c_g.attribute_7, c_g.attribute_8, c_g.attribute_9
	HAVING SUM(CONVERT(decimal,oa_cost.cost_value)) > 0

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_table_snapshot_manager_group_users]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_table_snapshot_manager_group_users]
	@object_dn_manager nvarchar(1000),
	@object_dn_group nvarchar(1000)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
	DECLARE @id_object_manager bigint = dbo.fnSnapshot_objectdn_id(@object_dn_manager)
	DECLARE @id_object_group bigint = dbo.fnSnapshot_objectdn_id(@object_dn_group)
	DECLARE @id_type_r_member bigint 
	EXEC spSnapshot_type_get 'member', @id_type_r_member OUTPUT
	DECLARE @id_type_r_manager bigint
	EXEC spSnapshot_type_get 'manager', @id_type_r_manager OUTPUT
	
	SELECT
	c_u.dn,
	c_u.attribute_1,
	c_u.attribute_2,
	c_u.attribute_3,
	c_u.attribute_4,
	c_u.attribute_5,
	c_u.attribute_6,
	c_u.attribute_7,
	c_u.attribute_8,
	c_u.attribute_9
	FROM Relationships r_member
	INNER JOIN Relationships r_manager ON r_manager.id_object_parent = r_member.id_object_child
		AND r_manager.id_type = @id_type_r_manager
		AND r_member.id_type = @id_type_r_member
		AND r_manager.id_object_child = @id_object_manager
		AND r_member.id_object_parent = @id_object_group
	INNER JOIN ObjectAttributes oa_child_key ON oa_child_key.id_object = r_member.id_object_child
		AND oa_child_key.is_key = 1
	INNER JOIN Objects o ON o.id = oa_child_key.id_object
		AND o.id_snapshot = @id_snapshot_l
	INNER JOIN Cache_table_ad c_u ON c_u.dn = oa_child_key.attribute_value
		AND c_u.type = 'user'
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_role_modelling_import]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_role_modelling_import]
	@attribute_names nvarchar(500),
	@min_relationship_percentage float = 80,
	@min_attribute_count bigint = 10,
	@type_relationship nvarchar(100) = 'member',
	@char_separator nvarchar(5) = '-'
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
	DECLARE @id_type_r bigint
	EXEC spSnapshot_type_get @type_relationship, @id_type_r OUTPUT
	
    CREATE TABLE #table_oa (attribute_value nvarchar(1000))
	INSERT INTO #table_oa
	SELECT
	s_oa.attribute_value
	FROM fnSnapshot_objectattributes_get_unique(0,@attribute_names,@char_separator) s_oa
    
    CREATE TABLE #table_id_oa (id_object bigint, attribute_value nvarchar(1000))
	INSERT INTO #table_id_oa
	SELECT
	o.id,
	dbo.fnSnapshot_objectid_attributes(o.id,@attribute_names,@char_separator)
	FROM Objects o
	WHERE o.id_snapshot = @id_snapshot_l
    
    CREATE CLUSTERED INDEX i_oa_id ON #table_id_oa(id_object)

	SELECT
	oa.attribute_value AS 'role',
	
	STUFF((SELECT ',' + dbo.fnSnapshot_objectid_sid(oa_objects.id_object)
		FROM #table_id_oa oa_objects 
		WHERE oa_objects.attribute_value = oa.attribute_value
		ORDER BY dbo.fnSnapshot_objectid_show(oa_objects.id_object)
		FOR XML PATH('')),1,1,'') AS 'objects',	
	
	STUFF((SELECT ',' +
		dbo.fnSnapshot_objectid_sid(r.id_object_parent) 
		FROM Relationships r
		INNER JOIN #table_id_oa oa_relationships ON oa_relationships.attribute_value = oa.attribute_value
			AND oa_relationships.id_object = r.id_object_child
		WHERE r.id_type = @id_type_r
		GROUP BY r.id_object_parent
		HAVING ROUND(CONVERT(float, COUNT(oa_relationships.attribute_value)) / CONVERT(float,(SELECT COUNT(*) FROM #table_id_oa oa_count 
		WHERE oa_count.attribute_value = oa.attribute_value)) * 100, 2) > @min_relationship_percentage
		ORDER BY COUNT(oa_relationships.attribute_value) DESC
		FOR XML PATH('')),1,1,'') AS 'relationships'

	FROM #table_oa oa
	WHERE NOT oa.attribute_value IS NULL
	AND (SELECT COUNT(*) FROM #table_id_oa oa_count WHERE oa_count.attribute_value = oa.attribute_value) >= @min_attribute_count
	AND NOT (STUFF((SELECT ',' +
		dbo.fnSnapshot_objectid_sid(r.id_object_parent) 
		FROM Relationships r
		INNER JOIN #table_id_oa oa_relationships ON oa_relationships.attribute_value = oa.attribute_value
			AND oa_relationships.id_object = r.id_object_child
		WHERE r.id_type = @id_type_r
		GROUP BY r.id_object_parent
		HAVING ROUND(CONVERT(float, COUNT(oa_relationships.attribute_value)) / CONVERT(float,(SELECT COUNT(*) FROM #table_id_oa oa_count 
		WHERE oa_count.attribute_value = oa.attribute_value)) * 100, 2) > @min_relationship_percentage
		ORDER BY COUNT(oa_relationships.attribute_value) DESC
		FOR XML PATH('')),1,1,'')) IS NULL
	
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_role_modelling]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_role_modelling]
	@attribute_names nvarchar(500),
	@attribute_values nvarchar(1000) = NULL,
	@include_child_objects bit = 1,
	@include_child_objects_ex bit = 1,
	@min_relationship_percentage float = 80,
	@min_attribute_count bigint = 10,
	@type_relationship nvarchar(100) = 'member',
	@char_separator nvarchar(5) = '-'
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
	DECLARE @id_type_r bigint
	EXEC spSnapshot_type_get @type_relationship, @id_type_r OUTPUT	
	
    CREATE TABLE #table_oa (attribute_value nvarchar(1000))
	INSERT INTO #table_oa
	SELECT
	s_oa.attribute_value
	FROM fnSnapshot_objectattributes_get_unique(0,@attribute_names,@char_separator) s_oa
    
    CREATE TABLE #table_id_oa (id_object bigint, attribute_value nvarchar(1000))
	INSERT INTO #table_id_oa
	SELECT
	o.id,
	dbo.fnSnapshot_objectid_attributes(o.id,@attribute_names,@char_separator)
	FROM Objects o
	WHERE o.id_snapshot = @id_snapshot_l
	AND (dbo.fnSnapshot_objectid_attributes(o.id,@attribute_names,@char_separator) = @attribute_values OR @attribute_values IS NULL)
    
    CREATE CLUSTERED INDEX i_oa_id ON #table_id_oa(id_object)

	SELECT
	oa.attribute_value AS 'role',

	(SELECT COUNT(*) FROM #table_id_oa oa_count 
		WHERE oa_count.attribute_value = oa.attribute_value) AS '# of objects',

	CASE @include_child_objects
	WHEN 1 THEN
	STUFF((SELECT ',' + dbo.fnSnapshot_objectid_show(oa_objects.id_object)
		FROM #table_id_oa oa_objects 
		WHERE oa_objects.attribute_value = oa.attribute_value
		ORDER BY dbo.fnSnapshot_objectid_show(oa_objects.id_object)
		FOR XML PATH('')),1,1,'')
	WHEN 0 THEN
	'n/a'
	END AS 'objects',
	
	STUFF((SELECT ',' +
		dbo.fnSnapshot_objectid_show(r.id_object_parent) 
		FROM Relationships r
		INNER JOIN #table_id_oa oa_relationships ON oa_relationships.attribute_value = oa.attribute_value
			AND oa_relationships.id_object = r.id_object_child
		WHERE r.id_type = @id_type_r
		GROUP BY r.id_object_parent
		HAVING ROUND(CONVERT(float, COUNT(oa_relationships.attribute_value)) / CONVERT(float,(SELECT COUNT(*) FROM #table_id_oa oa_count 
		WHERE oa_count.attribute_value = oa.attribute_value)) * 100, 2) > @min_relationship_percentage		
		ORDER BY COUNT(oa_relationships.attribute_value) DESC
		FOR XML PATH('')),1,1,'') AS 'relationships',
	
	CASE @include_child_objects_ex
	WHEN 1 THEN
	STUFF((SELECT ',' +
		dbo.fnSnapshot_objectid_show(r.id_object_parent) + ':' + 
		CONVERT(nvarchar,COUNT(oa_relationships.attribute_value)) + '/' +
		CONVERT(nvarchar,(SELECT COUNT(*) FROM #table_id_oa oa_count 
		WHERE oa_count.attribute_value = oa.attribute_value)) + '(' +
		CONVERT(nvarchar,ROUND(CONVERT(float, COUNT(oa_relationships.attribute_value)) / CONVERT(float,(SELECT COUNT(*) FROM #table_id_oa oa_count 
		WHERE oa_count.attribute_value = oa.attribute_value)) * 100, 2)) + '%)' + '(ex:' +
	
		ISNULL(STUFF((SELECT ',' +
		dbo.fnSnapshot_objectid_show(oa_relationships_delta.id_object)
		FROM #table_id_oa oa_relationships_delta
		WHERE oa_relationships_delta.attribute_value = oa.attribute_value
		AND NOT oa_relationships_delta.id_object IN
		(SELECT
		r_delta.id_object_child FROM Relationships r_delta WHERE r_delta.id_object_parent = r.id_object_parent)
		AND (COUNT(oa_relationships.attribute_value) <> (SELECT COUNT(*) FROM #table_id_oa oa_count 
			WHERE oa_count.attribute_value = oa.attribute_value))		
		ORDER BY dbo.fnSnapshot_objectid_show(oa_relationships_delta.id_object)
		FOR XML PATH('')),1,1,''),'n/a') + ')'	
		
		FROM Relationships r
		INNER JOIN #table_id_oa oa_relationships ON oa_relationships.attribute_value = oa.attribute_value
			AND oa_relationships.id_object = r.id_object_child
		WHERE r.id_type = @id_type_r
		GROUP BY r.id_object_parent
		HAVING ROUND(CONVERT(float, COUNT(oa_relationships.attribute_value)) / CONVERT(float,(SELECT COUNT(*) FROM #table_id_oa oa_count 
		WHERE oa_count.attribute_value = oa.attribute_value)) * 100, 2) > @min_relationship_percentage
		ORDER BY COUNT(oa_relationships.attribute_value) DESC
		FOR XML PATH('')),1,1,'')
	WHEN 0 THEN
	STUFF((SELECT ',' +
		dbo.fnSnapshot_objectid_show(r.id_object_parent) + ':' + 
		CONVERT(nvarchar,COUNT(oa_relationships.attribute_value)) + '/' +
		CONVERT(nvarchar,(SELECT COUNT(*) FROM #table_id_oa oa_count 
		WHERE oa_count.attribute_value = oa.attribute_value)) + '(' +
		CONVERT(nvarchar,ROUND(CONVERT(float, COUNT(oa_relationships.attribute_value)) / CONVERT(float,(SELECT COUNT(*) FROM #table_id_oa oa_count 
		WHERE oa_count.attribute_value = oa.attribute_value)) * 100, 2)) + '%)'
	
		FROM Relationships r
		INNER JOIN #table_id_oa oa_relationships ON oa_relationships.attribute_value = oa.attribute_value
			AND oa_relationships.id_object = r.id_object_child
		WHERE r.id_type = @id_type_r
		GROUP BY r.id_object_parent
		HAVING ROUND(CONVERT(float, COUNT(oa_relationships.attribute_value)) / CONVERT(float,(SELECT COUNT(*) FROM #table_id_oa oa_count 
		WHERE oa_count.attribute_value = oa.attribute_value)) * 100, 2) > @min_relationship_percentage		
		ORDER BY COUNT(oa_relationships.attribute_value) DESC
		FOR XML PATH('')),1,1,'')	
	END  AS 'relationships-details'

	FROM #table_oa oa
	WHERE NOT oa.attribute_value IS NULL
	AND (SELECT COUNT(*) FROM #table_id_oa oa_count WHERE oa_count.attribute_value = oa.attribute_value) >= @min_attribute_count
	AND NOT (STUFF((SELECT ',' +
		dbo.fnSnapshot_objectid_show(r.id_object_parent) 
		FROM Relationships r
		INNER JOIN #table_id_oa oa_relationships ON oa_relationships.attribute_value = oa.attribute_value
			AND oa_relationships.id_object = r.id_object_child
		WHERE r.id_type = @id_type_r
		GROUP BY r.id_object_parent
		HAVING ROUND(CONVERT(float, COUNT(oa_relationships.attribute_value)) / CONVERT(float,(SELECT COUNT(*) FROM #table_id_oa oa_count 
		WHERE oa_count.attribute_value = oa.attribute_value)) * 100, 2) > @min_relationship_percentage		
		ORDER BY COUNT(oa_relationships.attribute_value) DESC
		FOR XML PATH('')),1,1,'')) IS NULL
	ORDER BY '# of objects' DESC
	
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_role_mining]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_role_mining]
	@attribute_names nvarchar(500),
	@min_attribute_count bigint = 0,
	@char_separator nvarchar(5) = '-'
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
    CREATE TABLE #table_oa (attribute_value nvarchar(1000))
	INSERT INTO #table_oa
	SELECT
	s_oa.attribute_value
	FROM fnSnapshot_objectattributes_get_unique(0,@attribute_names,@char_separator) s_oa
    
    CREATE TABLE #table_id_oa (id_object bigint, attribute_value nvarchar(1000))
	INSERT INTO #table_id_oa
	SELECT
	o.id,
	dbo.fnSnapshot_objectid_attributes(o.id,@attribute_names,@char_separator)
	FROM Objects o
	WHERE o.id_snapshot = @id_snapshot_l
    
    CREATE CLUSTERED INDEX i_oa_id ON #table_id_oa(id_object)

	SELECT
	oa.attribute_value AS 'role',
	
	(SELECT COUNT(*) FROM #table_id_oa oa_count 
		WHERE oa_count.attribute_value = oa.attribute_value) AS '# of objects'

	FROM #table_oa oa
	WHERE NOT oa.attribute_value IS NULL
	AND (SELECT COUNT(*) FROM #table_id_oa oa_count WHERE oa_count.attribute_value = oa.attribute_value) >= @min_attribute_count
	ORDER BY '# of objects' DESC	
	
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_relationship_delete]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_relationship_delete]
	@id_snapshot bigint = 0,
	@type nvarchar(255),
	@name_object_parent nvarchar(1000),
	@name_object_child nvarchar(1000)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @id_snapshot_l bigint
	SET @id_snapshot_l = @id_snapshot
	IF @id_snapshot_l = 0 BEGIN SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots) END
	
	DECLARE @id_object_parent bigint = dbo.fnSnapshot_objectdn_id(@name_object_parent)
	DECLARE @id_object_child bigint = dbo.fnSnapshot_objectdn_id(@name_object_child)
	DECLARE @id_type bigint = (SELECT id FROM Types WHERE name = @type)	
	
	IF @id_object_child > 0 AND @id_object_parent > 0 AND @id_type > 0 BEGIN	
		DELETE FROM Relationships 
		WHERE id_object_child = @id_object_child
		AND id_object_parent = @id_object_parent
		AND id_type = @id_type
		
		SELECT @name_object_parent
	END
	ELSE BEGIN
		SELECT 'no-relationship-deleted'
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_relationship_add]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_relationship_add]
	@id_snapshot bigint = 0,
	@type nvarchar(255),
	@name_object_parent nvarchar(1000),
	@name_object_child nvarchar(1000)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @id_snapshot_l bigint
	SET @id_snapshot_l = @id_snapshot
	IF @id_snapshot_l = 0 BEGIN SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots) END
	
	DECLARE @id_object_parent bigint = dbo.fnSnapshot_objectdn_id(@name_object_parent)
	DECLARE @id_object_child bigint = dbo.fnSnapshot_objectdn_id(@name_object_child)
	DECLARE @id_type bigint = (SELECT id FROM Types WHERE name = @type)
	DECLARE @id_relationship bigint = (SELECT id FROM Relationships WHERE id_object_child = @id_object_child AND id_object_parent = @id_object_parent AND id_type = @id_type)
	
	IF @id_relationship IS NULL AND @id_object_child > 0 AND @id_object_parent > 0 AND @id_type > 0 BEGIN	
		INSERT INTO Relationships (id_type, id_object_parent, id_object_child)
		VALUES (@id_type, @id_object_parent, @id_object_child)
		SELECT @name_object_parent
	END
	ELSE BEGIN
		SELECT 'no-relationship-added'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_objects_get_delta]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_objects_get_delta]
	@id_snapshot bigint,
	@id_snapshot_delta bigint
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @id_snapshot_l bigint = @id_snapshot
	DECLARE @id_snapshot_delta_l bigint = @id_snapshot_delta

	SELECT
	o.id,
	dbo.fnSnapshot_objectid_key(o.id),
	dbo.fnSnapshot_objectid_show(o.id),
	dbo.fnSnapshot_sourceid_name(o.id_source),
	dbo.fnSnapshot_typeid_name(o.id_type)	
	FROM Objects o
	WHERE o.id_snapshot = @id_snapshot_l
	AND NOT dbo.fnSnapshot_objectid_key(o.id) IN
	(SELECT dbo.fnSnapshot_objectid_key(o_delta.id) 
	FROM Objects o_delta
	WHERE o_delta.id_snapshot = @id_snapshot_delta_l)

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_objects_add_staging]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_objects_add_staging]
	@id_snapshot bigint,
	@type nvarchar(255),
	@source nvarchar(255),
	@column_index_key int = 0,
	@column_index_show int = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint = @id_snapshot
	IF @id_snapshot_l = 0 SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots)

	DECLARE @id_object bigint
	DECLARE @id_type bigint
	DECLARE @id_source bigint

	EXEC spSnapshot_source_get @source, @id_source OUTPUT
	EXEC spSnapshot_type_get @type, @id_type OUTPUT
	
    CREATE TABLE #table_oa_key (id_object bigint, attribute_value nvarchar(1000))
	INSERT INTO #table_oa_key
	SELECT
	o_a.id_object,
	o_a.attribute_value
	FROM ObjectAttributes o_a
	INNER JOIN Objects o ON o.id = o_a.id_object
	WHERE o_a.is_key = 1
	AND o.id_snapshot = @id_snapshot_l
    
    CREATE CLUSTERED INDEX i_oa_id ON #table_oa_key(id_object)

	DECLARE @attribute_name_0 nvarchar(255)
	DECLARE @attribute_name_1 nvarchar(255)
	DECLARE @attribute_name_2 nvarchar(255)
	DECLARE @attribute_name_3 nvarchar(255)
	DECLARE @attribute_name_4 nvarchar(255)
	DECLARE @attribute_name_5 nvarchar(255)
	DECLARE @attribute_name_6 nvarchar(255)
	DECLARE @attribute_name_7 nvarchar(255)
	DECLARE @attribute_name_8 nvarchar(255)
	DECLARE @attribute_name_9 nvarchar(255)
	DECLARE @attribute_name_10 nvarchar(255)
	DECLARE @attribute_name_11 nvarchar(255)
	DECLARE @attribute_name_12 nvarchar(255)
	DECLARE @attribute_name_13 nvarchar(255)
	DECLARE @attribute_name_14 nvarchar(255)
	DECLARE @attribute_name_15 nvarchar(255)
	DECLARE @attribute_name_16 nvarchar(255)
	DECLARE @attribute_name_17 nvarchar(255)
	DECLARE @attribute_name_18 nvarchar(255)
	DECLARE @attribute_name_19 nvarchar(255)
	DECLARE @attribute_name_20 nvarchar(255)
	DECLARE @attribute_name_21 nvarchar(255)
	DECLARE @attribute_name_22 nvarchar(255)
	DECLARE @attribute_name_23 nvarchar(255)
	DECLARE @attribute_name_24 nvarchar(255)
	DECLARE @attribute_name_25 nvarchar(255)
	DECLARE @attribute_name_26 nvarchar(255)
	DECLARE @attribute_name_27 nvarchar(255)
	DECLARE @attribute_name_28 nvarchar(255)
	DECLARE @attribute_name_29 nvarchar(255)
	DECLARE @attribute_name_30 nvarchar(255)	
	DECLARE @attribute_name_31 nvarchar(255)
	DECLARE @attribute_name_32 nvarchar(255)
	DECLARE @attribute_name_33 nvarchar(255)
	DECLARE @attribute_name_34 nvarchar(255)
	DECLARE @attribute_name_35 nvarchar(255)
	DECLARE @attribute_name_36 nvarchar(255)
	DECLARE @attribute_name_37 nvarchar(255)
	DECLARE @attribute_name_38 nvarchar(255)
	DECLARE @attribute_name_39 nvarchar(255)
	DECLARE @attribute_name_40 nvarchar(255)
	DECLARE @attribute_name_41 nvarchar(255)
	DECLARE @attribute_name_42 nvarchar(255)
	DECLARE @attribute_name_43 nvarchar(255)
	DECLARE @attribute_name_44 nvarchar(255)
	DECLARE @attribute_name_45 nvarchar(255)
	DECLARE @attribute_name_46 nvarchar(255)
	DECLARE @attribute_name_47 nvarchar(255)
	DECLARE @attribute_name_48 nvarchar(255)
	DECLARE @attribute_name_49 nvarchar(255)
	DECLARE @attribute_name_50 nvarchar(255)
	DECLARE @attribute_name_51 nvarchar(255)
	DECLARE @attribute_name_52 nvarchar(255)
	DECLARE @attribute_name_53 nvarchar(255)
	DECLARE @attribute_name_54 nvarchar(255)
	DECLARE @attribute_name_55 nvarchar(255)
	DECLARE @attribute_name_56 nvarchar(255)
	DECLARE @attribute_name_57 nvarchar(255)
	DECLARE @attribute_name_58 nvarchar(255)
	DECLARE @attribute_name_59 nvarchar(255)
	DECLARE @attribute_name_60 nvarchar(255)	
	DECLARE @attribute_name_61 nvarchar(255)
	DECLARE @attribute_name_62 nvarchar(255)
	DECLARE @attribute_name_63 nvarchar(255)
	DECLARE @attribute_name_64 nvarchar(255)
	DECLARE @attribute_name_65 nvarchar(255)
	DECLARE @attribute_name_66 nvarchar(255)
	DECLARE @attribute_name_67 nvarchar(255)
	DECLARE @attribute_name_68 nvarchar(255)
	DECLARE @attribute_name_69 nvarchar(255)
	DECLARE @attribute_name_70 nvarchar(255)
	DECLARE @attribute_name_71 nvarchar(255)
	DECLARE @attribute_name_72 nvarchar(255)
	DECLARE @attribute_name_73 nvarchar(255)
	DECLARE @attribute_name_74 nvarchar(255)
	DECLARE @attribute_name_75 nvarchar(255)
	DECLARE @attribute_name_76 nvarchar(255)
	DECLARE @attribute_name_77 nvarchar(255)
	DECLARE @attribute_name_78 nvarchar(255)
	DECLARE @attribute_name_79 nvarchar(255)
	DECLARE @attribute_name_80 nvarchar(255)
	
	DECLARE @id_attribute_0 bigint
	DECLARE @id_attribute_1 bigint
	DECLARE @id_attribute_2 bigint
	DECLARE @id_attribute_3 bigint
	DECLARE @id_attribute_4 bigint
	DECLARE @id_attribute_5 bigint
	DECLARE @id_attribute_6 bigint
	DECLARE @id_attribute_7 bigint
	DECLARE @id_attribute_8 bigint
	DECLARE @id_attribute_9 bigint
	DECLARE @id_attribute_10 bigint
	DECLARE @id_attribute_11 bigint
	DECLARE @id_attribute_12 bigint
	DECLARE @id_attribute_13 bigint
	DECLARE @id_attribute_14 bigint
	DECLARE @id_attribute_15 bigint
	DECLARE @id_attribute_16 bigint
	DECLARE @id_attribute_17 bigint
	DECLARE @id_attribute_18 bigint
	DECLARE @id_attribute_19 bigint
	DECLARE @id_attribute_20 bigint
	DECLARE @id_attribute_21 bigint
	DECLARE @id_attribute_22 bigint
	DECLARE @id_attribute_23 bigint
	DECLARE @id_attribute_24 bigint
	DECLARE @id_attribute_25 bigint
	DECLARE @id_attribute_26 bigint
	DECLARE @id_attribute_27 bigint
	DECLARE @id_attribute_28 bigint
	DECLARE @id_attribute_29 bigint
	DECLARE @id_attribute_30 bigint	
	DECLARE @id_attribute_31 bigint
	DECLARE @id_attribute_32 bigint
	DECLARE @id_attribute_33 bigint
	DECLARE @id_attribute_34 bigint
	DECLARE @id_attribute_35 bigint
	DECLARE @id_attribute_36 bigint
	DECLARE @id_attribute_37 bigint
	DECLARE @id_attribute_38 bigint
	DECLARE @id_attribute_39 bigint
	DECLARE @id_attribute_40 bigint
	DECLARE @id_attribute_41 bigint
	DECLARE @id_attribute_42 bigint
	DECLARE @id_attribute_43 bigint
	DECLARE @id_attribute_44 bigint
	DECLARE @id_attribute_45 bigint
	DECLARE @id_attribute_46 bigint
	DECLARE @id_attribute_47 bigint
	DECLARE @id_attribute_48 bigint
	DECLARE @id_attribute_49 bigint
	DECLARE @id_attribute_50 bigint
	DECLARE @id_attribute_51 bigint
	DECLARE @id_attribute_52 bigint
	DECLARE @id_attribute_53 bigint
	DECLARE @id_attribute_54 bigint
	DECLARE @id_attribute_55 bigint
	DECLARE @id_attribute_56 bigint
	DECLARE @id_attribute_57 bigint
	DECLARE @id_attribute_58 bigint
	DECLARE @id_attribute_59 bigint
	DECLARE @id_attribute_60 bigint	
	DECLARE @id_attribute_61 bigint
	DECLARE @id_attribute_62 bigint
	DECLARE @id_attribute_63 bigint
	DECLARE @id_attribute_64 bigint
	DECLARE @id_attribute_65 bigint
	DECLARE @id_attribute_66 bigint
	DECLARE @id_attribute_67 bigint
	DECLARE @id_attribute_68 bigint
	DECLARE @id_attribute_69 bigint
	DECLARE @id_attribute_70 bigint	
	DECLARE @id_attribute_71 bigint
	DECLARE @id_attribute_72 bigint
	DECLARE @id_attribute_73 bigint
	DECLARE @id_attribute_74 bigint
	DECLARE @id_attribute_75 bigint
	DECLARE @id_attribute_76 bigint
	DECLARE @id_attribute_77 bigint
	DECLARE @id_attribute_78 bigint
	DECLARE @id_attribute_79 bigint
	DECLARE @id_attribute_80 bigint	
	
	DECLARE @attribute_value_0 nvarchar(MAX)
	DECLARE @attribute_value_1 nvarchar(MAX)
	DECLARE @attribute_value_2 nvarchar(MAX)
	DECLARE @attribute_value_3 nvarchar(MAX)
	DECLARE @attribute_value_4 nvarchar(MAX)
	DECLARE @attribute_value_5 nvarchar(MAX)
	DECLARE @attribute_value_6 nvarchar(MAX)
	DECLARE @attribute_value_7 nvarchar(MAX)
	DECLARE @attribute_value_8 nvarchar(MAX)
	DECLARE @attribute_value_9 nvarchar(MAX)
	DECLARE @attribute_value_10 nvarchar(MAX)
	DECLARE @attribute_value_11 nvarchar(MAX)
	DECLARE @attribute_value_12 nvarchar(MAX)
	DECLARE @attribute_value_13 nvarchar(MAX)
	DECLARE @attribute_value_14 nvarchar(MAX)
	DECLARE @attribute_value_15 nvarchar(MAX)
	DECLARE @attribute_value_16 nvarchar(MAX)
	DECLARE @attribute_value_17 nvarchar(MAX)
	DECLARE @attribute_value_18 nvarchar(MAX)
	DECLARE @attribute_value_19 nvarchar(MAX)
	DECLARE @attribute_value_20 nvarchar(MAX)
	DECLARE @attribute_value_21 nvarchar(MAX)
	DECLARE @attribute_value_22 nvarchar(MAX)
	DECLARE @attribute_value_23 nvarchar(MAX)
	DECLARE @attribute_value_24 nvarchar(MAX)
	DECLARE @attribute_value_25 nvarchar(MAX)
	DECLARE @attribute_value_26 nvarchar(MAX)
	DECLARE @attribute_value_27 nvarchar(MAX)
	DECLARE @attribute_value_28 nvarchar(MAX)
	DECLARE @attribute_value_29 nvarchar(MAX)
	DECLARE @attribute_value_30 nvarchar(MAX)
	DECLARE @attribute_value_31 nvarchar(MAX)
	DECLARE @attribute_value_32 nvarchar(MAX)
	DECLARE @attribute_value_33 nvarchar(MAX)
	DECLARE @attribute_value_34 nvarchar(MAX)
	DECLARE @attribute_value_35 nvarchar(MAX)
	DECLARE @attribute_value_36 nvarchar(MAX)
	DECLARE @attribute_value_37 nvarchar(MAX)
	DECLARE @attribute_value_38 nvarchar(MAX)
	DECLARE @attribute_value_39 nvarchar(MAX)
	DECLARE @attribute_value_40 nvarchar(MAX)
	DECLARE @attribute_value_41 nvarchar(MAX)
	DECLARE @attribute_value_42 nvarchar(MAX)
	DECLARE @attribute_value_43 nvarchar(MAX)
	DECLARE @attribute_value_44 nvarchar(MAX)
	DECLARE @attribute_value_45 nvarchar(MAX)
	DECLARE @attribute_value_46 nvarchar(MAX)
	DECLARE @attribute_value_47 nvarchar(MAX)
	DECLARE @attribute_value_48 nvarchar(MAX)
	DECLARE @attribute_value_49 nvarchar(MAX)
	DECLARE @attribute_value_50 nvarchar(MAX)
	DECLARE @attribute_value_51 nvarchar(MAX)
	DECLARE @attribute_value_52 nvarchar(MAX)
	DECLARE @attribute_value_53 nvarchar(MAX)
	DECLARE @attribute_value_54 nvarchar(MAX)
	DECLARE @attribute_value_55 nvarchar(MAX)
	DECLARE @attribute_value_56 nvarchar(MAX)
	DECLARE @attribute_value_57 nvarchar(MAX)
	DECLARE @attribute_value_58 nvarchar(MAX)
	DECLARE @attribute_value_59 nvarchar(MAX)
	DECLARE @attribute_value_60 nvarchar(MAX)
	DECLARE @attribute_value_61 nvarchar(MAX)
	DECLARE @attribute_value_62 nvarchar(MAX)
	DECLARE @attribute_value_63 nvarchar(MAX)
	DECLARE @attribute_value_64 nvarchar(MAX)
	DECLARE @attribute_value_65 nvarchar(MAX)
	DECLARE @attribute_value_66 nvarchar(MAX)
	DECLARE @attribute_value_67 nvarchar(MAX)
	DECLARE @attribute_value_68 nvarchar(MAX)
	DECLARE @attribute_value_69 nvarchar(MAX)
	DECLARE @attribute_value_70 nvarchar(MAX)
	DECLARE @attribute_value_71 nvarchar(MAX)
	DECLARE @attribute_value_72 nvarchar(MAX)
	DECLARE @attribute_value_73 nvarchar(MAX)
	DECLARE @attribute_value_74 nvarchar(MAX)
	DECLARE @attribute_value_75 nvarchar(MAX)
	DECLARE @attribute_value_76 nvarchar(MAX)
	DECLARE @attribute_value_77 nvarchar(MAX)
	DECLARE @attribute_value_78 nvarchar(MAX)
	DECLARE @attribute_value_79 nvarchar(MAX)
	DECLARE @attribute_value_80 nvarchar(MAX)

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
	
	EXEC spSnapshot_attribute_get @attribute_name_0, @id_attribute_0 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_1, @id_attribute_1 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_2, @id_attribute_2 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_3, @id_attribute_3 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_4, @id_attribute_4 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_5, @id_attribute_5 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_6, @id_attribute_6 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_7, @id_attribute_7 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_8, @id_attribute_8 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_9, @id_attribute_9 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_10, @id_attribute_10 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_11, @id_attribute_11 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_12, @id_attribute_12 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_13, @id_attribute_13 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_14, @id_attribute_14 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_15, @id_attribute_15 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_16, @id_attribute_16 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_17, @id_attribute_17 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_18, @id_attribute_18 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_19, @id_attribute_19 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_20, @id_attribute_20 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_21, @id_attribute_21 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_22, @id_attribute_22 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_23, @id_attribute_23 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_24, @id_attribute_24 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_25, @id_attribute_25 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_26, @id_attribute_26 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_27, @id_attribute_27 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_28, @id_attribute_28 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_29, @id_attribute_29 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_30, @id_attribute_30 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_31, @id_attribute_31 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_32, @id_attribute_32 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_33, @id_attribute_33 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_34, @id_attribute_34 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_35, @id_attribute_35 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_36, @id_attribute_36 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_37, @id_attribute_37 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_38, @id_attribute_38 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_39, @id_attribute_39 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_40, @id_attribute_40 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_41, @id_attribute_41 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_42, @id_attribute_42 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_43, @id_attribute_43 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_44, @id_attribute_44 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_45, @id_attribute_45 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_46, @id_attribute_46 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_47, @id_attribute_47 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_48, @id_attribute_48 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_49, @id_attribute_49 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_50, @id_attribute_50 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_51, @id_attribute_51 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_52, @id_attribute_52 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_53, @id_attribute_53 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_54, @id_attribute_54 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_55, @id_attribute_55 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_56, @id_attribute_56 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_57, @id_attribute_57 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_58, @id_attribute_58 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_59, @id_attribute_59 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_60, @id_attribute_60 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_61, @id_attribute_61 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_62, @id_attribute_62 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_63, @id_attribute_63 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_64, @id_attribute_64 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_65, @id_attribute_65 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_66, @id_attribute_66 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_67, @id_attribute_67 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_68, @id_attribute_68 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_69, @id_attribute_69 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_70, @id_attribute_70 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_71, @id_attribute_71 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_72, @id_attribute_72 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_73, @id_attribute_73 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_74, @id_attribute_74 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_75, @id_attribute_75 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_76, @id_attribute_76 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_77, @id_attribute_77 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_78, @id_attribute_78 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_79, @id_attribute_79 OUTPUT
	EXEC spSnapshot_attribute_get @attribute_name_80, @id_attribute_80 OUTPUT
	
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
		IF LEN(@attribute_value_0) > 0 AND @id_source > 0 AND @id_type > 0 BEGIN
			SET @id_object = (SELECT oa_key.id_object FROM #table_oa_key oa_key
				WHERE oa_key.attribute_value = @attribute_value_0)
				
			IF @id_object > 0 BEGIN
				INSERT INTO Staging_log ([message]) VALUES ('duplicate key-value: ' + @attribute_value_0)
			END
		
			IF @id_object IS NULL BEGIN
				INSERT INTO Objects (id_snapshot, id_source, id_type) 
				VALUES (@id_snapshot_l, @id_source, @id_type)
				SET @id_object = (SELECT SCOPE_IDENTITY())
			END
			
			EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_0, @attribute_value_0, 1, 0
			EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_1, @attribute_value_1, 0, 1			

			EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_2, @attribute_value_2
			EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_3, @attribute_value_3
			EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_4, @attribute_value_4
			EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_5, @attribute_value_5
			EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_6, @attribute_value_6
			EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_7, @attribute_value_7
			EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_8, @attribute_value_8
			EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_9, @attribute_value_9
			
			IF @id_attribute_10 > 0 BEGIN
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_10, @attribute_value_10
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_11, @attribute_value_11
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_12, @attribute_value_12
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_13, @attribute_value_13
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_14, @attribute_value_14
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_15, @attribute_value_15
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_16, @attribute_value_16
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_17, @attribute_value_17
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_18, @attribute_value_18
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_19, @attribute_value_19
			END
			IF @id_attribute_20 > 0 BEGIN
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_20, @attribute_value_20
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_21, @attribute_value_21
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_22, @attribute_value_22
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_23, @attribute_value_23
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_24, @attribute_value_24
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_25, @attribute_value_25
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_26, @attribute_value_26
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_27, @attribute_value_27
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_28, @attribute_value_28
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_29, @attribute_value_29
			END
			IF @id_attribute_30 > 0 BEGIN
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_30, @attribute_value_30
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_31, @attribute_value_31
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_32, @attribute_value_32
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_33, @attribute_value_33
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_34, @attribute_value_34
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_35, @attribute_value_35
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_36, @attribute_value_36
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_37, @attribute_value_37
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_38, @attribute_value_38
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_39, @attribute_value_39
			END
			IF @id_attribute_40 > 0 BEGIN
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_40, @attribute_value_40
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_41, @attribute_value_41
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_42, @attribute_value_42
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_43, @attribute_value_43
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_44, @attribute_value_44
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_45, @attribute_value_45
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_46, @attribute_value_46
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_47, @attribute_value_47
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_48, @attribute_value_48
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_49, @attribute_value_49
			END
			IF @id_attribute_50 > 0 BEGIN
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_50, @attribute_value_50
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_51, @attribute_value_51
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_52, @attribute_value_52
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_53, @attribute_value_53
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_54, @attribute_value_54
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_55, @attribute_value_55
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_56, @attribute_value_56
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_57, @attribute_value_57
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_58, @attribute_value_58
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_59, @attribute_value_59
			END
			IF @id_attribute_60 > 0 BEGIN
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_60, @attribute_value_60
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_61, @attribute_value_61
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_62, @attribute_value_62
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_63, @attribute_value_63
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_64, @attribute_value_64
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_65, @attribute_value_65
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_66, @attribute_value_66
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_67, @attribute_value_67
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_68, @attribute_value_68
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_69, @attribute_value_69
			END
			IF @id_attribute_70 > 0 BEGIN	
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_70, @attribute_value_70
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_71, @attribute_value_71
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_72, @attribute_value_72
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_73, @attribute_value_73
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_74, @attribute_value_74
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_75, @attribute_value_75
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_76, @attribute_value_76
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_77, @attribute_value_77
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_78, @attribute_value_78
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_79, @attribute_value_79
				EXEC spSnapshot_objectattribute_add @id_object, @id_attribute_80, @attribute_value_80
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
/****** Object:  StoredProcedure [dbo].[spSnapshot_objectattributes_match]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_objectattributes_match]
	@initials nvarchar(255),
	@firstname nvarchar(255),
	@middlename_birth nvarchar(255),
	@middlename_partner nvarchar(255),
	@lastname_birth nvarchar(255),
	@lastname_partner nvarchar(255),
	@attribute_name_match nvarchar(255) = NULL, -- specify the attribute on which the names are matches (e.g. displayName)
	@attribute_name_ignore nvarchar(255) = NULL, -- specify attribute for which you want an empty value (e.g. employeeID)
	@ignore_result_string nvarchar(255) = NULL, -- specify a string you want to ignore (e.g. _adm)
	@type_object nvarchar(255) = 'user'
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
	DECLARE @id_attribute_match bigint = (SELECT a.id FROM Attributes a WHERE a.name = @attribute_name_match)
	DECLARE @id_attribute_ignore bigint = (SELECT a.id FROM Attributes a WHERE a.name = @attribute_name_ignore)
	DECLARE @match_rank TABLE (result nvarchar(1000), match_value nvarchar(400), score bigint, criteria nvarchar(400)) 

	CREATE TABLE #table_oa (id bigint, attribute_value nvarchar(1000), attribute_value_ignore nvarchar(1000))
	INSERT INTO #table_oa
	SELECT
	o.id,
	oa_match.attribute_value,
	oa_ignore.attribute_value
	FROM ObjectAttributes oa_match
	INNER JOIN Objects o ON oa_match.id_object = o.id
	LEFT JOIN ObjectAttributes oa_ignore ON oa_ignore.id_object = o.id
		AND oa_ignore.id_attribute = @id_attribute_ignore
	WHERE o.id_snapshot = @id_snapshot_l
	AND oa_match.id_attribute = @id_attribute_match
	
    CREATE CLUSTERED INDEX i_oa_key ON #table_oa(id)
    CREATE INDEX i_oa_attribute ON #table_oa(attribute_value) 

	INSERT INTO @match_rank
	SELECT DISTINCT dbo.fnSnapshot_objectid_key(oa.id), oa.attribute_value, 100, 'initials+firstname+middlename_birth+lastname_birth'
	FROM #table_oa oa
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
	AND NOT dbo.fnSnapshot_objectid_key(oa.id) LIKE '%' + @ignore_result_string + '%'
	AND (LEN(oa.attribute_value_ignore) = 0 OR oa.attribute_value_ignore IS NULL OR @attribute_name_ignore IS NULL)

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT ROW_NUMBER() OVER (ORDER BY m.score) as 'id', 
		m.result, 
		m.score, 
		m.criteria, 
		m.match_value 
		FROM @match_rank m 
		ORDER BY m.score DESC
		RETURN	
	END
	
	INSERT INTO @match_rank
	SELECT DISTINCT dbo.fnSnapshot_objectid_key(oa.id), oa.attribute_value, 100, 'initials+firstname+middlename_partner+lastname_partner'
	FROM #table_oa oa
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
	AND NOT dbo.fnSnapshot_objectid_key(oa.id) LIKE '%' + @ignore_result_string + '%'
	AND (LEN(oa.attribute_value_ignore) = 0 OR oa.attribute_value_ignore IS NULL OR @attribute_name_ignore IS NULL)

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT ROW_NUMBER() OVER (ORDER BY m.score) as 'id', 
		m.result, 
		m.score, 
		m.criteria, 
		m.match_value 
		FROM @match_rank m 
		ORDER BY m.score DESC
		RETURN	
	END

	INSERT INTO @match_rank
	SELECT DISTINCT dbo.fnSnapshot_objectid_key(oa.id), oa.attribute_value, 99, 'firstname+middlename_birth+lastname_birth'
	FROM #table_oa oa
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
	AND NOT dbo.fnSnapshot_objectid_key(oa.id) LIKE '%' + @ignore_result_string + '%'
	AND (LEN(oa.attribute_value_ignore) = 0 OR oa.attribute_value_ignore IS NULL OR @attribute_name_ignore IS NULL)

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT ROW_NUMBER() OVER (ORDER BY m.score) as 'id', 
		m.result, 
		m.score, 
		m.criteria, 
		m.match_value 
		FROM @match_rank m 
		ORDER BY m.score DESC
		RETURN	
	END
	
	INSERT INTO @match_rank
	SELECT DISTINCT dbo.fnSnapshot_objectid_key(oa.id), oa.attribute_value, 99, 'firstname+middlename_partner+lastname_partner'
	FROM #table_oa oa
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
	AND NOT dbo.fnSnapshot_objectid_key(oa.id) LIKE '%' + @ignore_result_string + '%'
	AND (LEN(oa.attribute_value_ignore) = 0 OR oa.attribute_value_ignore IS NULL OR @attribute_name_ignore IS NULL)

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT ROW_NUMBER() OVER (ORDER BY m.score) as 'id', 
		m.result, 
		m.score, 
		m.criteria, 
		m.match_value 
		FROM @match_rank m 
		ORDER BY m.score DESC
		RETURN	
	END	

	INSERT INTO @match_rank
	SELECT DISTINCT dbo.fnSnapshot_objectid_key(oa.id), oa.attribute_value, 95, 'firstname+lastname_birth+lastname_partner'
	FROM #table_oa oa
	WHERE ((oa.attribute_value LIKE '%[^a-z]' + @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @firstname))
	AND ((oa.attribute_value LIKE '%[^a-z]' + @lastname_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE @lastname_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @lastname_birth))
	AND ((oa.attribute_value LIKE '%[^a-z]' + @lastname_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE @lastname_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @lastname_partner))	
	AND LEN(@lastname_birth) > 1
	AND LEN(@lastname_partner) > 1
	AND LEN(@firstname) > 1
	AND NOT dbo.fnSnapshot_objectid_key(oa.id) LIKE '%' + @ignore_result_string + '%'
	AND (LEN(oa.attribute_value_ignore) = 0 OR oa.attribute_value_ignore IS NULL OR @attribute_name_ignore IS NULL)

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT ROW_NUMBER() OVER (ORDER BY m.score) as 'id', 
		m.result, 
		m.score, 
		m.criteria, 
		m.match_value 
		FROM @match_rank m 
		ORDER BY m.score DESC
		RETURN	
	END

	INSERT INTO @match_rank
	SELECT DISTINCT dbo.fnSnapshot_objectid_key(oa.id), oa.attribute_value, 90, 'firstname+lastname_birth'
	FROM #table_oa oa
	WHERE ((oa.attribute_value LIKE '%[^a-z]' + @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @firstname))
	AND ((oa.attribute_value LIKE '%[^a-z]' + @lastname_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE @lastname_birth + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @lastname_birth))
	AND LEN(@lastname_birth) > 1
	AND LEN(@firstname) > 1
	AND NOT dbo.fnSnapshot_objectid_key(oa.id) LIKE '%' + @ignore_result_string + '%'
	AND (LEN(oa.attribute_value_ignore) = 0 OR oa.attribute_value_ignore IS NULL OR @attribute_name_ignore IS NULL)

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT ROW_NUMBER() OVER (ORDER BY m.score) as 'id', 
		m.result, 
		m.score, 
		m.criteria, 
		m.match_value 
		FROM @match_rank m 
		ORDER BY m.score DESC
		RETURN	
	END

	INSERT INTO @match_rank
	SELECT DISTINCT dbo.fnSnapshot_objectid_key(oa.id), oa.attribute_value, 90, 'firstname+lastname_partner'
	FROM #table_oa oa
	WHERE ((oa.attribute_value LIKE '%[^a-z]' + @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE @firstname + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @firstname))
	AND ((oa.attribute_value LIKE '%[^a-z]' + @lastname_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE @lastname_partner + '[^a-z]%')
	OR (oa.attribute_value LIKE '%[^a-z]' + @lastname_partner))
	AND LEN(@lastname_partner) > 1
	AND LEN(@firstname) > 1
	AND NOT dbo.fnSnapshot_objectid_key(oa.id) LIKE '%' + @ignore_result_string + '%'
	AND (LEN(oa.attribute_value_ignore) = 0 OR oa.attribute_value_ignore IS NULL OR @attribute_name_ignore IS NULL)

	IF (SELECT COUNT(*) FROM @match_rank) > 0
	BEGIN
		SELECT ROW_NUMBER() OVER (ORDER BY m.score) as 'id', 
		m.result, 
		m.score, 
		m.criteria, 
		m.match_value 
		FROM @match_rank m 
		ORDER BY m.score DESC
		RETURN	
	END

	SELECT ROW_NUMBER() OVER (ORDER BY m.score) as 'id', 
	m.result, 
	m.score, 
	m.criteria, 
	m.match_value 
	FROM @match_rank m 
	ORDER BY m.score DESC
	RETURN	
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_objectattributes_get_delta]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_objectattributes_get_delta]
	@id_snapshot bigint,
	@id_snapshot_delta bigint
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @id_snapshot_l bigint = @id_snapshot
	DECLARE @id_snapshot_delta_l bigint = @id_snapshot_delta	
	
	SELECT
	oa.id,
	o.id,
	dbo.fnSnapshot_objectid_key(o.id),
	dbo.fnSnapshot_objectid_show(o.id),
	dbo.fnSnapshot_objectid_attributes_all(o.id),
	dbo.fnSnapshot_objectid_attributes_all(o_delta.id)
	FROM ObjectAttributes oa
	INNER JOIN Attributes a ON a.id = oa.id_attribute
	INNER JOIN Objects o ON o.id = oa.id_object
	INNER JOIN ObjectAttributes oa_delta ON oa_delta.id_attribute = oa.id_attribute
	INNER JOIN Attributes a_delta ON a_delta.id = oa_delta.id_attribute
	INNER JOIN Objects o_delta ON o_delta.id = oa_delta.id_object
	INNER JOIN ObjectAttributes oa_delta_key ON oa_delta_key.id_object = o_delta.id
		AND oa_delta_key.is_key = 1
	WHERE o.id_snapshot = @id_snapshot_l
	AND o_delta.id_snapshot = @id_snapshot_delta_l
	AND dbo.fnSnapshot_objectid_key(o.id) = dbo.fnSnapshot_objectid_key(o_delta.id)
	AND NOT oa.attribute_value = oa_delta.attribute_value

END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_objectattribute_update]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_objectattribute_update]
	@name_object nvarchar(1000),
	@name_attribute nvarchar(255),
	@value nvarchar(1000),
	@id_snapshot bigint = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	SET @id_snapshot_l = @id_snapshot
	IF @id_snapshot_l = 0 BEGIN SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots) END
	
	DECLARE @id_object bigint = dbo.fnSnapshot_objectdn_id(@name_object)
	DECLARE @id_objectattribute bigint = (SELECT id 
		FROM ObjectAttributes 
		WHERE id_object = @id_object 
		AND id_attribute IN (SELECT id FROM Attributes WHERE name = @name_attribute))
	
	IF @id_object > 0 AND @id_objectattribute > 0 AND LEN(@value) > 0 BEGIN
		UPDATE ObjectAttributes
		SET attribute_value = @value
		WHERE id = @id_objectattribute
		SELECT @value
	END
	ELSE BEGIN
		SELECT 'no-objectattribute-updated'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_object_delete]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_object_delete]
	@name_object nvarchar(1000),
	@id_snapshot bigint = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	SET @id_snapshot_l = @id_snapshot
	IF @id_snapshot_l = 0 BEGIN SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots) END
	
	DECLARE @id_object bigint = dbo.fnSnapshot_objectdn_id(@name_object)
	
	IF @id_object > 0 BEGIN
		DELETE FROM ObjectAttributes WHERE id_object = @id_object
		DELETE FROM Relationships WHERE id_object_child = @id_object
		DELETE FROM Relationships WHERE id_object_parent = @id_object
		DELETE FROM Objects WHERE id = @id_object
		SELECT @id_object
	END
	ELSE BEGIN
		SELECT 'no-object-deleted'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_table_group_attributes_managedby_users]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_table_group_attributes_managedby_users]
	@object_dn nvarchar(1000)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
	DECLARE @id_type_o_user bigint = (SELECT id FROM Types WHERE name = 'user')
	DECLARE @id_object_group bigint = dbo.fnSnapshot_objectdn_id(@object_dn)
	DECLARE @id_type_r_managedby bigint = (SELECT id FROM Types WHERE name = 'managedBy')
	DECLARE @id_object_child bigint = (SELECT r.id_object_child FROM Relationships r WHERE r.id_object_parent = @id_object_group AND id_type = @id_type_r_managedby)
	DECLARE @object_dn_child nvarchar(1000) = dbo.fnSnapshot_objectid_key(@id_object_child)
	DECLARE @id_type_r_member bigint = (SELECT id FROM Types WHERE name = 'member')	

	SELECT
	c_u.dn,
	c_u.attribute_1,
	c_u.attribute_2,
	c_u.attribute_3,
	c_u.attribute_4,
	c_u.attribute_5,
	c_u.attribute_6,
	c_u.attribute_7,
	c_u.attribute_8,
	c_u.attribute_9
	FROM Cache_table_ad c_u
	WHERE c_u.[type] = 'user' 
	AND (c_u.dn = @object_dn_child  
	OR c_u.dn IN
	(SELECT oa_key.attribute_value FROM Relationships r
	INNER JOIN ObjectAttributes oa_key ON oa_key.id_object = r.id_object_child
		AND oa_key.is_key = 1	
	INNER JOIN Objects o ON o.id = oa_key.id_object 
		AND o.id_snapshot = @id_snapshot_l
		AND o.id_type = @id_type_o_user
	WHERE r.id_object_parent = @id_object_child 
	AND r.id_type = @id_type_r_member))
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_relationships_get_delta]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_relationships_get_delta]
	@id_snapshot bigint,
	@id_snapshot_delta bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint = @id_snapshot
	DECLARE @id_snapshot_delta_l bigint = @id_snapshot_delta

	SELECT
	r.id,
	dbo.fnSnapshot_sourceid_name(o_parent.id_source),
	dbo.fnSnapshot_typeid_name(o_parent.id_type),
	dbo.fnSnapshot_objectid_key(r.id_object_parent),
	dbo.fnSnapshot_objectid_show(r.id_object_child),
	dbo.fnSnapshot_sourceid_name(o_child.id_source),
	dbo.fnSnapshot_typeid_name(o_child.id_type),
	dbo.fnSnapshot_objectid_key(r.id_object_child),
	dbo.fnSnapshot_objectid_show(r.id_object_child),
	dbo.fnSnapshot_typeid_name(r.id_type)
	FROM Relationships r
	INNER JOIN Objects o_parent ON o_parent.id = r.id_object_parent
	INNER JOIN Objects o_child ON o_child.id = r.id_object_child			
	WHERE o_parent.id_snapshot = @id_snapshot_l
	AND o_child.id_snapshot = @id_snapshot_l
	AND NOT dbo.fnSnapshot_objectid_key(r.id_object_parent) IN
	(SELECT dbo.fnSnapshot_objectid_key(r_delta.id_object_parent) 
	FROM Relationships r_delta
	INNER JOIN Objects o_parent_delta ON o_parent_delta.id = r_delta.id_object_parent
	INNER JOIN Objects o_child_delta ON o_child_delta.id = r_delta.id_object_child
	WHERE o_child_delta.id_snapshot = @id_snapshot_delta_l
	AND o_parent_delta.id_snapshot = @id_snapshot_delta_l 
	AND dbo.fnSnapshot_objectid_key(r_delta.id_object_child) = dbo.fnSnapshot_objectid_key(r.id_object_child)
	AND o_child.id_type = o_child_delta.id_type
	AND o_parent.id_type = o_parent_delta.id_type
	AND o_child.id_source = o_child_delta.id_source
	AND o_parent.id_source = o_parent_delta.id_source)

END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_enable]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_enable]
	@id_tagobject bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE TagObjects SET is_active = 1 WHERE id = @id_tagobject
	EXEC spTag_object_timer_start @id_tagobject, 'duration'
	
	SELECT @id_tagobject
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_disable]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_disable]
	@id_tagobject bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE TagObjects SET is_active = 0 WHERE id = @id_tagobject
	EXEC spTag_object_timer_end @id_tagobject, 'duration'
	
	SELECT @id_tagobject
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_permissions_active]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnTag_permissions_active]
(
	@id_tag bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @tag_permissions nvarchar(MAX)

	SELECT @tag_permissions = STUFF((SELECT ',' + '[' + t_t_p.name + ':' + ISNULL(c.sAMAccountName,t_p.name) + '(' + dbo.fnSnapshot_objectid_relationships_child(dbo.fnSnapshot_objectsid_id(c.objectSID)) + ')' + ']'
	FROM TagPermissions t_p
	INNER JOIN Types t_t_p ON t_p.id_type_permission = t_t_p.id
	LEFT JOIN Cache_table_dn_sAMAccountName c ON t_p.name = c.objectSID 
	WHERE t_p.id_tag = @id_tag
	AND t_p.is_allowed = 1
	FOR XML PATH('')),1,1,'')
	
	RETURN ISNULL(@tag_permissions,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectdn_sid]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_objectdn_sid]
(
	@object_dn nvarchar(500)
)
RETURNS nvarchar(400)
AS
BEGIN
	DECLARE @id_object bigint = (SELECT dbo.fnSnapshot_objectdn_id(@object_dn))

	DECLARE @object_sid nvarchar(400)
	SET @object_sid = (SELECT TOP 1 o_a.attribute_value 
		FROM ObjectAttributes o_a
		WHERE o_a.id_object = @id_object
		AND o_a.id_attribute = (SELECT a.id FROM Attributes a WHERE a.name = 'objectSID'))

	RETURN @object_sid
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_tags_active]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_objectid_tags_active]
(
	@id_object bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @snapshot_object_tags nvarchar(MAX)
	DECLARE @name nvarchar(1000) = (SELECT dbo.fnSnapshot_objectid_sid(@id_object))
	
	SELECT @snapshot_object_tags = STUFF((SELECT ',' + t.[description]
	FROM Tags t
	INNER JOIN TagObjects t_o ON t_o.id_tag = t.id
	WHERE t_o.is_active = 1
	AND t.is_active = 1
	AND t_o.name = @name
	FOR XML PATH('')),1,1,'')
	
	RETURN ISNULL(@snapshot_object_tags,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_tagobjects_related_active]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_objectid_tagobjects_related_active]
(
	@id_object bigint
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @snapshot_object_tags nvarchar(MAX)
	DECLARE @name nvarchar(1000) = (SELECT dbo.fnSnapshot_objectid_sid(@id_object))
	
	SELECT @snapshot_object_tags = STUFF((SELECT DISTINCT ',' + ISNULL(c.distinguishedName,t_o_related.name)
	FROM TagObjects t_o
	INNER JOIN TagObjects t_o_related ON t_o.id_tag = t_o_related.id_tag
	LEFT JOIN Cache_table_dn_sAMAccountName c ON t_o_related.name = c.objectSID
	WHERE t_o.is_active = 1
	AND t_o_related.is_active = 1
	AND t_o.name = @name
	AND t_o_related.id_type <> t_o.id_type
	FOR XML PATH('')),1,1,'')
	
	RETURN ISNULL(@snapshot_object_tags,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_tag_count_active]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSnapshot_objectid_tag_count_active]
(
	@id_object bigint
)
RETURNS bigint
AS
BEGIN
	DECLARE @snapshot_object_tag_count bigint = 0
	DECLARE @name nvarchar(1000) = (SELECT dbo.fnSnapshot_objectid_sid(@id_object))
	
	SELECT @snapshot_object_tag_count = (SELECT COUNT(t.id)
	FROM Tags t
	INNER JOIN TagObjects t_o ON t_o.id_tag = t.id
	WHERE t_o.is_active = 1
	AND t.is_active = 1
	AND t_o.name = @name)
	
	RETURN ISNULL(@snapshot_object_tag_count,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectattributes_get]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnSnapshot_objectattributes_get] 
(
	@id_snapshot bigint = 0,
	@attribute_names nvarchar(500) = NULL,
	@char_separator nvarchar(5) = '-'
)
RETURNS @table_result table (
	id_object bigint,
	attribute_name nvarchar(500),
	attribute_value nvarchar(1000))  
AS
BEGIN
	DECLARE @id_snapshot_l bigint
	SET @id_snapshot_l = @id_snapshot
	IF @id_snapshot_l = 0 BEGIN SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots WHERE is_finished = 1) END
	
	INSERT INTO @table_result
	SELECT
	o.id,
	REPLACE(@attribute_names,',',@char_separator),
	dbo.fnSnapshot_objectid_attributes(o.id,@attribute_names,@char_separator)
	FROM Objects o
	WHERE o.id_snapshot = @id_snapshot_l
			
	RETURN 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectattributes_count]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnSnapshot_objectattributes_count] 
(
	@id_snapshot bigint = 0,
	@attribute_names nvarchar(500) = NULL,
	@char_separator nvarchar(1) = '-'
)
RETURNS @table_result table (
	attribute_name nvarchar(500),
	attribute_value nvarchar(1000),
	count_value bigint)  
AS
BEGIN
	DECLARE @id_snapshot_l bigint
	SET @id_snapshot_l = @id_snapshot
	IF @id_snapshot_l = 0 BEGIN SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots) END
	
	INSERT INTO @table_result
	SELECT
	REPLACE(@attribute_names,',',@char_separator),
	s_oa.attribute_value,
	COUNT(s_oa.attribute_value)
	FROM fnSnapshot_objectattributes_get(0,@attribute_names,@char_separator) s_oa
	GROUP BY s_oa.attribute_value
	HAVING COUNT(s_oa.attribute_value) > 0
	
	RETURN 
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_validation_get]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_validation_get]
	@is_active bit = NULL,
	@keywords nvarchar(255) = NULL,
	@category nvarchar(255) = NULL,
	@type_permission nvarchar(50) = 'owner', --defaults to 'owner'
	@name_object nvarchar(1000) = NULL, --specify if you want to filter on a specific TagObject
	@name_permission nvarchar(1000) = NULL --required, you need to specify for which person or group you want to get the validations
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE @name_o nvarchar(255) = (SELECT dbo.fnSnapshot_objectdn_sid(@name_object))
	DECLARE @name_p nvarchar(255) = (SELECT dbo.fnSnapshot_objectdn_sid(@name_permission))
	DECLARE @id_object_p bigint = dbo.fnSnapshot_objectdn_id(@name_permission)
	
	DECLARE @id_type_p bigint
	EXEC spSnapshot_type_get @type_permission, @id_type_p OUTPUT
	DECLARE @id_type_r_member bigint
	EXEC spSnapshot_type_get 'member', @id_type_r_member OUTPUT
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	DECLARE @id_attribute_sid bigint
	EXEC spSnapshot_attribute_get 'objectSID', @id_attribute_sid OUTPUT

	SELECT
	t.id,
	t.[description],
	(SELECT MAX(t_v.validation_date) FROM TagValidation t_v WHERE t_v.id_tag = t.id) as 'last_validated_on',
	(SELECT TOP 1 dbo.fnSnapshot_objectid_show(dbo.fnSnapshot_objectsid_id(t_v.validated_by)) FROM TagValidation t_v WHERE t_v.id_tag = t.id ORDER BY t_v.validation_date DESC) as 'last_validated_by',
	(SELECT TOP 1 t_v.is_valid FROM TagValidation t_v WHERE t_v.id_tag = t.id ORDER BY t_v.validation_date DESC) as 'is_valid'
	FROM Tags t
	INNER JOIN TagPermissions t_p ON t_p.id_tag = t.id
	INNER JOIN Types t_t_p ON t_t_p.id = t_p.id_type_permission
	WHERE (t.is_active = @is_active OR @is_active IS NULL)
	AND (t.keywords IN (SELECT string_value FROM fnStringToTable(@keywords, ','))
		OR @keywords IN (SELECT string_value FROM fnStringToTable(t.keywords, ','))
		OR @keywords = t.keywords
		OR @keywords IS NULL)
	AND (t.category = @category OR @category IS NULL)
	AND (t.id IN (SELECT t_p.id_tag FROM TagPermissions t_p 
		WHERE t_p.id_type_permission = @id_type_p
		AND (t_p.name = @name_p OR @name_permission IS NULL)
		AND t_p.is_allowed = 1) OR @type_permission IS NULL)
	AND (t.id IN (SELECT t_o.id_tag FROM TagObjects t_o 
		WHERE t_o.name = @name_o
		AND (t_o.is_active = @is_active OR @is_active IS NULL)) OR @name_object IS NULL)
	AND (DATEDIFF(DAY,(SELECT MAX(t_v.validation_date) FROM TagValidation t_v WHERE t_v.id_tag = t.id),GETDATE()) >
		t.validation_interval_days OR t.validation_required = 0)
	AND (t_p.name IN
	(SELECT c.objectSID
	FROM Cache_table_dn_sAMAccountName c
	INNER JOIN ObjectAttributes oa_sid ON oa_sid.attribute_value = c.objectSID 
		AND oa_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o ON o.id = oa_sid.id_object 
		AND o.id_snapshot = @id_snapshot_l
		AND o.id_type = @id_type_o_group
	INNER JOIN Relationships s_r ON s_r.id_object_parent = o.id
		AND s_r.id_type = @id_type_r_member
	WHERE s_r.id_object_child = @id_object_p))
	AND t_t_p.name = @type_permission
	

END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_add]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_add]
	@id_tag bigint,
	@name nvarchar(1000), -- specify the name of the object (e.g. <DN>, <sAMAccountName>, AppX_AuthorizationY)
	@type_object nvarchar(50),
	@date_start datetime = NULL,
	@date_end datetime = NULL,
	@is_active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_o bigint
	EXEC spSnapshot_type_get @type_object, @id_type_o OUTPUT
	
	IF @date_start = '' BEGIN SET @date_start = NULL END
	IF @date_end = '' BEGIN SET @date_end = NULL END
	
	DECLARE @id_tagobject bigint = (SELECT TOP 1 id 
		FROM TagObjects t_o
		WHERE t_o.name = @name 
		AND t_o.id_tag = @id_tag 
		AND t_o.id_type = @id_type_o
		ORDER BY t_o.id)
	
	IF @id_tagobject > 0 BEGIN
		UPDATE TagObjects
		SET	date_start = @date_start,
		date_end = @date_end
		WHERE id = @id_tagobject
		
		EXEC spTag_object_enable @id_tagobject
		
		RETURN
	END
	
	IF @id_tagobject IS NULL BEGIN
		INSERT INTO TagObjects (id_tag, id_type, name, date_start, date_end, is_active) 
		VALUES (@id_tag, @id_type_o, @name, @date_start, @date_end, @is_active)
		SET @id_tagobject = (SELECT SCOPE_IDENTITY())
		
		EXEC spTag_object_timer_start @id_tagobject, 'duration'
		EXEC spTag_object_link @id_tagobject
		
		SELECT @id_tagobject
		
		RETURN
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_get]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_get]
	@is_active bit = NULL,
	@keywords nvarchar(400) = NULL,
	@category nvarchar(400) = NULL,
	@activity nvarchar(400) = NULL,
	@task nvarchar(400) = NULL,
	@type_permission nvarchar(50) = NULL,
	@name_object nvarchar(1000) = NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE @name nvarchar(400) = (SELECT dbo.fnSnapshot_objectdn_sid(@name_object))
	
	DECLARE @id_type_p bigint
	EXEC spSnapshot_type_get @type_permission, @id_type_p OUTPUT

	SELECT
	t.id,
	t.[description]
	FROM Tags t
	WHERE (t.is_active = @is_active OR @is_active IS NULL)
	AND (t.keywords IN (SELECT string_value FROM fnStringToTable(@keywords, ','))
		OR @keywords IN (SELECT string_value FROM fnStringToTable(t.keywords, ','))
		OR @keywords = t.keywords
		OR @keywords IS NULL)
	AND (t.category = @category OR @category IS NULL)
	AND (t.activity = @activity OR @activity IS NULL)
	AND (t.task = @task OR @task IS NULL)
	AND (t.id IN (SELECT t_p.id_tag FROM TagPermissions t_p 
		WHERE t_p.id_type_permission = @id_type_p
		AND t_p.is_allowed = 1) OR @type_permission IS NULL)
	AND (t.id IN (SELECT t_o.id_tag FROM TagObjects t_o 
		WHERE t_o.name = @name
		AND (t_o.is_active = @is_active OR @is_active IS NULL)) OR @name_object IS NULL)

END
GO
/****** Object:  StoredProcedure [dbo].[spTag_validation_add]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_validation_add]
	@id_tag bigint,
	@dn_validated_by nvarchar(1000),
	@is_valid bit = 1,
	@type nvarchar(50) = 'validate'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @name_validated_by nvarchar(400) = (SELECT dbo.fnSnapshot_objectdn_sid(@dn_validated_by))
	DECLARE @id_type bigint
	EXEC spSnapshot_type_get @type, @id_type OUTPUT
	
	IF NOT @name_validated_by IS NULL BEGIN
		INSERT INTO TagValidation (id_tag, id_type, validated_by, is_valid)
		VALUES (@id_tag, @id_type, @name_validated_by, @is_valid)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_table_users_exclusive]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_table_users_exclusive]
	@id_tag bigint,
	@name_group_exclusive nvarchar(1000),
	@tag_is_active bit = 1,
	@object_is_active bit = 1,
	@is_overdue bit = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @name_exclusive nvarchar(255) = (SELECT dbo.fnSnapshot_objectdn_sid(@name_group_exclusive))
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT

	SELECT
	c_o.dn,
	c_o.attribute_1,
	c_o.attribute_2,
	c_o.attribute_3,
	c_o.attribute_4,
	c_o.attribute_5,
	c_o.attribute_6,
	c_o.attribute_7,
	c_o.attribute_8,
	c_o.attribute_9
	FROM TagObjects t_o
	INNER JOIN Tags t ON t_o.id_tag = t.id
	INNER JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = t_o.name
	INNER JOIN Cache_table_ad c_o ON c_o.dn = c.distinguishedName
	WHERE (t_o.is_active = @object_is_active OR @object_is_active IS NULL)
	AND ((ISNULL(t_o.date_start, GETDATE() - 1000) < GETDATE() AND ISNULL(t_o.date_end, GETDATE() + 1000) > GETDATE() AND @is_overdue = 0)
	OR (ISNULL(t_o.date_end, GETDATE() + 1000) < GETDATE() AND @is_overdue = 1)
	OR @is_overdue IS NULL)
	AND t_o.id_type = @id_type_o_user
	AND (t.is_active = @tag_is_active OR @tag_is_active IS NULL)
	AND t_o.id_tag = @id_tag
	AND t_o.name NOT IN
	(SELECT t_u_delta.name FROM TagObjects t_g_delta
	INNER JOIN TagObjects t_u_delta ON t_g_delta.id_tag = t_u_delta.id_tag
	WHERE t_g_delta.id_tag <> @id_tag
	AND t_g_delta.id_type = @id_type_o_group
	AND (t_g_delta.is_active = @object_is_active OR @object_is_active IS NULL)
	AND t_u_delta.id_type = @id_type_o_user
	AND (t_u_delta.is_active = @object_is_active OR @object_is_active IS NULL)
	AND t_g_delta.name = @name_exclusive)
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_table_groups_exclusive]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_table_groups_exclusive]
	@id_tag bigint,
	@name_user_exclusive nvarchar(1000),
	@tag_is_active bit = 1,
	@object_is_active bit = 1,
	@is_overdue bit = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @name_exclusive nvarchar(255) = (SELECT dbo.fnSnapshot_objectdn_sid(@name_user_exclusive))
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT

	SELECT
	c_g.dn,
	c_g.attribute_1,
	c_g.attribute_2,
	c_g.attribute_3,
	c_g.attribute_4,
	c_g.attribute_5,
	c_g.attribute_6,
	c_g.attribute_7,
	c_g.attribute_8,
	c_g.attribute_9
	FROM TagObjects t_o
	INNER JOIN Tags t ON t_o.id_tag = t.id
	INNER JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = t_o.name
	INNER JOIN Cache_table_ad c_g ON c_g.dn = c.distinguishedName
	WHERE (t_o.is_active = @object_is_active OR @object_is_active IS NULL)
	AND ((ISNULL(t_o.date_start, GETDATE() - 1000) < GETDATE() AND ISNULL(t_o.date_end, GETDATE() + 1000) > GETDATE() AND @is_overdue = 0)
	OR (ISNULL(t_o.date_end, GETDATE() + 1000) < GETDATE() AND @is_overdue = 1)
	OR @is_overdue IS NULL)
	AND t_o.id_type = @id_type_o_group
	AND (t.is_active = @tag_is_active OR @tag_is_active IS NULL)
	AND t_o.id_tag = @id_tag
	AND t_o.name NOT IN
	(SELECT t_g_delta.name FROM TagObjects t_g_delta
	INNER JOIN TagObjects t_u_delta ON t_g_delta.id_tag = t_u_delta.id_tag
	WHERE t_g_delta.id_tag <> @id_tag
	AND t_g_delta.id_type = @id_type_o_group
	AND (t_g_delta.is_active = @object_is_active OR @object_is_active IS NULL)
	AND t_u_delta.id_type = @id_type_o_user
	AND t_u_delta.name = @name_exclusive)
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_users_not_in_tags]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_users_not_in_tags]
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT
	
	SELECT
	o.id,
	dbo.fnSnapshot_objectid_key(o.id) as 'key',
	dbo.fnSnapshot_objectid_show(o.id) as 'show'
	FROM Objects o
	INNER JOIN Snapshots s ON s.id = o.id_snapshot
	WHERE o.id_snapshot = @id_snapshot_l
	AND o.id_type = @id_type_o_user
	AND dbo.fnSnapshot_objectid_tag_count_active(o.id) = 0
	AND s.is_finished = 1
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_user_tag_count]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_user_tag_count]
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get 0, @id_snapshot_l OUTPUT
	
	DECLARE @id_type_o_user bigint
	EXEC spSnapshot_type_get 'user', @id_type_o_user OUTPUT
	
	SELECT
	o.id,
	dbo.fnSnapshot_objectid_key(o.id) as 'key',
	dbo.fnSnapshot_objectid_show(o.id) as 'show',
	dbo.fnSnapshot_objectid_tag_count_active(o.id) as 'count_tag',
	dbo.fnSnapshot_objectid_tags_active(o.id) as 'tags'
	FROM Objects o
	WHERE o.id_snapshot = @id_snapshot_l
	AND o.id_type = @id_type_o_user
	AND dbo.fnSnapshot_objectid_tag_count_active(o.id) > 0
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_overview_detailed]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_overview_detailed]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
	t.id, 
	t.[description], 
	t.keywords,
	t.category,
	t.activity,
	t.task,
	t.duration_hour,
	t.delay_hour,
	t.is_active,
	t.direct_provision,
	t.validation_required,
	t.block_pending_validation,
	t.validation_interval_days,	
	dbo.fnTag_user_count_active(t.id) as 'Users',
	dbo.fnTag_group_count_active(t.id) as 'Groups',
	dbo.fnTag_object_count_active(t.id) as 'Objects',
	dbo.fnTag_groups_active(t.id) AS 'AD-groups',
	dbo.fnTag_groups_inactive(t.id) AS 'AD-groups (disabled)',
	dbo.fnTag_objects_active(t.id) AS 'Objects',
	dbo.fnTag_objects_inactive(t.id) AS 'Objects (disabled)',
	dbo.fnTag_users_active(t.id) AS 'AD-accounts',
	dbo.fnTag_users_inactive(t.id) AS 'AD-accounts (disabled)',
	dbo.fnTag_permissions_active(t.id) AS 'Permissions',
	dbo.fnTag_permissions_direct_active(t.id) AS 'Direct-permissions',
	dbo.fnTag_timers_active(t.id) AS 'Duration (hours)',
	dbo.fnTag_timers_overdue(t.id) AS 'Overdue (hours)',
	dbo.fnTag_validation(t.id) AS 'Validation',
	dbo.fnTag_validation_overdue(t.id) AS 'Validation overdue (days)'
	FROM Tags t
	ORDER BY t.[description]
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_groups_not_in_tags]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_groups_not_in_tags]
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot bigint
	EXEC spSnapshot_get 0, @id_snapshot OUTPUT
	
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT	
	
	SELECT
	o.id,
	dbo.fnSnapshot_objectid_key(o.id) as 'key',
	dbo.fnSnapshot_objectid_show(o.id) as 'show'
	FROM Objects o
	WHERE o.id_snapshot = @id_snapshot
	AND o.id_type = @id_type_o_group
	AND dbo.fnSnapshot_objectid_tag_count_active(o.id) = 0
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_group_tag_count]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_group_tag_count]
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot bigint
	EXEC spSnapshot_get 0, @id_snapshot OUTPUT
	
	DECLARE @id_type_o_group bigint
	EXEC spSnapshot_type_get 'group', @id_type_o_group OUTPUT
	
	SELECT
	o.id,
	dbo.fnSnapshot_objectid_key(o.id) as 'key',
	dbo.fnSnapshot_objectid_show(o.id) as 'show',
	dbo.fnSnapshot_objectid_tag_count_active(o.id) as 'count_tag',
	dbo.fnSnapshot_objectid_tags_active(o.id) as 'tags'
	FROM Objects o
	WHERE o.id_snapshot = @id_snapshot
	AND o.id_type = @id_type_o_group
	AND dbo.fnSnapshot_objectid_tag_count_active(o.id) > 0
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_all]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_all]
AS
BEGIN
	EXEC spTags_report_group_tag_count
	EXEC spTags_report_groups_not_in_tags
	EXEC spTags_report_object_count_chart
	EXEC spTags_report_overview
	EXEC spTags_report_overview_chart
	EXEC spTags_report_overview_detailed
	EXEC spTags_report_relationships_duplicate
	EXEC spTags_report_relationships_not_in_tags
	EXEC spTags_report_timers_chart
	EXEC spTags_report_user_tag_count
	EXEC spTags_report_users_not_in_tags
	
	EXEC spTags_categories_get
	EXEC spTags_objects_timer_get
	EXEC spTags_relationships_snapshot_common
	EXEC spTags_relationships_snapshot_left
	EXEC spTags_relationships_snapshot_right
	EXEC spTags_table_objects
	EXEC spTags_validation_get
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_get_details]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_get_details]
	@is_active bit = NULL,
	@keywords nvarchar(400) = NULL,
	@category nvarchar(400) = NULL,
	@activity nvarchar(400) = NULL,
	@task nvarchar(400) = NULL,
	@type_permission nvarchar(50) = NULL,
	@name_object nvarchar(500) = NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE @table_tags TABLE (id bigint, [description] nvarchar(400))
	INSERT INTO @table_tags
	EXEC spTags_get @is_active, @keywords, @category, @activity, @task, @type_permission, @name_object
	
	SELECT
	t.id,
	t.[description],
	t.keywords,
	t.category,
	t.activity,
	t.task,
	t.duration_hour,
	t.delay_hour,
	t.is_active,
	t.direct_provision,
	t.validation_required,
	t.block_pending_validation,
	t.validation_interval_days,
	dbo.fnTag_user_count_active(t.id) as 'users',
	dbo.fnTag_group_count_active(t.id) as 'groups',
	dbo.fnTag_object_count_active(t.id) as 'objects'
	FROM Tags t
	INNER JOIN @table_tags t_t ON t_t.id = t.id

END
GO
/****** Object:  StoredProcedure [dbo].[spTags_objects_right]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_objects_right]
	@name_object nvarchar(1000),
	@keywords nvarchar(400) = NULL,
	@category nvarchar(400) = NULL,
	@activity nvarchar(400) = NULL,
	@task nvarchar(400) = NULL,
	@is_active bit = 1
AS
BEGIN
	-- Calculates the Tags that @name_object is assigned to other than the Tags that apply to @keywords, @category, @activity and @task
	SET NOCOUNT ON;
	
	DECLARE @table_tags TABLE (id bigint, [description] nvarchar(400))
		
	INSERT INTO @table_tags
	EXEC spTags_get @is_active,@keywords,@category,@activity,@task
	
	DECLARE @table_tags_common TABLE (id bigint, [description] nvarchar(400))
		
	INSERT INTO @table_tags_common
	EXEC spTags_get @is_active,NULL,NULL,NULL,NULL,NULL,@name_object	
		
	SELECT
	t_common.id,
	t_common.[description]
	FROM @table_tags_common t_common
	LEFT JOIN @table_tags t ON t_common.id = t.id
	WHERE t.id IS NULL
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_objects_left]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_objects_left]
	@name_object nvarchar(1000),
	@keywords nvarchar(400) = NULL,
	@category nvarchar(400) = NULL,
	@activity nvarchar(400) = NULL,
	@task nvarchar(400) = NULL,
	@is_active bit = 1
AS
BEGIN
	-- Calculates the Tags that the user should be assigned to based on @keywords, @category, @activity and @task parameters
	SET NOCOUNT ON;
	
	DECLARE @table_tags TABLE (id bigint, [description] nvarchar(400))
		
	INSERT INTO @table_tags
	EXEC spTags_get @is_active,@keywords,@category,@activity,@task
	
	DECLARE @table_tags_common TABLE (id bigint, [description] nvarchar(400))
		
	INSERT INTO @table_tags_common
	EXEC spTags_get @is_active,@keywords,@category,@activity,@task,NULL,@name_object	
	
	SELECT
	t.id,
	t.[description]
	FROM @table_tags t
	WHERE t.id NOT IN (SELECT t_common.id FROM @table_tags_common t_common)
END
GO
/****** Object:  StoredProcedure [dbo].[spSnapshot_table_relationships_report]    Script Date: 07/01/2014 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSnapshot_table_relationships_report]
	@attribute_names nvarchar(500),
	@id_snapshot bigint = 0,
	@type_relationship nvarchar(100) = NULL,
	@char_separator nvarchar(5) = '-'
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint
	EXEC spSnapshot_get @id_snapshot, @id_snapshot_l OUTPUT
	
	DECLARE @id_type_r bigint
	EXEC spSnapshot_type_get @type_relationship, @id_type_r OUTPUT	
	
	SELECT
	ROW_NUMBER() OVER (ORDER BY s_oa.attribute_value, COUNT(s_oa.attribute_value) DESC) as 'id',
	s_oa.attribute_name,
	s_oa.attribute_value,
	t_oa.count_value,
	s_oa_parent.attribute_value,
	t_o_parent.name,
	COUNT(s_oa.attribute_value) as 'count',
	ROUND(CONVERT(float, COUNT(s_oa.attribute_value)) / CONVERT(float,t_oa.count_value) * 100, 2) as 'percentage'
	FROM Relationships r
	INNER JOIN fnSnapshot_objectattributes_get(0,@attribute_names,@char_separator) s_oa ON s_oa.id_object = r.id_object_child
	INNER JOIN fnSnapshot_objectattributes_count(0,@attribute_names,@char_separator) t_oa ON t_oa.attribute_value = s_oa.attribute_value
	INNER JOIN ObjectAttributes s_oa_parent ON s_oa_parent.id_object = r.id_object_parent
		AND s_oa_parent.is_show = 1
	INNER JOIN Objects o_parent ON o_parent.id = r.id_object_parent
		AND o_parent.id_snapshot = @id_snapshot_l
	INNER JOIN Types t_o_parent ON t_o_parent.id = o_parent.id_type
	WHERE (r.id_type = @id_type_r OR @type_relationship IS NULL)
	GROUP BY s_oa.attribute_name, s_oa_parent.attribute_value, t_o_parent.name, s_oa.attribute_value, t_oa.count_value
	HAVING COUNT(s_oa.attribute_value) > 1
	ORDER BY s_oa.attribute_value, COUNT(s_oa.attribute_value) DESC
	
END
GO
/****** Object:  Default [DF_Batches_timestamp_created]    Script Date: 07/01/2014 14:39:27 ******/
ALTER TABLE [dbo].[Batches] ADD  CONSTRAINT [DF_Batches_timestamp_created]  DEFAULT (getdate()) FOR [timestamp_created]
GO
/****** Object:  Default [DF_Batches_limit_execute_run]    Script Date: 07/01/2014 14:39:27 ******/
ALTER TABLE [dbo].[Batches] ADD  CONSTRAINT [DF_Batches_limit_execute_run]  DEFAULT ((0)) FOR [limit_execute_run]
GO
/****** Object:  Default [DF_Batches_allow_auto_run]    Script Date: 07/01/2014 14:39:27 ******/
ALTER TABLE [dbo].[Batches] ADD  CONSTRAINT [DF_Batches_allow_auto_run]  DEFAULT ((0)) FOR [allow_auto_run]
GO
/****** Object:  Default [DF_Batches_closed]    Script Date: 07/01/2014 14:39:27 ******/
ALTER TABLE [dbo].[Batches] ADD  CONSTRAINT [DF_Batches_closed]  DEFAULT ((0)) FOR [closed]
GO
/****** Object:  Default [DF_NTFS2dbCollectionShares_is_active]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[NTFS2dbCollectionShares] ADD  CONSTRAINT [DF_NTFS2dbCollectionShares_is_active]  DEFAULT ((1)) FOR [is_active]
GO
/****** Object:  Default [DF_Notifications_date_created]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Notifications] ADD  CONSTRAINT [DF_Notifications_date_created]  DEFAULT (getdate()) FOR [date_created]
GO
/****** Object:  Default [DF_Notifications_is_active]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Notifications] ADD  CONSTRAINT [DF_Notifications_is_active]  DEFAULT ((1)) FOR [is_active]
GO
/****** Object:  Default [DF_Log_timestamp]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Log] ADD  CONSTRAINT [DF_Log_timestamp]  DEFAULT (getdate()) FOR [timestamp]
GO
/****** Object:  Default [DF_Log_facility_level]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Log] ADD  CONSTRAINT [DF_Log_facility_level]  DEFAULT ((0)) FOR [facility_level]
GO
/****** Object:  Default [DF_Log_level]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Log] ADD  CONSTRAINT [DF_Log_level]  DEFAULT ((0)) FOR [severity_level]
GO
/****** Object:  Default [DF_Jobs_timestamp_created]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Jobs] ADD  CONSTRAINT [DF_Jobs_timestamp_created]  DEFAULT (getdate()) FOR [timestamp_created]
GO
/****** Object:  Default [DF_Jobs_closed]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Jobs] ADD  CONSTRAINT [DF_Jobs_closed]  DEFAULT ((0)) FOR [closed]
GO
/****** Object:  Default [DF_Snapshots_timestamp]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Snapshots] ADD  CONSTRAINT [DF_Snapshots_timestamp]  DEFAULT (getdate()) FOR [timestamp_start]
GO
/****** Object:  Default [DF_Snapshots_is_finished]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Snapshots] ADD  CONSTRAINT [DF_Snapshots_is_finished]  DEFAULT ((0)) FOR [is_finished]
GO
/****** Object:  Default [DF_SecureConfig_is_active]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[SecureConfig] ADD  CONSTRAINT [DF_SecureConfig_is_active]  DEFAULT ((1)) FOR [is_active]
GO
/****** Object:  Default [DF_Staging_log_timestamp]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Staging_log] ADD  CONSTRAINT [DF_Staging_log_timestamp]  DEFAULT (getdate()) FOR [timestamp]
GO
/****** Object:  Default [DF_Tasks_timestamp_created]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Tasks] ADD  CONSTRAINT [DF_Tasks_timestamp_created]  DEFAULT (getdate()) FOR [timestamp_created]
GO
/****** Object:  Default [DF_Tasks_closed]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Tasks] ADD  CONSTRAINT [DF_Tasks_closed]  DEFAULT ((0)) FOR [closed]
GO
/****** Object:  Default [DF_TagValidation_validation_date]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[TagValidation] ADD  CONSTRAINT [DF_TagValidation_validation_date]  DEFAULT (getdate()) FOR [validation_date]
GO
/****** Object:  Default [DF_TagValidation_is_valid]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[TagValidation] ADD  CONSTRAINT [DF_TagValidation_is_valid]  DEFAULT ((1)) FOR [is_valid]
GO
/****** Object:  Default [DF_Tags_date_created]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Tags] ADD  CONSTRAINT [DF_Tags_date_created]  DEFAULT (getdate()) FOR [date_created]
GO
/****** Object:  Default [DF_Tags_duration_hour]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Tags] ADD  CONSTRAINT [DF_Tags_duration_hour]  DEFAULT ((0)) FOR [duration_hour]
GO
/****** Object:  Default [DF_Tags_delay_hour]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Tags] ADD  CONSTRAINT [DF_Tags_delay_hour]  DEFAULT ((0)) FOR [delay_hour]
GO
/****** Object:  Default [DF_Tags_is_active]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Tags] ADD  CONSTRAINT [DF_Tags_is_active]  DEFAULT ((1)) FOR [is_active]
GO
/****** Object:  Default [DF_Tags_direct_provision]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Tags] ADD  CONSTRAINT [DF_Tags_direct_provision]  DEFAULT ((1)) FOR [direct_provision]
GO
/****** Object:  Default [DF_Tags_validation_required]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Tags] ADD  CONSTRAINT [DF_Tags_validation_required]  DEFAULT ((0)) FOR [validation_required]
GO
/****** Object:  Default [DF_Tags_block_pending_validation]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Tags] ADD  CONSTRAINT [DF_Tags_block_pending_validation]  DEFAULT ((0)) FOR [block_pending_validation]
GO
/****** Object:  Default [DF_Tags_validation_interval_days]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[Tags] ADD  CONSTRAINT [DF_Tags_validation_interval_days]  DEFAULT ((0)) FOR [validation_interval_days]
GO
/****** Object:  Default [DF_TagPermissions_date_added]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[TagPermissions] ADD  CONSTRAINT [DF_TagPermissions_date_added]  DEFAULT (getdate()) FOR [date_created]
GO
/****** Object:  Default [DF_TagPermissions_is_allowed]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[TagPermissions] ADD  CONSTRAINT [DF_TagPermissions_is_allowed]  DEFAULT ((1)) FOR [is_allowed]
GO
/****** Object:  Default [DF_TagObjects_date_added]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[TagObjects] ADD  CONSTRAINT [DF_TagObjects_date_added]  DEFAULT (getdate()) FOR [date_created]
GO
/****** Object:  Default [DF_TagObjects_is_active]    Script Date: 07/01/2014 14:39:28 ******/
ALTER TABLE [dbo].[TagObjects] ADD  CONSTRAINT [DF_TagObjects_is_active]  DEFAULT ((1)) FOR [is_active]
GO
/****** Object:  Default [DF_ObjectAttributes_is_key]    Script Date: 07/01/2014 14:39:33 ******/
ALTER TABLE [dbo].[ObjectAttributes] ADD  CONSTRAINT [DF_ObjectAttributes_is_key]  DEFAULT ((0)) FOR [is_key]
GO
/****** Object:  Default [DF_ObjectAttributes_is_show]    Script Date: 07/01/2014 14:39:33 ******/
ALTER TABLE [dbo].[ObjectAttributes] ADD  CONSTRAINT [DF_ObjectAttributes_is_show]  DEFAULT ((0)) FOR [is_show]
GO
/****** Object:  ForeignKey [FK_Relationships_Objects]    Script Date: 07/01/2014 14:39:33 ******/
ALTER TABLE [dbo].[Relationships]  WITH CHECK ADD  CONSTRAINT [FK_Relationships_Objects] FOREIGN KEY([id_object_parent])
REFERENCES [dbo].[Objects] ([id])
GO
ALTER TABLE [dbo].[Relationships] CHECK CONSTRAINT [FK_Relationships_Objects]
GO
/****** Object:  ForeignKey [FK_Relationships_Objects1]    Script Date: 07/01/2014 14:39:33 ******/
ALTER TABLE [dbo].[Relationships]  WITH CHECK ADD  CONSTRAINT [FK_Relationships_Objects1] FOREIGN KEY([id_object_child])
REFERENCES [dbo].[Objects] ([id])
GO
ALTER TABLE [dbo].[Relationships] CHECK CONSTRAINT [FK_Relationships_Objects1]
GO
/****** Object:  ForeignKey [FK_ObjectAttributes_Attributes]    Script Date: 07/01/2014 14:39:33 ******/
ALTER TABLE [dbo].[ObjectAttributes]  WITH CHECK ADD  CONSTRAINT [FK_ObjectAttributes_Attributes] FOREIGN KEY([id_attribute])
REFERENCES [dbo].[Attributes] ([id])
GO
ALTER TABLE [dbo].[ObjectAttributes] CHECK CONSTRAINT [FK_ObjectAttributes_Attributes]
GO
/****** Object:  ForeignKey [FK_ObjectAttributes_Objects]    Script Date: 07/01/2014 14:39:33 ******/
ALTER TABLE [dbo].[ObjectAttributes]  WITH CHECK ADD  CONSTRAINT [FK_ObjectAttributes_Objects] FOREIGN KEY([id_object])
REFERENCES [dbo].[Objects] ([id])
GO
ALTER TABLE [dbo].[ObjectAttributes] CHECK CONSTRAINT [FK_ObjectAttributes_Objects]
GO
