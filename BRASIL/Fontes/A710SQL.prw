#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

User Function A710SQL()

	Local cAliasAtu := paramixb[1]
	Local cQuery  	:= paramixb[2]
	Local _cQryCZI  := ""
	// FMT Consultoria
	//Local oComboBo1
	//Local nComboBo1 := 1
	//Local oFont1 := TFont():New("Arial",,017,,.F.,,,,,.F.,.F.)
	//Local oSay1
	//Local oSButton1
	//Static oDlg
	//Public _cDestOP := ''
	// FMT Consultoria

	If cAliasAtu == 'SC1' 

		cQuery += " AND C1_ZSTATUS NOT IN ('4','5') " // Ticket 20200629003515 - Everson Santana - 29.06.2020

	EndIf


	If cAliasAtu == 'SC6' 

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

		
		if cEmpAnt=='03'  // Manaus
		
			//DEFINE MSDIALOG oDlg TITLE "Selecionar Destino da O.P." FROM 000, 000  TO 200, 230 COLORS 0, 16777215 PIXEL

			//@ 044, 021 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"1 - Sao Paulo","2 - Argentina","3 - México","4 - Local","5 - Fábrica","6 - Costa Rica"} SIZE 076, 012 OF oDlg COLORS 0, 16777215 FONT oFont1 PIXEL
			//@ 026, 022 SAY oSay1 PROMPT "Destino da O.P." SIZE 075, 007 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
			//DEFINE SBUTTON oSButton1 FROM 071, 073 TYPE 01 OF oDlg ENABLE ACTION (_cDestOP:=Alltrim(Str(nComboBo1)),oDlg:End())

			//ACTIVATE MSDIALOG oDlg CENTERED

			_cDestOP := AllTrim(GetMv("STDESTMRP",,""))
	
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

			cQuery := ChangeQuery(cQuery)

			Return(cQuery)
		EndIf
		
		// FMT COnsultoria
		
		If cfilant == '02'

			If Select("TRD") > 0
				TRD->(DbCloseArea())
			Endif

			_cQryCZI := " "
			_cQryCZI += " SELECT * FROM "+RetSqlName("CZI")+ " WHERE CZI_FILIAL = '"+xFilial("CZI")+"' AND CZI_ALIAS = 'PAR' AND D_E_L_E_T_ = ' ' "

			TcQuery _cQryCZI New Alias "TRD"

			TRD->(dbGoTop())

			cQuery := " "
			
			cQuery := " SELECT SC6.C6_BLQ,  SC6.C6_ITEM,  SC6.C6_FILIAL,  SC6.C6_QTDVEN,  SC6.C6_QTDENT,  SC6.C6_LOCAL,  SC6.C6_PRODUTO,  SC6.C6_TES,  SC6.C6_ENTREG,  SC6.C6_NUM,  SC6.C6_OP,  SC6.C6_OPC,  SC6.C6_REVISAO,  SC6.C6_DATFAT,  SC6.R_E_C_N_O_ C6REC  "+ CRLF
			cQuery += " FROM "+RetSqlName("SC6")+" SC6, "+RetSqlName("SB1")+" SB1,"+RetSqlName("SF4")+" SF4  "+ CRLF
			cQuery += " WHERE SC6.C6_FILIAL  = '"+xFilial("SC6")+"' "+ CRLF
			cQuery += " AND SC6.C6_LOCAL  >= '01'  AND SC6.C6_LOCAL  <= '98'   "+ CRLF   
			cQuery += " AND (SC6.C6_BLQ    = '  '   OR  SC6.C6_BLQ    = 'N ')   "+ CRLF
			//cQuery += " AND SC6.C6_ENTREG <= '20190502'   "
			cQuery += " AND SC6.D_E_L_E_T_ = ' '   "+ CRLF
			cQuery += " AND SC6.C6_PRODUTO = SB1.B1_COD  "+ CRLF
			cQuery += " AND SF4.F4_FILIAL  = '"+xFilial("SF4")+"'  "+ CRLF
			cQuery += " AND SF4.F4_ESTOQUE = 'S'  "+ CRLF
			cQuery += " AND SF4.F4_CODIGO  = SC6.C6_TES "+ CRLF   
			cQuery += " AND SF4.D_E_L_E_T_ = ' '  "+ CRLF
			cQuery += " AND SC6.C6_OP <> '02'  " + CRLF
			cQuery += " AND SC6.C6_LOCAL IN (SELECT NR_LOCAL FROM CZINNR)   "+ CRLF
			cQuery += " AND SB1.B1_FILIAL   = '"+xFilial("SB1")+"' "+ CRLF
			cQuery += " AND SB1.B1_FANTASM <> 'S' "+ CRLF
			cQuery += " AND SB1.D_E_L_E_T_  = ' ' "+ CRLF
			cQuery += " AND B1_MSBLQL <> '1' "+ CRLF
			cQuery += " AND SB1.B1_MRP     IN (' ','S') "+ CRLF
			cQuery += " AND SB1.B1_TIPO IN (SELECT TP_TIPO FROM CZITTP)  "+ CRLF
			cQuery += " AND SB1.B1_GRUPO IN (SELECT GR_GRUPO FROM CZITGR)  "+ CRLF
			cQuery += " AND SC6.C6_QTDENT < SC6.C6_QTDVEN  "+ CRLF
			
			cQuery += " UNION "+ CRLF
			
			cQuery += " SELECT * FROM ( "+ CRLF  		
			cQuery += " SELECT SC6.C6_BLQ , D2_ITEMPV C6_ITEM,  D2_FILIAL C6_FILIAL,  D2_QUANT C6_QTDVEN,  D2_QUANT C6_QTDENT,  D2_LOCAL C6_LOCAL,  D2_COD C6_PRODUTO,  SD2.D2_TES C6_TES,  SD2.D2_EMISSAO C6_ENTREG,  SD2.D2_PEDIDO C6_NUM,  SC6.C6_OP, SC6.C6_OPC,  SC6.C6_REVISAO,  SC6.C6_DATFAT,  SC6.R_E_C_N_O_ C6REC "+ CRLF
			cQuery += " FROM "+RetSqlName("SD2")+" SD2 " + CRLF    
			cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SF4")+")SF4  "+ CRLF
			cQuery += " ON SF4.D_E_L_E_T_ = ' '  "+ CRLF
			cQuery += " AND F4_CODIGO = D2_TES  "+ CRLF
			cQuery += " AND F4_ESTOQUE = 'S' "+ CRLF
			cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+")SB1 "+ CRLF
			cQuery += " ON SB1.D_E_L_E_T_ = ' '  "+ CRLF
			cQuery += " AND B1_COD = D2_COD  "+ CRLF
			cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SBM")+")SBM  "+ CRLF
			cQuery += " ON SBM.D_E_L_E_T_ = ' ' "+ CRLF
			cQuery += " LEFT JOIN (SELECT * FROM "+RetSqlName("SC6")+") SC6 "+ CRLF 
			cQuery += " ON SC6.C6_FILIAL = SD2.D2_FILIAL "+ CRLF
			cQuery += " AND SC6.C6_NUM = SD2.D2_PEDIDO "+ CRLF
			cQuery += " AND SC6.C6_ITEM = SD2.D2_ITEMPV "+ CRLF
			cQuery += " AND SC6.D_E_L_E_T_ = ' ' "+ CRLF
			cQuery += " AND BM_GRUPO = B1_GRUPO  "+ CRLF
			cQuery += " WHERE SD2.D_E_L_E_T_ = ' ' "+ CRLF
			cQuery += " AND D2_FILIAL = '"+xFilial("SD2")+"' "+ CRLF
			cQuery += " AND D2_EMISSAO BETWEEN '"+ TRD->CZI_DTOG +"' AND '"+ dtos(dDatabase) +"' "+ CRLF
			cQuery += " AND BM_GRUPO   IN(SELECT GR_GRUPO FROM CZITGR) "+ CRLF
			cQuery += " AND SB1.B1_TIPO IN(SELECT TP_TIPO FROM CZITTP WHERE D_E_L_E_T_ = ' ') "+ CRLF
			cQuery += " AND D2_CLIENTE <> '033467' " + CRLF
			cQuery += " AND SC6.R_E_C_N_O_ > 0 " + CRLF
			cQuery += " AND D2_LOCAL <> '60' " + CRLF
			cQuery += " ORDER BY C6_FILIAL,C6_ITEM,C6_PRODUTO " + CRLF//+ SqlOrder(SC6->(IndexKey(2)))
			cQuery += " ) TMP" + CRLF
			
			cQuery := ChangeQuery(cQuery)

		ElseIf cfilant == '04'

			If Select("TRD") > 0
				TRD->(DbCloseArea())
			Endif

			_cQryCZI := " "
			_cQryCZI += " SELECT * FROM "+RetSqlName("CZI")+ " WHERE CZI_FILIAL = '"+xFilial("CZI")+"' AND CZI_ALIAS = 'PAR' AND D_E_L_E_T_ = ' ' "

			TcQuery _cQryCZI New Alias "TRD"

			TRD->(dbGoTop())

			cQuery := " "
			
			cQuery := " SELECT SC6.C6_BLQ,  SC6.C6_ITEM,  SC6.C6_FILIAL,  SC6.C6_QTDVEN,  SC6.C6_QTDENT,  SC6.C6_LOCAL,  SC6.C6_PRODUTO,  SC6.C6_TES,  SC6.C6_ENTRE1 C6_ENTREG,  SC6.C6_NUM,  SC6.C6_OP,  SC6.C6_OPC,  SC6.C6_REVISAO,  SC6.C6_DATFAT,  SC6.R_E_C_N_O_ C6REC  "+ CRLF
			cQuery += " FROM "+RetSqlName("SC6")+" SC6, "+RetSqlName("SB1")+" SB1,"+RetSqlName("SF4")+" SF4  "+ CRLF
			cQuery += " WHERE SC6.C6_FILIAL  = '"+xFilial("SC6")+"' "+ CRLF
			cQuery += " AND SC6.C6_LOCAL  >= '01'  AND SC6.C6_LOCAL  <= '98'   "+ CRLF   
			cQuery += " AND (SC6.C6_BLQ    = '  '   OR  SC6.C6_BLQ    = 'N ')   "+ CRLF
		//	cQuery += " AND SC6.C6_ENTREG <= '20190502'   "
			cQuery += " AND SC6.D_E_L_E_T_ = ' '   "+ CRLF
			cQuery += " AND SC6.C6_PRODUTO = SB1.B1_COD  "+ CRLF
			cQuery += " AND SF4.F4_FILIAL  = '"+xFilial("SF4")+"'  "+ CRLF
			cQuery += " AND SF4.F4_ESTOQUE = 'S'  "+ CRLF
			cQuery += " AND SF4.F4_CODIGO  = SC6.C6_TES "+ CRLF   
			cQuery += " AND SF4.D_E_L_E_T_ = ' '  "+ CRLF
			cQuery += " AND SC6.C6_OP <> '02'  " + CRLF
			cQuery += " AND SC6.C6_LOCAL IN (SELECT NR_LOCAL FROM CZINNR)   "+ CRLF
			cQuery += " AND SB1.B1_FILIAL   = '"+xFilial("SB1")+"' "+ CRLF
			cQuery += " AND SB1.B1_FANTASM <> 'S' "+ CRLF
			cQuery += " AND SB1.D_E_L_E_T_  = ' ' "+ CRLF
			cQuery += " AND B1_MSBLQL <> '1' "+ CRLF
			cQuery += " AND SB1.B1_MRP     IN (' ','S') "+ CRLF
			cQuery += " AND SB1.B1_TIPO IN (SELECT TP_TIPO FROM CZITTP)  "+ CRLF
			cQuery += " AND SB1.B1_GRUPO IN (SELECT GR_GRUPO FROM CZITGR)  "+ CRLF
			cQuery += " AND SC6.C6_QTDENT < SC6.C6_QTDVEN  "+ CRLF
			
			cQuery += " UNION "+ CRLF
			
			cQuery += " SELECT * FROM ( "+ CRLF  		
			cQuery += " SELECT SC6.C6_BLQ , D2_ITEMPV C6_ITEM,  D2_FILIAL C6_FILIAL,  D2_QUANT C6_QTDVEN,  D2_QUANT C6_QTDENT,  D2_LOCAL C6_LOCAL,  D2_COD C6_PRODUTO,  SD2.D2_TES C6_TES,  SD2.D2_EMISSAO C6_ENTREG,  SD2.D2_PEDIDO C6_NUM,  SC6.C6_OP, SC6.C6_OPC,  SC6.C6_REVISAO,  SC6.C6_DATFAT,  SC6.R_E_C_N_O_ C6REC "+ CRLF
			cQuery += " FROM "+RetSqlName("SD2")+" SD2 " + CRLF    
			cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SF4")+")SF4  "+ CRLF
			cQuery += " ON SF4.D_E_L_E_T_ = ' '  "+ CRLF
			cQuery += " AND F4_CODIGO = D2_TES  "+ CRLF
			cQuery += " AND F4_ESTOQUE = 'S' "+ CRLF
			cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+")SB1 "+ CRLF
			cQuery += " ON SB1.D_E_L_E_T_ = ' '  "+ CRLF
			cQuery += " AND B1_COD = D2_COD  "+ CRLF
			cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SBM")+")SBM  "+ CRLF
			cQuery += " ON SBM.D_E_L_E_T_ = ' ' "+ CRLF
			cQuery += " LEFT JOIN (SELECT * FROM "+RetSqlName("SC6")+") SC6 "+ CRLF 
			cQuery += " ON SC6.C6_FILIAL = SD2.D2_FILIAL "+ CRLF
			cQuery += " AND SC6.C6_NUM = SD2.D2_PEDIDO "+ CRLF
			cQuery += " AND SC6.C6_ITEM = SD2.D2_ITEMPV "+ CRLF
			cQuery += " AND SC6.D_E_L_E_T_ = ' ' "+ CRLF
			cQuery += " AND BM_GRUPO = B1_GRUPO  "+ CRLF
			cQuery += " WHERE SD2.D_E_L_E_T_ = ' ' "+ CRLF
			cQuery += " AND D2_FILIAL = '"+xFilial("SD2")+"' "+ CRLF
			cQuery += " AND D2_EMISSAO BETWEEN '"+ TRD->CZI_DTOG +"' AND '"+ dtos(dDatabase) +"' "+ CRLF
			cQuery += " AND BM_GRUPO   IN(SELECT GR_GRUPO FROM CZITGR) "+ CRLF
			cQuery += " AND SB1.B1_TIPO IN(SELECT TP_TIPO FROM CZITTP WHERE D_E_L_E_T_ = ' ') "+ CRLF
			cQuery += " AND D2_CLIENTE <> '033467' " + CRLF
			cQuery += " AND SC6.R_E_C_N_O_ > 0 " + CRLF
			cQuery += " AND D2_LOCAL <> '60' " + CRLF
			cQuery += " ORDER BY C6_FILIAL,C6_ITEM,C6_PRODUTO " + CRLF//+ SqlOrder(SC6->(IndexKey(2)))
			cQuery += " ) TMP" + CRLF
			
			cQuery := ChangeQuery(cQuery)
				
		EndIf
		
		//MemoWrite( "C:\Temp\MRP\A710SQL.txt", cQuery )
		
	EndIf


Return cQuery
