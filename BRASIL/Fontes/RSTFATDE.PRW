#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*/{Protheus.doc} RSTFATDE.PRW
Relatório de orçamentos com desconto

@author renato.oliveira
@since 24/03/2023
@version 1.0
@return ${return}, ${return_description}

/*/


User Function RSTFATDE()

	Local   oReport
	Private cPerg 		:= "RSTFATDE"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cHora+ cMinutos+cSegundos
	Private lXlsHeader   := .F.
	Private lXmlEndRow   := .F.
	Private cPergTit 		:= cAliasLif
	
	U_STPutSx1( cPerg, "01","Data De?" 			 	,"MV_PAR01","mv_ch1","D",10,0,"G",,"","@D")
	U_STPutSx1( cPerg, "02","Data Até?"				,"MV_PAR02","mv_ch2","D",10,0,"G",,"","@D")
	U_STPutSx1( cPerg, "03","Orcamento De?" 	 	,"MV_PAR03","mv_ch3","C",6,0,"G",,"","@!")
	U_STPutSx1( cPerg, "04","Orcamento Até?"		,"MV_PAR04","mv_ch4","C",6,0,"G",,"","@!")
	U_STPutSx1( cPerg, "05","%Desconto De?" 	 	,"MV_PAR05","mv_ch5","N",14,2,"G",,"","@E 99,999,999,999.99")
	U_STPutSx1( cPerg, "06","%Desconto Até?"		,"MV_PAR06","mv_ch6","N",14,2,"G",,"","@E 99,999,999,999.99")
	
	oReport		:= ReportDef()
	oReport:PrintDialog()
	
Return

/*/{Protheus.doc} ReportDef
@author renato.oliveira
@since 24/03/2023
@version 1.0
/*/


Static Function ReportDef()
	
	Local oReport
	Local oSection
	
	oReport := TReport():New(cPergTit,"Relatório de orçamentos",cPerg,{|oReport| ReportPrint(oReport)},"Este programa fará a impressão dos orçamentos")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Relatório de orçamentos",{"SUA"})
	
	TRCell():New(oSection,"11",,"Numero"			,,TamSX3("UA_NUM")[1],.F.,)
	TRCell():New(oSection,"01",,"Cliente"			,,TamSX3("UA_CLIENTE")[1],.F.,)
	TRCell():New(oSection,"02",,"Loja"				,,TamSX3("UA_LOJA")[1],.F.,)
	TRCell():New(oSection,"03",,"Nome"				,,TamSX3("UA_XNOME")[1],.F.,)
	TRCell():New(oSection,"04",,"Produto"			,,TamSX3("UB_PRODUTO")[1],.F.,)
	TRCell():New(oSection,"05",,"Quant."			,,TamSX3("UB_QUANT")[1],.F.,)
	TRCell():New(oSection,"06",,"V.Unit"			,,TamSX3("UB_VRUNIT")[1],.F.,)
	TRCell():New(oSection,"07",,"Custo"				,,TamSX3("UB_XCUSTO")[1],.F.,)
	TRCell():New(oSection,"08",,"Desconto item"		,,TamSX3("UB_XPORDEC")[1],.F.,)
	TRCell():New(oSection,"09",,"V.Liquido"			,,TamSX3("UB_ZVALLIQ")[1],.F.,)
	TRCell():New(oSection,"10",,"Desc.Geral"		,,TamSX3("ZZI_DESC")[1],.F.,)
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SUA")
	
Return oReport

/*/{Protheus.doc} ReportPrint
@author renato.oliveira
@since 24/04/2023
@version 1.0
/*/

Static Function ReportPrint(oReport)
	
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local aDados[2]
	Local aDados1[99]
	
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

	oReport:SetTitle("SUA")// Titulo do relatório
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
						
			aDados1[01]	:=  (cAliasLif)->UA_CLIENTE
			aDados1[02]	:=  (cAliasLif)->UA_LOJA
			aDados1[03]	:=  (cAliasLif)->UA_XNOME
			aDados1[04]	:=  (cAliasLif)->UB_PRODUTO
			aDados1[05]	:= 	(cAliasLif)->UB_QUANT
			aDados1[06]	:= 	(cAliasLif)->UB_VRUNIT
			aDados1[07]	:=  (cAliasLif)->UB_XCUSTO
			aDados1[08]	:=  (cAliasLif)->UB_XPORDEC
			aDados1[09]	:= 	(cAliasLif)->UB_ZVALLIQ
			aDados1[10]	:=  (cAliasLif)->ZZI_DESC
			aDados1[11]	:=  (cAliasLif)->UA_NUM
			
			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End
		
		oSection1:PrintLine()
		aFill(aDados1,nil)
		
		(cAliasLif)->(dbCloseArea())
	EndIf

	oReport:SkipLine()

Return oReport

/*/{Protheus.doc} StQuery
@author renato.oliveira
@since 24/04/2023
@version 1.0
/*/

Static Function StQuery(_ccod)

	Local cQuery1     := ' '
	
	cQuery1 := " SELECT UA_NUM, UA_CLIENTE, UA_LOJA, UA_XNOME, UB_PRODUTO, UB_QUANT, UB_VRUNIT, UB_XCUSTO, UB_XPORDEC, UB_ZVALLIQ, NVL(ZZI_DESC,0) ZZI_DESC
	cQuery1 += " FROM "+RetSqlName("SUA")+" UA
	cQuery1 += " LEFT JOIN "+RetSqlName("SUB")+" UB
	cQuery1 += " ON UA_FILIAL=UB_FILIAL AND UA_NUM=UB_NUM
	cQuery1 += " LEFT JOIN "+RetSqlName("ZZI")+" ZZI
	cQuery1 += " ON ZZI_FILANT=UA_FILIAL AND ZZI_TIPO='ORÇAMENTO' AND ZZI_NUM=UA_NUM AND ZZI.D_E_L_E_T_=' ' 
	cQuery1 += " WHERE UA.D_E_L_E_T_=' ' AND UB.D_E_L_E_T_=' ' 
	
	cQuery1 += " AND UA_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
	cQuery1 += " AND UA_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
	cQuery1 += " AND ZZI_DESC BETWEEN '"+cValToChar(MV_PAR05)+"' AND '"+cValToChar(MV_PAR06)+"'
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAliasLif)

Return()
	
	
	
	