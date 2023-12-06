#INCLUDE "PROTHEUS.CH"
#include 'FWMVCDEF.ch'
#include "rwmake.ch"
#include "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STCOM027     ºAutor  ³Joao Rinaldi    º Data ³  23/02/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Aprovadores de Solicitação de Compras          º±±
±±º          ³ Tela desenvolvida em MVC Modelo 3                          º±±
±±º          ³ Obrigatório o uso de 2 tabelas                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STCOM027()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declaração das Variáveis
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aArea1       := GetArea()
	Local aArea2       := SC7->(GetArea())
	Local aArea3       := SC1->(GetArea())
	Local aArea4       := SY1->(GetArea())
	Local _lValid      := .T.
	Local _nPosNumsc   := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C7_NUMSC"})
	Local _nPosItemsc  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C7_ITEMSC"})
	Local _nPosQuant   := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C7_QUANT"})
	Local _nPosItem    := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C7_ITEM"})
	Local _nPosProd    := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C7_PRODUTO"})
	Local _nPosCc      := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C7_CC"})
	Local _nI
	Local _cInfo 	   := ""
	Local _lComp 	   := .F.
	Private cTitle     := "Pedido de Compra"

	/*
	Local _cAlias1    := "SZK"
	Local _aGrupos    := {}
	Private _cCID     := "MOD3025"
	Private _cSSID    := "STCOM025"
	Private aRotina   := MenuDef(_cSSID)
	Private oBrowse
	Private _cGrprEng := '000035/000083'
	Private _cGrupo   := ''
	Private _lEng     := .F.
	Private _lComp    := .F.
	Private _lSolic   := .F.
	Private _cOpcEng  := '1/2'
	Private _cOpcSol  := '1/3'
	Private _cGeraPrd := '2/3'
	Private _cStatus  := ''
	*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validação de acesso a rotina
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//	Adicionado para chamada Faturamento Beneficiamento - Valdemir Rabelo 26/07/2019
	if IsInCallStack( "U_STGerPC" ) .Or. IsInCallStack( "U_STCOM251" ) .Or. IsInCallStack( "U_STCOM260" )
		Return .T.
	ENDIF

	If __cUserId $ GetMv("STCOM0271",,"") //20201029009658
		Return .T.
	EndIf

	_lComp := .F.
	
	DbSelectArea("SY1")
	SY1->(DbSetOrder(3))//Y1_FILIAL+Y1_USER
	SY1->(DbGoTop())
	If DbSeek(xFilial("SY1")+__cUserId)
		_lComp := .T.
	Endif

	_cInfo := ""

	If !(_lComp)
		Aviso(_cInfo; //01 - cTitulo - Título da janela
		,"Usuário sem permissão para a rotina de "+cTitle+"."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"Favor Verificar."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
		_lValid := .F.
	Else
		If !(IsInCallStack("CNTA121"))

			/**********************************
			<<< Alteração >>>
			Ação.........: Caso o pedido de compra seja para determinados fornecedores ignora o tratamento da Solitação de Compras
			Regras.......: Buscar os códigos dos fornecedores no parãmetro MV_XFORPC
			Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
			Data.........: 08/12/2021
			Chamado......: 20211203025901
			**********************************/
			IF !cA120Forn $ SUPERGETMV("MV_XFORPC",,"014006")

				For _nI := 1 to Len(aCols)
					If !(aCols[_nI][Len(aCols[_nI])])
						If Empty(Alltrim(aCols[_nI,_nPosNumsc]))
							Aviso("Informação não preenchida"; //01 - cTitulo - Título da janela
							,"O campo '"+Alltrim(RetTitle("C7_NUMSC")) +"' é obrigatório o preenchimento."+ Chr(10) + Chr(13) +;
							CHR(10)+CHR(13)+;
							"Favor Verificar a linha do Pedido de Compra com as seguintes informações:"+ Chr(10) + Chr(13) +;
							"Produto: "+(aCols[_nI,_nPosProd])           + Chr(10) + Chr(13) +;
							"Item nº: "+(aCols[_nI,_nPosItem])           + Chr(10) + Chr(13) +;
							"Quant. : "+CValtoChar(aCols[_nI,_nPosQuant])+ Chr(10) + Chr(13) +;
							CHR(10)+CHR(13)+;
							"O Pedido de Compra não será confirmado.",; //02 - cMsg - Texto a ser apresentado na janela.
							{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
							,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
							,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
							,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
							,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
							,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
							,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
							,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
							)
							_lValid := .F.
							Exit
						ElseIf Empty(Alltrim(aCols[_nI,_nPosItemsc]))
							Aviso("Informação não preenchida"; //01 - cTitulo - Título da janela
							,"O campo '"+Alltrim(RetTitle("C7_ITEMSC")) +"' é obrigatório o preenchimento."+ Chr(10) + Chr(13) +;
							CHR(10)+CHR(13)+;
							"Favor Verificar a linha do Pedido de Compra com as seguintes informações:"+ Chr(10) + Chr(13) +;
							"Produto: "+(aCols[_nI,_nPosProd])           + Chr(10) + Chr(13) +;
							"Item nº: "+(aCols[_nI,_nPosItem])           + Chr(10) + Chr(13) +;
							"Quant. : "+CValtoChar(aCols[_nI,_nPosQuant])+ Chr(10) + Chr(13) +;
							CHR(10)+CHR(13)+;
							"O Pedido de Compra não será confirmado.",; //02 - cMsg - Texto a ser apresentado na janela.
							{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
							,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
							,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
							,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
							,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
							,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
							,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
							,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
							)
							_lValid := .F.
							Exit
						ElseIf Empty(Alltrim(aCols[_nI,_nPosCc]))
							Aviso("Informação não preenchida"; //01 - cTitulo - Título da janela
							,"O campo '"+Alltrim(RetTitle("C7_CC")) +"' é obrigatório o preenchimento."+ Chr(10) + Chr(13) +;
							CHR(10)+CHR(13)+;
							"Favor Verificar a linha do Pedido de Compra com as seguintes informações:"+ Chr(10) + Chr(13) +;
							"Produto: "+(aCols[_nI,_nPosProd])           + Chr(10) + Chr(13) +;
							"Item nº: "+(aCols[_nI,_nPosItem])           + Chr(10) + Chr(13) +;
							"Quant. : "+CValtoChar(aCols[_nI,_nPosQuant])+ Chr(10) + Chr(13) +;
							CHR(10)+CHR(13)+;
							"O Pedido de Compra não será confirmado.",; //02 - cMsg - Texto a ser apresentado na janela.
							{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
							,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
							,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
							,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
							,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
							,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
							,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
							,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
							)
							_lValid := .F.
							Exit
							//ElseIf Empty(Alltrim(aCols[_nI,_nPosQuant]))
						Else
							DbSelectArea("SC1")
							SC1->(DbSetOrder(1))//C1_FILIAL+C1_NUM+C1_ITEM
							SC1->(DbGoTop())
							If DbSeek(xFilial("SC1")+(aCols[_nI,_nPosNumsc])+(aCols[_nI,_nPosItemsc]))
								If SC1->C1_ZSTATUS == '3' .And. !Empty(Alltrim(SC1->C1_CODCOMP))
									If !(SC1->C1_QUANT == (aCols[_nI,_nPosQuant]))
										Aviso("Divergência de Informações"; //01 - cTitulo - Título da janela
										,"O campo '"+Alltrim(RetTitle("C7_QUANT")) +"' está divergente com relação a Solicitação de Compras."+ Chr(10) + Chr(13) +;
										CHR(10)+CHR(13)+;
										"Favor Verificar a linha do Pedido de Compra com as seguintes informações:"+ Chr(10) + Chr(13) +;
										"Produto  : "+(aCols[_nI,_nPosProd])           + Chr(10) + Chr(13) +;
										"Item nº  : "+(aCols[_nI,_nPosItem])           + Chr(10) + Chr(13) +;
										"Quant.PC : "+CValtoChar(aCols[_nI,_nPosQuant])+ Chr(10) + Chr(13) +;
										Replicate("=",50)                              + Chr(10) + Chr(13) +;
										"Dados da Solicitação de Compra:"+ Chr(10)     + Chr(13) +;
										"Solic Compra : "+(aCols[_nI,_nPosNumsc])      + Chr(10) + Chr(13) +;
										"Item SC nº   : "+(aCols[_nI,_nPosItemsc])     + Chr(10) + Chr(13) +;
										"Quant.SC     : "+CValtoChar(SC1->C1_QUANT)    + Chr(10) + Chr(13) +;
										CHR(10)+CHR(13)+;
										"O Pedido de Compra não será confirmado.",; //02 - cMsg - Texto a ser apresentado na janela.
										{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
										,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
										,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
										,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
										,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
										,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
										,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
										,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
										)
										_lValid := .F.
										Exit
									ElseIf !(SC1->C1_CC	== (aCols[_nI,_nPosCc]))
										Aviso("Divergência de Informações"; //01 - cTitulo - Título da janela
										,"O campo '"+Alltrim(RetTitle("C7_CC")) +"' está divergente com relação a Solicitação de Compras."+ Chr(10) + Chr(13) +;
										CHR(10)+CHR(13)+;
										"Favor Verificar a linha do Pedido de Compra com as seguintes informações:"+ Chr(10) + Chr(13) +;
										"Produto  : "+(aCols[_nI,_nPosProd])      + Chr(10) + Chr(13) +;
										"Item nº  : "+(aCols[_nI,_nPosItem])      + Chr(10) + Chr(13) +;
										"C. Custo : "+(aCols[_nI,_nPosCc])        + Chr(10) + Chr(13) +;
										Replicate("=",50)                         + Chr(10) + Chr(13) +;
										"Dados da Solicitação de Compra:"         + Chr(10) + Chr(13) +;
										"Solic Compra : "+(aCols[_nI,_nPosNumsc]) + Chr(10) + Chr(13) +;
										"Item SC nº   : "+(aCols[_nI,_nPosItemsc])+ Chr(10) + Chr(13) +;
										"C. Custo SC  : "+(SC1->C1_CC)            + Chr(10) + Chr(13) +;
										CHR(10)+CHR(13)+;
										"O Pedido de Compra não será confirmado.",; //02 - cMsg - Texto a ser apresentado na janela.
										{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
										,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
										,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
										,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
										,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
										,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
										,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
										,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
										)
										_lValid := .F.
										Exit
									Endif
								Else
									Aviso("Divergência com a Solicitação de Compras"; //01 - cTitulo - Título da janela
									,"Não foi encontrada Solicitação de Compra vinculada ao Pedido de Compra."+ Chr(10) + Chr(13) +;
									CHR(10)+CHR(13)+;
									"Favor Verificar a linha do Pedido de Compra com as seguintes informações:"+ Chr(10) + Chr(13) +;
									"Produto: "+(aCols[_nI,_nPosProd])+ Chr(10)  + Chr(13) +;
									"Item nº: "+(aCols[_nI,_nPosItem])+ Chr(10)  + Chr(13) +;
									"Quant. : "+CValtoChar(aCols[_nI,_nPosQuant])+ Chr(10) + Chr(13) +;
									"Solic Compra : "+(aCols[_nI,_nPosNumsc])    + Chr(10) + Chr(13) +;
									"Item SC nº   : "+(aCols[_nI,_nPosItemsc])   + Chr(10) + Chr(13) +;
									CHR(10)+CHR(13)+;
									"O Pedido de Compra não será confirmado.",; //02 - cMsg - Texto a ser apresentado na janela.
									{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
									,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
									,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
									,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
									,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
									,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
									,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
									,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
									)
									_lValid := .F.
									Exit
								Endif
							Else
								Aviso("Divergência com a Solicitação de Compras"; //01 - cTitulo - Título da janela
								,"Não foi encontrada Solicitação de Compra vinculada ao Pedido de Compra."+ Chr(10) + Chr(13) +;
								CHR(10)+CHR(13)+;
								"Favor Verificar a linha do Pedido de Compra com as seguintes informações:"+ Chr(10) + Chr(13) +;
								"Produto: "+(aCols[_nI,_nPosProd])+ Chr(10)  + Chr(13) +;
								"Item nº: "+(aCols[_nI,_nPosItem])+ Chr(10)  + Chr(13) +;
								"Quant. : "+CValtoChar(aCols[_nI,_nPosQuant])+ Chr(10) + Chr(13) +;
								"Solic Compra : "+(aCols[_nI,_nPosNumsc])    + Chr(10) + Chr(13) +;
								"Item SC nº   : "+(aCols[_nI,_nPosItemsc])   + Chr(10) + Chr(13) +;
								CHR(10)+CHR(13)+;
								"O Pedido de Compra não será confirmado.",; //02 - cMsg - Texto a ser apresentado na janela.
								{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
								,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
								,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
								,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
								,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
								,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
								,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
								,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
								)
								_lValid := .F.
								Exit
							Endif
						Endif
					Endif
				Next _nI
			ENDIF
		EndIf
	Endif

	RestArea(aArea4)
	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)

Return (_lValid)
