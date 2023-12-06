#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120BRW  ºAutor  ³Microsiga           º Data ³  14/02/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120BRW()

Local cUserDt2 := GetMv("ST_DT2USER")

If __cUserId $ cUserDt2

    AAdd( aRotina, { 'Dt Entrega 2', 'U_DtEnt2', 0, 4 } )

ENDIF

Return


/*/{Protheus.doc} DtEnt2
Função para ver os grupos de produto
@author Atilio ****adaptado
@since 07/04/2019
@version 1.0
@type function
/*/

User Function DtEnt2()

    Local aArea := GetArea()

    Private oDlgPvt
    Private oMsGetSC7
    Private aHeadSC7 := {}
    Private aColsSC7 := {}
    Private oBtnSalv
    Private oBtnFech
    Private nJanLarg    := 850
    Private nJanAltu    := 500
    Private cFontUti   := "Tahoma"
    Private oFontAno   := TFont():New(cFontUti,,-38)
    Private oFontSub   := TFont():New(cFontUti,,-20)
    Private oFontSubN  := TFont():New(cFontUti,,-20,,.T.)
    Private oFontBtn   := TFont():New(cFontUti,,-14)

    IF SC7->C7_ENCER <> 'E'

        aAdd(aHeadSC7, {"Item",              "C7_ITEM",    "",                            TamSX3("C7_ITEM")[01],    0,         ".F.",   ".T.", "C", "",  ""} )
        aAdd(aHeadSC7, {"Código",            "C7_PRODUTO", "",                            TamSX3("C7_PRODUTO")[01], 0,         ".F.",   ".F.", "C", "",  ""} )
        aAdd(aHeadSC7, {"Descrição",         "C7_DESCRI",  "",                            TamSX3("C7_DESCRI")[01],  0,         ".F.",   ".T.", "C", "",  ""} )
        aAdd(aHeadSC7, {"Data Entrega",      "C7_DATPRF",  "",                            TamSX3("C7_DATPRF")[01],  0,         ".F.",   ".T.", "D", "",  ""} )
        aAdd(aHeadSC7, {"Data Entrega 2",    "C7_XDATPRF", "",                            TamSX3("C7_XDATPRF")[01], 0,         ".T.",   ".T.", "D", "",  ""} )
        aAdd(aHeadSC7, {"SC7 Recno",         "XX_RECNO",   "@E 999,999,999,999,999,999",  018,                      0,         ".F.",   ".F.", "N", "",  ""} )

        Processa({|| fCarAcols()}, "Processando")

        DEFINE MSDIALOG oDlgPvt TITLE "Itens do Pedido" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL

        @ 004, 003 SAY "Data Entrega 2"     SIZE 200, 030 FONT oFontAno  OF oDlgPvt COLORS RGB(149,179,215) PIXEL
        @ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Fechar"        SIZE 050, 018 OF oDlgPvt ACTION (oDlgPvt:End())                               FONT oFontBtn PIXEL
        @ 006, (nJanLarg/2-001)-(0052*02) BUTTON oBtnSalv  PROMPT "Salvar"        SIZE 050, 018 OF oDlgPvt ACTION (fSalvar())                                   FONT oFontBtn PIXEL

        oMsGetSC7 := MsNewGetDados():New(   029,;
            003,;
            (nJanAltu/2)-3,;
            (nJanLarg/2)-3,;
            GD_UPDATE,;
            "AllwaysTrue()",;
            ,;
            "",;
            {"C7_XDATPRF"},;
            ,;
            9999,;
            ,;
            ,;
            ,;
            oDlgPvt,;
            aHeadSC7,;
            aColsSC7)

        ACTIVATE MSDIALOG oDlgPvt CENTERED

    else

        MsgInfo("Não é possivel alterar Pedidos encerrados!", "Atenção")

    EndIF

    RestArea(aArea)

Return

/*------------------------------------------------*
 | Func.: fCarAcols                               |
 | Desc.: Função que carrega o aCols              |
 *------------------------------------------------*/
 
Static Function fCarAcols()

    Local aArea  := GetArea()
    Local cQry   := ""
    Local nAtual := 0
    Local nTotal := 0

    cQry := " SELECT "                                                  + CRLF
    cQry += "     C7_ITEM, "                                            + CRLF
    cQry += "     C7_PRODUTO, "                                         + CRLF
    cQry += "     C7_DESCRI, "                                          + CRLF
    cQry += "     C7_DATPRF, "                                          + CRLF
    cQry += "     C7_XDATPRF, "                                         + CRLF
    cQry += "     SC7.R_E_C_N_O_ AS SC7REC "                            + CRLF
    cQry += " FROM "                                                    + CRLF
    cQry += "     " + RetSQLName('SC7') + " SC7 "                       + CRLF
    cQry += " WHERE "                                                   + CRLF
    cQry += "     C7_FILIAL = '" + xFilial('SC7') + "' "                + CRLF   
    cQry += "     AND C7_NUM = '" + SC7->C7_NUM + "' "                  + CRLF
    cQry += "     AND SC7.D_E_L_E_T_ = ' ' "                            + CRLF
    cQry += " ORDER BY "                                                + CRLF
    cQry += "     C7_ITEM "                                             + CRLF
    TCQuery cQry New Alias "QRY_SC7"

    Count To nTotal
    ProcRegua(nTotal)
     
    QRY_SC7->(DbGoTop())

    While ! QRY_SC7->(EoF())
     
        nAtual++
        IncProc("Adicionando " + Alltrim(QRY_SC7->C7_ITEM) + " (" + cValToChar(nAtual) + " de " + cValToChar(nTotal) + ")...")
         
        aAdd(aColsSC7, { ;
            QRY_SC7->C7_ITEM,;
            QRY_SC7->C7_PRODUTO,;
            QRY_SC7->C7_DESCRI,;
            SToD(QRY_SC7->C7_DATPRF),;
            SToD(QRY_SC7->C7_XDATPRF),;
            QRY_SC7->SC7REC,;
            .F.;
            })

        QRY_SC7->(DbSkip())

    EndDo
    
    QRY_SC7->(DbCloseArea())

    RestArea(aArea)
Return

/*--------------------------------------------------------*
 | Func.: fSalvar                                         |
 | Desc.: Função que percorre as linhas e faz a gravação  |
 *--------------------------------------------------------*/

Static Function fSalvar()

    Local aColsAux := oMsGetSC7:aCols
    Local nPosIte  := aScan(aHeadSC7, {|x| Alltrim(x[2]) == "C7_ITEM"})
    Local nPosPro  := aScan(aHeadSC7, {|x| Alltrim(x[2]) == "C7_PRODUTO"})
    Local nPosDes  := aScan(aHeadSC7, {|x| Alltrim(x[2]) == "C7_DESCRI"})
    Local nPosDt1  := aScan(aHeadSC7, {|x| Alltrim(x[2]) == "C7_DATPRF"})
    Local nPosDt2  := aScan(aHeadSC7, {|x| Alltrim(x[2]) == "C7_XDATPRF"})
    Local nPosRec  := aScan(aHeadSC7, {|x| Alltrim(x[2]) == "XX_RECNO"})
    Local nPosDel  := Len(aHeadSC7) + 1
    Local nLinha   := 0
     
    DbSelectArea('SC7')
     
    For nLinha := 1 To Len(aColsAux)
     
        If aColsAux[nLinha][nPosRec] != 0
            SC7->(DbGoTo(aColsAux[nLinha][nPosRec]))
        EndIf
         
            RecLock('SC7', .F.)
            SC7->C7_XDATPRF   := aColsAux[nLinha][nPosDt2]
            SC7->(MsUnlock())

    Next

    MsgInfo("Manipulações finalizadas!", "Atenção")

    oDlgPvt:End()

Return