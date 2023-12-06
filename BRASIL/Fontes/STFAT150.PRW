#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | STFAT150        | Autor | Renato Nogueira           | Data | 13/06/2019  |
|=====================================================================================|
|Descrição | Informações adicionais no pedido                                         |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT150()

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	If SC5->C5_TIPO=="N" .And. cEmpAnt=="01" .And. SC5->C5_FILIAL="02" .And. AllTrim(SC5->C5_CLIENTE)=="000224"
		
		SC5->C5_XOBSEXP := "Santil"
		
		SC6->(DbSetOrder(1))
		SC6->(DbSeek(SC5->(C5_FILIAL+C5_NUM)))
		While SC6->(!Eof()) .And. SC5->(C5_FILIAL+C5_NUM)==SC6->(C6_FILIAL+C6_NUM)
			If SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
				If AllTrim(SB1->B1_GRUPO) $ "170#172#179#169"
					SC5->C5_XOBSEXP := "Santil + EAN13 bobinas e contatores"
					Exit
				EndIf
			EndIf
			SC6->(DbSkip())
		EndDo

	EndIf

Return()