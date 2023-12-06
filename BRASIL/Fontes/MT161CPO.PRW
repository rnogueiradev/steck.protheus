#include "protheus.ch"

/*
Autor:      Valdemir Rabelo
Data:       15/07/2019
Descrição:  Ponto de entrada para adicionar campos Analise Cotação
Ticket:     20190627000003
*/

User Function MT161CPO()

	Local aPropostas := PARAMIXB[1] // Array com os dados das propostas dos Fornecedores
	Local aItens := PARAMIXB[2] // Array com os dados da grid "Produtos"
	Local aCampos := {"C8_XPRCORC", "C8_PRECO"} // Array com os campos adicionados na grid "Item da Proposta"
	Local aCposProd := {} // Array com os campos adicionados na grid "Produtos"
	Local aRetorno := {}
	Local nX := 0
	Local nY := 0
	Local nZ := 0
	Local nCount := 0
	Local aAreaSC8 := SC8->(GetArea())
	Local _cFilial 	:= SC8->C8_FILIAL
	Local _cNum	 	:= SC8->C8_NUM

	For nX := 1 To Len(aPropostas)
		For nY := 1 To Len(aPropostas[nX])
			For nZ := 1 To Len(aPropostas[nX][nY][2])
				nCount++
				//C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO
				If Len(aPropostas[nX][nY][1]) > 0
					AADD(aPropostas[nX][nY][2][nZ],Posicione("SC8",1,_cFilial+_cNum+aPropostas[nX][nY][1][1]+aPropostas[nX][nY][1][2]+aPropostas[nX][nY][2][nZ][2]+aPropostas[nX][nY][2][nZ][12],"C8_XPRCORC"))
					AADD(aPropostas[nX][nY][2][nZ],Posicione("SC8",1,_cFilial+_cNum+aPropostas[nX][nY][1][1]+aPropostas[nX][nY][1][2]+aPropostas[nX][nY][2][nZ][2]+aPropostas[nX][nY][2][nZ][12],"C8_PRECO"))
				Else
					AADD(aPropostas[nX][nY][2][nZ],0)
					AADD(aPropostas[nX][nY][2][nZ],0)
				EndIf
			next nZ
		Next nY
	Next nX

	AADD(aRetorno,aPropostas)
	AADD(aRetorno,aCampos)
	AADD(aRetorno,aItens)
	AADD(aRetorno,aCposProd)

	RestArea(aAreaSC8)
Return aRetorno