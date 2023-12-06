#include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ STFATR07   ∫ Autor ≥ Vitor Merguizo	∫ Data ≥  16/11/12	  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Relatorio de Captacao liquido conforme especificaÁ„o do    ∫±±
±±∫          ≥ cliente                                                    ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function STFATR07()

	Local oReport

	If !( __cUserId $ Getmv("ST_FATR03",,"000000/000645/000294/000965/000271/000231/000391/000591"))
		MsgInfo("Usuario sem acesso, solicite liberaÁ„o ...!!!")
		Return
	EndIf
	
	Ajusta()

	oReport := ReportDef()
	oReport:PrintDialog()

Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±≥FunÁ„o    ≥ ReportDef≥ Autor ≥ Microsiga	        ≥ Data ≥ 12.05.12 	  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriÁ„o ≥ Definicao do layout do Relatorio				  			  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ ReportDef(void)                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Generico                                                   ≥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function ReportDef()

	Local oReport
	Local oSection1

	oReport := TReport():New("STFATR07","Captacao Anual Por Dia","STFATR07",{|oReport| ReportPrint(oReport)},"Este programa ir· imprimir a captaÁ„o anual conforme parametros selecionados.")
	oReport:SetLandscape()
	oReport:nFontBody := 5

	Pergunte("STFATR07",.F.)

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Variaveis utilizadas para parametros						  ≥
	//≥ mv_par01 | Ano                                                ≥
	//≥ mv_par02 | Produto de                                         ≥
	//≥ mv_par03 | Produto atÈ                                        ≥
	//≥ mv_par04 | Grupo de                                           ≥
	//≥ mv_par05 | Grupo atÈ                                          ≥
	//≥ mv_par06 | Agrupamento de                                     ≥
	//≥ mv_par07 | Agrupamento atÈ                                    ≥
	//≥ mv_par08 | Cliente de                                         ≥
	//≥ mv_par09 | Loja de                                            ≥
	//≥ mv_par10 | Cliente ate                                        ≥
	//≥ mv_par11 | Loja ate                                           ≥
	//≥ mv_par12 | Considera os Clientes                              ≥
	//≥ mv_par13 | N„o Considera os Clientes                          ≥
	//≥ mv_par14 | Imprime Detalhes                          		  ≥	
	//≥ mv_par15 | Data de                              			  ≥
	//≥ mv_par16 | Data atÈ                           				  ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	oSection1 := TRSection():New(oReport,"Captacao",{"SC5"},)

	TRCell():New(oSection1,"TIPO"		,,"Destino"	 	,"@!",20,.F.,)
	TRCell():New(oSection1,"FILIAL"		,,"Filial"	 	,PesqPict('SC5',"C5_FILIAL")	,TamSX3("C5_FILIAL")[1],.F.,)
	TRCell():New(oSection1,"DATA"		,,"Data"	 	,PesqPict('SC5',"C5_EMISSAO")	,TamSX3("C5_EMISSAO")[1],.F.,)
	TRCell():New(oSection1,"COD"		,,"Codigo  	"	,PesqPict('SC6',"C6_PRODUTO")	,TamSX3("C6_PRODUTO")[1],.F.,)
	TRCell():New(oSection1,"GRUPO"		,,"Grupo  	"	,PesqPict('SBM',"BM_GRUPO")		,TamSX3("BM_GRUPO")[1],.F.,)
	TRCell():New(oSection1,"AGRP"		,,"Aglut. GrUpo",PesqPict('SBM',"BM_XAGRUP")	,TamSX3("BM_XAGRUP")[1],.F.,)
	TRCell():New(oSection1,"VALOR"		,,"Valor   "	,PesqPict('SC6',"C6_VALOR")		,TamSX3("C6_VALOR")[1],.F.,)

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("SC5")

Return oReport

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±≥Programa  ≥ReportPrint≥ Autor ≥Microsiga		          ≥ Data ≥16.11.12 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriÁ„o ≥A funcao estatica ReportDef devera ser criada para todos os  ≥±±
±±≥          ≥relatorios que poderao ser agendados pelo usuario.           ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥Nenhum                                                       ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ExpO1: Objeto Report do RelatÛrio                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥   DATA   ≥ Programador   ≥Manutencao efetuada                          ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥          ≥               ≥                                             ≥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function ReportPrint(oReport)

	Local cTitulo		:= OemToAnsi("CaptaÁ„o referente "+mv_par01)
	Local cClienteIN	:= ""
	Local cClienteNIN	:= ""
	Local cAlias		:= "QRY1SC5"
	Local cQuery		:= ""
	Local cQuery1		:= ""
	Local cArqTRB		:= ""
	Local cInd1			:= ""
	Local cInd2			:= ""
	Local _n			:= 0
	Local _i			:= 0
	Local n				:= 0
	Local aAreaSM0		:= SM0->(GetArea())
	Local aEmpQry		:= {}
	Local aEmpresa		:= MarkFile()
	Local aStruct		:= {}
	Local aDados1[28]
	Local oSection1  := oReport:Section(1)

	oSection1:Cell("TIPO")		:SetBlock( { || aDados1[01]	})
	oSection1:Cell("FILIAL")	:SetBlock( { || aDados1[02]	})
	oSection1:Cell("DATA")		:SetBlock( { || aDados1[03]	})
	oSection1:Cell("COD")		:SetBlock( { || aDados1[04]	})
	oSection1:Cell("GRUPO")		:SetBlock( { || aDados1[04]	})
	oSection1:Cell("AGRP")		:SetBlock( { || aDados1[04]	})
	oSection1:Cell("VALOR")		:SetBlock( { || aDados1[05]	})

	If Empty(aEmpresa)
		MsgAlert("AtenÁ„o, N„o foi selecionada nenhuma Empresa.")
		Return(Nil)
	EndIf

	If !Empty(mv_par12)
		cClienteIN += StrTran(mv_par12,";","','")
	EndIf

	If !Empty(mv_par13)
		cClienteNIN += StrTran(mv_par13,";","','")
	EndIf

	If Len(aEmpresa) > 0
		RestArea(aAreaSM0)
		For _n := 1 to Len(aEmpresa)
			If aEmpresa[_n][1]
				aAdd(aEmpQry,aEmpresa[_n][2])
			EndIf
		Next _n
		cQuery += " SELECT TIP,FILIAL,DAT,MAX(COD)COD,MAX(BM_GRUPO) GRP, BM_XAGRUP AGR, SUM(C6_VALOR)VALOR FROM ("+ CRLF
		For _i := 1 to Len(aEmpQry)
			If _i > 1
				cQuery += " UNION ALL"+ CRLF
			EndIf
			If aEmpQry[_i] = '11' //Distribuidora
				cQuery += " SELECT '"+aEmpQry[_i]+"' EMP,CASE WHEN A1_GRPVEN = 'SC' THEN '3' WHEN A1_EST = 'EX' THEN '2' ELSE '1' END TIP,C5_EMISSAO DAT, C5_FILIAL FILIAL,C6_PRODUTO COD,C5_CLIENTE CLI,C5_LOJACLI LOJ,"+ CRLF
				If aEmpQry[_i] == "11"
					cQuery += " SUM(CASE WHEN C6_BLQ = 'R' AND C6_ZVALLIQ > 0 THEN C6_ZVALLIQ/C6_QTDVEN*C6_QTDENT WHEN C6_ZVALLIQ > 0 THEN C6_ZVALLIQ WHEN C6_BLQ = 'R' THEN C6_VALOR/C6_QTDVEN*C6_QTDENT "+ CRLF
					cQuery += " ELSE C6_VALOR END * CASE WHEN A1_EST = 'EX' THEN CASE WHEN NVL(EE7_MOEDA,'R$ ') = 'EUR' THEN NVL(M2_MOEDA4,1) WHEN NVL(EE7_MOEDA,'R$ ') = 'US$' THEN NVL(M2_MOEDA2,1) ELSE NVL(M2_MOEDA2,1) END ELSE 1 END) C6_VALOR" + CRLF// Alterar apos criacao do campo em outras empresas
				Else
					cQuery += " SUM(CASE WHEN C6_BLQ = 'R' THEN C6_VALOR/C6_QTDVEN*C6_QTDENT ELSE C6_VALOR END * CASE WHEN A1_EST = 'EX' THEN CASE WHEN NVL(EE7_MOEDA,'R$ ') = 'EUR' THEN NVL(M2_MOEDA4,1) WHEN NVL(EE7_MOEDA,'R$ ') = 'US$' THEN NVL(M2_MOEDA2,1) ELSE NVL(M2_MOEDA2,1) END ELSE 1 END ) C6_VALOR"+ CRLF
				EndIf
				cQuery += " FROM UDBD11.SC5"+aEmpQry[_i]+"0 SC5 "+ CRLF
				cQuery += " INNER JOIN UDBD11.SC6"+aEmpQry[_i]+"0 SC6 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA AND SC6.D_E_L_E_T_ = ' '"+ CRLF
				cQuery += " LEFT JOIN UDBD11.SA3"+aEmpQry[_i]+"0 SA3 ON A3_FILIAL = '"+xFilial("SA3")+"' AND C5_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ' '"+ CRLF
				cQuery += " LEFT JOIN UDBD11.SA1"+aEmpQry[_i]+"0 SA1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND SA1.D_E_L_E_T_ = ' '"+ CRLF
				cQuery += " LEFT JOIN UDBD11.SF4"+aEmpQry[_i]+"0 SF4 ON F4_FILIAL = '"+xFilial("SF4")+"' AND C6_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' '"+ CRLF
				cQuery += " LEFT JOIN UDBD11.EE7"+aEmpQry[_i]+"0 EE7 ON EE7_FILIAL = C6_FILIAL AND EE7_PEDFAT = C6_NUM AND EE7.D_E_L_E_T_ = ' '"+ CRLF
				cQuery += " LEFT JOIN UDBD11.SM2"+aEmpQry[_i]+"0 SM2 ON M2_DATA = C5_EMISSAO AND SM2.D_E_L_E_T_ = ' '"+ CRLF
				If aEmpQry[_i] == "11"
					cQuery += " LEFT JOIN UDBD11.PC1"+aEmpQry[_i]+"0 PC1 ON C6_NUM=PC1_PEDREP AND PC1.D_E_L_E_T_ = ' '"+ CRLF
				EndIf
				cQuery += " WHERE"+ CRLF
				cQuery += " C5_FILIAL <> ' ' AND"+ CRLF
				cQuery += " C5_EMISSAO BETWEEN '"+DTOS(mv_par15)+"' AND '"+DTOS(mv_par16)+"' AND"+ CRLF
				cQuery += " C5_TIPO = 'N' AND"+ CRLF
				cQuery += " A1_GRPVEN <> 'ST' AND"+ CRLF
				cQuery += " (F4_DUPLIC = 'S' OR F4_DUPLIC <> 'S' AND A1_EST = 'EX') AND"+ CRLF
				IF aEmpQry[_i]="11"
					cQuery += " PC1_PEDREP IS NULL AND"+ CRLF
				EndIf
				cQuery += " SC5.D_E_L_E_T_ = '' "+ CRLF
				cQuery += " GROUP BY CASE WHEN A1_GRPVEN = 'SC' THEN '3' WHEN A1_EST = 'EX' THEN '2' ELSE '1' END,C5_EMISSAO,C5_FILIAL,C6_PRODUTO,C5_CLIENTE,C5_LOJACLI"+ CRLF
				cQuery += " UNION ALL"+ CRLF
				cQuery += " SELECT '"+aEmpQry[_i]+"' EMP,'4'TIP,EE7_DTPEDI DAT, EE7_FILIAL FILIAL,EE8_COD_I COD,' 'Cli,' 'Loj,ROUND(SUM(EE8_PRCTOT*(CASE WHEN NVL(M2_MOEDA2,1) > 0 THEN M2_MOEDA2 ELSE 1 END))-(SUM(EE8_PRCTOT*(CASE WHEN NVL(M2_MOEDA2,1) > 0 THEN M2_MOEDA2 ELSE 1 END) )*0.0925),2) VALOR"+ CRLF
				cQuery += " FROM UDBD11.EE8"+aEmpQry[_i]+"0 EE8"+ CRLF
				cQuery += " INNER JOIN UDBD11.EE7"+aEmpQry[_i]+"0 EE7 ON EE7_FILIAL = EE8_FILIAL AND EE7_PEDIDO = EE8_PEDIDO AND EE7.D_E_L_E_T_ = ' '"
				cQuery += " LEFT JOIN UDBD11.SM2"+aEmpQry[_i]+"0 SM2 ON M2_DATA = EE7_DTPEDI AND SM2.D_E_L_E_T_ = ' '"
				cQuery += " WHERE"
				cQuery += " EE8_FILIAL <> ' ' AND"
				cQuery += " EE7_DTPEDI BETWEEN '"+DTOS(mv_par15)+"' AND '"+DTOS(mv_par16)+"' AND"
				cQuery += " EE7_PEDFAT = ' ' AND"
				cQuery += " EE7_FATURA = ' ' AND"
				cQuery += " EE7_CONDPA <> '58' AND"  //GIOVANI ZAGO 15/06/2016 SL JESSICA
				cQuery += " EE8.D_E_L_E_T_ = ' '"
				cQuery += " GROUP BY EE7_DTPEDI,EE7_FILIAL,EE8_COD_I"
			ElseIf aEmpQry[_i] = '01' //Distribuidora
				cQuery += " SELECT '"+aEmpQry[_i]+"' EMP,CASE WHEN A1_GRPVEN = 'SC' THEN '3' WHEN A1_EST = 'EX' THEN '2' ELSE '1' END TIP,C5_EMISSAO DAT, C5_FILIAL FILIAL,C6_PRODUTO COD,C5_CLIENTE CLI,C5_LOJACLI LOJ,"+ CRLF
				If aEmpQry[_i] == "11"
					cQuery += " SUM(CASE WHEN C6_BLQ = 'R' AND C6_ZVALLIQ > 0 THEN C6_ZVALLIQ/C6_QTDVEN*C6_QTDENT WHEN C6_ZVALLIQ > 0 THEN C6_ZVALLIQ WHEN C6_BLQ = 'R' THEN C6_VALOR/C6_QTDVEN*C6_QTDENT "+ CRLF
					cQuery += " ELSE C6_VALOR END * CASE WHEN A1_EST = 'EX' THEN CASE WHEN NVL(EE7_MOEDA,'R$ ') = 'EUR' THEN NVL(M2_MOEDA4,1) WHEN NVL(EE7_MOEDA,'R$ ') = 'US$' THEN NVL(M2_MOEDA2,1) ELSE NVL(M2_MOEDA2,1) END ELSE 1 END) C6_VALOR" + CRLF// Alterar apos criacao do campo em outras empresas
				Else
					cQuery += " SUM(CASE WHEN C6_BLQ = 'R' THEN C6_VALOR/C6_QTDVEN*C6_QTDENT ELSE C6_VALOR END * CASE WHEN A1_EST = 'EX' THEN CASE WHEN NVL(EE7_MOEDA,'R$ ') = 'EUR' THEN NVL(M2_MOEDA4,1) WHEN NVL(EE7_MOEDA,'R$ ') = 'US$' THEN NVL(M2_MOEDA2,1) ELSE NVL(M2_MOEDA2,1) END ELSE 1 END ) C6_VALOR"+ CRLF
				EndIf
				cQuery += " FROM UDBP12.SC5"+aEmpQry[_i]+"0 SC5 "+ CRLF
				cQuery += " INNER JOIN UDBP12.SC6"+aEmpQry[_i]+"0 SC6 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA AND SC6.D_E_L_E_T_ = ' '"+ CRLF
				cQuery += " LEFT JOIN UDBP12.SA3"+aEmpQry[_i]+"0 SA3 ON A3_FILIAL = '"+xFilial("SA3")+"' AND C5_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ' '"+ CRLF
				cQuery += " LEFT JOIN UDBP12.SA1"+aEmpQry[_i]+"0 SA1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND SA1.D_E_L_E_T_ = ' '"+ CRLF
				cQuery += " LEFT JOIN UDBP12.SF4"+aEmpQry[_i]+"0 SF4 ON F4_FILIAL = '"+xFilial("SF4")+"' AND C6_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' '"+ CRLF
				cQuery += " LEFT JOIN UDBP12.EE7"+aEmpQry[_i]+"0 EE7 ON EE7_FILIAL = C6_FILIAL AND EE7_PEDFAT = C6_NUM AND EE7.D_E_L_E_T_ = ' '"+ CRLF
				cQuery += " LEFT JOIN UDBP12.SM2"+aEmpQry[_i]+"0 SM2 ON M2_DATA = C5_EMISSAO AND SM2.D_E_L_E_T_ = ' '"+ CRLF
				If aEmpQry[_i] == "01"
					cQuery += " LEFT JOIN UDBP12.PC1"+aEmpQry[_i]+"0 PC1 ON C6_NUM=PC1_PEDREP AND PC1.D_E_L_E_T_ = ' '"+ CRLF
				EndIf
				cQuery += " WHERE"+ CRLF
				cQuery += " C5_FILIAL <> ' ' AND"+ CRLF
				cQuery += " C5_EMISSAO BETWEEN '"+DTOS(mv_par15)+"' AND '"+DTOS(mv_par16)+"' AND"+ CRLF
				cQuery += " C5_TIPO = 'N' AND"+ CRLF
				cQuery += " A1_GRPVEN <> 'ST' AND"+ CRLF
				cQuery += " (F4_DUPLIC = 'S' OR F4_DUPLIC <> 'S' AND A1_EST = 'EX') AND"+ CRLF
				IF aEmpQry[_i]="01"
					cQuery += " PC1_PEDREP IS NULL AND"+ CRLF
				EndIf
				cQuery += " SC5.D_E_L_E_T_ = '' "+ CRLF
				cQuery += " GROUP BY CASE WHEN A1_GRPVEN = 'SC' THEN '3' WHEN A1_EST = 'EX' THEN '2' ELSE '1' END,C5_EMISSAO,C5_FILIAL,C6_PRODUTO,C5_CLIENTE,C5_LOJACLI"+ CRLF
				cQuery += " UNION ALL"+ CRLF
				cQuery += " SELECT '"+aEmpQry[_i]+"' EMP,'4'TIP,EE7_DTPEDI DAT, EE7_FILIAL FILIAL,EE8_COD_I COD,' 'Cli,' 'Loj,ROUND(SUM(EE8_PRCTOT*(CASE WHEN NVL(M2_MOEDA2,1) > 0 THEN M2_MOEDA2 ELSE 1 END))-(SUM(EE8_PRCTOT*(CASE WHEN NVL(M2_MOEDA2,1) > 0 THEN M2_MOEDA2 ELSE 1 END) )*0.0925),2) VALOR"+ CRLF
				cQuery += " FROM UDBP12.EE8"+aEmpQry[_i]+"0 EE8"+ CRLF
				cQuery += " INNER JOIN UDBP12.EE7"+aEmpQry[_i]+"0 EE7 ON EE7_FILIAL = EE8_FILIAL AND EE7_PEDIDO = EE8_PEDIDO AND EE7.D_E_L_E_T_ = ' '"
				cQuery += " LEFT JOIN UDBP12.SM2"+aEmpQry[_i]+"0 SM2 ON M2_DATA = EE7_DTPEDI AND SM2.D_E_L_E_T_ = ' '"
				cQuery += " WHERE"
				cQuery += " EE8_FILIAL <> ' ' AND"
				cQuery += " EE7_DTPEDI BETWEEN '"+DTOS(mv_par15)+"' AND '"+DTOS(mv_par16)+"' AND"
				cQuery += " EE7_PEDFAT = ' ' AND"
				cQuery += " EE7_FATURA = ' ' AND"
				cQuery += " EE7_CONDPA <> '58' AND"  //GIOVANI ZAGO 15/06/2016 SL JESSICA
				cQuery += " EE8.D_E_L_E_T_ = ' '"
				cQuery += " GROUP BY EE7_DTPEDI,EE7_FILIAL,EE8_COD_I"
			ElseIf aEmpQry[_i] = '07' //Argentina
				cQuery += " SELECT '"+aEmpQry[_i]+"' EMP,'5' TIP,C5_EMISSAO DAT, C5_FILIAL FILIAL ,C6_PRODUTO COD,C5_CLIENTE CLI,C5_LOJACLI LOJ, "
				cQuery += " SUM((C6_VALOR*SM2.M2_MOEDA2)) C6_VALOR "
				cQuery += " FROM UDBP12ARG.SC6"+aEmpQry[_i]+"0 SC6 "
				cQuery += " INNER JOIN(SELECT * FROM UDBP12ARG.SC5"+aEmpQry[_i]+"0) SC5
				cQuery += " ON SC5.D_E_L_E_T_ = ' '
				cQuery += " AND
				cQuery += " C5_EMISSAO BETWEEN '"+DTOS(mv_par15)+"' AND '"+DTOS(mv_par16)+"' "
				cQuery += " AND C5_NUM = C6_NUM
				cQuery += " INNER JOIN(SELECT * FROM UDBP12ARG.SF4"+aEmpQry[_i]+"0)SF4
				cQuery += " ON SF4.D_E_L_E_T_ = ' '
				cQuery += " AND F4_CODIGO = C6_TES
				cQuery += " AND F4_DUPLIC = 'S'
				cQuery += "       LEFT JOIN UDBP12ARG.SM2"+aEmpQry[_i]+"0 SM2"
				cQuery += "             ON SM2.M2_DATA = SC5.C5_EMISSAO "
				cQuery += "             AND SM2.D_E_L_E_T_ = ' ' "
				cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
				cQuery += " GROUP BY '5',C5_EMISSAO,C5_FILIAL,C6_PRODUTO,C5_CLIENTE,C5_LOJACLI"
			ElseIf aEmpQry[_i] = '09' //Colombia
				cQuery += " SELECT '"+aEmpQry[_i]+"' EMP,'5' TIP,C5_EMISSAO DAT, C5_FILIAL FILIAL ,C6_PRODUTO COD,C5_CLIENTE CLI,C5_LOJACLI LOJ, "
				cQuery += " SUM((C6_VALOR*SM2.M2_MOEDA2)) C6_VALOR "
				cQuery += " FROM UDBCOL.SC6"+aEmpQry[_i]+"0 SC6 "
				cQuery += " INNER JOIN(SELECT * FROM UDBCOL.SC5"+aEmpQry[_i]+"0) SC5
				cQuery += " ON SC5.D_E_L_E_T_ = ' '
				cQuery += " AND
				cQuery += " C5_EMISSAO BETWEEN '"+DTOS(mv_par15)+"' AND '"+DTOS(mv_par16)+"' "
				cQuery += " AND C5_NUM = C6_NUM
				cQuery += " INNER JOIN(SELECT * FROM UDBCOL.SF4"+aEmpQry[_i]+"0)SF4
				cQuery += " ON SF4.D_E_L_E_T_ = ' '
				cQuery += " AND F4_CODIGO = C6_TES
				cQuery += " AND F4_DUPLIC = 'S'
				cQuery += "       LEFT JOIN UDBCOL.SM2"+aEmpQry[_i]+"0 SM2"
				cQuery += "             ON SM2.M2_DATA = SC5.C5_EMISSAO "
				cQuery += "             AND SM2.D_E_L_E_T_ = ' ' "
				cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
				cQuery += " GROUP BY '5',C5_EMISSAO,C5_FILIAL,C6_PRODUTO,C5_CLIENTE,C5_LOJACLI"
			EndIf
		Next _i
		cQuery += " )NF "
		cQuery += " LEFT JOIN ( SELECT '01' EMP,B1_COD,D_E_L_E_T_,B1_GRUPO FROM UDBP12.SB1010 WHERE D_E_L_E_T_ = ' ' UNION SELECT '11' EMP,B1_COD,D_E_L_E_T_,B1_GRUPO FROM UDBD11.SB1110 WHERE D_E_L_E_T_ = ' ' UNION SELECT '03' EMP, B1_COD,D_E_L_E_T_,B1_GRUPO FROM UDBP12.SB1030 WHERE D_E_L_E_T_ = ' ' UNION SELECT '07' EMP, B1_COD,D_E_L_E_T_,B1_GRUPO FROM UDBP12ARG.SB1070 WHERE D_E_L_E_T_ = ' ' UNION SELECT '09' EMP, B1_COD,D_E_L_E_T_,B1_GRUPO FROM UDBCOL.SB1090 WHERE D_E_L_E_T_ = ' ') B1 ON B1_COD = NF.COD AND B1.EMP = NF.EMP AND B1.D_E_L_E_T_ = ' ' 
		cQuery += " LEFT JOIN (SELECT '01' EMP, BM_XAGRUP,BM_GRUPO,D_E_L_E_T_ FROM UDBP12.SBM010 WHERE D_E_L_E_T_ = ' ' UNION SELECT '11' EMP, BM_XAGRUP,BM_GRUPO,D_E_L_E_T_ FROM UDBD11.SBM110 WHERE D_E_L_E_T_ = ' ' UNION SELECT '03' EMP,BM_XAGRUP,BM_GRUPO,D_E_L_E_T_ FROM UDBP12.SBM030 WHERE D_E_L_E_T_ = ' ' UNION SELECT '07' EMP,BM_XAGRUP,BM_GRUPO,D_E_L_E_T_ FROM UDBP12ARG.SBM070 WHERE D_E_L_E_T_ = ' ' UNION SELECT '09' EMP,BM_XAGRUP,BM_GRUPO,D_E_L_E_T_ FROM UDBCOL.SBM090 WHERE D_E_L_E_T_ = ' ') BM ON B1.B1_GRUPO = BM.BM_GRUPO AND BM.EMP = NF.EMP AND BM.D_E_L_E_T_ = ' '
		If !Empty(mv_par03)
			cQuery1 += " COD >= '"+mv_par02+"' AND"
			cQuery1 += " COD <= '"+mv_par03+"' AND"
		EndIf
		If !Empty(mv_par05)
			cQuery1 += " BM_GRUPO >= '"+mv_par04+"' AND"
			cQuery1 += " BM_GRUPO <= '"+mv_par05+"' AND"
		EndIf
		If !Empty(mv_par07)
			cQuery1 += " BM_XAGRUP >= '"+mv_par06+"' AND"
			cQuery1 += " BM_XAGRUP <= '"+mv_par07+"' AND"
		EndIf
		If !Empty(mv_par10) .Or. !Empty(mv_par11)
			cQuery1 += " CLI >= '"+mv_par08+"' AND"
			cQuery1 += " LOJ >= '"+mv_par09+"' AND"
			cQuery1 += " CLI <= '"+mv_par10+"' AND"
			cQuery1 += " LOJ <= '"+mv_par11+"' AND"
		EndIf
		If !Empty(mv_par12)
			cQuery1 += " CLI IN ('"+cClienteIN+"') AND"
		EndIf
		If !Empty(mv_par13)
			cQuery1 += " CLI NOT IN ('"+cClienteNIN+"') AND"
		EndIf
		If Len(cQuery1) > 1
			cQuery	+= " WHERE "+SUBS(cQuery1,1,Len(cQuery1)-4)
		EndIf

		cQuery += " GROUP BY TIP, BM_XAGRUP, BM_GRUPO, DAT, COD, FILIAL "
		cQuery += " ORDER BY TIP, DAT, COD, BM_XAGRUP, BM_GRUPO "

		cQuery := ChangeQuery(cQuery)

		// Fecha Alias se estiver em Uso
		If !Empty(Select(cAlias))
			dbSelectArea(cAlias)
			(cAlias)->( dbCloseArea() )
		EndIf

		// Monta Area de Trabalho executando a Query
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.T.)

		TCSetField(cAlias,"VALOR","N",18,2)

		dbSelectArea(cAlias)
		(cAlias)->( dbGoTop() )

		While (cAlias)->( !Eof() )
			oSection1:Init()
			oSection1:Cell("TIPO"):SetValue((cAlias)->TIP)
			oSection1:Cell("FILIAL"):SetValue((cAlias)->FILIAL)
			oSection1:Cell("DATA"):SetValue(Stod((cAlias)->DAT))
			oSection1:Cell("COD"):SetValue((cAlias)->COD)
			oSection1:Cell("GRUPO"):SetValue((cAlias)->GRP)
			oSection1:Cell("AGRP"):SetValue((cAlias)->AGR)
			oSection1:Cell("VALOR"):SetValue((cAlias)->VALOR)
			oSection1:PrintLine()
			(cAlias)->( dbSkip() )
		End	
	EndIf
	
	oSection1:Finish()

Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ MARKFILE ∫Autor  ≥ Vitor Merguizo     ∫ Data ≥  08/09/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ FunÁ„o auxiliar para seleÁ„o de Arquivos                   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function MarkFile()

	Local aArea		:= SM0->( GetArea() )
	Local aChaveArq := {}
	Local lSelecao	:= .T.
	Local cTitulo 	:= "SeleÁ„o de Empresas para GeraÁ„o de Relatorio: "
	Local cEmpresa	:= ""
	Local bCondicao := {|| .T.}

	// Vari·veis utilizadas na seleÁ„o de categorias
	Local oChkQual,lQual,oQual,cVarQ

	// Carrega bitmaps
	Local oOk := LoadBitmap( GetResources(), "LBOK")
	Local oNo := LoadBitmap( GetResources(), "LBNO")

	// Vari·veis utilizadas para lista de filiais
	Local nx := 0
	Local nAchou := 0

	aAdd(aChaveArq,{.F.,"11","Steck Distribuidora"})
	aAdd(aChaveArq,{.F.,"03","Steck da AmazÙnia Ind˙stria ElÈtrica Ltda"})
	aAdd(aChaveArq,{.F.,"07","Steck Argentina"})
	aAdd(aChaveArq,{.F.,"09","Steck ColÙmbia"})

	If Empty(aChaveArq)
		ApMsgAlert("Nao foi possivel Localizar Empresas.")
		RestArea(aArea)
		Return aChaveArq
	EndIf

	RestArea(aArea)

	//+--------------------------------------------------------------------+
	//| Monta tela para seleÁ„o dos arquivos contidos no diretÛrio |
	//+--------------------------------------------------------------------+
	DEFINE MSDIALOG oDlg TITLE cTitulo STYLE DS_MODALFRAME From 145,0 To 445,628 OF oMainWnd PIXEL
	oDlg:lEscClose := .F.
	@ 05,15 TO 125,300 OF oDlg PIXEL
	@ 15,20 CHECKBOX oChkQual VAR lQual PROMPT "Inverte SeleÁ„o" SIZE 50, 10 OF oDlg PIXEL;
	ON CLICK (AEval(aChaveArq, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual:Refresh(.F.))
	@ 30,20 LISTBOX oQual VAR cVarQ Fields HEADER "","Codigo","Nome" SIZE;
	273,090 ON DBLCLICK (aChaveArq:=Troca(oQual:nAt,aChaveArq),oQual:Refresh()) NoScroll OF oDlg PIXEL
	oQual:SetArray(aChaveArq)
	oQual:bLine := { || {If(aChaveArq[oQual:nAt,1],oOk,oNo),aChaveArq[oQual:nAt,2],aChaveArq[oQual:nAt,3]}}
	DEFINE SBUTTON FROM 134,240 TYPE 1 ACTION IIF(MarcaOk(aChaveArq),(lSelecao := .T., oDlg:End(),.T.),.F.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 134,270 TYPE 2 ACTION (lSelecao := .F., oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED

Return aChaveArq

/*/{Protheus.doc} Troca
(long_description) FunÁ„o auxiliar: TROCA()
@type  Static Function
@author user
@since 24/11/2020
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function Troca(nIt,aArray)
	
	aArray[nIt,1] := !aArray[nIt,1]

Return aArray

/*/{Protheus.doc} MarcaOk
(long_description) FunÁ„o auxiliar: MARCAOK()
@type  Static Function
@author user
@since 24/11/2020
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function MarcaOk(aArray)
	
	Local lRet:=.F.
	Local nx:=0
	
	// Checa marcaÁıes efetuadas
	For nx := 1 To Len(aArray)
		If aArray[nx,1]
			lRet:=.T.
		EndIf
	Next
	
	// Checa se existe algum item marcado na confirmaÁ„o
	If !lRet
		MsgAlert("N„o existem Empresas marcadas")
	EndIf

Return lRet

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±≥FunáÖo	 ≥Ajusta    ≥ Autor ≥ Vitor Merguizo 		  ≥ Data ≥ 16/08/2012		≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Insere novas perguntas na tabela SX1 a Ajusta o Picture dos valores	≥±±
±±≥          ≥ no SX3                                                           	≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe e ≥ 																		≥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function Ajusta()

	Local aPergs 	:= {}

	aAdd(aPergs,{"Ano ?                        ","Ano ?                        ","Ano ?                        ","mv_ch1","C",4,0,0,"G",""                    ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	aAdd(aPergs,{"Produto de ?                 ","Produto de ?                 ","Produto de ?                 ","mv_ch2","C",15,0,0,"G",""                   ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
	aAdd(aPergs,{"Produto ate ?                ","Produto ate ?                ","Produto ate ?                ","mv_ch3","C",15,0,0,"G",""                   ,"mv_par03","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
	aAdd(aPergs,{"Grupo de ?                   ","Grupo de ?                   ","Grupo de ?                   ","mv_ch4","C",4,0,0,"G",""                    ,"mv_par04","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SBM","S","",""})
	aAdd(aPergs,{"Grupo ate ?                  ","Grupo ate ?                  ","Grupo ate ?                  ","mv_ch5","C",4,0,0,"G",""                    ,"mv_par05","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SBM","S","",""})
	aAdd(aPergs,{"Agrupamento de ?             ","Agrupamento de ?             ","Agrupamento de ?             ","mv_ch6","C",3,0,0,"G",""                    ,"mv_par06","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	aAdd(aPergs,{"Agrupamento ate ?            ","Agrupamento ate ?            ","Agrupamento ate ?            ","mv_ch7","C",3,0,0,"G",""                    ,"mv_par07","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	aAdd(aPergs,{"Cliente de ?                 ","Cliente de ?                 ","Cliente de ?                 ","mv_ch8","C",6,0,0,"G",""                    ,"mv_par08","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SA1","S","",""})
	aAdd(aPergs,{"Loja de ?                    ","Loja de ?                    ","Loja de ?                    ","mv_ch9","C",2,0,0,"G",""                    ,"mv_par09","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	aAdd(aPergs,{"Cliente ate ?                ","Cliente ate ?                ","Cliente ate ?                ","mv_cha","C",6,0,0,"G",""                    ,"mv_par10","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SA1","S","",""})
	aAdd(aPergs,{"Loja ate ?                   ","Loja ate ?                   ","Loja ate ?                   ","mv_chb","C",2,0,0,"G",""                    ,"mv_par11","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	aAdd(aPergs,{"Considera os Clientes:       ","Considera os Clientes:       ","Considera os Clientes:       ","mv_chc","C",30,0,0,"G",""                   ,"mv_par12","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	aAdd(aPergs,{"N„o Considera os Clientes:   ","N„o Considera os Clientes:   ","N„o Considera os Clientes:   ","mv_chd","C",30,0,0,"G",""                   ,"mv_par13","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	aAdd(aPergs,{"Imprime Detalhes ?           ","Imprime Detalhes ?           ","Imprime Detalhes ?           ","mv_che","N",1,0,1,"C",""                    ,"mv_par14","Cod.+Grp.+Agr.","Cod.+Grp.+Agr.","Cod.+Grp.+Agr.","","","Grp.+Agr.     ","Grp.+Agr.     ","Grp.+Agr.     ","","","Agr.","Agr.","Agr.","","","","","","","","","","","","","S","",""})
	aAdd(aPergs,{"Data de ?                    ","Data de ?                    ","Data de ?                    ","mv_chf","D",8,0,0,"G",""                    ,"mv_par15","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	aAdd(aPergs,{"Data ate ?                   ","Data ate ?                   ","Data ate ?                   ","mv_chg","D",8,0,0,"G",""                    ,"mv_par16","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})

	//AjustaSx1("STFATR03",aPergs)

Return
