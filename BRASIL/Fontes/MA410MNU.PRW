#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

#define GD_INSERT 1
#define GD_UPDATE 2
#define GD_DELETE 4

/*====================================================================================\
|Programa  | MA410MNU         | Autor | GIOVANI.ZAGO             | Data | 17/01/2013  |
|=====================================================================================|
|Descri��o |   P.E. MA410MNU				     	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MA410MNU                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

*-----------------------------*
User Function MA410MNU()
	*-----------------------------*
	Local _cuserRej := GetMv("ST_REJFIN",,'000000')
	Local _cUsers   := GetMv("ST_ALSC5DT")
	local cUserArm  := SuperGetMV("MV_B002001", .F., "")

	Local _cUsersFis  := AllTrim(GetMv("ST_USRFISC"))

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		If 'MATA410' $ FUNNAME()
			aRotina := U_STMENU361(aRotina)
		EndIf
		//Solicita prazo de entrega unicon 18/08/17 giovani zago chamado 005809
		aadd( aRotina, {"Prazo Unicom","U_STUNIC03(SC5->C5_NUM)",0,2,0,NIL} )

		aadd( aRotina, {"E-mail Finan.","U_STFINEMAIL(SC5->C5_NUM)",0,2,0,NIL} )

		aadd( aRotina, {"Tracking P.V.","U_STTRACKING(SC5->C5_NUM)",0,2,0,NIL} )
		aadd( aRotina, {"Anexos","U_YPVSTANEX(.t.)",0,2,0,NIL} )

		aadd( aRotina, {"Imprimir","U_RSTFAT09(SC5->C5_NUM)",0,2,0,NIL} ) //Inclu�do em 29/07/2013 por Jo�o Victor

		If __cUserId $ _cUsers
			aadd( aRotina, {"Alterar data","U_STSC5DTA(SC5->C5_NUM)",0,2,0,NIL} ) //Renato Nogueira - 09/02/2014
		EndIf

		If __cuserid $ _cuserRej
			aadd( aRotina, {"Mot.Rejei��o","U_STALTREJ(SC5->C5_NUM)",0,2,0,NIL} ) //Inclu�do em 29/07/2013 por Jo�o Victor
		EndIf
		//aadd( aRotina, {"Fiscal"       ,"U_STPEDFIS(SC5->C5_NUM)"  ,0,2,0,NIL} ) Excluido para a usu�ria Ver�nica n�o efetC5r altera��o de TES por essa rotina.

		AADD( aRotina, {"Exportar Excel","U_STSC5EXL()",0,2,0,NIL} )
		AADD( aRotina, {"Solicitar novo prazo","U_STNEWPRZ()",0,2,0,NIL} )
		If __cuserid $ '000000/000645/000294'
			AADD( aRotina, {"Wf Metas","U_STM10()",0,2,0,NIL} )
		EndIf

		AADD( aRotina, {"Troca Vendedor","U_STTRVEN()",0,2,0,NIL} )
		AADD( aRotina, {"Markup","U_STFSVE39(.T.,.F.,'SC6')",0,2,0,NIL} )
		AADD( aRotina, {"Reserva Manual","U_MSTECK19()",0,2,0,NIL} )

		if __cUserId $ cUserArm .and. findFunction("U_B0002001")
			AADD( aRotina, {"Reproc.Armaz�m Cli.","U_B0002001()",0,2,0,NIL} )
		endif

		If __cUserId $ _cUsersFis
			aAdd(aRotina, {"Altera RICMS-ST", "U_RICMSST()", 0, 2, 0, Nil})
		EndIf

	EndIf
Return()

/*====================================================================================\
|Programa  | STSC5EXL         | Autor | GIOVANI.ZAGO             | Data | 17/01/2013  |
|=====================================================================================|
|Descri��o |   P.E. MA410MNU				     	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MA410MNU                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function STSC5EXL()

	Local aArea		:= GetArea()

	Local aCabec		:= {}
	Local aDados		:= {}

	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel n�o instalado!")
		Return
	EndIf

	aCabec := {"Filial","Item","Num","Produto","QC5nt","Valor","Total"}

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->(DbGoTop())
	SC6->(DbSeek(SC5->(C5_FILIAL+C5_NUM)))
	While SC6->(!Eof()) .And. SC6->(C6_FILIAL+C6_NUM)==SC5->(C5_FILIAL+C5_NUM)
		AAdd(aDados, {SC6->C6_FILIAL,SC6->C6_ITEM,SC6->C6_NUM,SC6->C6_PRODUTO,CVALTOCHAR(SC6->C6_QTDVEN),CVALTOCHAR(SC6->C6_PRCVEN),CVALTOCHAR(SC6->C6_VALOR)})
		SC6->(DbSkip())
	EndDo

	DlgToExcel({ {"ARRAY", "PEDIDO", aCabec, aDados} })

	RestArea(aArea)

Return()

User Function YPVSTANEX(_lT)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declara��o das Vari�veis
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aArea       := GetArea()
	Local aArea1      := SC5->(GetArea())

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
	Local cSolicit	  := 	SC5->C5_NUM

	Private _cPath      := GetSrvProfString("RootPath","")
	Private _cStartPath := "\PEDIDOSANEXOS\"
	Private _cEmp       := ""+cEmpAnt+"\"
	Private _cFil       := ""+SC5->C5_FILIAL+"\"
	Private _cNUm       := ""+cSolicit+"\"
	Private _cServerDir   := ''
	Default _lT := .f.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria��o das pastas para salvar os anexos das Solicitações de Compras no Servidor
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+cSolicit))
			dDtEmiss   := SC5->C5_EMISSAO
			cNameSolic := SC5->C5_XNOME

			Do While !lSaida
				nOpcao := 0

				Define msDialog oDxlg Title "Selecione os Anexos " From 10,10 TO 450,600 Pixel
				_nLin := 005
				@ _nLin,010 say "Filial" COLOR CLR_BLACK  Of oDxlg Pixel
				@ _nLin,040 get xFilial("SC5") when .f. size 050,08  Of oDxlg Pixel

				@ _nLin,110 say "Emiss�o" COLOR CLR_BLACK   Of oDxlg Pixel
				@ _nLin,140 get  dDtEmiss  when .f. size 090,08  Of oDxlg Pixel

				_nLin := _nLin + 10
				@ _nLin,010 say "Or�amento" COLOR CLR_BLACK    Of oDxlg Pixel
				@ _nLin,040 get cSolicit  when .f. size 050,08  Of oDxlg Pixel

				@ _nLin,110 say "Cliente" COLOR CLR_BLACK   Of oDxlg Pixel
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

			EndDo

		EndIf

	Endif

	RestArea(aArea1)
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
	Local nTamMax   := 2
	Local cMascara  := "Todos os arquivos"
	Local cTitulo   := "Escolha o arquivo"
	Local nMascpad  := 0
	Local cDirini   := "c:\"
	Local lSalvar   := .T. /*.F. = Salva || .T. = Abre*/
	Local lArvore   := .F. /*.T. = apresenta o �rvore do servidor || .F. = n�o apresenta*/
	Local _cMsgSave := ""
	Local aArea1    := GetArea()
	Local aArea2    := SC5->(GetArea())

	_cLocArq  := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar,, lArvore)

	If !(Empty(_cLocArq))
		nTamOrig := Directory(_cLocArq)[1,2]
		If (nTamOrig/nMB) > (nMB*nTamMax)
			Aviso("Tamanho do Arquivo Superior ao Permitido"; //01 - cTitulo - Título da janela
			,"O Arquivo '"+_cArq+"' tem que ter tamanho m�ximo de "+cValtoChar(nTamMax)+"MB."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"A��o n�o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
			,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
			)
			Return
		EndIf

		If Len(Directory(_cServerDir+Strzero(_nSave,6)+".mzp")) = 1
			_lRet := MsgYesNo("J� existe um arquivo anexado."+ Chr(10) + Chr(13) +" Deseja sobrepor o arquivo existente ???","Aten��o")
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
					//³ Realizo a compacta��o do arquivo para a extens�o .mzp
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					MsCompress((_cServerDir+_cSave+cExtensao),(_cServerDir+_cSave+".mzp"))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Apago o arquivo original do servidor
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Ferase( _cServerDir+_cSave+cExtensao)
					Aviso("Anexar Arquivo"; //01 - cTitulo - Título da janela
					,"O Arquivo '"+_cArq+"' foi anexado com sucesso.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
					,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
					)
					_cSave += ".mzp"
					_cMsgSave += "===================================" +CHR(13)+CHR(10)
					_cMsgSave += "Documento "+Alltrim(_cArq)+" anexado com sucesso por: " +CHR(13)+CHR(10)
					_cMsgSave += "Usu�rio: "+cUserName+CHR(13)+CHR(10)
					_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)

					dbSelectArea("SC5")
					RecLock("SC5", .F.)
					SC5->C5_XHISTOR   :=  _cMsgSave   + CHR(13)+ CHR(10) + Alltrim(SC5->C5_XHISTOR)
					SC5->(MsUnlock())

				Else
					_cSave := ''
					Aviso("Problema ao Anexar Arquivo"; //01 - cTitulo - Título da janela
					,"O Arquivo '"+_cArq+"' n�o foi anexado."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Favor verificar com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
					,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
					)
				EndIf
			Else
				Aviso("Problema com Extens�o do Anexo"; //01 - cTitulo - Título da janela
				,"A Extens�o "+cExtensao+" é inv�lida para anexar junto a Solicita��o de Compras."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"A��o n�o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
				,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
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
		,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
		,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
		)
	Endif

	RestArea(aArea2)
	RestArea(aArea1)

Return(_cSave)

Static Function DelAnexo(_nDel,_cFile,cSolicit)

	Local _cDelete := ''
	Local _lRet    := .T.
	Local _cMsgDel := ""
	Local aArea1   := GetArea()
	Local aArea2   := SC5->(GetArea())

	If Len(Directory(_cServerDir+_cFile)) = 1
		_lRet := MsgYesNo("Deseja deletar o Arquivo ??? "+ Chr(10) + Chr(13) +" Uma vez confirmada essa a��o o arquivo n�o ficar� mais disponível para consulta.","Aten��o")
	Else
		_lRet := .F.
		Aviso("Deletar Anexo"; //01 - cTitulo - Título da janela
		,"N�o existe nenhum Arquivo para ser deletado."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"A��o n�o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
		,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
		)
	Endif

	If _lRet
		Ferase( _cServerDir+_cFile)
		_cDelete := ''
		_cMsgDel += "===================================" +CHR(13)+CHR(10)
		_cMsgDel += "Documento "+Alltrim(_cFile)+" deletado com sucesso por: " +CHR(13)+CHR(10)
		_cMsgDel += "Usu�rio: "+cUserName+CHR(13)+CHR(10)
		_cMsgDel += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
		dbSelectArea("SC5")
		RecLock("SC5", .F.)
		SC5->C5_XHISTOR   :=  _cMsgDel   + CHR(13)+ CHR(10) + Alltrim(SC5->C5_XHISTOR)
		SC5->(MsUnlock())

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
	Local _lUnzip     := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria��o das pastas para salvar os anexos das Solicitações de Compras na m�quina Local do usu�rio
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cLocalDir += (_cSaveArq)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += (_cStartPath)
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
				,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
				,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
				)
			Endif
		Else
			_cOpen  := _cFile
			Aviso("Anexo inv�lido"; //01 - cTitulo - Título da janela
			,"N�o existe nenhum anexo no Protheus para ser aberto."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"A��o n�o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
			,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
			)
		Endif
	Else
		Aviso("Erro ao Salvar Anexo"; //01 - cTitulo - Título da janela
		,"Houve erro ao Salvar o Anexo."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
		,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
		)
	Endif

Return (_cOpen)

/*====================================================================================\
|Programa  | STNEWPRZ        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descri��o | Solicitar novo prazo para atendimento do item                            |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function STNEWPRZ()

	Local _cQuery1 		:= ""
	Local _cAlias1 	 	:= GetNextAlias()
	Local aCampoEdit    := {}
	Local _nX			:= 0
	Local _lExistZ15	:= .F.
	Local _lAltera		:= .F.
	Local _lPrim		:= .T.
	Local lSaida   		:= .T.
	Local lConfirma		:= .F.

	Local _cAssunto := ""
	Local cFuncSent := "STNEWPRZ"
	Local _aMsg     := {}
	Local i         := 0
	Local cArq      := ""
	Local cMsg      := ""
	Local _nLin
	Local _cCopia  := ""
	Local cAttach  := ""
	Local _cEmail  := "renato.oliveira@steck.com.br"
	Local _aItens  := {}
	Local nY

	Private	_oWindow,;
	oFontWin,;
	_aHead				:= {},;
	_bOk 				:= {||(	lSaida:=.f., lConfirma:=.T.,_oWindow:End()) },;
	_bCancel 	    	:= {||(	lSaida:=.f.,_oWindow:End()) },;
	_aButtons	    	:= {},;
	_oGet,;
	_oGet2
	Private _aHeader	:= {}
	Private _aCols		:= {}

	If SC5->C5_ZFATBLQ == '1'.Or. ('XXXX' $ SC5->C5_NOTA)
		MsgAlert("Aten��o, pedido "+AllTrim(SC5->C5_NUM)+" faturado totalmente e n�o pode ser alterado!")
		Return
	EndIf

	Aadd(_aHeader,{"Item"					,"ITEM"		,"@!"						,TamSx3("C6_ITEM")[1],0,"",,"C","R"})
	Aadd(_aHeader,{"Produto"				,"PROD"		,"@!"						,TamSx3("C6_PRODUTO")[1],0,"",,"C","R"})
	Aadd(_aHeader,{"Status"					,"STATUS"	,"@!"						,10,0,"",,"C","R"})
	Aadd(_aHeader,{"Saldo"					,"SALDO"	,"@E 999,999,999.99"		,TamSx3("C6_QTDVEN")[1],0,"",,"N","R"})
	Aadd(_aHeader,{"Data prev."				,"DTPRV"	,"@!"						,10,0,"",,"D","R"})
	Aadd(_aHeader,{"Nova data sugerida"		,"DTSUG"	,"@!"						,10,0,"",,"D","R"})
	Aadd(_aHeader,{"Aprovada?"				,"APROV"	,"@!"						,03,0,"",,"D","R"})
	Aadd(_aHeader,{"Nova data fixada"		,"DTFIX"	,"@!"						,10,0,"",,"D","R"})
	Aadd(_aHeader,{"Observa��o vendas"		,"OBS1"		,"@!"						,10,0,"",,"M","R"})
	Aadd(_aHeader,{"Observa��o f�brica"		,"OBS2"		,"@!"						,10,0,"",,"M","R"})
	Aadd(_aHeader,{"Compromisso"			,"COMP"		,"@!"						,TamSx3("C6_XPREV")[1],0,"",,"C","R"})

	_nPosItem := aScan(_aHeader,{|x| AllTrim(x[2]=="ITEM")})
	_nPosProd := aScan(_aHeader,{|x| AllTrim(x[2]=="PROD")})
	_nPosSald := aScan(_aHeader,{|x| AllTrim(x[2]=="SALDO")})
	_nPosDtPr := aScan(_aHeader,{|x| AllTrim(x[2]=="DTPRV")})
	_nPosDtSu := aScan(_aHeader,{|x| AllTrim(x[2]=="DTSUG")})
	_nPosDtFi := aScan(_aHeader,{|x| AllTrim(x[2]=="DTFIX")})
	_nPosObs1 := aScan(_aHeader,{|x| AllTrim(x[2]=="OBS1")})
	_nPosObs2 := aScan(_aHeader,{|x| AllTrim(x[2]=="OBS2")})
	_nPosComp := aScan(_aHeader,{|x| AllTrim(x[2]=="COMP")})
	_nPosStat := aScan(_aHeader,{|x| AllTrim(x[2]=="STATUS")})
	_nPosApro := aScan(_aHeader,{|x| AllTrim(x[2]=="APROV")})

	_cQuery1  := " SELECT C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_QTDENT, C6_ZENTRE2, C6_XPREV,
	_cQuery1  += " NVL(Z16_DTSUG,' ') Z16_DTSUG, NVL(Trim( UTL_RAW.CAST_TO_VARCHAR2( DBMS_LOB.SUBSTR( Z16_OBSRET,2000 ) ) ),' ') Z16_OBSRET, NVL(Z16_NOVADT,' ') Z16_NOVADT,
	_cQuery1  += " NVL(trim( UTL_RAW.CAST_TO_VARCHAR2( DBMS_LOB.SUBSTR( Z16_MSG,2000 ) ) ),' ') Z16_MSG, NVL(Z15_STATUS,' ') Z15_STATUS
	_cQuery1  += " ,NVL(Z16_ATENDE,' ') Z16_ATENDE
	_cQuery1  += " FROM " +RetSqlName("SC6")+ " C6
	_cQuery1  += " LEFT JOIN "+RetSqlName("Z15")+" Z15
	_cQuery1  += " ON C6_FILIAL=Z15_FILIAL AND C6_NUM=Z15_PEDIDO AND C6_CLI=Z15_CLIENT AND C6_LOJA=Z15_LOJA AND Z15.D_E_L_E_T_=' '
	_cQuery1  += " LEFT JOIN "+RetSqlName("Z16")+" Z16
	_cQuery1  += " ON Z16_FILIAL=Z15_FILIAL AND Z16_DOC=Z15_DOC AND Z16_ITEM=C6_ITEM AND Z16.D_E_L_E_T_=' '
	_cQuery1  += " WHERE C6.D_E_L_E_T_=' ' AND C6_FILIAL='"+SC5->C5_FILIAL+"' AND C6_NUM='"+SC5->C5_NUM+"'"
	_cQuery1  += " AND C6_XPREV<>' '

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_aCols		:= {}
	_nModo 		:= GD_UPDATE

	If (_cAlias1)->(!Eof())
		If Empty((_cAlias1)->Z15_STATUS) .Or. (_cAlias1)->Z15_STATUS=="0"
			_lAltera := .T.
		EndIf
	Else
		_lAltera := .T.
	EndIf

	aCampoEdit := {"DTSUG","OBS1","OBS2"}

	While (_cAlias1)->(!Eof())

		AADD(_aCols,Array(Len(_aHeader)+1))

		For nY := 1 To Len(_aHeader)

			DO CASE

				CASE AllTrim(_aHeader[nY][2]) =  "ITEM"
				_aCols[Len(_aCols)][nY] := (_cAlias1)->C6_ITEM
				CASE AllTrim(_aHeader[nY][2]) =  "PROD"
				_aCols[Len(_aCols)][nY] := (_cAlias1)->C6_PRODUTO
				CASE AllTrim(_aHeader[nY][2]) =  "SALDO"
				_aCols[Len(_aCols)][nY] := (_cAlias1)->(C6_QTDVEN-C6_QTDENT)
				CASE AllTrim(_aHeader[nY][2]) =  "DTPRV"
				_aCols[Len(_aCols)][nY] := STOD((_cAlias1)->C6_ZENTRE2)
				CASE AllTrim(_aHeader[nY][2]) =  "DTSUG"
				_aCols[Len(_aCols)][nY] := IIf(!Empty((_cAlias1)->Z16_DTSUG),STOD((_cAlias1)->Z16_DTSUG),CTOD("  /  /    "))
				CASE AllTrim(_aHeader[nY][2]) =  "DTFIX"
				_aCols[Len(_aCols)][nY] := IIf(!Empty((_cAlias1)->Z16_NOVADT),STOD((_cAlias1)->Z16_NOVADT),CTOD("  /  /    "))
				CASE AllTrim(_aHeader[nY][2]) =  "OBS1"
				_aCols[Len(_aCols)][nY] := IIf(!Empty((_cAlias1)->Z16_MSG),(_cAlias1)->Z16_MSG,"")
				CASE AllTrim(_aHeader[nY][2]) =  "OBS2"
				_aCols[Len(_aCols)][nY] := IIf(!Empty((_cAlias1)->Z16_OBSRET),(_cAlias1)->Z16_OBSRET,"")
				CASE AllTrim(_aHeader[nY][2]) =  "COMP"
				_aCols[Len(_aCols)][nY] := (_cAlias1)->C6_XPREV
				CASE AllTrim(_aHeader[nY][2]) =  "STATUS"
				_aCols[Len(_aCols)][nY] := GETDESC1((_cAlias1)->Z15_STATUS)
				CASE AllTrim(_aHeader[nY][2]) =  "APROV"

				If !Empty((_cAlias1)->Z16_ATENDE)
					_aCols[Len(_aCols)][nY] := IIf((_cAlias1)->Z16_ATENDE=="S","Sim","N�o")
				Else
					_aCols[Len(_aCols)][nY] := ""
				EndIf

			ENDCASE

		Next

		_aCols[Len(_aCols)][Len(_aHeader)+1] := .F.

		(_cAlias1)->(DbSkip())
	EndDo

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	DbSelectArea("Z15")
	Z15->(DbSetOrder(2))

	DbSelectArea("Z16")
	Z16->(DbSetOrder(2))

	DEFINE MSDIALOG _oWindow FROM 0,0 TO 400,1200/*500,1200*/ TITLE Alltrim(OemToAnsi('Pedido: '+SC5->C5_NUM+' - Prazos')) Pixel //430,531
	_oGet	:= MsNewGetDados():New(35,0,_oWindow:nClientHeight/2-20,_oWindow:nClientWidth/2-5,_nModo,"AllWaysTrue()","AllWaysTrue()",,aCampoEdit,,Len(_aCols),,, ,_oWindow,_aHeader,_aCols)
	_oGet:SetArray(_aCols)
	_oWindow:Refresh()
	_oGet:Refresh()
	MsNewGetDados():SetEditLine (.T.)
	ACTIVATE MSDIALOG _oWindow CENTERED ON INIT EnchoiceBar(_oWindow,_bOk,_bCancel,,_aButtons)

	aDados := aClone(_oGet:aCols)

	If lConfirma .And. _lAltera

		Begin Transaction

			For _nX:=1 To Len(aDados)

				If !Empty(aDados[_nX][_nPosDtSu])

					If _lPrim

						_lPrim := .F.

						If Z15->(DbSeek(xFilial("Z15")+SC5->C5_NUM))
							Z15->(RecLock("Z15",.F.))
							Z15->Z15_SOLIC	:= cUserName
							Z15->Z15_DTSOLIC:= Date()
							Z15->Z15_HRSOLI	:= Time()
						Else
							_cNumDoc := GETSX8NUM("Z15","Z15_DOC")
							Z15->(RecLock("Z15",.T.))
							Z15->Z15_FILIAL := SC5->C5_FILIAL
							Z15->Z15_DOC	:= _cNumDoc
							Z15->Z15_PEDIDO	:= SC5->C5_NUM
							Z15->Z15_CLIENT	:= SC5->C5_CLIENTE
							Z15->Z15_LOJA	:= SC5->C5_LOJACLI
							Z15->Z15_SOLIC	:= cUserName
							Z15->Z15_DTSOLIC:= Date()
							Z15->Z15_HRSOLI	:= Time()
						EndIf

						Z15->Z15_STATUS := "0"
						Z15->(MsUnLock())

					EndIf

					SB1->(DbSeek(xFilial("SB1")+aDados[_nX][_nPosProd]))

					If Z16->(DbSeek(Z15->(Z15_FILIAL+Z15_DOC)+aDados[_nX][_nPosItem]))
						Z16->(RecLock("Z16",.F.))
					Else
						Z16->(RecLock("Z16",.T.))
						Z16->Z16_FILIAL := SC5->C5_FILIAL
						Z16->Z16_DOC	:= Z15->Z15_DOC
						Z16->Z16_ITEM	:= aDados[_nX][_nPosItem]
						Z16->Z16_PROD	:= aDados[_nX][_nPosProd]
						Z16->Z16_DESC	:= SB1->B1_DESC
					EndIf

					Z16->Z16_QTD	:= aDados[_nX][_nPosSald]
					Z16->Z16_MSG	:= aDados[_nX][_nPosObs1]
					Z16->Z16_DTSUG	:= aDados[_nX][_nPosDtSu]
					Z16->Z16_DTPREV := aDados[_nX][_nPosDtPr]
					Z16->(MsUnLock())

					AADD(_aItens,{Z16->Z16_ITEM,Z16->Z16_PROD,Z16->Z16_DESC,Z16->Z16_QTD,Z16->Z16_DTSUG,Z16->Z16_MSG})

				EndIf

			Next

			Z15->(ConfirmSX8())

		End Transaction

		MsgAlert("Solicita��o n�mero: "+Z15->Z15_DOC+", gerada com sucesso!")

		_cAssunto := "[WFPROTHEUS] - Solicita��o de novo prazo - "+Z15->Z15_DOC

		cMsg := ''
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		cMsg += '<br>
		cMsg += '<TR BgColor=#FFFFFF>'
		cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Filial</Font></B></TD>'
		cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Pedido</Font></B></TD>'
		cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Cliente</Font></B></TD>'
		cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Loja</Font></B></TD>'
		cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Nome</Font></B></TD>'
		cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Emiss�o</Font></B></TD>'
		cMsg += '</TR>'
		cMsg += '<TR BgColor=#FFFFFF>'
		cMsg += '<TD><Font Color="black" Size="3" Face="Arial">'+SC5->C5_FILIAL+'</Font></TD>'
		cMsg += '<TD><Font Color="black" Size="3" Face="Arial">'+SC5->C5_NUM+'</Font></TD>'
		cMsg += '<TD><Font Color="black" Size="3" Face="Arial">'+SC5->C5_CLIENTE+'</Font></TD>'
		cMsg += '<TD><Font Color="black" Size="3" Face="Arial">'+SC5->C5_LOJACLI+'</Font></TD>'
		cMsg += '<TD><Font Color="black" Size="3" Face="Arial">'+Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_NOME")+'</Font></TD>'
		cMsg += '<TD><Font Color="black" Size="3" Face="Arial">'+DTOC(SC5->C5_EMISSAO)+'</Font></TD>'
		cMsg += '</TR>'
		cMsg += '</Table>'
		cMsg += '<br>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<TR BgColor=#FFFFFF>'
		cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Item</Font></B></TD>'
		cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Produto</Font></B></TD>'
		cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Descri��o</Font></B></TD>'
		cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Qtde</Font></B></TD>'
		cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Data sugerida</Font></B></TD>'
		cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Observa��o</Font></B></TD>'
		cMsg += '</TR>'

		For _nLin := 1 to Len(_aItens)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf

			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aItens[_nLin,1] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aItens[_nLin,2] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aItens[_nLin,3] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + CVALTOCHAR(_aItens[_nLin,4]) + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + DTOC(_aItens[_nLin,5]) + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aItens[_nLin,6] + ' </Font></TD>'
			cMsg += '</TR>'

		Next

		cMsg += '</body>'
		cMsg += '</html>'

		If !(   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach) )
			MsgInfo("Email n�o Enviado..!!!!")
		EndIf

	ElseIf lConfirma .And. !_lAltera

		MsgAlert("N�o � poss�vel alterar mais essa solicita��o!")

	EndIf

Return()

/*====================================================================================\
|Programa  | GETDESC1         | Autor | RENATO.OLIVEIRA          | Data | 07/12/2018  |
|=====================================================================================|
|Descri��o |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   |                                                                          |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

Static Function GETDESC1(_cStatus)

	Local _cDesc := ""

	Do Case
		Case _cStatus=="0"
		_cDesc := "PENDENTE"
		Case _cStatus=="1"
		_cDesc := "ANALISADO"
	EndCase

Return(_cDesc)


/*/{Protheus.doc} RICMSST
Acesso a altera��o nos par�metros ST_CLIST e ST_NCMST
@type function
@version 12.1.33
@author Ricardo Munhoz
@since 1/29/2023
/*/
User Function RICMSST
Local aArea := GetArea()
Local lOk	:= .F.
Local aParam 	:= {}
Local aRetParm	:= {}
Local cCliST 	:= PadR(SuperGetMV("ST_CLIST"), 255, " ")
Local cNCMST01	:= PadR(SuperGetMV("ST_NCMST01"), 255, " ") // Incluido na melhoria 20230713008872
Local cNCMST02	:= PadR(SuperGetMV("ST_NCMST02"), 255, " ") // Incluido na melhoria 20230713008872
Local cNCMST03	:= PadR(SuperGetMV("ST_NCMST03"), 255, " ") // Incluido na melhoria 20230713008872
Local cNCMST04	:= PadR(SuperGetMV("ST_NCMST04"), 255, " ") // Incluido na melhoria 20230713008872

/*
If  ! (RetCodUsr() $ GetMV("X",.T.,"0,1"))
	MsgInfo("Você n�o possui permiss�o para executar esta fun��o. Entre em contato com o respons�vel.")
	RestArea(aArea)
	Return
Endif
*/

aadd(aParam,{1, "Clientes", cCliST, "", ".T.", , ".T.", 100, .F.})

If ParamBox(aParam, "Entre com os c�digos de Cliente (ST_CLIST) com sua respectiva Loja", aRetParm)
	lOk	:= .T.
End If

If lOk
	// Alterado na melhoria 20230713008872
	SX6->(DbSetOrder(1))
	If SX6->(DbSeek("  " + "ST_CLIST"))
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD := AllTrim(aRetParm[1])
		SX6->(MsUnLock())
		FWAlertSuccess("Par�metro ST_CLIST alterado com sucesso")
	Else
		FWAlertInfo("Problemas no Par�metro ST_CLIST")
	End If
Else
	FWAlertInfo("Opera��o cancelada")
End If

If FWAlertYesNo("Haver� altera��o dos NCM aos Clientes beneficiados ?","Par�metro ST_NCMST")
	lOk	:= .F.
	aRetParm := {}
	aParam := {}
	aadd(aParam,{1, "NCM01", cNCMST01, "", ".T.", , ".T.", 100, .F.})// Incluido na melhoria 20230713008872
	aadd(aParam,{1, "NCM02", cNCMST02, "", ".T.", , ".T.", 100, .F.}) // Incluido na melhoria 20230713008872
	aadd(aParam,{1, "NCM03", cNCMST03, "", ".T.", , ".T.", 100, .F.}) // Incluido na melhoria 20230713008872
	aadd(aParam,{1, "NCM04", cNCMST04, "", ".T.", , ".T.", 100, .F.}) // Incluido na melhoria 20230713008872

	If ParamBox(aParam, "Entre com os c�digos de NCM (ST_NCMST)", aRetParm)
		lOk	:= .T.
	End If

	If lOk
		// Alterado na melhoria 20230713008872
		SX6->(DbSetOrder(1))
		If !Empty(AllTrim(aRetParm[1]))
			If SX6->(DbSeek("  " + ""))
				RecLock("SX6",.F.)
				SX6->X6_CONTEUD := AllTrim(aRetParm[1])
				SX6->(MsUnLock())
			EndIf
		Endif

		IF !Empty(AllTrim(aRetParm[2]))
			If SX6->(DbSeek("  " + "ST_NCMST02"))
				RecLock("SX6",.F.)
				SX6->X6_CONTEUD := AllTrim(aRetParm[2])
				SX6->(MsUnLock())
			EndIf
		Endif

		IF !Empty(AllTrim(aRetParm[3]))
			If SX6->(DbSeek("  " + "ST_NCMST03"))
				RecLock("SX6",.F.)
				SX6->X6_CONTEUD := AllTrim(aRetParm[3])
				SX6->(MsUnLock())
			EndIf
		Endif
		
		IF !Empty(AllTrim(aRetParm[4]))
			If SX6->(DbSeek("  " + "ST_NCMST04"))
				RecLock("SX6",.F.)
				SX6->X6_CONTEUD := AllTrim(aRetParm[4])
				SX6->(MsUnLock())
			EndIf
		Endif
		FWAlertSuccess("Par�metros alterado com sucesso")
	Else
		FWAlertInfo("Opera��o cancelada")
	EndIf
End If

RestArea(aArea)
Return
