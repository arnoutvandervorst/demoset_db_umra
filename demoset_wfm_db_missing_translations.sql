SELECT
t_o.id,
t_primary.value,
t_us.value
FROM translations t_primary
INNER JOIN translationObjects t_o ON t_o.id = t_primary.translationObjectID
INNER JOIN languages l_primary ON l_primary.id = t_primary.languageID
INNER JOIN translations t_us ON t_us.translationObjectID = t_o.id
INNER JOIN languages l_us ON l_us.id = t_us.languageID
WHERE l_primary.id = (SELECT id FROM languages WHERE isDefault = 1)
AND l_us.id = (SELECT id FROM languages WHERE code = 'usa')
AND LEN(t_primary.value) > 0
AND LEN(t_us.value) = 0