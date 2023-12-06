#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#Include 'FWMVCDef.ch'

#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
	"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
	"    border-top-width: 3px; "+;
	"    border-left-width: 3px; "+;
	"    border-right-width: 3px; "+;
	"    border-bottom-width: 3px }"+;
	"QPushButton:pressed {	color: #FFFFFF; "+;
	"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
	"    border-top-width: 3px; "+;
	"    border-left-width: 3px; "+;
	"    border-right-width: 3px; "+;
	"    border-bottom-width: 3px }"

// U_STFTA005
User Function STFTA005()
	Local cQuery     := ""
	Local aRet       := {}
	Local aParam     := {}
	Local aFiltro    := {}
	Local aCabec     := {}
	Local aDados     := {}
	Local nCBO       := 0
	Local oBTProc    := nil
	Local bSavKeyF12 := SetKey(VK_F12, Nil)

	PRIVATE cCadastro 	:= "Gerenciamento UNICOM (Desenvolvimento)"
	PRIVATE aColunas    := {}
	PRIVATE oConteudo   := nil
	PRIVATE oCBO        := nil
	PRIVATE aCmbo       := {}
	PRIVATE cConteudo   := Space(100)
	PRIVATE cPict       := "@!"
	PRIVATE oLbx
	Static oDlg1

	FWMsgRun(,{|| STFTA05A() },'Aguarde','Carregando Registros')

Return


/*/{Protheus.doc} GetNewTela
	description
	Rotina para ser utilizada com F12
	@type function
	@version 
	@author Valdemir RAbelo
	@since 27/04/2020
	@return return_type, return_description
/*/
Static Function GetNewTela()

	If oDlg1 <> Nil
		oDlg1:End()
	EndIf
	u_STFTA005()

Return

Static Function SelChange(oCBO, nCBO, aCBO, oDlg, oBTProc,oLbx)
	Local cReadVar
	Local aArea := GetArea()
	// Ordena conforme seleção
	aSort(aColunas,,,{ |x,y| x[oCBO:nAT] < y[oCBO:nAT]} )
	if oLbx != nil
		oLbx:nAt := 1
		oLbx:Refresh()
	Endif

	cConteudo := CriaVar(aCBO[oCBO:nAT][1],.F.)
	If (oCBO:nAT == 1) .or. (oCBO:nAT == 2)
		cConteudo := Space(TamSX3(aCBO[oCBO:nAT][1])[1])
		cPict    := "@!"
	ElseIf (oCBO:nAT == 3)
		cConteudo := CtoD(Space(TamSX3(aCBO[oCBO:nAT][1])[1]) )
		cPict     := "@D 99/99/9999"
	ElseIf (oCBO:nAT == 4)
		cConteudo := Space(TamSX3(aCBO[oCBO:nAT][1])[1])
	EndIf

	oConteudo:Refresh()
	oConteudo:SetFocus()

	RestArea( aArea )

Return




Static Function LocReg(oCBO, cConteudo, oLbx)
	Local nPos := 0

	oLbx:nAt := 1
	If (oCBO:nAT == 3)
		nPos := aScan(aColunas, { |x|  x[oCBO:nAT] == cConteudo } )
	ElseIf (oCBO:nAT == 2)
		nPos := aScan(aColunas, { |x| Alltrim(x[oCBO:nAT]) == Alltrim(cConteudo)} )
	Else
		if oCBO:nAT == 4
			cConteudo := Lower(cConteudo)
		endif
		nPos := aScan(aColunas, { |x| x[oCBO:nAT] $ Alltrim(cConteudo)} )
	EndIf
	If nPos > 0
		oLbx:nAT := nPos
	EndIf
	oLbx:SetFocus()

Return


Static Function VLDCONT(oBTProc)
	Local lRet := (!Empty(cConteudo))
	If lRet
		oBTProc:SetFocus()
	Else
		oLbx:SetFocus()
		lRet := .T.
	EndIf
Return lRet

Static Function MntPP8()
	Local cQry     := ""
	Local cSelecao := ""

	if MV_PAR01 > 1

		if MV_PAR01 == 7		// Encerrado
			cSelecao := " AND (PP8_DAPCLI <> ' ') AND (PP8_STATUS = 'E') and (PP8_DTENG <> ' ') and (PP8_PROD <> ' ') AND (PP8_DTRCSD <> ' ') "
		elseif MV_PAR01 == 6	// Em Desenvolvimento
			cSelecao := "  AND (PP8_DAPCLI <> ' ') AND (PP8_STATUS = 'E') AND (PP8_PROD=' ') AND (PP8_USRCSD <> ' ') AND (PP8_DTRCSD <> ' ')  and  (PP8_INDESE <> ' ')"
		elseif MV_PAR01 == 5   // Data de Entrega do Desenho
			cSelecao := " AND (PP8_DAPCLI <> ' ') AND (PP8_STATUS = 'E') AND (PP8_PROD=' ') AND (PP8_USRCSD=' ') AND (PP8_DTRCSD <> ' ')  and (PP8_INDESE=' ') AND (PP8_DTPRES <> ' ') "
		elseif MV_PAR01 == 4   // RECEBIDO ENGENHARIA
			cSelecao := " AND (PP8_DAPCLI <> ' ') AND (PP8_STATUS = 'E') AND (PP8_PROD=' ') AND (PP8_USRCSD=' ') AND (PP8_DTRCSD <> ' ')  and PP8_INDESE=' ' "
		elseif MV_PAR01 == 3	// Não recebido pela engenharia
			cSelecao := " AND ( (PP8_PROD=' ') AND (PP8_DTRCSD=' ') AND (PP8_INDESE=' ') ) OR (PP7_REJEIT='S') "
		elseif MV_PAR01 == 2	// Enviado para Engenharia
			cSelecao := " AND (PP8_DAPCLI <> ' ') AND (PP8_STATUS = 'E') AND (PP8_PROD=' ') AND (PP8_USRCSD=' ')"
			lRET := .F.
		Endif

	Endif

	cQry += "SELECT " + CRLF
	cQRY += "	PP8_FILIAL, PP8_CODIGO, PP8_DTORC,PP8_USORC,PP8_UAPCLI,PP8_STATUS,PP8_PRIOR,PP8_DTRCSD,PP8_REVDES,PP8_ROTEIR,PP8_DTRSOL,PP7_REJEIT" + CRLF
	cQRY += "FROM " + RETSQLNAME('PP8') + " PP8 " + CRLF
	cQRY += "INNER JOIN " + RETSQLNAME('PP7') + " PP7 " + CRLF
	cQRY += "ON PP7.PP7_FILIAL=PP8.PP8_FILIAL AND PP7.PP7_CODIGO=PP8.PP8_CODIGO AND PP7.D_E_L_E_T_ = ' ' " + CRLF
	cQRY += "WHERE PP8.D_E_L_E_T_ = ' ' " + CRLF
	cQRY += cSelecao + CRLF
	cQRY += " AND PP8_FILIAL='" + XFILIAL('PP8') + "' " + CRLF
	cQRY += "GROUP BY PP8_FILIAL, PP8_CODIGO, PP8_DTORC,PP8_USORC,PP8_UAPCLI,PP8_STATUS,PP8_PRIOR,PP8_DTRCSD,PP8_REVDES,PP8_ROTEIR,PP8_DTRSOL,PP7_REJEIT " + CRLF
	cQRY += "ORDER BY PP8_FILIAL, PP8_PRIOR, PP8_DTRSOL, PP8_CODIGO " + CRLF

Return cQRY




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STFTA005 ³ Autor ³ Totvs                 ³ Data ³ 22/07/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Controle de SD		                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK                                                   	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function STFTA05A()
	Private aRotina := {	{"Pesquisar"			,"AxPesqui",  	0,1},;
		{"Visualizar"			,"AxVisual",	0,2},;
		{"Conf Recebimento"		,"U_FTA005RC",	0,3},;
		{"Iniciar Desenho"		,"U_FTA005ID",	0,4},;
		{"Rej Recebimento"		,"U_FTA005RJ",	0,4},;
		{"Informar Roteiro"		,"U_FTA005D1",	0,4},;
		{"Informar Dt.Ent.Des"	,"U_TelaDtEntD",0,4},;
		{"Encerrar S D" 		,"U_FTA005SD",	0,4},;
		{"Estornar Encerrar"	,"U_FTA005EC",	0,4},;
		{"Historico S D" 		,"U_FTA005HS",	0,4},;
		{"Copiar Orcamento"		,"U_FTA005OR",	0,4},;
		{"Lista Avancada"		,"U_RSTFATAN()",0,4},;	//Chamado 005811 - Everson Santana - 08/11/2018
	    {"Rel Itens Orcamento"	,"U_FTA005PR",	0,4},;
		{"Dados Sol.Desenho"    , 'u_DadosSD()',0,4},;
		{"Rel Solic.Desenho"	,"U_STRELSD(nil,nil,1,1)",	0,4},;
		{"Obs Engenharia" 		,"U_FTA005OB",	0,4},;
		{"Legenda"				,"U_FTA005LG",	0,2} }

	Private cCadastro := OemtoAnsi( "Controle de Sol. de Desenvolvimento")

	aCores := {	{ "EMPTY(PP8_INDESE)  .AND. EMPTY(PP8_DTRCSD) .AND. EMPTY(PP8_DAPCLI) "	, "ENABLE"  	}  	,;
		{ "EMPTY(PP8_DTPRES)  .AND. !EMPTY(PP8_DAPCLI) .AND. PP8_STATUS=='E' "	, "BR_PINK"		}	,;				// Valdemir Rabelo 05/12/2019
	{ "!EMPTY(PP8_DTPRES) .AND. !EMPTY(PP8_DAPCLI) .AND. PP8_STATUS=='E' "	, "BR_MARRON"	}	,;				// Valdemir Rabelo 05/12/2019
	{ "!EMPTY(PP8_DTENG)  .AND. !EMPTY(PP8_ROTEIR) "       	   				, "DISABLE" 	} 	,;
		{ "!EMPTY(PP8_DTENG)  .AND. EMPTY(PP8_ROTEIR)  "       	   				, "BR_LARANJA" 	} 	,;
		{ "!EMPTY(PP8_INDESE) .AND. !EMPTY(PP8_DTRCSD) "     					, "BR_AZUL"		}	,;
		{ "!EMPTY(PP8_DTRCSD) .AND. EMPTY(PP8_INDESE)  "             	     	, "BR_AMARELO"	}	}



	// Dbselectarea("PP8")
	// SET FILTER TO  PP8_CODIGO == aColunas[oLbx:nAt,2] .AND. PP8_FILIAL == aColunas[oLbx:nAt,1]
	mBrowse( 6, 1, 22, 75, "PP8", , , , , , aCores)
	// SET FILTER TO
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA005  ºAutor  ³Microsiga           º Data ³  07/24/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FTA005LG
	Local aCores    := {{"ENABLE"		,"Em Aberto"},; 						//Giovani Zago 23/05/2014
	{"BR_AMARELO"	,"Recebido Engenharia"},;				//Giovani Zago 23/05/2014
	{"BR_LARANJA"	,"Pendente de informar roteiro"},;		//Valdemir Rabelo 18/09/2019
	{"BR_PINK"		,"Aguardando Data Entrega Desenho"},;	//Valdemir Rabelo 05/12/2019
	{"BR_MARRON"	,"Data Entrega do desenho já Informada"},;			//Valdemir Rabelo 05/12/2019
	{"DISABLE"		,"Encerrada"},;
		{"BR_AZUL"		,"Em Desenvolvimento"}}

	BrwLegenda(cCadastro,"Status de Processo de Engenharia",aCores)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA005  ºAutor  ³Microsiga           º Data ³  07/24/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FTA005RC
	LOCAL aCampo    := {}
	LOCAL aCONDICAO := {}
	LOCAL cHisto    := ""
	Local aAreaPP7  := GetArea()

	IF  EMPTY(PP8->PP8_DTENG)

		IF EMPTY(PP8->PP8_USRCSD)

			IF PP7->( FIELDPOS("PP7_REJEIT") ) = 0			// Valdemir Rabelo 24/04/2020
				MsgInfo("Campo de Rejeição não foi criado na Tabela: PP7. "+CRLF+"Informe o setor de TI", "Atenção!")
				return
			ENDIF

			if !PP7->( dbSeek(xFilial("PP7")+PP8->PP8_CODIGO) )					// Valdemir Rabelo 24/04/2020
				MsgInfo("Atendimento não encontrado na PP7, informe o setor de TI","Atenção!")
				Return
			endif

			If MsgYesno("Confirma Recebimento de Sol. Desenvolvimento ? ")
				// Ajuste realizado pela solicitação Lucas em 22/04/2020 - Valdemir
				cHisto := PP8->PP8_HIST +  "Docs de SD Recebidos EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
				aCampo := {{'PP8_HIST', cHisto},;
					{'PP8_DTRCSD', DDATABASE},;
					{'PP8_USRCSD', __cUSERID} }
				aCONDICAO := {{'PP8_FILIAL', PP8->PP8_FILIAL},;
					{'PP8_CODIGO', PP8->PP8_CODIGO} }
				if !AtuPP8(aCampo, aCONDICAO)
					MsgInfo("Não foi atualizado os Dados na Tabela: PP8. Informe o setor de TI", "Atenção!")
					Return
				endif

				// Valdemir Rabelo 24/04/2020 - Solicitação do Lucas
				RecLock("PP7",.F.)
				PP7->PP7_REJEIT := ''
				MsUnlock()

				/*
				RecLock("PP8",.F.)
				PP8->PP8_HIST  	 := PP8->PP8_HIST +  "Docs de SD Recebidos EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
				PP8->PP8_DTRCSD   := DDATABASE
				PP8->PP8_USRCSD   := CUSERNAME
				MSUNLOCK()
				*/
				IF 	SuperGetMV("ST_SDENVE",,.F.)
					_cEmail := SuperGetMV("ST_EMRCSD",,"gallo@rvgsolucoes.com.br")
					_cTipo := "Recebimento de documentacao"
					StEmail("Confirmacao de Recebimento de SD ",_cEmail,_cTipo)
				Endif
			Endif
		Else
			if !empty(PP8->PP8_QUDESE)
				MsgSTop(" Processo de SD ja Iniciado !!  Verifqiue !! "  )
			Else
				MsgSTop(" Processo de SD ja recebido !!  Verifqiue !! "  )
			Endif
		Endif

	ELSE

		MsgSTop(" Processo de SD ja Encerrado !! Verifique !! ")

	ENDIF

	RestArea( aAreaPP7 )
Return



/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³STFTA005  ºAutor  ³Microsiga           º Data ³  07/24/13   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³                                                            º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP                                                        º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FTA005SD
	Local cGetRec  := cUserName
	Local cGetData := dDatabase
	Local cGetHora := Space(10)
	Local cGetVen  := Space(15)
	Local cGetHora := Time()
	Local cGetPS   := Space(10)
	Local cGetPzDes:= ctod("")
	Local cGetConcl:= ctod("")
	Local cGetHrCon:= Space(08)
	Local oCBCampo
	Local nChange  := 0
	Local nCBCampo := 1
	Local cGetRestr:= Space(254)
	Local lRest    := .F.

	IF !EMPTY(PP8->PP8_USRCSD)

		IF  EMPTY(PP8->PP8_USENG)

			IF  !empty(PP8->PP8_INDESE)

				IF EMPTY(PP8_DTENG)

					If MsgYesno("Confirma Encerramento Sol. Desenvolvimento ? ")
						cCodOrig := PP8->PP8_PROD
						lOk := .F.

						DEFINE MSDIALOG oDlg FROM  140,000 TO 470,615 TITLE OemToAnsi("Encerramento de SD") PIXEL //"Substituicao de Componentes"
						DEFINE SBUTTON oBtn FROM 800,800 TYPE 5 ENABLE OF oDlg
						@ 046,006 TO 076,305 LABEL OemToAnsi("Produto Gerado") OF oDlg PIXEL //"Componente Original"
						@ 058,035 MSGET cCodOrig   F3 "SB1" Picture PesqPict("SG1","G1_COMP") Valid NaoVazio(cCodOrig) .And. ExistCpo("SB1",cCodOrig)  SIZE 105,09 OF oDlg PIXEL

						@ 060,013 SAY OemtoAnsi("Produto")   SIZE 24,7  OF oDlg PIXEL

						ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||(lOk:=.T.,oDlg:End())},{||(lOk:=.F.,oDlg:End())})

						If lOk

							DbSelectarea("SB1")
							DbsetOrder(1)
							Dbseek(xfilial("SB 1")+cCodOrig)

							DbSelectarea("PP8")
							recLock("PP8",.F.)
							PP8->PP8_HIST  	:= PP8->PP8_HIST +  "Engenharia Encerrada EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
							PP8->PP8_STATUS := "Z"
							PP8->PP8_DTENG 	:= DDATABASE
							PP8->PP8_USENG 	:= CUSERNAME
							PP8->PP8_PROD   := cCodOrig
							PP8->PP8_DESENH := SB1->B1_XDESENH //cCodOrig
							PP8->PP8_DTSDEN := DATE() //chamado 001776
							PP8->PP8_HRSDEN := TIME() //chamado 001776
							MSUNLOCK()

							// Situação Encerrado - Valdemir Ticket: 20200527002504
							//if PP8->( (PP8_DAPCLI <> ' ') .AND. (PP8_STATUS = 'E') .and. (PP8_DTENG <> ' ') .and. (PP8_PROD <> ' ') .AND. (PP8_DTRCSD <> ' ') )
								incRotei()
							//endif

							libenge()

							FWMsgRun(, {|| VldLeadComp(cCodOrig)},'Aguarde!',"Validando componentes do produto: "+cCodOrig)		// Valdemir Rabelo 17/06/2020
						EndIf

					Endif

				Else

					MsgSTop(" Processo de SD ja encerrado !! Verifique !!" )

				Endif

			ELSE

				MsgSTop(" Processo de SD nao Iniciado !! Verifique !!" )

			ENDIF

		ELSE

			MsgSTop(" Processo de SD ja Encerrado !! Verifique !!" )

		ENDIF
	ELSE
		MsgSTop(" Processo de SD nao Recebido !! Verifique !!" )

	ENDIF

Return

/*
Static Function ChangDes(lRest, nCBCampo, oRest, nChange)
		Local aCBO := {"Viavel","Inviavel","Viavel c/Restrição"}

		nChange := aScan(aCBO, {|X| X==nCBCampo})
		lRest := (nChange == 3)
		oRest:Refresh()

	Return
*/	


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³StEmail   ºAutor  ³Microsiga           º Data ³  26/07/13   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³ Envia Email de SD                                          º±±
	±±º          ³ baseado na funcao e-mail Criado por Giovanni Zago          º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP                                                        º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/

Static Function  StEmail(_cTitulo,_cEmail,_cTipo)

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= _cTitulo
	Local cFuncSent:= "StLibFinMail"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin

	DEFAULT _cEmail  := "gallo@rvgsolucoes.com.br"

	Aadd( _aMsg , { "SD Num: "          , PP8->PP8_CODIGO+ '-'+ PP8->PP8_ITEM } )
	Aadd( _aMsg , { "Ocorrencia: "    	, _cTipo  } )
	Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
	Aadd( _aMsg , { "Hora: "    		, time() } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do cabecalho do email                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do texto/detalhe do email                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nLin := 1 to Len(_aMsg)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		cMsg += '</TR>'
	Next
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do rodape do email                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'


	U_STMAILTES(_cEmail, "", _cAssunto, cMsg , "")

	RestArea(aArea)
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA005  ºAutor  ³Microsiga           º Data ³  08/14/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static function LibEnge

	Local nOpcA 	:= 0
	Local aPosObj   := {}
	Local aPosGet	:= {}
	Local aObjects  := {}
	Local aSize     := {}
	Local aArea     := GetArea()

	Local cCadastro := "Gerar Solicitacao de Desenvolvimento "
	Local cQuery    := ""
	Local cTrab     := "PP8"

	Local nUsado    := 0
	Local nGd1      := 0
	Local nGd2      := 0
	Local nGd3      := 0
	Local nGd4      := 0
	Local nGetLin   := 0
	Local nLoop     := 0
	Local nOpcGD	:= 0
	Local nSaveSx8  := GetSx8Len()
	Local aSize    := MsAdvSize()
	Local aObjects := {{  60, 100, .T., .T. }, { 100, 100, .T., .T. }  }

	Local aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	Local aPosObj := MsObjSize( aInfo, aObjects )

	Local aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{265,283}} )
	Local nGetLin := aPosObj[2,1] + 200
	Local _nfator := 25
	Local oOk		:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
	Local oNo		:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
	Local _nLin := 0
	Private aitens :={}

	PRIVATE aHEADER := {}
	PRIVATE aCOLS   := {}
	PRIVATE aHEADER1:= {}
	PRIVATE aCOLS1  := {}
	PRIVATE aGETS   := {}
	PRIVATE aTELA   := {}

	PRIVATE oGetDad1:= Nil
	PRIVATE oFolder	:= Nil
	PRIVATE aitens   := {}
	Dbselectarea("PP8")
	_cArea_pp8 := getarea()

	_cCodigo := PP8->PP8_CODIGO
	Dbsetorder(1)
	dbseek(xfilial("PP8")+_cCodigo )

	_oksd := .T.
	_aSds := {}
	Do While !eof()  .and. _cCodigo == PP8->PP8_CODIGO
		IF !EMPTY(PP8->PP8_DAPCLI) .and. EMPTY(PP8->PP8_DTENG)

			_oksd := .F.

		Else
			aadd(_aSds,{PP8->PP8_CODIGO + " " + PP8->PP8_ITEM,PP8->PP8_PROD})
		Endif

		Dbskip()
	Enddo

	if _oksd

		_cEmail    := supergetmv("ST_UNCENGE",,"gallo@rvgsolucoes.com.br")

		_cAssunto  := "Conclusao de Desenvolvimento - Engenharia"

		if len(_aSds) > 0

			_aMsg := {}

			Aadd( _aMsg , { "SD Num: "          , PP8->PP8_CODIGO } )
			Aadd( _aMsg , { "Ocorrencia: "    	, "SD Concluidas - Engenharia"  } )
			Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
			Aadd( _aMsg , { "Hora: "    		, time() } )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Definicao do cabecalho do email                                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cMsg := ""
			cMsg += '<html>'
			cMsg += '<head>'
			cMsg += '<title> Unicom' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
			cMsg += '</head>'
			cMsg += '<body>'
			//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
			cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Definicao do texto/detalhe do email                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For _nLin := 1 to Len(_aMsg)
				IF (_nLin/2) == Int( _nLin/2 )
					cMsg += '<TR BgColor=#B0E2FF>'
				Else
					cMsg += '<TR BgColor=#FFFFFF>'
				EndIF
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '</TR>'
			Next
			cMsg += '<tr>'
			cMsg += '</tr>'
			For _nLin := 1 to Len(_aSds)
				IF (_nLin/2) == Int( _nLin/2 )
					cMsg += '<TR BgColor=#B0E2FF>'
				Else
					cMsg += '<TR BgColor=#FFFFFF>'
				EndIF
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aSds[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aSds[_nLin,2] + ' </Font></TD>'
				cMsg += '</TR>'
			Next
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Definicao do rodape do email                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cMsg += '</Table>'
			cMsg += '<P>'
			cMsg += '<Table align="center">'
			cMsg += '<tr>'
			cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">(Unicom)</td>'
			cMsg += '</tr>'
			cMsg += '</Table>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '</body>'
			cMsg += '</html>'


			U_STMAILTES(_cEmail, "", _cAssunto, cMsg , "")


			MsgStop("Liberacao para SD efetuada com sucesso")//"Foi criado o produto " + _cCodProd + ", e tambem a SD referente a ele !")

		Endif


	Endif
Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA005  ºAutor  ³Microsiga           º Data ³  24/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function FTA005ID

	Local cGetMotivo  := Space(80)
	Local nOpcao      := 0

	Local lSaida      := .f.
	Local _aMotRej    := {}
	Local _cItem      := Space(30)


	IF  empty(PP8->PP8_DTENG)

		IF  !empty(PP8->PP8_USRCSD)

			IF EMPTY(PP8_QUDESE)

				If MsgYesno("Confirma Inicio do Desenvolvimento ? ")

					RecLock("PP8",.F.)  //Chamado 001378
					PP8->PP8_HIST  	 := PP8->PP8_HIST +  "Desenvolvimento iniciado EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
					PP8->PP8_INDESE   := DDATABASE
					PP8->PP8_QUDESE   := CUSERNAME
					MSUNLOCK()

					// Valdemir Rabelo 17/06/2020 - ticket: 20200403001451
					dbSelectArea("Z77")
					dbSetOrder(1)
					dbGotop()
					While !Eof()
						AADD(_aMotRej, ALLTRIM(Z77->Z77_CODIGO)+' - '+ALLTRIM(Z77->Z77_DESCRI))
						dbSkip()
					EndDo

					Do While !lSaida
						nOpcao := 0

						Define msDialog oDxlg Title "Classificação" From 10,10 TO 260,600 Pixel


						@ 010,010 Say "Classificação:"   COLOR CLR_HBLUE  Of oDxlg Pixel
						@ 020,010 COMBOBOX _cItem ITEMS _aMotRej SIZE 110,50 Of oDxlg Pixel

						DEFINE SBUTTON FROM 102,130 TYPE 1 ACTION IF(!(Empty(Alltrim(_cItem))),(lSaida:=.T.,nOpcao:=1,oDxlg:End()),msgInfo("Classificação não preenchido","Atenção")) ENABLE OF oDxlg

						Activate dialog oDxlg centered

					EndDo

					If nOpcao == 1

						RecLock("PP8",.F.)
						//PP8->PP8_HIST  	 := PP8->PP8_HIST +  "Desenvolvimento iniciado EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
						//PP8->PP8_INDESE   := DDATABASE
						//PP8->PP8_QUDESE   := CUSERNAME
						PP8->PP8_CLASSI   := Alltrim(_cItem)
						MSUNLOCK()

					EndIf



				Endif

			Else

				MsgSTop(" Desenho ja iniciado !! Verifique !!" )

			Endif

		Else

			MsgSTop(" Processo de SD nao recebido, verifique !!" )

		Endif


	Else

		MsgSTop(" Processo de SD ja Encerrado !! Verifique !! ")

	endif

RETURN


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³STFTA005  ºAutor  ³Microsiga           º Data ³  08/16/13   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³                                                            º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP                                                        º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/

Static Function FTA005SL
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= "Conclusao SD"
	Local cFuncSent:= "StLibFinMail"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin

	Local _cEmail := SuperGetMV("ST_EMFIMSD",,"gallo@rvgsolucoes.com.br")

	Local _nPosItem := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP8_ITEM" })
	Local nOpcA 	:= 0
	Local aPosObj   := {}
	Local aPosGet	:= {}
	Local aObjects  := {}
	Local aSize     := {}
	Local aArea     := GetArea()

	Local cCadastro := "Gerar Orcamentos "
	Local cQuery    := ""
	Local cTrab     := "PP8"

	Local nUsado    := 0
	Local nGd1      := 0
	Local nGd2      := 0
	Local nGd3      := 0
	Local nGd4      := 0
	Local nGetLin   := 0
	Local nLoop     := 0
	Local nOpcGD	:= 0
	Local nSaveSx8  := GetSx8Len()
	Local aSize    := MsAdvSize()
	Local aObjects := {{  60, 100, .T., .T. }, { 100, 100, .T., .T. }  }

	Local aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	Local aPosObj := MsObjSize( aInfo, aObjects )

	Local aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{265,283}} )
	Local nGetLin := aPosObj[2,1] + 200
	Local _nfator := 25
	Local oOk		:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
	Local oNo		:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
	Local __nCount := 0
	Private aitens :={}

	PRIVATE aHEADER := {}
	PRIVATE aCOLS   := {}
	PRIVATE aHEADER1:= {}
	PRIVATE aCOLS1  := {}
	PRIVATE aGETS   := {}
	PRIVATE aTELA   := {}

	PRIVATE oGetDad1:= Nil
	PRIVATE oFolder	:= Nil
	PRIVATE aitens   := {}

	Dbselectarea("PP8")
	Dbsetorder(1)
	dbseek(xfilial("PP8")+PP7->PP7_CODIGO)

	SA1->(dbsetorder(1))
	SA1->(dbseek(xfilial("SA1")+PP7->PP7_CLIENTE+PP7->PP7_LOJA))


	Dbselectarea("PP8")
	Dbsetorder(1)
	dbseek(xfilial("PP8")+PP7->PP7_CODIGO)
	Do While !eof()  .and. PP7->PP7_CODIGO == PP8->PP8_CODIGO
		IF EMPTY(PP8->PP8_NUMORC)

			aadd(aitens,{" ",pp8_item,pp8_descr,pp8_dtnec})

		Endif
		Dbskip()
	Enddo

	if len(aitens) == 0

		Msgstop("Nao Existem itens a Liberar para Vendas ")

	else

		DEFINE MSDIALOG oDlg1 TITLE cCadastro From aSize[7],00 To aSize[6] , aSize[5] OF oMainWnd PIXEL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define as posicoes da Getdados a partir do folder    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nGd1 	:= 2
		nGd2 	:= 2
		nGd3 	:= aSize[3]-50  //aPosObj[2,3]*2//-aPosObj[2,2] // aPosObj[2,3]-aPosObj[2,1]-15
		nGd4 	:= aSize[4]  //aPosObj[2,4]-100 //aPosObj[2,4]-aPosObj[2,2]-4

		_atit_cab1:= 	{"","Item","Descricao","Dt. Necessidade"}

		oListBox2 := TWBrowse():New( aPosObj[1,1],aPosObj[2,2]+_nfator,nGd3,nGd4                              ,,_atit_cab1, ,oDlg1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		oListBox2:AddColumn(TCColumn():New( " "  		   	    ,{|| iif(aItens[ oListBox2:nAt, 01 ] ='X',oOk,oNo)  }, "@c",nil,nil,nil,010,.T.,.T.,nil,nil,nil,.T.,nil))
		oListBox2:AddColumn(TCColumn():New( "Item"  			,{|| aItens[ oListBox2:nAt, 02 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Descricao"  		,{|| aItens[ oListBox2:nAt, 03 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
		oListBox2:AddColumn(TCColumn():New( "Data"  			,{|| aItens[ oListBox2:nAt, 04 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))

		oListBox2:SetArray(aitens)
		oListBox2:bLine 		:= {|| {	if(aItens[ oListBox2:nAt, 01 ] = 'X',oOk,oNo), aItens[ oListBox2:nAT, 02 ], aItens[ oListBox2:nAT, 03 ], aItens[ oListBox2:nAT, 04]   } }
		oListBox2:blDblClick 	:= {||  aItens[ oListBox2:nAt, 01 ] := if(aItens[ oListBox2:nAt, 01 ] = 'X',' ','X') ,oListBox2:refresh() }

		@ 030,2 BTNBMP oBtn1 RESOURCE "SELECTALL" 		SIZE 40,40 ACTION _mAll(1)  MESSAGE "Marca Todos "
		@ 065,2 BTNBMP oBtn2 RESOURCE "UNSELECTALL" 	SIZE 40,40 ACTION _mAll(2)  MESSAGE "Desmarca Todos "


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ao confirmar, simula a mudanca de folder para atualizar os arrays necessarios ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1, {||nOpcA := 1 ,oDlg1:End()} ,{||oDlg1:End()},, )

		If  nOpcA == 1

			_aorcs := {}
			_cOrcs := ""

			For __ncount := 1 to len(aitens)

				if aItens[__ncount , 01 ] = 'X'

					Dbselectarea("PP8")
					PP8->(dbsetorder(1))
					PP8->(dbseek(xfilial("PP8")+PP7->PP7_CODIGO + aitens[__ncount ,2]))

					IN_PEDIDO := GetSX8Num("SCJ","CJ_NUM")
					ConfirmSX8()

					_cOrcs += IN_PEDIDO + chr(13)+ chr(10)
					aadd(_aorcs,{IN_PEDIDO,PP8->PP8_DESCR})
					RecLock("SCJ",.T.)

					SCJ->CJ_FILIAL  := xFilial("SCJ")
					SCJ->CJ_NUM     := IN_PEDIDO
					SCJ->CJ_EMISSAO := dDataBase
					SCJ->CJ_XDSCUNC := PP8->PP8_DESCR
					SCJ->CJ_CLIENTE := PP7->PP7_CLIENTE
					SCJ->CJ_LOJA    := PP7->PP7_LOJA
					SCJ->CJ_CLIENT  := PP7->PP7_CLIENTE
					SCJ->CJ_LOJAENT := PP7->PP7_LOJA
					SCJ->CJ_STATUS  := "A"
					SCJ->CJ_VALIDA  := dDataBase+30
					SCJ->CJ_CONDPAG := IF(!EMPTY(SA1->A1_COND),SA1->A1_COND,'001')
					SCJ->CJ_TIPLIB  := "2"
					SCJ->CJ_XNOTA   := PP8->PP8_NOTA
					SCJ->CJ_XUNICOM := PP8->(PP8_CODIGO+PP8_ITEM)
					SCJ->CJ_XOBRA 	:= PP7->PP7_OBRA
					SCJ->CJ_XENDOBR := PP7->PP7_ENDOBR
					SCJ->CJ_XCONTAT := PP7->PP7_CONTAT
					SCJ->CJ_TXMOEDA := 1

					MsUnlock()

					dbselectarea("SCK")
					RecLock("SCK",.T.)
					SCK->CK_FILIAL  := SCJ->CJ_FILIAL
					SCK->CK_NUM     := IN_PEDIDO
					SCK->CK_ITEM    := "01"
					SCK->CK_PRODUTO := "UNICOM"
					SCK->CK_DESCRI  := PP8->PP8_DESCR
					SCK->CK_QTDVEN  := 1
					SCK->CK_PRCVEN  := 1
					SCK->CK_VALOR   := PP8->PP8_QUANT
					SCK->CK_LOCAL   := "01"
					SCK->CK_UM      := "PC"
					SCK->CK_CLIENTE := PP7->PP7_CLIENTE
					SCK->CK_LOJA    := PP7->PP7_LOJA
					SCK->CK_DESCONT := 0
					SCK->CK_VALDESC := 0
					SCK->CK_PRUNIT  := 1
					SCK->CK_FILVEN  := SCJ->CJ_FILIAL
					SCK->CK_FILENT  := SCJ->CJ_FILIAL
					SCK->CK_TES     := "501"

					MsUnlock()

					Dbselectarea("PP8")
					RecLock("PP8",.F.)
					PP8->PP8_NUMORC := IN_PEDIDO
					PP8->PP8_HIST := PP8->PP8_HIST + "ORCAMENTO " + IN_PEDIDO +" GERADO EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10) + REPLICATE("-",80) + chr(13) + chr(10)

					MsUnlock()

				Endif

			Next __nCount

			if !empty(_cOrcs)

				Aadd( _aMsg , { "SD Num: "          , PP8->PP8_CODIGO+ '-'+ PP8->PP8_ITEM } )
				Aadd( _aMsg , { "Ocorrencia: "    	, "Liberacao para Orcamento"  } )
				Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
				Aadd( _aMsg , { "Hora: "    		, time() } )

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do cabecalho do email                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cMsg := ""
				cMsg += '<html>'
				cMsg += '<head>'
				cMsg += '<title> Unicom' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
				cMsg += '</head>'
				cMsg += '<body>'
				//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
				cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do texto/detalhe do email                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For _nLin := 1 to Len(_aMsg)
					IF (_nLin/2) == Int( _nLin/2 )
						cMsg += '<TR BgColor=#B0E2FF>'
					Else
						cMsg += '<TR BgColor=#FFFFFF>'
					EndIF
					cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
					cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
					cMsg += '</TR>'
				Next
				cMsg += '<tr>'
				cMsg += '</tr>'
				For _nLin := 1 to Len(_aOrcs)
					IF (_nLin/2) == Int( _nLin/2 )
						cMsg += '<TR BgColor=#B0E2FF>'
					Else
						cMsg += '<TR BgColor=#FFFFFF>'
					EndIF
					cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aorcs[_nLin,1] + ' </Font></B></TD>'
					cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aorcs[_nLin,2] + ' </Font></TD>'
					cMsg += '</TR>'
				Next
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do rodape do email                                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cMsg += '</Table>'
				cMsg += '<P>'
				cMsg += '<Table align="center">'
				cMsg += '<tr>'
				cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
				cMsg += '</tr>'
				cMsg += '</Table>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '</body>'
				cMsg += '</html>'


				U_STMAILTES(_cEmail, "", _cAssunto, cMsg , "")

				MsgStop("Foram gerados os orcamentos"  + chr(13)+ chr(10)+ chr(13)+ chr(10)+_cOrcs)

			Endif

		Endif

	Endif


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³STFTA005  ºAutor  ³Microsiga           º Data ³  11/01/13   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³                                                            º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP                                                        º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/


User Function FTA005HS()

	_cHist := PP8->PP8_HIST//MemoRead(PP8->PP8_HIST)
	@ 000, 000 TO 430, 550 DIALOG oDlgX1 TITLE 'Historico de Unicom'
	@ 005,005 Get _cHist  Size 267,180 MEMO Object oMemo  //when .f.
	@ 192,235 BMPBUTTON TYPE 1 ACTION Close(oDlgX1)

	ACTIVATE DIALOG oDlgX1 CENTERED

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA005  ºAutor  ³Microsiga           º Data ³  11/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function FTA005OB()
	_cOpcao := 0
	_cObs := PP8->PP8_HSTENG
	@ 000, 000 TO 430, 550 DIALOG oDlgX1 TITLE 'Observacoes da Engenharia'
	@ 005,005 Get _cObs   Size 267,180 MEMO Object oMemo

	@ 192,190 BMPBUTTON TYPE 2 ACTION Close(oDlgX1)
	@ 192,235 BMPBUTTON TYPE 1 ACTION  Eval( { || _cOpcao := 1 ,  Close(oDlgX1) }  )

	ACTIVATE DIALOG oDlgX1 CENTERED

	if _copcao == 1
		RecLock("PP8",.F.)
		PP8->PP8_HSTENG :=  _cObs
		MsUnlock()
	Endif
return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA005  ºAutor  ³Microsiga           º Data ³  07/24/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function FTA005EC

	IF !EMPTY(PP8_DTENG)

		If MsgYesno("Confirma Estorno do Encerramento Sol. Desenvolvimento ? ")
			cCodOrig := space(15)
			lOk := .t.
			If lOk

				DbSelectarea("PP8")
				recLock("PP8",.F.)
				PP8->PP8_HIST  	:= PP8->PP8_HIST +  "Engenharia Estornou Encerramento EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
				PP8->PP8_STATUS := "E"
				PP8->PP8_DTENG 	:= ctod("  /  /   ")
				PP8->PP8_USENG 	:= " "
				PP8->PP8_QUDESE := " "
				PP8->PP8_PROD   := cCodOrig
				PP8->PP8_DESENH := cCodOrig
				MSUNLOCK()
				if  !empty(PP8->PP8_PEDVEN)

					DbSelectArea('SC6')
					DbSetOrder(1) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
					DbSeek(xFilial("SC6")+PP8->PP8_PEDVEN)
					IF !Eof()
						RecLock("SC6",.f.)
						C6_PRODUTO :=  cCodOrig
						Msunlock()
					Endif

				endif

				// Valdemir Rabelo
				dbSelectArea("Z67")
				dbSetOrder(1)
				IF dbSeek(xFilial("Z67")+PP8->PP8_CODIGO+PP8->PP8_ITEM)
					// Valdemir Rabelo
					RecLock("Z67",.F.)
					Z67->Z67_RECPOR := cGetRec
					Z67->Z67_DTPOR  := cGetData
					Z67->Z67_HRPOR  := cGetHora
					Z67->Z67_DESENV := cValToChar(nChange)
					Z67->Z67_RESTIC := cGetRestr
					Z67->Z67_CPDPRD := cCodOrig
					Z67->Z67_CODVND := cGetVen
					Z67->Z67_PS     := cGetPS
					Z67->Z67_PRZDES := cGetPzDes
					Z67->Z67_CONCLU := cGetConcl
					Z67->Z67_HSCONC := cGetHrCon
					MsUnlock()
				ELSE
					MSGINFO("Capa de solicitação não encontrada","Atenção!")
				ENDIF

			EndIf

		Endif

	Else

		MsgSTop(" Processo de SD ainda nao encerrado !! Verifique !! " )


	Endif


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³STFTA005  ºAutor  ³Microsiga           º Data ³  04/10/14   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³                                                            º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP                                                        º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/

User Function FTA005OR

	Local   aSize    := MsAdvSize()
	Local   aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	Local   aObjects := {{  60, 100, .T., .T. }, { 100, 100, .T., .T. }  }
	Local   aPosObj := MsObjSize( aInfo, aObjects )

	Private aitens   := {}

	If !EMPTY(Alltrim(PP8_DTENG))
		msginfo("SD Já Finalizada!!!!")
		return()
	EndIf
	Dbselectarea('SCJ')
	SCJ->(dbsetorder(1))
	Dbseek(xfilial("SCJ") + PP8->PP8_NUMORC )

	Dbselectarea('SCK')
	SCK->(dbsetorder(1))
	Dbseek(xfilial("SCK") + SCJ->CJ_NUM )
	_cCaixa := ""
	Do while !eof() .and. SCJ->CJ_NUM == SCK->CK_NUM

		Dbselectarea("SB1")
		Dbseek(xfilial("SB1")+SCK->CK_PRODUTO)

		AADD( aitens , {SCK->CK_PRODUTO,SCK->CK_DESCRI,TRANSFORM(SCK->CK_QTDVEN,'@e 999,999,999'),SCK->CK_PRCVEN,SCK->CK_VALOR})

		Dbselectarea('SCK')
		Dbskip()

	Enddo


	DEFINE MSDIALOG oDlg2 TITLE 'Gerar pre-estrutura' From aSize[7],00 To aSize[6] , aSize[5] OF oMainWnd PIXEL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define as posicoes da Getdados a partir do folder    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nGd1 	:= 2
	nGd2 	:= 2
	nGd3 	:= aSize[3]-50
	nGd4 	:= aSize[4]-40
	_atam_cab1:= 	{55,255,55 }

	@ 05,020 SAY "Estrutura Base"
	IF !EMPTY(SCJ->CJ_XESBAS)
		@ 05,070 SAY SCJ->CJ_XESBAS + " " + posicione("SB1",1,xfilial("SB1")+SCJ->CJ_XESBAS,"B1_DESC") SIZE 235,15
	ELSE
		@ 05,070 SAY "Nao Usado" SIZE 235,15
	ENDIF
	_atit_cab1:= 	{"Produto","Descricao","Quantidade"}

	oListBox2 := TWBrowse():New( aPosObj[1,1]+20,aPosObj[2,2]+40,nGd3,nGd4                              ,,_atit_cab1,_atam_cab1 ,oDlg2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

	oListBox2:AddColumn(TCColumn():New( "Produto"  				,{|| aItens[ oListBox2:nAt, 01 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
	oListBox2:AddColumn(TCColumn():New( "Descricao"  			,{|| aItens[ oListBox2:nAt, 02 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
	oListBox2:AddColumn(TCColumn():New( "Quantidade"  			,{|| aItens[ oListBox2:nAt, 03 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))

	oListBox2:SetArray(aitens)
	oListBox2:bLine 		:= {|| {	  aItens[ oListBox2:nAT, 01 ], aItens[ oListBox2:nAT, 02 ], aItens[ oListBox2:nAT, 03]   } }

	@ 035,10 BTNBMP oBtn1  RESOURCE "FORM"  		SIZE 40,40 ACTION _mGeraPre()  MESSAGE "Gera Pre Estrutura "


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ao confirmar, simula a mudanca de folder para atualizar os arrays necessarios ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2, {||nOpcA := 1 ,oDlg2:End()} ,{||oDlg2:End()},, )

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³STFTA005  ºAutor  ³Microsiga           º Data ³  04/10/14   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³                                                            º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP                                                        º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/


Static Function 	_mGeraPre
	lOCAL _nCount := 0
	_cCodProd := space(15)
	lOk := .F.
	DEFINE MSDIALOG oDlg FROM  140,000 TO 350,615 TITLE OemToAnsi("Geracao de Pre-Estrutura") PIXEL
	@ 026,006 TO 056,305 LABEL OemToAnsi("Produto Gerado") OF oDlg PIXEL
	@ 038,035 MSGET _cCodProd   F3 "SB1" Picture PesqPict("SG1","G1_COMP") Valid NaoVazio(_cCodProd) .And. ExistCpo("SB1",_cCodProd)  SIZE 105,09 OF oDlg PIXEL
	@ 040,013 SAY OemtoAnsi("Produto")   SIZE 24,7  OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||(lOk:=.T.,oDlg:End())},{||(lOk:=.F.,oDlg:End())})
	If lOk

		DbSelectarea("SB1")
		DbsetOrder(1)
		Dbseek(xfilial("SB1")+_cCodProd)
		DbSelectArea("SGG")
		DbSeek(xFilial("SGG")+_cCodProd)
		If Eof()
			For _nCount := 1 to len(aitens)
				RecLock("SGG",.T.)
				SGG->GG_FILIAL  := xFilial("SG1")
				SGG->GG_COD     := _cCodProd
				SGG->GG_COMP    :=  aitens[_ncount,1]
				SGG->GG_TRT     := strzero(_ncount,3)
				SGG->GG_QUANT   := iif(valtype(aitens[_ncount,3])='N' .And. aitens[_ncount,3]>0,aitens[_ncount,3],1)
				SGG->GG_PERDA   := 0
				SGG->GG_OBSERV  := "REF UNICOM " + SCJ->CJ_XUNICOM
				SGG->GG_FIXVAR  := "V"
				SGG->GG_INI     := CTOD('01/01/2001')
				SGG->GG_FIM     := CTOD('01/01/2049')
				SGG->GG_GROPC   := ""
				SGG->GG_OPC     := ""
				SGG->GG_STATUS  := "1"

				Msunlock()
			Next _nCount
		Endif

		RecLock("PP8",.F.)
		PP8->PP8_PROD := _cCodProd
		Msunlock()

		MsgStop('Pre-estrutura Criada !')

	Endif

Return






/*====================================================================================\
|Programa  | Sb2Saldo            | Autor | GIOVANI.ZAGO          | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  Retorna saldo do sb2(custo)                                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | Sb2Saldo                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------*
User Function STFT5Sld(_cProd)
	*---------------------------*
	Local _aArea := GetArea()
	Local cAliasLif  := 'TMPB2'
	Local cQuery     := ' '
	Local  _nQut    := 0
	Local  _nVal    := 0
	Local  _nCust    := 0
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+_cProd))
	
	if !SB1->B1_CLAPROD = 'I'
		
		If SB1->B1_XPCSTK  <> 0
			
			_nCust := SB1->B1_XPCSTK
			
		Else
			cQuery := " SELECT B2_COD, B2_LOCAL,B2_FILIAL,B2_QATU,B2_VATU1 ,B2_CMFIM1
			cQuery += " FROM "+RetSqlName("SB2")+" SB2 "
			cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
			cQuery += " AND   SB2.B2_COD   = '"+SB1->B1_COD+"'"
			cQuery += " AND   SB2.B2_LOCAL = '"+SB1->B1_LOCPAD+"'"
			cQuery += " AND   SB2.B2_FILIAL= '"+xFilial("SB2")+"'"
			cQuery += " ORDER BY SB2.R_E_C_N_O_
			
			cQuery := ChangeQuery(cQuery)
			
			If Select(cAliasLif) > 0
				(cAliasLif)->(dbCloseArea())
			EndIf
			
			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
			dbSelectArea(cAliasLif)
			If  Select(cAliasLif) > 0
				(cAliasLif)->(dbgotop())
				While (cAliasLif)->(!Eof())
					_nCust  := (cAliasLif)->B2_CMFIM1
					(cAliasLif)->(DbSkip())
				End
			EndIf
			
			
			If Select(cAliasLif) > 0
				(cAliasLif)->(dbCloseArea())
			EndIf
			
			If  !(_nCust > 0) .and. SB1->B1_CLAPROD <> 'F'
				
				cQuery := " SELECT D1_VUNIT
				cQuery += ' "SALDO"
				cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
				cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
				cQuery += " AND SD1.D1_FILIAL = '"+xFilial("SD1")+"'"
				cQuery += " AND SD1.D1_COD = '"+SB1->B1_COD+"'"
				cQuery += " AND SD1.D1_FORNECE <> '005764'
				cQuery += " AND SD1.D1_TIPO = 'N'
				cQuery += " ORDER BY   SD1.R_E_C_N_O_ DESC
				
				
				cQuery := ChangeQuery(cQuery)
				
				If Select(cAliasLif) > 0
					(cAliasLif)->(dbCloseArea())
				EndIf
				
				dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
				dbSelectArea(cAliasLif)
				If  Select(cAliasLif) > 0
					(cAliasLif)->(dbgotop())
					_nCust  := (cAliasLif)->SALDO
				EndIf
				
				
				
				If Select(cAliasLif) > 0
					(cAliasLif)->(dbCloseArea())
				EndIf
				
			EndIf
		Endif
	ElseIf   SB1->B1_CLAPROD = 'I'
		
		cQuery := " SELECT D1_VUNIT
		cQuery += ' "SALDO"
		cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
		cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
		// cQuery += " AND SD1.D1_FILIAL = '"+xFilial("SD1")+"'"    //Giovani Zago chamado 000451 28/04/14
		cQuery += " AND SD1.D1_COD = '"+SB1->B1_COD+"'"
		cQuery += " AND SD1.D1_FORNECE <> '005764'
		cQuery += " AND SD1.D1_TIPO = 'N'
		cQuery += " ORDER BY   SD1.R_E_C_N_O_ DESC
		
		
		cQuery := ChangeQuery(cQuery)
		
		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf
		
		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
		dbSelectArea(cAliasLif)
		If  Select(cAliasLif) > 0
			(cAliasLif)->(dbgotop())
			_nCust  := (cAliasLif)->SALDO
		EndIf
		
		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf
		
	EndIf
	
	RestArea(_aArea)
Return(round(_nCust,2))







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA005  ºAutor  ³Microsiga           º Data ³  04/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FTA005PR


	Local oReport
	Private aItens[6]
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:= ReportDef()
	oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTA005  ºAutor  ³Microsiga           º Data ³  09/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()

	Local aOrdem    := {}
	Local cPictQt   := PesqPict("SB2","B2_QATU")
	Local nTamQt    := TamSX3('B2_QATU')[1]
	Local oCabec
	Local oFaltas
	Private cAliasTRB := "TRB"


	oReport:= TReport():New("FTA005OPR","Relatorio de Itens do Orcamento", , {|oReport| ReportPrint(oReport)},"O relatorio irá listar Itens do OrcamentoK ")

	oSection1 := TRSection():New(oReport,"Relatorio de Itens do Orcamento",{},aOrdem)
	oSection1:SetTotalInLine(.F.)

	TRCell():New(oSection1,'B1_COD'    	, ,'Produto'	,		/*Picture*/		,15,/*lPixel*/, {|| aItens[1] } )
	TRCell():New(oSection1,'B1_DESC' 	, ,'Descricao'	,		/*Picture*/		,35,/*lPixel*/, {|| aItens[2] } )
	TRCell():New(oSection1,'B1_TIPO' 	, ,'Tipo' 		,		/*Picture*/		,04,/*lPixel*/, {|| aItens[3] })
	TRCell():New(oSection1,'B1_GRUPO' 	, ,'Grupo'		,		/*Picture*/		,05,/*lPixel*/, {|| aItens[4] })
	TRCell():New(oSection1,'CK_QTDVEN'	, ,'Quantidade'	, "@E 999999,999.99"	,14,/*lPixel*/, {|| aItens[5] },,,"RIGHT")
	TRCell():New(oSection1,'CK_OBS'	, ,'Observação'	, /*Picture*/	          ,35,/*lPixel*/, {|| aItens[6] },,,"RIGHT")
Return(oReport)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³ReportPrint ³ Autor ³ RVG                 ³ Data ³05/04/13  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³A funcao estatica ReportPrint devera ser criada para todos  ³±±
	±±³          ³os relatorios que poderao ser agendados pelo usuario.       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Nenhum                                                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³       			                                          ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,aOrdem,cAliasTRB)

	Local oSection1    := oReport:Section(1)
	Local nOrdem       := oSection1:GetOrder()

	oSection1:Init()

	Dbselectarea('SCJ')
	SCJ->(dbsetorder(1))
	Dbseek(xfilial("SCJ") + PP8->PP8_NUMORC )

	oReport:PrintText(  "Unicom: "     +PP8->PP8_CODIGO + "-" + PP8->PP8_ITEM + "-" + PP8->PP8_DESCR)
	oReport:SkipLine()

	Dbselectarea('SCK')
	SCK->(dbsetorder(1))
	Dbseek(xfilial("SCK") + SCJ->CJ_NUM )
	Do while !eof() .and. SCJ->CJ_NUM == SCK->CK_NUM

		Dbselectarea("SB1")
		Dbseek(xfilial("SB1")+SCK->CK_PRODUTO)

		aitens[1] :=  SCK->CK_PRODUTO
		aitens[2] :=  SCK->CK_DESCRI
		aitens[3] :=  SB1->B1_TIPO
		aitens[4] :=  SB1->B1_GRUPO
		aitens[5] :=  SCK->CK_QTDVEN
		aitens[6] :=  SCK->CK_OBS
		oSection1:PrintLine()

		If oReport:Cancel()
			Exit
		EndIf

		dbSelectArea("SCK")
		DbSkip()

	Enddo

	oSection1:Finish()

Return


/*/{Protheus.doc} User Function FTA005D1
    (long_description)
    ROTINA PARA SER INFORMADO O ROTEIRO
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 18/09/2019
    @example
    (examples)
/*/
User Function FTA005D1()
	Local aArea001 := GetArea()
	Local aPerg    := {}
	Local aRetor   := {}

	if Empty(PP8->PP8_DESENH)
		MSGINFO( "Só pode ser informado o roteiro, quando se tem o código do desenho.", "Atenção!" )
		Return
	elseif !EMPTY(PP8_DTENG) .AND. !EMPTY(PP8_ROTEIR)
		MSGINFO( "Registro já Encerrado e informado roteiro.", "Atenção!" )
		Return
	Endif

	aAdd(aPERG, {3, "Foi criado roteiro",1, {"N-Não     ", "S-SIM     "}, 50, "!empty(mv_par01)",.T.})
	If ParamBox(aPerg, "Informe o Roteiro", @aRetor,,,,,,,, .F., .F.)
		RecLock("PP8", .F.)
		PP8->PP8_ROTEIR := iif(MV_PAR01==2,"S","")
		MsUnlock()
	Endif

	RestArea( aArea001 )

Return



//--------------------------------------------------------------
/*{Protheus.doc} TelaDtEntD
Description
	Rotina para apresentar a data de entreda do desenho
@author Valdemir José - valdemir.rabelo@sigamat.com.br
@since 06/12/2019
*/
//--------------------------------------------------------------
User Function TelaDtEntD()
	Local oBTOK		   := Nil
	Local oBTSair	   := Nil
	Local oGetDtEntDes := Nil
	Local dGetDtEntDes := PP8->PP8_DTPRES
	Local oPanel1      := Nil
	Local oSayTitulo   := Nil
	Local cUsuPer 	   := SuperGetMV('ST_USUFT05',.F.,"000690/000616/000731")
	Static oDlg1       := Nil

	if !(__cUserID $ cUsuPer)
		FwMsgRun(,{|| Sleep(2000)},"Informativo","Usuário não tem permissão para informar a data de entrega do desenho.")
		Return
	Endif

	if (EMPTY(PP8->PP8_DAPCLI) .AND. PP8->PP8_STATUS=='E' )
		MsgInfo("O registro selecionado não no status para informar data. Só pode ser "+CRLF+;
			"informado a data de entrega, para registros liberados.","Atenção!")
		Return
	Endif

	DEFINE MSDIALOG oDlg1 TITLE "Informe Data Entrega do Desenho" FROM 000, 000  TO 200, 330 COLORS 0, 16777215 PIXEL

	@ 011, 009 MSPANEL oPanel1 SIZE 145, 050 OF oDlg1 COLORS 0, 12910591 RAISED
	@ 023, 011 SAY oSayTitulo PROMPT "Data Entrega Desenho" SIZE 061, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
	@ 022, 075 MSGET oGetDtEntDes VAR dGetDtEntDes VALID VldDtEnt(dGetDtEntDes) SIZE 048, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
	@ 076, 037 BUTTON oBTOK 	PROMPT "OK" 	SIZE 037, 012 OF oDlg1 ACTION (ConfDTDes(dGetDtEntDes), oDLG1:End()) PIXEL
	@ 076, 080 BUTTON oBTSair 	PROMPT "Sair" 	SIZE 037, 012 OF oDlg1 ACTION oDLG1:End() PIXEL

	ACTIVATE MSDIALOG oDlg1 CENTERED

Return .t.


//--------------------------------------------------------------
/*{Protheus.doc} ConfDTDes
Description
	Rotina para confirmação dos Dados
@author Valdemir José - valdemir.rabelo@sigamat.com.br
@since 06/12/2019
*/
//--------------------------------------------------------------
Static Function ConfDTDes(dGetDtEntDes)
	Local aArea     := GetArea()
	Local lPerg     := (!Empty(PP8->PP8_DTPRES))
	Local lResult   := .T.
	Local aWFDes    := {}
	Local aRegis    := {}
	Local _cEmail   := SuperGetMV("ST_EMLUDES",.F.,"filipe.nascimento@steck.com.br,lucas.machado@steck.com.br,mirla.miguins@steck.com.br,daniel.denez@steck.com.br,jose.junior@steck.com.br,felipe.silva@steck.com.br")

	if lPerg
		lResult := MsgYesNo("Atenção!","Deseja realmente atualizar a Data de Entrega do Desenho?")
	Endif

	if lResult
		dbSelectArea("PP7")
		dbSetOrder(1)
		dbSeek(PP8->PP8_FILIAL+PP8->PP8_CODIGO)
		dbSelectArea("PP8")

		RecLock("PP8",.F.)
		PP8->PP8_DTPRES := dGetDtEntDes
		MsUnlock()
		FwMsgRun(,{|| Sleep(2000)},"Informativo","Data Entrega do Desenho, Atualizada com sucesso.")
		// Preparando Envio WF
		Aadd( aRegis, {"Atendimento: ", PP8->PP8_CODIGO }  )
		Aadd( aRegis, {"Item: "       , PP8->PP8_ITEM }  )
		//Aadd( aRegis, {"Produto"   , PP8->PP8_PROD }  )
		//Aadd( aRegis, {"Descrição" , PP8->PP8_DESCR}  )
		//Aadd( aRegis, {"Desenho"   , PP8->PP8_DESENH} )
		Aadd( aRegis, { "Dt.Entrega", dtoc(PP8->PP8_DTPRES) } )			// Valdemir 10/08/2020
		Aadd( aRegis, { "Pedido"    , PP8->PP8_PEDVEN} )				// Chamado 20200527002503 - Valdemir Rabelo 07/08/2020
		Aadd( aRegis, { "Data: "    , dtoc(dDataBase) } )
		Aadd( aRegis, { "Hora: "    , time() } )
		Aadd( aRegis, { "Usuario: " , Alltrim(cUserName) } ) 			// Valdemir 10/08/2020
		aAdd(aWFDes, aRegis)
		aRegis := nil
		// ------------ Adicionando Vendedor Externo - 11/08/2020 -----------
		SA1->( dbSetOrder(1) )
		if SA1->( dbSeek(xFilial('SA1')+PP7->PP7_CLIENT+PP7->PP7_LOJA) )
			IF !EMPTY(SA1->A1_VEND)
				cTMP := Alltrim(Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND, "A3_EMAIL"))
				if !Empty(cTMP)
					_cEmail += ","+cTMP
				Endif
			Endif
		Endif
		//---------------------------------------------------------------------
		// Valdemir Rabelo 07/08/2020 Chamado 20200527002503
		if !Empty(PP7->PP7_VEND) // Vendedor Interno
			cTMP := Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND, "A3_EMAIL"))
			if !Empty(cTMP)
				_cEmail += ","+cTMP
			Endif
		Endif

		U_EnviaWF1(aWFDes, _cEmail, "AVISO ( DATA ENTREGA DESENHO INFORMADA )") //StaticCall (STFTA001,EnviaWF, aWFDes, _cEmail, "AVISO ( DATA ENTREGA DESENHO INFORMADA )")
	Endif

	RestArea( aArea )

Return .T.


//--------------------------------------------------------------
/*{Protheus.doc} VldDtEnt
Description
	Rotina valida Data Entrega Desenho
@author Valdemir José - valdemir.rabelo@sigamat.com.br
@since 06/12/2019
*/
//--------------------------------------------------------------
Static Function VldDtEnt(dGetDtEntDes)
	Local lRET := .T.

	if !Empty(dGetDtEntDes)
		lRET := (dGetDtEntDes > PP8->PP8_DTORC)
		if !lRET
			MsgInfo("Data invalida, por favor verifique.","Atenção!")
		endif
	Endif

Return lRET


/*/{Protheus.doc} FTA005RJ
	description
	Rotina para rejeição de recebimento
	@type function
	@version 
	@author Valdemir Rabelo
	@since 24/04/2020
	@return return_type, return_description
/*/
User Function FTA005RJ
	LOCAL aCampo    := {}
	LOCAL aCONDICAO := {}
	LOCAL cMotivo   := ""
	Local aAreaPP7  := GetArea()

	IF PP7->( FIELDPOS("PP7_REJEIT") ) == 0			// Valdemir Rabelo 24/04/2020
		MsgInfo("Campo de Rejeição não foi criado na Tabela: PP7. Informe o setor de TI", "Atenção!")
		return
	ENDIF

	if (PP7->PP7_REJEIT=="S")
		MsgInfo("Atendimento já rejeitado anteriromente", "Atenção!")
		return
	endif

	IF  EMPTY(PP8->PP8_DTENG)

		IF EMPTY(PP8->PP8_USRCSD)

			if !PP7->( dbSeek(xFilial("PP7")+PP8->PP8_CODIGO) )					// Valdemir Rabelo 24/04/2020
				MsgInfo("Atendimento não encontrado na PP7, informe o setor de TI","Atenção!")
				Return
			endif

			If MsgYesno("Confirma Rejeição de Sol. Desenvolvimento ? ")
				While Empty(cMotivo)
					cMotivo := FWInputBox("Informe o motivo da rejeição","")
				EndDo
				// Valdemir Rabelo 24/04/2020 - Solicitação do Lucas
				RecLock("PP7",.F.)
				PP7->PP7_REJEIT := 'S'
				PP7->PP7_DTREJE := dDATABASE
				PP7->PP7_MOTREJ := cMotivo
				MsUnlock()

				IF 	SuperGetMV("ST_SDENVE",,.F.)
					_cEmail := SuperGetMV("ST_EMRCSD",,"gallo@rvgsolucoes.com.br")
					_cTipo := "Rejeição de documentacao"
					StEmail("Rejeição de Recebimento de SD ",_cEmail,_cTipo)
				Endif
			Endif
		Else
			if !empty(PP8->PP8_QUDESE)
				MsgSTop(" Processo de SD ja Iniciado !!  Verifqiue !! "  )
			Else
				MsgSTop(" Processo de SD ja recebido !!  Verifqiue !! "  )
			Endif
		Endif

	ELSE

		MsgSTop(" Processo de SD ja Encerrado !! Verifique !! ")

	ENDIF

	RestArea( aAreaPP7 )

Return



Static Function AtuPP8(aCampo, aCONDICAO)
	Local aAreaPP8 := GetArea()
	Local nReg     := PP8->( RECNO() )
	Local lRET     := .T.
	Local nX       := 0

	dbSelectArea("PP8")
	dbSetOrder(1)
	if dbSeek(xFilial("PP8")+aCondicao[2][2])
		While PP8->( !Eof() ) .AND. aCONDICAO[1][2]==PP8->PP8_FILIAL .AND. aCONDICAO[2][2]==PP8_CODIGO
			RecLock("PP8",.F.)
			For nX := 1 to Len(aCampo)
				&(aCampo[nX][1]) := aCampo[nX][2]
			Next
			MSUNLOCK()
			dbSkip()
		ENDDO
	else
		lRET := .F.
	endif

	RestArea( aAreaPP8 )
	PP8->( dbGoto(nReg) )

Return lRET



/*/{Protheus.doc} incRotei
description
Inclusão de Roteiro automático
@type function
@version  
@author Valdemir Jose
@since 30/04/2021
@return return_type, return_description
/*/
Static Function incRotei()
	Local oModel, oMdlDet
	Local cErro  := ""
	Local nLinha := 0
	Local lRet   := .T.
	Local aCabTMP:= {}
	Local aDados := getQuadros(Left(PP8->PP8_CLASSI,3), @aCabTMP)

	INCLUI := .T.
	ALTERA := .F.
	SG2->( dbSetOrder(1) )
	For nLinha := 1 to Len(aDados)
	    nPosCPO := aScan(aCabTMP, {|X| alltrim(X)=="Produto"})
		cProduto:= PadR(aDados[nLinha, nPosCPO],TamSX3("G2_PRODUTO")[1],' ')
		cCodigo := '01'
	    nPosCPO := aScan(aCabTMP, {|X| alltrim(X)=="OP"})
		cOPerac := aDados[nLinha, nPosCPO]

	    if SG2->( dbSeek(xFilial("SG2")+cProduto+cCodigo+cOPerac) )
		   RecLock('SG2',.F.)
		   SG2->( dbDelete() )
		   MsUnlock()
		endif 
	Next
	oModel := FWLoadModel('MATA632') //Carrega o modelo do programa MATA632

	oModel:SetOperation(MODEL_OPERATION_INSERT) //Seta a operação de inclusão no modelo.

	If oModel:Activate() //Ativa o modelo.

		For nLinha := 1 to Len(aDados)
			If !oModel:SetValue("MATA632_CAB","G2_CODIGO" , '01'/*PP8->PP8_ROTEIR*/) //Atribui o código do roteiro no modelo. (G2_CODIGO)
				//Se ocorreu algum erro na atribuição, recupera o erro.
				cErro := oModel:GetErrorMessage()[6]
				lRet := .F.
			EndIf
			nPosCPO := aScan(aCabTMP, {|X| alltrim(X)=="Produto"})
			If lRet .And. !oModel:SetValue("MATA632_CAB","G2_PRODUTO", aDados[nLinha, nPosCPO]) //Atribui o código do produto no modelo. (G2_PRODUTO)
				//Se ocorreu algum erro na atribuição, recupera o erro.
				cErro := oModel:GetErrorMessage()[6]
				lRet := .F.
			EndIf

			oMdlDet := oModel:GetModel("MATA632_SG2") //Recupera o submodelo detalhe.

			nPosCPO := aScan(aCabTMP, {|X| alltrim(X)=="OP"})
			If lRet .And. !oMdlDet:SetValue("G2_OPERAC",aDados[nLinha, nPosCPO]) //Atribui o código da operação no modelo. (G2_OPERAC)
				//Se ocorreu algum erro na atribuição, recupera o erro.
				cErro := oModel:GetErrorMessage()[6]
				lRet := .F.
			EndIf
			nPosCPO := aScan(aCabTMP, {|X| alltrim(X)=="Desc. Oper."})
			If lRet .And. !oMdlDet:SetValue("G2_DESCRI",aDados[nLinha, nPosCPO]) //Atribui a descrição da operação no modelo. (G2_DESCRI)
				//Se ocorreu algum erro na atribuição, recupera o erro.
				cErro := oModel:GetErrorMessage()[6]
				lRet := .F.
			EndIf
			nPosCPO := aScan(aCabTMP, {|X| alltrim(X)=="Recurso"})
			If lRet .And. !oMdlDet:SetValue("G2_RECURSO",aDados[nLinha, nPosCPO]) //Atribui o código do recurso no modelo. (G2_RECURSO)
				//Se ocorreu algum erro na atribuição, recupera o erro.
				cErro := oModel:GetErrorMessage()[6]
				lRet := .F.
			EndIf
			nPosCPO := aScan(aCabTMP, {|X| alltrim(X)=="Setup"})
			If lRet .And. !oMdlDet:SetValue("G2_SETUP",aDados[nLinha, nPosCPO]) //Atribui o tempo de setup no modelo. (G2_SETUP)
				//Se ocorreu algum erro na atribuição, recupera o erro.
				cErro := oModel:GetErrorMessage()[6]
				lRet := .F.
			EndIf
			nPosCPO := aScan(aCabTMP, {|X| alltrim(X)=="Lote Padrão"})
			If lRet .And. !oMdlDet:SetValue("G2_LOTEPAD",aDados[nLinha, nPosCPO]) //Atribui o lote padrão no modelo. (G2_LOTEPAD)
				//Se ocorreu algum erro na atribuição, recupera o erro.
				cErro := oModel:GetErrorMessage()[6]
				lRet := .F.
			EndIf
			nPosCPO := aScan(aCabTMP, {|X| alltrim(X)=="Tempo Padrão"})
			If lRet .And. !oMdlDet:SetValue("G2_TEMPAD",aDados[nLinha, nPosCPO]) //Atribui o tempo padrão no modelo. (G2_TEMPAD)
				//Se ocorreu algum erro na atribuição, recupera o erro.
				cErro := oModel:GetErrorMessage()[6]
				lRet := .F.
			EndIf
			nPosCPO := aScan(aCabTMP, {|X| alltrim(X)=="Tipo Op."})
			If lRet .And. !oMdlDet:SetValue("G2_TPOPER",aDados[nLinha, nPosCPO]) //Atribui o tipo de operação no modelo. (G2_TPOPER)
				//Se ocorreu algum erro na atribuição, recupera o erro.
				cErro := oModel:GetErrorMessage()[6]
				lRet := .F.
			EndIf
			nPosCPO := aScan(aCabTMP, {|X| alltrim(X)=="Cent. Trab."})
			If lRet .And. !oMdlDet:SetValue("G2_CTRAB",aDados[nLinha, nPosCPO]) //Atribui o Centro de trabalho no modelo. (G2_CTRAB)
				//Se ocorreu algum erro na atribuição, recupera o erro.
				cErro := oModel:GetErrorMessage()[6]
				lRet := .F.
			EndIf
			If lRet .And. !oMdlDet:AddLine() //Adiciona uma nova linha no modelo detalhe
				//Se ocorreu algum erro ao adicionar uma nova linha, recupera o erro
				cErro := oModel:GetErrorMessage()[6]
				lRet := .F.
			EndIf

			if !Empty(cErro)
			   MsgInfo(cErro)
			Endif 

		Next

		If lRet
			If oModel:VldData() //Valida as informações
				lRet := oModel:CommitData() //Efetiva o cadastro.
				If !lRet
					cErro := oModel:GetErrorMessage()[6]
				EndIf
			Else
				cErro := oModel:GetErrorMessage()[6]
				lRet := .F.
			EndIf
		EndIf
		oModel:DeActivate() //Desativa o modelo.
	Else
		lRet := .F.
	EndIf

Return lRet


/*/{Protheus.doc} VldLeadComp
description
   Rotina que valida componentes do produto pai e envia WF, caso não encontre o Lead-Time
@type function
@version 
@author Valdemir Jose
@since 17/06/2020
@param pProdPai, param_type, param_description
@return return_type, return_description
/*/
Static Function VldLeadComp(pProdPai)
	Local aArea2  := GetArea()
	Local cChave  := '04'+pProdPai
	Local _EmlWF  := SuperGetMV("ST_EMLLEAD",.F.,'ulisses.almeida@steck.com.br,alex.lourenco@steck.com.br,julianny.bernardo@steck.com.br,juliana.queiroz@steck.com.br,lucas.machado@steck.com.br')
	Local _aDados := {}
	Local _aTMP   := {}

	dbSelectArea("SB1")
	dbSetOrder(1)

	dbSelectArea("SB2")
	dbSetOrder(1)

	dbSelectArea("SBZ") // posiciono SBJ - 12/06/2020 - BZ_PE
	dbSetOrder(1)

	dbSelectArea('SGG')
	dbSetOrder(1)
	dbSeek(cChave)				// Chumbado Filial 04, por entrarem em filial diferente e não encontrar o registro - Valdemir Rabelo 07/08/2020
	While SGG->(!EOF()).and. (SGG->GG_FILIAL+SGG->GG_COD==cChave)
		if SB1->( dbSeek(xFilial('SB1')+SGG->GG_COMP) ) .AND. (SB1->B1_CLAPROD=="C")  // Verifico se é Comprado
			SB2->( dbSeek('04'+SGG->GG_COMP+SB1->B1_LOCPAD) )				  // Verifico se tem Saldo
			if SB2->(SaldoSb2()) == 0
				if SBZ->( dbSeek('04'+SGG->GG_COMP) )								  // localizo indicadores de produtos
					if SBZ->BZ_PE==0												  // Se não existir Lead-Time
						IF aScan(_aTMP, {|X| X[1]=="Tabela: " })==0
							aAdd(_aTMP, {"Tabela: ", "SBZ - Indicadores de Produtos"})
						Endif
						aAdd(_aTMP, {"Produto: ", SC6->C6_PRODUTO})
					endif
				else
					aAdd(_aTMP, {"Produto: ", SGG->GG_COMP+" - Não cadastrado (SBZ-Indicadores Produtos)"})
				Endif
			Endif
		Endif
		SGG->( dbSkip() )
	EndDo


	// Valdemir Rabelo 17/06/2020 - 20200403001451
	if Len(_aTMP) > 0
		Aadd( _aTMP, { "Data: "    , dtoc(dDataBase) } )
		Aadd( _aTMP, { "Hora: "    , time() } )
		Aadd( _aTMP, { "Usuario: " , Alltrim(cUserName) } )
		aAdd(_aDados, _aTMP)
		_aTMP := {}
		U_EnviaWF1(_aDados, _EmlWF, "AVISO ( Cadastrar Lead Time )")
	Endif

	RestArea( aArea2 )

Return


/*/{Protheus.doc} getQuadros
description
Rotina que irá montar os dados a serem criado
referente ao roteiro
@type function
@version  
@author Valdemir Jose
@since 27/04/2021
@return return_type, return_description
/*/
Static Function getQuadros(pRoteiro, aCabTMP)
	Local aRET   := {}
	
	aCabTMP := {'OP','Produto','Recurso','Cent. Trab.','Linha Prod.','Tipo Linha','Desc. Oper.','Setup','Mão de Obra','Lote Padrão','Tempo Padrão','Tipo Op.','Tempo Final'}

	if pRoteiro$'003/004/005/006/007'
		if pRoteiro=='003'
			aAdd(aRET, {'05','SCM123660','MTM002','08','Mon','O', 'Cortar Cabos',    0.08, 1, 1200,1,'1',0.08})
			aAdd(aRET, {'10','SCM123660','MTM001','08','Mon','P', 'Montar e Embalar',0.02, 1, 12,  1,'1',0.08})
		elseif pRoteiro=='004'
			aAdd(aRET, {'05','SCM163087','MTM007','08','Mon','O', 'Cortar Barramentos', 0.08, 1, 160, 1,'1',0.08})
			aAdd(aRET, {'10','SCM163087','MTM002','08','Mon','O', 'Cortar Cabos',       0.08, 1, 1200,1,'1',0.08})
			aAdd(aRET, {'15','SCM163087','MTM001','08','Mon','P', 'Montar e Embalar',   0.02, 1, 9,   1,'1',0.08})
		elseif pRoteiro=='005'
			aAdd(aRET, {'05','SCM24B077','MTM002','08','Mon','O', 'Cortar Cabos',    0.08, 1, 135, 1,'1',0.08})
			aAdd(aRET, {'10','SCM24B077','MTM001','08','Mon','P', 'Montar e Embalar',0.02, 1, 7,   1,'1',0.08})
		elseif pRoteiro=='006'
			aAdd(aRET, {'05','SCE367664','MTM002','08','Mon','O', 'Cortar Cabos',    0.08, 1, 80, 1,'1',0.08})
			aAdd(aRET, {'10','SCE367664','MTM001','08','Mon','P', 'Montar e Embalar',0.02, 1, 4,  1,'1',0.08})
		elseif pRoteiro=='007'
			aAdd(aRET, {'05','SCE484141','MTM002','08','Mon','O', 'Cortar Cabos',    0.08, 1, 80, 1,'1',0.08})
			aAdd(aRET, {'10','SCE484141','MTM001','08','Mon','P', 'Montar e Embalar',0.02, 1, 3,  1,'1',0.08})
		endif
	endif

	if pRoteiro$'011/012/013'
		if pRoteiro=='011'
			aAdd(aRET, {'05','S66202036','MTM002','08','Mon','O', 'Furar Porta',         0.08, 1, 1, 0.52,'1',0.08})
			aAdd(aRET, {'10','S66202036','MTM002','08','Mon','O', 'Furar Placa',         0.08, 1, 1, 0.23,'1',0.08})
			aAdd(aRET, {'15','S66202036','MTM001','08','Mon','P', 'Montagem Mecanica',   0.08, 1, 1, 2.20,'1',0.08})
			aAdd(aRET, {'20','S66202036','MTM001','08','Mon','P', 'Interligar e Testar', 0.08, 1, 1, 4.00,'1',0.08})
			aAdd(aRET, {'25','S66202036','MTM001',''  ,'Mon','P', 'Embalar',    		 0.02, 1, 1, 0.13,'1',0.08})
		elseif pRoteiro=='012'
			aAdd(aRET, {'05','S10620742','MTU002','08','Mon','O', 'Furar Porta',         0.08, 1, 1, 0.20,'1',0.08})
			aAdd(aRET, {'10','S10620742','MTU002','08','Mon','O', 'Furar Placa',         0.08, 1, 1, 0.67,'1',0.08})
			aAdd(aRET, {'15','S10620742','MTM001','08','Mon','P', 'Montagem Mecanica',   0.08, 1, 1, 4.17,'1',0.08})
			aAdd(aRET, {'20','S10620742','MTM001','08','Mon','P', 'Interligar e Testar', 0.08, 1, 1,11.00,'1',0.08})
			aAdd(aRET, {'25','S10620742','MTM001','08','Mon','P', 'Embalar',    		 0.02, 1, 1, 0.13,'1',0.08})
		elseif pRoteiro=='013'
			aAdd(aRET, {'05','S18820031','MTU002','08','Mon','O', 'Furar Porta',         0.08, 1, 1, 0.38,'1',0.08})
			aAdd(aRET, {'10','S18820031','MTU002','08','Mon','O', 'Furar Placa',         0.08, 1, 1, 1.20,'1',0.08})
			aAdd(aRET, {'15','S18820031','MTM001','08','Mon','P', 'Montagem Mecanica',   0.08, 1, 1, 2.28,'1',0.08})
			aAdd(aRET, {'20','S18820031','MTM001','08','Mon','P', 'Interligar e Testar', 0.08, 1, 1,20.00,'1',0.08})
			aAdd(aRET, {'25','S18820031','MTM001','08','Mon','P', 'Embalar',    	     0.02, 1, 1, 0.13,'1',0.08})
		elseif pRoteiro=='014'
			aAdd(aRET, {'05','S86201980','MTU007','08','Mon','O', 'Cortar Barramento',   0.02, 1,50, 1.00, '1', 0.08})
			aAdd(aRET, {'10','S86201980','MTU008','08','Mon','O', 'Furar Barramento',    0.02, 1,22, 1.00, '1', 0.08})
			aAdd(aRET, {'15','S86201980','MTU011','08','Mon','O', 'Fazer Rosca',         0.02, 1,50, 1.00, '1', 0.08})
			aAdd(aRET, {'20','S86201980','MTU002','08','Mon','P', 'Furar Placa',         0.08, 1, 1, 0.50, '1', 0.08})
			aAdd(aRET, {'25','S86201980','MTU001','08','Mon','P', 'Montagem Mecanica',   0.08, 1, 1, 1.00, '1', 0.08})
			aAdd(aRET, {'30','S86201980','MTU001','08','Mon','P', 'Interligar e Testar', 0.08, 1, 1, 1.40, '1', 0.08})
			aAdd(aRET, {'35','S86201980','MTU001','08','Mon','P', 'Embalar',    	     0.02, 1, 1, 0.13, '1', 0.08})
		elseif pRoteiro=='015'
			aAdd(aRET, {'05','S12620583','MTU007','08','Mon','O', 'Cortar Barramento',  0.02, 1,17, 1.00, '1', 0.08})
			aAdd(aRET, {'10','S12620583','MTU008','08','Mon','O', 'Furar Barramento',   0.02, 1,19, 1.00, '1', 0.08})
			aAdd(aRET, {'15','S12620583','MTU011','08','Mon','O', 'Fazer Rosca',        0.02, 1,40, 1.00, '1', 0.08})
			aAdd(aRET, {'20','S12620583','MTU002','08','Mon','P', 'Furar Placa',        0.08, 1, 1, 0.92, '1', 0.08})
			aAdd(aRET, {'25','S12620583','MTU001','08','Mon','P', 'Montagem Mecanica',  0.08, 1, 1, 2.17, '1', 0.08})
			aAdd(aRET, {'30','S12620583','MTU001','08','Mon','P', 'Interligar e Testar',0.08, 1, 1, 5.00, '1', 0.08})
			aAdd(aRET, {'35','S12620583','MTU001','08','Mon','P', 'Embalar',    	    0.02, 1, 1, 0.13, '1', 0.08})
		elseif pRoteiro=='016'
			aAdd(aRET, {'05','S16101513','MTU007','08','Mon','O', 'Cortar Barramento',  0.02, 1, 1, 2.00, '1', 0.08})
			aAdd(aRET, {'10','S16101513','MTU008','08','Mon','O', 'Furar Barramento',   0.02, 1, 1, 1.00, '1', 0.08})
			aAdd(aRET, {'15','S16101513','MTU011','08','Mon','O', 'Fazer Rosca',        0.02, 1, 1, 1.00, '1', 0.08})
			aAdd(aRET, {'20','S16101513','MTU002','08','Mon','P', 'Furar Placa',        0.08, 1, 1, 0.85, '1', 0.08})
			aAdd(aRET, {'25','S16101513','MTU001','08','Mon','P', 'Montagem Mecanica',  0.08, 1, 1, 2.00, '1', 0.08})
			aAdd(aRET, {'30','S16101513','MTU001','08','Mon','P', 'Interligar e Testar',0.08, 1, 1, 8.50, '1', 0.08})
			aAdd(aRET, {'35','S16101513','MTU001','08','Mon','P', 'Embalar',    	    0.02, 1, 1, 0.17, '1', 0.08})
		endif
	endif

Return aRET
