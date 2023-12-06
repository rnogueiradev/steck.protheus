#Include "Protheus.ch"
#Include "TopConn.ch"
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ARFIS003  º Autor ³ Cristiano Pereiraº Data ³  30/03/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Listado das retenciones Steck Argentina                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ARFIS003()

Local oReport
Local aArea	:= GetArea()



If Pergunte("ARFIS03",.T.)
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

oReport := TReport():New("ARFIS03","Listado das Retenciones entradas","ARFIS03",{|oReport| ReportPrint(oReport)},"Listado Retenciones.")

oReport:SetLandscape()
pergunte("ARFIS03",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						  ³
//³ mv_par01			// Mes							 		  ³
//³ mv_par02			// Ano									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 


oSection1 := TRSection():New(oReport,"Retenciones",{"SD1"},)  


TRCell():New(oSection1,"IMPUESTO"	    ,,"IMPUESTO"	    ,"@!",003,.F.,)                
TRCell():New(oSection1,"EMISION"	    ,,"EMISION"	,"@!",010,.F.,) 
TRCell():New(oSection1,"FECHA_EMISION"	,,"FECHA EMISION","@!",010,.F.,) 
TRCell():New(oSection1,"NUM_FAT"		,,"NUM. FACTURA" ,"@!",010,.F.,)   
TRCell():New(oSection1,"DENOMINACION"   ,,"DENOMINACION" ,"@!",040,.F.,)
TRCell():New(oSection1,"CUIT"		    ,,"CUIT"	,"@!",025,.F.,) 
TRCell():New(oSection1,"PROVINCIA"		    ,,"PROVINCIA"	,"@!",05,.F.,)
TRCell():New(oSection1,"BASE_IMPONIBLE"		,,"BASE IMPONIBLE"	,"@!",20,.F.,) 
TRCell():New(oSection1,"LIBRO"		,,"LIBRO"	,"@!",20,.F.,)  
TRCell():New(oSection1,"RETENCION"		,,"RETENCION"	,"@!",20,.F.,)  

oBreak1 := TRBreak():New(oSection1,".T.","Total general",.F.) 
oFunction := TRFunction():New(oSection1:Cell('BASE_IMPONIBLE'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.) 
oFunction := TRFunction():New(oSection1:Cell('RETENCION'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.) 



oSection1:SetHeaderSection(.T.)
oSection1:Setnofilter("SD1")


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

Local cTitulo		:= OemToAnsi("Retenciones Steck entrada")
Local cAlias1		:= "QRY1SD1"
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
oSection1:Cell("LIBRO" )	:SetBlock( { || aDados1[9] }) 
oSection1:Cell("RETENCION" )	:SetBlock( { || aDados1[10] }) 



cQuery1 := "       SELECT            "
cQuery1 += "       SFB.FB_CODIGO AS codigo_impuesto,   "
cQuery1 += "        SUBSTR(SD1.D1_EMISSAO,7,2)||'/'|| SUBSTR(SD1.D1_EMISSAO,5,2)||'/'|| SUBSTR(SD1.D1_EMISSAO,1,4) AS emision,   "
cQuery1 += "        SUBSTR(SD1.D1_DTDIGIT,7,2)||'/'|| SUBSTR(SD1.D1_DTDIGIT,5,2)||'/'|| SUBSTR(SD1.D1_DTDIGIT,1,4) AS Fecha_de_publicacion,   "
cQuery1 += "        SD1.D1_DOC AS factura,     "
cQuery1 += "        SA2.A2_NOME AS denominacion,         "
cQuery1 += "        SA2.A2_CGC  AS numero_de_CUIT,       "
cQuery1 += "        SA2.A2_EST  AS provincia,            "
cQuery1 += "        SD1.D1_TOTAL AS base_imponible,      "
cQuery1 += "        SFB.FB_CPOLVRO AS libro,             "
cQuery1 += "        CASE SFB.FB_CODIGO WHEN 'IBR'  THEN SD1.D1_VALIMP8+SD1.D1_VALIMPR ELSE SD1.D1_VALIMP9 END retencion       "
       
       
                                                                                                                               "
cQuery1 += "  FROM "+RetSqlName("SD1")+" SD1,"+RetSqlName("SFC")+" SFC ,"+RetSqlName("SFB")+" SFB ,"+RetSqlName("SA2")+" SA2 ,"+RetSqlName("SE2")+" SE2 "
cQuery1 += "  WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"'           AND      "
cQuery1 += "      SD1.D_E_L_E_T_ <> '*'                            AND      "
cQuery1 += "      SD1.D1_DTDIGIT >='"+Dtos(MV_PAR01)+"'                       AND      "
cQuery1 += "      SD1.D1_DTDIGIT <='"+Dtos(MV_PAR02)+"'                       AND      "
cQuery1 += "      SD1.D1_TES     = SFC.FC_TES                      AND      "
cQuery1 += "      SFC.D_E_L_E_T_ <> '*'                            AND      "
cQuery1 += "      SFC.FC_INCNOTA = '2'                             AND      "
cQuery1 += "      SFB.FB_CODIGO = SFC.FC_IMPOSTO                   AND      "
cQuery1 += "      SFC.D_E_L_E_T_ <> '*'                            AND      "
cQuery1 += "      SD1.D1_FORNECE= SA2.A2_COD                       AND      "
cQuery1 += "      SD1.D1_LOJA   = SA2.A2_LOJA                      AND      "
cQuery1 += "      SA2.D_E_L_E_T_ <> '*'                            AND      "
cQuery1 += "      SD1.D1_FILIAL = SE2.E2_FILIAL                    AND      "
cQuery1 += "      SD1.D1_FORNECE = SE2.E2_FORNECE                  AND      "
cQuery1 += "      SD1.D1_LOJA    = SE2.E2_LOJA                     AND      "
cQuery1 += "      SD1.D1_DOC     = SE2.E2_NUM                      AND      "
cQuery1 += "      SE2.D_E_L_E_T_ <> '*'                            AND      "
cQuery1 += "      SE2.E2_BAIXA >='"+Dtos(MV_PAR03)+"'              AND      "
cQuery1 += "      SE2.E2_BAIXA <='"+Dtos(MV_PAR04)+"'                       " 
      
cQuery1 += " UNION ALL    "


cQuery1 += "  SELECT         "
cQuery1 += "       ''  AS codigo_impuesto,   "
cQuery1 += "       SUBSTR(SE2.E2_EMISSAO,7,2)||'/'|| SUBSTR(SE2.E2_EMISSAO,5,2)||'/'|| SUBSTR(SE2.E2_EMISSAO,1,4) AS emisión,             "
cQuery1 += "       SUBSTR(SE2.E2_VENCTO,7,2)||'/'|| SUBSTR(SE2.E2_VENCTO,5,2)||'/'|| SUBSTR(SE2.E2_VENCTO,1,4) AS Fecha_de_publicación,   "
cQuery1 += "       SE2.E2_NUM AS factura,    "
cQuery1 += "       SA2.A2_NOME AS denominación,        "
cQuery1 += "       SA2.A2_CGC  AS numero_de_CUIT,      "
cQuery1 += "       SA2.A2_EST  AS província,           "
cQuery1 += "       SE2.E2_VALOR AS base_imponible,     "
cQuery1 += "       '' AS libro,                        "
cQuery1 += "       0 retención                         "
       
       
       
cQuery1 += " FROM "+RetSqlName("SA2")+" SA2,"+RetSqlName("SE2")+" SE2   "
cQuery1 += "  WHERE    "
cQuery1 += "       SE2.E2_FILIAL = '"+RetSqlName("SE2")+"'           AND    "
cQuery1 += "       SE2.E2_PREFIXO  = 'SOL'                           AND    "
cQuery1 += "       SE2.E2_FORNECE = SA2.A2_COD                       AND    "
cQuery1 += "       SE2.E2_LOJA    = SA2.A2_LOJA                      AND    "
cQuery1 += "       SA2.D_E_L_E_T_ <> '*'                             AND    "
cQuery1 += "       SE2.D_E_L_E_T_ <> '*'                             AND    "
cQuery1 += "      SE2.E2_BAIXA >='"+Dtos(MV_PAR03)+"'                AND    "
cQuery1 += "      SE2.E2_BAIXA <='"+Dtos(MV_PAR04)+"'                       " 
                 
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
     
	aDados1[01]  := (cAlias1)->(codigo_impuesto) 
	aDados1[02]  := (cAlias1)->(emision) 
	aDados1[03]  := (cAlias1)->Fecha_de_publicacion
	aDados1[04]  := (cAlias1)->(factura) 
	aDados1[05]  := (cAlias1)->(denominacion) 
	aDados1[06]  := (cAlias1)->(numero_de_CUIT) 
	aDados1[07]  := (cAlias1)->(provincia) 
	aDados1[08]  := Alltrim(Transform((cAlias1)->(base_imponible),PesqPict("SE2","E2_VALOR")))
	aDados1[09]  := (cAlias1)->(libro)
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



