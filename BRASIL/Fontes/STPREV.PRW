#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | STPREV          | Autor | GIOVANI.ZAGO             | Data | 30/10/2014   |
|=====================================================================================|
|Descri��o | STPREV                                                                   |
|          |  																	      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPREV                                                                   |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
/**********************************************
Altera��o....: Quandou houver a modifica��o na Quantidade, limpar todos os campos na tabela SC6 
onde � refernciado o compromisso, deta forma na pr�xima vez que a rotina STPREVATU for inicalizada ser� recalculado 
as quantidades a serem atendidas para cada pedido.
Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
Data.........: 22/09/2021
***********************************************/
*----------------------------------*
User Function STPREV()
	*----------------------------------*
	
	Local oBrowse
	PRIVATE Emlvnd := ""

	MsgAlert("Rotina desativada")
	Return

	dbSelectArea("SC5")
	dbSetOrder(1)
	
	If GetMv("ST_PREV2",,.F.)
		U_STPRVE2()
		Return()
	EndIf
	
	//Processa({|| U_STATUSALDO( ) },"Aguarde") 
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZZJ")							// Alias da tabela utilizada
	oBrowse:SetMenuDef("STPREV")					// Nome do fonte onde esta a fun��o MenuDef
	oBrowse:SetDescription("Compromisso")   	// Descri��o do browse //"Al�quotas de ICMS"
	DbSelectArea("ZZJ")
	ZZJ->(DbSetOrder(3))
	
	oBrowse:AddLegend(" DTOS(ZZJ_DATA) >= '"+DTOs(DATE())+ "' .and. Empty(Alltrim(ZZJ_CANCEL))  "	, "GREEN"   , "Dentro do Prazo" )
	oBrowse:AddLegend(" !Empty(Alltrim(ZZJ_CANCEL))  " 												, "BLACK"	, "Canceladas" )
	oBrowse:AddLegend(" DTOS(ZZJ_DATA) < '"+DTOs(DATE()) + "' .and. Empty(Alltrim(ZZJ_CANCEL))  "	, "RED"    	, "Encerradas" )
	oBrowse:AddLegend("  !Empty(Alltrim(ZZJ_DTCHEG))"												, "BLUE"	, "Atendido" )
	
	oBrowse:Activate()
	
Return(Nil)

//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}
	
	//-------------------------------------------------------
	// Adiciona bot�es do browse
	//-------------------------------------------------------
	ADD OPTION aRotina TITLE "Pesquisar" 								ACTION "AxPesqui"       				OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	ADD OPTION aRotina TITLE "Visualizar"								ACTION "VIEWDEF.STPREV" 				OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Incluir"   								ACTION "VIEWDEF.STPREV" 				OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Alterar"   								ACTION "VIEWDEF.STPREV" 				OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Motivos de Cancelamento"  ACTION "u_STSX5Z4()" 						OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Importar TXT"     				ACTION "u_STCOMIMPORT()" 				OPERATION 9 ACCESS 0 //"Copiar"
	ADD OPTION aRotina TITLE "Informar Chegada"    			ACTION "u_STCHEPREV()" 					OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Exclui Reg.TXT"   				ACTION "u_STTXTEXC()" 					OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Alt.Massa"   							ACTION "u_COMALT(ZZJ->ZZJ_OP)"	OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Excluir Massa"   			    ACTION "u_STEXCMAS()" 					OPERATION 3 ACCESS 0 // Excluir em Massa - Valdemir Rabelo Ticket:20210203001777 
	
Return aRotina


Static Function ModelDef()
	
	Local oModel
	
	Local oStructZZJ := FWFormStruct(1,"ZZJ")
	
	// cID     Identificador do modelo
	// bPre    Code-Block de pre-edi��o do formul�rio de edi��o. Indica se a edi��o esta liberada
	// bPost   Code-Block de valida��o do formul�rio de edi��o
	// bCommit Code-Block de persist�ncia do formul�rio de edi��o
	// bCancel Code-Block de cancelamento do formul�rio de edi��o
	oModel := MPFormModel():New("xws", /*bPre*/, { |oX| STPREVAL( oX ) },/*bPost*/, /*bCommit*/, /*bCancel*/)
	// cId          Identificador do modelo
	// cOwner       Identificador superior do modelo
	// oModelStruct Objeto com  a estrutura de dados
	// bPre         Code-Block de pr�-edi��o do formul�rio de edi��o. Indica se a edi��o esta liberada
	// bPost        Code-Block de valida��o do formul�rio de edi��o
	// bLoad        Code-Block de carga dos dados do formul�rio de edi��o
	oModel:AddFields("STPREV2_ZZJ", Nil, oStructZZJ,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:SetPrimaryKey({"ZZJ_FILIAL", "ZZJ_NUM"})
	
Return oModel

//-------------------------------------------------------------------

Static Function ViewDef()
	
	Local oModel  := FWLoadModel("STPREV")
	Local oView   := Nil
	Local oStruct := FWFormStruct(2,"ZZJ")
	Local nOpc := oModel:GetOperation()
	oStruct:RemoveField("ZZJ_USEREP")
	oStruct:RemoveField("ZZJ_HREPRO")
	oStruct:RemoveField("ZZJ_REPRO")
	
	If nOpc == MODEL_OPERATION_INSERT
		oStruct:RemoveField("ZZJ_ALTER")
		oStruct:RemoveField("ZZJ_ALT")
	EndIf
	
	If nOpc == MODEL_OPERATION_UPDATE
		oStruct:SetProperty( "ZZJ_COD"    , MVC_VIEW_CANCHANGE ,.F.)
	EndIf
	oView := FWFormView():New()
	// Objeto do model a se associar a view.
	oView:SetModel(oModel)
	// cFormModelID - Representa o ID criado no Model que essa FormField ir� representar
	// oStruct - Objeto do model a se associar a view.
	// cLinkID - Representa o ID criado no Model ,S� � necess�ri o caso estamos mundando o ID no View.
	oView:AddField( "STPREV2_ZZJ" , oStruct, /*cLinkID*/ )	//
	// cID		  	Id do Box a ser utilizado
	// nPercHeight  Valor da Altura do box( caso o lFixPixel seja .T. � a qtd de pixel exato)
	// cIdOwner 	Id do Box Vertical pai. Podemos fazer diversas cria��es uma dentro da outra.
	// lFixPixel	Determina que o valor passado no nPercHeight � na verdade a qtd de pixel a ser usada.
	// cIDFolder	Id da folder onde queremos criar o o box se passado esse valor, � necess�rio informar o cIDSheet
	// cIDSheet     Id da Sheet(Folha de dados) onde queremos criar o o box.
	oView:CreateHorizontalBox( "MASTER" , 100,/*cIDOwner*/,/*lFixPixel*/,/*cIDFolder*/,/*cIDSheet*/ )
	// Associa um View a um box
	oView:SetOwnerView( "STPREV2_ZZJ" , "MASTER" )
	
Return oView

Static Function STPREVAL(oModel)
	Local nOpc     := oModel:GetOperation()
	Local _cLog    := ' '
	Local _aWf     := {}
	Local _cQry    := ""				// Valdemir Rabelo 14/02/2020
	Local _cPedido := ""
	Local _CodCli  := ""
	Local _Loja    := ""
	Local _NomeCli := ""
	LOCAL nRet := 0
	
	
	
	If nOpc == MODEL_OPERATION_UPDATE
		If Empty(AllTrim(FwFldGet("ZZJ_ALTER"))) .And. Empty(AllTrim(FwFldGet("ZZJ_CANCEL")))
			Help( ,, 'HELP',, "Motivo de altera��o deve ser preenchido!!!!!", 1, 0,)
			Return .F.
		EndIf
	EndIf
	
	
	If nOpc == MODEL_OPERATION_UPDATE
	    _cPedido := getRetPed(ZZJ->ZZJ_OP)		// Valdemir Rabelo 27/08/2020 Chamado: 20200818005811

			/*****************************************
			Altera��o....: Quandou houver a modifica��o na Quantidade, limpar todos os campos na tabela SC6 
			onde � refernciado o compromisso, deta forma na pr�xima vez que a rotina STPREVATU for inicalizada ser� recalculado 
			as quantidades a serem atendidas para cada pedido.
			Regras para limpar os campos referente ao compromisso:
			1 - Quantidade...: Quando a quantidade for alterada para MAIOR ou MENOR que a quantidade anterior.
			2 - Data.........: Quando a Data for alterada para MAIOR ou MENOR que a Data anterior.
			3 - Cancelamento.: Conforme a regra se o campo "ZZJ_CANCEL" possuir qualquer informa��o (Podendo ser at� um ".") isso determina que o compromisso est� cancelado.
			Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
			Data.........: 22/09/2021
			*****************************************/
			IF ZZJ->ZZJ_QUANT <> M->ZZJ_QUANT .OR. ZZJ->ZZJ_DATA <> M->ZZJ_DATA .OR. !EMPTY(ALLTRIM(FwFldGet("ZZJ_CANCEL")))
				cQuery := "UPDATE "+RetSqlName("SC6")+" SET C6_XPREV = ' ',C6_XQTPRV = 0 ,C6_ZENTRE2 = ' ' WHERE D_E_L_E_T_ = ' ' "
				cQuery += "AND C6_XPREV = '"+M->ZZJ_NUM+"' AND C6_FILIAL = '"+XFILIAL("SC6")+"' AND C6_PRODUTO = '"+M->ZZJ_COD+"' "
				nRet := TcSQLExec(cQuery)
				IF nRet <> 0
					MSGALERT("N�o foi poss�vel atualizar os pedidos de venda!")
					CONOUT("[STPREV] - Erro na execu��o da Query -"+CHR(13)+CHR(10)+cQuery)
				ENDIF
			ENDIF

		if !Empty(_cPedido)
			if SC5->( dbSeek(xFilial('SC5')+_cPedido) )
			_CodCli  := SC5->C5_CLIENTE
			_Loja    := SC5->C5_LOJACLI
			_NomeCli := Posicione("SA1",1,xFilial('SA1')+_CodCli+_Loja,"A1_NOME")

				// ------------20200818005811 Adicionando Vendedor Externo - 27/08/2020 -----------
				SA1->( dbSetOrder(1) )
				SA1->( dbSeek(xFilial('SA1')+_CodCli+_Loja) )
				IF !EMPTY(SA1->A1_VEND)
				cTMP := Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND, "A3_EMAIL")
					if !Empty(cTMP)
						Emlvnd += ","+cTMP
					Endif		   
				Endif 
				//---------------------------------------------------------------------			
				// Valdemir Rabelo 11/02/2020 - 20200818005811
				if !Empty(SC5->C5_VEND1)
					cTMP := Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1, "A3_EMAIL")
					if !Empty(cTMP)
						Emlvnd += ","+cTMP
					Endif
				Endif
			Endif   
		Endif 

		_cLog:= Alltrim(ZZJ->ZZJ_MHISTO)+CR+CR+'ALTERADO: '+DTOC(DATE())+' - '+TIME() +' - '+CUSERNAME+' - '+__cUserId+CR+;
			"Num.: "+Alltrim( ZZJ->ZZJ_NUM)+CR+'Cod.:'+ Alltrim(ZZJ->ZZJ_COD)+CR+'Ref.:'+ Alltrim(ZZJ->ZZJ_OP)+CR+'Quan:'+ cvaltochar(ZZJ->ZZJ_QUANT)+CR+;
			'Pra.:'+ DTOC(ZZJ->ZZJ_DATA)+CR+'Mod.:'+;
			Iif(Alltrim(ZZJ->ZZJ_TRANSP)= '1','Rodoviario',Iif(Alltrim(ZZJ->ZZJ_TRANSP)= '2','Aereo','Maritimo'));
			+CR+'Mot.:'+ Alltrim(ZZJ->ZZJ_ALTER)
		If ExistSx3("ZZJ_LOCAL")
			_cLog:= Alltrim(_cLog)+CR+'Ste.:'+ Alltrim(ZZJ->ZZJ_LOCAL)
		EndIf

		FwFldPut("ZZJ_MHISTO", _cLog)
		Aadd(_aWf,{' ' 			,'De:'						,'Para:'})
		Aadd(_aWf,{'Numero' 	,Alltrim( ZZJ->ZZJ_NUM) 	,AllTrim(FwFldGet("ZZJ_NUM"))})
		Aadd(_aWf,{'Codigo' 	,Alltrim( ZZJ->ZZJ_COD) 	,AllTrim(FwFldGet("ZZJ_COD"))})
		Aadd(_aWf,{'Referencia' ,Alltrim( ZZJ->ZZJ_OP) 		,AllTrim(FwFldGet("ZZJ_OP"))})
		// --------------- Chamado 20200818005811- Valdemir Rabelo
		Aadd(_aWf,{'Pedido' 	,Alltrim( _cPedido) 		,AllTrim(_cPedido)})
		Aadd(_aWf,{'Cliente' 	,Alltrim( _CodCli) 			,AllTrim(_CodCli)})
		Aadd(_aWf,{'Loja' 		,Alltrim( _Loja) 			,AllTrim(_Loja)})
		Aadd(_aWf,{'Nome' 		,Alltrim( _NomeCli) 		,AllTrim(_NomeCli)})
		// ----------------
		Aadd(_aWf,{'Quantidade' ,cvaltochar(ZZJ->ZZJ_QUANT) ,cvaltochar(FwFldGet("ZZJ_QUANT"))})
		Aadd(_aWf,{'Prazo' 		,DTOC(ZZJ->ZZJ_DATA) 		,DTOC(FwFldGet("ZZJ_DATA"))})
		Aadd(_aWf,{'Modal' 		,Iif(Alltrim(ZZJ->ZZJ_TRANSP)= '1','Rodoviario',Iif(Alltrim(ZZJ->ZZJ_TRANSP)= '2','Aereo','Maritimo')) ,Iif(Alltrim(FwFldGet("ZZJ_TRANSP"))= '1','Rodoviario',Iif(Alltrim(FwFldGet("ZZJ_TRANSP"))= '2','Aereo','Maritimo'))})
		Aadd(_aWf,{'Motivo' 	,Alltrim( ZZJ->ZZJ_ALTER) 	,AllTrim(FwFldGet("ZZJ_ALTER"))})
		Aadd(_aWf,{'Compl.Alter.',Alltrim( ZZJ->ZZJ_COMPAL) ,AllTrim(FwFldGet("ZZJ_COMPAL"))})      // Chamado 20200818005811- Valdemir Rabelo
		If ExistSx3("ZZJ_LOCAL")
			Aadd(_aWf,{'Steck' 		,Iif(Alltrim(FwFldGet("ZZJ_LOCAL"))= '1','Fabrica AM',Iif(Alltrim(FwFldGet("ZZJ_LOCAL"))= '2','Fabrica SP','Importado')),;
			Iif(Alltrim(FwFldGet("ZZJ_LOCAL"))= '1','Fabrica AM',Iif(Alltrim(FwFldGet("ZZJ_LOCAL"))= '2','Fabrica SP','Importado'))})			 				
		EndIf
		Aadd(_aWf,{CUSERNAME	,DTOC(DATE()) 				,TIME()})
		//workflow de altera��o
		STWFCOM(_aWf)
	EndIf
	If nOpc == MODEL_OPERATION_INSERT
		
		_cLog:= "Incluido - "+DTOC(DATE())+' - '+TIME() +' - '+CUSERNAME
		FwFldPut("ZZJ_MHISTO"	, _cLog)
		FwFldPut("ZZJ_USUARI"	, __cUserId)
		FwFldPut("ZZJ_NOME"		, cUserName)
		FwFldPut("ZZJ_ALT"		, '1')
		
	EndIf

	// Valdemir Rabelo 14/02/2020 - Grava��o de Hist�rico na PP8
	If (nOpc == MODEL_OPERATION_INSERT) .or. (nOpc == MODEL_OPERATION_UPDATE)
	
		_cQry += "UPDATE "+RETSQLNAME("SC6")+" SET C6_XOBSUNI= RAWTOHEX('"+Alltrim(FwFldGet("ZZJ_ALTER"))+"') " + CRLF
		_cQry += "WHERE D_E_L_E_T_ = '' AND C6_XPREV = '"+ZZJ->ZZJ_NUM+"' " + CRLF
		nStatus := TcSQLExec(_cQry)

		If (nStatus < 0)
			conout("TCSQLError() " + TCSQLError())
		EndIf
		// Complementando grava��o - Valdemir 21/02/2020 Gravar Historico na SC6
		_cQry := ""
		
		_cQry += " MERGE INTO "+RetSqlName("PP8")+" PP8 " 
		_cQry += " USING ( "
		_cQry += " SELECT C6_XPREV,utl_raw.cast_to_varchar2(dbms_lob.substr(C6_XOBSUNI)) C6_XOBSUNI, PP8A.R_E_C_N_O_ RECPP8 FROM "+RetSqlName("PP8")+" PP8A " 
		_cQry += " INNER JOIN "+RetSqlName("SC6")+" SC6 " 
		_cQry += " ON SC6.C6_NUM = SubStr(PP8A.PP8_PEDVEN,1,6) "
		_cQry += " AND C6_ITEM = SubStr(PP8A.PP8_PEDVEN,7,2) AND SC6.D_E_L_E_T_ = ' ' "
		_cQry += " WHERE  SC6.C6_XPREV='"+ZZJ->ZZJ_NUM+"' " 
		_cQry += " ) XXX " 
		_cQry += " ON (PP8.R_E_C_N_O_=XXX.RECPP8) "
		_cQry += " WHEN MATCHED THEN UPDATE "
		_cQry += " SET PP8.PP8_OBS= RAWTOHEX(XXX.C6_XOBSUNI) "
		
		nStatus1 := TcSQLExec(_cQry)
		
		If (nStatus1 < 0)
			conout("TCSQLError() " + TCSQLError())
		EndIf
		
	Endif
	
Return .T.


/*/{Protheus.doc} getRetPed
description
Retorna o numero do Pedido
@type function
@version 
@author Valdemir Jose
@since 27/08/2020
@param pcOP, param_type, param_description
@return return_type, return_description
/*/
Static Function getRetPed(pcOP)
	Local cRET := ""
	Local aAreaSC2 := GetArea()

	dbSelectArea("SC2")
	dbSetOrder(1)
	if dbSeek(xFilial("SC2")+pcOP)
		cRET := SC2->C2_PEDIDO
	Endif

	RestArea( aAreaSC2 )

Return cRET


User Function STVALPREV2()
	Local _lRezzj   := .F.
	Local cAliaszzj := 'STVALPREV2'
	Local _nQuer    := 0
	Local cQuery    := ' '
	
	
	dbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(dbSeek(xFilial('SB1')+M->ZZJ_COD))
	If SB1->B1_CLAPROD = 'F'
		Return(.T.)
	EndIf
	
	//_nQtAcol -= aCols[n,_nPosQtd] M->ZZJ_QUANT
	
	cQuery := " SELECT
	cQuery += " SUM(SC7.C7_QUANT - SC7.C7_QUJE )
	cQuery += ' "VALOR"
	
	cQuery += " FROM "+RetSqlName("SC7")+" SC7
	cQuery += " WHERE SC7.D_E_L_E_T_ = ' '
	cQuery += " AND SC7.C7_PRODUTO = '"+ Alltrim(M->ZZJ_COD)+"'
	cQuery += " AND SC7.C7_QUANT > SC7.C7_QUJE
	cQuery += " AND SC7.C7_RESIDUO = ' '
	cQuery += " AND SC7.C7_FILIAL  = '"+xFilial('SC7')+"'
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliaszzj) > 0
		(cAliaszzj)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliaszzj)
	dbSelectArea(cAliaszzj)
	If  Select(cAliaszzj) > 0
		(cAliaszzj)->(dbgotop())
		
		_nQuer 	:= (cAliaszzj)->VALOR
		
	EndIf
	
	/*********************************************
	<<<< ALTERA��O >>>>
	A��o.........: Retirado trataneto para o saldo em pedido de compras.
	Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
	Data.........: 21/02/2022
	Chamados.....: 20220216003868
		If _nQuer  >= M->ZZJ_QUANT
			_lRezzj := .T.
		Else
			MsgInfo("Quantidade Superior ao Saldo do Pedido de Compras...!!!"+CR+CR+"Saldo Disponivel: "+ cvaltochar(_nQuer))
		EndIf
	****************************************/	
	_lRezzj := .T.
	
Return(_lRezzj)



Static Function STWFCOM(_aMsg)
	Local aArea 	:= GetArea()
	Local _cFrom    := "protheus@steck.com.br"
	Local _cAssunto := 'Altera��o - Previs�o de Chegada.('+_aMsg[2,2]+')'
	Local cFuncSent := "STWFCOM"
	Local i         := 0
	Local cArq      := ""
	Local cMsg      := ""
	Local _nLin
	Local _cCopia   := 'Richely.Lima@steck.com.br;paulo.filho@steck.com.br;'
	Local cAttach   := ''

	// Valdemir Rabelo 20/08/2020 - ticket N� 20200609002790 / 20200818005810
	_cCopia += AllTrim(GetMv("STPREV0001",,"alex.lourenco@steck.com.br;lucas.machado@steck.com.br;"))
	_cCopia += "filipe.nascimento@steck.com.br;bruno.galvao@steck.com.br"
	_cCopia += Emlvnd

	If __cuserid = '000000'
		_cAssunto:=_cAssunto+ " TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf
	
	If "AM" $ _aMsg[9,2]
		_cEmail  := ' ' /// chamado 004097
	ElseIf "SP" $ _aMsg[9,2]
		_cEmail  := 'Ulisses.Almeida@steck.com.br; Luciano.Fernandes@steck.com.br'
	ElseIf "Importado" $ _aMsg[9,2]
		_cEmail  := 'arisla.aciardi@steck.com.br'
	Else
		_cEmail  := 'Richely.Lima@steck.com.br;paulo.filho@steck.com.br'
	EndIf


	If ( Type("l410Auto") == "U" .OR. !l410Auto )
				
		//�����������������������������������������������������������������������������Ŀ
		//� Definicao do cabecalho do email                                             �
		//�������������������������������������������������������������������������������
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
		//�����������������������������������������������������������������������������Ŀ
		//� Definicao do texto/detalhe do email                                         �
		//�������������������������������������������������������������������������������
		For _nLin := 1 to Len(_aMsg)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		//�����������������������������������������������������������������������������Ŀ
		//� Definicao do rodape do email                                                �
		//�������������������������������������������������������������������������������
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
		
		
		If !(   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach) )
			MsgInfo("Email n�o Enviado..!!!!")
		EndIf
	EndIf
	RestArea(aArea)
Return()

User Function STPREV1()

	Local _cRet := ""
	
	DbSelectArea("SX5")
	SX5->(dbSetOrder(1))
	SX5->(dbSeek(xFilial("SX5") + '_I'))
	Do While SX5->(!Eof()) .and. xFilial("SX5") = SX5->X5_FILIAL .And. SX5->X5_TABELA  = '_I'
		_cRet+= ';'+AllTrim(SX5->X5_DESCRI)
		SX5->(DbSkip())
	EndDo

Return(_cRet)



