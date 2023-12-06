#INCLUDE "Protheus.ch"
#DEFINE CR    chr(13)+chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT121BRW     �Autor  �Joao Rinaldi    � Data �  24/02/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada utilizado na rotina de pedidos de compra  ���
���          � para adicionar op��es ao array aRotina que cont�m os menus ���
���          � do programa.                                               ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������͹��
���Chamado   � 002612 - Automatizar Solicita��o de Compras                ���
���Solic.    � Juliana Queiroz - Depto. Compras                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT121BRW()

	//������������������������������������������������������������������������Ŀ
	//�Declara��o das Vari�veis
	//��������������������������������������������������������������������������
	Local aArea1    := GetArea()
	//Local aArea2    := SC1->(GetArea())
	//Local aArea3    := SY1->(GetArea())
	Local _cProgram := ALLTRIM(UPPER(funname()))

	If !Empty(_cProgram)
		DbSelectArea("SY1")
		SY1->(DbSetOrder(3))//Y1_FILIAL+Y1_USER
		SY1->(DbGoTop())
		If DbSeek(xFilial("SY1")+__cUserId)
			aAdd(aRotina,{"Gerar PV antigo","U_STGERSC5()", 0, Len(aRotina)+1, 0, .F. }) //Chamado 000784
			aAdd(aRotina,{"Gerar PV novo","u_StWeb070(2)", 0, Len(aRotina) + 1, 0, .F. }) // Chamado 000784		// Antigo: STGERSC5
			aAdd(aRotina,{"Imprimir P.C.","U_RSTFAT92()", 0, Len(aRotina)+1, 0, .F. }) //Chamado 000784
			aAdd(aRotina,{"Eliminar Residuo","U_MSTECK27()", 0, Len(aRotina)+1, 0, .F. }) //Chamado 000784
		Else
			Aviso("Cadastro de Comprador"; //01 - cTitulo - T�tulo da janela
			,"Voc� n�o est� cadastrado como Comprador."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Voc� n�o ter� acesso a nenhuma funcionalidade."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"A��o n�o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as op��es dos bot�es.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
			,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
			)
			aRotina := {}
			aAdd(aRotina,{"Visualizar","A120Pedido", 0,2,0,Nil})
		Endif
	Endif

	aAdd(aRotina,{"Alterar OP","U_STALTOP()", 0, Len(aRotina)+1, 0, .F. }) //Chamado 000784

	//RestArea(aArea3)
	//RestArea(aArea2)
	RestArea(aArea1)

Return(aRotina)


/****************************
A��o...........: Rotina para icnlus�o de Bot�es no Outras A��es dentro do Pedido de Compras
Desenvolvedor..: Desconhecido
Data...........: Desconhecida
Chamado........: Desconhecido
<<< Altera��o >>> 
A��o...........: Incluir a rotina para inportar itens para dendo do pedido de compras atrav�s de um arquivo CSV
...............: Fonte se chamado MSTECK06.PRW
Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
Data...........: 07/12/2021
Chamado........: 20211203025901
*****************************/
User Function  MA120BUT()
	Local _aButtons := {}
	If cEmpAnt = '03'
		//aAdd(_aButtons,{"xPrc.Steck","u_PrcTrans()", 0, Len(aRotina)+1, 0, .F. }) //Chamado 000784
		aAdd(_aButtons,{"xPrc.Steck" ,{|| u_PrcTrans()}	,"Prc.Steck","Prc.Steck"})
	EndIf
	aAdd(_aButtons,{"xAnexo" ,{|| U_STAnexoV('SC7', 'AutorizacaoEntrega', {'C7_FILIAL','C7_USER','NOUSER'},,SC7->C7_NUM)}	,"Anexar Documento","Anexar Documento"})         // Valdemir Rabelo Ticket: 20210623010642 - 29/06/2021
	AADD(_aButtons,{"xPlancsv",{|| U_MSTECK06()},"Importar Pedido","Importar Pedido"})

Return(_aButtons)

User Function  STALTOP()

	Local _aParamBox := {}
	Local _aRet		 := {}

	AADD(_aParamBox,{1,"OP",Space(11) ,"","","SC2","",0,.F.})

	If !ParamBox(_aParamBox,"Selecionar OP",@_aRet,,,.T.,,500)
		Return
	EndIf

	DbSelectArea("SC2")
	SC2->(DbSetOrder(1))
	If !SC2->(DbSeek(xFilial("SC2")+MV_PAR01))
		MsgAlert("OP n�o encontrada, verifique!")
	EndIf

	//_cFilial := SC7->C7_FILIAL
	//_cPedido := SC7->C7_NUM

	//_aAreaSC7 := SC7->(GetArea())
	//SC7->(DbSetOrder(1))
	//SC7->(DbSeek(_cFilial+_cPedido))
	//While SC7->(!Eof()) .And. SC7->(C7_FILIAL+C7_NUM)==_cFilial+_cPedido
		SC7->(RecLock("SC7",.F.))
		SC7->C7_OP := MV_PAR01
		SC7->(MsUnLock())
	//	SC7->(DbSkip())
	//EndDo
	//RestArea(_aAreaSC7)

	MsgAlert("OP alterada com sucesso!")

Return()



User Function PrcTrans( )
	Local nPosXPrc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_XPRCORC"})
	Local nPosPrc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRECO"})
	Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRODUTO"})
	Local nPQtd 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_QUANT"})
	Local nPosNumSc := ASCAN(aHeader,{|x| AllTrim(x[2]) == "C7_NUMSC"})
	Local nPosItSc  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "C7_ITEMSC"})
	Local _nPosTot	:= ASCAN(aHeader,{|x| AllTrim(x[2]) == "C7_TOTAL"})
	Local nX        := 0
	Local _cMsg     := ' '
	Local _nTot 	:= 0
	Public l120Auto := .t.

	Public Altera:= .t.
	If  INCLUI
		_nOld :=n
		For nX := 1 To Len(aCols)
			If  !(aCols[nX][Len(aCols[nX])])
				DbSelectArea("DA1")
				DA1->(DbSetOrder(1))
				If DA1->(DbSeek(xFilial("DA1")+'T01'+aCols[nX][nPProduto]))
					n:= nx
					aCols[nX][nPosPrc] :=  DA1->DA1_PRCVEN
					aCols[nX][nPosXPrc]:=  DA1->DA1_PRCVEN


					//MaFisAlt("IT_PRCUNI",DA1->DA1_PRCVEN,nX)
					MaFisRef("IT_PRCUNI","MT120",DA1->DA1_PRCVEN)
					aCols[nX][_nPosTot] := NoRound(	aCols[nX][nPosPrc]*	aCols[nX][nPQtd],TamSX3("C7_TOTAL")[2])
					_nTot+=	aCols[nX][_nPosTot]
					MaFisRef("IT_VALMERC","MT120",	aCols[nX][_nPosTot])
					//MaFisAlt("IT_VALMERC",aCols[nX][_nPosTot],nX)
					//MTA121TROP(nX)
					A120Total(	aCols[nX][_nPosTot])
				Else
					_cMsg += "Produto Sem Pre�o de Transferencia: "+aCols[nX][nPProduto] + CR
				EndIf
			EndIf
		Next nX
		n:= _nOld
	EndIf
	Altera:= .f.
	If !(Empty(Alltrim(_cMsg)))
		msginfo(_cMsg)
	EndIf
Return()
