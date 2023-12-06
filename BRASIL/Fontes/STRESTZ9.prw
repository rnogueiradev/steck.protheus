#Include 'Protheus.ch'
#Include 'RestFul.CH'

/*====================================================================================\
|Programa  | STRESTZ9         | Autor | Marcio NIshime             | Data | 30/06/2021|
|=====================================================================================|
|Descrição | APi para o módulo de aprovações do App Steck                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck..                                                    	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STRESTZ9()
Return

WSRESTFUL APROVACAOAPP DESCRIPTION "Serviço REST para Aprovações"
    WSDATA CODIGO As String
    WSDATA TIPO As String
    WSDATA STATUS As String
    WSDATA EMPRESA As String

    WSMETHOD GET GETAPROVACOES DESCRIPTION "Retorna lista de aprovações pendentes" WSSYNTAX "/APROVACAOAPP/GETAPROVACOES"  PATH  "/APROVACAOAPP/GETAPROVACOES"
    WSMETHOD GET GETITENS DESCRIPTION "Retorna lista de itens da aprovacao" WSSYNTAX "/APROVACAOAPP/{TIPO}/{CODIGO}" PATH "/APROVACAOAPP/{TIPO}/{CODIGO}"
    WSMETHOD GET GETMOTIVOS DESCRIPTION "Retorna lista de motivos para rejeicao" WSSYNTAX "/APROVACAOAPP/GETMOTIVOS" PATH "/APROVACAOAPP/GETMOTIVOS"
    WSMETHOD GET GETACESSO DESCRIPTION "Verifica Acesso do usuário ao Prohetus" WSSYNTAX "/APROVACAOAPP/GETACESSO" PATH "/APROVACAOAPP/GETACESSO"
    WSMETHOD PUT DESCRIPTION "Atualiza status dos itens aprovados/reprovados" WSSYNTAX "/APROVACAOAPP/{TIPO}/{CODIGO}/{STATUS}" PATH "/APROVACAOAPP/{TIPO}/{CODIGO}/{STATUS}"
END WSRESTFUL

WSMETHOD GET GETAPROVACOES WSSERVICE APROVACAOAPP
    Local aArea := GetArea()
    Local aJson := {}
    Local cQuery := ""
    Local cAlias := "SC1"

    ::SetContentType("application/json")

    cQuery	:= "SELECT '01' AS EMPRESA, C1_FILIAL FILIAL, C1_NUM NUMERO, C1_MOTIVO MOTIVO, C1_ZAPROV ZAPROV, C1_SOLICIT SOLICIT, C1_EMISSAO EMISSAO, 'COMPRAS' TIPO "
    cQuery	+= "FROM SC1010 COMPRAS "
    cQuery	+= "WHERE COMPRAS.D_E_L_E_T_=' ' AND C1_ZAPROV='" + __cUserid  + "' AND C1_ZSTATUS IN ('1','2') "
    cQuery	+= "UNION "
    cQuery	+= "SELECT '03' AS EMPRESA, C1_FILIAL FILIAL, C1_NUM NUMERO, C1_MOTIVO MOTIVO, C1_ZAPROV ZAPROV, C1_SOLICIT SOLICIT, C1_EMISSAO EMISSAO, 'COMPRAS' TIPO "
    cQuery	+= "FROM SC1030 COMPRAS "
    cQuery	+= "WHERE COMPRAS.D_E_L_E_T_=' ' AND C1_ZAPROV='" + __cUserid  + "' AND C1_ZSTATUS IN ('1','2')"
    
    cQuery := ChangeQuery(cQuery)

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

    DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
    While (cAlias)->(!Eof())

        Aadd(aJson,JsonObject():new())
        nPos := Len(aJson)
        aJson[nPos]['EMPRESA'] := (cAlias)->EMPRESA
        aJson[nPos]['FILIAL'] := AllTrim((cAlias)->FILIAL)
        aJson[nPos]['NUMERO'] := AllTrim((cAlias)->NUMERO)
        aJson[nPos]['MOTIVO'] := AllTrim((cAlias)->MOTIVO)
        aJson[nPos]['ZAPROV'] := AllTrim((cAlias)->ZAPROV)
        aJson[nPos]['SOLICIT'] := AllTrim((cAlias)->SOLICIT)
        aJson[nPos]['EMISSAO'] := DTOC(STOD(AllTrim((cAlias)->EMISSAO)))
        aJson[nPos]['TIPO'] := AllTrim((cAlias)->TIPO)

        (cAlias)->(DbSkip())
    EndDo
    
    wrk := JsonObject():new()
    wrk:set(aJson)

    ::SetResponse(EncodeUTF8(wrk:toJSON(), "cp1252"))

    (cAlias)->(dbCloseArea())
    RestArea(aArea)
Return(.T.)

WSMETHOD GET GETITENS WSSERVICE APROVACAOAPP
    Local cCodigo   := Self:CODIGO
    Local cTipo     := Self:TIPO
    Local aArea     := GetArea()
    Local aJson     := {}
    Local cQuery    := ""
    Local cAlias    := ""

    ::SetContentType("application/json")

    Do Case
        Case cTipo = "COMPRAS"
            cAlias  := "SC1"
            cQuery	:= "SELECT C1_NUM NUMERO, C1_ZSTATUS STATUS, C1_ITEM ITEM, C1_PRODUTO PRODUTO, C1_TOTAL TOTAL, C1_DESCRI DESCRI, C1_QUANT QUANT, C1_CC CC, C1_DATPRF ENTREGA, C1_OBS OBS"
            cQuery	+= "FROM " +RetSqlName(cAlias) + " COMPRAS"
            cQuery	+= "WHERE COMPRAS.D_E_L_E_T_=' ' AND C1_FILIAL='" + cFilAnt + "' AND C1_NUM='" + cCodigo + "' AND C1_ZSTATUS IN ('1','2')"
        Otherwise
            cQuery	:= ""
    End Case

    cQuery := ChangeQuery(cQuery)

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

    DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
    While (cAlias)->(!Eof())

        Aadd(aJson,JsonObject():new())
        nPos := Len(aJson)
        aJson[nPos]['NUMERO'] := AllTrim((cAlias)->NUMERO)
        aJson[nPos]['STATUS'] := AllTrim((cAlias)->STATUS)
        aJson[nPos]['ITEM'] := AllTrim((cAlias)->ITEM)
        aJson[nPos]['PRODUTO'] := AllTrim((cAlias)->PRODUTO)
        aJson[nPos]['TOTAL'] := cValToChar((cAlias)->TOTAL)
        aJson[nPos]['DESCRI'] := AllTrim((cAlias)->DESCRI)
        aJson[nPos]['QUANT'] := cValToChar((cAlias)->QUANT)
        aJson[nPos]['CC'] := AllTrim((cAlias)->CC)
        aJson[nPos]['ENTREGA'] := DTOC(STOD(AllTrim((cAlias)->ENTREGA)))
        aJson[nPos]['OBS'] := AllTrim((cAlias)->OBS)

        (cAlias)->(DbSkip())
    EndDo
    
    wrk := JsonObject():new()
    wrk:set(aJson)

    ::SetResponse(EncodeUTF8(wrk:toJSON(), "cp1252"))

    (cAlias)->(dbCloseArea())
    RestArea(aArea)
Return(.T.)

WSMETHOD GET GETMOTIVOS WSSERVICE APROVACAOAPP
    Local aArea     := GetArea()
    Local aJson     := {}
    Local cAlias    := "SX5"
    Local cTabela   := "Z6"

    ::SetContentType("application/json")

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

    DbSelectArea(cAlias)
	(cAlias)->(dbSetOrder(1))
    (cAlias)->(dbSeek(xFilial(cAlias) + cTabela))
    While (cAlias)->(!Eof()).and. xFilial(cAlias) = (cAlias)->X5_FILIAL .And. (cAlias)->X5_TABELA  = cTabela
        Aadd(aJson,JsonObject():new())
        nPos := Len(aJson)
        aJson[nPos]['CODIGO'] := AllTrim((cAlias)->X5_CHAVE)
        aJson[nPos]['DESCRICAO'] := AllTrim((cAlias)->X5_DESCRI)

        (cAlias)->(DbSkip())
    EndDo
    
    wrk := JsonObject():new()
    wrk:set(aJson)

    ::SetResponse(EncodeUTF8(wrk:toJSON(), "cp1252"))

    (cAlias)->(dbCloseArea())
    RestArea(aArea)
Return(.T.)

WSMETHOD GET GETACESSO WSSERVICE APROVACAOAPP
    Local cResp := ""

    cResp := '{"CODRET":"00","DESCRET":"Usuário válido!"}'

    ::SetResponse(EncodeUTF8(cResp, "cp1252"))
Return(.T.)

WSMETHOD PUT WSSERVICE APROVACAOAPP
    Local cNum       := Self:CODIGO
    Local cStatus    := Self:STATUS
    Local cTipo      := Self:TIPO
    Local _cJsonRec  := StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
    Local cQuery     := ""
    Local cAlias     := ""
    Local cZSTATUS   := ""
    Local cZDTAPRO   := ""
    Local cZHRAPRO   := ""
    Local cZLOG      := ""
    Local _cMsg      := ""
    Local cMotRej    := ""
    Local _lRet      := {}
    Local _nX
    Local oJson
    Local aArea     := GetArea()

    ::SetContentType("application/json")

    oJson := JsonObject():New()
    _lRet := oJson:FromJson(_cJsonRec)

    if ValType(_lRet) == "C"
        cResp := '{"CODRET":"03","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(cResp)
		Return .T.
    endif

    If cTipo = "COMPRAS"
            cAlias   := "SC1"
            cZSTATUS := "C1_ZSTATUS"
            cZDTAPRO := "C1_ZDTAPRO"
            cZHRAPRO := "C1_ZHRAPRO"
            cZLOG    := "C1_ZLOG"
    Endif

    If cStatus == '3'
        _cStatus := "Aprovado Pelo Gestor - AppSteck"
    Elseif cStatus == '4'
        _cStatus := "Rejeitado Pelo Gestor - AppSteck"
        cMotRej  := "Motivo de Rejeição: " + oJson[1]:MOTIVO +CHR(13)+CHR(10)
    EndIf

    cQuery := ChangeQuery(cQuery)

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

    DbSelectArea(cAlias)
    (cAlias)->(DbSetOrder(1))
	(cAlias)->(DbGoTop())
    For _nX:=1 To Len(oJson)
        If dbSeek(xFilial((cAlias))+cNum+oJson[_nX]:ITEM)
            _cMsg := "===================================" +CHR(13)+CHR(10)
            _cMsg += "Item de Solicitação de Compra com Status '"+_cStatus+"' por: " +CHR(13)+CHR(10)
            _cMsg += "Usuário: "+cUserName+CHR(13)+CHR(10)
            _cMsg += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
            _cMsg += IIF(cMotRej != "", cMotRej, "")
            RECLOCK((cAlias), .F.)
            (cAlias)->(&(cZSTATUS)) := cStatus
            (cAlias)->(&(cZDTAPRO)) := DDATABASE
            (cAlias)->(&(cZHRAPRO)) := TIME()
            (cAlias)->(&(cZLOG))    := (cAlias)->(&(cZLOG)) + CHR(13)+ CHR(10) + _cMsg
            (cAlias)->(MSUNLOCK())
        EndIf
    Next

    cResp := '{"CODRET":"00","DESCRET":"Aprovacao/reprovacao realizada com sucesso."}'

    ::SetResponse(EncodeUTF8(cResp, "cp1252"))

    (cAlias)->(dbCloseArea())
    RestArea(aArea)
Return(.T.)
