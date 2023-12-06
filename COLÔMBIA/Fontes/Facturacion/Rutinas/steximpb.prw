#include "RwMake.ch"
#INCLUDE "Protheus.ch"
#Include "tbiconn.ch"
#Include "tbicode.ch"
#INCLUDE "TOPCONN.CH"

Static cRET     := ""
Static cCPOEX6  := "C6_ITEM/C6_PRODUTO/C6_DESCRI/C6_QTDVEN/C6_PRCVEN/C6_VALOR/C6_OPER/C6_TES"      // Campos que deverão ser considerados
Static cCPOEXK  := "CK_ITEM/CK_PRODUTO/CK_DESCRI/CK_QTDVEN/CK_PRCVEN/CK_VALOR/CK_OPER/CK_TES"      // Campos que deverão ser considerados
Static cAlias   := ""

/*/{@Protheus.doc} STEXIMPB
@description
Rotina para seleção de campos
@type function
@version  12.1.33
@author Valdemir Jose
@since 21/10/2021
/*/
User Function steximpb(pAlias)
    Local oConfirma := Nil
    Local oCancela  := Nil
    Local aLay      := {}
    Local aCampos   := {}
	Local aCPOCHV   := {}
    Local oWinSP01
    Local oWin1
    Local oWin2
    Local nColb     := 15
    Local oFont1    := TFont():New("MS Sans Serif", , 016, , .T., , , , , .F., .F.)

    Private aCoordenadas := MsAdvSize(.T.)
    Private cTitulo      := "SELEÇÃO DE CAMPOS"
    Private oOk          := LoadBitmap(GetResources(),"LBOK")
    Private oNo          := LoadBitmap(GetResources(),"LBNO")
    Private cVar
    Private oDlg
    Private oChk
    Private oTotReg
    Private oTotSel
    Private nTotReg      := 0
    Private nTotSel      := 0
    Private oLbx
    Private lChk         := .F.
    Private lChkBol      := .T.
    Private lMark        := .F.
    Private aVetor       := {}

    cAlias   := pAlias

    SetKey(VK_F6, {|| u_STPesqGD(oLbx, aVetor, aCampos,aCPOCHV) })

    aCampos := { ;
                {"Campo",	 2,"C",10,"@!"},;
                {"Descrição",3,"C",40,"@!"};
                }
    aCPOCHV := {{"Campo",2,    "C",10,"@!"}}

    DEFINE MSDIALOG oDlg TITLE cTitulo FROM aCoordenadas[7],000 To aCoordenadas[6]-100,aCoordenadas[5]-900 COLORS 0,16772829 PIXEL //STYLE nOR( WS_VISIBLE, WS_POPUP ) //style DS_MODALFRAME

    aLay := LayOutSel()
    oWin1    := aLay[1]
    oWin2    := aLay[2]
    oWinSP01 := aLay[3]

    @001,010 CHECKBOX oChk    VAR lChk    Prompt "Marca/Desmarca"    SIZE 60,007 PIXEL Of oWinSP01 On Click(aEval(aVetor,{|x| x[1] := lChk}),AtuSel(),oLbx:Refresh())
    @-01,250 BUTTON oProcura PROMPT "Procura F6"   SIZE 050, 010 Font oDlg:oFont ACTION { || u_STPesqGD(oLbx, aVetor, aCampos,aCPOCHV),oLbx:SETFOCUS()  } Of oWinSP01 PIXEL
    @009,010 LISTBOX oLbx VAR cVar FIELDS Header " ", "Campo", "Descrição" SIZE 290,195 Of oWinSP01 PIXEL ON dblClick(aVetor[oLbx:nAt,1] := (!aVetor[oLbx:nAt,1] ),AtuSel(),oLbx:Refresh())
    oLbx:SetArray(aVetor)
    oLbx:bLine := {|| { if(aVetor[oLbx:nAt,1],oOk,oNo),;
                            aVetor[oLbx:nAt,2],; 
                            aVetor[oLbx:nAt,3] } }
    oLbx:Refresh()
    SetKey(VK_F6, {|| u_STPesqGD(oLbx, aVetor, aCampos,aCPOCHV) })
    
    @ 005,0010 SAY "Registros:   "    SIZE 045, 007 OF oWin1  COLORS 0, 16777215 PIXEL
    @ 005,0055 SAY oTotReg  PROMPT nTotReg	SIZE 045, 007 OF oWin1  FONT oFont1 COLORS 16711680, 16777215 PIXEL

    @ 005,0080 SAY "Selecionado: "    SIZE 050, 007 OF oWin1  COLORS 0, 16777215 PIXEL
    @ 005,0130 SAY oTotSel  PROMPT nTotSel  SIZE 050, 007 OF oWin1  FONT oFont1 COLORS 16711680, 16777215 PIXEL

    @002,000+nColb BUTTON oConfirma PROMPT "Confirmar"   SIZE 050, 014 Font oDlg:oFont ACTION { U_STEXIMPC(), oDlg:End() } Of oWin2 PIXEL
    @002,060+nColb BUTTON oCancela 	PROMPT  "Sair"		 SIZE 050, 014 Font oDlg:oFont ACTION oDlg:End() OF oWin2 PIXEL

    oCancela:SetCSS( GetSetCSS("BUTTOM", "", "Danger") )
    oConfirma:SetCSS( GetSetCSS("BUTTOM", "", "Success") )
    oProcura:SetCSS( GetSetCSS("BUTTOM", "", "Warning") )

    oChk:cToolTip 		:= "Marca ou Desmarca todos os registros"
    oConfirma:cToolTip 	:= "Confirma inicialização de processo selecionado"
    oCancela:cToolTip 	:= "Retorna para tela anterior"
    getCarga()
    oLbx:SetFocus()
    ACTIVATE MSDIALOG oDlg CENTER

    SetKey(VK_F6, {|| nIL} )

Return cRET

/*/{Protheus.doc} LayOutSel
Monta LayOut de apresentação
@type function
@version  12.1.33
@author valdemir rabelo
@since 21/10/2022
@return variant, Array Definição de tela
/*/
Static Function LayOutSel()
    Local aRET := Array(3)
    Local oFWLMain 

    oFWLMain := FWLayer():New()
    oFWLMain:Init( oDlg, .T. )
    oFWLMain:AddLine("LineSup",084,.T.)
    oFWLMain:AddLine("LineInf",015,.T.)
    oFWLMain:AddCollumn( "ColSP01", 098, .T.,"LineSup" )
    oFWLMain:AddWindow( "ColSP01", "WinSP01", "Seleção Boletos", 100, .F., .F.,/*bAction*/,"LineSup",/*bGotFocus*/)
    aRET[3] := oFWLMain:GetWinPanel('ColSP01','WinSP01',"LineSup" )
    oFWLMain:AddCollumn( "Col01", 050, .T.,"LineInf" )
    oFWLMain:AddCollumn( "Col02", 048, .T.,"LineInf" )
    oFWLMain:AddWindow( "Col01", "Win01", "Totais"  ,100, .F., .F.,/*bAction*/,"LineInf",/*bGotFocus*/)
    oFWLMain:AddWindow( "Col02", "Win02", "Botões"  ,100, .F., .F.,/*bAction*/,"LineInf",/*bGotFocus*/)
    aRET[1] := oFWLMain:GetWinPanel('Col01','Win01',"LineInf" )
    aRET[2] := oFWLMain:GetWinPanel('Col02','Win02',"LineInf" )  

Return aRET 

/*/{@Protheus.doc} getCarga
@description
Rotina que irá popular a tabela temporaria.
@type function
@version 12.1.33  
@author Valdemir Jose
@since 21/10/2021
/*/
Static Function getCarga()
    Local cCPOSEL := gCPOSEL()
    Local lTrue   := .f. 

    if Empty(cCPOSEL)
       IF cAlias=="SC6"
          cCPOSEL := cCPOEX6
       else 
          cCPOSEL := cCPOEXK
       endif 
    endif 

    dbSelectArea("SX3")
    dbSetOrder(1)
    dbSeek(cAlias)
    While SX3->( !Eof() .and. X3_ARQUIVO==cAlias)
        lTrue   := (Alltrim(SX3->X3_CAMPO) $ cCPOSEL)
        if lTrue
           nTotSel++
        endif 
        aAdd(aVetor, {lTrue, SX3->X3_CAMPO, SX3->X3_TITULO} )
        nTotReg++
        SX3->( dbSkip() )
    EndDo
    oTotReg:Refresh()
    oTotSel:Refresh()
    oDlg:Refresh()

Return


/*/{Protheus.doc} AtuSel
Rotina para atualizar totalizadores
@type function
@version  12.1.33
@author valdemir rabelo
@since 21/10/2022
@return variant, Nil
/*/
Static Function AtuSel()
    Local nSelec := 0

    aEVal(aVetor,{|X| if(X[1],nSelec++,nil) })

    nTotSel := nSelec
    oTotSel:Refresh()
    oDlg:Refresh()

Return 


/*/{Protheus.doc} gCPOSEL
Rotina para efetuar leitura do arquivo de campos
@type function
@version  12.1.33
@author valdemir rabelo
@since 21/10/2022
@return variant, String - Contendo os campos da empresa
/*/
Static Function gCPOSEL()
    Local cRET    := ""
    Local nHandle := 0
    Local cArqSEL := cAlias+"_"+cEmpAnt+".cpo"

    if File(cArqSEL)
        nHandle := FT_FUSE(cArqSEL)
		If nHandle = -1
		   Return cRET
		Endif        
        FT_FGOTOP()
    	While !FT_FEOF()
           cRET := FT_FREADLN()
           FT_FSKIP()
        EndDo
        FT_FUSE()
    Endif 

Return cRET

/*/{Protheus.doc} UDateList
Atualiza Grid
@type function
@version  12.1.33
@author valdemir rabelo
@since 21/10/2022
@return variant, Nil
/*/
Static Function UDateList()
    oLbx:SetArray(aVetor)
    oLbx:bLine := {|| { Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
                            aVetor[oLbx:nAt,2],; 
                            aVetor[oLbx:nAt,3] } }
    oLbx:Refresh()
Return 

/*/{@Protheus.doc} STEXIMPC
description
@type function
@version 12.1.33  
@author Valdemir Jose
@since 16/07/2021
@return variant, return_description
/*/
User Function STEXIMPC()
    Local nSelec := 0
     aEVal(aVetor,{|X| if(X[1],nSelec++,nil) })
    if nSelec > 0
        Processa( {|| STEXIMP1() },"Processando","Separando registros, aguarde.")
    else
       MsgRun("Não foi selecionado nenhum registro", "Atenção!", {|| Sleep(3000)}) 
    Endif 
Return 


/*/{Protheus.doc} STEXIMP1
Rotina que irá salvar as seleção
@type function
@version  12.1.33
@author valdemir rabelo
@since 21/10/2022
@return variant, Nil
/*/
Static Function STEXIMP1()
    Local cCMPSel := ""
    Local xConta  := 1
	Local cArqEmp := cAlias+"_"+cEmpAnt+".cpo"
    Local nX      := 1

    For nX := 1 to Len(aVetor)
        if aVetor[nX][1]
            IF xConta > 1
               cCMPSel += "/"
            Endif 
            cCMPSel += ALLTRIM(aVetor[nX,2])
            xConta++
        Endif 
    Next

    if File(cArqEmp)
	   FErase(cArqEmp)
	endif 

	Memowrite(cArqEmp, cCMPSel)
    if File(cArqEmp)
	    FWMsgRun(,{|| Sleep(3000)},"Informativo","Os Campos selecionados foram salvos com sucesso.")
    Endif

    cRET := cCMPSel

Return 


































































































/*/{Protheus.doc} GetSetCSS
Rotina de style
@type function
@version  12.1.33
@author valdemir rabelo
@since 21/10/2022
@param pComp, variant, Tipo de Grupo
@param pcImg, variant, Imagem a ser apresentado
@param cTipo, character, Tipo do botão
@return variant, Nil
/*/
Static Function GetSetCSS(pComp, pcImg, cTipo)
	Local cRET    := ""
	Default pcImg := "rpo:yoko_sair.png"
	Default pTipo := "Botao CRLFanco"

	if pComp == "GROUP"
		cRET +="QGroupBox {";
			+CRLF+"  background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
			+CRLF+"                    stop: 0 #E0E0E0, stop: 1 #FFFFFF); /*cor de fundo*/";
			+CRLF+"  border: 2px solid gray; /*cor da borda*/";
			+CRLF+"  border-radius: 5px;  /*arredondamento da borda*/";
			+CRLF+"  margin-top: 2px; /*espaco ao topo para o titulo*/";
			+CRLF+"}";
			+CRLF+"/* Caracterissticas do titulo */";
			+CRLF+"QGroupBox::title {";
			+CRLF+"  color: red;";
			+CRLF+"  subcontrol-origin: margin; /*margem*/";
			+CRLF+"  padding: 0 3px; /*espacamento*/";
			+CRLF+"  subcontrol-position: top center; /*posiciona texto ao topo+centro*/";
			+CRLF+"  background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
			+CRLF+"                    stop: 0 #FFOECE, stop: 1 #FFFFFF); /*cor de fundo*/";
			+CRLF+"}"
	Elseif pComp == "BUTTOM"

		If cTipo == "Success"
			cRET := "QPushButton {"
			cRET += " color:#fff;background-color:#28a745;border-color:#28a745 "
			cRET += "}"
		EndIf

		If cTipo == "Primary"
			cRET := "QPushButton {"
			cRET += " color:#fff;background-color:#007bff;border-color:#007bff "
			cRET += "}"
		EndIf

		If cTipo == "Danger"
			cRET := "QPushButton {"
			cRET += " color:#fff;background-color:#dc3545;border-color:#dc3545 "
			cRET += "}"
		EndIf

		If cTipo == "Warning"
			cRET := "QPushButton {"
			cRET += " color:#fff;background-color:#FFD700;border-color:#FFD700 "
			cRET += "}"
		EndIf
		If cTipo == "Orange"
			cRET := "QPushButton {"
			cRET += " color:#fff;background-color:#DBA901;border-color:#DBA901 "
			cRET += "}"
		EndIf
		If cTipo == "Cinza"
			cRET := "QPushButton {"
			cRET += " color:#fff;background-color:#A4A4A4;border-color:#A4A4A4 "
			cRET += "}"
		EndIf

	Elseif pComp == "LISTBOX"
		cRET +=	 CRLF+"QAbstractItemView {";
				+CRLF+"  font-size: 12px; /*tamanho da fonte*/";
				+CRLF+"  color: #0d65d4; /*cor da fonte*/";
				+CRLF+"  border: 2px solid #0d65d4; /*cor da borda*/";
				+CRLF+"  background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
				+CRLF+"			stop: 0 #aed1fc, stop: 1 #deecfc); /*Cor de fundo*/";
				+CRLF+"";
				+CRLF+"  /* Caracteristicas quando selecionado*/";
				+CRLF+"  selection-color: #953734; /*cor da fonte*/";
				+CRLF+"  selection-background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
				+CRLF+"			stop: 0 #C4BD97, stop: 1 #DDD9C3); /*cor de fundo*/";
				+CRLF+"}"
	Endif

Return cRET
