#Include "Protheus.ch"
#Include "Topconn.ch"
#INCLUDE "REPORT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STDCR05   ºAutor  ³ Cristiano Pereira  º Data ³  19/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     |Analise de reducao de Imposto de importacao                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STDCR05()
	
	Private _cArqTmp	:= ""
	Private _cIndTmp	:= ""
	Private Amtr		:= {}
	Private mvpar		:= ""
	
	Private lValPai	:= GetNewPar("MV_DCRE12",.F.)
	Private lReg3 := GetNewPar("MV_DCRE01",.F.)
	Private lImpr := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validacao do Produto/Estrutura                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private bValid := {||.T.}
	
	If MsgYesNo("Novo DCRE?")
		u_RSTFATAS()
	EndIf
	
	
	fRelDCR()
	
	If	Select( "QRY2" ) > 0
		QRY2->( dbCloseArea() )
	EndIf
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRelDCR() ºAutor  ³ Cristiano Pereira  º Data ³  19/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao da chamada do relatorio.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso                                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fRelDCR()
	
	Local oReport
	
	
	Private cFOpen	:= ""
	
	oReport:= ReportDef()
	oReport:PrintDialog()
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³Cristiano Pereira   º Data ³  19/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³A funcao estatica ReportDef devera ser criada para todos os º±±
±±º          ³relatorios que poderao ser agendados pelo usuario.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()
	
	Local cTitle
	Local cAliasCmp	:= GetNextAlias()
	Local aOrdem		:= {}
	Local oBreak
	Private oReport
	Private oSection1
	Private oSection2
	
	
	Private cPerg	:= "STDCR05"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ajusta perguntas do relatorio³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	fCriaSx1()
	aResul	:= {}
	nCont	:= 0
	
	pergunte(cPerg,.T.)
	
	
	cTitle		:= "ANÁLISE DE REDUÇÕES DE IMPOSTOS II - REF:"+DTOC(MV_PAR03)+" A "+DTOC(MV_PAR04)
	oReport:= TReport():New("STDCR05",cTitle,cPerg, {|oReport| ReportPrtG(oReport,aOrdem,"SB1",mvpar)},"Este programa tem como objetivo imprimir ANALISE DAS REDUÇÕES DE IMPOSTOS V. II")
	oReport:SetLandscape()
	
	
	oSection1 := TRSection():New(oReport,"PRODUTOS ACABADO",{"QRY2"},aOrdem)
	oSection1:SetLineStyle()
	
	oSection1:SetNoFilter("QRY2")
	
	TRCell():New(oSection1,"PRODUTO"			,"","PRODUTO"		,PesqPict("B1","B1_COD")	,TamSX3("B1_COD")[1]+1)
	TRCell():New(oSection1,"DESCRIÇÃO"			,"","DESCRIÇÃO"		,PesqPict("B1","B1_DESC")	,TamSX3("B1_DESC")[1]+1)
	TRCell():New(oSection1,"PROTOCOLO"			,"","PROTOCOLO"			,PesqPict("SB1","B1_DCRE")	,30)
	
	
	oSection2 := TRSection():New(oSection1,"COMPONENTES",{"QRY2"},aOrdem)
	
	
	TRCell():New(oSection2,"COMPONENTE"			,"","COMPONENTE"		,PesqPict("B1","B1_COD")	,TamSX3("B1_COD")[1]+1)
	TRCell():New(oSection2,"DESCRIÇÃO"			,"","DESCRIÇÃO"		   ,PesqPict("B1","B1_DESC")	,TamSX3("B1_DESC")[1]+1)
	TRCell():New(oSection2,"ORIGEM"			,"","ORIGEM"		   ,"@!"	,30)
	//TRCell():New(oSection2,"COEFICIENTE"			,"","COEFICIENTE"		,PesqPict("SB1","B1_COEFDCR")		,TamSX3("B1_COEFDCR")[1]+1)
	//TRCell():New(oSection2,"VALOR_II"			,"","VALOR_II"			,PesqPict("SB1","B1_DCRII")		,TamSX3("B1_DCRII")[1]+1)
	TRCell():New(oSection2,"DOC"			,"","NOTA FISCAL"		   ,PesqPict("SD1","D1_DOC")	,TamSX3("D1_DOC")[1]+1)
	TRCell():New(oSection2,"FORNECE"			,"","FORNECEDOR"		   ,PesqPict("SD1","D1_FORNECE")	,TamSX3("D1_FORNECE")[1]+1)
	TRCell():New(oSection2,"NOME"			,"","N. FORNECEDOR"		   ,PesqPict("SA2","A2_NOME")	,TamSX3("A2_NOME")[1]+1)
	TRCell():New(oSection2,"DTDIGITACAO"			,"","DT DIGITACAO"		   ,""	,TamSX3("D1_DTDIGIT")[1]+1)
	
	
	
	
	
	
	
	
	oSection2:SetHeaderPage()
	oSection2:SetNoFilter("SB1")
	
	
	//oBreak := TRBreak():New(oSection1,{|| QRY2->COD },"Total ", .F.)
	
	//TRFunction():New(oSection1:Cell("VALOR_II")				,NIL,"SUM"		,oBreak, , , , .F., .T.)
	
	
Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ReportPrtGº Autor ³ Cristiano Pereira  º Data ³  19/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Função com o objetivo de criar a tabela temporária e preen-º±±
±±º          ³ cher o relatório conforme estrutura Geral.				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrtG(oReport,aOrdem,cAliasCmp,mvpar)
	
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)
	Local _cQuery	:= ""
	Local _cTemp	:= "QRY2"
	Local _nReg	:= 0
	Local _cDb		:= TcGetDb()
	Local nTotReg 	:= 0
	Local _aRetEic  := {}
	Local linha := 0
	//Local bQuery  := {|| Iif(Select(_cTemp) > 0, (_cTemp)->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),_cTemp,.F.,.T.) , dbSelectArea(_cTemp), (_cTemp)->(dbGoTop()), (_cTemp)->(dbEval({|| nTotReg++ })) , (_cTemp)->(dbGoTop()) }
	//Local bQuery  := {|| Iif(Select(_cTemp) > 0, (_cTemp)->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),_cTemp,.F.,.T.) , dbSelectArea(_cTemp), (_cTemp)->(dbGoTop()), (_cTemp)->(dbEval({|| nTotReg++ })) , (_cTemp)->(dbGoTop()) }
	
	
	If Select("QRY2")  > 0
		DbSelectArea("QRY2")
		DbCloseArea()
	Endif
	
	
	_cQuery   := "  SELECT SB1.B1_COD AS COD,   "
	_cQuery   += "         SB1.B1_DESC AS DESCRR, "
	_cQuery   += "         SB1.B1_DCRE AS DCRE, "
	_cQuery   += "         SB1.B1_COEFDCR AS COEF, "
	_cQuery   += "         SB1.B1_DCRII  AS DCRII "
	_cQuery   += "  FROM "+RetSqlName("SB1")+" SB1 "
	_cQuery   += "  WHERE SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
	_cQuery   += "        SB1.D_E_L_E_T_ <> '*'                AND "
	//_cQuery   += "        SB1.B1_COD = 'S4206'                 AND "
	_cQuery   += "        SB1.B1_COD >= '"+MV_PAR01+"'   AND "
	_cQuery   += "        SB1.B1_COD <= '"+MV_PAR02+"'       AND EXISTS (SELECT * FROM  "+RetSqlName("SG1")+" SG1  WHERE SG1.D_E_L_E_T_ = ' ' AND G1_COD = B1_COD) "
	_cQuery   += "  ORDER BY SB1.B1_COD "
	
	
	
	TCQUERY _cQuery NEW ALIAS "QRY2"
	
	
	_nReg := 0
	DbEval({|| _nReg++  })
	
	
	oReport:SetMeter(_nReg)
	
	//%Processamento
	oReport:SetTitle(oReport:Title())
	
	
	DbSelectArea((_cTemp))
	(_cTemp)->(dbGoTop())
	
	While !oReport:Cancel() .And. !((_cTemp)->(EOF()))
		
		oReport:IncMeter()
		
		
		//#######################################################
		//Verifica se o Item possui Item Importado na estrutura #
		//#######################################################
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+(_cTemp)->COD) .And. !Empty(SB1->B1_ALTER)
			_aRetEic := 	STDCR05A(SB1->B1_ALTER)
		Else
			_aRetEic :=	STDCR05A((_cTemp)->COD)
		Endif
		
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+(_cTemp)->COD)
		
		
		
		If len(_aRetEic) > 0
			oSection1:Init(.F.)
			oReport:SkipLine()
			
			oSection1:Cell("PRODUTO"		):SetValue(SB1->B1_TIPO+" - "+(_cTemp)->COD)
			oSection1:Cell("DESCRIÇÃO"		):SetValue((_cTemp)->DESCRR)
			oSection1:Cell("PROTOCOLO"		):SetValue((_cTemp)->DCRE)
			
			
			oSection1:PrintLine()
			oReport:SkipLine()
			oSection1:Finish()
			
			
			oSection2:Init()
			
			
			For linha := 1 to len(_aRetEic)
				
				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1")+_aRetEic[linha,5])
				
				
				oSection2:Cell("COMPONENTE"):SetValue(SB1->B1_TIPO+" - "+_aRetEic[linha,5])
				oSection2:Cell("DESCRIÇÃO"		):SetValue(SB1->B1_DESC)
				
				DbSelectArea("SX5")
				DbSetOrder(1)
				DbSeek(xFilial("SX5") + "S0" + SB1->B1_ORIGEM)
				
				oSection2:Cell("ORIGEM"		):SetValue(SX5->X5_DESCRI)
				//oSection1:Cell("COEFICIENTE"		):SetValue((_cTemp)->COEF)
				//oSection1:Cell("VALOR_II"		):SetValue((_cTemp)->DCRII)
				
				oSection2:Cell("DOC"		):SetValue(_aRetEic[linha,1])
				oSection2:Cell("FORNECE"	):SetValue(_aRetEic[linha,2]+" "+_aRetEic[linha,3])
				oSection2:Cell("DTDIGITACAO"	):SetValue(  DTOC(stod(_aRetEic[linha,6]))  )
				DbSelectArea("SA2")
				DbSetOrder(1)
				DbSeek(xFilial("SA2")+_aRetEic[linha,2]+_aRetEic[linha,3])
				
				oSection2:Cell("NOME"		):SetValue(SA2->A2_NOME)
				
				oSection2:PrintLine()
				
			Next linha
			
			
			oSection2:Finish()
			oReport:ThinLine() //-- Impressao de Linha Simples
			
			
		Endif
		//Inicializa Retorno
		_aRetEic  := {}
		
		(_cTemp)->(dbSkip())
	Enddo
	
	
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCriaSx1  ºAutor  ³Yuri F. Palacio     º Data ³  11/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Criacao de perguntas do relatorio.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ NCGAMES                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCriaSx1()
	PutSX1(cPerg,"01","Produto De?     "   	,"Produto De?  "	,"Produto De?  "		,"mv_ch1","C",15,0,1,"G","SB1",""		,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSX1(cPerg,"02","Produto Ate?     "   ,"Produto Ate? "	,"Produto Ate?"		,"mv_ch2","C",15,0,1,"G","SB1",""		,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSX1(cPerg,"03","Data De?     "   	,"Data De?  "	,"Data De?  "		,"mv_ch3","D",8,0,1,"G","",""		,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSX1(cPerg,"04","Data Até?     "   	,"Data Até?  "	,"Data Até?  "		,"mv_ch4","D",8,0,1,"G","",""		,"","","mv_par04","","","","","","","","","","","","","","","","")
	
	
return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STDCR05A  ºAutor  ³Cristiano Pereira   º Data ³  09-28-14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Explosão da Estrutura                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function STDCR05A(cProduto)
	
	Local _nLin
	Local nNivel  := 2
	Private _aEstrut   := {}  //Array com os dados da Estrutura
	Private _aEstrut2  := {}  //Array com a explosão da estrutura
	Private _cQrySD1   := ""
	Private _aItEIC    := {}
	
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+cProduto)
		
		
		DbSelectArea("SG1")
		DbSetOrder(1)
		If dbSeek(xFilial("SG1")+cProduto)
			
			_aEstrut := GeraExpl(cProduto,If(SB1->B1_QB == 0,1,SB1->B1_QB),nNivel,SB1->B1_OPC,SG1->G1_QUANT)
			_aEstrut:=asort(_aEstrut,,,{|x,y| x[2] < y[2] })
			For _nLin := 1 to len(_aEstrut)
				
				//######################################
				//Processa Notas de Importação         #
				//######################################
				If Select("TSD1") > 0
					DbSelectArea("TSD1")
					DbCloseArea()
				Endif
				_cQrySD1  := " SELECT SD1.D1_DOC AS DOC,SD1.D1_FORNECE AS FORNECE, SD1.D1_LOJA AS LOJA,SD1.D1_SERIE AS SERIE,SD1.D1_COD AS COD,SD1.D1_DTDIGIT AS DIGIT "
				_cQrySD1  += " FROM "+RetSqlName("SD1")+" SD1 "
				_cQrySD1  += " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"'    AND "
				_cQrySD1  += "       SD1.D_E_L_E_T_ <> '*'                  AND "
				_cQrySD1  += "       SD1.D1_DTDIGIT >= '"+Dtos(MV_PAR03)+"' AND "
				_cQrySD1  += "       SD1.D1_DTDIGIT <= '"+Dtos(MV_PAR04)+"' AND "
				_cQrySD1  += "       ( SUBSTR(SD1.D1_CF,1,1) = '3'  OR SD1.D1_TIPO_NF  IN ('1','3') ) AND "
				_cQrySD1  += "       SD1.D1_COD = '"+_aEstrut[_nlin][3]+"' AND SD1.D1_TIPO NOT IN ('D','C') "
				
				TCQUERY _cQrySD1 NEW ALIAS "TSD1"
				
				TCSETFIELD("TSD1","D1_DTDIGIT","D",8,0)
				
				_nRec := 0
				DbEval({|| _nRec++  })
				
				DbSelectArea("TSD1")
				DbGotop()
				While !TSD1->(EOF())
					AADD(_aItEIC,{TSD1->DOC,TSD1->FORNECE,TSD1->LOJA,TSD1->SERIE,TSD1->COD,TSD1->DIGIT})
					DbSelectArea("TSD1")
					DbSkip()
				Enddo
			Next _nLin
		Endif
	Endif
	
return(_aItEIC)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraExpl  ºAutor  ³Cristiano Pereira   º Data ³  24/07/08  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera Explosão da Estrutura conforme parâmetro inoformado    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC lRet:= .t.
Static Function GeraExpl(cProduto,nQuantPai,nNivel,cOpcionais,nQtdBase)
	
	local nReg,nQuantItem := 0
	local nPrintNivel := " "
	Local aObserv   := {}
	local nx := 0
	local linha := 0
	Local aAreaSB1:={}
	Private lNegEstr := GETMV("MV_NEGESTR")
	Private _nNecess := 0
	
	DbSelectArea("SG1")
	While !Eof() .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+cProduto
		
		nReg    := Recno()
		nQuantItem := ExplEstr(nQuantPai,,)
		DbSelectArea("SG1")
		If lNegEstr .Or. (!lNegEstr) .and. SG1->G1_FIM >= DDATABASE .And. SG1->G1_INI <= DDATABASE //.And. nQuantItem > 0 )
			
			//-- Divide a Observa‡„o em Sub-Arrays com 45 posi‡”es
			aObserv := {}
			For nX := 1 to MlCount(AllTrim(G1_OBSERV),45)
				aAdd(aObserv, MemoLine(AllTrim(G1_OBSERV),45,nX))
			Next nX
			
			//nPrintNivel:=IIF(nNivel>17,17,nNivel-2)
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xfilial("SB1")+SG1->G1_COMP)
			
			
			If lRet
				If (nNivel-1) == 1
					_aQtd := {}
					
					If SG1->G1_PERDA > 0
						_nNecess := ROUND((SG1->G1_QUANT * 1)*(SG1->G1_PERDA/100)+(SG1->G1_QUANT * 1),9)
						AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,_nNecess,SG1->G1_PERDA,.f.})
						AADD(_aQtd,{cProduto,SG1->G1_COMP,_nNecess,nNivel,.f.})
					Else
						_nNecess := SG1->G1_QUANT
						AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,_nNecess,SG1->G1_PERDA,.f.})
						AADD(_aQtd,{cProduto,SG1->G1_COMP,_nNecess,nNivel,.f.})
					Endif
				Else
					If SG1->G1_PERDA > 0
						
						_nQuant := 0
						lVer := .f.
						for linha := 1 to len(_aQtd)
							If cProduto == _aQtd[linha,2] .and. nNivel-1 <> 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif
							ElseIf cProduto == _aQtd[linha,2] .and. nNivel-1 == 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif
								
							Endif
						Next linha
						If !lVer .AND. _nQuant > 0
							AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,(_nQuant*SG1->G1_QUANT)*(SG1->G1_PERDA/100)+(_nQuant*SG1->G1_QUANT) ,SG1->G1_PERDA,.f.})
							AADD(_aQtd,{cProduto,SG1->G1_COMP,(_nQuant*SG1->G1_QUANT)*(SG1->G1_PERDA/100)+(_nQuant*SG1->G1_QUANT),nNivel,.f.})
						Else
							//AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,ROUND(nQtdBase*(SG1->G1_PERDA/100)+nQtdBase,9) ,SG1->G1_PERDA,.f.})
							AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,ROUND(nQtdBase*(SG1->G1_QUANT+(SG1->G1_QUANT*((SG1->G1_PERDA/(100-SG1->G1_PERDA))))),9) ,SG1->G1_PERDA,.f.})
							AADD(_aQtd,{cProduto,SG1->G1_COMP,ROUND(nQtdBase*(SG1->G1_PERDA/100)+nQtdBase,9),nNivel,.f.})
						Endif
					Else
						_nQuant := 0
						lVer := .f.
						for linha := 1 to len(_aQtd)
							If cProduto == _aQtd[linha,2] .and. nNivel-1 <> 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif
							ElseIf cProduto == _aQtd[linha,2] .and. nNivel-1 == 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif
								
							Endif
						Next linha
						If !lVer .AND. _nQuant > 0
							AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,_nQuant*SG1->G1_QUANT,SG1->G1_PERDA,.f.})
							AADD(_aQtd,{cProduto,SG1->G1_COMP,_nQuant*SG1->G1_QUANT,nNivel,.f.})
						Else
							//##########################################################
							//Manutencao : Quantidade da Mao de obra gerando errado    #
							//28/05/2010                                               #
							//##########################################################
							If SubStr(SG1->G1_COMP,1,3) <> "MOD"
								AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,nQuantItem,SG1->G1_PERDA,.f.}) //nQtdBase Cristiano 27/11/2009
							Else
								AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,SG1->G1_QUANT,SG1->G1_PERDA,.f.}) //Cristiano 27/11/2009
							Endif
							//AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,SG1->G1_QUANT,SG1->G1_PERDA,.f.})
							//Alterado devido a diferenca no calculo da quant. necessaria que esta calculando errado.
							AADD(_aQtd,{cProduto,SG1->G1_COMP,nQuantItem,nNivel,.f.})
							
						Endif
					Endif
				Endif
			Else
				
				If (nNivel-1) == 1
					_aQtd := {}
					If SG1->G1_PERDA > 0
						_nNecess := ROUND((SG1->G1_QUANT * 1)*(SG1->G1_PERDA/100)+(SG1->G1_QUANT * 1),9)
						AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,_nNecess,SG1->G1_PERDA,.f.})
						AADD(_aQtd,{cProduto,SG1->G1_COMP,_nNecess,nNivel,.f.})
					Else
						_nNecess := SG1->G1_QUANT
						AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,_nNecess,SG1->G1_PERDA,.f.})
						AADD(_aQtd,{cProduto,SG1->G1_COMP,_nNecess,nNivel,.f.})
					Endif
				Else
					If SG1->G1_PERDA > 0
						
						_nQuant := 0
						lVer := .f.
						for linha := 1 to len(_aQtd)
							If cProduto == _aQtd[linha,2] .and. nNivel-1 <> 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif
							ElseIf cProduto == _aQtd[linha,2] .and. nNivel-1 == 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif
								
							Endif
						Next linha
						
						If !lVer .AND. _nQuant > 0
							AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,ROUND((_nQuant*SG1->G1_QUANT)*(SG1->G1_PERDA/100)+(_nQuant*SG1->G1_QUANT),9) ,SG1->G1_PERDA,.f.})
							AADD(_aQtd,{cProduto,SG1->G1_COMP,ROUND((nQtdBase*SG1->G1_QUANT)*(SG1->G1_PERDA/100)+(_nQuant*SG1->G1_QUANT),9),nNivel,.f.})
						Else
							AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,ROUND((nQtdBase*SG1->G1_QUANT)*(SG1->G1_PERDA/100)+(nQtdBase*SG1->G1_QUANT),9) ,SG1->G1_PERDA,.f.})
							AADD(_aQtd,{cProduto,SG1->G1_COMP,ROUND((nQtdBase*SG1->G1_QUANT)*(SG1->G1_PERDA/100)+(nQtdBase*SG1->G1_QUANT),9),nNivel,.f.})
							
						Endif
					Else
						
						_nQuant := 0
						lVer := .f.
						for linha := 1 to len(_aQtd)
							If cProduto == _aQtd[linha,2] .and. nNivel-1 <> 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif
							ElseIf cProduto == _aQtd[linha,2] .and. nNivel-1 == 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif
								
							Endif
						Next linha
						
						
						If !lVer .AND. _nQuant > 0
							AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,_nQuant*SG1->G1_QUANT,SG1->G1_PERDA,.f.})
							AADD(_aQtd,{cProduto,SG1->G1_COMP,_nQuant*SG1->G1_QUANT,nNivel,.f.})
						Else
							AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,nQtdBase*SG1->G1_QUANT,SG1->G1_PERDA,.f.})
							AADD(_aQtd,{cProduto,SG1->G1_COMP,nQtdBase*SG1->G1_QUANT,nNivel,.f.})
							
						Endif
					Endif
					
				Endif
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe sub-estrutura                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SG1")
			DbSeek(xFilial("SG1")+SG1->G1_COMP)
			If Found()
				lRet := .t.
				If (nNivel-1) == 1
					GeraExpl(SG1->G1_COD,nQuantItem,nNivel+1,cOpcionais,ROUND(SG1->G1_QUANT*_nNecess,9),SG1->G1_PERDA)
				Else
					GeraExpl(SG1->G1_COD,nQuantItem,nNivel+1,cOpcionais,ROUND(SG1->G1_QUANT*nQtdBase,9),SG1->G1_PERDA)
				Endif
			Else
				lRet := .f.
			EndIf
			DbGoto(nReg)
		EndIf
		DbSkip()
		
	End
	
	
Return(_aEstrut2)

