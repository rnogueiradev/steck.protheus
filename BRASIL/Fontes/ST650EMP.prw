#Include "Protheus.CH"
#Include "TOTVS.CH"
#include "topconn.ch"


/*/{Protheus.doc} ST650EMP
    (long_description)
    Rotina verifica se componente do produto não tem saldo
    @type  Function
    @author user
    Valdemir Rabelo
    @since 06/04/2020
    @version version
    @param 
/*/
User Function ST650EMP()
	Local cChave    := SC2->(C2_FILIAL+C2_PRODUTO)
	Local aAreaG    := GetArea()
	Local cGrupos   := SuperGetMV("STGRPCOMPR",.F.,"005,039,040,041,042,047,110,117,122,127")
	Local nQtdPai   := SC2->C2_QUANT             
	Local nLeadT    := 0
	Local nLeadTP   := 0
	Local nSaldo    := 0
	Local cCODPAI   := SC2->C2_PRODUTO
	Local cNumPed   := SC5->C5_NUM         // Valdemir Rabelo 01/07/2020
	Local lCria     := .F.
	Local cClassi   := ""
	Local nPrazoZ77 := 0                  // Valdemir Rabelo 01/07/2020
	Local nREGPP8   := 0                  // Valdemir Rabelo 01/07/2020
	Local aSBZ      := {}
	Local cEmail    := SuperGetMV("ST_EMLSBZ",.F.,"lucas.machado@steck.com.br,rodrigo.ferreira@steck.com.br,ulisses.almeida@steck.com.br,alex.lourenco@steck.com.br")

	dbSelectArea("SD4")
	dbSetOrder(2)

	dbSelectArea("SB1") // Posiciono SB1
	dbSetOrder(1)
	if !dbSeek(xFilial("SB1")+cCODPAI)
		MsgInfo("Produto: "+alltrim(cCODPAI)+" não encontrado (Tabela: SB1)","Atenção!")
		Return
	ENDIF

	// ------ Valdemir Rabelo 17/06/2020 -------------
	dbSelectArea("PP8")
	nREGPP8 := GetPP8(cNumPed, cCODPAI)      // Posiciona registro da PP8 com base na SC6

	if nREGPP8 > 0
		PP8->( dbGoto(nREGPP8) )

		// Ticket: 20200701003633 - Valdemir Rabelo 22/04/2021
		cClassi := PadL(Alltrim(Left(PP8->PP8_CLASSI,3)),3,'0')
		if (cClassi== '000')
			cClassi := PadL(Alltrim(Left(SB1->B1_XCLASSI,3)),3,'0')
			if Empty(cClassi) .OR. (cClassi== '000')
				aAdd(aSBZ, {"PRODUTO: "+Alltrim(cCODPAI),"NÃO CONTÉM CLASSIFICAÇÃO ",'SB1 / PP8'})				
				if (Len(aSBZ) > 0)
					EnvMail(cEmail, aSBZ)
				endif
            MsgInfo('Não será gerado o compromisso. Produto: '+Alltrim(cCODPAI)+' não tem classificação','Atenção!')
            Return
			endif
		endif
		// -----------------------

		dbSelectArea("Z77")          // Classificação de Processos - Chamado: 20200403001451
		dbSetOrder(1)
		IF !dbSeek(XFilial('Z77')+cClassi)
			MsgInfo("Classificação: "+ALLTRIM(cClassi)+" não encontrado (Tabela: Z77)"+CRLF+;
				"Não será gerado o compromisso","Atenção!")
			Return
		Endif

		nPrazoZ77 := Z77->Z77_PRAZO

	endif
	// --------------------------------------


/*         Removido conforme solicitação do Lucas 01/09/2020 - chamado: 20200103000022
    dbSelectArea("SBZ") // posiciono SBJ - 12/06/2020 - BZ_PE     
    dbSetOrder(1)
	if !dbSeek(xFilial("SBZ")+cCODPAI)
       MsgInfo("Produto: "+alltrim(cCODPAI)+" não encontrado (Tabela: SBZ)","Atenção!")
       Return
	else
       nLeadTP := SBZ->BZ_PE 
	Endif
*/    

	if !(ALLTRIM(SB1->B1_GRUPO) $ cGrupos)
		return
	Endif

	SD4->( dbSetOrder(1) )

	dbSelectArea('SG1')
	dbSetOrder(1)
	dbSeek(xFilial('SG1')+cCODPAI)
	While SG1->( !Eof() ) .and. (SG1->G1_FILIAL+SG1->G1_COD==cChave)

		IF SB1->( !dbSeek(xFilial("SB1")+SG1->G1_COMP) )
			aAdd(aSBZ, {"PRODUTO: "+Alltrim(SG1->G1_COMP),"NÃO CADASTRADO - CADASTRO DE PRODUTOS (SB1)"})
		ENDIF

		// Se o produto não fizer parte dos grupos que não deverá continuar
		//if (ALLTRIM(SB1->B1_GRUPO) $ cGrupos)
		//  SG1->( dbSkip() )
		//  Loop
		//Endif

		IF SD4->( dbSeek(xFilial('SD4')+SG1->G1_COMP+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) ) ) .and. (SB1->B1_CLAPROD $ "C/I")    // Verifica se existe empenho

			if ((cFilAnt=="05") .And. (SD4->D4_LOCAL $ "01/03")) .or. ((cFilAnt=="02") .And. (SD4->D4_LOCAL == "03"))  // Valdemir Rabelo 27/08/2020
				DbSelectArea("SB2")
				SB2->(DbSetOrder(1))
				If SB2->(DbSeek(xFilial("SB2")+SD4->D4_COD+SD4->D4_LOCAL  ))                    // Verifico o Saldo
					nSaldo := SaldoSb2()
				EndIf

				//IF (SD4->D4_QUANT > 0) .AND. (SD4->D4_QUANT != SD4->D4_QTDEORI)                // Se não foi, ou se o empenho não foi total
				IF (nSaldo < SD4->D4_QUANT)                                                 // Se não existe saldo
					// Valdemir Rabelo 17/06/2020
					//if SB1->( dbSeek(xFilial("SB1")+SG1->G1_COMP) )    // Ticket: 20201127011295 - Mudança de SBZ para SB1 Valdemir Rabelo
					if SB1->B1_PE > nLeadT
						nLeadT := SB1->B1_PE
					endif
					if nLeadT > 0
						lCria  := .T.
					else
						//>>Ticket 20210223003009 - Everson Santana - 01/03/2021
						aAdd(aSBZ, {"PRODUTO: "+Alltrim(SG1->G1_COMP),"NÃO CADASTRADO - LEAD TIME ",SD4->D4_OP})
						//<<Ticket 20210223003009
					Endif
					//Else
					//   aAdd(aSBZ, {"PRODUTO: "+Alltrim(SG1->G1_COMP),"NÃO CADASTRADO - INDICADORES PRODUTOS"})
					//Endif
				Else
					lCria  := .T.
				ENDIF

			Endif

		ENDIF

		SG1->( dbSkip() )
	EndDo
	if (Len(aSBZ) > 0)  // Caso exista indicadores não cadastrado, não gerar compromisso 03/09/2020
		lCria := .F.
	Else
		if lCria
			nLeadT += (nLeadTP+nPrazoZ77)                   // Valdemir Rabelo 17/06/2020
			GrvZZJ(nQtdPai, 'SD4', cCODPAI, nLeadT)         // Cria o compromisso - 20200103000022
		Endif
	Endif

	// Valdemir Rabelo - 20/08/2020
	if (Len(aSBZ) > 0)
		EnvMail(cEmail, aSBZ)
	endif

	RestArea( aAreaG )

Return


/*/{Protheus.doc} GrvZZJ
    (long_description)
    Rotina Grava Compromisso e Atualiza SC6
    @type  Function
    @author user
    Valdemir Rabelo
    @since 07/04/2020
    @version version
    @param 
/*/
Static Function GrvZZJ(nQtdPai, pAliasSD4, pCodPai, nLeadT)
	Local cNumZZJ := GETSXENUM("ZZJ","ZZJ_NUM")
	Local aAreaZJ := GetArea()
	Local _cQuery := ""
	Local _cQry   := ""
	Local nQtde   := 0
	Local aMsgEnt := {}
	Local cEmail  := SuperGetMV("ST_EMLLEAD",.F.,'ulisses.almeida@steck.com.br,alex.lourenco@steck.com.br,julianny.bernardo@steck.com.br,juliana.queiroz@steck.com.br,lucas.machado@steck.com.br')
	Local AliasPA1:= GetNextAlias()

	// Cria registro ZZJ referente a quantidade informada
	DbSelectArea("ZZJ")
	RecLock("ZZJ", .T.)
	ZZJ->ZZJ_FILIAL 	:= " "
	ZZJ->ZZJ_NUM 		:= cNumZZJ
	ZZJ->ZZJ_COD 		:= pCodPai
	ZZJ->ZZJ_QUANT	:= nQtdPai
	ZZJ->ZZJ_LOCAL   := (pAliasSD4)->D4_LOCAL
	ZZJ->ZZJ_DATA		:= dDATABASE+nLeadT
	ZZJ->ZZJ_OP 		:= (pAliasSD4)->D4_OP
	//ZZJ->ZZJ_TRANSP		:= ''
	ZZJ->ZZJ_USUARI	:= __cUserId
	ZZJ->ZZJ_NOME	  	:= cUserName
	MsUnLock()

	// Conforme alinhamento com Lucas, as filiais que estão como fixo, precisam buscar a informação na 02 - Valdemir Rabelo 01/09/2020

	_cQuery := "SELECT * FROM " + RETSQLNAME("PA1") + " PA1 " + CRLF
	_cQuery += "WHERE PA1.D_E_L_E_T_ = ' ' " + CRLF
	_cQuery += " AND PA1.PA1_TIPO = '1'    " + CRLF
	_cQuery += " AND PA1.PA1_CODPRO = '"+pCodPai+"'        " + CRLF
	_cQuery += " AND PA1.PA1_FILIAL = '02' " + CRLF

	If Select(AliasPA1) > 0
		(AliasPA1)->( dbCloseArea() )
	endif
	TcQuery _cQuery New Alias (AliasPA1)

	While (AliasPA1)->( !Eof() )
		if nQtde <= nQtdPai
			_cQry := "UPDATE "+RETSQLNAME("SC6")+" SET C6_XPREV='"+ZZJ->ZZJ_NUM +"' " + CRLF
			_cQry += "WHERE D_E_L_E_T_ = ' '  " + CRLF
			_cQry += " AND C6_NUM || C6_ITEM= '"+(AliasPA1)->PA1_DOC+"' " + CRLF
			_cQry += " AND C6_FILIAL = '02'              " + CRLF
			TcSQLExec(_cQry)
		endif
		(AliasPA1)->( dbSkip() )
	EndDo

	If Select(AliasPA1) > 0
		(AliasPA1)->( dbCloseArea() )
	endif

	// Adicionando mensagem para WF - 24/08/2020 - VALDEMIR RABELO
	//Processa({|| U_STPREVATU('M') }, "Aguarde enviando e-Mail") Retiramos do ar para avaliar a quantidade de e-mil's. Everson Santana - 16.12.2020

	RestArea( aAreaZJ )

Return


/*/{Protheus.doc} GetPP8
description
Rotina que irá buscar o registro PP8 relacionado a Pedido
@type function
@version 
@author Valdemir Jose
@since 01/07/2020
@param cNumPed, character, param_description
@param cCODPAI, character, param_description
@return return_type, return_description
/*/
Static Function GetPP8(cNumPed, cCODPAI)
	Local nRET     := 0
	Local aAreaPP8 := GetArea()
	Local cQry     := ""

	// cQry += "SELECT B.R_E_C_N_O_ REG " + CRLF
	// cQry += "FROM " + RETSQLNAME("SC6") + " A      " + CRLF
	// cQRY += "INNER JOIN "+RETSQLNAME("PP8") + " B  " + CRLF
	// cQRY += "ON B.PP8_CODIGO=A.C6_XNUMUNI AND B.PP8_ITEM=A.C6_XITEUNI AND B.D_E_L_E_T_ = ' '  " + CRLF
	// cQry += "WHERE A.D_E_L_E_T_ = ' '          " + CRLF
	// cQry += " AND A.C6_NUM='" + cNumPed + "' " + CRLF
	// cQry += " AND A.C6_PRODUTO='" + cCODPAI + "' " + CRLF

	cQry += "SELECT B.R_E_C_N_O_ REG " + CRLF
	cQry += "FROM " + RETSQLNAME("PP8") + " B  " + CRLF
	cQry += "WHERE B.D_E_L_E_T_ = ' '          " + CRLF
	cQry += " AND B.PP8_PROD='" + cCODPAI + "' " + CRLF
	cQry += " AND B.PP8_FILIAL='02' " + CRLF

	IF SELECT("PP8T") > 0
		PP8T->( dbCloseArea() )
	ENDIF

	TcQuery cQry new Alias "PP8T"

	IF !EOF()
		nRET := PP8T->REG
	ENDIF

	IF SELECT("PP8T") > 0
		PP8T->( dbCloseArea() )
	ENDIF

	RestArea( aAreaPP8 )

Return nRET


/*/{Protheus.doc} EnvMail
   description
   @type function
   @version 
   @author Valdemir Jose
   @since 26/08/2020
   @param cEmail, character, param_description
   @param _aMsg, param_type, param_description
   @param _cAssunto, param_type, param_description
   @return return_type, return_description
/*/
Static Function EnvMail(cEmail, _aMsg, _cAssunto)
	Local aArea     := Getarea()
	Local cMsg      := ""
	Local cCC       := ""
	Local _nLin
	Local cFuncSent := "ST650EMP"
	DEFAULT _cAssunto := "PRODUTOS NÃO CADASTRADOS - LEAD TIME"

	//A Definicao do cabecalho do email
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'

	//A Definicao do texto/detalhe do email
	For _nLin := 1 to Len(_aMsg)

		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf

		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		If Len(_aMsg[_nLin,3]) > 0
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
		EndIf
	Next

	//A Definicao do rodape do email
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
	//cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1"></td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

	RestArea( aArea )

	U_STMAILTES(cEmail, cCC, _cAssunto, cMsg,{},"")

Return


