#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "Colors.ch"
#INCLUDE 'DBTREE.CH'
#INCLUDE 'TBICONN.CH'
#include 'protheus.ch'


Static aRetMod, aTables, aDirMnu
Static nTitle

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BDPCP001 บAutor  ณMicrosiga           บ Data ณ  12/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STGPE002

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Locais                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


	Local aBtn := Array(10)
	Local lFlatMode := If(FindFunction("FLATMODE"),FlatMode(),SetMDIChild())
	Private nWndTop
	Private nWndLeft
	Private nAdjust
	Private nWidth
	Private nHeight


	Private aGroup := {}
	Private aInfo  := {}
	Private cDir	 := ""
	Private cMenu	 := ""
	Private nBtnCol:= 0
	Private nPnlWdt:= 0
//Local oFWMenuManager := FWMenuManager():New()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Private                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private nIndex   := 1

	Private aRecDel	   := {}
	Private oTree
	Private cCadastro  := 'EAA'
	Private cCodAtual  := space(6)
	Private ldbTree    := .F.
	Private cInd5      := ''
	Private nNAlias    := 0

	Private oLPanel
	Private oRPanel
	Private oRPanel1
	Private oRPanel2
	Private oRPanel3
	Private oCPanel
	Private oLPanel1
	Private oLPanel2
	Private oLPanel3

	Private i
	Private oDlg
	Private oPrg1
	Private oMod1
	Private oPrg2
	Private oMod2
	Private oTree1
	Private oTree2
	Private nTree := 1
	Private cCargo1 := ""
	Private cCargo2 := ""

	Private aEstrutura := {} //contem itens do do projeto escolhido
	Private aEmbarque  := {} //contem itens do embarque a gerar
	Private lAbortPrint := .F.
	Private aMainTitles := Array(4)
	Private aCreated := {}
	Private _Comple := space(100)
	Private _nQuant := 0
	Private _cUM 	:= space(len(sb1->b1_um))
	Private _npeso := 0
	Private _cUser := __cUserID
	Private _cAno  := space(4)
	Private _alterado := .f.
	Private  oGetp6a,oGetp1a ,oGetp2a ,oGetp3a ,oGetp4a ,oCbx1  ,oGetp5a ,oCbx1a
	Private  oGetp1b ,oGetp2b ,oGetp3b ,oGetp4b , oGetp5b ,oCbx2
	Private  oGetp1c ,oGetp2c ,oGetp3c ,oGetp4c , oGetp5c ,oCbx3
	Private  oGetp1d ,oGetp2d ,oGetp3d ,oGetp4d , oGetp5d ,oCbx4
	Private  oGetp1e ,oGetp2e ,oGetp3e ,oGetp4e , oGetp5e ,oCbx5

	Private ogCbx1a
	Private ogGetp1a
	Private ogCbx2a
	Private ogGetp2a
	Private ogCbx3a
	Private ogGetp3a
	Private ogCbx4a
	Private ogGetp4a
	Private ogCbx5a
	Private ogGetp5a

	Private osCbx1a
	Private osGetp1a
	Private osCbx2a
	Private osGetp2a
	Private osCbx3a
	Private osGetp3a
	Private osCbx4a
	Private osGetp4a
	Private osCbx5a
	Private osGetp5a
	Private  aBtn1
	Private  aBtn2
	Private  aBtn3
	Private  aBtn4
	Private  aBtn5
	Private  aBtn6

	Private cGera := '1'
	Private oGera
	Private _lEncerra   := .F.
	Private _lMetas     := .F.
	Private _lAvaliador := .F.

	Private	cMemo   	:= ' '
	Private oMemo

	oMainWnd:ReadClientCoors()

	If lFlatMode
		nWndTop := 0
		nWndLeft := 0
		nAdjust := 30
	Else
		nWndTop := oMainWnd:nTop+125
		nWndLeft := oMainWnd:nLeft+5
		nAdjust := 60
	EndIf


	aCbx := {'1-Nao Alcan็ada',"2-Parcial Alcan็ada","3-Alcan็ada","4-Excedida","5-Excedida Constantemente"," "}

	_c1Pegunta1 := space(200)
	_n1Result 	:= " "
	_n1Aval 	:= " "
	_c1min1 	:= space(10)
	_c1max1 	:= space(10)
	_c1tgt1 	:= space(10)
	_c1obsp1 	:= space(200)
	_c1obsa1 	:= space(200)

	_c2Pegunta1 := space(200)
	_n2Result 	:= " "
	_n2Aval 	:= " "
	_c2min1 	:= space(10)
	_c2max1 	:= space(10)
	_c2tgt1 	:= space(10)
	_c2obsp1 	:= space(200)
	_c2obsa1 	:= space(200)

	_c3Pegunta1 := space(200)
	_n3Result 	:= " "
	_n3Aval 	:= " "
	_c3min1 	:= space(10)
	_c3max1 	:= space(10)
	_c3tgt1 	:= space(10)
	_c3obsp1 	:= space(200)
	_c3obsa1 	:= space(200)


	_c4Pegunta1 := space(200)
	_n4Result 	:= " "
	_n4Aval 	:= " "
	_c4min1 	:= space(10)
	_c4max1 	:= space(10)
	_c4tgt1 	:= space(10)
	_c4obsp1 	:= space(200)
	_c4obsa1 	:= space(200)


	_c5Pegunta1 := space(200)
	_n5Result 	:= " "
	_n5Aval 	:= " "
	_c5min1 	:= space(10)
	_c5max1 	:= space(10)
	_c5tgt1 	:= space(10)
	_c5obsp1 	:= space(200)
	_c5obsa1 	:= space(200)



	DEFINE MSDIALOG oDlg FROM nWndTop,nWndLeft TO oMainWnd:nBottom-nAdjust,oMainWnd:nRight-10 TITLE "Avalia็ใo EAA" PIXEL
	oDlg:lMaximized := .T.
	nWidth := oDlg:nWidth/2
	nHeight := oDlg:nHeight/2

	nPnlWdt	:= nWidth/2-30

	@00,00 MSPANEL oLPanel SIZE nPnlWdt,00 OF oDlg

	oLPanel:Align := CONTROL_ALIGN_LEFT
	_xusername := space(40)

	@ 003, 05 SAY oSay1 PROMPT "Usuแrio" SIZE 033, 009  OF oLPanel COLOR CLR_GREEN PIXEL
	@ 003, 48 MSGET oGet1 VAR _cUser      F3 'USR' VALID _GeraTree(_cUser , _cAno)  WHEN .f. SIZE 30, 010    OF odlg COLORS 0, 16777215 PIXEL
	@ 003, 90 SAY oSay1Name PROMPT _xusername SIZE 033, 009  OF oLPanel COLORS 0, 16777215 PIXEL

	@ 018, 005 SAY oSay3 PROMPT "Ano" SIZE 010, 009 OF oLPanel COLOR CLR_GREEN PIXEL
	@ 018, 048 MSGET oGet3 VAR _cAno    PICTURE '9999' VALID _GeraTree(_cUser , _cAno) WHEN EMPTY(_cAno) SIZE 10, 010 OF odlg COLORS 0, 16777215 PIXEL

	DEFINE DBTREE oTree1 FROM 035,005 TO nHeight-70,nPnlWdt-5 CARGO OF oDlg Pixel
	oTree1:bChange := {|| _MstDad(),oDlg:refresh() }
	oTree1:SetScroll(2,.T.)
//------------------------
// ## Painel dos Bot๕es ##
//------------------------


	@ 0,140  SAY  "Aval.Geral"  SIZE 35,6 OF oLPanel  PIXEL
	@ 7,140 MSCOMBOBOX oGera VAR cGera  ITEMS {'1','2','3','4','5'} SIZE 35,6 OF oLPanel PIXEL WHEN !Empty(Alltrim(_cAno))


	@ 20,140 BUTTON aBtn1 PROMPT "Comentแrios" SIZE 35,12 Of oLPanel PIXEL;
		ACTION (StComent()) WHEN !Empty(Alltrim(_cAno))


	@ 3,180 BUTTON aBtn1 PROMPT "Fechar Metas" SIZE 35,12 Of oLPanel PIXEL;
		ACTION (gr_Met()) WHEN nTree == 1

	@ 3,220 BUTTON aBtn2 PROMPT "Salvar" SIZE 35,12 Of oLPanel PIXEL;
		ACTION (gr_Dados()) WHEN nTree == 1

	@ 3,260 BUTTON aBtn3 PROMPT "Encerrar" SIZE 35,12 Of oLPanel PIXEL;
		ACTION (gr_Prova()) WHEN nTree == 1

	@ 20,180 BUTTON aBtn4 PROMPT "Cancelar" SIZE 35,12 Of oLPanel PIXEL;
		ACTION IF(FaCancOK(),oDlg:End(),oDlg:Refresh())

	@ 20,220 BUTTON aBtn5 PROMPT "Avaliar" SIZE 35,12 Of oLPanel PIXEL;
		ACTION IF(Fa_Avalia(),oDlg:End(),oDlg:Refresh())

	@ 20,260 BUTTON aBtn6 PROMPT "Imprimir" SIZE 35,12 Of oLPanel PIXEL;
		ACTION u__Fa_imprime()

	@ nHeight-55,010 SAY oSay1 PROMPT "M้dia Usuแrio" SIZE 50, 9  OF oLPanel Color CLR_HRED PIXEL
	@ nHeight-45,010 TO nHeight-20,140 OF olPanel  PIXEL
	@ nHeight-42,015 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,040 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,065 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,090 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,115 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL


	@ nHeight-55,150 SAY oSay1 PROMPT "M้dia Avaliador" SIZE 50, 9  OF oLPanel Color CLR_HRED PIXEL
	@ nHeight-45,150 TO nHeight-20,280 OF olPanel  PIXEL
	@ nHeight-42,155 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,180 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,205 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,230 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,255 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL


	ACTIVATE MSDIALOG oDlg ON INIT MsgRun( "Aguarde... Carregando Itens...", , {|| tel_dados() } )

Return aCreated


Static Function StComent()

	Local nOpca			:= 0
	Local aButtons		:= {}
	Private cCadastro 	:= "COMENTมRIOS"
	Private oDlg
	
	Dbselectarea("PH2")
	Dbsetorder(1)
	If Dbseek(xfilial("PH2")+ cCodAtual+_cAno)
		cMemo   := MSMM(PH2->PH2_COMEN)
	EndIf

	Define MSDialog oDlg Title cCadastro From 000,000 To 205,505 of GetWndDefault() Pixel

	oMemo	:= tMultiget():New(001,001,{|u|if(Pcount()>0,cMemo:=u,cMemo)},oDlg,252,088,,,,,,.T.)
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End() },{||oDlg:End()},,aButtons)

// se a opcao for encerrar executa a rotina.
	If nOpca == 1
		Dbselectarea("PH2")
		Dbsetorder(1)
		If Dbseek(xfilial("PH2")+ cCodAtual+_cAno)
				MSMM(PH2->PH2_COMEN,,,' ',1,,,"PH2","PH2_COMEN")
			PH2->(RecLock("PH2",.F.))
			MSMM(PH2->PH2_COMEN,,,cMemo,1,,,"PH2","PH2_COMEN")
			PH2->(MsUnlock("PH2"))
		EndIf
	EndIf

Return()
 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BDPCP001 บAutor  ณMicrosiga           บ Data ณ  12/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FaCancOK()

	_lRet := .f.
	If _alterado
		If MsgYesno("Deseja Abandonar Avalia็ใo ?")
			_lRet := .t.
		Endif
	Else
		_lRet := .t.
	Endif
Return _lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BDPCP001 บAutor  ณMicrosiga           บ Data ณ  12/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _GeraTree(_cUser , _cAno)
	Private lRet := .t.


	if !empty(_cUser) .and. !empty( _cAno)
	
		Dbselectarea("PH1")
		Dbsetorder(1)
		Dbseek(xfilial("PH1")+_cUser)
	
		if eof()
			Dbselectarea("PH1")
			Dbsetorder(2)
			Dbseek(xfilial("PH1")+_cUser)
			if eof()
				MsgStop("Usuario nao esta cadastrado para Avaliacao !")
				Return(.f.)
			endif
		endif
	
		if !oTree1:IsEmpty()
			_deltudo()
		endif
		Dbselectarea("PH1")
	
		cPrompt := PH1->PH1_USER +'-' + USRFULLNAME( PH1->PH1_USER ) //PH1_NOME
		cCargo := '00'+StrZero(PH1->(Recno()), 9)
		cFolderA := 'FOLDER5'
		cFolderB := 'FOLDER6'
	
		OTREE1:currentnodeid := "0000000"
	
		_CrgEstEaa(OTREE1, oDlg,PH1->PH1_USER, , , 3, ,, .T.,.T.,'00')
	
		Dbselectarea(oTree1:carqtree)
		OTREE1:TreeSeek("01000000001")
		OTREE1:Refresh()
	
		bsc_dados()
	
	
	Endif

//_xusername := UsrRetName(&(readvar()))
	oSay1Name:refresh()

Return .t.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BDPCP001 บAutor  ณMicrosiga           บ Data ณ  12/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _CrgEstEaa(OTREE1, oDlg, cUser, cCodSim, cRevisao, nOpcX, cCargo, cTRTPai, lZeraStatic,_lpai,_Nnivel)

	Local nRecAnt    := 0
	Local nRecSup    := 0
	Local cComp      := ''
	Local cPrompt    := ''
	Local cFolderA   := 'FOLDER5'
	Local cFolderB   := 'FOLDER6'
	Local lRet		  := .T.
	Local lContinua	  := .T.
	Local xUser      := PH1->PH1_USER
	Local xNivel     := strzero(val(_nNivel)+1,2)

	Static nNivelTr  := 0
	Static cFistCargo:= NIL


// -- Atualiza nivel
	nNivelTr += 1

	nOpcX := If(nOpcX==Nil,0,nOpcX)

	If lRet
		cCargo := xNivel+StrZero(PH1->(Recno()), 9)
		nRecAnt  := PH1->(Recno())
		cPrompt := PH1->PH1_USER +'-' + USRFULLNAME( PH1->PH1_USER )
	
		PH1->(dbSetOrder(2))
		PH1->(dbSeek(xFilial('PH1') + xUser , .F.))
	
		if eof()
		
			if !_lpai
				DBADDITEM OTREE1 PROMPT cPrompt RESOURCE cFolderA CARGO cCargo
			else
			
				oTree1:AddTree( cPrompt  ,.F.,cFolderA, cFolderB,,,cCargo)
				oTree1:EndTree()
				_lAvaliador := .f.
				atu_tel()
			endif
		
		else
		
			oTree1:AddTree( cPrompt  ,.F.,cFolderA, cFolderB,,,cCargo)
		
			Do While !PH1->(Eof()) .and. xUser == ph1->ph1_sup
			
				cComp    := PH1->PH1_USER
				cCargo   := xNivel+StrZero(PH1->(Recno()), 9)
			
			//-- Define as Pastas a serem usadas
				cFolderA := 'FOLDER5'
				cFolderB := 'FOLDER6'
			
				nRecSup  := PH1->(Recno())
			
			//-- Adiciona um Nivel a Arvore
				_CrgEstEAA(OTREE1, oDlg, ph1->ph1_user, '', "", If(nOpcX==3,0,nOpcX), cCargo, cTRTPai,.F.,.F.,xNivel)
			
				PH1->(dbSetOrder(2))
				PH1->(dbGoto(nRecSup))
				PH1->(dbSkip())
			
			EndDo
		
			oTree1:EndTree()
		
		Endif
	
		PH1->(dbSetOrder(1))
		PH1->(dbGoto(nRecAnt))
	
	Endif

	If lContinua
	// --- Atualiza nivel da estrutura
		nNivelTr -= 1
	EndIf

//Zera conteudo das variaveis static, necessario para montagem do tree na rotina MATC015.
	If ValType(lZeraStatic)=="L" .And. lZeraStatic
		nNivelTr  := 0
		cFistCargo:= NIL
	EndIf
Return lRet






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BDPCP001 บAutor  ณMicrosiga           บ Data ณ  12/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _DelTudo()

	Local _cCodigo
	Local _cCargo

	Do while !oTree1:IsEmpty()
	
		_cCodigo := oTree1:GetPrompt()
		_cCargo  := oTree1:GetCargo()
		oTree1:DelItem()
	
	Enddo

	oTree1:Refresh()

return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BDPCP001 บAutor  ณMicrosiga           บ Data ณ  12/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function _MstDad

	xArea := getarea()

	If _alterado
	
		If Msgyesno("Grava Dados Alterados ???" )
			gr_dados()
		Endif
	
	Endif


	if substr(oTree1:GetCargo(),1,2) == '02'  .and.  (oTree1:carqtree)->(RecCount()) > 1
	
	
	//oRPanel:end()
		_lAvaliador := .t.
		bsc_dados()
		atu_tel()
		orPanel:Refresh(.T.)
		orPanel:Show()
		oGetp1a:SetFocus()
	
	
	//	odlg:refresh()
	
	ELSE
	
	//	oRPanel:end()
		_lAvaliador := .F.
		bsc_dados()
		atu_tel()
		orPanel:Refresh(.T.)
		orPanel:Show()
		oGetp1a:SetFocus()
	
	
	
	endif

	_alterado := .f.

	RestArea(xArea)

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BDPCP001 บAutor  ณMicrosiga           บ Data ณ  12/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



Static Function Gr_dados

	Dbselectarea("PH2")
	Dbsetorder(1)
	Dbseek(xfilial("PH2")+ cCodAtual+_cAno)

	if eof()
		reclock("PH2",.T.)
		PH2_FILIAL := XFILIAL("PH2")
		PH2_USER   := cCodAtual
		PH2_ANO    := _cAno
	else
		reclock("PH2",.F.)
	endif

	if _lavaliador  .and. !empty(_c1obsa1)
	
		PH2_CMTAV1 := _c1obsa1
		PH2_AVAL1  := _n1Aval
		PH2_CMTAV2 := _c2obsa1
		PH2_AVAL2  := _n2Aval
		PH2_AVAL3  := _n3Aval
		PH2_CMTAV3 := _c3obsa1
		PH2_AVAL4  := _n4Aval
		PH2_CMTAV4 := _c4obsa1
		PH2_AVAL5  := _n5Aval
		PH2_CMTAV5 := _c5obsa1
	
	else
	
		PH2_PERG1  := _c1Pegunta1
		PH2_PERG2  := _c2Pegunta1
		PH2_PERG3  := _c3Pegunta1
		PH2_PERG4  := _c4Pegunta1
		PH2_PERG5  := _c5Pegunta1
	
		PH2_1MIN	:= _c1min1
		PH2_1TARGE  := _c1Tgt1
		PH2_1MAX    := _c1Max1
	
		PH2_2MIN	:= _c2min1
		PH2_2TARGE  := _c2Tgt1
		PH2_2MAX    := _c2Max1
	
		PH2_3MIN	:= _c3min1
		PH2_3TARGE  := _c3Tgt1
		PH2_3MAX    := _c3Max1
	
		PH2_4MIN	:= _c4min1
		PH2_4TARGE  := _c4Tgt1
		PH2_4MAX    := _c4Max1
	
		PH2_5MIN	:= _c5min1
		PH2_5TARGE  := _c5Tgt1
		PH2_5MAX    := _c5Max1
	
		PH2_RESP1  := _n1Result
		PH2_COM1   := _c1obsp1
	
		PH2_RESP2  := _n2Result
		PH2_COM2   := _c2obsp1
	
		PH2_RESP3  := _n3Result
		PH2_COM3   := _c3obsp1
	
		PH2_RESP4  := _n4Result
		PH2_COM4   := _c4obsp1
	
		PH2_RESP5  := _n5Result
		PH2_COM5   := _c5obsp1
	
	endif

//GIOVANI ZAGO 29/01/2015
	PH2_AVGERA  := cGera


	Msunlock()

	_alterado := .f.

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BDPCP001 บAutor  ณMicrosiga           บ Data ณ  12/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function tel_dados

	@00,00 MSPANEL oRPanel SIZE nPnlWdt+70,00 OF oDlg
//DEFINE MSDIALOG oRPanel FROM 5,oMainWnd:nRight-85-nPnlWdt TO oMainWnd:nBottom-nAdjust,oMainWnd:nRight-15 TITLE "Avalia็ใo EAA333" PIXEL of Odlg

	oRPanel:Align := CONTROL_ALIGN_LEFT

	_npasso := 0

	@ 1+_npasso,1 TO 054+_npasso,350 OF oRPanel  PIXEL
	@ 5+_npasso,004 SAY "Objetivo 1" OF oRPanel  PIXEL
	@ 5+_npasso,040 MSGET oGetp1a VAR _c1Pegunta1        SIZE 200, 08     WHEN ValGtObj()     OF oRPanel COLORS 0, 16777215 PIXEL

	@ 01+_npasso,250 SAY "Minimo" OF oRPanel  PIXEL
	@ 11+_npasso,250 MSGET oGetp2a VAR _c1min1     VALID _alterado := .T.  WHEN ValGtObj()  SIZE 30, 008   OF oRPanel COLORS 0, 16777215 PIXEL

	@ 01+_npasso,283 SAY "Target" OF oRPanel  PIXEL
	@ 11+_npasso,283 MSGET oGetp3a VAR _c1tgt1     VALID _alterado := .T.   WHEN ValGtObj()   SIZE 30, 008    OF oRPanel COLORS 0, 16777215 PIXEL

	@ 01+_npasso,316 SAY "Maximo" OF oRPanel  PIXEL
	@ 11+_npasso,316 MSGET oGetp4a VAR _c1max1     VALID _alterado := .T.   WHEN ValGtObj() SIZE 30, 008    OF oRPanel COLORS 0, 16777215 PIXEL

	@ 25+_npasso,005 SAY "Participante" OF oRPanel  PIXEL
	@ 25+_npasso,040 MSCOMBOBOX oCbx1 VAR _n1Result  ITEMS aCbx VALID _alterado := .T. .and. _ClestrUsr()  WHEN !_lavaliador .and. !_lEncerra SIZE 065, 8 OF oRPanel PIXEL

	@ 25+_npasso,130 SAY "Obs.:" OF oRPanel  PIXEL
	@ 25+_npasso,150 MSGET oGetp5a VAR _c1obsp1     VALID _alterado := .T.    SIZE 200, 08    OF oRPanel COLORS 0, 16777215 PIXEL


	@ 40+_npasso,005 SAY        osCbx1a PROMPT "Avaliador" OF oRPanel  PIXEL
	@ 40+_npasso,040 MSCOMBOBOX ogCbx1a VAR _n1Aval  ITEMS aCbx VALID _alterado := .T. .and. _ClestrAva() SIZE 065, 8 OF oRPanel PIXEL

	@ 40+_npasso,130 SAY   osGetp1a PROMPT "Obs.:" OF oRPanel  PIXEL
	@ 40+_npasso,150 MSGET ogGetp1a    VAR _c1obsa1      VALID _alterado := .T.  SIZE 200, 08    OF oRPanel COLORS 0, 16777215 PIXEL


// box 2

	_npasso := 56
	@ 1+_npasso,1 TO 054+_npasso,350 OF oRPanel  PIXEL
	@ 5+_npasso,004 SAY "Objetivo 2" OF oRPanel  PIXEL
	@ 5+_npasso,040 MSGET oGetp1b VAR _c2Pegunta1     VALID _alterado := .T.  WHEN ValGtObj()   SIZE 200, 08    OF oRPanel COLORS 0, 16777215 PIXEL

	@ 01+_npasso,250 SAY "Minimo" OF oRPanel  PIXEL
	@ 11+_npasso,250 MSGET oGetp2b VAR _c2min1       VALID _alterado := .T. WHEN ValGtObj()   SIZE 30, 008   OF oRPanel COLORS 0, 16777215 PIXEL

	@ 01+_npasso,283 SAY "Target" OF oRPanel  PIXEL
	@ 11+_npasso,283 MSGET oGetp3b VAR _c2tgt1       VALID _alterado := .T.  WHEN ValGtObj()  SIZE 30, 008    OF oRPanel COLORS 0, 16777215 PIXEL

	@ 01+_npasso,316 SAY "Maximo" OF oRPanel  PIXEL
	@ 11+_npasso,316 MSGET oGetp4b VAR _c2max1       VALID _alterado := .T.  WHEN ValGtObj() SIZE 30, 008    OF oRPanel COLORS 0, 16777215 PIXEL

	@ 25+_npasso,005 SAY "Participante" OF oRPanel  PIXEL
	@ 25+_npasso,040 MSCOMBOBOX oCbx2 VAR _n2Result  ITEMS aCbx VALID _alterado := .T.  .and. _ClestrUsr() WHEN !_lavaliador  .and. !_lEncerra  SIZE 065, 8 OF oRPanel PIXEL

	@ 25+_npasso,130 SAY "Obs.:" OF oRPanel  PIXEL
	@ 25+_npasso,150 MSGET oGetp5b VAR _c2obsp1       VALID _alterado := .T.    SIZE 200, 08    OF oRPanel COLORS 0, 16777215 PIXEL



	@ 40+_npasso,005 SAY        osCbx2a PROMPT "Avaliador" OF oRPanel  PIXEL
	@ 40+_npasso,040 MSCOMBOBOX ogCbx2a VAR _n2Aval  ITEMS aCbx VALID _alterado := .T. .and. _ClestrAva() SIZE 065, 8 OF oRPanel PIXEL

	@ 40+_npasso,130 SAY   osGetp2a PROMPT "Obs.:" OF oRPanel  PIXEL
	@ 40+_npasso,150 MSGET ogGetp2a    VAR _c2obsa1      VALID _alterado := .T.  SIZE 200, 08    OF oRPanel COLORS 0, 16777215 PIXEL


// box 3

	_npasso += 56
	@ 1+_npasso,1 TO 054+_npasso,350 OF oRPanel  PIXEL
	@ 5+_npasso,004 SAY "Objetivo 3" OF oRPanel  PIXEL
	@ 5+_npasso,040 MSGET oGetp1c VAR _c3Pegunta1     VALID _alterado := .T.  WHEN ValGtObj() SIZE 200, 08    OF oRPanel COLORS 0, 16777215 PIXEL

	@ 01+_npasso,250 SAY "Minimo" OF oRPanel  PIXEL
	@ 11+_npasso,250 MSGET oGetp2c VAR _c3min1        VALID _alterado := .T.   WHEN ValGtObj()  SIZE 30, 008   OF oRPanel COLORS 0, 16777215 PIXEL

	@ 01+_npasso,283 SAY "Target" OF oRPanel  PIXEL
	@ 11+_npasso,283 MSGET oGetp3c VAR _c3tgt1        VALID _alterado := .T.  WHEN ValGtObj()   .and. !_lMetas SIZE 30, 008    OF oRPanel COLORS 0, 16777215 PIXEL

	@ 01+_npasso,316 SAY "Maximo" OF oRPanel  PIXEL
	@ 11+_npasso,316 MSGET oGetp4c VAR _c3max1        VALID _alterado := .T.  WHEN ValGtObj() SIZE 30, 008    OF oRPanel COLORS 0, 16777215 PIXEL

	@ 25+_npasso,005 SAY "Participante" OF oRPanel  PIXEL
	@ 25+_npasso,040 MSCOMBOBOX oCbx3 VAR _n3Result  ITEMS aCbx VALID _alterado := .T. .and. _ClestrUsr() WHEN !_lavaliador  .and. !_lEncerra  SIZE 065, 8 OF oRPanel PIXEL

	@ 25+_npasso,130 SAY "Obs.:" OF oRPanel  PIXEL
	@ 25+_npasso,150 MSGET oGetp5c VAR _c3obsp1              VALID _alterado := .T.    SIZE 200, 08    OF oRPanel COLORS 0, 16777215 PIXEL


	@ 40+_npasso,005 SAY        osCbx3a PROMPT "Avaliador" OF oRPanel  PIXEL
	@ 40+_npasso,040 MSCOMBOBOX ogCbx3a VAR _n3Aval      ITEMS aCbx VALID _alterado := .T. .and. _ClestrAva() SIZE 065, 8 OF oRPanel PIXEL

	@ 40+_npasso,130 SAY   osGetp3a PROMPT "Obs.:"       OF oRPanel  PIXEL
	@ 40+_npasso,150 MSGET ogGetp3a    VAR _c3obsa1      VALID _alterado := .T.  SIZE 200, 08    OF oRPanel COLORS 0, 16777215 PIXEL

// box 4

	_npasso += 56
	@ 1+_npasso,1 TO 054+_npasso,350 OF oRPanel  PIXEL
	@ 5+_npasso,004 SAY "Objetivo 4" OF oRPanel  PIXEL
	@ 5+_npasso,040 MSGET oGetp1d VAR _c4Pegunta1        SIZE 200, 08   WHEN ValGtObj()  OF oRPanel COLORS 0, 16777215 PIXEL

	@ 01+_npasso,250 SAY "Minimo" OF oRPanel  PIXEL
	@ 11+_npasso,250 MSGET oGetp2d VAR _c4min1      VALID _alterado := .T.  WHEN ValGtObj() SIZE 30, 008   OF oRPanel COLORS 0, 16777215 PIXEL

	@ 01+_npasso,283 SAY "Target" OF oRPanel  PIXEL
	@ 11+_npasso,283 MSGET oGetp3d VAR _c4tgt1      VALID _alterado := .T.  WHEN ValGtObj() SIZE 30, 008    OF oRPanel COLORS 0, 16777215 PIXEL

	@ 01+_npasso,316 SAY "Maximo" OF oRPanel  PIXEL
	@ 11+_npasso,316 MSGET oGetp4d VAR _c4max1      VALID _alterado := .T.  WHEN ValGtObj() SIZE 30, 008    OF oRPanel COLORS 0, 16777215 PIXEL

	@ 25+_npasso,005 SAY "Participante" OF oRPanel  PIXEL
	@ 25+_npasso,040 MSCOMBOBOX oCbx4 VAR _n4Result  ITEMS aCbx VALID _alterado := .T. .and. _ClestrUsr() WHEN !_lavaliador  .and. !_lEncerra  SIZE 065, 8 OF oRPanel PIXEL

	@ 25+_npasso,130 SAY "Obs.:" OF oRPanel  PIXEL
	@ 25+_npasso,150 MSGET oGetp5d VAR _c4obsp1     VALID _alterado := .T.     SIZE 200, 08    OF oRPanel COLORS 0, 16777215 PIXEL



	@ 40+_npasso,005 SAY        osCbx4a PROMPT "Avaliador" OF oRPanel  PIXEL
	@ 40+_npasso,040 MSCOMBOBOX ogCbx4a VAR _n4Aval  ITEMS aCbx VALID _alterado := .T. .and. _ClestrAva() SIZE 065, 8 OF oRPanel PIXEL

	@ 40+_npasso,130 SAY   osGetp4a PROMPT "Obs.:" OF oRPanel  PIXEL
	@ 40+_npasso,150 MSGET ogGetp4a    VAR _c4obsa1      VALID _alterado := .T.  SIZE 200, 08    OF oRPanel COLORS 0, 16777215 PIXEL

// box 5

	_npasso += 56
	@ 1+_npasso,1 TO 054+_npasso,350 OF oRPanel  PIXEL
	@ 5+_npasso,004 SAY "Objetivo 5" OF oRPanel  PIXEL
	@ 5+_npasso,040 MSGET oGetp1e VAR _c5Pegunta1      VALID _alterado := .T.  WHEN ValGtObj() SIZE 200, 08    OF oRPanel COLORS 0, 16777215 PIXEL

	@ 01+_npasso,250 SAY "Minimo" OF oRPanel  PIXEL
	@ 11+_npasso,250 MSGET oGetp2e VAR _c5min1        VALID _alterado := .T.  WHEN ValGtObj()  SIZE 30, 008   OF oRPanel COLORS 0, 16777215 PIXEL

	@ 01+_npasso,283 SAY "Target" OF oRPanel  PIXEL
	@ 11+_npasso,283 MSGET oGetp3e VAR _c5tgt1        VALID _alterado := .T.  WHEN ValGtObj()  SIZE 30, 008    OF oRPanel COLORS 0, 16777215 PIXEL

	@ 01+_npasso,316 SAY "Maximo" OF oRPanel  PIXEL
	@ 11+_npasso,316 MSGET oGetp4e VAR _c5max1        VALID _alterado := .T.  WHEN ValGtObj()  SIZE 30, 008    OF oRPanel COLORS 0, 16777215 PIXEL

	@ 25+_npasso,005 SAY "Participante" OF oRPanel  PIXEL
	@ 25+_npasso,040 MSCOMBOBOX oCbx5 VAR _n5Result  ITEMS aCbx VALID _alterado := .T.  .and. _ClestrUsr() WHEN !_lavaliador  .and. !_lEncerra SIZE 065, 8 OF oRPanel PIXEL

	@ 25+_npasso,130 SAY "Obs.:" OF oRPanel  PIXEL
	@ 25+_npasso,150 MSGET oGetp5e VAR _c5obsp1     VALID _alterado := .T.     SIZE 200, 08    OF oRPanel COLORS 0, 16777215 PIXEL


	@ 40+_npasso,005 SAY        osCbx5a PROMPT "Avaliador" OF oRPanel  PIXEL
	@ 40+_npasso,040 MSCOMBOBOX ogCbx5a VAR _n5Aval  ITEMS aCbx VALID _alterado := .T. .and. _ClestrAva() SIZE 065, 8 OF oRPanel PIXEL

	@ 40+_npasso,130 SAY   osGetp5a PROMPT "Obs.:" OF oRPanel  PIXEL
	@ 40+_npasso,150 MSGET ogGetp5a    VAR _c5obsa1      VALID _alterado := .T.  SIZE 200, 08    OF oRPanel COLORS 0, 16777215 PIXEL


	atu_tel()
//ACTIVATE MSDIALOG oRpanel

return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BDPCP001 บAutor  ณMicrosiga           บ Data ณ  12/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function atu_tel


	oGetp1a:refresh()
	oGetp2a:refresh()
	oGetp3a:refresh()
	oGetp4a:refresh()
	oGetp5a:refresh()

	oGetp1b:refresh()
	oGetp2b:refresh()
	oGetp3b:refresh()
	oGetp4b:refresh()
	oGetp5b:refresh()

	oGetp1c:refresh()
	oGetp2c:refresh()
	oGetp3c:refresh()
	oGetp4c:refresh()
	oGetp5c:refresh()

	oGetp1d:refresh()
	oGetp2d:refresh()
	oGetp3d:refresh()
	oGetp4d:refresh()
	oGetp5d:refresh()

	oGetp1e:refresh()
	oGetp2e:refresh()
	oGetp3e:refresh()
	oGetp4e:refresh()
	oGetp5e:refresh()

	ocbx1:refresh()
	ocbx2:refresh()
	ocbx3:refresh()
	ocbx4:refresh()
	ocbx5:refresh()


	if !_lAvaliador
	
		ogCbx1a:lvisible:=.f.
		osCbx1a:lvisible:=.f.
		ogGetp1a:lvisible:=.f.
		osGetp1a:lvisible:=.f.
	
		osGetp1a:refresh()
		ogGetp1a:refresh()
		osCbx1a:refresh()
		ogCbx1a:refresh()
	
		ogCbx2a:lvisible:=.f.
		osCbx2a:lvisible:=.f.
		ogGetp2a:lvisible:=.f.
		osGetp2a:lvisible:=.f.
	
		osGetp2a:refresh()
		ogGetp2a:refresh()
		osCbx2a:refresh()
		ogCbx2a:refresh()
	
		ogCbx3a:lvisible:=.f.
		osCbx3a:lvisible:=.f.
		ogGetp3a:lvisible:=.f.
		osGetp3a:lvisible:=.f.
	
		osGetp3a:refresh()
		ogGetp3a:refresh()
		osCbx3a:refresh()
		ogCbx3a:refresh()
	
		ogCbx4a:lvisible:=.f.
		osCbx4a:lvisible:=.f.
		ogGetp4a:lvisible:=.f.
		osGetp4a:lvisible:=.f.
	
		osGetp4a:refresh()
		ogGetp4a:refresh()
		osCbx4a:refresh()
		ogCbx4a:refresh()
	
		ogCbx5a:lvisible:=.f.
		osCbx5a:lvisible:=.f.
		ogGetp5a:lvisible:=.f.
		osGetp5a:lvisible:=.f.
	
		osGetp5a:refresh()
		ogGetp5a:refresh()
		osCbx5a:refresh()
		ogCbx5a:refresh()
	
	Else
	
		ogCbx1a:lvisible:=.t.
		osCbx1a:lvisible:=.t.
		ogGetp1a:lvisible:=.t.
		osGetp1a:lvisible:=.t.
	
		osGetp1a:refresh()
		ogGetp1a:refresh()
		osCbx1a:refresh()
		ogCbx1a:refresh()
	
		ogCbx2a:lvisible:=.t.
		osCbx2a:lvisible:=.t.
		ogGetp2a:lvisible:=.t.
		osGetp2a:lvisible:=.t.
	
		osGetp2a:refresh()
		ogGetp2a:refresh()
		osCbx2a:refresh()
		ogCbx2a:refresh()
	
		ogCbx3a:lvisible:=.t.
		osCbx3a:lvisible:=.t.
		ogGetp3a:lvisible:=.t.
		osGetp3a:lvisible:=.t.
	
		osGetp3a:refresh()
		ogGetp3a:refresh()
		osCbx3a:refresh()
		ogCbx3a:refresh()
	
		ogCbx4a:lvisible:=.t.
		osCbx4a:lvisible:=.t.
		ogGetp4a:lvisible:=.t.
		osGetp4a:lvisible:=.t.
	
		osGetp4a:refresh()
		ogGetp4a:refresh()
		osCbx4a:refresh()
		ogCbx4a:refresh()
	
		ogCbx5a:lvisible:=.t.
		osCbx5a:lvisible:=.t.
		ogGetp5a:lvisible:=.t.
		osGetp5a:lvisible:=.t.
	
		osGetp5a:refresh()
		ogGetp5a:refresh()
		osCbx5a:refresh()
		ogCbx5a:refresh()
	
	Endif
	/*/
	if _lEncerra
		aBtn3:lvisible:=.T.
	else
		aBtn3:lvisible:=.F.
	Endif


	if _lMetas
		aBtn1:lvisible:=.T.
	else
		aBtn1:lvisible:=.F.
	Endif

	aBtn1:refresh()
	aBtn3:refresh()
	/*/

	_ClestrUsr()
	if _lAvaliador
		_ClestrAva()
	endif
return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BDPCP001 บAutor  ณMicrosiga           บ Data ณ  12/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



Static Function bsc_dados

	Local _cCodigo := substr(oTree1:GetPrompt(),1,6)
	cCodAtual := substr(oTree1:GetPrompt(),1,6)

	Dbselectarea("PH2")
	Dbsetorder(1)
	Dbseek(xfilial("PH2")+_cCodigo+_cAno)

	if !eof()
	//GIOVANI ZAGO 29/01/2015
		cGera := PH2_AVGERA
	
	
		_n1Aval		:= if(val(PH2_AVAL1)<>0 ,aCbx[val(PH2_AVAL1)]," ")
		_n2Aval		:= if(val(PH2_AVAL2)<>0 ,aCbx[val(PH2_AVAL2)]," ")
		_n3Aval		:= if(val(PH2_AVAL3)<>0 ,aCbx[val(PH2_AVAL3)]," ")
		_n4Aval		:= if(val(PH2_AVAL4)<>0 ,aCbx[val(PH2_AVAL4)]," ")
		_n5Aval		:= if(val(PH2_AVAL5)<>0 ,aCbx[val(PH2_AVAL5)]," ")
	
		_c1obsa1	:= PH2_CMTAV1
		_c2obsa1	:= PH2_CMTAV2
		_c3obsa1	:= PH2_CMTAV3
		_c4obsa1	:= PH2_CMTAV4
		_c5obsa1	:= PH2_CMTAV5
	
		_c1Pegunta1:=PH2_PERG1
		_c2Pegunta1:=PH2_PERG2
		_c3Pegunta1:=PH2_PERG3
		_c4Pegunta1:=PH2_PERG4
		_c5Pegunta1:=PH2_PERG5
	
		_c1min1:=PH2_1MIN
		_c1Tgt1:=PH2_1TARGE
		_c1Max1:=PH2_1MAX
	
		_c2min1:=PH2_2MIN
		_c2Tgt1:=PH2_2TARGE
		_c2Max1:=PH2_2MAX
	
		_c3min1:=PH2_3MIN
		_c3Tgt1:=PH2_3TARGE
		_c3Max1:=PH2_3MAX
	
		_c4min1:=PH2_4MIN
		_c4Tgt1:=PH2_4TARGE
		_c4Max1:=PH2_4MAX
	
		_c5min1:=PH2_5MIN
		_c5Tgt1:=PH2_5TARGE
		_c5Max1:=PH2_5MAX
	
		_n1Result := if(val(PH2_RESP1)<>0 ,aCbx[val(PH2_RESP1)]," ")
		_c1obsp1  := PH2_COM1
	
		_n2Result := if(val(PH2_RESP2)<>0 ,aCbx[val(PH2_RESP2)]," ")
		_c2obsp1  := PH2_COM2
	
		_n3Result := if(val(PH2_RESP3)<>0 ,aCbx[val(PH2_RESP3)]," ")
		_c3obsp1  := PH2_COM3
	
		_n4Result := if(val(PH2_RESP4)<>0 ,aCbx[val(PH2_RESP4)]," ")
		_c4obsp1  := PH2_COM4
	
		_n5Result := if(val(PH2_RESP5)<>0 ,aCbx[val(PH2_RESP5)]," ")
		_c5obsp1  := PH2_COM5
	
		if PH2_METAS <> ' '
			_lMetas := .t.
		ELSE
			_lMetas := .F.
		
		ENDIF
	
		if PH2_ENCEAA<> ' '
			_lEncerra := .t.
		ELSE
			_lEncerra := .F.
		
		ENDIF
	else
	
		_c1Pegunta1 := space(200)
		_n1Result 	:= " "
		_n1Aval 	:= 0
		_c1min1 	:= space(10)
		_c1max1 	:= space(10)
		_c1tgt1 	:= space(10)
		_c1obsp1 	:= space(200)
		_c1obsa1 	:= space(200)
	
		_c2Pegunta1 := space(200)
		_n2Result 	:= " "
		_n2Aval 	:= 0
		_c2min1 	:= space(10)
		_c2max1 	:= space(10)
		_c2tgt1 	:= space(10)
		_c2obsp1 	:= space(200)
		_c2obsa1 	:= space(200)
	
		_c3Pegunta1 := space(200)
		_n3Result 	:= " "
		_n3Aval 	:= 0
		_c3min1 	:= space(10)
		_c3max1 	:= space(10)
		_c3tgt1 	:= space(10)
		_c3obsp1 	:= space(200)
		_c3obsa1 	:= space(200)
	
		_c4Pegunta1 := space(200)
		_n4Result 	:= " "
		_n4Aval 	:= 0
		_c4min1 	:= space(10)
		_c4max1 	:= space(10)
		_c4tgt1 	:= space(10)
		_c4obsp1 	:= space(200)
		_c4obsa1 	:= space(200)
	
		_c5Pegunta1 := space(200)
		_n5Result 	:= ""
		_n5Aval 	:= 0
		_c5min1 	:= space(10)
		_c5max1 	:= space(10)
		_c5tgt1 	:= space(10)
		_c5obsp1 	:= space(200)
		_c5obsa1 	:= space(200)
	
		_lMetas 	:= .F.
		_lEncerra 	:= .F.
	
	endif

	Msunlock()

	atu_tel()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTGPE002  บAutor  ณMicrosiga           บ Data ณ  01/22/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function gr_Met()

	_cArea := getarea()

	Dbselectarea("PH2")
	Dbsetorder(1)
	Dbseek(xfilial("PH2")+cCodAtual+_cAno)

	IF EOF()
		GR_DADOS()
	ENDIF

	if empty(PH2_METAS) .and. msgYesNo("Encerra inclusao da Metas ? (S/N)")
	
	
		RecLock("PH2",.f.)
		PH2_METAS := 'S'
		Msunlock()
	
	Elseif msgYesNo("Metas Encerradass ! Deseja Reabrir da Metas ? (S/N)")
		RecLock("PH2",.f.)
		PH2_METAS := ' '
		Msunlock()
	endif

 
	bsc_dados()
	
	RestArea(_cArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTGPE002  บAutor  ณMicrosiga           บ Data ณ  01/22/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function gr_PROVA()
	_cArea := getarea()

	Dbselectarea("PH2")
	Dbsetorder(1)
	Dbseek(xfilial("PH2")+cCodAtual+_cAno)

	if eof() //.or. empty(PH2_ENCEAA)
	
		MsgStop("Voce Ainda nao Pode encerrar a EAA")
	Else
	
		if empty(PH2_ENCEAA) .and. msgYesNo("Encerra Auto Avaliacao ? (S/N)")
		
		
		
			RecLock("PH2",.f.)
			PH2_ENCEAA := 'S'
			Msunlock()
		
			_Email_EAA("Auto",cCodAtual,_cAno)


		
		endif
	Endif
	RestArea(_cArea)

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTGPE002  บAutor  ณMicrosiga           บ Data ณ  01/22/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER Function _fa_imprime()

	Local lEnd 		:= .t.
	Local wnRel   	:= 'STGPE002'
	Local cString 	:= 'PH2'
	Local Titulo  	:= 'Avalia็ใo EAA'

	PRIVATE _cPath		  := GetSrvProfString("RootPath","")
	PRIVATE cStartPath 	  := '\EAA\'
	PRIVATE _cNomePdf     := ''

	_cNomePdf  :="EAA_"+cCodAtual
	oPrn:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , '\EAA\'  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
	oPrn:SetPortrait()
	oPrn:SetMargin(60,60,60,60)
	oPrn:setPaperSize(9)
	oPrn:setup()

	oPrn:cPathPDF := cStartPath

	RptStatus({|lEnd| RGPE01Imp(@lEnd,wnRel,cString,cCodAtual)},Titulo)

	oPrn:Print()
	_aDirProc := 'C:\EAA\'
	if !ExistDir(_aDirProc)
		MakeDir(_aDirProc)
	Endif

	FERASE('c:\EAA\'+_cNomePdf+".pdf")

	_cArqPDF  := cStartPath+alltrim(_cNomePdf)+'.pdf'
	cPath 			:= "c:\EAA\"

	If CpyS2T(_cArqPDF, cPath, .T.)
		ShellExecute("open",'C:\EAA\'+_cNomePdf+'.pdf', "", "", 1)
	Endif

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTGPE002  บAutor  ณMicrosiga           บ Data ณ  01/22/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fa_avalia()

	_cArea := getarea()

	Dbselectarea("PH2")
	Dbsetorder(1)
	Dbseek(xfilial("PH2")+cCodAtual+_cAno)

	if eof()
	
		gr_dados()
	
	endif

	if empty(PH2_ENCGES) .and. msgYesNo("Encerra Avaliacao deste participante ? (S/N)")
	
		RecLock("PH2",.f.)
		PH2_ENCGES := 'S'
		Msunlock()
	
		_Email_EAA("Gestor",cCodAtual,_cAno)
	
	endif

	RestArea(_cArea)

Return .T.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTGPE002  บAutor  ณMicrosiga           บ Data ณ  01/22/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _Email_EAA(_cTipo,cCodAtual,_cAno)

	Local aArea 	:= GetArea()
	Local _cAssunto:= "EAA - Status"
	Local cFuncSent:= "StGPEMail"
	Local _aMsg    :={}
	Local cMsg     := ""
	Local _nLin


	Private _cEmail  := " "

	Dbselectarea("PH1")
	Dbsetorder(1)
	Dbseek(xfilial("PH1")+_cUser)

	PswOrder(1)
	If PswSeek( PH1->PH1_SUP )
		_cEmail := PswRet()[1,14]
	Endif

	_cEmail := "gallo@rvgsolucoes.com.br"

	IF !EMPTY(_cEmail)
	
		Aadd( _aMsg , { "EAA: "             , cCodAtual+" - "+_cAno } )
		if _cTipo == 'Auto'
			Aadd( _aMsg , { "Ocorrencia: "    	, "Conclusใo Auto Avalia็o"  } )
		else
			Aadd( _aMsg , { "Ocorrencia: "    	, "Conclusใo Avalia็ใo do Gestor"  } )
		endif
	
		Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
		Aadd( _aMsg , { "Hora: "    		, time() } )
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Definicao do cabecalho do email                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' +   " EAA - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
	//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Definicao do texto/detalhe do email                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Definicao do rodape do email                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
	
	
		STMAILGPE(_cEmail, "", _cAssunto, cMsg , "")
	endif
	RestArea(aArea)

Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTGPE002  บAutor  ณMicrosiga           บ Data ณ  01/26/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _ClestrUsr
	Local _n,_nMedia,_nCol,_nQuantos

	@ nHeight-42,015 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,040 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,065 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,090 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,115 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL

	_nQuantos := iif(!empty(_n1Result),1,0) + iif(!empty(_n2Result),1,0) + iif(!empty(_n3Result),1,0) + iif(!empty(_n4Result),1,0) + iif(!empty(_n5Result),1,0)

	_nMedia := (( val(substr(_n1Result,1,1)) + val(substr(_n2Result,1,1)) + val(substr(_n3Result,1,1)) + val(substr(_n4Result,1,1)) + val(substr(_n5Result,1,1)) ) / _nQuantos )

	_nCol := 0

	For _n := 1 to int(_nMedia)
		@ nHeight-42,015+_nCol BITMAP oBmp FILE "estrela00.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
		_nCol+=25
	Next n
	_nSobra := (_nMedia - int(_nMedia))*100
	do case
	
	case _nSobra >= 1 .and.  _nSobra <= 40
		@ nHeight-42,015+_nCol BITMAP oBmp FILE "estrela25.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
		
	case _nSobra >= 41 .and.  _nSobra <= 60
		@ nHeight-42,015+_nCol BITMAP oBmp FILE "estrela50.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
		
	case _nSobra >= 61 .and.  _nSobra <= 90
		@ nHeight-42,015+_nCol BITMAP oBmp FILE "estrela75.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
		
	case _nSobra >= 91 .and.  _nSobra <= 99
		@ nHeight-42,015+_nCol BITMAP oBmp FILE "estrela00.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
		
	endcase

Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTGPE002  บAutor  ณMicrosiga           บ Data ณ  01/26/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _ClestrAva
	Local _n,_nMedia,_nCol,_nQuantos

	@ nHeight-42,155 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,180 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,205 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,230 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
	@ nHeight-42,255 BITMAP oBmp FILE "estrela.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL

	_nQuantos := iif(!empty(_n1Aval),1,0) + iif(!empty(_n2Aval),1,0) + iif(!empty(_n3Aval),1,0) + iif(!empty(_n4Aval),1,0) + iif(!empty(_n5Aval),1,0)

	if ValType( _n1Aval ) == "C"
		_nMedia := (( val(substr(_n1Aval,1,1)) + val(substr(_n2Aval,1,1)) + val(substr(_n3Aval,1,1)) + val(substr(_n4Aval,1,1)) + val(substr(_n5Aval,1,1)) ) / _nQuantos )
	else
		_nMedia :=  ((_n1Aval + _n2Aval + _n3Aval + _n4Aval + _n5Aval )  / _nQuantos )
	endif

	_nCol := 0

	For _n := 1 to int(_nMedia)
		@ nHeight-42,155+_nCol BITMAP oBmp FILE "estrela00.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
		_nCol+=25
	Next n
	_nSobra := (_nMedia - int(_nMedia))*100
	do case
	
	case _nSobra >= 1 .and.  _nSobra <= 40
		@ nHeight-42,155+_nCol BITMAP oBmp FILE "estrela25.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
		
	case _nSobra >= 41 .and.  _nSobra <= 60
		@ nHeight-42,155+_nCol BITMAP oBmp FILE "estrela50.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
		
	case _nSobra >= 61 .and.  _nSobra <= 90
		@ nHeight-42,155+_nCol BITMAP oBmp FILE "estrela75.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
		
	case _nSobra >= 91 .and.  _nSobra <= 99
		@ nHeight-42,155+_nCol BITMAP oBmp FILE "estrela00.bmp" OF olpanel NOBORDER SIZE 20,20 PIXEL
		
	endcase

Return .t.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTGPE002  บAutor  ณMicrosiga           บ Data ณ  01/26/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STMAILGPE(_cEmail,_cAssunto,cMsg,cAttach)
	Local oMail , oMessage , nErro
	Local lRet := .T.
	Local cCopia := " "
	Local cSMTPServer	:= GetMV("MV_RELSERV",,"smtp.servername.com.br")
	Local cSMTPUser		:= GetMV("MV_RELACNT",,"minhaconta@servername.com.br")
	Local cSMTPPass		:= GetMV("MV_RELPSW",,"minhasenha")
	Local cMailFrom		:= GetMV("MV_RELACNT",,"minhaconta@servername.com.br")
	Local nPort	   		:= GetMV("MV_GCPPORT",,25)
	Local lUseAuth		:= GetMV("MV_RELAUTH",,.T.)

	cPara    := _cEmail

	conout('Conectando com SMTP ['+cSMTPServer+'] ')

	oMail := TMailManager():New()

	conout('Inicializando SMTP')
	oMail:Init( '', cSMTPServer , cSMTPUser, cSMTPPass, 0, nPort  )

	conout('Setando Time-Out')
	oMail:SetSmtpTimeOut( 30 )

	conout('Conectando com servidor...')
	nErro := oMail:SmtpConnect()

	conout('Status de Retorno = '+str(nErro,6))

	If lUseAuth
		Conout("Autenticando Usuario ["+cSMTPUser+"] senha ["+cSMTPPass+"]")
		nErro := oMail:SmtpAuth(cSMTPUser ,cSMTPPass)
		conout('Status de Retorno = '+str(nErro,6))
		If nErro <> 0
		// Recupera erro ...
			cMAilError := oMail:GetErrorString(nErro)
			DEFAULT cMailError := '***UNKNOW***'
			Conout("Erro de Autenticacao "+str(nErro,4)+' ('+cMAilError+')')
			lRet := .F.
		Endif
	Endif

	if nErro <> 0
	
	// Recupera erro
		cMAilError := oMail:GetErrorString(nErro)
		DEFAULT cMailError := '***UNKNOW***'
		conout(cMAilError)
	
		msgstop("Erro de Conexใo SMTP "+str(nErro,4))
	
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
	
		lRet := .F.
	
	Endif

	If lRet
		conout('Compondo mensagem em mem๓ria')
		oMessage := TMailMessage():New()
		oMessage:Clear()
		oMessage:cFrom	:= cMailFrom
		oMessage:cTo	:= cPara
		If !Empty(cCopia)
			oMessage:cCc	:= cCopia
		Endif
		oMessage:cSubject	:= _cAssunto
		oMessage:cBody		:= cMsg
	//Adiciona um attach
		IF !EMPTY(cAttach)
			If oMessage:AttachFile( cAttach ) < 0
				Conout( "Erro ao atachar o arquivo" )
				Return .F.
			Else
			//adiciona uma tag informando que ้ um attach e o nome do arq
				oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+cAttach)
			EndIf
		Endif
		conout('Enviando Mensagem para ['+cPara+'] ')
		nErro := oMessage:Send( oMail )
	
		if nErro <> 0
			xError := oMail:GetErrorString(nErro)
			msgstop("Erro de Envio SMTP "+str(nErro,4)+" ("+xError+")")
			lRet := .F.
		Endif
	
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
	Endif

Return(lRet)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRGPE01IMP บAutor  ณ RVG Solucoes       บ Data ณ  03/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio                                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RGPE01IMP(lEnd,WnRel,cString,cCodAtual)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Locais (Programa)                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local _n,_nMedia,_nCol,_nQuantos
	Private	aDescFil := {}
	Private cFilQueb
	Private _nlarg := 520

// Crea los objetos con las configuraciones de fuentes
	oFont08  := TFont():New( "Arial",,08,,.f.,,,,,.f. )
	oFont08b := TFont():New( "Arial",,08,,.t.,,,,,.f. )
	oFont09  := TFont():New( "Arial",,09,,.f.,,,,,.f. )
	oFont09b := TFont():New( "Arial",,09,,.t.,,,,,.f. )
	oFont10  := TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f. )
	oFont11  := TFont():New( "Arial",,11,,.f.,,,,,.f. )
	oFont11b := TFont():New( "Arial",,11,,.t.,,,,,.f. )
	oFont12  := TFont():New( "Arial",,12,,.f.,,,,,.f. )
	oFont12B := TFont():New( "Times New Roman",,12,,.t.,,,,,.f. )
	oFont12BI:= TFont():New( "Arial",,12,,.t.,,,,,.t. )
	oFont20b := TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
	oFont22b := TFont():New( "Times New Roman",,22,,.t.,,,,,.f. )
	oFont24b := TFont():New( "Times New Roman",,24,,.t.,,,,,.f. )

//oPrn := TMSPrinter():New()

	oPrn:StartPage()


	xCabGpe()
	oprn:Box(140,005,800,_nlarg)

	_nFator := 100
	_nIni   := 150
	_ntamLin := 10

	Dbselectarea("PH2")
	Dbsetorder(1)
	Dbseek(xfilial("PH2")+cCodAtual+_cAno)

	Dbselectarea("PH1")
	Dbsetorder(1)
	Dbseek(xfilial("PH1")+cCodAtual)

	oprn:Say  (_nIni,10              , "Colaborador: "  ,oFont08)
	oprn:Say  (_nIni,100             ,   PH1->PH1_NOME  ,oFont08)
	oprn:Say  (_nIni+_ntamLin,10     , "Ano: "  		,oFont08)
	oprn:Say  (_nIni+_ntamLin,100    , _cAno  			,oFont08)
	oprn:Say  (_nIni+(_ntamLin*2),10 , "Cargo: "  		,oFont08)
	oprn:Say  (_nIni+(_ntamLin*2),100, PH1->PH1_CARGO   ,oFont08)
	oprn:Say  (_nIni+(_ntamLin*3),10 , "Setor: "  		,oFont08)
	oprn:Say  (_nIni+(_ntamLin*3),100, PH1->PH1_SETOR   ,oFont08)
	_nIni += (_ntamLin*4)

	oPrn:Line(_nIni    , 5 , _nIni ,_nlarg)   	// horizontal
	oPrn:Line(_nIni+1 , 5 , _nIni +1,_nlarg)   	// horizontal
	oPrn:Line(_nIni+2 , 5 , _nIni +2,_nlarg)   	// horizontal
	oPrn:Line(_nIni+3 , 5 , _nIni +3,_nlarg)   	// horizontal
	_nIni += 10
	Dbselectarea("PH2")

	_nQuantos := 0
	_nMediapar:= 0
	_nMediaAva:= 0
	For _n := 1 to 5
	
		_cPerg 	:= &('PH2_PERG'+str(_n,1) )
		_cmin 	:= &('PH2_'+str(_n,1) +'MIN')
		_ctarget:= &('PH2_'+str(_n,1) +'TARGE')
		_cmax 	:= &('PH2_'+str(_n,1) +'MAX')
		_cAval 	:= &('PH2_AVAL'+str(_n,1) )
		_cCmtAV := &('PH2_CMTAV'+str(_n,1) )
		_cResp  := &('PH2_RESP'+str(_n,1) )
		_cCom   := &('PH2_COM'+str(_n,1) )
	
		if !empty(_cPerg)
		
			oprn:Say  (_nIni+(_ntamLin*0.5),10 , "Objetivo "  + str(_n,1)+":"	  	 ,oFont08)
			oprn:Say  (_nIni+(_ntamLin*1.5),10 , substr(_cPerg,01,70)                ,oFont08)
			oprn:Say  (_nIni+(_ntamLin*2.5),10 , substr(_cPerg,71,70)                ,oFont08)
			oprn:Say  (_nIni+(_ntamLin*3.5),10 , substr(_cPerg,141,50)               ,oFont08)
		
			oprn:Say  (_nIni+(_ntamLin*0.5),420 , "Parametros: "  		,oFont08)
			oprn:Say  (_nIni+(_ntamLin*1.5),420, "Minino: "  			,oFont08)
			oprn:Say  (_nIni+(_ntamLin*1.5),460, _cMin                  ,oFont08)
		
			oprn:Say  (_nIni+(_ntamLin*2.5),420, "Target: "  			,oFont08)
			oprn:Say  (_nIni+(_ntamLin*2.5),460, _cTarget             ,oFont08)
		
			oprn:Say  (_nIni+(_ntamLin*3.5),420, "Maximo: "  			,oFont08)
			oprn:Say  (_nIni+(_ntamLin*3.5),460, _cMax                ,oFont08)
		
		
			oPrn:Line(_nIni-10  , 410 , (_nIni+(_ntamLin*4)) ,410)   					// vertical
			oPrn:Line((_nIni+(_ntamLin*4)) , 5 , (_nIni+(_ntamLin*4)) ,_nlarg)   	// horizontal
		
			oprn:Say  (_nIni+(_ntamLin*5),10 , "Alcan็ado: "  		,oFont08)
			oprn:Say  (_nIni+(_ntamLin*5),100, if(_cResp <> ' ', aCbx[val(_cResp)],' ')   ,oFont08)
		
			oprn:Say  (_nIni+(_ntamLin*6),10 , "Comentแrio: "  		,oFont08)
			oprn:Say  (_nIni+(_ntamLin*6),100, alltrim(substr(_cCom,1,100))               ,oFont08)
			oprn:Say  (_nIni+(_ntamLin*6.7),100, alltrim(substr(_cCom,101,100))               ,oFont08)
		
			oPrn:Line((_nIni+(_ntamLin*7.2)) , 5 , (_nIni+(_ntamLin*7.2)) ,_nlarg)   	// horizontal
		
			oprn:Say  (_nIni+(_ntamLin*8),10 , "Superior: "  		,oFont08)
			oprn:Say  (_nIni+(_ntamLin*8),100, if(_cAval <> ' ', aCbx[val(_cAval)],' ')    ,oFont08)
		
			oprn:Say  (_nIni+(_ntamLin*9),10 , "Comentแrio Sup.: "	,oFont08)
		//		oprn:Say  (_nIni+(_ntamLin*9),100, _cCmtAv              ,oFont08)
			oprn:Say  (_nIni+(_ntamLin*9),100, alltrim(substr(_cCmtAv ,1,100))               ,oFont08)
			oprn:Say  (_nIni+(_ntamLin*9.7),100, alltrim(substr(_cCmtAv ,101,100))               ,oFont08)
		
			_nIni += (_ntamLin*10)
		
			oPrn:Line(_nIni , 5 , _nIni ,_nlarg)   	// horizontal
			oPrn:Line(_nIni+1 , 5 , _nIni +1,_nlarg)   	// horizontal
			oPrn:Line(_nIni+2 , 5 , _nIni +2,_nlarg)   	// horizontal
			oPrn:Line(_nIni+3 , 5 , _nIni +3,_nlarg)   	// horizontal
		
			_nIni+= 10
			_nQuantos++
			_nMediapar+=val(_cResp)
			_nMediaAva+=val(_cAval)
		Endif
	
	Next _n

	_nMedia := (_nMediapar / _nQuantos )

	_nIni += 10
	_nCol := 30
	_nStarts := 0
	oprn:Say  (_nIni,8 , "Media Colaborador: "	,oFont08)
	oprn:Say  (_nIni,318 , "Media Avaliador: "	,oFont08)
	_nIni += 10

	For _n := 1 to int(_nMedia)
		oprn:SayBitmap(_nIni,_ncol,"estrela00.bmp",020,020 )
		_nCol+=25
		_nStarts++
	Next n

	_nSobra := (_nMedia - int(_nMedia))*100

	do case
	
	case _nSobra >= 1 .and.  _nSobra <= 40
		oprn:SayBitmap(_nIni,_ncol,"estrela25.bmp",020,020 )
		_nStarts++
		
		_nCol+=25
	case _nSobra >= 41 .and.  _nSobra <= 60
		oprn:SayBitmap(_nIni,_ncol,"estrela50.bmp",020,020 )
		_nStarts++
		_nCol+=25
	case _nSobra >= 61 .and.  _nSobra <= 90
		oprn:SayBitmap(_nIni,_ncol,"estrela75.bmp",020,020 )
		_nStarts++
		_nCol+=25
	case _nSobra >= 91
		oprn:SayBitmap(_nIni,_ncol,"estrela00.bmp",020,020 )
		_nStarts++
		_nCol+=25
	endcase

	For _n := _nStarts+1 to 5
		oprn:SayBitmap(_nIni,_ncol,"estrela.bmp",020,020 )
		_nCol+=25
		_nStarts++
	Next n


	_nMedia := (_nMediaAva / _nQuantos )

	_nCol := 330

	_nStarts:=0

	For _n := 1 to int(_nMedia)
		oprn:SayBitmap(_nIni,_ncol,"estrela00.bmp",020,020 )
		_nCol+=25
		_nStarts++
	Next n

	_nSobra := (_nMedia - int(_nMedia))*100

	do case
	
	case _nSobra >= 1 .and.  _nSobra <= 40
		oprn:SayBitmap(_nIni,_ncol,"estrela25.bmp",020,020 )
		_nStarts++
		_nCol+=25
	case _nSobra >= 41 .and.  _nSobra <= 60
		oprn:SayBitmap(_nIni,_ncol,"estrela50.bmp",020,020 )
		_nStarts++
		_nCol+=25
	case _nSobra >= 61 .and.  _nSobra <= 90
		oprn:SayBitmap(_nIni,_ncol,"estrela75.bmp",020,020 )
		_nStarts++
		_nCol+=25
	case _nSobra >= 91
		oprn:SayBitmap(_nIni,_ncol,"estrela00.bmp",020,020 )
		_nStarts++
		_nCol+=25
	endcase

	For _n := _nStarts+1 to 5
		oprn:SayBitmap(_nIni,_ncol,"estrela.bmp",020,020 )
		_nCol+=25
		_nStarts++
	Next n

	oPrn:EndPage()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTGPE002  บAutor  ณMicrosiga           บ Data ณ  01/29/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xCabGpe()

	PRIVATE _cNomeCom     := SM0->M0_NOMECOM
	PRIVATE _cEndereco    := SM0->M0_ENDENT
	PRIVATE cCep          := SM0->M0_CEPENT
	PRIVATE cCidade       := SM0->M0_CIDENT
	PRIVATE cEstado       := SM0->M0_ESTENT
	PRIVATE cCNPJ         := SM0->M0_CGC
	PRIVATE cTelefone     := SM0->M0_TEL
	PRIVATE cFax          := SM0->M0_FAX
	PRIVATE cResponsavel  := Alltrim(MV_PAR04)
	PRIVATE cIe           := Alltrim(SM0->M0_INSC)

	oprn:Box(045,005,130,520)

	aBmp := "STECK.BMP"

	If File(aBmp)
		oprn:SayBitmap(060,020,aBmp,095,050 )
	EndIf

	oprn:Say  (070,120, _cNomeCom  ,oFont12)
	oprn:Say  (085,120, _cEndereco ,oFont12)
	oprn:Say  (100,120,"CEP: "+ SUBSTR(cCep,1,5)+"-"+SUBSTR(cCep,6,3) +" - "+Alltrim(cCidade)+" - "+cEstado,oFont12)
	oprn:Say  (120,350, 'Avalia็ใo E. A. A.'  ,oFont20b)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTGPE002  บAutor  ณMicrosiga           บ Data ณ  02/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function ValGtObj()

	Local _lRet := .t.

	if   _lMetas
	
		_lRet := .f.
	
	Endif

Return  _lRet
