#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"

/*/{Protheus.doc} WSINTVEF
@name WSINTVEF
@type User Function
@desc estrutura de integra��o com a VEF
@author Renato Nogueira
@since 17/05/2018
/*/

WSSERVICE WSINTVEF DESCRIPTION "Servi�o para realizar integra��o com plataforma VEF"

	WSDATA cXmlEnv			AS STRING
	WSDATA cXmlRet			AS STRING

	WSMETHOD ConsultaEstoque DESCRIPTION "M�todo para realizar consulta de estoque"

ENDWSSERVICE

WSMETHOD ConsultaEstoque WSRECEIVE cXmlEnv WSSEND cXmlRet WSSERVICE WSINTVEF

	::cXmlRet := U_STESTA05(::cXmlEnv)

Return .T.