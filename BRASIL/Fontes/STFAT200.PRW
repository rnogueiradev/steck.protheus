#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT200        | Autor | RENATO.OLIVEIRA           | Data | 14/08/2019  |
|=====================================================================================|
|Descrição | Comparar rotas antigas com novas TNT		                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT200()

	Local _cQuery1 := ""
	Local _cAlias1 := ""
	Local _cQuery2 := ""
	Local _cAlias2 := ""
	Local _cQuery8 := ""
	Local _cAlias8 := ""
	Local _aDivs   := {}
	Local _nX

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	_cAlias1 := GetNextAlias()
	_cAlias2 := GetNextAlias()
	_cAlias8 := GetNextAlias()

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM SF2010 F2
	_cQuery1 += " WHERE F2.D_E_L_E_T_=' ' AND F2_FILIAL='02' AND F2_TRANSP='000163' AND SUBSTR(F2_EMISSAO,1,6)='201908'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	DbSelectArea("CB7")
	CB7->(DbSetOrder(4))

	While (_cAlias1)->(!Eof())

		SD2->(DbSeek((_cAlias1)->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
		SC5->(DbSeek(SD2->(D2_FILIAL+D2_PEDIDO)))
		CB7->(DbSeek(SD2->(D2_FILIAL+D2_DOC+D2_SERIE)))

		If SC5->(!Eof())

			_aEndEnt := U_STTNT011()

			_cQuery8 := " SELECT *
			_cQuery8 += " FROM SZV030 ZV
			_cQuery8 += " WHERE ZV.D_E_L_E_T_=' ' AND '"+_aEndEnt[1][1]+"' BETWEEN ZV_CEPDE AND ZV_CEPATE

			If !Empty(Select(_cAlias8))
				DbSelectArea(_cAlias8)
				(_cAlias8)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery8),_cAlias8,.T.,.T.)

			dbSelectArea(_cAlias8)

			(_cAlias8)->(dbGoTop())

			If (_cAlias8)->(!Eof())

				_cQuery2 := " SELECT *
				_cQuery2 += " FROM SZV010 ZV
				_cQuery2 += " WHERE ZV.D_E_L_E_T_=' ' AND '"+_aEndEnt[1][1]+"' BETWEEN ZV_CEPDE AND ZV_CEPATE

				If !Empty(Select(_cAlias2))
					DbSelectArea(_cAlias2)
					(_cAlias2)->(dbCloseArea())
				Endif

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

				dbSelectArea(_cAlias2)

				(_cAlias2)->(dbGoTop())

				_cOld := SD2->D2_DOC+";"+CB7->CB7_ORDSEP+";"+_aEndEnt[1][1]+";"+(_cAlias8)->ZV_CEPDE+";";
				+(_cAlias8)->ZV_CEPATE+";"+(_cAlias8)->ZV_PARTIDA+";"+(_cAlias8)->ZV_TIPO+";"+(_cAlias8)->ZV_DESTINO+";";
				+(_cAlias8)->ZV_CODIGO+";"+(_cAlias8)->ZV_SEQ+";"

				If (_cAlias2)->(Eof()) //Não encontrada na nova				
					_cNew := ""
				Else
					_cNew := SD2->D2_DOC+";"+CB7->CB7_ORDSEP+";"+_aEndEnt[1][1]+";"+(_cAlias2)->ZV_CEPDE+";";
					+(_cAlias2)->ZV_CEPATE+";"+(_cAlias2)->ZV_PARTIDA+";"+(_cAlias2)->ZV_TIPO+";"+(_cAlias2)->ZV_DESTINO+";";
					+(_cAlias2)->ZV_CODIGO+";"+(_cAlias2)->ZV_SEQ+";"
				EndIf

				If !(_cOld==_cNew)
					AADD(_aDivs,{_cOld,_cNew})
				EndIf

			EndIf

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	_cCsv := ""

	For _nX:=1 To Len(_aDivs)
		_cCsv += _aDivs[_nX][1]+_aDivs[_nX][2]+chr(13)+chr(10)
	Next

Return()