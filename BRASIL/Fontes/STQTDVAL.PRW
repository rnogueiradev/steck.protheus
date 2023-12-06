#include 'Protheus.ch'
#include 'RwMake.ch'
#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | STQTDVAL         | Autor | GIOVANI.ZAGO             | Data | 08/07/2014  |
|=====================================================================================|
|Descrição |  STQTDVAL     Valida qtd minima de venda                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STQTDVAL                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STQTDVAL()
	*-----------------------------*
	Private _lRet         := .T.
	Private _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Private _cVerStella	  := IIF(  _Lmomat,"M->UA_XSTELLA" ,"M->C5_XSTELLA"	)
	Private _cQuant		  := IIF(  _Lmomat,"UB_QUANT" ,"C6_QTDVEN"	)
	Private _nPosQuant    := aScan(aHeader, { |x| Alltrim(x[2]) == _cQuant   })
	Private _cOper		  := IIF(  _Lmomat,"UB_OPER" ,"C6_OPER"	)
	Private _nPosOper     := aScan(aHeader, { |x| Alltrim(x[2]) == _cOper   })
	Private _cProd		  := IIF(  _Lmomat,"UB_PRODUTO" ,"C6_PRODUTO"	)
	Private _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == _cProd    })
	Private _lAtiva		  := GetMv("ST_QUANVAL",,.F.)
	Private _nResul		  :=  0
	Private _cGrpStella	  := GetMv("ST_QUANV01",,'105')
	Private _aStell   	  := {}
	Private _nStella	  :=  0
	Private _lSC5		  := .T.
	
	/****************************************
	Ação.........: Inibir a validação da quantidade quando o pedido vier da importação e da proforma
	Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT / Flávia Rocha - SIGAMAT
	Data.........: 08/01/2022 - 13/01/2022
	Chamados.....: 20220107000555 / 20220108000590 / 20220107000524
	****************************************/
	If IsInCallStack("U_STTRANSIBL") .OR. IsInCallStack("U_MSTECK09") .OR. IsInCallStack("U_STPEDPRO")
		Return(.T.)
	EndIf
	
	//Chamado 002780 - Comentado comando que pula quando for execauto pois tem que bloquear pra todos os pedidos, inclusive EDI
	//.And. ( Type("l410Auto") == "U" .OR. !l410Auto )
	If _lAtiva .And. !(aCols[n,_nPosOper] $ GetMv('ST_QTDVAL',,'94'))
		
		If	SA1->A1_COD $ GetMv('ST_QTDVAX',,'038134/014519/092187/092887/023789')//giovani zago edi da leroy entra sem lote minimo. 24/11/16
			return(.t.)
		EndIf
		
		/* comentado pois não recebi retorno no ticket
		If "MRV" $ AllTrim(SA1->A1_NREDUZ) //Ticket 20200710004060
			Return(.T.)
		EndIf
		*/
		DbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+aCols[n,_nPosProd] ))
			If SB1->B1_XLM  > 0

				//>> Ticket 20200709003996
				If !_Lmomat 

					If M->C5_TIPO $("B#D") //>> Ticket 20200709003996 - Everson Santana - 09.07.2020 - Não validar quando o pedido utilizar fornecedor 
						_lSC5 := .F.
					EndIf

				EndIf

				If _lSC5 
				//<< Ticket 20200709003996
					If   SB1->B1_XTIPLM $ 'M'
						//002779
						
						If 		(SUBSTR(SA1->A1_GRPVEN,1,1)=="C" .And. SB1->B1_XEMBC=="S") .Or.;
								(SUBSTR(SA1->A1_GRPVEN,1,1)=="D" .And. SB1->B1_XEMBD=="S") .Or.;
								(SUBSTR(SA1->A1_GRPVEN,1,1)=="E" .And. SB1->B1_XEMBE=="S") .Or.;
								(SUBSTR(SA1->A1_GRPVEN,1,1)=="I" .And. SB1->B1_XEMBI=="S") .Or.;
								(SUBSTR(SA1->A1_GRPVEN,1,1)=="R" .And. SB1->B1_XEMBR=="S")
							
							_nResul:= (aCols[n,_nPosQuant]/SB1->B1_XLM)  - Round((aCols[n,_nPosQuant]/SB1->B1_XLM),0)

							If AllTrim(SA1->A1_GRPVEN)=="R6" //20200928008009
								_nResul := 0
							EndIf

							If _nResul <> 0
								MsgInfo("Quantidade Fora do Permitido!!!"+CR+CR+"Utilize Multiplo de: "+transform(SB1->B1_XLM,'@E 999,999.99'))
								_lRet:= .F.
								If __cUserId $ GetMv("ST_LIBMULT") .And. !(SubStr(Alltrim(SB1->B1_COD),1,2) $ GetMv("ST_QTDCAN",,"CA/CE/PA/CR"))  .And. !(SubStr(Alltrim(SB1->B1_COD),1,5) $ GetMv("ST_QTDCAN2",,"DXN10")) //20220509009765 - nao permitir liberacao de Canaletas SEB 
									//MsgInfo("Quantidade Fora do Permitido!!!"+CR+CR+"Grupo Canaleta ")
									_lRet:= .T.
								EndIf
							EndIf
							
						EndIf
						
					Else
						If aCols[n,_nPosQuant] < SB1->B1_XLM
							MsgInfo("Quantidade Inferior ao Permitido!!!"+CR+CR+"Minimo Permitido: "+transform(SB1->B1_XLM,'@E 999,999.99'))
							AutoGrLog("Quantidade Inferior ao Permitido do produto "+AllTrim(SB1->B1_COD)+CR+CR+"Minimo Permitido: "+transform(SB1->B1_XLM,'@E 999,999.99'))
							_lRet:= .F.
						EndIf
						If __cUserId $ GetMv("ST_LIBMULT")
							_lRet:= .T.
						EndIf
					EndIf
				EndIf
			EndIf //<< Ticket 20200709003996
			
			If Alltrim(SB1->B1_GRUPO) $ _cGrpStella  .And. &_cVerStella = '1'
				_nStella:= U_STSBFSTELLA (SB1->B1_COD, Substr(&_cVerStella,1,1) )
				If aCols[n,_nPosQuant]  > _nStella
					_lRet:= .F.
					MsgInfo("Quantidade Indisponivel "+AllTrim(SB1->B1_COD)+"....."+CR+"Saldo: "+cValtochar(_nStella))
					AutoGrLog("Quantidade Indisponivel do produto "+AllTrim(SB1->B1_COD)+CR+"Saldo: "+cValtochar(_nStella))
				EndIf
				
			EndIf
			_nStella:=0
			If SB1->B1_XR01  = '1'
				Dbselectarea('SB2')
				SB2->(DbSetOrder(1))
				If	SB2->(DbSeek(xfilial("SB2") + SB1->B1_COD +'03'))
					
					_nStella:= 	SB2->B2_QATU - (U_STResSDC(SB2->B2_COD) + u_STSldPV(SB2->B2_COD,cFilAnt))-SB2->B2_QACLASS
						
					If aCols[n,_nPosQuant]  > _nStella
						_lRet:= .F.
						MsgInfo("Quantidade Indisponivel "+AllTrim(SB1->B1_COD)+".....(RR/O)"+CR+"Saldo: "+cValtochar(_nStella))
						AutoGrLog("Quantidade Indisponivel do produto "+AllTrim(SB1->B1_COD)+CR+"Saldo: "+cValtochar(_nStella))
					EndIf
				Else
					
					_lRet:= .F.
					MsgInfo("Quantidade Indisponivel "+AllTrim(SB1->B1_COD)+".....(RR/O)"+CR+"Saldo: "+cValtochar(_nStella))
					AutoGrLog("Quantidade Indisponivel do produto "+AllTrim(SB1->B1_COD)+CR+"Saldo: "+cValtochar(_nStella))
					
				EndIf
			EndIf
		EndIf
		
	EndIf
	
Return(_lRet)

