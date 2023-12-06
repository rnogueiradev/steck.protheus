#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STEST060        | Autor | RENATO.OLIVEIRA           | Data | 26/12/2018  |
|=====================================================================================|
|Descrição | WF de endereçamentos pendentes                                           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STEST060()

	Local cNewEmp 	:= "01"
	Local cNewFil 	:= "02"
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _cAssunto := "[WFPROTHEUS] - Produtos sem endereçar
	Local _nLin 	:= 0
	Local _cEmail	:= ""
	Local _cCopia	:= ""
	Local cAttach	:= ""

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")
	
	_cEmail	:= GetMv("ST_EST060",,"kleber.braga@steck.com.br")

	ConOut("[STEST060]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	_cAlias1 	:= GetNextAlias()

	_cQuery1 := " SELECT DA_PRODUTO, B1_DESC, DA_SALDO, DA_DATA, DA_LOCAL, DA_DOC, DA.R_E_C_N_O_ RECSDA
	_cQuery1 += " FROM "+RetSqlName("SDA")+" DA
	_cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" B1
	_cQuery1 += " ON DA_PRODUTO=B1_COD
	_cQuery1 += " WHERE DA.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' '  
	_cQuery1 += " AND DA_FILIAL='02' AND DA_SALDO>0 AND DA_DATA<'"+DTOS(Date()-2)+"'
	_cQuery1 += " ORDER BY DA_DATA

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	cMsg += '<TR BgColor=#B0E2FF><B><TD>PRODUTO</TD><TD>DESCRIÇÃO</TD><TD>SALDO</TD><TD>DATA</TD><TD>ARMAZEM</TD><TD>DOCUMENTO</TD><TD>NF</TD></B></TR>'
	
	DbSelectArea("SDA")

	While (_cAlias1)->(!Eof())
	
		SDA->(DbGoTo((_cAlias1)->RECSDA))
		_nLin++

		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf

		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+(_cAlias1)->DA_PRODUTO+'</Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+(_cAlias1)->B1_DESC+'</Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+CVALTOCHAR((_cAlias1)->DA_SALDO)+'</Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+DTOC(STOD((_cAlias1)->DA_DATA))+'</Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+(_cAlias1)->DA_LOCAL+'</Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+(_cAlias1)->DA_DOC+'</Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+U_STESTNF()+'</Font></TD>'
		cMsg += '</TR>'

		(_cAlias1)->(DbSkip())
	EndDo

	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">(STEST060.PRW)</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

	U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

	ConOut("[STEST060]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()