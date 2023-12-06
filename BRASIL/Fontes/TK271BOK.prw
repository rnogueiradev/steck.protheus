#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TK271BOK  ºAutor  ³Microsiga           º Data ³  02/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada "TUDOOK" na tela do Call Center TMKA271A   º±±
±±º          ³na funcao Tk271Grava                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TK271BOK( nOpc )
	Local lNovaR  := GETMV("STREGRAFT",.F.,.T.)              // Ticket: 20210811015405 - 24/08/2021
	Local lRet    := .T.
	PRIVATE oCodCon
	PRIVATE cCodCon := SPACE(08)
	 
	/****************************************
	<<<< ALTERAÇÃO >>>>
	Ação.........: Verificar se o cliente possui contrato vigente cadastrado na tabela Z73 - Módulo de Contratos Customizados
	.............: Se existir contrato pergunta se vai utilizar contrato ou não.
	.............: Se SIM abre tela para digitar o número do contrato 
	Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
	Data.........: 28/02/2022
	Chamados.....: 20220210003369
	****************************************/
	IF nOpc = 3 .AND. EMPTY(M->UA_XCONTRA)
		cQuery := "SELECT COUNT(*) QTD FROM "+RetSqlName("Z73")+" Z73 "
		cQuery += "WHERE Z73.D_E_L_E_T_ = ' ' AND Z73.Z73_CODCLI = '"+M->UA_CLIENTE+"' AND Z73.Z73_LOJCLI = '"+M->UA_LOJA+"' "
		cQuery += "AND Z73.Z73_DTATE >= '"+DTOS(DATE())+"' AND Z73.Z73_CONTRA = 'S' "
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TZ73', .F., .T.)
		IF TZ73->QTD > 0
			TZ73->(DBCLOSEAREA())
			IF MSGNOYES("Este cliente possui contrato cadastrado"+CHR(13)+CHR(10)+"Deseja selecionar um contrato?")
				SVLDCON1()
			ENDIF
		ELSE
			TZ73->(DBCLOSEAREA())
		ENDIF
	ENDIF

	lRet := U_STFSVE41()
	If lRet
		lRet := U_STXOKCALL() //Giovani.Zago totvs 2º onda 05/03/2013
	EndIf
	If lRet
		lRet := U_STTMKA03()  //Renato.Nogueira steck 07/03/2013
	Endif
	/*
	If lRet
		lRet := U_STTMKV02() //Renato Nogueira steck 06/04/2013
	Endif
	*/
	
	//Giovani Zago 26/05/14
	If  lRet
		lRet :=	U_STCEPNF()
	EndIf
	
	If lRet
		lRet := U_STTMKTRA()  //Renato.Nogueira steck 14/04/2015
	Endif
	
	U_STATUSCUS()  //ATUALIZO O CUSTO GERAL DO ORÇAMENTO GIOVANI.ZAGO 26/11/14
	
	U_STTMKVAL()//Chamado 002562 - atualizar o valor líquido do cabeçalho M->UA_ZVALLIQ
	
	If M->UA_TRANSP=="000001" .And. !(M->UA_TPFRETE=="C") //Chamado 002987
		MsgAlert("Transportadora Steck e frete diferente de CIF, verifique!")
		Return(.F.)
	EndIf
	
	If !Empty(SA1->A1_XEAN14)  //Chamado 002970
		If !U_EAN14VLD()
			MsgAlert("Problema com cadastro de EAN14, verifique!")
			Return(.F.)
		EndIf
	EndIf
	/*
	If SA1->A1_XBLQFIN=="3" .And. M->UA_OPER=="1" //Chamado 003316
		MsgAlert("Atenção, solicite documentação completa, o pedido não será gerado!")
		Return(.F.)
	EndIf
	*/
	If SA1->A1_XGERPED=="N" .And. M->UA_OPER=="1" //Chamado 003298
		MsgAlert("Atenção, bloqueado para gerar pedido, falta documentação, o pedido não será gerado!")
		Return(.F.)
	EndIf
	
	If SA1->A1_XBLOQF=="B" .And. M->UA_OPER=="1" //Chamado 002796
		MsgAlert("Atenção, bloqueado para gerar pedido, verifique com o financeiro, o pedido não será gerado!")
		Return(.F.)
	EndIf
	If M->UA_TRANSP = "000163" .And. GetMv("ST_TNTCF",,.T.)//   M->UA_TPFRETE = "C"  //Chamado 005994
		
		cZCodM:= ' '
		If Empty(Alltrim(M->UA_XCODMUN))
			cZCodM:= SA1->A1_COD_MUN
		Else
			cZCodM:= M->UA_XCODMUN
		EndIf
		/*
		Ticket: 20210811015405 - Valdemir Rabelo - 23/08/2021
		Removido conforme conversa com Kleber		
		DbSelectArea("CC2")
		CC2->(DbSetOrder(3))
		CC2->(DbGoTop())
		If CC2->(DbSeek(xFilial("CC2")+cZCodM))//CC2->(DbSeek(xFilial("CC2")+cZEstE+cZCodM))
			If  AllTrim(CC2->CC2_XSTECK)="S" .AND. ALLTRIM(SA1->A1_ATIVIDA) <> "VE" // Chamado 006516
				MsgAlert("Atenção, para essa situação a transportadora não pode ser TNT")
				Return(.F.)
			EndIf
		EndIf
		*/
		
	EndIf

	// Valdemir Rabelo Ticket: 20210811015405 - 31/08/2021
	if lRET
	   IF lNovaR .and. (cEmpAnt=="11" .and. cFilant=="01")
	      lRET := u_STVLDT01("SUA")
	   ENDIF 
	endif 
		
	//giovani zago 26/04/19 apagar codigo do vendedor no caso de ser representante para determinados clientes, falar com vanderlei.
	If lRet .And. Inclui
		If  M->UA_CLIENTE+M->UA_LOJA $ GetMv("ST_271BOK",,"00659624/00659636/00659637/03557602/03746307/03746311/03746313/03746319/03746320/03746321/03746323/03746324/03746327/03746330/03746331/03746332/03746334/03746335/ ") .And. Substr(M->UA_VEND,1,1) = 'R'.And. Substr(M->UA_VEND2,1,1) = 'I'
			ST271BOK(M->UA_VEND,M->UA_VEND2,SA1->A1_NOME,M->UA_NUM)
			MsgInfo("Sem Vendedor 1, Falar com Tereza....!!!!")
			M->UA_VEND := ' '
		Endif
	Endif

	// Valdemir Rabelo - 31/03/2020 ticket Nº 20191218000007
	if lRet .and. (INCLUI .OR. ALTERA)
	   U_STVLDZ68("SCJ", "SCK", INCLUI, ALTERA)
	Endif

	/***********************************************************************************************************************
	Fonte........: MSTECK15
	ação.........: Função para cálculo dos dias da entrega progamada do Orçamento
	Desenvolvedor: Marcelo Klopfer Leme
	Data.........: 29/04/2022
	Chamado......: 20220429009114 - Oferta Logística
	***********************************************************************************************************************/
	lRet := U_MSTECK15()

	If M->UA_OPER=="1" .And. Empty(M->UA_XORDEM) //Ticket 20230329003708
		MsgInfo("É obrigatório informar ordem de compra do cliente!")
		Return(.F.)
	EndIf

	
Return(lRet)


 
*------------------------------------------------------------------*
Static Function  ST271BOK(cVendNew,cVendNew2,_cCli,_cNum)
	*------------------------------------------------------------------*
	
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Orçamento Bloqueado Sem Vendedor - '+_cNum
	Local cFuncSent:= "ST271BOK"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ' '
	Local cAttach  := ''
	Local _cEmail  :=  ' '
	If __cuserid = '000000'
		_cAssunto:= "TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf
	_cEmail  := ""
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		Aadd( _aMsg , { "Orcamento: "    		, Alltrim(_cNum) } )
		Aadd( _aMsg , { "Cliente: "    		, Alltrim(_cCli) } )
		Aadd( _aMsg , { "Vendedor de"       , cVendNew + " - " + substr(Posicione("SA3",1,xFilial("SA3")+cVendNew,"A3_NOME"),1,30)} ) // chamado 005504 - Robson Mazzarotto
		Aadd( _aMsg , { "Vendedor para"     , cVendNew2 + " - " + substr(Posicione("SA3",1,xFilial("SA3")+cVendNew2,"A3_NOME"),1,30)} ) // chamado 005504 - Robson Mazzarotto
		Aadd( _aMsg , { "Usuario"  			, cUserName } )
		Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
		Aadd( _aMsg , { "Hora: "    		, time() } )
	 
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
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
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



 /*/{Protheus.doc} STVLDZ68()
    (long_description)
    Rotina que faz validação e dispara o WF para produtos usados
	ticket Nº 20191218000007
    @type  Function
    @author user
    Valdemir Rabelo - SigaMat
    @since date
    31/03/2020
    @example
/*/
User Function STVLDZ68(pAliaCab, pAliaItem, INCLUI, ALTERA)
	Local cCHVCAB   := "XFILIAL(pAliaCab)+(pAliaCab)->"+Right(pAliaCab,2)+"_NUM"
	Local cCHVITE   := "(pAliaItem)->"+Right(pAliaItem,2)+"_FILIAL+(pAliaItem)->"+Right(pAliaItem,2)+"_NUM"
	Local cProduto  := Right(pAliaItem,2)+"_PRODUTO"
	Local cNUM      := Right(pAliaCab,2)+"_NUM"
	Local cEmail    := ""
	Local cTitulo   := if(pAliaCab=="SC5","PEDIDO DE VENDA: ", "ORÇAMENTO: ")
	Local _aProduto := {}

	// ---- Valdemir Rabelo 30/03/2020 - ticket Nº 20191218000007 ----------------------------
	IF INCLUI  .or. ALTERA
		dbSelectArea('Z68')
		dbSetOrder(1)
		(pAliaItem)->( DbSeek( &cCHVCAB ) )
		While (pAliaItem)->( !Eof() .and. (&cCHVITE == &cCHVCAB) )
			nReg := aScan(_aProduto, { |X| alltrim(X[3])==Alltrim( (pAliaItem)->&(cProduto)) })
			IF Z68->( dbSeek(xFilial("Z68")+(pAliaItem)->&(cProduto)) )
			    PswOrder(2)
			    IF PswSeek( Z68->Z68_USUARI, .T. )					
					cEmail := UsrRetMail(PswID())
					IF !EMPTY(Z68->Z68_EMAIL)
						cEmail += ";"+Z68->Z68_EMAIL
					ENDIF
					if (nReg==0)
						aAdd(_aProduto, {"PRODUTO", Alltrim((pAliaItem)->&(cProduto))+" - "+Posicione("SB1",1,xFilial("SB1")+(pAliaItem)->&(cProduto),"B1_DESC"), (pAliaItem)->&(cProduto)} )
					endif
				Endif
			Endif
			(pAliaItem)->( dbSkip() )			// Ajustado estava com SC6 (Erroneamente) Valdemir Rabelo 14/04/2020
		EndDo
		if (Len(_aProduto) > 0)
			// Verifica se dispara o WF ao responsavel pelo cadastro Z68
			EnvMail(cEmail, _aProduto, cTitulo+(pAliaCab)->&(cNUM))
		Endif
	Endif
	// ----------------------------------------------------------------------------------------

Return




//-------------------------------------------------------------------
// Monta e envia e-mail conforme status do registro
// Nome: Valdemir Rabelo
// Data: 31/03/2020
// Retorno: nil
//-------------------------------------------------------------------
Static Function EnvMail(cEmail, _aMsg, _cTipo)
	Local aArea     := Getarea()
	Local cMsgSt    := ""
	Local cMsg      := ""
	Local cCC       := ""
	Local _cAssunto := "Produtos que fizeram parte ( " + _cTipo + " )"
	Local cSubject  := "Produtos que fizeram parte ( " + _cTipo + " )"
	Local _nLin
	_cAssunto := cMsgSt

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

	Next

	//A Definicao do rodape do email                                               
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1"></td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'
	
	RestArea( aArea )

	U_STMAILTES(cEmail, cCC, cSubject, cMsg,{},"")

Return

/****************************************
Ação.........: Monta a tela para digitação do contrato
Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
Data.........: 28/02/2022
Chamados.....: 20220210003369
****************************************/
STATIC FUNCTION SVLDCON1()
LOCAL oBtCancel
LOCAL oBtOK
STATIC oDlgVlCon

 DEFINE MSDIALOG oDlgVlCon TITLE "Contrato" FROM 000, 000  TO 130, 180  PIXEL

  @ 010, 010 SAY "Informe o código do contrato:" SIZE 072, 007 OF oDlgVlCon  PIXEL
  @ 022, 010 MSGET oCodCon VAR cCodCon SIZE 038, 010 OF oDlgVlCon  VALID(IIF(!EMPTY(cCodCon),SVLDCON2(),.T.)) F3 "Z73" PIXEL
  DEFINE SBUTTON oBtOK     FROM 042, 010 TYPE 01 OF oDlgVlCon ENABLE ACTION IIF(SVLDCON2()=.T.,oDlgVlCon:End(),"")
  DEFINE SBUTTON oBtCancel FROM 042, 050 TYPE 02 OF oDlgVlCon ENABLE ACTION (oDlgVlCon:End())

ACTIVATE MSDIALOG oDlgVlCon CENTERED

RETURN

/****************************************
Ação.........: Static Funciton para validar se o contrato está vigente e se o mesmo existe
Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
Data.........: 28/02/2022
Chamados.....: 20220210003369
****************************************/
STATIC FUNCTION SVLDCON2()
LOCAL lRet := .F. 

	cQuery := "SELECT Z73_CODIGO FROM "+RetSqlName("Z73")+" Z73 "
	cQuery += "WHERE Z73.D_E_L_E_T_ = ' ' AND Z73.Z73_CODCLI = '"+M->UA_CLIENTE+"' AND Z73.Z73_LOJCLI = '"+M->UA_LOJA+"' "
	cQuery += "AND Z73.Z73_DTATE >= '"+DTOS(DATE())+"' AND Z73.Z73_CODIGO = '"+cCodCon+"' "
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TZ73', .F., .T.)
	IF EMPTY(TZ73->Z73_CODIGO)
		MSGALERT("Cógio de contrato inválido!","Atenção")
		cCodCon := SPACE(08)
 		oCodCon:Refresh()
	ELSE
		cCodCon := TZ73->Z73_CODIGO
		M->UA_XCONTRA := TZ73->Z73_CODIGO
 		oCodCon:Refresh()
		lRet := .T. 
	ENDIF
 
	TZ73->(DBCLOSEAREA())
RETURN lRet



