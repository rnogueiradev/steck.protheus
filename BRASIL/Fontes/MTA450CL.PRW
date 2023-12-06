#INCLUDE "RWMAKE.CH"
#Include "Colors.ch"
#include 'Protheus.ch'

#Define CR chr(13)+chr(10)



/*====================================================================================\
|Programa  | MTA450I          | Autor | GIOVANI.ZAGO             | Data | 26/03/2013  |
|=====================================================================================|
|Descrição | MTA450CL                                                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MTA450CL                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function MTA450CL()
*-----------------------------*
	Local cPedido     := SC9->C9_PEDIDO
	Local cItem       := SC9->C9_ITEM
	Local cFilSC9     := xFilial("SC9")
	Local cInd        := "1"
	Local cGetMotivo  := Space(80)
	Local nOpcao      := 0
	Local lRetorno    := .T.
	Local lBrowser    := .F.
	Local lSaida      := .f.
	Local _aMotRej    := {}
	Local i
	Local _cItem      := ''
	Local _nOpcx      := PARAMIXB[1]
	Local _aRegSc6    := {}
	_aRegSc6          := PARAMIXB[2]


	For i:=1 To Len(_aRegSc6)
	
		DbSelectArea("SC6")
		SC6->(DbGoTop())
		SC6->(DbGoTo(_aRegSc6[i]))
		If 		SC6->(recno()) = _aRegSc6[i]
		
			cPedido:= SC6->C6_NUM
			DbSelectArea("SC5")
			SC5->(DbSetOrder(1))
			If 	SC5->(DbSeek(xFilial("SC5")+cPedido))
			
				Reclock("SC5",.F.)
				SC5->C5_ZMOTREJ  := ''
				SC5->C5_ZDTREJE  := CTOD('  /  /    ')
				SC5->(MsUnLock())
				SC5->( DbCommit() )
			EndIf
		
		
			If	SC5->C5_ZDTJOB <> CTOD('  /  /    ')
				StItens()
				Reclock("SC5",.F.)
				SC5->C5_ZDTJOB  := CTOD('  /  /    ')
				SC5->(MsUnLock())
				SC5->( DbCommit() )
			EndIf
		
//Gravar hora da liberação de crédito
			SC5->(Reclock("SC5",.F.))
			SC5->C5_XHRLIB	:= DTOC(DATE())+" "+TIME()
			SC5->C5_XUSRFIN	:= Alltrim(UsrRetName(__CUSERID))
			SC5->(Msunlock())

		EndIF
	
	Next i

	U_STOFERLG(SC5->C5_FILIAL,SC5->C5_NUM,.T.) //Carregar informações da oferta logística - Renato Nogueira - 28/05/2014  
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	
	IF SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM ))
		
		While SC6->(!Eof()) .and. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM = SC5->C5_NUM
			u_LOGJORPED("SC9","3",SC6->C6_PRODUTO,SC6->C6_ITEM,SC6->C6_NUM,"","Liberacao financeira")
			SC6->(DbSkip())
		End
		
	EndIf

Return()

Static Function StItens()

	Local cNumPed 	:= SC5->C5_NUM
	Local aArea 	:= GetArea()
	Local aSC6Area	:= SC6->(GetArea())
	Local cItemPed  := ''
	Local cProduto  := ''
	Local nQtde	    := 0

	If ! U_STProducao()
		Return .t.
	EndIf

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	If SC6->(DbSeek(xFilial('SC6')+cNumPed))
		While SC6->(! Eof() .and. C6_FILIAL+C6_NUM == xFilial('SC6')+cNumPed)
			If AvalTes(SC6->C6_TES,'S')
				cItemPed := SC6->C6_ITEM
				cProduto := SC6->C6_PRODUTO
				nQtde	 := SC6->C6_QTDVEN-SC6->C6_QTDENT
			EndIf
			SC6->(DbSkip())
		End
		U_STGrvSt(cNumPed,SC5->C5_XTIPF=="2")  // analisa e grava o status
		U_STPriSC5()  // grava prioridade
	EndIf
	RestArea(aSC6Area)
	RestArea(aArea)
Return()
