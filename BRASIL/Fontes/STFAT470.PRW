#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT470        | Autor | RENATO.OLIVEIRA           | Data | 15/09/2020  |
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

User Function STFAT470()

	Local _cQuery1 := ""
	Local _cAlias1 := ""
	Local cNewEmp  := "01"
	Local cNewFil  := "05"

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
	_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND C5_FILIAL='05' AND C5_XORDEM<>' ' AND C5_CLIENTE='012047' AND C5_LOJACLI='09'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))

	While (_cAlias1)->(!Eof())

		If SC5->(DbSeek((_cAlias1)->(C5_FILIAL+C5_NUM)))

			SC6->(DbSeek((_cAlias1)->(C5_FILIAL+C5_NUM)))
			While SC6->(!Eof()) .And. SC6->(C6_FILIAL+C6_NUM)==(_cAlias1)->(C5_FILIAL+C5_NUM)

				SC6->(RecLock("SC6",.F.))
				SC6->C6_ENTRE1 := U_atudtentre(0,SC6->C6_PRODUTO,0)
				SC6->(MsUnLock())

			SC6->(DbSkip())
			EndDo

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	MsgAlert("Finalizado")

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Metodo   ³ STTMKG02 ºAutor  ³ Donizeti Lopes     º Data ³  11/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recupera o Saldo Atual do Produto.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteração ³ Giovani.Zago compatibilização para funcionar no pedido de v.±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function STTMKG02()

	Local nSaldo   	    := 0	//Saldo Atual - Alterado João Victor 16/02/2013 pois produto com saldo igual a Zero estava entrando na regra de que existe produto em estoque.
	Local nDiasGrp 	    := 0
	Local nDias		    := 0
	Local aRetArray
	Local _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Local cProd	     	:= SC6->C6_PRODUTO
	Local i
	Local _nDow         := 0
	Local _cQtdven      := IIF(  _Lmomat,"UB_QUANT"    ,"C6_QTDVEN"  	)
	Local _cArmVen      := "01/03/15"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao foi utilizada uma Entidade, pois a funcao   ³
//³ SaldoSB2 precisa que o SB2 esteja posicionado   ³
//³ para efetuar o calculo do Saldo Atual Disponivel³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	lSaldo := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao foi utilizada uma Entidade, pois a funcao   ³
//³ SaldoSB2 precisa que o SB2 esteja posicionado   ³
//³ para efetuar o calculo do Saldo Atual Disponivel³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	aRetArray:=(U_STFSVE50(SC6->C6_PRODUTO,,,.T.))

	If aRetArray <> NIL
		FOR I=1 TO LEN(aRetArray)
			If Alltrim(aRetArray[i,2] )  $ _cArmVen
				nSaldo+=aRetArray[i,3]
			EndIf
		NEXT
	else
		//	ApMsgAlert("Não existe registro em estoque para este produto.","Atenção")
	EndIf


/// Tratamento da Data de Entrega
	if !lSaldo
		dtEntre:= u_atudtentre(nSaldo,	SC6->C6_PRODUTO ,	SC6->(C6_QTDVEN-C6_QTDENT) )



		Return dtEntre
	Else
		Return (nSaldo) //- Alterado João Victor 16/02/2013 pois produto com saldo igual a Zero estava entrando na regra de que existe produto em estoque.
	Endif

Return
