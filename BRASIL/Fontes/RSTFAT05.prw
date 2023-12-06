#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    RSTFAT05   º Autor ³ Giovani.Zago       º Data ³  20/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ relatorio de pedidos rejeitados                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RSTFAT05()

	Local cString 			:= "SC5"
	Local cDesc1         	:= "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         	:= "dos Pedidos Rejeitados"
	Local cDesc3         	:= ""
	Local cPict         	:= ""
	Local titulo       		:= "Pedidos Rejeitados"
	Local nLin         		:= 70
//                                    1         2         3         4         5         6         7         8         9         0         1         2         3         4         6         7         8         9
//                          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	Local Cabec1       		:= "PEDIDO  EMISSAO    CLIENTE  LOJA   NOME                               VENDEDOR  NOME  VEND.                   DT. REJEIÇÃO  VALOR             MOTIVO"
	Local Cabec2      		:= "======= ========== ======== ====== ================================== ========= ============================= ============= ================= ======================================================="
	Local imprime      		:= .T.
	Local aOrd 				:= {}
	Private _nGetCond       :=  GetMv("ST_VALMIN",,400)
	Private lEnd         	:= .F.
	Private lAbortPrint  	:= .F.
	Private CbTxt        	:= ""
	Private limite          := 70
	Private tamanho         := "G"
	Private nomeprog        := "COMISS"
	Private nTipo           := 18
	Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cbcont     		:= 00
	Private CONTFL     		:= 01
	Private m_pag      		:= 01
	Private wnrel      		:= "RFAT05"
	Private cPerg       	:= "RFAT05"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos

	cbtxt     		:= Space(10)
//	If MsgYesNo("Novo Relatorio?")
	U_XRSTFAT05()
Return()
//	EndIf

	AjustaSX1(cPerg)
	If Pergunte(cPerg,.t.)

		wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

		If nLastKey == 27
			Return
		Endif

		SetDefault(aReturn,cString)

		If nLastKey == 27
			Return
		Endif

		nTipo := If(aReturn[4]==1,15,18)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	Endif
Return


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    RunReport  º Autor ³ Giovani.Zago       º Data ³  16/06/13   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ relatorio de pedido aptos a faturar                        º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local _aResult  :={{0,0,0,0,0}}
	Local _nXCon    := 0
	StQuery()

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			If nLin > 65
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif

			nLin := nLin + 1
			@nLIN,000 PSAY 	(cAliasLif)->C5_NUM //2
			@nLIN,008 PSAY 	STOD((cAliasLif)->C5_EMISSAO)      //6
			@nLIN,019 PSAY  (cAliasLif)->C5_CLIENTE      //6
			@nLIN,028 PSAY 	(cAliasLif)->C5_LOJACLI      //6
			@nLIN,035 PSAY 	SUBSTR((cAliasLif)->A1_NOME,1,33)     //6
			@nLIN,070 PSAY 	(cAliasLif)->A3_COD
			@nLIN,080 PSAY 	SUBSTR((cAliasLif)->A3_NOME,1,29)
			@nLIN,110 PSAY 	STOD((cAliasLif)->C5_ZDTREJE)      //6
			@nLIN,142 PSAY 	(cAliasLif)->C5_ZMOTREJ
			@nLIN,124 PSAY 	transform((cAliasLif)->TOTAL	,"@E 99,999,999,999.99")

			_nXCon++
			(cAliasLif)->(dbskip())

		End

	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return


Static Function AjustaSX1(cPerg)

	Local _aArea	  := GetArea()
	Local _aRegistros := {}
	Local i			  := 0
	Local j           := 0

	cPerg := PADR(cPerg, Len(SX1->X1_GRUPO)," " )
	Aadd(_aRegistros,{cPerg, "01", "Da Data:" ,"Da Data: ?" ,"Da Data: ?" 				   			,"mv_ch1","D",8,0,0,"G","","mv_par01" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(_aRegistros,{cPerg, "02", "Ate Data:" ,"Ate Data: ?" ,"Ate Data: ?" 			   			,"mv_ch2","D",8,0,0,"G","","mv_par02" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(_aRegistros,{cPerg, "03", "Da Vendedor:" ,"Da Vendedor: ?" ,"Da Vendedor: ?" 			   	,"mv_ch3","C",6,0,0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
	Aadd(_aRegistros,{cPerg, "04", "Ate Vendedor:" ,"Ate Vendedor: ?" ,"Ate Vendedor: ?" 			,"mv_ch4","C",6,0,0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
	AADD(_aRegistros,{cPerg, "05","Cliente de  ?",											   "","","mv_ch5","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
	AADD(_aRegistros,{cPerg, "06","Cliente até ?",											   "","","mv_ch6","C",06,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
	AADD(_aRegistros,{cPerg, "07","Loja de    ?",											   "","","mv_ch7","C",02,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegistros,{cPerg, "08","Loja até   ?",											   "","","mv_ch8","C",02,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","",""})

	dbSelectArea("SX1")
	_nCols := FCount()

	For i:=1 to Len(_aRegistros)

		aSize(_aRegistros[i],_nCols)

		If !dbSeek(_aRegistros[i,1]+_aRegistros[i,2])

			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,if(_aRegistros[i,j]=Nil, "",_aRegistros[i,j] ))
			Next j

			MsUnlock()

		EndIf
	Next i

	RestArea(_aArea)

Return(NIL)

Static Function StQuery()

	Local cQuery     := ' '

	cQuery := " SELECT
	cQuery += " C5_NUM,
	cQuery += " C5_EMISSAO,
	cQuery += " C5_CLIENTE,
	cQuery += " C5_LOJACLI,
	cQuery += " A1_NOME,
	cQuery += " A3_COD,
	cQuery += " A3_NOME,
	cQuery += " C5_ZDTREJE,
	cQuery += " C5_ZMOTREJ,
	cQuery += " ROUND(SUM(C9_QTDLIB*C9_PRCVEN),2) TOTAL,
	cQuery += " C5_ZBLOQ"

	cQuery += " FROM "+RetSqlName("SC5")+" SC5 "

	cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SC6")+" )SC6 "
	cQuery += " ON SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_NUM = SC5.C5_NUM
	cQuery += " AND SC6.C6_FILIAL = SC5.C5_FILIAL

	cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SC9")+" )SC9 "
	cQuery += " ON SC9.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_NUM = SC9.C9_PEDIDO
	cQuery += " AND SC6.C6_ITEM = SC9.C9_ITEM
	cQuery += " AND SC9.C9_BLCRED = '09'
	cQuery += " AND SC6.C6_FILIAL = SC9.C9_FILIAL

	cQuery += " INNER JOIN( SELECT * FROM "+RetSqlName("SA3")+" )SA3 "
	cQuery += " ON SA3.A3_COD = SC5.C5_VEND2
	cQuery += " AND SA3.D_E_L_E_T_ = ' '
	cQuery += " AND SA3.A3_FILIAL =  '"+xFilial("SA3")+"'"


	cQuery += " INNER JOIN( SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
	cQuery += " ON SA1.A1_COD = SC5.C5_CLIENTE
	cQuery += " AND SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI
	cQuery += " AND SA1.A1_FILIAL =  '"+xFilial("SA1")+"'"

	cQuery += " WHERE  SC5.D_E_L_E_T_   = ' '
	cQuery += " AND SC5.C5_EMISSAO BETWEEN  '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
	cQuery += " AND SC5.C5_FILIAL   = '"+xFilial("SC5")+"'"
	cQuery += " AND SC5.C5_NOTA NOT LIKE '%XXX%'
	cQuery += " AND SC5.C5_VEND2 BETWEEN  '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery += " AND SC5.C5_CLIENTE BETWEEN  '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "

	cQuery += " GROUP BY C5_NUM,
	cQuery += " C5_EMISSAO,
	cQuery += " C5_CLIENTE,
	cQuery += " C5_LOJACLI,
	cQuery += " A1_NOME,
	cQuery += " A3_COD,
	cQuery += " A3_NOME,
	cQuery += " C5_ZDTREJE,
	cQuery += " C5_ZMOTREJ
	cQuery += " ORDER BY C5_NUM

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  XRSTFAT05    ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio Valor Liquido 		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function XRSTFAT05()
	Local   oReport
	Private cPerg 			:= "RFAT05"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"Relatório Pedidos Rejeitados",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório Pedidos Rejeitados.")
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 10

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Pedidos Rejeitados",{"SC5"})

	TRCell():New(oSection,"PEDIDO"	  	,,"PEDIDO"			,,6,.F.,)
	TRCell():New(oSection,"EMISSAO"		,,"EMISSAO"		,,10,.F.,)
	TRCell():New(oSection,"CLIENTE"  	,,"CLIENTE"		,,6,.F.,)
	TRCell():New(oSection,"LOJA"  		,,"LOJA"			,,2,.F.,)
	TRCell():New(oSection,"CNPJ"  		,,"CNPJ"			,,20,.F.,)
	TRCell():New(oSection,"NOME"  		,,"NOME"			,,35,.F.,)
	TRCell():New(oSection,"VENDEDOR"    ,,"VENDEDOR"		,,6,.F.,)
	TRCell():New(oSection,"NOME_VEND"   ,,"NOME_VEND"	,,35,.F.,)
	TRCell():New(oSection,"REJEIÇÃO"	,,"REJEIÇÃO"		,,10,.F.,)
	TRCell():New(oSection,"VALOR"		,,"VALOR"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"MOTIVO"  	,,"MOTIVO"			,,50,.F.,)
	//TRCell():New(oSection,"1A_COMPRA"	,,"1A_COMPRA"		,,10,.F.,)
	//TRCell():New(oSection,"ULT_COMPRA"	,,"ULT_COMPRA"	,,10,.F.,)
	//TRCell():New(oSection,"ACUMULADO"	,,"ACUMULADO"		,"@E 99,999,999.99",14)
	//TRCell():New(oSection,"MAIOR_COMPRA",,"MAIOR_COMPRA"	,"@E 99,999,999.99",14)
	//TRCell():New(oSection,"QTD_LINHAS"	,,"QTD_LINHAS"	,"@E 99,999,999.99",14)
	//TRCell():New(oSection,"QTD_PECAS"	,,"QTD_PECAS"		,"@E 99,999,999.99",14)
	//TRCell():New(oSection,"Vlr Reserva" ,,"VLR_RESERV",		"@E 99,999,999.99",14)
	TRCell():New(oSection,"COND_PAG"  	,,"COND.PAGTO."		,,6,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC5")

Return oReport

Static Function ReportPrint(oReport)
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados[2]
	Local aDados1[99]

	If MV_PAR09 = 2
		TRCell():New(oSection,"Status Pedido",,"STS_PEDIDO"	,,14,.F.)
	EndIf
	
	oSection1:Cell("PEDIDO")       	:SetBlock( { || aDados1[01] } )
	oSection1:Cell("EMISSAO")	   	:SetBlock( { || aDados1[02] } )
	oSection1:Cell("CLIENTE")  		:SetBlock( { || aDados1[03] } )
	oSection1:Cell("LOJA")  		:SetBlock( { || aDados1[04] } )
	oSection1:Cell("CNPJ")	  		:SetBlock( { || aDados1[05] } )
	oSection1:Cell("NOME")	  		:SetBlock( { || aDados1[06] } )
	oSection1:Cell("VENDEDOR")     	:SetBlock( { || aDados1[07] } )
	oSection1:Cell("NOME_VEND")    	:SetBlock( { || aDados1[08] } )
	oSection1:Cell("REJEIÇÃO")     	:SetBlock( { || aDados1[09] } )
	oSection1:Cell("VALOR")        	:SetBlock( { || aDados1[10] } )
	oSection1:Cell("MOTIVO")       	:SetBlock( { || aDados1[11] } )
	//oSection1:Cell("1A_COMPRA")    	:SetBlock( { || aDados1[12] } )
	//oSection1:Cell("ULT_COMPRA")   	:SetBlock( { || aDados1[13] } )
	//oSection1:Cell("ACUMULADO")    	:SetBlock( { || aDados1[14] } )
	//oSection1:Cell("MAIOR_COMPRA") 	:SetBlock( { || aDados1[15] } )
	//oSection1:Cell("QTD_LINHAS") 	:SetBlock( { || aDados1[16] } )
	//oSection1:Cell("QTD_PECAS") 	:SetBlock( { || aDados1[17] } )
	//oSection1:Cell("VLR_RESERV") 	:SetBlock( { || aDados1[18] } )
	oSection1:Cell("COND_PAG") 		:SetBlock( { || aDados1[19] } )

	If MV_PAR09 = 2
		oSection1:Cell("STS_PEDIDO") 	:SetBlock( { || aDados1[19] } )
	Endif

	oReport:SetTitle("Pedidos Rejeitados")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| XStQuery( ) },"Compondo Relatorio")

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aRetRes		:=	RetRes((cAliasLif)->C5_NUM)
			aDados1[01]	:= 	(cAliasLif)->C5_NUM
			aDados1[02]	:=  (cAliasLif)->C5_EMISSAO
			aDados1[03]	:=	(cAliasLif)->C5_CLIENTE
			aDados1[04]	:=	(cAliasLif)->C5_LOJACLI
			aDados1[05]	:=	Left((cAliasLif)->A1_CGC,8)
			aDados1[06]	:=	(cAliasLif)->A1_NOME
			aDados1[07]	:=	(cAliasLif)->A3_COD
			aDados1[08]	:=	(cAliasLif)->A3_NOME
			aDados1[09]	:=	(cAliasLif)->C5_ZDTREJE
			aDados1[10]	:=	(cAliasLif)->TOTAL
			aDados1[11]	:=	StrTran((cAliasLif)->C5_ZMOTREJ,"- - ","")			// Retirar quando houver
			aDados1[12]	:=	(cAliasLif)->A1_PRICOM
			aDados1[13]	:=	(cAliasLif)->A1_ULTCOM
			aDados1[14]	:=	(cAliasLif)->A1_VACUM
			aDados1[15]	:= 	(cAliasLif)->A1_MCOMPRA
			aDados1[16]	:=	If(!Empty(aRetRes),aRetRes[1],0)
			aDados1[17]	:=	If(!Empty(aRetRes),aRetRes[2],0)
			aDados1[18] := U_STFSXRES((cAliasLif)->C5_NUM)
			aDados1[19] := (cAliasLif)->C5_CONDPAG

			If MV_PAR09 = 2
				aDados1[19] :=  (cAliasLif)->C5_ZBLOQ
			EndIf

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())

		End

	EndIf

	oReport:SkipLine()

Return oReport

Static Function RetRes(_cPedido)
	Local aRetRes	:= {0,0}
	Local nSaldoSC6	:= 0
	Local nRes		:= 0

	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6")+_cPedido))
	Do While SC6->C6_FILIAL + SC6->C6_NUM = xFilial("SC6")+_cPedido .And. ! SC6->(Eof())

		If AllTrim(SC6->C6_BLQ) == "R"             //os duplicada 150413 abre
			SC6->(DbSkip())
			Loop
		EndIf

		nSaldoSC6 := U_STSLDSC6(SC6->(RECNO()))
		If nSaldoSC6 <= 0
			SC6->(DbSkip())
			Loop
		EndIf

		nRes := SC6->(U_STGetRes(C6_NUM+C6_ITEM,C6_PRODUTO,cFilAnt))

		If ! Empty(nRes)
			aRetRes[1] += 1
			aRetRes[2] += nRes
		EndIf

		SC6->(DbSkip())
	EndDo


Return(aRetRes)


Static Function XStQuery()

	Local cQuery      := ' '

	cQuery := ""
	cQuery += " SELECT C5_NUM, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, A1_COD, A1_CGC, A1_NOME, A1_PRICOM, A1_ULTCOM, A1_VACUM, A1_MCOMPRA, A3_COD, A3_NOME, C5_ZDTREJE, C5_ZMOTREJ, C5_CONDPAG, " + Chr(13) + Chr(10)
	cQuery += " ROUND(SUM(TOTAL),2) TOTAL

	If MV_PAR09 = 2
		cQuery += " , case when c5_zbloq = '1' then 'Comercial'  when c5_zbloq = '2' then 'Financeiro' ELSE ' ' end C5_ZBLOQ  " + Chr(13) + Chr(10)
	EndIf

	cQuery += " FROM ( " + Chr(13) + Chr(10)
	cQuery += " SELECT C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_ZMOTREJ, C5_CONDPAG, A1_COD, A1_CGC, A1_NOME, A1_VACUM, A1_MCOMPRA, A3_COD, A3_NOME,  " + Chr(13) + Chr(10)
	cQuery += " SUBSTR(C5_EMISSAO,7,2)||'/'||SUBSTR(C5_EMISSAO,5,2)||'/'||SUBSTR(C5_EMISSAO,1,4) C5_EMISSAO,  " + Chr(13) + Chr(10)
	cQuery += " CASE WHEN A1_PRICOM IS NULL THEN ' ' ELSE SUBSTR(A1_PRICOM ,7,2)||'/'||SUBSTR(A1_PRICOM ,5,2)||'/'||SUBSTR(A1_PRICOM ,1,4) END A1_PRICOM,   " + Chr(13) + Chr(10)
	cQuery += " CASE WHEN A1_ULTCOM IS NULL THEN ' ' ELSE SUBSTR(A1_ULTCOM ,7,2)||'/'||SUBSTR(A1_ULTCOM ,5,2)||'/'||SUBSTR(A1_ULTCOM ,1,4) END A1_ULTCOM,   " + Chr(13) + Chr(10)
	cQuery += " CASE WHEN C5_ZDTREJE = ' '  THEN ' ' ELSE SUBSTR(C5_ZDTREJE,7,2)||'/'||SUBSTR(C5_ZDTREJE,5,2)||'/'||SUBSTR(C5_ZDTREJE,1,4) END C5_ZDTREJE,  " + Chr(13) + Chr(10)
	cQuery += " (C9_QTDLIB * C9_PRCVEN) TOTAL

	If MV_PAR09 = 2
		cQuery += " ,C5_ZBLOQ  " + Chr(13) + Chr(10) "
	EndIf

	cQuery += " FROM " + RetSqlName("SC5'") + " SC5   " + Chr(13) + Chr(10)
	cQuery += " INNER JOIN ( SELECT * FROM " + RetSqlName("SC6") + " ) SC6 ON SC6.D_E_L_E_T_ = ' ' AND SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_FILIAL = SC5.C5_FILIAL  " + Chr(13) + Chr(10)
	cQuery += " INNER JOIN ( SELECT * FROM " + RetSqlName("SC9") + " ) SC9 ON SC9.D_E_L_E_T_ = ' ' AND SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.C9_BLCRED =

	If MV_PAR09 = 1
		cQuery += " 	'09'
	Else
		cQuery += " 	'01'
	EndIf

	cQuery += " 	 AND SC6.C6_FILIAL = SC9.C9_FILIAL  " + Chr(13) + Chr(10)
	cQuery += " LEFT JOIN ( SELECT * FROM " + RetSqlName("SA3") + " ) SA3 ON SA3.D_E_L_E_T_ = ' ' AND SA3.A3_COD = SC5.C5_VEND2 AND SA3.A3_FILIAL =  '" + xFilial("SA3") + "'  " + Chr(13) + Chr(10)
	cQuery += " INNER JOIN " + Chr(13) + Chr(10)
	cQuery += " ( " + Chr(13) + Chr(10)
	cQuery += " SELECT A1_COD, A1_LOJA, A1_CGC, A1_NOME, " + Chr(13) + Chr(10)
	cQuery += " (SELECT MIN(A1_PRICOM)  FROM " + RetSqlName("SA1") + " PRICOM  WHERE PRICOM.A1_COD  = SA1.A1_COD AND A1_PRICOM  <> ' ' AND PRICOM.D_E_L_E_T_  = ' ' GROUP BY A1_COD) A1_PRICOM, "  + Chr(13) + Chr(10)
	cQuery += " (SELECT MAX(A1_ULTCOM)  FROM " + RetSqlName("SA1") + " ULTCOM  WHERE ULTCOM.A1_COD  = SA1.A1_COD AND A1_ULTCOM  <> ' ' AND ULTCOM.D_E_L_E_T_  = ' ' GROUP BY A1_COD) A1_ULTCOM, "  + Chr(13) + Chr(10)
	cQuery += " (SELECT SUM(A1_MCOMPRA) FROM " + RetSqlName("SA1") + " MCOMPRA WHERE MCOMPRA.A1_COD = SA1.A1_COD AND A1_MCOMPRA <> 0   AND MCOMPRA.D_E_L_E_T_ = ' ' GROUP BY A1_COD) A1_MCOMPRA, " + Chr(13) + Chr(10)
	cQuery += " (SELECT SUM(A1_VACUM)   FROM " + RetSqlName("SA1") + " VACUM   WHERE VACUM.A1_COD   = SA1.A1_COD AND A1_VACUM   <> 0   AND VACUM.D_E_L_E_T_   = ' ' GROUP BY A1_COD) A1_VACUM "    + Chr(13) + Chr(10)
	cQuery += " FROM " + RetSqlName("SA1") + " SA1 " + Chr(13) + Chr(10)
	cQuery += " WHERE A1_FILIAL = '" + xFilial("SA1") + "' " + Chr(13) + Chr(10)
	cQuery += " AND D_E_L_E_T_ = ' '  " + Chr(13) + Chr(10)
	cQuery += " ) DADOSSA1 ON DADOSSA1.A1_COD = SC5.C5_CLIENTE AND DADOSSA1.A1_LOJA = SC5.C5_LOJACLI " + Chr(13) + Chr(10)
	cQuery += " WHERE  SC5.D_E_L_E_T_   = ' '  " + Chr(13) + Chr(10)
	cQuery += " AND SC5.C5_EMISSAO BETWEEN  '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' " + Chr(13) + Chr(10)
	cQuery += " AND SC5.C5_FILIAL   = '" + xFilial("SC5") + "'" + Chr(13) + Chr(10)
	cQuery += " AND SC5.C5_NOTA NOT LIKE '%XXX%'  " + Chr(13) + Chr(10)
	cQuery += " AND SC5.C5_VEND2 BETWEEN  '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + Chr(13) + Chr(10)
	cQuery += " AND SC5.C5_CLIENTE BETWEEN  '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " + Chr(13) + Chr(10)
	cQuery += " ) TAB " + Chr(13) + Chr(10)
	cQuery += " GROUP BY C5_NUM, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, A1_COD, A1_CGC, A1_NOME, A1_PRICOM, A1_ULTCOM, A1_VACUM, A1_MCOMPRA, A3_COD, A3_NOME, C5_ZDTREJE, C5_ZMOTREJ, C5_CONDPAG

	If MV_PAR09 = 2
		cQuery += " ,C5_ZBLOQ " + Chr(13) + Chr(10)
	EndIf

	cQuery += " ORDER BY A1_COD " + Chr(13) + Chr(10)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
