#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STCMPROM      ³Autor  ³ Renato Nogueira  ³ Data ³13.02.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Função utilizada para retornar informações das notas do      ³±±
±±³          ³romaneio                                                     ³±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STCMPROM(_cCampo)

	Local aArea     := GetArea()
	Local aAreaPD1  := PD1->(GetArea())
	Local aAreaPD2  := PD2->(GetArea())
	Local _nVal		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"
	
	
	If IsInCallStack("U_STROMA00") 
		If xInclui
			Return (0)
		Endif
	Endif
	DO CASE

		CASE Alltrim(_cCampo) == "VLRNTS"

		cQuery	:= " SELECT SUM(F2_VALBRUT) VALBRUT "
		cQuery  += " FROM " +RetSqlName("PD2")+ " PD2 "
		cQuery  += " LEFT JOIN " +RetSqlName("SF2")+ " SF2 "
		cQuery  += " ON PD2_FILIAL=F2_FILIAL AND PD2_NFS=F2_DOC AND PD2_SERIES=F2_SERIE AND PD2_CLIENT=F2_CLIENTE AND PD2_LOJCLI=F2_LOJA "
		cQuery  += " WHERE PD2.D_E_L_E_T_=' ' AND SF2.D_E_L_E_T_=' '  AND PD2_CODROM='"+PD1->PD1_CODROM+"' AND PD2_FILIAL='"+PD1->PD1_FILIAL+"' "

		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		_nVal := (cAlias)->VALBRUT

		CASE Alltrim(_cCampo) == "QTDNFS"

		cQuery	:= " SELECT COUNT(F2_DOC) CONTADOR "
		cQuery  += " FROM " +RetSqlName("PD2")+ " PD2 "
		cQuery  += " LEFT JOIN " +RetSqlName("SF2")+ " SF2 "
		cQuery  += " ON PD2_FILIAL=F2_FILIAL AND PD2_NFS=F2_DOC AND PD2_SERIES=F2_SERIE AND PD2_CLIENT=F2_CLIENTE AND PD2_LOJCLI=F2_LOJA "
		cQuery  += " WHERE PD2.D_E_L_E_T_=' ' AND SF2.D_E_L_E_T_=' '  AND PD2_CODROM='"+PD1->PD1_CODROM+"' AND PD2_FILIAL='"+PD1->PD1_FILIAL+"' "

		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		_nVal := (cAlias)->CONTADOR
		
		CASE Alltrim(_cCampo) == "QTDENT"
		
		cQuery := " SELECT COUNT(*) CONTADOR "
		cQuery += " FROM " +RetSqlName("PD2")+ " PD2 "
		cQuery += " WHERE PD2.D_E_L_E_T_=' ' AND PD2_FILIAL='"+PD1->PD1_FILIAL+"' 
		cQuery += " AND PD2_CODROM='"+PD1->PD1_CODROM+"' AND PD2_STATUS='4'

		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		_nVal := (cAlias)->CONTADOR		
		
		CASE Alltrim(_cCampo) == "QTDRET"

		cQuery := " SELECT COUNT(*) CONTADOR "
		cQuery += " FROM " +RetSqlName("PD2")+ " PD2 "
		cQuery += " WHERE PD2.D_E_L_E_T_=' ' AND PD2_FILIAL='"+PD1->PD1_FILIAL+"' 
		cQuery += " AND PD2_CODROM='"+PD1->PD1_CODROM+"' AND PD2_STATUS='5'

		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		_nVal := (cAlias)->CONTADOR		

	ENDCASE

	RestArea(aAreaPD1)
	RestArea(aAreaPD2)
	RestArea(aArea)

Return(_nVal)