#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AREST001  º Autor ³ Cristiano Pereiraº Data ³  30/03/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Listado costo de ventas                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AREST001()

	Local oReport
	Local aArea	:= GetArea()



	If Pergunte("AREST01",.T.)
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

	oReport := TReport():New("AREST01","Listado costo del ventas","AREST01",{|oReport| ReportPrint(oReport)},"Listado costo del ventas.")

	oReport:SetLandscape()
	pergunte("AREST01",.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros						  ³
	//³ mv_par01			// Mes							 		  ³
	//³ mv_par02			// Ano									  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	oSection1 := TRSection():New(oReport,"Costo Ventas",{"SD2"},)


	TRCell():New(oSection1,"FACTURA"	    ,,"FACTURA"	    ,"@!",009,.F.,)
	TRCell():New(oSection1,"PRODUCTO"	    ,,"PRODUCTO"	,"@!",015,.F.,)
	TRCell():New(oSection1,"DEPOSITO"	,,"DEPOSITO","@!",05,.F.,)
	TRCell():New(oSection1,"CANTIDAD"	,,"CANTIDAD","@!",18,.F.,)
	TRCell():New(oSection1,"DESCPRO"		,,"DESC PRODUTO" ,"@!",030,.F.,)
	TRCell():New(oSection1,"CLIENTE"   ,,"CLIENTE" ,"@!",06,.F.,)
	TRCell():New(oSection1,"LOJA"		    ,,"LOJA"	,"@!",02,.F.,)
	TRCell():New(oSection1,"NOME"		    ,,"NOME"	,"@!",30,.F.,)
	TRCell():New(oSection1,"COSTOPE"		,,"COSTO TOTALE PESO"	,"@!",20,.F.,)
	TRCell():New(oSection1,"COSTODO"		,,"COSTO TOTALE DOLAR"	,"@!",20,.F.,)
	TRCell():New(oSection1,"PAIS"		,,"PAIS ORIGEM"	,"@!",20,.F.,)
	

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

	Local cTitulo		:= OemToAnsi("Costo del ventas")
	Local cAlias1		:= "QRY1SD2"
	Local cQuery1		:= ""
	Local aDados1[11]
	Local oSection1  := oReport:Section(1)

	


	oSection1:Cell("FACTURA"  )		:SetBlock( { || aDados1[1] })
	oSection1:Cell("PRODUCTO" )		:SetBlock( { || aDados1[2] })
	oSection1:Cell("DEPOSITO" )		:SetBlock( { || aDados1[3] })
	oSection1:Cell("CANTIDAD" )		:SetBlock( { || aDados1[11] })
	oSection1:Cell("DESC PRODUTO" )		:SetBlock( { || aDados1[4] })
	oSection1:Cell("CLIENTE" )	    	:SetBlock( { || aDados1[5] })
	oSection1:Cell("LOJA" )	    	:SetBlock( { || aDados1[6] })
	oSection1:Cell("NOME" )	:SetBlock( { || aDados1[7] })
	oSection1:Cell("COSTO TOTALE PESO" )	:SetBlock( { || aDados1[8] })
	oSection1:Cell("COSTO TOTALE DOLAR" )	:SetBlock( { || aDados1[9] })
	oSection1:Cell("PAIS ORIGEM" )	:SetBlock( { || aDados1[10] })



	cQuery1 := "  SELECT SD2.D2_FILIAL  AS FIL, "
    cQuery1 += "   SD2.D2_DOC     AS FACTURA,  "
    cQuery1 += "   SD2.D2_COD     AS PRODUCTO, "
	cQuery1 += "   SD2.D2_QUANT   AS QUANT ,   "
    cQuery1 += "   SD2.D2_LOCAL   AS DEPOSITO,  "
    cQuery1 += "   SB1.B1_DESC    AS DESCR, "
    cQuery1 += "   SD2.D2_CLIENTE AS CLIENTE, "
    cQuery1 += "   SD2.D2_LOJA    AS LOJA, "
    cQuery1 += "   SA1.A1_NOME    AS NOME, "
    cQuery1 += "   SD2.D2_CUSRP1  AS custo_pesos, "
    cQuery1 += "   SD2.D2_CUSRP2  AS custo_dolar, "
    cQuery1 += "   SB1.B1_XPAIS   AS PAIS_ORIGEM         "
       
    cQuery1 += " FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SF4")+" SF4 " 

    cQuery1 += " WHERE SD2.D2_FILIAL = '"+xfilial("SD2")+"'           AND "
    cQuery1 += "       SD2.D2_EMISSAO>='"+Dtos(MV_PAR01)+"'           AND "
    cQuery1 += "       SD2.D2_EMISSAO<='"+Dtos(MV_PAR02)+"'           AND "
    cQuery1 += "       SD2.D_E_L_E_T_ <>'*'                           AND "
    cQuery1 += "       SD2.D2_CUSRP1 > 0                              AND "
    cQuery1 += "       SUBSTRING(SD2.D2_DOC,1,4) = '0001'             AND "
    cQuery1 += "       SD2.D2_CLIENTE = SA1.A1_COD                    AND "
    cQuery1 += "       SD2.D2_LOJA    = SA1.A1_LOJA                   AND "
    cQuery1 += "       SA1.D_E_L_E_T_ <> '*'                          AND "
    cQuery1 += "       SD2.D2_COD  = SB1.B1_COD                       AND "
    cQuery1 += "       SB1.D_E_L_E_T_ <> '*'                          AND "
    cQuery1 += "       SD2.D2_TES = SF4.F4_CODIGO                     AND "
    cQuery1 += "       SF4.D_E_L_E_T_ <> '*'                          AND "
    cQuery1 += "       SF4.F4_ESTOQUE='S'                                 "
	
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

		
        aDados1[01]  := (cAlias1)->(FACTURA)
		aDados1[02]  := (cAlias1)->(PRODUCTO)
		aDados1[03]  := (cAlias1)->DEPOSITO
		aDados1[04]  := (cAlias1)->DESCR
		aDados1[05]  := (cAlias1)->(CLIENTE)
		aDados1[06]  := (cAlias1)->(LOJA)
		aDados1[07]  := (cAlias1)->(NOME)
		aDados1[08]  := Alltrim(Transform((cAlias1)->(custo_pesos),PesqPict("SD2","D2_CUSRP1")))
		aDados1[09]  := Alltrim(Transform((cAlias1)->(custo_dolar),PesqPict("SD2","D2_CUSRP2"))) 
		aDados1[10]  := (cAlias1)->PAIS_ORIGEM   
		aDados1[11]  := (cAlias1)->QUANT
		
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
