#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STCOM190        | Autor | RENATO.OLIVEIRA           | Data | 07/05/2019  |
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

User Function STCOM190()

	Local _aRet 			:= {}
	Local _aParamBox 		:= {}
	Local _nPosTes 			:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"	} )
	Local _nPosCfop			:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CF"	} )
	Local _nX

	If !Type("aCols")=="A"
		MsgAlert("Opção disponível somente com a nota aberta na tela, verifique!")
		Return
	EndIf

	AADD(_aParamBox,{1,"TES",Space(3) ,"","EXISTCPO('SF4')","SF4","",0,.F.})

	If !ParamBox(_aParamBox,"Alterar TES",@_aRet,,,.T.,,500)
		Return
	EndIf

	DbSelectArea("SF4")
	SF4->(DbSetOrder(1))
	SF4->(DbGoTop())
	If !SF4->(DbSeek(xFilial("SF4")+MV_PAR01))
		MsgAlert("TES não encontrada, verifique!")
		Return
	EndIf

	For _nX:=1 To Len(aCols)

		aCols[_nx][_nPosTes] 	:= SF4->F4_CODIGO
		aCols[_nx][_nPosCfop] 	:= SF4->F4_CF

		If MaFisFound("IT",_nX)
			MaFisAlt("IT_TES",aCols[_nX][_nPosTes],_nX)
			MaFisRef("IT_TES","MT100",aCols[_nX][_nPosTes])
			RunTrigger(2,_nX,Nil,,"M->D1_TES")
		EndIf

	Next

	MsgAlert("NF atualizada com sucesso, revise os impostos por favor!")

Return()

/*====================================================================================\
|Programa  | STCOM191        | Autor | RENATO.OLIVEIRA           | Data | 07/05/2019  |
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

User Function STCOM191()

	Local _aRet 			:= {}
	Local _aParamBox 		:= {}
	Local _nPosVunit		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_VUNIT"	} )
	Local _nX

	If !Type("aCols")=="A"
		MsgAlert("Opção disponível somente com a nota aberta na tela, verifique!")
		Return
	EndIf

	If !MsgYesNo("Deseja atualizar os valores dessa NF?")
		Return
	EndIf

	For _nX:=1 To Len(aCols)
		RunTrigger(2,_nX,Nil,,"M->D1_VUNIT")
		RunTrigger(2,_nX,Nil,,"M->D1_TOTAL")
	Next

	MsgAlert("Valores atualizados com sucesso!")

Return()