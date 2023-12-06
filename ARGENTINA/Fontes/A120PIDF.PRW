#INCLUDE "PROTHEUS.CH"

/*====================================================================================\
|Programa  | A120PIDF        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function A120PIDF()

	Local aArea1    		:= GetArea()
	Local aArea2    		:= SC1->(GetArea())
	Local cFiltro   		:= ''
	Local _aRet 			:= {}
	Local _aParamBox 		:= {}

	AADD(_aParamBox,{1,"SC",Space(6) ,"","EXISTCPO('SC1')","SC1","",0,.F.})

	If ParamBox(_aParamBox,"Selecionar SC",@_aRet,,,.T.,,500)
		cFiltro := " C1_NUM=='"+MV_PAR01+"'"
	EndIf

	aRetFiltro := {cFiltro, }

	RestArea(aArea2)
	RestArea(aArea1)

Return (aRetFiltro)
