DECLARE @table_fieldsets_duplicate_translations TABLE (nameTranslationObjectID bigint)
DECLARE @id_translationobject bigint = 0
DECLARE @id_fieldset bigint = 0
DECLARE @translation_nl varchar(500)
DECLARE @id_language_nl bigint = (SELECT id FROM languages WHERE code = 'nl')
DECLARE @translation_usa varchar(500)
DECLARE @id_language_usa bigint = (SELECT id FROM languages WHERE code = 'usa')
DECLARE @id_translationobject_new bigint = 0

INSERT INTO @table_fieldsets_duplicate_translations
SELECT
f_s.nameTranslationObjectID
FROM fieldsets f_s
WHERE f_s.visible = 1
GROUP BY f_s.nameTranslationObjectID
HAVING COUNT(f_s.id) > 1
ORDER BY f_s.nameTranslationObjectID

SELECT TOP 1 @id_translationobject = nameTranslationObjectID 
FROM @table_fieldsets_duplicate_translations 
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
	
	SELECT TOP 1 @id_fieldset = f_s.ID
	FROM fieldSets f_s
	WHERE f_s.nameTranslationObjectID = @id_translationobject
	ORDER BY f_s.id
	
	WHILE @@ROWCOUNT > 0
	BEGIN
		SELECT @id_fieldset, @id_translationobject, @translation_nl, @translation_usa
		
		INSERT INTO translationObjects (code,isDefault)
		VALUES ('formFieldSetName_duplicate_' + CONVERT(varchar,@id_fieldset),0)
		
		SET @id_translationobject_new = (SELECT SCOPE_IDENTITY())
		
		INSERT INTO translations (languageID, translationObjectID, value)
		VALUES (1,@id_translationobject_new,@translation_nl)
		
		INSERT INTO translations (languageID, translationObjectID, value)
		VALUES (2,@id_translationobject_new,@translation_usa)
		
		UPDATE fieldSets
		SET nameTranslationObjectID = @id_translationobject_new WHERE ID = @id_fieldset
		
		INSERT INTO translationObjects (code,isDefault)
		VALUES ('formFieldSetDescription_duplicate_' + CONVERT(varchar,@id_fieldset),0)
		
		SET @id_translationobject_new = (SELECT SCOPE_IDENTITY())
		
		INSERT INTO translations (languageID, translationObjectID, value)
		VALUES (1,@id_translationobject_new,'')
		
		INSERT INTO translations (languageID, translationObjectID, value)
		VALUES (2,@id_translationobject_new,'')
		
		UPDATE fieldSets
		SET descriptionTranslationObjectID = @id_translationobject_new WHERE ID = @id_fieldset	
	
		SELECT TOP 1 @id_fieldset = f_s.ID
		FROM fieldSets f_s
		WHERE f_s.nameTranslationObjectID = @id_translationobject
		AND f_s.ID > @id_fieldset
		ORDER BY f_s.id
	END

	SELECT TOP 1 @id_translationobject = nameTranslationObjectID 
	FROM @table_fieldsets_duplicate_translations 
	WHERE nameTranslationObjectID > @id_translationobject
	ORDER BY nameTranslationObjectID
END
