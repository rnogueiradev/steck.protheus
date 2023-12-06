#include 'protheus.ch'
#include 'parmtype.ch'

/*/
+------------------------------------------------------------------------------+
|                           FICHA T�CNICA DO PROGRAMA                          |
+------------------------------------------------------------------------------+
|Tipo              | Ponto de Entrada                                          |
+------------------------------------------------------------------------------+
|M�dulo            | Faturamento                                               |
+------------------------------------------------------------------------------+
|Fun��o            | M410VRES                                                  |
+------------------------------------------------------------------------------+
|Descri��o         | Ponto de Entrada executado ap�s a confirma��o da          |
|                  | elimina��o de residuos no pedido de venda e antes do      |
|                  | inicio da transa��o do mesmo                              |
+------------------------------------------------------------------------------+
|Autor             | Eduardo Matias 					                       |
+------------------------------------------------------------------------------+
|Data de Cria��o   | 06/08/2018                                                |
+------------------------------------------------------------------------------+
|                  |                                                           |
+------------------------------------------------------------------------------+
/*/

User Function M410VRES()

	Local lRet		:=	.T.
	Local lAtivo	:=	SuperGetMv("M410VRES",.F.,.T.)//Para desativar PE
	Local lCredito	:= .F.
	Local lEstoque	:= .F.
	Local lLiber	:= .F.
	Local lTransf	:= .F.

	Private _cPedido:=	SC5->C5_NUM

	If lAtivo

		dbSelectArea('SC6')
		SC6->(dbSetOrder(1))
		If SC6->(dbSeek(xFilial('SC6')+_cPedido))

			While SC6->(!Eof()) .And. _cPedido == SC6->C6_NUM

				MaAvalSC6("SC6",2,"SC5")

				SC6->(dbSkip())

			EndDo

		EndIf

	EndIf

	If lRet

		RecLock("SC5",.F.)

		SC5->C5_MENNOTA:="Eliminado por: " + UsrRetName(RetCodUsr()) +" "+ SC5->C5_MENNOTA

		SC5->(MsUnLock())

	EndIf

Return(lRet)