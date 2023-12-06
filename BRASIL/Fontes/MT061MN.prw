#Include 'protheus.ch'
#Include 'parmtype.ch'

User Function MT061MN()
	
	aAdd( aRotina, { 'Amarração ProdutoxFornecedor via .CSV', "u_MT061MNa()", 9, 0 } )
	
Return aRotina

/*/Protheus.doc MT061MNa()
    (long_description)
    Ponto de Entrada em MATA061 - Carregar via CSV Amarração ProdutoxFornecedor
    @type  Function
    @author user
    Jose Carlos Frasson
    @since
    16/11/2020
/*/

User Function MT061MNa()

	Private _oBtArq
	Private _oBtArq1
	Private _oBtArq2
	Private _oBtFecha
	Private _oBtOk
	Private _cPath 		:= ""
	Private _oCaminho
	Private _cCaminho 	:= Space(100)
	Static _oDlg

	DEFINE MSDIALOG _oDlg TITLE "Informe o Caminho do Arquivo para Importação" FROM 000, 000  TO 150, 400 COLORS 0, 16777215 PIXEL
	@ 009, 005 SAY "Selecione o Arquivo: " SIZE 094, 007 OF _oDlg PIXEL
	@ 019, 005 BUTTON _oBtArq PROMPT "Selecionar" SIZE 082, 012 OF _oDlg ACTION(PROCDIR()) PIXEL
	@ 035, 005 MSGET _oCaminho VAR _cCaminho SIZE 189, 010 OF _oDlg PIXEL WHEN .F.
	@ 055, 036 BUTTON _oBtOk    PROMPT "Importar" SIZE 037, 012 OF _oDlg ACTION(Processa({|| IMPPROD(_cCaminho) },"Processando..."),_oDlg:End()) PIXEL
	@ 055, 117 BUTTON _oBtFecha PROMPT "FECHAR"   SIZE 037, 012 OF _oDlg ACTION(_oDlg:End()) PIXEL
	ACTIVATE MSDIALOG _oDlg CENTERED

Return .T.

Static Function IMPPROD(_cCaminho)

	Local cLinha	:= ""
	Local aCampos 	:= {}
	Local aDados	:= {}
	Local lPrim   	:= .T.
	Local i			:= 0
	Local j			:= 0
	Local cCampo	:= ""
	Local aRet 		:= {} //TamSX3(cCampo)
	Local aLinha 	:= {}
	Local _cEmail	:= ""
	Local _cCopia	:= "" 
	Local _aAttach	:= {}
	
	FT_FUSE(_cCaminho)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	
	While !FT_FEOF()
		IncProc("Lendo arquivo texto...")
		cLinha := FT_FREADLN()
		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			If !Empty(cLinha)
				aAdd(aDados,Separa(cLinha,";",.T.))
			EndIf
		EndIf
		FT_FSKIP()
	EndDo

	Begin Transaction
		ProcRegua(Len(aDados))		
		dbSelectArea("SA5")	// A5_FILIAL + A5_FORNECE + A5_LOJA + A5_PRODUTO + A5_FABR + A5_FALOJA
		dbSetOrder(1)
		dbGoTop()
		_cAssunto := "[WFPROTHEUS] - Importacao Amarração Produto x Fornecedor- Via Arquivo .CSV" 
		cMsg := ""
		cMsg += '<html><head><title>' + SM0->M0_NOME + "/" + Alltrim(SM0->M0_FILIAL) + '</title></head><body>'
		For i := 1 to Len(aDados)		
			If SA2->( dbSeek(xFilial("SA2") + Strzero(Val(aDados[i,2]),6) + Strzero(Val(aDados[i,3]),2)) )
				IncProc("Importacao Amarração Produto x Fornecedor- Via Arquivo .CSV...")
				If SB1->(dbSeek(xFilial("SB1") + PadR(aDados[i,1],15)))
					aAdd(aLinha, "Produto: " + PadR(aDados[i,1],15) + " x Fornecedor: " + aDados[i,2] + " - " + aDados[i,3]) 
					cMsg += "<b> Produto: " + PadR(aDados[i,1],15) + " x Fornecedor: " + aDados[i,2] + " - " + aDados[i,3] + " por " + UsrFullName(__cUserId) + " </b></body></html>" + CRLF
					If SA5->( dbSeek(xFilial("SA5") + Strzero(Val(aDados[i,2]),6) + Strzero(Val(aDados[i,3]),2) + PadR(aDados[i,1],15)) )
						Reclock("SA5",.F.)
					Else
						Reclock("SA5",.T.)
					EndIf
					SA5->A5_FILIAL := xFilial("SA5")
					For j := 1 to Len(aCampos)
						If !Empty(aDados[i,j])
							cCampo  := "SA5->" + aCampos[j]
							aRet := TamSX3(aCampos[j])
							If aRet[03] $ "N"
								&cCampo := Val(StrTran(aDados[i,j],",","."))
							ElseIf aRet[03] $ "D"
								&cCampo := Stod(Alltrim(aDados[i,j]))
							Else
								&cCampo := aDados[i,j]
							EndIf
						EndIf
					Next j
					SA5->A5_NOMEFOR		:= SA2->A2_NOME
					SA5->A5_NOMPROD		:= SB1->B1_DESC
					SA5->A5_FABR		:= Strzero(Val(aDados[i,5]),6)
					SA5->A5_FALOJA		:= Strzero(Val(aDados[i,6]),2)
					SA5->( MsUnlock() )
				EndIf	
			EndIf
		Next i
		If Len(aLinha) > 0
			_cEmail := GetEmail(__cUserId)
			u_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
		EndIf
	End Transaction

	FT_FUSE()

	If Len(aLinha) > 0
		ApMsgInfo("Atualização concluída com sucesso. " + Alltrim(Str(len(aLinha))) + " Registro(s) processado(s)","[STECK]")
	Else
		ApMsgInfo("Nenhuma nova atualização foi encontrada...","[STECK]")
	EndIf

Return

/*/Protheus.doc PROCDIR()
    (long_description)
    Seleciona arquivo de processamento 
    @type  Function
    @author user
    Jose Carlos Frasson
    @since
    16/11/2020
/*/

Static Function PROCDIR()

	Local _CEXTENS := "Arquivo a ser Anexado (*.CSV) |*.CSV|"

	_cPath	:= cGetFile(_CEXTENS, "Selecione o arquivo", , , .T., GETF_NETWORKDRIVE + GETF_LOCALFLOPPY + GETF_LOCALHARD)
	_cArq	:= Alltrim(_cPath)

	If !Empty(_cPath)
		If Len(_cArq) <= 0
			Aviso( cTitulo, "Não existe arquio no diretório informado.", {"OK"} )
			_cCaminho := ""
			_oCaminho:Refresh()
		Else
			_cCaminho := _cArq
			_oCaminho:Refresh()
		EndIf
	EndIf

Return

//-------------------------------------------------------------------
// Busca e-mail conforme parâmetro passado
// Input: Model
// Retorno: String
//-------------------------------------------------------------------

Static Function GetEmail(cUsuMail)

	Local aGrpMail	:= Separa(cUsuMail,"/",.F.)
	Local nX		:= 0
	Local cRet		:= ""
	Local cCodTMP	:= ""

	If VldUsu(cUsuMail)
		PswOrder(2)
		If PswSeek( cUsuMail, .T. )
			cCodTMP := PswID()
		EndIf
	   cRet := UsrRetMail( cCodTMP ) 
	Else
		For nX := 1 to Len(aGrpMail)
			If nX > 1
				cRet += ";"
			EndIf
			cRet += UsrRetMail(aGrpMail[nX])
		Next
	EndIf

Return cRet

//-------------------------------------------------------------------
// Valida Usuário. Verifica se foi passado usuário 
// Input: Model
// Retorno: Lógico
//-------------------------------------------------------------------

Static Function Vldusu(pcUsuMail)

	Local lRet := .F.
	Local aVld := Separa("A/a/E/e/I/i/O/o/U/u",'/')
	Local nX   := 0

	For nX := 1 to Len(aVld)
		If !lRet
		   lRet := At(aVld[nX], pcUsuMail) > 0
		EndIf
	Next

Return lRet
