//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
	
/*/{Protheus.doc} STRELSC
Relatório - Relatorio Solicitação de Compras                    
@author Valdemir Rabelo
@since 18/03/20
@version 1.0
	@example
/*/
	
User Function STRSC001()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	Private dEmissa1 := nil
	Private dEmissa2 := nil
	Private cMotivo1 := nil
	Private cMotivo2 := nil
	Private cReferen := nil
	Private nProduto := nil
	Private cFilial1 := nil
	Private cFilial2 := nil
	

	//Definições da perguntawin
	cPerg := "STRELATSC1"

	if !AjustaSX1(cPerg)
       Return
    else 
		dEmissa1 := MV_PAR01
		dEmissa2 := MV_PAR02
		cMotivo1 := MV_PAR03
		cMotivo2 := MV_PAR04
		cReferen := MV_PAR05
		nProduto := MV_PAR06
		cFilial1 := MV_PAR07
		cFilial2 := MV_PAR08
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
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Função que monta a definição do relatório                              |
 *-------------------------------------------------------------------------------*/	
Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	Local oFunTot1 := Nil
	
	//Criação do componente de impressão
	oReport := TReport():New(	"STRELSC001",;		//Nome do Relatório
								"Relatorio SC por Motivo de Compra",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape()
	
	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Dados",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad, "C1_NUM",    "QRY_AUX", "Numero da SC",  /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C1_PRODUTO","QRY_AUX", "Produto",       /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "B1_DESC",   "QRY_AUX", "Descricao",     /*Picture*/, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C1_QUANT",  "QRY_AUX", "Quantidade",    "@E 99999999"/*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C1_MOTIVO", "QRY_AUX", "Mot. Compra",   /*Picture*/,  3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UNIT",      "QRY_AUX", "Unit",          "@E 999,999,999.99"/*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TOTAL",     "QRY_AUX", "Total",         "@E 999,999,999,999.99"/*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "REFERENCIA","QRY_AUX", "Referencia",    /*Picture*/,  10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRCORC",    "QRY_AUX", "Preço Orç",      "@E 999,999,999,999.99"/*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DTVLORC",   "QRY_AUX", "Valid.Orç",      "@D 99/99/9999" /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
	//Definindo a quebra
	oBreak := TRBreak():New(oSectDad,{|| QRY_AUX->(REFERENCIA) },{|| "Sub Total" })
	oSectDad:SetHeaderBreak(.T.)
	
	//Totalizadores
	oFunTot1 := TRFunction():New(oSectDad:Cell("TOTAL"),,"SUM",oBreak,,"@E 999,999,999.99")
	oFunTot1:SetEndReport(.F.)

Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT"		+ CRLF
	cQryAux += "    C1_NUM, C1_PRODUTO, B1_DESC, C1_QUANT, C1_MOTIVO, B1_UPRC UNIT, (C1_QUANT * B1_UPRC) TOTAL,"		+ CRLF
	cQryAux += "    'REF.MES "+cReferen+"' AS REFERENCIA, C1_XPRCORC PRCORC, C1_XDTVORC DTVLORC " + CRLF
	cQryAux += "FROM " + RETSQLNAME("SC1") + " A             " + CRLF
	cQryAux += "INNER JOIN " + RETSQLNAME("SB1") + " B     " + CRLF
	cQryAux += "ON B1_COD=C1_PRODUTO AND B.D_E_L_E_T_ = ' '" + CRLF
	cQryAux += "WHERE A.D_E_L_E_T_ = ' '"		+ CRLF
	cQryAux += " AND C1_EMISSAO BETWEEN '"+dtos(dEmissa1)+"' AND '"+dtos(dEmissa2)+"'"		+ CRLF
	cQryAux += " AND C1_MOTIVO BETWEEN '"+cMotivo1+"' AND '"+cMotivo2+"'"		+ CRLF
	cQryAux += " AND C1_FILIAL BETWEEN '"+cFilial1+"' AND '"+cFilial2+"'"		+ CRLF
	if     (nProduto==2)
	    cQryAux += " AND C1_XPRCORC > 0 " + CRLF
	elseif (nProduto==3)
	    cQryAux += " AND C1_XPRCORC = 0 " + CRLF
	endif
	cQryAux += "ORDER BY C1_FILIAL,C1_NUM, C1_PRODUTO" + CRLF
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"

	TCSetField("QRY_AUX","PRCORC","N",15,2)
	TCSetField("QRY_AUX","DTVLORC","D",8)

	Count to nTotal
	oReport:SetMeter(nTotal)
	
	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a régua
		nAtual++
		oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
		oReport:IncMeter()
		
		//Imprimindo a linha atual
		oSectDad:PrintLine()
		
		QRY_AUX->(DbSkip())
	EndDo
	oSectDad:Finish()
	QRY_AUX->(DbCloseArea())
	
	RestArea(aArea)
Return


/*/{Protheus.doc} STRELSC
Rotina para geração dos parâmetros
@author Valdemir Rabelo
@since 18/03/20
@version 1.0
	@example
/*/
Static Function AjustaSX1(cPerg)
    Local cAllPer  := ""
    Local aHelp    := {}
    Local oParamet := nil

    cAllPerg := '{"AllPerg": [ '
    cAllPerg += '               {"X1_PERGUNT": "Emissão  de",    "X1_TIPO": "D", "X1_TAMANHO": 8, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "G", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "",     "X1_PYME": "S"}, '
    cAllPerg += '               {"X1_PERGUNT": "Emissão até",    "X1_TIPO": "D", "X1_TAMANHO": 8, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "G", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "",     "X1_PYME": "S"}, '
    cAllPerg += '               {"X1_PERGUNT": "Motivo  de ",    "X1_TIPO": "C", "X1_TAMANHO": 3, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "G", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "SZ1",  "X1_PYME": "S"}, '
    cAllPerg += '               {"X1_PERGUNT": "Motivo até ",    "X1_TIPO": "C", "X1_TAMANHO": 3, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "G", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "SZ1",  "X1_PYME": "S"}, '
    cAllPerg += '               {"X1_PERGUNT": "Referência ",    "X1_TIPO": "C", "X1_TAMANHO": 7, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "G", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "",     "X1_PYME": "S"}, '
    cAllPerg += '				{"X1_PERGUNT": "Produtos   ", 	 "X1_TIPO": "N", "X1_TAMANHO": 1, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "C", "X1_VALID": "", "X1_DEF01": "Todos", "X1_DEF02": "Orçado", "X1_DEF03": "Não Orçado", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": "S"},  '
    cAllPerg += '               {"X1_PERGUNT": "Filial  De ",    "X1_TIPO": "C", "X1_TAMANHO": 2, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "G", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "",     "X1_PYME": "S"}, '
    cAllPerg += '               {"X1_PERGUNT": "Filial Até ",    "X1_TIPO": "C", "X1_TAMANHO": 2, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "G", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "",     "X1_PYME": "S"}  '
    cAllPerg += '] }    '

    aAdd(aHelp, "Informe a emissão inicial")
    aAdd(aHelp, "Informe a emissão final")
    aAdd(aHelp, "Informe o motivo inicial")
    aAdd(aHelp, "Informe o motivo final")
    aAdd(aHelp, "Informe a referência")
    aAdd(aHelp, "Informe opção para Produto 1-Todos 2=Orçado 3-Não orçado")
    aAdd(aHelp, "Informe a Filial Inicial")
    aAdd(aHelp, "Informe a Filial Final")

    oParamet := EVParame():New(cPerg, cAllPerg, aHelp)
    if !oParamet:Activate(.T.)      // Parâmetro Activate .T. = Abre tela de parametro, .F. = Carrega em memoria sem abrir a tela
       oParamet:Dispose()           // Removendo da Memoria o objeto
	   Return .F.
	Endif
    oParamet:Dispose()   

    U_EVPUTSX1(cPerg, "Emissao de", "D", ) //StaticCall (STFSLIB, EVPUTSX1, cPerg, "Emissao de", "D", )

Return .T.

