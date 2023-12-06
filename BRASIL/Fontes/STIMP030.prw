#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STIMP030        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
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

User Function STIMP031()

	Private cArquivo := ""

	//RpcSetType( 3 )
	//RpcSetEnv("01","04",,,"FAT")

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*| ","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)
		MsgStop("O arquivo " +cDir+cArq + " n�o foi encontrado. A importa��o ser� abortada!","[AEST901] - ATENCAO")
		Return
	EndIf

	oProcess := MsNewProcess():New( { || PROCESSA() } , "Processando" , "Processando, por favor aguarde..." , .F. )
	oProcess:Activate()

Return()

/*====================================================================================\
|Programa  | PROCESSA        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
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

Static Function PROCESSA()

	Local aCampos  := {}
	Local aDados   := {}
	Local lPrim    := .T.
	Local _cLog	   := ""
	Local oDlg
	Local oModel, oMdlDet, oMdlH3
	Local cErro  := ""
	Local lRet   := .T.
	Local _nY
	Private lMsErroAuto := .F.

	INCLUI := .T.
	ALTERA := .F.

	oModel := FWLoadModel('MATA632') //Carrega o modelo do programa MATA632

	oModel:SetOperation(MODEL_OPERATION_INSERT) //Seta a opera��o de inclus�o no modelo.

	oProcess:SetRegua1(FT_FLASTREC())

	FT_FUSE(cArquivo)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()                     // fa�a enquanto n�o for fim do arquivo

		oProcess:IncRegua1("Lendo arquivo...")

		cLinha := FT_FREADLN()           // lendo a linha

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	oProcess:SetRegua1(Len(aDados))

	_cProd := ""
	_nProx := 0
	_nColC := 3

	For _nY:=1 To Len(aDados)

		oProcess:IncRegua1("Importando")

		If !SB1->(DbSeek(xFilial("SB1")+aDados[_nY][3]))
			_cLog += "Linha "+cValToChar(_nY)+" produto n�o existe"+CHR(13)+CHR(10)
			Loop
		EndIf

		lRet := .T.
		_lNewProd := .F.

		If Empty(_cProd)
			_lNewProd := .T.
		ElseIf !(AllTrim(aDados[_nY][3])==_cProd)
			_lNewProd := .T.
		EndIf

		_cProd := AllTrim(aDados[_nY][3])

		If _lNewProd
			If oModel:Activate() //Ativa o modelo.

				If !oModel:SetValue("MATA632_CAB","G2_CODIGO" , "01") //Atribui o c�digo do roteiro no modelo. (G2_CODIGO)
					//Se ocorreu algum erro na atribui��o, recupera o erro.
					cErro := u_getErr(oModel)
					lRet := .F.
				EndIf
				If lRet .And. !oModel:SetValue("MATA632_CAB","G2_PRODUTO", aDados[_nY][3]) //Atribui o c�digo do produto no modelo. (G2_PRODUTO)
					//Se ocorreu algum erro na atribui��o, recupera o erro.
					cErro := u_getErr(oModel)
					lRet := .F.
				EndIf

				oMdlDet := oModel:GetModel("MATA632_SG2") //Recupera o submodelo detalhe.

				If lRet .And. !oMdlDet:SetValue("G2_OPERAC",SubStr(AllTrim(aDados[_nY][5]),3,2)) //Atribui o c�digo da opera��o no modelo. (G2_OPERAC)
					//Se ocorreu algum erro na atribui��o, recupera o erro.
					cErro := u_getErr(oModel)
					lRet := .F.
				EndIf
				If lRet .And. !oMdlDet:SetValue("G2_DESCRI",SubStr(AllTrim(aDados[_nY][10]),1,20)) //Atribui a descri��o da opera��o no modelo. (G2_DESCRI)
					//Se ocorreu algum erro na atribui��o, recupera o erro.
					cErro := u_getErr(oModel)
					lRet := .F.
				EndIf

				If lRet .And. !oMdlDet:SetValue("G2_RECURSO",AllTrim(aDados[_nY][6])) //Atribui o c�digo do recurso no modelo. (G2_RECURSO)
					//Se ocorreu algum erro na atribui��o, recupera o erro.
					cErro := u_getErr(oModel)
					lRet := .F.
				EndIf

				If lRet .And. !oMdlDet:SetValue("G2_LINHAPR",AllTrim(aDados[_nY][9])) //Atribui o c�digo do recurso no modelo. (G2_RECURSO)
					//Se ocorreu algum erro na atribui��o, recupera o erro.
					cErro := u_getErr(oModel)
					lRet := .F.
				EndIf

				If lRet .And. !oMdlDet:SetValue("G2_SETUP",Val(aDados[_nY][12])) //Atribui o tempo de setup no modelo. (G2_SETUP)
					//Se ocorreu algum erro na atribui��o, recupera o erro.
					cErro := u_getErr(oModel)
					lRet := .F.
				EndIf

				If lRet .And. !oMdlDet:SetValue("G2_TEMPAD",Val(StrTran(aDados[_nY][21],",","."))) //Atribui o tempo padr�o no modelo. (G2_TEMPAD)
					//Se ocorreu algum erro na atribui��o, recupera o erro.
					cErro := u_getErr(oModel)
					lRet := .F.
				EndIf

				If lRet .And. !oMdlDet:SetValue("G2_LOTEPAD",Val(aDados[_nY][22])) //Atribui o lote padr�o no modelo. (G2_LOTEPAD)
					//Se ocorreu algum erro na atribui��o, recupera o erro.
					cErro := u_getErr(oModel)
					lRet := .F.
				EndIf

				If lRet .And. !oMdlDet:SetValue("G2_MAOOBRA",Val(aDados[_nY][23])) //Atribui o lote padr�o no modelo. (G2_LOTEPAD)
					//Se ocorreu algum erro na atribui��o, recupera o erro.
					cErro := u_getErr(oModel)
					lRet := .F.
				EndIf

			EndIf
		Else
			If lRet .And. !oMdlDet:AddLine() //Adiciona uma nova linha no modelo detalhe
				//Se ocorreu algum erro ao adicionar uma nova linha, recupera o erro
				cErro := u_getErr(oModel)
				lRet := .F.
			EndIf

			If lRet .And. !oMdlDet:SetValue("G2_OPERAC",SubStr(AllTrim(aDados[_nY][5]),3,2)) //Atribui o c�digo da opera��o no modelo. (G2_OPERAC)
				//Se ocorreu algum erro na atribui��o, recupera o erro.
				cErro := u_getErr(oModel)
				lRet := .F.
			EndIf
			If lRet .And. !oMdlDet:SetValue("G2_DESCRI",SubStr(AllTrim(aDados[_nY][10]),1,20)) //Atribui a descri��o da opera��o no modelo. (G2_DESCRI)
				//Se ocorreu algum erro na atribui��o, recupera o erro.
				cErro := u_getErr(oModel)
				lRet := .F.
			EndIf

			If lRet .And. !oMdlDet:SetValue("G2_RECURSO",AllTrim(aDados[_nY][6])) //Atribui o c�digo do recurso no modelo. (G2_RECURSO)
				//Se ocorreu algum erro na atribui��o, recupera o erro.
				cErro := u_getErr(oModel)
				lRet := .F.
			EndIf

			If lRet .And. !oMdlDet:SetValue("G2_LINHAPR",AllTrim(aDados[_nY][9])) //Atribui o c�digo do recurso no modelo. (G2_RECURSO)
				//Se ocorreu algum erro na atribui��o, recupera o erro.
				cErro := u_getErr(oModel)
				lRet := .F.
			EndIf

			If lRet .And. !oMdlDet:SetValue("G2_SETUP",Val(aDados[_nY][12])) //Atribui o tempo de setup no modelo. (G2_SETUP)
				//Se ocorreu algum erro na atribui��o, recupera o erro.
				cErro := u_getErr(oModel)
				lRet := .F.
			EndIf

			If lRet .And. !oMdlDet:SetValue("G2_TEMPAD",Val(StrTran(aDados[_nY][21],",","."))) //Atribui o tempo padr�o no modelo. (G2_TEMPAD)
				//Se ocorreu algum erro na atribui��o, recupera o erro.
				cErro := u_getErr(oModel)
				lRet := .F.
			EndIf

			If lRet .And. !oMdlDet:SetValue("G2_LOTEPAD",Val(aDados[_nY][22])) //Atribui o lote padr�o no modelo. (G2_LOTEPAD)
				//Se ocorreu algum erro na atribui��o, recupera o erro.
				cErro := u_getErr(oModel)
				lRet := .F.
			EndIf

			If lRet .And. !oMdlDet:SetValue("G2_MAOOBRA",Val(aDados[_nY][23])) //Atribui o lote padr�o no modelo. (G2_LOTEPAD)
				//Se ocorreu algum erro na atribui��o, recupera o erro.
				cErro := u_getErr(oModel)
				lRet := .F.
			EndIf

		EndIf

		_nProx := _nY+1

		If Len(aDados)==_nY
			_nProx := _nY
			_nColC := 1
		EndIf

		If !(AllTrim(aDados[_nY][3])==AllTrim(aDados[_nProx][_nColC]))

			If lRet
				If oModel:VldData() //Valida as informa��es
					lRet := oModel:CommitData() //Efetiva o cadastro.
					If !lRet
						cErro := u_getErr(oModel)
						_cLog := "Linha "+cValToChar(_nY)+" erro no execauto
					EndIf
				Else
					cErro := u_getErr(oModel)
					lRet := .F.
					_cLog := "Linha "+cValToChar(_nY)+" erro na validacao
				EndIf
			Else
				_cLog := "Linha "+cValToChar(_nY)+" erro no modelo
			EndIf
			oModel:DeActivate() //Desativa o modelo.

		EndIf

	Next

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relat�rio de inconsist�ncias'
	@ 005,005 Get _cLog Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return()