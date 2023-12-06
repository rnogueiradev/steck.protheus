#include 'protheus.ch'
#include 'parmtype.ch'

User Function FISFILREM()
	Local cCondic := "F2_FILIAL =='"+xFilial("SF2") + "' " +;
		".AND. Alltrim(F2_TIPODOC) >= '50' "

	If !Empty(MV_PAR02)
		cCondic += ".AND.F2_SERIE=='"+MV_PAR02+"' "
	EndIf

	If SubStr(MV_PAR01,1,1) == "1" //"1- Autorizada
		cCondic += ".AND. F2_FLREMEL $ 'E' "
	ElseIf SubStr(MV_PAR01,1,1) == "2" //"2-Rejeitadas"
		cCondic += ".AND. F2_FLREMEL $ 'M' "
	ElseIf SubStr(MV_PAR01,1,1) == "3" //"3 -não Transmitida"
		cCondic += ".AND. F2_FLREMEL $ ' ' "
	EndIf

Return(cCondic)