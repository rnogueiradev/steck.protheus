
#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STTPCLI         | Autor | GIOVANI.ZAGO              | Data | 01/02/2013  |
|=====================================================================================|
|Descrição |  Validação do gatilho desconto adicional  e acrescimo adicional          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTPCLI                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STTPCLI()
*-----------------------------*

	Local aArea         := GetArea()
	Local lRet          := .F.

	If Empty(M->UA_XTIPO)

		DbSelectArea('SA1')
		SA1->(DbSetOrder(1))
		If SA1->(dbSeek(xFilial('SA1')+M->UA_CLIENTE+M->UA_LOJA))
			
			M->UA_XTIPO := SA1->A1_TIPO
		Else
			msgInfo('Tipo de Cliente não Encontrado Selecione Manualmente!!!!')
			
		EndIf

	EndIf

	// Atualiza totais da tela
	Tk273Trigger()
	Tk273FRefresh()
	Tk273TlvImp() 

	Restarea(aArea)

Return(lRet)
