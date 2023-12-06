#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STTESTEL         | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  tela da tes						                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTESTEL                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STTESTEL()
	*-----------------------------*
	Local lSaida        := .f.
	Local nOpcao        := 0
	Local nOpcaofor     := 0
	Local _Lmomat   	:= IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46") 
	Local _nPosTes  	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == IIF(  _Lmomat,"UB_TES"     ,"C6_TES"  	)   })
	Local _nPosOper 	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == IIF(  _Lmomat ,"UB_OPER"    ,"C6_OPER"  	)   })
	Local _nPosProd 	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == IIF(  _Lmomat ,"UB_PRODUTO" ,"C6_PRODUTO"	)   })
	Local _nPosCfo   	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == IIF(  _Lmomat ,"UB_CF"      ,"C6_CF"     	)   })
	Local _lRet     	:= .F.
	//Chamado 001423 abre
	//Local _cTipoCF   	:= IIF(_Lmomat ,'C',IIf(M->C5_TIPO $ 'DB',"F","C"))
	//Local _cProg     	:= IIF(_Lmomat ,"TK273"        ,"MT100")
	//Local _cLoja    	:= IIF(_Lmomat ,"M->UA_LOJA"   ,"M->C5_LOJACLI")
	//Local _cCliente 	:= IIF(_Lmomat ,"M->UA_CLIENTE","M->C5_CLIENTE")
	//Local _cTipoCli 	:= IIF(_Lmomat ,"M->UA_XTIPO"  ,"M->C5_TIPOCLI")
	//Local _cZconsum 	:= IIF(_Lmomat ,"M->UA_ZCONSUM","M->C5_ZCONSUM")
	Local _lUnicom      := IsInCallStack("U_STFTA001") 
	Local _cTipoCF   	:= IIF( _lUnicom, "C"            , IIF(_Lmomat ,'C',IIf(M->C5_TIPO $ 'DB',"F","C")))
	Local _cProg     	:= IIF(_Lmomat ,"TK273"          ,"MT100")
	Local _cLoja    	:= IIF( _lUnicom, "M->PP7_LOJA"  , IIF(_Lmomat ,"M->UA_LOJA"   ,"M->C5_LOJACLI"))
	Local _cCliente 	:= IIF( _lUnicom, "M->PP7_CLIENT", IIF(_Lmomat ,"M->UA_CLIENTE","M->C5_CLIENTE"))
	Local _cTipoCli 	:= IIF( _lUnicom, "M->PP7_ZTIPOC", IIF(_Lmomat ,"M->UA_XTIPO"  ,"M->C5_TIPOCLI"))
	Local _cZconsum 	:= IIF( _lUnicom, "M->PP7_ZCONSU", IIF(_Lmomat ,"M->UA_ZCONSUM","M->C5_ZCONSUM"))
	//Chamado 001423 fecha
	Local _cTes     	:= ''
	Local _cEst         := Getmv("MV_ESTADO",,'SP')
	Local _aDadosCfo    := {}
	Local _cCliEst      := If(_cTipoCF == "C", "SA1->A1_EST"     , "SA2->A2_EST"    )
	Local _cTipofor   := '1'
	Local _cCliContrib  := If(_cTipoCF == "C", "SA1->A1_CONTRIB" , "_cTipofor"      )
	Local _cCliInscr    := If(_cTipoCF == "C", "SA1->A1_INSCR"   , "SA2->A2_INSCR"  )
	Local _cCliTip      := If(_cTipoCF == "C", "SA1->A1_TIPO"    , ""               )
	Local _cCliGru      := If(_cTipoCF == "C", "SA1->A1_ATIVIDA" , ""               )
	Local _cCli008      := If(_cTipoCF == "C", "SA1->A1_SATIV1"  , ""               )
	Local _cCliSufra    := If(_cTipoCF == "C", "SA1->A1_SUFRAMA" , ""               )
	Local _cCliMun      := If(_cTipoCF == "C", "SA1->A1_COD_MUN" , "SA2->A2_COD_MUN")
	Local _cxCliContr   := If(_cTipoCF == "C", "SA1->A1_GRPTRIB" , "SA2->A2_GRPTRIB")
	Local oDxlg
	Local aItems 		:= {"1 - Industrialização","2 - Consumo Próprio"}
	Local aTipo 		:= {"1 - Consumidor Final","2 - Revendedor","3 - Solidário"}
	Local cItem 		:= space(20)
	Local _lEst         :=.T.
	Local _lRest		:= .F.
	//--------------------------------------------------------------------------------//
	//FR - 21/03/2023 - Flávia Rocha - Sigamat Consultoria - PROJETO MERCADO LIVRE
	//--------------------------------------------------------------------------------//
	Local _cCliMELI     := GetNewPar("ST_CLIMELI" , "102917")  //cliente para envio de pedido remessa MERCADO LIVRE

	If Type("_cConsumo")=="C"
		//&_cZconsum := _cConsumo
		_lRest     := .T.
		_cTipoCF   := "C"		//FR - 02/05/2022 - Projeto Integração CRM - esta variável é necessária para compor o TES Inteligente
	Else
		If IsBlind() .And. _Lmomat .And. !IsInCallStack("U_STFAT370") .And. !IsInCallStack("WSEXECUTE")
			Return(&_cCliente)
		EndIf
	EndIf

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		If Select("SA1")==0
			dbSelectArea("SA1")
		EndIf
		SA1->(dbSetOrder(1))
		If Select("SA2")==0
			dbSelectArea("SA2")
		EndIf
		SA2->(dbSetOrder(1))
		If 	SA1->(DbSeek(xFilial("SA1")+&_cCliente+&_cLoja))  .Or. 	SA2->(DbSeek(xFilial("SA2")+&_cCliente+&_cLoja))

			//If 'AM' $ &_cCliEst
			//	_lEst:= (Empty(ALLTRIM( &_cCliSufra)))  .and. !(alltrim(&_cCliMun) $ ('03569/02603/03536/04062'))
			//EndIf

			If !IsBlind()
				If Alltrim(&_cCli008) = '000008'
					MsgYesno("Cliente Possui REB ?......Caso Sim utilize a operação 78...!!!!!!!")
				EndIf
			EndIf

			If _cTipoCF == "F"

				If !IsInCallStack("U_STFAT370")
					Do While !lSaida
						nOpcaofor := 0

						Define msDialog oDxlg Title "Informe o Tipo do Fornecedor" From 10,10 TO 150,200 Pixel

						@ 010,010 COMBOBOX cItem ITEMS aTipo SIZE 80,80

						DEFINE SBUTTON FROM 030,030 TYPE 1 ACTION IF(!empty(alltrim(cItem)),(lSaida:=.T.,nOpcaofor:=1,oDxlg:End()),msgInfo("Tipo de Fornecedor não preenchido","Atenção")) ENABLE OF oDxlg

						Activate dialog oDxlg centered

					EndDo
				Else
					Do Case
						Case AllTrim(SA1->A1_TIPO)=="F"
						cItem := "1"
						Case AllTrim(SA1->A1_TIPO)=="R"
						cItem := "2"
						Case AllTrim(SA1->A1_TIPO)=="S"
						cItem := "3"
					EndCase
					//cItem := "2"
				EndIf

			Endif

			If nOpcaofor == 1
				If	Substr(cItem,1,1) = '1'
					&_cTipoCli:= 'F'
				ElseIf	Substr(cItem,1,1) = '2'
					&_cTipoCli:= 'R'
				ElseIf	Substr(cItem,1,1) = '3'
					&_cTipoCli:= 'S'
				Endif
				If Substr(cItem,1,1) $ ('1/2')
					&_cZconsum := Substr(cItem,1,1)
				Endif
				If M->C5_TIPO=="B" .And. Substr(cItem,1,1)=="1"
					&_cZconsum := "2"
				EndIf
			EndIf

			//--------------------------------------------------------------------------------//
			//FR - 21/03/2023 - Flávia Rocha - Sigamat Consultoria - PROJETO MERCADO LIVRE
			//--------------------------------------------------------------------------------//	
			If _cTipoCF == "C" .and. Alltrim(&_cCliente) != Alltrim(_cCliMELI)  //se tipo == "CLIENTE" e cliente não for MERCADO LIVRE

				IF U_TELACONSUMO(SA1->A1_COD,SA1->A1_LOJA)=='S'
				
				//If (&_cCliTip $ 'R' .And. &_cCliContrib = '1'  .And. !(alltrim(&_cCliGru) $ 'D1/D2/D3/R1/R2/R3/R5' ) .And. (!Empty(ALLTRIM(&_cCliInscr)) .Or. 'ISENT' $ Upper(ALLTRIM(&_cCliInscr)))) .Or. ;
				//(&_cCliTip $ 'F' .And. &_cCliContrib = '1'  .And. (!Empty(ALLTRIM(&_cCliInscr)) .Or. 'ISENT' $ Upper(ALLTRIM(&_cCliInscr))) .and. _lEst );
                //.or. ((&_cCliTip $ 'S' .And. &_cCliContrib = '1'  .And. (!Empty(ALLTRIM(&_cCliInscr)) .Or. 'ISENT' $ Upper(ALLTRIM(&_cCliInscr))) .and. _lEst ) .and.;
				//      (cFilAnt=='02' .AND. SA1->A1_COD=='012047' .AND. SA1->A1_LOJA=='09'))    // Cliente Adicionado 01/07/2021 - Ticket: 20210108000420 - Valdemir Rabelo

					If !_lRest
						If !IsInCallStack("U_STFAT370") .And. !IsInCallStack("WSEXECUTE") .And. !IsInCallStack("U_STFAT373") .And.;
						!IsInCallStack("U_RSTFAT08") 
							Do While !lSaida
								nOpcao := 0

								Define msDialog oDxlg Title "Destinação do Produto" From 10,10 TO 150,200 Pixel

								@ 010,010 COMBOBOX cItem ITEMS aItems SIZE 80,80

								DEFINE SBUTTON FROM 030,030 TYPE 1 ACTION IF(!empty(alltrim(cItem)),(lSaida:=.T.,nOpcao:=1,oDxlg:End()),msgInfo("Tipo de Consumo não preenchido","Atenção")) ENABLE OF oDxlg

								Activate dialog oDxlg centered

							EndDo
						Else
							cItem := SA1->A1_XDESTP
							nOpcao := 1
						EndIf
					Else
						cItem := _cConsumo //&_cZconsum
						nOpcao := 1
					EndIf

					If nOpcao == 1
						If	&_cCliTip $ 'R' .and.   substr(cItem,1,1) = '1'    //regra de 1 a 12
							&_cTipoCli:= 'R'
						ElseIf	(&_cCliTip $ 'R' .and.   substr(cItem,1,1) = '2') .or. ;   //regra de 13 a 24
						        (&_cCliTip $ 'S' .and.  substr(cItem,1,1) = '2' .and. cFilAnt=='02' .AND. SA1->A1_COD=='012047' .AND. SA1->A1_LOJA=='09')  // Adicionado 01/07/2021 - Ticket: 20210108000420 - Valdemir Rabelo
							&_cTipoCli:= 'F'
						ElseIf	(&_cCliTip $ 'F' .and.  substr(cItem,1,1) = '1') .or. ;          //regra de 37 a 48
						        (&_cCliTip $ 'S' .and.  substr(cItem,1,1) = '1' .and. cFilAnt=='02' .AND. SA1->A1_COD=='012047' .AND. SA1->A1_LOJA=='09')  // Adicionado 01/07/2021 - Ticket: 20210108000420 - Valdemir Rabelo
							&_cTipoCli:= 'R'
							//ElseIf	&_cCliTip $ 'F' .and.  substr(cItem,1,1) = '2' .And.   &_cCliEst $ 'MG/RS/SC/BA'//regra de 49 a 54
						ElseIf	&_cCliTip $ 'F' .and.  substr(cItem,1,1) = '2' .And.   &_cCliEst $ 'RS/SC/BA/AL/AP/DF/ES/GO/RJ/SE'//regra de 49 a 54 - chamado 002456
							&_cTipoCli:= 'S'
						ElseIf	&_cCliTip $ 'F' .and.  substr(cItem,1,1) = '2' .And.   &_cCliEst $ 'MG/PR/PE'//regra de 49 a 54 - chamado 002456
							&_cTipoCli:= 'F'
							//ElseIf	&_cCliTip $ 'F' .and.  substr(cItem,1,1) = '2' .And.  !( &_cCliEst $ 'MG/RS/SC/BA')//regra de 67 a 72
						ElseIf	&_cCliTip $ 'F' .and.  substr(cItem,1,1) = '2' .And.  !( &_cCliEst $ 'MG/RS/SC/BA/AL/AP/DF/ES/GO/PE/PR/RJ/SE')//regra de 67 a 72 - chamado 002456
							&_cTipoCli:= 'F'
						EndIf

						&_cZconsum := substr(cItem,1,1)

						If  _Lmomat
							U_STGAP18() //ATUALIZA MAFIS COM O TIPO DO CLIENTE
						EndIf
					EndIf
					//Chamado 001423 abre
				ElseIf _lUnicom
					&_cTipoCli:=&_cCliTip
					//Chamado 001423 fecha
				Else
					If Type("_cConsumo")=="C"
						&_cZconsum := ""
					EndIf
				EndIf
			Elseif Alltrim(&_cCliente) == Alltrim(_cCliMELI)
				//Local aItems 		:= {"1 - Industrialização","2 - Consumo Próprio"}
				&_cZconsum := "2" 
				//FR - 21/03/2023 - Flávia Rocha - Sigamat Consultoria - Orientado por Elisângela que a tela não pode aparecer para pedido remessa
				//o consumo nesse caso deve ser fixado como 2-Próprio
			Endif
		EndIf

		If _cTipoCF == "C"
			If (&_cCliTip $ 'R' .And. &_cCliContrib = '1'  .And. (alltrim(&_cCliGru) $ 'D1/D2/D3/R1/R2/R3/R5' ) .And. (!Empty(ALLTRIM(&_cCliInscr)) .Or. 'ISENT' $ Upper(ALLTRIM(&_cCliInscr))))
				&_cZconsum := '1'
			EndIf
			//	If !_lEst
			//		&_cZconsum := '2'
			//	EndIf
		Endif

	EndIf
Return(&_cCliente)
