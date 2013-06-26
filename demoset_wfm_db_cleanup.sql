USE workflow
GO

UPDATE workflowLayers SET visible = 0 WHERE workflowLayers.ID IN
(SELECT workflowlayers.ID FROM workflowLayers
INNER JOIN workflows ON workflows.ID = workflowLayers.workflowID
WHERE workflows.visible = 0)

UPDATE activities SET visible = 0 WHERE activities.ID IN
(SELECT activities.ID FROM activities
INNER JOIN workflowLayers ON workflowLayers.ID = activities.workflowLayerID
WHERE workflowLayers.visible = 0)

UPDATE activities SET visible = 0 WHERE activities.ID IN
(SELECT fields.nextActivityID FROM fields
WHERE fields.visible = 0)

UPDATE fieldSets SET visible = 0 WHERE fieldsets.ID IN
(SELECT fieldsets.ID FROM fieldSets
INNER JOIN activities ON activities.ID = fieldsets.activityID
WHERE activities.visible = 0)

UPDATE fields SET visible = 0 WHERE fields.ID IN
(SELECT fields.ID FROM fields
INNER JOIN fieldSets ON fieldsets.ID = fields.fieldsetID
WHERE fieldsets.visible = 0)

UPDATE fields SET visible = 0 WHERE fields.nextActivityID IN
(SELECT activities.ID FROM activities
WHERE activities.visible = 0)

TRUNCATE TABLE workflowInstanceData
TRUNCATE TABLE workflowInstanceHistory
TRUNCATE TABLE workflowInstanceLock
TRUNCATE TABLE workflowInstanceTrace
TRUNCATE TABLE workflowDelegation
TRUNCATE TABLE repositoryData
TRUNCATE TABLE errorLog
DELETE FROM workflowInstances
DBCC CHECKIDENT (workflowInstances, RESEED, 1)

DECLARE @table_fields TABLE (id bigint, nameTranslationObjectID bigint) 
INSERT INTO @table_fields
SELECT f.id, f.nameTranslationObjectID FROM fields f WHERE f.visible = 0

DELETE FROM fields WHERE visible = 0

DECLARE @table_fieldsets TABLE (id bigint, nameTranslationObjectID bigint) 
INSERT INTO @table_fieldsets
SELECT f_s.id, f_s.nameTranslationObjectID FROM fieldSets f_s WHERE f_s.visible = 0

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
INNER JOIN @table_fieldsets f_s ON f_s.nameTranslationObjectID = t_o.id)

DELETE FROM translationObjects WHERE id IN
(SELECT t_o.id FROM translationObjects t_o
INNER JOIN @table_fieldsets f_s ON f_s.nameTranslationObjectID = t_o.id)

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
