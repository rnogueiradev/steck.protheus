#include 'FWMVCDEF.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#Define CR chr(13)+chr(10)

/*
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▒▒╔══════════╤══════════╦═══════╤════════════════════╦══════╤═════════════╗▒▒
▒▒║Programa  STZ48     ║Autor  │Giovani Zago    ║ Data │  16/08/19    	  ║▒▒
▒▒╠══════════╪══════════╩═══════╧════════════════════╩══════╧═════════════╣▒▒
▒▒║Desc.     │ 		CADASTRO DE CI UNICOM					              ║▒▒
▒▒║          │                                                            ║▒▒
▒▒╠══════════╪════════════════════════════════════════════════════════════╣▒▒
▒▒║Uso       │ AP                                                         ║▒▒
▒▒╚══════════╧════════════════════════════════════════════════════════════╝▒▒
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
*/
User Function STZ48()

	Local aArea1    := GetArea()
	Local aArea2    := Z48->(GetArea())
	Local _cAlias1  := "Z48"
	Local _cFiltro  := " "
	Private cTitle  := "CI UNICOM"
	Private cChaveAux := ""
	Private _cGrp   := ' '
	Private _cCID   := "MODZ48"
	Private _cSSID  := "STZ48"
	Private aRotina := MenuDef(_cSSID)
	Private oBrowse

	oBrowse := FWMBrowse():New()

	oBrowse:SetAlias(_cAlias1)

	oBrowse:SetWalkThru(.F.)
	oBrowse:SetAmbiente(.F.)
	oBrowse:SetUseFilter(.T.)
	oBrowse:SetDescription(cTitle)

	oBrowse:SetFilterDefault( _cFiltro )

	oBrowse:AddLegend("Z48_STATUS=='1'" ,"GREEN"   ,"Incluido")
	oBrowse:AddLegend("Z48_STATUS=='2'" ,"YELLOW"  ,"Aguardando Aprovaчуo")
	oBrowse:AddLegend("Z48_STATUS=='3'" ,"RED"     ,"Aguardando Engenharia")
	oBrowse:AddLegend("Z48_STATUS=='4'" ,"BLACK"   ,"Encerrado")
	oBrowse:AddLegend("Z48_STATUS=='5'" ,"PINK"    ,"Cancelado")
	oBrowse:DisableDetails()

	oBrowse:Activate()

	RestArea(aArea2)
	RestArea(aArea1)

Return

Static Function MenuDef(_cSSID)

	Local _cProgram := ALLTRIM(UPPER(funname()))
	Local aRotina   := {}

	If !Empty(_cProgram)
		//┌────────────────────────────────────────────────────────────────────────┐
		//│Opчїes padrїes do MVC
		// 1 para Pesquisar
		// 2 para Visualizar
		// 3 para Incluir
		// 4 para Alterar
		// 5 para Excluir
		// 6 para Imprimir
		// 7 para Copiar
		// 8 Opчїes Customizadas
		//└────────────────────────────────────────────────────────────────────────┘
		ADD OPTION aRotina TITLE "Pesquisar"    ACTION "PESQBRW"       OPERATION 1  ACCESS 0
		ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.STZ48" OPERATION 2  ACCESS 0
		ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.STZ48" OPERATION 3  ACCESS 0
		ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.STZ48" OPERATION 4  ACCESS 0
		ADD OPTION aRotina TITLE "Aprovar"  	ACTION "U_STAPZ48()" 	   OPERATION 8  ACCESS 0  
		ADD OPTION aRotina TITLE "Anexo"  	    ACTION "U_ANEX01(.T.)" OPERATION 8 ACCESS 0  
		ADD OPTION aRotina TITLE "Cancelar"  	ACTION "U_Z48CAN()" 	   OPERATION 8  ACCESS 0   
		//ADD OPTION aRotina TITLE "Excluir"      ACTION "VIEWDEF.STZ48" OPERATION 5  ACCESS 0 
	Endif
Return aRotina


Static Function ModelDef()

	Local oStruCabec := FWFormStruct(1, "Z48")// Construчуo de estrutura de dados
	Local oModel
	Local _cTitulo   := cTitle
	Local _cCabec    := cTitle

	oModel := MPFormModel():New(_cCID  , /*bPreValidacao*/ ,  { | oModel | VldTOK( oModel ) }  ,  { | oModel | GrvTOK( oModel ) }  , /*bCancel*/ )
	oModel:AddFields("CABECALHO", /*cOwner*/, oStruCabec)

	oModel:SetPrimaryKey({})
	oModel:SetDescription(_cTitulo)
	oModel:GetModel("CABECALHO"):SetDescription(_cCabec)
	oModel:SetActivate( {|oMod| IniPad(oMod)} )

	oModel:SetVldActivate ( { |oMod| VldAcess( oMod ) } )

Return oModel


Static Function ViewDef()

	Local oStruCabec := FWFormStruct(2, "Z48")
	Local oModel     := FWLoadModel(_cSSID)
	Local oView

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField("VIEW_CABEC", oStruCabec, "CABECALHO")

	oView:CreateHorizontalBox("SUPERIOR", 100)

	oView:SetOwnerView("VIEW_CABEC", "SUPERIOR")

	oView:SetCloseOnOk({||.T.})

	oView:EnableTitleView("VIEW_CABEC")


Return oView



Static Function IniPad(oModel)

	Local lIni := .T.

Return lIni


Static Function VldAcess(oModel)

	Local lAcess    := .T.




Return (lAcess)


Static Function VldTOK( oModel )

	Local lVld      := .T.
	Local nOp 		:= oModel:GetOperation()



Return lVld


Static Function GrvTOK( oModel )

	Local nOp         := oModel:GetOperation()
	Local lGrv        := .T. 

	FWFormCommit( oModel )

	Reclock("Z48",.F.)
	If nOp == MODEL_OPERATION_INSERT //Cєpia tambщm щ reconhecida como inserчуo
		Z48->Z48_LOG:= 'Inserido por: '+__cuserid+ '-'+ cUserName+CR+ dtoc(date())+' - '+ time()+CR+CR + Alltrim(Z48->Z48_LOG) 
	Else
		Z48->Z48_LOG:= 'Alterado por: '+__cuserid+ '-'+ cUserName+CR+ dtoc(date())+' - '+ time()+CR+CR + Alltrim(Z48->Z48_LOG)
	EndIf	 

	Z48->(MsUnLock())
	Z48->( DbCommit())



Return lGrv




User Function ANEX01(_lT)

	//├Ъ├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д┬┐
	//┬│Declara├з├гo das Variсveis
	//├А├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Щ
	Local aArea       := GetArea()
	Local aArea1      := Z48->(GetArea())

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
	Local cSolicit	  := 	Z48->Z48_COD

	Private _cPath      := GetSrvProfString("RootPath","")
	Private _cStartPath := "\arquivos\CI\"
	Private _cEmp       := ' '//""+cEmpAnt+"\"
	Private _cFil       := ' '//""+Z48->Z48_XFIL+"\"
	Private _cNUm       := ""+cSolicit+"\"
	Private _cServerDir   := ''
	Default _lT := .f.
	If !_lT
		If Inclui
			MsgInfo("Anexo so pode ser incluido apos a Gravaчуo do CI...!!!!")
			Return()
		EndIf
	EndIf
	//├Ъ├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д┬┐
	//┬│ Cria├з├гo das pastas para salvar os anexos das Solicita├з├╡es de Compras no Servidor
	//├А├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Щ
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

		DbSelectArea("Z48")
		Z48->(DbSetOrder(1))//Z48_FILIAL+Z48_COD+Z48_ITEM
		If Z48->(DbSeek(xFilial("Z48")+cSolicit))

			cNameSolic := USRRETNAME(Z48->Z48_USER)

			Do While !lSaida
				nOpcao := 0

				Define msDialog oDxlg Title "Selecione os Anexos " From 10,10 TO 450,600 Pixel
				_nLin := 005
				@ _nLin,010 say "Filial" COLOR CLR_BLACK  Of oDxlg Pixel
				@ _nLin,040 get xFilial("Z48") when .f. size 050,08  Of oDxlg Pixel

				//@ _nLin,110 say "Data SC" COLOR CLR_BLACK   Of oDxlg Pixel
				//@ _nLin,140 get  dDtEmiss  when .f. size 090,08  Of oDxlg Pixel

				_nLin := _nLin + 10
				@ _nLin,010 say "N║ CI" COLOR CLR_BLACK    Of oDxlg Pixel
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
				//DEFINE SBUTTON FROM 200,160 TYPE 2 ACTION (lSaida:=.T.,nOpcao:=2,oDxlg:End()) ENABLE OF oDxlg

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
	Local nTamMax   := 5
	Local cMascara  := "Todos os arquivos"
	Local cTitulo   := "Escolha o arquivo"
	Local nMascpad  := 0
	Local cDirini   := "c:\"
	Local lSalvar   := .T. /*.F. = Salva || .T. = Abre*/
	Local lArvore   := .F. /*.T. = apresenta o сrvore do servidor || .F. = n├гo apresenta*/
	Local _cMsgSave := ""
	Local aArea1    := GetArea()
	Local aArea2    := Z48->(GetArea())



	_cLocArq  := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar,, lArvore)

	If !(Empty(_cLocArq))
		nTamOrig := Directory(_cLocArq)[1,2]
		If (nTamOrig/nMB) > (nMB*nTamMax)
			Aviso("Tamanho do Arquivo Superior ao Permitido"; //01 - cTitulo - T├нtulo da janela
			,"O Arquivo '"+_cArq+"' tem que ter tamanho mсximo de "+cValtoChar(nTamMax)+"MB."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"A├з├гo n├гo permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as op├з├╡es dos bot├╡es.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri├з├гo (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op├з├гo padr├гo usada pela rotina automсtica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi├з├гo do campo memo
			,;                               //09 - nTimer - Tempo para exibi├з├гo da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op├з├гo padr├гo apresentada na mensagem.
			)
			Return
		EndIf

		If Len(Directory(_cServerDir+Strzero(_nSave,6)+".mzp")) = 1
			_lRet := MsgYesNo("Jс existe um arquivo anexado."+ Chr(10) + Chr(13) +" Deseja sobrepor o arquivo existente ???","Aten├з├гo")
		Endif

		If _lRet

			_cLocArq  := Alltrim(_cLocArq)
			_cDir     := SUBSTR(_cLocArq, 1                      ,RAT( "\"   , _cLocArq ))
			_cArq     := SUBSTR(_cLocArq, RAT( "\"   , _cLocArq ),Len(_cLocArq))
			_cArq     := StrTran(_cArq,"\","")
			cExtensao := SUBSTR(_cLocArq,Rat(".",_cLocArq),Len(_cLocArq))

			If At(".",cExtensao) == 1

				_cSave := Strzero(_nSave,6)

				//├Ъ├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д?├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д┬┐
				//┬│ Copio o arquivo original da mсquina do usuсrio para o servidor
				//├А├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Щ
				lSucess   := __CopyFile(_cLocArq,_cServerDir+_cSave+cExtensao)

				If lSucess

					//├Ъ├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д┬┐
					//┬│ Realizo a compacta├з├гo do arquivo para a extens├гo .mzp
					//├А├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Щ
					MsCompress((_cServerDir+_cSave+cExtensao),(_cServerDir+_cSave+".mzp"))

					//├Ъ├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д┬┐
					//┬│ Apago o arquivo original do servidor
					//├А├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Щ
					Ferase( _cServerDir+_cSave+cExtensao)
					Aviso("Anexar Arquivo"; //01 - cTitulo - T├нtulo da janela
					,"O Arquivo '"+_cArq+"' foi anexado com sucesso.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as op├з├╡es dos bot├╡es.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descri├з├гo (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Op├з├гo padr├гo usada pela rotina automсtica
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edi├з├гo do campo memo
					,;                               //09 - nTimer - Tempo para exibi├з├гo da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Op├з├гo padr├гo apresentada na mensagem.
					)
					_cSave += ".mzp"
					_cMsgSave += "===================================" +CHR(13)+CHR(10)
					_cMsgSave += "Documento "+Alltrim(_cArq)+" anexado com sucesso por: " +CHR(13)+CHR(10)
					_cMsgSave += "Usuсrio: "+cUserName+CHR(13)+CHR(10)
					_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
					dbSelectArea("Z48")
					Z48->(dbGoTop())
					While Z48->(!EOF()) .And. cSolicit = Z48->Z48_COD .And. Z48->Z48_FILIAL = xfilial("Z48")
						RecLock("Z48", .F.)
						Z48->Z48_LOG    :=  _cMsgSave   + CHR(13)+ CHR(10) + Z48->Z48_LOG
						Z48->(MsUnlock())
						Z48->( dbSkip() )
					End
				Else
					_cSave := ''
					Aviso("Problema ao Anexar Arquivo"; //01 - cTitulo - T├нtulo da janela
					,"O Arquivo '"+_cArq+"' n├гo foi anexado."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Favor verificar com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as op├з├╡es dos bot├╡es.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descri├з├гo (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Op├з├гo padr├гo usada pela rotina automсtica
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edi├з├гo do campo memo
					,;                               //09 - nTimer - Tempo para exibi├з├гo da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Op├з├гo padr├гo apresentada na mensagem.
					)
				EndIf
			Else
				Aviso("Problema com Extens├гo do Anexo"; //01 - cTitulo - T├нtulo da janela
				,"A Extens├гo "+cExtensao+" ├й invсlida para anexar junto a Solicita├з├гo de Compras."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"A├з├гo n├гo permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as op├з├╡es dos bot├╡es.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descri├з├гo (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Op├з├гo padr├гo usada pela rotina automсtica
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edi├з├гo do campo memo
				,;                               //09 - nTimer - Tempo para exibi├з├гo da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Op├з├гo padr├гo apresentada na mensagem.
				)
			Endif
		Else
			_cSave := _cFile
		Endif

	Else
		_cSave := _cFile
		Aviso("Anexar Arquivo"; //01 - cTitulo - T├нtulo da janela
		,"Nenhum Arquivo foi selecionado para ser anexado.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op├з├╡es dos bot├╡es.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri├з├гo (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op├з├гo padr├гo usada pela rotina automсtica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi├з├гo do campo memo
		,;                               //09 - nTimer - Tempo para exibi├з├гo da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op├з├гo padr├гo apresentada na mensagem.
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
	Local aArea2   := Z48->(GetArea())

	If Len(Directory(_cServerDir+_cFile)) = 1
		_lRet := MsgYesNo("Deseja deletar o Arquivo ??? "+ Chr(10) + Chr(13) +" Uma vez confirmada essa a├з├гo o arquivo n├гo ficarс mais dispon├нvel para consulta.","Aten├з├гo")
	Else
		_lRet := .F.
		Aviso("Deletar Anexo"; //01 - cTitulo - T├нtulo da janela
		,"N├гo existe nenhum Arquivo para ser deletado."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"A├з├гo n├гo permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op├з├╡es dos bot├╡es.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri├з├гo (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op├з├гo padr├гo usada pela rotina automсtica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi├з├гo do campo memo
		,;                               //09 - nTimer - Tempo para exibi├з├гo da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op├з├гo padr├гo apresentada na mensagem.
		)
	Endif

	If _lRet
		Ferase( _cServerDir+_cFile)
		_cDelete := ''
		_cMsgDel += "===================================" +CHR(13)+CHR(10)
		_cMsgDel += "Documento "+Alltrim(_cFile)+" deletado com sucesso por: " +CHR(13)+CHR(10)
		_cMsgDel += "Usuсrio: "+cUserName+CHR(13)+CHR(10)
		_cMsgDel += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
		dbSelectArea("Z48")
		Z48->(dbGoTop())
		While Z48->(!EOF()) .And. cSolicit = Z48->Z48_COD .And. Z48->Z48_FILIAL = xfilial("Z48")
			RecLock("Z48", .F.)
			Z48->Z48_LOG   :=  _cMsgDel   + CHR(13)+ CHR(10) + Z48->Z48_LOG
			Z48->(MsUnlock())
			Z48->( dbSkip() )
		End
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
	Local _cStartPath1 := "CI\"
	Local _lUnzip     := .T.

	//├Ъ├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д┬┐
	//┬│ Cria├з├гo das pastas para salvar os anexos das Solicita├з├╡es de Compras na mсquina Local do usuсrio
	//├А├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Д├Щ
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
				Aviso("Erro para Descompactar Anexo"; //01 - cTitulo - T├нtulo da janela
				,"Houve erro para Descompactar o Anexo."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as op├з├╡es dos bot├╡es.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descri├з├гo (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Op├з├гo padr├гo usada pela rotina automсtica
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edi├з├гo do campo memo
				,;                               //09 - nTimer - Tempo para exibi├з├гo da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Op├з├гo padr├гo apresentada na mensagem.
				)
			Endif
		Else
			_cOpen  := _cFile
			Aviso("Anexo invсlido"; //01 - cTitulo - T├нtulo da janela
			,"N├гo existe nenhum anexo no Protheus para ser aberto."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"A├з├гo n├гo permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as op├з├╡es dos bot├╡es.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri├з├гo (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op├з├гo padr├гo usada pela rotina automсtica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi├з├гo do campo memo
			,;                               //09 - nTimer - Tempo para exibi├з├гo da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op├з├гo padr├гo apresentada na mensagem.
			)
		Endif
	Else
		Aviso("Erro ao Salvar Anexo"; //01 - cTitulo - T├нtulo da janela
		,"Houve erro ao Salvar o Anexo."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op├з├╡es dos bot├╡es.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri├з├гo (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op├з├гo padr├гo usada pela rotina automсtica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi├з├гo do campo memo
		,;                               //09 - nTimer - Tempo para exibi├з├гo da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op├з├гo padr├гo apresentada na mensagem.
		)
	Endif

Return (_cOpen)



User Function STAPZ48()
	Local _cMsgSave	:= ' '
	Local _cPara 	:= ' '
	Local _cCop 	:= ' '
	Local _UserGes  := GetMv('ST_Z4801',,'000000/000645/')
	Local _MailGes  := GetMv('ST_Z4802',,'FILIPE.NASCIMENTO@STECK.COM.BR') + ";bruno.galvao@steck.com.br"
	Local _UserEng  := GetMv('ST_Z4803',,'000000/000645/')
	Local _MailEng  := GetMv('ST_Z4804',,'FILIPE.NASCIMENTO@STECK.COM.BR') + ";bruno.galvao@steck.com.br"


	If Z48->Z48_STATUS = '1' 
		If Z48->Z48_USER = __cUserId
			If	MsgYesNo("Deseja enviar para Aprovaчуo do Gestor ?")
				_cMsgSave += "===================================" +CR
				_cMsgSave += "Enviado Para Aprovaчуo do Gestor. " +CR
				_cMsgSave += "Usuсrio: "+cUserName+CR
				_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR


				_cPara:=  _MailGes
				_cCop :=  UsrRetMail(Z48->Z48_USER)+' ; '+Alltrim(Z48->Z48_EMAIL)


				STWF48("Fluxo de CI: "+Z48->Z48_COD+", Enviado para Aprovaчуo do Gestor.",_cPara,_cCop)
				RecLock("Z48", .F.)
				Z48->Z48_LOG    :=  _cMsgSave + CR + Z48->Z48_LOG
				Z48->Z48_STATUS := '2' 
				Z48->(MsUnlock())
				Z48->(DbCommit())

			EndIf
		Else
			MsgInfo('Apenas o Usuario: '+Alltrim(USRRETNAME(Z48->Z48_USER))+' , pode enviar para a Aprovaчуo do Gestor')
		EndIf

	ElseIf Z48->Z48_STATUS = '2'

		If __cuserid $ _UserGes  

			If	MsgYesNo("Deseja Aprovar e enviar para Engenharia?")
				_cMsgSave += "===================================" +CR
				_cMsgSave += "Aprovado e enviado para Engenharia. " +CR
				_cMsgSave += "Usuсrio: "+cUserName+CR
				_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

				_cCop :=  UsrRetMail(Z48->Z48_USER)+' ; '+UsrRetMail(__cuserid)+' ; '+Alltrim(Z48->Z48_EMAIL)
				_cPara:= _MailEng

				STWF48("Fluxo de CI: "+Z48->Z48_COD+", Aprovado e Enviado para Engenharia.",_cPara,_cCop)
				RecLock("Z48", .F.)
				Z48->Z48_LOG    :=  _cMsgSave + CR + Z48->Z48_LOG
				Z48->Z48_STATUS := '3'
				Z48->Z48_DATA	:= DDATABASE
				Z48->Z48_HORA	:= TIME()				 
				Z48->(MsUnlock())
				Z48->(DbCommit())


			EndIf
		Else
			MsgInfo('Apenas Gestores podem Aprovar a CI....!!!!')
		EndIf

	ElseIf Z48->Z48_STATUS = '3'

		If !(__cUserId $ _UserEng)
			MsgInfo("Voce nao щ o aprovador !!!!!!!")
		Else


			If	MsgYesNo("Deseja Encerrar a CI ?")
				_cMsgSave += "===================================" +CR
				_cMsgSave += "CI Encerrada. " +CR
				_cMsgSave += "Usuсrio: "+cUserName+CR
				_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

				_cCop := UsrRetMail(__cuserid)+' ; '+Alltrim(Z48->Z48_EMAIL)
				_cPara:= UsrRetMail(Z48->Z48_USER)

				STWF48("Fluxo de CI: "+Z48->Z48_COD+", Encerramento.",_cPara,_cCop)

				RecLock("Z48", .F.)
				Z48->Z48_LOG    :=   _cMsgSave + CR + Z48->Z48_LOG
				Z48->Z48_STATUS := '4'
				Z48->Z48_DTFIM	:= DDATABASE
				Z48->Z48_HRFIM	:= TIME()
				Z48->(MsUnlock())
				Z48->(DbCommit())


			EndIf
		Endif
	EndIf

	Return


	*------------------------------------------------------------------*
Static Function STWF48(_cAssunto,_cEmail,_cCopia )
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local cFuncSent:= "STWF48"
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
	Local _aMsg    :={}

	Aadd( _aMsg , { "Numero: "          , Z48->Z48_COD } )
	Aadd( _aMsg , { "Nome: "    		, Z48->Z48_NOME } )
	Aadd( _aMsg , { "Unicom: "    		, Z48->Z48_UNICOM } )
	Aadd( _aMsg , { "Obra: "    		, Z48->Z48_OBRA } )
	Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
	Aadd( _aMsg , { "Hora: "    		, time() } )
	Aadd( _aMsg , { "Usuario: "    		, Alltrim(USRRETNAME(Z48->Z48_USER)) } ) 

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//┌─────────────────────────────────────────────────────────────────────────────┐
		//│ Definicao do cabecalho do email                                             │
		//└─────────────────────────────────────────────────────────────────────────────┘
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//┌─────────────────────────────────────────────────────────────────────────────┐
		//│ Definicao do texto/detalhe do email                                         │
		//└─────────────────────────────────────────────────────────────────────────────┘
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf


			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

		Next

		//┌─────────────────────────────────────────────────────────────────────────────┐
		//│ Definicao do rodape do email                                                │
		//└─────────────────────────────────────────────────────────────────────────────┘
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)


	EndIf
	RestArea(aArea)
Return()

User Function Z48CAN()
	Local _cMsgSave	:= ' '
	Local _UserGes  := GetMv('ST_Z4801',,'000000/000645/')
	Local _MailGes  := GetMv('ST_Z4802',,'FILIPE.NASCIMENTO@STECK.COM.BR') + ";bruno.galvao@steck.com.br"

	If __cuserid $ _UserGes  

		If	MsgYesNo("Deseja Cancelar a CI ?")
			_cMsgSave += "===================================" +CR
			_cMsgSave += "CI Cancelada. " +CR
			_cMsgSave += "Usuсrio: "+cUserName+CR
			_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

			_cCop := UsrRetMail(__cuserid)
			_cPara:= UsrRetMail(Z48->Z48_USER)

			STWF48("Fluxo de CI: "+Z48->Z48_COD+", Cancelamento.",_cPara,_cCop)

			RecLock("Z48", .F.)
			Z48->Z48_LOG    :=   _cMsgSave + CR + Z48->Z48_LOG
			Z48->Z48_STATUS := '5'
			Z48->(MsUnlock())
			Z48->(DbCommit())


		EndIf
	Else
		MsgInfo('Apenas Gestores podem Cancelar a CI....!!!!')
	EndIf



Return()
