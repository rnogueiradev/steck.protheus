#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STCOM240
@name STCOM240
@type User Function
@desc inserir SC
@author Renato Nogueira
@since 23/03/2021
/*/

User Function STCOM240()

	Local cNewEmp 		:= "01"
	Local cNewFil 		:= "02"
	Local aCabSC1		:= {}
	Local aItensSC1		:= {}
	Local aLinhaSC1		:= {}
	Private lMsErroAuto	:= .F.

	RpcSetType( 3 )
	RpcSetEnv(cNewEmp,cNewFil,,,"FAT")

	__cUserId := "000000"

	DbSelectArea("SC1")

	cDocSC1 := GetSXENum("SC1","C1_NUM")
	SC1->(dbSetOrder(1))
	While SC1->(dbSeek(xFilial("SC1")+cDocSC1))
		ConfirmSX8()
		cDocSC1 := GetSXENum("SC1","C1_NUM")		// Trocado de cDOC para cDocSC1 - Valdemir Rabelo - 25/07/2019
	EndDo
	aCab:={{"C1_EMISSAO" ,Date() ,Nil},;
	{"C1_SOLICIT" ,"administrador" ,Nil}}

	aItem:={{{"C1_ITEM"   ,"0001"   ,Nil},; //Numero do Item
                              {"C1_PRODUTO","S000046",Nil},; //Codigo do Produto
                              {"C1_QUANT"  ,100        ,Nil},; //Quantidade
                              {"C1_MOTIVO"   ,"MRP"   ,Nil},; // Tipo SC
                              {"C1_CC"     ,"120108"     ,Nil},; //Centro de Custos
							  {"C1_SOLICIT"     ,"administrador"     ,Nil},; //Centro de Custos
                              {"AUTVLDCONT","N"                      ,Nil}}} //Loja do Fornecedor


	MSExecAuto({|v,x,y| MATA110(v,x,y)},aCab,aItem,3)

	If lMsErroAuto
		mostraerro()
	Else
		MsgAlert("Sucesso")
	EndIf

Return()

User Function STCOM241()

	Local cNewEmp 		:= "03"
	Local cNewFil 		:= "01"
	Local aCabec			:= {}
	Local aItens		:= {}
	Private lMsErroAuto	:= .F.

	RpcSetType( 3 )
	RpcSetEnv(cNewEmp,cNewFil,,,"FAT")

	DbSelectArea("SC5")

	AADD(aCabec,{"C5_TIPO","N",NIL})
	AADD(aCabec,{"C5_CLIENTE","033467",NIL})
	AADD(aCabec,{"C5_LOJACLI","02",NIL})
	aAdd(aCabec,{"C5_CLIENT"	,"033467"			,Nil}) // Codigo do Cliente para entrega
	aAdd(aCabec,{"C5_LOJAENT"	,"02"			,Nil}) // Loja para entregaF
	AADD(aCabec,{"C5_TIPOCLI","F",NIL})
	AADD(aCabec,{"C5_ZCONDPG","502",NIL})
	AADD(aCabec,{"C5_TPFRETE","F",NIL})
	AADD(aCabec,{"C5_TRANSP","100000",NIL})
	AADD(aCabec,{"C5_XTIPO","2",NIL})
	AADD(aCabec,{"C5_XTIPF","1",NIL})
	AADD(aCabec,{"C5_ZCONSUM","1",NIL})

	Aadd(aItens ,{{"C6_ITEM"		,"01"																			,Nil},; // Numero do Item no Pedido
				{"C6_PRODUTO"	,"SSB4"																			,Nil},; // Codigo do Produto
				{"C6_UM"   		,"UN"		  																				,Nil},; // Unidade de Medida Primar.
				{"C6_QTDVEN"	,20																				,Nil},; // Quantidade Vendida
				{"C6_PRCVEN"	,3.536																					,Nil},; // Preco Venda
				{"C6_PRUNIT"	,3.536																					,Nil},; // Preco Unitario
				{"C6_VALOR"		,round(3.536*20,2)															,Nil},; // Valor Total do Item
				{"C6_LOCAL"		,"03"																					,Nil},; // Almoxarifado
				{"C6_CLI"		,"033467"																					,Nil},; // Cliente
				{"C6_OPER"		,"15"																						,Nil},; // OPERAÇÃO
				{"C6_TES"		,"701"																					,Nil}})

	MsExecAuto({|x,y,z| MATA410(x,y,z)},aCabec,aItens,3)

	If lMsErroAuto
		mostraerro()
	Else
		MsgAlert("Sucesso")
	EndIf

Return()
