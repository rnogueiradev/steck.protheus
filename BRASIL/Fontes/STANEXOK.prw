#Include 'Protheus.ch'

/*/{Protheus.doc} STANEXOK(pAlias)
    (long_description)
    @type  Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function  STANEXOK(pAlias, _lT, _SubPasta)
    Local aArea       := GetArea()
	Local aArea1      := Z49->(GetArea())
    Local _aCampos    := aClone(aMotBX)
	Local n           := 0
	Local lSaida      := .f.
	Local nOpcao      := 0
	Local oDxlg
	Local _cAne01     := ''
	Local _cAne02     := ''
	Local _cAne03     := ''
	Local _cAne04     := ''
	Local _cAne05     := ''
	Local _nLin       := 000
	Local cSolicit	  := ''
    Local cTitulo1    := FWSX3Util():GetDescription( _aCampos[2] ) 
    Local cTitulo2    := FWSX3Util():GetDescription( _aCampos[3] ) 
    Local cSay        := ''
    Local cGet        := ''


	Private _cPath      := GetSrvProfString("RootPath","")
	Private _cStartPath := "\arquivos\"
	Private _cEmp       := _SubPasta
	Private _cFil       := ' '
	Private _cNUm       := ' '
	Private _cServerDir := ''
    Default _lT         := .f.

    dbSelectArea(pAlias)

    cSolicit  := (pAlias)->&(_aCampos[2])
    _cNUm     := cSolicit

   	If !_lT
		If Inclui
			MsgInfo("Anexo so pode ser incluido apos a Grava��o...!!!!")
			Return()
		EndIf
	EndIf

	_cServerDir += (_cStartPath)
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	_cServerDir += _cEmp
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

    if !Empty(_cFil)
        _cServerDir += _cFil
        If MakeDir (_cServerDir) == 0
            MakeDir(_cServerDir)
        Endif
    Endif

	_cServerDir += _cNUm+"\"
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif


	If ExistDir(_cServerDir)

		If Len(Directory(_cServerDir+Strzero(1,6)+".mzp")) = 1
			_cAne01 := Strzero(1,6)+".mzp"
		Else
			_cAne01 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(2,6)+".mzp")) = 1
			_cAne02 := Strzero(2,6)+".mzp"
		Else
			_cAne02 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(3,6)+".mzp")) = 1
			_cAne03 := Strzero(3,6)+".mzp"
		Else
			_cAne03 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(4,6)+".mzp")) = 1
			_cAne04 := Strzero(4,6)+".mzp"
		Else
			_cAne04 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(5,6)+".mzp")) = 1
			_cAne05 := Strzero(5,6)+".mzp"
		Else
			_cAne05 := space(90)
		Endif

        if Right(_aCampos[2],3)=="USER"
            cNameSolic := USRRETNAME((pAlias)->&(_aCampos[2]))
        else
            cNameSolic := (pAlias)->&(_aCampos[3])
        endif

        Do While !lSaida
            nOpcao := 0

            Define msDialog oDxlg Title "Selecione os Anexos " From 10,10 TO 450,600 Pixel
            /*
            For nX := 1 to 5
                cGet  := "oGet"  + Strzero( nX	,2	,0 )
                cSay  := "oSay"	 + Strzero( nX	,2	,0 )
                cCnt  := "cProc" + Strzero( i	,2	,0 )

                &cCnt 	:= CriaVar(_aCampos[3])

                // Campo editavel para informar o conteudo 
                bSetGet1   := {|u| If(PCount()>0, &cCnt :=u, &cCnt) }
                bValid	   := {||.T.}
                bWhen	   := {||.T.}
                &cGet	   := tGet():New(_nLin,x-137,bSetGet1,&cPnlPsq,80,08,"@!",bValid,,,,,,.T.,,,bWhen,,,,.F.,.F.,, cCnt)

                _nLin := 005

            Next
            */
            _nLin := 005
            @ _nLin,010 say "Filial" COLOR CLR_BLACK  Of oDxlg Pixel
            @ _nLin,070 get xFilial(pAlias) when .f. size 050,08  Of oDxlg Pixel

            _nLin := _nLin + 13
            @ _nLin,010 say cTitulo1 COLOR CLR_BLACK    Of oDxlg Pixel
            @ _nLin,070 get cSolicit  when .f. size 050,08  Of oDxlg Pixel

            @ _nLin,128 say cTitulo2 COLOR CLR_BLACK   Of oDxlg Pixel
            @ _nLin,190 get  cNameSolic  when .f. size 090,08  Of oDxlg Pixel

            _nLin := _nLin + 20
            @ _nLin,010 Say "Anexo - 01"   COLOR CLR_HBLUE  Of oDxlg Pixel
            _nLin := _nLin + 10
            @ _nLin,010 get _cAne01     when .f.   size 165,08  Of oDxlg Pixel
            @ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne01:=SaveAnexo(1,_cAne01,cSolicit)) Of oDxlg Pixel
            @ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne01:=DelAnexo (1,_cAne01,cSolicit)) Of oDxlg Pixel
            @ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne01:=OpenAnexo(1,_cAne01,cSolicit,_SubPasta)) Of oDxlg Pixel

            _nLin := _nLin + 20
            @ _nLin,010 Say "Anexo - 02"   COLOR CLR_HBLUE  Of oDxlg Pixel
            _nLin := _nLin + 10
            @ _nLin,010 get _cAne02     when .f.   size 165,08  Of oDxlg Pixel
            @ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne02:=SaveAnexo(2,_cAne02,cSolicit)) Of oDxlg Pixel
            @ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne02:=DelAnexo (2,_cAne02,cSolicit)) Of oDxlg Pixel
            @ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne02:=OpenAnexo(2,_cAne02,cSolicit,_SubPasta)) Of oDxlg Pixel

            _nLin := _nLin + 20
            @ _nLin,010 Say "Anexo - 03"   COLOR CLR_HBLUE  Of oDxlg Pixel
            _nLin := _nLin + 10
            @ _nLin,010 get _cAne03     when .f.   size 165,08  Of oDxlg Pixel
            @ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne03:=SaveAnexo(3,_cAne03,cSolicit)) Of oDxlg Pixel
            @ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne03:=DelAnexo (3,_cAne03,cSolicit)) Of oDxlg Pixel
            @ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne03:=OpenAnexo(3,_cAne03,cSolicit,_SubPasta)) Of oDxlg Pixel

            _nLin := _nLin + 20
            @ _nLin,010 Say "Anexo - 04"   COLOR CLR_HBLUE  Of oDxlg Pixel
            _nLin := _nLin + 10
            @ _nLin,010 get _cAne04     when .f.   size 165,08  Of oDxlg Pixel
            @ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne04:=SaveAnexo(4,_cAne04,cSolicit)) Of oDxlg Pixel
            @ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne04:=DelAnexo (4,_cAne04,cSolicit)) Of oDxlg Pixel
            @ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne04:=OpenAnexo(4,_cAne04,cSolicit,_SubPasta)) Of oDxlg Pixel

            _nLin := _nLin + 20
            @ _nLin,010 Say "Anexo - 05"   COLOR CLR_HBLUE  Of oDxlg Pixel
            _nLin := _nLin + 10
            @ _nLin,010 get _cAne05     when .f.   size 165,08  Of oDxlg Pixel
            @ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne05:=SaveAnexo(5,_cAne05,cSolicit)) Of oDxlg Pixel
            @ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne05:=DelAnexo (5,_cAne05,cSolicit)) Of oDxlg Pixel
            @ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne05:=OpenAnexo(5,_cAne05,cSolicit,_SubPasta)) Of oDxlg Pixel

            _nLin := _nLin + 20

            DEFINE SBUTTON FROM _nLin,130 TYPE 1 ACTION (lSaida:=.T.,nOpcao:=1,oDxlg:End()) ENABLE OF oDxlg

            Activate dialog oDxlg centered

        EndDo


	Endif

	RestArea(aArea1)
	RestArea(aArea)

Return .T.




Static Function SaveAnexo(_nSave,_cFile,cSolicit)

	Local _cSave := ''
	Local _lRet     := .T.
	Local _cLocArq  := ''
	Local _cDir     := ''
	Local _cArq     := ''
	Local cExtensao := ''
	Local nTamOrig  := ''
	Local nMB       := 1024
	Local nTamMax   := 5
	Local cMascara  := "Todos os arquivos"
	Local cTitulo   := "Escolha o arquivo"
	Local nMascpad  := 0
	Local cDirini   := "c:\"
	Local lSalvar   := .T. /*.F. = Salva || .T. = Abre*/
	Local lArvore   := .F. /*.T. = apresenta o �rvore do servidor || .F. = n�o apresenta*/
	Local _cMsgSave := ""
	Local _cAlias   := Alias()
	Local aArea1    := GetArea()
	Local aArea2    := (_cAlias)->(GetArea())

	_cLocArq  := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar,, lArvore)

	If !(Empty(_cLocArq))
		nTamOrig := Directory(_cLocArq)[1,2]
		If (nTamOrig/nMB) > (nMB*nTamMax)
			Aviso("Tamanho do Arquivo Superior ao Permitido"; //01 - cTitulo - Título da janela
			,"O Arquivo '"+_cArq+"' tem que ter tamanho m�ximo de "+cValtoChar(nTamMax)+"MB."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"Anexo n�o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina autom�tica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
			,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
			)
			Return
		EndIf

		If Len(Directory(_cServerDir+Strzero(_nSave,6)+".mzp")) = 1
			_lRet := MsgYesNo("J� existe um arquivo anexado."+ Chr(10) + Chr(13) +" Deseja sobrepor o arquivo existente ???","Aten��o")
		Endif

		If _lRet

			_cLocArq  := Alltrim(_cLocArq)
			_cDir     := SUBSTR(_cLocArq, 1, RAT( "\"   , _cLocArq ))
			_cArq     := SUBSTR(_cLocArq, RAT( "\"   , _cLocArq ),Len(_cLocArq))
			_cArq     := StrTran(_cArq,"\","")
			cExtensao := SUBSTR(_cLocArq,Rat(".",_cLocArq),Len(_cLocArq))

			If At(".",cExtensao) == 1

				_cSave := Strzero(_nSave,6)

				//³ Copio o arquivo original da m�quina do usu�rio para o servidor
				lSucess   := __CopyFile(_cLocArq,_cServerDir+_cSave+cExtensao)

				If lSucess

					//³ Realizo a compactA��o do arquivo para a extensão .mzp
					MsCompress((_cServerDir+_cSave+cExtensao),(_cServerDir+_cSave+".mzp"))

					//³ Apago o arquivo original do servidor
					Ferase( _cServerDir+_cSave+cExtensao)
					Aviso("Anexar Arquivo"; //01 - cTitulo - Título da janela
					,"O Arquivo '"+_cArq+"' foi anexado com sucesso.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina autom�tica
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
					,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
					)
					_cSave += ".mzp"
					_cMsgSave += "===================================" +CHR(13)+CHR(10)
					_cMsgSave += "Documento "+Alltrim(_cArq)+" anexado com sucesso por: " +CHR(13)+CHR(10)
					_cMsgSave += "Usu�rio: "+cUserName+CHR(13)+CHR(10)
					_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
					dbSelectArea("Z49")
					Z49->(dbGoTop())
					While Z49->(!EOF()) .And. cSolicit = Z49->Z49_COD .And. Z49->Z49_FILIAL = xfilial("Z49")
						RecLock("Z49", .F.)
						Z49->Z49_LOG    :=  _cMsgSave   + CHR(13)+ CHR(10) + Z49->Z49_LOG
						Z49->(MsUnlock())
						Z49->( dbSkip() )
					End
				Else
					_cSave := ''
					Aviso("Problema ao Anexar Arquivo"; //01 - cTitulo - Título da janela
					,"O Arquivo '"+_cArq+"' n�o foi anexado."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Favor verificar com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina autom�tica
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
					,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
					)
				EndIf
			Else
				Aviso("Problema com Extensão do Anexo"; //01 - cTitulo - Título da janela
				,"A Extens�o "+cExtensao+" � inv�lida para anexar junto a Solicita��o de Compras."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Anexo n�o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina autom�tica
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
		Aviso("Anexar Arquivo"; //01 - cTitulo - Título da janela
		,"Nenhum Arquivo foi selecionado para ser anexado.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina autom�tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
	Endif

	RestArea(aArea2)
	RestArea(aArea1)

Return(_cSave)



Static Function DelAnexo(_nDel,_cFile,cSolicit)

	Local _cDelete := ''
	Local _lRet    := .T.
	Local _cMsgDel := ""
	Local _cAlias  := Alias()
	Local aArea1   := GetArea()
	Local aArea2   := (_cAlias)->(GetArea())

	If Len(Directory(_cServerDir+_cFile)) = 1
		_lRet := MsgYesNo("Deseja deletar o Arquivo ??? "+ Chr(10) + Chr(13) +" Uma vez confirmada essa a��o o arquivo n�o ficar� mais dispon��vel para consulta.","Aten��o")
	Else
		_lRet := .F.
		Aviso("Deletar Anexo"; //01 - cTitulo - Título da janela
		,"N�o existe nenhum Arquivo para ser deletado."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"Anexo n�o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina autom�tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
	Endif

	If _lRet
		Ferase( _cServerDir+_cFile)
		_cDelete := ''
		_cMsgDel += "===================================" +CHR(13)+CHR(10)
		_cMsgDel += "Documento "+Alltrim(_cFile)+" deletado com sucesso por: " +CHR(13)+CHR(10)
		_cMsgDel += "Usu�rio: "+cUserName+CHR(13)+CHR(10)
		_cMsgDel += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
		dbSelectArea("Z49")
		Z49->(dbGoTop())
		While Z49->(!EOF()) .And. cSolicit = Z49->Z49_COD .And. Z49->Z49_FILIAL = xfilial("Z49")
			RecLock("Z49", .F.)
			Z49->Z49_LOG   :=  _cMsgDel   + CHR(13)+ CHR(10) + Z49->Z49_LOG
			Z49->(MsUnlock())
			Z49->( dbSkip() )
		End
	Else
		_cDelete := _cFile
	Endif

	RestArea(aArea2)
	RestArea(aArea1)

Return (_cDelete)

Static Function OpenAnexo(_nOpen,_cFile,cSolicit,_SubPasta)

	Local _cOpen      := ''
	Local cZipFile    := ''
	Local _cSaveArq   := "C:\ARQUIVOS_PROTHEUS\"
	Local _cLocalDir  := ''
	Local _cStartPath := "arquivos\"
	Local _cStartPath1 := _SubPasta
	Local _lUnzip     := .T.

	// CriA��o das pastas para salvar os anexos das Solicitações de Compras na m�quina Local do usu�rio
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

	_cLocalDir += _cNUm+"\"
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	If ExistDir(_cLocalDir)
		_cOpen   := Strzero(_nOpen,6)+".mzp"
		cZipFile := _cServerDir+_cOpen
		If Len(Directory(cZipFile)) = 1
			CpyS2T  ( cZipFile , _cLocalDir, .T. )
			_lUnzip := MsDecomp( _cLocalDir+_cOpen , _cLocalDir )
			If _lUnzip
				Ferase  ( _cLocalDir+_cOpen)
				ShellExecute("open", _cLocalDir, "", "", 1)
			Else
				Aviso("Erro para Descompactar Anexo"; //01 - cTitulo - Título da janela
				,"Houve erro para Descompactar o Anexo."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina autom�tica
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
				,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
				)
			Endif
		Else
			_cOpen  := _cFile
			Aviso("Anexo inv�lido"; //01 - cTitulo - Título da janela
			,"n�o existe nenhum anexo no Protheus para ser aberto."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"A��o n�o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina autom�tica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
			,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
			)
		Endif
	Else
		Aviso("Erro ao Salvar Anexo"; //01 - cTitulo - Título da janela
		,"Houve erro ao Salvar o Anexo."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina autom�tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
	Endif

Return (_cOpen)

