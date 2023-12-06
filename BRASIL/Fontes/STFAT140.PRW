#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

#DEFINE _OPC_cGETFILE ( GETF_RETDIRECTORY + GETF_ONLYSERVER + GETF_LOCALHARD + GETF_LOCALFLOPPY )

/*====================================================================================\
|Programa  | STFAT140        | Autor | Cassio Kenj               | Data | 13/06/2019  |
|=====================================================================================|
|Descrição | Enviar wf de Pedidos embalados sem localizacao na expedicao		      |
|          | ticket 20190516000017                                                    |
|          | 																		  |
|          | Alterado de CB6_PEDIDO para CB6_XORDSE nas linhas 67 e 69				  |
|          | Alterado de TMP1.CB7_PEDIDO = TMP2.CB6_PEDIDO p/ TMP1.CB7_ORDSEP = TMP2. |
|          | CB6_XORDSE p/ trazer os volumes por Ordem de Separacao - Linha 76		  |
|          | Ticket 20200630003591 - WF SERASA - Eduardo Pereira - Sigamat - 01.12.20 |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT140()

	Local _cQuery1 := ""
	Local _cAlias1 := ""
	Local cNewEmp  := "01"
	Local cNewFil  := "02"
	Local _nTotOs  := 0
	Local _nTotVol := 0
	Local _nTotPes := 0
	Local _nX

	If IsBlind()
		Reset Environment
		RpcSetType( 3 )
		RpcSetEnv( cNewEmp, cNewFil,,,"FAT")
	EndIf

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT TMP1.CB7_PEDIDO, TMP1.CB7_ORDSEP, TMP2.VOLUME, TMP2.PESO, TMP2.EMBALADOR, TMP1.CB7_CODOPE,TMP3.CB1_NOME,
	_cQuery1 += " TMP1.CB7_XDFEM, TMP1.CB7_XHFEM, TMP1.CB7_NOTA, TMP1.CB7_SERIE, TMP1.PD1_CODROM, TMP1.PD1_STATUS, TMP1.PD2_STATUS,
	_cQuery1 += " TMP1.CB7_CLIENT, TMP1.A1_NOME, TMP1.XREAN14
	_cQuery1 += " FROM (  SELECT CB7_PEDIDO, CB7_ORDSEP, CB7_CODOPE, CB7_XDFEM, CB7_XHFEM, CB7_NOTA, CB7_SERIE,
	_cQuery1 += " NVL(PD1_CODROM,' ') PD1_CODROM, NVL(PD1_STATUS,' ') PD1_STATUS, NVL(PD2_STATUS,' ') PD2_STATUS,
	_cQuery1 += " CB7_CLIENT, A1_NOME, C5.C5_XREAN14 XREAN14
	_cQuery1 += " FROM "+RetSqlName("CB7")+" CB7
	_cQuery1 += " LEFT JOIN "+RetSqlName("SZ5")+" SZ5
	_cQuery1 += " ON CB7_FILIAL=Z5_FILIAL AND CB7_ORDSEP=Z5_ORDSEP AND SZ5.D_E_L_E_T_=' '
	_cQuery1 += " LEFT JOIN "+RetSqlName("PD2")+" PD2
	_cQuery1 += " ON CB7_FILIAL=PD2_FILIAL AND CB7_NOTA=PD2_NFS AND PD2.D_E_L_E_T_=' '
	_cQuery1 += " LEFT JOIN "+RetSqlName("PD1")+" PD1
	_cQuery1 += " ON PD1_FILIAL=PD2_FILIAL AND PD1_CODROM=PD2_CODROM AND PD1.D_E_L_E_T_=' '
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON A1_COD=CB7_CLIENT AND A1_LOJA=CB7_LOJA

	//>> Ticket 20200707003882 - Everson Santana - 09.07.2020
	_cQuery1 += " LEFT JOIN SC5010 C5 "
    _cQuery1 += "	ON C5.C5_FILIAL = CB7.CB7_FILIAL "
    _cQuery1 += "		AND C5.C5_NUM = CB7.CB7_PEDIDO "
    _cQuery1 += "		AND C5.D_E_L_E_T_ = ' '	"
	//<< Ticket 20200707003882

	_cQuery1 += " WHERE CB7.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' '
	_cQuery1 += " AND CB7_FILIAL='02' AND CB7_STATUS='4' AND CB7_PEDIDO <> ' ' AND SZ5.Z5_ORDSEP IS NULL
	_cQuery1 += " order by CB7_ORDSEP  )  TMP1,
	_cQuery1 += " ( SELECT CB6_XORDSE , COUNT(CB6_VOLUME) AS VOLUME, SUM(CB6_XPESO) AS PESO, MAX(CB6_XOPERA) EMBALADOR FROM "+RetSqlName("CB6")+" CB6
	_cQuery1 += " WHERE CB6.D_E_L_E_T_=' ' AND CB6_FILIAL='02'
	_cQuery1 += " GROUP BY CB6_XORDSE  )  TMP2,
	_cQuery1 += " ( SELECT CB1_CODOPE, CB1_NOME FROM "+RetSqlName("CB1")+" CB1
	_cQuery1 += "  WHERE CB1.D_E_L_E_T_=' ' AND CB1_FILIAL='02' )  TMP3
	_cQuery1 += " WHERE TMP1.CB7_ORDSEP = TMP2.CB6_XORDSE AND TMP1.CB7_CODOPE=TMP3.CB1_CODOPE AND TMP1.CB7_XDFEM>='20190701'
	_cQuery1 += " ORDER BY TMP1.CB7_XDFEM,TMP1.CB7_XHFEM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_cEmail	  := GetMv("STFAT1401",,"kleber.braga@steck.com.br;renato.oliveira@steck.com.br")//"kleber.braga@steck.com.br")
	_cCopia   := ""
	_cAssunto := "[WFPROTHEUS] - Pedidos embalados sem localização na expedição"
	_aAttach  := {}
	_cCaminho := ""

	cMsg := ""
	cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'

	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<TR BgColor=#FFFFFF>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Pedido</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Ordem Separação</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Qtde Volumes</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Peso Bruto</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Região Expedição</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Embalador</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Dt Embalagem</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Hr Fim Emb.</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Nome cliente</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Nota Fiscal</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Status NF</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Romaneio</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Status Rom</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">EAN14</Font></B></TD>'
	cMsg += '</TR>'

	_aRegiao := {}

	While (_cAlias1)->(!Eof())

		_cRegiao := u_regceped((_cAlias1)->CB7_PEDIDO)

		_lAchou := .F.

		For _nX:=1 To Len(_aRegiao)
			If AllTrim(Upper(_aRegiao[_nX][1]))==AllTrim(Upper(_cRegiao))
				_lAchou := .T.
				_aRegiao[_nX][2] += 1
				_aRegiao[_nX][3] += (_cAlias1)->VOLUME
				_aRegiao[_nX][4] += (_cAlias1)->PESO
			EndIf
		Next

		If !_lAchou
			AADD(_aRegiao,{_cRegiao,1,(_cAlias1)->VOLUME,(_cAlias1)->PESO})
		EndIf

		cMsg += '<TR BgColor=#66FF66>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->CB7_PEDIDO+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->CB7_ORDSEP+'</Font></B></TD>'

		If !Empty((_cAlias1)->CB7_ORDSEP)
			_nTotOs++
		EndIf

		_nTotPes += (_cAlias1)->PESO
		_nTotVol += (_cAlias1)->VOLUME

		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+CVALTOCHAR((_cAlias1)->VOLUME)+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+CVALTOCHAR((_cAlias1)->PESO)+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+_cRegiao+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->EMBALADOR+" - "+AllTrim(Posicione("CB1",1,xFilial("CB1")+(_cAlias1)->EMBALADOR,"CB1_NOME"))+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+DTOC(STOD((_cAlias1)->CB7_XDFEM))+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->CB7_XHFEM+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->A1_NOME+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->CB7_NOTA+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+GETSTANF((_cAlias1)->PD2_STATUS)+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->PD1_CODROM+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+GETSTAROM((_cAlias1)->PD1_STATUS)+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+;
			IIF((_cAlias1)->XREAN14 = "1", "Sim","Não") + '</Font></B></TD>'
		cMsg += '</TR>'

		(_cAlias1)->(DbSkip())
	EndDo

	cMsg += '</Table>'
	cMsg += '<br><br>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<TR BgColor=#FFFFFF>'
	cMsg += '<TD colspan="3"><B> <Font Color="red" Size="3" Face="Arial"><center>TOTAL GERAL</center></Font></B></TD>'
	cMsg += '</TR>'
	cMsg += '<TR BgColor=#FFFFFF>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Total OS</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Total volumes</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Total peso bruto</Font></B></TD>'
	cMsg += '</TR>'
	cMsg += '<TR BgColor=#66FF66>'
	cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+cValToChar(_nTotOs)+'</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+cValToChar(_nTotVol)+'</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+cValToChar(_nTotPes)+'</Font></B></TD>'
	cMsg += '</TR>'
	cMsg += '</Table>'

	cMsg += '<br><br>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<TR BgColor=#FFFFFF>'
	cMsg += '<TD colspan="4"><B> <Font Color="red" Size="3" Face="Arial"><center>TOTAL ROTAS</center></Font></B></TD>'
	cMsg += '</TR>'
	cMsg += '<TR BgColor=#FFFFFF>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Região expedição</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Total OS</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Total volumes</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Total peso bruto</Font></B></TD>'
	cMsg += '</TR>'
	
	aSort(_aRegiao,,,{|x,y| x[4]>y[4]})

	For _nX:=1 To Len(_aRegiao)
		cMsg += '<TR BgColor=#66FF66>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+_aRegiao[_nX][1]+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+cValToChar(_aRegiao[_nX][2])+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+cValToChar(_aRegiao[_nX][3])+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+cValToChar(_aRegiao[_nX][4])+'</Font></B></TD>'
		cMsg += '</TR>'
	Next

	cMsg += '</Table>'
	cMsg += '</body></html>'

	If IsBlind()
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
	EndIf

	If !IsBlind() .And. !Empty(cMsg)

		cPath		:= cGetFile( "Selecione o Diretorio | " , OemToAnsi( "Selecione Diretorio" ) , NIL , "" , .F. , _OPC_cGETFILE )
		cArquivo	:= DTOS(Date())+StrTran(Time(),":")+".html"
		cAnexo		:= cPath+cArquivo

		nHdlXml   := FCreate(cAnexo,0)
		If nHdlXml > 0
			FWrite(nHdlXml,cMsg)
			FClose(nHdlXml)
			MsgAlert("Arquivo salvo com sucesso, obrigado!")
		Endif

	EndIf

Return()

Static Function GETSTANF(_cStatus)

	Local _cDesc := ""

	_cStatus := AllTrim(_cStatus)

	Do Case
	Case _cStatus=="0"
		_cDesc := "Não iniciado"
	Case _cStatus=="1"
		_cDesc := "Em andamento"
	Case _cStatus=="2"
		_cDesc := "Encerrado"
	EndCase

Return(_cDesc)

Static Function GETSTAROM(_cStatus)

	Local _cDesc := ""

	_cStatus := AllTrim(_cStatus)

	Do Case
	Case _cStatus=="0"
		_cDesc := "Não iniciado"
	Case _cStatus=="1"
		_cDesc := "Em andamento"
	Case _cStatus=="2"
		_cDesc := "Fechado"
	Case _cStatus=="3"
		_cDesc := "Encerrado"
	EndCase

Return(_cDesc)
