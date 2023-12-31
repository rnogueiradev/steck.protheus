#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA110MNU    �Autor  �Joao Rinaldi    � Data �  16/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � O ponto de entrada 'MTA110MNU' � utilizado para            ���
���          � adicionar bot�es ao Menu Principal atrav�s do array aRotina���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � MATA110.PRX                                                ���
���Nome      � Solicita��o de Compra                                      ���
�������������������������������������������������������������������������ͼ��
���Chamado   � 002612 - Automatizar Solicita��o de Compras                ���
���Solic.    � Juliana Queiroz - Depto. Compras                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA110MNU()

	//������������������������������������������������������������������������Ŀ
	//�Declara��o das Vari�veis
	//��������������������������������������������������������������������������
	Local aArea1    := GetArea()
	Local aArea2    := {}//SC1->(GetArea())
	Local aArea3    := {}//SAI->(GetArea())
	Local aArea4    := {}//SY1->(GetArea())
	Local _cProgram := ALLTRIM(UPPER(funname()))
	Local _nI
	Local _lComp    := .F.
	Local _lSolic   := .F.
	Local aProgram  := {}


	//	Adicionado para chamada Faturamento Beneficiamento - Valdemir Rabelo 26/07/2019
	if IsInCallStack( "U_STGerPC" )
		Return .T.
	ENDIF

	//������������������������������������������������������������������������Ŀ
	//�Remove as Op��es de Excluir / Aprovar / C�pia / Cancelar / Banco do Conhecimento
	//��������������������������������������������������������������������������
	If !Empty(_cProgram)
		For _nI := 1 To Len(aRotina)
			If !(Upper(Alltrim(aRotina[_nI,2])) = Upper("A110Deleta");
					.OR. Upper(Alltrim(aRotina[_nI,2])) == Upper("A110Aprov");
					.OR. Upper(Alltrim(aRotina[_nI,2])) == Upper("A110Copia");
					.OR. Upper(Alltrim(aRotina[_nI,2])) == Upper("A110Cancela");
					.OR. Upper(Alltrim(aRotina[_nI,2])) == Upper("MsDocument"))
				If Len(aRotina[_nI]) == 6
					aAdd(aProgram,{(aRotina[_nI,1]),(aRotina[_nI,2]),(aRotina[_nI,3]),(aRotina[_nI,4]),(aRotina[_nI,5]),(aRotina[_nI,6])})
				Endif
			EndIf
		Next _nI
	Endif
	aRotina := {}
	aRotina := ACLONE(aProgram)

	If !Empty(_cProgram)

		DbSelectArea("SY1")
		SY1->(DbSetOrder(3))//Y1_FILIAL+Y1_USER
		SY1->(DbGoTop())
		If DbSeek(xFilial("SY1")+__cUserId)
			_lComp := .T.
		Endif

		If !(_lComp)
			DbSelectArea("SAI")
			SAI->(DbSetOrder(2))//AI_FILIAL+AI_USER
			SAI->(DbGoTop())
			If !DbSeek(xFilial("SAI")+__cUserId)
				Aviso("Cadastro de Solicitante"; //01 - cTitulo - T�tulo da janela
				,"Voc� n�o est� cadastrado como Solicitante de Compras."+ Chr(10) + Chr(13) +;
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
			Else
				_lSolic := .T.
			Endif
		Endif

		If _lComp .Or. _lSolic

			aadd( aRotina, {"Anexar Docs","U_STCOM016(SC1->C1_NUM)",0,Len(aRotina)+1,0,NIL} )
			aadd( aRotina, {"2� Via Aprova��o","U_STCOM019(SC1->C1_NUM,4,SC1->C1_USER)",0,Len(aRotina)+1,0,NIL} )
			aadd( aRotina, {"Tracking S.C.","Alert('Op��o n�o Dispon�vel')",0,Len(aRotina)+1,0,NIL} )
			aadd( aRotina, {"Limpar res�duo","U_STCOM150",0,Len(aRotina)+1,0,NIL} )
			aadd( aRotina, {"Aprova��o digital","U_STCOM160",0,Len(aRotina)+1,0,NIL} )
			If __cUserId $ GetMv("ST_EXCSOL") //Chamado 003676
				aAdd(aRotina, {"Excluir","A110Deleta" ,0,Len(aRotina)+1,0,NIL} )
			EndIf
		Else
			aRotina := {}
		Endif
		If __cuserid $ Getmv("ST_110MEN",,"000000/000645/000172/000215")
			aAdd(aRotina, {"COPIAR","U_STC1COPI(SC1->C1_NUM)"  , 0 , Len(aRotina)+1, 0, nil})
		Endif
	Endif
	//RestArea(aArea4)
	//RestArea(aArea3)
	//RestArea(aArea2)
	RestArea(aArea1)

Return(aRotina)


User Function STC1COPI(cNumSol)

	Local _c1Num := ' '
	Local _aC1   := {}
	Local i:=0
	Dbselectarea("SC1")
	SC1->(Dbsetorder(1))
	If SC1->(dbseek(xfilial("SC1")+cNumSol))
		_c1Num := GETSXENUM("SC1", "C1_NUM")
		SC1->(ConfirmSX8())

		While SC1->(!EOF()) .And. cNumSol = SC1->C1_NUM .And. SC1->C1_FILIAL = xfilial("SC1")
			Aadd(_aC1,{	SC1->C1_FILIAL,;
				SC1->C1_NUM,;
				SC1->C1_ITEM,;
				SC1->C1_PRODUTO,;
				SC1->C1_UM,;
				SC1->C1_QUANT,;
				SC1->C1_MOTIVO,;
				SC1->C1_QTSEGUM,;
				SC1->C1_DATPRF,;
				SC1->C1_LOCAL,;
				SC1->C1_CC,;
				SC1->C1_CONTA,;
				SC1->C1_EMISSAO,;
				SC1->C1_DESCRI,;
				SC1->C1_SOLICIT,;
				SC1->C1_IMPORT,;
				SC1->C1_CODCOMP,;
				SC1->C1_CLASS,;
				SC1->C1_GRUPCOM,;
				SC1->C1_USER,;
				SC1->C1_FILENT,;
				SC1->C1_QTDORIG,;
				SC1->C1_TIPO,;
				SC1->C1_RATEIO,;
				SC1->C1_XEMAIL,;
				SC1->C1_XPRC,;
				SC1->C1_ZAPROV,;
				SC1->C1_ZSTATUS,;
				SC1->C1_ZLOG,;
				SC1->C1_ZMOTREJ;
				})



			SC1->(dBSkip())
		EndDo

		For i:=1 to Len(_aC1)

			SC1->(RecLock("SC1",.T.))

			SC1->C1_FILIAL 	:= _aC1[i,01]
			SC1->C1_NUM 	:= _c1Num
			SC1->C1_ITEM 	:= _aC1[i,03]
			SC1->C1_PRODUTO := _aC1[i,04]
			SC1->C1_UM 		:= _aC1[i,05]
			SC1->C1_QUANT 	:= _aC1[i,06]
			SC1->C1_MOTIVO 	:= _aC1[i,07]
			SC1->C1_QTSEGUM := _aC1[i,08]
			SC1->C1_DATPRF 	:= _aC1[i,09]
			SC1->C1_LOCAL 	:= _aC1[i,10]
			SC1->C1_CC 		:= _aC1[i,11]
			SC1->C1_CONTA 	:= _aC1[i,12]
			SC1->C1_EMISSAO := _aC1[i,13]
			SC1->C1_DESCRI 	:= _aC1[i,14]
			SC1->C1_SOLICIT := _aC1[i,15]
			SC1->C1_IMPORT 	:= _aC1[i,16]
			SC1->C1_CODCOMP := _aC1[i,17]
			SC1->C1_CLASS 	:= _aC1[i,18]
			SC1->C1_GRUPCOM := _aC1[i,19]
			SC1->C1_USER 	:= _aC1[i,20]
			SC1->C1_FILENT 	:= _aC1[i,21]
			SC1->C1_QTDORIG := _aC1[i,22]
			SC1->C1_TIPO 	:= _aC1[i,23]
			SC1->C1_RATEIO 	:= _aC1[i,24]
			SC1->C1_XEMAIL 	:= _aC1[i,25]
			SC1->C1_XPRC 	:= _aC1[i,26]
			SC1->C1_ZAPROV 	:= _aC1[i,27]
			SC1->C1_ZSTATUS := '1'
			SC1->C1_ZLOG 	:= 'Copiado '+_aC1[i,03]
			SC1->C1_ZMOTREJ := ' '

			SC1->(MsUnlock())
			SC1->(DbCommit())

		Next i
		MsgInfo("Copia Realizada, entre novamente na solicita��o e confirme a Opera��o.!!!!!!   Solicita��o Nova: "+_c1Num)
	Endif







Return()
