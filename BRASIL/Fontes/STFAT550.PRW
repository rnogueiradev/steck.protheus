#INCLUDE "TBICONN.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"

/*====================================================================================\
|Programa  | STFAT550        | Autor | RENATO.OLIVEIRA           | Data | 03/06/2022  |
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

User Function STFAT550()

	Local cNewEmp 	:= "11"
	Local cNewFil	:= "01"
	Local _cQuery1  := ""
	Local _cAlias1  := ""
	Local aFiles := {}

	Private oExcel := FwMsExcelXlsx():New()

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()

	ConOut(CRLF + "[STFAT550]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	If !LockByName("STFAT550",.T.,.T.)
		ConOut("[STFAT550]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	_cArq := U_RSTFATDB(oExcel)

	ConOut(CRLF + "[STFAT550]["+ FWTimeStamp(2) +"] Iniciando processamento de arquivo e envio de email.")

	FErase("\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\captacao_aberto.zip")
	cFile := "\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\captacao_aberto.xlsx"
	_nret := FZip( "\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\captacao_aberto.zip", {cFile} , "\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\" ,"" )
	FErase("\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\captacao_aberto.xlsx")
	__CopyFile("\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\captacao_aberto.zip","\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\CAPTACAO\captacao_aberto.zip")
	FErase("\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\captacao_aberto.zip")

	_aAttach    := {}
	_cEmail 	:= Alltrim(GetMv("STFAT55001",,"renato.oliveira@steck.com.br"))
	_cEmail 	+= Alltrim(GetMv("STFAT55002",,""))
	_cEmail 	+= Alltrim(GetMv("STFAT55003",,""))
	_cEmail 	+= Alltrim(GetMv("STFAT55004",,""))
	_cEmail 	+= Alltrim(GetMv("STFAT55005",,""))
	_cAssunto   := "[WFPROTHEUS] - Relatório de captação em aberto
	cMsg		:= ""
	//aadd( _aAttach  , "captacao_aberto.zip" )
	_cCaminho := "\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\CAPTACAO\"
	_cCopia := ""

	cMsg := '<html><head><title>stkSales</title></head>
	cMsg += '<body>
	cMsg += 'Relatório de captação atualizado<br>
	cMsg += '</body></html>'

	If GetMv("STFAT55000",,.T.)
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
	EndIf

	UnLockByName("STFAT550",.T.,.T.)

	ConOut("[STFAT550]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()
