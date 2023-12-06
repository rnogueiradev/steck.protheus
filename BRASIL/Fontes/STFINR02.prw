#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFINR02  ºAutor  ³Everson Santana 	 º Data ³  27/02/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Enviar WorkFlow da Posição dos Titulos a Pagar Vencidos    º±±
±±º          ³ 										                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STFINR02()

	Local _cHtml  	:= ""
	Local _cQuery		:= ""
	Local _cTemp		:= ""
	Local _cCopia   	:= ""
	Local _cAssunto 	:= ""
	Local cMsg	    	:= ""
	Local _aAttach  	:= {}
	Local _cCaminho 	:= ''
	Local _cEmail		:= ""
	Local _DtIni
	Local _DtFim
	Local _nX 			:= 0
	Local _aFiliais	:= {}
	Local _nCont		:= 0
	Local _nLin			:= 0
	Local _nPag			:= 0

	OpenSm0()
	dbSelectArea("SM0")
	dbSetOrder(1)
	dbGoTop()

	SET DELETED ON
	
	While SM0->(!EOF())
		If SM0->M0_CODIGO <> '99'

			_nCont := aScan(_aFiliais,{|x|x[1]== UPPER(SM0->M0_CODIGO)})

			If _nCont = 0
				AADD(_aFiliais, { SM0->M0_CODIGO, SM0->M0_CODFIL,SM0->M0_NOME })
			EndIf

		EndIf
		SM0->(dbSkip())
	EndDo
	SET DELETED OFF

	For _nX := 1 To Len(_aFiliais)

		RpcSetType(3)
		RpcSetEnv(_aFiliais[_nX,1], _aFiliais[_nX,2],,'FIN')

		_DtFim	:= DaySub( Date(), 1 )
		_DtIni	:=	MonthSub(_DtFim, 6)

		_cHtml	:= ""
		_nLin	:= 0
		_nPag	:= 1

		_cTemp  := GetNextAlias()
		_cQuery := " SELECT E2_FILIAL,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_EMISSAO,E2_VENCTO,E2_VENCREA,E2_VALOR,E2_SALDO,E2_BAIXA " + CHR(13) + CHR(10)
		_cQuery += " FROM 																	" + CHR(13) + CHR(10)
		_cQuery += 		RetSqlName("SE2") + " SE2										" + CHR(13) + CHR(10)
		_cQuery += " WHERE 																	" + CHR(13) + CHR(10)
		_cQuery += "	E2_VENCREA BETWEEN '"+DtoS(_DtIni)+"' AND '"+DtoS(_DtFim)+"'	" + CHR(13) + CHR(10)
		_cQuery += " 	AND E2_BAIXA = ' ' 											 		" + CHR(13) + CHR(10)
		_cQuery += " 	AND E2_SALDO > 0														" + CHR(13) + CHR(10)
		_cQuery += " 	AND E2_PREFIXO <> 'EIC' 												" + CHR(13) + CHR(10)
		_cQuery += " 	AND E2_FORNECE NOT IN('005866','005764')							" + CHR(13) + CHR(10)
		_cQuery += " 	AND E2_TIPO NOT IN('PA')												" + CHR(13) + CHR(10)
		_cQuery += "  AND E2_NUMBOR = ' '													" + CHR(13) + CHR(10)
		_cQuery += " 	AND D_E_L_E_T_ = ' ' 												" + CHR(13) + CHR(10)
		//_cQuery += " 	AND E2_FILIAL='"+xFilial("SE2")+"'
		_cQuery += " 	ORDER BY E2_FILIAL,E2_VENCREA DESC	 											" + CHR(13) + CHR(10)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cTemp,.T.,.T.)
		dbSelectArea(_cTemp)
		dbGotop()

		_cHtml   += StCab(_aFiliais[_nX,03],_DtIni,_DtFim)

		While !Eof()

			_nLin += 1

			_cHtml   += '                <tr>'
			_cHtml   += '                    <td align="center"><font size="1" face="verdana">'+(_cTemp)->E2_FILIAL+'</font></td>'
			_cHtml   += '                    <td align="center"><font size="1" face="verdana">'+(_cTemp)->E2_FORNECE+'</font></td>'
			_cHtml   += '                    <td align="center"><font size="1" face="verdana">'+(_cTemp)->E2_LOJA+'</font></td>'
			_cHtml   += '                    <td align="left"><font size="1" face="verdana">'+(_cTemp)->E2_NOMFOR+'</font></td>'
			_cHtml   += '                    <td align="center"><font size="1" face="verdana">'+(_cTemp)->E2_PREFIXO+'</font></td>'
			_cHtml   += '                    <td align="center"><font size="1" face="verdana">'+(_cTemp)->E2_NUM+'</font></td>'
			_cHtml   += '                    <td align="center"><font size="1" face="verdana">'+(_cTemp)->E2_PARCELA+'</font></td>'
			_cHtml   += '                    <td align="center"><font size="1" face="verdana">'+(_cTemp)->E2_TIPO+'</font></td>'
			_cHtml   += '                    <td align="center"><font size="1" face="verdana">'+Dtoc(Stod((_cTemp)->E2_EMISSAO))+'</font></td>'
			_cHtml   += '                    <td align="center"><font size="1" face="verdana">'+Dtoc(Stod((_cTemp)->E2_VENCTO))+'</font></td>'
			_cHtml   += '                    <td align="center"><font size="1" face="verdana">'+Dtoc(Stod((_cTemp)->E2_VENCREA))+'</font></td>'
			_cHtml   += '                    <td align="right"><font size="1" face="verdana">'+TRANSFORM((_cTemp)->E2_VALOR,"@E 99999999.99")+'</font></td>'
			_cHtml   += '                    <td align="right"><font size="1" face="verdana">'+TRANSFORM((_cTemp)->E2_SALDO,"@E 99999999.99")+'</font></td>'
			_cHtml   += '                </tr>'

			If _nLin > 700

				//>> Rodape
				_cHtml  += '            </table>'
				_cHtml  += '</form>'
				_cHtml  += '</body>'
				_cHtml  += '</html>'

				_cEmail		:=  GetMv("ST_TITVEN",,"")
				_cAssunto := 'Posição de Titulos a Pagar - '+Alltrim(_aFiliais[_nX,03])+" - Pagina "+Alltrim(StrZero(_nPag,2))
				cMsg 	  := _cHtml

				If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
					VtAlert("Problemas no envio de email!")
				EndIf

				//<<
				_nPag += 1
				cMsg 	  := ""
				_cHtml	  := ""

				_cHtml   += StCab(_aFiliais[_nX,03],_DtIni,_DtFim)

				_nLin := 0

			EndIf

			dbSelectArea(_cTemp)
			dbSkip()
		End

		_cHtml  += '            </table>'
		_cHtml  += '</form>'
		_cHtml  += '</body>'
		_cHtml  += '</html>'

		dbSelectArea(_cTemp)
		(_cTemp)->(dbCloseArea())

		_cEmail		:= GetMv("ST_TITVEN",,"")
		_cAssunto := 'Posição de Titulos a Pagar - '+Alltrim(_aFiliais[_nX,03])+" - Pagina "+Alltrim(StrZero(_nPag,2))
		cMsg 	  := _cHtml
		_nPag := 0
		_nLin := 0
		If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
		VtAlert("Problemas no envio de email!")
		EndIf

		RpcClearEnv()

	Next _nX
Return


Static Function StCab(cVar,_DtIni,_DtFim)

	Local _cHtml  	:= ""

	_cHtml   := ""
	_cHtml  += '<html>'
	_cHtml  += '<form action="mailto:%WFMailTo%" method="POST"'
	_cHtml  += 'name="FrontPage_Form1">'
	_cHtml  += '    <table border="0" >'
	_cHtml  += '                <tr>'
	_cHtml  += '                    <td colspan="13" width="630" bgcolor="#DFEFFF"'
	_cHtml  += '                    height="24"><p align="center"><font size="4"'
	_cHtml  += '                    face="verdana"><b>'+cVar+'</b></font></p>'
	_cHtml  += '                    </td>'
	_cHtml  += '                </tr>'
	_cHtml  += '                <tr>'
	_cHtml  += '                    <td colspan="13" width="630" bgcolor="#DFEFFF"'
	_cHtml  += '                    height="24"><p align="center"><font size="4"'
	_cHtml  += '                    face="verdana"><b>Posição de Titulos a Pagar de '+DtoC(_DtIni)+' ate '+DtoC(_DtFim)+'</b></font></p>'
	_cHtml  += '                    </td>'
	_cHtml  += '                </tr>'
	_cHtml  += '                <tr>'
	_cHtml  += '                    <td align="center" width="60"  bgcolor="#DFEFFF" height="18"><font face="verdana">Filial</font></td>'
	_cHtml  += '                    <td align="center" width="60"  bgcolor="#DFEFFF" height="18"><font face="verdana">Codigo</font></td>'
	_cHtml  += '                    <td align="center" width="60"  bgcolor="#DFEFFF" height="18"><font face="verdana">Loja</font></td>'
	_cHtml  += '                    <td align="center" width="200"  bgcolor="#DFEFFF" height="18"><font face="verdana">Nome do Fornecedor</font></td>'
	_cHtml  += '                    <td align="center" width="60"  bgcolor="#DFEFFF" height="18"><font face="verdana">Prefixo</font></td>'
	_cHtml  += '                    <td align="center" width="80" bgcolor="#DFEFFF" height="18"><font face="verdana">Titulo</font></td>'
	_cHtml  += '                    <td align="center" width="60"  bgcolor="#DFEFFF" height="18"><font face="verdana">Parcela</font></td>'
	_cHtml  += '                    <td align="center" width="60"  bgcolor="#DFEFFF" height="18"><font face="verdana">Tipo</font></td>'
	_cHtml  += '                    <td align="center" width="80"  bgcolor="#DFEFFF" height="18"><font face="verdana">Emissão</font></td>'
	_cHtml  += '                    <td align="center" width="80"  bgcolor="#DFEFFF" height="18"><font face="verdana">Vencimento</font></td>'
	_cHtml  += '                    <td align="center" width="80"  bgcolor="#DFEFFF" height="18"><font face="verdana">Venc.Real</font></td>'
	_cHtml  += '                    <td align="center" width="80"  bgcolor="#DFEFFF" height="18"><font face="verdana">Valor</font></td>'
	_cHtml  += '                    <td align="center" width="80"  bgcolor="#DFEFFF" height="18"><font face="verdana">Saldo</font></td>'
	_cHtml  += '                </tr>'

Return _cHtml

