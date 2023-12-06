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
//Altera็ใo: Flแvia Rocha: 
//FR - 13/12/2021 - Tratativa para incluir no retorno, consulta estoque 
                    do(s) produto(s) #20210823016536 /  #task 732                    
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STTMKG02(xTipo,xProd,xQtde)

	Local nSaldo   	    := 0	//Saldo Atual - Alterado Joใo Victor 16/02/2013 pois produto com saldo igual a Zero estava entrando na regra de que existe produto em estoque.
	//Local nDiasGrp 	    := 0
	//Local nDias		    := 0
	Local aRetArray
	Local _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Local _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_PRODUTO"    ,"C6_PRODUTO"  	)   })
	Local _nPosQtd      := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_QUANT"    ,"C6_QTDVEN"   	)   })
	Local cProd	     	:= ""  //aCols[n,_nPosProd]		//FR - 20/12/2021 - Ticket #20210823016536
	Local i
	//Local _nDow         := 0
	Local _cQtdven      := IIF(  _Lmomat,"UB_QUANT"    ,"C6_QTDVEN"  	)
	Local _cArmVen      := GetMv("ST_ARMVEN",,"01/03")
	Local lRest			:= .F. //FR - 14/12/2021

	IIF (_cQtdven $ readvar(),lSaldo:=.F.,lSaldo:=.T.)
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Nao foi utilizada uma Entidade, pois a funcao   ณ
//ณ SaldoSB2 precisa que o SB2 esteja posicionado   ณ
//ณ para efetuar o calculo do Saldo Atual Disponivelณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	lRest := .F.		//FR - 14/12/2021
	
	IIF (_cQtdven $ readvar(),lSaldo:=.F.,lSaldo:=.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Nao foi utilizada uma Entidade, pois a funcao   ณ
//ณ SaldoSB2 precisa que o SB2 esteja posicionado   ณ
//ณ para efetuar o calculo do Saldo Atual Disponivelณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//FR - 13/12/2021 - Tratativa para incluir no retorno, consulta estoque do(s) produto(s) #task 732 
//FR - 08/04/2022 - Altera็ใo - incluํda na verifica็ใo abaixo se ้ a fun็ใo U_STCONSCOT pois ela executa via startjob                   
// Marcelo Klopfer - 28/07/2022 - Inclusใo da Chamada para a fun็ใo de Conssulta de Pre็os STCRM07A
If IsInCallStack("POST") .or. IsInCallStack("U_STCONSCOT") .OR. IsInCallStack("U_STCRM07A") 
	
	lRest := .T. 
	If xTipo <> Nil 
		If xTipo == "E" //ESTOQUE
			lSaldo := .T.
		Elseif xTipo == "D" // Dt entrega 
			lSaldo := .F.
		Endif 
		cProd  	:= xProd					//FR - 20/12/2021 - Ticket #20210823016536
	Else
		cProd  	:= aCols[n,_nPosProd]		//FR - 20/12/2021 - Ticket #20210823016536
		xQtde   := aCols[n,_nPosQtd]	
	Endif
	
Else
	cProd  	:= aCols[n,_nPosProd]		//FR - 20/12/2021 - Ticket #20210823016536
EndIf


	aRetArray:=(U_STFSVE50(cProd,,,.T.))

	If aRetArray <> NIL
		FOR I=1 TO LEN(aRetArray)
			If Alltrim(aRetArray[i,2] )  $ _cArmVen
				nSaldo+=aRetArray[i,3]
			EndIf
		NEXT
	else
	//	ApMsgAlert("Nใo existe registro em estoque para este produto.","Aten็ใo")
	EndIf


/// Tratamento da Data de Entrega
	if !lSaldo
		//FR - 20/12/2021 - Ticket #20210823016536
		If !lRest
			dtEntre:= u_atudtentre(nSaldo,	cProd ,	aCols[n,_nPosQtd] )	
		Else 
			dtEntre:= u_atudtentre(nSaldo,	cProd ,	xQtde )	//FR - 20/12/2021 - usa _n qdo vem do Rest STCRM003
		Endif

		IF FUNNAME() == 'MATA410' 
			u_STTMKG04(dtEntre)//chamada para calcular Data1C
		ENDIF
		Return dtEntre
	Else
		Return (nSaldo) //- Alterado Joใo Victor 16/02/2013 pois produto com saldo igual a Zero estava entrando na regra de que existe produto em estoque.
	Endif

Return
 