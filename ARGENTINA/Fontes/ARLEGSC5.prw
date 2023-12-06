#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | ARLEGSC5        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|DescriГЦo | AVALIA PEDIDO E AJUSTA LEGENDA			                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................HistСrico....................................|
\====================================================================================*/

User Function ARLEGSC5(_cFilial,_cPedido)

	Local _cQuery1 	:= ""
	Local _cAlias1 	:= GetNextAlias()
	Local _cQuery2 	:= ""
	Local _cAlias2 	:= GetNextAlias()
	
	Local _aAreaSC5 := SC5->(GetArea())

	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := ""
	Local cMsg		  := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local _cEmailV	:= ""
	Local _aMsg    	:={}
	Local _nLin
	Local cFuncSent	:= "ARLEGSC5"

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbGoTop())
	If !SC5->(DbSeek(_cFilial+_cPedido))
		Return
	EndIf

	_cQuery1 := " SELECT COUNT(*) CONTADOR
	_cQuery1 += " FROM "+RetSqlName("SC9")+" C9
	_cQuery1 += " WHERE C9.D_E_L_E_T_=' ' AND C9_FILIAL='"+_cFilial+"' 
	_cQuery1 += " AND C9_PEDIDO='"+_cPedido+"' AND C9_BLCRED<>' ' AND C9_NFISCAL=' '

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	SC5->(RecLock("SC5",.F.))

	If (_cAlias1)->CONTADOR>0
		SC5->C5_XSTAFIN := "B"

	_cQuery2 := " SELECT SUM(C6_VALOR) TOTAL
	_cQuery2 += " FROM "+RetSqlName("SC6")+" C6
	_cQuery2 += " WHERE C6.D_E_L_E_T_=' ' AND C6_FILIAL='"+_cFilial+"' 
	_cQuery2 += " AND C6_NUM ='"+_cPedido+"'

	If !Empty(Select(_cAlias2))
		DbSelectArea(_cAlias2)
		(_cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbGoTop())

		
		_cAssunto := "[WFPROTHEUS] - Pedido "+AllTrim(SC5->C5_NUM)+" con bloqueo de credito"

		Aadd( _aMsg , { "Pedido: "          , SC5->C5_NUM } )
		Aadd( _aMsg , { "Cliente - Loja: "  , SC5->C5_CLIENTE+' - '+SC5->C5_LOJACLI } )
		Aadd( _aMsg , { "Nome Cliente: "    , substr(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"),1,35)  } )
		Aadd( _aMsg , { "Total USD: "    	, TransForm((_cAlias2)->TOTAL, "@E 999,999,999,999.99") } )

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
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
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

		_cEmail := GetMv("ST_LIBCRED",,"everson.santana@steck.com.br")

		U_ARMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

	Else
		SC5->C5_XSTAFIN := ""
	EndIf

	SC5->(MsUnLock())

	RestArea(_aAreaSC5)

Return