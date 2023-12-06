#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#DEFINE CR    chr(13)+chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa   STCOMMA     �Autor  �Giovani Zago    � Data �  16/07/14     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Retorna pre�o de venda				                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STCOMMA()
Local _aArea  := GetArea()
Local _nPosProd	    := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C7_PRODUTO"})
Local _nPosPrec	    := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C7_PRECO"})
Local _nPosQuan	    := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C7_QUANT"})
Local _nPosTot	    := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C7_TOTAL"})

//Validar se o item n�o est� deltado
If !Acols[n][Len(aHeader)+1]
	If  Alltrim(CA120FORN) = '005764'
		DbSelectArea("DA1")
		DA1->(DbSetOrder(1))
		If DA1->(DbSeek(xFilial("DA1")+'T01'+Acols[n,_nPosProd]))
			Acols[n,_nPosPrec] := DA1->DA1_PRCVEN
			MaFisRef("IT_PRCUNI","MT120",Acols[n,_nPosPrec])
			Acols[n,_nPosTot] := NoRound(	Acols[n,_nPosPrec]*	Acols[n,_nPosQuan],TamSX3("C7_TOTAL")[2])
			A120Total(	Acols[n,_nPosTot])
			MaFisRef("IT_VALMERC","MT120",	Acols[n,_nPosTot])
		Else
			MsgInfo("Produto N�o Cadastrado na Tabela de Pre�o de Transferencia..."+CR+"Solicite o Cadastro...!!!!")
		EndIf
	ElseIf  Alltrim(CA120FORN) = '005866'
		DbSelectArea("DA1")
		DA1->(DbSetOrder(1))
		If DA1->(DbSeek(xFilial("DA1")+'T02'+Acols[n,_nPosProd]))
			Acols[n,_nPosPrec] := DA1->DA1_PRCVEN
			MaFisRef("IT_PRCUNI","MT120",Acols[n,_nPosPrec])
			Acols[n,_nPosTot] := NoRound(	Acols[n,_nPosPrec]*	Acols[n,_nPosQuan],TamSX3("C7_TOTAL")[2])
			A120Total(	Acols[n,_nPosTot])
			MaFisRef("IT_VALMERC","MT120",	Acols[n,_nPosTot])
		Else
			MsgInfo("Produto N�o Cadastrado na Tabela de Pre�o de Transferencia..."+CR+"Solicite o Cadastro...!!!!")
		EndIf
		
		
	EndIf
EndIf

RestArea(_aArea)
Return(.f.)
