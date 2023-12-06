#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ST154BLQ  ºAutor  ³Renato Nogueira     º Data ³  19/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para mostrar os itens bloqueados do processo		 	 º±±
±±º          ³															  		 º±±
±±º          ³					     								      		 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ST154BLQ()

	Local aArea   := GetArea()
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"
	Local aNeg		:={}

	_cLog:= "RELATÓRIO DE PRODUTOS BLOQUEADOS "+CHR(13)+CHR(10)

	cQuery	 := " SELECT DISTINCT W7_COD_I CODIGO, B1_MSBLQL BLOQ, W7_FORN FORNECEDOR, W7_FORLOJ LOJA "
	cQuery   += " FROM " +RetSqlName("SW7")+ " W7 "
	cQuery   += " LEFT JOIN " +RetSqlName("SB1")+ " B1 "
	cQuery	 += " ON B1_FILIAL='  ' AND B1_COD=W7_COD_I AND B1.D_E_L_E_T_=' '  "
	cQuery   += " WHERE W7.D_E_L_E_T_=' ' AND W7_FILIAL='"+SW6->W6_FILIAL+"' AND W7_HAWB='"+SW6->W6_HAWB+"' "
	
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	DbSelectArea("SA5")
	SA5->(DbSetOrder(1))
	
	While (cAlias)->(!Eof())
	
		SA5->(DbGoTop())
		SA5->(DbSeek(xFilial("SA5")+(cAlias)->(FORNECEDOR+LOJA)+(cAlias)->CODIGO))
		
		If AllTrim((cAlias)->BLOQ)=="1" //Bloqueado - Engenharia
	
			_ClOG+= AllTrim((cAlias)->CODIGO)+" - Engenharia"+CHR(13) +CHR(10)
		
		EndIf
		
		If SA5->(Eof())
		
			_ClOG+= AllTrim((cAlias)->CODIGO)+" - Qualidade - Não existe"+CHR(13) +CHR(10)
		
		EndIf
		
		If SA5->(!Eof()) .And. AllTrim(SA5->A5_SITU)<>"A"
		
			_ClOG+= AllTrim((cAlias)->CODIGO)+" - Qualidade - Situação"+CHR(13) +CHR(10)
		
		EndIf
	
		(cAlias)->(DbSkip())
	
	EndDo
	
	FT_FUSE()

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatorio de Inconsistencias '
	@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

	RestArea(aArea)

Return()