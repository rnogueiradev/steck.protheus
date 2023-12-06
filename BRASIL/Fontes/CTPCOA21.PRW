#INCLUDE 	"PROTHEUS.CH" 

STATIC aCpoDef	:= {}
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTPCOA21 ³ Autor ³ TOTVS PROTHEUS        ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de importacao de planilhas orçamentárias em       ³±±
±±³          ³ formato .CSV.                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PLANEJAMENTO E CONTROLE ORÇAMENTÁRIO                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTPCOA21()

LOCAL aSays 		:= {}
LOCAL aButtons		:= {}
LOCAL cPerg			:= "CTPCOA21"
LOCAL dDataSalv 	:= dDataBase
LOCAL nOpca 		:= 0     
LOCAL oMeter
LOCAL lProcess		:= .T.
LOCAL cMVPCOCONS	:= GETMV("MV_PCOCONS",.F.,"") // EMPRESA/FILIAL CONSOLIDADORA SERPARADO POR ,
LOCAL aMVPCOCONS	:= IIF( !EMPTY(cMVPCOCONS),  StrtoKarr(cMVPCOCONS,",") , {"",""} )

PRIVATE cCadastro 	:= "Importação de planilhas orçamentárias em formato .CSV"
PRIVATE lAtureg		:= .T.        
PRIVATE lUsu		:= .T.        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VALIDACOES PRELIMINARES - EMPRESA/FILIAL CONSOLIDADORA           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF 		EMPTY(aMVPCOCONS[1]) .OR. EMPTY(aMVPCOCONS[2])
	lProcess := .F.
	ShowHelpDlg("PCO00A03CONS.01",	{"O parâmetro MV_PCOCONS não está configurado."},5,;
									{"1) Configure o parâmetro MV_PCOCONS informando a empresa e filial consolidadora"},5)

ELSEIF	ALLTRIM(cEmpAnt) == ALLTRIM(aMVPCOCONS[1])
	lProcess := .F.
	ShowHelpDlg("PCO00A03CONS.02",	{"A empresa corrente está configurada como consolidadora."},5,;       
									{"1) Esta rotina não pode ser executada na empresa e filial consolidadora"},5)

ENDIF

IF lProcess
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01 // Arquivo a ser importado                          ³
	//³ mv_par02 // Quantidade de periodos                           ³
	//³ mv_par03 // Calendario padrao(CTG)                           ³
	//³ mv_par04 // Formato do Valor(1- 9999.99 - 2- 9.999,99        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	CriaSX1(cPerg)
	Pergunte(cPerg,.f.)
	
	AADD(aSays,OemToAnsi( "Importação de movimentos orçamentários em formato .CSV" ) )
	AADD(aSays,OemToAnsi( "  O  objetivo  deste programa  e  o  de  gerar  lancamentos  orçamentários" ) )
	
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) 	}} )
	AADD(aButtons, { 1,.T.,{|| nOpca:= 1, FechaBatch() 	}} )
	AADD(aButtons, { 2,.T.,{|| nOpca:= 0, FechaBatch() 	}} )
	
	FormBatch( cCadastro, aSays, aButtons )
		
	IF nOpca == 1
		MsgMeter( {|oMeter,oText01,oText02,oDlg,lEnd| PCOA21PC(oMeter,oText01,oText02,oDlg,@lEnd)},"Processando movimentação orçamentária...",,"Importação de movimentos orçamentários em formato .CSV",.T.)
	Endif
	
	dDataBase := dDataSalv

ENDIF

RETURN
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PCOA21PC³ Autor ³ TOTVS PROTHEUS        ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento do movimento orçamentário em formato CSV     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CTPCOA21 - IMPORTAÇÃO DE MOVIMENTOS ORÇAMENTÁRIOS CSV      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION PCOA21PC(oMeter,oText01,oText02,oDlg,lEnd)

Local aArea			:= GetArea()
Local _aPARAM		:= ARRAY(4)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis do processo de importacao CSV                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cLine			:=	""
Local aField 		:= {{}}
Local aData   		:= {{}}
Local aTempRead		:= {}
Local aTempData		:= {}
Local nLenFields	:= 0
Local nLenData		:= 0
Local lProcess		:= .T.
Local lConverte		:= .F.
Local nX,nY,nZ
Local nCount		:= 0
Local nTotCount		:= 0
Local lFirst		:= .T.
Local cAK5COSUP		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Identificadores das posicoes dos alias nos arrays de trabalho              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAlias		:= {"AKD"}
Local nPosAlias		:= 1
Local cAliasCab		:= "AKD"
Local aAliasIt		:= {"AKD"}
Local aFieldsObr	:= {}
Local nPosField		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva as variaveis de ambiente                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SaveInter()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis de compatibilizacao para que nao seja exibida a tela dos movtos  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE Inclui := .F.							

IF Type("__cInternet") != "C"
	PRIVATE __cInternet := "AUTOMATICO"
Else
	__cInternet := "AUTOMATICO"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis PRIVATE utilizadas em processo com MacroSubstituicao             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nPAKD_FIL	:= 0
PRIVATE nPAKD_PRC	:= 0
PRIVATE nPAKD_PLA	:= 0
PRIVATE nPAKD_VER	:= 0
PRIVATE nPAKD_LIN	:= 0
PRIVATE nPAKD_MDA   := 0
PRIVATE nPAKD_DTA   := 0
PRIVATE nPAKD_HST   := 0
PRIVATE nPAKD_CTA   := 0
PRIVATE nPAKD_CLA   := 0
PRIVATE nPAKD_OPR   := 0
PRIVATE nPAKD_CUS	:= 0
PRIVATE nPAKD_ITM	:= 0
PRIVATE nPAKD_CLV	:= 0
PRIVATE nPAKD_UNI	:= 0
PRIVATE nPAKD_E05	:= 0
PRIVATE nPAKD_E06	:= 0
PRIVATE nPAKD_E07	:= 0
PRIVATE nPAKD_E08	:= 0
PRIVATE nPAKD_E09	:= 0
PRIVATE aPAKD_PER	:= {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis padroes de contabilizacao que serao carregadas com os dados do CSV ³
//³Campos específico															³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nAKD_XAT01	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis padroes de contabilizacao que serao carregadas com os dados do CSV ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE VALOR 		:= 0
PRIVATE PLANILHA	:= ""
PRIVATE VERPLAN		:= ""
PRIVATE DEBITO 		:= ""
PRIVATE CREDITO		:= "" 
PRIVATE CLASSED		:= ""
PRIVATE CLASSEC		:= ""
PRIVATE OPERDB		:= ""
PRIVATE OPERCR		:= ""
PRIVATE CUSTOD		:= ""
PRIVATE CUSTOC		:= ""
PRIVATE ITEMD		:= ""
PRIVATE ITEMC		:= ""
PRIVATE CLVLD		:= ""
PRIVATE CLVLC		:= ""
PRIVATE UNIORCD		:= ""
PRIVATE UNIORCC		:= ""
PRIVATE EC05DB		:= ""
PRIVATE EC06DB		:= ""
PRIVATE EC07DB		:= ""
PRIVATE EC08DB		:= ""
PRIVATE EC09DB 		:= ""
PRIVATE EC05CR		:= ""
PRIVATE EC06CR		:= ""
PRIVATE EC07CR		:= ""
PRIVATE EC08CR		:= ""
PRIVATE EC09CR 		:= ""
PRIVATE HISTORICO 	:= ""
PRIVATE XBUFFER		:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega array aFieldsObr com os campos que devem existir na estrutura do CSV ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aFieldsObr,"AKD_FILIAL")
AADD(aFieldsObr,"AKD_CODPLA")
AADD(aFieldsObr,"AKD_VERSAO")
AADD(aFieldsObr,"AKD_LINHA" )
AADD(aFieldsObr,"AKD_MOEDA" )
AADD(aFieldsObr,"AKD_CO"    )
AADD(aFieldsObr,"AKD_CLASSE")
AADD(aFieldsObr,"AKD_OPER"  )
AADD(aFieldsObr,"AKD_CC"    )
AADD(aFieldsObr,"AKD_UNIORC")
AADD(aFieldsObr,"AKD_PER01" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do processamento                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva os parametros no array _aPARAM para protecao da PcoDetLan ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01 // Arquivo a ser importado                          ³
//³ mv_par02 // Quantidade de periodos                           ³
//³ mv_par03 // Calendario padrao(CTG)                           ³
//³ mv_par04 // Formato do Valor(1- 9999.99 - 2- 9.999,99        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

FOR nX := 1 TO LEN(_aPARAM)
	_aPARAM[nX] := &("MV_PAR"+StrZero(nX,2))
NEXT nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamentos dos valores (Formato 2 necessita de conversao)       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lConverte := _aPARAM[04] == 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VALIDACOES PRELIMINARES - INTEGRACAO ORCAMENTARIA HABILITADA     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !SuperGetMV("MV_PCOINTE",.T.,"2")=="1"
	lProcess := .F.
	ShowHelpDlg("MV_PCOINTE",{"A integração com o módulo PCO está desabilitada."},5,;
                               {"1) Habilite o parâmetro MV_PCOINTE para poder importar a movimentação."},5)
ENDIF

IF Empty(_aPARAM[01])

	lProcess := .F.
	ShowHelpDlg("CTPCOA21PRC.01",{"Não foi informado o nome do arquivo a ser contabilizado."},5,;
                               {"1) Informe o nome do arquivo a ser processado"},5)
ENDIF

IF lProcess .AND. (nHandle := FT_FUse(AllTrim(_aPARAM[01])))== -1

	lProcess := .F.
	ShowHelpDlg("CTPCOA21PRC.02",{"Não foi possivel abrir o arquivo selecionado para contabilizacao."},5,;
                               {"1) Informe um nome/caminho validos para leitura do arquivo a ser processado"},5)

ENDIF

IF lProcess .AND. Empty(_aPARAM[03])

	lProcess := .F.
	ShowHelpDlg("CTPCOA21PRC.04",{"Nao foi informado o calendario para tratamento dos peridos/datas dos movimentos."},5,;
                               {"1) Informe um calendario valido",  "2) Informe um calendario com "+cValToChar(_aPARAM[02])+" periodos"},5)

ELSEIF lProcess .AND. !EMPTY(_aPARAM[03])

	IF U_PCOA21CD(_aPARAM[03],_aPARAM[02]) // VALIDACAO DO CALENDARIO
                                 
		DbSelectArea("CTG")
		DbSetOrder(1)
		DbSeek(xFilial("CTG")+_aPARAM[03])
		
		aPeriodos 	:= {}
	   
		WHILE CTG->(!EOF()) .AND. CTG->(CTG_FILIAL+CTG_CALEND) == xFilial("CTG")+_aPARAM[03]
	
			AADD(aPeriodos,{ CTG->CTG_DTINI 					, CTG_DTFIM  								})
		
			CTG->(DbSkip())
		END
	
	
		IF Len(aPeriodos) == _aPARAM[02]
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiciona os demais campos de periodo como obrigatórios.               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nX := 2 TO LEN(aPeriodos)
				AADD(aFieldsObr,"AKD_PER"+STRZERO(nX,2) ) //"AKD_PERxx"
			Next nX 
			
			aPAKD_PER := ARRAY(_aPARAM[02])
		
		ELSE
			lProcess := .F.
			ShowHelpDlg("CTPCOA21PRC.05",{"O calendario informado nao possui","a mesma quantidade de periodos definida", "nos parametros"},5,;
		                               {"1) Informe um calendario valido",  "2) Informe um calendario com "+cValToChar(_aPARAM[02])+" periodos"},5)
		ENDIF
	
	ELSE
		lProcess := .F.
		ShowHelpDlg("CTPCOA21PRC.06",{"Nao foi informado um calendario nos parâmetros"},5,;
	                               {"1) Informe um calendario valido",  "2) Informe um calendario com "+cValToChar(_aPARAM[02])+" periodos"},5)
	ENDIF

ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³1a Etapa: Leitura do arquivo em conversao nos arrays de trabalho ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	( nCount :=0, nTotCount:=FT_FLASTREC(), oMeter:nTotal := nTotCount )  /*ProcRegua(FT_FLASTREC())*/

	lFirst := .T.
	WHILE !FT_FEOF()
	
		(nCount++, IncMeter(oMeter,oText01,"Etapa de Importação (01 de 01): ",oText02,"Leitura do arquivo CSV - Processando registro:"+STRZERO(nCount,12)+" de "+STRZERO(nTotCount,12),nCount) )/*IncProc()*/

		cLine		:= FT_FREADLN()
		cLine		:= PCOA21TRAN(cLine, ";;", "; ;") //StrTran( cLine, ";;", "; ;" ) // TRATAMENTO NECESSARIO PARA A StrtoKarr
		aTempRead	:= StrtoKarr(cLine,";")
	
		IF 	lFirst // Linhas de estrutrua de campos
			
			lFirst := .F.
			
			FOR nX := 1 TO LEN(aTempRead)
				AADD(aField[nPosAlias],{aTempRead[nX],X3TIPO(aTempRead[nX])})
			NEXT nX
	
		ELSE // Linha de dados: AKD
			
			aTempData := {}
			
			// Elimina as duas primeiras posicoes: Identificador e Alias
			FOR nX := 1 TO LEN(aTempRead)
				AADD(aTempData,aTempRead[nX])			
			NEXT nX		

			AADD(aData[nPosAlias],aClone(aTempData))
				
		ENDIF
	
		FT_FSKIP()
		
	END

	FT_FUSE()
	FCLOSE(nHandle)

ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³2a Etapa: Validacao da estrutura de campos e conteudos dos arrays³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2.1: Validacao das posicoes dos campos necessarios ao processo     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	( nCount :=0, nTotCount:= 4, oMeter:nTotal := nTotCount )
	(nCount++, IncMeter(oMeter,oText01,"Etapa de Validacao ("+STRZERO(nCount,2)+" de "+STRZERO(nTotCount,2)+"): ",oText02,"Validacao das posicoes dos campos necessarios ao processo",nCount) )/*IncProc()*/

	nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(cAliasCab)})        
	
	FOR nX := 1 TO LEN(aFieldsObr)

		IF ( nPosField := aScan(aField[nPosAlias],{|aFieldObr| ALLTRIM(aFieldObr[1]) == ALLTRIM(aFieldsObr[nX]) } ) ) == 0
		
			lProcess := .F.		
			ShowHelpDlg("CTPCOA21PRC.06",{"Nao existe na estrutura do arquivo selecionado"," um dos campos necessario a contabilizacao: "},5,;
		                                {"1) Atualize a estrutura do arquivo adicionando o campo:",ALLTRIM(aFieldsObr[nX]) },5)

		ELSE

			DO CASE
				
				CASE 	ALLTRIM(aFieldsObr[nX]) == "AKD_FILIAL"
					nPAKD_FIL := nPosField
				
				CASE 	ALLTRIM(aFieldsObr[nX]) == "AKD_CODPLA"
					nPAKD_PLA := nPosField
				
				CASE 	ALLTRIM(aFieldsObr[nX]) == "AKD_VERSAO"
					nPAKD_VER := nPosField
				
				CASE 	ALLTRIM(aFieldsObr[nX]) == "AKD_LINHA" 
					nPAKD_LIN := nPosField
				
				CASE 	ALLTRIM(aFieldsObr[nX]) == "AKD_MOEDA" 
					nPAKD_MDA := nPosField
				
				CASE 	ALLTRIM(aFieldsObr[nX]) == "AKD_CO"    
					nPAKD_CTA := nPosField
				
				CASE 	ALLTRIM(aFieldsObr[nX]) == "AKD_CLASSE"
					nPAKD_CLA := nPosField
				
				CASE 	ALLTRIM(aFieldsObr[nX]) == "AKD_OPER"  
					nPAKD_OPR := nPosField
				
				CASE 	ALLTRIM(aFieldsObr[nX]) == "AKD_CC"    
					nPAKD_CUS := nPosField
				
				CASE 	ALLTRIM(aFieldsObr[nX]) == "AKD_UNIORC" 
					nPAKD_UNI := nPosField


				CASE 	SUBSTR(ALLTRIM(aFieldsObr[nX]),1,7) == "AKD_PER" 
					aPAKD_PER[VAL(SUBSTR(ALLTRIM(aFieldsObr[nX]),8,2))] := nPosField
				
			ENDCASE
			
		ENDIF

	NEXT nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2.1.1: Carrega as posicoes dos demais campos do CT2 utilizados no  ³
	//³       processo mas que nao sao obrigatorios                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF lProcess
	
		nPAKD_PRC	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("AKD_PROCES")})
		nPAKD_DTA	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("AKD_DATA")})
		nPAKD_HST	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("AKD_HIST")})
		nPAKD_ITM	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("AKD_ITCTB")})
		nPAKD_CLV	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("AKD_CLVLR")})
		nPAKD_E05	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("AKD_ENT05")})
		nPAKD_E06	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("AKD_ENT06")})
		nPAKD_E07	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("AKD_ENT07")})
		nPAKD_E08	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("AKD_ENT08")})
		nPAKD_E09	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("AKD_ENT09")})
		nAKD_XAT01	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("AKD_XAT01")})

	ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2.2: Validacao da quantidade de itens das linhas de dados x campos ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	(nCount++, IncMeter(oMeter,oText01,"Etapa de Validacao ("+STRZERO(nCount,2)+" de "+STRZERO(nTotCount,2)+"): ",oText02,"Validacao da quantidade de itens das linhas de dados x campos",nCount) )/*IncProc()*/

	IF lProcess

		FOR nX := 1 TO LEN(aAlias)
			
			nLenFields := Len(aField[nX])
			             
			FOR nY := 1 TO LEN(aData[nX])

				nLenData := Len(aData[nX][nY])
							
				IF nLenData != nLenFields

					lProcess := .F.
					ShowHelpDlg("CTPCOA21PRC.10",{"Erro na estrutura de campos informada no arquivo","selecionado para importacao.","Quantidade de campos invalida !"},5,;
				                                {"Alias: "+aAlias[nX]	+" / Campos: "+STRZERO(nLenFields,2),"Linha: "+STRZERO(nY,6)	+" / Campos: "+STRZERO(nLenData,2)},5)

					EXIT
				
				ENDIF	
			
			NEXT nY
		
		NEXT nX

	ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2.3: Valida se todas as contas do orcamento possuem conta superior ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	(nCount++, IncMeter(oMeter,oText01,"Etapa de Validacao ("+STRZERO(nCount,2)+" de "+STRZERO(nTotCount,2)+"): ",oText02,"Validacao da conta superior para as contas do orcamento",nCount) )/*IncProc()*/

	IF lProcess

		DbSelectArea("AK5")
		DbSetOrder(1)		
		
		FOR nX := 1 TO LEN(aAlias)
			
			FOR nY := 1 TO LEN(aData[nX])

				IF AK5->(DbSeek(xFilial("AK5")+aData[nX][nY][nPAKD_CTA]))
				
					cAK5COSUP := AK5->AK5_COSUP
					
					IF !EMPTY(cAK5COSUP)
					
						IF !AK5->(DbSeek(xFilial("AK5")+cAK5COSUP))
					
							lProcess := .F.
							ShowHelpDlg("CTPCOA21PRC.11",{"Conta superior orçamentária não existe"," no cadastro de contas orçamentárias - AK5!"},5,;
						                                 {"Conta orçamentaria: "+aData[nX][nY][nPAKD_CTA],;
						                                  "Conta superior orçamentaria: "+cAK5COSUP},5)
						
						    EXIT
					
						ENDIF
					
					ELSE

						lProcess := .F.
						ShowHelpDlg("CTPCOA21PRC.12",{"Conta orçamentária não possui conta"," superior no cadastro de contas orçamentárias - AK5!"},5,;
					                                 {"Conta: "+aData[nX][nY][nPAKD_CTA]},5)
					
					    EXIT
					
					ENDIF
				
				ELSE
				
					lProcess := .F.
					ShowHelpDlg("CTPCOA21PRC.13",{"Conta orçamentária não presente"," no cadastro de contas orçamentárias - AK5!"},5,;
				                                 {"Conta: "+aData[nX][nY][nPAKD_CTA]},5)
				
				    EXIT
				
				ENDIF
	
			
			NEXT nY
		
		NEXT nX
	
	ENDIF

ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³3a Etapa: Efetua a contabilizacao das informacoes com base       ³
//³          no array dos dados importados.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³3.0: Efetua conversao dos dados em formato caracter para o         ³
	//³     formato dos campos										      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FOR nY := 1 TO Len(aData[nPosAlias])
		( nCount :=0, nTotCount:= Len(aData[nPosAlias]), oMeter:nTotal := nTotCount )
		(nCount++, IncMeter(oMeter,oText01,"Etapa de integração orçamentária (01 de 02): ",oText02,"Adequando formato dos dados do registro "+STRZERO(nCount,12)+" de "+STRZERO(nTotCount,12),nCount) )
		
		FOR nZ := 1 TO Len(aField[nPosAlias])

			DO CASE
					CASE aField[nPosAlias][nZ][2] == "C"
						aData[nPosAlias][nY][nZ] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]) )
						aData[nPosAlias][nY][nZ] := PCODPADR(aField[nPosAlias][nZ][1],aData[nPosAlias][nY][nZ])
					CASE aField[nPosAlias][nZ][2] == "L"
						aData[nPosAlias][nY][nZ] := IIF( ALLTRIM(aData[nPosAlias][nY][nZ]) == "T", .T., .F. )
					CASE aField[nPosAlias][nZ][2] == "D"
						aData[nPosAlias][nY][nZ] := CTOD( ALLTRIM(aData[nPosAlias][nY][nZ]) )
					CASE aField[nPosAlias][nZ][2] == "N"
						aData[nPosAlias][nY][nZ] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]), lConverte)
					CASE aField[nPosAlias][nZ][2] == "M"
						aData[nPosAlias][nY][nZ] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]) )
				ENDCASE

		NEXT nZ                  

	NEXT nY

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³3.1: Processamento da estrutura da planilha orçamentária AK1|AK2|AK3  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	( nCount :=0, nTotCount:= Len(aData[nPosAlias]), oMeter:nTotal := nTotCount )
	(nCount++, IncMeter(oMeter,oText01,"Etapa de integração orçamentária (02 de 02): ",oText02,"Criação da estrutura da planilha orçamentária "+STRZERO(nCount,12)+" de "+STRZERO(nTotCount,12),nCount) )
	IF lProcess
		PCOA21AK1(oMeter, oText01, oText02, oDlg, lEnd, _APARAM, aPeriodos, aAlias, aAliasIt, aData, aField, nPosAlias)
	ENDIF


ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura as variaveis de ambiente                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestInter()
RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PCOA21AK1ºAutor  ³ ------------------ º Data ³ ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria a estrutura da planilha orçamentária                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTPCOA21                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION PCOA21AK1(oMeter, oText01, oText02, oDlg, lEnd, _APARAM, aPeriodos, aAlias, aAliasIt, aData, aField, nPosAlias)

LOCAL aArea		:= GetArea()
LOCAL nCount 	:= 0
LOCAL nTotCount	:= 0
LOCAL nX,nY,nZ
LOCAL lExistAK1	:= .F.
LOCAL lExistAK3	:= .F.
LOCAL lExistAKE	:= .F.
LOCAL lFirstAK2	:= .F.
LOCAL nIDAK2	:= 0
LOCAL cCTACODPai:= ""
LOCAL nNivelSup	:= 1
LOCAL nTamAk1Cod:= TAMSX3("AK1_CODIGO")[1]
LOCAL lAK2_ENT05:= .F.
LOCAL lAK2_ENT06:= .F.
LOCAL lAK2_ENT07:= .F.
LOCAL lAK2_ENT08:= .F.
LOCAL lAK2_ENT09:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campos específicos											      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL lAK2_XAT01:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³3.1.0: Prepara as tabelas que serao utilizadas na importacao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("AK1")
DbSetOrder(1) //AK1_FILIAL+AK1_CODIGO+AK1_VERSAO

DbSelectArea("AK2")
//DbSetOrder(1) //AK2_FILIAL+AK2_ORCAME+AK2_VERSAO+AK2_CO+DTOS(AK2_PERIOD)+AK2_ID
DBORDERNICKNAME("AK2ENT0001") //AK2_FILIAL+AK2_ORCAME+AK2_VERSAO+AK2_CO+AK2_CC+AK2_CLASSE+AK2_OPER+AK2_ID+DTOS(AK2_PERIOD)

DbSelectArea("AK3")
DbSetOrder(1) //AK3_FILIAL+AK3_ORCAME+AK3_VERSAO+AK3_CO

DbSelectArea("AK5")
DbSetOrder(1) //AK5_FILIAL+AK5_CODIGO

DbSelectArea("AKE")
DbSetOrder(1) //AKE_FILIAL+AKE_ORCAME+AKE_REVISA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se os campos para tratamentos das novas entidades contaveis existem  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lAK2_ENT05 := AK2->(FieldPos("AK2_ENT05")) > 0
lAK2_ENT06 := AK2->(FieldPos("AK2_ENT06")) > 0
lAK2_ENT07 := AK2->(FieldPos("AK2_ENT07")) > 0
lAK2_ENT08 := AK2->(FieldPos("AK2_ENT08")) > 0
lAK2_ENT09 := AK2->(FieldPos("AK2_ENT09")) > 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campos específicos											      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lAK2_XAT01 := AK2->(FieldPos("AK2_XAT01")) > 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua o tratamento do controle de transacao para a geracao da AK1, AK2 e AK3 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//BEGIN TRANSACTION
FOR nX := 1 TO Len(aAliasIt)

	IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(aAliasIt[nX])})) > 0

		( nCount :=0, nTotCount:= Len(aData[nPosAlias]), oMeter:nTotal := nTotCount ) /*ProcRegua(Len(aData[nPosAlias]))*/

		FOR nY := 1 TO Len(aData[nPosAlias])

			(nCount++, IncMeter(oMeter,oText01,"Etapa de Importação (02 de 03): ",oText02,"Criação da estrutura da planilha orçamentária "+STRZERO(nCount,12)+" de "+STRZERO(nTotCount,12),nCount) )/*IncProc()*/

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³3.1.2: Para cada linha de dados, atualiza as estruturas do AK1, AK2, AK3³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³3.1.2.1: Efetua a criacao do AK1 - Capa do orçamento                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF !lExistAK1 
				//AK1_FILIAL+AK1_CODIGO+AK1_VERSAO
				IF AK1->(!DbSeek(xFilial("AK1")+PADR(aData[nPosAlias][nY][nPAKD_PLA],nTamAk1Cod," ")+aData[nPosAlias][nY][nPAKD_VER]))
					RecLock("AK1",.T.)
	                	AK1->AK1_FILIAL := xFilial("AK1")
						AK1->AK1_CODIGO := aData[nPosAlias][nY][nPAKD_PLA]
						AK1->AK1_VERSAO := aData[nPosAlias][nY][nPAKD_VER]
						AK1->AK1_VERREV := "0000"
						AK1->AK1_DESCRI := "ORCAMENTO GERADO VIA IMPORTACAO CSV"
						AK1->AK1_NMAX	:= 1
						AK1->AK1_TPPERI := "3" // MENSAL
						AK1->AK1_INIPER := aPeriodos[01][01] 				// DATA INICIAL DO PRIMEIRO PERIODO
						AK1->AK1_FIMPER := aPeriodos[LEN(aPeriodos)][02] 	// DATA FINAL DO ULTIMO PERIODO
						AK1->AK1_TPREV 	:= "1"
						AK1->AK1_STATUS := "1" 
						AK1->AK1_MEMO	:= ""
						AK1->AK1_CTRUSR := "2" // CONTROLE DE USUÁRIO DESATIVO PARA PERMITIR A MANUTEÇÃO INICIAL PÓS IMPORTACAO
						AK1->AK1_FASE 	:= "001"
						AK1->AK1_JUSTM 	:= ""
						AK1->AK1_CODJM 	:= ""
					MsUnlock()			
				ENDIF
				lExistAK1 := .T.
            ENDIF

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³3.1.2.1: Efetua a criacao do AKE - Versao do orçamento                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF !lExistAKE 
				//AKE_FILIAL+AKE_ORCAME+AKE_REVISA
				IF AKE->(!DbSeek(xFilial("AKE")+PADR(aData[nPosAlias][nY][nPAKD_PLA],nTamAk1Cod," ")+aData[nPosAlias][nY][nPAKD_VER]))
					RecLock("AKE",.T.)
	                	AKE->AKE_FILIAL := xFilial("AK1")
						AKE->AKE_ORCAME := aData[nPosAlias][nY][nPAKD_PLA]
						AKE->AKE_REVISA := aData[nPosAlias][nY][nPAKD_VER]
						AKE->AKE_DATAI	:= MSDATE()
						AKE->AKE_HORAI	:= TIME()
						AKE->AKE_USERI	:= RetCodUsr()
						AKE->AKE_DATAF	:= CTOD("")
						AKE->AKE_HORAF	:= ""
						AKE->AKE_USERF	:= ""
						AKE->AKE_MEMO	:= ""
						AKE->AKE_TIPO	:= "3" // MENSAL
					MsUnlock()			
				ENDIF
				lExistAKE := .T.
            ENDIF

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³3.1.2.2: Efetua a criacao do AK2 - Linhas do Orçamento                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            lFirstAK2 := .T.
			//AK2_FILIAL+AK2_ORCAME+AK2_VERSAO+AK2_CO+DTOS(AK2_PERIOD)+AK2_ID
			////AK2_FILIAL+AK2_ORCAME+AK2_VERSAO+AK2_CO+AK2_CC+AK2_CLASSE+AK2_OPER+AK2_ID+DTOS(AK2_PERIOD)
			//IF AK2->(!DbSeek(xFilial("AK2")+PADR(aData[nPosAlias][nY][nPAKD_PLA],nTamAk1Cod," ")+aData[nPosAlias][nY][nPAKD_VER]+NoMascara(aData[nPosAlias][nY][nPAKD_CTA])+DTOS(aPeriodos[nZ][01])))
			IF AK2->(!DbSeek(xFilial("AK2")+PADR(aData[nPosAlias][nY][nPAKD_PLA],nTamAk1Cod," ")+aData[nPosAlias][nY][nPAKD_VER]+NoMascara(aData[nPosAlias][nY][nPAKD_CTA])+NoMascara(aData[nPosAlias][nY][nPAKD_CUS])+NoMascara(aData[nPosAlias][nY][nPAKD_CLA])+NoMascara(aData[nPosAlias][nY][nPAKD_OPR]) ) )

				IF lFirstAK2
					nIDAK2++
					lFirstAK2 := .F.
				ENDIF

	            FOR nZ := 1 TO Len(aPeriodos)
	
					RecLock("AK2",.T.)
	                   	AK2->AK2_FILIAL := xFilial("AK2")
	                   	AK2->AK2_ID 	:= RETASC(STRZERO(nIDAK2,4),4,.T.)
	                   	AK2->AK2_ORCAME := aData[nPosAlias][nY][nPAKD_PLA]
	                   	AK2->AK2_VERSAO := aData[nPosAlias][nY][nPAKD_VER]
	                   	AK2->AK2_CO 	:= NoMascara(aData[nPosAlias][nY][nPAKD_CTA])
	                   	AK2->AK2_PERIOD := aPeriodos[nZ][01]
	                   	AK2->AK2_CC		:= IIF(nPAKD_CUS > 0, NoMascara(aData[nPosAlias][nY][nPAKD_CUS]), "")
	                   	AK2->AK2_ITCTB	:= IIF(nPAKD_ITM > 0, NoMascara(aData[nPosAlias][nY][nPAKD_ITM]), "")
	                   	AK2->AK2_CLVLR	:= IIF(nPAKD_CLV > 0, NoMascara(aData[nPosAlias][nY][nPAKD_CLV]), "")
	                   	AK2->AK2_CLASSE	:= NoMascara(aData[nPosAlias][nY][nPAKD_CLA])
	                   	AK2->AK2_VALOR	:= ABS(aData[nPosAlias][nY][aPAKD_PER[nZ]])
	                   	AK2->AK2_DESCRI := "" //PCOGETVAL("AK5","AK5_DESCRI",xFilial("AK5")+NoMascara(aData[nPosAlias][nY][nPAKD_CTA]),1,"")
	                   	AK2->AK2_OPER	:= NoMascara(aData[nPosAlias][nY][nPAKD_OPR])
	                   	AK2->AK2_CHAVE	:= ""
	                   	AK2->AK2_MOEDA	:= Val(aData[nPosAlias][nY][nPAKD_MDA])
	                   	AK2->AK2_DATAI	:= aPeriodos[nZ][01]
	                   	AK2->AK2_DATAF	:= aPeriodos[nZ][02]
	                   	AK2->AK2_FORMUL := ""
	                   	AK2->AK2_UNIORC := IIF(nPAKD_UNI > 0, NoMascara(aData[nPosAlias][nY][nPAKD_UNI]), "")
	                   	AK2->AK2_FORM	:= ""
	                   	IF lAK2_ENT05
	                   		AK2->AK2_ENT05	:= IIF(nPAKD_E05 > 0, NoMascara(aData[nPosAlias][nY][nPAKD_E05]), "")
						ENDIF
	                   	IF lAK2_ENT06
	                   		AK2->AK2_ENT06	:= IIF(nPAKD_E06 > 0, NoMascara(aData[nPosAlias][nY][nPAKD_E06]), "")
						ENDIF
	                   	IF lAK2_ENT07
	                    	AK2->AK2_ENT07	:= IIF(nPAKD_E07 > 0, NoMascara(aData[nPosAlias][nY][nPAKD_E07]), "")
						ENDIF
	                   	IF lAK2_ENT08
	                    	AK2->AK2_ENT08	:= IIF(nPAKD_E08 > 0, NoMascara(aData[nPosAlias][nY][nPAKD_E08]), "")
						ENDIF    
	                   	IF lAK2_ENT09
	                    	AK2->AK2_ENT09	:= IIF(nPAKD_E09 > 0, NoMascara(aData[nPosAlias][nY][nPAKD_E09]), "")
						ENDIF

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Campos específicos											      ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						IF lAK2_XAT01
	                    	AK2->AK2_XAT01	:= IIF(nAKD_XAT01 > 0, NoMascara(aData[nPosAlias][nY][nAKD_XAT01]), "")
						ENDIF

					MsUnLock()

				NEXT nZ

			ENDIF
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³3.1.2.3: Efetua a criacao do AK3 - Estrutura das contas do orçamento    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³3.1.2.3.1: Efetua a criacao da linha inicial do AK3 caso nao exista     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF !lExistAK3 
				//AK3_FILIAL+AK3_ORCAME+AK3_VERSAO+AK3_CO
				IF AK3->(!DbSeek(xFilial("AK3")+PADR(aData[nPosAlias][nY][nPAKD_PLA],nTamAk1Cod," ")+aData[nPosAlias][nY][nPAKD_VER]+aData[nPosAlias][nY][nPAKD_PLA]))
					RecLock("AK3",.T.)
						AK3->AK3_FILIAL := xFilial("AK3")
						AK3->AK3_ORCAME := aData[nPosAlias][nY][nPAKD_PLA]
						AK3->AK3_VERSAO := aData[nPosAlias][nY][nPAKD_VER]
						AK3->AK3_CO 	:= aData[nPosAlias][nY][nPAKD_PLA]
						AK3->AK3_PAI	:= ""
						AK3->AK3_TIPO	:= "1" // SINTETICO
						AK3->AK3_NIVEL	:= "001"
						AK3->AK3_DESCRI := "ORCAMENTO GERADO VIA IMPORTACAO CSV"
						AK3->AK3_MEMO	:= ""
						AK3->AK3_SEQ	:= ""
						AK3->AK3_LOGLCK := ""
					MsUnlock()			
				ENDIF
				lExistAK3 := .T.
            ENDIF			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³3.1.2.3.2: Inclui a conta orcamentaria na estrutura do AK3              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//AK3_FILIAL+AK3_ORCAME+AK3_VERSAO+AK3_CO
			IF AK3->(!DbSeek(xFilial("AK3")+PADR(aData[nPosAlias][nY][nPAKD_PLA],nTamAk1Cod," ")+aData[nPosAlias][nY][nPAKD_VER]+NoMascara(aData[nPosAlias][nY][nPAKD_CTA])))
            
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³3.1.2.3.2.1: Efetua o tratamento da estrutura do AK3 criando a arvore ascendente (pais)³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cCTACodPai := PCOGETVAL("AK5","AK5_COSUP",xFilial("AK5")+NoMascara(aData[nPosAlias][nY][nPAKD_CTA]),1,"")

				WHILE .T.
					IF PCOINSSUP(PADR(aData[nPosAlias][nY][nPAKD_PLA],nTamAk1Cod," "),aData[nPosAlias][nY][nPAKD_VER],cCTACodPai)
						lRetSup := .T.
						EXIT
					ENDIF
				END

				IF lRetSup .AND. AK3->(!DbSeek(xFilial("AK3")+PADR(aData[nPosAlias][nY][nPAKD_PLA],nTamAk1Cod," ")+aData[nPosAlias][nY][nPAKD_VER]+aData[nPosAlias][nY][nPAKD_CTA]))

					DbSelectArea("AK3")
					RecLock("AK3",.T.)
						AK3->AK3_FILIAL := xFilial("AK3")
						AK3->AK3_ORCAME := aData[nPosAlias][nY][nPAKD_PLA]
						AK3->AK3_VERSAO := aData[nPosAlias][nY][nPAKD_VER]
						AK3->AK3_CO 	:= NoMascara(aData[nPosAlias][nY][nPAKD_CTA])
						AK3->AK3_PAI	:= cCTACodPai
						AK3->AK3_TIPO	:= "2" //ANALITICO
						AK3->AK3_NIVEL	:= STRZERO( VAL( PCONIVSUP( PADR(aData[nPosAlias][nY][nPAKD_PLA],nTamAk1Cod," "),aData[nPosAlias][nY][nPAKD_VER], NoMascara(aData[nPosAlias][nY][nPAKD_CTA]) ) )+1,3)
						AK3->AK3_DESCRI := PCOGETVAL("AK5","AK5_DESCRI",xFilial("AK5")+NoMascara(aData[nPosAlias][nY][nPAKD_CTA]),1,"")
						AK3->AK3_MEMO	:= ""
						AK3->AK3_SEQ	:= ""
						AK3->AK3_LOGLCK := ""
					MsUnLock()
									
				ENDIF

			ENDIF
						
		NEXT nY
    
	ENDIF

NEXT nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Encerra o tratamento do controle de transacao para a geracao da AK1, AK2 e AK3 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//END TRANSACTION

RestArea(aArea)
RETURN(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PCOINSSUPºAutor  ³ ------------------ º Data ³ ----------  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ FUNCAO RECURSIVA PARA CADASTRAMENTO DA ENTIDADE SUPERIOR   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTPCOA21                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION PCOINSSUP(cAK3ORC, cAK3VER, cAK3CO)

Local aArea		:= GetArea()
Local lRet 		:= .F.
Local cCTACodPai:= ""

cCTACodPai := PCOGETVAL("AK5","AK5_COSUP",xFilial("AK5")+cAK3CO,1,"")

//AK3_FILIAL+AK3_ORCAME+AK3_VERSAO+AK3_CO
IF AK3->(!DbSeek(xFilial("AK3")+cAK3ORC+cAK3VER+cCTACodPai)) .AND. !EMPTY(cCTACodPai)

	lRet := PCOINSSUP(cAK3ORC,cAK3VER,cCTACodPai)

ELSEIF !EMPTY(cAK3CO)

	IF AK3->(!DbSeek(xFilial("AK3")+cAK3ORC+cAK3VER+cAK3CO))
		DbSelectArea("AK3")
		RecLock("AK3",.T.)
			AK3->AK3_FILIAL := xFilial("AK3")
			AK3->AK3_ORCAME := cAK3ORC
			AK3->AK3_VERSAO := cAK3VER
			AK3->AK3_CO 	:= cAK3CO
			AK3->AK3_PAI	:= IIF( Empty(cCTACodPai), cAK3ORC, cCTACodPai )
			AK3->AK3_TIPO	:= "1" //SINTETICO
			AK3->AK3_NIVEL	:= STRZERO( VAL( PCONIVSUP(cAK3ORC,cAK3VER,cAK3CO) )+1,3)
			AK3->AK3_DESCRI := PCOGETVAL("AK5","AK5_DESCRI",xFilial("AK5")+cAK3CO,1,"")
			AK3->AK3_MEMO	:= ""
			AK3->AK3_SEQ	:= ""
			AK3->AK3_LOGLCK := ""
		MsUnLock()
	ELSE
		lRet := .T.	
	ENDIF

ELSE
	lRet := .T.
ENDIF

RestArea(aArea)
RETURN lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PCOGETVALºAutor  ³ ------------------ º Data ³ ----------  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ENCAPSULA A FUNCAO GETADVFVAL() COM GETAREA()/RESTAREA()   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTPCOA21                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION PCOGETVAL(cAliasRet,cCpoRet,cKeyVal,nOrdVal,xRetDef)

Local aArea 	:= GetArea()
Local xReturn   := GetAdvFVal(cAliasRet,cCpoRet,cKeyVal,nOrdVal,xRetDef)

RestArea(aArea)
RETURN xReturn

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PCONIVSUPºAutor  ³ ------------------ º Data ³ ----------  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RETORNA O NIVEL DA CONTA ORCAMENTARIA SUPERIOR             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTPCOA21                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION PCONIVSUP(cAK3ORC, cAK3VER, cAK3CO)

Local aArea		:= GetArea()
Local cCTACodPai:= ""
Local cNivSup	:= ""

cCTACodPai := PCOGETVAL("AK5","AK5_COSUP",xFilial("AK5")+cAK3CO,1,"")

//AK3_FILIAL+AK3_ORCAME+AK3_VERSAO+AK3_CO
IF !EMPTY(cCTACodPai) .AND. AK3->(DbSeek(xFilial("AK3")+cAK3ORC+cAK3VER+cCTACodPai))
	cNivSup := AK3->AK3_NIVEL
ELSEIF EMPTY(cCTACodPai) .AND. AK3->(DbSeek(xFilial("AK3")+cAK3ORC+cAK3VER+cAK3ORC)) //cAK3ORC+cAK3VER+cAK3ORC
	cNivSup := AK3->AK3_NIVEL
ELSE
	cNivSup := "001"
ENDIF

RestArea(aArea)
RETURN cNivSup

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCOA21TRANºAutor  ³ ------------------ º Data ³ ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Garante que a STRTRAN() ajuste todas as ocorrencias        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTPCOA21                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION PCOA21TRAN(cString, cSearch, cReplace, nStart, nCount)

LOCAL cReturn 	:= ""
LOCAL cStringAtu:= cString

WHILE .T.

	cReturn := StrTran(cStringAtu, cSearch, cReplace, nStart, nCount)
	
	IF cReturn != cStringAtu
		cStringAtu := cReturn
	ELSE
		EXIT
	ENDIF

END

RETURN cReturn
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PCOA21CDºAutor  ³ ------------------ º Data ³ ----------  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida o calendario informado - 12 periodos                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTPCOA21                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION PCOA21CD(cCTGCalend,nQtdPer,lShowMsg)

Local lRet 		:= .T.
Local aArea 	:= GetArea()
Local aAreaCTG 	:= CTG->(GetArea()) 
Local aPeriodos	:= {}

Default lShowMsg := .T.
Default nQtdPer	 := 0

DbSelectArea("CTG")
DbSetOrder(1)
IF DbSeek(xFilial("CTG")+cCTGCalend)

	While CTG->(!EOF()) .AND. CTG->(CTG_FILIAL+CTG_CALEND) == xFilial("CTG")+cCTGCalend

		AADD(aPeriodos,{ CTG->CTG_DTINI 					, CTG_DTFIM  								})
	
		CTG->(DbSkip())
	End

	IF Len(aPeriodos) != nQtdPer
		IF lShowMsg
			ShowHelpDlg("PCO20ACD.01",{"O calendario informado nao possui "+cValToChar(nQtdPer)+" periodos."},5,;
		                             {"1) Informe um calendario com "+cValToChar(nQtdPer)+" periodos."},5)
		ENDIF
		lRet := .F.
	ENDIF
	
ELSE
	
	IF lShowMsg
		ShowHelpDlg("PCO20ACD.02",{"O calendario informado nao existe."},5,;
	                             {"1) Informe um calendario valido."},5)
	ENDIF
	lRet := .F.
ENDIF

RestArea(aAreaCTG)
RestArea(aArea)
RETURN lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ X3TIPO   ºAutor  ³ TOTVS Protheus     º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RETORNA O TIPO DO CAMPO CONFORME DICIONARIO DE DADOS       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION X3TIPO(cCampo)

LOCAL aArea 	:= GetArea() 
LOCAL aAreaSX3 	:= SX3->(GetArea())
LOCAL cTipo		:= "C"  // RETORNO PADRAO PARA PERMITIR O TRATAMENTO DA INFORMACAO NA ROTINA CHAMADORA
LOCAL nPosDef	:= 0

DEFAULT cCampo 	:= ""

IF !Empty(cCampo)

	AADD(aCpoDef,{"AKD_LINHA","C",04,0})
	AADD(aCpoDef,{"AKD_MOEDA","C",01,0})
	AADD(aCpoDef,{"AKD_PER","N",18,2})

	IF (nPosDef := aScan(aCpoDef,{|aCampo| ALLTRIM(aCampo[1]) == ALLTRIM(cCampo)}) ) > 0

		cTipo := aCpoDef[nPosDef][2]

	ELSEIF (nPosDef := aScan(aCpoDef,{|aCampo| ALLTRIM(aCampo[1]) == SUBSTR(ALLTRIM(cCampo),1,7)}) ) > 0
	
		cTipo := aCpoDef[nPosDef][2]
	
	ELSE
	
		DbSelectArea("SX3")
		DbSetOrder(2) // X3_CAMPO
		IF DbSeek(ALLTRIM(cCampo))
			cTipo := SX3->X3_TIPO
		ENDIF

	ENDIF

ENDIF

RestArea(aAreaSX3)
RestArea(aArea)

RETURN cTipo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PCODPADR ºAutor  ³ TOTVS Protheus     º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ AJUSTA O CONTEUDO DO CAMPO CARACTER CONFORME DICIONARIO    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION PCODPADR(cCampo,cConteudo)

LOCAL aArea 	:= GetArea() 
LOCAL aAreaSX3 	:= SX3->(GetArea())

LOCAL nPosPADR	:= 0
LOCAL nTamPADR	:= 0

STATIC aPCOPADR := {}

IF 		(nPosPADR := aScan(aPCOPADR,{|aCampo| ALLTRIM(aCampo[1]) == ALLTRIM(cCampo)}) ) > 0

	nTamPADR := aPCOPADR[nPosPADR][3]

ELSEIF	(nPosPADR := aScan(aCpoDef,{|aCampo| ALLTRIM(aCampo[1]) == ALLTRIM(cCampo)}) ) > 0

	nTamPADR := aCpoDef[nPosPADR][3]
	
ELSE
	
	DbSelectArea("SX3")
	DbSetOrder(2) // X3_CAMPO
	IF DbSeek(ALLTRIM(cCampo))
		AADD(aPCOPADR,{cCampo,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		nTamPADR := SX3->X3_TAMANHO
	ENDIF

ENDIF

cConteudo := IIF(nTamPADR>0,PADR(cConteudo,nTamPADR),cConteudo)

RestArea(aAreaSX3)
RestArea(aArea)
RETURN cConteudo

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NoAcento ³ Autor ³ TOTVS PROTHEUS        ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retira acento dos caracteres                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³Retorno   ³ ExpC1: Retorna String sem Acento                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: Recebe String com Acento                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION NoAcento(cString)

Local nConta := 0           
Local cLetra := ""        
Local cRet   := ""
cString := Upper(cString)
For nConta:= 1 To Len(cString)	
	cLetra := SubStr(cString, nConta, 1)
	Do Case
		Case (Asc(cLetra) >= 191 .and. Asc(cLetra) <= 198) .or. (Asc(cLetra) >= 223 .and. Asc(cLetra) <= 230)
			cLetra := "A"
		Case (Asc(cLetra) >= 199 .and. Asc(cLetra) <= 204) .or. (Asc(cLetra) >= 231 .and. Asc(cLetra) <= 236)
			cLetra := "E"
		Case (Asc(cLetra) >= 204 .and. Asc(cLetra) <= 207) .or. (Asc(cLetra) >= 235 .and. Asc(cLetra) <= 240)
			cLetra := "I"
		Case (Asc(cLetra) >= 209 .and. Asc(cLetra) <= 215) .or. (Asc(cLetra) == 240) .or. (Asc(cLetra) >= 241 .and. Asc(cLetra) <= 247)
			cLetra := "O"
		Case (Asc(cLetra) >= 216 .and. Asc(cLetra) <= 221) .or. (Asc(cLetra) >= 248 .and. Asc(cLetra) <= 253)
			cLetra := "U"
		Case Asc(cLetra) == 199 .or. Asc(cLetra) == 231
			cLetra := "C"
		Case Asc(cLetra) == 35 // "#"
			cLetra := "?"
		Case Asc(cLetra) == 63 // "?"
			cLetra := "?" 
		Case cLetra == '"'
			cLetra := ' '
	EndCase   
	cRet := cRet+cLetra
Next

Return UPPER(cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NoMascara³ Autor ³ TOTVS PROTHEUS        ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retira pontuacao dos codigos das entidades contabeis       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³Retorno   ³ ExpC1: Retorna String sem pontuacao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: Recebe String com pontuacao                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION NoMascara(cString)

Local nConta := 0           
Local cLetra := ""        
Local cRet   := ""
cString := Upper(cString)
For nConta:= 1 To Len(cString)	
	cLetra := SubStr(cString, nConta, 1)
	IF cLetra $ ".|,|-|/|*|\|_"
		cLetra := ""	
	ENDIF
	cRet := cRet+cLetra
Next

Return UPPER(cRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ValFormat³ Autor ³ TOTVS PROTHEUS        ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retira o "." do separador de milhares e troca a ","        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³Retorno   ³ ExpC1: Retorna String convertida em valor                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: Recebe String de valor formatada                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION ValFormat(cString,lConverte)

Local nConta := 0           
Local cLetra := ""        
Local cRet   := ""

IF lConverte .AND. AT(",",cString) > 0 
	cString := Upper(cString)
	For nConta:= 1 To Len(cString)	
		cLetra := SubStr(cString, nConta, 1)
		Do Case
			Case cLetra == "."
				cLetra := ""
			Case cLetra == ","
				cLetra := "."
		EndCase   
		cRet := cRet+cLetra
	Next
ELSE
	cRet := Upper(cString)
ENDIF

Return Val(cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MsgMeter ³ Autor ³ TOTVS PROTHEUS        ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Regua de processamento personalizada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION MsgMeter(bAction, cMsg01, cMsg02, cTitle, lEnd)

Local oDlg
Local oMeter
Local oText01
Local oText02
Local lEnd := .F. 
Local nVal := 0

DEFAULT bAction := {|| Nil}
DEFAULT cMsg01	 := "Processando ..."
DEFAULT cMsg02	 := ""
DEFAULT cTitle	 := "Aguarde"

DEFINE MSDIALOG oDlg FROM 05.00, 05.00 TO 12.00, 80.00 TITLE cTitle /*STYLE DS_MODALFRAME*/
@ 00.50, 01.00 SAY oText01 VAR cMsg01 SIZE 130.00, 10.00 OF oDlg
@ 01.25, 01.00 SAY oText02 VAR cMsg02 SIZE 130.00, 10.00 OF oDlg
@ 02.50, 01.00 METER oMeter VAR nVal TOTAL 10.00 SIZE 265.00, 10.00 OF oDlg
DEFINE SBUTTON FROM 37.50, 205.00 TYPE 2 ACTION lEnd := .F. ENABLE OF oDlg
oDlg:bStart = {|| Eval (bAction, oMeter, oText01, oText02 , oDlg, @lEnd), lEnd := .T., oDlg:End() }

ACTIVATE MSDIALOG oDlg CENTERED VALID lEnd

RETURN Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ IncMeter ³ Autor ³ TOTVS PROTHEUS        ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Incrementa a barra de processamento MsgMeter()             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION IncMeter(oMeter, oText01, cText01, oText02, cText02, nCount)

Local bBlock := {||}

DEFAULT cText01 := ""
DEFAULT cText02 := ""

oText01:SetText( cText01 )
oText02:SetText( cText02 )
bBlock := {|| oMeter:Set(nCount), SysRefresh() }
Eval(bBlock)

RETURN Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CriaSX1  ºAutor  ³Microsiga Protheus  º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Insere novas perguntas ao sx1                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTPCOA21                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSX1(cPerg)

Local cGrupoSX1 := PADR(cPerg,10," ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01 // Arquivo a ser importado                          ³
//³ mv_par02 // Quantidade de periodos                           ³
//³ mv_par03 // Calendario padrao(CTG)                           ³
//³ mv_par04 // Formato do Valor(1- 9999.99 - 2- 9.999,99        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PutSx1( cGrupoSX1, "01","Arquivo a Importar            ","Arquivo a Importar            ","Arquivo Importar              ","mv_ch1","C",40,0,0,"G",""								,"DIR"	,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1( cGrupoSX1, "02","Quantidade de periodos        ","Quantidade de periodos        ","Quantidade de periodos        ","mv_ch2","N",02,0,0,"G",""								,""		,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1( cGrupoSX1, "03","Calendario padrao             ","Calendario padrao             ","Calendario padrao             ","mv_ch3","C",03,0,0,"G","U_PCOA21CD(MV_PAR03,MV_PAR02)"	,"CTG"	,"","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1( cGrupoSX1, "04","Formato do valor              ","Formato do valor              ","Formato do valor              ","mv_ch4","N",01,0,2,"C",""								,""		,"","","mv_par04","9999.99","9999.99","9999.99","","9.999,99","9.999,99","9.999,99","","","","","","","","","")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PutSx1    ³ Autor ³Wagner                 ³ Data ³ 14/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria uma pergunta usando rotina padrao                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

LOCAL aArea := GetArea()
Local cKey
Local lPort := .f.
Local lSpa  := .f.
Local lIngl := .f. 

cKey  := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

cPyme    := Iif( cPyme 		== Nil, " ", cPyme		)
cF3      := Iif( cF3 		== NIl, " ", cF3		)
cGrpSxg  := Iif( cGrpSxg	== Nil, " ", cGrpSxg	)
cCnt01   := Iif( cCnt01		== Nil, "" , cCnt01 	)
cHelp	 := Iif( cHelp		== Nil, "" , cHelp		)

dbSelectArea( "SX1" )
dbSetOrder( 1 )

// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
// RFC - 15/03/2007
cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

If !( DbSeek( cGrupo + cOrdem ))

    cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
	cPerSpa	:= If(! "?" $ cPerSpa  .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
	cPerEng	:= If(! "?" $ cPerEng  .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
	/* Removido 11/05/23 - Não executa mais Recklock na X1 - Criar perguntas no configurador
	Reclock( "SX1" , .T. )

	Replace X1_GRUPO   With cGrupo
	Replace X1_ORDEM   With cOrdem
	Replace X1_PERGUNT With cPergunt
	Replace X1_PERSPA  With cPerSpa
	Replace X1_PERENG  With cPerEng
	Replace X1_VARIAVL With cVar
	Replace X1_TIPO    With cTipo
	Replace X1_TAMANHO With nTamanho
	Replace X1_DECIMAL With nDecimal
	Replace X1_PRESEL  With nPresel
	Replace X1_GSC     With cGSC
	Replace X1_VALID   With cValid

	Replace X1_VAR01   With cVar01

	Replace X1_F3      With cF3
	Replace X1_GRPSXG  With cGrpSxg

	If Fieldpos("X1_PYME") > 0
		If cPyme != Nil
			Replace X1_PYME With cPyme
		Endif
	Endif

	Replace X1_CNT01   With cCnt01
	If cGSC == "C"			// Mult Escolha
		Replace X1_DEF01   With cDef01
		Replace X1_DEFSPA1 With cDefSpa1
		Replace X1_DEFENG1 With cDefEng1

		Replace X1_DEF02   With cDef02
		Replace X1_DEFSPA2 With cDefSpa2
		Replace X1_DEFENG2 With cDefEng2

		Replace X1_DEF03   With cDef03
		Replace X1_DEFSPA3 With cDefSpa3
		Replace X1_DEFENG3 With cDefEng3

		Replace X1_DEF04   With cDef04
		Replace X1_DEFSPA4 With cDefSpa4
		Replace X1_DEFENG4 With cDefEng4

		Replace X1_DEF05   With cDef05
		Replace X1_DEFSPA5 With cDefSpa5
		Replace X1_DEFENG5 With cDefEng5
	Endif

	Replace X1_HELP  With cHelp

	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	MsUnlock()*/
Else

   lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
   lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA)
   lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG)

   If lPort .Or. lSpa .Or. lIngl
		/* Removido 11/05/23 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
		RecLock("SX1",.F.)
		If lPort 
         SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
		EndIf
		If lSpa 
			SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
		EndIf
		If lIngl
			SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
		EndIf
		SX1->(MsUnLock())
		*/
	EndIf
Endif

RestArea( aArea )

Return
