#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRSTFAT33	บAutor  ณRenato Nogueira     บ Data ณ  25/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio utilizado para calcular a provisใo de estoque     บฑฑ
ฑฑบ          ณ									    				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RSTFAT33()

	Local oReport

	PutSx1("RSTFAT33", "01","Produto de?" 				,"","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1("RSTFAT33", "02","Produto ate?"				,"","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1("RSTFAT33", "03","Grupo de?"	  				,"","","mv_ch3","C",4,0,0,"G" ,"","SBM","","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1("RSTFAT33", "04","Grupo ate?"  				,"","","mv_ch4","C",4,0,0,"G" ,"","SBM","","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1("RSTFAT33", "05","Mes?"			    		,"","","mv_ch5","C",2,0,0,"G" ,"","","",""	  ,"mv_par05","","","","","","","","","","","","","","","","")
	PutSx1("RSTFAT33", "06","Ano?"			    		,"","","mv_ch6","C",4,0,0,"G" ,"","","",""	  ,"mv_par06","","","","","","","","","","","","","","","","")
	PutSx1("RSTFAT33", "07","% Crescimento imp?"   		,"","","mv_ch7","N",3,0,0,"G" ,"","","",""	  ,"mv_par07","","","","","","","","","","","","","","","","")
	PutSx1("RSTFAT33", "08","% Crescimento nac?"   		,"","","mv_ch8","N",3,0,0,"G" ,"","","",""	  ,"mv_par08","","","","","","","","","","","","","","","","")
	PutSx1("RSTFAT33", "09","Positivo(P) Negativo(N)"   ,"","","mv_ch9","C",1,0,0,"G" ,"","","",""	  ,"mv_par09","","","","","","","","","","","","","","","","")
//PutSx1("RSTFAT33", "08","Quebra por filial (S/N)"	,"","","mv_ch8","C",1,0,0,"G" ,"","","",""	  ,"mv_par08","","","","","","","","","","","","","","","","")

	oReport		:= ReportDef()
	oReport		:PrintDialog()

Return

Static Function ReportDef()


	Local nX:= 0
	Local oReport
	Local oSection
	Static _aArmaz	:= {}
	Static _nTam	:= 0

	//MV_PAR08	:= "N"

	oReport := TReport():New("RSTFAT33","RELATำRIO DE PROVISรO","RSTFAT33",{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de provisใo de estoque.")

	Pergunte("RSTFAT33",.F.)

	oSection := TRSection():New(oReport,"PRODUTOS",{"SB1"})

	DbSelectArea("SX5")
	SX5->(DbSetOrder(1))
	SX5->(DbGoTop())
	SX5->(DbSeek(xFilial("SX5")+"90"))

	While SX5->(!Eof()) .And. SX5->X5_TABELA=="90"

		AADD(_aArmaz,{AllTrim(SX5->X5_CHAVE),AllTrim(SX5->X5_DESCRI)})

		SX5->(DbSkip())
	EndDo
/*
If MV_PAR08=="S"
	TRCell():New(oSection,"FILIAL" 		,"SB1","FILIAL"				 			   	    	,"@!",02)
EndIf
*/
	TRCell():New(oSection,"COD" 		,"SB1","CODIGO"				 			   	    	,"@!",15)
	TRCell():New(oSection,"DESC" 		,"SB1","DESCRICAO"			 			   	    	,"@!",50)
	TRCell():New(oSection,"GRP" 		,"SB1","GRUPO"				 			   	    	,"@!",4)
	TRCell():New(oSection,"DESGRP" 		,"SB1","DESC GRUPO"				 			   	    ,"@!",45)
	TRCell():New(oSection,"CLAPROD" 	,"SB1","CLASSIFICACAO"			 			   	    ,"@!",1)
	TRCell():New(oSection,"TIPO" 		,"SB1","TIPO"					 			   	    ,"@!",2)
	TRCell():New(oSection,"AGRUP" 		,"SB1","AGRUPAMENTO"			 			   	    ,"@!",55)
	TRCell():New(oSection,"APROPRI" 	,"SB1","APROPRIACAO"			 			   	    ,"@!",1)
	TRCell():New(oSection,"DTCADPRO"	,"SB1","DT CAD PRODUTO"		 			   	    	,"@!",10)
	TRCell():New(oSection,"SALDO" 		,"SB1","SALDO"				 			   	    	,"@E 99,999,999,999.99",14)
	TRCell():New(oSection,"CUSTOUN"		,"SB1","CUSTO MEDIO UN"		 			   	    	,"@E 99,999,999,999.99",14)
	TRCell():New(oSection,"VLREST"		,"SB1","VALOR ESTOQUE"		 			   	    	,"@E 99,999,999,999.99",14)
	TRCell():New(oSection,"CONS" 		,"SB1","CONSUMO"			 			   	    	,"@E 99,999,999,999.99",14)
	TRCell():New(oSection,"PRJCONS" 	,"SB1","CONSUMO PROJETADO"	 			   	    	,"@E 99,999,999,999.99",14)
	TRCell():New(oSection,"GIRO"		,"SB1","GIRO ESTOQUE"		 			   	    	,"@E 99,999,999,999.99",14)
	TRCell():New(oSection,"SEMGIRO"		,"SB1","SEM GIRO"			 			   	    	,"@E 99,999,999,999.99",14)
	TRCell():New(oSection,"EXC50"		,"SB1","EXCEDENTE 50 - 2 ANO" 			   	    	,"@E 99,999,999,999.99",14)
	TRCell():New(oSection,"EXC100"		,"SB1","EXCEDENTE 100 - 3 ANO" 			   	    	,"@E 99,999,999,999.99",14)
	TRCell():New(oSection,"PROVISAO"	,"SB1","PROVISAO" 			 			  	    	,"@E 99,999,999,999.99",14)

	For nX:=1 To Len(_aArmaz)

		TRCell():New(oSection,_aArmaz[nX][1]	,"SB1","SALDO ARM. "+_aArmaz[nX][1] 			  	    	,"@E 99,999,999,999.99",14)

	Next

	_nTam	:= len(oSection:aCell)

	oSection:SetHeaderSection(.T.)
	oSection:Setnofilter("SB1")

Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local _cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"
	Local _cAlia1 	:= "QRYCON"
	Local aDados[_nTam+1]
	Local dData		:= ""
	Local nX		:= 0
	Local _aDadosAd	:= {}
	Local _cCampo	:= ""
	Local nDados	:= 0
	Local nTamArray	:= 19
	Local dFecham 	:= GetMv("MV_ULMES")
	Private nProx	:= 1
	Private _nQryC  := ""
	Private _nConsT := 0
	Private _nConsC := 0
	Private _dDtInc := Ctod(Space(8))

//MV_PAR08	:= "N"

	oSection:Cell("COD")   		:SetBlock( { || aDados[1] } )
	oSection:Cell("DESC")  		:SetBlock( { || aDados[2] } )
	oSection:Cell("GRP")  		:SetBlock( { || aDados[3] } )
	oSection:Cell("DESGRP")  	:SetBlock( { || aDados[4] } )
	oSection:Cell("CLAPROD")  	:SetBlock( { || aDados[5] } )
	oSection:Cell("TIPO")	  	:SetBlock( { || aDados[6] } )
	oSection:Cell("AGRUP")  	:SetBlock( { || aDados[7] } )
	oSection:Cell("CONS")	  	:SetBlock( { || aDados[8] } )
	oSection:Cell("PRJCONS")  	:SetBlock( { || aDados[9] } )
	oSection:Cell("SALDO")  	:SetBlock( { || aDados[10] } )
	oSection:Cell("DTCADPRO")  	:SetBlock( { || aDados[11] } )
	oSection:Cell("CUSTOUN")  	:SetBlock( { || aDados[12] } )
	oSection:Cell("GIRO")  		:SetBlock( { || aDados[13] } )
	oSection:Cell("VLREST")  	:SetBlock( { || aDados[14] } )
	oSection:Cell("SEMGIRO")  	:SetBlock( { || aDados[15] } )
	oSection:Cell("EXC50")  	:SetBlock( { || aDados[16] } )
	oSection:Cell("EXC100")  	:SetBlock( { || aDados[17] } )
	oSection:Cell("APROPRI")  	:SetBlock( { || aDados[18] } )
	oSection:Cell("PROVISAO")  	:SetBlock( { || aDados[19] } )
/*
If MV_PAR08=="S"
	oSection:Cell("FILIAL")		:SetBlock( { || aDados[20] } )
	nTamArray	:= 20
EndIf
*/
	For nX:=1 To Len(_aArmaz)

		oSection:Cell(_aArmaz[nX][1])  	:SetBlock( { || aDados[  U_COUNTAR(nTamArray)   ] } )

		AADD(_aDadosAd,{nTamArray+nX})

	Next
	oReport:SetTitle("Lista de produtos")// Titulo do relat๓rio

	If !MV_PAR05 $ '01--02--03--04--05--06//07--08--09--10--11--12'
		MsgStop("Somente Meses de 01 a 12 ใo validos !!! Verifique !!!")
		Return
	EndIf

	If val(mv_par06) > year(dDatabase)+10 .or. val(mv_par06) < year(dDatabase)-10
		MsgStop("Ano invalido !!! Verifique !!!")
		Return
	EndIf
/*
If !MV_PAR08 $ 'SN'
	MsgStop("Coloque S ou N no parโmetro de quebra por filial!")
	Return
EndIf
*/

	_cDtFim := LastDay(ctod("01/"+strzero(val(mv_par05))+"/"+mv_par06) )
	_cDtIni := _cDtFim - 364

	If _cDtFim	> dFecham
		MsgStop("Aten็ใo, a data solicitada ้ maior que a data do ๚ltimo fechamento")
		Return
	EndIf

	_cPer01 := substr(dtos(_cDtFim),1,6)
	_cPer02 := substr(dtos(_cDtFim-(32*1)),1,6)
	_cPer03 := substr(dtos(_cDtFim-(32*2)),1,6)
	_cPer04 := substr(dtos(_cDtFim-(32*3)),1,6)
	_cPer05 := substr(dtos(_cDtFim-(32*4)),1,6)
	_cPer06 := substr(dtos(_cDtFim-(32*5)),1,6)
	_cPer07 := substr(dtos(_cDtFim-(32*6)),1,6)
	_cPer08 := substr(dtos(_cDtFim-(32*7)),1,6)
	_cPer09 := substr(dtos(_cDtFim-(32*8)),1,6)
	_cPer10 := substr(dtos(_cDtFim-(32*9)),1,6)
	_cPer11 := substr(dtos(_cDtFim-(32*10)),1,6)
	_cPer12 := substr(dtos(_cDtFim-(32*11)),1,6)

	dData	:= Lastday(CTOD("01/"+MV_PAR05+"/"+MV_PAR06))

	_cQuery := " SELECT "


	_cQuery += " CODIGO,B1_GRUPO,B1_DESC,B1_TIPO,B1_DATREF, BM_GRUPO, BM_DESC, B1_CLAPROD, B1_UM, BM_XAGRUP, B1_APROPRI, "
//_cQuery += " NVL(ROUND(MAX(CASE WHEN B2_CM1 > 0 THEN B2_CM1 ELSE (CASE WHEN B1_CUSTD > 0 THEN B1_CUSTD ELSE 0.01 END) END),2),0) AS CUSTO , " Substituido pelo custo da B9 para ficar igual ao relat๓rio de posi็ใo de estoque - Solicita็ใo j้ssica.menezes - 07/05/14
	_cQuery += " NVL((SELECT SUM( ROUND(SUM(CASE WHEN (B9_VINI1)<>0 THEN B9_VINI1 ELSE 0 END),2) / ROUND(SUM(CASE WHEN (B9_QINI)<>0 THEN B9_QINI ELSE 0 END),2) ) AS CUSTO FROM "+RetSqlName("SB9")+" B9 WHERE B9.D_E_L_E_T_=' ' AND B9_VINI1<>0 AND B9_QINI<>0 AND B9_DATA = '"+DTOS(dData)+"' AND B9.B9_COD=DDDD.CODIGO GROUP BY B9_COD),0) AS CUSTO, "
	_cQuery += " NVL((SELECT DISTINCT SUM(B9_QINI) AS SALDO FROM "+RetSqlName("SB9")+" B9 WHERE B9.D_E_L_E_T_=' ' AND B9_DATA = '"+DTOS(dData)+"' AND B9.B9_COD=DDDD.CODIGO GROUP BY B9_COD),0) AS SALDO, "

	For nX:=1 To Len(_aArmaz)
		_cQuery += " NVL((SELECT DISTINCT SUM(B9_QINI) AS SALDO FROM "+RetSqlName("SB9")+" B9 WHERE B9.D_E_L_E_T_=' ' AND B9_DATA = '"+DTOS(dData)+"' AND B9.B9_COD=DDDD.CODIGO AND B9.B9_LOCAL='"+_aArmaz[nX][1]+"' GROUP BY B9_COD),0) AS SALDO"+CValToChar(nX)+", "
	Next

	_cQuery += "  SUM(CONSUMO) AS TOTAL_CONSUMO, "
//_cQuery += "  SUM(CONSUMO)*1."+CVALTOCHAR(MV_PAR07)+" AS CONSUMOPROJ "
//_cQuery += " CASE WHEN (B1_CLAPROD='I') THEN SUM(CONSUMO)*"+IIF(MV_PAR09=="N","-","")+"1."+CVALTOCHAR(MV_PAR07)+" ELSE SUM(CONSUMO)*"+IIF(MV_PAR09=="N","-","")+"1."+CVALTOCHAR(MV_PAR08)+" END AS CONSUMOPROJ "
	_cQuery += " CASE WHEN (B1_CLAPROD='I') THEN "+IIF(MV_PAR09=="P","SUM(CONSUMO)+SUM(CONSUMO)*"+CVALTOCHAR(MV_PAR07)+"/100","SUM(CONSUMO)-SUM(CONSUMO)*"+CVALTOCHAR(MV_PAR07)+"/100")+" ELSE "+IIF(MV_PAR09=="P","SUM(CONSUMO)+SUM(CONSUMO)*"+CVALTOCHAR(MV_PAR08)+"/100","SUM(CONSUMO)-SUM(CONSUMO)*"+CVALTOCHAR(MV_PAR08)+"/100")+" END AS CONSUMOPROJ " // Robson Mazzarotto chamado 004876


	_cQuery += "  FROM  "
	_cQuery += "  ( "
	_cQuery += "   SELECT D2_FILIAL AS FILIAL ,B1_COD AS CODIGO,SUM(D2_QUANT) AS CONSUMO, COUNT(*) AS OCORRENCIAS , SUBSTR(D2_EMISSAO,1,6) PERIODO  FROM "+ RETSQLNAME("SB1")+ " B1 "
	_cQuery += "   LEFT JOIN (SELECT D2_FILIAL,D2_COD,D_E_L_E_T_ ,D2_EMISSAO,D2_CF,D2_QUANT FROM "+RetSqlName("SD2")+" WHERE D2_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND D2_EMISSAO BETWEEN '"+dtos(_cDtini)+"' AND '"+dtos(_cDtFim)+"'  AND D2_CF IN ('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102','1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','5405','5551','5922','5502','6404','6551','6922') AND D_E_L_E_T_ <> '*'  ) D2 ON D2.D2_COD=B1.B1_COD AND D2.D_E_L_E_T_ = ' ' AND D2_EMISSAO BETWEEN '"+dtos(_cDtini)+"' AND '"+dtos(_cDtFim)+"' "
	_cQuery	+= "   AND D2_CF IN ('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102','1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','5405','5551','5922','5502','6404','6551','6922') "
//_cQuery += "   LEFT JOIN (SELECT * FROM "+RetSqlName("SF4")+") F4 ON F4_FILIAL = '  ' AND F4_CODIGO = D2_TES AND F4.D_E_L_E_T_ = ' ' AND F4_ESTOQUE = 'S'   AND  F4_DUPLIC = 'S' "
	_cQuery += "   WHERE B1.D_E_L_E_T_=' ' AND B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "
	_cQuery += "   AND B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery += "   GROUP BY D2_FILIAL,B1_COD,SUBSTR(D2_EMISSAO,1,6) "
	_cQuery += "   UNION ALL "
	_cQuery += "   SELECT D3_FILIAL AS FILIAL,D3_COD AS CODIGO,SUM(D3_QUANT) AS CONSUMO, COUNT(*) AS OCORRENCIAS ,   SUBSTR(D3_EMISSAO,1,6) AS PERIODO "
	_cQuery += "   FROM "+ RETSQLNAME("SD3")+" WHERE D3_EMISSAO BETWEEN '"+dtos(_cDtini)+"' AND '"+dtos(_cDtFim)+"' "
	_cQuery += "   AND D_E_L_E_T_ = ' '  "
//_cQuery += "   AND D3_OP <> ' ' "
	_cQuery += "   AND (D3_OP <> ' ' AND D3_TIPO NOT IN ('IC','MC') OR D3_TIPO IN ('IC','MC') OR (D3_TM = '800' AND D3_TIPO = 'ME')) "
	_cQuery += "   AND D3_CF  LIKE 'RE%' AND D3_ESTORNO = ' ' AND D3_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND D3_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery += "   GROUP BY D3_FILIAL,D3_COD,SUBSTR(D3_EMISSAO,1,6) "
	_cQuery += "  ) DDDD "
	_cQuery += "  LEFT JOIN "+ RETSQLNAME("SB1")+" B1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD =  CODIGO AND B1.D_E_L_E_T_ = ' ' "
//_cQuery += "  LEFT JOIN "+ RETSQLNAME("SB2")+" ON B2_COD =  CODIGO AND B2_LOCAL = B1_LOCPAD AND SB2010.D_E_L_E_T_ = ' ' "
	_cQuery += "  LEFT JOIN "+ RETSQLNAME("SBM")+" BM ON B1_FILIAL = BM_FILIAL AND B1_GRUPO=BM_GRUPO AND BM.D_E_L_E_T_ = ' ' "
	_cQuery += " WHERE NVL((SELECT DISTINCT SUM(B9_QINI) AS SALDO FROM "+RetSqlName("SB9")+" B9 WHERE B9.D_E_L_E_T_=' ' AND B9_DATA = '"+DTOS(dData)+"' AND B9.B9_COD=DDDD.CODIGO  GROUP BY B9_COD),0)<>0 "

/*
If MV_PAR08=="S"
	_cQuery += " AND FILIAL <> ' ' "
EndIf
*/
	_cQuery += " GROUP BY "
/*
If MV_PAR08=="S"
	_cQuery += " FILIAL, "
EndIf
*/
	_cQuery += " CODIGO,B1_GRUPO,B1_DESC,B1_TIPO,B1_DATREF, BM_GRUPO, BM_DESC, B1_CLAPROD, B1_UM, BM_XAGRUP, B1_APROPRI "
	_cQuery += " ORDER BY CODIGO ,B1_GRUPO,B1_DESC,B1_TIPO,B1_DATREF "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAlias,.F.,.T.)

	//TCQUERY _cQuery ALIAS cAlias NEW


	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	oReport:SetMeter(0)
	aFill(aDados,nil)
	oSection:Init()


	While !(cAlias)->(Eof())

		nProx	:= 1
		_nConsT := 0
		_nConsC := 0
		_cAlia1 	:= "QRYCON"
		_dDtInc := Ctod(Space(8))

		//**********************************
		//monta query somando o consumo total do produto - empresa GUA
		//**********************************
		If SubStr(cNumEmp,1,2)=="11"

			If !Empty(Select(_cAlia1))
				DbSelectArea(_cAlia1)
				(_cAlia1)->(dbCloseArea())
			Endif

			_nQryC := " SELECT D2_FILIAL                AS FILIAL, "
			_nQryC += "  B1_COD                         AS CODIGO, "
			_nQryC += "  B1_XDTINCL                     AS XDTINCL, "
			_nQryC += "  Sum(D2_QUANT)                  AS CONSUMO "


			_nQryC += " FROM   UDBP12.SB1010 B1                    "
			_nQryC += " LEFT JOIN (SELECT D2_FILIAL,D2_COD,D_E_L_E_T_ ,D2_EMISSAO,D2_CF,D2_QUANT                        "
			_nQryC += " FROM   UDBP12.SD2010                  "
			_nQryC += " WHERE D2_COD ='"+(cAlias)->CODIGO+"'       AND                       "
			_nQryC += "       D2_EMISSAO BETWEEN '"+dtos(_cDtini)+"'  AND '20211231' AND     "
			_nQryC += "       D_E_L_E_T_ <> '*'                                      AND     "
			_nQryC += "        D2_CF IN ( '5101', '5102', '5109', '5116',                    "
			_nQryC += "                        '5117', '5118', '5119', '5122',    "
			_nQryC += "                        '5123', '5401', '5403', '5501',    "
			_nQryC += "                        '5502', '6101', '6102', '6107',    "
			_nQryC += "                        '6108', '6109', '6110', '6111',    "
			_nQryC += "                        '6114', '6116', '6117', '6118',    "
			_nQryC += "                        '6119', '6122', '6123', '6401',    "
			_nQryC += "                        '6403', '6501', '6502', '7101',    "
			_nQryC += "                        '7102', '1201', '1202', '1410',    "
			_nQryC += "                        '1411', '2201', '2202', '2410',    "
			_nQryC += "                        '2411', '2203', '1918', '2918',    "
			_nQryC += "                        '3201', '3202', '3211','5405','5551','5922','5502','6404','6551','6922' )           "
			_nQryC += " ) D2                                                      "
			_nQryC += " ON D2.D2_COD = B1.B1_COD                   "
			_nQryC += " AND D2.D_E_L_E_T_ = ' '                    "
			_nQryC += " AND D2.D2_COD = '"+(cAlias)->CODIGO+"'     "
			_nQryC += " AND D2_EMISSAO BETWEEN '"+dtos(_cDtini)+"'  AND '20211231' "
			_nQryC += " AND D2_CF IN ( '5101', '5102', '5109', '5116',   "
			_nQryC += "                '5117', '5118', '5119', '5122',   "
			_nQryC += "                '5123', '5401', '5403', '5501',   "
			_nQryC += "                '5502', '6101', '6102', '6107',   "
			_nQryC += "                '6108', '6109', '6110', '6111',   "
			_nQryC += "                '6114', '6116', '6117', '6118',   "
			_nQryC += "                '6119', '6122', '6123', '6401',   "
			_nQryC += "                '6403', '6501', '6502', '7101',   "
			_nQryC += "                '7102', '1201', '1202', '1410',   "
			_nQryC += "                '1411', '2201', '2202', '2410',   "
			_nQryC += "                '2411', '2203', '1918', '2918',   "
			_nQryC += "                '3201', '3202', '3211','5405','5551','5922','5502','6404','6551','6922' )          "
			_nQryC += " WHERE  B1.D_E_L_E_T_ = ' '                       "
			_nQryC += " AND B1_COD = '"+(cAlias)->CODIGO+"'                        "
			_nQryC += " AND B1_GRUPO BETWEEN '    ' AND 'ZZZZ'                     "
			_nQryC += " GROUP  BY D2_FILIAL,                                       "
			_nQryC += " B1_COD ,B1_XDTINCL                                         "

			_nQryC += " UNION ALL                                                  "

			_nQryC += " SELECT D3_FILIAL                AS FILIAL,                 "
			_nQryC += " D3_COD                          AS CODIGO,                 "
			_nQryC += " ''                      AS USERLGI,                "
			_nQryC += " Sum(D3_QUANT)                   AS CONSUMO                 "
			_nQryC += " FROM   UDBP12.SD3010                                       "
			_nQryC += " WHERE  D3_EMISSAO BETWEEN '"+dtos(_cDtini)+"'  AND '20211231'        "
			_nQryC += " AND D3_COD= '"+(cAlias)->CODIGO+"'                     "
			_nQryC += " AND D_E_L_E_T_ = ' '                                       "
			_nQryC += " AND ( D3_OP <> ' '                                         "
			_nQryC += " AND D3_TIPO NOT IN ( 'IC', 'MC' )                          "
			_nQryC += " OR D3_TIPO IN ( 'IC', 'MC' )                               "
			_nQryC += " OR ( D3_TM = '800'                                         "
			_nQryC += " AND D3_TIPO = 'ME' ) )                                     "
			_nQryC += " AND D3_CF LIKE 'RE%'                                       "
			_nQryC += " AND D3_ESTORNO = ' '                                       "
			_nQryC += " AND D3_COD BETWEEN '               ' AND 'ZZZZZZZZZZZZZZZ' "
			_nQryC += " AND D3_GRUPO BETWEEN '    ' AND 'ZZZZ'                     "


			_nQryC += " GROUP  BY D3_FILIAL, "
			_nQryC += " D3_COD            "


			If !Empty(Select(_cAlia1))
				DbSelectArea(_cAlia1)
				(_cAlia1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_nQryC),_cAlia1,.F.,.T.)


			//TCQUERY _nQryC ALIAS _cAlia1 NEW

			(_cAlia1)->(dbGoTop())

			While !(_cAlia1)->(Eof())

				_nConsC += IIF((cAlias)->B1_CLAPROD=="I",IIF(MV_PAR09=="P",(_cAlia1)->CONSUMO+(_cAlia1)->CONSUMO*MV_PAR07/100,(_cAlia1)->CONSUMO-(_cAlia1)->CONSUMO*MV_PAR07/100),IIF(MV_PAR09=="P",(_cAlia1)->CONSUMO+(_cAlia1)->CONSUMO*MV_PAR08/100,(_cAlia1)->CONSUMO-(_cAlia1)->CONSUMO*MV_PAR08/100))
				_nConsT += (_cAlia1)->CONSUMO
				_dDtInc := (_cAlia1)->XDTINCL 

				(_cAlia1)->(DbSkip())
			Enddo



		Endif


		SX5->(DbSetOrder(1))
		SX5->(DbSeek(xFilial("SX5")+"ZZ"+(cAlias)->BM_XAGRUP))

		aDados[1]	:= (cAlias)->CODIGO
		aDados[2]	:= (cAlias)->B1_DESC
		aDados[3]	:= (cAlias)->BM_GRUPO
		aDados[4]	:= (cAlias)->BM_DESC
		aDados[5]	:= (cAlias)->B1_CLAPROD
		aDados[6]	:= (cAlias)->B1_TIPO
		aDados[7]	:= SX5->X5_DESCRI
		aDados[8]	:= (cAlias)->TOTAL_CONSUMO+_nConsT
		aDados[9]	:= ((cAlias)->CONSUMOPROJ+_nConsC )
		aDados[10]	:= (cAlias)->SALDO
		If SubStr(cNumEmp,1,2)=="11" .And. !Empty(_dDtInc)
         	aDados[11]	:= DTOC(STOD(_dDtInc))
		Else
		aDados[11]	:= FWLeUserlg("B1_USERLGI",2)
	    Endif
		aDados[12]	:= (cAlias)->CUSTO
		aDados[13]	:= (cAlias)->SALDO/((cAlias)->CONSUMOPROJ+_nConsC )
		aDados[14]	:= (cAlias)->CUSTO*(cAlias)->SALDO
		aDados[15]	:= IIf(DateDiffYear(aDados[11],DATE())>1 .And. ((cAlias)->CONSUMOPROJ+_nConsC )=0,(cAlias)->SALDO,0)
		aDados[16]	:= IIf(DateDiffYear(aDados[11],DATE())>1 .And. aDados[13]>=2,((cAlias)->CONSUMOPROJ+_nConsC )/2,;
			IIf(DateDiffYear(aDados[11],DATE())>1 .And. aDados[13]>=1 .And. aDados[13]<=2,;
			((cAlias)->SALDO-((cAlias)->CONSUMOPROJ+_nConsC ))/2,0))
		aDados[17]	:= IIf(DateDiffYear(aDados[11],DATE())>1 .And. aDados[13]>2,(cAlias)->SALDO-(2*((cAlias)->CONSUMOPROJ+_nConsC)),0)
		aDados[18]	:= (cAlias)->B1_APROPRI
		aDados[19]	:= ((aDados[15]+aDados[16]+aDados[17])*aDados[12])


		nX	:= 0

		For nX:=1 To Len(_aDadosAd)

			nDados	:=	_aDadosAd[nX][1]
			_cCampo	:= cAlias+"->SALDO"+CValToChar(nX)
			aDados[nDados]	:= &(_cCampo)

		Next nX

		oSection:PrintLine()
		aFill(aDados,nil)

		(cAlias)->(DbSkip())

	EndDo

	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())

	_aArmaz	:= {}
	_nTam	:= 0
	nProx	:= 0

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOUNTAR	บAutor  ณRenato Nogueira     บ Data ณ  25/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio utilizado para calcular a provisใo de estoque     บฑฑ
ฑฑบ          ณ									    				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function COUNTAR(nTamArray)

	Local nRet

	nRet	:= nTamArray+nProx
	nProx	:= nProx+1

Return(nRet)





