#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EMP650    �Autor  � RVG Solucoes       � Data �  07/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para alterar o almoxarifado dos empenhos no momento ���
���          � da confirmacao das ordens de producoes.                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP11 - Steck                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EMP650()
Local _nI		:= 0
_cGetArea := getarea()

_cLocProd := GetMv("MV_LOCPROC")

Dbselectarea("SB1")

For _nI := 1 To Len(aCols)
	
	If DbSeek(xFilial("SB1")+aCols[_nI,1])
		If UPPER(ALLTRIM(SB1->B1_APROPRI)) <> 'D' .OR. SC2->C2_XBENEF=='S'
			aCols[_nI,3] := _cLocProd
		EndIf
	EndIf
	
Next _nI

RestArea(_cGetArea)

xEMP650()

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EMP650    �Autor  �                    � Data �  02/06/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para alterar os empenhos no momento                 ���
���          � da confirmacao das ordens de producoes.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xEMP650()

	Local _nI

//������������������������������������������������������Ŀ
//� Salva a area atual                                   �
//��������������������������������������������������������
	_aArea := GetArea()

//������������������������������������������������������Ŀ
//� Salva a area atual de Produtos                       �
//��������������������������������������������������������
	DbSelectArea("SB1")
	DbSetOrder(1)
	_aArSB1 := GetArea()

//������������������������������������������������������Ŀ
//� Salva a area atual de Estruturas                     �
//��������������������������������������������������������
	DbSelectArea("SG1")
	_aArSG1 := GetArea()
	DbSetOrder(1)

//������������������������������������������������������Ŀ
//� Salva a area atual da OP                             �
//��������������������������������������������������������
	DbSelectArea("SC2")
	_aArSC2 := GetArea()

//��������������������������������������Ŀ
//� Gera todos os empenhos da ETAPA      �
//����������������������������������������
	For _nI := 1 To Len(aCols)

		DbSelectArea("SB1")

		If DbSeek(xFilial("SB1")+aCols[_nI,1])

			If SB1->B1_TIPO == 'IC'

				aCols[_nI,LEN(acols[_ni])] := .T. // DELETA A LINHA

			EndIf

		EndIf

	Next _nI

//������������������������������������������������������Ŀ
//� Restaura a area de Produtos                          �
//��������������������������������������������������������

	RestArea(_aArSB1)

//������������������������������������������������������Ŀ
//� Restaura a area da Estrutura                         �
//��������������������������������������������������������

	RestArea(_aArSG1)

//������������������������������������������������������Ŀ
//� Restaura a area da OP                                �
//��������������������������������������������������������
	RestArea(_aArSC2)

//������������������������������������������������������Ŀ
//� Restaura a area atual                                �
//��������������������������������������������������������
	RestArea(_aArea)

Return
/*
ESTRUTURA DO ACOLS
posicao     campos
01         Componente - Codigo do produto
02         Quantidade
03         Armazem
04         Sequencia da Estrutura
05         Sub-Lote
06         Lote
07         Validade do Lote (DATA)
08         Potencia
09         Endereco Fisico
10         Num.Serie
11         1a UM
12         Qtde 2a UM
13         2a UM
14         Descricao
15         Esta Deleta ou nao .t. ou .f.
*/

