#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STEST050        | Autor | RENATO.OLIVEIRA           | Data | 26/12/2018  |
|=====================================================================================|
|Descrição | Rotina para ajustar OSs duplicadas                                       |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STEST050()

	Local cNewEmp 	:= "01"
	Local cNewFil 	:= "02"
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _cQuery2 	:= ""
	Local _cAlias2 	:= ""
	Local _cQuery3 	:= ""
	Local _cAlias3 	:= ""
	Local _cNextCB7 := "378454"

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 	:= GetNextAlias()
	_cAlias2 	:= GetNextAlias()
	_cAlias3 	:= GetNextAlias()

	DbSelectArea("CB8")
	DbSelectArea("SC9")
	DbSelectArea("SDC")
	SDC->(DbSetOrder(1))
	DbSelectArea("SBF")
	SBF->(DbSetOrder(1))

	_cQuery1 := " SELECT CB8_FILIAL, CB8_ORDSEP, PEDIDO
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT WWW.*,
	_cQuery1 += " (SELECT MAX(CB8_PEDIDO)
	_cQuery1 += " FROM CB8010 CB8
	_cQuery1 += " WHERE CB8.D_E_L_E_T_=' ' AND CB8.R_E_C_N_O_=WWW.MAXREC) PEDIDO
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT YYY.*
	_cQuery1 += " ,(SELECT MAX(CB8.R_E_C_N_O_)
	_cQuery1 += " FROM CB8010 CB8
	_cQuery1 += " WHERE CB8.D_E_L_E_T_=' ' AND CB8_FILIAL=YYY.CB8_FILIAL AND CB8_ORDSEP=YYY.CB8_ORDSEP
	_cQuery1 += " ) MAXREC
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT CB8_FILIAL, CB8_ORDSEP, COUNT(*) QTD
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT DISTINCT CB8_FILIAL, CB8_ORDSEP, CB8_PEDIDO
	_cQuery1 += " FROM CB8010 CB8
	_cQuery1 += " WHERE CB8.D_E_L_E_T_=' ' AND CB8_FILIAL='02' AND CB8_ORDSEP>='376000'
	_cQuery1 += " ) XXX
	_cQuery1 += " GROUP BY CB8_FILIAL, CB8_ORDSEP
	_cQuery1 += " ) YYY
	_cQuery1 += " WHERE QTD>1
	_cQuery1 += " ORDER BY CB8_ORDSEP
	_cQuery1 += " ) WWW
	_cQuery1 += " ) KKK

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_cQuery2 := " SELECT CB8.R_E_C_N_O_ RECCB8
		_cQuery2 += " FROM CB8010 CB8
		_cQuery2 += " WHERE CB8.D_E_L_E_T_=' ' AND CB8_FILIAL='"+(_cAlias1)->CB8_FILIAL+"'
		_cQuery2 += " AND CB8_ORDSEP='"+(_cAlias1)->CB8_ORDSEP+"' AND CB8_PEDIDO='"+(_cAlias1)->PEDIDO+"'
		_cQuery2 += " ORDER BY CB8_FILIAL, CB8_ORDSEP, CB8_PEDIDO, CB8_ITEM

		If !Empty(Select(_cAlias2))
			DbSelectArea(_cAlias2)
			(_cAlias2)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

		dbSelectArea(_cAlias2)
		(_cAlias2)->(dbGoTop())

		While (_cAlias2)->(!Eof())

			CB8->(DbGoTo((_cAlias2)->RECCB8))

			If CB8->(!Eof())

				//Limpar SC9
				_cQuery3 := " SELECT C9.R_E_C_N_O_ SC9REC
				_cQuery3 += " FROM SC9010 C9
				_cQuery3 += " WHERE C9.D_E_L_E_T_=' ' AND C9_FILIAL='"+CB8->CB8_FILIAL+"'
				_cQuery3 += " AND C9_PEDIDO='"+CB8->CB8_PEDIDO+"' AND C9_ITEM='"+CB8->CB8_ITEM+"'
				_cQuery3 += " AND C9_NFISCAL=' ' AND C9_BLEST=' ' AND C9_ORDSEP='"+CB8->CB8_ORDSEP+"'

				If !Empty(Select(_cAlias3))
					DbSelectArea(_cAlias3)
					(_cAlias3)->(dbCloseArea())
				Endif

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

				dbSelectArea(_cAlias3)
				(_cAlias3)->(dbGoTop())

				If (_cAlias3)->(!Eof())

					SC9->(DbGoTo((_cAlias3)->SC9REC))

					If SC9->(!Eof())

						SC9->(RecLock("SC9",.F.))
						SC9->C9_BLEST := "02"
						SC9->C9_ORDSEP:= ""
						SC9->(MsUnLock())

					EndIf

				EndIf

				//Limpar SDC
				If SDC->(DbSeek(CB8->(CB8_FILIAL+CB8_PROD+CB8_LOCAL+"SC6"+CB8_PEDIDO+CB8_ITEM+CB8_SEQUEN)))

					If SBF->(DbSeek(SDC->(DC_FILIAL+DC_LOCAL+DC_LOCALIZ+DC_PRODUTO)))

						SBF->(RecLock("SBF",.F.))
						SBF->BF_EMPENHO -= SDC->DC_QUANT
						SBF->(MsUnLock())

						SDC->(RecLock("SDC",.F.))
						SDC->(DbDelete())
						SDC->(MsUnLock())

					EndIf

				EndIf

				CB8->(RecLock("CB8",.F.))
				CB8->(DbDelete())
				CB8->(MsUnLock())

			EndIf

			(_cAlias2)->(DbSkip())
		EndDo

		(_cAlias1)->(DbSkip())
	EndDo

Return()