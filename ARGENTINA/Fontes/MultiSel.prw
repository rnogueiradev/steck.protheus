#INCLUDE "PROTHEUS.CH"

#DEFINE LARMIN	400
#DEFINE LARMAX	850
#DEFINE ANCMIN 	374
#DEFINE ANCMAX	1300

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ?MultiSel ?Autor ?Alejandro Perret      ?Data ?26/02/14 ³±?±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.   ?Grilla para seleccion multiple.                            ³±?±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso        ?VARIOS.                                                    ³±?±±ÃÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

CLASS MultiSel

	DATA cTit
	DATA cQry 
	DATA cAlias 	 //TODO: no implementado aun
	DATA cMarcaInicial
	DATA cMarkOk
	DATA cMarkNo
	DATA nLargo 
	DATA nAncho 
	DATA cCampoRet
	DATA lMarcaUno
	DATA aDevs
	DATA aIndices
	DATA nScrollType
	DATA aTitulos
	
	METHOD New() CONSTRUCTOR
	METHOD Show() 

ENDCLASS


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Metodo     ?New      ?Autor ?Alejandro Perret      ?Fecha?//14 ?ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrip.   ?                     ?ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

METHOD New(cTitulo,cConsulta,lIniMarcado,cCRet,nLar,nAnch,cMOk,cMNo,lSoloUno, aDev, aInd, nScrTp, aTit) CLASS MultiSel

Default cTitulo 	:= "Consulta"
Default cConsulta 	:= ""
Default lIniMarcado	:= .F.
Default cMOk		:= "LBOK"
Default cMNo		:= "LBNO"
Default nLar		:= 400
Default nAnch		:= 374
Default cCRet		:= ""
Default lSoloUno	:= .F.
Default aDev		:= {}
Default aInd		:= {}
Default nScrTp		:= 1
Default aTit		:= {}

::cTit			:= cTitulo
::cQry 			:= cConsulta
::cMarkOk		:= cMOk
::cMarkNo		:= cMNo
::cMarcaInicial:= Iif(lIniMarcado,::cMarkOk,::cMarkNo)
::nLargo   		:= Iif(nLar < LARMIN, LARMIN, Iif(nLar > LARMAX, LARMAX, nLar))
::nAncho		:= Iif(nAnch < ANCMIN, ANCMIN, Iif(nAnch > ANCMAX, ANCMAX, nAnch))
::cCampoRet		:= cCRet
::lMarcaUno		:= lSoloUno
::aDevs			:= aDev
::aIndices		:= aInd
::nScrollType	:= nScrTp
::aTitulos		:= aTit

RETURN SELF    


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Metodo     ?Show     ?Autor ?Alejandro Perret      ?Fecha?//14 ?ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrip.   ?                     ?ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

METHOD Show() CLASS MultiSel
Local aRet := {}

	aRet := Mostrar(::cTit,::cQry,::cMarcaInicial,::cCampoRet,::nLargo,::nAncho,::cMarkOk,::cMarkNo,@::lMarcaUno, ::aDevs, ::aIndices, ::nScrollType, ::aTitulos)
	
RETURN AClone(aRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Programa   ?Mostrar  ?Autor ?Alejandro Perret      ?Fecha?//14 ?ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrip.   ?                     ?ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

Static Function Mostrar(cTit,cQry,cMKIni,cCampoR,nLarg,nAnch,cMOk,cMNo,lUnoSolo,aDev,aInd, nScrTp, aTitus)

Local aArea 	:= GetArea()
Local oFontB	:= TFont():New('Monoas',0,-14,,.T.)
Local lAcepta	:= .F.
Local nAnchoDlg	:= 0
Local nLargoDlg	:= 0
Local aRet		:= {} 
Local aTmp 	:= {}
Local nPos		:= 0
Local nPos2		:= 0
Local bBkpF4 	:= SetKey(VK_F4)
Local bBkpF5 	:= SetKey(VK_F5)
Local bBkpF6 	:= SetKey(VK_F6)
Local bF4		:= {|| BtnSel(1,oGetdad,cMOk,cMNo) }
Local bF5		:= {|| BtnSel(2,oGetdad,cMOk,cMNo) }
Local bF6		:= {|| BtnSel(3,oGetdad,cMOk,cMNo) }
Local oDlg, oBtnMarc, oBtnDesm, oBtnInv, oGetdad, oGetBus, oBtnBus, oCombo
Local nX, nV
Local lUsaBusq	:= .T.
Local cGetBus	:= Space(60)
Local cCombo	:= Space(60)
Local aCombo	:= {}
Local nInd		:= 1
Local aTmpInd	:= {}
Local cNomInd	:= ""

Private _xoBtn1,_xoBtn2, _oSayQtdTot, _oSayQtdSel
Private _nSayTot 	:= 0
Private _nSaySel 	:= 0
Private _cQtdPict	:= "@E 9,999,999"
Private _cVarMV 	:= Alltrim(ReadVar())
Private _cBkpMV		:= Iif(!Empty(_cVarMV), &(ReadVar()), "")

If !Empty(aInd)
	For nV := 1 To Len(aInd)
		If Empty(aInd[nV][1]) .And. Len(aInd[nV]) > 1
			aTmpInd := StrTokArr(aInd[nV][2],"+")
			
			For nX := 1 To Len(aTmpInd)
				cNomInd += AllTrim(RetTitle(aTmpInd[nX])) + " + " 
			Next
			
			cNomInd := SubStr(cNomInd,1,Len(cNomInd)-3)
			
		Else
			cNomInd :=	aInd[nV][1] 
		EndIf
		
		aAdd( aCombo, cNomInd )
		cNomInd := ""
	Next
Else
	lUsaBusq := .F.
EndIf
	
DEFINE MSDIALOG oDlg TITLE cTit FROM 0,0 TO nLarg,nAnch PIXEL

nAnchoDlg  := oDlg:nWidth/2
nLargoDlg  := oDlg:nHeight/2

If lUsaBusq
	@ 004,005 COMBOBOX oCombo 	VAR cCombo ITEMS aCombo ON CHANGE (OrdGrilla(oGetdad,oCombo:nAt,@aInd)) SIZE 181,10 PIXEL OF oDlg
	@ 019,005 MSGET 	 oGetBus 	VAR cGetBus Picture "@!" SIZE 150,010 PIXEL OF oDlg  // 187
	@ 019,158 BUTTON 	 oBtnBus	PROMPT "&Buscar" SIZE 27,12 ACTION(Buscar(oGetdad,cGetBus,oCombo:nAt,aInd)) PIXEL OF oDlg  
EndIf

oGetdad := Grilla(oDlg,cQry,cMKIni,cMOk,cMNo,nLargoDlg,nAnchoDlg,cCampoR,bF6,@lUnoSolo,lUsaBusq, aTitus)
oGetdad:oBrowse:nScrollType := nScrTp

_nSaySel := Iif(!Empty(_cBkpMV),_nSaySel, Iif(cMKIni == cMOk, _nSayTot, 0))

@ nLargoDlg-077,005 BUTTON oBtnMarc    PROMPT "&Marca Todos <F4>" 			SIZE 60,12 ACTION(Eval(bF4)) PIXEL OF oDlg
@ nLargoDlg-077,065 BUTTON oBtnDesm    PROMPT "&Desmarca Todos <F5>" 		SIZE 60,12 ACTION(Eval(bF5)) PIXEL OF oDlg
@ nLargoDlg-077,125 BUTTON oBtnInv     PROMPT "&Invertir Seleccion <F6>"	SIZE 60,12 ACTION(Eval(bF6)) PIXEL OF oDlg

@ nLargoDlg-060,005 TO nLargoDlg-040,095 LABEL "Cantidad de Elementos" 	OF oDlg PIXEL // FONT oFontB
@ nLargoDlg-060,095 TO nLargoDlg-040,185 LABEL "Elementos Seleccionados" 	OF oDlg PIXEL // FONT oFontB

@ nLargoDlg-050,035 SAY _oSayQtdTot PROMPT TransForm(_nSayTot,_cQtdPict) 	PIXEL OF oDlg FONT oFontB
@ nLargoDlg-050,130 SAY _oSayQtdSel PROMPT TransForm(_nSaySel,_cQtdPict)	PIXEL OF oDlg FONT oFontB //COLOR CLR_RED

@ nLargoDlg-032,005 BUTTON _xoBtn1 PROMPT "C&onfirmar" SIZE 90,14 ACTION(lAcepta := .T.,oDlg:End()) PIXEL OF oDlg
@ nLargoDlg-032,095 BUTTON _xoBtn2 PROMPT "&Cancelar"  SIZE 90,14 ACTION(lAcepta := .F.,oDlg:End()) PIXEL OF oDlg

oDlg:lEscClose		:= .T. // permite sair ao se pressionar a tecla ESC.

If lUsaBusq
	OrdGrilla(oGetdad,oCombo:nAt,@aInd)
EndIf

If lUnoSolo
	oBtnMarc:Disable()
	oBtnDesm:Disable()
    oBtnInv:Disable()
Else
	SetKey(VK_F4,bF4)
	SetKey(VK_F5,bF5)
	SetKey(VK_F6,bF6)
EndIf

ACTIVATE MSDIALOG oDlg CENTERED 

_cRetCons := ""

If lAcepta
	If (nPos := GdFieldPos(cCampoR,oGetdad:aHeader)) > 0
		For nX := 1 To Len(oGetdad:aCols)
			If oGetdad:aCols[nX][1] == cMOk
				Aadd(aTmp,oGetdad:aCols[nX][nPos])
		
				For nV := 1 To Len(aDev)
					If (nPos2 := GdFieldPos(aDev[nV],oGetdad:aHeader)) > 0
						Aadd(aTmp,oGetdad:aCols[nX][nPos2])
					EndIf
				Next
		
				Aadd(aRet,aTmp)
				aTmp := {}
			EndIf
		Next
	EndIf
	
	If !Empty(aRet)
		If ValType(aRet[1][1]) == 'C'
			AEval(aRet,{|x| _cRetCons += x[1] + ";"  })
			_cRetCons := SubStr(_cRetCons,1,Len(_cRetCons)-1)
		Else
			_cRetCons := aRet[1][1]
		EndIf
	EndIf
Else	
	_cRetCons := _cBkpMV
EndIf

&_cVarMV := Iif(lUnoSolo,_cRetCons,_cRetCons + Space(300))

SetKey(VK_F4,bBkpF4)	  	
SetKey(VK_F5,bBkpF5)    	
SetKey(VK_F6,bBkpF6)     	

oFontB:End()
RestArea(aArea)
Return(AClone(aRet))


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Programa   ?ArchivoT ?Autor ?Alejandro Perret      ?Fecha?//14 ?ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrip.   ?                     ?ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

Static Function Grilla(oDlg,cQry,cMKIni,cMOk,cMNo,nLar,nAnch,cCampoRet,bF6,lUnoSolo,lBusqueda,aTitus)
Local aArea		:= GetArea()
Local cQryTrb 		:= GetNextAlias()
Local aStruct		:= {}
Local aAux 		:= {}
Local bUnoSolo 	:= {|| AEval(oGetd:aCols,{|x| x[1] := cMNo}), AtuQSel(1,.T.), oGetd:oBrowse:Refresh(), cMOk }
Local bVarios  	:= {|| AtuQSel(1), cMOk }
Local bMarca		:= {|| Iif(lUnoSolo, Eval(bUnoSolo), Eval(bVarios))}
Local bDesmarca	:= {|| AtuQSel(-1),cMNo}
Local cMarcaIni	:= cMKIni
Local bDblClick	:= {|| oGetd:aCols[oGetd:oBrowse:nat][1] := Iif(oGetd:aCols[oGetd:oBrowse:nat][1] == cMOk, Eval(bDesmarca), Eval(bMarca))}
Local bClickH  	:= {|| }
Local bNoAction	:= {|| }
Local lParEmpty 	:= .T.
//Local bClickH  	:= {|x,nCol| Iif(nCol == 1, Iif(lPrimera, lPrimera := .F., (AEval(oGetd:aCols,bInvert),lPrimera := .T.,oGetd:oBrowse:Refresh())),Nil)}
Local nM, oGetd

Local nSup 	:= Iif(lBusqueda,036,005)
Local nEsq		:= 005
Local nInf		:= nLar - 81
Local nDir		:= nAnch - 6
Local nOpc		:= 2
Local cLinOk	:= "AllwaysTrue"
Local cTudoOk	:= "AllwaysTrue"
Local cIniCpos	:= ""
Local aAlterGDa	:= {}
Local nFreeze	:= 0
Local nMax		:= 999
Local cFieldOk	:= "AllwaysTrue"
Local cSuperDel:= "AllwaysFalse"
Local cDelOk	:= "AllwaysFalse"
Local oDLG		:= oDlg
Local aH1		:= {}
Local aC1		:= {}
Local lEstEsp	:= !Empty(aTitus)
Local cTituCpo	:= ""
Local cPictCpo	:= ""
Local nTamaCpo	:= 0
Local nPosT		:= 0

If !Empty(_cBkpMV)
	If ValType(_cBkpMV) == 'C'
		aMark2 := StrTokArr(_cBkpMV,";")
		cMarcaIni := cMNo
		lParEmpty := .F.
	Else
		lParEmpty := .T.
	EndIf
EndIf

If !Empty(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), cQryTrb, .F., .T.)
	DbSelectArea(cQryTrb)
	aStruct := DbStruct() //nombre,tipo,tam,dec

Else
	//usar ::cAlias
	//filtro??	
EndIf

Aadd(aH1,{ " ", "CHECK", "@BMP", 04, 0 , "", .T., "C", "", "V", "","" }) // Marca

DbSelectArea("SX3")
DbSetOrder(2)	//X3_CAMPO

For nM := 1 To Len(aStruct)
	
	If DbSeek(aStruct[nM][1]) 
		cTituCpo := AllTrim(X3Titulo())
		cCpo	 := X3_CAMPO	
		cPictCpo := X3_PICTURE
		nTamaCpo := X3_TAMANHO+1	
		nDecCpo	 := X3_DECIMAL
		cTipoCpo := X3_TIPO	
	Else 
		//DbStruct: Nombre, tipo , tamaño, decimal
		cTituCpo := aStruct[nM][1]
		cCpo	 := X3_CAMPO
		cPictCpo := ""
		nTamaCpo := aStruct[nM][3]
		nDecCpo	 := aStruct[nM][4]
		cTipoCpo := aStruct[nM][2]
	EndIf
		
	If lEstEsp
		If (nPosT := AScan(aTitus, {|x| x[1] == AllTrim(cCpo) })) > 0
			If !Empty(aTitus[nPosT][2])	
				cTituCpo := aTitus[nPosT][2]	
			EndIf
			
			If !Empty(aTitus[nPosT][3])	
				cPictCpo := aTitus[nPosT][3]	
			EndIf	
			
			If !Empty(aTitus[nPosT][4])	
				nTamaCpo := aTitus[nPosT][4]	
			EndIf
		EndIf
	EndIf
	Aadd(aH1,{ cTituCpo, cCpo, cPictCpo, nTamaCpo, nDecCpo,"" ,.T. ,cTipoCpo ,"" ,"" ,"" ,"''"}) 
	
	If cTipoCpo == 'D'
		TCSetField(cQryTrb, cCpo,'D',8,0)
	EndIf

Next

DbSelectArea(cQryTrb)
DbGoTop()
While !Eof()
	_nSayTot++
	
	If lParEmpty
		Aadd(aAux,cMarcaIni)
	Else
		If (AScan(aMark2, {|x| &(cCampoRet) == AllTrim(x) }) > 0)
			Aadd(aAux,cMOk)
			_nSaySel ++
		Else
			Aadd(aAux,cMNo)
		EndIf
	EndIf

	For nM := 2 To Len(aH1)
		//TODO: 19/01/20 - 07:07 [] -> Ejecutar algún bloque de código (enviado como configuracíon) para ejecutar acciones durante la carga de cada ítem
		Aadd(aAux,&(aH1[nM][2]))
	Next 
    Aadd(aAux,.F.)
	Aadd(aC1,aAux)
    aAux := {}
    DbSkip()
	
EndDo

(cQryTrb)->(DbCloseArea())

oGetd := MsNewGetDados():New(nSup, nEsq ,nInf, nDir, nOpc, cLinOk, cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax, cFieldOk, cSuperDel, cDelOk, oDLG, aH1, aC1)
If Empty(aC1)
	oGetd:oBrowse:bLDblClick := bNoAction
	lUnoSolo := .T. // Solo para desactivar botones de seleciona todos, etc... cuando no hay nada para seleccionar
Else
	oGetd:oBrowse:bLDblClick := bDblClick
EndIf
oGetd:oBrowse:bHeaderClick := bClickH

RestArea(aArea)
Return(oGetd)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Programa   ?BtnSel   ?Autor ?Alejandro Perret      ?Fecha?27/02/14 ?
ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrip.   ?Accion de botones.                                         ?
ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

Static Function BtnSel(nBtn,oGetdados,cOk,cNo)

Local nCount := 0

Do Case
	Case nBtn == 1	//Marca todos
		AEval(oGetdados:aCols, {|x| x[1] := cOk })
		nCount := _nSayTot
	
	Case nBtn == 2	//Desmarca todos
		AEval(oGetdados:aCols, {|x| x[1] := cNo })
		nCount := 0
		
	Case nBtn == 3	//Invierte seleccion
		AEval(oGetdados:aCols, {|x| x[1] := Iif(x[1] == cOk ,cNo, Eval({|| nCount++,cOk}) ) })
EndCase

AtuQSel(nCount,.T.)

Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Programa   ?AtuQSel  ?Autor ?Alejandro Perret      ?Fecha?27/02/14 ?
ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrip.   ?                                                           ?
ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

Static Function AtuQSel(nQtd,lAsigna)

Default lAsigna := .F.

If lAsigna
	_nSaySel := nQtd
Else
	_nSaySel += nQtd
EndIf

_oSayQtdSel:SetText(TransForm(_nSaySel,_cQtdPict))

Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Programa   ?OrdGrilla?Autor ?Alejandro Perret      ?Fecha?27/02/14 ?ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrip.   ?                                                           ?ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

Static Function OrdGrilla(oGrilla,nSel,aInfo)

Local aCampos 	:= ""
Local aPos		:= {}
Local nPos		:= 0
Local cBloque	:= ""
Local bBloque	:= {||  }
Local nA

If !Empty(aInfo) .And. !Empty(nSel)

	aCampos := StrTokArr(aInfo[nSel][2],"+")
	For nA := 1 To Len(aCampos)
		If (nPos := GdFieldPos(AllTrim(aCampos[nA]),oGrilla:aHeader)) > 0
			aAdd(aPos,nPos)
			cBloque += "x[" + CValToChar(nPos) + "]+"
		Else
			MsgAlert("El campo: '" + AllTrim(aCampos[nA]) + "' de la busqueda, no se encontr?en la grilla.","Atención!")
		EndIf
	Next
	
	If !Empty(cBloque)
		cBloque := SubStr(cBloque,1,Len(cBloque)-1) 
		Aadd(aInfo[nSel],cBloque)
		cBloque := "{|x,y| " + cBloque + " < " + StrTran(cBloque,"x","y") + "}"
		bBloque := &(cBloque)
		ASort(oGrilla:aCols,,,bBloque) 
	EndIf	
	oGrilla:Refresh()
EndIf

Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Programa   ?Buscar   ?Autor ?Alejandro Perret      ?Fecha?27/02/14 ?ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrip.   ?                                                           ?ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

Static Function Buscar(oGrilla,cClave,nIndice,aIndices)

Local nLinea := 0
Local bBusqueda := {||  }

Default cClave := ""

cClave := AllTrim(cClave)

If !Empty(cClave) .And. Len(aIndices[nIndice]) > 2 

	bBusqueda := &("{|x| SubStr(" + aIndices[nIndice][3] + ",1," + CValToChar(Len(cClave)) + ") == cClave}")

	nLinea := AScan(oGrilla:aCols,bBusqueda)
	If nLinea > 0   
		oGrilla:oBrowse:nAt := nLinea
		oGrilla:oBrowse:Refresh()
		oGrilla:oBrowse:SetFocus()
		oGrilla:oBrowse:Refresh()
	Else
		MsgInfo("Clave no encontrada.")
	EndIf

EndIf

Return()