#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT620        | Autor | RENATO.OLIVEIRA           | Data | 02/10/2022  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                    |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT620()

	Local _cQuery1 := ""
	Private aHeader := {}

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	_cAlias1 := GetNextAlias()

	DbSelectArea("SC5")

	_cQuery1 := " SELECT C5.R_E_C_N_O_ RECSC5
	_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
	_cQuery1 += " LEFT JOIN "+RetSqlName("ZZI")+" ZZI
	_cQuery1 += " ON ZZI_FILANT=C5_FILIAL AND ZZI_TIPO='PEDIDO' AND ZZI_NUM=C5_NUM AND ZZI.D_E_L_E_T_=' ' 
	_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND C5_ZBLOQ='1' AND C5_ZMOTBLO LIKE '%DESC%'
	_cQuery1 += " AND ZZI_NUM IS NULL

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())
		
	While (_cAlias1)->(!Eof())

		SC5->(DbGoTo((_cAlias1)->RECSC5))
		If SC5->(!Eof())
			U_STDESALC(.t.,.f.)
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

Return()

User Function STFAT621()

	Local _cQuery1 := ""
	Private aHeader := {}

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	_cAlias1 := GetNextAlias()

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	DbSelectArea("SUA")
	SUA->(DbSetOrder(1))

	_cQuery1 := " SELECT ZZI.R_E_C_N_O_ RECZZI
	_cQuery1 += " FROM "+RetSqlName("ZZI")+" ZZI
	_cQuery1 += " WHERE ZZI.D_E_L_E_T_=' ' AND ZZI_DATA>='"+DTOS(Date()-GetMv("STFAT62101",,30))+"'
	_cQuery1 += " AND ZZI_NUM='083776'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())
		
	While (_cAlias1)->(!Eof())

		ZZI->(DbGoTo((_cAlias1)->RECZZI))

		If ZZI->(!Eof())

			If AllTrim(ZZI->ZZI_TIPO)=="PEDIDO"

				SC5->(DbSetOrder(1))
				If SC5->(DbSeek(ZZI->(ZZI_FILANT+ZZI_NUM)))
					U_STDESALC(.t.,.f.,"PED")
				EndIf

			Else

				SUA->(DbSetOrder(1))
				If SUA->(DbSeek(ZZI->(ZZI_FILANT+ZZI_NUM)))
					U_STDESALC(.t.,.f.,"ORC")
				EndIf

			EndIf

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

Return()
