#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M020INC  � Autor � Everson Santana     � Data �  19/09/18  ���
�������������������������������������������������������������������������͹��
���Descricao � Efetua a grava��o do Item Contabil (CTD) autom�ticamente   ���
���          � Conforme defini��o do projeto, o item contabil registrar�  ���
���          � a contabiliza��o de Clientes, permitindo                   ���
���          � que a contabilidade tenha um plano de contas "exuto".      ���
���          �                                                            ���
���          � O cadastro de itens contabeis  ser� composto de:           ���
���          �                                                            ���
���          � Clientes:"1"+ALLTRIM(SA1->A1_COD)+ALLTRIM(SA1->A1_LOJA)	  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Steck                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M030INC()

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������

	Local _cItemContab	:= "1"+ALLTRIM(SA1->A1_COD)+ALLTRIM(SA1->A1_LOJA)
	
	dbSelectArea("CTD")
	dbSetOrder(1)

	if !CTD->( dbSeek( xfilial("CTD")+_cItemContab ) )

		Reclock("CTD",.T.)
		CTD->CTD_FILIAL		:=	xFilial("CTD")
		CTD->CTD_ITEM		:=	alltrim(_cItemContab)
		CTD->CTD_CLASSE		:=	"2"
		CTD->CTD_NORMAL		:=	"0"
		CTD->CTD_DESC01		:=	alltrim(SA1->A1_NOME)
		CTD->CTD_BLOQ		:=	"2"
		CTD->CTD_DTEXIS		:=	Ctod("01/01/80")
		MsUnlock()

		dbSelectArea("SA1")
		RecLock("SA1",.F.)
		SA1->A1_E_ITEM :=	_cItemContab
		MsUnlock()

	Else

		dbSelectArea("SA1")

	Endif

Return(.T.)

