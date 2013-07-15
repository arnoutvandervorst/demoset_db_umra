SELECT 
v.id, 
v.name,
v.umraScript, 
w_t.value,
w_t_target.value, 
w_t_f.value,
w_t_f_default.value
FROM umraVariables v
LEFT JOIN activities a_target ON a_target.targetUmraVariableID = v.id
LEFT JOIN workflowLayers w_l_target ON w_l_target.id = a_target.workflowLayerID
LEFT JOIN workflows w_target ON w_target.id = w_l_target.workflowID
LEFT JOIN translationObjects w_t_o_target ON w_t_o_target.id = w_target.nameTranslationObjectID
LEFT JOIN translations w_t_target ON w_t_target.translationObjectID = w_t_o_target.id
	AND w_t_target.languageID = 1

LEFT JOIN activities a ON a.umraVariableID = v.ID
LEFT JOIN workflowLayers w_l ON w_l.id = a.workflowLayerID
LEFT JOIN workflows w ON w.id = w_l.workflowID
LEFT JOIN translationObjects w_t_o ON w_t_o.id = w.nameTranslationObjectID
LEFT JOIN translations w_t ON w_t.translationObjectID = w_t_o.id
	AND w_t.languageID = 1

LEFT JOIN fields f ON f.umraVariableID = v.ID
LEFT JOIN fieldSets f_s ON f_s.ID = f.fieldsetID
LEFT JOIN activities a_f ON a_f.ID = f_s.activityID
LEFT JOIN workflowLayers w_l_f ON w_l_f.id = a_f.workflowLayerID
LEFT JOIN workflows w_f ON w_f.id = w_l_f.workflowID
LEFT JOIN translationObjects w_t_o_f ON w_t_o_f.id = w_f.nameTranslationObjectID
LEFT JOIN translations w_t_f ON w_t_f.translationObjectID = w_t_o_f.id
	AND w_t_f.languageID = 1

LEFT JOIN fields f_default ON f_default.defaultValueUmraVariableID = v.ID
LEFT JOIN fieldSets f_s_default ON f_s_default.ID = f_default.fieldsetID
LEFT JOIN activities a_f_default ON a_f_default.ID = f_s_default.activityID
LEFT JOIN workflowLayers w_l_f_default ON w_l_f_default.id = a_f_default.workflowLayerID
LEFT JOIN workflows w_f_default ON w_f_default.id = w_l_f_default.workflowID
LEFT JOIN translationObjects w_t_o_f_default ON w_t_o_f_default.id = w_f_default.nameTranslationObjectID
LEFT JOIN translations w_t_f_default ON w_t_f_default.translationObjectID = w_t_o_f_default.id
	AND w_t_f_default.languageID = 1

WHERE v.name IN
(SELECT v_delta.name FROM umraVariables v_delta
WHERE v.ID <> v_delta.ID
AND v.name = v_delta.name
AND v.name <> 'Execute UMRA script')

OR v.umraScript IN
(SELECT v_delta.umraScript FROM umraVariables v_delta
WHERE v.id <> v_delta.ID
AND v.umraScript = v_delta.umraScript)

ORDER BY v.name, v.umraScript, v.ID DESC