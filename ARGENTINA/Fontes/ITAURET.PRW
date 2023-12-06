#INCLUDE "PROTHEUS.CH"


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	IATURET	|	FECHA:	05/06/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: NUEVO FORMATO, procesamiento de archivo que regresa del Banco ITAU actualizando el campo E2_NUMBCO y realizar la funciÛn "Descontar 
Cheque".
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
User Function ITAURET()
Local cDirLog	:= '\LogITAU'


Private oDlg    := 0
Private oGet    := 0
Private nOpca   := 0
Private cFile   :=Space(255)
Private cFileLog:=Space(255)
Private cType   := "*.TXT      | *.TXT " //Para filtrar que solo sean archivos .dat los que se vean.
Private nLastKey:= 0
  
    DEFINE FONT oFont NAME "Arial" SIZE 000,020 BOLD
    DEFINE DIALOG oDlg FROM 000,000 TO 300,480 TITLE OemToAnsi('NUEVO FORMATO: Lectura de Archivo del Banco') PIXEL
    
    @ 010,055 SAY 'Seleccione archivo a procesar' SIZE 150, 010 PIXEL OF oDlg FONT oFont
    
    @ 110,070 MSGET oGet VAR cFile SIZE 125,10 PIXEL OF oDlg
    @ 110,200 BUTTON OemToAnsi("...") SIZE 15,10 PIXEL OF oDlg ACTION cFile := Padr( cGetFile(cType, OemToAnsi("Seleccione el archivo "+Subs(cType,1,6)),0,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY), 255 )
    
    DEFINE SBUTTON FROM  135, 140 TYPE 1 ACTION (Iif(TodoOk(),oDlg:End(),.F.)) ENABLE PIXEL OF oDlg
    DEFINE SBUTTON FROM  135, 170 TYPE 2 ACTION (nOpca := 0, oDlg:End())       ENABLE PIXEL OF oDlg
    
    ACTIVATE DIALOG oDlg CENTERED
    
	If nOpca == 1
		Processa( { || ProIntPrec( ) }, 'Procesando Archivo...' )
		Aviso(OemToAnsi("ConfirmaciÛn"),"Proceso Finalizado",{"Ok"},1)
       
		cFileLog := NomeAutoLog()

		If cFileLog <> ""
			nX := 1
			While .t.
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
		EndIF
	EndIf

Return


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	RECAITAU	|	FUNCI”N: TUDOOK	|	FECHA:	05/06/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Validaciones sobre el archivo.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function TodoOk()

    If Empty( cFile )
       Aviso("Archivo", "Informe la ruta y el nombre del archivo a procesar.", {"Ok"}, 1 )
       Return( .F. )
    EndIf
    
    If !File( Alltrim( cFile ) )
       Aviso("Falla de Apertura", "El archivo no existe.", {"Ok"}, 1 )
       Return( .F. )
    EndIf
    
    nOpca := 1

Return( .T. )


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	RECAITAU	|	FUNCI”N: TUDOOK	|	FECHA:	05/06/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Acualizacion de archivo de informe preliminar.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function ProIntPrec( )
Local cLine 	:= ""
Local cNombre	:= AllTrim(cFile)
Local cTipoReg	:= ""
Local cOP		:= ""
Local cProve	:= ""
Local cNumCh	:= ""
Local nImporte	:= 0
Local lFound	:= .T.

	If (FT_FUSE(cNombre) == -1)						//Error en apertura.
		AutoGrLog('No se pudo abrir el archivo: ' + cNombre)
	Else
		While !FT_FEOF()
			cLine := FT_FREADLN()

//			cTipoReg := SubStr( cLine, 40, 1 )           // Tipo de PosiciÛn
			cTipoReg := SubStr( cLine, 1, 1 )           // Tipo de PosiciÛn

			IF cTipoReg == 'P'
//				cOP   := SubStr( cLine, 422, Len( SEK->EK_ORDPAGO ) )
				cOP   := SubStr( cLine, 3, 12 )
//	         cTipoPag := SubStr( cLine, 106, 2 )
	         cTipoPag := "18"
//      	   cNumCh   := SubStr( cLine, 118, 8 ) 
      	   cNumCh   := SubStr( cLine, 16, 6 )
      	   cProve   := SubStr( cLine, 23, 10 )
      	   
//   	      nImporte := Val( SubStr( cLine, 150, 17 ) ) / 100
   	      nImporte := Val( SubStr( cLine, 33, 20 ) )
	         If cTipoPag $ '17/18'
         	   lFound   := .F.
         
      	      SEK->(DbSetOrder(1))
   	         If SEK->(DbSeek(xFilial('SEK')+cOP))
	               While !SEK->(Eof()) .and. xFilial('SEK')+cOP == SEK->(EK_FILIAL+EK_ORDPAGO)
                  
               	   If AllTrim(SEK->EK_TIPODOC) == 'CP' .AND. AllTrim(SEK->EK_TIPO) == 'CHI' 
            	         If SEK->EK_EMISSAO == SEK->EK_VENCTO .and. cTipoPag == '17' .and. Round(SEK->EK_VALOR,2) == Round(nImporte,2)
//         	               AutoGrLog('OP ' + cOP + ' => OK Cheque Nro ' + cNumCh )
      	                  ACTUACH( cOP, cNumCh, nImporte )
   	                     lFound   := .T.
	                     ElseIf SEK->EK_EMISSAO < SEK->EK_VENCTO .and. cTipoPag == '18' .and. Round(SEK->EK_VALOR,2) == Round(nImporte,2)
//                        	AutoGrLog('OP ' + cOP + ' => OK Cheque Nro ' + cNumCh )
                     	   ACTUACH( cOP, cNumCh, nImporte )
                  	      lFound   := .T.
               	      EndIf
            	      EndIf
         	         SEK->(DbSkip())
      	         EndDo
   	         EndIf
            
	            If !lFound
               	AutoGrLog('OP ' + cOP + ' => ERROR Chq Nro ' + cNumCh )
            	EndIf
            ENDIF //cTipoPag	
         EndIf  //cTipoReg

			FT_FSKIP()
		End //WHILE

		FT_FUSE()	
	EndIf //FT_USE

Return


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	RECAITAU	|	FUNCI”N:	ACTUACH	|	FECHA:	05/06/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Graba las modificaciones en la tabla SE2.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function ACTUACH( cOP, cCH, nValor )
Local aArea := GetArea()


	SE2->(DbSetOrder(1))
	IF SE2->(DbSeek(xFilial('SE2')+SEK->(EK_PREFIXO+EK_NUM+EK_PARCELA+EK_TIPO+EK_FORNEPG+EK_LOJAPG)))
		IF AllTrim(SE2->E2_NUMBCO)	!= AllTrim(cCH)
			BEGIN TRANSACTION
   		RecLock('SE2', .F.)

	   	Replace SE2->E2_NUMBCO		WITH cCH
		   Replace SE2->E2_VALLIQ		WITH nValor
		   Replace SE2->E2_SALDO		WITH 0
	   	Replace SE2->E2_BAIXA		WITH dDataBase
		   Replace SE2->E2_MOVIMEN		WITH dDataBase

   		MsUnLock()

			DesconCH( cOP, cCH, SE2->E2_BCOCHQ, SE2->E2_AGECHQ, SE2->E2_CTACHQ, nValor )

	   	END TRANSACTION
        	AutoGrLog('OP ' + cOP + ' => OK Cheque Nro ' + cCH )
		Else
			AutoGrLog( 'OP ' + cOP + ' => Cheque Nro ' + cCH + ' ya debitado.' )
		EndIF
	Else
		AutoGrLog("Cheque no Debitado. Proceda a debitar el Cheque:"+SE2->E2_NUMBCO+" manualmente." )
	EndIF


RestArea(aArea)

Return



/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	RECAITAU	|	FUNCI”N:	DESCONCH	|	FECHA:	06/06/2014 	|	AUTOR:	Andres Lovos	|	Colegio de escribanos.
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: FunciÛn descontar.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function DesconCH( cOP, cCH , cBanco, cSucurs, cCuenta, nValor )
Local aArea      := GetArea()
Local aAreaSE2   := SE2->(GetArea())
Local aAreaSE5   := SE5->(GetArea())


		RecLock( "SE5", .T.)
		SE5->E5_FILIAL		   := xFilial("SE5")
		SE5->E5_VALOR     	:= nValor
		SE5->E5_RECPAG    	:= "P"
		SE5->E5_HISTOR    	:= "Deb CH:"+alltrim(SE2->E2_NUMBCO)+" OP:"+cOP
		SE5->E5_DTDIGIT   	:= dDataBase
		SE5->E5_DATA      	:= dDataBase
		SE5->E5_TIPODOC   	:= "VL"
		SE5->E5_NUMERO   	   := SE2->E2_NUM
		SE5->E5_PARCELA   	:= SE2->E2_PARCELA
		SE5->E5_CLIFOR    	:= SE2->E2_FORNECE
		SE5->E5_FORNECE    	:= SE2->E2_FORNECE
		SE5->E5_LOJA      	:= SE2->E2_LOJA
		SE5->E5_BENEF     	:= SE2->E2_NOMFOR
		SE5->E5_VLMOED2   	:= nValor
		SE5->E5_TIPO      	:= SE2->E2_TIPO
		SE5->E5_BANCO 	   	:= cBanco
		SE5->E5_AGENCIA   	:= cSucurs
		SE5->E5_CONTA     	:= cCuenta
		SE5->E5_MOEDA     	:= StrZero(Posicione("SA6",1,xFilial("SA6") + cBanco + cSucurs + cCuenta,"A6_MOEDA"), 2)
		SE5->E5_DTDISPO   	:= dDatabase
		SE5->E5_NATUREZ      := ""
		SE5->E5_TXMOEDA		:= 1
		SE5->E5_PREFIXO   	:= SE2->E2_PREFIXO
		SE5->E5_LA		      := " "
		SE5->(MsUnLock())

		FKCommit()

		AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DATA,SE5->E5_VALOR,"-")
	
RestArea(aAreaSE5)		
RestArea(aAreaSE2)		
RestArea(aArea)

Return