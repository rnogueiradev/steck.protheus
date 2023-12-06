#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STFAT080        | Autor | RENATO.OLIVEIRA           | Data | 26/12/2018  |
|=====================================================================================|
|Descrição | WF de NFS pendentes de gerar romaneio                                    |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT080()

	Local cNewEmp 	:= "11"       // 01   - Valdemir Rabelo - 23/02/2022 - chamado: 20220120001661
	Local cNewFil 	:= "01"       // 02   - Valdemir Rabelo - 23/02/2022 - chamado: 20220120001661
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _cAssunto := "[WFPROTHEUS] - NFs sem romaneio gerado
	Local _nLin 	:= 0
	Local _cEmail	:= ""
	Local _cCopia	:= ""
	Local cAttach	:= ""

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cEmail	:= GetMv("ST_FAT080",,"kleber.braga@steck.com.br")

	ConOut("[STFAT080]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	_cAlias1 	:= GetNextAlias()

	_cQuery1 := " SELECT F2_OK, F2_DOC, F2_SERIE, F2_CLIENTE , F2_LOJA, F2_EMISSAO, F2_TRANSP, F2_VOLUME1, F2_PLIQUI, F2_PBRUTO, 	A1_COD, A1_LOJA, A1_NOME, A1_REGIAO, F2_XGUIA,F2_XPRFGUI,F2_EST  ,
	_cQuery1 += "  A4_NOME AS TRANSP  , F2_XOBSROM AS OBS  , CASE WHEN C5_XTIPO='1' THEN 'R' ELSE 'E' END  AS TPENT
	_cQuery1 += "  FROM "+RetSqlName("SF2")+" SF2
	_cQuery1 += " inner join (SELECT * FROM "+RetSqlName("SA1")+") SA1
	_cQuery1 += " ON      SA1.A1_FILIAL = '" + xFilial("SA1") + "'
	_cQuery1 += " AND 	SF2.F2_CLIENTE = SA1.A1_COD
	_cQuery1 += " AND     SF2.F2_LOJA = SA1.A1_LOJA
	_cQuery1 += " AND     SA1.D_E_L_E_T_ = ' '
	//_cQuery1 += " AND 	SA1.A1_REGIAO BETWEEN  '" + cRegiaoDe + "'  AND   '"+cRegiaoAte+"'
	_cQuery1 += " INNER JOIN(SELECT * FROM "+RetSqlName("SD2")+" )D2 ON D2.D_E_L_E_T_=' '
	_cQuery1 += " AND D2.D2_FILIAL=SF2.F2_FILIAL AND D2.D2_DOC=SF2.F2_DOC AND D2.D2_ITEM='01'
	_cQuery1 += " INNER JOIN(SELECT * FROM "+RetSqlName("SC5")+") C5 ON C5.D_E_L_E_T_=' '
	_cQuery1 += " AND C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO
	_cQuery1 += " INNER JOIN(SELECT * FROM "+RetSqlName("SA4")+") A4
	_cQuery1 += " ON A4.D_E_L_E_T_=' '
	_cQuery1 += " AND A4.A4_COD=SF2.F2_TRANSP
	_cQuery1 += " AND A4_FILIAL = '" + xFilial("SA4") + "'
	_cQuery1 += " WHERE SF2.F2_FILIAL = '" + xFilial("SF2") + "'
	_cQuery1 += " AND 	SF2.F2_XCODROM  = '          '
	_cQuery1 += " AND SF2.F2_EMISSAO<'"+DTOS(Date()-GetMv("STFAT0801",,1))+"'
	_cQuery1 += " AND	SF2.F2_CLIENTE <> '033467'
	//_cQuery1 += " AND 	SF2.F2_DOC       BETWEEN '" + cNFSDe 			+ "'  AND   '" + cNFSAte + "'
	//_cQuery1 += " AND 	SF2.F2_SERIE     BETWEEN '" + cSerieDe 			+ "'  AND   '" + cSerieAte + "'
	//_cQuery1 += " AND 	SF2.F2_CLIENTE   BETWEEN '" + cClienteDe 		+ "'  AND   '" + cClienteAte + "'
	//_cQuery1 += " AND 	SF2.F2_LOJA      BETWEEN '" + cLojaDe 			+ "'  AND   '" + cLojaAte + "'
	//_cQuery1 += " AND 	SF2.F2_EMISSAO   BETWEEN '" + DTOS(dEmissaoDe)  + "'  AND   '" + DTOS(dEmissaoAte) + "'
	//_cQuery1 += " AND 	SF2.F2_TRANSP    BETWEEN '" + cTransp 			+ "'  AND   '" + cTranAte + "'
	_cQuery1 += " AND       NOT exists (SELECT PD2_NFS FROM "+RetSqlName("PD2")+" PD2 WHERE PD2.D_E_L_E_T_=' ' AND PD2.PD2_FILIAL=SF2.F2_FILIAL AND PD2.PD2_NFS=SF2.F2_DOC)
	_cQuery1 += " AND  	SF2.D_E_L_E_T_ = ' '
	_cQuery1 += " ORDER BY F2_DOC, F2_SERIE

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
	cMsg += '<TR BgColor=#B0E2FF><B><TD>NUMERO</TD><TD>SERIE</TD><TD>GUIA</TD><TD>CLIENTE</TD><TD>LOJA</TD><TD>NOME</TD><TD>REGIAO</TD><TD>DT EMISSAO</TD><TD>VOLUME 1</TD><TD>PESO LIQUIDO</TD><TD>PESO BRUTO</TD><TD>TIPO ENTREGA</TD><TD>TRANSPORTADORA</TD><TD>OBSERVACAO</TD></B></TR>'

	DbSelectArea("CB7")
	CB7->(DbSetOrder(4))

	dbselectarea("SE2")

	While (_cAlias1)->(!Eof())

		_nLin++

		_lContinua  := .F.
		_cGuia		:= ""
		cNomeCli    := Posicione("SA1",1,XFILIAL("SA1")+(_cAlias1)->(F2_CLIENTE+F2_LOJA),"A1_NOME")
		dEmissao    := CTOD(Right((_cAlias1)->F2_EMISSAO,2)+"/"+SubStr((_cAlias1)->F2_EMISSAO,5,2)+"/"+Left((_cAlias1)->F2_EMISSAO,4))
		If CB7->(DbSeek(xFilial('CB7')+(_cAlias1)->(F2_DOC+F2_SERIE)))
			If!Empty(DTOC(CB7->CB7_XDFEM))  .AND. !(CB7->CB7_STATUS $ "1/9")
					_lContinua := .T.
			Endif
		Else
			_lContinua := .T.
		EndIf

		If _lContinua

			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf

			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+(_cAlias1)->F2_DOC+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+(_cAlias1)->F2_SERIE+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+_cGuia+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+(_cAlias1)->F2_CLIENTE+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+(_cAlias1)->F2_LOJA+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+cNomeCli+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+(_cAlias1)->A1_REGIAO+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+DTOC(dEmissao)+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+CVALTOCHAR((_cAlias1)->F2_VOLUME1)+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+CVALTOCHAR((_cAlias1)->F2_PLIQUI)+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+CVALTOCHAR((_cAlias1)->F2_PBRUTO)+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+(_cAlias1)->TPENT+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+(_cAlias1)->TRANSP+'</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">'+(_cAlias1)->OBS+'</Font></TD>'
			cMsg += '</TR>'

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">(STFAT080.PRW)</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

	U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

	ConOut("[STFAT080]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()
