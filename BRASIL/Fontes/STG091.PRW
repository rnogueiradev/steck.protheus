#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Metodo   ณ STTMKG02 บAutor  ณ Donizeti Lopes     บ Data ณ  11/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Recupera o Saldo Atual do Produto.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ STECK                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบAltera็ใo ณ Giovani.Zago compatibiliza็ใo para funcionar no pedido de v.ฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STG091()

Local nSaldo   	    := 0	//Saldo Atual - Alterado Joใo Victor 16/02/2013 pois produto com saldo igual a Zero estava entrando na regra de que existe produto em estoque.
Local nDiasGrp 	    := 0
Local nDias		    := 0
Local aRetArray
Local _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
Local _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_PRODUTO"    ,"C6_PRODUTO"  	)   })
Local _nPosQtd      := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_QUANT"    ,"C6_QTDVEN"   	)   })
Local cProd	     	:= aCols[n,_nPosProd]
Local i
Local _nDow         := 0
Local _cQtdven      := IIF(  _Lmomat,"UB_QUANT"    ,"C6_QTDVEN"  	)
Local _cArmVen      := GetMv("ST_ARMVEN",,"01/03")

IIF (_cQtdven $ readvar(),lSaldo:=.F.,lSaldo:=.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Nao foi utilizada uma Entidade, pois a funcao   ณ
//ณ SaldoSB2 precisa que o SB2 esteja posicionado   ณ
//ณ para efetuar o calculo do Saldo Atual Disponivelณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aRetArray:=(U_STFSVE50(cProd,,,.T.))

If aRetArray <> NIL
	FOR i:=1 TO LEN(aRetArray)
		If Alltrim(aRetArray[i,2] )  $ _cArmVen
			nSaldo+=aRetArray[i,3]
		EndIf
	Next i
	Return (nSaldo)
EndIf


/// Tratamento da Data de Entrega
if !lSaldo
	nDias    := GETMV("ST_DIASALD",,2) 	// Parametro para acrescimo de dias com Saldo //GIOVANI ZAGO 01/03/13
	IF aCols[n,_nPosQtd] < nSaldo    	// Com Saldo - Soma a Database + Conte๚do do Parโmetro
		dtEntre:=DataValida(dDataBase + nDias, .T.)
	else                    			// Sem Saldo - Soma a Database + Conte๚do do Parโmetro + Conte๚do do PE do Produto ou Grupo de Produto
		
		cGrupo	:=GETADVFVAL("SB1","B1_GRUPO"  ,xFilial("SB1")+cProd ,1,"")   //COMENTADO GIOVANI ZAGO 01/03/13
		nDiasGrp:=GETADVFVAL("SBM","BM_ZDIASLD",xFilial("SBM")+cGrupo,1,"")
		
		nDias += nDiasGrp
		//	dtEntre:=DataValida(dDataBase + nDias, .T.)
		_nDow:= DOW(DDATABASE)
		If _nDow = 6
			nDias+=2
		ElseIf _nDow = 7
			nDias+=1
		Endif
		dtEntre:=DataValida(dDataBase + nDias, .T.)
		
		
	Endif
	Return dtEntre
Else
	Return (nSaldo) //- Alterado Joใo Victor 16/02/2013 pois produto com saldo igual a Zero estava entrando na regra de que existe produto em estoque.
Endif

Return	
