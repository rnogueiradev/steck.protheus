#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} DECOA300
Maestro de Rangos de descuentos para Sell Out
	
@author Alejandro Perret
@since 13/12/2019
@version 1.0		
/*/

User Function STACO303()
Local oBrowse

NEW MODEL ;
	TYPE 2 ;
	DESCRIPTION "Rango de Descuentos" ;
	BROWSE oBrowse ;
	SOURCE "STACO303" ;
	MODELID "MDRDE303" ;
	PRIMARYKEY {"ZD7_FILIAL", "ZD7_CLIENT", "ZD7_LOJA"};
	MASTER "ZD7" ;
	AFTER      { |oMdl| DeleteOk( oMdl ) };
	AFTERLINE { |oModelGrid, nLine| COMP022LPOS( oModelGrid, nLine ) } ;
	HEADER { "ZD7_CLIENT", "ZD7_LOJA","ZD7_RAZSOC" } ; 
	RELATION { { "ZD7_FILIAL", "xFilial('ZD7')"}, { "ZD7_CLIENT", "ZD7_CLIENT" }, { "ZD7_LOJA", "ZD7_LOJA" }} ;
	ORDERKEY ZD7->( IndexKey(1)) ;

Return NIL

//==========================================================================//
/*/{Protheus.doc} COMP022LPOS
	(long_description)
	@type  Static Function
	@author MicroSIGA
	@since 12/04/2021
	@version version
	/*/
//==========================================================================//
Static Function COMP022LPOS( oModelGrid, nLine )
Local lRet		:= .T. 
Local cRet		:= ""
Local nDesde	:= oModelGrid:GetValue("ZD7_CDESD")
Local nHasta 	:= oModelGrid:GetValue("ZD7_CHAST")
Local nQtdLinhas:= oModelGrid:Length()
Local lCond1	
Local lCond2	
Local lCond3	
Local lCondF	
Local nI

For nI := 1 To nQtdLinhas

	oModelGrid:GoLine(nI)

	If ExRango(nDesde, nHasta, @cRet)
		If nI == nLine 
			Loop
		EndIf

		lCond1	:= ((nDesde >= oModelGrid:GetValue("ZD7_CDESD")) .And. (nDesde <= oModelGrid:GetValue("ZD7_CHAST")))
		lCond2	:= ((nHasta >= oModelGrid:GetValue("ZD7_CDESD")) .And. (nHasta <= oModelGrid:GetValue("ZD7_CHAST")))
		lCond3	:= ((nHasta >= oModelGrid:GetValue("ZD7_CHAST")) .And. (nDesde <= oModelGrid:GetValue("ZD7_CDESD")))
		lCondF	:= lCond1 .Or. lCond2 .Or. lCond3

		If (!oModelGrid:IsDeleted(nI) .And. lCondF)
			lRet := .F.
			Help(NIL, NIL, "Rango ya utilizado", NIL, "Este rango ya esta utilizado o comprende otros rangos. "  ;
			, 1, 0, , , , , ,{"Ingrese un rango que no incluya otros ya ingresados." })
			Exit
		EndIf
	Else
		lRet := .F.
		Help(NIL, NIL, "Rango de Descuento no válido", NIL, cRet ,1 , 0, , , , , , {"Ingrese un rango válido."})
	EndIf
Next

Return lRet

//==========================================================================//
/*/{Protheus.doc} ExClient
Funcion de consulta registro de clientes en ZD7
@author MicroSIGA
@since 12/04/2021
@version 1.0        
/*/
//==========================================================================//

User Function ExClient(cClient, cLoja)
Local lExist 	:= .T.
Local aArea 	:= GetArea()

DbSelectArea("ZD7")
DbSetOrder(1)

If DbSeek(xFilial("ZD7") + cClient + cLoja)

	Help(NIL, NIL, "Rango de Descuento Existente", NIL,; 
	"Ya existen rangos de descuento para el cliente informado : '" + cClient + "'." ,;
	1, 0, , , , , , {"Verifique los rangos de descuentos existentes para este cliente y modifíquelos si es necesario."})
	lExist := .F.

EndIf

RestArea(aArea)
Return lExist

//==========================================================================//
/*/{Protheus.doc} Static Function ExRango
	(long_description)
	@type  Function
	@author MicroSIGA
	@since 13/04/2021
	@version version
	/*/
//==========================================================================//

Static Function ExRango(nDesde,nHasta,cRet)

Local lRet := .T.

If (nHasta < 0)  .Or. (nDesde < 0)
	lRet := .F.
	cRet := "Los limites del rango deben ser mayores o iguales a cero "
ElseIf (nHasta <= nDesde)
	lRet := .F.
	cRet := "El limite superior del rango debe ser mayor al limite inferior "
EndIf

Return (lRet)
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
	lRet := MsgYesNo("¿Desea borrar todos los items relacionados con este cliente?" + CRLF + CRLF + " En caso de querer eliminar solo un item, dirijase a la opcion de 'Modificar'.")
	Help(NIL, NIL, "Eliminación de registro cancelada", NIL,; 
	"Se canceló la eliminacion de todos los rangos asociados al cliente  : " + M->ZD7_CLIENT ,;
	1, 0, , , , , , {"Para eliminar individualmente rangos o items, dirigirse a la opcion 'Modificar' del menú "})

EndIf 


Return (lRet)
