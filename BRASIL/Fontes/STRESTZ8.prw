#Include 'Protheus.ch'
#Include 'RestFul.CH'

/*====================================================================================\
|Programa  | STRESTZ8         | Autor | Marcio NIshime             | Data | 30/04/2021|
|=====================================================================================|
|Descrição | APi para controle de notificações para usuário do PortalCliente          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck..                                                    	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STRESTZ8()
Return

WSRESTFUL NOTIFICACAO DESCRIPTION "Serviço REST para manipulação de Notificações"
    WSDATA EMAIL As String
    WSDATA COD As String

    WSMETHOD GET DESCRIPTION "Retorna a notificação informada" WSSYNTAX "/NOTIFICACAO/{}"
    WSMETHOD PUT DESCRIPTION "Atualiza a notificação como lida e retorna a msg" WSSYNTAX "/NOTIFICACAO/{}"
END WSRESTFUL

WSMETHOD GET WSRECEIVE EMAIL WSSERVICE NOTIFICACAO
    Local cEmail := Self:EMAIL
    Local aArea := GetArea()
    Local aJson := {}
    Local cQuery := ""
    Local cAlias := "Z86"

    ::SetContentType("application/json")

    cQuery	:= "SELECT "
    cQuery	+= "NOTIFICACOES.Z87_COD, "
    cQuery	+= "Z86_ASSUNT, "
    cQuery	+= "NVL(utl_raw.cast_to_varchar2(Z86_MENSAG),'') AS Z86_MENSAG, "
    cQuery	+= "Z86_DATA, "
    cQuery	+= "Z86_HORA, "
    cQuery	+= "NOTIFICACOES.Z87_LIDO "
    cQuery	+= "FROM " +RetSqlName("Z86")
    cQuery	+= " INNER JOIN "
    cQuery	+= "(SELECT Z87_CODNOT, Z87_COD, Z87_EMAIL, Z87_LIDO"
    cQuery	+= " FROM " +RetSqlName("Z87")
    cQuery	+= " WHERE Z87_EMAIL='"+cEmail+"' AND D_E_L_E_T_ = ' ') NOTIFICACOES"
    cQuery	+= " ON Z86_COD = NOTIFICACOES.Z87_CODNOT
    cQuery  += " ORDER BY to_date(Z86_DATA,'YYYYMMDD') DESC, Z86_HORA DESC"

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
        aJson[nPos]['Z87_COD'] := (cAlias)->Z87_COD
        aJson[nPos]['Z86_ASSUNT'] := AllTrim((cAlias)->Z86_ASSUNT)
        aJson[nPos]['Z86_MENSAG'] := AllTrim((cAlias)->Z86_MENSAG)
        aJson[nPos]['Z87_EMAIL'] := AllTrim(cEmail)
        aJson[nPos]['Z86_DATA'] := DTOC(STOD(AllTrim((cAlias)->Z86_DATA)))
        aJson[nPos]['Z86_HORA'] := (cAlias)->Z86_HORA
        aJson[nPos]['Z87_LIDO'] := ((cAlias)->Z87_LIDO = "T")

        (cAlias)->(DbSkip())
    EndDo
    
    wrk := JsonObject():new()
    wrk:set(aJson)

    ::SetResponse(EncodeUTF8(wrk:toJSON(), "cp1252"))

    (cAlias)->(dbCloseArea())
    RestArea(aArea)
Return(.T.)


WSMETHOD PUT WSRECEIVE COD WSSERVICE NOTIFICACAO
    Local cCod := Self:COD
    Local aArea := GetArea()
    Local aJson := {}
    Local cQuery := ""
    Local cAlias := "Z86"
    Local cAliasNot := "Z87"

    ::SetContentType("application/json")

    If !Empty(Select(cAliasNot))
		DbSelectArea(cAliasNot)
		(cAliasNot)->(dbCloseArea())
	Endif

    DbSelectArea((cAliasNot))
	Z87->(DbSetOrder(1))
	Z87->(DbGoTop())
    If Z87->(DbSeek(xFilial("Z87") + cCod))
        RECLOCK((cAliasNot), .F.)
        (cAliasNot)->Z87_LIDO := .T.
        (cAliasNot)->(MSUNLOCK())
    EndIF

    cQuery	:= "SELECT "
    cQuery	+= "USUARIOS.Z87_COD, "
    cQuery	+= "NOTIFICACOES.Z86_ASSUNT, "
    cQuery	+= "NVL(utl_raw.cast_to_varchar2(NOTIFICACOES.Z86_MENSAG),'') AS Z86_MENSAG, "
    cQuery	+= "USUARIOS.Z87_EMAIL, "
    cQuery	+= "Z86_DATA, "
    cQuery	+= "NOTIFICACOES.Z86_HORA, "
    cQuery	+= "USUARIOS.Z87_LIDO"
	cQuery  += " FROM " +RetSqlName("Z86") + " NOTIFICACOES"
	cQuery  += " INNER JOIN " +RetSqlName("Z87") + " USUARIOS"
	cQuery  += " ON NOTIFICACOES.Z86_COD = USUARIOS.Z87_CODNOT"
	cQuery  += " WHERE USUARIOS.Z87_COD='"+cCod+"'"
	cQuery  += " ORDER BY to_date(NOTIFICACOES.Z86_DATA,'YYYYMMDD') DESC, NOTIFICACOES.Z86_HORA DESC"

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

        aJson[nPos]['Z86_ASSUNT'] := AllTrim((cAlias)->Z86_ASSUNT)
        aJson[nPos]['Z86_MENSAG'] := AllTrim((cAlias)->Z86_MENSAG)
        aJson[nPos]['Z87_EMAIL'] := AllTrim((cAlias)->Z87_EMAIL)
        aJson[nPos]['Z86_DATA'] := DTOC(STOD(AllTrim((cAlias)->Z86_DATA)))
        aJson[nPos]['Z86_HORA'] := (cAlias)->Z86_HORA
        aJson[nPos]['Z87_LIDO'] := ((cAlias)->Z87_LIDO = "T")

        (cAlias)->(DbSkip())
    EndDo
    
    wrk := JsonObject():new()
    wrk:set(aJson)

    ::SetResponse(EncodeUTF8(wrk:toJSON(), "cp1252"))

    (cAliasNot)->(dbCloseArea())
    (cAlias)->(dbCloseArea())
    RestArea(aArea)
Return(.T.)
