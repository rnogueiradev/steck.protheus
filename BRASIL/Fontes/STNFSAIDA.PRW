#INCLUDE "TBICONN.CH"
#INCLUDE "MATA461.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWADAPTEREAI.CH"
#Include "Rwmake.ch"
#Include "TopConn.ch"

//aTitulo
#DEFINE _VLRTIT_		01
#DEFINE _VLRIRRF_		02
#DEFINE _VLRINSS_		03
#DEFINE _VLRISS_		04
#DEFINE _VLRPIS_		05
#DEFINE _VLRCSLL_		06
#DEFINE _VLRCOFI_		07
#DEFINE _VLRIPI_   		08
#DEFINE _VLRSOL_   		09
#DEFINE _VLRMOE_   		10
#DEFINE _VLRREA_   		11
#DEFINE _VLRACR_   		12
#DEFINE _VLRDSPMOE_		13 //Valor despesas acessorias na moeda
#DEFINE _VLRDSPREA_    14 //Valor despesas acessorias em real
#DEFINE _VLRTITDIF_    15 //Diferenca no valor do titulo na moeda do titulo
#DEFINE _TAXANDF_      16 //Taxa da NDF
#DEFINE _MOEDANDF_     17 //Moeda da NDF
#DEFINE _VLRFET_       18 //Valor do FETHAB
#DEFINE _VLRDESPAC2_   19 //Diferença no rateio das despesas acessorias em dolar
#DEFINE _VLRFAB_       20 //Valor do FABOV
#DEFINE _VLRFAC_       21 //Valor do FACS
#DEFINE _VLRTPDP_      22 //Valor do FACS

//aImposto
#DEFINE _IMPFET_		08 //Valor do FETHAB
#DEFINE _IMPFAB_		09 //Valor do FABOV
#DEFINE _IMPFAC_		10 //Valor do FACS

//GetMv
#DEFINE  __ULMES    	01
#DEFINE  __LIBGRUPO 	02
#DEFINE  __FRETMOE  	03
#DEFINE  __CONTSOC	 	04
#DEFINE  __MCUSTO	 	05
#DEFINE  __MOEDTIT	 	06
#DEFINE  __TXPER	 	07
#DEFINE  __TPCOMIS	 	08
#DEFINE  __1DUP	 		09
#DEFINE  __1DUPREF	 	10
#DEFINE  __1DUPNAT	 	11
#DEFINE  __RATDESP  	12
#DEFINE  __SERCUP   	13
#DEFINE  __TPNRNFS  	14
#DEFINE  __EECFAT   	15
#DEFINE  __RTIPFIN  	16

//Entry Point - Pontos de Entrada
#DEFINE EP_M460MKB	 	01
#DEFINE EP_M461IMPF 	02
#DEFINE EP_SF2460I	 	03
#DEFINE EP_M460IPI	 	04
#DEFINE EP_M460ICM	 	05
#DEFINE EP_M460SOLI 	06
#DEFINE EP_MSD2UM2	 	07
#DEFINE EP_MSD2460	 	08
#DEFINE EP_MTASF2	 	09
#DEFINE EP_F440COM	 	10
#DEFINE EP_M460IREN 	11
#DEFINE EP_M460ISS 		12
#DEFINE EP_M460VISS 	13
#DEFINE EP_M460ATEC 	14
#DEFINE EP_M460NITE 	15
#DEFINE EP_M460PROC 	16
#DEFINE EP_M460QRY  	17
#DEFINE EP_M460FIL  	18
#DEFINE EP_M460RTPD 	19
#DEFINE EP_M460FIM  	20
#DEFINE EP_M460COND 	21
#DEFINE EP_M460INSS 	22
#DEFINE EP_M460ITPD 	23
#DEFINE EP_M460ORD  	24
#DEFINE EP_M460MOED 	25
#DEFINE EP_M460FIT  	26
#DEFINE EP_M460IPT	 	27
#DEFINE EP_M460QRT  	28
#DEFINE EP_M460SOT  	29
#DEFINE EP_MSD246T	 	30
#DEFINE EP_MSD2UMT	 	31
#DEFINE EP_SF2460T	 	32
#DEFINE EP_M460RAT  	33
#DEFINE EP_M461ACRE 	34
#DEFINE EP_M460NOTA 	35
#DEFINE EP_M460ICMT		36
#DEFINE EP_M460QUEB		37

//aSavRat
#DEFINE SV_PEDIDO   	01
#DEFINE SV_FRETE    	02
#DEFINE SV_FRETAUT  	03
#DEFINE SV_SEGURO   	04
#DEFINE SV_DESPESA  	05
#DEFINE SV_DESCONT  	06
#DEFINE SV_DESPAC2  	07
#DEFINE SV_VLR_FRT  	08

//aRateio
#DEFINE RT_PEDIDO   	01
#DEFINE RT_ITEM     	02
#DEFINE RT_SEQUEN   	03
#DEFINE RT_FRETE    	04
#DEFINE RT_SEGURO   	05
#DEFINE RT_DESPESA  	06
#DEFINE RT_FRETAUT  	07
#DEFINE RT_DESCONT  	08
#DEFINE RT_PRECOIT  	09
#DEFINE RT_PDESCON  	10
#DEFINE RT_DESPAC2  	11
#DEFINE RT_DESPMOE  	12
#DEFINE RT_VLR_FRT  	13

#DEFINE __UFORI  		01
#DEFINE __ALQORI 		02
#DEFINE __PROPOR 		03

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis Staticas do Programa                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static aEntry     := {}
Static aFisGet    := Nil
Static aFisGetSC5 := Nil
Static aRelImp    := Nil
Static aSavRat    := {}
Static cOriPed    := "" //Origem do Pedido
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis Staticas para utilizacao do arquivo SD9 na numeracao de DOC   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static cMin460D
Static dDatabOri := Ctod("")
Static aSerieSD9 := {}                    // Series utilizadas no controle pelo SD9
Static cFilOri   := ""                    //filial  para controle de numeracao SD9
/*====================================================================================\
|Programa  | STNFSAIDA         | Autor | GIOVANI.ZAGO             | Data | 21/02/2018 |
|=====================================================================================|
|Descrição | STNFSAIDA                                                                |
|          |  FATURAMENTO NF DE SAIDA				                                  |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ms520vld                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*-----------------------------*
User Function STNFSAIDA	()
	*-----------------------------*
	Local lContinua	:= .T.
	Local lIntACD	  	:= SuperGetMV("MV_INTACD",.F.,"0") == "1"

	Local aIndexSC9	:= {}
	Local aCores	  	:= {}
	Local aRotAdic	:= {}				// Array utilizado no ponto de entrada
	Local lFatPrev	:= SuperGetMV( 'MV_FATFTPR', .F., .T. )	//Indica se permite faturar itens previstos (C9_TPOP = P)
	Local cMarca    := ""
	Local cMarcaAgr := ""
	Local cQryUpd   := ""
	Local lAgrupad  := .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para e-Commerce      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local lECommerce := SuperGetMV("MV_LJECOMM",,.F.)
	PRIVATE bFiltraBrw         // Expressao de Filtro
	PRIVATE nOrdNFS   := 1     // Ordem de Geracao da Nota Fiscal
	PRIVATE aRotina   := {  { STR0001,"Ma460Pesq", 0 , 1},;  //"Pesquisar"
	{ STR0002 ,"Ma460Ordem" , 0 , 0},; //"Ordem"
	{ STR0003 ,"U_STFAT999"  , 0 , 4},; //"Prep. Doc's"
	{ STR0004 ,"Ma461Estor" , 0 , 0},; //"Estor.Doc's"
	{ STR0033 ,"Ma461View"  , 0 , 2},; //"Visualiza Doc."
	{ STR0042 ,"A461Legend" , 0 , 6},; //"Legenda"
	{ STR0041 ,"Ma461Conh"  , 0 , 4} } //"Conhecimento"

	PRIVATE cFilSC9		:= ""
	PRIVATE cQrySC9		:= ""
	Private _aPedPv			:= {}

	PRIVATE cCadastro := OemToAnsi(STR0005)                  //"Prepara‡„o dos Documentos de Sa¡da"
	Private c460Cond  := ""

	//aRotina := {}

	If GetMv("ST_NFNEW1",,.F.) .Or. __cuserid = '000645'

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Carga das Variaveis Staticas do Programa                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea('SC9')	//Liberação de Pedidos
		SC9->(DbSetOrder(1))	//C9_FILIAL + C9_PEDIDO + C9_ITEM + C9_SEQUEN + C9_PRODUTO
		dbSelectArea("SFC")
		dbSelectArea("AF8")
		dbSelectArea("AFS")
		dbSelectArea("SES")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica o Ambiente de Processamento.                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( AMIIn(5,12,39,45,69,72) .And. lContinua )			// SigaFat - SigaLoja - SigaCda
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica o Fechamento do Estoque                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( MVUlmes() >= dDataBase )
				Help ( " ", 1, "FECHTO" )
				lContinua := .F.
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica o Fechamento do Fiscal                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( !FisChkDt(dDataBase) )
				lContinua := .F.
			EndIf

			If (   lContinua )

				cFilSC9 := ""
				cQrySC9 := ""

				cMarca	  := GetMark(,"SC9","C9_OK")

				Processa( { ||  NFNEW() },'Aguarde','Selecionando PEDIDOS...',@lContinua )

				If Len(_aPedPv)==0
					//MsgAlert("Nenhum pedido encontrado com esses parâmetros, verifique!")
					Return
				EndIf

				MaNfsInit()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Array com as cores que definem cada status no markbrowser³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aCores := {	{'Empty(SC9->C9_BLEST)   .And. Empty(SC9->C9_BLCRED) .And. SC9->C9_BLWMS$"05,06,07,  "','ENABLE' },;	//Pedido de Venda liberado
				{'SC9->C9_BLEST=="10"    .And. SC9->C9_BLCRED=="10"  .And. SC9->C9_BLWMS$"05,06,07,  "','DISABLE'},;	//Pedido de Venda Faturado
				{'!(Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED) .And. SC9->C9_BLWMS$"05,06,07,  ")','BR_AZUL'}}	//Pedido de Venda com bloqueio

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Realiza a Filtragem                                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				bFiltraBrw := {|x| If(x==Nil,FilBrowse("SC9",@aIndexSC9,@cFilSC9),{cFilSC9,cQrySC9,"","",aIndexSC9}) }
				Eval(bFiltraBrw)
				SC9->(MsSeek(xFilial()))

				MarkBrow("SC9","C9_OK","A460Avalia()",,.t.,cMarca,,,,,,,,,aCores)

				dbSelectArea("SC9")
				RetIndex("SC9")
				dbClearFilter()
				aEval(aIndexSC9,{|x| Ferase(x[1]+OrdBagExt())})

			Else
				lContinua := .F.
			EndIf

			SetKey(VK_F12,Nil)
		Else
			lContinua := .F.
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Anula as variaveis staticas criadas pela funcao manfsinit               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MaNfsEnd()
	EndIf
Return( lContinua )

Static Function NFNEW()

	Local _cFilSC9		:= "SC9.C9_PEDIDO = 'xxxxxx'"
	Local _cPedido		:= ""
	Local _cItemPV		:= ""
	Local _cQuery		:= ""
	Local _aQuery		:= {}
	Local cMVXPGAVIS	:= SuperGetMV("MV_XPGAVIS",.F.,"501")
	Local cMVXSTCLI		:= SuperGetMV("MV_XSTCLI",.F.,"033467")		//Leo -> Verificacao se o cliente e' a propria STECK
	Local _cOrder  		:= '%ZZ2_PEDIDO%'
	Local _cErro		:= ""
	Local _lInc			:= .T.
	Local _nCount		:= 0
	Local _nxCount		:= 0
	Local _cFa10Oper    :=  GetMv("ST_FAOPER",,'74')//Giovani zago 14/06/2013 Tipos de Operação que nao entram na separação
	Local _lTrocNf      := .F.//giovani zago 27/01/2014 troca de nf
	Local _cInvent      := .T. // Variavel para analisar se no pedido de venda existe algum item em inventario rotativo
	Local aTipo 		:= {"1 - Consumidor Final","2 - Revendedor","3 - Solidário"}
	Local cItem 		:= space(20)
	Local oDxlg
	Local _cQuery2  	:= ""
	Local _cAlias2  	:= GetNextAlias()
	Local _cQuery3  	:= ""
	Local _cAlias3  	:= GetNextAlias()
	Private cPerg 			:= "NFNEW"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private _cPeInve		:= ' '
	Private _cProdInv		:= ' '

	_aPedPv := {}

	If Pergunte("RFAT01",.t.)

		_cQuery := " SELECT C9_PEDIDO,C9_LOCAL,C9_PRODUTO,C9_ITEM,C9_ORDSEP "
		_cQuery += " FROM "+RETSQLNAME("SC9")+" SC9"
		_cQuery += " INNER JOIN( SELECT * FROM "+RETSQLNAME("SC5")+")SC5
		_cQuery += " ON SC5.D_E_L_E_T_ = ' '
		_cQuery += " AND C5_NUM = C9_PEDIDO
		_cQuery += " AND C5_FILIAL = C9_FILIAL

		If MV_PAR12=1
			_cQuery += " AND C5_TRANSP <> ' '
		EndIf

		_cQuery += " AND SC5.C5_ZREFNF  <> '1'
		_cQuery += " AND SC5.C5_XTNTFOB <>'1'
		_cQuery += " AND SC5.C5_XOPER32 <> '2'
		//>>Ticket 20191107000028 - Everson Santana 08.11.2019
		_cQuery += " AND SC5.C5_XOPERCO <> '2' 
		//<<Ticket 20191107000028 - Everson Santana 08.11.2019
		_cQuery += " AND SC5.C5_EMISSAO BETWEEN   '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
		_cQuery += " AND SC5.C5_NUM            BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
		_cQuery += " AND SC5.C5_TRANSP      BETWEEN '" + MV_PAR03 + "' AND '" +MV_PAR04 + "' "
		_cQuery += " AND SC5.C5_CONDPAG    BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "

		If MV_PAR12=2
			_cQuery += " AND SC5.C5_PEDEXP <> ' ' "
		Else
			_cQuery += " AND SC5.C5_PEDEXP = ' ' "
		EndIf

		If MV_PAR08=3
			_cQuery += " AND SC5.C5_TRANSP = '000163' "
		EndIf

		If MV_PAR08<=2 //Retira ou entrega
			_cQuery += " AND SC5.C5_XTIPO     = '"+IIF(MV_PAR08=1,'1','2')+"'"
		EndIf

		lSaida:= .f.
		aTipo:= {"1 - Leroy","2 - C&C","3 - Telha Norte"}
		cItem:= space(20)
		If MV_PAR08=5

			Do While !lSaida

				Define msDialog oDxlg Title "Informe o Cliente:" From 10,10 TO 150,200 Pixel

				@ 010,010 COMBOBOX cItem ITEMS aTipo SIZE 80,80

				DEFINE SBUTTON FROM 030,030 TYPE 1 ACTION IF(!(Empty(alltrim(cItem))),(lSaida:=.T.,oDxlg:End()),msgInfo("Tipo de Cliente não preenchido","Atenção")) ENABLE OF oDxlg

				Activate dialog oDxlg centered

			EndDo

			If	Substr(cItem,1,1) = '1'
				_cQuery += " AND SC5.C5_CLIENTE='038134' "
			ElseIf	Substr(cItem,1,1) = '2'
				_cQuery += " AND SC5.C5_CLIENTE='014519' "
			ElseIf	Substr(cItem,1,1) = '3'
				_cQuery += " AND SC5.C5_CLIENTE='028358' "
			Endif

		Else

			_cQuery += " AND SC5.C5_CLIENTE<>'038134' "
			_cQuery += " AND SC5.C5_CLIENTE<>'014519' "
			_cQuery += " AND SC5.C5_CLIENTE<>'028358' "

		EndIf

		/*
		If MV_PAR08=5 //Leroy - Renato Nogueira - Chamado 002278
		_cQuery += " AND SC5.C5_CLIENTE='038134' "
		EndIf

		If MV_PAR08<>5 //Leroy - Renato Nogueira - Chamado 002278
		_cQuery += " AND SC5.C5_CLIENTE<>'038134' "
		EndIf
		*/

		If MV_PAR07=1
			_cQuery += " INNER JOIN ( SELECT CB7_STATUS,CB7_NOTA,CB7_PEDIDO ,CB7_FILIAL
			_cQuery += "  FROM "+RetSqlName("CB7")+" CB7  "
			_cQuery += " WHERE CB7.CB7_FILIAL =  '"+xFilial("CB7")+"'"
			_cQuery += " AND CB7.D_E_L_E_T_ <>  '*')TB7
			_cQuery += " ON TB7.CB7_PEDIDO   = SC9.C9_PEDIDO
			_cQuery += " AND TB7.CB7_NOTA = '         '
			_cQuery += " AND TB7.CB7_STATUS = '4'
		EndIf

		_cQuery += " WHERE C9_FILIAL = '"+xFilial("SC9")+"'"
		_cQuery += " AND C9_DATALIB > '20170101'
		_cQuery += " AND C9_NFISCAL = ' '
		_cQuery += " AND SC9.D_E_L_E_T_ = ' '

		If MV_PAR07=1
			_cQuery += " AND C9_ORDSEP <> ' '
		ElseIf MV_PAR07=2
			_cQuery += " AND C9_ORDSEP = ' '
		EndIf

		_cQuery += " ORDER BY C9_PEDIDO,C9_PRODUTO

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery),cAliasLif)

		dbSelectArea(cAliasLif)
		(cAliasLif)->(dbGoTop())
		While (cAliasLif)->(!Eof())
			_nCount++
			_nxCount++
			(cAliasLif)->(dbSkip())
		EndDo

		_cErro 		:= ""
		_cErroFin 	:= ""

		ProcRegua( _nCount )
		IncProc("Selecionando PEDIDOS... "+ cValToChar(_nxCount))
		dbSelectArea(cAliasLif)
		(cAliasLif)->(dbGoTop())
		While (cAliasLif)->(!Eof())

			If !Empty(_cErro)
				_cErroFin += _cErroCab+_cErro+chr(13)+chr(10)
			EndIf

			IncProc("Selecionando PEDIDOS... "+ cValToChar(_nxCount))
			_nxCount:= _nxCount-1
			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			If SC5->(dbSeek(xFilial("SC5")+(cAliasLif)->C9_PEDIDO))
				_lTrocNf      := !Empty(Alltrim(SC5->C5_XTRONF))//giovani zago 27/01/2014 troca de nf
			EndIf

			dbSelectArea("CBA")
			dbSetOrder(4)
			dbGoTop()
			If dbSeek(xFilial("CBA")+(cAliasLif)->C9_PRODUTO+"1"+(cAliasLif)->C9_LOCAL) // Filtra itens do pedido de venda que estejam em inventario rotativo.
				while CBA->(!eof()) .and. (cAliasLif)->C9_PRODUTO == CBA->CBA_PROD .AND. CBA->CBA_XROTAT = "1" .AND. (cAliasLif)->C9_LOCAL == CBA->CBA_LOCAL

					if CBA->CBA_STATUS $ "1/2/3/4/6"

						//MSGALERT("O item " +ALLTRIM((cAliasLif)->C9_PRODUTO)+ " do pedido "+ (cAliasLif)->C9_PEDIDO + " está em inventario rotativo e não será liberado para faturar!")
						_lInc := .F.
						_cInvent := .F.
						_cPeInve+= Alltrim((cAliasLif)->C9_PEDIDO)+'#'
						_cProdInv +=Alltrim((cAliasLif)->C9_PRODUTO)+"#CBA#"
						//(cAliasLif)->(dbSkip())    Removido por Valdemir 16/10/2019
						CBA->(dbSkip())
						Loop

					elseif CBA->CBA_STATUS = "5"
						// spl005029   505431
						dbSelectArea("SB7")
						SB7->(dbSetOrder(3))
						SB7->(dbGoTop())
						If SB7->(dbSeek(xFilial("SB7")+CBA->CBA_CODINV))

							if SB7->B7_STATUS <> "2"
								//	MSGALERT("O item " +(cAliasLif)->C9_PRODUTO+ " do pedido "+ (cAliasLif)->C9_PEDIDO + "está em inventario rotativo e será liberado para faturar!")
								_lInc := .F.
								_cInvent := .F.
								_cPeInve+= Alltrim((cAliasLif)->C9_PEDIDO)+'#'
								_cProdInv +=Alltrim((cAliasLif)->C9_PRODUTO)+"#SB7#"
								//(cAliasLif)->(dbSkip())     Removido por Valdemir 16/10/2019
								CBA->(dbSkip())
								Loop
							endif

						endif

					endif
					CBA->(dbSkip())
				end

			Endif

			//>> Rotina para verificar se o endereço está bloqueado mesmo que os itens do pedido não esteja sendo inventariado - Everson Santana 22.08.2019

			If !Alltrim((cAliasLif)->C9_PEDIDO) $ _cPeInve

				_cQuery3 := " SELECT * FROM "+RetSqlName("SDC")+" DC"
				_cQuery3 += " WHERE DC_ORIGEM = 'SC6'
				_cQuery3 += " AND DC_QUANT > 0
				_cQuery3 += " AND DC_PEDIDO = '"+Alltrim((cAliasLif)->C9_PEDIDO)+"'
				_cQuery3 += " AND D_E_L_E_T_ = ' '

				If !Empty(Select(_cAlias3))
					DbSelectArea(_cAlias3)
					(_cAlias3)->(dbCloseArea())
				Endif

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

				dbSelectArea(_cAlias3)
				(_cAlias3)->(dbGoTop())

				If (_cAlias3)->(!Eof())

					dbSelectArea("SBE")
					dbSetOrder(1)
					dbGotop()
					If dbSeek(xFilial("SBE")+(_cAlias3)->DC_LOCAL+(_cAlias3)->DC_LOCALIZ)

						If !Empty(SBE->BE_DTINV)

							_cPeInve+= Alltrim((cAliasLif)->C9_PEDIDO)+'#'
							_cProdInv +=Alltrim((cAliasLif)->C9_PRODUTO)+"#SBE#"

						Endif

					EndIf

					(_cAlias3)->(dbSkip())

				EndIf

			Endif

			//<<

			If !_lInc
				_lInc := .T.
			EndIf

			_lInc := .T.
			_cErroCab := "O Pedido "+(cAliasLif)->C9_PEDIDO+" possui divergencias: "
			_cErro 	  := ""

			//Renato Nogueira - Bloquear faturamento para clientes bloqueados - Solicitação Rogério Martelo - 09092013
			DbSelectArea("SA1")
			DbSetOrder(1)
			If DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
				If SA1->(!Eof()) .And. SC5->C5_TIPO=="N"
					If SA1->A1_MSBLQL=="1"
						_cErro += "Cliente bloqueado"
						_lInc := .F.
						(cAliasLif)->(dbSkip())
						Loop
					EndIf
					// Giovani Zago 06/08/2015 chamado 002099
					If GetMv("ST_FINLIB",,.F.)
						If SA1->A1_XBLQFIN=="1"
							_cErro += "Cliente bloqueado Fin."
							_lInc := .F.
							(cAliasLif)->(dbSkip())
							Loop
						EndIf
					EndIf

					// Giovani Zago 27/07/2016 chamado 003740
					If GetMv("ST_FINLIB2",,.F.)
						If !(Empty(SA1->A1_XDTSERA)) .And. !( SC5->C5_CONDPAG $ ('501/599/FRC' )) .And. SA1->A1_TIPO <> 'X'
							If dDataBase > ( SA1->A1_XDTSERA + getmv("ST_FINLIB3",,160) )
								_cErro += "Cliente bloqueado Fin.SERASA"
								_lInc := .F.
								(cAliasLif)->(dbSkip())
								Loop
							EndIf

						EndIf
					EndIf
				EndIf
			EndIf
			//Giovani Zago Não faturar 2 os e uma em aberto 14/04/14
			DbSelectArea('CB7')
			CB7->(DbSetOrder(2))
			CB7->(dbSeek(xFilial('CB7')+SC5->C5_NUM))
			While CB7->(!EOF()  .and. CB7_FILIAL+CB7_PEDIDO ==xFilial('CB7')+SC5->C5_NUM)

				If Val(CB7->CB7_STATUS) < 4
					_cErro += "OS em Aberto"
					_lInc := .F.
				EndIf
				If !VERIFCB9(CB7->CB7_FILIAL,CB7->CB7_ORDSEP)
					_cErro += "Volume aberto"
					_lInc  := .F.
				EndIf

				CB7->(dbSkip())
			End
			If !_lInc
				(cAliasLif)->(dbSkip())
				Loop
			EndIf

			If !SC5->C5_CLIENTE $ cMVXSTCLI	 .And.   !(Posicione('SC6',1,xFilial('SC6')+SC5->C5_NUM,"C6_OPER") $  _cFa10Oper ).And. !_lTrocNf	//Leo -> Verificacao se o cliente e' a propria STECK
				If SC5->C5_CONDPAG $ cMVXPGAVIS .And. SC5->C5_XLIBAVI <> "S"
					_cErro += "Condição de Pagamento a Vista."
					_lInc := .F.
					(cAliasLif)->(dbSkip())
					Loop
				EndIf

				dbSelectArea("SC6")
				dbSetOrder(1)
				If dbSeek(xFilial("SC6")+SC5->C5_NUM)
					If Posicione("SF4",1,XFILIAL("SF4")+SC6->C6_TES,"F4_ESTOQUE") == "S"
						dbSelectArea("CB7")
						dbSetOrder(1)

						If dbSeek(xFilial("CB7")+(cAliasLif)->C9_ORDSEP)
							If CB7->CB7_STATUS <> "4"
								_cErro += "Ordem de Separacao "+(cAliasLif)->C9_ORDSEP+" pendente."
								_lInc := .F.
								(cAliasLif)->(dbSkip())
								Loop
							EndIf
						Else
							_cErro += "Ordem de Separacao "+(cAliasLif)->C9_ORDSEP+" nao Localizada."
							_lInc := .F.
							(cAliasLif)->(dbSkip())
							Loop
						EndIf
					EndIf
				EndIf
			Endif

			IF SC5->C5_CLIENTE $ cMVXSTCLI	 .And.   (Posicione('SC6',1,xFilial('SC6')+SC5->C5_NUM,"C6_OPER") $  SuperGetMV("ST_OPEREMB",.F.,"15")) .And. cFilAnt == '01'//Apenas para a Filial 01 de SP e AM
				_cErro += "Operação "+SuperGetMV("ST_OPEREMB",.F.,"15")+" deve ser faturada pela rotina de Embarque...!!!"
				_lInc := .F.
				(cAliasLif)->(dbSkip())
				Loop
			EndIf

			//Verificar duas OS TNT

			If AllTrim(SC5->C5_TRANSP)=="000163"

				_cQuery2 := " SELECT C9_FILIAL, C9_PEDIDO, COUNT(DISTINCT C9_ORDSEP) QTDOS
				_cQuery2 += " FROM "+RetSqlName("SC9")+" C9
				_cQuery2 += " LEFT JOIN "+RetSqlName("SC5")+" C5
				_cQuery2 += " ON C5_FILIAL=C9_FILIAL AND C5_NUM=C9_PEDIDO AND C5_CLIENTE=C9_CLIENTE AND C5_LOJACLI=C9_LOJA
				_cQuery2 += " WHERE C9.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' AND C5_TRANSP='000163'
				_cQuery2 += " AND C9_FILIAL='"+SC5->C5_FILIAL+"' AND C9_NFISCAL=' ' AND C9_BLEST=' '
				_cQuery2 += " AND C9_BLCRED=' ' AND C9_ORDSEP<>' ' AND C9_PEDIDO='"+SC5->C5_NUM+"'
				_cQuery2 += " GROUP BY C9_FILIAL, C9_PEDIDO

				If !Empty(Select(_cAlias2))
					DbSelectArea(_cAlias2)
					(_cAlias2)->(dbCloseArea())
				Endif

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

				dbSelectArea(_cAlias2)
				(_cAlias2)->(dbGoTop())

				If (_cAlias2)->(!Eof())
					If (_cAlias2)->QTDOS>1
						_cErro += "Pedido TNT com duas OS para faturamento, favor cancelar uma"
						_lInc := .F.
						(cAliasLif)->(dbSkip())
						Loop
					EndIf
				EndIf

			EndIf

 			If Alltrim((cAliasLif)->C9_PEDIDO) $ _cPeInve
				_cErro += "Pedido com item sendo inventáriado: "+_cProdInv
				_lInc := .F.
				(cAliasLif)->(dbSkip())
				Loop
			Else
				If !(cAliasLif)->C9_PEDIDO $ _cPedido //.and. !(cAliasLif)->C9_PEDIDO $ _cPeInve //Chamado 008506 - Everson Santana - 29.11.18 Inclui a validação da variavel "_cInvent", para não trazer os pedidos que constem item sendo inventariados
					_cPedido += IIf(!Empty(_cPedido),"#","")+(cAliasLif)->C9_PEDIDO
					Aadd(_aPedPv,{.T.,(cAliasLif)->C9_PEDIDO,Alltrim(SC5->C5_XALERTF),IIF(SC5->C5_XTIPO = '1','RETIRA','ENTREGA')})
				EndIf
			EndIf

			If !_lInc
				_lInc := .T.
			EndIf

			(cAliasLif)->(dbSkip())
		EndDo

		If !Empty(_cErro) .And. Empty(_cErroFin)
			_cErroFin += _cErroCab+_cErro+chr(13)+chr(10)
		EndIf
		If !Empty(_cErroFin)
			@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Resumo do processamento'
			@ 005,005 Get _cErroFin Size 167,080 MEMO Object oMemo
			@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
			ACTIVATE DIALOG oDlg CENTERED
		EndIf

		IncProc("Selecionando PEDIDOS... 0" )

		If Len(_aPedPv) > 0
			_cPedido:= NFTEL(_aPedPv)
		EndIf

	EndIf
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

Return()

Static Function NFTEL(_aPedPv)
	Local _cRet		:= ' '
	Local i			:= 0
	Local oDlg
	Local aCores := {}
	Local aButtons := {}
	Local aSize        := MsAdvSize(, .F., 400)
	Local aInfo        := {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	Local aObjects     := {{100, 100,.T.,.T. }}
	Local aPosObj      := MsObjSize( aInfo, aObjects,.T. )
	Private cString := "NFTEL"
	Private _cNOME 	:= SPACE(25)
	Private _cArea	:= GetArea()
	Private _OldCadas:=cCadastro
	Private _OldRotina:=aRotina
	Private aSize    	:= MsAdvSize(.F.)
	Private lOk := .f.
	Private lInverte := .F.
	Private cMark   := GetMark()
	Private oMark//Cria um arquivo de Apoio

	cCadastro:= 'Faturamento'
	aRotina:= {}

	aCampos := {}                                   // Campos que serao exibidos no MarkBrowse
	AADD(aCampos,{"TRB_MARK"	,"Mark"           ,"X"})
	AADD(aCampos,{"TRB_PEDIDO"	," ",     "PEDIDO"})
	AADD(aCampos,{"TRB_OBS"		," ",     "OBS"})

	_aEstru := {}                             // Estrutura do Arquivo Temporario
	AADD(_aEstru,{"TRB_MARK"	, "C",02,     0})
	AADD(_aEstru,{"TRB_PEDIDO"	, "C",06,     0})
	AADD(_aEstru,{"TRB_OBS"		, "C",50,     0})

	_cArqTrb := CriaTrab(aCampos,.F.)     // Nome do Arquivo Temporario
	DbCreate(_cArqTrb,_aEstru)
	DbUseArea(.T.,,_cArqTrb,"TRB",.F.)

	For i:=1 To Len(_aPedPv)
		DbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB_MARK    := ""
		TRB_PEDIDO  :=  _aPedPv[i,2]
		TRB_OBS     :=  _aPedPv[i,3]

		MsUnlock()
	Next i

	//+---------------------------------------------+
	//| Monta o Mark Browse para selecao do nome     |
	//+---------------------------------------------+

	cMarca := getmark()

	DbSelectArea("TRB")
	DbGotop()

	aRotCop := aRotina
	aRotina := { }
	lSaida:= .f.
	nOpca:= 0

	//aButtons := {{"LBTIK",{|| PedStx()} ,"Gerar Financeiro"}}

	_cQuer:= ' '
	_cFils:= ' '
	DEFINE MSDIALOG oDlg TITLE "Selecione os Pedidos" From 0,0 To aSize[6]-15,aSize[5]-15 PIXEL
	DbSelectArea("TRB")
	DbGotop()//Cria a MsSelect
	oMark := MsSelect():New("TRB","TRB_MARK","",aCampos,@lInverte,@cMark,{aPosObj[1,1] ,aPosObj[1,2] ,aPosObj[1,3] ,aPosObj[1,4] },,,,,)
	oMark:oBrowse:bAllMark := {||MarkAll(cMark,@oMark,"TRB",oDlg)}
	Eval(oMark:oBrowse:bGoTop)
	oMark:oBrowse:Refresh()
	oMark:bMark := {| | Disp()} //Exibe a Dialog

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| lOk:= .t., oDlg:End()},{|| lOk:= .f.,oDlg:End()})

	DbSelectArea('TRB')
	TRB->(DbGoTop())
	If lOk
		While TRB->(!EOF())
			If TRB->TRB_MARK <> " "
				_cQuer += IIf(!(Empty(_cQuer)),",'","'")+ Alltrim(TRB->TRB_PEDIDO)+"'"
				_cFils += IIf(!(Empty(_cFils)),"#","")+ Alltrim(TRB->TRB_PEDIDO)
			EndIf
			TRB->(dbSkip())
		End

		cFilSC9 += " C9_FILIAL='"+xFilial("SC9")+"'"
		If !(Empty(_cFils))
			cFilSC9 +=" .AND.  C9_PEDIDO $ '"+_cFils+"'
		EndIf
		cQrySC9 += " SC9.C9_FILIAL='"+xFilial("SC9")+"'"
		If !(Empty(_cQuer))
			cQrySC9  +=" AND SC9.C9_PEDIDO IN ("+_cQuer+")"
		EndIf
	Else
		cFilSC9 += " C9_FILIAL='"+xFilial("SC9")+"'"

		cFilSC9 +=" .AND.  C9_PEDIDO = 'xxxxxx'

		cQrySC9 += " SC9.C9_FILIAL='"+xFilial("SC9")+"'"

		cQrySC9  +=" AND SC9.C9_PEDIDO = 'xxxxxx'

	EndIf

	DbSelectArea("TRB")
	DbCloseArea()

	cCadastro:=	_OldCadas
	aRotina	 :=   _OldRotina

Return()

Static Function MarkAll(cMark,oMark,cAlias,oDlg)

	DbSelectArea("TRB")
	("TRB")->(DbGoTop())

	While ("TRB")->(!Eof())

		("TRB")->(RecLock("TRB",.F.))
		IF ("TRB")->TRB_MARK == cMark
			("TRB")->TRB_MARK := ""
		Else
			("TRB")->TRB_MARK := cMark
		EndIf

		("TRB")->(DbSkip())

	EndDo
	DbSelectArea("TRB")
	("TRB")->(DbGoTop())
	Eval(oMark:oBrowse:bGoTop)
	oMark:oBrowse:Refresh(.t.)

Return Nil

Static Function Disp()
	RecLock("TRB",.F.)
	If Marked("TRB_MARK")
		TRB->TRB_MARK := cMark
	Else
		TRB->TRB_MARK := ""
	Endif
	MSUNLOCK()
	oMark:oBrowse:Refresh()
Return()

Static Function VERIFCB9(_cFilial,_cOrdsep)

	Local _lRet		:= .T.
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"

	cQuery1	 := " SELECT FILIAL, ORDSEP, TOTALOS "
	cQuery1  += " ,(SELECT SUM(CB9_QTEEMB) FROM "+RetSqlName("CB9")+" B9 WHERE B9.D_E_L_E_T_=' '
	cQuery1	 += " AND CB9_FILIAL=FILIAL AND CB9_ORDSEP=ORDSEP) TOTALEMB "
	cQuery1  += " FROM ( "
	cQuery1	 += " SELECT CB8_FILIAL FILIAL, CB8_ORDSEP ORDSEP, SUM(CB8_QTDORI) TOTALOS "
	cQuery1  += " FROM "+RetSqlName("CB8")+" B8 "
	cQuery1	 += " WHERE B8.D_E_L_E_T_=' ' AND CB8_FILIAL='"+_cFilial+"' AND CB8_ORDSEP='"+_cOrdsep+"' "
	cQuery1  += " GROUP BY CB8_FILIAL, CB8_ORDSEP ) "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->TOTALOS<>(cAlias1)->TOTALEMB
		_lRet	:= .F.
	EndIf

	cQuery1	 := " SELECT COUNT(*) CONTADOR "
	cQuery1  += " FROM "+RetSqlName("CB6")+" CB6 "
	cQuery1  += " WHERE CB6.D_E_L_E_T_=' ' AND CB6_FILIAL='"+_cFilial+"' AND CB6_XORDSE='"+_cOrdsep+"' "
	cQuery1  += " AND CB6_XPESO=0 "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->CONTADOR>0
		_lRet	:= .F.
	EndIf
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Return(_lRet)

/*====================================================================================\
|Programa  | STFAT999        | Autor | RENATO.OLIVEIRA           | Data | 31/01/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT999()

	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()
	Local _lInverte := ThisInv()
	Local _cMarca   := ThisMark()
	Local _lCont	:= .T.

	_cQuery1 := " SELECT C9_FILIAL, C9_PEDIDO, C9_ORDSEP, QTDCB8, QTDC9
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT XXX.*,
	_cQuery1 += " (SELECT COUNT(DISTINCT CB8_ITEM) FROM "+RetSqlName("CB8")+" CB8 WHERE CB8.D_E_L_E_T_=' ' AND CB8_FILIAL=C9_FILIAL AND CB8_ORDSEP=C9_ORDSEP) QTDCB8
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT C9_FILIAL, C9_PEDIDO, C9_ORDSEP, COUNT(*) QTDC9
	_cQuery1 += " FROM "+RetSqlName("SC9")+" SC9
	_cQuery1 += " WHERE SC9.D_E_L_E_T_=' ' AND C9_ORDSEP<>' ' AND C9_NFISCAL = ' ' AND
	_cQuery1 += Eval(bFiltraBrw,1)[2]

	If !(SubStr(AllTrim(Eval(bFiltraBrw,1)[2]),Len(AllTrim(Eval(bFiltraBrw,1)[2]))-3,3)=="AND")
		_cQuery1 += " AND
	EndIf

	If _lInverte
		_cQuery1 += " SC9.C9_OK<>'"+_cMarca+"'"
	Else
		_cQuery1 += " SC9.C9_OK='"+_cMarca+"'"
	EndIf

	_cQuery1 += " GROUP BY C9_FILIAL, C9_PEDIDO, C9_ORDSEP
	_cQuery1 += " ) XXX
	_cQuery1 += " ) ZZZ
	_cQuery1 += " LEFT JOIN "+RetSqlName("CB7")+" CB7
	_cQuery1 += " ON CB7_FILIAL=C9_FILIAL AND CB7_ORDSEP=C9_ORDSEP
	_cQuery1 += " WHERE CB7.D_E_L_E_T_=' ' AND CB7_STATUS='4' AND CB7_NOTA=' '

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())
		If !((_cAlias1)->QTDC9==(_cAlias1)->QTDCB8)
			_lCont := .F.
			MsgAlert("Pedido "+(_cAlias1)->C9_PEDIDO+" divergente. Qtde marcada "+cValToChar((_cAlias1)->QTDC9)+" / Qtde separada "+cValTochar((_cAlias1)->QTDCB8))
		EndIf
		(_cAlias1)->(DbSkip())
	EndDo

	If _lCont
		Ma460Nota("SC9")
	EndIf

Return
