#INCLUDE "PROTHEUS.CH"
/*====================================================================================\
|Programa  | STMENU361        | Autor | GIOVANI.ZAGO             | Data | 24/01/2013  |
|=====================================================================================|
|Descrição |   STMENU361 MONTA MENU BESPECIFICO VENDEDOR EXTERNO                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STMENU361                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
//FR - #20211130025600 - Tela Markup para Colômbia
//     Adicionado no aRotina chamada para função 'Tela MarkUp', 'U_COTMKSCK(.T.)
//------------------------------------------------------------------------------------//

*-----------------------------*
User Function STMENU361(aRotina)
	*-----------------------------*
	Local _cCod    := __cuserid
	Local i := 0
	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+_cCod))
		//If SUBSTR(SA3->A3_COD,1,1) =  GETMV("ST_361MN",,'S') .Or. SA3->A3_COD $ (getmv("ST_361MN1",,"I08072/I08009/I08011"))
		//FR - 14/12/2021 - #20211130025600 - Tela Markup para Colômbia 
		If SUBSTR(SA3->A3_COD,1,1) =  GETNEWPAR("ST_361MN",'S') .Or. SA3->A3_COD $ (GetNewPar("ST_361MN1","I08072/I08009/I08011"))
			/*
			aRotina := {	{	OemToAnsi("Pesquisar"),"AxPesqui"		,0,1,0 ,.F.},;		//"Pesquisar"
			{ OemToAnsi("Visual"),"A410Visual"	,0,2,0 ,NIL},;		//"Visual"
			{ OemToAnsi("Legenda"),"A410Legend"	,0,3,0 ,.F.}}		//"Legenda"
			/*/
			For i :=1 to Len(aRotina)
				If "Incluir" $ aRotina[i,1] .Or.  "Alterar" $ aRotina[i,1]
					aRotina[i,2]  := 'msgInfo("usuario nao autorizado.!!!")'
				EndIF
			Next i
		//ElseIf SA3->A3_TPVEND <> 'I'
		Elseif SA3->(FieldPos("A3_TPVEND")) > 0
			If SA3->A3_TPVEND <> 'I'

				aRotina := {	{	OemToAnsi("Pesquisar"),"AxPesqui"		,0,1,0 ,.F.},;		//"Pesquisar"
				{ OemToAnsi("Visual"),"A410Visual"	,0,2,0 ,NIL},;		//"Visual"
				{ OemToAnsi("Alterar"),"U_XA410ALT"	,0,4,0 ,NIL},;		//"Alterar"
				{ OemToAnsi("Legenda"),"A410Legend"	,0,3,0 ,.F.}}		//"Legenda"
				//If GETMV("ST_C6OPER",,.F.)
				//FR - 14/12/2021 - #20211130025600 - Tela Markup para Colômbia
				If GETNEWPAR("ST_C6OPER",.F.)
					aadd( aRotina, {"Incluir","A410INCLUI",0,2,0,NIL} )
				EndIf
			Endif 

		EndIf
	EndIf

	aadd( aRotina, {"Altera Cabec","U_XSTALTSC5()",0,2,0,NIL} )
	aadd( aRotina, {"Altera Item","U_STALSC5IT()",0,2,0,NIL} )
	aadd( aRotina, {"Aviso entrega","U_STFAT290()",0,2,0,NIL} )

Return(aRotina)

/*====================================================================================\
|Programa  | XSTALTSC5        | Autor | RENATO.NOGUEIRA          | Data | 20/03/2014  |
|=====================================================================================|
|Descrição |   													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | XSTALTSC5                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*-----------------------------*
User Function XSTALTSC5()
	*-----------------------------*
	//If !(__cuserid $ getmv("MV_XLIBFMI",,'000000')+'/000000')
	//FR - 14/12/2021 - #20211130025600 - Tela Markup para Colômbia
	If !(__cuserid $ GetNewPar("MV_XLIBFMI",'000000')+'/000000')
		If !SC5->C5_ZFATBLQ == '1'
			If !('XXXX' $ SC5->C5_NOTA) //Renato Nogueira - 230114 - Não permitir alterar o cabeçalho quando PV estiver faturado totalmente
				U_STALTSC5()
			elseif ('XXXX' $ SC5->C5_NOTA) .and. SC5->C5_XREAN14 $ "1#S" // Chamado 006688 - Robosn Mazzarotto
				U_STALTSC5()
			Else
				MsgAlert("Pedido totalmente faturado e não pode ser alterado!")
			EndIf
		//Elseif __cuserid $ getmv("ST_ROMEAN",,'000000')
		//FR - 14/12/2021 - #20211130025600 - Tela Markup para Colômbia
		Elseif __cuserid $ GetNewPar("ST_ROMEAN",'000000')
				U_STALTSC5()
		Else
			MsgAlert("Pedido totalmente faturado e não pode ser alterado!")
		EndIf
	Else
		U_STALTSC5()
	EndIf
Return

/*====================================================================================\
|Programa  | STALSC5IT        | Autor | Everson Santana         v| Data | 19/02/2017  |
|=====================================================================================|
|Descrição | Rotina para permitir alteração de preços dos pedidos de vendas.          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STALSC5IT                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*-----------------------------*
User Function STALSC5IT()
	*-----------------------------*
	//If (__cuserid $ getmv("ST_ALTVEN",,'000000')+'/000000')
	//FR - 14/12/2021 - #20211130025600 - Tela Markup para Colômbia
	If (__cuserid $ GetNewPar("ST_ALTVEN",'000000')+'/000000')
		If !SC5->C5_ZFATBLQ == '1'
			If !('XXXX' $ SC5->C5_NOTA)
				U_XSTALC5IT()
			elseif ('XXXX' $ SC5->C5_NOTA) .and. SC5->C5_XREAN14 = "1"
				U_XSTALC5IT()
			Else
				MsgAlert("Pedido totalmente faturado e não pode ser alterado!")
			EndIf
		Else
			MsgAlert("Pedido totalmente faturado e não pode ser alterado!")
		EndIf
	EndIf
Return

/*====================================================================================\
|Programa  | XA410ALT         | Autor | RENATO.NOGUEIRA          | Data | 20/03/2014  |
|=====================================================================================|
|Descrição |   													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | XA410ALT                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*-----------------------------*
User Function XA410ALT()
	*-----------------------------*

	DbSelectArea('SC6')
	SC6->(DbGoTop())
	SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
		//If   SC6->C6_OPER $ '01' .Or. GETMV("ST_C6OPER",,.F.)
		//FR - 14/12/2021 - #20211130025600 - Tela Markup para Colômbia
		If   SC6->C6_OPER $ '01' .Or. GETNEWPAR("ST_C6OPER",.F.)
			A410Altera("SC5",SC5->(Recno()),4)
		Else
			MsgInfo("Pedido Não Pode Ser Alterado!!!!!!!")
		EndIf
	EndIf
Return
