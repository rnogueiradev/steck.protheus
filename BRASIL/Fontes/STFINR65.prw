#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STFINR65  º Autor ³ Cristiano Pereiraº Data ³  30/03/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relação de movimentos de entrada das notas fiscais         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function  STFINR65()

	Local oReport
	Local aArea	:= GetArea()
	Local aParam   := {}
	Local aRet     := {}
	Private _cEspecie := Space(50)
	Private _dDatDe  := ctod(space(8))
	Private _dDatAt  := ctod(space(8))


	aAdd(aParam, {1, "Data Digitação De:",_dDatDe , "@!", ".T.","SF1", ".T.", 50, .F.})
	aAdd(aParam, {1, "Data DigitaçãoAte:",_dDatAt, "@!", ".T.","SF1", ".T.", 50, .T.})
    aAdd(aParam, {1, "Especie:",_cEspecie, "@S50",".T.",, ".T.", 50, .F.})

	If !ParamBox(aParam,"Informe os dados", @aRet,,,,,,,,.F.,.F.)
		RestArea( aArea )
		Return
	EndIf

	oReport 	:= ReportDef()
	oReport		:PrintDialog()
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
	Static aDados1[14]

Static Function ReportDef()

	Private oReport
	Private oSection1
	Private oBreak1
	Private oSecFil

	oReport := TReport():New("STFIN65","Movimentos do recebimento de materiais","STFIN65",{|oReport| ReportPrint(oReport)},"Este programa ira imprimir a relação das entradas de notas fiscais")

	oReport:SetLandscape()
	pergunte("STFIN65",.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros						  ³
	//³ mv_par01			// Mes							 		  ³
	//³ mv_par02			// Ano									  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 7

	oSection1 := TRSection():New(oReport,"Financeiro",{"SF1"},)

	TRCell():New(oSection1,"FILIAL"	,,"FILIAL."	,"@!",02,.F.,)
	TRCell():New(oSection1,"NF"		,,"NOTA FISCAL"	,"@!",9,.F.,)
	TRCell():New(oSection1,"SERIE"		,,"SERIE"	,"@!",03,.F.,)
	TRCell():New(oSection1,"FORNECE"		,,"FORNECEDOR"	,"@!",6,.F.,)
	TRCell():New(oSection1,"LOJA"		,,"LOJA"	,"@!",2,.F.,)
	TRCell():New(oSection1,"NOME"		,,"NOME"	,"@!",30,.F.,)
	TRCell():New(oSection1,"EMISSAO"		,,"EMISSAO"	,"@!",10,.F.,)
	TRCell():New(oSection1,"ESPECIE"		,,"ESPECIE"	,"@!",10,.F.,)
	TRCell():New(oSection1,"NOTREC"		,,"NOT.RECEBIMENTO"	,"@!",10,.F.,)
	TRCell():New(oSection1,"STATUS"		,,"STATUS"	,"@!",02,.F.,)
	TRCell():New(oSection1,"DTREC"		,,"DATA RECECEBIMENTO","@!",10,.F.,)
	TRCell():New(oSection1,"DTNOTIF"		,,"DATA NOTIFICACAO","@!",010,.F.,)
	TRCell():New(oSection1,"DTDIGI"		,,"DATA DIGITACAO","@!",010,.F.,)
    TRCell():New(oSection1,"DELETE"		,,"DELETADO","@!",010,.F.,)

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("SF1")


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

	Local cTitulo		:= OemToAnsi("Recebimento de materiais ")+Dtoc(MV_PAR01)+" A "+Dtoc(MV_PAR02)
	Local cAlias1		:= "QRY1SF1"
	Local cQuery1		:= ""
	Local oSection1     := oReport:Section(1)



	oSection1:Cell("FILIAL"  )   	:SetBlock( { || aDados1[1] })
	oSection1:Cell("NF" )		    :SetBlock( { || aDados1[2] })
	oSection1:Cell("SERIE" )	   	    :SetBlock( { || aDados1[3] })
	oSection1:Cell("FORNECE" )	   	:SetBlock( { || aDados1[4] })
	oSection1:Cell("LOJA" )	   	:SetBlock( { || aDados1[5] })
	oSection1:Cell("NOME" )	   	    :SetBlock( { || aDados1[6] })
	oSection1:Cell("STATUS" )	   	    :SetBlock( { || aDados1[7] })
	oSection1:Cell("EMISSAO" )	   	    :SetBlock( { || aDados1[8] })
	oSection1:Cell("NOTREC" )	   	    :SetBlock( { || aDados1[9] })
	oSection1:Cell("DELETE" )	   	    :SetBlock( { || aDados1[10] })
	oSection1:Cell("DTREC" )	   	    :SetBlock( { || aDados1[11] })
	oSection1:Cell("DTDIGI" )	   	    :SetBlock( { || aDados1[12] })
	oSection1:Cell("DTNOTIF" )	   	    :SetBlock( { || aDados1[13] })
	oSection1:Cell("ESPECIE" )	   	    :SetBlock( { || aDados1[14] })
	




	cQuery1 := " SELECT SF1.F1_FILIAL AS FIL, "
	cQuery1 += " SF1.F1_DOC    AS NF,         "
	cQuery1 += " SF1.F1_ESPECIE    AS ESPECIE,         "
	cQuery1 += " SF1.F1_SERIE  AS SERIE,      "
	cQuery1 += " SF1.F1_FORNECE AS FORNECE,   "
	cQuery1 += " SF1.F1_LOJA    AS LOJA,      "
	cQuery1 += " SA2.A2_NOME    AS NOME_FOR,  "
	cQuery1 += " SF1.F1_STATUS AS STATUS_NF,  "
	cQuery1 += " SUBSTR(SF1.F1_EMISSAO,7,2)||'/'||SUBSTR(SF1.F1_EMISSAO,5,2)||'/'||SUBSTR(SF1.F1_EMISSAO,1,4) AS EMISSAO, "
	cQuery1 += " SF1.F1_XNOTREB  AS NOT_RECEBIMENTO, "
	cQuery1 += " CASE WHEN SF1.D_E_L_E_T_ ='*' THEN 'DELETADA' ELSE 'ATIVA' END AS STATUS, "
	cQuery1 += " SF1.F1_RECBMTO AS RECECIMENTO, "
	cQuery1 += " SF1.F1_DTDIGIT AS DATA_DIGITACAO, "
	cQuery1 += " SF1.F1_DTNOTIF  AS DATA_NOTIFICACAO "

	cQuery1 += " FROM "+RetSqlName("SF1")+" SF1, "+RetSqlName("SA2")+" SA2   "

	cQuery1 += " WHERE   "
	cQuery1 += " SF1.F1_ESPECIE ='"+RTRIM(MV_PAR03)+"'        AND                                       "
	cQuery1 += " SF1.F1_DTDIGIT>='"+Dtos(MV_PAR01)+"'  AND                             "
	cQuery1 += " SF1.F1_DTDIGIT<='"+Dtos(MV_PAR02)+"'  AND                             "

	cQuery1 += " SF1.F1_FORNECE = SA2.A2_COD AND                                       "
	cQuery1 += " SF1.F1_LOJA    = SA2.A2_LOJA AND                                      "
	cQuery1 += " SA2.D_E_L_E_T_ <>'*'                                                  "


	cQuery1 += " ORDER BY   "
	cQuery1 += " SF1.F1_FILIAL, "
	cQuery1 += " SF1.F1_DOC, "
	cQuery1 += " SF1.F1_SERIE, "
	cQuery1 += " SF1.F1_FORNECE, "
	cQuery1 += " SF1.F1_LOJA "


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

		aDados1[01]  :=  (cAlias1)->(FIL)
		aDados1[02]  :=  (cAlias1)->(NF)
		aDados1[03]  :=  (cAlias1)->(SERIE)
		aDados1[04]  :=  (cAlias1)->(FORNECE)
		aDados1[05]  :=  (cAlias1)->(LOJA)
		aDados1[06]  :=  (cAlias1)->(NOME_FOR)
		aDados1[07]  :=  (cAlias1)->(STATUS_NF)
		aDados1[08]  :=  (cAlias1)->(EMISSAO)
		aDados1[09]  :=  (cAlias1)->(NOT_RECEBIMENTO)
		aDados1[10]  :=  (cAlias1)->(STATUS)
		aDados1[11]  :=  DTOC(STOD((cAlias1)->(RECECIMENTO)))
		aDados1[12]  :=  DTOC(STOD((cAlias1)->(DATA_DIGITACAO)))
		aDados1[13]  :=  DTOC(STOD((cAlias1)->(DATA_NOTIFICACAO)))
        aDados1[14]  :=  (cAlias1)->(ESPECIE)

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

