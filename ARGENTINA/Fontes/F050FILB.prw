#Include 'Protheus.ch'

User Function F050FILB()

Local cFiltro := " "
Local _cF050FIL := GetMv('ST_F050FIL',,'000000/001084')

If !__cUserId $ _cF050FIL

    cFiltro := "E2_TIPO <> 'FOL'"

EndIf

Return cFiltro