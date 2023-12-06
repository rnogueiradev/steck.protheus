#Include 'TOTVS.ch'
#INCLUDE "TopConn.ch"
#INCLUDE "stdwin.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "TBICONN.CH"
/*/{Protheus.doc} STTRAN01
Rutina para hacer transfereencia entre Bodegas en Masivo
@type function
@version  
@author AxelDiaz
@since 25/5/2021
@return return_type, return_description
Formato:
Código Prod; Cantidad; almacen Origen ; Almacen Destino
SB330R;9;03;02
SD2115AM;105;03;02
/*///U_STTRAN01 C:\Users\AxelDiaz\Desktop\Clientes\Steck Andina\SaldosIniciales\TRANSFER_BODEGA.CSV  GFEFUNGE
User function STTRAN01
    Local aArea			:= GetArea()
    Local cArchivo  := ""
    Local aActuali  := {}
    Private cTipo   :=""
 
    cArchivo:=fCargaArchivo()
    IF EMPTY(cArchivo)
        Return .T.
    EndIf

    aActuali:=ReadUpd1(cArchivo)

    oProcess := MsNewProcess():New({|| _valida(aActuali,oProcess)}, "Procesando...", "Espere...", .T.)
    oProcess:Activate()
    

    RestArea(aArea)
Return .t.
/*/{Protheus.doc} _valida
Validador de Archivo CSV y Ejecuta EXECAUTO
@type function
@version  
@author AxelDiaz
@since 25/5/2021
@param aActuali, array, param_description
@param oObj, object, param_description
@return return_type, return_description
/*/
Static function _valida(aActuali,oObj)
    Local nX         := 0
    Local nY         := 0
    Local nTamB1Cod  := TAMSX3("B1_COD")[1]
    Local nTamNRCod  := TAMSX3("NNR_CODIGO")[1]
    Local cCodSb1    := ""
    Local cCodNNR1   := ""
    Local cCodNNR2   := ""
    Local cFilialNNR := XFILIAL("NNR")
    Local cFilialSb1 := XFILIAL("SB1")
    Local cFilialSb2 := XFILIAL("SB2")
    Local nCant      := 0
    Local aLinha     := {}
    Local aAuto      := {}
    Local nOpcAuto   := 3 // Inclusao
    Private lMsErroAuto := .F.
    
    dbSelectArea("SB1")     // Productos
	SB1->(DBSetOrder(1))    // B1_FILIAL+B1_COD
    DBSelectArea("SB2")     // Saldo Actual
    SB2->(DBSetOrder(1))    // B2_FILIAL+B2_COD+B2_LOCAL
    DBSelectArea("NNR")     // Bodegas
    NNR->(DBSetOrder(1))    // NNR_FILIAL+NNR_CODIGO

    oObj:SetRegua1(2)
    oObj:IncRegua1("Analizando Consistencia de los datos, fase 1 de 2 ...")
    oObj:SetRegua2(len(aActuali))
    For nX:=1 to  len(aActuali)  //  aActuali -> {'codigo producto', cantidad, 'bodegaOrigen', 'BodegaDestino'}
        oObj:IncRegua2("Registo " + cValToChar(nX) + " de " + cValToChar(len(aActuali)) + "...")
        cCodSb1  := PADR(aActuali[nX][1],nTamB1Cod)
        cCodNNR1 := PADR(aActuali[nX][3],nTamNRCod)
        cCodNNR2 := PADR(aActuali[nX][4],nTamNRCod)
        nCant    := Val(aActuali[nX][2])
        If !SB1->(MsSeek(cFilialSb1+cCodSb1,.T.))
            Alert("Producto no Existe "+cCodSb1)
            Return .t.
        Else
            aActuali[nX][1]:=cCodSb1
        EndIf

        If !NNR->(MsSeek(cFilialNNR+cCodNNR1,.T.))
            Alert("Bodega Origen no Existe "+cCodNNR1)
            Return .t.
        Else
            aActuali[nX][3]:=cCodNNR1
        EndIf

        If !NNR->(MsSeek(cFilialNNR+cCodNNR2,.T.))
            Alert("Bodega Destino no Existe "+cCodNNR2)
            Return .t.
        Else   
            aActuali[nX][4]:=cCodNNR2
        EndIf
        If !SB2->(MsSeek(cFilialSb2+cCodSb1+cCodNNR1,.T.))
            Alert("el producto "+cCodSb1+" en la Bodega Origen "+cCodNNR1+" no Existe ")
            Return
        Else
            IF SB2->B2_QATU<nCant
                Alert("Saldo actual del Producto "+cCodSb1+" en la Bodega Origen "+cCodNNR1+" es menor al diligenciado "+cValToChar(nCant))
                Return .t.
            Else
                aActuali[nX][2]:=nCant
            EndIf
        endIf
    Next nX

    oObj:IncRegua1("Ensamblado información validada, fase 2 de 2 ...")
    oObj:SetRegua2(len(aActuali))
    // Archivo Validado
	cDocumen	:= GetSxeNum("SD3","D3_DOC")
	aadd(aAuto,{cDocumen,dDataBase}) //Cabecalho


	for nX := 1 to len(aActuali)
	    aLinha := {}
        oObj:IncRegua2("Registo ensamblado" + cValToChar(nX) + " de " + cValToChar(len(aActuali)) + "...")
	    //Origen
	    conout("Producto: "+aActuali[nX][1])
        SB1->(MsSeek(cFilialSb1+aActuali[nX][1],.T.))

	    CriaSB2(SB1->B1_COD,aActuali[nX][4])   // CREA EL PRODUCTO EN EL ALMACEN DESTINO
	    CriaSB2(SB1->B1_COD,aActuali[nX][3])

	    aadd(aLinha,{"ITEM"			,'00'+cvaltochar(nX), Nil})
	    aadd(aLinha,{"D3_COD"		, SB1->B1_COD    	, Nil}) 	//Cod Produto origem
	    aadd(aLinha,{"D3_DESCRI"	, SB1->B1_DESC		, Nil}) 	//descr produto origem
	    aadd(aLinha,{"D3_UM"		, SB1->B1_UM     	, Nil}) 	//unidade medida origem
	    aadd(aLinha,{"D3_SEGUM"		, SB1->B1_SEGUM 	, Nil}) 	//unidade medida origem
	    aadd(aLinha,{"D3_LOCAL"		, aActuali[nX][3]	, Nil}) 	//armazem origem
	    aadd(aLinha,{"D3_LOCALIZ"	, ""				, Nil}) 	//Informar endereÃ§o origem

	    //Destino
	    aadd(aLinha,{"D3_COD"		, SB1->B1_COD    	, Nil}) 	//cod produto destino
	    aadd(aLinha,{"D3_DESCRI"	, SB1->B1_DESC		, Nil}) 	//descr produto destino
	    aadd(aLinha,{"D3_UM"		, SB1->B1_UM		, Nil}) 	//unidade medida destino
	    aadd(aLinha,{"D3_SEGUM"		, SB1->B1_SEGUM		, Nil}) 	//unidade medida origem
	    aadd(aLinha,{"D3_LOCAL"		, aActuali[nX][4]	, Nil}) 	//armazem destino
	    aadd(aLinha,{"D3_LOCALIZ"	, ""				, Nil}) 	//Informar endereÃ§o destino

	    aadd(aLinha,{"D3_NUMSERI"	, ""				, Nil})		//Numero serie
	    aadd(aLinha,{"D3_LOTECTL"	, ""				, Nil}) 	//Lote Origem
	    aadd(aLinha,{"D3_NUMLOTE"	, ""				, Nil}) 	//sublote origem
	    aadd(aLinha,{"D3_DTVALID"	, dDataBase			, Nil}) 	//data validade
	    aadd(aLinha,{"D3_POTENCI"	, 0					, Nil}) 	//Potencia
	    aadd(aLinha,{"D3_QUANT"		, aActuali[nX][2]	, Nil}) 	//Quantidade
	    aadd(aLinha,{"D3_QTSEGUM"	, ConvUni(aActuali[nX][2],SB1->B1_CONV,SB1->B1_TIPCONV)	, Nil}) 	//Seg unidade medida
	    aadd(aLinha,{"D3_ESTORNO"	, ""				, Nil}) 	//Estorno
	    aadd(aLinha,{"D3_NUMSEQ"	, ""				, Nil}) 	//Numero sequencia D3_NUMSEQ

	    aadd(aLinha,{"D3_LOTECTL"	, ""				, Nil}) 	//Lote destino
	    aadd(aLinha,{"D3_NUMLOTE"	, ""				, Nil}) 	//sublote destino
	    aadd(aLinha,{"D3_DTVALID"	, dDataBase			, Nil}) 	//validade lote destino
	    aadd(aLinha,{"D3_ITEMGRD"	, ""				, Nil}) 	//Item Grade

	    aadd(aLinha,{"D3_CODLAN"	, ""				, Nil}) 	//cat83 prod origem
	    aadd(aLinha,{"D3_CODLAN"	, ""				, Nil}) 	//cat83 prod destino

	    aAdd(aAuto,aLinha)

	Next nX

	conout("inicio Inclusión de transferencias multiple Steck Colombia" )
    
    MsgRun( "Procesando" ,, {|| MSExecAuto({|x,y| MATA261(x,y)},aAuto,nOpcAuto) } )
	
    if lMsErroAuto
        DisarmTransaction()
        MostraErro()
        conout("Inclusión de transferencias multiple Steck Colombia finalizó con errores " )
    else
        conout("Fin Inclusión de transferencias multiple Steck Colombia finalizó con Exito")
        MSGINFO( "Inclusion de transferencias multiple, Steck Colombia, finalizó con Exito", "Transferencia documento No."+cDocumen )
    EndIf

	conout("Movimiento Finalizado")

    SB1->(DBCloseArea())
    SB2->(DBCloseArea())
    NNR->(DBCloseArea())
Return .T.

/*
+---------------------------------------------------------------------------+
| Programa  # ConvUni   |Autor  | Axel Diaz        |Fecha |  10/12/2019     |
+---------------------------------------------------------------------------+
| Uso       # Hace la conversion de segunda unidad de medida                |
+---------------------------------------------------------------------------+
*/
Static Function ConvUni(nCant,nConver,cOper)
	Local nSegCan:=0
	If cOper=="D"
		nSegCan:=nCant/nConver
	Else
		nSegCan:=nCant*nConver
	EndIf
Return nSegCan

/*/{Protheus.doc} ReadUpd1
Lee el Archivo y convierte en Array
@type function
@version  
@author AxelDiaz
@since 25/5/2021
@param cArchivo, character, param_description
@return return_type, return_description
/*/
Static function ReadUpd1(cArchivo)
	Local nTimer	:= seconds()
	Local cLine 	:= ''
	Local cLinha	:= ""
	Local nLines 	:= 0
	Local nLinTXT	:= 0
	Local aDados	:= {}
	Local oTXTFile
	Local nX		:= 0
	Private aErro	:= {}

    oTXTFile := ZFWReadAXL():New(cArchivo)
    If !oTXTFile:Open()
        MsgStop("El archivo " +alltrim(cArchivo) + " no pudo ser abierto. La importación será abortada!","[ARCHLOAD] - ATENCION")
        aAdd(aMsgLog,{LogErrorSI,"ImporPV",'['+alltrim(cArchivo)+']','No se pudo abrir'})
        lFileOk:=.F.
        Return
    Endif

    While oTXTFile:ReadLine(@cLine)
        nLines++
    Enddo

    oTXTFile:Close()

    ProcRegua(nLines++)

    oTXTFile := ZFWReadAXL():New(cArchivo)
    oTXTFile:Open()
    cLine:=""
    While oTXTFile:ReadLine(@cLinha)
        IncProc("Leyendo arquivo texto, revisando estructura")
        nLinTXT += 1
        If !EMPTY(ALLTRIM(cLinha))
            AADD(aDados,Separa(cLinha,";",.T.)) // separa los campos y agrega un campos al final que es el mombre del archivo
        EndIf
    Enddo
    oTXTFile:Close()
	lFileOk:= .T.
Return aDados

/*/{Protheus.doc} fCargaArchivo
Ventana de Seleecion de Archivo CSV
@type function
@version  
@author AxelDiaz
@since 25/5/2021
@return return_type, return_description
/*/
Static Function fCargaArchivo()

Local cFile 		:= ""
Local cTitulo1  	:= "Seleccione Archivo de transferencia:"
Local cExtens   	:= "Archivo | *.csv"


cFile := cGetFile(cExtens,cTitulo1,,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
If File( cFile )
 return cFile
EndIf
MsgStop("El archivo no fue encontrado. La transferencia no será procesada!","Transferencia Abortada")
Return ""

