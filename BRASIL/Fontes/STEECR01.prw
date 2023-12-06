#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STEECR01   º Autor ³ Vitor Merguizo     º Data ³  30/03/13 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Resumo de Exportacao                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STEECR01()

	Local oReport
	Local aArea	:= GetArea()
	Private aSuper := {}

	Ajusta()

	oReport 	:= ReportDef()
	oReport		:PrintDialog()

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³Microsiga           º Data ³  03/30/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Definicao do layout do Relatorio                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()

	Local oReport
	Local oSection1
	Local oSection2

	oReport := TReport():New("STEECR01","Resumo de Exportacao","STEECR01",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir o Resumo de Exportacao por item conforme parametros.")

	pergunte("STEECR01",.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros						  ³
	//³ mv_par01			// Mes							 		  ³
	//³ mv_par02			// Ano									  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oReport:SetTitle("Resumo de Exportacao")
	oSection1:= TRSection():New(oReport,"Resumo",{"QR1"},)
	oSection1:SetTotalInLine(.t.)
	oSection1:SetHeaderPage()
	oSection1:Setnofilter("QR1")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Microsiga		          ³ Data ³12.05.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportPrint(oReport)

	Local cQuery	:= ""
	Local cAlias	:= "QR1"
	Local _cAlias1	:= "QR2"
	Local _cQuery1	:= ""
	Local cNcm		:= ""
	Local lPrim		:= .T.
	Local nSubQtd	:= 0
	Local nSubQtdEmb:= 0
	Local nSubPeso	:= 0
	Local nSubFCA	:= 0

	Local nTotQtd	:= 0
	Local nTotQtdEmb:= 0
	Local nTotPeso	:= 0
	Local nTotFCA	:= 0

	Local nTotFat08	:= 0
	Local nTotFat09	:= 0
	Local nTotFat10	:= 0
	Local nTotFat11	:= 0

	Local _nRatFator:= 0
	Local _nDesFator:= 0
	Local _nTotFator:= 0
	Local oSection1	:= oReport:Section(1)

	Local aDados1[12]


	TRCell():New(oSection1,"COD"		,	,"Produto"				,"@!"			   ,15,				/*lPixel*/,{||aDados1[1]})
	TRCell():New(oSection1,"DESC"		,	,"Descricao"			,"@!"			   ,30,				/*lPixel*/,{||aDados1[2]})
	TRCell():New(oSection1,"QTD"		,	,"Qtd."					,"@E 9,999,999.999",17,	/*lPixel*/,{||aDados1[3]})
	If MV_PAR03 == 1
		TRCell():New(oSection1,"QTDEMB"		,	,"Qtd. Embar."			,"@E 9,999,999.999",17,	/*lPixel*/,{||aDados1[12]})
	Endif
	TRCell():New(oSection1,"PESO"		,	,"P.Liq.Total"			,"@E 9,999,999.999",17,	/*lPixel*/,{||aDados1[4]})
	TRCell():New(oSection1,"PRECO"		,	,"FCA Unit."			,"@E 9,999,999.999",17,	/*lPixel*/,{||aDados1[5]})
	TRCell():New(oSection1,"TOTAL"		,	,"FCA Total"			,"@E 9,999,999.999",17,	/*lPixel*/,{||aDados1[6]})
	TRCell():New(oSection1,"TIPO"		,	,"Tipo"					,"@!"			   ,30,	/*lPixel*/,{||aDados1[7]})

	If MV_PAR02 == 1

		TRCell():New(oSection1,"DESFATOR"	,	,"Fator Desconto"		,"@E 9,999,999.99" ,17,	/*lPixel*/,{||aDados1[10]})
		TRCell():New(oSection1,"DESTOTAL"	,	,"Total Desconto"		,"@E 9,999,999.99" ,17,	/*lPixel*/,{||aDados1[11]})

		TRCell():New(oSection1,"RATFATOR"	,	,"Fator Frete\Seguro"	,"@!" ,17,	/*lPixel*/,{||aDados1[8]})
		TRCell():New(oSection1,"RATTOTAL"	,	,"Total Frete\Seguro"	,"@E 9,999,999.99" ,17,	/*lPixel*/,{||aDados1[9]})

	EndIF

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	If MV_PAR03 == 1

		//cQuery	:= " SELECT EE8_COD_I COD,B1_DESC,B1_CLAPROD, EE8_POSIPI NCM, EE8_SLDINI QTD, EE9.EE9_SLDINI QTDEMB,B1_PESO*EE8_SLDINI PESO,EE8_PRECO PRECO,EE8_SLDINI*EE8_PRECO TOTAL "
		cQuery	:= " SELECT EE8_COD_I COD,B1_DESC,B1_CLAPROD, EE8_POSIPI NCM, EE8_SLDINI QTD, EE9.EE9_SLDINI QTDEMB,B1_PESO*EE9.EE9_SLDINI PESO,EE8_PRECO PRECO,EE9.EE9_SLDINI*EE8_PRECO TOTAL "
		cQuery	+= " FROM "+RetSqlName("EE8")+" EE8 "
		cQuery	+= " INNER JOIN "+RetSqlName("EE9")+" EE9 ON EE9.EE9_PEDIDO = EE8.EE8_PEDIDO AND EE9.EE9_COD_I = EE8.EE8_COD_I AND EE9_SEQUEN = EE8_SEQUEN AND EE9.D_E_L_E_T_ = ' ' "
		cQuery	+= " LEFT JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD = EE8_COD_I AND SB1.D_E_L_E_T_= ' ' "
		cQuery	+= " WHERE "
		cQuery	+= " EE8_PEDIDO = '"+mv_par01+"' AND "
		cQuery	+= " EE8.D_E_L_E_T_= ' ' ORDER BY EE8_POSIPI "

	Else

		cQuery	:= " SELECT EE8_COD_I COD,B1_DESC,B1_CLAPROD, EE8_POSIPI NCM, EE8_SLDINI QTD,B1_PESO*EE8_SLDINI PESO,EE8_PRECO PRECO,EE8_SLDINI*EE8_PRECO TOTAL "
		cQuery	+= " FROM "+RetSqlName("EE8")+" EE8 "
		cQuery	+= " LEFT JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD = EE8_COD_I AND SB1.D_E_L_E_T_= ' ' "
		cQuery	+= " WHERE "
		cQuery	+= " EE8_PEDIDO = '"+mv_par01+"' AND "
		cQuery	+= " EE8.D_E_L_E_T_= ' ' ORDER BY EE8_POSIPI "

	EndIf

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)

	TcSetField(cAlias,"PESO"	, "N",TamSx3("B1_PESO")[1]		, TamSx3("B1_PESO")[2])
	TcSetField(cAlias,"QTD"		, "N",TamSx3("EE8_SLDINI")[1]	, TamSx3("EE8_SLDINI")[2])
	TcSetField(cAlias,"PRECO"	, "N",TamSx3("EE8_PRECO")[1]	, TamSx3("EE8_PRECO")[2])
	TcSetField(cAlias,"TOTAL"	, "N",TamSx3("CB9_QTEEMB")[1]	, TamSx3("CB9_QTEEMB")[2])

	If MV_PAR02 == 1

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		_cQuery1	:= " SELECT EEC_FRPREV,EEC_SEGPRE,EEC_DESCON,(EEC_TOTPED-(EEC_FRPREV+EEC_SEGPRE)) TOTPROD "
		_cQuery1	+= " FROM "+RetSqlName("EEC")+" EEC "
		_cQuery1	+= " WHERE "
		_cQuery1	+= " EEC_PEDREF = '"+mv_par01+"' AND "
		_cQuery1	+= " EEC.D_E_L_E_T_= ' '"

		dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery1),_cAlias1, .F., .T.)

		_nRatFator := (((_cAlias1)->EEC_FRPREV+(_cAlias1)->EEC_SEGPRE) / CalFator())//(_cAlias1)->TOTPROD) 
		_nDesFator := ((_cAlias1)->EEC_DESCON / CalFator()) //(_cAlias1)->TOTPROD)

	EndIf

	DbSelectArea (cAlias)
	(cAlias)->(DbGoTop())
	nCount:=0
	dbeval({||nCount++})

	oReport:SetMeter(nCount)

	oSection1:Init()
	aFill(aDados1,nil)

	DbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	While (cAlias)->(!Eof())
		If !lPrim .And. cNcm <> (cAlias)->NCM
			aDados1[02] := "SubTotal"
			aDados1[03] := nSubQtd
			aDados1[04] := nSubPeso
			aDados1[06] := nSubFCA
			If MV_PAR03 == 1
				aDados1[12]	:= nSubQtdEmb
			EndIF

			nSubQtd		:= 0
			If MV_PAR03 == 1
				nSubQtdEmb	:= 0
			EndIf
			nSubPeso	:= 0
			nSubFCA		:= 0

			oSection1:PrintLine()
			oReport:SkipLine()
			aFill(aDados1,nil)
		EndIf

		If lPrim .Or. cNcm <> (cAlias)->NCM
			lPrim		:= .F.
			aFill(aDados1,nil)

			aDados1[02] := "Ncm: "+(cAlias)->NCM
			oSection1:PrintLine()
			aFill(aDados1,nil)
		EndIf
		aDados1[01] := (cAlias)->COD
		aDados1[02] := (cAlias)->B1_DESC
		aDados1[03] := (cAlias)->QTD
		If MV_PAR03 == 1
			aDados1[12] := (cAlias)->QTDEMB
		EndIF
		aDados1[04] := (cAlias)->PESO
		aDados1[05] := (cAlias)->PRECO
		aDados1[06] := (cAlias)->TOTAL
		aDados1[07] := (cAlias)->B1_CLAPROD

		If MV_PAR02 == 1

			aDados1[10] := ROUND((cAlias)->TOTAL*_nDesFator,3)
			aDados1[11] := Iif(_nDesFator > 0, (cAlias)->TOTAL - aDados1[10],0)

			aDados1[08] := ROUND((cAlias)->TOTAL*_nRatFator,3)

			If aDados1[11] > 0

				aDados1[09] :=  aDados1[08]+aDados1[11]

			Else

				aDados1[09] :=  aDados1[08]+(cAlias)->TOTAL

			EndIf



			//Iif(_nRatFator > 0,aDados1[08]+aDados1[11],0) //Iif(_nRatFator > 0,aDados1[08]+(cAlias)->TOTAL,0)


			nTotFat08 += ROUND((cAlias)->TOTAL*_nRatFator,3)

			If aDados1[11] > 0

				nTotFat09 +=  aDados1[08]+aDados1[11]

			Else

				nTotFat09 +=  aDados1[08]+(cAlias)->TOTAL

			EndIf


			//nTotFat09 += Iif(_nRatFator > 0,aDados1[08]+aDados1[11],0)

			nTotFat10 += ROUND((cAlias)->TOTAL*_nDesFator,3)
			nTotFat11 += Iif(_nDesFator > 0, (cAlias)->TOTAL - aDados1[10],0)

		EndIF

		nSubQtd		+= (cAlias)->QTD
		If MV_PAR03 == 1
			nSubQtdEmb 	+= (cAlias)->QTDEMB
		EndIf
		nSubPeso	+= (cAlias)->PESO
		nSubFCA		+= (cAlias)->TOTAL

		nTotQtd		+= (cAlias)->QTD
		If MV_PAR03 == 1
			nTotQtdEmb	+= (cAlias)->QTDEMB
		EndIf
		nTotPeso	+= (cAlias)->PESO
		nTotFCA		+= (cAlias)->TOTAL


		oSection1:PrintLine()
		aFill(aDados1,nil)

		oReport:IncMeter()
		cNcm 		:= (cAlias)->NCM
		(cAlias)->(dbSkip())
	EndDo

	aDados1[02] := "SubTotal"
	aDados1[03] := nSubQtd
	If MV_PAR03 == 1
		aDados1[12]	:= nSubQtdEmb
	EndIf
	aDados1[04] := nSubPeso
	aDados1[06] := nSubFCA

	oSection1:PrintLine()
	oReport:SkipLine()
	aFill(aDados1,nil)

	If MV_PAR02 == 1

		aDados1[02] := "Total"
		aDados1[03] := nTotQtd
		If MV_PAR03 == 1
			aDados1[12] := nTotQtdEmb
		EndIf
		aDados1[04] := nTotPeso
		aDados1[06] := nTotFCA
		aDados1[08]	:= nTotFat08
		aDados1[09]	:= nTotFat09
		aDados1[10]	:= nTotFat10
		aDados1[11]	:= nTotFat11

		oSection1:PrintLine()
		aFill(aDados1,nil)

		//_nTotFator := (_cAlias1)->EEC_FRPREV+(_cAlias1)->EEC_SEGPRE

		aDados1[02] := "Desconto"
		aDados1[06] := (_cAlias1)->EEC_DESCON
		nTotFCA -= (_cAlias1)->EEC_DESCON

		oSection1:PrintLine()
		aFill(aDados1,nil)

		aDados1[02] := "SubTotal"
		aDados1[06] := nTotFCA

		oSection1:PrintLine()
		aFill(aDados1,nil)

		aDados1[02] := "Frete"
		aDados1[06] := (_cAlias1)->EEC_FRPREV
		nTotFCA += (_cAlias1)->EEC_FRPREV

		oSection1:PrintLine()
		aFill(aDados1,nil)

		aDados1[02] := "Seguro"
		aDados1[06] := (_cAlias1)->EEC_SEGPRE
		nTotFCA += (_cAlias1)->EEC_SEGPRE

		/*
		oSection1:PrintLine()
		aFill(aDados1,nil)

		_nTotFator := (_cAlias1)->EEC_FRPREV+(_cAlias1)->EEC_SEGPRE

		aDados1[02] := "Desconto"
		aDados1[06] := (_cAlias1)->EEC_DESCON
		nTotFCA -= (_cAlias1)->EEC_DESCON
		*/

	EndIf

	oSection1:PrintLine()
	oReport:SkipLine()
	aFill(aDados1,nil)

	aDados1[02] := "Total"
	aDados1[03] := nTotQtd
	If MV_PAR03 == 1
		aDados1[12] := nTotQtdEmb
	EndIf
	aDados1[04] := nTotPeso
	aDados1[06] := nTotFCA

	oReport:SkipLine()
	oSection1:PrintLine()
	aFill(aDados1,nil)
	oSection1:Finish()

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ajusta    ºAutor  ³Microsiga           º Data ³  03/30/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Insere novas perguntas na tabela SX1 a Ajusta o Picture    º±±
±±º          ³ dos valores no SX3                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Ajusta()

	Local aPergs 	:= {}

	Aadd(aPergs,{"Pedido ?                  ","Pedido ?                  ","Pedido ?                  ","mv_ch1","C",20,0,0,"G",""                   ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","EE7","S","",""})

	//AjustaSx1("STEECR01",aPergs)

Return

Static Function CalFator()

	Local _cAlias2	:= "QR3"
	Local _cQuery2	:= ""
	Local _nRet		:= 0
	If !Empty(Select(_cAlias2))
		DbSelectArea(_cAlias2)
		(_cAlias2)->(dbCloseArea())
	Endif

	_cQuery2	:= " SELECT SUM(EE9_SLDINI*EE8_PRECO) TOTAL "
	_cQuery2	+= " FROM "+RetSqlName("EE8")+" EE8 "
	_cQuery2	+= " LEFT JOIN "+RetSqlName("EE9")+" EE9 ON EE9.EE9_PEDIDO = EE8.EE8_PEDIDO AND EE9.EE9_COD_I = EE8.EE8_COD_I AND EE8_SEQUEN = EE9_SEQUEN AND EE9.D_E_L_E_T_ = ' ' "
	_cQuery2	+= " WHERE "
	_cQuery2	+= " EE8_PEDIDO = '" + Mv_Par01 + "' AND "
	_cQuery2	+= " EE8.D_E_L_E_T_= ' '"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery2),_cAlias2, .F., .T.)

	_nRet := (_cAlias2)->TOTAL


Return(_nRet)
