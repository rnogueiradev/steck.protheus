#Include "protheus.ch"
#Include "topConn.ch"
#INCLUDE "TBICONN.CH"

#Define EOL chr(13)+chr(10)

// FMT CONSULTORIA

User Function TelaDest(lGeraS4)

	//Local cAliasAtu := ''//paramixb
	Local cQuery  	:= ''//paramixb[2]
	//Local _cQryCZI  := ""
	// FMT Consultoria
	Local oComboBo1
	Local oFont1 := TFont():New("Arial",,017,,.F.,,,,,.F.,.F.)
	Local oSay1
	Local oSButton1
	Static oDlg
	Private nComboBo1 := ''
	Private cDoc := ''
	
	// FMT Consultoria


	// FMT Consultoria
	/*
	1=São Paulo;2=Argentina;3=México;4=Local;5=Fábrica;6=Costa Rica
	1=033467/02
	2=033833/01
	3=México
	5=033467/05
	6=Não está em uso
	4=Local
	*/

	DEFINE MSDIALOG oDlg TITLE "Selecionar Destino da O.P." FROM 000, 000  TO 200, 230 COLORS 0, 16777215 PIXEL

	@ 044, 021 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"1 - Sao Paulo","2 - Argentina","3 - México","4 - Local","5 - Fábrica","6 - Costa Rica"} SIZE 076, 012 OF oDlg COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 026, 022 SAY oSay1 PROMPT "Destino da O.P." SIZE 075, 007 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
	DEFINE SBUTTON oSButton1 FROM 071, 073 TYPE 01 OF oDlg ENABLE ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

	_cDestOP := nComboBo1
	if Type("_cDestOP") # "C"
		_cDestOP := Alltrim(str(nComboBo1))
	Else	
		_cDestOP := Alltrim(substr(nComboBo1,1,1))
	Endif	
	cDoc  := "DESTINO"+_cDestOP

	if _cDestOP=='1'
		cQuery += " AND C6_CLI='033467' AND C6_LOJA='02' "
	ElseIf _cDestOP=='2'
		cQuery += " AND C6_CLI='033833' AND C6_LOJA='01' "
	ElseIf _cDestOP=='3'
		cQuery += " AND C6_CLI='019886' AND C6_LOJA='01' "
	ElseIf _cDestOP=='5'
		cQuery += " AND C6_CLI='033467' AND C6_LOJA='05' "
	Else
		cQuery += " AND C6_CLI NOT IN ('033467','033833','019886') "
	EndIf

	PutMV("STDESTMRP",_cDestOP)

	if lGeraS4
		if MsgYesNo("Gerar Previsão de Vendas SC4, para destino ' "+nComboBo1+" ' ?")
			GeraSC4(cQuery,cDoc)
		Endif
	Endif
	// FMT COnsultoria

Return()

///================================================================
Static Function GeraSC4(cQuery,cDoc)

	Local cQry1 := ''

	Pergunte("MTA712",.F.)

// Limpar SC4 DO MESMO DESTINO
	cQry1 := "DELETE "+RETSQLNAME('SC4')+" WHERE C4_DOC='"+cDoc+"' AND C4_FILIAL='"+cfilant+"' "
	TCSQLEXEC(cQry1)

	cQry1	:= " SELECT C6_PRODUTO PRODUTO,C6_ENTREG ENTREGA, C6_LOCAL, SUM(C6_QTDVEN-C6_QTDENT) AS PREVISAO "			 			+EOL
	cQry1	+= " FROM "+RETSQLNAME('SC6')+" SC6 "											+EOL
	cQry1	+= " JOIN "+RETSQLNAME('SC5')+" SC5 "											+EOL
	cQry1	+= " ON SC5.D_E_L_E_T_ = '' "												+EOL
	cQry1	+= " AND SC5.C5_NUM=SC6.C6_NUM "												+EOL
	cQry1	+= " AND SC5.C5_CLIENTE=SC6.C6_CLI "											+EOL
	cQry1	+= " AND SC5.C5_LOJACLI=SC6.C6_LOJA "										+EOL
	cQry1	+= " AND SC5.C5_FILIAL=SC6.C6_FILIAL "												+EOL
	cQry1	+= " AND SC5.C5_FILIAL='"+XFILIAL("SC5")+"' "												+EOL
	cQry1	+= " AND SC5.C5_TIPO='N' "													+EOL
	cQry1	+= " AND SC6.C6_BLQ=' ' "	         						     			+EOL
	cQry1	+= " INNER JOIN "+RETSQLNAME("SA1")+" SA1 "										+EOL
	cQry1	+= " ON  SC5.C5_CLIENTE=SA1.A1_COD "										+EOL
	cQry1	+= " AND SC5.C5_LOJACLI=SA1.A1_LOJA "										+EOL
	cQry1	+= " AND SA1.D_E_L_E_T_ = '' "												+EOL
	cQry1	+= " WHERE SC6.D_E_L_E_T_ = '' "												+EOL
	cQry1	+= " AND C6_QTDVEN>C6_QTDENT "							     				+EOL
	cQry1	+= " AND C6_ENTREG BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' "	+EOL
	If !empty(cQuery)
		cQry1	+= cQuery +EOL
	Endif
	cQry1	+= " GROUP BY C6_PRODUTO,C6_ENTREG,C6_LOCAL "							 				+EOL

	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf

	cQry1	:= ChangeQuery(cQry1)

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry1),"TMP")

	DBSelectArea("SC4")
	SC4->(DBSetOrder(1))

	WHILE TMP->(!EOF())
		IncProc()
		IF SC4->	(RECLOCK("SC4",.T.))
			SC4->C4_PRODUTO	:= TMP->PRODUTO
			SC4->C4_FILIAL	:= XFILIAL('SC4')
			SC4->C4_LOCAL	:= TMP->C6_LOCAL
			SC4->C4_DOC		:= cDoc
			SC4->C4_QUANT	:= TMP->PREVISAO
			SC4->C4_DATA	:= StoD(TMP->ENTREGA)
			SC4->(MSUNLOCK())
		ENDIF
		TMP->(DBSKIP())
	END

	TMP->(DbCloseArea())

	cQry1 := "SELECT COUNT(*) AS REGSC4 FROM "+RETSQLNAME('SC4')+" WHERE D_E_L_E_T_='' " 
	cQry1 += "AND C4_DOC='"+cDoc+"' AND C4_FILIAL='"+cfilant+"' "

	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf

	cQry1	:= ChangeQuery(cQry1)

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry1),"TMP")

	If TMP->REGSC4<=0
		MsgAlert("Não foram geradas previsoes de Vendas para o Destino "+nComboBo1) 
	Endif	

	TMP->(DbCloseArea())
Return
