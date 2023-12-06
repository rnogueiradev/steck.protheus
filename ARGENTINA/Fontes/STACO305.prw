#INCLUDE 'PROTHEUS.CH'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "Ap5Mail.ch"

#DEFINE	CRLF_HTML		"<br>"

/*/{Protheus.doc} User Function STACO305
    Funcion encargada de realizar las aprobaciones o rechazos de cada sector. 
    @type  Function
    @author user
    @since 27/04/2021
    @version version
/*/
User Function STACO305(lAprob)

Local cTitAcc := "Aprobar"
Local lOk     := .T.
Local lRechaz := .F.

Default lAprob := .F.

Private _lEnviarMail := GetMV("ST_ACMAIL", , .F.)   // Parámetro para habilitar/deshabilitar el envío del e-mail al realizar la aprobación total (alta) de un cliente.
Private _cSector     := Posicione("SZM", 2, xFilial("SZM") + __CuserID, "ZM_SECTOR")

If !lAprob
    lRechaz := .T.
    cTitAcc := "Rechazar"
EndIf

If (SA1->A1_MSBLQL == '1')
    
    If (_cSector $ "FIN/FIS/COM")
        Do Case
            Case _cSector == "FIN"
                If !Empty(SA1->A1_XFINAPR) .And. SA1->A1_XFINEST == "1" .And. lAprob
                    lOk:=.F.
                    MsgInfo("Usted pertenece al sector FINANZAS, ya se ha realizado la aprobación.")
                ElseIf !Empty(SA1->A1_XFINAPR) .And. SA1->A1_XFINEST == "2" .And. lRechaz
                    lOk:=.F.
                    MsgInfo("Usted pertenece al sector FINANZAS, ya se ha realizado el rechazo, intente realizar una aprobación.")
                EndIf
            Case _cSector == "FIS"
                If !Empty(SA1->A1_XFISAPR) .And. SA1->A1_XFISEST == "1" .And. lAprob
                    lOk:=.F.
                    MsgInfo("Usted pertenece al sector FISCAL, ya se ha realizado la aprobación.")
                ElseIf !Empty(SA1->A1_XFISAPR) .And. SA1->A1_XFISEST == "2" .And. lRechaz
                    lOk:=.F.
                    MsgInfo("Usted pertenece al sector FISCAL, ya se ha realizado el rechazo, intente realizar una aprobación.")
                EndIf
            Case _cSector == "COM"
                If !Empty(SA1->A1_XCOMAPR) .And. SA1->A1_XCOMEST == "1"  .And. lAprob 
                    lOk:=.F.
                    MsgInfo("Usted pertenece al sector COMERCIAL, ya se ha realizado la aprobación.")
                ElseIf !Empty(SA1->A1_XCOMAPR) .And. SA1->A1_XCOMEST == "2"  .And. lRechaz
                    lOk:=.F.
                    MsgInfo("Usted pertenece al sector COMERCIAL, ya se ha realizado el rechazo, intente realizar una aprobación.") 
                EndIf
        EndCase

        If lOk
            ModalObs(lAprob,lRechaz,cTitAcc, oMainWnd:nClientHeight)
        EndIf
    Else
        MsgInfo("El usuario logueado no pertenece a los sectores aprobados para realizar aprobaciones o rechazos."+;
        CRLF+"Comuniquese con el supervisor.")
    EndIf

Else
    MsgInfo("No se puede aprobar ni rechazar un cliente que ya esta activo.")
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
Static Function ModalObs(lAp,lRec,cAccion,nAltoRes)
Local oModal
Local oContainer
Local cTexto1   := ""
Local cUser     := UsrFullName(__CuserID)
Local cHora     := CValToChar(TIME())
Local lGraba    := .F.
Local oFont     := TFont():New('Arial',,-12,.T.,.T.)
Local cSector   := "" // Buscar el Nombre del sector que corresponde //
Local cString   := ""
Local cString2  := ""
Local nMargY    := 0
Local nMargx    := 10
Local nAuxY     := 0 

If lAp
    cString  := "Aprobación"
    cString2 := "de la Aprobación"
ElseIf lRec
    cString := "Rechazo"
    cString2:= "del Rechazo"
EndIf

If nAltoRes < 700 
    nMargY:= 10
    nAuxY := 30
ElseIf nAltoRes < 900 .And. nAltoRes >700
    nMargY:= 5
    nAuxY := 20
EndIf

Do Case
    Case _cSector == "FIN"
        cSector := "FINANZAS"
    Case _cSector == "FIS"
        cSector := "FISCAL"
    Case _cSector == "COM"
        cSector := "COMERCIAL"
EndCase
 
oModal  := FWDialogModal():New()       
oModal:SetEscClose(.T.)
oModal:setTitle("Aprobaciones - " + cAccion)

oModal:setSize(335-nAuxY-nMargY, 410)
oModal:createDialog()
oModal:AddButtons({{"", cAccion,  {|| lGraba := MsgNoYes(cAccion ,"Confirme..."), Iif(lGraba, oModal:OOWNER:END(), )}, "", 0, .T., .F.}})
oModal:AddButtons({{"", "Ver Hist. Aprobaciones",  {|| U_STCO305H()}, "", 0, .T., .F.}})
oModal:AddButtons({{"", "Cancelar", {||Iif(Empty(cTexto1), oModal:OOWNER:END(), Iif(MsgNoYes("Desea descartar los cambios?" ,"Confirme..."), oModal:OOWNER:END(),))} , "", 0, .T., .F.}})


oContainer := TPanel():New( ,,, oModal:getPanelMain() )
oContainer:Align := CONTROL_ALIGN_ALLCLIENT

nMargY:= 5

TSay():New(12,10,{|| "Cliente "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 20,10,{||SA1->A1_COD},oContainer,100,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,SA1->A1_COD,,,, )//primer linea

TSay():New(12,120,{|| "Tienda "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 20,120,{||SA1->A1_LOJA},oContainer,035,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,SA1->A1_LOJA,,,, )//primer linea

TSay():New(12,165,{|| "Razón Social "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 20,165,{||SA1->A1_NOME},oContainer,230,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,SA1->A1_NOME,,,, ) //primer linea
//---------------------------------------------------------------------------------------------------------------
@040,010 TO 115,400 LABEL "Estado Actual" OF oContainer PIXEL 
//---------------------------------------------------------------------------------------------------------------
TSay():New(46+nMargy,10+nMargx,{|| "Sector "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 54+nMargy,10+nMargx,{||"FINANZAS"},oContainer,60,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,"FINANZAS",,,, )//segunda linea

TSay():New(46+nMargy,80+nMargx,{|| "Estado "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 54+nMargy,80+nMargx,{||Iif(SA1->A1_XFINEST == '1', 'Aprobada',Iif(SA1->A1_XFINEST == '2', 'Rechazado','Pendiente' )) },oContainer,60,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,SA1->A1_XFINEST,,,, )

TSay():New(46+nMargy,150+nMargx,{|| "Usuario "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 54+nMargy,150+nMargx,{||UsrFullName(SA1->A1_XFINAPR)},oContainer,100,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,UsrFullName(SA1->A1_XFINAPR),,,, )

TSay():New(46+nMargy,260+nMargx,{|| "Fecha "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 54+nMargy,260+nMargx,{||DToC(SA1->A1_XFINFEC)},oContainer,40,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,DToC(SA1->A1_XFINFEC),,,, )

TSay():New(46+nMargy,310+nMargx,{|| "Hora "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 54+nMargy,310+nMargx,{||SA1->A1_XFINHOR},oContainer,035,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,SA1->A1_XFINHOR,,,, )

//----------------------------------------------------------------------------------------------------------------
TGet():New( 70+nMargy,10+nMargx,{||"COMERCIAL"},oContainer,60,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,cSector,,,, )//tercer linea

TGet():New( 70+nMargy,80+nMargx,{||Iif(SA1->A1_XCOMEST == '1', 'Aprobada', Iif(SA1->A1_XCOMEST == '2', 'Rechazado','Pendiente' ) )},oContainer,60,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,SA1->A1_XCOMEST,,,, )

TGet():New( 70+nMargy,150+nMargx,{||UsrFullName(SA1->A1_XCOMAPR)},oContainer,100,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,UsrFullName(SA1->A1_XCOMAPR),,,, )

TGet():New( 70+nMargy,260+nMargx,{||DToC(SA1->A1_XCOMFEC)},oContainer,40,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,DToC(SA1->A1_XCOMFEC),,,, )

TGet():New( 70+nMargy,310+nMargx,{||SA1->A1_XCOMHOR},oContainer,035,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,SA1->A1_XCOMHOR,,,, )

//---------------------------------------------------------------------------------------------------------------
TGet():New( 86+nMargy,10+nMargx,{||"FISCAL"},oContainer,60,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,"FISCAL",,,, )//cuarta linea

TGet():New( 86+nMargy,80+nMargx,{||Iif(SA1->A1_XFISEST == '1', 'Aprobada', Iif(SA1->A1_XFISEST == '2', 'Rechazado','Pendiente' ) )},oContainer,60,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,SA1->A1_XFISEST,,,, )

TGet():New( 86+nMargy,150+nMargx,{||UsrFullName(SA1->A1_XFISAPR)},oContainer,100,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,UsrFullName(SA1->A1_XFISAPR),,,, )

TGet():New( 86+nMargy,260+nMargx,{||DToC(SA1->A1_XFISFEC)},oContainer,40,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,DToC(SA1->A1_XFISFEC),,,, )

TGet():New( 86+nMargy,310+nMargx,{||SA1->A1_XFISHOR},oContainer,035,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,SA1->A1_XFISHOR,,,, )

//---------------------------------------------------------------------------------------------------------------
nMargY := 15
@104+nMargY,010 TO 155,400 LABEL "Acción:" OF oContainer PIXEL

TSay():New(112+nMargY,10+nMargx,{|| "Sector "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 120+nMargY,10+nMargx,{||cSector},oContainer,60,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,cSector,,,, )

TSay():New(112+nMargY,80+nMargx,{|| "Usuario "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 120+nMargY,80+nMargx,{||cUser},oContainer,100,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,cUser,,,, )

TSay():New(112+nMargY,190+nMargx,{|| "ACCION "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 120+nMargY,190+nMargx,{||cString},oContainer,60,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,cString,,,, )
//---------------------------------------------------------------------------------------------------------------

TSay():New(160,10,{|| "Observaciones " + cString2},oContainer,,oFont,,,,.T.,,,140,20,,,,,,.T.)
tMultiget():new( 170, 10, {| u | if( pCount() > 0, cTexto1 := u, cTexto1 ) }, ;
oContainer, 390, 100-nAuxY, , , , , , .T., , , , , , , , , , , .T.  )
   
oModal:Activate()

If lGraba
    GrabaAprob(cSector,cHora,cTexto1,lAp,lRec)// Graba las aprobaciones
    MsgInfo("Se ha " + Iif(lAp , 'aprobado', Iif(lRec , 'rechazado','' ) )  + " con éxito ") 
EndIf

Return()

 //==========================================================================//
 
/*/{Protheus.doc} GrabaAprob
    Graba las aprobaciones en la tabla ZDL
    @type  Static Function
    @author Juan Mascotena
    @since 27/04/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

Static Function GrabaAprob(cSector,cHora,cOBS,lAprob,lRech)
Local cEstado := ""
Local aMailDest := {}
Local cAsunto := ""
Local cCuerpo := ""

If lAprob
    cEstado := "1"
ElseIf lRech
    cEstado := "2"
EndIf

Do Case
    Case cSector == "FINANZAS"
        RecLock("SA1", .F.)
            A1_XFINEST := cEstado
            A1_XFINAPR := __CuserID
            A1_XFINFEC := dDatabase
            A1_XFINHOR := cHora
        MsUnlock()

    Case cSector == "FISCAL"
        RecLock("SA1", .F.)
            A1_XFISEST := cEstado
            A1_XFISAPR := __CuserID
            A1_XFISFEC := dDatabase
            A1_XFISHOR := cHora
        MsUnLock()

    Case cSector == "COMERCIAL"
        RecLock("SA1", .F.)
            A1_XCOMEST := cEstado
            A1_XCOMAPR := __CuserID
            A1_XCOMFEC := dDatabase
            A1_XCOMHOR := cHora
        MsUnLock()
        
EndCase

If SA1->A1_XFINEST == '1' .And. SA1->A1_XFISEST == '1' .And. SA1->A1_XCOMEST == '1'
    RecLock("SA1", .F.)
        A1_MSBLQL := '2'
    MsUnLock()

    MsgInfo("El cliente fue aprobado por todos los sectores. El mismo procedera a ser un Cliente Activo.")

    If _lEnviarMail
        Aadd(aMailDest,  UsrRetMail(SA1->A1_XFINAPR))
        Aadd(aMailDest,  UsrRetMail(SA1->A1_XCOMAPR))
        Aadd(aMailDest,  UsrRetMail(SA1->A1_XFISAPR))

        ArmaHtml(@cAsunto,@cCuerpo)
        If EnviarMail(cAsunto, cCuerpo, , aMailDest, , )
            MsgInfo("Se ha enviado un mail notificando la activación del cliente, a todos los usuarios aprobadores.")
        EndIf 
    EndIf
EndIf

RecLock("SZL", .T.)
    ZL_FILIAL   := xFilial("SZL") 
    ZL_CLIENTE  := SA1->A1_COD
    ZL_TIENDA   := SA1->A1_LOJA
    ZL_NOMBRE   := SA1->A1_NOME
    ZL_SECTOR   := cSector
    ZL_USUARIO  := __CuserID
    ZL_STATUS   := cEstado
    ZL_FECHA    := dDatabase
    ZL_HORA     := cHora
    ZL_OBSERV   := cOBS
MsUnlock()

Return ()


/*/{Protheus.doc} User Function STCO305H
    (long_description)
    @type  Function
    @author user
    @since 29/04/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function STCO305H()

Local aCab        :={}
Local aIt         :={}
Local aArea       := GetArea()
Local cEst        := ""
Local cQryTrb     := GetNextAlias()
Local cQry1       := ""
Local lAprob      := .T.
Local cTitle      := "Historial de Aprobaciones"
  
cQry1 := "SELECT ZL_USUARIO AS USUARIO, ZL_TIENDA AS TIENDA, ZL_NOMBRE AS NOMBRE, ZL_SECTOR AS SECTOR, "
cQry1 += "ZL_STATUS AS ESTADO, ZL_FECHA AS FECHA, ZL_HORA AS HORA, "
cQry1 += "UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(ZL_OBSERV, 200,1)) AS OBS, R_E_C_N_O_ AS NUM_REG "  // Oracle
//cQry1 += "CAST(ZL_OBSERV AS VARCHAR(100)) AS OBS, R_E_C_N_O_ AS NUM_REG "   // SQL
cQry1 += "FROM " + RetSqlName("SZL") + " " 
cQry1 += "WHERE ZL_FILIAL = '" + xFilial("SZL") + "' "
cQry1 += "AND ZL_CLIENTE = '" + SA1->A1_COD + "' "
cQry1 += "AND ZL_TIENDA = '" + SA1->A1_LOJA + "' "
cQry1 += "AND D_E_L_E_T_ = ' ' "
cQry1 += "ORDER BY NUM_REG DESC"

DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry1), cQryTrb, .F., .T.)
DbSelectArea(cQryTrb)
DbGoTop()
While !Eof()
    If ESTADO == '1'
        cEst := "APROBADO"
    Else
        cEst := "RECHAZADO"
    EndIf
    Aadd(aIt, {'', SECTOR, cEst, UsrFullName(USUARIO), Stod(FECHA), HORA, OBS, NUM_REG})
    DbSkip()
EndDo

Aadd(aCab,  {"Sector"        ,              'C', "@!"            , 1, 15                       , 0 , .F.})
Aadd(aCab,  {"Estado"        ,              'C', "@!"            , 1, 15                       , 0 , .F.})
Aadd(aCab,  {"Usuario"       ,              'C', "@!"            , 1, 45                       , 0 , .F.})
Aadd(aCab,  {"Fecha"         ,              'D', "@!"            , 1, 12                       , 0 , .F.})
Aadd(aCab,  {"Hora"          ,              'C', "@!"            , 1, 13                       , 0 , .F.})
Aadd(aCab,  {"Observación"   ,              'C', "@!"            , 1, 6                        , 0 , .F.})

If Empty(aIt)
    MsgInfo("No existen registros de Aprobaciones/Rechazos por exhibir.")
else
    MsgInfoBr(cTitle, /*cMsgTop*/, aCab, aIt, /*cMsgBot*/, /*aBotones*/, 0.8, 0.9, lAprob)
EndIf

(cQryTrb)->(DbCloseArea())
RestArea(aArea)
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
Local nAltoWnd 	    := aCoordAdms[4] 
Local nC			:= 0
Local aCol			:= {}
Local aAux			:= {}
Local oFont         := TFont():New('Arial',,-11,.T.,.T.)
Local bStatus       := {|oBr01| Iif(oBr01:oData:aArray[oBr01:nAt][3] == 'APROBADO', 'OK', 'CANCEL')}
Local oDlg, oBtnCancelar, oSayTop, oMainPanel, oBr01, oGetUsrF

Default cTit 	    := ""
Default cMsgTop	    := ""
Default aCab	    := {}
Default aIt		    := {}
Default cMsgBot	    := ""					
Default aBotones    := {}					
Default nAncho	    := aCoordAdms[3]  		// Si no se pasa nada ocupa todo el espacio, si se pasa un valor ocupa eso, si se pasa entre 0 y 1 toma como porcentaje del espacio
Default nAlto	    := aCoordAdms[4]  		// Si no se pasa nada ocupa todo el espacio, si se pasa un valor ocupa eso, si se pasa entre 0 y 1 toma como porcentaje del espacio
Default lAprobac    := .T.

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
   
   //Cliente
   @004, 006 SAY oSayTop PROMPT "Cliente" SIZE 025, 007 PIXEL OF oDlg FONT oFont COLORS 0, 16777215 PIXEL 
   @012, 006 MSGET oGetUsrF VAR SA1->A1_COD SIZE 30,010 When .F. PIXEL OF oDlg

   //Tienda
   @004, 050 SAY oSayTop PROMPT "Tienda" SIZE 025, 007 PIXEL OF oDlg FONT oFont COLORS 0, 16777215 PIXEL 
   @012, 050 MSGET oGetUsrF VAR SA1->A1_LOJA SIZE 30,010 When .F. PIXEL OF oDlg
	
   //Nombre
   @004, 094 SAY oSayTop PROMPT "Razón Social" SIZE 050, 007 PIXEL OF oDlg FONT oFont COLORS 0, 16777215 PIXEL 
   @012, 094 MSGET oGetUsrF VAR Posicione("SA1", 1, xFilial("SA1") + SA1->A1_COD + SA1->A1_LOJA, "A1_NOME") SIZE 180,010 When .F. PIXEL OF oDlg


    DEFINE FWBROWSE oBr01 DATA ARRAY ARRAY aIt NO LOCATE NO CONFIG NO REPORT OF oMainPanel
	    oBr01:nRowHeight := 30//22
      oBr01:AddStatusColumns(bStatus)
      oBr01:SetDoubleClick({|| VerRegistro(oBr01, lAprobac)})

		For nC := 1 To Len(aCab)
         aCol := {	aCab[nC][1],;		// Título da coluna
            &("{|| aIt[oBr01:nAt,"+CValToChar(nC+1)+"]}"),;// Code-Block de carga dos da
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
Local aAreaSZL := SZL->(GetArea())
Local cTitulo  := "Visualizar registro"

Default lAprobac := .T.

If !Empty(oBr01:oData:aArray)
   If lAprobac
      If Len(oBr01:oData:aArray[oBr01:nAt]) >= 8
         SZL->(DbGoto(oBr01:oData:aArray[oBr01:nAt][8]))
         ModalVis(cTitulo, UsrFullName(SZL->ZL_USUARIO), DToC(SZL->ZL_FECHA), SZL->ZL_OBSERV, SZL->ZL_STATUS,SZL->ZL_SECTOR,SZL->ZL_HORA)
      EndIf
    EndIf
EndIf

RestArea(aAreaSZL)
RestArea(aArea)
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

Static Function ModalVis(cTitle, cUser, cDate, cObs, cEstado ,cSector,cHora)
Local oModal
Local oContainer
Local oFont    := TFont():New('Arial',,-12,.T.,.T.)
Local cEst  := ""
Default cEstado := ""

oModal  := FWDialogModal():New()       
oModal:SetEscClose(.T.)
oModal:setTitle(cTitle)

oModal:setSize(230, 420)
oModal:createDialog()
oModal:AddButtons({{"", "Cerrar", {|| oModal:OOWNER:END()} , "", 0, .T., .F.}})

oContainer := TPanel():New( ,,, oModal:getPanelMain() )
oContainer:Align := CONTROL_ALIGN_ALLCLIENT

If cEstado == '1'
    cEst := "Aprobado"
Else
    cEst := "Rechazado"
EndIf

nMargx := 0

TSay():New(12,10+nMargx,{|| "Sector "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 20,10+nMargx,{||cSector},oContainer,60,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,cSector,,,, )//segunda linea

TSay():New(12,80+nMargx,{|| "Estado "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 20,80+nMargx,{||cEst },oContainer,60,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,cEst,,,, )

TSay():New(12,150+nMargx,{|| "Usuario "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 20,150+nMargx,{||cUser},oContainer,100,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,cUser,,,, )

TSay():New(12,260+nMargx,{|| "Fecha "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 20,260+nMargx,{||cDate},oContainer,40,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,cDate,,,, )

TSay():New(12,310+nMargx,{|| "Hora "},oContainer,,oFont,,,,.T.,,,30,20,,,,,,.T.)
TGet():New( 20,310+nMargx,{||cHora},oContainer,035,010, "@!",,0,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,,.F.,.F.,,cHora,,,, )

TSay():New(40,10,{|| "Observaciones "},oContainer,,oFont,,,,.T.,,,60,20,,,,,,.T.)
tMultiget():new( 50, 10, {| u | if( pCount() > 0, cObs := u, cObs ) }, oContainer, 400, 120, , , , , , .T., , , , , , .T., , , , , .T.  )

oModal:Activate()

Return()



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Programa   ³EnviarMail³ Autor ³ Alejandro Perret      ³ Fecha³ xx/xx/xx ³
ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrip.   ³          								                     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function EnviarMail(cAsunto, cCuerpo, aAdjuntos, aMailDest, aMailCC, aMailCO)

Local cAdjuntos := ""
Local cAcc 		:= AllTrim( GetNewPar("MV_RELACNT","") )	// Cuenta a ser utilizada en el envío de E-Mail para los informes. Ejemplo: andres_totvs@yahoo.com.ar
Local cServer	:= AllTrim( GetNewPar("MV_RELSERV","") )	// smtp.lapiamontesa.com	// Nombre de Servidor de Envio de E-mail utilizado en los informes.
Local cFrom		:= AllTrim( GetNewPar("MV_RELFROM","") ) 	// Nombre de origen	// "prueba@gmail.com"                                                                                                                           
Local cPass		:= AllTrim( GetNewPar("MV_RELPSW" ,"") )	// Contraseña para autenticación en servidor de e-mail. Nota: Esta contraseña es visible.


Default cAsunto	  := "Protheus Mail"
Default cCuerpo	  := "TEST EMAIL"	
Default	aAdjuntos := {}
Default	aMailDest := {}
Default	aMailCC	  := {}
Default	aMailCO   := {}

If Empty(aMailDest)
	MsgAlert("No se informó el/los destinatarios del e-mail a enviar", "Envío cancelado")
Else

	lOk := MailSmtpOn( cServer, cAcc, cPass)

	If lOk
		If cPass <> ''
			lOk:= MailAuth(Alltrim(cFrom),Alltrim(cPass))
			If !lOk
	   			nA := At("@", cFrom)
	   			cUser:= If(nA>0,Subs(cFrom,1,nA-1), cEmail)
	   			lOk:= MailAuth(Alltrim(cUser), Alltrim(cPass))
	   		EndIf
		EndIf

		If lOk
			lOk := MailSend(cFrom, aMailDest, aMailCC, aMailCO, cAsunto, cCuerpo, aAdjuntos, .T. /*lText*/)
		EndIf

		If !lOk   
			cSmtpError := MAILGETERR()
			MsgAlert( "Error de envio : " + cSmtpError)
		EndIf    

		MailSmtpOff() 
		
	Else
		cSmtpError := MAILGETERR()
		MsgAlert( "Error de conexion : " + cSmtpError)
	EndIf

EndIf
Return(lOk)

//==========================================================================//
//==========================================================================//

Static Function STACOTAB(aTabla)

Local nI		:= 0
Local nJ		:= 0
Local cMsg		:= ""
Default aTabla	:= {}

cMsg := '<table width="100%" border="1" align="center">'

For nI := 1 To Len(aTabla)
	If nI == 1
		cMsg += '<tr class="normal">'
		For nJ := 1 To Len(aTabla[nI])
			If nJ == 1
				cMsg += '	<th height="29" align="center" bgcolor="#CCCCCC"><b>' + aTabla[nI][nJ] + '</b></th>'
			Else
				cMsg += '	<th align="center" bgcolor="#CCCCCC"><b>' + aTabla[nI][nJ] + '</b></th>'
			EndIf
		Next
		cMsg += '</tr>'
	Else
		cMsg += '<tr class="normal">'
		For nJ := 1 To Len(aTabla[nI])
			cMsg += '	<td align="center">' + aTabla[nI][nJ] + '</td>'
		Next
		cMsg += '</tr>'
	EndIf
Next nI
	
cMsg += '</table>'

Return(cMsg)

/*/{Protheus.doc} ArmaHtml
    (long_description)
    @type  Static Function
    @author user
    @since 06/05/2021
    @version version
    /*/
Static Function ArmaHtml(cAsunto,cCuerpo)

Local cEncab    := ""
Local aAprob    := {}
Local aClient   := {}

cAsunto := "=?UTF-8?Q? Protheus - Informe de Activacion de Cliente electr=C3=B3nicos enviados (" + DToC(dDataBase) + ")?= "

cEncab := '<table width="100%" border="0" align="left">'
cEncab += '  <tr>'
cEncab += '    <th>Empresa:</th>'
cEncab += '    <td>'+ "(" + SM0->M0_CODIGO + ") - " + Capital(AllTrim(SM0->M0_NOMECOM)) + '</td>'
cEncab += '    <th>Sucursal:</th>'
cEncab += '    <td>'+ "(" + SM0->M0_CODFIL + ") - " + Capital(AllTrim(SM0->M0_FILIAL)) +'</td>'
cEncab += '    <th>Fecha - Hora:</th>'
cEncab += '    <td>'+ DtoC(dDataBase) + " - " + Time() +'</td>'
cEncab += '  </tr>'
cEncab += '</table>'
cEncab += CRLF_HTML + "<hr>" + CRLF_HTML

cCuerpo := cEncab  

cCuerpo += " <h3> NUEVO CLIENTE HABILITADO </h3> " + CRLF_HTML   // Agregar mensaje con las variables clientes y demas corre

aAdd(aClient , {"Codigo","Tienda","Razon Social"})
aAdd(aClient , {SA1->A1_COD, SA1->A1_LOJA, SA1->A1_NOME})

cCuerpo += STACOTAB(aClient) + CRLF_HTML

cCuerpo += "<h3> APROBADORES  </h3> " + CRLF_HTML 

aAdd(aAprob , {"Sector","Usuario","Fecha","Hora"})
aAdd(aAprob , {"FINANZAS",UsrFullName(SA1->A1_XFINAPR),DToC(SA1->A1_XFINFEC) ,SA1->A1_XFINHOR})
aAdd(aAprob , {"COMERCIAL",UsrFullName(SA1->A1_XCOMAPR),DToC(SA1->A1_XCOMFEC) ,SA1->A1_XCOMHOR})
aAdd(aAprob , {"FISCAL",UsrFullName(SA1->A1_XFISAPR),DToC(SA1->A1_XFISFEC) ,SA1->A1_XFISHOR})

cCuerpo += STACOTAB(aAprob) + CRLF_HTML

cCuerpo += CRLF_HTML + "<hr>"
cCuerpo += "Entorno: " + GetEnvServer()

Return ()
