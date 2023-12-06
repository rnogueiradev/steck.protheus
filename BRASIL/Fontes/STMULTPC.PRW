#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STMULTPC	ºAutor  ³Renato Nogueira     º Data ³  24/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado para selecionar mais de um pedido para a    º±±
±±º          ³mesma linha da nota de entrada  		    				    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ 		                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STMULTPC()

	Local _aArea 			:= GetArea()
	Local _aAreaSD1		:= SD1->(GetArea())
	Local _cQuery 		:= ""
	Local _cAlias 		:= "QRYTEMP"
	Local _lContinua		:= .T.
	Local aCampoEdit		:= {}
	Local lSaida   		:= .T.
	Local lConfirma		:= .F.
	Local lMudou			:= .F.
	Local _nZ:= 0
	Local ni:= 0
	Local ny:= 0
	Local _nX:= 1
	Public _aCols
	PRIVATE _nPedido		:= aScan(aHeader,{|w| AllTrim(w[2])=="D1_PEDIDO"})
	PRIVATE _nPosCC		:= aScan(aHeader,{|w| AllTrim(w[2])=="D1_CC"})
	PRIVATE _nFilial		:= aScan(aHeader,{|w| AllTrim(w[2])=="D1_FILIAL"})
	PRIVATE _nDoc			:= aScan(aHeader,{|w| AllTrim(w[2])=="D1_DOC"})
	PRIVATE _nSerie		:= aScan(aHeader,{|w| AllTrim(w[2])=="D1_SERIE"})
	PRIVATE _nFornece		:= aScan(aHeader,{|w| AllTrim(w[2])=="D1_FORNECE"})
	PRIVATE _nLoja		:= aScan(aHeader,{|w| AllTrim(w[2])=="D1_LOJA"})
	PRIVATE _nItemD1		:= aScan(aHeader,{|w| AllTrim(w[2])=="D1_ITEM"})
	PRIVATE _nItem		:= aScan(aHeader,{|w| AllTrim(w[2])=="D1_ITEMPC"})
	PRIVATE _nProduto		:= aScan(aHeader,{|w| AllTrim(w[2])=="D1_COD"})
	PRIVATE _nQuant		:= aScan(aHeader,{|w| AllTrim(w[2])=="D1_QUANT"})
	PRIVATE bOk 			:= {||(	lSaida:=.f., lConfirma:=.T.,oDlg:End()) }
	PRIVATE bCancel 	    := {||(	lSaida:=.f.,oDlg:End()) }
	PRIVATE aButtons	    := {}
	PRIVATE oGet
	PRIVATE _aStruTrb 	:= {} //estrutura do temporario
	PRIVATE oDlg
	PRIVATE _lCriou
	PRIVATE oOk   	   	:= LoadBitmap( GetResources(), "LBOK" )
	PRIVATE oNo	      	:= LoadBitmap( GetResources(), "LBNO" )
	PRIVATE oLbx
	PRIVATE _nValQtd		:= aCols[n][_nQuant]
	PRIVATE _cValItem		:= aCols[n][_nItemD1]

	If AllTrim(CA100FOR)<>"005866" //Quando for Manaus não deve entrar na rotina

		If Type("_aCols")=="U"
			_aCols	:= {}
		EndIf

		If aCols[n][_nQuant]==0
			MsgAlert("Atenção, quantidade não preenchida!")
			Return
		EndIf

		If !Empty(aCols[n][_nPedido])
			MsgAlert("Atenção, pedido preenchido!")
			Return
		EndIf

		If Type("_lCriou")=="U"

			//Define campos do TRB

			AADD(_aStruTrb,{"Pedido","PEDIDO","@!",6,0,,,"C","","R",})
			AADD(_aStruTrb,{"Item","ITEM"  ,"@!",4,0,,,"C","","R",})
			AADD(_aStruTrb,{"Produto","PROD"  ,"@!",15,0,,,"C","","R",})
			AADD(_aStruTrb,{"Quant","QUANT"  ,"@E 999999999.99",12,2,,,"N","","R",})
			AADD(_aStruTrb,{"Quant Sub","OK"  ,"@E 999999999.99",12,2,"U_STVLDSC7()",,"N","","R",})
			AADD(_aStruTrb,{"Saldo","SALDO"  ,"@E 999999999.99",12,2,,,"N","","R",})
			AADD(_aStruTrb,{"Registo","REGISTRO"  ,"@E",20,0,,,"N","","R",})
			AADD(_aStruTrb,{"Filial","FILIAL"  ,"@!",2,0,,,"C","","R",})
			AADD(_aStruTrb,{"Documento","DOC"  ,"@!",9,0,,,"C","","R",})
			AADD(_aStruTrb,{"Serie","SERIE"  ,"@!",3,0,,,"C","","R",})
			AADD(_aStruTrb,{"Fornecedor","FORNECE"  ,"@!",6,0,,,"C","","R",})
			AADD(_aStruTrb,{"Loja","LOJA"  ,"@!",2,0,,,"C","","R",})
			AADD(_aStruTrb,{"Item","D1ITEM"  ,"@!",4,0,,,"C","","R",})

		EndIf

		cQuery := " SELECT C7_FILIAL, C7_NUM, C7_ITEM, C7_PRODUTO, C7_QUANT-C7_QUJE SALDO, R_E_C_N_O_ REGISTRO "
		cQuery += " FROM "+RetSqlName("SC7")+" C7 "
		cQuery += " WHERE C7.D_E_L_E_T_=' ' AND C7_QUANT-C7_QUJE>0 AND C7_FORNECE='"+CA100FOR+"' "
		cQuery += " AND C7_LOJA='"+CLOJA+"' AND C7_FILIAL='"+cFilAnt+"' AND C7_RESIDUO=' ' AND "
		cQuery += " C7_PRODUTO='"+aCols[n][_nProduto]+"' "
		cQuery += " ORDER BY C7_FILIAL, C7_PRODUTO, C7_NUM, C7_ITEM "
		cQuery := ChangeQuery(cQuery)

		cAlias :=	GetNextAlias()
		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias)

		While (cAlias)->(!Eof())

			For _nZ:=1 To Len(_aCols)
				If _aCols[_nZ][1]==(cAlias)->C7_NUM .And. _aCols[_nZ][2]==(cAlias)->C7_ITEM

					For nY := 1 To Len(_aStruTrb)
						DO CASE
							CASE AllTrim(_aStruTrb[nY][2]) =  "QUANT"
							If _aCols[Len(_aCols)][nY]<>aCols[n][_nQuant]
								_aCols[Len(_aCols)][nY] := aCols[n][_nQuant]
								lMudou	:= .T.
							EndIf
							CASE AllTrim(_aStruTrb[nY][2]) =  "OK"
							If lMudou
								_aCols[Len(_aCols)][nY] := 0
								lMudou	:= .F.
							EndIf
						ENDCASE
					Next
					(cAlias)->(DbSkip())

				EndIf
			Next

			If (cAlias)->(!Eof())

				AADD(_aCols,Array(Len(_aStruTrb)+1))

				For nY := 1 To Len(_aStruTrb)

					DO CASE
						CASE AllTrim(_aStruTrb[nY][2]) =  "PEDIDO"
						_aCols[Len(_aCols)][nY] := (cAlias)->C7_NUM
						CASE AllTrim(_aStruTrb[nY][2]) =  "ITEM"
						_aCols[Len(_aCols)][nY] := (cAlias)->C7_ITEM
						CASE AllTrim(_aStruTrb[nY][2]) =  "PROD"
						_aCols[Len(_aCols)][nY] := (cAlias)->C7_PRODUTO
						CASE AllTrim(_aStruTrb[nY][2]) =  "QUANT"
						_aCols[Len(_aCols)][nY] := aCols[n][_nQuant]
						CASE AllTrim(_aStruTrb[nY][2]) =  "SALDO"
						_aCols[Len(_aCols)][nY] := (cAlias)->SALDO
						CASE AllTrim(_aStruTrb[nY][2]) =  "REGISTRO"
						_aCols[Len(_aCols)][nY] := (cAlias)->REGISTRO
						CASE AllTrim(_aStruTrb[nY][2]) =  "FILIAL"
						_aCols[Len(_aCols)][nY] := cFilAnt
						CASE AllTrim(_aStruTrb[nY][2]) =  "DOC"
						_aCols[Len(_aCols)][nY] := CNFISCAL
						CASE AllTrim(_aStruTrb[nY][2]) =  "SERIE"
						_aCols[Len(_aCols)][nY] := CSERIE
						CASE AllTrim(_aStruTrb[nY][2]) =  "FORNECE"
						_aCols[Len(_aCols)][nY] := CA100FOR
						CASE AllTrim(_aStruTrb[nY][2]) =  "LOJA"
						_aCols[Len(_aCols)][nY] := CLOJA
						CASE AllTrim(_aStruTrb[nY][2]) =  "D1ITEM"
						_aCols[Len(_aCols)][nY] := aCols[n][_nItemD1]
						CASE AllTrim(_aStruTrb[nY][2]) =  "OK"
						_aCols[Len(_aCols)][nY] := 0
					ENDCASE

				Next

				_aCols[Len(_aCols)][Len(_aStruTrb)+1] := .F.

				(cAlias)->(DbSkip())

			EndIf

		Enddo

		aCampoEdit := {"OK"}

		While lSaida
			DEFINE MSDIALOG oDlg FROM 0,0 TO 400,700/*500,1200*/ TITLE Alltrim(OemToAnsi('Pedidos')) Pixel //430,531

			oGet	:= MsNewGetDados():New( 30,  0,  185,350, GD_UPDATE ,"AllWaysTrue()","AllWaysTrue()",,aCampoEdit,,Len(_aCols),,, ,oDlg, _aStruTrb, _aCols )
			MsNewGetDados():SetEditLine (.T.)

			ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel,,aButtons)
		End

		If lConfirma

			DbSelectArea("SC7")
			SC7->(DbSetOrder(1))

			_cCusto := ""
			

			For _nX:=1 To Len(oGet:aCols)
				If oGet:aCols[_nX][5]>0
					If SC7->(DbSeek(xFilial("SC7")+oGet:aCols[_nX][1]+oGet:aCols[_nX][2]))
						_cCusto := SC7->C7_CC
						Exit
					EndIf
				EndIf
			Next

			If !Empty(_cCusto)
				aCols[n][_nPosCC] := _cCusto
			EndIf

		EndIf

	Else

		MsgAlert("Atenção, nota vinda de Manaus, não é permitido usar essa rotina")

	EndIf

	RestArea(_aAreaSD1)
	RestArea(_aArea)

Return()

User Function STVLDSC7()

	Local _lRet		:= .T.
	Local _nQtdDig	:= &(ReadVar())
	Local _nQtdAnt	:= 0
	Local _nQtdTot	:= 0
	Local nX	:= 0

	If _aCols[n][13]<>_cValItem
		_lRet	:= .F.
		MsgAlert("Atenção, item alterado diferente de item posicionado, verifique!")
	EndIf

	For nX:=1 To Len(_aCols)
		If _aCols[nX][13]==_cValItem
			_nQtdAnt	+= _aCols[nX][5]
		EndIf
	Next

	_nQtdTot	:= _nQtdAnt+_nQtdDig

	If _nQtdTot>_nValQtd
		_lRet	:= .F.
		MsgAlert("Atenção, a quantidade colocada é maior do que a quantidade da nota!")
	EndIf

	If &(ReadVar())>_aCols[n][6]
		_lRet	:= .F.
		MsgAlert("Atenção, quantidade digitada maior que saldo do pedido!")
	EndIf

	If _lRet
		_aCols[n][5]	:= &(ReadVar())
	EndIf

Return(_lRet)
