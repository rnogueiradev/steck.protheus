#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE 'APVT100.CH'

#DEFINE CODROM	01
#DEFINE DTEMIS	02
#DEFINE NOTAFI	03
#DEFINE SERIES	04
#DEFINE CLIENT	05
#DEFINE LOJACL	06
#DEFINE PEDIDO	07
#DEFINE NTRANS	08
#DEFINE BAIRRO	09
#DEFINE MUNICI	10
#DEFINE TELCLI	11
#DEFINE CONTAT	12
#DEFINE QTDVOL	13
#DEFINE PBRUTO	14
#DEFINE NPLACA	15
#DEFINE NCLIEN	16
#DEFINE ENDENT	17
#DEFINE MOTORI	18
#DEFINE AJUDA1	19
#DEFINE AJUDA2	20
#DEFINE TIPROM	21
#DEFINE TELEFO	22
#DEFINE HRROM	23
#DEFINE CEP     24
#DEFINE PEDWEB  25

Static oFont06	:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
Static oFont06N	:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
Static oFont08	:= TFont():New("Arial",07,07,,.F.,,,,.T.,.F.)
Static oFont08N	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
Static oFont12	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
Static oFont12N	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
Static oFont14 	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
Static oFont14N	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
Static oFont16 	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
Static oFont16N	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
Static oFont18 	:= TFont():New("Arial",18,18,,.F.,,,,.T.,.F.)
Static oFont18N	:= TFont():New("Arial",18,18,,.T.,,,,.T.,.F.)

Static oBrush  := TBrush():New(,(0,0,0))
Static oBrush2 := TBrush():New(,CLR_HGRAY) // Cinza Claro
Static oBrush3 := TBrush():New(,CLR_YELLOW) // Amarelo Claro
Static nTotPag := 0

Static nColMax := 800

/*/Protheus.doc STFSF60C
(long_description)
Relatório de Romaneios
@type  Function
@author user
Valdemir Rabelo
@since 10/09/2019
@version 12.1.25
/*/

User Function STFSR60C(pRoma1, pRoma2, plDireto)

	Local cPasta        := "\arquivos\relatorio_romaneio\"
	Local cRomaneioAtu  := ""
	Local oPrint        := Nil
	Local nLin          := 0
	Local lRET          := .F.
	Local cArqPDF       := ""
	Local cPastaRom     := ""
	Local nX
	Private cPerg       := "STFSR60C"
	Private aImpDet     := {}
	Private m_pag       := nAlt := 0
	Private nUltColCab  := 0
	Private oFont10 	:= TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)   // alterado 19/02/2020
	Private oFont10N	:= oFont10    //TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)   // alterado 19/02/2020
	Default pRoma1   := ""
	Default pRoma2   := ""
	Default plDireto := .T.

	If Empty(pRoma1) .And. Empty(pRoma2)
		AjustaSX1()
		If !Pergunte(cPerg,.T.)
			Return
		EndIf
		pRoma1 := MV_PAR01
		pRoma2 := MV_PAR02
	EndIf

	if !ExistDir(cPasta)
	   MAKEDIR( cPasta )
	endif 
	
	CursorArrow()                 // Cursor flecha
	CursorWait()                  // Cursor Ampulheta

	//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
	//aImpDet := MntSTF60(pRoma1, pRoma2)
	aImpDet := U_MntSTF60(pRoma1, pRoma2)
	
	//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
	//SomaPag(aImpDet)
	U_SomaPag(aImpDet)

	m_pag        := 0
	cRomaneioAtu := ""
	nAlt         := 9 // 12

If Len(aImpDet) > 0

	For nX := 1 to Len(aImpDet)
		If cRomaneioAtu <> aImpDet[nX,01]
		    cPastaRom := aImpDet[nX,CODROM]
		    cArqPDF   := "ROMANEIO_" + aImpDet[nX,CODROM]+".pdf"
			If nLin > 0
				oPrint:Preview()
				FreeObj(oPrint)
				if file(cPasta+cArqPDF)
				   __CopyFile(cPasta+cArqPDF, "C:\relatorio_romaneio\"+RetFileName(cArqPDF))
				endif 
				oPrint := Nil
			EndIf
			
			oPrint := NewPrint("ROMANEIO_" + aImpDet[nX,CODROM], plDireto)
			if (oPrint==nil)
			   return .F.
			endif 
			oPrint:cPathPDF := cPasta    
		EndIf
		If (nLin == 0) .Or. (nLin > 530)
			If nLin > 530
				oPrint:EndPage()
				Conout("Saltando pagina")
			EndIf
			Conout("Imprimindo cabecalho")
			nLin := Cabec(oPrint, nX, aImpDet)
		EndIf
		Conout("Imprimindo detalhes")

		//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
		U_ImpDet(oPrint, nX, aImpDet, @nLin)

		cRomaneioAtu := aImpDet[nX,01]
	Next
	Conout("Ira iniciar a impressao")
	If oPrint <> Nil
		If plDireto
			oPrint:Print()
			lRET := .T.
			
		Else
			oPrint:Preview()
			lRET := .T.
		EndIf
	Endif 

	FreeObj(oPrint)
	oPrint := Nil

	// Valdemir Rabelo 24/11/2021 - Ticket: 20210617010297
	// Se existir eu deleto ele
	if File("C:\relatorio_romaneio\"+cPastaRom+"\"+cArqPDF)
	   FErase("C:\relatorio_romaneio\"+cPastaRom+"\"+cArqPDF)  //FR voltar
	endif 
	// Copiando do Servidor para a maquina
	if file(cPasta+cArqPDF)
		__CopyFile(cPasta+cArqPDF, "C:\relatorio_romaneio\"+cPastaRom+"\"+cArqPDF)
	endif 


	CursorArrow()                 // Cursor flecha

Endif  //len aImpDet

Return lRET

//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
//Static Function SomaPag(aImpDet)
User Function SomaPag(aImpDet)

	Local nLI   := 0
	Local nLin  := 0
	Local nX    := 0

	For nX := 1 to Len(aImpDet)
		If (nLI == 0) .Or. (nLI > 530)
			nLI := Cabec(Nil, nX, aImpDet,.T.)
		EndIf
		//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
		U_ImpDet(Nil, nX, aImpDet, @nLin)
		nLI += 118
		cRomaneioAtu := aImpDet[nX,01]
	Next

Return

/*/Protheus.doc MntSTF60
	(long_description)
	Carrega Registros para serem apresentado no relatório
	@type  Function
	@author user
	Valdemir Rabelo
	@since 10/09/2019
	@version 12.1.25
/*/

//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
//Static Function MntSTF60(pRoma1, pRoma2)
User Function MntSTF60(pRoma1, pRoma2)

	Local aRET   := {}
	Local cQuery := ""
	Local aArea  := GetArea()

	cQuery := " Select PD2_CODROM, PD2_NFS, PD2_SERIES, PD2_CLIENT, PD2_LOJCLI, PD2_QTDVOL, PD2_PBRUTO "
	cQuery += " From " + RetSqlName("PD2") + " PD2 "
	cQuery += " Where PD2_FILIAL = '" + xFilial("PD2") + "' AND "
	cQuery += "     PD2_CODROM >= '" + pRoma1 + "' AND PD2_CODROM <= '" + pRoma2 + "' AND "
	cQuery += "     PD2.D_E_L_E_T_ = ' ' "
	cQuery += " Order by PD2_ORDROT, PD2_NFS,PD2_SERIES "
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)

	dbSelectArea("SC5")
	SC5->( dbSetOrder(1) )
	SA1->( dbSetOrder(1) )
	SA4->( dbSetOrder(1) )
	SF2->( dbSetOrder(1) )
	SD2->( dbSetOrder(3) )
	PD1->( dbSetOrder(1) )

	TMP->( dbGoTop() )
	While TMP->( !Eof() )
		PD1->( dbSeek(xFilial("PD1") + TMP->PD2_CODROM) )
		SF2->( dbSeek(xFilial("SF2") + TMP->(PD2_NFS + PD2_SERIES + PD2_CLIENT + PD2_LOJCLI)) )
		SA4->( dbSeek(xFilial("SA4") + SF2->F2_TRANSP) )
		SA1->( dbSeek(xFilial("SA1") + TMP->(PD2_CLIENT + PD2_LOJCLI)) )
		SD2->( dbSeek(xFilial("SD2") + TMP->(PD2_NFS + PD2_SERIES + PD2_CLIENT + PD2_LOJCLI)) )
		SC5->( dbSeek(SD2->(D2_FILIAL + D2_PEDIDO)) )
		aAdd(aRET,{	TMP->PD2_CODROM,PD1->PD1_DTEMIS,TMP->PD2_NFS,TMP->PD2_SERIES,TMP->PD2_CLIENT,TMP->PD2_LOJCLI,SD2->D2_PEDIDO,SA4->A4_NOME,;
			SA1->A1_BAIRRO,SA1->A1_MUN,SA1->A1_TEL,SA1->A1_CONTATO,TMP->PD2_QTDVOL, Transform(TMP->PD2_PBRUTO,"@E 999,999.99"),PD1->PD1_PLACA,SA1->A1_NOME,;
			SA1->A1_END,PD1->PD1_MOTORI,PD1->PD1_AJUDA1,PD1->PD1_AJUDA2,PD1->PD1_TPROM,SA4->A4_TEL,PD1->PD1_HRROM,SA1->A1_CEP,SC5->C5_XWEB})

		TMP->( dbSkip() )
	Enddo
	TMP->( dbCloseArea() )

	RestArea( aArea )

Return aRET

/*/Protheus.doc AjustaSX1
	(long_description)
	Cria um grupo de perguntas
	@type  Function
	@author user
	Valdemir Rabelo
	@since 11/09/2019
	@version 12.1.25
/*/

Static Function AjustaSX1()

	Local cAlias        := Alias()
	Local aRegistros    := {}
	Local i             := 0
	Local j             := 0

	aAdd(aRegistros,{Padr(cPerg,Len(SX1->X1_GRUPO),""),"01","Romaneio de          ?","","","mv_ch1","C",TamSX3("PD1_CODROM")[01]	,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegistros,{Padr(cPerg,Len(SX1->X1_GRUPO),""),"02","Romaneio ate         ?","","","mv_ch2","C",TamSX3("PD1_CODROM")[01]	,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	dbSelectArea("SX1")
	SX1->( dbSetOrder(1) )
	For i := 1 to Len(aRegistros)
		If !dbSeek(aRegistros[i,1] + aRegistros[i,2])
			RecLock("SX1",.T.)
			For j := 1 to FCount()
				FieldPut(j,aRegistros[i,j])
			Next j
			MsUnlock()
		EndIf
	Next I

	dbSelectArea(cAlias)

Return

/*/Protheus.doc Cabec
	(long_description)
	Cria o cabeçalho do Relatório
	@type  Function
	@author user
	Valdemir Rabelo
	@since 11/09/2019
	@version 12.1.25
/*/

Static Function Cabec(oPrint, nX, aImpDet)

	Local nLinha  := 30
	Local cTitCab := ""
	Local cLogo   := FisxLogo("1")

	If aImpDet[nX,TIPROM] == "1"
		cTitCab := "ROMANEIO DE ENTREGA"
	Else
		cTitCab := "ROMANEIO DE RETIRADA"
	EndIf

	nLinha := TITULOCABEC( oPrint, cTitCab, "" ,"", "P", 1, 14)

	nLinha += 4
	//oPrint:FillRect({nLinha, 02, nLinha+13, nColMax }, oBrush2)    // Removido por solicitação de Edmar e Kleber - 21/02/2020
	If oPrint != Nil
		oPrint:Box(nLinha, 02, nLinha+74, nColMax)
	EndIf

	nLinha += 7

	cCode := AllTrim(aImpDet[nX,CODROM])

	If oPrint != Nil
		oPrint:FWMSBAR("CODE128",;        // 01 - Tipo Código Barra
		nLinha-47.1,;                              // 02 - Linha -- -09
		59.5,;                            // 03 - Coluna
		RTrim(cCode),;                    // 04 - Chave Codigo barra
		oPrint,;                          // 05 - Objeto Printer
		,;                                // 06 - Se calcula o digito de controle. Defautl .T.
		,;                                // 07 - Numero da Cor, utilize a "color.ch". Default CLR_BLACK
		,;                                // 08 - Se imprime na Horizontal. Default .T.
		0.030,;                           // 09 - Numero do Tamanho da barra. Default 0.025
		0.80,;                            // 10 - Numero da Altura da barra. Default 1.5
		.F.,;                             // 11 - Se imprime a linha com o código embaixo da barra. Default .T.
		,;                                // 12 - Nome do Fonte a ser utilizado. Defautl "Arial"
		,;                                // 13 - Modo do codigo de barras CO. Default ""
		.f.,;                             // 14 - Se executa o método Print() de oPrinter pela MsBar. Default .T.
		,;                                // 15 - Número do índice de ajuste da largura da fonte. Default 1
		,;                                // 16 - Número do índice de ajuste da altura da fonte. Default 1
		)                                // 17 - Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
	EndIf

	If oPrint != Nil
		oPrint:Say (nLinha, 005, cTitCab + " " + AllTrim(aImpDet[nX,CODROM]) + " - DIA: " + DtoC(aImpDet[nX,DTEMIS]) + " - " + aImpDet[nX,HRROM], oFont10N )
	EndIf
	nLinha += nAlt
	If oPrint != Nil
		oPrint:Say (nLinha, 005,"MOTORISTA: ", oFont10 )
		oPrint:Say (nLinha, 060, If(!Empty(AllTrim(aImpDet[nX,MOTORI])), AllTrim(aImpDet[nX,MOTORI]), "___________________________________________"), oFont10N )
		oPrint:Say (nLinha, 300,"AJUDANTE 1 : ", oFont10 )
		oPrint:Say (nLinha, 355, If(!Empty(AllTrim(aImpDet[nX,AJUDA1])), AllTrim(aImpDet[nX,AJUDA1]), "___________________________________________"), oFont10N )
	EndIf
	nLinha += nAlt
	If oPrint != Nil
		oPrint:Say (nLinha, 005,"PLACA: ", oFont10 )
		oPrint:Say (nLinha, 060, If(!Empty(AllTrim(aImpDet[nX,NPLACA])), AllTrim(aImpDet[nX,NPLACA]), "_________________________"), oFont10N )
		oPrint:Say (nLinha, 300,"AJUDANTE 2 : ", oFont10 )
		oPrint:Say (nLinha, 355, If(!Empty(AllTrim(aImpDet[nX,AJUDA2])), AllTrim(aImpDet[nX,AJUDA2]), "___________________________________________"), oFont10N )
	EndIf
	nLinha += 22

Return nLinha

/*/Protheus.doc ImpDet
	(long_description)
	Cria o corpo do relatório
	@type  Function
	@author user
	Valdemir Rabelo
	@since 11/09/2019
	@version 12.1.25
/*/
//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
//Static Function ImpDet(oPrint, nX, aImpDet, nLinha)
User Function ImpDet(oPrint, nX, aImpDet, nLinha)

	Local _cOS    := GetOs(aImpDet[nX,NOTAFI])
	Local nColAju := 580

	If oPrint != Nil
		oPrint:Box(nLinha-14, 002, nLinha+109, 800)
		oPrint:Line(nLinha-13, nColAju,nLinha+108, nColAju, 0, "-2" )
	EndIf
	nLinha -= 3
	If oPrint != Nil
		oPrint:Say (nLinha, 005,"NOTA FISCAL: ", oFont10 )
		oPrint:Say (nLinha, 060,aImpDet[nX,NOTAFI], oFont10N,,CLR_BLUE)
		oPrint:Say (nLinha, nColAju+090,"CONFIRMAÇÃO", oFont10 )
	EndIf
	nLinha += nAlt
	If oPrint != Nil
		oPrint:Say (nLinha, 005,"PEDIDO: ", oFont10 )
		oPrint:Say (nLinha, 060,aImpDet[nX,PEDIDO] + " OS: " + GetOs(aImpDet[nX,NOTAFI]), oFont10N )
		If !Empty(aImpDet[nX,PEDWEB])
			oPrint:Say (nLinha, 300,"PED. INTERNET: ", oFont10N )
			oPrint:Say (nLinha, 360,AllTrim(aImpDet[nX,PEDWEB]), oFont10N )
		EndIf
	EndIf
	nLinha += nAlt
	If oPrint != Nil
		oPrint:Say (nLinha, 005,"CLIENTE: ", oFont10 )                          // Valdemir Rabelo 19/02/2020
		oPrint:Say (nLinha, 060,AllTrim(aImpDet[nX,NCLIEN]), oFont10N )
	endif
	nLinha += nAlt
	if oPrint != nil
		oPrint:Say (nLinha, 005,"TRANSP: ", oFont10 )
		oPrint:Say (nLinha, 060,AllTrim(aImpDet[nX,NTRANS]), oFont10N )
		oPrint:Say (nLinha, 300,"TELEFONE: ", oFont10 )
		oPrint:Say (nLinha, 360,AllTrim(aImpDet[nX,TELEFO]), oFont10N )
		oPrint:Say (nLinha, nColAju+10,"NOME ", oFont10 )
	EndIf
	nLinha += nAlt
	If oPrint != Nil
		oPrint:Say (nLinha, 005,"END ENTREG: ", oFont10 )
		oPrint:Say (nLinha, 060,alltrim(aImpDet[nX,ENDENT]) + " - CEP:"+aImpDet[nX,CEP], oFont10N )
	EndIf
	nLinha += nAlt
	If oPrint != Nil
		oPrint:Say (nLinha, 005,"BAIRRO: ", oFont10 )
		oPrint:Say (nLinha, 060,alltrim(aImpDet[nX,BAIRRO]), oFont10N )
		oPrint:Say (nLinha, 300,"MUNICIPIO: ", oFont10 )
		oPrint:Say (nLinha, 360,alltrim(aImpDet[nX,MUNICI]), oFont10N )
		oPrint:Say (nLinha, nColAju+10,"RG: ", oFont10 )                           // Valdemir Rabelo 19/02/2020
	EndIf
	nLinha += nAlt
	If oPrint != Nil
		oPrint:Say (nLinha, 005,"CONTATO: ", oFont10 )
		oPrint:Say (nLinha, 040, aImpDet[nX,CONTAT], oFont10N )
		oPrint:Say (nLinha, 300,"TELEFONE: ", oFont10 )
		oPrint:Say (nLinha, 360,AllTrim(aImpDet[nX,TELCLI]), oFont10N )
	EndIf
	nLinha += 7
	If oPrint != Nil
		oPrint:Line(nLinha, 002,nLinha, nColAju, 0, "-2" )
		oPrint:Say (nLinha, nColAju+10, "DATA:   ____/____/______ ", oFont10 )
	EndIf
	nLinha += nAlt
	If oPrint != Nil
		oPrint:Say (nLinha, 005,"OBSERVAÇÃO: ", oFont10 )
		oPrint:Line(nLinha, 80,nLinha, 500, 0, "-2" )
	EndIf
	nLinha += nAlt   //14
	If oPrint != Nil
		oPrint:Line(nLinha, 80,nLinha, 500, 0, "-2" )
	EndIf
	nLinha += nAlt   //14
	If oPrint != Nil
		oPrint:Say (nLinha, 005,"N. VOLUMES: ", oFont10 )
		oPrint:Say (nLinha, 060, Transform(aImpDet[nX,QTDVOL], "@E 999"), oFont10N )
		oPrint:Say (nLinha, 300,"PESO: ", oFont10 )
		oPrint:Say (nLinha, 350, aImpDet[nX,PBRUTO], oFont10N )
		oPrint:Say (nLinha, nColAju+10,"HR ENTREGA: _____:_____", oFont10 )                           // Valdemir Rabelo 19/02/2020
	EndIf
	nLinha += nAlt+2   //14
	If oPrint != Nil
		oPrint:Say (nLinha, 005,"LOC.EXPED.: "+GetLcExp(_cOS), oFont10 )                              // Valdemir Rabelo 19/02/2020
		oPrint:Say (nLinha, nColAju+10,"HR SAÍDA:       _____:_____", oFont10 )                       // Valdemir Rabelo 19/02/2020
	EndIf
	nLinha += 18

Return

/*/Protheus.doc Cabec
	(long_description)
	Cria a instância do Objeto de impressão
	@type  Function
	@author user
	Valdemir Rabelo
	@since 11/09/2019
	@version 12.1.25
/*/

Static Function NewPrint(pArquivo, plDireto)
	Local lSTTNTCOL       := FWIsInCall("u_STIMPROM") // Ticket: 20210617010297
	Local lServer         := FWIsInCall("u_STIMPROM") .or. FWIsInCall("u_STFATROM")
	Local oRET            := Nil
	Local lAdjustToLegacy := .F.
	Local lDisableSetup   := .T.
	Local aImpres         := GetImpWindows(lServer)    // Busco as impressoras .T. = Server .F. = Local
	Local DIRECAO         := IF(plDireto, IMP_SPOOL, IMP_PDF)    //if(lSTTNTCOL, IMP_PDF, If(plDireto, IMP_SPOOL, IMP_PDF))
	// Ticket 20210601009161 - Impressão de NF e Romaneio - Eduardo Pereira - Sigamat - 04.06.2021 - Inicio
	
	//FR - 30/08/2022 - CORREÇÃO DA IMPRESSÃO DO ROMANEIO VIA ROTINA COLETOR U_STIMPROM
	Local cImpress        := "" 
	//COMENTADO POR FR: //Upper(alltrim(iif(FWIsInCall("U_STTNTCOL") .or. FWIsInCall("u_STIMPROM"),GetMV("FS_ROMEXPE",.F.,"F02 - Expedicao"), GetMV("FS_XIMPRES",.F.,"DIRECAO") ) ) ) // Valdemir Rabelo 08/11/2021
	//FR - 30/08/2022 - CORREÇÃO DA IMPRESSÃO DO ROMANEIO VIA ROTINA COLETOR U_STIMPROM
	
	// Ticket 20210601009161 - Impressão de NF e Romaneio - Eduardo Pereira - Sigamat - 04.06.2021 - Fim
	Local aDevice         := {}
	Local cSession        := GetPrinterSession()
	Local nLocal          := 1
	Local nOrient         := 1
	Local nPrintType      := 6
	
	//cImpress:= GetNewPar("FS_ROMEXPE" , "\\sw2012h01\F02-Transportes") //deu certo, essa é a regra, \\nome servidor\nome compartilhamento da impressora

	//QDO A IMPRESSÃO DO ROMANEIO É ORIGEM COLETOR, USA ESTA IMPRESSORA	
	If FWIsInCall(Alltrim(Upper("U_STIMPROM")))
		cImpress := GetNewPar("FS_ROMEXP2","\\sw2012h01\F02-Bancada")	//FR - 31/08/2022 - FIXAR APENAS UMA IMPRESSORA

	//QDO A IMPRESSÃO DO ROMANEIO É ORIGEM APENAS PROTHEUS (tela grande romaneio STFATROM)
	Elseif FWIsInCall(Alltrim(Upper("U_STFATROM")))
		cImpress := GetNewPar("FS_ROMEXPE","\\sw2012h01\F02-Transportes")
	Endif 	

	If plDireto       
        //cImpress:= GetNewPar("FS_ROMEXPE" , "\\sw2012h01\F02-Transportes")
        lServer := .F.
        //cImpress:= "EPSONDDEC5B (L3150 Series)" //FR teste    - deu certo impressora local RETIRAR DEPOIS
        //cImpress := "Lexmark International Lexmark X656de"    - impressora instalada na maquina do Euler
        //cImpress := "F02-Transportes"                         - só o nome de compartilhamento não funciona tem q vir antes o nome do servidor
        
		// FR - 01/09/2022 - TENTATIVA PARA SABER SE AO ESCOLHER PDF 
		if aScan(aImpres, {|X| alltrim(upper(X))==alltrim(upper(cImpress))})==0         // Procuro no servidor
			aImpres := GetImpWindows(.F.)												// Verifico Impressora Local
			if aScan(aImpres, {|X| alltrim(upper(X))==alltrim(upper(cImpress))})==0
				MsgInfo("Impressora: "+cImpress+" não encontrada"+CRLF+;
						"Verifique se existe impressora com nome: "+cImpress+", ou se está desligada.")
				Return nil 
			endif 
			lServer := .F.
		endif	
	
	Endif    
	/*
    // Valdemir 16/11/2021 - Ticket: 20211116024527
    if aScan(aImpres, {|X| alltrim(upper(X))==alltrim(upper(cImpress))})==0         // Procuro no servidor
        aImpres := GetImpWindows(.F.)												// Verifico Impressora Local
        if aScan(aImpres, {|X| alltrim(upper(X))==alltrim(upper(cImpress))})==0
            MsgInfo("Impressora: "+cImpress+" não encontrada"+CRLF+;
                    "Verifique se existe impressora com nome: "+cImpress+", ou se está desligada.")
            Return nil 
        endif 
        lServer := .F.
    endif
	*/

	AADD(aDevice,"DISCO") // 1
	AADD(aDevice,"SPOOL") // 2
	AADD(aDevice,"EMAIL") // 3
	AADD(aDevice,"EXCEL") // 4
	AADD(aDevice,"HTML" ) // 5
	AADD(aDevice,"PDF"  ) // 6

	cSession   := GetPrinterSession()
	cDevice    := If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
	nOrient    := If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
	nLocal     := If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
	nPrintType := aScan(aDevice,{|x| x == cDevice })

	if File('\arquivos\relatorio_romaneio\'+pArquivo+".pdf")
	   Conout("Arquivo encontrado na pasta: \arquivos\relatorio_romaneio\")
	   FErase('\arquivos\relatorio_romaneio\'+pArquivo+".pdf")
	   Conout("Arquivo excluído para nova geração.")
	endif 

	conout("Criando instancia para montagem do relatorio")
	oRET := FWMSPrinter():New(pArquivo+".pdf", DIRECAO, lAdjustToLegacy,'\arquivos\relatorio_romaneio\', lDisableSetup,,,upper(alltrim(cImpress)),lServer,,,.F.,)
	oRET:SetResolution(72)	        // Default
	oRET:SetLandscape() 		    // SetLandscape() ou SetPortrait()
	oRET:SetPaperSize(9)	        // A4 210mm x 297mm  620 x 876
	oRET:SetMargin(60,60,60,60)

      //Força a impressão em PDF / SPOOL
	oRET:nDevice  := DIRECAO     //6
	oRET:cPathPDF := '\arquivos\relatorio_romaneio\'
	oRET:cPrinter := cImpress
	oRET:lServer  := lServer
	oRET:lViewPDF := .F.	

	conout("Arquivo sera salvo na pasta \arquivos\relatorio_romaneio\")
	conout("arquivo a ser criado é: "+pArquivo+".pdf")

Return oRET


/*/Protheus.doc GeOS
	(long_description)
	Retorna Codigo da OS
	@type  Function
	@author user
	Valdemir Rabelo
	@since 19/02/2020
	@version 12.1.25
/*/

Static Function GetOs(_cNf)

	Local _cRet 	:= ""
	Local _cQuery1 	:= ""
	Local _cAlias1  := GetNextAlias()

	_cQuery1 := " SELECT CB7_ORDSEP
	_cQuery1 += " FROM " + RetSqlName("CB7") + " CB7
	_cQuery1 += " WHERE CB7.D_E_L_E_T_ = ' '
	_cQuery1 += "   AND CB7_FILIAL = '" + xFilial("CB7") + "'
	_cQuery1 += "   AND CB7_NOTA = '" + _cNf + "'
	If !Empty(Select(_cAlias1))
		dbSelectArea(_cAlias1)
		(_cAlias1)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->( dbGoTop() )
	While (_cAlias1)->( !Eof() )
		_cRet += (_cAlias1)->CB7_ORDSEP + " / "
		(_cAlias1)->( dbSkip() )
	EndDo

Return _cRet

/*/Protheus.doc GetLcExp
	(long_description)
	Retorna local
	@type  Function
	@author user
	Valdemir Rabelo
	@since 19/02/2020
	@version 12.1.25
/*/

Static Function GetLcExp(_cOS)

	Local cRET    := ""
	Local aAreaLC := GetArea()

	dbSelectArea("SZ5")
	dbSetOrder(1)
	dbGotop()
	If (dbSeek(xFilial("SZ5") + Alltrim(StrTran(_cOS,"/",""))))
		While !Eof() .And. SZ5->Z5_FILIAL == xFilial("SZ5") .And. SZ5->Z5_ORDSEP == Alltrim(StrTran(_cOS,"/",""))
			If Empty(cRET)
				cRET :=  Alltrim(SZ5->Z5_ENDEREC)
			Else
				cRET :=  cRET + "/" + Alltrim(SZ5->Z5_ENDEREC)
			EndIf
			SZ5->( dbSkip() )
		End
	EndIf

	RestArea( aAreaLC )

Return cRET

Static Function TITULOCABEC(oPrint, pTITULO, pSubTit ,pSubTit1, pTipo, pCont, pnTamF)

	Local oFontCab      := TFont():New("Arial", 10, 10,,.t.,,,,.T.,.F.)
	Local nReturn       := 010//045
	Local nColPix
	Local nCol          := 0
	Local cSubPag       := ' / ' + StrZero(pCont,2)
	Local nUltColPos    :=  0
	Local aPosTitulo    := {}
	Local oFontTit      := TFont():New("Arial",pnTamF,pnTamF,,.T.,,,,.T.,.F.)

	nCol := If(Len(aPosTitulo) == 0, 5, aPosTitulo[1])

	If oPrint != Nil
		If Len(aPostitulo) > 0
			nUltColPos := aPosTitulo[17]
		Else
			ultCol := 650
		EndIf
		nUltColCab := If(pTipo == "P", If(Len(aPosTitulo) < 32,700, ultCol), 1400)
		oPrint:EndPage()
		oPrint:StartPage() 						// Inicia uma nova pagina
		cFont:=oFont10
		m_pag++
		nReturn += 20
		oPrint:say(nReturn+8 ,005,Alltrim(SM0->M0_NOME) + " " + Alltrim(pTITULO),oFontTit)
		oPrint:say (nReturn+8 , If(pTipo == "P", If( Len(aPosTitulo) < 32,575, ultCol), If(Len(aPosTitulo) < 32,ultCol,ultCol)-80), "IMPRESSO EM " + (DtoC(dDatabase) + " " + Time()) + " - PAG.: " + StrZero(m_pag,3) + " de " + StrZero(nTotPag,3),oFontCab)
		nReturn += 10 //60
	Else
		m_pag++
		nReturn += 30
		nTotPag := m_pag
	EndIf

Return nReturn
