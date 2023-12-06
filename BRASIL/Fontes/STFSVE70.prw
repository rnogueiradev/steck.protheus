#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH"
#define CLR Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE70  ºAutor  ³Microsiga           º Data ³  01/27/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monitor de pedidos de venda -  bloqueio                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSVE70()
	//---------------------------------------------------------------------------------------//
    //FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos
	//no browse da tela de liberaçao de pedidos, inibir a exibição dos pedidos bloqueados
	//por desconto, porque serão liberados em tela específica para liberar desconto
    //---------------------------------------------------------------------------------------//
    //Local cFiltro := "C5_FILIAL = '"+xFilial("SC5")+"' AND C5_XBLOQPV = '1'"  //alterado por Flávia Rocha
    Local cFiltro := ""  //"C5_FILIAL = '"+xFilial("SC5")+"' AND C5_XBLOQPV = '1' "  //alterado por Flávia Rocha

    Local bFiltraBrw := {}		//FR - 18/10/2022 - Flávia Rocha - Sigamat Consultoria
	Local aIndexSC5  := {}		//FR - 18/10/2022 - Flávia Rocha - Sigamat Consultoria

	Local aCores := {{"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)",'ENABLE' },;		//Pedido em Aberto
	{ "!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)" ,'DISABLE'},;		   	//Pedido Encerrado
	{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)",'BR_AMARELO'},;
		{ "C5_BLQ == '1'",'BR_AZUL'},;	//Pedido Bloquedo por regra
	{ "C5_BLQ == '2'",'BR_LARANJA'}}	//Pedido Bloquedo por verba

	Private cCadastro := "Liberação de Pedidos Bloqueados"
	Private aRotina := {	{	"Pesquisar"		,"AxPesqui"		,0,1,0 ,.F.},;
		{ "Visualizar"		,"A410Visual"	,0,2,0 ,NIL},;
		{ "Desbloquear" 	,"U_STFSVE73"	,0,4,0 ,NIL},;
		{ "Legenda"			,"A410Legend"	,0,4,0 ,.F.},;
		{ "Conhecimento"	,"MsDocument"	,0,5,0 ,NIL} }

	DbSelectArea("SC5")

	//---------------------------------------------------------------------------------------//
    //FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos
	//no browse da tela de liberaçao de pedidos, inibir a exibição dos pedidos bloqueados
	//por desconto, porque serão liberados em tela específica para liberar desconto
    //---------------------------------------------------------------------------------------//
    cFiltro := "C5_FILIAL = '"+xFilial("SC5")+"' .AND. C5_XBLOQPV = '1' .AND. !('DESC' $ C5_ZMOTBLO) "
    //cFiltro := "C5_FILIAL = '"+xFilial("SC5")+"' .AND. C5_XBLOQPV = '1' "
    bFiltraBrw := { || FilBrowse("SC5" , @aIndexSC5 , @cFiltro )}
	
    If !Empty(cFiltro)
		Eval(bFiltraBrw)
	Endif 
	//FR - 18/10/2022 - Flávia Rocha - Sigamat Consultoria

	PC1->(DbGoTop())
	//mBrowse( 6, 1,22,75,"SC5"	,,,,,,aCores,,,,,,,,cFiltro,3000,{|| o:=GetObjBrow(),o:Refresh()})

    MBrowse(,,,,"SC5",,,,,,aCores)

	If !Empty(cFiltro)
		EndFilBrw("SC5" ,aIndexSC5)
	Endif 


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE70  ºAutor  ³Microsiga           º Data ³  01/27/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para atualizar o pedido de venda gerado    º±±
±±º          ³orcamento do televendas                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSVE71(cOrc,cPedido)
	Local aArea 	:= GetArea()
	Local aSA3Area	:= SA3->(GetArea())
	Local dDataEntr := dDatabase
	Local nPerCom	:= 0
	Local nI		:= 0
	Local _CRLF:= CHR(13)+CHR(10)
	Local _nxSal  := 0
	Local _dEnt   := ddatabase
	Local lCredito := .F.
	Local _cConPag      := GetMv("ST_STTS01",,"501")
	Local _aGrupos	:= {}
	Local _lEnvGrp	:= .F.
	Local cEmlCli   := ""
	Local lAtiva    := GetMV("ST_ATINPUT",.F.,.T.)    // ticket Nº 20210211002338 / 20210601009141 - Valdemir Rabelo 18/06/2021

	For nI:=1 to len(aCols)

		_nxSal :=  u_versaldo(GDFieldGet("UB_PRODUTO",nI))//atualizo saldo
		_dEnt  :=  u_atudtentre(_nxSal,GDFieldGet("UB_PRODUTO",nI),GDFieldGet("UB_QUANT",nI),SUA->UA_NUM,GDFieldGet("UB_ITEM",nI))//atualizo data
		GDFieldPut( "UB_DTENTRE", _dEnt	,nI)
		If GDFieldGet("UB_DTENTRE",nI) > dDataEntr
			dDataEntr := GDFieldGet("UB_DTENTRE",nI)
		Endif
	Next

	//conout(time()+' - ve70 ini')
	DbSelectArea('SUB')
	SUB->(DbSetOrder(1))
	If SUB->(DbSeek(xFilial("SUB")+SUA->UA_NUM))
		While SUB->(!Eof()) .and. SUB->UB_FILIAL+SUB->UB_NUM == xFilial("SUB")+SUA->UA_NUM

			_nxSal :=  u_versaldo(	SUB->UB_PRODUTO )//atualizo saldo
			_dEnt  :=  u_atudtentre(_nxSal,	SUB->UB_PRODUTO ,	SUB->UB_QUANT )//atualizo data

			SUB->(RecLock("SUB",.F.))

			SUB->UB_DTENTRE  :=_dEnt
			SUB->(MsUnlock())
			SUB->( DbCommit() )

			If SUB->UB_DTENTRE  > dDataEntr
				dDataEntr := SUB->UB_DTENTRE
			Endif
			SUB->(DbSkip())
		End
	Endif

	// Gravar Maior data de Entrefa varrendo SUB MIT044 1.3
	SUA->(RecLock("SUA",.F.))
	SUA->UA_XDTENTR	:= dDataEntr
	SUA->(MsUnlock())
	SUA->(DbCommit())   //Giovani Zago 25/02/14
	If !Empty(cPedido)
		SUA->(RecLock("SUA",.F.))
		SUA->UA_PROXLIG	:= ctod('  /  /    ')
		SUA->UA_HRPEND	:= ''
		SUA->(MsUnlock())
		SUA->(DbCommit())//Giovani Zago 25/02/14
		//	aSUAArea	:= SUA->(GetArea())
		DbSelectarea("SA3")
		SA3->(DbSetOrder(1))
		If SA3->(DbSeek(xFilial("SA3")+SUA->UA_VEND))
			nPerCom := SA3->A3_COMIS
		Endif
		//	RestArea(aSUAArea)

		// ----------------------------------------
		SC5->(RecLock("SC5",.F.))
		SC5->C5_ZBLOQ   := SUA->UA_XBLOQ
		SC5->C5_ZCONSUM	:= SUA->UA_ZCONSUM
		SC5->C5_ZCODCON	:= SUA->UA_CODCONT
		SC5->C5_ZDESCNT	:= SUA->UA_DESCNT
		SC5->C5_XORDEM 	:= SUA->UA_XORDEM
		SC5->C5_CONDPAG := SUA->UA_XCONDPG
		SC5->C5_TRANSP 	:= SUA->UA_TRANSP
		SC5->C5_TPFRETE	:= SUA->UA_TPFRETE
		SC5->C5_XTIPO	:= SUA->UA_XTIPOPV
		SC5->C5_XTIPF	:= SUA->UA_XTIPFAT
		SC5->C5_XDTEN	:= SUA->UA_XDTENTR
		SC5->C5_ZCODOBR := SUA->UA_ZCODOBR
		SC5->C5_ZOPERAD	:= SUA->UA_OPERADO
		SC5->C5_VEND2	:= SUA->UA_VEND2
		SC5->C5_COMIS2	:= nPerCom
		SC5->C5_ZENDENT	:= SUA->UA_ENDENT
		SC5->C5_ZBAIRRE	:= SUA->UA_BAIRROE
		SC5->C5_ZMUNE	:= SUA->UA_MUNE
		SC5->C5_ZESTE	:= SUA->UA_ESTE
		SC5->C5_ZCEPE	:= SUA->UA_CEPE
		SC5->C5_ZVALLIQ	:= SUA->UA_ZVALLIQ
		SC5->C5_XHISVEN	:= SUA->UA_XHISVEN
		SC5->C5_ZOBS    := SUA->UA_ZOBS
		SC5->C5_XALERTF := SUA->UA_XALERTF
		SC5->C5_XOBSEXP := SUA->UA_XOBSEXP
		SC5->C5_ZCONSUM	:= SUA->UA_ZCONSUM
		SC5->C5_ZFATBLQ	:= "3"
		// ONDA 1
		SC5->C5_XBLOQPV	:= "1"
		SC5->C5_XBLQFMI := "S"
		//Inclusao Joao Victor em 06/02/2013 referente ao item GAP 16 denominado "Identificação de Orçamento e Pedido de Venda"
		//	U_STTMKI90()
		//Giovani Zago Totvs 2º onda  Gap 09 14/02/2013
		//	U_STGAP09A()

		//****************************************************************

		SC5->C5_ZORCAME	  := SUA->UA_NUM
		SC5->C5_XORDEM    := SUA->UA_XORDEM  //ORDEM DE COMPRA
		SC5->C5_TIPOCLI   := SUA->UA_XTIPO   //TIPO DE CLIENTE (SOLIDARIO,CONS.FINAL,....))
		SC5->C5_VEND1     := SUA->UA_VEND    //VENDEDOR 1
		SC5->C5_VEND2     := SUA->UA_VEND2   //VENDEDOR 2
		SC5->C5_XHISVEN   := SUA->UA_XHISVEN //HISTORICO
		SC5->C5_CONDPAG   := SUA->UA_XCONDPG //COND. PAG.
		SC5->C5_ZCONDPG   := SUA->UA_XCONDPG //COND. PAG.
		SC5->C5_TRANSP    := SUA->UA_TRANSP  //TRANP
		SC5->C5_ZCONSUM   := SUA->UA_ZCONSUM //CONSUMO
		SC5->C5_LIBEROK   := 'S'//SUA->UA_ZCONSUM //CONSUMO
		SC5->C5_TIPLIB    := '1'
		SC5->C5_TPCARGA   := '2'
		SC5->C5_XNOME	  := SUA->UA_XNOME
		SC5->C5_XDE     := SUA->UA_XDE
		SC5->C5_XATE    := SUA->UA_XATE
		SC5->C5_XMDE    := SUA->UA_XMDE
		SC5->C5_XMATE   := SUA->UA_XMATE
		SC5->C5_XDANO   := SUA->UA_XDANO
		SC5->C5_XAANO   := SUA->UA_XAANO
		SC5->C5_XSTELLA := SUBSTR(SUA->UA_XSTELLA,1,1)
		SC5->C5_XCODMUN  := SUA->UA_XCODMUN
		SC5->C5_INDPRES := "3"//João Victor chamado 001404
		If	SUA->UA_TPFRETE = 'F' .And. SUA->UA_TRANSP = '000163' // BLOQUEAR TNT/FOB CHAMADO     GIOVANI ZAGO 09/09/2015
			SC5->C5_XTNTFOB  := "1"
		Endif
		SC5->C5_EMISSAO := DataValida(SC5->C5_EMISSAO)
		SC5->C5_XORIG   := SUA->UA_XORIG

		/****************************************
		Ação.........: Campos customizados integração CRM x Protheus - consCotacoes
		Desenvolvedor: Marcelo Klopfer Leme
		Data.........: 25/08/2022
		Chamado......: 20220727014715 - Integração de Cotações
		****************************************/

		If cEmpAnt=="11"
		SC5->C5_CODOPOR := UA_CODOPOR
		SC5->C5_NOMOPOR := UA_NOMOPOR
		SC5->C5_CODOBRA := UA_CODOBRA
		SC5->C5_NOMOBRA := UA_NOMOBRA
		EndIf

		U_STFAT190()
		U_STVLDZ68("SC5", "SC6", .T. , .F.)

		//Chamado 008952
		If SC5->C5_TIPO=="N" .And. cEmpAnt=="01"
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			If SA1->(DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI)))
				If AllTrim(SA1->A1_XEAN14O)=="S"
					SC5->C5_XOBSEXP  := "EAN14"
				EndIf
			EndIf
		EndIf

		U_STFAT150()

		SC5->C5_XVENDA := U_STAVALVD()

		/*************************************************************
		<<< ALTERAÇÃO >>> 
		Ação...........: Gravação do campo customizado Data Programada da Entrega
		...............: Foi criado um campo novo para não conflitar com o acampo existe "C5_DTENTRE"
		Regra..........: Se o Tipo de Operação for "IGUAL A 01 NÃO EFETUA A RESERVA" 
		...............: Se o Tipo de Operação for "DIFERENTE DE 01 EFETUA A RESERVA" 
		Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
		Data...........: 02/05/2022
		Chamado........: 20220429009114 - OFERTA LOGISTICA
		*************************************************************/				
		SC5->C5_XDTENPR := SUA->UA_XDTENPR
		SC5->C5_XENTFAT := SUA->UA_XENTFAT //Kleber Ribeiro CRM Services 18/05/2023 - inserido campos abaixo ref projeto entrega programada
		SC5->C5_XDE		:= SUA->UA_XDE
		SC5->C5_XMDE	:= SUA->UA_XMDE
		SC5->C5_XDANO	:= SUA->UA_XDANO
		SC5->C5_XATE	:= SUA->UA_XATE
		SC5->C5_XMATE	:= SUA->UA_XMATE
		SC5->C5_XAANO	:= SUA->UA_XAANO
		SC5->(MsUnLock())
		SC5->(DbCommit())//Giovani Zago 25/02/14

		If cEmpAnt=="11"
		If !Empty(SUA->UA_XGUID)
			U_STFAT612()
		EndIf
		EndIf

		// ticket Nº 20210211002338 / 20210601009141 - Valdemir Rabelo 18/06/2021
		if lAtiva  .and. (SC5->C5_XTIPO=='1')   // Gera Agendamento
			U_ADDAGEPD()	 
		endif 

		U_STOFERLG(SC5->C5_FILIAL,SC5->C5_NUM,.T.) //Carregar informações da oferta logística - Renato Nogueira - 28/05/2014

		//
		//Leitura dos Impostos para Transferencia ao Pedido
		SC9->(DBSETORDER(1))
		For nI:=1 to len(aCols)
			//
			DbSelectArea("SC6")
			SC6->(DbSetOrder(1))
			IF SC6->(DbSeek(xFilial("SC6")+cPedido+GDFieldGet("UB_ITEM",nI) + GDFieldGet("UB_PRODUTO",nI)))

				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))
				SB1->(DbGoTop())
				If SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
					If AllTrim(SB1->B1_GRUPO) $ "039#040#041#042#047" //aqui
						AADD(_aGrupos,{SB1->B1_COD,SB1->B1_GRUPO})
						_lEnvGrp	:= .T.
					EndIf
				EndIf

				SC6->(RecLock("SC6",.F.))
				SC6->C6_ZVALICM	:= GDFieldGet("UB_ZVALICM",nI)			// Valor do ICMS
				SC6->C6_ZVALIPI	:= GDFieldGet("UB_ZVALIPI",nI)			// Valor do IPI
				SC6->C6_ZVALIST	:= GDFieldGet("UB_ZVALIST",nI)			// Valor do ICMS ST
				SC6->C6_ZPICMS	:= GDFieldGet("UB_ZPICMS",nI)			// Aliq. ICMS
				SC6->C6_ZVALLIQ	:= GDFieldGet("UB_ZVALLIQ",nI)			// Valor do Liquido

				//GIOVANI******************************************************************************************************************************
				SC6->C6_COMIS1  := GDFieldGet("UB_XCOMIS1",nI)			//SUB->UB_XCOMIS1  //PORCENTAGEM DE COMISSAO VEND1
				SC6->C6_XVALCOM := GDFieldGet("UB_XVCOMS1",nI)			//SUB->UB_XVCOMS1  //VALOR COMISSAO VEND1
				SC6->C6_COMIS2  := GDFieldGet("UB_XCOMIS2",nI)			//SUB->UB_XCOMIS2  //PORCENTAGEM DE COMISSAO VEND1
				SC6->C6_XORDEM  := GDFieldGet("UB_XORDEM",nI)			//SUB->UB_XORDEM   //ORDEM DE COMPRA DO CLIENTE
				SC6->C6_XPORDEC := GDFieldGet("UB_XPORDEC",nI)			//SUB->UB_XPORDEC  //PORCENTAGEM DE DESCONTO ADICIONAL
				SC6->C6_XVALDES := GDFieldGet("UB_XVALDES",nI)			//SUB->UB_XVALDES	//VALOR DE DESCONTO ADICIONAL
				SC6->C6_XACREPO := GDFieldGet("UB_XACREPO",nI)			//SUB->UB_XACREPO	//PORCENTAGEM DE ACRESCIMO ADICIONAL
				SC6->C6_XACREVA := GDFieldGet("UB_XACREVA",nI)			//SUB->UB_XACREVA  //VALOR DE ACRESCIMO ADICIONAL
				SC6->C6_XVALACR := GDFieldGet("UB_XVALACR",nI)			//SUB->UB_XVALACR	//VALOR DE ACRESCIMO CONDIÇÃO DE PAGAMENTO
				SC6->C6_XPORACR := GDFieldGet("UB_XACRECP",nI)			//SUB->UB_XACRECP	//PORCENTAGEM DE ACRESCIMO CONDIÇÃO DE PAGAMENTO
				SC6->C6_XPRCLIS := GDFieldGet("UB_PRCTAB",nI)			//SUB->UB_PRCTAB   //GRAVA PREÇO DE LISTA CUSTOMIZADO
				SC6->C6_PRUNIT  := GDFieldGet("UB_VRUNIT",nI)			//SUB->UB_VRUNIT  //GRAVA PREÇO DE LISTA COM O PREÇO DE VENDA( NAO GERAR DESCONTO )
				SC6->C6_DESCONT := 0
				SC6->C6_VALDESC := 0
				SC6->C6_OPER    := GDFieldGet("UB_OPER",nI)			//SUB->UB_OPER
				SC6->C6_XTABPRC := GDFieldGet("UB_XTABPRC",nI)
				SC6->C6_XCUSTO := GDFieldGet("UB_XCUSTO",nI)
				SC6->C6_XCAMPA := GDFieldGet("UB_XCAMPA",nI) //22/12/14 GIOVANI ZAGO
				SC6->C6_ZENTREP := GDFieldGet("UB_ZENTREP",nI)//Kleber Ribeiro CRM Services 18/05/2023 - inserido campos abaixo ref projeto entrega programada

				If Empty(SC6->C6_OPER) .And. SC5->C5_TIPOCLI<>"X" //Renato Nogueira - Verificação do erro de tipo de operação não gravada
					MsgAlert("Atenção, o tipo de operação não será gravado, não feche essa tela e entre em contato com o TI imediatamente, obrigado!STFSVE70")
					MsgAlert("Atenção, o tipo de operação não será gravado, não feche essa tela e entre em contato com o TI imediatamente, obrigado!STFSVE70")
					MsgAlert("Atenção, o tipo de operação não será gravado, não feche essa tela e entre em contato com o TI imediatamente, obrigado!STFSVE70")
				EndIf

				SC6->C6_ZNCM    := GDFieldGet("UB_ZNCM",nI)			//SUB->UB_ZNCM
				SC6->C6_ZIPI   	:= GDFieldGet("UB_ZIPI",nI)			//SUB->UB_ZIPI
				SC6->C6_ZB2QATU	:= GDFieldGet("UB_ZB2QATU",nI)			//SUB->UB_ZB2QATU
				SC6->C6_ZMARKUP	:= GDFieldGet("UB_ZMARKUP",nI)			//SUB->UB_ZMARKUP
				SC6->C6_ZMOTBLO	:= GDFieldGet("UB_XBLQITE",nI)			//SUB->UB_XBLQITE
				SC6->C6_XPRCCON := GDFieldGet("UB_XPRCCON",nI)			//SUB->UB_XPRCCON
				SC6->C6_QTDLIB  := GDFieldGet("UB_QUANT",nI)			//SUB->UB_QUANT
				SC6->C6_QTDEMP  := GDFieldGet("UB_QUANT",nI)			//SUB->UB_QUANT
				SC6->C6_UM  	:= GDFieldGet("UB_UM",nI)			//SUB->UB_UM
				SC6->C6_ZPRCTAB := GDFieldGet("UB_ZPRCTAB",nI)			//SUB->UB_ZPRCTAB
				SC6->C6_XULTPRC := GDFieldGet("UB_XULTPRC",nI)			//SUB->UB_XULTPRC
				SC6->C6_ZLULT   := GDFieldGet("UB_ZLULT",nI)			//SUB->UB_ZLULT
				SC6->C6_ZRESERV := Posicione("PA2",4,xFilial("PA2")+xFilial("SC6")+SC6->C6_NUM+SC6->C6_ITEM,"PA2_QUANT")
				SC6->C6_ITEMPC  := GDFieldGet("UB_XITEMPC",nI)          // Item do pedido cliente     inserido Jefferson
				SC6->C6_NUMPCOM := GDFieldGet("UB_XNUMPCO",nI)          // Numero do pedido cliente   inserido Jefferson
				SC6->C6_ENTRE1  := GDFieldGet("UB_DTENTRE",nI)// DATA DE ENTRGA

			    _nSldDisp   :=  u_versaldo(SC6->C6_PRODUTO)
				_dNewData   :=  u_atudtentre(_nSldDisp,SC6->C6_PRODUTO,SC6->(C6_QTDVEN-C6_QTDENT))

				SC6->C6_ENTREG  := _dNewData
				
				//SC6->C6_ENTRE1  := GDFieldGet("UB_DTENTRE",nI)// DATA DE ENTRGA
				SC6->C6_FCICOD	:= U_STGETFCI(GDFieldGet("UB_PRODUTO",nI)) //Renato - Adicionar FCI no pedido
				SC6->C6_ZPRCPSC := GDFieldGet("UB_ZPRCPSC",nI)

				SC6->(Msunlock("SC6"))
				SC6->(DbCommit())

				//Giovani Zago 05/03/14 liberação de credito automatico

				If SC5->C5_CONDPAG $ _cConPag

					lCredito := .F.
				ElseIf !Empty(SC5->C5_PEDEXP)
					lCredito := .F.
					//giovani zago bloquear pedido sem serasa e serasa vencido 17/08/18 007862
				ElseIf !(Empty(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XDTSERA")))
					If dDataBase > (Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XDTSERA") + getmv("ST_FINLIB3",,160) )
						lCredito := .F.
					Else
						lCredito := .T.
					EndIf
				ElseIf  Empty(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XDTSERA"))
					lCredito := .F.
					////////////////////////
				Else
					lCredito := MaAvalCred(SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_VALOR,SC5->C5_MOEDA,.F.)
				EndIf
				U_STLOGFIN(SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRCVEN,SC6->C6_QTDVEN,lCredito,.T.)
                
				// Antes de liberar efetuar estorno caso exista. 
				nRecno:= SC6->(RecNo())
				
				IF SC9->(DBSEEK(SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM))	
                   DBSELECTAREA('SC9')
	               While ! SC9->(EOF()) .AND. SC9->C9_FILIAL = SC6->C6_FILIAL .AND. ;
				      SC9->C9_PEDIDO = SC6->C6_NUM .AND. SC9->C9_ITEM = SC6->C6_ITEM 
					  a460Estorna()
					  SC9->(DBSKIP())
				   ENDDO 
				   DbSelectArea("SC6")
			       SC6->(DbSetOrder(1))				   
				   SC6->(DbGoto(nRecno))
				ENDIF
				
				MaLibDoFat(SC6->(RecNo()), SC6->C6_QTDLIB,.F.,.T.,lCredito,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
				MaLiberOk({SC6->C6_NUM},.F.)
				MsUnLockall()
				SC6->(DbGoto(nRecno))
				dbcommitall()

			EndIf
		Next nI
		If lCredito
			u_STC9LIB('','',cusername,dtoc(date()),time(),'')
		EndIf

		/* Retirado daqui e colocado no final da função STVLDPED para não ficar com lock na sb2
		//
		AVISO('Pedido Gerado !',;
		'Sr(a).' + ALLTRIM(Substr(cUsuario,7,15)) + ', foi gerado o pedido de número: ' + _CRLF + _CRLF +;
		SC5->C5_NUM ,{'OK'},2,"")

		//				Alert("Foi gerado o pedido de número " + SC5->C5_NUM + " !")
		///////// Fim Alteracao Donizeti
		*/
	Endif

	If _lEnvGrp
		U_STEMLGRP("PEDIDO",SC5->C5_NUM,_aGrupos,SC5->C5_VEND1)
	EndIf

	RestArea(aSA3Area)
	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE70  ºAutor  ³Microsiga           º Data ³  01/27/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para analisar o pedido de venda            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSVE72()
	Local lRet 		:= .T.
	Local aArea 	:= GetArea()
	Local aSF4Area	:= SF4->(GetArea())
	Local lExporta	:= SC5->C5_TIPOCLI == "X"

	SF4->(dbsetOrder(1))

	If !(lExporta)
		If ALTERA
			//If U_STISTLV(SC5->C5_NUM)
			If !Empty(AllTrim(SC5->C5_ZORCAME))
				//MsgAlert("Este pedido de venda só pode ser alterado pela opção de TELEVENDAS - Call Center!")
				//MsgInfo("Este Pedido de Venda Fora Originado pela Rotina de Televendas do Módulo Call Center.";
					//	+CLR+CLR+"O Número do Orçamento Gerado é "+(SC5->C5_ZORCAME)+".","Alerta - Informação")
				lRet := .T. //ALTERADO POR JOAO VICTOR EM 23/01/2013
			Endif

			If lRet .and. !(SC5->C5_TIPO == "N") .and. SC5->C5_XBLOQPV == "2"
				//MsgAlert("Pedidos desbloqueados deste tipo não podem ser alterados!")
				//	lRet := .F.
			Endif

			//Verifica se existe controle PE1 - somente Manaus
			If !Empty(SC5->C5_XCTRL)
				MsgAlert("Este pedido de venda não pode ser alterado pois hÁ controle de paletes / expedição!")
				lRet := .F.
			Endif

		Endif
	Endif
	RestArea(aSF4Area)
	RestArea(aArea)

	If lRet
		//U_STFSC10A(PARAMIXB[1])  // funcao para gravar a reserva ou falta
		//U_STFSC10B()  // funcao para gravar a reserva ou falta - ALTERADO EM 07/05/2013 POR JOÃO VICTOR CONFORME SOLICITAÇÃO DE RENATO OLIVEIRA.
		U_STFSVE93() //Funcao para atualizar o campo de Data de Entrega Especifico (C5_XDATENTR)
	Endif
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE70  ºAutor  ³Microsiga           º Data ³  01/27/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para desbloquear pedido de venda bloqueado por flag  º±±
±±º          ³(campo C5_XBLOQPV)                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSVE73()

	If (Aviso("Desbloqueio de pedido de venda","Deseja desbloquear este pedido de venda?",{"Desbloquear","Cancelar"})) == 1
		MsgRun( "Desbloqueando e liberando o pedido de vendas "+ SC5->C5_NUM +"...",, {|| LibPVBlq()} )
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE70  ºAutor  ³Microsiga           º Data ³  01/27/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para desbloquear pedido de venda bloqueado por flag  º±±
±±º          ³(campo C5_XBLOQPV)                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LibPVBlq()
	Local aSaldos	:= {}
	Local aSC6Area	:= SC6->(GetArea())
	Local aSC5Area	:= SC5->(GetArea())
	Local aSF4Area	:= SF4->(GetArea())
	Local aArea		:= GetArea()

	SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	SF4->(dbsetOrder(1)) //F4_FILIAL+F4_CODIGO
	SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO

	If !SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
		Return .F.
	Endif

	If !Empty(C5_NOTA).Or.C5_LIBEROK=='E' //.And. Empty(C5_BLQ)
		MsgAlert("Não é possível realizar a liberação deste pedido pois o mesmo já se encontra faturado!")
		Return .F.
	Endif

	Begin Transaction

		SC5->(RecLock("SC5",.F.))
		SC5->C5_XBLOQPV := '2'
		SC5->(MsUnlock())

		While SC6->(!Eof() .and. C6_FILIAL+C6_NUM == xFilial("SC6")+SC5->C5_NUM)

			SF4->(DbSeek(xFilial("SF4")+ SC6->C6_TES))
			lAvalEC := SF4->F4_ESTOQUE == "S"

			SC9->(DbSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM)))
			While SC9->(! Eof() .and. C9_FILIAL+C9_PEDIDO+C9_ITEM == xFilial("SC9")+SC6->(C6_NUM+C6_ITEM))
				If Empty(SC9->C9_ORDSEP)
					a460Estorna() // Estorna o item liberado
					Exit
				Endif
				SC9->(DbSkip())
			End
			SC6->(aSaldos := {{ "","","","",C6_QTDVEN,ConvUm(C6_PRODUTO,0,2,C6_QTDVEN),Ctod(""),"","","",C6_LOCAL,0}})
			nRecno:= SC6->(Recno())
			MaLibDoFat	(SC6->(Recno()),SC6->C6_QTDVEN,.T.,.T.,lAvalEC,lAvalEC,.F.,.F.,Nil,,aSaldos,Nil,Nil,Nil)
			MaLiberOk	({SC6->C6_NUM},.F.)
			MsUnLockall()
			SC6->(DbGoto(nRecno))

			SC6->(DbSkip())
		End

		SC5->(U_STGrvSt(C5_NUM,C5_XTIPF=="2"))  // analisa e grava o status
		U_STPriSC5()  // grava prioridade

	End Transaction

	RestArea(aSF4Area)
	RestArea(aSC5Area)
	RestArea(aSC6Area)
	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSVE74  ºAutor  ³Microsiga           º Data ³  02/23/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ utilizado no pe MBRWBTN para permitir ou nao a alteracao   º±±
±±º          ³ do pedido de venda                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STFSVE74(cAlias,nRec,nBotao)
	Local lRet := .T.

	If FunName() == 'MATA410'
		If nBotao == 4
			If U_STISTLV(SC5->C5_NUM)
				//MsgAlert("Este pedido de venda só pode ser alterado pela opção de TELEVENDAS - Call Center!")
				//MsgInfo("Este Pedido de Venda Fora Originado pela Rotina de Televendas do Módulo Call Center.";
					//	+CLR+CLR+"O Número do Orçamento Gerado é "+(SC5->C5_ZORCAME)+".","Alerta - Informação")
				lRet := .T. //ALTERADO POR JOAO VICTOR EM 23/01/2013
			Endif
		Endif
	ElseIf FunName() == 'MATA380'
		If nBotao == 4 .or. nBotao == 5
			lRet := U_STFSC10E() //Funcao para validar se existe ordem de separacao para o empenho posicionado.
		Endif
	Endif

Return lRet
