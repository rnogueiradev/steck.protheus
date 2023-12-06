#include 'protheus.ch'
#include 'parmtype.ch'
#include 'FWPrintSetup.ch'
#include 'TBICONN.CH'
#include 'RPTDEF.CH'
#include 'FONT.CH'

User Function M475IMPPER()

    Local __aArea:= Getarea()
    Private cEspecie    := PARAMIXB[1]  //Especie(NF/NCC/NDC)
    Private cSerie      := PARAMIXB[2]
    Private cNumFac     := PARAMIXB[3]
    Private cTipoDoc    := ParamIXB[4]  //Tipo -> 01 - Factura Normal, 21 - Factura de Traslado.
    Private cCliente    := PARAMIXB[5]  
    Private cLoja       := PARAMIXB[6]
    Private lVisPDF     := ParamIXB[7]  //Informa si visualizara PDF tras impresión.
    Private cTpOper     := "I"
    Private cRUTASRV 	:= &(SuperGetmv( "MV_CFDDOCS" , .F. , "\cfd\facturas\" ))	// Ruta donde se encuentran las facturas.xml (servidor)
    Private	cNameCFDI := Lower( Alltrim(cEspecie) + "_" + Alltrim(SubStr(cSerie,1,3)) + "_" + Alltrim(cNumFac) + ".xml" )	
	Private	cNCFDIpdf := Lower( Alltrim(cEspecie) + "_" + Alltrim(SubStr(cSerie,1,3)) + "_" + Alltrim(cNumFac) + ".pdf" )
    Private lFactura := .T.
    Private cObservaciones:= ""
    Private cTimbre := ""

    lFactura  := IIF(Alltrim(cEspecie) =="NF" .or. Alltrim(cEspecie) =="NDC",.T.,.F.)
    IF lFactura
        DbSelectarea("SF2")
        dbSetOrder(1)
        Dbseek(xfilial("SF2")+cNumFac+cSerie+cCliente+cLoja)
    Else
        DbSelectarea("SF1")
        dbSetOrder(1)
        Dbseek(xfilial("SF1")+cNumFac+cSerie+cCliente+cLoja)
    Endif
    //EFAT004 esta dentro de PDFFAT.PRW
    U_EFAT004(cNumFac , cSerie , cEspecie , cCliente , cLoja, cTpOper, lVisPDF)
    Restarea(__aArea)
Return



