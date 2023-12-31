#INCLUDE "PROTHEUS.CH"
#DEFINE CR    chr(13)+chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STPCVLDTRANSFERPRICE�Autor�Joao Rinaldi� Data �  01/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o chamada pelo ponto de entrada MT120OK para validar   ���
���          �se o pre�o de unit�rio do Pedido de Compra � o mesmo        ���
���          �informado na Tabela de Pre�o de Transfer�ncia no momento da ���
���          �gera��o do Pedido de Compra                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � MATA121.PRX                                                ���
���Nome      � Pedido de Compra                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
						MsgInfo("Produto "+Alltrim(aCols[_nI,_nPosProd])+" com pre�o diferente do Cadastrado na Tabela de Pre�o de Transfer�ncia...!!!";
							+CR+CR+;
							"Pre�o do Pedido de Compra: "+CvaltoChar(aCols[_nI,_nPosPrec]);
							+CR+;
							"Pre�o da Tabela de Transfer�ncia: "+CvaltoChar(DA1->DA1_PRCVEN);
							+CR+CR+;
							"Favor manter o Pre�o da Tabela de Transfer�ncia...!!!")
						_lRet := .F.
						Exit
					Endif
				Else
					MsgInfo("Produto "+Alltrim(aCols[_nI,_nPosProd])+" n�o Cadastrado na Tabela de Pre�o de Transfer�ncia...!!!";
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
						MsgInfo("Produto "+Alltrim(aCols[_nI,_nPosProd])+" com pre�o diferente do Cadastrado na Tabela de Pre�o de Transfer�ncia...!!!";
							+CR+CR+;
							"Pre�o do Pedido de Compra: "+CvaltoChar(aCols[_nI,_nPosPrec]);
							+CR+;
							"Pre�o da Tabela de Transfer�ncia: "+CvaltoChar(DA1->DA1_PRCVEN);
							+CR+CR+;
							"Favor manter o Pre�o da Tabela de Transfer�ncia...!!!")
						_lRet := .F.
						Exit
					Endif
				Else
					MsgInfo("Produto "+Alltrim(aCols[_nI,_nPosProd])+" n�o Cadastrado na Tabela de Pre�o de Transfer�ncia...!!!";
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
