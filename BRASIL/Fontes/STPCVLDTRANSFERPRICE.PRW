#INCLUDE "PROTHEUS.CH"
#DEFINE CR    chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STPCVLDTRANSFERPRICEºAutor³Joao Rinaldiº Data ³  01/10/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função chamada pelo ponto de entrada MT120OK para validar   º±±
±±º          ³se o preço de unitário do Pedido de Compra é o mesmo        º±±
±±º          ³informado na Tabela de Preço de Transferência no momento da º±±
±±º          ³geração do Pedido de Compra                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRotina    ³ MATA121.PRX                                                º±±
±±ºNome      ³ Pedido de Compra                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STPCVLDTRANSFERPRICE

	Local _aArea     := GetArea()
	Local _lRet      := .T.
	Local _nPosProd  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C7_PRODUTO"})
	Local _nPosPrec  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C7_PRECO"})
	Local _nI
	
	If !Acols[n][Len(aHeader)+1]
		If  Alltrim(CA120FORN) = '005764'
			For _nI := 1 to Len(aCols)
				DbSelectArea("DA1")
				DA1->(DbSetOrder(1))
				If DA1->(DbSeek(xFilial("DA1")+'T01'+aCols[_nI,_nPosProd]))
					IF DA1->DA1_PRCVEN <> aCols[_nI,_nPosPrec] .And. !(aCols[_nI][Len(aCols[_nI])])
						MsgInfo("Produto "+Alltrim(aCols[_nI,_nPosProd])+" com preço diferente do Cadastrado na Tabela de Preço de Transferência...!!!";
							+CR+CR+;
							"Preço do Pedido de Compra: "+CvaltoChar(aCols[_nI,_nPosPrec]);
							+CR+;
							"Preço da Tabela de Transferência: "+CvaltoChar(DA1->DA1_PRCVEN);
							+CR+CR+;
							"Favor manter o Preço da Tabela de Transferência...!!!")
						_lRet := .F.
						Exit
					Endif
				Else
					MsgInfo("Produto "+Alltrim(aCols[_nI,_nPosProd])+" não Cadastrado na Tabela de Preço de Transferência...!!!";
						+CR+CR+;
						"Solicite o Cadastro...!!!!")
					_lRet := .F.
					Exit
				EndIf
			Next _nI
		
		ElseIf  Alltrim(CA120FORN) = '005866'
			For _nI := 1 to Len(aCols)
				DbSelectArea("DA1")
				DA1->(DbSetOrder(1))
				If DA1->(DbSeek(xFilial("DA1")+'T02'+aCols[_nI,_nPosProd]))
					IF DA1->DA1_PRCVEN <> aCols[_nI,_nPosPrec] .And. !(aCols[_nI][Len(aCols[_nI])])
						MsgInfo("Produto "+Alltrim(aCols[_nI,_nPosProd])+" com preço diferente do Cadastrado na Tabela de Preço de Transferência...!!!";
							+CR+CR+;
							"Preço do Pedido de Compra: "+CvaltoChar(aCols[_nI,_nPosPrec]);
							+CR+;
							"Preço da Tabela de Transferência: "+CvaltoChar(DA1->DA1_PRCVEN);
							+CR+CR+;
							"Favor manter o Preço da Tabela de Transferência...!!!")
						_lRet := .F.
						Exit
					Endif
				Else
					MsgInfo("Produto "+Alltrim(aCols[_nI,_nPosProd])+" não Cadastrado na Tabela de Preço de Transferência...!!!";
						+CR+CR+;
						"Solicite o Cadastro...!!!!")
					_lRet := .F.
					Exit
				EndIf
			Next _nI

		EndIf
	EndIf
	RestArea(_aArea)
	
Return(_lRet)
