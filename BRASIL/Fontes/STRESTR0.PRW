#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'
#include "Fileio.ch"

/*====================================================================================\
|Programa  | STRESTR0        | Autor | RENATO.OLIVEIRA           | Data | 22/08/2021  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
// http://rest-p12.steck.com.br:9997/rest/strestr0 -> homologação
// rest-p12.steck.com.br:9997/rest/strestr0?cOrc=759305  passar como parâmetro o número do orçamento

WSRESTFUL STRESTR0 DESCRIPTION "Retornar orçamento em pdf"

WSDATA cOrc As String

WSMETHOD Get DESCRIPTION "Retornar orçamento em pdf" WSSYNTAX "/rest/strestr0"

END WSRESTFUL

WSMETHOD Get WSRECEIVE cOrc WSSERVICE strestr0

	Local cResp 	:= ""
	Local aFiles := {}
	Local aSizes := {}
	Local _cJsonRet := '{"pdf":"
    Local _cRetorno := ""
    Local cMsg      := ""
    Local cZZIBlq   := ""
	Local cPedVen   := ""
	Local cOrc		:= ""

	::SetContentType("application/json")

	cOrc := Alltrim(Self:cOrc)
	
	
	If Empty(cOrc)
		_cRetorno := '{"CODRET":"99","DESCRET":"ORCAMENTO VAZIO"}'
		::SetResponse(_cRetorno)
		Return .T.
	Endif

	DbSelectArea("SUA")
	SUA->(DbSetOrder(1)) 

	//If SUA->(DbSeek(xFilial("SUA")+Self:cOrc))
	If SUA->(DbSeek(xFilial("SUA")+cOrc))

		//ver bloqueio de orçamento: 
        If SUA->UA_XBLOQ == "1"
		    cMsg := "O orcamento encontra-se bloqueado e portanto nao sera possivel enviar o relatorio de Cotacao ao Cliente."
		    cMsg += " Entre em contato com seu supervisor para que o mesmo libere este Orcamento!"

            _cRetorno := '{"CODRET":"99","DESCRET":"ORCAMENTO BLOQUEADO: ' + cMsg + '"}'
		    ::SetResponse(_cRetorno)
		    Return .T.
		
		Else

			//ver se a alçada tem bloqueio
			DbSelectArea('ZZI')
			ZZI->(DbGoTop())
			ZZI->(DbSetOrder(3))
			If ZZI->(DbSeek(xFilial("ZZI")+SUA->UA_NUM))
				cZZIBlq := ZZI->ZZI_BLQ
				//If ZZI->ZZI_BLQ = '2'.Or. ZZI->ZZI_BLQ = '3'
				If cZZIBlq = '2' .Or. cZZIBlq = '3'

					cMsg := "O orcamento encontra-se bloqueado e portanto nao sera possivel enviar o relatorio de Cotacao ao Cliente."
		    		cMsg += " Entre em contato com seu supervisor para que o mesmo libere este Orcamento!"

            		_cRetorno := '{"CODRET":"99","DESCRET":"ORCAMENTO BLOQUEADO: ' + cMsg + '"}'
		    		::SetResponse(_cRetorno)
		    		Return .T.

				EndIf
			
			Endif

			//ver se tem pedido de venda
			cPedVen := SUA->UA_NUMSC5
			//If SUA->UA_NUMSC5 <> ' '
			If !Empty(cPedVen) 
				/*Comentado para chamar a impressão do pedido de vendas caso já exista o pedido.
				cMsg := "O orcamento em questao ja foi convertido em Pedido de Venda."
				cMsg += " Favor acessar o modulo Faturamento e realize a impressao do Pedido de Venda emitido!"
			
				_cRetorno := '{"CODRET":"99","DESCRET":"ORCAMENTO COM PEDIDO VENDA: ' + cMsg + '"}'
				::SetResponse(_cRetorno)
				Return .T.
				*/
			Endif 
			
		EndIf	

		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		If SA1->(DbSeek(xFilial("SA1")+SUA->(UA_CLIENTE+UA_LOJA)))
			_cArq := U_RSTFAT11(.T.)			
		EndIf
        
	EndIf

	ADir(_cArq, aFiles, aSizes)//Verifica o tamanho do arquivo, parâmetro exigido na FRead.

	nHandle := fopen(_cArq , FO_READWRITE + FO_SHARED )
	cString := ""
	FRead( nHandle, cString, aSizes[1] ) //Carrega na variável cString, a string ASCII do arquivo.

	cTexto := Encode64(cString) //Converte o arquivo para BASE64

	fclose(nHandle)

	_cJsonRet += cTexto+'"}'
	//_cJsonRet := cTexto

	::SetResponse(_cJsonRet)

Return .T.
