#INCLUDE "rwmake.ch"
#INCLUDE "RPTDEF.CH" 
#INCLUDE 'DBTREE.CH'
#INCLUDE 'TBICONN.CH'
#include 'protheus.ch'
#Include "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M030ALT  � Autor � Vitor Merguizo     � Data �  27/01/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Efetua a grava��o do Item Contabil (CTD) autom�ticamente   ���
���          � Conforme defini��o do projeto, o item contabil registrar�  ���
���          � a contabiliza��o de Clientes, permitindo               ���
���          � que a contabilidade tenha um plano de contas "exuto".      ���
���          �                                                            ���
���          � O cadastro de itens contabeis  ser� composto de:           ���
���          �                                                            ���
���          � Clientes:"1"+ALLTRIM(SA1->A1_COD)+ALLTRIM(SA1->A1_LOJA)���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Steck                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M030ALT()

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������

	Local _cItemContab	:= "1"+ALLTRIM(SA1->A1_COD)+ALLTRIM(SA1->A1_LOJA)
	Public _cA1VEND		:= SA1->A1_VEND
	Public _cA1GRPVEN	:= SA1->A1_GRPVEN
	Public _cA1TIPO		:= SA1->A1_TIPO
	Public _cA1ATIVIDA	:= SA1->A1_ATIVIDA
	Public _cA1HISTOR	:= Alltrim( MSMM(SA1->A1_XCODMC))
	Public _cA1NSEG		:= SA1->A1_XNSEG			//Richard - 24/04/18 
	Public _cA1BLQFIN	:= SA1->A1_XBLQFIN			//Richard - 04/05/18 - Chamado 007309 
	Public _cA1BLOQF	:= SA1->A1_XBLOQF			//Richard - 04/05/18 - Chamado 007309 

	dbSelectArea("CTD")
	dbSetOrder(1)

	if !CTD->( dbSeek( xfilial("CTD")+_cItemContab ) )

		Reclock("CTD",.T.)
		CTD->CTD_FILIAL		:=	xfilial("CTD")
		CTD->CTD_ITEM		:=	alltrim(_cItemContab)
		CTD->CTD_CLASSE		:=	"2"
		CTD->CTD_NORMAL		:=	"0"
		CTD->CTD_DESC01		:=	alltrim(SA1->A1_NOME)
		CTD->CTD_BLOQ		:=	"2"
		CTD->CTD_DTEXIS		:=	Ctod("01/01/80")
		MsUnlock()

	Else

		Reclock("CTD",.F.)
		CTD->CTD_DESC01		:=	alltrim(SA1->A1_NOME)
		MsUnlock()

	Endif

	dbSelectArea("SA1")
	If empty(SA1->A1_XIDBRA)
		Reclock("SA1",.F.)
		SA1->A1_XIDBRA := U_STFINDV1(SA1->A1_COD)
		MsUnlock()
	Endif

	If empty(SA1->A1_E_ITEM)
		RecLock("SA1",.F.)
		SA1->A1_E_ITEM :=	_cItemContab
		MsUnlock()
	Endif

	SA1->(RecLock("SA1",.F.))
	SA1->A1_XDTENVM := CTOD("  /  /    ")
	SA1->(MsUnLock())

Return(.T.)