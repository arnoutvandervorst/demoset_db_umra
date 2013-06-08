DECLARE @id_snapshot bigint
SET @id_snapshot = (SELECT MAX(id) FROM Snapshots)
DECLARE @id_snapshot_delta bigint
SET @id_snapshot_delta = (SELECT MIN(id) FROM Snapshots)

SELECT * FROM fnSnapshot_objectattributes_get(default,default,default)
SELECT * FROM fnSnapshot_objectattribute_get(default,default)
SELECT * FROM fnSnapshot_objects_get(default,default,default)
SELECT * FROM fnCache_get('user')
SELECT * FROM fnSnapshot_relationships_get(default,default,default,default,default,default,default)
SELECT * FROM fnTag_objects_get(default,default,default,default)
SELECT * FROM fnTags_get(default,default,default)
SELECT * FROM fnTags_get(default,'default',default)
SELECT * FROM fnTags_get(0,default,default)
SELECT * FROM fnTags_get(0,default,'application')
SELECT * FROM fnTags_objects_get(NULL,1,1,1)
SELECT * FROM fnTags_objects_get(NULL,1,1,0)
SELECT * FROM fnTags_objects_get(NULL,1,0,0)
SELECT * FROM fnTags_relationships_get(1,1,1,'group','user')
SELECT * FROM fnTags_relationships_get(1,1,0,'group','user')
SELECT * FROM fnTags_relationships_get(1,0,0,'group','user')
SELECT * FROM fnTags_relationships_get(0,0,0,'group','user')
EXEC spSnapshot_table_relationships_report 'department,title'
EXEC spSnapshot_relationships_get_delta @id_snapshot, @id_snapshot_delta
EXEC spSnapshot_objectattributes_get_delta @id_snapshot, @id_snapshot_delta
EXEC spSnapshot_objects_get_delta @id_snapshot, @id_snapshot_delta
EXEC spSnapshot_objects_search 0,'sAMAccountName','mvandijk'
EXEC spSnapshot_objects_search 0,NULL,'mvandijk'
EXEC spSnapshot_objectattributes_match 'AJ','Arnout','','','Vorst','','displayName'
EXEC spTags_relationships_snapshot_left
EXEC spTags_relationships_snapshot_common
EXEC spTags_relationships_snapshot_right
EXEC spTags_relationships_snapshot_right_all
EXEC spTag_objects_timer_get 1, 'user'
EXEC spTags_objects_timer_get 'user'
EXEC spTags_objects_left 'CN=Marcel van Dijk,OU=website_users,DC=wfm,DC=local',NULL,NULL
EXEC spTags_objects_common 'CN=Marcel van Dijk,OU=website_users,DC=wfm,DC=local',NULL,NULL
EXEC spTags_objects_right 'CN=Marcel van Dijk,OU=website_users,DC=wfm,DC=local',NULL,NULL
EXEC spTags_objects_timer_get
EXEC spTags_table_objects
EXEC spTags_table_objects NULL,1,1,0
EXEC spTags_table_objects NULL,1,1,1
EXEC spTag_permissions_get 1,NULL,NULL,NULL,NULL
EXEC spTags_permissions_get 'CN=Hans Blom,OU=website_users,DC=wfm,DC=local'
EXEC spTags_permissions_get 'CN=Hans Blom,OU=website_users,DC=wfm,DC=local','owner'
EXEC spTag_table_users 1,1,0
EXEC spTag_table_users 1,0,0
EXEC spTag_table_groups 1,1,0
EXEC spTag_table_groups 1,0,0
EXEC spTag_table_groups_exclusive 1,'CN=Marcel van Dijk,OU=website_users,DC=wfm,DC=local',1,1,0
EXEC spTag_table_groups_exclusive 1,'CN=Marcel van Dijk,OU=website_users,DC=wfm,DC=local',0,0,0
EXEC spTag_table_groups_exclusive 1,'CN=Marcel van Dijk,OU=website_users,DC=wfm,DC=local'
EXEC spSnapshot_attributes_get
EXEC spSnapshot_objects_get_details NULL
EXEC spSnapshot_relationships_get_details NULL
EXEC spSnapshot_sources_get
EXEC spSnapshot_table_group_attributes_managedby_users 'CN=GG_FUNC_Activiteitenbegeleider,OU=Functions,OU=Groups,OU=Organisation,DC=wfm,DC=local'
EXEC spSnapshot_table_object_member_groups_nested 'CN=Marcel van Dijk,OU=website_users,DC=wfm,DC=local'
EXEC spSnapshot_table_snapshot_manager_group_users 'CN=Hans Blom,OU=website_users,DC=wfm,DC=local','CN=GG_APP_MicrosoftProject,OU=Applications,OU=Groups,OU=Organisation,DC=wfm,DC=local'
EXEC spSnapshot_table_snapshot_manager_groups_costs 'CN=Hans Blom,OU=website_users,DC=wfm,DC=local','info'
EXEC spSnapshot_table_user_attributes_groups_managedby 'CN=Marcel van Dijk,OU=website_users,DC=wfm,DC=local'
EXEC spSnapshot_types_get
EXEC spSnapshots_get
EXEC spTags_get 1,NULL,NULL,NULL,'CN=Marcel van Dijk,OU=website_users,DC=wfm,DC=local'