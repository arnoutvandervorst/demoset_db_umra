USE workflow
GO

PRINT 'set all workflowlayers to invisible when the workflow is invisible'
UPDATE workflowLayers SET visible = 0 WHERE workflowLayers.ID IN
(SELECT wl.ID FROM workflowLayers wl INNER JOIN workflows w ON w.ID = wl.workflowID WHERE w.visible = 0)

PRINT 'set activities to invisible when the workflowlayer is invisible'
UPDATE activities SET visible = 0 WHERE activities.ID IN
(SELECT a.ID FROM activities a INNER JOIN workflowLayers wl ON wl.ID = a.workflowLayerID WHERE wl.visible = 0)

PRINT 'set activities to invisible when the nextActivity on the field is invisible'
UPDATE activities SET visible = 0 WHERE activities.ID IN
(SELECT f.nextActivityID FROM fields f WHERE f.visible = 0)

PRINT 'set fieldsets to invisible when the activity is invisible'
UPDATE fieldSets SET visible = 0 WHERE fieldsets.ID IN
(SELECT fs.ID FROM fieldSets fs INNER JOIN activities a ON a.ID = fs.activityID WHERE a.visible = 0)

PRINT 'set fields to invisible when the fieldset is invisible'
UPDATE fields SET visible = 0 WHERE fields.ID IN
(SELECT f.ID FROM fields f INNER JOIN fieldSets fs ON fs.ID = f.fieldsetID WHERE fs.visible = 0)

PRINT 'set fields to invisible when the nextActivity is invisible'
UPDATE fields SET visible = 0 WHERE fields.nextActivityID IN
(SELECT a.ID FROM activities a WHERE a.visible = 0)

PRINT 'truncate workflowInstanceData'
TRUNCATE TABLE workflowInstanceData

PRINT 'truncate workflowInstanceHistory'
TRUNCATE TABLE workflowInstanceHistory

PRINT 'truncate workflowInstanceLock'
TRUNCATE TABLE workflowInstanceLock

PRINT 'truncate workflowInstanceTrace'
TRUNCATE TABLE workflowInstanceTrace

PRINT 'truncate workflowDelegation'
TRUNCATE TABLE workflowDelegation

PRINT 'truncate repositoryData'
TRUNCATE TABLE repositoryData

PRINT 'truncate errorLog'
TRUNCATE TABLE errorLog

PRINT 'delete workflowInstances and reseed ID to 0'
DELETE FROM workflowInstances
DBCC CHECKIDENT (workflowInstances, RESEED, 0)

PRINT 'getting translationObjects from invisible fields'
DECLARE @table_fields TABLE (id bigint, nameTranslationObjectID bigint) 
INSERT INTO @table_fields
SELECT f.id, f.nameTranslationObjectID FROM fields f WHERE f.visible = 0

PRINT 'delete invisible fields'
DELETE FROM fields WHERE visible = 0

PRINT 'getting translationObjects from invisible fieldSets'
DECLARE @table_fieldsets TABLE (id bigint, nameTranslationObjectID bigint) 
INSERT INTO @table_fieldsets
SELECT fs.id, fs.nameTranslationObjectID FROM fieldSets fs WHERE fs.visible = 0

PRINT 'delete invisible fieldSets'
DELETE FROM fieldSets WHERE visible = 0

PRINT 'getting translationObjects from invisible workflows'
DECLARE @table_workflows TABLE (id bigint, nameTranslationObjectID bigint) 
INSERT INTO @table_workflows
SELECT w.id, w.nameTranslationObjectID FROM workflows w WHERE w.visible = 0

PRINT 'delete translations from invisible fields'
DELETE FROM translations WHERE id IN
(SELECT t.id FROM translations t
INNER JOIN translationObjects t_o ON t.translationObjectID = t_o.id
INNER JOIN @table_fields f ON f.nameTranslationObjectID = t_o.id)

PRINT 'delete translationObjects from invisible fields'
DELETE FROM translationObjects WHERE id IN
(SELECT t_o.id FROM translationObjects t_o
INNER JOIN @table_fields f ON f.nameTranslationObjectID = t_o.id)

PRINT 'delete translations from invisible fieldSets'
DELETE FROM translations WHERE id IN
(SELECT t.id FROM translations t
INNER JOIN translationObjects t_o ON t.translationObjectID = t_o.id
INNER JOIN @table_fieldsets fs ON fs.nameTranslationObjectID = t_o.id)

PRINT 'delete translationObjects from invisible fieldSets'
DELETE FROM translationObjects WHERE id IN
(SELECT t_o.id FROM translationObjects t_o
INNER JOIN @table_fieldsets fs ON fs.nameTranslationObjectID = t_o.id)

PRINT 'delete invisible activities'
DELETE FROM activities WHERE visible = 0

PRINT 'delete invisible workflowLayers'
DELETE FROM WorkflowLayers WHERE visible = 0

PRINT 'delete invisible workflows'
DELETE FROM workflows WHERE visible = 0

PRINT 'delete unused workflow categories'
DELETE FROM workflowCategories
WHERE ID NOT IN
(SELECT w.categoryID FROM workflows w)

PRINT 'delete translations from invisible workflows'
DELETE FROM translations WHERE id IN
(SELECT t.id FROM translations t
INNER JOIN translationObjects t_o ON t.translationObjectID = t_o.id
INNER JOIN @table_workflows w ON w.nameTranslationObjectID = t_o.id)

PRINT 'delete translationObjects from invisible workflows'
DELETE FROM translationObjects WHERE id IN
(SELECT t_o.id FROM translationObjects t_o
INNER JOIN @table_workflows w ON w.nameTranslationObjectID = t_o.id)

PRINT 'getting obsolete umraVariables'
DECLARE @table_umravariables TABLE (id bigint)
INSERT INTO @table_umravariables
SELECT v.ID
FROM umraVariables v
WHERE (ISNULL((SELECT COUNT(id) FROM fields f WHERE f.defaultValueUmraVariableID = v.ID OR f.umraVariableID = v.ID), 0) +
ISNULL((SELECT COUNT(id) FROM activities a WHERE a.targetUmraVariableID = v.ID OR a.umraVariableID = v.ID), 0) +
ISNULL((SELECT COUNT(id) FROM umraVariables v_r WHERE v_r.repositoryUmraScriptVariableID = v.ID), 0)) = 0
AND v.ID <> (SELECT value FROM settings s WHERE s.name = 'delegation_RepositoryVariableID')
AND v.ID <> (SELECT value FROM settings s WHERE s.name = 'assignments_RepositoryVariableID')

PRINT 'delete obsolete umraVariables'
DELETE FROM umraVariables WHERE ID IN
(SELECT v.id FROM @table_umravariables v)

PRINT 'getting obsolete translations'
DECLARE @table_translations TABLE (id bigint)
INSERT INTO @table_translations
SELECT t.id
FROM translations t
INNER JOIN translationObjects t_o ON t_o.id = t.translationObjectID
WHERE t_o.id NOT IN (SELECT w.nameTranslationObjectID FROM workflows w)
AND t_o.id NOT IN (SELECT w.descriptionTranslationObjectID FROM workflows w)
AND t_o.id NOT IN (SELECT fs.nameTranslationObjectID FROM fieldSets fs)
AND t_o.id NOT IN (SELECT f.nameTranslationObjectID FROM fields f)
AND t_o.id NOT IN (SELECT wc.nameTranslationObjectID FROM workflowCategories wc)
AND t_o.id NOT IN (SELECT tp.valueTranslationObjectID FROM textParts tp)
AND t_o.id NOT IN (SELECT fv.errorMessageTranslationObjectID FROM fieldValidators fv)
AND t_o.id NOT IN (SELECT uv_d.defaultValueTranslationObjectID FROM umraVariables uv_d)
AND t_o.id NOT IN (SELECT uv_n.displayNameTranslationObjectID FROM umraVariables uv_n)
AND t_o.isDefault = 0