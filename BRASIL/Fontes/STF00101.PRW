#Include "Totvs.ch" 

/*/{Protheus.doc} User Function STF00101
Aglutinação de títulos à pagar referente ao Faturas GFE
@type  Function
@author Ricardo Minoro
@since  22/05/2023
@version version

Tabelas envolvidas
GW3 - Documentos de frete
GW6 - Faturas de Frete
SE2 - Títulos à Pagar
/*/

User Function STF00101()

    Local aArea := GetArea()
    //Fontes
    Local cFontUti    := "Tahoma"
    Local oFontAno    := TFont():New(cFontUti,,-38)
    Local oFontSub    := TFont():New(cFontUti,,-20)
    Local oFontSubN   := TFont():New(cFontUti,,-20,,.T.)
    Local oFontBtn    := TFont():New(cFontUti,,-14)
    Local lRet        := .F.

    //Janela e componentes
    Private oDlgGrp
    Private oPanGrid
    Private oGetGrid
    Private aColunas    := {}
    Private cAliasTab   := getnextalias()

    Private aHeadAux    := {}
    Private aHeadTmp    := {}

    Private nQtdTit     := 0
    Private nVlrTot     := 0

    Private cMsgErro    := ""

    //Tamanho da janela
    Private    aTamanho := MsAdvSize()
    Private    nJanLarg := aTamanho[5]
    Private    nJanAltu := aTamanho[6]

    if GW6->GW6_SITAPR <> '3'
        msginfo("Status da fatura não permite aglutinar os títulos.")
        return .F.
    endif
 
    //Cria a temporária
    oTempTable := FWTemporaryTable():New(cAliasTab)

    //Monta o cabecalho
    STF00101A()
     
    //Define as colunas usadas, adiciona indice e cria a temporaria no banco
    oTempTable:SetFields( aHeadTmp )
    oTempTable:AddIndex("1", {"E2_FILIAL"} )
    oTempTable:Create()
 
    //Montando os dados, eles devem ser montados antes de ser criado o FWBrowse
    FWMsgRun(, {|oSay| STF00101B(oSay) }, "Processando", "Buscando os Títulos à Pagar")
 
    //Criando a janela
    DEFINE MSDIALOG oDlgGrp TITLE "Aglutinação de Título a Pagar" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
    
        //Labels gerais
        @ 004, 003 SAY "GFE"                      SIZE 200, 030 FONT oFontAno  OF oDlgGrp COLORS RGB(149,179,215) PIXEL
        @ 004, 050 SAY "Aglutinação"              SIZE 200, 030 FONT oFontSub  OF oDlgGrp COLORS RGB(031,073,125) PIXEL
        @ 014, 050 SAY "Títulos a Pagar"          SIZE 200, 030 FONT oFontSubN OF oDlgGrp COLORS RGB(031,073,125) PIXEL

        @ 014, 150 SAY "QTD.Titulos"              SIZE 200, 030 FONT oFontSubN OF oDlgGrp COLORS RGB(149,179,215) PIXEL
        @ 004, 210 GET nQtdTit PICTURE "@E 99,999.99" WHEN .F. SIZE 150, 025 FONT oFontSubN Of oDlgGrp COLORS RGB(031,073,125) PIXEL

        @ 014, 400 SAY "Vlr.Total"                SIZE 200, 030 FONT oFontSubN OF oDlgGrp COLORS RGB(149,179,215) PIXEL
        @ 004, 450 GET nVlrTot PICTURE PesqPict("SE2","E2_VALOR") WHEN .F. SIZE 150, 025 FONT oFontSubN Of oDlgGrp COLORS RGB(031,073,125) PIXEL
 
        //Botões
        @ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Fechar"        SIZE 050, 018 OF oDlgGrp ACTION (oDlgGrp:End())   FONT oFontBtn PIXEL
        @ 006, (nJanLarg/2-001)-(0052*02) BUTTON oBtnLege  PROMPT "Processar"     SIZE 050, 018 OF oDlgGrp ACTION (STF00101C()) FONT oFontBtn PIXEL
 
        //oGrpDad:oFont := oFontBtn
        oPanGrid := tPanel():New(033, 006, "", oDlgGrp, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2 - 13),     (nJanAltu/2 - 45))
        oGetGrid := FWBrowse():New()
        oGetGrid:DisableFilter()
        oGetGrid:DisableConfig()
        oGetGrid:DisableReport()
        oGetGrid:DisableSeek()
        oGetGrid:DisableSaveConfig()
        oGetGrid:SetFontBrowse(oFontBtn)
        oGetGrid:SetAlias(cAliasTab)
        oGetGrid:SetDataTable()
        oGetGrid:SetInsert(.F.)
        oGetGrid:SetDelete(.F., { || .F. })
        oGetGrid:lHeaderClick := .F.
        oGetGrid:SetColumns(aColunas)
        oGetGrid:SetOwner(oPanGrid)
        oGetGrid:Activate()

    ACTIVATE MsDialog oDlgGrp CENTERED
 
    //Deleta a temporaria
    oTempTable:Delete()
 
    RestArea(aArea)

Return

/*
    Montagem da estrutura que será apresentado em GRID
*/

Static Function STF00101A()

    Local cCampos  := "E2_FILIAL|E2_PREFIXO|E2_NUM|E2_PARCELA|E2_TIPO|E2_FORNECE|E2_LOJA|E2_NOMFOR|E2_VALOR|E2_EMISSAO|E2_VENCREA|E2_HIST"
    Local aAreaGet := getarea()
    Local nx       := 0
 
    //Adicionando colunas
    //[1] - Campo da Temporaria
    //[2] - Titulo
    //[3] - Tipo
    //[4] - Tamanho
    //[5] - Decimais
    //[6] - Máscara

    dbselectarea("SX3")
    SX3->( dbsetorder(1) )
    if SX3->( dbseek( "SE2" ) )
        while SX3->( !eof() ) .and. SX3->X3_ARQUIVO == "SE2"
            if alltrim(SX3->X3_CAMPO) $ cCampos
                aadd(aHeadAux, { SX3->X3_CAMPO,;
                                 SX3->X3_TITULO,;
                                 SX3->X3_TIPO,;
                                 SX3->X3_TAMANHO,;
                                 SX3->X3_DECIMAL,;
                                 SX3->X3_PICTURE})

                aadd(aHeadTmp, { SX3->X3_CAMPO,;
                                 SX3->X3_TIPO,;
                                 SX3->X3_TAMANHO,;
                                 SX3->X3_DECIMAL})


            endif
            SX3->(dbskip())
        enddo
        aadd(aHeadAux, {"RECNOSE2","SE2 RECNO","C", 10, 0, "@!"})
        aadd(aHeadTmp, {"RECNOSE2","C", 10, 0})
    endif

    //Percorrendo e criando as colunas
    For nx := 1 To Len(aHeadAux)

        if alltrim(aHeadAux[nx,1]) <> "RECNOSE2"
            oColumn := FWBrwColumn():New()
            oColumn:SetData(&("{|| " + cAliasTab + "->" + aHeadAux[nx][1] +"}"))
            oColumn:SetTitle(aHeadAux[nx][2])
            oColumn:SetType(aHeadAux[nx][3])
            oColumn:SetSize(aHeadAux[nx][4])
            oColumn:SetDecimal(aHeadAux[nx][5])
            oColumn:SetPicture(aHeadAux[nx][6])
            aAdd(aColunas, oColumn)
        endif

    Next

    restarea(aAreaGet)

Return

/*
    Montagem da tabela temporária com os dados do documento de frete GW3 x Titulos a Pagar SE2
*/
Static Function STF00101B(oSay)

    Local aArea     := GetArea()
    Local cQry      := ""
    Local nAtual    := 0
    Local nTotal    := 0
    Local nY        := 0
    Local cChave    := GW6->GW6_FILIAL + GW6->GW6_EMIFAT + GW6->GW6_NRFAT
    Local cQryTmp   := getnextalias()
 
    //Zera a grid
    aColsGrid := {}
     
    //Montando a query
    oSay:SetText("Montando a consulta")

    cQry := " SELECT "                                                          + CRLF
    for nY := 1 to len(aHeadAux)
        if alltrim(aHeadAux[nY,1]) <> "RECNOSE2"
            if nY == 1
                cQry += aHeadAux[nY,1]                                              + CRLF
            else
                cQry += " , " + aHeadAux[nY,1]                                      + CRLF
            endif
        endif
    next nY
    cQry += " , SE2.R_E_C_N_O_ AS RECNOSE2, E2_SALDO "
    cQry += " FROM " + retsqlname("SE2") + " SE2 "                              + CRLF
    cQry += "   INNER JOIN " + retsqlname("GW6") + " GW6 "                      + CRLF
    cQry += "       ON GW6_FILIAL + GW6_EMIFAT + GW6_NRFAT = '"+ cChave +"'"    + CRLF
    cQry += "       AND GW6.D_E_L_E_T_ = ' ' "                                  + CRLF
    cQry += "   INNER JOIN " + retsqlname("GW3") + " GW3 "                      + CRLF
    cQry += "       ON GW3_FILIAL = GW6_FILIAL "                                + CRLF
    cQry += "       AND GW3_EMIFAT = GW6_EMIFAT "                               + CRLF
    cQry += "       AND GW3_NRFAT = GW6_NRFAT "                                 + CRLF
    cQry += "       AND GW3.D_E_L_E_T_ = ' ' "                                  + CRLF
    cQry += "   INNER JOIN " + retsqlname("SA2") + " SA2 "                      + CRLF
    cQry += "       ON A2_CGC = GW3_EMISDF "                                    + CRLF
    cQry += "       AND SA2.D_E_L_E_T_ = ' ' "                                  + CRLF
    cQry += " WHERE E2_FILIAL = GW3_FILIAL "                                    + CRLF
    cQry += " AND E2_PREFIXO = GW3_SERDF "                                      + CRLF
    cQry += " AND E2_NUM = GW3_NRDF "                                           + CRLF
    cQry += " AND E2_FORNECE = A2_COD "                                         + CRLF
    cQry += " AND E2_LOJA = A2_LOJA "                                           + CRLF
    cQry += " AND E2_EMISSAO = GW3_DTEMIS "                                     + CRLF
    cQry += " AND E2_SALDO > 0 "                                                + CRLF
    cQry += " AND SE2.D_E_L_E_T_ = ' ' "                                        + CRLF
    cQry += " ORDER BY SE2.R_E_C_N_O_ "                                         + CRLF
 
    //Executando a query
    oSay:SetText("Executando a consulta")
    PLSQuery(cQry, cQryTmp)
 
    //Se houve dados
    If !(cQryTmp)->(EoF())
        //Pegando o total de registros
        DbSelectArea(cQryTmp)

        Count To nTotal

        (cQryTmp)->(DbGoTop())
 
        //Enquanto houver dados
        nSaldo := 0
        While !(cQryTmp)->(EoF())
 
            //Muda a mensagem na regua
            nAtual++
            oSay:SetText("Adicionando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")

            Reclock(cAliasTab, .T.)
                for nY := 1 to len(aHeadAux)
                    (cAliasTab)->&(aHeadAux[nY,1]) := iif(alltrim(aHeadAux[nY,1])=="RECNOSE2",alltrim(cvaltochar((cQryTmp)->&(aHeadAux[nY,1]))),(cQryTmp)->&(aHeadAux[nY,1]))
                    if alltrim(aHeadAux[nY,1]) == "E2_VALOR"
                        nVlrTot += (cQryTmp)->&(aHeadAux[nY,1])
                    endif
                next nY
                nSaldo += (cQryTmp)->E2_SALDO
            (cAliasTab)->(MsUnlock())

            nQtdTit += 1
 
            (cQryTmp)->(DbSkip())
        EndDo

    EndIf
    (cQryTmp)->(DbCloseArea())
    (cAliasTab)->(DbGoTop())
 
    RestArea(aArea)

Return

/*
    Função execauto FINA290
*/
static function STF00101C(oProcess,lEnd)

    local lProcOk       as logical
    local nQtdRecs      as numeric
    local nTitAtu       as numeric
    local aAreas        as array
    local cTipoTit      as character
    local aTits         as array
    local nx            as numeric
    local nAux          as numeric
    local cLogTxt       as character

    local nTamTit       as numeric
    local nTamParc      as numeric
    local nTamForn      as numeric
    local nTamLoja      as numeric
    local nTamTipo      as numeric
    local nTamFil       as numeric
    local nTamPref      as numeric

    local dDataIni      as character
    local dDataFim      as character

    local cFornece      as character
    local cLoja         as character

    private lMsErroAuto := .F.

    default oProcess := nil
    default lEnd := .F.

    aRecnosBx := {}

    dbselectarea(cAliasTab)
    (cAliasTab)->( dbgotop() )
    while (cAliasTab)->(!eof())
        aadd( aRecnosBx, { alltrim((cAliasTab)->RECNOSE2) } )
        (cAliasTab)->( dbskip() )
    enddo

    cTipoTit    := superGetMv("ST_XPRJP01", .F., "FT")
    cPrefixo    := GW6->GW6_SERFAT
    cNumFat     := GW6->GW6_NRFAT
    cCondPgo    := superGetMv("ST_XPRJP03", .F., "001")
    cNaturez    := superGetMv("ST_XPRJP04", .F., "0001")
    dDtVenc     := GW6->GW6_DTVENC
    cFornece    := posicione("SA2",3,xfilial("SA2")+alltrim(GW6->GW6_EMIFAT),"A2_COD")
    cLoja       := posicione("SA2",3,xfilial("SA2")+alltrim(GW6->GW6_EMIFAT),"A2_LOJA")
    aAreas      := {SE2->(getArea()), getArea()}
    lProcOk     := .T.
    nQtdRecs    := len(aRecnosBx)
    nTitAtu     := 1
    nx          := 0

    dDataIni    := stod("20200101") //FirstDate(GW6->GW6_DTEMIS)
    dDataFim    := stod("20491231") //LastDate(GW6->GW6_DTEMIS)

    nTamTit     := TamSx3("E2_NUM")[1]
    nTamParc    := TamSx3("E2_PARCELA")[1]
    nTamForn    := TamSx3("E2_FORNECE")[1]
    nTamLoja    := TamSx3("E2_LOJA")[1]
    nTamTipo    := TamSx3("E2_TIPO")[1]
    nTamFil     := TamSx3("E2_FILIAL")[1]
    nTamPref    := TamSx3("E2_PREFIXO")[1]

    If oProcess <> Nil
		oProcess:SetRegua1(nQtdRecs)
	EndIf

    dbSelectArea("SE2")

    BEGIN TRANSACTION 

        aTits := {}

        for nx := 1 to len(aRecnosBx)

            If oProcess <> Nil
                oProcess:IncRegua1("Montando títulos originais..."+alltrim(cValToChar(nTitAtu)) +" de "+alltrim(cValToChar(nQtdRecs)))
                ProcessMessages()
            endif

            //--------------------------------------------------
            //Realiza primeiro as baixas dos ttulos originais
            //sem movimentar banco
            //--------------------------------------------------
            
            SE2->(dbGoTo(val(aRecnosBx[nTitAtu,1])))

            //[13] - ARRAY com os titulos da fatura - Geradores (esses ttulos devem existir na base)
            //[13,1] Prefixo
            //[13,2] Numero
            //[13,3] Parcela
            //[13,4] Tipo
            //[13,5] Ttulo localizado na geracao de fatura (lgico). Iniciar com falso.
            //[13,6] Fornecedor
            //[13,7] Loja
            //[13,8] Filial (utilizada em fatura de ttulos de diferentes filiais)

            aadd(aTits, { SE2->E2_PREFIXO   ,;
                          SE2->E2_NUM       ,;
                          SE2->E2_PARCELA   ,;
                          SE2->E2_TIPO      ,;
                          .F.               ,;
                          SE2->E2_FORNECE   ,;
                          SE2->E2_LOJA      ,;
                          SE2->E2_FILIAL    })

            nTitAtu++

        next nx

        if len(aTits) > 0

            If oProcess <> Nil
		        oProcess:SetRegua2()
                ProcessMessages()
	        EndIf

            //Descricao do Array aFatPag
            //[01] - Prefixo
            //[02] - Tipo
            //[03] - Numero da Fatura (se o numero estiver em branco obtem pelo FINA290)
            //[04] - Natureza
            //[05] - Data de
            //[06] - Data Ate
            //[07] - Fornecedor
            //[08] - Loja
            //[09] - Fornecedor para geracao
            //[10] - Loja do fornecedor para geracao
            //[11] - Condicao de pagto
            //[12] - Moeda
            //[13] - ARRAY com os titulos da fatura - Geradores
            //[14] - Valor de decrescimo
            //[15] - Valor de acrescimo
            aFatPag := { PADR(cPrefixo, nTamPref), PADR(cTipoTit,nTamTipo), cNumFat, cNaturez,;
                        dDataIni, dDataFim, cFornece, PADR(cLoja,nTamLoja), cFornece, PADR(cLoja,nTamLoja), cCondPgo, 01, aTits ,0 ,0 }

            MsExecAuto( { |x,y| FINA290(x,y)},3,aFatPag)

            if lMsErroAuto
                //mostraerro()
                aLogAuto := {}
                nAux     := 0
                aLogAuto := GetAutoGRLog()
                //Percorrendo o Log e incrementando o texto (para usar o CRLF você deve usar a include "Protheus.ch")
                For nAux := 1 To Len(aLogAuto)
                    cLogTxt += aLogAuto[nAux] + CRLF
                Next
                msginfo(cLogTxt)
                lProcOk  := .F.
            else

                SE2->( dbsetorder(1) )
                SE2->( dbseek( FK7->FK7_FILTIT + FK7->FK7_PREFIX + FK7->FK7_NUM + FK7->FK7_PARCEL + FK7->FK7_TIPO + FK7->FK7_CLIFOR + FK7->FK7_LOJA ) )

                lProcOk := .T.
                cMsgRet := "Foi gerado os dados abaixo"+CRLF
                cMsgRet += " Prefixo: "             + SE2->E2_PREFIXO +CRLF 
                cMsgRet += " Número: "              + SE2->E2_NUM +CRLF
                cMsgRet += " Parcela: "             + SE2->E2_PARCELA +CRLF
                cMsgRet += " Tipo: "                + SE2->E2_TIPO +CRLF
                cMsgRet += " Fornecedor: "          + SE2->E2_FORNECE +CRLF 
                cMsgRet += " Loja: "                + SE2->E2_LOJA +CRLF
                cMsgRet += " Nome: "                + alltrim(SE2->E2_NOMFOR) +CRLF
                cMsgRet += " Valor: "               + alltrim( transform( SE2->E2_VALOR, PesqPict("SE2","E2_VALOR") ) )+CRLF
                cMsgRet += " Data de Vencimento: "  + DTOC(SE2->E2_VENCREA)+CRLF

                reclock("GW6", .F.)
                    GW6->GW6_XSE2FA    := SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
                GW6->( msunlock() )
                
                msginfo(cMsgRet)

            endif

        else
            disarmtransaction()
        endif

    END TRANSACTION


    aEval(aAreas, {|aArea|restArea(aArea)})
    aSize(aAreas,0)

    //oProcess:End()

return lProcOk 
