#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

/*====================================================================================\
|Programa  | STREST20        | Autor | RENATO.OLIVEIRA           | Data | 27/08/2018  |
|=====================================================================================|
|Descrição | ROTINA PARA CONSULTAR PREÇOS 			                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSRESTFUL conspreco DESCRIPTION "Consultar preço dos produtos"

WSDATA cSenha As String
WSDATA cProd As String
WSDATA cCond As String
WSDATA cCnpj As String

WSMETHOD GET DESCRIPTION "Consultar preço de produto" WSSYNTAX "/html-protheus/rest"

END WSRESTFUL

/*====================================================================================\
|Programa  | conspreco      | Autor | RENATO.OLIVEIRA           | Data | 27/08/2018   |
|=====================================================================================|
|Descrição | ROTINA PARA CONSULTAR PREÇO DE PRODUTO	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSMETHOD GET WSRECEIVE cSenha,cProd,cCond,cCnpj WSSERVICE conspreco

	Local cRet 		:= 0
	Local cSenha 	:= Decode64(Self:cSenha)
	Local cProd 	:= Self:cProd
	Local cCond 	:= Self:cCond
	Local cCnpj 	:= Self:cCnpj
	Local _cQuery1  := ""
	Local _cAlias1  := ""

	//::SetContentType("text/html")

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT A1_COD, A1_LOJA
	_cQuery1 += " FROM "+RetSqlName("SA1")+" A1
	_cQuery1 += " WHERE A1.D_E_L_E_T_=' ' AND A1_CGC='"+cCnpj+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		cRet := U_STRETSST("01",(_cAlias1)->A1_COD,(_cAlias1)->A1_LOJA,cProd,cCond,'PRECO')
	EndIf
	
	Conout(cCond)
	Conout(cCnpj)

	::SetResponse(cRet)

Return .T.