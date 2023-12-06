#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT300        | Autor | RENATO.OLIVEIRA           | Data | 29/11/2019  |
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

User Function STFAT300()

	Local cNewEmp 	:= "01"
	Local cNewFil 	:= "01"
	Local _cQuery1	:= ""
	Local _cAlias1  := ""
	Local oInfo
	Local nTimeOut 	:= 120
	Local cHeadRet 	:= ""
	Local aHeadOut 	:= {}

	Reset Environment
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT A1.R_E_C_N_O_ RECSA1
	_cQuery1 += " FROM "+RetSqlName("SA1")+" A1
	_cQuery1 += " WHERE A1.D_E_L_E_T_=' ' AND A1_VEND='EX0000' AND SUBSTR(A1_ATIVIDA,1,1) IN ('D','R')
	_cQuery1 += " AND A1_XDTATU=' '

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	_cToken := GetMv("ST_TOKSINT",,"170CA40A-64CE-4D58-AADC-07AE05DABB5E")

	DbSelectArea("SA1")

	While (_cAlias1)->(!Eof())

		SA1->(DbGoTo((_cAlias1)->RECSA1))

		cUrl := "https://www.sintegraws.com.br/api/v1/execute-api.php?token="+_cToken+"&cnpj="+AllTrim(SA1->A1_CGC)+"&plugin=RF"

		cHttpGet 	:= HttpSGet(cUrl,"","","","",nTimeOut,aHeadOut,@cHeadRet)
		_lRet    := FWJsonDeserialize(cHttpGet,@oInfo)

		If _lRet

			SA1->(RecLock("SA1",.F.))

			If AllTrim(oInfo:CODE)=="0"

				If AllTrim(Upper(oInfo:SITUACAO)) $ "INAPTA#BAIXADA#SUSPENSA"

					SA1->A1_ATIVIDA := "99"
					SA1->A1_GRPVEN  := "CA"
					SA1->A1_VEND	:= "R00099"
					SA1->A1_MSBLQL	:= "1"

				Else

					_cCep := StrTran(StrTran(AllTrim(oInfo:CEP),"."),"-")
					_cNum := AllTrim(oInfo:NUMERO)
					U_STCEP(_cCep,"4",_cNum)
					SA1->A1_NOME := AllTrim(oInfo:NOME)

				EndIf

			EndIf

			SA1->A1_XDTATU := Date()
			SA1->(MsUnLock())

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

Return()