#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "Protheus.ch"
#Include "TOPCONN.CH"
#Include "RWMAKE.CH"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#Include "topconn.ch"




/*/{Protheus.doc} USolucoes
Classe com metodos referente a Unica Solucoes
@type class
@version  12.1.33
@author valdemir rabelo
@since 15/09/2022
/*/
Class USolucoes
    data userName as string
    data password as string
    data grant_type
    data token as string

    Method New(cUserName, cPassword)
    Method Login(cURL)
    Method ConfirmacaoPedido(cJson)
    Method AgendamentoEntrega(cJson)
EndClass


Method New(cUserName, cPassword) Class USolucoes
    Local _HostPrd := AllTrim(SuperGetMV("MV_GTUSHST", .F., "https://api.unicasolucoes.com.br/uniconvert/api/token"))
    Local _HostTst := "https://api_tst.unicasolucoes.com.br/uniconvert/api/token"
    Local _AtiHost := GetMV("FS_PRDSOLU",.F.,.F.)
    Local _cHost   := IIF(_AtiHost, _HostPrd, _HostTst) 

    self:userName   := cUserName
    self:password   := cPassword
    self:grant_type := "password"
    self:token      := ::Login(_cHost)
Return



/*/{Protheus.doc} USolucoes::Login
Metodo para Retorno do Token por
tempo limitado
@type method
@version  12.1.33
@author valde
@since 19/09/2022
@param cURL, character, URL para Acesso
@return variant, Retorna Token para ativação
/*/
Method Login(cURL) Class USolucoes

    Local cToken    := ""
    Local aHeadOut  := {}
    Local cJson     := ""
    Local cAviso    := ""

    aadd(aHeadOut,'Content-Type: application/x-www-form-urlencoded')
    aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus ' + GetBuild() )

    cJson := "userName=" + self:userName
    cJson += "&password=" + self:password
    cJson += "&grant_type=" + self:grant_type

    xRetWs := HttpPost(cURL, "", cJson, 120, aHeadOut, @cAviso)

    If xRetWs != Nil
        oJson := JsonObject():New()
        oJson:fromJSON(xRetWs)
        cToken := oJson['access_token']
    EndIf

Return cToken


/*/{Protheus.doc} USolucoes::ConfirmacaoPedido
Metodo para Confirmação de Pedido
@type method
@version  12.1.33
@author valdemir rabelo
@since 19/09/2022
@param cJson, character, Json de Dados
@return variant, Logico
/*/
Method ConfirmacaoPedido(cJson) Class USolucoes
    Local cURLTST  := "https://api_tst.unicasolucoes.com.br/uniconvert/api/pedidos/poritempedido"
    Local cURLPRD  := AllTrim(GetMV("MV_GTUSHST", .F., "https://api.unicasolucoes.com.br/uniconvert/api/pedidos/poritempedido"))
    Local lPRD     := GetMV("FS_PRDSOLU",.F.,.F.)
    Local cURL     := iif(lPRD, cURLPRD, cURLTST)
    /* Exemplo do json
[
{
"CNPJCliente": "120001230000100",
"CNPJFornecedor": "00123002000100",
"NumeroDocumento": "00004589001",
"NumeroDocumentoVenda": "426355",
"NItemPed": "10",
"DataEntrega": "2022-05-20T00:00:00.00",
"Justificativa": "Item será entregue na data informada",
"Status": "A ou C"
},
{
"CNPJCliente": "120001230000100",
"CNPJFornecedor": "00123002000100",
"NumeroDocumento": "00004589001",
"NumeroDocumentoVenda": "426355",
"NItemPed": "20",
"DataEntrega": "2022-05-20T00:00:00.00",
"Justificativa": "Item será entregue na data informada",
"Status": "A ou C"
}
]
    */
    Post(cJson, cURL, self:token)
Return .T.


/*/{Protheus.doc} USolucoes::AgendamentoEntrega
Metodo para agendamento da entrega
@type method
@version  12.1.33
@author valdemir rabelo
@since 19/09/2022
@param cJson, character, Json de Dados
@return variant, Logico
/*/
Method AgendamentoEntrega(cJson) Class USolucoes
    Local cURLTST  := "https://api_tst.unicasolucoes.com.br/uniconvert/api/pedidos/agendarentrega"
    Local cURLPRD  := AllTrim(GetMV("MV_GTUSHST", .F., "https://api.unicasolucoes.com.br/uniconvert/api/pedidos/agendarentrega"))
    Local lPRD     := GetMV("FS_PRDSOLU",.F.,.F.)
    Local cURL     := iif(lPRD, cURLPRD, cURLTST)
    /*  Exemplo do Json
    {
        "CNPJCliente": "120001230000100",
        "CNPJFornecedor": "00123002000100",
        "NumeroDocumento": "00004589001",
        "NumeroDocumentoVenda": "426355",
        "NItemPed": "10",
        "DataEntrega": "2019-05-20T00:00:00.00",
        "Justificativa": "Pedido será entregue na data informada",
        "Status": "A ou C"
    }*/
    Post(cJson, cURL, self:token)

Return 


/*/{Protheus.doc} Post
Rotina utilizada nos metodos para envio de dados
@type function
@version  12.1.33
@author valdemir rabelo
@since 19/09/2022
@param cJson, variant, Json de Dados
@return variant, Logico
/*/
Static Function Post(cJson as string, cURL as String, cToken)
    Local aHeadOut := {}
    Local cAviso   := ""
    Local xRetWs
    Local nR       := 0
    Local nTotErr  := 0
    Local _cMsgErr := "" //"LOGs ERRO: " + CRLF + CRLF
    Local _cMsgSuc := "" //"LOGs SUCESSO: " + CRLF + CRLF

    aAdd( aHeadOut,"Content-Type: application/json")
    aAdd( aHeadOut,"Authorization: Bearer " + cToken  )

    cJson := EncodeUTF8(cJson)

    xRetWs := HttpPost(cURL, "", cJson, 120, aHeadOut, @cAviso)

    If xRetWs != Nil
        oJson := JsonObject():New()
        oJson:fromJSON(xRetWs)   

        if Len(oJson) > 0
            For nR := 1 to Len(oJson)
                oRET := oJson[nR]
                if !oRET['success']
                    _cMsgErr += 'Numero documento: ' + oRET['NumeroDocumento']+CRLF+'Item:'+oRET['NItemPed']+CRLF+'Mensagem: '+oRET['message']+CRLF+CRLF
                    Conout( _cMsgErr )
                    nTotErr++
                Else
                    _cMsgSuc += 'Numero documento: ' + oRET['NumeroDocumento']+CRLF+'Item:'+oRET['NItemPed']+CRLF+'Mensagem: '+oRET['message']+CRLF+CRLF
                endif 
            Next 
            if nTotErr > 0
               Conout(' Existem ' + CValToChar(nTotErr)+ ' para ser verificado' )
                  RecLock("ZZ6", .F.)
			      ZZ6->ZZ6_JENV := cJson
			      ZZ6->ZZ6_JRET := xRetWs
                  Aviso("PROBLEMA", DecodeUTF8(_cMsgErr), {"Ok"}, 3, , , "BR_VERMELHO") 
                  MsUnlock()
                  _cMsgErr := ""
            else 
               if IsBlind()
                    Conout(' Registros enviados com sucesso: '+CValToChar(Len(oJson)-nTotErr)+' - Erros: '+CValToChar(nTotErr) )
               else 
                    FWMsgRun(,{|| Sleep(3000)},'Informativo',' Registros enviados com sucesso: '+CValToChar(Len(oJson)-nTotErr)+' - Erros: '+CValToChar(nTotErr))
               endif 
               RecLock("ZZ6",.F.)
               ZZ6->ZZ6_STATUS := '5'
			   ZZ6->ZZ6_JENV := cJson
			   ZZ6->ZZ6_JRET := xRetWs
               Aviso("SUCESSO", DecodeUTF8(_cMsgSuc), {"Ok"}, 3, , , "BR_AZUL") //FWAlertSuccess(DecodeUTF8(_cMsgSuc))
               MsUnlock()
               _cMsgSuc := ""
            endif 
        Endif 
    EndIf

    FREEOBJ( oJson )

Return 





// Testa API
user function GetTok3()
    Local cRET           := ""
    Local _cHost         := AllTrim(SuperGetMV("MV_GTUSHST", .F., "https://api_tst.unicasolucoes.com.br/uniconvert/api/token"))
    Local _cUser         := Alltrim(SuperGetMV("MV_USERSLU",.F.,"api_steck"))
    Local _cSenha        := Alltrim(SuperGetMV("MV_PSWSLUC",.F.,"api@steck@edi"))
    Local oTESTE := USolucoes():new(_cUser, _cSenha)

    cRET := oTESTE:Login(_cHost)

return cRET 
