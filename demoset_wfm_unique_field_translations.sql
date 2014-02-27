DECLARE @table_fields_duplicate_translations TABLE (nameTranslationObjectID bigint)
DECLARE @id_translationobject bigint = 0
DECLARE @id_field bigint = 0
DECLARE @translation_nl varchar(500)
DECLARE @id_language_nl bigint = (SELECT id FROM languages WHERE code = 'nl')
DECLARE @translation_usa varchar(500)
DECLARE @id_language_usa bigint = (SELECT id FROM languages WHERE code = 'usa')
DECLARE @id_translationobject_new bigint = 0

INSERT INTO @table_fields_duplicate_translations
SELECT
f.nameTranslationObjectID
FROM fields f
WHERE f.visible = 1
GROUP BY f.nameTranslationObjectID
HAVING COUNT(f.id) > 1
ORDER BY f.nameTranslationObjectID

SELECT TOP 1 @id_translationobject = nameTranslationObjectID 
FROM @table_fields_duplicate_translations 
ORDER BY nameTranslationObjectID

WHILE @@ROWCOUNT > 0
BEGIN
	SELECT @translation_nl = t_nl.value 
	FROM translations t_nl 
	WHERE t_nl.languageID = @id_language_nl
	AND t_nl.translationObjectID = @id_translationobject

	SELECT @translation_usa = t_usa.value 
	FROM translations t_usa 
	WHERE t_usa.languageID = @id_language_usa
	AND t_usa.translationObjectID = @id_translationobject
	
	SELECT TOP 1 @id_field = f.ID
	FROM fields f
	WHERE f.nameTranslationObjectID = @id_translationobject
	ORDER BY f.id
	
	WHILE @@ROWCOUNT > 0
	BEGIN
		SELECT @id_field, @id_translationobject, @translation_nl, @translation_usa
		
		INSERT INTO translationObjects (code,isDefault)
		VALUES ('formFieldName_duplicate_' + CONVERT(varchar,@id_field),0)
		
		SET @id_translationobject_new = (SELECT SCOPE_IDENTITY())
		
		INSERT INTO translations (languageID, translationObjectID, value)
		VALUES (1,@id_translationobject_new,@translation_nl)
		
		INSERT INTO translations (languageID, translationObjectID, value)
		VALUES (2,@id_translationobject_new,@translation_usa)
		
		UPDATE fields
		SET nameTranslationObjectID = @id_translationobject_new WHERE ID = @id_field
		
		INSERT INTO translationObjects (code,isDefault)
		VALUES ('formFieldDescription_duplicate_' + CONVERT(varchar,@id_field),0)
		
		SET @id_translationobject_new = (SELECT SCOPE_IDENTITY())
		
		INSERT INTO translations (languageID, translationObjectID, value)
		VALUES (1,@id_translationobject_new,'')
		
		INSERT INTO translations (languageID, translationObjectID, value)
		VALUES (2,@id_translationobject_new,'')
		
		UPDATE fields
		SET descriptionTranslationObjectID = @id_translationobject_new WHERE ID = @id_field		
	
		SELECT TOP 1 @id_field = f.ID
		FROM fields f
		WHERE f.nameTranslationObjectID = @id_translationobject
		AND f.ID > @id_field
		ORDER BY f.id
	END

	SELECT TOP 1 @id_translationobject = nameTranslationObjectID 
	FROM @table_fields_duplicate_translations 
	WHERE nameTranslationObjectID > @id_translationobject
	ORDER BY nameTranslationObjectID
END
