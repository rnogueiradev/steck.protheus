#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'APVT100.CH'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"

Static	nConta  := 0
Static	cCssLim := "QPushButton { color:#fff;background-color:#FF0000;border-color:#FF0000 }"
Static  cCSSPnl := "QLabel {color:#00FF22; font-size:10px; }"

/* TMeter => QProgressBar */
Static  cCSSPnl := ""


/*/{Protheus.doc} STTNTCOL
description
Rotina  de geração de romaneio via coletor TNT
Ticket: 20200430001985
@type function
@version  
@author Valdemir Jose
@since 01/03/2021
@return return_type, return_description
/*/
User Function STTNTCOL()
	Local aTela  := VtSave()
	Local cRoma  := Space(10)

	While .t.
		VTCLear()
		cRoma  := Space(10)
		@ 00,00 VtSay  "Romaneio"
		//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
		@ 01,00 VTGet cRoma Picture "@!" F3 "PD1" Valid U_getVldRo(@cRoma)
		VTRead
		If VtLastkey() == 27
			if VTYesNo("Deseja Imprimir romaneio e Danfe?",".:ATENCAO:.",.T.)
				//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
				U_EncerRom(cRoma)
			else
				if VTYesNo("Deseja realmente sair?",".:ATENCAO:.",.T.)
					Exit
				endif
			endif
		EndIf
		// Chama Embarque
		u_STFSFA62(cRoma)
	EndDo

	VtRestore(,,,,aTela)

Return

/*/{Protheus.doc} getVldRo
description
@type function
@version  
@author Valdemir Jose
@since 02/03/2021
@param cRoma, character, param_description
@return return_type, return_description
/*/
//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
//Static Function getVldRo(cRoma)
User Function getVldRo(cRoma)
	Local lRET        := .T.
	Local aTela1      := VtSave()
	Local lAdic       := .T.
	Local lSair       := .F.
	Local lGrv        := .F.
	Local lEncerra    := .F.
	Local lPendent    := .F.     // Ticket: 20211116024527 - Valdemir Rabelo
	Local cPlaca      := Space(08)
	Local cOrdSep     := Space(10)
	//Local cSerie      := Space(03)
	Local _cRegiao    := ""
	Local nRegsPD2    := 0
	Local nAndamentos := 0
	Local nFechados   := 0
	Local cStatus     := ""
	Local nVols       := 0
	Local nPesoL      := 0
	Local nPesoB      := 0
	Local nLido       := 0
	Public bkey01,bkey02

	dbselectarea("SE2")
	SE2->(dbSetOrder(1))

	dbSelectArea("CB7")
	DbSetOrder(1)

	dbSelectArea("PD2")
	dbSetOrder(2)

	dbSelectArea("PD1")
	dbSetOrder(1)

	if !Empty(cRoma)
		lAdic := PD1->(!dbSeek(xFilial("PD1")+cRoma))
	Endif

	if lAdic
		if !VTYesNo("Deseja criar o romaneio? ",".:ATENCAO:.",.T.)
			VtBeep(3)
			VtAlert("Romaneio nao sera criado",	"Atencao",.t.,4000)
			return .F.
		endif
		cRoma := PD1->(GetSX8Num("PD1","PD1_CODROM"))
		ConfirmSX8()
		@ 00,00 VtSay "Romaneio"
		@ 01,00 VtSay cRoma

		PD1->(RecLock("PD1",.T.))
		PD1->PD1_FILIAL := xFilial("PD1")
		PD1->PD1_CODROM := cRoma
		PD1->PD1_DTEMIS := dDataBase
		PD1->PD1_STATUS := "1"
		PD1->PD1_TPROM  := "1"
		MsUnlock()

		lGrv := .F.
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSelectArea("SF2")
		dbSetOrder(1)
		While !lSair

			cOrdSep := Space(33)
			@ 02,00 VtSay  "Total Lido: "+cValToChar(nLido)
			@ 03,00 VtSay  "Ordem Separacao: "
			@ 04,00 VTGet cOrdSep Picture "@!"  Valid !Empty(cOrdSep)
			VTRead
			If VtLastkey() == 27
				if VTYesNo("Nao ira lancar mais OS? Deseja Sair?",".:ATENCAO:.",.T.)
					Exit
				endif
			EndIf
			if (Len(alltrim(cOrdSep)) > 0) .and. (Len(alltrim(cOrdSep)) >= 11)
				cOrdSep := Substr(cOrdSep, 11, 6)
			elseif (Len(alltrim(cOrdSep)) == 6)
				cOrdSep := Alltrim(cOrdSep)
			endif
			IF !CB7->(DbSeek(xFilial("CB7")+cOrdSep))
				VtAlert("Ordem Separacao nao encontrado",	"Atencao",.t.,4000)
				Loop
			Endif

			//Bloco - Projeto DHL - 20230405004135 - LG

			PD1->(RecLock("PD1",.F.))
			IF CB7->CB7_TRANSP = "004415"
				PD1->PD1_PLACA  := "DHL"
				PD1->PD1_MOTORI := "DHL"
				PD1->PD1_AJUDA1 := "DHL"
			Else
				PD1->PD1_PLACA  := "BRASPRES"
				PD1->PD1_MOTORI := "BRASPRES"
				PD1->PD1_AJUDA1 := "BRASPRES"
			ENDIF
			pd1->(MsUnLock())

			if Empty(CB7->CB7_NOTA)
				VtAlert("Nota Fiscal nao pode ser em branco",	"Atencao",.t.,4000)
				Loop
			else

				if SF2->( !dbSeek(xFilial("SF2")+CB7->CB7_NOTA+CB7->CB7_SERIE) )
					VtAlert("Nota Fiscal nao encontrado",	"Atencao",.t.,4000)
					Loop
				else
					// Posiciona Cliente - Ticket: 20211116024527 - Valdemir Rabelo 16/11/2021
					IF !SA1->( dbSeek(XFilial('SA1')+SF2->(F2_CLIENTE+F2_LOJA) ) )
						VtAlert("Cliente: "+SF2->F2_CLIENTE+" nao encontrado",	"Atencao",.t.,4000)
						Loop
					Endif
					if Empty(SF2->F2_CHVNFE)         // Valdemir Rabelo 03/05/2022
						VtAlert("Nota Fiscal não faturada, favor aguardar o faturamento",	"Atencao",.t.,4000)
						Loop
					endif

					if !Empty(SF2->F2_XTRIAN)
						VtAlert("Nota Fiscal triangular não pode ser lancado",	"Atencao",.t.,4000)
						Loop
					endif
					lPendent := .F.
					if !Empty(SF2->F2_XGUIA)
						If SE2->(DbSeek(Xfilial("SE2")  +SF2->F2_XPRFGUI+padr(alltrim(SF2->F2_EST+Right( AllTrim( SF2->F2_DOC ) , 5 )),9,' ')+'   '+'TX ESTADO00' ) )//BUSCA GUIA DE RECOLHIMENTO NO FINANCEIRO
							If SE2->E2_SALDO > 0
								lPendent := .T.     // 'Pendente'
							Endif
						Else
							lPendent := .T.         // 'Pendente'
						Endif
						VtAlert("Nota Fiscal Pendente GUIA",	"Atencao",.t.,4000)
					Endif
					// Ticket: 20211116024527 - Valdemir Rabelo 16/11/2021
					if !Empty(SF2->F2_XPIN)
						VtAlert("Nota Fiscal Pendente PIN",	"Atencao",.t.,4000)
						lPendent := .T.         // 'Pendente'
					endif
					if ((ALLTRIM(SA1->A1_ATIVIDA)=="E3") .AND. (ALLTRIM(SF2->F2_EST) == 'MS') .AND. (SF2->F2_XDECLA=="S"))
						VtAlert("Nota Fiscal Pendente DECLARACAO",	"Atencao",.t.,4000)
						lPendent := .T.         // 'Pendente'
					endif
					if lPendent
						Loop
					endif

					// Verificar se a nota já foi lançada - 09/08/2021 - Valdemir Rabelo Ticket: 20210617010297
					nRegPD2 := PD2->( Recno() )
					PD2->( dbSetOrder(2) )
					lInclui := PD2->( !dbSeek(xFilial('PD2')+SF2->F2_DOC+SF2->F2_SERIE) )

					IF !lInclui
						if (cRoma==PD2->PD2_CODROM)
							VtAlert("Nota Fiscal ja foi adicionada no Romaneio",	"Atencao",.t.,4000)
						else
							VtAlert("Nota Fiscal ja foi adicionada em outro Romaneio",	"Atencao",.t.,4000)
						endif
						Loop
					Endif
					PD2->( dbGoto(nRegPD2) )

				endif
			endif

			if lInclui
				//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
				lGrv := U_AddPD2(cRoma)
				if lGRV
					nLido++
				endif

			Endif
		EndDo

		lRET := .T.
	Else
		lGrv := .F.
		dbSelectArea("SF2")
		dbSetOrder(1)
		nLido := 0
		While !lSair
			//VTSetKey(118, bkey01)
			cOrdSep := Space(33)
			@ 02,00 VtSay  "Total Lido: "+cValToChar(nLido)
			@ 03,00 VtSay  "Ordem Separacao: "
			@ 04,00 VTGet cOrdSep Picture "@!"  Valid !Empty(cOrdSep)
			VTRead
			If VtLastkey() == 27
				if VTYesNo("Nao ira lancar mais OS? Deseja Sair?",".:ATENCAO:.",.T.)
					Exit
				endif
			EndIf
			if (Len(alltrim(cOrdSep)) > 0) .and. (Len(alltrim(cOrdSep)) > 6)
				cOrdSep := Substr(cOrdSep, 10, 6)
			elseif (Len(alltrim(cOrdSep)) == 6)
				cOrdSep := Alltrim(cOrdSep)
			endif
			IF !CB7->(DbSeek(xFilial("CB7")+cOrdSep))
				VtAlert("Ordem Separacao nao encontrado",	"Atencao",.t.,4000)
				Loop
			Endif
			if Empty(CB7->CB7_NOTA)
				VtAlert("Nota Fiscal nao pode ser em branco",	"Atencao",.t.,4000)
				Loop
			else
				if SF2->( !dbSeek(xFilial("SF2")+CB7->CB7_NOTA+CB7->CB7_SERIE) )
					VtAlert("Nota Fiscal nao encontrado",	"Atencao",.t.,4000)
					Loop
				else
					// Posiciona Cliente -  Ticket: 20211116024527 - Valdemir Rabelo 16/11/2021
					IF !SA1->( dbSeek(XFilial('SA1')+SF2->(F2_CLIENTE+F2_LOJA) ) )
						VtAlert("Cliente: "+SF2->F2_CLIENTE+" nao encontrado",	"Atencao",.t.,4000)
						Loop
					Endif

					if !Empty(SF2->F2_XTRIAN)
						VtAlert("Nota Fiscal triangular não pode ser lancado",	"Atencao",.t.,4000)
						Loop
					endif
					lPendent := .F.
					if !Empty(SF2->F2_XGUIA)
						If SE2->(DbSeek(Xfilial("SE2")  +SF2->F2_XPRFGUI+padr(alltrim(SF2->F2_EST+Right( AllTrim( SF2->F2_DOC ) , 5 )),9,' ')+'   '+'TX ESTADO00' ) )//BUSCA GUIA DE RECOLHIMENTO NO FINANCEIRO
							If SE2->E2_SALDO > 0
								lPendent := .T.     // 'Pendente'
							Endif
						Else
							lPendent := .T.         // 'Pendente'
						Endif
						VtAlert("Nota Fiscal Pendente GUIA",	"Atencao",.t.,4000)
					Endif
					// Ticket: 20211116024527 / 20210318004396 - Valdemir Rabelo 16/11/2021
					if !Empty(SF2->F2_XPIN)
						VtAlert("Nota Fiscal Pendente PIN",	"Atencao",.t.,4000)
						lPendent := .T.         // 'Pendente'
					endif
					if ((ALLTRIM(SA1->A1_ATIVIDA)=="E3") .AND. (ALLTRIM(SF2->F2_EST) == 'MS') .AND. (SF2->F2_XDECLA=="S"))
						VtAlert("Nota Fiscal Pendente DECLARACAO",	"Atencao",.t.,4000)
						lPendent := .T.         // 'Pendente'
					endif
					if lPendent
						Loop
					endif

					// Verificar se a nota já foi lançada - 09/08/2021 - Valdemir Rabelo Ticket: 20210617010297
					nRegPD2 := PD2->( Recno() )
					PD2->( dbSetOrder(2) )
					lInclui := PD2->( !dbSeek(xFilial('PD2')+SF2->F2_DOC+SF2->F2_SERIE) )

					IF !lInclui
						if (cRoma==PD2->PD2_CODROM)
							VtAlert("Nota Fiscal ja foi adicionada no Romaneio",	"Atencao",.t.,4000)
						else
							VtAlert("Nota Fiscal ja foi adicionada em outro Romaneio",	"Atencao",.t.,4000)
						endif
						Loop
					Endif
					PD2->( dbGoto(nRegPD2) )
					if lInclui
						//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
						lGrv := U_AddPD2(cRoma)
						if lGrv
							nLido++
						endif
					Endif
				endif
			endif
		EndDo

	Endif

	if lGrv
		// Atualiza Cabecalho
		PD1->(DbSetOrder(1))
		If	PD1->(DbSeek(xFilial("PD1")+cRoma))

			PD2->(DbSetOrder(1))
			If	PD2->(DbSeek(xFilial("PD2")+cRoma))
				While PD2->(!Eof() .AND. PD2_FILIAL+PD2_CODROM == xFilial("PD2")+cRoma)
					++nRegsPD2
					If PD2->PD2_STATUS == "1"      //Em andamento
						++nAndamentos
					ElseIf PD2->PD2_STATUS == "2"  //Fechados
						++nFechados
					Endif

					nVols 	+= PD2->PD2_QTDVOL
					nPesoL 	+= PD2->PD2_PLIQ
					nPesoB 	+= PD2->PD2_PBRUTO
					PD2->(DbSkip())
				Enddo

				If nFechados == nRegsPD2
					cStatus := If(lEncerra,"3","2")
				ElseIf nFechados>0 .OR. nAndamentos>0
					cStatus := "1"
				ElseIf nFechados==0 .OR. nAndamentos==0
					cStatus := "0"
				Endif

				//Atualiza informacao da tabela de Romaneio:
				PD1->(RecLock("PD1",.F.))
				PD1->PD1_QTDVOL := nVols
				PD1->PD1_PLIQ   := nPesoL
				PD1->PD1_PBRUTO := nPesoB
				//PD1->PD1_STATUS := cStatus
				PD1->(MsUnLock())

				// Chama Embarque
				u_STFSFA62(cRoma)

				// Verifico se deseja encerrar o Romaneio
				if VTYesNo("Deseja Imprimir romaneio e Danfe?",".:ATENCAO:.",.T.)
					//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
					U_EncerRom(cRoma)
				endif

			else
				if VTYesNo("Nao foi informado nenhuma nota. Deseja excluir o romaneio?",".:ATENCAO:.",.T.)
					PD1->(RecLock("PD1",.F.))
					PD1->(dbDelete())
					PD1->(MsUnLock())
				endif
			Endif
		Endif
	endif

	VtRestore(,,,,aTela1)

Return lRET

/*/{Protheus.doc} AddPD2
description
Rotina para adicionar notas a PD2
@type function
@version  
@author Valdemir Jose
@since 10/03/2021
@param cRoma, character, param_description
@return return_type, return_description
/*/
//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
//Static Function AddPD2(cRoma)
User Function AddPD2(cRoma)
	Local lRET     := .T.
	Local aAreaPD2 := GetArea()
	Local _cRegiao := u_StCepReg(SF2->F2_DOC,SF2->F2_SERIE,' ')

	PD2->(RecLock("PD2",.T.))
	PD2->PD2_FILIAL := xFilial("PD2")
	PD2->PD2_STATUS := "1"
	PD2->PD2_CODROM := cRoma
	PD2->PD2_NFS    := SF2->F2_DOC
	PD2->PD2_SERIES := SF2->F2_SERIE
	PD2->PD2_CLIENT := SF2->F2_CLIENTE
	PD2->PD2_LOJCLI := SF2->F2_LOJA
	PD2->PD2_REGIAO := _cRegiao
	PD2->PD2_QTDVOL := SF2->F2_VOLUME1
	PD2->PD2_PLIQ   := SF2->F2_PLIQUI
	PD2->PD2_PBRUTO := SF2->F2_PBRUTO
	PD2->(MsUnLock())

	SF2->(RecLock("SF2",.F.))
	SF2->F2_XCODROM := cRoma
	SF2->F2_XPLACA	:= PD1->PD1_PLACA
	SF2->(MsUnLock())

	RestArea( aAreaPD2 )

Return lRET

/*/{Protheus.doc} VLDNFS
description
Valida a existência da Nota Fiscal
@type function
@version  
@author Valdemir Jose
@since 03/03/2021
@param cNotaF, character, param_description
@param cSerie, character, param_description
@return return_type, return_description
/*/
Static Function VLDNFS(cNotaF,cSerie)
	Local lRET := .T.
	Local aSF2 := VtSave()

	dbSelectArea("SF2")
	dbSetOrder(1)
	lRET := dbSeek(xFilial("SF2")+cNotaF+cSerie)
	if !lRET
		VtAlert("Nota Fiscal nao encontrado",	"Atencao",.t.,4000)
	endif

	VtRestore(,,,,aSF2)

Return lRET

/*/{Protheus.doc} STENCROM
    description
    @type function
    @version  
    @author Valdemir Jose
    @since 09/03/2021
    @param cRoma, character, param_description
    @return return_type, return_description
/*/
//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
//Static Function STENCROM(cRoma, lJob)
User Function STENCROM(cRoma, lJob)
	//Local aCB6     := VtSave()
	Local aVetor   := {}
	Local nX       := 0
	Local cQry     := ""
	Local cPasta   := "\arquivos\relatorio_romaneio\"
	Local cArquivo := ""
	Local lPD1     := .F.
	Local nDir     := 0
	Local lDanfe   := .F.
	Local lRoma    := .F.
	Private nConsNeg 	:= 0.4 // Constante para concertar o cálculo retornado pelo GetTextWidth para fontes em negrito.
	Private nConsTex 	:= 0.5 // Constante para concertar o cálculo retornado pelo GetTextWidth.

	Private PixelX,PixelY
	Default lJob := .f.

	dbSelectArea("PD1")
	dbSetOrder(1)

	if !ExistDir(cPasta)
		nDir := MAKEDIR( cPasta )
	endif
	//nDir := MAKEDIR( cPasta+cRoma )
	if nDir != 0
		conout( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
	endif

	if !getConfer(cRoma)
		CONOUT("Existem iten(s) a ser(em) conferido(s), Romaneio não pode ser encerrado")
		IF !lJob
			FWAlertInfo( "Existem iten(s) a ser(em) conferido(s).", "Romaneio não pode ser encerrado" )
		endif
	else
		PD1->( dbSetOrder(1) )
		lPD1 := PD1->( dbSeek(xFilial("PD1") + cRoma) )
		Conout("Posicionou tabela: PD1, para romaneio: "+cRoma+" Resultado dbSeek: "+cValToChar(lPD1))

		For nX := 1 to 2
			Conout("Ira imprimir a "+cvaltochar(nX)+" via")
			lRoma:= u_STFSR60C(cRoma, cRoma, .T.)            // Imprime Romaneio
		Next

		Conout("Montando array para impressao da danfe")
		aAdd(aVetor, {.T., 1,.T.,1,PD1->PD1_CODROM,PD1->PD1_PLACA,PD1->PD1_DTEMIS,PD1->PD1_MOTORI,0,PD1->PD1_PBRUTO,PD1->PD1_QTDVOL} )
		//
		nX := 1
		if aVetor[nX][1]    // Imprime Nota
			//MAKEDIR( cPasta+aVetor[nX][5] )
			Conout("Ira imprimir a danfe ")
			lDanfe :=  U_ImpDanfe1(aVetor[nX], .T.) //StaticCall (STFSF60A, ImpDanfe, aVetor[nX], .T.)
			if pd1->( dbSeek(XFilial('PD1')+cRoma) ) .and. lDanfe .and. lRoma
				// Romaneio será encerrado após
				//RecLock("PD1",.F.)
				//PD1->PD1_STATUS := '3'
				//PD1->(MsUnLock())
			endif
		endif

	endif

	if Select("TVAL") > 0
		TVAL->( dbCloseArea() )
	endif

	// VtRestore(,,,,aCB6)
Return

// Teste de Impressão Valdemir
// u_TST001
User Function TST001(pcRoma)
	Default pcRoma := '0000108415'
/*    
    Default pcRoma := '0000000030'

     RPCSetType(3)
     RPCSetEnv("01", "02", "", "", "")
  
     STENCROM(pcRoma)    // REMOVER DEPOIS
*/
	//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
	U_EncerRom(pcRoma)
Return


/*/{Protheus.doc} JBIMPROM
@description
Rotina para realizar o encerramento por meio de JOB
@type function
@version  1.0
@author Valdemir Jose
@since 09/09/2021
/*/
//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
//Static Function JBIMPROM(pcRoma)
User Function JBIMPROM(pcRoma)
	Local cPasta := "\arquivos\relatorio_romaneio\"

	Conout("Iniciando   * * * * *  Rotina: JBIMPROM   * * * * * ")
	if U_TravaEV("JBIMPROM",cPasta,0)
		conout("ENCONTROU ARQUIVO: "+pcRoma)
		//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
		U_STENCROM(pcRoma, .F.)

		conout("EXCLUINDO ARQUIVO: "+pcRoma)
		FErase(cPasta+cRoma+".ROM")  //FR VOLTAR
		U_TravaEV("JBIMPROM",cPasta, 1)
	Endif

Return

/*/{Protheus.doc} EncerRom
description
Rotina que fará a geração do arquivo para impressão Romaneio/Notas
@type function
@version  
@author Valdemir Jose
@since 09/09/2021
@param pRom, variant, param_description
@return variant, return_description
/*/
//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
//Static Function EncerRom(pcRoma)
User Function EncerRom(pcRoma)
	Local cPasta := "\arquivos\relatorio_romaneio\"
	Local aTela  := iif(FWIsInCallStack("U_STTNTCOL"),VtSave(),{})
	Local cRoma  := Space(10)
	cRoma  := pcRoma

	if FWIsInCallStack("U_STTNTCOL")
		While .t.
			VTCLear()
			cRoma  := pcRoma
			@ 00,00 VtSay  "Romaneio a Imprimir"
			//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
			@ 01,00 VTGet cRoma Picture "@!" Valid U_getVld2(@cRoma)
			VTRead
			If (VtLastkey() == 27) .or. (!Empty(cRoma))
				Exit
			EndIf
		EndDo
	endif

	if !Empty(cRoma)
		//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
		if U_getVld2(@cRoma)
			if FWIsInCallStack("U_STTNTCOL")
				VtAlert("Impressao enviada ao gerenciador",	"Atencao!",.t.,2000)
			endif
			Memowrite(cPasta+cRoma+".ROM", cRoma)
		endif
	Endif

	if FWIsInCallStack("U_STTNTCOL")
		VtRestore(,,,,aTela)
	endif

Return

/*/{Protheus.doc} getVld2
description
Rotina que fará a validação do Encerramento
@type function
@version  
@author Valdemir Jose
@since 09/09/2021
@param pcRoma, variant, param_description
@return variant, return_description
/*/
//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
//Static Function getVld2(pcRoma)
User Function getVld2(pcRoma)
	Local lRET := .T.

	dbSelectArea("PD1")
	dbSetOrder(1)
	if !Empty(pcRoma)
		lRET := PD1->(dbSeek(xFilial("PD1")+pcRoma))
		if !lRET
			if FWIsInCallStack("U_STTNTCOL")
				VtAlert("Romaneio nao encontrado",	"Atencao!",.t.,4000)
			else
				Alert("Romaneio não encontrado")
			endif
			return lRET
		endif
		if !getConfer(pcRoma)
			lRET := .F.
			VtAlert("Existem iten(s) a ser(em) conferido(s)","Atencao!",.t.,4000)
		endif
	Endif

Return lRET


/*/{Protheus.doc} TravaEV
@description
Rotina que fará o controle de semafaro
@type function
@version  1.0
@author Valdemir Jose
@since 13/10/2021
@param pArquivo, variant, param_description
@param pcPasta, variant, param_description
@param nTrava, numeric, param_description
@return variant, return_description
/*/
//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
//Static Function TravaEV(pArquivo, pcPasta, nTrava)
User Function TravaEV(pArquivo, pcPasta, nTrava)
	Local lRET := .F.
	Local cArquivo := pArquivo

	if File(cArquivo) .and. (nTrava==0)
		Return lRet
	else
		lRET := .T.
	endif

	if (nTrava == 0)
		Memowrite(pcPasta+cArquivo,"x")
	else
		FErase(pcPasta+cArquivo)
	endif

Return lRET

/*/{Protheus.doc} STIMPROM
@description
Rotina a ser chamada via menu, que irá verificar a existencia de arquivos
a serem impresso
@type function
@version 1.0
@author Valdemir Jose
@since 13/10/2021
@return variant, return_description
u_STIMPROM
/*/
User Function STIMPROM()
	Local bCabec       := {"Romaneio","Emissao"}
	Local nList        := 0
	Local nMeter1      := 0
	Private aLista     := {{"",""}}
	Private cSTitulo   := Space(1)
	Private nSelecao   := 2
	Private lAbortPrint:=.F.
	Private oProcess   := nil

	cCSSPnl := "QProgressBar {border: 2px solid #C3C7C4; /*cor da borda*/"
	cCSSPnl += "border-radius: 5px /*arredondamento da borda*/}"
	/* caracteristicas da barra de progressao */
	cCSSPnl += "QProgressBar::chunk {"
	cCSSPnl += "background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,"
	cCSSPnl += "stop: 0 #00CF0A, stop: 1 #83F566); /*cor de fundo*/"
	cCSSPnl += "width: 10px; /*largura*/"
	cCSSPnl += "margin: 0.5px; /*Espacamento*/"
	cCSSPnl += "}"

	SetPrvt("oDlgF","oSTitulo","oLBox1","oBtnSair")

	oDlgF      := MSDialog():New( 092,232,344,678,"Gerencia Impressão Coletor",,,.F.,,,,,,.T.,,,.T. )
	oSTitulo   := TSay():New( 000,008,{||"                                                    Impressão via Coletor"},oDlgF,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,208,008)

	@ 08,08 LISTBOX oLBox1 FIELDS HEADER ;
		'Romaneio','Emissão' ;
		SIZE 208,064 OF oDlgF PIXEL

	oLBox1:SetArray(aLista)
	oLBox1:bLine := {|| {aLista[oLBox1:nAt][1], aLista[oLBox1:nAt][2]}}
	oLBox1:Refresh()

	oProcess   := TMeter():New( 076,008,{|u|if(Pcount()>0,nMeter1:=u,nMeter1)},100,oDlgF,208,008,,.T.)
	oBtnSair   := TButton():New( 088,150,"Sair",oDlgF, {|| oDlgF:End()},061,020,,,,.T.,,"",,,,.F. )
	oSelecao   := TRadMenu():New( 092,014,{"Ativa","Desativa"},{|u| If(PCount()>0,nSelecao:=u,nSelecao)},oDlgF,,{|| .T. },CLR_BLACK,CLR_WHITE,"",,,036,12,,.F.,.F.,.T. )
	oBtnSair:SetCSS(cCssLim)
	oProcess:SetCSS(cCSSPnl)

	//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
	oTimer := TTimer():New(1000, {|| U_TimeBlink() }, oDlgF )
	oTimer:Activate()
	oDlgF:Activate(,,,.T.)

Return

/*/{Protheus.doc} TimeBlink
@description
Verifica a existencia de arquivos
@type function
@since 13/10/2021
@version  1.0
@author Valdemir Jose
/*/
//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
//Static Function TimeBlink()
User Function TimeBlink()
	Local cPasta := "\arquivos\relatorio_romaneio\"
	Local aRoma  := Directory(cPasta+"*.ROM")
	Local nX     := 0


	dbSelectArea("PD1")
	dbSetOrder(1)

	aLista := {}
	For nX := 1 to Len(aRoma)
		cRoma := RetFileName(aRoma[nX][1])
		if dbSeek(xFilial("PD1")+cRoma)
			aAdd(aLista,{PD1->PD1_CODROM, DTOC(PD1->PD1_DTEMIS)})
		endif
	Next

	oProcess:Set(0)
	oProcess:SetTotal(1)
	if nSelecao == 1
		if nConta == 0
			nTProces := Len(aLista)
			oProcess:SetTotal(nTProces)
			oProcess:Set(0)
			For nX := 1 to nTProces
				nConta += 5
				oProcess:Set(nConta)
				cRoma := aLista[nX][1]
				PROCESSMESSAGES()
				//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
				U_JBIMPROM(cRoma)
				//oLBox1:Del(aLista,nX)
			next
			nConta := 0
		endif
	endif

	if Len(aLista) == 0
		aLista := {{"",""}}
	endif

	oLBox1:SetArray(aLista)
	oLBox1:bLine := {|| {aLista[oLBox1:nAt][1], aLista[oLBox1:nAt][2]}}
	oLBox1:Refresh()
Return

/*/{Protheus.doc} IMPROM01
description
Rotina que ficará a procura de arquivos que estão salvo na pasta especificada
@type function
@version  1.0
@author Valdemir Jose
@since 13/10/2021
@return variant, return_description
/*/
Static Function IMPROM01()
	Local cPasta := "\arquivos\relatorio_romaneio\"
	Local aRoma  := Directory(cPasta+"*.ROM")

	While (nSelecao == 1)
		aRoma  := Directory(cPasta+"*.ROM")
		PROCESSMESSAGES()
		if Len(aRoma) > 0
			ProcRegua(Len(aRoma))
			//FR - 29/08/2022 - SUBSTITUIR STATIC FUNCTION POR USER FUNCTION, NO R.33 NÃO FUNCIONA MAIS STATIC
			U_JBIMPROM()
		endif
	EndDo
	ProcessMessages()
Return


/*/{Protheus.doc} getConfer
description
Rotina que valida se foi realizado a conferência
@type function
@version  
@author Valdemir Jose
@since 27/10/2021
@param cRoma, character, param_description
@return variant, return_description
/*/
Static function getConfer(cRoma)
	Local cQry := ""
	Local lRET := .T.
/*  Removido por solicitação do Jefferson
	cQry += "SELECT SUM(1) TOTAL, SUM((CASE WHEN CB6_STATUS='5' THEN 1 ELSE 0 END)) CONFERIDO " + CRLF
	cQry += "FROM "+RETSQLNAME("PD1")+ " PD1       " + CRLF
	cQry += "LEFT JOIN "+RETSQLNAME("PD2") + " PD2 " + CRLF
	cQry += "ON PD1_FILIAL=PD2_FILIAL AND PD1_CODROM=PD2_CODROM " + CRLF
	cQry += "LEFT JOIN "+RETSQLNAME("CB7") + " CB7 " + CRLF
	cQry += "ON CB7_FILIAL=PD2_FILIAL AND CB7_NOTA=PD2_NFS AND CB7_SERIE=PD2_SERIES " + CRLF
	cQry += "LEFT JOIN "+RETSQLNAME("CB6") + " CB6 " + CRLF
	cQry += "ON CB6_FILIAL=CB7_FILIAL AND CB6_XORDSE=CB7_ORDSEP " + CRLF
	cQry += "WHERE PD1.D_E_L_E_T_=' ' AND PD2.D_E_L_E_T_=' ' AND CB7.D_E_L_E_T_=' ' AND CB6.D_E_L_E_T_=' ' " + CRLF
	cQry += " AND PD1_FILIAL='" +Xfilial('PD1')+ "' AND PD1_CODROM='" +cRoma+ "'     " + CRLF

	if Select("TVAL") > 0
		TVAL->( dbCloseArea() )
	endif

	tcQuery cQry New Alias "TVAL" 

	lRET := (TVAL->(TOTAL == CONFERIDO) )
*/
Return lRET
