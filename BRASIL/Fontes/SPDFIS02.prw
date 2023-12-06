#include "rwmake.ch"
#include "Topconn.ch"
#include "protheus.ch"
//Emerson Holanda 19/09/23 - AJUSTES PARA FUNCIONAR SEM APRESENTAR ERROR.LOG
User Function SPDFIS02()
	Local aAliasIT := ParamIXB[1]                                                // Recebe o Alias principal
	Local cTipoMov := ParamIXB[2]                                                // Recebe o tipo de movimento - E = ENTRADA / S = SAIDA, para registros gerados a partir de notas fiscais. Para registros não originados de notas esta posição terá conteúdo Nil.
	Local cRegSped := Iif(Len(ParamIXB) > 2,ParamIXB[3],"")                      // Recebe o  nome do registro, quando passado(1105, G140, H010, K200).
	Local aRet := Array(4)                                                       // Array para armazenar dados do retorno da função
	Local cPrefix := Iif(ValType(cTipoMov)=='C',Iif (cTipoMov$"E","D1","D2"),"") // Prefixo da tabela - D1_ / D2_
	Local aAreaAnt := GetArea()
	Local cAliasQry := ""

	//Emerson Holanda 20/09/2023 - Ajuste para funcionar no bloco 0220
	If cRegSped == "0220"
			Aadd(aRet,"8888888888888")  // Posição 05 código de barras
	EndIf

	//Emerson Holanda 20/09/2023 - Ajuste para funcionar no bloco C170
	If cRegSped  ==  "C170"
		If cTipoMov == "E"
			// Busca informação do documento SD1
			cAliasQry := GetNextAlias()
			BeginSql alias cAliasQry
			SELECT SD1.D1_XUM,
               SD1.D1_XQTDE
          	FROM %table:SD1% SD1
          	WHERE SD1.D1_FILIAL = %exp:(aAliasIT)->FT_FILIAL%
            AND SD1.D1_DOC = %exp:(aAliasIT)->FT_NFISCAL%
            AND SD1.D1_SERIE = %exp:(aAliasIT)->FT_SERIE%
            AND SD1.D1_FORNECE = %exp:(aAliasIT)->FT_CLIEFOR%
            AND SD1.D1_LOJA = %exp:(aAliasIT)->FT_LOJA%
            AND SD1.D1_COD = %exp:(aAliasIT)->FT_PRODUTO%
            AND SD1.D1_ITEM = %exp:(aAliasIT)->FT_ITEM%
            AND SD1.%notDel%
			%noparser%
			EndSql

			If !(cAliasQry)->(Eof())
				If !Empty((cAliasQry)->D1_XUM)
					aRet[1] := (cAliasQry)->D1_XUM
				Else//Emerson Holanda 13/09/23
					aRet[1] := Posicione("SB1",1,xFilial("SB1")+(aAliasIT)->FT_PRODUTO,"B1_UM")
				EndIf
				If (cAliasQry)->D1_XQTDE > 0
					aRet[2] := (cAliasQry)->D1_XQTDE
				Else//Emerson Holanda 13/09/23
					aRet[2] := (aAliasIT)->FT_QUANT //(aAliasIT)->&("QTD")//
				EndIf
				aRet[3] := 0 // Fator
				aRet[4] := "M" // Tipo de Conversão
			Else
				aRet[1] := Posicione("SB1",1,xFilial("SB1")+(aAliasIT)->FT_PRODUTO,"B1_UM")
				aRet[2] := (aAliasIT)->FT_QUANT
				aRet[3] := 0 // Fator
				aRet[4] := "M" // Tipo de Conversão
			EndIf
			(cAliasQry)->(dbCloseArea())
		Else
			aRet[1] := Posicione("SB1",1,xFilial("SB1")+(aAliasIT)->FT_PRODUTO,"B1_UM")
			aRet[2] := (aAliasIT)->FT_QUANT
			aRet[3] := 0 // Fator
			aRet[4] := "M" // Tipo de Conversão
		EndIf
	EndIf
	/*
	If cRegSped  ==  "C425"
			aRet[1] := Posicione("SB1",1,xFilial("SB1")+(aAliasIT)->FT_PRODUTO,"B1_UM")
			aRet[2] := (aAliasIT)->FT_QUANT
	EndIf
	*/
	
	/*
	If cRegSped  ==  "G140"

			aRet[1] := Posicione("SB1",1,xFilial("SB1")+(aAliasIT)->FT_PRODUTO,"B1_UM")
			aRet[2] := (aAliasIT)->FT_QUANT
			aRet[3] := 0 // Fator
			aRet[4] := "M" // Tipo de Conversão
	EndIf
	*/
	
	//Emerson Holanda 20/09/2023 - Ajuste para funcionar no bloco k200 e 0220
	If cRegSped  ==  "K200"

		If ("SB1")->(dbSeek(xFilial("SB1")+(aAliasIT)->COD_ITEM))

			aRet[1]  :=  ("SB1")->B1_SEGUM
			aRet[2]  :=  (aAliasIT)->&("QTD")
			aRet[3]  :=  ("SB1")->B1_CONV           //Fator
			aRet[4]  :=  ("SB1")->B1_TIPCONV        //Tipo de Conversão
		Else
			aRet[1]  :=  "UN"
			aRet[2]  :=  0
			aRet[3]  :=  0     //Fator
			aRet[4]  :=  "M"   //Tipo de Conversão
		Endif
	EndIf


	RestArea(aAreaAnt)

Return aRet
