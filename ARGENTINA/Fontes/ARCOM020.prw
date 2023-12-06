#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | ARCOM020        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function ARCOM020()

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local _aDados  := {}
	Local _cLog    := ""
	Local _nX

	RpcSetType( 3 )
	RpcSetEnv("07","01",,,"FIN")
	
	//=CONCATENAR("AADD(_aDados,{'";C2;"','";A2;"'})")

	AADD(_aDados,{'47608812','11/12/2018'})
	AADD(_aDados,{'1115','11/12/2018'})
	AADD(_aDados,{'923502','11/12/2018'})
	AADD(_aDados,{'92897253','11/12/2018'})
	AADD(_aDados,{'92849839','11/12/2018'})
	AADD(_aDados,{'93156149','11/12/2018'})
	AADD(_aDados,{'93154360','11/12/2018'})
	AADD(_aDados,{'649017','11/12/2018'})
	AADD(_aDados,{'20566819','11/12/2018'})
	AADD(_aDados,{'19809799','11/12/2018'})
	AADD(_aDados,{'77033520','11/12/2018'})
	AADD(_aDados,{'89764323','11/12/2018'})
	AADD(_aDados,{'89764518','11/12/2018'})
	AADD(_aDados,{'14800110','11/12/2018'})
	AADD(_aDados,{'3606','11/12/2018'})
	AADD(_aDados,{'1696','11/12/2018'})
	AADD(_aDados,{'34254697','11/12/2018'})
	AADD(_aDados,{'50403829','11/12/2018'})
	AADD(_aDados,{'85668397','11/12/2018'})
	AADD(_aDados,{'85783271','11/12/2018'})
	AADD(_aDados,{'48190909','12/12/2018'})
	AADD(_aDados,{'244359','12/12/2018'})
	AADD(_aDados,{'221','12/12/2018'})
	AADD(_aDados,{'58548674','14/12/2018'})
	AADD(_aDados,{'65943267','19/12/2018'})
	AADD(_aDados,{'1171','19/12/2018'})
	AADD(_aDados,{'210','19/12/2018'})
	AADD(_aDados,{'48123','19/12/2018'})
	AADD(_aDados,{'11874','19/12/2018'})
	AADD(_aDados,{'57980758','19/12/2018'})
	AADD(_aDados,{'3932801','19/12/2018'})
	AADD(_aDados,{'9050979','19/12/2018'})
	AADD(_aDados,{'9465119','19/12/2018'})
	AADD(_aDados,{'9484656','19/12/2018'})
	AADD(_aDados,{'9488201','19/12/2018'})
	AADD(_aDados,{'4025605','19/12/2018'})
	AADD(_aDados,{'48228405','20/12/2018'})
	AADD(_aDados,{'504346','20/12/2018'})
	AADD(_aDados,{'998','20/12/2018'})
	AADD(_aDados,{'2643023','20/12/2018'})
	AADD(_aDados,{'1187','20/12/2018'})
	AADD(_aDados,{'41055936','20/12/2018'})
	AADD(_aDados,{'76805934','20/12/2018'})
	AADD(_aDados,{'6774','20/12/2018'})
	AADD(_aDados,{'17501460','20/12/2018'})
	AADD(_aDados,{'58577566','20/12/2018'})
	AADD(_aDados,{'34812500','20/12/2018'})
	AADD(_aDados,{'42916007','20/12/2018'})
	AADD(_aDados,{'9514028','20/12/2018'})
	AADD(_aDados,{'90494964','20/12/2018'})
	AADD(_aDados,{'13900517','20/12/2018'})
	AADD(_aDados,{'735916','21/12/2018'})
	AADD(_aDados,{'3045699','27/12/2018'})
	AADD(_aDados,{'486252','27/12/2018'})
	AADD(_aDados,{'486257','27/12/2018'})
	AADD(_aDados,{'31855721','27/12/2018'})
	AADD(_aDados,{'7173625','27/12/2018'})
	AADD(_aDados,{'1537702','28/12/2018'})
	AADD(_aDados,{'50500876','28/12/2018'})

	For _nX:=1 To Len(_aDados)

		_cQuery1 := " SELECT R_E_C_N_O_
		_cQuery1 += " FROM "+RetSqlName("SE5")+" E5
		_cQuery1 += " WHERE E5.D_E_L_E_T_=' ' AND E5_NUMERO='"+_aDados[_nX][1]+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		DbSelectArea("SE5")

		If (_cAlias1)->(!Eof())

			SE5->(DbGoTo((_cAlias1)->R_E_C_N_O_))

			If SE5->(!Eof())
				SE5->(RecLock("SE5",.F.))
				SE5->E5_DATA	:= CTOD(_aDados[_nX][2])
				SE5->E5_DTDIGIT := CTOD(_aDados[_nX][2])
				SE5->E5_DTDISPO := CTOD(_aDados[_nX][2])
				SE5->(MsUnLock())

				_cLog += _aDados[_nX][1]+" alterado"+CHR(13) +CHR(10)

			EndIf

		Else

			_cLog += _aDados[_nX][1]+" nao encontrado"+CHR(13) +CHR(10)

		EndIf

	Next

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Resumo do processamento'
	@ 005,005 Get _cLog Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return()