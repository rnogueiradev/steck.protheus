#Include "Protheus.ch"
#Include "RWMake.ch"
#Include "TBIConn.ch"
#Include "AP5Mail.ch"
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} STDISTC7
description
@type function
@version  
@author everson.santana
@since 23/08/2022
@return variant, return_description
/*/

User Function STDISTC7()

	Local aCabec := {}
	Local aItens := {}
	Local aLinha := {}
	Local aRatCC := {}
	Local aRatPrj := {}
	Local aAdtPC := {}
	//Local aItemPrj := {{"01","02"},{"02","01"}} //Projeto, Tarefa
	//Local aCCusto := {{40,"01","101010","333330","CL0001"},{60,"02","101011","333330","CL0001"}} //Porcentagem,Centro de Custo, Conta Contabil, Item Conta, CLVL
	Local nX := 0
	Local cDoc := ""
	Local nOpc := 3
	Local cQuery := ""
	Local cNumC6 := ""


	PRIVATE lMsErroAuto := .F.

	PREPARE ENVIRONMENT EMPRESA "11" FILIAL "01" MODULO "COM"

	__cUserId := "000000"

	cQuery := " SELECT (C6_QTDVEN - C6_QTDENT) C6_SALDO,C6_PRCVEN,C6_VALOR,C6.* FROM UDBP12.SC6010 C6
	cQuery += " LEFT JOIN UDBP12.SC5010 C5 ON C5_FILIAL=C6_FILIAL AND C6_NUM=C5_NUM
	cQuery += " WHERE C6_NUM IN('005178','005184','005195','005204','004785','004789','004987','005002','005006','005012','004725','004754','004786','004335','005221','005286')
	cQuery += " AND C6_FILIAL = '05' "
	cQuery += " AND C6_QTDVEN - C6_QTDENT > 0 "
	cQuery += " AND C5.D_E_L_E_T_ = ' ' AND C6.D_E_L_E_T_ = ' '
	cQuery += " AND C5_ZNUMPC=' ' 
	cQuery := ChangeQuery(cQuery)

	//ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Select pedido de venda."+ALLTRIM(cQuery))
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC6', .F., .T.)

	DbSelectArea("TSC6")
	DbGotop()

	While(!EOF())

		cNumC6 := TSC6->C6_NUM

		dbSelectArea("SC7")

//Teste de Inclusão
		cDoc := GetSXENum("SC7","C7_NUM")
		SC7->(dbSetOrder(1))
		While SC7->(dbSeek(xFilial("SC7")+cDoc))
			ConfirmSX8()
			cDoc := GetSXENum("SC7","C7_NUM")
		EndDo

		aadd(aCabec,{"C7_NUM" ,cDoc})
		aadd(aCabec,{"C7_EMISSAO" ,dDataBase})
		aadd(aCabec,{"C7_FORNECE" ,"005764"})
		aadd(aCabec,{"C7_LOJA" ,"05"})
		aadd(aCabec,{"C7_COND" ,"007"})
		aadd(aCabec,{"C7_CONTATO" ,"EDUARDO"})
		aadd(aCabec,{"C7_FILENT" ,cFilAnt})

		DbSelectArea("TSC6")

		While(!EOF()) .AND. TSC6->C6_NUM == cNumC6
			//For nX := 1 To 1
			aLinha := {}
			aadd(aLinha,{"C7_PRODUTO" ,TSC6->C6_PRODUTO,Nil})
			aadd(aLinha,{"C7_QUANT" ,TSC6->C6_SALDO ,Nil})
			aadd(aLinha,{"C7_PRECO" ,TSC6->C6_PRCVEN ,Nil})
			aadd(aLinha,{"C7_TOTAL" ,TSC6->C6_SALDO * TSC6->C6_PRCVEN ,Nil})
			aadd(aLinha,{"C7_MOTIVO" ,"MRP" ,Nil})
			aadd(aLinha,{"C7_COMPSTK" ,"102" ,Nil})
			aadd(aLinha,{"C7_CC" ,"115108" ,Nil})
			aadd(aLinha,{"C7_CONTA" ,"114001001" ,Nil})
			aadd(aLinha,{"C7_OBS" ,"Pedido Gerado pela rotina STDISTCT ref. ao pedido de vendas "+Alltrim(cNumC6) ,Nil})
			aadd(aLinha,{"C7_CONTA" ,"114001001" ,Nil}) 

			aadd(aLinha,{"C7_ZNUMPV" ,cNumC6 ,Nil}) 
			aadd(aLinha,{"C7_XPEDGER" ,'S' ,Nil}) 
			aadd(aLinha,{"C7_XPEDVEN" ,cNumC6 ,Nil}) 
			aadd(aLinha,{"C7_XITEMPV" ,TSC6->C6_ITEM ,Nil}) 
			aadd(aLinha,{"C7_XDATAPV" ,DTOS(DATE()) ,Nil}) 
			aadd(aItens,aLinha)
			//Next nX
			TSC6->(DbSkip())
		End

		MSExecAuto({|a,b,c,d,e,f,g,h| MATA120(a,b,c,d,e,f,g,h)},1,aCabec,aItens,nOpc,.F.,aRatCC,aAdtPC,aRatPrj)

		If !lMsErroAuto
			ConOut("Incluido PC: "+cDoc)

			_cQuery := " "
			_cQuery := " UPDATE UDBP12.SC5010 SET C5_ZNUMPC = '"+cDoc+"' "
			_cQuery += " WHERE C5_FILIAL = '05' "
			_cQuery += " AND C5_NUM = '"+cNumC6+"' "
			_cQuery += " AND D_E_L_E_T_ = ' ' "

			nErrQry := TCSqlExec( _cQuery )

			If nErrQry <> 0
				Conout('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
			EndIf

            aCabec := {}
            aItens := {}
            aRatCC := {}
            aAdtPC := {}
            aRatPrj := {}
            cNumC6 := ""

            DbSelectArea("TSC6")
            Loop
		Else
			ConOut("Erro na inclusao!")
			MostraErro()
		EndIf

	End
/*
//Rateio Centro de Custo
	aAdd(aRatCC, Array(2))
	aRatCC[1][1] := "0001"
	aRatCC[1][2] := {}

	For nX := 1 To Len(aCCusto)
		aLinha := {}
		aAdd(aLinha, {"CH_FILIAL" , xFilial("SCH"), Nil})
		aAdd(aLinha, {"CH_ITEM" , PadL(nX, TamSx3("CH_ITEM")[1], "0"), Nil})
		aAdd(aLinha, {"CH_PERC" , aCCusto[nX][1], Nil})
		aAdd(aLinha, {"CH_CC" , aCCusto[nX][2], Nil})
		aAdd(aLinha, {"CH_CONTA" , aCCusto[nX][3], Nil})
		aAdd(aLinha, {"CH_ITEMCTA" , aCCusto[nX][4], Nil})
		aAdd(aLinha, {"CH_CLVL" , aCCusto[nX][5], Nil})

		aAdd(aRatCC[1][2], aClone(aLinha))
	Next nX

//Rateio Projeto
	aAdd(aRatPrj, Array(2))
	aRatPrj[1][1] := "0001"
	aRatPrj[1][2] := {}

	For nX := 1 To Len(aItemPrj)
		aLinha := {}
		aAdd(aLinha, {"AJ7_FILIAL" , xFilial("AJ7") , Nil})
		aAdd(aLinha, {"AJ7_PROJET" , aItemPrj[nX][1], Nil})
		aAdd(aLinha, {"AJ7_TAREFA" , PadR(aItemPrj[nX][2],TamSX3("AF9_TAREFA")[1]), Nil})
		aAdd(aLinha, {"AJ7_NUMPC" , cDoc , Nil})
		aAdd(aLinha, {"AJ7_ITEMPC" , "0001" , Nil})
		aAdd(aLinha, {"AJ7_COD" , "0001" , Nil})
		aAdd(aLinha, {"AJ7_QUANT" , 1 , Nil})
		aAdd(aLinha, {"AJ7_REVISA" , "0001" , Nil})
		aAdd(aRatPrj[1][2], aClone(aLinha))
	Next nX

//Adiantamento
	aLinha := {}
	aAdd(aLinha, {"FIE_FILIAL", xFilial("FIE"),                                                            Nil})
	aAdd(aLinha, {"FIE_CART",   "P",                                                                        Nil}) // Carteira pagar
	aAdd(aLinha, {"FIE_PEDIDO", "" ,                                                                       Nil}) // Não precisa, pois quem trata é a MATA120
	aAdd(aLinha, {"FIE_PREFIX", PadR("A", TamSX3("FIE_PREFIX")[1]),                    Nil}) //Prefixo
	aAdd(aLinha, {"FIE_NUM",    PadR("PAPC01", TamSX3("FIE_NUM")[1]),            Nil}) //Numero Titulo
	aAdd(aLinha, {"FIE_PARCEL", PadR("1", TamSX3("FIE_PARCEL")[1]),                  Nil}) //Parcela
	aAdd(aLinha, {"FIE_TIPO",   PadR("PA", TamSX3("FIE_TIPO")[1]),                       Nil}) //Tipo = PA
	aAdd(aLinha, {"FIE_FORNEC", PadR("001 ", TamSX3("FIE_FORNEC")[1]),          Nil}) // Fornecedor
	aAdd(aLinha, {"FIE_LOJA",   PadR("01", TamSX3("FIE_LOJA")[1]),                       Nil}) //Loja
	aAdd(aLinha, {"FIE_VALOR",  100,                                                                     Nil}) // Valor do pa que está vinculado ao pedido
	aAdd(aAdtPC, aClone(aLinha))
*/



	RESET ENVIRONMENT

Return
