#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TopConn.ch"

/*====================================================================================\
|Programa  | MT060VLD        | Autor | RENATO.NOGUEIRA            | Data | 26/11/2015 |
|=====================================================================================|
|Descri��o | MT060VLD                                                                 |
|          | Valida altera��o/inclus�o do produto x fornecedor                        |
|          | Chamado 002995                                                           |
|=====================================================================================|
|Sintaxe   | MT060VLD                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function MT060VLD()

	Local _aArea    := GetArea()
	Local _lRet	  	:= .F.
	Local _cQuery1	:= ""
	Local _cAlias1  := GetNextAlias()

	_lRet	:= U_STVLDSA2(M->A5_FORNECE,M->A5_LOJA) //Chamado 002995

	If !Empty(M->A5_XGRUPO) .AND. M->A5_XGRUPO $ '01#02#03#04#10'

		DbSelectArea("SA2")
		SA2->(DbSetOrder(1))
		SA2->(DbGoTop())
		If SA2->(DbSeek(xFilial("SA2")+M->(A5_FORNECE+A5_LOJA)))

			If SA2->A2_FATAVA < 60
				MsgAlert(" Favor revisar as informa��es do campo IQS no cadastro de Fornecedores "+ Chr(13) + Chr(10)+" Entrem em contato com o departamento da qualidade" )
				Return(.F.)
			EndIf

		EndIf

	EndIf

	//If AllTrim(__cUserId) $ AllTrim(GetMv("ST060VLD1",,"001137#000386#000199#000276#000285#000010"))

	_cQuery1 := " SELECT COUNT(*) QTD
	_cQuery1 += " FROM "+RetSqlName("SRA")+" RA
	_cQuery1 += " WHERE RA.D_E_L_E_T_=' ' AND RA_XUSRCFG='"+__cUserId+"'
	_cQuery1 += " AND RA_DEPTO IN ("+GetMv("ST_DPTOMKT",,"'000000007','000000180','000000181'")+")

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		If (_cAlias1)->QTD>0 //Usu�rio MKT

			If Empty(M->A5_FORNECE)
				MsgAlert("Aten��o, campo Fabricante � obrigat�rio!")
				Return(.F.)
			EndIf
			If Empty(M->A5_FALOJA)
				MsgAlert("Aten��o, campo Loja Fabric. � obrigat�rio!")
				Return(.F.)
			EndIf
			If Empty(M->A5_VLCOTUS)
				MsgAlert("Aten��o, campo Vlr.Cotacao � obrigat�rio!")
				Return(.F.)
			EndIf
			If Empty(M->A5_MOE_US)
				MsgAlert("Aten��o, campo Moeda Utiliz � obrigat�rio!")
				Return(.F.)
			EndIf
			If Empty(M->A5_PARTOPC)
				MsgAlert("Aten��o, campo Part-Num.Opc � obrigat�rio!")
				Return(.F.)
			EndIf

		EndIf
	EndIf

	RestArea(_aArea)

Return(_lRet)