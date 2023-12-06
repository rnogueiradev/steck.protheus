#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M020INC  � Autor � Vitor Merguizo     � Data �  27/01/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Efetua a grava��o do Item Contabil (CTD) autom�ticamente   ���
���          � Conforme defini��o do projeto, o item contabil registrar�  ���
���          � a contabiliza��o de Clientes, permitindo               ���
���          � que a contabilidade tenha um plano de contas "exuto".      ���
���          �                                                            ���
���          � O cadastro de itens contabeis  ser� composto de:           ���
���          �                                                            ���
���          � Clientes:"1"+ALLTRIM(SA1->A1_COD)+ALLTRIM(SA1->A1_LOJA)���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Steck                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M030INC()

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������

	Local _cItemContab	:= "1"+ALLTRIM(SA1->A1_COD)+ALLTRIM(SA1->A1_LOJA)
	Local _cQuery 		:= ""
	Local cAlias 		:= "QRYTEMP"

	Local cCampNS		:= "A1_XNSEG"
	Local cContNS		:= SA1->A1_XNSEG
	Local cTituNS		:= ""
	Local cHistNS		:= ""

	Local cCampBF		:= "A1_XBLQFIN"
	Local cContBF		:= SA1->A1_XBLQFIN
	Local cTituBF		:= ""
	Local cHistBF		:= ""

	Local cCampBP		:= "A1_XBLOQF"
	Local cContBP		:= SA1->A1_XBLOQF
	Local cTituBP		:= ""
	Local cHistBP		:= ""

	Local cCliInc		:= SA1->A1_COD
	Local cLojInc		:= SA1->A1_LOJA

	Local _cQuery8  := ""
	Local _cAlias8  := GetNextAlias()

	dbSelectArea("CTD")
	dbSetOrder(1)

	if !CTD->( dbSeek( xfilial("CTD")+_cItemContab ) )

		Reclock("CTD",.T.)
		CTD->CTD_FILIAL		:=	xFilial("CTD")
		CTD->CTD_ITEM		:=	alltrim(_cItemContab)
		CTD->CTD_CLASSE		:=	"2"
		CTD->CTD_NORMAL		:=	"0"
		CTD->CTD_DESC01		:=	alltrim(SA1->A1_NOME)
		CTD->CTD_BLOQ		:=	"2"
		CTD->CTD_DTEXIS		:=	Ctod("01/01/80")
		MsUnlock()

		dbSelectArea("SA1")
		RecLock("SA1",.F.)
		SA1->A1_E_ITEM :=	_cItemContab
		MsUnlock()

	Else

		dbSelectArea("SA1")

	Endif

	dbSelectArea("SA1")
	RecLock("SA1",.F.)
	SA1->A1_XIDBRA := U_STFINDV1(SA1->A1_COD)

	If ! Empty(SA1->A1_XNSEG)		// Grava  historico caso seja digitada a informacao do campo A1_XNSEG - Richard - 24/04/18
		DbSelectArea("SX3")
		SX3->(DbGoTop())
		SX3->(DbSetOrder(2))
		SX3->(DbSeek(cCampNS))
		cTituNS := SX3->X3_TITULO
		DbSelectArea("SA1")
		cHistNS := "Usu�rio: " + cUserName + " - Inclu�do em: " + DTOC(dDataBase) + " " + TIME() + " Campo: " + Alltrim(cTituNS) + " - Conte�do: " + Alltrim(SA1->A1_XNSEG) + CRLF + SA1->A1_XHISTOR
		SA1->A1_XHISTOR := cHistNS
	EndIf

	If ! Empty(SA1->A1_XBLQFIN)		// Grava  historico caso seja digitada a informacao do campo A1_XBLQFIN - Richard - 04/05/18 - Chamado 007309
		DbSelectArea("SX3")
		SX3->(DbGoTop())
		SX3->(DbSetOrder(2))
		SX3->(DbSeek(cCampBF))
		cTituBF := SX3->X3_TITULO
		DbSelectArea("SA1")
		cHistBF := "Usu�rio: " + cUserName + " - Inclu�do em: " + DTOC(dDataBase) + " " + TIME() + " Campo: " + Alltrim(cTituBF) + " - Conte�do: " + Alltrim(SA1->A1_XBLQFIN) + CRLF + SA1->A1_XHISTOR
		SA1->A1_XHISTOR := cHistBF
	EndIf

	If ! Empty(SA1->A1_XBLOQF)		// Grava  historico caso seja digitada a informacao do campo A1_XBLOQF - Richard - 04/05/18 - Chamado 007309
		DbSelectArea("SX3")
		SX3->(DbGoTop())
		SX3->(DbSetOrder(2))
		SX3->(DbSeek(cCampBP))
		cTituBP := SX3->X3_TITULO
		DbSelectArea("SA1")
		cHistBP := "Usu�rio: " + cUserName + " - Inclu�do em: " + DTOC(dDataBase) + " " + TIME() + " Campo: " + Alltrim(cTituBP) + " - Conte�do: " + Alltrim(SA1->A1_XBLOQF) + CRLF + SA1->A1_XHISTOR
		SA1->A1_XHISTOR := cHistBP
	EndIf

	MsUnlock()

	If ! Empty(SA1->A1_XNSEG)	// Atualiza o conteudo e historico para as demais lojas do mesmo cliente - Richard - 24/04/18
		U_AtuCliNS(cCliInc,cLojInc,cContNS,cHistNS,"NS")
	EndIf

	If ! Empty(SA1->A1_XBLQFIN)	// Atualiza o conteudo e historico para as demais lojas do mesmo cliente - Richard - 04/05/18 - Chamado 007309
		U_AtuCliNS(cCliInc,cLojInc,cContBF,cHistBF,"BF")
	EndIf

	If ! Empty(SA1->A1_XBLOQF)	// Atualiza o conteudo e historico para as demais lojas do mesmo cliente - Richard - 04/05/18 - Chamado 007309
		U_AtuCliNS(cCliInc,cLojInc,cContBP,cHistBP,"BP")
	EndIf
	/*
	_cQuery := " SELECT COUNT(*) CONTADOR "
	_cQuery += " FROM SA1030 A1 "
	_cQuery += " WHERE A1.D_E_L_E_T_=' ' AND A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD='"+SA1->A1_COD+"' AND A1_LOJA='"+SA1->A1_LOJA+"' "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	If (cAlias)->CONTADOR=0

		If !IsBlind()
			If cEmpAnt == "01" .And. PARAMIXB <> 3
				If msgyesno("Deseja copiar o cliente para a empresa Manaus?")
					U_STCOPIREG("SA1","01","03","01") //Copiar cliente para AM
				EndIf
			EndIf
		EndIf

	EndIf
	
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
	*/
	_cQuery8 := " SELECT *
	_cQuery8 += " FROM "+RetSqlName("SZV")+" ZV
	_cQuery8 += " WHERE ZV.D_E_L_E_T_=' ' AND '"+SA1->A1_CEP+"' BETWEEN ZV_CEPDE AND ZV_CEPATE

	If !Empty(Select(_cAlias8))
		DbSelectArea(_cAlias8)
		(_cAlias8)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery8),_cAlias8,.T.,.T.)

	dbSelectArea(_cAlias8)

	(_cAlias8)->(dbGoTop())

	If (_cAlias8)->(Eof())

		_cEmail		:= GetMv("MT410TOK01",,"renato.oliveira@steck.com.br;kleber.braga@steck.com.br")
		_cAssunto 	:= "[WFPROTHEUS] - Cliente sem rota na TNT"

		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<b>Cnpj: </b>'+SA1->A1_CGC+'<br>
		cMsg += '<b>Nome: </b>'+SA1->A1_NOME+'<br>
		cMsg += '<b>Endere�o: </b>'+SA1->A1_END+'<br>
		cMsg += '<b>Complemento: </b>'+SA1->A1_COMPLEM+'<br>
		cMsg += '<b>Estado: </b>'+SA1->A1_EST+'<br>
		cMsg += '<b>C�d. Munic.: </b>'+SA1->A1_COD_MUN+'<br>
		cMsg += '<b>Munic�pio: </b>'+SA1->A1_MUN+'<br>
		cMsg += '<b>Bairro: </b>'+SA1->A1_BAIRRO+'<br>
		cMsg += '<b>DDD: </b>'+SA1->A1_DDD+'<br>
		cMsg += '<b>Telefone: </b>'+SA1->A1_TEL+'<br>
		cMsg += '<b>Cep: </b>'+SA1->A1_CEP+'<br>
		cMsg += '<b>Inscri��o estadual: </b>'+SA1->A1_INSCR+'<br>
		cMsg += '</body></html>'

		U_STMAILTES(_cEmail,"",_cAssunto, cMsg,{},"")

	EndIf

Return(.T.)

User Function AtuCliNS(cCliInc,cLojInc,cContRx,cHistRx,cOrig)

	Local aArea := GetArea()
	Local aAreaSA1 := SA1->(GetArea())

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1") + cCliInc))
	Do While SA1->A1_FILIAL + SA1->A1_COD = xFilial("SA1") + cCliInc .And. ! SA1->(Eof())
		If SA1->A1_LOJA <> cLojInc
			RecLock("SA1",.F.)
			If cOrig = "NS"
				SA1->A1_XNSEG := cContRx
			ElseIf cOrig = "BF"
				SA1->A1_XBLQFIN := cContRx
			ElseIf cOrig = "BP"
				SA1->A1_XBLOQF := cContRx
			EndIf
			SA1->A1_XHISTOR := cHistRx
			SA1->(MsUnLock())
		EndIf
		SA1->(DbSkip())
	EndDo

	SA1->(RestArea(aAreaSA1))
	RestArea(aArea)

Return
