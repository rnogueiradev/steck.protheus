#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STGAP04          | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  Gap 04     Condição de Pagament                                         |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STGAP04                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STGAP04(_cMod)
	*-----------------------------*
	Local i
	Private aArea         := GetArea()
	Private lRet          := .F.
	Private _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Private _nPosDESC     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_DESC"    ,"C6_DESC"  	)   })
	Private _nPosTotItem  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_VLRITEM" ,"C6_VALOR"  	)   })
	Private _nPosPrcven   := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_VRUNIT"  ,"C6_PRCVEN"  )   })
	Private _nPosQtdVen	  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_QUANT"	  ,"C6_QTDVEN"  )   })
	Private _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_PRODUTO" ,"C6_PRODUTO"	)   })
	Private _nPosXVALACR  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XVALACR" ,"C6_XVALACR"	)   })
	Private _nPosXacres   := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XACRECP" ,"C6_XPORACR" )   })
	Private _nPosXPrCcon  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XPRCCON" ,"C6_XPRCCON" )   })
	Private _nPosUnt      := aScan(aHeader, { |x| AllTrim(x[2]) == IIF(  _Lmomat,"UB_PRCTAB"  ,"C6_XPRCLIS"  )   })
	Private _nPosBloq     := aScan(aHeader, { |x| AllTrim(x[2]) == IIF(  _Lmomat,"UB_XBLQITE"  ,"C6_ZMOTBLO"  )   })
	Private _nPosPord    := aScan(aHeader, { |x| AllTrim(x[2]) ==  IIF(  _Lmomat,"UB_XPORDEC"  ,"C6_XVALDES"  )   })
	Private _nValComiss   := 0
	Private _cFunCmp      := IIF(_Lmomat ,"M->UA_XCONDPG","M->C5_ZCONDPG")
	Private _cMsgCli      := IIF(_Lmomat ,"M->UA_XMSGCLI","M->C5_XMSGCLI")
	Private _cXlikm       := IIF(_Lmomat ,"M->UA_XLIMLIB","M->C5_XLIMLIB")

	Private _cTpPedido    := IIF(_Lmomat ,'',"M->C5_TIPO")

	Private _nValAcre     := Posicione("SE4",1,xFilial("SE4")+&_cFunCmp,"E4_XACRESC")
	Private _nValPed      := Posicione("SE4",1,xFilial("SE4")+&_cFunCmp,"E4_XVLRMIN")
	Private _nTotPed      := 0
	Private _nxPrcven     := 0
	Private _xdesc        := 0
	Private _nPrcAnt      := 0
	Private _nOld		  := n

	//Chamado 002301 João Victor
	If _Lmomat
		_cTpPedido := 'N'
	Else
		_cTpPedido := &_cTpPedido
	Endif

	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		&_cXlikm:= _nValPed
		If !Empty(Alltrim(&_cFunCmp)) .and. alltrim(aCols[n,_nPosProd]) <> ''.And. Empty(alltrim(&_cMsgCli))
			If _cmod= '1'
				If _cTpPedido $ 'N'
					If IsBlind()
						ST04GAP(.T.)
					Else
						If RESA3() //se for interno atualiza a condpag
							ST04GAP(.T.)
						ElseIf msgyesno("Deseja Atualizar os Valores de Acordo com a Condição de Pagamento !!!!!")
							ST04GAP(.T.)
						Else
							For i:= 1 To Len(Acols)

								If !aCols[i,Len(aHeader)+1]
									n:=i
									aCols[n,_nPosXPrCcon]:=	(aCols[n,_nPosPrcven]*100 /(aCols[n,_nPosXacres]+100))*(1+(_nValAcre/100))
								EndIf
								aCols[i,_nPosBloq] := '4'
							Next i
							n:=_nOld
							If !(_Lmomat)

								M->C5_ZBLOQ   :="1"
								M->C5_ZMOTBLO := 	ALLTRIM(M->C5_ZMOTBLO)+'CONDPG/'
								//	_oDlgDefault := GetWndDefault()
								//aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
								If ( Type("l410Auto") == "U" .or. ! l410Auto)          //Inserido Jefferson Carlos dia 25/11/2013
									If !( oGetDad == Nil )                             //Inserido Jefferson Carlos dia 25/11/2013
										oDlg                      := GetWndDefault()   //Inserido Jefferson Carlos dia 25/11/2013
										oDlg := oGetDad:oWnd                           //Inserido Jefferson Carlos dia 25/11/2013
									EndIf                                              //Inserido Jefferson Carlos dia 25/11/2013
								EndIf
								//Ma410Rodap(,,0)
								If ( Type("l410Auto") == "U" .OR. !l410Auto )
									oGetDad:oBrowse:Refresh()
								EndIf

							Else
								M->UA_XBLOQ :='1'
								M->UA_XDESBLQ := 	ALLTRIM(M->UA_XDESBLQ)+'CONDPG/'
								Tk273Trigger()
								//_oDlgDefault := GetWndDefault()
								//aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
								/*Giovani Zago Ta dando erro no gatilho 19/02/14
								If ( Type("l410Auto") == "U" .or. ! l410Auto)          //Inserido Jefferson Carlos dia 25/11/2013
								If !( oGetDad == Nil )                             //Inserido Jefferson Carlos dia 25/11/2013
								oDlg                      := GetWndDefault()   //Inserido Jefferson Carlos dia 25/11/2013
								oDlg := oGetDad:oWnd                           //Inserido Jefferson Carlos dia 25/11/2013
								EndIf                                              //Inserido Jefferson Carlos dia 25/11/2013
								EndIf
								*/
								Tk273FRefresh()
								Tk273TlvImp()
							EndIf
						EndIf
					EndIf
				Endif
			ElseIf  _cmod = '2'
				ST04GAP(.F.)
			Endif
		EndIf
	EndIf

	Restarea(aArea)
	Return(lRet)
	/*====================================================================================\
	|Programa  | ST04GAP          | Autor | GIOVANI.ZAGO             | Data | 23/02/2013  |
	|=====================================================================================|
	|Descrição |  Gap 04     Condição de Pagament                                         |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | ST04GAP                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function ST04GAP(_lXGap)
	*-----------------------------*
	local _nxn := n
	Local i

	For i:= 1 To Len(Acols)

		If !aCols[i,Len(aHeader)+1]
			n:=i
			If !(_Lmomat)
				u_STFATG02()
			Else
				u_STTMKG03()
			EndIf

			If !(_Lmomat)
				//_oDlgDefault := GetWndDefault()
				//aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
				If ( Type("l410Auto") == "U" .or. ! l410Auto)          //Inserido Jefferson Carlos dia 25/11/2013
					If !( oGetDad == Nil )                             //Inserido Jefferson Carlos dia 25/11/2013
						oDlg                      := GetWndDefault()   //Inserido Jefferson Carlos dia 25/11/2013
						oDlg := oGetDad:oWnd                           //Inserido Jefferson Carlos dia 25/11/2013
					EndIf                                              //Inserido Jefferson Carlos dia 25/11/2013
				EndIf
				Ma410Rodap(,,0)
				If ( Type("l410Auto") == "U" .OR. !l410Auto )
					oGetDad:oBrowse:Refresh()
				EndIf

			Else

				M->UA_CONDPG :=	M->UA_XCONDPG

				MaFisRef("IT_VALMERC","TK273",aCols[i,_nPosTotItem])
				U_STTMKG01()

				Tk273Trigger()
				Tk273FRefresh()
				Tk273TlvImp()
			Endif
		EndIf
	Next i
	n := _nxn
	If (_Lmomat)

		Tk273Trigger()
		Tk273FRefresh()
		Tk273TlvImp()
		M->UA_CONDPG :=	M->UA_XCONDPG
	Endif
Return()




Static Function RESA3()

	Local saArea := SA3->(GetArea())
	Local _sRet  := .F.


	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	SA3->(DbGotop())
	If SA3->(dbSeek(xFilial("SA3")+__cUserId))

		If SubStr(SA3->A3_COD,1,1) $ "I" .And. Empty(Alltrim(SA3->A3_SUPER))
			_sRet  := .T.
		EndIf
	EndIf

	//Ticket 20201029009682
	If __cUserID $ GetMv("STGAP041",,"000366#000231#000641#000378")
		_sRet := .F.
	Else
		_sRet := .T.
	EndIf

	Restarea(saArea)
Return(_sRet)


