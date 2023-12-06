#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} FWMarkBrowseMA
MarkBrowse extendido 
	
@author Alejandro Perret
@since 01/01/2020
@version 1.0		
/*/

CLASS FWMarkBrowseMA FROM FWMARKBROWSE

	DATA cTRBAlias
	DATA cNomTrb
	DATA aIndexNames
	DATA cQuery
	DATA cWhileTRB

	METHOD New() CONSTRUCTOR
	METHOD BuildTemp(cQry1, aUsrCpo, cWhileTRB, aSeek, lProgBar) 
	METHOD RunQuery(cQry1, aUsrCpo, cWhileTRB, aSeek, lProgBar) 
	METHOD DeActivate() 
	METHOD AllMark2()		// Marca todos, marcando también en la tabla pq el estándar marca todos solo en la grilla
	METHOD RefreshTemp()
	METHOD RefreshFil()

	
ENDCLASS

//--------------------------------------------------------------------------------------------

METHOD New() CLASS FWMarkBrowseMA
	
	_Super:New()
	::cTRBAlias 	:= ""
	::cNomTrb		:= ""
	::aIndexNames 	:= {}
	::cQuery		:= ""
	::cWhileTRB		:= ""

RETURN SELF

//--------------------------------------------------------------------------------------------

METHOD BuildTemp(cQry1, aUsrCpo, cWhileTRB, aSeek, lProgBar) CLASS FWMarkBrowseMA

Local lRet := .T.

Default lProgBar	:= .F.

::cQuery 	:= cQry1
::cWhileTRB	:= cWhileTRB

If lProgBar
	Processa({|| lRet := ::RunQuery(cQry1, aUsrCpo, cWhileTRB, aSeek, lProgBar)}, "Aguarde por favor...", "Obteniendo registros...", .F.)
Else
	lRet := ::RunQuery(cQry1, aUsrCpo, cWhileTRB, aSeek, lProgBar)
EndIf
	
RETURN(lRet)

//===================================================================================================================================
/*/{Protheus.doc} RunQuery
    Ejecuta la consulta, arma y carga el archivo de trabajo temporal. 

    @type  Static Function
    @author Alejandro Perret
    @since 03/02/2020
    @version 1.0
/*/
//===================================================================================================================================

METHOD RunQuery(cQry1, aUsrCpo, cWhileTRB, aSeek, lProgBar) CLASS FWMarkBrowseMA

Local cQryTrb 	:= GetNextAlias()
Local aCampos	:= {}
Local aStruct	:= {}
Local aFieldsMB	:= {}
Local lEstEsp	:= .F.
Local cTituCpo	:= ""
Local cCpo		:= ""
Local cPictCpo	:= ""
Local lHideCpo	:= .F.
Local nTamaCpo	:= 0
Local nTamUsr	:= 0
Local nDecUsr	:= 0
Local nDecCpo	:= 0
Local cTipoCpo	:= 0
Local nPosT		:= 0
Local nM		:= 0
Local nN		:= 0
Local cNroInd	:= "0"
Local cIndExt	:= OrdBagExt()
Local cNomIndex	:= ""
Local cCposInd	:= ""
Local nTot		:= 0
Local lRet 		:= .T.

Default cQry1		:= ""
Default aUsrCpo		:= {}
Default cWhileTRB 	:= ""
Default aSeek		:= {}
Default lProgBar	:= .F.

ProcRegua(0)

lEstEsp := !Empty(aUsrCpo)

If !Empty(cQry1)
	
	IncProc()
	IncProc()

	::cTRBAlias := GetNextAlias()

	DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry1), cQryTrb, .F., .T.)
	DbSelectArea(cQryTrb)
	DbGoTop()
	
	// If Eof()
	// 	lRet := .F.
	// 	(cQryTrb)->(DbCloseArea())
	// 	MsgInfo("No se encontraron registros para seleccionar según los parámetros ingresados.")
	// 	Return()
	// EndIf
	
	aStruct := DbStruct() //nombre,tipo,tam,dec
	
	DbSelectArea("SX3")
	DbSetOrder(2)	//X3_CAMPO

	For nM := 1 To Len(aStruct)
		
		If aStruct[nM][1] == "MARK"
			lHideCpo := .T.
		Else
			lHideCpo := .F.
		EndIf
		
		If DbSeek(aStruct[nM][1]) 
			cTituCpo := AllTrim(X3Titulo())
			cCpo	 := X3_CAMPO	
			cTipoCpo := X3_TIPO	
			nTamaCpo := X3_TAMANHO			// Tamaño para la tabla temporal
			nTamUsr	 := X3_TAMANHO			// Tamaño para el mark browse
			nDecCpo	 := X3_DECIMAL
			nDecUsr	 := X3_DECIMAL
			cPictCpo := X3_PICTURE
		Else 
			//DbStruct: Nombre, tipo , tamaño, decimal
			cTituCpo := aStruct[nM][1]
			cCpo	 := aStruct[nM][1]
			cTipoCpo := aStruct[nM][2]
			nTamaCpo := aStruct[nM][3]		// Tamaño para la tabla temporal
			nTamUsr	 := aStruct[nM][3]      // Tamaño para el mark browse
			nDecCpo	 := aStruct[nM][4]
			nDecUsr	 := aStruct[nM][4]
			cPictCpo := ""
		EndIf
			
		If lEstEsp 
			If (nPosT := AScan(aUsrCpo, {|x| x[1] == AllTrim(cCpo) })) > 0
				If !Empty(aUsrCpo[nPosT][2])	
					cTituCpo := aUsrCpo[nPosT][2]	
				EndIf
				
				If !Empty(aUsrCpo[nPosT][3])	
					nTamUsr := aUsrCpo[nPosT][3]	
				EndIf
				
				If !Empty(aUsrCpo[nPosT][4])	
					nDecUsr := aUsrCpo[nPosT][4]	
				EndIf
				
				If !Empty(aUsrCpo[nPosT][5])	
					cPictCpo := aUsrCpo[nPosT][5]	
				EndIf	
				
				If !Empty(aUsrCpo[nPosT][6])	
					lHideCpo := aUsrCpo[nPosT][6]
				Else
					lHideCpo := .F.
				EndIf
				
			EndIf
		EndIf
		
		Aadd(aCampos,{cCpo, cTipoCpo, nTamaCpo, nDecCpo})
		
		If !lHideCpo 	
			Aadd(aFieldsMB, {cTituCpo, cCpo, cTipoCpo, nTamUsr, nDecUsr, cPictCpo})
		EndIf
		
		If cTipoCpo == 'D'
			TCSetField(cQryTrb, cCpo,'D', 8, 0)
		EndIf

	Next
	
	::cNomTrb := CriaTrab(aCampos)
	dbSelectArea(0)
	dbUseArea( .T.,, ::cNomTrb, ::cTRBAlias,.F. )
	dbSelectArea(::cTRBAlias)
	Zap

	DbSelectArea(cQryTrb)
	DbGoTop()

	If lProgBar
		Count To nTot
		ProcRegua(nTot)  
		DbGoTop()
	EndIf

	While !EOF()
	
		If lProgBar
			IncProc()
		EndIf

		RecLock(::cTRBAlias,.T.)
			
			For nM := 1 To Len(aCampos)
				(::cTRBAlias)->(&(aCampos[nM][1])) := (cQryTrb)->(&(aCampos[nM][1]))
			Next
			
			If !Empty(cWhileTRB)
				cTRBA := ::cTRBAlias
				&(cWhileTRB+"(cTRBA, cQryTrb)")
			EndIf

		MsUnlock()
		
		DbSelectArea(cQryTrb)
		DbSkip()
		
	EndDo

	(cQryTrb)->(DbCloseArea())
	
	DbSelectArea(::cTRBAlias)
	
	::aIndexNames := {}
	
	
	For nM := Len(aSeek) To 1 Step -1
		cCposInd := ""
		cNroInd := Soma1(cNroInd)
		For nN := 1 To Len(aSeek[nM][2])
			If nN > 1
				cCposInd += "+"
			EndIf
			cCposInd += aSeek[nM][2][nN][5]
		Next
		cNomIndex := SubStr(::cNomTrb,1,7)+cNroInd
		IndRegua(::cTRBAlias, cNomIndex+cIndExt, cCposInd, , , "Creando índice...", .F.) 
		Aadd(::aIndexNames, cNomIndex)
	Next

	For nM := Len(::aIndexNames) To 1 Step -1
		DbSetIndex(::aIndexNames[nM])
	Next
	
	DbGoTop()
	
	If (::cTRBAlias)->(FieldPos("MARK")) > 0
		::SetFieldMark("MARK")
		::SetAllMark({|| ::AllMark2() })
	EndIf
	
	::SetTemporary(.T.)
	::SetAlias(::cTRBAlias)
	::SetFields(aFieldsMB)	
	If !Empty(aSeek)
		::SetSeek(.T., aSeek)
	EndIf

EndIf

RETURN(lRet)


//--------------------------------------------------------------------------------------------

METHOD DeActivate() CLASS FWMarkBrowseMA

Local nM 		:= 0
Local cIndExt	:= OrdBagExt()
	
	If !Empty(::cTRBAlias)
		If Select(::cTRBAlias) > 0
			DbSelectarea(::cTRBAlias)
			DbCloseArea()
		EndIf
	EndIf
	
	If !Empty(::cNomTrb)
		Ferase(::cNomTrb  + GetDBExtension())  
	EndIf
	
	For nM := 1 To Len(::aIndexNames)
		Ferase(::aIndexNames[nM] + cIndExt) 
	Next
	
	_Super:DeActivate()

RETURN


//--------------------------------------------------------------------------------------------

METHOD AllMark2() CLASS FWMarkBrowseMA
//Local nCurrRec := ::At()
Local nLastRec := 0

::GoBottom(.T.)
nLastRec := ::At()
::GoTop(.T.)

While .T.
	::MarkRec()
	
	If ::At() == nLastRec
		Exit
	EndIf
	
	::GoDown(1)
EndDo

::GoTop(.T.)
//::GoTo( nCurrRec, .T. )

Return()


//===================================================================================================================================
/*/{Protheus.doc} RefreshTemp
    Ejecuta una nueva consulta y recarga la tabla temporal para refrescar la grilla con el resultado. 
	Esta función reutiliza la tabla temporal ya existente para reutilizar la configuración de campos y los índices creados inicialmente.

    @type  Static Function
    @author Alejandro Perret
    @since 03/02/2020
    @version 1.0
/*/
//===================================================================================================================================

METHOD RefreshTemp() CLASS FWMarkBrowseMA

Local nM		:= 0
Local cQryTrb 	:= GetNextAlias()
Local aCampos	:= {}
Local aStruct	:= {}

If !Empty(::cQuery)
	
	// IncProc()	//TODO: tal vez se pueda implementar una barra de progreso (ver tipos)
	// IncProc()
	
	DbUseArea( .T., 'TOPCONN', TCGENQRY(,,::cQuery), cQryTrb, .F., .T.)
	// DbSelectArea(cQryTrb)
	// DbGoTop()

	DbSelectArea(::cTRBAlias)
	Zap
	aCampos := DbStruct()

	DbSelectArea(cQryTrb)
	DbGoTop()

	For nM := 1 To Len(aCampos)
		If aCampos[nM][2] == 'D'
			TCSetField(cQryTrb, aCampos[nM][1],'D', 8, 0)
		EndIf
	Next

	// If lProgBar
	// 	Count To nTot
	// 	ProcRegua(nTot)  
	// 	DbGoTop()
	// EndIf

	If !EOF()
		While !EOF()
		
			// If lProgBar
			// 	IncProc()
			// EndIf

			RecLock(::cTRBAlias,.T.)
				
				For nM := 1 To Len(aCampos)
					(::cTRBAlias)->(&(aCampos[nM][1])) := (cQryTrb)->(&(aCampos[nM][1]))
				Next
				
				If !Empty(::cWhileTRB)
					cTRBA := ::cTRBAlias
					&(::cWhileTRB+"(cTRBA, cQryTrb)")
				EndIf

			MsUnlock()
			
			DbSelectArea(cQryTrb)
			DbSkip()
			
		EndDo
	Else
		RecLock(::cTRBAlias, .T.)
		MsUnlock()
	EndIf

	(cQryTrb)->(DbCloseArea())
	DbSelectArea(::cTRBAlias)
	::Refresh(.T.)

EndIf

Return()

