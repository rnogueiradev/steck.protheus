#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | STCOM260        | Autor | RENATO.OLIVEIRA           | Data | 09/08/2022  |
|=====================================================================================|
|Descrição | CRIAR PC A PARTIR DO PO                                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM260()

	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()
	Private lMsErroAuto := .F.

	//RpcSetType( 3 )
	//RpcSetEnv("01","05",,,"FAT")

	DbSelectArea("SC7")
	SC7->(DbSetOrder(1))

	_cPoNum := FWInputBox("Informe o PO:", _cPoNum)

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SW2")+" W2
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC7")+" C7
	_cQuery1 += " ON C7_FILIAL=W2_FILIAL AND W2_PO_NUM=C7_PO_EIC AND C7.D_E_L_E_T_=' ' 
	_cQuery1 += " AND C7.C7_FILIAL='"+xFilial("SC7")+"'
	_cQuery1 += " LEFT JOIN "+RetSqlName("SW3")+" W3
	_cQuery1 += " ON W2_FILIAL=W3_FILIAL AND W2_PO_NUM=W3_PO_NUM
	_cQuery1 += " WHERE W2.D_E_L_E_T_=' '  AND W3.D_E_L_E_T_=' ' AND W3_TEC<>' ' 
	_cQuery1 += " AND C7.C7_NUM IS NULL AND W2_PO_NUM='"+_cPoNum+"'
	_cQuery1 += " ORDER BY W2_PO_NUM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_cItem  	:= "0000"
	_aCabec 	:= {}
	_aItens 	:= {}

	While .T.
		_cNumPc := GetSXENum("SC7","C7_NUM")
		If SC7->(DbSeek(xFilial("SC7")+_cNumPc))
			SC7->(ConfirmSX8())
		Else
			Exit
		EndIf
	EndDo

	While (_cAlias1)->(!Eof())	

		_aCabec:= {{"C7_NUM"            ,_cNumPc 													,nil},;
		{"C7_EMISSAO"                   ,Date()										,nil},;
		{"C7_FORNECE"                   ,(_cAlias1)->W2_FORN											,nil},;
		{"C7_LOJA"                      ,(_cAlias1)->W2_FORLOJ										,nil},;
		{"C7_COND"                   	,Posicione("SY6",1,xFilial("SY6")+(_cAlias1)->W2_COND_PA,"Y6_SIGSE4")	,nil},;
		{"C7_MOEDA"                   	,4															,nil},;
		{"C7_TXMOEDA"                  	,5.3583															,nil}}

		_aItem := {}
		_cItem 		:= Soma1(_cItem)

		_aItem :=   {	{"C7_ITEM"   		,(_cAlias1)->W3_POSICAO    																									,nil},;
		{"C7_PRODUTO"	,(_cAlias1)->W3_COD_I																										,nil},;
		{"C7_QUANT" 	,(_cAlias1)->W3_QTDE 																			,nil},;
		{"C7_PRECO" 	,(_cAlias1)->W3_PRECO 																			,nil},;
		{"C7_DATPRF" 	,Date()																	,nil},;
		{"C7_CC","115108",NIL},;
		{"C7_PO_EIC"                   	,_cPoNum	,nil}}

		aadd(_aItens,_aItem)

		(_cAlias1)->(DbSkip())
	EndDo

	lMsErroAuto := .F.

	If Len(_aCabec)>0

		MSExecAuto({|u,v,x,y| MATA120(u,v,x,y)},1,_aCabec,_aItens,3)

		If lMsErroAuto
			_cErro := MostraErro("arquivos\logs",dtos(date())+time()+".log")
			SC7->(RollBackSX8())
			MsgAlert(_cErro)
		Else
			SC7->(ConfirmSX8())
			MsgAlert("Pedido inserido")

			TcSqlExec("UPDATE "+RetSqlName("SC7")+" C7 SET C7_PO_EIC='"+_cPoNum+"' WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='"+xFilial("SC7")+"' AND C7_NUM='"+_cNumPc+"'")
		EndIf

	Else
		MsgAlert("PO já gerado, favor validar!")
	EndIf

Return
