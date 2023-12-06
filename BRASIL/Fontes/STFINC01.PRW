#INCLUDE "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±º Programa    ³ STFINC01 ³ Efetua manutenção na tabela ZS do arquivo SX5                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 05.04.13 ³ João Victor                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ ExpC1: código da tabela                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso         ³ STECK                                                                   º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function STFINC01()

	Local nQ, n

	nOpcx	:= 3
	nQ		:= 0
	aCols	:= {}
	nItem	:= 0
	n		:= 0

	dbSelectArea("Sx3")
	dbSetOrder(1)
	dbSeek("SX5")
	nUsado := 0
	aHeader := {}

	While !Eof() .And. (x3_arquivo == "SX5")
		If X3USO(x3_usado) .And. cNivel >= x3_nivel
			nUsado := nUsado+1
			aAdd(aHeader,{ Trim(X3_TITULO), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )
		EndIf
		dbSkip()
	End

	dbSelectArea("Sx3")
	dbSeek("SX5")

	// Posiciona o Cabecalho da Tabela a ser editada
	dbSelectArea("SX5")
	dbSetOrder(1)
	
	// Cabecalho da tabela, filial ‚ vazio
	If !dbSeek(xFilial("SX5") + "00" + "ZS")
		MsgStop("O cabeçalho da tabela ZS não foi encontrado. Cadastre a tabela ZS(SX5) para prosseguir.","Atenção","STOP" )
		Return
	EndIf
	
	_cChave  := AllTrim(SX5->X5_CHAVE)
	_cDescri := SubStr(SX5->X5_DESCRI,1,35)
	_cCodFil := xFilial("SX5")

	nUsado := 0
	dbSeek(_cCodFil + "ZS")
	While !Eof() .And. (SX3->X3_ARQUIVO == "SX5") .And. SX5->X5_FILIAL == _cCodFil .And. Alltrim(SX5->X5_TABELA) == "ZS"
		// Ticket 20210423006534 - ERRO CADASTRO DE REJEIÇÕES - Inicio
		aAdd(aCols, Array(6))
		For nQ := 1 to Len(aCols[1])-1
			If nOpcx == 3
				aCols[Len(aCols)][nQ] := FieldGet(FieldPos(aHeader[nQ,2]))
			EndIf
		Next nQ
		aCols[Len(aCols)][Len(aCols[1])] := .F.
		// Ticket 20210423006534 - ERRO CADASTRO DE REJEIÇÕES - Fim
		dbSkip()
	End
	
	nItem 	 := Len(aCols)
	nLinGetD := 0
	cTitulo  := _cDescri
	aC := {}
	
	#IFDEF WINDOWS
		aAdd(aC,{"_cChave" ,{20,05} ,"Tabela"   ,"@!"," ","",.F.})
		aAdd(aC,{"_cDescri",{20,65} ,"Descricao","@!"," ","",.F.})
	#ELSE
		aAdd(aC,{"_cChave" ,{06,05} ,"Tabela"   ,"@!"," ","",.F.})
		aAdd(aC,{"_cDescri",{06,65} ,"Descricao","@!"," ","",.F.})
	#ENDIF
	
	aR := {}
	
	#IFDEF WINDOWS
		aCGD := {044,005,118,315}
	#ELSE
		aCGD := {010,004,015,073}
	#ENDIF
	
	cLinhaOk:= "(!Empty(aCols[n,2]) .Or. aCols[n,3])"
	cTudoOk := "AllwaysTrue()"
	lRet = .F.
	n := 1
	lRet := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,{"X5_CHAVE","X5_DESCRI"})

	If lRet
		Begin Transaction
			dbSelectAre("SX5")
			dbSetOrder(1)
			For n := 1 to Len(aCols)
				/* Removido\Ajustado - Não executa mais RecLock na X6. Criação/alteração de dados deve ser feita apenas pelo módulo Configurador ou pela rotina de atualização de versão.
				If aCols[n,Len(aHeader)+1] == .T.
					// Filial e Chave e a chave indepEndente da descricao que pode ter sido alterada.
					If dbSeek(_cCodFil + "ZS" + aCols[n,2])
						RecLock("SX5",.F.,.T.)
						dbDelete()
						MsUnlock()
					EndIf
				Else
					If dbSeek(_cCodFil + "ZS" + aCols[n,2])
						If aCols[n,3] != SX5->X5_DESCRI
							RecLock("SX5",.F.)
							SX5->X5_CHAVE   := aCols[n,2]
							SX5->X5_DESCRI  := aCols[n,3]
							SX5->X5_DESCSPA := aCols[n,3]
							SX5->X5_DESCENG := aCols[n,3]
							MsUnlock()
						EndIf
					Else
						If nItem >= n
							dbGoto(aRecNo[n,2])
							RecLock("SX5",.F.)
							SX5->X5_CHAVE 	:= aCols[n,2]
							SX5->X5_DESCRI	:= aCols[n,3]
							SX5->X5_DESCSPA := aCols[n,3]
							SX5->X5_DESCENG := aCols[n,3]
							MsUnlock()
						ElseIf (!Empty(aCols[n,2]))
							RecLock("SX5",.T.)
							SX5->X5_FILIAL  := _cCodFil
							SX5->X5_TABELA  := "ZS"
							SX5->X5_CHAVE   := aCols[n,2]
							SX5->X5_DESCRI  := aCols[n,3]
							SX5->X5_DESCSPA := aCols[n,3]
							SX5->X5_DESCENG := aCols[n,3]
							MsUnlock()
						EndIf
					EndIf
				EndIf*/
			Next			
		End Transaction
	EndIf

Return Nil

/*
User Function FATEC01()
	Local aAreaSX5    := SX5->(GetArea())
	
	SX5->(dbSetFilter({|| SX5->X5_TABELA == "ZS" .AND. SX5->X5_FILIAL = xFilial("SX5") },"SX5->X5_TABELA == 'ZS' .AND. SX5->X5_FILIAL = xFilial('SX5')"))
	
	AxCadastro("SX5","Cadastro de Motivos de FATEC (Ficha de Assistência Técnica STECK",".F.","U_COK()")
	
	SX5->(DbClearFilter())
	
	RestArea(aAreaSX5)
Return()

User Function cOK()
	Local lRet := .T.
	
	If M->X5_TABELA <> "ZS"
		lRet := .F.
		MSGINFO("Tabela Não disponível! Favor alterar o campo X5_TABELA para ZS.")
	Endif
Return (lRet)
*/
