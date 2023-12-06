#include 'protheus.ch'
#include 'parmtype.ch'
/*
||------------------------------------------------------------------------------------------||
||MA180TOK - Ponto de Entrada utilizado na validação dos dados Complementares do Produto.	||
||																							||
||Autor: Eduardo Matias - 06/11/2018														||
||Descrição: Rotina desenvolvida para gravar as informações de tipo de embalagem no cadastro||
||de produto conforme solictação da engenharia.												||
||------------------------------------------------------------------------------------------||
*/
User Function MA180TOK()

	Local lRet		:= .T.
	Local aAreaBk	:= GetArea()

	If INCLUI .Or. ALTERA 

		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+M->B5_COD))

			RecLock("SB1",.F.)
			SB1->B1_XEMBCOL := M->B5_EMB1
			SB1->B1_XEMBMAS := M->B5_EMB2
			SB1->(MsUnLock())

		EndIf

	EndIf

	RestArea(aAreaBk)

Return(lRet)