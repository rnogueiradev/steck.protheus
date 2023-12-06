#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  STCB8CORTE   ºAutor  ³Giovani Zago    º Data ³  02/12/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Corte de Os								                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STCB8CORTE()
	
	Local   oReport
	Private cPerg 			:= "CB8COR"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cOS 			:=  Space(6)
	Private cItem     		:=  Space(3)
	Private cProd     		:=  Space(15)
	Private nQtd	    	:=  0
	Private nxQtd	    	:=  0
	Private nEnd     		:=  Space(15)
	Private _lC9			:= .t.
	Private aSaldos 		:= {}
	Private nC9Qtd	    	:=  0
	
	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Ajuste de Os") From 1,0 To 30,45 OF oMainWnd

	MsgAlert("Rotina em revisão")
	return
	
	@ 05,04 SAY "Os:" PIXEL OF oDlgEmail
	@ 15,04 MSGet cOS 	F3 'CB8COR'	  Size 35,012  PIXEL OF oDlgEmail Valid( existcpo("CB7",cOS)  .And. Posicione("CB7",1,xFilial("CB7")+cOS,"CB7_STATUS") $ "012" )
	
	
	@ 45,04 SAY "Item:" PIXEL OF oDlgEmail
	@ 55,04 MSGet cItem  when .F.	  Size 35,012  PIXEL OF oDlgEmail
	
	@  85,04 SAY "Produto:" PIXEL OF oDlgEmail
	@ 100,04 MSGet cProd 	when .F.	  Size 35,012  PIXEL OF oDlgEmail
	
	@ 125,04 SAY "Endereço:" PIXEL OF oDlgEmail
	@ 140,04 MSGet nEnd  when .F.	  Size 35,012  PIXEL OF oDlgEmail
	
	@ 165,04 SAY "Qtd:" PIXEL OF oDlgEmail
	@ 180,04 MSGet nQtd  when .F.	 Picture '@e 999,999' Size 35,012  PIXEL OF oDlgEmail
	
	@ 165,67 SAY "Qtd Real:" PIXEL OF oDlgEmail
	@ 180,67 MSGet nxQtd  	 Picture '@e 999,999' Size 35,012 Valid ( nxQtd >= 0 .And. nQtd > nxQtd ) PIXEL OF oDlgEmail
	
	
	@ 200, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	@ 200, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel
	
	
	nOpca:=0
	
	ACTIVATE MSDIALOG oDlgEmail CENTERED
	
	If nOpca == 1
		Begin Transaction
			DbSelectArea("CB8")
			CB8->(DbGoTop())
			CB8->(DbSetOrder(1)) //CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_SEQUEN+CB8_PROD
			If CB8->(DbSeek(xFilial("CB8")+cOS+alltrim(cItem)))
				
				
				DbSelectArea("SC9")
				SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
				If	SC9->(DbSeek(CB8->(CB8_FILIAL+CB8_PEDIDO+CB8_ITEM+CB8_SEQUEN+CB8_PROD)))
					SC9->(RecLock("SC9",.F.))
					If nxQtd = 0
						SC9->C9_BLEST  := '02'
						SC9->C9_ORDSEP := ''
						SC9->(MsUnlock())
						SC9->(DbCommit())
						
						DbSelectArea("SC9")
						SC9->(DbGoTop())
						SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
						If	SC9->(DbSeek(CB8->(CB8_FILIAL+CB8_PEDIDO+CB8_ITEM)))
							DbSelectArea("SC6")
							SC6->(DbSetOrder(1))
							If SC6->(DbSeek(xFilial("SC6")+CB8->(CB8_PEDIDO+CB8_ITEM)))
								
								
								While SC9->(! Eof()) .and. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM)  == CB8->(CB8_FILIAL+CB8_PEDIDO+CB8_ITEM)
									If Empty(SC9->C9_ORDSEP)
										_lC9:=.f.
										nC9Qtd:= (nC9Qtd+SC9->C9_QTDLIB)
										SC9->(RecLock("SC9",.F.))
										SC9->(DbDelete())
										SC9->(MsUnlock())
										SC9->(DbCommit())
										
									Endif
									SC9->(DbSkip())
								End
								
								//cria a sc9
								nRecno:= SC6->(RecNo())
								MaLibDoFat(SC6->(RecNo()),(nC9Qtd),.T.,.T.,.T.,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
								MaLiberOk({SC6->C6_NUM},.F.)
								MsUnLockall()
								SC6->(DbGoto(nRecno))
								SC9->(RecLock("SC9",.F.))
								SC9->C9_BLEST  := '02'
								SC9->C9_BLCRED := ''
								SC9->(MsUnlock())
								SC9->(DbCommit())
								
							EndIf
						EndIf
						
					Else
						SC9->C9_QTDLIB := nxQtd
						SC9->(MsUnlock())
						SC9->(DbCommit())
						
						DbSelectArea("SC9")
						SC9->(DbGoTop())
						SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
						If	SC9->(DbSeek(CB8->(CB8_FILIAL+CB8_PEDIDO+CB8_ITEM)))
							DbSelectArea("SC6")
							SC6->(DbSetOrder(1))
							If SC6->(DbSeek(xFilial("SC6")+CB8->(CB8_PEDIDO+CB8_ITEM)))
								
								
								While SC9->(! Eof()) .and. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM)  == CB8->(CB8_FILIAL+CB8_PEDIDO+CB8_ITEM)
									If Empty(SC9->C9_ORDSEP)
										_lC9:=.f.
										SC9->(RecLock("SC9",.F.))
										SC9->C9_QTDLIB := SC9->C9_QTDLIB+(nQtd-nxQtd)
										SC9->C9_BLEST  := '02'
										SC9->(MsUnlock())
										SC9->(DbCommit())
										Exit
									Endif
									SC9->(DbSkip())
								End
								If 	_lC9
									//cria a sc9
									nRecno:= SC6->(RecNo())
									MaLibDoFat(SC6->(RecNo()),(nQtd-nxQtd),.T.,.T.,.T.,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
									MaLiberOk({SC6->C6_NUM},.F.)
									MsUnLockall()
									SC6->(DbGoto(nRecno))
									SC9->(RecLock("SC9",.F.))
									SC9->C9_BLEST  := '02'
									SC9->C9_BLCRED := ''
									SC9->(MsUnlock())
									SC9->(DbCommit())
									
								EndIf
							EndIf
						EndIf
					EndIf
					DbSelectArea("SDC")
					SDC->(DbSetOrder(1))
					If SDC->(DbSeek(xFilial("SDC")+CB8->CB8_PROD+CB8->CB8_LOCAL+'SC6'+CB8->CB8_PEDIDO+CB8->CB8_ITEM))
						Do While SDC->(!Eof()) .And. SDC->(DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM) = (CB8->CB8_FILIAL+CB8->CB8_PROD+CB8->CB8_LOCAL+'SC6'+CB8->CB8_PEDIDO+CB8->CB8_ITEM)
							If SDC->DC_LOCALIZ =  CB8->CB8_LCALIZ
								SDC->(RecLock("SDC",.F.))
								If nxQtd = 0
									SDC->(DbDelete())
								Else
									SDC->DC_QUANT :=  	(SDC->DC_QUANT-(nQtd - nxQtd))
								EndIf
								SDC->(MsUnlock())
								SDC->(DbCommit())
								
							EndIf
							SDC->(DbSkip())
						ENDDO
					EndIf
					
					
					DbSelectArea("SBF")
					SBF->(DbSetOrder(1))
					If SBF->(DbSeek(xFilial("SBF")+CB8->CB8_LOCAL+CB8->CB8_LCALIZ+CB8->CB8_PROD))
						SBF->(RecLock("SBF",.F.))
						
						SBF->BF_EMPENHO :=  (SBF->BF_EMPENHO-(nQtd-nxQtd))
						
						SBF->(MsUnlock())
						SBF->(DbCommit())
						
						
					EndIf
					
					DbSelectArea("PA2")
					PA2->(DbSetOrder(2))
					If PA2->(DbSeek(xFilial('PA2')+"1"+CB8->CB8_PEDIDO+CB8->CB8_ITEM))
						//	Do While PA2->(!Eof()) .And. PA2->PA2_DOC = CB8->CB8_PEDIDO+CB8->CB8_ITEM  .And. PA2->PA2_TIPO = '1'
						PA2->(RecLock("PA2",.F.))
						If nxQtd = 0
							PA2->PA2_OBS:= 'CORTE '+__cuserId+' - '+dTOc(date())  +' - '+TIME()
							PA2->(DbDelete())
						Else
							PA2->PA2_QUANT := (PA2->PA2_QUANT - (nQtd - nxQtd))
						EndIf
						PA2->(MsUnlock())
						PA2->(DbCommit())
						
						//	PA2->(DbSkip())
						//	ENDDO
					EndIf
					DbSelectArea("PA1")
					PA1->(DbSetOrder(2))
					If PA1->(DbSeek(xFilial('PA1')+"1"+CB8->CB8_PEDIDO+CB8->CB8_ITEM))
						PA1->(RecLock("PA1",.F.))
						
						PA1->PA1_OBS	:= 'CORTE '+__cuserId+' - '+dTOc(date())  +' - '+TIME()
						PA1->PA1_QUANT  := (PA1->PA1_QUANT + (nQtd - nxQtd))
						
						PA1->(MsUnlock())
						PA1->(DbCommit())
					Else
						PA1->(RecLock("PA1",.T.))
						PA1->PA1_FILIAL  := xFilial('PA1')
						PA1->PA1_CODPRO  := CB8->CB8_PROD
						PA1->PA1_DOC  := CB8->CB8_PEDIDO+CB8->CB8_ITEM
						PA1->PA1_TIPO  := '1'
						PA1->PA1_OBS	:= 'CORTE '+__cuserId+' - '+dTOc(date())  +' - '+TIME()
						PA1->PA1_QUANT  :=   (nQtd - nxQtd)
						
						PA1->(MsUnlock())
						PA1->(DbCommit())
						
					EndIf
					
					If nxQtd = 0 //Chamado 002094
						DbSelectArea("CB9")
						CB9->(DbSetOrder(6)) //CB9_FILIAL+CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTECT+CB9_NUMLOT+CB9_NUMSER+CB9_LOTSUG+CB9_SLOTSU+CB9_SUBVOL+CB9_CODETI
						CB9->(DbGoTop())
						If CB9->(DbSeek(xFilial("CB9")+CB8->(CB8_ORDSEP+CB8_ITEM)))
							CB9->(RecLock("CB9",.F.))
							CB9->(DbDelete())
							CB9->(MsUnlock())
							CB9->(DbCommit())
						EndIf
					EndIf
					
					CB8->(RecLock("CB8",.F.))
					If nxQtd = 0
						CB8->(DbDelete())
					Else
						CB8->CB8_QTDORI := (CB8->CB8_QTDORI -(nQtd-nxQtd))
						CB8->CB8_SALDOS := (CB8->CB8_SALDOS -(nQtd-nxQtd))
						CB8->CB8_SALDOE := (CB8->CB8_SALDOE -(nQtd-nxQtd))
					EndIf
					CB8->(MsUnlock())
					CB8->(DbCommit())
					
				EndIf
			Endif
		End Transaction
		
		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+CB8->CB8_PEDIDO))
			SC5->(U_STGrvSt(C5_NUM,C5_XTIPF=="2"))  // analisa e grava o status
			U_STPriSC5()  // grava prioridade
		EndIf
		msginfo('Ajuste Realizado !!!!!!!!')
	Endif
	
Return

