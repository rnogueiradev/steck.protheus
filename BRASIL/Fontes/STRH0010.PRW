#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STRH0010        | Autor | RENATO.OLIVEIRA           | Data | 31/10/2019  |
|=====================================================================================|
|Descrição | Rotina utilizada para gerar os pagtos do banco de horas                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STRH0010()

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local _cArq	   := "RGB_FILIAL RGB_MAT RGB_PD RGB_HORAS"+CHR(13)+CHR(10)

	_cFile := cGetFile(,"Selecione o diretorio",,"",.T.,GETF_LOCALFLOPPY+GETF_LOCALHARD+128)
	If Empty(_cFile)
		MsgAlert("Diretório não selecionado, verifique!")
		Return
	EndIf

	_cFile += DTOS(Date())+StrTran(Time(),":","")+".txt"

	_cQuery1 := " SELECT PI_FILIAL, PI_MAT, NVL(PD4_QTDHRS,0) DESCONT, NVL(PD8_QTDHRS,0) ACRESC
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT *
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT PI_FILIAL, PI_MAT, SUBSTR(PI_PD,1,1) PI_PD, SUM(NVL(PI_QUANTV,0)) QTDHRS
	_cQuery1 += " FROM "+RetSqlName("SPI")+" SPI
	_cQuery1 += " WHERE SPI.D_E_L_E_T_=' ' AND PI_STATUS=' '
	_cQuery1 += " GROUP BY PI_FILIAL, PI_MAT, SUBSTR(PI_PD,1,1)
	_cQuery1 += " ORDER BY PI_FILIAL, PI_MAT, SUBSTR(PI_PD,1,1) DESC
	_cQuery1 += " ) XXX
	_cQuery1 += " PIVOT ( SUM(QTDHRS) AS QTDHRS FOR (PI_PD) IN ('4' AS PD4, '8' AS PD8) )
	_cQuery1 += " ORDER BY PI_FILIAL, PI_MAT
	_cQuery1 += " ) YYY

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_cVerba	 := ""
		_nQtdHrs := (_cAlias1)->(ACRESC-DESCONT)
		If _nQtdHrs<0 //desconto
			_nQtdHrs := _nQtdHrs*-1
			_cVerba  := "520"
			_cArq += (_cAlias1)->PI_FILIAL+" "+(_cAlias1)->PI_MAT+" "+_cVerba+" "+StrTran(Transform(_nQtdHrs,"@E 99.99"),",",".")+CHR(13)+CHR(10)
		Else
			If _nQtdHrs>60
				//MAIOR QUE 60
				_cVerba  := "353"
				_cArq += (_cAlias1)->PI_FILIAL+" "+(_cAlias1)->PI_MAT+" "+_cVerba+" "+StrTran(Transform(_nQtdHrs-60,"@E 99.99"),",",".")+CHR(13)+CHR(10)
				//40 ATÉ 60
				_cVerba  := "352"
				_cArq += (_cAlias1)->PI_FILIAL+" "+(_cAlias1)->PI_MAT+" "+_cVerba+" "+StrTran(Transform(20,"@E 99.99"),",",".")+CHR(13)+CHR(10)
				//25 ATÉ 40
				_cVerba  := "351"
				_cArq += (_cAlias1)->PI_FILIAL+" "+(_cAlias1)->PI_MAT+" "+_cVerba+" "+StrTran(Transform(15,"@E 99.99"),",",".")+CHR(13)+CHR(10)
				//ATÉ 25
				_cVerba  := "200"
				_cArq += (_cAlias1)->PI_FILIAL+" "+(_cAlias1)->PI_MAT+" "+_cVerba+" "+StrTran(Transform(25,"@E 99.99"),",",".")+CHR(13)+CHR(10)
			ElseIf _nQtdHrs>40
				//40 ATÉ 60
				_cVerba  := "352"
				_cArq += (_cAlias1)->PI_FILIAL+" "+(_cAlias1)->PI_MAT+" "+_cVerba+" "+StrTran(Transform(_nQtdHrs-40,"@E 99.99"),",",".")+CHR(13)+CHR(10)
				//25 ATÉ 40
				_cVerba  := "351"
				_cArq += (_cAlias1)->PI_FILIAL+" "+(_cAlias1)->PI_MAT+" "+_cVerba+" "+StrTran(Transform(15,"@E 99.99"),",",".")+CHR(13)+CHR(10)
				//ATÉ 25
				_cVerba  := "200"
				_cArq += (_cAlias1)->PI_FILIAL+" "+(_cAlias1)->PI_MAT+" "+_cVerba+" "+StrTran(Transform(25,"@E 99.99"),",",".")+CHR(13)+CHR(10)
			ElseIf _nQtdHrs>25
				//25 ATÉ 40
				_cVerba  := "351"
				_cArq += (_cAlias1)->PI_FILIAL+" "+(_cAlias1)->PI_MAT+" "+_cVerba+" "+StrTran(Transform(_nQtdHrs-25,"@E 99.99"),",",".")+CHR(13)+CHR(10)
				//ATÉ 25
				_cVerba  := "200"
				_cArq += (_cAlias1)->PI_FILIAL+" "+(_cAlias1)->PI_MAT+" "+_cVerba+" "+StrTran(Transform(25,"@E 99.99"),",",".")+CHR(13)+CHR(10)
			Else
				//ATÉ 25
				_cVerba  := "200"
				_cArq += (_cAlias1)->PI_FILIAL+" "+(_cAlias1)->PI_MAT+" "+_cVerba+" "+StrTran(Transform(_nQtdHrs,"@E 99.99"),",",".")+CHR(13)+CHR(10)
			EndIf
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	nHdlImp := FCreate(_cFile)
	If nHdlImp <= 0
		MsgAlert("Falha na criação do arquivo")
		Return
	EndIf
	FWrite(nHdlImp,_cArq)
	FClose(nHdlImp)

	MsgAlert("Arquivo criado com sucesso em "+_cFile)

	GPEA210()

Return()