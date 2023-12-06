#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TopConn.ch"

#DEFINE VALMERC 	1  // Valor total do mercadoria
#DEFINE VALDESC 	2  // Valor total do desconto
#DEFINE VALIPI  	3  // Valor total do IPI
#DEFINE VALICM  	4  // Valor total do ICMS
#DEFINE FRETE   	5  // Valor total do Frete
#DEFINE VALDESP 	6  // Valor total da despesa
#DEFINE TOTF1		7  // Total de Despesas Folder 1
#DEFINE TOTPED		8  // Total do Pedido
#DEFINE BASEIPI 	9  // Base de IPI
#DEFINE BASEICM    10 // Base de ICMS
#DEFINE BASESOL    11 // Base do ICMS Sol.
#DEFINE VALSOL		12 // Valor do ICMS Sol.
#DEFINE VALCOMP 	13 // Valor do ICMS Com.
#DEFINE SEGURO		14 // Valor total do seguro
#DEFINE TOTF3		15 // Total utilizado no Folder 3

/*====================================================================================\
|Programa  | MT150OK         | Autor | RENATO.NOGUEIRA            | Data | 26/11/2015 |
|=====================================================================================|
|Descrição | MT150OK                                                                  |
|          | Valida fornecedor na rotina atualiza cotação                             |
|          | Chamado 002995                                                           |
|=====================================================================================|
|Sintaxe   | MT150OK                                                                  |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MT150OK()

	Local _aArea    := GetArea()
	Local _lRet	  	:= .F.
	Local _C8_XVL2UM 	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C8_XVL2UM" })
	Local _C8_TOTAL 	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C8_TOTAL" })
	Local _C8_PRECO 	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C8_PRECO" })
	Local _C8_QTSEGUM 	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C8_QTSEGUM" })
	Local _C8_QUANT 	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C8_QUANT" })
	Local _C8_BASEICM 	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C8_BASEICM" })
	Local _C8_VALFRE 	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C8_VALFRE" })
	Local _C8_VALICM 	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C8_VALICM" })
	Local _C8_PICM 		:= aScan(aHeader, { |x| Alltrim(x[2]) == "C8_PICM" })
	Local _nX 			:= 0
	Local _cQuery1 	:= ""
	Local _cAlias1  := GetNextAlias()
	Local _nTotal	:= 0 //Ticket 20200824006228 - Everson Santana - 28.08.2020

	_lRet	:= U_STVLDSA2(CA150FORN,CA150LOJ) //Chamado 002995

	If _lRet
		For _nX:=1 To Len(aCols)
			n := _nX
			If aCols[_nX][_C8_XVL2UM]>0
				aCols[_nX][_C8_TOTAL] := Round(aCols[_nX][_C8_XVL2UM] * aCols[_nX][_C8_QTSEGUM],TamSx3("C8_TOTAL")[2])
				aCols[_nX][_C8_PRECO] := Round(aCols[_nX][_C8_TOTAL] / aCols[_nX][_C8_QUANT],TamSx3("C8_PRECO")[2])
			EndIf
			_nTotal =+ aCols[_nX][_C8_TOTAL]  //A150Total(aCols[_nX][_C8_TOTAL]) //Ticket 20200824006228 - Everson Santana - 28.08.2020
			MaFisRef("IT_PRCUNI","MT150",aCols[_nX][_C8_PRECO])
			MaFisRef("IT_VALMERC","MT150",aCols[_nX][_C8_TOTAL])
		Next
		A150Total(_nTotal) //Ticket 20200824006228 - Everson Santana - 28.08.2020
		_nTotal := 0 
	EndIf

	If PARAMIXB[1]==2

		DbSelectArea("SA5")
		SA5->(DbSetOrder(1))

		DbSelectArea("SA2")
		SA2->(DbSetOrder(1))
		SA2->(DbSeek(xFilial("SA2")+cA150Forn+cA150Loj))

		_cQuery1 := " SELECT DISTINCT C8_PRODUTO
		_cQuery1 += " FROM "+RetSqlName("SC8")+" C8
		_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND C8_FILIAL='"+xFilial("SC8")+"'
		_cQuery1 += " AND C8_NUM='"+cA150Num+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		While (_cAlias1)->(!Eof())

			If !SA5->(DbSeek(xFilial("SA5")+cA150Forn+cA150Loj+(_cAlias1)->C8_PRODUTO))

				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))
				SB1->(DbSeek(xFilial("SB1")+(_cAlias1)->C8_PRODUTO))

				If SB1->(!Eof()) .And. SA2->(!Eof())
					SA5->(RecLock("SA5",.T.))
					SA5->A5_FILIAL 	:= xFilial("SA5")
					SA5->A5_FORNECE := cA150Forn
					SA5->A5_LOJA	:= cA150Loj
					SA5->A5_NOMEFOR	:= SA2->A2_NOME
					SA5->A5_PRODUTO := (_cAlias1)->C8_PRODUTO
					SA5->A5_NOMPROD	:= SB1->B1_DESC
					SA5->A5_SITU	:= "A"

					Do Case
						Case AllTrim(SA5->A5_FORNECE)=="005764" .And. AllTrim(SA5->A5_LOJA)$"01#02#03"
						SA5->A5_SITU 	:= "A"
						SA5->A5_SKPLOT 	:= "28"
						SA5->A5_TEMPLIM	:= 99
						Case AllTrim(SA5->A5_FORNECE)=="005866" .And. AllTrim(SA5->A5_LOJA)$"01"
						SA5->A5_SITU 	:= "A"
						SA5->A5_SKPLOT 	:= "28"
						SA5->A5_TEMPLIM	:= 99
					EndCase

					SA5->(MsUnLock())
				EndIf

			EndIf

			(_cAlias1)->(DbSkip())
		EndDo

	EndIf

	RestArea(_aArea)

Return(_lRet)
