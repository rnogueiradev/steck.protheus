#include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

#DEFINE AGRUP		1
#DEFINE GRUPO		2
#DEFINE CODIGO		3
#DEFINE DESCRICAO	4
#DEFINE QTD1		5
#DEFINE VLR1		6
#DEFINE MED1		7
#DEFINE QTD2		8
#DEFINE VLR2		9
#DEFINE MED2		10
#DEFINE TIPO		11

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STFLRE07   º Autor ³ Vitor Merguizo	 º Data ³  16/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Faturamento Delta conforme especificação do   º±±
±±º          ³ cliente                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STFLRE07()

	Local oReport

	Ajusta()

	oReport 	:= ReportDef()
	oReport		:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ ReportDef³ Autor ³ Microsiga	        ³ Data ³ 12.05.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Definicao do layout do Relatorio				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()
	Local oReport
	Local oSection1

	oReport := TReport():New("STFLRE07","Base Delta Preço","STFLR7",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir o faturamento em formato Delta Preço conforme parametros selecionados.")
	oReport:SetLandscape()
	oReport:nFontBody := 5

	pergunte("STFLR7",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						  ³
//³ mv_par01 | Produto de                                         ³
//³ mv_par02 | Produto até                                        ³
//³ mv_par03 | Grupo de                                           ³
//³ mv_par04 | Grupo até                                          ³
//³ mv_par05 | Agrupamento de                                     ³
//³ mv_par06 | Agrupamento até                                    ³
//³ mv_par07 | Cliente de                                         ³
//³ mv_par08 | Loja de                                            ³
//³ mv_par09 | Cliente ate                                        ³
//³ mv_par10 | Loja ate                                           ³
//³ mv_par11 | Considera os Clientes                              ³
//³ mv_par12 | Não Considera os Clientes                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oSection1 := TRSection():New(oReport,"Faturamento Líquido",{"SD2"},)
	TRCell():New(oSection1,"TIPO"		,,"Destino",,20,.F.,)
	TRCell():New(oSection1,"AGRUP"		,,"Agr.",,09,.F.,)
	TRCell():New(oSection1,"GRUPO"		,,"Grp.",,12,.F.,)
	TRCell():New(oSection1,"CODIGO"		,,"Cod.",,15,.F.,)
	TRCell():New(oSection1,"DESCRICAO"	,,"Descrição",,30,.F.,)
	TRCell():New(oSection1,"QTD1"		,,"Qtd. Y-1","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"VLR1"		,,"Vlr. Y-1","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"MED1"		,,"Med. Y-1","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"QTD2"		,,"Qtd. Y","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"VLR2"		,,"Vlr. Y","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"MED2"		,,"Med. Y","@E 9,999,999,999.99",16,.F.,)

	oSection1:Cell("QTD1"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VLR1"):SetHeaderAlign("RIGHT")
	oSection1:Cell("MED1"):SetHeaderAlign("RIGHT")
	oSection1:Cell("QTD2"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VLR2"):SetHeaderAlign("RIGHT")
	oSection1:Cell("MED2"):SetHeaderAlign("RIGHT")

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("SD2")

Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Microsiga		          ³ Data ³16.11.12 ³±±
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
/*/

Static Function ReportPrint(oReport)

	Local cTitulo		:= OemToAnsi("Base Delta Preço: Y-1 "+DTOC(mv_par14)+" a "+DTOC(mv_par15)+", Y "+DTOC(mv_par16)+" a "+DTOC(mv_par17))
	Local cClienteIN	:= ""
	Local cClienteNIN	:= ""
	Local cAlias		:= "QRY1SD2"
	Local cQuery		:= ""
	Local cQuery1		:= ""
	Local cValorSD1		:= "D1_TOTAL-D1_VALICM-D1_VALIMP5-D1_VALIMP6"
	Local cValorSD2		:= "D2_TOTAL-D2_VALICM-D2_VALIMP5-D2_VALIMP6"
	Local cQtdSD1		:= "D1_QUANT"
	Local cQtdSD2		:= "D2_QUANT"
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
	Local aDados1[16]
	Local oSection1  := oReport:Section(1)
	Local oTable

	Local cGCod	:= ""
	Local nGQ01	:= 0
	Local nGV01	:= 0
	Local nGM01	:= 0
	Local nGQ02	:= 0
	Local nGV02	:= 0
	Local nGM02	:= 0

	Local cACod	:= ""
	Local nAQ01	:= 0
	Local nAV01	:= 0
	Local nAM01	:= 0
	Local nAQ02	:= 0
	Local nAV02	:= 0
	Local nAM02	:= 0

	oSection1:Cell("TIPO")		:SetBlock( { || aDados1[TIPO]		})
	oSection1:Cell("AGRUP")		:SetBlock( { || aDados1[AGRUP]		})
	oSection1:Cell("GRUPO")		:SetBlock( { || aDados1[GRUPO]		})
	oSection1:Cell("CODIGO")	:SetBlock( { || aDados1[CODIGO]		})
	oSection1:Cell("DESCRICAO")	:SetBlock( { || aDados1[DESCRICAO]	})
	oSection1:Cell("QTD1")		:SetBlock( { || aDados1[QTD1]		})
	oSection1:Cell("VLR1")		:SetBlock( { || aDados1[VLR1]		})
	oSection1:Cell("MED1")		:SetBlock( { || aDados1[MED1]		})
	oSection1:Cell("QTD2")		:SetBlock( { || aDados1[QTD2]		})
	oSection1:Cell("VLR2")		:SetBlock( { || aDados1[VLR2]		})
	oSection1:Cell("MED2")		:SetBlock( { || aDados1[MED2]		})

	If Empty(aEmpresa)
		MsgAlert("Atenção, Não foi selecionada nenhuma Empresa.")
		Return(Nil)
	EndIf

	If !Empty(mv_par11)
		cClienteIN += StrTran(mv_par11,";","','")
	EndIf
	If !Empty(mv_par12)
		cClienteNIN += StrTran(mv_par12,";","','")
	EndIf

	If Len(aEmpresa) > 0
	
		RestArea(aAreaSM0)
	
	// Cria Estrutura
		AAdd( aStruct, { "TRB_TIP"  , "C",  1, 0 } )
		AAdd( aStruct, { "TRB_COD"  , "C", 15, 0 } )
		AAdd( aStruct, { "TRB_GRP"  , "C",  4, 0 } )
		AAdd( aStruct, { "TRB_AGR"	, "C",  3, 0 } )
		AAdd( aStruct, { "TRB_QTD1"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_VLR1"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_MED1"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_QTD2"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_VLR2"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_MED2"	, "N", 18, 2 } )
	
	// Cria fisicamente o arquivo.
		//cArqTRB := CriaTrab( aStruct, .T. ) 	//Função CriaTrab descontinuada, adicionado o oTable no lugar
		oTable := FWTemporaryTable():New("TRB") //adicionado\Ajustado
		oTable:SetFields(aStruct)				//adicionado\Ajustado
		oTable:Create()							//adicionado\Ajustado
		cArqTRB	:= oTable:GetRealName()			//adicionado\Ajustado
		cInd1 := Left( cArqTRB, 7 ) + "1"
		cInd2 := Left( cArqTRB, 7 ) + "2"
	
	// Acessa o arquivo e coloca-lo na lista de arquivos abertos.
		dbUseArea( .T., "topconn", cArqTRB, "TRB", .F., .F. )
	
	// Cria os índices.
		IndRegua( "TRB", cInd1, "TRB_TIP+TRB_COD", , , "Criando índices (Codigo)...")
		IndRegua( "TRB", cInd2, "TRB_TIP+TRB_AGR+TRB_GRP+TRB_COD", , , "Criando índices (Agrupamento+Grupo+Codigo)...")
	
	// Libera os índices.
		dbClearIndex()
	
	// Agrega a lista dos índices da tabela (arquivo).
		dbSetIndex( cInd1 + OrdBagExt() )
		dbSetIndex( cInd2 + OrdBagExt() )
	
		For _n := 1 to Len(aEmpresa)
			If aEmpresa[_n][1]
				AADD(aEmpQry,aEmpresa[_n][2])
			EndIf
		Next _n
	
		For _n := 1 to 2
			
			If _n = 1
				dDataIni := mv_par14
				dDataFim := mv_par15
			Else
				dDataIni := mv_par16
				dDataFim := mv_par17
			EndIf
			
			cQuery := " SELECT CASE WHEN GVEN = 'BACK  ' THEN '4' WHEN GVEN = 'SC' THEN '3' WHEN SUBSTR(CF,1,1) IN ('3','7') THEN '2' ELSE '1' END TIP,COD,B1_GRUPO GRP, BM_XAGRUP AGR, SUM(VALOR)VALOR, SUM(QUANT)QUANT FROM ("
			
			For _i := 1 to Len(aEmpQry)
				If _i > 1
					cQuery += " UNION ALL"
				EndIf
				cQuery += " SELECT A1_GRPVEN GVEN,D2_COD COD,D2_CF CF,D2_CLIENTE CLI,D2_LOJA LOJ,"+cValorSD2+" VALOR, "+cQtdSD2+" QUANT FROM SD2"+aEmpQry[_i]+"0 D2 LEFT JOIN SA1"+aEmpQry[_i]+"0 A1 ON "
				cQuery += " A1_FILIAL = '"+xFilial("SA1")+"' AND D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND A1.D_E_L_E_T_ = ' ' WHERE D2_FILIAL <> ' ' "
				cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
				cQuery += " AND D2_TIPO <> 'D' AND D2.D_E_L_E_T_ = ' ' "
				cQuery += " UNION ALL"
				cQuery += " SELECT A1_GRPVEN,D1_COD,D1_CF,D1_FORNECE,D1_LOJA,("+cValorSD1+")*-1, ("+cQtdSD1+")*-1 FROM SD1"+aEmpQry[_i]+"0 D1 LEFT JOIN SA1"+aEmpQry[_i]+"0 A1 ON "
				cQuery += " A1_FILIAL = '"+xFilial("SA1")+"' AND D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND A1.D_E_L_E_T_ = ' ' WHERE D1_FILIAL <> ' ' "
				cQuery += " AND D1_DTDIGIT BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
				cQuery += " AND D1_TIPO = 'D' AND D1.D_E_L_E_T_ = ' ' "
				cQuery += " UNION ALL"
				cQuery += " SELECT 'BACK  'GVEN,EE8_COD_I COD,'BACK'CF,' 'Cli,' 'Loj,ROUND(SUM(EE8_PRCTOT*(CASE WHEN NVL(M2_MOEDA2,1) > 0 THEN M2_MOEDA2 ELSE 1 END)),2) VALOR, ROUND(SUM(EE8_SLDINI),2)  "
				cQuery += " FROM EE8"+aEmpQry[_i]+"0 EE8"
				cQuery += " INNER JOIN EE7"+aEmpQry[_i]+"0 EE7 ON EE7_FILIAL = EE8_FILIAL AND EE7_PEDIDO = EE8_PEDIDO AND EE7.D_E_L_E_T_ = ' '"
				cQuery += " LEFT JOIN SM2"+aEmpQry[_i]+"0 SM2 ON M2_DATA = EE7_DTSLCR AND SM2.D_E_L_E_T_ = ' '"
				cQuery += " WHERE"
				cQuery += " EE8_FILIAL <> ' ' AND"
				cQuery += " EE7_DTSLCR BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' AND"
				cQuery += " EE7_PEDFAT = ' ' AND"
				cQuery += " EE7_FATURA = ' ' AND"
				cQuery += " EE8.D_E_L_E_T_ = ' '"
				cQuery += " GROUP BY EE8_COD_I"
			Next _i
			cQuery += " )NF LEFT JOIN SB1010 B1 ON B1_COD = NF.COD AND B1.D_E_L_E_T_ = ' ' LEFT JOIN SBM010 BM ON B1_GRUPO = BM_GRUPO AND BM.D_E_L_E_T_ = ' '"
			cQuery1 := ""
			If !Empty(mv_par02)
				cQuery1 += " COD >= '"+mv_par01+"' AND"
				cQuery1 += " COD <= '"+mv_par02+"' AND"
			EndIf
			If !Empty(mv_par04)
				cQuery1 += " B1_GRUPO >= '"+mv_par03+"' AND"
				cQuery1 += " B1_GRUPO <= '"+mv_par04+"' AND"
			EndIf
			If !Empty(mv_par06)
				cQuery1 += " BM_XAGRUP >= '"+mv_par05+"' AND"
				cQuery1 += " BM_XAGRUP <= '"+mv_par06+"' AND"
			EndIf
			If !Empty(mv_par09) .Or. !Empty(mv_par10)
				cQuery1 += " CLI >= '"+mv_par07+"' AND"
				cQuery1 += " LOJ >= '"+mv_par08+"' AND"
				cQuery1 += " CLI <= '"+mv_par09+"' AND"
				cQuery1 += " LOJ <= '"+mv_par10+"' AND"
			EndIf
			If !Empty(mv_par11)
				cQuery1 += " CLI IN ('"+cClienteIN+"') AND"
			EndIf
			If !Empty(mv_par12)
				cQuery1 += " CLI NOT IN ('"+cClienteNIN+"') AND"
			EndIf
	
			cQuery	+= " WHERE CF IN ('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102','1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','BACK') AND "
			cQuery	+= " GVEN <> 'ST'"
	
			If Len(cQuery1) > 1
				cQuery	+= " AND "+SUBS(cQuery1,1,Len(cQuery1)-4)
			EndIf
			
			cQuery += " GROUP BY CASE WHEN GVEN = 'BACK  ' THEN '4' WHEN GVEN = 'SC' THEN '3' WHEN SUBSTR(CF,1,1) IN ('3','7') THEN '2' ELSE '1' END,BM_XAGRUP,B1_GRUPO,COD ORDER BY BM_XAGRUP,B1_GRUPO,COD"
			
			cQuery := ChangeQuery(cQuery)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha Alias se estiver em Uso ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Area de Trabalho executando a Query ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.T.)
	
			TCSetField(cAlias,"VALOR","N",18,2)
			TCSetField(cAlias,"QUANT","N",18,2)
	
			DbSelectArea(cAlias)
			(cAlias)->(dbGoTop())
	
			While (cAlias)->(!Eof())
		
				DbSelectArea("TRB")
				TRB->(dbSetOrder(1))
				If TRB->(dbSeek( (cAlias)->(TIP+COD) ))
					TRB->(RecLock("TRB",.F.))
				Else
					TRB->(RecLock("TRB",.T.))
					TRB->TRB_TIP := (cAlias)->TIP
					TRB->TRB_COD := (cAlias)->COD
					TRB->TRB_GRP := (cAlias)->GRP
					TRB->TRB_AGR := IIF(Len(allTrim((cAlias)->AGR))=2,(cAlias)->AGR,IIF(Len(allTrim((cAlias)->AGR))=1,"0"+(cAlias)->AGR,(cAlias)->AGR))
				EndIf
				If _n = 1
					TRB->TRB_QTD1 := (cAlias)->QUANT
					TRB->TRB_VLR1 := (cAlias)->VALOR
					TRB->TRB_MED1 := IIf((cAlias)->QUANT>0,(cAlias)->VALOR/(cAlias)->QUANT,0)
				Else
					TRB->TRB_QTD2 := (cAlias)->QUANT
					TRB->TRB_VLR2 := (cAlias)->VALOR
					TRB->TRB_MED2 := IIf((cAlias)->QUANT>0,(cAlias)->VALOR/(cAlias)->QUANT,0)
				EndIf
				(cAlias)->(dbSkip())
			EndDo
	
			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif
	
		Next _n
	
	EndIf

	oReport:SetMeter(0)

	oReport:SetTitle(cTitulo)

	aFill(aDados1,nil)
	oSection1:Init()

	n := 0

	TRB->(dbSetOrder(2))
	TRB->(dbGoTop())
	If TRB->(dbSeek('1'))
		While TRB->(!Eof()) .AND. TRB->TRB_TIP = '1'
			If TRB->TRB_TIP = '1'
				n++
			
				If n>1 .And. cGCod <> TRB->TRB_GRP
				
					DbSelectArea("SBM")
					DbSetOrder(1)
					DbSeek(xFilial("SBM") + Alltrim(cGCod) )
				
					aDados1[AGRUP]		:= ""
					aDados1[GRUPO]		:= ""
					aDados1[CODIGO]		:= cGCod
					aDados1[DESCRICAO]	:= SBM->BM_DESC
					aDados1[QTD1]		:= nGQ01
					aDados1[VLR1]		:= nGV01
					aDados1[MED1]		:= nGM01
					aDados1[QTD2]		:= nGQ02
					aDados1[VLR2]		:= nGV02
					aDados1[MED2]		:= nGM02
					aDados1[TIPO]		:= "Brasil"
					
					nGQ01 := 0
					nGV01 := 0
					nGM01 := 0
					nGQ02 := 0
					nGV02 := 0
					nGM02 := 0
					
					If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
							oReport:SkipLine()
							oReport:ThinLine()
							oSection1:PrintLine()
							aFill(aDados1,nil)
							oReport:ThinLine()
							oReport:SkipLine()
					EndIf
				
				EndIf
			
				If n>1 .And. cACod <> TRB->TRB_AGR
				
					DbSelectArea("SX5")
					DbSetOrder(1)
					DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
				
					aDados1[AGRUP]		:= ""
					aDados1[GRUPO]		:= ""
					aDados1[CODIGO]		:= cACod
					aDados1[DESCRICAO]	:= IIF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
					aDados1[QTD1]		:= nAQ01
					aDados1[VLR1]		:= nAV01
					aDados1[MED1]		:= nAM01
					aDados1[QTD2]		:= nAQ02
					aDados1[VLR2]		:= nAV02
					aDados1[MED2]		:= nAM02
					aDados1[TIPO]		:= "Brasil"
					
					nAQ01 := 0
					nAV01 := 0
					nAM01 := 0
					nAQ02 := 0
					nAV02 := 0
					nAM02 := 0
					
					If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
						oReport:SkipLine()
						oReport:ThinLine()
						oSection1:PrintLine()
						aFill(aDados1,nil)
						oReport:ThinLine()
						oReport:SkipLine()
					EndIf
				EndIf
			
				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1") + TRB->TRB_COD )
			
				aDados1[AGRUP]		:= TRB->TRB_AGR
				aDados1[GRUPO]		:= TRB->TRB_GRP
				aDados1[CODIGO]		:= TRB->TRB_COD
				aDados1[DESCRICAO]	:= SB1->B1_DESC
				aDados1[QTD1]		:= TRB->TRB_QTD1
				aDados1[VLR1]		:= TRB->TRB_VLR1
				aDados1[MED1]		:= TRB->TRB_MED1
				aDados1[QTD2]		:= TRB->TRB_QTD2
				aDados1[VLR2]		:= TRB->TRB_VLR2
				aDados1[MED2]		:= TRB->TRB_MED2
				aDados1[TIPO]		:= "Brasil"
			
				If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0
				
					cGCod	:= TRB->TRB_GRP
					nGQ01	+= TRB->TRB_QTD1
					nGV01	+= TRB->TRB_VLR1
					nGM01	:= IIF(nGQ01>0,nGV01/nGQ01,0)
					nGQ02	+= TRB->TRB_QTD2
					nGV02	+= TRB->TRB_VLR2
					nGM02	:= IIF(nGQ02>0,nGV02/nGQ02,0)
					
					cACod	:= TRB->TRB_AGR
					nAQ01	+= TRB->TRB_QTD1
					nAV01	+= TRB->TRB_VLR1
					nAM01	:= IIF(nAQ01>0,nAV01/nAQ01,0)
					nAQ02	+= TRB->TRB_QTD2
					nAV02	+= TRB->TRB_VLR2
					nAM02	:= IIF(nAQ02>0,nAV02/nAQ02,0)
				
					oSection1:PrintLine()
					aFill(aDados1,nil)

				EndIf
			EndIf
			TRB->(dbSkip())
		EndDo
	
		If (nGV01+nGV02)>0 .Or. (nGQ01+nGQ02)>0
		
			DbSelectArea("SBM")
			DbSetOrder(1)
			DbSeek(xFilial("SBM") + Alltrim(cGCod) )
		
			aDados1[AGRUP]		:= ""
			aDados1[GRUPO]		:= ""
			aDados1[CODIGO]		:= cGCod
			aDados1[DESCRICAO]	:= SBM->BM_DESC
			aDados1[QTD1]		:= nGQ01
			aDados1[VLR1]		:= nGV01
			aDados1[MED1]		:= nGM01
			aDados1[QTD2]		:= nGQ02
			aDados1[VLR2]		:= nGV02
			aDados1[MED2]		:= nGM02
			aDados1[TIPO]		:= "Brasil"
		
			nGQ01 := 0
			nGV01 := 0
			nGM01 := 0
			nGQ02 := 0
			nGV02 := 0
			nGM02 := 0

			If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
				oReport:SkipLine()
				oReport:ThinLine()
				oSection1:PrintLine()
				aFill(aDados1,nil)
				oReport:ThinLine()
				oReport:SkipLine()
			EndIf
		EndIf
	
		If (nAV01+nAV02)>0 .Or. (nAQ01+nAQ02)>0
		
			DbSelectArea("SX5")
			DbSetOrder(1)
			DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
		
			aDados1[AGRUP]		:= ""
			aDados1[GRUPO]		:= ""
			aDados1[CODIGO]		:= cACod
			aDados1[DESCRICAO]	:= IF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
			aDados1[QTD1]		:= nAQ01
			aDados1[VLR1]		:= nAV01
			aDados1[MED1]		:= nAM01
			aDados1[QTD2]		:= nAQ02
			aDados1[VLR2]		:= nAV02
			aDados1[MED2]		:= nAM02
			aDados1[TIPO]		:= "Brasil"
			
			nAQ01 := 0
			nAV01 := 0
			nAM01 := 0
			nAQ02 := 0
			nAV02 := 0
			nAM02 := 0
			
			If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
				oReport:SkipLine()
				oReport:ThinLine()
				oSection1:PrintLine()
				aFill(aDados1,nil)
				oReport:ThinLine()
				oReport:SkipLine()
			EndIf
		EndIf
	
	EndIf

	oSection1:Finish()

	cGCod := ""
	nGQ01 := 0
	nGV01 := 0
	nGM01 := 0
	nGQ02 := 0
	nGV02 := 0
	nGM02 := 0

	cACod := ""
	nAQ01 := 0
	nAV01 := 0
	nAM01 := 0
	nAQ02 := 0
	nAV02 := 0
	nAM02 := 0
	
	n := 0

	aFill(aDados1,nil)
	oSection1:Init()

	TRB->(dbSetOrder(2))
	TRB->(dbGoTop())
	If TRB->(dbSeek('2'))
		While TRB->(!Eof()) .AND. TRB->TRB_TIP = '2'
			If TRB->TRB_TIP = '2'
				n++
			
				If n>1 .And. cGCod <> TRB->TRB_GRP
				
					DbSelectArea("SBM")
					DbSetOrder(1)
					DbSeek(xFilial("SBM") + Alltrim(cGCod) )
				
					aDados1[AGRUP]		:= ""
					aDados1[GRUPO]		:= ""
					aDados1[CODIGO]		:= cGCod
					aDados1[DESCRICAO]	:= SBM->BM_DESC
					aDados1[QTD1]		:= nGQ01
					aDados1[VLR1]		:= nGV01
					aDados1[MED1]		:= nGM01
					aDados1[QTD2]		:= nGQ02
					aDados1[VLR2]		:= nGV02
					aDados1[MED2]		:= nGM02
					aDados1[TIPO]		:= "Exportação"
				
					nGQ01 := 0
					nGV01 := 0
					nGM01 := 0
					nGQ02 := 0
					nGV02 := 0
					nGM02 := 0
					
					If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
						oReport:SkipLine()
						oReport:ThinLine()
						oSection1:PrintLine()
						aFill(aDados1,nil)
						oReport:ThinLine()
						oReport:SkipLine()
					EndIf
				EndIf
			
				If n>1 .And. cACod <> TRB->TRB_AGR
				
					DbSelectArea("SX5")
					DbSetOrder(1)
					DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
				
					aDados1[AGRUP]		:= ""
					aDados1[GRUPO]		:= ""
					aDados1[CODIGO]		:= cACod
					aDados1[DESCRICAO]	:= IF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
					aDados1[QTD1]		:= nAQ01
					aDados1[VLR1]		:= nAV01
					aDados1[MED1]		:= nAM01
					aDados1[QTD2]		:= nAQ02
					aDados1[VLR2]		:= nAV02
					aDados1[MED2]		:= nAM02
					aDados1[TIPO]		:= "Exportação"
				
					nAQ01 := 0
					nAV01 := 0
					nAM01 := 0
					nAQ02 := 0
					nAV02 := 0
					nAM02 := 0
					
					If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
						oReport:SkipLine()
						oReport:ThinLine()
						oSection1:PrintLine()
						aFill(aDados1,nil)
						oReport:ThinLine()
						oReport:SkipLine()
					EndIf
				EndIf
			
				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1") + TRB->TRB_COD )
			
				aDados1[AGRUP]		:= TRB->TRB_AGR
				aDados1[GRUPO]		:= TRB->TRB_GRP
				aDados1[CODIGO]		:= TRB->TRB_COD
				aDados1[DESCRICAO]	:= SB1->B1_DESC
				aDados1[QTD1]		:= TRB->TRB_QTD1
				aDados1[VLR1]		:= TRB->TRB_VLR1
				aDados1[MED1]		:= TRB->TRB_MED1
				aDados1[QTD2]		:= TRB->TRB_QTD2
				aDados1[VLR2]		:= TRB->TRB_VLR2
				aDados1[MED2]		:= TRB->TRB_MED2
				aDados1[TIPO]		:= "Exportação"
			
				If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0
				
					cGCod	:= TRB->TRB_GRP
					nGQ01	+= TRB->TRB_QTD1
					nGV01	+= TRB->TRB_VLR1
					nGM01	:= IIF(nGQ01>0,nGV01/nGQ01,0)
					nGQ02	+= TRB->TRB_QTD2
					nGV02	+= TRB->TRB_VLR2
					nGM02	:= IIF(nGQ02>0,nGV02/nGQ02,0)
					
					cACod	:= TRB->TRB_AGR
					nAQ01	+= TRB->TRB_QTD1
					nAV01	+= TRB->TRB_VLR1
					nAM01	:= IIF(nAQ01>0,nAV01/nAQ01,0)
					nAQ02	+= TRB->TRB_QTD2
					nAV02	+= TRB->TRB_VLR2
					nAM02	:= IIF(nAQ02>0,nAV02/nAQ02,0)
					
					oSection1:PrintLine()
					aFill(aDados1,nil)

				EndIf
			EndIf
			TRB->(dbSkip())
		EndDo
	
		If (nGV01+nGV02)>0 .Or. (nGQ01+nGQ02)>0
		
			DbSelectArea("SBM")
			DbSetOrder(1)
			DbSeek(xFilial("SBM") + Alltrim(cGCod) )
		
			aDados1[AGRUP]		:= ""
			aDados1[GRUPO]		:= ""
			aDados1[CODIGO]		:= cGCod
			aDados1[DESCRICAO]	:= SBM->BM_DESC
			aDados1[QTD1]		:= nGQ01
			aDados1[VLR1]		:= nGV01
			aDados1[MED1]		:= nGM01
			aDados1[QTD2]		:= nGQ02
			aDados1[VLR2]		:= nGV02
			aDados1[MED2]		:= nGM02
			aDados1[TIPO]		:= "Exportação"
			
			nGQ01 := 0
			nGV01 := 0
			nGM01 := 0
			nGQ02 := 0
			nGV02 := 0
			nGM02 := 0
			
			If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
				oReport:SkipLine()
				oReport:ThinLine()
				oSection1:PrintLine()
				aFill(aDados1,nil)
				oReport:ThinLine()
				oReport:SkipLine()
			EndIf
		EndIf
	
		If (nAV01+nAV02)>0 .Or. (nAQ01+nAQ02)>0
		
			DbSelectArea("SX5")
			DbSetOrder(1)
			DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
		
			aDados1[AGRUP]		:= ""
			aDados1[GRUPO]		:= ""
			aDados1[CODIGO]		:= cACod
			aDados1[DESCRICAO]	:= IF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
			aDados1[QTD1]		:= nAQ01
			aDados1[VLR1]		:= nAV01
			aDados1[MED1]		:= nAM01
			aDados1[QTD2]		:= nAQ02
			aDados1[VLR2]		:= nAV02
			aDados1[MED2]		:= nAM02
			aDados1[TIPO]		:= "Exportação"
		
			nAQ01 := 0
			nAV01 := 0
			nAM01 := 0
			nAQ02 := 0
			nAV02 := 0
			nAM02 := 0
			
			If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
				oReport:SkipLine()
				oReport:ThinLine()
				oSection1:PrintLine()
				aFill(aDados1,nil)
				oReport:ThinLine()
				oReport:SkipLine()
			EndIf
		EndIf
	
	EndIf

	oSection1:Finish()

	cGCod := ""
	nGQ01 := 0
	nGV01 := 0
	nGM01 := 0
	nGQ02 := 0
	nGV02 := 0
	nGM02 := 0

	cACod := ""
	nAQ01 := 0
	nAV01 := 0
	nAM01 := 0
	nAQ02 := 0
	nAV02 := 0
	nAM02 := 0
	
	n := 0

	aFill(aDados1,nil)
	oSection1:Init()

	TRB->(dbSetOrder(2))
	TRB->(dbGoTop())
	If TRB->(dbSeek('3'))
		While TRB->(!Eof()) .AND. TRB->TRB_TIP = '3'
			If TRB->TRB_TIP = '3'
				n++
			
				If n>1 .And. cGCod <> TRB->TRB_GRP
				
					DbSelectArea("SBM")
					DbSetOrder(1)
					DbSeek(xFilial("SBM") + Alltrim(cGCod) )
				
					aDados1[AGRUP]		:= ""
					aDados1[GRUPO]		:= ""
					aDados1[CODIGO]		:= cGCod
					aDados1[DESCRICAO]	:= SBM->BM_DESC
					aDados1[QTD1]		:= nGQ01
					aDados1[VLR1]		:= nGV01
					aDados1[MED1]		:= nGM01
					aDados1[QTD2]		:= nGQ02
					aDados1[VLR2]		:= nGV02
					aDados1[MED2]		:= nGM02
					aDados1[TIPO]		:= "Schneider"
				
					nGQ01 := 0
					nGV01 := 0
					nGM01 := 0
					nGQ02 := 0
					nGV02 := 0
					nGM02 := 0
					
					If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
						oReport:SkipLine()
						oReport:ThinLine()
						oSection1:PrintLine()
						aFill(aDados1,nil)
						oReport:ThinLine()
						oReport:SkipLine()
					EndIf
				EndIf
			
				If n>1 .And. cACod <> TRB->TRB_AGR
				
					DbSelectArea("SX5")
					DbSetOrder(1)
					DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
				
					aDados1[AGRUP]		:= ""
					aDados1[GRUPO]		:= ""
					aDados1[CODIGO]		:= cACod
					aDados1[DESCRICAO]	:= IF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
					aDados1[QTD1]		:= nAQ01
					aDados1[VLR1]		:= nAV01
					aDados1[MED1]		:= nAM01
					aDados1[QTD2]		:= nAQ02
					aDados1[VLR2]		:= nAV02
					aDados1[MED2]		:= nAM02
					aDados1[TIPO]		:= "Schneider"
				
					nAQ01 := 0
					nAV01 := 0
					nAM01 := 0
					nAQ02 := 0
					nAV02 := 0
					nAM02 := 0
					
					If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
						oReport:SkipLine()
						oReport:ThinLine()
						oSection1:PrintLine()
						aFill(aDados1,nil)
						oReport:ThinLine()
						oReport:SkipLine()
					EndIf
				EndIf
			
				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1") + TRB->TRB_COD )
			
				aDados1[AGRUP]		:= TRB->TRB_AGR
				aDados1[GRUPO]		:= TRB->TRB_GRP
				aDados1[CODIGO]		:= TRB->TRB_COD
				aDados1[DESCRICAO]	:= SB1->B1_DESC
				aDados1[QTD1]		:= TRB->TRB_QTD1
				aDados1[VLR1]		:= TRB->TRB_VLR1
				aDados1[MED1]		:= TRB->TRB_MED1
				aDados1[QTD2]		:= TRB->TRB_QTD2
				aDados1[VLR2]		:= TRB->TRB_VLR2
				aDados1[MED2]		:= TRB->TRB_MED2
				aDados1[TIPO]		:= "Schneider"
			
				If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0
				
					cGCod	:= TRB->TRB_GRP
					nGQ01	+= TRB->TRB_QTD1
					nGV01	+= TRB->TRB_VLR1
					nGM01	:= IIF(nGQ01>0,nGV01/nGQ01,0)
					nGQ02	+= TRB->TRB_QTD2
					nGV02	+= TRB->TRB_VLR2
					nGM02	:= IIF(nGQ02>0,nGV02/nGQ02,0)
					
					cACod	:= TRB->TRB_AGR
					nAQ01	+= TRB->TRB_QTD1
					nAV01	+= TRB->TRB_VLR1
					nAM01	:= IIF(nAQ01>0,nAV01/nAQ01,0)
					nAQ02	+= TRB->TRB_QTD2
					nAV02	+= TRB->TRB_VLR2
					nAM02	:= IIF(nAQ02>0,nAV02/nAQ02,0)
					
					oSection1:PrintLine()
					aFill(aDados1,nil)

				EndIf
			EndIf
			TRB->(dbSkip())
		EndDo
	
		If (nGV01+nGV02)>0 .Or. (nGQ01+nGQ02)>0
		
			DbSelectArea("SBM")
			DbSetOrder(1)
			DbSeek(xFilial("SBM") + Alltrim(cGCod) )
		
			aDados1[AGRUP]		:= ""
			aDados1[GRUPO]		:= ""
			aDados1[CODIGO]		:= cGCod
			aDados1[DESCRICAO]	:= SBM->BM_DESC
			aDados1[QTD1]		:= nGQ01
			aDados1[VLR1]		:= nGV01
			aDados1[MED1]		:= nGM01
			aDados1[QTD2]		:= nGQ02
			aDados1[VLR2]		:= nGV02
			aDados1[MED2]		:= nGM02
			aDados1[TIPO]		:= "Schneider"

			nGQ01 := 0
			nGV01 := 0
			nGM01 := 0
			nGQ02 := 0
			nGV02 := 0
			nGM02 := 0
			
			If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
				oReport:SkipLine()
				oReport:ThinLine()
				oSection1:PrintLine()
				aFill(aDados1,nil)
				oReport:ThinLine()
				oReport:SkipLine()
			EndIf
		EndIf
	
		If (nAV01+nAV02)>0 .Or. (nAQ01+nAQ02)>0
		
			DbSelectArea("SX5")
			DbSetOrder(1)
			DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
		
			aDados1[AGRUP]		:= ""
			aDados1[GRUPO]		:= ""
			aDados1[CODIGO]		:= cACod
			aDados1[DESCRICAO]	:= IIF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
			aDados1[QTD1]		:= nAQ01
			aDados1[VLR1]		:= nAV01
			aDados1[MED1]		:= nAM01
			aDados1[QTD2]		:= nAQ02
			aDados1[VLR2]		:= nAV02
			aDados1[MED2]		:= nAM02
			aDados1[TIPO]		:= "Schneider"
		
			nAQ01 := 0
			nAV01 := 0
			nAM01 := 0
			nAQ02 := 0
			nAV02 := 0
			nAM02 := 0
			
			If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
				oReport:SkipLine()
				oReport:ThinLine()
				oSection1:PrintLine()
				aFill(aDados1,nil)
				oReport:ThinLine()
				oReport:SkipLine()
			EndIf
		EndIf
	
	EndIf

	oSection1:Finish()

	cGCod := ""
	nGQ01 := 0
	nGV01 := 0
	nGM01 := 0
	nGQ02 := 0
	nGV02 := 0
	nGM02 := 0

	cACod := ""
	nAQ01 := 0
	nAV01 := 0
	nAM01 := 0
	nAQ02 := 0
	nAV02 := 0
	nAM02 := 0
	
	n := 0

	aFill(aDados1,nil)
	oSection1:Init()

	TRB->(dbSetOrder(2))
	TRB->(dbGoTop())
	If TRB->(dbSeek('4'))
		While TRB->(!Eof()) .AND. TRB->TRB_TIP = '4'
			If TRB->TRB_TIP = '4'
				n++
			
				If n>1 .And. cGCod <> TRB->TRB_GRP
				
					DbSelectArea("SBM")
					DbSetOrder(1)
					DbSeek(xFilial("SBM") + Alltrim(cGCod) )
				
					aDados1[AGRUP]		:= ""
					aDados1[GRUPO]		:= ""
					aDados1[CODIGO]		:= cGCod
					aDados1[DESCRICAO]	:= SBM->BM_DESC
					aDados1[QTD1]		:= nGQ01
					aDados1[VLR1]		:= nGV01
					aDados1[MED1]		:= nGM01
					aDados1[QTD2]		:= nGQ02
					aDados1[VLR2]		:= nGV02
					aDados1[MED2]		:= nGM02
					aDados1[TIPO]		:= "Back To Back"
				
					nGQ01 := 0
					nGV01 := 0
					nGM01 := 0
					nGQ02 := 0
					nGV02 := 0
					nGM02 := 0
					
					If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
						oReport:SkipLine()
						oReport:ThinLine()
						oSection1:PrintLine()
						aFill(aDados1,nil)
						oReport:ThinLine()
						oReport:SkipLine()
					EndIf
				EndIf
			
				If n>1 .And. cACod <> TRB->TRB_AGR
				
					DbSelectArea("SX5")
					DbSetOrder(1)
					DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
				
					aDados1[AGRUP]		:= ""
					aDados1[GRUPO]		:= ""
					aDados1[CODIGO]		:= cACod
					aDados1[DESCRICAO]	:= IF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
					aDados1[QTD1]		:= nAQ01
					aDados1[VLR1]		:= nAV01
					aDados1[MED1]		:= nAM01
					aDados1[QTD2]		:= nAQ02
					aDados1[VLR2]		:= nAV02
					aDados1[MED2]		:= nAM02
					aDados1[TIPO]		:= "Back To Back"
				
					nAQ01 := 0
					nAV01 := 0
					nAM01 := 0
					nAQ02 := 0
					nAV02 := 0
					nAM02 := 0
					
					If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
						oReport:SkipLine()
						oReport:ThinLine()
						oSection1:PrintLine()
						aFill(aDados1,nil)
						oReport:ThinLine()
						oReport:SkipLine()
					EndIf
				EndIf
			
				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1") + TRB->TRB_COD )
			
				aDados1[AGRUP]		:= TRB->TRB_AGR
				aDados1[GRUPO]		:= TRB->TRB_GRP
				aDados1[CODIGO]		:= TRB->TRB_COD
				aDados1[DESCRICAO]	:= SB1->B1_DESC
				aDados1[QTD1]		:= TRB->TRB_QTD1
				aDados1[VLR1]		:= TRB->TRB_VLR1
				aDados1[MED1]		:= TRB->TRB_MED1
				aDados1[QTD2]		:= TRB->TRB_QTD2
				aDados1[VLR2]		:= TRB->TRB_VLR2
				aDados1[MED2]		:= TRB->TRB_MED2
				aDados1[TIPO]		:= "Back To Back"
			
				If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0
				
					cGCod	:= TRB->TRB_GRP
					nGQ01	+= TRB->TRB_QTD1
					nGV01	+= TRB->TRB_VLR1
					nGM01	:= IIF(nGQ01>0,nGV01/nGQ01,0)
					nGQ02	+= TRB->TRB_QTD2
					nGV02	+= TRB->TRB_VLR2
					nGM02	:= IIF(nGQ02>0,nGV02/nGQ02,0)
					
					cACod	:= TRB->TRB_AGR
					nAQ01	+= TRB->TRB_QTD1
					nAV01	+= TRB->TRB_VLR1
					nAM01	:= IIF(nAQ01>0,nAV01/nAQ01,0)
					nAQ02	+= TRB->TRB_QTD2
					nAV02	+= TRB->TRB_VLR2
					nAM02	:= IIF(nAQ02>0,nAV02/nAQ02,0)
					
					oSection1:PrintLine()
					aFill(aDados1,nil)
					
				EndIf
			EndIf
			TRB->(dbSkip())
		EndDo
	
		If (nGV01+nGV02)>0 .Or. (nGQ01+nGQ02)>0
		
			DbSelectArea("SBM")
			DbSetOrder(1)
			DbSeek(xFilial("SBM") + Alltrim(cGCod) )
		
			aDados1[AGRUP]		:= ""
			aDados1[GRUPO]		:= ""
			aDados1[CODIGO]		:= cGCod
			aDados1[DESCRICAO]	:= SBM->BM_DESC
			aDados1[QTD1]		:= nGQ01
			aDados1[VLR1]		:= nGV01
			aDados1[MED1]		:= nGM01
			aDados1[QTD2]		:= nGQ02
			aDados1[VLR2]		:= nGV02
			aDados1[MED2]		:= nGM02
			aDados1[TIPO]		:= "Back To Back"
		
			nGQ01 := 0
			nGV01 := 0
			nGM01 := 0
			nGQ02 := 0
			nGV02 := 0
			nGM02 := 0
			
			If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
				oReport:SkipLine()
				oReport:ThinLine()
				oSection1:PrintLine()
				aFill(aDados1,nil)
				oReport:ThinLine()
				oReport:SkipLine()
			EndIf
		EndIf
	
		If (nAV01+nAV02)>0 .Or. (nAQ01+nAQ02)>0
		
			DbSelectArea("SX5")
			DbSetOrder(1)
			DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
		
			aDados1[AGRUP]		:= ""
			aDados1[GRUPO]		:= ""
			aDados1[CODIGO]		:= cACod
			aDados1[DESCRICAO]	:= IIF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
			aDados1[QTD1]		:= nAQ01
			aDados1[VLR1]		:= nAV01
			aDados1[MED1]		:= nAM01
			aDados1[QTD2]		:= nAQ02
			aDados1[VLR2]		:= nAV02
			aDados1[MED2]		:= nAM02
			aDados1[TIPO]		:= "Back To Back"
		
			nAQ01 := 0
			nAV01 := 0
			nAM01 := 0
			nAQ02 := 0
			nAV02 := 0
			nAM02 := 0
			
			If mv_par18 > 1 .Or. aDados1[VLR1] > 0 .And. aDados1[VLR2] > 0 .And. mv_par13 = 1
				oReport:SkipLine()
				oReport:ThinLine()
				oSection1:PrintLine()
				aFill(aDados1,nil)
				oReport:ThinLine()
				oReport:SkipLine()
			EndIf
		EndIf
	
	EndIf

	oSection1:Finish()


	TRB->(DbCLoseArea())
	FErase(cArqTRB+OrdBagExt())
	FErase(cArqTRB+GetDBExtension())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MARKFILE ºAutor  ³ Vitor Merguizo     º Data ³  08/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função auxiliar para seleção de Arquivos                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MarkFile()

	Local aArea		:= SM0->(GetArea())
	Local aChaveArq := {}
	Local lSelecao	:= .T.
	Local cTitulo 	:= "Seleção de Empresas para Geração de Relatorio: "
	Local cEmpresa	:= ""
	Local bCondicao := {|| .T.}

// Variáveis utilizadas na seleção de categorias
	Local oChkQual,lQual,oQual,cVarQ

// Carrega bitmaps
	Local oOk := LoadBitmap( GetResources(), "LBOK")
	Local oNo := LoadBitmap( GetResources(), "LBNO")

// Variáveis utilizadas para lista de filiais
	Local nx := 0
	Local nAchou := 0

	DbSelectArea("SM0")
	DbSetOrder(1)
	SM0->(DbGoTop())

	While SM0->(!Eof())
		If SM0->M0_CODIGO <> cEmpresa .And. SM0->M0_CODIGO <> "06" //Não Carrega a EMpresa 06
		//+--------------------------------------------------------------------+
		//| aChaveArq - Contem os arquivos que serão exibidos para seleção |
		//+--------------------------------------------------------------------+
			AADD(aChaveArq,{.F.,SM0->M0_CODIGO,SM0->M0_NOMECOM})
		EndIf
		cEmpresa := SM0->M0_CODIGO
		SM0->(dbSkip())
	EndDo

	If Empty(aChaveArq)
		ApMsgAlert("Nao foi possivel Localizar Empresas.")
		RestArea(aArea)
		Return aChaveArq
	EndIf

	RestArea(aArea)

//+--------------------------------------------------------------------+
//| Monta tela para seleção dos arquivos contidos no diretório |
//+--------------------------------------------------------------------+
	DEFINE MSDIALOG oDlg TITLE cTitulo STYLE DS_MODALFRAME From 145,0 To 445,628 OF oMainWnd PIXEL
	oDlg:lEscClose := .F.
	@ 05,15 TO 125,300 OF oDlg PIXEL
	@ 15,20 CHECKBOX oChkQual VAR lQual PROMPT "Inverte Seleção" SIZE 50, 10 OF oDlg PIXEL;
		ON CLICK (AEval(aChaveArq, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual:Refresh(.F.))
	@ 30,20 LISTBOX oQual VAR cVarQ Fields HEADER "","Codigo","Nome" SIZE;
		273,090 ON DBLCLICK (aChaveArq:=Troca(oQual:nAt,aChaveArq),oQual:Refresh()) NoScroll OF oDlg PIXEL
	oQual:SetArray(aChaveArq)
	oQual:bLine := { || {If(aChaveArq[oQual:nAt,1],oOk,oNo),aChaveArq[oQual:nAt,2],aChaveArq[oQual:nAt,3]}}
	DEFINE SBUTTON FROM 134,240 TYPE 1 ACTION IIF(MarcaOk(aChaveArq),(lSelecao := .T., oDlg:End(),.T.),.F.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 134,270 TYPE 2 ACTION (lSelecao := .F., oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED

RETURN aChaveArq

//Função auxiliar: TROCA()
Static Function Troca(nIt,aArray)
	aArray[nIt,1] := !aArray[nIt,1]
Return aArray

//Função auxiliar: MARCAOK()
Static Function MarcaOk(aArray)
	Local lRet:=.F.
	Local nx:=0
// Checa marcações efetuadas
	For nx:=1 To Len(aArray)
		If aArray[nx,1]
			lRet:=.T.
		EndIf
	Next
// Checa se existe algum item marcado na confirmação
	If !lRet
		MsgAlert("Não existem Empresas marcadas")
	EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Ajusta    ³ Autor ³ Vitor Merguizo 		  ³ Data ³ 16/08/2012		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Insere novas perguntas na tabela SX1 a Ajusta o Picture dos valores	³±±
±±³          ³ no SX3                                                           	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ 																		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Ajusta()

	Local aPergs 	:= {}

	Aadd(aPergs,{"Produto de ?                 ","Produto de ?                 ","Produto de ?                 ","mv_ch1","C",15,0,0,"G",""                   ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
	Aadd(aPergs,{"Produto ate ?                ","Produto ate ?                ","Produto ate ?                ","mv_ch2","C",15,0,0,"G",""                   ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
	Aadd(aPergs,{"Grupo de ?                   ","Grupo de ?                   ","Grupo de ?                   ","mv_ch3","C",4,0,0,"G",""                    ,"mv_par03","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SBM","S","",""})
	Aadd(aPergs,{"Grupo ate ?                  ","Grupo ate ?                  ","Grupo ate ?                  ","mv_ch4","C",4,0,0,"G",""                    ,"mv_par04","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SBM","S","",""})
	Aadd(aPergs,{"Agrupamento de ?             ","Agrupamento de ?             ","Agrupamento de ?             ","mv_ch5","C",3,0,0,"G",""                    ,"mv_par05","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Agrupamento ate ?            ","Agrupamento ate ?            ","Agrupamento ate ?            ","mv_ch6","C",3,0,0,"G",""                    ,"mv_par06","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Cliente de ?                 ","Cliente de ?                 ","Cliente de ?                 ","mv_ch7","C",6,0,0,"G",""                    ,"mv_par07","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SA1","S","",""})
	Aadd(aPergs,{"Loja de ?                    ","Loja de ?                    ","Loja de ?                    ","mv_ch8","C",2,0,0,"G",""                    ,"mv_par08","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Cliente ate ?                ","Cliente ate ?                ","Cliente ate ?                ","mv_ch9","C",6,0,0,"G",""                    ,"mv_par09","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SA1","S","",""})
	Aadd(aPergs,{"Loja ate ?                   ","Loja ate ?                   ","Loja ate ?                   ","mv_cha","C",2,0,0,"G",""                    ,"mv_par10","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Considera os Clientes:       ","Considera os Clientes:       ","Considera os Clientes:       ","mv_chb","C",30,0,0,"G",""                   ,"mv_par11","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Não Considera os Clientes:   ","Não Considera os Clientes:   ","Não Considera os Clientes:   ","mv_chc","C",30,0,0,"G",""                   ,"mv_par12","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Imprime Detalhes ?           ","Imprime Detalhes ?           ","Imprime Detalhes ?           ","mv_chd","N",1,0,1,"C",""                    ,"mv_par13","Sim           ","Sim           ","Sim           ","","","Não           ","Não           ","Não           ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Y-1 de ?                     ","Y-1 de ?                     ","Y-1 de ?                     ","mv_che","D",8,0,0,"G",""                    ,"mv_par14","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Y-1 ate ?                    ","Y-1 ate ?                    ","Y-1 ate ?                    ","mv_chf","D",8,0,0,"G",""                    ,"mv_par15","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Y de ?                       ","Y de ?                       ","Y de ?                       ","mv_chg","D",8,0,0,"G",""                    ,"mv_par16","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Y ate ?                      ","Y ate ?                      ","Y ate ?                      ","mv_chh","D",8,0,0,"G",""                    ,"mv_par17","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Matching ?                   ","Matching ?                   ","Matching ?                   ","mv_chi","N",1,0,1,"C",""                    ,"mv_par18","Sim           ","Sim           ","Sim           ","","","Não           ","Não           ","Não           ","","","","","","","","","","","","","","","","","","S","",""})
	
	//AjustaSx1("STFLR7",aPergs)

Return
