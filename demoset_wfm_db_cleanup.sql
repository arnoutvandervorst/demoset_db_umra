DECLARE @id_language integer = (SELECT id FROM languages WHERE isDefault = 1)

--basic maintenance & cleanup
PRINT 'truncate workflowInstanceData'
TRUNCATE TABLE workflowInstanceData

PRINT 'truncate workflowInstanceHistory'
TRUNCATE TABLE workflowInstanceHistory

PRINT 'truncate workflowInstanceLock'
TRUNCATE TABLE workflowInstanceLock

PRINT 'truncate workflowInstanceTrace'
TRUNCATE TABLE workflowInstanceTrace

PRINT 'truncate workflowInstanceReadFlag'
TRUNCATE TABLE workflowInstanceReadFlag

PRINT 'truncate workflowInstanceReminders'
TRUNCATE TABLE workflowInstanceReminders

PRINT 'truncate workflowDelegation'
TRUNCATE TABLE workflowDelegation

PRINT 'truncate repositoryData'
TRUNCATE TABLE repositoryData

PRINT 'truncate errorLog'
TRUNCATE TABLE errorLog

PRINT 'delete workflowInstances and reseed ID to 0'
DELETE FROM workflowInstances
DBCC CHECKIDENT (workflowInstances, RESEED, 0)

--advanced cleanup
DECLARE @workflows_invisible TABLE (id bigint, name varchar(255), id_category bigint, id_to_n bigint, id_to_d bigint)
INSERT INTO @workflows_invisible
SELECT 
w.ID,
t.value,
w.categoryID, 
w.nameTranslationObjectID, 
w.descriptionTranslationObjectID 
FROM workflows w
LEFT JOIN translationObjects t_o ON t_o.id = w.nameTranslationObjectID
LEFT JOIN translations t ON t.translationObjectID = t_o.id
	AND t.languageID = @id_language
WHERE w.visible = 0

DECLARE @workflowcategories_unused TABLE (id bigint, name varchar(255), id_to bigint)
INSERT INTO @workflowcategories_unused
SELECT 
w_c.ID, 
t.value,
w_c.nameTranslationObjectID 
FROM workflowCategories w_c
LEFT JOIN translationObjects t_o ON t_o.id = w_c.nameTranslationObjectID
LEFT JOIN translations t ON t.translationObjectID = t_o.id
	AND t.languageID = @id_language
WHERE w_c.ID IN (SELECT id_category FROM @workflows_invisible)

DECLARE @workflowlayers_invisible TABLE (id bigint, name varchar(255), id_workflow bigint)
INSERT INTO @workflowlayers_invisible
SELECT 
w_l.ID,
w_l.name,
w_l.workflowID
FROM workflowLayers w_l
WHERE w_l.visible = 0
OR w_l.workflowID IN (SELECT id FROM @workflows_invisible)

DECLARE @activities_invisible TABLE (id bigint, name varchar(255), id_to bigint, id_wl bigint, id_uv_target bigint, id_uv bigint)
INSERT INTO @activities_invisible
SELECT 
a.ID,
a.name,
a.translationObjectID,
a.workflowLayerID,
a.targetUmraVariableID,
a.umraVariableID
FROM activities a
WHERE a.visible = 0
OR a.workflowLayerID IN (SELECT id FROM @workflowlayers_invisible)

DECLARE @fieldsets_invisible TABLE (id bigint, name varchar(255), id_to bigint)
INSERT INTO @fieldsets_invisible
SELECT 
f_s.ID, 
t.value,
f_s.nameTranslationObjectID 
FROM fieldSets f_s
LEFT JOIN translationObjects t_o ON t_o.id = f_s.nameTranslationObjectID
LEFT JOIN translations t ON t.translationObjectID = t_o.id
	AND t.languageID = @id_language
WHERE f_s.visible = 0
OR f_s.activityID IN (SELECT id FROM @activities_invisible)

DECLARE @fields_invisible TABLE (id bigint, name varchar(255), type varchar(255), id_to_n bigint, id_to_d bigint, id_tp bigint, id_tp_h bigint, id_uv_def bigint, id_uv bigint)
INSERT INTO @fields_invisible
SELECT 
f.ID,
t.value,
f.type,
f.nameTranslationObjectID, 
f.descriptionTranslationObjectID, 
f.textPartID, 
f.helpTextPartID,
f.defaultValueUmraVariableID,
f.umraVariableID
FROM fields f
LEFT JOIN translationObjects t_o ON t_o.id = f.nameTranslationObjectID
LEFT JOIN translations t ON t.translationObjectID = t_o.id
	AND t.languageID = @id_language
WHERE f.visible = 0
OR f.fieldsetID IN (SELECT id FROM @fieldsets_invisible)
OR f.nextActivityID IN (SELECT id FROM @activities_invisible)

DECLARE @umravariables_used TABLE (id bigint)
INSERT INTO @umravariables_used
SELECT DISTINCT
u_v.ID
FROM umraVariables u_v
WHERE u_v.ID IN (SELECT f.defaultValueUmraVariableID FROM fields f)
OR u_v.ID IN (SELECT f.umraVariableID FROM fields f)
OR u_v.ID IN (SELECT a.targetUmraVariableID FROM activities a)
OR u_v.ID IN (SELECT a.umraVariableID FROM activities a)
OR u_v.ID IN (SELECT u_v_r.repositoryUmraScriptVariableID FROM umraVariables u_v_r)
OR u_v.ID = (SELECT value FROM settings s WHERE s.name = 'delegation_RepositoryVariableID')
OR u_v.ID = (SELECT value FROM settings s WHERE s.name = 'assignments_RepositoryVariableID')
OR u_v.isRepositoryVariable = 1

DECLARE @umravariables_unused TABLE (id bigint, name varchar(255), umrascript varchar(255), id_to_def bigint, id_to_dspl bigint)
INSERT INTO @umravariables_unused
SELECT 
u_v.ID, 
u_v.name,
u_v.umraScript,
u_v.defaultValueTranslationObjectID,
u_v.displayNameTranslationObjectID
FROM umraVariables u_v
WHERE u_v.ID NOT IN (SELECT id FROM @umravariables_used)
AND (u_v.ID IN (SELECT f.id_uv FROM @fields_invisible f)
OR u_v.ID IN (SELECT f.id_uv_def FROM @fields_invisible f)
OR u_v.ID IN (SELECT a.id_uv FROM @activities_invisible a)
OR u_v.ID IN (SELECT a.id_uv_target FROM @activities_invisible a))

DECLARE @umravariables_duplicate TABLE (id bigint, name varchar(255), umrascript varchar(255))
INSERT INTO @umravariables_duplicate
SELECT
u_v.ID,
u_v_d.ID,
u_v.name
FROM umraVariables u_v
INNER JOIN umraVariables u_v_d ON u_v_d.name = u_v.name AND u_v.umraScript IS NULL
WHERE u_v.ID <> u_v_d.ID

DECLARE @textparts_unused TABLE (id bigint, id_to bigint)
INSERT INTO @textparts_unused
SELECT 
t_p.id, 
t_p.valueTranslationObjectID 
FROM textParts t_p
WHERE t_p.id IN (SELECT f.id_tp FROM @fields_invisible f)
OR t_p.id IN (SELECT f.id_tp_h FROM @fields_invisible f)

DECLARE @translationobjects_unused TABLE (id bigint)
INSERT INTO @translationobjects_unused
SELECT t_o.id
FROM translationObjects t_o
WHERE t_o.id IN (SELECT w.id_to_d FROM @workflows_invisible w)
OR t_o.id IN (SELECT w.id_to_n FROM @workflows_invisible w)
OR t_o.id IN (SELECT a.id_to FROM @activities_invisible a)
OR t_o.id IN (SELECT f_s.id_to FROM @fieldsets_invisible f_s)
OR t_o.id IN (SELECT f.id_to_d FROM @fields_invisible f)
OR t_o.id IN (SELECT f.id_to_n FROM @fields_invisible f)
OR t_o.id IN (SELECT w_c.id_to FROM @workflowcategories_unused w_c)
OR t_o.id IN (SELECT t_p.id_to FROM @textparts_unused t_p)
OR t_o.id IN (SELECT u_v.id_to_def FROM @umravariables_unused u_v)
OR t_o.id IN (SELECT u_v.id_to_dspl FROM @umravariables_unused u_v)

DECLARE @translations_unused TABLE (id bigint, value varchar(MAX))
INSERT INTO @translations_unused
SELECT t.id, t.value FROM translations t
WHERE t.translationObjectID IN (SELECT id FROM @translationobjects_unused)

SELECT * FROM @workflows_invisible
SELECT * FROM @workflowlayers_invisible
SELECT * FROM @workflowcategories_unused
SELECT * FROM @activities_invisible
SELECT * FROM @fieldsets_invisible
SELECT * FROM @fields_invisible
SELECT * FROM @umravariables_unused
SELECT * FROM @umravariables_duplicate
SELECT * FROM @translations_unused

DELETE FROM umraVariables WHERE ID IN
(SELECT id FROM @umravariables_unused)

DELETE FROM fields WHERE ID IN
(SELECT id FROM @fields_invisible)

DELETE FROM fieldSets WHERE ID IN
(SELECT id FROM @fieldsets_invisible)

DELETE FROM activities WHERE ID IN
(SELECT id FROM @activities_invisible)

DELETE FROM workflowLayers WHERE ID IN
(SELECT id FROM @workflowlayers_invisible)

DELETE FROM workflows WHERE ID IN
(SELECT id FROM @workflows_invisible)

DELETE FROM workflowCategories WHERE ID IN
(SELECT id FROM @workflowcategories_unused)

DELETE FROM translations WHERE ID IN
(SELECT id FROM @translations_unused)

DELETE FROM translationObjects WHERE id IN
(SELECT id FROM @translationobjects_unused)