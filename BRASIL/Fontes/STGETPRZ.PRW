#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STGETPRZ	ºAutor  ³Renato Nogueira     º Data ³  14/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado devolver dias de prazo para um produto      º±±
±±º          ³										    				        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Filial,produto,quantidade                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STGETPRZ(_cProduto,_nQuant,_cTipo)

	Local _aArea		:= GetArea()
	Local _aSaldo 	:= {}
	Local _nPrazo		:= 0
	Local _nSaldoDisp	:= 0
	
	Do case
	Case _cTipo=="1" //Orçamento
		_nPrazo	:= DateDiffDay(DATE(),SUB->UB_DTENTRE)
	Case _cTipo=="2" //Pedido
		_nPrazo	:= DateDiffDay(SC5->C5_EMISSAO,Iif( Empty(SC6->C6_ZENTRE2) ,SC6->C6_ENTRE1,SC6->C6_ZENTRE2)) 
	EndCase
	
	//_nPrazo	:= _nPrazo+1  //FR - 11/05/2022 - Conforme validação de Kleber, não precisa "chumbar" 1 dia aqui, trazer apenas o prazo entrega do produto
		
	If _nPrazo<0
		_nPrazo	:= 0
	EndIf
	
	/*
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	SB1->(DbSeek(xFilial("SB1")+_cProduto))
	
	DbSelectArea("SBM")
	SBM->(DbSetOrder(1))
	SBM->(DbGoTop())
	SBM->(DbSeek(xFilial("SBM")+SB1->B1_GRUPO))
	
	If SB1->(!Eof())
	
		Do case
		
		Case _cTipo=="1" //Orçamento
		
			U_STFSVE50(SB1->B1_COD,cFilAnt,,_aSaldo )
		
			For _nX:=1 To Len(_aSaldo)
				If AllTrim(_aSaldo[_nX][1])==AllTrim(cFilAnt) .And. AllTrim(_aSaldo[_nX][2])==AllTrim(SB1->B1_LOCPAD)
					_nSaldoDisp	:= _aSaldo[_nX][3]
				EndIf
			Next
	
			If _nSaldoDisp>=_nQuant //caso tenha o produto disponível em estoque
				_nPrazo	:= 3
			Else
				_nPrazo	:= IIf(SB1->B1_PE>0,SB1->B1_PE,SBM->BM_ZDIASLD)
			EndIf
	
		Case _cTipo=="2" //Pedido
			
			If _nQuant>0
				
				DbSelectArea("PA2")
				PA2->(DbSetOrder(2))
				PA2->(DbGoTop())
				If PA2->(DbSeek(xFilial("PA2")+"1"+PADR(SC6->(C6_NUM+C6_ITEM),11)+SC6->C6_PRODUTO+cFilAnt))
	
					If AllTrim(SC5->C5_XTIPF)=="1" .And. _nQuant<=PA2->PA2_QUANT //Total
						_nPrazo	:= 3
					EndIf
	
					If AllTrim(SC5->C5_XTIPF)=="2" .And. PA2->PA2_QUANT>0 //Total
						_nPrazo	:= 3
					EndIf
	
				Else
					_nPrazo	:= IIf(SB1->B1_PE>0,SB1->B1_PE,SBM->BM_ZDIASLD)
				EndIf
			
			Else
			
				_nPrazo	:= 0
			
			EndIf
	
		EndCase
		
	EndIf
	*/

	RestArea(_aArea)

Return(_nPrazo)
