#Include "Average.ch"
#Include "protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
Função......: EecFat2()
Parâmetros:
Retorno......:
Objetivo.....: Função principal do programa EECFAT2.PRW
Autor.........: Julio de Paula Paz
Data/Hora..: 19/02/2013 - 11:40
Observação:
*/
User Function Eecfat2()
	Local cParam := If(Type("PARAMIXB") == "A", ParamIxb[1],ParamIxb)
	Local lQtdEmp	:= .F.
	Local nPercDesc
	Local nI
	Local cTransp := GETMV("ST_TRANPAD",.F.,'10004')
	//Local nY

	Begin Sequence
		Do Case
			Case cParam == "PE_GRVCAPA" .And. nOpc != 5

			_cCond := Posicione("SY6",1,xFilial("SY6")+M->EE7_CONDPA,"Y6_SIGSE4")

			// Valdemir Rabelo 21/09/2021 - 20210914018904
			if !Empty(SA1->A1_TRANSP)
			   cTransp := SA1->A1_TRANSP
			endif 
			
			// Os campos abaixo foram customizados pela Totvs e são obrigatíorios.
			// Na gravação do Pedido de Exportação,há a necessidade de gravar informações nestes campos.
			Aadd(aCab, {"C5_XTIPO", EE7->EE7_XTIPO,nil})  // Tipo de Entrega
			Aadd(aCab, {"C5_XDTEN", dDataBase,nil})       // Data de Entrega do Orçamento
			Aadd(aCab, {"C5_XTIPF", "1",nil})             // Tipo de Fatura
			Aadd(aCab, {"C5_XPRIORI", " ",nil})
			Aadd(aCab, {"C5_ZBLOQ", "2",nil})
			Aadd(aCab, {"C5_ZCONDPG", _cCond,nil})
			Aadd(aCab, {"C5_TRANSP", cTransp,nil})					// Valdemir Rabelo 21/09/2021 - 20210914018904
			//nPercDesc := (M->EE7_DESCON / M->EE7_TOTPED) * 100 	// Desconto do pedido de exportação em percetual.
			nPercDesc := (M->EE7_DESCON / M->EE7_VLFOB) * 100 		// Desconto do pedido de exportação em percetual.
			Aadd(aCab, {"C5_DESC1", nPercDesc,nil})       			// Percentual de desconto do pedido de exportação.
			Aadd(aCab, {"C5_ZCONSUM", "2",nil})       				// Mercadoria para consumo próprio do cliente Sim/Não
			Aadd(aCab, {"C5_TPFRETE", iif(EE7->EE7_XTIPO=="1","F","C"),nil})  // Valdemir Rabelo 21/09/2021 - 20210914018904
			Aadd(aCab, {"C5_PESOL"  , EE7->EE7_PESLIQ ,nil})     	// Envia peso Liq do P.export para P.Faturamento
			Aadd(aCab, {"C5_PBRUTO" , EE7->EE7_PESBRU ,nil})     	// Envia peso Bru do P.export para P.Faturamento
			Aadd(aCab, {"C5_XORDEM" , "." ,nil})
			
			If !Empty(M->EE7_XARM) //20200214000540
				Aadd(aCab, {"C5_XTRONF" ,"1" ,nil})
			EndIf

			aCab := FWVetByDic(aCab, "SC5",.F.)

			Case cParam == "PE_GRVITEM"
			nI := aScan(aReg,{|x| x[1]="C6_VALDESC"})
			If nI > 0   // Tratamentos para zerar o valor do desconto por item. O valor do desconto será enviado na capa do pedido de vendas.
				If aReg[nI,2] > 0
					aReg[nI,2] := 0
				EndIf
			EndIf
			
			If !Empty(M->EE7_XARM) //20200214000540
				nI := aScan(aReg,{|x| x[1]="C6_LOCAL"})
				If nI > 0
					aReg[nI,2] := M->EE7_XARM
				EndIf
			EndIf
			
			If nOpc = 5 .And. EE7->EE7_AMOSTR== "1" //.And. EECMsg("Deseja ELIMINAR Amostra no SIGAFAT Nr.:"+EE7->EE7_PEDFAT+"?", "Integração", "MsgNoYes")
				Processa({|| lQtdEmp := U_STEXC6(EE7->EE7_PEDFAT) },'Aguarde','Eliminando Registros...',)
				If !lQtdEmp
					MsgAlert("Não foi possível eliminar o pedido!!!",".:AVISO:.")
					Return
				Endif

			ElseIf  nOpc = 5 //.And. EECMsg("Deseja ELIMINAR PEDIDO no SIGAFAT Nr.:" +EE7->EE7_PEDFAT+"?", "Integração", "MsgNoYes")
				Processa({|| lQtdEmp := U_STEXC6(EE7->EE7_PEDFAT) },'Aguarde','Eliminando Registros...',)
				If !lQtdEmp
					MsgAlert("Não foi possível eliminar o pedido!!!",".:AVISO:.")
					Return
				Endif

			EndIf

		EndCase

	End Sequence
Return 

/*/{Protheus.doc} STEXC6
Funcao utilizada para zerar o campo 'C6_QTDEMP' para que
seja possivel realizar a exclusao de um pedido de venda em
aberto ao excluir um processo de exportação.
@type function
@author thiago.fonseca
@since 19/09/2016
@version 1.0
@param cNumSC6, character, (Descrição do parâmetro)
@return ${return}, ${return_description}
/*/

User Function STEXC6(cNumSC6)
	Local aArea := GetArea()
	Local lRet		:= .T.

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO

	SC6->(MsSeek(xFilial("SC6")+cNumSC6))

	While !SC6->(Eof()) .and. SC6->C6_NUM == cNumSC6 .and. Empty(SC6->C6_NOTA) .And. SC6->C6_QTDEMP > 0
		RecLock("SC6",.F.)
		SC6->C6_QTDEMP := 0
		MsUnlock()
		If SC6->C6_QTDEMP > 0
			lRet := .F.
			Return lRet
		Else
			lRet := .T.
		EndIf
		SC6->(DbSkip())

	Enddo

	RestArea(aArea)
Return lRet
