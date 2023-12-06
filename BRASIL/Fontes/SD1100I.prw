#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SD1100I	ºAutor  ³Renato Nogueira     º Data ³  07/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado baixar o saldo dos pedidos de compra após	  º±±
±±º          ³a entrada da nota					    				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ 		                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SD1100I()

	Local _aArea 		:= GetArea()
	Local _aAreaSD1		:= SD1->(GetArea())
	Local _aAreaSF1		:= SF1->(GetArea())
	Local _aAreaSC7		:= SC7->(GetArea())
	Local _cQuery 		:= ""
	Local _cAlias 		:= "QRYTEMP"
	Local _nQtdSub		:= 0
	Local _nQtdSaldoD1	:= 0
	Local _lContinua	:= .T.
	Local _lValida		:= .T.

	If AllTrim(SD1->D1_CF) $ GetMv("ST_CFOPTST")
		_lValida	:= .F.
	EndIf

	/*Inibido por Emerson Holanda 04/09/23 - A Baixa do saldo sera efetuada pelas rotina padrões.
	If AllTrim(CA100FOR)=="005866" .And. AllTrim(CTIPO)=="N" .And. cEmpAnt == "01" .And. _lValida //Notas vindas da Steck Manaus
	
		_cQuery	:= " SELECT C7_FILIAL, C7_NUM, C7_ITEM, C7_PRODUTO, C7_QUANT, C7_QUJE, C7_QUANT-C7_QUJE AS SALDO, C7.R_E_C_N_O_ REGISTRO "
		_cQuery	+= " FROM "+RetSqlName("SC7")+" C7 "
		_cQuery	+= " WHERE C7.D_E_L_E_T_=' ' AND C7_QUANT-C7_QUJE>0 AND C7_FORNECE='"+SF1->F1_FORNECE+"' "
		_cQuery	+= " AND C7_LOJA='"+SF1->F1_LOJA+"' AND C7_PRODUTO='"+SD1->D1_COD+"' AND C7_FILIAL='"+SD1->D1_FILIAL+"' AND C7_RESIDUO=' ' "
		_cQuery	+= " ORDER BY C7_EMISSAO, C7_NUM "
	
		If !Empty(Select(_cAlias))
			DbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		Endif
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)
	
		dbSelectArea(_cAlias)
		(_cAlias)->(dbGoTop())
	
		While (_cAlias)->(!Eof()) .And. _lContinua
		
		
		//Begin Transaction
		//End Transaction
		
		
			DbSelectArea("SC7")
			SC7->(DbGoTop())
			SC7->(DbGoTo((_cAlias)->REGISTRO))
		
			If SC7->(!Eof())
			
				DO CASE
				
				CASE SD1->D1_QUANT <= (_cAlias)->SALDO .And. _nQtdSaldoD1==0
					
					_nQtdSub		:= SD1->D1_QUANT
					
					SC7->(RecLock("SC7",.F.))
					SC7->C7_QUJE	:= SC7->C7_QUJE+SD1->D1_QUANT
					SC7->(MsUnLock())
					
					DbSelectArea("ZZS")
					ZZS->(DbSetOrder(1)) //ZZS_FILIAL+ZZS_NF+ZZS_SERIE+ZZS_FORNEC+ZZS_LOJA+ZZS_PEDCOM+ZZS_ITEMPC+ZZS_ITEMNF
					ZZS->(DbGoTop())
					If !ZZS->(DbSeek(SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)+SC7->(C7_NUM+C7_ITEM)+SD1->D1_ITEM))
						
						ZZS->(RecLock("ZZS",.T.))
						ZZS->ZZS_FILIAL	:=	SD1->D1_FILIAL
						ZZS->ZZS_NF		:=	SD1->D1_DOC
						ZZS->ZZS_SERIE	:=	SD1->D1_SERIE
						ZZS->ZZS_FORNEC	:=	SD1->D1_FORNECE
						ZZS->ZZS_LOJA	:=	SD1->D1_LOJA
						ZZS->ZZS_PEDCOM	:=	SC7->C7_NUM
						ZZS->ZZS_ITEMPC	:=	SC7->C7_ITEM
						ZZS->ZZS_ITEMNF	:=	SD1->D1_ITEM
						ZZS->ZZS_QTDNF	:=	SD1->D1_QUANT
						ZZS->ZZS_QTDPC	:=	SC7->C7_QUANT
						ZZS->ZZS_QTDSUB	:=	_nQtdSub
						ZZS->(MsUnLock())
						
					EndIf
					
					_lContinua	:= .F.
					
				CASE SD1->D1_QUANT > (_cAlias)->SALDO .And. _nQtdSaldoD1==0
					
					_nQtdSaldoD1	:= SD1->D1_QUANT-(_cAlias)->SALDO
					
					SC7->(RecLock("SC7",.F.))
					SC7->C7_QUJE	:= SC7->C7_QUANT
					SC7->(MsUnLock())
					
					DbSelectArea("ZZS")
					ZZS->(DbSetOrder(1)) //ZZS_FILIAL+ZZS_NF+ZZS_SERIE+ZZS_FORNEC+ZZS_LOJA+ZZS_PEDCOM+ZZS_ITEMPC+ZZS_ITEMNF
					ZZS->(DbGoTop())
					If !ZZS->(DbSeek(SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)+SC7->(C7_NUM+C7_ITEM)+SD1->D1_ITEM))
						
						ZZS->(RecLock("ZZS",.T.))
						ZZS->ZZS_FILIAL	:=	SD1->D1_FILIAL
						ZZS->ZZS_NF		:=	SD1->D1_DOC
						ZZS->ZZS_SERIE	:=	SD1->D1_SERIE
						ZZS->ZZS_FORNEC	:=	SD1->D1_FORNECE
						ZZS->ZZS_LOJA	:=	SD1->D1_LOJA
						ZZS->ZZS_PEDCOM	:=	SC7->C7_NUM
						ZZS->ZZS_ITEMPC	:=	SC7->C7_ITEM
						ZZS->ZZS_ITEMNF	:=	SD1->D1_ITEM
						ZZS->ZZS_QTDNF	:=	SD1->D1_QUANT
						ZZS->ZZS_QTDPC	:=	SC7->C7_QUANT
						ZZS->ZZS_QTDSUB	:=	(_cAlias)->SALDO
						ZZS->(MsUnLock())
						
					EndIf
					
					_lContinua	:= .T.
					
				CASE _nQtdSaldoD1>0
					
					If _nQtdSaldoD1 <= (_cAlias)->SALDO
						
						SC7->(RecLock("SC7",.F.))
						SC7->C7_QUJE	:= SC7->C7_QUJE+_nQtdSaldoD1
						SC7->(MsUnLock())
						
						DbSelectArea("ZZS")
						ZZS->(DbSetOrder(1)) //ZZS_FILIAL+ZZS_NF+ZZS_SERIE+ZZS_FORNEC+ZZS_LOJA+ZZS_PEDCOM+ZZS_ITEMPC+ZZS_ITEMNF
						ZZS->(DbGoTop())
						If !ZZS->(DbSeek(SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)+SC7->(C7_NUM+C7_ITEM)+SD1->D1_ITEM))
							
							ZZS->(RecLock("ZZS",.T.))
							ZZS->ZZS_FILIAL	:=	SD1->D1_FILIAL
							ZZS->ZZS_NF		:=	SD1->D1_DOC
							ZZS->ZZS_SERIE	:=	SD1->D1_SERIE
							ZZS->ZZS_FORNEC	:=	SD1->D1_FORNECE
							ZZS->ZZS_LOJA	:=	SD1->D1_LOJA
							ZZS->ZZS_PEDCOM	:=	SC7->C7_NUM
							ZZS->ZZS_ITEMPC	:=	SC7->C7_ITEM
							ZZS->ZZS_ITEMNF	:=	SD1->D1_ITEM
							ZZS->ZZS_QTDNF	:=	SD1->D1_QUANT
							ZZS->ZZS_QTDPC	:=	SC7->C7_QUANT
							ZZS->ZZS_QTDSUB	:=	_nQtdSaldoD1
							ZZS->(MsUnLock())
							
							_nQtdSaldoD1	:= 0
							
						EndIf
						
						_lContinua	:= .F.
						
					ElseIf _nQtdSaldoD1 > (_cAlias)->SALDO
						
						DbSelectArea("ZZS")
						ZZS->(DbSetOrder(1)) //ZZS_FILIAL+ZZS_NF+ZZS_SERIE+ZZS_FORNEC+ZZS_LOJA+ZZS_PEDCOM+ZZS_ITEMPC+ZZS_ITEMNF
						ZZS->(DbGoTop())
						If !ZZS->(DbSeek(SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)+SC7->(C7_NUM+C7_ITEM)+SD1->D1_ITEM))
							
							ZZS->(RecLock("ZZS",.T.))
							ZZS->ZZS_FILIAL	:=	SD1->D1_FILIAL
							ZZS->ZZS_NF		:=	SD1->D1_DOC
							ZZS->ZZS_SERIE	:=	SD1->D1_SERIE
							ZZS->ZZS_FORNEC	:=	SD1->D1_FORNECE
							ZZS->ZZS_LOJA	:=	SD1->D1_LOJA
							ZZS->ZZS_PEDCOM	:=	SC7->C7_NUM
							ZZS->ZZS_ITEMPC	:=	SC7->C7_ITEM
							ZZS->ZZS_ITEMNF	:=	SD1->D1_ITEM
							ZZS->ZZS_QTDNF	:=	SD1->D1_QUANT
							ZZS->ZZS_QTDPC	:=	SC7->C7_QUANT
							ZZS->ZZS_QTDSUB	:=	SC7->C7_QUANT-SC7->C7_QUJE
							ZZS->(MsUnLock())
							
							SC7->(RecLock("SC7",.F.))
							SC7->C7_QUJE	:= SC7->C7_QUANT
							SC7->(MsUnLock())
							
							_nQtdSaldoD1	:= _nQtdSaldoD1-(_cAlias)->SALDO
							
						EndIf
						
						_lContinua	:= .T.
						
					EndIf
					
				ENDCASE
			
			EndIf
		
			(_cAlias)->(DbSkip())
		
		EndDo
	
	EndIf
	*/
	
	DbSelectArea("QEK")
	DbSetOrder(10) 
	DbGoTop()
	
	If DbSeek(xFilial("QEK")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_ITEM)
	
		If !Empty(SD1->D1_XFATEC)
		
			QEK->(RecLock('QEK',.F.))
			QEK->QEK_XFATEC := SD1->D1_XFATEC
			QEK->(MsUnLock())
		
		EndIf
	
	
	ENDIF
	
	
	RestArea(_aAreaSC7)
	RestArea(_aAreaSF1)
	RestArea(_aAreaSD1)
	RestArea(_aArea)

Return()
