#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMBRWBTN   บAutor  ณMicrosiga           บ Data ณ  02/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada ativado ao pressionar qualquer botao da    บฑฑ
ฑฑบ          ณMarkBrow ou MBrowse                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบParametrosณPARAMIXB[1] = ALIAS                                         บฑฑ
ฑฑบ          ณPARAMIXB[2] = RECNO                                         บฑฑ
ฑฑบ          ณPARAMIXB[3] = BOTAO                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRETORNO     = LOGICO                                        บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MBRWBTN()

	Local cAlias	:= Paramixb[1]
	Local nRec		:= Paramixb[2]
	Local nBotao	:= Paramixb[3]
	Local lRet		:= .T.
 
	If !('STREGDES'  $ FunName()) //giovani zago sei la isso nao esta funcionando no mvc
		lRet := U_STFSVE74(cAlias, nRec, nBotao)
	EndIf
Return lRet