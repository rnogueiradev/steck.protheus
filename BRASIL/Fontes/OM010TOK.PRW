#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OM010TOK	�Autor  �Renato Nogueira     � Data �  28/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado gerar log de altera��o da tabela de preco   ���
���          �									  	 				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � L�gico										              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function OM010TOK()

/*

Local _aArea     	:= GetArea()
Local _aAreaDA1  	:= DA1->(GetArea())
Local _lRet			:= .T.
Local _cMsg			:= ""
Local _nX			:= 0
Local _aProds		:= {}

If ALTERA .And. !IsInCallSteck("U_STTRANSFER")  .And. !IsInCallSteck("Oms010TCOk")  .And. !IsInCallSteck("U_STTRANSAM") 
	
	_aProds	:=	AClone(aCols)                             
	
	For _nX:=1 To Len(_aProds)
		
		DA1->(DbGoTo(_aProds[_nX][19]))
		
		If !(_aProds[_nX][7]==DA1->DA1_PRCVEN)
			
			_cMsg	:= "Usu�rio: "+cUserName+CHR(13) +CHR(10)
			_cMsg	+= "Alterado em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13) +CHR(10)
			_cMsg	+= "Campo | Anterior | Novo | Tabela "+CHR(13) +CHR(10)
			_cMsg	+= "DA1_PRCVEN"+" | "+CVALTOCHAR(DA1->DA1_PRCVEN)+" | "+CVALTOCHAR(_aProds[_nX][7])+" | "+DA1->DA1_CODTAB+CHR(13) +CHR(10)
			
			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbGoTop())
			
			If SB1->(DbSeek(xFilial("SB1")+DA1->DA1_CODPRO))
				SB1->(RecLock("SB1",.F.))
				SB1->B1_XLOGDA1	:= _cMsg+CHR(13)+CHR(10)+SB1->B1_XLOGDA1
				SB1->(MsUnLock())
			EndIf
			
		EndIf
		
	Next
	
EndIf

RestArea(_aAreaDA1)
RestArea(_aArea)

*/

Return(.T.)