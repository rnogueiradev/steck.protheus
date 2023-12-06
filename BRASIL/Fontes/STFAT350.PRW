#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT350        | Autor | RENATO.OLIVEIRA           | Data | 17/02/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT350()

	Local oLbx							 					//Listbox com os nomes dos contatos
	Local aCont		:= {}									//Array com os contatos
	Local cDFuncao	:= CRIAVAR("U5_FUNCAO",.F.)				//Funcao do contato na empresa
	Local cCliente	:= ""									//Codigo do cliente
	Local cLoja		:= ""									//Loja do cliente
	Local cDesc		:= ""									//Decricao do cliente
	Local cEntidade	:= ""									//Alias da entidade
	Local nOpcao	:= 0									//Opcao
	Local nContato	:= 0									//Posicao do contato dentro do array na selecao
	Local oDlg												//Tela
	Local lRet		:= .F.									//Retorno da tela
	Local cMVTpCons	:= SuperGetMv("MV_LJF3CNT", NIL, "1")	//Parametro que define o Tipo de consulta 1- Padrao Call Center 2- Por Endereco
	Local nFoldLoc											//Folder 1-Telemarketing, Televendas ou Telecobranca, 2-Televendas, 3-Telecobranca, 12-Sigaloja
	Local lProspLoc											//Determina se e Prospect
	Local lTkFilCont:= ExistBlock("TKFILCONT")				//Ponto de entrada para filtrar os contatos
	Local lFilSU5	:= .T.
	Local lMVTpCons	:= .F.

	cEntidade := "SA1"

	cCliente := M->ZR_CODIGO
	cLoja    := M->ZR_LOJA
	cDesc    := M->ZR_NOME

	If Empty(cCliente)
		Help(" ",1,"SEM CLIENT")
		Return(lRet)
	Endif

	DbSelectArea("AC8")
	DbSetOrder(2)		//AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON
	If DbSeek(xFilial("AC8") + cEntidade + xFilial(cEntidade) + cCliente + cLoja)

		While (!Eof())										.AND.;
		(AC8->AC8_FILIAL == xFilial("AC8")) 			.AND.;
		(AC8->AC8_ENTIDA == cEntidade)			 	.AND.;
		(AC8->AC8_FILENT == xFilial(cEntidade)) 		.AND.;
		(AllTrim(AC8->AC8_CODENT) == AllTrim(cCliente + cLoja))

			DbSelectArea("SU5")
			DbSetOrder(1)
			If DbSeek(xFilial("SU5") + AC8->AC8_CODCON)

				If lTkFilCont
					lFilSU5 := ExecBlock("TKFILCONT",.F.,.F.)
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se considerar o parametro, MV_LJF3CNT  ³
				//³e o tipo de consulta for por endereço  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lMVTpCons .AND. cMVTpCons = "2" .AND. lFilSU5
					cDFuncao := Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC")

					Aadd(aCont, {	SU5->U5_CODCONT,;		//C¢digo
					SU5->U5_END,;			//Endereco
					SU5->U5_BAIRRO,;		//Bairro
					SU5->U5_MUN,;			//Municipio
					SU5->U5_EST,;			//Estado
					SU5->U5_CEP,;			//CEP
					SU5->U5_CONTAT;			//Nome
					} )
					//Padrao CallCenter
				ElseIf lFilSU5
					cDFuncao := Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC")

					Aadd(aCont, {	SU5->U5_CODCONT,;		//C¢digo
					SU5->U5_CONTAT,;		//Nome
					cDFuncao,;				//Fun‡„o
					SU5->U5_FONE,;			//Telefone
					SU5->U5_OBS;			//Observacao
					} )
				EndIf

			Else
				Aadd(aCont,{"","","","",""})
			Endif
			DbSelectArea("AC8")
			DbSkip()
		End
	Else
		If TkIncCt(@oLbx,@aCont,.T.,cEntidade,cCliente,cLoja,cDesc,nFoldLoc,lProspLoc,lMVTpCons ) == 3 // Cancelou a Inclusao
			Return(lRet)
		Else
			lRet := .T.
			Return(lRet)
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Mostra dados dos Contatos 								     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg FROM  48,171 TO 230,800 TITLE "Cadastro de contatos" + " - " + cDesc PIXEL //"Cadastro de Contatos"

	@  3,2 TO  73, 310 LABEL "Cadastro de contatos"+":" OF oDlg  PIXEL //"Cadastro de Contatos"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se considerar o parametro, MV_LJF3CNT  ³
	//³e o tipo de consulta for por endereço  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMVTpCons .AND. cMVTpCons = "2"

		@ 10,5	LISTBOX oLbx FIELDS ;
		HEADER ;
		"Codigo",; //"C¢digo"
		"Endereco",; //"Endereco"
		"Bairro",; //"Bairro"
		"Municipio",; //"Municipio"
		"Estado",; //"Estado"
		"Cep",; //"CEP"
		"Nome";  //"Nome"
		SIZE 303,60  NOSCROLL OF oDlg PIXEL ;
		ON DBLCLICK( nOpcao:= 1,nContato := oLbx:nAt,oDlg:End() )

		oLbx:SetArray(aCont)
		oLbx:bLine:={ || {	aCont[oLbx:nAt,1],;	//C¢digo
		aCont[oLbx:nAt,2],;	//Endereco
		aCont[oLbx:nAt,3],;	//Bairro
		aCont[oLbx:nAt,4],;	//Municipio
		aCont[oLbx:nAt,5],;	//Estado
		aCont[oLbx:nAt,6],;	//CEP
		aCont[oLbx:nAt,7];	//Nome
		}}
		//Padrao CallCenter
	Else
		@ 10,5	LISTBOX oLbx FIELDS ;
		HEADER ;
		"Codigo",; //"C¢digo"
		"Nome",; //"Nome",
		"Funcao",; //"Fun‡„o"
		"Telefone",; //"Telefone"
		"Observacao";  //"Observa‡„o"
		SIZE 303,60  NOSCROLL OF oDlg PIXEL ;
		ON DBLCLICK( nOpcao:= 1,nContato := oLbx:nAt,oDlg:End() )

		oLbx:SetArray(aCont)
		oLbx:bLine:={ || {	aCont[oLbx:nAt,1],;	//C¢digo
		aCont[oLbx:nAt,2],;	//Nome
		aCont[oLbx:nAt,3],;	//Fun‡„o
		aCont[oLbx:nAt,4],;	//Telefone
		aCont[oLbx:nAt,5];	//Observacao
		}}
	EndIf

	DEFINE SBUTTON FROM 74,162 TYPE 4	ENABLE OF oDlg ACTION TkIncCt(	@oLbx	, @aCont	, .F.	, cEntidade	,;
	cCliente, cLoja		, cDesc, nFoldLoc,;
	lProspLoc, lMVTpCons )
	DEFINE SBUTTON FROM 74,192 TYPE 11	ENABLE OF oDlg ACTION TkAltCt(@oLbx,1,@aCont,cCliente,cLoja, lProspLoc)
	DEFINE SBUTTON FROM 74,222 TYPE 15	ENABLE OF oDlg ACTION TkVisCt(oLbx,1,@aCont,cCliente,cLoja)

	DEFINE SBUTTON FROM 74,252 TYPE 1	ENABLE OF oDlg ACTION (nOpcao:= 1,nContato:= oLbx:nAt,oDlg:End())
	DEFINE SBUTTON FROM 74,282 TYPE 2	ENABLE OF oDlg ACTION (nOpcao:= 0,oDlg:End())

	ACTIVATE MSDIALOG oDlg CENTERED

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona no registro correto para ser atualizado o campo de codigo do contato.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SU5")
	DbSetOrder(1)
	If (nOpcao == 1)
		lRet := .T.
		DbSeek(xFilial("SU5") + aCont[nContato,1])
	Endif

Return(lRet)