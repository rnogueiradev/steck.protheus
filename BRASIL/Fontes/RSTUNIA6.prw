#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"


 /*/{Protheus.doc} RSTUNIA6()
    (long_description)
    Relatório Unicon
    @type  Function
    @author user
    Valdemir Rabelo - SigaMat
    @since date
    04/12/2019
    @example
	u_RSTUNIA6()
/*/
*-----------------------------*
User Function RSTUNIA6()
	*-----------------------------*
	Local   oReport
	Local   cQryTMP      := ""
	Private cPerg 		 := "RSTUNIA006"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos     := SUBSTR(cTime, 4, 2)
	Private cSegundos    := SUBSTR(cTime, 7, 2)
	Private cAliasLif    := cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader   := .F.
	Private lXmlEndRow   := .F.
	Private cPergTit 	 := cAliasLif

	U_ARPutSx1(cPerg, "01", "Vendedor de:"		        ,"MV_PAR01","mv_ch1", "C", 06, 0, "G",""	,'SA3' 	,"")
	U_ARPutSx1(cPerg, "02", "Vendedor Ate:"	            ,"MV_PAR02","mv_ch2", "C", 06, 0, "G",""	,'SA3' 	,"")
	U_ARPutSx1(cPerg, "03", "Da Emissao:"		        ,"MV_PAR03","mv_ch3", "D", 08, 0, "G","" ,""	 	,"")
	U_ARPutSx1(cPerg, "04", "Até a Emissao:"	        ,"MV_PAR04","mv_ch4", "D", 08, 0, "G","" ,""	 	,"")
	U_ARPutSx1(cPerg, "05", "Analítico(A) Sintetico(S)" ,"MV_PAR05","mv_ch5", "C", 01, 0, "G",""	,"" 	,"")
	U_ARPutSx1(cPerg, "06", "Supervisor de:"		    ,"MV_PAR06","mv_ch6", "C", 06, 0, "G",""	,'SA3' 	,"")
	U_ARPutSx1(cPerg, "07", "Supervisor Ate:"	        ,"MV_PAR07","mv_ch7", "C", 06, 0, "G",""	,'SA3' 	,"")

	oReport		:= ReportDef()
	 oReport:PrintDialog()

	if ExistTab("PP7TMP")
		cQryTMP := "DROP TABLE PP7TMP"
		nResult := TcSqlExec(cQryTMP)
		if nResult < 0
			FWMsgRun(,{|| sleep(3000)},"Informativo","Ocorreu um problema ao excluir a tabela: PP7TMP")
			Return
		Endif
	Endif

	if ExistTab("PP8TMP")
		cQryTMP := "DROP TABLE PP8TMP"
		nResult := TcSqlExec(cQryTMP)
		if nResult < 0
			FWMsgRun(,{|| sleep(3000)},"Informativo","Ocorreu um problema ao excluir a tabela: PP8TMP")
			Return
		Endif		 
	Endif
Return




Static Function ReportDef()
	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"Relatório Unicons-Agenda",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório para análise dos orçamentos")

	Pergunte(cPerg,.T.)

	oSection := TRSection():New(oReport,"Relatório Unicons-Agenda",{"PP7"})

	If MV_PAR05=="S"

		TRCell():New(oSection,"01",,"VENDEDOR"				,,06,.F.,)
		TRCell():New(oSection,"02",,"NOME"					,,40,.F.,)
		TRCell():New(oSection,"03",,"VALOR" 				,"@E 99,999,999.99",14)
		TRCell():New(oSection,"04",,"ORCAMENTOS" 			,"@E 99,999,999.99",14)
		TRCell():New(oSection,"05",,"VIROU PEDIDO"			,"@E 99,999,999.99",14)
		TRCell():New(oSection,"12",,"VLR VP" 				,"@E 99,999,999.99",14)
		TRCell():New(oSection,"06",,"CANCELADOS"			,"@E 99,999,999.99",14)
		TRCell():New(oSection,"13",,"VVL CAN" 				,"@E 99,999,999.99",14)
		TRCell():New(oSection,"07",,"ABERTOS"				,"@E 99,999,999.99",14)
		TRCell():New(oSection,"14",,"VVL ABER" 				,"@E 99,999,999.99",14)
		TRCell():New(oSection,"08",,"TOTAL INTERAÇÕES"		,"@E 99,999,999.99",14)
		TRCell():New(oSection,"09",,"SEM INTERAÇÃO"			,"@E 99,999,999.99",14)
		TRCell():New(oSection,"10",,"VENCIDAS"				,"@E 99,999,999.99",14)
		TRCell():New(oSection,"11",,"A VENCER"				,"@E 99,999,999.99",14)

	Else

		TRCell():New(oSection,"01",,"FILIAL"				,,02,.F.,)
		TRCell():New(oSection,"02",,"ORÇAMENTO"			    ,,06,.F.,)
		TRCell():New(oSection,"03",,"EMISSAO"				,,20,.F.,)
		TRCell():New(oSection,"04",,"CLIENTE" 				,,10,.F.,)
		TRCell():New(oSection,"05",,"LOJA"	    			,,02,.F.,)
		TRCell():New(oSection,"06",,"NOME"					,,40,.F.,)
		TRCell():New(oSection,"07",,"VALOR"				    ,"@E 99,999,999.99",14)
		TRCell():New(oSection,"08",,"VIROU PEDIDO?"		    ,,03,.F.,)
		TRCell():New(oSection,"09",,"CANCELADO?"			,,03,.F.,)
		TRCell():New(oSection,"10",,"EM ABERTO?"			,,03,.F.,)
		TRCell():New(oSection,"11",,"OPERADOR"				,,10,.F.,)
		TRCell():New(oSection,"12",,"NOME OPERADOR"		    ,,50,.F.,)
		TRCell():New(oSection,"13",,"VENDEDOR"				,,10,.F.,)
		TRCell():New(oSection,"14",,"NOME VENDEDOR"		    ,,50,.F.,)

		TRCell():New(oSection,"15",,"SUPERVISOR"			,,10,.F.,)
		TRCell():New(oSection,"16",,"NOME SUPERVISOR"		,,50,.F.,)


		TRCell():New(oSection,"17",,"TOTA INTERAÇÕES"		,"@E 99,999,999.99",14)
		TRCell():New(oSection,"18",,"INTERAGIU?"			,,03,.F.,)
		TRCell():New(oSection,"19",,"VENCIDA?"				,,03,.F.,)
		TRCell():New(oSection,"20",,"A VENCER?"			    ,,03,.F.,)
		TRCell():New(oSection,"21",,"MOTIVO"				,,30,.F.,)
		TRCell():New(oSection,"22",,"OBS"					,,30,.F.,)
		TRCell():New(oSection,"23",,"PEDIDO"				,,30,.F.,)
		TRCell():New(oSection,"24",,"NOTA"					,,30,.F.,)

	EndIf

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("PP7")

Return oReport




Static Function ReportPrint(oReport)
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local aDados[2]
	Local aDados1[99]
	Local _n01:= 0
	Local _n02:= 0
	Local _n03:= 0
	Local _n04:= 0
	Local _n05:= 0
	Local _n06:= 0
	Local _nv01:= 0
	Local _nv02:= 0
	Local _nv03:= 0
	Local _nv04:= 0
	Local _nv05:= 0
	Local _nv06:= 0

	If MV_PAR05=="S"

		oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
		oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
		oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
		oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
		oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
		oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
		oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
		oSection1:Cell("08") :SetBlock( { || aDados1[08] } )
		oSection1:Cell("09") :SetBlock( { || aDados1[09] } )
		oSection1:Cell("10") :SetBlock( { || aDados1[10] } )
		oSection1:Cell("11") :SetBlock( { || aDados1[11] } )
		oSection1:Cell("12") :SetBlock( { || aDados1[12] } )
		oSection1:Cell("13") :SetBlock( { || aDados1[13] } )
		oSection1:Cell("14") :SetBlock( { || aDados1[14] } )

	Else

		oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
		oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
		oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
		oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
		oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
		oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
		oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
		oSection1:Cell("08") :SetBlock( { || aDados1[08] } )
		oSection1:Cell("09") :SetBlock( { || aDados1[09] } )
		oSection1:Cell("10") :SetBlock( { || aDados1[10] } )
		oSection1:Cell("11") :SetBlock( { || aDados1[11] } )
		oSection1:Cell("12") :SetBlock( { || aDados1[12] } )
		oSection1:Cell("13") :SetBlock( { || aDados1[13] } )
		oSection1:Cell("14") :SetBlock( { || aDados1[14] } )
		oSection1:Cell("15") :SetBlock( { || aDados1[15] } )
		oSection1:Cell("16") :SetBlock( { || aDados1[16] } )
		oSection1:Cell("17") :SetBlock( { || aDados1[17] } )
		oSection1:Cell("18") :SetBlock( { || aDados1[18] } )
		oSection1:Cell("19") :SetBlock( { || aDados1[19] } )
		oSection1:Cell("20") :SetBlock( { || aDados1[20] } )
		oSection1:Cell("21") :SetBlock( { || aDados1[21] } )
		oSection1:Cell("22") :SetBlock( { || aDados1[22] } )
		oSection1:Cell("23") :SetBlock( { || aDados1[23] } )
		oSection1:Cell("24") :SetBlock( { || aDados1[24] } )
	EndIf


	oReport:SetTitle("PP7")// Titulo do relatório

	aFill(aDados,   nil)
	aFill(aDados1,  nil)
	oSection:Init()


	Processa({|| StQuery() },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	nReg := 0
	(cAliasLif)->( dbEval({|| nReg++},,{|| !Eof()}) )
	oReport:SetMeter(nReg)

	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			If oReport:Cancel()
				Exit
			EndIf		

			If MV_PAR05=="S"

				aDados1[01]	:=  (cAliasLif)->VENDEDOR
				aDados1[02]	:=  (cAliasLif)->NOME
				aDados1[03]	:=  (cAliasLif)->VALOR
				aDados1[04]	:=  (cAliasLif)->VIROUPED + (cAliasLif)->CANCELADOS +  (cAliasLif)->ABERTAS
				aDados1[05]	:=  (cAliasLif)->VIROUPED
				aDados1[06]	:=	(cAliasLif)->CANCELADOS
				aDados1[07]	:= 	(cAliasLif)->ABERTAS
				aDados1[08]	:= 	(cAliasLif)->INTERACOES
				aDados1[09]	:= 	(cAliasLif)->SEMINTERACOES
				aDados1[10]	:= 	(cAliasLif)->VENCIDAS
				aDados1[11]	:= 	(cAliasLif)->AVENCER
				aDados1[12]	:= 	(cAliasLif)->VLRVP
				aDados1[13]	:= 	(cAliasLif)->VVLCAN
				aDados1[14]	:= 	(cAliasLif)->VVLABER

			Else

				aDados1[01]	:=	(cAliasLif)->FILIAL
				aDados1[02]	:=	(cAliasLif)->CODIGO
				aDados1[03]	:= 	stod((cAliasLif)->EMISSAO)
				aDados1[04]	:=	(cAliasLif)->CLIENTE
				aDados1[05]	:=	(cAliasLif)->LOJA
				aDados1[06]	:=	(cAliasLif)->NOME
				aDados1[07]	:=	(cAliasLif)->VALORNET
				aDados1[08]	:= 	IIf((cAliasLif)->VIROUPEDIDO==1	,"SIM","NÃO")
				aDados1[09]	:= 	IIf((cAliasLif)->CANCELADO==1		,"SIM","NÃO")
				aDados1[10]	:= 	IIf((cAliasLif)->ABERTA==1		,"SIM","NÃO")
				aDados1[11]	:= 	(cAliasLif)->OPERADOR
				aDados1[12]	:= 	Posicione("SU7",1,xFilial("SU7")+(cAliasLif)->OPERADOR,"U7_NOME")
				aDados1[13]	:= 	(cAliasLif)->VENDEDOR
				aDados1[14]	:= 	Posicione("SA3",1,xFilial("SA3")+(cAliasLif)->VENDEDOR,"A3_NOME")
				aDados1[15]	:= 	Posicione("SA3",1,xFilial("SA3")+(cAliasLif)->VENDEDOR,"A3_SUPER")
				aDados1[16]	:= 	Posicione("SA3",1,xFilial("SA3")+aDados1[15],"A3_NOME")
				aDados1[17]	:= 	(cAliasLif)->INTERACOES
				aDados1[18]	:= 	IIf((cAliasLif)->SEMINTERACAO==1 .And. (cAliasLif)->ABERTA==1,"NÃO","")
				aDados1[19]	:= 	IIf((cAliasLif)->VENCIDA==1		,"SIM","NÃO")
				aDados1[20]	:=	IIf((cAliasLif)->AVENCER==1		,"SIM","NÃO")

				_cRet:= ' '
				If SUBSTR((cAliasLif)->MOTIVO,6,1) = '1'
					_cRet:='1=SOMENTE CUSTO'
					_n01++
					_nv01+=  (cAliasLif)->VALORNET
				ElseIf SUBSTR((cAliasLif)->MOTIVO,6,1) = '2'
					_cRet:='2=OUTRO'
					_n02++
					_nv02+=  (cAliasLif)->VALORNET
				ElseIf SUBSTR((cAliasLif)->MOTIVO,6,1) = '3'
					_cRet:='3=ITENS INCL. PEDIDO'
					_n03++
					_nv03+=  (cAliasLif)->VALORNET
				ElseIf SUBSTR((cAliasLif)->MOTIVO,6,1) = '4'
					_cRet:='4=COMP NO DISTRI'
					_n04++
					_nv04+=  (cAliasLif)->VALORNET
				ElseIf SUBSTR((cAliasLif)->MOTIVO,6,1) = '5'
					_cRet:='5=PERD CONCORRE'
					_n05++
					_nv05+=  (cAliasLif)->VALORNET
				ElseIf SUBSTR((cAliasLif)->MOTIVO,6,1) = '6'
					_cRet:='6=PERDEU COT'
					_n06++
					_nv06+=  (cAliasLif)->VALORNET
				ElseIf SUBSTR((cAliasLif)->MOTIVO,6,1) = '7'
					_cRet:='7=CANC MASSA'
				ElseIf SUBSTR((cAliasLif)->MOTIVO,6,1) = '8'
					_cRet:='8=COBRAR NOVAMEN'
				ElseIf (cAliasLif)->MOTIVO = 'SUP'
					_cRet:='SUP'
				ElseIf (cAliasLif)->MOTIVO = 'NF.'
					_cRet:='NF.'
				EndIf

				IF empty(_cRet)
					If (cAliasLif)->STATUS = '1'
						_cRet:='1=SOMENTE CUSTO'
						_n01++
						_nv01+=  (cAliasLif)->VALORNET
					ElseIf (cAliasLif)->STATUS = '2'
						_cRet:='2=OUTRO'
						_n02++
						_nv02+=  (cAliasLif)->VALORNET
					ElseIf (cAliasLif)->STATUS = '3'
						_cRet:='3=ITENS INCL. PEDIDO'
						_n03++
						_nv03+=  (cAliasLif)->VALORNET
					ElseIf (cAliasLif)->STATUS = '4'
						_cRet:='4=COMP NO DISTRI'
						_n04++
						_nv04+=  (cAliasLif)->VALORNET
					ElseIf (cAliasLif)->STATUS = '5'
						_cRet:='5=PERD CONCORRE'
						_n05++
						_nv05+=  (cAliasLif)->VALORNET
					ElseIf (cAliasLif)->STATUS = '6'
						_cRet:='6=PERDEU COT'
						_n06++
						_nv06+=  (cAliasLif)->VALORNET
					ElseIf (cAliasLif)->STATUS = '7'
						_cRet:='7=CANC MASSA'
					ElseIf (cAliasLif)->STATUS = '8'
						_cRet:='8=COBRAR NOVAMEN'
					EndIf


				Endif

				aDados1[21]	:= 	_cRet
				aDados1[22]	:= 	(cAliasLif)->OBS
				aDados1[23]	:= 	(cAliasLif)->NUMSC5
				aDados1[24]	:= 	""				//ALLTRIM(IIF((cAliasLif)->NOTA==NIL,"",(cAliasLif)->NOTA))

			EndIf

			oSection1:PrintLine()
			oReport:IncMeter()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End

		oSection1:PrintLine()
		aFill(aDados1,nil)


		If MV_PAR05=="A"
			oSection1:PrintLine()
			aFill(aDados1,nil)
			oSection1:PrintLine()
			aFill(aDados1,nil)

			aDados1[04]	:=	'Totais'
			aDados1[05]	:=	''
			//aDados1[06] := 0

			oSection1:PrintLine()
			aFill(aDados1,nil)
			aDados1[04]	:= '1=SOMENTE CUSTO'
			aDados1[05]	:= cvaltochar(_n01)
			aDados1[06] :=  _nv01

			oSection1:PrintLine()
			aFill(aDados1,nil)
			aDados1[04]	:= '2=OUTRO'
			aDados1[05]	:=  cvaltochar(_n02)
			aDados1[06] := _nv02

			oSection1:PrintLine()
			aFill(aDados1,nil)
			aDados1[04]	:= '3=ITENS INCL. PEDIDO'
			aDados1[05]	:=  cvaltochar(_n03)
			aDados1[06] :=  _nv03

			oSection1:PrintLine()
			aFill(aDados1,nil)
			aDados1[04]	:= '4=COMP NO DISTRI'
			aDados1[05]	:=  cvaltochar(_n04)
			aDados1[06] :=  _nv04

			oSection1:PrintLine()
			aFill(aDados1,nil)
			aDados1[04]	:= '5=PERD CONCORRE'
			aDados1[05]	:=  cvaltochar(_n05)
			aDados1[06] :=  _nv05

			oSection1:PrintLine()
			aFill(aDados1,nil)
			aDados1[04]	:= '6=PERDEU COT'
			aDados1[05]	:=  cvaltochar(_n06)
			aDados1[06] :=  _nv06
			oSection1:PrintLine()
			aFill(aDados1,nil)

		EndIf

		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport


 /*/{Protheus.doc} RSTUNIA6()
    (long_description)
    Rotina para montagem da query
    @type  Function
    @author user
    Valdemir Rabelo - SigaMat
    @since date
    05/12/2019
    @example
/*/
Static Function StQuery(_ccod)
	Local cQuery     := ' '
	Local cQryTMP    := ''
	Local nResult    := 0

	//cAliasLif := "RST6"

	if ExistTab("PP7TMP")
		cQryTMP := "DROP TABLE PP7TMP"
		nResult := TcSqlExec(cQryTMP)
		if nResult < 0
			FWMsgRun(,{|| sleep(3000)},"Informativo","Ocorreu um problema ao excluir a tabela: PP7TMP")
			Return
		Endif
	Endif

	if ExistTab("PP8TMP")
		cQryTMP := "DROP TABLE PP8TMP"
		nResult := TcSqlExec(cQryTMP)
		if nResult < 0
			FWMsgRun(,{|| sleep(3000)},"Informativo","Ocorreu um problema ao excluir a tabela: PP8TMP")
			Return
		Endif		 
	Endif	

	cQuery := " CREATE TABLE PP8TMP AS  " + CRLF
	cQuery += " SELECT PP7_CODIGO, PP7_PEDIDO, PP7_TRAVA, SUM(PP8_PRORC) ZVALLIC  " + CRLF
	cQuery += " FROM " + RETSQLNAME("PP7") + " A " + CRLF
	cQuery += " INNER JOIN  " + RETSQLNAME("PP8") + "  B " + CRLF
	cQuery += " ON PP8_FILIAL=PP7_FILIAL AND PP8_CODIGO=PP7_CODIGO AND B.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " WHERE A.D_E_L_E_T_ = ' ' " + CRLF
 	cQuery += " AND PP7_EMISSA BETWEEN  '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' " + CRLF
	cQuery += " GROUP BY PP7_CODIGO, PP7_PEDIDO, PP7_TRAVA " + CRLF

	nResult := TcSqlExec(cQuery)
	if nResult < 0
	   FWMsgRun(,{|| sleep(3000)},"Informativo","Ocorreu um problema na geração dos registros para o relatório.")
	   Return
	Endif
	//------------------------------------------------------------------------------------------------------------------------------------------.
	cQuery := "CREATE TABLE PP7TMP AS 		" + CRLF

	cQuery += "	SELECT PP7_FILIAL FILIAL, 	" + CRLF
	cQuery += "	PP7_CODIGO CODIGO, 			" + CRLF
	cQuery += "	PP7_CLIENT CLIENTE,			" + CRLF
	cQuery += "	PP7_LOJA LOJA,				" + CRLF
	cQuery += "	A1_NOME NOME,			 	" + CRLF
	cQuery += "	1 CONTADOR,					" + CRLF
	cQuery += "	PP7_EMISSA EMISSAO, 		" + CRLF
	cQuery += "	PP7_REPRES OPERADOR,	 	" + CRLF
	cQuery += "	(CASE						" + CRLF
	cQuery += "		WHEN PP7_PEDIDO<>' ' THEN 1	 " + CRLF
	cQuery += "		ELSE 0						 " + CRLF
	cQuery += "  END) VIROUPEDIDO,				 " + CRLF
	cQuery += "  (CASE							 " + CRLF
	cQuery += "		WHEN PP7_TRAVA='3' THEN 1	 " + CRLF
	cQuery += "		ELSE 0						 " + CRLF
	cQuery += "	 END) CANCELADO,				 " + CRLF
	cQuery += "	 (CASE							 " + CRLF
	cQuery += "		WHEN PP7_TRAVA IN ('1',		 " + CRLF
	cQuery += "                '2')				 " + CRLF
	cQuery += "  	AND PP7_PEDIDO=' ' THEN 1	 " + CRLF
	cQuery += "		ELSE 0						 " + CRLF
	cQuery += "	 END) ABERTA,					 " + CRLF
	cQuery += "	 PP7_VEND VENDEDOR,  (SELECT COUNT(*)	 				       " + CRLF
	cQuery += "  					  FROM  "+RetSqlName("Z1Y")+"  Z1Y	       " + CRLF
	cQuery += "						  WHERE Z1Y.D_E_L_E_T_=' '			       " + CRLF
	cQuery += " 					   AND Z1Y_FILIAL=PP7.PP7_FILIAL	 	   " + CRLF
	cQuery += " 					   AND Z1Y_NUM=PP7.PP7_CODIGO) INTERACOES, " + CRLF
	cQuery += "	 (CASE							 " + CRLF
	cQuery += "	 WHEN (PP7.PP7_TRAVA='3'			 " + CRLF
	cQuery += "   OR PP7.PP7_PEDIDO<>' ') THEN 0 " + CRLF
	cQuery += "  WHEN							 " + CRLF
	cQuery += "       ( SELECT COUNT(*)			 " + CRLF
	cQuery += " 		FROM  "+RetSqlName("Z1Y")+"  Z1Y " + CRLF
	cQuery += " 		WHERE Z1Y.D_E_L_E_T_=' '		 " + CRLF
	cQuery += "  		 AND Z1Y_FILIAL=PP7.PP7_FILIAL	 " + CRLF
	cQuery += "  		 AND Z1Y_NUM=PP7.PP7_CODIGO		 " + CRLF
	cQuery += "  		 AND PP7_TRAVA IN ('1','2')		 " + CRLF
	cQuery += "  		 AND PP7_PEDIDO=' ')=0 THEN 1	 " + CRLF
	cQuery += "  ELSE 0							 " + CRLF
	cQuery += "  END) SEMINTERACAO,				 " + CRLF
	cQuery += "  (CASE							 " + CRLF
	cQuery += "	 WHEN							 " + CRLF
	cQuery += " 	(SELECT MAX(Z1Y_RETORN)		 " + CRLF
	cQuery += " 	 FROM  "+RetSqlName("Z1Y")+"  Z1Y " + CRLF
	cQuery += " 	 WHERE Z1Y.D_E_L_E_T_=' '		  " + CRLF
	cQuery += " 	  AND Z1Y_FILIAL=PP7.PP7_FILIAL	  " + CRLF
	cQuery += " 	  AND Z1Y_NUM=PP7.PP7_CODIGO	  " + CRLF
	cQuery += " 	  AND Z1Y_MOTIVO='8') < '"+DTOS(Date())+"' THEN 1 " + CRLF
	cQuery += " ELSE 0							 " + CRLF
	cQuery += " END) VENCIDA,					 " + CRLF
	cQuery += " ' ' MOTIVO,						 " + CRLF
	cQuery += " PP7_STATUS STATUS,				 " + CRLF
	cQuery += " PP7_PEDIDO NUMSC5,				 " + CRLF
	cQuery += " PP7_NOTAS NOTA,					 " + CRLF
	cQuery += " (CASE							 " + CRLF
	cQuery += " WHEN NVL(						 " + CRLF
	cQuery += "           ( SELECT NVL(Z1Y_OBS, ' ')	 " + CRLF
	cQuery += " 			FROM "+RetSqlName("Z1Y")+" Z1Y	 " + CRLF
	cQuery += " 			WHERE Z1Y.D_E_L_E_T_=' '		 " + CRLF
	cQuery += " 			 AND Z1Y_FILIAL=PP7.PP7_FILIAL	 " + CRLF
	cQuery += " 			 AND Z1Y_NUM=PP7.PP7_CODIGO		 " + CRLF
	cQuery += " 			 AND Z1Y.R_E_C_N_O_ =			 " + CRLF
	cQuery += " 			 (SELECT MAX(R_E_C_N_O_)		 " + CRLF
	cQuery += " 			  FROM Z1Y010 TZY				 " + CRLF
	cQuery += " 			  WHERE TZY.D_E_L_E_T_=' '		 " + CRLF
	cQuery += " 			  AND TZY.Z1Y_FILIAL=PP7.PP7_FILIAL " + CRLF
	cQuery += " 			  AND TZY.Z1Y_NUM=PP7.PP7_CODIGO) ),' ') <> ' ' THEN " + CRLF
	cQuery += " (SELECT NVL(Z1Y_OBS, ' ') " + CRLF
	cQuery += "  FROM "+RetSqlName("Z1Y")+" Z1Y " + CRLF
	cQuery += "  WHERE Z1Y.D_E_L_E_T_=' ' 		" + CRLF
	cQuery += "   AND Z1Y_FILIAL=PP7.PP7_FILIAL " + CRLF
	cQuery += "   AND Z1Y_NUM=PP7.PP7_CODIGO 	" + CRLF
	cQuery += "   AND Z1Y.R_E_C_N_O_ = 			" + CRLF
	cQuery += " 	(SELECT MAX(R_E_C_N_O_) 	" + CRLF
	cQuery += " 	 FROM  "+RetSqlName("Z1Y")+" TZY " + CRLF
	cQuery += " 	 WHERE TZY.D_E_L_E_T_=' ' " + CRLF
	cQuery += " 	  AND TZY.Z1Y_FILIAL=PP7.PP7_FILIAL " + CRLF
	cQuery += " 	  AND TZY.Z1Y_NUM=PP7.PP7_CODIGO) ) " + CRLF
	cQuery += " ELSE ' ' " + CRLF
	cQuery += " END) OBS, " + CRLF
	cQuery += " (CASE " + CRLF
	cQuery += " WHEN " + CRLF
	cQuery += "        (SELECT MAX(Z1Y_RETORN) 			 " + CRLF
	cQuery += "         FROM  "+RetSqlName("Z1Y")+"  Z1Y " + CRLF
	cQuery += " 		WHERE Z1Y.D_E_L_E_T_=' ' 		 " + CRLF
	cQuery += " 		 AND Z1Y_FILIAL=PP7.PP7_FILIAL 	 " + CRLF
	cQuery += "          AND Z1Y_NUM=PP7.PP7_CODIGO 	 " + CRLF
	cQuery += "           AND Z1Y_MOTIVO='8') >= '"+DTOS(Date())+"' THEN 1 " + CRLF
	cQuery += " ELSE 0 " + CRLF
	cQuery += "	END) AVENCER " + CRLF
	cQuery += "	FROM PP7010 PP7 " + CRLF
	cQuery += "	LEFT JOIN  "+RetSqlName("SA1")+"  A1  " + CRLF
	cQuery += " ON A1.A1_COD=PP7.PP7_CLIENT " + CRLF
	cQuery += "	AND A1.A1_LOJA=PP7.PP7_LOJA " + CRLF
	cQuery += "	INNER JOIN  "+RetSqlName("SA3") + " SA3  " + CRLF
   	cQuery += "	ON SA3.D_E_L_E_T_ = ' ' AND PP7_VEND = A3_COD AND A3_SUPER BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' " + CRLF
	cQuery += "	WHERE PP7.D_E_L_E_T_= ' ' " + CRLF
  	cQuery += "	 AND A1.D_E_L_E_T_= ' ' " + CRLF
  	cQuery += "	 AND PP7_EMISSA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' " + CRLF
  	cQuery += "  AND PP7_VEND BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += "	ORDER BY VENDEDOR, " + CRLF
    cQuery += "	  FILIAL, " + CRLF
    cQuery += "	  CODIGO" + CRLF
	
	nResult := TcSqlExec(cQuery)
	if nResult < 0
	   FWMsgRun(,{|| sleep(3000)},"Informativo","Ocorreu um problema na geração dos registros para o relatório.")
	   Return
	Endif
	
	cQuery := ""
	If MV_PAR05=="S"
		cQuery += " SELECT VENDEDOR, NVL(A3_NOME,' ') NOME, SUM(VALORNET) VALOR, SUM(CONTADOR) ORCAMENTOS,
		cQuery += " SUM(PEDIDO) VLRVP, SUM(CANCEL) VVLCAN, SUM(ABERT) VVLABER, "
		cQuery += " SUM(VIROUPEDIDO) VIROUPED, SUM(CANCELADO) CANCELADOS, SUM(ABERTA) ABERTAS, "
		cQuery += " SUM(INTERACOES) INTERACOES, SUM(SEMINTERACAO) SEMINTERACOES, SUM(VENCIDA) VENCIDAS, "
		cQuery += " SUM(AVENCER) AVENCER "
		cQuery += " FROM ( "
	EndIf

	cQuery += " SELECT PP7_PEDIDO,(CASE WHEN PP7_PEDIDO<>' ' THEN ZVALLIC ELSE 0 END) PEDIDO, ZVALLIC VALORNET, " + CRLF
	cQuery += "        (CASE WHEN PP7_TRAVA='3'   THEN ZVALLIC ELSE 0 END) CANCEL," + CRLF
	cQuery += "        (CASE WHEN PP7_TRAVA IN ('1','2') AND PP7_PEDIDO=' ' THEN ZVALLIC ELSE 0 END) ABERT," + CRLF
	cQuery += " A.* FROM PP7TMP A		" + CRLF
	cQuery += " INNER JOIN PP8TMP B		" + CRLF
	cQuery += " ON B.PP7_CODIGO=A.CODIGO" + CRLF 

	If MV_PAR05=="S"
		cQuery += " ) AAA "
		cQuery += " LEFT JOIN "+RetSqlName("SA3")+" A3 "
		cQuery += " ON A3.A3_COD=VENDEDOR AND A3.D_E_L_E_T_=' ' "
		cQuery += " GROUP BY VENDEDOR, A3_NOME "
	EndIf

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()


Static Function ExistTab(pTabela)
	Local cQry   := ""
	Local nResut := 0

	cQry := "SELECT count(*) REG  FROM user_tables where table_name = '"+pTabela+"'"

	if Select("TMPTAB") > 0
	   TMPTAB->( dbCloseArea() )
	endif
	TcQuery cQry new Alias "TMPTAB"
	
	nResut := TMPTAB->REG

	if Select("TMPTAB") > 0
	   TMPTAB->( dbCloseArea() )
	endif

Return nResut