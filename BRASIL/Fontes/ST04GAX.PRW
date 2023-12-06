#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | ST04GAX          | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  Gap 04     Condição de Pagament                                         |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ST04GAX                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function ST04GAX()
*-----------------------------*
	Private aArea         := GetArea()
	Private lRet          := .F.
	Private _Lmomat       := IsInCallStack("TMKA271") .Or. IsInCallStack("TMKA380") .or. IsInCallStack("U_STFSVE46")
	Private _nPosDESC     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_DESC"    ,"C6_DESCONT"  	)   })
	Private _nPosTotItem  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_VLRITEM" ,"C6_VALOR"  	)   })
	Private _nPosPrcven   := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_VRUNIT"  ,"C6_PRCVEN"  )   })
	Private _nPosQtdVen	  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_QUANT"	  ,"C6_QTDVEN"  )   })
	Private _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_PRODUTO" ,"C6_PRODUTO"	)   })
	Private _nPosXVALACR  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XVALACR" ,"C6_XVALACR"	)   })
	Private _nPosXacres   := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XACRECP" ,"C6_XPORACR" )   })
	Private _nPosXPrCcon  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XPRCCON" ,"C6_XPRCCON" )   })
	Private _nPosUnt      := aScan(aHeader, { |x| AllTrim(x[2]) == IIF(  _Lmomat,"UB_PRCTAB"  ,"C6_XPRCLIS"  )   })
	Private _nValComiss   := 0
	Private _cFunCmp      := ""
	Private _nValAcre     := 0
	Private _cConCmp      := IIF(_Lmomat ,"M->UA_XLIMLIB","M->C5_XLIMLIB")
	Private _nTotPed      := 0
	Private _nxPrcven     := 0
	Private _xdesc        := 0
	Private _nPrcAnt      := 0
	Private _nCamDes      := 0
	Private cCliente 	  := IIF(_Lmomat ,"M->UA_CLIENTE","M->C5_CLIENTE")
	Private cLoja 	      := IIF(_Lmomat ,"M->UA_LOJA","M->C5_LOJACLI")
	
	Default _cCondPg      := ""

	If isincallstack("u_stzzi") .Or. isincallstack("u_xSTEDIPV") .Or. isincallstack("u_STSEB010")
		Return()
	EndIf
	
	
	//FR - Flávia Rocha - 17/02/2022 - erro na api conscotacoes trazia o campo M->UA_XCONDPG nulo, porque de fato a consulta não é orçamento	
	If !isincallstack("calculaped")
		_cFunCmp := IIF(_Lmomat ,"M->UA_XCONDPG","M->C5_ZCONDPG")

			//FR - 05/07/2022 - Sigamat Consultoria - Ticket #20220704013334 - só vai cair nesta condição se vier das apis consulta preço cotação e cad. cotação
			If Isincallstack("U_STCONSCOT") .OR. Isincallstack("U_STCRM07A")
				If &_cFunCmp == Nil 
					&_cFunCmp := _cCondPg	//se estiver nulo, traz da variável private que está criada no STCRM003
				Endif
			Else 
				_cFunCmp := IIF(_Lmomat ,"M->UA_XCONDPG","M->C5_ZCONDPG")	
			Endif 
			//FR - 05/07/2022 - Sigamat Consultoria - Ticket #20220704013334 - só vai cair nesta condição se vier das apis consulta preço cotação e cad. cotação
		 
		_nValAcre := Posicione("SE4",1,xFilial("SE4")+ &_cFunCmp,"E4_XACRESC")
	else
		M->C5_ZCONDPG := oXml:_PEDIDO:_CONDPG:TEXT
		_cFunCmp := "M->C5_ZCONDPG"
		_nValAcre := Posicione("SE4",1,xFilial("SE4")+&_cFunCmp,"E4_XACRESC")
	EndIf
                            
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
	
		dbSelectarea("SE4")
		SE4->(dbSetOrder(1))
		If SE4->(DbSeek(xFilial("SE4")+&_cFunCmp))
			&_cConCmp :=SE4->E4_XVLRMIN
		EndIf
		If !aCols[n,Len(aHeader)+1]
			//aCols[n,_nPosPrcven]:= (aCols[n,_nPosUnt]-(aCols[n,_nPosUnt]*(aCols[n,_nPosDESC]/100)))
		
			If ALLTRIM(&_cFunCmp) <> ' '

				_nCamDes := 0
				
				//FR - 27/06/2022 - CORREÇÃO POR CONTA DO ESTOURO DE ÁREA PARA COTAÇÕES COM MAIS DE 100 ITENS
				If !IsInCallStack("U_STCONSCOT") .and. !IsInCallStack("U_STCRM07A")
					_nCamDes := U_STDESCAMP(&cCliente,&cLoja,aCols[n,_nPosProd]   )
				Endif
				//FR - 27/06/2022 - CORREÇÃO POR CONTA DO ESTOURO DE ÁREA PARA COTAÇÕES COM MAIS DE 100 ITENS

				If _nCamDes <> 0
				
					If SE4->E4_CODIGO $ GetMv("ST_04GAT",,'501/608/615/506/717')//SOLICITAÇÃO DANIEL VENDAS TEM CHAMADO
						_nValAcre:= 0
					ElseIf SE4->E4_CODIGO $ GetMv("ST_04GA1",,'610/654/733') // considera 0.5 para algumas condiçoes de pagamento  giovani zago 28/04/2020 
						_nValAcre:= 0.5
					Else
						_nValAcre:= 2.26
					EndIf
				EndIf
		

				/********************************
				_nQtdRest declarada como private na rotina STCRM007
				Se a chamado veio do REST de integração do CRM
				Altera a quantidade pela passada pelo rest, pois o acols está fixando em 1 e está dando divergência nos valores
				********************************/
				IF IsInCallStack("U_STCRM07A")
					aCols[n,_nPosQtdVen] := _nQtdRest
				ENDIF
				aCols[n,_nPosXacres]   :=  _nValAcre
		
				aCols[n,_nPosXVALACR]  :=  round(aCols[n,_nPosQtdVen] * ((	aCols[n,_nPosXacres]*	aCols[n,_nPosPrcven])/100),2)
		
				aCols[n,_nPosPrcven]   :=  round(aCols[n,_nPosPrcven] + (aCols[n,_nPosXVALACR]  /aCols[n,_nPosQtdVen]),2 )
		
			EndIf
			aCols[n,_nPosTotItem]   :=  	aCols[n,_nPosPrcven] *	aCols[n,_nPosQtdVen]
		EndIf
	EndIf

	Restarea(aArea)
Return()
