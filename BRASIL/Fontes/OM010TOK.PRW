#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OM010TOK	ºAutor  ³Renato Nogueira     º Data ³  28/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado gerar log de alteração da tabela de preco   º±±
±±º          ³									  	 				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Lógico										              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
			
			_cMsg	:= "Usuário: "+cUserName+CHR(13) +CHR(10)
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