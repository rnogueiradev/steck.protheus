#INCLUDE "PROTHEUS.CH"  

#DEFINE CSTR0001 "Integração Orçamentária: Movimentação Contábil"
#DEFINE CSTR0002 "Confirma a integração da movimentação contábil para o orçamento"+CRLF+"conforme os parâmetros selecionados?"
#DEFINE CSTR0003 "Processo para integração da movimentação contábil com o orçamento."
#DEFINE CSTR0004 "Histórico de Processamento"
#DEFINE CSTR0005 "Processo concluido sem ocorrências"
#DEFINE CSTR0006 "Processo nao executado. Verifique as ocorrencias"

//-------------------------------------------------------------------
/*/{Protheus.doc}CTPCOA10

FUNÇÃO PARA INTEGRAÇÃO DA MOVIMENTAÇÃO CONTÁBIL AO ORÇAMENTO
COM BASE NOS PARÂMETROS DE SELEÇÃO DEFINIDOS PELO USUÁRIO

@author TOTVS MICROSIGA PROTHEUS
@since  01/01/2016
/*/
//-------------------------------------------------------------------

USER FUNCTION CTPCOA10()

LOCAL cAKDProcess	:= "934001"
LOCAL bProcess		:= Nil
LOCAL cPerg			:= Nil
LOCAL aInfo			:= {}
LOCAL oProcess		:= Nil      
LOCAL cIdCV8		:= ""
LOCAL lProcess		:= .T.
LOCAL cPerg			:= "CTPCOA10C" 
LOCAL aPARAM 		:= ARRAY(17)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VALIDACOES PRELIMINARES - INTEGRACAO ORCAMENTARIA HABILITADA     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !SuperGetMV("MV_PCOINTE",.T.,"2")=="1"
	lProcess := .F.
	ShowHelpDlg("MV_PCOINTE",{"A integração com o módulo PCO está desabilitada."},5,;
                               {"1) Habilite o parâmetro MV_PCOINTE para poder importar a movimentação."},5)
ENDIF

IF lProcess 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Perguntas para parametrizacao da rotina (PARAMBOX)          		    ³
	//³ MV_PAR01   - Processo de Integração                				     	³
	//³ MV_PAR02   - Da Filial                                   				³
	//³ MV_PAR03   - Até a Filial                                  				³
	//³ MV_PAR04   - Da Data                                     				³
	//³ MV_PAR05   - Até a Data                                    				³
	//³ MV_PAR06   - Do lote                                                    ³
	//³ MV_PAR07   - Até o lote                                          		³
	//³ MV_PAR08   - Do sublote                                          		³
	//³ MV_PAR09   - Até o sublote                                          	³
	//³ MV_PAR10   - Do documento                                          		³
	//³ MV_PAR11   - Até o documento                                          	³
	//³ MV_PAR12   - Da moeda                                          			³
	//³ MV_PAR13   - Do tipo de saldo                                          	³    
	//³ MV_PAR14   - Para o tipo de saldo                                      	³
	//³ MV_PAR15   - Atualiza saldo dos movtos                                 	³
	//³ MV_PAR16   - Limpa movtos do periodo                                   	³
	//³ MV_PAR17   - Limpa historico de processamento                          	³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CRIASX1(cPerg,cAKDProcess)
	AADD(aInfo,{"Visualizar", { || ProcLogView(,FunName()) },"WATCH" })
	bProcess	:= {|oSelf| IIF( U_PCOA10PB(cPerg,aPARAM) .AND. ApMsgNoYes( CSTR0002, CSTR0001) , U_PCOA10PC(oSelf,aPARAM,cIdCV8), .F.) }    
	
	oProcess := tNewProcess():New("CTPCOA10",;
									CSTR0001,;
									bProcess,;
									CSTR0003,;
									cPerg,;
									aInfo,;
									.T.,;
									5,;
									CSTR0004,;
									.T.)
ENDIF

RETURN

//-------------------------------------------------------------------
/*/{Protheus.doc}CTPCOA10PRC

PROCESSAMENTO DA INTEGRAÇÃO DA MOVIMENTAÇÃO CONTÁBIL AO ORÇAMENTO
COM BASE NOS PARÂMETROS DE SELEÇÃO DEFINIDOS PELO USUÁRIO

@author TOTVS MICROSIGA PROTHEUS
@since  01/01/2016
/*/
//-------------------------------------------------------------------
USER FUNCTION PCOA10PC(oProcess,aPARAM,cIdCV8)

LOCAL aArea 	:= GetArea()
LOCAL cAliasQRY	:= GetNextAlias()
LOCAL cQuery    := ""
LOCAL aRecCT2	:= {}   
LOCAL nRecno	:= 0
LOCAL cAKDProcess	:= aPARAM[01]
LOCAL lAKDProces:= PcoExistLc(cAKDProcess,"01","1")
LOCAL nCountReg	:= 0
LOCAL nCountPrc	:= 0
LOCAL lAtuSldMvt:= aPARAM[15]==1
LOCAL lDelMvtPer:= aPARAM[16]==1
LOCAL lDelHstLog:= aPARAM[17]==1
LOCAL lProcess	:= .T.

LOCAL lCT2_EC05DB := CT2->(FIELDPOS("CT2_EC05DB")) > 0
LOCAL lCT2_EC06DB := CT2->(FIELDPOS("CT2_EC06DB")) > 0
LOCAL lCT2_EC07DB := CT2->(FIELDPOS("CT2_EC07DB")) > 0
LOCAL lCT2_EC08DB := CT2->(FIELDPOS("CT2_EC08DB")) > 0
LOCAL lCT2_EC09DB := CT2->(FIELDPOS("CT2_EC09DB")) > 0
LOCAL lCT2_EC05CR := CT2->(FIELDPOS("CT2_EC05CR")) > 0
LOCAL lCT2_EC06CR := CT2->(FIELDPOS("CT2_EC06CR")) > 0
LOCAL lCT2_EC07CR := CT2->(FIELDPOS("CT2_EC07CR")) > 0
LOCAL lCT2_EC08CR := CT2->(FIELDPOS("CT2_EC08CR")) > 0
LOCAL lCT2_EC09CR := CT2->(FIELDPOS("CT2_EC09CR")) > 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis para controle da quebra do lote de registro                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL lFirst	  	:= .T.
LOCAL cCT2_FILIAL 	:= ""
LOCAL cCT2_DATA	 	:= ""
LOCAL cCT2_LOTE	 	:= ""
LOCAL cCT2_SBLOTE	:= ""
LOCAL cCT2_DOC	 	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis padroes de contabilizacao que serao carregadas com os dados do CSV ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE VALOR 		:= 0
PRIVATE VALOR01		:= 0
PRIVATE VALOR02		:= 0
PRIVATE VALOR03		:= 0
PRIVATE VALOR04		:= 0
PRIVATE VALOR05		:= 0
PRIVATE DATAMOV		:= CTOD("")
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
PRIVATE TPSALD		:= ""

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

IF lAKDProces

	ProcLogIni( {},FunName(),,@cIdCV8 )
	ProcLogAtu( "INICIO" 	, CSTR0001 ,,,.T. )
	ProcLogAtu( "MENSAGEM"	, "PROCESSO: "+aPARAM[01] ,,,.T. )

	oProcess:SetRegua1(0)
	oProcess:IncRegua1(CSTR0001)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Perguntas para parametrizacao da rotina (PARAMBOX)          		    ³
	//³ MV_PAR01   - Processo de Integração                				     	³
	//³ MV_PAR02   - Da Filial                                   				³
	//³ MV_PAR03   - Até a Filial                                  				³
	//³ MV_PAR04   - Da Data                                     				³
	//³ MV_PAR05   - Até a Data                                    				³
	//³ MV_PAR06   - Do lote                                                    ³
	//³ MV_PAR07   - Até o lote                                          		³
	//³ MV_PAR08   - Do sublote                                          		³
	//³ MV_PAR09   - Até o sublote                                          	³
	//³ MV_PAR10   - Do documento                                          		³
	//³ MV_PAR11   - Até o documento                                          	³
	//³ MV_PAR12   - Da moeda                                          			³
	//³ MV_PAR13   - Do tipo de saldo                                          	³    
	//³ MV_PAR14   - Para o tipo de saldo                                      	³
	//³ MV_PAR15   - Atualiza saldo dos movtos                                 	³
	//³ MV_PAR16   - Limpa movtos do periodo                                   	³
	//³ MV_PAR17   - Limpa historico de processamento                          	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT NVL(CT2.R_E_C_N_O_,0) CT2RECNO FROM "+RetSqlName("CT2")+" CT2 "
	cQuery += "WHERE "
	cQuery += "		CT2.D_E_L_E_T_ = ' ' "
	cQuery += "AND 	CT2.CT2_FILIAL	BETWEEN '"+XFILIAL("CT2",aPARAM[02])+"' AND '"+XFILIAL("CT2",aPARAM[03])+"' "
	cQuery += "AND 	CT2.CT2_DATA 	BETWEEN '"+DTOS(aPARAM[04])+"' AND '"+DTOS(aPARAM[05])+"' "
	cQuery += "AND 	CT2.CT2_LOTE	BETWEEN '"+aPARAM[06]+ "' AND '"+aPARAM[07]+"' "
	cQuery += "AND 	CT2.CT2_SBLOTE	BETWEEN '"+aPARAM[08]+ "' AND '"+aPARAM[09]+"' "
	cQuery += "AND 	CT2.CT2_DOC		BETWEEN '"+aPARAM[10]+ "' AND '"+aPARAM[11]+"' "
	cQuery += "AND 	CT2.CT2_MOEDLC	='"+aPARAM[12]+"' "
	cQuery += "AND 	CT2.CT2_TPSALD	='"+aPARAM[13]+"' "

	IF !lDelMvtPer
		cQuery += "AND  NOT EXISTS ( "
		cQuery += "					 SELECT 1 FROM "+RetSqlName("AKD")+" AKD "
		cQuery += "					 WHERE "
		cQuery += "					 		AKD.D_E_L_E_T_ = ' ' "
		cQuery += "					 AND	AKD.AKD_FILIAL = '"+xFilial("AKD")+"' "
		cQuery += "					 AND 	AKD.AKD_CHAVE  = 'CT2'+CT2.CT2_FILIAL+CT2.CT2_DATA+CT2.CT2_LOTE+CT2.CT2_SBLOTE+CT2.CT2_DOC+CT2.CT2_LINHA+CT2.CT2_TPSALD+CT2.CT2_EMPORI+CT2.CT2_FILORI+CT2.CT2_MOEDLC "
		cQuery += "					 AND 	AKD.AKD_PROCES = '"+cAKDProcess+"' "
		cQuery += "					 ) "
	ENDIF
	
	cQuery += "ORDER BY CT2.CT2_FILIAL, CT2.CT2_DATA, CT2.CT2_LOTE, CT2.CT2_SBLOTE, CT2.CT2_DOC"
	
	cQuery := ChangeQuery(cQuery)
	
	ProcLogAtu( "MENSAGEM"	, "QUERY DE SELECAO",cQuery,,.T. )
	
	IF SELECT(cAliasQRY) > 0
		DbSelectArea(cAliasQRY)
		DbCloseArea()
	ENDIF
	
	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasQRY,.F.,.T.)
	
	DbSelectArea(cAliasQRY)
	DbGoTop()
	While (cAliasQRY)->(!EOF())
	
		IF 	(cAliasQRY)->CT2RECNO > 0
			AADD(aRecCT2,(cAliasQRY)->CT2RECNO)
		ENDIF
	
		(cAliasQRY)->(dbSkip())
	End
	
	IF SELECT(cAliasQRY) > 0
		DbSelectArea(cAliasQRY)
		DbCloseArea()
	ENDIF
	
	IF (nCountReg := LEN(aRecCT2) ) > 0
	
		//--------------------------------------------------------//
		// SOMENTE LIMPA O HISTORICO SE PROCESSAR                 //
		//--------------------------------------------------------//
		IF lDelHstLog
			lProcess := PCOA10XCV8(oProcess,FUNNAME(),cIdCV8)
		ENDIF

		//--------------------------------------------------------//
		// SOMENTE LIMPA A MOVIMENTACAO DO PERIODO SE PROCESSAR   //
		//--------------------------------------------------------//
		IF lDelMvtPer
			lProcess := PCOA10XAKD(oProcess,aPARAM,cIdCV8)
		ENDIF

		IF lProcess
		
			DbSelectArea("CT2")
			ProcLogAtu( "MENSAGEM"	,  "REGISTROS: "+CVALTOCHAR(nCountReg) ,,,.T. )
	
			oProcess:SetRegua2(nCountReg)
	
			FOR nRecno := 1 TO nCountReg
		
				nCountPrc++
				CT2->(DbGoto(aRecCT2[nRecno]))
				oProcess:IncRegua2("Processando movimentação contábil - Registro: "+STRZERO(nRecno,6)+" | "+STRZERO(nCountReg,6))
		
				IF lFirst
	
					//----------------------------------------------------//
					// INICIALIZA O PROCESSO ORÇAMENTARIO SELECIONADO     //
					//----------------------------------------------------//
					PcoIniLan(aPARAM[01])
					lFirst := .F.
	
				ELSEIF CT2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC) != (cCT2_FILIAL+cCT2_DATA+cCT2_LOTE+cCT2_SBLOTE+cCT2_DOC) .OR. nCountPrc >= 1000
				
					nCountPrc := 0
				
					//----------------------------------------------------//
					// EFETUA A QUEBRA DO DOCUMENTO ORÇAMENTÁRIO          //
					//----------------------------------------------------//
					PcoFinLan(cAKDProcess)
					PcoFreeBlq(cAKDProcess)
	
					//----------------------------------------------------//
					// INICIALIZA O PROCESSO ORÇAMENTARIO SELECIONADO     //
					//----------------------------------------------------//
					PcoIniLan(aPARAM[01])
	
				ENDIF
					
				CFILANT		:= XFILIAL("CT2",CT2_FILIAL)
				DATAMOV		:= CT2->CT2_DATA
				VALOR 		:= CT2->CT2_VALOR
				VALOR01		:= IIF(CT2->CT2_MOEDLC == "01", CT2->CT2_VALOR, 0)
				VALOR02		:= IIF(CT2->CT2_MOEDLC == "02", CT2->CT2_VALOR, 0)
				VALOR03		:= IIF(CT2->CT2_MOEDLC == "03", CT2->CT2_VALOR, 0)
				VALOR04		:= IIF(CT2->CT2_MOEDLC == "04", CT2->CT2_VALOR, 0)
				VALOR05		:= IIF(CT2->CT2_MOEDLC == "05", CT2->CT2_VALOR, 0)
				DEBITO 		:= IIF( CT2->CT2_DC $ "1|3", CT2->CT2_DEBITO, "")
				CREDITO 	:= IIF( CT2->CT2_DC $ "2|3", CT2->CT2_CREDIT, "")
				//CLASSED		:= U_PCGETAK6(CT2->CT2_DEBITO)
				//CLASSEC		:= U_PCGETAK6(CT2->CT2_CREDIT)
				OPERDB		:= ""
				OPERCR		:= ""
				CUSTOD		:= CT2->CT2_CCD
				CUSTOC		:= CT2->CT2_CCC
				ITEMD		:= CT2->CT2_ITEMD
				ITEMC		:= CT2->CT2_ITEMC
				CLVLD		:= CT2->CT2_CLVLDB
				CLVLC		:= CT2->CT2_CLVLCR
				EC05DB		:= IIF( lCT2_EC05DB ,CT2->CT2_EC05DB,"" ) //CT2->CT2_EC05DB
				EC06DB		:= IIF( lCT2_EC06DB ,CT2->CT2_EC06DB,"" ) //CT2->CT2_EC06DB
				EC07DB		:= IIF( lCT2_EC07DB ,CT2->CT2_EC07DB,"" ) //CT2->CT2_EC07DB
				EC08DB		:= IIF( lCT2_EC08DB ,CT2->CT2_EC08DB,"" ) //CT2->CT2_EC08DB
				EC09DB 		:= IIF( lCT2_EC09DB ,CT2->CT2_EC09DB,"" ) //CT2->CT2_EC09DB
				EC05CR		:= IIF( lCT2_EC05CR ,CT2->CT2_EC05CR,"" ) //CT2->CT2_EC05CR
				EC06CR		:= IIF( lCT2_EC06CR ,CT2->CT2_EC06CR,"" ) //CT2->CT2_EC06CR
				EC07CR		:= IIF( lCT2_EC07CR ,CT2->CT2_EC07CR,"" ) //CT2->CT2_EC07CR
				EC08CR		:= IIF( lCT2_EC08CR ,CT2->CT2_EC08CR,"" ) //CT2->CT2_EC08CR
				EC09CR 		:= IIF( lCT2_EC09CR ,CT2->CT2_EC09CR,"" ) //CT2->CT2_EC09CR
				HISTORICO	:= CT2->CT2_HIST
				UNIORCD 	:= U_PCGETAMF()
				UNIORCC 	:= UNIORCD
				TPSALD 		:= aPARAM[14]
				PLANILHA	:= ""
				VERPLAN		:= ""
			    
				DATABASE	:= DATAMOV
				//IF !U_PCAKDCHV(cAKDProcess,"CT2"+CT2->CT2_FILIAL+DTOS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC+CT2->CT2_LINHA+CT2->CT2_TPSALD+CT2->CT2_EMPORI+CT2->CT2_FILORI+CT2->CT2_MOEDLC)
					PcoDetLan(cAKDProcess,"01","CTPCOA10",.F.,,"1",lAtuSldMvt) //PcoDetLan( cAKDProcesso, cItem, cPrograma, lDeleta, cProcDel, cAKDStatus, lAtuSld )
				//ENDIF
	
				cCT2_FILIAL := CT2->CT2_FILIAL
				cCT2_DATA	:= DTOS(CT2->CT2_DATA)
				cCT2_LOTE	:= CT2->CT2_LOTE
				cCT2_SBLOTE	:= CT2->CT2_SBLOTE
				cCT2_DOC	:= CT2->CT2_DOC
	
			NEXT nRecno
	
			PcoFinLan(cAKDProcess)
			PcoFreeBlq(cAKDProcess)
			ProcLogAtu( "MENSAGEM"	,  CSTR0005 ,,,.T. )
		ELSE
			ProcLogAtu( "MENSAGEM"	,  CSTR0006 ,,,.T. )
		ENDIF

	ENDIF

	ProcLogAtu( "FINAL"		,  CSTR0001 ,,,.T. )
	ProcLogView(cFilAnt,FunName(),,cIdCV8)

ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura as variaveis de ambiente                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestInter()
RESTAREA(aArea)
RETURN

//-------------------------------------------------------------------
/*/{Protheus.doc}PCOA10XAKD

Efetua a exclusao dos lancamentos do periodo para o processo informado

@author TOTVS MICROSIGA PROTHEUS
@since  01/01/2016
/*/
//-------------------------------------------------------------------
STATIC FUNCTION PCOA10XAKD(oProcess,aPARAM,cIdCV8)

LOCAL cQuery 	:= ""
LOCAL cTableAKD	:= RetSqlName("AKD")
LOCAL cAliasQRY	:= GetNextAlias()
LOCAL nCountReg	:= 0
LOCAL nHndQry 	:= 0
LOCAL lRet		:= .T.

ProcLogAtu( "MENSAGEM"	, "EXCLUSÃO DE LANCAMENTOS DO PERIODO",,,.T. )

cQuery := "SELECT COUNT(*) NCOUNTREG FROM "+cTableAKD+" AKD "
cQuery += "WHERE "
cQuery += "		AKD.D_E_L_E_T_ = ' ' "
cQuery += "AND 	AKD.AKD_PROCES	='"+aPARAM[01]+"' "
cQuery += "AND 	AKD.AKD_DATA 	BETWEEN '"+DTOS(aPARAM[04])+"' AND '"+DTOS(aPARAM[05])+"' "      
cQuery += "AND 	AKD.AKD_FILIAL 	BETWEEN '"+XFILIAL("AKD",aPARAM[02])+"' AND '"+XFILIAL("AKD",aPARAM[03])+"' "

cQuery := ChangeQuery(cQuery)

ProcLogAtu( "MENSAGEM"	, "QUERY DE SELECAO" ,cQuery,,.T. )

IF SELECT(cAliasQRY) > 0
	DbSelectArea(cAliasQRY)
	DbCloseArea()
ENDIF

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasQRY,.F.,.T.)

DbSelectArea(cAliasQRY)
DbGoTop()
WHILE (cAliasQRY)->(!EOF())
	nCountReg := (cAliasQRY)->NCOUNTREG
	(cAliasQRY)->(dbSkip())
END

ProcLogAtu( "MENSAGEM"	,  "REGISTROS: "+CVALTOCHAR(nCountReg) ,,,.T. )

IF SELECT(cAliasQRY) > 0
	DbSelectArea(cAliasQRY)
	DbCloseArea()
ENDIF

cQuery := "DELETE FROM "+cTableAKD+" "
cQuery += "WHERE "
cQuery += "		 "+cTableAKD+".D_E_L_E_T_ = ' ' "
cQuery += "AND 	 "+cTableAKD+".AKD_PROCES	='"+aPARAM[01]+"' "
cQuery += "AND 	 "+cTableAKD+".AKD_DATA 	BETWEEN '"+DTOS(aPARAM[04])+"' AND '"+DTOS(aPARAM[05])+"' "   
cQuery += "AND 	"+cTableAKD+".AKD_FILIAL 	BETWEEN '"+XFILIAL("AKD",aPARAM[02])+"' AND '"+XFILIAL("AKD",aPARAM[03])+"' "

ProcLogAtu( "MENSAGEM"	, "QUERY DE EXCLUSAO" ,cQuery,,.T. )

nHndQry := TCSQLEXEC(cQuery)

IF nHndQry  >= 0
	ProcLogAtu( "MENSAGEM"	, "ATUALIZACAO EFETUADA COM SUCESSO" ,cQuery,,.T. ) 
	lRet := .T.
ELSE
	ProcLogAtu( "ERRO"		, "ERRO NA EXECUCAO DA ATUALIZACAO"  ,cQuery,,.T. )
	lRet := .F.
ENDIF

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc}PCOA10XCV8

Efetua a exclusao do log de processamento da rotina - CV8

@author TOTVS MICROSIGA PROTHEUS
@since  01/01/2016
/*/
//-------------------------------------------------------------------
STATIC FUNCTION PCOA10XCV8(oProcess,cRotina,cIdCV8)

LOCAL cQuery 	:= ""
LOCAL cTableCV8	:= RetSqlName("CV8")
LOCAL cAliasQRY	:= GetNextAlias()
LOCAL nCountReg	:= 0
LOCAL nHndQry 	:= 0
LOCAL lRet		:= .T.

ProcLogAtu( "MENSAGEM"	, "EXCLUSÃO DE LOGS ANTERIORES",,,.T. )

cQuery := "SELECT COUNT(*) NCOUNTREG FROM "+cTableCV8+" CV8 "
cQuery += "WHERE "
cQuery += "		CV8.D_E_L_E_T_ = ' ' "
cQuery += "AND 	CV8.CV8_PROC	='"+cRotina+"' "

cQuery := ChangeQuery(cQuery)

ProcLogAtu( "MENSAGEM"	, "QUERY DE SELECAO" ,cQuery,,.T. )

IF SELECT(cAliasQRY) > 0
	DbSelectArea(cAliasQRY)
	DbCloseArea()
ENDIF

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasQRY,.F.,.T.)

DbSelectArea(cAliasQRY)
DbGoTop()
WHILE (cAliasQRY)->(!EOF())
	nCountReg := (cAliasQRY)->NCOUNTREG
	(cAliasQRY)->(dbSkip())
END

ProcLogAtu( "MENSAGEM"	,  "REGISTROS: "+CVALTOCHAR(nCountReg) ,,,.T. )

IF SELECT(cAliasQRY) > 0
	DbSelectArea(cAliasQRY)
	DbCloseArea()
ENDIF

cQuery := "DELETE FROM "+cTableCV8+" "
cQuery += "WHERE "
cQuery += "		 "+cTableCV8+".D_E_L_E_T_ = ' ' "
cQuery += "AND 	 "+cTableCV8+".CV8_PROC	='"+cRotina+"' "

ProcLogAtu( "MENSAGEM"	, "QUERY DE EXCLUSAO" ,cQuery,,.T. )

nHndQry := TCSQLEXEC(cQuery)

IF nHndQry  >= 0
	ProcLogAtu( "MENSAGEM"	, "EXCLUSAO EFETUADA COM SUCESSO" ,cQuery,,.T. ) 
	lRet := .T.
ELSE
	ProcLogAtu( "ERRO"		, "ERRO NO PROCESSAMENTO DA EXCLUSAO"  ,cQuery+CRLF+TCSqlError(),,.T. )
	lRet := .F.
ENDIF

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc}PCAKDCHV

Retorna de uma determinada movimentação já existe no PCO, de forma
a evitar a duplicidade de lançamentos.

@author TOTVS MICROSIGA PROTHEUS
@since  01/01/2016
/*/
//-------------------------------------------------------------------
STATIC FUNCTION PCAKDCHV(cAKDProcess,cChvMovto)

LOCAL lRet   := .F.
LOCAL aArea  := GetArea()
LOCAL aAreaAKD  := AKD->(GetArea())

dbSelectArea("AKD")
DbOrderNickName("AKDCHAVEP") //AKD_FILIAL+AKD_CHAVE+AKD_PROCES+AKD_ITEM+AKD_SEQ
lRet := AKD->(DbSeek(xFilial("AKD")+cChvMovto+cAKDProcess))

RestArea(aAreaAKD)
RestArea(aArea)
RETURN lRet
//-------------------------------------------------------------------
/*/{Protheus.doc}CTPCOA10PAR

ENCAPSULA A CHAMADA DA PERGUNTE() PARA CONVERTER O RETORNO NO ARRAY APARAM

@author TOTVS MICROSIGA PROTHEUS
@since  01/01/2016
/*/
//-------------------------------------------------------------------

USER FUNCTION PCOA10PB(cPerg,aPARAM)

LOCAL lRet 	:= PERGUNTE(cPerg,.T.)
LOCAL nX	:= 0

For nX := 1 to Len(aPARAM)
	aPARAM[nX] := &("MV_PAR"+StrZero(nX,2))
Next nX

Return lRet
 
//-------------------------------------------------------------------
/*/{Protheus.doc}PCOA10VP
Valida se o processo selecionado é permitido na rotina

@author TOTVS MICROSIGA PROTHEUS
@since  01/01/2016
/*/
//-------------------------------------------------------------------
USER FUNCTION PCOA10VP(cMVPAR,cAKDProcess)

LOCAL lRet := .T.

IF ALLTRIM(&(cMVPAR)) != ALLTRIM(cAKDProcess)
	lRet := .F.
	ShowHelpDlg("CTPCOA10.PROCESSO",{"O processo selecionado não está disponível","para uso nesta rotina."},5,;
                               		{"1) Selecione para processamento a opção: "+cAKDProcess},5)
ENDIF


RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc}CRIASX1
Atualiza o SX1 criando as perguntas do grupo especificado                                                      

@author TOTVS MICROSIGA PROTHEUS
@since  01/01/2016
/*/
//-------------------------------------------------------------------

STATIC FUNCTION CRIASX1(cPerg,cAKDProcess)

LOCAL aArea := GetArea()
LOCAL aRegs := {}
LOCAL nloop1:= 0
LOCAL nLoop2:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variáveis utilizadas na criacao das PERGUNTAS 					     	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL aAKD_PROCES	:= TamSx3("AKD_PROCES")
LOCAL aCT2_FILIAL	:= TamSx3("CT2_FILIAL")
LOCAL aCT2_LOTE 	:= TamSx3("CT2_LOTE")
LOCAL aCT2_SBLOTE   := TamSx3("CT2_SBLOTE")
LOCAL aCT2_DOC		:= TamSx3("CT2_DOC")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas para parametrizacao da rotina (PARAMBOX)          		    ³
//³ MV_PAR01   - Processo de Integração                				     	³
//³ MV_PAR02   - Da Filial                                   				³
//³ MV_PAR03   - Até a Filial                                  				³
//³ MV_PAR04   - Da Data                                     				³
//³ MV_PAR05   - Até a Data                                    				³
//³ MV_PAR06   - Do lote                                                    ³
//³ MV_PAR07   - Até o lote                                          		³
//³ MV_PAR08   - Do sublote                                          		³
//³ MV_PAR09   - Até o sublote                                          	³
//³ MV_PAR10   - Do documento                                          		³
//³ MV_PAR11   - Até o documento                                          	³
//³ MV_PAR12   - Da moeda                                          			³
//³ MV_PAR13   - Do tipo de saldo                                          	³    
//³ MV_PAR14   - Para o tipo de saldo                                      	³
//³ MV_PAR15   - Atualiza saldo dos movtos                                 	³
//³ MV_PAR16   - Limpa movtos do periodo                                   	³
//³ MV_PAR17   - Limpa historico de processamento                          	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aRegs,{PADR(cPerg,10),"01","Processo de Integração     ","","","mv_ch1","C",06									,0,0,"G","NaoVazio() .AND. U_PCOA10VP('MV_PAR01','"+cAKDProcess+"')"   	,"MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","AKB"	,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"02","Da filial                  ","","","mv_ch2","C",aCT2_FILIAL[1]						,0,0,"G",""																,"MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","XM0"	,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"03","Até a filial               ","","","mv_ch3","C",aCT2_FILIAL[1]						,0,0,"G","NaoVazio()"   												,"MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","XM0"	,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"04","Da Data                    ","","","mv_ch4","D",08						         	,0,0,"G",""																,"MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"05","Até a Data                 ","","","mv_ch5","D",08						         	,0,0,"G","NaoVazio()"													,"MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"06","Do lote                    ","","","mv_ch6","C",aCT2_LOTE[1]						,0,0,"G",""																,"MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","09"	,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"07","Até o lote                 ","","","mv_ch7","C",aCT2_LOTE[1]						,0,0,"G","NaoVazio()"   												,"MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","09"	,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"08","Do sublote                 ","","","mv_ch8","C",aCT2_SBLOTE[1]						,0,0,"G",""																,"MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","SB"	,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"09","Até o sublote              ","","","mv_ch9","C",aCT2_SBLOTE[1]						,0,0,"G","NaoVazio()"   												,"MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SB"	,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"10","Do documento               ","","","mv_chA","C",aCT2_DOC[1]						,0,0,"G",""																,"MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"11","Até o documento            ","","","mv_chB","C",aCT2_DOC[1]						,0,0,"G","NaoVazio()"   												,"MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"12","Da moeda                   ","","","mv_chC","C",02									,0,0,"G","NaoVazio()"   												,"MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","CTO"	,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"13","Do tipo de saldo           ","","","mv_chD","C",01									,0,0,"G","NaoVazio()"   												,"MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","","SL"	,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"14","Para o tipo de saldo       ","","","mv_chE","C",02									,0,0,"G","NaoVazio()"   												,"MV_PAR14","","","","","","","","","","","","","","","","","","","","","","","","","AL2A"	,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"15","Atualiza saldos dos movtos	","","","mv_chF","N",01						         	,0,2,"C",""																,"MV_PAR15","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","",""		,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"16","Limpa movtos do periodo    ","","","mv_chG","N",01						         	,0,2,"C",""																,"MV_PAR16","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","",""		,"","","","",""})
AADD(aRegs,{PADR(cPerg,10),"17","Limpa hist.de processamento","","","mv_chH","N",01						         	,0,2,"C",""																,"MV_PAR17","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","",""		,"","","","",""})

//-------------------------------------------------------------------//
// Atualizacao do SX1 com os parametros criados						 //
//-------------------------------------------------------------------//
dbSelectArea("SX1")
dbSetorder(1)
For nLoop1 := 1 to Len(aRegs)
	If !dbSeek(PADR(cPerg,10)+aRegs[nLoop1,2])
		RecLock("SX1",.T.)
		For nLoop2 := 1 to FCount()
			FieldPut(nLoop2,aRegs[nLoop1,nLoop2])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next

//-------------------------------------------------------------------//
// Retorna ambiente original										 //
//-------------------------------------------------------------------//
RestArea(aArea)
RETURN
