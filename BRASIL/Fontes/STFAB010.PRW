#Include "TOTVS.CH"
#Include "RPTDEF.CH"
#INCLUDE "TBICONN.CH"

/*====================================================================================\
|Programa  | STFAB010        | Autor | RENATO.OLIVEIRA           | Data | 22/04/2021  |
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

User Function STFAB010()

	Local oPrinter
	Local _aParamBox := {}
	Local _aRet		 := {}
	Local cStartPath := GetTempPath()

	AADD(_aParamBox,{1,"Matrícula",Space(6),"","ExistCpo('SRA')","","",0,.F.})

	If !ParamBox(_aParamBox,"Filtro de chamados",@_aRet,,,.T.,,500)
		Return
	EndIf
 
	oPrinter := FWMSPrinter():New('Matrícula',6,.F.,cStartPath,.T.,,,,,.F.)
	oPrinter:Setup()
	oPrinter:setDevice(IMP_PDF)
	oPrinter:cPathPDF := cStartPath
	oPrinter:QRCode(150,150,cEmpAnt+cFilAnt+MV_PAR01, 100)
	
	oPrinter:EndPage()
	oPrinter:Preview()
	FreeObj(oPrinter)
	oPrinter := Nil

Return()
