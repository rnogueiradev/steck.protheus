#INCLUDE "PROTHEUS.CH" 
#INCLUDE "APVT100.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SchEmb30 ºAutor ³Jonathan Schmidt Alves º Data ³20/05/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Embalar Multiplo via coletor.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SchEmb30()
Local lRet := .F.
Local aRet := { .F. }
Local _w1

Local cOrdSep := Space(06)
Local cEtique := Space(40)
Local cStaSep := ""
Local cPedSep := ""
Local cCliLoj := ""
Local cCliNom := ""
Local aVolums := {}

Private cCodOpe := CbRetOpe() // "000010"
Private nMaxCol := VTMaxCol()

// Filiais tabelas
Private _cFilSB1 := xFilial("SB1")
Private _cFilCB1 := xFilial("CB1")
Private _cFilCB3 := xFilial("CB3")
Private _cFilCB6 := xFilial("CB6")
Private _cFilCB7 := xFilial("CB7")
Private _cFilCB8 := xFilial("CB8")
Private _cFilCB9 := xFilial("CB9")
Private _cFilSA1 := xFilial("SA1")
Private _cFilSC5 := xFilial("SC5")
Private _cFilPA0 := xFilial("PA0")
Private _cFilZB6 := xFilial("ZB6")
Private _cSqlSZV := RetSqlName("SZV")
Private _cSqlCB9 := RetSqlName("CB9")

// Abertura das tabelas
DbSelectArea("SB1") // Produtos
SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
DbSelectArea("CB1") // Operadores
CB1->(DbSetOrder(1)) // CB1_FILIAL + CB1_CODOPE
DbSelectArea("CB3") // Tipos de Embalagem
CB3->(DbSetOrder(1)) // CB3_FILIAL + CB3_CODEMB
DbSelectArea("CB6") // Volumes de Embalagem
CB6->(DbOrderNickName("STFSCB601")) // CB6_FILIAL + CB6_XORDSE + CB6_VOLUME
DbSelectArea("CB7") // Cabecalho Ordem Separacao
CB7->(DbSetOrder(1)) // CB7_FILIAL + CB7_ORDSEP
DbSelectArea("CB8") // Itens de ordem de separacao   
CB8->(DbSetOrder(4)) // CB8_FILIAL + CB8_ORDSEP + CB8_ITEM + CB8_PROD + CB8_LOCAL + CB8_LCALIZ + CB8_LOTECT + CB8_NUMLOT + CB8_NUMSER
DbSelectArea("CB9") // Produtos Separados
CB9->(DbSetOrder(8)) // CB9_FILIAL + CB9_ORDSEP + CB9_PROD + CB9_LOTECT + CB9_NUMLOT + CB9_NUMSER + CB9_VOLUME
DbSelectArea("SA1") // Clientes
SA1->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
DbSelectArea("SC5") // Pedido Venda
SC5->(DbSetOrder(1)) // C5_FILIAL + C5_NUM
DbSelectArea("PA0")
PA0->(DbSetOrder(2)) // PA0_FILIAL + PA0_TIPDOC + PA0_DOC + PA0_PROD + PA0_LOTEX
DbSelectArea("ZB6") // Volume/Peso padrao do produto
ZB6->(DbSetOrder(1)) // ZB6_FILIAL + ZB6_CODPRO

// #################################
// ####### ORDEM SEPARACAO #########
// #################################

While .T.

    If Empty(cCodOpe) // Operador nao cadastrado
        VTAlert("Operador nao cadastrado (CB1)!","[-]",.T.,1500)
        Exit
    EndIf

    cOrdSep := Space(06)
    cEtique := PadR("SSX111=LOTE=236",40) // Space(40)

    VTCLEARBUFFER()
    VTCLEAR
    @000,000 VTSAY "Ordem Separacao?"
    @001,000 VTGET cOrdSep PICTURE "@!" VALID VldOrd30(@cOrdSep) F3 "CB7FS1" // Validacao da Ordem Separacao
    VTREAD
    If VTLastKey() == 27
        If CBYesNo("Deseja sair do programa?",".:AVISO:.",.T.)
            Exit
        EndIf
    EndIf
    VTAlert("Carregando Ordem de Separacao... Aguarde...","[-]",.T.,1500)

    // #########################
    // #### DADOS SEPARACAO ####
    // #########################
    While .T.
        VTCLEARBUFFER()
        VTCLEAR
        If CB7->(!EOF())
            If SA1->(DbSeek(_cFilSA1 + CB7->CB7_CLIENT + CB7->CB7_LOJA))

                cStaSep := RetStatus(CB7->CB7_STATUS)
                cPedSep := CB7->CB7_PEDIDO
                cCliLoj := SA1->A1_COD + "/" + SA1->A1_LOJA
                cCliNom := RTrim(SA1->A1_NOME)

                @000,000 VTSAY PadR("Ord Sep: " + cOrdSep, nMaxCol)     // Ordem de Separacao
                @001,000 VTSAY PadR(cStaSep, nMaxCol)                   // Status Separacao
                @002,000 VTSAY PadR("Pedido: " + cPedSep, nMaxCol)      // Pedido de Venda
                @003,000 VTSAY PadR("Cli/Loja: " + cCliLoj, nMaxCol)    // Codigo Cliente/Loja
                @004,000 VTSAY PadR(cCliNom, nMaxCol)                   // Nome Cliente

                Sleep(1000)
                If CB7->CB7_STATUS $ "2/3/" // 2=Separacao Finalizada ou 3=Embalando
                    // Carregamento das separacoes existentes
                    aVolums := MontVols(CB7->CB7_ORDSEP)
                    lShowVols := .F.
                    If Len(aVolums) > 0 // Ja existem volumes
                        Sleep(2000)
                        lShowVols := CBYesNo("Existem volumes ja separados, deseja reembalar?",".:AVISO:.",.T.) // Sem volumes ja separados ou nao deseja reembalar volumes ja separados
                    EndIf
                    If lShowVols // .T.=Mostrar volumes ja embalados

                        // #########################
                        // #### ITENS EMBALADOS ####
                        // #########################
                        aCls01 := {}
                        aSze01 := {          04,               33,             09,          36,          15 }
                        aHdr01 := {       "Vol", "Tipo Embalagem",         "Peso",  "Operador", "Ult Ocorr" }
                        For _w1 := 1 To Len( aVolums ) // Rodo nos volumes
                            //           {          Volume,     Tipo Volume,            Peso,        Operador, Ultima Ocorrencia }
                            //           {              01,              02,              03,              04,                05 }
                            aAdd(aCls01, { aVolums[_w1,02], aVolums[_w1,03], aVolums[_w1,08], aVolums[_w1,10],   aVolums[_w1,12] })
                        Next
                        nPos01 := VTaBrowse(,,,,aHdr01, aCls01, aSze01, "u_ProcItem()", nPos01)
                        If nPos01 > 0 // Executa Selecao da linha
                            If CBYesNo("O volume sera excluido, confirma?",".:AVISO:.",.T.)
                                VTAlert("Excluindo volume da Ordem de Separacao... Aguarde...","[-]",.T.,1500)
                                DbSelectArea("PA0")
                                PA0->(DbSetOrder(2)) // PA0_FILIAL + PA0_TIPDOC + PA0_DOC + PA0_PROD + PA0_LOTEX
                                DbSelectArea("CB8") // Itens de ordem de separacao   
                                CB8->(DbSetOrder(4)) // CB8_FILIAL + CB8_ORDSEP + CB8_ITEM + CB8_PROD + CB8_LOCAL + CB8_LCALIZ + CB8_LOTECT + CB8_NUMLOT + CB8_NUMSER
                                DbSelectArea("CB6") // Volumes de Embalagem
                                CB6->(DbOrderNickName("STFSCB601")) // CB6_FILIAL + CB6_XORDSE + CB6_VOLUME
                                DbSelectArea("CB9") // Produtos Separados
                                CB9->(DbSetOrder(2)) // CB9_FILIAL + CB9_ORDSEP + CB9_VOLUME + ...
                                If CB6->(DbSeek(_cFilCB6 + CB7->CB7_ORDSEP + CB7->CB7_ORDSEP + aCls01[nPos01,01]))
                                    If CB9->(DbSeek(_cFilCB9 + CB7->CB7_ORDSEP + CB6->CB6_VOLUME ))
                                        While CB9->(!EOF()) .And. CB9->CB9_FILIAL + CB9->CB9_ORDSEP + CB9->CB9_VOLUME == _cFilCB9 + CB7->CB7_ORDSEP + CB6->CB6_VOLUME
                                            // Limpa CB8: Itens da Ordem de Separacao + Item + Produto
                                            If CB8->(DbSeek(_cFilCB8 + CB7->CB7_ORDSEP + CB9->CB9_ITEM))
                                                While CB8->(!EOF()) .And. CB8->CB8_FILIAL + CB8->CB8_ORDSEP + CB8->CB8_ITEM == _cFilCB8 + CB7->CB7_ORDSEP + CB9->CB9_ITEM
                                                    RecLock("CB8",.F.)
                                                    CB8->CB8_SALDOE := CB8->CB8_QTDORI      // Reseto o saldo original
                                                    CB8->(MsUnlock())
                                                    CB8->(DbSkip())
                                                End
                                            EndIf
                                            // Limpa PA0: Ordem de Separacao + Doc + Produto: PA0_TIPDOC + PA0_ORDSEP + PA0_DOC + PA0_PROD
                                            If PA0->(DbSeek(_cFilPA0 + "CB9" + CB7->CB7_ORDSEP + CB6->CB6_VOLUME))
                                                While PA0->(!EOF()) .And. PA0->PA0_FILIAL + PA0->PA0_TIPDOC + PA0->PA0_ORDSEP == _cFilPA0 + "CB9" + CB7->CB7_ORDSEP + CB6->CB6_VOLUME
                                                    RecLock("PA0",.F.)
                                                    PA0->PA0_QTDE := 0              // Zera Quantidade Referencia
                                                    PA0->(MsUnlock())
                                                    PA0->(DbSkip())
                                                End
                                            EndIf
                                            // Reseta CB9: CB9_CB9_VOLUME: Limpa o volume todo da CB9 (pode ser 1 ou mais)
                                            RecLock("CB9",.F.)
                                            CB9->CB9_VOLUME := Space(10)            // Codigo Volume
                                            CB9->CB9_CODEMB := Space(06)            // Cod Embalagem
                                            CB9->CB9_STATUS := "1"                  // Status 1=Em Aberto   
                                            CB9->CB9_LCALIZ := Space(15)            // Endereco
                                            CB9->CB9_LOTECT := Space(10)            // Lote
                                            CB9->CB9_NUMLOT := Space(06)            // SubLote
                                            CB9->CB9_XULTVO := Space(01)            // Ultimo Volume
                                            CB9->CB9_QTEEMB := 0                    // Quantidade Embalada
                                            CB9->(MsUnlock())
                                            CB9->(DbSkip())
                                        End
                                    EndIf
                                    // Limpa o CB6: Volumes
                                    RecLock("CB6",.F.)
                                    CB6->(DbDelete())
                                    CB6->(MsUnlock())
                                    VTAlert("Excluindo volume da Ordem de Separacao... Sucesso!","[-]",.T.,500)
                                    VTCLEARBUFFER()
                                    VTCLEAR
                                    @000,000 VTSAY PadR("Ord Sep: " + cOrdSep, nMaxCol)     // Ordem de Separacao
                                    @001,000 VTSAY PadR(cStaSep, nMaxCol)                   // Status Separacao
                                    @002,000 VTSAY PadR("Pedido: " + cPedSep, nMaxCol)      // Pedido de Venda
                                    @003,000 VTSAY PadR("Cli/Loja: " + cCliLoj, nMaxCol)    // Codigo Cliente/Loja
                                    @004,000 VTSAY PadR(cCliNom, nMaxCol)                   // Nome Cliente
                                EndIf
                            Else // Cancelada exclusao
                                Exit
                            EndIf
                        ElseIf nPos01 == 0 // 0=Aborta Selecao
                            nPos01 := 1
                            Exit
                        EndIf
                    EndIf

                    // #########################
                    // ####### ETIQUETA ########
                    // #########################
                    // Agora vai para a Etiqueta (Cod Barras do Coletor)
                    @005,000 VTSAY "Etiqueta?"
                    @006,000 VTGET cEtique PICTURE "@!" VALID (aRet := VldEti30(cOrdSep,@cEtique))[01] // Validacao da Etiqueta
                    VTREAD
                    If VTLastKey() == 27
                        If CBYesNo("Voltar para Ordem Separacao?",".:AVISO:.",.T.)
                            Exit
                        EndIf
                    EndIf

                    If aRet[01] // .T.=Confirmada etiqueta

                        // Processamento da embalagem
                        VTAlert("Processando embalagem... Aguarde...","[-]",.T.,1000)
                        lRet := ProcEmba(aRet) // .T.=Fim do processo .F.=Ainda existem produtos para embalar

                        // Recarrego os volumes para totalizar qtde e peso
                        aVolums := MontVols( CB7->CB7_ORDSEP )
                        nPesPed := 0
                        aEVal(aVolums, {|x|, nPesPed += Val(x[08]) }) // Somatorio dos pesos

                        If !lRet // .T.=Fim da embalagem .F.=Ainda nao eh o fim
                            CB7->(DbSetOrder(1)) // CB7_FILIAL + CB7_ORDSEP
                            If CB7->(DbSeek(_cFilCB7 + cOrdSep))
                                CB6->(DbOrderNickName("STFSCB601")) // CB6_FILIAL + CB6_XORDSE + CB6_VOLUME
                                Reclock('CB7',.F.)
                                If CB6->(!DbSeek(_cFilCB6 + cOrdSep))
                                    CB7->CB7_STATUS := "2" // 0=Inicio 1=Separando 2=Sep.Final 3=Embalando 4=Emb.Final 5=Gera Nota 6=Imp.nota 7=Imp.Vol 8=Embarcado 9=Embarque Finalizado
                                Else
                                    CB7->CB7_STATUS := "3" // 0=Inicio 1=Separando 2=Sep.Final 3=Embalando 4=Emb.Final 5=Gera Nota 6=Imp.nota 7=Imp.Vol 8=Embarcado 9=Embarque Finalizado
                                EndIf
                                CB7->(MsUnLock())
                            EndIf
                        EndIf

                        If CB7->CB7_STATUS >= "4" // 0=Inicio 1=Separando 2=Sep.Final 3=Embalando 4=Emb.Final 5=Gera Nota 6=Imp.nota 7=Imp.Vol 8=Embarcado 9=Embarque Finalizado
                            SC5->(DbSetOrder(1)) // C5_FILIAL + C5_NUM
                            If !Empty(CB7->CB7_PEDIDO) .And. SC5->(DbSeek(_cFilSC5 + CB7->CB7_PEDIDO))
                                RecLock("SC5",.F.)
                                SC5->C5_PBRUTO	:= nPesPed
                                SC5->C5_VOLUME1	:= Len(aVolums)
                                SC5->C5_ESPECI1	:= "CX"
                                SC5->(MsUnLock())
                            EndIf
                        EndIf

                        VTAlert("Processando embalagem... Sucesso!...","[-]",.T.,1000)
                        Sleep(0500)

                        // Chamada para impressao
                        VTAlert("Verificando impressao etiqueta...","[-]",.T.,1000)
                        EtiVol(CB7->CB7_ORDSEP, Right(CB6->CB6_VOLUME,4)) // Right(cVolume,4)

                        If lRet // .T.=Fim do processo de embalagem .F.=Nao eh o fim ainda
                            Exit // Sai do loop e vai pra Ordem Separacao
                        EndIf

                    Else // Cancelado
                        Exit
                    EndIf

                Else // Status de separacao invalido
                    Sleep(2000)

                    If CB7->CB7_STATUS > "4" // 0=Inicio 1=Separando 2=Sep.Final 3=Embalando 4=Emb.Final 5=Gera Nota 6=Imp.nota 7=Imp.Vol 8=Embarcado 9=Embarque Finalizado
                        VTAlert("Ordem de Separação com status de " + RetStatus(CB7->CB7_STATUS) + " e não pode haver manutenção","[-]",.T.,1500)
                    EndIf

                    Exit
                EndIf

            EndIf
        EndIf
    End
End
Return

Static Function EtiVol(cOrdSep, cSeq) // , oDescImp)
Local cVolume	:= cOrdSep + cSeq
Local cLocImp	:= CB1->CB1_XLOCIM
Local cLocOri   := ""
While Empty(cLocImp)
	//If !CfgLocImp(oDescImp)
	//	Return
	//EndIf
	cLocImp := CB1->CB1_XLOCIM
End
cLocOri := cLocImp

CB6->(DbSetOrder(1))
CB6->(DbSeek(xFilial('CB6') + cVolume))
If Empty(CB6->CB6_XPESO)
	VTAlert("Volume em aberto, não poderá ser impresso!!!","[-]",.T.,1500) // MsgAlert("Volume em aberto, não poderá ser impresso!!!","Atenção")
	Return
EndIf

If Empty(CB6->CB6_XOPERA)
	VTAlert("Volume em aberto, não poderá ser impresso!!!","[-]",.T.,1500) // MsgAlert("Operador não cadastrado, não poderá ser impresso!!!","Atenção")
	Return
EndIf

If __cUserID $ GetMv("ST_CDUSRS",,'000415/000421/000439/000441')
    Return
EndIf

/*
If ! MsgYesNo("Confirma a impressão de etiqueta do volume: "+cSeq,"Atenção")
Return
EndIf
*/

DbSelectArea("SC5")
SC5->(DbSetOrder(1))
SC5->(DbSeek(CB6->CB6_FILIAL + CB6->CB6_PEDIDO))
If SC5->(!EOF()) .And. AllTrim(SC5->C5_TRANSP) == "000163" .And. GetMv("ST_NEWTNT",,.T.) .And. SC5->C5_FILIAL=="02"
	cLocImp := "000013" // Enviar para impressora TNT
EndIf
If !CB5SetImp(cLocImp)
	MsgAlert("Local de impressão " + cLocImp + " não cadastrado!!!","Atenção")
	Return
EndIf
If ExistBlock("IMG05") // Impressao
	ExecBlock("IMG05",,,{ cVolume, CB7->CB7_PEDIDO, CB7->CB7_NOTA, CB7->CB7_SERIE, cLocOri, cLocImp })
EndIf
MSCBClosePrinter()
Return





/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ProcEmba ºAutor ³Jonathan Schmidt Alves º Data ³20/05/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento da embalagem.                                º±±
±±º          ³                                                            º±±
±±º          ³ Como esse processamento sera sempre de embalagem multipla  º±±
±±º          ³ onde a embalagem tera apenas um unico codigo de produto e  º±±
±±º          ³ suas quantidades, o codigo do produto sera unico, assim    º±±
±±º          ³ como lote, serie etc.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³                                                            º±±
±±º          ³ aRet:                                                      º±±
±±º          ³ { lRet, CB7->CB7_ORDSEP, CB3->CB3_CODEMB,                  º±±
±±º          ³ ZB6->ZB6_QTDVOL, nPeso, SB1->B1_COD, nQE,                  º±±
±±º          ³ cLote, cNumSer, cLoteX }                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ProcEmba(aRet) // Processamento Embalagem
Local lRet := .F.

Local nSaldoEmb := aRet[04] // nQE
Local nPeso     := aRet[05]
Local cProduto  := aRet[06]
Local cLote     := aRet[08]
Local cSLote    := Space(06)
Local cNumSer   := aRet[09]
Local cLoteX    := aRet[10]
Local cVolume   := Soma1(STUltimo( aRet[02] ))

// Na inclusao do volume
RecLock("CB6",.T.)
CB6->CB6_FILIAL := _cFilCB6             // Filial
CB6->CB6_VOLUME := cVolume              // Numero do volume
CB6->CB6_XORDSE := CB7->CB7_ORDSEP      // Ordem de Separacao
CB6->CB6_XOPERA := cCodOpe              // Codigo do Operador
CB6->CB6_PEDIDO := CB7->CB7_PEDIDO      // Numero do Pedido de Venda
CB6->CB6_XPESO  := nPeso                // Peso volume
CB6->CB6_TIPVOL := CB3->CB3_CODEMB      // Tipo de Volume (CB3)
CB6->CB6_XDTINI := dDataBase            // Data
//CB6->CB6_XHINI  := Left(Time(),5)     // Hora
CB6->CB6_XHINI  := Time()                 // Hora
CB6->CB6_XDTFIN := dDataBase            // Ultima ocorrencia
//CB6->CB6_XHFIN  := Left(Time(),5)       // Hora ultima ocorrencia
CB6->CB6_XHFIN  := Time()       // Hora ultima ocorrencia
CB6->(MsUnLock())

If .T. // Nao Estorno

	// Atualiza quantidade embalagem
	CB9->(DbSetOrder(8)) // CB9_FILIAL + CB9_ORDSEP + CB9_PROD + CB9_LOTECT + CB9_NUMLOT + CB9_NUMSER + CB9_VOLUME + ...
    While nSaldoEmb > 0 .And. CB9->(DbSeek(_cFilCB9 + CB7->CB7_ORDSEP + SB1->B1_COD + cLote + cSLote + cNumSer + Space(10)))

		If nSaldoEmb > CB9->CB9_QTESEP

			Begin Transaction
			CB9->(RecLock("CB9"))
			CB9->CB9_VOLUME := cVolume
			CB9->CB9_QTEEMB := CB9->CB9_QTESEP
			CB9->CB9_CODEMB := cCodOpe
			CB9->CB9_STATUS := "2" // Status 1=Em Aberto 2=Embalado
			CB9->(MsUnlock())

			// Atualiza Itens Ordem da Separacao
			CB8->(DbSetOrder(4)) // CB8_FILIAL + CB8_ORDSEP + CB8_ITEM + CB8_PROD + CB8_LOCAL + CB8_LCALIZ + CB8_LOTECT + CB8_NUMLOT + CB8_NUMSER
			If CB8->(DbSeek(_cFilCB8 + CB9->CB9_ORDSEP + CB9->CB9_ITESEP + CB9->CB9_PROD + CB9->CB9_LOCAL + CB9->CB9_LCALIZ + CB9->CB9_LOTSUG + CB9->CB9_SLOTSU + CB9->CB9_NUMSER))
                RecLock("CB8",.F.)
                CB8->CB8_SALDOE -= CB9->CB9_QTESEP
                If CB8->CB8_SALDOE < 0
                    CB8->CB8_SALDOE	:= 0
                EndIf
                CB8->(MsUnlock())
            EndIf
			End Transaction

			nSaldoEmb -= CB9->CB9_QTESEP

		Else // Total (sempre deve ser o total)
			nRecnoCB9:= CB9->(Recno())
			CB9->(DbSetOrder(8))
			If CB9->(DbSeek(CB9_FILIAL + CB9_ORDSEP + CB9_PROD + cLoteX + CB9_NUMLOT + CB9_NUMSER + cVolume + CB9_ITESEP + CB9_LOCAL + CB9_LCALIZ))

				Begin Transaction
				RecLock("CB9",.F.)
				CB9->CB9_QTEEMB += nSaldoEmb
				CB9->CB9_QTESEP += nSaldoEmb
				CB9->(MsUnlock())
				
				// Atualiza Itens Ordem da Separacao
				CB8->(DbSetOrder(4)) // CB8_FILIAL + CB8_ORDSEP + CB8_ITEM + CB8_PROD + CB8_LOCAL + CB8_LCALIZ + CB8_LOTECT + CB8_NUMLOT + CB8_NUMSER
			    If CB8->(DbSeek(_cFilCB8 + CB9->CB9_ORDSEP + CB9->CB9_ITESEP + CB9->CB9_PROD + CB9->CB9_LOCAL + CB9->CB9_LCALIZ + CB9->CB9_LOTSUG + CB9->CB9_SLOTSU + CB9->CB9_NUMSER))
                    RecLock("CB8")
                    CB8->CB8_SALDOE -= nSaldoEmb
                    If CB8->CB8_SALDOE < 0
                        CB8->CB8_SALDOE	:= 0
                    EndIf
                    CB8->(MsUnlock())
                EndIf
				
				CB9->(DbGoto(nRecnoCB9))
				RecLock("CB9",.F.)
				CB9->CB9_QTESEP -= nSaldoEmb
				If Empty(CB9->CB9_QTESEP)
					CB9->(DBDelete())
				EndIf
				CB9->(MsUnlock())
				End Transaction

				nSaldoEmb := 0

			Else
				CB9->(DbGoto(nRecnoCB9))
				nRecno := CB9->(CBCopyRec())
				
                Begin Transaction
				RecLock("CB9",.F.)
				CB9->CB9_VOLUME := cVolume
				CB9->CB9_QTEEMB := nSaldoEmb
				CB9->CB9_QTESEP := nSaldoEmb
				CB9->CB9_CODEMB := cCodOpe
				CB9->CB9_STATUS := "2" // Status 1=Em Aberto 2=Embalado
				CB9->CB9_LOTECT	:= cLoteX
				CB9->(MsUnlock())

				// Atualiza Itens Ordem da Separacao
				CB8->(DbSetOrder(4)) // CB8_FILIAL + CB8_ORDSEP + CB8_ITEM + CB8_PROD + CB8_LOCAL + CB8_LCALIZ + CB8_LOTECT + CB8_NUMLOT + CB8_NUMSER
                If CB8->(DbSeek(_cFilCB8 + CB9->CB9_ORDSEP + CB9->CB9_ITESEP + CB9->CB9_PROD + CB9->CB9_LOCAL + CB9->CB9_LCALIZ + CB9->CB9_LOTSUG + CB9->CB9_SLOTSU + CB9->CB9_NUMSER))
                    RecLock("CB8",.F.)
                    CB8->CB8_SALDOE -= nSaldoEmb
                    If CB8->CB8_SALDOE < 0
                        CB8->CB8_SALDOE	:= 0
                    EndIf
                    CB8->(MsUnlock())
                EndIf
				
				CB9->(DbGoto(nRecno))
				RecLock("CB9",.F.)
				CB9->CB9_QTESEP -= nSaldoEmb
				If Empty(CB9->CB9_QTESEP)
					CB9->(DbDelete())
				EndIf
				CB9->(MsUnlock())
				End Transaction

				nSaldoEmb := 0
			EndIf
		EndIf
	End
	
	_cUpd := "UPDATE " + _cSqlCB9 + " B9 "
	_cUpd += "SET CB9_XULTVO = ' ' WHERE "
	_cUpd += "CB9_FILIAL = '" + CB9->CB9_FILIAL + "' AND "		// Filial conforme
	_cUpd += "CB9_ORDSEP = '" + CB9->CB9_ORDSEP + "' AND "		// Ordem Separacao conforme
	_cUpd += "B9.D_E_L_E_T_ = ' '"								// Nao apagado
	nRet := TcSqlExec(_cUpd)
	
	_cUpd := "UPDATE " + _cSqlCB9 + " B9 "
	_cUpd += "SET CB9_XULTVO = 'S' WHERE "
	_cUpd += "CB9_FILIAL = '" + CB9->CB9_FILIAL + "' AND "		// Filial conforme
	_cUpd += "CB9_ORDSEP = '" + CB9->CB9_ORDSEP + "' AND "		// Ordem Separacao conforme
	_cUpd += "CB9_PROD = '" + cProduto + "' AND "				// Produto conforme
	_cUpd += "CB9_VOLUME = '" + cVolume + "' AND "				// Volume conforme
	_cUpd += "CB9_LOTECT = '" + cLoteX + "' AND "				// Lote conforme
	_cUpd += "B9.D_E_L_E_T_ = ' '"
	nRet := TcSqlExec(_cUpd)


    // Manutencao no PA0
    PA0->(DbSetOrder(2)) // PA0_FILIAL + PA0_TIPDOC + PA0_DOC + PA0_PROD + PA0_LOTEX
    If PA0->(!DbSeek(_cFilPA0 + "CB9" + PadR(cVolume,20) + cProduto + cLoteX))
        RecLock("PA0",.T.)
        PA0->PA0_FILIAL 	:= _cFilPA0
        PA0->PA0_DOC		:= cVolume
        PA0->PA0_ORDSEP		:= PadR(cVolume,6)
        PA0->PA0_TIPDOC     := "CB9"
        PA0->PA0_PROD   	:= cProduto
        PA0->PA0_LOTEX  	:= cLoteX
    Else
        RecLock("PA0",.F.)
    EndIf
    If .F. // !lEstorna
        PA0->PA0_QTDE += nSaldoEmb // nQE
    Else
        PA0->PA0_QTDE -= nSaldoEmb // nQE
        If PA0->PA0_QTDE < 0
            PA0->PA0_QTDE := 0
        EndIf
    EndIf
    PA0->PA0_USU		:= __cUserID
    PA0->PA0_DTSEP  	:= dDataBase
    PA0->PA0_HRSEP  	:= Time()
    If PA0->PA0_QTDE <= 0
        PA0->(DbDelete())
    EndIf
    PA0->(MsUnLock())

    lRet := FimProcEmb()

EndIf

Return lRet // .T.=Fim do processo de embalagem .F.=Ainda nao eh o fim


Static Function FimProcEmb()
Local cOrdSep	:= CB7->CB7_ORDSEP
Local lFimEmb	:= .T.
Local lTemSep	:= .F.
CB8->(DBSeek(_cFilCB8 + cOrdSep))
While CB8->(!Eof() .AND. CB8_FILIAL+CB8_ORDSEP== _cFilCB8 + cOrdSep)
	If !Empty(CB8->CB8_SALDOS)
		lTemSep := .T.
		lFimEmb := .F.
		Exit
	EndIf
	If !Empty(CB8->CB8_SALDOE)
		lFimEmb := .F.
		Exit
	EndIf
	CB8->(DbSkip())
End
Reclock('CB7',.F.)
If lFimEmb
	If CB7->CB7_STATUS < "4" // 0=Inicio 1=Separando 2=Sep.Final 3=Embalando 4=Emb.Final 5=Gera Nota 6=Imp.nota 7=Imp.Vol 8=Embarcado 9=Embarque Finalizado
		If ("02" $ CBUltExp(CB7->CB7_TIPEXP)) // 2=Sep. Final 3=Embalando 4=Embalagem Finalizada 9=Embalagem Finalizada
			CB7->CB7_STATUS := "9" // 0=Inicio 1=Separando 2=Sep.Final 3=Embalando 4=Emb.Final 5=Gera Nota 6=Imp.nota 7=Imp.Vol 8=Embarcado 9=Embarque Finalizado
		Else
			CB7->CB7_STATUS := "4" // 0=Inicio 1=Separando 2=Sep.Final 3=Embalando 4=Emb.Final 5=Gera Nota 6=Imp.nota 7=Imp.Vol 8=Embarcado 9=Embarque Finalizado
		EndIf
		CB7->CB7_XDFEM := Date()
		CB7->CB7_XHFEM := Time()
	EndIf
Else
	If lTemSep
		CB7->CB7_STATUS := "1" // 0=Inicio 1=Separando 2=Sep.Final 3=Embalando 4=Emb.Final 5=Gera Nota 6=Imp.nota 7=Imp.Vol 8=Embarcado 9=Embarque Finalizado
	Else
		CB7->CB7_STATUS := "2" // 0=Inicio 1=Separando 2=Sep.Final 3=Embalando 4=Emb.Final 5=Gera Nota 6=Imp.nota 7=Imp.Vol 8=Embarcado 9=Embarque Finalizado
	EndIf
EndIf
CB7->(MsUnLock())
Return lFimEmb



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ VldEti30 ºAutor ³Jonathan Schmidt Alves º Data ³20/05/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao da etiqueta.                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VldEti30(cOrdSep,cEtique) // Validacao da Etiqueta

Local lRet := .T.
Local aRet
Local _w1
Local _w2

Local cProduto
Local cLote    := Space(10)
Local cSLote   := Space(06)
Local cNumSer  := Space(20)

Local nQE      := 0
Local nSaldoEmb
Local nRecno, nRecnoCB9
Local nQtdSep := 0 // CB9_STATUS 1=Em Aberto 2=Embalado

Local lZB6 := .T. // .T.=Ativado embalar multiplo ZB6

cEtiqueta := U_STAVALET(cEtique) // Rotina para avaliar etiqueta e ajustar para padrão de leitura do CBRETIEAN - Renato Nogueira - 01/12/2014

aRet := VldPro30(cEtiqueta) // aRet2 := CBRetEtiEan(cEtiqueta)
If Empty(aRet)
    VTAlert("Etiqueta invalida!","[-]",.T.,2500)
    VTClearGet("cEtique")
	lRet := .F.

Else // Etiqueta valida

    cProduto:= aRet[01]
    nQE  	:= aRet[02]
    cLote  	:= aRet[03]
    cNumSer := aRet[05]
    cLoteX 	:= U_RetLoteX()

    If Empty(nQE)
        VTAlert("Quantidade invalida","[-]",.T.,2500)
        VTClearGet("cEtique")
        lRet := .F.
    Else

        CB9->(DbSetOrder(8)) // CB9_FILIAL + CB9_ORDSEP + CB9_PROD + CB9_LOTECT + CB9_NUMLOT + CB9_NUMSER + CB9_VOLUME
        If CB9->(DbSeek(_cFilCB9 + cOrdSep + cProduto + cLote + cSLote + cNumSer + Space(10)))
            While CB9->(!EOF()) .And. CB9->CB9_FILIAL + CB9->CB9_ORDSEP + CB9->CB9_PROD + CB9->CB9_LOTECT + CB9->CB9_NUMLOT + Space(10) == _cFilCB9 + cOrdSep + cProduto + cLote + cSLote + Space(10)
                nQtdSep += CB9->CB9_QTESEP
                CB9->(DbSkip())
            End

            If nQE > nQtdSep // Quantidade maior que a disponivel
                VTAlert("Quantidade informada maior que disponivel para embalar","[-]",.T.,2500)
                VTClearGet("cEtique")
                lRet := .F.
            EndIf

        Else
            VTAlert("Etiqueta Invalida","[-]",.T.,2500)
            VTClearGet("cEtique")
            lRet := .F.
        EndIf


        If lRet // Ainda valido
            If GetMv("ST_30GIO",,.T.) // GIOVANI.ZAGO SE DER PROBLEMA NA EMBALAGEM BASTA CRIAR O PARAMETRO COM .F.  06/08/2019
                If cEmpAnt == "01" .And. cFilAnt == "02"
                    DbSelectArea("SC5")
                    SC5->(DbSetOrder(1)) // C5_FILIAL + C5_NUM
                    If SC5->(DbSeek(xFilial("SC5") + CB7->CB7_PEDIDO))
                        DbSelectArea("Z44")
                        Z44->(DbSetOrder(1))
                        If Z44->(DbSeek(xFilial("Z44") + SC5->C5_CLIENTE + SC5->C5_LOJACLI))
                            If Z44->Z44_MAXITE > 0
                                _cCodPrx := AllTrim(cProduto)
                                _nCodPrx := 0
                                
                                For _w1 := 1 To Len(aLbx)
                                    If !(Empty(Alltrim(aLbx[_w1,02])))
                                        
                                        _lAchou := .F.
                                        For _w2 := 1 To Len(_aProdsDif)
                                            If AllTrim(_aProdsDif[_w2]) == AllTrim(aLbx[_w1,2])
                                                _lAchou := .T.
                                                Exit
                                            EndIf
                                        Next
                                        
                                        If !_lAchou // Nao achou
                                            aAdd(_aProdsDif, aLbx[_w1,2])
                                        EndIf
                                    EndIf
                                Next
                                
                                _lProdIgual := .F.
                                For _w2 := 1 To Len(_aProdsDif)
                                    If AllTrim(_aProdsDif[_w2]) == AllTrim(_cCodPrx)
                                        _lProdIgual := .T.
                                    EndIf
                                Next
                                
                                _nCodPrx := Len(_aProdsDif)
                                If _nCodPrx >= Z44->Z44_MAXITE .And. !_lProdIgual
                                    VTAlert("Quantidade de itens por volume: " + cValToChar(Z44->Z44_MAXITE) + " item","[-]",.T.,2500)
                                    lRet := .F.
                                EndIf
                            EndIf
                        EndIf
                    EndIf
                EndIf
            EndIf

            If lRet // .T.=Ainda valido
                If .T. // !lEstorna

                    lChkZB6 := .F.
                    If lZB6 // .T.=Trata Pesos/Volumes pelo ZB6 (Quantidade padrao/Volume/Peso Padrao)
                        DbSelectArea("SB1")
                        SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
                        If SB1->(DbSeek(_cFilSB1 + cProduto))

                            DbSelectArea("ZB6") // Volume/Peso padrao do produto
                            ZB6->(DbSetOrder(1)) // ZB6_FILIAL + ZB6_CODPRO
                            If ZB6->(DbSeek(_cFilZB6 + SB1->B1_COD))
                                While ZB6->(!EOF()) .And. ZB6->ZB6_FILIAL + ZB6->ZB6_CODPRO == xFilial("ZB6") + SB1->B1_COD
                                    If ZB6->ZB6_QTDVOL == nQE // Quantidade conforme
                                        
                                        // Atualiza o Tipo da Embalagem conforme o relacionamento
                                        cCodEmb := ZB6->ZB6_TIPVOL // Altero o Tipo da Embalagem

                                        CB3->(DbSetOrder(1)) // CB3_FILIAL + CB3_CODEMB 
                                        If CB3->(DbSeek(_cFilCB3 + cCodEmb))

                                            // Armazenar o peso para em seguida alimentar CB6_XPESO
                                            nPeso := ZB6->ZB6_PESOVL

                                            // Atualiza objeto como carregado via ZB6
                                            lChkZB6 := .T.
                                            Exit

                                        EndIf
                                    EndIf
                                    ZB6->(DbSkip())
                                End
                            EndIf
                        EndIf
                    EndIf

                    If !lChkZB6 // .F.=Embalar Multiplo nao identificado
                        VTAlert("Produto/Qtde nao encontrado em Emb Multipla (ZB6)!","[-]",.T.,2500)
                        VTClearGet("cEtique")
                        lRet := .F.
                    Else
                        //     {   01,              02,              03,              04,    05,          06,  07,    08,      09,     10 }
                        Return { lRet, CB7->CB7_ORDSEP, CB3->CB3_CODEMB, ZB6->ZB6_QTDVOL, nPeso, SB1->B1_COD, nQE, cLote, cNumSer, cLoteX }
                    EndIf
    
                EndIf
            EndIf
        EndIf
    EndIf
EndIf

Return { lRet }


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ VldPro30 ºAutor ³Jonathan Schmidt Alves º Data ³03/05/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao do produto (SB1).                                º±±
±±º          ³                                                            º±±
±±º          ³ Caractere especial separador:                              º±±
±±º          ³ = separador China                                          º±±
±±º          ³ : separador Nacional                                       º±±
±±º          ³ ¦ separador Alienigena                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±º          ³ Exemplo: SDD61C20=51432=12                                 º±±
±±º          ³                                                            º±±
±±º          ³ SDD61C20 é o código                                        º±±
±±º          ³ 51432 é o lote                                             º±±
±±º          ³ 12 é a quantidade                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VldPro30( cCodEti )
Local lRet := .T.
Local aRet := {}
Local _w1
Local _w2 := 0
Local cCodPro := ""
Local cLote := ""
Local nQtde := 0
For _w1 := 1 To Len( cCodEti )
    If !IsAlpha(SubStr(cCodEti,_w1,1)) .And. !(SubStr(cCodEti,_w1,1) $ "0123456789") // Caractere nao eh Alpha nem Numero
        If Empty(cCodPro) // Ainda nao carregou produto
            cCodPro := PadR(Left( cCodEti, _w1 - 1 ),15)
            _w2 := _w1 + 1
        ElseIf Empty(cLote) // Ainda nao carregou lote
            cLote := PadR( SubStr( cCodEti, _w2, _w1 - _w2 ), 10)
            _w2 := _w1 + 1
        EndIf
    EndIf
    If _w1 == Len( cCodEti ) // Quantidade
        nQtde := Val( SubStr( cCodEti, _w2, _w1 - _w2 ))
    EndIf
Next

cLote := Space(10)

DbSelectArea("SB1")
SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
If SB1->(!DbSeek(_cFilSB1 + cCodPro))
    SB1->(DbSetOrder(5)) // B1_FILIAL + B1_CODBAR
	If SB1->(!DbSeek(_cFilSB1 + cCodPro))
        VTAlert("Produto nao encontrado no cadastro! " + cCodPro,"[-]",.T.,2500)
        VTClearGet("cCodPro")
        lRet := .F.
	EndIf
EndIf
SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
If lRet // .T.=Produto localizado
    //      {          01,    02,    03,       04,        05 }
    //      {     Produto,  Qtde,  Lote, Vld Lote, Num Serie }
    aRet := { SB1->B1_COD, nQtde, cLote, CtoD(""), Space(20) }
EndIf
Return aRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ VldOrd30 ºAutor ³Jonathan Schmidt Alves º Data ³20/05/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao da Ordem Separacao.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VldOrd30(cOrdSep)
Local lRet := .T.
CB7->(DbSetOrder(1)) // CB7_FILIAL + CB7_ORDSEP
If CB7->(!DbSeek(_cFilCB7 + cOrdSep))
    VTAlert("Ordem de Separacao nao encontrada: " + cOrdSep,"[-]",.T.,2500)
    VTClearGet("cOrdSep")
    lRet := .F.
ElseIf !("01*" $ CB7->CB7_TIPEXP .Or. "02*" $ CB7->CB7_TIPEXP)
    VTAlert("Ordem de Separacao  configurada para ter embalagem: " + cOrdSep,"[-]",.T.,2500)
    VTClearGet("cOrdSep")
    lRet := .F.
Else // Ainda valido (Validacao U_STFSFA32() existente no STFSFA30)
    
    If cEmpAnt == "01" .And. cFilAnt == "02"

        DbSelectArea("SA1")
        SA1->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
        If SA1->(DbSeek(_cFilSA1 + CB7->CB7_CLIENT + CB7->CB7_LOJA))
            /*
            If !U_STFAT340("2","T") // Funcao nao encontrada
                lRet := .F. // Break
            EndIf
            
            If !U_STFAT340("4","T") // Funcao nao encontrada
                lRet := .F. 
            EndIf
            */
        EndIf

        // Verificar se o pedido de venda tem rota na TNT
        DbSelectArea("SC5")
        SC5->(DbSetOrder(1)) // C5_FILIAL + C5_NUM
        If SC5->(DbSeek(_cFilSC5 + CB7->CB7_PEDIDO))

            If AllTrim(SC5->C5_XORIG) == "2"
                If !VTYesNo("Atenção, pedido de internet, deseja continuar?","VldOrd30",.T.)
                    VTClearGet("cOrdSep")
                    lRet := .F.
                EndIf
            EndIf

            If AllTrim(SC5->C5_TRANSP) == "000163" .And. AllTrim(SC5->C5_TIPOCLI) <> "X" // TNT Exportacao
                DbSelectArea("SA1")
                SA1->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA

                _aEndEnt := u_STTNT011() // Funcao nao encontrada

                _cQrySZV := "SELECT *
                _cQrySZV += "FROM " + _cSqlSZV + " ZV WHERE "
                _cQrySZV += "ZV_CEPDE >= '" + _aEndEnt[01][01] + "' AND "   // Cep inicial conforme
                _cQrySZV += "ZV_CEPATE <= '" + _aEndEnt[01][01] + "' AND "  // Cep final conforme
                _cQrySZV += "ZV.D_E_L_E_T_ = ' '"
                If Select("QRYSZV") > 0
                    QRYSZV->(DbCloseArea())
                EndIf
                DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySZV),"QRYSZV",.T.,.T.)
                QRYSZV->(DbGoTop())
                If QRYSZV->(EOF()) /*
                    VTAlert("Rota TNT nao encontrada!","[-]",.T.,2500)
                    VTClearGet("cOrdSep")
                    lRet := .F. */
                EndIf
            EndIf
        EndIf
    EndIf

EndIf
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MontVols ºAutor ³Jonathan Schmidt Alves º Data ³20/05/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Montagem dos volumes existentes da Ordem de Separacao.     º±±
±±º          ³                                                            º±±
±±º          ³ CB6: Volumes da Embalagem                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function MontVols(cOrdSep) // Montagem dos volumes
Local nQtdEmb := 0
Local cRegiao := ""
Local nTotCub := 0
Local nTotPes := 0
Local aVolAux := {}
Local aVolums := {}
DbSelectArea("CB6") // Volumes de Embalagem
CB6->(DbOrderNickName("STFSCB601")) // CB6_FILIAL + CB6_XORDSE + CB6_VOLUME
DbSelectArea("CB3") // Tipos de Embalagem
CB3->(DbSetOrder(1)) // CB3_FILIAL + CB3_CODEMB
DbSelectArea("CB1") // Operadores
CB1->(DbSetOrder(1)) // CB1_FILIAL + CB1_CODOPE
If CB6->(DbSeek(_cFilCB6 + cOrdSep))
	While CB6->(!EOF()) .And. CB6->CB6_FILIAL + CB6->CB6_XORDSE == _cFilCB6 + cOrdSep // Volumes
        If CB3->(DbSeek(_cFilCB3 + CB6->CB6_TIPVOL)) // Tipo Volume
            If CB1->(DbSeek(_cFilCB1 + CB6->CB6_XOPERA)) // Operador
                nQtdEmb := STEMB30(CB6->CB6_VOLUME)
                If Empty(Alltrim(cRegiao))
                    cRegiao := u_RegCeped(CB6->CB6_PEDIDO)
                EndIf
                aVolAux := { /*oEmb*/ "",;                              // 01: Bolinha
                Right(CB6->CB6_VOLUME, 4),;                             // 02: Seq.
                CB6->CB6_TIPVOL + " " + CB3->CB3_DESCRI,;               // 03: Tipo Embalagem
                CB3->CB3_ALTURA,;                                       // 04: Altura
                CB3->CB3_LARGUR,;                                       // 05: Largura
                CB3->CB3_PROFUN,;                                       // 06: Profundidade
                cRegiao,;                                               // 07: Regiao
                Transform(CB6->CB6_XPESO,"999999.99"),;                 // 08: Peso Volume
                nQtdEmb,;                                               // 09: Qtde Itens
                CB6->CB6_XOPERA + " " + CB1->CB1_NOME,;                 // 10: Nome do Operador
                Dtoc(CB6->CB6_XDTINI) + " " + CB6->CB6_XHINI,;          // 11: Data + Hora Abertura
                Dtoc(CB6->CB6_XDTFIN) + " " + CB6->CB6_XHFIN,;          // 12: Ultima Ocorrencia
                " "}                                                    // 13: Vazio
                nTotPes += CB6->CB6_XPESO
                nTotCub += CB3->CB3_VOLUME // Renato Nogueira - Chamado 000214
                aAdd(aVolums, aClone(aVolAux))
            EndIf
        EndIf
		CB6->(DbSkip())
	End
EndIf
Return aVolums




Static Function RetStatus(cStatus)
Local aStatus := { "Nao iniciado", "Em separacao", "Separacao finalizada", "Em processo de embalagem", "Embalagem Finalizada", "Nota gerada", "Nota impressa", "Volume impresso", "Em processo de embarque", "Finalizado" }
Local _cRet := aStatus[Val(cStatus) + 1]
If _cRet $ "Nao iniciado#Em separacao" .And. CB7->CB7_XOPE2 <> " " .And. cFilAnt == "02" // Giovani zago 24/05/19 ajuste para começar a embalagem quando tiver 2 separadores. ticket 20190517000020
	_cRet := Space(01)
EndIf
Return _cRet

/*====================================================================================\
|Programa  | STEMB30             | Autor | GIOVANI.ZAGO          | Data | 30/07/2014  |
|=====================================================================================|
|Descrição |  Retorna volume			                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STEMB30                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function STEMB30(_cVol)
Local _nRet30    := 0
Local _aArea     := GetArea()
Local cAliasLif  := 'TMPB30VOL'
Local cQuery     := ' '
cQuery := "  SELECT
cQuery += " sum(CB9.CB9_QTEEMB)
cQuery += ' as "CB9_QTEEMB"
cQuery += " FROM "+RetSqlName("CB9")+" CB9 "
cQuery += " WHERE CB9.D_E_L_E_T_ = ' '
cQuery += " AND CB9.CB9_VOLUME = '"+_cVol+"'"
cQuery += " AND CB9.CB9_FILIAL = '"+xFilial("CB9")+"'"
//cQuery := ChangeQuery(cQuery)
If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
dbSelectArea(cAliasLif)
If  Select(cAliasLif) > 0
	(cAliasLif)->(dbgotop())
	While (cAliasLif)->(!Eof())
		_nRet30+= (cAliasLif)->CB9_QTEEMB
		(cAliasLif)->(DbSkip())
	End
EndIf
If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf
RestArea(_aArea)
Return _nRet30

Static Function StUltimo(cOrdSep)
Local aArea		:= GetArea()
Local aAreaCB6	:= CB6->(GetArea())
Local cVolume	:= cOrdSep+"0000"
Local cTime     := Time()
Local cHora     := SUBSTR(cTime, 1, 2)
Local cMinutos  := SUBSTR(cTime, 4, 2)
Local cSegundos := SUBSTR(cTime, 7, 2)
Local cAliasLif := 'STVOL'+cHora+ cMinutos+cSegundos
Local cQuery    := ' '
cQuery := " SELECT
cQuery += " CB6.CB6_VOLUME
cQuery += " FROM "+RetSqlName("CB6")+" CB6 "
cQuery += " WHERE CB6.D_E_L_E_T_ = ' '
cQuery += " AND CB6.CB6_XORDSE = '"+cOrdSep+"'"
cQuery += " AND CB6.CB6_FILIAL =  '"+xFilial("CB6")+"'"
cQuery += " ORDER BY CB6.CB6_VOLUME
// cQuery := ChangeQuery(cQuery)
If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf
DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	While (cAliasLif)->(!Eof())
		cVolume := Soma1(cVolume)
		If cVolume <> (cAliasLif)->CB6_VOLUME
			cVolume:= Tira1(cVolume)
			RestArea(aAreaCB6)
			RestArea(aArea)
			Return cVolume
		EndIf
		(cAliasLif)->(DbSkip())
	End
	(cAliasLif)->(dbCloseArea())
EndIf
If Empty(Alltrim(cVolume))
	cVolume	:= cOrdSep + "0000"
EndIf
RestArea(aAreaCB6)
RestArea(aArea)
Return cVolume
