#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"

/*====================================================================================\
|Programa  | STFAT580        | Autor | RENATO.OLIVEIRA           | Data | 29/06/2022  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT580()

	Local cNewEmp 	:= "11"
	Local cNewFil	:= "01"
	Local _cQuery1  := ""
	Local _cAlias1  := ""

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()

	ConOut(CRLF + "[STFAT580]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	If !LockByName("STFAT580",.T.,.T.)
		ConOut("[STFAT580]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	_aAttach    := {}
	_cEmail 	:= Alltrim(GetMv("STFAT58002",,"renato.oliveira@steck.com.br"))
	_cAssunto   := "[WFPROTHEUS] - Produtos com data de lançamento vencidos
	cMsg		:= ""
	_cCaminho := ""
	_cCopia := ""

	cMsg := ''
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	cMsg += '<br>
	cMsg += '<TR BgColor=#FFFFFF>'
	cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Produto</Font></B></TD>'
	cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Descrição</Font></B></TD>'
	cMsg += '<TD><B><Font Color="red" Size="3" Face="Arial">Dt lançamento</Font></B></TD>'
	cMsg += '</TR>'

	_cQuery1 := " SELECT B1_COD, B1_DESC, B1_XDTLCTO
	_cQuery1 += " FROM "+RetSqlName("SB1")+" B1
	_cQuery1 += " WHERE B1.D_E_L_E_T_=' ' 
	_cQuery1 += " AND TO_DATE(B1_XDTLCTO,'YYYYMMDD')+"+cValToChar(GetMv("STFAT58001",,30))+"<=TO_DATE('"+Dtos(Date())+"','YYYYMMDD')
	_cQuery1 += " AND B1_XDTLCTO<>' ' 

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		cMsg += '<TR BgColor=#FFFFFF>'
		cMsg += '<TD><Font Color="black" Size="3" Face="Arial">'+(_cAlias1)->B1_COD+'</Font></TD>'
		cMsg += '<TD><Font Color="black" Size="3" Face="Arial">'+AllTrim((_cAlias1)->B1_DESC)+'</Font></TD>'
		cMsg += '<TD><Font Color="black" Size="3" Face="Arial">'+DTOC(STOD((_cAlias1)->B1_XDTLCTO))+'</Font></TD>'
		cMsg += '</TR>'

		(_cAlias1)->(DbSkip())
	EndDo

	cMsg += '</Table>'
	cMsg += '</body>'
	cMsg += '</html>'

	U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

	UnLockByName("STFAT580",.T.,.T.)

	ConOut("[STFAT580]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()
