
#include 'Protheus.ch'
#include 'RwMake.ch'
#DEFINE CR    chr(13)+chr(10)
/*====================================================================================\
|Programa  | STZZLGAT          | Autor | GIOVANI.ZAGO             | Data | 02/04/2014 |
|=====================================================================================|
|Descrição | STZZLGAT                                                                 |
|          | Gatilho  -  Produto Relacionado									      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STZZLGAT                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STZZLGAT()
	*-----------------------------*
	Local _lPv		    := IsInCallSteck("U_STFAT15") //rotina de avalição de regras
	Local aArea         := GetArea()
	Local lRet          := .F.
	Local _Lmomat       := IsInCallStack("TMKA271") .Or. IsInCallStack("TMKA380") .or. IsInCallStack("U_STFSVE46")
	Local lRestCRM      := .F.
	Local nSaldo		:= 0 
	Private  _nPosProd  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_PRODUTO"    ,"C6_PRODUTO"  	)   })
	Private _nPosMemo   := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XPRDM"      ,"C6_XPRDM"  	)   })
	Private _nPosQuan   := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_QUANT"      ,"C6_QTDVEN"  	)   })

	//FR - 05/07/2022 - Flávia Rocha - Sigamat Consultoria - Tratativa qdo efetua chamada da verificação de saldos via api STCRM003
	Default cMsgRet     := "" 

	//FR - 05/07/2022 - Correção problema de Erro de referência de produto alternativo no cad. cotações via integração CRM
	//na integração não é possível fazer chamada de tela dialog u_STUZZLTEL abaixo que oferece produto alternativo
	If IsInCallStack("U_STCRM08A")
		lRestCRM := .T.	
		CONOUT("<<< STCCRM008 GATILHO STZZLGAT ITEM >>> " + Alltrim(Str(n)) + " >>> PRODUTO : " + aCols[n,_nPosProd] + ">>> " )
	Endif 	 
	//FR - 05/07/2022 - Correção problema de Erro de referência de produto alternativo no cad. cotações via integração CRM
	//na integração não é possível fazer chamada de tela dialog u_STUZZLTEL abaixo que oferece produto alternativo
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )  .And.  !_lPv


		If substr(aCols[n,_nPosProd] ,1,4) = 'SDZD' .And. SA1->A1_EST = 'RS'
			RestArea(aArea)
			Return (lRet)
		EndIf

		//If u_versaldo(aCols[n,_nPosProd])  < aCols[n,_nPosQuan]
		//FR - 05/07/2022 - Correção problema de Erro de referência de produto alternativo no cad. cotações via integração CRM
		//na integração não é possível fazer chamada de tela dialog u_STUZZLTEL abaixo que oferece produto alternativo
		If !lRestCRM
		
			DbSelectArea('ZZL')
			ZZL->(DbSetOrder(1))
			If ZZL->(DbSeek(xFilial('ZZL') + aCols[n,_nPosProd] ))
				u_STUZZLTEL(aCols[n,_nPosProd])
			EndIf

		EndIf
		//FR - 05/07/2022 - Correção problema de Erro de referência de produto alternativo no cad. cotações via integração CRM
		//na integração não é possível fazer chamada de tela dialog u_STUZZLTEL abaixo que oferece produto alternativo
		
		//If !IsBlind()
			nSaldo := u_versaldo(aCols[n,_nPosProd])
			//If u_versaldo(aCols[n,_nPosProd])<=0 .And. AllTrim(SB1->B1_GRUPO) $ "351/117/118/035"
			If nSaldo <=0 .And. AllTrim(SB1->B1_GRUPO) $ "351/117/118/035"
				If !lRestCRM
					MsgAlert("Atenção, produto não disponível no estoque!")
				Else 
					//FR - 05/07/2022 - Flávia Rocha - Sigamat Consultoria - Tratativa qdo efetua chamada da verificação de saldos via api STCRM003
					cMsgRet := "Atenção, produto: " + aCols[n,_nPosProd] + "NAO DISPONIVEL NO ESTOQUE!"
					CONOUT("<<< STCADCOT VERSALDO ITEM >>> " + Altrim(Str(n)) + " >>> PRODUTO SEM SALDO ESTOQUE: " + aCols[n,_nPosProd] + ">>> " )
				Endif 
			EndIf
		
		//EndIf

	EndIf
	RestArea(aArea)
Return (lRet)

/*====================================================================================\
|Programa  | STUZZLTEL      | Autor | GIOVANI.ZAGO               | Data | 01/04/2014  |
|=====================================================================================|
|Descrição | Manutenção do Menu										                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STUZZLTEL                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function STUZZLTEL( _cProd )
	*---------------------------------------------------*


	Local oDlgEmail
	Local _nVal       :=  0
	Local lSaida      := .F.
	Local nOpca       :=  0
	Local aHeader0    := {}
	Local aCols0      := {}
	Local nCntFor     := 0
	Local nSaldo      := 0
	Local _lCont		:= .T.

	aTam := TamSX3("ZZL_COD2")
	Aadd(aHeader0,{"Produto"   , "Produto"   , PesqPict('ZZL',"ZZL_COD2", aTam[1]),    15  ,     0 ,""  ,   ,"C" ,"",""})
	aTam := TamSX3("ZZL_OBS")
	Aadd(aHeader0,{"OBS"   , "OBS"   , PesqPict('ZZL',"ZZL_OBS", aTam[1]),    50  ,     0 ,""  ,   ,"C" ,"",""})
	aTam := TamSX3("C6_QTDVEN")
	Aadd(aHeader0,{"Quantidade"   , "Quantidade"   , PesqPict('SC6',"C6_QTDVEN", aTam[1]) , aTam[1], aTam[2], '', "", 'N', '', ''})

	DbSelectArea('ZZL')
	ZZL->(DbSetOrder(1))
	If ZZL->(DbSeek(xFilial('ZZL') +_cProd ))
		aCols[n,_nPosMemo]:=  'Produtos Alternativos'+CR+CR
		While ZZL->(!Eof())  .And. ZZL->ZZL_COD = _cProd

			nSaldo      := u_versaldo(ZZL->ZZL_COD2)

			//>>Chamado 005336 - Everon Santana - Valida se pode exibir saldo zero
			If nSaldo = 0

				If ZZL->ZZL_EST $ "2"
					_lCont := .F.
				EndIf

			EndIF

			If _lCont
			//<<
			AADD(aCols0,Array(Len(aHeader0) + 1))

			For nCntFor := 1 To Len(aHeader0)
				If  ( alltrim(aHeader0[nCntFor][2]) =  "Produto")
					aCols0[Len(aCols0)][nCntFor] := ZZL->ZZL_COD2
				ElseIf  ( alltrim(aHeader0[nCntFor][2]) =  "OBS")
					aCols0[Len(aCols0)][nCntFor] := ZZL->ZZL_OBS
				ElseIf  ( alltrim(aHeader0[nCntFor][2]) =  "Quantidade")
					aCols0[Len(aCols0)][nCntFor] := nSaldo
				EndIf


			Next nCntFor
			aCols0[Len(aCols0)][Len(aHeader0)+1] := .F.
			//EndIf
			aCols[n,_nPosMemo] +=   ZZL->ZZL_COD2+' - '+ZZL->ZZL_OBS+CR
			EndIf
			
			_lCont := .T. 
			
			ZZL->(DbSkip())
		End

		nOpcao := 0
		If Len(aCols0) > 0 .And. !IsBlind()
			//>>Chamado 005336 - Everson Santana - 23.04.18

			//MsgInfo("Sr. Vendedor , dispomos de um produto alternativo em nosso estoque para esta oferta, poderia tentar oferecer e concretizar a venda com esta opção, inclusive ela está mais econômica que a oferta original... a validade desta campanha é até o termino do estoque do produto alternativo.","Steck ")
			cTexto := "Sr. Vendedor , dispomos de um produto alternativo em nosso estoque para esta oferta, poderia tentar oferecer e concretizar a venda com esta opção, inclusive ela está mais econômica que a oferta original... a validade desta campanha é até o termino do estoque do produto alternativo."
			//<<

			DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Produtos Alternativos") From  1,0 To 180,550 Pixel OF oMainWnd

			@ 005,005 SAY cTexto SIZE 255,107 OF oDlgEmail PIXEL

			MSNewGetDados():New (035,001,79,279 , 0 , , , , , , , , , ,, aHeader0, aCols0)

			ACTIVATE MSDIALOG oDlgEmail CENTERED

		EndIf
	EndIf
Return()
