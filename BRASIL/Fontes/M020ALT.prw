#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M020ALT  � Autor � Vitor Merguizo     � Data �  27/01/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Efetua a grava��o do Item Contabil (CTD) autom�ticamente   ���
���          � Conforme defini��o do projeto, o item contabil registrar�  ���
���          � a contabiliza��o de Fornecedores, permitindo               ���
���          � que a contabilidade tenha um plano de contas "exuto".      ���
���          �                                                            ���
���          � O cadastro de itens contabeis  ser� composto de:           ���
���          �                                                            ���
���          � Fornecedores:"2"+ALLTRIM(SA2->A2_COD)+ALLTRIM(SA2->A2_LOJA)���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico COPPEL                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M020ALT

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local _cItemContab	:= "2"+ALLTRIM(SA2->A2_COD)+ALLTRIM(SA2->A2_LOJA)

dbSelectArea("CTD")
dbSetOrder(1)

if !CTD->( dbSeek( xfilial("CTD")+_cItemContab ) )
	
	Reclock("CTD",.T.)
	CTD->CTD_FILIAL		:=	xfilial("CTD")
	CTD->CTD_ITEM		:=	alltrim(_cItemContab)
	CTD->CTD_CLASSE		:=	"2"
	CTD->CTD_NORMAL		:=	"0"
	CTD->CTD_DESC01		:=	alltrim(SA2->A2_NOME)
	CTD->CTD_BLOQ		:=	"2"
	CTD->CTD_DTEXIS		:=	Ctod("01/01/80")
	MsUnlock()

Else

	Reclock("CTD",.F.)
	CTD->CTD_DESC01		:=	alltrim(SA2->A2_NOME)
	MsUnlock()
		
Endif

dbSelectArea("SA2")

If empty(SA2->A2_E_ITEM)
	RecLock("SA2",.F.)
	SA2->A2_E_ITEM :=	_cItemContab
	MsUnlock()
Endif

Return(.T.)