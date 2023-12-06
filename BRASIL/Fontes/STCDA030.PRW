#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ ACDA030  ณ Autor ณ Ricardo               ณ Data ณ 23/03/01 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Programa de manutencao no arquivo mestre de inventario     ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ SIGAACD                                                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ03
ฤฤฤฤดฑฑ
ฑฑณ PROGRAMADOR  ณ DATA   ณ BOPS ณ  MOTIVO DA ALTERACAO                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ        ณ      ณ                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function STCDA030()    // compilacao da funcao padrao acda030
	Local aCores := {}
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define Array contendo as Rotinas a executar do programa      ณ
	//ณ ----------- Elementos contidos por dimensao ------------     ณ
	//ณ 1. Nome a aparecer no cabecalho                              ณ
	//ณ 2. Nome da Rotina associada                                  ณ
	//ณ 3. Usado pela rotina                                         ณ
	//ณ 4. Tipo de Transao a ser efetuada                          ณ
	//ณ    1 - Pesquisa e Posiciona em um Banco de Dados             ณ
	//ณ    2 - Simplesmente Mostra os Campos                         ณ
	//ณ    3 - Inclui registros no Bancos de Dados                   ณ
	//ณ    4 - Altera o registro corrente                            ณ
	//ณ    5 - Remove o registro corrente do Banco de Dados          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PRIVATE aRotina := {	{ "Pesquisar", "AxPesqui",	0, 1}     ,; //"Pesquisar"
	{ "Visualizar", 		"AxVisual",					0, 2}     ,; //"Visualizar"
	{ "Incluir", 			"u_ACDA30Inc",				0, 3}     ,; //"Incluir"
	{ "Alterar", 			"u_ACDA30Alt",				0, 4, 17} ,; //"Alterar"
	{ "Excluir", 			"u_ACDA30Del",				0, 5, 17} ,; //"Excluir"
	{ "Planilha", 			"u_STIMP030",				0, 3, 17} ,; //"Automatico"
	{ "Monitor", 			"ACDA032",					0, 4, 17} ,; //"Monitor"
	{ "Mensagem", 			"U_STMSGUSU()",				0, 4} 	  ,; //"Mensagem"
	{ "Relatorio", 			"u_ACDR030",				0, 1}     ,; //"Relatorio"
	{ "Acerto Inventario", 	"u_AIVA30Aut",				0, 1}     ,; //"Gera Acerto"
	{ "Liberar Usuario", 	"u_AIVA30Usu",				0, 1}     ,; //"Relatorio"
	{ "Andamento", 			"u_AIVA30And",				0, 1}     ,; //"Relatorio"
	{ "Rotativo", 			"u_INVROT",					0, 1}     ,; //"Setar Rotativo"
	{ "Invent.Randomico", 	"U_STFSFA73()",				0, 3}     ,; //"Invent.Randomico"
	{ "Reprocessar", 		"u_AcertoInv",				0, 1}     ,; //"Reprocessar inventario Rotativo"
	{ "Legenda", 			"u_AIVA30Lg",				0, 2} }      //"Legenda"


	PRIVATE cDelFunc := "u_ACDA30Exc()"
	PRIVATE lLocaliz := GetMv('MV_LOCALIZ')=='S'

	//CBChkTemplate()
	//If ! IntAcd(.t.)
	//	Return .f.
	//EndIf

	If ! SuperGetMV("MV_CBPE012",.F.,.F.)
		CBAlert( "Necessario ativar o parametro MV_CBPE012")
		Return .F.
	EndIf
	AjustaSX1()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define o cabecalho da tela de atualizacoes                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PRIVATE cCadastro :=  "Mestre de inventario"

	aCores := {	{ "CBA->CBA_STATUS == '0'"	, "BR_VERDE"},;
		{ "CBA->CBA_STATUS == '1'"	, "BR_AMARELO"},;
		{ "CBA->CBA_STATUS == '2'"	, "BR_CINZA"},;
		{ "CBA->CBA_STATUS == '3'"	, "BR_LARANJA"},;
		{ "CBA->CBA_STATUS == '4'"	, "BR_AZUL"},;
		{ "CBA->CBA_STATUS == '6'"	, "BR_PINK"},;
		{ "CBA->CBA_STATUS == '5'"	, "BR_VERMELHO"},;
		{ "CBA->CBA_STATUS == '7'"	, "BR_VERMELHO"}}

	mBrowse( 6, 1, 22, 75, "CBA", , , , , , aCores, , , ,{|x|TimerBrw(x)})
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAcda30Inc บAutor  ณEduardo Motta       บ Data ณ  08/03/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusao do mestre de inventario                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACDA30Inc(cAlias,nReg,nOPc)
	Private lInclui := .t.
Return AxInclui(cAlias,nReg,nOPc,nil,nil,nil,"ACDA30Chk()")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAcda30Alt บAutor  ณEduardo Motta       บ Data ณ  08/03/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Alteracao do mestre de inventario                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACDA30Alt(cAlias,nReg,nOPc)
	Private lInclui := .f.

	If CBA->CBA_STATUS$"12"
		Alert( "Inventario em andamento, nao sera possivel alterar!!!")
		Return
	EndIf

	If CBA->CBA_STATUS$"5"
		Alert( "Inventario concluido, nao sera possivel alterar!!!" )
		Return
	EndIf
Return AxAltera(cAlias,nReg,nOPc,nil,nil,nil,"ACDA30Chk()")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAcda30Del บAutor  ณAnderson Rodrigues  บ Data ณ  18/02/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExclusao do Mestre de inventario                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ PROGRAMADOR  ณ DATA   ณ BOPS ณ  MOTIVO DA ALTERACAO                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณErike Yuri    ณ13/07/04ณ      ณAlteracao que permite excluir SB7 quandoณฑฑ
ฑฑณ              ณ        ณ      ณo Status estiver finalizado,CBA_STATUS=4ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Acda30Del(cAlias,nReg,nOPc)
	Local nI      := 0
	Local aSB7    := GetArea('SB7')
	Local cCodInv := CBA->CBA_CODINV
	Local aProdDel:= {}
	Private lInclui := .f.
	If CBA->CBA_STATUS == "5" // processadoo
		MsgAlert( "Nao e permitida a exclusao de Mestres de Inventario ja processado !!!"   )
		Return .f.
	ElseIf CBA->CBA_STATUS == "4" // finalizado
		MsgAlert( 'Este Mestre de Inventario esta finalizado, se o mesmo for excluido, sera efetuada a exclusao de '   +;
			'todos "Lancamentos Inventariados" (SB7) deste Mestre, e este Mestre de Inventario ficara com '+;
			'Status de "Em Andamento".' + chr(13)+chr(10)+chr(13)+chr(10)+  'Para excluir definitivamente este '+;
			'Mestre de Inventario, esta rotina devera ser executada ate que o Mestre de inventario esteja com '+;
			'Status de "Nao Iniciado" ou "Em Andamento".')

		If !IW_MSGBOX("Deseja prosseguir com a exclusao?","Atencao","YESNO") //"Deseja prosseguir com a exclusao?"###"Atencao"
			Return .f.
		Endif

		//Carrega array com produtos do inventario para desbloqueio
		CBLoadEst(aProdDel,.f.)
		For nI:=1 To Len(aProdDel)
			CBUnBlqInv(cCodInv,aProdDel[nI,1])
		Next

		//Como nao existe rotina automatica para a exclusao do SB7(Mata270), a exclusao sera feita diretamente
		Begin Transaction
			DbSelectArea("SB7")
			SB7->(DbOrderNickName("ACDSB701"))
			SB7->(DbSeek(xFilial("SB7")+CBA->CBA_CODINV))
			While SB7->(!Eof() .AND. B7_FILIAL+B7_DOC==xFilial("SB7")+CBA->CBA_CODINV)
				RecLock("SB7",.F.)
				SB7->(DbDelete())
				SB7->(MsUnLock())
				SB7->(DbSkip())
			EndDo

			RecLock("CBA",.F.)
			CBA->CBA_STATUS := "3" // contadoang
			CBA->(MsUnLock())
		End Transaction
		RestArea(aSB7)
	ElseIf CBA->CBA_STATUS$"3|2|1" // contado/em pausa/em andamento
		/*	CBB->(DbSetOrder(1))
		CBB->(DbSeek(xFilial("CBB")+CBA->CBA_CODINV))
		While ! CBB->(EOF()) .and. CBB->(CBB_FILIAL+CBB_CODINV) == xFilial("CBB")+CBA->CBA_CODINV
			If CBB->CBB_STATUS == "1"
		MsgAlert("Nao e permitida a exclusao de Mestres de Inventario com contagens em andamento!!!"+chr(13)+CHR(10)+; //"Nao e permitida a exclusao de Mestres de Inventario com contagens em andamento!!!"
		"Necessario excluir ou finalizar a contagem em andamento." ) //"Necessario excluir ou finalizar a contagem em andamento."
		Return .f.
			Endif
		CBB->(DbSkip())
		Enddo
		*/
		MsgAlert( "Ja foram realizadas contagens para este Mestre de Inventario, "   +;
			"se o mesmo for excluido todas as contagens realizadas tambem serao excluidas !!!"  )
		If !IW_MSGBOX("Deseja prosseguir com a exclusao?","Atencao","YESNO") //"Deseja prosseguir com a exclusao?"###"Atencao"
			Return .f.
		Endif
		If AxDeleta(cAlias,nReg,nOPc,nil,nil,nil) == 2
			CBB->(DbSetOrder(1))
			CBB->(DbSeek(xFilial("CBB")+cCodInv))
			While ! CBB->(EOF()) .and. CBB->(CBB_FILIAL+CBB_CODINV) == xFilial("CBB")+cCodInv
				While CBC->(DbSeek(xFilial("CBC")+CBB->CBB_NUM))
					ACD35CBM(5,CBA->CBA_CODINV,CBC->CBC_COD,CBC->CBC_LOCAL,CBC->CBC_LOCALI,CBC->CBC_LOTECT,CBC->CBC_NUMLOT,CBC->CBC_NUMSER)
					RecLock("CBC",.f.)
					CBC->(DbDelete())
					CBC->(MsUnlock())
				Enddo
				RecLock("CBB",.f.)
				CBB->(DbDelete())
				CBB->(MsUnlock())
				CBB->(DbSkip())
			Enddo
			If CBA->CBA_STATUS == '0'
				u_ACDA30Exc()
			EndIf
		EndIf
	Else
		If cEmpAnt == "03"
			If ApMsgYesNo("Deseja excluir todos os lancamentos nใo iniciados de: " + Dtoc(dDatabase) + "?", "Confirmar")
				dbSelectArea("CBA")
				dbSetFilter({|| DTOS(CBA->CBA_DATA) = DTOS(dDataBase)},"")
				dbGoTop()

				While !Eof()
					If DTOS(CBA->CBA_DATA) = DTOS(dDataBase)
						If CBA->CBA_STATUS == '0'
							u_ACDA30Exc()

							RecLock("CBA",.F.)
							CBA->(DbDelete())
							CBA->(MsUnLock())

						EndIf
					EndIf

					dbSelectArea("CBA")
					dbSkip()
				Enddo

				dbSelectArea("CBA")
				dbClearFilter()
				TCRefresh("CBA")
			Else
				AxDeleta(cAlias,nReg,nOPc,nil,nil,nil)
				If CBA->CBA_STATUS == '0'
					u_ACDA30Exc()
				EndIf
			EndIf
		Else
			AxDeleta(cAlias,nReg,nOPc,nil,nil,nil)
			If CBA->CBA_STATUS == '0'
				u_ACDA30Exc()
			EndIf
		EndIf

	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACDA30Chk บAutor  ณEduardo Motta       บ Data ณ  08/03/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecuta as validacoes padroes                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACDA30Chk()
	If	M->CBA_TIPINV == "2" // Por endereco
		If Empty(M->CBA_LOCALI)
			Alert( "O campo endereco nao pode ficar em branco." )
			Return .F.
		EndIf
	EndIf

	If ! lInclui
		Return .t.
	EndIf
	If M->CBA_DATA < dDataBase
		Alert( "Data do Inventario menor que a database")
		Return .f.
	EndIf
	If M->CBA_TIPINV=="1" // por produto
		CBA->(DbSetOrder(3)) //CBA_FILIAL+CBA_TIPINV+CBA_STATUS+CBA_LOCAL+CBA_PROD+CBA_DATA
		If	CBA->(DbSeek(xFilial("CBA")+"1"+"0"+M->CBA_LOCAL+Padr(M->CBA_PROD,15)+DTOS(M->CBA_DATA))) .or. ;
				CBA->(DbSeek(xFilial("CBA")+"1"+"1"+M->CBA_LOCAL+Padr(M->CBA_PROD,15)+DTOS(M->CBA_DATA)))
			Alert( "Inventario ja cadastrado " )
			Return .f.
		EndIf
	Else  // por endereco
		CBA->(DbSetOrder(2)) //CBA_FILIAL+CBA_TIPINV+CBA_STATUS+CBA_LOCAL+CBA_LOCALI+CBA_DATA
		If	CBA->(DbSeek(xFilial("CBA")+"2"+"0"+M->CBA_LOCAL+Padr(M->CBA_LOCALI,15)+DTOS(M->CBA_DATA))) .or. ;
				CBA->(DbSeek(xFilial("CBA")+"2"+"1"+M->CBA_LOCAL+Padr(M->CBA_LOCALI,15)+DTOS(M->CBA_DATA)))
			Alert( "Inventario ja cadastrado ")
			Return .f.
		EndIf
	EndIf
	If ExistBlock('ACDA30OK')
		If ! Execblock('ACDA30OK',.F.,.F.)
			Return .f.
		Endif
	Endif
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAcda30Exc บAutor  ณEduardo Motta       บ Data ณ  04/02/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclusao do mestre de inventario, libera o endereco        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACDA30Exc()
	If	CBA->CBA_STATUS$"54" //If CBA->CBA_STATUS #"1"
		Return .t.
	EndIf
	If	CBA->CBA_TIPINV== "1"
		SB2->(DbSetorder(1))
		If	SB2->(DbSeek(xFilial("SB2")+CBA->(CBA_PROD+CBA_LOCAL)))
			RecLock("SB2")
			SB2->B2_DTINV := CTOD("")
			SB2->(MsUnlock())
		EndIf
	Else
		SBE->(DbSetOrder(1))
		If	SBE->(DbSeek(xFilial("SBE")+CBA->CBA_LOCAL+CBA->CBA_LOCALI))
			RecLock("SBE")
			SBE->BE_STATUS := " "
			SBE->BE_DTINV  := CTOD('')
			SBE->(MsUnlock())
		EndIf
	EndIf
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAIVA30Loc บAutor  ณRicardo             บ Data ณ  20/04/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se utiliza localizacao                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AIVA30Loc()
Return (M->CBA_TIPINV=="2" .AND. lLocaliz)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAIVA30Aut บAutor  ณRicardo             บ Data ณ  20/04/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera mestre inventario automaticamente conf. parametros    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ PROGRAMADOR  ณ DATA   ณ BOPS ณ  MOTIVO DA ALTERACAO                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Erike Yuri   ณ08/10/04ณ      ณ Inclusao de opcoes automaticas incluin-ณฑฑ
ฑฑณ              ณ        ณ      ณ do Geracao automatica de Mestre de in- ณฑฑ
ฑฑณ              ณ        ณ      ณ ventario,Lancamento SB7,Acerto e Exclu-ณฑฑ
ฑฑณ              ณ        ณ      ณ sao automatica de lancamento SB7.      ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AIVA30Aut()
	Local nAcao    := 0
	Local nOpca    := 0
	Local aSays    := {}
	Local aButtons := {}
	Local oDlg
	Private cCadastro := OemToAnsi( "Geracao automatica")


	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End()}})
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End()}})

	If ! Pergunte("AIA033",.T.)
		Return
	EndIf

	nAcao := MV_PAR01

	If	nAcao==1 //Geracao automatica de mestre de inventario
		AADD(aSays,OemToAnsi( "Esta rotina tem o objetivo de efetuar a geracao"   ))
		AADD(aSays,OemToAnsi( "automatica de mestres de inventario, a partir do"  ))
		AADD(aSays,OemToAnsi( "range informado pelo operador nos parametros."     ))

		FormBatch(cCadastro, aSays, aButtons,,200,450 ) // Monta Caixa de dialogo
		If	nOpca <> 1
			Return
		EndIf
		If	lLocaliz //Utiliza Controle de Localizacao == Gera por Produto ou Endereco
			If ! Pergunte("AIA031",.T.)  //Seleciona Produto ou Endereco
				Return
			EndIf
			If mv_par01 == 01 //Produto
				If ! Pergunte("AIA032",.T.)
					Return
				EndIf
				Processa({|| AI031( )})
			Else //Endereco
				If ! Pergunte("AIA030",.T.)
					Return
				EndIf
				Processa({|| AI030( )})
			EndIf
		Else //Nao utiliza Controle de Localizacao == Gera por Produto
			If ! Pergunte("AIA032",.T.)
				Return
			EndIf
			Processa({|| AI031( )})
		EndIf
	ElseIf nAcao==2 //Exclusao automatica de mestre de inventario
		AADD(aSays,OemToAnsi( "A T E N C A O:"))
		AADD(aSays,OemToAnsi( "Esta rotina tem o objetivo de efetuar a exclusao"))
		AADD(aSays,OemToAnsi( "automatica de mestres de inventarios informados "))
		AADD(aSays,OemToAnsi( "nos parametros solicitados."))
		FormBatch(cCadastro, aSays, aButtons,,200,450 ) // Monta Caixa de dialogo
		If nOpca == 1
			If	!Pergunte("AIA034",.T.)  //Seleciona o Mestre de Inventario de Ate
				Return
			EndIf
			Processa({||ExcluiCBA()})
		EndIf
	ElseIf nAcao==3 //Geracao automatica do lancamento de inventario
		AADD(aSays,OemToAnsi( 'Esta rotina tem o objetivo de efetuar a geracao automatica'))
		AADD(aSays,OemToAnsi( 'do lancamento de inventario (tabela SB7), atraves da tabela'))
		AADD(aSays,OemToAnsi( 'de mestre de inventario (CBA), que ja foi finalizada. Caso'))
		AADD(aSays,OemToAnsi( 'o modelo do inventario seja o "2", so sera gerado lancamento'))
		AADD(aSays,OemToAnsi( 'para os totais inventariados diferentes do saldo em estoque.'))
		FormBatch(cCadastro, aSays, aButtons,,200,450 ) // Monta Caixa de dialogo
		If	nOpca == 1
			If	!Pergunte("AIA034",.T.) //Seleciona o Mestre de Inventario de Ate
				Return
			EndIf
			Processa({||GeraSB7Auto()})
		EndIf
	ElseIf nAcao==4 //Exclusao automatica do lancamento de inventario
		AADD(aSays,OemToAnsi( "A T E N C A O:"))
		AADD(aSays,OemToAnsi( "Esta rotina tem o objetivo de efetuar a exclusao"))
		AADD(aSays,OemToAnsi( "automatica dos lancamentos de inventarios infor-"))
		AADD(aSays,OemToAnsi( "mados nos parametros solicitados."))
		FormBatch(cCadastro, aSays, aButtons,,200,450 ) // Monta Caixa de dialogo
		If nOpca == 1
			If	!Pergunte("AIA034",.T.)  //Seleciona o Mestre de Inventario de Ate
				Return
			EndIf
			Processa({||ExcluiSB7()})
		EndIf
	ElseIf nAcao==5 //Geracao de acerto automatico
		AADD(aSays,OemToAnsi( 'Esta rotina ira gerar movimentacoes de ajuste para corrigir o saldo do'))
		AADD(aSays,OemToAnsi( 'estoque. Estas movimentacoes serao baseadas nas contagens realizadas e'))
		AADD(aSays,OemToAnsi( 'cadastradas na rotina de inventario Rotativo.'))
		//	AADD(aSays,OemToAnsi( 'Esta rotina tambem ira efetuar o ajuste das etiquetas (CB0), caso o'))
		//	AADD(aSays,OemToAnsi( 'cliente utilize codigo interno.'))
		FormBatch(cCadastro, aSays, aButtons,,200,450 ) // Monta Caixa de dialogo
		If nOpca == 1
			If	!Pergunte("AIA036",.T.)  //Seleciona o Mestre de Inventario de Ate
				Return
			EndIf
			Processa({||u_GeraAcerto(MV_PAR01,MV_PAR02)})
		EndIf
	EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAI030     บAutor  ณMicrosiga           บ Data ณ  20/04/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao do CBA                                             บฑฑ
ฑฑบ          ณ Por Endereco                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AI030()
	Local cCodInv   := ""
	Local lACDA30VE := ExistBlock("ACDA30VE") // Por Endereco
	Local aLog      := {}
	Local aArea     := SGetArea()
	SGetArea(aArea,"CBA")

	If MV_PAR05 < 1
		MsgAlert( "O numero de contagens nao pode ser igual ou inferior a zero, favor verificar !!!"     )
		Return
	EndIf

	dbSelectArea("SBE")
	SBE->(dbSetOrder(1))
	SBE->(dbSeek(xFilial("SBE")+MV_PAR01,.T.))
	While !Eof() .and. xFilial("SBE") == SBE->BE_FILIAL .and. SBE->BE_LOCAL <= MV_PAR02

		If	!(SBE->BE_LOCALIZ >= MV_PAR03 .and. SBE->BE_LOCALIZ <= MV_PAR04)
			IncProc()
			SBE->(dbSkip())
			Loop
		EndIf

		CBA->(dbSetOrder(2)) //CBA_FILIAL+CBA_TIPINV+CBA_STATUS+CBA_LOCAL+CBA_LOCALI+CBA_DATA
		If	CBA->(dbSeek(xFilial("CBA")+"2"+"0"+SBE->BE_LOCAL+SBE->BE_LOCALIZ+DTOS(MV_PAR06))) .OR.;
				CBA->(dbSeek(xFilial("CBA")+"2"+"1"+SBE->BE_LOCAL+SBE->BE_LOCALIZ+DTOS(MV_PAR06)))
			IncProc()
			SBE->(DbSkip())
			Loop
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Ponto de Entrada para Validar o SBE                          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lACDA30VE
			lOK := ExecBlock("ACDA30VE",.F.,.F.) //Por Endereco
			If (ValType(lOk) == "L")
				If !lOK
					aadd(aLog,{"AI030","98",NIL,NIL,SBE->BE_LOCAL,SBE->BE_LOCALIZ})
					IncProc()
					SBE->(dbSkip())
					Loop
				EndIf
			EndIf
		EndIf

		cCodInv := GetSXENum("CBA","CBA_CODINV")
		RecLock("CBA",.T.)
		CBA->CBA_Filial := xFilial("CBA")
		CBA->CBA_CODINV := cCodInv
		CBA->CBA_DATA   := MV_PAR06
		CBA->CBA_CONTS  := MV_PAR05
		CBA->CBA_STATUS := "0"
		CBA->CBA_TIPINV := "2"
		CBA->CBA_LOCAL  := SBE->BE_LOCAL
		CBA->CBA_LOCALI := SBE->BE_LOCALIZ
		CBA->CBA_CLASSA := Str(MV_PAR07,1)
		CBA->CBA_CLASSB := Str(MV_PAR08,1)
		CBA->CBA_CLASSC := Str(MV_PAR09,1)
		MsUnlock()
		If __lSX8
			ConfirmSx8()
		EndIf
		//Mestres de Inventario gerados
		aadd(aLog,{"AI030","01",CBA_CODINV,NIL,CBA->CBA_LOCAL,CBA->CBA_LOCALI})

		IncProc()
		SBE->(dbSkip())
	EndDo
	SRestArea(aArea)
	MostraLog("AI030","AIA030",aLog)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAI031     บAutor  ณMicrosiga           บ Data ณ  17/04/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao do CBA                                             บฑฑ
ฑฑบ          ณ Por Prduto                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AI031()
	Local cCodInv := ""
	Local lOk
	Local lACDA30VP := ExistBlock("ACDA30VP")
	Local aLog := {}
	Local aArea:= SGetArea()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Funcao utilizada para verificar a ultima versao dos fontes      ณ
	//ณ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
	//| cliente, assim verificando a necessidade de uma atualizacao     |
	//| nestes fontes. NAO REMOVER !!!							        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
		Final("Atualizar SIGACUS.PRW !!!")
	Endif
	If !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
		Final("Atualizar SIGACUSA.PRX !!!")
	Endif
	If !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
		Final("Atualizar SIGACUSB.PRX !!!")
	EndIf

	SGetArea(aArea,"CBA")
	If	MV_PAR04 < 1
		MsgAlert(  "O numero de contagens nao pode ser igual ou inferior a zero, favor verificar !!!"     )
		Return
	EndIf

	dbSelectArea("SB5")
	SB5->(dbSetOrder(1))
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+MV_PAR02,.T.))
	While !SB1->(Eof()) .and. xFilial("SB1") == SB1->B1_FILIAL .and. SB1->B1_COD <= MV_PAR03

		CBA->(dbSetOrder(3)) //CBA_FILIAL+CBA_TIPINV+CBA_STATUS+CBA_LOCAL+CBA_PROD+CBA_DATA
		If	CBA->(dbSeek(xFilial("CBA")+"1"+"0"+MV_PAR01+SB1->B1_COD+DTOS(MV_PAR05))) .OR.;
				CBA->(dbSeek(xFilial("CBA")+"1"+"1"+MV_PAR01+SB1->B1_COD+DTOS(MV_PAR05)))
			IncProc()
			SB1->(DbSkip())
			Loop
		EndIf

		//Gerar mestre de inventario para armazens com saldo
		//esta validacao so ocorre por produto
		SB2->(DbSetorder(1))
		If	RetFldProd(SB1->B1_COD,"B1_LOCPAD") # MV_PAR01 .And. ;
				!SB2->(DbSeek(xFilial("SB2")+SB1->B1_COD+MV_PAR01))
			IncProc()
			SB1->(DbSkip())
			Loop
		EndIf

		//So analisa um produto para bloqueio se encontrar na tabela de complemento,
		//caso contrario eu crio o mestre
		If	MV_PAR06==1 .and. SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD))
			If	!Empty(SB5->B5_PERIOT) .And. (SB5->(B5_DTINV+B5_PERIOT)>dDataBase)
				IncProc()
				SB1->(DbSkip())
				Loop
			EndIf
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Ponto de Entrada para Validar o SB1                          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	lACDA30VP
			lOK := ExecBlock("ACDA30VP",.F.,.F.)
			If (ValType(lOk) == "L")
				If !lOK
					aadd(aLog,{"AI031","98",NIL,SB1->B1_COD,RetFldProd(SB1->B1_COD,"B1_LOCPAD"),""})
					IncProc()
					SB1->(dbSkip())
					Loop
				Endif
			EndIf
		Endif

		cCodInv := GetSXENum("CBA","CBA_CODINV")
		RecLock("CBA",.T.)
		CBA->CBA_Filial := xFilial("CBA")
		CBA->CBA_CODINV := cCodInv
		CBA->CBA_DATA   := MV_PAR05
		CBA->CBA_CONTS  := MV_PAR04
		CBA->CBA_STATUS := "0"
		CBA->CBA_TIPINV := "1"
		CBA->CBA_PROD   := SB1->B1_COD
		CBA->CBA_LOCAL  := MV_PAR01
		CBA->CBA_CLASSA := Str(MV_PAR07,1)
		CBA->CBA_CLASSB := Str(MV_PAR08,1)
		CBA->CBA_CLASSC := Str(MV_PAR09,1)
		MsUnlock()
		If __lSX8
			ConfirmSx8()
		EndIf
		//Mestres de Inventario gerados
		aadd(aLog,{"AI031","01",CBA_CODINV,SB1->B1_COD,CBA->CBA_LOCAL})

		IncProc()
		SB1->(dbSkip())
	EndDo
	SRestArea(aArea)
	MostraLog("AI031","AIA032",aLog)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณTimerBrw  ณ Autor ณ Eduardo Motta         ณ Data ณ 06/04/01 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Funcao que cria timer no mbrowse                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ cMBrowse -> form em que sera criado o timer                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ .T.                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static Function TimerBrw(oMBrowse)
	Local oTimer
	DEFINE TIMER oTimer INTERVAL 1000 ACTION TmBrowse(GetObjBrow(),oTimer) OF oMBrowse
	oTimer:Activate()
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ TmBrowse ณ Autor ณ Eduardo Motta         ณ Data ณ 06/04/01 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Funcao de timer do mbrowse                                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ cMBrowse -> objeto mbrowse a dar refresh                   ณฑฑ
ฑฑณ          ณ oTimer   -> objeto timer                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ .T.                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static Function TmBrowse(oObjBrow,oTimer)
	oTimer:Deactivate()
	oObjBrow:Refresh()
	oTimer:Activate()
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณAIVA030Lg ณ Autor ณ Eduardo Motta         ณ Data ณ 06/04/01 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Legenda para as cores da mbrowse                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ Nenhum                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ .T.                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AIVA30Lg()
	Local aCorDesc := {}
	aCorDesc := {	{"BR_VERDE","Nao Iniciado"},;
		{"BR_AMARELO"	,"Em Andamento"},;
		{"BR_CINZA"		,"Em Recontagem"},;
		{"BR_LARANJA"	,"Aguardando Recontagem"},;
		{"BR_VERMELHO"	,"Processado"},;
		{"BR_PINK"		,"Com Problemas"},;
		{"BR_AZUL"		,"Contagem Finalizada (Batido)"}  }

	BrwLegenda( "Legenda - Mestre Inventario","Status", aCorDesc )
Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออหอออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณExcluiCBA()  บAutorณErike Yuri da Silva บ Data ณ 11/01/05   บฑฑ
ฑฑฬอออออออออุอออออออออออออสอออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Exclui os mestres de inventario que estiverem com status deบฑฑ
ฑฑบ         ณ 0 = nao iniciado                                           บฑฑ
ฑฑบ         ณ 2 = Em Pausa                                               บฑฑ
ฑฑบ         ณ 3 = Contado                                                บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ ACDA030                                                    บฑฑ
ฑฑศอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExcluiCBA()
	Local nX       := 0
	Local nCount   := 0
	Local cProduto := ""
	Local cMestre  := ""
	Local aProdEnd := {}

	MsgAlert('Esta Rotina ira excluir todos "Mestres Inventariados" que possuirem o seguinte status:'+chr(13)+chr(10)+;
		'0 = Nao iniciado'+chr(13)+chr(10)+;
		'2 = Em Pausa'+chr(13)+chr(10)+;
		'3 = Contado'+chr(13)+chr(10)+;
		'Para os mestres que possuirem contagem em andamento, as mesmas deverao ser encerradas antes '+;
		'de sua exclusao!')

	If !IW_MSGBOX("Deseja prosseguir com a exclusao?","Atencao","YESNO")
		Return .f.
	Endif

	//                  1         2         3         4         5         6
	//         123456789012345678901234567890123456789012345678901234567890
	AutoGRLog(Replicate("=",75))
	AutoGRLog( "                         I N F O R M A T I V O")
	AutoGRLog( "               H I S T O R I C O   D A S   E X C L U S O E S")
	AutoGRLog( "                                   D E")
	AutoGRLog( "                  M E S T R E S  D E  I N V E N T A R I O"  )
	AutoGRLog(Replicate("=",75))
	AutoGRLog( "P A R A M E T R O S:"  )
	AutoGRLog("Mestre De  : "+MV_PAR01)
	AutoGRLog("Mestre Ate : "+MV_PAR02)
	AutoGRLog(Replicate("=",75))
	AutoGRLog( "M E S T R E S   P R O C E S S A D O S :"   )
	AutoGRLog(Replicate("=",75))

	CBA->(dbSetOrder(1))
	CBB->(dbSetOrder(3))
	CBC->(DbSetOrder(2))
	CBA->(dbSeek(xFilial("CBA")+MV_PAR01,.T.))
	While CBA->(!Eof() .and. CBA_FILIAL==xFilial("CBA") .and.  CBA_CODINV<= MV_PAR02)
		If	CBA->CBA_STATUS $ "1|4|5" // Nao excluir mestres com contagem em andamento e finalizados
			CBA->(DbSkip())
			IncProc()
			Loop
		EndIf
		cMestre := CBA->CBA_CODINV
		Begin Transaction
			CBB->(DbSetOrder(1))
			CBB->(DbSeek(xFilial("CBB")+CBA->CBA_CODINV))
			While ! CBB->(EOF()) .and. CBB->(CBB_FILIAL+CBB_CODINV) == xFilial("CBB")+CBA->CBA_CODINV
				While CBC->(DbSeek(xFilial("CBC")+CBB->CBB_NUM))
					ACD35CBM(5,CBA->CBA_CODINV,CBC->CBC_COD,CBC->CBC_LOCAL,CBC->CBC_LOCALI,CBC->CBC_LOTECT,CBC->CBC_NUMLOT,CBC->CBC_NUMSER)
					RecLock("CBC",.f.)
					CBC->(DbDelete())
					CBC->(MsUnlock())
				Enddo
				RecLock("CBB",.f.)
				CBB->(DbDelete())
				CBB->(MsUnlock())
				CBB->(DbSkip())
			Enddo
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Faz o desbloqueio do inventario                              ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aProdEnd := {}
			CBLoadEst(aProdEnd,.f.)
			For nX := 1 to len(aProdEnd)
				cProduto := Subs(aProdEnd[nX,1],01,15)
				CBUnBlqInv(CBA->CBA_CODINV,cProduto)
			Next

			RecLock("CBA",.F.)
			CBA->(DbDelete())
			CBA->(MsUnLock())
			AutoGRLog("Mestre: "+CBA->CBA_CODINV+", excluido com sucesso!") //"Mestre: "###", excluido com sucesso!"
		End Transaction
		CBA->(DbSkip())
		IncProc()
		nCount++
	EndDo
	AutoGRLog(Replicate("=",75))
	AutoGRLog("Quantidade de mestres de inventarios excluidos.: "+AllTrim(Str(nCount)) ) //"Quantidade de mestres de inventarios excluidos.: "
	MOSTRAERRO()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออหอออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณGeraSB7Auto()บAutorณErike Yuri da Silva บ Data ณ 08/10/04   บฑฑ
ฑฑฬอออออออออุอออออออออออออสอออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Geracao de Lancamento de Inventario (SB7) Automatico       บฑฑ
ฑฑบ         ณ                                                            บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ ACDA030                                                    บฑฑ
ฑฑศอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraSB7Auto()
	Local cMestreAte := MV_PAR02
	Local lLoop      := .F.
	Local nCountDocs := 0
	Local nCountOk   := 0
	Local nI         := 0
	Local aAreaCBA   := SGetArea()
	Local lI         := 0
	Private lModelo1    := GetMV("MV_CBINVMD") =="1"
	Private lUsaCB001   := UsaCB0("01")
	Private aProdEnd    := {}
	Private lMsErroAuto := .F.
	Private aLogMestre  := {}

	SGetArea(aAreaCBA,"CBA")

	MsgAlert('Esta Rotina ira gerar "Lancamentos Inventariados" (SB7) dos '+;
		'Mestres de Inventario informados no range, alterando o Status para "Finalizado"'  )

	If !IW_MSGBOX('Deseja prosseguir com a geracao de "Lancamentos de Inventario"?',"Atencao","YESNO")
		Return .f.
	Endif

	//                  1         2         3         4         5         6
	//         123456789012345678901234567890123456789012345678901234567890
	AutoGRLog(Replicate("=",75))
	AutoGRLog( "                         I N F O R M A T I V O"   )
	AutoGRLog( "               H I S T O R I C O   D A S   G E R A C O E S")
	AutoGRLog( "                                   D E")
	AutoGRLog( "            L A N C A M E N T O  D O  I N V E N T A R I O (SB7)")
	AutoGRLog(Replicate("=",75))
	AutoGRLog( "P A R A M E T R O S:")
	AutoGRLog("Mestre De  : "+MV_PAR01)
	AutoGRLog("Mestre Ate : "+cMestreAte)
	AutoGRLog(Replicate("=",75))
	AutoGRLog( "I T E N S   P R O C E S S A D O S :")
	AutoGRLog(Replicate("=",75))

	CBA->(dbSetOrder(1))
	CBB->(dbSetOrder(3))
	CBC->(DbSetOrder(2))
	CBA->(dbSeek(xFilial("CBA")+MV_PAR01,.T.))
	While CBA->(!Eof() .and. CBA_FILIAL==xFilial("CBA") .and.  CBA_CODINV <= cMestreAte)

		If CBA->CBA_STATUS # "4"  //processa somente os mestre contados
			CBA->(DbSkip())
			IncProc()
			Loop
		EndIf

		If !CBB->(dbSeek(xFilial("CBB")+CBA->CBA_CODINV))
			CBA->(DbSkip())
			IncProc()
			Loop
		EndIf
		// ------------------------- Valdemir 15/10/2019 ---------------------------------
		If !Empty(CBA->CBA_XUSCT1) .AND. Empty(CBA->CBA_XUSCT2) .and. Empty(CBA->CBA_XUSCT3)

			_nXQSEP:= CBA->CBA_XQSEP
			_nXQATU:= CBA->CBA_XQATU

		ElseIF !Empty(CBA->CBA_XUSCT1) .AND. !Empty(CBA->CBA_XUSCT2) .and. Empty(CBA->CBA_XUSCT3)

			_nXQSEP:= CBA->CBA_XQSEP2
			_nXQATU:= CBA->CBA_XQATU2

		ElseIF !Empty(CBA->CBA_XUSCT1) .AND. !Empty(CBA->CBA_XUSCT2) .and. !Empty(CBA->CBA_XUSCT3)

			_nXQSEP:= CBA->CBA_XQSEP3
			_nXQATU:= CBA->CBA_XQATU3

		EndIf
		// -------------------------

		//Verifica se existe contagem em andamento
		lLoop := .F.

		/*/
		//Analisa produto a produto e gera SB7
		aProdEnd := {}
		CBLoadEst(aProdEnd,.f.)
		lMsErroAuto	:= .F.
		CBAnaInv(.t.,.t.)

		/*/
		DbSelectarea("SB1")
		DbSetOrder(1)
		DbGotop()
		Dbseek(Xfilial("SB1")+cba->cba_prod)

		DbSelectarea("SB7")
		Reclock("SB7",.T.)
		SB7->B7_FILIAL  := xFilial("SB7")
		SB7->B7_COD     := CBA->CBA_PROD
		SB7->B7_LOCAL   := CBA->CBA_LOCAL
		SB7->B7_TIPO    := SB1->B1_TIPO
		SB7->B7_DOC     := CBA->CBA_CODINV
		SB7->B7_QUANT   := CBA->CBA_XQTOK + _nXQSEP    // Valdemir 15/10/2019
		SB7->B7_DATA    := DDATABASE
		SB7->B7_LOCALIZ := CBA->CBA_LOCALI
		MsUnlock()

		DbSelectarea("CBA")
		reclock("CBA",.f.)
		CBA->CBA_STATUS := '5'
		MsUnlock()
		CBA->(dbSkip())

		IncProc()
		nCountDocs++
	EndDo

	//Gravacao do Log
	For nI:=1 To Len(aLogMestre)
		AutoGRLog(Space(aLogMestre[nI,2]*2)+aLogMestre[nI,3])
		If Empty(aLogMestre[nI,2]) .and. aLogMestre[nI,4]
			nCountOk++ //Contagens Ok
		EndIf
	Next

	AutoGRLog(Replicate("=",75))
	AutoGRLog("Quantidade de mestres de inventarios analisados.: "+AllTrim(Str(nCountDocs)))
	AutoGRLog("Quantidade de mestres de inventarios Ok.........: "+AllTrim(Str(nCountOk)))
	AutoGRLog("Quantidade de mestres de inventarios Divergentes: "+AllTrim(Str(nCountDocs-nCountOk)))

	If ExistBlock('ACDA30LG')
		aUserLog := ExecBlock('ACDA30LG',.F.,.F.)
		If ValType(aUserLog) == 'A'
			AutoGRLog(Replicate("=",75))
			For lI := 1 To Len(aUserLog)
				AutoGRLog(aUserLog[lI,1]+aUserLog[lI,2])
			Next
		Endif
	Endif

	MOSTRAERRO()
	SRestArea(aAreaCBA)
Return



Static Function ExcluiSB7()
	Local nCountM := 0
	Local nCountD := 0
	Local aCBA    := GetArea('CBA')
	Local aSB7    := GetArea('SB7')

	MsgAlert( 'Esta Rotina ira excluir todos "Lancamentos Inventariados" (SB7) dos '   +;
		'Mestres de Inventario informados no range, alterando o Status para "Em Andamento"' )

	If !IW_MSGBOX("Deseja prosseguir com a exclusao?","Atencao","YESNO") //
		Return .f.
	Endif


	//                  1         2         3         4         5         6
	//         123456789012345678901234567890123456789012345678901234567890
	AutoGRLog(Replicate("=",75))
	AutoGRLog( "                         I N F O R M A T I V O"   )
	AutoGRLog( "               H I S T O R I C O   D A S   E X C L U S O E S"  )
	AutoGRLog( "                                   D E"       )
	AutoGRLog( "            L A N C A M E N T O  D O  I N V E N T A R I O (SB7)"   )
	AutoGRLog(Replicate("=",75))
	AutoGRLog( "P A R A M E T R O S:"    )
	AutoGRLog("Mestre De  : "+MV_PAR01)
	AutoGRLog("Mestre Ate : "+MV_PAR02)
	AutoGRLog(Replicate("=",75))
	AutoGRLog( "D O C U M E N T O S   P R O C E S S A D O S :"   )
	AutoGRLog(Replicate("=",75))

	CBA->(dbSetOrder(1))
	CBB->(dbSetOrder(3))
	CBC->(DbSetOrder(2))
	CBA->(dbSeek(xFilial("CBA")+MV_PAR01,.T.))
	While CBA->(!Eof() .and. CBA_FILIAL==xFilial("CBA") .and.  CBA_CODINV<= MV_PAR02)

		If CBA->CBA_STATUS # "4" // Nao faz diferente de finalizado (status = 4 indica que gerou sb7)
			CBA->(DbSkip())
			IncProc()
			Loop
		EndIf
		nCountD := 0
		//Como nao existe rotina automatica para a exclusao do SB7(Mata270), a exclusao sera feita diretamente
		Begin Transaction
			DbSelectArea("SB7")
			SB7->(DbOrderNickName("ACDSB701"))
			SB7->(DbSeek(xFilial("SB7")+CBA->CBA_CODINV))
			While SB7->(!Eof() .AND. B7_FILIAL+B7_DOC==xFilial("SB7")+CBA->CBA_CODINV)
				RecLock("SB7",.F.)
				SB7->(DbDelete())
				SB7->(MsUnLock())
				nCountD++
				SB7->(DbSkip())
			EndDo
			AutoGRLog("Mestre:"+CBA->CBA_CODINV+", foram excluidos "+AllTrim(Str(nCountD))+ " documentos na tabela de lanc. invent.")
			RecLock("CBA",.F.)
			CBA->CBA_STATUS := "3" // Contado
			CBA->(MsUnLock())
		End Transaction
		CBA->(DbSkip())
		IncProc()
		nCountM++
	EndDo
	AutoGRLog(Replicate("=",75))
	AutoGRLog("Quantidade de mestres de inventarios analisados.: "+AllTrim(Str(nCountM)) )
	MostraErro()

	RestArea(aSB7)
	RestArea(aCBA)
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออหอออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณGeraAcerto() บAutorณErike Yuri da Silva บ Data ณ 08/10/04   บฑฑ
ฑฑฬอออออออออุอออออออออออออสอออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Geracao o acerto do inventario a partir no cod. do mestre  บฑฑ
ฑฑบ         ณ                                                            บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ ACDA030                                                    บฑฑ
ฑฑศอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STAINV(_cCod)

	RpcSetType( 3 )
	RpcSetEnv( '01', '02',,,)

	u_GeraAcerto(_cCod)

	RpcClearEnv()
Return


User Function GeraAcerto(_cCodRot,_cCodRota)

	Local cMestreDe  	:= _cCodRot
	Local cMestreAte 	:= _cCodRota
	Local aAreaCBA   	:= SGetArea()
	Local _nEmpenh   	:= 0
	Local cAliasLif    	:= 'TMP02'
	Local _cEndere 	 	:= ""
	Local cQuery       	:= ""
	Local lMsErroAuto	:= .F.
	Local aEmpenho		:= {}
	Local nX 			:= 0

	If !IW_MSGBOX('Deseja prosseguir com o "Acerto de Inventario"?',"Atencao","YESNO")
		Return .f.
	Endif

	//cQuery := "SELECT B7_DOC DOC, B7_LOCAL LOCAL, B7_LOCALIZ LOCALIZ, B7_COD COD FROM " + RetSqlName("SB7")+ " SB7 WHERE SB7.B7_LOCAL = '03' AND SB7.B7_FILIAL = '"+XFILIAL('SB7')+"' AND SB7.B7_STATUS = ' ' AND SB7.B7_DOC  BETWEEN '"+  cMestreDe +"' AND '"+  cMestreAte +"'  AND SB7.D_E_L_E_T_ = ' '  "
	cQuery := "SELECT B7_DOC DOC, B7_LOCAL LOCAL, B7_LOCALIZ LOCALIZ, B7_COD COD FROM " + RetSqlName("SB7")+ " SB7 WHERE SB7.B7_FILIAL = '"+XFILIAL('SB7')+"' AND SB7.B7_STATUS = ' ' AND SB7.B7_DOC  BETWEEN '"+  cMestreDe +"' AND '"+  cMestreAte +"'  AND SB7.D_E_L_E_T_ = ' '  "
	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)


	If Select(cAliasLif) > 0
		dbSelectArea(cAliasLif)
		(cAliasLif)->(dbgotop())

		While !EOF()

			_nEmpenh := 0
			aEmpenho := {}

			dbSelectArea("SBF")
			dbSetOrder(2)
			dbGoTop()
			//IF dbSeek(xFilial("SBF")+(cAliasLif)->LOCAL+(cAliasLif)->LOCALIZ+(cAliasLif)->COD)
			IF dbSeek(xFilial("SBF")+(cAliasLif)->COD+(cAliasLif)->LOCAL)

				While !EOF() .and. SBF->BF_FILIAL = xFilial("SBF") .and. SBF->BF_PRODUTO = (cAliasLif)->COD .and. SBF->BF_LOCAL = (cAliasLif)->LOCAL
					//>>Ticket 20210330005098 - Everson Santana - 06.04.2021
					//_nEmpenh += SBF->BF_EMPENHO
					If SBF->BF_EMPENHO > 0
						Aadd(aEmpenho,{xFilial("SBF"),(cAliasLif)->LOCAL,(cAliasLif)->LOCALIZ,(cAliasLif)->COD,SBF->BF_EMPENHO})
					EndIf

					RecLock("SBF",.F.)
					SBF->BF_EMPENHO:= 0
					MsUnLock()

					
					SBF->(dbSkip())
				End

				//<<
			ENDIF

			dbSelectArea("SB7")
			dbSetOrder(3)
			dbGoTop()

			if dbSeek(xFilial("SB7")+(cAliasLif)->DOC)

				MSExecAuto({|x,y,z| mata340(x,y,z)}, .T.,(cAliasLif)->DOC,.T.)

				If lMsErroAuto

					//MsgAlert("Inventario nใo processado, por favor verifique","Aten็ใo.")
					//>>Ticket 20210330005098 - Everson Santana - 06.04.2021
					If Len(aEmpenho) > 0

						For nX := 1 to len(aEmpenho)

							dbSelectArea("SBF")
							dbSetOrder(1)
							dbGoTop()
							IF dbSeek(aEmpenho[nX][01]+aEmpenho[nX][02]+aEmpenho[nX][03]+aEmpenho[nX][04])
								RecLock("SBF",.F.)
								SBF->BF_EMPENHO := aEmpenho[nX][05]
								MsUnLock()
							EndIf

						Next
					EndIf
					//<<
					Return()
				Else

					dbSelectArea("SBE")
					dbSetOrder(1)
					dbGotop()

					IF dbSeek(xFilial("SBE")+(cAliasLif)->LOCAL+(cAliasLif)->LOCALIZ)

						If !Empty(SBE->BE_DTINV)
							RecLock('SBE',.F.)
							SBE->BE_DTINV := CTOD("  /  /  ")
							SBE->(MsUnLock())
						EndIf

					ENDIF

				EndIf

				//MATA340(.T.,(cAliasLif)->DOC,.T.)

			endif

			//>>Ticket 20210330005098 - Everson Santana - 06.04.2021
			If Len(aEmpenho) > 0

				For nX := 1 to len(aEmpenho)

					dbSelectArea("SBF")
					dbSetOrder(1)
					dbGoTop()
					IF dbSeek(aEmpenho[nX][01]+aEmpenho[nX][02]+aEmpenho[nX][03]+aEmpenho[nX][04])
						RecLock("SBF",.F.)
						SBF->BF_EMPENHO := aEmpenho[nX][05]
						MsUnLock()
					EndIf

				Next
			EndIf
			//<<
			/*		
			dbSelectArea("SBF")
			RecLock("SBF",.F.)
			SBF->BF_EMPENHO:= _nEmpenh
			MsUnLock()
			*/
			dbSelectArea(cAliasLif)
			dbSkip()
		End

	EndIf

	SRestArea(aAreaCBA)

Return


Static Function MostraLog(cRotina,cPerg,aLog)
	Local nI       := 0
	Local nOk      := 0
	Local nNo      := 0
	Local aExcecao := {}
	Local nTamSX1  := Len(SX1->X1_GRUPO)

	AutoGRLog(Replicate("=",75))
	AutoGRLog( "                         I N F O R M A T I V O")
	If cRotina=="AI031"
		AutoGRLog( "               H I S T O R I C O   D A S   G E R A C O E S")
		AutoGRLog( "                                   D E")
		AutoGRLog( "                 M E S T R E   D E   I N V E N T A R I O")
	ElseIf cRotina=="AI030"
		AutoGRLog( "               H I S T O R I C O   D A S   G E R A C O E S")
		AutoGRLog( "                                   D E")
		AutoGRLog( "                 M E S T R E   D E   I N V E N T A R I O")
	EndIf
	AutoGRLog(Replicate("=",75))
	AutoGRLog( "P A R A M E T R O S:")
	cPerg := PADR(cPerg,nTamSX1)
	SX1->(DbSetOrder(1))
	SX1->(DbSeek(cPerg))
	While SX1->(!Eof() .AND. X1_GRUPO == cPerg)
		If SX1->X1_GSC == 'G'
			SX1->(AutoGRLog("Pergunta "+X1_ORDEM+": "+X1_PERGUNT+Alltrim(X1_CNT01)))
		Else
			SX1->(AutoGRLog("Pergunta "+X1_ORDEM+": "+X1_PERGUNT+If(X1_PRESEL==1,'Sim','Nao')))
		Endif
		SX1->(DbSkip())
	Enddo

	AutoGRLog(Replicate("=",75))
	AutoGRLog( "I T E N S   P R O C E S S A D O S :"    )
	AutoGRLog(Replicate("=",75))

	For nI:=1 To Len(aLog)
		If aLog[nI,2]=="98"
			aadd(aExcecao,{aLog[nI,1],NIL,aLog[nI,3],aLog[nI,4],aLog[nI,5],aLog[nI,6]})
			Loop
		EndIf
		If cRotina == "AI030"
			AutoGRLog("Mestre: "+aLog[nI,3]+" - Local: "+aLog[nI,5]+" - Endereco:"+aLog[nI,6])
		ElseIf cRotina == "AI031"
			AutoGRLog("Mestre: "+aLog[nI,3]+" - Produto: "+aLog[nI,4]+" - Local: "+aLog[nI,5])
		EndIf
		nOk++
	Next

	If !Empty(aExcecao)
		AutoGRLog("")
		AutoGRLog(Replicate("=",75))
		AutoGRLog( "E X C E C O E S:")
		AutoGRLog( "- Nao foi gerado mestre de inventario para o(s) item(s) abaixo."    )
	EndIf

	For nI:=1 To Len(aExcecao)
		If cRotina == "AI030"
			AutoGRLog("Local:"+aExcecao[nI,5]+" - Endereco: "+aExcecao[nI,6])
		ElseIf cRotina == "AI031"
			AutoGRLog( "Produto: "+aExcecao[nI,4]+" - Local: "+aExcecao[nI,5])
		EndIf
		nNo++
	Next
	AutoGRLog(Replicate("=",75))
	AutoGRLog("Sucesso(s)....:"+Str(nOk)) //
	AutoGRLog("Divergencia(s):"+Str(nNo)) //
	MostraErro()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณAjustaSX1 ณ Autor ณ A้cio Ferreira Gomes      ณ Data ณ 08/12/2008    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณAjusta a validacao das perguntas AIA032(MV_PAR05) e AIA030(MV_PARA04)ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณACDA030                                                              ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1()

	Local aAreaAnt := GetArea()
	Local aAreaSX1 := SX1->(GetArea())
/* Removido - 18/05/2023 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
	dbSelectArea("SX1")
	dbsetOrder(1)

	If (SX1->(DbSeek("AIA030    "+"05"))) // Numero de Contagens
		If !("(MV_PAR05>0)" $ Upper(SX1->X1_VALID))
			Reclock("SX1",.F.)
			SX1->X1_VALID := "(MV_PAR05>0)"
			MsUnlock()
		EndIf
		If SX1->X1_CNT01 <= "0"
			Reclock("SX1",.F.)
			SX1->X1_CNT01 := "1"
			MsUnlock()
		EndIf
	EndIf

	If (SX1->(DbSeek("AIA032    "+"01"))) // Armazem
		If "(MV_PAR04>0)" $ Upper(SX1->X1_VALID)
			Reclock("SX1",.F.)
			SX1->X1_VALID := ""
			MsUnlock()
		EndIf
	EndIf

	If (SX1->(DbSeek("AIA032    "+"04"))) // Numero de Contagens
		If !("(MV_PAR04>0)" $ Upper(SX1->X1_VALID))
			Reclock("SX1",.F.)
			SX1->X1_VALID := "(MV_PAR04>0)"
			MsUnlock()
		EndIf
		If SX1->X1_CNT01 <= "0"
			Reclock("SX1",.F.)
			SX1->X1_CNT01 := "1"
			MsUnlock()
		EndIf
	EndIf*/

	RestArea(aAreaSX1)
	RestArea(aAreaAnt)
Return
/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณMTA010MI  บ Autor ณ Aecio Ferreira Gomes บ Data ณ  24/12/08   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDescricao ณVerifica se existe o produto na tabela CBJ                    บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ MATA010(Cadastro de produtos)                                บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MTA010MI(cProduto)

	Local lRet     := .F.
	Local cAliasCBA:= ""

	#IFDEF TOP
		cAliasCBA := GetNextAlias()
		cQuery    := ""

		cQuery += "SELECT COUNT(*) QTDBASE FROM " + RetSqlName( "CBA" ) + " "
		cQuery += "WHERE "
		cQuery += "CBA_FILIAL='" + xFilial( "CBA" ) + "' AND "
		cQuery += "CBA_PROD='" + cProduto            + "' AND "
		cQuery += "D_E_L_E_T_=' '"

		cQuery := ChangeQuery( cQuery )
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCBA,.F.,.T. )

		If (cAliasCBA)->QTDBASE > 0
			PutHelp ("PMTA010MI",{"Produto nใo poderแ ser excluํdo. "},;
				{"Producto no puede ser borrado.   "},;
				{"Product cannot be deleted.       "},;
				.F.)

			PutHelp ("SMTA010MI",{"Verificar o cadastro de "," Mestre de inventแrio do ACD.  "},;
				{"Compruebe el registro de "," Maestro de inventario de la ACD. "},;
				{"Check the registration of "," Master of inventory of the ACD.      "},;
				.F.)

			Help(" ",1,"MTA010MI")
			lRet := .T.
		Endif
	#ENDIF

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STIMP030 บAutor  ณ RVG                บ Data ณ  16/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para importacao de planilha excel para mestre de    บฑฑ
ฑฑบ          ณ inventแrio                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function STIMP030

	Local _aDados    := {}					//Array com os campos enviados no TXT.
	Local nHandle := 0						//Handle do arquivo texto.
	Local cArqImp := ""						//Arquivo Txt a ser lido.
	private _lerror := .f.
	Private _aCampos := {"CBA_FILIAL","CBA_PROD" ,"CBA_LOCAL"  }

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Busca o arquivo para leitura.											 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cArqImp := cGetFile("Arquivo .CSV |*.CSV","Selecione o Arquivo CSV",0,"",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD )
	If (nHandle := FT_FUse(cArqImp))== -1
		MsgInfo("Erro ao tentar abrir arquivo.","Aten็ใo")
		Return
	EndIf


	If ! ApMsgYesNo("Confirma a importacao do arquivo " + cArqImp +" ???", "Confirmar")
		Return
	EndIf


	MsgRun("Aguarde, lendo arquivo de texto e gravando os produtos novos....",, { || FLEARQ(_aDados)})

	If _lerror
		MostraErro("\spool\", cFile)
	endif


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTCDA030  บAutor  ณ RVG                บ Data ณ  16/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Leutira do arquivo e criacao de array com os dados a serem บฑฑ
ฑฑบ          ณ importados                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

*/

Static Function FLEARQ()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declara variaveis.														 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local cLinha  := ""						//Linha do arquivo texto a ser tratada.
	Private _cError := ''

	FT_FGOTOP()

	_aFils := {'01','02','04'}

	While !FT_FEOF()
		cLinha := FT_FREADLN()
		cLinha := Upper(NoAcento(AnsiToOem(cLinha)))


		_aDados := {}

		While At(";",cLinha) > 0
			aAdd(_aDados,Substr(cLinha,1,At(";",cLinha)-1))
			cLinha := StrTran(Substr(cLinha,At(";",cLinha)+1,Len(cLinha)-At(";",cLinha)),'"','')
		EndDo
		if ! Empty(cLinha)
			aAdd(_aDados,cLinha)
		EndIf


		//For _nCount := 1 to len(_Afils)
		//		_aDados[1] := _Afils[_nCount]
		FCRIACBA(_aDados)
		//	Next _nCount

		FT_FSKIP()
	EndDo
	FT_FUSE()


	@ 000, 000 TO 430, 550 DIALOG oDlgX1 TITLE 'Inconsistencias'
	@ 005,005 Get _cError  WHEN .F. Size 267,180 MEMO Object oMemo
	@ 192,235 BMPBUTTON TYPE 1 ACTION Close(oDlgX1)

	ACTIVATE DIALOG oDlgX1 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCRIACBA  บAutor  ณ RVG                บ Data ณ  16/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Criacao da tabela cba - cabecalho do mestre de inventแrio  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

*/
Static Function FCRIACBA(_aDados)

	Local _nPosProd  := 2
	Local _nPosLocal := 3
	Local _nPosFil   := 1


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declara variaveis.														 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local nX			:= 0

	_aDados[_nPosProd] 	:= substr(_aDados[_nPosProd]+space(50),1,len(SB1->B1_COD))
	_aDados[_nPosFil] 	:= STRZERO(VAL(_aDados[_nPosFil]),len(SB1->B1_FILIAL))
	_aDados[_nPosLocal]	:= STRZERO(VAL(_aDados[_nPosLocal]),len(SB1->B1_LOCPAD))



	//DbselectArea("SB2")
	//Dbsetorder(1)
	//DbSeek(_aDados[_nPosFil]+ _aDados[_nposProd]+_aDados[_nposLocal] )

	//if eof()

	//_cError += _aDados[_nPosFil] + "-" + _aDados[_nPosProd] + "-" +  _aDados[_nPosLocal] + "Produto e Local nao encontrados"     + chr(13) + chr(10)


	//Else

	DbselectArea("SBF")
	SBF->(DbSetOrder(2))

	dbSeek(_aDados[_nPosFil]+ _aDados[_nposProd]+_aDados[_nposLocal] )

	IF !EOF()

		//	If U_STResSDC(SBF->BF_PRODUTO) > 0
		//		_cError += _aDados[_nPosFil] + " - " +_aDados[_nPosProd] + " - " +  _aDados[_nPosLocal] + "Produto com Empenho"+ chr(13) + chr(10)
		//	Else
		DO WHILE  _aDados[_nposFil]+_aDados[_nposProd]+_aDados[_nposLocal]  == BF_FILIAL+BF_PRODUTO+BF_LOCAL .AND. !EOF()

			IF SBF->BF_QUANT > 0
				cCodInv := GetSXENum("CBA","CBA_CODINV")

				DbSelectArea("CBA")
				RecLock("CBA",.T.)
				CBA->CBA_Filial := _aDados[_nPosFil]
				CBA->CBA_CODINV := cCodInv
				CBA->CBA_DATA   := dDatabase
				CBA->CBA_CONTS  := 4
				CBA->CBA_STATUS := "0"
				CBA->CBA_TIPINV := "3"
				CBA->CBA_LOCAL  := SBF->BF_LOCAL
				CBA->CBA_LOCALI := SBF->BF_LOCALIZ
				CBA->CBA_PROD   := SBF->BF_PRODUTO

				MsUnlock()


				ConfirmSx8()
			ENDIF
			DbSelectArea("SBF")
			DbSkip()

		EndDo

		//EndIf
	Else

		_cError += _aDados[_nPosFil] + " - " +_aDados[_nPosProd] + " - " +  _aDados[_nPosLocal] + "Produto nao possui enderecos"+ chr(13) + chr(10)


	Endif

	//EndIf


return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCRIACBA  บAutor  ณ RVG                บ Data ณ  16/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Criacao da tabela cba - cabecalho do mestre de inventแrio  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

*/

User Function AIVA30Usu

	Local _cArea_CBA := getarea()

	if msgyesno("Confirma Liberacao deste produto para outro usuario")

		_cQuery := "SELECT NVL(R_E_C_N_O_,0)  AS REG FROM "+retsqlname('CBA')+" WHERE CBA_PROD <>'"+CBA->CBA_PROD+" AND CBA_FILIAL = '"+XFILIAL('CBA')+"' AND D_E_L_E_T_ = ' '  ORDER BY CBA_PROD,R_E_C_N_O_ " // em sql

		_cQuery := ChangeQuery(_cQuery)

		TcQuery _cQuery New Alias "QR1"

		DbGotop()
		Do While !eof()

			DbSelectArea("CBA")
			DbGoto(qr1->reg)

			RecLock("CBA",.F.)
			if CBA->CBA_STATUS == "1"
				CBA->CBA_STATUS := "0"
			elseif	CBA->CBA_STATUS == "3"
				CBA->CBA_STATUS := "2"
			endif
			MsUnlock()

			DbSelectArea("QR1")
			DbSkip()

		Enddo

		DbSelectArea("QR1")
		DbCloseArea("QR1")

	Endif

	RestArea(_cArea_CBA)
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCRIACBA  บAutor  ณ RVG                บ Data ณ  16/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Criacao da tabela cba - cabecalho do mestre de inventแrio  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

*/

User Function AIVA30And

	Local _cArea_CBA := getarea()

	//	_cQuery := "SELECT NVL(R_E_C_N_O_,0)  AS REG FROM "+retsqlname('CBA')+" WHERE CBA_PROD <>'"+CBA->CBA_PROD+" AND CBA_FILIAL = '"+XFILIAL('CBA')+"' AND D_E_L_E_T_ = ' '  ORDER BY CBA_PROD,R_E_C_N_O_ " // em sql


	_cQuery := "	SELECT DISTINCT  FILIAL, "
	_cQuery += "                 SUM(LIDOS) AS LIDOS , "
	_cQuery += "                 SUM(TOTAIS) AS TOTAIS, "
	_cQuery += "                 SUM(RECONTAR) AS RECONTAR "
	_cQuery += " FROM "
	_cQuery += " ( "
	_cQuery += " SELECT DISTINCT CBA_FILIAL AS FILIAL ,COUNT(*) AS  LIDOS , 0        AS TOTAIS,0 AS RECONTAR  FROM  "+retsqlname('CBA')+" WHERE D_E_L_E_T_ = ' ' AND CBA_DATA LIKE '"+substr(dtos(dDatabase),1,6)+"%' AND CBA_STATUS <> '0' GROUP BY CBA_FILIAL "

	_cQuery += " UNION ALL "
	_cQuery += " SELECT DISTINCT CBA_FILIAL AS FILIAL ,0  AS  LIDOS       , COUNT(*) AS TOTAIS,0 AS RECONTAR  FROM  "+retsqlname('CBA')+" WHERE D_E_L_E_T_ = ' ' AND CBA_DATA LIKE '"+substr(dtos(dDatabase),1,6)+"%'      GROUP BY CBA_FILIAL "

	_cQuery += " UNION ALL "
	_cQuery += " SELECT DISTINCT CBA_FILIAL AS FILIAL ,0  AS  LIDOS       , 0 AS TOTAIS,COUNT(*) AS RECONTAR  FROM  "+retsqlname('CBA')+" WHERE D_E_L_E_T_ = ' ' AND CBA_DATA LIKE '"+substr(dtos(dDatabase),1,6)+"%'  AND CBA_STATUS ='3'    GROUP BY CBA_FILIAL "

	_cQuery += " ) TEMP "
	_cQuery += " GROUP BY FILIAL "
	_cQuery += " ORDER BY FILIAL "


	_cQuery := ChangeQuery(_cQuery)

	TcQuery _cQuery New Alias "QR1"

	TCSetField("QR1","TOTAIS","N",14,2)
	TCSetField("QR1","LIDOS","N",14,2)
	TCSetField("QR1","RECONTAR","N",14,2)

	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>Checagem de andamento de contagem</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60% align=righ>'
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Definicao do texto/detalhe do email                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cMsg += '<TR height=70% BgColor=#B0E2FF>'
	cMsg += '<TD align=righ><B><Font Color=#000000  align="right" Size="4" Face="Arial">Filial</Font></B></TD>'
	cMsg += '<TD align=righ><B> <Font Color=#000000  align="right" Size="4" Face="Courier New">Registros </Font></B></TD>'
	cMsg += '<TD align=righ><B> <Font Color=#000000  align="right" Size="4" Face="Courier New">Contados </Font></B></TD>'
	cMsg += '<TD align=righ><B> <Font Color=#000000  align="right" Size="4" Face="Courier New">Para Recontar</Font></B></TD>'
	cMsg += '</TR>'


	DbGotop()
	Do While !eof()

		cMsg += '<TR height=70% BgColor=#B0E2FF>'
		cMsg += '<TD height=25% align=righ><B> <Font Color=#000000 align=right Size="4" Face="Courier New">'+qr1->Filial+'</Font></B></TD>'
		cMsg += '<TD height=25% align=righ><B> <Font Color=#000000 align=right Size="4" Face="Courier New">'+TRANSFORM(qr1->totais,'@e9 999,999')+'</Font></B></TD>'
		cMsg += '<TD height=25% align=righ><B> <Font Color=#000000 align=right Size="4" Face="Courier New">'+TRANSFORM(qr1->LIDOS,'@e9 999,999')+'</Font></B></TD>'
		cMsg += '<TD height=25% align=righ><B> <Font Color=#000000 align=right Size="4" Face="Courier New">'+TRANSFORM(qr1->RECONTAR,'@e9 999,999')+'</Font></B></TD>'
		cMsg += '</TR>'


		DbSelectArea("QR1")
		DbSkip()

	Enddo

	DbSelectArea("QR1")
	DbCloseArea("QR1")

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Definicao do rodape do email                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

	MsgInfo(cMsg,"Andamento de Contagem")
	RestArea(_cArea_CBA)
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINVROT บAutorณ Robson Mazzarotto       บ Data ณ  13/07/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Setar o produto para inventario rotativo					  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 		                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

*/

User Function INVROT()

	Local _cArea_CBA := getarea()
	Local _cProd     := CBA_PROD
	Local _cInv      := CBA_CODINV

	If	!Pergunte("AIA038",.T.)  //Seleciona o Mestre de Inventario de Ate
		Return
	EndIf

	if msgyesno("Confirma colocar itens em Inventario Rotativo")

		dbSelectArea("CBA")
		dbSetOrder(1)
		dbGotop()

		IF dbSeek(xFilial("CBA")+MV_PAR01)

			while !EOF() .and. CBA->CBA_CODINV >= MV_PAR01 .and. CBA->CBA_CODINV <= MV_PAR02 .and. CBA->CBA_STATUS = "0"

				RecLock("CBA",.F.)
				CBA->CBA_XROTAT := "1"
				MsUnlock()

				dbSkip()
			End

		Endif

	Endif


	RestArea(_cArea_CBA)
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออหอออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณGeraSB7()บ Autorณ Robson Mazzarotto     บ Data ณ 14/08/2017 บฑฑ
ฑฑฬอออออออออุอออออออออออออสอออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Geracao de Lancamento de Inventario (SB7) Automatico,      บฑฑ
ฑฑบ         ณ baseado na rotina de inventario rotativo                   บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ STCDA030                                                   บฑฑ
ฑฑศอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GeraSB7(cMestre,cProdCBA)

	Local aAreaCBA   := GetArea()
	Local _nQtdPA2   := 0
	Local _nQtdAju   := 0
	Local lRet := .T.

	Local _nXQSEP:= 0
	Local _nXQATU:= 0

	dbSelectArea("CBA")
	dbSetOrder(1)
	dbGoTop()

	dbSeek(xFilial("CBA")+cMestre)

	If !Empty(CBA->CBA_XUSCT1) .AND. Empty(CBA->CBA_XUSCT2) .and. Empty(CBA->CBA_XUSCT3)

		_nXQSEP:= CBA->CBA_XQSEP
		_nXQATU:= CBA->CBA_XQATU

	ElseIF !Empty(CBA->CBA_XUSCT1) .AND. !Empty(CBA->CBA_XUSCT2) .and. Empty(CBA->CBA_XUSCT3)

		_nXQSEP:= CBA->CBA_XQSEP2
		_nXQATU:= CBA->CBA_XQATU2

	ElseIF !Empty(CBA->CBA_XUSCT1) .AND. !Empty(CBA->CBA_XUSCT2) .and. !Empty(CBA->CBA_XUSCT3)

		_nXQSEP:= CBA->CBA_XQSEP3
		_nXQATU:= CBA->CBA_XQATU3

	EndIf

	If CBA->CBA_STATUS = "4"  .or. CBA->CBA_STATUS = "6" .or. CBA->CBA_STATUS = "5"//processa somente o mestre batido e com problemas.

		IF CBA->CBA_XQTOK < (_nXQATU + _nXQSEP) //(CBA->CBA_XQATU + CBA->CBA_XQSEP)

			dbSelectArea("PA2")
			dbSetOrder(1)
			dbGoTop()

			if dbSeek(xFilial("PA2")+CBA->CBA_PROD+CBA->CBA_FILIAL)

				while !eof() .and. PA2->PA2_CODPRO = CBA->CBA_PROD .AND. PA2->PA2_FILRES == CBA->CBA_FILIAL

					_nQtdPA2 := PA2->PA2_QUANT

					dbSelectArea("PA2")
					dbSkip()
				End

			Endif

		ENDIF


		//		IF _nQtdPA2 <= _nQtdAju .AND. CBA->CBA_XQTOK <> CBA->CBA_XQATU .AND. _nQtdPA2 <> CBA->CBA_XQATU
		IF _nQtdPA2 < CBA->CBA_XQTOK .AND. CBA->CBA_XQTOK <> _nXQATU //CBA->CBA_XQATU

			DbSelectarea("SB1")
			Dbseek(Xfilial("SB1")+CBA->CBA_PROD)

			DbSelectarea("SB7")
			DbSetOrder(3)
			DbGotop()
			If !dbSeek(Xfilial("SB7")+CBA->CBA_CODINV)//Ticket 20210330005104 - Everosn Santana - 30.03.2021
				Reclock("SB7",.T.)
				SB7->B7_FILIAL  := xFilial("SB7")
				SB7->B7_COD     := CBA->CBA_PROD
				SB7->B7_LOCAL   := CBA->CBA_LOCAL
				SB7->B7_TIPO    := SB1->B1_TIPO
				SB7->B7_DOC     := CBA->CBA_CODINV
				SB7->B7_QUANT   := CBA->CBA_XQTOK+ _nXQSEP //CBA->CBA_XQSEP //Chamado 007971
				SB7->B7_DATA    := DDATABASE
				SB7->B7_LOCALIZ := CBA->CBA_LOCALI
				SB7->B7_ORIGEM  := "ACD01"//Chamado 007971
				MsUnlock()
			EndIf

		elseIF _nQtdPA2 = 0 .and. CBA->CBA_XQTOK = 0

			DbSelectarea("SB1")
			Dbseek(Xfilial("SB1")+CBA->CBA_PROD)

			DbSelectarea("SB7")
			DbSetOrder(3)
			DbGotop()
			If !dbSeek(Xfilial("SB7")+CBA->CBA_CODINV)//Ticket 20210330005104 - Everosn Santana - 30.03.2021
				Reclock("SB7",.T.)
				SB7->B7_FILIAL  := xFilial("SB7")
				SB7->B7_COD     := CBA->CBA_PROD
				SB7->B7_LOCAL   := CBA->CBA_LOCAL
				SB7->B7_TIPO    := SB1->B1_TIPO
				SB7->B7_DOC     := CBA->CBA_CODINV
				SB7->B7_QUANT   := CBA->CBA_XQTOK+_nXQSEP //CBA->CBA_XQSEP //Chamado 007971
				SB7->B7_DATA    := DDATABASE
				SB7->B7_LOCALIZ := CBA->CBA_LOCALI
				SB7->B7_ORIGEM  := "ACD02" //Chamado 007971
				If CBA->CBA_XQTOK = 0 .AND. _nXQSEP > 0 //CBA->CBA_XQSEP > 0
					SB7->B7_STATUS := "2"
				EndIf
				MsUnlock()


			EndIf
			If CBA->CBA_XQTOK = 0 .AND. _nXQSEP > 0 //CBA->CBA_XQSEP > 0

				dbSelectArea("SBE")
				dbSetOrder(1)
				dbGotop()

				IF dbSeek(xFilial("SBE")+CBA->CBA_LOCAL+CBA->CBA_LOCALI)

					RecLock('SBE',.F.)
					SBE->BE_DTINV := CTOD("  /  /  ")
					SBE->(MsUnLock())

				ENDIF

				dbSelectArea("SB2")
				dbSetOrder(1)
				dbGotop()

				IF dbSeek(xFilial("SB2")+CBA->CBA_PROD+CBA->CBA_LOCAL)

					RecLock('SB2',.F.)
					SB2->B2_DINVENT := CBA->CBA_DATA
					SB2->(MsUnLock())

				ENDIF

			EndIf

		elseif CBA->CBA_XQTOK == _nXQATU //CBA->CBA_XQATU

			dbSelectArea("SBE")
			dbSetOrder(1)
			dbGotop()

			IF dbSeek(xFilial("SBE")+CBA->CBA_LOCAL+CBA->CBA_LOCALI)

				RecLock('SBE',.F.)
				SBE->BE_DTINV := CTOD("  /  /  ")
				SBE->(MsUnLock())

			ENDIF

			dbSelectArea("SB2")
			dbSetOrder(1)
			dbGotop()

			IF dbSeek(xFilial("SB2")+CBA->CBA_PROD+CBA->CBA_LOCAL)

				RecLock('SB2',.F.)
				SB2->B2_DINVENT := CBA->CBA_DATA
				SB2->(MsUnLock())

			ENDIF

			lRet := .T.
		else
			lRet := .F.
		endif

		dbSelectArea("SBF")
		dbSetOrder(1)
		dbGotop()

		IF dbSeek(xFilial("SBF")+CBA->CBA_LOCAL+CBA->CBA_LOCALI+CBA->CBA_PROD)
			RecLock('SBF',.F.)
			SBF->BF_DINVENT := CBA->CBA_DATA
			SBF->(MsUnLock())

		ENDIF

	ENDIF

	RestArea(aAreaCBA)

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออหอออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณAcertoInv()บ Autorณ Robson Mazzarotto   บ Data ณ 17/08/2017 บฑฑ
ฑฑฬอออออออออุอออออออออออออสอออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Reprocessamento de invetario rotativo para itens com       บฑฑ
ฑฑบ         ณ status igual a 6		   						             บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ STCDA030                                                   บฑฑ
ฑฑศอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AcertoInv()

	Local aAreaCBA   := GetArea()
	Local _cMest     := CBA->CBA_CODINV

	IF !U_GeraSb7(_cMest)
		MSGALERT("Contagem continua com problemas, verifique!")
	else
		U_GeraAcerto(_cMest,_cMest)
		//IF CBA->CBA_STATUS = "6"
		//	Reclock("CBA",.F.)
		//	CBA->CBA_STATUS := "7"
		//	MsUnlock()
		//ENDIF
	ENDIF

	RestArea(aAreaCBA)

Return


/* {Protheus.doc} Function STMSGUSU
	Description
	Rotina para enviar mensagns
	@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
	@since 17/101/2020
*/
User Function STMSGUSU()
	Local cCodUsu  := ""
	Local aAreaMen := GetArea()

	// Verifica qual usuแrio serแ enviado mensagem
	if Empty(cCodUsu)
		cCodUsu := CBA_XUSCT3
		if Empty(cCodUsu)
			cCodUsu := CBA_XUSCT2
			if Empty(cCodUsu)
				cCodUsu := CBA_XUSCT1
			Endif
		Endif
	Endif

	// Chama tela de mensagem
	if !Empty(cCodUsu)
		dbSelectArea("CB1")
		dbSetOrder(2)
		lAchou := dbSeek(XFilial("CB1")+cCodUsu)			// Valdemir Rabelo 22/01/2020
		if lAchou
			//StaticCall (STFSFA10, Mensagem, CB1->CB1_CODOPE)
			u_Mensagem(CB1->CB1_CODOPE)
		else
			ApMsgInfo("Usuแrio: "+cCodUsu+" nใo encontrado na tabela [CB1]","Aten็ใo!")
		endif
	else
		ApMsgInfo("Nใo existe usuแrio informado para enviar mensagem","Aten็ใo!")
	endif

	RestArea( aAreaMen )

Return
