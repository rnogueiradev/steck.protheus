#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STMKP050        | Autor | RENATO.OLIVEIRA           | Data | 30/03/2020  |
|=====================================================================================|
|Descrição | Rotina criada para baixar os pedidos pendentes de pagamento              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STMKP050()

	Local _cAlias1 		:= ""
	Local _aHeadOut 	:= {}
	Local _nTimeOut 	:= 60
	Local _cHeadRet 	:= ""
	Local _cUrl			:= ""
	Local oRestClient
	Local _aRet			:= {}
	Local _nY
	Local _nX

	//RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")

	If !LockByName("STMKP050",.F.,.F.,.T.)
		ConOut("[STMKP050]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	DbSelectArea("SC5")
	SC5->(DbOrderNickName("STWEBPED"))
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	DbSelectArea("PA2")
	PA2->(DbSetOrder(2)) //PA2_FILIAL+PA2_TIPO+PA2_DOC+PA2_CODPRO+PA2_FILRES

	_cEmail := GetMv("STMKP0501",,"renato.oliveira@steck.com.br")

	_cAlias1 := GetNextAlias()

	_cToken := AllTrim(GetMv("ST_TOKPREC",,"dFA2M0dXWUxzVklOSWljTDY6"))
	_cUrl	:= AllTrim(GetMv("ST_URLPREC",,"https://www.replicade.com.br/api/v1"))
	//_cUrl   += "erp/novo

	ConOut("[STMKP050]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	aAdd( _aHeadOut , "Authorization: Basic "+_cToken)
	aAdd( _aHeadOut , "Content-Type: application/json; charset=utf-8")

	_aProc := {}
	_lRet  := .F.

	oRestClient   := FWRest():New(_cUrl)
	oRestClient:setPath("/erp/novo")
	oRestClient:nTimeOut := 600
	If oRestClient:Get(_aHeadOut)
		oInfo 	  	:= ""
		_lRet     	:= FWJsonDeserialize(oRestClient:GetResult(),@oInfo)
	Else
		AADD(_aRet,{"","Erro de chamada do REST: "+AllTrim(oRestClient:GetLastError()),"ERRO"})
		AADD(_aProc,_aRet)
	EndIf

	If _lRet
		_nPags := oInfo:PAGINAS
		FreeObj(oRestClient)
		FreeObj(oInfo)
		For _nX:=1 To _nPags
			oRestClient   := FWRest():New(_cUrl+"/"+cValToChar(_nX))
			oRestClient:nTimeOut := 600
			If oRestClient:Get(_aHeadOut)
				If FWJsonDeserialize(oRestClient:GetResult(),@oInfo)
					If Type("oInfo:PEDIDO")=="A"
						For _nY:=1 To Len(oInfo:PEDIDO)
							_aRet := PROCESSAR(oInfo:PEDIDO[_nY])
							AADD(_aProc,_aRet)
						Next
					EndIf
				EndIf
			EndIf
			FreeObj(oRestClient)
			FreeObj(oInfo)
		Next
	Else
		AADD(_aRet,{"","Erro de conversão do retorno JSON","ERRO"})
		AADD(_aProc,_aRet)
	EndIf

	cMsg := ""
	cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>
	cMsg += '<TR BgColor=#FFFFFF>
	cMsg += '<TD><B><Font Color="black" Size="3" Face="Arial">Pedido</Font></B></TD>
	cMsg += '<TD><B><Font Color="black" Size="3" Face="Arial">Mensagem</Font></B></TD>
	cMsg += '<TD><B><Font Color="black" Size="3" Face="Arial">Status</Font></B></TD>
	cMsg += '</TR>

	For _nX:=1 To Len(_aProc)

		_cColor := "white"

		If AllTrim(_aProc[_nX][1][3])=="ERRO"
			cMsg += '<TR BgColor=#FF0000>
			_cColor := "white"
		Else
			cMsg += '<TR BgColor=#00FF00>
			_cColor := "black"
		EndIf

		cMsg += '<TD><B><Font Color="'+_cColor+'" Size="3" Face="Arial">'+AllTrim(_aProc[_nX][1][1])+'</Font></B></TD>
		cMsg += '<TD><B><Font Color="'+_cColor+'" Size="3" Face="Arial">'+AllTrim(_aProc[_nX][1][2])+'</Font></B></TD>
		cMsg += '<TD><B><Font Color="'+_cColor+'" Size="3" Face="Arial">'+AllTrim(_aProc[_nX][1][3])+'</Font></B></TD>
		cMsg += '</TR>

	Next

	cMsg += '</body></html>'

	_cEmail := GetMv("STMKP0501",,"renato.oliveira@steck.com.br")

	If Len(_aProc)>0
		U_STMAILTES(_cEmail,"","[MKP] - Resumo de processamento dos pedidos pendentes",cMsg,{},"")
	EndIf

	UnLockByName("STMKP050",.F.,.F.,.T.)

	ConOut("[STMKP050]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()

/*====================================================================================\
|Programa  | PROCESSAR       | Autor | RENATO.OLIVEIRA           | Data | 06/03/2020  |
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

Static Function PROCESSAR(_oPedido)

	Local _aRet 	:= {}
	Local aCabec	:= {}
	Local aItens	:= {}
	Local _nX
	Private lMsErroAuto  := .F.

	//Verificar se pedido existe
	If SC5->(DbSeek(xFilial("SC5")+"2"+cValToChar(_oPedido:CODIGOPEDIDO)))
		AADD(_aRet,{cValToChar(_oPedido:CODIGOPEDIDO),"Pedido já incluído.","ERRO"})
		Return(_aRet)
	EndIf

	For _nX:=1 To Len(_oPedido:ITENS)

		If !SB1->(DbSeek(xFilial("SB1")+_oPedido:ITENS[_nX]:REFERENCIALOJA))
			AADD(_aRet,{cValToChar(_oPedido:CODIGOPEDIDO),"Produto "+_oPedido:ITENS[_nX]:REFERENCIALOJA+" não encontrado!","ERRO"})
			Return(_aRet)
		EndIf

		//PA2_FILIAL+PA2_TIPO+PA2_DOC+PA2_CODPRO+PA2_FILRES
		If !PA2->(DbSeek(xFilial("PA2")+"1"+PADR("MKP"+cValToChar(_oPedido:CODIGOPEDIDO),TamSx3("PA2_DOC")[1])+SB1->B1_COD+cFilAnt))
			U_STReserva("MKP"+cValToChar(_oPedido:CODIGOPEDIDO),SB1->B1_COD,_oPedido:ITENS[_nX]:QUANTIDADE,"+",cFilAnt)
		EndIf

	Next

	AADD(_aRet,{cValToChar(_oPedido:CODIGOPEDIDO),"Pedido reservado com sucesso","OK"})

Return(_aRet)