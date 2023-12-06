#include 'Protheus.ch'
#include 'RwMake.ch'
#DEFINE CR    chr(13)+chr(10)
/*====================================================================================\
|Programa  | FT080GRV          | Autor | GIOVANI.ZAGO             | Data | 30/10/2014 |
|=====================================================================================|
|DescriГЦo | FT080GRV                                                                 |
|          |  																	      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | FT080GRV                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................HistСrico....................................|
\====================================================================================*/
*----------------------------------*
User Function FT080GRV(_nOpc)
*----------------------------------*

	STDESMAIL('','',cusername,dtoc(date()),time(),' ')



Return ()


/*====================================================================================\
|Programa  | STCAMMAIL        | Autor | GIOVANI.ZAGO             | Data | 14/08/2014  |
|=====================================================================================|
|DescriГЦo | STCAMMAIL                                                                |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STCAMMAIL                                                                |
|=====================================================================================|
|Uso       | EspecIfico STECK                                                         |
|=====================================================================================|
|........................................HistСrico....................................|
\====================================================================================*/
*------------------------------------------------------------------*
Static Function  STDESMAIL(_cObs,_cMot,_cName,_cDat,_cHora,_cEmail)
*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= 'Cadastro de Desconto: Regra: '+ACO->ACO_CODREG 
	Local cFuncSent:= "STDESMAIL"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ""
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
	default _cEmail  := ""

	_cEmail   := Alltrim(Posicione("SA3",1,xFilial("SA3")+Posicione("SA1",1,xFilial("SA1")+ACO->ACO_CODCLI+ACO->ACO_LOJA,"A1_VEND")  ,"A3_EMAIL"))
	_cEmaSup  := Alltrim(Posicione("SA1",1,xFilial("SA1")+ACO->ACO_CODCLI+ACO->ACO_LOJA,"A1_VEND"))
	_cEmaSup  := Alltrim(Posicione("SA3",1,xFilial("SA3")+_cEmaSup  ,"A3_SUPER"))
	_cEmaSup  := Alltrim(Posicione("SA3",1,xFilial("SA3")+ _cEmaSup ,"A3_EMAIL"))

	If !Empty(Alltrim(_cEmaSup))
		_cEmail:= _cEmail+" ; "+_cEmaSup
	EndIf
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
	
		Aadd( _aMsg , { "Cod.Regra: "       , ACO->ACO_CODREG   } )
		Aadd( _aMsg , { "DescriГЦo : "  	, ACO->ACO_DESCRI} )
		Aadd( _aMsg , { "Cliente : "    	, ACO->ACO_CODCLI+'/'+ACO->ACO_LOJA+' - '+ Posicione("SA1",1,xFilial("SA1")+ACO->ACO_CODCLI+ACO->ACO_LOJA,"A1_NOME")} )
		Aadd( _aMsg , { "Data: "    		, _cDat  } )
		Aadd( _aMsg , { "Usuario: "    		, _cName } )
		Aadd( _aMsg , { "Hora: "    		, _cHora } )
	
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Definicao do cabecalho do email                                             Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
	//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
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
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
	
		cMsg += '<TR BgColor=#B0E2FF>'
	
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"> ITEM </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial"> PRODUTO </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"> DESCRIгцO </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial"> GRUPO </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"> DESC.GRUPO </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"> %DESC. </Font></TD>'
		cMsg += '</TR>'
	
		DbSelectArea("ACP")
		ACP->(DbSetOrder(1))
		If ACP->(DbSeek(xFilial("ACO")+ACO->ACO_CODREG))
			While ACP->(!Eof() .and. ACP_FILIAL+ACP->ACP_CODREG == xFilial("ACO")+ACO->ACO_CODREG)
				_nCam++
				IF (_nCam/2) == Int( _nCam/2 )
					cMsg += '<TR BgColor=#B0E2FF>'
				Else
					cMsg += '<TR BgColor=#FFFFFF>'
				EndIF
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + ACP->ACP_ITEM + ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + ACP->ACP_CODPRO + ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + Posicione("SB1",1,xFilial("SB1")+ACP->ACP_CODPRO,"B1_DESC")+ ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + ACP->ACP_GRUPO + ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + POSICIONE("SBM",1,XFILIAL("SBM")+ACP->ACP_GRUPO,"BM_DESC") + ' </Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + Transform(ACP->ACP_PERDES,"@E 99.99")   + ' </Font></TD>'
				cMsg += '</TR>'
			
				ACP->(DbSkip())
			End
		Endif
	
	
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Definicao do rodape do email                                                Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
	//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
	//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'
	
	
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)
	 
	EndIf
	RestArea(aArea)
Return()



