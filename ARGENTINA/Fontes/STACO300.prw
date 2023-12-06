#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

#DEFINE SnTipo      1
#DEFINE _SHOW_LEYEND "OBROWSE:ALEGENDS[1][2]:VIEW()"
#DEFINE _VER_TOTALES .F.   // Activa la visualización de los totalizadores

/*/{Protheus.doc} STACO300
Rutina de Solicitudes de devolución 
	
@author Alejandro Perret - Norte Desarrollos
@since 05/02/2021
@version 1.0		
/*/

User Function STACO300()
Local cTitulo := "Solicitudes de devolución"

Private aRotina    := MenuDef()  
Private _cSector   := Posicione("SZM", 2, xFilial("SZM") + __CuserID, "ZM_SECTOR")
Private _nTamSeq   := TamSX3("ZD3_SEQ")[1]
Private _nTamFac   := TamSX3("F2_DOC")[1]

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("ZD1")
oBrowse:SetDescription(cTitulo)
oBrowse:DisableDetails() 

oBrowse:AddLegend( "ZD1_ESTADO=='P'", "WHITE",   "Pendiente") 
oBrowse:AddLegend( "ZD1_ESTADO=='Q'", "YELLOW", "Aprobación Parcial") 
oBrowse:AddLegend( "ZD1_ESTADO=='R'", "RED",    "Rechazada") 
oBrowse:AddLegend( "ZD1_ESTADO=='A'", "GREEN",  "Aprobada") 
oBrowse:AddLegend( "ZD1_ESTADO=='N'", "GRAY",  "NCC Asociada") 

oBrowse:Activate() 

Return()


//===================================================================================================================================
/*/{Protheus.doc} MenuDef
   Definición del menú de acciones
   
   @type    Static Function
   @author  Alejandro Perret
   @since   05/02/21
   @version 1.0
/*/
//===================================================================================================================================


Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina Title 'Visualizar'   Action 'U_STACO30A(.F.,.F.)'       OPERATION 1 ACCESS 0
ADD OPTION aRotina Title 'Incluir'      Action 'VIEWDEF.STACO300'          OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Modificar'    Action 'U_STACO30A(.F.,.T.)'       OPERATION 1 ACCESS 0 
ADD OPTION aRotina Title 'Aprobar'      Action 'U_STACO30A(.T.,.F.)'       OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Eliminar'     Action 'U_STACO30A(.F.,.F.,,.T.)'  OPERATION 1 ACCESS 0
ADD OPTION aRotina Title 'Leyenda'      Action _SHOW_LEYEND                OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Obs. Calidad' Action 'U_STACO30A(.T.,.F.,.T.)'   OPERATION 2 ACCESS 0

Return(aRotina) 


//===================================================================================================================================
/*/{Protheus.doc} ModelDef
   Definición del modelo de datos  
   
   @type    Static Function
   @author  Alejandro Perret
   @since   05/02/21
   @version 1.0
/*/
//===================================================================================================================================

Static Function ModelDef()
Local oStruZD1 := FWFormStruct(1, 'ZD1')
Local oStruZD2 := FWFormStruct(1, 'ZD2')
Local oModel := MPFormModel():New("STCO300M") 

oModel:AddFields("ZD1MASTER", /*cOwner*/, oStruZD1) 
oModel:AddGrid("ZD2DETAIL", "ZD1MASTER", oStruZD2 )
oModel:SetRelation("ZD2DETAIL", {{"ZD2_FILIAL", "xFilial('ZD2')"}, {"ZD2_NUMSOL", "ZD1_NUMSOL"}}, ZD2->(IndexKey(1))) 

oModel:SetDescription('Modelo de dados de Devoluciones')
oModel:GetModel("ZD1MASTER"):SetDescription('Solicitud de devoluc.')
oModel:GetModel("ZD2DETAIL"):SetDescription('Ítems de la solicitud de devolución')
oModel:SetPrimaryKey({"ZD1_FILIAL", "ZD1_NUMSOL"})

If _VER_TOTALES
   oModel:AddCalc( 'STCO300MC1', 'ZD1MASTER', 'ZD2DETAIL', 'ZD2_QUANT', 'ZD2__TOT01', 'SUM',,,'Qtd. Total' )
   oModel:AddCalc( 'STCO300MC1', 'ZD1MASTER', 'ZD2DETAIL', 'ZD2_TOTAL', 'ZD2__TOT02', 'SUM',,,'Valor Total' )
EndIf

Return(oModel)



//===================================================================================================================================
/*/{Protheus.doc} ViewDef
   Definición de la vista
    
   @type    Static Function
   @author  Alejandro Perret
   @since   05/02/21
   @version 1.0
/*/
//===================================================================================================================================

Static Function ViewDef()
Local oModel   := FWLoadModel("STACO300")
Local oView    := FWFormView():New()
Local oStruZD1 := FWFormStruct(2, "ZD1")
Local oStruZD2 := FWFormStruct(2, "ZD2")
Local nTamCab  := 24
Local nTamItems:= Iif(Type('_lAprob') == 'L' .And. _lAlter == .F., 50, 76)
Local nTamPie  := 26
Local aCoordAdms 	:= MsAdvSize(.F.)
Local nAltoWnd 	:= aCoordAdms[4] 
Local nTamTotales := 0

oView:SetModel(oModel) 
oView:AddField("VIEW_ZD1", oStruZD1, "ZD1MASTER")
oView:AddGrid("VIEW_ZD2" , oStruZD2, "ZD2DETAIL") 

If _VER_TOTALES
   oStr3:= FWCalcStruct( oModel:GetModel('STCO300MC1') )
   oView:AddField('CALC', oStr3, 'STCO300MC1')
   nTamTotales := Iif(nAltoWnd < 372, 10, 6)
EndIf

oView:AddIncrementField("VIEW_ZD2", "ZD2_ITEM")
oView:AddUserButton("Factura Orig.", "CLIPS", {|oView| CargaFacturas(oView)})

oView:CreateHorizontalBox("ENCAB"  , nTamCab)
oView:SetOwnerView("VIEW_ZD1", "ENCAB")

If Type('_lAprob') == 'L' .And. _lAlter == .F. .And. nAltoWnd < 372
   nTamItems:= 41 
   nTamPie  := 35 
EndIf

oView:CreateHorizontalBox("DETALLE", nTamItems-nTamTotales)
oView:SetOwnerView("VIEW_ZD2", "DETALLE")

If _VER_TOTALES
   oView:CreateHorizontalBox("TOTALES", nTamTotales)
   oView:SetOwnerView('CALC','TOTALES')
EndIf

If Type('_lAprob') == 'L' .And. _lAlter == .F.
   oView:CreateHorizontalBox("PIE"  , nTamPie)
   oView:AddOtherObject("APROBACIONES", {|oPanel| PanelAprob(oPanel)})
   oView:SetOwnerView("APROBACIONES","PIE") 
EndIf

Return(oView)

//===================================================================================================================================
/*/{Protheus.doc} PanelAprob
   Panel para gestión de aprobaciones
    
   @type    Static Function
   @author  Alejandro Perret
   @since   05/02/21
   @version 1.0
/*/
//=================================================================================================================================== 
Static Function PanelAprob(oPanel) 
Local nMedio   := 0
Local nAltoPie := 0
Local nAnchoPie:= 0
Local oFolder, oBtnHObs, oSay1, oBtnRecF, oBtnAprF 
Local oBtnRecC, oBtnAprC, oBtnObs  
Local nAlignIzq   := 0
Local nAlignUp := 20
Local oFont    := TFont():New('Arial',,-11,.T.,.T.)
Local cUsrFina := Space(50)
Local cUsrCome := Space(50)  
Local cFecFina := Space(50)
Local cFecCome := Space(50)
Local cEstFina := Space(50)
Local cEstFiMs := ""
Local cEstCome := Space(50)
Local cEstCoMs := ""
Local cObsFina := ""
Local cObsCome := ""
Local cSeq     := "000"
Local cSeqObs  := "000"
Local cUsrObse := Space(50)
Local cFecObse := Space(50)
Local cSecObse := Space(50)
Local cObsObse  := ""
Local lWhen    := _lAprob
Local lEsFina  := (_cSector == "FIN")
Local lEsCome  := (_cSector == "COM")
Local lEsObse  := (_cSector == "QLT")
Local bIniVar  := {|| IniVar(@cUsrFina, @cUsrCome,@cFecFina,@cFecCome,@cEstFina,@cEstCome,@cObsFina,@cObsCome ,@cUsrObse,@cFecObse,@cSecObse,@cObsObse,@cSeq,@cSeqObs, @cEstFiMs, @cEstCoMs) } // Función para precargar y visualizar la informacion de aprobaciones/observ anteriores
Local oGetEstF, oGetFecF, oGetUsrF, oTMultiget1, oGetEstC, oGetFecC, oGetUsrC, oTMultiget2, oGetUsrO, oGetFecO, oTMultiget3

Eval(bIniVar)

@000, 000 FOLDER oFolder SIZE 744, 80 ITEMS "Aprobaciones","Observaciones de Calidad" PIXEL OF oPanel

oFolder:Align := CONTROL_ALIGN_ALLCLIENT
nAltoPie  := (oFolder:nClientHeight / 2)
nAnchoPie := (oFolder:nClientWidth / 2)
nMedio := (nAnchoPie / 2)

//BOX IZQUIERDA PESTAÑA APROBACIONES FINANZAS
@002,002 TO nAltoPie-20,nMedio-12 LABEL "Finanzas" OF oFolder:aDialogs[1] PIXEL 
cTexto3 := cObsFina

nAlignIzq := 010
@ nAlignUp-8, nAlignIzq SAY oSay1 PROMPT "Usuario" SIZE 025, 007 OF oFolder:aDialogs[1] FONT oFont COLORS 0, 16777215 PIXEL
@nAlignUp, nAlignIzq MSGET oGetUsrF VAR cUsrFina SIZE 100,010 When .F. PIXEL OF oFolder:aDialogs[1] //VALID Eval(bValQuant,nQtSeg)
nAlignIzq+=110
@ nAlignUp-8, nAlignIzq SAY oSay1 PROMPT "Fecha" SIZE 025, 007 OF oFolder:aDialogs[1]  FONT oFont COLORS 0, 16777215 PIXEL
@nAlignUp, nAlignIzq MSGET oGetFecF VAR cFecFina SIZE 045,010 When .F. HASBUTTON PIXEL OF oFolder:aDialogs[1] //VALID Eval(bValQuant,nQtSeg)
nAlignIzq+=50
@ nAlignUp-8, nAlignIzq SAY oSay1 PROMPT "Estado" SIZE 025, 007 OF oFolder:aDialogs[1]  FONT oFont COLORS 0, 16777215 PIXEL
@nAlignUp, nAlignIzq MSGET oGetEstF VAR cEstFiMs SIZE 035,010 When .F. PIXEL OF oFolder:aDialogs[1] //VALID Eval(bValQuant,nQtSeg)

nAlignIzq := 010
oTMultiget1 := tMultiget():new( nAlignUp+15, nAlignIzq, {| u | if( pCount() > 0, cObsFina := u, cObsFina ) }, ;
oFolder:aDialogs[1], nMedio-80, nAltoPie-60, , , , , , .T., , , {|| .F.})

@12, nMedio-60 BUTTON oBtnAprF PROMPT "&Aprobar" SIZE 40,14 ACTION(ModalObs("Aprobación Finanzas","Desea grabar la aprobación?","A","F",@cSeq,@cObsFina,@cUsrFina,@cFecFina,@cEstFina,,@cEstFiMs);
,Eval(bIniVar), AtuPie()) When (lWhen .And. lEsFina) PIXEL OF oFolder:aDialogs[1]
@32, nMedio-60 BUTTON oBtnRecF PROMPT "&Rechazar" SIZE 40,14 ACTION(ModalObs("Rechazo Finanzas","Desea grabar el rechazo?","R","F",@cSeq,@cObsFina,@cUsrFina,@cFecFina,@cEstFina,,@cEstFiMs);
,Eval(bIniVar), AtuPie()) When (lWhen .And. lEsFina) PIXEL OF oFolder:aDialogs[1]
@52, nMedio-60 BUTTON oBtn04  PROMPT "&Ver Historial" SIZE 40,14 ACTION(ModalHist("Historial Aprobaciones","FINA")) PIXEL OF oFolder:aDialogs[1]


//BOX DERECHA PESTAÑA APROBACIONES COMERCIAL
@002,nMedio+12 TO nAltoPie-20,nAnchoPie-6 LABEL "Comercial" OF oFolder:aDialogs[1] PIXEL

nAlignIzq := nMedio + 20 

@ nAlignUp-8, nAlignIzq SAY oSay1 PROMPT "Usuario" SIZE 025, 007 OF oFolder:aDialogs[1] FONT oFont COLORS 0, 16777215 PIXEL
@nAlignUp, nAlignIzq MSGET oGetUsrC VAR cUsrCome SIZE 100,010 When .F. PIXEL OF oFolder:aDialogs[1] //VALID Eval(bValQuant,nQtSeg)
nAlignIzq+=110
@ nAlignUp-8, nAlignIzq SAY oSay1 PROMPT "Fecha" SIZE 025, 007 OF oFolder:aDialogs[1] FONT oFont COLORS 0, 16777215 PIXEL
@nAlignUp, nAlignIzq MSGET oGetFecC VAR cFecCome SIZE 045,010 When .F. HASBUTTON PIXEL OF oFolder:aDialogs[1] //VALID Eval(bValQuant,nQtSeg)
nAlignIzq+=50
@ nAlignUp-8, nAlignIzq SAY oSay1 PROMPT "Estado" SIZE 025, 007 OF oFolder:aDialogs[1] FONT oFont COLORS 0, 16777215 PIXEL
@nAlignUp, nAlignIzq MSGET oGetEstC VAR cEstCoMs SIZE 035,010 When .F. PIXEL OF oFolder:aDialogs[1] //VALID Eval(bValQuant,nQtSeg)

nAlignIzq := nMedio + 20   

oTMultiget2 := tMultiget():new( nAlignUp+15, nAlignIzq, {| u | if( pCount() > 0, cObsCome := u, cObsCome ) }, ;
oFolder:aDialogs[1], nMedio-80, nAltoPie-60, , , , , , .T., , , {|| .F.})

@12, nAnchoPie-54 BUTTON oBtnAprC  PROMPT "&Aprobar" SIZE 40,14 ACTION(ModalObs("Aprobación Comercial","Desea grabar la aprobación?","A","C",@cSeq,@cObsCome,@cUsrCome,@cFecCome,@cEstCome,,@cEstCoMs);
,Eval(bIniVar) ,AtuPie()) When (lWhen .And. lEsCome) PIXEL OF oFolder:aDialogs[1]
@32, nAnchoPie-54 BUTTON oBtnRecC  PROMPT "&Rechazar" SIZE 40,14 ACTION(ModalObs("Rechazo Comercial","Desea grabar el rechazo?","R","C",@cSeq,@cObsCome,@cUsrCome,@cFecCome,@cEstCome,,@cEstCoMs);
,Eval(bIniVar) ,AtuPie()) When (lWhen .And. lEsCome) PIXEL OF oFolder:aDialogs[1]
@52, nAnchoPie-54 BUTTON oBtn04  PROMPT "&Ver Historial" SIZE 40,14 ACTION(ModalHist("Historial Aprobaciones", "COM")) PIXEL OF oFolder:aDialogs[1]

//PESTAÑA OBSERVACIONES

@008, 010 SAY oSay1 PROMPT "Usuario" SIZE 025, 007 OF oFolder:aDialogs[2] FONT oFont PIXEL
@036, 010 SAY oSay1 PROMPT "Fecha" SIZE 025, 007 OF oFolder:aDialogs[2] FONT oFont PIXEL
@008, 120 SAY oSay1 PROMPT "Observaciones" SIZE 050, 007 OF oFolder:aDialogs[2] FONT oFont PIXEL

@016, 010 MSGET oGetUsrO VAR cUsrObse SIZE 100,010 When .F. PIXEL OF oFolder:aDialogs[2]
@044, 010 MSGET oGetFecO VAR cFecObse SIZE 045,010 When .F. PIXEL OF oFolder:aDialogs[2] HASBUTTON

oTMultiget3 := tMultiget():new(016,120,{| u | if( pCount() > 0, cObsObse := u, cObsObse )},oFolder:aDialogs[2],nAnchoPie-82-120,nAltoPie-39, , , , , , .T. , , ,{|| .F.}, , , , , , , ,.T.)

@016, nAnchoPie-70 BUTTON oBtnObs  PROMPT "&Nueva Observación"   SIZE 60,14 ACTION(ModalObs("Observación","Desea grabar la Observación?",,,@cSeqObs,@cObsObse,@cUsrObse,@cFecObse,@cSecObse,.T.), Eval(bIniVar), AtuPie()) When (lWhen .And. lEsObse) PIXEL OF oFolder:aDialogs[2]
@036, nAnchoPie-70 BUTTON oBtnHObs PROMPT "&Ver Historial"       SIZE 60,14 ACTION(ModalHist("Historial Observaciones de Calidad","")) PIXEL OF oFolder:aDialogs[2]

If _lObs
   oFolder:ShowPage(2)
EndIf 

Return()


//===================================================================================================================================
/*/{Protheus.doc} ModalObs
   Modal Para Observaciones
    
   @type    Static Function
   @author  Frias Lucas
   @since   17/03/21
   @version 1.0ModalObs
/*/
//=================================================================================================================================== 
Static Function ModalObs(cTitle,cTitleMsg,cEstado,cNivel,cSeq,cObsCome,cUsrCome,cFecCome,cEstCome,lObs,cEstMs)
Local oModal
Local oContainer
Local cTexto1 := ""
Local cUser := UsrFullName(__CuserID)
Local cDate := DTOC(dDatabase)
Local lGraba := .F.
Local oFont    := TFont():New('Arial',,-12,.T.,.T.)
Local cSector := "Q" // Buscar el Nombre del sector que corresponde //

Default lObs := .F.
 
oModal  := FWDialogModal():New()       
oModal:SetEscClose(.T.)
oModal:setTitle(cTitle)

oModal:setSize(230, 420)
oModal:createDialog()
oModal:AddButtons({{"", "Confirmar",  {|| lGraba := MsgNoYes(cTitleMsg ,"Confirme..."), Iif(lGraba, oModal:OOWNER:END(), )}, "", 0, .T., .F.}})
oModal:AddButtons({{"", "Cancelar", {||Iif(Empty(cTexto1), oModal:OOWNER:END(), Iif(MsgNoYes("Desea descartar los cambios?" ,"Confirme..."), oModal:OOWNER:END(),))} , "", 0, .T., .F.}})

oContainer := TPanel():New( ,,, oModal:getPanelMain() )
oContainer:Align := CONTROL_ALIGN_ALLCLIENT

TSay():New(12,10,{|| "Usuario "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 20,10,{||cUser},oContainer,100,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,cUser,,,, )

TSay():New(12,120,{|| "Fecha "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 20,120,{||cDate},oContainer,035,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,cDate,,,, )

// If lObs
//    TSay():New(1,150,{|| "Sector "},oContainer,,,,,,.T.,,,30,20,,,,,,.T.)
//    TGet():New( 10,150,{||cSector},oContainer,035,010, "@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cSector,,,, )
// EndIf

TSay():New(40,10,{|| "Observaciones "},oContainer,,oFont,,,,.T.,,,60,20,,,,,,.T.)
tMultiget():new( 50, 10, {| u | if( pCount() > 0, cTexto1 := u, cTexto1 ) }, ;
oContainer, 400, 120, , , , , , .T., , , , , , , , , , , .T.  )
   
oModal:Activate()

If lObs .And. lGraba
   GrabaObs(cTexto1,cSector,@cSeq,@cObsCome,@cUsrCome,@cFecCome,@cEstCome) //Graba Las Observaciones

ElseIf lGraba
   GrabaAprob(cEstado,cNivel,cTexto1,@cObsCome,@cUsrCome,@cFecCome,@cEstCome,@cEstMs)      // Graba las aprobaciones
   ActApro()    

EndIf

Return()


//===================================================================================================================================
/*/{Protheus.doc} ModalVis
   Modal Para Observaciones
    
   @type    Static Function
   @author  Frias Lucas - Ale
   @since   17/03/21
   @version 1.0
/*/
//=================================================================================================================================== 

Static Function ModalVis(cTitle, cUser, cDate, cObs, cEstado)
Local oModal
Local oContainer
Local oFont    := TFont():New('Arial',,-12,.T.,.T.)
Local cSector := "Q" // Buscar el Nombre del sector que corresponde //

Default cEstado := ""

oModal  := FWDialogModal():New()       
oModal:SetEscClose(.T.)
oModal:setTitle(cTitle)

oModal:setSize(230, 420)
oModal:createDialog()
oModal:AddButtons({{"", "Cerrar", {|| oModal:OOWNER:END()} , "", 0, .T., .F.}})

oContainer := TPanel():New( ,,, oModal:getPanelMain() )
oContainer:Align := CONTROL_ALIGN_ALLCLIENT

TSay():New(12,10,{|| "Usuario "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 20,10,{||cUser},oContainer,100,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,cUser,,,, )

TSay():New(12,120,{|| "Fecha "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 20,120,{||cDate},oContainer,035,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,cDate,,,, )

If !Empty(cEstado)
   cEstado := Iif(cEstado == 'A', 'Aprobada', 'Rechazada')
   TSay():New(12, 167,{|| "Estado "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
   TGet():New(20, 167,{|| cEstado} ,oContainer,075,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,cEstado,,,, )
EndIf

// If lObs
//    TSay():New(1,150,{|| "Sector "},oContainer,,,,,,.T.,,,30,20,,,,,,.T.)
//    TGet():New( 10,150,{||cSector},oContainer,035,010, "@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cSector,,,, )
// EndIf

TSay():New(40,10,{|| "Observaciones "},oContainer,,oFont,,,,.T.,,,60,20,,,,,,.T.)
tMultiget():new( 50, 10, {| u | if( pCount() > 0, cObs := u, cObs ) }, oContainer, 400, 120, , , , , , .T., , , , , , .T., , , , , .T.  )
   
oModal:Activate()

Return()


//===================================================================================================================================
/*/{Protheus.doc} ModalHist
   Modal Para Historial
    
   @type    Static Function
   @author  Frias Lucas
   @since   17/03/21
   @version 1.0
/*/
//=================================================================================================================================== 
Static Function ModalHist(cTitle, cTipo)
Local aCab        :={}
Local aIt         :={}
Local aArea       := GetArea()
Local cQryTrb     := GetNextAlias()
Local cQry1       := ""
Local cNivel      := ""
Local cEstado     := ""
Local lAprob      := .F.

If cTipo == "FINA" .Or. cTipo == "COM"
   lAprob := .T.
   
   cQry1 := "SELECT ZD3_SEQ AS SEC, ZD3_USUARI AS USUARIO, ZD3_FECHA AS FECHA, ZD3_NIVEL AS NIVEL, ZD3_ESTADO AS ESTADO, "
   cQry1 += "UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(ZD3_OBS, 200,1)) AS OBSERVACIONES, R_E_C_N_O_ AS NUM_REG " 
   cQry1 += "FROM " + RetSqlName("ZD3") + " A " 
   cQry1 += "WHERE ZD3_FILIAL = '" + xFilial("ZD3") + "' "
   cQry1 += "AND ZD3_NUMSOL = '" + ZD1->ZD1_NUMSOL + "' "
   cQry1 += "AND D_E_L_E_T_ = ' ' "
   cQry1 += "ORDER BY ZD3_SEQ DESC"

   DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry1), cQryTrb, .F., .T.)
   DbSelectArea(cQryTrb)
   DbGoTop()
   While !Eof()
      cNivel := Iif(NIVEL  == "F", "Finanzas", "Comercial")
      cEstado:= Iif(ESTADO == "A", "Aprobada", "Rechazada")

      Aadd(aIt, {SEC, UsrFullName(USUARIO), Stod(FECHA), cNivel, cEstado, OBSERVACIONES, NUM_REG})
      DbSkip()
   End

   Aadd(aCab,  {"Sec."        ,              'C', "@!"            , 1, 4                        , 0 , .F.})
   Aadd(aCab,  {"Usuario"     ,              'C', "@!"            , 1, 35                       , 0 , .F.})
   Aadd(aCab,  {"Fecha"       ,              'D', "@!"            , 1, 12                       , 0 , .F.})
   Aadd(aCab,  {"Nivel"       ,              'C', "@!"            , 1, 12                       , 0 , .F.})
   Aadd(aCab,  {"Estado"      ,              'C', "@!"            , 1, 15                        , 0 , .F.})
   Aadd(aCab,  {"Observación" ,              'C', "@!"            , 1, 6                        , 0 , .F.})

Else 

   cQry1 := "SELECT ZD4_SEQ AS SEC, ZD4_USUARI AS USUARIO, ZD4_FECHA AS FECHA, "
   cQry1 += "UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(ZD4_OBS, 200,1)) AS OBS, R_E_C_N_O_ AS NUM_REG " 
   cQry1 += "FROM " + RetSqlName("ZD4") + " A " 
   cQry1 += "WHERE ZD4_FILIAL = '" + xFilial("ZD4") + "' "
   cQry1 += "AND ZD4_NUMSOL = '" + ZD1->ZD1_NUMSOL + "' "
   cQry1 += "AND D_E_L_E_T_ = ' ' "
   cQry1 += "ORDER BY ZD4_SEQ DESC"

   DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry1), cQryTrb, .F., .T.)
   DbSelectArea(cQryTrb)
   DbGoTop()

   While !Eof()
      Aadd(aIt, {SEC, UsrFullName(USUARIO), SToD(FECHA), OBS, NUM_REG})
      DbSkip()  
   EndDo

   Aadd(aCab,  {"Sec."        ,              'C', "@!"            , 1, 4                        , 0 , .F.})
   Aadd(aCab,  {"Usuario"     ,              'C', "@!"            , 1, 35                       , 0 , .F.})
   Aadd(aCab,  {"Fecha"       ,              'D', "@!"            , 1, 12                       , 0 , .F.})
   Aadd(aCab,  {"Observación" ,              'C', "@!"            , 1, 6                        , 0 , .F.})

EndIf

MsgInfoBr(cTitle, /*cMsgTop*/, aCab, aIt, /*cMsgBot*/, /*aBotones*/, 0.8, 0.9, lAprob)

(cQryTrb)->(DbCloseArea())
RestArea(aArea)
Return()


//===================================================================================================================================
/*/{Protheus.doc} CargaFacturas
   Muestra una pantalla para seleccionar factura
   
   @type    Static Function
   @author  Alejandro Perret
   @since   09/02/21
   @version 1.0
/*/
//===================================================================================================================================

Static Function CargaFacturas()

Local oModel      := FWModelActive() 
Local cCli        := oModel:GetValue("ZD1MASTER", "ZD1_CLIENT")
Local cLoj        := oModel:GetValue("ZD1MASTER", "ZD1_LOJA")
Local cNumSol     := oModel:GetValue("ZD1MASTER", "ZD1_NUMSOL")
Local cFacOri     := oModel:GetValue("ZD1MASTER", "ZD1_FACORI")
Local cSerOri     := oModel:GetValue("ZD1MASTER", "ZD1_SERORI")
Local oModelZD2   := oModel:GetModel("ZD2DETAIL") 
Local nOperation  := oModel:GetOperation()

Local oMS, oMSItems 	
Local cTit			:= "Consulta de Facturas"
Local cTitIt		:= "Ítems de factura: "
Local cQry1 		:= ""
Local lMark2		:= .F.
Local cCampoRet	:= "F2_DOC"
Local cCpoRetIt	:= "D2_ITEM"
Local nAncho		:= 400   
Local nAlto			:= 600
Local nAnchoIt		:= 900
Local nAltoIt		:= 500//650
Local lUnoSolo	   := .T.
Local lUnoSIt	   := .F.
Local aCposDev		:= {"F2_DOC", "F2_SERIE", "F2_EMISSAO"} 
Local aCposDevIt	:= {"D2_COD", "D2_QUANT", "D2_PRCVEN", "D2_TOTAL", "D2_LOCAL", "D2_ITEM"} 
Local aIndBusq		:= {} //{{"","ZF1_DOC"}} //El primer 'indice' ordena los resultados al inicio
Local nScrollTp	:= 0
Local aEstruEsp	:= {}
Local aFactura		:= {}
Local aItems		:= {}
Local cEspFact    := "NF"
Local nIt         := 0
Local cFilZD2     := xFilial("ZD2")
Local nTamItZD2   := TamSx3("ZD2_ITEM")[1]
Local cTES        := GetMV("ST_TESSDEV", , "001")  

If nOperation == MODEL_OPERATION_INSERT .Or. nOperation == MODEL_OPERATION_UPDATE
   If !Empty(cCli) .And. !Empty(cLoj)

      cQry1 := "SELECT F2_SERIE, F2_DOC, F2_EMISSAO " 
      cQry1 += "FROM " + RetSqlName("SF2") + " A " 
      cQry1 += "WHERE F2_FILIAL = '" + xFilial("SF2") + "' "
      cQry1 += "AND F2_CLIENTE = '" + cCli + "' "
      cQry1 += "AND F2_LOJA = '" + cLoj + "' "
      cQry1 += "AND F2_ESPECIE = '" + cEspFact + "' "

      If !Empty(cFacOri) .And. nOperation == MODEL_OPERATION_UPDATE
         MsgInfo("Esta devolución ya tiene una factura asociada. Se permitirá seleccionar únicamente items de la misma.")  
         cQry1 += "   AND F2_DOC = '" + cFacOri + "' " 
         cQry1 += "   AND F2_SERIE = '" + cSerOri + "' " 
      Else
         cQry1 += " AND F2_DOC NOT IN ( "
         cQry1 += "   SELECT ZD1_FACORI FROM " + RetSqlName("ZD1") + " "
         cQry1 += "   WHERE ZD1_FILIAL = '" + xFilial("ZD1") + "' "
         cQry1 += "   AND ZD1_CLIENT = '" + cCli + "' " 
         cQry1 += "   AND ZD1_LOJA = '" + cLoj + "' " 
         cQry1 += "   AND ZD1_FACORI <> ' ' " 
         cQry1 += "   AND D_E_L_E_T_ = ' ') "
      EndIf

      cQry1 += "AND A.D_E_L_E_T_ = ' ' "
      cQry1 += "ORDER BY F2_DOC DESC "

      oMS := MultiSel():New(cTit,cQry1,lMark2,cCampoRet,nAlto,nAncho,,,lUnoSolo, aCposDev, aIndBusq, nScrollTp, aEstruEsp)
      aFactura := oMS:Show() 
      
      If !Empty(aFactura)

            cQry1 := "SELECT D2_ITEM, D2_COD, B1_DESC, D2_QUANT, D2_PRCVEN, D2_TOTAL, D2_LOCAL " 
            cQry1 += "FROM " + RetSqlName("SD2") + " A " 
            cQry1 += "  INNER JOIN " + RetSqlName("SB1") + " B ON B1_FILIAL = '" + xFilial("SB1") + "' AND D2_COD = B1_COD AND B.D_E_L_E_T_ = ' ' "
            cQry1 += "WHERE D2_FILIAL = '" + xFilial("SD2") + "' "
            cQry1 += "AND D2_CLIENTE = '" + cCli + "' "
            cQry1 += "AND D2_LOJA = '" + cLoj + "' "
            cQry1 += "AND D2_ESPECIE = '" + cEspFact + "' "
            cQry1 += "AND D2_DOC = '" + AllTrim(aFactura[1][2]) + "' "
            cQry1 += "AND D2_SERIE = '" + AllTrim(aFactura[1][3]) + "' "
            cQry1 += "AND A.D_E_L_E_T_ = ' ' "
            cQry1 += "ORDER BY D2_ITEM "

            cTitIt += AllTrim(aFactura[1][3]) + "-" + AllTrim(aFactura[1][2])
            oMSItems := MultiSel():New(cTitIt,cQry1,/*lMark2*/ .F.,cCpoRetIt,nAltoIt,nAnchoIt,,,lUnoSIt, aCposDevIt, aIndBusq, nScrollTp, aEstruEsp)
            aItems := oMSItems:Show() 

            If !Empty(aItems)  
               If nOperation == MODEL_OPERATION_INSERT
                  oModelZD2:ClearData()
               Else
                  oModelZD2:DelAllLine()
                  oModelZD2:GoLine(1)
               EndIf

               For nIt := 1 To Len(aItems)
               
                  If (nIt > oModelZD2:Length())
                     nLin := oModelZD2:AddLine()                                           
                  Else
                     oModelZD2:GoLine(nIt)
                  EndIf

                  If oModelZD2:IsDeleted()
                     oModelZD2:UnDeleteLine()
                  EndIf
               
                  oModelZD2:SetValue('ZD2_FILIAL', cFilZD2)
                  oModelZD2:SetValue('ZD2_ITEM',   StrZero(nIt, nTamItZD2))
                  oModelZD2:SetValue('ZD2_NUMSOL', cNumSol)
                  oModelZD2:SetValue('ZD2_PRODUC', aItems[nIt][2])
                  oModelZD2:SetValue('ZD2_QUANT' , aItems[nIt][3])
                  oModelZD2:SetValue('ZD2_PRCUNI', aItems[nIt][4])
                  oModelZD2:SetValue('ZD2_TOTAL',  aItems[nIt][5])
                  oModelZD2:SetValue('ZD2_LOCAL',  aItems[nIt][6])
                  oModelZD2:SetValue('ZD2_TES',    cTES)
                  oModelZD2:SetValue('ZD2_ITEORI', aItems[nIt][7])
               Next

               oModel:SetValue("ZD1MASTER", "ZD1_FACORI", aFactura[1][2])
               oModel:SetValue("ZD1MASTER", "ZD1_SERORI", aFactura[1][3])
               oModel:SetValue("ZD1MASTER", "ZD1_FCHORI", aFactura[1][4])
            EndIf

         oModelZD2:GoLine(1)

      EndIf

   Else
      MsgInfo("Debe informar los datos de encabezado 'Cliente' y 'Tienda' para poder vincular facturas.")
   EndIf
Else
   MsgInfo("El uso de esta funcionalidad solo esta disponible al Incluir o Modificar una Solicitud de devolución")
EndIf

Return()


//===================================================================================================================================
/*/{Protheus.doc} STCO300L
   Limpia el cotendio de los campos Factura y serie original y elimina los ítems de la grilla.
   Utilizado al informar un cliente nuevo.
   
   @type    Static Function
   @author  Alejandro Perret
   @since   12/02/21
   @version 1.0
/*/
//===================================================================================================================================

User Function STCO300L()
Local oModel      := FWModelActive() 
Local oModelZD2   := oModel:GetModel("ZD2DETAIL")        
Local oView       := FWViewActive()
oModel:SetValue("ZD1MASTER", "ZD1_SERORI", Space(1))     // Limpia la serie ori
oModelZD2:ClearData()                                    // Limpia la grilla
oModelZD2:GoLine(1)
oView:Refresh() 

Return(Space(1))                                         // Limpia el factura ori


//===================================================================================================================================
/*/{Protheus.doc} STACO30A
   Visualización y aprobación
      
   @type    User Function
   @author  Alejandro Perret
   @since   18/03/21
   @p
   @version 1.0
   @param lAp , L, marca si es una aprobación
   @param lAl , L, marca si es una modificación (altera)
   @param lObs, L, marca si es una observación
   @param lDel, L, marca si es una eliminación (deleta)

/*/
//===================================================================================================================================

User Function STACO30A(lAp,lAl,lObs,lDel)

Local cTit     := "Visualizar"
Local cEstado  := ZD1_ESTADO
Local cNcc     := ""
Default lAp    := .F.
Default lAl    := .F.
Default lObs   := .F.
Default lDel   := .F.


Private _lAprob := lAp
Private _lAlter := lAl
Private _lObs   := lObs

If lAp 
   cTit := "Aprobación"
EndIf

DbSelectArea("ZD3")
DbSetOrder(1)  // ZD3_FILIAL + ZD3_NUMSOL + ZD3_SEQ

DbSelectArea("ZD4")
DbSetOrder(1)

If lAl 
   If (cEstado $ 'A/Q') 
      MsgInfo("No se permite modificar Solicitudes de devolución en estado 'Aprobadas' o 'Parcialmente aprobadas'.")
      Private _lAlter := .F.
      FWExecView("Visualizar", 'VIEWDEF.STACO300', 1, , {|| .T. })
   ElseIf cEstado == 'N'
      MsgInfo("No se permite modificar Solicitudes de devolución con Notas de Crédito asociadas." + CRLF + CRLF + "Nota de Crédito asociada: "+ Alltrim(ZD1->ZD1_NCCSER)  + "-" + ZD1->ZD1_NCCNUM )
      Private _lAlter := .F.
      FWExecView("Visualizar", 'VIEWDEF.STACO300', 1, , {|| .T. })
   else
      FWExecView("Modificar", 'VIEWDEF.STACO300', 4, , {|| .T. })
   EndIf
ElseIf lDel
   If cEstado == 'N'
      MsgInfo("No se permite eliminar Solicitudes de devolución con Notas de Crédito asociadas." + CRLF + CRLF + "Nota de Crédito asociada: "+ Alltrim(ZD1->ZD1_NCCSER)  + "-" + ZD1->ZD1_NCCNUM )
      FWExecView("Visualizar", 'VIEWDEF.STACO300', 1, , {|| .T. })
   Else
      _lObs   := .F.
      FWExecView("Eliminar", 'VIEWDEF.STACO300', 5, , {|| .T. })
   EndIf
ElseIf lAp
   If cEstado == 'N'
      MsgInfo("No se permite aprobar,rechazar o realizar observaciones en Solicitudes de devolución con Notas de Crédito asociadas." + CRLF + CRLF + "Nota de Crédito asociada: "+ Alltrim(ZD1->ZD1_NCCSER)  + "-" + ZD1->ZD1_NCCNUM )
      _lAprob := .F.
      FWExecView("Visualizar", 'VIEWDEF.STACO300', 1, , {|| .T. })
   Else
      FWExecView(cTit, 'VIEWDEF.STACO300', 1, , {|| .T. })
   EndIf
Else
   FWExecView("Visualizar", 'VIEWDEF.STACO300', 1, , {|| .T. })
EndIf
Return()


//===================================================================================================================================
/*/{Protheus.doc} GrabaAprob
   Grabación de aprobaciones
   
   @type    User Function
   @author  Alejandro Perret
   @since   18/03/21
   @version 1.0
/*/
//===================================================================================================================================

Static Function GrabaAprob(cEstado,cNivel,cOBS,cObsCome,cUsrCome,cFecCome,cEstCome, cEstMs)
Local cSecuencia := Soma1(UltimaSeq("ZD3"))

RecLock("ZD3", .T.)

   ZD3_FILIAL := xFilial("ZD3") 
   ZD3_NUMSOL := ZD1->ZD1_NUMSOL
   ZD3_SEQ    := cSecuencia
   ZD3_FECHA  := dDatabase
   ZD3_USUARI := __CuserID
   ZD3_ESTADO := cEstado
   ZD3_NIVEL  := cNivel
   ZD3_OBS    := cOBS

MsUnlock()

Return()

//===================================================================================================================================
/*/{Protheus.doc} GrabaObs
   Grabación de observaciones
   
   @type    User Function
   @author  Alejandro Perret
   @since   18/03/21
   @version 1.0
/*/
//===================================================================================================================================

Static Function GrabaObs(cOBS,cSector,cSeq,cObsObse,cUsrObse,cFecObse,cEstObse)
Local cSecuencia := Soma1(UltimaSeq("ZD4"))

RecLock("ZD4", .T.)

   ZD4_FILIAL := xFilial("ZD4") 
   ZD4_NUMSOL := ZD1->ZD1_NUMSOL
   ZD4_SEQ    := cSecuencia
   ZD4_FECHA  := dDatabase
   ZD4_USUARI := __CuserID
   ZD4_SEC    := cSector
   ZD4_OBS    := cOBS
  
MsUnlock()

Return()

//==========================================================================//
/*/{Protheus.doc} IniVar
   función para precargar y visualizar la informacion de aprobaciones/observ anteriores
   @type  Static Function
   @author Angeloff Cesar
   @since 19/03/2021
   /*/
//===================================================================================================================================
Static Function IniVar(cUsrFina, cUsrCome,cFecFina,cFecCome,cEstFina,cEstCome,cObsFina,cObsCome ,cUsrObse,cFecObse,cSecObse,cObsObse,cSeq,cSeqObs, cEstFiMs, cEstCoMs)   
Local cQuery  := ""
Local cQryTrb := GetNextAlias()
Local nNumReg := 0

nNumReg := UltAprob('F')

If !Empty(nNumReg)
   ZD3->(DbGoto(nNumReg))

   cUsrFina := UsrFullName(ZD3->ZD3_USUARI)
   cFecFina := ZD3->ZD3_FECHA
   cEstFina := ZD3->ZD3_ESTADO
   cObsFina := ZD3->ZD3_OBS
   cSeq     := ZD3->ZD3_SEQ   
   cEstFiMs := Iif(cEstFina == 'A', 'Aprobada', 'Rechazada')
EndIf

nNumReg := UltAprob('C')

If !Empty(nNumReg)
   ZD3->(DbGoto(nNumReg))

   cUsrCome := UsrFullName(ZD3->ZD3_USUARI)
   cFecCome := ZD3->ZD3_FECHA
   cEstCome := ZD3->ZD3_ESTADO
   cObsCome := ZD3->ZD3_OBS
   cSeq     := IIf(ZD3->ZD3_SEQ < cSeq, cSeq, ZD3->ZD3_SEQ)   
   cEstCoMs := Iif(cEstCome == 'A', 'Aprobada', 'Rechazada')
EndIf

cQuery := "SELECT * FROM (" 
cQuery += "SELECT ZD4_SEQ, R_E_C_N_O_ AS NUMREG " 
cQuery += "FROM " + RetSqlName("ZD4") + " A " 
cQuery += "WHERE ZD4_FILIAL = '" + xFilial("ZD4") + "' "
cQuery += "AND ZD4_NUMSOL = '" + ZD1->ZD1_NUMSOL + "' "
cQuery += "AND D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY 1 DESC) "
cQuery += "WHERE ROWNUM = 1 "

DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cQryTrb, .F., .T.)
DbSelectArea(cQryTrb)
DbGoTop()

If !Eof()
   DbSelectArea("ZD4")
   DbGoto((cQryTrb)->NUMREG)

   cUsrObse := UsrFullName(ZD4->ZD4_USUARI)
   cFecObse := ZD4->ZD4_FECHA
   cSecObse := ZD4->ZD4_SEC
   cObsObse := ZD4->ZD4_OBS
   cSeqObs  := ZD4->ZD4_SEQ   
EndIf

(cQryTrb)->(DbCloseArea())
Return()


//===================================================================================================================================
/*/{Protheus.doc} AtuPie
   (long_description)
   @type  Static Function
   @author Angeloff Cesar
   @since 19/03/2021
   @version version
   /*/
//===================================================================================================================================
Static Function AtuPie()
oView := FWViewActive()
oView:Refresh("APROBACIONES")

Return()


//===================================================================================================================================
/*/{Protheus.doc} MsgInfoBr
    Muestra un aviso en pantalla de los productos que no tienen suficiente stock contable. Solo informativo.

    @type  User Function
    @author Alejandro Perret
    @since 17/06/2020
    @version 1.0
/*/
//===================================================================================================================================

Static Function MsgInfoBr(cTit, cMsgTop, aCab, aIt, cMsgBot, aBotones, nAncho, nAlto, lAprobac)

Local lRet			:= .F.
Local aCoordAdms 	:= MsAdvSize(.F.)  // Coordenadas de pantalla | Va antes de obtener pq unifica entre la primera y las siguientes veces.
Local nAnchoWnd 	:= aCoordAdms[3] 
Local nAltoWnd 	:= aCoordAdms[4] 
Local nC			   := 0
Local aCol			:= {}
Local aAux			:= {}
Local oFont       := TFont():New('Arial',,-11,.T.,.T.)
Local bStatus     := {|oBr01| Iif(SubStr(oBr01:oData:aArray[oBr01:nAt][5], 1, 1) == 'A', 'OK', 'CANCEL')}
Local oDlg, oBtnCancelar, oSayTop, oMainPanel, oBr01, oGetUsrF

Default cTit 	   := ""
Default cMsgTop	:= ""
Default aCab	   := {}
Default aIt		   := {}
Default cMsgBot	:= ""					
Default aBotones  := {}					
Default nAncho	   := aCoordAdms[3]  		// Si no se pasa nada ocupa todo el espacio, si se pasa un valor ocupa eso, si se pasa entre 0 y 1 toma como porcentaje del espacio
Default nAlto	   := aCoordAdms[4]  		// Si no se pasa nada ocupa todo el espacio, si se pasa un valor ocupa eso, si se pasa entre 0 y 1 toma como porcentaje del espacio
Default lAprobac  := .T.

If !lAprobac
   bStatus := {|| 'BMPVISUAL'}
EndIf

If Empty(aIt)  
   AEval(aCab, {|x| Aadd(aAux, Iif(x[2] == 'N', 0, Iif(x[2] == 'D', CToD("  /  /  "), ""))) })  // Inicializa valores en caso de que el array esté vacío
   Aadd(aIt, aAux)
   bStatus := {|| ''}
EndIf

nAnchoWnd := Iif(0 < nAncho .And. nAncho < 1, nAnchoWnd * nAncho, nAncho)
nAltoWnd  := Iif(0 < nAlto .And. nAlto < 1, nAltoWnd * nAlto, nAlto)

DEFINE MSDIALOG oDlg TITLE cTit FROM 0,0 TO nAltoWnd*2,nAnchoWnd*2 PIXEL

	@010, 008 SAY oSayTop PROMPT cMsgTop SIZE nAnchoWnd-12,024 PIXEL OF oDlg //FONT oFont COLOR CLR_RED
	@030, 006 MsPanel oMainPanel Size nAnchoWnd-10, nAltoWnd-068 COLORS CLR_WHITE,RGB(234,241,246) OF oDlg
   
   //Solicitud
   @004, 006 SAY oSayTop PROMPT "Solicitud" SIZE 025, 007 PIXEL OF oDlg FONT oFont COLORS 0, 16777215 PIXEL 
   @012, 006 MSGET oGetUsrF VAR ZD1->ZD1_NUMSOL SIZE 30,010 When .F. PIXEL OF oDlg

   //Cliente
   @004, 050 SAY oSayTop PROMPT "Cliente" SIZE 025, 007 PIXEL OF oDlg FONT oFont COLORS 0, 16777215 PIXEL 
   @012, 050 MSGET oGetUsrF VAR ZD1->ZD1_CLIENT SIZE 30,010 When .F. PIXEL OF oDlg
	
   //Tienda
   @004, 094 SAY oSayTop PROMPT "Tienda" SIZE 025, 007 PIXEL OF oDlg FONT oFont COLORS 0, 16777215 PIXEL 
   @012, 094 MSGET oGetUsrF VAR ZD1->ZD1_LOJA SIZE 10,010 When .F. PIXEL OF oDlg

   //Razón Social
   @004, 130 SAY oSayTop PROMPT "Razón Social" SIZE 050, 007 PIXEL OF oDlg FONT oFont COLORS 0, 16777215 PIXEL 
   @012, 130 MSGET oGetUsrF VAR Posicione("SA1", 1, xFilial("SA1") + ZD1->ZD1_CLIENT + ZD1_LOJA, "A1_NOME") SIZE 200,010 When .F. PIXEL OF oDlg


   DEFINE FWBROWSE oBr01 DATA ARRAY ARRAY aIt NO LOCATE NO CONFIG NO REPORT OF oMainPanel
		oBr01:nRowHeight := 30//22
      oBr01:AddStatusColumns(bStatus)
      oBr01:SetDoubleClick({|| VerRegistro(oBr01, lAprobac)})

		For nC := 1 To Len(aCab)
         aCol := {	aCab[nC][1],;		// Título da coluna
            &("{|| aIt[oBr01:nAt,"+CValToChar(nC)+"]}"),;// Code-Block de carga dos da
            aCab[nC][2],;        // Tipo de dados
            aCab[nC][3],;        // Máscara
            aCab[nC][4],;        // Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
            aCab[nC][5]*0.5,;    // Tamanho
            aCab[nC][6],;        // Decimal
            aCab[nC][7];         // Indica se permite a edição 
         }

         oBr01:AddColumn(aCol)
		Next	

	ACTIVATE FWBROWSE oBr01

	@ nAltoWnd-26, nAnchoWnd-135 BUTTON oBtnCancelar PROMPT "&Visualizar" SIZE 60,16 ACTION(lRet := .F., VerRegistro(oBr01, lAprobac)) PIXEL OF oDlg
	@ nAltoWnd-26, nAnchoWnd-065 BUTTON oBtnCancelar PROMPT "&Cerrar" 	 SIZE 60,16 ACTION(lRet := .F., oDlg:End()) 	PIXEL OF oDlg

	oDlg:lEscClose	   := .T. // permite sair ao se pressionar a tecla ESC.
	oDlg:LCENTERED 	:= .T.

ACTIVATE MSDIALOG oDlg CENTERED 

Return()


//===================================================================================================================================
/*/{Protheus.doc} AtuFiltro
   Actualiza el filtro según la opción seleccionada
   Llamar; AtuFiltro(oBr01, @aIt, aTodos, aLinIni))
   
   @type    Static Function
   @author  Alejandro Perret
   @since   31/03/21
   @version 1.0
/*/
//===================================================================================================================================

Static Function AtuFiltro(oBr01, aIt, aTodos, aLinIni)
Local nF          := 0
Local cFilNivel   := "Finanzas"// "Comercial"

If cFilNivel == "Todos"
   aIt := AClone(aTodos)
Else
   aIt := {}
   For nF := 1 To Len(aTodos)
      If aTodos[nF][4] == cFilNivel
         Aadd(aIt, aTodos[nF])
      EndIf
   Next
   If Empty(aIt)
      aIt := AClone(aLinIni)
   EndIf
EndIf

oBr01:SetArray(aIt)
oBr01:Refresh(.T.)

Return()


//===================================================================================================================================
/*/{Protheus.doc} TestC
   Descripción
   
   @type    Static Function
   @author  Alejandro Perret
   @since   28/03/21
   @version 1.0
/*/
//===================================================================================================================================

Static Function VerRegistro(oBr01, lAprobac)
Local aArea    := GetArea()
Local aAreaZD3 := ZD3->(GetArea())
Local aAreaZD4 := ZD4->(GetArea())
Local cTitulo  := "Visualizar registro"

If !Empty(oBr01:oData:aArray)
   If lAprobac
      If Len(oBr01:oData:aArray[oBr01:nAt]) >= 7
         ZD3->(DbGoto(oBr01:oData:aArray[oBr01:nAt][7]))
         ModalVis(cTitulo, UsrFullName(ZD3->ZD3_USUARI), DToC(ZD3->ZD3_FECHA), ZD3->ZD3_OBS, ZD3->ZD3_ESTADO)
      EndIf
   Else
      If Len(oBr01:oData:aArray[oBr01:nAt]) >= 5
         ZD4->(DbGoto(oBr01:oData:aArray[oBr01:nAt][5]))
         ModalVis(cTitulo, UsrFullName(ZD4->ZD4_USUARI), DToC(ZD4->ZD4_FECHA), ZD4->ZD4_OBS)
      EndIf
   EndIf
EndIf

RestArea(aAreaZD4)
RestArea(aAreaZD3)
RestArea(aArea)
Return()


//===================================================================================================================================

/*/{Protheus.doc} ActApro
   función para precargar y visualizar la informacion de aprobaciones/observ anteriores
   @type  Static Function
   @author msiga
   @since 19/03/2021
   /*/
//===================================================================================================================================
Static Function ActApro()   

Local cQuery   := ""
Local cQryTrb  := GetNextAlias()
Local cEstFina := ""
Local cEstCome := ""
Local cEstDev  := "Q"
Local oModel   := FWModelActive()
Local oView    := FWViewActive()
Local nNumReg  := 0

nNumReg := UltAprob('F')

If !Empty(nNumReg)
   ZD3->(DbGoto(nNumReg))
   cEstFina := ZD3->ZD3_ESTADO
EndIf

nNumReg := UltAprob('C')

If !Empty(nNumReg)
   ZD3->(DbGoto(nNumReg))
   cEstCome := ZD3->ZD3_ESTADO  
EndIf

If cEstFina == "R" .Or. cEstCome == "R"
   cEstDev := "R"
ElseIf cEstFina == "A" .And. cEstCome == "A"
   cEstDev := "A"
EndIf

RecLock("ZD1", .F.)
   ZD1_ESTADO := cEstDev
MsUnlock()

oModel:LoadValue("ZD1MASTER", "ZD1_ESTADO", cEstDev)
oView:Refresh() 
Return()

//===================================================================================================================================
/*/{Protheus.doc} UltAprob
   Obtiene el último numero de registro de aprobación del nivel (Finanzas o Comercial)

   @type  Static Function
   @author Angeloff Cesar
   @since 23/03/2021
   @version 1.0
   /*/
//===================================================================================================================================
Static Function UltAprob(cNivel)
Local aArea    := GetArea()
Local cQryTrb  := GetNextAlias()
Local cQuery   := ""
Local nRet     := 0   

cQuery := "SELECT * FROM ("
cQuery += "SELECT ZD3_SEQ, R_E_C_N_O_ AS NUMREG " 
cQuery += "FROM " + RetSqlName("ZD3") + " A " 
cQuery += "WHERE ZD3_FILIAL = '" + xFilial("ZD3") + "' "
cQuery += "AND ZD3_NUMSOL = '" + ZD1->ZD1_NUMSOL + "' "
cQuery += "AND ZD3_NIVEL = '" + cNivel + "' "
cQuery += "AND D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY 1 DESC) "
cQuery += "WHERE ROWNUM = 1 "

DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cQryTrb, .F., .T.)
DbSelectArea(cQryTrb)
DbGoTop()
If !Eof()
   nRet := NUMREG
EndIf 

(cQryTrb)->(DbCloseArea())
RestArea(aArea)
Return(nRet)


//===================================================================================================================================
/*/{Protheus.doc} UltimaSeq
   Devuelve la última secuencia grabada en la tabla
   
   @type    Static Function
   @author  Alejandro Perret
   @since   26/03/21
   @version 1.0
/*/
//===================================================================================================================================

Static Function UltimaSeq(cAlias)
Local aArea	   := GetArea()
Local cQryTrb 	:= GetNextAlias()
Local cQry1 	:= ""
Local cRet     := StrZero(0, _nTamSeq)

cQry1 := "SELECT * FROM ("
cQry1 += "SELECT " + cAlias + "_SEQ AS ULT_SEQ " 
cQry1 += "FROM " + RetSqlName(cAlias) + " A " 
cQry1 += "WHERE " + cAlias + "_FILIAL = '" + xFilial(cAlias) + "' "
cQry1 += "AND " + cAlias + "_NUMSOL = '" + ZD1->ZD1_NUMSOL + "' "
cQry1 += "AND A.D_E_L_E_T_ = ' ' "
cQry1 += "ORDER BY 1 DESC) "
cQry1 += "WHERE ROWNUM = 1 "

DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry1), cQryTrb, .F., .T.)

DbSelectArea(cQryTrb)
DbGoTop()

If !Eof()
	cRet := ULT_SEQ
EndIf

(cQryTrb)->(DbCloseArea())
RestArea(aArea)
Return(cRet)


//===================================================================================================================================
/*/{Protheus.doc} STACO30C
   Pantalla para visualizar y vincular Solicitudes de devolución en la NCC
   
   @type    User Function
   @author  Alejandro Perret
   @since   29/03/21
   @version 1.0
/*/
//===================================================================================================================================

User Function STACO30C()

Local oMS 	
Local cTit			:= "Consulta de Solicitudes de devolución"
Local cQry1 		:= ""
Local lMark2		:= .F.
Local cCampoRet	:= "ZD1_NUMSOL"
Local nAncho		:= 550
Local nAlto			:= 600
Local lUnoSolo		:= .T.
Local aCposDev		:= {} 
Local aIndBusq		:= {} //El primer 'indice' ordena los resultados al inicio
Local nScrollTp	:= 0
Local aEstruEsp	:= {}
Local aSolicitud	:= {}

Private _cTESImp:= ""

If ValidIni()

   cQry1 := "SELECT ZD1_NUMSOL, ZD1_CLIENT, ZD1_FECHA, ZD1_SERORI , ZD1_FACORI  " 
   cQry1 += "FROM " + RetSqlName("ZD1") + " "
   cQry1 += "WHERE ZD1_FILIAL = '" + xFilial("ZD1") + "' "
   cQry1 += "AND ZD1_ESTADO = 'A' "
   cQry1 += "AND ZD1_CLIENT = '" + M->F1_FORNECE + "' "
   cQry1 += "AND ZD1_LOJA = '" + M->F1_LOJA + "' "
   cQry1 += "AND D_E_L_E_T_ = ' ' "

	oMS := MultiSel():New(cTit,cQry1,lMark2,cCampoRet,nAlto,nAncho,,,lUnoSolo, aCposDev, aIndBusq, nScrollTp, aEstruEsp)
	aSolicitud := oMS:Show() 

	If !Empty(aSolicitud) 
		Processa({|| CargaItems(aSolicitud)}, "Aguarde por favor", "Cargando ítems...", .F.)
	EndIf

EndIf

Return()


//===================================================================================================================================
/*/{Protheus.doc} ValidIni
    Validaciones iniciales.

    @type  Static Function
    @author Alejandro Perret
    @since 22/01/2020
    @version 1.0
/*/
//===================================================================================================================================

Static Function ValidIni()
Local lRet 		:= .T.
Local cMsgCli	:= "Informe Cliente y Tienda para poder continuar."

If Empty(M->F1_FORNECE) .Or. Empty(M->F1_LOJA)
	lRet := .F.
	MsgInfo(cMsgCli)
EndIf

Return(lRet)


//===================================================================================================================================
/*/{Protheus.doc} CargaItems
    Carga los items en el documento.

    @type  Static Function
    @author Alejandro Perret
    @since 22/01/2020
    @version 1.0
/*/
//===================================================================================================================================

Static Function CargaItems(aSolDev)
Local aArea		:= GetArea()
Local aAreaSF4	:= SF4->(GetArea())
Local cQryTrb 	:= GetNextAlias()
Local cQry1 	:= ""
Local nTot		:= 0
Local cLotes	:= ""
Local cFilSF4	:= xFilial("SF4")
Local aLinTemp	:= {}
Local cItem		:= ""
Local cCF		:= ""
Local aItIni	:= {}
Local cTesEnt	:= ""

Default aSolDev := {}

DbSelectArea("ZD2")
DbSetOrder(1)

cQry1 := "SELECT ZD2_NUMSOL, ZD2_PRODUC, ZD2_ITEM ,  ZD2_QUANT, ZD2_PRCUNI, ZD2_TOTAL, ZD2_LOCAL, ZD2_TES, B1_SEGUM , B1_DESC, B1_UM , B1_CONTA "	
cQry1 += "FROM " + RetSqlName("ZD2") + " ZD2 " 
cQry1 += "	INNER JOIN " + RetSqlName("SB1") + " B1 ON ZD2_PRODUC = B1_COD "
cQry1 += "WHERE ZD2_FILIAL = '" + xFilial("ZD2") + "' "
cQry1 += "AND B1_FILIAL = '" + xFilial("SB1") + "' "
cQry1 += "AND ZD2_NUMSOL = " + aSolDev[1][1] + " "
cQry1 += "AND ZD2.D_E_L_E_T_ = ' ' "
cQry1 += "AND B1.D_E_L_E_T_ = ' ' "
cQry1 += "ORDER BY ZD2_ITEM, ZD2_PRODUC "  

DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry1), cQryTrb, .F., .T.)

DbSelectArea(cQryTrb)
Count To nTot
ProcRegua(nTot)  
DbGoTop()

If !(cQryTrb)->(Eof())

   cItem := StrZero(0, TamSx3('D1_ITEM')[1])
   nHItem	:= GdFieldPos("D1_ITEM")			
   nHProd   := GdFieldPos("D1_COD")			
   nHDscr   := GdFieldPos("D1_XDESCRI")   
   nHUniM   := GdFieldPos("D1_UM")        
   nHSeUM   := GdFieldPos("D1_SEGUM")     
   nHCant   := GdFieldPos("D1_QUANT")
   nHPrec   := GdFieldPos("D1_VUNIT")
   nHTot_   := GdFieldPos("D1_TOTAL")
   nHTES_   := GdFieldPos("D1_TES")
   nHCF__   := GdFieldPos("D1_CF")
   nHLoca	:= GdFieldPos("D1_LOCAL")			
   nPrEnt   := GdFieldPos("D1_PROVENT")
   nHCtac	:= GdFieldPos("D1_CONTA")	
   nHNSol	:= GdFieldPos("D1_XNUMSOL")	
   nHISol	:= GdFieldPos("D1_ITEMSOL")	                
   
   aCols := {}
   oGetDados:Enable()  // Vuelve a habilitar la grilla para poder agregar los ítems de la Solicitud.
   oGetDados:AddLine(.F., .F.)
   aItIni := AClone(aCols[1])
   aCols := {}
   oGetDados:obrowse:refresh()
   MaFisClear()
      
   While !(cQryTrb)->(Eof())
      
      cTesEnt := (cQryTrb)->ZD2_TES
      SF4->(DbSeek(cFilSF4 + cTesEnt))
      cCF := SF4->F4_CF   
      
      cItem := Soma1(cItem)
      aLinTemp := AClone(aItIni)
         
      Iif(nHItem > 0, aLinTemp[nHItem] := cItem								   ,)
      Iif(nHProd > 0, aLinTemp[nHProd] := (cQryTrb)->ZD2_PRODUC			,)
      Iif(nHSeUM > 0, aLinTemp[nHSeUM] := (cQryTrb)->B1_SEGUM				,) 
      Iif(nHDscr > 0, aLinTemp[nHDscr] := (cQryTrb)->B1_DESC				,)
      Iif(nHUniM > 0, aLinTemp[nHUniM] := (cQryTrb)->B1_UM					,)
      Iif(nHCant > 0, aLinTemp[nHCant] := (cQryTrb)->ZD2_QUANT				,)
      Iif(nHPrec > 0, aLinTemp[nHPrec] := (cQryTrb)->ZD2_PRCUNI			,) 
      Iif(nHTot_ > 0, aLinTemp[nHTot_] := (cQryTrb)->ZD2_TOTAL				,)
      Iif(nHTES_ > 0, aLinTemp[nHTES_] := cTesEnt				            ,)
      Iif(nHCF__ > 0, aLinTemp[nHCF__] := cCF									,)
      Iif(nHLoca > 0, aLinTemp[nHLoca] := (cQryTrb)->ZD2_LOCAL				,)
      Iif(nPrEnt > 0, aLinTemp[nPrEnt] := M->F1_PROVENT         			,) 
      Iif(nHCtac > 0, aLinTemp[nHCtac] := (cQryTrb)->B1_CONTA				,)
      Iif(nHNSol > 0, aLinTemp[nHNSol] := (cQryTrb)->ZD2_NUMSOL			,) 
      Iif(nHISol > 0, aLinTemp[nHISol] := (cQryTrb)->ZD2_ITEM				,)
       
      Aadd(aCols, aLinTemp)
      MaColsToFis(aHeader,aCols,Len(aCols),"MT100",.T.)
      
      IncProc()
      (cQryTrb)->(DbSkip())
   EndDo
   //MaColsToFis(aHeader,aCols,,"MT100",.T.)
   
   Eval(bDoRefresh) //Atualiza o folder financeiro.
   Eval(bListRefresh)
   ModxAtuObj()
   
   oGetDados:obrowse:nAt := 1
   oGetDados:obrowse:refresh()
   oGetDados:Refresh()
   AtuLoadQt(.T.)
   oGetDados:Disable()  // Deshabilita la grilla para impedir que se modifiquen o agreguen ítems luego de vinculada con una Solicitud.
   
Else	
   MsgInfo("No se encontraron items para la solicitud seleccionada.")
EndIf

(cQryTrb)->(DbCloseArea())
RestArea(aAreaSF4)
RestArea(aArea)
Return()


//===================================================================================================================================
/*/{Protheus.doc} STACO30R
   Elimina los items de la grilla al cargar un nuevo cliente en la NCC si esta tenía ítems relacionados a una solicitud de devolución 
   de un cliente que no es el actual. También habilita la grilla en estos casos, porque podria haberse deshabilitado al vincular una 
   devolución. 
   (ejecutada desde gatillos en F1_FORNECE Y F1_LOJA)
   
   @type    User Function
   @author  Alejandro Perret
   @since   30/03/21
   @version 1.0
/*/
//===================================================================================================================================

User Function STACO30R()
Local nIt      := 0
Local nPosNSol := 0
Local cCli     := ""
Local cLoj     := ""
		
If (aCfgNF[SnTipo] == 4) .And. !Empty(M->F1_FORNECE) .And. !Empty(M->F1_LOJA) // Nota de crédito cliente (NCC)
   nPosNSol := GdFieldPos("D1_XNUMSOL")

   For nIt := 1 To Len(aCols)
      If !Empty(aCols[nIt][nPosNSol])
         cCli := Posicione("ZD1", 1, xFilial("ZD1") + aCols[nIt][nPosNSol], "ZD1_CLIENT")
         cLoj := Posicione("ZD1", 1, xFilial("ZD1") + aCols[nIt][nPosNSol], "ZD1_LOJA")
         If (M->F1_FORNECE <> cCli) .Or. (M->F1_LOJA <> cLoj)
            aCols := {}
            oGetDados:Enable()   
		      oGetDados:AddLine(.F., .F.)
            oGetDados:oBrowse:Refresh()
            MaFisClear()
         EndIf
         Exit
      EndIf
   Next
EndIf

Return()

//===================================================================================================================================
/*/{Protheus.doc} STACO30D
   Actualiza el estado de la solicitud de devolución vinculada a la NCC.
   Usada en LOCXPE08 Y LOCXPE29.
   
   @type    User Function
   @author  Alejandro Perret
   @since   02/04/21
   @version 1.0
/*/
//===================================================================================================================================

User Function STACO30D(cEstado, cSerie, cDoc)
Local nS       := 0
Local nPosNSol := 0

Default cSerie  := ""
Default cDoc    := ""

nPosNSol := GdFieldPos("D1_XNUMSOL")
For nS := 1 To Len(aCols)
   If !GdDeleted(nS) .And. !Empty(aCols[nS][nPosNSol])
      DbSelectArea("ZD1")
      DbSetOrder(1) // ZD1_FILIAL + ZD1_NUMSOL
      If DbSeek(xFilial("ZD1") + aCols[nS][nPosNSol])
         Reclock("ZD1", .F.)
            ZD1_ESTADO := cEstado
            ZD1_NCCSER := cSerie
            ZD1_NCCNUM := cDoc
         MsUnlock()
         Exit
      EndIf
   EndIf
Next

Return()


//===================================================================================================================================
/*/{Protheus.doc} STACO30E
   Antes de grabar la NCC valida que la solicitud de devolucíon no haya cambiado de estado (concurrencia).
   Usada en LOCXPE16.
   
   @type    User Function
   @author  Alejandro Perret
   @since   02/04/21
   @version 1.0
/*/
//===================================================================================================================================

User Function STACO30E()
Local nS       := 0
Local nPosNSol := 0
Local lRet     := .T.
 
nPosNSol := GdFieldPos("D1_XNUMSOL")
For nS := 1 To Len(aCols)
   If !GdDeleted(nS) .And. !Empty(aCols[nS][nPosNSol])
      DbSelectArea("ZD1")
      DbSetOrder(1) // ZD1_FILIAL + ZD1_NUMSOL
      If DbSeek(xFilial("ZD1") + aCols[nS][nPosNSol]) .And. ZD1_ESTADO != 'A'
         lRet := .F.
			Help(NIL, NIL, "Solicitud no aprobada", NIL,; 
            "La Solicitud de Devolución número: '" + aCols[nS][nPosNSol] + "' vinculada en los ítems de este documento " + ; 
            "ha cambiado de estado. Actualmente se encuentra en estado: '" + ZD1_ESTADO + "'." + CRLF + ;
            "No se permite grabar Notas de Crédito vinculadas a Solicitudes de Devolución con estado distinto de 'A - Aprobada'." ,;
			   1, 0, , , , , , {"Verifique que la Solicitud de devolución que intenta asociar esté 'Aprobada' o seleccione una Solicitud diferente para poder grabar el documento."})
         Exit
      EndIf
   EndIf
Next

Return(lRet)


/*/{Protheus.doc} User Function STACO30F
   Disparador de la fecha de la factura de origen, en caso de que la solicitud de la devolucion este asociada a una.

   @type  Function
   @author user
   @since 15/04/2021
   @version 1.0
   /*/

User Function STACO30F()

Local dRet := CToD("  /  /  ")

If !Empty(ZD1->ZD1_FACORI)
   dRet := Posicione("SF2", 2, xFilial("SF2") + ZD1->ZD1_CLIENT + ZD1->ZD1_LOJA + PadR(ZD1->ZD1_FACORI, _nTamFac) + ZD1_SERORI + 'N' + 'NF   ', "F2_EMISSAO")
EndIf

Return(dRet)


