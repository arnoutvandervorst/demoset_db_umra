SELECT * FROM fnSnapshot_objectattributes_get(0,NULL)
SELECT * FROM fnSnapshot_objects_get(0,NULL,NULL)
SELECT * FROM fnCache_get('user')
SELECT * FROM fnSnapshot_relationships_get(0,0,NULL,NULL,NULL)
SELECT * FROM fnTag_objects_get(1,NULL,1,0)
SELECT * FROM fnSnapshot_objects_get_attribute_related(0,'pers_nr','employeeID',NULL,NULL)
SELECT * FROM fnTags_get(1,NULL,NULL)
SELECT * FROM fnTags_get(1,'default',NULL)
SELECT * FROM fnTags_get(0,NULL,NULL)
SELECT * FROM fnTags_objects_get(NULL,1,1,1)
SELECT * FROM fnTags_objects_get(NULL,1,1,0)
SELECT * FROM fnTags_objects_get(NULL,1,0,0)
SELECT * FROM fnTags_relationships_get(1,1,1,'group','user')
SELECT * FROM fnTags_relationships_get(1,1,0,'group','user')
SELECT * FROM fnTags_relationships_get(1,0,0,'group','user')
SELECT * FROM fnTags_relationships_get(0,0,0,'group','user')
EXEC spSnapshot_table_relationships_report 'department,title'
EXEC spTags_relationships_snapshot_left
EXEC spTags_relationships_snapshot_common
EXEC spTags_relationships_snapshot_right
EXEC spTags_relationships_snapshot_right_all
EXEC spTag_objects_timer_get 1, 'user'
EXEC spTags_objects_timer_get 'user'
EXEC spTags_objects_left NULL,'default',NULL
EXEC spTags_objects_common NULL,'default',NULL
EXEC spTags_objects_right NULL,'default',NULL
EXEC spTags_objects_timer_get NULL,NULL,NULL,NULL
EXEC spTags_table_objects NULL,1,1,0
EXEC spTags_table_objects NULL,1,1,1
EXEC spTags_table_objects NULL,1,0,0
EXEC spTags_table_objects NULL,1,0,1
EXEC spTags_table_objects NULL,0,0,0
EXEC spTag_permissions_get 1,NULL,NULL,NULL,NULL
EXEC spTag_table_users 1,1,0
EXEC spTag_table_users 1,0,0
EXEC spTag_table_groups 1,1,0
EXEC spTag_table_groups 1,0,0
EXEC spTag_table_groups_exclusive 1,'mvandijk',1,0
EXEC spTag_table_groups_exclusive 1,'mvandijk',0,0
EXEC spSnapshot_attributes_get
EXEC spSnapshot_objects_get_details NULL
EXEC spSnapshot_relationships_get_details NULL
EXEC spSnapshot_sources_get
EXEC spSnapshot_table_group_attributes_managedby_users 'CN=Hans Blom,OU=website_users,DC=wfm,DC=local',NULL,NULL,NULL
EXEC spSnapshot_table_object_member_groups_nested 'CN=Hans Blom,OU=website_users,DC=wfm,DC=local',NULL
EXEC spSnapshot_table_snapshot_manager_group_users 'CN=Hans Blom,OU=website_users,DC=wfm,DC=local','CN=GG_APP_MicrosoftProject,OU=Applications,OU=Groups,OU=Organisation,DC=wfm,DC=local',NULL,NULL,NULL
EXEC spSnapshot_table_snapshot_manager_groups_costs 'CN=Hans Blom,OU=website_users,DC=wfm,DC=local','info',NULL
EXEC spSnapshot_table_user_attributes_groups_managedby 'CN=Hans Blom,OU=website_users,DC=wfm,DC=local',NULL,NULL,NULL
EXEC spSnapshot_table_user_attributes_groups_managedby 'CN=Marcel van Dijk,OU=website_users,DC=wfm,DC=local'
EXEC spSnapshot_types_get
EXEC spSnapshots_get
EXEC spTags_get 1,NULL,NULL,NULL,'CN=Marcel van Dijk,OU=website_users,DC=wfm,DC=local'