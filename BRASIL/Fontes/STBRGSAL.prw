#Include "Protheus.ch"
#Include "FWMvcDef.CH"
#include "topconn.ch"

#DEFINE CR    chr(13)+chr(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � STBRGSAL� Autor � Jefferson              � Data �26/07/18  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Carrega o saldo atual na tela do pedido					  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function STBRGSAL()

	Local nSaldo	:= 0
	Local nSaldo2	:= 0
	Local _nQuant	:= 0
	Local nQuant		:= ""
	Local _nProd	:= 0
	Local cProd		:= ""
	Local _nLocal	:= 0
	Local cLocal	:= ""


	_nQuant := aScan(aHeader,{|x| AllTrim(x[2]) == "CP_QUANT"})
	nQuant  		:= M->CP_QUANT //aCols[n][_nQuant]

	_nProd := aScan(aHeader,{|x| AllTrim(x[2]) == "CP_PRODUTO"})
	cProd  		:= aCols[n][_nProd]


	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	If SB1->(DbSeek(xFilial("SB1")+cProd))

		DbSelectArea("SB2")
		SB2->(DbSetOrder(1))
		If SB2->(DbSeek(xFilial("SB2")+SB1->(B1_COD+B1_LOCPAD)))
			nSaldo := SaldoSb2()
		EndIf

		If nQuant >  nSaldo

			nSaldo2 := TRANSFORM(nSaldo, "@E 999,999,999.99")
			//Help(NIL, NIL, "Saldo", NIL, 'Saldo Insuficiente em estoque.'+CR+' Saldo Atual:'+TRANSFORM(nSaldo, "@E 999,999,999.99") , 1, 0, NIL, NIL, NIL, NIL, NIL, {'Verifique a Quantidade Digitada.'})
			Help(NIL, NIL, "Saldo", NIL, 'Saldo Insuficiente em estoque.'+CR+' Saldo Atual:'+nSaldo2 , 1, 0, NIL, NIL, NIL, NIL, NIL, {'Verifique a Quantidade Digitada.'})
		EndIf

	EndIf

Return .t.
