#INCLUDE "Rwmake.ch"

/*====================================================================================\
|Programa  | ARREL001        | Autor | RENATO.OLIVEIRA           | Data | 09/08/2018  |
|=====================================================================================|
|Descrição | RELATORIO DE INGRESSOS BRUTOS			                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function ARREL001()

	Local _cComp := ""
	Private _cPerg 	 	:= "ARREL001"
	Private _cNomePdf 	:= ""
	Private _cPath		:= GetTempPath(.T.)

	//RpcSetEnv("07","01")

	//Pergunte(_cPerg,.T.)

	If SF1->F1_VALIMPR==0 .And. SF1->F1_VALIMP5==0
		MsgAlert("¡Atención, esta nota no tiene impuestos, verifique!")
		Return
	EndIf

	If SF1->F1_VALIMPR>0 //Ingresos bruto

		If Empty(SF1->F1_XCOMP)

			DbSelectArea("SX5")
			SX5->(DbSetOrder(1))
			SX5->(DbGoTop())
			If SX5->(DbSeek(xFilial("SX5")+"_A"+"000001"))

				_cComp := Soma1(AllTrim(SX5->X5_DESCSPA))

				SX5->(RecLock("SX5",.F.))
				SX5->X5_DESCRI  := _cComp
				SX5->X5_DESCSPA := _cComp
				SX5->X5_DESCENG := _cComp
				SX5->(MsUnLock())

				SF1->(RecLock("SF1",.F.))
				SF1->F1_XCOMP := _cComp
				SF1->(MsUnLock())

			EndIf

		EndIf

		_cComp := SF1->F1_XCOMP

		DbSelectArea("SA2")
		SA2->(DbSetOrder(1))
		SA2->(DbGoTop())
		If !SA2->(DbSeek(xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA)))
			MsgAlert("Proveedor no encontrado, verifique!")
			Return
		EndIf

		DbSelectArea("SE2")
		SE2->(DbSetOrder(1))
		SE2->(DbGoTop())
		If !SE2->(DbSeek(SF1->(F1_FILIAL+F1_SERIE+F1_DOC)))
			MsgAlert("Título no encontrado, verifique!")
			Return
		EndIf

		If Empty(SE2->E2_NUMBOR)
			MsgAlert("Bordero no encontrado, verifique! (1)")
			Return
		EndIf

		DbSelectArea("SEA")
		SEA->(DbSetOrder(1))
		SEA->(DbGoTop())
		If !SEA->(DbSeek(SE2->(E2_FILIAL+E2_NUMBOR)))
			MsgAlert("Bordero no encontrado, verifique! (2)")
			Return
		EndIf

		_cNomePdf  := cEmpAnt+"_"+SF1->F1_DOC+"_1.pdf"

		oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             ,   ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
		oPrint:SetPortrait()     //Retrato - SetPortrait() ou Paisagem - SetLandscape()
		oPrint:SetMargin(30,30,30,30)
		oPrint:setPaperSize(9)

		aBmp := "steck_arg.jpg"

		oFont13  := TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
		oFont13n := TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
		oFont15  := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
		oFont15n := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)

		oPrint:StartPage()     // INICIALIZA a página

		If File(aBmp)
			oPrint:SayBitmap(025,015,aBmp,180,050)
		EndIf

		//oPrint:Say (075,480, "Fecha: "+DTOC(SF1->F1_EMISSAO)				,oFont13)

		oPrint:Say (090,060, SM0->M0_NOMECOM 					,oFont13)
		oPrint:Say (100,060, SM0->M0_ENDENT 					,oFont13)
		oPrint:Say (110,060, "(005411) 4201-1489/7534/8396" 	,oFont13)
		oPrint:Say (120,015, "I.V.A. Responsable Inscripto" 	,oFont13)

		oPrint:Say (100,250, "CUIT"				,oFont13n)
		oPrint:Say (100,475, SM0->M0_CGC	,oFont13n)

		oPrint:Say (110,250, "ING. BRUTOS CONVENIO MULTILATERAL"				,oFont13n)
		oPrint:Say (110,475, SM0->M0_INSC	,oFont13n)

		oPrint:Say (120,250, "INICIO DE ACTIVIDADES"				,oFont13n)
		oPrint:Say (120,475, "01/03/2004"	,oFont13n)

		oPrint:Line( 130, 001 , 130 , 570 , ,"-4")

		oPrint:Say (150,130, "COMPROBANTE DE RETENCIÓN DE INGRESOS BRUTOS"				,oFont15n)
		oPrint:Say (165,215, "COMPROBANTE Nº "+_cComp				,oFont15n)

		oPrint:Say (200,015, "DATOS DEL BENEFICIARIO"				,oFont15n)
		oPrint:Say (220,015, "Apellido y nombre o Denominación"		,oFont15)
		oPrint:Say (220,250, SA2->A2_NOME		,oFont15)
		oPrint:Say (240,015, "Domicilio"		,oFont15)
		oPrint:Say (240,250, SA2->A2_END		,oFont15)
		oPrint:Say (260,015, "C.U.I.T. Nº"		,oFont15)
		oPrint:Say (260,250, SA2->A2_CGC		,oFont15)

		oPrint:Say (290,015, "DATOS DE LA RETENCIÓN"				,oFont15n)
		oPrint:Say (310,015, "Recibo Nº"		,oFont15)
		oPrint:Say (310,250, SE2->E2_NUMBOR		,oFont15)
		oPrint:Say (330,015, "Fecha"		,oFont15)
		oPrint:Say (330,250, DTOC(SEA->EA_DATABOR)		,oFont15)
		oPrint:Say (350,015, "Total del pago"		,oFont15)
		oPrint:Say (350,250, CVALTOCHAR(SF1->F1_VALBRUT)		,oFont15)
		oPrint:Say (370,015, "Importe neto"		,oFont15)
		oPrint:Say (370,250, CVALTOCHAR(SF1->F1_BASIMPR)	,oFont15)
		oPrint:Say (390,015, "Retención practicada"		,oFont15)
		oPrint:Say (390,250, CVALTOCHAR(SF1->F1_VALIMPR)		,oFont15)
		oPrint:Say (410,250, Extenso(SF1->F1_VALIMPR ,.F.,1,,"2",.T.,.F.)		,oFont15)
		oPrint:Say (430,015, "Comprobantes abonados"		,oFont15)
		oPrint:Say (430,250, SF1->F1_DOC		,oFont15)
		oPrint:Say (450,015, "Jurisdicción"		,oFont15)
		oPrint:Say (470,250, "BUENOS AIRES"		,oFont15)

		oPrint:Say (800,120, "--------------------------------"		,oFont15)
		oPrint:Say (815,170, "Firma"		,oFont15)
		oPrint:Say (800,350, "--------------------------------"		,oFont15)
		oPrint:Say (815,390, "Aclaración"		,oFont15)

		oPrint:cPathPDF := _cPath

		oPrint:Print()
		oPrint:EndPage()

		ShellExecute("open",_cPath+_cNomePdf, "", "", 1)

	EndIf
	
	//----------------------------------------------------
	
	If SF1->F1_VALIMP5>0 //La ganancias

		If Empty(SF1->F1_XCOMP)

			DbSelectArea("SX5")
			SX5->(DbSetOrder(1))
			SX5->(DbGoTop())
			If SX5->(DbSeek(xFilial("SX5")+"_A"+"000001"))

				_cComp := Soma1(AllTrim(SX5->X5_DESCSPA))

				SX5->(RecLock("SX5",.F.))
				SX5->X5_DESCRI  := _cComp
				SX5->X5_DESCSPA := _cComp
				SX5->X5_DESCENG := _cComp
				SX5->(MsUnLock())

				SF1->(RecLock("SF1",.F.))
				SF1->F1_XCOMP := _cComp
				SF1->(MsUnLock())

			EndIf

		EndIf

		_cComp := SF1->F1_XCOMP

		DbSelectArea("SA2")
		SA2->(DbSetOrder(1))
		SA2->(DbGoTop())
		If !SA2->(DbSeek(xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA)))
			MsgAlert("Proveedor no encontrado, verifique!")
			Return
		EndIf

		DbSelectArea("SE2")
		SE2->(DbSetOrder(1))
		SE2->(DbGoTop())
		If !SE2->(DbSeek(SF1->(F1_FILIAL+F1_SERIE+F1_DOC)))
			MsgAlert("Título no encontrado, verifique!")
			Return
		EndIf

		If Empty(SE2->E2_NUMBOR)
			MsgAlert("Bordero no encontrado, verifique! (1)")
			Return
		EndIf

		DbSelectArea("SEA")
		SEA->(DbSetOrder(1))
		SEA->(DbGoTop())
		If !SEA->(DbSeek(SE2->(E2_FILIAL+E2_NUMBOR)))
			MsgAlert("Bordero no encontrado, verifique! (2)")
			Return
		EndIf

		_cNomePdf  := cEmpAnt+"_"+SF1->F1_DOC+"_2.pdf"

		oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             ,   ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
		oPrint:SetPortrait()     //Retrato - SetPortrait() ou Paisagem - SetLandscape()
		oPrint:SetMargin(30,30,30,30)
		oPrint:setPaperSize(9)

		aBmp := "steck_arg.jpg"

		oFont13  := TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
		oFont13n := TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
		oFont15  := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
		oFont15n := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)

		oPrint:StartPage()     // INICIALIZA a página

		If File(aBmp)
			oPrint:SayBitmap(025,015,aBmp,180,050)
		EndIf

		//oPrint:Say (075,480, "Fecha: "+DTOC(SF1->F1_EMISSAO)				,oFont13)

		oPrint:Say (090,060, SM0->M0_NOMECOM 					,oFont13)
		oPrint:Say (100,060, SM0->M0_ENDENT 					,oFont13)
		oPrint:Say (110,060, "(005411) 4201-1489/7534/8396" 	,oFont13)
		oPrint:Say (120,015, "I.V.A. Responsable Inscripto" 	,oFont13)

		oPrint:Say (100,250, "CUIT"				,oFont13n)
		oPrint:Say (100,475, SM0->M0_CGC	,oFont13n)

		oPrint:Say (110,250, "ING. BRUTOS CONVENIO MULTILATERAL"				,oFont13n)
		oPrint:Say (110,475, SM0->M0_INSC	,oFont13n)

		oPrint:Say (120,250, "INICIO DE ACTIVIDADES"				,oFont13n)
		oPrint:Say (120,475, "01/03/2004"	,oFont13n)

		oPrint:Line( 130, 001 , 130 , 570 , ,"-4")

		oPrint:Say (150,130, "COMPROBANTE DE RETENCIÓN DE IMPUESTOS A LAS GANANCIAS"				,oFont15n)
		oPrint:Say (165,215, "COMPROBANTE Nº "+_cComp				,oFont15n)

		oPrint:Say (200,015, "DATOS DEL BENEFICIARIO"				,oFont15n)
		oPrint:Say (220,015, "Apellido y nombre o Denominación"		,oFont15)
		oPrint:Say (220,250, SA2->A2_NOME		,oFont15)
		oPrint:Say (240,015, "Domicilio"		,oFont15)
		oPrint:Say (240,250, SA2->A2_END		,oFont15)
		oPrint:Say (260,015, "C.U.I.T. Nº"		,oFont15)
		oPrint:Say (260,250, SA2->A2_CGC		,oFont15)

		oPrint:Say (290,015, "DATOS DE LA RETENCIÓN"				,oFont15n)
		oPrint:Say (310,015, "Recibo Nº"		,oFont15)
		oPrint:Say (310,250, SE2->E2_NUMBOR		,oFont15)
		oPrint:Say (330,015, "Fecha"		,oFont15)
		oPrint:Say (330,250, DTOC(SEA->EA_DATABOR)		,oFont15)
		oPrint:Say (350,015, "Total del pago"		,oFont15)
		oPrint:Say (350,250, CVALTOCHAR(SF1->F1_VALBRUT)		,oFont15)
		oPrint:Say (370,015, "Importe neto"		,oFont15)
		oPrint:Say (370,250, CVALTOCHAR(SF1->F1_BASIMP5)	,oFont15)
		oPrint:Say (390,015, "Retención practicada"		,oFont15)
		oPrint:Say (390,250, CVALTOCHAR(SF1->F1_VALIMP5)		,oFont15)
		oPrint:Say (410,250, Extenso(SF1->F1_VALIMP5 ,.F.,1,,"2",.T.,.F.)		,oFont15)
		oPrint:Say (430,015, "Comprobantes abonados"		,oFont15)
		oPrint:Say (430,250, SF1->F1_DOC		,oFont15)
		oPrint:Say (450,015, "Jurisdicción"		,oFont15)
		oPrint:Say (470,250, "BUENOS AIRES"		,oFont15)

		oPrint:Say (800,120, "--------------------------------"		,oFont15)
		oPrint:Say (815,170, "Firma"		,oFont15)
		oPrint:Say (800,350, "--------------------------------"		,oFont15)
		oPrint:Say (815,390, "Aclaración"		,oFont15)

		oPrint:cPathPDF := _cPath

		oPrint:Print()
		oPrint:EndPage()

		ShellExecute("open",_cPath+_cNomePdf, "", "", 1)

	EndIf

Return()