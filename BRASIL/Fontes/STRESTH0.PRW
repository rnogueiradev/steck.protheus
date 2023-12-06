#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

Static lPrepEnv := u_xPrepEnv()

/*====================================================================================\
|Programa  | STRESTH0        | Autor | RENATO.OLIVEIRA           | Data | 01/09/2020  |
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

WSRESTFUL cadFunc DESCRIPTION "Cadastrar funcionários"

WSMETHOD POST DESCRIPTION "Cadastrar funcionário" WSSYNTAX "/rest/cadFunc"

END WSRESTFUL

WSMETHOD POST WSSERVICE cadFunc

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cEmp 	:= ""
	Local _cFil		:= ""
	Local aCabec	:= {}
	Local _nX
	Private lMsErroAuto := .F.

	ConOut("[STRESTH0]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[STRESTH0]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	_cXmlRec := FwCutOff(_cXmlRec,.T.)

	oInfo := ""
	_lRet := FWJsonDeserialize(FwNoAccent(_cXmlRec),@oInfo)

	If !_lRet
		cResp := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	SM0->(DBGoTop())
	While SM0->(!Eof())
		If AllTrim(SM0->M0_CGC)==AllTrim(oInfo:CNPJ)
			_cEmp := SM0->M0_CODIGO
			_cFil := SM0->M0_CODFIL
			Exit
		EndIf
		SM0->(DbSkip())
	EndDo

	If Empty(_cEmp)
		cResp := '{"CODRET":"02","DESCRET":"CNPJ NAO ENCONTRADO"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	_cCpf := ""

	DbSelectArea("SRA")
	SRA->(DbSetOrder(5))

	aData := ClassDataArr(oInfo)

	_cMat := GetSxENum("SRA","RA_MAT")
	SRA->(ConfirmSX8())

	aadd(aCabec,{"RA_FILIAL",_cFil,Nil})
	aadd(aCabec,{"RA_MAT",_cMat,Nil})
	aadd(aCabec,{"RA_XORIG","1",Nil})
	aadd(aCabec,{"RA_XREVISA","N",Nil})

	For _nX:=1 To Len(aData)
		If SubStr(aData[_nX][1],1,3)=="RA_" 
			If AllTrim(aData[_nX][1])=="RA_CEP" .Or. AllTrim(aData[_nX][1])=="RA_CEPCXPO" 
				aData[_nX][2] := StrTran(StrTran(aData[_nX][2],"-"),".")
			EndIf
			aadd(aCabec,{aData[_nX][1],U_STRESTH1(aData[_nX][1],aData[_nX][2]),Nil})
		EndIf
		If AllTrim(aData[_nX][1])=="RA_CIC"
			_cCpf := aData[_nX][2]
		EndIf
	Next

	If SRA->(Dbseek(_cFil+_cCpf))
		cResp := '{"CODRET":"04","DESCRET":"FUNCIONARIO JA CADASTRADO","MATRICULA":"'+_cEmp+_cFil+SRA->RA_MAT+'"}
		::SetResponse(cResp)
		Return .T.
	EndIf

	MSExecAuto({|x,y,k,w| GPEA010(x,y,k,w)},NIL,NIL,aCabec,3)

	If lMsErroAuto
		//SRA->(RollBackSX8())
		_cErro := MostraErro("arquivos\logs","STRESTH0"+dtos(date())+time()+".log")
		cResp := '{"CODRET":"03","DESCRET":"'+_cErro+'"}
		::SetResponse(cResp)
		Return .T.
	Else
		//SRA->(ConfirmSX8())
		cResp := '{"CODRET":"00","DESCRET":"Funcionario incluido com sucesso.","MATRICULA":"'+_cEmp+_cFil+_cMat+'"}
		::SetResponse(cResp)
		Return .T.		
	EndIf

	::SetResponse(cResp)

Return .T.

/*====================================================================================\
|Programa  | STRESTH1        | Autor | RENATO.OLIVEIRA           | Data | 02/09/2020  |
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

User Function STRESTH1(_cCampo,_cVal)

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
			_xVal := Val(_cVal)
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
