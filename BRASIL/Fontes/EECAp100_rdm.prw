#Include "Average.ch"

/*
Programa...: EecAp100_rdm.prw
Objetivo.....: Ponto de entrada do programa EECAP100.PRW
Autor.........: Julio de Paula Paz
Data/Hora..: 22/02/2013 - 10:31
Observação:
*/

/*
Função......: EecAp100()
Parâmetros:
Retorno......:
Objetivo.....: Função principal para o Ponto de entrada do programa EECAP100.prw.
Autor.........: Julio de Paula Paz
Data/Hora..: 22/02/2013 - 10:31
Observação:
*/
//===========================================================================================================================================//
//FR - 07/03/2022 - Alteração por Flávia Rocha - Sigamat Consultoria - Ticket #20220217003914 - retorno da função AvalSC9 não estava correto
//de forma que estava permitindo alterações de pedidos que já possuiam OS ou já estavam faturados
//Situação corrigida, a função AvalSC9 retorna .F. e este retorno estou colocando em lRet de EECAP100
//===========================================================================================================================================//
User Function EECAp100
	//Local lRet  
	Local cParam := If(Type("PARAMIXB") == "A", ParamIxb[1],ParamIxb)
	Local cProcesso
	Local nProcesso
	Local aOrd := SaveOrd({"EE7"})
	Local nRegAtu := EE7->(Recno())
	Private lRet
	Private lAvalSC9

	Begin Sequence

		Do Case

		Case cParam == "ANTES_TELA_PRINCIPAL"

			If nSelecao == INCLUIR
				cProcesso := GetMv("MV_STECK02",,"000000")
				nProcesso := Val(Alltrim(cProcesso)) + 1
				cProcesso := StrZero(nProcesso,6) + "/" + Right(Str(Year(dDatabase),4),2)
				EE7->(DbSetOrder(1))
				Do While .T. // Este procedimento foi desenvolvido para evitar duplicidade na geração de processos. No caso de dois usuários acessarem a rotina juntos.
					If EE7->(DbSeek(xFilial("EE7")+AvKey(cProcesso,"EE7_PEDIDO")))
						cProcesso := GetMv("MV_STECK02",,"000000")
						nProcesso := Val(Alltrim(cProcesso)) + 1
						cProcesso := StrZero(nProcesso,6) + "/" + Right(Str(Year(dDatabase),4),2)
						If EE7->EE7_PEDIDO == AvKey(cProcesso,"EE7_PEDIDO")
							nProcesso := nProcesso + 1
							cProcesso := StrZero(nProcesso,6) + "/" + Right(Str(Year(dDatabase),4),2)
						EndIf
					Else
						Exit
					EndIf
				EndDo

				// Atualiza o parâmetro "MV_STECK02" com o ultimo número de processo gerado.
				SetMv("MV_STECK02",StrZero(nProcesso))
				M->EE7_PEDIDO := cProcesso

				RestOrd(aOrd)
				EE7->(DbGoTo(nRegAtu))
			
			//FR - 07/03/2022 - adequação da variável que retorna se pode alterar o pedido ou não
			Else 
				If ALTERA
					lAvalSC9 := AvalSC9()  
					lRet     := lAvalSC9
				Else
					lRet     := .T.
				EndIf
				
			EndIf
			//FR - 07/03/2022 - adequação da variável que retorna se pode alterar o pedido ou não

		//---------------------------------------------------
		// Chamado 004430 - Thiago Godinho em 31/08/16 11:19
		// Enquanto a Totvs não atualizar o FONTE deverá chamar esta static function
		// FONTE: 03/04/14 09:25:44 - EASYWORK.PRW
		//---------------------------------------------------
		Case cParam == "GRV_WORK" //"AP100MAN_INICIO" //"GRV_WORK" "CAN_MODIFY"

			If Select("WORKFILE") > 0
				DbselectArea("WORKFILE")
				DbClosearea()
			Endif 
			OpenWorkFile()

		Case cParam == "AP100MAN_INICIO"			//cParam == "CAN_MODIFY"	.Or. 

			If ALTERA
				//AvalSC9()
				lAvalSC9 := AvalSC9()  //FR - 07/03/2022 - adequação da variável que retorna se pode alterar o pedido ou não
				lRet     := lAvalSC9				
			EndIf

		//FR - 07/03/2022 - esse é o parâmetro que indica que o pedido está sendo alterado
		Case cParam == "CAN_MODIFY" 
			If ALTERA				
				lAvalSC9 := AvalSC9() 
				lRet     := lAvalSC9 
			EndIf		

		//Case cParam == "PRECOI_ATU_PRECO" 		
		//	If ALTERA				
		//		lRet := AvalSC9()  //FR - 07/03/2022 - adequação da variável que retorna se pode alterar o pedido ou não				
		//	EndIf
		//Case cParam == "ROD_CAPA_PED"  
		//	If ALTERA				
		//		lRet := AvalSC9()  //FR - 07/03/2022 - adequação da variável que retorna se pode alterar o pedido ou não				
		//	EndIf
		//Case cParam == "GRV_PED"
		//	If ALTERA				
		//		lRet := AvalSC9()  //FR - 07/03/2022 - adequação da variável que retorna se pode alterar o pedido ou não				
		//	EndIf
		//FR - 07/03/2022 - esse é o parâmetro que indica que o pedido está sendo alterado

		EndCase

	End Sequence

	//FR - 07/03/2022 - adequação da variável que retorna se pode alterar o pedido ou não				
	If !lRet .and. lRet <> Nil
		If !lAvalSC9
			If ALTERA
                MsgStop("Pedido com Ordem de Separação e Não Faturado. Não pode ser alterado")
            Else
                lRet := .T. //Libera pois é apenas visualizar
            EndIf
		Endif 
		Break
	Endif 
	//FR - 07/03/2022 - adequação da variável que retorna se pode alterar o pedido ou não

Return lRet

Static Function OpenWorkFile(lExclusive)
	Local cBarra		:= "\", aEstru, cIndiceF
	Local lRet 		:= .T.
	Local cDir 		:= "\Comex"
	Local cArquivo 	:= "WorkFile"

	Default lExclusive := .F.

	Begin Sequence

		If !File(cDir+cBarra+cArquivo+GetDBExtension())
			If !lIsDir(cDir)
				MakeDir(cDir)
			EndIf

			aEstru   := {}
			aAdd(aEstru,{"WORKNAME","C",8 ,0})
			aAdd(aEstru,{"FILESEQ" ,"C",2 ,0})
			aAdd(aEstru,{"FILENAME","C",15,0})
			aAdd(aEstru,{"FILETYPE","C",10,0})
			aAdd(aEstru,{"ALIAS"   ,"C",15,0})
			aAdd(aEstru,{"DRIVER"  ,"C",15,0})
			aAdd(aEstru,{"STATUS"  ,"C",10,0})
			aAdd(aEstru,{"DTCREATE","D",8 ,0})

			dbCreate(cDir+cBarra+cArquivo,aEstru)

		EndIf
		dbUseArea(.T.,,cDir+cBarra+cArquivo,"WorkFile",!lExclusive,.F.)

		If NetErr()
			If !lExclusive
				::Error("Não foi possível abrir o arquivo de controle de tabelas temporarias.")
			EndIf
			lRet := .F.
			BREAK
		EndIf

		cIndiceF := cDir+cBarra+cArquivo+OrdBagExt()
		If __LocalDriver == "CTREE"
			cIndiceF := ::cDir+cBarra+::cArquivo
		EndIf

		If !File(cIndiceF+cBarra+cArquivo+OrdBagExt())
			If Empty (aEstru)
				aEstru   := {}
				aAdd(aEstru,{"WORKNAME","C",8 ,0})
				aAdd(aEstru,{"FILESEQ" ,"C",2 ,0})
				aAdd(aEstru,{"FILENAME","C",15,0})
				aAdd(aEstru,{"FILETYPE","C",10,0})
				aAdd(aEstru,{"ALIAS"   ,"C",15,0})
				aAdd(aEstru,{"DRIVER"  ,"C",15,0})
				aAdd(aEstru,{"STATUS"  ,"C",10,0})
				aAdd(aEstru,{"DTCREATE","D",8 ,0})
			EndIf
			dbCreateIndex(cIndiceF,"WORKNAME+FILESEQ",{|| CODIGO })
			If NetErr()
				::Error("Não foi possível indexar o arquivo de controle de tabelas temporarias.")
				lRet := .F.
			EndIf
		EndIf


	End Sequence

Return lRet

Static Function AvalSC9()
	Local cPedFat := ""
	Local aArea	  := GetArea()
	Local aAreaSC9:= SC9->(GetArea())
	Local lAltPed := .T.

	cPedFat := EE7->EE7_PEDFAT
	SC9->(DbSetOrder(1))
	SC9->(DbSeek(xFilial("SC9") + cPedFat))
	Do While SC9->C9_FILIAL + SC9->C9_PEDIDO = xFilial("SC9") + cPedFat .And. ! SC9->(Eof())
		//If Empty(SC9->C9_NFISCAL) .And. ! Empty(SC9->C9_ORDSEP)		
		If Empty(SC9->C9_NFISCAL) .And. !Empty(SC9->C9_ORDSEP)		//FR - 07/03/2022 - JUNTAR O ponto exclamação com a condição verificada
			lAltPed := .F.
			Exit
		EndIf
		SC9->(DbSkip())
	EndDo

	SC9->(RestArea(aAreaSC9))
	RestArea(aArea)

	//If ! lAltPed
	If !lAltPed		//FR - 07/03/2022 - JUNTAR O ponto exclamação com a condição verificada
		//MsgStop("Pedido com Ordem de Separação e Não Faturado. Não pode ser alterado") //se deixar a msg aqui vai aparecer mtas vezes então deixei pra saída da função principal
	EndIf

Return(lAltPed)
