#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

Static lPrepEnv := u_xPrepEnv()

/*====================================================================================\
|Programa  | STRESTA0        | Autor | RENATO.OLIVEIRA           | Data | 01/03/2019  |
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

WSRESTFUL setAprovacoes DESCRIPTION "Aplicativo Steck"

WSMETHOD POST DESCRIPTION "Gravar interação nas aprovações" WSSYNTAX "/rest/setAprovacoes"

END WSRESTFUL

WSMETHOD POST WSSERVICE setAprovacoes

	Local cResp 	:= "ERRO"
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _nX 		:= 0
	Local _cUser 	:= __cUserId

	ConOut("[STRESTA0]["+ FWTimeStamp(2) +"] - Usuario "+_cUser+" realizou o acesso.")
	ConOut("[STRESTA0]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	_cAlias1 := GetNextAlias()

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	DbSelectArea("SC1")
	SC1->(DbSetOrder(1))

	Conout(1)

	If _lRet

		Conout(2)

		For _nX:=1 To Len(oInfo:APROVACOES)

			Conout(3)

			_cFilial := SubStr(oInfo:APROVACOES[_nX]:APROVACAO,3,2)
			_cAprov	 := SubStr(oInfo:APROVACOES[_nX]:APROVACAO,6,6)

			Conout(_cFilial)
			Conout(_cAprov)

			If SC1->(DbSeek(_cFilial+_cAprov))

				While SC1->(!Eof()) .And. SC1->(C1_FILIAL+C1_NUM)==_cFilial+_cAprov

					_lGravou	:= .F.

					SC1->(RecLock("SC1",.F.))
					If AllTrim(UsrRetName(_cUser))==AllTrim(SC1->C1_XAPROV1) .And.;
					AllTrim(SC1->C1_ZSTATUS)=="3" .And. Empty(SC1->C1_COTACAO) .And. AllTrim(SC1->C1_XSTAP1)=="P"
						SC1->C1_XDTAP1 := Date()
						SC1->C1_XHRAP1 := Time()
						SC1->C1_XSTAP1 := AllTrim(oInfo:APROVACOES[_nX]:STATUS)
					ElseIf AllTrim(UsrRetName(_cUser))==AllTrim(SC1->C1_XAPROV2) .And.;
					AllTrim(SC1->C1_ZSTATUS)=="3" .And. Empty(SC1->C1_COTACAO) .And. AllTrim(SC1->C1_XSTAP2)=="P"
						SC1->C1_XDTAP2 := Date()
						SC1->C1_XHRAP2 := Time()
						SC1->C1_XSTAP2 := AllTrim(oInfo:APROVACOES[_nX]:STATUS)
					EndIf

					If !Empty(SC1->C1_XSTAP1) .And. !Empty(SC1->C1_XSTAP2)

						If AllTrim(SC1->C1_XSTAP1)=="A" .And. AllTrim(SC1->C1_XSTAP2)=="A"
							SC1->C1_XSTAPRO := "A"
						ElseIf AllTrim(SC1->C1_XSTAP1)=="R" .Or. AllTrim(SC1->C1_XSTAP2)=="R"
							SC1->C1_XSTAPRO := "R"
						ElseIf AllTrim(SC1->C1_XSTAP1)=="P" .Or. AllTrim(SC1->C1_XSTAP2)=="P"
							SC1->C1_XSTAPRO := "P"
						EndIf 

					Else

						If !Empty(SC1->C1_XSTAP1)
							SC1->C1_XSTAPRO := SC1->C1_XSTAP1
						ElseIf !Empty(SC1->C1_XSTAP2)
							SC1->C1_XSTAPRO := SC1->C1_XSTAP2
						EndIf

					EndIf

					SC1->(MsUnLock())

					cResp := 'OK'

					SC1->(DbSkip())
				EndDo

			EndIf

		Next

	Else

		cResp := 'ERRO'

	EndIf

	ConOut("[STRESTA0]["+ FWTimeStamp(2) +"] - Retorno: "+cResp)

	::SetResponse(cResp)

Return .T.
