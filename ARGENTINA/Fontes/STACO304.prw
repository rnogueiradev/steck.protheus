#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'



User Function STACO304()
Local oBrowse

NEW MODEL ;
	TYPE 2 ;
	DESCRIPTION "Usuarios VS Sector" ;
	BROWSE oBrowse ;
	SOURCE "STACO304" ;
	MODELID "MDUSS303" ;
	PRIMARYKEY {"ZM_FILIAL", "ZM_USUARIO", "ZM_SECTOR"};
	MASTER "SZM" ;
	AFTER      { |oMdl| DeleteOk( oMdl ) };
	HEADER { "ZM_SECTOR" } ; 
	RELATION { { "ZM_FILIAL", "xFilial('SZM')"}, { "ZM_SECTOR", "ZM_SECTOR" }} ;
    UNIQUELINE {"ZM_USUARIO"} ;
    ORDERKEY SZM->( IndexKey(1)) ;


Return NIL


//==========================================================================//
/*/{Protheus.doc} ExSector
Funcion de consulta de registro de sector
@author MicroSIGA
@since 28/04/2021
@version 1.0        
/*/
//==========================================================================//

User Function ExSector( cSector ) 

Local lExist := .T.
Local aArea := GetArea()

DbSelectArea("SZM")
DbSetOrder(1)

If DbSeek(xFilial("SZM") + cSector)

	Help(NIL, NIL, "Ya existe un registro del Sector", NIL,; 
	"Ya existe un registro para el Sector : " + cSector ,;
	1, 0, , , , , , {"verifique los registros existentes para este Sector y modifíquelos para agregar un nuevo usuario. "})

	lExist := .F.

EndIf

RestArea(aArea)

Return lExist


//==========================================================================//
/*/{Protheus.doc} ExUsuario
Funcion de consulta existencia del registro de un Usr en alguno de los Sectores
@author MicroSIGA
@since 28/04/2021
@version 1.0        
/*/
//==========================================================================//

User Function ExUsr( cUsr ) 

Local lExist := .T.
Local aArea := GetArea()

DbSelectArea("SZM")
DbSetOrder(2)

If DbSeek(xFilial("SZM") + cUsr)

	Help(NIL, NIL, "Ya existe un usuario registrado", NIL,; 
	"Ya existe este usuario registrado en el sector : " + SZM->ZM_SECTOR,;
	1, 0, , , , , , {"verifique los registros existentes para este usuario y modifíquelos. "})

	lExist := .F.

EndIf

RestArea(aArea)
Return lExist


//==========================================================================//
/*/{Protheus.doc} ExUsuario
Funcion de consulta existencia del registro de un Usr en alguno de los Sectores
@author Lucas Frias
@since 28/04/2021
@version 1.0        
/*/
//==========================================================================//

User Function GetNombre()

Local oModel      	:= FWModelActive() 
Local oGrid     	:= oModel:GetModel(oModel:GetModelIds()[2]) //FWFormGridModel
Local nQtdLinhas	:= oGrid:Length()
Local cNombre 		:= USRFULLNAME(SZM->ZM_USUARIO)
Local nI 

For nI := 1 To nQtdLinhas

	oGrid:GoLine(nI)
	oGrid:GetValue("ZM_NOMBRE")

 	IF AllTrim(oGrid:GetValue("ZM_NOMBRE"))  == AllTrim(USRFULLNAME(SZM->ZM_USUARIO))
		cNombre := " "
		Exit
 	EndIf

Next

Return cNombre


//==========================================================================//
/*/{Protheus.doc} DeleteOk
	(long_description)
	@type  Static Function
	@author MSIGA
	@since 14/04/2021
	/*/
Static Function DeleteOk(oModel)

Local nOperation 	:=  oModel:GetOperation()
Local lRet 			:= .T.

If nOperation == 5
	lRet := MsgYesNo("¿Desea borrar todos los items relacionados con este Sector?" + CRLF + CRLF + " En caso de querer eliminar solo un item, dirijase a la opcion de 'Modificar'")
	Help(NIL, NIL, "Eliminación de registro cancelada", NIL,;
	"Se canceló la eliminacion de todos los rangos asociados al Sector  : " + SZM->ZM_SECTOR,;
	1, 0, , , , , , {"Para eliminar individualmente items, dirigirse a la opcion 'Modificar' del menú. "})
EndIf 

Return (lRet)
