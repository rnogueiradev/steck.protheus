#include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TOTVS.ch"

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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STESRB01 º Autor ³ Everaldo Gallo     º Data ³  08/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de curva FMR - Versão 2                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STESRB01()

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

	oReport := TReport():New("STESR001","RELATORIO FMR/ABC","STESR00102",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir as quantidades FMR conforme parametros selecionados.")
	oReport:SetLandscape()
	oReport:nFontBody := 6

	pergunte("STESR00102",.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros						  ³
	//³ mv_par01 | Mes                                                ³
	//³ mv_par02 | Ano                                                ³
	//³ mv_par03 | Corte F                                            ³
	//³ mv_par04 | Corte M                                            ³
	//³ mv_par05 | Curva A                                            ³
	//³ mv_par06 | Curva B                                            ³
	//³ mv_par07 | Curva C                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oSection1 := TRSection():New(oReport,"Curva  FMR ",{""},)
	TRCell():New(oSection1,"CODIGO"		,"TRB","Codigo"				,						,15,.F.,)
	TRCell():New(oSection1,"DESCRICAO"	,"TRB","Descricao"			,						,25,.F.,)
	TRCell():New(oSection1,"B1_GRUPO"	,"TRB","Grupo"				,						,4,.F.,) 	//Renato 060813
	TRCell():New(oSection1,"B1_TIPO"	,"TRB","TIPO"				,						,02,.F.,)
	TRCell():New(oSection1,"B1_PROC"	,"TRB","FORNECEDOR"			,						,06,.F.,)
	TRCell():New(oSection1,"B1_LOJPROC"	,"TRB","LOJA"				,						,02,.F.,)
	TRCell():New(oSection1,"B1_CLAPROD"	,"TRB","CLAS PROD"			,						,10,.F.,)
	TRCell():New(oSection1,"CURVA_FMR"	,"TRB","Clas. FMR"			,"@!"					, 2,.F.,)
	TRCell():New(oSection1,"ABC"		,	  ,"Curva ABC" 			,"@!"					, 1,.F.,)
	TRCell():New(oSection1,"MEDIA_6M"	,"TRB","Med. Ult 6 Meses"	,"@E 9,999,999,999.99"	,16,.F.,)
	TRCell():New(oSection1,"CONSUMO_6M"	,"TRB","Consumo 6 Meses"	,"@E 9,999,999,999.99"	,16,.F.,)
	TRCell():New(oSection1,"CUSTO"		,"TRB","Custo Medio"		,"@E 9,999,999,999.99"	,16,.F.,)
	TRCell():New(oSection1,"OCR_6M"		,"TRB","Movimentos(6M)"		,"@E 9,999,999,999.99"	,16,.F.,)
	TRCell():New(oSection1,"VALOR_6M"	,"TRB","Valor Total(6M)"	,"@E 9,999,999,999.99"	,16,.F.,)
	TRCell():New(oSection1,"B2_QATU"	,"TRB","Saldo Atual(LC.Pad)","@E 9,999,999,999.99"	,16,.F.,)
	TRCell():New(oSection1,"PERC"		,     ,"Percentual"			,"@E 9,999.9999"	,16,.F.,)
	TRCell():New(oSection1,"PEDIDOS"    ,"TRB","Ped Venda"			,"@E 9999,999,999"	,16,.F.,)
	TRCell():New(oSection1,"CONSUMO_3M"	,"TRB","Consumo 3 Meses"	,"@E 9,999,999,999.99"	,16,.F.,)
	TRCell():New(oSection1,"B1_XABC"    ,"TRB","ABC Cadastro"				,"@!"	,3,.F.,)
	TRCell():New(oSection1,"B1_XFMR"    ,"TRB","FMR Cadastro"				,"@!"	,3,.F.,)
	TRCell():New(oSection1,"B1_XOFLOG"	,"TRB","Oferta Log. Cadastro"		,"@E 999"	,3,.F.,)
	TRCell():New(oSection1,"SLDLIQ"		,"TRB","Saldo líquido"		,"@E 9,999,999,999.99"	,16,.F.,)
	TRCell():New(oSection1,"MEDIATRIM"		,"TRB","MEDIA TRIM"		,"@E 9,999,999,999.99"	,16,.F.,)

	oSection1:Cell("MEDIA_6M"):SetHeaderAlign("RIGHT")
	oSection1:Cell("CUSTO"):SetHeaderAlign("RIGHT")
	oSection1:Cell("OCR_6M"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VALOR_6M"):SetHeaderAlign("RIGHT")
	oSection1:Cell("CONSUMO_6M"):SetHeaderAlign("RIGHT")
	oSection1:Cell("CONSUMO_3M"):SetHeaderAlign("RIGHT")
	oSection1:Cell("PERC"):SetHeaderAlign("RIGHT")
	oSection1:Cell("SLDLIQ"):SetHeaderAlign("RIGHT")

	oSection1:SetHeaderSection(.T.)

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

	Local cTitulo		:= OemToAnsi("Curva FMR/ABC - base:"+mv_par01+"/"+mv_par02)
	Local cQuery		:= ""
	Local oSection1  := oReport:Section(1)
	Local _cMediaTrim := 0

	Dbselectarea("SB3")
	SB3->(DbSetOrder(1))

	if !MV_PAR01 $ '01--02--03--04--05--06//07--08--09--10--11--12'
		MsgStop("Somente Meses de 01 a 12 ão validos !!! Verifique !!!")
		Return
	endif

	if val(mv_par02) > year(dDatabase)+10 .or. val(mv_par02) < year(dDatabase)-10
		MsgStop("Ano invalido !!! Verifique !!!")
		Return
	endif

	if mv_par04 >  mv_par03
		MsgStop("Cortes FMR invalidos !!! Verifique !!!")
		Return
	endif

	if mv_par05 + mv_par06 + mv_par07  <> 100
		MsgStop("Parametros de Curva ABC diferente de 100 !!! Verifique !!!")
		Return
	endif

	_cDtFim := LastDay(ctod("01/"+strzero(val(mv_par01))+"/"+mv_par02) )
	_cDtIni := _cDtFim - 364

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

	_cQuery := ""

	//Nova
	_cQuery += " SELECT ZZZ.*, AAA.SDLDISP SLDLIQ
	_cQuery += " FROM (
	_cQuery += "  SELECT FILIAL, CODIGO, DESCRICAO, B1_GRUPO, B1_TIPO, B1_PROC, B1_COD, B1_LOJPROC, B1_CLAPROD, B1_XABC, B1_XFMR,
	_cQuery += "   B1_XOFLOG, CURVA_FMR, ACUMULADO, OCR_6M, CONSUMO_6M, CONSUMO_3M, MEDIA_6M, VALOR_6M, CONS_M01, CONS_M02, CONS_M03,
	_cQuery += "   CONS_M04, CONS_M05, CONS_M06, CONS_M07, CONS_M08, CONS_M09, CONS_M10, CONS_M11, CONS_M12, B2_QATU, OCR_M01,
	_cQuery += "   OCR_M02, OCR_M03, OCR_M04, OCR_M05, OCR_M06, OCR_M07, OCR_M08, OCR_M09, OCR_M10, OCR_M11, OCR_M12, CUSTO, CSUT2, TOTAL_CONSUMO, NVL(SUM(C6_QTDVEN),0) PEDIDOS
	_cQuery += "  FROM (

	_cQuery += " SELECT FILIAL  ,CODIGO , DESCRICAO , B1_GRUPO, B1_TIPO,B1_PROC,B1_COD,B1_LOJPROC ,B1_CLAPROD, B1_XABC, B1_XFMR, B1_XOFLOG,  "       +chr(10)+chr(13)

	//_cQuery += " (SELECT SUM(B2_QATU-B2_QACLASS)-(SELECT SUM(DC_QUANT) FROM "+ RETSQLNAME("SDC")+" DC WHERE B2.B2_COD=DC.DC_PRODUTO AND DC_LOCAL IN ('01','03') AND DC.D_E_L_E_T_=' ') "+chr(10)+chr(13)
	//_cQuery += " -(SELECT SUM(PA2_QUANT) FROM "+ RETSQLNAME("PA2")+" PA2 WHERE B2.B2_COD=PA2.PA2_CODPRO AND PA2.D_E_L_E_T_=' ') FROM "+ RETSQLNAME("SB2")+" B2 LEFT JOIN "+ RETSQLNAME("SB1")+" B1 ON B1_COD=B2_COD "+chr(10)+chr(13)
	//_cQuery += " WHERE B2.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND B1_LOCPAD=B2_LOCAL AND B2.B2_COD=CODIGO GROUP BY B2_COD) AS SLDLIQ, "+chr(10)+chr(13)

	_cQuery += " CASE WHEN OCR_6M > '"+str(MV_PAR03,2)+"'  THEN 'F' ELSE CASE WHEN OCR_6M > '"+str(MV_PAR04,2)+"'  THEN 'M' ELSE CASE WHEN OCR_6M > '"+str(MV_PAR10,2)+"' THEN 'R' ELSE 'RR'END END END AS CURVA_FMR, "
	_cQuery += " SUM(VALOR_6M) OVER (ORDER BY VALOR_6M DESC)  AS  ACUMULADO, OCR_6M,CONSUMO_6M, CONSUMO_3M, MEDIA_6M, VALOR_6M, CONS_M01, "  +chr(10)+chr(13)
	_cQuery += " CONS_M02,CONS_M03,CONS_M04,CONS_M05,CONS_M06,CONS_M07,CONS_M08,CONS_M09,CONS_M10,CONS_M11,CONS_M12,B2_QATU, "  +chr(10)+chr(13)
	_cQuery += " OCR_M01,OCR_M02,OCR_M03,OCR_M04,OCR_M05,OCR_M06,OCR_M07,OCR_M08,OCR_M09,OCR_M10,OCR_M11,OCR_M12,CUSTO,CSUT2,TOTAL_CONSUMO "
	//_cQuery += " ,NVL((SELECT SUM(C6_QTDVEN) FROM SC6010 WHERE C6_ENTRE1 BETWEEN  '"+dtos(_cDtini)+"' AND '"+dtos(_cDtFim)+"' AND CODIGO = C6_PRODUTO AND D_E_L_E_T_ = ' ' ),0) AS PEDIDOS    "   +chr(10)+chr(13)
	_cQuery += " FROM ( "  +chr(10)+chr(13)
	_cQuery += " SELECT FILIAL,CODIGO,B1_DESC AS DESCRICAO, B1_GRUPO, ROUND(MAX(B2_CM1),2) AS CSUT2, B1_TIPO,B1_PROC,B1_COD,B1_LOJPROC,B1_CLAPROD,B1_XABC, B1_XFMR, B1_XOFLOG ,MAX(B2_QATU) AS B2_QATU,  "  +chr(10)+chr(13)
	_cQuery += " NVL(ROUND(MAX(CASE WHEN B2_CM1 > 0 THEN B2_CM1 ELSE (CASE WHEN B1_CUSTD > 0 THEN B1_CUSTD ELSE 0.01 END) END),2),0) AS CUSTO , "  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer01+"' THEN CONSUMO ELSE 0 END) AS CONS_M01 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer02+"' THEN CONSUMO ELSE 0 END) AS CONS_M02 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer03+"' THEN CONSUMO ELSE 0 END) AS CONS_M03 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer04+"' THEN CONSUMO ELSE 0 END) AS CONS_M04 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer05+"' THEN CONSUMO ELSE 0 END) AS CONS_M05 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer06+"' THEN CONSUMO ELSE 0 END) AS CONS_M06 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer07+"' THEN CONSUMO ELSE 0 END) AS CONS_M07 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer08+"' THEN CONSUMO ELSE 0 END) AS CONS_M08 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer09+"' THEN CONSUMO ELSE 0 END) AS CONS_M09 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer10+"' THEN CONSUMO ELSE 0 END) AS CONS_M10 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer11+"' THEN CONSUMO ELSE 0 END) AS CONS_M11 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer12+"' THEN CONSUMO ELSE 0 END) AS CONS_M12 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer01+"' THEN OCORRENCIAS ELSE 0 END) AS OCR_M01 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer02+"' THEN OCORRENCIAS ELSE 0 END) AS OCR_M02 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer03+"' THEN OCORRENCIAS ELSE 0 END) AS OCR_M03 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer04+"' THEN OCORRENCIAS ELSE 0 END) AS OCR_M04 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer05+"' THEN OCORRENCIAS ELSE 0 END) AS OCR_M05 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer06+"' THEN OCORRENCIAS ELSE 0 END) AS OCR_M06 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer07+"' THEN OCORRENCIAS ELSE 0 END) AS OCR_M07 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer08+"' THEN OCORRENCIAS ELSE 0 END) AS OCR_M08 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer09+"' THEN OCORRENCIAS ELSE 0 END) AS OCR_M09 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer10+"' THEN OCORRENCIAS ELSE 0 END) AS OCR_M10 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer11+"' THEN OCORRENCIAS ELSE 0 END) AS OCR_M11 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE PERIODO WHEN  '"+_cPer12+"' THEN OCORRENCIAS ELSE 0 END) AS OCR_M12 ,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CONSUMO) AS TOTAL_CONSUMO,"  +chr(10)+chr(13)
	_cQuery += "  ROUND(ROUND(SUM(CONSUMO),0)* "  +chr(10)+chr(13)
	_cQuery += "  NVL(ROUND(MAX(CASE WHEN B2_CM1 > 0 THEN B2_CM1 ELSE (CASE WHEN B1_CUSTD > 0 THEN B1_CUSTD ELSE 0.01 END) END),2),0),2)  AS VALOR_GERAL,"  +chr(10)+chr(13)
	_cQuery += "  SUM(CASE WHEN  PERIODO IN ( '"+_cPer01+"', '"+_cPer02+"', '"+_cPer03+"', '"+_cPer04+"', '"+_cPer05+"', '"+_cPer06+"') THEN OCORRENCIAS ELSE 0 END) AS OCR_6M ,"  +chr(10)+chr(13)
	_cQuery += "  ROUND((SUM(CASE WHEN PERIODO IN ( '"+_cPer01+"', '"+_cPer02+"', '"+_cPer03+"', '"+_cPer04+"', '"+_cPer05+"', '"+_cPer06+"')  THEN CONSUMO ELSE 0 END)),0) AS CONSUMO_6M ,"  +chr(10)+chr(13)
	_cQuery += "  ROUND((SUM(CASE WHEN PERIODO IN ( '"+_cPer01+"', '"+_cPer02+"', '"+_cPer03+"')  THEN CONSUMO ELSE 0 END)),0) AS CONSUMO_3M ,"  +chr(10)+chr(13)
	_cQuery += "  ROUND((SUM(CASE WHEN PERIODO IN ( '"+_cPer01+"', '"+_cPer02+"', '"+_cPer03+"', '"+_cPer04+"', '"+_cPer05+"', '"+_cPer06+"')  THEN CONSUMO ELSE 0 END)/6),0) AS MEDIA_6M ,"  +chr(10)+chr(13)
	_cQuery += "  ROUND(ROUND((SUM(CASE WHEN PERIODO IN ( '"+_cPer01+"', '"+_cPer02+"', '"+_cPer03+"', '"+_cPer04+"', '"+_cPer05+"', '"+_cPer06+"')  THEN CONSUMO ELSE 0 END)/6),0)* "  +chr(10)+chr(13)
	_cQuery += "  NVL(ROUND(MAX(CASE WHEN B2_CM1 > 0 THEN B2_CM1 ELSE (CASE WHEN B1_CUSTD > 0 THEN B1_CUSTD ELSE 0.01 END) END),2),0),2)  AS VALOR_6M "  +chr(10)+chr(13)
	_cQuery += "  FROM ( "  +chr(10)+chr(13)
	_cQuery += "  SELECT '  ' AS FILIAL ,B1_COD AS CODIGO, " +chr(10)+chr(13)
	_cQuery += "  NVL(SUM(CASE WHEN F4_ESTOQUE = 'S'   AND  F4_DUPLIC = 'S' THEN D2_QUANT ELSE 0 END),0) AS CONSUMO,   "+chr(10)+chr(13)
	_cQuery += "  NVL(SUM(CASE WHEN F4_ESTOQUE = 'S'   AND  F4_DUPLIC = 'S' THEN 1 ELSE 0 END),0) AS OCORRENCIAS,      "+chr(10)+chr(13)
	_cQuery += "  NVL(SUBSTR(D2_EMISSAO,1,6),0) PERIODO 														       "+chr(10)+chr(13)
	_cQuery += "  FROM " + RETSQLNAME("SB1") + " B1 "  +chr(10)+chr(13)
	_cQuery += "  LEFT JOIN "+ RETSQLNAME("SD2") + " SD2 ON B1.B1_COD=SD2.D2_COD AND D2_EMISSAO BETWEEN '"+dtos(_cDtini)+"' AND '"+dtos(_cDtFim)+"' AND sd2.D_E_L_E_T_ = ' '  AND D2_FILIAL IN ('01','02') "  +chr(10)+chr(13)
	_cQuery += "  AND    D2_TP      BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "  +chr(10)+chr(13)
	_cQuery += "  LEFT JOIN "+ RETSQLNAME("SF4") + " SF4 ON F4_FILIAL = '  ' AND F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = ' '  AND  F4_ESTOQUE = 'S'   AND  F4_DUPLIC = 'S' "  +chr(10)+chr(13)
	_cQuery += "  WHERE B1.D_E_L_E_T_=' ' AND B1_TIPO BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "  +chr(10)+chr(13)
	_cQuery += "  GROUP BY B1_COD,SUBSTR(D2_EMISSAO,1,6) "  +chr(10)+chr(13)
	_cQuery += "  UNION ALL "  +chr(10)+chr(13)
	_cQuery += "  SELECT '  ' AS FILIAL,D3_COD AS CODIGO,SUM(D3_QUANT) AS CONSUMO, COUNT(*) AS OCORRENCIAS ,   SUBSTR(D3_EMISSAO,1,6) AS PERIODO "  +chr(10)+chr(13)
	_cQuery += "  FROM " + RETSQLNAME("SD3") + " WHERE D3_EMISSAO BETWEEN '"+dtos(_cDtini)+"' AND '"+dtos(_cDtFim)+"'   AND D3_FILIAL IN ('01','02')  "  +chr(10)+chr(13)
	_cQuery += "  AND D_E_L_E_T_ = ' '  AND D3_OP <> ' ' AND D3_CF  LIKE 'RE%' AND D3_ESTORNO = ' '    "  +chr(10)+chr(13)
	_cQuery += "  AND D3_TIPO         BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "  +chr(10)+chr(13)
	_cQuery += "  GROUP BY  D3_COD,SUBSTR(D3_EMISSAO,1,6) "  +chr(10)+chr(13)
	_cQuery += "  ) DDDD "  +chr(10)+chr(13)
	_cQuery += "  LEFT JOIN "+ RETSQLNAME("SB1")+" ON B1_COD =  CODIGO AND SB1010.D_E_L_E_T_ = ' ' "   +chr(10)+chr(13)
	_cQuery += "  LEFT JOIN "+ RETSQLNAME("SB2")+" ON B2_FILIAL =  '02' AND B2_COD =  CODIGO AND B2_LOCAL = SB1010.B1_LOCPAD AND SB2010.D_E_L_E_T_ = ' ' "  +chr(10)+chr(13)
	_cQuery += "  WHERE B1_DESC NOT LIKE '%RETR%' AND B1_TIPO BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' " +chr(10)+chr(13)
	_cQuery += "  AND B1_MSBLQL='2' "+chr(10)+chr(13)
	//_cQuery += "  HAVING SUM(CASE WHEN  PERIODO IN ( '"+_cPer01+"', '"+_cPer02+"', '"+_cPer03+"', '"+_cPer04+"', '"+_cPer05+"', '"+_cPer06+"') THEN OCORRENCIAS ELSE 0 END) > 0 "  +chr(10)+chr(13)
	_cQuery += "  GROUP BY FILIAL,CODIGO,B1_DESC,B1_GRUPO,B1_TIPO,B1_PROC,B1_COD,B1_LOJPROC,B1_CLAPROD, B1_XABC, B1_XFMR, B1_XOFLOG "  +chr(10)+chr(13)
	_cQuery += "  ORDER BY FILIAL,CODIGO,B1_DESC,B1_GRUPO,B1_TIPO,B1_PROC,B1_COD,B1_LOJPROC,B1_CLAPROD, B1_XABC, B1_XFMR, B1_XOFLOG "  +chr(10)+chr(13)
	_cQuery += "  ) TABFIM "   +chr(10)+chr(13)
	_cQuery += "  ORDER BY VALOR_6M DESC "

	//Nova 
	_cQuery += "  ) XXX
	_cQuery += "   LEFT JOIN "+RetSqlName("SC6")+" C6
	_cQuery += "   ON C6_PRODUTO=CODIGO AND C6.D_E_L_E_T_=' ' AND C6.C6_ENTRE1 BETWEEN '"+dtos(_cDtini)+"' AND '"+dtos(_cDtFim)+"'
	_cQuery += "   GROUP BY FILIAL, CODIGO, DESCRICAO, B1_GRUPO, B1_TIPO, B1_PROC, B1_COD, B1_LOJPROC, B1_CLAPROD, B1_XABC, B1_XFMR,
	_cQuery += "   B1_XOFLOG, CURVA_FMR, ACUMULADO, OCR_6M, CONSUMO_6M, CONSUMO_3M, MEDIA_6M, VALOR_6M, CONS_M01, CONS_M02, CONS_M03,
	_cQuery += "   CONS_M04, CONS_M05, CONS_M06, CONS_M07, CONS_M08, CONS_M09, CONS_M10, CONS_M11, CONS_M12, B2_QATU, OCR_M01,
	_cQuery += "   OCR_M02, OCR_M03, OCR_M04, OCR_M05, OCR_M06, OCR_M07, OCR_M08, OCR_M09, OCR_M10, OCR_M11, OCR_M12, CUSTO, CSUT2, TOTAL_CONSUMO
	_cQuery += "   ) ZZZ
	_cQuery += "   LEFT JOIN (
	_cQuery += "   SELECT B1_COD, QATU-DCQTD-PA2QTD SDLDISP
	_cQuery += " FROM (
	_cQuery += " SELECT B1_COD, NVL(SUM(B2_QATU-B2_QACLASS),0) QATU, NVL(SUM(DC_QUANT),0) DCQTD, NVL(SUM(PA2_QUANT),0) PA2QTD
	_cQuery += " FROM "+RetSqlName("SB1")+" B1
	_cQuery += " LEFT JOIN "+RetSqlName("SB2")+" B2
	_cQuery += " ON B2.D_E_L_E_T_=' ' AND B2_LOCAL=B1_LOCPAD AND B2_COD=B1_COD AND B2.B2_FILIAL<>' ' 
	_cQuery += " LEFT JOIN (SELECT DC_PRODUTO, SUM(DC_QUANT) DC_QUANT
	_cQuery += " FROM "+RetSqlName("SDC")+" DC
	_cQuery += " WHERE DC.D_E_L_E_T_=' ' AND DC_QUANT>0 AND DC_LOCAL IN ('01','03')
	_cQuery += " GROUP BY DC_PRODUTO) DC
	_cQuery += " ON DC.DC_PRODUTO=B2.B2_COD
	_cQuery += " LEFT JOIN (SELECT PA2_CODPRO, SUM(PA2_QUANT) PA2_QUANT
	_cQuery += " FROM "+RetSqlName("PA2")+" PA2
	_cQuery += " WHERE PA2.D_E_L_E_T_=' ' AND PA2_QUANT>0
	_cQuery += " GROUP BY PA2_CODPRO) PA2
	_cQuery += " ON PA2.PA2_CODPRO=B2.B2_COD
	_cQuery += " WHERE B1.D_E_L_E_T_=' '
	_cQuery += " GROUP BY B1_COD
	_cQuery += " ) XXX
	_cQuery += "   ) AAA
	_cQuery += "   ON AAA.B1_COD=CODIGO 

	//MEMOWRITE("FMR.SQL",_cQuery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"TRB", .F., .T.)

	TRB->(dbGoTop())
	_ntotal:=0
	_nCount:=0

	dbeval({||_nCount++,_ntotal+=VALOR_6M})

	_nCurvaA :=_ntotal * (mv_par05 / 100)
	_nCurvaB :=_nCurvaA+(_ntotal * (mv_par06 / 100) )

	oReport:SetMeter(_nCount)

	oReport:SetTitle(cTitulo)
	oSection1:Init()

	TRB->(dbGoTop())

	While TRB->(!Eof())

		_cMediaTrim	:= GETMEDIA(TRB->B1_COD)

		Do Case
			Case TRB->ACUMULADO <= _nCurvaA
			_cCurva := "A"
			Case TRB->ACUMULADO <= _nCurvaB
			_cCurva := "B"
			OtherWise
			_cCurva := "C"
		EndCase

		Do Case
			Case TRB->B1_CLAPROD = 'I'
			_cClassif := "Importado "
			Case TRB->B1_CLAPROD = 'F'
			_cClassif := "Fabricado"
			Case TRB->B1_CLAPROD = 'C'
			_cClassif := "Comprado"
			OtherWise
			_cClassif := "  "
		EndCase

		_nPerc :=( TRB->VALOR_6M/_ntotal ) * 100
		oSection1:Cell("ABC"):SetValue(_cCurva)
		oSection1:Cell("PERC"):SetValue(_nPerc)
		oSection1:Cell("B1_CLAPROD"):SetValue(_cClassif)
		oSection1:Cell("MEDIATRIM"):SetValue(_cMediaTrim)

		If TRB->OCR_6M==0
			oSection1:Cell("CURVA_FMR"):SetValue("O")
		Else
			oSection1:Cell("CURVA_FMR"):SetValue(TRB->CURVA_FMR)
			//oSection1:Cell("ABC"):SetValue("O")
		EndIf

		oSection1:PrintLine()
		oReport:IncMeter()

		TRB->(dbSkip())

	EndDo

	oSection1:Finish()

	DbSelectArea("TRB")
	DbCloseArea("TRB")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Ajusta    ³ Autor ³ RVG  					  ³ Data ³ 16/08/2012		³±±
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

	Aadd(aPergs,{"Mes ?                        ","Mes ?                        ","Mes ?                        ","mv_ch1","C",2,0,0,"G",""                    ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Ano  ?                       ","Ano ?        				   ","Ano ?               		   ","mv_ch2","C",4,0,0,"G",""                    ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Corte F ?                    ","Corte F ?                    ","Corte F ?                    ","mv_ch3","N",3,0,0,"G",""                    ,"mv_par03","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Corte M ?                    ","Corte M ?                    ","Corte M ?                    ","mv_ch4","N",3,0,0,"G",""                    ,"mv_par04","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"% Curva A ?                  ","% Curva A ?                  ","% Curva A ?                  ","mv_ch5","N",2,0,0,"G",""                    ,"mv_par05","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"% Curva B ?         		   ","% Curva B ?       		   ","% Curva B ?                  ","mv_ch6","N",2,0,0,"G",""                    ,"mv_par06","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"% Curva C ?            	   ","% Curva C ?		           ","% Curva C ?                  ","mv_ch7","N",2,0,0,"G",""                    ,"mv_par07","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Tipo De ?         		   ","% Curva B ?       		   ","% Curva B ?                  ","mv_ch8","C",2,0,0,"G",""                    ,"mv_par08","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Tipo Ate ?            	   ","% Curva C ?		           ","% Curva C ?                  ","mv_ch9","C",2,0,0,"G",""                    ,"mv_par09","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Corte R ?                    ","Corte R ?                    ","Corte R ?                    ","mv_ch10","N",3,0,0,"G",""                    ,"mv_par10","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})

	//AjustaSx1("STESR00102",aPergs)

Return

Static Function GETMEDIA(_cCod)

	Local _nMedia	:= 0

	DbSelectArea("SB3")
	SB3->(DbSetOrder(1))
	SB3->(Dbseek(xfilial("SB3")+_cCod))
	_nMedia  := (&("SB3->B3_Q"+StrZero(Month(LastDay(dDataBase)-33),2))+;
	&("SB3->B3_Q"+StrZero(Month(LastDay(dDataBase)-66),2))+;
	&("SB3->B3_Q"+StrZero(Month(LastDay(dDataBase)-99),2)))/3

Return(_nMedia)