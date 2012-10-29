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

UPDATE fieldSets SET visible = 0 WHERE fieldsets.ID IN
(SELECT fieldsets.ID FROM fieldSets
INNER JOIN activities ON activities.ID = fieldsets.activityID
WHERE activities.visible = 0)

UPDATE fields SET visible = 0 WHERE fields.ID IN
(SELECT fields.ID FROM fields
INNER JOIN fieldSets ON fieldsets.ID = fields.fieldsetID
WHERE fieldsets.visible = 0)

TRUNCATE TABLE workflowInstanceData
TRUNCATE TABLE workflowInstanceHistory
TRUNCATE TABLE workflowInstanceLock
TRUNCATE TABLE workflowInstanceTrace
TRUNCATE TABLE workflowDelegation
TRUNCATE TABLE repositoryData
TRUNCATE TABLE errorLog
DELETE FROM workflowInstances

DELETE FROM fields WHERE visible = 0
DELETE FROM fieldSets WHERE visible = 0
DELETE FROM activities WHERE visible = 0
DELETE FROM WorkflowLayers WHERE visible = 0
DELETE FROM workflows WHERE visible = 0
