#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M020INC  º Autor ³ Vitor Merguizo     º Data ³  27/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Efetua a gravação do Item Contabil (CTD) automáticamente   º±±
±±º          ³ Conforme definição do projeto, o item contabil registrará  º±±
±±º          ³ a contabilização de Fornecedores, permitindo               º±±
±±º          ³ que a contabilidade tenha um plano de contas "exuto".      º±±
±±º          ³                                                            º±±
±±º          ³ O cadastro de itens contabeis  será composto de:           º±±
±±º          ³                                                            º±±
±±º          ³ Fornecedores:"2"+ALLTRIM(SA2->A2_COD)+ALLTRIM(SA2->A2_LOJA)º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico COPPEL                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M020INC

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local _cItemContab	:= "2"+ALLTRIM(SA2->A2_COD)+ALLTRIM(SA2->A2_LOJA)

dbSelectArea("CTD")
dbSetOrder(1)

if !CTD->( dbSeek( xfilial("CTD")+_cItemContab ) )
	
	Reclock("CTD",.T.)
	CTD->CTD_FILIAL		:=	xFilial("CTD")
	CTD->CTD_ITEM		:=	alltrim(_cItemContab)
	CTD->CTD_CLASSE		:=	"2"
	CTD->CTD_NORMAL		:=	"0"
	CTD->CTD_DESC01		:=	alltrim(SA2->A2_NOME)
	CTD->CTD_BLOQ		:=	"2"
	CTD->CTD_DTEXIS		:=	Ctod("01/01/80")
	MsUnlock()
	
	dbSelectArea("SA2")
	RecLock("SA2",.F.)
	SA2->A2_E_ITEM :=	_cItemContab
	MsUnlock()         
	
Else

	dbSelectArea("SA2")
	
Endif

Return(.T.)