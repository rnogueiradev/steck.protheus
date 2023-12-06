#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STFATI_3_7_1     | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  Validação do MT410TOK                                                   |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STFATI_3_7_1                                                             |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------------*
User Function STFATI3_7_1(cFuncName)
	*-----------------------------------*
	Local aArea         := GetArea()
	Local lRet          := .T.
	Local _nPosTotItem  := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_VALOR"   })
	Local _nPosPrcven   := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_PRCVEN"  })
	Local _nPosQtdVen	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_QTDVEN"  })
	Local _nPosPrUnit	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_XPRCLIS" })
	Local _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" })
	Local _nPosComiss   := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_XVALCOM" })
	Local _nPosCom1     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_COMIS1"  })
	Local _nPos2Com     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_COMIS2"  })
	Local _nValComiss   := 0
	Local _nPosDESC     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_DESC"    })
	Local _nPosVALDESC  := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_VALDESC" })
	Local _lRetInc      := Inclui  .Or. Altera
	Local i := 0
	Local b := 0
	Local _NcOM := 0
	
	If !Empty(Alltrim(M->C5_VEND1)) .And. cFuncName = '371B'   .And. _lRetInc
		
		For i:= 1 To Len(Acols)
			
			If !aCols[i,Len(aHeader)+1]
				aCols[i,_nPosCom1]   := u_ValPorComiss(aCols[i,_nPosProd],M->C5_VEND1)     //atualiza a porcetagem da comissao por item
				aCols[i,_nPosComiss] := Round(((aCols[i,_nPosTotItem]*aCols[i,_nPosCom1])/100),2)//atualiza a comissao por item
				If Alltrim(M->C5_VEND1) = Alltrim(M->C5_VEND2)
					aCols[i,_nPos2Com]  := 0
				Else
					aCols[i,_nPos2Com]  :=	Posicione("SA3",1,xFilial("SA3")+M->C5_VEND2,"A3_COMIS")
				EndIf
				_nValComiss += aCols[i,_nPosComiss]
				
			EndIf
		Next i
		//_oDlgDefault := GetWndDefault()
		//aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
		If ( Type("l410Auto") == "U" .or. ! l410Auto)          //Inserido Jefferson Carlos dia 25/11/2013
			If !( oGetDad == Nil )                             //Inserido Jefferson Carlos dia 25/11/2013
				oDlg                      := GetWndDefault()   //Inserido Jefferson Carlos dia 25/11/2013
				oDlg := oGetDad:oWnd                           //Inserido Jefferson Carlos dia 25/11/2013
			EndIf                                              //Inserido Jefferson Carlos dia 25/11/2013
		EndIf
		
	EndIf
	
	If cFuncName = 'MT410TOK'
		
		If ( M->C5_XVALRA3+M->C5_XVALRA4+M->C5_XVALRA5 ) <> _nValComiss-M->C5_XVALRA1   .And.  (M->C5_XVALRA3+M->C5_XVALRA4+M->C5_XVALRA5) <> 0
			msginfo('Valor do Rateio Divergente do Valor da Comissão, Ajuste o Rateio!!!!!!!!!!!!!!!!')
			lRet:=.F.
		EndIf
		
		If M->C5_XTIPF <> '1' .And.  (M->C5_XVALRA3+M->C5_XVALRA4+M->C5_XVALRA5) <> 0
			MSGINFO('Rateio Disponivél Apenas Para Tipo de Fatura TOTAL')
			lRet:=.F.
		EndIf
		
	EndIf
	
	
	Restarea(aArea)
Return(lRet)


/*====================================================================================\
|Programa  | ValPorComiss     | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  Ponto de Entrada                                                        |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ValPorComiss                                                             |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*------------------------------------------*
User Function ValPorComiss(cProd,cVend1)
	*------------------------------------------*
	Local nPorComiss:= 0
	Local nPorSZ2:= -1
	Local nPorSZ3:= -1
	Local b
	
	DbSelectArea('SB1')
	SB1->(DbSetOrder(1))
	If SB1->(dbSeek(xFilial('SB1')+cProd))
		
		DbSelectArea('SZ2')
		SZ2->(DbSetOrder(1))
		If SZ2->(dbSeek(xFilial('SZ2')+cVend1+SB1->B1_COD))
			
			nPorSZ2:= SZ2->Z2_COMIS
			
		EndIf
		DbSelectArea('SZ3')
		SZ3->(DbSetOrder(1))
		If SZ3->(dbSeek(xFilial('SZ3')+cVend1+SB1->B1_GRUPO))
			
			nPorSZ3:= SZ3->Z3_COMIS
			
		EndIf
		Do Case
		Case nPorSZ2 < 0  .and. nPorSZ3>=0
			nPorComiss:=nPorSZ3
		Case nPorSZ3 < 0  .and. nPorSZ2>=0
			nPorComiss:=nPorSZ2
		Case nPorSZ3  < 0 .and. nPorSZ2  < 0
			nPorComiss:=0
		Case nPorSZ3 < nPorSZ2
			nPorComiss:=nPorSZ3
		Case nPorSZ3 > nPorSZ2
			nPorComiss:=nPorSZ2
		EndCase
	EndIf
Return(nPorComiss)


User Function COMISD2()
	Local _ACOD :={}
	Local b

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")
	AADD(_ACOD,{'R00181','SCM24A654      ',4745332})
AADD(_ACOD,{'R00181','SPLAE0446      ',4745331})
AADD(_ACOD,{'R00184','PCM02080416S   ',4433725})
AADD(_ACOD,{'R00234','02SCM2424      ',4563090})
AADD(_ACOD,{'R00293','02SCM2424      ',4647330})
AADD(_ACOD,{'R00386','02SCM2424      ',4490034})
AADD(_ACOD,{'R00485','02SCM163       ',4597187})
AADD(_ACOD,{'R00571','02SCM2421      ',4733183})
AADD(_ACOD,{'R00571','02SCM2424      ',4733184})
AADD(_ACOD,{'R00685','SDD61C10       ',4744773})
AADD(_ACOD,{'R00685','SDD61C25       ',4744774})
AADD(_ACOD,{'R00685','SDD63C25       ',4745328})
AADD(_ACOD,{'R00685','SDJS150        ',4744777})
AADD(_ACOD,{'R00685','SDJS175        ',4744776})
AADD(_ACOD,{'R00685','SDJS250        ',4744778})
AADD(_ACOD,{'R00685','SDJS500        ',4744779})
AADD(_ACOD,{'R00685','SLDS2201       ',4744441})
AADD(_ACOD,{'R00685','SLDS2202       ',4744440})
AADD(_ACOD,{'R00685','SLDS2203       ',4744430})
AADD(_ACOD,{'R00685','SLDS243        ',4744443})
AADD(_ACOD,{'R00685','SLMB8T0        ',4744438})
AADD(_ACOD,{'R00685','SLPDNR         ',4744439})
AADD(_ACOD,{'R00685','SLPFN1R3       ',4744433})
AADD(_ACOD,{'R00685','SLPFN1R4       ',4744442})
	
	b:= 0
	_NcOM:=0
	For b:=1 To Len(_aCod)
		
	  
		DbSelectArea("SD2")
		SD2->(DbGoTo(_aCod[B,3] ))
		If _aCod[B,3]   = SD2->(RECNO())
			_NcOM:=	u_ValPorComiss(ALLTRIM(_aCod[B,2]),ALLTRIM(_aCod[B,1]))
			If _NcOM > 0
				SD2->(RecLock("SD2",.F.))
				SD2->D2_COMIS1	:= _NcOM
				SD2->D2_ITEMGAR := "XX"
				SD2->(MsUnlock())
				SD2->(DbCommit())
			EndIf
		EndIf
		_NcOM:=0
		 
	Next b
	

 
	
return()


