#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"

/*====================================================================================\
|Programa  | STEST090         | Autor | Renato Nogueira            | Data | 15/10/2019|
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

User Function STEST090()

	Local lRet			:= .T.
	Local cEan  		:= Space(13)
	Private _cCodigo 	:= Space(15)

	While lRet


		@ 0,0 VTSAY Padc("Buscar produto",VTMaxCol())
		@ 2,0 VTSAY "Leia o EAN"
		@ 3,0 VTGET cEan PICTURE "@!" VALID VLDCOD(cEan)

		@ 4,0 VTSAY "Codigo Steck"
		@ 5,0 VTGET _cCodigo PICTURE "@!" WHEN .F.

		VTREAD

		If VTLASTKEY()==27
			If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
				Return
			Endif
		Endif

	EndDo

Return()

/*====================================================================================\
|Programa  | VLDCOD           | Autor | Renato Nogueira            | Data | 16/10/2019|
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

Static Function VLDCOD(_cValor)

	Local _lRet 	:= .T.
	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()

	If Empty(_cValor)
		_cCodigo := Space(15)
		VTGetRefresh("_cCodigo")
		Return(.F.)
	EndIf

	_cCodigo := Space(15)

	_cQuery1 := " SELECT B1_COD
	_cQuery1 += " FROM "+RetSqlName("SB1")+" B1
	_cQuery1 += " LEFT JOIN "+RetSqlName("SB5")+" B5
	_cQuery1 += " ON B5_COD=B1_COD AND B5.D_E_L_E_T_=' '
	_cQuery1 += " WHERE B1.D_E_L_E_T_=' ' AND (
	_cQuery1 += " B1_CODBAR='"+_cValor+"' OR
	_cQuery1 += " '1'||SUBSTR(B1_CODBAR,1,12)='"+_cValor+"' OR
	_cQuery1 += " '2'||SUBSTR(B1_CODBAR,1,12)='"+_cValor+"' OR
	_cQuery1 += " '3'||SUBSTR(B1_CODBAR,1,12)='"+_cValor+"' OR
	_cQuery1 += " '4'||SUBSTR(B1_CODBAR,1,12)='"+_cValor+"' OR
	_cQuery1 += " '5'||SUBSTR(B1_CODBAR,1,12)='"+_cValor+"' OR
	_cQuery1 += " '6'||SUBSTR(B1_CODBAR,1,12)='"+_cValor+"' OR
	_cQuery1 += " '7'||SUBSTR(B1_CODBAR,1,12)='"+_cValor+"' OR
	_cQuery1 += " '8'||SUBSTR(B1_CODBAR,1,12)='"+_cValor+"'
	_cQuery1 += " )

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		_lRet := .F.
		VTALERT("Codigo nao encontrado, verifique!")
	Else 
		_cCodigo := (_cAlias1)->B1_COD
	EndIf
	
	VTGetRefresh("_cCodigo")

Return(_lRet)