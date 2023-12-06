#INCLUDE "FINA840.ch"
#include "PROTHEUS.CH"
#include "FOLDER.CH"
#INCLUDE "FWMVCDEF.CH"

#DEFINE 	_PL_	chr(13)+chr(10)
                                                 
STATIC aCtbTmp
STATIC lMod2	:= .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA840   ºAutor  ³Guilherme C. Leal   º Data ³  05/27/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina baseada na FINA840. Serve para geração de Recibos.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.          	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador³ Data   ³ BOPS   ³  Motivo da Alteracao                	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³J.Aurelio  ³01/11/01³NC001503³Em atualizacao bancaria, o "if" so a per-³±±
±±³           ³        ³        ³mite quando nTipo == 2, e a data de baixa³±±
±±³           ³        ³        ³esta pegando do arquivo SEL.             ³±±									
±±³J.Aurelio  ³03/12/01³11894   ³Em u_st840TudoOk, nao permitit que se ava  ³±±
±±³           ³        ³        ³-nce p/ segundo processo se data emissao ³±±								
±±³           ³        ³        ³estiver vazia.                           ³±±
±±³Sergio F.  ³20/02/02³13395   ³Ajuste na emissao do Recibo com o tipo   ³±±
±±³           ³        ³        ³"EF".                                    ³±±
±±³Paulo Aug. ³07/08/02³        ³Inclusao do Cobrador e Calculo da Comis. ³±±
±±³           ³        ³        ³para ele                                 ³±±
±±³C.Denardi  ³19/08/03³66207   ³Inclusao da opcao de modificar as colun. ³±±
±±³           ³        ³        ³exibidas do SA1,SE1, gravando no profile ³±±
±±³C.Denardi  ³11/09/03³66637   ³Retirar campo Memo do TwBrowse em SA1,SE1³±±
±±³Wagner     ³08/06/10³        ³Implementado campo Naatureza no Recibo   ³±±
±±³Montenegro ³        ³        ³Implementado tributação e contabilização ³±±
±±³           ³        ³        ³do ITF.                                  ³±±
±±³           ³        ³        ³Implementado consistencia na seleção de  ³±±
±±³           ³        ³        ³Bancos X Natureza e Bancos X Tipo Valor  ³±±
±±³Renan      ³14/03/11³        ³ARG = Novo painel de resumo de retenções ³±±
±±³Guedes     ³        ³        ³e simulação da contabilização.		    ³±±
±±³           ³        ³        ³                                         ³±±
±±³           ³        ³        ³Se agrega localización para MEX ya que   ³±±
±±³M.Camargo  ³22/07/14³        ³ocasionaba error al referenciar un objeto³±±
±±³           ³        ³        ³Se modifica array aCposFix ya que EL_TIPO³±±
±±³M.Camargo  ³30/07/14³        ³DOC debe permitir alteración.            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function xFina840(cNumFatAut,cDadosAdt,aRecAdt,xCabRec,xDocRec,xFormaRec,xOperacao)

	Local lPanelFin 	:= IsPanelFin()
	LOCAL nRecSE1   	:= SE1->(Recno())
	LOCAL nOrdSE1   	:= SE1->(IndexOrd())
	LOCAL nRecSA1   	:= SA1->(Recno())
	LOCAL nOrdSA1   	:= SA1->(IndexOrd())
	LOCAL bRestSE1  	:= { || SE1->(DbSetOrder(nOrdSE1)), SE1->(DbGoTo(nOrdSE1)), SA1->(DbSetOrder(nOrdSA1)), SA1->(DbGoTo(nOrdSA1)) }
	LOCAL cCodCliTit	:= ""
	LOCAL cLojCliTit	:= ""
	LOCAL cCgcCPFTit	:= ""
	LOCAL cNomCliTit	:= ""
	LOCAL cTelCliTit	:= ""
	LOCAL lIncAdt		:= .F.		//Angola
	Local lRet 			:= .T.

	Private aTotReceb,lDigita,nAtraso,lGeraLanc,lVenc,cArqTrab,nFiltro,cPerg
	Private lCancel		:= .F.
	Private lCarga		:= .F.
	Private lConsSaldo	:= .T.
	Private nRecno		:= 0
	Private nRecnoSAQ	:= 0
	Private nSaveSX8 	:= GetSX8Len()
	Private aLinSE1_Ori	:= {}
	Private aLinSA1_Ori := {}
	Private cCliLoj_Ori := ""
	PRIVATE lTrocaDtRef	:= .F.
	Private lCobrador	:= GetNewPar("MV_UTILCOB",.F.)
	Private lGeraDCam	:= (GetNewPar("MV_DIFCAMR","N") == "S")
	Private lTemMon		:= .F.
	Private lPercRA		:= (GetNewPar("MV_PERRA","N") == "S")
	Private nItensC		:= GETNEWPAR("MV_ITENSC",1)
	Private lTitAd		:= .F.
	Private lFindITF	:= .T.
	Private lRotAuto	:= xCabRec <> Nil
	Private oPanel
	Private oObjBkp
	Public lbax:= .t.
	Public LLINARR := .f.
	DEFAULT cNumFatAut	:= ""
	DEFAULT cDadosAdt	:= ""
	DEFAULT aRecAdt		:= {}

/*
 * Verificação do processo que está configurado para ser utilizado no Módulo Financeiro (Argentina)
 */
	If lMod2
		If lRotAuto
			If !FinModProc(.F.,@cTxtRotAut)
				lRet := .F.
			EndIf
		Else
			If !FinModProc()
				lRet := .F.
			EndIf
		EndIf
	EndIf

	If lRet
		If cPaisLoc $ "EQU|VEN"
			fa840SX3Fix()
			fa840SX7Fix()
		EndIf
	
	//Ajuste no dicionario devido a implementacao do Pagaré
	//FA840PGRFix()
	
		FINLoad() //Carrega a tabela Modos de Pago padrão
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso seja passado um numero de titulo verifica sua existencia.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet .And. !Empty(cNumFatAut)
		SE1->(DbSetOrder(1))
		If ! SE1->(DbSeek(xFilial("SE1")+cNumFatAut))
			Help(" ",1,"EXISTNUM")
			Eval(bRestSE1)
			lRet := .F.
		Else
			SA1->(DbSetOrder(1))
			If ! SA1->(DbSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA)))
				Help(" ",1,"EXISTCLI")
				Eval(bRestSE1)
				lRet := .F.
			Else
				cCodCliTit := SE1->E1_CLIENTE
				cLojCliTit := SE1->E1_LOJA
				cCgcCPFTit := SA1->A1_CGC
				cNomCliTit := SA1->A1_NOME
				cTelCliTit := SA1->A1_TEL
			Endif
		Endif
		If lRet
			Eval(bRestSE1)
		EndiF
	Endif

//ANGOLA
	If lRet .And. !Empty(cDadosAdt)
		lIncAdt	:= .T.
	
		SA1->(DbSetOrder(1))
		If ! SA1->(DbSeek(xFilial("SA1")+cDadosAdt))
			Help(" ",1,"EXISTCLI")
			Eval(bRestSE1)
			lRet := .F.
		Else
			cCodCliTit := SA1->A1_COD
			cLojCliTit := SA1->A1_LOJA
			cCgcCPFTit := SA1->A1_CGC
			cNomCliTit := SA1->A1_NOME
			cTelCliTit := SA1->A1_TEL
			aRecAdt	  := {}
		Endif
	Endif

	If lRet

		cPerg := "FIN87A"
	//Criação da pergunta 07 Considerar Filial
		AjustaSX1(cPerg)
	                          
		If SX6->(Dbseek(xfilial("SX6")+"MV_MDCFIN"))
			lTemMon	:=Iif(!Empty(GETMV("MV_MDCFIN")),.T.,.F.)
		EndIf
	
		If cPaisLoc<>"BRA"
			lCobrador:= .T.
		EndIf
	// Verifica se pode ser incluido mov. com essa data
		If  !(dtMovFin(dDataBase) )
			lRet := .F.
		EndIf
	
	//Carrega Pergunte
		If lRet .And. Empty(cNumFatAut) .and. !lIncAdt .AND. FunName()<>'FINA846'.And. !lRotAuto
			If lPanelFin
				If !PergInPanel(cPerg,.T.)
					Return .T.
				Endif
			ElseIf !pergunte(cPerg,.T.)
				lRet := .F.
			Endif
		ElseIf lRet
			pergunte(cPerg,.F.)
		Endif
	
	
		SX3->(DbSetOrder(2))
	
		If  !SX3->(DBSeek("EL_PREFIXO")) .Or. !X3USO(SX3->X3_USADO) .Or. ;
				!SX3->(DBSeek("EL_NUMERO"))  .Or. !X3USO(SX3->X3_USADO) .Or. ;
				!SX3->(DBSeek("EL_PARCELA")) .Or. !X3USO(SX3->X3_USADO) .Or. ;
				!SX3->(DBSeek("EL_BANCO"))   .Or. !X3USO(SX3->X3_USADO) .Or. ;
				!SX3->(DBSeek("EL_AGENCIA")) .Or. !X3USO(SX3->X3_USADO) .Or. ;
				!SX3->(DBSeek("EL_CONTA"))   .Or. !X3USO(SX3->X3_USADO) .Or. ;
				!SX3->(DBSeek("EL_TIPODOC")) .Or. !X3USO(SX3->X3_USADO)
	
			Alert(STR0097 + CHR(10) + CHR(10) + ;
				"EL_PREFIXO" + CHR(10) + ;
				"EL_NUMERO"  + CHR(10) + ;
				"EL_PARCELA" + CHR(10) + ;
				"EL_BANCO"   + CHR(10) + ;
				"EL_AGENCIA" + CHR(10) + ;
				"EL_CONTA"   + CHR(10) + ;
				"EL_TIPODOC")
	
			lCancel:=.T.
			SX3->(DbSetOrder(1))
			lRet :=  .F.
		EndIf
	
	//Corrige titulo da coluna Emissão do Recibo
		If lRet .And. SX3->(DBSeek("EL_EMISREC"))
			Reclock("SX3",.F.)
			Replace X3_TITULO With STR0154 //"Emissão Rec."
			Replace X3_TITSPA With STR0154 //"Emissão Rec."
			Replace X3_TITENG With STR0154 //"Emissão Rec."
			MsUnlock()
		Endif
	
		If lRet
			SX3->(DbSetOrder(1))
		
			cDocCred:=IIf(Empty(mv_par05).Or. !(mv_par05$MV_CRNEG+"|"+MVRECANT),"NCC",mv_par05)
		
		//ANGOLA
		//Forco o tipo de titulo de adiantamento para o parametro
			If cPaisLoc == "ANG" .and. lIncAdt
				cDocCred := SuperGetMV("MV_TPADTCD",.T.,Substr(MVRECANT,1,3))
			ElseIf cPaisLoc == "MEX"
				cDocCred := Substr(MVRECANT,1,3) // Sempre sera tipo RA no mexico
			Endif
		
			lDigita  	:= If( mv_par01==1,.T.,.F.)  // Mostra Lanctos.
			lAglutina	:= If( mv_par02==1,.T.,.F.)  // Aglutina Lanctos.
			lGeraLanc	:= If( mv_par03==1,.T.,.F.)  // Lanctos. On-Line
			lTrocaDtRef := If( mv_par06==1,.T.,.F.)  // Altera Data
			nFiltro		:= mv_par04
		
		EndIf
	
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica no Sigamat.acs se o usuario tem acesso à baixa de titulos.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF lRet .And. Versenha(30)
		While !lCancel
			lCancel:=.T.
			MontaTela(cNumFatAut,cCodCliTit,cLojCliTit,cCgcCPFTit,cNomCliTit,cNomCliTit,cTelCliTit,lIncAdt,aRecAdt)

			If ! Empty(cNumFatAut) .or. lIncAdt  .or. lRotAuto
				lCancel := .T.
			Endif

			If lCarga
				If !SuperGetMv('MV_SERREC') .And. __lSX8
					While ( GetSX8Len() > nSaveSX8 )
						RollBackSX8()
					Enddo
				EndIf
				Return !lCancel
			EndIf
		Enddo
		If !SuperGetMv('MV_SERREC') .And. __lSX8
			While ( GetSX8Len() > nSaveSX8 )
				RollBackSX8()
			Enddo
		EndIf
	Else
		lRet := .F.
		If !lRotAuto
			Alert(STR0001) //"Usuario sem permissão para acesso à essa rotina, verifique os acessos do usuario no Configurador."
		Else
			cTxtRotAut += STR0001 +" "+ CRLF
		EndIF
	Endif
// Desabilitar Teclas de Atalho
	If  lRet .And. !lRotAuto
		Set KEY 17 To
		Set KEY 23 To
		Set KEY 12 To
		Set KEY 13 To
	EndIF

Return lRet

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaTela ºAutor  ³Guilherme C. Leal   º Data ³  05/27/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta tela de operacao do Recibo.            			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function MontaTela(cNumFatAut,cCodCliTit,cLojCliTit,cCgcCPFTit,cNomCliTit,cNomCliTit,cTelCliTit,lIncAdt,aRecAdt)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a montagem da tela e seus objetos.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local nIndice 	:= 	""
	Local cSeek		:= 	""
	Local cWhi  	:= 	""
	Local cSelec	:= 	""
	Local cCondMca	:= 	""
	Local c_Alias 	:= 	""
	Local nBase		:= 	005
	Local aGrid		:=	{}
	Local aCpos		:=	{}
	Local aTam		:=	{}
	Local nTop := 0
	Local aCposExtra 	:={}
	Local aCposNo :={}
	Local cTitRec
	Local cTitEmis
	Local cTitCli
	Local cTitLoja
	Local cTitCGC
	Local cTitNom
	Local cTitTel
	Local cTitCob
	Local cTitProv
	Local lSalvou	:=	.F.
	Local cWhenRec
	Local aButtons := {}
	Local nY
	Local nX
	Local nI
	Local nZ
	Local nTotSEL := 0
	Local nTotRec := 0
	Local nMoedSE1 := 0
	Local nMoedSEL := 0
	Local nMotivo := 0
	Local nMot := 0
	Local nValSEL := 0
	Local nTitSE1 := 0
	Local nValaPg := 0
	Local nValDes := 0
	Local nValMul := 0
	Local nValJur := 0
	Local nValIRRF := 0
	Local nIRRF := 0
	Local nRecnSE1 := 0
	Local nPosTpDoc	:= 0
	Local nPosRet	:= 0
	Local nPosImp	:= 0
	Local nPosPref	:= 0
	Local nPosParc	:= 0
	Local nPosTipE1	:= 0
	Local nPosEstEF	:= 0
	Local nPosCFOEF := 0
	Local nPosBasEF	:= 0
	Local nPosAlqEF	:= 0
	Local nPosRetEF	:= 0
	Local nPosConEF	:= 0
	Local nPosNum	:= 0
	Local nPosPreEF	:= 0
	Local nPosNumEF	:= 0
	Local nPosParEF	:= 0
	Local nPosTipEF	:= 0
	Local nPosMoeda	:= 0
	Local aCertRet	:= {}
	Local aTmpLinRet	:= {}
	Local aInfGet  := Array(9)
	Local cF3Cli := "SA1"
	Local lPanelFin := IsPanelFin()
	LOCAL lWhenCli  := .T.
	LOCAL bWhenCli  := { || lWhenCli .And. nPanel==1  }
	Local cMasc3 :=	PesqPict("SE1","E1_VALOR",18)
	Local oSerie := Nil
	Local oRecibo := Nil
	Local oRevisao := Nil // Controle de Versionamento de Recibo de Cobrança
	Local aColsReten	:= {}
	Local aHeadReten	:= {}
	Local aAltReten		:= {}
	Local aListRes		:= {}
	Local aCabRes		:= {}
	Local aCtbRes		:= {}
	Local nPosHdMoed	:= 0
	Local aHeadCtb		:= {}
	Local aColsCtb		:= {}
	Local aAltCtb		:= {}
	Local lRet		:= .T.
	Local bFilt1 	:= {|| ((FJS->FJS_RCOP == "1") 	.and. (FJS->FJS_CARTE $ "1|3") .and. (FJS->FJS_FILIAL == xFilial("FJS")))}
	Local bFilt2 	:= {|| ((FJS->FJS_RCOP == "2") 	.and. (FJS->FJS_CARTE $ "1|3") .and. (FJS->FJS_FILIAL == xFilial("FJS")))}
	Local bFilt3 	:= {|| ((FJS->FJS_RCOP == "3") 	.and. (FJS->FJS_CARTE $ "1|3") .and. (FJS->FJS_FILIAL == xFilial("FJS")))}
	Local cChave	:= xFilial("FJS")
	Local cAlias	:= "FJS"
	Local cCampo	:= "FJS_TIPO"
	Local nOrder	:= 1
	Local lRatImp		:= GetMv("MV_RATIMP",.F.,"0")=="0"

//////////////////////////////////////////
//       Descricao do array aInfGet     //            
//////////////////////////////////////////
// 1 => Linha do Get                    //
// 2 => Coluna do Get                   //
// 3 => Largura do Get                  //
// 4 => Altura do Get                   //
// 5 => Obejto Pai (Macro Executavel)   //
// 6 => Valid do Get (Macro Executavel) //
// 7 => When do Get (Macro Executavel)  //
// 8 => Picture do Get                  //
// 9 => Inicializador Padrao            //
//////////////////////////////////////////


	Private cFunName	:= "FINA840"    // Usado pelo Profile
	Private cProfChave	:= "FINA84001"  // Usado pelo Profile
	Private aCposProf	:= {}			// Lista de campos gravados no Profile
	Private cTitSer
	Private lPreRec		:= .F.
	Private nQtMoedas	:= Moedfin()
	Private aMask		:= Array(nQtMoedas)
	Private aTitulo		:= {STR0002,STR0003,STR0004,STR0005,STR0171,STR0172}		//"Recibo [Resumo de Retenções]"##"Resumo [Simulação da Contabilização]"
	Private cTipos
	Private aRLocks		:= {}
	Private nPosCli		:= 0
	Private nPosLoja	:= 0
	Private nPosDesc	:= 0
	Private nPosJuros	:= 0
	Private nPosSaldo	:= 0
	Private nPosMulta	:= 0
	Private nPosMotBx	:= 0
	Private nPosImpRet  := 0
	Private nPosTipo
	Private anPosMoed	:= Array(nQtMoedas)
	Private oValOrig
	Private nValOrig	:= 0
	Private oSaldo
	Private nSaldo		:= 0
	Private oMoedOri
	Private cMoedOri	:= ""
	Private oRetCfg
	Private nRetCfg		:= 0
	Private oParciais
	Private nParciais	:= 0
	Private oValAbat
	Private nTotAbat	:= 0
	Private oDescont
	Private nDescont	:= 0
	Private oMulta
	Private nMulta		:= 0
	Private oJuros
	Private nJuros		:= 0
	Private oValRec
	Private nValRec		:= 0
	Private nValOri		:= 0
	Private oVlEstrang
	Private nValEstr	:= 0
	Private oCorrec
	Private nCorrec		:= 0
	Private aNomeMoed	:= {}
	Private cOrdSEL
	Private bSEL
	Private aCabSEL
	Private cOrdSA1
	Private bSA1
	Private aCabSA1
	Private cOrdSE1
	Private bSE1
	Private aCabSE1
	Private cMoed
	Private aLinMoed	:= Array(nQtMoedas)
	Private nBaxTit
	Private aLinBaixa
	Private oLBBaixa
	Private nPosBx
	Private aTaxa		:= Array(nQtMoedas)
	Private aoCB		:= Array(3)
	Private oOk			:= LoadBitMap(GetResources(), "LBOK")
	Private oNo			:= LoadBitMap(GetResources(), "LBNO")
	Private oNever		:= LoadBitMap(GetResources(), "DISABLE")
	Private oDlgRecibo
	Private oMasterPanel
	Private oPanelTop
	Private oLBMoed
	Private nQtPassos	:= 4
	Private aHeader		:= {}
	Private aCols		:= {}
	Private aLinRet		:= {}
	Private oGetSEL
	Private aHeadSE1
	Private aHeadSA1
	Private aCposSEL	:= {}
	Private aCposSA1	:= {}
	Private aCposSE1	:= {}
	Private nPanel		:= 1
	Private oPesq
	Private cSerie  	:= Criavar("EL_SERIE")
	Private cRecibo  	:= Criavar("EL_RECIBO")
	Private cRevisao	:= ""
	Private cNatureza	:= Criavar("EL_NATUREZ")
	Private lNatureza	:= .F.
	Private dDataRef 	:= dDatabase
	Private cCliente 	:= Space(TamSX3("EL_CLIENTE")[1])
	Private cLoja		:= Space(TamSX3("EL_LOJA")[1])
	Private cCliOri 	:= Space(TamSX3("EL_CLIENTE")[1])
	Private cLojOri		:= Space(TamSX3("EL_LOJA")[1])
	Private cNome		:= Space(TamSX3("A1_NOME")[1])
	Private cCGC		:= Space(TamSX3("A1_CGC")[1])
	Private cContato	:= Space(TamSX3("A1_CONTATO")[1])
	Private cTel		:= Space(TamSX3("A1_TEL")[1])
// Cobrador
	Private cCobrador	:= Space(TamSX3("EL_COBRAD")[1])
	Private cRecProv	:= Space(TamSX3("EL_RECPROV")[1])
	Private cPesq
	Private aLinReceb	:= {}
	Private oLBReceb
	Private aLinBX		:= {}
	Private oLBBx
	Private oMenu

	Private cTiposAdm   := GetSAETipos()
	Private oBtn		:= Array(10)
	Private lDecr		:= .F.
	Private aFiltros	:= {"","","",""}
	Private oPDesc
	Private nPercDesc	:= 0
	Private nDescTot	:= 0
	Private nPercGer	:= 0
	Private nDescGer	:= 0
	Private lConsFilial := If(mv_par07==1,.T.,.F.)
	Private nMoedDesc	:= 1
	Private cDiario		:= ""
	Private oAPerc
	Private nValPerc	:= 0
	Private aPerc		:= {}
	Private nAliqPerc	:= 0

	Private cMotBx := Space(TamSx3("E5_MOTBX")[1])
	Private cMotBxSE1 := cMotBx
	Private aDescMotbx:={}
	Private aMotbx:={}
	Private aDadosAdm:={}

	Private nLastPan	:= 4  //ANGOLA - Numero do ultimo painel
	Private cCalcITF   := SuperGetMv("MV_CALCITF",.F.,"2")
	Private aLinSE1 := {}
	Private oRetTit
	Private aColsSEL	:= {}
	Private aHeaderSEL	:= {}
	Private oRetRes
	Private oDtCtb
	Private oLtCtb
	Private dDtCtb		:= ""
	Private cLtCtb		:= ""
	Private oSimCtb
	Private oCtbDeb
	Private oCtbCre
	Private nCtbDeb		:= 0
	Private nCtbCre		:= 0
	Private nTotSE1 := 0
	Private cCredMed	:= ""
	Private cCredInm	:= ""
	Private cCertRet	:= ""
	Private oSize
	Private CORD	:= ""
	Private _lCustom	:= .t.
	DEFAULT cNumFatAut := ""
	DEFAULT cCodCliTit := ""
	DEFAULT cLojCliTit := ""
	DEFAULT cCgcCPFTit := ""
	DEFAULT cNomCliTit := ""
	DEFAULT cTelCliTit := ""

//ANGOLA - Inclusao de adiantamento
	DEFAULT lIncAdt	:= .F.
	DEFAULT aRecAdt	:= {}


/*
 * Controle de Versionamento de Recibo de Cobrança
 */
	DbSelectArea("SEL")
	cRevisao := PADL("0",TamSX3("EL_VERSAO")[1],"0")


	cCredMed	:=	FinGetTipo(bFilt1,cAlias,cChave,cCampo,nOrder)
	cCredInm	:=	FinGetTipo(bFilt2,cAlias,cChave,cCampo,nOrder)
	cCertRet	:=	FinGetTipo(bFilt3,cAlias,cChave,cCampo,nOrder)

	cCredMed	:=	IIf(Empty(cCredMed),GetSESNew("CH","3"),cCredMed)
	cCredInm	:=	IIf(Empty(cCredInm),"TF /EF /CC /CD ",cCredInm)
	cTiposAdm   :=  IIf(Empty(cTiposAdm),"TJ",cTiposAdm)

	If ! Empty(cNumFatAut)
		lWhenCli := .F.
	Endif

//ANGOLA - Inclusao de adiantamento
	If lIncAdt
		nLastPan := 2
		lWhenCli := .F.
	Endif

	If cPaisLoc $ "COS"
		nQtPassos 	:= 4
		nLastPan	:= 4
	ElseIf !cPaisLoc $ 'URU|BOL|PTG|ANG|PER|ARG'
		nQtPassos 	:= 5
		nLastPan	:= 5
	Else
		nQtPassos 	:= 6
		nLastPan	:= 6
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Apos declaracao das variaveis, inicia montagem da tela.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	Posicione("SX3",2,"EL_SERIE"	,"X3_TITULO")
	cTitSer := AllTrim(X3TITULO())
	Posicione("SX3",2,"EL_RECIBO"	,"X3_TITULO")
	cWhenRec:=If(Empty(SX3->X3_WHEN),".T.",SX3->X3_WHEN)

	If cPaisLoc $ "BRA#PTG#ANG"
		cTitRec := STR0006 //Recibo
	Else
		cTitRec := AllTrim(X3TITULO())
	Endif

	Posicione("SX3",2,"EL_EMISSAO"	,"X3_TITULO")
	cTitEmis:= AllTrim(X3TITULO())
	Posicione("SX3",2,"EL_CLIENTE"	,"X3_TITULO")
	cTitCli := AllTrim(X3TITULO())
	Posicione("SX3",2,"EL_LOJA"		,"X3_TITULO")
	cTitLoja:= AllTrim(X3TITULO())
	Posicione("SX3",2,"A1_CGC"		,"X3_TITULO")
	cTitCGC := AllTrim(X3TITULO())
	Posicione("SX3",2,"A1_NOME"		,"X3_TITULO")
	cTitNom := AllTrim(X3TITULO())
	Posicione("SX3",2,"A1_TEL"		,"X3_TITULO")
	cTitTel := AllTrim(X3TITULO())
	Posicione("SX3",2,"EL_COBRAD"	,"X3_TITULO")
	cTitCob:= AllTrim(X3TITULO())
	Posicione("SX3",2,"EL_RECPROV","X3_TITULO")
	cTitProv:= AllTrim(X3TITULO())

	If !lRotAuto
		aSize := MSADVSIZE()

		oSize := FwDefSize():New(.T.)
	
		oSize:lLateral := .F.
	
		oSize:AddObject("MASTER",100,100,.T.,.T.)
	
		oSize:lProp := .T.
	
		oSize:Process()

	//DEFINE MSDIALOG oDlgRecibo TITLE STR0006 From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL //"Recibo"
		DEFINE MSDIALOG oDlgRecibo TITLE STR0006 From oSize:aWindSize[1],oSize:aWindSize[2] To oSize:aWindSize[3],oSize:aWindSize[4] OF oMainWnd PIXEL //"Recibo"
		odlgRecibo:lMaximized := .T.
	EndIf

	If ExistBlock("F087AF3")
		cF3Cli := ExecBlock("F087AF3",.F.,.F.)
	EndIf
	If !lRotAuto

		oMasterPanel := TPanel():New(oSize:GetDimension("MASTER","LININI"),;
			oSize:GetDimension("MASTER","COLINI"),;
			,oDlgRecibo,,,,,,oSize:GetDimension("MASTER","XSIZE"),;
			oSize:GetDimension("MASTER","YSIZE"),.F.,.F.)
									
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Cria campos do cabecalho.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		oPanelTop := TPanel():New(000,000,,oMasterPanel,,,,,,370,70,.F.,.F.)
		oPanelTop:Align := CONTROL_ALIGN_TOP
	
		@ 001, 001 TO 070,390  OF oPanelTop  PIXEL //"Dados Gerais"
		nTop+=003
		If SuperGetMV('MV_SERREC')
			@ nTop+3,005 SAY STR0140 				Size 040,015 Pixel 	Of oPanelTop  //"Serie/Recibo"
			@ nTop+1,050 MSGET oSerie Var cSerie	Size 020,008 Pixel 	Of oPanelTop PICTURE PesqPict("SEL","EL_SERIE",TamSX3("EL_SERIE")[1]) F3 "RN"  Valid Fa840Ser(@cSerie, @cRecibo) HASBUTTON When nPanel==1
			@ nTop+3,085 SAY OemtoAnsi("-") 							Of oPanelTop PIXEL
			@ nTop+1,090 MSGET oRecibo Var cRecibo	Size 075,008 Pixel 	Of oPanelTop When (nPanel==1 .And. &(cWhenRec)) Valid {||FA840Vld('cRecibo',cNumFatAut)}
		/*
		 * Controle de Versionamento de Recibo de Cobrança
		 */
			@ nTop+3,168 SAY STR0203				Size 100,015 Pixel 	Of oPanelTop //"Revisão"
			@ nTop+1,190 MSGET oRevisao Var cRevisao Size 030,008 Pixel Of oPanelTop WHEN .F.
		Else
			@ nTop+3,005 SAY cTitRec 				Size 040,015 Pixel 	Of oPanelTop  //"Recibo"
			@ nTop+1,045 MSGET oRecibo Var cRecibo	Size 075,008 Pixel 	Of oPanelTop When  (nPanel==1 .And. &(cWhenRec)) Valid {||FA840Vld('cRecibo',cNumFatAut)}
		/*
		 * Controle de Versionamento de Recibo de Cobrança
		 */
			@ nTop+3,135 SAY STR0203				Size 120,015 Pixel 	Of oPanelTop //"Revisão"
			@ nTop+1,160 MSGET oRevisao Var cRevisao Size 030,008 Pixel Of oPanelTop WHEN .F.
		Endif
	
		nTop+=013
	
		@ nTop+3,005 SAY cTitEmis 					SIZE 040,015 PIXEL OF oPanelTop   //"Emissao"
		@ nTop+1,035 MSGET oDataRef Var dDataRef	Size 054,008 Pixel Of oPanelTop VALID IIf(dtMovFin(dDataRef) ,.T.,.F.) When lTrocaDtReF // VALID {|| FAMoedas(dDataRef),RefData(3),".T."}When nPanel==1
	
		@ nTop+3,100 SAY STR0165 					SIZE 050,015 PIXEL OF oPanelTop   // "Natureza"
		@ nTop+1,130 MSGET cNatureza F3 "SED"		SIZE 085,008 When nPanel==1 Valid F840VldNat(cNatureza,cCalcITF,@lNatureza) PIXEL of oPanelTop HASBUTTON
	EndIf

	If ! Empty(cNumFatAut) .or. lIncAdt  //ANGOLA
		cCliente	:= cCodCliTit
		cLoja		:= cLojCliTit
		cCGC		:= cCgcCPFTit
		cNome		:= cNomCliTit
		cTel		:= cTelCliTit
	Endif
	If !lRotAuto
		nTop+=013
		@ nTop+3,005 SAY cTitCli 					Size 040,015 Pixel Of oPanelTop		//"Cliente"
		@ nTop+1,035 MSGET oCliente Var cCliente 	Size 050,008 Pixel Of oPanelTop PICTURE	PesqPict("SEL","EL_CLIENTE",TamSX3("EL_CLIENTE")[1]) F3 cF3Cli VALID F840ValCli(@cCliente,@cLoja) HASBUTTON When Eval(bWhenCli)
		@ nTop+3,090 SAY cTitLoja 					Size 040,015 Pixel Of oPanelTop		//"Loja"
		@ nTop+1,120 MSGET oLoja Var cLoja			Size 020,008 Pixel Of oPanelTop PICTURE	PesqPict("SEL","EL_LOJA",TamSX3("EL_LOJA")[1]) VALID Iif(ExistCpo("SA1",cCliente+cLoja), (F840ValCli(@cCliente,@cLoja) .And. FA840AtuCli(cNumFatAut)),.F.) When Eval(bWhenCli)
		@ nTop+3,180 SAY cTitCGC					Size 030,015 Pixel Of oPanelTop		//"CGC"
		@ nTop+1,215 MSGET cCGC 					Size 055,008 Pixel Of oPanelTop	PICTURE	PesqPict("SA1","A1_CGC",TamSX3("A1_CGC")[1]) When If(cPaisLoc=="CHI" .and. nPanel==1,.T.,.F.)
	
		nTop+=013
		@ nTop+3,005 SAY cTitNom 					Size 040,015 Pixel Of oPanelTop		//"Nome"
		@ nTop+1,035 MSGET cNome 					Size 235,008 Pixel Of oPanelTop	When .F.
	
		nTop+=013
		@ nTop+3,005 SAY cTitTel 					Size 040,015 Pixel Of oPanelTop		//"Tel. "
		@ nTop+1,035 MSGET cTel  					Size 040,008 Pixel Of oPanelTop	PICTURE	PesqPict("SA1","A1_TEL",TamSX3("A1_CGC")[1]) When .F.
	
		If  lCobrador
			@ nTop+3,090 SAY cTitCob				Size 040,015 Pixel Of oPanelTop		//Cobrador
			@ nTop+1,120 MSGET cCobrador			Size 050,008 Pixel Of oPanelTop	PICTURE	PesqPict("SEL","EL_COBRAD",TamSX3("EL_COBRAD")[1])	F3 "SAQ" Valid {||FA840Cob("1")} HASBUTTON When nPanel==1
		EndIf
		
		If cPaisLoc <>"BRA"
			@ nTop+3,180 SAY cTitProv				Size 040,015 Pixel Of oPanelTop		//Recibo Provisorio
			@ nTop+1,215 MSGET cRecProv				Size 075,008 Pixel Of oPanelTop	PICTURE	PesqPict("SEL","EL_RECPROV",TamSX3("EL_RECPROV")[1]) Valid {||FA840Cob("2")} When nPanel==1  //	F3 "SA1" VALID If(CheckSX3("EL_COBRAD",.T.,If(cContato=space(cContato),.t.,.f.)), When nPanel==1
		EndIf
	EndIf
	If  UsaSeqCor()
		SX3->(DbSetorder(2))
		SX3->(DbSeek("EL_DIACTB"))
		cDiario		:=	Criavar("EL_DIACTB",.T.)
		cTitDiar	:=	AllTrim(X3TITULO())
		IF !lRotAuto
			@ nTop+3,305 SAY cTitDiar					Size 040,015 Pixel Of oPanelTop	//Recibo Provisorio
			@ nTop+1,340 MSGET cDiario F3 SX3->X3_F3	Size 020,008 Pixel Of oPanelTop HASBUTTON When CtbWdia() Valid CTBvldDiario(cDiario,dDataBase)
		EndIf
		SX3->(DbSetorder(1))
	Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Cria barra onde ficarao as informacoes referentes a cada Grid.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If !lRotAuto
		If lPanelFin
			oPanBut:= TPanel():New(055,000,,oMasterPanel,,,,,,570,15,.F.,.F.)
			oPanBut:Align := CONTROL_ALIGN_TOP
		Else
			oPanBut:= TPanel():New(087,000,,oMasterPanel,,,,,,370,15,.F.,.F.)
			oPanBut:Align := CONTROL_ALIGN_TOP
			oPanBut:nHeight := 35
		Endif

		@ 000,000 BITMAP oBmp RESNAME "TOOLBAR" NOBORDER ADJUST PIXEL OF oPanBut
		oBmp:Align := CONTROL_ALIGN_ALLCLIENT
		cPesq := Space(50)
	
		@ 001,251 MSGET oPesq VAR cPesq Size 070,008 Pixel Of oPanBut ON CHANGE FA840Buscar(lIncAdt) When (nPanel < nlastPan .And. nPanel < 4)
		nBase:=001
	
		@003,350 SAY STR0222  SIZE 45,8 PIXEL OF oPanBut //Alt. Valor de Baixa
		@001,410 COMBOBOX oCBX VAR cOrd ITEMS {STR0223,STR0224} SIZE 25,15 PIXEL  OF oPanBut WHEN nPanel == 3
		
		@001,001 BTNBMP oBtn[1] RESOURCE "PREV" 		SIZE 25,25 ACTION (nPanel -= 1,FA840AValPan(nPanel,nLastPan),ShowPanel(nPanel, @oPanel,cNumFatAut,lIncAdt))				OF oPanBut WHEN nPanel > 1
		@001,030 BTNBMP oBtn[2] RESOURCE "NEXT" 		SIZE 25,25 ACTION (IIF(u_st840TudoOk(cNumFatAut,lIncAdt),(nPanel +=1,ShowPanel(nPanel, @oPanel,cNumFatAut,lIncAdt)),))	OF oPanBut WHEN nPanel < nLastPan
		@001,070 BTNBMP oBtn[10] RESOURCE "BMPINCLUIR"	SIZE 25,25 ACTION (A840Marca())		   																				OF oPanBut WHEN !lIncAdt .and. nPanel == 2
		@001,105 BTNBMP oBtn[4] RESOURCE "BMPINCLUIR"	SIZE 25,25 ACTION (A840Sugerir())		   																				OF oPanBut WHEN nPanel == 3 .and. !lIncAdt .And. ValType(aLinSE1[1][Len(aLinSE1[1])-1]) == "N"
		@001,155 BTNBMP oBtn[5] RESOURCE "PRECO"		SIZE 25,25 ACTION (A840Desconto())		 																				OF oPanBut WHEN (nPanel >= 3 .And. nPanel < 5) .and. !lIncAdt
		@001,374 BTNBMP oBtn[6] RESOURCE "FILTRO"		SIZE 25,25 ACTION (A840Filtrar(nPanel,cNumFatAut))																		OF oPanBut WHEN (nPanel > 1) .And. (nPanel < nLastPan .And. nPanel < 4)
		@001,400 BTNBMP oBtn[7] RESOURCE "VCDOWN"		SIZE 25,25 ACTION (lDecr:=.F.,Fa840Ord(nPanel),oBtn[7]:Hide(),oBtn[8]:Show())	   										OF oPanBut WHEN (nPanel < nLastPan .And. nPanel < 4)
		@001,400 BTNBMP oBtn[8] RESOURCE "VCUP"			SIZE 25,25 ACTION (lDecr:=.T.,Fa840Ord(nPanel),oBtn[8]:Hide(),oBtn[7]:Show())	   										OF oPanBut WHEN (nPanel < nLastPan .And. nPanel < 4)
		@001,645 BTNBMP oBtn[9] RESOURCE "PESQUISA"		SIZE 25,25 ACTION (aoCB[1]:SetFocus(),FA840Buscar(lIncAdt))	   														OF oPanBut WHEN (nPanel < nLastPan .And. nPanel < 4)
	
		oBtn[1]:cToolTip := STR0022 //"Voltar   (Ctrl+Q)"
		oBtn[2]:cToolTip := STR0023 //"Avancar   (Ctrl+W)"
	//oBtn[3]:cToolTip := STR0014 //"Salvar Pré-Recibo (Ctrl+P)"
		oBtn[4]:cToolTip := STR0064 //"Sugerir"
		oBtn[5]:cToolTip := STR0065 //"Desconto Geral"
		oBtn[6]:cToolTip := STR0066 //"Filtrar"
		oBtn[7]:cToolTip := STR0067 //"Ordem Descrescente"
		oBtn[8]:cToolTip := STR0068 //"Ordem Crescente"
		oBtn[9]:cToolTip := STR0024 //"Buscar (Ctrl+L)"
		oBtn[10]:cToolTip :=STR0111 // "Inverte Selecao (Ctrl+M)"
		oBtn[7]:Hide()
	
		SetKEY(17,oBtn[1]:bAction)
		SetKEY(23,oBtn[2]:bAction)
	//SetKEY(16,oBtn[3]:bAction)
		SetKEY(12,oBtn[9]:bAction)
		SetKEY(13,oBtn[10]:bAction)
		oPanel := {}
	EndIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Devolve todos os tipos de Titulos validos.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cTipos := GetSESTipos({|| ES_BXRCOP == "1"},"1")

	cTipos += "/"+MVNOTAFIS+"/"+MVRECANT+"/"+"DP /FT /NV /"
	If Right(Trim(MV_CRNEG),1) == "," //Se encontrar uma virgula retira
		cTipos += Left(Trim(MV_CRNEG),Len(MV_CRNEG)-1)
	Else
		ctipos += Trim(MV_CRNEG)
	EndIf
	If cPaisloc $ "COS"
		cTipos += "/LTR/"
	EndIf
	If cPaisloc $ "BRA/PTG"
		cTipos += "/CH /LJ /"
	Else
		cTipos += "/NDC/DC"
	Endif
	If  ExistBLock('A087TIPTI')
		cTipos	+=	ExecBlock('A087TIPTI',.F.,.F.)
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Cria um panel para cada passo.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

//ANGOLA
//Nao mostrar a tela de selecao de titulos a baixar
//na inclusão de adiantamento
	If lIncAdt
		aoCB 	:= Array(1)
		nQtPassos := nLastPan
		nI:=1
		aNomeMoed := {}
		For nI := 1 To nQtMoedas
			cTitMoed:= SuperGetMv("MV_MOEDA"+Alltrim(Str(nI)))
			AAdd(aNomeMoed,cTitMoed)
		Next nI
	Endif
	If !lRotAuto
		nx:= 1
		For nx := 1 to nQtPassos
			Aadd(oPanel,TPanel():New(000,000,,oMasterPanel,,,,,,350,110,.F.,.F.))
			nPan := nX
		Next

	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄ
//³PANEL 1	 ³
//ÀÄÄÄÄÄÄÄÄÄÄ
	c_Alias 	:= "SEL"
	nIndice 	:= 1
	cSeek		:= "ZZZZZZ"
	cSelec	:= ".F."
	cWhi  	:= ".F."
	nPainel	:= 1

	AAdd(aCposNo,"EL_FILIAL")
	AAdd(aCposNo,"EL_SERIE")
	AAdd(aCposNo,"EL_RECIBO")
	AAdd(aCposNo,"EL_DTDIGIT")
	AAdd(aCposNo,"EL_CANCEL")
	AAdd(aCposNo,"EL_PREREC")
	AAdd(aCposNo,"EL_CLIENTE")
	AAdd(aCposNo,"EL_LOJA")
	AAdd(aCposNo,"EL_VLMOED1")
	AAdd(aCposNo,"EL_COBRAD")
	AAdd(aCposNo,"EL_RECPROV")
	AAdd(aCposNo,"EL_CLIORIG")
	AAdd(aCposNo,"EL_LOJORIG")
	AAdd(aCposNo,"EL_TPCRED")

	aGrid	:= FA840Head(c_Alias,,.F.,aCposNo)   	//MOnta cabecalho

	aHeader	:=	aClone(aGrid[1])			// Campo + Tamanho + Titulo + Descricoes, etc....
	aCposSEL:=	aClone(aGrid[2])			// Somente campos validos
	aCabSEL	:=	aClone(aGrid[3])			// Somente Titulo dos campos que estao no aCposSEL

/*
Monta a array com os campos que poderao ser alterados */
	ACpoAlter := {}
//aCposFix := {"EL_TIPODOC","EL_TRANSIT","EL_TPCRED"}
	aCposFix := {"EL_TPCRED"}//{"EL_TIPODOC","EL_TPCRED"}
	If !lRotAuto
		For nI := 1 To Len(aHeader)
			If Ascan(aCposFix,{|cpo| AllTrim(cpo) == AllTrim(aHeader[nI,2])}) == 0
				Aadd(aCpoAlter,aHeader[nI,2])
			Endif
		Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Monta linhas de acordo com os campos acima definidos.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		aC:={}
		aCols:= u_ARTELCHEQUE(aC,aCposSEL,1)
	//	aCols 	:= MontaGrid(c_Alias,cWhi,cSelec,.F.,".F.",cSeek,nIndice,aCposSEL)
		 
	EndIf

	If !lRotAuto
		Private aRotina := { { "RDMAKE" ,"SIGAIXB", 0 , 3}}
		AADD(aRotina,aClone(aRotina[1]))
		AADD(aRotina,aClone(aRotina[1]))
	
		oPanel[nPainel]:Align := CONTROL_ALIGN_ALLCLIENT
	
		oGetSEL	:= MSGetDados():New(000,000,109,331,Iif(lCarga,4,1),"Fa840LinOk(.F.)","Fa840TudoOk(cNumFatAut,lIncAdt)",,.T.,aCpoAlter,,.F.,,"a840FldOk()",,,"A840DelLin()",oPanel[nPainel])
		oGetSel:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
		cOrdSEL	:= aCabSEL[1]
		bSEL	:= {|u| If( PCount() == 0, cOrdSEL, cOrdSEL:= u ) }
	
		//aoCB[1]	:= TComboBox():New(001,205,bSEL,aCabSEL,040,015,oPanBut, ,{||FA840Ord(1,)} , , , ,.t.,,,,)
	EndIF
//ÚÄÄÄÄÄÄÄÄÄÄ
//³PANEL 2	 ³
//ÀÄÄÄÄÄÄÄÄÄÄ
//ANGOLA - Inclusao de adiantamentos nao tera a tela de selecao de titulosclientes
	If !lIncAdt
		nIndice	:= 1
		c_Alias 	:= "SA1"
		cSeek	:= "ZZZZZZZZ"
		cWhi  	:= ".F."
		cSelec	:= ".F."
		cCondMca:= ".F."
		nPainel	:= 2
	
	///////////////////////////////////////////////////////
	// Verifica se existe lista de campos para cliente   //
	// no Profile do usuario, para que possa resgata-la  //
	///////////////////////////////////////////////////////
		If ( FindProfDef(cUserName,cFunName,cProfChave,c_Alias) )
			aCposProf := A840Prof(c_Alias)
			aGrid	  := FA840Head(c_Alias,Aclone(aCposProf),.T.)   	//Monta cabecalho
		Else
			aGrid	:= FA840Head(c_Alias,,.T.)   	//Monta cabecalho
		Endif
		aHeadSA1:= aClone(aGrid[1])
		aCposSA1:= aClone(aGrid[2])
		aCabSA1	:= aClone(aGrid[3])
		aTam	:= aClone(aGrid[4])
	
		If !lRotAuto
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Monta linhas de acordo com os campos acima definidos.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			aLinSA1	:= MontaGrid(c_Alias,cWhi,cSelec,.T.,cCondMca,cSeek,nIndice,aCposSA1,lIncAdt)  //ANGOLA
			oPanel[nPainel]:Align := CONTROL_ALIGN_ALLCLIENT
			oLBCli	:= TwBrowse():New(000,000,000,000,,aCabSA1,aTam,oPanel[nPainel],,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oLBCli:Align := CONTROL_ALIGN_ALLCLIENT
			oLBCli:lColDrag	:= .T.
			oLBCli:nFreeze	:= 1
			oLBCli:SetArray(aLinSA1)
			cBLinSA1:= "{If(aLinSA1[oLBCli:nAt,1]>0,oOk,If(aLinSA1[oLBCli:nAt,1]<0,oNo,oNever))"
			oLBCli:bLDblClick :={ || aLinSA1[oLBCli:nAt,1] := aLinSA1[oLBCli:nAT,1] * -1}
			nI:=2
			For nI:= 2 to Len(aCposSA1)
				c_Picture:= Alltrim(Posicione("SX3",2,aCposSA1[nI],"X3_PICTURE"))
				cBLinSA1:= cBLinSA1 + ", Transform(aLinSA1[oLBCli:nAT][" + alltrim(Str(nI))+ "], '" + c_Picture + "')"
			Next nI
			oLBCli:bLine:= { || &(cBLinSA1 + "}") }
		
			cOrdSA1 := aCabSA1[2]
			bSA1	:= {|u| If( PCount() == 0, cOrdSA1, cOrdSA1:= u ) }
			aoCB[2]	:= TComboBox():New(001,205,bSA1,aCabSA1,040,015,oPanBut, ,{||FA840Ord(2)} , , , ,.t.,,,,)
		EndIf
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄ
//³ PANEL 3	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄ
//ANGOLA - Inclusao de adiantamentos nao tera a tela de selecao de titulos
	If !lIncAdt

		c_Alias 	:= "SE1"
		nIndice 	:= 2
		cWhi  	:= ".F."
		cCondMca	:= ".F."
		cSelec	:= ".F."
		cSeek	:= "ZZZZZZZZ"
		nPainel	:= 3
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Execblock para poder modificar os campos no Lisbox do SE1.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If ExistBlock("FA087COL")
			aCpos := ExecBlock("FA087COL",.F.,.F.)
		Else
		///////////////////////////////////////////////////////
		// Verifica se existe lista de campos para titulo    //
		// no Profile do usuario, para que possa resgata-la  //
		///////////////////////////////////////////////////////
			If ( FindProfDef(cUserName,cFunName,cProfChave,c_Alias) )
				aCpos := A840Prof(c_Alias)
			Else
				aCpos	:= {	"E1_PREFIXO","E1_NUM"	,"E1_PARCELA"	,"E1_TIPO"		,"E1_EMISSAO", ;
					"E1_MOEDA"	,"E1_VALOR"	,"E1_SALDO"		,"E1_DESCONT"	,"E1_JUROS", ;
					"E1_MULTA" 	,"E1_VENCREA"}
			
				DbSelectArea("SX3")
				DbSetOrder(1)
				DbSeek(c_Alias,.F.)
				Do While !EOF() .And. X3_ARQUIVO == Alltrim(c_Alias)
					If x3uso(x3_usado) .And. cNivel >= X3_NIVEL .And. AScan(aCpos,Alltrim(X3_CAMPO))==0
						AAdd(aCpos,X3_CAMPO)
					Endif
					DbSkip()
				Enddo
			Endif
		Endif
	
	///////////////////////////////////////////////////
	// Rastreia aCpos para retirar campos do tipo MEMO
	// Necessario ser desta forma, devido ao ponto de
	//   entrada do usuario, que pode criar a aCols com
	//   campo tipo MEMO
		cAliasBM := Alias()
		DbSelectArea( "SX3" )
		DbSetOrder(2)
		For nZ := 1 to Len(aCpos)
			DbSeek( Alltrim(aCpos[nZ]) )
			If ( X3_TIPO = "M" )
				Adel( aCpos, nZ )
				Asize( aCpos, Len(aCpos)-1 )
			Endif
		Next nZ
		SX3->(DbSetOrder(1))
		DbSelectArea( cAliasBM )
	
	     
		aGrid	    := FA840Head(c_Alias,Aclone(aCpos),.T.) //Monta cabecalho
		aHeadSE1	:= aClone(aGrid[1])
		aCposSE1	:= aClone(aGrid[2])
		aCabSE1		:= aClone(aGrid[3])
		aTam		:= aClone(aGrid[4])
	
		If !lConsFilial
			aAux:=CposToHead({"E1_FILIAL"})
			AEval(aAux,{|x| AAdd(aHeadSE1,x)})
			AAdd(aCposSE1,"E1_FILIAL")
			AAdd(aCabSE1 ,X3Titulo())
			AAdd(aTam    ,12)
		EndIf
		nI:=0
		for nI:=1 to nQtMoedas
			&("nBxMoeda" + Alltrim(Str(nI))) := 0
		Next nI
		nBaixar	:=0
		nDescTot	:=0
		nDescSE1	:=0
		nJurSE1	:=0
		nMultaSE1	:=0
		nImpRetSE1 := 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Apos montagem dos campos insere campos que sao|
	//³indispensaveis para o funcionamento da rotina.|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	//				 Variavel			Titulo			 		 Tamanho
		AAdd(aCposExtra,{"nBaixar"		,STR0025				,25}) //"Vlr. Baixa"
		AAdd(aCposExtra,{"nDescTot"	,STR0069  			,25}) //Valor de desconto geral, rateado pelo item //"Desc. Geral"
		nI:=0
		for nI:=1 to nQtMoedas
			AAdd(aCposExtra,{"nBxMoeda" + Alltrim(Str(nI)),STR0026 + SuperGetMv("MV_MOEDA"+ Alltrim(Str(nI))),25}) //"Bx "
		Next nI
		AAdd(aCposExtra,{"nDescSE1"	,STR0027					,25,}) //"Descontos"
		AAdd(aCposExtra,{"nJurSE1"		,STR0028					,25,}) //"Juros"
		AAdd(aCposExtra,{"nMultaSE1"	,STR0029					,25,}) //"Multa"
		AAdd(aCposExtra,{"cMotBxSE1"	,Posicione("SX3",2,"E5_MOTBX","X3Titulo()"),25}) //"Motivo da Baixa"
		if  cPaisLoc == "COS"
			AAdd(aCposExtra,{"nImpRetSE1"	,"Imp. Retido",25}) //"Retenção"
		endif
		nI:=1
		For nI:=1 To Len(aCposExtra)
			AAdd(aCposSE1	,aCposExtra[nI][1])
			AAdd(aCabSE1	,aCposExtra[nI][2])
			AAdd(aTam		,aCposExtra[nI][3])
		Next nI
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Monta linhas de acordo com os campos acima definidos.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
		If !lRotAuto
			aLinSE1	:= MontaGrid(c_Alias,cWhi,cSelec,.T.,cCondMca,cSeek,nIndice,aCposSE1,.T.)
			oPanel[nPainel]:Align := CONTROL_ALIGN_ALLCLIENT
			oLBSE1	:= TwBrowse():New(000,000,000,000,,aCabSE1,aTam,oPanel[nPainel],,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oLBSE1:Align := CONTROL_ALIGN_ALLCLIENT
			oLBSE1:lColDrag	:= .T.
			oLBSE1:nFreeze	:= 1
			oLBSE1:SetArray(aLinSE1)
			cBLinSE1 := "{If(aLinSE1[oLBSE1:nAt,1]>0,oOk,If(aLinSE1[oLBSE1:nAt,1]<0,oNo,oNever))"
			oLBSE1:bLDblClick :={ || A840Pagtos(oLBSE1:nAt,cNumFatAut,(oCBX:nAt == 1))}

			nMx := AScan(aCposSE1,"E1_MOEDA")
			nI:=2
			For nI:= 2 to Len(aCposSE1)
				nX3:=AScan(aHeadSE1,{|x| Alltrim(x[2])==Alltrim(aCposSE1[nI])})
				If nX3>0 .And. aHeadSE1[nX3][8]=="N" .And. aHeadSE1[nX3][4]>=9
					cBLinSE1:= cBLinSE1 + ", Transform(aLinSE1[oLBSE1:nAT][" + Alltrim(Str(nI))+ "], PesqPict('SE1',aHeadSE1[" + alltrim(Str(nX3)) + "][2],18,IIf(nMx>0,aLinSE1[oLBSE1:nAT][" + Alltrim(Str(nMx)) + "],NIL)))"
				ElseIf Substr(aCposSE1[nI],1,1) == 'n'
					cBLinSE1:= cBLinSE1 + ", Transform(aLinSE1[oLBSE1:nAT][" + Alltrim(Str(nI))+ "],'@R 999,999.99')"
				Else
					cBLinSE1:= cBLinSE1 + ", aLinSE1[oLBSE1:nAT][" + alltrim(Str(nI))+ "]"
				Endif
			Next nI
			oLBSE1:bLine:= { || &(cBLinSE1 + "}") }
		
			cOrdSE1 := aCabSE1[2]
			bSE1	:= {|u| If( PCount() == 0, cOrdSE1, cOrdSE1:= u ) }
			aoCB[3]	:= TComboBox():New(001,205,bSE1,aCabSE1,040,015,oPanBut, ,{||FA840Ord(3)} , , , ,.t.,,,,)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Montagem do panel de pagto.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			oPPagto:=TPanel():New(84,100,,oMasterPanel,,,,,,232,150,.F.,.T.)
		
			nT1:=03
			@ nT1,002 GROUP oGrp1 TO 113+if(cPaisLoc == "COS", 14,0), 116 LABEL OemToAnsi(STR0030) OF oPPagto  PIXEL //"Valores da Baixa" //"Valores da Baixa"
			@ nT1,115 GROUP oGrp1 TO 113+if(cPaisLoc == "COS", 14,0), 230 LABEL " " OF oPPagto  PIXEL

		EndIF
		aMotBx := ReadMotBx()
		For NI := 1 to Len(aMotBx)
			If substr(aMotBx[nI],34,01) == "A" .or. substr(aMotBx[nI],34,01) =="R"
				AADD( aDescMotbx,substr(aMotBx[nI],07,10))
			EndIf
		next
		If !lRotAuto
			bMotBx :={|u| If( PCount() == 0, cMotBx, cMotBx:= u ) }
			nT1+=09
			@ nT1,004 SAY OemToAnsi(STR0098) SIZE 53, 07 OF oPPagto PIXEL //"Motivo Baixa"
			oMotBx :=TComboBox():New(nT1,046,bMotBx,aDescMotbx,066,010,oPPagto, , ,{|| F840MotBx()}, , ,.T.,,,,)
		
			@ nT1,120 SAY OemToAnsi( STR0032 )  SIZE 53,07 OF oPPagto PIXEL //"= a Receber"
			@ nT1,162 MSGET oSaldo VAR nSaldo 	SIZE 66, 10 OF oPPagto PIXEL When .F. Picture cMasc3 //"@E 999,999,999,999.99"
			nT1+=14
			@ nT1,004 SAY OemToAnsi( STR0031 ) SIZE 53, 10 OF oPPagto PIXEL //"Valor Original"
			@ nT1,046 MSGET oValOrig VAR nValorig SIZE 66, 10 OF oPPagto PIXEL When .F. Picture cMasc3 //"@E 999,999,999,999.99"
		
			@ nT1,120 SAY OemToAnsi( STR0033 ) SIZE 53, 07 OF oPPagto PIXEL //"Moeda Original"
			@ nT1,162 MSGET oMoedOri Var cMoedOri SIZE 66, 10 OF oPPagto PIXEL When .F.
		EndIf
		aCposBaixa	:={"cMoeda", "nBxMoed"}
		aCabBaixa	:={STR0034, STR0035} //"Moedas"###"Baixar"
		aTamBaixa	:={45,50}
		aLinBaixa	:=Array(nQtMoedas)
	
		nPosBx := Ascan(aCposSE1,"nBaixar")
		nValRec:= IIf(!lRotAuto,aLinSE1[oLBSE1:nAt][nPosBx],0)
		nI:=1
		aNomeMoed := {}
		For nI := 1 To nQtMoedas
			cTitMoed:= SuperGetMv("MV_MOEDA"+Alltrim(Str(nI)))
			AAdd(aNomeMoed,cTitMoed)
			anPosMoed[nI]:=AScan(aCposSE1,"nBxMoeda" + Alltrim(Str(nI)))
			aLinBaixa[nI]:={SuperGetMV("MV_MOEDA"+Alltrim(Str(nI))),iIf(!lRotAuto,aLinSE1[oLBSE1:nAt][anPosMoed[nI]], 0)}
		Next nI
		IF !lRotAuto
			nT1+=14
			oLBBaixa:=TwBrowse():New(nT1,120,000,000,,aCabBaixa,aTamBaixa,oPPagto,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oLBBaixa:lHScroll:=.F.
			oLBBaixa:lVScroll:= .T. //nQtMoedas>5
			oLBBaixa:nHeight	:=112
			oLBBaixa:nWidth	:=209
			oLBBaixa:SetArray(aLinBaixa)
			oLBBaixa:bLine 	:= { || {aLinBaixa[oLBBaixa:nAT][1],;
				Transform(aLinBaixa[oLBBaixa:nAT][2],PesqPict("SE1","E1_VALOR",18,oLBBaixa:nAT))}}
			oLBBaixa:bLDblClick := {|| DCLBBaixa()}
		
			nT1+=02
			@ nT1,004 SAY OemToAnsi( STR0102 ) SIZE 53, 10 OF oPPagto PIXEL //"- Abatimentos"
			@ nT1,046 MSGET oValAbat VAR nTotAbat SIZE 66, 10 OF oPPagto PIXEL HASBUTTON When .F. Picture cMasc3 //"@E 999,999,999,999.99"
		
			If cPaisLoc == "COS"
				nT1+=14
				@ nT1,004 SAY OemToAnsi( "- " + STR0173 ) SIZE 53, 07 OF oPPagto PIXEL  //"Retenções"
				@ nT1,046 MSGET oRetCfg Var nRetCfg	SIZE 66, 10 OF oPPagto PIXEL HASBUTTON When .F.  Picture cMasc3
			EndIf
			
			nT1+=14
			@ nT1,004 SAY OemToAnsi( STR0036 ) SIZE 53, 07 OF oPPagto PIXEL  //"- Baixas Parciais"
			@ nT1,046 MSGET oParciais Var nParciais	SIZE 66, 10 OF oPPagto PIXEL HASBUTTON When .F.  Picture cMasc3
			nT1+=14
			@ nT1,004 SAY OemToAnsi( STR0037 ) SIZE 53, 07 OF oPPagto PIXEL  //"- Descontos"
			@ nT1,046 MSGET oDescont VAR nDescont	SIZE 66, 10 OF oPPagto PIXEL HASBUTTON ON CHANGE(FAPagtoAtu()) When !(aLinSE1[oLBSE1:nAt][AScan(aCposSE1,"E1_TIPO")]$MVRECANT+"/"+MV_CRNEG .Or. oMotBx:nAt>1) Picture cMasc3
			nT1+=14
			@ nT1,004 SAY OemToAnsi( STR0070 ) 	SIZE 53, 07 OF oPPagto PIXEL //"+ Multa"
			@ nT1,046 MSGET oMulta VAR nMulta  		SIZE 66, 10 OF oPPagto PIXEL HASBUTTON ON CHANGE(FAPagtoAtu()) When !(aLinSE1[oLBSE1:nAt][AScan(aCposSE1,"E1_TIPO")]$MVRECANT+"/"+MV_CRNEG .Or. oMotBx:nAt>1)Picture cMasc3
			nT1+=14
			@ nT1,004 SAY OemToAnsi( STR0038 ) 	SIZE 53, 07 OF oPPagto PIXEL //"+ Juros"
			@ nT1,046 MSGET oJuros VAR nJuros  		SIZE 66, 10 OF oPPagto PIXEL HASBUTTON ON CHANGE(FAPagtoAtu()) When !(aLinSE1[oLBSE1:nAt][AScan(aCposSE1,"E1_TIPO")]$MVRECANT+"/"+MV_CRNEG .Or. oMotBx:nAt>1)Picture cMasc3
		
			@ nT1,120 SAY OemToAnsi( STR0039 )  SIZE 53,07 OF oPPagto PIXEL //"Valor a Baixar"
			@ nT1,162 MSGET oValRec VAR nValRec 	SIZE 66, 10 OF oPPagto PIXEL HASBUTTON  WHEN .F. Picture cMasc3
		
			oPPagto:NCLRPANE:= RGB(233,233,233) //13165800
			DEFINE SBUTTON FROM 128,170  TYPE 1  ACTION (Fa840BaixaOK(cNumFatAut)) OF oPPagto When .T.
			DEFINE SBUTTON FROM 128,200  TYPE 2  ACTION (oPPagto:Hide(),oPanBut:lReadOnly:=.F.,oPanel[3]:lReadOnly:=.F.,a840Lock(oLBSE1:nAt,.F.)) OF oPPagto When .T.
			oPPagto:Hide()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³ Montagem do PANEL de Descontos³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			oPDesc:=TPanel():New(84,00,,oMasterPanel,,,,,,127,117,.F.,.T.)
		
			@ 003,001 GROUP oGrp TO 103, 123 LABEL OemToAnsi(STR0027) OF oPDesc  PIXEL  //"Descontos"
		
			@ 015,005 SAY OemToAnsi( STR0045 ) SIZE 55, 07 OF oPDesc PIXEL  //"Valores expressos em "
			oCBMoed1:= TComboBox():New(015,065,bSEL,aNomeMoed,055,020,oPDesc, ,{|| nMoedDesc:=oCBMoed1:nAt, aInfGet[8]:=PesqPict("SE1","E1_VALOR",18,nMoedDesc), F840Get(aInfGet,@nDescTot)} , , , ,.T.,,,,)
		
			@ 030,005 SAY OemToAnsi(STR0071) SIZE 60,07	OF oPDesc PIXEL //"Percentual"
			@ 030,065 MSGET oPercDesc Var nPercDesc	SIZE 55,09 	OF oPDesc PIXEL When nDescTot==0 Picture "@R 99.99" HASBUTTON
		
			@ 045,005 SAY OemToAnsi(STR0072) SIZE 60,07	OF oPDesc PIXEL //"Valor do Desconto"

		// Valoriza array aInfGet com os dados necessarios para a montagem do GET.
			aInfGet[1] := 045
			aInfGet[2] := 065
			aInfGet[3] := 55
			aInfGet[4] := 09
			aInfGet[5] := "oPDesc"
			aInfGet[6] := ".T."
			aInfGet[7] := "nPercDesc == 0"
			aInfGet[8] := PesqPict("SE1","E1_VALOR",18,nMoedDesc)
			aInfGet[9] := nDescTot
		
		// Cria o get para o campo do desconto geral...
			F840Get(aInfGet,@nDescTot)

			oPDesc:NCLRPANE:= RGB(233,233,233) ///13165800
			DEFINE SBUTTON FROM 104,063  TYPE 1  ACTION (A840OKDesc(cNumFatAut)) OF oPDesc When .T.
			DEFINE SBUTTON FROM 104,093  TYPE 2  ACTION (oPDesc:Hide(),oPanBut:lReadOnly:=.F.,oPanel[nPainel]:lReadOnly:=.F.) OF oPDesc When .T.
		
			oPDesc:Hide()
		EndIF
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ PANEL 4	- Resumo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	nPainel	:= If(lIncAdt,2,4)
	If !lRotAuto
		nT1		:= 003
		aSize := MSADVSIZE()
		nRight 	:= ((aSize[5]/2)-330)/2
	
		@ nT1,001+nRight GROUP oGrp3 TO 085,168+nRight LABEL OemToAnsi(STR0040) OF OPANEL[nPainel]  PIXEL  //"Valores Recebidos"
		@ nT1,172+nRight GROUP oGrp4 TO 085,340+nRight LABEL OemToAnsi(STR0041) OF OPANEL[nPainel]  PIXEL  //"Titulos Baixados"
		@ 088,001+nRight GROUP oGrp5 TO 109,340+nRight 							OF OPANEL[nPainel]  PIXEL
	
		aCabRec	:={STR0042, STR0043 } //"Tipo"###"Valor"
		aTamRec	:={050,060}
		AAdd(aLinReceb,{"",0})

		oPanel[nPainel]:Align := CONTROL_ALIGN_ALLCLIENT
		oLBReceb := TwBrowse():New(012,004+nRight,000,000,,aCabRec,aTamRec,OPANEL[nPainel],,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oLBReceb:SetArray(aLinReceb)
		oLBReceb:bLine 	:= { ||{aLinReceb[oLBReceb:nAT][1], Transform(aLinReceb[oLBReceb:nAT][2],cMasc3) }}
		oLBReceb:lHScroll	:= .F.
		oLBReceb:nHeight	:= 140
		oLBReceb:nWidth		:= 320
	
		aCabBx	:={STR0042, STR0043 } //"Tipo"###"Valor"
		aTamBx	:={050,060}

		AAdd(aLinBX,{"",0})
		oLBBx := TwBrowse():New(012,175+nRight,000,000,,aCabBx,aTamBx,OPANEL[nPainel],,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oLBBx:SetArray(aLinBx)
		oLBBx:bLine 	:= { ||{aLinBX[oLBBx:nAT][1], Transform(aLinBX[oLBBx:nAT][2],cMasc3) }}
		oLBBx:lHScroll	:= .F.
		oLBBx:nHeight	:= 140
		oLBBx:nWidth	:= 320
	EndIF
	nTotal:=0
	nTotalBx:=0

	If !lRotAuto
		@ 096,005+nRight SAY OemToAnsi( STR0044 )	SIZE 020,007 OF OPANEL[nPainel] PIXEL  //"Saldo Final"
		@ 093,035+nRight MSGET oTotal Var nTotal	SIZE 070,009 OF OPANEL[nPainel] PIXEL When .F.  Picture cMasc3
		@ 096,175+nRight SAY OemToAnsi( STR0045 ) 	SIZE 040,007 OF OPANEL[nPainel] PIXEL  //"Valores expressos em "
	EndIF

	FAMoedas(dDataRef,cNumFatAut)
	If !lRotAuto
		oCBMoed:= TComboBox():New(093,220+nRight,bSEL,aNomeMoed,070,020,oPanel[nPainel], ,{||RefData(If(lIncAdt,2,4),cNumFatAut,lIncAdt)} , , , ,.t.,,,,)
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄ
//³ PANEL 5 ³
//ÀÄÄÄÄÄÄÄÄÄÄ

//Cria o painel do resumo de retenções
	If cPaisLoc $ 'URU|BOL|PTG|ANG|PER|ARG|MEX' .And. !lRotAuto
		nPainel	:= 5

		aSize 	:= MSADVSIZE()
		nRight	:=((aSize[5]/2)-330)/2

		@ 003,001+nRight GROUP oGrp7 TO 109,340+nRight Label STR0173	OF OPANEL[nPainel]  PIXEL		//"Retenções"
		@ 115,001+nRight GROUP oGrp8 TO 182,340+nRight Label STR0174 	OF OPANEL[nPainel]  PIXEL		//"Resumo de retenções"

		oPanel[nPainel]:Align := CONTROL_ALIGN_ALLCLIENT

	//Cria aHeader e campos editaveis do quadro de retenções
		aHeadReten	:= {}
		aAltReten	:= {}
		For nX := 1 To Len(aHeader)
			If (AllTrim(aHeader[nX,2]) $ "EL_TIPODOC|EL_PREFIXO|EL_NUMERO|EL_PARCELA|EL_VALOR|EL_EMISSAO|EL_DTVCTO|")
				AADD(aHeadReten,aHeader[nX])
				If (AllTrim(aHeader[nX,2]) == "EL_VALOR")
					AADD(aAltReten,aHeader[nX,2])		//Adiciona o campo VALOR no array de campos editáveis
					aHeadReten[Len(aHeadReten),6] := "Positivo() .And. NaoVazio()"		//Altera a validação do campo VALOR
				EndIf
			EndIf
		Next nX

	//Cria coluna de moeda
		nPosHdMoed := ASCAN(aHeader,{|aCpo| AllTrim(aCpo[2]) == "EL_MOEDA" })
		AADD(aHeadReten,aHeader[nPosHdMoed])

	//Cria coluna de ordenação das retenções
		AADD(aHeadReten,{STR0204 ,"ORDEM","@E 9",1,0,"","","N","",""}) // "Ord. Ret."

	//Cria aCols do quadro de retenções
		aColsReten := Array(1,Len(aHeadReten)+1)
		For nX := 1 To (Len(aHeadReten)-1)
			aColsReten[1,nX] := CriaVar(aHeadReten[nX,2])
		Next nX
		aColsReten[1,Len(aHeadReten)]	:= 9
		aColsReten[1,Len(aHeadReten)+1] := .F.

	//Browse das retenções
		oRetTit := MsNewGetDados():New(012,005+nRight,106,337+nRight,GD_UPDATE,"AllwaysTrue()","AllwaysTrue()", ,aAltReten,000,999,"FA840RetVld()","","AllwaysTrue()",oPanel[nPainel],aHeadReten,aColsReten)
		oRetTit:Refresh()
 	   
	//Cria aHeader do quadro de resumo das retenções
		aCabRes := {STR0175,STR0176}		//"Descricao"##"Valor"

	//Cria aCols do quadro de resumo das retenções
		aListRes := {}
		If cPaisLoc $ "URU|BOL"
			Aadd(aListRes,{STR0217   ,0})       //"IRIC"
			Aadd(aListRes,{STR0218	,0})       //"IR"
			Aadd(aListRes,{STR0181	,0})       //"TOTAL"
		ElseIf cPaisLoc == "PTG"
			Aadd(aListRes,{STR0177	,0})       //"IVA"
			Aadd(aListRes,{STR0219   ,0})       //"IRC"
			Aadd(aListRes,{STR0181	,0})       //"TOTAL"
		ElseIf cPaisLoc == "ANG"
			Aadd(aListRes,{STR0220	,0})        //"RIE"
			Aadd(aListRes,{STR0181	,0})	    //"TOTAL"
		ElseIf cPaisLoc == "PER"
			Aadd(aListRes,{STR0221	,0})       //"IGV"
			Aadd(aListRes,{STR0218	,0})       //"IR"
			Aadd(aListRes,{STR0181	,0})	    //"TOTAL"
		ElseiF cPaisLoc == "ARG"
			AADD(aListRes,{STR0177	,0})		//"Retenção de IVA"
			AADD(aListRes,{STR0178	,0})		//"Retenção de Ganancias"
			AADD(aListRes,{STR0179	,0})		//"Retenção de Ingressos Brutos"
			AADD(aListRes,{STR0180	,0})		//"Retenção de SUSS"
			AADD(aListRes,{STR0181	,0})		//"TOTAL"
		EndIf
	//oRetRes := MsNewGetDados():New(216,005+nRight,247,337+nRight,GD_UPDATE,"AllwaysTrue()","AllwaysTrue()", , ,000,999,"AllwaysTrue()","","AllwaysTrue()",oPanel[nPainel],aHeadRes,aColsRes)
		oRetRes := TwBrowse():New(124,005+nRight,000,000+nRight,,aCabRes,{200,100},oPanel[nPainel],,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oRetRes:SetArray(aListRes)
		oRetRes:lHScroll:= .F.
		If Len(aListRes) > 0
			oRetRes:bLine	:= {|| { oRetRes:aArray[oRetRes:nAt][1], LTrim(Transform(oRetRes:aArray[oRetRes:nAt][2],PesqPict("SEL","EL_VALOR",TamSX3("EL_VALOR")[1]))) } }
		EndIf
		oRetRes:nHeight	:= 110
		oRetRes:nWidth	:= 525+nRight
		oRetRes:Refresh()
	EndIf
                 
	If !cPaisLoc == "COS" .And. !lRotAuto
	//ÚÄÄÄÄÄÄÄÄÄÄ
	//³ PANEL 6 ³
	//ÀÄÄÄÄÄÄÄÄÄÄ
	//Cria o painel da simulação da contabilização
		nPainel := If( !cPaisLoc $ 'URU|BOL|PTG|ANG|PER|ARG',5,6)
		aSize 	:= MSADVSIZE()
		nRight	:=((aSize[5]/2)-330)/2
	
		@ 003,001 GROUP oGrp9 TO ((aSize[6]/2)-80),((aSize[5]/2)) Label STR0188	OF OPANEL[nPainel]  PIXEL		//"Simulação dos lançamentos contábeis"
	
		oPanel[nPainel]:Align := CONTROL_ALIGN_ALLCLIENT
	
		dDtCtb := ""
		cLtCtb := ""
	
		@ 017,005 SAY OemToAnsi(STR0183)	SIZE 020,015 OF OPANEL[nPainel] PIXEL  //"Data"
		@ 015,030 MSGET oDtCtb Var dDtCtb	SIZE 040,008 OF OPANEL[nPainel] PIXEL When .F.  Picture PesqPict("CT2","CT2_DATA",8,1)
		@ 017,090 SAY OemToAnsi(STR0184)	SIZE 020,015 OF OPANEL[nPainel] PIXEL  //"Lote"
		@ 015,115 MSGET oLtCtb Var cLtCtb	SIZE 040,008 OF OPANEL[nPainel] PIXEL When .F.
	
		oDtCtb:CtrlRefresh()
		oLtCtb:CtrlRefresh()

	//Cria aHeader da simulação da contabilização
		dbSelectArea("SX3")
		dbSetOrder(1)
		dbGoTop()
		SX3->(dbSeek("CT2"))
		While !EoF() .And. AllTrim(SX3->X3_ARQUIVO) == "CT2"
			If (!(AllTrim(SX3->X3_CAMPO) $ "CT2_FILIAL|CT2_DATA|CT2_LOTE|CT2_SBLOTE|CT2_DOC|CT2_MOEDLC|") .And. X3USO(SX3->X3_USADO) .And. (cNivel >= SX3->X3_NIVEL) .And. (Upper(AllTrim(SX3->X3_CONTEXT)) != "V")) .Or. (AllTrim(SX3->X3_CAMPO) $ "CT2_LINHA|")
				AADD(aHeadCtb, {TRIM(X3TITULO()), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,;
					SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT})
			EndIf
			dbSkip()
		EndDo
	
	//Cria aCols da simulação da contabilização
		aColsCtb := Array(1,Len(aHeadCtb)+1)
	//For nX := 1 To Len(aHeadCtb)
		//aColsCtb[1,nX] := CriaVar(aHeadCtb[nX,2])
	//Next nX
		aColsCtb[1,Len(aHeadCtb)+1] := .T.
	
	//MsNewGetDados da simulação da contabilização
		aAltCtb := {}
		oSimCtb := MsNewGetDados():New(035,005,290,465+nRight,GD_UPDATE,"AllwaysTrue()","AllwaysTrue()", , aAltCtb,000,999,"AllwaysTrue()","","AllwaysTrue()",oPanel[nPainel],aHeadCtb,aColsCtb)
		oSimCtb:Refresh()
    
		nCtbDeb := 0
		nCtbCre := 0
    
		@ 302,005 SAY OemToAnsi(STR0185)	SIZE 040,015 OF OPANEL[nPainel] PIXEL  //"Total Débito"
		@ 300,050 MSGET oCtbDeb Var nCtbDeb	SIZE 100,008 OF OPANEL[nPainel] PIXEL When .F.  Picture PesqPict("CT2","CT2_VALOR",17,1)
		@ 302,200 SAY OemToAnsi(STR0186)	SIZE 040,015 OF OPANEL[nPainel] PIXEL  //"Total Crédito"
		@ 300,250 MSGET oCtbCre Var nCtbCre	SIZE 100,008 OF OPANEL[nPainel] PIXEL When .F.  Picture PesqPict("CT2","CT2_VALOR",17,1)
	
		oCtbDeb:CtrlRefresh()
		oCtbCre:CtrlRefresh()
	EndIf

	If !lRotAuto
		OPANEL[nPainel]:NCLRPANE:= RGB(233,233,233) //13165800
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³ INICIALIZA TELA	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
		ShowPanel(1,@oPanel,cNumFatAut,lIncAdt)
	
	
	/////////
	// Botoes
		Aadd( aButtons, {"RPMDES",{ || A840CFG() }, STR0128,STR0145} ) // "Configurador de campos" ###"Config."
	EndIf
	
	If ! Empty(cNumFatAut)
		FA840AtuCli(cNumFatAut)
	Endif

	If !lRotAuto
		If lPanelFin
			ACTIVATE DIALOG oDlgRecibo ON INIT (If(Type("bFunAuto")=="B",Eval(bFunAuto),),FaMyBar(oDlgRecibo,{|| MsAguarde({|| lRet := lSalvou := FA840RetOk(nPanel,nLastPan) .And. Fa840Salvar(NIL,NIL,cNumFatAut,lIncAdt,aRecAdt)}),If(lSalvou,oDlgRecibo:End(),Nil) },{|| MsAguarde({|| Fa840Cancel(nPanel,nLastPan)}),oDlgRecibo:End()},aButtons))
		Else
			ACTIVATE DIALOG oDlgRecibo ON INIT  (If(Type("bFunAuto")=="B",Eval(bFunAuto),), EnchoiceBar(oDlgRecibo,{|| MsAguarde({|| lRet := lSalvou := FA840RetOk(nPanel,nLastPan) .And. Fa840Salvar(NIL,NIL,cNumFatAut,lIncAdt,aRecAdt)}),If(lSalvou,oDlgRecibo:End(),Nil) },{|| MsAguarde({|| Fa840Cancel(nPanel,nLastPan)}),oDlgRecibo:End()},,aButtons))
		Endif
	Else
		cRecibo := xCabRec[Ascan(xCabRec,{|x| AllTrim(x[1]) == "FJT_RECIBO"})][2]
		cSerie := xCabRec[Ascan(xCabRec,{|x| AllTrim(x[1]) == "FJT_SERIE"})][2]
		cCliente := xCabRec[Ascan(xCabRec,{|x| AllTrim(x[1]) == "FJT_CLIENT"})][2]
		cLoja := xCabRec[Ascan(xCabRec,{|x| AllTrim(x[1]) == "FJT_LOJA"})][2]
		cNatureza := xCabRec[Ascan(xCabRec,{|x| AllTrim(x[1]) == "FJT_NATURE"})][2]
		cCobrador := xCabRec[Ascan(xCabRec,{|x| AllTrim(x[1]) == "FJT_COBRAD"})][2]
		cRecProv := xCabRec[Ascan(xCabRec,{|x| AllTrim(x[1]) == "FJT_RECPRV"})][2]
		nPosDesc  := AScan(aCposSE1,"nDescSE1")
		nPosJuros := AScan(aCposSE1,"nJurSE1")
		nPosMulta := AScan(aCposSE1,"nMultaSE1")
		nPosSaldo := AScan(aCposSE1,"E1_SALDO")
		nPosMotBx := AScan(aCposSE1,"cMotBxSE1")
		Aadd(aCposSE1,"nImpRetSE1")
		nPosImpRet := ASCAN(aCposSE1,"nImpRetSE1")
		nPosValBx := AScan(aCposSE1,"nBaixar")
		nMoedSE1 := AScan(aCposSE1,"E1_MOEDA")
		nTotSE1 := 0
		nTotSEL := 0
		nTotRec := 0
		MV_PAR05 := IIF(Ascan(xCabRec,{|x| AllTrim(x[1]) == "TMP"}) > 0, xCabRec[Ascan(xCabRec,{|x| AllTrim(x[1]) == "TMP"})][2] ,)
	
		Aadd(aCols,Array(Len(aHeader)+1))
		For nZ := 1 to Len(xFormaRec)
			If nZ > 1
				Aadd(aCols,Array(Len(aHeader)+1))
			EndIf
			nValSEL := AScan(xFormaRec[nZ],{|x| AllTrim(x[1]) == "EL_VALOR"})
			nMoedSEL := AScan(xFormaRec[nZ],{|x| AllTrim(x[1]) == "EL_MOEDA"})
			nPosNum := AScan(xFormaRec[nZ],{|x| AllTrim(x[1]) == "EL_NUMERO"})
			nPosRet := Ascan(xFormaRec[nZ],{|formarec| formarec[1] == "RET"})
			For nY:=1 to Len(aHeader)
				For nX:=1 to Len(xFormaRec[nZ])
					If Alltrim(xFormaRec[nZ][nX][1]) == Alltrim(aHeader[nY][2])
						If Alltrim(aHeader[nY][8]) == "C"
							aCols[nZ][nY] :=  Padr(xFormaRec[nZ][nX][2],aHeader[nY][4] )
						Else
							aCols[nZ][nY] :=  xFormaRec[nZ][nX][2]
						EndIf
						If Alltrim(aHeader[nY][2])  $  "EL_TIPO/EL_TIPODOC/EL_NUMERO/EL_VALOR/EL_MOEDA/EL_EMISSAO"
							If 	Empty(aCols[nZ][nY])
								cTxtRotAuto += aHeader[nY][2] + "  :=  " + STR0230 // "    ----> Campo obrigatório. "
								lMsErroAuto := .T.
								lRet:= .F.
								Exit
							Else
								If Alltrim(aHeader[nY][2]) == "EL_TIPODOC"			/* agrupo os documentos de retencao */
									If Upper(Alltrim(aCols[nZ,nY])) $ "RS|RL|RB|RI|RG"
										Aadd(aTmpLinRet,{Upper(Alltrim(aCols[nZ,nY])),xFormaRec[nZ,nPosNum,2],xFormaRec[nZ,nValSel,2],xFormaRec[nZ,nMoedSel,2],{}})
										If cPaisLoc == "ARG"
											If !lRatImp
												If nPosRet > 0
													nPosEstEF := Ascan(xFormaRec[nZ,nPosRet,2],{|x| Upper(AllTrim(x[1])) == "FE_EST"})
													nPosCFOEF := Ascan(xFormaRec[nZ,nPosRet,2],{|x| Upper(AllTrim(x[1])) == "FE_CFO"})
													nPosBasEF := Ascan(xFormaRec[nZ,nPosRet,2],{|x| Upper(AllTrim(x[1])) == "FE_VALBASE"})
													nPosAlqEF := Ascan(xFormaRec[nZ,nPosRet,2],{|x| Upper(AllTrim(x[1])) == "FE_ALIQ"})
													nPosRetEF := Ascan(xFormaRec[nZ,nPosRet,2],{|x| Upper(AllTrim(x[1])) == "FE_RETENC"})
													If Upper(Alltrim(aCols[nZ,nY])) == "RS"
														nPosConEF := Ascan(xFormaRec[nZ,nPosRet,2],{|x| Upper(AllTrim(x[1])) == "A2_CONCSUS"})
													ElseIF  Upper(Alltrim(aCols[nZ,nY])) == "RG"
														nPosConEF := Ascan(xFormaRec[nZ,nPosRet,2],{|x| Upper(AllTrim(x[1])) == "A2_AGREGAN"})
													Else
														nPosConEF := 0
													Endif
													nPosImp:= Len(aTmpLinRet)
													Aadd(aTmpLinRet[nPosImp,5],{})
													nZ := Len(aTmpLinRet[nPosImp,5])
													Aadd(aTmpLinRet[nPosImp,5,nZ],xFormaRec[nZ,nPosRet,2,nPosEstEF,2])
													Aadd(aTmpLinRet[nPosImp,5,nZ],xFormaRec[nZ,nPosRet,2,nPosCFOEF,2])
													If nPosConEF > 0
														Aadd(aTmpLinRet[nPosImp,5,nZ],xFormaRec[nZ,nPosRet,2,nPosConEF,2])
													Endif
													Aadd(aTmpLinRet[nPosImp,5,nZ],xFormaRec[nZ,nPosRet,2,nPosBasEF,2])
													Aadd(aTmpLinRet[nPosImp,5,nZ],xFormaRec[nZ,nPosRet,2,nPosAlqEF,2])
													Aadd(aTmpLinRet[nPosImp,5,nZ],xFormaRec[nZ,nPosRet,2,nPosRetEF,2])
												Endif
											Endif
										Endif
									Endif
								Endif
							EndIf
						EndIf
						Exit
					EndIf
				Next nX
			
				If !lRet
					Exit
				EndIf

				nValSEL := AScan(aHeader,{|x| AllTrim(x[2]) == "EL_VALOR"})
				nMoedSEL := AScan(aHeader,{|x| AllTrim(x[2]) == "EL_MOEDA"})
			
				If Valtype(aCols[nZ][nY]) <> "U"
					Loop
				ElseIf Alltrim(aHeader[nY][8]) == "C"
					aCols[nZ][nY] := ""
				ElseIf Alltrim(aHeader[nY][8]) == "N"
					aCols[nZ][nY] := 0
				ElseIf Alltrim(aHeader[nY][8]) == "D"
					aCols[nZ][nY] := CTOD("  /  /    ")
				ElseIf Alltrim(aHeader[nY][8]) == "L"
					aCols[nZ][nY] := .T.
				EndiF
			Next nY
			
			If AllTrim(aCols[nZ][nMoedSEL]) <> '1'
				DbSelectArea("SM2")
				SM2->(DbSetOrder(1))
				If !(SM2->(DbSeek(dDatabase)))
					cTxtRotAuto += STR0049 //"Informe todas as taxas das moedas que serão utilizadas nos Documentos."
					lMsErroAuto := .T.
					lRet:= .F.
					Exit
				Else
					If &("SM2->M2_MOEDA"+AllTrim(aCols[nZ][nMoedSEL])) > 0
						nTotSEL += aCols[nZ][nValSEL] * &("SM2->M2_MOEDA"+AllTrim(aCols[nZ][nMoedSEL]))
					Else
						cTxtRotAuto += STR0049 //"Informe todas as taxas das moedas que serão utilizadas nos Documentos."
						lMsErroAuto := .T.
						lRet:= .F.
						Exit
					EndIf
				EndIf
			Else
				nTotSEL += aCols[nZ][nValSEL]
			EndIf
			aCols[nZ][Len(aHeader) + 1] := .F.
		Next nZ
	
		If lRet.And. !u_st840TudoOk()
			lMsErroAuto := .T.
			lRet:= .F.
		EndIF
	
		If lRet
			Aadd(aLinSE1,Array(Len(aCposSE1)+2))
			For nZ := 1 to Len(xDocRec)
				If nZ > 1
					Aadd(aLinSE1,Array(Len(aCposSE1)+2))
				EndIf
				nPosPref := Ascan(xDocRec[nZ],{|x| AllTrim(x[1]) == "E1_PREFIXO"})
				nPosParc := Ascan(xDocRec[nZ],{|x| AllTrim(x[1]) == "E1_PARCELA"})
				nPosTipE1 := Ascan(xDocRec[nZ],{|x| AllTrim(x[1]) == "E1_TIPO"})
				nTitSE1 := Ascan(xDocRec[nZ],{|x| AllTrim(x[1]) == "E1_NUM"})
				nValaPg := Ascan(xDocRec[nZ],{|x| AllTrim(x[1]) == "E1_SALDO"})
				nValDes := Ascan(xDocRec[nZ],{|x| AllTrim(x[1]) == "E1_DESCONT"})
				nValMul := Ascan(xDocRec[nZ],{|x| AllTrim(x[1]) == "E1_MULTA"})
				nValJur := Ascan(xDocRec[nZ],{|x| AllTrim(x[1]) == "E1_JUROS"})
				nMot 	:= Ascan(xDocRec[nZ],{|x| AllTrim(x[1]) == "cMotBxSE1"})
				nValImP := Ascan(xDocRec[nZ],{|x| AllTrim(x[1]) == "nImpRetSE1"})
				nPosMoeda := Ascan(xDocRec[nZ],{|x| AllTrim(x[1]) == "E1_MOEDA"})
				nRecnSE1 := Ascan(xDocRec[nZ],{|x| AllTrim(x[1]) == "R_E_C_N_O_"})
				If nRecnSE1 == 0
					lMsErroAuto := .T.
					lRet:= .F.
					cTxtRotAuto += STR0225 + xDocRec[nZ][nTitSE1][2]  +  STR0226  +" "+ CRLF // 	"R_E_C_N_O_ do título "    + +" não foi informado."
					Exit
				Else
					aLinSE1[nZ][Len(aCposSE1) + 1] := xDocRec[nZ][nRecnSE1][2]
				EndIf
			
				If lRet
					SE1->(MsGoto(aLinSE1[nZ][Len(aCposSE1) + 1]))
					If !(SE1->(RECNO()) == aLinSE1[nZ][Len(aCposSE1) + 1])
						lRet := .F.
					EndIf
					If lRet
						For nY:=1 to Len(aCposSE1)
							If SE1->(FieldPos(Alltrim(aCposSE1[nY]))) > 0
								aLinSE1[nZ][nY] := &("SE1->"+(Alltrim(aCposSE1[nY])))
							ElseIf nY > 1
								aLinSE1[nZ][nY] := &(Alltrim(aCposSE1[nY]))
							EndIF
						Next nY
				
						aLinSE1[nZ][1] := -1
						aLinSE1[nZ][Len(aCposSE1) + 2] := .F.
						aLinSE1[nZ][nPosValBx] := xDocRec[nZ][nValaPg][2]-xDocRec[nZ][nValDes][2]+xDocRec[nZ][nValMul][2]+xDocRec[nZ][nValJur][2]
						aLinSE1[nZ][nPosDesc]  := xDocRec[nZ][nValDes][2]
						aLinSE1[nZ][nPosMulta] := xDocRec[nZ][nValMul][2]
						aLinSE1[nZ][nPosJuros] := xDocRec[nZ][nValJur][2]
						aLinSE1[nZ][nPosMotBx] := xDocRec[nZ][nMot][2]
						aLinSE1[nZ][nPosImpRet] := xDocRec[nZ][nValImP][2]
						aLinSE1[nZ][anPosMoed[Val(xDocRec[nZ][nPosMoeda][2])]] := aLinSE1[nZ][nPosValBx]
					
						If !A840Pagtos(nZ,,.F.)
							lMsErroAuto := .T.
							lRet:= .F.
						Else
							If !Fa840BaixaOK(cNumFatAut,nZ)
								lMsErroAuto := .T.
								lRet:= .F.
							Endif
						EndIF
						aLinSE1[nZ][1] := 1
						If Len(aTmpLinRet) > 0
							If cPaisLoc == "ARG"
								If lRatImp
									For nY := 1 To Len(aTmpLinRet)
										nPosImp := Ascan(xDocrec[nZ],{|x| Upper(AllTrim(x[1])) == aTmpLinRet[nY,1]})
										If nPosImp > 0
											nI := Ascan(xDocRec[nZ,nPosImp,2],{|x| Upper(Alltrim(x[1])) == "FE_NROCERT"})
											If nI > 0
												If xDocRec[nZ,nPosImp,2,nI,2] == aTmpLinRet[nY,2]
													nPosEstEF := Ascan(xDocRec[nZ,nPosImp,2],{|x| Upper(AllTrim(x[1])) == "FE_EST"})
													nPosCFOEF := Ascan(xDocRec[nZ,nPosImp,2],{|x| Upper(AllTrim(x[1])) == "FE_CFO"})
													nPosBasEF := Ascan(xDocRec[nZ,nPosImp,2],{|x| Upper(AllTrim(x[1])) == "FE_VALBASE"})
													nPosAlqEF := Ascan(xDocRec[nZ,nPosImp,2],{|x| Upper(AllTrim(x[1])) == "FE_ALIQ"})
													nPosRetEF := Ascan(xDocRec[nZ,nPosImp,2],{|x| Upper(AllTrim(x[1])) == "FE_RETENC"})
													If  aTmpLinRet[nY,1] == "RS"
														nPosConEF := Ascan(xDocRec[nZ,nPosImp,2],{|x| Upper(AllTrim(x[1])) == "A2_CONCSUS"})
													ElseIF aTmpLinRet[nY,1] == "RG"
														nPosConEF := Ascan(xDocRec[nZ,nPosImp,2],{|x| Upper(AllTrim(x[1])) == "A2_AGREGAN"})
													Else
														nPosConEF := 0
													Endif
													Aadd(aTmpLinRet[nY,5],{})
													nX := Len(aTmpLinRet[nY,5])
													Aadd(aTmpLinRet[nY,5,nX],xDocRec[nZ,nPosPref,2])
													Aadd(aTmpLinRet[nY,5,nX],xDocRec[nZ,nTitSE1,2])
													Aadd(aTmpLinRet[nY,5,nX],xDocRec[nZ,nPosParc,2])
													Aadd(aTmpLinRet[nY,5,nX],xDocRec[nZ,nPosTipE1,2])
													Aadd(aTmpLinRet[nY,5,nX],xDocRec[nZ,nPosImp,2,nPosEstEF,2])
													Aadd(aTmpLinRet[nY,5,nX],xDocRec[nZ,nPosImp,2,nPosCFOEF,2])
													If nPosConEF > 0
														Aadd(aTmpLinRet[nY,5,nX],xDocRec[nZ,nPosImp,2,nPosConEF,2])
													Endif
													Aadd(aTmpLinRet[nY,5,nX],xDocRec[nZ,nPosImp,2,nPosBasEF,2])
													Aadd(aTmpLinRet[nY,5,nX],xDocRec[nZ,nPosImp,2,nPosAlqEF,2])
													Aadd(aTmpLinRet[nY,5,nX],xDocRec[nZ,nPosImp,2,nPosRetEF,2])
												Endif
											Endif
										Endif
									Next
								Endif
							Else
								If cPaisLoc == "PER"
									For nY := 1 To Len(aTmpLinRet)
										nPosImp := Ascan(xDocrec[nZ],{|x| Upper(AllTrim(x[1])) == aTmpLinRet[nY,1]})
										If nPosImp > 0
											nI := Ascan(xDocRec[nZ,nPosImp,2],{|x| Upper(Alltrim(x[1])) == "FE_NROCERT"})
											If nI > 0
												If xDocRec[nZ,nPosImp,2,nI,2] == aTmpLinRet[nY,2]
													Aadd(aTmpLinRet[nPosImp,5],{})
													nX := Len(aTmpLinRet[nPosImp,5])
													Aadd(aTmpLinRet[nPosImp,5,nX],xDocRec[nZ,nPosPref,2])
													Aadd(aTmpLinRet[nPosImp,5,nX],xDocRec[nZ,nTitSE1,2])
													Aadd(aTmpLinRet[nPosImp,5,nX],xDocRec[nZ,nPosParc,2])
													Aadd(aTmpLinRet[nPosImp,5,nX],xDocRec[nZ,nPosTipE1,2])
													nI := Ascan(xDocRec[nZ,nPosImp,2],{|x| Upper(Alltrim(x[1])) == "E1_SALDO"})
													Aadd(aTmpLinRet[nPosImp,5,nX],xDocRec[nZ,nPosImp,2,nI,2])
												Endif
											Endif
										Endif
									Next
								Endif
							Endif
						Endif
					Else
						lMsErroAuto := .T.
						lRet:= .F.
						cTxtRotAuto += STR0120+" "+ xDocRec[nZ][nTitSE1][2] + STR0227 +" "+ CRLF  // "Titulo" ++ " não foi encontrado. "
						Exit
					EndIf
				EndIf
			                               
				If cValtoChar(aLinSE1[nZ][nMoedSE1]) <> '1'
					DbSelectArea("SM2")
					SM2->(DbSetOrder(1))
					If !(SM2->(DbSeek(dDatabase)))
						cTxtRotAuto += STR0049 //"Informe todas as taxas das moedas que serão utilizadas nos Documentos."
						lMsErroAuto := .T.
						lRet:= .F.
					Else
						If &("SM2->M2_MOEDA"+Alltrim(cValtoChar(aLinSE1[nZ][nMoedSE1]))) > 0
							nTotSE1 += (xDocRec[nZ][nValaPg][2]-xDocRec[nZ][nValDes][2]+xDocRec[nZ][nValMul][2]+xDocRec[nZ][nValJur][2]  )* &("SM2->M2_MOEDA"+Alltrim(cValtoChar(aLinSE1[nZ][nMoedSE1])))
						Else
							cTxtRotAuto += STR0049 //"Informe todas as taxas das moedas que serão utilizadas nos Documentos."
							lMsErroAuto := .T.
							lRet:= .F.
						EndIf
					EndIf
				Else
					nTotSE1 += xDocRec[nZ][nValaPg][2]-xDocRec[nZ][nValDes][2]+xDocRec[nZ][nValMul][2]+xDocRec[nZ][nValJur][2]
				EndIf
				If !lRet
					Exit
				EndIf
			Next nZ
		EndIf
	
		If lRet
			FAMoedas(dDataRef,cNumFatAut)
			If !u_st840TudoOk()
				lMsErroAuto := .T.
				lRet:= .F.
			EndIF
		Endif
		If lRet
		/*
		verifica o valor das retencoes */  
			aLinRet := {}
			If Len(aTmpLinRet) > 0
				nZ := 0
				While lRet .And. nZ < (Len(aTmpLinRet))
					nZ++
					nI := 0
					If lRatImp
						If aTmpLinRet[nZ,1] $ "RG|RS"
							aCabRet := {"E1_PREFIXO","E1_NUM","E1_PARCELA","E1_TIPO","FE_EST","FE_CFO","A2_AGREGAN","FE_VALBASE","FE_ALIQ","FE_RETENC"}
						Else
							aCabRet := {"E1_PREFIXO","E1_NUM","E1_PARCELA","E1_TIPO","FE_EST","FE_CFO","FE_VALBASE","FE_ALIQ","FE_RETENC"}
						Endif
					Else
						If aTmpLinRet[nZ,1] $ "RG|RS"
							aCabRet := {"FE_EST","FE_CFO","A2_AGREGAN","FE_VALBASE","FE_ALIQ","FE_RETENC"}
						Else
							aCabRet := {"FE_EST","FE_CFO","FE_VALBASE","FE_ALIQ","FE_RETENC"}
						Endif
					Endif
					aCertRet := {}
					For nI := 1 To Len(aTmpLinRet[nZ,5])
						Aadd(aCertRet,Aclone(aTmpLinRet[nZ,5,nI]))
						Aadd(aCertRet[Len(aCertRet)],.F.)
					Next
					If A87VldRet(aCertRet,aTmpLinRet[nZ,3],If(cPaisLoc == "PER",1,2),,aCabRet,aTmpLinRet[nZ,4],aTmpLinRet[nZ,1])
						Aadd(aLinRet,Aclone(aCertRet))
					Else
						lRet := .F.
						lMsErroAuto := .T.
					Endif
				Enddo
			Endif
			nTotal := nTotSEL -  nTotSE1
			If nTotal < 0
				lMsErroAuto := .T.
				lRet:= .F.
				cTxtRotAuto += STR0228//"Saldo insuficiente para efetuar a baixa.  "
			EndIf
		Endif
	
		If lRet
			nPanel := 6
			If !Fa840Salvar(.F.,.T.)
				lMsErroAuto := .T.
				lRet:= .F.
			Else
				MsgAlert(STR0229 + cRecibo + "  .") //" Foi gerado o recibo número : "
			EndIf
		EndIF
	EndIf
Return(lRet)

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ShowPanel ºAutor  ³Guilherme C. Leal   º Data ³  05/27/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mostra o panel referente ao passo em questao.			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ShowPanel( nPan, oPanel,cNumFatAut,lIncAdt)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros utilizados na funcao                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ nPan 	- Numero do panel a ser mostrado.             ³
//³ oPanel 	- Objeto recebido como referencia.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local nX := 1
	Local nLastPan := 4

	DEFAULT lIncAdt := .F.

//Caso o objeto oPanel esteja sem valor, recupero através do
//objeto de backup
	If oPanel == Nil
		oPanel := oObjBkp
	EndIf

	If lIncAdt
		nLastPan := 2 //ANGOLA tem menos paineis na inclusao de adiantamento
	Endif

	nLastPan := 6

	If nPan != nLastPan
	//Atualiza taxas das moedas
		FaMoedas()
	EndIf

	If nPan > 0 .And. nPan <= nLastPan
		For nX:=1 To Len(oPanel)
			If ( nX!=nPan )
				IF nX <= Len(aoCB)
					aoCB[nX]:Hide()
					aoCB[nX]:Refresh()
				Endif
				oPanel[nX]:Hide()
				oPanel[nX]:Refresh()
			Else
				IF nX <= Len(aoCB)
					aoCB[nX]:Show()
					OBJRefresh(nPan)
				Endif
				oPanel[nX]:Show()
				oPanel[nX]:Refresh()
				oDlgRecibo:cCaption:=aTitulo[nX]
				If (nPan == nLastPan) .Or. (nPan > 4) .Or. (nPan == 4 .And. Ascan(aLinSE1, {|x| x[1] == 1 }) == 0 )
					RefData(nPan,cNumFatAut,lIncAdt)
				EndIf
			EndIf
						
		Next nX
		Do Case
		Case nPan == 2 .and. !lIncAdt
			oLBCli:SetFocus()
		Case nPan == 3 .and. !lIncAdt
			oLBSE1:SetFocus()
		End Case
		nPan:=nPanel
	Else
		If nPanel <  1
			nPanel:=1
			nPan:=nPanel
		Else
			nPanel:= nLastPan
			nPan:= nPanel
		EndIf
	EndIf

//Efetuo uma copia do objeto oPanel caso na próxima chamada da função
//o mesmo seja passado com valor NIL, preservando a integridade da rotina
	oObjBkp := oPanel

Return


/*
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA840Ord ºAutor  ³Guilherme C. Leal   º Data ³  05/27/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ordena linhas do Grid de acordo com Combo.        		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros utilizados na funcao                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ nCombo	- Qual combo deve ser considerado		       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Static Function FA840Ord(nCombo)
	Local nPos

	If nCombo==1
		nPos := Ascan(aCabSEL,cOrdSEL)
		If lDecr
			ASort(aCols,,,{|x,y| x[nPos]> y[nPos]})
		Else
			ASort(aCols,,,{|x,y| x[nPos]< y[nPos]})
		Endif
		oGetSEL:ForceRefresh()
	Endif
	If nCombo==2
		nPos := Ascan(aCabSA1,cOrdSA1)
		If lDecr
			ASort(aLinSA1,,,{|x,y| x[nPos]> y[nPos]})
		Else
			ASort(aLinSA1,,,{|x,y| x[nPos]< y[nPos]})
		Endif
		oLBCli:SetArray(aLinSA1)
		oLBCli:bLine:= { || &(cBLinSA1 + "}") }
		oLBCli:Refresh()
	Endif
	If nCombo==3
		nPos := Ascan(aCabSE1,cOrdSE1)
		If lDecr
			ASort(aLinSE1,,,{|x,y| x[nPos]> y[nPos]})
		Else
			ASort(aLinSE1,,,{|x,y| x[nPos]< y[nPos]})
		Endif
		oLBSE1:SetArray(aLinSE1)
		oLBSE1:bLine:= { || &(cBLinSE1 + "}") }
		oLBSE1:Refresh()
	Endif

Return

/*
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA840Buscar ºAutor  ³Guilherme C. Leal   º Data ³  05/27/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca valor do campo cPesq de acordo com o combo. 			 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA840Buscar(lIncAdt)

	Local nX
	Local nPos
	Local nLin:=1
	Local cTipo
	Local aLin


//ANGOLA
	DEFAULT lIncAdt := .F.

	If nPanel==1
		oGetSEL:oBrowse:SetFocus()
		nPos	:= Ascan(aCabSEL,cOrdSEL)
		nPos	:= iif(nPos>0,nPos,1)
		aLin 	:= aClone(aCols)
		cTipo	:= Type(aCposSEL[nPos])
	Endif
	If nPanel==2
		oLBCli:SetFocus()
		nPos	:= Ascan(aCabSA1,cOrdSA1)
		nPos	:= iif(nPos>0,nPos,1)
		aLin	:= aClone(aLinSA1)
		cTipo	:= Type(aCposSA1[nPos])
	Endif
	If nPanel==3 .and. !lIncAdt
		oLBSE1:SetFocus()
		nPos	:= Ascan(aCabSE1,cOrdSE1)
		nPos	:= iif(nPos>0,nPos,1)
		aLin	:= aClone(aLinSE1)
		cTipo	:= Type(aCposSE1[nPos])
	Endif

	cText	:=cPesq
	nX 		:= 1

	If nPos > 0
		For nX:= 1 to Len(aLin)
			Do Case
			Case cTipo=="D"
				If CtoD(cText)=aLin[nX][nPos]
					nLin:=nX
					Exit
				Endif
			Case cTipo=="N"
				If Val(cText)=aLin[nX][nPos]
					nLin:=nX
					Exit
				Endif
			Case cTipo$"C|U"
				If Upper(Alltrim(cText)) $ Upper(Alltrim(aLin[nX][nPos]))
					nLin:=nX
					Exit
				Endif
			EndCase
		Next nX
	
		If nPanel==1
			aCols	:=	aClone(aLin)
			n:=nlin
			oGetSEL:oBrowse:nAt:=nLin
			oGetSEL:oBrowse:Refresh()
			oGetSEL:oBrowse:SetFocus()
		Endif
		If nPanel==2
			aLinSA1		:= aClone(aLin)
			oLBCli:nAt := nLin
			oLBCli:SetArray(aLinSA1)
			oLBCli:bLine:= { || &(cBLinSA1 + "}") }
			oLBCli:SetFocus()
		Endif
		If nPanel==3 .and. !lIncAdt
			aLinSE1 		:= aClone(aLin)
			oLBSE1:nAt := nLin
			oLBSE1:SetArray(aLinSE1)
			oLBSE1:bLine:= { || &(cBLinSE1 + "}") }
			oLBSE1:SetFocus()
		Endif
	EndIf

Return
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RefData   ºAutor  ³Guilherme C. Leal   º Data ³  05/27/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Remonta dados do Grid, de acordo com Panel.                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RefData(nPan,cNumFatAut,lIncAdt)

	Local aRecs			:={}
	Local nValDac := 0
	Local lQuery  	:= .F.
	Local cQuery  	:= ""
	Local nI      	:= 0
	Local nCAsc   	:= 0
	Local cStrTipos := "'"
	Local cCposSE1	:= ""
	Local cCposSA1	:= ""
	Local cFilClie	:= ""
	Local nQtdCli 	:= 0
	Local nContCli 	:= 0
	Local lFiltSE1  := ExistBlock("F087ASE1")
	Local aCli		:= {}
	Local nX			:= 0
	Local nY 			:= 0
	Local nCont 		:= 0
	Local nPosHead 		:= 0
	Local nPosTmp		:= 0
	Local nPosTmp2		:= 0
	Local nPosTmp3		:= 0
	Local aColsReten	:= {}
	Local aColsCtb		:= {}
	Local nPosCT2		:= 0
	Local cTabCT2		:= ""
	Local nSkip			:= 0
	Local nPosValCtb	:= 0
	Local nPosDebCtb	:= 0
	Local nPosCreCtb	:= 0
	Local nPosDC		:= 0
	LOCAL nTamPre
	LOCAL nTamNum
	LOCAL nTamParcel
	LOCAL nTamTipTit
	LOCAL nLastPanel := 4
	Local nImpRet := 0

	DEFAULT cNumFatAut	:= ""
	DEFAULT lIncAdt		:= .F.

	nPosDesc  := AScan(aCposSE1,"nDescSE1")
	nPosJuros := AScan(aCposSE1,"nJurSE1")
	nPosMulta := AScan(aCposSE1,"nMultaSE1")
	nPosSaldo := AScan(aCposSE1,"E1_SALDO")
	nPosMotBx := AScan(aCposSE1,"cMotBxSE1")
	nPosImpRet:= ASCAN(aCposSE1,"nImpRetSE1")

	#IFDEF TOP
		If TCSrvType() != "AS/400"
			lQuery := .T.
		EndIf
	#ENDIF

//Inclusao de adiantamentos tem menos paineis
	If lIncAdt
		nLastPanel := 2
	Endif
	nLastPanel := 6


	If nPan == 1
		c_Alias 	:= "SEL"
		nIndice := 8
		cSeek	:= xFilial("SEL")+cSerie+cRecibo
		cSelec	:= ".T."
		cWhi  	:= "(!EOF() .And. EL_FILIAL == '" + xFilial("SEL") +"' .And. SEL->EL_SERIE == '" + cSerie +"' .And. SEL->EL_RECIBO == '" + cRecibo + "')"
		aCols 	:= MontaGrid(c_Alias,cWhi,cSelec,.F.,".F.",cSeek,nIndice,aCposSEL)
	Endif

//ANGOLA - Esta painel nao e habilitado na incusao de adiantamentos
//Painel de clientes
	If nPan == 2 .and. !lIncAdt
		nIndice := 1
		c_Alias 	:= "SA1"
		cSeek	:=""
	
		If nFiltro==4
			aUserFilter := ExecBlock("F087AFIL",.F.,.F.)
			nIndice := aUserFilter[1]
			cSeek	:= aUserFilter[2]
			cSelec	:= aUserFilter[3]
			cWhi  	:= aUserFilter[4]
			If Len(aUserFilter) > 4
				cQuery  := aUserFilter[5]
			EndIf
		Endif
		If nFiltro==3  // melhorar performance para Query caso nao haja filtro de cliente
			If !lQuery
				cSeek	:= xFilial("SA1")
				cSelec	:= ".T."
				cWhi  	:= "(!EOF() .And. SA1->A1_FILIAL == '" + xFilial("SA1") + "')"
			Else
			//Determina os campos que serao selecionado na query...				
				aEval(aCposSA1,{|x,y| cCposSA1 += Iif(Left(x,2)=="A1",AllTrim(x)+", ","")})
				cCposSA1 += "SA1.D_E_L_E_T_,SA1.R_E_C_N_O_"

				cQuery := "SELECT DISTINCT A1_FILIAL,"+cCposSA1
				cQuery += " FROM "+RetSQLName("SA1")+" SA1,"+RetSQLName("SE1")+" SE1"
				cQuery += " WHERE A1_FILIAL = '"+xFilial("SA1")+"' AND"
				cQuery += " A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND E1_SALDO > 0 AND"
				cQuery += " SA1.D_E_L_E_T_ <> '*'"
				cQuery += " ORDER BY "+SqlOrder(SA1->(IndexKey(nIndice)))
				cQuery := ChangeQuery(cQuery)

				cSeek  := ""
				cWhi   := "!EOF()"
				cSelec := ".T."
			EndIf
		Endif
		If nFiltro==2
			cSeek	:= xFilial("SA1")+cCliente
			cSelec	:= "'" + xFilial("SA1")+cCliente+ "' == A1_FILIAL+A1_COD"
			cWhi  	:= "(!EOF() .And. SA1->A1_FILIAL == '" + xFilial("SA1") + "') .And. ('" + cCliente + "' == A1_COD)"
		Endif
		If nFiltro==1
			cSeek	:= xFilial("SA1")+cCliente+cLoja
			cSelec	:= "'" + xFilial("SA1")+cCliente+cLoja + "' == SA1->A1_FILIAL+SA1->A1_COD+SA1->A1_LOJA"
			cWhi  	:= "(!EOF() .And. SA1->A1_FILIAL == '" + xFilial("SA1") + "') .And. ('" + cCliente + cLoja + "' == A1_COD+A1_LOJA)"
		Endif
		cCondMca:= "(A1_COD == '" + cCliente + "' .And. A1_LOJA =='" + cLoja + "')"
		cSelec	+= IIf(!Empty(aFiltros[2])," .And. ("+aFiltros[2]+")","")
		aLinSA1	:= MontaGrid(c_Alias,cWhi,cSelec,.T.,cCondMca,cSeek,nIndice,aCposSA1,,cQuery)
	
		oLBCli:SetArray(aLinSA1)
		oLBCli:bLine:= { || &(cBLinSA1 + "}") }
		FaMoedas(NIL,cNumFatAut)
	Endif

//ANGOLA - Esta painel nao e habilitado na incusao de adiantamentos
//Painel de titulos a baixar
	If nPan == 3 .and. !lIncAdt
		ValAltArray(aLinSE1,@aLinSE1_Ori,aLinSA1,@aLinSA1_Ori,@cCliLoj_Ori)
		c_Alias	:= "SE1"
		nIndice := 2
		cCondMca:= ".F."
		cSelec  := ""
		aCli	:={}
	
		nPosCli	:= AScan(aCposSA1,"A1_COD")
		nPosLoja:= AScan(aCposSA1,"A1_LOJA")
	
		AEval(oLBCli:aARRAY, {|x,y| If(oLBCli:aARRAY[y][1] == 1, nQtdCli++,.T.)})//Qtd de Clientes selecionados

		If nQtdCli >= 300
	    // limite de selecao de clientes para que nao estoure a string a ser montada a seguir.
	    // a cQuery tem um limite de 15980 bytes, e o limite de 300 clientes garante que a string cQuery
	    // nao estoure, considerando os tamanhos "default" para os campos codigos e loja de cliente (6 e 2)
			Alert(STR0112) //"Limite de 300 clientes selecionados foi atingido. Por favor, verifique a selecao feita."
		Else
			nX:=1
			For nX:= 1 to Len(oLBCli:aARRAY) //ListBox de clientes
				If oLBCli:aARRAY[nX][1] == 1 // Cliente esta selecionado
					AAdd(aCli,{oLBCli:aARRAY[nX][nPosCli],oLBCli:aARRAY[nX][nPosLoja]})
					If !lQuery //Prepara a condicao de filtro para DBF
						cFilClie += oLBCli:aARRAY[nX][nPosCli] +  oLBCli:aARRAY[nX][nPosLoja] + "|"
					Else //Prepara a condicao de filtro para Bco de Dados
						cFilClie += "(E1_CLIENTE = '" + oLBCli:aARRAY[nX][nPosCli] + "' AND E1_LOJA = '" + oLBCli:aARRAY[nX][nPosLoja] + "')"
						nContCli++
						If nContCli != nQtdCli //Verifica se existem mais clientes para se adicionar a Query
							cFilClie  += " OR "
						Else
							cFilClie  += ") AND "
						EndIf
					EndIf
				Endif
			Next nX
			aSort(aCli ,,,{|x,y| x[1]+x[2] < y[1]+y[2]})
			cFilClie := Iif(lQuery,"("+cFilClie,cFilClie)
		EndIf
	
		If Len(aCli) > 0

			aLinSE1 := {}
			If lFiltSE1
				aUserFilSE1 := ExecBlock("F087ASE1",.F.,.F.)
				nIndice := aUserFilSE1[1]
				cSeek	:= aUserFilSE1[2]
				cSelec	:= aUserFilSE1[3]
				cWhi  	:= aUserFilSE1[4]
				If Len(aUserFilSE1) > 4
					cQuery  := aUserFilSE1[5]
				EndIf
			Else
				If !lQuery
					If lConsFilial
						ASort(aCli,,,{|x,y| x[1]+x[2] < y[1]+y[2]})
						cSeek := xFilial(c_Alias)+ aCli[1][1] + aCli[1][2]
						cWhi  := "(!EOF() .And. SE1->E1_FILIAL == '" + xFilial("SE1") + "') .AND."
						If Len(aCli) > 1
							cWhi  += " (E1_CLIENTE+E1_LOJA  <= '" + aCli[Len(aCli)][1] +aCli[Len(aCli)][2] + "')"
						Else
							cWhi  += " (E1_CLIENTE+ E1_LOJA) $ '" + cFilClie + "'"
						EndIf
					Else
						cSeek := ""
						cWhi  := "!EOF()"
					EndIf
					cSelec:= IIf(!Empty(cSelec) .And. !Empty(aFiltros[3])," .And. ","") + IIf(!Empty(aFiltros[3]),Alltrim(aFiltros[3]),"")
					cSelec+= IIf(!Empty(cSelec)," .And. ","") + "E1_TIPO$'"+cTipos+"' .And. SE1->E1_EMISSAO <= dDataRef"

					If lConsFilial
						cSelec += IIf(!Empty(cSelec)," .And. ","")+"(E1_CLIENTE+E1_LOJA $ '" + cFilClie + "')"
					EndIf
					If lConsSaldo
						cSelec+= " .And. SE1->E1_SALDO > 0"
					EndIf
				Else
					For nI := 1 To Len(cTipos)
						nCAsc := Asc(SubStr(cTipos,nI,1))
						If (nCAsc == 32) .Or. (nCAsc == 45) .Or.;
								(nCAsc >= 48 .And. nCAsc <= 57 ) .Or.;
								(nCAsc >= 65 .And. nCAsc <= 90 ) .Or.;
								(nCAsc >= 97 .And. nCAsc <= 122)
						
							cStrTipos += (SubStr(cTipos,nI,1)+Iif(nI==Len(cTipos),	"'",""))
						Else
							cStrTipos += "','"
						EndIf
					Next nI
				          
					cStrTipos	:=	IIf(Right(cStrTipos,2)==",'",Substr(cStrTipos,1,Len(cStrTipos)-2),cStrTipos)
				//Determina os campos que serao selecionado na query...				
					aEval(aCposSE1,{|x,y| cCposSE1 += Iif(Left(x,2)=="E1",AllTrim(x)+", ","")})
					cCposSE1 += "D_E_L_E_T_, R_E_C_N_O_"
	
					cQuery := "SELECT "+cCposSE1
					cQuery += " FROM "+RetSQLName("SE1")
					If lConsFilial
						cQuery += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND"
						cQuery += cFilClie
					Else
						cQuery += " WHERE "+cFilClie+" "
					EndIf
					cQuery += " E1_EMISSAO <= '"+Dtos(dDataRef)+"' AND"
					cQuery += " E1_TIPO IN ("+cStrTipos+") AND"
					If lConsSaldo
						cQuery += " E1_SALDO > 0 AND"
					EndIf
					cQuery += " E1_NUM <> ' ' AND"
				
					If ! Empty(cNumFatAut)
						nTamPre    := TamSX3("E1_PREFIXO")[1]
						nTamNum    := TamSX3("E1_NUM")[1]
						nTamParcel := TamSX3("E1_PARCELA")[1]
						nTamTipTit := TamSX3("E1_TIPO")[1]

						cQuery += "( E1_PREFIXO = '"+Subs(cNumFatAut,1,nTamPre)+"' AND E1_NUM = '"+Subs(cNumFatAut,nTamPre+1,nTamNum)+"' AND E1_PARCELA = '"+Subs(cNumFatAut,nTamPre+nTamNum+1,nTamParcel)+"' AND E1_TIPO = '"+Subs(cNumFatAut,nTamPre+nTamNum+nTamParcel+1,nTamTipTit)+"' ) AND "
					Endif
				
					cQuery += " D_E_L_E_T_ = ' '"

				// Adicionado para atender a Shark 12/01/2010
					If ExistBlock("F087AQRY")
						cQuery += ExecBlock("F087AQRY",.F.,.F.)
					EndIf
				
					cQuery += " ORDER BY "+SqlOrder(SE1->(IndexKey(nIndice)))
					cQuery := ChangeQuery(cQuery)
	
					cSeek  := ""
					cWhi   := "!EOF()"
					cSelec := ".T."
					cSelec += IIf(!Empty(cSelec) .And. !Empty(aFiltros[3])," .And. ","") + IIf(!Empty(aFiltros[3]),Alltrim(aFiltros[3]),"")
				EndIf
			EndIf
			aLinSE1     := AClone(MontaGrid(c_Alias,cWhi,cSelec,.T.,cCondMca,cSeek,nIndice,aCposSE1,.T.,cQuery))
		Else
			cWhi	:=	'.F.'	// Se nenhum cliente estiver selecionado, cria o aLinhas em branco
			cSelec	:=	'.F.'	// Se nenhum cliente estiver selecionado, cria o aLinhas em branco
			cSeek	:= "ZZZZZZZZ"
			aLinSE1 := AClone(MontaGrid(c_Alias,cWhi,cSelec,.T.,cCondMca,cSeek,nIndice,aCposSE1,.T.))
		Endif
	
		oLBSE1:SetArray(aLinSE1)
		oLBSE1:nAt 	:= 1
		oLBSE1:bLine:= { || &(cBLinSE1 + "}") }
	Endif

	If	((nPan == nLastPanel) .And. lIncAdt) .Or. (nPan == 4)
		nPosTipo	:= AScan(aCposSEL,"EL_TIPODOC")
		nPosVal		:= AScan(aCposSEL,"EL_VALOR")
		nPosMoedTit	:= AScan(aCposSEL,"EL_MOEDA")
		aLinReceb	:= {}
	
		aRecs:=AClone(aCols)
		ASort(aRecs,,,{|x,y| x[nPosTipo] < y[nPosTipo]})
		cTipo:=NIL
		nX:=1
		For nX:= 1 To Len(aRecs)
			If cTipo!=aRecs[nX][nPosTipo] .and. !aRecs[nX][Len(aRecs[nX])]
				AAdd(aLinReceb,{aRecs[nX][nPosTipo],0})
				cTipo:=aRecs[nX][nPosTipo]
			Endif
			If aRecs[nX][nPosVal]!=Nil .and. !aRecs[nX][Len(aRecs[nX])]
				nM:=IIf(Empty(aRecs[nX][nPosMoedTit]).Or. Val(aRecs[nX][nPosMoedTit])<=1,1,Val(aRecs[nX][nPosMoedTit]))
				aLinReceb[Len(aLinReceb)][2]+=aRecs[nX][nPosVal]*(aTaxa[nM]/aTaxa[oCBMOed:nAt])
			Endif
		Next nX
		oLBReceb:SetArray(aLinReceb)
		oLBReceb:bLine := { ||{aLinReceb[oLBReceb:nAT][1],Transform(aLinReceb[oLBReceb:nAT][2],PesqPict("SEL","EL_VALOR",18,oCBMOed:nAt)) }}
		oLBReceb:Refresh()
		
	// Monta Resumo das baixas
		aLinBx := {}

	//Inclusao de adiantamento nao tem valor baixado
		If !lIncAdt
			nPosTipo		:= AScan(aCposSE1,"E1_TIPO")
			nPosVal		:= AScan(aCposSE1,"nBaixar")
			nPosMoedTit	:= AScan(aCposSE1,"E1_MOEDA")
			nPosDesc 	:= AScan(aCposSE1,"nDescSE1")
			nPosJuros	:= AScan(aCposSE1,"nJurSE1")
			nPosMulta	:= AScan(aCposSE1,"nMultaSE1")
			nPosImpRet	:= AScan(aCposSE1,"nImpRetSE1")

			aRecs:=AClone(aLinSE1)
			ASort(aRecs,,,{|x,y|  Str(x[1]) + x[nPosTipo] <  Str(y[1]) + y[nPosTipo]})
			cTipo:=Nil
			nX:=1
			For nX:= 1 To Len(aRecs)
				If aRecs[nX][1]<1
					Exit
				Endif
				If cTipo!=aRecs[nX][nPosTipo]
					AAdd(aLinBx,{aRecs[nX][nPosTipo],0})
					cTipo:=aRecs[nX][nPosTipo]
				Endif
				nM:=IIf(Empty(aRecs[nX][nPosMoedTit]).Or. aRecs[nX][nPosMoedTit]<=1,1,aRecs[nX][nPosMoedTit])
				If aRecs[nX][nPosTipo]$MVRECANT+"/"+MV_CRNEG
					aLinBx[Len(aLinBx)][2]-=aRecs[nX][nPosVal]*(aTaxa[nM]/aTaxa[oCBMOed:nAt])
					If aRecs[nX][nPosMotBx]=="DAC"
						nValDac-=aRecs[nX][nPosVal]*(aTaxa[nM]/aTaxa[oCBMOed:nAt])
					EndIf
				Else
					aLinBx[Len(aLinBx)][2]+=(aRecs[nX][nPosVal]-aRecs[nX][nPosDesc]+aRecs[nX][nPosJuros]+aRecs[nX][nPosMulta])*aTaxa[nM]/aTaxa[oCBMOed:nAt]
					If aRecs[nX][nPosMotBx]=="DAC"
						nValDac+=aRecs[nX][nPosVal]*(aTaxa[nM]/aTaxa[oCBMOed:nAt])
					EndIf
				Endif
			// Soma Retenção de Impostos como Baixa  
				if nPosImpRet > 0 .and. aRecs[nX, nPosImpRet] > 0
					nImpRet += aRecs[nX, nPosImpRet]
				endif
			Next nX
		
			If nValDac<>0
				Aadd(aLinBx,{"DAC",nValDac*(-1)})
			Endif
			If nDescGer>0
				Aadd(aLinBx,{"DC",nDescGer*(aTaxa[nMoedDesc]/aTaxa[oCBMOed:nAt])*(-1)})
			Endif
			If nPercGer>0
				nTotBx:=0
				AEval(aLinBx,{|x| If(!(x[1]$MVRECANT+"/"+MV_CRNEG+"/DAC"),nTotBx +=x[2],0)})
				AAdd(aLinBx,{"DC",nPercGer*nTotBx*0.01*(-1)})   // Aplica percentual de desconto
			Endif
		
    // Percepção de IGV - Peru
			If cPaisLoc $ "EQU|PER" .And. nValPerc > 0 .And. aPerc[1][8] //
				Aadd(aLinBx,{"P",nValPerc*(aTaxa[nMoedDesc]/aTaxa[oCBMOed:nAt])*(1)})
				cTipo:="P"
			EndIf
	
		Endif

		nTotBx:=0
		AEval(aLinBx,	{|x| nTotBx +=x[2]})
		nTotRec:=0
		AEval(aLinReceb,{|x| nTotRec += x[2]})
	
		oLBBx:SetArray(aLinBx)
		oLBBx:bLine := { ||{aLinBx[oLBBx:nAT][1],Transform(aLinBx[oLBBx:nAT][2],PesqPict("SE1","E1_VALOR",18,oCBMOed:nAt)) }}
		oLBBx:Refresh()
	
		nTotalBx := nTotBx
		nTotal:= Round(nTotRec-nTotBx,MsDecimais(IIf(!lRotAuto,oCBMOed:nAt,1)))
	
		oTotal:Picture:=PesqPict("SE1","E1_VALOR",TamSX3("E1_VALOR")[1],oCBMOed:nAt)
		oTotal:Refresh()
	
	EndIf


	//
	//Painel 5
	//
	aColsSEL	:= ACLONE(aCols)
	aHeaderSEL	:= ACLONE(aHeader)
	If nPan == 5 .and. cPaisLoc $ 'URU|BOL|PTG|ANG|PER|ARG'
		nCont 		:= 0
		aColsReten 	:= Array(1,Len(oRetTit:aHeader)+1)
		nPosTmp		:= ASCAN(oRetTit:aHeader,{|aCpo| AllTrim(aCpo[2]) == "EL_TIPODOC" })
		nPosTmp2 	:= ASCAN(oRetTit:aHeader,{|aCpo| AllTrim(aCpo[2]) == "EL_MOEDA" })
		nPosTmp3 	:= ASCAN(oRetTit:aHeader,{|aCpo| AllTrim(aCpo[2]) == "EL_VALOR" })
	
		For nX := 1 To Len(aCols)
			//Verifica tipo interno em caso do uso da tabela FJS
						
			If !(aCols[nX,Len(aHeader)+1]) .And. (aCols[nX,nPosTmp] $ "RI|RG|RB|RS|")
				nCont++
				//Se não for a primeira linha, adiciona nova linha no quadro de retenções
				If !(nCont == 1)
					AADD(aColsReten,Array(Len(oRetTit:aHeader)+1))
				EndIf
				
				aColsReten[nCont,nPosTmp] := aCols[nCont,nPosTmp]
				
				For nY := 1 To (Len(oRetTit:aHeader)-1)
					nPosHead := ASCAN(aHeader,{|aCab| AllTrim(aCab[2]) == AllTrim(oRetTit:aHeader[nY,2]) })
					aColsReten[nCont,nY] := aCols[nX,nPosHead]
					//Preenche a coluna de ordenação	
					Do Case
					Case (aColsReten[nCont,nPosTmp] $ "RI|")
						aColsReten[nCont,Len(oRetTit:aHeader)]	:= 1
					Case (aColsReten[nCont,nPosTmp] $ "RG|")
						aColsReten[nCont,Len(oRetTit:aHeader)]	:= 2
					Case (aColsReten[nCont,nPosTmp] $ "RB|")
						aColsReten[nCont,Len(oRetTit:aHeader)]	:= 3
					Case (aColsReten[nCont,nPosTmp] $ "RS|")
						aColsReten[nCont,Len(oRetTit:aHeader)]	:= 4
					Otherwise
						aColsReten[nCont,Len(oRetTit:aHeader)]	:= 9
					EndCase
					
					aColsReten[nCont,Len(oRetTit:aHeader)+1] := .F.
				Next nY
				//nM := IIF(Val(aColsReten[nCont][nPosTmp2]) <=1, 1, Val(aColsReten[nCont][nPosTmp2]))
				//aColsReten[nCont][nPosTmp3] := aColsReten[nCont][nPosTmp3]*(aTaxa[nM]/aTaxa[oCBMOed:nAt])
			EndIf
		Next nX
		
		//Verifica se há retenções ou não, para preencher a aColsReten com conteúdos em branco
		If nCont <= 0
			For nX := 1 To Len(oRetTit:aHeader)
				If oRetTit:aHeader[nX,8] == "N"
					aColsReten[1,nX] := 0
				Else
					aColsReten[1,nX] := ""
				EndIf
			Next nX
			aColsReten[1,Len(oRetTit:aHeader)+1] := .T.
		Else
			//Reordena as linhas do quadro de retenções, por tipo, de acordo com a ordem RI,RG,RB,RS
			ASORT(aColsReten, , , {|aLin1,aLin2| (aLin1[nPosTmp] < aLin2[nPosTmp]) })
		EndIf
		oRetTit:SetArray(aColsReten)
		oRetTit:Refresh()
		
		//Atualiza o quadro do resumo de retenções
		For nX := 1 To Len(oRetRes:aArray)
			oRetRes:aArray[nX,2] := 0
			
		Next nX
		
		For nX := 1 To Len(oRetTit:aCols)
			//Soma as retenções e atualiza os valores do quadro de resumo de retenções
			If cPaisLoc $ "URU|BOL"
				Do Case
				Case oRetTit:aCols[nX,Len(oRetTit:aHeader)] == 1		//IRIC
					oRetRes:aArray[1,2] += oRetTit:aCols[nX,nPosTmp3]
				Case oRetTit:aCols[nX,Len(oRetTit:aHeader)] == 2		//IR
					oRetRes:aArray[2,2] += oRetTit:aCols[nX,nPosTmp3]
				EndCase
				oRetRes:aArray[2,2] += oRetTit:aCols[nX,nPosTmp3]
			ElseIf cPaisLoc == "PTG"
				Do Case
				Case oRetTit:aCols[nX,Len(oRetTit:aHeader)] == 1		//IVA
					oRetRes:aArray[1,2] += oRetTit:aCols[nX,nPosTmp3]
				Case oRetTit:aCols[nX,Len(oRetTit:aHeader)] == 2		//IRC
					oRetRes:aArray[2,2] += oRetTit:aCols[nX,nPosTmp3]
				EndCase
				oRetRes:aArray[2,2] += oRetTit:aCols[nX,nPosTmp3]
			ElseIf cPaisLoc == "ANG"
				Do Case
				Case oRetTit:aCols[nX,Len(oRetTit:aHeader)] == 1		//RIE
					oRetRes:aArray[1,2] += oRetTit:aCols[nX,nPosTmp3]
				EndCase
				oRetRes:aArray[1,2] += oRetTit:aCols[nX,nPosTmp3]
			ElseIf cPaisLoc == "PER"
				Do Case
				Case oRetTit:aCols[nX,Len(oRetTit:aHeader)] == 1		//IGV
					oRetRes:aArray[1,2] += oRetTit:aCols[nX,nPosTmp3]
				Case oRetTit:aCols[nX,Len(oRetTit:aHeader)] == 2		//IR
					oRetRes:aArray[2,2] += oRetTit:aCols[nX,nPosTmp3]
				EndCase
				oRetRes:aArray[2,2] += oRetTit:aCols[nX,nPosTmp3]
			ElseIf cPaisLoc == "ARG"
				Do Case
				Case oRetTit:aCols[nX,Len(oRetTit:aHeader)] == 1		//IVA
					oRetRes:aArray[1,2] += oRetTit:aCols[nX,nPosTmp3]
				Case oRetTit:aCols[nX,Len(oRetTit:aHeader)] == 2		//Ganancias
					oRetRes:aArray[2,2] += oRetTit:aCols[nX,nPosTmp3]
				Case oRetTit:aCols[nX,Len(oRetTit:aHeader)] == 3		//Ingressos Brutos
					oRetRes:aArray[3,2] += oRetTit:aCols[nX,nPosTmp3]
				Case oRetTit:aCols[nX,Len(oRetTit:aHeader)] == 4		//SUSS
					oRetRes:aArray[4,2] += oRetTit:aCols[nX,nPosTmp3]
				EndCase
				oRetRes:aArray[5,2] += oRetTit:aCols[nX,nPosTmp3]
			EndIf
		Next nX
		oRetRes:bLine := {|| { oRetRes:aArray[oRetRes:nAT][1], RTrim(Transform(oRetRes:aArray[oRetRes:nAT][2],PesqPict("SEL","EL_VALOR",TamSX3("EL_VALOR")[1],oCBMOed:nAt))) } }
		oRetRes:Refresh()
	ElseIf nPan == 5 .and.  !cPaisLoc $ 'URU|BOL|PTG|ANG|PER|ARG'
		nPan++
	EndIf
	
	//
	//Painel 6
	//	
	If nPan == 6
		//Processa a simulação da contabilização
		MsAguarde({|| FA840aCtbA(1) } , STR0189)
		
		//Monta o browse da simulação da contabilização
		nPosCT2 := ASCAN(aCtbTmp, {|aX| aX[1] == "CT2"})

		aColsCtb := Array(1,Len(oSimCtb:aHeader)+1)
		aColsCtb[1,Len(oSimCtb:aHeader)+1] := .T.
		nSkip := 1
		If nPosCT2 > 0
			cTabCT2 := aCtbTmp[nPosCT2,4]
			dbSelectArea("CT2")
			dbGoTop()
			dDtCtb := CT2->CT2_DATA
			cLtCtb := CT2->CT2_LOTE
			
			oDtCtb:CtrlRefresh()
			oLtCtb:CtrlRefresh()
			While !EoF()
				If nSkip > 1
					AADD(aColsCtb,Array(Len(oSimCtb:aHeader)+1))
				EndIf
				For nX := 1 To Len(oSimCtb:aHeader)
					aColsCtb[nSkip,nX] := CT2->&(oSimCtb:aHeader[nX,2])
				Next nX
				aColsCtb[nSkip,Len(oSimCtb:aHeader)+1] := .F.
				dbSkip()
				nSkip++
			EndDo
			
			oSimCtb:SetArray(aColsCtb)
			oSimCtb:ForceRefresh()
			
			nPosValCtb 	:= ASCAN(oSimCtb:aHeader, {|aX| AllTrim(aX[2]) == "CT2_VALOR"})
			nPosDebCtb 	:= ASCAN(oSimCtb:aHeader, {|aX| AllTrim(aX[2]) == "CT2_DEBITO"})
			nPosCreCtb 	:= ASCAN(oSimCtb:aHeader, {|aX| AllTrim(aX[2]) == "CT2_CREDIT"})
			nPosDC		:= ASCAN(oSimCtb:aHeader, {|aX| AllTrim(aX[2]) == "CT2_DC"})
			nCtbDeb := 0
			nCtbCre := 0
			
			If (nPosValCtb > 0) .And. (nPosDebCtb > 0) .And. (nPosCreCtb > 0) .And. (nPosDC > 0)
				For nX := 1 To Len(aColsCtb)
					Do Case
					Case AllTrim(aColsCtb[nX,nPosDC]) == "1"
						nCtbDeb += aColsCtb[nX,nPosValCtb]
					Case AllTrim(aColsCtb[nX,nPosDC]) == "2"
						nCtbCre += aColsCtb[nX,nPosValCtb]
					Case AllTrim(aColsCtb[nX,nPosDC]) == "3"
						nCtbDeb += aColsCtb[nX,nPosValCtb]
						nCtbCre += aColsCtb[nX,nPosValCtb]
					EndCase
				Next nX
			EndIf
			
			oCtbDeb:CtrlRefresh()
			oCtbCre:CtrlRefresh()
		EndIf
	EndIf
//Endif

Return

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA840Vld ºAutor  ³Guilherme C. Leal   º Data ³  05/27/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz refresh dos objetos do Panel informado.        		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OBJRefresh(nPan)

	If nPan==1
		oGetSEL:ForceRefresh()
		oGetSEL:oBrowse:Refresh()
		aDadosAdm:={}
	Endif
	If nPan==2
		oLBCli:Refresh()
	Endif
	If nPan==3
		oLBSE1:Refresh()
	Endif

Return

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FAMoedas  ºAutor  ³Guilherme C. Leal   º Data ³  05/27/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta ListBox que contem as taxas das moedas.			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros utilizados na funcao                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ dData	- Data para buscar no SM2, caso nao informada,³
//³ nao monta taxas, somente Saldos.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Static Function FAMoedas(dData,cNumFatAut)

	Local nI 		:= 1
	Local aCabMoed	:=	{}
	Local aTamMoed	:=	{}
	Local aCpsMoed	:=	{}
	Local anTotRec	:= {}
	Local anTotBax	:= {}
	Local nRec		:= 0
	Local nBax		:= 0
	Local lNovo		:= .F.
	DEFAULT cNumFatAut := ""


	aCpsMoed:={"cMoeda","nTaxa","nRecebido","nBxTotMoed"}

	Posicione("SX3",2,"EL_MOEDA","X3_TITULO")
	Aadd(aCabMoed,X3Titulo())
	Posicione("SX3",2,"EL_TXMOEDA","X3_TITULO")
	Aadd(aCabMoed,X3Titulo())
	Aadd(aCabMoed,STR0047)
	Aadd(aCabMoed,STR0048)

	aTamMoed:={23,35,48,30}

	If dData!=NIL						// Se a data for informada, remonta taxas das moedas
		For nI:= 1 to Len(aTaxa)
			aTaxa[nI]	:= xMoeda(1,nI,1,dData,TamSx3("M2_MOEDA"+Alltrim(Str(nI)))[2])
		Next nI
	Else
		For nI:= 1 to Len(aTaxa)
			aTaxa[nI]	:= aLinMoed[nI][2]
		Next nI
	Endif

	anTotRec:=SomaReceb()
	anTotBax:=SomaBaixa()

	nI:=1
	For nI := 1 To nQtMoedas
		nRec	:= anTotRec[nI]
		nBax 	:= anTotRec[nI] - anTotBax[nI]
		aLinMoed[nI]:={aNomeMoed[nI],aTaxa[nI],nRec,nBax}
	Next nI
	If !lRotAuto .And. oLBMoed==NIL
		aSize := MSADVSIZE()
		oLBMoed	:=TwBrowse():New(001,(aSize[5]/2)-200,000,000,,aCabMoed,aTamMoed,oPanelTop,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		lNovo	:=.T.
	Endif

	If !lRotAuto
		IF lNovo
			oLBMoed:SetArray(aLinMoed)
			oLBMoed:bLine 	:= { ||{aLinMoed[oLBMoed:nAT][1],;
				Transform(aLinMoed[oLBMoed:nAT][2],PesqPict("SM2","M2_MOEDA"+AllTrim(Str(oLBMoed:nAT)),TamSx3("M2_MOEDA"+AllTrim(Str(oLBMoed:nAT)))[1])),;
				Transform(aLinMoed[oLBMoed:nAT][3],PesqPict("SEL","EL_VALOR",TamSx3("EL_VALOR")[1],oLBMoed:nAT)),;
				Transform(aLinMoed[oLBMoed:nAT][4],PesqPict("SEL","EL_VALOR",TamSx3("EL_VALOR")[1],oLBMoed:nAT)) }}
		
			oLBMoed:bLDblClick := {|| DCLBMoed(cNumFatAut)} //CBF
			oLBMoed:lHScroll:=.F.
			oLBMoed:lVScroll:=.T.
			oLBMoed:nHeight:=112
			oLBMoed:nWidth	:=400
		Else
			oLBMoed:Refresh()
		Endif
	EndIf

Return

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SomaReceb ºAutor  ³Guilherme C. Leal   º Data ³  05/27/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Soma todos os recebimentos.                       		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SomaReceb()

	Local nX:=1
	Local nPosMoed
	Local nPosVal
	Local anRec := Array(nQtMoedas)
	Local anR 	:= Array(nQtMoedas)

	aFill(anRec,0)
	aFill(anR,0)

	nPosMoed	:= AScan(aCposSEL,"EL_MOEDA")
	nPosVal	:= AScan(aCposSEL,"EL_VALOR")

	For nX:=1 to LEN(aCols)
		if !aCols[nX][Len(aCols[nX])] 		// Se o registro nao estiver deletado
			IF Empty(aCols[nX][nPosMoed]) .Or. aCols[nX][nPosMoed] <= "1"
				anRec[1] += aCols[nX][nPosVal]
			Else
				anRec[Val(aCols[nX][nPosMoed])]+=aCols[nX][nPosVal]
			Endif
		Endif
	Next nX

Return(anRec)

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SomaBaixa ºAutor  ³Guilherme C. Leal   º Data ³  05/27/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Soma valores a serem baixados.                    		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SomaBaixa()
	Local nX:=1
	Local nPosMoed
	Local nPosVal
	Local anBaixa 	:= Array(nQtMoedas)
	Local anB		:= Array(nQtMoedas)
	Local nMoed

	AFill(anBaixa,0)
	AFill(anB,0)

	nPosMoed:= AScan(aCposSE1,"E1_MOEDA")
	nPosTipo:= AScan(aCposSE1,"E1_TIPO")
	nPosVal	:= AScan(aCposSE1,"nBaixar")

//ANGOLA - Inclusao de Adiantamento nao tem tela de titulos a baixar
//Logo aLinSE1 nao vai existir para a soma de valores a baixar
	aLinSE1 := If(Type("aLinSE1") != "A",{},aLinSE1)

	For nX:=1 to LEN(aLinSE1)
		If aLinSE1[nX][1]== 1 // Esta Marcado
			For nMoed:=1 To nQtMoedas
				If aLinSE1[nX][nPosMotBx]=="DAC"
				// Nao deve fazer nada com os valores
				ElseIf aLinSE1[nX][nPosTipo]$MVRECANT+"/"+MV_CRNEG
					anBaixa[nMoed] -= aLinSE1[nX][anPosMoed[nMoed]]
				Else
					anBaixa[nMoed] 	+= aLinSE1[nX][anPosMoed[nMoed]]
					anB[nMoed]		+= aLinSE1[nX][anPosMoed[nMoed]]
				Endif
			Next nMoed
		Endif
	Next nX

	nTot:=0

	If nDescGer>0
		anBaixa[nMoedDesc] -= nDescGer
	Endif

	If nPercGer>0
		nTot:=0
		nX:=0
		AEval(anB,{|x,y| nTot += x*aTaxa[y]})

		nTot:=nTot/aTaxa[nMoedDesc]
		anBaixa[nMoedDesc] -= nPercGer*nTot*0.01
	Endif

Return(anBaixa)

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SomatitBaixa ºAutor  ³Guilherme C. Leal   º Data ³  05/27/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Soma valores a serem baixados sem considerar NEGATIVOS.       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SomaTitBaixa()
	Local nX:=1
	Local nPosMoed
	Local nPosVal
	Local anB		:= Array(nQtMoedas)
	Local nMoed

	AFill(anB,0)

	nPosMoed:= AScan(aCposSE1,"E1_MOEDA")
	nPosTipo:= AScan(aCposSE1,"E1_TIPO")
	nPosVal	:= AScan(aCposSE1,"nBaixar")

	For nX:=1 to LEN(aLinSE1)
		If aLinSE1[nX][1]== 1 // Esta Marcado
			For nMoed:=1 To nQtMoedas
				If aLinSE1[nX][nPosTipo]$MVRECANT+"/"+MV_CRNEG .Or. aLinSE1[nX][nPosMotBx]=="DAC"
				Else
					anB[nMoed]		+= aLinSE1[nX][anPosMoed[nMoed]]
				Endif
			Next nMoed
		Endif
	Next nX

Return(anB)


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaGrid ºAutor  ³Guilherme C. Leal   º Data ³  05/27/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta linhas dos Grids                           		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaGrid(c_Alias,cWhile,cCond,lMark,cCMarca,cSeek,nInd,aCpos,lRecno,cQuery,lIncAdt,nPanel)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros utilizados na funcao                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ c_Alias 	- Arquivo onde buscar as informacoes.         ³
//³ cWhile 	- Condicao inicial para o While.              ³
//³ cCond 	- Se .T. o registro sera inserido no aC.      ³
//³ lMark 	- Se usa Marca (somente para ListBox).        ³
//³ cCMarca - Se .T. o registro vem marcado.              ³
//³ cSeek 	- Registro inicial do while (performance).    ³
//³ nInd 	- Indice da Busca.                            ³
//³ aCpos 	- Campos utilizados (somente os validos).     ³
//³ lRecno	- Se TRUE, carregara o RECNO na penultima pos.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna aC, que sera utilizado como aCols ou Linhas   ³
//³ do ListBox.											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local lAchou:=.F.
	Local aC	:= {}
	Local nRecs
	Local nS	:=1
	Local nA	:=1
	Local aStru := {}
	Local aAreaAtu := GetArea()
	Local nLin     := 0
	Local nCol     := 0

	DEFAULT lRecno	:=	.F.
	DEFAULT cQuery  := ""

//ANGOLA
	DEFAULT lIncAdt := .F.
	DEFAULT nPanel	 := 0

	Private nSel  :=0

	nRecs	:=	If(lRecno,2,1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³De acordo com todos os parametros passados, monto o aC. 	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aC:={}
	If Empty(cQuery)
		DbSelectArea(c_Alias)
		DbSetOrder(nInd)
		DbGotop()
		DbSeek(cSeek,.F.)
	Else
	//Acerta os campos conforme o seu tipo...           
		aStru  := (c_Alias)->(dbStruct())
		c_Alias:= c_Alias+"TMP"
	//Abre a area criada na query...
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), c_Alias, .F., .T.)

		For nA := 1 To Len(aStru)
			If aStru[nA][2] != "C" .And. aStru[nA][2] != "M" .And. FieldPos(aStru[nA][1]) != 0
				TCSetField(c_Alias, aStru[nA][1], aStru[nA][2], aStru[nA][3], aStru[nA][4])
			EndIf
		Next nA

		dbSelectArea(c_Alias)
		dbGoTop()
	EndIf

	If !Empty(cQuery)
		DbEval({|| A840Load(@aC, nRecs, cCond, @lAchou, lRecno, aCpos, c_Alias)})

//ANGOLA - Inclusao de adiantamento nao tera painel Clientes e Titulos para baixa
	ElseIf lIncAdt .and. c_Aliasn $ "SA1#SE1"
		lAchou:=.F.

	Else
		While &(cWhile)
			If &(cCond)
				If lMark .And. &cCMarca
					nSel:= 1
				Else
					nSel := -1
				Endif
				lAchou:=.T.
				AAdd(aC,Array(Len(aCpos)+nRecs))
				For nA:=1 to Len(aCpos)
					aC[Len(aC)][nA]   := &(aCpos[nA])
				Next
				If lRecno
					If Empty(cQuery)
						aC[Len(aC)][Len(aC[1])-1]:=(c_Alias)->(Recno())
					Else
						aC[Len(aC)][Len(aC[1])-1]:=(c_Alias)->R_E_C_N_O_
					EndIf
				Endif
				aC[Len(aC)][Len(aC[1])]:=.F.

				If c_Alias == "SE1"
					nLin := Len(aC)
					nCol := Len(aC[nLin])-1
	
					If !Empty(aC[nLin][nCol])
						aC[nLin][nPosDesc]  := FaDescFin(c_Alias,dDataRef,(c_Alias)->E1_SALDO,(c_Alias)->E1_MOEDA)
						aC[nLin][nPosJuros] := fa070Juros(Max((c_Alias)->E1_MOEDA,1))
					EndIf
			
				//Monta arrays de controle de alteracoes...           
					AAdd(aLinSE1_Ori,{aC[nLin][1],aC[nLin][2],aC[nLin][3]})
				EndIf
			Endif
		
			DbSelectArea(c_Alias)
			DbSkip()
		Enddo
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Se nao encontrar nenhum registro, cria novamente em branco.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	If !lAchou
		aC := Array(1,Len(aCpos)+nRecs)
		If lMark
			aC[1][1] := 0
			nS:=2
		Else
			nS:=1
		Endif
		SX3->(DBSetOrder(2))
		For nA:=nS to Len(aCpos)
			If SX3->(DbSeek(aCpos[nA]))
				aC[Len(aC)][nA]   := CriaVar(aCpos[nA],.F.)
			Else
				aC[Len(aC)][nA]   := &(aCpos[nA])
			Endif
		Next
		aC[Len(aC)][Len(aC[1])]:=.F.
	Endif

	If !Empty(cQuery)
		(c_Alias)->(dbCloseArea())
		RestArea(aAreaAtu)
	EndIf
//	If _lCustom	.And. MsgYesNo("Cheque")
	
//		aC:= u_ARTELCHEQUE(aC,aCpos,nRecs)
	
//	EndIf

	SX3->(DbSetOrder(1))

Return(aC)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A840Pagtos  ºAutor  ³Microsiga        º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A840Pagtos(nLin,cNumFatAut,lAltTitulo)
	Local nI 			:= 0
	Local nPosMoed		:= AScan(aCposSE1,"E1_MOEDA")
	Local nPosValor		:= AScan(aCposSE1,"E1_VALOR")
	Local aValores      := Array(8)
	Local nPosBaixa		:= Ascan(aCposSE1,"nBaixar")
	Local nX 			:= 0
	Local aLinTit1 		:= {}
	Local nPosPref  	:= Ascan( aCposSE1, "E1_PREFIXO")
	Local nPosNum   	:= Ascan( aCposSE1, "E1_NUM")
	Local nPosParc  	:= Ascan( aCposSE1, "E1_PARCELA")
	Local nPosTipo  	:= Ascan( aCposSE1, "E1_TIPO")
	Local nPosCli   	:= Ascan( aCposSE1, "E1_CLIENTE")
	Local nPosLoja  	:= Ascan( aCposSE1, "E1_LOJA")
	Local nPosNatu  	:= Ascan( aCposSE1, "E1_NATUREZ")
	Local nPosImpRet    := AScan(aCposSE1,"nImpRetSE1")
	Local nAliq2		:= 0
	Local nAliq1		:= 0
	Local cCalcITF   	:= SuperGetMv("MV_CALCITF",.F.,"2")
	Local aConcepto		:= {}
	Local lRet 			:= .T.

	DEFAULT cNumFatAut 	:= ""
	DEFAULT lAltTitulo	:= .T.


//Se nao for um registro valido sai
	If aLinSE1[nLin,1]== 0
		lRet := .F.
	EndIf
	If lRet .And. cPaisLoc=="PER" .and. AllTrim(cCalcITF) == "1"
		`	If lFindITF .AND. FinProcITF( ,1,,,,,aLinSE1[nLin,nPosNatu])
		If !lNatureza
			lRet := .F.
			IF !lRotAuto
				MsgAlert(STR0159 + " ["+ cNatureza + "] " + STR0160)
			ELSE
				cTxtRotAut += STR0159 + " ["+ cNatureza + "] " + STR0160  +" "+ CRLF
			EndIf
		EndIF
	Else
		If lNatureza
			IF !lRotAuto
				MsgAlert(STR0159 + " [" + cNatureza + "] " + STR0161)
			ELSE
				cTxtRotAut += STR0159 + " [" + cNatureza + "] " + STR0161 +" "+ CRLF
			ENDIF
			lRet := .F.
		Endif
	EndIf
Endif

If lRet
	//Se esta marcado desmarca
	If (aLinSE1[nLin,1] * -1) != 1
		aLinSE1[nLin,1] := aLinSE1[nLin,1] * -1
	
		aLinSE1[nLin][nPosDesc]  	:=0
		aLinSE1[nLin][nPosJuros]	:=0
		aLinSE1[nLin][nPosMulta]	:=0
		
		if nPosImpRet > 0
			aLinSE1[nLin][nPosImpRet]	:=0
		endif
			
		for nI:=1 to nQtMoedas
			&("nPosBx" + Alltrim(Str(nI))) := Ascan(aCposSE1,"nBxMoeda" + Alltrim(Str(nI)))
			aLinSE1[nLin][&("nPosBx" + Alltrim(Str(nI)))] := 0
		Next nI
		aLinSE1[nLin][nPosBaixa] := 0
		a840Lock(nLin,.F.)
	
		FaMoedas()
		RefData(4,cNumFatAut)
		nValRec:= 0
		lRet := .F.
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³O titulo que teve seu ajuste de saldo por dif. de cambio nao pode ser baixado em³
		//³data anterior ao ajuste, porque senao o ajuste feito seria sobre o saldo errado ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc $ "ARG|COS"
			SE1->(MsGoto(aLinSE1[nLin][Len(aLinSE1[nLin])-1]))
			If SE1->E1_DTDIFCA>= dDataBase
				Help('',1,'BXDIFCAMB')
				lRet := .F.
			Endif
		Endif
	Endif
EndIF
If lRet .And. !a840Lock(nLin,.T.)
	lRet := .F.
Endif

If lRet .And. !lRotAuto
	//Bloqueia o painel para exibir a tela de pagamentos
	oPanel[nPanel]:lReadOnly:= .T.
	oPanBut:lReadOnly:=.T.
EndIf

//SE1->(DbSetorder(1))
//SE1->(DbSeek(xFilial("SE1")+aLinSE1[nLin][nPosPref]+aLinSE1[nLin][nPosNum]+;
//aLinSE1[nLin][nPosParc]+aLinSE1[nLin][nPosTipo]))
If lRet
	nValOrig	:= aLinSE1[nLin][nPosValor]
	nTotAbat	:= SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_MOEDA,"S",dDataRef)
	nParciais:= aLinSE1[nLin][nPosValor]-SE1->E1_SALDO
	
	If cPaisLoc == "COS" .And. SE1->E1_VALOR == SE1->E1_SALDO
		aConcepto := fa840Concept(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,Nil,{"2|3","2",SE1->E1_NATUREZ,SE1->E1_VALOR})
		nRetCfg := 0
		aEval(aConcepto,{|x| nRetCfg += x[5] })
	EndIf
	
	nDescont:= aLinSE1[nLin][nPosDesc]
	nJuros	:= aLinSE1[nLin][nPosJuros]
	nMulta	:= aLinSE1[nLin][nPosMulta]
	nValEstr:= 0
	dnCorrec	:= 0
	nSaldo	:= SE1->E1_SALDO-nTotAbat-nDescont+nMulta+nJuros-nRetCfg
	nValRec	:= aLinSE1[nLin][nPosBx] + nMulta - nDescont + nJuros
	nMotBx  := AScan(aMotBx,{|x| Substr(x,1,3)==aLinSE1[nLin][nPosMotBx]})
	cMotBx  := aDescMotBx[iif(nMotBx>0,nMotBx,1)]
	If !lRotAuto
		oMotBx:Refresh()
	EndIF
	
	If Empty(SE1->E1_MOEDA) .or. SE1->E1_MOEDA <= 1
		cM:="1"
	Else
		cM:=Alltrim(Str(SE1->E1_MOEDA))
	Endif
	cMoedOri:=SuperGetMv("MV_MOEDA" + cM)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de entrada antes da montagem da tela de baixas,		³
	//³permite que o analista configue os valores para baixa.	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("FA087ValBX")
		aValores[1] := nDescont
		aValores[2] := nJuros
		aValores[3] := nMulta
		aValores[4] := nValEstr
		aValores[5] := nCorrec
		aValores[6] := nSaldo
		aValores[7] := nValRec
		aValores[8] := Val(cM)
		aValores:=	ExecBlock("FA087ValBX",.F.,.F.,aValores)
		nDescont:=	aValores[1]
		nJuros	:=	aValores[2]
		nMulta	:=	aValores[3]
		nValEstr:=	aValores[4]
		nCorrec	:=	aValores[5]
		nSaldo	:=	aValores[6]-nTotAbat-nRetCfg
		nValRec	:=	aValores[7]
	Endif
	
	nI:=1
	For nI := 1 To nQtMoedas
		aLinBaixa[nI]:={SuperGetMV("MV_MOEDA"+Alltrim(Str(nI))),aLinSE1[nLin][anPosMoed[nI]]}
	Next nI
	
	//Caso a nValRec esteja zerada ou o valor do campo nBaixar (adicionado atraves da array aCposExtra depois do MontaGrid[2]) estiver zerado
	If nValRec == 0 .OR. aLinSE1[nLin][nPosBx] == 0
		nValRec := nSaldo +nRetCfg
		aLinBaixa[Val(cM)][2]:=nSaldo +nRetCfg
	Endif
EndIF

If lRet .And. !lRotAuto
	oLBBaixa:SetArray(aLinBaixa)
	oLBBaixa:bLine	:= { || {aLinBaixa[oLBBaixa:nAT][1],;
		Transform(aLinBaixa[oLBBaixa:nAT][2],PesqPict("SE1","E1_VALOR",18,oLBBaixa:nAT)) }}
	oLBBaixa:Refresh()
EndIf

If lRet
	cPictTit:=PesqPict("SE1","E1_VALOR",TamSX3("E1_VALOR")[1],aLinSE1[nLin][nPosMoed])

	If !lRotAuto
		oDescont:Picture:=cPictTit
		oMulta:Picture:=cPictTit
		oJuros:Picture:=cPictTit
		oValRec:Picture:=cPictTit
		oValOrig:Picture:=cPictTit
		oSaldo:Picture:=cPictTit
		If oRetCfg != Nil	//protecao para nao ocorrer errorlog em localizacoes diferentes de COS.
			oRetCfg:Picture:=cPictTit
		EndIf
		
		oParciais:Picture:=cPictTit
		
		oDescont:Refresh()
		oMulta:Refresh()
		oJuros:Refresh()
		oValRec:Refresh()
		oValOrig:Refresh()
		oSaldo:Refresh()
		oMoedOri:Refresh()
		If oRetCfg != Nil
			oRetCfg:Refresh()
		EndIf
		oParciais:Refresh()
		
		If lAltTitulo
			oPPagto:Show()
			oLbBaixa:SetFocus()
		Else
			Fa840BaixaOK(cNumFatAut)
		Endif
	EndIf
EndIf
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FAPagtoAtu  ºAutor  ³Microsiga         º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FAPagtoAtu()

	nSaldo	:= SE1->E1_SALDO-nTotAbat-nDescont+nMulta+nJuros-nRetCfg
	AEval(aLinBaixa,{|x,y| If(y==SE1->E1_MOEDA,x[2]:=nSaldo+nRetCfg,x[2]:=0)})

	oLBBaixa:bLine	:= { || {aLinBaixa[oLBBaixa:nAT][1],;
		Transform(aLinBaixa[oLBBaixa:nAT][2],PesqPict("SE1","E1_VALOR",18,oLBBaixa:nAT)) }}
	oLBBaixa:Refresh()

	oDescont:Refresh()
	oMulta:Refresh()
	oJuros:Refresh()
	oSaldo:Refresh()

	nValRec:=Round(nSaldo+nRetCfg,MsDecimais(SE1->E1_MOEDA))
	oValRec:Refresh()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DCLBMoed  ºAutor  ³Microsiga           º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DCLBMoed(cNumFatAut)
	Local nPosCpo
	Local nPosCpo1
	Local lRet:=.T.
	DEFAULT cNumFatAut := ""
	If oLBMoed:nAT > 1
		nPosCpo:=Ascan(aCposSE1,"nBxMoeda" + Alltrim(Str(oLBMoed:nAT)))
		nPosCpo1:=Ascan(aCposSE1,"E1_MOEDA")
		AEval(aLinSE1,{|x| If(x[1]==1 .And. (x[nPosCpo1]==oLBMoed:nAT .Or. x[nPosCpo]>0),lRet:=.F.,) })
		If !lRet
			Alert(STR0063)
		Else
			lEditCell(@aLinMoed,oLBMoed,PesqPict("SM2","M2_MOEDA"+AllTrim(Str(oLBMoed:nAT)),9),2)
		Endif
	Endif
	oLBMoed:SetFocus()
	FAMoedas()
	RefData(4,cNumFatAut)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DCLBBaixa  ºAutor  ³Microsiga          º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DCLBBaixa()
	Local nValSDesc,nDescFin
	Local nX:=1
	Local lAdiant:=(aLinSE1[oLBSE1:nAt][AScan(aCposSE1,"E1_TIPO")]$MVRECANT+"/"+MV_CRNEG .And. aLinSE1[oLBSE1:nAt][AScan(aCposSE1,"E1_MOEDA")] != oLBBaixa:nAT)
	Local bValid

	bValid := {|| a840VerPE(oLBBaixa:nAt,&(ReadVar()) ) }

	If !lAdiant
		lEditCell(@aLinBaixa,oLBBaixa,PesqPict("SE1","E1_VALOR",TamSx3("E1_VALOR")[1],oLBBaixa:nAt),2,,,bValid)
	EndIf
	nValRec:=0
	nMoedTit:=Iif(Empty(SE1->E1_MOEDA) .or. SE1->E1_MOEDA <= 1,1,SE1->E1_MOEDA)
	For nX:=1 to nQtMoedas
		If aLinMoed[nMoedTit][2]>0 .And. aLinMoed[nX][2]>0
			nValRec += aLinBaixa[nX][2]*(aLinMoed[nX][2]/aLinMoed[nMoedTit][2])
		Endif
	Next nX
	nValOri:=nValRec //Round(nValRec,MsDecimais(nMoedTit))
	oDescont:Refresh()
	oMulta:Refresh()
	oJuros:Refresh()
	oSaldo:Refresh()
	oValRec:Refresh()
	If SuperGetMV("MV_DESCFIN",,"I")=="P"   //verifica se o desconto financeiro pode ser parcial "P" ou integral "I"
		nDescFin:=FaDescFin("SE1",dDataRef,SE1->E1_SALDO,SE1->E1_MOEDA)
		If nDescFin<>0
			nValSDesc:=nValRec / ((100-SE1->E1_DESCFIN)/100)
			nDescFin:=nDescFin * (nValSDesc/SE1->E1_SALDO)
			nDescont:=nDescFin
			oDescont:Refresh()
		Endif
	Endif

	oLBBaixa:SetFocus()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa840BaixaOK  ºAutor  ³Microsiga      º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa840BaixaOK(cNumFatAut,nItem)
	Local nX:=0
	Local nPosTpSE1	:=	0
	Local lTemReceb := .F.
	Local nI := 0
	Local lRet := .T.
	Local nValorBx   := 0
	Local nValImpRet := 0

	Default cNumFatAut	:= ""
	Default nItem		:= 0

	If !lRotAuto
		F840MotBx()
		cMotBxSE1:=Substr(aMotBx[oMotBx:nAt],01,03)
	Endif

	nI:=0
	for nI:=1 to nQtMoedas
		&("nPosBx" + Alltrim(Str(nI))) := Ascan(aCposSE1,"nBxMoeda" + Alltrim(Str(nI)))
	Next nI
	nPosBx :=	Ascan(aCposSE1,"nBaixar")
	nPosTpSE1:=(AScan(aCposSE1,"E1_TIPO"))
	nX:=1


//Verifica se tem recebimentos no Panel 1
//Caso nao tenha, avisa ao usuario para selecionar primeiro as NCCs e RAs, pois eh possivel compensar 
//os titulos a receber com as RAs de mesmo valor sem a necessidade do recebimento de cheque, dinheiro etc.
	For nX := 1 to Len(aCols)
		If !aCols[nX][Len(aCols[nX])]
			lTemReceb  := .T.
			Exit
		EndIf
	Next nX

	For nX:=1 To nQtMoedas
		If !(aLinSE1[If(lRotAuto,nItem,oLBSE1:nAt)][nPosTpSE1]$(MVRECANT+"/"+MV_CRNEG) .Or. cMotBxSE1=="DAC") .And. ;
				Round(aLinBaixa[nX][2],MsDecimais(nX)) > Round(aLinBaixa[nX][2],MsDecimais(nX)) + Round(aLinMoed[nX][4],MsDecimais(nX))
			If lTemReceb
				If lRotAuto
					cTxtRotAuto += STR0050 + aLinMoed[nX][1] + STR0051 + CRLF + CRLF
				Else
					Alert(STR0050 + aLinMoed[nX][1] + STR0051) //"Saldo em "###" insuficiente para efetuar a baixa. "
				Endif
			Else
	   	//"Saldo em "###" insuficiente para efetuar a baixa. "		
	   	//"Como nao foram digitados recebimentos na tela inicial, selecione primeiro os documentos de credito do cliente(NCCs, RAs, etc.)"
				If lRotAutoc
					cTxtRotAuto += STR0050 + aLinMoed[nX][1] + STR0051 + CRLF + CRLF
				Else
					Alert(STR0050 + aLinMoed[nX][1] + STR0051) //"Saldo em "###" insuficiente para efetuar a baixa. "
				Endif
			EndIf
			Return .F.
		Endif
		If aLinBaixa[nX][2]>0 .And. aTaxa[nX]<=0
			If lRotAuto
				cTxtRotAuto += STR0052 + CRLF + CRLF
			Else
				Alert(STR0052) //"Informe todas as taxas das moedas que serão utilizadas nas Baixas."
			Endif
			Return .F.
		Endif
	Next nX

	nMoedTit:=Iif(Empty(SE1->E1_MOEDA) .or. SE1->E1_MOEDA <= 1,1,SE1->E1_MOEDA)
	nDec:= SuperGetMV("MV_CENT" + Iif(nMoedTit==1,"", Alltrim(Str(nMoedTit)) ) )
	If Round(nValRec,nDec)>Round(nSaldo+nRetCfg,nDec)
		If lRotAuto
			cTxtRotAut += STR0053 + CRLF + CRLF
		Else
			Alert(STR0053) //"Valor Recebido não pode ser maior que o saldo a receber."
		Endif
		Return .F.
	Endif
	If nValRec == 0 .And. Ascan(aLinSE1, {|x| x[1] == 1 }) <> 0
		If lRotAuto
			cTxtRotAut += STR0054 + CRLF + CRLF
		Else
			Alert(STR0054) //"Valor Recebido deve ser maior que zero."
		Endif
		Return .F.
	Endif
     

	If ExistBlock("F087ABXOK")
		lRet:= ExecBlock("F087ABXOK",.F.,.F.)
	EndIf
	If lRet
		nX:=1
		For nX:=1 To nQtMoedas
			nBx:=&("nPosBx" + Alltrim(Str(nX)))
			If lRotAuto
				aLinSE1[nItem][nBx]	:= aLinBaixa[nX][2]
			Else
				aLinSE1[oLBSE1:nAt][nBx] := aLinBaixa[nX][2]
			Endif
		Next nX
	
		If !lRotAuto
			nValorBx := nValRec-nMulta+nDescont-nJuros

			aLinSE1[oLBSE1:nAt][nPosDesc]	:= nDescont
			aLinSE1[oLBSE1:nAt][nPosJuros]	:= nJuros
			aLinSE1[oLBSE1:nAt][nPosMulta]	:= nMulta
			aLinSE1[oLBSE1:nAt][nPosBx]	:=  nValorBx //nValRec-nMulta+nDescont-nJuros
			aLinSE1[oLBSE1:nAt][nPosMotBx]	:= cMotBxSE1
			if nPosImpRet > 0
				aLinSE1[oLBSE1:nAt][nPosImpRet]	:= nRetCfg
			endif
		Endif
		If nValRec > 0
			If lRotAuto
				aLinSE1[nItem,1] := 1
			Else
				aLinSE1[oLBSE1:nAt,1] := 1
			Endif
		Endif
	EndIf
	If !lRotAuto
		oLBSE1:Refresh()
		RefData(4,cNumFatAut)
		oPanBut:lReadOnly		:=.F.
		oPanel[nPanel]:lReadOnly	:=.F.
		FaMoedas()
		oPPagto:Hide()
		oGetSel:oBrowse:SetFocus()
	Endif
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA840Unlock  ºAutor  ³Microsiga       º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA840Unlock()
	AEval(aRLocks,{|x,y| SE1->(MsRUnlock(x))})
	aRLocks:={}
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA840AtuCli  ºAutor  ³Microsiga       º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA840AtuCli(cNumFatAut,lIncAdt)
	DEFAULT cNumFatAut := ""

	cNome		:= Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NOME")
	cCGC		:= SA1->A1_CGC
	cTel		:= SA1->A1_TEL
	cContato	:= SA1->A1_CONTATO
	cCliori	:= cCliente
	cLojOri	:= cLoja
	RefData(2,cNumFatAut,lIncAdt)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FaGrv     ºAutor  ³Microsiga           º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FaGrv(aCampos,aLinha)
	AEval(aCampos,{|x,y| iIf(FieldPos(x)>0,FieldPut(FieldPos(ALLTRIM(x)),aLinha[y]),)})
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa840Cont  ºAutor  ³Microsiga          º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa840Cont()
	Local nHdlPrv	:=0
	Local cKeyImp 	:= ""
	Local cAlias	:= ""
	Local lAchou	:=.F.
	Local aFlagCTB 	:= {}
	Local lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
	Local nXE5 		:=0
	Local cPadrao 	:= ""
	nTotalLanc		:=0
	cArquivo		:= ""
	nLinha 			:= 1

	If lGeraLanc
	
	//+--------------------------------------------------------------+
	//¦ Posiciona numero do Lote para Lancamentos do Financeiro      ¦
	//+--------------------------------------------------------------+
		dbSelectArea("SX5")
		dbSeek(xFilial()+"09FIN")
		cLoteCom:=IIF(Found(),AllTrim(X5DESCRI()),"FIN")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa Lancamento Contabil                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nHdlPrv := HeadProva( cLoteCom,;
			"FINA840" /*cPrograma*/,;
			Substr( cUsuario, 7, 6 ),;
			@cArquivo )

		If nHdlPrv <= 0
			Help(" ",1,"A100NOPROV")
		EndIf
	Else
		Return
	EndIf

	If nHdlPrv > 0 .and. lGeraLanc
	
	//+--------------------------------------------------+
	//¦ Gera Lancamento Contab. para RECIBO.             ¦
	//+--------------------------------------------------+
		If lGeraLanc
			SEL->(DbSetOrder(8))
			SEL->(DbGotop())
			SEL->(DbSeek(xFilial("SEL")+cSerie+cRECIBO,.F.))
			Do while !SEL->(EOF()) .And. SEL->EL_SERIE==cSerie .And. SEL->EL_RECIBO==cRECIBO
			 
				Do Case
				Case SEL->EL_TIPODOC == "TB" .And. SEL->EL_TIPO $ MV_CRNEG+"/"+ MVRECANT .And. VerPadrao("5BN")
					lLancPad70 := .T.
					cPadrao := "5BN"
				Case SEL->EL_TIPODOC == "TB" .And. !(SEL->EL_TIPO $ MV_CRNEG+"/"+MVRECANT) .And. VerPadrao("5BO")
					lLancPad70 := .T.
					cPadrao := "5BO"
				Case SEL->EL_TIPODOC == "RA" .And. VerPadrao("5BP")
					lLancPad70 := .T.
					cPadrao := "5BP"
				Case SEL->EL_TIPODOC == "CH" .And. VerPadrao("5BQ")
					lLancPad70 := .T.
					cPadrao := "5BQ"
				Case SEL->EL_TIPODOC == "DC" .And. VerPadrao("5BR")
					lLancPad70 := .T.
					cPadrao := "5BR"
				Case SEL->EL_TIPODOC == "EF" .And. VerPadrao("5BS")
					lLancPad70 := .T.
					cPadrao := "5BS"
				Case SEL->EL_TIPODOC == "TF" .And. VerPadrao("5BT")
					lLancPad70 := .T.
					cPadrao := "5BT"
				Case SEL->EL_TIPODOC $ "RS/RL/RB/RI/RG/RR" .And. VerPadrao("5BU")
					lLancPad70 := .T.
					cPadrao := "5BU"
				Otherwise
					lLancPad70 := VerPadrao("575")
					cPadrao := "575"
				EndCase
				If lLancPad70
					SA6->(DbsetOrder(1))
					SA6->(DbSeek(xFilial("SA6")+SEL->EL_BANCO+SEL->EL_AGENCIA+SEL->EL_CONTA,.F.))
				
					SE1->(DbsetOrder(2))
					SE1->(DbSeek(xFilial("SE1")+SEL->EL_CLIORIG+SEL->EL_LOJORIG+SEL->EL_PREFIXO+SEL->EL_NUMERO+SEL->EL_PARCELA+SEL->EL_TIPO,.F.))
				
					Do Case
					Case ( Alltrim(SEL->EL_TIPO) == Alltrim(GetSESnew("NCC")) )
						cAlias := "SF1"
					Case ( Alltrim(SEL->EL_TIPO) == Alltrim(GetSESnew("NDE")) )
						cAlias := "SF1"
					Otherwise
						cAlias := "SF2"
					EndCase
					cKeyImp := 	xFilial(cAlias)	+;
						SE1->E1_NUM		+;
						SE1->E1_PREFIXO	+;
						SE1->E1_CLIENTE	+;
						SE1->E1_LOJA
					If ( cAlias == "SF1" )
						cKeyImp += SE1->E1_TIPO
					Endif
					Posicione(cAlias,1,cKeyImp,"F"+SubStr(cAlias,3,1)+"_VALIMP1")
					lAchou:=.F.
	
					SE5->(DbSetOrder(2))
				//Nos casos de baixas parciais pelo recibo gera registros com a mesma chave.
				//A diferenca estah no campo E5_ORDREC(numero do recibo)		
					If SE5->(DbSeek(xFilial("SE5")+"BA"+SEL->EL_PREFIXO+SEL->EL_NUMERO+SEL->EL_PARCELA+SEL->EL_TIPO))
						While xFilial("SE5") == SE5->E5_FILIAL .And. SEL->EL_PREFIXO == SE5->E5_PREFIXO .And.;
								SEL->EL_NUMERO == SE5->E5_NUMERO .And. SEL->EL_PARCELA == SE5->E5_PARCELA .And.;
								SEL->EL_TIPO == SE5->E5_TIPO .And. SE5->E5_TIPODOC == "BA" .And.!SE5->(Eof()) .And. !lAchou
							If (SE5->E5_ORDREC == cRECIBO .And. SE5->E5_SERREC== cSerie )
								lAchou:=.T.
							Else
								SE5->(DbSkip())
							EndIf
						
						EndDo
					EndIf
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Prepara Lancamento Contabil                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
						aAdd( aFlagCTB, {"EL_LA", "S", "SEL", SEL->( Recno() ), 0, 0, 0} )
					Endif
					nTotalLanc := nTotalLanc + DetProva( nHdlPrv,;
						cPadrao,;
						"FINA840" /*cPrograma*/,;
						cLoteCom,;
						@nLinha,;
											                    /*lExecuta*/,;
											                    /*cCriterio*/,;
											                    /*lRateio*/,;
											                    /*cChaveBusca*/,;
											                    /*aCT5*/,;
											                    /*lPosiciona*/,;
											                    @aFlagCTB,;
											                    /*aTabRecOri*/,;
											                    /*aDadosProva*/ )
	
	
				If UsaSeqCor()
					AAdd(aDiario,{"SEL",SEL->(Recno()),cDiario,"EL_NODIA","EL_DIACTB"})
				EndIf
			Endif	
			
			SEL->(DbSkip())
		EndDo
		If cPaisLoc == "PER"
  		   For nXE5 := 1 to Len(aRecnoITF)
		       SE5->(DbGoto(aRecnoITF[nXE5]))
               If lFindITF 
                  FinProcITF(SE5->(Recno()),8,SE5->E5_VALOR,.F.,{nHdlPrv,cPadrao,"FINA840","FINA840",cLotecom})
               Endif   
           Next
		Endif
	Endif
	
	//+-----------------------------------------------------+
	//¦ Envia para Lancamento Contabil, se gerado arquivo   ¦
	//+-----------------------------------------------------+
	SEL->(DbSetOrder (8))
	SEL->(DbSeek(xFilial("SEL")+cSerie+cRecibo))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetiva Lan‡amento Contabil                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RodaProva(	nHdlPrv,; 
						nTotalLanc )

		lLanctOk := cA100Incl(	cArquivo,;
										nHdlPrv,;
										3 /*nOpcx*/,;
										cLoteCom,;
										lDigita,;
										lAglutina,;
										/*cOnLine*/,;
										/*dData*/,;
										/*dReproc*/,;
										@aFlagCTB,;
										/*aDadosProva*/,;
										aDiario )
		aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento


	If lLanctOk
		SEL->(DbSetOrder (8))
		If SEL->(DbSeek(xFilial("SEL")+cSerie+cRecibo))
			Do while SEL->EL_SERIE==cSerie .And. SEL->EL_RECIBO==cRecibo
				RecLock("SEL",.F.)
				Replace EL_LA With "S"
				MsUnLock()
				SEL->(DbSkip())
			Enddo
		EndIf
	Endif
EndIf
Return


Static Function Fa840Cancel(nPan,nLPan)

					FA840Unlock()

					If nPan == nLPan
						FA840aCtbA(2)
					EndIf

		Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³a840Lock  ºAutor  ³Microsiga           º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
						Static Function a840Lock(nPos,lLock)
					Local nPosRec	:=	0
					Local lRet	:=	.T.
					If aLinSE1[nPos,Len(aLinSE1[1])-1] <> Nil
						If lLock
							SE1->(DbGoTo(aLinSE1[nPos,Len(aLinSE1[1])-1]))
							If SE1->(MsRLock(RECNO()))
								AAdd(aRLocks,SE1->(RECNO()))
							Else
								Alert(OemToAnsi(STR0073)) //"El registro esta en uso por otra estacion"
								lRet	:=	.F.
							Endif
						Else
							SE1->(DbGoTo(aLinSE1[nPos,Len(aLinSE1[1])-1]))
							SE1->(MsRUnlock(RECNO()))
							nPosRec	:=	AScan(aRLocks,SE1->(RECNO()))
							If nPosRec != 0
								ADel(aRLocks,nPosRec)
								ASize(aRLocks,Len(aRLocks)-1)
							EndIf
						Endif
					EndIf

					Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A840Sugerir  ºAutor  ³Microsiga       º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
				Static Function A840Sugerir()

					Local nPosPref	:= AScan(aCposSE1,"E1_PREFIXO")
					Local nPosNum 	:= AScan(aCposSE1,"E1_NUM")
					Local nPosParc	:= AScan(aCposSE1,"E1_PARCELA")
					Local nPosTipo	:= AScan(aCposSE1,"E1_TIPO")
					Local nPosValor	:= AScan(aCposSE1,"E1_VALOR")
					Local nJ			:= 0
					Local aRet := {}

					nPosBx :=	Ascan(aCposSE1,"nBaixar")

					SE1->(DbSetorder(1))
					For nJ:=1 to Len(aLinSE1)

						SE1->(DbSeek(xFilial("SE1")+aLinSE1[nJ][nPosPref]+aLinSE1[nJ][nPosNum]+;
							aLinSE1[nJ][nPosParc]+aLinSE1[nJ][nPosTipo]))
						If cPaisLoc $ "ARG|COS"
							If SE1->E1_DTDIFCA >= dDataBase
								nJ++
								Loop
							Endif
						Endif
						If !a840Lock(nJ,.T.)
							nJ++
							Loop
						Endif
						nValOrig	:= aLinSE1[nJ][nPosValor]
						nTotAbat	:= SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_MOEDA,"S",dDataRef)
						nParciais	:= aLinSE1[nJ][nPosValor]-SE1->E1_SALDO
	
						nDescont	:= aLinSE1[nJ][nPosDesc]
						nJuros		:= aLinSE1[nJ][nPosJuros]
						nMulta		:= aLinSE1[nJ][nPosMulta]
						nValEstr	:= 0
						dnCorrec	:= 0
						nSaldo		:= SE1->E1_SALDO-nTotAbat-nRetCfg-nDescont+nMulta+nJuros
						nValRec		:= nSaldo  + nRetCfg

						nBx:=Ascan(aCposSE1,"nBxMoeda" + Alltrim(Str(SE1->E1_MOEDA)))
	
						If aLinMoed[SE1->E1_MOEDA][4] >= nValRec-nMulta+nDescont-nJuros .Or. aLinSE1[nj][nPosTipo]$MVRECANT+"/"+MV_CRNEG
							aLinSE1[nJ][nBx]		:= nValRec
							aLinSE1[nJ][nPosDesc]	:= nDescont
							aLinSE1[nJ][nPosJuros]	:= nJuros
							aLinSE1[nJ][nPosMulta]	:= nMulta
							aLinSE1[nJ][nPosBx]	  	:= nValRec-nMulta+nDescont-nJuros
							aLinSE1[nJ][nPosMotBx] 	:= "NOR"
							If aLinSE1[nJ][nPosTipo] $ MVRECANT+"/"+MV_CRNEG
								aLinMoed[SE1->E1_MOEDA][4]+=nValRec-nMulta+nDescont-nJuros
							Else
								aLinMoed[SE1->E1_MOEDA][4]-=nValRec-nMulta+nDescont-nJuros
							Endif
							If nValRec>0
								aLinSE1[nJ,1] := 1
							Endif
						Endif
					Next nJ

					If ExistBlock("F087BTNSG")
						aRetLinSE1 := ExecBlock("F087BTNSG",.F.,.F.,{aLinSE1,aLinMoed})
						If ValType(aRet) == "A" .And. Len(aRet) == 2 //Se o retorno foi um array e se esta com duas dimensoes (aLinSE1 e aLinMoed)
							aLinSe1 := IIf(Len(aRet[1]) == Len(aLinSE1), aClone(aRet[1]), aLinSE1) //Se estiver com o mesmo tamanho do array original, atribuo o novo array
							aLinMoed := IIf(Len(aRet[2]) == Len(aLinMoed), aClone(aRet[2]), aLinMoed) //Se estiver com o mesmo tamanho do array original, atribuo o novo array
						EndIf
					EndIf

					oLbSE1:Refresh()
					FaMoedas()
					Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A840Filtrar  ºAutor  ³Microsiga       º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
				Static Function A840Filtrar(nPan,cNumFatAut)

					Local aCpos:={}
					Local ctitulo
					Local oBtn
					Local oBtnOp
					Local cCampo := ""
					Local aStrOp
					Local cOper
					Local oExpr
					Local cExpr:=""
					Local oCampo
					Local aCampo:={}
					Local cTxtFil := ""
					Local cExpFil := ""
					Local oTxtFil
					Local oOper
					Local oMatch
					Local nMatch := 0
					Local nI := 0

					Private lMarca := -1

					Default cNumFatAut :=""

					oGetSEL:oBrowse:lDisablepaint:=.T.
					If nPan==2
						aCpos:=aClone(aCabSA1)
	// Adiciona campo de Marca
						AADD(aCampo,{lMarca,STR0074,.F.,"01",1,Space(45),"N",0}) //"Selecionado"
						For nI:= 1 to Len(aHeadSA1)
							AADD(aCampo,{aHeadSA1[nI][2],aHeadSA1[nI][1],.T.,"01",aHeadSA1[nI][4],If(Empty(aHeadSA1[nI][3]),Space(45),aHeadSA1[nI][3]),aHeadSA1[nI][8],aHeadSA1[nI][5]})
						Next nI
					Endif
					If nPan==3
						aCpos:=aClone(aCabSE1)
	// Adiciona campo de Marca
						AADD(aCampo,{lMarca,STR0074,.F.,"01",1,Space(45),"N",0}) //"Selecionado"
						For nI:= 1 to Len(aHeadSE1)
							AADD(aCampo,{aHeadSE1[nI][2],aHeadSE1[nI][1],.T.,"01",aHeadSE1[nI][4],If(Empty(aHeadSE1[nI][3]),Space(45),aHeadSE1[nI][3]),aHeadSE1[nI][8],aHeadSE1[nI][5]})
						Next nI
					Endif
					nI:=1

					cTitulo:=STR0066 //"Filtrar"

					DEFINE MSDIALOG oDlgPesq TITLE OemToAnsi(cTitulo) FROM 000,000 TO 250,405 PIXEL OF oDlgRecibo

					aStrOp := { OemToAnsi(STR0075),OemToAnsi(STR0076),OemToAnsi(STR0077),OemToAnsi(STR0078),OemToAnsi(STR0079),OemToAnsi(STR0080),OemToAnsi(STR0081),OemToANsi(STR0082 ),OemToANsi(STR0083),OemToAnsi(STR0084)}	//  //"Igual a"###"DIferente de"###"Menor que"###"Menor ou igual a"###"Maior que"###"Maior ou igual a"###"Cont‚m a express„o"###"N„o cont‚m"###"Est  contido em"###"N„o est  contido em"
					@ 05,005 SAY OemToAnsi(STR0085) SIZE 20,8 PIXEL OF oDlgPesq //  //"Campo:"
					@ 05,060 SAY OemToAnsi(STR0086) SIZE 30,8 PIXEL OF oDlgPesq   //  //"Operador:"
					@ 05,115 SAY OemToAnsi(STR0087) SIZE 30,8 PIXEL OF oDlgPesq  //  //"Express„o:"
					@ 50,005 SAY OemToAnsi(STR0088) SIZE 20,8 PIXEL OF oDlgPesq  //  //"Filtro:"

					@ 35,005 BUTTON oBtna PROMPT OemToAnsi(STR0089) SIZE 35,10 OF oDlgPesq PIXEL ; //"&Adiciona"
					ACTION (cTxtFil := BuildTxt(cTxtFil,Trim(cCampo),cOper,cExpr,.t.,@cExpFil,aCampo,oCampo:nAt,oOper:nAt),cExpr := CalcField(oCampo:nAt,aCampo),BuildGet(oExpr,@cExpr,aCampo,oCampo,oDlgPesq),oTxtFil:Refresh(),oBtne:Enable(),oBtnOp:Disable(),oBtnOu:Enable(),oBtnExp:Disable(),oBtna:Disable(),oBtne:Refresh(),oBtnou:Refresh(),oBtna:Refresh()) ;
						FONT oDlgPesq:oFont //

					@ 35,45 BUTTON oBtn PROMPT OemToAnsi(STR0090) SIZE 35,10 OF oDlgPesq PIXEL ; //"&Limpa Filtro"
					ACTION (cTxtFil := "",cExpFil := "",nMatch := 0,oTxtFil:Refresh(),oBtnExp:Enable(),oBtnA:Enable(),oBtnE:Disable(),oBtnOu:Disable(),oMatch:Disable(),oBtnOp:Enable()) ;
						FONT oDlgPesq:oFont //

					@ 35,85 BUTTON oBtnExp PROMPT OemToAnsi(STR0091) SIZE 35,10 OF oDlgPesq PIXEL ; //"&Express„o"
					ACTION (lRet:=FilterExp(@cTxtFil,@cExpFil),oTxtFil:Refresh(),If(lRet,oBtnOp:Disable(),oBtnOp:Enable()),If(lRet,oBtnExp:Disable(),oBtnExp:Enable()),If(lRet,oBtna:Disable(),oBtna:Enable()),If(lRet,oBtnE:Enable(),oBtnE:Disable()),If(lRet,oBtnOu:Enable(),oBtnOu:Disable())) ;
						FONT oDlgPesq:oFont  //

					@ 30,175 BUTTON oBtnOp PROMPT OemToAnsi("(") SIZE 12,12 OF oDlgPesq PIXEL FONT oDlgPesq:oFont ;
						ACTION (If(nMatch==0,oMatch:Enable(),nil),nMatch++,cTxtFil+= " ( ",cExpFil+="(",oTxtFil:Refresh()) ;

						@ 30,190 BUTTON oMatch PROMPT OemToAnsi(")") SIZE 12,12 OF oDlgPesq PIXEL FONT oDlgPesq:oFont;
						ACTION (nMatch--,cTxtFil+= " ) ",cExpFil+=")",If(nMatch==0,oMatch:Disable(),nil),oTxtFil:Refresh()) ;

						@ 45,175 BUTTON oBtne PROMPT OemToAnsi(STR0092) SIZE 12,12 OF oDlgPesq PIXEL FONT oDlgPesq:oFont; //" E "
					ACTION (cTxtFil+=STR0092,cExpFil += ".and.",oTxtFil:Refresh(),oBtne:Disable(),oBtnou:Disable(),oBtnExp:Enable(),oBtna:Enable(),oBtne:Refresh(),oBtnou:Refresh(),oBtna:Refresh(),oBtnOp:Enable()) ; //" e "

					@ 45,190 BUTTON oBtnOu PROMPT OemToAnsi(STR0093) SIZE 12,12 OF oDlgPesq PIXEL FONT oDlgPesq:oFont; //" OU "
					ACTION (cTxtFil+=STR0093,cExpFil += ".or.",oTxtFil:Refresh(),oBtne:Disable(),oBtnou:Disable(),oBtnExp:Enable(),oBtna:Enable(),oBtne:Refresh(),oBtnou:Refresh(),oBtna:Refresh(),oBtnOp:Enable()) //" ou "
					oMatch:Disable()

					cCampo := aCpos[1]
					@ 15,05 COMBOBOX oCampo VAR cCampo ITEMS aCpos SIZE 50,50 OF oDlgPesq PIXEL;
						ON CHANGE BuildGet(oExpr,@cExpr,aCampo,oCampo,oDlgPesq,,oOper:nAt)
					cExpr := CalcField(oCampo:nAt,aCampo)
					cOper := aStrOp[1]

					@ 15,60 COMBOBOX oOper VAR cOper ITEMS aStrOp SIZE 50,50 OF oDlgPesq PIXEL;
						ON CHANGE BuildGet(oExpr,@cExpr,aCampo,oCampo,oDlgPesq,,oOper:nAt)

					@ 15,115 MSGET oExpr VAR cExpr SIZE 85,10 PIXEL OF oDlgPesq PICTURE AllTrim(aCampo[oCampo:nAt,6]) FONT oDlgPesq:oFont

					@ 60,05 GET oTxtFil VAR cTxtFil MEMO SIZE 195,40 PIXEL OF oDlgPesq READONLY
					oTxtFil:bRClicked := {||AlwaysTrue()}

					oBtne:Disable()
					oBtnou:Disable()

					DEFINE SBUTTON FROM 113,070  TYPE 1  ACTION (aFilOK(cExpFil,cNumFatAut),oDlgPesq:End()) OF oDlgPesq When .T.
					DEFINE SBUTTON FROM 113,100  TYPE 2  ACTION (oDlgPesq:End()) OF oDlgPesq When .T.

					ACTIVATE MSDIALOG oDlgPesq CENTERED

					If nPan==2
						oLBCli:SetArray(aLinSA1)
						oLBCli:bLine:= { || &(cBLinSA1 + "}") }
						oLBCli:Refresh()
					Endif
					If nPan==3
						oLBSE1:SetArray(aLinSE1)
						oLBSE1:bLine:= { || &(cBLinSE1 + "}") }
						oLBSE1:Refresh()
					Endif

					oGetSEL:oBrowse:lDisablepaint:=.F.
					Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcField  ºAutor  ³Microsiga          º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
				Static Function CalcField(nAt,aCampo)
					Local cRet

					If aCampo[nAt,7] == "C"
						cRet := Space(aCampo[nAt,5])
					ElseIf aCampo[nAt,7] == "N"
						cRet := 0
					ElseIf aCampo[nAt,7] == "D"
						cRet := CTOD("  /  /  ")
					EndIf
					Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BuildTxt  ºAutor  ³Microsiga           º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
				Static Function BuildTxt(cTxtFil,cCampo,cOper,xExpr,lAnd,cExpFil,aCampo,nCpo,nOper)
					Local cChar := OemToAnsi(CHR(39))
					Local cType := ValType(xExpr)
					Local aOper := { "==","!=","<","<=",">",">=","..","!.","$","!x"}

					cTxtFil += cCampo+" "+cOper+" "+If(cType=="C",cChar,"")+cValToChar(xExpr)+If(cType=="C",cChar,"")

					If cType == "C"
						#ifndef TOP
							If aOper[nOper] == "!."    //  Nao Contem
								cExpFil += '!('+'"'+AllTrim(cValToChar(xExpr))+'"'+' $ AllTrim('+aCampo[nCpo,1]+'))'   // Inverte Posicoes
							ElseIf aOper[nOper] == "!x"   // Nao esta contido
								cExpFil += '!(AllTrim('+aCampo[nCpo,1]+") $ " + '"'+AllTrim(cValToChar(xExpr))+'")'
							ElseIf aOper[nOper]	== ".."  // Contem a Expressao
								cExpFil += '"'+AllTrim(cValToChar(xExpr))+'"'+" $ AllTrim("+aCampo[nCpo,1] +" )"   // Inverte Posicoes
							#else
								If  aOper[nOper] == "!."    //  Nao Contem
									cExpFil += '!('+'"'+AllTrim(cValToChar(xExpr))+'"'+' $ '+aCampo[nCpo,1]+')'   // Inverte Posicoes
								ElseIf aOper[nOper] == "!x"   // Nao esta contido
									cExpFil += '!('+aCampo[nCpo,1]+" $ " + '"'+AllTrim(cValToChar(xExpr))+'")'
								ElseIf aOper[nOper]	== ".."  // Contem a Expressao
									cExpFil += '"'+AllTrim(cValToChar(xExpr))+'"'+" $ "+aCampo[nCpo,1] +" "   // Inverte Posicoes
								#endif
							Else
								#ifndef TOP
									If (aOper[nOper]=="==")
										cExpFil += aCampo[nCpo,1] +aOper[nOper]+" "
										cExpFil += '"'+cValToChar(xExpr)+'"'
									Else
										cExpFil += 'Alltrim('+aCampo[nCpo,1] +')' +aOper[nOper]+" "
										cExpFil += '"'+AllTrim(cValToChar(xExpr))+'"'
									EndIf
								#else
									If (aOper[nOper]=="==")
										cExpFil += aCampo[nCpo,1] +aOper[nOper]+" "
										cExpFil += '"'+cValToChar(xExpr)+'"'
									Else
										cExpFil += 'Alltrim('+aCampo[nCpo,1] +')' +aOper[nOper]+" "
										cExpFil += '"'+AllTrim(cValToChar(xExpr))+'"'
									EndIf
								#endif
							EndIf
						ElseIf cType == "D"
	// Nao Mexer, deixar dToS pois e'a FLAG Para Limpeza do Filtro
	// 						 
							cExpFil += "dToS("+aCampo[nCpo,1]+") "+aOper[nOper]+' "'
							cExpFil += Dtos(CTOD(cValToChar(xExpr)))+'"'
						Else
							cExpFil += aCampo[nCpo,1]+" "+aOper[nOper]+" "
							cExpFil += cValToChar(xExpr)
						EndIf

						Return cTxtFil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FilterExp  ºAutor  ³Microsiga          º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function FilterExp(cTxtFil,cExpFil)

						Local oDlg, oBtn, cExpr := Space(255), oPai
						Local lProcess := .f.

						oPai:= GetWndDefault()

						DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0094) FROM 0,0 TO 100,500 OF oPai PIXEL //"Expressão:"

						@ 10,10 MSGET oExpr VAR cExpr SIZE 230,10 OF oDlg PIXEL

						@ 30,10 TO 30,240 OF oDlg PIXEL

						@ 35,10 BUTTON oBtn PROMPT OemToAnsi(STR0089) SIZE 40,10 PIXEL ACTION (lProcess := .t.,oDlg:End()) //  //"&Adiciona"

						@ 35,55 BUTTON oBtn PROMPT OemToAnsi(STR0095) SIZE 40,10 PIXEL ACTION oDlg:End() //  //"&Cancela"

						ACTIVATE MSDIALOG oDlg CENTERED

						If lProcess

							cTxtFil += Trim(cExpr)
							cExpFil += Trim(cExpr)

	// Retorno correto para o Enable/Disable dos botoes.
							If Empty(cExpr)
								lProcess:= .F.
							EndIf

						EndIf
						Return lProcess


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AFilOk    ºAutor  ³Microsiga           º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function AFilOk(xExpr,cNumFatAut)

						DEFAULT cNumFatAut := ""

						aFiltros[nPanel]:=xExpr
						Refdata(nPanel,cNumFatAut)

						Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A840Desconto  ºAutor  ³Microsiga       º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function A840Desconto()
						oPanel[nPanel]:lReadOnly:=.T.
						oPanBut:lReadOnly:=.T.
						oCBMoed1:nAt:=nMoedDesc
						oPDesc:Show()
						Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A840OKDesc  ºAutor  ³Microsiga         º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function A840OKDesc(cNumFatAut)
						Local anTotBx
						Local nX
						DEFAULT cNumFatAut := ""

						If aTaxa[nMoedDesc]<=0
							Alert(STR0052) //"Informe todas as taxas das moedas que serão utilizadas nas Baixas."
							Return .F.
						Endif

// Para poder fazer a validação do valor do desconto, transformo o valor 
// total de baixas para a moeda em que o desconto foi dado, depois faco a comparacao.
						nTot:=0
						nX:=0
						If nDescTot > 0
							anTotBx:=SomaBaixa()
							For nX := 1 to Len(anTotBx)
								nTot += anTotBx[nX]*aTaxa[nX]
							Next nX
							nTot:=nTot/aTaxa[nMoedDesc]
							If nDescTot > nTot
								Alert(STR0096)  //"Valor do desconto não pode ser maior que o valor a baixar."
								Return .F.
							Endif
						EndIf

						nDescGer:=nDescTot
						nPercGer:=nPercDesc
						oPDesc:Hide()
						FaMoedas()
						oPanBut:lReadOnly:=.F.
						oPanel[nPanel]:lReadOnly:=.F.
						RefData(4,cNumFatAut)
						Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F840MotBx  ºAutor  ³Microsiga         º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F840MotBx()
						If oMotBx:nAt>1
							nDescont:= aLinSE1[oLBSE1:nAt][nPosDesc]
							nJuros	:= aLinSE1[oLBSE1:nAt][nPosJuros]
							nMulta	:= aLinSE1[oLBSE1:nAt][nPosMulta]
							oDescont:Disable()
							oMulta:Disable()
							oJuros:Disable()
							FAPagtoAtu()
						Else
							oDescont:Enable()
							oMulta:Enable()
							oJuros:Enable()
						Endif
						Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³a840VerPE  ºAutor  ³Microsiga          º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

					Static Function a840VerPE(nMoeda,nValor)
						Local lRet := .T.
						Local cVar
						If ExistBlock("Fa087Pg")
							cVar := ReadVar()
							lRet := ExecBlock("Fa087Pg",.F.,.F.,{nMoeda,nValor})
							&(cVar) := aLinBaixa[nMoeda][2]
							If oRetCfg != Nil
								oRetCfg:Refresh()
							EndIf
							oParciais:Refresh()
							oDescont:Refresh()
							oMulta:Refresh()
							oJuros:Refresh()
							oLBBaixa:SetArray(aLinBaixa)
							oLBBaixa:bLine 	:= { || {aLinBaixa[oLBBaixa:nAT][1],;
								Transform(aLinBaixa[oLBBaixa:nAT][2],PesqPict("SE1","E1_VALOR",18,oLBBaixa:nAT)) }}
							oLBBaixa:Refresh()
						EndIf

						Return lRet


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³TelaAdmCar³ Autor ³ Fernando Machima      ³ Data ³19/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mostra a tela para selecionar a administradora de cartao de³±±
±±³          ³ credito                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA840                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function TelaAdmCar(cPref,cNum,cParc,nValor,nMoeda,n)

						Local oDlgAdm,oCbxAdm,olbl1,olbl2,oBtn1
						Local cCodAdm  := ""
						Local aAdm     := {}
						Local aSAE     := {}
						Local lRet     := .T.
						Local aAreaAtu := GetArea()
						Local aAreaSA1 := SA1->(GetArea())
						Local aAreaSAE := SAE->(GetArea())
                                                       
						DEFINE FONT oFnt  NAME "Times New Roman" SIZE 7,15
						DEFINE FONT oFntB NAME "Times New Roman" SIZE 7,15 BOLD

						DbSelectArea("SAE")
						DbSetOrder(1)
						DbGoTop()
						While !Eof()
							If (AllTrim(SAE->AE_TIPO) == "CC") .or. (AllTrim(SAE->AE_TIPO) == "CD")
								AAdd(aAdm,SAE->AE_COD +" - "+SAE->AE_DESC)
								SA1->(dbSetOrder(1))
								SA1->(dbSeek(xFilial("SA1")+SAE->AE_COD))
								AAdd(aSAE,{SA1->A1_COD,SA1->A1_LOJA,SubStr(SA1->A1_NOME,1,30),SAE->AE_TIPO})
							EndIf
							DbSkip()
						End

						If Len(aAdm) == 0
							MsgStop(OemToAnsi(STR0103)) //"Nao e possivel efetuar a baixa dos titulos porque nao existe uma Administradora Financeira de Cartao de Credito/Debito cadastrada"
							lRet := .F.
						Else
	//Limpa o array para que sejam armazenados apenas os 
	//dados mais recentes...
		
							DEFINE MSDIALOG oDlgAdm FROM  34,155 TO 245,510 ;
								TITLE STR0104 PIXEL //"Administradora de Cartao de Credito"

							@  05, 05 Group olbl1 TO 045,173 LABEL OemToAnsi(STR0105) OF oDlgAdm PIXEL //" Dados do Recebimento "
		              
							@  15, 010 SAY STR0106       FONT oFnt  PIXEL SIZE 50,18 COLOR CLR_RED,CLR_WHITE //"Numero: "
							@  15, 040 SAY oNum VAR cNum FONT oFntB PIXEL SIZE 50,18 COLOR CLR_BLACK,CLR_WHITE
	
							@  15, 075 SAY STR0107         FONT oFnt  PIXEL SIZE 50,18 COLOR CLR_RED,CLR_WHITE //"Prefixo: "
							@  15, 110 SAY oPref VAR cPref FONT oFntB PIXEL SIZE 50,18 COLOR CLR_BLACK,CLR_WHITE
	
							@  25, 010 SAY STR0108         FONT oFnt  PIXEL SIZE 50,18 COLOR CLR_RED,CLR_WHITE //"Parcela: "
							@  25, 040 SAY oParc VAR cParc FONT oFntB PIXEL SIZE 50,18 COLOR CLR_BLACK,CLR_WHITE
	
							@  25, 075 SAY STR0109       FONT oFnt PIXEL SIZE 50,18 COLOR CLR_RED,CLR_WHITE //"Valor: "
							@  25, 110 SAY oValor VAR Transform(nValor,PesqPict("SEL","EL_VALOR",,nMoeda)) FONT oFntB PIXEL SIZE 50,18 COLOR CLR_BLACK,CLR_WHITE
                                                                                     
							@  50, 005 Group olbl2 TO 75,173 LABEL OemToAnsi(STR0110) OF oDlgAdm PIXEL //" Administradora "
		
							@  60, 010 COMBOBOX oCbxAdm VAR cCodAdm ITEMS aAdm SIZE 70,35 OF oDlgAdm PIXEL
	
							DEFINE SBUTTON oBtn1 FROM 085,145 TYPE 1 ENABLE;
								ACTION (AAdd(aDadosAdm,{aSAE[oCbxAdm:nAt][01],aSAE[oCbxAdm:nAt][02],;
								aSAE[oCbxAdm:nAt][03],aSAE[oCbxAdm:nAt][04],n}),oDlgAdm:End());
								OF oDlgAdm PIXEL
	
							ACTIVATE DIALOG oDlgAdm CENTERED
						EndIf

//Restaura as areas originais...
						SA1->(RestArea(aAreaSAE))
						SA1->(RestArea(aAreaSA1))
						RestArea(aAreaAtu)

						Return(lRet)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA840COB  ³ Autor ³ Paulo Augusto         ³ Data ³07/08/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida para saber se o recibo pertence ao cobrador e tb se ³±±
±±³          ³ esse talao ja esta fechado                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA840                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function FA840Cob(cTipo)
// Paulo
						Local aArea:=GetArea()
						Local lRet:=.F.
						Local lValSer

						lValSer := SuperGetMv('MV_SERREC') // Usando serie nos recibos

						If !Empty(cCobrador)
							DbSelectArea("SAQ")
							DbSetOrder(1)
							If dbSeek(xFilial("SAQ")+cCobrador)
								nRecnoSAQ:=Recno()
								If SAQ->AQ_TIPOREC=="3" .or. cTipo <> SAQ->AQ_TIPOREC .or. cTipo= "3"
									lRet:=.T.
								Else
									cRecComp	:= Iif(SAQ->AQ_TIPOREC =="1",cRecibo,cRecProv)
									cTipo 	:= SAQ->AQ_TIPOREC // Valida Tipo do Recibo do Cobrador
									DbSelectArea("SEY")
									DbSetOrder(1)
									If dbSeek(xFilial("SEY")+cCobrador)
				//So validar a serie quando é um recibo definitivo, provisorio nao tem serie
										While !EOF() .and. cCobrador == SEY->EY_COBRAD
											If SEY->EY_STATUS<>"2" .and. cTipo == SEY->EY_TIPOREC .and. ;
													cRecComp  >= SEY->EY_RECINI .and. cRecComp <= SEY->EY_RECFIN .and.;
													if(lValser .And. cTipo == '1', cSerie== SEY->EY_SERIE .Or. Empty(SEY->EY_SERIE),.T.)
												lRet:=.T.
												nRecno:=Recno()
												Exit
											EndIf
											DbSkip()
										Enddo
									EndIf
									If !lRet
										HELP(" ",1,"A087NUMV")
									EndIf
								EndIf
							Else
								Help(" ",1,"RECNO")
							EndIf
						Else
							lRet:=.T.
						EndIf
						RestArea(aArea)
						Return(lRet)



/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fa840Com  ³ Autor ³ Paulo Augusto         ³ Data ³07/08/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava o arquivo de comissoes  de cobrador                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA840                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function Fa840Com()

						Local aCpoSEX:={}
						SAQ->(dbGoto(nRecnoSAQ))
//SE MUDAR ALGUMA POSICAO DO ARRAY ABAIXO, PRECISA CORRIGIR TB NOS FONTES FINA016/FINA87A/FINA088.
						AADD(aCpoSEX,SEL->EL_COBRAD )
						AADD(aCpoSEX,SEL->EL_SERIE )
						AADD(aCpoSEX,SEL->EL_RECIBO )
						AADD(aCpoSEX,SEL->EL_DTDIGIT )
						AADD(aCpoSEX,SEL->EL_CLIORIG)
						AADD(aCpoSEX,SEL->EL_LOJORIG )
						AADD(aCpoSEX,SEL->EL_VALOR  )
						AADD(aCpoSEX, SAQ->AQ_COMIS)
						AADD(aCpoSEX,Val(SEL->EL_MOEDA))
						AADD(aCpoSEX,(SEL->EL_VALOR ) *(SAQ->AQ_COMIS/100) )
						AADD(aCpoSEX,SEL->EL_TIPODOC )
						AADD(aCpoSEX,SEL->EL_NUMERO)
//AADD(aCpoSEX,SEL->EL_PARCELA)
						Fa016Calc(aCpoSEX)

						Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A840Marca() ³Autor ³  Paulo Augusto       ³Data³ 19.02.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inverte selecao na tela de clientes                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

					STATIC FUNCTION A840Marca()

						Local nJ:=1

						For nJ:=1 to Len(aLinSA1)
							aLinSA1[nJ,1] := aLinSA1[nJ,1] * -1
						Next nJ
						oLBCli:Refresh()

						Return
//--

					Static Function A840Load(aC, nRecs, cCond, lAchou, lRecno, aCpos, c_Alias)

						Local nLin    := 0
						Local nCol    := 0
						If &(cCond)
							nSel:= -1
							lAchou:=.T.
							AAdd(aC,Array(Len(aCpos)+nRecs))
							aEval(aCpos,{|x,y| aC[Len(aC)][y] := &(x)})
							If lRecno
								aC[Len(aC)][Len(aC[1])-1]:=(c_Alias)->R_E_C_N_O_
							Endif
							aC[Len(aC)][Len(aC[1])]:=.F.
							If c_Alias == "SE1TMP"
								nLin     := Len(aC)
								nCol     := Len(aC[nLin])-1
	
								If !Empty(aC[nLin][nCol])
									SE1->(MsGoto(aC[nLin][nCol]))
									aC[nLin][nPosDesc]  := FaDescFin("SE1",dDataRef,SE1->E1_SALDO,SE1->E1_MOEDA)
									aC[nLin][nPosJuros] := fa070Juros(Max(SE1->E1_MOEDA,1))
								EndIf
	    
		//Monta array de controle de alteracoes...
								AAdd(aLinSE1_Ori,{aC[nLin][1],aC[nLin][2],aC[nLin][3]})
							EndIf
						Endif

						Return Nil

//--

					Static Function ValAltArray(aArrayPanel,aArrayPanOri,aArrayAtu,aArrayOri,cCliOri)

						Local lRet := .F.
						Local nI   := 0
						Local nPosOri	:= 0
						Local nPosCod  :=	Ascan(aCposSA1,{|x| Alltrim(x)=="A1_COD"})
						Local nPosLoj	:=	Ascan(aCposSA1,{|x| Alltrim(x)=="A1_LOJA"})
//O Array esta vazio e ainda nao valorizado...
						If Len(aArrayPanel)==1 .And. Empty(aArrayPanel[1][2])
							lRet     := .T.
							cCliOri  := cCliente+cLoja
	//Monta de controle - Clientes...
							aArrayOri:= {}
							aEval(aLinSA1,{|x,y| AAdd(aArrayOri,{x[1],x[nPosCod],x[nPosLoj]})})
						EndIf
                                               
//Verifica se foi alterado o cliente e a loja...
						If !lRet .And. (cCliLoj_Ori <> cCliente+cLoja)
							lRet     := .T.
							cCliOri  := cCliente+cLoja
	//Monta de controle - Clientes...
							aArrayOri:= {}
							aEval(aLinSA1,{|x,y| AAdd(aArrayOri,{x[1],x[nPosCod],x[nPosLoj]})})
						EndIf

//Verifica se existiu alguma alteracao no array...
						If !lRet
							For nI := 1 To Len(aArrayOri)
								If (nPosOri	:=	AScan(aArrayAtu, {|x| x[nPosCod]+x[nPosLoj]==aArrayOri[nI][2]+aArrayOri[nI][3]}))==0 .Or.;
										aArrayAtu[nPosOri][01] != aArrayOri[nI][01]
									lRet := .T.
			//Monta de controle - Clientes...
									aArrayOri   := {}
									aEval(aLinSA1,{|x,y| AAdd(aArrayOri,{x[1],x[nPosCod],x[nPosLoj]})})
									aArrayPanOri:= {}
									Exit
								Endif
							Next nI
						EndIf

						Return(lRet)
///////////////////////////////////////////////////////
//                                                   //
//    |  |       ---------------------------------   //
//   -    -      DAQUI PARA BAIXO ESTARAO            //
//   \    /      OS FONTES DO CONFIGURADOR           //
//    \  /       DOS CAMPOS DO BROWSE PARA RECIBOS   //
//     \/                                            //
//                                                   //
///////////////////////////////////////////////////////

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A840Prof()  ³Autor ³Cristiano Denardi     ³Data³ 19.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna Array contendo lista de campos gravados no Profile ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					static FUNCTION A840Prof(cAlias)

///////
// Var:
						Local aCposProfile 	:= {}
						Local nTamLin		:= 10
						Local cMemoPro		:= ""
						Local nTamMemo		:= 0
						Local nA			:= 0
						Local cAliasBM		:= ""


						cMemoPro := RetProfDef(cUserName,cFunName,cProfChave,cAlias)
						nTamMemo := MLCount(cMemoPro,nTamLin)


						For nA := 1 to nTamMemo
							Aadd( aCposProfile, Alltrim(MemoLine(cMemoPro,nTamLin,nA)) )
						Next nA
                        

///////////////////////////////////////////////////
// Rastreia aCpos para retirar campos do tipo MEMO
// Necessario ser desta forma, devido ao ponto de
//   entrada do usuario, que pode criar a aCols com
//   campo tipo MEMO
						cAliasBM := Alias()
						DbSelectArea( "SX3" )
						DbSetOrder(2)
						For nA := 1 to Len(aCposProfile)
							DbSeek( Alltrim(aCposProfile[nA]) )
							If ( X3_TIPO = "M" )
								Adel( aCposProfile, nA )
								Asize( aCposProfile, Len(aCposProfile)-1 )
							Endif
						Next nA
						SX3->(DbSetOrder(1))
						DbSelectArea( cAliasBM )

						RETURN( aCposProfile )
          


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A840CFG()   ³Autor ³Cristiano Denardi     ³Data³ 19.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configurador da ordem das colunas de recibo no Profile     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					STATIC FUNCTION A840CFG()

///////
// Var:
						Local	oFolder, oGet1, oGet2
						Local aTitles 		:= {STR0018,STR0120} //"Cliente"###"Titulo"
						Local	aPages  		:= Aclone(aTitles)
						Local aTamFolder		:= {}
						Local	lConfirm		:= .F.
						Local aButtons		:= {}
						Local cAlAnt			:= Alias()
						Local lPanelFin := IsPanelFin()

						Private oDlg
						Private lCancel			:= .F.
						Private cFunName  		:= "FINA840"
						Private cProfChave		:= "FINA84001"
						Private cAliasSA1 		:= "SA1"
						Private cAliasSE1 		:= "SE1"
						Private cAlias			:= ""
						Private aCposCliente	:= {}
						Private aCposTMPCli		:= {}
						Private aCposTitulo		:= {}
						Private aCposTMPTit		:= {}
						Private aCols           := {}
						Private aHeader 		:= {}

////////////////
// Monta aHeader
						Aadd(aHeader,{""     ,"CHECKBOL","@BMP"    , 07, 00, , ,"C", ,"V", , , , "V", , , })
						Aadd(aHeader,{""     ,"CHECK"   ,"@BMP"    , 05, 00, , ,"C", ,"V", , , , "V", , , })
						Aadd(aHeader,{STR0137,"ORDEM"   ,"@E 9,999", 04, 00, , ,"N", ,"V", , , , "A", , , }) //"Ordem"
						Aadd(aHeader,{STR0138,"NOMCAMPO", ""       , 12, 00, , ,"C", ,"V", , , , "V", , , }) //"Nome Campo"
						Aadd(aHeader,{STR0139,"CAMPO"   , ""       , 10, 00, , ,"C", ,"V", , , , "V", , , }) //"Campo"


//////////////////////
// Campos Obrigatorios
						aCposTMPCli := { 	"A1_COD"    , "A1_LOJA"   , "A1_NOME"   , "A1_CGC"   , "A1_CONTATO",	;
							"A1_TEL"    , "A1_NATUREZ"                								;
							}
						aCposTMPTit := {	"E1_PREFIXO", "E1_NUM"	  , "E1_PARCELA","E1_TIPO"	 , "E1_EMISSAO", 	;
							"E1_MOEDA"	, "E1_VALOR"  , "E1_SALDO"	,"E1_DESCONT", "E1_JUROS"  , 	;
							"E1_MULTA" 	, "E1_VENCREA" 												;
							}


///////
// Tela
						DEFINE MSDIALOG oDlg TITLE STR0121 FROM 0,0 TO 285,620 OF oMainWnd PIXEL //"Configurador de ordem e campos para browse de Recibos"
	
						aTamFolder := {014,002,oDlg:nHeight-5,129}
						oFolder    := TFolder():New(aTamFolder[1],aTamFolder[2],aTitles,aPages,oDlg,,,,.T.,.F.,aTamFolder[3],aTamFolder[4])
						oFolder:bSetOption :={|nAt| nGot:=nAt,A840CFGfol(@oFolder,nGot,@oGet1,@oGet2) }
	
	
	////////////////////////////////////////////////////////////
	// Alimenta pastas com os campos conforme Profile do Usuario
						A840CFGCo(cAliasSA1,cAliasSE1)


	/////////////
	// Monta Tela              
						nGetd := GD_UPDATE

						aCols :=  Aclone(aCposCliente)
						oGet1 := MsNewGetDados():New(0, 0, oFolder:aDialogs[1]:nClientHeight/2, oFolder:aDialogs[1]:nClientWidth/2,nGetd,,,,,,9999,,,,oFolder:aDialogs[1],aHeader,aCols)
						oGet1:oBrowse:bEditCol   := {|| A840CFGOrd(oGet1:oBrowse:nAt,@oGet1,.T.) }
						oGet1:oBrowse:blDblClick := {|| If( oGet1:oBrowse:nColPos == 3 , A840CFGOrd(oGet1:oBrowse:nAt,@oGet1,.F.), A840CFGbmp(oGet1:oBrowse:nAt,@oGet1) ) }

						aCols :=  Aclone(aCposTitulo)
						oGet2 := MsNewGetDados():New(0, 0, oFolder:aDialogs[2]:nClientHeight/2, oFolder:aDialogs[2]:nClientWidth/2,nGetd,,,,,,9999,,,,oFolder:aDialogs[2],aHeader,aCols)
						oGet2:oBrowse:bEditCol   := {|| A840CFGOrd(oGet2:oBrowse:nAt,@oGet2,.T.) }
						oGet2:oBrowse:blDblClick := {|| If( oGet2:oBrowse:nColPos == 3 , A840CFGOrd(oGet2:oBrowse:nAt,@oGet2,.F.), A840CFGbmp(oGet2:oBrowse:nAt,@oGet2) ) }

	
						Do Case
						Case oFolder:aDialogs[1]:lVisible // Folder 1 Ativo (Cliente)
							aCols :=  Aclone(aCposCliente)
						Case oFolder:aDialogs[2]:lVisible // Folder 2 Ativo (Titulo)
							aCols :=  Aclone(aCposTitulo)
						Endcase
	
	
	/////////
	// Botoes
						Aadd( aButtons, {"BMPINCLUIR",{ || A840CFGlst(@oFolder,@oGet1,@oGet2)		},STR0122,STR0146} ) //"Refaz lista de campos."###"Refaz"
						Aadd( aButtons, {"SDUPROP",{ || A840CFGleg()                        		},STR0129} ) //"Legenda"
						Aadd( aButtons, {"CHECKED"   ,{ || A840CFGsel(@oFolder,@oGet1,@oGet2,1)	},STR0135,STR0147} ) //"Todos campos selecionados"###"Td.Cp.Sel"
						Aadd( aButtons, {"UNCHECKED" ,{ || A840CFGsel(@oFolder,@oGet1,@oGet2,2)	},STR0136,STR0148} ) //"Todos campos nao selecionados"###"Td.Cp.N.Sel"

						If lPanelFin
							ACTIVATE MSDIALOG oDlg ON INIT ( FAMYBAR( oDlg,{|| lConfirm:=.T.,oDlg:End()} , {|| If(MsgYesNo(STR0123),oDlg:End(),) },aButtons )) CENTERED //"Deseja cancelar?"
						Else
							ACTIVATE MSDIALOG oDlg ON INIT ( EnchoiceBar( oDlg,{|| lConfirm:=.T.,oDlg:End()} , {|| If(MsgYesNo(STR0123),oDlg:End(),) }, , aButtons )) CENTERED //"Deseja cancelar?"
						Endif

///////////////////
// Grava em Profile
						If lConfirm
							A840CFGgrv(oGet1,oGet2)
						EndIf

						DbSelectArea( cAlAnt )
                                                                          
						RETURN Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A840CFGCo() ³Autor ³Cristiano Denardi     ³Data³ 19.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica Profile e monta lista de campos                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					static FUNCTION A840CFGCo(cAliasSA1,cAliasSE1)

///////
// Var:
						Local aCposTMP 	:= {} // Campos obrigatorios, usuario nao pode deselecionar


//////////
// CLIENTE
						aCposTMP := Aclone( aCposTMPCli )
						If FindProfDef( cUserName, cFunName, cProfChave, cAliasSA1 )
		////////////////////////////////////////////////////////
		// Resgata a lista do profile e mescla com campos de SX3
							A840CFGPR(cAliasSA1,aCposTMP,"aCposCliente")
						Else
		///////////////////////////////////////////////////
		// Cria Array com Lista nova de campos para Cliente
							A840CFGNR(cAliasSA1,aCposTMP,"aCposCliente")
						Endif
// CLIENTE
//////////


/////////
// TITULO
						aCposTMP := Aclone( aCposTMPTit )
						If FindProfDef( cUserName, cFunName, cProfChave, cAliasSE1 )
		////////////////////////////////////////////////////////
		// Resgata a lista do profile e mescla com campos de SX3
							A840CFGPR(cAliasSE1,aCposTMP,"aCposTitulo")
						Else
		//////////////////////////////////////////////////
		// Cria Array com Lista nova de campos para Titulo
							A840CFGNR(cAliasSE1,aCposTMP,"aCposTitulo")
						Endif
// TITULO
/////////

						RETURN Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A840CFGPR() ³Autor ³Cristiano Denardi     ³Data³ 19.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Resgata a lista do profile e mescla com campos de SX3      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					static FUNCTION A840CFGPR(c_alias,aCposTMP,cNomeArray)

///////
// Var:
						Local aCposPro	:= {} // Campos que estao gravados no Profile
						Local nTamLin	:= 10
						Local cAliasAnt := Alias()
						Local nOrdem	:= 0
						Local lEnable	:= .F.
						Local cBMP      := ""
						Local cBMPBOL   := ""
						Local cMemoProf	:= ""
						Local nTamMemo	:= 0
						Local nA		:= 0


						cMemoProf := RetProfDef(cUserName,cFunName,cProfChave,c_alias)
						nTamMemo  := MLCount(cMemoProf,nTamLin)

////////////////
// Cria aCposPro
						For nA := 1 to nTamMemo
							Aadd( aCposPro, Alltrim(MemoLine(cMemoProf,nTamLin,nA)) )
						Next nA
         

////////////////////////////////
// Pega a Lista de Campos de SX3
						DbSelectArea("SX3")
						DbSetOrder(2) // X3_CAMPO
	
	////////////////////
	// Rastreia aCposPro
						For nA := 1 to nTamMemo
	
							nOrdem++
	
							DbSeek( Alltrim(aCposPro[nA]), .F. )
	
							lEnable := If( (AScan(aCposTMP,Alltrim(aCposPro[nA]))==0), .T., .F. )
			
							If lEnable
								cBMPBOL	:= "ENABLE"
								cBMP	:= "LBTIK"
							Else
								cBMPBOL	:= "DISABLE"
								cBMP	:= "LBTIK"
							Endif
		
							Aadd(&cNomeArray,{cBMPBOL,cBMP,nOrdem,RetTitle(X3_CAMPO),X3_CAMPO,.F.})
						Next nA
	
						cBMPBOL	:= "ENABLE"
						cBMP	:= "LBNO"
	
	///////////////////////////
	// Mescla com campos do SX3
						DbSetOrder(1) // X3_ARQUIVO + X3_ORDEM
						DbSeek(c_Alias,.F.)
						Do While !EOF() .And. X3_ARQUIVO == Alltrim(c_Alias)
							If ( x3uso(X3_USADO) ) .And. ( cNivel >= X3_NIVEL ) .And. ( AScan(aCposPro,Alltrim(X3_CAMPO))==0 )
								nOrdem++
								AAdd(&cNomeArray,{cBMPBOL,cBMP,nOrdem,RetTitle(X3_CAMPO),X3_CAMPO,.F.})
							Endif
							DbSkip()
						Enddo
// Pega a Lista de Campos de SX3
////////////////////////////////

 
						DbSelectArea(cAliasAnt)

						RETURN Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A840CFGNR() ³Autor ³Cristiano Denardi     ³Data³ 19.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria a lista nova de campos                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					static FUNCTION A840CFGNR(c_alias,aCposTMP,cNomeArray)

///////
// Var:
						Local cAliasAnt := Alias()
						Local nOrdem	:= 0
						Local lEnable	:= .F.
						Local cBMP      := ""
         

////////////////////////////////
// Pega a Lista de Campos de SX3
						DbSelectArea("SX3")
						DbSetOrder(1)
						DbSeek(c_Alias,.F.)
						Do While !EOF() .And. X3_ARQUIVO == Alltrim(c_Alias)
							If ( x3uso(X3_USADO) ) .And. ( cNivel >= X3_NIVEL )
	
								nOrdem++
		
								lEnable := If((AScan(aCposTMP,Alltrim(X3_CAMPO))==0),.T.,.F.)
		
								cBMP	:= "LBTIK"

								If lEnable
									cBMPBOL	:= "ENABLE"
								Else
									cBMPBOL	:= "DISABLE"
								Endif
		
								AAdd(&cNomeArray,{cBMPBOL,cBMP,nOrdem,RetTitle(X3_CAMPO),X3_CAMPO,.F.})
							Endif
							DbSkip()
						Enddo
 
						DbSelectArea(cAliasAnt)

						RETURN Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A840CFGlst() ³Autor ³Cristiano Denardi     ³Data³ 19.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Desconsidera a lista atual e restaura a config. inicial    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					static FUNCTION A840CFGlst(oFolder,oGet1,oGet2)

///////
// Var:
						Local aCposTMP		:= {}
						Local cNomeArray	:= ""
						Local c_Alias		:= ""
						Local cAliasAnt 	:= Alias()
						Local nOrdem		:= 0
						Local lEnable		:= .F.
						Local cBMP      	:= ""
						Local nA			:= 0
						Local aFolders		:= {}
						Local lRefaz		:= .F.


						If MsgYesNo(STR0124) //"Deseja refazer a lista de campos para esta pasta?"
							lRefaz := .T.
						Endif


						If lRefaz

	/////////
	// Pastas
							Aadd(aFolders, {"SA1","aCposCliente","aCposTMPCli"} )
							Aadd(aFolders, {"SE1","aCposTitulo" ,"aCposTMPTit"} )
	
							Do Case
							Case ( oFolder:aDialogs[1]:lVisible )
								aCposCliente 	:= {}
								nA 				:= 1
			
							Case ( oFolder:aDialogs[2]:lVisible )
								aCposTitulo := {}
								nA 			:= 2
							EndCase

	
							c_Alias		:= aFolders[nA][1]
							cNomeArray	:= aFolders[nA][2]
							aCposTMP 	:= Aclone( &(aFolders[nA][3]) )
		
	////////////////////////////////
	// Pega a Lista de Campos de SX3
							DbSelectArea("SX3")
							DbSetOrder(1)
							DbSeek(c_Alias,.F.)
							Do While !EOF() .And. X3_ARQUIVO == Alltrim(c_Alias)
								If ( x3uso(X3_USADO) ) .And. ( cNivel >= X3_NIVEL )
		
									nOrdem++
			
									lEnable := If((AScan(aCposTMP,Alltrim(X3_CAMPO))==0),.T.,.F.)
			
									If lEnable
										cBMPBOL	:= "ENABLE"
										cBMP	:= "LBTIK"
									Else
										cBMPBOL	:= "DISABLE"
										cBMP	:= "LBTIK"
									Endif
			
									AAdd(&cNomeArray,{cBMPBOL,cBMP,nOrdem,RetTitle(X3_CAMPO),X3_CAMPO,.F.})
								Endif
								DbSkip()
							Enddo

	 
							Do Case
							Case ( oFolder:aDialogs[1]:lVisible )
								oGet1:aCols := Aclone( aCposCliente )
								oGet1:oBrowse:Refresh()
								oGet1:ForceRefresh()
			
							Case ( oFolder:aDialogs[2]:lVisible )
								oGet2:aCols := Aclone( aCposTitulo )
								oGet2:oBrowse:Refresh()
								oGet2:ForceRefresh()
			
							EndCase
	
							oDlg:Refresh()
	
							DbSelectArea(cAliasAnt)

						Endif

						RETURN Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A840CFGbmp() ³Autor ³Cristiano Denardi     ³Data³ 19.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a troca do BMP de aCOls                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					static Function A840CFGbmp(nLin,oGet)


						If ( oGet:aCols[nLin][1] = "ENABLE" )
							If     ( oGet:aCols[nLin][2] = "LBTIK" )
								oGet:aCols[nLin][2] := "LBNO"
							ElseIf ( oGet:aCols[nLin][2] = "LBNO" )
								oGet:aCols[nLin][2] := "LBTIK"
							Endif
						Endif


						RETURN Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A840CFGsel() ³Autor ³Cristiano Denardi     ³Data³ 19.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Troca a selecao de campos para NAO SELECIONADOS            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					static Function A840CFGsel(oFolder,oGet1,oGet2,nOpcBMP)

///////
// Var:
						Local nFor 	:= 0
						Local nA	:= 0


						Do Case
						Case ( oFolder:aDialogs[1]:lVisible )
							nFor := Len(oGet1:aCols)
							For nA := 1 to nFor
								If ( oGet1:aCols[nA][1] = "ENABLE" )
									If     ( nOpcBMP = 1 )
										oGet1:aCols[nA][2] := "LBTIK"
									ElseIf ( nOpcBMP = 2 )
										oGet1:aCols[nA][2] := "LBNO"
									Endif
								Endif
							Next nA
		
						Case ( oFolder:aDialogs[2]:lVisible )
							nFor := Len(oGet2:aCols)
							For nA := 1 to nFor
								If ( oGet2:aCols[nA][1] == "ENABLE" )
									If     ( nOpcBMP = 1 )
										oGet2:aCols[nA][2] := "LBTIK"
									ElseIf ( nOpcBMP = 2 )
										oGet2:aCols[nA][2] := "LBNO"
									Endif
								Endif
							Next nA
						EndCase

						RETURN Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A840CFGOrd() ³Autor ³Cristiano Denardi     ³Data³ 19.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Organiza aCols qdo e trocado a ordem de um campo           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					static Function A840CFGOrd(nLin,oGet,lVld)

///////
// Var:
						Local nPosNovo 	:= 0
						Local nValNovo 	:= 0
						Local nValAnti 	:= 0
						Local nValMaior := Len(oGet:aCols)
						Local nFor		:= 0
						Local nA		:= 0
						Local nOrdem	:= 0


						If lVld
							nValNovo := M->ORDEM
							nValAnti := nLin
						Else
							nValAnti := oGet:aCols[nLin][3]
							oGet:EditCell()
							nValNovo := oGet:aCols[nLin][3]
						Endif


						If ( nValNovo <= nValMaior ) .And. ( nValNovo > 0 )

	////////////////////////////////////////
	// Somente processa se valor for trocado
							If ( nValAnti <> nValNovo )
	
								If lVld
									nPosNovo := nValNovo
								Else
									nPosNovo := Ascan( oGet:aCols, {|aVal| aVal[3] == nValNovo } )
								Endif
		
								If ( nLin < nPosNovo )
									nFor := nPosNovo
									nLin++
									For nA := nLin to nFor
										nOrdem := nA
										nOrdem--
										oGet:aCols[nA][3] := nOrdem
									Next nA
								Else
									nFor := ( (nLin-nPosNovo) + nPosNovo ) - 1
									For nA := nPosNovo to nFor
										nOrdem := nA
										nOrdem++
										oGet:aCols[nA][3] := nOrdem
									Next nA
								Endif
		
								oGet:aCols := Asort( oGet:aCols,,, { |x,y| x[3] < y[3] } )
		
							Endif

						Else
							oGet:aCols[nLin][3] := nValAnti
							If ( nValNovo <= 0 )
								Alert(STR0125) //"Valor nao pode ser menor ou igual a Zero"
							Else
								Alert(STR0126) //"Valor nao pode ser maior do que o numero maximo de campos"
							Endif
						Endif

						oGet:oBrowse:Refresh()
						oGet:ForceRefresh()
						oDlg:Refresh()


						RETURN Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A840CFGgrv() ³Autor ³Cristiano Denardi     ³Data³ 19.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava lista de campos no profile do usuario corrente	      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					static Function A840CFGgrv(oGet1,oGet2)

///////
// Var:
						Local cList := ""
						Local nA	:= 0


/////////////////////////////
// Atualiza Arrays auxiliares
						aCposCliente := Aclone(oGet1:aCols)
						aCposTitulo  := Aclone(oGet2:aCols)


////////////////
// Grava Cliente
						cList := ""
						For nA := 1 to Len(aCposCliente)
							If ( aCposCliente[nA][2] == "LBTIK" )
								cList := cList + Alltrim( aCposCliente[nA][5] ) + _PL_
							Endif
						Next nA
						If FindProfDef( cUserName, cFunName, cProfChave, cAliasSA1 )
							WriteProfDef( cUserName, cFunName, cProfChave, cAliasSA1, cUserName, cFunName, cProfChave, cAliasSA1, cList )
						Else
							WriteNewProf( cUserName, cFunName, cProfChave, cAliasSA1, cList )
						Endif


///////////////
// Grava Titulo
						cList := ""
						For nA := 1 to Len(aCposTitulo)
							If ( aCposTitulo[nA][2] == "LBTIK" )
								cList := cList + Alltrim( aCposTitulo[nA][5] ) + _PL_
							Endif
						Next nA
						If FindProfDef( cUserName, cFunName, cProfChave, cAliasSE1 )
							WriteProfDef( cUserName, cFunName, cProfChave, cAliasSE1, cUserName, cFunName, cProfChave, cAliasSE1, cList )
						Else
							WriteNewProf( cUserName, cFunName, cProfChave, cAliasSE1, cList )
						Endif

						MsgInfo(STR0127) //"As alteracoes gravadas, so serao efetivadas na proxima abertura da rotina de Recibos!"


						RETURN Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A840CFGfol() ³Autor ³Cristiano Denardi     ³Data³ 19.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Trata a troca de folder, fazendo a troca do valor de aCols ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					static Function A840CFGfol(oFolder,nGot,oGet1,oGet2)
/////////////////////////////////////////////////////////////////
//                                                             //
//   nGot							-> Pasta que foi clicada   //
//   oFolder:aDialogs[n]:lVisible 	-> Ultima pasta ativa      //
//                                                             //
/////////////////////////////////////////////////////////////////


/////////////////////////////////////////////
// Guarda valor de Arrays de auxilio do aCols
						Do Case
						Case ( oFolder:aDialogs[1]:lVisible )
							aCposCliente := Aclone(oGet1:aCols)
		
						Case ( oFolder:aDialogs[2]:lVisible )
							aCposTitulo := Aclone(oGet2:aCols)
						EndCase


///////////////
// Ajusta aCols
						Do Case
						Case ( nGot = 1 )
							oGet1:aCols := Aclone(aCposCliente)
						Case ( nGot = 2 )
							oGet2:aCols := Aclone(aCposTitulo)
						EndCase

						Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A840CFGleg() ³Autor ³Cristiano Denardi     ³Data³ 19.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Legenda                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					static Function A840CFGleg()

						BrwLegenda(STR0129, STR0130,{	{"DISABLE", STR0131} ,; //"Legenda"###"Status"###" Campo obrigatorio"
						{"ENABLE" , STR0132} ,; //" Campo opcional"
						{""		  , " ------------------------ "} ,;
							{"LBTIK"  , STR0133} ,; //" Selecionado"
						{"LBNO"	  , STR0134}  ; //" Nao selecionado"
						} )

						RETURN Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ F840Get      ³Autor ³Julio Ceasr           ³Data³ 08.07.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria um get com os parametros informados.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function F840Get(aInfGet,uVarRet,oVarRet)

// Reinicializa a variavel.
						If aInfGet[9] <> Nil
							uVarRet := aInfGet[9]
						EndIf
          
						@ aInfGet[1],aInfGet[2] MSGET oVarRet Var uVarRet SIZE aInfGet[3],aInfGet[4] OF &(aInfGet[5]) PIXEL Valid &(aInfGet[6]) When &(aInfGet[7]) Picture aInfGet[8] HasButton

						Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Fa840Ret()  ³Autor ³Sabrina Passini Soares³Data³ 17.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que verifica se ha retencoes recebidas e chama a    ³±±
±±³          ³ montagem do panel correspondente para rateio dos valores   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function Fa840Ret()
						Local lRet   	:= .T.
						Local nI, nX	:= 1
						Local nPos	 	:= 0
						Local nNumRet	:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ StrTokArr: Esta funcao pega uma string com separadores e faz virar um array ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Local aDesc := IiF (cPaisLoc $ "ARG|COS",StrTokArr(FA840TpTit(),";"), StrTokArr(oGetsel:aInfo[AScan(aCposSEL,"EL_TIPODOC")][2], ';'))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega array com os titulos (NF) selecionados para distribuir as retencoes ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

						Local nPosPref  := Ascan( aCposSE1, "E1_PREFIXO")
						Local nPosNum   := Ascan( aCposSE1, "E1_NUM")
						Local nPosParc  := Ascan( aCposSE1, "E1_PARCELA")
						Local nPosTipo  := Ascan( aCposSE1, "E1_TIPO")
						Local lRatImp	:= GetMv("MV_RATIMP",.F.,"0")=="0"
						Local aCabRet   := {}
						Local aRetTmp   := {}

						Local nPosTrans := AScan(aHeader,{|x|Alltrim(x[2])=="EL_TRANSIT"})
						Local lExRateio	:= .T.
 
						Private aLinTit := {}
						aLinRet :={}

						Posicione("SX3",2,"E1_PREFIXO","X3_TITULO")
						Aadd( aCabRet, { SX3->(X3Titulo()), SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL} )
						Posicione("SX3",2,"E1_NUM","X3_TITULO")
						Aadd( aCabRet, { SX3->(X3Titulo()), SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL} )
						Posicione("SX3",2,"E1_PARCELA","X3_TITULO")
						Aadd( aCabRet, { SX3->(X3Titulo()), SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL} )
						Posicione("SX3",2,"E1_TIPO","X3_TITULO")
						Aadd( aCabRet, { SX3->(X3Titulo()), SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL} )
						Posicione("SX3",2,"E1_VALOR","X3_TITULO")
						Aadd( aCabRet, { SX3->(X3Titulo()), SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL} )

						For nX:=1 To Len( aLinSE1 )
							If aLinSE1[nX][1]== 1 // Titulo selecionado
								If cPaisLoc $ "ARG|COS" .Or. (!Alltrim(aLinSE1[nX][nPosTipo]) $ MV_CRNEG .Or. Alltrim(aLinSE1[nX][nPosTipo])=="CC")
									Aadd( aLinTit, { aLinSE1[nX][nPosPref], aLinSE1[nX][nPosNum], aLinSE1[nX][nPosParc], ;
										aLinSE1[nX][nPosTipo], 0, "", "" } )
								EndIf
							EndIf
						Next
                              
						For nI:=1 To Len(aCols)
							lExRateio := .T.
							If nPosTrans > 0
								If aCols[nI][nPosTrans] != "2"
									lExRateio := .F.
								EndIf
							EndIf

							If lExRateio .and. ( (cPaisLoc $ "ARG|COS" .And. aCols[nI][AScan(aCposSEL,"EL_TIPODOC")] $ 'RB|RS|RL|RI|RG' /*.Or. (lRatImp.And.aCols[nI][AScan(aCposSEL,"EL_TIPODOC")] == 'RI' )*/) ;
									.Or. (cPaisLoc == "PER" .And. ( aCols[nI][AScan(aCposSEL,"EL_TIPODOC")] $ 'RI' )) )
								If Len(aLinTit) > 0 .Or. (cPaisLoc $ "ARG|COS" .And.aCols[nI][AScan(aCposSEL,"EL_TIPODOC")] $ "RB|RI|RS|RG" )
									nNumRet++
									If Len( aLinRet ) >= nNumRet
										aRetTmp := aClone(aLinRet[nNumRet])
									Else
										aRetTmp := aClone(aLinTit)
										For nX := 1 to Len( aLinTit)
											aRetTmp[nX][6] := aCols[nI][AScan(aCposSEL,"EL_NUMERO")]  //numero da retencao (nrocert)
											aRetTmp[nX][7] := aCols[nI][AScan(aCposSEL,"EL_TIPODOC")]  //tipo da retencao
											If Len(aLinTit) == 1 .And. (cPaisLoc == "PER" .Or. (cPaisLoc $ "ARG|COS" .And. aCols[nI][AScan(aCposSEL,"EL_TIPODOC")] $ 'RS|RL' ))
												aRetTmp[nX][5]:= aCols[nI][AScan(aCposSEL,"EL_VALOR")]
											EndIf
										Next nX
									EndIf
									If cPaisLoc $ "ARG|COS"
										nPos := Ascan( aDesc, AllTrim(aCols[nI][AScan(aCposSEL,"EL_TIPO")])+'=' )
									Else
										nPos := Ascan( aDesc, AllTrim(aCols[nI][AScan(aCposSEL,"EL_TIPODOC")])+'=' )
									EndIf
									If Len(aLinTit)> 1  .Or. (cPaisLoc $ "ARG|COS" .And. ((aCols[nI][AScan(aCposSEL,"EL_TIPODOC")] $ "RB|RI|RS|RG") ))
				//Exibe a tela de rateio caso o parametro MV_RATIMP estiver configurado como "0"
										If cPaisLoc $ "ARG|COS"
											If (aCols[nI][AScan(aCposSEL,"EL_TIPODOC")] $ "RS|RL|RB|RI|RG")  //.Or. (lRatImp .And. (aCols[nI][AScan(aCposSEL,"EL_TIPODOC")] $ "RI"))
												lRet := MostraRets( Subs( aDesc[nPos], At('=', aDesc[nPos])+1 ), aCols[nI][AScan(aCposSEL,"EL_VALOR")], aCols[nI][AScan(aCposSEL,"EL_NUMERO")], aCabRet, @aRetTmp,aCols[nI][AScan(aCposSEL,"EL_TIPODOC")] ,lRatImp)
											Else
												lRet := .T.
											Endif
										Elseif cPaisLoc == "PER"
											If (aCols[nI][AScan(aCposSEL,"EL_TIPODOC")] $ "RI")
												lRet := MostraRets( Subs( aDesc[nPos], At('=', aDesc[nPos])+1 ), aCols[nI][AScan(aCposSEL,"EL_VALOR")], aCols[nI][AScan(aCposSEL,"EL_NUMERO")], aCabRet, @aRetTmp,aCols[nI][AScan(aCposSEL,"EL_TIPODOC")] )
											Else
												lRet := .T.
											Endif
				
										Endif
									Else
										lRet := .T.
									Endif
		 	
									If Len( aLinRet ) >= nNumRet
										aLinRet[nNumRet] := AClone(aRetTmp)
									Else
										Aadd( aLinRet, ACLone(aRetTmp)  )
									EndIf
    		
									If ( ! lRet )
										Exit
									EndIf
								Else
									If !lRotAuto
										Aviso(STR0149,STR0150,{STR0151}) // exibe mensagem que ha retencoes, porem nao foi selecionado nenhum item
									Else
										cTxtRotAut += STR0149 + " " + STR0150 + " " + STR0151  +" "+ CRLF
										lMsErroAuto := .T.
									EndIf
									lRet := .F.
									Exit
								EndIf
							EndIf
						Next
						Return lRet

  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DblClickBrow  ºAutor  ³Microsiga       º Data ³  03/24/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function DblClickBrow(oBrw, aIt, nRow, nCol, cPict)
						If ( oBrw:ColPos() == 5 )
							lEditCell(aIt, oBrw, cPict, nCol)
						EndIf
						Return

					Static Function A87VldRet( aItems, nRetVal,nTipo,oGetd,aCabRet,nMoeda,cTipo)
						Local lRet 		:= .T.
						Local nI   		:= 1
						Local nTotal	:= 0
						Local nPosRet	:= 0
						Local nPosCFO	:= 0
						Local nPosEst	:= 0
						Local nPosAlq	:= 0
						Local nPosBas	:= 0
						Local nPosTipo	:= 0
						Local nPosGan	:= 0

						Default aCabRet	:= {}
						Default nMoeda	:= 1
						Default cTipo	:= ""

						If nTipo == 1 .And. !lRotAuto
							For nI := 1 To Len(aItems)
								nTotal := nTotal + aItems[nI][5]
							Next
						Else
							If lRotAuto
								nPosRet	:=	Ascan(aCabRet,"FE_RETENC")
								nPosTipo:=	Ascan(aCabRet,"E1_TIPO")
								nPosCFO	:=	Ascan(aCabRet,"FE_CFO")
								nPosEst	:=	Ascan(aCabRet,"FE_EST")
								nPosAlq	:=	Ascan(aCabRet,"FE_ALIQ")
								nPosBas	:=	Ascan(aCabRet,"FE_VALBASE")
								nPosGan :=	Ascan(aCabRet,"A2_AGREGAN")
							Else
								nPosRet	:=	GdFieldPos("FE_RETENC",oGetd:aHeader)
								nPosTipo:=	GdFieldPos("E1_TIPO",oGetd:aHeader)
								nPosCFO	:=	GdFieldPos("FE_CFO",oGetd:aHeader)
								nPosEst	:=	GdFieldPos("FE_EST",oGetd:aHeader)
								nPosAlq	:=	GdFieldPos("FE_ALIQ",oGetd:aHeader)
								nPosBas	:=	GdFieldPos("FE_VALBASE",oGetd:aHeader)
								nPosGan :=	GdFieldPos("A2_AGREGAN",oGetd:aHeader)
							Endif
							For nI:= 1 To If(lRotAuto,Len(aItems),Len(oGetd:aCols))
								If lRotAuto
									nTotal := nTotal + aItems[nI,nPosRet] * If(nPosTipo>0 .And. aItems[nI,nPosTipo]$MV_CRNEG+"|"+MVRECANT,-1,1)
									If aItems[nI,nPosRet] <> 0 .And. (Empty(aItems[nI,nPosCFO]) .Or. Empty(aItems[nI,nPosEST]).Or. empty(aItems[nI,nPosBas]).Or.empty(aItems[nI,nPosAlq]))
										Help("",1,"OBRIGAT")
										lRet	:=	.F.
										Exit
									Endif
			//Validação do campo de conceito de Ganancias
									If cTipo == "RG"
										If nPosGan > 0 .And. Empty(aItems[nI,nPosGan])
											Help("",1,"OBRIGAT")
											lRet	:=	.F.
											Exit
										EndIf
									Endif
								Else
									If !oGetd:aCols[nI,Len(oGetd:aCols[nI])]
										nTotal := nTotal + oGetd:aCols[nI,nPosRet] * IIf(nPosTipo>0 .And. oGetd:aCols[nI,nPosTipo]$MV_CRNEG+"|"+MVRECANT,-1,1)
										If oGetd:aCols[nI,nPosRet] <> 0 .And. ;
												(Empty(oGetd:aCols[nI,nPosCFO]) .Or. Empty(oGetd:aCols[nI,nPosEST]).Or. empty(oGetd:aCols[nI,nPosBas]).Or.empty(oGetd:aCols[nI,nPosAlq]))
											Help("",1,"OBRIGAT")
											lRet	:=	.F.
											Exit
										Endif
			
				//Validação do campo de conceito de Ganancias
										If nPosGan > 0 .And. Empty(oGetd:aCols[nI,nPosGan])
											Help("",1,"OBRIGAT")
											lRet	:=	.F.
											Exit
										EndIf
									Endif
								Endif
							Next
						Endif
	     
						If lRet
							If lRotAuto
								If ( nTotal > nRetVal )
									cTxtRotAut += cTipo + " - " + STR0152 +" "+ CRLF
									lRet	:=	.F.
								ElseIf ( nTotal < nRetVal )
									cTxtRotAut += cTipo + " - " + STR0153 +" "+ CRLF
									lRet	:=	.F.
								EndIf
							Else
								If ( Round(nTotal,MsDecimais(oCBMOed:nAt)) > nRetVal )
									Aviso(STR0149,STR0152,{STR0151}) //'O valor digitado e maior que o valor da retencao'
									lRet	:=	.F.
								ElseIf ( Round(nTotal,MsDecimais(oCBMOed:nAt)) < nRetVal )
									Aviso(STR0149,STR0153,{STR0151})//'O valor digitado e menor que o valor da retencao'
									lRet	:=	.F.
								EndIf
							Endif
						Endif
						Return lRet


						/*/
						±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
						±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
						±±³Fun‡…o	 ³Fa840GrvIVA() ³ Autor ³ Paulo Augusto         ³ Data ³ 20/12/06 ³±±
						±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
						±±³Descri‡…o ³ Gravacao dos campos do Iva para o Mexico                       ³±±
						±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
						±±³Sintaxe	 ³ Fa840GrvIVA()              								      ³±±
						±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
						±±³ Uso		 ³ FINA87a													      ³±±
						±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
						±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
						ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
						/*/


					Static Function Fa840GrvIVA()

						Local aArea      := GetArea()
						LOCAL aAreaSE1   := SE1->( GetArea() )
						LOCAL _ValorBx1  := 0
						Local _ValorBx2  := 0
						Local _ValorBx3  := 0
						Local _ValorBx4  := 0
						Local _ValorBx5  := 0
						Local _ValorBx6  := 0
						Local _PerBx     := 0
						Local _PerDesc   := 0
						Local _ValorDc1  := 0
						Local _ValorDc2  := 0
						Local _ValorDc3  := 0
						Local _ValorDc4  := 0
						Local _ValorDc5  := 0
						Local _ValorDc6  := 0
//Local _nValPor1 := 0     
						LOCAL _BaseBx1  := 0
						Local _BaseBx2  := 0
						Local _BaseBx3  := 0
						Local _BaseBx4  := 0
						Local _BaseBx5  := 0
						Local _BaseBx6  := 0
						LOCAL _AliqBx1  := 0
						Local _AliqBx2  := 0
						Local _AliqBx3  := 0
						Local _AliqBx4  := 0
						Local _AliqBx5  := 0
						Local _AliqBx6  := 0

						Local aGrvSE   := {} //campos das tabelas SEL e SE5 a serem gravados.
						Local nX

						dbSelectArea("SE1")
						dbSetOrder(1)
						dbSeek(xFilial("SE1")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
						If Found()
	
	// Calcula el percentual de valor baixado
							_PerBx   := (SEL->EL_VALOR   * 100) / SE1->E1_VALOR
	
	// Calcula el percentual de valor de descuento 
							_PerDesc := (SEL->EL_DESCONT * 100) / SE1->E1_VALOR
	
							If SE1->E1_VALIMP1 > 0
								_ValorBx1 := SE1->E1_VALIMP1 * (_PerBx / 100)
								_AliqBx1 := SE1->E1_ALQIMP1
								_BaseBx1 := SE1->E1_BASIMP1 * (_PerBx / 100)
		
							EndIf
							If SE1->E1_VALIMP2 > 0
								_ValorBx2 := SE1->E1_VALIMP2 * (_PerBx / 100)
								_AliqBx2 := SE1->E1_ALQIMP2
								_BaseBx2 := SE1->E1_BASIMP2 * (_PerBx / 100)
							EndIf
							If SE1->E1_VALIMP3 > 0
								_ValorBx3 := SE1->E1_VALIMP3 * (_PerBx / 100)
								_AliqBx3 := SE1->E1_ALQIMP3
								_BaseBx3 := SE1->E1_BASIMP3 * (_PerBx / 100)
							EndIf
							If SE1->E1_VALIMP4 > 0
								_ValorBx4 := SE1->E1_VALIMP4 * (_PerBx / 100)
								_AliqBx4 := SE1->E1_ALQIMP4
								_BaseBx4 := SE1->E1_BASIMP4 * (_PerBx / 100)
							EndIf
							If SE1->E1_VALIMP5 > 0
								_ValorBx5 := SE1->E1_VALIMP5 * (_PerBx / 100)
								_AliqBx5 := SE1->E1_ALQIMP5
								_BaseBx5 := SE1->E1_BASIMP5 * (_PerBx / 100)
							EndIf
							If SE1->E1_VALIMP6 > 0
								_ValorBx6 := SE1->E1_VALIMP6 * (_PerBx / 100)
								_AliqBx6 := SE1->E1_ALQIMP6
								_BaseBx6 := SE1->E1_BASIMP6 * (_PerBx / 100)
							EndIf
							If SEL->EL_DESCONT > 0 .and. SE1->E1_VALIMP1 > 0
								_ValorDc1  := SE1->E1_VALIMP1 * (_PerDesc / 100)
							EndIf
							If SEL->EL_DESCONT > 0 .and. SE1->E1_VALIMP2 > 0
								_ValorDc2  := SE1->E1_VALIMP2 * (_PerDesc / 100)
							EndIf
							If SEL->EL_DESCONT > 0 .and. SE1->E1_VALIMP3 > 0
								_ValorDc3  := SE1->E1_VALIMP3 * (_PerDesc / 100)
							EndIf
							If SEL->EL_DESCONT > 0 .and. SE1->E1_VALIMP4 > 0
								_ValorDc4  := SE1->E1_VALIMP4 * (_PerDesc / 100)
							EndIf
							If SEL->EL_DESCONT > 0 .and. SE1->E1_VALIMP5 > 0
								_ValorDc5  := SE1->E1_VALIMP5 * (_PerDesc / 100)
							EndIf
							If SEL->EL_DESCONT > 0 .and. SE1->E1_VALIMP6 > 0
								_ValorDc6  := SE1->E1_VALIMP6 * (_PerDesc / 100)
							EndIf
	
	//Campos da tabela SEL
	//             Tab.      Campo        Valor
							Aadd(aGrvSE, {"SEL", "EL_VALIMP1", _ValorBx1})
							Aadd(aGrvSE, {"SEL", "EL_VALIMP2", _ValorBx2})
							Aadd(aGrvSE, {"SEL", "EL_VALIMP3", _ValorBx3})
							Aadd(aGrvSE, {"SEL", "EL_VALIMP4", _ValorBx4})
							Aadd(aGrvSE, {"SEL", "EL_VALIMP5", _ValorBx5})
							Aadd(aGrvSE, {"SEL", "EL_VALIMP6", _ValorBx6})
							Aadd(aGrvSE, {"SEL", "EL_BASIMP1", _BaseBx1})
							Aadd(aGrvSE, {"SEL", "EL_BASIMP2", _BaseBx2})
							Aadd(aGrvSE, {"SEL", "EL_BASIMP3", _BaseBx3})
							Aadd(aGrvSE, {"SEL", "EL_BASIMP4", _BaseBx4})
							Aadd(aGrvSE, {"SEL", "EL_BASIMP5", _BaseBx5})
							Aadd(aGrvSE, {"SEL", "EL_BASIMP6", _BaseBx6})
							Aadd(aGrvSE, {"SEL", "EL_ALQIMP1", _AliqBx1})
							Aadd(aGrvSE, {"SEL", "EL_ALQIMP2", _AliqBx2})
							Aadd(aGrvSE, {"SEL", "EL_ALQIMP3", _AliqBx3})
							Aadd(aGrvSE, {"SEL", "EL_ALQIMP4", _AliqBx4})
							Aadd(aGrvSE, {"SEL", "EL_ALQIMP5", _AliqBx5})
							Aadd(aGrvSE, {"SEL", "EL_ALQIMP6", _AliqBx6})
							Aadd(aGrvSE, {"SEL", "EL_IMPDES1", _ValorDc1})
							Aadd(aGrvSE, {"SEL", "EL_IMPDES2", _ValorDc2})
							Aadd(aGrvSE, {"SEL", "EL_IMPDES3", _ValorDc3})
							Aadd(aGrvSE, {"SEL", "EL_IMPDES4", _ValorDc4})
							Aadd(aGrvSE, {"SEL", "EL_IMPDES5", _ValorDc5})
							Aadd(aGrvSE, {"SEL", "EL_IMPDES6", _ValorDc6})
	
	//Campos da tabela SE5 
	//             Tab.      Campo        Valor
							Aadd(aGrvSE, {"SE5", "E5_VALIMP1", _ValorBx1})
							Aadd(aGrvSE, {"SE5", "E5_VALIMP2", _ValorBx2})
							Aadd(aGrvSE, {"SE5", "E5_VALIMP3", _ValorBx3})
							Aadd(aGrvSE, {"SE5", "E5_VALIMP4", _ValorBx4})
							Aadd(aGrvSE, {"SE5", "E5_VALIMP5", _ValorBx5})
							Aadd(aGrvSE, {"SE5", "E5_VALIMP6", _ValorBx6})
							Aadd(aGrvSE, {"SE5", "E5_BASIMP1", _BaseBx1})
							Aadd(aGrvSE, {"SE5", "E5_BASIMP2", _BaseBx2})
							Aadd(aGrvSE, {"SE5", "E5_BASIMP3", _BaseBx3})
							Aadd(aGrvSE, {"SE5", "E5_BASIMP4", _BaseBx4})
							Aadd(aGrvSE, {"SE5", "E5_BASIMP5", _BaseBx5})
							Aadd(aGrvSE, {"SE5", "E5_BASIMP6", _BaseBx6})
							Aadd(aGrvSE, {"SE5", "E5_ALQIMP1", _AliqBx1})
							Aadd(aGrvSE, {"SE5", "E5_ALQIMP2", _AliqBx2})
							Aadd(aGrvSE, {"SE5", "E5_ALQIMP3", _AliqBx3})
							Aadd(aGrvSE, {"SE5", "E5_ALQIMP4", _AliqBx4})
							Aadd(aGrvSE, {"SE5", "E5_ALQIMP5", _AliqBx5})
							Aadd(aGrvSE, {"SE5", "E5_ALQIMP6", _AliqBx6})
	
	//verifica se o campo existe e grava o valor na tabela
							For nX := 1 to Len(aGrvSE)
		//aGrvSE[nX,1] = Tabela
		//aGrvSE[nX,2] = Campo
		//aGrvSE[nX,3] = Valor a ser atribuido no campo
		
		//verifica se o campo existe.
								If (aGrvSE[nX,1])->(FieldPos(aGrvSE[nX,2]))> 0
									RecLock(aGrvSE[nX,1], .F.)
			//atribuição de valor no campo, caso o mesmo exista.
									(aGrvSE[nX,1])->&(aGrvSE[nX,2]) := aGrvSE[nX,3]
									MsUnlock()
								Endif
							Next nX

	
						EndIf

						RestArea( aAreaSE1)
						RestArea( aArea )

						RETURN ()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Fa840IGV()  ³Autor ³Ana Paula					 03.11.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que verifica se ha retencoes recebidas e chama a    ³±±
±±³          ³ montagem do panel correspondente para rateio dos valores   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function Fa840IGV(cCliente,cLoja,cNumFatAut)
						Local lRet   	:= .T.
						Local nI, nX	:= 1
						Local nPos	 	:= 0
						Local nNumRet	:= 0

//Local aDesc  := StrTokArr(oGetsel:aInfo[AScan(aCposSEL,"EL_TIPODOC")][2], ';')
						Local nPosPref  := Ascan( aCposSE1, "E1_PREFIXO")
						Local nPosNum   := Ascan( aCposSE1, "E1_NUM")
						Local nPosParc  := Ascan( aCposSE1, "E1_PARCELA")
						Local nPosTipo  := Ascan( aCposSE1, "E1_TIPO")
						Local nPosCli   := Ascan( aCposSE1, "E1_CLIENTE")
						Local nPosLoja  := Ascan( aCposSE1, "E1_LOJA")
						Local nPosValBx := Ascan( aCposSE1, "nBaixar")
						Local nPosValTi := Ascan( aCposSE1, "E1_VALOR")
						Local nPosMoeda := AScan(aCposSE1,"E1_MOEDA")
						Local nPosVal	:= AScan(aCposSEL,"EL_VALOR")
						Local lCalcPerc := .F.
						Local cAgente	:= GETMV("MV_AGENTE")
						Local aLinRet   := {}
						Local aRetTmp   := {}
						Local lPercRA	:= (GetNewPar("MV_PERRA","N") == "S")
						Private aLinTit := {}

						DEFAULT cNumFatAut := ""


						If Subs(cAgente,1,1) == "N"
							SA1->(DbSetOrder(1))
							If SA1->(MSSEEK(xFilial("SA1")+cCliente+cLoja)) .and. SA1->A1_AGENTE="2"
								lCalcPerc:=.T.
							EndIf
						EndIf


						For nX:=1 To Len( aLinSE1 )
							If aLinSE1[nX][1]== 1 // Titulo selecionado
								Aadd( aLinTit, { aLinSE1[nX][nPosPref], aLinSE1[nX][nPosNum], aLinSE1[nX][nPosCli], ;
									aLinSE1[nX][nPosTipo], aLinSE1[nX][nPosLoja], aLinSE1[nX][nPosValBx],aLinSE1[nX][nPosValTi],aLinSE1[nX][nPosMoeda] } )
				 
							EndIf
						Next

						If Len(aLinTit)< 1 .And. lCalcPerc  .And. lPercRA .And. aCols[1][nPosVal]>0
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?ÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³ Montagem do PANEL de aliquotas para percepção³//
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							oAPerc:=TPanel():New(84,00,,oDlgRecibo,,,,,,127,117,.F.,.T.)
	
							@ 003,001 GROUP oGrp6 TO 103, 123 LABEL OemToAnsi(STR0157) OF oAPerc  PIXEL  //"Percepção IGV"
	
	
							@ 015,005 SAY OemToAnsi(STR0155) SIZE 60,07	OF oAPerc PIXEL //"Aliquota"
							@ 015,065 MSGET oAliqPerc Var nAliqPerc	SIZE 55,09 	OF oAPerc PIXEL Valid Fa840CalcPer(@nAliqPerc,.T.) Picture "@R 99.99" HASBUTTON
	
							@ 030,005 SAY OemToAnsi(STR0156) SIZE 60,07	OF oAPerc PIXEL //"Valor Percepção"
							@ 030,065 MSGET oVarPer Var nValPerc SIZE 055,009 OF oAPerc READONLY PIXEL Picture PesqPict("SE1","E1_VALOR",18,nMoedDesc) HasButton
	
							@ 045,005 SAY OemToAnsi( STR0045 ) SIZE 55, 07 OF oAPerc PIXEL  //"Valores expressos em "
							oCBMoed1:= TComboBox():New(045,065,bSEL,aNomeMoed,055,020,oAPerc, ,{|| nMoedDesc:=oCBMoed1:nAt,Fa840CalcPer(nAliqPerc,.T.)} , , , ,.T.,,,,)
	
	
							oAPerc:NCLRPANE:= RGB(233,233,233) ///13165800
							DEFINE SBUTTON FROM 104,063  TYPE 1  ACTION (F840PerOk(@cNumFatAut)) OF oAPerc When .T.
							DEFINE SBUTTON FROM 104,093  TYPE 2  ACTION (oAPerc:Hide(),oPanBut:lReadOnly:=.F.,oPanel[nPainel]:lReadOnly:=.F.) OF oAPerc When .T.
	
	 
						Elseif lCalcPerc //Verifica percepção de titulos gerados por faturamento
							Fa840CalcPer(nAliqPerc,.F.)
						Endif
		   
						Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CkNatureza  ºAutor  ³Microsiga         º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function CkNatureza(cNatureza,lNatureza)

						If lFindITF .and. FinProcITF(,1,,,,,cNatureza)
							lNatureza:=.T.
						else
							lNatureza:=.F.
						Endif

						Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³lRetCkPG  ºAutor  ³Microsiga           º Data ³  03/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function lRetCkPG(n,cDebInm,cBanco,nPagar)
						Local lRetCx:=.T.
						If cPaisLoc="PER"
							If n==0
								If cBanco $ (Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1])+"/"+GetMv("MV_CARTEIR")) .or. IsCaixaLoja(cBanco)
									If nPagar=2 //.and. cDebInm="TF"
										lRetCx:=.F.
										MsgAlert(STR0162+cBanco+STR0163)
									Endif
								Endif
							Elseif n==3
								If cBanco $ (Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1])+"/"+GetMv("MV_CARTEIR"))  .or. IsCaixaLoja(cBanco)
									lRetCx:=.F.
								Endif
							Endif
						Endif
						Return(lRetCx)

						/*/
						ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
						±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
						±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
						±±³Fun‡…o    ³ GerNumCert³ Autor ³ marcos Kato          ³ Data ³30/07/2010³±±
						±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
						±±³Descri‡…o ³ Verifica o proximo numero do certificado do imposto        ³±±
						±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
						±±³ Retorno  ³ Retorna o numero de certificado e o Numero de Autorizacao  ³±±
						±±³          ³ aArray[1] -> Numero Certificado                            ³±±
						±±³          ³ aArray[2] -> Numero Autorizacao                            ³±±
						±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
						±±³ Uso      ³ Equador                                                    ³±±
						±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
						±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
						ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
						*/
					Static Function GerNumCert(cImp,lSoma)
						Local lCertOK	:=.F.
						Local cImpX5 	:=""
						Local aCertRet	:={}

						Default cImp:=""

						If cPaisLoc != "COS" .And. !Empty(cImp)
							aCertRet:={}
	//Pega o proximo Numero do Certificado de IR e verifica se a numeracao esta dentro do controle de folios tipo RIR		
							DbSelectArea("SX5")
							If dbSeek(xFilial("SX5")+"99"+cImp)
								cImpX5 := (X5Descri())
								cImpX5 := Alltrim(StrZero(VAL(cImpX5)+1,TamSx3("FE_NROCERT")[1]))
			
								DbSelectArea("SFP")
								SFP->(dbGoTop())
								SFP->(DbSetOrder(6))
								If DbSeek(xFilial("SFP")+cFilAnt+"6")
									Do While SFP->FP_FILIAL==xFilial("SFP") .And. SFP->FP_FILUSO==cFilAnt .And. Alltrim(SFP->FP_ESPECIE)=="6"
										If SFP->FP_NUMINI <= cImpX5 .and. SFP->FP_NUMFIM >= cImpX5
											If SFP->FP_ATIVO == "1"
												If dDataBase <= SFP->FP_DTAVAL
													aAdd(aCertRet,cImpX5)
													aAdd(aCertRet,SFP->FP_NUMAUT)
													lCertOk:=.T.
													Exit
												EndIf
											EndIf
										EndIf
										SFP->(dbSkip())
									End
								Endif
								If lCertOk
									If lSoma
										RecLock("SX5",.F.)
										Replace X5_DESCRI	WITH cImpX5
										Replace X5_DESCSPA	WITH cImpX5
										Replace X5_DESCENG	WITH cImpX5
										SX5->(MsUnLock())
									EndIf
								Endif
							Endif
						ElseIf cPaisLoc == "COS"
							aAdd(aCertRet,Space(TamSx3("FE_NROCERT")[1]))
							aAdd(aCertRet,Space(TamSx3("FP_NUMAUT")[1]))
						Endif
						Return aCertRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA840RetOk  ºAutor  ³Renan Guedes       º Data ³  03/28/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação ao confirmar a operação de recebimentos diversos. º±±
±±º          ³Faz a atualização dos quadros de retenções a partir das 	  º±±
±±º          ³alterações nos valores dos impostos retidos.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParâmetros³nPanAtu	= Número do painel em exibição                    º±±
±±º          ³nUltPan	= Número do último painel						  º±±
±±º          ³															  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function FA840RetOk(nPanAtu,nUltPan)

						Local lRet			:= .T.
						Local nPosVal1		:= 0
						Local nPosVal2		:= 0
						Local nPosTpDoc1	:= 0
						Local nPosTpDoc2	:= 0
						Local nPosPref1		:= 0
						Local nPosPref2		:= 0
						Local nPosNum1		:= 0
						Local nPosNum2		:= 0
						Local nPosPar1		:= 0
						Local nPosPar2		:= 0
						Local nPosEmis1		:= 0
						Local nPosEmis2		:= 0
						Local nPosVenc1		:= 0
						Local nPosVenc2		:= 0
						Local nX			:= 0
						Local nY			:= 0
						Local nTotBx		:= 0
						Local nTotRec		:= 0

	//Verifica se está no último painel
						If nPanAtu == nUltPan
		//Fecha os arquivos temporários e restaura os alias originais
							FA840aCtbA(2)
		//Valida a aCols inteira
							If !u_st840TudoOk()
								lRet := .F.
							ElseIf !Fa840BaixaOK()
								lRet := .F.
							EndIf
							If lRet
			//Posições dos campos no cabeçalho
								nPosVal1	:= ASCAN(aHeaderSEL,		{|aCpo| AllTrim(aCpo[2]) == "EL_VALOR"		})
								nPosTpDoc1	:= ASCAN(aHeaderSEL,		{|aCpo| AllTrim(aCpo[2]) == "EL_TIPODOC" 	})
								nPosPref1	:= ASCAN(aHeaderSEL,		{|aCpo| AllTrim(aCpo[2]) == "EL_PREFIXO" 	})
								nPosNum1	:= ASCAN(aHeaderSEL,		{|aCpo| AllTrim(aCpo[2]) == "EL_NUMERO"		})
								nPosPar1	:= ASCAN(aHeaderSEL,		{|aCpo| AllTrim(aCpo[2]) == "EL_PARCELA" 	})
								nPosEmis1	:= ASCAN(aHeaderSEL,		{|aCpo| AllTrim(aCpo[2]) == "EL_EMISSAO"	})
								nPosVenc1	:= ASCAN(aHeaderSEL,		{|aCpo| AllTrim(aCpo[2]) == "EL_DTVCTO" 	})
								If cPaisLoc $ 'URU|BOL|PTG|ANG|PER|ARG'
									nPosVal2	:= ASCAN(oRetTit:aHeader,	{|aCpo| AllTrim(aCpo[2])	== "EL_VALOR"	})
									nPosTpDoc2	:= ASCAN(oRetTit:aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_TIPODOC"	})
									nPosPref2	:= ASCAN(oRetTit:aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_PREFIXO"	})
									nPosNum2	:= ASCAN(oRetTit:aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_NUMERO" 	})
									nPosPar2	:= ASCAN(oRetTit:aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_PARCELA"	})
									nPosEmis2	:= ASCAN(oRetTit:aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_EMISSAO"	})
									nPosVenc2	:= ASCAN(oRetTit:aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_DTVCTO" 	})
				//Atualiza cada linha do quadro de retenções (Painel 1) a partir das alterações do painel 5
									For nX := 1 To Len(oRetTit:aCols)
										If !(oRetTit:aCols[nX,Len(oRetTit:aHeader)+1])
											For nY := 1 To Len(aColsSEL)
												If !(aColsSEL[nX,Len(aHeaderSEL)+1])								.And.;
														(oRetTit:aCols[nX,nPosTpDoc2]	== aColsSEL[nY][nPosTpDoc1])	.And.;
														(oRetTit:aCols[nX,nPosPref2]	== aColsSEL[nY][nPosPref1])		.And.;
														(oRetTit:aCols[nX,nPosNum2]		== aColsSEL[nY][nPosNum1])		.And.;
														(oRetTit:aCols[nX,nPosPar2]		== aColsSEL[nY][nPosPar1])		.And.;
														(oRetTit:aCols[nX,nPosEmis2]	== aColsSEL[nY][nPosEmis1])		.And.;
														(oRetTit:aCols[nX,nPosVenc2]	== aColsSEL[nY][nPosVenc1])
								//Atualiza linhas do quadro de retenções
													aColsSEL[nY][nPosVal1] := oRetTit:aCols[nX][nPosVal2]
												EndIf
											Next nY
										EndIf
									Next nX
								EndIf
			
			//Atualiza os arrays e objeto do quadro de retenções do painel 1
								aCols	:= ACLONE(aColsSEL)
								aHeader	:= ACLONE(aHeaderSEL)
								oGetSEL:ForceRefresh()
			
			//Atualiza taxas das moedas
								FaMoedas()
							EndIf
						EndIf

						Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA840AValPan  ºAutor  ³Renan Guedes     º Data ³  03/31/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida o refresh do painel 4 - Resumo                       º±±
±±º          ³Esta função forca a atualização do painel 4 quando o		  º±±
±±º          ³usuário está num painel posterior e volta para este.        º±±
±±º          ³															  º±±
±±º          ³Fecha e apaga os arquivos temporários da simulação da 	  º±±
±±º          ³contabilização, caso tenham sido criados					  º±±
±±º          ³															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParâmetros³nPan = Número do painel a ser exibido                       º±±
±±º          ³															  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function FA840AValPan(nPan,nLPan)

						Local aColsCtb	:= {}
						Local nX		:= 0

						If !cPaisLoc $ "COS"
							If (nPan == (nLPan - 1)) .Or. (nPan == 4)
		//Atualiza os arrays e objeto do quadro de retenções do painel 1
								aCols	:= ACLONE(aColsSEL)
								aHeader	:= ACLONE(aHeaderSEL)
								oGetSEL:ForceRefresh()
	
		//Refaz o browse da simulação da contabilização
								aColsCtb := Array(1,Len(oSimCtb:aHeader)+1)
								For nX := 1 To Len(oSimCtb:aHeader)
									aColsCtb[1,nX] := CriaVar(oSimCtb:aHeader[nX,2])
								Next nX
								aColsCtb[1,Len(oSimCtb:aHeader)+1] := .T.
								oSimCtb:SetArray(aColsCtb)
								oSimCtb:Refresh()
		
								dDtCtb := ""
								cLtCtb := ""
		
								oDtCtb:CtrlRefresh()
								oLtCtb:CtrlRefresh()
		
								nCtbDeb := 0
								nCtbCre := 0
	    
								oCtbDeb:CtrlRefresh()
								oCtbCre:CtrlRefresh()
		
								FA840aCtbA(2)
							EndIf
	
							If nPan == 4
								RefData(nPan)
							EndIf
						EndIf

						Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA840  ºAutor  ³Microsiga           º Data ³  03/31/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
					Static Function FA840aCtbA(nOpcX)

						Local aSimCtbSEL	:= {}
						Local aStru			:= {}
						Local cTabSEL		:= ""
						Local cTabSE1		:= ""
						Local cTabSEA		:= ""
						Local cTabSA1		:= ""
						Local cTabSFE		:= ""
						Local cTabCTK		:= ""
						Local cTabCT2		:= ""
						Local cTabSE5		:= ""
						Local cTabCV3		:= ""
						Local cIndSEL		:= ""
						Local cIndSE1		:= ""
						Local cIndSEA		:= ""
						Local cIndSA1		:= ""
						Local cIndSFE		:= ""
						Local cIndCTK		:= ""
						Local cIndCT2		:= ""
						Local cIndSE5		:= ""
						Local cIndCV3		:= ""
						Local cChave		:= ""
						Local cFil			:= ""
						Local aClonSE1		:= {}
						Local aClonSEL		:= {}
						Local aClonRet		:= {}
						Local aBxTotal		:= {}
						Local nValMinRa 	:= SuperGetMv("MV_VLMINRA")
						Local nX			:= 0
						Local nY			:= 0
						Local nI			:= 0
						Local nValMoed		:= 1
						Local cDriver		:= ""
						Local lCreate		:= .T.
						Local cErro			:= ""
						Local nPosSE1		:= 0
						Local nPosSA1		:= 0
//Posições dos campos nos cabeçalhos
						Local nPosVal1		:= 0
						Local nPosVal2		:= 0
						Local nPosVal3		:= 0
						Local nPosTpDoc1	:= 0
						Local nPosTpDoc2	:= 0
						Local nPosTpDoc3	:= 0
						Local nPosPref1		:= 0
						Local nPosPref2		:= 0
						Local nPosPref3		:= 0
						Local nPosNum1		:= 0
						Local nPosNum2		:= 0
						Local nPosNum3		:= 0
						Local nPosPar1		:= 0
						Local nPosPar2		:= 0
						Local nPosPar3		:= 0
						Local nPosEmis1		:= 0
						Local nPosEmis2		:= 0
						Local nPosEmis3		:= 0
						Local nPosVenc1		:= 0
						Local nPosVenc2		:= 0
						Local nPosVenc3		:= 0
						Local nPosMotBx3	:= 0
						Local nPosValBx3	:= 0
						Local nPosMoed3		:= 0
						Local nPosCred1		:= 0
//
						Local aCpoHdSEL		:= {}
						Local nPosDados		:= 0
						Local nDesc			:= 0
						Local nDescRat		:= 0
						Local nTot			:= 0
						Local nDias			:= 0
						Local dBase			:= ""
						Local aFeriados		:= {}
						Local lRatImp		:= GetMv("MV_RATIMP",.F.,"0") == "0"
						Local nVlrTit		:= 0
						Local lGerNCC		:= .T.
						Local aAreaSE1_		:= {}
						Local nHdlPrv		:= 0
						Local cKeyImp 		:= ""
						Local cAlias		:= ""
						Local aFlagCTB 		:= {}
						Local lUsaFlag		:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
						Local nTotalLanc	:= 0
						Local cArquivo		:= ""
						Local nLinha 		:= 1
						Local lLancPad70 	:= .F.
						Local lDigita		:= .F.
						Local cLoteCom		:= ""
						Local nPosAlias		:= 0
						Local aDiario		:= {}
						Local lCtbInUse		:= CtbinUse()
						Local lSimula		:= .T.
						Local aIndices		:= {}
						Local cChaveSEL		:= ""
						Local cChaveSE1		:= ""
						Local cChaveSEA		:= ""
						Local cPadrao		:= ""

						If !lCtbInUse
							Help(" ",1,"CTBINUSE",,STR0182,1,0)		//"A simulação da contabilização está disponível apenas para ambientes CTB."
							Return
						EndIf

						nTotalBx := IIf(Type("nTotalBx") == "U",0,nTotalBx)		//Valor total dos titulos selecionados para baixa
	
						If nOpcX == 1
	//Posições dos campos no cabeçalho
							nPosVal1	:= ASCAN(aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_VALOR"	})
							nPosVal3	:= ASCAN(aCposSE1,	{|aCpo| AllTrim(aCpo) 		== "E1_VALOR"	})
							nPosTpDoc1	:= ASCAN(aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_TIPODOC"	})
							nPosTipo   := ASCAN(aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_TIPO"	})
							nPosTpDoc3	:= ASCAN(aCposSE1,	{|aCpo| AllTrim(aCpo) 		== "E1_TIPO"	})
							nPosPref1	:= ASCAN(aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_PREFIXO"	})
							nPosPref3	:= ASCAN(aCposSE1,	{|aCpo| AllTrim(aCpo) 		== "E1_PREFIXO"	})
							nPosNum1	:= ASCAN(aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_NUMERO"	})
							nPosNum3	:= ASCAN(aCposSE1,	{|aCpo| AllTrim(aCpo) 		== "E1_NUM" 	})
							nPosPar1	:= ASCAN(aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_PARCELA"	})
							nPosPar3	:= ASCAN(aCposSE1,	{|aCpo| AllTrim(aCpo) 		== "E1_PARCELA"	})
							nPosEmis1	:= ASCAN(aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_EMISSAO"	})
							nPosEmis3	:= ASCAN(aCposSE1,	{|aCpo| AllTrim(aCpo) 		== "E1_EMISSAO"	})
							nPosVenc1	:= ASCAN(aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_DTVCTO" 	})
							nPosVenc3	:= ASCAN(aCposSE1,	{|aCpo| AllTrim(aCpo) 		== "E1_VENCTO" 	})
							nPosMotBx3	:= ASCAN(aCposSE1,	{|aCpo| AllTrim(aCpo) 		== "cMotBxSE1" 	})
							nPosValBx3	:= ASCAN(aCposSE1,	{|aCpo| AllTrim(aCpo) 		== "nBaixar" 	})
							nPosMoed3	:= ASCAN(aCposSE1,	{|aCpo| AllTrim(aCpo) 		== "E1_MOEDA" 	})
							nPosDesc3	:= ASCAN(aCposSE1,	{|aCpo| AllTrim(aCpo) 		== "nDescSE1" 	})
							nPosCred1	:= ASCAN(aHeader,	{|aCpo| Alltrim(aCpo[2])	== "EL_TPCRED"	})
							If cPaisLoc $ 'URU|BOL|PTG|ANG|PER|ARG|MEX'
								nPosVal2	:= ASCAN(oRetTit:aHeader,	{|aCpo| AllTrim(aCpo[2])	== "EL_VALOR"	})
								nPosTpDoc2	:= ASCAN(oRetTit:aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_TIPODOC"	})
								nPosPref2	:= ASCAN(oRetTit:aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_PREFIXO"	})
								nPosNum2	:= ASCAN(oRetTit:aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_NUMERO" 	})
								nPosPar2	:= ASCAN(oRetTit:aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_PARCELA"	})
								nPosEmis2	:= ASCAN(oRetTit:aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_EMISSAO"	})
								nPosVenc2	:= ASCAN(oRetTit:aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_DTVCTO" 	})
							EndIf
							nPosTrans	:= ASCAN(aHeader,	{|aCpo| AllTrim(aCpo[2]) 	== "EL_TRANSIT"	})
	  
							AADD(aCpoHdSEL,{"EL_FILIAL"	,xFilial("SEL")	})
							AADD(aCpoHdSEL,{"EL_SERIE"	,cSerie			})
							AADD(aCpoHdSEL,{"EL_RECIBO"	,cRecibo		})
							AADD(aCpoHdSEL,{"EL_DTDIGIT",dDataBase		})
							AADD(aCpoHdSEL,{"EL_CANCEL"	,.F.			})
							AADD(aCpoHdSEL,{"EL_CLIENTE",cCliente		})
							AADD(aCpoHdSEL,{"EL_LOJA"	,cLoja			})
							AADD(aCpoHdSEL,{"EL_COBRAD"	,cCobrador		})
							AADD(aCpoHdSEL,{"EL_RECPROV",cRecProv		})
							AADD(aCpoHdSEL,{"EL_CLIORIG",cCliOri		})
							AADD(aCpoHdSEL,{"EL_LOJORIG",cLojOri		})

	//Clona os arrays utilizados na confirmação do recebimento
							aClonSEL	:= ACLONE(aCols)
							aClonSE1	:= ACLONE(aLinSE1)
							aClonRet	:= ACLONE(oRetTit:aCols)
	
							For nX := 1 To Len(aClonSEL)
								If !(aClonSEL[nX][Len(aHeader)+1])
		   		//Adiciona a retenção ao array que será utilizado na simulação da contabilização
									AADD(aSimCtbSEL,aClonSEL[nX])
				
									For nY := 1 To Len(aClonRet)
										If	(aClonRet[nY][nPosTpDoc2]	== aClonSEL[nX][nPosTpDoc1])	.And.;
												(aClonRet[nY][nPosPref2]	== aClonSEL[nX][nPosPref1])		.And.;
												(aClonRet[nY][nPosNum2]		== aClonSEL[nX][nPosNum1]) 		.And.;
												(aClonRet[nY][nPosPar2]		== aClonSEL[nX][nPosPar1]) 		.And.;
												(aClonRet[nY][nPosEmis2]	== aClonSEL[nX][nPosEmis1]) 	.And.;
												(aClonRet[nY][nPosVenc2]	== aClonSEL[nX][nPosVenc1])
				   		//Altera o valor para o do quadro de resumo de retenções
											aSimCtbSEL[Len(aSimCtbSEL)][nPosVal1] := aClonRet[nY][nPosVal2]
										EndIf
									Next nY
								EndIf
							Next nX
		
							If nDescGer > 0
								nDesc		:= (nDescGer * nMoedDesc)
								nDescRat	:= 0
			//Totaliza valor das baixas em moeda 1
								aBxTotal := SomaTitBaixa()
								AEVAL(aBxTotal,{|x,y| nTot += (x * aTaxa[y]) })
			//Faz rateio do desconto geral, por item.
								AEVAL(aLinSE1, {|x| nDescRat := IIF (x[1]==1 .And. !(x[nPosTpDoc3]$MVRECANT+"/"+MV_CRNEG) .And. !(x[nPosMotBx3]=="DAC"),((x[nPosValBx3]/(nTot/aTaxa[x[nPosMoed3]]))*(nDescGer*(aTaxa[nMoedDesc]/aTaxa[x[nPosMoed3]]))),0),x[nPosDesc3] += nDescRat, nDesc -= nDescRat*(aTaxa[x[nPosMoed3]]/aTaxa[nMoedDesc])})
							Endif
		
							If nPercGer > 0
								nDescRat := 0
			//Faz rateio do desconto por item.
								AEVAL(aLinSE1, {|x| nDescRat := IIF (x[1]==1 .And. !(x[nPosTpDoc3]$MVRECANT+"/"+MV_CRNEG) .And. !(x[nPosMotBx3]=="DAC"),(nPercGer*x[nPosValBx3]*0.01),0),x[nPosDesc3] += nDescRat})
							Endif
		
							aCtbTmp := {}
		//Estrutura do array aCtbTmp:
		//1 - Alias original
		//2 - Estrutura da tabela (dbStruct)
		//3 - Alias temporário para a tabela original
		//4 - Arquivo de trabalho
		//5 - Índice do arquivo de trabalho
		//6 - Chave do índice do arquivo de trabalho
		//7 - Filtro do arquivo de trabalho
		//8 - GetArea da tabela
		
							dbSelectArea("SIX")
							SIX->(dbSetOrder(1))

							#IFDEF TOP
								cDriver := "TOPCONN"
							#ELSE
								cDriver := "DBFCDX"
							#ENDIF
		
		//SA1
							aStru := SA1->(dbStruct())
							cTabSA1	:= FINNextAlias()
							#IFDEF TOP
								cIndSA1 := ""
							#ELSE
								cIndSA1	:= CriaTrab(Nil,.F.)
							#ENDIF
							SIX->(dbGoTop())
							aIndices := GetIndices("SA1")
							cFil := ""
							If Select("SA1") > 0
								aAreaTmp := SA1->(GetArea())
								cFilter := dbFilter()
							Else
								aAreaTmp := Nil
								cFilter := Nil
							EndIf
							AADD(aCtbTmp,{"SA1",aStru,"__SA1",cTabSA1,cIndSA1,aIndices,cFil,aAreaTmp,cFilter,cDriver})
		
		//SE1
							aStru := SE1->(dbStruct())
							cTabSE1	:= FINNextAlias()
							#IFDEF TOP
								cIndSE1 := ""
							#ELSE
								cIndSE1	:= CriaTrab(Nil,.F.)
							#ENDIF
							SIX->(dbGoTop())
							aIndices := GetIndices("SE1")
							cFil := ""
							If Select("SE1") > 0
								aAreaTmp := SE1->(GetArea())
								cFilter := dbFilter()
							Else
								aAreaTmp := Nil
								cFilter := Nil
							EndIf
							AADD(aCtbTmp,{"SE1",aStru,"___SE1",cTabSE1,cIndSE1,aIndices,cFil,aAreaTmp,cFilter,cDriver})
		
		//SE5
							aStru := SE5->(dbStruct())
							cTabSE5	:= FINNextAlias()
							#IFDEF TOP
								cIndSE5 := ""
							#ELSE
								cIndSE5	:= CriaTrab(Nil,.F.)
							#ENDIF
							SIX->(dbGoTop())
							aIndices := GetIndices("SE5")
							cFil := ""
							If Select("SE5") > 0
								aAreaTmp := SE5->(GetArea())
								cFilter := dbFilter()
							Else
								aAreaTmp := Nil
								cFilter := Nil
							EndIf
							AADD(aCtbTmp,{"SE5",aStru,"__SE5",cTabSE5,cIndSE5,aIndices,cFil,aAreaTmp,cFilter,cDriver})
		
		//SEA
							aStru := SEA->(dbStruct())
							cTabSEA	:= FINNextAlias()
							#IFDEF TOP
								cIndSEA := ""
							#ELSE
								cIndSEA	:= CriaTrab(Nil,.F.)
							#ENDIF
							SIX->(dbGoTop())
							aIndices := GetIndices("SEA")
							cFil := ""
							If Select("SEA") > 0
								aAreaTmp := SEA->(GetArea())
								cFilter := dbFilter()
							Else
								aAreaTmp := Nil
								cFilter := Nil
							EndIf
							AADD(aCtbTmp,{"SEA",aStru,"__SEA",cTabSEA,cIndSEA,aIndices,cFil,aAreaTmp,cFilter,cDriver})
		
		//SEL
							aStru := SEL->(dbStruct())
							cTabSEL	:= FINNextAlias()
							#IFDEF TOP
								cIndSEL := ""
							#ELSE
								cIndSEL	:= CriaTrab(Nil,.F.)
							#ENDIF
							SIX->(dbGoTop())
							aIndices := GetIndices("SEL")
							cFil := ""
							If Select("SEL") > 0
								aAreaTmp := SEL->(GetArea())
								cFilter := dbFilter()
							Else
								aAreaTmp := Nil
								cFilter := Nil
							EndIf
							AADD(aCtbTmp,{"SEL",aStru,"__SEL",cTabSEL,cIndSEL,aIndices,cFil,aAreaTmp,cFilter,cDriver})
		
		//SFE
							aStru := SFE->(dbStruct())
							cTabSFE	:= FINNextAlias()
							#IFDEF TOP
								cIndSFE := ""
							#ELSE
								cIndSFE	:= CriaTrab(Nil,.F.)
							#ENDIF
							SIX->(dbGoTop())
							aIndices := GetIndices("SFE")
							cFil := ""
							If Select("SFE") > 0
								aAreaTmp := SFE->(GetArea())
								cFilter := dbFilter()
							Else
								aAreaTmp := Nil
								cFilter := Nil
							EndIf
							AADD(aCtbTmp,{"SFE",aStru,"__SFE",cTabSFE,cIndSFE,aIndices,cFil,aAreaTmp,cFilter,cDriver})
		
		//CT2
							aStru := CT2->(dbStruct())
							cTabCT2	:= FINNextAlias()
							#IFDEF TOP
								cIndCT2	:= ""
							#ELSE
								cIndCT2	:= CriaTrab(Nil,.F.)
							#ENDIF
							SIX->(dbGoTop())
							aIndices := GetIndices("CT2")
							cFil := ""
							If Select("CT2") > 0
								aAreaTmp := CT2->(GetArea())
								cFilter := dbFilter()
							Else
								aAreaTmp := Nil
								cFilter := Nil
							EndIf
							AADD(aCtbTmp,{"CT2",aStru,"__CT2",cTabCT2,cIndCT2,aIndices,cFil,aAreaTmp,cFilter,cDriver})
		
		//CTK
							aStru := CTK->(dbStruct())
							cTabCTK	:= FINNextAlias()
							#IFDEF TOP
								cIndCTK	:= ""
							#ELSE
								cIndCTK	:= CriaTrab(Nil,.F.)
							#ENDIF
							SIX->(dbGoTop())
							aIndices := GetIndices("CTK")
							cFil := ""
							If Select("CTK") > 0
								aAreaTmp := CTK->(GetArea())
								cFilter := dbFilter()
							Else
								aAreaTmp := Nil
								cFilter := Nil
							EndIf
							AADD(aCtbTmp,{"CTK",aStru,"__CTK",cTabCTK,cIndCTK,aIndices,cFil,aAreaTmp,cFilter,cDriver})
		
		//CV3
							aStru := CV3->(dbStruct())
							cTabCV3	:= FINNextAlias()
							#IFDEF TOP
								cIndCV3	:= ""
							#ELSE
								cIndCV3	:= CriaTrab(Nil,.F.)
							#ENDIF
							SIX->(dbGoTop())
							aIndices := GetIndices("CV3")
							cFil := ""
							If Select("CV3") > 0
								aAreaTmp := CV3->(GetArea())
								cFilter := dbFilter()
							Else
								aAreaTmp := Nil
								cFilter := Nil
							EndIf
							AADD(aCtbTmp,{"CV3",aStru,"__CV3",cTabCV3,cIndCV3,aIndices,cFil,aAreaTmp,cFilter,cDriver})
		
   		//Abre o alias original com outro nome e o fecha para tabelas temporárias DBFCDX
							For nX := 1 To Len(aCtbTmp)
								If Select(aCtbTmp[nX,3]) > 0
									dbSelectArea(aCtbTmp[nX,3])
									dbCloseArea()
								EndIf

								ChkFile(aCtbTmp[nX,1], .F. , aCtbTmp[nX,3])
								dbSelectArea(aCtbTmp[nX,1])
								dbCloseArea()
							Next nX
		
		//Cria o arquivo temporário
							For nX := 1 To Len(aCtbTmp)
								MsErase(aCtbTmp[nX,4])
								lCreate := MsCreate(aCtbTmp[nX,4], aCtbTmp[nX,2] , aCtbTmp[nX,10])
								If lCreate
									dbUseArea(.T. , aCtbTmp[nX,10] , aCtbTmp[nX,4] , aCtbTmp[nX,1] , .T. , .F.)
									dbSelectArea(aCtbTmp[nX,1])
									aIndices := aClone(aCtbTmp[nX,6])
									GeraIndice(aCtbTmp[nX,4],aIndices)
								EndIf
							Next nX
		
							nPosSE1 := ASCAN(aCtbTmp, {|aX| aX[1] == "SE1"})
							nPosSA1 := ASCAN(aCtbTmp, {|aX| aX[1] == "SA1"})
		
		//Adiciona o registro da tabela SE1 na tabela temporária		
							dbSelectArea(aCtbTmp[nPosSE1,3])
							dbSetOrder(1)		//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		
							For nY := 1 To Len(aLinSE1)
								If (aLinSE1[nY,1] == 1) .And. (aCtbTmp[nPosSE1,3])->(MsSeek(xFilial("SE1")+aLinSE1[nY,nPosPref3]+aLinSE1[nY,nPosNum3]+aLinSE1[nY,nPosPar3]+aLinSE1[nY,nPosTpDoc3]))
									RecLock("SE1",.T.)
									For nX := 1 To Len(aCtbTmp[nPosSE1,2])
										SE1->&(aCtbTmp[nPosSE1,2,nX,1]) := (aCtbTmp[nPosSE1,3])->&(aCtbTmp[nPosSE1,2,nX,1])
									Next nX
									MsUnlock()
								EndIf
							Next nY

		//Adiciona o registro da tabela SA1 na tabela temporária		
							dbSelectArea(aCtbTmp[nPosSA1,3])
							If MsSeek(xFilial("SA1")+cCliente+cLoja)		//A1_FILIAL+A1_COD+A1_LOJA
								RecLock("SA1",.T.)
								For nX := 1 To Len(aCtbTmp[nPosSA1,2])
									SA1->&(aCtbTmp[nPosSA1,2,nX,1]) := (aCtbTmp[nPosSA1,3])->&(aCtbTmp[nPosSA1,2,nX,1])
								Next nX
								MsUnlock()
							EndIf
		
		//Grava os dados da simulação da contabilização			
							For nX := 1 To Len(aSimCtbSEL)
			//Grava os dados da tabela SEL
								RecLock("SEL",.T.)
			//nI:=1
								AEVAL(aCpoHdSEL,{|x,y| IIF(FieldPos(x[1]) > 0, FieldPut(FieldPos(ALLTRIM(x[1])) , x[2]),)			})
								AEVAL(aCposSEL,	{|x,y| IIF(FieldPos(x) > 0, FieldPut(FieldPos(ALLTRIM(x)) , aSimCtbSEL[nX][y]),)	})
								If aSimCtbSEL[nX][nPosTpDoc1] $ cTiposAdm
									nPosDados := ASCAN(aDadosAdm, {|x| x[5] == nX})
									SEL->EL_CLIENTE := aDadosAdm[nPosDados][01]
									SEL->EL_LOJA    := aDadosAdm[nPosDados][02]
									SEL->EL_TIPODOC := aDadosAdm[nPosDados][04]
								EndIf
								SEL->EL_VLMOED1	:= Round( SEL->EL_VALOR * aTaxa[Val(SEL->EL_MOEDA)] ,MsDecimais(1) )
								SEL->EL_TIPO		:= SEL->EL_TIPODOC
								SEL->EL_RECIBO	:= cRecibo
								SEL->EL_VERSAO := cRevisao
			//Grava as taxas das moedas
								For nY := 2 To Len(aTaxa)
									If (SEL->(FieldPos("EL_TXMOE"+StrZero(nY,2))) > 0)
										SEL->&("EL_TXMOE"+StrZero(nY,2)) := aTaxa[nY]
									EndIf
								Next nY
								MsUnlock()
			
			//Grava os dados da tabela SE1
								If aSimCtbSEL[nX][nPosTipo] $ cCredMed
									RecLock("SE1",.T.)
									SE1->E1_FILIAL 	:= xFilial("SE1")
									SE1->E1_FILORIG := cFilant
									SE1->E1_SERREC 	:= SEL->EL_SERIE
									SE1->E1_RECIBO 	:= SEL->EL_RECIBO
									SE1->E1_PREFIXO	:= SEL->EL_PREFIXO
									SE1->E1_NUM    	:= SEL->EL_NUMERO
									SE1->E1_PARCELA	:= SEL->EL_PARCELA
									SE1->E1_TIPO   	:= SEL->EL_TIPODOC
									SE1->E1_PORTADO	:= SEL->EL_BANCO
									SE1->E1_AGEDEP 	:= SEL->EL_AGENCIA
									SE1->E1_CONTA  	:= SEL->EL_CONTA
									SE1->E1_BCOCHQ 	:= SEL->EL_BCOCHQ
									SE1->E1_AGECHQ 	:= SEL->EL_AGECHQ
									SE1->E1_CTACHQ 	:= SEL->EL_CTACHQ
									SE1->E1_EMISSAO	:= SEL->EL_EMISSAO   //dDataRef
									SE1->E1_EMIS1  	:= CtoD("")
									SE1->E1_VENCREA	:= DATAVALIDA(SEL->EL_DTVCTO)
									SE1->E1_VENCTO 	:= SEL->EL_DTVCTO
									SE1->E1_VENCORI	:= SEL->EL_DTVCTO
									SE1->E1_NATUREZ	:= SEL->EL_NATUREZ
									SE1->E1_MOEDA  	:= Val(SEL->EL_MOEDA)
									SE1->E1_CLIENTE	:= SEL->EL_CLIENTE
									SE1->E1_LOJA   	:= SEL->EL_LOJA
									SE1->E1_VALOR  	:= SEL->EL_VALOR
									SE1->E1_SALDO  	:= SEL->EL_VALOR
									SE1->E1_VLCRUZ 	:= SEL->EL_VALOR * aTaxa[SE1->E1_MOEDA]
									SE1->E1_NOMCLI 	:= SA1->A1_NOME
									SE1->E1_EMIS1  	:= dDataBase
									SE1->E1_TXMOEDA	:= aTaxa[SE1->E1_MOEDA]

									If (Empty(SEL->EL_BANCO) .And. Empty(SEL->EL_CONTA) .And. Empty(SEL->EL_AGENCIA)) .Or.;
											(SEL->EL_BANCO $ (GetNewPar("MV_CARTEIR","") + "/" + Left(GetNewPar("MV_CXFIN",""),TamSX3("A6_COD")[1])))
										SE1->E1_SITUACA := "0"
									ElseIf SEL->EL_BANCO $ (GetNewPar("MV_CARTEIR","") + "/" + Left(GetNewPar("MV_CXFIN",""),TamSX3("A6_COD")[1]))
										SE1->E1_SITUACA := "0"
									Else
										SE1->E1_SITUACA := "0"
									EndIf

									nDias := Val(SEL->EL_ACREBAN)
									dBase := SE1->E1_VENCREA
									If nDias > 5
										dBase += 3650
									Else
										aFeriados := RetFeriados()
										While nDias > 0
											dBase++
											If ASCAN(aFeriados,DtoS(dBase)) == 0 .And. Dow(dBase) <> 1 .And. Dow(dBase) <> 7
												nDias--
											EndIf
										EndDo
									EndIf
									SE1->E1_DTACRED := dBase

									SE1->E1_ORIGEM 	:= "FINA840"
									SE1->E1_VLCRUZ 	:= SEL->EL_VLMOED1
									SE1->E1_LA     	:= "S"
									SE1->E1_STATUS 	:= IIF(SE1->E1_SALDO <= 0, "B", "A")
									SE1->E1_MOVIMEN	:= SE1->E1_DTACRED
									MsUnLock()
					
									If SE1->E1_SITUACA == "1"
										SEA->(dbSetOrder(1))
										SEA->(dbGoTop())
										If SEA->(MsSeek(xFilial("SEA")+SEL->EL_PREFIXO+SEL->EL_NUMERO+SEL->EL_PARCELA))
											RecLock("SEA",.F.)
											SEA->EA_DATABOR 	:= SEL->EL_DTVCTO
											SEA->EA_PORTADO 	:= SEL->EL_BANCO
											SEA->EA_AGEDEP  	:= SEL->EL_AGENCIA
											SEA->EA_NUMCON  	:= SEL->EL_CONTA
											SEA->EA_TIPO    	:= SEL->EL_TIPODOC
											SEA->EA_CART    	:= "R"
											SEA->EA_SITUACA 	:= "1"
											SEA->EA_FILORIG 	:= SE1->E1_FILIAL
											MsUnlock()
										Else
											If !Empty(SEL->EL_BANCO)
												RecLock("SEA",.T.)
												SEA->EA_FILIAL  	:= xFilial("SEA")
												SEA->EA_DATABOR 	:= SEL->EL_DTVCTO
												SEA->EA_PORTADO 	:= SEL->EL_BANCO
												SEA->EA_AGEDEP  	:= SEL->EL_AGENCIA
												SEA->EA_NUMCON  	:= SEL->EL_CONTA
												SEA->EA_NUM     	:= SEL->EL_NUMERO
												SEA->EA_PARCELA 	:= SEL->EL_PARCELA
												SEA->EA_PREFIXO 	:= SEL->EL_PREFIXO
												SEA->EA_TIPO    	:= SEL->EL_TIPODOC
												SEA->EA_CART    	:= "R"
												SEA->EA_SITUACA 	:= "1"
												SEA->EA_FILORIG 	:= SE1->E1_FILIAL
												MsUnlock()
											EndIf
										EndIf
									EndIf
				
									FA840aAtSdDp("+",SE1->E1_VALOR,SE1->E1_MOEDA,SE1->E1_TIPO,aTaxa[SE1->E1_MOEDA],SE1->E1_EMISSAO)
								Endif
			
							Next nX
		
							dbSelectArea("SE1")
							SE1->(dbGoTop())
							ASORT(aClonSE1,,,{|x,y| x[1] > y[1] })		// Organiza aLinSE1 para que os marcados venham primeiro.
							For nX := 1 to Len(aClonSE1)
								If aClonSE1[nX][1] != 1
									Exit
								EndIf
								If SE1->(MsSeek(xFilial("SE1")+aClonSE1[nX,nPosPref3]+aClonSE1[nX,nPosNum3]+aClonSE1[nX,nPosPar3]+aClonSE1[nX,nPosTpDoc3]))
				//SE1->(MsGoto(aClonSE1[nX][Len(aClonSE1[nX])-1]))
									RecLock("SE1",.F.)
									SE1->E1_BAIXA		:= dDataRef
									SE1->E1_LA			:= 'S'
									SE1->E1_MOTIVO		:= aClonSE1[nX][nPosMotBx]
									SE1->E1_MOVIMEN		:= dDataRef
									SE1->E1_SALDO		:= (SE1->E1_SALDO - aClonSE1[nX][nPosValBx3])
									nDescoSlv			:= SE1->E1_DESCONT
									nMultaSlv			:= SE1->E1_MULTA
									nJurosSlv			:= SE1->E1_JUROS
									nVlLiqSlv			:= SE1->E1_VALLIQ
									SE1->E1_DESCONT		:= aClonSE1[nX][nPosDesc]
									SE1->E1_MULTA		:= aClonSE1[nX][nPosMulta]
									SE1->E1_JUROS		:= aClonSE1[nX][nPosJuros]
									SE1->E1_VALLIQ		:= (aClonSE1[nX][nPosValBx3] - aClonSE1[nX][nPosDesc] + aClonSE1[nX][nPosJuros] + aClonSE1[nX][nPosMulta])
									SE1->E1_SERREC   	:= cSerie
									SE1->E1_RECIBO		:= cRecibo
									SE1->E1_DTACRED		:= dDataRef
									SE1->E1_STATUS		:= IIF(SE1->E1_SALDO <=0 , "B", "A")
				//+--------------------------------------------------------------+
				//¦ Baixar titulos de abatimento se for baixa total              ¦
				//+--------------------------------------------------------------+
									IF (SE1->E1_SALDO > 0 .And. SE1->E1_SALDO == nTotAbat .And. !(SE1->E1_TIPO $ MV_CPNEG))
										SE1->E1_SALDO		:= 0
										SE1->E1_STATUS 		:= "B"
										cTitulo  	:= xFilial("SE1")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
										aAreaSE1_ 	:= SE1->(GetArea())
										SE1->(dbSetOrder(1))
										If MsSeek(cTitulo)
											While !SE1->(EOF()) .And. xFilial("SE1")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA == cTitulo
												If SE1->E1_TIPO $ MVABATIM
													RecLock("SE1",.F.)
													Replace E1_SALDO    With 0
													Replace E1_BAIXA    With dDataBase
													Replace E1_MOVIMEN  With dDataBase
													SE1->(MsUnLock())
												EndIf
												dbSkip()
											EndDo
										EndIf
										RestArea(aAreaSE1_)
									EndIf
									MsUnlock()
			
									dbSelectArea("SEL")
									RecLock("SEL",.T.)
									SEL->EL_FILIAL   	:= xFilial("SEL")
									SEL->EL_TIPODOC  	:= "TB"            // para registros que representam o titulo SE1 baixado
									SEL->EL_PREFIXO  	:= SE1->E1_PREFIXO
									SEL->EL_NUMERO   	:= SE1->E1_NUM
									SEL->EL_PARCELA  	:= SE1->E1_PARCELA
									SEL->EL_TIPO   	:= SE1->E1_TIPO
									SEL->EL_BCOCHQ 	:= SE1->E1_BCOCHQ
									SEL->EL_AGECHQ   	:= SE1->E1_AGECHQ
									SEL->EL_CTACHQ   	:= SE1->E1_CTACHQ
									SEL->EL_EMISSAO  	:= SE1->E1_EMISSAO
									SEL->EL_DTDIGIT  	:= dDataBase
									SEL->EL_DTVCTO   	:= SE1->E1_VENCREA
									SEL->EL_NATUREZ  	:= SE1->E1_NATUREZ
									SEL->EL_MOEDA    	:= STRZERO(SE1->E1_MOEDA,2)
									SEL->EL_VLMOED1		:= Round((SE1->E1_VALLIQ) * aTaxa[Max(1,SE1->E1_MOEDA)], MsDecimais(1))
									SEL->EL_DESCONT  	:= SE1->E1_DESCONT
									SEL->EL_MULTA	:= SE1->E1_MULTA
									SEL->EL_JUROS	:= SE1->E1_JUROS
									SEL->EL_VALOR    	:= SE1->E1_VALLIQ
									SEL->EL_CLIENTE		:= SE1->E1_CLIENTE
									SEL->EL_LOJA		:= SE1->E1_LOJA
									SEL->EL_SERIE    	:= cSerie
									SEL->EL_RECIBO 		:= cRecibo
									SEL->EL_VERSAO		:= cRevisao
									SEL->EL_COBRAD		:= cCobrador
									SEL->EL_RECPROV		:= cRecProv
									SEL->EL_CLIORIG		:= cCliOri
									SEL->EL_LOJORIG		:= cLojOri
				
									For nY := 2 To Len(aTaxa)
										If (SEL->(FieldPos("EL_TXMOE"+StrZero(nY,2))) > 0)
											SEL->&("EL_TXMOE"+StrZero(nY,2)) := aTaxa[nY]
										EndIf
									Next nY
				
									MsUnlock()
				
									If SE1->(MsSeek(xFilial("SE1")+aClonSE1[nX,nPosPref3]+aClonSE1[nX,nPosNum3]+aClonSE1[nX,nPosPar3]+aClonSE1[nX,nPosTpDoc3]))
										RecLock("SE1",.F.)
										SE1->E1_DESCONT		+= nDescoSlv
										SE1->E1_MULTA		+= nMultaSlv
										SE1->E1_JUROS		+= nJurosSlv
										SE1->E1_VALLIQ		+= nVlLiqSlv
										MsUnlock()
									EndIf
								EndIf
							Next nX
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz as gravacoes dos titulos que tem retencoes no SFE		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If Len(aSimCtbSEL) > 0
								dbSelectArea("SFE")
			//Rateia os impostos nos titulos informados
								nX:=0
								For nI := 1 To Len(aSimCtbSEL) // linhas do Recibo
									If aSimCtbSEL[nI][nPosTpDoc1] $ "RS|RL|RB|RI|RG"
										SE1->(dbSetOrder(1))
										nX++ // Linhas das retenções
										For nY := 1 To Len(aLinRet[nX])  // Linhas dos Titulos de cada Retenção
											If aSimCtbSEL[nI][nPosTpDoc1] == "RB"
												If !aLinRet[nX][nY][Len(aLinRet[nX,nY])] .And. (aLinRet[nX][nY][Len(aLinRet[nX,nY])-1] > 0) .And. ;
														(!lRatImp .Or.(SE1->(MsSeek(xFilial("SE1")+aLinRet[nX][nY][1]+aLinRet[nX][nY][2]+aLinRet[nX][nY][3]+aLinRet[nX][nY][4]) )))
													RecLock("SFE",.T.)
													SFE->FE_FILIAL   	:= xFilial("SFE")
													SFE->FE_EMISSAO  	:= dDataRef
													SFE->FE_CLIENTE  	:= cCliente
													SFE->FE_LOJCLI 		:= cLoja
													If lRatImp
														SFE->FE_NFISCAL  	:= SE1->E1_NUM
														SFE->FE_SERIE    	:= SE1->E1_SERIE
														SFE->FE_EST 		:= aLinRet[nX][nY][5]
														SFE->FE_CFO	 		:= aLinRet[nX][nY][6]
														SFE->FE_VALBASE 	:= aLinRet[nX][nY][7]
														SFE->FE_ALIQ		:= aLinret[nX][nY][8]
														SFE->FE_RETENC 		:= aLinRet[nX][nY][9]
													Else
														SFE->FE_EST 		:= aLinRet[nX][nY][1]
														SFE->FE_CFO	 		:= aLinRet[nX][nY][2]
														SFE->FE_VALBASE 	:= aLinRet[nX][nY][3]
														SFE->FE_ALIQ		:= aLinret[nX][nY][4]
														SFE->FE_RETENC 		:= aLinRet[nX][nY][5]
													Endif
													SFE->FE_RECIBO		:= cRecibo
													SFE->FE_NROCERT		:= aSimCtbSEL[nI][nPosNum1]
													SFE->FE_TIPO   		:= "B"
													MsUnlock()
												EndIf
											ElseIf aSimCtbSEL[nI][nPosTpDoc1] == "RI"
												If !aLinRet[nX][nY][Len(aLinRet[nX,nY])] .And. (aLinRet[nX][nY][Len(aLinRet[nX,nY])-1] > 0) .And. ;
														(!lRatImp .Or.(SE1->(MsSeek(xFilial("SE1")+aLinRet[nX][nY][1]+aLinRet[nX][nY][2]+aLinRet[nX][nY][3]+aLinRet[nX][nY][4]) )))
													RecLock("SFE",.T.)
													SFE->FE_FILIAL	:= xFilial("SFE")
													SFE->FE_EMISSAO	:= dDataRef
													SFE->FE_CLIENTE	:= cCliente
													SFE->FE_LOJCLI 	:= cLoja
													If lRatImp
														SFE->FE_NFISCAL		:= SE1->E1_NUM
														SFE->FE_SERIE		:= SE1->E1_SERIE
														SFE->FE_EST 		:= aLinRet[nX][nY][5]
														SFE->FE_CFO	 		:= aLinRet[nX][nY][6]
														SFE->FE_VALBASE 	:= aLinRet[nX][nY][7]
														SFE->FE_ALIQ		:= aLinret[nX][nY][8]
														SFE->FE_RETENC 		:= aLinRet[nX][nY][9]
													Else
														SFE->FE_EST 		:= aLinRet[nX][nY][1]
														SFE->FE_CFO	 		:= aLinRet[nX][nY][2]
														SFE->FE_VALBASE 	:= aLinRet[nX][nY][3]
														SFE->FE_ALIQ		:= aLinret[nX][nY][4]
														SFE->FE_RETENC 		:= aLinRet[nX][nY][5]
													Endif
													SFE->FE_RECIBO		:= cRecibo
													SFE->FE_NROCERT		:= aSimCtbSEL[nI][nPosNum1]
													SFE->FE_TIPO   		:= "I"
													MsUnlock()
												EndIf
							
											ElseIf aSimCtbSEL[nI][nPosTpDoc1] == "RG"
												If !aLinRet[nX][nY][Len(aLinRet[nX,nY])] .And. (aLinRet[nX][nY][Len(aLinRet[nX,nY])-1] > 0) .And. ;
														(!lRatImp .Or.(SE1->( MsSeek(xFilial("SE1")+aLinRet[nX][nY][1]+aLinRet[nX][nY][2]+aLinRet[nX][nY][3]+aLinRet[nX][nY][4]) )))
													RecLock("SFE",.T.)
													FE_FILIAL   := xFilial('SFE')
													FE_EMISSAO  := dDataRef
													FE_CLIENTE  := cCliente
													FE_LOJCLI 	:= cLoja
													If lRatImp
														FE_NFISCAL  := SE1->E1_NUM
														FE_SERIE    := SE1->E1_SERIE
														FE_EST 		:= aLinRet[nX][nY][5]
														FE_CFO	 	:= aLinRet[nX][nY][6]
														FE_CONCEPT 	:= aLinRet[nX][nY][7]
														FE_VALBASE 	:= aLinRet[nX][nY][8]
														FE_ALIQ		:=	aLinret[nX][nY][9]
														FE_RETENC 	:= aLinRet[nX][nY][10]
													Else
														FE_EST 		:= aLinRet[nX][nY][1]
														FE_CFO	 	:= aLinRet[nX][nY][2]
														FE_CONCEPT 	:= aLinRet[nX][nY][3]
														FE_VALBASE 	:= aLinRet[nX][nY][4]
														FE_ALIQ		:=	aLinret[nX][nY][5]
														FE_RETENC 	:= aLinRet[nX][nY][6]
													Endif
													FE_RECIBO   := cRecibo
													FE_NROCERT	:= aSimCtbSEL[nI][nPosNum1]
													FE_TIPO   	:= "G"
													MsUnlock()
												EndIf
											ElseIf aSimCtbSEL[nI][nPosTpDoc1] == "RS"
												If !aLinRet[nX][nY][Len(aLinRet[nX,nY])] .And. (aLinRet[nX][nY][Len(aLinRet[nX,nY])-1] > 0) .And. ;
														(!lRatImp .Or.(SE1->( MsSeek(xFilial("SE1")+aLinRet[nX][nY][1]+aLinRet[nX][nY][2]+aLinRet[nX][nY][3]+aLinRet[nX][nY][4]) )))
													RecLock("SFE",.T.)
													FE_FILIAL   := xFilial('SFE')
													FE_EMISSAO  := dDataRef
													FE_CLIENTE  := cCliente
													FE_LOJCLI 	:= cLoja
													If lRatImp
														FE_NFISCAL  := SE1->E1_NUM
														FE_SERIE    := SE1->E1_SERIE
														FE_EST 		:= aLinRet[nX][nY][5]
														FE_CFO	 	:= aLinRet[nX][nY][6]
														FE_CONCEPT 	:= aLinRet[nX][nY][7]
														FE_VALBASE 	:= aLinRet[nX][nY][8]
														FE_ALIQ		:=	aLinret[nX][nY][9]
														FE_RETENC 	:= aLinRet[nX][nY][10]
													Else
														FE_EST 		:= aLinRet[nX][nY][1]
														FE_CFO	 	:= aLinRet[nX][nY][2]
														FE_CONCEPT 	:= aLinRet[nX][nY][3]
														FE_VALBASE 	:= aLinRet[nX][nY][4]
														FE_ALIQ		:=	aLinret[nX][nY][5]
														FE_RETENC 	:= aLinRet[nX][nY][6]
													Endif
													FE_RECIBO   := cRecibo
													FE_NROCERT	:= aSimCtbSEL[nI][nPosNum1]
													FE_TIPO   	:= "S"
													MsUnlock()
												EndIf
											Else
												If aLinRet[nX][nY][7] == aSimCtbSEL[nI][nPosTpDoc1]
													If (aLinRet[nX][nY][5] > 0) .And. ;
															(SE1->(MsSeek(xFilial("SE1")+aLinRet[nX][nY][1]+aLinRet[nX][nY][2]+aLinRet[nX][nY][3]+aLinRet[nX][nY][4]) ))
														RecLock("SFE",.T.)
														SFE->FE_FILIAL   	:= xFilial("SFE")
														SFE->FE_EMISSAO  	:= dDataRef
														SFE->FE_CLIENTE  	:= cCliente
														SFE->FE_LOJCLI 		:= cLoja
														SFE->FE_NFISCAL  	:= SE1->E1_NUM
														SFE->FE_SERIE    	:= SE1->E1_SERIE
														SFE->FE_RECIBO   	:= cRecibo
														SFE->FE_NROCERT		:= aLinRet[nX][nY][6]
														SFE->FE_TIPO   		:= Subs(aLinRet[nX][nY][7] ,2 ,1) // I-B-S-L
														SFE->FE_RETENC 		:= aLinRet[nX][nY][5]
														MsUnlock()
													EndIf
												EndIf
											EndIf
										Next nY
									Else
										If (aSimCtbSEL[nI][nPosVal1] > 0) .And. (aSimCtbSEL[nI][nPosTpDoc1] $ "RI")
											RecLock("SFE",.T.)
											SFE->FE_FILIAL   	:= xFilial("SFE")
											SFE->FE_NROCERT		:= aSimCtbSEL[nI][nPosNum1]
											SFE->FE_EMISSAO  	:= dDataRef
											SFE->FE_CLIENTE  	:= cCliente
											SFE->FE_LOJCLI 		:= cLoja
											SFE->FE_TIPO   		:= Subs(aSimCtbSEL[nI][nPosTpDoc1] ,2 ,1) // I-B   // VERIFICAR O QUE GRAVA QUANDO USA RETENCAO
											SFE->FE_RECIBO   	:= cRecibo
											SFE->FE_RETENC 		:= aSimCtbSEL[nI][nPosVal1]
											MsUnlock()
										EndIf
									Endif
								Next nI
							EndIf

		
							If lGerNCC
								lGerNCC	:= .F.
								cParc	:= " "
			
								SE1->(dbGoTop())
								While SE1->(MsSeek(xFilial("SE1")+"REC"+Padr(cRecibo,TamSx3("E1_NUM")[1]," ")+Padr(cParc,TamSx3("E1_PARCELA")[1]," ")+cDocCred))
									cParc := Soma1(cParc)
								Enddo
		
								For nValMoed := 1 To Len(aLinMoed)
									nVlrTit	:= aLinMoed[nValMoed,4]
									If nVlrTit > 0
					//-- Registro no SEL
										RecLock("SEL",.T.)
										SEL->EL_FILIAL		:= xFilial("SEL")
										SEL->EL_TIPODOC 	:= "RA"
										SEL->EL_PREFIXO  	:= "REC"
										SEL->EL_NUMERO   	:= cRecibo
										SEL->EL_PARCELA  	:= cParc
										SEL->EL_TIPO   	:= cDocCred
										SEL->EL_EMISSAO  	:= dDataRef
										SEL->EL_DTDIGIT  	:= dDataBase
										SEL->EL_DTVCTO   	:= dDataRef
										SEL->EL_MOEDA    	:= StrZero(nValMoed,2)//Aqui representa qual e a moeda
										SEL->EL_VLMOED1  	:= Round( nVlrTit * aTaxa[nValMoed], MsDecimais(1) )
										SEL->EL_VALOR    	:= nVlrTit
										SEL->EL_CLIENTE  	:= cCliente
										SEL->EL_LOJA	 	:= cLoja
										SEL->EL_SERIE  		:= cSerie
										SEL->EL_RECIBO 		:= cRecibo
										SEL->EL_VERSAO := cRevisao
										SEL->EL_COBRAD		:= cCobrador
										SEL->EL_RECPROV		:= cRecProv
										SEL->EL_CLIORIG		:= cCliOri
										SEL->EL_LOJORIG		:= cLojOri
					
										For nY := 2 To Len(aTaxa)
											If (SEL->(FieldPos("EL_TXMOE"+StrZero(nY,2))) > 0)
												SEL->&("EL_TXMOE"+StrZero(nY,2)) := aTaxa[nY]
											EndIf
										Next nY
					
										MsUnlock()
		
					//-- Registro no SE1
										RecLock("SE1",.T.)
										SE1->E1_FILIAL   	:= xFilial("SE1")
										SE1->E1_FILORIG     := cFilant
										SE1->E1_PREFIXO  	:= "REC"
										SE1->E1_NUM			:= cRecibo
										SE1->E1_PARCELA		:= cParc
										SE1->E1_TIPO     	:= cDocCred   // gravando o titulo ncc com o tipo original. ok correto
										SE1->E1_EMISSAO  	:= dDataRef
										SE1->E1_EMIS1    	:= CtoD("")
										SE1->E1_VENCTO  	:= dDataRef
										SE1->E1_VENCREA 	:= DataValida(dDataRef)
										SE1->E1_NATUREZ  	:= SEL->EL_NATUREZ
										SE1->E1_MOEDA   	:= nValMoed
										SE1->E1_VLCRUZ		:= nVlrTit * aTaxa[nValMoed]
										SE1->E1_VALOR   	:= nVlrTit
										SE1->E1_SALDO   	:= nVlrTit
										SE1->E1_CLIENTE 	:= cCliente
										SE1->E1_LOJA    	:= cLOJA
										SE1->E1_SERREC    	:= cSerie
										SE1->E1_RECIBO  	:= cRecibo
										SE1->E1_NOMCLI   	:= SA1->A1_NOME
										SE1->E1_SITUACA  	:= "0"
										SE1->E1_ORIGEM   	:= "FINA840"
										SE1->E1_LA       	:= "S"
										SE1->E1_STATUS   	:= "A"
										SE1->E1_TXMOEDA		:= aTaxa[nValMoed]
										If cPaisLoc == "CHI"
											SE1->E1_CGC 		:= SA1->A1_CGC
										Endif
										MsUnlock()
		
					//AADD(aRecAdt,{SE1->(RECNO()),SE1->E1_VALOR}) //Controle de inclusão de adiantamentos
		
										FA840aAtSdDp("-",SE1->E1_VALOR,SE1->E1_MOEDA,SE1->E1_TIPO,aTaxa[SE1->E1_MOEDA],SE1->E1_EMISSAO)
										cParc := Soma1(cParc)		//Atualiza a proxima parcela
									EndIf
								Next nValMoed
							EndIf
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Simulação da contabilização                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lGeraLanc
			//+--------------------------------------------------------------+
			//¦ Posiciona numero do Lote para Lancamentos do Financeiro      ¦
			//+--------------------------------------------------------------+
								dbSelectArea("SX5")
								MsSeek(xFilial()+"09FIN")
								cLoteCom := IIF(Found(),AllTrim(X5DESCRI()),"FIN")
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializa Lancamento Contabil                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								nHdlPrv := HeadProva(cLoteCom,;
									"FINA840",;
									Substr(cUsuario, 7, 6),;
									@cArquivo)
		
								If nHdlPrv <= 0
									Help(" ",1,"A100NOPROV")
								EndIf
							Else
								Return
							EndIf
		
							If nHdlPrv > 0 .and. lGeraLanc
			//+--------------------------------------------------+
			//¦ Gera Lancamento Contab. para RECIBO.             ¦
			//+--------------------------------------------------+
								If lGeraLanc
									dbSelectArea("SEL")
									SEL->(dbSetOrder(8))
									SEL->(MsSeek(xFilial("SEL")+cSerie+cRECIBO,.F.))

									While !SEL->(EOF()) .And. SEL->EL_SERIE==cSerie .And. SEL->EL_RECIBO==cRECIBO
				
										Do Case
										Case SEL->(EL_TIPODOC) == "TB" .And. SEL->(EL_TIPO) $ MV_CRNEG+"/"+MVRECANT .And. VerPadrao("5BN")
											lLancPad70 := .T.
											cPadrao := "5BN"
										Case SEL->(EL_TIPODOC) == "TB" .And. !(SEL->(EL_TIPO) $ MV_CRNEG+"/"+MVRECANT) .And. VerPadrao("5BO")
											lLancPad70 := .T.
											cPadrao := "5BO"
										Case SEL->(EL_TIPODOC) == "RA" .And. VerPadrao("5BP")
											lLancPad70 := .T.
											cPadrao := "5BP"
										Case SEL->(EL_TIPODOC) == "CH" .And. VerPadrao("5BQ")
											lLancPad70 := .T.
											cPadrao := "5BQ"
										Case SEL->(EL_TIPODOC) == "DC" .And. VerPadrao("5BR")
											lLancPad70 := .T.
											cPadrao := "5BR"
										Case SEL->(EL_TIPODOC) == "EF" .And. VerPadrao("5BS")
											lLancPad70 := .T.
											cPadrao := "5BS"
										Case SEL->(EL_TIPODOC) == "TF" .And. VerPadrao("5BT")
											lLancPad70 := .T.
											cPadrao := "5BT"
										Case SEL->(EL_TIPODOC) $ "RS/RL/RB/RI/RG/RR" .And. VerPadrao("5BU")
											lLancPad70 := .T.
											cPadrao := "5BU"
										Otherwise
											lLancPad70 := VerPadrao("575")
											cPadrao := "575"
										EndCase
										If 	lLancPad70
											SA6->(dbSetOrder(1))
											SA6->(MsSeek(xFilial("SA6")+SEL->(EL_BANCO+EL_AGENCIA+EL_CONTA),.F.))
						    
											dbSelectArea("SE1")
											SE1->(dbSetOrder(2))
											SE1->(MsSeek(xFilial("SE1")+SEL->(EL_CLIORIG+EL_LOJORIG+EL_PREFIXO+EL_NUMERO+EL_PARCELA+EL_TIPO),.F.))
						
											Do Case
											Case ( Alltrim(SEL->EL_TIPO) == Alltrim(GetSESnew("NCC")) )
												cAlias := "SF1"
											Case ( Alltrim(SEL->EL_TIPO) == Alltrim(GetSESnew("NDE")) )
												cAlias := "SF1"
											Otherwise
												cAlias := "SF2"
											EndCase
											cKeyImp := 	xFilial(cAlias)			+;
												SE1->E1_NUM		+;
												SE1->E1_PREFIXO	+;
												SE1->E1_CLIENTE	+;
												SE1->E1_LOJA
											If ( cAlias == "SF1" )
												cKeyImp += SE1->E1_TIPO
											Endif
											Posicione(cAlias,1,cKeyImp,"F"+SubStr(cAlias,3,1)+"_VALIMP1")
						
			
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Prepara Lancamento Contabil                                      ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
												aAdd( aFlagCTB, {"EL_LA", "S", "SEL", SEL->( Recno() ), 0, 0, 0} )
											Endif
											nTotalLanc := nTotalLanc + DetProva(nHdlPrv,;
												cPadrao,;
												"FINA840" /*cPrograma*/,;
												cLoteCom,;
												@nLinha,;
										                    /*lExecuta*/,;
										                    /*cCriterio*/,;
										                    /*lRateio*/,;
										                    /*cChaveBusca*/,;
										                    /*aCT5*/,;
										                    /*lPosiciona*/,;
										                    @aFlagCTB,;
										                    /*aTabRecOri*/,;
										                    /*aDadosProva*/,;
										                    lSimula,;
										                    cTabCTK,;
										                    cTabCT2,;
										                    cTabCV3)
	
						If UsaSeqCor()
							AAdd(aDiario,{"SEL",SEL->(Recno()),cDiario,"EL_NODIA","EL_DIACTB"})
						EndIf
						
					EndIf						
					
					SEL->(dbSkip())
					
				EndDo
			Endif
			
			//+-----------------------------------------------------+
			//¦ Envia para Lancamento Contabil, se gerado arquivo   ¦
			//+-----------------------------------------------------+
			//SEL->(dbSetOrder (1))		//8##//O índice continua sendo 8, porém como ordem 1
			SEL->(MsSeek(xFilial("SEL")+cSerie+cRecibo))
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Efetiva Lan‡amento Contabil                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RodaProva(nHdlPrv,nTotalLanc)

			lLanctOk := cA100Incl(	cArquivo,;
									nHdlPrv,;
									3 /*nOpcx*/,;
									cLoteCom,;
									lDigita,;
									lAglutina,;
									/*cOnLine*/,;
									/*dData*/,;
									/*dReproc*/,;
									@aFlagCTB,;
									/*aDadosProva*/,;
									aDiario,;
									/*aTpSaldo*/,;
									lSimula,;
									cTabCTK,;
									cTabCT2)

			aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento
		
			If lLanctOk
				//SEL->(dbSetOrder(1))		//8##//O índice continua sendo 8, porém como ordem 1
				If SEL->(MsSeek(xFilial("SEL")+cSerie+cRecibo))
					While SEL->EL_SERIE==cSerie .And. SEL->EL_RECIBO==cRecibo
						RecLock("SEL",.F.)
						Replace EL_LA With "S"
						MsUnLock()
						SEL->(dbSkip())
					Enddo
				EndIf
			Endif
		EndIf				
	EndIf
	
	If nOpcX == 2
		If (aCtbTmp != Nil) .And. (ValType(aCtbTmp) == "A")
			//Se for 2, fecha e exclui os arquivos temporários e restaura os alias originais
			For nX := 1 To Len(aCtbTmp)
				If Select(aCtbTmp[nX,1]) > 0
					dbSelectArea(aCtbTmp[nX,1])
					dbCloseArea()
					#IFDEF TOP
						//Exclui a tabela temporária na base de dados
						TCDelFile(aCtbTmp[nX,4])
					#ELSE
						//Apaga os arquivos de trabalho e indices dos arquivos
						//If File(aCtbTmp[nX,5]+OrdBagExt())
						If File(aCtbTmp[nX,4]+GetDBExtension())
							Ferase(aCtbTmp[nX,4]+GetDBExtension())		//Apaga os arquivos temporários locais
							Ferase(aCtbTmp[nX,4]+OrdBagExt())			//Apaga os arquivos de índices
							Ferase(aCtbTmp[nX,5]+OrdBagExt())			//Apaga os arquivos de índices
							Ferase(aCtbTmp[nX,4]+".fpt")				//Apaga os arquivos temporários locais de tabelas com campos MEMO (BLOB)
						EndIf
					#ENDIF
				EndIf
				//Restaura o alias original
				If Select(aCtbTmp[nX,3]) > 0
					ChkFile(aCtbTmp[nX,3], .F. , aCtbTmp[nX,1])
					dbSelectArea(aCtbTmp[nX,3])
					dbCloseArea()
					dbSelectAreA(aCtbTmp[nX,1])
					If (aCtbTmp[nX,8] != Nil) .And. (ValType(aCtbTmp[nX,8]) == "A")
						RestArea(aCtbTmp[nX,8])
					EndIf
				EndIf
			Next nX
		EndIf
	EndIf


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA840  ºAutor  ³Microsiga           º Data ³  04/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³Funcao que grava os campos no SA1 para avaliaçao de credito ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Parametros³cOper = Operando para calcular os campos de avliaçao do 	  ³±±
±±º          ³        credito 											  ³±±
±±³          ³nValor = Valor do campo que será calculado                  ³±±
±±³          ³nMoeda = Moeda Forte do Cliente                             ³±±
±±³          ³cTipoDoc = Tipo de Titulo(Docto)                            ³±±
±±³          ³nTaxa  = Taxa de conversão do Valor do campo para a Moeda   ³±±
±±º          ³         Forte 											  ³±±
±±³          ³dData  = Data de conversão do Valor do cmapo para a Moeda   ³±±
±±º          ³         Forte 											  ³±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºATENÇÃO   ³ ESTE PROGRAMA É UMA CÓPIA E ADAPTAÇÃO DO AtuSalDup         º±±
±±º          ³ CONTIDO NO FONTE MATXATU                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
												Static Function FA840aAtSdDp(cOper,nValor,nMoeda,cTipoDoc,nTaxa,dData,nCm)

											Local cCampo		:= ""									// Campo que terá o saldo atualizado
											Local cCampo1		:= ""									// Campo que terá o saldo atualizado
											Local cTpNaoAtu		:= Nil									// Tipos que nao atualizam saldo algum no cadastro de clientes
//Local cFilSF2		:= xFilial("SF2")        				// Filial da tabela SF2
											Local lE1MsFil		:= SE1->(FieldPos("E1_MSFIL") > 0)		// Se existe o campo E1_MSFIL
											Local aAreaSA1		:= SA1->(GetArea()) 					// Salva a area do SA1
//Local aAreaSF2		:= SF2->(GetArea())						// Salva a area do SF2
											Local cTiposLC		:= Nil
											Local nMCusto
											Local nMoedaF		:= 0
											Local nValorMoe1	:= 0
											Local nValorMoeF	:= 0

											nTaxa	:=  If(nTaxa	==	Nil,0,nTaxa)
											nMoeda	:=	If(nMoeda	==	Nil,1,nMoeda)
											dData	:=	If(dData	==	Nil,dDataBase,dData)

											Default nCm := 0

											If !cOper $ "+-="
	//MsgAlert(STR0044)  //"Operando incorreto, Verifique se é uma atribuição, soma ou subtração"
												Return
											Endif

											If cTiposLC == Nil
												cTiposLC := ""
												cTiposLC := FA840aSESTp({ || ES_SALDUP == "2"},"1")
												nMCusto  :=	Val(GetMV("MV_MCUSTO"))
											Endif

// Tipos que nao atualizam nenhum dos saldos
											If cTpNaoAtu == Nil
												cTpNaoAtu := ""
												cTpNaoAtu := FA840aSESTp({ || ES_SALDUP == "3"},"1")
											Endif

											If !(cTipoDoc $ cTpNaoAtu)
												If cTipoDoc $ cTiposLC
													cCampo	:=	"SA1->A1_SALFIN"
													cCampo1	:=	"SA1->A1_SALFINM"
												Else
													cCampo	:=	"SA1->A1_SALDUP"
													cCampo1	:=	"SA1->A1_SALDUPM"
												Endif
											Else
												Return
											Endif

											nMoedaF		:= If(SA1->A1_MOEDALC > 0,SA1->A1_MOEDALC,nMCusto)

											nValorMoe1	:= Round(xMoeda(nValor-nCm,nMoeda,1,dData,MsDecimais(1)+1),MsDecimais(1))
											nValorMoeF  := Round(xMoeda(nValor,nMoeda,nMoedaF,dData,MsDecimais(nMoedaF)+1,,nTaxa),MsDecimais(nMoedaF))

											RecLock("SA1",.F.)
											If cOper == "+"
												&cCampo. 	+= nValorMoe1
												&cCampo1. 	+= nValorMoeF
											ElseIf cOper == "-"
												&cCampo. 	-= nValorMoe1
												&cCampo1. 	-= nValorMoeF
											ElseIf cOper == "="
												&cCampo. 	:= nValorMoe1
												&cCampo1.	:= nValorMoeF
											EndIf
											MsUnlock()

											Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA840aSESTp  ºAutor  ³ Renan Guedes     º Data ³  04/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna a os tipos de acordo com o bloco de codigo.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ bProps    = Bloco de codigo com as propriedades a consultarº±±
±±º          ³ cCarteira = Carteira a consultar (Default ‚ ambas).        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºATENÇÃO   ³ ESTE PROGRAMA É UMA CÓPIA E ADAPTAÇÃO DO GetSESTipos       º±±
±±º          ³ CONTIDO NO FONTE MATXFUNC                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
										Static Function FA840aSESTp(bProps,cCarteira)

											Local aArea	:= {}
											Local cRet

											Default cCarteira 	:=	"3"

											cRet	:=	Space(0)
											aArea	:=	GetArea()

											If AliasInDic("SES") //Select("SES") > 0
												dbSelectArea("SES")
												dbSetOrder(1)
												dbSeek(xFilial())
												While !EOF() .And. xFilial() == ES_FILIAL
													If EVAL(bProps) .And. ( cCarteira $ "3" .Or. ES_CARTEIR $ "3" ;
															.Or. ES_CARTEIR $ cCarteira)
														cRet +=	ES_TIPO + "|"
													Endif
													dbSkip()
												EndDo
											EndIf

											cRet :=	IIF(!Empty(cRet), Substr(cRet,1,Len(cRet)-1), cRet)

											RestArea(aArea)

											Return(cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINNextAliasºAutor  ³Alvaro Camillo Netoº Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Proteção para retornar o próximo alias disponivel no Banco  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
										Static Function FINNextAlias()

											Local cNextAlias := ""
											Local aArea := GetArea()

											While .T.
												cNextAlias := GetNextAlias()
												If !TCCanOpen(cNextAlias) .And. Select(cNextAlias) == 0
													Exit
												EndIf
											EndDo

											RestArea(aArea)

											Return cNextAlias

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AjustaSX1 ºAutor  ³Jose Lucas         º Data ³  20/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criacao da pergunte 07-Considera Filial?                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR840                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
										Static Function AjustaSX1(cPerg)
											LOCAL aSavArea := GetArea()
											LOCAL aHelpPor := {}
											LOCAL aHelpIng := {}
											LOCAL aHelpEsp := {}

// 01-X1_GRUPO,02-X1_ORDEM,03-X1_PERGUNT,04-X1_PERSPA,05-X1_PERENG,06-X1_VARIAVL,07-X1_TIPO,08-X1_TAMANHO,09-X1_DECIMAL,10-X1_PRESEL,11-X1_GSC,12-X1_VALID,13-X1_F3
// 14-X1_GRPSXG,15-X1_PYME,16-X1_VAR01,17-X1_DEF01,18-X1_DEFSPA1,19-X1_DEFENG1,20-X1_CNT01,21-X1_DEF02,22-X1_DEFSPA2,
// 23-X1_DEFENG2,24-X1_DEF03,25-X1_DEFSPA3,26-X1_DEFENG3,27-X1_DEF04,28-X1_DEFSPA4,29-X1_DEFENG4,30-X1_DEF05,31-X1_DEFSPA5,
// 32-X1_DEFENG5,33-HelpPor,34-HelpSpa,35-HelpEng,36-X1_HELP

											If ! SX1->(dbSeek(cPerg+"    "+"07"))

												aHelpPor:={}
												aHelpEsp:={}
												aHelpIng:={}
												Aadd(aHelpPor,'Se considera filial, sistema exibe  ')
												Aadd(aHelpPor,'os titulos da filial atual, caso não')
												Aadd(aHelpPor,'considera, exibe titulos de todas as')
												Aadd(aHelpPor,'filiais para liquidação.            ')
												Aadd(aHelpEsp,'Si considera sucursal, el sistema   ')
												Aadd(aHelpEsp,'presenta los titulos solamente de la')
												Aadd(aHelpEsp,'sucursal actual, si no, presenta    ')
												Aadd(aHelpEsp,'de todas las sucursales para baja.  ')
												Aadd(aHelpIng,'If considerate branch, the system   ')
												Aadd(aHelpIng,'show recepiet only select branch,   ')
	//       01    02        03                               04              05                 06    07  080910 11  12  13    14 15    16      17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36
												PutSx1( cPerg,  '07','Considera Filial?'    ,'Considera Sucursal?','Considerate Branch?','mv_ch1','N',01 ,0,0,'C','','   ','','','mv_par07','Sim','Si' ,'Yes','','Nao','No' ,'No ','','','','','','','','','','','','','')
												PutSX1Help("P."+cPerg+"07.",aHelpPor, aHelpIng, aHelpEsp)
											EndIf
											RestArea(aSavArea)
											Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetIndicesºAutor  ³ Marylly A. Silva   º Data ³  30/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ OBTEM OS INDICES DAS TABELAS                               º±±
±±º          ³ UTILIZADA PARA SIMULACAO DE LANCOS CONTABEIS (ARGENTTINA)  º±±
±±º          ³ (Correção do Problema de Restauração de Índices da simula- º±±
±±º          ³ ção da contabilização na rotina de recibos de cobrança)	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
										Static Function GetIndices(cAlias)

											Local aIndices	:= {}

											SIX->(dbSetOrder(1))
											If SIX->(MsSeek(cAlias+"1"))
												aIndices := {}
												While !(SIX->(EOF())) .AND.  SIX->INDICE == cAlias
													AADD(aIndices, SIX->CHAVE)
													SIX->(DBSkip())
												Enddo
											EndIf

											Return(aIndices)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraIndiceºAutor  ³Marylly A. Silva    º Data ³  30/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ GERA OS INDICES DAS TABELAS                                º±±
±±º          ³ UTILIZADA PARA SIMULACAO DE LANCOS CONTABEIS (ARGENTTINA)  º±±
±±º          ³ (Correção do Problema de Restauração de Índices da simula- º±±
±±º          ³ ção da contabilização na rotina de recibo de cobrança)	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Simulação da Contabilização dos itens do recibo de cobrançaº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
										Static Function GeraIndice(cArq,aIndices)

											Local cInd	:= "01"
											Local nX	:= 0

											For nX := 1 to Len(aIndices)
												dbCreateInd(cArq+cInd,aIndices[nX],{|| aIndices[nX] } )
												cInd := Soma1(cInd,5)
											Next nX

											dbClearInd()
											cInd	:= "01"

											For nX := 1 to Len(aIndices)
												dbSetIndex(cArq+cInd)
												cInd := Soma1(cInd,5)
											Next nX

											Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PmsFi840  ºAutor  ³Jandir Deodato      ºFecha ³ 04/09/12    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Caso a integração com o Totvs Obras e Projetos esteja      º±±
±±º              ligada chama a tela de rateio do projeto.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
										Static Function PmsFi840()
											Local aSave
											Local bPMSDlg84 :={||PmsDlgRC(3,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_ORIGEM)}//integração com Totvs obras e projetos
											aSave:=GetArea()
											M->E1_NUM 		:=SE1->E1_NUM
											M->E1_PREFIXO :=SE1->E1_PREFIXO
											M->E1_FORNECE :=SE1->E1_FORNECE
											M->E1_LOJA		:=SE1->E1_LOJA
											M->E1_ORIGEM	:=SE1->E1_ORIGEM
											M->E1_VALOR	:=SE1->E1_VALOR
											M->E1_MOEDA	:=SE1->E1_MOEDA
											M->E1_TXMOEDA	:=SE1->E1_TXMOEDA
											Eval (bPMSDlg84)
											PMSWriteRC(1,"SE1")
											RestArea(aSave)
											Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA840TpBcoºAutor  ³Microsiga           º Data ³  05/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida o tipo de banco do modo de pago (FJS)e do banco(SA6)º±±
±±º          ³ Projeto: M11.7CTR01 Requisito: 1421.5                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN - Argentina                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
										Static Function FA840TpBco(cTipModPag,cCodBanco,cCodAgenc,cCodConta)
											Local lRet			:= .T.
											Local aSaveArea 	:= GetArea()
											Local cFJSTipBco	:= ""
											Local cSA6TipBco	:= ""

											Default cTipModPag	:= CriaVar("FJS_TIPO"	,.F.)
											Default cCodBanco	:= CriaVar("A6_COD"		,.F.)
											Default cCodAgenc	:= CriaVar("A6_AGENCIA"	,.F.)
											Default cCodConta	:= CriaVar("A6_NUMCON"	,.F.)

//Verifica se os campos existem na base
//Verifica se todos campos estao preenchidos
											If !Empty(cTipModPag) .And. !Empty(cCodBanco) .And. !Empty(cCodAgenc) .And. !Empty(cCodConta)

												cFJSTipBco := GetAdvFVal("FJS","FJS_TIPBCO"	,XFilial("FJS")+cTipModPag						,1,"")
												cSA6TipBco := GetAdvFVal("SA6","A6_TIPBCO"	,XFilial("SA6")+cCodBanco+cCodAgenc+cCodConta	,1,"")
												If !Empty(cFJSTipBco) .And. (cFJSTipBco <> cSA6TipBco)
													lRet := .F.
													Help(" ",1,"SA6TIPBCO")
												EndIf
											EndIf

											RestArea(aSaveArea)

											Return(lRet)


/*/{Protheus.doc}F840GETDESC
Retorna descrição do campo posicionado na SX3.

@author Lucas de Oliveiva
@since  02/12/2013
@version 11.90
/*/
										Static Function F840GETDESC(cCampo)
											Local aArea := SX3->(GetArea())
											Local cDescric := ""

											SX3->(dbsetorder(2))
											SX3->(MsSeek(cCampo))
											cDescric := ALLTRIM(SX3->(X3DESCRIC()))

											RestArea(aArea)

											Return(cDescric)

