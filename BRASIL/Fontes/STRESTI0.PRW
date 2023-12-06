#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

/*====================================================================================\
|Programa  | STRESTHI        | Autor | RENATO.OLIVEIRA           | Data | 01/09/2020  |
|=====================================================================================|
|Descrição | Receber e cadastrar funcionários										  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSRESTFUL cadProd1 DESCRIPTION "Cadastrar produção"

WSMETHOD POST DESCRIPTION "Cadastrar produção" WSSYNTAX "/rest/cadProd1"

END WSRESTFUL

WSMETHOD POST WSSERVICE cadProd1

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cEmp 	:= ""
	Local _cFil		:= ""
	Local _nX
	Local aData
	Local lApoPend  := .F.
	Private l681Auto 	:= .T.
	Private l240:=.F.,l250 :=.F.,l241:=.F.,l242:=.F.,l261:=.F.,l185:=.F.,l650:=.F.,l680:=.F.,l681:=.T.
	Private lMSErroAuto := .F.
	Private lAutoErrNoFile := .T.
	Private lPerdInf    := .F.

	ConOut("[STRESTI0]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[STRESTI0]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	If !_lRet
		cResp := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	aData := ClassDataArr(oInfo)
	aCampos := {}

	For _nX:=1 To Len(aData)
		If SubStr(AllTrim(aData[_nX][1]),1,3)=="H6_"
			aadd(aCampos,{aData[_nX][1],U_STRESTI1(aData[_nX][1],aData[_nX][2]),Nil})
		EndIf
	Next

	lApoPend  	:= SuperGetMV("MV_APPENMO",.F.,"1")
	lPerdInf    := SuperGetMV("MV_PERDINF",.F.,.F.)

	_cQuery1 := ""
	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SRA")+" RA
	_cQuery1 += " WHERE RA.D_E_L_E_T_=' ' AND RA_FILIAL='"+cFilAnt+"' AND RA_MAT='"+oInfo:MAT+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		cResp := '{"CODRET":"02","DESCRET":"MATRICULA NAO ENCONTRADA"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	aadd(aCampos,{"H6_OPERADO",(_cAlias1)->RA_MAT,Nil})
	aadd(aCampos,{"H6_FILIAL",cFilAnt,Nil})
	aadd(aCampos,{"H6_XMAT",oInfo:MAT,Nil})

	DbSelectArea("SC2")
	SC2->(DbSetOrder(1))
	If !SC2->(DbSeek(xFilial("SC2")+oInfo:H6_OP))
		cResp := '{"CODRET":"03","DESCRET":"Ordem de producao nao existe"}
		::SetResponse(cResp)
		Return .T.	
	EndIf

	If !VLDOP()
		cResp := '{"CODRET":"03","DESCRET":"Ordem de producao sem ordem de separacao"}
		::SetResponse(cResp)
		Return .T.	
	EndIf

	aadd(aCampos,{"H6_PRODUTO",SC2->C2_PRODUTO,Nil})
	aadd(aCampos, {"PENDENTE",lApoPend, nil})

	lMSErroAuto := .F.
	lMSHelpAuto := .F.
	/*
	_cQuery1 := " SELECT MAX(D3_NUMSEQ) NUMSEQ
	_cQuery1 += " FROM "+RetSqlName("SD3")+" D3
	_cQuery1 += " WHERE D3.D_E_L_E_T_=' ' 

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		If !AllTrim((_cAlias1)->NUMSEQ)==AllTrim(GetMv("MV_DOCSEQ"))
			PutMv("MV_DOCSEQ",AllTrim(AllTrim((_cAlias1)->NUMSEQ)))
		EndIf
	EndIf
	*/

	If AllTrim(oInfo:OPERACAO)=="PRODUTIVA"
		msExecAuto({|x,y| MATA681(x,y)},aCampos,3)
	Else
		msExecAuto({|x,y| MATA682(x,y)},aCampos,3)
	EndIf

	If lMsErroAuto
		_cErro := MostraErro("arquivos\logs","STRESTI0"+dtos(date())+time()+".log")
		_cErro := StrTran(_cErro,'"','')
		cResp := '{"CODRET":"03","DESCRET":"'+_cErro+'"}
		::SetResponse(cResp)
		Return .T.
	Else

		SC2->(RecLock("SC2",.F.))
		SC2->C2_XSTATUS := "A"
		SC2->(MsUnLock())

		SH6->(RecLock("SH6",.F.))
		SH6->H6_QTDPERD := 0
		SH6->(MsUnLock())
	
		cResp := '{"CODRET":"00","DESCRET":"Apontamento realizado."}
		::SetResponse(cResp)
		Return .T.
	EndIf

Return .T.

/*====================================================================================\
|Programa  | STRESTI1        | Autor | RENATO.OLIVEIRA           | Data | 02/09/2020  |
|=====================================================================================|
|Descrição | RETORNA VARIAVEL CONVERTIDA			                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STRESTI1(_cCampo,_cVal)

	Local _aAreaSX3 := SX3->(GetArea())
	Local _xVal 	:= ""

	DbSelectArea("SX3")
	SX3->(DbGoTop())
	SX3->(DbSetOrder(2))

	If SX3->(DbSeek(_cCampo))

		If SX3->X3_TIPO == 'C' .Or. SX3->X3_TIPO == 'M'
			_xVal := _cVal
		ElseIf SX3->X3_TIPO == 'D'
			_xVal := CtoD(_cVal)
		ElseIf SX3->X3_TIPO == 'N'
			_xVal := Val(StrTran(StrTran(_cVal,".",""),",","."))
		Else
			If _cVal == ".T."
				_xVal := .T.
			Else
				_xVal := .F.
			Endif
		EndIf

	EndIf

	RestArea(_aAreaSX3)

Return(_xVal)

	WSRESTFUL GetCpfOper DESCRIPTION "Consultar CPF operador"

WSMETHOD POST DESCRIPTION "Consultar CPF operador" WSSYNTAX "/rest/GetCpfOper"

	END WSRESTFUL

WSMETHOD POST WSSERVICE GetCpfOper

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cEmp 	:= "01"
	Local _cFil		:= "05"
	Local _nX
	Local aData
	Local _cQuery1  := ""
	Local _cAlias1  := ""

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	If !_lRet
		cResp := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	_cAlias1 := GetNextAlias()

	ConOut("[STRESTJ0]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[STRESTJ0]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SRA")+" RA
	_cQuery1 += " WHERE RA.D_E_L_E_T_=' ' AND RA_FILIAL='"+cFilAnt+"'
	_cQuery1 += " AND RA_MAT='"+oInfo:MAT+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		cResp := '{"CODRET":"02","DESCRET":"MATRICULA NAO ENCONTRADA"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	cResp := '{"CODRET":"00","DESCRET":"MATRICULA ENCONTRADA","NOME":"'+AllTrim((_cAlias1)->RA_NOMECMP)+'","MATRICULA":"'+AllTrim((_cAlias1)->RA_MAT)+'"}
	::SetResponse(cResp)

Return .T.

	WSRESTFUL GetApont1 DESCRIPTION "Retorna apontamentos do operador"

WSMETHOD POST DESCRIPTION "Retorna apontamentos do operador" WSSYNTAX "/rest/GetApont1"

	END WSRESTFUL

WSMETHOD POST WSSERVICE GetApont1

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cEmp 	:= "01"
	Local _cFil		:= "05"
	Local _nX
	Local aData
	Local _cQuery1  := ""
	Local _cAlias1  := ""

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	If !_lRet
		cResp := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	_cAlias1 := GetNextAlias()

	ConOut("[STRESTK0]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[STRESTK0]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	_cQuery1 := " SELECT H6.*
	_cQuery1 += " FROM "+RetSqlName("SRA")+" RA
	_cQuery1 += " LEFT JOIN "+RetSqlName("SH6")+" H6
	_cQuery1 += " ON H6_OPERADO=RA_MAT AND RA_FILIAL='"+cFilAnt+"'
	_cQuery1 += " WHERE RA.D_E_L_E_T_=' ' AND H6.D_E_L_E_T_=' ' 
	_cQuery1 += " AND H6_FILIAL='"+cFilAnt+"'
	_cQuery1 += " AND RA_MAT='"+oInfo:MAT+"' AND H6_DATAINI='"+DTOS(Date())+"'
	_cQuery1 += " ORDER BY H6.R_E_C_N_O_ DESC

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		cResp := '[]
		::SetResponse(cResp)
		Return .T.
	EndIf

	cResp := '[

	While (_cAlias1)->(!Eof())
		
		cResp += '{
		cResp += '"H6_FILIAL":"'+(_cAlias1)->H6_FILIAL+'",
		cResp += '"H6_OP":"'+(_cAlias1)->H6_OP+'",
		cResp += '"H6_PRODUTO":"'+(_cAlias1)->H6_PRODUTO+'",
		cResp += '"H6_OPERAC":"'+(_cAlias1)->H6_OPERAC+'",
		cResp += '"H6_RECURSO":"'+(_cAlias1)->H6_RECURSO+'",
		cResp += '"H6_DATAINI":"'+DTOC(STOD((_cAlias1)->H6_DATAINI))+'",
		cResp += '"H6_HORAINI":"'+(_cAlias1)->H6_HORAINI+'",
		cResp += '"H6_HORAFIN":"'+(_cAlias1)->H6_HORAFIN+'",
		cResp += '"H6_MOTIVO":"'+(_cAlias1)->H6_MOTIVO+'",
		cResp += '"RECNO":"'+cValToChar((_cAlias1)->R_E_C_N_O_)+'"
		cResp += '}

		(_cAlias1)->(DbSkip())

		If (_cAlias1)->(!Eof())
			cResp += ',
		EndIf

	EndDo

	cResp += ']
	::SetResponse(cResp)

Return .T.

	WSRESTFUL DelApont1 DESCRIPTION "Deleta apontamento do operador"

WSMETHOD POST DESCRIPTION "Deleta apontamento do operador" WSSYNTAX "/rest/DelApont1"

	END WSRESTFUL

WSMETHOD POST WSSERVICE DelApont1

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cEmp 	:= "01"
	Local _cFil		:= "05"
	Local _nX
	Local aData
	Local _cQuery1  := ""
	Local _cAlias1  := ""

	_cAlias1 := GetNextAlias()

	ConOut("[DelApont1]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[DelApont1]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	If !_lRet
		cResp := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	DbSelectArea("SH6")
	SH6->(DbGoTo(oInfo:RECNO))
	If SH6->(!Eof())
	
		SH6->(RecLock("SH6",.F.))
		SH6->(DbDelete())
		SH6->(MsUnLock())

		cResp := '{"CODRET":"00","DESCRET":"DELETADO COM SUCESSO"}		
		::SetResponse(cResp)
		Return .T.

	Else

		cResp := '{"CODRET":"01","DESCRET":"REGISTRO NAO ENCONTRADO"}
		::SetResponse(cResp)
		Return .T.

	EndIf

Return .T.

	WSRESTFUL ApontProd DESCRIPTION "Apontar produção"

WSMETHOD POST DESCRIPTION "Apontar produção" WSSYNTAX "/rest/ApontProd"

	END WSRESTFUL

WSMETHOD POST WSSERVICE ApontProd

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cEmp 	:= "01"
	Local _cFil		:= "05"
	Local _nX
	Local aData
	Local _cQuery1  := ""
	Local _cAlias1  := ""
	Local cD3TM    	 := ""
	Private lMsErroAuto := .F.
	Private lMSHelpAuto := .T.

	cD3TM    	 := GetMV("ST_XAPTOP",,"100")

	_cAlias1 := GetNextAlias()

	ConOut("[ApontProd]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[ApontProd]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	If !_lRet
		cResp := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	DbSelectArea("SC2")
	SC2->(DbSetOrder(1))
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	If !SC2->(DbSeek(xFilial("SC2")+oInfo:H6_OP))
		cResp := '{"CODRET":"02","DESCRET":"OP nao encontrada, verifique!"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	If !VLDOP()
		cResp := '{"CODRET":"03","DESCRET":"Ordem de producao sem ordem de separacao"}
		::SetResponse(cResp)
		Return .T.	
	EndIf

	_cQuery1 := ""
	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SRA")+" RA
	_cQuery1 += " WHERE RA.D_E_L_E_T_=' ' AND RA_FILIAL='"+cFilAnt+"' AND RA_MAT='"+oInfo:MAT+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		cResp := '{"CODRET":"02","DESCRET":"MATRICULA NAO ENCONTRADA"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	SB1->(DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))

	If Val(oInfo:H6_QUANTIDADE)>SC2->(C2_QUANT-C2_QUJE)
		cResp := '{"CODRET":"02","DESCRET":"Quantidade apontada maior que o saldo!"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	If Val(oInfo:H6_QUANTIDADE)==SC2->(C2_QUANT-C2_QUJE)
		_cParc := "T"
	Else
		_cParc := "P"
	EndIf

	_cDoc := ""
	_cAlias4 := GetNextAlias()

	_cQuery4 := " SELECT D3_DOC
	_cQuery4 += " FROM "+RetSqlName("SD3")+" D3
	_cQuery4 += " WHERE D3.D_E_L_E_T_=' ' AND D3_FILIAL='"+SC2->C2_FILIAL+"'
	_cQuery4 += " AND D3_TM='"+cD3TM+"' AND D3_COD='"+SC2->C2_PRODUTO+"'
	_cQuery4 += " AND D3_OP='"+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)+"'
	_cQuery4 += " ORDER BY D3_DOC DESC

	If !Empty(Select(_cAlias4))
		DbSelectArea(_cAlias4)
		(_cAlias4)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery4),_cAlias4,.T.,.T.)

	dbSelectArea(_cAlias4)
	(_cAlias4)->(dbGoTop())

	If (_cAlias4)->(!Eof())
		_cDoc := Soma1((_cAlias4)->D3_DOC)
	Else
		_cDoc := SC2->(C2_NUM+C2_ITEM)+"A"
	EndIf

	_aMata250 := {}

	aAdd(_aMata250, {"D3_TM"     	, cD3TM	             										, NIL})
	aAdd(_aMata250, {"D3_COD"     	, SC2->C2_PRODUTO		 										, NIL})
	aAdd(_aMata250, {"D3_UM"      	, SB1->B1_UM			 										, NIL})
	aAdd(_aMata250, {"D3_QUANT"   	, Val(oInfo:H6_QUANTIDADE) 										, NIL})
	aAdd(_aMata250, {"D3_PERDA"   	, 0                    		    							, NIL})
	aAdd(_aMata250, {"D3_OP"      	, SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)			 					, NIL})
	aAdd(_aMata250, {"D3_PARCTOT" 	, _cParc               										, NIL})
	aAdd(_aMata250, {"D3_LOCAL"   	, SC2->C2_LOCAL												, NIL})
	aAdd(_aMata250, {"D3_EMISSAO" 	, Date()            										, NIL})
	aAdd(_aMata250, {"D3_DOC" 		, _cDoc					             				, NIL})
	aAdd(_aMata250, {"D3_CF"   , "PR0"		 										, NIL})
	aAdd(_aMata250, {"D3_XMAT"   , oInfo:MAT 										, NIL})

	lMsErroAuto := .F.
	lMSHelpAuto := .T.

	msExecAuto({|x,y| MATA250(x,y)},_aMata250,3)

	If lMsErroAuto
		_cErro := MostraErro("arquivos\logs","STRESTK0"+dtos(date())+time()+".log")
		_cErro := StrTran(_cErro,'"','')
		cResp := '{"CODRET":"03","DESCRET":"'+_cErro+'"}
		::SetResponse(cResp)
		Return .T.
	Else

		If SC2->C2_QUANT<=SC2->C2_QUJE
			SC2->(RecLock("SC2",.F.))
			SC2->C2_XSTATUS := "E"
			SC2->(MsUnLock())
		EndIf

		cResp := '{"CODRET":"00","DESCRET":"APONTAMENTO FEITO COM SUCESSO!"}		
		::SetResponse(cResp)
		Return .T.
	EndIf

Return .T.

	WSRESTFUL cadPerda DESCRIPTION "Cadastrar perda"

WSMETHOD POST DESCRIPTION "Cadastrar perda" WSSYNTAX "/rest/cadPerda"

	END WSRESTFUL

WSMETHOD POST WSSERVICE cadPerda

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cEmp 	:= ""
	Local _cFil		:= ""
	Local _nX
	Local aData
	Local lApoPend  := .F.
	Private l681Auto 	:= .T.
	Private l240:=.F.,l250 :=.F.,l241:=.F.,l242:=.F.,l261:=.F.,l185:=.F.,l650:=.F.,l680:=.F.,l681:=.T.
	Private lMSErroAuto := .F.
	Private lAutoErrNoFile := .T.
	Private lPerdInf    := .F.

	ConOut("[STRESTI0]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[STRESTI0]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	If !_lRet
		cResp := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	aData := ClassDataArr(oInfo)
	aCampos := {}
	aCabec  := {}
	aLinha  := {}

	DbSelectArea("SC2")
	SC2->(DbSetOrder(1))
	If !SC2->(DbSeek(xFilial("SC2")+oInfo:BC_OP))
		cResp := '{"CODRET":"03","DESCRET":"Ordem de producao nao existe"}
		::SetResponse(cResp)
		Return .T.	
	EndIf

	If !VLDOP()
		cResp := '{"CODRET":"03","DESCRET":"Ordem de producao sem ordem de separacao"}
		::SetResponse(cResp)
		Return .T.	
	EndIf

	_cQuery1 := ""
	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SRA")+" RA
	_cQuery1 += " WHERE RA.D_E_L_E_T_=' ' AND RA_FILIAL='"+cFilAnt+"' AND RA_MAT='"+oInfo:MAT+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		cResp := '{"CODRET":"02","DESCRET":"MATRICULA NAO ENCONTRADA"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	For _nX:=1 To Len(aData)
		If AllTrim(aData[_nX][1]) $ "BC_OP#BC_OPERAC#BC_RECURSO"
			aadd(aCabec,{aData[_nX][1],U_STRESTI1(aData[_nX][1],aData[_nX][2]),Nil})
		Else
			aadd(aCampos,{aData[_nX][1],U_STRESTI1(aData[_nX][1],aData[_nX][2]),Nil})
		EndIf
	Next

	AADD(aCabec,{"BC_PRODUTO",SC2->C2_PRODUTO,NIL})
	AADD(aCabec,{"BC_XMAT",oInfo:MAT,NIL})
	AADD(aCampos,{"BC_XMAT",oInfo:MAT,NIL})

	aCabec  := FWVetByDic( aCabec  , 'SBC' )
	aCampos := FWVetByDic( aCampos , 'SBC' )

	AAdd(aLinha ,aCampos)

	lApoPend  	:= SuperGetMV("MV_APPENMO",.F.,"1")
	lPerdInf    := SuperGetMV("MV_PERDINF",.F.,.F.)

	_cQuery1 := ""
	_cAlias1 := GetNextAlias()

	lMSErroAuto := .F.
	lMSHelpAuto := .F.

	MsExecAuto ( {|x,y,z| MATA685(x,y,z) }, aCabec, aLinha, 3)

	_cErro := ""

	If lMsErroAuto
		aErroAuto := GetAutoGRLog()
		For _nX:=1 To Len(aErroAuto)
			//If "INVALIDO"$UPPER(aErroAuto[_nX])
				_cErro += aErroAuto[_nX]+Chr(13)+Chr(10)
			//EndIf
		Next
		_cErro := StrTran(_cErro,'"','')
		cResp := '{"CODRET":"03","DESCRET":"'+_cErro+'"}
		::SetResponse(cResp)		
		Return .T.
	Else
		cResp := '{"CODRET":"00","DESCRET":"Apontamento realizado."}
		::SetResponse(cResp)
		Return .T.
	EndIf

Return .T.

	WSRESTFUL DelPerda DESCRIPTION "Deleta apontamento de perda"

WSMETHOD POST DESCRIPTION "Deleta apontamento de perda" WSSYNTAX "/rest/DelPerda"

	END WSRESTFUL

WSMETHOD POST WSSERVICE DelPerda

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cEmp 	:= "01"
	Local _cFil		:= "05"
	Local _nX
	Local aData
	Local _cQuery1  := ""
	Local _cAlias1  := ""

	_cAlias1 := GetNextAlias()

	ConOut("[DelApont1]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[DelApont1]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	If !_lRet
		cResp := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	DbSelectArea("SBC")
	SBC->(DbGoTo(oInfo:RECNO))
	If SBC->(!Eof())
	
		SBC->(RecLock("SBC",.F.))
		SBC->(DbDelete())
		SBC->(MsUnLock())

		cResp := '{"CODRET":"00","DESCRET":"DELETADO COM SUCESSO"}		
		::SetResponse(cResp)
		Return .T.

	Else

		cResp := '{"CODRET":"01","DESCRET":"REGISTRO NAO ENCONTRADO"}
		::SetResponse(cResp)
		Return .T.

	EndIf

Return .T.

	WSRESTFUL GetPerda DESCRIPTION "Retorna apontamentos de perdas"

WSMETHOD POST DESCRIPTION "Retorna apontamentos de perdas" WSSYNTAX "/rest/GetPerda"

	END WSRESTFUL

WSMETHOD POST WSSERVICE GetPerda

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cEmp 	:= "01"
	Local _cFil		:= "05"
	Local _nX
	Local aData
	Local _cQuery1  := ""
	Local _cAlias1  := ""

	_cAlias1 := GetNextAlias()

	ConOut("[STRESTK0]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[STRESTK0]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	If !_lRet
		cResp := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	_cQuery1 := " SELECT BC.*
	_cQuery1 += " FROM "+RetSqlName("SBC")+" BC
	_cQuery1 += " WHERE BC.D_E_L_E_T_=' '
	_cQuery1 += " AND BC_FILIAL='"+cFilAnt+"'
	_cQuery1 += " AND BC_DATA='"+DTOS(Date())+"'
	_cQuery1 += " AND BC_XMAT='"+oInfo:MAT+"'
	_cQuery1 += " ORDER BY BC.R_E_C_N_O_ DESC

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		cResp := '[]
		::SetResponse(cResp)
		Return .T.
	EndIf

	cResp := '[

	While (_cAlias1)->(!Eof())
		
		cResp += '{
		cResp += '"BC_FILIAL":"'+(_cAlias1)->BC_FILIAL+'",
		cResp += '"BC_OP":"'+(_cAlias1)->BC_OP+'",
		cResp += '"BC_PRODUTO":"'+(_cAlias1)->BC_PRODUTO+'",
		cResp += '"BC_OPERAC":"'+(_cAlias1)->BC_OPERAC+'",
		cResp += '"BC_RECURSO":"'+(_cAlias1)->BC_RECURSO+'",
		cResp += '"BC_DATA":"'+DTOC(STOD((_cAlias1)->BC_DATA))+'",
		cResp += '"BC_LOCORIG":"'+(_cAlias1)->BC_LOCORIG+'",
		cResp += '"BC_LOCALIZ":"'+(_cAlias1)->BC_LOCALIZ+'",
		cResp += '"BC_TIPO":"'+(_cAlias1)->BC_TIPO+'",
		cResp += '"BC_QUANT":"'+cValToChar((_cAlias1)->BC_QUANT)+'",
		cResp += '"BC_MOTIVO":"'+(_cAlias1)->BC_MOTIVO+'",
		cResp += '"BC_CODDEST":"'+(_cAlias1)->BC_CODDEST+'",
		cResp += '"BC_LOCAL":"'+(_cAlias1)->BC_LOCAL+'",
		cResp += '"BC_LOCDEST":"'+(_cAlias1)->BC_LOCDEST+'",
		cResp += '"RECNO":"'+cValToChar((_cAlias1)->R_E_C_N_O_)+'"
		cResp += '}

		(_cAlias1)->(DbSkip())

		If (_cAlias1)->(!Eof())
			cResp += ',
		EndIf

	EndDo

	cResp += ']
	::SetResponse(cResp)

Return .T.

	WSRESTFUL GetProds DESCRIPTION "Retorna produtos da OP"

WSMETHOD POST DESCRIPTION "Retorna produtos da OP" WSSYNTAX "/rest/GetProds"

	END WSRESTFUL

WSMETHOD POST WSSERVICE GetProds

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cEmp 	:= "01"
	Local _cFil		:= "05"
	Local _nX
	Local aData
	Local _cQuery1  := ""
	Local _cAlias1  := ""

	_cAlias1 := GetNextAlias()

	ConOut("[STRESTK0]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[STRESTK0]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	If !_lRet
		cResp := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	_cQuery1 := " SELECT DISTINCT B1_COD, B1_DESC
	_cQuery1 += " FROM "+RetSqlName("SD4")+" D4
	_cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" B1
	_cQuery1 += " ON B1_COD=D4_COD
	_cQuery1 += " WHERE D4.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' 
	_cQuery1 += " AND D4_FILIAL='"+cFilAnt+"'
	_cQuery1 += " AND D4_OP='"+oInfo:BC_OP+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		cResp := '[]
		::SetResponse(cResp)
		Return .T.
	EndIf

	cResp := '[

	While (_cAlias1)->(!Eof())
		
		cResp += '{
		cResp += '"BC_PRODUTO":"'+AllTrim((_cAlias1)->B1_COD)+' - '+AllTrim((_cAlias1)->B1_DESC)+'"
		cResp += '}

		(_cAlias1)->(DbSkip())

		If (_cAlias1)->(!Eof())
			cResp += ',
		EndIf

	EndDo

	cResp += ']
	cResp := FwNoAccent(cResp)
	::SetResponse(cResp)

Return .T.

	WSRESTFUL GetProd DESCRIPTION "Retorna apontamentos de producao"

WSMETHOD POST DESCRIPTION "Retorna apontamentos de producao" WSSYNTAX "/rest/GetProd"

	END WSRESTFUL

WSMETHOD POST WSSERVICE GetProd

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cEmp 	:= "01"
	Local _cFil		:= "05"
	Local _nX
	Local aData
	Local _cQuery1  := ""
	Local _cAlias1  := ""

	_cAlias1 := GetNextAlias()

	ConOut("[STRESTI0]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[STRESTI0]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	If !_lRet
		cResp := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	_cQuery1 := " SELECT D3.*
	_cQuery1 += " FROM "+RetSqlName("SD3")+" D3
	_cQuery1 += " WHERE D3.D_E_L_E_T_=' '
	_cQuery1 += " AND D3_FILIAL='"+cFilAnt+"'
	_cQuery1 += " AND D3_EMISSAO>='"+DTOS(Date()-3)+"'
	_cQuery1 += " AND D3_TM='100' 
	_cQuery1 += " AND D3_ESTORNO=' ' AND D3_XMAT='"+oInfo:MAT+"'
	_cQuery1 += " ORDER BY D3.R_E_C_N_O_ DESC

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		cResp := '[]
		::SetResponse(cResp)
		Return .T.
	EndIf

	cResp := '[

	While (_cAlias1)->(!Eof())
		
		cResp += '{
		cResp += '"D3_FILIAL":"'+(_cAlias1)->D3_FILIAL+'",
		cResp += '"D3_COD":"'+AllTrim((_cAlias1)->D3_COD)+'",
		cResp += '"D3_QUANT":"'+cValToChar((_cAlias1)->D3_QUANT)+'",
		cResp += '"D3_OP":"'+AllTrim((_cAlias1)->D3_OP)+'",
		cResp += '"D3_EMISSAO":"'+DTOC(STOD((_cAlias1)->D3_EMISSAO))+'",
		cResp += '"RECNO":"'+cValToChar((_cAlias1)->R_E_C_N_O_)+'"
		cResp += '}

		(_cAlias1)->(DbSkip())

		If (_cAlias1)->(!Eof())
			cResp += ',
		EndIf

	EndDo

	cResp += ']
	::SetResponse(cResp)

Return .T.

	WSRESTFUL DelProd DESCRIPTION "Deleta apontamento de produção"

WSMETHOD POST DESCRIPTION "Deleta apontamento de produção" WSSYNTAX "/rest/DelProd"

	END WSRESTFUL

WSMETHOD POST WSSERVICE DelProd

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cEmp 	:= "01"
	Local _cFil		:= "05"
	Local _nX
	Local aData
	Local _cQuery1  := ""
	Local _cAlias1  := ""
	Local nOpc      := 5 
	Private lMsErroAuto     := .F.  

	_cAlias1 := GetNextAlias()

	ConOut("[DelProd]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[DelProd]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	oInfo := ""
	_lRet := FWJsonDeserialize(_cXmlRec,@oInfo)

	If !_lRet
		cResp := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	DbSelectArea("SD3")
	SD3->(DbGoTo(oInfo:RECNO))
	If SD3->(!Eof())

		aApont := {}

		Aadd(aApont,{"D3_DOC"	 ,SD3->D3_DOC		,Nil})
		Aadd(aApont,{"D3_OP"	 ,SD3->D3_OP		,Nil})
		Aadd(aApont,{"D3_COD"    ,SD3->D3_COD		,Nil})
		Aadd(aApont,{"D3_UM"     ,SD3->D3_UM		,Nil})
		Aadd(aApont,{"D3_QUANT"  ,SD3->D3_QUANT		,Nil}) 
		Aadd(aApont,{"D3_LOCAL"  ,SD3->D3_LOCAL		,Nil})
		Aadd(aApont,{"D3_CC"     ,SD3->D3_CC		,Nil})
		Aadd(aApont,{"D3_EMISSAO",SD3->D3_EMISSAO	,Nil}) 
		Aadd(aApont,{"D3_LOTECTL",SD3->D3_LOTECTL	,Nil})
		Aadd(aApont,{"D3_DTVALID",SD3->D3_DTVALID	,Nil}) 
		Aadd(aApont,{"D3_NUMSEQ" ,SD3->D3_NUMSEQ    ,Nil})
		Aadd(aApont,{"D3_CHAVE"	 ,SD3->D3_CHAVE		,Nil})
		Aadd(aApont,{"D3_CF"	 ,SD3->D3_CF		,Nil})
		aAdd(aApont,{"INDEX"     , 4        , Nil})

		lMsErroAuto     := .F.

		MsExecAuto({|x,y| MATA250(x,y)},aApont,5)

		If lMsErroAuto
			_cErro := MostraErro("arquivos\logs","STRESTI0"+dtos(date())+time()+".log")
			_cErro := StrTran(_cErro,'"','')
			cResp := '{"CODRET":"03","DESCRET":"'+_cErro+'"}
			::SetResponse(cResp)
			Return .T.
		Else
			cResp := '{"CODRET":"00","DESCRET":"Estornado com sucesso!"}
			::SetResponse(cResp)
			Return .T.
		EndIf

	Else

		cResp := '{"CODRET":"01","DESCRET":"REGISTRO NAO ENCONTRADO"}
		::SetResponse(cResp)
		Return .T.

	EndIf

Return .T.

Static Function VLDOP()

	Local _cApropri := ""
	Local _lApropri := .T.
	Local _c90      := ''
	Local _lLocProd := .T.
	Local _lOrdSep  := .T.
	Local aLocProd  := {}
	Local _cArmProd := AllTrim(GetMv("MV_LOCPROC"))+"-10"
	Local _nj

	Dbselectarea("SD4")
	SD4->(DbSetOrder(2))//D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
	SD4->(DbGoTop())
	DbSeek(xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
	While SD4->(! Eof() .and. D4_FILIAL+Left(D4_OP,11) == xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)

		DbSelectarea("SB1")
		SB1->(DbSetOrder(1))//B1_FILIAL+B1_COD
		SB1->(DbGoTop())
		If SB1->(DbSeek(xFilial("SB1")+(SD4->D4_COD)))
			_cApropri := SB1->B1_APROPRI
		Endif

		If Alltrim(_cApropri) == "D" .Or. Empty (_cApropri)
			_lApropri := .F.
			Exit
		Endif

		SD4->(DbSkip())
	End

	Dbselectarea("SD4")
	SD4->(DbSetOrder(2))//D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
	SD4->(DbGoTop())
	DbSeek(xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
	While SD4->(! Eof() .and. D4_FILIAL+Left(D4_OP,11) == xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)

		_c90 += ALLTRIM(SD4->D4_LOCAL)+'|'

		SD4->(DbSkip())
	End

	while (npos := at("|",_c90) ) > 0
		aadd( aLocProd,substr(_c90,1,npos-1) )
		_c90:= substr(_c90,npos+1,len(_c90))
	end

	For _nj := 1 to len(aLocProd)
		If aLocProd[_nj] $ _cArmProd
			_lLocProd := .T.
		Else
			_lLocProd := .F.
			Exit
		Endif
	Next _nj

	If !_lApropri  .And. !_lLocProd
		DbSelectarea("CB7")
		CB7->(DbSetOrder(5))//CB7_FILIAL+CB7_OP+CB7_LOCAL+CB7_STATUS
		CB7->(DbGoTop())
		If !CB7->(DbSeek(xFilial("SC2")+(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN))) .And. !(SC2->C2_XBENEF = 'S')//.And. cEmpAnt == '03'//STECK MANAUS
			_lOrdSep := .F.
		Endif
	Endif

Return(_lOrdSep)
