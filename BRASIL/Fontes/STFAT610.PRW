#INCLUDE "TOTVS.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT610        | Autor | RENATO.OLIVEIRA           | Data | 02/10/2022  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                    |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT610(_cTipo)

Local cAmbiente := GETNewPar("ST_NECTAR1",'3') // 1-Produção;2-Homologação;3-Desenvolvimento
Local cXguid 	:= ""
Local aHeadOut 	:= {}
Local cHeadRet  := ""

If !cEmpAnt=="11"
	Return
EndIf

IF cAmbiente == '1'   // produção
	_cUrlEnt    := "https://steck.crm2.dynamics.com"
ELSEIF cAmbiente == '2' // homologação
	_cUrlEnt := "https://steckhml.crm2.dynamics.com"
ELSEIF cAmbiente == '3' // desenvolvimento
	_cUrlEnt := "https://steckdev.crm2.dynamics.com"
ENDIF


If _cTipo=="1" //Orçamento

	If Empty(SUA->UA_XGUID)
		Return()
	EndIf

	cXguid := AllTrim(SUA->UA_XGUID)

	oJson := U_STFAT611()

	IF !Empty(oJson)

		_cJsonEnv := "{"
		_cJsonEnv += '"nec_statusorcamento": 2' // 1- Bloqueado; 2- Liberado; 3- Cancelado
		_cJsonEnv += "}"

		// Carregando informações para Registrar KeyAccess
		cTokenBare    := oJson:TOKEN_TYPE
		cACCESS_TOKEN := oJson:ACCESS_TOKEN
		cEXPIRES_IN   := oJson:EXPIRES_IN
		cRESOURCE     := oJson:RESOURCE // "https://steckdev.crm2.dynamics.com/"
		
		//// Executando Metodo PATCH
		AADD( aHeadOut,"Content-Type: application/json; charset=utf-8")
		AADD( aHeadOut,"Authorization: Bearer " + cACCESS_TOKEN  )

		_cPath 		:= "/api/data/v9.2/quotes(" + cXguid + ")"
		cGETParms 	:= ""
		nTimeOut  	:= 60

		cResponse := HTTPQuote( _cUrlEnt+_cPath , "PATCH" , cGETParms, _cJsonEnv, nTimeOut, aHeadOut, @cHeadRet )

		Conout(cResponse)

	EndIf

EndIf

Return()


/*/{Protheus.doc} LoginNectar
description
Rotina que fará o login para acessar Dynamics da Nectar
@type function
@version  1.00
@author Valdemir Jose / adaptado por Flávia Rocha
@since 19/04/2021
@return return_type, return_description
/*/
User Function STFAT611()
/*
TenantID: 2422a1cd-474b-4d91-965a-59ea2dc1a9c8
Cliente_id: e4cf112c-5dd3-4bd2-93aa-89c51478f266
Cliente_secret: 02vMHP1-X0WESfD.7wt77u-Yzt_gCfU0.6
Resource: https://steckdev.crm2.dynamics.com/
*/
LOCAL oRet := NIL
LOCAL _lRet := .F.
LOCAL cAmbiente := GETNewPar("ST_NECTAR2",'3')				// 1-Produção;2-Homologação;3-Desenvolvimento
LOCAL nTimeOut 	:= 60
LOCAL aHeadOut 	:= {}
LOCAL cHeadRet 	:= ""
LOCAL sPostRet  := ""
LOCAL _cUrl 		:= ""
LOCAL _xJson		:= ""
LOCAL cResource := ""

//_cUrlHml += _cHmlID + _cUrl2  // "https://login.microsoftonline.com/{{TenantID}}/oauth2/token"
//concatenando:
//                "https://login.microsoftonline.com/"+   {{TenantID}}						   + "/oauth2/token"
//ficando assim: "https://login.microsoftonline.com/" + "2422a1cd-474b-4d91-965a-59ea2dc1a9c8" + "/oauth2/token"
//                https://login.microsoftonline.com/2422a1cd-474b-4d91-965a-59ea2dc1a9c8/oauth2/token
// Efetuando o Login

/*
aAdd( aHeadOut,"grant_type:" 	+ "client_credentials" )
aAdd( aHeadOut,"client_id:" 	+ cClientID )
aAdd( aHeadOut,"client_secret:" + cCliSecre )
aAdd( aHeadOut,"resource:" 		+ cResource )
*/

//FR - Alteração - Em 11/05 Vanderlei da Nectar passou esses novos ID's para acesso de obter token, então coloquei via parâmetro:
cClientID := AllTrim(GetNewPar("ST_NECTAR3" , "d0208216-6fc6-4174-97bc-96916daeeb4e"))
cCliSecre := AllTrim(GetNewPar("ST_NECTAR4" , "97D8Q~SOoQ4BXWhydmkvlLaWcyhpKJcrdjaoxdqk"))

If cAmbiente == '1'  //produção
	cResource := "https://steck.crm2.dynamics.com"
Elseif cAmbiente == '2'	//homologação
	cResource := "https://steckhml.crm2.dynamics.com"
Elseif cAmbiente == '3' //desenvolvimento
	cResource := "https://steckdev.crm2.dynamics.com"
Endif
_cUrl := "https://login.microsoftonline.com/2422a1cd-474b-4d91-965a-59ea2dc1a9c8/oauth2/token"


// Efetuando o Login
AADD(aHeadOut,"grant_type:client_credentials")
AADD(aHeadOut,"client_id:"+cClientID )
AADD(aHeadOut,"client_secret:"+cCliSecre )
If cAmbiente == '1'  //produção
	AADD(aHeadOut,"resource:https://steck.crm2.dynamics.com/" )
ELSE
	AADD(aHeadOut,"resource:https://steckdev.crm2.dynamics.com/" )
ENDIF

//qdo concatenar utilizar & no final de cada string:
_xJson := 'grant_type=client_credentials&'
_xJson += 'client_id='+cClientID+'&' 	+ Chr(13) + Chr(10)
_xJson += 'client_secret='+cCliSecre+'&' 	+ Chr(13) + Chr(10)
_xJson += 'resource=' + cResource
sPostRet := HttpPost(_cUrl,,_xJson, nTimeOut, aHeadOut, @cHeadRet)
_lRet := FWJsonDeserialize(sPostRet, @oRet)

/*
client_id=535fb089-9ff3-47b6-9bfb-4f1264799865
&scope=https%3A%2F%2Fgraph.microsoft.com%2F.default
&client_secret=sampleCredentia1s
&grant_type=client_credentials
*/
IF EMPTY(sPostRet)
	CONOUT("[STCRM007] [LogimNectar] Falha ao conectar com servidor NecTar")
	oRet := NIL
ENDIF

RETURN oRet

/*====================================================================================\
|Programa  | STFAT612        | Autor | RENATO.OLIVEIRA           | Data | 02/10/2022  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                    |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT612()

Local cAmbiente := GETNewPar("ST_NECTAR1",'3') // 1-Produção;2-Homologação;3-Desenvolvimento
Local cXguid 	:= ""
Local aHeadOut 	:= {}
Local cHeadRet  := ""

	IF cAmbiente == '1'   // produção
		_cUrlEnt    := "https://steck.crm2.dynamics.com"
	ELSEIF cAmbiente == '2' // homologação
		_cUrlEnt := "https://steckhml.crm2.dynamics.com"
	ELSEIF cAmbiente == '3' // desenvolvimento
		_cUrlEnt := "https://steckdev.crm2.dynamics.com"
	ENDIF

	cXguid := AllTrim(SUA->UA_XGUID)

	oJson := U_STFAT611()

	IF !Empty(oJson)

		_cJsonEnv := "{"
		_cJsonEnv += '"nec_codigopedido": "'+AllTrim(SUA->UA_NUMSC5)+'"
		_cJsonEnv += "}"

		// Carregando informações para Registrar KeyAccess
		cTokenBare    := oJson:TOKEN_TYPE
		cACCESS_TOKEN := oJson:ACCESS_TOKEN
		cEXPIRES_IN   := oJson:EXPIRES_IN
		cRESOURCE     := oJson:RESOURCE // "https://steckdev.crm2.dynamics.com/"
		
		//// Executando Metodo PATCH
		AADD( aHeadOut,"Content-Type: application/json; charset=utf-8")
		AADD( aHeadOut,"Authorization: Bearer " + cACCESS_TOKEN  )

		_cPath 		:= "/api/data/v9.2/quotes(" + cXguid + ")"
		cGETParms 	:= ""
		nTimeOut  	:= 60

		cResponse := HTTPQuote( _cUrlEnt+_cPath , "PATCH" , cGETParms, _cJsonEnv, nTimeOut, aHeadOut, @cHeadRet )

		Conout(cResponse)

	EndIf

Return()
