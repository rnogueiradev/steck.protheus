#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT510        | Autor | RENATO.OLIVEIRA           | Data | 17/04/2021  |
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

User Function STFAT510()

	Local aCab 	:= {}
	Local aItem := {}
	Local aItens:= {}
	Local _aArea:= GetArea()
	Private lMsErroAuto := .F.

	If !SF2->(F2_CLIENTE+F2_LOJA)=="03346702"
		MsgAlert("NF não é para Arujá, verifique!")
		Return
	EndIf

	If !MsgYesNo("Confirma a geração da NF de entrada?")
		Return()
	EndIf

	aadd(aCab,{"F1_TIPO" 	,"N" ,NIL})
	aadd(aCab,{"F1_FORMUL" 	,"N" ,NIL})
	aadd(aCab,{"F1_DOC" 	,SF2->F2_DOC ,NIL})
	aadd(aCab,{"F1_SERIE" 	,SF2->F2_SERIE ,NIL})
	aadd(aCab,{"F1_EMISSAO" ,DDATABASE ,NIL})
	aadd(aCab,{"F1_DTDIGIT" ,DDATABASE ,NIL})
	aadd(aCab,{"F1_FORNECE" ,"005764" ,NIL})
	aadd(aCab,{"F1_LOJA" 	,"02"	 ,NIL})
	aadd(aCab,{"F1_ESPECIE" ,"SPED" ,NIL})
	aadd(aCab,{"F1_COND" 	,"" ,NIL})
	aadd(aCab,{"F1_MOEDA" 	, 1 ,Nil})
	aadd(aCab,{"F1_TXMOEDA" , 1 ,Nil})
	aadd(aCab,{"F1_STATUS" 	, "A" ,Nil})
	aadd(aCab,{"F1_CHVNFE" ,SF2->F2_CHVNFE ,NIL})
	aadd(aCab,{"F1_EST" ,SF2->F2_EST ,NIL})

	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	SD2->(DbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA))) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	While SD2->(!Eof()) .And. SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)==;
	SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)

		SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))

		aItem := {}
		aadd(aItem,{"D1_ITEM" 	,PADL(SD2->D2_ITEM,4,"0") ,NIL})
		aadd(aItem,{"D1_COD" 	,SD2->D2_COD ,NIL})
		aadd(aItem,{"D1_QUANT" 	,SD2->D2_QUANT ,NIL})
		aadd(aItem,{"D1_VUNIT" 	,SD2->D2_PRCVEN ,NIL})
		aadd(aItem,{"D1_TES" 	,Iif(SD2->D2_TES=="854","448","449") ,NIL})
		aadd(aItem,{"D1_LOCAL" 	,SB1->B1_LOCPAD ,NIL})
		aAdd(aItens,aItem)

		SD2->(DbSkip())
	EndDo

	MSExecAuto({|x,y,z,a,b| MATA103(x,y,z,,,,,a,,,b)},aCab,aItens,3)

	If !lMsErroAuto
		MsgAlert("Nota Fiscal Gerada com Sucesso!!","Atenção")
	Else
		MostraErro()
	EndIf

	RestArea(_aArea)

Return()
