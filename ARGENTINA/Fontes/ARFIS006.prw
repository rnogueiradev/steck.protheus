#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ARFIS006  º Autor ³ Cristiano Pereiraº Data ³  30/03/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Listado das retenciones Steck Argentina Salida             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ARFIS006()

Local oReport
Local aArea	:= GetArea()



If Pergunte("ARFIS06",.T.)
	oReport 	:= ReportDef()
	oReport		:PrintDialog()
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

oReport := TReport():New("ARFIS06","Listado das Retenciones Salida","ARFIS06",{|oReport| ReportPrint(oReport)},"Listado Retenciones Salida.")

oReport:SetLandscape()
pergunte("ARFIS06",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						  ³
//³ mv_par01			// Mes							 		  ³
//³ mv_par02			// Ano									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


oSection1 := TRSection():New(oReport,"Retenciones",{"SFE"},)


TRCell():New(oSection1,"IMPUESTO"	    ,,"IMPUESTO"	    ,"@!",003,.F.,)
TRCell():New(oSection1,"EMISION"	    ,,"EMISION"	,"@!",010,.F.,)
TRCell():New(oSection1,"FECHA_EMISION"	,,"FECHA EMISION","@!",010,.F.,)
TRCell():New(oSection1,"NUM_FAT"		,,"NUM. FACTURA" ,"@!",010,.F.,)
TRCell():New(oSection1,"DENOMINACION"   ,,"DENOMINACION" ,"@!",040,.F.,)
TRCell():New(oSection1,"CUIT"		    ,,"CUIT"	,"@!",025,.F.,)
TRCell():New(oSection1,"PROVINCIA"		    ,,"PROVINCIA"	,"@!",05,.F.,)
TRCell():New(oSection1,"BASE_IMPONIBLE"		,,"BASE IMPONIBLE"	,"@!",20,.F.,)
TRCell():New(oSection1,"RECIBO"		,,"RECIBO"	,"@!",20,.F.,)
TRCell():New(oSection1,"RETENCION"		,,"RETENCION"	,"@!",20,.F.,)

oBreak1 := TRBreak():New(oSection1,".T.","Total general",.F.)
oFunction := TRFunction():New(oSection1:Cell('BASE_IMPONIBLE'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.)
oFunction := TRFunction():New(oSection1:Cell('RETENCION'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.)



oSection1:SetHeaderSection(.T.)
oSection1:Setnofilter("SFE")


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

Local cTitulo		:= OemToAnsi("Retenciones Steck salida")
Local cAlias1		:= "QRY1SD2"
Local cQuery1		:= ""
Local nRecSM0		:= SM0->(Recno())
Local aDados1[10]
Local oSection1  := oReport:Section(1)

oSection1:Cell("IMPUESTO"  )		:SetBlock( { || aDados1[1] })
oSection1:Cell("EMISION" )		:SetBlock( { || aDados1[2] })
oSection1:Cell("FECHA_EMISION" )		:SetBlock( { || aDados1[3] })
oSection1:Cell("NUM_FAT" )		:SetBlock( { || aDados1[4] })
oSection1:Cell("DENOMINACION" )	    	:SetBlock( { || aDados1[5] })
oSection1:Cell("CUIT" )	    	:SetBlock( { || aDados1[6] })
oSection1:Cell("PROVINCIA" )	:SetBlock( { || aDados1[7] })
oSection1:Cell("BASE_IMPONIBLE" )	:SetBlock( { || aDados1[8] })
oSection1:Cell("RECIBO" )	:SetBlock( { || aDados1[9] })
oSection1:Cell("RETENCION" )	:SetBlock( { || aDados1[10] })




cQuery1 := " SELECT SFE.FE_TIPO AS codigo_impuesto,      "
cQuery1 += "        SUBSTR(SFE.FE_EMISSAO,7,2)||'/'|| SUBSTR(SFE.FE_EMISSAO,5,2)||'/'|| SUBSTR(SFE.FE_EMISSAO,1,4) AS emision,  "
cQuery1 += "        SUBSTR(SFE.FE_EMISSAO,7,2)||'/'|| SUBSTR(SFE.FE_EMISSAO,5,2)||'/'|| SUBSTR(SFE.FE_EMISSAO,1,4) AS Fecha_de_publicacion,  "
cQuery1 += "        '         ' AS factura, "
cQuery1 += "        SA1.A1_NOME AS denominacion, "
cQuery1 += "        SA1.A1_CGC  AS numero_de_CUIT, "
cQuery1 += "        SFE.FE_EST  AS provincia,  "
cQuery1 += "        SUM(SFE.FE_VALBASE) AS base_imponible,   "
cQuery1 += "        SFE.FE_RECIBO  AS recibo,                    "
cQuery1 += "        SUM(SFE.FE_RETENC) AS retencion       "

cQuery1 += " FROM "+RetSqlName("SFE")+" SFE, "+RetSqlName("SA1")+" SA1 "

cQuery1 += " WHERE SFE.FE_FILIAL = '"+xFilial("SFE")+"'         AND      "
cQuery1 += "       SFE.D_E_L_E_T_ <>'*'         AND                      "
cQuery1 += "      SFE.FE_EMISSAO >='"+Dtos(MV_PAR01)+"'  AND             "
cQuery1 += "      SFE.FE_EMISSAO <='"+Dtos(MV_PAR02)+"'  AND             "
cQuery1 += "       SFE.FE_CLIENTE= SA1.A1_COD   AND                      "
cQuery1 += "      SFE.FE_LOJCLI   = SA1.A1_LOJA  AND                     "
cQuery1 += "      SA1.D_E_L_E_T_<> '*'                                 "

If MV_PAR03==1
	cQuery1 += "     AND  SFE.FE_TIPO ='B'  "
ElseIf MV_PAR03==2
	cQuery1 += "     AND  SFE.FE_TIPO ='G'  "
ElseIf MV_PAR03==3
	cQuery1 += "    AND   SFE.FE_TIPO ='S'  "
ElseIf MV_PAR03==4
	cQuery1 += "    AND   SFE.FE_TIPO ='I'  "   
Endif       

cQuery1 += " GROUP BY  SFE.FE_TIPO,SFE.FE_EMISSAO,SA1.A1_NOME,SA1.A1_CGC,SFE.FE_EST,SFE.FE_RECIBO  "                                  






cQuery1 := ChangeQuery(cQuery1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Alias se estiver em Uso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Area de Trabalho executando a Query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery1),cAlias1,.T.,.T.)


oReport:SetTitle(cTitulo)

nCont:= 0
dbeval({||nCont++})

oReport:SetMeter(nCont)

aFill(aDados1,nil)
oSection1:Init()

dbSelectArea(cAlias1)
(cAlias1)->(dbGoTop())

//Imprime Dcre
aFill(aDados1,nil)
oSection1:Init()


//Atualiza Array com dados de Captação
While (cAlias1)->(!Eof())
	
	If RTrim((cAlias1)->(codigo_impuesto))=="B"
		aDados1[01]  := "INGR. BRUTOS"
	ElseIf  RTrim((cAlias1)->(codigo_impuesto))=="G"
		aDados1[01]  := "GANANCIAS"
	ElseIf RTrim((cAlias1)->(codigo_impuesto))=="I"
		aDados1[01]  := "IVA"
	ElseIf RTrim((cAlias1)->(codigo_impuesto))=="S"
		aDados1[01]  := "SUSS"
	Else
		aDados1[01]  := (cAlias1)->(codigo_impuesto)
	Endif
	
	aDados1[02]  := (cAlias1)->(emision)
	aDados1[03]  := (cAlias1)->Fecha_de_publicacion
	aDados1[04]  := (cAlias1)->(factura)
	aDados1[05]  := (cAlias1)->(denominacion)
	aDados1[06]  := (cAlias1)->(numero_de_CUIT)
	aDados1[07]  := (cAlias1)->(provincia)
	aDados1[08]  := Alltrim(Transform((cAlias1)->(base_imponible),PesqPict("SE2","E2_VALOR")))
	aDados1[09]  := (cAlias1)->(recibo)
	aDados1[10]  := Alltrim(Transform((cAlias1)->(retencion),PesqPict("SE2","E2_VALOR")))
	
	oSection1:PrintLine()
	aFill(aDados1,nil)
	
	(cAlias1)->(dbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Alias se estiver em Uso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

//Imprime os dados de Metas
aFill(aDados1,nil)
oSection1:Init()

oSection1:PrintLine()
aFill(aDados1,nil)

oReport:SkipLine()
oSection1:Finish()

Return
