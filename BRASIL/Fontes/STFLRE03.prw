#include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

#DEFINE CODIGO		1
#DEFINE DESCRICAO	2
#DEFINE VLJAN		3
#DEFINE VLFEV		4
#DEFINE VLMAR		5
#DEFINE VLABR		6
#DEFINE VLMAI		7
#DEFINE VLJUN		8
#DEFINE VLJUL		9
#DEFINE VLAGO		10
#DEFINE VLSET		11
#DEFINE VLOUT		12
#DEFINE VLNOV		13
#DEFINE VLDEZ		14
#DEFINE VLANO		15
#DEFINE TIPO		16

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ STFLRE03   ∫ Autor ≥ Vitor Merguizo	 ∫ Data ≥  16/11/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Relatorio de Quantidades Vendidas conforme especificaÁ„o do∫±±
±±∫          ≥ cliente                                                    ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function STFLRE03()
	
	Local oReport
	
	

	Ajusta()
	
	oReport 	:= ReportDef()
	oReport		:PrintDialog()
	
Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunÁ„o    ≥ ReportDef≥ Autor ≥ Microsiga	        ≥ Data ≥ 12.05.12 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriÁ„o ≥ Definicao do layout do Relatorio				  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ ReportDef(void)                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Generico                                                   ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function ReportDef()
	Local oReport
	Local oSection1
	
	oReport := TReport():New("STFLRE03","RELATORIO DE FATURAMENTO","STFLR3",{|oReport| ReportPrint(oReport)},"Este programa ir· imprimir as quantidades faturadas conforme parametros selecionados.")
	oReport:SetLandscape()
	oReport:nFontBody := 5
	
	pergunte("STFLR3",.F.)
	
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
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	
	oSection1 := TRSection():New(oReport,"Quantidades Vendidas",{"SD2"},)
	TRCell():New(oSection1,"TIPO"		,,"Destino",,20,.F.,)
	TRCell():New(oSection1,"CODIGO"		,,"Cod.",,15,.F.,)
	TRCell():New(oSection1,"DESCRICAO"	,,"Descricao",,30,.F.,)
	TRCell():New(oSection1,"VLJAN"		,,"Janeiro  ","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"VLFEV"		,,"Fevereiro","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"VLMAR"		,,"Marco    ","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"VLABR"		,,"Abril    ","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"VLMAI"		,,"Maio     ","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"VLJUN"		,,"Junho    ","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"VLJUL"		,,"Julho    ","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"VLAGO"		,,"Agosto   ","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"VLSET"		,,"Setembro ","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"VLOUT"		,,"Outubro  ","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"VLNOV"		,,"Novembro ","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"VLDEZ"		,,"Dezembro ","@E 9,999,999,999.99",16,.F.,)
	TRCell():New(oSection1,"VLANO"		,,"Total    ","@E 999,999,999,999.99",18,.F.,)
	
	oSection1:Cell("VLJAN"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VLFEV"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VLMAR"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VLABR"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VLMAI"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VLJUN"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VLJUL"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VLAGO"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VLSET"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VLOUT"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VLNOV"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VLDEZ"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VLANO"):SetHeaderAlign("RIGHT")
	
	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("SD2")
	
Return oReport

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
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
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function ReportPrint(oReport)
	
	Local cTitulo		:= OemToAnsi("Quantidades Vendidas refente "+mv_par01)
	Local cClienteIN	:= ""
	Local cClienteNIN	:= ""
	Local cPaisOut		:= ""
	Local cAlias		:= "QRY1SD2"
	Local cQuery		:= ""
	Local cQuery1		:= ""
	Local cValorSD1		:= "D1_QUANT"
	Local cValorSD2		:= "D2_QUANT"
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
	Local nG01	:= 0
	Local nG02	:= 0
	Local nG03	:= 0
	Local nG04	:= 0
	Local nG05	:= 0
	Local nG06	:= 0
	Local nG07	:= 0
	Local nG08	:= 0
	Local nG09	:= 0
	Local nG10	:= 0
	Local nG11	:= 0
	Local nG12	:= 0
	
	Local cACod	:= ""
	Local nA01	:= 0
	Local nA02	:= 0
	Local nA03	:= 0
	Local nA04	:= 0
	Local nA05	:= 0
	Local nA06	:= 0
	Local nA07	:= 0
	Local nA08	:= 0
	Local nA09	:= 0
	Local nA10	:= 0
	Local nA11	:= 0
	Local nA12	:= 0
	
	oSection1:Cell("TIPO")		:SetBlock( { || aDados1[TIPO]		})
	oSection1:Cell("CODIGO")	:SetBlock( { || aDados1[CODIGO]		})
	oSection1:Cell("DESCRICAO")	:SetBlock( { || aDados1[DESCRICAO]	})
	oSection1:Cell("VLJAN")		:SetBlock( { || aDados1[VLJAN]		})
	oSection1:Cell("VLFEV")		:SetBlock( { || aDados1[VLFEV]		})
	oSection1:Cell("VLMAR")		:SetBlock( { || aDados1[VLMAR]		})
	oSection1:Cell("VLABR")		:SetBlock( { || aDados1[VLABR]		})
	oSection1:Cell("VLMAI")		:SetBlock( { || aDados1[VLMAI]		})
	oSection1:Cell("VLJUN")		:SetBlock( { || aDados1[VLJUN]		})
	oSection1:Cell("VLJUL")		:SetBlock( { || aDados1[VLJUL]		})
	oSection1:Cell("VLAGO")		:SetBlock( { || aDados1[VLAGO]		})
	oSection1:Cell("VLSET")		:SetBlock( { || aDados1[VLSET]		})
	oSection1:Cell("VLOUT")		:SetBlock( { || aDados1[VLOUT]		})
	oSection1:Cell("VLNOV")		:SetBlock( { || aDados1[VLNOV]		})
	oSection1:Cell("VLDEZ")		:SetBlock( { || aDados1[VLDEZ]		})
	oSection1:Cell("VLANO")		:SetBlock( { || aDados1[VLANO]		})
	
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
	If !Empty(mv_par18)
		cPaisOut := StrTran(AllTrim(mv_par18),";","','")
	EndIf
	
	
	If Len(aEmpresa) > 0
		
		RestArea(aAreaSM0)
		
		// Cria Estrutura
		AAdd( aStruct, { "TRB_TIP"  , "C",  1, 0 } )
		AAdd( aStruct, { "TRB_COD"  , "C", 15, 0 } )
		AAdd( aStruct, { "TRB_GRP"  , "C",  4, 0 } )
		AAdd( aStruct, { "TRB_AGR"	, "C",  3, 0 } )
		AAdd( aStruct, { "TRB_M01"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_M02"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_M03"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_M04"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_M05"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_M06"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_M07"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_M08"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_M09"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_M10"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_M11"	, "N", 18, 2 } )
		AAdd( aStruct, { "TRB_M12"	, "N", 18, 2 } )
		
		// Cria fisicamente o arquivo.
		//cArqTRB := CriaTrab( aStruct, .T. ) 	//FunÁ„o CriaTrab descontinuada, adicionado o oTable no lugar
		oTable := FWTemporaryTable():New("TRB") //adicionado\Ajustado
		oTable:SetFields(aStruct)				//adicionado\Ajustado
		oTable:Create()							//adicionado\Ajustado
		cArqTRB	:= oTable:GetRealName()			//adicionado\Ajustado
		cInd1 := Left( cArqTRB, 7 ) + "1"
		cInd2 := Left( cArqTRB, 7 ) + "2"
		
		// Acessa o arquivo e coloca-lo na lista de arquivos abertos.
		dbUseArea( .T., "topconn", cArqTRB, "TRB", .F., .F. )
		
		// Cria os Ìndices.
		IndRegua( "TRB", cInd1, "TRB_TIP+TRB_COD", , , "Criando Ìndices (Codigo)...")
		IndRegua( "TRB", cInd2, "TRB_TIP+TRB_AGR+TRB_GRP+TRB_COD", , , "Criando Ìndices (Agrupamento+Grupo+Codigo)...")
		
		// Libera os Ìndices.
		dbClearIndex()
		
		// Agrega a lista dos Ìndices da tabela (arquivo).
		dbSetIndex( cInd1 + OrdBagExt() )
		dbSetIndex( cInd2 + OrdBagExt() )
		
		For _n := 1 to Len(aEmpresa)
			If aEmpresa[_n][1]
				AADD(aEmpQry,aEmpresa[_n][2])
			EndIf
		Next _n
		
		If mv_par14 = 1
			cQuery += " SELECT CASE WHEN GVEN = 'BACK  ' THEN '4' WHEN GVEN = 'SC' THEN '3' WHEN SUBSTR(CF,1,1) IN ('3','7') THEN '2' ELSE '1' END TIP,DAT,COD,B1_GRUPO GRP, BM_XAGRUP AGR, SUM(VALOR)VALOR FROM ("
		ElseIf mv_par14 = 2
			cQuery += " SELECT CASE WHEN GVEN = 'BACK  ' THEN '4' WHEN GVEN = 'SC' THEN '3' WHEN SUBSTR(CF,1,1) IN ('3','7') THEN '2' ELSE '1' END TIP,DAT,MAX(COD)COD,B1_GRUPO GRP, BM_XAGRUP AGR, SUM(VALOR)VALOR FROM ("
		Else
			cQuery += " SELECT CASE WHEN GVEN = 'BACK  ' THEN '4' WHEN GVEN = 'SC' THEN '3' WHEN SUBSTR(CF,1,1) IN ('3','7') THEN '2' ELSE '1' END TIP,DAT,MAX(COD)COD,MAX(B1_GRUPO) GRP, BM_XAGRUP AGR, SUM(VALOR)VALOR FROM ("
		EndIf
		
		For _i := 1 to Len(aEmpQry)
			If _i > 1
				cQuery += " UNION ALL"
			EndIf
			cQuery += " SELECT SUBSTR(D2_EMISSAO,5,2)DAT,A1_GRPVEN GVEN,D2_COD COD,D2_CF CF,D2_CLIENTE CLI, D2_LOJA LOJ,"+cValorSD2+" VALOR ,D2_EST EXP, A1_PAIS PAIS FROM SD2"+aEmpQry[_i]+"0 D2 LEFT JOIN SA1"+aEmpQry[_i]+"0 A1 ON "
			cQuery += " A1_FILIAL = '"+xFilial("SA1")+"' AND D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND A1.D_E_L_E_T_ = ' ' WHERE D2_FILIAL <> ' ' "
			If !Empty(mv_par15) .And. !Empty(mv_par16)
				cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(mv_par15)+"' AND '"+DTOS(mv_par16)+"' "
			Else
				cQuery += " AND SUBSTR(D2_EMISSAO,1,4) = '"+mv_par01+"' "
			EndIf
			cQuery += " AND D2_TIPO <> 'D' AND D2.D_E_L_E_T_ = ' ' "
			cQuery += " UNION ALL"
			cQuery += " SELECT SUBSTR(D1_DTDIGIT,5,2),A1_GRPVEN,D1_COD,D1_CF,D1_FORNECE,D1_LOJA,("+cValorSD1+")*-1 , 'EXP',A1_PAIS PAIS FROM SD1"+aEmpQry[_i]+"0 D1 LEFT JOIN SA1"+aEmpQry[_i]+"0 A1 ON "
			cQuery += " A1_FILIAL = '"+xFilial("SA1")+"' AND D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND A1.D_E_L_E_T_ = ' ' WHERE D1_FILIAL <> ' ' "
			If !Empty(mv_par15) .And. !Empty(mv_par16)
				cQuery += " AND D1_DTDIGIT BETWEEN '"+DTOS(mv_par15)+"' AND '"+DTOS(mv_par16)+"' "
			Else
				cQuery += " AND SUBSTR(D1_DTDIGIT,1,4) = '"+mv_par01+"' "
			EndIf
			cQuery += " AND D1_TIPO = 'D' AND D1.D_E_L_E_T_ = ' ' "
			cQuery += " UNION ALL"
			cQuery += " SELECT SUBSTR(EE7_DTSLCR,5,2)DAT,'BACK  'GVEN,EE8_COD_I COD,'BACK'CF,'BACK'Cli,'BACK'Loj,ROUND(SUM(EE8_SLDINI),2) VALOR , 'EXP',EE7_PAISET "/* 'PAIS' " GIOVANI ZAGO 04/01/2017 CINTHYA*/
			cQuery += " FROM EE8"+aEmpQry[_i]+"0 EE8"
			cQuery += " INNER JOIN EE7"+aEmpQry[_i]+"0 EE7 ON EE7_FILIAL = EE8_FILIAL AND EE7_PEDIDO = EE8_PEDIDO AND EE7.D_E_L_E_T_ = ' '"
			cQuery += " WHERE"
			cQuery += " EE8_FILIAL <> ' ' AND"
			If !Empty(mv_par15) .And. !Empty(mv_par16)"
				cQuery += " EE7_DTSLCR BETWEEN '"+DTOS(mv_par15)+"' AND '"+DTOS(mv_par16)+"' AND"
			Else
				cQuery += " SUBSTRING(EE7_DTSLCR,1,4) = '"+mv_par01+"' AND"
			EndIf
			cQuery += " EE7_PEDFAT = ' ' AND"
			cQuery += " EE7_FATURA = ' ' AND"
			cQuery += " EE7_CONDPA <> '58' AND "   //GIOVANI ZAGO 15/06/2016 SL JESSICA
			cQuery += " EE8.D_E_L_E_T_ = ' '"
			cQuery += " GROUP BY SUBSTR(EE7_DTSLCR,5,2),EE8_COD_I,EE7_PAISET "
		Next _i
		cQuery += " )NF LEFT JOIN SB1010 B1 ON B1_COD = NF.COD AND B1.D_E_L_E_T_ = ' ' LEFT JOIN SBM010 BM ON B1_GRUPO = BM_GRUPO AND BM.D_E_L_E_T_ = ' '"
		If !Empty(mv_par03)
			cQuery1 += " COD >= '"+mv_par02+"' AND"
			cQuery1 += " COD <= '"+mv_par03+"' AND"
		EndIf
		If !Empty(mv_par05)
			cQuery1 += " B1_GRUPO >= '"+mv_par04+"' AND"
			cQuery1 += " B1_GRUPO <= '"+mv_par05+"' AND"
		EndIf
		If !Empty(mv_par07)
			cQuery1 += " BM_XAGRUP >= '"+mv_par06+"' AND"
			cQuery1 += " BM_XAGRUP <= '"+mv_par07+"' AND"
		EndIf
		If !Empty(mv_par10) .Or. !Empty(mv_par11)
			
			cQuery1 += "(
			cQuery1 += "(
			cQuery1 += " CLI >= '"+mv_par08+"' AND"
			cQuery1 += " LOJ >= '"+mv_par09+"' AND"
			cQuery1 += " CLI <= '"+mv_par10+"' AND"
			cQuery1 += " LOJ <= '"+mv_par11+"'"
			cQuery1 += ")
			cQuery1 += " OR
			cQuery1 += " (CLI='BACK' AND LOJ='BACK')  
			cQuery1 += ") AND
			
		EndIf
		If mv_par17=="S"
			cQuery1 += " EXP = 'EX' AND "
		EndIf
		If !Empty(mv_par12)
			cQuery1 += " CLI IN ('"+cClienteIN+"') AND"
		EndIf
		If !Empty(mv_par13)
			cQuery1 += " CLI NOT IN ('"+cClienteNIN+"') AND"
		EndIf
		If !Empty(mv_par18)
			//cQuery1 += " PAIS NOT IN ('"+cPaisOut+"') AND"
			cQuery1 += " PAIS  IN ('"+cPaisOut+"') AND"
		EndIf
		
		cQuery	+= " WHERE CF IN ('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102','1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','BACK') AND "
		cQuery	+= " GVEN <> 'ST'"
		
		If Len(cQuery1) > 1
			cQuery	+= " AND "+SUBS(cQuery1,1,Len(cQuery1)-4)
		EndIf
		If mv_par14 = 1
			cQuery += " GROUP BY CASE WHEN GVEN = 'BACK  ' THEN '4' WHEN GVEN = 'SC' THEN '3' WHEN SUBSTR(CF,1,1) IN ('3','7') THEN '2' ELSE '1' END,BM_XAGRUP,B1_GRUPO,COD,DAT ORDER BY BM_XAGRUP,B1_GRUPO,COD,DAT"
		ElseIf mv_par14 = 2
			cQuery += " GROUP BY CASE WHEN GVEN = 'BACK  ' THEN '4' WHEN GVEN = 'SC' THEN '3' WHEN SUBSTR(CF,1,1) IN ('3','7') THEN '2' ELSE '1' END,BM_XAGRUP,B1_GRUPO,DAT ORDER BY BM_XAGRUP,B1_GRUPO,DAT"
		Else
			cQuery += " GROUP BY CASE WHEN GVEN = 'BACK  ' THEN '4' WHEN GVEN = 'SC' THEN '3' WHEN SUBSTR(CF,1,1) IN ('3','7') THEN '2' ELSE '1' END,BM_XAGRUP,DAT ORDER BY BM_XAGRUP,DAT"
		EndIf
		
		cQuery := ChangeQuery(cQuery)
		
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Fecha Alias se estiver em Uso ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif
		
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Monta Area de Trabalho executando a Query ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.T.)
		
		TCSetField(cAlias,"VALOR","N",18,2)
		
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
			If (cAlias)->DAT = "01"
				TRB->TRB_M01 := (cAlias)->VALOR
			ElseIf (cAlias)->DAT = "02"
				TRB->TRB_M02 := (cAlias)->VALOR
			ElseIf (cAlias)->DAT = "03"
				TRB->TRB_M03 := (cAlias)->VALOR
			ElseIf (cAlias)->DAT = "04"
				TRB->TRB_M04 := (cAlias)->VALOR
			ElseIf (cAlias)->DAT = "05"
				TRB->TRB_M05 := (cAlias)->VALOR
			ElseIf (cAlias)->DAT = "06"
				TRB->TRB_M06 := (cAlias)->VALOR
			ElseIf (cAlias)->DAT = "07"
				TRB->TRB_M07 := (cAlias)->VALOR
			ElseIf (cAlias)->DAT = "08"
				TRB->TRB_M08 := (cAlias)->VALOR
			ElseIf (cAlias)->DAT = "09"
				TRB->TRB_M09 := (cAlias)->VALOR
			ElseIf (cAlias)->DAT = "10"
				TRB->TRB_M10 := (cAlias)->VALOR
			ElseIf (cAlias)->DAT = "11"
				TRB->TRB_M11 := (cAlias)->VALOR
			ElseIf (cAlias)->DAT = "12"
				TRB->TRB_M12 := (cAlias)->VALOR
			EndIf
			(cAlias)->(dbSkip())
		EndDo
		
		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif
		
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
					
					aDados1[CODIGO]		:= cGCod
					aDados1[DESCRICAO]	:= SBM->BM_DESC
					aDados1[VLJAN]		:= nG01
					aDados1[VLFEV]		:= nG02
					aDados1[VLMAR]		:= nG03
					aDados1[VLABR]		:= nG04
					aDados1[VLMAI]		:= nG05
					aDados1[VLJUN]		:= nG06
					aDados1[VLJUL]		:= nG07
					aDados1[VLAGO]		:= nG08
					aDados1[VLSET]		:= nG09
					aDados1[VLOUT]		:= nG10
					aDados1[VLNOV]		:= nG11
					aDados1[VLDEZ]		:= nG12
					aDados1[VLANO]		:= nG01+nG02+nG03+nG04+nG05+nG06+nG07+nG08+nG09+nG10+nG11+nG12
					aDados1[TIPO]		:= "Brasil"
					
					nG01 := 0
					nG02 := 0
					nG03 := 0
					nG04 := 0
					nG05 := 0
					nG06 := 0
					nG07 := 0
					nG08 := 0
					nG09 := 0
					nG10 := 0
					nG11 := 0
					nG12 := 0
					
					If mv_par14 <> 3
						If mv_par14 = 1
							oReport:SkipLine()
							oReport:ThinLine()
						EndIf
						oSection1:PrintLine()
						aFill(aDados1,nil)
						If mv_par14 = 1
							oReport:ThinLine()
							oReport:SkipLine()
						EndIf
					EndIf
				EndIf
				
				If n>1 .And. cACod <> TRB->TRB_AGR
					
					DbSelectArea("SX5")
					DbSetOrder(1)
					DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
					
					aDados1[CODIGO]		:= cACod
					aDados1[DESCRICAO]	:= IIF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
					aDados1[VLJAN]		:= nA01
					aDados1[VLFEV]		:= nA02
					aDados1[VLMAR]		:= nA03
					aDados1[VLABR]		:= nA04
					aDados1[VLMAI]		:= nA05
					aDados1[VLJUN]		:= nA06
					aDados1[VLJUL]		:= nA07
					aDados1[VLAGO]		:= nA08
					aDados1[VLSET]		:= nA09
					aDados1[VLOUT]		:= nA10
					aDados1[VLNOV]		:= nA11
					aDados1[VLDEZ]		:= nA12
					aDados1[VLANO]		:= nA01+nA02+nA03+nA04+nA05+nA06+nA07+nA08+nA09+nA10+nA11+nA12
					aDados1[TIPO]		:= "Brasil"
					
					nA01 := 0
					nA02 := 0
					nA03 := 0
					nA04 := 0
					nA05 := 0
					nA06 := 0
					nA07 := 0
					nA08 := 0
					nA09 := 0
					nA10 := 0
					nA11 := 0
					nA12 := 0
					
					If mv_par14 <> 3
						oReport:SkipLine()
						oReport:ThinLine()
					EndIf
					oSection1:PrintLine()
					aFill(aDados1,nil)
					If mv_par14 <> 3
						oReport:ThinLine()
						oReport:SkipLine()
					EndIf
				EndIf
				
				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1") + TRB->TRB_COD )
				
				aDados1[CODIGO]		:= TRB->TRB_COD
				aDados1[DESCRICAO]	:= SB1->B1_DESC
				aDados1[VLJAN]		:= TRB->TRB_M01
				aDados1[VLFEV]		:= TRB->TRB_M02
				aDados1[VLMAR]		:= TRB->TRB_M03
				aDados1[VLABR]		:= TRB->TRB_M04
				aDados1[VLMAI]		:= TRB->TRB_M05
				aDados1[VLJUN]		:= TRB->TRB_M06
				aDados1[VLJUL]		:= TRB->TRB_M07
				aDados1[VLAGO]		:= TRB->TRB_M08
				aDados1[VLSET]		:= TRB->TRB_M09
				aDados1[VLOUT]		:= TRB->TRB_M10
				aDados1[VLNOV]		:= TRB->TRB_M11
				aDados1[VLDEZ]		:= TRB->TRB_M12
				aDados1[VLANO]		:= TRB->(TRB_M01+TRB_M02+TRB_M03+TRB_M04+TRB_M05+TRB_M06+TRB_M07+TRB_M08+TRB_M09+TRB_M10+TRB_M11+TRB_M12)
				aDados1[TIPO]		:= "Brasil"
				
				cGCod	:= TRB->TRB_GRP
				nG01	+= TRB->TRB_M01
				nG02	+= TRB->TRB_M02
				nG03	+= TRB->TRB_M03
				nG04	+= TRB->TRB_M04
				nG05	+= TRB->TRB_M05
				nG06	+= TRB->TRB_M06
				nG07	+= TRB->TRB_M07
				nG08	+= TRB->TRB_M08
				nG09	+= TRB->TRB_M09
				nG10	+= TRB->TRB_M10
				nG11	+= TRB->TRB_M11
				nG12	+= TRB->TRB_M12
				
				cACod	:= TRB->TRB_AGR
				nA01	+= TRB->TRB_M01
				nA02	+= TRB->TRB_M02
				nA03	+= TRB->TRB_M03
				nA04	+= TRB->TRB_M04
				nA05	+= TRB->TRB_M05
				nA06	+= TRB->TRB_M06
				nA07	+= TRB->TRB_M07
				nA08	+= TRB->TRB_M08
				nA09	+= TRB->TRB_M09
				nA10	+= TRB->TRB_M10
				nA11	+= TRB->TRB_M11
				nA12	+= TRB->TRB_M12
				
				If mv_par14 = 1
					oSection1:PrintLine()
					aFill(aDados1,nil)
				EndIf
			EndIf
			TRB->(dbSkip())
		EndDo
		
		If (nG01+nG02+nG03+nG04+nG05+nG06+nG07+nG08+nG09+nG10+nG11+nG12)>0
			
			DbSelectArea("SBM")
			DbSetOrder(1)
			DbSeek(xFilial("SBM") + Alltrim(cGCod) )
			
			aDados1[CODIGO]		:= cGCod
			aDados1[DESCRICAO]	:= SBM->BM_DESC
			aDados1[VLJAN]		:= nG01
			aDados1[VLFEV]		:= nG02
			aDados1[VLMAR]		:= nG03
			aDados1[VLABR]		:= nG04
			aDados1[VLMAI]		:= nG05
			aDados1[VLJUN]		:= nG06
			aDados1[VLJUL]		:= nG07
			aDados1[VLAGO]		:= nG08
			aDados1[VLSET]		:= nG09
			aDados1[VLOUT]		:= nG10
			aDados1[VLNOV]		:= nG11
			aDados1[VLDEZ]		:= nG12
			aDados1[VLANO]		:= nG01+nG02+nG03+nG04+nG05+nG06+nG07+nG08+nG09+nG10+nG11+nG12
			aDados1[TIPO]		:= "Brasil"
			
			nG01 := 0
			nG02 := 0
			nG03 := 0
			nG04 := 0
			nG05 := 0
			nG06 := 0
			nG07 := 0
			nG08 := 0
			nG09 := 0
			nG10 := 0
			nG11 := 0
			nG12 := 0
			
			If mv_par14 <> 3
				If mv_par14 = 1
					oReport:SkipLine()
					oReport:ThinLine()
				EndIf
				oSection1:PrintLine()
				aFill(aDados1,nil)
				If mv_par14 = 1
					oReport:ThinLine()
					oReport:SkipLine()
				EndIf
			EndIf
		EndIf
		
		If (nA01+nA02+nA03+nA04+nA05+nA06+nA07+nA08+nA09+nA10+nA11+nA12)>0
			
			DbSelectArea("SX5")
			DbSetOrder(1)
			DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
			
			aDados1[CODIGO]		:= cACod
			aDados1[DESCRICAO]	:= IF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
			aDados1[VLJAN]		:= nA01
			aDados1[VLFEV]		:= nA02
			aDados1[VLMAR]		:= nA03
			aDados1[VLABR]		:= nA04
			aDados1[VLMAI]		:= nA05
			aDados1[VLJUN]		:= nA06
			aDados1[VLJUL]		:= nA07
			aDados1[VLAGO]		:= nA08
			aDados1[VLSET]		:= nA09
			aDados1[VLOUT]		:= nA10
			aDados1[VLNOV]		:= nA11
			aDados1[VLDEZ]		:= nA12
			aDados1[VLANO]		:= nA01+nA02+nA03+nA04+nA05+nA06+nA07+nA08+nA09+nA10+nA11+nA12
			aDados1[TIPO]		:= "Brasil"
			
			nA01 := 0
			nA02 := 0
			nA03 := 0
			nA04 := 0
			nA05 := 0
			nA06 := 0
			nA07 := 0
			nA08 := 0
			nA09 := 0
			nA10 := 0
			nA11 := 0
			nA12 := 0
			
			If mv_par14 <> 3
				oReport:SkipLine()
				oReport:ThinLine()
			EndIf
			oSection1:PrintLine()
			aFill(aDados1,nil)
			If mv_par14 <> 3
				oReport:ThinLine()
				oReport:SkipLine()
			EndIf
		EndIf
		
	EndIf
	
	oSection1:Finish()
	
	cGCod := ""
	nG01 := 0
	nG02 := 0
	nG03 := 0
	nG04 := 0
	nG05 := 0
	nG06 := 0
	nG07 := 0
	nG08 := 0
	nG09 := 0
	nG10 := 0
	nG11 := 0
	nG12 := 0
	
	cACod := ""
	nA01 := 0
	nA02 := 0
	nA03 := 0
	nA04 := 0
	nA05 := 0
	nA06 := 0
	nA07 := 0
	nA08 := 0
	nA09 := 0
	nA10 := 0
	nA11 := 0
	nA12 := 0
	
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
					
					aDados1[CODIGO]		:= cGCod
					aDados1[DESCRICAO]	:= SBM->BM_DESC
					aDados1[VLJAN]		:= nG01
					aDados1[VLFEV]		:= nG02
					aDados1[VLMAR]		:= nG03
					aDados1[VLABR]		:= nG04
					aDados1[VLMAI]		:= nG05
					aDados1[VLJUN]		:= nG06
					aDados1[VLJUL]		:= nG07
					aDados1[VLAGO]		:= nG08
					aDados1[VLSET]		:= nG09
					aDados1[VLOUT]		:= nG10
					aDados1[VLNOV]		:= nG11
					aDados1[VLDEZ]		:= nG12
					aDados1[VLANO]		:= nG01+nG02+nG03+nG04+nG05+nG06+nG07+nG08+nG09+nG10+nG11+nG12
					aDados1[TIPO]		:= "ExportaÁ„o"
					
					nG01 := 0
					nG02 := 0
					nG03 := 0
					nG04 := 0
					nG05 := 0
					nG06 := 0
					nG07 := 0
					nG08 := 0
					nG09 := 0
					nG10 := 0
					nG11 := 0
					nG12 := 0
					
					If mv_par14 <> 3
						If mv_par14 = 1
							oReport:SkipLine()
							oReport:ThinLine()
						EndIf
						oSection1:PrintLine()
						aFill(aDados1,nil)
						If mv_par14 = 1
							oReport:ThinLine()
							oReport:SkipLine()
						EndIf
					EndIf
				EndIf
				
				If n>1 .And. cACod <> TRB->TRB_AGR
					
					DbSelectArea("SX5")
					DbSetOrder(1)
					DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
					
					aDados1[CODIGO]		:= cACod
					aDados1[DESCRICAO]	:= IF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
					aDados1[VLJAN]		:= nA01
					aDados1[VLFEV]		:= nA02
					aDados1[VLMAR]		:= nA03
					aDados1[VLABR]		:= nA04
					aDados1[VLMAI]		:= nA05
					aDados1[VLJUN]		:= nA06
					aDados1[VLJUL]		:= nA07
					aDados1[VLAGO]		:= nA08
					aDados1[VLSET]		:= nA09
					aDados1[VLOUT]		:= nA10
					aDados1[VLNOV]		:= nA11
					aDados1[VLDEZ]		:= nA12
					aDados1[VLANO]		:= nA01+nA02+nA03+nA04+nA05+nA06+nA07+nA08+nA09+nA10+nA11+nA12
					aDados1[TIPO]		:= "ExportaÁ„o"
					
					nA01 := 0
					nA02 := 0
					nA03 := 0
					nA04 := 0
					nA05 := 0
					nA06 := 0
					nA07 := 0
					nA08 := 0
					nA09 := 0
					nA10 := 0
					nA11 := 0
					nA12 := 0
					
					If mv_par14 <> 3
						oReport:SkipLine()
						oReport:ThinLine()
					EndIf
					oSection1:PrintLine()
					aFill(aDados1,nil)
					If mv_par14 <> 3
						oReport:ThinLine()
						oReport:SkipLine()
					EndIf
				EndIf
				
				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1") + TRB->TRB_COD )
				
				aDados1[CODIGO]		:= TRB->TRB_COD
				aDados1[DESCRICAO]	:= SB1->B1_DESC
				aDados1[VLJAN]		:= TRB->TRB_M01
				aDados1[VLFEV]		:= TRB->TRB_M02
				aDados1[VLMAR]		:= TRB->TRB_M03
				aDados1[VLABR]		:= TRB->TRB_M04
				aDados1[VLMAI]		:= TRB->TRB_M05
				aDados1[VLJUN]		:= TRB->TRB_M06
				aDados1[VLJUL]		:= TRB->TRB_M07
				aDados1[VLAGO]		:= TRB->TRB_M08
				aDados1[VLSET]		:= TRB->TRB_M09
				aDados1[VLOUT]		:= TRB->TRB_M10
				aDados1[VLNOV]		:= TRB->TRB_M11
				aDados1[VLDEZ]		:= TRB->TRB_M12
				aDados1[VLANO]		:= TRB->(TRB_M01+TRB_M02+TRB_M03+TRB_M04+TRB_M05+TRB_M06+TRB_M07+TRB_M08+TRB_M09+TRB_M10+TRB_M11+TRB_M12)
				aDados1[TIPO]		:= "ExportaÁ„o"
				
				cGCod	:= TRB->TRB_GRP
				nG01	+= TRB->TRB_M01
				nG02	+= TRB->TRB_M02
				nG03	+= TRB->TRB_M03
				nG04	+= TRB->TRB_M04
				nG05	+= TRB->TRB_M05
				nG06	+= TRB->TRB_M06
				nG07	+= TRB->TRB_M07
				nG08	+= TRB->TRB_M08
				nG09	+= TRB->TRB_M09
				nG10	+= TRB->TRB_M10
				nG11	+= TRB->TRB_M11
				nG12	+= TRB->TRB_M12
				
				cACod	:= TRB->TRB_AGR
				nA01	+= TRB->TRB_M01
				nA02	+= TRB->TRB_M02
				nA03	+= TRB->TRB_M03
				nA04	+= TRB->TRB_M04
				nA05	+= TRB->TRB_M05
				nA06	+= TRB->TRB_M06
				nA07	+= TRB->TRB_M07
				nA08	+= TRB->TRB_M08
				nA09	+= TRB->TRB_M09
				nA10	+= TRB->TRB_M10
				nA11	+= TRB->TRB_M11
				nA12	+= TRB->TRB_M12
				
				If mv_par14 = 1
					oSection1:PrintLine()
					aFill(aDados1,nil)
				EndIf
			EndIf
			TRB->(dbSkip())
		EndDo
		
		If (nG01+nG02+nG03+nG04+nG05+nG06+nG07+nG08+nG09+nG10+nG11+nG12)>0
			
			DbSelectArea("SBM")
			DbSetOrder(1)
			DbSeek(xFilial("SBM") + Alltrim(cGCod) )
			
			aDados1[CODIGO]		:= cGCod
			aDados1[DESCRICAO]	:= SBM->BM_DESC
			aDados1[VLJAN]		:= nG01
			aDados1[VLFEV]		:= nG02
			aDados1[VLMAR]		:= nG03
			aDados1[VLABR]		:= nG04
			aDados1[VLMAI]		:= nG05
			aDados1[VLJUN]		:= nG06
			aDados1[VLJUL]		:= nG07
			aDados1[VLAGO]		:= nG08
			aDados1[VLSET]		:= nG09
			aDados1[VLOUT]		:= nG10
			aDados1[VLNOV]		:= nG11
			aDados1[VLDEZ]		:= nG12
			aDados1[VLANO]		:= nG01+nG02+nG03+nG04+nG05+nG06+nG07+nG08+nG09+nG10+nG11+nG12
			aDados1[TIPO]		:= "ExportaÁ„o"
			
			
			nG01 := 0
			nG02 := 0
			nG03 := 0
			nG04 := 0
			nG05 := 0
			nG06 := 0
			nG07 := 0
			nG08 := 0
			nG09 := 0
			nG10 := 0
			nG11 := 0
			nG12 := 0
			
			If mv_par14 <> 3
				If mv_par14 = 1
					oReport:SkipLine()
					oReport:ThinLine()
				EndIf
				oSection1:PrintLine()
				aFill(aDados1,nil)
				If mv_par14 = 1
					oReport:ThinLine()
					oReport:SkipLine()
				EndIf
			EndIf
		EndIf
		
		If (nA01+nA02+nA03+nA04+nA05+nA06+nA07+nA08+nA09+nA10+nA11+nA12)>0
			
			DbSelectArea("SX5")
			DbSetOrder(1)
			DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
			
			aDados1[CODIGO]		:= cACod
			aDados1[DESCRICAO]	:= IF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
			aDados1[VLJAN]		:= nA01
			aDados1[VLFEV]		:= nA02
			aDados1[VLMAR]		:= nA03
			aDados1[VLABR]		:= nA04
			aDados1[VLMAI]		:= nA05
			aDados1[VLJUN]		:= nA06
			aDados1[VLJUL]		:= nA07
			aDados1[VLAGO]		:= nA08
			aDados1[VLSET]		:= nA09
			aDados1[VLOUT]		:= nA10
			aDados1[VLNOV]		:= nA11
			aDados1[VLDEZ]		:= nA12
			aDados1[VLANO]		:= nA01+nA02+nA03+nA04+nA05+nA06+nA07+nA08+nA09+nA10+nA11+nA12
			aDados1[TIPO]		:= "ExportaÁ„o"
			
			nA01 := 0
			nA02 := 0
			nA03 := 0
			nA04 := 0
			nA05 := 0
			nA06 := 0
			nA07 := 0
			nA08 := 0
			nA09 := 0
			nA10 := 0
			nA11 := 0
			nA12 := 0
			
			If mv_par14 <> 3
				oReport:SkipLine()
				oReport:ThinLine()
			EndIf
			oSection1:PrintLine()
			aFill(aDados1,nil)
			If mv_par14 <> 3
				oReport:ThinLine()
				oReport:SkipLine()
			EndIf
		EndIf
		
	EndIf
	
	oSection1:Finish()
	
	cGCod := ""
	nG01 := 0
	nG02 := 0
	nG03 := 0
	nG04 := 0
	nG05 := 0
	nG06 := 0
	nG07 := 0
	nG08 := 0
	nG09 := 0
	nG10 := 0
	nG11 := 0
	nG12 := 0
	
	cACod := ""
	nA01 := 0
	nA02 := 0
	nA03 := 0
	nA04 := 0
	nA05 := 0
	nA06 := 0
	nA07 := 0
	nA08 := 0
	nA09 := 0
	nA10 := 0
	nA11 := 0
	nA12 := 0
	
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
					
					aDados1[CODIGO]		:= cGCod
					aDados1[DESCRICAO]	:= SBM->BM_DESC
					aDados1[VLJAN]		:= nG01
					aDados1[VLFEV]		:= nG02
					aDados1[VLMAR]		:= nG03
					aDados1[VLABR]		:= nG04
					aDados1[VLMAI]		:= nG05
					aDados1[VLJUN]		:= nG06
					aDados1[VLJUL]		:= nG07
					aDados1[VLAGO]		:= nG08
					aDados1[VLSET]		:= nG09
					aDados1[VLOUT]		:= nG10
					aDados1[VLNOV]		:= nG11
					aDados1[VLDEZ]		:= nG12
					aDados1[VLANO]		:= nG01+nG02+nG03+nG04+nG05+nG06+nG07+nG08+nG09+nG10+nG11+nG12
					aDados1[TIPO]		:= "Schneider"
					
					nG01 := 0
					nG02 := 0
					nG03 := 0
					nG04 := 0
					nG05 := 0
					nG06 := 0
					nG07 := 0
					nG08 := 0
					nG09 := 0
					nG10 := 0
					nG11 := 0
					nG12 := 0
					
					If mv_par14 <> 3
						If mv_par14 = 1
							oReport:SkipLine()
							oReport:ThinLine()
						EndIf
						oSection1:PrintLine()
						aFill(aDados1,nil)
						If mv_par14 = 1
							oReport:ThinLine()
							oReport:SkipLine()
						EndIf
					EndIf
				EndIf
				
				If n>1 .And. cACod <> TRB->TRB_AGR
					
					DbSelectArea("SX5")
					DbSetOrder(1)
					DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
					
					aDados1[CODIGO]		:= cACod
					aDados1[DESCRICAO]	:= IF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
					aDados1[VLJAN]		:= nA01
					aDados1[VLFEV]		:= nA02
					aDados1[VLMAR]		:= nA03
					aDados1[VLABR]		:= nA04
					aDados1[VLMAI]		:= nA05
					aDados1[VLJUN]		:= nA06
					aDados1[VLJUL]		:= nA07
					aDados1[VLAGO]		:= nA08
					aDados1[VLSET]		:= nA09
					aDados1[VLOUT]		:= nA10
					aDados1[VLNOV]		:= nA11
					aDados1[VLDEZ]		:= nA12
					aDados1[VLANO]		:= nA01+nA02+nA03+nA04+nA05+nA06+nA07+nA08+nA09+nA10+nA11+nA12
					aDados1[TIPO]		:= "Schneider"
					
					nA01 := 0
					nA02 := 0
					nA03 := 0
					nA04 := 0
					nA05 := 0
					nA06 := 0
					nA07 := 0
					nA08 := 0
					nA09 := 0
					nA10 := 0
					nA11 := 0
					nA12 := 0
					
					If mv_par14 <> 3
						oReport:SkipLine()
						oReport:ThinLine()
					EndIf
					oSection1:PrintLine()
					aFill(aDados1,nil)
					If mv_par14 <> 3
						oReport:ThinLine()
						oReport:SkipLine()
					EndIf
				EndIf
				
				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1") + TRB->TRB_COD )
				
				aDados1[CODIGO]		:= TRB->TRB_COD
				aDados1[DESCRICAO]	:= SB1->B1_DESC
				aDados1[VLJAN]		:= TRB->TRB_M01
				aDados1[VLFEV]		:= TRB->TRB_M02
				aDados1[VLMAR]		:= TRB->TRB_M03
				aDados1[VLABR]		:= TRB->TRB_M04
				aDados1[VLMAI]		:= TRB->TRB_M05
				aDados1[VLJUN]		:= TRB->TRB_M06
				aDados1[VLJUL]		:= TRB->TRB_M07
				aDados1[VLAGO]		:= TRB->TRB_M08
				aDados1[VLSET]		:= TRB->TRB_M09
				aDados1[VLOUT]		:= TRB->TRB_M10
				aDados1[VLNOV]		:= TRB->TRB_M11
				aDados1[VLDEZ]		:= TRB->TRB_M12
				aDados1[VLANO]		:= TRB->(TRB_M01+TRB_M02+TRB_M03+TRB_M04+TRB_M05+TRB_M06+TRB_M07+TRB_M08+TRB_M09+TRB_M10+TRB_M11+TRB_M12)
				aDados1[TIPO]		:= "Schneider"
				
				cGCod	:= TRB->TRB_GRP
				nG01	+= TRB->TRB_M01
				nG02	+= TRB->TRB_M02
				nG03	+= TRB->TRB_M03
				nG04	+= TRB->TRB_M04
				nG05	+= TRB->TRB_M05
				nG06	+= TRB->TRB_M06
				nG07	+= TRB->TRB_M07
				nG08	+= TRB->TRB_M08
				nG09	+= TRB->TRB_M09
				nG10	+= TRB->TRB_M10
				nG11	+= TRB->TRB_M11
				nG12	+= TRB->TRB_M12
				
				cACod	:= TRB->TRB_AGR
				nA01	+= TRB->TRB_M01
				nA02	+= TRB->TRB_M02
				nA03	+= TRB->TRB_M03
				nA04	+= TRB->TRB_M04
				nA05	+= TRB->TRB_M05
				nA06	+= TRB->TRB_M06
				nA07	+= TRB->TRB_M07
				nA08	+= TRB->TRB_M08
				nA09	+= TRB->TRB_M09
				nA10	+= TRB->TRB_M10
				nA11	+= TRB->TRB_M11
				nA12	+= TRB->TRB_M12
				
				If mv_par14 = 1
					oSection1:PrintLine()
					aFill(aDados1,nil)
				EndIf
			EndIf
			TRB->(dbSkip())
		EndDo
		
		If (nG01+nG02+nG03+nG04+nG05+nG06+nG07+nG08+nG09+nG10+nG11+nG12)>0
			
			DbSelectArea("SBM")
			DbSetOrder(1)
			DbSeek(xFilial("SBM") + Alltrim(cGCod) )
			
			aDados1[CODIGO]		:= cGCod
			aDados1[DESCRICAO]	:= SBM->BM_DESC
			aDados1[VLJAN]		:= nG01
			aDados1[VLFEV]		:= nG02
			aDados1[VLMAR]		:= nG03
			aDados1[VLABR]		:= nG04
			aDados1[VLMAI]		:= nG05
			aDados1[VLJUN]		:= nG06
			aDados1[VLJUL]		:= nG07
			aDados1[VLAGO]		:= nG08
			aDados1[VLSET]		:= nG09
			aDados1[VLOUT]		:= nG10
			aDados1[VLNOV]		:= nG11
			aDados1[VLDEZ]		:= nG12
			aDados1[VLANO]		:= nG01+nG02+nG03+nG04+nG05+nG06+nG07+nG08+nG09+nG10+nG11+nG12
			aDados1[TIPO]		:= "Schneider"
			
			
			nG01 := 0
			nG02 := 0
			nG03 := 0
			nG04 := 0
			nG05 := 0
			nG06 := 0
			nG07 := 0
			nG08 := 0
			nG09 := 0
			nG10 := 0
			nG11 := 0
			nG12 := 0
			
			If mv_par14 <> 3
				If mv_par14 = 1
					oReport:SkipLine()
					oReport:ThinLine()
				EndIf
				oSection1:PrintLine()
				aFill(aDados1,nil)
				If mv_par14 = 1
					oReport:ThinLine()
					oReport:SkipLine()
				EndIf
			EndIf
		EndIf
		
		If (nA01+nA02+nA03+nA04+nA05+nA06+nA07+nA08+nA09+nA10+nA11+nA12)>0
			
			DbSelectArea("SX5")
			DbSetOrder(1)
			DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
			
			aDados1[CODIGO]		:= cACod
			aDados1[DESCRICAO]	:= IIF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
			aDados1[VLJAN]		:= nA01
			aDados1[VLFEV]		:= nA02
			aDados1[VLMAR]		:= nA03
			aDados1[VLABR]		:= nA04
			aDados1[VLMAI]		:= nA05
			aDados1[VLJUN]		:= nA06
			aDados1[VLJUL]		:= nA07
			aDados1[VLAGO]		:= nA08
			aDados1[VLSET]		:= nA09
			aDados1[VLOUT]		:= nA10
			aDados1[VLNOV]		:= nA11
			aDados1[VLDEZ]		:= nA12
			aDados1[VLANO]		:= nA01+nA02+nA03+nA04+nA05+nA06+nA07+nA08+nA09+nA10+nA11+nA12
			aDados1[TIPO]		:= "Schneider"
			
			nA01 := 0
			nA02 := 0
			nA03 := 0
			nA04 := 0
			nA05 := 0
			nA06 := 0
			nA07 := 0
			nA08 := 0
			nA09 := 0
			nA10 := 0
			nA11 := 0
			nA12 := 0
			
			If mv_par14 <> 3
				oReport:SkipLine()
				oReport:ThinLine()
			EndIf
			oSection1:PrintLine()
			aFill(aDados1,nil)
			If mv_par14 <> 3
				oReport:ThinLine()
				oReport:SkipLine()
			EndIf
		EndIf
		
	EndIf
	
	oSection1:Finish()
	
	cGCod := ""
	nG01 := 0
	nG02 := 0
	nG03 := 0
	nG04 := 0
	nG05 := 0
	nG06 := 0
	nG07 := 0
	nG08 := 0
	nG09 := 0
	nG10 := 0
	nG11 := 0
	nG12 := 0
	
	cACod := ""
	nA01 := 0
	nA02 := 0
	nA03 := 0
	nA04 := 0
	nA05 := 0
	nA06 := 0
	nA07 := 0
	nA08 := 0
	nA09 := 0
	nA10 := 0
	nA11 := 0
	nA12 := 0
	
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
					
					aDados1[CODIGO]		:= cGCod
					aDados1[DESCRICAO]	:= SBM->BM_DESC
					aDados1[VLJAN]		:= nG01
					aDados1[VLFEV]		:= nG02
					aDados1[VLMAR]		:= nG03
					aDados1[VLABR]		:= nG04
					aDados1[VLMAI]		:= nG05
					aDados1[VLJUN]		:= nG06
					aDados1[VLJUL]		:= nG07
					aDados1[VLAGO]		:= nG08
					aDados1[VLSET]		:= nG09
					aDados1[VLOUT]		:= nG10
					aDados1[VLNOV]		:= nG11
					aDados1[VLDEZ]		:= nG12
					aDados1[VLANO]		:= nG01+nG02+nG03+nG04+nG05+nG06+nG07+nG08+nG09+nG10+nG11+nG12
					aDados1[TIPO]		:= "Back To Back"
					
					nG01 := 0
					nG02 := 0
					nG03 := 0
					nG04 := 0
					nG05 := 0
					nG06 := 0
					nG07 := 0
					nG08 := 0
					nG09 := 0
					nG10 := 0
					nG11 := 0
					nG12 := 0
					
					If mv_par14 <> 3
						If mv_par14 = 1
							oReport:SkipLine()
							oReport:ThinLine()
						EndIf
						oSection1:PrintLine()
						aFill(aDados1,nil)
						If mv_par14 = 1
							oReport:ThinLine()
							oReport:SkipLine()
						EndIf
					EndIf
				EndIf
				
				If n>1 .And. cACod <> TRB->TRB_AGR
					
					DbSelectArea("SX5")
					DbSetOrder(1)
					DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
					
					aDados1[CODIGO]		:= cACod
					aDados1[DESCRICAO]	:= IF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
					aDados1[VLJAN]		:= nA01
					aDados1[VLFEV]		:= nA02
					aDados1[VLMAR]		:= nA03
					aDados1[VLABR]		:= nA04
					aDados1[VLMAI]		:= nA05
					aDados1[VLJUN]		:= nA06
					aDados1[VLJUL]		:= nA07
					aDados1[VLAGO]		:= nA08
					aDados1[VLSET]		:= nA09
					aDados1[VLOUT]		:= nA10
					aDados1[VLNOV]		:= nA11
					aDados1[VLDEZ]		:= nA12
					aDados1[VLANO]		:= nA01+nA02+nA03+nA04+nA05+nA06+nA07+nA08+nA09+nA10+nA11+nA12
					aDados1[TIPO]		:= "Back To Back"
					
					nA01 := 0
					nA02 := 0
					nA03 := 0
					nA04 := 0
					nA05 := 0
					nA06 := 0
					nA07 := 0
					nA08 := 0
					nA09 := 0
					nA10 := 0
					nA11 := 0
					nA12 := 0
					
					If mv_par14 <> 3
						oReport:SkipLine()
						oReport:ThinLine()
					EndIf
					oSection1:PrintLine()
					aFill(aDados1,nil)
					If mv_par14 <> 3
						oReport:ThinLine()
						oReport:SkipLine()
					EndIf
				EndIf
				
				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1") + TRB->TRB_COD )
				
				aDados1[CODIGO]		:= TRB->TRB_COD
				aDados1[DESCRICAO]	:= SB1->B1_DESC
				aDados1[VLJAN]		:= TRB->TRB_M01
				aDados1[VLFEV]		:= TRB->TRB_M02
				aDados1[VLMAR]		:= TRB->TRB_M03
				aDados1[VLABR]		:= TRB->TRB_M04
				aDados1[VLMAI]		:= TRB->TRB_M05
				aDados1[VLJUN]		:= TRB->TRB_M06
				aDados1[VLJUL]		:= TRB->TRB_M07
				aDados1[VLAGO]		:= TRB->TRB_M08
				aDados1[VLSET]		:= TRB->TRB_M09
				aDados1[VLOUT]		:= TRB->TRB_M10
				aDados1[VLNOV]		:= TRB->TRB_M11
				aDados1[VLDEZ]		:= TRB->TRB_M12
				aDados1[VLANO]		:= TRB->(TRB_M01+TRB_M02+TRB_M03+TRB_M04+TRB_M05+TRB_M06+TRB_M07+TRB_M08+TRB_M09+TRB_M10+TRB_M11+TRB_M12)
				aDados1[TIPO]		:= "Back To Back"
				
				cGCod	:= TRB->TRB_GRP
				nG01	+= TRB->TRB_M01
				nG02	+= TRB->TRB_M02
				nG03	+= TRB->TRB_M03
				nG04	+= TRB->TRB_M04
				nG05	+= TRB->TRB_M05
				nG06	+= TRB->TRB_M06
				nG07	+= TRB->TRB_M07
				nG08	+= TRB->TRB_M08
				nG09	+= TRB->TRB_M09
				nG10	+= TRB->TRB_M10
				nG11	+= TRB->TRB_M11
				nG12	+= TRB->TRB_M12
				
				cACod	:= TRB->TRB_AGR
				nA01	+= TRB->TRB_M01
				nA02	+= TRB->TRB_M02
				nA03	+= TRB->TRB_M03
				nA04	+= TRB->TRB_M04
				nA05	+= TRB->TRB_M05
				nA06	+= TRB->TRB_M06
				nA07	+= TRB->TRB_M07
				nA08	+= TRB->TRB_M08
				nA09	+= TRB->TRB_M09
				nA10	+= TRB->TRB_M10
				nA11	+= TRB->TRB_M11
				nA12	+= TRB->TRB_M12
				
				If mv_par14 = 1
					oSection1:PrintLine()
					aFill(aDados1,nil)
				EndIf
			EndIf
			TRB->(dbSkip())
		EndDo
		
		If (nG01+nG02+nG03+nG04+nG05+nG06+nG07+nG08+nG09+nG10+nG11+nG12)>0
			
			DbSelectArea("SBM")
			DbSetOrder(1)
			DbSeek(xFilial("SBM") + Alltrim(cGCod) )
			
			aDados1[CODIGO]		:= cGCod
			aDados1[DESCRICAO]	:= SBM->BM_DESC
			aDados1[VLJAN]		:= nG01
			aDados1[VLFEV]		:= nG02
			aDados1[VLMAR]		:= nG03
			aDados1[VLABR]		:= nG04
			aDados1[VLMAI]		:= nG05
			aDados1[VLJUN]		:= nG06
			aDados1[VLJUL]		:= nG07
			aDados1[VLAGO]		:= nG08
			aDados1[VLSET]		:= nG09
			aDados1[VLOUT]		:= nG10
			aDados1[VLNOV]		:= nG11
			aDados1[VLDEZ]		:= nG12
			aDados1[VLANO]		:= nG01+nG02+nG03+nG04+nG05+nG06+nG07+nG08+nG09+nG10+nG11+nG12
			aDados1[TIPO]		:= "Back To Back"
			
			
			nG01 := 0
			nG02 := 0
			nG03 := 0
			nG04 := 0
			nG05 := 0
			nG06 := 0
			nG07 := 0
			nG08 := 0
			nG09 := 0
			nG10 := 0
			nG11 := 0
			nG12 := 0
			
			If mv_par14 <> 3
				If mv_par14 = 1
					oReport:SkipLine()
					oReport:ThinLine()
				EndIf
				oSection1:PrintLine()
				aFill(aDados1,nil)
				If mv_par14 = 1
					oReport:ThinLine()
					oReport:SkipLine()
				EndIf
			EndIf
		EndIf
		
		If (nA01+nA02+nA03+nA04+nA05+nA06+nA07+nA08+nA09+nA10+nA11+nA12)>0
			
			DbSelectArea("SX5")
			DbSetOrder(1)
			DbSeek(xFilial("SX5") + "ZZ" + IIF(SUBSTR(cACod,1,1)="0",SUBSTR(cACod,2,1),cACod) )
			
			aDados1[CODIGO]		:= cACod
			aDados1[DESCRICAO]	:= IIF(Empty(cACod),".Outros","."+Alltrim(SX5->X5_DESCRI))
			aDados1[VLJAN]		:= nA01
			aDados1[VLFEV]		:= nA02
			aDados1[VLMAR]		:= nA03
			aDados1[VLABR]		:= nA04
			aDados1[VLMAI]		:= nA05
			aDados1[VLJUN]		:= nA06
			aDados1[VLJUL]		:= nA07
			aDados1[VLAGO]		:= nA08
			aDados1[VLSET]		:= nA09
			aDados1[VLOUT]		:= nA10
			aDados1[VLNOV]		:= nA11
			aDados1[VLDEZ]		:= nA12
			aDados1[VLANO]		:= nA01+nA02+nA03+nA04+nA05+nA06+nA07+nA08+nA09+nA10+nA11+nA12
			aDados1[TIPO]		:= "Back To Back"
			
			nA01 := 0
			nA02 := 0
			nA03 := 0
			nA04 := 0
			nA05 := 0
			nA06 := 0
			nA07 := 0
			nA08 := 0
			nA09 := 0
			nA10 := 0
			nA11 := 0
			nA12 := 0
			
			If mv_par14 <> 3
				oReport:SkipLine()
				oReport:ThinLine()
			EndIf
			oSection1:PrintLine()
			aFill(aDados1,nil)
			If mv_par14 <> 3
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
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ MARKFILE ∫Autor  ≥ Vitor Merguizo     ∫ Data ≥  08/09/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ FunÁ„o auxiliar para seleÁ„o de Arquivos                   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function MarkFile()
	
	Local aArea		:= SM0->(GetArea())
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
	
	DbSelectArea("SM0")
	DbSetOrder(1)
	SM0->(DbGoTop())
	
	While SM0->(!Eof())
		If SM0->M0_CODIGO <> cEmpresa .And. SM0->M0_CODIGO <> "06" //N„o Carrega a EMpresa 06
			//+--------------------------------------------------------------------+
			//| aChaveArq - Contem os arquivos que ser„o exibidos para seleÁ„o |
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
	
RETURN aChaveArq

//FunÁ„o auxiliar: TROCA()
Static Function Troca(nIt,aArray)
	aArray[nIt,1] := !aArray[nIt,1]
Return aArray

//FunÁ„o auxiliar: MARCAOK()
Static Function MarcaOk(aArray)
	Local lRet:=.F.
	Local nx:=0
	// Checa marcaÁıes efetuadas
	For nx:=1 To Len(aArray)
		If aArray[nx,1]
			lRet:=.T.
		EndIf
	Next
	// Checa se existe algum item marcado na confirmaÁ„o
	If !lRet
		MsgAlert("N„o existem Empresas marcadas")
	EndIf
Return lRet

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo	 ≥Ajusta    ≥ Autor ≥ Vitor Merguizo 		  ≥ Data ≥ 16/08/2012		≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Insere novas perguntas na tabela SX1 a Ajusta o Picture dos valores	≥±±
±±≥          ≥ no SX3                                                           	≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe e ≥ 																		≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function Ajusta()
	
	Local aPergs 	:= {}
	
	Aadd(aPergs,{"Ano ?                        ","Ano ?                        ","Ano ?                        ","mv_ch1","C",4,0,0,"G",""                    ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Produto de ?                 ","Produto de ?                 ","Produto de ?                 ","mv_ch2","C",15,0,0,"G",""                   ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
	Aadd(aPergs,{"Produto ate ?                ","Produto ate ?                ","Produto ate ?                ","mv_ch3","C",15,0,0,"G",""                   ,"mv_par03","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
	Aadd(aPergs,{"Grupo de ?                   ","Grupo de ?                   ","Grupo de ?                   ","mv_ch4","C",4,0,0,"G",""                    ,"mv_par04","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SBM","S","",""})
	Aadd(aPergs,{"Grupo ate ?                  ","Grupo ate ?                  ","Grupo ate ?                  ","mv_ch5","C",4,0,0,"G",""                    ,"mv_par05","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SBM","S","",""})
	Aadd(aPergs,{"Agrupamento de ?             ","Agrupamento de ?             ","Agrupamento de ?             ","mv_ch6","C",3,0,0,"G",""                    ,"mv_par06","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Agrupamento ate ?            ","Agrupamento ate ?            ","Agrupamento ate ?            ","mv_ch7","C",3,0,0,"G",""                    ,"mv_par07","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Cliente de ?                 ","Cliente de ?                 ","Cliente de ?                 ","mv_ch8","C",6,0,0,"G",""                    ,"mv_par08","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SA1","S","",""})
	Aadd(aPergs,{"Loja de ?                    ","Loja de ?                    ","Loja de ?                    ","mv_ch9","C",2,0,0,"G",""                    ,"mv_par09","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Cliente ate ?                ","Cliente ate ?                ","Cliente ate ?                ","mv_cha","C",6,0,0,"G",""                    ,"mv_par10","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SA1","S","",""})
	Aadd(aPergs,{"Loja ate ?                   ","Loja ate ?                   ","Loja ate ?                   ","mv_chb","C",2,0,0,"G",""                    ,"mv_par11","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Considera os Clientes:       ","Considera os Clientes:       ","Considera os Clientes:       ","mv_chc","C",30,0,0,"G",""                   ,"mv_par12","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"N„o Considera os Clientes:   ","N„o Considera os Clientes:   ","N„o Considera os Clientes:   ","mv_chd","C",30,0,0,"G",""                   ,"mv_par13","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Imprime Detalhes ?           ","Imprime Detalhes ?           ","Imprime Detalhes ?           ","mv_che","N",1,0,1,"C",""                    ,"mv_par14","Cod.+Grp.+Agr.","Cod.+Grp.+Agr.","Cod.+Grp.+Agr.","","","Grp.+Agr.     ","Grp.+Agr.     ","Grp.+Agr.     ","","","Agr.","Agr.","Agr.","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Data de ?                    ","Data de ?                    ","Data de ?                    ","mv_chf","D",8,0,0,"G",""                    ,"mv_par15","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Data ate ?                   ","Data ate ?                   ","Data ate ?                   ","mv_chg","D",8,0,0,"G",""                    ,"mv_par16","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Somente EX?(S/N)             ","Somente EX?                  ","Somente EX?                  ","mv_chh","C",1,0,0,"G",""                    ,"mv_par17","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	//Aadd(aPergs,{"N„o Considera os paises:     ","N„o Considera os paises:     ","N„o Considera os paises:     ","mv_chi","C",30,0,0,"G",""                   ,"mv_par18","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Considera os paises:     ","N„o Considera os paises:     ","N„o Considera os paises:     ","mv_chi","C",30,0,0,"G",""                   ,"mv_par18","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	
	//AjustaSx1("STFLR3",aPergs)
	
Return
