#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"

/*====================================================================================\
|Programa  | STFAT560        | Autor | RENATO.OLIVEIRA           | Data | 03/06/2022  |
|=====================================================================================|
|Descri��o | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function STFAT560()

	Local cNewEmp 	:= "11"
	Local cNewFil	:= "01"
	Local _cQuery1  := ""
	Local _cAlias1  := ""
	Local aFiles := {}

	Private oExcel := FwMsExcelXlsx():New()

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()

	ConOut(CRLF + "[STFAT560]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	If !LockByName("STFAT560",.T.,.T.)
		ConOut("[STFAT560]["+ FWTimeStamp(2) +"] - J� existe uma sess�o em processamento.")
		Return()
	EndIf

	_cArq := U_RSTFATDB(oExcel)

	FErase("\arquivos\SFTP-INTEGRA��ES\RELATORIOS\TEMP\captacao_comercial.zip")
	cFile := "\arquivos\SFTP-INTEGRA��ES\RELATORIOS\TEMP\captacao_comercial.xlsx"
	_nret := FZip( "\arquivos\SFTP-INTEGRA��ES\RELATORIOS\TEMP\captacao_comercial.zip", {cFile} , "\arquivos\SFTP-INTEGRA��ES\RELATORIOS\TEMP\" ,"" )
	FErase("\arquivos\SFTP-INTEGRA��ES\RELATORIOS\TEMP\captacao_comercial.xlsx")
	__CopyFile("\arquivos\SFTP-INTEGRA��ES\RELATORIOS\TEMP\captacao_comercial.zip","\arquivos\SFTP-INTEGRA��ES\RELATORIOS\CAPTACAO\captacao_comercial.zip")
	FErase("\arquivos\SFTP-INTEGRA��ES\RELATORIOS\TEMP\captacao_comercial.zip")

	_aAttach    := {}
	_cEmail 	:= Alltrim(GetMv("STFAT56001",,"renato.oliveira@steck.com.br"))
	_cEmail 	+= Alltrim(GetMv("STFAT56002",,""))
	_cEmail 	+= Alltrim(GetMv("STFAT56003",,""))
	_cEmail 	+= Alltrim(GetMv("STFAT56004",,""))
	_cEmail 	+= Alltrim(GetMv("STFAT56005",,""))
	_cAssunto   := "[WFPROTHEUS] - Relat�rio de capta��o comercial
	cMsg		:= ""
	//aadd( _aAttach  , "captacao_comercial.zip" )
	_cCaminho := "\arquivos\SFTP-INTEGRA��ES\RELATORIOS\CAPTACAO\"
	_cCopia := ""

	cMsg := '<html><head><title>stkSales</title></head>
	cMsg += '<body>
	cMsg += 'Relat�rio de capta��o atualizado<br>
	cMsg += '</body></html>'

	If GetMv("STFAT56000",,.T.)
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
	EndIf

	UnLockByName("STFAT560",.T.,.T.)

	ConOut("[STFAT560]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()
