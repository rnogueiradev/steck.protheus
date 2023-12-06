#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STXOKCALL        | Autor | GIOVANI.ZAGO             | Data | 05/03/2013  |
|=====================================================================================|
|Descrição |    PONTO DE ENTRADA NO BOTAO DE OK DO CALL CENTER                        |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STXOKCALL                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\=====================================================================================
*/
*-----------------------------*
User Function STXOKCALL()
	*-----------------------------*
	Local _lRetx    := .T.
	Local i        	  := 0
	Private _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Private _cNum         := IIF(_Lmomat ,"M->UA_NUM"    ,"M->C5_NUM")
	Private _cLoja        := IIF(_Lmomat ,"M->UA_LOJA"   ,"M->C5_LOJACLI")
	Private _cCliente     := IIF(_Lmomat ,"M->UA_CLIENTE","M->C5_CLIENTE")
	Private _cEst         := IIF(_Lmomat ,"M->UA_ESTE","M->C5_ZESTE")
	Private _nPosTotItem  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_VLRITEM" ,"C6_VALOR"  	)   })
	Private _nPosPrcven   := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_VRUNIT"  ,"C6_PRCVEN"  )   })
	Private _nPosQtdVen	  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_QUANT"	  ,"C6_QTDVEN"  )   })
	Private _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_PRODUTO" ,"C6_PRODUTO"	)   })
	Private _nPosItem     := aScan(aHeader, { |x| AllTrim(x[2]) ==  IIF(  _Lmomat,"UB_ITEM"    ,"C6_ITEM"   )   })
	Private _cOpeTran     := GetMv('ST_OPERBLQ',,'94')//TIPO DE OPERAÇÃO NAO ENTRA EM REGRAS COMERCIAIS  ....utiliza preço de custo sb2
	Private _nPosOper	  := aScan(aHeader, { |x| AllTrim(x[2]) ==  IIF(  _Lmomat,"UB_OPER"    ,"C6_OPER"   )   })    	// OPER
	Private _nPosBlq      := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XBLQITE" ,"C6_ZMOTBLO"  	)   })
	Private _cOper        := If(Empty(_nPosOper) .And. _Lmomat,Posicione("SUB",1,xFilial("SUB")+&_cNum+aCols[n,_nPosItem],"UB_OPER"),aCols[n,_nPosOper])

	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		If !(_cOper $ _cOpeTran )
			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			If SA1->(DbSeek(xFilial("SA1")+&_cCliente+&_cLoja))
				If !( __cuserid $ GetMv("ST_UFX",,'000000/000645/000380/000088/000391/000360')+ '000000/000645/')
					If !(Empty(Alltrim( &_cEst ))) .And. SA1->A1_EST <> &_cEst
						_lRetx    := .F.
						MSGINFO("UF de Entrega Divergente da UF do Cadastro do Cliente  !!!!")
					EndIf
				EndIf
			EndIf
			//validação de preço de venda x quantidade igual ao valor total  giovani.zago 26/01/13
			_l410Pil01:= .F.
			_l410Pil02:= .F.
			For i:= 1 To Len(Acols)

				If !aCols[i,Len(aHeader)+1]
					If 	round((aCols[i,_nPosPrcven] *	aCols[i,_nPosQtdVen]),2)  <> 	round(aCols[i,_nPosTotItem],2)  .And. aCols[i,_nPosOper] <> "09"
						_lRetx    := .F.
						msginfo("O Item: "+aCols[i,_nPosItem] +" Produto: "+aCols[i,_nPosProd]+" Possui Divergência de Valores..!!!!!!!!" )
					EndIf
					If 	aCols[i,_nPosPrcven] = 0.01
						aCols[i,_nPosBlq]   := '1'
						If _Lmomat
							M->UA_XBLOQ    :=  '1'
							M->UA_XDESBLQ   :=	ALLTRIM(M->UA_XDESBLQ) + 'PSC/'
						Else
							M->C5_ZBLOQ   :=  '1'
							M->C5_ZMOTBLO := 	ALLTRIM(M->C5_ZMOTBLO)+'PSC/'
						EndIf
					EndIf


					If   GetMv("ST_PILH410",,.F.)
						If Alltrim(aCols[i,_nPosProd]) $ GetMv("ST_PILHAMA",,"PA15AAA2/PA15AAA4/PA15AA2/PA15AA4/PA15C2/PA15D2/PA09V") 
							_l410Pil01:= .T.
						EndIf
						If Alltrim(aCols[i,_nPosProd]) = "MCPS0919" 
							_l410Pil02:= .T.
						EndIf

					EndIf

				EndIf
			Next i
			If _l410Pil01 .And. !(_l410Pil02)
				_lRetx := .T.//giovani zago rertirei a obrigatoriedade 21/11/2019
				MsgAlert("Orçamento com Pilha, precisa enviar o Manual: MCPS0919 ")
			ElseIf _l410Pil02
				_lRetx := .T.
			EndIf
		EndIf
	EndIf
Return (_lRetx)



