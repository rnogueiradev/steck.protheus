#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STGAP31         | Autor | GIOVANI.ZAGO              | Data | 01/02/2013  |
|=====================================================================================|
|Descrição |  Gap 31     												              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STGAP31                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
| FR - 30/09/2021 - Ticket #20210929020425:                                           |
|                   Validação do armazém apenas qdo a operação for igual a '01'       |
|                   criação do parâmetro ST_OPERLOC                                   |
|                                                                                     |
\====================================================================================*/
/**********************************
Chamado....: 20211104023664
Alteração..: Retirar mesnsagem de contato com a TI, Substituir pela rotina AVISO pasando os procedimentos.
...........: Tratamento para não considerar se a linha está Deletada
Analista...: Marcelo Klopfer Leme - Sigamat
Data.......: 12/11/2021
**********************************/

*-----------------------------*
User Function STGAP31()
	*-----------------------------*

	Local aArea         := GetArea()
	Local lRet          := .t.
	Local cMsg          := ''
	Local _nPosItem     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_ITEM"    })
	Local _nPosLocal    := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_LOCAL"   })
	Local _nPosTotItem  := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_VALOR"   })
	Local _nPosPrcven   := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_PRCVEN"  })
	Local _nPosQtdVen	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_QTDVEN"  })
	Local _nPosQtLIB	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_QTDLIB"  })
	Local _nPosPrUnit	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_PRUNIT"  })
	Local _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" })
	Local _nPosComiss   := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_XVALCOM" })
	Local _nPosCom2     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_COMIS2"  })
	Local _nPosDESC     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_DESCONT" })
	Local _nPosVALDESC  := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_VALDESC" })
	Local _nPosComiss   := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_XVALCOM" })
	Local _nPosCom1     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_COMIS1"  })
	Local _nBloqIt      := aScan(aHeader, { |x| AllTrim(x[2]) == "C6_ZMOTBLO" })
	Local _nOper        := aScan(aHeader, { |x| AllTrim(x[2]) == "C6_OPER"    })
	Local _nPosQatu     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_ZB2QATU" })
	Local _nPosdtentr   := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_ENTRE1"  })
	Local _nPosReserv   := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_ZRESERV" })
	Local _nPosXDesc    := aScan(aHeader, { |x| Alltrim(x[2]) =="C6_XPORDEC"  })
	Local _nPosZPrc     := aScan(aHeader, { |x| Alltrim(x[2]) =="C6_ZPRCTAB"  })
	Local _nValComiss   := 0
	Local _nVaPed       := 0
	Local _nVaPsc       := 0
	Local _cOper        := GetMv("ST_OPERFAT",,'02')
	Local _cOpeTran     := GetMv('ST_OPERBLQ',,'94')//TIPO DE OPERAÇÃO NAO ENTRA EM REGRAS COMERCIAIS  ....utiliza preço de custo sb2
	Local _nPosOper	    := aScan(aHeader, { |x| Alltrim(x[2]) =="C6_OPER"  }) 	// OPER
	Local _nVaCif		:= 0
	Local nVlrST	    := 0
	Local nVlrIPI	    := 0
	Local  i	    := 0
	Local  J	    := 0
	Local _nPosIPI    := aScan(aHeader, { |x| Alltrim(x[2]) =="C6_ZVALIPI"  })
	Local _nPosST     := aScan(aHeader, { |x| Alltrim(x[2]) =="C6_ZVALIST"  })

	//FR - #20210929020425 - Validação do armazém apenas qdo a operação que estiver no C6_OPER for igual ao do parâmetro abaixo:
	Local cOperVALLOC  := GetNewPar("ST_OPERLOC",'01')  //TIPO OPERAÇÃO QUE VALIDA VALIDA O ARMAZÉM DO PRODUTO

	If ( Type("l410Auto") == "U" .OR. !l410Auto )  .and. !IsInCallSteck("U_STFAT15")

		//Chamado 008763
		If ( INCLUI .And. (!Empty(M->C5_XDE) .Or. !Empty(M->C5_XATE) .Or. !Empty(M->C5_XMDE) .Or. !Empty(M->C5_XMATE) .Or. !Empty(M->C5_XDANO) .Or. !Empty(M->C5_XAANO) ) .And.;
		(M->C5_VEND1 $ GetMv("ST_VENDENG",,"I08595#I08598#I08569#I08588") .Or. M->C5_VEND2 $ GetMv("ST_VENDENG",,"I08595#I08598#I08569#I08588") ) )

			_cCaminho 	:= ""
			_cCopia 	:= "bruno.galvao@steck.com.br"
			_cEmail		:= "filipe.nascimento@steck.com.br"
			_cAssunto 	:= "Alteração de data de programação: "+M->C5_NUM
			_aAttach    := {}

			cMsg := ""
			cMsg += '<html><head><title></title></head><body>
			cMsg += "Em "+DTOC(Date())+" - "+Time()+" por "+cUserName+" - MATA410<br><br>
			cMsg += "<table border='1'><tr><td>Campo</td><td>Alterado de</td><td>Alterado para</td>
			cMsg += '<tr><td>Dia De</td><td>Vazio</td><td>'+M->C5_XDE+'</td></tr>
			cMsg += '<tr><td>Dia Ate</td><td>Vazio</td><td>'+M->C5_XATE+'</td></tr>
			cMsg += '<tr><td>Mes De</td><td>Vazio</td><td>'+M->C5_XMDE+'</td></tr>
			cMsg += '<tr><td>Mes Ate</td><td>Vazio</td><td>'+M->C5_XMATE+'</td></tr>
			cMsg += '<tr><td>Ano de</td><td>Vazio</td><td>'+M->C5_XDANO+'</td></tr>
			cMsg += '<tr><td>Ano Ate</td><td>Vazio</td><td>'+M->C5_XAANO+'</td></tr>
			cMsg += '</table></body></html>'

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

		ElseIf ( ALTERA .And. (!(M->C5_XDE==SC5->C5_XDE) .Or. !(M->C5_XATE==SC5->C5_XATE) .Or. !(M->C5_XMDE==SC5->C5_XMDE) .Or. !(M->C5_XMATE==SC5->C5_XMATE) .Or. !(M->C5_XDANO==SC5->C5_XDANO) .Or. !(M->C5_XAANO==SC5->C5_XAANO) ) .And.;
		(M->C5_VEND1 $ GetMv("ST_VENDENG",,"I08595#I08598#I08569#I08588") .Or. M->C5_VEND2 $ GetMv("ST_VENDENG",,"I08595#I08598#I08569#I08588") ) )

			_cCaminho 	:= ""
			_cCopia 	:= "bruno.galvao@steck.com.br"
			_cEmail		:= "filipe.nascimento@steck.com.br"
			_cAssunto 	:= "Alteração de data de programação: "+M->C5_NUM
			_aAttach    := {}

			cMsg := ""
			cMsg += '<html><head><title></title></head><body>
			cMsg += "Em "+DTOC(Date())+" - "+Time()+" por "+cUserName+" - MATA410<br><br>
			cMsg += "<table border='1'><tr><td>Campo</td><td>Alterado de</td><td>Alterado para</td>
			cMsg += '<tr><td>Dia De</td><td>'+SC5->C5_XDE+'</td><td>'+M->C5_XDE+'</td></tr>
			cMsg += '<tr><td>Dia Ate</td><td>'+SC5->C5_XATE+'</td><td>'+M->C5_XATE+'</td></tr>
			cMsg += '<tr><td>Mes De</td><td>'+SC5->C5_XMDE+'</td><td>'+M->C5_XMDE+'</td></tr>
			cMsg += '<tr><td>Mes Ate</td><td>'+SC5->C5_XMATE+'</td><td>'+M->C5_XMATE+'</td></tr>
			cMsg += '<tr><td>Ano de</td><td>'+SC5->C5_XDANO+'</td><td>'+M->C5_XDANO+'</td></tr>
			cMsg += '<tr><td>Ano Ate</td><td>'+SC5->C5_XAANO+'</td><td>'+M->C5_XAANO+'</td></tr>
			cMsg += '</table></body></html>'

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

		EndIf
		//--------------------------------------
		
		u_ST31GAP()//giovani&jefferson  19/02/14 (erro c6_comis2)
		If aCols[n,_nPosOper]  $ _cOpeTran
			//u_ST31GAP()//giovani&jefferson  19/02/14 (erro c6_comis2)
			For i:= 1 To Len(Acols)
				If !aCols[i,Len(aHeader)+1]
					aCols[i,_nBloqIt]:= '3'
				EndIf
			Next i

			M->C5_ZBLOQ   := '2'
			M->C5_ZMOTBLO := ''
			Return(lRet)
		EndIf

		For i:= 1 To Len(Acols)

			If aCols[i,Len(aHeader)+1] = .F.

				If Empty(Alltrim(M->C5_VEND3))
					aCols[i,_nPosCom1]   := u_ValPorComiss(aCols[i,_nPosProd],M->C5_VEND1)     //atualiza a porcetagem da comissao por item
					aCols[i,_nPosComiss] := Round(((aCols[i,_nPosTotItem]*aCols[i,_nPosCom1])/100),2)//atualiza a comissao por item
				EndIf

				If !Empty(Alltrim(M->C5_VEND2))   .And. !Empty(Alltrim(M->C5_VEND1))  .And. M->C5_VEND2 = M->C5_VEND1
					aCols[i,_nPosCom2]   := 0
				Else
					aCols[i,_nPosCom2]  :=	Posicione("SA3",1,xFilial("SA3")+M->C5_VEND2,"A3_COMIS")
				EndIf
				aCols[i,_nPosDESC]      := 0
				aCols[i,_nPosVALDESC]   := 0
				_nValComiss += aCols[i,_nPosComiss]
				_nVaPed     += aCols[i,_nPosTotItem]
				nVlrST	   += aCols[i,_nPosQtdVen]  * aCols[i,_nPosST]
				nVlrIPI	   +=  aCols[i,_nPosQtdVen]  * aCols[i,_nPosIPI]

				DbSelectArea("SC6")
				SC6->(DbSetOrder(1))
				If SC6->(DbSeek(xFilial("SC6")+aCols[i,_nPosProd]+ aCols[i,_nPosItem]  ))
					aCols[i,_nPosQtLIB]   :=	aCols[i,_nPosQtdVen]-SC6->C6_QTDENT
				EndIf
				aCols[i,_nPosQatu]    :=  u_versaldo(aCols[i,_nPosProd])//atualizo saldo pro relatorio
				//	aCols[i,_nPosdtentr]  :=  u_atudtentre(aCols[i,_nPosQatu],aCols[i,_nPosProd],aCols[i,_nPosQtdVen])//atualizo data pro relatorio
			EndIf

			If 	aCols[i,_nPosZPrc] >  	aCols[i,_nPosPrcven]  .And. !('ATUA' $  M->C5_ZMOTBLO) .AND. aCols[i,Len(aHeader)+1] = .F.
				M->C5_ZBLOQ   :=   "1"
				M->C5_ZMOTBLO :=   ALLTRIM(M->C5_ZMOTBLO)+'ATUA/'
				//aCols[i,_nBloqIt]
			EndIf

			//fazer bloqueio de markup aqui mkp

			/**********************************
			Chamado....: 20211104023664
			Alteração..: Incluido tratamento para ignorar linha deletada
			Analista...: Marcelo Klopfer Leme - Sigamat
			Data.......: 12/11/2021
			**********************************/
			IF aCols[i,Len(aHeader)+1] = .F.
				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				If SB1->(DbSeek(xFilial("SB1")+aCols[i][_nPosProd]))
					If 	aCols[i,_nPosLocal] <> SB1->B1_LOCPAD .And. aCols[i,_nPosProd]<>"SCONSULTA" .And. cFilAnt=="02"
						
						//FR - #20210929020425 - Validação do armazém apenas qdo a operação que estiver no C6_OPER estiver contida no parâmetro abaixo:
						If aCols[i,_nOper] $ cOperVALLOC		//se a operação for = '01' valida o armazém
							lRet:=.F.
							/**********************************
							Chamado....: 20211104023664
							Alteração..: Retirar mesnsagem de contato com a TI, Substituir pela rotina AVISO pasando os procedimentos.
							Analista...: Marcelo Klopfer Leme - Sigamat
							Data.......: 12/11/2021
							MSGINFO("Favor Contactar o Renato ou Jefferson do T.I. ....  " + CRLF + "Erro: Local Diferente Do Cadastro Produto -> " + SB1->B1_LOCPAD )
							**********************************/
							AVISO("Divergência entre armazéns",;
										"Divergência entre o Armazém padrão e o armazém no item do pedido."+CRLF+;
										"Armazém Padrão....: "+ALLTRIM(SB1->B1_LOCPAD)+CRLF+;
										"Armazém Pedido....: "+ALLTRIM(aCols[i,_nPosLocal])+CRLF+CRLF+;
										"<<< P R O C E D I M E N T O >>>"+CRLF+;
										"1 - Contate o comercial para ALTERAR o pedido de venda. "+ALLTRIM(M->C5_NUM)+CRLF+;
										"2 - EXCLUIR o item "+ALLTRIM(aCols[i][_nPosItem])+" - "+ALLTRIM(aCols[i][_nPosProd])+" do pedido."+CRLF+;
										"3 - Salve o pedido."+CRLF+;
										"4 - ALTERE o pedido e INCLUA novamente o produto: "+ALLTRIM(aCols[i][_nPosProd])+CRLF+;
										"5 - Salve o pedido.", {"OK"}, 3)
						Endif

					EndIf
				EndIf
			ENDIF

		Next i

		If Empty(Alltrim(M->C5_VEND3))
			M->C5_COMIS1:=  ((_nValComiss*100)/_nVaPed)
		EndIf
		If ( M->C5_XVALRA3+M->C5_XVALRA4+M->C5_XVALRA5 ) <> _nValComiss-M->C5_XVALRA1   .And.  (M->C5_XVALRA3+M->C5_XVALRA4+M->C5_XVALRA5) <> 0
			msginfo('Valor do Rateio Divergente do Valor da Comissão, Ajuste o Rateio!!!!!!!!!!!!!!!!')
			lRet:=.F.
		EndIf

		If M->C5_XTIPF <> '1' .And.  (M->C5_XVALRA3+M->C5_XVALRA4+M->C5_XVALRA5) <> 0
			MSGINFO('Rateio Disponivél Apenas Para Tipo de Fatura TOTAL')
			lRet:=.F.
		EndIf

		If ! ('VLR' $	ALLTRIM(M->C5_ZMOTBLO))
			If _nVaPed < 	M->C5_XLIMLIB
				M->C5_ZBLOQ   :="1"
				M->C5_ZMOTBLO := 	ALLTRIM(M->C5_ZMOTBLO)+'VLR/'

			EndIf
		EndIf

		//FR - 04/10/2021 - #20210930020494 - Pedido beneficiamento não pode cair na regra comercial
		//If !M->C5_TIPO $ "B/D" //se não utiliza fornecedor, valida regra comercial
		If M->C5_TIPO <> "B" .AND. M->C5_TIPO <> "D"		//FR - 15/10/2021
			//Giovani Zago 16/04/14 Bloqueio Frete Cif
			_nVaCif:=	Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_XCIF")
			If M->C5_TPFRETE == 'C' .And.  _nVaCif > 0
				If (_nVaPed+nVlrIPI+nVlrST) < _nVaCif
					If ! ('FRETE' $	ALLTRIM(M->C5_ZMOTBLO))
						M->C5_ZBLOQ   :="1"
						M->C5_ZMOTBLO := ALLTRIM(M->C5_ZMOTBLO)+'FRETE/'
					EndIf
				Endif
			Endif

		Elseif M->C5_TIPO $ "B/D"

			M->C5_ZBLOQ   := '2'
			M->C5_ZMOTBLO := ''			

		Endif
		//FR - 04/10/2021 - #20210930020494
		//****************************************

		If ! ('MSG' $	ALLTRIM(M->C5_ZMOTBLO))
			If 	aCols[n,_nOper] $ _cOper
				M->C5_ZBLOQ   :="1"
				M->C5_ZMOTBLO := 	ALLTRIM(M->C5_ZMOTBLO)+'OPER/'
			EndIf
		EndIf

		For j:= 1 To Len(Acols)

			If !aCols[j,Len(aHeader)+1]
				If  aCols[j,_nPosPrcven]  = 0.01
					_nVaPsc++
				EndIf
			EndIf
		NEXT j
		If _nVaPsc = 0
			M->C5_ZMOTBLO:=	StrTran (ALLTRIM(M->C5_ZMOTBLO),'PSC/',"")
			If Empty(alltrim(M->C5_ZMOTBLO))
				M->C5_ZBLOQ   :="2"
			EndIf
		Else
			M->C5_ZBLOQ   :=  "1"
			M->C5_ZMOTBLO := 	ALLTRIM(M->C5_ZMOTBLO)+'PSC/'
		EndIf

		//	U_STMAFISRET()
		u_STVALLIQUI()//giovani Zago 31/05/2013

	EndIf

	If lRet .And. GetMv("ST_GAP31A",,.F.)
		For i:= 1 To Len(Acols)
			If !aCols[i,Len(aHeader)+1] .And. lRet
				If 	aCols[n,_nOper] = '01'
					If aCols[i,_nPosPrcven]  <> aCols[i,_nPosPrUnit]
						lRet:= .F.
						MsgInfo("Pedido possui Divergencia de Valores.....Verifique os Itens....!!!!!")
					EndIf
				EndIf
			EndIf
		Next i
	EndIf

	If (M->C5_ZBLOQ == "1" )
		cMsg := "O pedido de venda encontra-se bloqueado. Entre em contato com seu supervisor para que o mesmo libere este pedido de venda!"
		MsgAlert(cMsg)		//FR - 05/10/2021 - mensagem q informa o motivo do bloqueio
	Endif

	M->C5_ZDTJOB := CTOD('  /  /    ')
	M->C5_ZMOTREJ:= ' '
	Restarea(aArea)
Return( lRet)

