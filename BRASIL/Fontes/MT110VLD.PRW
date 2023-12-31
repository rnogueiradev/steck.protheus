#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT110VLD     �Autor  �Joao Rinaldi    � Data �  02/02/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � O ponto de entrada 'MT110VLD' � � respons�vel em validar   ���
���          � o registro posicionado da Solicita��o de Compras antes de  ���
���          � executar as opera��es de inclus�o, altera��o, exclus�o     ���
���          � e c�pia. Se retornar .T., deve executar as opera��es de    ���
���          � inclus�o, altera��o, exclus�o e c�pia ou .F. para          ���
���          � interromper o processo.                                    ���
�������������������������������������������������������������������������͹��
���ExpN1     � 3- Inclus�o                                                ���
���          � 4- Altera��o                                               ���
���          � 6- Exclus�o                                                ���
���          � 8- Copia                                                   ���
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

User Function MT110VLD()
	
	//������������������������������������������������������������������������Ŀ
	//�Declara��o das Vari�veis
	//��������������������������������������������������������������������������
	Local aArea1    := GetArea()
	Local aArea2    := SC1->(GetArea())
	Local aArea3    := SAI->(GetArea())
	Local aArea4    := SY1->(GetArea())
	Local ExpN1     := Paramixb[1]
	Local ExpL1     := .T.
	Local _cSolic   := SC1->C1_USER
	Local _cStatus  := SC1->C1_ZSTATUS
	
		//	Adicionado para chamada Faturamento Beneficiamento - Valdemir Rabelo 26/07/2019
	if IsInCallStack( "U_STGerPC" )
		Return .T.
	ENDIF

	If ExpN1 == 4//Altera��o
		If !(_cSolic == __cUserId)
			Aviso("Solicita��o de Compra"; //01 - cTitulo - T�tulo da janela
			,"Voc� n�o � o solicitante dessa Solicita��o de Compras."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Voc� n�o poder� realizar nenhuma altera��o nessa Solicita��o de Compras."+ Chr(10) + Chr(13) +;
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
			ExpL1 := .F.
		Else
			If _cStatus == '2'
				Aviso("Solicita��o de Compra Analisada "; //01 - cTitulo - T�tulo da janela
				,"A Solicita��o de Compras encontra-se Analisada pelo gestor."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Voc� n�o poder� realizar nenhuma altera��o nessa Solicita��o de Compras."+ Chr(10) + Chr(13) +;
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
				ExpL1 := .F.
			ElseIf (_cStatus == '3' .Or. _cStatus == '6') .And. (AllTrim(SC1->C1_MOTIVO)<>"MRP") //Chamado - 003641
				Aviso("Solicita��o de Compra Aprovada "; //01 - cTitulo - T�tulo da janela
				,"A Solicita��o de Compras encontra-se Aprovada pelo gestor."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Voc� n�o poder� realizar nenhuma altera��o nessa Solicita��o de Compras."+ Chr(10) + Chr(13) +;
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
				ExpL1 := .F.
			ElseIf _cStatus == '4'
				Aviso("Solicita��o de Compra Rejeitada"; //01 - cTitulo - T�tulo da janela
				,"A Solicita��o de Compras encontra-se Rejeitada pelo gestor."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Voc� n�o poder� realizar nenhuma altera��o nessa Solicita��o de Compras."+ Chr(10) + Chr(13) +;
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
				ExpL1 := .F.
			ElseIf _cStatus == '5'
				Aviso("Solicita��o de Compra Rejeitada por Compras"; //01 - cTitulo - T�tulo da janela
				,"A Solicita��o de Compras encontra-se Rejeitada pelo departamento de Compras."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Voc� n�o poder� realizar nenhuma altera��o nessa Solicita��o de Compras."+ Chr(10) + Chr(13) +;
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
				ExpL1 := .F.					
			Endif
		Endif
		
	ElseIf ExpN1 == 3//Inclus�o
		DbSelectArea("SAI")
		SAI->(DbSetOrder(2))//AI_FILIAL+AI_USER
		SAI->(DbGoTop())
		If !DbSeek(xFilial("SAI")+__cUserId)
			Aviso("Cadastro de Solicitante"; //01 - cTitulo - T�tulo da janela
			,"Voc� n�o est� cadastrado como Solicitante de Compras."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Voc� n�o poder� incluir Solicita��es de Compras."+ Chr(10) + Chr(13) +;
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
			ExpL1 := .F.
		Endif		
	Endif
	
	RestArea(aArea4)
	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)
	
Return ExpL1