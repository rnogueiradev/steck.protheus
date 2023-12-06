#include 'PROTHEUS.CH'
#include 'TOPCONN.CH'
#include 'TBICONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTVALRE	บAutor  ณRenato Nogueira     บ Data ณ  27/08/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGestใo de regime especial 							   	 บฑฑ
ฑฑบ          ณ									   				    	 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ 		                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STVALRE()

	Local cQuery 		:= ""
	Local cAlias 		:= "QRYTEMP"
	Local aUsuario	:= {}
	Local _cEmail   	:= ""
	Local _cCopia   	:= ""
	Local _cAssunto 	:= ''
	Local cMsg	      	:= ""
	Local cAttach   	:= ''
	Local _aAttach  	:= {}
	Local _cCaminho 	:= ''
	
	//Empresa 01

	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"FAT")

	cQuery := " SELECT A1_COD, A1_LOJA, A1_NOME, A1_XVALRE, A1_MSBLQL, "
	cQuery += " TO_CHAR(SYSDATE,'YYYYMMDD') DATAATUAL "
	cQuery += " FROM "+RetSqlName("SA1")+" A1 "
	cQuery += " WHERE A1.D_E_L_E_T_=' ' AND A1_XVALRE<>' ' AND A1_MSBLQL='2' "
	cQuery += " AND A1_XVALRE<TO_CHAR(SYSDATE,'YYYYMMDD') "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())
	
		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(DbGoTop())
		If SA1->(DbSeek(xFilial("SA1")+(cAlias)->(A1_COD+A1_LOJA)))
		
			SA1->(RecLock("SA1",.F.))
			SA1->A1_MSBLQL	:= "1"
			SA1->A1_XHISTOR	:= SA1->A1_XHISTOR+" - "+DTOC(Date())+" - CLIENTE BLOQUEADO AUTOMATICAMENTE POR REGIME ESPECIAL VENCIDO"
			SA1->(MsUnLock())
		
			_cEmail   := GetMv("ST_STVALRE")
			_cAssunto := '[STECK SP] - Cliente: '+(cAlias)->A1_COD+' loja: '+(cAlias)->A1_LOJA+' bloqueado - RE vencido'
			cMsg := ""
			cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
			cMsg += '<b>Cliente bloqueado</b></body></html>'
	
			If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
				Conout("Problemas no envio de email!")
			EndIf
		
		EndIf
	
		(cAlias)->(DbSkip())
		
	EndDo

	Reset Environment
	
	//Empresa 03
	
	RpcSetType( 3 )
	RpcSetEnv("03","01",,,"FAT")

	cQuery	:= " SELECT A1_COD, A1_LOJA, A1_NOME, A1_XVALRE, A1_MSBLQL, "
	cQuery += " TO_CHAR(SYSDATE,'YYYY')||TO_CHAR(SYSDATE,'MM')||TO_CHAR(SYSDATE,'DD') AS DATAATUAL "
	cQuery	+= " FROM "+RetSqlName("SA1")+" A1 "
	cQuery += " WHERE A1.D_E_L_E_T_=' ' AND A1_XVALRE<>' ' AND A1_MSBLQL='2' "
	cQuery += " AND A1_XVALRE<TO_CHAR(SYSDATE,'YYYY')||TO_CHAR(SYSDATE,'MM')||TO_CHAR(SYSDATE,'DD') "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())
	
		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(DbGoTop())
		If SA1->(DbSeek(xFilial("SA1")+(cAlias)->(A1_COD+A1_LOJA)))
		
			SA1->(RecLock("SA1",.F.))
			SA1->A1_MSBLQL	:= "1"
			SA1->A1_XHISTOR	:= SA1->A1_XHISTOR+" - "+DTOC(Date())+" - CLIENTE BLOQUEADO AUTOMATICAMENTE POR REGIME ESPECIAL VENCIDO"
			SA1->(MsUnLock())
		
			_cEmail   := GetMv("ST_STVALRE")
			_cAssunto := '[STECK AM] - Cliente: '+(cAlias)->A1_COD+' loja: '+(cAlias)->A1_LOJA+' bloqueado - RE vencido'
			cMsg := ""
			cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
			cMsg += '<b>Cliente bloqueado</b></body></html>'
	
			If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
				Conout("Problemas no envio de email!")
			EndIf
		
		EndIf
	
		(cAlias)->(DbSkip())
		
	EndDo

	Reset Environment

Return()