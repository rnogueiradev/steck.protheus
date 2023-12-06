#include 'Protheus.ch'
#include 'RwMake.ch'


/*====================================================================================\
|Programa  | StFatMail        | Autor | GIOVANI.ZAGO             | Data | 28/05/2013  |
|=====================================================================================|
|Descrição | StFatMail                                                                |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | StFatMail                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*------------------------------------------------------------------*
User Function  StFatMail(_cObs,_cMot,_cName,_cDat,_cHora,_cxEmail,_axcols)
*------------------------------------------------------------------*

Local aArea 	:= GetArea()
Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
Local _cAssunto:= 'Faturamento - Divergência no Documento de Saída ('+ALLTRIM(SF2->F2_DOC)+' - '+SF2->F2_SERIE+')'
Local cFuncSent:= "StFatMail"
Local _aMsg    :={}
Local i        := 0
Local cArq     := ""
Local cMsg     := ""
Local _nLin
Local _cCopia  := "renato.oliveira@steck.com.br;everson.santana@steck.com.br "
Local cAttach  := ''

Local _cEmail  := 'KLEBER.BRAGA@steck.com.br;Simone.MARA@steck.com.br;rafael.pereira@steck.com.br;vanessa.silva@steck.com.br;francisco.smania@steck.com.br;juliete.vieira@steck.com.br;marcelo.galera@steck.com.br;maurilio.francisquet@steck.com.br;marcelo.avelino@steck.com.br;luan.oliveira@steck.com.br;giovanni.cursino@steck.com.br'

If ( Type("l410Auto") == "U" .OR. !l410Auto )
	
	Aadd( _aMsg , { "Filial", "Pedido","Item","Produto","Descricao","Qtd. Nota","Qtd. Lib.","Qtd. Sep.","Qtd. Emb." ,"Ordem Sep."} )
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do cabecalho do email                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do texto/detalhe do email                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg += '<TR BgColor=#FFFFFF>'
	cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">' + _aMsg[1,1] + ' </Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,2] + ' </Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,3] + ' </Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,4] + ' </Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,5] + ' </Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,6] + ' </Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,7] + ' </Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,8] + ' </Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,9] + ' </Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,10] + ' </Font></B></TD>'
	cMsg += '</TR>'
	For _nLin := 1 to Len(_axcols)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _axcols[_nLin,2] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _axcols[_nLin,3] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _axcols[_nLin,4] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _axcols[_nLin,5] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _axcols[_nLin,6] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cvaltochar(_axcols[_nLin,7]) + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cvaltochar(_axcols[_nLin,8]) + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cvaltochar(_axcols[_nLin,9]) + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cvaltochar(_axcols[_nLin,10]) + ' </Font></TD>'
		dbSelectArea("SC9")
		SC9->(dbSetOrder(1))
		If SC9->(DbSeek(xFilial("SC9")+_axcols[_nLin,3]+_axcols[_nLin,4]))
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + SC9->C9_ORDSEP + ' </Font></TD>'
		Else
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + 'Vazio' + ' </Font></TD>'
		EndIf
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
	
	
	If !(   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach) )
		MsgInfo("Email não Enviado..!!!!")
		
	EndIf
EndIf
RestArea(aArea)
Return()

