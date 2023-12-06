#include "protheus.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"
#Define CR chr(13)+chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTEDIPV	บAutor  ณRenato Nogueira     บ Data ณ  25/02/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para ler as tabelas do EDI e importar os pedidos	  บฑฑ
ฑฑบ          ณ	    							 	 		        	บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//------------------------------------------------------------------------------------------//
//Altera็๕es:
//FR - 14/10/2021 - Ticket #20211013021811 cliente Dimensional ajustar qtde linhas para 20
//FR - 10/11/2021 - Ticket #20211109024068
//------------------------------------------------------------------------------------------//

User Function STEDIPV()

	Local cQuery:= ' '
	Local  cAlias:= 'STEDIPV'
	Private cWCodEmp    	:= "11"
	Private cWCodFil    	:= "01"

	PREPARE ENVIRONMENT EMPRESA cWCodEmp FILIAL cWCodFil  TABLES "ZZ6"

	cQuery	 := " SELECT * "
	cQuery  += " FROM " +RetSqlName("ZZ6")+ " ZZ6 "
	cQuery  += " WHERE ZZ6.D_E_L_E_T_=' ' AND ZZ6_FILIAL='"+cFilAnt+"' AND ZZ6_STATUS = '1'
	cQuery  += " ORDER BY R_E_C_N_O_ DESC

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	StartJob("U_STEDI01",GetEnvServer(), .F. )


	While (cAlias)->(!Eof())

		//Sleep(5000)

		StartJob("U_xSTEDIPV",GetEnvServer(), .F. , (cAlias)->ZZ6_NUMOC)		//FR VOLTAR

		//U_xSTEDIPV((cAlias)->ZZ6_NUMOC)		//FR PARA TESTE

		(cAlias)->(DbSkip())

	EndDo

Return()

User Function ZSTEDIPV(_cZZ6) // u_ZSTEDIPV('012085')

	PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'  TABLES "ZZ6"

	U_xSTEDIPV(_cZZ6)

	Reset Environment
Return()



User Function xSTEDIPV(_cZZ6)// u_xSTEDIPV('9696')

	Local aCabec 			:= {}
	Local aSC6   			:= {}
	Local _aAttach			:= {}
	Local _aPedidos			:= {}
	Local _aAreaSA1			:= {}
	Local _aAreaB1			:= {}
	Local _aItens			:= {}
	Local _cAssunto			:= ""
	Local cMsg				:= ""
	Local cAttach			:= ""
	Local _cCaminho			:= ""
	Local _cTransp			:= ""
	Local _cVend2			:= ""
	Local _cVend1			:= ""
	Local _cCodigo			:= ""
	Local _cProduto			:= ""
	Local _cStatus			:= ""
	Local _cCliente			:= ""
	Local _cCondPag			:= ""
	Local _cLoja			:= ""
	Local _cCodCli			:= ""
	Local _cDesc			:= ""
	Local _cLocPad			:= ""
	Local _nPreco			:= 0
	Local _nPrecoTab		:= 0
	Local _nPrecoSis		:= 0
	Local _nPrecoAnt		:= 0
	Local i					:= 0
	Local z					:= 0
	Local _nQtdItem			:= 0
	Local _nValLiqTot		:= 0
	Local _nValLiqPrd		:= 0
	Local _nPosCom1			:= 0
	Local _nPosComiss		:= 0
	Local _nValComiss		:= 0
	Local _nVaPed			:= 0
	Local _nSaldo			:= 0
	Local _lPrecoDiv		:= .F.
	Local _lPrcPsc			:= .F.
	Local _lCondDiv			:= .F.
	Local _cX				:= "00"
	Local _cBloq			:= " "
	Local _dDtEntrega		:= Date()
	Local _lTemStella		:= .F.
	Local cQuery 			:= ""
	Local cAlias 			:= "QRYEDI1"+Alltrim(_cZZ6)
	Local cQuery1 			:= ""
	Local cAlias1 			:= "QRYEDI2"+Alltrim(_cZZ6)
	Local _cQuery3 			:= ""
	Local _cAlias3 			:= ""
	Local _lPedOk			:= .T.
	Local _cTpEnt			:= ""
	Local _cTpFat			:= ""
	Local _cTpFre			:= ""
	Local _cPrDu			:= " "
	Local _PrDi				:= " "
	Local _cCep				:= " "
	Local _cCliNom			:= " "
	Local cC5NUM			:= "" //FR - 10/11/2021 - Ticket #20211109024068
	Local _cErro			:= "" //FR
	Local ii				:= 0  //FR
	Local _cUser            := ""//Alltrim(SuperGetMV("MV_USERSLU",.F.,"api_steck"))		// Valdemir Rabelo 20/09/2022
	Local _cSenha           := ""//Alltrim(SuperGetMV("MV_PSWSLUC",.F.,"api@steck@edi"))	// Valdemir Rabelo 20/09/2022
	Local cClient           := ""//GetMV("FS_CLIPORT",.F.,"03740001/04325217/04325206/09804801/04325204/04325238/04325213")     // Cliente+Loja
	Local _cJson            := " "
	Local nPed              := 0

	Private _cEmail  		:= ""  //"carla.lodetti@STECK.COM.BR;marcelo.oliveira@STECK.COM.BR " //FR - 10/11/2021 - Ticket #20211109024068
	Private _cCopia  		:= ""
	Private lMsErroAuto     := .F.
	Private lMsHelpAuto     := .T.
	Private nAliqICM		:= 0
	Private nValICms		:= 0
	Private nAliqIPI		:= 0
	Private nValIPI			:= 0
	Private nValICMSST		:= 0
	Private nValPis			:= 0
	Private nValCof			:= 0
	Private cZConsumo		:= ""
	Private _aEmail			:= {}
	Private cWCodEmp    	:= "11"
	Private cWCodFil    	:= "01"
	Private _cTabela		:= '001'
	Default _cZZ6 			:= 'x'

	PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01' TABLES "ZZ6"

	//_cZZ6 := "790591"

	_cUser            := Alltrim(SuperGetMV("MV_USERSLU",.F.,"api_steck"))		// Valdemir Rabelo 20/09/2022
	_cSenha           := Alltrim(SuperGetMV("MV_PSWSLUC",.F.,"api@steck@edi"))	// Valdemir Rabelo 20/09/2022
	cClient           := GetMV("FS_CLIPORT",.F.,"03740001/04325217/04325206/09804801/04325204/04325238/04325213")     // Cliente+Loja

	/****************************************
	A็ใo.........: Retirada a fun็ใo PREPARE ENVIRONMET da user fuction, estแ comflitando com o MVC da fun็ใo STEDIPV
	Desenvolvedor: Marcelo Klopfer Leme
	Data.........: 21/03/2022
	Chamado......: 20220311005640
	//	PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'  USER __cuserid TABLES "ZZ6" 
	****************************************/
	If !LockByName("STEDIPV"+Alltrim(_cZZ6),.F.,.F.,.T.)
		//ConOut("[STEDIPV]["+ FWTimeStamp(2) +"] - Jแ existe uma sessใo em processamento.")
		Return()
	EndIf

	If dow(date())= 1  .Or. dow(date())= 7 //domingo ---- sabado
		Return(.t.)
	EndIf

	_cAlias3 := GetNextAlias()

	_cEmail  := GetNewPar("STEDIPV" , "carla.lodetti@steck.com.br;marcelo.oliveira@steck.com.br;elizabeth.moura@steck.com.br ")

	cQuery	 := " SELECT * "
	cQuery  += " FROM " +RetSqlName("ZZ6")+ " ZZ6 "
	cQuery  += " WHERE ZZ6.D_E_L_E_T_=' ' AND ZZ6_FILIAL='"+cFilAnt+"' AND ZZ6_STATUS='1'
	cQuery  += " AND ZZ6_NUMOC = '"+ Alltrim(_cZZ6)+"' "
	//Memowrite("D:\QUERY\STEDIPFV.SQL", cQuery)

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())
		_cCliente := ' '
		_cLoja    := ' '
		_cCondPag := ' '
		_cVend1   := ' '

		//	Sleep(10000) //Espera 10 segundos antes de come็ar - Problema de estouro de email

		//Zerar todas as variaveis pra come็ar novamente
		_lPedOk		:= .T.
		_cTpFre		:= ""
		cZConsumo	:= ""
		_cBloq		:= " " //giovani zago 13/08/2018
		_lCondDiv	:= .F.
		_cCondPag	:= ""
		_cTransp	:= ""
		_lTemStella	:= .F.

		DbSelectArea("ZZ6")
		ZZ6->(DbGoTop())
		ZZ6->(DbGoTo((cAlias)->R_E_C_N_O_))

		//Conout("AQUI :"+ZZ6->ZZ6_NUMOC)

		DbSelectArea("SA1")
		SA1->(DbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
		SA1->(DbGoTop())
		If !SA1->(DbSeek(xFilial("SA1")+(cAlias)->(ZZ6_CLIENTE+ZZ6_LOJA)))
			Conout("OC: "+AllTrim((cAlias)->ZZ6_NUMOC)+" - Cliente: "+(cAlias)->(ZZ6_CLIENTE+ZZ6_LOJA)+" nใo encontrado")
			U_STMAILTES("daniel.mori@steck.com.br", ' ', "OC: "+AllTrim((cAlias)->ZZ6_NUMOC)+" - Cliente: "+(cAlias)->(ZZ6_CLIENTE+ZZ6_LOJA)+" nใo encontrado", '','') //voltar
			
			//_cEmail:= "flah.rocha@gmail.com;flah.rocha@sigamat.com.br"
			//FRSendMail(_cEmail, "", "OC: "+AllTrim((cAlias)->ZZ6_NUMOC)+" - Cliente: "+(cAlias)->(ZZ6_CLIENTE+ZZ6_LOJA)+" nใo encontrado", '', "" )  //FR - TESTE RETIRAR

			(cAlias)->(DbSkip())
			LOOP
		EndIf

		_aAreaSA1 := SA1->(GetArea())
		_cCliente := SA1->A1_COD
		_cLoja    := SA1->A1_LOJA
		IF ALLTRIM(SA1->A1_COD) $ Alltrim(SuperGetMV("ST_CONDSA1",.F.,"000224/001236"))
		   _cCondPag:=SA1->A1_ZCONDPG
		ELSE    
		   _cCondPag := ZZ6->ZZ6_CONDPG
		ENDIF   
		_cVend1   := SA1->A1_VEND
		_cCliNom  := SA1->A1_NOME
		/*********************************************
		<<<< ALTERAวรO >>>>
		A็ใo.........: Busca rela็ใo de e-mails casdastrado na tabela Z88 
		Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
		Data.........: 15/04/2022
		Chamados.....: 20220310005549/20220328006776
		****************************************/				
		Z88->(DBSETORDER(1))

		If  Substr(AllTrim(SA1->A1_NREDUZ),1,3) == 'MRV'

			IF Z88->(dbSeek(xFilial('Z88')+"C"+"MRV   " ))

				IF !EMPTY(Z88->Z88_EMAIL)
					_cEmail += ";"+ ALLTRIM(Z88->Z88_EMAIL)
				ENDIF

				IF !EMPTY(Z88->Z88_COPIAE)
					_cCopia := ALLTRIM(Z88->Z88_COPIAE)
				ENDIF

			EndIf

		Else

			IF Z88->(DBSEEK(XFILIAL("Z88")+"C"+SA1->A1_COD))
				IF !EMPTY(Z88->Z88_EMAIL)
					_cEmail += ";"+ ALLTRIM(Z88->Z88_EMAIL)
				ENDIF

				IF !EMPTY(Z88->Z88_COPIAE)
					_cCopia := ALLTRIM(Z88->Z88_COPIAE)
				ENDIF
			Else
				_cEmail += ";everson.santana@steck.com.br;carla.lodetti@steck.com.br"
			EndIf

		EndIf

		//Verifica se cliente estแ autorizado a usar o EDI
		If  Substr(AllTrim(SA1->A1_NREDUZ),1,3) <> 'MRV' //giovani zago libera MRV
			If !AllTrim(SA1->A1_XEDI)=="S"
				Conout("Cliente: "+AllTrim(SA1->A1_COD)+" nใo esta autorizado a usar o EDI"+" - OC: "+ZZ6->ZZ6_NUMOC)
				
				U_STMAILTES("everson.santana@steck.com.br", ' ', "Cliente: "+ AllTrim(SA1->A1_COD)+" nใo esta autorizado a usar o EDI, Nome: "+ Alltrim(SA1->A1_NOME) , '','')
				
				//FR retirar
				//_cEmail:= "flah.rocha@gmail.com;flah.rocha@sigamat.com.br"
				//FRSendMail(_cEmail, "", "Cliente: "+ AllTrim(SA1->A1_COD)+" nใo esta autorizado a usar o EDI, Nome: "+ Alltrim(SA1->A1_NOME), '', "" )  //FR - TESTE RETIRAR

				(cAlias)->(DbSkip())
				LOOP
			EndIf
		EndIf

		//Verifica se OC jแ existe na base, se tem produto bloqueado, desativado ou sem amarra็ใo
		DbSelectArea("ZZ7")
		ZZ7->(DbSetOrder(1)) //ZZ7_FILIAL+ZZ7_NUMOC+ZZ7_CLIENT+ZZ7_LOJA
		ZZ7->(DbGoTop())
		ZZ7->(DbSeek(xFilial("ZZ7")+(cAlias)->(ZZ6_NUMOC+ZZ6_CLIENT+ZZ6_LOJA)))

		_aItens	:= {}

		While ZZ7->(!Eof()) .And. 	ZZ6->(ZZ6_FILIAL+ZZ6_NUMOC+ZZ6_CLIENTE+ZZ6_LOJA)==;
		ZZ7->(ZZ7_FILIAL+ZZ7_NUMOC+ZZ7_CLIENT+ZZ7_LOJA)
			AADD(_aItens,{ZZ7->ZZ7_ITEMP,ZZ7->ZZ7_PRODUT,ZZ7->ZZ7_QUANT })
			ZZ7->(DbSkip())
		EndDo

		_cStatus	:= TUDOOK(SA1->A1_COD,SA1->A1_LOJA,AllTrim(ZZ6->ZZ6_NUMOC),_aItens)

		If _cStatus=="1" //Passou pela valida็ใo, continua
			//Conout("Valida็ใo da OC: "+ZZ6->ZZ6_NUMOC+" efetuada com sucesso")
		ElseIf _cStatus=="2" //OC jแ inserida, devolve true
			_lPedOk	:= .T.

			If _lPedOk
				ZZ6->(RecLock("ZZ6",.F.))
				ZZ6->ZZ6_STATUS	:= "2"
				ZZ6->(MsUnLock())
			EndIf

			(cAlias)->(DbSkip())
			LOOP
		ElseIf _cStatus=="3" //Problema com produto, devolve falso
			_lPedOk	:= .F.
			(cAlias)->(DbSkip())
			LOOP
		EndIf

		If !ZZ6->ZZ6_TPFRET $ "C#F#T#S"
			_cTpFre	:= "F" //Frete
		EndIf
		If (SA1->A1_TIPO $ 'R' .And. SA1->A1_CONTRIB = '1'  .And. (alltrim(SA1->A1_GRPVEN) $ 'D1/D2/D3/R1/R2/R3/R5' ) .And. (!Empty(ALLTRIM(SA1->A1_INSCR)) .Or. 'ISENT' $ Upper(ALLTRIM(SA1->A1_INSCR))))
			cZConsumo := "1"
		EndIf

		If !Empty(SA1->A1_TRANSP)
			_cTransp	:= SA1->A1_TRANSP
		EndIf
		If !Empty(SA1->A1_TPFRET)
			_cTpFre	:= SA1->A1_TPFRET
		EndIf

		If SA1->A1_COD=="006596"
			_cVend2	:= ' '//"I08553" //Marcelo Oliveira - recebimento de email prazo de entrega //desabilitado giovani zago
		EndIf

		cObserv	:= ZZ6->ZZ6_OBSERV

		If Substr(AllTrim(SA1->A1_NREDUZ),1,3) = 'MRV'
			cObserv	:=  Alltrim(ZZ6->ZZ6_NUMOC)+' - '+ Alltrim(cObserv)
		EndIf

		_cTpFat	:= "2" //Tipo de faturamento - sempre 2 - regra definida dia 13/11/2014 com a Tatiane Neves

		/*********************************************
		<<<< ALTERAวรO >>>>
		A็ใo.........: Inluir tratamento para o cliente 038134 - LEROY 
		.............: Quando o cliente for LEROY troca o tipo de entra para " 1 - Retira"
		Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
		Data.........: 20/04/2022
		Chamados.....: 20220309005438
		****************************************/				
		IF SA1->A1_COD = "038134"
			_cTpEnt	:= "1" // Tipo de entrega - Retira
		ELSE
			_cTpEnt	:= "2" // Tipo de entrega - Entrega
		ENDIF

		If SA1->A1_COD $ "038134" //Cliente Leroy // C&C // CONSTRUDECOR // TELHANORTE // TUMELEIRO
			cObserv	:= SA1->A1_XLOJA //Chamado 003432
			//_cTpFat	:= "1"			 //Chamado 003575 - Sempre faturamento total para Leroy , C&C e CONSTRUDECOR JOGUEI PARA BAIXO TP FAT TOTAL
		EndIf
		// 20210319004469 - Everson Santana - 24.08.2021 - Inclui os clientes 092887#014519#028358
		If	AllTrim(SA1->A1_COD) $ "038134/014519/023789/028358/092187/092887"// telha norte sempre total  //Cliente Leroy // C&C // CONSTRUDECOR // TELHANORTE // TUMELEIRO
			_cTpFat	:= "1"
		EndIf

		//FR - 10/11/2021 - Ticket #20211109024068
		/*  //para testes
		cC5NUM := GetSxeNum("SC5", "C5_NUM")

		SC5->(OrdSetFocus(1))
		While SC5->( DbSeek( xFilial( "SC5" ) + cC5NUM ) )
			ConfirmSX8()   
			cC5NUM := SOMA1(cC5NUM)
		Enddo
		
		AADD(aCabec,{"C5_NUM" , cC5NUM    ,Nil })
		*/
	//FR - 10/11/2021 - Ticket #20211109024068


	aAdd(aCabec, {"C5_TIPO"		,"N"												,Nil}) // Tipo do Pedido
	aAdd(aCabec, {"C5_CLIENTE"	,SA1->A1_COD										,Nil}) // Codigo do Cliente
	aAdd(aCabec, {"C5_LOJACLI"	,SA1->A1_LOJA										,Nil}) // Loja do Cliente
	//aAdd(aCabec, {"C5_CLIENT"	,SA1->A1_COD										,Nil}) // Codigo do Cliente para entrega
	//aAdd(aCabec, {"C5_LOJAENT"	,SA1->A1_LOJA										,Nil}) // Loja para entrega
	aAdd(aCabec, {"C5_TIPOCLI"	,SA1->A1_TIPO										,Nil}) // Tipo do Cliente
	aAdd(aCabec, {"C5_CONDPAG"	,_cCondPag											,Nil}) // Condicao de pagamanto
	aAdd(aCabec, {"C5_EMISSAO"	,dDatabase											,Nil}) // Data de Emissao
	aAdd(aCabec, {"C5_ZCONDPG"	,_cCondPag											,Nil}) // COND PG
	aAdd(aCabec, {"C5_TABELA"	,"001"						 						,Nil}) // TABELA
	aAdd(aCabec, {"C5_VEND1"	,SA1->A1_VEND										,Nil}) //VENDEDOR 1
	aAdd(aCabec, {"C5_VEND2"	,_cVend2											,Nil}) //VENDEDOR 2
	aAdd(aCabec, {"C5_TPFRETE"	,_cTpFre											,Nil}) // C=CIF;F=FOB;T=Por conta terceiros;S=Sem frete
	aAdd(aCabec, {"C5_TRANSP"	,_cTransp											,Nil}) // Transportadora
	aAdd(aCabec, {"C5_XTIPO"	,_cTpEnt											,Nil}) // 1=Retira;2=Entrega
	aAdd(aCabec, {"C5_XTIPF"	,_cTpFat											,Nil}) // 1=Total;2=Parcial
	aAdd(aCabec, {"C5_ZOBS"		,cObserv											,Nil}) // Observa็ใo
	aAdd(aCabec, {"C5_XORDEM"	,ZZ6->ZZ6_NUMOC										,Nil}) // Pedido do cliente
	aAdd(aCabec, {"C5_ZCONSUM"	,cZConsumo											,Nil}) // Consumo
	aAdd(aCabec, {"C5_ZEDI"		,"S"												,Nil}) // EDI
	aAdd(aCabec, {"C5_XNOME"	,Alltrim(SA1->A1_NOME)								,Nil}) // NOME
	aAdd(aCabec, {"C5_XORIG"	,"3"												,Nil})

	_lCepNEnt := .F.

	If  Substr(AllTrim(SA1->A1_NOME),1,3) = 'MRV' .Or. Substr(AllTrim(SA1->A1_NREDUZ),1,3) = 'MRV'
		_cCep:= Alltrim(ZZ6->ZZ6_ENTCEP)
		_cXCep:= ' '
		DbSelectArea("JC2")
		JC2->( dbSetOrder(1))
		If JC2->( dbSeek(xFilial("JC2")+_cCep) ) .And. !(Empty(Alltrim(_cCep)))

			aAdd(aCabec, {"C5_ZENDENT"	,Alltrim(ZZ6->ZZ6_ENTEND)									,Nil}) // End entrega
			aAdd(aCabec, {"C5_ZBAIRRE"	,Iif(Empty(Alltrim(JC2->JC2_BAIRRO)),"CENTRO",Alltrim(JC2->JC2_BAIRRO)) 									,Nil}) // Bairro entrega
			aAdd(aCabec, {"C5_ZCEPE"	,_cCep														,Nil}) // CEP entrega
			aAdd(aCabec, {"C5_ZESTE"	,Alltrim(JC2->JC2_ESTADO)									,Nil}) // Estado entrega
			aAdd(aCabec, {"C5_ZMUNE"	,Alltrim(JC2->JC2_CIDADE)									,Nil}) // Mun entrega
			aAdd(aCabec, {"C5_XCODMUN"	,Alltrim(JC2->JC2_CODCID)									,Nil}) // Codigo mun entrega
			_cXCep:= _cCep
		Else

			aAdd(aCabec, {"C5_ZENDENT"	,SA1->A1_ENDENT										,Nil}) // End entrega
			aAdd(aCabec, {"C5_ZBAIRRE"	,Iif(Empty(SA1->A1_BAIRROE),"CENTRO",SA1->A1_BAIRROE),Nil}) // Bairro entrega //Ticket 20200127000148
			aAdd(aCabec, {"C5_ZCEPE"	,SA1->A1_CEPE										,Nil}) // CEP entrega
			aAdd(aCabec, {"C5_ZESTE"	,SA1->A1_ESTE										,Nil}) // Estado entrega
			aAdd(aCabec, {"C5_ZMUNE"	,SA1->A1_MUNE										,Nil}) // Mun entrega
			aAdd(aCabec, {"C5_XCODMUN"	,SA1->A1_COD_MUN									,Nil}) // Codigo mun entrega
			_cXCep:= SA1->A1_CEPE

			If !(Empty(ZZ6->ZZ6_ENTCEP))
				_lCepNEnt := .T.
			EndIf

		EndIf



		//Giovani Zago ticket 20191112000016
		If Substr(_cXCep,1,1) = '0'
			aAdd(aCabec, {"C5_XDANO"	,Substr(Dtos(ddatabase),1,4)										,Nil}) // ano entrega
			aAdd(aCabec, {"C5_XMDE"		,Substr(Dtos(ddatabase),5,2)										,Nil}) // mes entrega
			aAdd(aCabec, {"C5_XDE"		,Substr(Dtos(ddatabase),7,2)										,Nil}) // dia entrega

			aAdd(aCabec, {"C5_XAANO"	,Substr(Dtos(ddatabase+8),1,4)										,Nil}) // ano entrega
			aAdd(aCabec, {"C5_XMATE"	,Substr(Dtos(ddatabase+8),5,2)										,Nil}) // mes entrega
			aAdd(aCabec, {"C5_XATE"		,Substr(Dtos(ddatabase+8),7,2)										,Nil}) // dia entrega

		EndIf
	Else

		aAdd(aCabec, {"C5_ZENDENT"	,SA1->A1_ENDENT										,Nil}) // End entrega
		aAdd(aCabec, {"C5_ZBAIRRE"	,SA1->A1_BAIRROE									,Nil}) // Bairro entrega
		aAdd(aCabec, {"C5_ZCEPE"	,SA1->A1_CEPE										,Nil}) // CEP entrega
		aAdd(aCabec, {"C5_ZESTE"	,SA1->A1_ESTE										,Nil}) // Estado entrega
		aAdd(aCabec, {"C5_ZMUNE"	,SA1->A1_MUNE										,Nil}) // Mun entrega
		aAdd(aCabec, {"C5_XCODMUN"	,SA1->A1_COD_MUN									,Nil}) // Codigo mun entrega

	EndIf

	If SA1->A1_COD $ "038134" //Chamado 007744 JEFFERSON CARLOS 24/07/18
		aAdd(aCabec, {"C5_XOBSEXP"		,"LEROY MERLIN"											,Nil}) //Obs. Exped.
	ElseIf SA1->A1_COD $ "028358/023789" //TELHANORTE SAINT GOBAN - CONSTRUDECOR 10/07/2018 GIOVANI.ZAGO
		aAdd(aCabec, {"C5_XOBSEXP"		,"EMBALAGEM INDIVIDUAL POR PRODUTO + EAN14"												,Nil}) //Obs. Exped.
		aAdd(aCabec, {"C5_XEAN"			,"1"													,Nil}) //Cod. Barras
	ElseIf SA1->A1_COD=="006596" //Chamado 004838 GIOVANI ZAGO 13/12/16
		aAdd(aCabec, {"C5_XOBSEXP"		,"NORTEL"												,Nil}) //Obs. Exped.
	ElseIf SA1->A1_COD=="014519" //Chamado 007744 JEFFERSON CARLOS 24/07/18
		aAdd(aCabec, {"C5_XOBSEXP"		,"C&C CASA CONSTRUวรO"									,Nil}) //Obs. Exped.
	ElseIf SA1->A1_COD=="092887" //Chamado 008706
		aAdd(aCabec, {"C5_XOBSEXP"		,"AMAZON"									,Nil}) //Obs. Exped.
	Else
		aAdd(aCabec, {"C5_XOBSEXP"		," "												,Nil}) //Obs. Exped.
		aAdd(aCabec, {"C5_XEAN"		    ," "												,Nil}) //Obs. Exped.
	EndIf

	cQuery1  := " SELECT COUNT(*) CONTADOR "
	cQuery1  += " FROM " +RetSqlName("ZZ7")+ " ZZ7 "
	cQuery1  += " WHERE ZZ7.D_E_L_E_T_=' ' AND ZZ7_FILIAL='"+cFilAnt+"' AND ZZ7_NUMOC='"+(cAlias)->ZZ6_NUMOC+"' "
	cQuery1  += " AND ZZ7_CLIENT='"+(cAlias)->ZZ6_CLIENT+"' AND ZZ7_LOJA='"+(cAlias)->ZZ6_LOJA+"' "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())
	i	:= (cAlias1)->CONTADOR

	// Itens
	ZZ7->(DbSetOrder(1)) //ZZ7_FILIAL+ZZ7_NUMOC+ZZ7_CLIENT+ZZ7_LOJA
	ZZ7->(DbGoTop())
	ZZ7->(DbSeek(xFilial("ZZ7")+(cAlias)->(ZZ6_NUMOC+ZZ6_CLIENT+ZZ6_LOJA)))

	z	:= 0
	_aEmail	:= {}
	_PrDi:= ' '
	While ZZ7->(!Eof()) .And. 	ZZ6->(ZZ6_FILIAL+ZZ6_NUMOC+ZZ6_CLIENTE+ZZ6_LOJA)==ZZ7->(ZZ7_FILIAL+ZZ7_NUMOC+ZZ7_CLIENT+ZZ7_LOJA)

		z++

		DbSelectArea("SZD")
		SZD->(DbSetOrder(1))
		SZD->(DbGoTop())
		_OldCli:=  ' '
		_OldCli:=  _cCliente
		If  Substr(AllTrim(SA1->A1_NOME),1,3) = '.' .Or. Substr(AllTrim(SA1->A1_NREDUZ),1,3) = 'MRV'
			_cCliente:= '043252'
		EndIf
		SZD->(DbSeek(xFilial("SZD")+_cCliente+Alltrim(ZZ7->ZZ7_PRODUT)))
		_cCliente:= _OldCli
		_cCodCli := SZD->ZD_CODCLI

		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())
		SB1->(DbSeek(xFilial("SB1")+SZD->ZD_CODSTE))

		If AllTrim(SB1->B1_GRUPO)=="105" //Linha stella - Chamado 003371
			_lTemStella	:= .T.
		EndIf

		_aAreaB1	:= SB1->(GetArea())
		_cProduto	:= SB1->B1_COD
		_cDesc		:= SB1->B1_DESC
		_cLocPad	:= SB1->B1_LOCPAD

		_nQtdItem++
		_cX	:= Soma1(_cX)
		_cTabela:= '001'
		_nPreco	:=	U_STRETSST('01',_cCliente,_cLoja,_cProduto,_cCondPag,'PRECO',.F.,,,_cTabela)
		If valtype(_nPreco) <> 'N'
			_nPreco:= 0.01
		EndIf

		_nPDesc := GetMv("ST_WSPRT02",,0) //Desconto ordem digital

		_nPrecoTab	:= _nPreco
		_nPrecoSis	:= _nPrecoTab
		If _nPDesc>0
			_nvDesc	:= Round(((	_nPDesc*_nPrecoSis)/100),2)
			_nPrecoSis := Round(_nPrecoSis - _nvDesc,2)
		EndIf

		If GetMv("STEDIPV004",,.T.) .And. !AllTrim(SA1->A1_XPRCEDI)=="N"
			_nPrecoTab  := ZZ7->ZZ7_PRECO
		Else
			_nPrecoTab  := _nPreco
			If _nPDesc>0
				_nvDesc	:= Round(((	_nPDesc*_nPrecoTab)/100),2)
				_nPrecoTab := Round(_nPrecoTab - _nvDesc,2)
			EndIf
		EndIf

		_nPreco		:= _nPrecoSis-ZZ7->ZZ7_PRECO

		If !Positivo(_nPreco)
			_nPreco	:= _nPreco*-1
		EndIf

		If _nPreco>0.02
			_lPrecoDiv	:= .T.
		EndIf
		If _nPrecoSis<=0.01
			_lPrcPsc := .T.
		EndIf

		//_nPrecoTab --> pre็o que serแ carregado no pedido 
		//_nPrecoSis --> pre็o calculado pelo sistema - desconto order digital
		//ZZ7->ZZ7_PRECO --> pre็o recebido pelo cliente

		cTesPad  		:= U_STRETSST('01',_cCliente,_cLoja,_cProduto,_cCondPag,'TES',.T.)
		_nValLiqPrd		:= STLiq(_nPrecoTab*ZZ7->ZZ7_QUANT,_cProduto,ZZ7->ZZ7_QUANT,cTesPad)
		_nPosCom1		:= u_ValPorComiss(AllTrim(_cProduto),_cVend1) //C6_COMIS1
		_nPosComiss 	:= Round(((_nPrecoTab*ZZ7->ZZ7_QUANT*_nPosCom1)/100),2) //C6_XVALCOM
		_nSaldo			:= u_versaldo(AllTrim(_cProduto))
		_dDtEntrega		:= u_atudtentre(_nSaldo,AllTrim(_cProduto),ZZ7->ZZ7_QUANT)

		RestArea(_aAreaB1)
		RestArea(_aAreaSA1)
		If _cX = '01'
			_cPrDu:=  AllTrim(_cProduto)
		EndIf
		If VALTYPE(cTesPad) <> 'C'
			cTesPad:='501'
		EndIf
		_cProdZZ7:= AllTrim(ZZ7->ZZ7_PRODUT)

		If _cCliente = '040289'
			_cProdZZ7:= '"'+AllTrim(ZZ7->ZZ7_PRODUT)+'"'
		EndIf

		Aadd(aSC6 ,{{"C6_ITEM"		,_cX																			,Nil},; // Numero do Item no Pedido
		{"C6_PRODUTO"	,AllTrim(_cProduto)																			,Nil},; // Codigo do Produto
		{"C6_UM"   		,"UN"		  																				,Nil},; // Unidade de Medida Primar.
		{"C6_QTDVEN"	,ZZ7->ZZ7_QUANT																				,Nil},; // Quantidade Vendida
		{"C6_PRCVEN"	,_nPrecoTab																					,Nil},; // Preco Venda
		{"C6_PRUNIT"	,_nPrecoTab																					,Nil},; // Preco Unitario
		{"C6_VALOR"		,round(_nPrecoTab*ZZ7->ZZ7_QUANT,2)															,Nil},; // Valor Total do Item
		{"C6_LOCAL"		,_cLocPad																					,Nil},; // Almoxarifado
		{"C6_CLI"		,_cCliente																					,Nil},; // Cliente
		{"C6_OPER"		,"01"																						,Nil},; // OPERAวรO
		{"C6_TES"		,cTesPad																					,Nil},; // Tipo de Entrada/Saida do Item
		{"C6_ITEMPC"	,Iif(AllTrim(SA1->A1_COD)=="028358",AllTrim(ZZ7->ZZ7_ITEMP)+'0',AllTrim(ZZ7->ZZ7_ITEMP))	,Nil},; // Item do pedido de compra
		{"C6_NUMPCOM"	,AllTrim(ZZ6->ZZ6_NUMOC)																	,Nil},; // Tipo de Entrada/Saida do Item
		{"C6_XORDEM"	,_cProdZZ7																					,Nil},; // Tipo de Entrada/Saida do Item
		{"C6_ZVALLIQ"	,_nValLiqPrd																				,Nil},; //Valor liquido
		{"C6_ENTRE1"	,_dDtEntrega																				,Nil},; // Data da Entrega
		{"C6_ZPICMS"	,nAliqICM																					,Nil},; // Aliq ICMS
		{"C6_ZVALICM"	,nValICms																					,Nil},; // Val ICMS
		{"C6_ZIPI"		,nAliqIPI																					,Nil},; // Aliq IPI
		{"C6_ZVALIPI"	,nValIPI																					,Nil},; // Val IPI
		{"C6_ZVALIST"	,nValICMSST																					,Nil},; // Val ICMS ST
		{"C6_ZMOTBLO"	,Iif(_nPreco>0.02,"6","3")																	,Nil},; // Bloqueio do item
		{"C6_COMIS1"	,_nPosCom1																					,Nil},; // C6_COMIS1
		{"C6_EMISSAO"	,dDatabase																					,Nil},; // C6_EMISSAO
		{"C6_XVALCOM"	,_nPosComiss																				,Nil}}) // C6_XVALCOM

		_nValComiss		+= _nPosComiss
		_nVaPed			+= round(_nPrecoTab*ZZ7->ZZ7_QUANT,2)
		_nValLiqTot		+= _nValLiqPrd

		AADD(_aEmail,{AllTrim(ZZ6->ZZ6_NUMOC),AllTrim(ZZ7->ZZ7_ITEMP),	AllTrim(_cCliente),AllTrim(_cCodCli),;
			AllTrim(_cProduto),AllTrim(_cDesc),ZZ7->ZZ7_PRECO,_nPrecoSis,_nPrecoAnt,_nPrecoTab,;
			Iif(_lPrecoDiv,"DIVERGENTE","OK")})

		//FR - 10/11/2021 - Ticket #20211109024068
		_nQtITCLI := 0
		Do Case
		Case AllTrim(_cCliente)=="010566"
			_nQtITCLI=30
		Case AllTrim(_cCliente)=="006596"
			_nQtITCLI=20
		Case AllTrim(_cCliente)=="008724"
			_nQtITCLI=30
		Case AllTrim(_cCliente)=="011859"
			_nQtITCLI=20
		Case AllTrim(_cCliente)=="003382"
			_nQtITCLI=20
		Case Alltrim(_cCliente)== "036659" //DIMENSIONAL
			_nQtITCLI = 20
				/*********************************************
				<<<< ALTERAวรO >>>>
				A็ใo.........: Incluido tratamento para o cliente 008724
				Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
				Data.........: 15/04/2022
				Chamados.....: 20220408007663
				****************************************/				
				Case Alltrim(_cCliente)== "008724"
					_nQtITCLI = 30

				/*
				  Adicionado por Jackson Santos - Ticket: 20220516010241
				  EDI Cliente Copafer 007613 01 E 02  
				*/		
		Case Alltrim(_cCliente)== "007613"
			_nQtITCLI = 30

		EndCase
		//FR - 10/11/2021 - Ticket #20211109024068

			/* //FR - 10/11/2021 - Ticket #20211109024068
			If i==z .Or. (AllTrim(_cCliente)=="010566" .And. _nQtdItem=30).Or. (AllTrim(_cCliente)=="006596" .And. _nQtdItem=20);
			.Or. (AllTrim(_cCliente)=="008724" .And. _nQtdItem=30) .Or. (AllTrim(_cCliente)=="011859" .And. _nQtdItem=20);
			.Or. (AllTrim(_cCliente)=="003382" .And. _nQtdItem=20);
			.Or. (Alltrim(_cCliente)== "036659" .And. _nQtdItem = 20) //FR - 14/10/2021 - Ticket #20211013021811 cliente Dimensional ajustar qtde linhas para 20
			*/ //FR - 10/11/2021 - Ticket #20211109024068

		If i == z .Or. (_nQtdItem == _nQtITCLI)	//FR - 10/11/2021 - Ticket #20211109024068

			_nQtdItem	:= 0

			//	Begin Transaction

			If _lPrcPsc
				_cBloq	+= "PSC/"
			EndIf
			If _lPrecoDiv
				_cBloq	+= "PRCEDI/"
			EndIf

			If    _cCliente $ GetMv("ST_EDIBLQ",, '023789/')
				_cBloq	+= "EDI-/"
			EndIf

			If _lCepNEnt
				_cBloq	+= "CEPENT/"
			EndIf

			_lPrecoDiv	:= .F.

			aAdd(aCabec, {"C5_ZBLOQ"	,IIf(Empty(Alltrim(_cBloq)),"2","1")				,Nil}) // Bloqueio
			aAdd(aCabec, {"C5_ZMOTBLO"	,_cBloq												,Nil}) // Descri็ใo do bloqueio
			aAdd(aCabec, {"C5_ZVALLIQ"	,_nValLiqTot										,Nil}) // Valor lํquido
			aAdd(aCabec, {"C5_COMIS1"	,((_nValComiss*100)/_nVaPed)						,Nil}) // Comissใo Total

			If !Empty(ZZ6->ZZ6_DTENT)
				aAdd(aCabec, {"C5_ZDTCLI"	,ZZ6->ZZ6_DTENT									,Nil}) // Descri็ใo do bloqueio
			EndIf
			If _lTemStella
				aAdd(aCabec, {"C5_XSTELLA"	,"2"											,Nil}) //Stella
			EndIf

			//giovani zago 11/10/16

			lMsErroAuto	:= .F.
			If GetMv("ST_EDIPVX",,.T.) .And. !(STDUPLOD(ZZ6->ZZ6_NUMOC,_cPrDu,_cCliente,_cLoja))

				U_STMAILTES(_cEmail+"; everson.santana@steck.com.br", _cCopia, "  Nome: "+ Alltrim(_cCliNom)+" duplicado OC: "+ZZ6->ZZ6_NUMOC, '','')

				//_cEmail := "flah.rocha@gmail.com;flah.rocha@sigamat.com.br"
				//FRSendMail(_cEmail, "", "  Nome: "+ Alltrim(_cCliNom)+" duplicado OC: "+ZZ6->ZZ6_NUMOC, "", "" )  //FR - TESTE RETIRAR

				DisarmTransaction()
				RollBackSX8()

			Else

				MsExecAuto({|x,y,z| MATA410(x,y,z)},aCabec,aSC6,3)

				If !lMsErroAuto

					_cQuery3 := " SELECT C5_NUM
					_cQuery3 += " FROM "+RetSqlName("SC5")+" C5
					_cQuery3 += " WHERE C5.D_E_L_E_T_=' ' AND C5.C5_FILIAL='"+xFilial("SC5")+"'
					_cQuery3 += " AND C5.C5_XORDEM='"+AllTrim(ZZ6->ZZ6_NUMOC)+"'
					_cQuery3 += " ORDER BY C5_NUM DESC

					If !Empty(Select(_cAlias3))
						DbSelectArea(_cAlias3)
						(_cAlias3)->(dbCloseArea())
					Endif

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

					dbSelectArea(_cAlias3)
					(_cAlias3)->(dbGoTop())

					If (_cAlias3)->(!Eof())
						If !(AllTrim((_cAlias3)->C5_NUM)==AllTrim(SC5->C5_NUM))
							SC5->(DbSetOrder(1))
							SC5->(DbSeek(xFilial("SC5")+(_cAlias3)->C5_NUM))
						EndIf
					EndIf



					SC5->(RecLock("SC5",.F.))
					U_STFAT150()
					SC5->(MsUnLock())

					//Desabilitado pois a diretoria nใo quer mais receber
					If _nValLiqTot >= 25000
						//U_LVPED(SC5->C5_NUM,"  EDI")
					Else
						//U_LVPED(SC5->C5_NUM,"GIO")
					EndIf
					// ------------ Envio de confirma็ใo ao portal - Valdemir Rabelo 20/09/2022
					if (SC5->C5_CLIENTE+SC5->C5_LOJACLI $ cClient) .OR. ;
							(Substr(AllTrim(SA1->A1_NOME),1,3) = 'MRV' .Or. Substr(AllTrim(SA1->A1_NREDUZ),1,3) = 'MRV')
						RecLock('ZZ6',.F.)
						ZZ6->ZZ6_STATUS := "4"
						MsUnlock()
					endif
					// --------------

				    // Limpa o campo C6_ZDTENRE - Nใo se sabe qual rotina esta preenchendo. 
					_cQuery4 := " UPDATE "+RetSqlName("SC6")+" SET C6_ZDTENRE = '"+SPACE(8)+"' "
					_cQuery4 += " WHERE D_E_L_E_T_=' ' AND C6_FILIAL = '"+XFILIAL('SC6')+"' AND C6_NUM ='"+(_cAlias3)->C5_NUM+"' "
				    //Memowrite("C:\CNAB\STEDIPFV.SQL", _cQuery4)
					TcSqlExec(_cQuery4)


				Else
					//mostraerro() //FR
				EndIf

			EndIf

			_aAttach	    := {}
			aSC6			:= {}
			_cX				:= "00"
			_cBloq			:= " "
			_nValLiqTot	:= 0
			_nValComiss	:= 0
			_nVaPed		:= 0

			If _lCondDiv
				_cBloq	+= "CONDPG/"
			EndIf

			_aAttach	:= {}
			If lMsErroAuto
				//Conout("Erro ao inserir o pedido via execauto"+" - OC: "+ZZ6->ZZ6_NUMOC)
				MostraErro("LOGS",AllTrim(ZZ6->ZZ6_NUMOC)+"PED.log")
				DisarmTransaction()
				RollBackSX8()
			Else
				//Conout("Pedido inserido com sucesso!"+" - OC: "+ZZ6->ZZ6_NUMOC)
				ConfirmSX8()
			EndIf
			_nValLiqTot	:= 0
			If !lMsErroAuto
				_cAssunto:= 'Pedido portal - ('+SC5->C5_NUM+') - Inserido com sucesso - '+ AllTrim(_cCliNom)+' - produ็ใo - OC: ' + AllTrim(ZZ6->ZZ6_NUMOC)
				AADD(_aPedidos,{SC5->C5_NUM,SC5->(Recno())})
				cMsg	:=  LISTARITENS("1")

				U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho) //FR voltar
				//_cEmail := "flah.rocha@gmail.com;flah.rocha@sigamat.com.br;elizabeth.moura@steck.com.br"
				//FRSendMail(_cEmail, "", _cAssunto, cMsg, "" )  //FR - TESTE RETIRAR

				cMsg		:= ""
				_aAttach	:= {}
				_cCaminho	:= ""

				dbSelectArea("Z1V")
				Z1V->(dbgotop())
				Z1V->(dbsetorder(1))
				If Z1V->(DbSeek(xFilial("Z1V")+_cCliente+_cLoja))
					If GetMv("ST_WF11",,.T.)
						//U_STWF11(SC5->C5_NUM, Alltrim(_cEmail)+";"+Alltrim(_cCopia)+";"+Alltrim(Z1V->Z1V_EMAIL1))
						StartJob("U_STWF11",GetEnvServer(), .F. , SC5->C5_NUM, Alltrim(_cEmail)+";"+Alltrim(_cCopia)+";"+Alltrim(Z1V->Z1V_EMAIL1))
					EndIf
				EndIf
			Else
				_cAssunto:= 'Pedido portal apresentou erro ao inserir - '+ AllTrim(_cCliNom)+' - produ็ใo- OC: ' + AllTrim(ZZ6->ZZ6_NUMOC)
				aadd( _aAttach  ,AllTrim(ZZ6->ZZ6_NUMOC)+'PED.log')
				_cCaminho := '\LOGS\'
				cMsg	  := ""

				//Prepara arquivo de log de grava็ใo ou erro de grava็ใo:
				cNArq  := "STEDIPV_"+AllTrim(ZZ6->ZZ6_NUMOC)+".log"  //nome do arquivo de log
				cDir    := "\arquivos\logs\"

				If !ExistDir(cDir)
					Makedir(cDir)
				EndIf

				_cErro 	:= MostraErro(cDir,cNArq)
				aLog 	:= {}
				_cFile 	:= ""
				ii		:= 0

				If Empty(_cErro)
					aLog := GetAutoGRLog()
					For ii := 1 to len(aLog)
						_cErro += aLog[ii]
					Next
				Endif

				_cFile := cDir+ cNArq  //diret๓rio mais nome do arquivo

				nHdlXml:= FCreate(_cFile,0)		//Cria o arquivo no diretorio (cria o nome.extensao na pasta apenas)

				If nHdlXml > 0

					FWrite(nHdlXml,_cErro)	//aqui grava o conteudo no arquivo acima gravado na pasta
					FClose(nHdlXml)

				Endif
				cMsg := _cErro
				//arquivo log

				//_cEmail := "elizabeth.moura@steck.com.br"
				_aAttach:= {}
				U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)  //FR voltar

				//_cEmail := "flah.rocha@gmail.com;flah.rocha@sigamat.com.br"
				//FRSendMail(_cEmail, "", _cAssunto, cMsg, "" )  //FR - TESTE RETIRAR

				_aAttach	:= {}
				_cCaminho	:= ""
				If AllTrim(_cCliente)=="010566#008724"
					STESTORNA(_aPedidos)
				EndIf
				_lPedOk	:= .F.
			EndIf

		EndIf

		ZZ7->(DbSkip())

	EndDo

	If _lPedOk
		ZZ6->(RecLock("ZZ6",.F.))
		ZZ6->ZZ6_STATUS	:= "2"
		ZZ6->(MsUnLock())
	EndIf

	(cAlias)->(DbSkip())

EndDo

Return

Static Function STDUPLOD(_cOrdem,_cPrDu,_cCliedi,_cLJedi)
	Local _lRex			:= .T.
	Local _cQuery 		:= ""
	Local _cAlias 		:= "STDUPLOD"

	_cQuery	:= " SELECT C5_NUM, C6_PRODUTO FROM "+RetSqlName("SC5")+" SC5
	_cQuery	+= " INNER JOIN(SELECT * FROM "+RetSqlName("SC6")+")SC6
	_cQuery	+= " ON SC6.D_E_L_E_T_ = ' '
	_cQuery	+= " AND C6_FILIAL = C5_FILIAL
	_cQuery	+= " AND C6_NUM = C5_NUM
	_cQuery	+= " AND C6_ITEM = '01'
	_cQuery	+= " AND C6_PRODUTO = '"+_cPrDu+"' AND C5_CLIENTE = '"+_cCliedi+"' AND C5_LOJACLI = '"+_cLJedi+"'
	_cQuery	+= " WHERE SC5.D_E_L_E_T_ = ' ' AND C5_NOTA NOT LIKE '%XXXX%' AND C5_XORDEM = '"+ ALLTRIM(_cOrdem)+"' AND C5_FILIAL = '02' "

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	If (_cAlias)->(!Eof())

		_lRex			:= .F.

	EndIf

Return(_lRex)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
	ฑฑณPrograma  ณSTLiqณ 	  Autor ณ Giovani Zago          ณ Data ณ13/03/13  ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณDescri…o ณ Retornar valor liquido							          ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณUso       ณ Especifico Steck                                           ณฑฑ
	ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function STLiq(_nValor,_cProduto,_nQuant,_cTesA)

	default _cProduto := SuperGetMv("ST_PRDUNIC",,"SUNICOM")
	default _nQuant :=1

	//DbSelectArea("SA1")
	//SA1->(dbSetOrder(1))
	//SA1->(dbseek(xfilial("SA1")+PP7->PP7_CLIENTE+PP7->PP7_LOJA))
	C5_TIPOCLI := SA1->A1_TIPO
	_cTipoCli:= SA1->A1_TIPO
	_cTipoCF := 'C'

	//dbSelectArea("SB1")
	//dbSetOrder(1)
	//DbSeek(xFilial("SB1")+_cProduto)

	_nIcms    	:= SA1->A1_CONTRIB
	_cEst		:= SA1->A1_EST

	//_cTes:=U_STRETSST('01',SA1->A1_COD,SA1->A1_LOJA ,_cProduto,PP7->PP7_CPAG  ,'TES')	// u_LcStOper()

	MaFisSave()
	MaFisEnd()
	MaFisIni(SA1->A1_COD,;	// 1-Codigo Cliente/Fornecedor
	SA1->A1_LOJA ,;			// 2-Loja do Cliente/Fornecedor
	"C",;					// 3-C:Cliente , F:Fornecedor
	"N",;					// 4-Tipo da NF
	SA1->A1_TIPO,;			// 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461")                                                               // 10-Nome da rotina que esta utilizando a funcao

	MaFisAdd(_cProduto,;                                               // 1-Codigo do Produto ( Obrigatorio )
	_cTesA,;                                                            // 2-Codigo do TES ( Opcional )
	_nQuant,;                                                          // 3-Quantidade ( Obrigatorio )
	_nValor,;                                                         // 4-Preco Unitario ( Obrigatorio )
	0,;                														 // 5-Valor do Desconto ( Opcional )
	,;                                                                       // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                       // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                       // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                      // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                      // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                      // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                      // 12-Valor do Frete Autonomo ( Opcional )
	_nValor,;														 // 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                      // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                      // 15-RecNo do SB1
	0)                                                                       // 16-RecNo do SF4

	nAliqICM 	:= (MaFisRet(1,'IT_ALIQICM',5,2)  )    //Aliquota do ICMS
	nValICms	:= (MaFisRet(1,'IT_VALICM',14,2)  )    //Valor do ICMS

	nAliqIPI 	:= (MaFisRet(1,"IT_ALIQIPI",5,2)  )    //Aliqutota do IPI
	/*********************************************
	<<<< ALTERAวรO >>>>
	A็ใo.........: Erro no valor de imposto - Campo customizado
	.............: Conforme levantado o valor do IPI estแ vindo com o pre็o cheio, sendo que o correto ้ o valor do IPI divido pela quantidade.
	Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
	Data.........: 14/03/2022
	Chamados.....:20220224004565
	nValICMSST 	:= (MaFisRet(1,'IT_VALSOL',14,2)  )    //Valor do ICMS-ST
	****************************************/	
	nValIPI 	:= ROUND(MaFisRet(1,"IT_VALIPI",14,2) / _nQuant,2)    //Valor do IPI
	
	/*********************************************
	<<<< ALTERAวรO >>>>
	A็ใo.........: Erro no valor de imposto - Campo customizado
	.............: Conforme levantado o valor do IcmsSt estแ vindo com o pre็o cheio, sendo que o correto ้ o valor do ICMSST divido pela quantidade.
	Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
	Data.........: 08/03/2022
	Chamados.....:20220131002377
	nValICMSST 	:= (MaFisRet(1,'IT_VALSOL',14,2)  )    //Valor do ICMS-ST
	****************************************/	
	nValICMSST 	:= ROUND(MaFisRet(1,'IT_VALSOL',14,2) / _nQuant,2)    //Valor do ICMS-ST

	nValPis		:= (MaFisRet(1,"IT_VALPS2",14,2)  )    //Valor do PIS
	nValCof		:= (MaFisRet(1,"IT_VALCF2",14,2)  )    //Valor do COFINS

	//DIFAL
	nValCmp 	:= noround(MaFisRet(1,"IT_VALCMP",14,2)  )
	nValDif 	:= noround(MaFisRet(1,"IT_DIFAL",14,2)  )

	mafisend()

	_nValor -= (nValICms  + nValPis + nValCof + nValCmp + nValDif)

Return(round(_nValor,2))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPEDPORTAL	บAutor  ณRenato Nogueira     บ Data ณ  03/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณWebservice de integra็ใo dos pedidos de vendas			  บฑฑ
ฑฑบ          ณ	    							 	 				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STESTORNA(_aPedidos)

	Local _nX			:= 0
	Local lContinua		:= .T.
	Local _aArea		:= GetArea()

	For _nX:=1 To Len(_aPedidos)

		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		SC5->(DbGoTop())
		SC5->(DbSeek("02"+_aPedidos[_nX][1]))
		IF SC5->(!Eof())
			//lContinua	:= U_Mt410Ace()
			If lContinua

				Begin Transaction
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Eliminacao de residuo                                ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					dbSelectArea("SC6")
					dbSetOrder(1)
					MsSeek(xFilial("SC6")+SC5->C5_NUM)

					While ( !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM 	== SC5->C5_NUM )
						lValido  := .T.
						If lValido .And. !Empty(SC5->C5_PEDEXP) .And. SuperGetMv("MV_EECFAT") // Integracao SIGAEEC
							If FindFunction("EECZERASALDO")
								lValido := EECZeraSaldo(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
							Else
								lValido := EECCancelPed(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
							EndIf
						EndIf
						If lValido .And. (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0
							MaResDoFat(,.T.,.F.)
						EndIf
						dbSelectArea("SC6")
						dbSkip()
					EndDo
					SC6->(MaLiberOk({SC5->C5_NUM},.T.))
				End Transaction

			EndIf
		EndIf

	Next

	RestArea(_aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLISTARITENS Autor ณRenato Nogueira     บ Data ณ  03/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณWebservice de integra็ใo dos pedidos de vendas			  บฑฑ
ฑฑบ          ณ	    							 	 				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LISTARITENS(cTipo)

	Local cFuncSent	:= "RetPedido"
	Local cMsg			:= ""
	Local _nLin := 0
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	If cTipo=="1"//AllTrim(ProcName(1))=="RETPEDIDO"
		cMsg += '<TR><B><TD>OC</TD><TD>ITEM</TD><TD>CLIENTE</TD><TD>COD CLIENTE</TD><TD>COD STECK</TD><TD>DESCRIวรO</TD><TD>PREวO RECEBIDO</TD><TD>PREวO SISTEMA</TD><TD>PREวO ANTIGO</TD><TD>PREวO CARREGADO</TD><TD>STATUS</TD></B></TR>'
	Else
		cMsg += '<TR><B><TD>ITEM</TD><TD>CำDIGO CLIENTE</TD><TD>CำDIGO STECK</TD><TD>BLOQUEADO?</TD><TD>DESATIVADO?</TD><TD>TEM AMARRAวรO?</TD></B></TR>'
	EndIf

	For _nLin := 1 to Len(_aEmail)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf

		If cTipo=="1"//AllTrim(ProcName(1))=="RETPEDIDO"
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,1] + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,2] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,3] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,4] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,5] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,6] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + CVALTOCHAR(TRANSFORM(_aEmail[_nLin,7] ,"@E 99,999,999.99999")) + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + CVALTOCHAR(TRANSFORM(_aEmail[_nLin,8] ,"@E 99,999,999.99999")) + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + CVALTOCHAR(TRANSFORM(_aEmail[_nLin,9] ,"@E 99,999,999.99999")) + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + CVALTOCHAR(TRANSFORM(_aEmail[_nLin,10] ,"@E 99,999,999.99999")) + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,11] + ' </Font></TD>'
			cMsg += '</TR>'
		Else
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,1] + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,2] + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,3] + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,4] + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,5] + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,6] + ' </Font></TD>'
			cMsg += '</TR>'
		EndIf
	Next
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Definicao do rodape do email                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

	_aEmail	:= {}

Return(cMsg)

/*====================================================================================\
|Programa  | TUDOOK	         | Autor | RENATO.NOGUEIRA          | Data | 09/11/2015  |
|=====================================================================================|
|Descri็ใo | Verifica produtos e oc antes de iniciar o processo de EDI                |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | TUDOOK	                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|Retorno   | _cStatus 1 - valida็ใo ok ; _cStatus 2 - oc jแ inserida ;                |
|		    | _cStatus 3 - produto bloqueado, desativado ou sem amarra็ใo				  |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/

Static Function TUDOOK(_cCliente,_cLoja,_cPedCli,_aItens)

	Local _cStatus	:= "1"
	Local cQuery2 	:= ""
	Local cAlias2 	:= "QRYEDI2"
	Local _nX			:= 0
	Local _cAssunto := ""
	Local cMsg		  := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''

	_aEmail	:= {}

	//Verifica se jแ foi inserida a OC

	cQuery2  := " SELECT COUNT(*) CONTADOR "
	cQuery2  += " FROM " +RetSqlName("SC6")+ " C6 "
	cQuery2  += " WHERE C6.D_E_L_E_T_=' ' AND C6_FILIAL='"+cFilAnt+"' AND C6_CLI='"+_cCliente+"' AND C6_LOJA='"+_cLoja+"'
	cQuery2  += " AND C6_NUMPCOM='"+_cPedCli+"' AND C6_BLQ=' ' AND ( "
	For _nX:=1 To Len(_aItens)
		cQuery2  += " C6_ITEMPC='"+_aItens[_nX][1]+"' "
		If !(Len(_aItens)==_nX)
			cQuery2  += " OR "
		EndIf
	Next
	cQuery2  += " ) "

	If !Empty(Select(cAlias2))
		DbSelectArea(cAlias2)
		(cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAlias2,.T.,.T.)

	dbSelectArea(cAlias2)
	(cAlias2)->(dbGoTop())

	If (cAlias2)->(!Eof())
		If (cAlias2)->CONTADOR==Len(_aItens)
			//Conout("OC: "+_cPedCli+" jแ foi inserida na base - "+dtoc(date())+" - "+time())
			_cStatus	:= "2"
			Return(_cStatus)
		EndIf
	EndIf

	//Verifica se tem amarra็ใo
	For _nX:=1 To Len(_aItens)

		DbSelectArea("SZD")
		SZD->(DbSetOrder(1))
		SZD->(DbGoTop())

		_OldCli:=  ' '
		_OldCli:=  _cCliente
		If  Substr(AllTrim(SA1->A1_NOME),1,3) = 'MRV' .Or. Substr(AllTrim(SA1->A1_NREDUZ),1,3) = 'MRV'
			_cCliente:= '043252'
		EndIf
		If !SZD->(DbSeek(xFilial("SZD")+_cCliente+AllTrim(_aItens[_nX][2])))
			_cCliente:= _OldCli
			_cCodCli := SZD->ZD_CODCLI

			_cStatus	:= "3"
			AADD(_aEmail,{AllTrim(_aItens[_nX][1]),;
			AllTrim(_aItens[_nX][2]),;
			"",;
			"",;
			"",;
			"Nใo encontrada"})
			Loop
		EndIf

		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())
		If !SB1->(DbSeek(xFilial("SB1")+SZD->ZD_CODSTE))
			_cStatus	:= "3"
			AADD(_aEmail,{AllTrim(_aItens[_nX][1]),;
			AllTrim(_aItens[_nX][2]),;
			"Nใo encontrado",;
			"",;
			"",;
			"OK"})
		Else
			If SB1->B1_MSBLQL=="1"
				_cStatus	:= "3"
				AADD(_aEmail,{AllTrim(_aItens[_nX][1]),;
				AllTrim(_aItens[_nX][2]),;
				AllTrim(SB1->B1_COD),;
				"SIM",;
				"",;
				"OK"})
			EndIf
			If SB1->B1_XDESAT=="2"
				_cStatus	:= "3"
				AADD(_aEmail,{AllTrim(_aItens[_nX][1]),;
				AllTrim(_aItens[_nX][2]),;
				AllTrim(SB1->B1_COD),;
				"",;
				"SIM",;
				"OK"})
			EndIf

			If SB1->B1_XLM  > 0 .And. !(AllTrim(SA1->A1_COD) $ AllTrim(GetMv("STEDIPV001",,"038134/014519/092187/092887")) ) // GIOVANI ZAGO 17/09/18 SOLICITAวรO PRISCILLA
			
				If   SB1->B1_XTIPLM $ 'M'

					If 		(SUBSTR(SA1->A1_GRPVEN,1,1)=="C" .And. SB1->B1_XEMBC=="S") .Or.;
					(SUBSTR(SA1->A1_GRPVEN,1,1)=="D" .And. SB1->B1_XEMBD=="S") .Or.;
					(SUBSTR(SA1->A1_GRPVEN,1,1)=="E" .And. SB1->B1_XEMBE=="S") .Or.;
					(SUBSTR(SA1->A1_GRPVEN,1,1)=="I" .And. SB1->B1_XEMBI=="S") .Or.;
					(SUBSTR(SA1->A1_GRPVEN,1,1)=="R" .And. SB1->B1_XEMBR=="S")

						_nResul:= ( _aItens[_nX][3]/SB1->B1_XLM)  - Round((_aItens[_nX][3]/SB1->B1_XLM),0)
						If _nResul <> 0

							_cStatus	:= "3"
							AADD(_aEmail,{AllTrim(_aItens[_nX][1]),;
							AllTrim(_aItens[_nX][2]),;
							AllTrim(SB1->B1_COD),;
							"Quantidade Fora do Permitido!!!"+CR+CR+"Utilize Multiplo de: "+transform(SB1->B1_XLM,'@E 999,999.99'),;
							"SIM",;
							"OK"})

						EndIf
					EndIf
				Else
					If _aItens[_nX][3] < SB1->B1_XLM
						_cStatus	:= "3"
						AADD(_aEmail,{AllTrim(_aItens[_nX][1]),;
						AllTrim(_aItens[_nX][2]),;
						AllTrim(SB1->B1_COD),;
						"Quantidade Inferior ao Permitido!!!"+CR+CR+"Minimo Permitido: "+transform(SB1->B1_XLM,'@E 999,999.99'),;
						"SIM",;
						"OK"})
					EndIf

				EndIf

			EndIf

		EndIf

	Next

	If Len(_aEmail)>0
		_cAssunto:= '[EDI] - OC: '+_cPedCli+' - Cliente: '+ aLLTRIM(SA1->A1_NOME)+' - Problema ao Inserir....!!!!!'
		cMsg	:= LISTARITENS("2")

		U_STMAILTES(_cEmail+';everson.santana@steck.com.br', _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)  //FR VOLTAR
		//_cEmail := "flah.rocha@gmail.com;flah.rocha@sigamat.com.br"
		//FRSendMail(_cEmail, "", _cAssunto, cMsg, "" )  //FR - TESTE RETIRAR 
		

	EndIf

	//Sleep( 30000 )

Return(_cStatus)

User Function STCODSTE()
	Local _cRet:= ' '

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
	SA1->(DbGoTop())
	If  SA1->(DbSeek(xFilial("SA1")+ZZ6->(ZZ6_CLIENTE+ZZ6_LOJA)))

		DbSelectArea("SZD")
		SZD->(DbSetOrder(1))
		SZD->(DbGoTop())
		If		SZD->(DbSeek(xFilial("SZD")+SA1->A1_COD+ZZ7->ZZ7_PRODUT))

			_cCodCli := SZD->ZD_CODCLI

			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbGoTop())
			If		SB1->(DbSeek(xFilial("SB1")+SZD->ZD_CODSTE))

				_cRet:= SB1->B1_COD

			EndIf
		EndIf
	EndIf

Return(_cRet)


/*==========================================================================
|Funcao    | FRSendMail          | Flแvia Rocha          | Data | 12/08/2015|
============================================================================
|Descricao | Envia um email                              				   | 
|                                   	  						           |
============================================================================
|Observa็๕es: Gen้rico      											   |
==========================================================================*/
//FUNวรO FR PARA TESTES
/*
Static Function FRSendMail(cMailTo, cCopia, cAssun, cCorpo, cAnexo )

//Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""


//Local cAccount	:= GetMV( "MV_RELACNT" )
//Local cPassword 	:= GetMV( "MV_RELPSW"  )
//Local cServer		:= GetMV( "MV_RELSERV" )
//Local cFrom		:= GetMV( "MV_RELACNT" )   


Local cAccount	:= "wfprotheus7@steck.com.br" 
Local cPassword := "Teste123"  
Local cServer	:= "smtp.office365.com"
Local cFrom		:= "wfprotheus7@steck.com.br"


//Local cAccount	:= "nfe_teste@hfbr.com.br" 	//GetMV( "MV_RELACNT" )    //nfe_teste@hfbr.com.br
//Local cPassword := "hfbr2030" 				//GetMV( "MV_RELPSW"  )    //hfbr2030
//Local cServer	:= "smtp.hfbr.com.br:587"	//GetMV( "MV_RELSERV" )
//Local cFrom		:= "nfe_teste@hfbr.com.br" //GetMV( "MV_RELACNT" )   //relatorio@premierpescados.com.br                                     


//Local cAttach 	:= cAnexo

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	//MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.
	MailAuth( cAccount, cPassword ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//Msgbox("E-mail nใo enviado...")	
	//else
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult .And. lEnviado )
*/
