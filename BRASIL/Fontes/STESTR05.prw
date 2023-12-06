#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STESTR05   º Autor ³ Vitor Merguizo     º Data ³  02/06/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Materias utilizados na produção                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STESTR05()

Local oReport
Local aArea	:= GetArea()

Ajusta()

If cEmpAnt = "01"
	oReport 	:= ReportDef()
	oReport		:PrintDialog()
Else
	MsgAlert("Relatório valido apenas para empresa Steck Matriz.")
EndIf                                                                  


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

oReport := TReport():New("STESTR05","Relatorio de Materiais Utilizados na Produção","STESTR05",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir uma listagem de materiais utilizados no processo produtivo com base no cadastro de estrutura conforme parametros.")
oReport:SetLandScape(.T.)

pergunte("STESTR05",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						  ³
//³ mv_par01			// Mes							 		  ³
//³ mv_par02			// Ano									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:SetTitle("Relatorio de Materiais Utilizados na Produção")
oSection1:= TRSection():New(oReport,"Itens",{"SD3"},)
oSection1:SetTotalInLine(.t.)
oSection1:SetHeaderPage()
oSection1:Setnofilter("SD3")

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
Local cAlias	:= GetNextAlias()
Local cTrb		:= GetNextAlias()
Local nTotNF	:= 0
Local nTotLib	:= 0
Local nTotSep	:= 0
Local nTotEmb	:= 0
Local oSection1	:= oReport:Section(1)
Local aDados1[13]
Local aStru		:= {}
local oTable
Private cFilPrd := ""
Private cCodPrd := ""
Private cDescPrd := ""
Private cGrpPrd := ""
Private nQtdPrd := 0
Private nCMFim := 0

TRCell():New(oSection1,"FILIAL"	,,"Filial"		,"@!"				,10,/*lPixel*/,{||aDados1[1]})
TRCell():New(oSection1,"CODPRD"	,,"Cod.Prd."	,"@!"				,15,/*lPixel*/,{||aDados1[2]})
TRCell():New(oSection1,"DESPRD"	,,"Desc.Prd."	,"@!"				,30,/*lPixel*/,{||aDados1[3]})
TRCell():New(oSection1,"GRPPRD"	,,"Grp.Prd."	,"@!"				,10,/*lPixel*/,{||aDados1[4]})
TRCell():New(oSection1,"QTDPRD"	,,"Qtd.Prd."	,"@E 9,999,999.9999",16,/*lPixel*/,{||aDados1[5]})
TRCell():New(oSection1,"CMPRD"	,,"Custo Prd."	,"@E 9,999,999.9999",16,/*lPixel*/,{||aDados1[6]})
TRCell():New(oSection1,"PRDTOT"	,,"Total Prd."	,"@E 9,999,999.9999",16,/*lPixel*/,{||aDados1[7]})
TRCell():New(oSection1,"CODCOMP",,"Cod.Comp."	,"@!"				,15,/*lPixel*/,{||aDados1[8]})
TRCell():New(oSection1,"DESCOMP",,"Desc.Comp."	,"@!"				,30,/*lPixel*/,{||aDados1[9]})
TRCell():New(oSection1,"QTDCOMP",,"Qtd.Comp"	,"@E 9,999,999.9999",16,/*lPixel*/,{||aDados1[10]})
TRCell():New(oSection1,"CMCOMP"	,,"Custo.Comp."	,"@E 9,999,999.9999",16,/*lPixel*/,{||aDados1[11]})
TRCell():New(oSection1,"QTDTOT"	,,"Qtd.Total"	,"@E 9,999,999.9999",16,/*lPixel*/,{||aDados1[12]})
TRCell():New(oSection1,"CMTOT"	,,"Custo Total"	,"@E 9,999,999.9999",16,/*lPixel*/,{||aDados1[13]})

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

If mv_par09 = 1
	
	cQuery	:= " SELECT D3_FILIAL,B1_COD,B1_GRUPO,B1_DESC,MAX(B2_CMFIM1)B2_CMFIM1,SUM(D3_QUANT)D3_QUANT "
	cQuery	+= " FROM "+RetSqlName("SD3")+" SD3 "
	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = D3_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery	+= " INNER JOIN (SELECT G1_COD FROM "+RetSqlName("SG1")+" SG1 WHERE G1_FILIAL = '"+xFilial("SG1")+"' AND SG1.D_E_L_E_T_ = ' ' GROUP BY G1_COD)XXX ON G1_COD = D3_COD "
	cQuery	+= " LEFT JOIN "+RetSqlName("SB2")+" SB2 ON B2_FILIAL = D3_FILIAL AND B2_COD = D3_COD AND B2_LOCAL = '03' AND SB2.D_E_L_E_T_ = ' ' "
	cQuery	+= " WHERE "
	cQuery	+= " D3_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	cQuery	+= " D3_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
	cQuery	+= " B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
	cQuery	+= " D3_EMISSAO BETWEEN '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"' AND "
	cQuery	+= " SUBSTR(D3_CF,1,2) = 'PR' AND "
	cQuery	+= " D3_LOCAL = '03' AND "
	cQuery	+= " SD3.D_E_L_E_T_ = ' ' "
	cQuery	+= " GROUP BY D3_FILIAL,B1_COD,B1_GRUPO,B1_DESC "
	
Else
	
	cQuery	:= " SELECT D2_FILIAL D3_FILIAL,B1_COD,B1_GRUPO,B1_DESC,MAX(B2_CMFIM1)B2_CMFIM1,SUM(D2_QUANT)D3_QUANT "
	cQuery	+= " FROM "+RetSqlName("SD2")+" SD2 "
	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery	+= " INNER JOIN (SELECT G1_COD FROM "+RetSqlName("SG1")+" SG1 WHERE G1_FILIAL = '"+xFilial("SG1")+"' AND SG1.D_E_L_E_T_ = ' ' GROUP BY G1_COD)XXX ON G1_COD = D2_COD "
	cQuery	+= " LEFT JOIN "+RetSqlName("SB2")+" SB2 ON B2_FILIAL = '"+xFilial("SB2")+"' AND B2_COD = D2_COD AND B2_LOCAL IN ('03','90') AND SB2.D_E_L_E_T_ = ' ' "
	cQuery	+= " WHERE "
	cQuery	+= " D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	cQuery	+= " D2_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
	cQuery	+= " B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
	cQuery	+= " D2_EMISSAO BETWEEN '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"' AND "
	cQuery	+= " D2_CLIENTE = '"+mv_par10+"' AND "
	cQuery	+= " SD2.D_E_L_E_T_ = ' ' "
	cQuery	+= " GROUP BY D2_FILIAL,B1_COD,B1_GRUPO,B1_DESC "
	
EndIf

cQuery	:= ChangeQuery(cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)

TcSetField(cAlias,"D3_QUANT"	, "N",TamSx3("D3_QUANT" )[1], TamSx3("D3_QUANT" )[2])
TcSetField(cAlias,"B2_CMFIM1"	, "N",TamSx3("B2_CMFIM1")[1], TamSx3("B2_CMFIM1")[2])

DbSelectArea (cAlias)
(cAlias)->(DbGoTop())
nCount:=0
dbeval({||nCount++})

oReport:SetMeter(nCount)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho para a escolha do Grupo de Compra ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd( aStru,{ "XX_FILIAL"	,"C",02,0} )
Aadd( aStru,{ "XX_CODPRD"	,"C",15,0} )
Aadd( aStru,{ "XX_DESPRD"	,"C",30,0} )
Aadd( aStru,{ "XX_GRPPRD"	,"C",04,0} )
Aadd( aStru,{ "XX_QTDPRD"	,"N",16,4} )
Aadd( aStru,{ "XX_CMPRD "	,"N",16,4} )
Aadd( aStru,{ "XX_CODCOMP"	,"C",15,0} )
Aadd( aStru,{ "XX_QTDCOMP"	,"N",16,4} )

//cArqTrab := CriaTrab(aStru) //Função CriaTrab descontinuada, adicionado o oTable no lugar
oTable := FWTemporaryTable():New(cTrb) //adicionado\Ajustado
oTable:SetFields(aStru)				   //adicionado\Ajustado
oTable:Create()						   //adicionado\Ajustado
cAlias	 := oTable:GetAlias()		   //adicionado\Ajustado
cArqTrab := oTable:GetRealName()	   //adicionado\Ajustado
dbUseArea(.T.,"topconn",cArqTrab,(cTrb),.F.,.F.)
IndRegua((cTrb),cArqTrab,"XX_FILIAL+XX_CODPRD+XX_CODCOMP",,,"Indexando Arquivo...")

DbSelectArea(cAlias)
(cAlias)->(dbGoTop())
While (cAlias)->(!Eof())
	
	oReport:IncMeter()
	cFilPrd := (cAlias)->D3_FILIAL
	cCodPrd := (cAlias)->B1_COD
	cDescPrd := (cAlias)->B1_DESC
	cGrpPrd := (cAlias)->B1_GRUPO
	nQtdPrd := (cAlias)->D3_QUANT
	cCMFim	:= (cAlias)->B2_CMFIM1
	STESTR5A((cAlias)->B1_COD,1,cTrb)
	
	(cAlias)->(dbSkip())
EndDo

aFill(aDados1,nil)
oSection1:Init()

DbSelectArea(cTrb)
(cTrb)->(dbGoTop())
While (cTrb)->(!Eof())

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+(cTrb)->XX_CODCOMP))
	
	DbSelectArea("SB2")
	SB2->(DbSetOrder(2))
	SB2->(DbSeek((cTrb)->XX_FILIAL+"90"+(cTrb)->XX_CODCOMP))
	
	aDados1[01] := (cTrb)->XX_FILIAL
	aDados1[02] := (cTrb)->XX_CODPRD
	aDados1[03] := (cTrb)->XX_DESPRD
	aDados1[04] := (cTrb)->XX_GRPPRD
	aDados1[05] := (cTrb)->XX_QTDPRD
	aDados1[06] := (cTrb)->XX_CMPRD
	aDados1[07] := (cTrb)->XX_CMPRD*(cTrb)->XX_QTDPRD
	aDados1[08] := (cTrb)->XX_CODCOMP
	aDados1[09] := SB1->B1_DESC
	aDados1[10] := (cTrb)->XX_QTDCOMP
	aDados1[11] := SB2->B2_CMFIM1
	aDados1[12] := (cTrb)->XX_QTDPRD*(cTrb)->XX_QTDCOMP
	aDados1[13] := (cTrb)->XX_QTDPRD*(cTrb)->XX_QTDCOMP*SB2->B2_CMFIM1
		
	oSection1:PrintLine()
	aFill(aDados1,nil)
	
	(cTrb)->(dbSkip())
EndDo

oSection1:Finish()

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

DbSelectArea(cTrb)
(cTrb)->( DbCloseArea() )
FErase(cArqTrab+GetDBExtension())
FErase(cArqTrab+OrdBagExt())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STESTR5A  ºAutor  ³Microsiga           º Data ³  10/15/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para calculo do componente                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function STESTR5A(cCodigo,nQuant,cTrb)

Local cQuery2	:= ""
Local cAlias2	:= GetNextAlias()
Local nImp		:= 0
Local nRet		:= 0

cQuery2	:= "SELECT G1_NIVEL,G1_COD,G1_COMP,SUM(G1_QUANT) G1_QUANT FROM ( "
cQuery2	+= "SELECT 'N' G1_NIVEL,SG11.G1_COD,SG11.G1_COMP,SG11.G1_QUANT AS G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery2	+= "SG12.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT 'N',SG11.G1_COD,SG12.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery2	+= "SG13.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT 'N',SG11.G1_COD,SG13.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT*SG13.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG14 ON SG13.G1_FILIAL=SG14.G1_FILIAL AND SG13.G1_COMP=SG14.G1_COD AND SG14.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery2	+= "SG14.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT 'N',SG11.G1_COD,SG14.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT*SG13.G1_QUANT*SG14.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG14 ON SG13.G1_FILIAL=SG14.G1_FILIAL AND SG13.G1_COMP=SG14.G1_COD AND SG14.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG15 ON SG14.G1_FILIAL=SG15.G1_FILIAL AND SG14.G1_COMP=SG15.G1_COD AND SG15.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery2	+= "SG15.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT 'N',SG11.G1_COD,SG15.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT*SG13.G1_QUANT*SG14.G1_QUANT*SG15.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG14 ON SG13.G1_FILIAL=SG14.G1_FILIAL AND SG13.G1_COMP=SG14.G1_COD AND SG14.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG15 ON SG14.G1_FILIAL=SG15.G1_FILIAL AND SG14.G1_COMP=SG15.G1_COD AND SG15.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG16 ON SG15.G1_FILIAL=SG16.G1_FILIAL AND SG15.G1_COMP=SG16.G1_COD AND SG16.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery2	+= "SG16.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT 'N',SG11.G1_COD,SG16.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT*SG13.G1_QUANT*SG14.G1_QUANT*SG15.G1_QUANT*SG16.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG14 ON SG13.G1_FILIAL=SG14.G1_FILIAL AND SG13.G1_COMP=SG14.G1_COD AND SG14.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG15 ON SG14.G1_FILIAL=SG15.G1_FILIAL AND SG14.G1_COMP=SG15.G1_COD AND SG15.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG16 ON SG15.G1_FILIAL=SG16.G1_FILIAL AND SG15.G1_COMP=SG16.G1_COD AND SG16.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG17 ON SG16.G1_FILIAL=SG17.G1_FILIAL AND SG16.G1_COMP=SG17.G1_COD AND SG17.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery2	+= "SG17.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT 'N',SG11.G1_COD,SG17.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT*SG13.G1_QUANT*SG14.G1_QUANT*SG15.G1_QUANT*SG16.G1_QUANT*SG17.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG14 ON SG13.G1_FILIAL=SG14.G1_FILIAL AND SG13.G1_COMP=SG14.G1_COD AND SG14.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG15 ON SG14.G1_FILIAL=SG15.G1_FILIAL AND SG14.G1_COMP=SG15.G1_COD AND SG15.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG16 ON SG15.G1_FILIAL=SG16.G1_FILIAL AND SG15.G1_COMP=SG16.G1_COD AND SG16.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG17 ON SG16.G1_FILIAL=SG17.G1_FILIAL AND SG16.G1_COMP=SG17.G1_COD AND SG17.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG18 ON SG17.G1_FILIAL=SG18.G1_FILIAL AND SG17.G1_COMP=SG18.G1_COD AND SG18.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery2	+= "SG18.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT 'N',SG11.G1_COD,SG18.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT*SG13.G1_QUANT*SG14.G1_QUANT*SG15.G1_QUANT*SG16.G1_QUANT*SG17.G1_QUANT*SG18.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG14 ON SG13.G1_FILIAL=SG14.G1_FILIAL AND SG13.G1_COMP=SG14.G1_COD AND SG14.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG15 ON SG14.G1_FILIAL=SG15.G1_FILIAL AND SG14.G1_COMP=SG15.G1_COD AND SG15.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG16 ON SG15.G1_FILIAL=SG16.G1_FILIAL AND SG15.G1_COMP=SG16.G1_COD AND SG16.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG17 ON SG16.G1_FILIAL=SG17.G1_FILIAL AND SG16.G1_COMP=SG17.G1_COD AND SG17.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG18 ON SG17.G1_FILIAL=SG18.G1_FILIAL AND SG17.G1_COMP=SG18.G1_COD AND SG18.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG19 ON SG18.G1_FILIAL=SG19.G1_FILIAL AND SG18.G1_COMP=SG19.G1_COD AND SG19.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery2	+= "SG19.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT CASE WHEN SG10.G1_FILIAL IS NULL THEN 'N' ELSE 'S'END,SG11.G1_COD,SG19.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT*SG13.G1_QUANT*SG14.G1_QUANT*SG15.G1_QUANT*SG16.G1_QUANT*SG17.G1_QUANT*SG18.G1_QUANT*SG19.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG14 ON SG13.G1_FILIAL=SG14.G1_FILIAL AND SG13.G1_COMP=SG14.G1_COD AND SG14.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG15 ON SG14.G1_FILIAL=SG15.G1_FILIAL AND SG14.G1_COMP=SG15.G1_COD AND SG15.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG16 ON SG15.G1_FILIAL=SG16.G1_FILIAL AND SG15.G1_COMP=SG16.G1_COD AND SG16.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG17 ON SG16.G1_FILIAL=SG17.G1_FILIAL AND SG16.G1_COMP=SG17.G1_COD AND SG17.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG18 ON SG17.G1_FILIAL=SG18.G1_FILIAL AND SG17.G1_COMP=SG18.G1_COD AND SG18.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG19 ON SG18.G1_FILIAL=SG19.G1_FILIAL AND SG18.G1_COMP=SG19.G1_COD AND SG19.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG10 ON SG19.G1_FILIAL=SG10.G1_FILIAL AND SG19.G1_COMP=SG10.G1_COD AND SG10.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= ")TEMP "
cQuery2	+= "WHERE G1_COD='"+cCodigo+"' "
cQuery2	+= "GROUP BY G1_COD,G1_COMP,G1_NIVEL "

If !Empty(Select(cAlias2))
	DbSelectArea(cAlias2)
	(cAlias2)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery2),cAlias2,.F.,.T.)

TCSetField(cAlias2,"G1_QUANT","N",14,6 )

dbSelectArea(cAlias2)
(cAlias2)->(DbGoTop())

While (cAlias2)->(!Eof())
	
	If (cAlias2)->G1_NIVEL="S"
		STESTR5A((cAlias2)->G1_COMP,IIf((cAlias2)->G1_QUANT>0,(cAlias2)->G1_QUANT*nQuant,0.0001),cTrb)
	Else
		If (cAlias2)->G1_QUANT>0
			nRet := (cAlias2)->G1_QUANT*nQuant
		Else
			nRet := 0.0001
		EndIf
		
		DbSelectArea(cTrb)
		DbSelectArea(cTrb)
		(cTrb)->( DbSetOrder(1) )
		If !(cTrb)->( DbSeek( cFilPrd+cCodPrd+(cAlias2)->G1_COMP ) )
			RecLock((cTrb),.T.)
			(cTrb)->XX_FILIAL	:= cFilPrd
			(cTrb)->XX_CODPRD	:= cCodPrd
			(cTrb)->XX_DESPRD	:= cDescPrd
			(cTrb)->XX_GRPPRD	:= cGrpPrd
			(cTrb)->XX_QTDPRD	:= nQtdPrd
			(cTrb)->XX_CMPRD	:= cCMFim
			(cTrb)->XX_CODCOMP	:= (cAlias2)->G1_COMP
			(cTrb)->XX_QTDCOMP	:= Round(nRet,4)
			MsUnlock()
		Else
			nRet += (cTrb)->XX_QTDCOMP
			RecLock((cTrb),.F.)
			(cTrb)->XX_QTDCOMP	:= Round(nRet,4)
			MsUnlock()
		EndIf
	EndIf
	
	(cAlias2)->(DbSkip())
	
End

If !Empty(Select(cAlias2))
	DbSelectArea(cAlias2)
	(cAlias2)->(dbCloseArea())
EndIf

Return(nRet)

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

Aadd(aPergs,{"Filial de ?                  ","Filial de ?                  ","Filial de ?                  ","mv_ch1","C",02,0,0,"G",""                   ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","",""   ,"S","",""})
Aadd(aPergs,{"Filial ate ?                 ","Filial ate ?                 ","Filial ate ?                 ","mv_ch2","C",02,0,0,"G",""                   ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","",""   ,"S","",""})
Aadd(aPergs,{"Produto de ?                 ","Produto de ?                 ","Produto de ?                 ","mv_ch3","C",15,0,0,"G",""                   ,"mv_par03","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
Aadd(aPergs,{"Produto ate ?                ","Produto ate ?                ","Produto ate ?                ","mv_ch4","C",15,0,0,"G",""                   ,"mv_par04","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
Aadd(aPergs,{"Grupo de ?                   ","Grupo de ?                   ","Grupo de ?                   ","mv_ch5","C",04,0,0,"G",""                   ,"mv_par05","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SBM","S","",""})
Aadd(aPergs,{"Grupo ate ?                  ","Grupo ate ?                  ","Grupo ate ?                  ","mv_ch6","C",04,0,0,"G",""                   ,"mv_par06","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SBM","S","",""})
Aadd(aPergs,{"Emissao de ?                 ","Emissao de ?                 ","Emissao de ?                 ","mv_ch7","D",08,0,0,"G",""                   ,"mv_par07","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","",""   ,"S","",""})
Aadd(aPergs,{"Emissao ate ?                ","Emissao ate ?                ","Emissao ate ?                ","mv_ch8","D",08,0,0,"G",""                   ,"mv_par08","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","",""   ,"S","",""})
Aadd(aPergs,{"Tipo?                        ","Somente Divergente ?         ","Somente Divergente ?         ","mv_ch9","N",01,0,1,"C",""                   ,"mv_par09","Requisições   ","Requisições   ","Requisições   ","","","Nota Fiscal   ","Nota Fiscal   ","Nota Fiscal   ","","","","","","","","","","","","","","","","",""   ,"S","",""})
Aadd(aPergs,{"Cliente ?                    ","Cliente ?                    ","Cliente ?                    ","mv_cha","C",06,0,0,"G",""                   ,"mv_par10","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SA1","S","",""})


//AjustaSx1("STESTR05",aPergs)

Return
