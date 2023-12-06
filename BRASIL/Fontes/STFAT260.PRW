#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT260        | Autor | RENATO.OLIVEIRA           | Data | 31/10/2019  |
|=====================================================================================|
|Descrição | Rotina para carregar vendedores na tela de visistas                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT260()

	Local _cQuery1 := ""
	Local _cAlias1 := ""

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")
	
	_cAlias1 := GetNextAlias()

	DbSelectArea("Z1R")
	Z1R->(DbSetOrder(2))

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SA3")+" A3
	_cQuery1 += " WHERE A3.D_E_L_E_T_=' ' AND A3_NOME NOT LIKE '%ENCERRADO%' AND SUBSTR(A3_COD,1,1)='I'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		If !Z1R->(DbSeek(xFilial("Z1R")+(_cAlias1)->A3_COD))

			_cCod := GETSX8NUM("Z1R","Z1R_COD")

			Z1R->(RecLock("Z1R",.T.))
			Z1R->Z1R_COD 	:= _cCod
			Z1R->Z1R_USER	:= (_cAlias1)->A3_CODUSR
			Z1R->Z1R_NOME	:= (_cAlias1)->A3_NOME
			Z1R->Z1R_VEND	:= (_cAlias1)->A3_COD
			Z1R->(MsUnLock())

			Z1R->(ConfirmSX8())

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

Return()