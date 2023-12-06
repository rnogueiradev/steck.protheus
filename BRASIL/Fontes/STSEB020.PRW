#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STSEB020        | Autor | RENATO.OLIVEIRA           | Data | 06/03/2020  |
|=====================================================================================|
|Descrição | Rotina para gerar o arquivo ORDRSP					                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STSEB020()

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

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))

	_cDir 	:= AllTrim(GetMv("STSEB020",.F.,"\arquivos\seb\production\edi\ordrsp\"))
	cServer := AllTrim(GetMv("STSEB021",,"10.152.4.36"))
	nPorta  := GetMv("STSEB022",,21)
	cUser   := AllTrim(GetMv("STSEB023",,"steck-ftp"))
	cPass   := AllTrim(GetMv("STSEB024",,"Br@s1l@2020"))
	cDirFtp	:= AllTrim(GetMv("STSEB025",,"/seb/production/edi/ordrsp"))

	ConOut("[STSEB020]["+ FWTimeStamp(2) +"] Início do processamento.")

	If !LockByName("STSEB020",.F.,.F.,.T.)
		ConOut("[STSEB020]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	_cQuery1 := " SELECT C5.R_E_C_N_O_ RECSC5
	_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
	_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND C5_FILIAL='"+xFilial("SC5")+"'
	_cQuery1 += " AND C5_CLIENTE='012047' AND C5_LOJACLI='09'
	_cQuery1 += " AND C5_XALTDT='S' AND SUBSTR(C5_NOTA,1,1)<>'X'
	//_cQuery1 += " AND C5_NUM='000034'
	//_cQuery1 += " AND C5_NOTA=' ' 

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_lReprog := .F.
	
		SC5->(DbGoTo((_cAlias1)->RECSC5))
		
		//_cCodCont := SC5->C5_NUM+SubStr(DTOS(Date()),3,6)+SubStr(StrTran(Time(),":"),1,2)
		_cCodCont := SC5->C5_NUM

		_cQuery2 := " SELECT C6_NUMPCOM, C6_ITEMPC, B1_CODBAR, C6_QTDVEN-C6_QTDENT SALDO, C6_ZENTRE2, B1_COD, C6_ENTRE1
		_cQuery2 += " FROM "+RetSqlName("SC5")+" C5
		_cQuery2 += " LEFT JOIN "+RetSqlName("SC6")+" C6
		_cQuery2 += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM
		_cQuery2 += " LEFT JOIN "+RetSqlName("SB1")+" B1
		_cQuery2 += " ON B1_COD=C6_PRODUTO AND B1.D_E_L_E_T_=' ' 
		_cQuery2 += " WHERE C5.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' '
		_cQuery2 += " AND C5.R_E_C_N_O_="+cValToChar((_cAlias1)->RECSC5)
		_cQuery2 += " AND C6.C6_XALTDT='S' AND C6.C6_NUMPCOM<>' ' AND C6.C6_ITEMPC<>' ' 
		_cQuery2 += " ORDER BY C6_ITEMPC

		If !Empty(Select(_cAlias2))
			DbSelectArea(_cAlias2)
			(_cAlias2)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

		dbSelectArea(_cAlias2)
		(_cAlias2)->(dbGoTop())

		_nCount := 0

		_cItens := ""

		While (_cAlias2)->(!Eof())

			_nCount++
			
			_cItens += "LIN+"+AllTrim((_cAlias2)->C6_ITEMPC)+"'"+CHR(13)+CHR(10)
			_cItens += "PIA+5+"+AllTrim((_cAlias2)->B1_COD)+":SA'"+CHR(13)+CHR(10)
			_cItens += "QTY+113:"+StrTran(AllTrim(Transform((_cAlias2)->SALDO,"@E 999999999.999")),",",".")+":PCE'"+CHR(13)+CHR(10)
			If !Empty((_cAlias2)->C6_ZENTRE2)
				_cItens += "DTM+2:"+(_cAlias2)->C6_ZENTRE2+":102'"+CHR(13)+CHR(10)
				_lReprog := .T.
			else
				_cItens += "DTM+2:"+(_cAlias2)->C6_ENTRE1+":102'"+CHR(13)+CHR(10)
			EndIf
			_cItens += "RFF+ON:"+AllTrim((_cAlias2)->C6_NUMPCOM)+":"+AllTrim((_cAlias2)->C6_ITEMPC)+"'"+CHR(13)+CHR(10)

			(_cAlias2)->(DbSkip())
		EndDo

		_cArquivo := ""
		_cArquivo += "UNA:+.? '"+CHR(13)+CHR(10)
		_cArquivo += "UNB+UNOA:1+2BR00461:ST+XI3:91+"+SubStr(StrTran(DTOC(Date()),"/"),5,2)+SubStr(StrTran(DTOC(Date()),"/"),3,2)+SubStr(StrTran(DTOC(Date()),"/"),1,2)+":"+SubStr(StrTran(Time(),":"),1,4)+"+"+_cCodCont+"'"+CHR(13)+CHR(10)

		If _lReprog
			_cArquivo += "UNH+"+_cCodCont+"+ORDRSP:D:96A:UN:EAN005+REPD'"+CHR(13)+CHR(10)
		Else
			_cArquivo += "UNH+"+_cCodCont+"+ORDRSP:D:96A:UN:EAN005+AR'"+CHR(13)+CHR(10)
		EndIf

		_cArquivo += "BGM+231::::+"+_cCodCont+"+29'"+CHR(13)+CHR(10)
		_cArquivo += "DTM+137:"+DTOS(Date())+":102'"+CHR(13)+CHR(10)
		_cArquivo += "RFF+CO:"+AllTrim(SC5->C5_XORDEM)+"'"+CHR(13)+CHR(10)
		_cArquivo += "NAD+SU'"+CHR(13)+CHR(10)
		_cArquivo += "RFF+API:2BR00461'"+CHR(13)+CHR(10)

		_cArquivo += _cItens

		_cArquivo += "UNS+S'"+CHR(13)+CHR(10)
		_cArquivo += "UNT+"+cValToChar(8+(_nCount*5))+"+"+_cCodCont+"'"+CHR(13)+CHR(10)
		_cArquivo += "UNZ+1+"+_cCodCont+"'"+CHR(13)+CHR(10)
		
		_cArq  := "ORDRSP_"+SC5->C5_NUM+DTOS(Date())+StrTran(Time(),":")
		_cFile := _cDir+_cArq
		
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
		
		If nRet==0
			
			SC5->(RecLock("SC5",.F.))
			SC5->C5_XALTDT := ""
			SC5->(MsUnLock())

			SC6->(DbSeek(SC5->(C5_FILIAL+C5_NUM)))
			While SC6->(!Eof()) .And. SC5->(C5_FILIAL+C5_NUM)==SC6->(C6_FILIAL+C6_NUM)
				SC6->(RecLock("SC6",.F.))
				SC6->C6_XALTDT := ""
				SC6->(MsUnLock())
				SC6->(DbSkip())
			EndDo

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	UnLockByName("STSEB020",.F.,.F.,.T.)

	ConOut("[STSEB020]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()
