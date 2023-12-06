#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT110VLD     ºAutor  ³Joao Rinaldi    º Data ³  02/02/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ O ponto de entrada 'MT110VLD' é é responsável em validar   º±±
±±º          ³ o registro posicionado da Solicitação de Compras antes de  º±±
±±º          ³ executar as operações de inclusão, alteração, exclusão     º±±
±±º          ³ e cópia. Se retornar .T., deve executar as operações de    º±±
±±º          ³ inclusão, alteração, exclusão e cópia ou .F. para          º±±
±±º          ³ interromper o processo.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºExpN1     ³ 3- Inclusão                                                º±±
±±º          ³ 4- Alteração                                               º±±
±±º          ³ 6- Exclusão                                                º±±
±±º          ³ 8- Copia                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRotina    ³ MATA110.PRX                                                º±±
±±ºNome      ³ Solicitação de Compra                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT110VLD()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declaração das Variáveis
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aArea1    := GetArea()
	Local aArea2    := SC1->(GetArea())
	Local aArea3    := SAI->(GetArea())
	Local aArea4    := SY1->(GetArea())
	Local ExpN1     := Paramixb[1]
	Local ExpL1     := .T.
	Local _cSolic   := SC1->C1_USER
	Local _cStatus  := SC1->C1_ZSTATUS
	
		//	Adicionado para chamada Faturamento Beneficiamento - Valdemir Rabelo 26/07/2019
	if IsInCallStack( "U_STGerPC" )
		Return .T.
	ENDIF

	If ExpN1 == 4//Alteração
		If !(_cSolic == __cUserId)
			Aviso("Solicitação de Compra"; //01 - cTitulo - Título da janela
			,"Você não é o solicitante dessa Solicitação de Compras."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Você não poderá realizar nenhuma alteração nessa Solicitação de Compras."+ Chr(10) + Chr(13) +;
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
			ExpL1 := .F.
		Else
			If _cStatus == '2'
				Aviso("Solicitação de Compra Analisada "; //01 - cTitulo - Título da janela
				,"A Solicitação de Compras encontra-se Analisada pelo gestor."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Você não poderá realizar nenhuma alteração nessa Solicitação de Compras."+ Chr(10) + Chr(13) +;
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
				ExpL1 := .F.
			ElseIf (_cStatus == '3' .Or. _cStatus == '6') .And. (AllTrim(SC1->C1_MOTIVO)<>"MRP") //Chamado - 003641
				Aviso("Solicitação de Compra Aprovada "; //01 - cTitulo - Título da janela
				,"A Solicitação de Compras encontra-se Aprovada pelo gestor."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Você não poderá realizar nenhuma alteração nessa Solicitação de Compras."+ Chr(10) + Chr(13) +;
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
				ExpL1 := .F.
			ElseIf _cStatus == '4'
				Aviso("Solicitação de Compra Rejeitada"; //01 - cTitulo - Título da janela
				,"A Solicitação de Compras encontra-se Rejeitada pelo gestor."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Você não poderá realizar nenhuma alteração nessa Solicitação de Compras."+ Chr(10) + Chr(13) +;
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
				ExpL1 := .F.
			ElseIf _cStatus == '5'
				Aviso("Solicitação de Compra Rejeitada por Compras"; //01 - cTitulo - Título da janela
				,"A Solicitação de Compras encontra-se Rejeitada pelo departamento de Compras."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Você não poderá realizar nenhuma alteração nessa Solicitação de Compras."+ Chr(10) + Chr(13) +;
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
				ExpL1 := .F.					
			Endif
		Endif
		
	ElseIf ExpN1 == 3//Inclusão
		DbSelectArea("SAI")
		SAI->(DbSetOrder(2))//AI_FILIAL+AI_USER
		SAI->(DbGoTop())
		If !DbSeek(xFilial("SAI")+__cUserId)
			Aviso("Cadastro de Solicitante"; //01 - cTitulo - Título da janela
			,"Você não está cadastrado como Solicitante de Compras."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Você não poderá incluir Solicitações de Compras."+ Chr(10) + Chr(13) +;
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
			ExpL1 := .F.
		Endif		
	Endif
	
	RestArea(aArea4)
	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)
	
Return ExpL1