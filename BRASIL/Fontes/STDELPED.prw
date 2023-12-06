#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STDELPED  ºAutor  ³Renato Nogueira     º Data ³  11/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado para verificar e apagar o vendedor repetido º±±
±±º          ³no pedido                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STDELPED(cPedDe,cPedAte)

Local aArea     := GetArea()
Local aAreaSC5  := SC5->(GetArea())
Local aAreaSC6  := SC6->(GetArea())
Local aAreaSC9  := SC9->(GetArea())
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP"

cQuery	:= " SELECT C5_NUM PEDIDO "
cQuery  += " FROM " +RetSqlName("SC5")+ " SC5 "
cQuery  += " WHERE D_E_L_E_T_=' ' AND C5_NUM BETWEEN '"+cPedDe+"' AND '"+cPedAte+"' AND C5_FILIAL='"+xFilial("SC5")+"' "

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())

While (cAlias)->(!Eof())
	
	DbSelectArea("SC5")
	DbGoTop()
	DbSetOrder(1) //C5_FILIAL+C5_NUM
	DbSeek(xFilial("SC5")+(cAlias)->PEDIDO)
	
	If SC5->(!Eof())
		
		If SC5->C5_VEND1 == SC5->C5_VEND2 .And. Empty(SC5->C5_COMIS2)
			
			SC5->(RecLock('SC5',.F.))
			SC5->C5_VEND2 := ""
			SC5->(MsUnLock())
			
		EndIf
		
	EndIf
	
	(cAlias)->(DbSkip())
	
EndDo

RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)
RestArea(aArea)

Return()