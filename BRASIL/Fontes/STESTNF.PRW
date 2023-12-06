#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STESTNF   ³Autor  ³ Giovani Zago		  ³   Data ³23.01.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Mostrar número da nota na tela de endereçamento de produto   ³±±
±±³          ³                                                             ³±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STESTNF()

Local aArea     := GetArea()
Local aAreaSDA  := SDA->(GetArea())
Local aAreaSDB  := SDB->(GetArea())
Local cQuery 		:= ""
Local cAlias 		:= "QRYTEMP"
Local cNf			:= ""


If SDA->DA_ORIGEM = 'SD1'
	
	cNf			:= SDA->DA_DOC
	
Else
	
	cQuery := " SELECT QEK_NTFISC "
	cQuery += " FROM " +RetSqlName("QEK") "
	cQuery += " WHERE D_E_L_E_T_=' ' AND QEK_FILIAL='"+xFilial("QEK")+"' AND QEK_CERFOR='"+SDA->DA_DOC+"' "
	
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	dbSelectArea(cAlias)
	
	(cAlias)->(dbGoTop())
	
	cNf	:= (cAlias)->QEK_NTFISC
	
	(cAlias)->(dbCloseArea())
	
EndIf

RestArea(aAreaSDA)
RestArea(aAreaSDB)
RestArea(aArea)

Return(cNf)
