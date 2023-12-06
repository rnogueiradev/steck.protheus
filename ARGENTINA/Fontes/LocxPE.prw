#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LocxPE     ºAutor  ³Cristiano Pereira Data ³  11/29/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada financeiro x nota de debito               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LocxPE11()

	Local _cFilial:= SD2->D2_FILIAL
	Local _cDoc   := SD2->D2_DOC
	Local _cSerie := SD2->D2_SERIE
	Local _cCli   := SD2->D2_CLIENTE
	Local _cLoja  := SD2->D2_LOJA
	Local _cObs   := Space(100)
	Local oDlgA
	Local _nConsul := 0

	//<< Ticket 20190815000023 - Everson Santana - 18.09.2019
	Local cMsg		:= ""
	Local _nLin
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _aMsg		:= {}
	Local _lClas	:= .F.
	Local _cAssunto := "Ingreso de Remito de Compras"
	Local _cEmail  :=  GetMv('ST_MAT102N',,'carla.gimenez@steckgroup.com;cristina.benitez@steckgroup.com;marcela.faravelli@steckgroup.com;johany.soler@steckgroup.com;tatiana.neves@steckgroup.com;Gabriela.Marchetta@steckgroup.com')
	Local _cCopia  := ""
	local _aAttach := {}
	local _aAttach1 := {}
	Local _cCaminho:=""
	Local _Xn
	Local cFuncSent:= "LocxPE11_A"
	//>> Ticket 20190815000023 - Everson Santana - 18.09.2019
	If RTRIM(SF2->F2_ESPECIE)=="NDC"

		DbSelectArea("SF3")
		DbSetOrder(5)
		If DbSeek(_cFilial+_cSerie+_cDoc+_cCli+_cLoja)

			While !SF3->(EOF()) .And. _cFilial+_cSerie+_cDoc+_cCli+_cLoja==SF3->F3_FILIAL+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA

				SF3->(RecLock("SF3",.F.))
				SF3->F3_ENTRADA := msdate()
				SF3->(MsUnLock())

				DbSelectArea("SF3")
				DbSkip()
			Enddo

		Endif


	Endif


	If RTRIM(SF2->F2_ESPECIE)=="NDC"
		// Ticket 20201203011644
		
		/*
		oDlgA := MSDialog():New(C(10),C(10),C(220),C(300),'Nota de Débito',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

		DEFINE FONT oFont1 NAME "Arial" SIZE 0,-11 BOLD
		DEFINE FONT oFont2 NAME "Arial" SIZE 0,-14 BOLD

		@ C(020),C(003)    SAY OemToAnsi("Observação: ")                    SIZE C(026),C(010)    OF  oDlgA PIXEL FONT oFont1
		@ C(020),C(050)    MSGET _cObs  SIZE C(035),C(008)   OF  oDlgA PIXEL   WHEN .T.

		oTBrowseButton1 := TBrowseButton():New( C(60),C(14),'Gravar',oDlgA,{|| (oDlgA:End(),_nConsul := 1)},C(30),C(10),,,.F.,.T.,.F.,,.F.,,,)
		// ativa diálogo centralizado
		oDlgA:Activate(,,,.T.,,, )

		SF2->(RecLock("SF2",.F.))
		SF2->F2_DTDIGIT := msdate()

		If _nConsul == 1
			SF2->F2_XOBS := _cObs
		Endif
		SF2->(MsUnLock())
		*/
	
	Endif

	If RTRIM(SD2->D2_ESPECIE)=="NDC"

		DbSelectArea("SD2")
		DbSetOrder(3)
		If DbSeek(_cFilial+_cDoc+_cSerie+_cCli+_cLoja)

			While !SD2->(EOF()) .And. _cFilial+_cDoc+_cSerie+_cCli+_cLoja==SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

				SD2->(RecLock("SD2",.F.))
				SD2->D2_DTDIGIT := msdate()
				SD2->(MsUnLock())

				DbSelectArea("SD2")
				DbSkip()
			Enddo

		Endif
	Endif

	//>> Ticket 20190815000023 - Everson Santana - 18.09.2019
	If FUNNAME() $ "MATA102N" .AND. SF1->F1_SERIE = "R  "

		If MsgYesNo("¿Quieres incluir el archivo adjunto?")

			_aAttach := U_ARANEX(.t.)

			For _Xn := 1 to Len(_aAttach)

				Aadd(_aAttach1,_aAttach[_Xn][01])

			Next

			If Len(_aAttach) > 0
				_cCaminho := _aAttach[01][02]
			EndIf

		EndIf

		Aadd( _aMsg , { "Orden de Compra: "		, UPPER(Posicione("SD1",1,xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA),"D1_PEDIDO")) } )
		Aadd( _aMsg , { "Num. de Doc: " 		, SF1->F1_DOC  } )
		Aadd( _aMsg , { "Serie: "    			, SF1->F1_SERIE } )
		Aadd( _aMsg , { "Lote: "    			, SF1->F1_XLOTE } )
		Aadd( _aMsg , { "Local : "    			, SF1->F1_XLOCAL } )
		Aadd( _aMsg , { "Proveedor: "   		, UPPER(Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")) } )
		Aadd( _aMsg , { "Fch Emision  " 		, Dtoc(SF1->F1_EMISSAO) } )
		Aadd( _aMsg , { "Fecha Digit."  		, Dtoc(SF1->F1_DTDIGIT) } )
		Aadd( _aMsg , { "Valor Total: "	 		, transform(SF1->F1_VALBRUT	,"@E 999,999,999.99")  } )
		Aadd( _aMsg , { "Usuario"  				,  UsrRetName(__cUserId) } )

		_cAssunto := "Ingreso de Remito de Compras "+ Alltrim(SF1->F1_DOC)

		If ( Type("l410Auto") == "U" .OR. !l410Auto )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Definicao do cabecalho do email                                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cMsg := ""
			cMsg += '<html>'
			cMsg += '<head>'
			cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
			cMsg += '</head>'
			cMsg += '<body>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
			cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Definicao do texto/detalhe do email                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For _nLin := 1 to Len(_aMsg)
				If (_nLin/2) == Int( _nLin/2 )
					cMsg += '<TR BgColor=#B0E2FF>'
				Else
					cMsg += '<TR BgColor=#FFFFFF>'
				EndIf

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

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



			U_ARMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach1,_cCaminho)

		EndIf

	EndIf
	//<< Ticket 20190815000023 - Everson Santana - 18.09.2019
return


User Function ARANEX(_lT)

	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	//Â³Declaração das Variáveis
	//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
	Local aArea       := GetArea()
	Local aArea1      := SF1->(GetArea())
	Local n           := 0
	Local lSaida      := .f.
	Local nOpcao      := 0
	Local oDxlg
	Local _cAne01     := ''
	Local _cAne02     := ''
	Local _cAne03     := ''
	Local _cAne04     := ''
	Local _cAne05     := ''
	Local _cAnex	  := ''
	Local _aAttach	  := {}
	Local _nLin       := 000
	Local cSolicit	  := Alltrim(SF1->F1_DOC)

	Private _cPath      := GetSrvProfString("RootPath","")
	Private _cStartPath := "\arquivos\Remitos_Entrada\"
	Private _cEmp       := ""+cEmpAnt+"\"
	Private _cFil       := ""+SF1->F1_FILIAL+"\"
	Private _cNUm       := ""+cSolicit+"\"
	Private _cServerDir   := ''
	Default _lT := .f.

	If !_lT
		If Inclui
			MsgInfo("Anexo so pode ser incluido apos a Gravação do Reembolso...!!!!")
			Return()
		EndIf
	EndIf
	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	//Â³ Criação das pastas para salvar os anexos das SolicitaÃ§Ãµes de Compras no Servidor
	//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
	_cServerDir += (_cStartPath)
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	_cServerDir += _cEmp
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	_cServerDir += _cFil
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	_cServerDir += _cNUm
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif


	If ExistDir(_cServerDir)

		_cAne01 := space(90)
		_cAne02 := space(90)
		_cAne03 := space(90)
		_cAne04 := space(90)
		_cAne05 := space(90)

		cNameSolic := USRRETNAME(__cUserId)

		Do While !lSaida
			nOpcao := 0

			Define msDialog oDxlg Title "Seleccionar archivos adjuntos " From 10,10 TO 450,600 Pixel
			_nLin := 005

			_nLin := _nLin + 10
			@ _nLin,010 say "Documento" COLOR CLR_BLACK    Of oDxlg Pixel
			@ _nLin,040 get cSolicit  when .f. size 050,08  Of oDxlg Pixel

			@ _nLin,110 say "Usuario" COLOR CLR_BLACK   Of oDxlg Pixel
			@ _nLin,140 get  cNameSolic  when .f. size 090,08  Of oDxlg Pixel

			_nLin := _nLin + 20
			@ _nLin,010 Say "Anexo - 01"   COLOR CLR_HBLUE  Of oDxlg Pixel
			_nLin := _nLin + 10
			@ _nLin,010 get _cAne01     when .f.   size 165,08  Of oDxlg Pixel
			@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne01:=SaveAnexo(1,_cAne01,cSolicit)) Of oDxlg Pixel
			@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne01:=DelAnexo (1,_cAne01,cSolicit)) Of oDxlg Pixel
			@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne01:=OpenAnexo(1,_cAne01,cSolicit)) Of oDxlg Pixel

			_nLin := _nLin + 20
			@ _nLin,010 Say "Anexo - 02"   COLOR CLR_HBLUE  Of oDxlg Pixel
			_nLin := _nLin + 10
			@ _nLin,010 get _cAne02     when .f.   size 165,08  Of oDxlg Pixel
			@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne02:=SaveAnexo(2,_cAne02,cSolicit)) Of oDxlg Pixel
			@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne02:=DelAnexo (2,_cAne02,cSolicit)) Of oDxlg Pixel
			@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne02:=OpenAnexo(2,_cAne02,cSolicit)) Of oDxlg Pixel

			_nLin := _nLin + 20
			@ _nLin,010 Say "Anexo - 03"   COLOR CLR_HBLUE  Of oDxlg Pixel
			_nLin := _nLin + 10
			@ _nLin,010 get _cAne03     when .f.   size 165,08  Of oDxlg Pixel
			@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne03:=SaveAnexo(3,_cAne03,cSolicit)) Of oDxlg Pixel
			@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne03:=DelAnexo (3,_cAne03,cSolicit)) Of oDxlg Pixel
			@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne03:=OpenAnexo(3,_cAne03,cSolicit)) Of oDxlg Pixel

			_nLin := _nLin + 20
			@ _nLin,010 Say "Anexo - 04"   COLOR CLR_HBLUE  Of oDxlg Pixel
			_nLin := _nLin + 10
			@ _nLin,010 get _cAne04     when .f.   size 165,08  Of oDxlg Pixel
			@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne04:=SaveAnexo(4,_cAne04,cSolicit)) Of oDxlg Pixel
			@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne04:=DelAnexo (4,_cAne04,cSolicit)) Of oDxlg Pixel
			@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne04:=OpenAnexo(4,_cAne04,cSolicit)) Of oDxlg Pixel

			_nLin := _nLin + 20
			@ _nLin,010 Say "Anexo - 05"   COLOR CLR_HBLUE  Of oDxlg Pixel
			_nLin := _nLin + 10
			@ _nLin,010 get _cAne05     when .f.   size 165,08  Of oDxlg Pixel
			@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne05:=SaveAnexo(5,_cAne05,cSolicit)) Of oDxlg Pixel
			@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne05:=DelAnexo (5,_cAne05,cSolicit)) Of oDxlg Pixel
			@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne05:=OpenAnexo(5,_cAne05,cSolicit)) Of oDxlg Pixel

			_nLin := _nLin + 20

			DEFINE SBUTTON FROM _nLin,130 TYPE 1 ACTION (lSaida:=.T.,nOpcao:=1,oDxlg:End()) ENABLE OF oDxlg

			Activate dialog oDxlg centered

			If nOpcao == 1

				For n:= 1 to 5

					_cAnex := &("_cAne"+StrZero(n,2))

					aadd( _aAttach  ,{_cAnex,_cServerDir})

				Next

			EndIf

		EndDo

	Endif

	RestArea(aArea1)
	RestArea(aArea)

Return(_aAttach)

Static Function SaveAnexo(_nSave,_cFile,cSolicit)

	Local _cSave := ''
	Local _lRet     := .T.
	Local _cLocArq  := ''
	Local _cDir     := ''
	Local _cArq     := ''
	Local cExtensao := ''
	Local nTamOrig  := ''
	Local nMB       := 1024
	Local nTamMax   := 2
	Local cMascara  := "Todos os arquivos"
	Local cTitulo   := "Escolha o arquivo"
	Local nMascpad  := 0
	Local cDirini   := "c:\"
	Local lSalvar   := .T. /*.F. = Salva || .T. = Abre*/
	Local lArvore   := .F. /*.T. = apresenta o árvore do servidor || .F. = não apresenta*/
	Local _cMsgSave := ""
	Local aArea1    := GetArea()
	Local aArea2    := SF1->(GetArea())

	_cLocArq  := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar,, lArvore)

	If !(Empty(_cLocArq))
		nTamOrig := Directory(_cLocArq)[1,2]
		If (nTamOrig/nMB) > (nMB*nTamMax)
			Aviso("Tamanho do Arquivo Superior ao Permitido"; //01 - cTitulo - TÃ­tulo da janela
			,"O Arquivo '"+_cArq+"' tem que ter tamanho máximo de "+cValtoChar(nTamMax)+"MB."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
			,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
			)
			Return
		EndIf

		If _lRet

			_cLocArq  := Alltrim(_cLocArq)
			_cDir     := SUBSTR(_cLocArq, 1                      ,RAT( "\"   , _cLocArq ))
			_cArq     := SUBSTR(_cLocArq, RAT( "\"   , _cLocArq ),Len(_cLocArq))
			_cArq     := StrTran(_cArq,"\","")
			cExtensao := SUBSTR(_cLocArq,Rat(".",_cLocArq),Len(_cLocArq))

			If At(".",cExtensao) == 1

				//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„?Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
				//Â³ Copio o arquivo original da máquina do usuário para o servidor
				//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
				lSucess   := __CopyFile(_cLocArq,_cServerDir+_cArq)

				If lSucess

					Aviso("Anexar Arquivo"; //01 - cTitulo - TÃ­tulo da janela
					,"O Arquivo '"+_cArq+"' foi anexado com sucesso.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
					,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
					)
				Else
					_cSave := ''
					Aviso("Problema ao Anexar Arquivo"; //01 - cTitulo - TÃ­tulo da janela
					,"O Arquivo '"+_cArq+"' não foi anexado."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Favor verificar com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
					,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
					)
				EndIf
			Else
				Aviso("Problema com Extensão do Anexo"; //01 - cTitulo - TÃ­tulo da janela
				,"A Extensão "+cExtensao+" Ã© inválida para anexar junto ao reembolso."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
				,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
				)
			Endif
		Else
			_cSave := _cFile
		Endif

	Else
		_cSave := _cFile
		Aviso("Anexar Arquivo"; //01 - cTitulo - TÃ­tulo da janela
		,"Nenhum Arquivo foi selecionado para ser anexado.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
	Endif


	RestArea(aArea2)
	RestArea(aArea1)

Return(_cArq)

Static Function DelAnexo(_nDel,_cFile,cSolicit)

	Local _cDelete := ''
	Local _lRet    := .T.
	Local _cMsgDel := ""
	Local aArea1   := GetArea()
	Local aArea2   := SF1->(GetArea())

	If Len(Directory(_cServerDir+_cFile)) = 1
		_lRet := MsgYesNo("Deseja deletar o Arquivo ??? "+ Chr(10) + Chr(13) +" Uma vez confirmada essa ação o arquivo não ficará mais disponÃ­vel para consulta.","Atenção")
	Else
		_lRet := .F.
		Aviso("Deletar Anexo"; //01 - cTitulo - TÃ­tulo da janela
		,"Não existe nenhum Arquivo para ser deletado."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
	Endif

	If _lRet
		Ferase( _cServerDir+_cFile)
		_cDelete := ''
	Else
		_cDelete := _cFile
	Endif

	RestArea(aArea2)
	RestArea(aArea1)

Return (_cDelete)

Static Function OpenAnexo(_nOpen,_cFile,cSolicit)

	Local _cOpen      := ''
	Local cZipFile    := ''
	Local _cSaveArq   := "C:\ARQUIVOS_PROTHEUS\"
	Local _cLocalDir  := ''
	Local _cStartPath := "arquivos\"
	Local _cStartPath1 := "REMITOS_ENTRADA\"
	Local _lUnzip     := .T.
	local _aAttach 	  := {}

	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	//Â³ Criação das pastas para salvar os anexos das SolicitaÃ§Ãµes de Compras na máquina Local do usuário
	//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
	_cLocalDir += (_cSaveArq)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += (_cStartPath)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += (_cStartPath1)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += _cEmp
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += _cFil
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += _cNUm
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	If ExistDir(_cLocalDir)
		cZipFile := _cServerDir+_cFile
		If Len(Directory(cZipFile)) = 1
			CpyS2T  ( cZipFile , _cLocalDir, .T. )
		Else
			//_cOpen  := _cFile
			Aviso("Anexo inválido"; //01 - cTitulo - TÃ­tulo da janela
			,"Não existe nenhum anexo no Protheus para ser aberto."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
			,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
			)
		Endif
	Else
		Aviso("Erro ao Salvar Anexo"; //01 - cTitulo - TÃ­tulo da janela
		,"Houve erro ao Salvar o Anexo."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
	Endif

Return (_cFile)
