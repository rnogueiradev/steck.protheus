#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCRGFCI  ºAutor  ³Renato Nogueira     º Data ³  01/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fonte utilizado para carregar os códigos de FCI em branco  º±±
±±º          ³ na tabela CFD                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STCRGFCI()

Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP"
Local cQuery2 	:= ""
Local cAlias2 	:= "QRYTEMP2"
Local cQuery3 	:= ""
Local cAlias3 	:= "QRYTEMP3"
Local nPreco	:= 0

	//verificar quais produtos estão na tabela sem fci
	
	cQuery	:= " SELECT DISTINCT CFD_COD CODIGO, CFD_FCICOD, R_E_C_N_O_ REGISTRO "
	cQuery  += " FROM " +RetSqlName("CFD")+ " CFD "
	cQuery  += " WHERE D_E_L_E_T_=' ' AND CFD_FCICOD=' ' AND CFD_VSAIIE=0  "
	
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	While (cAlias)->(!Eof())
	
	cQuery2	 := " SELECT C6_PRODUTO, C6_PRCVEN-C6_ZVALIPI-C6_ZVALICM PRECO, R_E_C_N_O_ REGISTRO "
	cQuery2  += " FROM " +RetSqlName("SC6")+ " C6 "
	cQuery2  += " WHERE R_E_C_N_O_ = ( "
	cQuery2	 += " SELECT MAX(R_E_C_N_O_) "
	cQuery2  += " FROM " +RetSqlName("SC6")+ " C6 "
	cQuery2  += " WHERE D_E_L_E_T_=' ' AND C6_PRODUTO='"+(cAlias)->CODIGO+"' AND C6_PRCVEN-C6_ZVALIPI-C6_ZVALICM>0 "
	cQuery2  += " GROUP BY C6_PRODUTO) "
	
	If !Empty(Select(cAlias2))
		DbSelectArea(cAlias2)
		(cAlias2)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAlias2,.T.,.T.)
	
	dbSelectArea(cAlias2)
	(cAlias2)->(dbGoTop())
	
	nPreco	:= (cAlias2)->PRECO	
	
	If nPreco = 0
	
	cQuery3	:= " SELECT UB_PRODUTO, UB_VRUNIT-UB_ZVALIPI-UB_ZVALICM PRECO, R_E_C_N_O_ REGISTRO "
	cQuery3 += " FROM " +RetSqlName("SUB")+ " UB "
	cQuery3 += " WHERE R_E_C_N_O_ = (  "
	cQuery3 += " SELECT MAX(R_E_C_N_O_) "
	cQuery3 += " FROM " +RetSqlName("SUB")+ " UB "
	cQuery3 += " WHERE D_E_L_E_T_=' ' AND UB_PRODUTO='"+(cAlias)->CODIGO+"' AND UB_VRUNIT-UB_ZVALIPI-UB_ZVALICM>0  GROUP BY UB_PRODUTO) "
	
	If !Empty(Select(cAlias3))
		DbSelectArea(cAlias3)
		(cAlias3)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),cAlias3,.T.,.T.)
	
	dbSelectArea(cAlias3)
	(cAlias3)->(dbGoTop())
	
	nPreco	:= (cAlias3)->PRECO	
	
	EndIf
	
	DbSelectArea("CFD")
	CFD->(DbGoTop())
	CFD->(DbGoTo((cAlias)->REGISTRO))
	
	CFD->(Reclock('CFD',.f.))
	CFD->CFD_VSAIIE	:= nPreco
	CFD->(MsUnlock())
	
	(cAlias)->(DbSkip())
	
	EndDo
	
	MsgAlert("Programa finalizado!")

Return()