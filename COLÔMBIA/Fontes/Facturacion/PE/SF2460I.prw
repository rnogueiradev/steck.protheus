#INCLUDE "totvs.ch"
/*
Punto de Entrada Facturas de Ventas desde Pedido de Venta O fACTURA mANUAL
Importante debe existir el parametro CB_LSTOBS (sE EJECUTA PRIMERO AL PE MTASF2)
Programa SF2460I
Empresa: 
Fecha 24/03/2020
Desc. PE para modificar el tipo de doc gerado na facturacion
Revisión Yilberth Ladino, Axel Díaz
*/

User Function SF2460I
//	Local aAreaSF2  := SF2->( GetArea() )
	Local cPrefi		:= SF2->F2_SERIE
	Local cDocum		:= SF2->F2_DOC
	Local cClien		:= SF2->F2_CLIENTE
	Local cLojF2		:= SF2->F2_LOJA
	Local cTpSF2		:= SF2->F2_TIPODOC
	Local cQry			:= ""

	Private lMsErroAuto := .F.

	If ISINCALLSTACK("MATA468N") .OR. ISINCALLSTACK("MATA460B")	.OR. FUNNAME()=="MATA461"				// Factura de Venta
		If cTpSF2 == "01" 
			If Reclock("SF2",.F.)
				Replace SF2->F2_XNOME  	 With SC5->C5_XNOME		// 
				Replace SF2->F2_XOBS	 With SC5->C5_XOBS  	// oBSERVACIONES
				Replace SF2->F2_XFORCOM  With SC5->C5_XDTORDC 	// Fecha Orden de Compra
				Replace SF2->F2_XORDCOM	 With SC5->C5_XORDEM  	// Orden de Compra
				Replace SF2->F2_CLIENT 	 With SC5->C5_CLIENT  	// oBSERVACIONES
				Replace SF2->F2_LOJENT   With SC5->C5_LOJAENT 	// Fecha Orden de Compra
				Replace SF2->F2_XENDENT	 With SC5->C5_XENDENT  	// Orden de Compra
				Replace SF2->F2_DTENTR	 With SC5->C5_FECENT  	// fECHA eNTREGA
				// Campos Back to Back
				Replace SF2->F2_XFORNEC	 With SC5->C5_XFORNEC  	// fECHA eNTREGA
				Replace SF2->F2_XLOJA	 With SC5->C5_XLOJA 	// fECHA eNTREGA
				Replace SF2->F2_XDOC	 With SC5->C5_XDOC  	// fECHA eNTREGA
				Replace SF2->F2_XSERIE	 With SC5->C5_XSERIE  	// fECHA eNTREGA

				Replace SF2->F2_INCOTER	 With SC5->C5_INCOTER   // Incoterm

				Replace SF2->F2_XTPED	 With SC5->C5_XTPED  	// Tipo de Pedido (B2B, Nacional, Exportacion, Obsequio)

				SF2->(MsUnlock())
				If Reclock("SC5",.F.)
					Replace SC5->C5_XFATVEN With ALLTRIM(SF2->F2_SERIE)+"-"+cValToChar( VAL(SF2->F2_DOC) )
					SC5->(MsUnlock())
				EndIf
			Endif
			/*/
			DbSelectArea("SE1")
			cChaveSE1:= xFilial("SE1")+ cClien + cLojF2 + cPrefi + cDocum
			DbSetOrder(2)
			If 	DbSeek(xFilial("SE1")+ cClien + cLojF2 + cPrefi + cDocum )  
				While !Eof() .and. SE1->E1_FILIAL + SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_PREFIXO + SE1->E1_NUM == cChaveSE1
					RecLock("SE1",.F.)
					SE1->E1_HIST    := SF2->F2_XOBS
					SE1->E1_XIVA    := SF2->F2_VALIMP1
					SE1->E1_XRETFTE := SF2->F2_VALIMP4
					SE1->E1_XICA    := SF2->F2_VALIMP9
					SE1->E1_XRETIVA := SF2->F2_VALIMP2

					MsUnLock()
					DbSelectArea("SE1")
					DbSkip()
				EndDo
			EndIf
			/*/
		EndIf
	elseIf FUNNAME()=="MATA467N"  // Factura Venta Manual
		If cTpSF2 == "01" 
			If Reclock("SF2",.F.)
				Replace SF2->F2_XNOME  	 With POSICIONE("SA1",1,xFilial("SA1")+cClien + cLojF2, "A1_NOME")	// 
				MsUnlock()
			Endif	
			/*/
			DbSelectArea("SE1")
			cChaveSE1:= xFilial("SE1")+ cClien + cLojF2 + cPrefi + cDocum
			DbSetOrder(2)
			If 	DbSeek(xFilial("SE1")+ cClien + cLojF2 + cPrefi + cDocum )  
				While !Eof() .and. SE1->E1_FILIAL + SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_PREFIXO + SE1->E1_NUM == cChaveSE1
					RecLock("SE1",.F.)
					SE1->E1_HIST    := SF2->F2_XOBS
					SE1->E1_XIVA    := SF2->F2_VALIMP1
					SE1->E1_XRETFTE := SF2->F2_VALIMP4
					SE1->E1_XICA    := SF2->F2_VALIMP9
					SE1->E1_XRETIVA := SF2->F2_VALIMP2

					MsUnLock()
					DbSelectArea("SE1")
					DbSkip()
				EndDo
			EndIf
			/*/
		EndIf
	EndIf
//RestArea( aAreaSF2 )
RETURN (.T.) 
