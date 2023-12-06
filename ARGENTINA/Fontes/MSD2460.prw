#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

User function MSD2460()

	If SD2->D2_QUANT = 0

		MSGALERT( "Hay artМculos con cantidad cero.","AtenciСn"  )

		ARWFRE()

	EndIf

Return


Static Function ARWFRE()

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local cFuncSent:= "ARWFRE"
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
	Local _aMsg    :={}	
	Local _cAssunto := "Itens Faturados com Quantidade Zero Argentina"
	Local _cEmail 	:= "everson.santana@steck.com.br;Renato.Oliveira@steck.com.br"
	Local _cCopia	:= ""

	Aadd( _aMsg , { "Documento: "       , SD2->D2_DOC 	} )
	Aadd( _aMsg , { "Item: "    		, SD2->D2_ITEM 	} )
	Aadd( _aMsg , { "Produto: "    		, SD2->D2_COD  	} )
	Aadd( _aMsg , { "Cliente: "    		, SD2->D2_XNOME } )

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do cabecalho do email                                             Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do texto/detalhe do email                                         Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf

			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		U_ARMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)

	EndIf
	RestArea(aArea)
Return()
