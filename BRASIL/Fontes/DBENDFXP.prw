#Include "PROTHEUS.Ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DBENDFXP  � Autor � Renato Nogueira      � Data � 13.12.12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posicionar no �ltimo registro da tabela SA5                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function DBENDFXP()  

Local _cFornece := ""

DbSelectArea("SA5")
DbSetOrder(0)
DBGoBottom() 

_cFornece := SA5->A5_FORNECE

Return(_cFornece)

