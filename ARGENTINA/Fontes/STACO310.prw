#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "argremelet.ch"

//===================================================================================================================================
/*/{Protheus.doc} Nombre STACO310
   Transmisión de remitos masivos
   
   @type    User Function
   @author  Nicolás Vallejos
   @since   21/12/21
   @version 1.0
/*/
//===================================================================================================================================

User Function STACO310()
Local aArea			:= GetArea()
Local aCoordAdms 	:= MsAdvSize(.F.)  // Coordenadas de pantalla | Va antes de obtener pq unifica entre la primera y las siguientes veces.
Local nAnchoWnd 	:= aCoordAdms[3]
Local nAltoWnd 		:= aCoordAdms[4]
Local cQry1 		:= ""
Local cPlaca		:= Space(TamSX3("F2_VEHICL")[1])
Local dFchEmis		:= dDataBase
Local bkpRotina		:= aRotina

Private lProgBar	:= .T.
PRIVATE aOrder 		:= {}
Private cComboBco	:= ""
Private cWhileTRB 	:= ""			// Función ejecutada durante el while de la cración del archivo temporal para la grilla
Private aItemsBco	:= {}
Private cComboEst	:= ""
Private _cTitulo	:= "Remito electrónico - Transmisión Masiva"
Private oMark		:= FWMarkBrowseMA():New()  
Private aCpoRem		:= {}
Private _aRecnosRem	:= {}
Private _cRecnosRem	:= ""
Private _aDocsElec	:= {}
Private oPnlGrid, oModal, oSayPl, oGetPlaca, oSayEmis, oGetFchE, oSayRem, oGetRem
Private _cSerieRem 	:= " "
Private	_cSerie		:= ""
Private _nCont		:= 0

SaveInter()

DbSelectArea("SF2")
DbSetOrder(1)

aRotina	:= {}
cQry1 := QryRemitos()

Aadd(aCpoRem, {"F2_DOC"		, "Num. Doc"		, 10,  ,	""		, 		})
Aadd(aCpoRem, {"F2_SERIE"	, "Serie"			, 03,  ,	""		, 		})
Aadd(aCpoRem, {"F2_CLIENTE"	, "Cliente"			, 06,  ,	""		, 		})
Aadd(aCpoRem, {"F2_LOJA"	, "Tienda"			, 02,  ,	""		, 		})
Aadd(aCpoRem, {"A1_NOME"	, "Raz. Social"		, 25,  ,	""		, 		})
Aadd(aCpoRem, {"F2_EMISSAO"	, "Fch Emision"		, 10,  ,	""		, 		})
Aadd(aCpoRem, {"F2_VEHICL"	, "Placa"			, 08,  ,	""		, 		})
Aadd(aCpoRem, {"REGNUM"		, "Recno"			, 08,  ,	""		, .T. 	})
Aadd(aCpoRem, {"F2_FLREMEL"	, "Flag Rem."		, 03,  ,	""		, .T. 	})

// Creación de índices y criterios de búsqueda
Aadd(aOrder, {"Num. Doc + Serie",	{{"SF2"	, 'C', 12, 0, "F2_DOC"	, "@!"} ,;
									 {""	, 'C', 03, 0, "F2_SERIE", "@!"}}, 1, .T.})

oMark:BuildTemp(cQry1, aCpoRem, cWhileTRB, aOrder, lProgBar) 
oMark:SetMenuDef('')
oMark:DisableReport()
oMark:SetValid({|| VldMrk() })
oMark:SetAfterMark({|| AfterMrk() })
oMark:SetAllMark({|| })
oMark:AddLegend("F2_FLREMEL == ' '", "DISABLE",   "Remito No Transmitido")
oMark:AddLegend("F2_FLREMEL == 'S'", "BR_AZUL",   "Remito Transmitido")
// oMark:AddLegend("F2_FLREMEL == 'E'", "ENABLE",    "Remito Autorizado")	// A. Perret (15/07/22): En esta grilla no se muestran los que ya fueron autorizados
oMark:AddLegend("F2_FLREMEL == 'M'", "BR_PRETO",  "Remito No Autorizado")
//oMark:SetDescription(_cTitulo)  

oModal  := FWDialogModal():New()       
oModal:SetEscClose(.T.)
oModal:setTitle(_cTitulo)

oModal:setSize(nAltoWnd * 0.86, nAnchoWnd * 0.87)
oModal:createDialog()
oModal:AddButtons({{"", "Cerrar", 	{|| oModal:OOWNER:END()} 	, "", 0, .T., .F.}})
oModal:AddButtons({{"", "Confirmar",{|| Iif(VldForm(cPlaca, dFchEmis, @_aRecnosRem, @_aDocsElec), Transmitir(oModal),) } , "", 0, .T., .F.}})

	oContainer := TPanel():New( ,,, oModal:getPanelMain() )
	oContainer:Align := CONTROL_ALIGN_ALLCLIENT

	oPnlTop 	:= TPanel():New(00,00,"",oContainer,,,,,RGB(050,050,550), 200, 022)	// Panel de cabecera
	oPnlTop:Align := CONTROL_ALIGN_TOP

		@012, 010 SAY oSayPl   PROMPT "Codigo de Placa: " SIZE 090, 010 OF oPnlTop PIXEL 
		@010, 055 MSGET oGetPlaca VAR cPlaca SIZE 50,010 When .T. PIXEL OF oPnlTop Picture "@!" F3 "DA3ARG" Hasbutton //ToDo: validar que exista el vehículo en el maestro
		
		@012, 130 SAY oSayEmis PROMPT "Fecha de Emisión: " SIZE 090, 010 OF oPnlTop PIXEL 
		@010, 180 MSGET oGetFchE VAR dFchEmis SIZE 60,010 When .T. PIXEL OF oPnlTop Hasbutton VALID VldFecha(dFchEmis)

		@012, 250 SAY oSayRem PROMPT "Remitos seleccionados: " SIZE 090, 010 OF oPnlTop PIXEL 
		@010, 310 MSGET oGetRem VAR _nCont SIZE 20,010 When .F. PIXEL OF oPnlTop 


	oPnlLeft	:= TPanel():New(00,00,"",oContainer,,,,,RGB(255,255,255), 003, 003)
	oPnlLeft:Align := CONTROL_ALIGN_LEFT

	oPnlGrid	:= TPanel():New(100,00,, oContainer)
	oPnlGrid:Align := CONTROL_ALIGN_ALLCLIENT

	oMark:Activate(oPnlGrid)  

oModal:Activate()

oMark:DeActivate()
aRotina:= bkpRotina

RestInter()
RestArea(aArea)
Return()


//===================================================================================================================================
/*/{Protheus.doc} VldFecha
   Validación de fecha informada


   @type    Static Function
   @author  Nicolás Vallejos
   @since   15/07/22
   @version 1.0
/*/
//===================================================================================================================================

Static Function VldFecha(dFchEmis)

Local lRet	:= .T.

If dFchEmis < dDataBase
	MsgAlert("La fecha informada debe ser posterior o igual a la fecha actual","Atención!")
	lRet	:= .F.
EndIf

Return(lRet)


//===================================================================================================================================
/*/{Protheus.doc} VldForm
   Validación antes de confirmar la transmisión masiva
   
   @type    Static Function
   @author  Alejandro Perret
   @since   23/06/22
   @version 1.0
/*/
//===================================================================================================================================
Static Function VldForm(cPlaca, dFchEmis, aRecnos, aDocs)
Local lRet      := .T.
Local aArea 	:= GetArea()
Local cMarca	:= oMark:Mark() 
Local cQryTrb	:= oMark:cTRBAlias

Default cPlaca   := ""
Default dFchEmis := ""
Default aRecnos  := {}
Default aDocs	 := {}		 

If Empty(cPlaca) .Or. Empty(dFchEmis)
	lRet := .F.
	MsgAlert("Por favor informe el 'Codigo de Placa' y la 'Fecha de Emisión' a actualizar en los remitos antes de realizar la transmisión.", "Atención!")
EndIf

If lRet	
	If MsgYesNo("Desea transmitir los Remitos seleccionados?", "Confirme..")

		aRecnos := {}
		aDocs	:= {}
		Begin Transaction
		DbSelectArea(cQryTrb)
		DbGoTop()
		While !(cQryTrb)->(Eof())
			If cMarca == MARK

				SF2->(DbGoTo((cQryTrb)->REGNUM))		
			 	If RecLock("SF2", .F.)
			 		F2_VEHICL 	:= cPlaca 
			 		F2_EMISSAO 	:= dFchEmis
			 		MsUnLock()
				 	Aadd(aRecnos, (cQryTrb)->REGNUM)
				 	Aadd(aDocs,   (cQryTrb)->F2_SERIE + (cQryTrb)->F2_DOC)
			 	Else
			 		lRet := .F.
					DisarmTransaction()
			 		MsgStop("No se pudo actualizar el registro debido a que está bloqueado por otro usuario. Intente nuevamente.", "Atención!")
			 		Exit
			 	EndIf

			EndIf
			(cQryTrb)->(DbSkip())
		EndDo
		End Transaction
	
		If lRet .And. Empty(aRecnos)
			lRet:= .F.
			MsgInfo("Debe seleccionar al menos un remito para transmitir.", "Atención!")
		EndIf

	Else
		lRet := .F.
	EndIf
EndIf

RestArea(aArea)
Return(lRet)


//===================================================================================================================================
/*/{Protheus.doc} QryRemitos
   Consulta de remitos pendientes de autorizar.
   
   @type    Static Function
   @author  Nicolás Vallejos
   @since   22/12/21
   @version 1.0
/*/
//===================================================================================================================================

Static Function QryRemitos()
Local cQry1 := "" 

cQry1 += "SELECT '  ' MARK, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, A1_NOME, F2_EMISSAO, F2_VEHICL, A.R_E_C_N_O_ AS REGNUM, F2_FLREMEL "
cQry1 += "FROM " + RetSqlName("SF2") + " A "
cQry1 += " INNER JOIN " + RetSqlName("SA1") + " B ON A1_FILIAL = '"  + xFilial("SA1") + "' AND F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND B.D_E_L_E_T_ = ' ' "
cQry1 += "WHERE F2_FILIAL = '" + xFilial("SF2") + "' "
cQry1 += "AND F2_TIPODOC >= '50' "
cQry1 += "AND F2_FLREMEL <> 'E' "
cQry1 += "AND F2_FORMUL = 'S' "
If !Empty(_cSerieRem)
	cQry1 += "AND F2_SERIE = '" + _cSerieRem + "' "
EndIf
cQry1 += "AND A.D_E_L_E_T_ = ' ' "
cQry1 += "ORDER BY F2_DOC DESC "

Return(cQry1)


//===================================================================================================================================
/*/{Protheus.doc} VldMrk
   Verifica si el campo F2_AUTHCOT no está vacío.
   
   @type    Static Function
   @author  Nicolás Vallejos
   @since   28/12/21
   @version 1.0
/*/
//===================================================================================================================================
Static Function VldMrk()
Local lRet		:= .T.
Local cMark     := oMark:Mark()
Local cQryTrb	:= oMark:cTRBAlias

If !oMark:IsMark(cMark) .And. !Empty(_cSerie)
	If _cSerie <> (cQryTrb)->F2_SERIE
		lRet := .F.
		MsgInfo("Solo se permiten seleccionar Remitos de la misma serie.")
	EndIf
EndIf

Return(lRet)


//===================================================================================================================================
/*/{Protheus.doc} AfterMrk
   Actualizaciones luego de marcar un registro en la grilla.
   
   @type    Static Function
   @author  Nicolás Vallejos
   @since   28/12/21
   @version 1.0
/*/
//===================================================================================================================================
Static Function AfterMrk()
Local cMark     := oMark:Mark()
Local cQryTrb	:= oMark:cTRBAlias

If oMark:IsMark(cMark)
	If _nCont == 0
		_cSerie	:= (cQryTrb)->F2_SERIE
	EndIf
	_nCont++
Else
	_nCont--
	If _nCont == 0
		_cSerie	:= " "
	EndIf
EndIf

Return()


//===================================================================================================================================
/*/{Protheus.doc} Transmitir
   Inicia el proceso de transmisión masiva de remitos.
   
   @type    Static Function
   @author  Nicolás Vallejos
   @since   27/12/21
   @version 1.0
/*/
//===================================================================================================================================

Static Function Transmitir(oModal)
Local lRetorno	:= .T.
Local aArea 	:= GetArea()
Local aParam    := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC)),Space(3),Space(3)}
Local cParNfeRem:= SM0->M0_CODIGO+SM0->M0_CODFIL+"Trans_Remito_Elec"
Local cSerie	:= _cSerie
Local cNotaIni	:= ""
Local cNotaFim	:= ""
Local cPlanta	:= PadR(AllTrim(GetMV("ST_REMELPLA", .F., "02")), 3)
Local cPorta	:= PadR(AllTrim(GetMV("ST_REMELPOR", .F., "01")), 3)
Local cLoad		:=	__cUserID+"_"+cParNfeRem

If !Empty(_aDocsElec)
	ASort(_aDocsElec)
	cNotaIni := SubStr(_aDocsElec[1], 4)
	cNotaFim := SubStr(ATail(_aDocsElec), 4)
EndIf

MV_PAR01 := cSerie
MV_PAR02 := cNotaIni
MV_PAR03 := cNotaFim
MV_PAR04 := cPlanta
MV_PAR05 := cPorta 
ParamSave(cLoad, aParam, '1')

DbSelectArea("SF2")
ARGNRemRe2(cSerie, cNotaIni, cNotaFim, cPlanta, cPorta, @lRetorno)	// Transmision de remitos electonicos

oModal:OOWNER:END()
RestArea(aArea)

If lRetorno							// Llamada al monitor si se ejecutó la transmisión de manera correcta
	MV_PAR01 := cSerie
	MV_PAR02 := cNotaIni
	MV_PAR03 := cNotaFim
	aParam   := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC))}
	cParNfeRem := SM0->M0_CODIGO+SM0->M0_CODFIL+"Monit_Remito_Elec"
	cLoad	 :=	__cUserID+"_"+cParNfeRem
	ParamSave(cLoad, aParam, '1')
	DbSelectArea("SF2")

	VisMonitor(cSerie, cNotaIni, cNotaFim)  // Reemplaza al ARGNRem6Mnt(cSerie, cNotaIni, cNotaFim)
EndIf
Return()



//===================================================================================================================================
/*/{Protheus.doc} STACO311
   Filtro en consulta de transmisión de remitos para que devuelva únicamente los registros seleccionados en el MarkBrowse.
   
   @type    User Function
   @author  Alejandro Perret
   @since   27/06/22
   @version 1.0
/*/
//===================================================================================================================================

User Function STACO311(cQuery)
Local nR        := 0
Local cRecnos   := ""   

Default cQuery := ""

For nR := 1 To Len(_aRecnosRem)
    cRecnos += CValToChar(_aRecnosRem[nR]) + ','
Next
cRecnos := SubStr(cRecnos, 1, Len(cRecnos)-1)
cQuery += " AND R_E_C_N_O_ IN (" + cRecnos + ") "

Return(cQuery)



//===================================================================================================================================
/*/{Protheus.doc} VisMonitor
   Copia del monitor. Función 'ARGNRem6Mnt' del fuente ARGREMELET.PRX. Se copia para poder filtrar los remitos que muestra en el monitor.
   
   @type    Static Function
   @author  Nicolás Vallejos
   @since   18/07/22
   @version 1.0
/*/
//===================================================================================================================================

Static Function VisMonitor(cSerie,cNotaIni,cNotaFim)

Local aPerg    := {}
Local aParam   := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC))}
Local aSize    := {}
Local aObjects := {}
Local aListBox := {}
Local aInfo    := {}
Local aPosObj  := {}
//Local oWS
Local oDlg                           
Local oListBox
Local oBtn1
Local oBtn2
Local oBtn3
Local oBtn4
Local oBtn5
//Local cParNfeRem := SM0->M0_CODIGO+SM0->M0_CODFIL+"Monit_Remito_Elec"
Local lOK        := .T.

Default cSerie   := ''
Default cNotaIni := ''
Default cNotaFim := ''

aadd(aPerg,{1,"Serie del remito",	aParam[01],"",".T.","01",".T.",30,.F.}) //"Série do Remito"
aadd(aPerg,{1,"Remito inicial",		aParam[02],"",".T.","",".T.",50,.T.})   //"Remito inicial"
aadd(aPerg,{1,"Remito final",		aParam[03],"",".T.","",".T.",50,.T.})   //"Remito final"

aParam[01] := cSerie   //ParamLoad(cParNfeRem,aPerg,1,aParam[01])
aParam[02] := cNotaIni //ParamLoad(cParNfeRem,aPerg,2,aParam[02])
aParam[03] := cNotaFim //ParamLoad(cParNfeRem,aPerg,3,aParam[03])

If IsReady() 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Obtem o codigo da entidade                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If cIdEnt == Nil .Or. Empty(cIdEnt)
		cIdEnt := GetIdEnt()		
	EndIf 
	
	If !Empty(cIdEnt)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Instancia a classe                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cIdEnt)
			
			//lOK        := ParamBox(aPerg,"ARG - REMe",@aParam,,,,,,,cParNfeRem,.T.,.T.)
						
			If (lOK)
				aListBox := WsNFeMnt(cIdEnt,1,aParam)
		
				FiltraRem(@aListBox)	// A. Perret (19/07/22): Función para filtrar los resultados del monitor para visualizar únicamente los remitos transmitidos
			
				If !Empty(aListBox)
					aSize := MsAdvSize()
					aObjects := {}
					AAdd( aObjects, { 100, 100, .t., .t. } )
					AAdd( aObjects, { 100, 015, .t., .f. } )
				
					aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
					aPosObj := MsObjSize( aInfo, aObjects )
											
					DEFINE MSDIALOG oDlg TITLE "ARG - REMe" From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL
					
					@ aPosObj[1,1],aPosObj[1,2] LISTBOX oListBox Fields HEADER "", "Remito","Entorno","Clave","Autorizacion","Comprobante","Recomendacion","Nombre Arch"; //"Ambiente"###"Chave"###"Autorização"###"Comprovante"###"Recomendação"###"Nome Arq."
						SIZE aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1] PIXEL
					oListBox:SetArray( aListBox )
					oListBox:bLine := { || { aListBox[ oListBox:nAT,1 ],aListBox[ oListBox:nAT,2 ],aListBox[ oListBox:nAT,3 ],aListBox[ oListBox:nAT,4 ],aListBox[ oListBox:nAT,5 ],aListBox[ oListBox:nAT,11 ],aListBox[ oListBox:nAT,6 ],aListBox[ oListBox:nAT,7 ]} }
					
					@ aPosObj[2,1],aPosObj[2,4]-040 BUTTON oBtn1 PROMPT "Ok"   	 		ACTION oDlg:End() OF oDlg PIXEL SIZE 035,011 //"OK"
					@ aPosObj[2,1],aPosObj[2,4]-080 BUTTON oBtn2 PROMPT "Refresh" 		ACTION (aListBox := WsNFeMnt(cIdEnt,1,aParam), FiltraRem(@aListBox),oListBox:nAt := 1,IIF(Empty(aListBox),oDlg:End(),oListBox:Refresh())) OF oDlg PIXEL SIZE 035,011 //"Refresh"
					@ aPosObj[2,1],aPosObj[2,4]-120 BUTTON oBtn3 PROMPT "Ver Xml" 		ACTION (RemViewXml(aListBox[ oListBox:nAT,2 ], aListBox[ oListBox:nAT,8 ],aListBox[ oListBox:nAT,9 ])) OF oDlg PIXEL SIZE 035,011 //"Ver Xml"
					@ aPosObj[2,1],aPosObj[2,4]-160 BUTTON oBtn4 PROMPT "Ver Arch.TXT"	ACTION (RemViewTxt(cIdEnt,aListBox[ oListBox:nAT,7 ])) OF oDlg PIXEL SIZE 035,011 //"Ver Arq.TXT"
					@ aPosObj[2,1],aPosObj[2,4]-200 BUTTON oBtn5 PROMPT "Mensaje"		ACTION (VisMsgErr(aListBox[ oListBox:nAT,10 ])) OF oDlg PIXEL SIZE 035,011 //"Mensagem"
				
					ACTIVATE MSDIALOG oDlg			
	   	 
				EndIf
				
			EndIf
		EndIf
	Else
		Aviso("NFEE","Siga atentamente los pasos para la configuracion del remito electronico.",{"Ok"},3)	 //"Ok"
	EndIf
Else
	Aviso("NFEE","Siga atentamente los pasos para la configuracion del remito electronico.",{"Ok"},3) //"Ok"
EndIf

DelClassIntf()
Return


//===================================================================================================================================
/*/{Protheus.doc} FiltraRem
   Función para filtrar los resultados del monitor para visualizar únicamente los remitos transmitidos
   
   @type    Static Function
   @author  Alejandro Perret
   @since   19/07/22
   @version 1.0
/*/
//===================================================================================================================================

Static Function FiltraRem(aRemitos)
Local aAux 	:= {}
Local nPos	:= 0
Local nX	:= 0

Default aRemitos := {}

If Type('_aDocsElec') == 'A' .And. !Empty(_aDocsElec) .And. !Empty(aRemitos)

	aAux := AClone(aRemitos)
	aRemitos := {}

	For nX := 1 To Len(aAux)
		If (nPos := AScan(_aDocsElec, {|x| x == aAux[nX][2]})) > 0
			Aadd(aRemitos, aAux[nX])
		EndIf
	Next
EndIf

Return()


//===================================================================================================================================
/*/{Protheus.doc} WsNFeMnt - COPIA DEL ARGREMELET.PRX   
/*/
//===================================================================================================================================


Static Function WsNFeMnt(cIdEnt,nModelo,aParam)

Local aListBox := {}
Local aMsg     := {}
Local nX       := 0
Local nY       := 0
Local cURL        := FindURL()
Local lOk      := .T.
Local oOk      := LoadBitMap(GetResources(), "ENABLE")
Local oNo      := LoadBitMap(GetResources(), "DISABLE") 
Local oWS
Local oRetorno

Local cErro	:=""
Local cAviso	:=""

Private oXMLERROS
Private oXMLERRO
Private oRetRem

oWS:= WSNFESLOC():New()                   
oWS:cUSERTOKEN    := "TOTVS"
oWS:cID_ENT       := cIdEnt 
oWS:_URL          := AllTrim(cURL)+"/NFESLOC.apw"
oWS:cMODELO       := "5"
oWS:cIdInicial    := aParam[01]+aParam[02]
oWS:cIdFinal      := aParam[01]+aParam[03]
lOk := oWS:MONITORREMITO()

If (lOk)
	
	oRetorno := oWs:oWSMONITORREMITORESULT
	
	SF2->(dbSetorder(1))
	For nX := 1 To Len(oRetorno:OWSRETIDARRAY:OWSMONITORRET)
		
		aMsg      := {}
  		oXMLERROS := Nil 
  		oXmlErro  := NIl
  		
  		oRetRem := oRetorno:OWSRETIDARRAY:OWSMONITORRET[Nx]
  		
  		if !Empty(oRetRem:CXMLRETERRO) //Caso exista msg de erro leva as informações para a mensagem  			
  			
  			oXMLERROS := XmlParser(EncodeUTF8(oRetRem:CXMLRETERRO),"_",@cErro,@cAviso) 
  			
  			if type("oXMLERROS:_REMITOERROS:_ERRO") == "A"
  				oXmlErro := oXMLERROS:_REMITOERROS:_ERRO
  			else
   				oXmlErro := {oXMLERROS:_REMITOERROS:_ERRO}
  			endif   			
  			
  			for ny := 1 to  len(oXmlErro)
	  			
	  			aadd(aMsg,{oRetRem:CID,;
	  				oXmlErro[ny]:_DESC_ERRO_RET:TEXT,;
	  				oXmlErro[nY]:_COD_ERRO_RET:TEXT})
	  			
		 	next ny	
  		endif
  		  			
		//"", "NF",STR0063,STR0064,STR0065,STR0066,STR0067,STR0075; //"Ambiente"###"Chave"###"Autorização"###"Recomendação"###"Nome Arq."###"Comprovante"
					
		aadd(aListBox,{ IIf(oRetRem:cSTATUS <> '3',oNo,oOk),;
   				  		oRetRem:CID,;
   				  		IIf(oRetRem:nAMBIENTE==1,"Produccion","Homologacion"),;//"Produção"###"Homologação"
   				  		oRetRem:CCHV_REMITO,;
   				  		oRetRem:CAUT,;
   				  		PadR(oRetRem:CRECOMENDACAO,100),;
   				  		PadR(oRetRem:CARQNAME,50),;
   				  		oRetRem:CXMLRETAUTH,; 
   				  		oRetRem:CXMLRETERRO,;
	  					aMsg,;
	  					oRetRem:cCOMP,;
	  					oRetRem:cSTATUS})
	  					
	  					//STATUS POSSIVEIS RETORNADO PELO TSS
	  					//1 - "001 - Remito recebido, aguarde montagem do arquivo de lote e transmissão"
						//2 - "002 - Remito inserido no arquivo de lote, aguarde transmissão"
						//3 - "003 - Remito transmitido e autorizado"
						//4 - "004 - Remito transmitido e rejeitado, consulte xml de erro"

			 		
		RemAtuBsCot(cIdEnt,aListBox[nX])		
    Next nX
Else
	Aviso("REMe",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Ok"},3) //"Ok"
EndIf      
Return(aListBox)


//-------------------------------------------------------------------
/*/{Protheus.doc} RemAtuBsCot - COPIA DEL ARGREMELET.PRX
Função que atualiza a base de dados do ERP com o retorno do monitor
do TSS.

@param cIdEnt		ID da enteidade do TSS
@param aDadosMnt	Dados do Monitor

@return 

@author  Rafael Iaquinto 
@since   15/01/2013
@version 11.5
/*/
//-------------------------------------------------------------------
Static Function RemAtuBsCot(cIdEnt,aDadosMnt)

local cSeek		:= ""
local cFlag		:= ""

local aAliasAtu	:= GetArea()

local dEnvLote

cSeek:= aDadosMnt[2]
cSeek:=SubStr(cSeek,TamSX3("F2_SERIE")[1]+1,TamSX3("F2_DOC")[1])+SubStr(cSeek,1,TamSX3("F2_SERIE")[1])

//STATUS POSSIVEIS RETORNADO PELO TSS
//1 - "001 - Remito recebido, aguarde montagem do arquivo de lote e transmissão"
//2 - "002 - Remito inserido no arquivo de lote, aguarde transmissão"
//3 - "003 - Remito transmitido e autorizado"
//4 - "004 - Remito transmitido e rejeitado, consulte xml de erro"


SF2->(dbSetOrder(1))

If SF2->( dbSeek(xFilial("SF2")+cSeek) ) .And. aDadosMnt[12] $ "3,4"
	if aDadosMnt[12] $ "3
		cFlag	:= "E"
	else
		cFlag	:= "M"	
	endif	
	
	if SF2->F2_FLREMEL <> cFlag .And. empty(SF2->F2_COMCOT)
		RecLock("SF2")	 	
	 	if cFlag == "E"
		 	SF2->F2_COMCOT 		:= aDadosMnt[11]
			SF2->F2_AUTHCOT    	:= aDadosMnt[05]
			if RemGetTxt(cIdEnt,aDadosMnt[07],,@dEnvLote) .And. !empty(dEnvLote)
				SF2->F2_ENVCOT	:= dEnvLote
			endif 
		endif	
		SF2->F2_FLREMEL	 	:= cFlag		
		MsUnlock()
	endif	
endif

RestArea(aAliasAtu)
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} RemGetTxt - COPIA DEL ARGREMELET.PRX
Função que busca o TXT de envio do COT no TSS

@param cIdEnt		Id da entidade no TSS
@param cNameArq		Nome do Arquivo desejado
@param cArqTxt		Refrência que irá receber o arquivo.
@param dEnvLote		Refrência data do envio do lote
@param dGerLote		Refrência data de geração do lote.
@param cTLote		Refrência hora de envio do lote.
@param cTGerLote	Refrência hora de geração do lote.
@param cXmlAut		Refrência Xml de autorização modelo TSS
@param cXmlRet		Refrência XML de retorno da propria ARBA.


@return lOk			.T. se o metodo for chamado com sucesso, e 
					retornar o arquivo.

@author  Rafael Iaquinto 
@since   15/01/2013
@version 11.5
/*/
//-------------------------------------------------------------------
Static Function RemGetTxt(cIdEnt,cNameArq,cArqTxt,dEnvLote,dGerLote,cTLote,cTGerLote,cXmlAut,cXmlErr,cXmlRet)

local cUrl 		:= FindURL()

local lOk 		:= .T.

local oWs                                 

default	cArqTxt		:= ""
default	cTLote		:= ""
default	cTGerLote	:= ""
default	cXmlAut		:= ""
default	cXmlErr		:= ""
default	cXmlRet		:= ""

default	dEnvLote	:= CTOD("  /  /  ")
default	dGerLote	:= CTOD("  /  /  ") 

oWS := WSNFESLOC():New()	  
oWs:cUserToken := "TOTVS"
oWs:cID_ENT    := cIdEnt
oWS:_URL       := AllTrim(cURL)+"/NFESLOC.apw"
oWS:cModelo    := "5"                                     


if !empty(cNameArq)
	oWS:cNAMEARQ    := Alltrim(cNameArq)
	lOk := oWs:RETARQLOTEREMITO()
	
	if lOk
		cArqTxt 	:= oWS:OWSRETARQLOTEREMITORESULT:CTXTLOTE 
		dEnvLote	:= oWS:OWSRETARQLOTEREMITORESULT:dDATEENVLOTE
		dGerLote	:= oWS:OWSRETARQLOTEREMITORESULT:dDATEGERLOTE
		cTLote		:= oWS:OWSRETARQLOTEREMITORESULT:cTIMEENVLOTE
		cTGerLote	:= oWS:OWSRETARQLOTEREMITORESULT:cTIMEGERLOTE
		cXmlAut		:= oWS:OWSRETARQLOTEREMITORESULT:cXMLAUT
		cXmlErr		:= oWS:OWSRETARQLOTEREMITORESULT:cXMLERR
		cXmlRet		:= oWS:OWSRETARQLOTEREMITORESULT:cXMLRET
	endif
endif
  
oWS	:=Nil

Return(lOk)


//COPIA DEL ARGREMELET.PRX
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³IsReady   ³ Autor ³Eduardo Riera          ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se a conexao com a Totvs ARGN Services pode ser    ³±±
±±³          ³estabelecida                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: URL do Totvs Services ARGN                        OPC³±±
±±³          ³ExpN2: nTipo - 1 = Conexao ; 2 = Certificado             OPC³±±
±±³          ³ExpL3: Exibe help                                        OPC³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function IsReady(cURL,lHelp)

Local oWS
Local lRetorno := .t.

DEFAULT lHelp := .F.


If !Empty(cURL)
	PutMV("MV_ARGREUR",cURL)
EndIf   			    
  
DEFAULT cURL      := PadR(GetNewPar("MV_ARGREUR","http://"),250)
SuperGetMv() //Limpa o cache de parametros - nao retirar

//Verifica se o servidor do TSS está no AR
If cIdEnt == Nil .Or. Empty(cIdEnt)
	cIdEnt := GetIdEnt()		
EndIf 

oWs:= WSNFECFGLOC()():New()
oWs:cUserToken := "TOTVS"
oWS:cID_ENT       := cIdEnt 
oWS:_URL := AllTrim(cURL)+"/NFECFGLOC.apw"
If oWs:LOCCONNECT()
	lRetorno := .T.
Else
	If lHelp
		Aviso("REMe",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Ok"},3)
	EndIf
	lRetorno := .F.
EndIf

Return(lRetorno)


//COPIA DEL ARGREMELET.PRX
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GetIdEnt  ³ Autor ³Eduardo Riera          ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtem o codigo da entidade apos enviar o post para o Totvs  ³±±
±±³          ³Service                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: Codigo da entidade no Totvs Services                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL        := FindURL()
Local oWs
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄJÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWs:=WSNFECFGLOC():New() 
oWS:cUSERTOKEN := "TOTVS"
oWS:_URL       := AllTrim(cURL)+"/NFECFGLOC.apw"	
oWs:oWSEMPRESA:cCUIT       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")	
oWS:oWSEMPRESA:cCODFIL 	   := SM0->M0_CODFIL
oWS:oWSEMPRESA:cINSCRPROVI := SM0->M0_INSC		
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWs:oWSEMPRESA:cCODPROVINC := SM0->M0_ESTENT  // pegar codigo
oWS:oWSEMPRESA:cCP         := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_PAIS   := "063"               
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:CNUM        := SM0->M0_CIDENT        
oWs:oWSEMPRESA:cREGMUN     := ""  // rEGIME mUN
oWs:oWSEMPRESA:cDDN        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())                                      
//oWS:oWSEMPRESA:cDESCPROVINC 	:= "BA"//SA1->A1_
oWS:_URL := AllTrim(cURL)+"/NFECFGLOC.apw"

If  oWS:ADMEMPLOC()
	cIdEnt  := oWS:CADMEMPLOCRESULT
Else
	Aviso("NFEE",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Ok"},3)
EndIf

RestArea(aArea)
Return(cIdEnt)


//-------------------------------------------------------------------
/*/{Protheus.doc} RemRecXml - COPIA DEL ARGREMELET.PRX
Exibe em um DIalog o XML de ERRO e Autorização

@param cIdRemito	Id do Remito
@param cXmlAuth		Variavel com o XML de Autorização
@param cXMLErro		Variável com o XML de Erro

@return

@author  Rafael Iaquinto 
@since   15/01/2013
@version 11.5
/*/
//-------------------------------------------------------------------
Static Function RemViewXml(cIdRemito,cXMLAuth,cXMLErro)

Local	oDlg
Local 	oSayAuth		
Local 	oSayErro		
Local 	oGetAuth		
Local 	oGetErro		
Local	oFont		:=	TFont ():New ("Arial",, 15,, .F.) 
Local	oFontB		:=	TFont ():New ("Arial",, 15,, .T.)

DEFINE MSDIALOG oDlg FROM 000,000 TO 325, 416 TITLE STR0072+": "+cIdRemito PIXEL
//
@005, 005 SAY oSayAuth VAR STR0070 SIZE 205, 010 FONT oFontB OF oDlg PIXEL COLOR CLR_RED
@015, 005 GET oGetAuth VAR cXMLAuth OF oDlg MEMO SIZE 199, 055 FONT oFont PIXEL READONLY //NOBORDER
//
@075, 005 SAY oSayErro VAR STR0071 SIZE 205, 010 FONT oFontB OF oDlg PIXEL COLOR CLR_RED
@085, 005 GET oGetErro VAR cXMLErro OF oDlg MEMO SIZE 199, 055 FONT oFont PIXEL READONLY //NOBORDER
//
DEFINE SBUTTON oBtOk FROM 145, 180 TYPE 1 ACTION (lRet := .T., oDlg:End ()) ENABLE OF oDlg
//
ACTIVATE MSDIALOG oDlg CENTERED

return

//-------------------------------------------------------------------
/*/{Protheus.doc} RemViewTxt - COPIA DEL ARGREMELET.PRX
Função que exibe o TXT na tela para o usuário vizualizar

@param cIdRemito	ID da Entidade
@param cNameArq		Nome do arquivo desejado

@return

@author  Rafael Iaquinto 
@since   15/01/2013
@version 11.5
/*/
//-------------------------------------------------------------------
Static Function RemViewTxt (cIdEnt,cNameArq)

local cArtTxt := "" 

if !empty( cNameArq )
	if RemGetTxt(cIdEnt,cNameArq,@cArtTxt)
		if !empty( cArtTxt )
			Aviso(STR0074,cArtTxt,{STR0069},3)//"REMe - Arquivo de Lote TXT - COT"##"Ok"			
		else
			Aviso("REMe",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Ok"},3)//"Ok"
		endif	
	endif
else
	Aviso("REMe",STR0073,{STR0069},3)//"Ok"	
endif

return


//-------------------------------------------------------------------
/*/{Protheus.doc} RemVldUpd
Função que valida se o updfloc foi rodado corretamente e todos os
campos necessários foram criados.

@param aMsg			Array com as mensagens de erro.

@return 

@author  Rafael Iaquinto 
@since   15/01/2013
@version 11.5
/*/
//-------------------------------------------------------------------
Static Function VisMsgErr( aMsg ) 

Local aSize    := MsAdvSize()
Local aObjects := {}
Local aInfo    := {}
Local aPosObj  := {}
Local oDlg
Local oListBox
Local oBtn1
                                                 		
If !Empty(aMsg)
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	DEFINE MSDIALOG oDlg TITLE "REMe" From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL
	@ aPosObj[1,1],aPosObj[1,2] LISTBOX oListBox Fields HEADER STR0080,STR0081,STR0082; //"NF"###"Codigo do Erro"###"Descrição do Erro"
						SIZE aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1] PIXEL
	oListBox:SetArray( aMsg )
	oListBox:bLine := { || { aMsg[ oListBox:nAT,1 ],aMsg[ oListBox:nAT,3 ],aMsg[ oListBox:nAT,2 ]} }
	@ aPosObj[2,1],aPosObj[2,4]-030 BUTTON oBtn1 PROMPT STR0069         ACTION oDlg:End() OF oDlg PIXEL SIZE 028,011//Ok""
	ACTIVATE MSDIALOG oDlg
EndIf
Return(.T.)


//-------------------------------------------------------------------
/*/{Protheus.doc} FindURL
Função que retorna a URL configurada no ERP pelo usuário, e gravada
no SX6

@param 


@return cRetURL		Retorna a URL do TSS configurada no SX6 do Prothes

@author  Rafael Iaquinto 
@since   15/01/2013
@version 11.5
/*/
//-------------------------------------------------------------------                                           			
Static Function FindURL()

Local cRetURL := ""

cRetURL := (PadR(GetNewPar("MV_ARGREUR","http://"),250))		

Return cRetURL
