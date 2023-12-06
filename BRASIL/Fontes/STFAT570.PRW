#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"

/*====================================================================================\
|Programa  | STFAT570        | Autor | RENATO.OLIVEIRA           | Data | 03/06/2022  |
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

User Function STFAT570()

	Local cNewEmp 	:= "11"
	Local cNewFil	:= "01"
	Local _cQuery1  := ""
	Local _cAlias1  := ""
	Local aFiles := {}

	Private oExcel := FwMsExcelXlsx():New()

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()

	ConOut(CRLF + "[STFAT570]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	If !LockByName("STFAT570",.T.,.T.)
		ConOut("[STFAT570]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	_cArq := U_RSTFATDC(oExcel)

	FErase("\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\faturamento.zip")
	cFile := "\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\faturamento.xlsx"
	_nret := FZip( "\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\faturamento.zip", {cFile} , "\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\" ,"" )
	FErase("\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\faturamento.xlsx")
	__CopyFile("\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\faturamento.zip","\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\CAPTACAO\faturamento.zip")
	FErase("\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\TEMP\faturamento.zip")

	_aAttach    := {}
	_cEmail 	:= Alltrim(GetMv("STFAT57001",,"renato.oliveira@steck.com.br"))
	_cEmail 	+= Alltrim(GetMv("STFAT57002",,""))
	_cAssunto   := "[WFPROTHEUS] - Relatório de faturamento
	cMsg		:= ""
	//aadd( _aAttach  , "faturamento.zip" )
	_cCaminho := "\arquivos\SFTP-INTEGRAÇÕES\RELATORIOS\CAPTACAO\"
	_cCopia := ""

	cMsg := '<html><head><title>stkSales</title></head>
	cMsg += '<body>
	cMsg += 'Relatório de faturamento atualizado<br>
	cMsg += '</body></html>'

	If GetMv("STFAT57003",,.T.)
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
	EndIf

	UnLockByName("STFAT570",.T.,.T.)

	ConOut("[STFAT570]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()
