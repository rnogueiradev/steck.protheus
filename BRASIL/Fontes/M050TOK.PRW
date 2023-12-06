#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | M050TOK          | Autor | RENATO.NOGUEIRA          | Data | 18/11/2015  |
|=====================================================================================|
|Descrição |  M050TOK     Valida alteração/inclusão de transportadoras                |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | M050TOK                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function M050TOK()
	
	Local _lRet		:= .T.
	Local _aArea	:= GetArea()
	Local _aEmail	:= {}
	Local _cAssunto := ""
	Local cMsg		  := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local _cEmail  				:= GetMv("ST_WFSA4AL")
	Local _cCopia  				:= " "
	
	If ALTERA
		
		If !(M->A4_END==SA4->A4_END)
			AADD(_aEmail,{"ENDEREÇO",SA4->A4_END,M->A4_END})
		EndIf
		If !(M->A4_BAIRRO==SA4->A4_BAIRRO)
			AADD(_aEmail,{"BAIRRO",SA4->A4_BAIRRO,M->A4_BAIRRO})
		EndIf
		If !(M->A4_MUN==SA4->A4_MUN)
			AADD(_aEmail,{"MUNICÍPIO",SA4->A4_MUN,M->A4_MUN})
		EndIf
		If !(M->A4_EST==SA4->A4_EST)
			AADD(_aEmail,{"ESTADO",SA4->A4_EST,M->A4_EST})
		EndIf
		If !(M->A4_CEP==SA4->A4_CEP)
			AADD(_aEmail,{"CEP",SA4->A4_CEP,M->A4_CEP})
		EndIf
		
		If Len(_aEmail)>0
			
			_cAssunto:= '[WFPROTHEUS] - Endereço da transportadora '+AllTrim(SA4->A4_NOME)+' alterado'
			cMsg	:= LISTARALT(_aEmail)
			cMsg	+= LISTARNFS(SA4->A4_COD)
			
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			
			
		EndIf
		
	EndIf
	
	RestArea(_aArea)
	
Return(_lRet)

Static Function LISTARALT(_aEmail)
	
	Local cFuncSent	:= "RetPedido"
	Local cMsg			:= ""
	Local _nLin := 0
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	cMsg += '<TR><B><TD>CAMPO</TD><TD>CONTEÚDO ANTIGO</TD><TD>CONTEÚDO NOVO</TD><TD>ALTERADO POR</TD></B></TR>'
	
	For _nLin := 1 to Len(_aEmail)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf
		
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,1] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,2] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,3] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + Alltrim(UsrRetName(__CUSERID)) + ' </Font></TD>'
		cMsg += '</TR>'
	Next
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do rodape do email                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	
	_aEmail	:= {}
	
Return(cMsg)

Static Function LISTARNFS(_cTransp)
	
	Local cFuncSent	:= "RetPedido"
	Local cMsg		:= ""
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"
	Local _nLin		:= 0
	
	cQuery1  := " SELECT (SELECT MAX(D2_PEDIDO) FROM " +RetSqlName("SD2")+ " D2 WHERE D2.D_E_L_E_T_=' ' AND D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC) AS PEDIDO, "
	cQuery1  += " F2_DOC, F2_SERIE, A1_NOME, PD1_CODROM "
	cQuery1  += " FROM " +RetSqlName("SF2")+ " F2 "
	cQuery1  += " LEFT JOIN " +RetSqlName("PD2")+ " PD2 "
	cQuery1  += " ON PD2.PD2_FILIAL=F2.F2_FILIAL AND PD2.PD2_NFS=F2.F2_DOC AND PD2.D_E_L_E_T_=' ' "
	cQuery1  += " LEFT JOIN " +RetSqlName("PD1")+ " PD1 "
	cQuery1  += " ON PD1_FILIAL=PD2_FILIAL AND PD1_CODROM=PD2_CODROM AND PD1.D_E_L_E_T_=' ' "
	cQuery1  += " LEFT JOIN " +RetSqlName("SA1")+ " A1 "
	cQuery1  += " ON A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND A1.D_E_L_E_T_=' ' "
	cQuery1  += " WHERE F2.D_E_L_E_T_=' ' "
	cQuery1  += " AND F2.F2_FILIAL='02' AND PD1_STATUS<>'3' AND F2.F2_TRANSP='"+_cTransp+"' "
	cQuery1  += " ORDER BY F2_DOC "
	
	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)
	
	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())
	
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	cMsg += '<TR><B><TD>PEDIDO</TD><TD>NOTA FISCAL</TD><TD>SERIE</TD><TD>CLIENTE</TD><TD>ROMANEIO</TD></B></TR>'
	
	While (cAlias1)->(!Eof())
		_nLin++
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf
		
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + (cAlias1)->PEDIDO + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + (cAlias1)->F2_DOC + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + (cAlias1)->F2_SERIE + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + (cAlias1)->A1_NOME + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + (cAlias1)->PD1_CODROM + ' </Font></TD>'
		cMsg += '</TR>'
		
		(cAlias1)->(DbSkip())
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do rodape do email                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	
	_aEmail	:= {}
	
Return(cMsg)
