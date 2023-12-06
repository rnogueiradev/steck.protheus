#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT600        | Autor | RENATO.OLIVEIRA           | Data | 21/09/2021  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                    |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT600()

	Local _cQuery1 := ""
	Local _cAlias1 := ""
	Local _cQuery2 := ""
	Local _cAlias2 := ""
	Local cNewEmp  := "11"
	Local cNewFil  := "01"

	Reset Environment

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()
	_cAlias2 := GetNextAlias()

   _cQuery1 += " SELECT *
   _cQuery1 += " FROM (
   _cQuery1 += " SELECT C6_NUM||C6_ITEM NUMITEM, C6_NUM, C5_EMISSAO, C6_EMISSAO, C6_ITEM, C6_PRODUTO, C6_QTDVEN-C6_QTDENT SALDO, 
   _cQuery1 += " NVL(PA1_QUANT,0) FALTA, NVL(PA2_QUANT,0) RESERVA, NVL(DC_QUANT,0) EMPENHO
   _cQuery1 += " FROM "+RetSqlName("SC6")+" C6
   _cQuery1 += " LEFT JOIN "+RetSqlName("SC5")+" C5
   _cQuery1 += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5.D_E_L_E_T_=' ' 
   _cQuery1 += " LEFT JOIN "+RetSqlName("PA1")+" PA1
   _cQuery1 += " ON PA1_FILIAL=C6_FILIAL AND PA1_CODPRO=C6_PRODUTO AND PA1_DOC=C6_NUM||C6_ITEM AND PA1.D_E_L_E_T_=' ' 
   _cQuery1 += " LEFT JOIN "+RetSqlName("PA2")+" PA2
   _cQuery1 += " ON PA2_FILRES=C6_FILIAL AND PA2_CODPRO=C6_PRODUTO AND PA2_DOC=C6_NUM||C6_ITEM AND PA2.D_E_L_E_T_=' ' 
   _cQuery1 += " LEFT JOIN (SELECT DC_FILIAL, DC_PEDIDO, DC_ITEM, DC_PRODUTO, SUM(DC_QUANT) DC_QUANT
   _cQuery1 += " FROM "+RetSqlName("SDC")+" DC WHERE D_E_L_e_t_=' ' AND DC_QUANT>0 AND DC_PEDIDO<>' '  
   _cQuery1 += " AND DC_ORIGEM = 'SC6' GROUP BY DC_FILIAL, DC_PEDIDO, DC_ITEM, DC_PRODUTO) DC
   _cQuery1 += " ON DC_FILIAL = C6_FILIAL AND DC_PRODUTO = C6_PRODUTO AND DC_PEDIDO = C6_NUM
   _cQuery1 += " AND DC_ITEM = C6_ITEM
   _cQuery1 += " WHERE C6.D_E_L_E_T_=' ' AND C6_QTDVEN - C6_QTDENT > 0 AND C6_BLQ=' ' AND C6_OPER='01' AND C6_XDTRERE<>' ' 
   _cQuery1 += " AND C6_LOCAL<>'60'
   _cQuery1 += " ) XXX
   _cQuery1 += " WHERE FALTA+RESERVA+EMPENHO<>SALDO
   _cQuery1 += " ORDER BY NUMITEM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_cEmail	  := GetMv("STFAT6001",,"renato.oliveira@steck.com.br")
	_cCopia   := ""
	_cAssunto := "[WFPROTHEUS] - Divergência de saldos - Empresa "+cEmpAnt
	_aAttach  := {}
	_cCaminho := ""

	cMsg := ""
	cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<TR BgColor=#FFFFFF>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Pedido</Font></B></TD>'
   cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Item</Font></B></TD>'
   cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Saldo</Font></B></TD>'
   cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Falta</Font></B></TD>'
   cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Reserva</Font></B></TD>'
   cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Empenho</Font></B></TD>'
	cMsg += '</TR>'

	While (_cAlias1)->(!Eof())

		cMsg += '<TR BgColor=#66FF66>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->C6_NUM+'</Font></B></TD>'
      cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->C6_ITEM+'</Font></B></TD>'
      cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+cValToChar((_cAlias1)->SALDO)+'</Font></B></TD>'
      cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+cValToChar((_cAlias1)->FALTA)+'</Font></B></TD>'
      cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+cValToChar((_cAlias1)->RESERVA)+'</Font></B></TD>'
      cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+cValToChar((_cAlias1)->EMPENHO)+'</Font></B></TD>'
		cMsg += '</TR>'

		(_cAlias1)->(DbSkip())
	EndDo

	cMsg += '</body></html>'

   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

Return()
