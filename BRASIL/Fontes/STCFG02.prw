#Include "rwmake.ch"
#Include "PROTHEUS.CH"
#include "TOTVS.CH"

User Function STCFG02()

	Local aArea 	:= GetArea()
	Local oDlg
	Local oBtnOk
	Local oBtnCancel
	Local nRadio := 0
	Local nOpcao := 0
	Local cStcfg02 := GetMv('ST_STCFG02',,'000000/001036')
	Local _cDoc		:= "MV_NUMITEN"
	Local _cTipo	:= "X6"
	Local cHist		:= ""

	Local _cFrom   := "protheus@steck.com.br"
	Local cFuncSent:= "STCFG02"
	Local _cAssunto	:= "Quantidade de Itens da Nota fiscal Alterado."
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
	Local _aMsg    :={}
	Local _CCOPIA  := ""
	Local _cEmail := GetMv('ST_STCFGEM',,'everson.santana@steck.com.br')

	If !__cUserId $ cStcfg02

		MsgAlert("Usuário sem permissão para utilizar está rotina")
		Return()

	EndIf

	SetPrvt('cmvnumiten')

	Define MSDialog oDlg Title "Parametros - Filial "+xFilial('') From 200,200 To 300,550 Pixel

	cmvnumiten := GETMV('MV_NUMITEN')

	If cmvnumiten <= 100
		nRadio := 2
	Else
		nRadio := 1
	EndIf

	//@05,05 Say "Quantidade de Itens Atual da Nota Fiscal: "+Alltrim(Str(cmvnumiten)) Pixel Of oDlg

	@05,05 Say "Configuração Atual do Parametro: " SIZE 150,8 OF oDlg FONT oFont1 COLORS 16711680, 16777215 Pixel 
	@05,125 Say cmvnumiten  SIZE 100,8 OF oDlg FONT oFont1 COLORS CLR_RED Pixel

	aItems := {'Alterar Quantidade de Itens da Nota fiscal para 100','Alterar Quantidade de Itens da Nota fiscal para 200'}
	oRadio := TRadMenu():New (15,05,aItems,,oDlg,,,,,,,,150,12,,,,.T.)
	oRadio:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}

	@oDlg:nHeight/2-27,oDlg:nClientWidth/2-105 Button oBtnOk     Prompt "&Ok"       Size 25,10 Pixel Action {|| nOpcao := 1,oDlg:End()}       Message "Clique aqui para Confirmar" Of oDlg
	@oDlg:nHeight/2-27,oDlg:nClientWidth/2-70 Button oBtnCancel Prompt "&Cancelar" Size 25,10 Pixel Action {|| nOpcao := 2,oDlg:End()} Cancel Message "Clique aqui para Cancelar"  Of oDlg
	@oDlg:nHeight/2-27,oDlg:nClientWidth/2-35 Button oBtnCancel Prompt "&Log"      Size 25,10 Pixel Action {|| nOpcao := 0,U_STCFG01A(_cDoc,_cTipo)}   Of oDlg

	Activate MSDialog oDlg Centered

	If nOpcao == 1

		If nRadio == 1

			cmvnumiten := 100

		Else

			cmvnumiten := 200

		EndIf

		PutMv("MV_NUMITEN",cmvnumiten )

		cHist := "Alteracão Efetuada para "+Alltrim(Str(cmvnumiten))

		MsgAlert(cHist)

		u_STCFG01(_cDoc,_cTipo,cHist)	

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
				cMsg += '<TR BgColor=#B0E2FF>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + cHist+" por "+CUSERNAME + ' </Font></B></TD>'

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

			
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)

		EndIf

	EndIf

Return Nil

User Function STCFG03()

	Local oDlg
	Local oBtnOk
	Local oBtnCancel
	Local nRadio 	:= 0
	Local nOpcao 	:= 0
	Local cStcfg03 	:= GetMv('ST_STCFG03',,'000000/001036')
	Local _cDoc		:= "STQIE010"
	Local _cTipo	:= "X6"
	Local cHist		:= ""
	Local _cStatus	:= ""

	Static oFont1 	   := TFont():New("MS Sans Serif",,019,,.T.,,,,,.F.,.F.)

	If !__cUserId $ cStcfg03

		MsgAlert("Usuário sem permissão para utilizar está rotina")
		Return()

	EndIf

	SetPrvt('_LQ215')

	_LQ215 :=  GetMv('STQIE010')

	Define MSDialog oDlg Title "Parametros - Filial "+xFilial('') From 200,200 To 300,550 Pixel

	//1 = Habilitado; 2 = Desabilitado 
	If _LQ215 //Se está liberado eu posiciono na opção para realizar o bloqueio.
		nRadio := 2 
		_cStatus := "Bloqueado"
	Else
		nRadio := 1 
		_cStatus := "Liberado"
	EndIf

	@05,05 Say "Configuração Atual do Parametro: " SIZE 150,8 OF oDlg FONT oFont1 COLORS 16711680, 16777215 Pixel 
	@05,125 Say _cStatus  SIZE 100,8 OF oDlg FONT oFont1 COLORS Iif(_cStatus $ "Bloqueado",CLR_RED,CLR_GREEN) Pixel

	aItems := {'Liberar requisição para OP apontada','Bloquear requisição para OP apontada'}
	oRadio := TRadMenu():New (15,05,aItems,,oDlg,,,,,,,,150,12,,,,.T.)
	oRadio:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}

	@oDlg:nHeight/2-27,oDlg:nClientWidth/2-105 Button oBtnOk     Prompt "&Ok"       Size 25,10 Pixel Action {|| nOpcao := 1,oDlg:End()}       Message "Clique aqui para Confirmar" Of oDlg
	@oDlg:nHeight/2-27,oDlg:nClientWidth/2-70 Button oBtnCancel Prompt "&Cancelar" Size 25,10 Pixel Action {|| nOpcao := 2,oDlg:End()} Cancel Message "Clique aqui para Cancelar"  Of oDlg
	@oDlg:nHeight/2-27,oDlg:nClientWidth/2-35 Button oBtnCancel Prompt "&Log"      Size 25,10 Pixel Action {|| nOpcao := 0,U_STCFG01A(_cDoc,_cTipo)}   Of oDlg

	Activate MSDialog oDlg Centered

	If nOpcao == 1

		If nRadio == 1

			_LQ215 := .F.

		Else

			_LQ215 := .T.

		EndIf

		PutMv("STQIE010",_LQ215 )

		If _LQ215
			cHist := "Processo Bloqueado para o apontamento."
			MsgAlert(cHist)
		Else
			cHist := "Processo Liberado para o apontamento."
			MsgAlert(cHist)
		EndIf

		u_STCFG01(_cDoc,_cTipo,cHist)	

	EndIf

Return Nil


