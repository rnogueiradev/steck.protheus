#include 'Protheus.ch' 
#include 'RwMake.ch'
#DEFINE CR    chr(13)+chr(10)
/*====================================================================================\
|Programa  | STDESALC          | Autor | GIOVANI.ZAGO             | Data | 10/12/2013 |
|=====================================================================================|
|Descrição | STDESALC                                                                 |
|          | Avalia e grava zzi  -  Alçada de desconto							      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STDESALC                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
//FR - 11/01/2022 - TICKET #20220110000672 - ERROR LOG ao salvar orçamento 
//                         Erro de tabela não existente
//                         Correção da query aplicando função RetSqlName
//-------------------------------------------------------------------------------------//
*----------------------------------*
User Function STDESALC(_lInc,_lAlt,_cTipo)
	*----------------------------------*
	Local _lOrc     	:= IsInCallStack("TMKA271") .Or. IsInCallStack("TMKA380") .or. IsInCallStack("U_STFSVE46")    //rotinas de call center
	Local _lPv		    := IsInCallStack("U_STFAT15")//rotina de avalição de regras
	Local _aArea  		:= GetArea()
	Local _aDesc        :=  {}
	Local _cOerFalRes   := GetMv("ST_OPRESFA",,"94/74")
	Local _nDesc        :=   0
	Local i        		:=   0
	Local _nTotDesc     :=   0
	Local _nTotPrcTab   :=   0 
	Local _nTotCust     :=   0
	Local _nTotMark     :=   0
	Local _cMemo        :=   ''

     //---------------------------------------------------------------------------------------//
     //FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos
     //  0,001 --> 5% - Vendedor             -> _nAlcVend
     //  5,01% --> 10% - Gerente Regional    -> _nAlcGerR
     //  10,01% --> 15% - Gerente de Canais  -> _nAlcGerC
     //  Acima de 15% --> Marketing          -> _nAlcMkt
     //---------------------------------------------------------------------------------------//
     //Parâmetro informa o teto máximo de desconto que a área pode autorizar
     Local _nAlcVend := GetNewPar("ST_ZZHVEN" , 0)  //era 5, alterado para 0 conforme solicitado por Renato em 19/10/2022
     Local _nAlcGerR := GetNewPar("ST_ZZHGERR", 10)
     Local _nAlcGerC := GetNewPar("ST_ZZHGERC", 15)
     Local _nAlcMkt  := GetNewPar("ST_ZZHMKT" , 99)
            
	Private nDesc       :=   0
	Private nRet        :=   0
	Private nPosPorDe		:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="UB_XPORDEC" })			// % desconto
	Private nPosValDe		:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="UB_XVALDES" })			// valor desconto
	Private nPosQuant		:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="UB_QUANT"   })			// Quantidade
	Private nPosCusto		:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="UB_XCUSTO"  })			// CUSTO
	Private nPosTabPr		:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="UB_XTABPRC"  })		// TabPrc
	Private nPosZLULT		:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="UB_ZLULT"  })			// Ultimo Preco .t.
	Private nPosXULTPRC		:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="UB_XULTPRC"  })		// Ultimo Preco
	Private nPosProd		:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="UB_PRODUTO"  })		// Produto
	Private nPosAdic		:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="UB_XADIC"  })	     	// ADICIONAL
	Private nPosItem		:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="UB_ITEM"  })	     	// Item
	Private nPosPrcTab		:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="UB_ZPRCTAB"  })	     	// Item
	Private _lAlcx          := GetMv("ST_VE4001",,.F. )
	Private _cMeCus         :=  ' '
	Private _lAlUp			:= .f.

	If IsInCallStack("U_STFAT621")
		If AllTrim(_cTipo)=="PED"
			_lPv 	:= .T.
			_lOrc 	:= .F.
		Else
			_lPv 	:= .F.
			_lOrc 	:= .T.
		EndIf
	EndIf

	If GetMv("ST_DEUERRO",,.F.)
		Return(.t.)
	EndIf

	If _lAlcx
        //--------------------------//
        //PEDIDO DE VENDA
        //--------------------------//
		If !_lOrc  .And.  !_lPv //so entra se for P.V.

			DbSelectArea('SC6')
			SC6->(DbGoTop())
			SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
			If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
				//If   !(SC6->C6_OPER $ _cOerFalRes)

					While SC6->(!Eof()) .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM
						If SC6->C6_XCUSTO = 0
							If Empty(Alltrim(_cMeCus))
								_cMeCus:= 'Itens Sem Custo:'+CR+SC6->C6_ITEM+CR
							EndIf
						EndIf

						If !(SC6->C6_ZLULT)
							If 	_nDesc < SC6->C6_XPORDEC
								_nDesc:= SC6->C6_XPORDEC    //Guardo a maior porcentagem de desconto
							EndIf

							_nTotDesc+=  SC6->C6_XVALDES*SC6->C6_QTDVEN

							If SC6->C6_XVALDES>0
								_nTotPrcTab += SC6->C6_ZPRCTAB*SC6->C6_QTDVEN
							EndIf

							_nTotCust+=  (SC6->C6_QTDVEN*SC6->C6_XCUSTO)
							nRet  :=   0
							nDesc :=   0
							If SC6->C6_XPORDEC > 0
								If STREG01(SC6->C6_PRODUTO,SC6->C6_CLI,SC6->C6_LOJA) > 0
									nDesc := nRet
								ElseIf STREG02(SC6->C6_PRODUTO,SC6->C6_CLI,SC6->C6_LOJA) > 0
									nDesc := nRet

								EndIf

								If nDesc > 0
									If Empty(Alltrim(_cMemo))
										_cMemo:= 'Itens Possui Desconto Adicional:'+CR+SC6->C6_ITEM+CR
									Else
										_cMemo:= _cMemo+SC6->C6_ITEM+CR
									EndIf
									SC6->(RecLock('SC6',.F.))
									SC6->C6_XADIC  := 'S'
									SC6->(MsUnlock())
									SC6->( DbCommit() )
								EndIf
							Else
								If  SC6->C6_XTABPRC > SC6->C6_XULTPRC

									If 	_nDesc <  ((SC6->C6_XULTPRC*100)/ SC6->C6_XTABPRC )
										_nDesc:=  100-((SC6->C6_XULTPRC*100)/ SC6->C6_XTABPRC )
									EndIf

									//_nTotDesc+=  SC6->C6_XTABPRC - SC6->C6_XULTPRC
									//_nTotCust+=  (SC6->C6_QTDVEN*SC6->C6_XCUSTO)
									nRet  :=   0
									nDesc :=   0
									If ((SC6->C6_XULTPRC*100)/ SC6->C6_XTABPRC ) > 0
										If STREG01(SC6->C6_PRODUTO,SC6->C6_CLI,SC6->C6_LOJA) > 0
											nDesc := nRet
										ElseIf STREG02(SC6->C6_PRODUTO,SC6->C6_CLI,SC6->C6_LOJA) > 0
											nDesc := nRet

										EndIf

										If nDesc > 0
											If Empty(Alltrim(_cMemo))
												_cMemo:= 'Itens Possui Desconto Adicional:'+CR+SC6->C6_ITEM+CR
											Else
												_cMemo:= _cMemo+SC6->C6_ITEM+CR
											EndIf
											SC6->(RecLock('SC6',.F.))
											SC6->C6_XADIC  := 'S'
											SC6->(MsUnlock())
											SC6->( DbCommit() )

										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
						SC6->(DbSkip())

					End
				//EndIf
			EndIf

			//TOTALIZO O CUSTO NO CABEÇALHO
			If SC5->C5_XMARKUP <>	(ROUND(	 (    SC5->C5_ZVALLIQ/SC5->C5_XCUSTO ) ,5))
				_lAlUp:= .T.
			EndIf

			cQry := " UPDATE "+RetSqlName("SC5")+" SC5 SET C5_XCUSTO = (SELECT SUM(C6_QTDVEN*C6_XCUSTO) FROM "+RetSqlName("SC6")+"  SC6 WHERE SC6.D_E_L_E_T_ = ' ' AND C6_NUM = C5_NUM AND C6_FILIAL = C5_FILIAL) WHERE SC5.D_E_L_E_T_ = ' ' AND C5_NUM =  '"+SC5->C5_NUM+"' AND C5_FILIAL ='"+SC5->C5_FILIAL+"'
			TcSQLExec(cQry)
			cQry := " UPDATE "+RetSqlName("SC5")+" SC5 SET C5_XMARKUP = ROUND((C5_ZVALLIQ/C5_XCUSTO ) ,5) WHERE SC5.D_E_L_E_T_ = ' ' AND   C5_NUM =  '"+SC5->C5_NUM+"' AND C5_FILIAL ='"+SC5->C5_FILIAL+"'
			TcSQLExec(cQry)
			/*
			SC5->(RecLock('SC5',.F.))
			SC5->C5_XCUSTO  := _nTotCust
			SC5->C5_XMARKUP :=	ROUND(	 (    SC5->C5_ZVALLIQ/SC5->C5_XCUSTO ) ,5)
			SC5->(MsUnlock())
			SC5->( DbCommit() )
			*/


If 	_nDesc > 0  // se tiver desconto

	If _lInc .And. !_lOrc  .And.  !_lPv //so entra se for P.V.    Inclusao
		//ENTRA AQUI SE FOR INCLUSÃO DE PEDIDO VENDA
		_cMemo:= _cMemo+_cMeCus

		//---------------------------------------------------------------------------------------//
		//FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos
		//  0,001 --> 5% - Vendedor             -> _nAlcVend
		//  5,01% --> 10% - Gerente Regional    -> _nAlcGerR
		//  10,01% --> 15% - Gerente de Canais  -> _nAlcGerC
		//  Acima de 15% --> Marketing          -> _nAlcMkt
		//---------------------------------------------------------------------------------------//
		//Parâmetro informa o teto máximo de desconto que a área pode autorizar

		If _nDesc > _nAlcVend //passou de 0,01% já bloqueia

			U_StGravZZI(.T.,_nDesc,_nTotDesc,_cMemo,_cMemo,CTOD("  /  /    "),0,_nTotPrcTab)  //Grava zzi Tabela de alçadas
			MsgInfo("Bloqueado pela Alçada Comercial")

		Endif
		//FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos

	ElseIf _lAlt .And. !_lOrc  .And.  !_lPv //so entra se for P.V. alteração
		//ENTRA AQUI SE FOR ALTERAÇÃO DE PEDIDO DE VENDA

		DbSelectArea('ZZI')
		ZZI->(DbGoTop())
		ZZI->(DbSetOrder(3))
		If ZZI->(DbSeek(xFilial("ZZI")+SC5->C5_NUM))
			//If ZZI->ZZI_BLQ = '2'   .Or. ( ZZI->ZZI_BLQ <> '2' .And. ZZI->ZZI_DESCON < _nTotDesc ) .Or. ZZI->ZZI_BLQ = '3'

			//FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos
			//If _lAlUp //comentado por FR - 24/10/2022
			//---------------------------------------------------------------------------//
			//FR - 24/10 - Sigamat - só entrava aqui se esta variável _lAlUp fosse .T. ,
			//o que causava a não gravação da alçada desconto
			//---------------------------------------------------------------------------//

			If _nDesc > _nAlcVend //até 5% não bloqueia

				ZZI->(RecLock('ZZI',.F.))
				ZZI->(DbDelete())
				ZZI->(MsUnlock())
				ZZI->( DbCommit() )
				_cMemo:= _cMemo+_cMeCus
				U_StGravZZI(.T.,_nDesc,_nTotDesc,_cMemo,,,,_nTotPrcTab)	//Grava zzi Tabela de alçadas
				MsgInfo("Bloqueado pela Alçada Comercial")
			EndIf
			//FR - 18/10/2022 - Sigamat - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos
			//EndIf
		Else

			//------------------------------------------------------------------------//
			//FR - 24/10/2022 - NÃO ESTAVA GRAVANDO ZZI - MESMO COM DESCONTO LANÇADO
			//SE NÃO ENCONTRAR NA ZZI NO DBSEEK ACIMA, CRIA CONFORME BLOCO ABAIXO:
			//------------------------------------------------------------------------//
			//IF !ZZI->(DbSeek(xFilial("ZZI") + SC5->C5_NUM))
			If _nDesc > _nAlcVend //até 5% não bloqueia
				U_StGravZZI(.T.,_nDesc,_nTotDesc,_cMemo,_cMemo,CTOD("  /  /    "),0,_nTotPrcTab)
				MsgInfo("Bloqueado pela Alçada Comercial")
			Endif
			//ENDIF
			//FR - 24/10/2022 - Sigamat - comentado por Flávia Rocha - estava deletando a alçada indevidamente
						/*
						DbSelectArea('ZZI')
						ZZI->(DbGoTop())
						ZZI->(DbSetOrder(3))
						If ZZI->(DbSeek(xFilial("ZZI")+SC5->C5_ZORCAME))
							//If ZZI->ZZI_BLQ = '2'   .Or. ( ZZI->ZZI_BLQ <> '2' .And. ZZI->ZZI_DESCON < _nTotDesc ) .Or. ZZI->ZZI_BLQ = '3'
							If 	_lAlUp

                                //FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos
                                If _nDesc > _nAlcVend //até 5% não bloqueia

                                    ZZI->(RecLock('ZZI',.F.))
                                    ZZI->(DbDelete())
                                    ZZI->(MsUnlock())
                                    ZZI->( DbCommit() )
                                    _cMemo:= _cMemo+_cMeCus
                                    U_StGravZZI(.T.,_nDesc,_nTotDesc,_cMemo)//Grava zzi Tabela de alçadas
                                    MsgInfo("Bloqueado pela Alçada Comercial")
								EndIf
                                 //FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos

							EndIf
						EndIf
						*/
			//FR - 24/10/2022 - Sigamat - Comentado por Flávia Rocha - estava deletando a alçada indevidamente
		EndIf
	EndIf

ElseIf  _nDesc = 0  // sem desconto
	DbSelectArea('ZZI')
	ZZI->(DbGoTop())
	ZZI->(DbSetOrder(3))
	If ZZI->(DbSeek(xFilial("ZZI")+SC5->C5_NUM))

		ZZI->(RecLock('ZZI',.F.))
		ZZI->(DbDelete())
		ZZI->(MsUnlock())
		ZZI->( DbCommit() )
		_cMemo:= _cMemo+_cMeCus
		U_StGravZZI(.T.,_nDesc,_nTotDesc,_cMemo,,,,_nTotPrcTab)	//Grava zzi Tabela de alçadas

	EndIf
EndIf
//--------------------------//
//ORÇAMENTO
//--------------------------//
ElseIf _lOrc

	If IsInCallStack("U_STFAT621")

		DbSelectArea('SUB')
		SUB->(DbSetOrder(1))
		If SUB->(DbSeek(xFilial("SUB")+SUA->UA_NUM))
			While SUB->(!Eof()) .and. SUB->UB_FILIAL+SUB->UB_NUM == xFilial("SUB")+SUA->UA_NUM

				If 	_nDesc < SUB->UB_XPORDEC
					_nDesc:= SUB->UB_XPORDEC      //Guardo a maior porcentagem de desconto
				EndIf

				_nTotDesc+=  SUB->UB_XVALDES*SUB->UB_QUANT
				
				If SUB->UB_XVALDES>0
					_nTotPrcTab += SUB->UB_ZPRCTAB*SUB->UB_QUANT
				EndIf

				_nTotCust+=  (SUB->UB_QUANT * SUB->UB_XCUSTO)
				nRet  :=   0
				nDesc :=   0
				If SUB->UB_XVALDES > 0
					If STREG01(SUB->UB_PRODUTO,SUA->UA_CLIENTE,SUA->UA_LOJA) > 0
						nDesc := nRet
					ElseIf STREG02(SUB->UB_PRODUTO,SUA->UA_CLIENTE,SUA->UA_LOJA) > 0
						nDesc := nRet

					EndIf

					If nDesc > 0
						If Empty(Alltrim(_cMemo))
							_cMemo:= 'Itens Possui Desconto Adicional:'+CR+SUB->UB_ITEM +CR
						Else
							_cMemo:= _cMemo+SUB->UB_ITEM+CR
						EndIf

						//aCols[i][nPosAdic]	   := 'S'
					EndIf
				EndIf

				SUB->(DbSkip())
			EndDo
		EndIf

	Else

		//------------------------------------------------//
		//LOOP DE LEITURA DO ACOLS DE ITENS DO ORÇAMENTO
		//------------------------------------------------//
		For i:=1 To Len(Acols)
			If aCols[i][nPosCusto]= 0
				If Empty(Alltrim(_cMeCus))
					_cMeCus:= 'Itens Sem Custo:'+CR+aCols[i][nPosItem]+CR
				EndIf
			EndIf
			If !aCols[i,Len(aHeader)+1]

				If !(aCols[i][nPosZLULT] )

					If 	_nDesc < aCols[i][nPosPorDe]
						_nDesc:= aCols[i][nPosPorDe]      //Guardo a maior porcentagem de desconto
					EndIf

					_nTotDesc+=  aCols[i][nPosValDe]*aCols[i][nPosQuant]

					If aCols[i][nPosValDe]>0
						_nTotPrcTab += aCols[i][nPosPrcTab]*aCols[i][nPosQuant]
					EndIf

					_nTotCust+=  (aCols[i][nPosQuant] *aCols[i][nPosCusto] )
					nRet  :=   0
					nDesc :=   0
					If aCols[i][nPosValDe] > 0
						If STREG01(aCols[i][nPosProd],SUA->UA_CLIENTE,SUA->UA_LOJA) > 0
							nDesc := nRet
						ElseIf STREG02(aCols[i][nPosProd],SUA->UA_CLIENTE,SUA->UA_LOJA) > 0
							nDesc := nRet

						EndIf

						If nDesc > 0
							If Empty(Alltrim(_cMemo))
								_cMemo:= 'Itens Possui Desconto Adicional:'+CR+aCols[i][nPosItem] +CR
							Else
								_cMemo:= _cMemo+aCols[i][nPosItem]+CR
							EndIf

							aCols[i][nPosAdic]	   := 'S'
						EndIf
					EndIf
				Else
					_nTotCust+=  (aCols[i][nPosQuant] * aCols[i][nPosCusto] )
					If   aCols[i][nPosTabPr] > aCols[i][nPosXULTPRC]
						If 	_nDesc < ((aCols[i][nPosXULTPRC]*100)/ aCols[i][nPosTabPr] )
							_nDesc:= 100-((aCols[i][nPosXULTPRC]*100)/ aCols[i][nPosTabPr] )     //Guardo a maior porcentagem de desconto
						EndIf

						//_nTotDesc+=  (aCols[i][nPosXULTPRC]-aCols[i][nPosTabPr])

						nRet  :=   0
						nDesc :=   0
						If (aCols[i][nPosXULTPRC]-aCols[i][nPosTabPr]) <> 0
							If STREG01(aCols[i][nPosProd],SUA->UA_CLIENTE,SUA->UA_LOJA) > 0
								nDesc := nRet
							ElseIf STREG02(aCols[i][nPosProd],SUA->UA_CLIENTE,SUA->UA_LOJA) > 0
								nDesc := nRet
							EndIf

							If nDesc > 0
								If Empty(Alltrim(_cMemo))
									_cMemo:= 'Itens Possui Desconto Adicional:'+CR+aCols[i][nPosItem] +CR
								Else
									_cMemo:= _cMemo+aCols[i][nPosItem]+CR
								EndIf

								aCols[i][nPosAdic]	   := 'S'
							EndIf
						EndIf

					EndIf
				EndIf

			EndIf

		Next i

	EndIf

	If SUA->UA_XMARKUP <>	(ROUND(	 (    SUA->UA_ZVALLIQ/_nTotCust ),5))
		_lAlUp:= .T.
	EndIf

	SUA->(RecLock('SUA',.F.))
	SUA->UA_XCUSTO  := _nTotCust
	SUA->UA_XMARKUP :=	ROUND(	 (    SUA->UA_ZVALLIQ/SUA->UA_XCUSTO ),5)
	SUA->(MsUnlock())
	SUA->( DbCommit() )

	//---------------------------------------------------------------------------------------//
	//FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos
	//  0,001 --> 5% - Vendedor             -> _nAlcVend
	//  5,01% --> 10% - Gerente Regional    -> _nAlcGerR
	//  10,01% --> 15% - Gerente de Canais  -> _nAlcGerC
	//  Acima de 15% --> Marketing          -> _nAlcMkt
	//---------------------------------------------------------------------------------------//
	If 	_nDesc > _nAlcVend   // se tiver desconto
		_lBAlxx:= .F.
		If _lInc
			_cMemo:= _cMemo+_cMeCus

			//FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos
			If _nDesc > _nAlcVend //até 5% não bloqueia
				U_StGravZZI(.F.,_nDesc,_nTotDesc,_cMemo,CTOD("  /  /    "),0,,_nTotPrcTab) //Grava zzi Tabela de alçadas
			Endif
			//FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos

		ElseIf _lAlt
			DbSelectArea('ZZI')
			ZZI->(DbGoTop())
			ZZI->(DbSetOrder(3))
			If ZZI->(DbSeek(xFilial("ZZI")+SUA->UA_NUM))

				DbSelectArea('SUB')
				SUB->(DbSetOrder(1))
				If SUB->(DbSeek(xFilial("SUB")+SUA->UA_NUM))
					While SUB->(!Eof()) .and. SUB->UB_FILIAL+SUB->UB_NUM == xFilial("SUB")+SUA->UA_NUM

						If	SUB->UB_XBLQITE = '2' .Or. SUB->UB_XBLQITE = '5'
							_lBAlxx:= .T.
						EndIf
						SUB->(DbSkip())
					End
				EndIf

				// If Round(_nDesc,2) > Round(ZZI->ZZI_DESC,2) .Or. ZZI->ZZI_BLQ = '3' .Or. ZZI->ZZI_BLQ = '2' //GIOVANI ZAGO 06/03/18 VANDERLEI SOLICITOU QUE VOLTE PARA A ALCADA QUANDO TIVER DESCONTO INFERIOR AO JA APROVADO.

				If  _lBAlxx .Or. ZZI->ZZI_BLQ = '3' .Or. ZZI->ZZI_BLQ = '2'
					ZZI->(RecLock('ZZI',.F.))
					ZZI->(DbDelete())
					ZZI->(MsUnlock())
					ZZI->( DbCommit() )
					_cMemo:= _cMemo + _cMeCus
					U_StGravZZI(.F.,_nDesc,_nTotDesc,_cMemo,,,,_nTotPrcTab)//Grava zzi Tabela de alçadas
				EndIf

			Else
				_cMemo:= _cMemo+_cMeCus

				//FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos
				If _nDesc > _nAlcVend //a partir de 0,01% bloqueia
					U_StGravZZI(.F.,_nDesc,_nTotDesc,_cMemo,CTOD("  /  /    "),0,,_nTotPrcTab)//Grava zzi Tabela de alçadas
				Endif
				//FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos
			EndIf
		EndIf

	ElseIf  _nDesc = 0  // sem desconto
		DbSelectArea('ZZI')
		ZZI->(DbGoTop())
		ZZI->(DbSetOrder(3))
		If ZZI->(DbSeek(xFilial("ZZI")+SUA->UA_NUM))
			//If _nDesc > ZZI->ZZI_DESC .Or. ZZI->ZZI_BLQ = '3' .Or. ZZI->ZZI_BLQ = '2'
			ZZI->(RecLock('ZZI',.F.))
			ZZI->(DbDelete())
			ZZI->(MsUnlock())
			ZZI->( DbCommit() )
			_cMemo:= _cMemo+_cMeCus
			U_StGravZZI(.F.,_nDesc,_nTotDesc,_cMemo,,,,_nTotPrcTab)//Grava zzi Tabela de alçadas

			//EndIf
		EndIf
	EndIf

EndIf
EndIf
RestArea(_aArea)
Return (.t.)

	/*====================================================================================\
	|Programa  | StGravZZI         | Autor | GIOVANI.ZAGO             | Data | 10/12/2013 |
	|=====================================================================================|
	|Descrição | StGravZZI                                                                |
	|          | Grava zzi alçada de desconto										      |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | StGravZZI                                                                |
	|=====================================================================================|
	|Uso       | Especifico Steck                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*------------------------------------------------*
User Function StGravZZI(_lSc5,_nDesc,_nTotDesc,_cMemo,_cMem1,_cData,_nOld,_nTotPrcTab)   //.T. PEDIDO DE VENDA ------  .F. ORCAMENTO ========== % DESCONTO  ======= VLR DESCONTO TOTAL =======memo
	*------------------------------------------------*
	Local _aArea  		:= GetArea()
	Local aAlcada      :={}
	Local nx            :=0
	Local cVend         :=""
	Local cCampo        :=""
	Local cMkt          :=SuperGetMv("ES_APRMKT",.f.,'002013')
	Local nTotNivel     :=SuperGetMv("ES_NTOTNIV",.f.,4)
	Local cObs1         :=""
	Local nMarg1       :=0
	Private _aMail:= {}

	If	Iif(_lSc5,SC5->C5_NUM,SUA->UA_NUM) <> '008048'

		If _nDesc <> 0
			If !_lSc5
				DbSelectArea('SUA')
				SUA->(RecLock("SUA",.F.))

				SUA->UA_XBLOQ :='1'
				If    !('DESC' $ ALLTRIM(SUA->UA_XDESBLQ))
					SUA->UA_XDESBLQ := 	ALLTRIM(SUA->UA_XDESBLQ)+'DESC/'
				EndIf
				SUA->(MsUnlock())
				SUA->( DbCommit() )
			Else
				DbSelectArea('SC5')
				SC5->(RecLock("SC5",.F.))
				SC5->C5_ZBLOQ   :="1"
				If    !('DESC' $ ALLTRIM(SC5->C5_ZMOTBLO))
					SC5->C5_ZMOTBLO := 	ALLTRIM(SC5->C5_ZMOTBLO)+'DESC/'
				EndIf
				SC5->(MsUnlock())
				SC5->( DbCommit() )
				If GetMv("ST_DESXX",,.T.)

					cGetMot:= space(200)
					If !Empty(Alltrim(SC5->C5_XMOTDES))
						cGetMot	:= Alltrim(SC5->C5_XMOTDES)+space(200-(Len(Alltrim(SC5->C5_XMOTDES))))
					EndIf

					If !IsInCallStack("U_STFAT620")

						Define msDialog oDlg Title "Motivo do Desconto/Ult.Preço" From 10,10 TO 20,100 Style DS_MODALFRAME

						@ 010,010 say "Motivo: "
						@ 020,010 get cGetMot  size 350,60 Picture "@!"   valid IiF(IsInCallStack('U_STFAT15'),.t.,IiF( Len(alltrim(cGetMot)) >= 20,.t.,(msgInfo("Motivo deve Conter Minimo de 20 Caracteres!!!!","Atenção"),.f.)))

						DEFINE SBUTTON FROM 40,10 TYPE 1 ACTION IiF(IsInCallStack('U_STFAT15'),(_nOpcao:=1,oDlg:End()),IiF( Len(alltrim(cGetMot)) >= 20,(_nOpcao:=1,oDlg:End()),msgInfo("Motivo deve Conter Minimo de 20 Caracteres!!!!","Atenção"))) ENABLE OF oDlg

						Activate dialog oDlg centered

					Else

						_nOpcao := 1
						cGetMot := "PEDIDO GERADO VIA STFAT620"
						
					EndIf

					If _nOpcao = 1
						If !IsInCallStack('U_STFAT15')
							SC5->(RecLock('SC5',.F.))
							SC5->C5_XMOTDES  := cGetMot
							SC5->(MsUnlock())
							SC5->( DbCommit() )
						EndIf
					Endif
				EndIf
			EndIf

			If !_lSc5
				If !Empty(SUA->UA_NUMSC5)
					RestArea(_aArea)
					Return
				EndIf
			EndIf

			If _lSc5
				cQry := " UPDATE "+RetSqlName("SC5")+" SC5 SET C5_XCUSTO = (SELECT SUM(C6_QTDVEN*C6_XCUSTO) FROM "+RetSqlName("SC6")+"  SC6 WHERE SC6.D_E_L_E_T_ = ' ' AND C6_NUM = C5_NUM AND C6_FILIAL = C5_FILIAL) WHERE SC5.D_E_L_E_T_ = ' ' AND C5_NUM =  '"+SC5->C5_NUM+"' AND C5_FILIAL ='"+SC5->C5_FILIAL+"'
				TcSQLExec(cQry)
				cQry := " UPDATE "+RetSqlName("SC5")+" SC5 SET C5_XMARKUP = ROUND((C5_ZVALLIQ/C5_XCUSTO ) ,5) WHERE SC5.D_E_L_E_T_ = ' ' AND   C5_NUM =  '"+SC5->C5_NUM+"' AND C5_FILIAL ='"+SC5->C5_FILIAL+"'
				TcSQLExec(cQry)
			EndIf
            
			SA1->(DBSETORDER(1))
            IF _lSc5
			   SA1->(DBSEEK(XFILIAL('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			   cVend:=SA1->A1_VEND 
			ELSE 
               SA1->(DBSEEK(XFILIAL('SA1')+SUA->UA_CLIENTE+SUA->UA_LOJA))
			   cVend:=SA1->A1_VEND 
			ENDIF   
						
			// Tratamento das alçadas de desconto
			aAlcada:=U_VERALCADA(ALLTRIM(SA1->A1_GRPVEN),SA1->A1_XESCALA,Iif(_lSc5,SC5->C5_ZVALLIQ,SUA->UA_ZVALLIQ),Round((_nTotDesc/_nTotPrcTab)*100,1),cVend)
			
	    	DbSelectArea('ZZI')
			ZZI->(RecLock("ZZI",.T.))
			ZZI->ZZI_FILIAL  	:=	xFilial('ZZI')
			ZZI->ZZI_FILANT  	:=	cFilAnt
			ZZI->ZZI_GRP  		:=	STGRUP(_nDesc)
			ZZI->ZZI_BLQ 		:=	'2'
			ZZI->ZZI_TIPO 		:=	Iif(_lSc5,'PEDIDO','ORÇAMENTO')
			ZZI->ZZI_COD 		:=	GetSxENum("ZZI","ZZI_COD")
			ZZI->ZZI_NUM 		:=	Iif(_lSc5,SC5->C5_NUM,SUA->UA_NUM)
			ZZI->ZZI_CUSTO 	    :=	Iif(_lSc5,SC5->C5_XCUSTO,SUA->UA_XCUSTO)
			ZZI->ZZI_VALOR 	    :=	Iif(_lSc5,SC5->C5_ZVALLIQ,SUA->UA_ZVALLIQ)
			ZZI->ZZI_MARKUP  	:=	ZZI->ZZI_VALOR / ZZI->ZZI_CUSTO
			nMarg1:=IIF(ZZI->ZZI_VALOR<>0,((ZZI->ZZI_VALOR-ZZI->ZZI_CUSTO)/ZZI->ZZI_VALOR)*100,0)
			ZZI->ZZI_MARGEM  	:=	nMarg1
			ZZI->ZZI_COR        :=  VerCor(Round(nMarg1,0))
			ZZI->ZZI_DESCON  	:=	_nTotDesc  //VALOR DO DESCONTO EM R$
			ZZI->ZZI_DESC 		:=  _nDesc     //MAIOR PERCENTUAL DE DESCONTO (GRAVA O MAIOR DESCONTO)
			ZZI->ZZI_DESTOT		:=  Round((_nTotDesc/_nTotPrcTab)*100,1)
			ZZI->ZZI_DATA 		:=  DATE()
			ZZI->ZZI_VEND1 	    :=  Iif(_lSc5,SC5->C5_VEND1  ,SUA->UA_VEND)
			ZZI->ZZI_NVEND1  	:=  Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND1,"A3_NOME")
			ZZI->ZZI_VEND2 	    :=  Iif(_lSc5,SC5->C5_VEND2  ,SUA->UA_VEND2)
			ZZI->ZZI_NVEND2  	:=  Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND2,"A3_NOME")
			ZZI->ZZI_RASTRO  	:=  ''
			ZZI->ZZI_CLIENT  	:=  Iif(_lSc5,SC5->C5_CLIENTE,SUA->UA_CLIENTE)
			ZZI->ZZI_LOJA 		:=  Iif(_lSc5,SC5->C5_LOJACLI,SUA->UA_LOJA)
			ZZI->ZZI_NOMECL  	:=  Posicione("SA1",1,xFilial("SA1")+ZZI->ZZI_CLIENT+ZZI->ZZI_LOJA,"A1_NOME") +' - '+ Posicione("SA1",1,xFilial("SA1")+ZZI->ZZI_CLIENT+ZZI->ZZI_LOJA,"A1_GRPVEN")
			ZZI->ZZI_SUPER 	    :=  Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND1,"A3_SUPER")
			ZZI->ZZI_OBSVEN		:=  Iif(_lSc5,SC5->C5_XMOTDES,SUA->UA_XMOTDES)
			ZZI->ZZI_MOBS	    :=  _cMemo + Iif(_lSc5,' ',SUA->UA_XALCMSG)
			ZZI->ZZI_GRPVEN	    :=  Posicione("SA1",1,xFilial("SA1")+ZZI->ZZI_CLIENT+ZZI->ZZI_LOJA,"A1_GRPVEN")
            cObs1:=Iif(_lSc5,SC5->C5_XMOTDES,SUA->UA_XMOTDES)
		    // Se for alteração de pedido ou campanha -> envia para o Marketing )
			IF ( IsInCallStack('MATA410') .AND. ALTERA .AND. !INCLUI) .OR.;
			   SuperGetMv("ES_OBSORC",.f.,'CAMPANHA') $ UPPER(cObs1)
			   FOR NX:=1 TO nTotNivel-1
			      cCampo:='ZZI_APROV'+ALLTRIM(STR(NX))
                  ZZI->&cCampo:='000000'
                  cCampo:='ZZI_STAPR'+ALLTRIM(STR(NX))
				  ZZI->&cCampo:='Z'
			   NEXT 
			   cCampo:='ZZI_APROV'+ALLTRIM(STR(nTotNivel))
			   ZZI->&cCampo:=cMkt
			ELSE 
			   //Tratamento da alçada. 
			   FOR NX:=1 TO LEN(aAlcada)
			      cCampo:='ZZI_APROV'+ALLTRIM(STR(NX))
			      IF ALLTRIM(aAlcada[nx,1])=='B'
                     ZZI->&cCampo:=ALLTRIM(aAlcada[nx,2])
			      ELSEIF ALLTRIM(aAlcada[nx,1])=='A'
                     ZZI->&cCampo:=ALLTRIM(aAlcada[nx,2]) //'000000' // se ja gerar aprovado gera no ID do administrador
                     cCampo:='ZZI_STAPR'+ALLTRIM(STR(NX))
				     ZZI->&cCampo:='Z'
			      ENDIF
			   NEXT 
            ENDIF

			ZZI->(MsUnlock())
			ZZI->( DbCommit() )
			ZZI->(ConfirmSX8())

			GravaZyc(ZZI->ZZI_NUM)

			If ZZI->ZZI_DESTOT>=15 .And. AllTrim(ZZI->ZZI_TIPO)=="ORÇAMENTO"
				//Enviar email para Leonardo
				FGERACSV(SUA->UA_NUM,SUA->UA_VEND)
			EndIf
			
			_cNome := ZZI->ZZI_NOMECL
			If Empty(_cNome)
				DbSelectArea("SA1")
				SA1->(DbSetOrder(1))
				If SA1->(DbSeek(xFilial("SA1")+ZZI->(ZZI_CLIENT+ZZI_LOJA)))
					_cNome := AllTrim(SA1->A1_NOME)
				EndIf
			EndIf

			Aadd(_aMail,{ZZI->ZZI_TIPO 	,ZZI->ZZI_NUM,'',''})
			Aadd(_aMail,{'Cliente' 		,ZZI->ZZI_CLIENT+'-'+ZZI->ZZI_LOJA,'',''})
			Aadd(_aMail,{'Nome' 		,_cNome,'',''})
			Aadd(_aMail,{'Coordenador' 	,ZZI->ZZI_SUPER+' - '+Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_SUPER,"A3_NOME"),'',''})
			Aadd(_aMail,{'Vendedor 01' 	,ZZI->ZZI_VEND1+' - '+ZZI->ZZI_NVEND1,'',''})
			Aadd(_aMail,{'Vendedor 02' 	,ZZI->ZZI_VEND2+' - '+ZZI->ZZI_NVEND2,'',''})
			Aadd(_aMail,{'%Desconto' 	,Transform( ZZI->ZZI_DESC  ,"@E 999,999,999.99")+'%','',''})
			Aadd(_aMail,{'Obs.:' 	    ,Alltrim(ZZI->ZZI_OBSVEN),'',''})
			If !_lSc5
				//Aadd(_aMail,{'Historico:' 	, Alltrim(SUA->UA_XALCMSG),'',''})
				Aadd(_aMail,{'Historico:' 	, Alltrim(ZZI->ZZI_MOBS),'',''})
			EndIf

			ZZIMAIL(_aMail,AllTrim(GetMv("STDESALC03",,""))+;
			Alltrim(Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND1,"A3_EMAIL" ))+";"+ ;
			Alltrim(Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND2,"A3_EMAIL" ))+";"+ ;
			Alltrim(Posicione("SA3",1,xFilial("SA3")+Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND2,"A3_XSUPINT"),"A3_EMAIL" ))+";"+ ;
			Alltrim(Posicione("SA3",1,xFilial("SA3")+Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND1,"A3_SUPER"),"A3_EMAIL" )))

			Aadd(_aMail,{'MarkUp - Geral'		,Transform(((ZZI->ZZI_MARKUP-1)*100) ,"@E 999,999,999.99")+' %'  ,'Val.Liq.: R$' + Transform(ZZI->ZZI_VALOR,"@E 999,999,999.99") ,'Custo: R$' + Transform(ZZI->ZZI_CUSTO ,"@E 999,999,999.99")})

			STCZZI(ZZI->ZZI_NUM)

			If	ZZI->ZZI_VALOR > 120000 .And. ZZI->ZZI_DESC > 10  
				ZZIMAIL(_aMail)
			EndIf

		EndIf
	EndIf
	RestArea(_aArea)
Return()

Static Function ZZIMAIL(_aMsg,_cEmail)

	Local _nLin 	:= 0
	Local _cAssunto := "Controle de Alçada de Desconto "+ZZI->ZZI_TIPO+": "+ ZZI->ZZI_NUM
	Local cFuncSent := "STDESCALC"

	Default   _cEmail	  := AllTrim(GetMv("STDESALC02",,"klecios.souza@steckgroup.com;leandro.souza@steck.com.br"))

	If AllTrim(ZZI->ZZI_TIPO)=="ORÇAMENTO"
		DbSelectArea("SUA")
		SUA->(DbSetOrder(1))
		If SUA->(DbSeek(ZZI->(ZZI_FILANT+ZZI_NUM)))
			If AllTrim(SUA->UA_XBLOQ)=="3" //Orçamento cancelado
				ZZI->(RecLock("ZZI",.F.))
				ZZI->(DbDelete())
				ZZI->(MsUnLock())
				Return
			EndIf
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do cabecalho do email                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do texto/detalhe do email                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nLin := 1 to Len(_aMsg)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
		cMsg += '</TR>'
	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do rodape do email                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

	U_STMAILTES(_cEmail, '', _cAssunto, cMsg,,,'' )

	Return()

	/*====================================================================================\
	|Programa  | STZZIBOK          | Autor | GIOVANI.ZAGO             | Data | 10/12/2013 |
	|=====================================================================================|
	|Descrição | STZZIBOK                                                                 |
	|          | P.E. botao UA_OPER													      |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STZZIBOK                                                                 |
	|=====================================================================================|
	|Uso       | Especifico Steck                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------*
User Function STZZIBOK()
	*-----------------------*
	Local _lRet  := .T.
	If Inclui
		U_STDESALC(Inclui,Altera)//Giovani Zago 18/12/13 Alçada Comercial
	EndIf
	DbSelectArea('ZZI')
	ZZI->(DbGoTop())
	ZZI->(DbSetOrder(3))
	If ZZI->(DbSeek(xFilial("ZZI")+SUA->UA_NUM+'ORÇAMENTO'))
		If ZZI->ZZI_BLQ = '2' .Or. ZZI->ZZI_BLQ = '3'
			_lRet  := .F.
		EndIf

	EndIf
	Return(_lRet)

	/*====================================================================================\
	|Programa  | STGRUP            | Autor | GIOVANI.ZAGO             | Data | 14/01/2014 |
	|=====================================================================================|
	|Descrição | STGRUP                                                                   |
	|          | Retorna Grupo de Aprovação 										      |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STGRUP                                                                   |
	|=====================================================================================|
	|Uso       | Especifico Steck                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*------------------------------*
Static Function STGRUP(_nDesc)
	*------------------------------*
	Local _cRet  := ''
	Local _cVar  := ''
	If _nDesc <= GetMv('ST_ALCA00',,0)
		_cVar  := 'ST_ALCA00'
	ElseIf _nDesc <= GetMv('ST_ALCA01',,0)
		_cVar  := 'ST_ALCA01'
	ElseIf _nDesc <= GetMv('ST_ALCA02',,0)
		_cVar  := 'ST_ALCA02'
	ElseIf _nDesc <= GetMv('ST_ALCA03',,0)
		_cVar  := 'ST_ALCA03'
	ElseIf _nDesc <= GetMv('ST_ALCA04',,0)
		_cVar  := 'ST_ALCA04'
	EndIf

	DbSelectArea ("SX6")
	SX6->(DbSetOrder (1))
	If (SX6->(DbSeek ('  '+_cVar)))
		_cRet:= SX6->X6_DESCRIC
	EndIf
	Return(_cRet)

	/*====================================================================================\
	|Programa  | STREG01           | Autor | GIOVANI.ZAGO             | Data | 14/01/2014 |
	|=====================================================================================|
	|Descrição | STREG01                                                                  |
	|          | Retorna desconto													      |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STREG01                                                                  |
	|=====================================================================================|
	|Uso       | Especifico Steck                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------------------------*
Static Function STREG01(cProduto,cCliente,cLoja)
	*-----------------------------------------------*
	Local cAliasLif  := 'TMP01'
	Local cQuery     := ' '

	cQuery := " SELECT ACP.ACP_PERDES DESCONTO
	cQuery += " FROM  "+RetSqlName("ACO")+" ACO  ,"+RetSqlName("ACP")+" ACP "
	cQuery += " WHERE ACO.ACO_FILIAL = '"+xFilial("ACO")+"'"
	cQuery += " AND  ACO.ACO_CODCLI  = '"+cCliente+"'"
	cQuery += " AND  ACO.ACO_LOJA    = '"+cLoja+"'"
	cQuery += " AND ACO.D_E_L_E_T_   = ' ' "
	cQuery += " AND ACP.ACP_FILIAL   = '"+xFilial("ACP")+"'"
	cQuery += " AND ACP.ACP_CODREG   =  ACO.ACO_CODREG "
	cQuery += " AND ACP.ACP_CODPRO   = '"+cProduto+"'"
	cQuery += " AND ACP.ACP_FAIXA   >= 000000000000001.00 "
	cQuery += " AND ACP.D_E_L_E_T_   = ' ' "
	cQuery += " AND ACO.ACO_DATDE   <= '"+dtos(dDataBase)+"'"
	cQuery += " AND (ACO.ACO_DATATE >= '"+dtos(dDataBase)+"'  OR ACO.ACO_DATATE = ' ')"
	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	If  Select(cAliasLif) > 0
		dbSelectArea(cAliasLif)
		(cAliasLif)->(dbgotop())
		nRet:= (cAliasLif)->DESCONTO
	EndIf
	Return (nRet)

	/*====================================================================================\
	|Programa  | STREG02           | Autor | GIOVANI.ZAGO             | Data | 14/01/2014 |
	|=====================================================================================|
	|Descrição | STREG02                                                                  |
	|          | Retorna desconto													      |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STREG02                                                                  |
	|=====================================================================================|
	|Uso       | Especifico Steck                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------------------------*
Static Function STREG02(cProduto,cCliente,cLoja)
	*-----------------------------------------------*
	Local cAliasLif  := 'TMP02'
	Local cQuery     := ' '

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+cProduto))

		cQuery := " SELECT ACP.ACP_PERDES DESCONTO
		cQuery += " FROM  "+RetSqlName("ACO")+" ACO  ,"+RetSqlName("ACP")+" ACP "
		cQuery += " WHERE ACO.ACO_FILIAL = '"+xFilial("ACO")+"'"
		cQuery += " AND  ACO.ACO_CODCLI  = '"+cCliente+"'"
		cQuery += " AND  ACO.ACO_LOJA    = '"+cLoja+"'"
		cQuery += " AND ACO.D_E_L_E_T_   = ' ' "
		cQuery += " AND ACP.ACP_FILIAL   = '"+xFilial("ACP")+"'"
		cQuery += " AND ACP.ACP_CODREG   =  ACO.ACO_CODREG "
		cQuery += " AND ACP.ACP_CODPRO   = ' '"
		cQuery += " AND ACP.ACP_GRUPO    = '"+SB1->B1_GRUPO+"'"
		cQuery += " AND ACP.ACP_FAIXA   >= 000000000000001.00 "
		cQuery += " AND ACP.D_E_L_E_T_   = ' ' "
		cQuery += " AND ACO.ACO_DATDE   <= '"+dtos(dDataBase)+"'"
		cQuery += " AND (ACO.ACO_DATATE >= '"+dtos(dDataBase)+"'  OR ACO.ACO_DATATE = ' ')"
		cQuery := ChangeQuery(cQuery)

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

		If  Select(cAliasLif) > 0
			dbSelectArea(cAliasLif)
			(cAliasLif)->(dbgotop())
			nRet:= (cAliasLif)->DESCONTO
		EndIf
	EndIf
	Return (nRet)

	/*====================================================================================\
	|Programa  | STREG03           | Autor | GIOVANI.ZAGO             | Data | 14/01/2014 |
	|=====================================================================================|
	|Descrição | STREG03                                                                  |
	|          | Retorna desconto													      |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STREG03                                                                  |
	|=====================================================================================|
	|Uso       | Especifico Steck                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------------------------*
Static Function STREG03(cProduto,cCliente,cLoja)
	*-----------------------------------------------*
	Local cAliasLif  := 'TMP03'
	Local cQuery     := ' '

	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+cCliente+cLoja))

		cQuery := " SELECT ACP.ACP_PERDES DESCONTO
		cQuery += " FROM  "+RetSqlName("ACO")+" ACO  ,"+RetSqlName("ACP")+" ACP "
		cQuery += " WHERE ACO.ACO_FILIAL = '"+xFilial("ACO")+"'"
		cQuery += " AND  ACO.ACO_CODCLI  = ' '"
		cQuery += " AND  ACO.ACO_LOJA    = ' '"
		cQuery += " AND ACO.D_E_L_E_T_   = ' ' "
		cQuery += " AND ACP.ACP_FILIAL   = '"+xFilial("ACP")+"'"
		cQuery += " AND ACP.ACP_CODREG   =  ACO.ACO_CODREG "
		cQuery += " AND ACP.ACP_CODPRO   = '"+cProduto+"'"
		cQuery += " AND ACP.ACP_GRUPO    = ' '"
		cQuery += " AND ACO.ACO_GRPVEN    = '"+SA1->A1_GRPVEN+"'"
		cQuery += " AND ACP.ACP_FAIXA   >= 000000000000001.00 "
		cQuery += " AND ACP.D_E_L_E_T_   = ' ' "
		cQuery += " AND ACO.ACO_DATDE   <= '"+dtos(dDataBase)+"'"
		cQuery += " AND (ACO.ACO_DATATE >= '"+dtos(dDataBase)+"'  OR ACO.ACO_DATATE = ' ')"
		cQuery := ChangeQuery(cQuery)

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

		If  Select(cAliasLif) > 0
			dbSelectArea(cAliasLif)
			(cAliasLif)->(dbgotop())
			nRet:= (cAliasLif)->DESCONTO
		EndIf
	EndIf
	Return (nRet)

	/*====================================================================================\
	|Programa  | STREG04           | Autor | GIOVANI.ZAGO             | Data | 14/01/2014 |
	|=====================================================================================|
	|Descrição | STREG04                                                                  |
	|          | Retorna desconto													      |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STREG04                                                                  |
	|=====================================================================================|
	|Uso       | Especifico Steck                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------------------------*
Static Function STREG04(cProduto,cCliente,cLoja)
	*-----------------------------------------------*
	Local cAliasLif  := 'TMP04'
	Local cQuery     := ' '

	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+cCliente+cLoja))
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+cProduto))

			cQuery := " SELECT ACP.ACP_PERDES DESCONTO
			cQuery += " FROM  "+RetSqlName("ACO")+" ACO  ,"+RetSqlName("ACP")+" ACP "
			cQuery += " WHERE ACO.ACO_FILIAL = '"+xFilial("ACO")+"'"
			cQuery += " AND  ACO.ACO_CODCLI  = ' '"
			cQuery += " AND  ACO.ACO_LOJA    = ' '"
			cQuery += " AND ACO.D_E_L_E_T_   = ' ' "
			cQuery += " AND ACP.ACP_FILIAL   = '"+xFilial("ACP")+"'"
			cQuery += " AND ACP.ACP_CODREG   =  ACO.ACO_CODREG "
			cQuery += " AND ACP.ACP_CODPRO   = ' '"
			cQuery += " AND ACP.ACP_GRUPO    = '"+SB1->B1_GRUPO+"'"
			cQuery += " AND ACO.ACO_GRPVEN   = '"+SA1->A1_GRPVEN+"'"
			cQuery += " AND ACP.ACP_FAIXA   >= 000000000000001.00 "
			cQuery += " AND ACP.D_E_L_E_T_   = ' ' "
			cQuery += " AND ACO.ACO_DATDE   <= '"+dtos(dDataBase)+"'"
			cQuery += " AND (ACO.ACO_DATATE >= '"+dtos(dDataBase)+"'  OR ACO.ACO_DATATE = ' ')"
			cQuery := ChangeQuery(cQuery)

			If Select(cAliasLif) > 0
				(cAliasLif)->(dbCloseArea())
			EndIf

			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

			If  Select(cAliasLif) > 0
				dbSelectArea(cAliasLif)
				(cAliasLif)->(dbgotop())
				nRet:= (cAliasLif)->DESCONTO
			EndIf
		EndIf
	EndIf
Return (nRet)

Static Function STCZZI(_cZzi)
	*-----------------------------------------------*
	Local cAliasLif  := 'STCZZI'
	Local cQuery     := ' '

	//FR - 11/01/2022 - TICKET #20220110000672 - ERROR LOG ao salvar orçamento 
	cQuery := " SELECT "
	cQuery += "   TRIM(B1_GRUPO||' - '||BM_DESC) AS GRUPO, "
	cQuery += "   SUM (CASE WHEN ZZI_TIPO = 'ORÇAMENTO' THEN UB_ZVALLIQ ELSE C6_ZVALLIQ END) AS VLIQ , " 
	cQuery += "   SUM (CASE WHEN ZZI_TIPO = 'ORÇAMENTO' THEN UB_QUANT*UB_XCUSTO ELSE C6_QTDVEN*C6_XCUSTO END) AS CUSTO , "
	cQuery += "    ROUND( ((SUM (CASE WHEN ZZI_TIPO = 'ORÇAMENTO' THEN UB_ZVALLIQ ELSE C6_ZVALLIQ END) / SUM (CASE WHEN ZZI_TIPO = 'ORÇAMENTO' THEN UB_QUANT*UB_XCUSTO ELSE C6_QTDVEN*C6_XCUSTO END))-1) * 100  ,2) " 
	cQuery += "      AS MKP

	cQuery += "   FROM " + RetSqlName("ZZI") + " ZZI " 
	cQuery += "   LEFT JOIN (SELECT * FROM " + RetSqlname("SUB") + ")  SUB  "   
	cQuery += "   ON SUB.D_E_L_E_T_ = ' ' "
	cQuery += "   AND ZZI_TIPO = 'ORÇAMENTO' AND UB_XCUSTO <> 0 " //giovani zago ub_xcusto 0 da erro
	cQuery += "   AND SUB.UB_NUM = ZZI_NUM "

	cQuery += "   LEFT JOIN (SELECT * FROM " + RetSqlname("SC6") + ") SC6 " 
	cQuery += "   ON SC6.D_E_L_E_T_ = ' ' "
	cQuery += "   AND ZZI_TIPO = 'PEDIDO' AND C6_XCUSTO <> 0 " //giovani zago ub_xcusto 0 da erro
	cQuery += "   AND SC6.C6_NUM = ZZI_NUM "
	cQuery += "   INNER JOIN (SELECT * FROM " + RetSqlName("SB1") + ") SB1 "  
	cQuery += "   ON SB1.D_E_L_E_T_ = ' ' "
	cQuery += "   AND (SB1.B1_COD = UB_PRODUTO OR SB1.B1_COD = C6_PRODUTO) "
	cQuery += "   INNER JOIN(SELECT * FROM " + RetSqlName("SBM") + ") SBM "  
	cQuery += "   ON SBM.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SBM.BM_GRUPO = B1_GRUPO "
	cQuery += "   WHERE ZZI.D_E_L_E_T_ = ' ' "
	cQuery += "   AND ZZI_NUM = '"+_cZzi+"'"

	cQuery += "   GROUP BY B1_GRUPO||' - '||BM_DESC "
	cQuery += "   ORDER BY B1_GRUPO||' - '||BM_DESC "

	MemoWrite("C:\TEMP\STDESALC.TXT" , cQuery)

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			Aadd(_aMail,{ (cAliasLif)->GRUPO, Transform((cAliasLif)->MKP,"@E 999,999,999.99")+' %',' Val.Liq.: R$ '+Transform((cAliasLif)->VLIQ,"@E 999,999,999.99"),'Custo: R$ '+Transform((cAliasLif)->CUSTO,"@E 999,999,999.99")    })

			(cAliasLif)->(dbskip())

		End

	EndIf

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
Return ()

//------------------------------------------//
//Função que gera o arquivo CSV
//------------------------------------------//
STATIC FUNCTION FGERACSV(cOrc,cVend)

Local nConLin   := 0
Local nHdl      := 0
Local cLinha    := ""
Local cPath     := ""
Local cNomeArq  := ""
Local cPathServ := ""
Local _aAttach  := {}
Local _cCaminho := ""	
Local cAnexo    := ""
Local _cEmail   := ""
Local _cAssunto := ""
Local lEnviou   := .F.	
Local cSuper    := ""	
Local _cCopia   := ""
Local _nMaiorD  := 0

 //---------------------------------------------------------------------------------------//
 //FR - 18/10/2022 - TICKET #20221018019345 - Alteração - Melhoria na alçada de descontos
 //  0,001 --> 5% - Vendedor             -> _nAlcVend
 //  5,01% --> 10% - Gerente Regional    -> _nAlcGerR
 //  10,01% --> 15% - Gerente de Canais  -> _nAlcGerC
 //  Acima de 15% --> Marketing          -> _nAlcMkt
 //---------------------------------------------------------------------------------------//
 //Parâmetro informa o teto máximo de desconto que a área pode autorizar
 Local _nAlcVend := GetNewPar("ST_ZZHVEN" , 0)  //era 5, alterado para 0 conforme solicitado por Renato em 19/10/2022
 Local _nAlcGerR := GetNewPar("ST_ZZHGERR", 10)
 Local _nAlcGerC := GetNewPar("ST_ZZHGERC", 15)
 Local _nAlcMkt  := GetNewPar("ST_ZZHMKT" , 99)
 Local _cMailMKt := GetNewPar("ST_ZZHMKTM", "leonardo.capelli@steck.com.br")   
 Local lEnvCSV   := .F. 

cPath := "C:\PROTHEUS\"
If !ExistDir(cPath)
	MakeDir(cPath)
EndIf

DbselectArea("SUB")
OrdSetFocus(1)

If SUB->(Dbseek(xFilial("SUB") + cOrc ))
    cNomeArq := "ORC_"+ cOrc + ".CSV"

    //============================================================================//
    // Cria arquivo CSV no diretorio informado                                  
    //============================================================================//
    If (nHdl := FCreate(cPath+cNomeArq))== -1
        MsgStop( "O arquivo " + cPath + cNomeArq + " não pode ser gerado!" )
        Return Nil
    EndIf

	While SUB->(!Eof()) .and. SUB->UB_FILIAL == xFilial("SUB") .and. SUB->UB_NUM == cOrc
        
        If SUB->UB_XPORDEC > 0
            lEnvCSV := .T.
        Endif 

        //============================================================================//
        // Gera linha de cabecalho e grava no arquivo CSV                     
        //============================================================================//
        nConLin++
        
	    If nConLin == 1
            cLinha += "FILIAL;ORCAMENTO;ITEM;PRODUTO;QTDE;PRCUNIT;XPORDEC;PRCLISTA;VAL_LIQUIDO" + CRLF

            If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
                If !MsgYesNo('Ocorreu um erro na gravação da linha ' + AllTrim(Str(nConLin)) +   ' no arquivo ' + AllTrim(cPath + cNomeArq) + '. Continua?','Aten‡ão!')
                    lContinua := .F.
                    Exit
                Endif
            Endif

        Endif 

        cLinha := SUB->UB_FILIAL + ";"                  //1
        cLinha += SUB->UB_NUM + ";"                     //2
        cLinha += SUB->UB_ITEM + ";"                    //3
        cLinha += SUB->UB_PRODUTO + ";"                 //4
        cLinha += cValToChar(SUB->UB_QUANT) + ";"       //5
        cLinha += cValToChar(SUB->UB_VRUNIT) + ";"      //6
        cLinha += cValToChar(SUB->UB_XPORDEC) + ";"     //7
        cLinha += cValToChar(SUB->UB_ZPRCTAB) + ";"     //8
        cLinha += cValToChar(SUB->UB_ZVALLIQ) + ";"     //9

        cLinha += CRLF

        If SUB->UB_XPORDEC > _nMaiorD  //guarda sempre o maior desconto
            _nMaiorD := SUB->UB_XPORDEC
        Endif 

        If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
            If !MsgYesNo('Ocorreu um erro na gravação da linha ' + AllTrim(Str(nConLin)) +   ' no arquivo ' + AllTrim(cPath + cNomeArq) + '. Continua?','Atenção!')		
                lContinua := .F.
                Exit
            Endif
        Endif

		SUB->(Dbskip())

	Enddo

    //============================================================================//
    //Fecha arquivo CSV                                                         
    //============================================================================//
    fClose(nHdl)

    //============================================================================//
    //Prepara envio por email                                                         
    //============================================================================//    
    If lEnvCSV
        If File(cPath + cNomeArq)  //verifica se o arquivo existe na pasta local
            cPathServ := "\arquivos\orcamento\"

            If !ExistDir(cPathServ)
                MakeDir(cPathServ)
            EndIf
            
            //copia o arquivo para o servidor para enviar por email
            //__CopyFile(cDirSrv+cNomArq, cDirUsr+cNomArq)  //Caminho origem + arquivo , Caminho destino + arquivo
            __CopyFile(cPath + cNomeArq , cPathServ + cNomeArq) 

            aadd( _aAttach  , cNomeArq)	
            _cCaminho := cPathServ	
            cAnexo    := cPathServ + cNomeArq
            
            _cAssunto := "ARQUIVO CSV ORÇAMENTO x DESCONTOS - ORCAMENTO "+SUA->UA_NUM
            //_cAssunto += " - TESTE "  //RETIRAR

			_cEmail := AllTrim(GetMv("STDESALC01",,"leonardo.capelli@steck.com.br"))

            cMsg      := "Segue Anexo arquivo CSV."
            lEnviou   := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

        Endif //se envia o csv só se o orçamento tiver desconto
    Endif 			


Endif 

Return Nil


/*/{Protheus.doc} U_VERALCADA

Rotina que devolve o usuário responsavel pela aprovação conforme o nivel. 

@type function
@author	Antonio Cordeiro. 
@since 05/06/2023
@version P11,P12
@database Oracle.  

@see VERALCADA
/*/

User Function VERALCADA(cGrpVen,cEscala,nValor,nTotDesc,cVend)

Local cAlias    :=""
Local aArea    :=GetArea()
Local nx       :=0
Local nTotNivel:=SuperGetMv("ES_NTOTNIV",.f.,4)
Local cCampo   :=""
Local cSuper   :=""
Local cGeren   :=""
Local aAlcadas :={}
Local cCanal   :=SuperGetMv("ES_APRMKT",.f.,'002013')
Local cMkt     :=SuperGetMv("ES_APRMKT",.f.,'002013')

SA3->(DBSETORDER(1))
IF SA3->(DBSEEK(XFILIAL('SA3')+cVend))
   cSuper:=SA3->A3_SUPER 
   cGeren:=SA3->A3_GEREN 
   IF SA3->(DBSEEK(XFILIAL('SA3')+cSuper)) // AÇADADA 1 REGIONAL 
      AADD(aAlcadas,{' ',SA3->A3_CODUSR})
   ELSE 
      AADD(aAlcadas,{'',cMkt}) // Nao localizou alçada 1
   ENDIF	  

   IF SA3->(DBSEEK(XFILIAL('SA3')+cGeren)) // AÇADADA 2 NACIONAL 
      AADD(aAlcadas,{' ',SA3->A3_CODUSR})
   ELSE 
      AADD(aAlcadas,{'  ',cMkt}) // Nao localizou alçada 2
   ENDIF	  
ELSE 
   AADD(aAlcadas,{,cMkt}) // Nao localizou alçada 1 Regional 
   AADD(aAlcadas,{,cMkt}) // Nao localizou alçada 2 Nacional 
ENDIF

cCanal:=VerCanal(cGrpVen)
IF !Empty(cCanal)
   AADD(aAlcadas,{' ',cCanal}) // ALCADA DO CANCAL 
ELSE 
   AADD(aAlcadas,{' ',cMkt}) // ALCADA DO CANCAL 
ENDIF
AADD(aAlcadas,{' ',cMkt}) // ALCADA DO MARKETING 

cAlias := GetNextAlias()
cQuery := " SELECT ZAC_PAPR1,ZAC_PAPR2,ZAC_PAPR3,ZAC_PAPR4 "
cQuery += " FROM "+RetSqlName("ZAC")+ " ZAC "
cQuery += " WHERE R_E_C_N_O_ IN ( "
cQuery += " SELECT MIN(R_E_C_N_O_)  
cQuery += " FROM "+RetSqlName("ZAC")+ " ZAC "
cQuery += " WHERE ZAC_CANAL = '"+cGrpVen+"' "
cQuery += " AND ZAC_ESCALA = '"+cEscala+"' "
cQuery += " AND ZAC_VALOR >= "+ALLTRIM(STR(nValor))
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " ) AND D_E_L_E_T_ = ' ' "

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
IF (cAlias)->( ! Eof())
   FOR nx:=1 to nTotNivel
	  cCampo:='ZAC_PAPR'+alltrim(STR(nx,1))
	  IF nTotDesc > (cAlias)->&cCampo
	     IF (cAlias)->&cCampo==0
			aAlcadas[NX,1]:='A'	// Caso informado limite zero gera como aprovado     
		 ELSE
		    aAlcadas[NX,1]:='B' // Bloqueado 
	 	 ENDIF	
	  ELSE 
	     aAlcadas[NX,1]:='B' 
		 EXIT 
	  ENDIF
   NEXT 
ELSE // Alçada não localizada. 
   FOR nx:=1 to nTotNivel-1
       aAlcadas[NX,1]:='A'
   NEXT 
   aAlcadas[NX,1]:='B' // Bloqueado 
ENDIF

//Se houver alçada repetida em sequencia mantem somente a segunda 
FOR nx:=1 to Len(aAlcadas)-1
   IF aAlcadas[nx,1]=='B' .AND. aAlcadas[nx+1,1]=='B' .AND. ;
      aAlcadas[nx,2]==aAlcadas[nx+1,2] 
      aAlcadas[nx,1]:='A'
   ENDIF	  
NEXT 



(cAlias)->( DbcloseArea())

RestArea(aArea)

Return(aAlcadas)


// Ver Canal. 
Static Function VerCanal(cGrpVen)

Local aArea   :=GetArea()
Local cAlias  := GetNextAlias()
Local cQuery  :=""
Local cUsuario:=""


cQuery +=" SELECT ZZH_USER USER1  "
cQuery +=" FROM "+RetSqlName("ZZH")+ " ZZH "
cQuery +=" WHERE ZZH.ZZH_FILIAL = '"+XFILIAL('ZZH')+"' "
cQuery +=" AND ZZH_GRPVEN LIKE '%"+cGrpVen+"%' "
cQuery +=" AND ZZH.D_E_L_E_T_ = ' ' " 

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
(cAlias)->(DBGOTOP())
IF ! (cAlias)->(EOF())
   cUsuario:=(cAlias)->USER1
ENDIF

(cAlias)->( DbcloseArea())

RestArea(aArea)

Return(cUsuario)


// Ver Cor. 
Static Function VerCor(nMargem)

Local aArea   :=GetArea()
Local cAlias  := GetNextAlias()
Local cQuery  :=""
Local cCor    :=""

cQuery +=" SELECT X5_DESCRI COR "
cQuery +=" FROM "+RetSqlName("SX5")+ " SX5 "
cQuery +=" WHERE X5_TABELA = 'WI' "
cQuery +=" AND "+ALLTRIM(STR(nMargem))+" BETWEEN SUBSTR(X5_CHAVE,1,3) AND SUBSTR(X5_CHAVE,4,3) "
cQuery +=" AND D_E_L_E_T_ = ' ' "

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
(cAlias)->(DBGOTOP())
IF ! (cAlias)->(EOF())
   cCor:=ALLTRIM((cAlias)->COR)
ENDIF
(cAlias)->( DbcloseArea())

RestArea(aArea)

Return(cCor)


// Grava ZYC - Segregação de Margem por familia 
Static Function GravaZYC(cNum)

Local aArea   :=GetArea()
Local cAlias  := GetNextAlias()
Local cQuery  :=""
Local nMargem :=0
Local cDescGru:=""

cQry := " UPDATE "+RetSqlName("ZYC")+" SET D_E_L_E_T_  = '*'  "
cQry +="  WHERE D_E_L_E_T_ = ' ' AND ZYC_FILIAL = '"+XFILIAL('ZYC')+"' " 
cQry +="  AND  ZYC_NUM =  '"+cNum+"' AND ZYC_FILANT ='"+cFilAnt+"' "
TcSQLExec(cQry)


cQuery +=" SELECT Z92_CODGRP CODGRP,UB_XTEMCTR TEMCTR,SUM(UB_ZVALLIQ) ZVALLIQ,SUM(UB_XCUSTO*UB_QUANT) XCUSTO
cQuery +=" FROM "+RetSqlName("SUB")+ " SUB "
cQuery +=" INNER JOIN "+RetSqlName("SB1")+ " SB1 ON SB1.B1_COD = SUB.UB_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
cQuery +=" INNER JOIN "+RetSqlName("SBM")+ " SBM ON SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.D_E_L_E_T_ = ' ' "
cQuery +=" INNER JOIN "+RetSqlName("Z92")+ " Z92 ON Z92.Z92_CODGRP = SBM.BM_XAGRUP2 AND Z92.D_E_L_E_T_ = ' ' "
cQuery +=" WHERE UB_FILIAL = '"+XFILIAL('SUB')+"' "
cQuery +=" AND UB_NUM = '"+cNum+"' "
cQuery +=" AND SUB.D_E_L_E_T_ = ' ' " 
cQuery +=" GROUP BY Z92_CODGRP,UB_XTEMCTR "
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
(cAlias)->(DBGOTOP())
While ! (cAlias)->(EOF())
  nMargem:=IIF((cAlias)->ZVALLIQ<>0,((cAlias)->ZVALLIQ-(cAlias)->XCUSTO)/(cAlias)->ZVALLIQ,0)
  nMargem:=round(nMargem*100,0)
  Z92->(DBSETORDER(1))
  IF Z92->(DBSEEK(XFILIAL('Z92')+(cAlias)->CODGRP))
     cDescGru:=Z92->Z92_DSCGRP
  ELSE 
     cDescGru:='Nao existe'
  ENDIF	 
  ZYC->(RECLOCK('ZYC',.T.))    
  ZYC->ZYC_FILANT:=cFilAnt
  ZYC->ZYC_NUM   :=cNum 
  ZYC->ZYC_FAMILI:=(cAlias)->CODGRP 
  ZYC->ZYC_CONTRA:=IIF((cAlias)->TEMCTR=='S','S','N')
  ZYC->ZYC_VALLIQ:=(cAlias)->ZVALLIQ
  ZYC->ZYC_CUSTO :=(cAlias)->XCUSTO   
  ZYC->ZYC_COR   :=VerCor(nMargem)
  ZYC->ZYC_MARGEM:=nMargem 
  ZYC->ZYC_DESCRI:=cDescGru
  ZYC->(MSUNLOCK('ZYC'))     
  (cAlias)->(DBSKIP())
ENDDO

(cAlias)->( DbcloseArea())

RestArea(aArea)

Return()
