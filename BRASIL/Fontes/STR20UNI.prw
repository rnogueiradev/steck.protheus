#include "Protheus.ch"
#include "TopConn.ch"

/*/{Protheus.doc} STR20UNI
    (long_description)
    Relatório Unicom Pendentes a Produzir
    @author user
    Valdemir Rabelo
    @since date
    26/02/2020
    /*/
User Function STR20UNI()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := "STR20UNICO"
	
    // Cria Pergunta
    CriaSX1()
    if !pergunte(cPerg)
       Return
    Endif
	//Cria as definições do relatório
	oReport := fReportDef()
	
	//Será enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)

		//Senão, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	
	RestArea(aArea)

Return .T.


/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Função que monta a definição do relatório                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad  := Nil
	Local oSectDad1 := Nil
	Local oSectDad2 := Nil
	Local oBreak    := Nil
	Local oFunTot1  := Nil
	Local oFunTot2  := Nil
	Local aOrdem    := {}
	
	//Criação do componente de impressão
	oReport := TReport():New(	"STR20UNI",;		//Nome do Relatório
								"ITENS PENDENTES A PRODUZIR",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape()
	
	//Criando a seção de dados
	oSectDad  := TRSection():New(	oReport,;	    	//Objeto TReport que a seção pertence
									"UNICON",;		//Descrição da seção
									{"PP7"},;		//Tabelas utilizadas, a primeira será considerada como principal da seção
									aOrdem)
    //Style()
	//Colunas do relatório
	TRCell():New(oSectDad,  "PP7_01", , "ATENDIMENTO",  "@!",                8, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
	TRCell():New(oSectDad,  "PP7_02", , "CLIENTE",      "@!",               10, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
	TRCell():New(oSectDad,  "PP7_03", , "LOJA",         "@!",                6, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
	TRCell():New(oSectDad,  "PP7_04", , "NOME",         "@!",               30, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
	TRCell():New(oSectDad,  "PP7_05", , "EMISSÃO",      "@D 99/99/9999",    12, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
	TRCell():New(oSectDad,  "PP7_06", , "REPRESENTANTE","@!",               10, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
	TRCell():New(oSectDad,  "PP7_07", , "PEDIDO",       "@!",               10, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)

	oSectDad:setnoFilter("QRY_AUX")
	oSectDad:SetHeaderSection(.T.)
	oSectDad:SetTotalInLine(.F.)
	

	oSectDad1 := TRSection():New(	oSectDad,;		//Objeto TReport que a seção pertence
									"UNICON",;		//Descrição da seção
									{"PP8"},;		//Tabelas utilizadas, a primeira será considerada como principal da seção
									aOrdem)

	TRCell():New(oSectDad1, "PP8_01", , "Item",         "@!",               3, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "PP8_02", , "Produto",      "@!",              15, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "PP8_03", , "Descrição",    "@!",              40, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "PP8_04", , "Desenho",      "@!",              20, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "PP8_05", , "Quantidade",   "@E 999999999",    14, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "PP8_06", , "Data Cliente", "@D 99/99/9999",    8, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "PP8_07", , "Data Entrega", "@D 99/99/9999",    8, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

	oSectDad1:setnoFilter("QRY_AUX")
	oSectDad1:SetHeaderSection(.T.)
	oSectDad1:SetTotalInLine(.F.)

	oSectDad2 := TRSection():New(	oSectDad1,;				//Objeto TReport que a seção pertence
									"ORÇAMENTO",;		//Descrição da seção
									{"SCK"},;				//Tabelas utilizadas, a primeira será considerada como principal da seção
									aOrdem)

	TRCell():New(oSectDad2, "CK_01", , "Item",         "@!",               2, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "CK_02", , "Produto",      "@!",              15, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "CK_06", , "Descrição",    "@!",              40, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "CK_03", , "UM",           "@!",               2, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "CK_04", , "Quantidade",   "@E 999999",       11, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "CK_05", , "Armazem",      "@!",               2, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	oSectDad2:SetHeaderSection(.T.)
	oSectDad2:SetTotalInLine(.F.)  					//Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha

	//Totalizadores
	//oFunTot1 := TRFunction():New(oSectDad1:Cell("PP8_05"),,"SUM",,,"@E 999999999")
	//oFunTot1:SetEndReport(.F.)
	//oFunTot1:SetEndSection(.T.)
	oFunTot2 := TRFunction():New(oSectDad2:Cell("CK_04"),,"SUM",,,"@E 999999999")
	oFunTot2:SetEndReport(.F.)
	oFunTot2:SetEndSection(.T.)


	oSectDad3 := TRSection():New(	oSectDad2,;				//Objeto TReport que a seção pertence
									"TOTAL POR QUEBRA",;		//Descrição da seção
									{"SCK"},;				//Tabelas utilizadas, a primeira será considerada como principal da seção
									aOrdem)

	TRCell():New(oSectDad3, "TOTAL_01", , "ATENDIMENTO",  		  "@!",                			8, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
	TRCell():New(oSectDad3, "TOTAL_02", , "TOTAL UNICON",         "@E 999999999",              15, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad3, "TOTAL_03", , "TOTAL ORÇAMENTO",      "@E 999999999",              15, .F./*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	oSectDad3:SetHeaderSection(.T.)
	oSectDad3:SetTotalInLine(.F.)  					//Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha

Return oReport


/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea     := GetArea()
	Local cQryAux   := MntQuery()
	Local oSectDad  := oReport:Section(1)
	Local oSectDad1 := oReport:Section(1):Section(1)
	Local oSectDad2 := oReport:Section(1):Section(1):Section(1)
	Local oSectDad3 := oReport:Section(1):Section(1):Section(1):Section(1)
	Local nAtual    := 0
	Local nTotal    := 0
	Local nX        := 0
	Local nConta    := 0
	Local nTotPP8   := 0
	Local nTotSCK   := 0
	Local aDados[20]
	
	cQryAux   := ChangeQuery(cQryAux)

    if Select("QRY_AUX") > 0
       QRY_AUX->( dbCloseArea() )
    Endif
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "PP7_EMISSA", "D")
	TCSetField("QRY_AUX", "PP8_DAPCLI", "D")
	TCSetField("QRY_AUX", "PP8_DTENG",  "D")

	aFill(aDados,nil)
   	oSectDad:Init()
	
	//Enquanto houver dados
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		nTotPP8   := 0
		nTotSCK   := 0

		//Incrementando a régua
		nAtual++
		oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
		oReport:IncMeter()
        aDados[01] := QRY_AUX->PP7_CODIGO
        aDados[02] := QRY_AUX->PP7_CLIENT
        aDados[03] := QRY_AUX->PP7_LOJA
        aDados[04] := QRY_AUX->A1_NOME
        aDados[05] := QRY_AUX->PP7_EMISSA
        aDados[06] := QRY_AUX->PP7_REPRES
        aDados[07] := QRY_AUX->PP7_PEDIDO
		
		oSectDad:Cell("PP7_01"):SetBlock( {|| aDados[01]} )
		oSectDad:Cell("PP7_02"):SetBlock( {|| aDados[02]} )
		oSectDad:Cell("PP7_03"):SetBlock( {|| aDados[03]} )
		oSectDad:Cell("PP7_04"):SetBlock( {|| aDados[04]} )
		oSectDad:Cell("PP7_05"):SetBlock( {|| aDados[05]} )
		oSectDad:Cell("PP7_06"):SetBlock( {|| aDados[06]} )
		oSectDad:Cell("PP7_07"):SetBlock( {|| aDados[07]} )

		//Imprimindo a linha atual
		oSectDad:PrintLine()
		oSectDad:Finish()
        oReport:SkipLine()

		cCodigo := QRY_AUX->PP7_CODIGO
		While ! QRY_AUX->(Eof()) .and. (QRY_AUX->PP7_CODIGO == cCodigo)
			aFill(aDados,nil)
			oSectDad1:Init()	        
			nTotPP8   += QRY_AUX->PP8_QUANT

			aDados[08] := QRY_AUX->PP8_ITEM
			aDados[09] := QRY_AUX->PP8_PROD
			aDados[10] := QRY_AUX->PP8_DESCR
			aDados[11] := QRY_AUX->PP8_DESENH
			aDados[12] := QRY_AUX->PP8_QUANT
			aDados[13] := QRY_AUX->PP8_DAPCLI
			aDados[14] := QRY_AUX->PP8_DTENG

			oSectDad1:Cell("PP8_01"):SetBlock( {|| aDados[08]} )
			oSectDad1:Cell("PP8_02"):SetBlock( {|| aDados[09]} )
			oSectDad1:Cell("PP8_03"):SetBlock( {|| aDados[10]} )
			oSectDad1:Cell("PP8_04"):SetBlock( {|| aDados[11]} )
			oSectDad1:Cell("PP8_05"):SetBlock( {|| aDados[12]} )
			oSectDad1:Cell("PP8_06"):SetBlock( {|| aDados[13]} )
			oSectDad1:Cell("PP8_07"):SetBlock( {|| aDados[14]} )

			oSectDad1:PrintLine()
			oSectDad1:Finish()

			aFill(aDados,nil)
			oReport:ThinLine()
			//oReport:SkipLine()

			oSectDad2:Init()
			cTMP := QRY_AUX->CJ_NUM
			While ! QRY_AUX->(Eof()) .and. (cTMP == QRY_AUX->CJ_NUM)
				nTotSCK   += QRY_AUX->CK_QTDVEN

				aDados[15] := QRY_AUX->CK_ITEM
				aDados[16] := QRY_AUX->CK_PRODUTO
				aDados[17] := QRY_AUX->CK_UM
				aDados[18] := QRY_AUX->CK_QTDVEN
				aDados[19] := QRY_AUX->CK_LOCAL
				aDados[20] := QRY_AUX->CK_DESCRI

				oSectDad2:Cell("CK_01"):SetBlock( {|| aDados[15]} )
				oSectDad2:Cell("CK_02"):SetBlock( {|| aDados[16]} )
				oSectDad2:Cell("CK_03"):SetBlock( {|| aDados[17]} )
				oSectDad2:Cell("CK_04"):SetBlock( {|| aDados[18]} )
				oSectDad2:Cell("CK_05"):SetBlock( {|| aDados[19]} )
				oSectDad2:Cell("CK_06"):SetBlock( {|| aDados[20]} )

				oSectDad2:PrintLine()
				aFill(aDados,nil)
				QRY_AUX->( dbSkip() )
			EndDo
			oSectDad2:PrintLine()
			oSectDad2:Finish()
			oReport:SkipLine()
		EndDo
		aFill(aDados,nil)
		oReport:ThinLine()
		oSectDad3:Init()
		oSectDad3:Cell("TOTAL_01"):SetBlock( {|| cCodigo} )
		oSectDad3:Cell("TOTAL_02"):SetBlock( {|| nTotPP8} )
		oSectDad3:Cell("TOTAL_03"):SetBlock( {|| nTotSCK} )
		oSectDad3:PrintLine()
		oSectDad3:Finish()
		oReport:ThinLine()
		
		oSectDad:PrintLine()
	    oSectDad:Finish()
	   	oSectDad:Init()
		oReport:SkipLine()
		oReport:SkipLine()
		oReport:SkipLine()
		oReport:SkipLine()
        oReport:SkipLine()
		oReport:ThinLine()

	EndDo

    oSectDad1:Finish()
    oSectDad:Finish()

	QRY_AUX->(DbCloseArea())
	
	RestArea(aArea)
Return



/*/{Protheus.doc} MntQuery
    (long_description)
    Montagem de Filtro
    @author user
    Valdemir Rabelo
    @since date
    26/02/2020
    /*/
Static Function MntQuery()
    Local cRET    := ""
    Local cCampos := ""

    cCampos += "PP7_CODIGO, PP7_CLIENT, PP7_LOJA, A1_NOME, PP7_EMISSA, PP7_REPRES, PP7_PEDIDO, " + CRLF 
    cCampos += "PP8_CODIGO,PP8_ITEM, PP8_PROD, PP8_DESCR,PP8_DESENH, PP8_QUANT, PP8_DAPCLI, PP8_DTENG," + CRLF 
    cCampos += "CJ_XUNICOM, CJ_NUM, B.R_E_C_N_O_ REGSCJ, CK_ITEM, CK_PRODUTO, CK_DESCRI, CK_QTDVEN, CK_UM, CK_LOCAL " + CRLF 

    cRET += "SELECT " +cCampos+ " FROM " + RETSQLNAME("PP8") + " A " + CRLF
    cRET += "INNER JOIN " + RETSQLNAME("PP7") + " P7 " + CRLF
    cRET += "ON P7.PP7_FILIAL=A.PP8_FILIAL AND P7.PP7_CODIGO=A.PP8_CODIGO AND P7.D_E_L_E_T_ =  ' ' " + CRLF
    cRET += "INNER JOIN  " + RETSQLNAME("SCJ") + " B " + CRLF
    cRET += "ON B.CJ_FILIAL=A.PP8_FILIAL AND B.CJ_XUNICOM = concat(A.PP8_CODIGO,A.PP8_ITEM) AND B.D_E_L_E_T_ =  ' ' " + CRLF
    cRET += "LEFT OUTER JOIN  " + RETSQLNAME("SCK") + " C " + CRLF
    cRET += "ON C.CK_FILIAL=B.CJ_FILIAL AND C.CK_NUM=B.CJ_NUM  AND C.D_E_L_E_T_ =  ' ' " + CRLF
    cRET += "INNER JOIN " + RETSQLNAME("SB1") + " B1 " + CRLF
    cRET += "ON B1.B1_COD=C.CK_PRODUTO AND B1.D_E_L_E_T_ =  ' '	 " + CRLF
    cRET += "INNER JOIN " + RETSQLNAME("SA1") + " A1 " + CRLF
    cRET += "ON A1_COD = P7.PP7_CLIENT AND A1_LOJA=PP7_LOJA AND A1.D_E_L_E_T_ =  ' ' " + CRLF
    cRET += "WHERE A.D_E_L_E_T_ =  ' ' " + CRLF
    cRET += " AND (C.CK_PRODUTO LIKE 'SDZD%' " + CRLF
	cRET += "  OR C.CK_PRODUTO LIKE 'SDA%') " + CRLF			// Adicionado 02/03/2020 - Valdemir Rabelo
    cRET += " AND A.PP8_PEDVEN <> ' ' " + CRLF
    cRET += " AND P7.PP7_STATUS IN('2','8') " + CRLF
    cRET += " AND A.PP8_DTSDAP = ' ' " + CRLF
	cRET += " AND B1.B1_GRUPO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " + CRLF
    cRET += " AND P7.PP7_EMISSA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
    IF !EMPTY(MV_PAR03)
        cRET += " AND P7.PP7_CLIENT = '"+MV_PAR03+"' " + CRLF
    Endif
    IF !EMPTY(MV_PAR04)
        cRET += " AND P7.PP7_LOJA = '"+MV_PAR04+"' " + CRLF
    Endif
    IF !EMPTY(MV_PAR05)
        cRET += " AND P7.PP7_PEDIDO = '"+MV_PAR05+"' " + CRLF
    Endif
    IF !EMPTY(MV_PAR06)
        cRET += " AND P7.PP7_CODIGO = '"+MV_PAR06+"' " + CRLF
    Endif

Return cRET


Static Function CriaSX1()
	Local cAlias    := Alias()
	Local aRegistros:={}
	Local i         :=0
    Local lCria     := .F.

	_cDtIni :=   ctod("01/"+ substr(dtoc(ddatabase),4) )
	_cDtFim := _cDtIni + 364
/* Removido - 18/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
    //Grupo/Ordem/Titulo/Conteudo/PRESEL/Tipo/Tamanho/F3
	aadd(aRegistros,{Padr(cPerg,Len(SX1->X1_GRUPO),""), "01", "Emissão",     dtos(_cDtini),"" ,"D",8,"","G"})
	aadd(aRegistros,{Padr(cPerg,Len(SX1->X1_GRUPO),""), "02", "Emissão",     dtos(_cDtFim),"" ,"D",8,"","G"})
	aadd(aRegistros,{Padr(cPerg,Len(SX1->X1_GRUPO),""), "03", "Cliente",     space(6)     ,"" ,"C",6,"SA1","G"})
	aadd(aRegistros,{Padr(cPerg,Len(SX1->X1_GRUPO),""), "04", "Loja",        Space(2)     ,"" ,"C",2,"","G"})
	aadd(aRegistros,{Padr(cPerg,Len(SX1->X1_GRUPO),""), "05", "Pedido",      space(6)     ,"" ,"C",6,"","G"})
	aadd(aRegistros,{Padr(cPerg,Len(SX1->X1_GRUPO),""), "06", "Atendimento", Space(6)     ,"" ,"C",6,"","G"})
	aadd(aRegistros,{Padr(cPerg,Len(SX1->X1_GRUPO),""), "07", "Grupo",       space(4)     ,"" ,"C",4,"SBM","G"})
	aadd(aRegistros,{Padr(cPerg,Len(SX1->X1_GRUPO),""), "08", "Grupo",       "ZZZZ"       ,"" ,"C",4,"SBM","G"})

	DbSelectArea("SX1")
	SX1->(DbSetOrder(1))
	For i:=1 to Len(aRegistros)
		lCria := (!dbSeek(aRegistros[i,1]+aRegistros[i,2]) )
		RecLock("SX1",lCria)
        if lCria
           SX1->X1_GRUPO := aRegistros[i,1]
           SX1->X1_ORDEM := aRegistros[i,2]
        Endif
        SX1->X1_PERGUNT := aRegistros[i,3]
        SX1->X1_PERSPA  := aRegistros[i,3]
        SX1->X1_PERENG  := aRegistros[i,3]
        SX1->X1_CNT01   := aRegistros[i,4]
        IF !EMPTY( aRegistros[i,5])
            SX1->X1_PRESEL :=  aRegistros[i,5]
        Endif
        SX1->X1_TIPO    := aRegistros[i,6]
        SX1->X1_TAMANHO := aRegistros[i,7]
        SX1->X1_F3      := aRegistros[i,8]
        SX1->X1_GSC     := aRegistros[i,9]
        SX1->X1_VARIAVL := "MV_CH"+cValToChar(i)
        SX1->X1_VAR01   := "MV_PAR"+StrZero(i,2)
        MsUnlock()
	Next I
	dbSelectArea(cAlias)*/

Return
