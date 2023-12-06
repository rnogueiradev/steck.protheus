#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STCTBR65  º Autor ³ Cristiano Pereiraº Data ³  30/03/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Movimentos contábeis x usuário de inclusão                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function  STCTBR65()

	Local oReport
	Local aArea	:= GetArea()
	Local aParam   := {}
	Local aRet     := {}
	Private _dDatDe  := ctod(space(8))
	Private _dDatAt  := ctod(space(8))

	aAdd(aParam, {1, "Date De:",_dDatDe , "@!", ".T.","CT2", ".T.", 50, .F.})
	aAdd(aParam, {1, "Date Ate:",_dDatAt, "@!", ".T.","CT2", ".T.", 50, .T.})

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
	Static aDados1[18]

Static Function ReportDef()

	Private oReport
	Private oSection1
	Private oBreak1
	Private oSecFil

	oReport := TReport():New("STCTB65","Movimentos contábeis com usuário de inclusão","STCTB65",{|oReport| ReportPrint(oReport)},"Este programa ira imprimir a relação dos movimentos contábeis com o usuário de inclusão")

	oReport:SetLandscape()
	pergunte("STCTB65",.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros						  ³
	//³ mv_par01			// Mes							 		  ³
	//³ mv_par02			// Ano									  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 7

	oSection1 := TRSection():New(oReport,"Contabilidade Gerencial",{"CT2"},)

	TRCell():New(oSection1,"DATA"	,,"DATA MOV."	,"@!",25,.F.,)
	TRCell():New(oSection1,"LOTE"		,,"LOTE"	,"@!",15,.F.,)
	TRCell():New(oSection1,"SUB"		,,"SUB LOTE"	,"@!",03,.F.,)
	TRCell():New(oSection1,"DOC"		,,"DOCUMENTO"	,"@!",15,.F.,)
	TRCell():New(oSection1,"LINHA"		,,"LINHA"	,"@!",15,.F.,)
	TRCell():New(oSection1,"LCTO"		,,"LCTO"	,"@!",10,.F.,)
	TRCell():New(oSection1,"DEBITO"		,,"CONTA DEBITO"	,"@!",02,.F.,)
	TRCell():New(oSection1,"CREDITO"		,,"CONTA CREDITO"	,"@!",02,.F.,)
	TRCell():New(oSection1,"VALOR"		,,"VALOR"	,"@E 9,999,999,999,999.99",18,.F.,)
	TRCell():New(oSection1,"HISTPAD"		,,"HIS PAD","@!",010,.F.,)
	TRCell():New(oSection1,"HIST"		,,"HISTORICO","@!",100,.F.,)
	TRCell():New(oSection1,"ITEMD"		,,"ITEM DEBITO","@!",030,.F.,)
	TRCell():New(oSection1,"ITEMC"		,,"ITEM CREDITO","@!",030,.F.,)
	TRCell():New(oSection1,"CCD"		,,"CC DEBITO","@!",030,.F.,)
	TRCell():New(oSection1,"CCC"		,,"CC CREDITO","@!",030,.F.,)
	TRCell():New(oSection1,"ROTINA"		,,"ROTINA","@!",030,.F.,)
	TRCell():New(oSection1,"USUARIO"		,,"USUARIO INCLUSÃO","@!",07,.F.,)
	TRCell():New(oSection1,"NOME"		,,"NOME","@!",032,.F.,)


	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("CT2")


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

	Local cTitulo		:= OemToAnsi("Movimentos contábeis ")+Dtoc(MV_PAR01)+" A "+Dtoc(MV_PAR02)
	Local cAlias1		:= "QRY1CT2"
	Local cQuery1		:= ""
	Local oSection1     := oReport:Section(1)



	oSection1:Cell("DATA"  )   	:SetBlock( { || aDados1[1] })
	oSection1:Cell("LOTE" )		    :SetBlock( { || aDados1[2] })
	oSection1:Cell("SUB" )	   	    :SetBlock( { || aDados1[3] })
	oSection1:Cell("DOC" )	   	:SetBlock( { || aDados1[4] })
	oSection1:Cell("LINHA" )	   	:SetBlock( { || aDados1[5] })
	oSection1:Cell("LCTO" )	   	    :SetBlock( { || aDados1[6] })
	oSection1:Cell("DEBITO" )	   	    :SetBlock( { || aDados1[7] })
	oSection1:Cell("CREDITO" )	   	    :SetBlock( { || aDados1[8] })
	oSection1:Cell("VALOR" )	   	    :SetBlock( { || aDados1[9] })
	oSection1:Cell("HISTPAD" )	   	    :SetBlock( { || aDados1[10] })
	oSection1:Cell("HIST" )	   	    :SetBlock( { || aDados1[11] })
	oSection1:Cell("ITEMD" )	   	    :SetBlock( { || aDados1[12] })
	oSection1:Cell("ITEMC" )	   	    :SetBlock( { || aDados1[13] })
	oSection1:Cell("ROTINA" )	   	    :SetBlock( { || aDados1[14] })
	oSection1:Cell("USUARIO" )	   	    :SetBlock( { || aDados1[15] })
	oSection1:Cell("NOME" )	   	    :SetBlock( { || aDados1[16] })
	oSection1:Cell("CCD" )	   	    :SetBlock( { || aDados1[17] })
	oSection1:Cell("CCC" )	   	    :SetBlock( { || aDados1[18] })


	cQuery1 := " SELECT CT2.*,                        "
	cQuery1 += " substr(CT2.CT2_USERGI, 3, 1) || substr(CT2.CT2_USERGI, 7, 1) || "
	cQuery1 += " substr(CT2.CT2_USERGI, 11, 1) || substr(CT2.CT2_USERGI, 15, 1) || "
	cQuery1 += " substr(CT2.CT2_USERGI, 2, 1) || substr(CT2.CT2_USERGI, 6, 1) || "
	cQuery1 += " substr(CT2.CT2_USERGI, 10, 1) || substr(CT2.CT2_USERGI, 14, 1) || "
	cQuery1 += " substr(CT2.CT2_USERGI, 1, 1) || substr(CT2.CT2_USERGI, 5, 1) ||  "
	cQuery1 += " substr(CT2.CT2_USERGI, 9, 1) || substr(CT2.CT2_USERGI, 13, 1) || "
	cQuery1 += " substr(CT2.CT2_USERGI, 17, 1) || substr(CT2.CT2_USERGI, 4, 1) || "
	cQuery1 += " substr(CT2.CT2_USERGI, 8, 1) USUARIO                             "

	cQuery1 += " FROM "+RetSqlName("CT2")+" CT2 "
	cQuery1 += "  WHERE CT2.D_E_L_E_T_ <> '*'            AND "
	cQuery1 += "  CT2.CT2_DATA>='"+Dtos(MV_PAR01)+"'     AND "
	cQuery1 += "  CT2.CT2_DATA<='"+Dtos(MV_PAR02)+"'     AND "
	cQuery1 += " CT2.CT2_ROTINA='CTBA102'                   "


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

		aDados1[01]  := DTOC(STOD((cAlias1)->(CT2_DATA)))
		aDados1[02]  :=  (cAlias1)->(CT2_LOTE)
		aDados1[03]  :=  (cAlias1)->(CT2_SBLOTE)
		aDados1[04]  :=  (cAlias1)->(CT2_DOC)
		aDados1[05]  :=  (cAlias1)->(CT2_LINHA)
		aDados1[06]  :=  IIF((cAlias1)->(CT2_DC)=="1","DEBITO", IIF((cAlias1)->(CT2_DC)=="2","CREDITO","PARTIDA DOBRADA"))
        aDados1[07]  :=  (cAlias1)->(CT2_DEBITO)
        aDados1[08]  :=  (cAlias1)->(CT2_CREDIT)
		aDados1[09]  :=  (cAlias1)->(CT2_VALOR)
		aDados1[10]  :=  (cAlias1)->(CT2_HP)
		aDados1[11]  :=  (cAlias1)->(CT2_HIST)
		aDados1[12]  :=  (cAlias1)->(CT2_ITEMD)
		aDados1[13]  :=  (cAlias1)->(CT2_ITEMC)
		aDados1[14]  :=  (cAlias1)->(CT2_ROTINA)
		aDados1[15]  := SubStr((cAlias1)->(USUARIO ),3,6)
		aDados1[16]  := UsrRetName(SubStr((cAlias1)->(USUARIO ),3,6))
		aDados1[17]  :=  (cAlias1)->(CT2_CCD)
		aDados1[18]  :=  (cAlias1)->(CT2_CCC)


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

