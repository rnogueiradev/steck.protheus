#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT085OK      �Autor  �Joao Rinaldi    � Data �  01/02/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para confirmar a altera��o, exclus�o e    ���
���          � inclus�o do Solicitante de Compras                         ���
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
User Function MT085OK()
	
	//������������������������������������������������������������������������Ŀ
	//�Declara��o das Vari�veis
	//��������������������������������������������������������������������������
	Local aArea1    := GetArea()
	Local aArea2    := SAI->(GetArea())
	
	Local ExpL1 := PARAMIXB[1]
	Local ExpL2 := PARAMIXB[2]
	Local ExpL3 := PARAMIXB[3]
	Local ExpL4 := .F.
	
	Aviso("Cadastro de Solicitantes"; //01 - cTitulo - T�tulo da janela
	,"N�o � permitido Incluir/Alterar/Excluir Solicitantes por essa rotina."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"O Aprovador de cada Centro de Custo que deve realizar o cadastro do Solicitante."+ Chr(10) + Chr(13) +;
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
	
	RestArea(aArea2)
	RestArea(aArea1)
	
Return ExpL4
