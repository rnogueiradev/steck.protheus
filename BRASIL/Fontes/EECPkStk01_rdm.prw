/*
Programa        : EECPkStk01_RDM.Prw
Objetivo        : Impressao do Packing List - Steck
Autor           : Julio de Paula Paz
Data/Hora       : 03/09/2010
Obs.            : Este Rdmake é uma alteração do rdmake EECPEM54_rdm.prw.
*/

#Include "Average.ch"

#define NUMLINPAG 22
#define TAMDESC 38 // 22
#define cPict1 "@E 999,999,999"
#define cPict2 "@E 999,999,999.999"

/*
Funcao      : EECPkStk01()
Parametros  : Nenhum.
Retorno     : .t./.f.
Objetivos   : Impressao do Packing List da Steck
Autor       : Julio de Paula Paz
Data/Hora   : 03/09/2010
Revisao     :
Obs.        :
*/

******************************
User Function EECPkStk01()
******************************

Local lRet := .f.
Local nAlias := Select()
Local aOrd := SaveOrd({"EE9","SA2","SY9","SA1","SYA","SYQ","EEK","EE5","ZZA"})
Local cCod,cLoja

Private nTotRacks, nTotPesLi, nTotPesBr, nTotQtdVo, nTotVolum
Private nLin :=0,nPag := 1, nTotPag := 1, nTotCaixa := 0
Private nComEmb := 0, nLarEmb := 0, nAltEmb := 0
Private cUltEmb := "", nQtdUltEmb := 0
Private nPesBrTot := 0, nPesLiqTot := 0, nCubageTot := 0, nQtdTot := 0
Private nPesBrParc := 0, nPesLiqParc := 0, nCubageParc := 0, nQtdVolParc := 0, nQtdTotParc := 0

Begin Sequence

EE9->(dbSetOrder(3))
//EEK->(dbSetOrder(2))
EE5->(dbSetOrder(1))
EE7->(dbSetOrder(1))
EEO->(dbSetorder(2))
EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
EE7->(dbSeek(xFilial()+EE9->EE9_PEDIDO))

cSeqRel := GetSXENum("SY0","Y0_SEQREL")
ConfirmSX8()

HEADER_P->(Add())

IF !Empty(EEC->EEC_EXPORT)
	cCod := EEC->EEC_EXPORT
	cLoja:= EEC->EEC_EXLOJA
Else
	cCod := EEC->EEC_FORN
	cLoja:= EEC->EEC_FOLOJA
Endif

// Exportador ou Fornecedor
SA2->(dbSeek(xFilial("SA2")+cCod+cLoja))
HEADER_P->AVG_C01_60 := SA2->A2_NOME
cEnd := AllTrim(SA2->A2_END) +;
If(!Empty(SA2->A2_NR_END)," "+AllTrim(SA2->A2_NR_END),"") +	If(!Empty(SA2->A2_BAIRRO)," - "+AllTrim(SA2->A2_BAIRRO),"") +	" - " + AllTrim(SA2->A2_MUN) +	"/" +  SA2->A2_EST +	" " + AllTrim(Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM"))
	
	HEADER_P->AVG_C01150 := cEnd
	cEnd := If(!Empty(SA2->A2_CGC),"CNPJ "+AllTrim(Transform(SA2->A2_CGC,AvSx3("A2_CGC",6))),"")
	
	HEADER_P->AVG_C03_60 := cEnd
	cEnd := If(!Empty(SA2->A2_TEL),"TEL.: ("+AllTrim(SA2->A2_DDD)+") "+AllTrim(Transform(SA2->A2_TEL,AvSx3("A2_TEL",6))),"")+ If(!Empty(SA2->A2_FAX),"  FAX.: ("+AllTrim(SA2->A2_DDD)+") "+AllTrim(Transform(SA2->A2_FAX,AvSx3("A2_TEL",6))),"")
	
	HEADER_P->AVG_C04_60 := cEnd
	
	// Importador
	HEADER_P->AVG_C05_60 := EEC->EEC_IMPODE
	HEADER_P->AVG_C06_60 := EEC->EEC_ENDIMP
	HEADER_P->AVG_C07_60 := EEC->EEC_END2IM
	
	//No do Pedido
	HEADER_P->AVG_C01_30 := EEC->EEC_REFIMP
	
	//Data do Pedido
	HEADER_P->AVG_C01_10 := DtoC(EE7->EE7_DTPEDI)
	
	//No do Packing List
	HEADER_P->AVG_C02_30 := EEC->EEC_NRINVO
	
	//Data do Packing List
	HEADER_P->AVG_C02_10 := DtoC(EEC->EEC_DTINVO)
	
	nTotRacks := 0
	nTotCaixa := 0
	nTotPesLi := 0
	nTotPesBr := 0
	nTotQtdVo := 0
	nTotVolum := 0
	nQtdPallet:= 0
	
	GravaItens()
	
	// Totais
	//cTotRacks := DecPoint(LTrim(Transf(nTotRacks,cPict1)))
	//HEADER_P->AVG_C03_30 := cTotRacks
	
	cTotCaixa := DecPoint(LTrim(Transf(nTotCaixa,cPict1))) // Fernando
	//cTotCaixa := DecPoint(LTrim(Transf(nQtdTot,cPict1))) // Fernando
	HEADER_P->AVG_C04_30 := cTotCaixa
	
	//cTotPesLi := DecPoint(LTrim(Transf(EEC->EEC_PESLIQ,cPict2)),2)
	cTotPesLi := DecPoint(LTrim(Transf(nPesLiqTot,cPict2)),2)
	cTotPesLi += If(!Empty(cTotPesLi)," Kg","")
	HEADER_P->AVG_C05_30 := cTotPesLi
	
	//cTotPesBr := DecPoint(LTrim(Transf(EEC->EEC_PESBRU,cPict2)),2)
	cTotPesBr := DecPoint(LTrim(Transf(nPesBrTot,cPict2)),2) // - Fernando 29/04
	cTotPesBr += If(!Empty(cTotPesBr)," Kg","")
	HEADER_P->AVG_C06_30 := cTotPesBr
	
	//cTotQtdVo := DecPoint(LTrim(Transf(nTotQtdVo,cPict1)))
	cTotQtdVo := DecPoint(LTrim(Transf(nQtdTot,cPict1)))
	HEADER_P->AVG_C07_30 := cTotQtdVo
	
	//cTotVolum := DecPoint(LTrim(Transf(nTotVolum,cPict2)),2)
	nCubageTot := Posicione("EX9",1,xFilial("EX9")+EEC->EEC_PREEMB,"EX9->EX9_XCUB")
	cTotVolum := DecPoint(LTrim(Transf(nCubageTot,cPict2)),2)
	cTotVolum += If(!Empty(cTotVolum)," m3","")
	HEADER_P->AVG_C08_30 := cTotVolum
	
	HEADER_P->AVG_C08_10 := AllTrim(Str(nTotPag))
	
	cObs := Posicione("EX9",1,xFilial("EX9")+EEC->EEC_PREEMB,"EX9->EX9_OBS")
	
	// Marks
	//cMemo := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO))
	cMemo := MSMM(EX9->EX9_OBS,AVSX3("EEC_MARCAC",AV_TAMANHO))
	HEADER_P->AVG_C04_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),1)
	HEADER_P->AVG_C05_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),2)
	HEADER_P->AVG_C06_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),3)
	HEADER_P->AVG_C07_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),4)
	HEADER_P->AVG_C08_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),5)
	HEADER_P->AVG_C09_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),6)
	HEADER_P->(dbUnlock())
	
	HEADER_H->(dbAppend())
	AvReplace("HEADER_P","HEADER_H")
	
	DETAIL_P->(DbGoTop())
	Do While ! DETAIL_P->(Eof())
		DETAIL_H->(DbAppend())
		AvReplace("DETAIL_P","DETAIL_H")
		DETAIL_P->(DbSkip())
	EndDo
	
	HEADER_P->(DBCOMMIT())
	DETAIL_P->(DBCOMMIT())
	
	lRet := .t.
	
	End Sequence
	
	RestOrd(aOrd)
	Select(nAlias)
	
	Return lRet
	
	/*
	Funcao      : GravaItens
	Parametros  : Nenhum.
	Retorno     : Nil
	Objetivos   : Gravar os itens.
	Autor       : Julio de Paula Paz
	Data/Hora   : 03/09/2010
	Revisao     :
	Obs.        :
	*/
	*-------------------------*
	Static Function GravaItens
	*-------------------------*
	Local i				:=0
	Local cPalletAtual  := ""
	Local nRegAtu 		:= 0
	Local nPesoPallet   := 0
	Local cOldDim       := ""
	Local cCodvolume    := ""
	Local cVol          := ""
	Local nTVol 		:= 0
	Local cPallet 		:= ""
	Local _xPalle 		:= ""
	Local nPsPall       := 0
	Local _cZzaEof 		:= ""
	
	Begin Sequence
	nPesBrTot 	:= 0
	nPesLiqTot 	:= 0
	nCubageTot 	:= 0
	nQtdTot 	:= 0
	nPesBrParc 	:= 0
	nPesLiqParc := 0
	nCubageParc := 0
	nQtdTotParc := 0
	
	DbSelectArea("CB3")
	CB3->(DbSetOrder(1))
	EE9->(DbSetOrder(3)) // EE9_FILIAL+EE9_PREEMB+EE9_SEQEMB
	ZZA->(DbSetOrder(5)) // ZZA_FILIAL+ZZA_PREEMB+ZZA_CONTNR+ZZA_PALLET+ZZA_VOLUME //Giovani zago 28/04/14 ajuste qtd caixas
	
	ZZA->(DbSeek(xFilial("ZZA")+EEC->EEC_PREEMB))
	
	Do While ZZA->(!Eof() .And. ZZA_FILIAL == xFilial("ZZA")) .And. ZZA->ZZA_PREEMB == EEC->EEC_PREEMB
		
		EE9->(DbSeek(xFilial("EE9")+ZZA->(ZZA_PREEMB+ZZA_SEQEMB)))
		cDimensao := ""
		cVolume   := ""
		
		nVolume    := 0
		nQtdUltEmb := 0
		
		AppendDet()
		
		If  cPalletAtual <> ZZA->ZZA_PALLET // Quebra por pallet
			cPalletAtual := ZZA->ZZA_PALLET
			nRegAtu := DETAIL_P->(Recno())
			nPesBrParc := 0
			nPesLiqParc := 0
			nCubageParc := 0
			nQtdVolParc := 0
			nQtdTotParc := 0
			nPesoPallet := 0
		EndIf
		
		
		DETAIL_P->AVG_C01_20 := "(" + AllTrim(EE9->EE9_COD_I) + ")"
		
		// Quantidade
		IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNIDAD))
			MsgStop("Unidade de medida "+EE9->EE9_UNIDAD+" não cadastrada em "+EEC->EEC_IDIOMA,"Aviso")
		Endif
		
		
		DETAIL_P->AVG_C02_20 := DecPoint(Transf(ZZA->ZZA_QTEEMB,"@E 999,999,999")) + " " + AllTrim(EE2->EE2_DESCMA)
		//nQtdTot := nQtdTot + ZZA->ZZA_QTEEMB // Fernando 26/03/13
		nQtdTotParc := nQtdTotParc + ZZA->ZZA_QTEEMB
		EE5->(dbSeek(xFilial("EE5")+EE9->EE9_EMBAL1))
		
		// Valdemir Rabelo 14/04/2021 - Ticket: 20210412005829
		IF EX9->( FieldPos("EX9_XPSPAL") ) > 0
			nPsPall := Posicione("EX9",1,xFilial("EX9")+EEC->EEC_PREEMB,"EX9_XPSPAL")
		ELSE 
			MsgInfo("Campo (EX9_XPSPAL) peso do pallet não foi criado. Por favor, comunique o depto. TI","Atenção!")
			Return
		Endif

		cPallet := Posicione("EX9",1,xFilial("EX9")+EEC->EEC_PREEMB,"EX9_XPALLE")
		If cPallet == "S"
			nPesoPallet := nPsPall                // 10- Trocado para buscar o peso - Valdemir Rabelo 14/04/2021
		Endif
		
		cTipEmb:= Posicione("CB6",1,xFilial("CB6")+ALLTRIM(ZZA->ZZA_ORDSEP)+ALLTRIM(ZZA->ZZA_VOLUME),"CB6_TIPVOL") // 23/10/2013 - alterado
		
		If CB3->(DbSeek(xFilial("CB3")+cTipEmb)) // Fernando - 29/04
			
			nQtdUltEmb := ZZA->ZZA_QTEEMB
			nAltEmb := Round(CB3->CB3_ALTURA,3)
			nLarEmb := Round(CB3->CB3_LARGUR,3)
			nComEmb := Round(CB3->CB3_PROFUN,3)
			
			nVolume := (nAltEmb*nLarEmb*nComEmb) //* nQtdUltEmb
			nVolume := Round(nVolume,3)
			cVolume := DecPoint(Transf(nVolume,cPict2),2) + " m3"
		EndIf
		
		// Dimensões das embalagens
		cDimensao := AllTrim(Str((nComEmb*100)))+" x "+;
		AllTrim(Str((nLarEmb*100)))+" x "+;
		AllTrim(Str((nAltEmb*100)))+" cm"
		
		If cOldDim !=  cDimensao
			DETAIL_P->AVG_C02_60 := cDimensao
			cOldDim := cDimensao
		Endif
		
		nQtdPallet := If( nQtdPallet >= EE9->EE9_QTDEM1,EE9->EE9_QTDEM1, nQtdPallet )
		
		// Volume - Cubagem
		DETAIL_P->AVG_C03_20 := cVolume
		
		nCubageTot  := nCubageTot + nVolume
		nCubageParc := nCubageParc + nVolume
		
		//	*** Peso liq alterado em 24/06/2013 ****
		nPesoLiqProd 			:= Posicione("SB1",1,xFilial("SB1")+EE9->EE9_COD_I,"B1_PESO")
		DETAIL_P->AVG_C04_20 	:= DecPoint(Transf((ZZA->ZZA_QTEEMB * nPesoLiqProd),AvSx3("ZZA_PESVOL",AV_PICTURE)),AvSx3("ZZA_PESVOL",AV_DECIMAL)) + " Kg"
		nPesLiqTot   			:= nPesLiqTot + (ZZA->ZZA_QTEEMB * nPesoLiqProd)
		nPesLiqParc  			:= nPesLiqParc + (ZZA->ZZA_QTEEMB * nPesoLiqProd)
		
		// Peso Bruto do Volume
		If !Substr(ZZA->ZZA_VOLUME,2,3)+Alltrim(ZZA->ZZA_ORDSEP) $ cVol   //Giovani zago 28/04/14 ajuste qtd caixas
			nPesBrutoCx := Posicione("CB6",1,xFilial("CB6")+ALLTRIM(ZZA->ZZA_ORDSEP)+ALLTRIM(ZZA->ZZA_VOLUME),"CB6_XPESO")
			nPesBrParc := nPesBrParc + nPesBrutoCx // ZZA->ZZA_PESVOL
			cCodVolume := Substr(ZZA->ZZA_VOLUME,2,3)
			cvol := cVol + Substr(ZZA->ZZA_VOLUME,2,3)+Alltrim(ZZA->ZZA_ORDSEP) + "|"    //Giovani zago 28/04/14 ajuste qtd caixas
			nTVol:= nTVol + nPesBrutoCx
			nTotCaixa += 1
		Endif
		
		************************************************************************************************************************************
		
		// Peso Bruto Total
		
		cTipEmb:= Posicione("CB6",1,xFilial("CB6")+ALLTRIM(ZZA->ZZA_ORDSEP)+ALLTRIM(ZZA->ZZA_VOLUME),"CB6_TIPVOL") // 23/10/2013 - alterado
		
		If CB3->(DbSeek(xFilial("CB3")+cTipEmb)) // Fernando - 29/04
			//DETAIL_P->AVG_C08_20 := AllTrim(ZZA->ZZA_TIPVOL)+"-"+CB3->CB3_DESCRI
			// DETAIL_P->AVG_C08_20 := Substr(ZZA->ZZA_VOLUME,2,3)+"-"+CB3->CB3_DESCRI
			DETAIL_P->AVG_C08_20 := Substr(ZZA->ZZA_VOLUME,2,3)+"-"+CB3->CB3_DESCRI // 23/10/2013 - alterado
			
			nQtdUltEmb := ZZA->ZZA_QTEEMB
			nAltEmb := Round(CB3->CB3_ALTURA,2)
			nLarEmb := Round(CB3->CB3_LARGUR,2)
			nComEmb := Round(CB3->CB3_PROFUN,2)
			
			nVolume := (nAltEmb*nLarEmb*nComEmb) * nQtdUltEmb
			nVolume := Round(nVolume,2)
			cVolume := DecPoint(Transf(nVolume,cPict2),2) + " m3"
			
		Else
			DETAIL_P->AVG_C08_20 := Substr(AllTrim(ZZA->ZZA_VOLUME),2,3)
		EndIf
		
		// Total Embalagens
		//DETAIL_P->AVG_C06_20 := DecPoint(Transf(EE9->EE9_QTDEM1,cPict1))
		
		// Pallet
		DETAIL_P->AVG_C06_20 := ZZA->ZZA_PALLET
		
		// Total Peças / Embalagens
		// DETAIL_P->AVG_C07_20 := DecPoint(Transf(EE9->EE9_QE,cPict1))
		
		// Numero do pedido
		DETAIL_P->AVG_C07_20 := ZZA->ZZA_PEDIDO
		
		// Descricao Produto
		cMemo := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))
		DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,1)
		lCodProd := .t.
		For i := 2 To MlCount(cMemo,TAMDESC,3)
			IF !EMPTY(MemoLine(cMemo,TAMDESC,i))
				UnLockDet()
				AppendDet()
				DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,i)
				//If lCodProd
				//   DETAIL_P->AVG_C01_20 := "(" + AllTrim(EE9->EE9_COD_I) + ")"
				lCodProd := .f.
				//Endif
			ENDIF
			//If lCodProd
			//UnLockDet()
			//AppendDet()
			//  DETAIL_P->AVG_C01_20 := "(" + AllTrim(EE9->EE9_COD_I) + ")"
			//  lCodProd := .f.
			//Endif
		Next
		
		If lCodProd
			//UnLockDet()
			//AppendDet()
			DETAIL_P->AVG_C01_20 := "(" + AllTrim(EE9->EE9_COD_I) + ")"
			lCodProd := .f.
		Endif
		
		//Total de Caixas Unitárias
		//nTotCaixa := Posicione("EX9",1,xFilial("EX9")+EEC->EEC_PREEMB,"EX9->EX9_XTOT")  //+= 1 //EE9->EE9_QTDEM1
		
		UnlockDet()
		
		//AppendDet()
		//UnLockDet()
		
		ZZA->(dbSkip())
		
		If cPalletAtual <> ZZA->ZZA_PALLET  .Or. ZZA->(Eof())  .Or. ZZA->ZZA_PREEMB <> EEC->EEC_PREEMB
			
			// nPesBrParc := nPesBrParc + nPesoPallet // Peso bruto parcial das embalagens + peso do pallet
			//nPesBrTot  := nPesBrTot + nPesoPallet // Peso bruto total das embalagens + peso do pallet
			DETAIL_P->(DbGoto(nRegAtu))
			DETAIL_P->(RecLock("DETAIL_P",.F.))
			//DETAIL_P->AVG_C05_20 := DecPoint(Transf(nPesBrParc,AvSx3("EE9_PSBRTO",AV_PICTURE)),AvSx3("EE9_PSBRTO",AV_DECIMAL)) + " Kg"
			DETAIL_P->(MsUnlock())
			
			// Imprime linha de totais
			AppendDet()
			// Coluna Pallet
			DETAIL_P->AVG_C06_20 := "TOTAL PALLET"
			// nQtdTot++ //+ 1 // Incluso Fernando em 26/03/13
			//nPesBrTot := nPesBrTot + 10
			If  nQtdTot <   val(cPalletAtual)
				nQtdTot:= val(cPalletAtual)
			Endif
			If cPallet == "S"    .and. !('/'+alltrim(cPalletAtual)+'/' $ _xPalle)
				nTVol := nTvol + nPesoPallet
				_xPalle:=_xPalle+'/'+alltrim(cPalletAtual)
				
				nPesBrParc := nPesBrParc + nPesoPallet // Peso bruto parcial das embalagens + peso do pallet
			Endif
			
			// Total Quantidade do Pallet
			DETAIL_P->AVG_C02_20 := DecPoint(Transf(nQtdTotParc,"@E 999,999,999"))
			// Total do Volume do Pallet
			DETAIL_P->AVG_C03_20 := DecPoint(Transf(nCubageParc,cPict2),2) + " m3"
			// Peso Liquido Total do Pallet
			DETAIL_P->AVG_C04_20 := DecPoint(Transf(nPesLiqParc,AvSx3("EE9_PSLQUN",AV_PICTURE)),AvSx3("EE9_PSLQUN",AV_DECIMAL)) + " Kg"
			// Peso Bruto total do Pallet
			nPrbr := nPesBrParc //+nPesLiqParc // Fernando....
			nPesBrTot := nTVol //nPrbr // Fernando - 29/04
			DETAIL_P->AVG_C05_20 := DecPoint(Transf(nPrbr,AvSx3("EE9_PSBRTO",AV_PICTURE)),AvSx3("EE9_PSBRTO",AV_DECIMAL)) + " Kg"
			nPrbr := 0
			
			UnLockDet()
			AppendDet()
			UnLockDet()
		EndIf

	Enddo
	
	DO WHILE MOD(nLin,NUMLINPAG) <> 0
		APPENDDET()
	ENDDO
	
	nTotPag := nPag  
	//Giovani Zago 11/08/14 ajuste prc total amostra 1 item apenas
		If 	nPesBrtot = 0
			nPesBrtot:=	nPesBrParc
		Endif
	End Sequence
	
	Return NIL
	
	/*
	Funcao      : Add
	Parametros  : Nenhum.
	Retorno     : Nil
	Objetivos   : Add de registros no header.
	Autor       : Julio de Paula Paz
	Data/Hora   : 03/09/2010
	Revisao     :
	Obs.        :
	*/
	*------------------*
	Static Function Add
	*------------------*
	
	Begin Sequence
	dbAppend()
	
	bAux:=FieldWBlock("AVG_FILIAL",Select())
	
	IF ValType(bAux) == "B"
		Eval(bAux,xFilial("SY0"))
	Endif
	
	bAux:=FieldWBlock("AVG_CHAVE",Select())
	
	IF ValType(bAux) == "B"
		Eval(bAux,EEC->EEC_PREEMB)
	Endif
	
	bAux:=FieldWBlock("AVG_SEQREL",Select())
	
	IF ValType(bAux) == "B"
		Eval(bAux,cSeqRel)
	Endif
	
	End Sequence
	
	Return NIL
	
	/*
	Funcao      : DecPoint()
	Parametros  : cStr,nDec.
	Retorno     : String convertida.
	Objetivos   : Muda os pontos da casas decimais para virgula e as virgulas p/ pontos
	Ex. 999,999,999.99 p/ 999.999.999,99.
	Autor       : Julio de Paula Paz
	Data/Hora   : 03/09/2010
	Revisao     :
	Obs.        :
	*/
	*---------------------------------*
	Static Function DecPoint(cStr,nDec)
	*---------------------------------*
	Local cStrIni, cStrFim
	
	Begin Sequence
	
	nDec := If(nDec = Nil,0,nDec)
	cStr := AllTrim(cStr)
	
	If nDec > 0
		cStrFim := Right(cStr,nDec+1)
		cStrFim := StrTran(cStrFim,".",",")
	Else
		cStrFim := ""
	EndIf
	
	if nDec > 0
		cStrIni := SubStr(cStr,1,Len(cStr)-(nDec+1))
		cStrIni := StrTran(cStrIni,",",".")
	Else
		cStrIni := cStr
		cStrIni := StrTran(cStrIni,",",".")
	Endif
	
	End Sequence
	
	Return AllTrim(cStrIni+cStrFim)
	
	
	/*
	Funcao      : AppendDet
	Parametros  :
	Retorno     :
	Objetivos   : Adiciona registros no arquivo de detalhes.
	Autor       : Julio de Paula Paz
	Data/Hora   : 03/09/2010
	Revisao     :
	Obs.        :
	*/
	*-------------------------*
	Static Function AppendDet()
	*-------------------------*
	Begin Sequence
	nLin := nLin+1
	IF nLin > NUMLINPAG
		nLin := 1
		nPag := nPag+1
	ENDIF
	DETAIL_P->(Add())
	DETAIL_P->AVG_FILIAL := xFilial("SY0")
	DETAIL_P->AVG_SEQREL := cSEQREL
	DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB //nr. do processo
	DETAIL_P->AVG_CONT   := STRZERO(nPag,6,0)
	End Sequence
	
	Return NIL
	
	/*
	Funcao      : UnlockDet
	Parametros  :
	Retorno     :
	Objetivos   : Desaloca registros no arquivo de detalhes
	Autor       : Julio de Paula Paz
	Data/Hora   : 03/09/2010
	Revisao     :
	Obs.        :
	*/
	*-------------------------*
	Static Function UnlockDet()
	*-------------------------*
	Begin Sequence
	DETAIL_P->(dbUnlock())
	End Sequence
	
	Return NIL
	
	*-----------------------------------------------------------------------------------------------------------------*
	*  FIM DO RDMAKE EECPEM54_RDM
	*-----------------------------------------------------------------------------------------------------------------*
