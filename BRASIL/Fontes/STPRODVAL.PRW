#include 'Protheus.ch'
#include 'RwMake.ch'
#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | STPRODVAL        | Autor | GIOVANI.ZAGO             | Data | 30/06/2013  |
|=====================================================================================|
|Descrição |  STPRODVAL    Troca newcon por albany                                    |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPRODVAL                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STPRODVAL()
	*-----------------------------*
	//Private aArea         := GetArea()
	//Local i:= 1
	//FR - Flávia Rocha - Sigamat Consultoria
	Local lRest     := .F. //FR - 29/03/2022 - indica se a chamada veio do Rest das cotações STCRM003
	//FR - Flávia Rocha - Sigamat Consultoria

	Public _cAlbany       := ""

	Private lRet          := .T.
	Private _Lmomat       := IsInCallStack("TMKA271") .Or. IsInCallStack("TMKA380") .or. IsInCallStack("U_STFSVE46")
	Private _cProd		  := IIF(  _Lmomat,"UB_PRODUTO" ,"C6_PRODUTO"	)
	Private _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == _cProd   })
	Private _nPosDescri	  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_DESCRI" ,"C6_DESCRI"	)   })
	Private _cCli     	  := IIF(_Lmomat ,"M->UA_CLIENTE","M->C5_CLIENTE")
	Private _cLojaCli     := IIF(_Lmomat ,"M->UA_LOJA"	 ,"M->C5_LOJACLI")
	Private _cStella      := IIF(_Lmomat ,"M->UA_XSTELLA"	 ,"M->C5_XSTELLA")
	Private _nEstAlbany   := 0
	Private _lAtiva		  := GetMv("ST_PRODVAL",,.t.)
	Private _cGrpStella	  := GetMv("ST_QUANV01",,'105')
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		lRet:= STLINCOUNT()
	EndIf

	//FR - 29/03/2022 - Alteração - Se a chamada veio do rest de integração CRM cotações: 
	If IsInCallStack("POST") .or. IsInCallStack("U_STCONSCOT") .OR. IsInCallStack("U_STCRM07A")
		lRest := .T.		
	Endif
	//FR - 29/03/2022 - Alteração - Se a chamada veio do rest de integração CRM cotações:  

	If !IsInCallStack("U_STTRANSIBL")
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+&("M->"+_cProd)))
			If AllTrim(SB1->B1_XMSBLQL)=="1" //Bloqueado
				MsgAlert("Produto bloqueado, verifique!")
				Return(.F.)
			EndIf
		EndIf
	EndIf

	If _lAtiva .And. ( Type("l410Auto") == "U" .OR. !l410Auto ) .And. lRet
		If Alltrim(&("M->"+_cProd)) $ "N3056/N3256/N4059/N3079/N4279/N4206/N3279/N5276/N3206/N4256/N4006/N3076/N5076/N3006/N4209/N3259/N4259/N5006/N3209/N4276/N4056/N3009/N5206/N4009/N4079/N4076/N3059/N3254/N4509/N4579/N3246/N4046/N3054"
			DbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			If SA1->(DbSeek(xFilial("SA1")+ &_cCli + &_cLojaCli))
				If SA1->A1_XNEWCON = 'B' .Or. Empty(Alltrim(SA1->A1_XNEWCON))
					Do Case
					Case Alltrim(&('M->'+_cProd)) = 'N4509'
						_cAlbany:=  'A4509'
					Case Alltrim(&('M->'+_cProd)) = 'N4579'
						_cAlbany:=  'A4579'
					Case Alltrim(&('M->'+_cProd)) = 'N4256'
						_cAlbany:=  'A4256'
					Case Alltrim(&('M->'+_cProd)) = 'N3209'
						_cAlbany:=  'A3209'
					Case Alltrim(&('M->'+_cProd)) = 'N4206'
						_cAlbany:=  'A4206'
					Case Alltrim(&('M->'+_cProd)) = 'N4006'
						_cAlbany:=  'A4006'
					Case Alltrim(&('M->'+_cProd)) = 'N4009'
						_cAlbany:=  'A4009'
					Case Alltrim(&('M->'+_cProd)) = 'N3254'
						_cAlbany:=  'A3254'
					Case Alltrim(&('M->'+_cProd)) = 'N3256'
						_cAlbany:=  'A3256'
					Case Alltrim(&('M->'+_cProd)) = 'N4056'
						_cAlbany:=  'A4056'
					Case Alltrim(&('M->'+_cProd)) = 'N3246'
						_cAlbany:=  'A3246'
					Case Alltrim(&('M->'+_cProd)) = 'N4046'
						_cAlbany:=  'A4046'
					Case Alltrim(&('M->'+_cProd)) = 'N3054'
						_cAlbany:=  'A3054'
					Case Alltrim(&('M->'+_cProd)) = 'N3059'
						_cAlbany:=  'A3059'
					Case Alltrim(&('M->'+_cProd)) = 'N3004'
						_cAlbany:=  'A3004'
					Case Alltrim(&('M->'+_cProd)) = 'N3006'
						_cAlbany:=  'A3006'
					Case Alltrim(&('M->'+_cProd)) = 'N3009'
						_cAlbany:=  'A3009'
					Case Alltrim(&('M->'+_cProd)) = 'N4076'
						_cAlbany:=  'A4076'
					Case Alltrim(&('M->'+_cProd)) = 'N4079'
						_cAlbany:=  'A4079'
					Case Alltrim(&('M->'+_cProd)) = 'N4076'
						_cAlbany:=  'A4076I'
					Case Alltrim(&('M->'+_cProd)) = 'N3044'
						_cAlbany:=  'A3044'
					Case Alltrim(&('M->'+_cProd)) = 'N3049'
						_cAlbany:=  'A3049'
					Case Alltrim(&('M->'+_cProd)) = 'N3074'
						_cAlbany:=  'A3074'
					Case Alltrim(&('M->'+_cProd)) = 'N3079'
						_cAlbany:=  'A3079'
					Case Alltrim(&('M->'+_cProd)) = 'N3276'
						_cAlbany:=  'A3276I'
					Case Alltrim(&('M->'+_cProd)) = 'N3274'
						_cAlbany:=  'A3274I'
					Case Alltrim(&('M->'+_cProd)) = 'N4059'
						_cAlbany:=  'A4059I'
					Case Alltrim(&('M->'+_cProd)) = 'N4276'
						_cAlbany:=  'A4276I'
					Case Alltrim(&('M->'+_cProd)) = 'N4279'
						_cAlbany:=  'A4279I'
					Case Alltrim(&('M->'+_cProd)) = 'N4006'
						_cAlbany:=  'A4006I'
					Case Alltrim(&('M->'+_cProd)) = 'N5006'
						_cAlbany:=  'A5006I'
					Case Alltrim(&('M->'+_cProd)) = 'N4256'
						_cAlbany:=  'A4256I'
					Case Alltrim(&('M->'+_cProd)) = 'N4056'
						_cAlbany:=  'A4056I'
					Case Alltrim(&('M->'+_cProd)) = 'N3054'
						_cAlbany:=  'A3054I'
					Case Alltrim(&('M->'+_cProd)) = 'N3056'
						_cAlbany:=  'A3056I'
					Case Alltrim(&('M->'+_cProd)) = 'N3256'
						_cAlbany:=  'A3256I'
					Case Alltrim(&('M->'+_cProd)) = 'N4259'
						_cAlbany:=  'A4259I'
					Case Alltrim(&('M->'+_cProd)) = 'N5056'
						_cAlbany:=  'A5056'
					Case Alltrim(&('M->'+_cProd)) = 'N5059'
						_cAlbany:=  'A5059'
					Case Alltrim(&('M->'+_cProd)) = 'N5256'
						_cAlbany:=  'A5256'
					Case Alltrim(&('M->'+_cProd)) = 'N5259'
						_cAlbany:=  'A5259'
					Case Alltrim(&('M->'+_cProd)) = 'N4556'
						_cAlbany:=  'A4556'
					Case Alltrim(&('M->'+_cProd)) = 'N4556'
						_cAlbany:=  'A4556P'
					Case Alltrim(&('M->'+_cProd)) = 'N4559'
						_cAlbany:=  'A4559'
					Case Alltrim(&('M->'+_cProd)) = 'S5556'
						_cAlbany:=  'A5556'
					Case Alltrim(&('M->'+_cProd)) = 'S5559'
						_cAlbany:=  'A5559'
					Case Alltrim(&('M->'+_cProd)) = 'S5546'
						_cAlbany:=  'A5546'
					Case Alltrim(&('M->'+_cProd)) = 'S5549'
						_cAlbany:=  'A5549'
					Case Alltrim(&('M->'+_cProd)) = 'SN4546'
						_cAlbany:=  'AN4546'
					Case Alltrim(&('M->'+_cProd)) = 'S5506'
						_cAlbany:=  'A5506'
					Case Alltrim(&('M->'+_cProd)) = 'S5509'
						_cAlbany:=  'A5509'
					EndCase
				EndIf

				If !Empty(Alltrim(_cAlbany))

					If ( Posicione("SB1",1,xFilial("SB1")+_cAlbany,"B1_MSBLQL") = "1" )
						//FR - Flávia Rocha - Sigamat Consultoria - 29/03/2022 - alteração para adequar qdo chamada vier do Rest das Cotações STCRM003
						If !lRest
							MsgAlert("Produto Bloqueado p/ Este Cliente e o produto a ser alterado (" + Alltrim(_cAlbany) + ") está bloqueado para uso")
						Else 
							cMsgRet := "Produto: " +  Alltrim(&('M->'+_cProd)) + " Bloqueado p/ Este Cliente e o produto a ser alterado (" + Alltrim(_cAlbany) + ") bloqueado para uso" 
						Endif
						//FR - Flávia Rocha - Sigamat Consultoria - 29/03/2022 - alteração para adequar qdo chamada vier do Rest das Cotações STCRM003
						_cAlbany := ""
						Return(.F.)
					EndIf

					_nEstAlbany := u_versaldo(_cAlbany)
				
					If _nEstAlbany > 0

						If SA1->A1_XNEWCON = 'B' .Or. Empty(Alltrim(SA1->A1_XNEWCON))
							//FR - Flávia Rocha - Sigamat Consultoria - 29/03/2022 - alteração para adequar qdo chamada vier do Rest das Cotações STCRM003
							If !lRest
								If	MsgYesNo("Produto Bloqueado p/ Este Cliente"+CR+CR+;
										"Devemos Utilizar o Produto: "+_cAlbany+" - "+Alltrim(Posicione("SB1",1,xFilial('SB1')+_cAlbany,"B1_DESC"))+" ?")
									DbSelectArea("SB1")
									SB1->(dbSetOrder(1))
									SB1->(DbSeek(xFilial("SA1")+ _cAlbany))
									aCols[n,_nPosProd]  := _cAlbany
									&("M->"+_cProd)     := _cAlbany
									aCols[n,_nPosDescri]:= SB1->B1_DESC
									If !(_Lmomat)
										If ( Type("l410Auto") == "U" .or. ! l410Auto)
											If !( oGetDad == Nil )
												oDlg                      := GetWndDefault()
												oDlg := oGetDad:oWnd
											EndIf
										EndIf
										
										If ( Type("l410Auto") == "U" .OR. !l410Auto )
											oGetDad:oBrowse:Refresh()
										EndIf
										
									Else
										Tk273FRefresh()
										Tk273TlvImp()
									EndIf
								Else
									lRet:= .F.
								EndIf
							Else 
								lRet := .T.	
							Endif
							//FR - Flávia Rocha - Sigamat Consultoria - 29/03/2022 - alteração para adequar qdo chamada vier do Rest das Cotações STCRM003 
						EndIf
					Else
						If !lRest
							MsgAlert("Produto Bloqueado p/ Este Cliente e o produto a ser alterado (" + Alltrim(_cAlbany) + ") está sem saldo")
						Else
							cMsgRet := "Produto: " + Alltrim(&('M->'+_cProd)) + " Bloqueado p/ Este Cliente e o produto a ser alterado (" + Alltrim(_cAlbany) + ") sem saldo" 
						Endif 
						_cAlbany := ""
						lRet := .F.
					EndIf
				EndIf
			EndIf
		EndIf

	EndIf

Return(lRet)
/*====================================================================================\
|Programa  | STSTEVAL         | Autor | GIOVANI.ZAGO             | Data | 30/06/2013  |
|=====================================================================================|
|Descrição |  STSTEVAL                                                                |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STSTEVAL                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STSTEVAL()
	*-----------------------------*
	Private lRet          := .T.
	Private _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Private _cProd		  := IIF(  _Lmomat,"UB_PRODUTO" ,"C6_PRODUTO"	)
	Private _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == _cProd   })
	Private _nPosDescri	  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_DESCRI" ,"C6_DESCRI"	)   })
	Private _cCli     	  := IIF(_Lmomat ,"M->UA_CLIENTE","M->C5_CLIENTE")
	Private _cLojaCli     := IIF(_Lmomat ,"M->UA_LOJA"	 ,"M->C5_LOJACLI")
	Private _cStella      := IIF(_Lmomat ,"M->UA_XSTELLA"	 ,"M->C5_XSTELLA")
	Private _cGrpStella	  := GetMv("ST_QUANV01",,'105')
	/* giovani zago desabilitei por conta de solicitação da janaina paixao 22/06/17 vai abrir chamado.
	If   ( Type("l410Auto") == "U" .OR. !l410Auto )
		If Substr(Alltrim( &_cStella ),1,1) = '1'
			DbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			If SA1->(DbSeek(xFilial("SA1")+ &_cCli + &_cLojaCli))
				If SA1->A1_GRPVEN <> 'ST' .And. SA1->A1_GRPVEN <> 'SC'
					
					For i:=1 To Len(Acols)
						
						DbSelectArea("SB1")
						SB1->(dbSetOrder(1))
						If		SB1->(DbSeek(xFilial("SB1")+aCols[i][_nPosProd] ))
							If !(Alltrim(SB1->B1_GRUPO) $ _cGrpStella)
								lRet := .F.
							EndIf
						EndIf
					Next i
					
					
					If !lRet
						MsgInfo("Para Versao 2, P.V. Deve Conter Apenas Linha Stella...!!!")
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	*/
Return(lRet)

/*====================================================================================\
|Programa  | STLINCOUNT       | Autor | GIOVANI.ZAGO             | Data | 30/06/2013  |
|=====================================================================================|
|Descrição |  STLINCOUNT                                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STLINCOUNT                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*-----------------------------*
Static Function STLINCOUNT()
	*-----------------------------*
	Local   lRetLi        := .T.
	Local _nLinCol	      := GetMv("ST_LINCOUN",,190)
	Local _nLi            := 0
	Local i:= 1
	Local lRestCRM		  := .F.

	//FR - 05/07/2022 - Correção problema de Erro de referência de produto alternativo no cad. cotações via integração CRM
	//na integração não é possível fazer chamada de tela dialog u_STUZZLTEL abaixo que oferece produto alternativo
	If IsInCallStack("U_STCRM08A") .OR. IsInCallStack("U_STCRM08A")
		lRestCRM := .T.
		
		CONOUT("<<< STCRM08A STLINCOUNT CONTADOR LINHAS DE ORCAMENTO ITEM >>> " + Alltrim(Str(n)) )

	Endif 	 

	If   ( Type("l410Auto") == "U" .OR. !l410Auto )
		
		For i:=1 To Len(Acols)
			If	!aCols[i,Len(aCols[i])]
				_nLi ++
			EndIf
		Next i

		If SA1->(!Eof())
			
			DO CASE
			CASE SA1->A1_XMAXLIN > 0
				_nLinCol	:= SA1->A1_XMAXLIN //Chamado 001150
			ENDCASE
			
			If _nLi > _nLinCol
				If !lRestCRM
					lRetLi := .F.
					MsgInfo("O limite máximo de itens para esse cliente é: "+CVALTOCHAR(_nLinCol)+". Inclua um novo Orçamento/Pedido!!!!!")
				Else 
					CONOUT("<<< STCADCOT -> O limite maximo de itens para esse cliente eh: "+CVALTOCHAR(_nLinCol)+".")
				Endif 
			EndIf
			
		EndIf
		
	EndIf
	
Return(lRetLi)
