#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Metodo   � STTMKG02 �Autor  � Donizeti Lopes     � Data �  11/01/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Recupera o Saldo Atual do Produto.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � STECK                                                      ���
�������������������������������������������������������������������������ͼ��
���Altera��o � Giovani.Zago compatibiliza��o para funcionar no pedido de v.��
//Altera��o: Fl�via Rocha: 
//FR - 13/12/2021 - Tratativa para incluir no retorno, consulta estoque 
                    do(s) produto(s) #20210823016536 /  #task 732                    
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STTMKG02(xTipo,xProd,xQtde)

	Local nSaldo   	    := 0	//Saldo Atual - Alterado Jo�o Victor 16/02/2013 pois produto com saldo igual a Zero estava entrando na regra de que existe produto em estoque.
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
	
//�������������������������������������������������Ŀ
//� Nao foi utilizada uma Entidade, pois a funcao   �
//� SaldoSB2 precisa que o SB2 esteja posicionado   �
//� para efetuar o calculo do Saldo Atual Disponivel�
//���������������������������������������������������
	lRest := .F.		//FR - 14/12/2021
	
	IIF (_cQtdven $ readvar(),lSaldo:=.F.,lSaldo:=.T.)

//�������������������������������������������������Ŀ
//� Nao foi utilizada uma Entidade, pois a funcao   �
//� SaldoSB2 precisa que o SB2 esteja posicionado   �
//� para efetuar o calculo do Saldo Atual Disponivel�
//���������������������������������������������������

//FR - 13/12/2021 - Tratativa para incluir no retorno, consulta estoque do(s) produto(s) #task 732 
//FR - 08/04/2022 - Altera��o - inclu�da na verifica��o abaixo se � a fun��o U_STCONSCOT pois ela executa via startjob                   
// Marcelo Klopfer - 28/07/2022 - Inclus�o da Chamada para a fun��o de Conssulta de Pre�os STCRM07A
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
	//	ApMsgAlert("N�o existe registro em estoque para este produto.","Aten��o")
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
		Return (nSaldo) //- Alterado Jo�o Victor 16/02/2013 pois produto com saldo igual a Zero estava entrando na regra de que existe produto em estoque.
	Endif

Return
 