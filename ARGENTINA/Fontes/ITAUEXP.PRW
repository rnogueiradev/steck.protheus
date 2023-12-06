#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	ITAUEXP	|	FECHA:	24/04/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: NUEVO FORMATO, Generacion de archivo TXT para Banco ITAU
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
User Function ITAUEXP(lReProcesa)

Local cExten	:= ".txt"
Local cDirLog	:= '\LogITAU'
Local cEmpresa := ""

Private lCustom	:= .T.	// Considero los campos especificos?
Private lHayDatos	:= .F.


Private cPerg   	:= ""
Private nFirma  	:={"","",""}

Private nLastKey	:= 0
Private nRef1   	:= 0   //Numero de renglon, se obtiene por parametro
Private nRef2   	:= 0   //Numero de proceso para reproceso
Private nRenglon	:= 0   //Numero de proceso secuencial, se obtiene por parametro
Private nCantFir	:= 0
Private nLinea		:= 0
Private nHnd		:= 0
Private nCantReg 	:= 0
Private nTotImp  	:= 0

Private cFormPag	:= ""
Private cHeader	:= ""
Private cClientes	:= ""
Private cDetPag	:= ""
Private cTrailer	:= ""
Private cOpc		:= ""
Private cFrmPago	:= ""

Private cDirTXT	:= ""
Private cArchivo	:= ""

Private cCRLF		:= Chr(13) + Chr(10)
Private TMP			:= GetNextAlias()

Private aDet	:= {}
Private aPag	:= {}
Private aRet	:= {}
Private nLote	:= 0

Private nValPag := 0

Private cNumProd	:= PadR( GetNewPar( "IT_XPRODCV", "" ), 3 ) 	// 3 - Pos: 13 - Numero de Producto al cual esta vinculado el Convenio
Private cNumConv	:= PadR( GetNewPar( "IT_XNUMCNV", "" ), 6 ) 	// 4 - Pos: 16 - Numero de Convenio

Private lProcesado := .F.

Default lReProcesa := .F.

	lProcesado := lReProcesa

	// Genero los parametros
	GenParam()

	// Si el directorio no existe, lo creo.
	IF !ExistDir ( cDirLog )
		MakeDir( cDirLog )
	EndIF

	IF lProcesado	// Si es un reproceso.
		cPerg := "ITAUREP001"
	Else
		cPerg	:= "ITAUEXP001"
	EndIF
	
	// Genero las preguntas
    AtuSX1(cPerg)  
    
	If !Pergunte(cPerg ,.T.,"Seleccion de Rango de busqueda")
		Return
	EndIf   

	//ValidBanco()
/*
	IF MV_PAR09 == 1	// Cheque ITAU.
		cOpc := "CHI"
	EndIF
	IF MV_PAR09 == 2	// Transferencia con CBU.
		cOpc := "TFC"
	EndIF
	IF MV_PAR09 == 3	// Transferencia sin CBU.
		cOpc := "TFS"
	EndIF
*/
	If MV_PAR09 == 1  // CHEQUE ITAU
		cFrmPago:="CH"
//		nCantFir:=CantFirm()	Los firmantes no son necesarios en el nuevo formato.
//		nFirma  :=Firmante()

//        nRef1   :=Getmv("MV_NROREF1")
//        nRenglon:=Getmv("MV_NROPRO")
	else
		// IF MV_PAR09 == 2  // Transferencia con CBU	
			cFrmPago:="TF"
		// Else              // Transferencia sin CBU
			// cFrmPago:="TFS"
		// ENDIF  
	Endif 

//LP	IF !lProcesado		// Si no tengo en cuenta los reprocesos, no lo tengo en cuenta para actualizarlo.
		nRef1   :=Getmv("IT_NROREF1")
		nRef1   := StrZero( nRef1, 5 )
		nRenglon:=Getmv("IT_NROPRO")
//	Else             
	IF lProcesado // si es un reproceso busco el lote con el cual estan grabados actualmente los registros
		nLote		:= BuLote()
		nRef2		:= nLote
	EndIF

    If nLastKey == 27
       Return
    Endif

	// Asigno el Path a un Auxiliar.
	cDirTXT	:= Alltrim(MV_PAR10)

	cDirTXT	:= cDirTXT + If( SubStr( cDirTXT, Len(cDirTXT), 1 ) == '\', '', '\' )

	// Valido que exista el directorio.
	IF !ExistDir(cDirTXT)
		Alert("El Proceso No Puede Continuar, Porque No Existe el Directorio Ingresado"+CRLF+"Por Favor Cree el Directorio o Elija Otro Directorio."+CRLF+"DIRECTORIO: "+cDirTXT,"Error")
		Return   
	EndIF

	// Busco los datos
	BuDatos()

	cCadastro := OemToAnsi("Generacion de archivo para ITAU")

	IF lHayDatos	// Si hay datos
		// Valido los datos.
 		lError := ValidDatos()

		// Si el archivo no ningun error, lo proceso.
		IF !lError
			cEmpresa := BuEmp(SM0->M0_CODIGO)
			// Nombre del archivo
    		cArchivo := cFrmPago + '_' + cEmpresa + FWTimeStamp(1)  +'_' + nRef1 + '.txt'

			// Creo el archivo.
			nHnd  := FCreate( cDirTXT + cArchivo )
		
			// Genero el Header.
			GenHeader()

			// Genero el cuerpo.
			GenCuerpo()

			// Genero el Trailer.
			GenTrailer()
		Else
			cFileLog := NomeAutoLog()

			If cFileLog <> ""
				nX := 1
				While .T.
					If File( Lower( cDirLog + '\' + Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) )
						nX++
						If nX == 999
            				Exit
         				EndIf
         			
         				Loop
					Else
						Exit
      				EndIf
   				
   				EndDo

				__CopyFile( Alltrim( cFileLog ), Lower( cDirLog + '\' + Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) )
		   	MostraErro( "", cFileLog)
			   FErase( cFileLog )
			Endif
		EndIF
	Else
		MsgInfo("No hay datos para los filtros seleccionados")
	EndIF

	DbUnlockAll()

	DbSelectArea("SA2")
	DbCloseArea()

	DbSelectArea("SEK")
	DbCloseArea()    

//LP		IF !lProcesado		// Si no tengo en cuenta los reprocesos, no lo tengo en cuenta para actualizarlo.
			nRef1:=val(nRef1)+1
			PutMV("IT_NROPRO" ,nRenglon)
			PutMV("IT_NROREF1",nRef1)
//LP		EndIF

Return


// Harcodeo el nombre de la empresa, porque el archivo no admite espacios en blanco.
Static Function BuEmp(cCodEmp)
Local cRet := ""

	Do Case
		Case cCodEmp == '01'
			cRet := "CE_"
		Case cCodEmp == '02'
			cRet := "CN_"
		Case cCodEmp == '03'
			cRet := "RP_"
		Case cCodEmp == '04'
			cRet := "IG_"
		Case cCodEmp == '05'
			cRet := "SJ_"
		Case cCodEmp == '06'
			cRet := "FG_"
		Case cCodEmp == '07'
			cRet := "RE_"
		Case cCodEmp == '08'
			cRet := "DR_"
		Case cCodEmp == '09'
			cRet := "FD"
	End Case

Return cRet

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N: BULOTE	|	FECHA:	06/06/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Busco el lote y el numero de renglon.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function BuLote()
Local aArea	:= GetArea()
Local aAreaSEK	:= SEK->(GetArea())
Local TMP_SEK	:= GetNextAlias()
Local cQry	:= ""
Local cIdTau:= ""
Local lContinua:= .T.
Local lPrimero	:= .T.
Local cOP	:= ""

	cQry := "SELECT EK_XIDTAU, EK_ORDPAGO "+CRLF
	cQry += "FROM " + RetSQLName("SEK") + " SEK, "+RetSqlName("SA6")+" SA6, "
	IF cFrmPago = "CH"
	cQry += RetSqlName("SE2")+" SE2 "+CRLF
	EndIf
	cQry += "WHERE SEK.EK_FILIAL = '" + xFilial('SEK') + "' "+CRLF
	cQry += "AND SA6.A6_FILIAL = '" + xFilial('SA6') + "' "+CRLF
	cQry += "AND SEK.EK_CANCEL <> 'T' "+CRLF
	cQry += "AND SEK.EK_BANCO   BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR06 + "' "+CRLF
	cQry += "AND SEK.EK_AGENCIA BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR07 + "' "+CRLF
	cQry += "AND SEK.EK_CONTA   BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR08 + "' "+CRLF
	cQry += "AND SEK.EK_DTDIGIT BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "+CRLF
	cQry += "AND SEK.EK_BANCO   = SA6.A6_COD "+CRLF
	cQry += "AND SEK.EK_AGENCIA = SA6.A6_AGENCIA "+CRLF
	cQry += "AND SEK.EK_CONTA   = SA6.A6_NUMCON "+CRLF
	//cQry += "AND SA6.A6_XINTPAG = '007' "+CRLF	// Solo tengo en cuenta bancos para la nueva rutina.
	cQry += "AND SEK.D_E_L_E_T_ <> '*' "+CRLF
	cQry += "AND SA6.D_E_L_E_T_ <> '*' "+CRLF
	IF !lProcesado
		cQry += "AND SEK.EK_XIDTAU ='' "+CRLF
	EndIF
	//cQry += "AND SEK.EK_TIPO IN ('"+cOpc+"', 'NF','NCP','NDP','PA') "+CRLF
	cQry += "AND SEK.EK_TIPO IN ('TF', 'CH', 'NF','NCP','NDP','PA') "+CRLF
	cQry += "AND SEK.EK_TIPODOC IN('TB', 'CP', 'RG') "+CRLF
	IF cFrmPago = "CH"
		cQry += "AND SEK.EK_ORDPAGO = SE2.E2_ORDPAGO "+CRLF
		cQry += "AND SEK.EK_TIPO = SE2.E2_TIPO "+CRLF
		cQry += "AND SEK.EK_NUM = SE2.E2_NUM "+CRLF
		cQry += "AND SE2.E2_BAIXA = '' "+CRLF
	EndIf	
	IF !Empty( MV_PAR12 )
		cQry += "AND SEK.EK_ORDPAGO BETWEEN '" + MV_PAR11 + "' AND '"+ MV_PAR12 +"' "+CRLF
	EndIF
	cQry += "ORDER BY SEK.EK_ORDPAGO, SEK.EK_TIPODOC "+CRLF

   cQry := ChangeQuery(cQry)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), TMP_SEK, .F., .T.)

   DbSelectArea(TMP_SEK)
   DbGoTop()

	WHILE !(TMP_SEK)->(EOF())
		IF lPrimero .AND. !Empty((TMP_SEK)->EK_XIDTAU)
			cIdTau := (TMP_SEK)->EK_XIDTAU
			lPrimero := .F.
			cOP := (TMP_SEK)->EK_ORDPAGO
		EndIF

		
		IF !Empty(cIdTau)
			IF cIdTau != (TMP_SEK)->EK_XIDTAU
				lContinua := .F.
				IF !Empty( cOP )
					cOP += " / " + (TMP_SEK)->EK_ORDPAGO
				EndIF
			EndIF
		EndIF
		
		(TMP_SEK)->(DbSkip())
	EndDo

	(TMP_SEK)->(DbCloseArea())

	IF !lContinua
		Alert("Los parametros informados contienen lotes distintos, busque por la Orden de Pago."+CRLF+"Ordenes de pagos encontradas: "+cOP)
		RestArea(aAreaSEK)
		RestArea(aArea)
		Return
	EndIF

	cIdTau := StrZero( Val(cIdTau), 5 )

RestArea(aAreaSEK)
RestArea(aArea)

Return cIdTau


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N: BUDATOS	|	FECHA:	25/04/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Genero la cabecera para el archivo.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function BuDatos()
Local aSEK     := SEK->(DbStruct())
Local nSEK     := Len( aSEK )               
Local c_agedes := ''
Local c_agehas := ''
Local c_condes := ''
Local c_conhas := ''
Local cQry   := "SELECT "

//ordena agencia y cuenta de menor a mayor para el between
if ALLTRIM(MV_PAR04)<ALLTRIM(MV_PAR07)
      c_agedes := ALLTRIM(MV_PAR04)
      c_agehas := ALLTRIM(MV_PAR07)
else
      c_agedes := ALLTRIM(MV_PAR07)
      c_agehas := ALLTRIM(MV_PAR04)      
endif                     

if ALLTRIM(MV_PAR05)<ALLTRIM(MV_PAR08)
		c_condes := ALLTRIM(MV_PAR05)
		c_conhas := ALLTRIM(MV_PAR08)
else
		c_condes := ALLTRIM(MV_PAR08)
		c_conhas := ALLTRIM(MV_PAR05)
endif                     

	For nX := 1 To nSEK
 		cQry   += "SEK."+AllTrim( aSEK[nX][1]  ) + ',' 
	Next
	IF cFrmPago = "CH"
	cQry += "ISNULL(SE2.E2_BAIXA,'') E2_BAIXA, "+CRLF   //Fecha de cancelamiento del tÌtulo.        
	else
	cQry += "'' E2_BAIXA, "+CRLF   //Fecha de cancelamiento del tÌtulo.        	
   endif
	cQry += "SEK.R_E_C_N_O_ AS RECSEK "+CRLF
	cQry += "FROM " + RetSQLName("SEK") + " SEK, "+RetSqlName("SA6")+" SA6"
	IF cFrmPago = "CH"
	cQry += ", "+RetSqlName("SE2")+" SE2 "+CRLF
   endif	
	cQry += "WHERE SEK.EK_FILIAL = '" + xFilial('SEK') + "' "+CRLF
	cQry += "AND SA6.A6_FILIAL = '" + xFilial('SA6') + "' "+CRLF
	cQry += "AND SEK.EK_CANCEL <> 'T' "+CRLF
	cQry += "AND SEK.EK_BANCO   BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR06 + "' "+CRLF
	cQry += "AND SEK.EK_AGENCIA BETWEEN '" + c_agedes + "' AND '" + c_agehas + "' "+CRLF
	cQry += "AND SEK.EK_CONTA   BETWEEN '" + c_condes + "' AND '" + c_conhas + "' "+CRLF
	cQry += "AND SEK.EK_DTDIGIT BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "+CRLF
	cQry += "AND SEK.EK_ORDPAGO BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "+CRLF
	cQry += "AND SEK.EK_BANCO   = SA6.A6_COD "+CRLF
	cQry += "AND SEK.EK_AGENCIA = SA6.A6_AGENCIA "+CRLF
	cQry += "AND SEK.EK_CONTA   = SA6.A6_NUMCON "+CRLF         
	
	//cQry += "AND SA6.A6_XINTPAG = '007' "+CRLF	// Solo tengo en cuenta bancos para la nueva rutina.
	cQry += "AND SEK.D_E_L_E_T_ <> '*' "+CRLF
	cQry += "AND SA6.D_E_L_E_T_ <> '*' "+CRLF
	cQry += "AND SEK.EK_NUM <> 'NORET' "+CRLF	// ANDRES LOVOS - 11/09/2014 - No tengo en cuento el tipo NORET
	IF !lProcesado
		cQry += "AND SEK.EK_XIDTAU = '' "+CRLF
	Else
		cQry += "AND SEK.EK_XIDTAU = '"+cValToChar(nRef2)+"' "+CRLF
//LP		IF !Empty( MV_PAR12 )          // COMENTADO ESTE CRITERIO PORQUE DEBE CONSIDERAR TODAS LAS OP DEL LOTE
//LP			cQry += "AND SEK.EK_ORDPAGO BETWEEN '" + MV_PAR11 + "' AND '"+ MV_PAR12 +"' "+CRLF
//LP		EndIF
	EndIF
	//cQry += "AND SEK.EK_TIPO IN ('"+cOpc+"', 'NF','NCP','NDP','PA') "+CRLF
	cQry += "AND SEK.EK_TIPO IN ('TF', 'CH', 'NF','NCP','NDP','PA') "+CRLF
	cQry += "AND SEK.EK_TIPODOC IN('TB', 'CP', 'RG') "+CRLF
	IF cFrmPago = "CH"
//	cOpc		 cFrmPago
	cQry += "AND SEK.EK_ORDPAGO = SE2.E2_ORDPAGO "+CRLF
	cQry += "AND SEK.EK_TIPO = SE2.E2_TIPO "+CRLF
	cQry += "AND SEK.EK_NUM = SE2.E2_NUM "+CRLF
	cQry += "AND SE2.E2_BAIXA = '' "+CRLF
	endif
	cQry += "ORDER BY SEK.EK_ORDPAGO, SEK.EK_TIPODOC "+CRLF

   cQry := ChangeQuery(cQry)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), TMP, .F., .T.)
   
   DbSelectArea(TMP)
   DbGoTop()

	IF !(TMP)->(EOF())
		lHayDatos	:= .T.
	EndIF

Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N: GENHEADER	|	FECHA:	24/04/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Genero la cabecera para el archivo.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function GenHeader()

	// REGISTRO HEADER
	cHeader     := "H"                                     	// 1 - 1 - Tipo de Registro
	cHeader     += SubStr(StrTran(SM0->M0_CGC,'-',''),1,11) 	// 2 - 2 - CUIT
	cHeader     += cNumProd												// 3 - 13 - Numero de Producto al cual esta vinculado el Convenio
	cHeader     += cNumConv												// 4 - 16 - Numero de Convenio
	cHeader     += PADR( cValToChar(nRef1), 5 )					// 5 - 22 - Numero de Envio
	cHeader     += DtoS( dDataBase )									// 6 - 27 - Fecha de Generacion del Archivo
	cHeader     += Space(1)												// 7 - 35 - Refresh de Deuda
	cHeader     += "O"                                      	// 8 - 36 - Tipo de Publicacion 
	cHeader     += "P"                                      	// 9 - 37 - Tipo de Archivo
	
	cHeader     := PadR( cHeader, 800 ) + cCRLF					// 10 - 38 - Filler

	FWrite( nHnd, cHeader )

Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N: GENTRAILER	|	FECHA:	24/04/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Genero el trailer para el archivo.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function GenTrailer()

	// REGISTRO TRAILER
	cTrailer	:= "T"                                      	// 1 - Pos: 1 - Tipo de Registro
	cTrailer	+= SubStr(StrTran(SM0->M0_CGC,'-',''),1,11)	// 2 - Pos: 2 - CUIT
	cTrailer	+= cNumProd 											// 3 - Pos: 13 - Numero de Producto al cual esta vinculado el Convenio
	cTrailer	+= cNumConv 											// 4 - Pos: 16 - Numero de Convenio
	cTrailer	+= PADR( cValToChar(nRef1), 5 )					// 5 - Pos: 22 - Numero de Envio
	cTrailer	+= DtoS( dDataBase )									// 6 - Pos: 27 - Fecha de GeneraciÛn de Archivo
	cTrailer	+= Num2Str( nCantReg, 5, 0 )                	// 7 - Pos: 35 - Cantidad de Registros
	cTrailer	+= Num2Str( nTotImp, 15, 2 )                	// 8 - Pos: 40 - Total Importe

	cTrailer	:= PadR( cTrailer, 800 ) //+ cCRLF            	// 9 - Pos: 57 - Filler

	FWrite( nHnd, cTrailer )  

	IF nHnd > 0
		MsgInfo("Se generÛ el archivo con correcamente"+cCRLF+"Path: "+cDirTXT+""+cCRLF+"Archivo: "+cArchivo+;
		cCRLF+"Cantidad de registros: "+cValToChar(nCantReg)+cCRLF+"Total: "+cValToChar(nTotImp))
	EndIF

	FClose( nHnd )

	DbSelectArea(TMP)
	DbCloseArea()

Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N: VALIDDATOS	|	FECHA:	25/04/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Genero los parametros.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function ValidDatos()
Local lRet := .F.
Local cOrdPago := ""

	DbSelectArea(TMP)
	DbGoTop()

	While !(TMP)->(Eof())
		// Si el filtro lo aplico en la query es mejor!!
		IF !Empty((TMP)->E2_BAIXA)   // Verifico que no haya sido dado de baja
      	DbSkip()
      	loop
	   EndIF  
	   

		cOrdPago := (TMP)->EK_ORDPAGO
		SA2->(DbSetOrder(1))
		SA2->(DbSeek(xFilial('SA2')+(TMP)->EK_FORNEPG + (TMP)->EK_LOJAPG))

		IF Empty(SA2->A2_CGC)
			lRet   := .T.
			AutoGrLog( "OP " + cOrdPago + " => Proveedor: "+SA2->A2_COD +"/"+ SA2->A2_LOJA+" - "+SA2->A2_NOME+" Sin C.U.I.T." )
		EndIF

		IF Empty(SA2->A2_EMAIL)
			lRet   := .T.
			AutoGrLog( "OP " + cOrdPago + " => Proveedor: "+SA2->A2_COD +"/"+ SA2->A2_LOJA+" - "+SA2->A2_NOME+" Sin E-Mail" )
		EndIf

		IF !IsEmail(ALLTRIM(SA2->A2_EMAIL))	// ANDRES LOVOS - 11/09/2014 - Valido que el email sea valido.
			lRet   := .T.
			AutoGrLog( "OP " + cOrdPago + " => Proveedor: "+SA2->A2_COD +"/"+ SA2->A2_LOJA+" - "+SA2->A2_NOME+" E-Mail no valido" )
		EndIF

		IF Empty(SA2->A2_END)
			lRet   := .T.
			AutoGrLog( "OP " + cOrdPago + " => Proveedor: "+SA2->A2_COD +"/"+ SA2->A2_LOJA+" - "+SA2->A2_NOME+" Sin Direccion" )
		EndIF

		IF Empty(SA2->A2_CEP)
			lRet   := .T.
			AutoGrLog( "OP " + cOrdPago + " => Proveedor: "+SA2->A2_COD +"/"+ SA2->A2_LOJA+" - "+SA2->A2_NOME+" Sin Codigo postal" )
		EndIF
		
		IF SA2->A2_CEP="9999" .or. VAL(SA2->A2_CEP)=0 .OR. LENGTH(ALLTRIM(SA2->A2_CEP))<>4
			lRet   := .T.
			AutoGrLog( "OP " + cOrdPago + " => Proveedor: "+SA2->A2_COD +"/"+ SA2->A2_LOJA+" - "+SA2->A2_NOME+"Codigo postal Invalido" )
		EndIF

		// IF lCustom
		// 	IF Empty(SA2->A2_XLUGBCO)
		// 		lRet   := .T.
		// 		AutoGrLog( "OP " + cOrdPago + " => Proveedor: "+SA2->A2_COD +"/"+ SA2->A2_LOJA+" - "+SA2->A2_NOME+" Sin Lugar de distribucion" )
		// 	EndIF
		// EndIF

		IF Empty(SA2->A2_MUN)
			lRet   := .T.
			AutoGrLog( "OP " + cOrdPago + " => Proveedor: "+SA2->A2_COD +"/"+ SA2->A2_LOJA+" - "+SA2->A2_NOME+" Sin Localidad" )
		EndIF

		IF Empty(SA2->A2_EST)	// A2_ESTADO
			lRet   := .T.
			AutoGrLog( "OP " + cOrdPago + " => Proveedor: "+SA2->A2_COD +"/"+ SA2->A2_LOJA+" - "+SA2->A2_NOME+" Sin Provincia" )
		EndIF
		
		/* 
		IF Empty(SA2->A2_CBU) .AND. SA2->A2_XFORPAG=="2"	// A2_XCBU
			lRet   := .T.
			AutoGrLog( "OP " + cOrdPago + " => Proveedor: "+SA2->A2_COD +"/"+ SA2->A2_LOJA+" - "+SA2->A2_NOME+" Sin CBU" )
		EndIF
		
		IF !Empty(SA2->A2_CBU) .AND. SA2->A2_XFORPAG$"2,3"	                                   
			if !ValidCbu (SA2->A2_CBU)
			lRet   := .T.
			endif
			AutoGrLog( "OP " + cOrdPago + " => Proveedor: "+SA2->A2_COD +"/"+ SA2->A2_LOJA+" - "+SA2->A2_NOME+" CBU INVALIDO" )
		EndIF
		IF (Empty(SA2->A2_XCTABAN) .OR. VAL(SA2->A2_XCTABAN)==0 ) .AND. SA2->A2_XFORPAG=="3"	// A2_XCBU
			lRet   := .T.
			AutoGrLog( "OP " + cOrdPago + " => Proveedor: "+SA2->A2_COD +"/"+ SA2->A2_LOJA+" - "+SA2->A2_NOME+" Sin CUENTA" )
		EndIF
		*/
		(TMP)->(DbSkip())
	EndDo

	DbSelectArea(TMP)
	DbGoTop()

	IF Empty(cNumProd)
		lRet   := .T.
		AutoGrLog( "El parametro 'IT_XPRODCV', no esta dado de alta" )
	EndIF
	
	IF Empty(cNumConv)
		lRet   := .T.
		AutoGrLog( "El parametro 'IT_XNUMCNV', no esta dado de alta" )
	EndIF

Return lRet



/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N: GENCUERPO	|	FECHA:	24/04/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Genero los parametros.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function GenCuerpo()
Local aDatDet := {}
Local aDatRet := {}

Local cSEkNum := ""
Local cNum	:= ""

Local nRecnoS := 0

	IF nHnd > 0
		DbSelectArea(TMP)
		DbGoTop()

		While !(TMP)->(Eof())
			// Si el filtro lo aplico en la query es mejor!!
			IF !Empty((TMP)->E2_BAIXA)   // Verifico que no haya sido dado de baja
   	   	DbSkip()	// voy al siguiente registro
      		loop	// vuelvo al principio del While.
		   EndIF
		   

		   cOrdPago := (TMP)->EK_ORDPAGO
		   cFornece := (TMP)->EK_FORNEPG
		   cLoja    := (TMP)->EK_LOJAPG 
		   dEmissao := (TMP)->EK_DTDIGIT
		   aDet     := {}
		   aPag     := {}
		   aRet     := {}
			aDatDet	:= {}
			aDatRet	:= {}

			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial('SA2')+(TMP)->EK_FORNEPG + (TMP)->EK_LOJAPG))
						
			While !(TMP)->(Eof()) .and. cOrdPago == (TMP)->EK_ORDPAGO
				SEK->(DbGoTo((TMP)->RECSEK))

				IF AllTrim(SEK->EK_NUM) != "NORET"
					// Busco los datos del detalle.
					aDatDet := BuDatAux( (TMP)->EK_ORDPAGO, 'TB' )

					// Busco las retenciones.
					aDatRet := BuDatAux( (TMP)->EK_ORDPAGO, 'RG' )

					FOR nX := 1 To Len(aDatDet)
						IF aDatDet[nX][1] == 'TB'
							IF AllTrim( aDatDet[nX][2] ) $ 'NF/NCP/NDP/PA/NCI/NDI'	// ANDRES LOVOS - 11/09/2014 - Se agrego el tipo NCI.
								Aadd( aDet, aDatDet[nX][3] )
							EndIF
						EndIF
					Next nX

					IF (TMP)->EK_TIPODOC == 'CP' .AND. AllTrim( (TMP)->EK_TIPO ) $ "CH/TF"
						AADD( aPag, (TMP)->RECSEK )
					EndIF

					FOR nX := 1 To Len(aDatRet)
						IF aDatRet[nX][1] == 'RG' 
							IF AllTrim( aDatRet[nX][2] ) $ 'SS-/SU-/SL-/SI-/IB-/IV-/GN-'
								IF aDatRet[nX][4] != cNum	// ANDRES LOVOS - 01/10/2014 - Para no repetir los comprobantes y acumularlos.
									AADD( aRet, aDatRet[nX][3] )
								EndIF

								cNum := aDatRet[nX][4]
							EndIF
						EndIF
					Next nX

					IF Len( aDet ) > 0
						SEK->(DbGoTo(aDet[1])) 
					ElseIf Len( aPag ) > 0
						SEK->(DbGoTo(aPag[1])) 
					EndIf

					// REGISTRO DE CLIENTES
					cClientes   := "C"												// 1 - 1 - Tipo de Registro
					cClientes   += "A"												// 2 - 2 - Tipo de Accion
					cClientes   += PadR( AllTrim(SA2->A2_COD), 22 )			// 3 - 3 - Id Cliente 
					cClientes   += PadR( AllTrim(SA2->A2_NOME), 60 )		// 4 - 25 - Razon Social
					cClientes   += "CT"												// 5 - 85 - Tipo de Documento
					cClientes   += PadR( AllTrim(SA2->A2_CGC), 11 )			// 6 - 87 - Numero de Documento
					cClientes   += PadR( AllTrim(SA2->A2_CGC), 11 )			// 7 - 98 - Numero de CUIT
					cClientes   += PadR( AllTrim(SA2->A2_END), 30 )			// 8 - 109 - Calle
					cClientes   += Space(06)										// 9 - 139 - Numero
					cClientes   += Space(06)										// 10 - 145 - Piso
					cClientes   += Space(06)										// 11 - 151 - Departamento
					cClientes   += PadR( "0"+AllTrim(SA2->A2_CEP), 8 )			// 12 - 162 - Codigo Postal
					cClientes   += Space(01)										// 13 - 165 - Imprime / ReImprime Tarjeta
					cClientes   += Space(40)										// 14 - 166 - Forma Pago del Cliente
					cClientes   += Space(26)										// 15 - 206 - CBU de Debito del Cliente 1
					cClientes   += Space(26)										// 16 - 232 - CBU de Debito del Cliente 2
//LP 28/11/2014					IF lCustom
//LP 28/11/2014						cClientes   += PadR( AllTrim(SA2->A2_XLUGBCO), 2 )	// 17 - 258 - Tipo de Distribucion
//LP 28/11/2014					Else
						cClientes   += "00"
//LP 28/11/2014					EndIF
//					cClientes   += PadL( AllTrim(SA2->A2_AGENCIA), 4)		// 18 - 260 - Sucursal de Distribucion
//LP 28/11/2014					cClientes   += PadL( AllTrim((TMP)->EK_AGENCIA), 4)		// 18 - 260 - Sucursal de Distribucion
//LP 28/11/2014					cClientes   += Space(04)		// 18 - 260 - Sucursal de Distribucion
					cClientes   += "0824"		// 18 - 260 - Sucursal de Distribucion
					cClientes   += Space(02)										// 19 - 264 - Documentacion a Solicitar
					cClientes   += PadR( SA2->A2_TEL, 20 )						// 20 - 266 - Telefono Beneficiario
					cClientes   += PadR( SA2->A2_EMAIL, 100 )					// 21 - 286 - E-Mail Beneficiario   
					cClientes   += PadR( SA2->A2_MUN, 50 )						// 22 - 386 - Localidad
					cClientes   += PadR( Tabela( '12', SA2->A2_EST, .F. ), 50 )	// 23 - 436 - Provincia
// LP					cClientes   += DtoS( DataValida(STOD((TMP)->EK_EMISSAO)) )	// 24 - 486 - Fecha de Emision
					cClientes   += DtoS( dDataBase )	// 24 - 486 - Fecha de Emision
					cClientes   += PadR( SEK->EK_ORDPAGO, 30)					// 25 - 494 - Libre 1
					cClientes   += Space(30)										// 26 - 524 - Libre 2
					cClientes   += Space(30)										// 27 - 554 - Libre 3
//					cClientes   += "_"												// 28 - 584 - Publica IBE
					cClientes   += Space(1)											// 28 - 584 - Publica IBE
					cClientes   := PadR( cClientes, 800 ) + cCRLF			// 29 - 585 - Filler
				
					FWrite( nHnd, cClientes )	// Grabo los clientes.
				
					nCantReg++  //Clientes

					// REGISTRO DE FORMAS DE PAGO
					For nX := 1 To Len( aPag )

						SEK->(DbGoTo(aPag[nX])) 

						cFormPag    := "F"										// 1 - Pos: 1 - Tipo de Registro
						If  substr(SA2->A2_CBU,1,3)="259"   
							cFormPag    += FormPago("TF")				// 2 - Pos: 2 - Forma de Pago
						Else
							cFormPag    += FormPago(SEK->EK_TIPO)				// 2 - Pos: 2 - Forma de Pago
						ENDIF
           				IF cFrmPago = "TF"
							cFormPag    += PadR( SA2->A2_CBU, 22 )          // 3 - Pos: 4 - Id Instrumento CBU
						// ELSEIF cFrmPago = "TFS"
							//cFormPag    += PadR( SA2->A2_CBU, 22 )          // 3 - Pos: 4 - Id Instrumento CBU
//							cFormPag    += PadR( SA2->A2_XCTABAN, 22 )          // 3 - Pos: 4 - Id Instrumento CBU
						ELSE
							cFormPag    += Space(22)                        // 3 - Pos: 4 - Id Instrumento					
						ENDIF
						cFormPag    += Space(7)                         // 4 - Pos: 26 - Reservado Uso Futuro
						cFormPag    += Num2Str( SEK->EK_VALOR, 15, 2 )	// 5 - Pos: 33 - Importe
						cFormPag    += Space(17)                        // 6 - Pos: 50 - Importe Adelanto
					 //	cFormPag    += DtoS( SEK->EK_VENCTO )           // 7 - Pos: 67 - Fec. Pago del Instrumento
					 	IF cFrmPago = "TF"
//LP 28/11/2014							cFormPag    += DtoS( dDataBase +2 )           // 7 - Pos: 67 - Fec. Pago del Instrumento TFC
						    if CDOW (dDataBase +2)="Sunday"
								cFormPag    += DtoS( dDataBase +4 )           // 7 - Pos: 67 - Fec. Pago del Instrumento TFC
							elseif	CDOW (dDataBase +2)="Saturday"
								cFormPag    += DtoS( dDataBase +5 )           // 7 - Pos: 67 - Fec. Pago del Instrumento TFC
							else
 							    cFormPag    += DtoS( dDataBase +2 )           // 7 - Pos: 67 - Fec. Pago del Instrumento TFC
							endif	                             
							
						//ELSEIF cFrmPago = "TFS"
							//cFormPag    += DtoS( dDataBase )			// 7 - Pos: 67 - Fec. Pago del Instrumento TFS
						ELSE 
							cFormPag    += DtoS( SEK->EK_VENCTO )        // 7 - Pos: 67 - Fec. Pago del Instrumento Cheque						                 
						ENDIF
        	    		cFormPag    += Space(2)                         // 8 - Pos: 75 - Tipo de Emision
	        	    
						cFormPag    := PadR( cFormPag, 800 ) + cCRLF    // 9 - 77 - Filler

    		        	FWrite( nHnd, cFormPag )	// Grabo la forma de pago.

						nTotImp     += SEK->EK_VALOR

						nCantReg++ //Formas de pago

					Next

					// REGISTRO DE DETALLE DE PAGO
					For nX := 1 To Len( aDet )
						SEK->(DbGoTo(aDet[nX]))

						cDetPag     := "D"										// 1 - 1 - Tipo de Registro
						cDetPag     += Space(01)								// 2 - 2 - Tipo de Accion
						cDetPag     += GetTypeAndDoc(1)						// 3 - 3 - Tipo de Documento                 
						cDetPag     += PadR( SEK->EK_NUM, 22 )				// 4 - 5 - Nro de Documento
//						cDetPag     += Space(03)								// 5 - 27 - Cuota
						cDetPag     += Num2Str(0,3,0)							// 5 - 27 - Cuota
						cDetPag     += Space(22)								// 6 - 30 - Id Cliente
						cDetPag     += Space(60)								// 7 - 52 - Razon Social
						cDetPag     += Space(02)								// 8 - 112 - Tipo Documento
//						cDetPag     += Space(11)								// 9 - 114 - Nro Documento
						cDetPag     += Num2Str(0,11,0)						// 9 - 114 - Nro Documento
						cDetPag     += Space(01)								// 10 - 125 - Imprime
	        		    cDetPag     += Space(40)								// 11 - 126 - Forma de Pago del Cliente
						cDetPag     += Space(08)								// 12 - 166 - Fecha Hasta Pago Adelantado
//						cDetPag     += Space(17)								// 13 - 174 - Importe Pago Adelantado
						cDetPag     += Num2Str(0,17,0)		            // 13 - 174 - Importe Pago Adelantado
//      	  	    	cDetPag     += Space(07)							// 14 - 191 - % de Descuento Pago Adelantado
        		    	cDetPag     += Num2Str(0,7,0)							// 14 - 191 - % de Descuento Pago Adelantado
//						cDetPag     += Space(17)								// 15 - 198 - Importe Parcial Minimo
						cDetPag     += Num2Str(0,17,0)						// 15 - 198 - Importe Parcial Minimo
						cDetPag     += DtoS( SEK->EK_VENCTO )				// 16 - 215 - Fecha Vencimiento 1
						cDetPag     += Num2Str( SEK->EK_VALOR, 15, 2 )	// 17 - 223 - Importe
//    		        	cDetPag     += Space(08)							// 18 - 240 - Fecha Vencimiento 2
    	    	    	cDetPag     += Num2Str(0,8,0)  		 		      // 18 - 240 - Fecha Vencimiento 2
						cDetPag     += Num2Str(0,17,0)								// 19 - 248 - Importe Vencimiento 2
						cDetPag     += Num2Str(0,7,0)								// 20 - 265 - % Recargo Vecimiento 2
//	        	    	cDetPag     += Space(08)								// 21 - 272 - Fecha Vencimiento 3
						cDetPag     += Num2Str(0,8,0) 						// 21 - 272 - Fecha Vencimiento 3
     					cDetPag     += Num2Str(0,17,0)								// 22 - 280 - Importe Vencimiento 3
						cDetPag     += Num2Str(0,7,0)								// 23 - 297 - % Recargo Vecimiento 3
//						cDetPag     += Space(08)								// 24 - 304 - Fecha Vencimiento Punitorios
						cDetPag     += Num2Str(0,8,0)							// 24 - 304 - Fecha Vencimiento Punitorios
						cDetPag     += Num2Str(0,17,0)								// 25 - 312 - Importe Vencimiento Punitorios
						cDetPag     += Num2Str(0,7,0)								// 26 - 329 - % Recargo Vecimiento Punitorios
						cDetPag     += Space(02)								// 27 - 336 - Tipo de Documento Asociado
						cDetPag     += Space(22)								// 28 - 338 - Numero de Documento Asociado

						cDetPag     := PadR( cDetPag, 800 ) + cCRLF     // 29 -  - Filler

						FWrite( nHnd, cDetPag )	// Grabo el detalle de pagos.

						nCantReg++      //Detalle de pago
					Next

					// REGISTRO DE IMPRESIONES
					For nX := 1 To Len( aRet )
						SEK->(DbGoTo(aRet[nX])) 
/**						IF nX > 1
							cSEkNum := SEK->EK_NUM
						EndIF
						
						IF cSEkNum == SEK->EK_NUM
							Skip()
							Loop
						EndiF
**/
						// PRIMERA SECCION
						cImp	:= SECCION1( SEK->EK_ORDPAGO, SEK->EK_NUM )

						// SEGUNDA SECCION
						cImp	+= SECCION2( SEK->EK_ORDPAGO, SEK->EK_FORNECE, SEK->EK_LOJA, SEK->EK_NUM, SEK->EK_NROCERT )	// ANDRES LOVOS - 11/09/2014 - Adiciono el Proveedor y la Loja.

						// TERCERA SECCION
						cImp	+= SECCION3( SEK->EK_ORDPAGO, SEK->EK_NUM )

						// CUARTA SECCION
						cImp	+= SECCION4( SEK->EK_ORDPAGO, SEK->EK_NUM )

						// QUINTA SECCION
						cImp	+= SECCION5()

			            FWrite( nHnd, cImp )	// Grabo las impresiones
//						nCantReg++
					Next

//LP					IF !lProcesado	// Si no tengo en cuenta los reprocesos, no lo tengo en cuenta para actualizarlo.
						ActuaSEK(nRenglon, nRef1)  // ACTUALIZO AUNQUE SEA REPROCESO PORQUE LE ASIGNO UN NUEVO NUMERO
//LP					EndIF

					nRenglon++				
				EndIF
				(TMP)->(DbSkip())
			EndDo	// WHILE TMP
		EndDo
	EndIF

Return


// Busco los datos que no obtengo de la query principal
Static Function BuDatAux( cOrdPago, cTipoDoc )
Local aArea := GetArea()
Local aAreaSEK := SEK->(GetArea())
Local TMP_SEK	:= GetNextAlias()
Local cQry		:= ""
Local cTipDoc	:= ""
Local cTipo		:= ""
Local cNum		:= ""

Local aRet		:= {}
Local nRecno	:= 0
Local lEncontre := .F.


	IF Select(TMP_SEK) > 0
		DbSelectArea(TMP_SEK)
		DbCloseArea()
	EndIF

	cQry := "SELECT EK_TIPODOC EKTIPODOC, EK_TIPO EKTIPO, R_E_C_N_O_ RECNO_SEK, EK_NUM EKNUM "+CRLF
	cQry += "FROM "+RetSqlName("SEK")+" SEK "+CRLF
	cQry += "WHERE D_E_L_E_T_ <> '*' "+CRLF
	cQry += "AND EK_ORDPAGO = '"+cOrdPago+"' "+CRLF
	cQry += "AND EK_TIPODOC = '"+cTipoDoc+"' "+CRLF       
	cQry += "AND EK_NUM <> 'NORET' "+CRLF
	cQry += "ORDER BY R_E_C_N_O_ "+CRLF

	cQry := ChangeQuery(cQry)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), TMP_SEK, .F., .T.)

	DbSelectArea(TMP_SEK)
	DbGoTop()
/**
	IF !(TMP_SEK)->(EOF())
		cTipoDoc	:= (TMP_SEK)->EKTIPODOC
		cTipo		:= (TMP_SEK)->EKTIPO
		nRecno	:= (TMP_SEK)->RECNO_SEK
	EndIF
	AADD(aRet, cTipoDoc)
	AADD(aRet, cTipo)
	AADD(aRet, nRecno)
**/
	WHILE !(TMP_SEK)->(EOF())
		lEncontre := .T.
		
		AADD(aRet, { (TMP_SEK)->EKTIPODOC, (TMP_SEK)->EKTIPO, (TMP_SEK)->RECNO_SEK, (TMP_SEK)->EKNUM })
		
		(TMP_SEK)->(DbSkip())
	EndDo
	
	IF !lEncontre
		AADD(aRet, { cTipoDoc, cTipo, nRecno, cNum })
	EndIF

	IF Select(TMP_SEK) > 0
		DbSelectArea(TMP_SEK)
		DbCloseArea()
	EndIF

RestArea(aAreaSEK)
RestArea(aArea)

Return aRet


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N: FormPago	|	FECHA:	25/04/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Codifico la forma de pago segun el formato de archivo de banco ITAU.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function FormPago(cEkTipo)
Local cRet := ""

	Do Case
		Case cEkTipo == "TF"
			cRet := "14"
		Case cEkTipo == "TFC"
			cRet := "15"
		Case cEkTipo == "CH"
			cRet := "18"
	End Case
		
Return cRet

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N: GENTYPEANDDOC	|	FECHA:	25/04/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function GetTypeAndDoc( nRet )
Local cRet  := ''

	If nRet == 1 
   		If AllTrim( SEK->EK_TIPO ) == 'NF'
      		cRet  := 'FC'
		ElseIf AllTrim( SEK->EK_TIPO ) == 'NDC' .OR. AllTrim( SEK->EK_TIPO ) == 'NDI' 
      		cRet  := 'ND'
		ElseIf AllTrim( SEK->EK_TIPO ) == 'NCC' .OR. AllTrim( SEK->EK_TIPO ) == 'NCI'  
      		cRet  := 'NC'
		ElseIf AllTrim( SEK->EK_TIPO ) == 'PA' 
      		cRet  := 'OP'
	   Else
    	  cRet  := 'FC'
	   EndIf
	Else
		If AllTrim( SEK->EK_TIPO ) == 'PA'
			cRet  := PadR( AllTrim( SEK->EK_ORDPAGO ), 22 )
		Else
			cRet  := PadR( AllTrim( SEK->EK_PREFIXO ) + ' ' + SubStr( SEK->EK_NUM, 1, 4 ) + '-' + SubStr( SEK->EK_NUM, 5, 8 ), 22 )
		EndIf
	EndIf

Return( cRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N: GENPARAM	|	FECHA:	24/04/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Genero los parametros.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function GenParam()

	//Verifica y crea parametro para manejar correlativo de certificados
	DbSelectArea("SX6")
	DbSetOrder(1)
	IF !DbSeek(xFilial("SA6")+"IT_NROPRO")
		RecLock("SX6",.T.)
		Replace SX6->X6_FIL      With xFilial("SA6")
		Replace SX6->X6_VAR      With "IT_NROPRO"
		Replace SX6->X6_TIPO     With "N"
		Replace SX6->X6_DESCRIC  With "Numero de Referencia Secuencial"
		Replace SX6->X6_DSCSPA   With "Numero de Referencia Secuencial"
		Replace SX6->X6_DSCENG   With "Numero de Referencia Secuencial"
		Replace SX6->X6_DESC1    With "para txt del banco Itau"
		Replace SX6->X6_DSCSPA1  With "para txt del banco Itau"
		Replace SX6->X6_DSCENG1  With "para txt del banco Itau"
		Replace SX6->X6_CONTEUD  With "1"
		Replace SX6->X6_CONTSPA  With "1"
		Replace SX6->X6_CONTENG  With "1"
		Replace SX6->X6_PROPRI   With "U"
		SX6->(MsUnlock())
	EndIF

	//Verifica y crea parametro para manejar correlativo de referencia1
	DbSelectArea("SX6")
	DbSetOrder(1)
	IF !DbSeek(xFilial("SA6")+"IT_NROREF1")
		RecLock("SX6",.T.)
		Replace SX6->X6_FIL      With xFilial("SA6")
		Replace SX6->X6_VAR      With "IT_NROREF1"
		Replace SX6->X6_TIPO     With "N"
		Replace SX6->X6_DESCRIC  With "Numero de Ref1 Secuencial"
		Replace SX6->X6_DSCSPA   With "Numero de Ref1 Secuencial"
		Replace SX6->X6_DSCENG   With "Numero de Ref1 Secuencial"
		Replace SX6->X6_DESC1    With "para txt del banco Itau"
		Replace SX6->X6_DSCSPA1  With "para txt del banco Itau"
		Replace SX6->X6_DSCENG1  With "para txt del banco Itau"
		Replace SX6->X6_CONTEUD  With "1"
		Replace SX6->X6_CONTSPA  With "1"
		Replace SX6->X6_CONTENG  With "1"
		Replace SX6->X6_PROPRI   With "U"
		SX6->(MsUnlock())
	ENDIF

Return


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N: ACTUASEK	|	FECHA:	25/04/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Actualiza el registro de la tabla SEK agregando el cheque de la orden de pago
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function ActuaSEK(nRenglon, nRef1)
Local aArea   := GetArea()
Local aAreaSEK:= SEK->(GetArea())
Local cIDITAU :=STRZERO(nRenglon,12)
Local cLoteItau:= nRef1	//StrZero(nRef1,5)

	SEK->(DbGoTo((TMP)->RECSEK))
	RecLock("SEK",.F.)
	SEK->EK_XIDTAU := cIDITAU   // Se completa el registro
	SEK->EK_XLOTITA	:= cLoteItau
	SEK->(MsUnlock())  

RestArea(aAreaSEK)
RestArea(aArea)

Return


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N: IMP	|	FECHA:	08/05/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Seleccion de Tipo de Comprobantes.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function Imp( )
Local cRet  := "  "

	If SEK->EK_TIPODOC == "RG"
   	If SEK->EK_TIPO == "IV-"
      	cRet  := '01'
	   ElseIf SEK->EK_TIPO == "GN-"
   	   cRet  := '02'
	   ElseIf SEK->EK_TIPO == "IB-"
   	   cRet  := '03'
	   ElseIf SEK->EK_TIPO $ "SS-/SU-/SL-/SI-"
   	   cRet  := '04'
	   EndIf
	EndIf
      
Return( cRet )        

/*============================================================================*/
/*Funcion    : CantFirm  |Autor:  Martin Carrozzo     |Data:   19/11/2012     */
/*============================================================================*/
/*Descripcion: Seleccion de cantidad de firmantes.										*/
/*============================================================================*/
Static Function CantFirm()
Local cTitulo   := "Seleccione la cantidad de firmantes"
Local MvPar     := ""
Local MvParDef  := "1 FIRMANTE 2 FIRMANTES 3 FIRMANTES"
Local nTamChave := 11  
Local nMaxSele  := 1    
Local aOpcoes   := {"","",""}
Local nFirmas

    CursorArrow()

    // Crea la pantalla.
    If f_Opcoes( @MvPar , cTitulo , aOpcoes , MvParDef , 12 , 49 , .F. , nTamChave , nMaxSele , .F.,.F.,,.F.,.F.)
        MvPar   := AllTrim(StrTran( MvPar , "*" , "" ))
    Else
        return
        Final("Firmantes por cheque","Anulado por el Usuario.") // Obliga al usuario a salir.
    EndIF
    nFirmas:=( Val(SUBSTR(MvPar,1,1)))
    
    if nFirmas == 0
    	nFirmas:=1
	 endif
	 
Return nFirmas

/*============================================================================*/
/*Funcion    : Firmante  |Autor:  Martin Carrozzo     |Data:   19/11/2012     */
/*============================================================================*/
/*Descripcion: Seleccion de firmantes.														*/
/*============================================================================*/
Static Function Firmante()
Local cTitulo1:= "Seleccione a los firmantes"
Local aFirmant:= {"0","0","0"}
Local MvParDe1:=""    //Array de donde estan los distintos tipos de firmantes posibles
Local nTamCha1:=22
Local MvPar1  :=""
Local aOpcoes1:= {}
    
    DbSelectArea("SX5")
    DbSetOrder(1)  
    if dbSeek(xFilial("SX5")+ "X1"+"1")
    
        while ("SX5")->X5_TABELA == "X1" .AND. ("SX5")->(!EOF()) 
            MvParDe1 += alltrim(("SX5")->X5_CHAVE)+"-"+Padl(substr(("SX5")->X5_DESCRI,1,20),20," ")
            aadd(aOpcoes1,"")
            ("SX5")->(dbskip()) 
        enddo
        
    endif

    CursorArrow()
    // Crea la pantalla.
    If f_Opcoes(@MvPar1,cTitulo1,aOpcoes1,MvParDe1,12,49,.F.,nTamCha1,nCantFir,.F.,.F.,,.F.,.F.)
        MvPar1:=AllTrim(StrTran(MvPar1,"*","" ))
    Else
        Final("Descripcion de los firmantes","Anulado por el Usuario.") // Obliga al usuario a salir.
    EndIF
    
    j:=1
    nfirmaux:=1  
    For i:=1 to nCantFir
         
        if VAL(substr(MvPar1,1*j,1)) > 0
            cFirmante:= substr(MvPar1,1*j,1)
        else
            cFirmante:= ALLTRIM(str(nfirmaux)) //Valor Default ARRANCA EN 1 Y ES UN VALOR QUE SE INCREMENTA SECUENCIALMENTE
            nfirmaux++
        endif
          
        aFirmant[i]:= cFirmante
        j+=22
    next i
    
Return( aFirmant )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N:	NUM2STR	|	FECHA:	24/04/2014 	|	AUTOR:	Andres Lovos	|	CECBA
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function Num2Str( nValor, nInt, nDec )
Local cRet := StrTran( PadL( AllTrim( StrTran( Str( nValor,nInt+nDec+1, nDec), '.', '' ) ), nInt+nDec ), ' ', '0' )
//Local nRet	:= TransForm( nValor, PesqPict("SEK","EK_VALOR") )

//Return nRet
Return cRet

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N:	ValidBanco	|	FECHA:	08/05/2014 	|	AUTOR:	Andres Lovos	|	CECBA
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Valido los bancos ingresados
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function ValidBanco()
Local aArea := GetArea()
Local aAreaSA6 := SA6->(GetArea())
Local cAliaSA6	:= GetNextAlias()
Local lRet	:= .T.
Local cQry	:= ""

	AutoGrLog( "Los siguientes bancos solo se procesan con la rutina antigua, o no tienen rutina asignada.")

	cQry := "SELECT A6_COD, A6_AGENCIA, A6_NUMCON, A6_NOME, A6_XINTPAG "+CRLF
	cQry += "FROM "+RetSqlName("SA6")+" SA6 "+CRLF
	cQry += "WHERE D_E_L_E_T_ <> '*' "+CRLF
	cQry += "AND A6_FILIAL = '"+xFilial("SA6")+"' "+CRLF
	cQry += "AND A6_COD BETWEEN '"		+ MV_PAR03 + "' AND '" + MV_PAR06 + "' "+CRLF
	cQry += "AND A6_AGENCIA BETWEEN '"	+ MV_PAR04 + "' AND '" + MV_PAR07 + "' "+CRLF
	cQry += "AND A6_NUMCON BETWEEN '"	+ MV_PAR05 + "' AND '" + MV_PAR08 + "' "+CRLF

	cQry := ChangeQuery(cQry)

	dbUseArea ( .T., 'TOPCONN', TCGENQRY(,,cQry), cAliaSA6, .F., .T.)   

	DbSelectArea(cAliaSA6)
	DbGoTop()

	WHILE !(cAliaSA6)->(EOF()) .AND. (cAliaSA6)->A6_COD + (cAliaSA6)->A6_AGENCIA + (cAliaSA6)->A6_NUMCON <= MV_PAR04 + MV_PAR06 + MV_PAR08 
		IF Empty((cAliaSA6)->A6_XINTPAG)
			AutoGrLog( "Banco: " + (cAliaSA6)->A6_COD + " - " + AllTrim((cAliaSA6)->A6_NOME) + " - Agencia: " + (cAliaSA6)->A6_AGENCIA + " - Cuenta: " + (cAliaSA6)->A6_NUMCON + "  sin rutina asignada!")
			lRet := .F.
		EndIF

		IF	RTRIM((cAliaSA6)->A6_XINTPAG) <> "007"	// 007-ITAU
			AutoGrLog( "Banco: " + (cAliaSA6)->A6_COD + " - " + AllTrim((cAliaSA6)->A6_NOME) + " - Agencia: " + (cAliaSA6)->A6_AGENCIA + " - Cuenta: " + (cAliaSA6)->A6_NUMCON)
			lRet := .F.
		EndIF

		(cAliaSA6)->(DbSkip())
	EndDo

	AutoGrLog( "Fin de bancos.")

	If !lRet
   	AutoGrLog( "Fecha Fin..........: " + Dtoc(MsDate()) )
	   AutoGrLog( "Hora Fin...........: " + Time() )

   	cFileLog := NomeAutoLog()

	   IF cFileLog <> ""
   	     MostraErro( "", cFileLog)
      	  FErase( cFileLog )
	    EndIF
	EndIF

	(cAliaSA6)->(DbCloseArea())

RestArea(aAreaSA6)
RestArea(aArea)

Return


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N:	SECCFIJA	|	FECHA:	08/08/2014 	|	AUTOR:	Andres Lovos	|	CECBA
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Genero la seccion fija de la impresion.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function SECCFIJA()
Local cRet := ""

   cRet 	:= "I"											// Fijo - 1 a 1
	cRet	+= Imp( )										// Fijo - 2 a 3
	cRet	+= PadR( AllTrim( SEK->EK_NUM ), 22 )	// Fijo - 4 a 26
	cRet	+= Num2Str( SEK->EK_VALOR, 15, 2 )		// Fijo - 27 a 43
 
nCantReg++	// Incremento la cantidad de los registros.

Return cRet


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N:	SECCION1	|	FECHA:	08/08/2014 	|	AUTOR:	Andres Lovos	|	CECBA
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Genero la primera seccion de la impresion.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function SECCION1( cOrdPag, cEkNum )
Local cSec		:= ""
Local cDesRet	:= ""
Local aSFE 		:= {}

	cSec := SECCFIJA()
	
	aSFE := BUSFE( cOrdPag, cEkNum )
	cDesRet := AllTrim( aSFE[5] )

//	cSec += PADR( Space(50)+"FECHA DE RETENCION: " + DTOC( dDataBase ), 80 )
	cSec += PADR( Space(12)+"FECHA DE RETENCION: " + DTOC( aSFE[7] ) + " - Nro. Certificado: " + aSFE[6], 80 )
	cSec += PadR( AllTrim( SM0->M0_NOMECOM ), 80 )
	cSec += PadR( AllTrim( SM0->M0_ENDENT ), 80 )
	cSec += PadR( AllTrim( SM0->M0_CIDCOB ), 80 )
	cSec += PadR( "C.U.I.T. : " + AllTrim( SM0->M0_CGC ), 80 )
	cSec += Space(80)
	cSec += Space(80)
	cSec += PADR( Space(11)+"CONSTANCIA DE RETENCION " + cDesRet, 80 )
   cSec := PADR( cSec, 800 ) + cCRLF

Return cSec


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N:	SECCION2	|	FECHA:	08/08/2014 	|	AUTOR:	Andres Lovos	|	CECBA
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Genero la segunda seccion de la impresion.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function SECCION2( cOrdPag, cEKFORNECE, cEKLOJA, cEkNum, cEkNroCert )
Local aArea	:= GetArea()
Local aAreaSEK	:= SEK->( GetArea() )
Local aAreaSA2	:= SA2->( GetArea() )
Local cSec	:= ""
Local aSFE := {}

Default cEkNroCert := ""

	cSec := SECCFIJA()

	aSFE := BUSFE( cOrdPag, cEkNum )


	// ANDRES LOVOS - 11/09/2014 - Para posicionarme correctamente en la tabla de proveedores.
	// Soluciona el error de que siempre imprime CLIENTE DE PRUEBA.
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbSeek(xFilial("SA2") + cEKFORNECE + cEKLOJA )

  	cSec += Replicate("-", 80 )
  	cSec += Space(80)
  	cSec += PADR( AllTrim( SA2->A2_NOME ), 80)
  	cSec += PADR( AllTrim( SA2->A2_END ), 80)
  	cSec += PADR( "C.U.I.T. : " + SA2->A2_CGC, 80 )
//  	cSec += PADR( "Nro de Certificado: " + cEkNroCert, 80 )
  	cSec += Space(80)
  	cSec += PADR( "Retencion: " + aSFE[5], 80 )
  	cSec += PADR( "Jurisdiccion: " + SA2->A2_MUN, 80 )
  	cSec += Space(80)
	cSec := PADR( cSec, 800 ) + cCRLF


RestArea(aAreaSA2)
RestArea(aAreaSEK)
RestArea(aArea)
 
Return cSec


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N:	SECCION3	|	FECHA:	08/08/2014 	|	AUTOR:	Andres Lovos	|	CECBA
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Genero la tercera seccion de la impresion.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function SECCION3 (cOrdPag, cEkNum )
Local cSec		:= ""
Local cSec1		:= ""
Local aDocSFE	:= {}

Local nX		:= 1

	cSec := SECCFIJA()

	aDocSFE := BuDocSFE( cOrdPag )

	cSec += Replicate("-", 80)
	cSec += PADR("Documento", 80)	// ANDRES LOVOS - 01/10/2014 + Space(39) + "Fecha" + Space(19) + "Importe"
 
	FOR nX := 1 To Len(aDocSFE)
//		cSec += PADR( aDocSFE[nX][1], 80 )
    if nX =36      // si supera los 35 documentos cierro esta linea y abro una nueva lienta de imprasion
			cSec1 := PADR( cSec, 800 ) + cCRLF    
			cSec := SECCFIJA()
    endif 
		cSec += PADR( aDocSFE[nX][1], 16 )
	Next nX

	cSec += Space(762-Len(cSec))
//	cSec += Replicate("-", 80 )
	cSec := PADR( cSec, 800 ) + cCRLF
	cSec := cSec1 + cSec
Return cSec


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N:	SECCION4	|	FECHA:	08/08/2014 	|	AUTOR:	Andres Lovos	|	CECBA
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Genero la cuarta seccion de la impresion.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function SECCION4( cOrdPag, cEkNum )
Local cSec	:= ""
Local aSFE	:= {}

	cSec := SECCFIJA()

	// Busco los datos de la SFE.
	aSFE := BUSFE( cOrdPag, cEkNum )

	nValPag := aSFE[2]

   cSec += Replicate("-", 80 )
   cSec += PADR( "Concepto de la Retencion: " + aSFE[4], 80 )
//   cSec += PADR( "Base Retencion: " + Num2Str( aSFE[1], 15, 2 ), 80 )
cSec += PADR( "Base Retencion: " + TransForm( aSFE[1], PesqPict("SFE","FE_VALBASE") ), 80 ) 
//   cSec += PADR( "Importe Retenido: " + Num2Str( aSFE[2], 15, 2 ), 80 )
   cSec += PADR( "Importe Retenido: " + TransForm( aSFE[2], PesqPict("SFE","FE_RETENC") ), 80 )
//   cSec += PADR( "Alicuota: " + Num2Str( aSFE[3], 15, 2 ), 80 )
   cSec += PADR( "Alicuota: " + TransForm( aSFE[3], PesqPict("SFE","FE_ALIQ") )+"%", 80 )
   cSec += Space(80)
   cSec := PADR( cSec, 800 ) + cCRLF

Return cSec

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N:	ValidCBU	|	FECHA:	08/01/2015 	|	AUTOR:	luis porati	|	CECBA
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Genero la cuarta seccion de la impresion.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function ValidCbu ( NumCbu )
Local lOkCbu	:= .T.
Local cCbu1 :=substr(NumCbu,1,8)
Local cCbu2 :=substr(NumCbu,9,14)
Local aCbu1 :={}
Local aCbu2 :={}

for Xi:=1 to 8
     Aadd( aCbu1, val(substr(cCbu1,Xi,1)) )
next
for Xj:=1 to 14
     Aadd( aCbu2, val(substr(cCbu2,Xj,1)) )
next                             
     nSum1 := aCbu1[1] *7 + aCbu1[2] *1 + aCbu1[3] *3 + aCbu1[4] *9 + aCbu1[5] *7 + aCbu1[6] *1 + aCbu1[7] *3 + aCbu1[8]
//     nDV1 := 10- val( substr(cValToChar(nSum1),len(cValToChar(nSum1)),1))
//     if   nDV1 <> aCbu1[8]
    if val( substr(cValToChar(nSum1),len(cValToChar(nSum1)),1)) <> 0
	     lOkCbu:=.F.
     endif

     nSum2 := aCbu2[1] *3 + aCbu2[2] *9 + aCbu2[3] *7 + aCbu2[4] *1 + aCbu2[5] *3 + aCbu2[6] *9 + aCbu2[7] *7 + aCbu2[8] *1 + aCbu2[9] *3 + aCbu2[10] *9 + aCbu2[11] *7 + aCbu2[12] *1 + aCbu2[13] *3 + aCbu2[14]
//     nDV2 := 10- val( substr(cValToChar(nSum2),len(cValToChar(nSum2)),1))
//     if   nDV2 <> aCbu2[14]
    if val( substr(cValToChar(nSum2),len(cValToChar(nSum2)),1)) <> 0
	     lOkCbu:=.F.
     endif

Return lOkCbu


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N:	SECCION5	|	FECHA:	08/08/2014 	|	AUTOR:	Andres Lovos	|	CECBA
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Genero la quinta seccion de la impresion.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function SECCION5()
Local cSec	:= ""

	cSec := SECCFIJA()
	cSec += Replicate("-", 80 )
	cSec += Space(80)
	cSec += PADR( "Este certificado es de la orden de pago Nro " + SEK->EK_ORDPAGO, 80 ) //+ " pagada el " + DTOC( dDataBase ), 80 )
//	cSec += PADR( "de $ " + Num2Str( SEK->EK_VALOR, 15, 2 ), 80 )
	cSec += Space(80)	//PADR( "de $ " + TransForm( nValPag, PesqPict("SEK","EK_VALOR") ), 80 )	ANDRES LOVOS 01/09/2014 a Pedido de Luis Porati.
//	cSec += PADR( "de $ " + TransForm( SEK->EK_VALOR, PesqPict("SEK","EK_VALOR") ), 80 )
	
	cSec += Replicate("-", 80 )
   cSec := PADR( cSec, 800 ) + cCRLF

Return cSec


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N:	BUSFE	|	FECHA:	08/08/2014 	|	AUTOR:	Andres Lovos	|	CECBA
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Busco los datos en la tabla SFE.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function BUSFE( cOrdPag, cEkNum )
Local aArea	:= GetArea()
Local aAreaSEK	:= SEK->( GetArea() )
Local aAreaSA2	:= SA2->( GetArea() )
Local aAreaSFE	:= SFE->( GetArea() )

Local nReteCom	:= 0
Local nBaseRet	:= 0
Local nPorcAliq	:= 0
Local nCF		:= 0

Local cImpuCom	:= ""
Local cRegiCom	:= ""
Local cProv		:= ""
Local cNroCert	:= ""
Local c_numcert	:= ""
Local quecom	:= cOrdPag
Local dEmision	:= CTOD("  /  /  ")


	dbSelectArea( "SFE" )
	DbSetOrder(2)
	IF DbSeek( xFilial("SFE") + cOrdPag, .T. )
	
		WHILE !SFE->(EOF()) .AND. quecom == SFE->FE_ORDPAGO  //.AND. ALLTRIM(SFE->FE_NROCERT) <> 'NORET'
			IF AllTrim( SFE->FE_NROCERT ) == "NORET"
				SFE->(DbSkip())
				Loop
			EndIF

			IF cEkNum != SFE->FE_NROCERT
				SFE->(DbSkip())
				Loop
			EndIF

			Do Case	// Todo el contenido del "Case", fue copiado y pegado del fuente ARFINR02().
					Case SFE->FE_TIPO = "I"
						cImpuCom := "IMPUESTO AL VALOR AGREGADO (I.V.A.)"
						cRegiCom := IIF( ALLTRIM(SFE->FE_SERIE) == 'M', "FACTURA M IVA. EMISION DE COMPROBANTES CON DISCRIMINACION DEL GRAVAMEN.", "COMPRA-VENTA DE MUEBLES/LOCACION DE SERVICIOS" )
						nPorcAliq := SFE->FE_ALIQ
						dEmision := SFE->FE_EMISSAO

						While !SFE->( Eof() ) .and. SFE->FE_TIPO = "I" .and. SFE->FE_ORDPAGO = quecom
							nReteCom += SFE->FE_RETENC     //Importe de la retencion
							nBaseRet := SFE->FE_RETENC * 100 / SFE->FE_PORCRET  //Base de retencion
							SFE->( dbSkip( 1 ) )
						EndDo
					Case SFE->FE_TIPO = "G"
						cImpuCom := "IMPUESTO A LAS GANANCIAS "
						cRegiCom := Posicione( "SFF", 2, xFilial( "SFF" ) + SFE->FE_CONCEPT, "FF_CONCEPT" )  //cRegiCom
						dEmision := SFE->FE_EMISSAO

						nBaseRet := SFE->FE_RETENC * 100 / SFE->FE_ALIQ	//Base de retencion
						nReteCom := SFE->FE_RETENC     //Importe de la retencion
						nPorcAliq := SFE->FE_ALIQ

					Case SFE->FE_TIPO = "B"    .AND.  SFE->FE_EST="CF"
						cImpuCom := "IMPUESTO SOBRE LOS INGRESOS BRUTOS"
						cRegiCom := "R.G. 533/2000 D.G.R."//SFE->FE_SERIE+SFE->FE_NFISCAL
						
						nPorcAliq := SFE->FE_ALIQ
						dEmision := SFE->FE_EMISSAO
						While !SFE->( Eof() ) .and. SFE->FE_TIPO = "B" .and. SFE->FE_EST="CF".and. SFE->FE_ORDPAGO = quecom     //QUIQUE 15/10/03
							nReteCom += SFE->FE_RETENC     //Importe de la retencion
							nBaseRet += SFE->FE_RETENC * 100 / SFE->FE_ALIQ  //Base de retencion
							SFE->( dbSkip( 1 ) )      
							c_numcert :=  SFE->FE_NROCERT        	//LP 26/11/2013           
						EndDo                            

					  	If SFE->FE_ORDPAGO = quecom  .OR. SFE->FE_NROCERT == c_numcert	//LP 26/11/2013  								
		  					SFE->( dbSkip( -1 ) )
						EndIf

					Case SFE->FE_TIPO = "B"    .AND.  SFE->FE_EST="BA"
						cImpuCom := "IMPUESTO SOBRE LOS INGRESOS BRUTOS DPR  Bs. As. B 1/2002"
						nCF:=posicione("SD1",1,xFilial("SD1")+SFE->FE_NFISCAL+SFE->FE_SERIE+SFE->FE_FORNECE+SFE->FE_LOJA,"D1_CF")
						cProv:=SFE->FE_EST
						dEmision := SFE->FE_EMISSAO

						if (alltrim(nCF)<>"104")
							cRegiCom := posicione("SFF",5,xFilial("SFF")+"IBR"+nCF+cProv,"FF_CONCEPT")
						endif

						While !SFE->( Eof() ) .and. SFE->FE_TIPO = "B" .and. SFE->FE_EST="BA" .and. SFE->FE_ORDPAGO = quecom
							nReteCom += SFE->FE_RETENC     //Importe de la retencion
							nBaseRet += SFE->FE_VALBASE//SFE->FE_RETENC * 100 / SFE->FE_ALIQ  //Base de retencion
							SFE->( dbSkip( 1 ) )
						EndDo

						If SFE->FE_ORDPAGO = quecom
							SFE->( dbSkip( -1 ) )
						EndIf

					Case SFE->FE_TIPO = "S"
						cImpuCom := "A CUENTA DE LAS CONTRIBUCIONES CON DESTINO AL S.U.S.S. (R.G. 3983/95)"
						cRegiCom := "S.U.S.S."

						nReteCom := SFE->FE_RETENC     //Importe de la retencion
						nBaseRet := SFE->FE_RETENC * 100 / SFE->FE_ALIQ  //Base de retencion
						nPorcAliq := SFE->FE_ALIQ
						dEmision := SFE->FE_EMISSAO

					Case SFE->FE_TIPO = "L"
						cImpuCom := "RETENCION AFIP  -  RG 1556/2003)"
						cRegiCom := "Servicio de Limpieza."

						nBaseRet := SFE->FE_RETENC * 100 / nAliq  //Base de retencion
						nReteCom := SFE->FE_RETENC     //Importe de la retencion                                                     
						nPorcAliq := SFE->FE_ALIQ
						dEmision := SFE->FE_EMISSAO

					Case SFE->FE_TIPO = "C"
						cImpuCom := "RETENCION LEY 12.207"
						cRegiCom := "Caja Medica de la Provincia de Buenos Aires"

						nReteCom := SFE->FE_RETENC     //Importe de la retencion                                                     
						nBaseRet := SFE->FE_RETENC * 100 / SFE->FE_ALIQ  //Base de retencion
						nPorcAliq := SFE->FE_ALIQ
						dEmision := SFE->FE_EMISSAO
				EndCase

				cNroCert	:= SFE->FE_NROCERT
			
			SFE->( DbSkip() )
		EndDo
	EndIF

RestArea(aAreaSFE)
RestArea(aAreaSA2)
RestArea(aAreaSEK)
RestArea(aArea)
	
Return({ nBaseRet, nReteCom, nPorcAliq, cRegiCom, cImpuCom, cNroCert, dEmision })


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	EXPAITAU	|	FUNCI”N:	BUDOCSFE	|	FECHA:	08/08/2014 	|	AUTOR:	Andres Lovos	|	CECBA
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Busco todos los numeros de certificados asociados.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function BuDocSFE( cOrdPag )
Local aArea	:= GetArea()
Local aAreaSEK	:= SEK->( GetArea() )
Local aAreaSA1	:= SA1->( GetArea() )
Local aAreaSFE	:= SFE->( GetArea() )

Local aDocs	:= {}

	dbSelectArea( "SFE" )
	DbSetOrder(2)
	IF DbSeek( xFilial("SFE") + cOrdPag, .T. )
		WHILE !SFE->(EOF()) .AND. SFE->FE_ORDPAGO == cOrdPag
//			IF Empty( SFE->FE_NFISCAL )
//				SFE->(DbSkip())
//				Loop
//			EndIF

			IF AllTrim( SFE->FE_NROCERT ) == "NORET"
				SFE->(DbSkip())
				Loop
			EndIF

			IF SFE->FE_TIPO == "G"
				aDocs := BuComp( SFE->FE_ORDPAGO )
			Else
				AADD( aDocs, { SFE->FE_NFISCAL })
			EndIF
			
			SFE->(DbSkip())
		EndDo
	EndIF

RestArea(aAreaSFE)
RestArea(aAreaSA1)
RestArea(aAreaSEK)
RestArea(aArea)

Return aDocs



Static Function BuComp( quecom )
Local aArea := GetArea()
Local aAreaSFE := SFE->( GetArea() )
Local aAreaSEK := SEK->( GetArea() )
Local aRet	:= {}

	DbSelectArea ("SEK")
	DbSetOrder (1)
	DbSeek (xfilial("SEK") + quecom )
	While !SEK->( Eof() ) .and. SEK->EK_ORDPAGO == quecom
		If SEK->EK_TIPODOC == 'TB'
			AADD( aRet, { SEK->EK_NUM } )
		EndIf
		SEK->( dbSkip( 1 ) )
	EndDo

RestArea(aAreaSEK)
RestArea(aAreaSFE)
RestArea(aArea)

Return aRet

//--------------------------------------------------------------------
/*/{Protheus.doc} AtuSX1
AtualizaÁ„o do SX1 - Perguntas

@author TOTVS Protheus
@since  31/07/2019
@obs    Gerado por EXPORDIC - V.6.1.0.1 EFS / Upd. V.5.0.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function AtuSX1()
Local aArea    := GetArea()
Local aAreaDic := SX1->( GetArea() )
Local aEstrut  := {}
Local aStruDic := SX1->( dbStruct() )
Local aDados   := {}
Local nI       := 0
Local nJ       := 0
Local nTam1    := Len( SX1->X1_GRUPO )
Local nTam2    := Len( SX1->X1_ORDEM )

aEstrut := { "X1_GRUPO"  , "X1_ORDEM"  , "X1_PERGUNT", "X1_PERSPA" , "X1_PERENG" , "X1_VARIAVL", "X1_TIPO"   , ;
             "X1_TAMANHO", "X1_DECIMAL", "X1_PRESEL" , "X1_GSC"    , "X1_VALID"  , "X1_VAR01"  , "X1_DEF01"  , ;
             "X1_DEFSPA1", "X1_DEFENG1", "X1_CNT01"  , "X1_VAR02"  , "X1_DEF02"  , "X1_DEFSPA2", "X1_DEFENG2", ;
             "X1_CNT02"  , "X1_VAR03"  , "X1_DEF03"  , "X1_DEFSPA3", "X1_DEFENG3", "X1_CNT03"  , "X1_VAR04"  , ;
             "X1_DEF04"  , "X1_DEFSPA4", "X1_DEFENG4", "X1_CNT04"  , "X1_VAR05"  , "X1_DEF05"  , "X1_DEFSPA5", ;
             "X1_DEFENG5", "X1_CNT05"  , "X1_F3"     , "X1_PYME"   , "X1_GRPSXG" , "X1_HELP"   , "X1_PICTURE", ;
             "X1_IDFIL"  }

aAdd( aDados, {'ITAUREP001','01','Fecha Inicio','Fecha Inicio','Fecha Inicio','MV_CH0','D',8,0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUREP001','02','Fecha Fin','Fecha Fin','Fecha Fin','MV_CH0','D',8,0,0,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUREP001','03','De Banco','De Banco','De Banco','MV_CH0','C',3,0,0,'G','','MV_PAR03','','','','','','','','','','','','','','','','','','','','','','','','','SA6','','','','',''} )
aAdd( aDados, {'ITAUREP001','04','De Agencia','De Agencia','De Agencia','MV_CH0','C',5,0,0,'G','','MV_PAR04','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUREP001','05','De Cuenta','De Cuenta','De Cuenta','MV_CH0','C',20,0,0,'G','','MV_PAR05','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUREP001','06','Hasta Banco','Hasta Banco','Hasta Banco','MV_CH0','C',3,0,0,'G','','MV_PAR06','','','','','','','','','','','','','','','','','','','','','','','','','SA6','','','','',''} )
aAdd( aDados, {'ITAUREP001','07','Hasta Agencia','Hasta Agencia','Hasta agencia','MV_CH0','C',5,0,0,'G','','MV_PAR07','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUREP001','08','Hasta cuenta','Hasta cuenta','Hasta cuenta','MV_CH0','C',20,0,0,'G','','MV_PAR08','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUREP001','09','Forma de pago','Forma de pago','Forma de pago','MV_CH0','N',1,0,0,'C','','MV_PAR09','Cheque Itau','Cheque Itau','Cheque Itau','','','Transferencia','Transferencia','Transferencia','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUREP001','10','Directorio destino','Directorio destino','Directorio destino','MV_CH1','C',60,0,0,'G','','MV_PAR10','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUREP001','11','De Orden de Pago','De Orden de Pago','De Orden de Pago','MV_CH1','C',12,0,0,'G','','MV_PAR11','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUREP001','12','Hasta Orden de pago','Hasta Orden de pago','Hasta Orden de pago','MV_CH1','C',12,0,0,'G','','MV_PAR12','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )


aAdd( aDados, {'ITAUEXP001','01','Fecha Inicio','Fecha Inicio','Fecha Inicio','MV_CH0','D',8,0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUEXP001','02','Fecha Fin','Fecha Fin','Fecha Fin','MV_CH0','D',8,0,0,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUEXP001','03','De Banco','De Banco','De Banco','MV_CH0','C',3,0,0,'G','','MV_PAR03','','','','','','','','','','','','','','','','','','','','','','','','','SA6','','','','',''} )
aAdd( aDados, {'ITAUEXP001','04','De Agencia','De Agencia','De Agencia','MV_CH0','C',5,0,0,'G','','MV_PAR04','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUEXP001','05','De Cuenta','De Cuenta','De Cuenta','MV_CH0','C',20,0,0,'G','','MV_PAR05','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUEXP001','06','Hasta Banco','Hasta Banco','Hasta Banco','MV_CH0','C',3,0,0,'G','','MV_PAR06','','','','','','','','','','','','','','','','','','','','','','','','','SA6','','','','',''} )
aAdd( aDados, {'ITAUEXP001','07','Hasta Agencia','Hasta Agencia','Hasta agencia','MV_CH0','C',5,0,0,'G','','MV_PAR07','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUEXP001','08','Hasta cuenta','Hasta cuenta','Hasta cuenta','MV_CH0','C',20,0,0,'G','','MV_PAR08','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUEXP001','09','Forma de pago','Forma de pago','Forma de pago','MV_CH0','N',1,0,0,'C','','MV_PAR09','Cheque Itau','Cheque Itau','Cheque Itau','','','Transf con CBU','Transf con CBU','Transf con CBU','','','Transf sin CBU','Transf sin CBU','Transf sin CBU','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUEXP001','10','Directorio destino','Directorio destino','Directorio destino','MV_CH1','C',60,0,0,'G','','MV_PAR10','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUEXP001','11','De Orden de Pago','De Orden de Pago','De Orden de Pago','MV_CH1','C',12,0,0,'G','','MV_PAR11','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'ITAUEXP001','12','Hasta Orden de pago','Hasta Orden de pago','Hasta Orden de pago','MV_CH1','C',12,0,0,'G','','MV_PAR12','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )


//
// Atualizando dicion·rio
//
dbSelectArea( "SX1" )
SX1->( dbSetOrder( 1 ) )

For nI := 1 To Len( aDados )
	If !SX1->( dbSeek( PadR( aDados[nI][1], nTam1 ) + PadR( aDados[nI][2], nTam2 ) ) )
		RecLock( "SX1", .T. )
		For nJ := 1 To Len( aDados[nI] )
			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nJ], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nJ] ), aDados[nI][nJ] ) )
			EndIf
		Next nJ
		MsUnLock()
	EndIf
Next nI

RestArea( aAreaDic )
RestArea( aArea )

Return NIL

