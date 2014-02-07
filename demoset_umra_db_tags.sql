USE [UMRA]
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectsid_validate]    Script Date: 02/06/2014 15:19:47 ******/
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
	@name varchar(500)
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
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_attribute_datetime]    Script Date: 02/06/2014 15:19:47 ******/
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
	@attribute_value varchar(500)
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
/****** Object:  StoredProcedure [dbo].[spTags_report_object_count_chart]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_object_count_chart]
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @cols NVARCHAR(MAX) = STUFF((
	SELECT N',' + QUOTENAME(y)
	FROM (SELECT DISTINCT t.description AS y FROM Tags t) AS Y
	ORDER BY y FOR XML PATH('')),1, 1, N'');

	DECLARE @sql NVARCHAR(MAX) = N'SELECT *
	FROM (SELECT t.description, t_o.id as qty
	FROM Tags t
	INNER JOIN TagObjects t_o ON t_o.id_tag = t.id) AS D
	PIVOT(COUNT(qty) FOR description IN(' + @cols + N')) AS P;';

	EXEC sp_executesql @sql;
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_groups_not_in_tags]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_groups_not_in_tags]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
	c_g.sAMAccountName
	FROM Cache_table_dn_sAMAccountName c_g
	INNER JOIN Cache_table_ad c ON c.dn = c_g.distinguishedName
	LEFT JOIN TagObjects t_o_g ON c_g.objectSID = t_o_g.name
		AND t_o_g.id_type = (SELECT id FROM Types WHERE name = 'group')
	LEFT JOIN Tags t ON t.id = t_o_g.id_tag
	WHERE t.id IS NULL AND c.type = 'group'
	GROUP BY c_g.sAMAccountName
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_group_tag_count]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_group_tag_count]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
	c_g.sAMAccountName,
	COUNT(t.id) 'count_tag'
	FROM Cache_table_dn_sAMAccountName c_g
	INNER JOIN TagObjects t_o_g ON c_g.objectSID = t_o_g.name
		AND t_o_g.id_type = (SELECT id FROM Types WHERE name = 'group')
	INNER JOIN Tags t ON t.id = t_o_g.id_tag
	GROUP BY c_g.sAMAccountName
	ORDER BY c_g.sAMAccountName
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_objecttimers_cleanup]    Script Date: 02/06/2014 15:19:47 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_group_count]    Script Date: 02/06/2014 15:19:47 ******/
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
		WHERE id_type = @id_type_o_group 
		AND o.id_snapshot = @id_snapshot_l)
	
	RETURN ISNULL(@snapshot_group_count,0)
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_enable]    Script Date: 02/06/2014 15:19:46 ******/
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
/****** Object:  StoredProcedure [dbo].[spTag_disable]    Script Date: 02/06/2014 15:19:46 ******/
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
/****** Object:  StoredProcedure [dbo].[spTags_categories_get]    Script Date: 02/06/2014 15:19:47 ******/
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
/****** Object:  StoredProcedure [dbo].[spTag_table_users_exclusive]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_table_users_exclusive]
	@id_tag bigint,
	@name_group_exclusive varchar(500),
	@tag_is_active bit = 1,
	@object_is_active bit = 1,
	@is_overdue bit = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @name_exclusive varchar(255) = (SELECT TOP 1 c.objectSID FROM Cache_table_dn_sAMAccountName c WHERE c.distinguishedName = @name_group_exclusive)
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')
	IF @id_type_o_group IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('group')
		SET @id_type_o_group = (SELECT SCOPE_IDENTITY())
	END		
	DECLARE @id_type_o_user bigint = (SELECT id FROM Types WHERE name = 'user')
	IF @id_type_o_user IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('user')
		SET @id_type_o_user = (SELECT SCOPE_IDENTITY())
	END		

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
/****** Object:  StoredProcedure [dbo].[spTag_table_users]    Script Date: 02/06/2014 15:19:46 ******/
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

	DECLARE @id_type_o bigint = (SELECT id FROM Types WHERE name = 'user')
	IF @id_type_o IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('user')
		SET @id_type_o = (SELECT SCOPE_IDENTITY())
	END	

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
/****** Object:  StoredProcedure [dbo].[spTag_table_permissions_direct]    Script Date: 02/06/2014 15:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_table_permissions_direct]
	@id_tag bigint,
	@type_permission varchar(255) = NULL,
	@is_allowed bit = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_p bigint = (SELECT id FROM Types WHERE name = @type_permission)
	IF @id_type_p IS NULL AND LEN(@type_permission) > 0 BEGIN
		INSERT INTO Types (name) VALUES (@type_permission)
		SET @id_type_p = (SELECT SCOPE_IDENTITY())
	END
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')
	IF @id_type_o_group IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('group')
		SET @id_type_o_group = (SELECT SCOPE_IDENTITY())
	END		
	DECLARE @id_type_o_user bigint = (SELECT id FROM Types WHERE name = 'user')
	IF @id_type_o_user IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('user')
		SET @id_type_o_user = (SELECT SCOPE_IDENTITY())
	END		

	SELECT
	t_p.id,
	t_t_p.name,
	t_t_n.name,
	t_p.name,
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
/****** Object:  StoredProcedure [dbo].[spTag_table_permissions]    Script Date: 02/06/2014 15:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_table_permissions]
	@id_tag bigint,
	@type_permission varchar(255) = NULL,
	@is_allowed bit = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_p bigint = (SELECT id FROM Types WHERE name = @type_permission)
	IF @id_type_p IS NULL AND LEN(@type_permission) > 0 BEGIN
		INSERT INTO Types (name) VALUES (@type_permission)
		SET @id_type_p = (SELECT SCOPE_IDENTITY())
	END	

	SELECT
	t_p.id,
	c_o.dn,
	c_o.attribute_1,
	c_o.attribute_2,
	c_o.attribute_3,
	c_o.attribute_4,
	c_o.attribute_5,
	c_o.attribute_6,
	c_o.attribute_7,
	c_o.attribute_8,
	c_o.attribute_9,
	t_t_p.name,
	t_p.is_allowed
	FROM TagPermissions t_p
	INNER JOIN Types t_t_p ON t_p.id_type_permission = t_t_p.id
	INNER JOIN Cache_table_dn_sAMAccountName c ON t_p.name = c.objectSID
	INNER JOIN Cache_table_ad c_o ON c_o.dn = c.distinguishedName
	AND c_o.type = 'group'
	AND (t_t_p.id = @id_type_p OR @type_permission IS NULL)
	AND (t_p.is_allowed = @is_allowed OR @is_allowed IS NULL)
	AND t_p.id_tag = @id_tag

END
GO
/****** Object:  StoredProcedure [dbo].[spTag_table_objects]    Script Date: 02/06/2014 15:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_table_objects]
	@id_tag bigint,
	@type_object varchar(255) = NULL,
	@object_is_active bit = 1,
	@is_overdue bit = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @id_type_o bigint = (SELECT id FROM Types WHERE name = @type_object)
	IF @id_type_o IS NULL AND LEN(@type_object) > 0 BEGIN
		INSERT INTO Types (name) VALUES (@type_object)
		SET @id_type_o = (SELECT SCOPE_IDENTITY())
	END	

	SELECT
	t_o.id,
	t_o.name,
	c.sAMAccountName,
	t_t_o.name,
	t_o.date_start,
	t_o.date_end
	FROM TagObjects t_o
	INNER JOIN Cache_table_dn_sAMAccountName c ON t_o.name = c.objectSID
	LEFT JOIN Types t_t_o ON t_t_o.id = t_o.id_type
	WHERE t_o.id_tag = @id_tag
	AND (t_o.is_active = @object_is_active OR @object_is_active IS NULL)
	AND (t_o.id_type = @id_type_o OR @type_object IS NULL)
	AND ((ISNULL(t_o.date_start, GETDATE() - 1000) < GETDATE() AND ISNULL(t_o.date_end, GETDATE() + 1000) > GETDATE() AND @is_overdue = 0)
	OR (ISNULL(t_o.date_end, GETDATE() + 1000) < GETDATE() AND @is_overdue = 1)
	OR @is_overdue IS NULL)	
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_table_groups_exclusive]    Script Date: 02/06/2014 15:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_table_groups_exclusive]
	@id_tag bigint,
	@name_user_exclusive varchar(500),
	@tag_is_active bit = 1,
	@object_is_active bit = 1,
	@is_overdue bit = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @name_exclusive varchar(255) = (SELECT TOP 1 c.objectSID FROM Cache_table_dn_sAMAccountName c WHERE c.distinguishedName = @name_user_exclusive)
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')
	IF @id_type_o_group IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('group')
		SET @id_type_o_group = (SELECT SCOPE_IDENTITY())
	END		
	DECLARE @id_type_o_user bigint = (SELECT id FROM Types WHERE name = 'user')
	IF @id_type_o_user IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('user')
		SET @id_type_o_user = (SELECT SCOPE_IDENTITY())
	END	

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
/****** Object:  StoredProcedure [dbo].[spTag_table_groups]    Script Date: 02/06/2014 15:19:46 ******/
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
	
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')
	IF @id_type_o_group IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('group')
		SET @id_type_o_group = (SELECT SCOPE_IDENTITY())
	END

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
/****** Object:  StoredProcedure [dbo].[spTag_save]    Script Date: 02/06/2014 15:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_save]
	@description varchar(255),
	@keywords varchar(MAX),
	@category varchar(255),
	@duration_hour int = 0,
	@delay_hour int = 0,
	@is_active bit = 1,
	@direct_provision bit = 1,
	@id bigint = 0,
	@id_template bigint = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @id > 0 BEGIN
		UPDATE Tags 
		SET [description] = @description,
		keywords = @keywords,
		category = @category,
		duration_hour = @duration_hour,
		delay_hour = @delay_hour,
		is_active = @is_active,
		direct_provision = @direct_provision
		WHERE id = @id

		SELECT @id AS 'id_tag'
	END
	ELSE BEGIN
		INSERT INTO Tags (description, keywords, category, is_active, direct_provision, duration_hour, delay_hour) 
		VALUES (@description, @keywords, @category, @is_active, @direct_provision, @duration_hour, @delay_hour)
		
		DECLARE @id_tag bigint
		SET @id_tag = (SELECT SCOPE_IDENTITY())
		
		SELECT CONVERT(varchar, @id_tag) AS 'id_tag'
		
		IF @id_template > 0 BEGIN
			INSERT INTO TagObjects (id_tag, name, id_type, date_start, date_end, is_active)
			SELECT
			@id_tag,
			t_o.name,
			t_o.id_type,
			t_o.date_start,
			t_o.date_end,
			t_o.is_active
			FROM TagObjects t_o
			WHERE t_o.id_tag = @id_template
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_permission_remove]    Script Date: 02/06/2014 15:19:46 ******/
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
		SELECT @id_tagpermission
	END
	ELSE BEGIN
		SELECT '0' AS 'id_tagpermission'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_permission_add_direct]    Script Date: 02/06/2014 15:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_permission_add_direct]
	@id_tag bigint,
	@type_permission varchar(255),
	@type_name varchar(500),
	@name_input varchar(500),
	@is_allowed bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_p bigint = (SELECT id FROM Types WHERE name = @type_permission)
	IF @id_type_p IS NULL BEGIN
		INSERT INTO Types (name) VALUES (@type_permission)
		SET @id_type_p = (SELECT SCOPE_IDENTITY())
	END
	
	DECLARE @id_type_n bigint = (SELECT id FROM Types WHERE name = @type_name)
	IF @id_type_n IS NULL BEGIN
		INSERT INTO Types (name) VALUES (@type_name)
		SET @id_type_n = (SELECT SCOPE_IDENTITY())
	END
	
	DECLARE @id_tagpermission bigint = (SELECT t_p.id 
		FROM TagPermissions t_p
		WHERE t_p.name = @name_input
		AND t_p.id_tag = @id_tag
		AND t_p.id_type_permission = @id_type_p
		AND t_p.id_type_name = @id_type_n
		AND t_p.is_allowed = @is_allowed)

	IF @id_tag > 0 AND @id_tagpermission IS NULL AND LEN(@name_input) > 0 AND @id_type_p > 0 AND @id_type_n > 0 BEGIN
		INSERT INTO TagPermissions (id_tag, id_type_permission, id_type_name, name, is_allowed) 
		VALUES (@id_tag, @id_type_p, @id_type_n, @name_input, @is_allowed)
		SELECT CONVERT(VARCHAR, SCOPE_IDENTITY()) AS 'id_tagpermission'
	END
	SELECT 'not-created'
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_permission_add]    Script Date: 02/06/2014 15:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_permission_add]
	@id_tag bigint,
	@type_permission varchar(255),
	@type_name varchar(500),
	@name_input varchar(500),
	@is_allowed bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_p bigint = (SELECT id FROM Types WHERE name = @type_permission)
	IF @id_type_p IS NULL BEGIN
		INSERT INTO Types (name) VALUES (@type_permission)
		SET @id_type_p = (SELECT SCOPE_IDENTITY())
	END
	
	DECLARE @id_type_n bigint = (SELECT id FROM Types WHERE name = @type_name)
	IF @id_type_n IS NULL BEGIN
		INSERT INTO Types (name) VALUES (@type_name)
		SET @id_type_n = (SELECT SCOPE_IDENTITY())
	END
	
	DECLARE @name varchar(255) = (SELECT TOP 1 objectSID FROM Cache_table_dn_sAMAccountName WHERE distinguishedName = @name_input)	
	
	IF @name IS NULL BEGIN
		SET @name = @name_input
	END
	
	DECLARE @id_tagpermission bigint = (SELECT t_p.id 
		FROM TagPermissions t_p
		WHERE t_p.name = @name
		AND t_p.id_tag = @id_tag
		AND t_p.id_type_permission = @id_type_p
		AND t_p.id_type_name = @id_type_n
		AND t_p.is_allowed = @is_allowed)

	IF @id_tag > 0 AND @id_tagpermission IS NULL AND LEN(@name) > 0 AND @id_type_p > 0 AND @id_type_n > 0 BEGIN
		INSERT INTO TagPermissions (id_tag, id_type_permission, id_type_name, name, is_allowed) 
		VALUES (@id_tag, @id_type_p, @id_type_n, @name, @is_allowed)
		SELECT CONVERT(VARCHAR, SCOPE_IDENTITY()) AS 'id_tagpermission'
	END
	SELECT 'not-created'
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_objects_timer_get]    Script Date: 02/06/2014 15:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_objects_timer_get]
	@id_tag bigint,
	@type_object varchar(50) = NULL,
	@type_timer varchar(50) = NULL,
	@is_overdue bit = 0,
	@object_is_active bit = 1,
	@tag_is_active bit = 1
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE @id_type_t bigint = (SELECT id FROM Types WHERE name = @type_timer)
	IF @id_type_t IS NULL AND LEN(@type_timer) > 0 BEGIN
		INSERT INTO Types (name) VALUES (@type_timer)
		SET @id_type_t = (SELECT SCOPE_IDENTITY())
	END	
	DECLARE @id_type_o bigint = (SELECT id FROM Types WHERE name = @type_object)
	IF @id_type_o IS NULL AND LEN(@type_object) > 0 BEGIN
		INSERT INTO Types (name) VALUES (@type_object)
		SET @id_type_o = (SELECT SCOPE_IDENTITY())
	END		

	SELECT DISTINCT
	t_o_t.id, 
	c_o.attribute_1,
	c_o.attribute_2,
	c_o.attribute_3,
	c_o.attribute_4,
	c_o.attribute_5,
	c_o.attribute_6,
	c_o.attribute_7,
	c_o.attribute_8,
	c_o.attribute_9,
	t_t_o_t.name,
	t.duration_hour,
	DATEDIFF(hour, t_o_t.date_start, GETDATE()) as 'duration_hour_used'
	FROM Cache_table_ad c_o
	INNER JOIN Cache_table_dn_sAMAccountName c ON c.distinguishedName = c_o.dn
	INNER JOIN TagObjects t_o ON t_o.name = c.objectSID
	INNER JOIN TagObjectTimers t_o_t ON t_o_t.id_tagobject = t_o.id
	INNER JOIN Types t_t_o_t ON t_t_o_t.id = t_o_t.id_type
	INNER JOIN Tags t ON t.id = t_o.id_tag
	WHERE (c_o.type = @type_object OR @type_object IS NULL)
	AND (t_o.id_type = @id_type_o OR @type_object IS NULL)
	AND (t_t_o_t.id = @id_type_t OR @type_timer IS NULL)
	AND (t.is_active = @tag_is_active OR @tag_is_active IS NULL)
	AND (t_o.is_active = @object_is_active OR @object_is_active IS NULL)
	AND (DATEDIFF(hour, t_o_t.date_start, GETDATE()) > t.duration_hour AND t.duration_hour > 0 OR @is_overdue = 0 OR @is_overdue IS NULL)
	AND t.id = @id_tag
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_timer_start]    Script Date: 02/06/2014 15:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_timer_start]
	@id_tagobject bigint,
	@type_timer varchar(100)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_t bigint = (SELECT id FROM Types WHERE name = @type_timer)
	IF @id_type_t IS NULL BEGIN
		INSERT INTO Types (name) VALUES (@type_timer)
		SET @id_type_t = (SELECT SCOPE_IDENTITY())
	END	
	
	DECLARE @id_tagobjecttimer bigint = (SELECT id FROM TagObjectTimers WHERE id_tagobject = @id_tagobject AND id_type = @id_type_t)
	
	IF @id_tagobject > 0 BEGIN
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
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_timer_end]    Script Date: 02/06/2014 15:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_timer_end]
	@id_tagobject bigint,
	@type_timer varchar(100)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_t bigint = (SELECT id FROM Types WHERE name = @type_timer)
	IF @id_type_t IS NULL BEGIN
		INSERT INTO Types (name) VALUES (@type_timer)
		SET @id_type_t = (SELECT SCOPE_IDENTITY())
	END	
	
	IF @id_tagobject > 0 BEGIN
		UPDATE TagObjectTimers 
		SET date_end = GETDATE() 
		WHERE id_tagobject = @id_tagobject
		AND id_type = @id_type_t
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_get]    Script Date: 02/06/2014 15:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_get]
	@id_tag bigint,
	@name_input varchar(500),
	@type_object varchar(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @name varchar(255) = (SELECT TOP 1 c.objectSID FROM Cache_table_dn_sAMAccountName c WHERE c.distinguishedName = @name_input)
	
	DECLARE @id_type_o bigint = (SELECT id FROM Types WHERE name = @type_object)
	IF @id_type_o IS NULL AND LEN(@type_object) > 0 BEGIN
		INSERT INTO Types (name) VALUES (@type_object)
		SET @id_type_o = (SELECT SCOPE_IDENTITY())
	END
				
	SELECT 
	t_o.id
	FROM TagObjects t_o
	WHERE t_o.name = @name
	AND t_o.id_tag = @id_tag
	AND (t_o.id_type = @id_type_o OR @type_object IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_table_objects]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_table_objects]
	@type_object varchar(255) = NULL,
	@tag_is_active bit = 1,
	@object_is_active bit = 1,
	@is_overdue bit = 0
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE @id_type_o bigint = (SELECT id FROM Types WHERE name = @type_object)
	IF @id_type_o IS NULL AND LEN(@type_object) > 0 BEGIN
		INSERT INTO Types (name) VALUES (@type_object)
		SET @id_type_o = (SELECT SCOPE_IDENTITY())
	END		

	SELECT
	t_o.id_tag,
	t_o.id,
	t_o.name,
	c.sAMAccountName,
	t_t_o.name,
	t_o.date_start,
	t_o.date_end
	FROM TagObjects t_o
	INNER JOIN Cache_table_dn_sAMAccountName c ON t_o.name = c.objectSID
	INNER JOIN Tags t ON t.id = t_o.id_tag
	LEFT JOIN Types t_t_o ON t_t_o.id = t_o.id_type
	WHERE (t_o.is_active = @object_is_active OR @object_is_active IS NULL)
	AND (t_o.id_type = @id_type_o OR @type_object IS NULL)
	AND (t.is_active = @tag_is_active OR @tag_is_active IS NULL)
	AND ((ISNULL(t_o.date_start, GETDATE() - 1000) < GETDATE() AND ISNULL(t_o.date_end, GETDATE() + 1000) > GETDATE() AND @is_overdue = 0)
	OR (ISNULL(t_o.date_end, GETDATE() + 1000) < GETDATE() AND @is_overdue = 1)
	OR @is_overdue IS NULL)		
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_user_tag_count]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_user_tag_count]
AS
BEGIN
	SET NOCOUNT ON;	
	
	SELECT
	c_u.sAMAccountName,
	COUNT(t.id) 'count_tag'
	FROM Cache_table_dn_sAMAccountName c_u
	INNER JOIN TagObjects t_o_u ON c_u.objectSID = t_o_u.name
		AND t_o_u.id_type = (SELECT id FROM Types WHERE name = 'user')
	INNER JOIN Tags t ON t.id = t_o_u.id_tag
	GROUP BY c_u.sAMAccountName
	ORDER BY c_u.sAMAccountName
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_timers_chart]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_timers_chart]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT COUNT(t_o_t.id) AS '>5000',
	(SELECT COUNT(t_o_t.id) FROM TagObjectTimers t_o_t WHERE DATEDIFF(hour, t_o_t.date_start, GETDATE()) BETWEEN 4000 AND 5000) AS '4000-5000',
	(SELECT COUNT(t_o_t.id) FROM TagObjectTimers t_o_t WHERE DATEDIFF(hour, t_o_t.date_start, GETDATE()) BETWEEN 3000 AND 4000) AS '3000-4000',
	(SELECT COUNT(t_o_t.id) FROM TagObjectTimers t_o_t WHERE DATEDIFF(hour, t_o_t.date_start, GETDATE()) BETWEEN 2000 AND 3000) AS '2000-3000',
	(SELECT COUNT(t_o_t.id) FROM TagObjectTimers t_o_t WHERE DATEDIFF(hour, t_o_t.date_start, GETDATE()) BETWEEN 1000 AND 2000) AS '1000-2000',
	(SELECT COUNT(t_o_t.id) FROM TagObjectTimers t_o_t WHERE DATEDIFF(hour, t_o_t.date_start, GETDATE()) BETWEEN 500 AND 1000) AS '500-1000',
	(SELECT COUNT(t_o_t.id) FROM TagObjectTimers t_o_t WHERE DATEDIFF(hour, t_o_t.date_start, GETDATE()) BETWEEN 250 AND 500) AS '250-500',
	(SELECT COUNT(t_o_t.id) FROM TagObjectTimers t_o_t WHERE DATEDIFF(hour, t_o_t.date_start, GETDATE()) BETWEEN 100 AND 250) AS '100-250',
	(SELECT COUNT(t_o_t.id) FROM TagObjectTimers t_o_t WHERE DATEDIFF(hour, t_o_t.date_start, GETDATE()) BETWEEN 50 AND 100) AS '50-100',
	(SELECT COUNT(t_o_t.id) FROM TagObjectTimers t_o_t WHERE DATEDIFF(hour, t_o_t.date_start, GETDATE()) BETWEEN 0 AND 50) AS '0-50'
	FROM TagObjectTimers t_o_t
	WHERE DATEDIFF(hour, t_o_t.date_start, GETDATE()) > 5000
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_users_inactive]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(MAX)
AS
BEGIN
	DECLARE @tag_users varchar(MAX)
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
/****** Object:  UserDefinedFunction [dbo].[fnTag_users_active]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(MAX)
AS
BEGIN
	DECLARE @tag_users varchar(MAX)
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
/****** Object:  UserDefinedFunction [dbo].[fnTag_user_count_active]    Script Date: 02/06/2014 15:19:47 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnTag_timers_overdue]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(MAX)
AS
BEGIN
	DECLARE @tag_timers varchar(MAX)

	SELECT @tag_timers = STUFF((SELECT ',' + '[' + t_t_o_t.name + ':' + ISNULL(c.sAMAccountName,t_o.name) + '(' + CONVERT(VARCHAR,DATEDIFF(hour, t_o_t.date_start, GETDATE())) + ')' + ']'
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
/****** Object:  UserDefinedFunction [dbo].[fnTag_timers_active]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(MAX)
AS
BEGIN
	DECLARE @tag_timers varchar(MAX)

	SELECT @tag_timers = STUFF((SELECT ',' + '[' + t_t_o_t.name + ':' + ISNULL(c.sAMAccountName,t_o.name) + '(' + CONVERT(VARCHAR,DATEDIFF(hour, t_o_t.date_start, GETDATE())) + ')' + ']'
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
/****** Object:  UserDefinedFunction [dbo].[fnTag_permissions_direct_active]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(MAX)
AS
BEGIN
	DECLARE @tag_permissions varchar(MAX)

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
/****** Object:  UserDefinedFunction [dbo].[fnTag_groups_inactive]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(MAX)
AS
BEGIN
	DECLARE @tag_groups varchar(MAX)
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
/****** Object:  UserDefinedFunction [dbo].[fnTag_groups_active]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(MAX)
AS
BEGIN
	DECLARE @tag_groups varchar(MAX)
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
/****** Object:  UserDefinedFunction [dbo].[fnTag_group_count_active]    Script Date: 02/06/2014 15:19:47 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_user_count]    Script Date: 02/06/2014 15:19:47 ******/
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
		WHERE id_type = @id_type_o_user 
		AND o.id_snapshot = @id_snapshot_l)
	
	RETURN ISNULL(@snapshot_user_count,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_type]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(500)
AS
BEGIN
	DECLARE @object_type varchar(500)
	SET @object_type = (SELECT TOP 1 t_o.name FROM Objects o
		INNER JOIN Types t_o ON t_o.id = o.id_type
		WHERE o.id = @id_object)

	RETURN ISNULL(@object_type,'not-found')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_sid]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(500)
AS
BEGIN
	DECLARE @id_attribute_objectsid bigint
	SET @id_attribute_objectsid = (SELECT id 
		FROM Attributes
		WHERE name = 'objectSID')

	DECLARE @object_sid varchar(255)
	SELECT @object_sid = o_a.attribute_value FROM ObjectAttributes o_a
		WHERE o_a.id_object = @id_object AND o_a.id_attribute = @id_attribute_objectsid

	RETURN @object_sid
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_show]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(500)
AS
BEGIN
	DECLARE @object_show varchar(500)
	SELECT @object_show = o_a.attribute_value FROM ObjectAttributes o_a
		INNER JOIN Attributes a ON o_a.id_attribute = a.id AND a.is_show = 1
		WHERE o_a.id_object = @id_object

	RETURN @object_show
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_relationships_parent]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(MAX)
AS
BEGIN
	DECLARE @relationships_parent varchar(MAX)

	SELECT @relationships_parent = STUFF((SELECT '[' + 
	t.name +
	':' +
	ISNULL(o_a.attribute_value,'') +
	']'
	FROM Relationships r
	INNER JOIN ObjectAttributes o_a ON o_a.id_object = r.id_object_parent
	INNER JOIN Attributes a ON a.id = o_a.id_attribute
	INNER JOIN Types t ON t.id = r.id_type
	WHERE r.id_object_child = @id_object
	AND a.is_key = 1
	FOR XML PATH('')),1,1,'[')	
	
	RETURN ISNULL(@relationships_parent,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_relationships_child]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(MAX)
AS
BEGIN
	DECLARE @relationships_child varchar(MAX)

	SELECT @relationships_child = STUFF((SELECT '[' + 
	t.name +
	':' +
	ISNULL(o_a.attribute_value,'') +
	']'
	FROM Relationships r
	INNER JOIN ObjectAttributes o_a ON o_a.id_object = r.id_object_child
	INNER JOIN Attributes a ON a.id = o_a.id_attribute
	INNER JOIN Types t ON t.id = r.id_type
	WHERE r.id_object_parent = @id_object
	AND a.is_key = 1
	FOR XML PATH('')),1,1,'[')	
	
	RETURN ISNULL(@relationships_child,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_key]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(500)
AS
BEGIN
	DECLARE @object_key varchar(500)
	SELECT @object_key = o_a.attribute_value FROM ObjectAttributes o_a
		INNER JOIN Attributes a ON o_a.id_attribute = a.id AND a.is_key = 1
		WHERE o_a.id_object = @id_object

	RETURN @object_key
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_attributes_all]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(MAX)
AS
BEGIN
	DECLARE @object_attributes varchar(MAX)
	
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
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_attributes]    Script Date: 02/06/2014 15:19:47 ******/
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
	@name_a varchar(500),
	@char_separator varchar(1)
)
RETURNS varchar(MAX)
AS
BEGIN
	DECLARE @object_attributes varchar(MAX)
	
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
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectdn_id]    Script Date: 02/06/2014 15:19:47 ******/
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
	@object_dn varchar(500)
)
RETURNS bigint
AS
BEGIN
	DECLARE @id_object bigint
	SET @id_object = (SELECT TOP 1 o_a.id_object FROM ObjectAttributes o_a
		INNER JOIN Attributes a ON a.id = o_a.id_attribute AND a.is_key = 1
		INNER JOIN Objects o ON o.id = o_a.id_object AND o.id_snapshot = (SELECT MAX(id) FROM Snapshots)
		WHERE o_a.attribute_value = @object_dn)

	RETURN ISNULL(@id_object,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectsid_id]    Script Date: 02/06/2014 15:19:47 ******/
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
	@object_sid varchar(255)
)
RETURNS bigint
AS
BEGIN
	DECLARE @id_attribute_objectsid bigint
	SET @id_attribute_objectsid = (SELECT TOP 1 id 
		FROM Attributes
		WHERE name = 'objectSID')

	DECLARE @id_object bigint
	SET @id_object = (SELECT TOP 1 o_a.id_object FROM ObjectAttributes o_a
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = o_a.attribute_value
		WHERE c.objectSID = @object_sid AND o_a.id_attribute = @id_attribute_objectsid)

	RETURN ISNULL(@id_object,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_relationship_count]    Script Date: 02/06/2014 15:19:47 ******/
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
		AND o.id_snapshot = @id_snapshot_l)
	
	RETURN ISNULL(@snapshot_group_count,0)
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_enable]    Script Date: 02/06/2014 15:19:46 ******/
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
	
	SELECT
	t_t_o.name,
	t_o.name,
	c.sAMAccountName,
	c.distinguishedName
	FROM TagObjects t_o
	INNER JOIN Types t_t_o ON t_t_o.id = t_o.id_type
	LEFT JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = t_o.name
	WHERE t_o.id = @id_tagobject	
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_disable]    Script Date: 02/06/2014 15:19:46 ******/
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
	
	SELECT
	t_t_o.name,
	t_o.name,
	c.sAMAccountName,
	c.distinguishedName
	FROM TagObjects t_o
	INNER JOIN Types t_t_o ON t_t_o.id = t_o.id_type
	LEFT JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = t_o.name
	WHERE t_o.id = @id_tagobject
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_get]    Script Date: 02/06/2014 15:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_get]
	@id_tag bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
	t.id, 
	t.description, 
	t.keywords,
	t.category,
	t.duration_hour,
	t.delay_hour,
	t.is_active,
	t.direct_provision,
	dbo.fnTag_user_count_active(t.id) as 'users',
	dbo.fnTag_group_count_active(t.id) as 'groups'
	FROM Tags t
	WHERE id = @id_tag
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectattribute_get]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnSnapshot_objectattribute_get] 
(
	@id_snapshot bigint = 0,
	@attribute_name varchar(100) = NULL
)
RETURNS @table_result table (
	id_object bigint,
	id_attribute bigint,
	attribute_value varchar(500))  
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
	WHERE oa_0.id_attribute IN
		(SELECT id FROM Attributes WHERE name = @attribute_name)
	OR @attribute_name IS NULL
			
	RETURN 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_objectid_dn]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(500)
AS
BEGIN
	DECLARE @cache_object_count bigint = (SELECT dbo.fnCache_object_count(NULL))
	IF @cache_object_count = 0 RETURN 'no-cache-data'

	DECLARE @object_dn varchar(500)
	SET @object_dn = (SELECT TOP 1 c.distinguishedName FROM TagObjects t_o
		INNER JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = t_o.name
		WHERE t_o.id = @id_object)

	RETURN @object_dn
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_objectdn_id]    Script Date: 02/06/2014 15:19:47 ******/
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
	@object_dn varchar(500)
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
/****** Object:  StoredProcedure [dbo].[spTags_objects_timer_get]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_objects_timer_get]
	@type_object varchar(50) = NULL,
	@type_timer varchar(50) = NULL,
	@is_overdue bit = 0,
	@tag_is_active bit = 1,
	@object_is_active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @cache_object_count bigint = (SELECT dbo.fnCache_object_count(NULL))
	IF @cache_object_count = 0 BEGIN SELECT 0,0,'no-cache-data' RETURN END	
	
	DECLARE @id_type_t bigint = (SELECT id FROM Types WHERE name = @type_timer)
	IF @id_type_t IS NULL AND LEN(@type_timer) > 0 BEGIN
		INSERT INTO Types (name) VALUES (@type_timer)
		SET @id_type_t = (SELECT SCOPE_IDENTITY())
	END	
	DECLARE @id_type_o bigint = (SELECT id FROM Types WHERE name = @type_object)
	IF @id_type_o IS NULL AND LEN(@type_object) > 0 BEGIN
		INSERT INTO Types (name) VALUES (@type_object)
		SET @id_type_o = (SELECT SCOPE_IDENTITY())
	END
		
	SELECT
	t.id,
	t_o.id,
	t.description,
	c_o.dn,
	c_o.attribute_1,
	c_o.attribute_2,
	c_o.attribute_3,
	c_o.attribute_4,
	c_o.attribute_5,
	c_o.attribute_6,
	c_o.attribute_7,
	c_o.attribute_8,
	c_o.attribute_9,
	t_t_o_t.name,
	t.duration_hour,
	DATEDIFF(hour, t_o_t.date_start, GETDATE()) as 'duration_hour_used'
	FROM Cache_table_ad c_o
	INNER JOIN Cache_table_dn_sAMAccountName c ON c.distinguishedName = c_o.dn
	INNER JOIN TagObjects t_o ON t_o.name = c.objectSID
	INNER JOIN TagObjectTimers t_o_t ON t_o_t.id_tagobject = t_o.id
	INNER JOIN Types t_t_o_t ON t_t_o_t.id = t_o_t.id_type
	INNER JOIN Tags t ON t.id = t_o.id_tag
	WHERE (c_o.type = @type_object OR @type_object IS NULL)
	AND (t_o.id_type = @id_type_o OR @type_object IS NULL)
	AND (t_t_o_t.id = @id_type_t OR @type_timer IS NULL)
	AND (t.is_active = @tag_is_active OR @tag_is_active IS NULL)
	AND (t_o.is_active = @object_is_active OR @object_is_active IS NULL)
	AND (DATEDIFF(hour, t_o_t.date_start, GETDATE()) > t.duration_hour AND t.duration_hour > 0 OR @is_overdue = 0 OR @is_overdue IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_objects_link]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_objects_link]
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE t_o
	SET name = c.objectSID
	FROM TagObjects t_o
	INNER JOIN Cache_table_dn_sAMAccountName c ON c.sAMAccountName = t_o.name
	WHERE dbo.fnCache_object_count(NULL) > 50

	UPDATE t_o
	SET name = c.objectSID
	FROM TagObjects t_o
	INNER JOIN Cache_table_dn_sAMAccountName c ON c.distinguishedName = t_o.name
	WHERE dbo.fnCache_object_count(NULL) > 50
	
	UPDATE t_o
	SET name = c.objectSID
	FROM TagObjects t_o
	INNER JOIN Cache_table_dn_sAMAccountName c ON c.objectGUID = t_o.name
	WHERE dbo.fnCache_object_count(NULL) > 50
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_overview_chart]    Script Date: 02/06/2014 15:19:47 ******/
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
	dbo.fnSnapshot_user_count_active(0) AS 'Snapshot users',
	dbo.fnTag_group_count_active(0) AS 'Tag groups',
	dbo.fnSnapshot_group_count_active(0) AS 'Snapshot groups'
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_report_overview]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_overview]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
	CONVERT(varchar,t.id) + '-' + c_g.sAMAccountName as 'id',
	t.[description],
	c_g.sAMAccountName,
	(SELECT COUNT(t_o_u.id)
	FROM TagObjects t_o_u
	WHERE t_o_u.id_tag = t.id
	AND t_o_u.id_type = (SELECT id FROM Types WHERE name = 'user')) as 'count_tag',
	(SELECT COUNT(r.id) 
	FROM Relationships r 
	WHERE r.id_object_parent = o.id
	AND r.id_type = (SELECT id FROM Types WHERE name = 'member')) as 'count_memberships'
	FROM Tags t
	INNER JOIN TagObjects t_o_g ON t_o_g.id_tag = t.id 
		AND t_o_g.id_type = (SELECT id FROM Types WHERE name = 'group')
	INNER JOIN Cache_table_dn_sAMAccountName c_g ON t_o_g.name = c_g.objectSID
	INNER JOIN ObjectAttributes oa_key ON oa_key.attribute_value = c_g.distinguishedName
	INNER JOIN Objects o ON o.id = oa_key.id_object
		AND o.id_snapshot = (SELECT MAX(id) FROM Snapshots)
	ORDER BY t.[description]
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_get]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_get]
	@is_active bit = NULL,
	@keywords varchar(255) = NULL,
	@category varchar(255) = NULL,
	@type_permission varchar(50) = NULL,
	@name_object varchar(500) = NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE @name varchar(255) = (SELECT TOP 1 c.objectSID FROM Cache_table_dn_sAMAccountName c WHERE c.distinguishedName = @name_object)
	
	DECLARE @id_type_p bigint = (SELECT id FROM Types WHERE name = @type_permission)
	IF @id_type_p IS NULL AND LEN(@type_permission) > 0 BEGIN
		INSERT INTO Types (name) VALUES (@type_permission)
		SET @id_type_p = (SELECT SCOPE_IDENTITY())
	END

	SELECT
	t.id,
	t.[description],
	t.keywords,
	t.category,
	t.duration_hour,
	t.delay_hour,
	t.is_active,
	t.direct_provision,
	dbo.fnTag_user_count_active(t.id) as 'users',
	dbo.fnTag_group_count_active(t.id) as 'groups'
	FROM Tags t
	WHERE (t.is_active = @is_active OR @is_active IS NULL)
	AND (t.keywords IN (SELECT string_value FROM fnStringToTable(@keywords, ','))
		OR @keywords IN (SELECT string_value FROM fnStringToTable(t.keywords, ','))
		OR @keywords IS NULL)
	AND (t.category = @category OR @category IS NULL)
	AND (t.id IN (SELECT t_p.id_tag FROM TagPermissions t_p 
		WHERE t_p.id_type_permission = @id_type_p
		AND t_p.is_allowed = 1) OR @type_permission IS NULL)
	AND (t.id IN (SELECT t_o.id_tag FROM TagObjects t_o 
		WHERE t_o.name = @name
		AND (t_o.is_active = @is_active OR @is_active IS NULL)) OR @name_object IS NULL)

END
GO
/****** Object:  StoredProcedure [dbo].[spTags_relationships_snapshot_right]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_relationships_snapshot_right]
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint = (SELECT MAX(id) FROM Snapshots)
	DECLARE @id_attribute_sid bigint = (SELECT id FROM Attributes WHERE name = 'objectSID')
	DECLARE @id_type_r_member bigint = (SELECT id FROM Types WHERE name = 'member')
	IF @id_type_r_member IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('member')
		SET @id_type_r_member = (SELECT SCOPE_IDENTITY())
	END	
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')
	IF @id_type_o_group IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('group')
		SET @id_type_o_group = (SELECT SCOPE_IDENTITY())
	END		
	DECLARE @id_type_o_user bigint = (SELECT id FROM Types WHERE name = 'user')
	IF @id_type_o_user IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('user')
		SET @id_type_o_user = (SELECT SCOPE_IDENTITY())
	END
	
	SELECT
	CONVERT(varchar,t_o_group.id) + '-' + CONVERT(varchar,t_o_user.id) as 'id',
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
	INNER JOIN Attributes a_group_key ON a_group_key.id = oa_group_key.id_attribute
		AND a_group_key.is_key = 1
	INNER JOIN ObjectAttributes oa_user_key ON oa_user_key.id_object = r.id_object_child
	INNER JOIN Attributes a_user_key ON a_user_key.id = oa_user_key.id_attribute
		AND a_user_key.is_key = 1
	AND NOT t_o_group.name IN
	(SELECT t_o_group_active.name FROM TagObjects t_o_group_active
	INNER JOIN TagObjects t_o_user_active ON t_o_group_active.id_tag = t_o_user_active.id_tag 
		AND t_o_group_active.id_type = @id_type_o_group
		AND t_o_user_active.id_type = @id_type_o_user
		AND t_o_group_active.is_active = 1
		AND t_o_user_active.is_active = 1
		AND t_o_user_active.name = t_o_user.name)
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_relationships_snapshot_left]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_relationships_snapshot_left]
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_snapshot_l bigint = (SELECT MAX(id) FROM Snapshots)
	DECLARE @id_attribute_sid bigint = (SELECT id FROM Attributes WHERE name = 'objectSID')
	DECLARE @id_type_r_member bigint = (SELECT id FROM Types WHERE name = 'member')
	IF @id_type_r_member IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('member')
		SET @id_type_r_member = (SELECT SCOPE_IDENTITY())
	END	
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')
	IF @id_type_o_group IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('group')
		SET @id_type_o_group = (SELECT SCOPE_IDENTITY())
	END		
	DECLARE @id_type_o_user bigint = (SELECT id FROM Types WHERE name = 'user')
	IF @id_type_o_user IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('user')
		SET @id_type_o_user = (SELECT SCOPE_IDENTITY())
	END		
	
	SELECT
	t_o_group.name + '-' + t_o_user.name as 'id',
	c_group.distinguishedName,
	t_o_group.name,
	t_o_group.date_start,
	t_o_group.date_end,
	c_user.distinguishedName,	
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
	INNER JOIN Cache_table_dn_sAMAccountName c_group ON c_group.objectSID = t_o_group.name
	INNER JOIN ObjectAttributes oa_user_sid ON oa_user_sid.attribute_value = t_o_user.name
		AND oa_user_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_user ON o_user.id = oa_user_sid.id_object
		AND o_user.id_snapshot = @id_snapshot_l
	INNER JOIN Cache_table_dn_sAMAccountName c_user ON c_user.objectSID = t_o_user.name
	LEFT JOIN Relationships r ON r.id_object_parent = o_group.id
		AND r.id_object_child = o_user.id
		AND r.id_type = @id_type_r_member
	WHERE r.id_object_parent IS NULL
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_relationships_snapshot_common]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_relationships_snapshot_common]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @id_snapshot_l bigint = (SELECT MAX(id) FROM Snapshots)
	DECLARE @id_attribute_sid bigint = (SELECT id FROM Attributes WHERE name = 'objectSID')
	DECLARE @id_type_r_member bigint = (SELECT id FROM Types WHERE name = 'member')
	IF @id_type_r_member IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('member')
		SET @id_type_r_member = (SELECT SCOPE_IDENTITY())
	END	
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')
	IF @id_type_o_group IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('group')
		SET @id_type_o_group = (SELECT SCOPE_IDENTITY())
	END		
	DECLARE @id_type_o_user bigint = (SELECT id FROM Types WHERE name = 'user')
	IF @id_type_o_user IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('user')
		SET @id_type_o_user = (SELECT SCOPE_IDENTITY())
	END
	
	SELECT
	t_o_group.name + '-' + t_o_user.name as 'id',
	c_group.distinguishedName,
	t_o_group.name,
	c_user.distinguishedName,
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
	INNER JOIN Cache_table_dn_sAMAccountName c_group ON c_group.objectSID = t_o_group.name
	INNER JOIN ObjectAttributes oa_user_sid ON oa_user_sid.attribute_value = t_o_user.name
		AND oa_user_sid.id_attribute = @id_attribute_sid
	INNER JOIN Objects o_user ON o_user.id = oa_user_sid.id_object
		AND o_user.id_snapshot = @id_snapshot_l
	INNER JOIN Cache_table_dn_sAMAccountName c_user ON c_user.objectSID = t_o_user.name
	INNER JOIN Relationships r ON r.id_object_parent = o_group.id
		AND r.id_object_child = o_user.id
		AND r.id_type = @id_type_r_member
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_permissions_link]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_permissions_link]
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE t_p
	SET name = c.objectSID
	FROM TagPermissions t_p
	INNER JOIN Cache_table_dn_sAMAccountName c ON c.sAMAccountName = t_p.name
	WHERE dbo.fnCache_object_count(NULL) > 50

	UPDATE t_p
	SET name = c.objectSID
	FROM TagPermissions t_p
	INNER JOIN Cache_table_dn_sAMAccountName c ON c.distinguishedName = t_p.name
	WHERE dbo.fnCache_object_count(NULL) > 50
	
	UPDATE t_p
	SET name = c.objectSID
	FROM TagPermissions t_p
	INNER JOIN Cache_table_dn_sAMAccountName c ON c.objectGUID = t_p.name
	WHERE dbo.fnCache_object_count(NULL) > 50
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_permissions_get_direct]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_permissions_get_direct]
	@name_input varchar(500),
	@type_permission varchar(50) = NULL,
	@tag_is_active bit = 1,
	@is_allowed bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @id_type_p bigint = (SELECT id FROM Types WHERE name = @type_permission)
	IF @id_type_p IS NULL AND LEN(@type_permission) > 0 BEGIN
		INSERT INTO Types (name) VALUES (@type_permission)
		SET @id_type_p = (SELECT SCOPE_IDENTITY())
	END

	SELECT 
	t.id,
	t.description,
	t.keywords,
	t.category,
	t.duration_hour,
	t.delay_hour,
	t.is_active,
	t.direct_provision,
	dbo.fnTag_user_count_active(t.id) as 'users',
	dbo.fnTag_group_count_active(t.id) as 'groups'
	FROM TagPermissions t_p
	INNER JOIN Tags t ON t.id = t_p.id_tag
	WHERE (t_p.id_type_permission = @id_type_p OR @type_permission IS NULL)
	AND (t_p.is_allowed = @is_allowed OR @is_allowed IS NULL)
	AND (t.is_active = @tag_is_active OR @tag_is_active IS NULL)
	AND (t_p.name = @name_input)
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_permissions_get]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_permissions_get]
	@name_input varchar(500),
	@type_permission varchar(50) = NULL,
	@tag_is_active bit = 1,
	@is_allowed bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @snapshot_user_count bigint = (SELECT dbo.fnSnapshot_user_count(0))
	DECLARE @snapshot_group_count bigint = (SELECT dbo.fnSnapshot_group_count(0))
	DECLARE @snapshot_relationship_count bigint = (SELECT dbo.fnSnapshot_relationship_count(0))
	IF @snapshot_user_count < 50 OR @snapshot_group_count < 50 OR @snapshot_relationship_count < 50 BEGIN SELECT 'no-snapshot-data' RETURN END
	
	DECLARE @id_object_input bigint = dbo.fnSnapshot_objectdn_id(@name_input)
	DECLARE @name_input_sid varchar(255) = dbo.fnSnapshot_objectid_sid(@id_object_input)
	DECLARE @id_type_r_member bigint = (SELECT id FROM Types WHERE name = 'member')
	
	IF @id_type_r_member IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('member')
		SET @id_type_r_member = (SELECT SCOPE_IDENTITY())
	END
	
	DECLARE @id_type_p bigint = (SELECT id FROM Types WHERE name = @type_permission)
	IF @id_type_p IS NULL AND LEN(@type_permission) > 0 BEGIN
		INSERT INTO Types (name) VALUES (@type_permission)
		SET @id_type_p = (SELECT SCOPE_IDENTITY())
	END
	
	DECLARE @id_type_o_group bigint = (SELECT id FROM Types WHERE name = 'group')
	IF @id_type_o_group IS NULL BEGIN
		INSERT INTO Types (name) VALUES ('group')
		SET @id_type_o_group = (SELECT SCOPE_IDENTITY())
	END		
	
	DECLARE @id_snapshot_l bigint = (SELECT MAX(id) FROM Snapshots)
	DECLARE @id_attribute_sid bigint = (SELECT id FROM Attributes WHERE name = 'objectSID')

	SELECT 
	t.id,
	t.description,
	t.keywords,
	t.category,
	t.duration_hour,
	t.delay_hour,
	t.is_active,
	t.direct_provision,
	dbo.fnTag_user_count_active(t.id) as 'users',
	dbo.fnTag_group_count_active(t.id) as 'groups'
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
/****** Object:  StoredProcedure [dbo].[spTags_objects_left]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_objects_left]
	@name_object varchar(500),
	@keywords varchar(255) = NULL,
	@category varchar(255) = NULL,
	@is_active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @table_tags_common TABLE (
		id bigint,
		[description] varchar(255),
		keywords varchar(255),
		category varchar(255),
		duration_hour bigint,
		delay_hour bigint,
		is_active bigint,
		direct_provision bit,
		user_count bigint,
		group_count bigint)
		
	INSERT INTO @table_tags_common
	EXEC spTags_get @is_active,@keywords,@category,NULL,@name_object
	
	SELECT
	t.id,
	t.[description],
	t.keywords,
	t.category,
	t.duration_hour,
	t.delay_hour,
	t.is_active,
	t.direct_provision,
	dbo.fnTag_user_count_active(t.id) as 'users',
	dbo.fnTag_group_count_active(t.id) as 'groups'
	FROM Tags t
	WHERE (t.is_active = @is_active OR @is_active IS NULL)
	AND (t.keywords IN (SELECT string_value FROM fnStringToTable(@keywords, ',')) OR @keywords IS NULL)
	AND (t.category = @category OR @category IS NULL)	
	AND t.id NOT IN (SELECT t_common.id FROM @table_tags_common t_common)
	AND dbo.fnCache_object_count(NULL) > 50
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_objects_cleanup_soft]    Script Date: 02/06/2014 15:19:47 ******/
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
	
	DECLARE @obsoleteid_tagobject TABLE (id bigint)
	INSERT INTO @obsoleteid_tagobject
	SELECT
	t_o.id
	FROM TagObjects t_o
	LEFT JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = t_o.name
	WHERE c.distinguishedName IS NULL
	AND dbo.fnSnapshot_objectsid_validate(t_o.name) = 1
	AND dbo.fnCache_object_count(NULL) > 50
	AND t_o.is_active = 1
	
	UPDATE TagObjects
	SET is_active = 0
	WHERE id IN (SELECT o.id FROM @obsoleteid_tagobject o)
	
	EXEC spTags_objecttimers_cleanup
END
GO
/****** Object:  StoredProcedure [dbo].[spTags_objects_cleanup_hard]    Script Date: 02/06/2014 15:19:47 ******/
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

	DECLARE @obsoleteid_tagobject TABLE (id bigint)
	INSERT INTO @obsoleteid_tagobject
	SELECT
	t_o.id
	FROM TagObjects t_o
	LEFT JOIN Cache_table_dn_sAMAccountName c ON c.objectSID = t_o.name
	WHERE c.distinguishedName IS NULL
	AND dbo.fnSnapshot_objectsid_validate(t_o.name) = 1
	AND dbo.fnCache_object_count(NULL) > 50
	AND t_o.is_active = 1
	
	DELETE FROM TagObjects
	WHERE id IN (SELECT o.id FROM @obsoleteid_tagobject o)
	
	EXEC spTags_objecttimers_cleanup
END
GO
/****** Object:  StoredProcedure [dbo].[spTag_object_add]    Script Date: 02/06/2014 15:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTag_object_add]
	@id_tag bigint,
	@name_input varchar(500),
	@type_object varchar(50),
	@date_start datetime = '',
	@date_end datetime = '',
	@is_active bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @delay_hour int = (SELECT delay_hour FROM Tags WHERE id = @id_tag)
	DECLARE @name varchar(255) = (SELECT TOP 1 c.objectSID FROM Cache_table_dn_sAMAccountName c WHERE c.distinguishedName = @name_input)
	DECLARE @id_type_o bigint = (SELECT id FROM Types WHERE name = @type_object)
	
	IF @id_type_o IS NULL BEGIN
		INSERT INTO Types (name) VALUES (@type_object)
		SET @id_type_o = (SELECT SCOPE_IDENTITY())
	END
	
	IF @name IS NULL BEGIN
		SET @name = @name_input
	END
	
	DECLARE @id_tagobject bigint = (SELECT id 
		FROM TagObjects 
		WHERE name = @name 
		AND id_tag = @id_tag 
		AND id_type = @id_type_o)
	
	IF @date_start = '' OR @date_start = '0' BEGIN SET @date_start = NULL END
	IF @date_end = '' OR @date_end = '0' BEGIN SET @date_end = NULL END
	
	IF @id_tagobject > 0 BEGIN
		UPDATE TagObjects
		SET	date_start = @date_start,
		date_end = @date_end
		WHERE id = @id_tagobject
		
		EXEC spTag_object_enable @id_tagobject
		
		SELECT @id_tagobject
		
		RETURN
	END
	
	IF @id_tagobject IS NULL BEGIN
		INSERT INTO TagObjects (id_tag, id_type, name, date_start, date_end, is_active) 
		VALUES (@id_tag, @id_type_o, @name, @date_start, @date_end, @is_active)
		SET @id_tagobject = (SELECT SCOPE_IDENTITY())
		
		EXEC spTag_object_timer_start @id_tagobject, 'duration'
		
		SELECT @id_tagobject
		
		RETURN
	END
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnTag_permissions_active]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(MAX)
AS
BEGIN
	DECLARE @tag_permissions varchar(MAX)

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
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_tags_active]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(MAX)
AS
BEGIN
	DECLARE @snapshot_object_tags varchar(MAX)
	DECLARE @name varchar(500) = (SELECT dbo.fnSnapshot_objectid_sid(@id_object))
	
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
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_tagobjects_related_active]    Script Date: 02/06/2014 15:19:47 ******/
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
RETURNS varchar(MAX)
AS
BEGIN
	DECLARE @snapshot_object_tags varchar(MAX)
	DECLARE @name varchar(500) = (SELECT dbo.fnSnapshot_objectid_sid(@id_object))
	
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
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectid_tag_count_active]    Script Date: 02/06/2014 15:19:47 ******/
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
	DECLARE @name varchar(500) = (SELECT dbo.fnSnapshot_objectid_sid(@id_object))
	
	SELECT @snapshot_object_tag_count = (SELECT COUNT(t.id)
	FROM Tags t
	INNER JOIN TagObjects t_o ON t_o.id_tag = t.id
	WHERE t_o.is_active = 1
	AND t.is_active = 1
	AND t_o.name = @name)
	
	RETURN ISNULL(@snapshot_object_tag_count,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectattributes_get]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnSnapshot_objectattributes_get] 
(
	@id_snapshot bigint = 0,
	@attribute_names varchar(500) = NULL,
	@char_separator varchar(5) = '-'
)
RETURNS @table_result table (
	id_object bigint,
	attribute_name varchar(500),
	attribute_value varchar(500))  
AS
BEGIN
	DECLARE @id_snapshot_l bigint
	SET @id_snapshot_l = @id_snapshot
	IF @id_snapshot_l = 0 BEGIN SET @id_snapshot_l = (SELECT MAX(id) FROM Snapshots) END
	
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
/****** Object:  StoredProcedure [dbo].[spTags_report_overview_detailed]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTags_report_overview_detailed]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
	t.[description] AS 'Description',
	t.keywords AS 'Keywords',
	t.category AS 'Category',
	t.duration_hour AS 'Duration (hour)',
	t.delay_hour AS 'Delay (hour)',
	t.is_active AS 'Active',
	t.direct_provision AS 'Direct-provision',
	dbo.fnTag_user_count_active(t.id) as 'Users',
	dbo.fnTag_group_count_active(t.id) as 'Groups',
	dbo.fnTag_groups_active(t.id) AS 'AD-groups',
	dbo.fnTag_groups_inactive(t.id) AS 'AD-groups (disabled)',
	dbo.fnTag_users_active(t.id) AS 'AD-accounts',
	dbo.fnTag_users_inactive(t.id) AS 'AD-accounts (disabled)',
	dbo.fnTag_permissions_active(t.id) AS 'Permissions',
	dbo.fnTag_permissions_direct_active(t.id) AS 'Direct-permissions',
	dbo.fnTag_timers_active(t.id) AS 'Duration (hours)',
	dbo.fnTag_timers_overdue(t.id) AS 'Overdue (hours)'
	FROM Tags t
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSnapshot_objectattributes_count]    Script Date: 02/06/2014 15:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnSnapshot_objectattributes_count] 
(
	@id_snapshot bigint = 0,
	@attribute_names varchar(500) = NULL,
	@char_separator varchar(1) = '-'
)
RETURNS @table_result table (
	attribute_name varchar(500),
	attribute_value varchar(500),
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
	
	RETURN 
END
GO
