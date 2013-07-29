USE workflow
GO

-- set all workflowlayers to invisible when the workflow is invisible
UPDATE workflowLayers SET visible = 0 WHERE workflowLayers.ID IN
(SELECT wl.ID FROM workflowLayers wl INNER JOIN workflows w ON w.ID = wl.workflowID WHERE w.visible = 0)

-- set activities to invisible when the workflowlayer is invisible
UPDATE activities SET visible = 0 WHERE activities.ID IN
(SELECT a.ID FROM activities a INNER JOIN workflowLayers wl ON wl.ID = a.workflowLayerID WHERE wl.visible = 0)

-- set activities to invisible when the nextActivity on the field is invisible
UPDATE activities SET visible = 0 WHERE activities.ID IN
(SELECT f.nextActivityID FROM fields f WHERE f.visible = 0)

-- set fieldsets to invisible when the activity is invisible
UPDATE fieldSets SET visible = 0 WHERE fieldsets.ID IN
(SELECT fs.ID FROM fieldSets fs INNER JOIN activities a ON a.ID = fs.activityID WHERE a.visible = 0)

-- set fields to invisible when the fieldset is invisible
UPDATE fields SET visible = 0 WHERE fields.ID IN
(SELECT f.ID FROM fields f INNER JOIN fieldSets fs ON fs.ID = f.fieldsetID WHERE fs.visible = 0)

-- set fields to invisible when the nextActivity is invisible
UPDATE fields SET visible = 0 WHERE fields.nextActivityID IN
(SELECT a.ID FROM activities a WHERE a.visible = 0)

TRUNCATE TABLE workflowInstanceData
TRUNCATE TABLE workflowInstanceHistory
TRUNCATE TABLE workflowInstanceLock
TRUNCATE TABLE workflowInstanceTrace
TRUNCATE TABLE workflowDelegation
TRUNCATE TABLE repositoryData
TRUNCATE TABLE errorLog
DELETE FROM workflowInstances
DBCC CHECKIDENT (workflowInstances, RESEED, 0)

DECLARE @table_fields TABLE (id bigint, nameTranslationObjectID bigint) 
INSERT INTO @table_fields
SELECT f.id, f.nameTranslationObjectID FROM fields f WHERE f.visible = 0

DELETE FROM fields WHERE visible = 0

DECLARE @table_fieldsets TABLE (id bigint, nameTranslationObjectID bigint) 
INSERT INTO @table_fieldsets
SELECT fs.id, fs.nameTranslationObjectID FROM fieldSets fs WHERE fs.visible = 0

DELETE FROM fieldSets WHERE visible = 0

DECLARE @table_workflows TABLE (id bigint, nameTranslationObjectID bigint) 
INSERT INTO @table_workflows
SELECT w.id, w.nameTranslationObjectID FROM workflows w WHERE w.visible = 0

DELETE FROM translations WHERE id IN
(SELECT t.id FROM translations t
INNER JOIN translationObjects t_o ON t.translationObjectID = t_o.id
INNER JOIN @table_fields f ON f.nameTranslationObjectID = t_o.id)

DELETE FROM translationObjects WHERE id IN
(SELECT t_o.id FROM translationObjects t_o
INNER JOIN @table_fields f ON f.nameTranslationObjectID = t_o.id)

DELETE FROM translations WHERE id IN
(SELECT t.id FROM translations t
INNER JOIN translationObjects t_o ON t.translationObjectID = t_o.id
INNER JOIN @table_fieldsets fs ON fs.nameTranslationObjectID = t_o.id)

DELETE FROM translationObjects WHERE id IN
(SELECT t_o.id FROM translationObjects t_o
INNER JOIN @table_fieldsets fs ON fs.nameTranslationObjectID = t_o.id)

DELETE FROM activities WHERE visible = 0
DELETE FROM WorkflowLayers WHERE visible = 0
DELETE FROM workflows WHERE visible = 0

DELETE FROM translations WHERE id IN
(SELECT t.id FROM translations t
INNER JOIN translationObjects t_o ON t.translationObjectID = t_o.id
INNER JOIN @table_workflows w ON w.nameTranslationObjectID = t_o.id)

DELETE FROM translationObjects WHERE id IN
(SELECT t_o.id FROM translationObjects t_o
INNER JOIN @table_workflows w ON w.nameTranslationObjectID = t_o.id)

DECLARE @table_umravariables TABLE (id bigint)
INSERT INTO @table_umravariables
SELECT v.ID
FROM umraVariables v
WHERE (ISNULL((SELECT COUNT(id) FROM fields f WHERE f.defaultValueUmraVariableID = v.ID OR f.umraVariableID = v.ID), 0) +
ISNULL((SELECT COUNT(id) FROM activities a WHERE a.targetUmraVariableID = v.ID OR a.umraVariableID = v.ID), 0) +
ISNULL((SELECT COUNT(id) FROM umraVariables v_r WHERE v_r.repositoryUmraScriptVariableID = v.ID), 0)) = 0
AND v.ID <> (SELECT value FROM settings s WHERE s.name = 'delegation_RepositoryVariableID')
AND v.ID <> (SELECT value FROM settings s WHERE s.name = 'assignments_RepositoryVariableID')

DELETE FROM umraVariables WHERE ID IN
(SELECT v.id FROM @table_umravariables v)


