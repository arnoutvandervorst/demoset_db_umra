-- all ObjectAttributes for latest snapshot
SELECT * FROM fnSnapshot_objectattributes_get(0,NULL)
-- all Objects for latest snapshot
SELECT * FROM fnSnapshot_objects_get(0,NULL,NULL)
-- all cache records for 'user' objects
SELECT * FROM fnCache_get('user')
-- all nested relationships for all objects in latest snapshot
SELECT * FROM fnSnapshot_relationships_get(1,0,NULL,NULL,NULL)
-- all objects in tag ID=1
SELECT * FROM fnTag_objects_get(1,NULL,1,0)
-- all tags where is_active = true
SELECT * FROM fnTags_get(1,NULL,NULL)
-- all objects in tags where is_active = true
SELECT * FROM fnTags_objects_get(NULL,1,0)
-- all relationships between objects in tags where is_active = true
SELECT * FROM fnTags_relationships_get(1,0,NULL,NULL)
-- relationship report on AD on attributes department + title
EXEC spSnapshot_table_relationships_report 'department','title'
-- tag relationships not present in AD
EXEC spTags_relationships_snapshot_left
-- tag relationship matches in AD
EXEC spTags_relationships_snapshot_common
-- tag relationships deactivated, still present in AD
EXEC spTags_relationships_snapshot_right
-- group memberships in AD not present in any tag relationship
EXEC spTags_relationships_snapshot_right_all