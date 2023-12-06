#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ MA030TOK  ºAutor  ³Renato Nogueira    º Data ³  08/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para validar clientes do estado MT  	  º±±
±±º          ³ 													          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------*
User Function MA030TOK()
	*------------------------*
	Local lRet	:= .T.
	Local aArea     := GetArea()
	Local _cEmail   	:= ""
	Local _cCopia   	:= ""
	Local _cAssunto 	:= ''
	Local cMsg	      	:= ""
	Local cAttach   	:= ''
	Local _aAttach  	:= {}
	Local _cCaminho 	:= ''
	//>> Chamado 005634 - Everson Santana
	Local _cSuper 	:= ""
	Local _cGrpClas	:= ""
	Local _lEst := .T.
	Local lSaida        := .f.
	Local aItems 		:= {"1 - Industrialização","2 - Consumo Próprio"}
	Local aTipo 		:= {"1 - Consumidor Final","2 - Revendedor","3 - Solidário"}
	Local cItem 		:= space(20)
	Local lSaida        := .f.
	Local lRest			:= .F.		//FR - 09/03/2022 - Flávia Rocha - Sigamat Consultoria - Alteração
	

	//FR - 09/03/2022 - Flávia Rocha - Sigamat Consultoria - Alteração
	If IsInCallStack("POST")
		lRest := .T.			
	Endif 

	/*
	If !(__cUserId $ GetMv("ST_UPDSA1",,"000800#001036"))
	MsgAlert("Usuário sem acesso para alterar/incluir clientes, verifique!")
	Return(.F.)
	EndIf
	*/
	//<< Chamado 005634
	If !lRest
		If (M->A1_EST="MT" .And. Empty(M->A1_CNAE) .And. M->A1_MSBLQL="2")
			MsgAlert("Este cliente é do Mato Grosso, COLOQUE O CAMPO BLOQUEADO COMO SIM e avise o departamento fiscal para preencher o CNAE")
			lRet	:= .F.
		Endif
	Else
		//FR - 09/03/2022 - Alteração - qdo vem do Rest já bloqueia o cliente, então não precisa deste alerta acima
		lRet := .T.
		Return(lRet)
	Endif 

	//Giovani Zago 15/04/14  desabilitado chamado 000389
	/*
	If lRet .And. M->A1_MSBLQL = "2"

	If Empty(Alltrim(M->A1_TIPO)) .Or. Empty(Alltrim(M->A1_CONTRIB)) .Or. Empty(Alltrim(M->A1_XREVISA))
	MsgAlert("Campos Nao preenchidos,Verificar!!!!(Contribuinte,Tipo,Revisado)")
	lRet	:= .F.
	Endif
	Endif
	*/
	//Giovani Zago 15/04/14
	If lRet
		If Inclui .And.  M->A1_TPFRET = 'C' .And. M->A1_XCIF > 0
			StCIFCli()
		ElseIf Altera .And. M->A1_XCIF <> SA1->A1_XCIF
			StCIFCli()
		Endif
	Endif

	If lRet
		If M->A1_MSBLQL=="2" .And. M->A1_XVALRE<DDATABASE .And. !Empty(M->A1_XVALRE)
			_cEmail   := GetMv("ST_STVALRE")
			_cAssunto := 'Empresa: '+cEmpAnt+' - Cliente: '+M->A1_COD+' loja: '+M->A1_LOJA+' liberado com RE vencido'
			cMsg := ""
			cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
			cMsg += '<b>Cliente liberado com RE vencido</b></body></html>'

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

		EndIf
	EndIf

	If lRet .And. (!Empty(M->A1_VEND) .Or. !Empty(SA1->A1_VEND)) //Chamado 003317
		_cEmail   := " "// Ticket 20201029009696
		Do Case
			Case INCLUI
			//>>Chamado 005634 - Everson Santana - Enviar e-mail para o vendedor quando se trata de um cliente novo
			_cAssunto := "[WFPROTHEUS] - Novo Cliente incluído: "+M->A1_VEND+" cliente: "+M->A1_COD+" loja: "+M->A1_LOJA
			_cGrpClas := Posicione("ACY", 1, XFilial("ACY") + M->A1_GRPVEN, "ACY_DESCRI")
			cMsg := ""
			cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'

			cMsg += '<b>Novo Cliente incluído:' +Alltrim(M->A1_VEND)+' cliente: '+Alltrim(M->A1_COD)+' loja: '+Alltrim(M->A1_LOJA)+' Nome: '+Alltrim(M->A1_NOME)+'</b><BR><BR>
			cMsg += '<b>Sr. Representante  / Sr. Vendedor acaba de ser criado um novo cliente em sua área de atuação abaixo<BR> seguem alguns dados  que o ajudarão a facilmente o localizar em sua carteira de clientes.</b><BR><BR>'
			cMsg += '<b>Contamos com a vossa habitual colaboração de dar atendimento ao mesmo, bem como cuidar de devidas <BR> atualizações que se fizerem necessárias em seu cadastro.</b><BR><BR>'
			cMsg += '<b>Duvidas ou necessidades especificas sobre este novo cliente, favor contatar vosso coordenador para o <BR>alinhamento necessário..</b><BR><BR></body></html>'

			If Empty(M->A1_GRPVEN)
				cMsg += '<b>Classificação não Informada</b><BR><BR></body></html>'
			Else
				cMsg += '<b>Classificação: '+Alltrim(M->A1_GRPVEN)+' '+Alltrim(_cGrpClas)+'</b><BR><BR></body></html>'
			EndIF

			_cSuper := Posicione("SA3", 1, XFilial("SA3") + M->A1_VEND, "A3_SUPER")
			_cEmail := _cEmail+";"+Posicione("SA3", 1, XFilial("SA3") + M->A1_VEND, "A3_EMAIL")+";"+Posicione("SA3", 1, XFilial("SA3") + _cSuper, "A3_EMAIL")
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

			//<<
			Case ALTERA .And. !(M->A1_VEND==SA1->A1_VEND)
			_cAssunto := "[WFPROTHEUS] - Área alterada de: "+SA1->A1_VEND+" para: "+M->A1_VEND+" cliente: "+M->A1_COD+" loja: "+M->A1_LOJA
			cMsg := ""
			cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
			cMsg += '<b>Cliente: '+Alltrim(M->A1_NOME)+' com área alterada de: '+Alltrim(M->A1_VEND)+' para: '+Alltrim(SA1->A1_VEND)+' por '+UsrFullName(__cUserId)+' </b></body></html>' //Chamado 008928 - Everson Santana - 29.01.2019
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

		EndCase
	EndIf

	//Destinação do produto
	If M->A1_XENVTBP=="S"
		If (M->A1_TIPO $ 'R' .And. M->A1_CONTRIB = '1'  .And. !(alltrim(M->A1_ATIVIDA) $ 'D1/D2/D3/R1/R2/R3/R5' ) .And. (!Empty(ALLTRIM(M->A1_INSCR)) .Or. 'ISENT' $ Upper(ALLTRIM(M->A1_INSCR)))) .Or. ;
		(M->A1_TIPO $ 'F' .And. M->A1_CONTRIB = '1'  .And. (!Empty(ALLTRIM(M->A1_INSCR)) .Or. 'ISENT' $ Upper(ALLTRIM(M->A1_INSCR))) .and. _lEst )
			If Empty(M->A1_XDESTP)
				lRet := .F.
				MsgAlert("Atenção, preencha a destinação do produto!")
			EndIf
		EndIf
	EndIf

	// Zeca em 06/11/2020
	// Ticket: 20200723004589
	
	If lRet
		If ( M->A1_XDTSERA <> SA1->A1_XDTSERA ) .And. ( !Empty( M->A1_XDTSERA) )
			If MsgYesNo("Atualiza a Data do Serasa para os demais clientes ?")
				_cQuery1 := " UPDATE " + RetSqlName("SA1") + " SA1"
				_cQuery1 += " SET A1_XDTSERA = '" + Dtos(M->A1_XDTSERA) + "'"
				_cQuery1 += " WHERE SA1.D_E_L_E_T_= ' '"
				_cQuery1 += " AND A1_MSBLQL <> '1'"
				_cQuery1 += " AND A1_COD = '" + SA1->A1_COD + "'"
				TcSqlExec(_cQuery1)
	
				MsgAlert("Fim do Processamento...")
			EndIf
		EndIf
	EndIf	
	
	RestArea(aArea)

	Return(lRet)

	/*====================================================================================\
	|Programa  | StCIFCli          | Autor | GIOVANI.ZAGO             | Data | 15/04/2014 |
	|=====================================================================================|
	|Descrição | StCIFCli		                                                          |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | StCIFCli                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*------------------------------------------------------------------*
Static Function  StCIFCli(_cObs,_cMot,_cName,_cDat,_cHora,_cEmail)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= 'Comercial - Cadastro Cliente(Vlr.CIF)'
	Local cFuncSent:= "StCIFCli"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ''
	Local cAttach  := ''
	Local _nValBase:= 0

	DEFAULT _cEmail  := ""

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		Aadd( _aMsg , { "Usuario"          , __cUserId } )
		Aadd( _aMsg , { "Nome"  , cUserName } )
		Aadd( _aMsg , { "Data"    , DtoC(dDatabase) +" às " + Time() } )
		Aadd( _aMsg , { "Cliente"  , M->A1_COD+" - "+M->A1_LOJA } )
		Aadd( _aMsg , { "Nome Cli."  , M->A1_NOME } )
		Aadd( _aMsg , { "Valor Cif"  , Transform(M->A1_XCIF,"@E 999,999,999.99") } )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

	EndIf
	RestArea(aArea)
Return()
