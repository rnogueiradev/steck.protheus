#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"

/*====================================================================================\
|Programa  | STEST120         | Autor | Renato Nogueira            | Data | 15/10/2019|
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                     	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STEST120()

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local aCabEnd  		:= {}
	Local aItensEnd		:= {}

	DbSelectArea("SDA")

	_cQuery1 += " SELECT D1_FILIAL, D1_COD, D1_QUANT, D1_SERIE, D1_FORNECE, D1_LOJA, B1_LOCPAD, D1_EMISSAO, D1_NUMSEQ, D1_DOC
	_cQuery1 += " FROM "+RetSqlName("SD1")+" D1
	_cQuery1 += " LEFT JOIN "+RetSqlName("SDA")+" DA
	_cQuery1 += " ON DA_FILIAL=D1_FILIAL AND DA_PRODUTO=D1_COD AND DA_DOC=D1_DOC AND DA_SERIE=D1_SERIE AND DA_CLIFOR=D1_FORNECE AND DA_LOJA=D1_LOJA AND DA_ORIGEM='SD1'
	_cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" B1
	_cQuery1 += " ON B1_COD=D1_COD
	_cQuery1 += " WHERE D1.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' '
	_cQuery1 += " AND D1_DOC='000367791' AND D1_FILIAL='02' AND DA_DOC IS NULL

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		SDA->(RecLock("SDA",.T.))
		SDA->DA_FILIAL 	:= (_cAlias1)->D1_FILIAL
		SDA->DA_PRODUTO := (_cAlias1)->D1_COD
		SDA->DA_QTDORI 	:= (_cAlias1)->D1_QUANT
		SDA->DA_SALDO 	:= (_cAlias1)->D1_QUANT
		SDA->DA_DATA 	:= STOD((_cAlias1)->D1_EMISSAO)
		SDA->DA_LOCAL 	:= (_cAlias1)->B1_LOCPAD
		SDA->DA_DOC 	:= (_cAlias1)->D1_DOC
		SDA->DA_SERIE 	:= (_cAlias1)->D1_SERIE
		SDA->DA_CLIFOR 	:= (_cAlias1)->D1_FORNECE
		SDA->DA_LOJA 	:= (_cAlias1)->D1_LOJA
		SDA->DA_TIPONF 	:= "N"
		SDA->DA_ORIGEM 	:= "NF"
		SDA->DA_NUMSEQ 	:= (_cAlias1)->D1_NUMSEQ
		SDA->DA_XUSER	:= "STEST120"
		SDA->(MsUnLock())

		(_cAlias1)->(DbSkip())
	EndDo
