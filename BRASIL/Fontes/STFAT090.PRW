#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STFAT090        | Autor | RENATO.OLIVEIRA           | Data | 26/12/2018  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT090()

	Local cNewEmp 	:= "01"
	Local cNewFil 	:= "02"

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(DbGoTop())
	SX3->(DbSeek("SA1"))

	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO=="SA1"
		/* Removido\Ajustado - Não executa mais Recklock na X3
		SX3->(RecLock("SX3",.F.))
		SX3->X3_WHEN := 'U_STCOM100("SA1","'+AllTrim(SX3->X3_CAMPO)+'")'
		SX3->(MsUnLock())

		SX3->(DbSkip())*/
	EndDo

Return
