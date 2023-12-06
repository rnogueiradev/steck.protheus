#INCLUDE "PROTHEUS.CH"
#define CLRF Chr(13)+Chr(10)

/*====================================================================================\
|Programa  | MT410TOK       | Autor | RENATO.OLIVEIRA           | Data | 03/02/2020   |
|=====================================================================================|
|Descri��o | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function MT410TOK()

	Local aArea      := GetArea()
	Local lRet       := .T.
	Local _nPosDepos := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_LOCAL" })
	Local _nX
	Local _lAnexo    := .F.
	Local _nA
	Local nPosCF     := 0
	Local nPosFecEn  := 0
	Local nX         := 0
	Local nY         := 0
	Local nI         := 0
    Local cCfEquiv   := SuperGetMV("ST_CODFISC",.T., "{{ '601' , '601SB' }, { '101' , '101SB' }}" )
    Local cTSEqB2B   := SuperGetMV("ST_TESB2B" ,.T., "{{ '501' , '650' }  , { '   ' , '650' }}" )
    Local cTSEqEXP   := SuperGetMV("ST_TESEXP" ,.T., "{{ '501' , '650' }  , { '   ' , '650' }}" )
    Local cTSEqOBS   := SuperGetMV("ST_TESOBS" ,.T., "{{ '501' , '652' }  , { '   ' , '652' }}" )
    Local cBodgEXP   := SuperGetMV("ST_BODGEX" ,.T., "01" )
    Local cBodgNAC   := SuperGetMV("ST_BODGNC" ,.T., "03" )
    Local aCfEquiv   := &(" "+cCfEquiv+" ")
	

	/*/
	For _nX:=1 To Len(aCols)
		If  ( aCols[_nX,_nPosDepos] $ "02") .And. ( AllTrim(SA1->A1_PAIS)=="169" .And. Empty(SA1->A1_SUFRAMA) )
			lRet := .F.
			MsgAlert("Atenci�n, el sitio 02 ha sido seleccionado para clientes nacionales!")
		Else
			lRet := .T.
		EndIf
	Next

	If M->C5_XDTDES<M->C5_XDTFAT
		lRet := .F.
		MsgAlert("Fecha de env�o menor que la fecha de la factura!")
	EndIf
	/*/
	If IsInCallStack("MATA410")
		//If Empty(M->C5_XDTFAT)
		//	MsgAlert("Complete la fecha de facturaci�n!")
		//	Return(.F.)
		//EndIf
		if Empty(M->C5_CODMUN)    // Valdemir Rabelo 27/06/2023
			MsgAlert("El campo "+FWX3Titulo('C5_CODMUN')+" no puede estar vac�o")
			Return(.F.)
		Endif 
		If Empty(M->C5_XDTDES)
			MsgAlert("Complete la fecha de despacho!")
			Return(.F.)
		EndIf
		If Empty(M->C5_XNOMECT)
			MsgAlert("Complete el nombre del contacto!")
			Return(.F.)
		EndIf
		If Empty(M->C5_XCED)
			MsgAlert("Complete la cedula!")
			Return(.F.)
		EndIf
		If Empty(M->C5_XENDENT)
			MsgAlert("Complete la direcci�n de entrega!")
			Return(.F.)
		EndIf
		If Empty(M->C5_XCIUD)
			MsgAlert("Complete la ciudad!")
			Return(.F.)
		EndIf
		If Empty(M->C5_XHORA)
			MsgAlert("Complete el tiempo de entrega!")
			Return(.F.)
		EndIf
		If Empty(M->C5_XORDEM)
			MsgAlert("Complete la orden de compra!")
			Return(.F.)
		EndIf
		If Empty(M->C5_XCODM)
			MsgAlert("Complete la ciudad!")
			Return(.F.)
		EndIf
		If Empty(M->C5_XTEL)
			MsgAlert("Complete el N�mero de telefono!")
			Return(.F.)
		EndIf

		IF M->C5_XTPED $ 'BxE'
			IF M->C5_MOEDA == 1
				MsgAlert("La moneda seleccionada es Pesos Colombianos, pero el Pedido no es Nacional!")
				Return(.F.)
			ENDif
			If M->C5_XTPED $ 'B' 
				IF EMPTY(M->C5_XFORNEC) .OR. EMPTY(M->C5_XDOC) .OR. EMPTY(M->C5_XLOJA)
                    MSGINFO( "Los Pedidos Back to Back deben tener diligenciado los campos de la carpeta BackToBack", "Campo(s) vacios(s)" )  
                    Return (.F.)
                ENDIF
			EndIf
		EndIf
		nPosFecEn    := AScan(aHeader,{|x| AllTrim(x[2]) == 'C6_ENTREG'})  
		For nI:=1 to len(aCols)
			aCols[nI][nPosFecEn]:=M->C5_FECENT
		Next

        IF SA1->A1_XFULLRT=='2' // Full Retenciones sin base y cambia el Codigo Fiscal
            /*
				Removido conforme novas regras passada por Jaqueline - Valdemir Rabelo 27/06/2023
			nPosCF := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})
            FOR nX:=1 to Len(aCfEquiv)
                cCFa:=aCfEquiv[nX][1]
                cCFb:=aCols[n][nPosCF]
				For nY:=1 to len(aCols)
					IF ALLTRIM(aCfEquiv[nX][1])==ALLTRIM(aCols[nY][nPosCF]) .AND. !EMPTY(ALLTRIM(aCfEquiv[nX][2]))
						aCols[nY][nPosCF]:= LEFT(ALLTRIM(aCfEquiv[nX][2])+SPACE(5),5)
					EndIf
				Next
            NEXT
			*/
        EndIf
	EndIf

	/*/
	If lRet

		//Libera��o automatica do pedido
		If !IsInCallStack("A410Deleta") .Or. !IsInCallStack("Ma410Resid")

			_nQTDENT := 0

			nPos1 := aScan(aHeader,{|x| AllTrim(x[2]) = "C6_QTDVEN"})
			nPos3 := aScan(aHeader,{|x| AllTrim(x[2]) = "C6_QTDLIB"})
			nPos5 := aScan(aHeader,{|x| AllTrim(x[2]) = "C6_ITEM"})
			nPos6 := aScan(aHeader,{|x| AllTrim(x[2]) = "C6_PRODUTO"})
			nPos7 := aScan(aHeader,{|x| AllTrim(x[2]) = "C6_PROVENT"})

			If nPos3 > 0 .And. nPos5 > 0 .And. nPos6 > 0

				DbSelectArea("SC6")
				SC6->(DbGoTop())
				SC6->(DbSetOrder(1))//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO

				For _nA := 1 to len(aCols)

					If nPos7>0
						aCols[_nA,nPos7] := ""
					EndIf

					_nQTDENT  := 0

					If SC6->(DbSeek(xFilial("SC6")+M->C5_NUM+aCols[_nA,nPos5]))
						_nQTDENT  := SC6->C6_QTDENT
					Endif

					aCols[_nA,nPos3] := aCols[_nA,nPos1]-(_nQTDENT)

				Next _nA

			EndIf

		EndIf

	EndIf
	/*/

	If !AllTrim(M->C5_XTPED)=="B"
		While !_lAnexo
			Anexar()
			_lAnexo := File("\arquivos\oc_pedidos\"+cEmpAnt+"\"+cFilAnt+"\"+M->C5_NUM+"\000001.mzp")
		EndDo
	EndIf

	Restarea(aArea)

Return (lRet)

/*====================================================================================\
|Programa  | Anexar         | Autor | RENATO.OLIVEIRA           | Data | 03/02/2020   |
|=====================================================================================|
|Descri��o | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

Static Function Anexar()

	Local aArea       := GetArea()
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
	Local cSolicit	  := M->C5_NUM

	Private _cPath      := GetSrvProfString("RootPath","")
	Private _cStartPath := "\arquivos\oc_pedidos\"
	Private _cEmp       := "" + cEmpAnt + "\"
	Private _cFil       := "" + xFilial("SC5") + "\"
	Private _cNUm       := "" + M->C5_NUM   + "\"
	Private _cServerDir   := ''

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

		If Len(Directory(_cServerDir+Strzero(1,6)+".mzp")) = 1
			_cAne01 := Strzero(1,6)+".mzp"
		Else
			_cAne01 := space(90)
		Endif

		dDtEmiss   := M->C5_EMISSAO
		cNameSolic := cUserName

		Do While !lSaida

			nOpcao := 0

			Define msDialog oDxlg Title "Seleccionar orden de compra " From 10,10 TO 450,600 Pixel
			_nLin := 005
			@ _nLin,010 say "Filial" COLOR CLR_BLACK  Of oDxlg Pixel
			@ _nLin,040 get xFilial("SC5") when .f. size 050,08  Of oDxlg Pixel

			@ _nLin,110 say "Data" COLOR CLR_BLACK   Of oDxlg Pixel
			@ _nLin,140 get  dDtEmiss  when .f. size 090,08  Of oDxlg Pixel

			_nLin := _nLin + 10
			@ _nLin,010 say "Pedido" COLOR CLR_BLACK    Of oDxlg Pixel
			@ _nLin,040 get cSolicit  when .f. size 050,08  Of oDxlg Pixel

			@ _nLin,110 say "Solicitante" COLOR CLR_BLACK   Of oDxlg Pixel
			@ _nLin,140 get  cNameSolic  when .f. size 090,08  Of oDxlg Pixel

			_nLin := _nLin + 20
			@ _nLin,010 Say "Anexo - 01"   COLOR CLR_HBLUE  Of oDxlg Pixel
			_nLin := _nLin + 10
			@ _nLin,010 get _cAne01     when .f.   size 165,08  Of oDxlg Pixel
			@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne01:=SaveAnexo(1,_cAne01,cSolicit)) Of oDxlg Pixel
			@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne01:=DelAnexo (1,_cAne01,cSolicit)) Of oDxlg Pixel
			@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne01:=OpenAnexo(1,_cAne01,cSolicit)) Of oDxlg Pixel

			_nLin := _nLin + 20

			DEFINE SBUTTON FROM _nLin,130 TYPE 1 ACTION (lSaida:=.T.,nOpcao:=1,oDxlg:End()) ENABLE OF oDxlg

			Activate dialog oDxlg centered

		EndDo
	Else
		MsgAlert("Atenci�n: no se pudo crear la estructura de directorios en el server : "+ _cServerDir, "Llame al administrador de Protheus")
	Endif

	RestArea(aArea)

Return()

Static Function SaveAnexo(_nSave,_cFile,cSolicit)

	Local _cSave := ''
	Local _lRet     := .T.
	Local _cLocArq  := ''
	Local _cDir     := ''
	Local _cArq     := ''
	Local cExtensao := ''
	Local nTamOrig  := ''
	Local nMB       := 1024
	Local nTamMax   := 10
	Local cMascara  := "Todos los arquivos"
	Local cTitulo   := "Seleccione el archivo"
	Local nMascpad  := 0
	Local cDirini   := "c:\"
	Local lSalvar   := .T. /*.F. = Salva || .T. = Abre*/
	Local lArvore   := .F. /*.T. = apresenta o �rvore do servidor || .F. = não apresenta*/
	Local _cMsgSave := ""
	Local aArea1    := GetArea()

	_cLocArq  := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar,, lArvore)

	If !(Empty(_cLocArq))
		nTamOrig := Directory(_cLocArq)[1,2]
		If (nTamOrig/nMB) > (nMB*nTamMax)
			Aviso("Tama�o del archivo es superior al permitido"; //01 - cTitulo - Título da janela
			,"El Archivo '"+_cArq+"' tiene que tener un tama�o m�ximo de "+cValtoChar(nTamMax)+"MB."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
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
			_lRet := MsgYesNo("J� existe um arquivo anexado."+ Chr(10) + Chr(13) +" Deseja sobrepor o arquivo existente ???","Atenção")
		Endif

		If _lRet

			_cLocArq  := Alltrim(_cLocArq)
			_cDir     := SUBSTR(_cLocArq, 1                      ,RAT( "\"   , _cLocArq ))
			_cArq     := SUBSTR(_cLocArq, RAT( "\"   , _cLocArq ),Len(_cLocArq))
			_cArq     := StrTran(_cArq,"\","")
			cExtensao := SUBSTR(_cLocArq,Rat(".",_cLocArq),Len(_cLocArq))

			If At(".",cExtensao) == 1

				_cSave := Strzero(_nSave,6)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Copio o arquivo original da m�quina do usu�rio para o servidor
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lSucess   := __CopyFile(_cLocArq,_cServerDir+_cSave+cExtensao)

				If lSucess

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Realizo a compactação do arquivo para a extensão .mzp
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					MsCompress((_cServerDir+_cSave+cExtensao),(_cServerDir+_cSave+".mzp"))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Apago o arquivo original do servidor
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Ferase( _cServerDir+_cSave+cExtensao)
					Aviso("Anexar Archivo"; //01 - cTitulo - Título da janela
					,"El Archivo '"+_cArq+"' fue anexado con exito.",; //02 - cMsg - Texto a ser apresentado na janela.
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
					_cMsgSave += "Documento "+Alltrim(_cArq)+" anexado con exito por: " +CHR(13)+CHR(10)
					_cMsgSave += "Usuario: "+cUserName+CHR(13)+CHR(10)
					_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
					/*
					dbSelectArea("Z1O")
					Z1O->(dbGoTop())
					While Z1O->(!EOF()) .And. cSolicit = Z1O->Z1O_COD .And. Z1O->Z1O_FILIAL = xfilial("Z1O")
					RecLock("Z1O", .F.)
					Z1O->Z1O_LOG    :=  _cMsgSave   + CHR(13)+ CHR(10) + Z1O->Z1O_LOG
					Z1O->(MsUnlock())
					Z1O->( dbSkip() )
					End
					*/
				Else
					_cSave := ''
					Aviso("Problema ao Anexar Arquivo"; //01 - cTitulo - Título da janela
					,"O Arquivo '"+_cArq+"' não foi anexado."+ Chr(10) + Chr(13) +;
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
				,"A Extensão "+cExtensao+" é inv�lida para anexar junto a Solicitação de Compras."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
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

	RestArea(aArea1)

Return(_cSave)

Static Function DelAnexo(_nDel,_cFile,cSolicit)

	Local _cDelete := ''
	Local _lRet    := .T.
	Local _cMsgDel := ""
	Local aArea1   := GetArea()

	If Len(Directory(_cServerDir+_cFile)) = 1
		_lRet := MsgYesNo("Deseja deletar o Arquivo ??? "+ Chr(10) + Chr(13) +" Uma vez confirmada essa ação o arquivo não ficar� mais disponível para consulta.","Atenção")
	Else
		_lRet := .F.
		Aviso("Deletar Anexo"; //01 - cTitulo - Título da janela
		,"Não existe nenhum Arquivo para ser deletado."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
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
		/*
		dbSelectArea("Z1O")
		Z1O->(dbGoTop())
		While Z1O->(!EOF()) .And. cSolicit = Z1O->Z1O_COD .And. Z1O->Z1O_FILIAL = xfilial("Z1O")
		RecLock("Z1O", .F.)
		Z1O->Z1O_LOG   :=  _cMsgDel   + CHR(13)+ CHR(10) + Z1O->Z1O_LOG
		Z1O->(MsUnlock())
		Z1O->( dbSkip() )
		End
		*/
	Else
		_cDelete := _cFile
	Endif

	RestArea(aArea1)

Return (_cDelete)

Static Function OpenAnexo(_nOpen,_cFile,cSolicit)

	Local _cOpen      := ''
	Local cZipFile    := ''
	Local _cSaveArq   := "C:\ARQUIVOS_PROTHEUS\"
	Local _cLocalDir  := ''
	Local _cStartPath := "arquivos\"
	Local _cStartPath1 := "oc_pedidos\"
	Local _lUnzip     := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criação das pastas para salvar os anexos das Solicitações de Compras na m�quina Local do usu�rio
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

	_cLocalDir += _cEmp+"\"
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += _cFil+"\"
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
			,"Não existe nenhum anexo no Protheus para ser aberto."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
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


/*/{Protheus.doc} VLDCODMUN
Rotina utilizada para acionar gatilho
Atualizando conforme necessidade
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 26/06/2023
@return variant, l�gico
/*/
User Function VLDCODMUN()
	RUNTRIGGER(1,,,,'C5_CLIENTE')
RETURN .T.
