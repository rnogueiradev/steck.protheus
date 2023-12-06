#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STSC5DTA      ³Autor  ³ Renato Nogueira  ³ Data ³09.02.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Função utilizada para fazer a troca de data dos pedidos      ³±±
±±³          ³                                                             ³±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STSC5DTA(_cPedido)

Local aArea     	:= GetArea()
Local aAreaSC5  	:= SC5->(GetArea())
Local aAreaSC6  	:= SC6->(GetArea())
Local _aRet 		:= {}
Local _aParamBox 	:= {}

AADD(_aParamBox,{1,"Data",DDATABASE,"99/99/9999","","","",50,.F.})
	
	If ParamBox(_aParamBox,"Alteração de data do pedido",@_aRet,,,.T.,,500)
		
		If MsgYesNo("Confirma a troca de data do pedido "+Alltrim(SC5->C5_NUM)+" filial "+Alltrim(SC5->C5_FILIAL)+" para "+DTOC(_aRet[1])+"?")
			
			If SC5->(!Eof())
				
				SC5->(Reclock("SC5",.F.))
				SC5->C5_EMISSAO	:= _aRet[1]
				SC5->(Msunlock()) 
				
				MsgInfo("Data alterada com sucesso!")
				
			EndIf
			
		EndIf
		
	EndIf

RestArea(aAreaSC6)
RestArea(aAreaSC5)
RestArea(aArea)

Return