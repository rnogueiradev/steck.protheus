#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ARFIN030     º Autor ³ AP6 IDE            º Data ³  24/12/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ARFIN030()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Private oGeraAg2
	Private cPerg    := "ARFI30"
	cPaisLoc := "BRA"


	Pergunte("ARFI30",.t.)


	dbSelectArea( "SE1" )
	dbSetOrder( 1 )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da tela de processamento.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oGeraAg2 FROM  200,001 TO 410,480 TITLE OemToAnsi( "Transferencia de valores" ) PIXEL

	@ 002, 010 TO 095, 230 OF oGeraAg2  PIXEL

	@ 010, 018 SAY " Este programa generará la Transferencia de valores " SIZE 200, 007 OF oGeraAg2 PIXEL
	@ 018, 018 SAY " a partir de la selección financiera                              " SIZE 200, 007 OF oGeraAg2 PIXEL
	@ 026, 018 SAY "                                                               " SIZE 200, 007 OF oGeraAg2 PIXEL

	DEFINE SBUTTON FROM 070,128 TYPE 5 ENABLE OF oGeraAg2 ACTION (Pergunte(cPerg,.T.))
	DEFINE SBUTTON FROM 070,158 TYPE 1 ENABLE OF oGeraAg2 ACTION (OkGeraAg2(),oGeraAg2:End())
	DEFINE SBUTTON FROM 070,188 TYPE 2 ENABLE OF oGeraAg2 ACTION (oGeraAg2:End())


	ACTIVATE MSDIALOG oGeraAg2 Centered


	cPaisLoc := "ARG"

return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ OkGeraAg2  º Autor ³ Cristiano Pereiraº Data ³ 10/11/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Seleção dos títulos                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function OkGeraAg2()

	//Declaracao das variaveis

	Private _oMarcados, _cAlias,_cQuery
	Private _nMarcado
	Private _lOk, lInverte
	Private _aStr,_aArea
	Private _Tmp1
	Private _aTIT,_aCampos
	Private _cPesq
	Private oMTRMT43
	Private _nVal,_oVal
	Private _cBanco , _cAg,_cCC

	_nVal:=0
	_cBanco:=space(3)
	_cAg   :=space(10)
	_cCC   := space(10)


	// Variaveis utilizada na selecao
	_nMarcados := 0
	_nVal     := 0
	_oMarcados := ""
	_oVal     := ""

	//Matriz com o nome dos campos do arquivo temporario a serem mostrados no Browse
	_aTIT := {}

	Aadd( _aTIT, {"OK"            ,"C",02,0} )
	Aadd( _aTIT, {"TITULO"        ,"C",12,0} )
	Aadd( _aTIT, {"PARCELA"        ,"C",02,0} )
	Aadd( _aTIT, {"CLIENTE"        ,"C",06,0} )
	Aadd( _aTIT, {"LOJA"          ,"C",02,0} )
	Aadd( _aTIT, {"NOME"          ,"C",20,0} )
	Aadd( _aTIT, {"VALOR"        ,"N",16,2} )
	Aadd( _aTIT, {"PREFIXO"        ,"C",3,0} )
	Aadd( _aTIT, {"TIPO"        ,"C",3,0} )




	// Fecha arquivo temporario
	If Select("TRB1") > 0
		DbSelectArea("TRB1")
		DbCloseArea()
	Endif


	//Cria arquivo temporario com os campos acima
	_Tmp1 := CriaTrab(_aTIT,.t.)

	If !Empty(_Tmp1)
		DbUseArea(.t.,,_Tmp1,"TRB1",.t.,.f.)
	EndIf

	//Matriz com o nome dos campos do arquivo temporario a serem mostrados no Browse
	_aCampo := {}

	Aadd( _aCampo, {"OK"        ,," "                     , } )
	Aadd( _aCampo, {"TITULO"       ,,"Título"             , } )
	Aadd( _aCampo, {"PARCELA"      ,,"Parcela"            , } )
	Aadd( _aCampo, {"CLIENTE"   ,,"Cliente"             , } )
	Aadd( _aCampo, {"LOJA"     ,,"Loja"                   , } )
	Aadd( _aCampo, {"NOME"     ,,"Nome"                   , } )
	Aadd( _aCampo, {"VALOR"     ,"@E 999,999,999.99","Valor"                 , } )
	Aadd( _aCampo, {"PREFIXO"     ,,"Prefixo"             , } )
	Aadd( _aCampo, {"TIPO"     ,,"Tipo"                   , } )

	// Fecha arquivo temporario
	If Select("TSE1") > 0
		DbSelectArea("TSE1")
		DbCloseArea()
	Endif


	//###############################################
	//          SELEÇÃO DE TITULOS                  #
	//###############################################
	_cQuery := " "
	_cQuery += " SELECT SE1.E1_FILIAL AS FIL,SE1.E1_PREFIXO AS PREF,SE1.E1_TIPO AS TIPO,SE1.E1_NUM AS NUM,SE1.E1_CLIENTE AS CLIENTE,SE1.E1_LOJA AS LOJA,SE1.E1_PARCELA AS PARC,SE1.E1_SALDO AS SALDO,SE1.E1_NOMCLI AS NOMCLI  "
	_cQuery += " FROM  "+RetSqlName("SE1")+" SE1             "
	_cQuery += " WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"'                                   AND                            "
	_cQuery += "       SE1.D_E_L_E_T_ <> '*'                                                  AND                            "
	_cQuery += "       SE1.E1_CLIENTE >='"+MV_PAR01+"' AND SE1.E1_CLIENTE <='"+MV_PAR02+"'    AND                            "
	_cQuery += "       SE1.E1_LOJA    >='"+MV_PAR03+"' AND SE1.E1_LOJA <='"+MV_PAR04+"'       AND                            "                                 
	_cQuery += "       SE1.E1_SALDO > 0                                                       AND                            "
	_cQuery += "       RTRIM(SE1.E1_PORTADO) ='"+RTRIM(MV_PAR07)+"'                                         AND              "
	_cQuery += "       SE1.E1_VENCREA    >='"+DTOS(MV_PAR05)+"' AND SE1.E1_VENCREA  <='"+DTOS(MV_PAR06)+"'                   "

	_cQuery += " ORDER BY SE1.E1_SALDO DESC   "

	TCQUERY _cQuery NEW ALIAS "TSE1"

	TCSETFIELD("TSE1","E1_VENCREA","D",8,0)


	_nRec   := 0
	DbEval({|| _nRec++  })

	DbSelectArea("TSE1")
	DbGotop()
	ProcRegua(lastRec())

	While !TSE1->(EOF())


		IncProc("Processando título  "+TSE1->FIL+" "+TSE1->NUM+" "+TSE1->CLIENTE)

		DbSelectArea("TRB1")
		Do While !RecLock("TRB1",.T.)
		EndDo
		TRB1->TITULO   :=  TSE1->NUM
		TRB1->PARCELA  :=  TSE1->PARC
		TRB1->CLIENTE    := TSE1->CLIENTE
		TRB1->LOJA     := TSE1->LOJA
		TRB1->NOME   :=  TSE1->NOMCLI 
		TRB1->VALOR    :=  TSE1->SALDO
		TRB1->PREFIXO  := TSE1->PREF
		TRB1->TIPO  := TSE1->TIPO

		MsUnlock()
		DbSelectArea("TSE1")
		DbSkip()
	Enddo


	DbSelectArea("TRB1")
	_cIndTRB := CriaTrab(Nil, .F.)
	_cChave  := "VALOR"
	IndRegua("TRB1",_cIndTRB,_cChave,,,"Criando Indice...")


	DbGoTop()

	If _nRec == 0
		DbSelectArea("TRB1")
		DbCloseArea()
		Ferase(_Tmp1+".Dbf")
		Aviso("Transferencias","Não existem dados para selecionar.",{"Ok"})
		return
	Endif


	lInverte := .f.
	cMarca   := GetMark()
	_aLEG    := {}

	AAdd( _aLEG,{"	TRB1->TITULO<> Space(1)","BR_VERDE"})



	//Posiciona no primeiro registro do temporario
	DbSelectArea("TRB1")
	DbGotop()

	//####################################################
	//   Montagem de Browse para interface com o usuario #
	//####################################################

	Define MsDialog oMTRMT43 Title OemToAnsi("STECK ARG - Transferencia de valores") From C(3),C(3) To C(30),C(120)
	@ C(020),C(080) To C(180),C(500)

	@  C(1),C(010) Say "Valor Selecionado:. " Color CLR_HBLUE
	@  C(1),C(0025) Say "Banco:. " Color CLR_HBLUE

	@ C(012),C(130) Get _nVal Object _oVal When .f. Picture "@E 9,999,999,999.99"  Size 070,12


	@ C(012),C(0250) Get _cBanco F3 "SA6" Size 070,12  WHEN .T.
	@ C(12),C(320) Get _cAg  When .F. F3 "SA6"     Size 070,12
	@ C(12),C(380) Get _cCC   When .F. F3 "SA6"     Size 070,12



	@ C(05),C(005) BUTTON "Pesquisar" SIZE C(50),C(15) ACTION (IIF(ARFI30A(@_cPesq) <> SPACE(40),TRB1->(DbSeek(_cPesq)),TRB1->(DbGotop())))
	@ C(6.9),C(005) BUTTON "Transferencia" SIZE C(50),C(15) ACTION ARFI30B(_cBanco,_cAg,_cCC)
	@ C(8.9),C(005) BUTTON "Sair" SIZE C(50),C(15) ACTION _Sair1(oMTRMT43)

	oMark := MsSelect():New("TRB1","OK","",_aCampo,@lInverte,@cMarca,{C(20),C(70),C(180),C(430)},,,,,_aLEG)
	oMark:bMark := {| | SELECAO(@lInverte,@_oVal,@_oMarcados,@_nVal,@_nMarcados)}


	//Ativa janela de dialogo
	Activate MsDialog oMTRMT43 CENTERED



return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SELECAO   ºAutor  ³Damiao Braz         º Data ³  09/08/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza registros no MsSelect de acordo com a selecao de   º±±
±±º          ³cada registro.                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SELECAO(lInverte,_oVal,_oMarcados,_nVal,_nMarcados)

	// Verifica se o registro foi marcado
	If IsMark("OK")
		_nVal += TRB1->VALOR   
		_nMarcados++
	Else
		_nVal -= TRB1->VALOR 
		_nMarcados--
	EndIf
	// Refresh do objeto 
	_oVal:Refresh()
	oMark:oBrowse:Refresh()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()      ³ Autor ³ Norbert Waage Junior  ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolução horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C(nTam)

	Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor

	Do Case
		Case nHRes == 640	//Resolucao 640x480
		nTam *= 0.8
		Case nHRes == 800	//Resolucao 800x600
		nTam *= 1
		OtherWise			//Resolucao 1024x768 e acima
		nTam *= 1.28
	EndCase

	If "MP8" $ oApp:cVersion
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para tema "Flat"³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf

Return Int(nTam)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DURIN48G ºAutor  ³ Cristiano Pereira  º Data ³  25/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pesquisar um fornecedor na tabela temporaria               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6- Especifico Dura Automotive                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ARFI30A(_cPesq)

	Local cCcFilial := "01"
	Local cFilMat   := "01"
	Local lRet      := .T.
	Local oDlgU
	Local oFilUsr
	Local cFilUsr   := cCcFilial
	Local oDesUsr
	Local cCodCli   := Space(TamSx3("A1_COD" )[1])
	Local cDesCli   := Space(TamSx3("A1_NOME")[1])
	Local cCodCli
	Private cDesUsr
	Private oCodCli



	DEFINE MSDIALOG oDlgU FROM 000,000 TO 160,340 TITLE OemToAnsi("Pesquisar") PIXEL //"Pesquisar"

	@ 020,003 TO 065,165 LABEL OemToAnsi("Cliente") OF oDlgU PIXEL

	@ 030,006 SAY OemToAnsi("Fil") SIZE 010,008 OF oDlgU PIXEL
	@ 040,006 MSGET oFilUsr VAR cCcFilial PICTURE "99" F3 "SM0" SIZE 010,008 OF oDlgU PIXEL VALID QA_CHKFIL(cCcFilial,@cFilMat)

	@ 030,025 SAY OemToAnsi("Código") SIZE 044,008 OF oDlgU PIXEL  //"C¢digo"
	@ 040,028 MSGET oCodFor VAR cCodCli  PICTURE '@!' F3 "SA1" SIZE 044,008 OF oDlgU PIXEL;
	VALID (cDesUsr:= A2_FOR1(cCcFilial,cCodCli,.T.),	oDesUsr:Refresh(),A1_CHK1(cCcFilial,cCodCli,SA1->A1_LOJA))

	@ 030,075 SAY OemToAnsi("Nome") SIZE 85,008 OF oDlgU PIXEL  //"Nome"
	@ 040,075 MSGET oDesUsr VAR cDesUsr SIZE 85,008 OF oDlgU PIXEL WHEN .f.

	ACTIVATE MSDIALOG oDlgU CENTERED ON INIT EnchoiceBar(oDlgU,{|| lRet:=.T., oDlgU:End()},{|| lRet:=.F., oDlgU:End()} )

	cCcFilial := cFilUsr
	_cPesq    := cDesUsr

	Return(_cPesq)

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_Sair     ºAutor  ³Cristiano Pereira    º Data ³  25/01/09  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fecha o Objeto                                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _Sair1(oMTRMT43)

	DbSelectArea("TRB1")
	Ferase(_Tmp1+".Dbf")
	//Close(oMTRMT43)
	oMTRMT43:End()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ARFI09  ºAutor  ³Cristiano Pereira     º Data ³  01/18/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processa aglutinação                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ARFI30B(_cBanco,_cAg,_cCC)

	Local _aArea  := GetArea()
	Local _nSeq    := 1


	Local aTit :={}
	Local cPrefixo := "001"
	Local cNumero := "000000001"
	Local cParcela := "001"
	Local cTipo := "NF"
	Local cBanco := "001"
	Local cAgencia := "001"
	Local cConta := "001"
	Local cSituaca := "1"
	Local cNumBco := "132456"
	Local nDesconto := 0
	Local nValCred := 0
	Local nVlIof := 0
	Local dDataMov := Ctod("29/03/2019")







	//-- Variáveis utilizadas para o controle de erro da rotina automática
	Local aErroAuto :={}
	Local cErroRet :=""
	Local nCntErr :=0
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	Private lAutoErrNoFile := .T.

	If Empty(_cBanco)
		Alert("seleccione el banco ..")
		return     
	Endif


	//Para retornar o título para carteira é necessário informar o banco em "branco"
	If cSituaca ="0"
		cBanco := ""
		cAgencia := ""
		cConta := ""
		cNumBco := ""
	EndIf



	DbSelectArea("TRB1")
	DbGotop()

	While !TRB1->(EOF())

		If !Empty(TRB1->OK)

			aTit :={}
			cPrefixo := TRB1->PREFIXO
			cNumero := TRB1->TITULO
			cParcela := TRB1->PARCELA
			cTipo := TRB1->TIPO
			cBanco := RTrim(_cBanco)
			cAgencia := rTrim(_cAg)
			cConta := RTrim(_cCC)
			cSituaca := "1"
			cNumBco := Space(12)
			nDesconto := 0
			nValCred := 0
			nVlIof := 0
			dDataMov := ddatabase

			aErroAuto :={}
			cErroRet :=""
			nCntErr :=0
			lMsErroAuto := .F.
			lMsHelpAuto := .T.
			lAutoErrNoFile := .T.

			_aArea  := GetArea()


			//Chave do título
			aAdd(aTit, {"E1_PREFIXO" , PadR(cPrefixo , TamSX3("E1_PREFIXO")[1]) ,Nil})
			aAdd(aTit, {"E1_NUM" , PadR(cNumero , TamSX3("E1_NUM")[1]) ,Nil})
			aAdd(aTit, {"E1_PARCELA" , PadR(cParcela , TamSX3("E1_PARCELA")[1]) ,Nil})
			aAdd(aTit, {"E1_TIPO" , PadR(cTipo , TamSX3("E1_TIPO")[1]) ,Nil})


			//Informações bancárias
			aAdd(aTit, {"AUTDATAMOV" , dDataMov ,Nil})
			aAdd(aTit, {"AUTBANCO" , PadR(cBanco ,TamSX3("A6_COD")[1]) ,Nil})
			aAdd(aTit, {"AUTAGENCIA" , PadR(cAgencia ,TamSX3("A6_AGENCIA")[1]) ,Nil})
			aAdd(aTit, {"AUTCONTA" , PadR(cConta ,TamSX3("A6_NUMCON")[1]) ,Nil})
			aAdd(aTit, {"AUTSITUACA" , PadR(cSituaca ,TamSX3("E1_SITUACA")[1]) ,Nil})
			aAdd(aTit, {"AUTNUMBCO" , PadR(cNumBco ,TamSX3("E1_NUMBCO")[1]) ,Nil})


			MSExecAuto({|a, b| FINA060(a, b)}, 2,aTit)
			If lMsErroAuto
				aErroAuto := GetAutoGRLog()
				For nCntErr := 1 To Len(aErroAuto)
					cErroRet += aErroAuto[nCntErr]
				Next
				alert(cErroRet)
			EndIf

			RestArea(_aArea)

			_nSeq++

		Endif

		DbSelectArea("TRB1")
		DbSkip()
	Enddo

	DbSelectArea("TRB1")
	DbGotop()

	If !lMsErroAuto
		MsgInfo("transferencias generadas con éxito....")

		DbSelectArea("TRB1")
		Ferase(_Tmp1+".Dbf")
		//Close(oMTRMT43)
		oMTRMT43:End()

	Endif


return
