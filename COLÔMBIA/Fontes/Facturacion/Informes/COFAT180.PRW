#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FILEIO.CH"

/*====================================================================================\
|Programa  | COFAT180        | Autor | RENATO.OLIVEIRA           | Data | 07/05/2019  |
|=====================================================================================|
|Descrição | Enviar wf estoque                                                        |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function COFAT180()

	Local _cQuery1 := ""
	Local _cAlias1 := ""
	Local _cQuery2 := ""
	Local _cAlias2 := ""
	Local cNewEmp  := "09"
	Local cNewFil  := "01"
	Local cArqXML1	:= ""
	Local cArqXML2	:= ""
	Local nHdlXml

	Reset Environment

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()
	_cAlias2 := GetNextAlias()

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM
	_cQuery1 += " (
	_cQuery1 += " SELECT B2_COD,B2_LOCAL,B2_QATU, B2_QPEDVEN, B1_GRUPO, B1_DESC,
	_cQuery1 += " NVL((SELECT SUM(C7_QUANT-C7_QUJE) FROM "+RetSqlName("SC7")+" C7
	_cQuery1 += " WHERE C7.D_E_L_E_T_=' ' AND C7_QUANT>C7_QUJE AND C7_PRODUTO=B2_COD),0) PEDCOM,
	_cQuery1 += " 0 B1_XLM, NVL(DA1_PRCVEN,0) PRECO, B2_RESERVA
	_cQuery1 += " FROM "+RetSqlName("SB2")+" B2
	_cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" B1
	_cQuery1 += " ON B1_COD=B2_COD
	_cQuery1 += " LEFT JOIN "+RetSqlName("DA1")+" DA1
	_cQuery1 += " ON DA1_CODTAB='"+AllTrim(GetMv("COFAT1803",,"007"))+"' AND DA1_CODPRO=B2_COD AND DA1.D_E_L_E_T_=' '
	_cQuery1 += " WHERE B2.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' '
	_cQuery1 += " AND B2_LOCAL IN ('02','03')
	_cQuery1 += " AND B1_TIPO = 'PA'"
	_cQuery1 += " AND B1_DESC <> '#N/D'"
	_cQuery1 += " ) XXX
	_cQuery1 += " PIVOT ( SUM(B2_QATU) AS QATU, SUM(B2_QPEDVEN) AS QPEDVEN, SUM(B2_RESERVA) AS RESERVA FOR (B2_LOCAL) IN ('02' AS A02, '03' as A03) )
	_cQuery1 += " ORDER BY B2_COD

	conout(_cQuery1)

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	//Gerência
	cMsg := ""
	cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
	cMsg += '<Table Align=Center CELLPADDING=4 CELLSPACING=0 Width=60%>
	cMsg += '<tr><td><img src="http://www.appstk.com.br/imagens/logo1.jpg"></td>
	cMsg += '<td><b><font color="red">STECK ANDINA</font><br>INVENTARIO '+DTOC(Date())+'</b><br></td></tr>
	cMsg += '</table><br>
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>
	cMsg += '<TR BgColor=#ff0000>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">Código</Font></B></TD>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">Descripción</Font></B></TD>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">Empaque Estandar</Font></B></TD>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">ZONA FRANCA</Font></B></TD>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">NACIONALIZADO</Font></B></TD>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">TOTAL</Font></B></TD>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">Cantidad comprometida</Font></B></TD>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">Cantidad pedida</Font></B></TD>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">Precio de lista</Font></B></TD>
	cMsg += '</TR>

	While (_cAlias1)->(!Eof())

		cMsg += '<TR BgColor=#ffffff>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial"><b>'+AllTrim((_cAlias1)->B2_COD)+'</b></Font></TD>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial">'+AllTrim((_cAlias1)->B1_DESC)+'</Font></TD>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial">'+cValToChar((_cAlias1)->B1_XLM)+'</Font></TD>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial">'+cValToChar((_cAlias1)->A02_QATU)+'</Font></TD>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial">'+cValToChar((_cAlias1)->A03_QATU)+'</Font></TD>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial">'+cValToChar((_cAlias1)->(A02_QATU+A03_QATU))+'</Font></TD>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial">'+cValToChar((_cAlias1)->(A02_QPEDVEN+A03_QPEDVEN+A02_RESERVA+A03_RESERVA))+'</Font></TD>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial">'+cValToChar((_cAlias1)->PEDCOM)+'</Font></TD>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial">'+TRANSFORM((_cAlias1)->PRECO , "@E 99,999,999.99")+'</Font></TD>
		cMsg += '</TR>'

		(_cAlias1)->(DbSkip())
	EndDo

	cMsg += '</body></html>'

	_cEmail	  := GetMv("COFAT1801",,"renato.oliveira@steck.com.br")
	_cCopia   := AllTrim(GetMv("COFAT1804",,"jaqueline.silva@steck.com.br;renato.oliveira@steck.com.br"))
	_cAssunto := "[WFPROTHEUS] - Resumen de stock (1)
	_aAttach  := {}
	_cCaminho := "\arquivos\colombia\wf_estoque\"

	cArqXML1	:= _cCaminho + cNewEmp + "_" + Dtos(dDataBase) + "_01.xml" 
	AADD(_aAttach, cArqXML1)

	nHdlXml   := FCreate(cArqXML1,0)
	If nHdlXml > 0
		FWrite(nHdlXml,cMsg)
		FClose(nHdlXml)
	Endif

	u_COMAILTES(_cEmail,_cCopia,_cAssunto,cMsg,_aAttach,"")

	(_cAlias1)->(dbGoTop())

	//Vendedores
	cMsg := ""
	cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
	cMsg += '<Table Align=Center CELLPADDING=4 CELLSPACING=0 Width=60%>
	cMsg += '<tr><td><img src="http://www.appstk.com.br/imagens/logo1.jpg"></td>
	cMsg += '<td><b><font color="red">STECK ANDINA</font><br>INVENTARIO '+DTOC(Date())+'</b><br></td></tr>
	cMsg += '</table><br>
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>
	cMsg += '<TR BgColor=#ff0000>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">Código</Font></B></TD>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">Descripción</Font></B></TD>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">Empaque Estandar</Font></B></TD>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">ZONA FRANCA</Font></B></TD>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">NACIONALIZADO</Font></B></TD>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">TOTAL</Font></B></TD>
	cMsg += '<TD><B><Font Color="white" Size="3" Face="Arial">Cantidad comprometida</Font></B></TD>
	cMsg += '</TR>

	While (_cAlias1)->(!Eof())

		cMsg += '<TR BgColor=#ffffff>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial"><b>'+AllTrim((_cAlias1)->B2_COD)+'</b></Font></TD>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial">'+AllTrim((_cAlias1)->B1_DESC)+'</Font></TD>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial">'+cValToChar((_cAlias1)->B1_XLM)+'</Font></TD>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial">'+cValToChar((_cAlias1)->A02_QATU)+'</Font></TD>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial">'+cValToChar((_cAlias1)->A03_QATU)+'</Font></TD>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial">'+cValToChar((_cAlias1)->(A02_QATU+A03_QATU))+'</Font></TD>
		cMsg += '<TD><Font Color="#000000" Size="2" Face="Arial">'+cValToChar((_cAlias1)->(A02_QPEDVEN+A03_QPEDVEN+A02_RESERVA+A03_RESERVA))+'</Font></TD>
		cMsg += '</TR>'

		(_cAlias1)->(DbSkip())
	EndDo

	cMsg += '</body></html>'

	_cEmail	  := GetMv("COFAT1802",,"renato.oliveira@steck.com.br")
	_cCopia   := ""
	_cAssunto := "[WFPROTHEUS] - Resumen de stock (2)
	_aAttach  := {}
	_cCaminho := "\arquivos\colombia\wf_estoque\"

	cArqXML2	:= _cCaminho + cNewEmp + "_" + Dtos(dDataBase) + "_02.xml" 
	AADD(_aAttach, cArqXML2)

	nHdlXml   := FCreate(cArqXML2,0)
	If nHdlXml > 0
		FWrite(nHdlXml,cMsg)
		FClose(nHdlXml)
	Endif

	u_COMAILTES(_cEmail,_cCopia,_cAssunto,cMsg,_aAttach,"")

Return()
