#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STCOMA50
@name STCOMA50
@type User Function
@desc enviar wf de pedidos gerados
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STCOMA52()

U_STCOMA50("11","01")

Return()

User Function STCOMA50(cNewEmp,cNewFil)

	Default cNewEmp 	:= "01"
	Default cNewFil		:= "01"

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	ConOut(CRLF + "[STCOMA50]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	SM0->(DBGoTop())
	While SM0->(!Eof())
		If SM0->M0_CODIGO$"01#03#11"
			ConOut(CRLF + "[STCOMA51]["+ FWTimeStamp(2) +"] Inicio do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))
			StartJob("U_STCOMA51",GetEnvServer(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL)
			ConOut(CRLF + "[STCOMA51]["+ FWTimeStamp(2) +"] Fim do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))
		EndIf
		SM0->(DbSkip())
	EndDo

	ConOut("[STCOMA50]["+ FWTimeStamp(2) +"] Fim do processamento")

	Reset Environment

Return

/*/{Protheus.doc} STCOMA51
@name STCOMA51
@type User Function
@desc enviar wf
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STCOMA51(cNewEmp,cNewFil)

	Local _cQuery1 	:= ""
	Local _cAlias1 	:= GetNextAlias()
	Local _cQuery2 	:= ""
	Local _cAlias2 	:= GetNextAlias()
	Local _cCopia  	:= ""
	Local _aAttach 	:= {}
	Local _cCaminho	:= ""
	Default cNewEmp := "01"
	Default cNewFil := "04"

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	If !LockByName("STCOMA50",.T.,.T.)
		ConOut("[STCOMA50]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	_cQuery1 := " SELECT DISTINCT C8_FILIAL, C8_NUM, C8_FORNECE, C8_LOJA, C8_NUMPED, C8_XWFPED, A2_EMAIL, NVL(Y1_EMAIL,' ') AS Y1_EMAIL, C7_COMPSTK, A2_CGC
	_cQuery1 += " FROM "+RetSqlName("SC8")+" C8
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA2")+" A2
	_cQuery1 += " ON A2_COD=C8_FORNECE AND A2_LOJA=C8_LOJA
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC7")+" C7
	_cQuery1 += " ON C7_FILIAL=C8_FILIAL AND C7_NUM=C8_NUMPED AND C7_FORNECE=C8_FORNECE AND C7_LOJA=C8_LOJA
	_cQuery1 += "  LEFT JOIN(SELECT * FROM "+RetSqlName("SY1")+")SY1 ON SY1.D_E_L_E_T_ =' ' AND Y1_COD = C7_COMPSTK
	_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND A2.D_E_L_E_T_=' ' AND C7.D_E_L_E_T_=' '
	_cQuery1 += " AND C8_EMISSAO>='20181201' AND C8_XWFPED=' '  AND C8_NUMPED<>' ' AND C7_CONAPRO='L'
	_cQuery1 += " AND C8_FILIAL='"+cNewFil+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_cEmail := AllTrim((_cAlias1)->A2_EMAIL)
		//_cCopia := "renato.oliveira@steck.com.br;"//+ AllTrim((_cAlias1)->Y1_EMAIL)
		_aAttach := {}

		_cAssunto := '[STECK] - Processo de Cotação No. '+(_cAlias1)->C8_NUM

		cMsg := ' <html><head><title>Cotação - Steck</title></head>
		cMsg += ' <body>
		cMsg += ' <img src="http://www.appstk.com.br/portal_cliente/imagens/teckinho.jpg">
		cMsg += ' <br><font size="5" color=#ff0000>Processo de Cotação No. <b>'+(_cAlias1)->C8_NUM+'</b></font>
		cMsg += ' <br><br>
		cMsg += ' <font size="3" face="Arial" size="4" bgcolor=#afeeee background="">

		If SubStr((_cAlias1)->C8_NUMPED,1,1)=="X" //Perdeu
			cMsg += ' Infelizmente você não ganhou esse processo de cotação, boa sorte nas próximos processos!<br><br>
		Else

			_cEmpresa := ""

			If cNewEmp=="01" .Or. cNewEmp=="11"
				_cEmpresa := "São Paulo / Filial "+cNewFil
			Else
				_cEmpresa := "Manaus / Filial "+cNewFil
			EndIf

			cMsg += ' Parabéns! Você ganhou o processo dessa cotação, o número do pedido gerado é o '+(_cAlias1)->C8_NUMPED+', por favor siga os passos abaixo para confirmar seu pedido.
			cMsg += ' <br><br>
			cMsg += ' 1. Acesse o portal pelo link https://portalfornecedor.steck.com.br/login.php<br>
			cMsg += ' 2. Faça o login com o CNPJ '+(_cAlias1)->A2_CGC+' pela empresa '+_cEmpresa+'<br>'
			cMsg += ' 3. Utilize o link https://portalfornecedor.steck.com.br/editar_pedido.php?cChave='+(_cAlias1)->C8_NUMPED+' para acessar seu pedido.<br>
			cMsg += ' 4. Confira os dados do seu pedido para verificar se estão corretos.<br>
			cMsg += ' 5. Utilize o botão Imprimir pedido para confirmar o mesmo

			cMsg += ' <br><br>
		EndIf

		cMsg += ' Obrigado por ter participado do processo de cotação da STECK.<br><br>

		cMsg += ' Esta é uma mensagem automática. Por favor, não responda este e-mail

		AADD(_aAttach,SuperGetMv("ST_COM0002",.F.,"\portal_fornecedor\condicoes_gerais_steck.pdf"))

		DbSelectArea("SC7")
		SC7->(DbSetOrder(3))
		SC7->(DbGoTop())
		If SC7->(DbSeek((_cAlias1)->(C8_FILIAL+C8_FORNECE+C8_LOJA+C8_NUMPED)))

			U_RSTFAT92()

			DbSelectArea("SY1")
			SY1->(DbSetOrder(1))
			SY1->(DbGoTop())
			If SY1->(DbSeek(xFilial("SY1")+(_cAlias1)->C7_COMPSTK))
				_cCopia := SY1->Y1_EMAIL
			EndIf

		EndIf

		_cNomePdf := "\pedido_compra\"+cEmpAnt+"_"+SC7->C7_NUM+".pdf"

		AADD(_aAttach,_cNomePdf)

		_cCopia += SuperGetMv("ST_COM0004",.F.,"")
		//cPara := "renato.oliveira@steck.com.br"

		If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			//If !U_STMAILZ1A(cPara, "", _cAssunto, cMsg,_aAttach,_cCaminho,"")
			Conout("Problemas no envio de email!"+" - Cotação: "+(_cAlias1)->C8_NUM)
		Else

			_cQuery2 := " SELECT C8.R_E_C_N_O_ RECSC8
			_cQuery2 += " FROM "+RetSqlName("SC8")+" C8
			_cQuery2 += " WHERE C8.D_E_L_E_T_=' ' AND C8_FILIAL='"+(_cAlias1)->C8_FILIAL+"'"
			_cQuery2 += " AND C8_NUM='"+(_cAlias1)->C8_NUM+"' AND C8_FORNECE='"+(_cAlias1)->C8_FORNECE+"'"
			_cQuery2 += " AND C8_LOJA='"+(_cAlias1)->C8_LOJA+"' AND C8_NUMPED='"+(_cAlias1)->C8_NUMPED+"'"

			If !Empty(Select(_cAlias2))
				DbSelectArea(_cAlias2)
				(_cAlias2)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

			dbSelectArea(_cAlias2)
			(_cAlias2)->(dbGoTop())

			While (_cAlias2)->(!Eof())

				DbSelectArea("SC8")
				SC8->(DbGoTop())
				SC8->(DbGoTo((_cAlias2)->RECSC8))

				If SC8->(!Eof())
					SC8->(RecLock("SC8",.F.))
					SC8->C8_XWFPED := "S"
					SC8->(MsUnLock())
				EndIf

				SC7->(DbSetOrder(1))
				SC7->(DbGoTop())
				If SC7->(DbSeek(SC8->(C8_FILIAL+C8_NUMPED+C8_ITEMPED)))
					SC7->(RecLock("SC7",.F.))
					SC7->C7_XENV := "S"
					SC7->(MsUnLock())
				EndIf

				(_cAlias2)->(DbSkip())
			EndDo

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	UnLockByName("STCOMA50",.T.,.T.)

	Reset Environment

Return
