/*/{Protheus.doc} MTASF2
Esta localizado en la función A460GeraF2 (Genera registros en la SF2 y acumula valores),
 es ejecutado después de la actualización de casi todos los campos de la SF2
@type function
@version  
@author AxelDiaz
@since 19/5/2021
@return return_type, return_description
/*/
USER FUNCTION MTASF2
    Local aAreaSF2  := SF2->( GetArea() )
	Local cPrefi		:= ""
	Local cDocum		:= ""
	Local cClien		:= ""
	Local cLojF2		:= ""
	Local cTpSF2		:= ""
	Local cQry			:= ""
	local cLSTOBS		:= ""
	Private lMsErroAuto := .F. 


    If ISINCALLSTACK("MATA468N") .OR. ISINCALLSTACK("MATA460B")	.OR. FUNNAME()=="MATA461"				// Factura de Venta
        cPrefi		:= SF2->F2_SERIE
        cDocum		:= SF2->F2_DOC
        cClien		:= SF2->F2_CLIENTE
        cLojF2		:= SF2->F2_LOJA
        cTpSF2		:= SF2->F2_TIPODOC
		If cTpSF2 == "01" 
			If Reclock("SF2",.F.)
				Replace SF2->F2_XNOME 	With SC5->C5_XNOME 		// 
				Replace SF2->F2_XOBS 	With SC5->C5_XOBS 		// oBSERVACIONES
				Replace SF2->F2_XFORCOM With SC5->C5_XDTORDC 	// Fecha Orden de Compra
				Replace SF2->F2_XORDCOM With SC5->C5_XORDEM 	// Orden de Compra
				Replace SF2->F2_CLIENT 	With SC5->C5_CLIENT 	// oBSERVACIONES
				Replace SF2->F2_LOJENT 	With SC5->C5_LOJAENT 	// Fecha Orden de Compra
				Replace SF2->F2_XENDENT With SC5->C5_XENDENT 	// Orden de Compra
				Replace SF2->F2_DTENTR 	With SC5->C5_FECENT 	// fECHA eNTREGA
				// Campos Back to Back
				Replace SF2->F2_XFORNEC With SC5->C5_XFORNEC 	// fECHA eNTREGA
				Replace SF2->F2_XLOJA	With SC5->C5_XLOJA 		// fECHA eNTREGA
				Replace SF2->F2_XDOC 	With SC5->C5_XDOC 		// fECHA eNTREGA
				Replace SF2->F2_XSERIE 	With SC5->C5_XSERIE 	// fECHA eNTREGA

				Replace SF2->F2_INCOTER	With SC5->C5_INCOTER   // Incoterm

				Replace SF2->F2_XTPED With SC5->C5_XTPED 		// Tipo de Pedido (B2B, Nacional, Exportacion, Obsequio)
				SF2->(MsUnlock())
				If Reclock("SC5",.F.)
					Replace SC5->C5_XFATVEN With ALLTRIM(SF2->F2_SERIE)+"-"+cValToChar( VAL(SF2->F2_DOC) )
					SC5->(MsUnlock())
				EndIf
			Endif
        EndIf
    EndIf
RestArea( aAreaSF2 )
Return .T.
