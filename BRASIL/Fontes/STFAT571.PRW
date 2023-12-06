#INCLUDE "TBICONN.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"

/*====================================================================================\
|Programa  | STFAT571        | Autor | ANTONIO.CORDEIRO          | Data | 04/07/2023  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT571()

	Local cNewEmp 	:= "11"
	Local cNewFil	:= "01"
	Local _cAlias1  := ""

	Private oExcel := FwMsExcelXlsx():New()

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()

	ConOut(CRLF + "[STFAT571]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	If !LockByName("STFAT571",.T.,.T.)
		ConOut("[STFAT571]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	_cArq := U_RSTFATDF(oExcel)

	FErase("\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\pedidos.zip")
	cFile := "\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\pedidos.xlsx"
	_nret := FZip( "\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\pedidos.zip", {cFile} , "\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\" ,"" )
	FErase("\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\pedidos.xlsx")
	__CopyFile("\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\pedidos.zip","\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\CAPTACAO\pedidos.zip")
	FErase("\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\pedidos.zip")

	UnLockByName("STFAT571",.T.,.T.)

	ConOut("[STFAT571]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()
