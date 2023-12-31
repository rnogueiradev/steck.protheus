#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT290        | Autor | RENATO.OLIVEIRA           | Data | 28/11/2019  |
|=====================================================================================|
|Descri��o | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function STFAT290()

	Local aParambox		:= {}
	Local aRet			:= {}

	aAdd(aParamBox,{1,"Emails"		,Space(100)		,"@!","","","" ,0,.T.})

	If !ParamBox(aParamBox,"Cadastrar e-mails",@aRet,,,,,,,,.f.)
		Return
	EndIf

	SC5->(RecLock("SC5",.F.))
	SC5->C5_XAVENT := AllTrim(MV_PAR01)
	SC5->(MsUnLock())

	MsgAlert("E-mails gravados com sucesso!")

Return()