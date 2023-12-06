#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ARFIS008  º Autor ³ Cristiano Pereiraº Data ³  30/03/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Listado das retenciones Steck Argentina entrada Financeiro º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ARFIS008()

Local oReport
Local aArea	:= GetArea()



If Pergunte("ARFIS08",.T.)
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

oReport := TReport():New("ARFIS08","Informe de ventas y gastos","ARFIS08",{|oReport| ReportPrint(oReport)},"Informe de ventas y gastos.")

oReport:SetLandscape()
pergunte("ARFIS08",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						  ³
//³ mv_par01			// Mes							 		  ³
//³ mv_par02			// Ano									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


oSection1 := TRSection():New(oReport,"ventas_y_gastos",{"SF2"},)


If MV_PAR03==1
	
	TRCell():New(oSection1,"PROVINCIA"	    ,,"PROVINCIA"	    ,"@!",003,.F.,)
	TRCell():New(oSection1,"VALOR"	    ,,"VALOR LIQUIDO"	,"@E 9,999,999,999,999.99",016,.F.,) 
	TRCell():New(oSection1,"VALDEB"	    ,,"VALOR DEBITO"	,"@E 9,999,999,999,999.99",016,.F.,)
	TRCell():New(oSection1,"IVA"	    ,,"IVA"	,"@E 9,999,999,999,999.99",016,.F.,)       
	//TRCell():New(oSection1,"EXENTAS"	    ,,"EXENTAS"	,"@E 9,999,999,999,999.99",018,.F.,)   
	TRCell():New(oSection1,"NCC"	    ,,"NCC"	,"@E 9,999,999,999,999.99",016,.F.,)     
	
ElseIf MV_PAR03==2
	
	TRCell():New(oSection1,"PROVINCIA"	    ,,"PROVINCIA"	    ,"@!",003,.F.,)   
	TRCell():New(oSection1,"CONTA"	    ,,"CUENTA"	,"@!",018,.F.,)
	TRCell():New(oSection1,"DESCR"	    ,,"DESCRIPCIÓN"	,"@!",018,.F.,)
	TRCell():New(oSection1,"GASTOS"	    ,,"GASTOS"	,"@E 9,999,999,999,999.99",016,.F.,)
	
	
Endif

If MV_PAR03==1    

	oBreak1 := TRBreak():New(oSection1,".T.","Total general",.F.)
	oFunction := TRFunction():New(oSection1:Cell('VALOR'),NIL,"SUM",oBreak1,"Total general",PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.F.,.F.)
	oFunction := TRFunction():New(oSection1:Cell('VALDEB'),NIL,"SUM",oBreak1,"Total general",PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.F.,.F.)  
	oFunction := TRFunction():New(oSection1:Cell('IVA'),NIL,"SUM",oBreak1,"Total general",PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.F.,.F.)      
	//oFunction := TRFunction():New(oSection1:Cell('EXENTAS'),NIL,"SUM",oBreak1,"Total general",PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.F.,.F.) 
	oFunction := TRFunction():New(oSection1:Cell('NCC'),NIL,"SUM",oBreak1,"Total general",PesqPict("SF2","F2_VALBRUT"),/*uFormula*/,.F.,.F.)      
	//oFunction := TRFunction():New(oSection1:Cell('RETENCION'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.)
	
ElseIf MV_PAR03==2
	
	oBreak1 := TRBreak():New(oSection1,".T.","Total general",.F.)
	oFunction := TRFunction():New(oSection1:Cell('GASTOS'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.)
	//oFunction := TRFunction():New(oSection1:Cell('RETENCION'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.)
	
Endif



oSection1:SetHeaderSection(.T.)
oSection1:Setnofilter("SF2")


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

Local cTitulo		:= OemToAnsi("ventas_y_gastos")
Local cAlias1		:= "QRY1SF2"
Local cQuery1		:= ""
Local nRecSM0		:= SM0->(Recno())
Local aDados1[06]
Local oSection1  := oReport:Section(1)

If MV_PAR03==1
	
	oSection1:Cell("PROVINCIA"  )		:SetBlock( { || aDados1[1] })
	oSection1:Cell("VALOR" )		:SetBlock( { || aDados1[2] }) 
	oSection1:Cell("VALDEB" )		:SetBlock( { || aDados1[3] })
	oSection1:Cell("IVA" )		:SetBlock( { || aDados1[4] }) 
	//oSection1:Cell("EXENTAS" )		:SetBlock( { || aDados1[5] })
	oSection1:Cell("NCC" )		:SetBlock( { || aDados1[6] })
ElseIf MV_PAR03==2
	
	oSection1:Cell("PROVINCIA"  )		:SetBlock( { || aDados1[1] })
	oSection1:Cell("GASTOS" )		:SetBlock( { || aDados1[2] }) 
	oSection1:Cell("CONTA" )		:SetBlock( { || aDados1[3] })
	oSection1:Cell("DESCR" )		:SetBlock( { || aDados1[4] })
	
	
Endif

If  MV_PAR03==1
	
	cQuery1 := " SELECT PROV.FILIAL AS FILIAL,      "
    cQuery1 += "   PROV.PROVINCIA AS PROVINCIA,      "
    cQuery1 += "   SUM(PROV.VALOR_BRUTO) AS VALOR_BRUTO,   "
    cQuery1 += "   SUM(PROV.VALDEB) AS VADEB,               "  
    cQuery1 += "   SUM(PROV.IVA) AS IVA,               " 
    cQuery1 += "   SUM(PROV.EXENTAS) AS EXENTAS,   "
    cQuery1 += "   SUM(PROV.NCC) AS NCC   "
      

	cQuery1 += " FROM (    "
 
    cQuery1 += " SELECT SF2.F2_FILIAL AS FILIAL,    "  
    cQuery1 += "    SF2.F2_EST    AS PROVINCIA,     "
    cQuery1 += "    SUM(SF2.F2_VALMERC) AS VALOR_BRUTO,  " 
    cQuery1 += "    0 AS VALDEB,                         "
    cQuery1 += "    SUM(SF2.F2_VALIMP1) AS IVA,                         "
    cQuery1 += "        0  AS EXENTAS,           "
    cQuery1 += "   0 AS NCC
	cQuery1 += " FROM "+RetSqlName("SF2")+" SF2   "
	cQuery1 += " WHERE SF2.F2_FILIAL = '"+xFilial("SF2")+"'            AND  "
	cQuery1 += "       SF2.D_E_L_E_T_ <>'*'                            AND  "
    cQuery1 += "      SF2.F2_EMISSAO >='"+Dtos(mv_par01)+"'           AND  "
    cQuery1 += "      SF2.F2_EMISSAO <='"+Dtos(mv_par02)+"'           AND  "
    cQuery1 += "     SF2.F2_ESPECIE='NF'                             AND    "
    cQuery1 += "      SF2.F2_DUPL<> '         '                            "
	
    cQuery1 += " GROUP BY SF2.F2_FILIAL,SF2.F2_EST        "
    
    cQuery1 += " UNION ALL     "

    
    cQuery1 += "  SELECT SF3.F3_FILIAL AS FILIAL,   "   
     cQuery1 += "        SF3.F3_ESTADO    AS PROVINCIA,  " 
     cQuery1 += "        SUM(SF3.F3_EXENTAS)*(-1) AS VALOR_BRUTO,  " 
     cQuery1 += "        0 AS VALDEB ,            " 
     cQuery1 += "         SUM(SF3.F3_VALIMP1)*(-1) AS IVA,                         "
     cQuery1 += "        0 AS EXENTAS,           "
     cQuery1 += "         0 AS NCC               "
     cQuery1 += " FROM "+RetSqlName("SF3")+" SF3      "
     cQuery1 += "  WHERE SF3.F3_FILIAL = '"+xFilial("SF3")+"'  AND "
     cQuery1 += "      SF3.D_E_L_E_T_ <> '*' AND   "
     cQuery1 += "      SF3.F3_ENTRADA >='"+Dtos(mv_par01)+"' AND  "
     cQuery1 += "      SF3.F3_ENTRADA <='"+Dtos(mv_par02)+"' AND  "
     cQuery1 += "      SF3.F3_ESPECIE IN('NF')                  AND  "
     cQuery1 += "      SF3.F3_EXENTAS> 0 AND SF3.F3_FORMUL='S'  "
               
      
    cQuery1 += " GROUP BY SF3.F3_FILIAL,SF3.F3_ESTADO     "


	
    cQuery1 += " UNION ALL     "

    cQuery1 += " SELECT SF1.F1_FILIAL AS FILIAL,      "
    cQuery1 += "       SF1.F1_EST    AS PROVINCIA,   "
    cQuery1 += "       0 AS VALOR_BRUTO,   "
    cQuery1 += "       0 VALDEB,                                   " 
    cQuery1 += "       SUM(SF1.F1_VALIMP1)*(-1) AS IVA,                         "
    cQuery1 += "        0  AS EXENTAS,           " 
    cQuery1 += "     SUM(SF1.F1_VALMERC) AS NCC "
    cQuery1 += " FROM "+RetSqlName("SF1")+" SF1  "
    cQuery1 += " WHERE SF1.F1_FILIAL = '"+xFilial("SF1")+"'  AND  "
    cQuery1 += "      SF1.D_E_L_E_T_ <> '*' AND                   "
    cQuery1 += "      SF1.F1_DTDIGIT >='"+Dtos(mv_par01)+"' AND   "
    cQuery1 += "       SF1.F1_DTDIGIT <='"+Dtos(mv_par02)+"' AND  "
    cQuery1 += "       SF1.F1_ESPECIE ='NCC'                      "
      
    cQuery1 += "  GROUP BY SF1.F1_FILIAL,SF1.F1_EST        "

    cQuery1 += "  UNION ALL        "
    
    
     cQuery1 += "  SELECT SF3.F3_FILIAL AS FILIAL,   "   
     cQuery1 += "        SF3.F3_ESTADO    AS PROVINCIA,  " 
     cQuery1 += "        0 AS VALOR_BRUTO,  " 
     cQuery1 += "        0 AS VALDEB ,            " 
     cQuery1 += "         SUM(SF3.F3_VALIMP1)*(-1) AS IVA,                         "
     cQuery1 += "        0 AS EXENTAS,           "
     cQuery1 += "         SUM(SF3.F3_EXENTAS)*(-1) AS NCC               "
     cQuery1 += " FROM "+RetSqlName("SF3")+" SF3      "
     cQuery1 += "  WHERE SF3.F3_FILIAL = '"+xFilial("SF3")+"'  AND "
     cQuery1 += "      SF3.D_E_L_E_T_ <> '*' AND   "
     cQuery1 += "      SF3.F3_ENTRADA >='"+Dtos(mv_par01)+"' AND  "
     cQuery1 += "      SF3.F3_ENTRADA <='"+Dtos(mv_par02)+"' AND  "
     cQuery1 += "      SF3.F3_ESPECIE IN('NCC')                  AND  "
     cQuery1 += "      SF3.F3_EXENTAS> 0 AND SF3.F3_FORMUL='S'  "
               
      
    cQuery1 += " GROUP BY SF3.F3_FILIAL,SF3.F3_ESTADO     "


    cQuery1 += "  UNION ALL        "

      
     cQuery1 += "  SELECT SF2.F2_FILIAL AS FILIAL,   "   
     cQuery1 += "        SF2.F2_EST    AS PROVINCIA,  " 
     cQuery1 += "        0 AS VALOR_BRUTO,  " 
     cQuery1 += "        SUM(SF2.F2_VALMERC) AS VALDEB ,            " 
     cQuery1 += "         SUM(SF2.F2_VALIMP1) AS IVA,              "
     cQuery1 += "        0  AS EXENTAS ,          "
      cQuery1 += "        0 AS NCC                "
     cQuery1 += " FROM "+RetSqlName("SF2")+" SF2      "
     cQuery1 += "  WHERE SF2.F2_FILIAL = '"+xFilial("SF2")+"'  AND "
     cQuery1 += "      SF2.D_E_L_E_T_ <> '*' AND   "
     cQuery1 += "      SF2.F2_EMISSAO >='"+Dtos(mv_par01)+"' AND  "
     cQuery1 += "      SF2.F2_EMISSAO <='"+Dtos(mv_par02)+"'AND  "
     cQuery1 += "      SF2.F2_ESPECIE ='NDC'      "
      
     cQuery1 += " GROUP BY SF2.F2_FILIAL,SF2.F2_EST     "


     cQuery1 += " UNION ALL  "



     cQuery1 += "  SELECT SF3.F3_FILIAL AS FILIAL,   "   
     cQuery1 += "        SF3.F3_ESTADO    AS PROVINCIA,  " 
     cQuery1 += "        0 AS VALOR_BRUTO,  " 
     cQuery1 += "        SUM(SF3.F3_EXENTAS)*(-1) AS VALDEB ,            " 
     cQuery1 += "         SUM(SF3.F3_VALIMP1)*(-1) AS IVA,                         "
     cQuery1 += "        0 AS EXENTAS,           "
     cQuery1 += "         0 AS NCC               "
     cQuery1 += " FROM "+RetSqlName("SF3")+" SF3      "
     cQuery1 += "  WHERE SF3.F3_FILIAL = '"+xFilial("SF3")+"'  AND "
     cQuery1 += "      SF3.D_E_L_E_T_ <> '*' AND   "
     cQuery1 += "      SF3.F3_ENTRADA >='"+Dtos(mv_par01)+"' AND  "
     cQuery1 += "      SF3.F3_ENTRADA <='"+Dtos(mv_par02)+"' AND  "
     cQuery1 += "      SF3.F3_ESPECIE IN('NDC')                  AND  "
     cQuery1 += "      SF3.F3_EXENTAS> 0 AND SF3.F3_FORMUL='S'  "
               
      
    cQuery1 += " GROUP BY SF3.F3_FILIAL,SF3.F3_ESTADO     "


    cQuery1 += " ) PROV    "


    cQuery1 += " GROUP BY PROV.FILIAL,PROV.PROVINCIA   "

    cQuery1 += " ORDER BY PROVINCIA   "      
	
ElseIf MV_PAR03==2 



   	cQuery1 := " SELECT PROV.FILIAL AS FILIAL,      "
    cQuery1 += "   PROV.PROVINCIA AS PROVINCIA,      "
    cQuery1 += "   SUM(PROV.GASTOS) AS GASTOS,   "
    cQuery1 += "   PROV.CONTA AS CONTA,               "  
    cQuery1 += "   PROV.DCSCONT  AS DESC01              " 
    
      

	cQuery1 += " FROM (    "
	
	
	
	cQuery1 += " SELECT SD1.D1_FILIAL AS FILIAL,    "
	cQuery1 += "        SA2.A2_EST AS PROVINCIA,     "
	cQuery1 += "        SUM(SD1.D1_TOTAL) AS GASTOS, "
	cQuery1 += "        SD1.D1_CONTA AS CONTA ,      " 
	cQuery1 += "        CT1.CT1_DESC01   AS DCSCONT  "
	
	cQuery1 += " FROM "+RetSqlName("SD1")+" SD1,"+RetSqlName("SA2")+" SA2, "+RetSqlName("SF1")+" SF1, "+RetSqlName("CT1")+" CT1, "
	
	
	cQuery1 += " (SELECT SE21.E2_FILIAL,    "
    cQuery1 += "       SE21.E2_NUM,         "
    cQuery1 += "           SE21.E2_FORNECE, "
    cQuery1 += "           SE21.E2_LOJA,    "
    cQuery1 += "           SE21.E2_NATUREZ, "
    cQuery1 += "            SE21.E2_PREFIXO "
    cQuery1 += "    FROM "+RetSqlName("SE2")+ " SE21        "
    cQuery1 += "    WHERE SE21.E2_FILIAL='"+xFilial("SE2")+"'      AND  "
    cQuery1 += "          SE21.D_E_L_E_T_ <> '*'        "
        
    cQuery1 += "    GROUP BY SE21.E2_FILIAL,SE21.E2_NUM,SE21.E2_FORNECE,SE21.E2_LOJA,SE21.E2_NATUREZ,SE21.E2_PREFIXO) SE2 "
	
	
	cQuery1 += " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"'    AND  "
	cQuery1 += "       SD1.D_E_L_E_T_ <> '*'                   AND  "
    cQuery1 += "       SD1.D1_DTDIGIT>='"+Dtos(mv_par01)+"'    AND  "
    cQuery1 += "       SD1.D1_DTDIGIT<='"+Dtos(mv_par02)+"'    AND  "
	cQuery1 += "       SD1.D1_FORNECE=SA2.A2_COD               AND  "
	cQuery1 += "       SD1.D1_LOJA =SA2.A2_LOJA                AND  " 
	cQuery1 += "       SA2.D_E_L_E_T_ <>'*'                    AND  "
	cQuery1 += "       SD1.D_E_L_E_T_ <> '*'                   AND  "
	cQuery1 += "       SD1.D1_QUANT > 0                        AND  " 
	cQuery1 += "       SUBSTR(SD1.D1_COD,1,4)='SERV'        AND  "
	cQuery1 += "       SD1.D1_FILIAL = SE2.E2_FILIAL           AND  "
	cQuery1 += "       SD1.D1_SERIE = SE2.E2_PREFIXO           AND  " 
	cQuery1 += "       SD1.D1_DOC    = SE2.E2_NUM              AND  "
	cQuery1 += "       SD1.D1_FORNECE= SE2.E2_FORNECE          AND  "
	cQuery1 += "       SD1.D1_LOJA   = SE2.E2_LOJA             AND  "
	cQuery1 += "       SE2.E2_NATUREZ NOT IN('21003','21004')  AND  "
	cQuery1 += "       SD1.D1_FILIAL = SF1.F1_FILIAL           AND  "
	cQuery1 += "       SD1.D1_DOC = SF1.F1_DOC                 AND  "
	cQuery1 += "       SD1.D1_FORNECE = SF1.F1_FORNECE         AND  "
	cQuery1 += "       SD1.D1_LOJA    = SF1.F1_LOJA            AND  "
	cQuery1 += "       SF1.D_E_L_E_T_ <>'*'                    AND  "
	cQuery1 += "       SD1.D1_SERIE =SF1.F1_SERIE              AND  "
	cQuery1 += "       SD1.D1_CONTA = CT1.CT1_CONTA            AND  "
	cQuery1 += "       CT1.D_E_L_E_T_ <> '*'                        "  
	cQuery1 += " GROUP BY SD1.D1_FILIAL,SA2.A2_EST,SD1.D1_CONTA,CT1.CT1_DESC01  "
	          
	
	cQuery1 += " UNION ALL  "
	
	

    cQuery1 += " SELECT SE2.E2_FILIAL AS FILIAL,                 "
	cQuery1 += "        SA2.A2_EST AS PROVINCIA,                 "
	cQuery1 += "        SUM(SE2.E2_VALOR) AS GASTOS,             "
	cQuery1 += "        SED.ED_CONTA AS CONTA ,                  "  
	cQuery1 += "        CT1.CT1_DESC01   AS DCSCONT               "
	
	cQuery1 += " FROM "+RetSqlName("SE2")+" SE2, "+RetSqlName("SED")+" SED, "+RetSqlName("CT1")+" CT1, "+RetSqlName("SA2")+" SA2 "
	cQuery1 += " WHERE SE2.E2_FILIAL ='"+xFilial("SE2")+"'    AND  "
	cQuery1 += "       SE2.D_E_L_E_T_ <> '*'                  AND  "
	cQuery1 += "       SE2.E2_EMISSAO >='"+Dtos(mv_par01)+"'  AND  "
	cQuery1 += "       SE2.E2_EMISSAO <='"+Dtos(mv_par02)+"'  AND  "
	cQuery1 += "       SE2.E2_PREFIXO ='FIN'                  AND  "
	cQuery1 += "       SE2.E2_NATUREZ = SED.ED_CODIGO         AND  "
	cQuery1 += "       SED.D_E_L_E_T_ <>'*'                   AND  " 
	cQuery1 += "       SE2.E2_FORNECE = SA2.A2_COD            AND  "
	cQuery1 += "       SE2.E2_LOJA    = SA2.A2_LOJA           AND  "
	cQuery1 += "       SA2.D_E_L_E_T_ <> '*'                  AND  "
	cQuery1 += "       SUBSTR(SED.ED_CONTA,1,1) IN ('3','4','5') AND   "
	cQuery1 += "       SED.ED_CONTA= CT1.CT1_CONTA            AND      "
	cQuery1 += "       CT1.D_E_L_E_T_ <> '*'                           "
	
	cQuery1 += "	GROUP  BY SE2.E2_FILIAL  ,  "
    	cQuery1 += "              SA2.A2_EST,   "
       	cQuery1 += "           SED.ED_CONTA,  "
      	cQuery1 += "            CT1.CT1_DESC01  "
	           
	cQuery1 += " )   PROV " 
	 
	
	cQuery1 += " GROUP BY PROV.FILIAL,PROV.PROVINCIA,PROV.CONTA,PROV.DCSCONT  "
	
	cQuery1 += " ORDER BY  PROV.PROVINCIA                               "
	
	
Endif

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

   If MV_PAR03==1
	
	aDados1[01]  := (cAlias1)->(PROVINCIA)
	aDados1[02]  := Transform((cAlias1)->VALOR_BRUTO,"@E 9,999,999,999,999.99")
	aDados1[03]  := Transform((cAlias1)->VADEB ,"@E 9,999,999,999,999.99") 
	aDados1[04]  := Transform((cAlias1)->IVA ,"@E 9,999,999,999,999.99")
	//aDados1[05]  := Transform((cAlias1)->EXENTAS ,"@E 9,999,999,999,999.99")    
	aDados1[06]  := Transform((cAlias1)->NCC,"@E 9,999,999,999,999.99")  
	ElseIf MV_PAR03==2
		aDados1[01]  := (cAlias1)->(PROVINCIA)                                 
		aDados1[03]  := (cAlias1)->(CONTA) 
		aDados1[04]  := (cAlias1)->(DESC01)                     
	aDados1[02]  := Transform((cAlias1)->GASTOS,"@E 9,999,999,999,999.99")
	Endif
	
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
