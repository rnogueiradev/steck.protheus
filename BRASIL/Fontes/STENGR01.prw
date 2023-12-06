#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STESTR05   บ Autor ณ Vitor Merguizo     บ Data ณ  02/06/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Materias utilizados na produ็ใo                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function STENGR01()

Local oReport
Local aArea	:= GetArea()
Private cOrigem := ""
Ajusta()

oReport 	:= ReportDef()
oReport		:PrintDialog()

DbSelectArea("SB1")
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+mv_par01))
If cOrigem<>SB1->B1_ORIGEM .And. mv_par03=1
	If MsgNoYes("Deseja Alterar a Origem do Produto: "+AllTrim(mv_par01)+"-"+AllTrim(SB1->B1_DESC)+" De: '"+SB1->B1_ORIGEM+"' Para: '"+cOrigem+"'?")
		Reclock("SB1",.F.)
		SB1->B1_ORIGEM := cOrigem
		MsUnlock()
	EndIf
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณMicrosiga           บ Data ณ  03/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Definicao do layout do Relatorio                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2

oReport := TReport():New("STENGR01","Relatorio de Estrutura para Calculo de Origem","STENGR01",{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir uma listagem de materiais com base no cadastro de estrutura conforme parametros.")
oReport:SetLandScape(.T.)

pergunte("STENGR01",.F.)

oReport:SetTitle("Relatorio de Estrutura para Calculo de Origem")
oSection1:= TRSection():New(oReport,"Itens",{"SD1"},)
oSection1:SetTotalInLine(.T.)
oSection1:SetHeaderPage()
oSection1:Setnofilter("SD1")

oSection2:= TRSection():New(oReport,"Resumo",{"SD3"},)
oSection2:SetTotalInLine(.T.)
oSection2:SetHeaderPage()
oSection2:Setnofilter("SD3")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณReportPrintณ Autor ณMicrosiga		          ณ Data ณ12.05.12 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri็ใo ณA funcao estatica ReportDef devera ser criada para todos os  ณฑฑ
ฑฑณ          ณrelatorios que poderao ser agendados pelo usuario.           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpO1: Objeto Report do Relat๓rio                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao efetuada                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                             ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportPrint(oReport)

Local cQuery4	:= ""
Local cAlias4	:= GetNextAlias()
Local cAlias	:= GetNextAlias()
Local cArqTrab
Local nTotalNac	:= 0
Local nTotalImp	:= 0
Local nValorSai	:= 0
Local cObs		:= ""
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(2)
Local aDados1[13]
Local aDados2[8]
Local aStru		:= {}
Local RecSM0	:= 0
Local oTable //\Ajustado

TRCell():New(oSection1,"TIPO"	,,"Tipo"		,"@!"				,10,/*lPixel*/,{||aDados1[1]})
TRCell():New(oSection1,"FILIAL"	,,"Filial"		,"@!"				,06,/*lPixel*/,{||aDados1[2]})
TRCell():New(oSection1,"COD"	,,"Componente"	,"@!"				,15,/*lPixel*/,{||aDados1[3]})
TRCell():New(oSection1,"DESC"	,,"Descri็ใo"	,"@!"				,30,/*lPixel*/,{||aDados1[4]})
TRCell():New(oSection1,"QTD"	,,"Quant."		,"@E 9,999,999.9999",16,/*lPixel*/,{||aDados1[5]})
TRCell():New(oSection1,"CM1"	,,"Custo"		,"@E 9,999,999.9999",16,/*lPixel*/,{||aDados1[6]})
TRCell():New(oSection1,"CTOTAL"	,,"Total"		,"@E 9,999,999.9999",16,/*lPixel*/,{||aDados1[7]})
TRCell():New(oSection1,"FORNEC"	,,"Fornec."		,"@!"				,06,/*lPixel*/,{||aDados1[8]})
TRCell():New(oSection1,"LOJA"	,,"Loja"		,"@!"				,04,/*lPixel*/,{||aDados1[9]})
TRCell():New(oSection1,"NOTA"	,,"NF"			,"@!"				,09,/*lPixel*/,{||aDados1[10]})
TRCell():New(oSection1,"SERIE"	,,"Serie"		,"@!"				,05,/*lPixel*/,{||aDados1[11]})
TRCell():New(oSection1,"DATA"	,,"Data"		,"@!"				,10,/*lPixel*/,{||aDados1[12]})
TRCell():New(oSection1,"ORIGEM"	,,"Orig."		,"@!"				,04,/*lPixel*/,{||aDados1[13]})

TRCell():New(oSection2,"COD"	,,"Codigo"		,"@!"				,15,/*lPixel*/,{||aDados2[1]})
TRCell():New(oSection2,"DESC"	,,"Descri็ใo"	,"@!"				,30,/*lPixel*/,{||aDados2[2]})
TRCell():New(oSection2,"CNAC"	,,"Custo Nac."	,"@E 9,999,999.9999",16,/*lPixel*/,{||aDados2[3]})
TRCell():New(oSection2,"CIMP"	,,"Custo Imp."	,"@E 9,999,999.9999",16,/*lPixel*/,{||aDados2[4]})
TRCell():New(oSection2,"VENDA"	,,"Valor Saida"	,"@E 9,999,999.9999",16,/*lPixel*/,{||aDados2[5]})
TRCell():New(oSection2,"OBS"	,,"Obs."		,"@!"				,30,/*lPixel*/,{||aDados2[6]})
TRCell():New(oSection2,"ORIGEM"	,,"ORIGEM"		,"@!"				,02,/*lPixel*/,{||aDados2[7]})
TRCell():New(oSection2,"PERC"	,,"Perc.Imp."	,"@E 99.99"			,10,/*lPixel*/,{||aDados2[8]})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria Arquivo de Trabalho para a escolha do Grupo de Compra ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Aadd( aStru,{ "XX_TIPO"		,"C",01,0} )
Aadd( aStru,{ "XX_FILIAL"	,"C",02,0} )
Aadd( aStru,{ "XX_COD"		,"C",15,0} )
Aadd( aStru,{ "XX_DESC"		,"C",30,0} )
Aadd( aStru,{ "XX_QTD"		,"N",16,4} )
Aadd( aStru,{ "XX_CM1"		,"N",16,4} )
Aadd( aStru,{ "XX_CTOTAL"	,"N",16,4} )
Aadd( aStru,{ "XX_FORNEC"	,"C",06,0} )
Aadd( aStru,{ "XX_LOJA"		,"C",02,0} )
Aadd( aStru,{ "XX_NOTA"		,"C",09,0} )
Aadd( aStru,{ "XX_SERIE"	,"C",03,0} )
Aadd( aStru,{ "XX_DATA"		,"D",08,0} )
Aadd( aStru,{ "XX_ORIGEM"	,"C",01,0} )

//cArqTrab := CriaTrab(aStru) //Fun็ใo CriaTrab descontinuada, adicionado o oTable no lugar
oTable := FWTemporaryTable():New(cAlias) //adicionado\Ajustado
oTable:SetFields(aStru)					 //adicionado\Ajustado
oTable:Create()							 //adicionado\Ajustado
cAlias		:= oTable:GetAlias()		 //adicionado\Ajustado
cArqTrab	:= oTable:GetRealName()		 //adicionado\Ajustado
dbUseArea(.T.,"topconn",cArqTrab,(cAlias),.F.,.F.)
IndRegua((cAlias),cArqTrab,"XX_TIPO+XX_COD",,,"Indexando Arquivo...")

DbSelectArea("SM0")
SM0->(DbSetOrder(1))
RecSM0 := SM0->(Recno())
SM0->(DbGoTop())
While SM0->(!Eof())
	If cEmpAnt = SM0->M0_CODIGO  .And. SM0->M0_CODFIL = '05'
		//Alimenta Tabela Temporaria Estrutura
		If U_STENGRB1(mv_par01,1,cAlias,SM0->M0_CODFIL)
			Exit
		//Alimenta Tabela Temporaria Pr้-Estrutura
		ElseIf U_STENGRB2(mv_par01,1,cAlias,SM0->M0_CODFIL)
			Exit
		EndIf
	EndIf
	
	SM0->(DbSkip())
End
SM0->(DbGoTo(RecSM0))

aFill(aDados1,nil)
oSection1:Init()

DbSelectArea(cAlias)
(cAlias)->(dbGoTop())
While (cAlias)->(!Eof())
	aDados1[01] := IIF((cAlias)->XX_TIPO="0","Importado","Nacional")
	aDados1[02] := (cAlias)->XX_FILIAL
	aDados1[03] := (cAlias)->XX_COD
	aDados1[04] := (cAlias)->XX_DESC
	aDados1[05] := (cAlias)->XX_QTD
	aDados1[06] := (cAlias)->XX_CM1
	aDados1[07] := (cAlias)->XX_CTOTAL
	aDados1[08] := (cAlias)->XX_FORNEC
	aDados1[09] := (cAlias)->XX_LOJA
	aDados1[10] := (cAlias)->XX_NOTA
	aDados1[11] := (cAlias)->XX_SERIE
	aDados1[12] := (cAlias)->XX_DATA
	aDados1[13] := (cAlias)->XX_ORIGEM
	If (cAlias)->XX_TIPO<>"0"
		nTotalNac += (cAlias)->XX_CTOTAL
	Else
		nTotalImp += (cAlias)->XX_CTOTAL
	EndIf
	oSection1:PrintLine()
	aFill(aDados1,nil)
	(cAlias)->(dbSkip())
EndDo

oReport:SkipLine()
oSection1:Finish()

cQuery4 := " SELECT B1_COD, "
cQuery4 += " (SELECT D2_PRCVEN "
cQuery4 += " FROM "+RetSqlName("SD2")+" SD2 "
cQuery4 += " INNER JOIN (SELECT D2_COD DX_COD,MAX(R_E_C_N_O_)DX_REC "
cQuery4 += "  		FROM "+RetSqlName("SD2")+" SD2 "
cQuery4 += "  		WHERE SD2.D2_FILIAL <> ' ' AND SD2.D2_PRCVEN > 0 AND SD2.D_E_L_E_T_ = ' '  "
cQuery4 += "  		GROUP BY D2_COD)SDX ON SDX.DX_COD=SD2.D2_COD AND SDX.DX_REC=SD2.R_E_C_N_O_  "
cQuery4 += " WHERE SD2.D2_FILIAL <> ' ' AND SD2.D2_COD = SB1.B1_COD  "
cQuery4 += " ) AS D2_PRCVEN, "
cQuery4 += " (SELECT C6_PRCVEN "
cQuery4 += " FROM "+RetSqlName("SC6")+" SC6 "
cQuery4 += " INNER JOIN (SELECT C6_PRODUTO CX_COD,MAX(R_E_C_N_O_)CX_REC "
cQuery4 += "  		FROM "+RetSqlName("SC6")+" SC6 "
cQuery4 += "  		WHERE SC6.C6_FILIAL <> ' ' AND SC6.C6_PRCVEN > 0 AND SC6.D_E_L_E_T_ = ' '  "
cQuery4 += "  		GROUP BY C6_PRODUTO)SCX ON SCX.CX_COD=SC6.C6_PRODUTO AND SCX.CX_REC=SC6.R_E_C_N_O_  "
cQuery4 += " WHERE SC6.C6_FILIAL <> ' ' AND SC6.C6_PRODUTO = SB1.B1_COD  "
cQuery4 += " ) AS C6_PRCVEN, "
cQuery4 += " (SELECT UB_VRUNIT "
cQuery4 += " FROM "+RetSqlName("SUB")+" SUB "
cQuery4 += " INNER JOIN (SELECT UB_PRODUTO CX_COD,MAX(R_E_C_N_O_)CX_REC "
cQuery4 += "  		FROM "+RetSqlName("SUB")+" SUB "
cQuery4 += "  		WHERE SUB.UB_FILIAL <> ' ' AND SUB.UB_VRUNIT > 0 AND SUB.D_E_L_E_T_ = ' '  "
cQuery4 += "  		GROUP BY UB_PRODUTO)SCX ON SCX.CX_COD=SUB.UB_PRODUTO AND SCX.CX_REC=SUB.R_E_C_N_O_  "
cQuery4 += " WHERE SUB.UB_FILIAL <> ' ' AND SUB.UB_PRODUTO = SB1.B1_COD  "
cQuery4 += " ) AS UB_VRUNIT "
cQuery4 += " FROM "+RetSqlName("SB1")+" SB1 "
cQuery4 += " WHERE B1_COD = '"+mv_par01+"' AND SB1.D_E_L_E_T_ = ' ' "

If !Empty(Select(cAlias4))
	DbSelectArea(cAlias4)
	(cAlias4)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery4),cAlias4,.F.,.T.)

TCSetField(cAlias4,"D2_PRCVEN"	,"N",14,2 )
TCSetField(cAlias4,"C6_PRCVEN"	,"N",14,2 )
TCSetField(cAlias4,"UB_VRUNIT"	,"N",14,2 )

dbSelectArea(cAlias4)
(cAlias4)->(DbGoTop())
While (cAlias4)->(!Eof())
	If (cAlias4)->D2_PRCVEN>0
		cObs := "Valor da Ultima Saida"
		nValorSai := (cAlias4)->D2_PRCVEN
	ElseIf (cAlias4)->C6_PRCVEN>0
		cObs := "Valor do Ultimo Pedido"
		nValorSai := (cAlias4)->C6_PRCVEN
	ElseIf (cAlias4)->UB_VRUNIT>0
		cObs := "Valor do Ultimo Or็amento"
		nValorSai := (cAlias4)->UB_VRUNIT
	Else
		cObs := "Valor de Custo + Margem"
		nValorSai := (nTotalNac+nTotalImp)/(1-(mv_par02/100))
	EndIf 
	If nValorSai>0
		Exit
	Else
		cObs := "Nใo foi possivel obter o Valor"
	EndIf
	(cAlias3)->(DbSkip())
End

If !Empty(Select(cAlias4))
	DbSelectArea(cAlias4)
	(cAlias4)->(dbCloseArea())
EndIf

cOrigem := IIF(nTotalImp=0,"0",IIF(nTotalImp/nValorSai<0.4,"5",IIF(nTotalImp/nValorSai<0.7,"3","8")))

aFill(aDados2,nil)
oSection2:Init()

DbSelectArea("SB1")
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+mv_par01))
aDados2[01] := SB1->B1_COD
aDados2[02] := SB1->B1_DESC
aDados2[03] := nTotalNac
aDados2[04] := nTotalImp
aDados2[05] := nValorSai
aDados2[06] := cObs 
aDados2[07] := cOrigem
aDados2[08] := Round(nTotalImp/nValorSai*100,2)

oSection2:PrintLine()

oReport:SkipLine()
oSection2:Finish()

DbSelectArea(cAlias)
(cAlias)->( DbCloseArea() )
FErase(cArqTrab+GetDBExtension())
FErase(cArqTrab+OrdBagExt())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO3     บAutor  ณMicrosiga           บ Data ณ  08/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STENGRB1(cCodigo,nQtdMult,cAlias,cFil)

Local cQuery2	:= ""
Local cAlias2	:= GetNextAlias()
Local nQuant	:= 0
Local nCusto	:= 0
Local aComp		:= {}
Local lRet		:= .F.

cQuery2	+= "WITH ESTRUT(CODIGO,COD_PAI,COD_COMP,QTD,NIVEL) AS ( "
cQuery2	+= "SELECT G1_COD PAI,G1_COD,G1_COMP,G1_QUANT,1 AS NIVEL FROM "+RetSqlName("SG1")+" SG1 WHERE SG1.G1_FILIAL = '"+cFil+"' AND SG1.D_E_L_E_T_ = ' ' and G1_COD = '"+cCodigo+"' " 
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT CODIGO,G1_COD,G1_COMP,QTD*G1_QUANT,NIVEL + 1 FROM "+RetSqlName("SG1")+" SG1 INNER JOIN ESTRUT EST ON G1_COD = COD_COMP WHERE SG1.G1_FILIAL = '"+cFil+"' AND SG1.D_E_L_E_T_ = ' ') "
cQuery2	+= "SELECT CODIGO,COD_COMP,B1_DESC,B1_ORIGEM,B1_UM,ROUND(SUM(QTD),6)QTD, "
cQuery2	+= "NVL((SELECT MAX(R_E_C_N_O_)DX_REC FROM "+RetSqlName("SD1")+" SD1 INNER JOIN (SELECT D1_COD DX_COD,MAX(D1_DTDIGIT)DX_DAT FROM "+RetSqlName("SD1")+" SD1 " 
cQuery2	+= "WHERE SD1.D1_FILIAL <> ' ' AND SUBSTR(D1_CF,1,1)='3' AND D1_QUANT>0 AND D1_TIPO='N' AND SD1.D_E_L_E_T_ = ' ' " 
cQuery2	+= "GROUP BY SD1.D1_COD)SDX ON SDX.DX_COD=SD1.D1_COD AND SDX.DX_DAT=SD1.D1_DTDIGIT " 
cQuery2	+= "WHERE SD1.D1_FILIAL <> ' ' AND SD1.D1_COD=COD_COMP AND SUBSTR(SD1.D1_CF,1,1)='3' AND D1_QUANT>0 AND D1_TIPO='N' AND SD1.D_E_L_E_T_ = ' ' " 
cQuery2	+= "GROUP BY SD1.D1_COD),0)RECIMP, "
cQuery2	+= "NVL((SELECT MAX(R_E_C_N_O_)DX_REC FROM "+RetSqlName("SD1")+" SD1 INNER JOIN (SELECT D1_COD DX_COD,MAX(D1_DTDIGIT)DX_DAT FROM "+RetSqlName("SD1")+" SD1 "
cQuery2	+= "WHERE SD1.D1_FILIAL <> ' ' AND SUBSTR(D1_CF,1,1)<>'3' AND D1_QUANT>0 AND D1_TIPO='N' AND SD1.D_E_L_E_T_ = ' ' "
cQuery2	+= "GROUP BY SD1.D1_COD)SDX ON SDX.DX_COD=SD1.D1_COD AND SDX.DX_DAT=SD1.D1_DTDIGIT "
cQuery2	+= "WHERE SD1.D1_FILIAL <> ' ' AND SD1.D1_COD=COD_COMP AND SUBSTR(SD1.D1_CF,1,1)<>'3' AND D1_QUANT>0 AND D1_TIPO='N' AND SD1.D_E_L_E_T_ = ' ' "
cQuery2	+= "GROUP BY SD1.D1_COD),0)RECNAC "
cQuery2	+= "FROM ESTRUT "
cQuery2	+= "INNER JOIN "+RetSqlName("SB1")+" SB1_A ON SB1_A.D_E_L_E_T_ = ' ' AND SB1_A.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1_A.B1_COD = COD_COMP "
cQuery2	+= "LEFT  JOIN (SELECT G1_COD COD FROM "+RetSqlName("SG1")+" SG1_A WHERE SG1_A.D_E_L_E_T_ = ' ' AND SG1_A.G1_FILIAL = '"+cFil+"' GROUP BY G1_COD) SG1_A ON COD = COD_COMP "
cQuery2	+= "WHERE " 
cQuery2	+= "ESTRUT.CODIGO = '"+cCodigo+"' AND COD IS NULL "
cQuery2	+= "GROUP BY CODIGO,COD_COMP,B1_DESC,B1_ORIGEM,B1_UM "
cQuery2	+= "ORDER BY COD_COMP "

Conout("[STENGRB1] - Processando c๓digo: "+cCodigo)

If !Empty(Select(cAlias2))
	DbSelectArea(cAlias2)
	(cAlias2)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery2),cAlias2,.F.,.T.)
TCSetField(cAlias2,"lRet","N",14,6 )

dbSelectArea(cAlias2)
(cAlias2)->(DbGoTop())
While (cAlias2)->(!Eof())
	lRet := .T.
	If (cAlias2)->QTD>0
		nQuant := ((cAlias2)->QTD*nQtdMult)
	Else
		nQuant := (0.0001)
	EndIf
	aComp := U_STENGRC1((cAlias2)->COD_COMP,(cAlias2)->RECIMP,(cAlias2)->RECNAC)
	If Len(aComp)>0
		RecLock((cAlias),.T.)
		(cAlias)->XX_TIPO	:= aComp[1]
		(cAlias)->XX_FILIAL	:= aComp[2]
		(cAlias)->XX_COD	:= aComp[3]
		(cAlias)->XX_DESC	:= (cAlias2)->B1_DESC
		(cAlias)->XX_QTD	:= nQuant
		(cAlias)->XX_CM1	:= aComp[4]
		(cAlias)->XX_CTOTAL	:= nQuant*aComp[4]
		(cAlias)->XX_FORNEC	:= aComp[5]
		(cAlias)->XX_LOJA	:= aComp[6]
		(cAlias)->XX_NOTA	:= aComp[7]
		(cAlias)->XX_SERIE	:= aComp[8]
		(cAlias)->XX_DATA	:= aComp[9]
		(cAlias)->XX_ORIGEM	:= (cAlias2)->B1_ORIGEM
		MsUnlock()		
	Else			
		nCusto := 0
		DbSelectArea("SB2")
		SB2->(DbSetOrder(1))
		SB2->(DbSeek(xFilial("SB2")+(cAlias2)->COD_COMP))
		While SB2->(!Eof()) .And. SB2->(B2_FILIAL+B2_COD)=xFilial("SB2")+(cAlias2)->COD_COMP
			If SB2->B2_CMFIM1 > 0
				nCusto := SB2->B2_CMFIM1
				Exit
			EndIf
			SB2->(DbSkip())
		End
		RecLock((cAlias),.T.)
		(cAlias)->XX_TIPO	:= "1"
		(cAlias)->XX_FILIAL	:= "  "
		(cAlias)->XX_COD	:= (cAlias2)->COD_COMP
		(cAlias)->XX_DESC	:= (cAlias2)->B1_DESC
		(cAlias)->XX_QTD	:= nQuant
		(cAlias)->XX_CM1	:= nCusto
		(cAlias)->XX_CTOTAL	:= nQuant*nCusto
		(cAlias)->XX_FORNEC	:= ""
		(cAlias)->XX_LOJA	:= ""
		(cAlias)->XX_NOTA	:= ""
		(cAlias)->XX_SERIE	:= ""
		(cAlias)->XX_DATA	:= CTOD("  /  /    ")
		(cAlias)->XX_ORIGEM	:= (cAlias2)->B1_ORIGEM
		MsUnlock()		
	EndIf
	(cAlias2)->(DbSkip())
End

If !Empty(Select(cAlias2))
	DbSelectArea(cAlias2)
	(cAlias2)->(dbCloseArea())
EndIf

Return(lRet)

User Function STENGRB2(cCodigo,nQtdMult,cAlias,cFil)

Local cQuery2	:= ""
Local cAlias2	:= GetNextAlias()
Local nQuant	:= 0
Local nCusto	:= 0
Local aComp		:= {}
Local lRet		:= .F.

cQuery2	+= "WITH ESTRUT(CODIGO,COD_PAI,COD_COMP,QTD,NIVEL) AS ( "
cQuery2	+= "SELECT GG_COD PAI,GG_COD,GG_COMP,GG_QUANT,1 AS NIVEL FROM "+RetSqlName("SGG")+" SGG WHERE SGG.GG_FILIAL = '"+cFil+"' AND SGG.D_E_L_E_T_ = ' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT CODIGO,GG_COD,GG_COMP,QTD*GG_QUANT,NIVEL + 1 FROM "+RetSqlName("SGG")+" SGG INNER JOIN ESTRUT EST ON GG_COD = COD_COMP WHERE SGG.GG_FILIAL = '"+cFil+"' AND SGG.D_E_L_E_T_ = ' ') "
cQuery2	+= "SELECT CODIGO,COD_COMP,B1_DESC,B1_ORIGEM,B1_UM,ROUND(SUM(QTD),6)QTD, "
cQuery2	+= "NVL((SELECT MAX(R_E_C_N_O_)DX_REC FROM "+RetSqlName("SD1")+" SD1 INNER JOIN (SELECT D1_COD DX_COD,MAX(D1_DTDIGIT)DX_DAT FROM "+RetSqlName("SD1")+" SD1 " 
cQuery2	+= "WHERE SD1.D1_FILIAL <> ' ' AND SUBSTR(D1_CF,1,1)='3' AND D1_QUANT>0 AND D1_TIPO='N' AND SD1.D_E_L_E_T_ = ' ' " 
cQuery2	+= "GROUP BY SD1.D1_COD)SDX ON SDX.DX_COD=SD1.D1_COD AND SDX.DX_DAT=SD1.D1_DTDIGIT " 
cQuery2	+= "WHERE SD1.D1_FILIAL <> ' ' AND SD1.D1_COD=COD_COMP AND SUBSTR(SD1.D1_CF,1,1)='3' AND D1_QUANT>0 AND D1_TIPO='N' AND SD1.D_E_L_E_T_ = ' ' " 
cQuery2	+= "GROUP BY SD1.D1_COD),0)RECIMP, "
cQuery2	+= "NVL((SELECT MAX(R_E_C_N_O_)DX_REC FROM "+RetSqlName("SD1")+" SD1 INNER JOIN (SELECT D1_COD DX_COD,MAX(D1_DTDIGIT)DX_DAT FROM "+RetSqlName("SD1")+" SD1 "
cQuery2	+= "WHERE SD1.D1_FILIAL <> ' ' AND SUBSTR(D1_CF,1,1)<>'3' AND D1_QUANT>0 AND D1_TIPO='N' AND SD1.D_E_L_E_T_ = ' ' "
cQuery2	+= "GROUP BY SD1.D1_COD)SDX ON SDX.DX_COD=SD1.D1_COD AND SDX.DX_DAT=SD1.D1_DTDIGIT "
cQuery2	+= "WHERE SD1.D1_FILIAL <> ' ' AND SD1.D1_COD=COD_COMP AND SUBSTR(SD1.D1_CF,1,1)<>'3' AND D1_QUANT>0 AND D1_TIPO='N' AND SD1.D_E_L_E_T_ = ' ' "
cQuery2	+= "GROUP BY SD1.D1_COD),0)RECNAC "
cQuery2	+= "FROM ESTRUT "
cQuery2	+= "INNER JOIN "+RetSqlName("SB1")+" SB1_A ON SB1_A.D_E_L_E_T_ = ' ' AND SB1_A.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1_A.B1_COD = COD_COMP "
cQuery2	+= "LEFT  JOIN (SELECT GG_COD COD FROM "+RetSqlName("SGG")+" SGG_A WHERE SGG_A.D_E_L_E_T_ = ' ' AND SGG_A.GG_FILIAL = '"+cFil+"' GROUP BY GG_COD) SGG_A ON COD = COD_COMP "
cQuery2	+= "WHERE " 
cQuery2	+= "ESTRUT.CODIGO = '"+cCodigo+"' AND COD IS NULL "
cQuery2	+= "GROUP BY CODIGO,COD_COMP,B1_DESC,B1_ORIGEM,B1_UM "
cQuery2	+= "ORDER BY COD_COMP "

Conout("[STENGRB2] - Processando c๓digo: "+cCodigo)

If !Empty(Select(cAlias2))
	DbSelectArea(cAlias2)
	(cAlias2)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery2),cAlias2,.F.,.T.)
TCSetField(cAlias2,"lRet","N",14,6 )
TCSetField(cAlias2,"lRet","N",18,0 )

dbSelectArea(cAlias2)
(cAlias2)->(DbGoTop())
While (cAlias2)->(!Eof())
	lRet := .T.
	If (cAlias2)->QTD>0
		nQuant := ((cAlias2)->QTD*nQtdMult)
	Else
		nQuant := (0.0001)
	EndIf
	aComp := U_STENGRC1((cAlias2)->COD_COMP,(cAlias2)->RECIMP,(cAlias2)->RECNAC)
	If Len(aComp)>0
		RecLock((cAlias),.T.)
		(cAlias)->XX_TIPO	:= aComp[1]
		(cAlias)->XX_FILIAL	:= aComp[2]
		(cAlias)->XX_COD	:= aComp[3]
		(cAlias)->XX_DESC	:= (cAlias2)->B1_DESC
		(cAlias)->XX_QTD	:= nQuant
		(cAlias)->XX_CM1	:= aComp[4]
		(cAlias)->XX_CTOTAL	:= nQuant*aComp[4]
		(cAlias)->XX_FORNEC	:= aComp[5]
		(cAlias)->XX_LOJA	:= aComp[6]
		(cAlias)->XX_NOTA	:= aComp[7]
		(cAlias)->XX_SERIE	:= aComp[8]
		(cAlias)->XX_DATA	:= aComp[9]
		(cAlias)->XX_ORIGEM	:= (cAlias2)->B1_ORIGEM
		MsUnlock()		
	Else			
		nCusto := 0
		DbSelectArea("SB2")
		SB2->(DbSetOrder(1))
		SB2->(DbSeek(xFilial("SB2")+(cAlias2)->COD_COMP))
		While SB2->(!Eof()) .And. SB2->(B2_FILIAL+B2_COD)=xFilial("SB2")+(cAlias2)->COD_COMP
			If SB2->B2_CMFIM1 > 0
				nCusto := SB2->B2_CMFIM1
				Exit
			EndIf
			SB2->(DbSkip())
		End
		RecLock((cAlias),.T.)
		(cAlias)->XX_TIPO	:= "1"
		(cAlias)->XX_FILIAL	:= "  "
		(cAlias)->XX_COD	:= (cAlias2)->COD_COMP
		(cAlias)->XX_DESC	:= (cAlias2)->B1_DESC
		(cAlias)->XX_QTD	:= nQuant
		(cAlias)->XX_CM1	:= nCusto
		(cAlias)->XX_CTOTAL	:= nQuant*nCusto
		(cAlias)->XX_FORNEC	:= ""
		(cAlias)->XX_LOJA	:= ""
		(cAlias)->XX_NOTA	:= ""
		(cAlias)->XX_SERIE	:= ""
		(cAlias)->XX_DATA	:= CTOD("  /  /    ")
		(cAlias)->XX_ORIGEM	:= (cAlias2)->B1_ORIGEM
		MsUnlock()		
	EndIf
	(cAlias2)->(DbSkip())
End

If !Empty(Select(cAlias2))
	DbSelectArea(cAlias2)
	(cAlias2)->(dbCloseArea())
EndIf

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO3     บAutor  ณMicrosiga           บ Data ณ  08/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STENGRC1(cCod,nRecImp,nRecNac)

Local aRet		:= {}
Local aArea		:= GetArea()

/*
Local cQuery3	:= ""
Local cAlias3	:= GetNextAlias()

cQuery3	:= " SELECT * FROM ( "
cQuery3	+= " SELECT '0'TIPO,D1_FILIAL,D1_COD,CASE WHEN D1_QUANT>0 THEN D1_CUSTO/D1_QUANT ELSE 0 END D1_CUSTO,D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_DTDIGIT "
cQuery3	+= " FROM "+RetSqlName("SD1")+" SD1 "
cQuery3	+= " INNER JOIN (SELECT D1_COD DX_COD,MAX(R_E_C_N_O_)DX_REC "
cQuery3	+= " 		FROM "+RetSqlName("SD1")+" SD1 "
cQuery3	+= " 		INNER JOIN (SELECT D1_COD DX_COD,MAX(D1_DTDIGIT)DX_DAT "
cQuery3	+= " 				FROM "+RetSqlName("SD1")+" SD1 "
cQuery3	+= " 				WHERE SD1.D1_FILIAL <> ' ' AND SUBSTR(D1_CF,1,1)='3' AND D1_QUANT>0 AND D1_TIPO='N' AND SD1.D_E_L_E_T_ = ' ' "
cQuery3	+= " 				GROUP BY SD1.D1_COD)SDX ON SDX.DX_COD=SD1.D1_COD AND SDX.DX_DAT=SD1.D1_DTDIGIT "
cQuery3	+= " 		WHERE SD1.D1_FILIAL <> ' ' AND SUBSTR(SD1.D1_CF,1,1)='3' AND D1_QUANT>0 AND D1_TIPO='N' AND SD1.D_E_L_E_T_ = ' ' "
cQuery3	+= " 		GROUP BY SD1.D1_COD)SDX ON SDX.DX_COD=SD1.D1_COD AND SDX.DX_REC=SD1.R_E_C_N_O_ "
cQuery3	+= " WHERE SD1.D1_FILIAL <> ' ' AND SD1.D1_COD='"+cCod+"' "
cQuery3	+= " UNION ALL "
cQuery3	+= " SELECT '1'TIPO,D1_FILIAL,D1_COD,CASE WHEN D1_QUANT>0 THEN D1_CUSTO/D1_QUANT ELSE 0 END D1_CUSTO,D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_DTDIGIT "
cQuery3	+= " FROM "+RetSqlName("SD1")+" SD1 "
cQuery3	+= " INNER JOIN (SELECT D1_COD DX_COD,MAX(R_E_C_N_O_)DX_REC "
cQuery3	+= " 		FROM "+RetSqlName("SD1")+" SD1 "
cQuery3	+= " 		INNER JOIN (SELECT D1_COD DX_COD,MAX(D1_DTDIGIT)DX_DAT "
cQuery3	+= " 				FROM "+RetSqlName("SD1")+" SD1 "
cQuery3	+= " 				WHERE SD1.D1_FILIAL <> ' ' AND SUBSTR(D1_CF,1,1)<>'3' AND D1_QUANT>0 AND D1_TIPO='N' AND SD1.D_E_L_E_T_ = ' ' "
cQuery3	+= " 				GROUP BY SD1.D1_COD)SDX ON SDX.DX_COD=SD1.D1_COD AND SDX.DX_DAT=SD1.D1_DTDIGIT "
cQuery3	+= " 		WHERE SD1.D1_FILIAL <> ' ' AND SUBSTR(SD1.D1_CF,1,1)<>'3' AND D1_QUANT>0 AND D1_TIPO='N' AND SD1.D_E_L_E_T_ = ' ' "
cQuery3	+= " 		GROUP BY SD1.D1_COD)SDX ON SDX.DX_COD=SD1.D1_COD AND SDX.DX_REC=SD1.R_E_C_N_O_ "
cQuery3	+= " WHERE SD1.D1_FILIAL <> ' ' AND SD1.D1_COD='"+cCod+"' "
cQuery3	+= " )XXX "
cQuery3	+= " ORDER BY 1 "

If !Empty(Select(cAlias3))
	DbSelectArea(cAlias3)
	(cAlias3)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery3),cAlias3,.F.,.T.)

TCSetField(cAlias3,"D1_CUSTO"	,"N",14,4 )
TCSetField(cAlias3,"D1_DTDIGIT"	,"D",08,0 )

dbSelectArea(cAlias3)
(cAlias3)->(DbGoTop())
While (cAlias3)->(!Eof())
	If Empty(aRet) .Or. (cAlias3)->TIPO="0"
		aRet := { (cAlias3)->TIPO,(cAlias3)->D1_FILIAL,(cAlias3)->D1_COD,(cAlias3)->D1_CUSTO,(cAlias3)->D1_FORNECE,(cAlias3)->D1_LOJA,(cAlias3)->D1_DOC,(cAlias3)->D1_SERIE,(cAlias3)->D1_DTDIGIT }
	EndIf
	(cAlias3)->(DbSkip())
End

If !Empty(Select(cAlias3))
	DbSelectArea(cAlias3)
	(cAlias3)->(dbCloseArea())
EndIf
*/

If nRecImp > 0
	DbSelectArea("SD1")
	SD1->(DbGoto(nRecImp))
	aRet := { '0',SD1->D1_FILIAL,SD1->D1_COD,SD1->(D1_CUSTO/D1_QUANT),SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_DTDIGIT }
ElseIf nRecNac > 0
	DbSelectArea("SD1")
	SD1->(DbGoto(nRecNac))
	aRet := { '1',SD1->D1_FILIAL,SD1->D1_COD,SD1->(D1_CUSTO/D1_QUANT),SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_DTDIGIT }
EndIf

RestArea(aArea)

Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusta    บAutor  ณMicrosiga           บ Data ณ  03/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Insere novas perguntas na tabela SX1 a Ajusta o Picture    บฑฑ
ฑฑบ          ณ dos valores no SX3                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Produto ?                    ","Produto ?                    ","Produto ?                    ","mv_ch1","C",15,0,0,"G",""                   ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","SB1","S","",""})
Aadd(aPergs,{"Margem ?                     ","Margem ?                     ","Margem ?                     ","mv_ch2","N",02,0,0,"G",""                   ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","",""   ,"S","",""})
Aadd(aPergs,{"Atualiza Cadastro?           ","Atualiza Cadastro?           ","Atualiza Cadastro?           ","mv_ch3","N",01,0,1,"C",""                   ,"mv_par03","Sim           ","Sim           ","Sim           ","","","Nใo           ","Nใo           ","Nใo           ","","","","","","","","","","","","","","","","",""   ,"S","",""})

//AjustaSx1("STENGR01",aPergs)

Return
