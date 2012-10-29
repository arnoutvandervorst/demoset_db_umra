SELECT * FROM fnSnapshot_objectattributes_get(0,NULL)
SELECT * FROM fnSnapshot_objects_get(0,NULL,NULL)
SELECT * FROM fnCache_get('user')
SELECT * FROM fnSnapshot_relationships_get(1,0,NULL,NULL,NULL)
SELECT * FROM fnTag_objects_get(1,NULL,1,0)
SELECT * FROM fnTags_get(1,NULL,NULL)
SELECT * FROM fnTags_objects_get(NULL,1,0)
SELECT * FROM fnTags_relationships_get(1,0,NULL,NULL)
EXEC spSnapshot_table_relationships_report 'department','title'
EXEC spTags_relationships_snapshot_left
EXEC spTags_relationships_snapshot_common
EXEC spTags_relationships_snapshot_right
EXEC spTags_relationships_snapshot_right_all