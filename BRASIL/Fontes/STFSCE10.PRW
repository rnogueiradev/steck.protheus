#Include "Protheus.ch" 
#INCLUDE "TOPCONN.CH"
Static __aItensPV:={}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณSTFSC10A  บAutor  ณMicrosiga           บ Data ณ  12/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณanalise de reserva com base nos PEDIDOS        				  บฑฑ
ฑฑบ          ณpara montar um espelho antes da alteracao	                 บฑฑ
ฑฑบ          ณPE MT410TOK MATA410                                         บฑฑ
ฑฑบ          ณOBS __aItensPV                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSC10A(nOpc)
	Local cNumPed 	:= M->C5_NUM
	Local aArea 	:= GetArea()
	Local aSC6Area	:= SC6->(GetArea())

	__aItensPV:={}

	If ! U_STProducao()
		Return .t.
	EndIf

	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial('SC6')+cNumPed))
	While SC6->(! Eof() .and. C6_FILIAL+C6_NUM == xFilial('SC6')+cNumPed)
		If AvalTes(SC6->C6_TES,'S')
			SC6->(aadd(__aItensPV,{C6_ITEM,C6_PRODUTO,C6_QTDVEN,0}))
		EndIf
		SC6->(DbSkip())
	End

	RestArea(aSC6Area)
	RestArea(aArea)
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณSTFSC10B  บAutor  ณMicrosiga           บ Data ณ  12/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณfuncao para gravar a reserva ou falta         				  บฑฑ
ฑฑบ          ณPE M410STTS MATA410                                         บฑฑ
ฑฑบ          ณOBS __aItensPV                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSC10B() //alterado dia 12/04/2013 para nใo duplicar as reservas
	Local lExcluir := !INCLUI .and. ! ALTERA
	Local cNumPed 	:= M->C5_NUM
	Local aArea 	:= GetArea()
	Local aSC6Area	:= SC6->(GetArea())
	Local nPosProd	:= aScan(aHeader,{|x| Trim(x[2])=="C6_PRODUTO"})
	LocaL nPosItem	:= aScan(aHeader,{|x| Trim(x[2])=="C6_ITEM"})
	Local nPosQtd	:= aScan(aHeader,{|x| Trim(x[2])=="C6_QTDVEN"})
	Local nX
	Local cTes
	Local _aArea
	Local _nQtdSal

	If ! U_STProducao()
		Return
	EndIf

	If lExcluir
		U_STDelFR(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO)
	Else

		If !(SC5->C5_TIPO == "N") //.AND. INCLUI
			Return
		EndIf

		//For nx:= 1 to len(aCols)  // SINCRONIZAR ACOLS COM __AITENSPV

		cTes 	 := SC6->C6_TES
		cItemPed := SC6->C6_ITEM
		cProduto := SC6->C6_PRODUTO

		IF !INCLUI
			U_STDelFR(cNumPed+cItemPed,cProduto)
		ENDIF

		//If ! AvalTes(cTes,'S')
		//	Loop
		//EndIf

		//	   	If U_STIsIndireto(cProduto) //Leonardo Flex -> Comentado para nao verificar se e' indireto quando vem de pedidod e venda
		//	   		Loop
		//	   	EndIf

		//If !GdDeleted(nX)
		//_aArea	:= GetArea("SC6")        //alterado em 250413 pois estava pegando o C6_QTDVEN direto ao inv้s de fazer C6_QTDVEN-C6_QTDENT abre
		//DbSelectArea("SC6")
		//DbSetOrder(1) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
		//SC6->(DbSeek(xFilial("SC6")+cNumPed+cItemPed+cProduto))

		//iF !SC6->(Eof())
		_nQtdSal	:= SC6->C6_QTDVEN - SC6->C6_QTDENT
		//EndIf
		//RestArea(_aArea)  				//alterado em 250413 pois estava pegando o C6_QTDVEN direto ao inv้s de fazer C6_QTDVEN-C6_QTDENT fecha
		//Endif

		//Next

	EndIf

	U_STGrvSt(cNumPed,SC5->C5_XTIPF=="2")  // analisa e grava o status
	U_STPriSC5()  // grava prioridade

	__aItensPV:={}
	RestArea(aSC6Area)
	RestArea(aArea)
Return
///////////rotina antiga ///////////////////
User Function oldSTFSC10B()
	Local lExcluir := !INCLUI .and. ! ALTERA
	Local cNumPed 	:= SC5->C5_NUM
	Local aArea 	:= GetArea()
	Local aSC6Area	:= SC6->(GetArea())
	Local nPosProd	:= aScan(aHeader,{|x| Trim(x[2])=="C6_PRODUTO"})
	LocaL nPosItem	:= aScan(aHeader,{|x| Trim(x[2])=="C6_ITEM"})
	Local nPosQtd	:= aScan(aHeader,{|x| Trim(x[2])=="C6_QTDVEN"})
	Local nX
	Local cTes
	If ! U_STProducao()
		Return
	EndIf

	If lExcluir
		For nX:= 1 to len(aCols)
			cItemPed := GDFieldGet("C6_ITEM",nX)
			cProduto := GDFieldGet("C6_PRODUTO",nX)
			U_STDelFR(cNumPed+cItemPed,cProduto)
		Next
	Else
		If !(SC5->C5_TIPO == "N") //.AND. INCLUI
			Return
		EndIf

		For nx:= 1 to len(aCols)  // SINCRONIZAR ACOLS COM __AITENSPV
			cTes := GDFieldGet("C6_TES",nX)
			If ! AvalTes(cTes,'S')
				Loop
			EndIf

			If (nPos := aScan(__aItensPV,{|x| x[2] == aCols[nX,nPosProd]})) > 0
				__aItensPV[nPos,4] := aCols[nX,nPosQtd]
			Else
				Aadd(__aItensPV,{aCols[nX,nPosItem],aCols[nX,nPosProd],0,aCols[nX,nPosQtd]})
			Endif
		Next
		For nx:= 1 to len(__aItensPV)
			If __aItensPV[nX,3]==__aItensPV[nX,4]
				Loop
			EndIf
			cItemPed := __aItensPV[nX,1]
			cProduto := __aItensPV[nX,2]
			nQtde		:= __aItensPV[nX,4]-__aItensPV[nX,3]
			//   	If U_STIsIndireto(cProduto)  // COMENTADO GALLO EM 10/05/13
			//   		Loop
			//   	EndIf
		Next
	EndIf

	U_STGrvSt(cNumPed,SC5->C5_XTIPF=="2")  // analisa e grava o status
	U_STPriSC5()  // grava prioridade

	__aItensPV:={}
	RestArea(aSC6Area)
	RestArea(aArea)
Return

//===================================================================================================
//===================================================================================================
//===================================================================================================
//===================================================================================================
//===================================================================================================

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณSTFSC10C  บAutor  ณMicrosiga           บ Data ณ  12/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para eliminar a falta ou reservas do documento       บฑฑ
ฑฑบ          ณda OP pelo PE MTA650AE MATA650                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFSC10C()
	Local cNumOP 	:= SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)
	Local aArea 	:= GetArea()
	Local aSD4Area	:= SD4->(GetArea())

	If ! U_STProducao()
		Return
	EndIf

	U_STDelDoc(cNumOP)

	RestArea(aSD4Area)
	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณSTFSC10D  บAutor  ณMicrosiga           บ Data ณ  12/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para manutencao de falta ou reservas                 บฑฑ
ฑฑบ          ณda OP pelo PE MA650EMP MATA650                              บฑฑ
ฑฑบ          ณOBS __aItensOP                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSC10D()
	Local cNumOP 	:= SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)
	Local aArea 	:= GetArea()
	Local aSD4Area	:= SD4->(GetArea())
	Local _cLocProd := GetMv("MV_LOCPROC")

	If ! U_STProducao()
		Return
	EndIf

	SD4->(DbSetOrder(2))
	SD4->(DbSeek(xFilial('SD4')+cNumOP))
	While SD4->(! Eof() .and. D4_FILIAL+Left(D4_OP,11) == xFilial('SD4')+cNumOP)

		DbSelectArea("CB7")
		CB7->(DbSetOrder(5))
		//If U_STIsIndireto(SD4->D4_COD) .OR. !ALLTRIM(SD4->D4_LOCAL)$"01#03"  // giovani zago 13/04/2017

		If U_STIsIndireto(SD4->D4_COD) .OR. !ALLTRIM(SD4->D4_LOCAL)$"01#03" .Or.  (CB7->(DbSeek(xFilial('CB7')+cNumOP))   .And. CB7->CB7_STATUS <> '9')   //== _cLocProd                  // GALLO EM 280613
			SD4->(DbSkip())
			Loop
		EndIf

		SD4->(U_STGrvFR(cNumOP,D4_COD,D4_QTDEORI))
		SD4->(DbSkip())

	End

	U_STPriSC2()  // grava prioridade
	U_STGrvSt(cNumOP,.T.)  // analisa e grava o status
	RestArea(aSD4Area)
	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณSTFSC10E  บAutor  ณMicrosiga           บ Data ณ  12/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para validar se e' possivel alterar/excluir um       บฑฑ
ฑฑบ          ณempenho de producao manualmente (chamado pelo ponto de      บฑฑ
ฑฑบ          ณentrada MT380INC                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSC10E()
	If ! U_STProducao()
		Return .T.
	EndIf

	If !INCLUI .and. !Empty(SD4->D4_XORDSEP)
		MsgAlert("Existe uma ordem de separa็ใo para este empenho (Ord. Sep. nro "+SD4->D4_XORDSEP+")","Opera็ใo nใo permitida!")
		Return .F.
	Endif
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณSTFSC10F  บAutor  ณMicrosiga           บ Data ณ  12/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para validar se e' possivel alterar/excluir uma      บฑฑ
ฑฑบ          ณOP MATA650                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSC10F()
	Local cNumOP 	:= M->(C2_NUM+C2_ITEM+C2_SEQUEN)
	Local aArea 	:= GetArea()
	Local aSD4Area	:= SD4->(GetArea())
	Local lRet		:= .t.

	If ! U_STProducao()
		Return .T.
	EndIf

	SD4->(DbSetOrder(2))
	SD4->(DbSeek(xFilial('SD4')+cNumOP))
	While SD4->(! Eof() .and. Alltrim(D4_FILIAL+D4_OP) == xFilial('SD4')+cNumOP)
		If ! Empty(SD4->D4_XORDSEP)
			MsgAlert("Manuten็ใo/Exclusใo na OP nใo permitida. Existe ordem de separa็ใo gerada:"+SD4->D4_XORDSEP+" (Empenho)","Aten็ใo")
			lRet:= .f.
			Exit
		EndIf
		SD4->(DbSkip())
	End

	If cEmpAnt = '03'
		DbSelectArea("CB7")
		CB7->(DbSetOrder(5))
		CB7->(DbGoTop())
		If CB7->(DbSeek(xFilial("CB7")+cNumOP))
			MsgAlert("Manuten็ใo/Exclusใo na OP nใo permitida. Existe ordem de separa็ใo gerada: "+CB7->CB7_ORDSEP,"Aten็ใo")
			lRet:= .f.
		EndIf
	EndIf

	RestArea(aSD4Area)
	RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณSTFSC10G  บAutor  ณMicrosiga           บ Data ณ  12/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para manutencao da falta ou reserva no PE            บฑฑ
ฑฑบ          ณOP MTGRVEMP DO GRAVAEMP SIGACUSB                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSC10G()
	Local aArea		:= GetArea()
	Local aAreaSC2 := SC2->(GetArea())
	Local cProduto	:= PARAMIXB[01]
	Local nQtde		:= PARAMIXB[03]
	Local cOp		:= Alltrim(PARAMIXB[09])
	Local cOrigem	:= PARAMIXB[13]
	Local lEstorno	:= PARAMIXB[14]

	If ! U_STProducao()
		Return
	EndIf

	If cOrigem == "SC2" .AND. FunName() =="MATA380" .and.  ! U_STIsIndireto(cProduto)
		If lEstorno
			SD4->(U_STGrvFR(cOp,cProduto,nQtde*-1))
		Else
			SD4->(U_STGrvFR(cOp,cProduto,nQtde))
		EndIf
		SC2->(DbSetOrder(1))
		SC2->(DbSeek(xFilial('SC2')+cOP))
		U_STPriSC2()  // grava prioridade
		U_STGrvSt(cOp,.T.)  // analisa e grava o status
	EndIf
	RestArea(aAreaSC2)
	RestArea(aArea)
Return

/*
=====================================================================================================================================
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณSTFSC10H  บAutor  ณMicrosiga           บ Data ณ  12/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para distribui็ใode saldo estqoue conforme prioridadeบฑฑ
ฑฑบ          ณ												                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSC10H(cProduto,nSaldo,_cLocal)
	Local aArea			:= GetArea()
	Local aPrioDF		:={}
	Local aPrioFalta	:={}
	Local nQtde			:=0
	Local cDoc			:= ''
	Local cFilDP 		:= Right(AllTrim(GetMV("FS_DEPOSIT")),2)
	Local nX,nY,nI
	Local aSaldoIt		:={}
	Local aFiliais 	:={cFilAnt,cFilDP}
	Local nSldDisp 	:= 0
	Default _cLocal := ""

	If ! U_STProducao()
		Return
	EndIf

	BuscaResDP(cProduto,aPrioDF)
	BuscaFalta(cProduto,aPrioFalta)

	aSort(aPrioDF		,,,{|x,y|  x[4]+x[1] < y[4]+y[1]})
	aSort(aPrioFalta	,,,{|x,y|  x[1] < y[1] })

	If ! Empty(nSaldo)
		For nx:= 1 to len(aPrioDF)
			cDoc		:= aPrioDF[nX,2]
			nQtde		:= aPrioDF[nX,3]
			If nSaldo >= nQtde
				U_STReserva(cDoc,cProduto,nQtde,"-",cFilDP)
				U_STReserva(cDoc,cProduto,nQtde,"+",cFilAnt)
				nSaldo-= nQtde
				aPrioDF[nX,3]-= nQtde
				U_STGrvSt(cDoc)
			Else
				U_STReserva(cDoc,cProduto,nSaldo,"-",cFilDP)
				U_STReserva(cDoc,cProduto,nSaldo,"+",cFilAnt)
				aPrioDF[nX,3]-= nSaldo
				U_STGrvSt(cDoc)
				nSaldo:= 0
				Exit
			Endif
		Next
		For nx:= 1 to len(aPrioFalta)
			cDoc		:= aPrioFalta[nX,2]
			nQtde		:= aPrioFalta[nX,3]
			If nSaldo >= nQtde
				U_STFalta(cDoc,cProduto,nQtde,"-")
				U_STReserva(cDoc,cProduto,nQtde,"+",cFilAnt)
				nSaldo-= nQtde
				aPrioFalta[nX,3]-= nQtde
				U_STGrvSt(cDoc)
			Else
				U_STFalta(cDoc,cProduto,nSaldo,"-")
				U_STReserva(cDoc,cProduto,nSaldo,"+",cFilAnt)
				aPrioFalta[nX,3]-= nSaldo
				U_STGrvSt(cDoc)
				Exit
			Endif
		Next
	EndIf

	// verificar outros saldos e remanejar o documentos entre faltas, reservas e deposito fechado
	For nY := 1 to 2
		aSaldoIt	:= {}
		U_STFSVE50(cProduto,aFiliais[nY],_cLocal,aSaldoIt )
		For nI:=1 to len(aSaldoIt)
			If ! aSaldoIt[nI,4]  // ARMAZEM DIFRENTE DO PADRAO
				Loop
			EndIf
			nSldDisp := SuperVal(aSaldoIt[nI,3])
			If nSldDisp <= 0
				Loop
			EndIf
			If nY == 1 // somente para filial producao
				For nx:= 1 to len(aPrioDF)
					If Empty(aPrioDF[nX,3])
						Loop
					EndIf
					cDoc		:= aPrioDF[nX,2]
					nQtde		:= aPrioDF[nX,3]
					If nSldDisp >= nQtde
						U_STReserva(cDoc,cProduto,nQtde,"-",cFilDP)
						U_STReserva(cDoc,cProduto,nQtde,"+",cFilAnt)
						nSldDisp-= nQtde
						aPrioDF[nX,3]-= nQtde
						U_STGrvSt(cDoc)
					Else
						U_STReserva(cDoc,cProduto,nSldDisp,"-",cFilDP)
						U_STReserva(cDoc,cProduto,nSldDisp,"+",cFilAnt)
						aPrioDF[nX,3]-= nSldDisp
						U_STGrvSt(cDoc)
						nSldDisp:= 0
						Exit
					Endif
				Next
			EndIf
			For nx:= 1 to len(aPrioFalta)
				If Empty(aPrioFalta[nX,3])
					Loop
				EndIf
				cDoc		:= aPrioFalta[nX,2]
				nQtde		:= aPrioFalta[nX,3]
				If nSldDisp >= nQtde
					U_STFalta(cDoc,cProduto,nQtde,"-")
					U_STReserva(cDoc,cProduto,nQtde,"+",aFiliais[nY],aFiliais[nY])	//renato/leo  ajustado em 10/04/13
					nSldDisp-= nQtde
					aPrioFalta[nX,3]-= nQtde
					U_STGrvSt(cDoc)
				Else
					U_STFalta(cDoc,cProduto,nSldDisp,"-")
					U_STReserva(cDoc,cProduto,nSldDisp,"+",aFiliais[nY],aFiliais[nY]) 	//renato/leo  ajustado em 10/04/13
					aPrioFalta[nX,3]-= nSldDisp
					U_STGrvSt(cDoc)
					Exit
				Endif
			Next
		Next
	Next
	RestArea(aArea)
Return

Static Function BuscaResDP(cProduto,aPriori)
	Local cFilDP 		:= Right(AllTrim(GetMV("FS_DEPOSIT")),2)
	Local aArea 		:= GetArea()
	Local aPA2Area 	:= PA2->(GetArea())
	Local aSC5Area 	:= SC5->(GetArea())
	Local aSC2Area 	:= SC2->(GetArea())
	Local cPriori		:= ""
	Local nTotal		:= 0

	SC5->(DbSetOrder(1))
	SC2->(DbSetOrder(1))
	dbSelectArea("SC9")
	SC9->(	dbSetOrder(1) )
	PA2->(DbSetOrder(1))
	PA2->(DbSeek(xFilial('PA2')+cProduto+cFilDP))
	While PA2->(! Eof() .and. PA2_FILIAL+PA2_CODPRO+PA2_FILRES ==xFilial('PA2')+cProduto+cFilDP)
		If Len(Alltrim(PA2->PA2_DOC))==11
			If ! SC2->(DbSeek(xFilial('SC2')+Alltrim(PA2->PA2_DOC)))
				PA2->(DbSkip())
				Loop
			EndIf
			cPriori	:= SC2->C2_XPRIORI
		Else
			If ! SC5->(DbSeek(xFilial('SC5')+Left(PA2->PA2_DOC,6)))
				PA2->(DbSkip())
				Loop

			Else

				If	SC9->(dbSeek(xFilial("SC9")+SC5->C5_NUM))  .And. SC9->C9_BLCRED = '09'
					PA2->(DbSkip())
					Loop
				EndIf
			EndIf
			cPriori	:= SC5->C5_XPRIORI
		EndIf
		PA2->(aadd(aPriori,{cPriori,PA2_DOC,PA2_QUANT}))
		nTotal +=PA2->PA2_QUANT
		PA2->(DbSkip())
	End
	RestArea(aPA2Area)
	RestArea(aSC5Area)
	RestArea(aSC2Area)
	RestArea(aArea)
Return nTotal

Static Function BuscaFalta(cProduto,aPriori)
	Local aArea 		:= GetArea()
	Local aPA1Area 	:= PA1->(GetArea())
	Local aSC5Area 	:= SC5->(GetArea())
	Local aSC2Area 	:= SC2->(GetArea())
	Local cPriori		:= ""
	Local _cOper := "01"

	dbSelectArea("SC6")

	SC5->(DbSetOrder(1))
	SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	SC2->(DbSetOrder(1))

	dbSelectArea("SC9")
	SC9->(	dbSetOrder(1) )
	PA1->(DbSetOrder(1))
	PA1->(DbSeek(xFilial('PA1')+cProduto))
	While PA1->(! Eof() .and. PA1_FILIAL+PA1_CODPRO ==xFilial('PA1')+cProduto)
		If Len(Alltrim(PA1->PA1_DOC))==11
			If ! SC2->(DbSeek(xFilial('SC2')+Alltrim(PA1->PA1_DOC)))
				PA1->(DbSkip())
				Loop
			EndIf
			cPriori	:= SC2->C2_XPRIORI
		Else
			If ! SC5->(DbSeek(xFilial('SC5')+Left(PA1->PA1_DOC,6)))
				PA1->(DbSkip())
				Loop
			Else
				If	SC5->C5_EMISSAO < STOD('20170101')
					PA1->(DbSkip())
					Loop
				EndIf
				If	SC9->(dbSeek(xFilial("SC9")+SC5->C5_NUM)) .And. SC9->C9_BLCRED = '09'
					PA1->(DbSkip())
					Loop
				EndIf
				If	SC5->C5_XPRIORI = '99999999999999' .And. GetMv('ST_PRIOK',,.T.)
					PA1->(DbSkip())
					Loop
				EndIf
			EndIf

			If 	SC5->C5_CLIENTE $ GetMv("ST_CLIPRIO",,' ')//giovani zago altera a prioridade para clientes especificos ex.: Leroy chamado:
				cPriori	:= '000000'
			Else
				cPriori	:= SC5->C5_XPRIORI
			EndIf

			If SC6->(MsSeek(SC5->(C5_FILIAL+C5_NUM)))
				_cOper := SC6->C6_OPER
			EndIf

		EndIf
		PA1->(aadd(aPriori,{cPriori,PA1_DOC,PA1_QUANT,_cOper}))
		PA1->(DbSkip())
	End
	RestArea(aPA1Area)
	RestArea(aSC5Area)
	RestArea(aSC2Area)
	RestArea(aArea)
Return

//=====================================================================================================================================

/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณSTFSC10I  บAutor  ณMicrosiga           บ Data ณ  12/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para distribui็ใode saldo estqoue conforme prioridadeบฑฑ
ฑฑบ          ณutilizando no PE MTA265I MATA265	                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFSC10I()
	Local aArea		:= GetArea()
	Local aAreaSDA	:= SDA->(GetArea())
	Local aAreaSD3	:= SD3->(GetArea())
	Local aAreaSC2	:= SC2->(GetArea())
	Local aAreaSC6	:= SC6->(GetArea())

	Local cFilDP	:= Right(AllTrim(GetMV("FS_DEPOSIT")),2)
	Local nQtde		:= 0
	Local cDoc		:= ''
	Local cPedido	:= ""
	Local aItens	:= {}
	Local cProduto	:= SDB->DB_PRODUTO
	LocaL nSaldo 	:= SDB->DB_QUANT
	Local nVerSaldo	:= SDB->DB_QUANT
	Local cLocPad	:= Posicione("SB1",1,xFilial('SB1')+SDB->DB_PRODUTO,"B1_LOCPAD")
	Local cEmpProd	:= Substr(GetMV("FS_PRODUCA"),1,2)
	Local cFilProd	:= Substr(GetMV("FS_PRODUCA"),3,2)
	Local nX

	If ! U_STProducao()
		StartJob( "U_STFSC10R", GetEnvServer(), .F., cEmpProd , cFilProd , cProduto)
		Return
	EndIf

	If SDB->DB_LOCAL <> cLocPad
		Return
	EndIf

	If SDA->DA_ORIGEM == "SD3"
		SD3->(DBSetorder(4))
		SD3->(DbSeek(xFilial("SD3"+SDA->DA_NUMSEQ)))
		cOp := SD3->D3_OP
		If ! Empty(cOP)
			SC2->(DbSetOrder(1))
			SC2->(DbSeek(xFilial('SC2')+cOP))
			cPedido:= SC2->C2_XPEDIDO
			If ! Empty(cPedido)
				SC6->(DbSetOrder(1))
				SC6->(DbSeek(xFilial('SC6')+cPedido))
				While SC6->(! Eof() .and. C6_FILIAL+C6_NUM == xFilial('SC6')+cPedido)
					If SC6->C6_PRODUTO == cProduto
						aadd(aItens,{cPedido,SC6->C6_ITEM})
					EndIf
					SC6->(DbSkip())
				End
			EndIf
		Else
			/*/ TRECHO INCLUIDO EM 28/06 GALLO
			PA2->(DbSetOrder(1))//PA2_FILIAL+PA2_CODPRO+PA2_FILRES
			PA2->(DbSeek(xFilial("PA2")+Padr(cProduto,15) + cFilDP ))
			While PA2->(!Eof() .and. PA2_FILIAL+PA2_CODPRO+PA2_FILRES == xFilial("PA2")+Padr(cProduto,15)+ cFilDP  )
				aadd(aItens,{SubStr(PA2->PA2_DOC,1,6),SubStr(PA2->PA2_DOC,7,5)})
				PA2->(DbSkip())
			End
			FIM DO TRECHO
			/*/

			PA1->(DbSetOrder(1))
			PA1->(DbSeek(xFilial('PA1')+cProduto))
			While PA1->(! Eof() .and. PA1_FILIAL+PA1_CODPRO == xFilial('PA1')+cProduto)
				If nVerSaldo > 0
					aadd(aItens,{SubStr(PA1->PA1_DOC,1,6),SubStr(PA1->PA1_DOC,7,2)})
					nVerSaldo -= PA1->PA1_QUANT
				Else
					Exit
				EndIf
				PA1->(DbSkip())
			EndDo
		Endif
	EndIf

	For nX:= 1 to Len(aItens)
		cDoc:= Alltrim(aItens[nx][1])+Alltrim(aItens[nx][2])
		nQtde := U_STGetRes(cDoc,cProduto,cFilDP)
		If nQtde > 0
			If nQtde < nSaldo
				U_STReserva(cDoc,cProduto,nQtde,"-",cFilDP)
				U_STReserva(cDoc,cProduto,nQtde,"+",cFilant)
				U_STGrvSt(cDoc)
				nSaldo -=nQtde
			Else
				U_STReserva(cDoc,cProduto,nSaldo,"-",cFilDP)
				U_STReserva(cDoc,cProduto,nSaldo,"+",cFilant)
				U_STGrvSt(cDoc)
				nSaldo := 0
			EndIf
		EndIf
		If nSaldo > 0
			nQtde := U_STGetFal(cDoc,cProduto)
			If nQtde > 0
				If nQtde < nSaldo
					U_STFalta(cDoc,cProduto,nQtde,"-")
					U_STReserva(cDoc,cProduto,nQtde,"+",cFilant)
					U_STGrvSt(cDoc)
					nSaldo -=nQtde
				Else
					U_STFalta(cDoc,cProduto,nSaldo,"-")
					U_STReserva(cDoc,cProduto,nSaldo,"+",cFilant)
					U_STGrvSt(cDoc)
					nSaldo := 0
				EndIf
			EndIf
		EndIf
		If Empty(nSaldo)
			Exit
		EndIf
	Next

	RestArea(aAreaSDA)
	RestArea(aAreaSD3)
	RestArea(aAreaSC2)
	RestArea(aAreaSC6)
	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณSTFSC10J  บAutor  ณMicrosiga           บ Data ณ  12/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para distribui็ใode saldo estqoue conforme prioridadeบฑฑ
ฑฑบ          ณutilizando no PE  MA260D3  MA261D3 (Transferencia)          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFSC10J()
	Local cProduto := SD3->D3_COD
	//LocaL nSaldo 	:= SD3->D3_QUANT
	Local cLocPad	:= Posicione("SB1",1,xFilial('SB1')+SDB->DB_PRODUTO,"B1_LOCPAD")

	If ! U_STProducao()
		Return
	EndIf

	If SD3->D3_LOCAL <> cLocPad
		Return
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณSTFSC10K  บAutor  ณMicrosiga           บ Data ณ  12/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para validar o estorno no endere็amento              บฑฑ
ฑฑบ          ณMATA265 PE M265VEST                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFSC10K()
	Local nX			:=0
	Local nQtde 	:=0
	Local cProduto	:=""
	Local cArm		:=""
	Local aSaldo	:={}
	Local nOpca		:= PARAMIXB[1]

	If ! U_STProducao() .OR. SDA->DA_LOCAL == '98'  // OR - INLCUIDO POR GALLO EM 13/05/13
		Return nOpca
	EndIf

	//Return nOpca

	For nX:=1 To Len(aCols)
		If ! GDFieldGet("DB_ESTORNO",nX) == "S"
			Loop
		EndIf
		If GDDeleted(nX)
			Loop
		EndIf
		cProduto 	:= SDA->DA_PRODUTO
		nQtde 		:= GDFieldGet("DB_QUANT",nX)
		cArm 		:= SDA->DA_LOCAL
		aSaldo		:={}
		U_STFSVE50(cProduto,cFilAnt,cArm,aSaldo)
		If Len(aSaldo) == 0
			MsgAlert("1.Nใo hแ saldo disponivel para o estorno do produto, verifique a reserva(PA2) "+cProduto)
			Return 0
		EndIf
		nSldDisp := aSaldo[1,3]
		If nSldDisp < nQtde
			MsgAlert("1.Nใo hแ saldo disponivel para o estorno do produto, verifique a reserva(PA2) "+cProduto)
			Return 0
		EndIf
	Next
Return nOpca

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณSTFSC10L  บAutor  ณMicrosiga           บ Data ณ  12/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para valida็ใo na transferencia a respeito da reservaบฑฑ
ฑฑบ          ณutilizando no PE  MT260TOK E MA260EST MATA260			        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFSC10L(lEstorno)
	Local cLocPad	:= Posicione("SB1",1,xFilial('SB1')+cCodOrig,"B1_LOCPAD")
	Local aSaldo	:= {}
	Local nSldDisp	:= 0
	Local cMsg		:= ''
	DEFAULT lEstorno := .F.

	If ! U_STProducao()
		Return .T.
	EndIf

	aSaldo	:={}
	If lEstorno
		If cLocDest <> cLocPad  .or. ( cLocOrig == cLocDest .and. cCodOrig == cCodDest)
			Return .t.
		EndIf
		U_STFSVE50(cCodDest,cFilAnt,cLocDest,aSaldo)
		cMsg := "Nใo hแ saldo disponivel para a estorno da transferencia. Produto: "+cCodDest
	Else
		If cLocOrig <> cLocPad  .or. ( cLocOrig == cLocDest .and. cCodOrig == cCodDest)
			Return .t.
		EndIf
		U_STFSVE50(cCodOrig,cFilAnt,cLocOrig,aSaldo)
		cMsg := "Nใo hแ saldo disponivel para a transferencia do produto " +cCodOrig
	EndIf

	If Len(aSaldo) == 0
		Return .f.
	EndIf
	nSldDisp := aSaldo[1,3]
	If nSldDisp < nQuant260
		cMsg+=" Disponivel: " + transform(nSldDisp,'@E 999,999.99')
		ApMsgAlert(cMsg)
		Return .f.
	EndIf

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณSTFSC10M  บAutor  ณMicrosiga           บ Data ณ  12/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para validar tudo ok transferencia mod 2             บฑฑ
ฑฑบ          ณA261TOK MATA261                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFSC10M()
	Local nX		  		:= 0
	Local nPosCODOri	:= 1 			//Codigo do Produto Origem
	Local nPosLOCOri	:= 4			//Armazem Origem
	Local nPosCODDes	:= 6 			//Codigo do Produto Destino
	Local nPosLOCDes	:= 9 			//Armazem Destino
	Local nPosQUANT	:= 16			//Quantidade
	Local cLocPad		:= ""
	Local aSaldo		:= {}
	Local nSldDisp		:= 0
	Local	cCodOrig 	:= ''
	Local	cLocOrig		:= ''
	Local	nQtde 		:= 0
	Local	cCodDest		:= ''
	Local	cLocDest		:= ''

	If ! U_STProducao()
		Return .T.
	EndIf

	For nX := 1 To Len(aCols)
		If aCols[nx,Len(aCols[nx])]
			Loop
		EndIf
		cCodOrig := aCols[nX,nPosCODOri	]
		cLocOrig	:= aCols[nX,nPosLOCOri	]
		nQtde 	:= aCols[nX,nPosQUANT	]
		cCodDest	:= aCols[nX,nPosCODDes	]
		cLocDest	:= aCols[nX,nPosLOCDes	]
		cLocPad	:= Posicione("SB1",1,xFilial('SB1')+cCodOrig,"B1_LOCPAD")
		If cLocOrig <> cLocPad  .or. ( cLocOrig == cLocDest .and. cCodOrig == cCodDest)
			Loop
		EndIf

		nSldDisp	:= 0
		aSaldo	:={}
		If IsTelNet()
			nSldDisp := STFSCESDC(cCodOrig,cLocOrig,aCols[nX,5],CB7->CB7_PEDIDO,CB7->CB7_OP)
		Else
			U_STFSVE50(cCodOrig,cFilAnt,cLocOrig,aSaldo)
		EndIf
		If nSldDisp == 0
			If Len(aSaldo) == 0
				return .f.
			endif
			nSldDisp := aSaldo[1,3]
		EndIf
		if nSldDisp < nQtde .and. isincallstack("U_JOBTRFCB7") .and. alltrim(funname()) == "RPC"
			nSldDisp := STFSCESDC(cCodOrig,cLocOrig,aCols[nX,5],CB7->CB7_PEDIDO,CB7->CB7_OP)
			// Acrescentado uma condi็ใo para considerar o processamento via job da melhoria plano manaus
		endif
		If nSldDisp < nQtde
			ApMsgAlert("Nใo hแ saldo disponivel para a transferencia do produto "+cCodOrig+" Disponivel: " + transform(nSldDisp,'@E 999,999.99') )
			conout("Nใo hแ saldo disponivel para a transferencia do produto "+cCodOrig+" Disponivel: " + transform(nSldDisp,'@E 999,999.99') )
			Return .f.
		EndIf

		// Chamado 005540 e 007074 - Robson Mazzarotto

		if cEmpAnt = "03"
			if SUBSTR(SB1->B1_COD,1,1) = "E" .and. SB1->B1_TIPO = "MC" .AND. cLocOrig <> cLocDest
				MSGAlert("Este produto ้ de consumo e nใo pode ser transferido!!!")
				Return .F.
			endif
		endif

	Next

Return .t.

Static Function STFSCESDC(cProduto,cArmz,cLocaliz,cPedido,cOP)

	Local nRet		:= 0
	Local cQuery	:= ""

	cQuery := " SELECT SUM(DC_QUANT) AS QUANT"
	cQuery += " FROM " + RetSqlName("SDC") +" SDC"
	cQuery += " WHERE DC_FILIAL = '" + xFilial("SDC") +"'"
	cQuery += "   AND DC_PRODUTO = '" + cProduto +"'"
	cQuery += "   AND DC_LOCAL = '" + cArmz +"'"
	cQuery += "   AND DC_LOCALIZ = '" + cLocaliz +"'"
	If !Empty(cPedido)
		cQuery += "   AND DC_PEDIDO = '" + cPedido +"'"
	Else
		cQuery += "   AND DC_OP = '" + cOP +"'"
	EndIf

	TCQUERY cQuery New Alias "TEMP"

	nRet := TEMP->QUANT

	TEMP->(dbCloseArea())

Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSC10N  บAutor  ณMicrosiga           บ Data ณ  01/14/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para validar o estorno da transferencia mod 2        บฑฑ
ฑฑบ          ณMA261EST MATA261                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFSC10N()
	Local nX		  		:= PARAMIXB[1]

	Local nPosCODOri	:= 2 			//Codigo do Produto Origem
	Local nPosLOCOri	:= 5			//Armazem Origem
	Local nPosCODDes	:= 7 			//Codigo do Produto Destino
	Local nPosLOCDes	:= 10 			//Armazem Destino
	Local nPosQUANT	:= 17			//Quantidade

	Local cLocPad		:= ""
	Local aSaldo		:= {}
	Local nSldDisp		:= 0
	Local	cCodOrig 	:= ''
	Local	cLocOrig		:= ''
	Local	nQtde 		:= 0
	Local	cCodDest		:= ''
	Local	cLocDest		:= ''

	If ! U_STProducao() .OR. cLocOrig == '98'
		Return .T.
	EndIf

	cCodOrig := aCols[nX,nPosCODOri	]
	cLocOrig	:= aCols[nX,nPosLOCOri	]
	nQtde 	:= aCols[nX,nPosQUANT	]
	cCodDest	:= aCols[nX,nPosCODDes	]
	cLocDest	:= aCols[nX,nPosLOCDes	]
	cLocPad	:= Posicione("SB1",1,xFilial('SB1')+cCodOrig,"B1_LOCPAD")
	If cLocDest <> cLocPad  .or. ( cLocOrig == cLocDest .and. cCodOrig == cCodDest)
		Return .T.
	EndIf

	nSldDisp	:= 0
	aSaldo	:={}
	U_STFSVE50(cCodDest,cFilAnt,cLocDest,aSaldo)
	If Len(aSaldo) == 0
		Return .F.
	EndIf
	nSldDisp := aSaldo[1,3]
	If nSldDisp < nQtde
		ApMsgAlert("2.Nใo hแ saldo disponivel para o estorno do produto "+cCodDest)
		Return .F.
	EndIf

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSC10O  บAutor  ณMicrosiga           บ Data ณ  01/14/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณfuncao para gravar a reserva ou falta         				  บฑฑ
ฑฑบ          ณPE TMKVFIM TMKA273D                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSC10O(cNumPed)
	Local aArea := GetArea()
	Local aSC5Area	:= SC5->(GetArea())
	Local aSC6Area	:= SC6->(GetArea())
	Local lExcluir := .F. //!INCLUI .and. ! ALTERA
	Local aItensPV	:= {}
	Local cItemPed	:= ""
	Local cProduto	:= ""
	Local nX

	If ! U_STProducao()
		Return
	EndIf

	If Empty(cNumPed)
		Return
	Endif

	If IsInCallSteck("TMKA380")
		INCLUI := .F.
		ALTERA := .T.
	Endif
	lExcluir := !INCLUI .and. ! ALTERA

	If lExcluir
		For nX:= 1 to len(aCols)
			If IsInCallSteck("TMKA271")
				cItemPed := GDFieldGet("UB_ITEM",nX)
				cProduto := GDFieldGet("UB_PRODUTO",nX)
			Else
				cItemPed := GDFieldGet("C6_ITEM",nX)
				cProduto := GDFieldGet("C6_PRODUTO",nX)
			Endif
			U_STDelFR(cNumPed+cItemPed,cProduto)
		Next
	Else
		SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
		If !SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
			RestArea(aSC6Area)
			Return
		Endif

		While SC6->(!Eof() .and. SC6->(C6_FILIAL+C6_NUM) == xFilial("SC6")+SC5->C5_NUM)
			If AvalTes(SC6->C6_TES,'S') //.and. !U_STIsIndireto(SC6->C6_PRODUTO) //Leonardo Flex -> Comentado para nao verificar se e' indireto quando vem de pedidod e venda
				SC6->(aadd(aItensPV,{SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_QTDVEN,0,SC6->C6_FILIAL}))
			EndIf
			SC6->(DbSkip())
		End

		PA2->(DbSetOrder(3)) //PA2_FILIAL+PA2_DOC+PA2_CODPRO+PA2_FILRES
		PA2->(DbSeek(xFilial("PA2")+SC5->C5_NUM))
		While PA2->(!Eof() .and. PA2_FILIAL+Left(PA2_DOC,6) == xFilial("PA2")+SC5->C5_NUM)
			If (nPos := aScan(aItensPV,{|x| x[2]+x[5] == PA2->(PA2_CODPRO+PA2_FILRES)})) > 0
				aItensPV[nPos,4] := PA2->PA2_QUANT
			Else
				PA2->(Aadd(aItensPV,{Substr(PA2_DOC,7,2),PA2_CODPRO,0,PA2_QUANT,PA2_FILRES}))
			Endif

			PA2->(DbSkip())
		End

		//Elimina todas as faltas do produto
		For nx:= 1 to len(aItensPV)
			U_STFalta(cNumPed+aItensPV[nX,1],aItensPV[nX,2],99999999,"-")
		Next
		For nx:= 1 to len(aItensPV)
			If aItensPV[nX,3]==aItensPV[nX,4]
				Loop
			EndIf
			cItemPed := aItensPV[nX,1]
			cProduto := aItensPV[nX,2]
			nQtde		:= aItensPV[nX,3]-aItensPV[nX,4]
		Next

		SC5->(U_STGrvSt(C5_NUM,C5_XTIPF=="2"))
		U_STPriSC5()
	Endif

	RestArea(aSC6Area)
	RestArea(aSC5Area)
	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSCE10  บAutor  ณMicrosiga           บ Data ณ  02/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para reajustar a reserva/falta na exclusao do pedido บฑฑ
ฑฑบ          ณdo televendas                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSC10P(nOpca,cOrca)
	Local aArea	:= GetArea()
	Local cNumPed	:= SUA->UA_NUMSC5
	Local nX

	If ! U_STProducao()
		Return
	EndIf

	For nX:= 1 to len(aCols)
		cItemPed := GDFieldGet("UB_ITEM",nX)
		cProduto := GDFieldGet("UB_PRODUTO",nX)
		U_STDelFR(cNumPed+cItemPed,cProduto)
	Next

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSCE10  บAutor  ณMicrosiga           บ Data ณ  04/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณElimina as reservas de pedidos nao liberados a mais de      บฑฑ
ฑฑบ          ณ xx dias                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSC10Q()
	Local nQtdDias		:= GetMv("FS_DIASELI",.F.,5)
	Local dDtUlProc	:= StoD(GetMv("FS_DTULELI",.F.,"20010101"))
	Local cDataLim		:= DtoS(dDatabase - nQtdDias)
	If dDtUlProc < dDatabase
		PutMv("FS_DTULELI",DtoS(dDatabase))
		Processa({|| fDelRes(cDataLim),"Eliminando reservas..." })
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFSCE10  บAutor  ณMicrosiga           บ Data ณ  04/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณElimina as reservas                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fDelRes(cDataLim)
	Local cQuery

	cQuery := " SELECT C9_PEDIDO, C9_ITEM, C9_PRODUTO, C9_QTDLIB"
	cQuery += " FROM " + RetSqlName("SC9") + " WHERE C9_FILIAL = '"+xFilial("SC9")+"'"
	cQuery += " AND C9_DATALIB <= '"+cDataLim+"' AND C9_NFISCAL = ''"
	cQuery += " AND C9_BLCRED NOT IN ('10','  ') AND D_E_L_E_T_ = ''"

	IncProc("Recuperando registros...")
	TCQUERY cQuery NEW ALIAS "QSC9"
	IncProc("Eliminando registros...")

	While QSC9->(!Eof())
		QSC9->(U_STFalta(C9_PEDIDO+C9_ITEM,C9_PRODUTO,C9_QTDLIB,"-"))
		QSC9->(DbSkip())
	End
	QSC9->(DbCloseArea())
	IncProc("Finalizando opera็ใo...")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณSTFSC10R  บAutor  ณMicrosiga           บ Data ณ  12/18/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para distribui็ใode saldo estqoue conforme prioridadeบฑฑ
ฑฑบ          ณjob											                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSC10R(cEmpProd , cFilProd , cProduto)
	RpcSetType(3)
	RpcSetEnv(cEmpProd,cFilProd, , ,'EST',,{"XX4"})
	
	RpcClearEnv()
Return

