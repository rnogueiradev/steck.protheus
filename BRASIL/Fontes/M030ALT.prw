#INCLUDE "rwmake.ch"
#INCLUDE "RPTDEF.CH" 
#INCLUDE 'DBTREE.CH'
#INCLUDE 'TBICONN.CH'
#include 'protheus.ch'
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M030ALT  º Autor ³ Vitor Merguizo     º Data ³  27/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Efetua a gravação do Item Contabil (CTD) automáticamente   º±±
±±º          ³ Conforme definição do projeto, o item contabil registrará  º±±
±±º          ³ a contabilização de Clientes, permitindo               º±±
±±º          ³ que a contabilidade tenha um plano de contas "exuto".      º±±
±±º          ³                                                            º±±
±±º          ³ O cadastro de itens contabeis  será composto de:           º±±
±±º          ³                                                            º±±
±±º          ³ Clientes:"1"+ALLTRIM(SA1->A1_COD)+ALLTRIM(SA1->A1_LOJA)º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico Steck                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M030ALT()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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