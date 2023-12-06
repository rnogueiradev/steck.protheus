#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFATI43  บ Autor ณ SAULO CARVALHO     บ Data ณ  16/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina para manutencao da data de entrega e justificativa noบฑฑ
ฑฑบ          ณPedido de Vendas.                                           บฑฑ
ฑฑบ          ณRef: ITEM 4.3 513603 v3                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSTECK                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function STFATI43()
	
	Local aCores := {{"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)",'ENABLE' },;		//Pedido em Aberto
	{ "!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)" ,'DISABLE'},;		   	//Pedido Encerrado
	{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)",'BR_AMARELO'},;
		{ "C5_BLQ == '1'",'BR_AZUL'},;	//Pedido Bloquedo por regra
	{ "C5_BLQ == '2'",'BR_LARANJA'},; //Pedido Bloquedo por verba
	{ "AllTrim(C5_NOTA)=='REMITO'",'BR_CINZA'}}
	
	
	Private cCadastro	:= "Pedidos de Venda - Data Prevista / Justificativa Comercial"	//Titulo da tela
	Private cAlias1		:= "SC5"														//Tabela Pai
	Private aRotina		:= {}															//Array mbrowse
	Private nTamGet6    := 74
	
	//Monta o vetor a rotina
	aAdd(aRotina, { "Pesquiar"   , "AxPesqui", 0, 1} )		//Pesquisa
	aAdd(aRotina, { "Visualizar" , "U_FATI43A", 0, 2} )	//Visualiza
	aAdd(aRotina, { "Manuten็ใo" , "U_FATI43A", 0, 4} )	//Manutencao (4 -> Alteracao para que a mensagem de bloqueio do SC5 seja apresentada caso outro usuario jah esteja alterando o pedido.)
	aAdd(aRotina, { "Legenda"    , "A410Legend", 0 , 0 , 0 , .F.} )		// "Legenda"
	
	
	//Seleciona tabela pai
	DbSelectArea(cAlias1)
	DbSetOrder(1)
	DbGoTop()
	
	//Funcao mBrowse
	mBrowse( 6, 1,22,75,"SC5",,,,,,aCores)
	//MBrowse(,,,,cAlias1)
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATI43A   บ Autor ณ SAULO CARVALHO     บ Data ณ  16/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina para tratamento da data de entrega e justificativa noบฑฑ
ฑฑบ          ณPedido de Vendas.                                           บฑฑ
ฑฑบ          ณRef: ITEM 4.3 513603 v3                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSTECK                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function FATI43A(cAlias, nRecNo, nOpc)
	
	/*
	Declara็ใo de Variaveis Private dos Objetos
	*/
	Local lEncerrado := !Empty(SC5->C5_NOTA) .OR. SC5->C5_LIBEROK == 'E' .AND. Empty(SC5->C5_BLQ) //Pedido encerrado
	Local cGet1 := SC5->C5_NUM     //Numero do Pedido
	Local cCBox1:= SC5->C5_TIPO    //Tipo Pedido
	Local aTipo := {"N=Normal","C=Compl.Precos","I=Compl.ICMS","P=Compl.IPI","D=Dev.Compras","B=Utiliza Fornecedor"}
	Local cGet2 := SC5->C5_CLIENTE //Cliente
	Local cGet3 := SC5->C5_LOJACLI //Loja do cliente
	Local cGet4 := SC5->C5_CLIENT  //Cliente de entrega
	Local dGet5 := SC5->C5_XDTEN //SC5->C5_XDTECOM //Data Entrega Comercial
	Local cGet6 := Space(nTamGet6) //O tamanho do campo YP_TEXTO eh igual a 80, mas o GET serah de 74 por causa do "\13\10" <ENTER>
	Local cGet7 := Posicione("SA1",1,xFilial("SA1") + SC5->(C5_CLIENTE + C5_LOJACLI),"A1_NREDUZ")
	Local cGet8 := SC5->C5_XDTEN //Data de Entraga do Pedido (Comercial)
	Local cGet9 := SC5->C5_XDTFABR //Data de Entrega do Pedido (Fแbrica)
	Local cGet10:= SC5->C5_VEND2 //C[odigo do Vendedor 2
	Local cGet11:= Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND2,"A3_NOME") //Nome do Vendedor 2
	
	
	Local _aHeader  := {'Descri็ใo'}
	Local _aColunas := {50}
	Local _lWhen    := .F.
	Local _nFinalizar   := 0
	SetPrvt("oDlg1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10","oSay11","oSay12","oSay13","oGet1","oGet2","oGet3")
	SetPrvt("oCBox1","oGet4","oGet5","oGet6","oGet7","oGet8","oGet9","oGet10","oGet11","oLBox1","oSBtn1","oSBtn2")
	Private aListBox  := {}
	
	If ALTERA .AND. lEncerrado
		Msgbox('Nแo ้ permitido dar manuten็ใo para um pedido de venda encerrado.','Aten็ใo','STOP')
		Return
	Endif
	
	//Verifica se ha justificativas na SYP
	FATI43B()
	
	/*
	Definicao do Dialog e todos os seus componentes.
	*/
	oDlg1      := MSDialog():New( 122,350,700,1028,cCadastro,,,.F.,,,,,,.T.,,,.T. )
	
	oSay1      := TSay():New( 008,012,{||"Numero"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oGet1      := TGet():New( 020,012,{|u| If(PCount()>0,cGet1:=u,cGet1)},oDlg1,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen},.F.,.F.,,.F.,.F.,"","cGet1",,)
	
	oSay2      := TSay():New( 008,080,{||"Tipo Pedido"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
	oCBox1     := TComboBox():New( 020,080,{|u| If(PCount()>0,cCBox1:=u,cCBox1)},aTipo,072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,{|u| _lWhen},,,,,"cCBox1")
	
	oSay3      := TSay():New( 008,172,{||"Cliente"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oGet2      := TGet():New( 020,172,{|u| If(PCount()>0,cGet2:=u,cGet2)},oDlg1,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen},.F.,.F.,,.F.,.F.,"","cGet2",,)
	
	oSay4      := TSay():New( 008,232,{||"Loja"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
	oGet3      := TGet():New( 020,232,{|u| If(PCount()>0,cGet3:=u,cGet3)},oDlg1,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen},.F.,.F.,,.F.,.F.,"","cGet3",,)
	
	oSay5      := TSay():New( 008,272,{||"Cli.Entrega"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oGet4      := TGet():New( 020,272,{|u| If(PCount()>0,cGet4:=u,cGet4)},oDlg1,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen},.F.,.F.,,.F.,.F.,"","cGet4",,)
	
	oSay9      := TSay():New( 036,012,{||"Nome"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet7      := TGet():New( 048,012,{|u| If(PCount()>0,cGet7:=u,cGet7)},oDlg1,240,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen},.F.,.F.,,.F.,.F.,"","cGet7",,)
	
	oSay10     := TSay():New( 064,012,{||"Data de Entrega Comercial"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
	oGet8      := TGet():New( 076,012,{|u| If(PCount()>0,cGet8:=u,cGet8)},oDlg1,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen},.F.,.F.,,.F.,.F.,"","cGet8",,)
	
	oSay11     := TSay():New( 064,100,{||"Data de Entrega Fแbrica"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
	oGet9      := TGet():New( 076,100,{|u| If(PCount()>0,cGet9:=u,cGet9)},oDlg1,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen},.F.,.F.,,.F.,.F.,"","cGet9",,)
	
	oSay12     := TSay():New( 064,180,{||"Vendedor 2"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
	oGet10     := TGet():New( 076,180,{|u| If(PCount()>0,cGet10:=u,cGet10)},oDlg1,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen},.F.,.F.,,.F.,.F.,"","cGet10",,)
	
	oSay13     := TSay():New( 092,012,{||"Nome Vendedor 2"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
	oGet11     := TGet():New( 104,012,{|u| If(PCount()>0,cGet11:=u,cGet11)},oDlg1,240,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen},.F.,.F.,,.F.,.F.,"","cGet11",,)
	
	oSay6      := TSay():New( 120,012,{||"Data de Entrega"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oGet5      := TGet():New( 132,012,{|u| If(PCount()>0,dGet5:=u,dGet5)},oDlg1,048,008,'',{|u| FATI43E(dGet5)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| ALTERA},.F.,.F.,,.F.,.F.,"","dGet5",,)
	
	oSay7      := TSay():New( 120,080,{||"Justificativa Comercial"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
	oGet6      := TGet():New( 132,080,{|u| If(PCount()>0,cGet6:=u,cGet6)},oDlg1,240,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| ALTERA},.F.,.F.,{|u| FATI43C(cGet6) },.F.,.F.,"","cGet6",,)
	
	oSay8      := TSay():New( 152,012,{||"Rela็ใo de justificativas do comercial"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,092,008)
	oLBox1     := TWBrowse():New( 164,012,308,088,,_aHeader,_aColunas, oDlg1, ,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	oLBox1:SetArray( aListBox )
	oLBox1:bLine := {|| { aListBox[oLBox1:nAt,1] }}
	
	oSBtn1 := TButton():New( 265,112,"&Confirmar",oDlg1,{|| (_nFinalizar := 1,oDlg1:End())},037,012,,,,.T.,,"",,{|| IIF(Len(aListBox) > 0 .AND. ALTERA,.T.,.F.)},,.F. )
	oSBtn2 := TButton():New( 265,200,"&Fechar",oDlg1,{|| oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.)
	
	If _nFinalizar == 1
		Processa({|lEnd| FATI43D(dGet5) },"Gravando justificativas","Aguarde...",.T.)
	EndIf
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATI43B   บ Autor ณ SAULO CARVALHO     บ Data ณ  16/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFuncao para buscar as justificativas do comercial e         บฑฑ
ฑฑบ          ณcarrega-las no objeto TWBrowse().                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSTECK                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function FATI43B()
	
	//Busca a ultima sequencia
	cQuery	:=	" SELECT YP_TEXTO"
	cQuery  +=	" FROM " + RetSqlName("SYP") + " YP "
	cQuery	+=	" WHERE "
	cQuery	+=	" YP_FILIAL = '"+xFilial("SYP")+"' "
	cQuery	+=	" AND YP_CHAVE = '"+SC5->C5_XCODJU2+"' "
	cQuery	+=	" AND YP_CAMPO = 'C5_XCODJU2' "
	cQuery	+=	" AND YP.D_E_L_E_T_ <> '*' "
	cQuery	+=	" ORDER BY YP_FILIAL,YP_CHAVE,YP_SEQ "
	cQuery	:= ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB1', .F., .T.)
	TRB1->(DbGotop())
	While TRB1->(!Eof())
		Aadd(aListBox,{SubStr(Alltrim(TRB1->YP_TEXTO),1,Len(Alltrim(TRB1->YP_TEXTO))-6) }) //Retira o enter do final da linha
		TRB1->(DbSkip())
	End
	
	//Fecha arquivo
	TRB1->(DbCloseArea())
	
	If Len(aListBox) == 0
		Aadd(aListBox,{""})
	Endif
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATI43C   บ Autor ณ SAULO CARVALHO     บ Data ณ  16/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFuncao para inserir no objeto TWBrowse a  justificativa     บฑฑ
ฑฑบ          ณdigitada  no campo de justificativa  (cGet6).               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSTECK                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function FATI43C(cGet6)
	
	If Len(aListBox)==1	.AND. Empty(Alltrim(aListBox[1,1]))
		aListBox[1,1]:=	Alltrim(cGet6)
		nPos :=	1
	Else
		Aadd(aListBox,{Alltrim(cGet6)})
		nPos := Len(aListBox)
	Endif
	
	oLBox1:SetArray( aListBox )
	oLBox1:bLine := {|| { aListBox[oLBox1:nAt,1] }}
	
	oLBox1:nAt:=nPos
	oLBox1:Refresh()
	
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATI43D   บ Autor ณ SAULO CARVALHO     บ Data ณ  16/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFuncao para: 1) Gravar na tabela SYP (Campo Memo) as        บฑฑ
ฑฑบ          ณjustificativas inseridas no objeto TWBrowse.                บฑฑ
ฑฑบ          ณ2) Gravar a data de entrega do pedido no SC5.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSTECK                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function FATI43D(dGet5)
	Local _nx := 0
	//Grava SYP - Justificativa do comercial
	If Empty(SC5->C5_XCODJU2)
		
		//Se ainda no existe justificativa gravada para esse pedido a inclusao sera feita.
		DbSelectArea(cAlias1)
		_cHist := SubStr(Dtoc(dDatabase)+"|"+SubStr(Time(),1,5)+"|"+Dtoc(dGet5)+"|"+Alltrim(SubStr(cUsuario,7,15))+"|",1,nTamGet6)+"\13\10" //+CRLF
		MSMM(,80,,_cHist,1,,,"SC5","C5_XCODJU2") // O nOpc do MSMM para inclusao tem que ser <> 3
		
		_nSeq := '001'
		
		For _nx := 1 To Len(aListBox)
			_nSeq := Soma1(_nSeq,3)
			
			DbSelectArea("SYP")
			Reclock("SYP",.T.)
			SYP->YP_CHAVE := SC5->C5_XCODJU2
			SYP->YP_SEQ   := _nSeq
			SYP->YP_TEXTO := Alltrim(aListBox[_nx,1])+"\13\10" //+CRLF
			SYP->YP_CAMPO := "C5_XCODJU2"
			MsUnlock()
		Next _nx
		
	Else
		
		//Busca a ultima sequencia pra atualizar somente as novas justificativas
		cQuery	:=	" SELECT "
		cQuery	+=	" Max(YP_SEQ) As SEQ "
		cQuery  +=	" FROM " + RetSqlName("SYP") + " YP "
		cQuery	+=	" WHERE "
		cQuery	+=	" YP_FILIAL = '"+xFilial("SYP")+"' "
		cQuery	+=	" AND YP_CHAVE = '"+SC5->C5_XCODJU2+"' "
		cQuery	+=	" AND YP_CAMPO = 'C5_XCODJU2' "
		cQuery	+=	" AND YP.D_E_L_E_T_ <> '*' "
		cQuery	:= ChangeQuery(cQuery)
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB1', .F., .T.)
		TRB1->(DbGotop())
		If TRB1->(!Eof())
			
			_nSeq := TRB1->SEQ
			_nSeq := Val(_nSeq)
			
			If Len(aListBox) > _nSeq
				
				_nSeq++
				
				//Registro com o usuario que fez a inclusao das novas linhas de justificativas
				DbSelectArea("SYP")
				Reclock("SYP",.T.)
				SYP->YP_CHAVE := SC5->C5_XCODJU2
				SYP->YP_SEQ   := StrZero(_nSeq,3)
				SYP->YP_TEXTO := SubStr(Dtoc(dDatabase)+"|"+SubStr(Time(),1,5)+"|"+Dtoc(dGet5)+"|"+Alltrim(SubStr(cUsuario,7,15))+"|",1,nTamGet6)+"\13\10" //+CRLF
				SYP->YP_CAMPO := "C5_XCODJU2"
				MsUnlock()
				
				_nSeq2 := _nSeq
				For _nx := _nSeq To Len(aListBox)
					_nSeq2++
					
					DbSelectArea("SYP")
					Reclock("SYP",.T.)
					SYP->YP_CHAVE := SC5->C5_XCODJU2
					SYP->YP_SEQ   := StrZero(_nSeq2,3)
					SYP->YP_TEXTO := Alltrim(aListBox[_nx,1])+"\13\10" //+CRLF
					SYP->YP_CAMPO := "C5_XCODJU2"
					MsUnlock()
				Next _nx
			Endif
			
			//Fecha arquivo
			TRB1->(DbCloseArea())
			
		Endif
	Endif
	
	
	//Grava a Data de entrega do comercial no cabecalho do Pedido de Venda.
	SC5->(Reclock("SC5",.F.))
	SC5->C5_XDTEN := dGet5
	SC5->(MsUnlock())
	SC5->( DbCommit() )
Return




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATI43E   บ Autor ณ SAULO CARVALHO     บ Data ณ  06/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao da data.                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSTECK                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function FATI43E(dGet5)
	
	Local _lRet := .T.
	
	/*
	If dGet5 < dXDTEN //Data Fabrica < Data Comercial
		_lRet := .F.
		MsgBox('Data da fabrica nใo pode ser menor que a data de entrega de vendas. A Data de Entrega de Vendas ้ '+dtoc(dXDTEN),'FATI43E-Atenวใo','STOP') //giovani zago add dtoc
	Endif
	*/
	If dGet5 < Date() //Data Fabrica < Data
		_lRet := .F.
		MsgBox('Data da fabrica nแo pode ser menor que a data do dia.','FATI43E-Aten็ใo','STOP')
	Endif
	
Return(_lRet)
