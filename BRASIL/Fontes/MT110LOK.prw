#INCLUDE "PROTHEUS.CH" 
#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MT110LOK ³ Autor ³ Ricardo Posman      ³ Data ³  01.06.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o c Ponto de Entrada para validar quantidade digitada na Solici-³±±
±±³          c tacao de compra contra Lote Economico do Produto            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico STECK                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± 20210701011385															±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT110LOK()

	Local _aArea    := GetArea()
	Local _nPosQtde,_nPosProd,_nLE, _nPosUm
	Local nPosPrd   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})
	Local nPosCC	  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_CC'})
	Local lValido	  := .T.
	Local _nPosForn := aScan(aHeader,{|x| AllTrim(x[2])=="C1_FORNECE"})
	Local _nPosLoja := aScan(aHeader,{|x| AllTrim(x[2])=="C1_LOJA"})

	//Chamado 002612
	
	If !l110Auto
		_nPosQtde  := ASCAN(aHeader, {|x| UPPER(ALLTRIM(X[2])) == "C1_QUANT"})
		_nPosUm    := ASCAN(aHeader, {|x| UPPER(ALLTRIM(X[2])) == "C1_UM"})
		_nPosProd  := ASCAN(aHeader, {|x| UPPER(ALLTRIM(X[2])) == "C1_PRODUTO"})
		_nLE       := Posicione("SB1",1,xFilial("SB1")+aCols[n,_nPosProd],"B1_LE")

/*		20230920011837 - comentado a validação, pois, estava gerando erro na definição do aprovador 
        IF aCols[n,_nPosQtde] < _nLE

			MSGALERT("Atencao, este produto possui lote de compra de "+Str(_nLE)+ " "+aCols[n,_nPosUm]+".")
			lValido := .F.
		endif
*/		
		dbSelectArea('SB1')
		dbSetOrder(1)
		If MsSeek(xFilial('SB1')+aCols[n][nPosPrd])
			If !SB1->B1_TIPO$"MP,EM,PA,PI,PP,BN,IC" .AND. Empty(aCols[n][nPosCC])
				lValido := .F.
				MsgAlert("Centro de Custo Obrigatorio!!!")
			EndIf
		EndIf
	Endif
	//Chamado 002612

	//Chamado 002995
	
	If lValido
		If !aCols[n][len(aHeader)+1] .And. !Empty(aCols[n][_nPosForn]) .And. !Empty(aCols[n][_nPosLoja])
			lValido := U_STVLDSA2(aCols[n][_nPosForn],aCols[n][_nPosLoja]) //Chamado 002995
		EndIf
	Endif

	/*
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
	±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	*/
	
	If lValido
		lValido := VLDLINSC()
	Endif
	/*
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±ºChamado   ³ 20230209001655 Solicitacoes de compra Urgente               º±±
	±±ºSolic.    ³ Leandro Godoy - Depto. Compras                           º±±
	±±ºSolic.    ³ Leandro Godoy - Depto. Compras                           º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	*/	
	lValido := U_VLDXTIPSC()


	RestArea(_aArea)

Return lValido

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VLDLINSC     ºAutor  ³Joao Rinaldi    º Data ³  01/02/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função desenvolvida para validar a linha da Solicitação    º±±
±±º          ³ de Compra                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VLDLINSC()

	Local _lLinOk     := .T.
	Local aArea1      := GetArea()
	Local aArea2      := SC1->(GetArea())
	Local aArea3      := SZI->(GetArea())
	Local aArea4      := SZJ->(GetArea())
	Local aArea5      := SX3->(GetArea())
	Local aArea6      := SB1->(GetArea())

	Local _nPosItem   := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_ITEM"})
	Local _nPosUser   := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_USER"})
	Local _nPoscc     := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_CC"})
	Local _nPosAprov  := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_ZAPROV"})
	Local _cAprovp    := ''
	Local _nPosCompSt := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_COMPSTK"})
	Local _nPosCodComp:= aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_CODCOMP"})
	Local _nPosRecno  := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_REC_WT"})
	Local _nPosNomeAp := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_ZNOMEAP"})
	Local _nPosStatus := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_ZSTATUS"})
	Local _nPos2Status:= aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_ZSTATU2"})
	Local _nPosAnexo  := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_ZANEXO"})
	Local _nPosMotivo := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_MOTIVO"})
	Local _nJ
	Local _cNewValue  := ''
	Local _cOldValue  := ''
	Local _cStatus    := ''
	Local _nPosQtde   := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_QUANT"})
	Local _nPosProd   := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_PRODUTO"})

	If !(AllTrim(aCols[n][_nPosMotivo])=="MRP") //Chamado 003641

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Validação do preenchimento do Centro de Custo
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(aCols[n][_nPoscc]) .And. !aCols[n][len(aCols[n])]
			Aviso("Inclusão de Solicitação de Compras"; //01 - cTitulo - Título da janela
			,"O preenchimento do " + Alltrim(RetTitle("C1_CC")) + " é Obrigatório."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Você não poderá confirmar o Item."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
			,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
			)
			_lLinOk := .F.

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Validação para não permitir que a linha Analisada, Aprovada, e Rejeitada pelo Gestor e por Compras não seja alterada
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (aCols[n][_nPosRecno]) > 0
			If !(aCols[n][_nPosStatus]  == '1' .Or. aCols[n][_nPosStatus] == ' ')
				If (aCols[n][len(aCols[n])])
					If aCols[n][_nPosStatus]     == '2'
						_cStatus := 'Analisado Pelo Gestor'
					ElseIf aCols[n][_nPosStatus]  == '3' .Or. aCols[n][_nPosStatus] == '6'
						_cStatus := 'Aprovado Pelo Gestor'
					ElseIf aCols[n][_nPosStatus]  == '4'
						_cStatus := 'Rejeitado Pelo Gestor'
					ElseIf aCols[n][_nPosStatus]  == '5'
						_cStatus := 'Rejeitado por Compras'
					Endif
					Aviso("Item "+_cStatus; //01 - cTitulo - Título da janela
					,"Item "+Alltrim(aCols[n][_nPosItem])+" da Solicitação de Compra com Status '"+_cStatus+"' não pode ser deletado."+ Chr(10) + Chr(13) +;
						CHR(10)+CHR(13)+;
						"Favor recuperar o registro pressionando o botão Delete novamente.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
					,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
					)
					_lLinOk := .F.
				Else
					SC1->(DbGoto(aCols[n][_nPosRecno]))
					DbSelectArea("SX3")
					SX3->(DbGoTop())
					SX3->(DbSetOrder(1))
					SX3->(DbSeek("SC1"))
					While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="SC1"
						If !((SX3->X3_CONTEXT) == 'V') .And. (SX3->X3_TIPO $ 'C/N/D')
							For _nJ := 1 to Len(aHeader)
								If (Alltrim(aHeader[_nJ][2]) == Alltrim(SX3->X3_CAMPO))
									If  !((aCols[n][_nJ])  ==  (&("SC1->"+SX3->X3_CAMPO)))
										DO CASE
										CASE AllTrim(SX3->X3_TIPO)=="C"
											_cNewValue := (aCols[n][_nJ])
											_cOldValue := (&("SC1->"+SX3->X3_CAMPO))
										CASE AllTrim(SX3->X3_TIPO)=="N"
											_cNewValue := (CVALTOCHAR(aCols[n][_nJ]))
											_cOldValue := (CVALTOCHAR(&("SC1->"+SX3->X3_CAMPO)))
										CASE AllTrim(SX3->X3_TIPO)=="D"
											_cNewValue := (DTOC(aCols[n][_nJ]))
											_cOldValue := (DTOC(&("SC1->"+SX3->X3_CAMPO)))
										ENDCASE
										If aCols[n][_nPosStatus]     == '2'
											_cStatus := 'Analisado Pelo Gestor'
										ElseIf aCols[n][_nPosStatus]  == '3' .Or. aCols[n][_nPosStatus] == '6'
											_cStatus := 'Aprovado Pelo Gestor'
										ElseIf aCols[n][_nPosStatus]  == '4'
											_cStatus := 'Rejeitado Pelo Gestor'
										ElseIf aCols[n][_nPosStatus]  == '5'
											_cStatus := 'Rejeitado por Compras'
										Endif
										Aviso("Item "+_cStatus; //01 - cTitulo - Título da janela
										,"Item "+Alltrim(aCols[n][_nPosItem])+" da Solicitação de Compra com Status '"+_cStatus+"' não pode sofrer alterações."+ Chr(10) + Chr(13) +;
											CHR(10)+CHR(13)+;
											"Campo Alterado : "+SX3->X3_TITULO+ Chr(10) + Chr(13) +;
											"Conteúdo Antigo: "+_cOldValue+ Chr(10) + Chr(13) +;
											"Conteúdo Novo  : "+_cNewValue+ Chr(10) + Chr(13) +;
											CHR(10)+CHR(13)+;
											"Favor manter o campo "+Alltrim(SX3->X3_TITULO)+" com o Conteúdo Antigo.",; //02 - cMsg - Texto a ser apresentado na janela.
										{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
										,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
										,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
										,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
										,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
										,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
										,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
										,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
										)
										_lLinOk := .F.
									EndIf
								Endif
							Next _nJ
						Endif
						SX3->(DbSkip())
					EndDo
				Endif
			Endif
		Endif

	EndIf

	// Richard - 26/04/18
	If AllTrim(aCols[n][_nPosMotivo]) == "MRP" .And. Empty(aCols[n][_nPoscc])

		If cEmpAnt == '01' .and. cFilAnt == '02'
			aCols[n][_nPoscc] := '115108'
		ElseIf cEmpAnt == "03"
			aCols[n][_nPoscc] := '120208'
		ElseIf cEmpAnt == '01' .and. cFilAnt == '05'
			aCols[n][_nPoscc] := '120208'
		Else
			aCols[n][_nPoscc] := '120108' //Cc Montagem Manual
		EndIf

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validação do código do Centro de Custo e atualização dos campos com o código e nome do aprovador, bem como o status do aprovador e a quantidade de anexos da SC
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _lLinOk .And. !(aCols[n][len(aCols[n])]) .AND. AllTrim(FUNNAME())<>"JOBM712" //FMT
		DbSelectArea("SZI")
		SZI->(DbSetOrder(3))//ZI_FILIAL+ZI_CC+ZI_APROVP
		SZI->(DbGoTop())
		If DbSeek(xFilial("SZI")+(aCols[n][_nPoscc]))
			_cAprovp := SZI->ZI_APROVP
			DbSelectArea("SZJ")
			SZJ->(DbSetOrder(3))//ZJ_FILIAL+ZJ_SOLICIT+ZJ_APROVP
			SZJ->(DbGoTop())
			//If DbSeek(xFilial("SZJ")+(__cUserId)+(_cAprovp)) // Alterado a busca para atender a necessidade da Rotina de Beneficiamento - Robson Mazzarotto
			IF !EMPTY(SC5->C5_XUSER)
				_cSolici := SC5->C5_XUSER
			ELSE
				_cSolici := __cUserId
			ENDIF
			If DbSeek(xFilial("SZJ")+(_cSolici)+(_cAprovp))
				If aCols[n][_nPosStatus]  == '1' .Or. aCols[n][_nPosStatus] == ' '
					aCols[n][_nPosStatus] := '1'
				Endif
				aCols[n][_nPosAprov]   := _cAprovp
				aCols[n][_nPosNomeAp]  := USRRETNAME(_cAprovp)
				aCols[n][_nPos2Status] := '5'//Substr(U_STCOM022('4',_cAprovp),1,1)
				aCols[n][_nPosAnexo]   := (ADir("\arquivos\SC\"+cEmpAnt+"\"+cFilAnt+"\"+(CA110NUM)+"\*.MZP*"))
			Else
				Aviso("Inclusão de Solicitação de Compras"; //01 - cTitulo - Título da janela
				,"O seu código de usuário não está vinculado com o " + Alltrim(RetTitle("C1_CC")) + " " + Alltrim(aCols[n][_nPoscc]) + "."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Você não poderá confirmar o Item."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
				,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
				)
				_lLinOk := .F.
			Endif
		Else
			Aviso("Inclusão de Solicitação de Compras"; //01 - cTitulo - Título da janela
			,"O " + Alltrim(RetTitle("C1_CC")) + " " + Alltrim(aCols[n][_nPoscc]) + " não foi cadastrado para utilização."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Você não poderá confirmar o Item."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
			,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
			)
			_lLinOk := .F.
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validação do Lote Mínimo e Múltiplos versus a quantidade digitada na SC
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _lLinOk .And. !(aCols[n][len(aCols[n])]) .And. (aCols[n][_nPosStatus] == '1')

		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))//B1_FILIAL+B1_COD
		SB1->(DbGoTop())
		If DbSeek(xFilial("SB1")+(aCols[n][_nPosProd]))
			_cUM     := SB1->B1_UM//Unidade de medida
			_nMultip := SB1->B1_QE//Múltiplos
			_nLotEco := SB1->B1_LE//Lote Econômico
			If !(SB1->B1_TIPO="PA" .OR. SB1->B1_TIPO="BN")

				If aCols[n,_nPosQtde] < _nLotEco
					Aviso("Lote Econômico"; //01 - cTitulo - Título da janela
					,"O Produto "+Alltrim(aCols[n][_nPosProd])+" possui " +Alltrim(RetTitle("B1_LE"))+ " de Compra e a " +Alltrim(RetTitle("C1_QUANT"))+ " Desejada está divergente."+ Chr(10) + Chr(13) +;
						CHR(10)+CHR(13)+;
						Alltrim(RetTitle("B1_LE"))+" : " + cValtoChar(_nLotEco)+;
						CHR(10)+CHR(13)+;
						Alltrim(RetTitle("C1_QUANT"))+"    : " + cValtoChar(aCols[n,_nPosQtde])+ Chr(10) + Chr(13) +;
						CHR(10)+CHR(13)+;
						"Favor solicitar uma Quantidade que atenda o " +Alltrim(RetTitle("B1_LE"))+ "."+;
						CHR(10)+CHR(13)+;
						"Qualquer dúvida acione o Departamento de Compras.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,"Produto: "+Alltrim(aCols[n][_nPosProd])+" / Unidade de Medida: "+_cUM;//05 - cText - Titulo da Descrição (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
					,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
					)
					_lLinOk := .F.

				ElseIf aCols[n,_nPosQtde]/_nMultip > 0
					If At(".",Cvaltochar(aCols[n,_nPosQtde]/_nMultip)) > 0
						Aviso("Múltiplo de Quantidade"; //01 - cTitulo - Título da janela
						,"O Produto "+Alltrim(aCols[n][_nPosProd])+" possui " +Alltrim(RetTitle("B1_QE"))+ " de Compra e a " +Alltrim(RetTitle("C1_QUANT"))+ " Desejada está divergente."+ Chr(10) + Chr(13) +;
							CHR(10)+CHR(13)+;
							Alltrim(RetTitle("B1_QE"))+" : " + cValtoChar(_nMultip)+;
							CHR(10)+CHR(13)+;
							Alltrim(RetTitle("C1_QUANT"))+"    : " + cValtoChar(aCols[n,_nPosQtde])+ Chr(10) + Chr(13) +;
							CHR(10)+CHR(13)+;
							"Favor solicitar uma Quantidade que atenda a " +Alltrim(RetTitle("B1_QE"))+ "."+;
							CHR(10)+CHR(13)+;
							"Qualquer dúvida acione o Departamento de Compras.",; //02 - cMsg - Texto a ser apresentado na janela.
						{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
						,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
						,"Produto: "+Alltrim(aCols[n][_nPosProd])+" / Unidade de Medida: "+_cUM;//05 - cText - Titulo da Descrição (Dentro da Janela)
						,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
						,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
						,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
						,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
						,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
						)
						_lLinOk := .F.
					Endif
				Endif
			Endif
		Endif
	Endif
	RestArea(aArea6)
	RestArea(aArea5)
	RestArea(aArea4)
	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)

Return (_lLinOk)
User Function VLDXTIPSC()
Local lRet := .T. 
Local aArea1      := GetArea()
Local aArea2      := SC1->(GetArea())
Local _nPosCompSt := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_XTIPOSC"})
Local _nXPosObs  := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C1_XOBSTPS"})  
If aCols[n][_nPosCompSt] == '002' .and. !(aCols[n][len(aCols[n])]) // Configurado como URGENTE
	If !Empty(aCols[n][_nXPosObs])
		lRet := .T. 
	Else
		Aviso("Inclusão de Solicitação de Compras"; //01 - cTitulo - Título da janela
				,"Para Solicitaçoes do tipo Urgente e necessario o preenchimento do campo Observação Tipo."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Você não poderá confirmar o Item."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
				,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
				)
				lRet := .F. 
	Endif
Endif

RestArea(aArea1)
RestArea(aArea2)
Return lRet
