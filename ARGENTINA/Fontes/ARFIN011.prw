#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ARFIN011  º Autor ³ Cristiano Pereiraº Data ³  30/03/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Listado los cobros                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ARFIN011()

	Local oReport
	Local aArea	:= GetArea()



	//If Pergunte("ARFIN11",.T.)
	oReport 	:= ReportDef()
	oReport		:PrintDialog()
	//EndIf

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

	oReport := TReport():New("ARFIN011","Listado los cobros","ARFIN011",{|oReport| ReportPrint(oReport)},"Listado los Cobros.")

	oReport:SetLandscape()
	//pergunte("ARFIS07",.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros						  ³
	//³ mv_par01			// Mes							 		  ³
	//³ mv_par02			// Ano									  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	oSection1 := TRSection():New(oReport,"Cobros",{"SE1"},)


	TRCell():New(oSection1,"CLIENTE"	    ,,"CLIENTE"	    ,"@!",006,.F.,)
	TRCell():New(oSection1,"TITULO"	    ,,"TITULO"	,"@!",010,.F.,)
	TRCell():New(oSection1,"NOMCLI"	,,"NOMCLI","@!",030,.F.,)
	TRCell():New(oSection1,"TIPO"		,,"TIPO" ,"@!",5,.F.,)
	TRCell():New(oSection1,"EMISION"   ,,"EMISION" ,"@!",010,.F.,)
	TRCell():New(oSection1,"VENC"		    ,,"VENCIMENTO"	,"@!",010,.F.,)
	TRCell():New(oSection1,"VALOR"		    ,,"VALOR"	,"@!",16,.F.,)
	TRCell():New(oSection1,"SALDO"		    ,,"SALDO"	,"@!",16,.F.,)
	TRCell():New(oSection1,"HISTOR"		,,"HISTORIAL"	,"@!",16,.F.,)
	TRCell():New(oSection1,"VEND"		,,"VENDEDOR"	,"@!",20,.F.,)
	TRCell():New(oSection1,"NOMVEN"		,,"NOMVEN"	,"@!",20,.F.,)



	//oBreak1 := TRBreak():New(oSection1,".T.","Total general",.F.)
	//oFunction := TRFunction():New(oSection1:Cell('BASE_IMPONIBLE'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.)
	//oFunction := TRFunction():New(oSection1:Cell('RETENCION'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.)



	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("SE1")


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

	Local cTitulo		:= OemToAnsi("Listado del cobros")
	Local cAlias1		:= "QRY1SE1"
	Local cQuery1		:= ""
	Local nRecSM0		:= SM0->(Recno())
	Local aDados1[11]
	Local oSection1  := oReport:Section(1)




	oSection1:Cell("CLIENTE"  )		:SetBlock( { || aDados1[1] })
	oSection1:Cell("TITULO" )		:SetBlock( { || aDados1[2] })
	oSection1:Cell("NOMCLI" )		:SetBlock( { || aDados1[3] })
	oSection1:Cell("TIPO" )		:SetBlock( { || aDados1[4] })
	oSection1:Cell("EMISION" )	    	:SetBlock( { || aDados1[5] })
	oSection1:Cell("VENC" )	    	:SetBlock( { || aDados1[6] })
	oSection1:Cell("VALOR" )	:SetBlock( { || aDados1[7] })
	oSection1:Cell("SALDO" )	:SetBlock( { || aDados1[8] })
	oSection1:Cell("HISTOR" )	:SetBlock( { || aDados1[9] })
	oSection1:Cell("VEND" )	:SetBlock( { || aDados1[10] })
	oSection1:Cell("NOMVEN" )	:SetBlock( { || aDados1[11] })


	If Select(cAlias1) > 0
		DbSelectArea(cAlias1)
		DbCloSeArea()
	Endif

	cQuery1 := " "
	cQuery1 += " SELECT SE1.E1_FILIAL AS FIL,SE1.E1_PREFIXO AS PREF,SE1.E1_VALOR AS VALOR,SE1.E1_TIPO AS TIPO,SE1.E1_NUM AS NUM,SE1.E1_CLIENTE AS CLIENTE,SE1.E1_LOJA AS LOJA,SE1.E1_PARCELA AS PARC,SE1.E1_SALDO AS SALDO,SE1.E1_NOMCLI AS NOMCLI,SA3.A3_COD AS VEND,SA3.A3_NOME AS NOVND,SE1.E1_EMISSAO AS EMIS,SE1.E1_VENCTO AS VENCTO,SE1.E1_HIST AS HISTOR  "
	cQuery1 += " FROM  "+RetSqlName("SE1")+" SE1, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3 "
	cQuery1 += " WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"'                                   AND                            "
	cQuery1 += "       SE1.D_E_L_E_T_ <> '*'                                                  AND                            "
	cQuery1 += "       SE1.E1_SALDO > 0                                                       AND                            "
	cQuery1 += "       SE1.E1_TIPO <> 'CH'                                                    AND                            "
	cQuery1 += "       SE1.E1_CLIENTE = SA1.A1_COD                                            AND                            "
	cQuery1 += "       SE1.E1_LOJA    = SA1.A1_LOJA                                           AND                            "
	cQuery1 += "       SA1.D_E_L_E_T_ <> '*'                                                  AND                            "
	cQuery1 += "       SE1.E1_VEND1 = SA3.A3_COD                                              AND                            "
	cQuery1 += "       SA3.D_E_L_E_T_ <>'*'                                                                                  " 


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


		aDados1[01]  := (cAlias1)->(CLIENTE)
		aDados1[02]  := (cAlias1)->(NUM)
		aDados1[03]  := (cAlias1)->NOMCLI
		aDados1[04]  := (cAlias1)->TIPO
		aDados1[05]  := Dtoc(Stod((cAlias1)->(EMIS)))
		aDados1[06]  := Dtoc(Stod((cAlias1)->(VENCTO)))
		aDados1[07]  := Transform((cAlias1)->(VALOR),'@E 999,999,999,999,999.99')
		aDados1[08]  := Transform((cAlias1)->(SALDO),'@E 999,999,999,999,999.99')
		aDados1[09]  := (cAlias1)->(HISTOR)
		aDados1[10]  := (cAlias1)->(VEND)   
		aDados1[11]  :=(cAlias1)->(NOVND)



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