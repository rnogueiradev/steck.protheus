#include 'Protheus.ch'
#include 'RwMake.ch'
#DEFINE CR    chr(13)+chr(10)
/*====================================================================================\
|Programa  | STALCAZZI         | Autor | GIOVANI.ZAGO             | Data | 10/12/2013 |
|=====================================================================================|
|Descrição | STALCAZZI                                                                |
|          | Gatilho  -  Alçada de desconto										      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STALCAZZI                                                                |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STALCAZZI()
*-----------------------------*
	Local _lPv		    := IsInCallSteck("U_STFAT15") //rotina de avalição de regras
	Local aArea         := GetArea()
	Local lRet          := .F.
	Local _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Local _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_PRODUTO"    ,"C6_PRODUTO"  	)   })
	Local _nPosCust   	:= aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XCUSTO"     ,"C6_XCUSTO"  	)   })
	Local _nPosTabe     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XTABELA"    ,"C6_QTDVEN"   	)   })

	If IsInCallSteck("U_STEnterCpo")
		Return
	EndIf

	If Type("_cAlbany") = "C" .And. ! Empty(_cAlbany)
		aCols[n,_nPosProd] := _cAlbany
		U_STEnterCpo((aHeader[_nPosProd,2]),_cAlbany,n)
		_cAlbany := ""
		If _Lmomat
			Tk273FRefresh()
			Tk273TlvImp()
		EndIf
	EndIf

	If ( Type("l410Auto") == "U" .OR. !l410Auto )  .And.  !_lPv
		aCols[n,_nPosCust] := U_STCUSTO1(aCols[n,_nPosProd])
		If _Lmomat
			aCols[n,_nPosTabe] := ' '
		EndIf
	EndIf

	RestArea(aArea)
Return (lRet)


/*====================================================================================\
|Programa  | STATUCUS          | Autor | GIOVANI.ZAGO             | Data | 10/12/2013 |
|=====================================================================================|
|Descrição | STATUCUS                                                                 |
|          | ATUALIZO CUSTO														      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STATUCUS                                                                |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STATUSCUS()
*-----------------------------*
	Local aArea         := GetArea()
	Local _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Local _nPosQtdVen	:= aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_QUANT"	  ,"C6_QTDVEN"  )   })
	Local _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_PRODUTO"    ,"C6_PRODUTO"  	)   })
	Local _nPosCust   	:= aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XCUSTO"     ,"C6_XCUSTO"  	)   })
	Local _nTotCus      := 0
	Local i		:= 0

	For i:=1 To Len(aCols)
		aCols[i,_nPosCust] := U_STCUSTO1(aCols[i,_nPosProd])
		_nTotCus+= aCols[i,_nPosCust] * aCols[i,_nPosQtdVen] 
	Next i
	M->UA_XCUSTO := _nTotCus

	RestArea(aArea)
Return ()

User Function STEnterCpo(cCampo,ValorDoCampo,n)

	Local cVarAtu  := ReadVar()
	Local lRet     := .T.
	Local cPrefixo := "M->"
	Local bValid

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ A variavel __ReadVar e padrao do sistema, ela identifica o campo atualmente posicionado. ³
	//³ Mude o conteudo desta variavel para disparar as validacoes e gatilhos do novo campo.     ³
	//³ Nao esquecer de voltar o conteudo original no final desta funcao.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	__ReadVar := cPrefixo+cCampo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valoriza o campo atual "Simulado".                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	&(cPrefixo+cCampo) := ValorDoCampo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega validacoes do campo.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SX3->( dbSetOrder(2) )
	SX3->( dbSeek(cCampo) )
	bValid := "{|| "+IIF(!Empty(SX3->X3_VALID),Rtrim(SX3->X3_VALID)+IIF(!Empty(SX3->X3_VLDUSER),".And.",""),"")+Rtrim(SX3->X3_VLDUSER)+" }"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa validacoes do campo.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet := Eval( &(bValid) )

	IF lRet
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Executa gatilhos do campo.                          ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SX3->(DbSetOrder(2))
		SX3->(DbSeek(cCampo))
		IF ExistTrigger(cCampo)
			RunTrigger(2,n)
		EndIF
	EndIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorna __ReadVar com o valor original.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	__ReadVar := cVarAtu

Return(lRet)
