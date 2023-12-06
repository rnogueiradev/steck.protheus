#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTSOFTWF  บAutor  ณEverson Santana 	 บ Data ณ  07/03/18  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia Workflow informando que estแ pr๓ximo da expira็ใo    บฑฑ
ฑฑบ          ณ 										                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck - Chamado 006891                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STSOFTWF()

	Local _cHtml  	:= ""
	Local _cQuery		:= ""
	Local _cTemp		:= ""
	Local _cCopia   	:= ""
	Local _cAssunto 	:= ""
	Local cMsg	    	:= ""
	Local _aAttach  	:= {}
	Local _cCaminho 	:= ''
	Local _cEmail		:= ""
	Local _DtDif		:= 0
	Local _lEmail		:= .F.
	
	RpcSetType(3)
	RpcSetEnv("01","01",,'MNT')
			
	_cTemp  := GetNextAlias()
	_cQuery := " SELECT * 							" + CHR(13) + CHR(10)
	_cQuery += " FROM "+ RetSqlName("ZZQ")+ " ZZQ	" + CHR(13) + CHR(10)
	_cQuery += " WHERE 								" + CHR(13) + CHR(10)
	_cQuery += "	ZZQ_DTEXP <> ' ' 					" + CHR(13) + CHR(10)
	_cQuery += " 	AND D_E_L_E_T_ = ' ' 			" + CHR(13) + CHR(10)
		
	_cQuery := ChangeQuery(_cQuery)
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cTemp,.T.,.T.)
	dbSelectArea(_cTemp)
	dbGotop()

	_cHtml   := ""
	_cHtml  += '<html>'
	_cHtml  += '    <table border="0" bgcolor="#666666">'
	_cHtml  += '                <tr>'
	_cHtml  += '                    <td colspan="7" width="630" bgcolor="#DFEFFF"'
	_cHtml  += '                    height="24"><p align="center"><font size="4"'
	_cHtml  += '                    face="verdana"><b>Notifica็ใo de Expira็ใo de Software</b></font></p>'
	_cHtml  += '                    </td>'
	_cHtml  += '                </tr>'
	_cHtml  += '                <tr>'
	_cHtml  += '                    <td align="center" width="60"  bgcolor="#DFEFFF" height="18"><font face="verdana">Filial</font></td>'
	_cHtml  += '                    <td align="center" width="80"  bgcolor="#DFEFFF" height="18"><font face="verdana">Codigo</font></td>'
	_cHtml  += '                    <td align="center" width="200"  bgcolor="#DFEFFF" height="18"><font face="verdana">Descri็ใo</font></td>'
	_cHtml  += '                    <td align="center" width="100"  bgcolor="#DFEFFF" height="18"><font face="verdana">Qtd Licen็a</font></td>'
	_cHtml  += '                    <td align="center" width="100"  bgcolor="#DFEFFF" height="18"><font face="verdana">Dt Compra</font></td>'
	_cHtml  += '                    <td align="center" width="100" bgcolor="#DFEFFF" height="18"><font face="verdana">Dt Expira็ใo</font></td>'
	_cHtml  += '                    <td align="center" width="100" bgcolor="#DFEFFF" height="18"><font face="verdana">Expira em</font></td>'
	_cHtml  += '                </tr>'
	
	While !Eof()
			
		_DtDif := DateDiffDay( Date(),Stod((_cTemp)->ZZQ_DTEXP) )
			
		If _DtDif = 90 .OR. _DtDif = 60 .OR. _DtDif = 30
		
			_cHtml   += '                <tr>'
			_cHtml   += '                    <td align="center" bgcolor="#FFFFFF"><font size="1" face="verdana">'+(_cTemp)->ZZQ_FILIAL+'</font></td>'
			_cHtml   += '                    <td align="center" bgcolor="#FFFFFF"><font size="1" face="verdana">'+(_cTemp)->ZZQ_CODIGO+'</font></td>'
			_cHtml   += '                    <td align="left" bgcolor="#FFFFFF"><font size="1" face="verdana">'+(_cTemp)->ZZQ_DESC+'</font></td>'
			_cHtml   += '                    <td align="right" bgcolor="#FFFFFF"><font size="1" face="verdana">'+TRANSFORM((_cTemp)->ZZQ_QTDLIC,"@E 99999999.99")+'</font></td>'
			_cHtml   += '                    <td align="center" bgcolor="#FFFFFF"><font size="1" face="verdana">'+Dtoc(Stod((_cTemp)->ZZQ_DTCMP))+'</font></td>'
			_cHtml   += '                    <td align="center" bgcolor="#FFFFFF"><font size="1" face="verdana">'+Dtoc(Stod((_cTemp)->ZZQ_DTEXP))+'</font></td>'
			_cHtml   += '                    <td align="center" bgcolor="#FFFFFF"><font size="1" face="verdana">'+TRANSFORM(_DtDif,"@E 999")+'</font></td>'
			_cHtml   += '                </tr>'
			
			_lEmail := .T.
			
		EndIf
					
		dbSelectArea(_cTemp)
		dbSkip()
	End
	
	_cHtml  += '            </table>'
	_cHtml  += '</body>'
	_cHtml  += '</html>'
	
	dbSelectArea(_cTemp)
	(_cTemp)->(dbCloseArea())
		
	If _lEmail
			
		_lEmail := .F.
		_cEmail		:= SuperGetMv("ST_NOTSOFT",,"")
		_cAssunto := 'Notifica็ใo de Expira็ใo de Software'
		cMsg 	  := _cHtml
	
		If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			VtAlert("Problemas no envio de email!")
		EndIf
		
	EndIf
			
	RpcClearEnv()
	
Return
