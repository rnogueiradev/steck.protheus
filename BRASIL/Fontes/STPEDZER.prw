#include 'PROTHEUS.CH'
#include 'TOPCONN.CH'
#include 'TBICONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STPEDZER	ºAutor  ³Renato Nogueira     º Data ³  25/08/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Enviar email com os numeros de pedido que estão com preço	  º±±
±±º          ³zerado								   				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ 		                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STPEDZER()

	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"
	Local aUsuario	:= {}
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := ''
	Local cMsg	    := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''

	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"FAT")

	cQuery	:= " SELECT DISTINCT C6_FILIAL, C6_NUM, C5_EMISSAO, A1_NOME "
	cQuery	+= " FROM ( "
	cQuery	+= " SELECT C6_FILIAL, C6_NUM, C6_PRODUTO, C6_ITEM, C6_PRCVEN, A1_NOME "
	cQuery  += " FROM "+RetSqlName("SC6")+" C6 "
	cQuery  += " LEFT JOIN "+RetSqlName("SA1")+" A1"
	cQuery  += " ON A1.A1_COD=C6.C6_CLI AND A1.A1_LOJA=C6.C6_LOJA "
	cQuery  += " WHERE C6.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND A1_TIPO='X' "
	cQuery  += " AND C6_PRCVEN=0 AND C6_BLQ=' ' AND C6_QTDVEN-C6_QTDENT>0 ) "
	cQuery  += " LEFT JOIN "+RetSqlName("SC5")+" C5 "
	cQuery  += " ON C5_FILIAL=C6_FILIAL AND C6_NUM=C5_NUM AND C5.D_E_L_E_T_=' ' "
	cQuery  += " ORDER BY C6_NUM "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())
	
		_cEmail	  := " ana.figueiredo@steck.com.br;Arisla.Aciardi@steck.com.br"
		_cAssunto := 'O pedido: '+(cAlias)->C6_NUM+' filial: '+(cAlias)->C6_FILIAL+' está com preço zerado'
		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<b>Cliente: </b>'+(cAlias)->A1_NOME+'<br></body></html>'
	
		If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			Conout("Problemas no envio de email!")
		EndIf
	
		(cAlias)->(DbSkip())
	EndDo

	Reset Environment

Return()
