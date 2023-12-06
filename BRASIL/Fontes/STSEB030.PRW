#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STSEB030        | Autor | RENATO.OLIVEIRA           | Data | 21/09/2020  |
|=====================================================================================|
|Descrição | Rotina para gerar o arquivo DESADV					                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STSEB030()

	Local _cDir 	:= ""
	Local _cQuery1 	:= ""
	Local _cAlias1  := ""
	Local _cQuery2 	:= ""
	Local _cAlias2  := ""

	RpcSetType( 3 )
	RpcSetEnv("01","05",,,"FAT")

	_cAlias1 := GetNextAlias()
	_cAlias2 := GetNextAlias()
	
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))

	_cDir 	:= AllTrim(GetMv("STSEB030",.F.,"\arquivos\seb\edi\ordrsp\"))
	cServer := AllTrim(GetMv("STSEB021",,"10.152.4.30"))
	nPorta  := GetMv("STSEB022",,21)
	cUser   := AllTrim(GetMv("STSEB023",,"steck-ftp"))
	cPass   := AllTrim(GetMv("STSEB024",,"Br@s1l@2020"))
	cDirFtp	:= AllTrim(GetMv("STSEB025",,"/seb/quality/edi/ordrsp"))

	ConOut("[STSEB030]["+ FWTimeStamp(2) +"] Início do processamento.")

	If !LockByName("STSEB030",.F.,.F.,.T.)
		ConOut("[STSEB030]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	_cQuery1 := " SELECT C5.R_E_C_N_O_ RECSC5
	_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
	_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND C5_FILIAL='"+xFilial("SC5")+"'
	_cQuery1 += " AND C5_CLIENTE='012047' AND C5_XALTDT='S'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())
	
		SC5->(DbGoTo((_cAlias1)->RECSC5))
		
		_cCodCont := SC5->C5_NUM+DTOS(Date())+StrTran(Time(),":")

		_cArquivo := ""
		_cArquivo += "UNA:+.?'"+CHR(13)+CHR(10)
		_cArquivo += "UNB+UNOA:3+SEB:14+STECK:14+"+SubStr(StrTran(DTOC(Date()),"/"),5,2)+SubStr(StrTran(DTOC(Date()),"/"),3,2)+SubStr(StrTran(DTOC(Date()),"/"),1,2)+":"+SubStr(StrTran(Time(),":"),1,4)+"+"+_cCodCont+"++ORDRSP'"+CHR(13)+CHR(10)
		_cArquivo += "UNH+"+_cCodCont+"00001+ORDRSP:D:96A:UN:EAN005'"+CHR(13)+CHR(10)
		_cArquivo += "BGM+231:::+1002069299+4'"+CHR(13)+CHR(10)
		_cArquivo += "DTM+137:"+DTOS(Date())+":102'"+CHR(13)+CHR(10)

		_cQuery2 := " SELECT C6_NUMPCOM, C6_ITEMPC, B1_CODBAR, C6_QTDVEN-C6_QTDENT SALDO, C6_ZENTRE2
		_cQuery2 += " FROM "+RetSqlName("SC5")+" C5
		_cQuery2 += " LEFT JOIN "+RetSqlName("SC6")+" C6
		_cQuery2 += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM
		_cQuery2 += " LEFT JOIN "+RetSqlName("SB1")+" B1
		_cQuery2 += " ON B1_COD=C6_PRODUTO AND B1.D_E_L_E_T_=' ' 
		_cQuery2 += " WHERE C5.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' '
		_cQuery2 += " AND C5.R_E_C_N_O_="+cValToChar((_cAlias1)->RECSC5)
		_cQuery2 += " AND C6.C6_XALTDT='S'

		If !Empty(Select(_cAlias2))
			DbSelectArea(_cAlias2)
			(_cAlias2)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

		dbSelectArea(_cAlias2)
		(_cAlias2)->(dbGoTop())

		While (_cAlias2)->(!Eof())
			
			_cArquivo += "RFF+ON:"+AllTrim((_cAlias2)->(C6_NUMPCOM+C6_ITEMPC))+"'"+CHR(13)+CHR(10)
			_cArquivo += "LIN+"+AllTrim((_cAlias2)->C6_ITEMPC)+"+3+"+AllTrim((_cAlias2)->B1_CODBAR)+":EN'"+CHR(13)+CHR(10)
			_cArquivo += "QTY+113:"+cValToChar((_cAlias2)->SALDO)+":PCE'"+CHR(13)+CHR(10)
			_cArquivo += "DTM+2:"+(_cAlias2)->C6_ZENTRE2+":102'"+CHR(13)+CHR(10)

			(_cAlias2)->(DbSkip())
		EndDo

		_cArquivo += "UNS+S'
		_cArquivo += "UNT+13+"+_cCodCont+"'
		_cArquivo += "UNZ+1+"+_cCodCont+"'		
		
		_cArq  := "ORDRSP_"+SC5->C5_NUM+DTOS(Date())+StrTran(Time(),":")+".txt"
		_cFile := _cDir+"pendentes\"+_cArq
		
		If File(_cFile)
			FErase(_cFile)
		EndIf

		nHdlXml   := FCreate(_cFile,0)

		If nHdlXml > 0
			FWrite(nHdlXml,_cArquivo)
			FClose(nHdlXml)
		Endif
		
		oFTPHandle := tFtpClient():New()
		oFTPHandle:nTransferType := 0
		nRet := oFTPHandle:FTPConnect(cServer,nPorta,cUser,cPass)
		nRet := oFTPHandle:ChDir(cDirFtp)
		nRet := oFTPHandle:SendFile(_cFile,_cArq)
		oFTPHandle:Close()
		
		If nRet
		
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	UnLockByName("STSEB030",.F.,.F.,.T.)

	ConOut("[STSEB030]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()
