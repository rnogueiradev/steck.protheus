#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STEST030        | Autor | RENATO.OLIVEIRA           | Data | 26/12/2018  |
|=====================================================================================|
|Descrição | ROTINA PARA ENVIAR WF DE PRODUTOS SEM CUSTO                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STEST030()

	Local cNewEmp 	:= "01"
	Local cNewFil	:= "04"
	Local _cQuery1  := ""
	Local _cAlias1  := ""
	Local _cAssunto := "[WFPROTHEUS] - Produtos sem custo"
	Local cAttach   := ''

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()

	_cEmail := GetMv("ST_STEST03",,"renato.oliveira@steck.com.br")
	_cCopia := ""

	_cQuery1 := " SELECT B2_FILIAL, B2_COD, B2_LOCAL, B1_DESC, B2_CMFIM1
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT DISTINCT D1_COD CODIGO
	_cQuery1 += " FROM "+RetSqlName("SD1")+" D1
	_cQuery1 += " LEFT JOIN "+RetSqlName("SF4")+" F4
	_cQuery1 += " ON F4_CODIGO=D1_TES
	_cQuery1 += " WHERE D1.D_E_L_E_T_=' ' AND F4.D_E_L_E_T_=' '
	_cQuery1 += " AND D1_FILIAL='04' AND F4_ESTOQUE='S' AND D1_DTDIGIT BETWEEN '"+DTOS(YearSub(Date(),1))+"' AND '"+DTOS(Date())+"'
	_cQuery1 += " UNION
	_cQuery1 += " SELECT DISTINCT D3_COD CODIGO
	_cQuery1 += " FROM "+RetSqlName("SD3")+" D3
	_cQuery1 += " WHERE D3.D_E_L_E_T_=' ' AND D3_EMISSAO BETWEEN '"+DTOS(YearSub(Date(),1))+"' AND '"+DTOS(Date())+"'
	_cQuery1 += " ) XXX
	_cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" B1
	_cQuery1 += " ON B1_COD=XXX.CODIGO
	_cQuery1 += " LEFT JOIN "+RetSqlName("SB2")+" B2
	_cQuery1 += " ON B2_COD=B1_COD
	_cQuery1 += " WHERE B2.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' '
	_cQuery1 += " AND B2_FILIAL='04' AND B2_CMFIM1=0
	_cQuery1 += " AND B1_MSBLQL='2' AND B1_XDESAT<>'2' AND B2_LOCAL<>' '
	_cQuery1 += " ORDER BY B1_COD

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
	cMsg += '<title>'  + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +'</FONT> </Caption>'
	cMsg += '<tr><td><b>Filial</b></td><td><b>Código</b></td><td><b>Local</b></td><td><b>Descrição</b></td><td><b>Custo</b></td></tr>'

	_nCount := 0

	While (_cAlias1)->(!Eof())

		_nCount++

		If (_nCount/2) == Int(_nCount/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf

		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ (_cAlias1)->B2_FILIAL	+ ' </Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ (_cAlias1)->B2_COD	+ ' </Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ (_cAlias1)->B2_LOCAL 	+ ' </Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ (_cAlias1)->B1_DESC  	+ ' </Font></B></TD>'
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' 	+ CVALTOCHAR((_cAlias1)->B2_CMFIM1)	+ ' </Font></B></TD>'
		cMsg += '</TR>'

		(_cAlias1)->(DbSkip())
	EndDo

	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">(STEST030.PRW)</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

	U_STMAILTES(_cEmail,_cCopia,_cAssunto,cMsg,cAttach)

Return