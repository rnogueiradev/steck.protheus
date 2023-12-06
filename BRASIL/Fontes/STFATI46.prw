#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "AVPRINT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "FILEIO.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFATI46  º Autor ³ SAULO CARVALHO     º Data ³  22/01/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina para tratamento de pedidos do tipo retira.           º±±
±±º          ³                                                            º±±
±±º          ³Ref: ITEM 4.6 513603 v3                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³STECK                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function STFATI46()

Local aCores := {{"Empty(ZZ2_DTENTR) .AND. Empty(ZZ2_DTSAID) .AND. Empty(ZZ2_OBS)",'ENABLE' },; //LIBERADO PARA COLETA (O vendedor incluiu o pedido).
{ "!Empty(ZZ2_DTENTR) .AND. Empty(ZZ2_DTSAID) .AND. Empty(ZZ2_OBS)" ,'BR_AZUL'},; //CLIENTE COLETANDO (O cliente está na Steck e a recepção já apontou os dados do responsável).
{ "!Empty(ZZ2_DTSAID)",'DISABLE'},; //COLETADO (A recepção informou a data de saída)
{ "Empty(ZZ2_DTSAID) .AND. !Empty(ZZ2_OBS)",'BR_PRETO'}}	//NÃO COLETADO (Não tem data de saída e tem observação. Ex: Transportadora não aguardou).

Private cCadastro	:= "Pedidos de Venda - Tipo Retira"	//Titulo da tela
Private cAlias1		:= "ZZ2"						 	//Tabela Pai
Private aRotina		:= {} 
								//Array mbrowse
Private _lRecepcao  := FATI46F1()						//Retorno .T. se o usuario pertence ao grupo de usuario da recepcao.

SetPrvt("oDlg2","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oGet1","oGet2","oGet3")
SetPrvt("oGet5","oGet6","oGet7","oGet8","oGet9","oGet10","oGrp2","oSay8","oSay9","oSay10","oSay11","oSay12")
SetPrvt("oSay14","oSay15","oSay16","oSay17","oSay18","oGet11","oGet12","oGet13","oGet14","oGet15","oGet16","oGet17","oGet18","oGet19","oGet20","oGet21","oSBtn1")

/*
Dados incluidos pelo Vendedor.
*/

Private cGet1  := Space(TamSx3("ZZ2_PEDIDO")[1])
Private dGet2  := Date()
Private cGet3  := Space(TamSx3("ZZ2_CODCLI")[1])
Private cGet3Lj:= Space(TamSx3("ZZ2_LOJACL")[1])
Private cGet4  := Space(TamSx3("ZZ2_NOMCLI")[1])
Private cGet5  := Space(TamSx3("ZZ2_VEND1")[1])
Private cGet6  := Space(TamSx3("ZZ2_NOMVEN")[1])
Private cGet7  := Space(TamSx3("ZZ2_TRANSP")[1])
Private cGet8  := Space(TamSx3("ZZ2_NOMTRA")[1])
Private dGet9  := Date()
Private cGet10 := Time()
Private dGet19 := Space(TamSx3("ZZ2_DTEMISS")[1])
Private dGet20 := Space(TamSx3("ZZ2_DTVEN")[1])
Private dGet21 := Space(TamSx3("ZZ2_DTFABR")[1])

/*
Dados incluidos pela Recepcao.
*/
Private cGet11 := Space(TamSx3("ZZ2_NRDOC")[1])
Private cGet12 := Space(TamSx3("ZZ2_NOMRES")[1])
Private cGet13 := Space(TamSx3("ZZ2_PLACA")[1])
Private dGet14 := Ctod('')
Private cGet15 := Space(TamSx3("ZZ2_HRENTR")[1])
Private dGet16 := Ctod('')
Private cGet17 := Space(TamSx3("ZZ2_HRSAID")[1])
Private cGet18 := Space(TamSx3("ZZ2_OBS")[1])

/*
MarkBrowse
*/
Private aIndexZZ2   := {}
Private cFilterZZ2  := ""
Private bFiltraBrw  := {|| Nil}
Private cMarca      := GetMark(,"ZZ2","ZZ2_OK")
Private lInverte    := .F.
Private _aHeader    := {}
Private _l1Vez      := .T.
Private _lRecep     := .F.

cFilterZZ2  := " ZZ2_FILIAL=='"+xFilial("ZZ2")+"' "
bFiltraBrw := {|| FilBrowse("ZZ2",@aIndexZZ2,@cFilterZZ2) }
Eval(bFiltraBrw)
ZZ2->(DbSetOrder(1))
ZZ2->(DbGotop())

_CriaSXB() //Cria SXB especifico

/*
_aHeader  := {{ "ZZ2_OK"            ,, "  "                ,"@!"},;
{ "ZZ2_PEDIDO"        ,, "Pedido"            ,"@!"},;
{ "ZZ2_DTCOLE"        ,, "Data Coleta"       ,"@R 99/99/9999"},;
{ "ZZ2_CODCLI"        ,, "Cod.Cliente"       ,"@!"},;
{ "ZZ2_LOJACL"        ,, "Loja Cliente"      ,"@!"},;
{ "ZZ2_NOMCLI"        ,, "Nome Cliente"      ,"@!"},;
{ "ZZ2_VEND1"         ,, "Vendedor"          ,"@!"},;
{ "ZZ2_NOMVEN"        ,, "Nom.Vendedor"      ,"@!"},;
{ "ZZ2_TRANSP"        ,, "Transportad."      ,"@!"},;
{ "ZZ2_NOMTRA"        ,, "Nom. Transp."      ,"@!"},;
{ "ZZ2_DTINCL"        ,, "Dt. Inclusao"      ,"@R 99/99/9999"},;
{ "ZZ2_HRINCL"        ,, "Hora Inclus."      ,"@R 99:99:99"},;
{ "ZZ2_NRDOC"         ,, "Nr. Doc."          ,"@!"},;
{ "ZZ2_NOMRES"        ,, "Nome Resp."        ,"@!"},;
{ "ZZ2_PLACA"         ,, "Placa"             ,"@!"},;
{ "ZZ2_DTENTR"        ,, "Dt. Entrada"       ,"@R 99/99/9999"},;
{ "ZZ2_HRENTR"        ,, "Hora Entrada"      ,"@R 99:99:99"},;
{ "ZZ2_DTSAID"        ,, "Dt. Saida"         ,"@R 99/99/9999"},;
{ "ZZ2_HRSAID"        ,, "Hora Saida"        ,"@R 99:99:99"},;
{ "ZZ2_OBS"           ,, "Observacao"        ,"@!"}}
*/
  

 If   __cuserid = '000000' 
		 If Msgyesno('incluir')
 			_lRecepcao:= .f. 
 		 else
 			_lRecepcao:= .t. 
 		EndIf
 EndIf


//Monta o vetor a rotina
aAdd(aRotina, { "Pesquisar"   , "AxPesqui", 0, 1} )		//Pesquisa
aAdd(aRotina, { "Visualizar" , "U_FATI46V", 0, 2} )	    	//Visualiza
If !_lRecepcao
	aAdd(aRotina, { "Incluir"    , "U_FATI46A", 0, 3} )	//Inclusao
Endif

If _lRecepcao
	aAdd(aRotina, { "Alterar"    , "U_FATI46B", 0, 4} )	//Alterar
Endif

If !_lRecepcao
	aAdd(aRotina, { "Excluir"    , "U_FATI46C", 0, 5} )	//Excluir
Endif

aAdd(aRotina, { "Legenda"    , "U_FATI46D", 0 , 0 , 0 , .F.} ) //Legenda

If !_lRecepcao
	mBrowse( 6, 1,22,75,"ZZ2",,,,,,aCores) //Funcao mBrowse
Else
	
	//Antes de carregar a MarkBrow limpa todos os registros. Necessario porque ao carregar a MarkBrow as funcoes U_FATI46F3() e U_FATI46F4() sao disparadas.
	FATI46F5()
	
	MarkBrow("ZZ2","ZZ2_OK", "ZZ2->ZZ2_DTSAID <> Ctod('') .OR. Alltrim(ZZ2->ZZ2_OBS) <> ''",/*_aHeader*/,lInverte,cMarca,/*U_FATI46F3()*/,,,,U_FATI46F4() )
	
	//Obs: Pedidos com a DATA DE SAIDA ou OBSERVACAO preenchidos nao serah permitido marcar. Legenda = VERMELHO
	
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATI46A   º Autor ³ SAULO CARVALHO     º Data ³  22/01/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Inclusao dos pedidos para a coleta.                         º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³STECK                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FATI46A(cAlias, nRecNo, nOpc)

Local _nFinalizar := 0
Local _lWhen1 := .T.
Local _lWhen2 := .F.

/*
Dados incluidos pelo Vendedor.
*/
cGet1  := Space(TamSx3("ZZ2_PEDIDO")[1])
dGet2  := Date()
cGet3  := Space(TamSx3("ZZ2_CODCLI")[1])
cGet3Lj:= Space(TamSx3("ZZ2_LOJACL")[1])
cGet4  := Space(TamSx3("ZZ2_NOMCLI")[1])
cGet5  := Space(TamSx3("ZZ2_VEND1")[1])
cGet6  := Space(TamSx3("ZZ2_NOMVEN")[1])
cGet7  := Space(TamSx3("ZZ2_TRANSP")[1])
cGet8  := Space(TamSx3("ZZ2_NOMTRA")[1])
dGet9  := Date()
cGet10 := Time()
dGet19 := Space(TamSx3("ZZ2_DTEMIS")[1])
dGet20 := Space(TamSx3("ZZ2_DTVEN")[1])
dGet21 := Space(TamSx3("ZZ2_DTFABR")[1])

/*
Dados incluidos pela Recepcao.
*/
cGet11 := Space(TamSx3("ZZ2_NRDOC")[1])
cGet12 := Space(TamSx3("ZZ2_NOMRES")[1])
cGet13 := Space(TamSx3("ZZ2_PLACA")[1])
dGet14 := Ctod('')
cGet15 := Space(TamSx3("ZZ2_HRENTR")[1])
dGet16 := Ctod('')
cGet17 := Space(TamSx3("ZZ2_HRSAID")[1])
cGet18 := Space(TamSx3("ZZ2_OBS")[1])

_nFinalizar := FATI46F0(cAlias, nRecNo, nOpc, _lWhen1, _lWhen2) //Tela Principal

If _nFinalizar == 1
	//Inclusao do pedido para a coleta.
	ZZ2->(DbSelectArea('ZZ2'))
	ZZ2->(DbSetOrder(1))
	If !ZZ2->(DbSeek(xFilial('ZZ2') + cGet1 + Dtos(dGet2),.F.))
		ZZ2->(Reclock('ZZ2',.T.))
		ZZ2->ZZ2_FILIAL := xFilial('ZZ2')
		ZZ2->ZZ2_PEDIDO := cGet1
		ZZ2->ZZ2_DTCOLE := dGet2
		ZZ2->ZZ2_CODCLI := cGet3
		ZZ2->ZZ2_LOJACL := cGet3Lj
		ZZ2->ZZ2_NOMCLI := cGet4 //Incluído João Victor em 03/04/2013
		ZZ2->ZZ2_VEND1  := cGet5
		ZZ2->ZZ2_NOMVEN := cGet6 //Incluído João Victor em 03/04/2013
		ZZ2->ZZ2_TRANSP := cGet7
		ZZ2->ZZ2_NOMTRA := cGet8 //Incluído João Victor em 03/04/2013
		ZZ2->ZZ2_DTINCL := Date()
		ZZ2->ZZ2_HRINCL := Time()
		ZZ2->ZZ2_DTEMIS := dGet19
		ZZ2->ZZ2_DTVEN  := dGet20
		ZZ2->ZZ2_DTFABR := dGet21
		ZZ2->(MsUnlock())
	Else
		MsgBox('O Pedido de Venda '+ZZ2->ZZ2_PEDIDO+' já foi incluido para coleta em '+Dtoc(ZZ2->ZZ2_DTCOLE)+'.','Atenção','STOP')
	Endif
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATI46B   º Autor ³ SAULO CARVALHO     º Data ³  22/01/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Alteracao dos pedidos para a coleta.                        º±±
±±º          ³Somente a recepcao que faz a alteracao.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³STECK                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FATI46B(cAlias, nRecNo, nOpc)

Local _nFinalizar := 0
Local _lWhen1 := .F.                       //Vendedores -> Nao pode alterar, se não houve nenhum apontamento da recepção sera permitido excluir as inclusoes.
Local _lWhen2 := .T.                      //Recepcao   -> Identificação do responsável que irá retirar os materiais.

/*
Dados incluidos pelo Vendedor.
*/
cGet1  := ZZ2->ZZ2_PEDIDO
dGet2  := ZZ2->ZZ2_DTCOLE
cGet3  := ZZ2->ZZ2_CODCLI
cGet3Lj:= ZZ2->ZZ2_LOJACL
cGet4  := Posicione("SA1",1,xFilial("SA1") + ZZ2->(ZZ2_CODCLI + ZZ2_LOJACL),"A1_NOME") //Nome do cliente
cGet5  := ZZ2->ZZ2_VEND1
cGet6  := Posicione("SA3",1,xFilial("SA3") + ZZ2->ZZ2_VEND1,"A3_NOME") //Nome do vendedor
cGet7  := ZZ2->ZZ2_TRANSP
cGet8  := Posicione("SA4",1,xFilial("SA4") + ZZ2->ZZ2_TRANSP,"A4_NOME") //Nome da transportadora
dGet9  := ZZ2->ZZ2_DTINCL
cGet10 := ZZ2->ZZ2_HRINCL
dGet19 := Posicione("SC5",1,xFilial("SC5") + ZZ2->ZZ2_PEDIDO,"C5_EMISSAO") //Data da Emissao do Pedido de Venda
dGet20 := Posicione("SC5",1,xFilial("SC5") + ZZ2->ZZ2_PEDIDO,"C5_XDTEN") //Data de Entrega do Comercial do Pedido de Venda
dGet21 := Posicione("SC5",1,xFilial("SC5") + ZZ2->ZZ2_PEDIDO,"C5_XDTFABR") //Data de Entrega de F[abrica do Pedido de Venda

/*
Dados incluidos pela Recepcao.
*/
cGet11 := ZZ2->ZZ2_NRDOC
cGet12 := ZZ2->ZZ2_NOMRES
cGet13 := ZZ2->ZZ2_PLACA
dGet14 := IIf(Empty(ZZ2->ZZ2_DTENTR), Date(), ZZ2->ZZ2_DTENTR)
cGet15 := IIf(Empty(ZZ2->ZZ2_HRENTR), Time(), ZZ2->ZZ2_HRENTR)
dGet16 := ZZ2->ZZ2_DTSAID
cGet17 := ZZ2->ZZ2_HRSAID
cGet18 := ZZ2->ZZ2_OBS

_nFinalizar := FATI46F0A(cAlias, nRecNo, nOpc, _lWhen1, _lWhen2) //Tela Principal da alteracao

If _nFinalizar == 1
	
	If Empty(cGet11) .OR. Empty(cGet12) .OR. Empty(cGet13) .OR. Empty(dGet14) .OR. Empty(cGet15)
		MsgBox('Há campos obrigatórios que não foram preenchidos.','Atenção','INFO')
		Return
	EndIf
	If _lRecep
		If Ctod('')=dGet16 .And. Empty(alltrim(cGet17)) .And. Empty(alltrim(cGet18))
			U_STreMAIL(cGet1)
		EndIf
	EndIf
	ZZ2->(DbGotop())
	While ZZ2->(!Eof()) .AND. ZZ2->ZZ2_FILIAL == xFilial('ZZ2')
		
		//Alteracao somente os pedidos marcados.
		If ZZ2->ZZ2_OK == cMarca //ZZ2->(IsMark('ZZ2_OK', cMarca))
			ZZ2->(Reclock('ZZ2',.F.))
			ZZ2->ZZ2_NRDOC  := cGet11
			ZZ2->ZZ2_NOMRES := cGet12
			ZZ2->ZZ2_PLACA  := cGet13
			ZZ2->ZZ2_DTENTR := dGet14
			ZZ2->ZZ2_HRENTR := cGet15
			ZZ2->ZZ2_DTSAID := dGet16
			ZZ2->ZZ2_HRSAID := cGet17
			ZZ2->ZZ2_OBS    := cGet18
			ZZ2->(MsUnlock())
		Endif
		
		ZZ2->(DbSkip())
	End
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATI46C   º Autor ³ SAULO CARVALHO     º Data ³  22/01/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Exclusao dos pedidos para a coleta.                         º±±
±±º          ³Se não houve nenhum apontamento da recepção sera permitido  º±±
±±º          ³que o vendedor faca a exclusao.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³STECK                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FATI46C(cAlias, nRecNo, nOpc)

Local _nFinalizar := 0
Local _lWhen1 := .F.
Local _lWhen2 := .F.
Local nOpc    := 5 //Exclusao

/*
Dados incluidos pelo Vendedor.
*/
cGet1  := ZZ2->ZZ2_PEDIDO
dGet2  := ZZ2->ZZ2_DTCOLE
cGet3  := ZZ2->ZZ2_CODCLI
cGet3Lj:= ZZ2->ZZ2_LOJACL
cGet4  := Posicione("SA1",1,xFilial("SA1") + ZZ2->(ZZ2_CODCLI + ZZ2_LOJACL),"A1_NOME") //Nome do cliente
cGet5  := ZZ2->ZZ2_VEND1
cGet6  := Posicione("SA3",1,xFilial("SA3") + ZZ2->ZZ2_VEND1,"A3_NOME") //Nome do vendedor
cGet7  := ZZ2->ZZ2_TRANSP
cGet8  := Posicione("SA4",1,xFilial("SA4") + ZZ2->ZZ2_TRANSP,"A4_NOME") //Nome da transportadora
dGet9  := ZZ2->ZZ2_DTINCL
cGet10 := ZZ2->ZZ2_HRINCL
dGet19 := Posicione("SC5",1,xFilial("SC5") + ZZ2->ZZ2_PEDIDO,"C5_EMISSAO") //Data da Emissao do Pedido de Venda
dGet20 := Posicione("SC5",1,xFilial("SC5") + ZZ2->ZZ2_PEDIDO,"C5_XDTEN") //Data de Entrega do Comercial do Pedido de Venda
dGet21 := Posicione("SC5",1,xFilial("SC5") + ZZ2->ZZ2_PEDIDO,"C5_XDTFABR") //Data de Entrega de F[abrica do Pedido de Venda


/*
Dados incluidos pela Recepcao.
*/
cGet11 := ZZ2->ZZ2_NRDOC
cGet12 := ZZ2->ZZ2_NOMRES
cGet13 := ZZ2->ZZ2_PLACA
dGet14 := ZZ2->ZZ2_DTENTR
cGet15 := ZZ2->ZZ2_HRENTR
dGet16 := ZZ2->ZZ2_DTSAID
cGet17 := ZZ2->ZZ2_HRSAID
cGet18 := ZZ2->ZZ2_OBS

_nFinalizar := FATI46F0(cAlias, nRecNo, nOpc, _lWhen1, _lWhen2) //Tela Principal

If _nFinalizar == 1
	
	If Empty(ZZ2->ZZ2_NRDOC) .AND.  Empty(ZZ2->ZZ2_NOMRES) .AND. Empty(ZZ2->ZZ2_PLACA) .AND. Empty(ZZ2->ZZ2_DTENTR);
		.AND. Empty(ZZ2->ZZ2_HRENTR) .AND. Empty(ZZ2->ZZ2_DTSAID) .AND. Empty(ZZ2->ZZ2_HRSAID) .AND. Empty(ZZ2->ZZ2_OBS)
		//Exclusao do pedido.
		ZZ2->(Reclock('ZZ2',.F.))
		ZZ2->(DbDelete())
		ZZ2->(MsUnlock())
	Else
		Msgbox('Não será permitido a exclusão porque a recepção já apontou a coleta.','Atenção','STOP')
	Endif
EndIf

Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³FATI46D  ³ Autores ³ SAULO CARVALHO         ³ Data ³22/01/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³Legenda.                                                      ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FATI46D()

Local aCores := {}

If !_lRecepcao
	aCores := {{'ENABLE','LIBERADO PARA COLETA' },;  //LIBERADO PARA COLETA (O vendedor incluiu o pedido).
	{ 'BR_AZUL','CLIENTE COLETANDO'},; //CLIENTE COLETANDO (O cliente está na Steck e a recepção já apontou os dados do responsável).
	{ 'DISABLE','FINALIZADO'},; 			//COLETADO (A recepção informou a data de saída) -Alterado em 02/04/2013 por João Victor conforme solicitação de Tatiana Neves
	{ 'BR_PRETO','NÃO COLETADO'}}	    //NÃO COLETADO (Não tem data de saída e tem observação. Ex: Transportadora não aguardou).
	
Else
	aCores := {{'ENABLE','LIBERADO' },;  //LIBERADO PARA APONTAMENTO
	{ 'DISABLE','FINALIZADO'}} 	//COLETADO (A recepção informou a data de saída) OU NÃO COLETADO (Não tem data de saída e tem observação. Ex: Transportadora não aguardou).
Endif

BrwLegenda(cCadastro,'',aCores)

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATI46V   º Autor ³ SAULO CARVALHO     º Data ³  06/03/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Visualizacao.                                               º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³STECK                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FATI46V(cAlias, nRecNo, nOpc)

Local _nFinalizar := 0
Local _lWhen1 := .F.
Local _lWhen2 := .F.
Local nOpc    := 2 //Visualizacao

/*
Dados incluidos pelo Vendedor.
*/
cGet1  := ZZ2->ZZ2_PEDIDO
dGet2  := ZZ2->ZZ2_DTCOLE
cGet3  := ZZ2->ZZ2_CODCLI
cGet3Lj:= ZZ2->ZZ2_LOJACL
cGet4  := Posicione("SA1",1,xFilial("SA1") + ZZ2->(ZZ2_CODCLI + ZZ2_LOJACL),"A1_NOME") //Nome do cliente
cGet5  := ZZ2->ZZ2_VEND1
cGet6  := Posicione("SA3",1,xFilial("SA3") + ZZ2->ZZ2_VEND1,"A3_NOME") //Nome do vendedor
cGet7  := ZZ2->ZZ2_TRANSP
cGet8  := Posicione("SA4",1,xFilial("SA4") + ZZ2->ZZ2_TRANSP,"A4_NOME") //Nome da transportadora
dGet9  := ZZ2->ZZ2_DTINCL
cGet10 := ZZ2->ZZ2_HRINCL
dGet19 := Posicione("SC5",1,xFilial("SC5") + ZZ2->ZZ2_PEDIDO,"C5_EMISSAO") //Data da Emissao do Pedido de Venda
dGet20 := Posicione("SC5",1,xFilial("SC5") + ZZ2->ZZ2_PEDIDO,"C5_XDTEN") //Data de Entrega do Comercial do Pedido de Venda
dGet21 := Posicione("SC5",1,xFilial("SC5") + ZZ2->ZZ2_PEDIDO,"C5_XDTFABR") //Data de Entrega de F[abrica do Pedido de Venda

/*
Dados incluidos pela Recepcao.
*/
cGet11 := ZZ2->ZZ2_NRDOC
cGet12 := ZZ2->ZZ2_NOMRES
cGet13 := ZZ2->ZZ2_PLACA
dGet14 := ZZ2->ZZ2_DTENTR
cGet15 := ZZ2->ZZ2_HRENTR
dGet16 := ZZ2->ZZ2_DTSAID
cGet17 := ZZ2->ZZ2_HRSAID
cGet18 := ZZ2->ZZ2_OBS

_nFinalizar := FATI46F0(cAlias, nRecNo, nOpc, _lWhen1, _lWhen2) //Tela Principal

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³FATI46F0 ³ Autores ³ SAULO CARVALHO         ³ Data ³22/01/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³Tela Principal.                                               ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FATI46F0(cAlias, nRecNo, nOpc, _lWhen1, _lWhen2)

Local _nFinalizar := 0

/*
Dados incluidos pelo Vendedor.
*/
oDlg2      := MSDialog():New( 072,320,660,1015,"Pedido de Venda Retira",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 012,008,140,332,"Dados do Pedido de Vendas:",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1      := TSay():New( 028,016,{||"Pedido:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet1      := TGet():New( 024,060,{|u| If(PCount()>0,cGet1:=u,cGet1)},oGrp1,060,008,'@!',{|u| Vazio() .OR. (ExistCpo("SC5") .AND. FATI46F2(nOpc)) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen1 .AND. nOpc==3},.F.,.F.,{|u| },.F.,.F.,"SC5S46","cGet1",,)


oSay16     := TSay():New( 028,132,{||"Emissão:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet19     := TGet():New( 024,170,{|u| If(PCount()>0,dGet19:=u,dGet19)},oGrp1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| .F.},.F.,.F.,,.F.,.F.,"","dGet19",,)

oSay17     := TSay():New( 108,132,{||"Dt. Vendas:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet20     := TGet():New( 104,170,{|u| If(PCount()>0,dGet20:=u,dGet20)},oGrp1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| .F.},.F.,.F.,,.F.,.F.,"","dGet20",,)

oSay18     := TSay():New( 124,132,{||"Dt. Fábrica:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet21      := TGet():New( 120,170,{|u| If(PCount()>0,dGet21:=u,dGet21)},oGrp1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| .F.},.F.,.F.,,.F.,.F.,"","dGet21",,)




oSay2      := TSay():New( 044,016,{||"Data da Coleta:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGet2      := TGet():New( 040,060,{|u| If(PCount()>0,dGet2:=u,dGet2)},oGrp1,060,008,'',{|u| dGet2 >= Date() .AND. !Empty(dGet2)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen1},.F.,.F.,,.F.,.F.,"","dGet2",,)

//Campo Visual
oSay3      := TSay():New( 060,016,{||"Cliente:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet3      := TGet():New( 056,060,{|u| If(PCount()>0,cGet3:=u,cGet3)},oGrp1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| .F.},.F.,.F.,,.F.,.F.,"","cGet3",,)
oGet4      := TGet():New( 056,132,{|u| If(PCount()>0,cGet4:=u,cGet4)},oGrp1,176,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| .F.},.F.,.F.,,.F.,.F.,"","cGet4",,)

//Campo Visual
oSay4      := TSay():New( 076,016,{||"Vendedor 2:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet5      := TGet():New( 072,060,{|u| If(PCount()>0,cGet5:=u,cGet5)},oGrp1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| .F.},.F.,.F.,,.F.,.F.,"","cGet5",,)
oGet6      := TGet():New( 072,132,{|u| If(PCount()>0,cGet6:=u,cGet6)},oGrp1,176,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| .F.},.F.,.F.,,.F.,.F.,"","cGet6",,)

//Campo Visual
oSay5      := TSay():New( 092,016,{||"Transportadora:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGet7      := TGet():New( 088,060,{|u| If(PCount()>0,cGet7:=u,cGet7)},oGrp1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| .F.},.F.,.F.,,.F.,.F.,"","cGet7",,)
oGet8      := TGet():New( 088,132,{|u| If(PCount()>0,cGet8:=u,cGet8)},oGrp1,176,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| .F.},.F.,.F.,,.F.,.F.,"","cGet8",,)

//Campo Visual
oSay6      := TSay():New( 108,016,{||"Data Inclusão:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGet9      := TGet():New( 104,060,{|u| If(PCount()>0,dGet9:=u,dGet9)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| .F.},.F.,.F.,,.F.,.F.,"","dGet9",,)

//Campo Visual
oSay7      := TSay():New( 124,016,{||"Hora Inclusão:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGet10     := TGet():New( 120,060,{|u| If(PCount()>0,cGet10:=u,cGet10)},oGrp1,060,008,'@R 99:99:99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| .F.},.F.,.F.,,.F.,.F.,"","cGet10",,)



/*
Dados que a manutencao sera feita exclusivamente pela Recepcao.
*/
oGrp2      := TGroup():New( 152,008,260,332,"Dados do responsável pela coleta:",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay8      := TSay():New( 168,016,{||"No Documento:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGet11     := TGet():New( 164,064,{|u| If(PCount()>0,cGet11:=u,cGet11)},oGrp2,072,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","cGet11",,)

oSay9      := TSay():New( 184,016,{||"Nome:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet12     := TGet():New( 180,064,{|u| If(PCount()>0,cGet12:=u,cGet12)},oGrp2,176,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","cGet12",,)

oSay10     := TSay():New( 200,016,{||"Placa do Veículo:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGet13     := TGet():New( 196,064,{|u| If(PCount()>0,cGet13:=u,cGet13)},oGrp2,060,008,'@R AAA-9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","cGet13",,)

oSay11     := TSay():New( 216,016,{||"Data Entrada:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGet14     := TGet():New( 212,064,{|u| If(PCount()>0,dGet14:=u,dGet14)},oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","dGet14",,)

oSay12     := TSay():New( 216,144,{||"Hora Entrada:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oGet15     := TGet():New( 212,184,{|u| If(PCount()>0,cGet15:=u,cGet15)},oGrp2,060,008,'@R 99:99:99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","cGet15",,)

oSay13     := TSay():New( 232,016,{||"Data Saida:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet16     := TGet():New( 228,064,{|u| If(PCount()>0,dGet16:=u,dGet16)},oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","dGet16",,)

oSay14     := TSay():New( 232,144,{||"Hora Saida:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet17     := TGet():New( 228,184,{|u| If(PCount()>0,cGet17:=u,cGet17)},oGrp2,060,008,'@R 99:99:99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","cGet17",,)

oSay15     := TSay():New( 248,016,{||"Observação:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet18     := TGet():New( 244,064,{|u| If(PCount()>0,cGet18:=u,cGet18)},oGrp2,180,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","cGet18",,)

If nOpc == 3 //Inclusao
	oSBtn1 := TButton():New( 268,116,"&Confirmar",oDlg2,{|| (_nFinalizar := 1,oDlg2:End())},037,012,,,,.T.,,"",,{|| !Empty(cGet1) .AND. !Empty(dGet2) },,.F. )
ElseIf nOpc == 5 //Exclusao
	oSBtn1 := TButton():New( 268,116,"&Confirmar",oDlg2,{|| (_nFinalizar := 1,oDlg2:End())},037,012,,,,.T.,,"",,{|| .T. },,.F. )
Endif

oSBtn2 := TButton():New( 268,204,"&Fechar",oDlg2,{|| oDlg2:End()},037,012,,,,.T.,,"",,,,.F. )

oDlg2:Activate(,,,.T.)

Return(_nFinalizar)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³FATI46F0A³ Autores ³ SAULO CARVALHO         ³ Data ³22/01/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³Tela Principal da alteracao.                                  ³±±
±±³           ³A alteracao eh feita somente pela recepcao.                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FATI46F0A(cAlias, nRecNo, nOpc, _lWhen1, _lWhen2)

Local _nFinalizar := 0
_lRecep:=.t.
/*
Dados que a manutencao sera feita exclusivamente pela Recepcao.
*/
oDlg2      := MSDialog():New( 072,320,660,1015,"Pedido de Venda Retira",,,.F.,,,,,,.T.,,,.T. )
oGrp2      := TGroup():New( 012,008,140,332,"Dados do responsável pela coleta:",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay8a     := TSay():New( 028,014,{||"*"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,044,008)
oSay8      := TSay():New( 028,016,{||"No Documento:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGet11     := TGet():New( 024,060,{|u| If(PCount()>0,cGet11:=u,cGet11)},oGrp2,072,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","cGet11",,)

oSay9a     := TSay():New( 044,014,{||"*"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,044,008)
oSay9      := TSay():New( 044,016,{||"Nome:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet12     := TGet():New( 040,060,{|u| If(PCount()>0,cGet12:=u,cGet12)},oGrp2,176,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","cGet12",,)

oSay10a    := TSay():New( 060,014,{||"*"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,044,008)
oSay10     := TSay():New( 060,016,{||"Placa do Veículo:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGet13     := TGet():New( 056,060,{|u| If(PCount()>0,cGet13:=u,cGet13)},oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","cGet13",,)

oSay11a    := TSay():New( 076,014,{||"*"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,044,008)
oSay11     := TSay():New( 076,016,{||"Data Entrada:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGet14     := TGet():New( 072,060,{|u| If(PCount()>0,dGet14:=u,dGet14)},oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","dGet14",,)

oSay12a    := TSay():New( 072,130,{||"*"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,044,008)
oSay12     := TSay():New( 072,132,{||"Hora Entrada:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oGet15     := TGet():New( 072,184,{|u| If(PCount()>0,cGet15:=u,cGet15)},oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","cGet15",,)

oSay13     := TSay():New( 092,016,{||"Data Saida:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet16     := TGet():New( 088,060,{|u| If(PCount()>0,dGet16:=u,dGet16)},oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","dGet16",,)

oSay14     := TSay():New( 088,132,{||"Hora Saida:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet17     := TGet():New( 088,184,{|u| If(PCount()>0,cGet17:=u,cGet17)},oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","cGet17",,)

oSay15     := TSay():New( 108,016,{||"Observação:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet18     := TGet():New( 104,060,{|u| If(PCount()>0,cGet18:=u,cGet18)},oGrp2,180,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|u| _lWhen2},.F.,.F.,,.F.,.F.,"","cGet18",,)

oSBtn1 := TButton():New( 268,116,"&Confirmar",oDlg2,{|| (_nFinalizar := 1,oDlg2:End())},037,012,,,,.T.,,"",,{|| .T. },,.F. )

oSBtn2 := TButton():New( 268,204,"&Fechar",oDlg2,{|| oDlg2:End()},037,012,,,,.T.,,"",,,,.F. )

oDlg2:Activate(,,,.T.)

Return(_nFinalizar)




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³FATI46F1 ³ Autores ³ SAULO CARVALHO         ³ Data ³22/01/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³Funcao para validar se o usuario pertence ao grupo RECEPCAO.  ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FATI46F1

Local _aGrupos 	:= {}
Local _cUser   	:= __cUserID //Substr(cUsuario,7,15)
Local _lRet     := .F.
Local _nx       := 0

//Verifica se o usuario pertence ao grupo RECEPCAO
PswOrder(2)
If PswSeek(_cUser)
	_aGrupos  := PswRet(1)[1][10] //Retorna o codigo do grupo de usuario
EndIf

For _nx := 1 To Len(_aGrupos)    // O usuario pode pertencer a outros grupos.
	If _aGrupos[_nx] $ SuperGetMv("ST_GRPRECE",.F.,'000001/000019/000078') //Grupo RECEPCAO
		_lRet := .T.
		Exit
	Endif
Next _nx

Return(_lRet)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³FATI46F2 ³ Autores ³ SAULO CARVALHO         ³ Data ³22/01/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³Funcao para atualizar variaveis e dar refresh.                ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FATI46F2(nOpc)

If !Empty(cGet1) .AND. nOpc == 3 //Numero do Pedido de Venda e inclusao
	SC5->(DbSelectArea('SC5'))
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial('SC5')+cGet1,.F.))
		cGet3   := SC5->C5_CLIENTE
		cGet3Lj := SC5->C5_LOJACLI
		cGet4   := Posicione("SA1",1,xFilial("SA1") + SC5->(C5_CLIENTE + C5_LOJACLI),"A1_NOME") //Nome do cliente
		cGet5   := SC5->C5_VEND2
		cGet6   := Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND2,"A3_NOME") //Nome do vendedor
		cGet7   := SC5->C5_TRANSP
		cGet8   := Posicione("SA4",1,xFilial("SA4") + SC5->C5_TRANSP,"A4_NOME") //Nome da transportadora
		dGet19  := SC5->C5_EMISSAO //Data da Emissao do Pedido de Venda
		dGet20  := SC5->C5_XDTEN //Data de Entrega do Comercial do Pedido de Venda
		dGet21  := SC5->C5_XDTFABR //Data de Entrega de F[abrica do Pedido de Venda
		
		
		oGet3:Refresh()
		oGet4:Refresh()
		oGet5:Refresh()
		oGet6:Refresh()
		oGet7:Refresh()
		oGet8:Refresh()
	Endif
Endif

Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATI46F3   ³ Autor ³SAULO CARVALHO        ³ Data ³22/01/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Marca / desmarca TODAS posicoes no browse.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FATI46F3

Local aAreaAnt  := GetArea()
Local lMarca    := .F.

DbSelectArea('ZZ2')
DbSetOrder(1)
ZZ2->(DbGotop())
While ZZ2->(!Eof()) .AND. ZZ2->ZZ2_FILIAL == xFilial('ZZ2')
	
	//Nao marca/desmarca se atender essa condicao
	If ZZ2->ZZ2_DTSAID <> Ctod('') .OR. Alltrim(ZZ2->ZZ2_OBS) <> ''
		ZZ2->(DbSkip())
		Loop
	Endif
	
	lMarca := (ZZ2->ZZ2_OK == cMarca)
	
	RecLock("ZZ2",.F.)
	ZZ2->ZZ2_OK := If(lMarca,Space(Len(ZZ2->ZZ2_OK)),cMarca )
	MsUnLock()
	
	ZZ2->(DbSkip())
End

RestArea(aAreaAnt)
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATI46F4   ³ Autor ³SAULO CARVALHO        ³ Data ³22/01/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Marca / desmarca UMA posicao no browse.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FATI46F4

Local aAreaAnt  := GetArea()

If _l1Vez
	_l1Vez := .F.
	RestArea(aAreaAnt)
	Return .T.
Endif


DbSelectArea('ZZ2')
If ZZ2->ZZ2_OK == cMarca //ZZ2->(IsMark('ZZ2_OK', cMarca))
	Reclock('ZZ2', .F.)
	ZZ2->ZZ2_OK := Space(Len(ZZ2->ZZ2_OK))
	MsUnlock()
Else
	Reclock('ZZ2', .F.)
	ZZ2->ZZ2_OK := cMarca
	MsUnlock()
EndIf

RestArea(aAreaAnt)
Return .T.




/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FATI46F5   ³ Autor ³   SAULO CARVALHO    ³ Data ³22/01/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Limpa todos os registros da MarkBrowse()                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FATI46F5

Local aAreaAnt  := GetArea()

ZZ2->(DbSetOrder(1))
ZZ2->(DbGotop())
While ZZ2->(!Eof()) .AND. ZZ2->ZZ2_FILIAL == xFilial('ZZ2')
	
	//Nao marca/desmarca se atender essa condicao
	If ZZ2->ZZ2_DTSAID <> Ctod('') .OR. Alltrim(ZZ2->ZZ2_OBS) <> ''
		ZZ2->(DbSkip())
		Loop
	Endif
	
	RecLock('ZZ2',.F.)
	ZZ2->ZZ2_OK := Space(Len(ZZ2->ZZ2_OK))
	MsUnLock()
	
	ZZ2->(DbSkip())
End

RestArea(aAreaAnt)

Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FATI46F6   ³ Autor ³   SAULO CARVALHO    ³ Data ³22/01/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorno o status do pedido para a Recepcao.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FATI46F6

Local _cStatus := ""

If Empty(ZZ2->ZZ2_DTENTR) .AND. Empty(ZZ2->ZZ2_DTSAID) .AND. Empty(ZZ2->ZZ2_OBS)
	_cStatus := "LIBERADO" //LEGENDA VERDE     -> LIBERADO PARA COLETA (O vendedor incluiu o pedido).
ElseIf !Empty(ZZ2->ZZ2_DTENTR) .AND. Empty(ZZ2->ZZ2_DTSAID) .AND. Empty(ZZ2->ZZ2_OBS)
	_cStatus := "COLETANDO" //LEGENDA AZUL     -> CLIENTE COLETANDO (O cliente está na Steck e a recepção já apontou os dados do responsável).
ElseIf !Empty(ZZ2->ZZ2_DTSAID)
	_cStatus := "FINALIZADO" //LEGENDA VERMELHO  -> COLETADO (A recepção informou a data de saída)
ElseIf Empty(ZZ2->ZZ2_DTSAID) .AND. !Empty(ZZ2->ZZ2_OBS)
	_cStatus := "NAO COLETADO" //LEGENDA PRETO -> NAO COLETADO (Não tem data de saída e tem observação. Ex: Transportadora não aguardou).
Endif

Return(_cStatus)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ _CriaSXB ºAutor  ³ TOTVS              º Data ³  06/03/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criacao da consulta padrao para o pedido retira.           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _CriaSXB()
/* Removido - 18/05/2023 - Não executa mais Recklock na XB - Criar/alterar consultas no configurador
_cAlias := PADR("SC5S46",LEN(SXB->XB_ALIAS))
If !SXB->(DbSeek(_cAlias))
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "1"
	SXB->XB_SEQ 	:= "01"
	SXB->XB_COLUNA 	:= "DB"
	SXB->XB_DESCRI	:= "Pedido de Venda"
	SXB->XB_DESCSPA	:= SXB->XB_DESCRI
	SXB->XB_DESCENG	:= SXB->XB_DESCRI
	SXB->XB_CONTEM	:= "SC5"
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "2"
	SXB->XB_SEQ 	:= "01"
	SXB->XB_COLUNA 	:= "01"
	SXB->XB_DESCRI	:= "Numero"
	SXB->XB_DESCSPA	:= "Numero"
	SXB->XB_DESCENG	:= "Numero"
	SXB->XB_CONTEM	:= ""
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "2"
	SXB->XB_SEQ 	:= "02"
	SXB->XB_COLUNA 	:= "02"
	SXB->XB_DESCRI	:= "Emissao + Numero"
	SXB->XB_DESCSPA	:= "Emissao + Numero"
	SXB->XB_DESCENG	:= "Emissao + Numero"
	SXB->XB_CONTEM	:= ""
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "2"
	SXB->XB_SEQ 	:= "03"
	SXB->XB_COLUNA 	:= "03"
	SXB->XB_DESCRI	:= "Cod. Cliente + Numer"
	SXB->XB_DESCSPA	:= "Cod. Cliente + Numer"
	SXB->XB_DESCENG	:= "Cod. Cliente + Numer"
	SXB->XB_CONTEM	:= ""
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "4"
	SXB->XB_SEQ 	:= "01"
	SXB->XB_COLUNA 	:= "01"
	SXB->XB_DESCRI	:= "Numero"
	SXB->XB_DESCSPA	:= "Numero"
	SXB->XB_DESCENG	:= "Numero"
	SXB->XB_CONTEM	:= "C5_NUM"
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "4"
	SXB->XB_SEQ 	:= "01"
	SXB->XB_COLUNA 	:= "02"
	SXB->XB_DESCRI	:= "Cod. Cliente"
	SXB->XB_DESCSPA	:= "Cod. Cliente"
	SXB->XB_DESCENG	:= "Cod. Cliente"
	SXB->XB_CONTEM	:= "C5_CLIENTE"
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "4"
	SXB->XB_SEQ 	:= "01"
	SXB->XB_COLUNA 	:= "03"
	SXB->XB_DESCRI	:= "Loja"
	SXB->XB_DESCSPA	:= "Loja"
	SXB->XB_DESCENG	:= "Loja"
	SXB->XB_CONTEM	:= "C5_LOJACLI"
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "4"
	SXB->XB_SEQ 	:= "01"
	SXB->XB_COLUNA 	:= "04"
	SXB->XB_DESCRI	:= "Emissao"
	SXB->XB_DESCSPA	:= "Emissao"
	SXB->XB_DESCENG	:= "Emissao"
	SXB->XB_CONTEM	:= "C5_EMISSAO"
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "4"
	SXB->XB_SEQ 	:= "02"
	SXB->XB_COLUNA 	:= "05"
	SXB->XB_DESCRI	:= "Emissao"
	SXB->XB_DESCSPA	:= "Emissao"
	SXB->XB_DESCENG	:= "Emissao"
	SXB->XB_CONTEM	:= "C5_EMISSAO"
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "4"
	SXB->XB_SEQ 	:= "02"
	SXB->XB_COLUNA 	:= "06"
	SXB->XB_DESCRI	:= "Numero"
	SXB->XB_DESCSPA	:= "Numero"
	SXB->XB_DESCENG	:= "Numero"
	SXB->XB_CONTEM	:= "C5_NUM"
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "4"
	SXB->XB_SEQ 	:= "02"
	SXB->XB_COLUNA 	:= "07"
	SXB->XB_DESCRI	:= "Cod. Cliente"
	SXB->XB_DESCSPA	:= "Cod. Cliente"
	SXB->XB_DESCENG	:= "Cod. Cliente"
	SXB->XB_CONTEM	:= "C5_CLIENTE"
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "4"
	SXB->XB_SEQ 	:= "02"
	SXB->XB_COLUNA 	:= "08"
	SXB->XB_DESCRI	:= "Loja"
	SXB->XB_DESCSPA	:= "Loja"
	SXB->XB_DESCENG	:= "Loja"
	SXB->XB_CONTEM	:= "C5_LOJACLI"
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "4"
	SXB->XB_SEQ 	:= "03"
	SXB->XB_COLUNA 	:= "09"
	SXB->XB_DESCRI	:= "Cod. Cliente"
	SXB->XB_DESCSPA	:= "Cod. Cliente"
	SXB->XB_DESCENG	:= "Cod. Cliente"
	SXB->XB_CONTEM	:= "C5_CLIENTE"
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "4"
	SXB->XB_SEQ 	:= "03"
	SXB->XB_COLUNA 	:= "10"
	SXB->XB_DESCRI	:= "Numero"
	SXB->XB_DESCSPA	:= "Numero"
	SXB->XB_DESCENG	:= "Numero"
	SXB->XB_CONTEM	:= "C5_NUM"
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "4"
	SXB->XB_SEQ 	:= "03"
	SXB->XB_COLUNA 	:= "11"
	SXB->XB_DESCRI	:= "Emissao"
	SXB->XB_DESCSPA	:= "Emissao"
	SXB->XB_DESCENG	:= "Emissao"
	SXB->XB_CONTEM	:= "C5_EMISSAO"
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "5"
	SXB->XB_SEQ 	:= "01"
	SXB->XB_COLUNA 	:= ""
	SXB->XB_CONTEM	:= "SC5->C5_NUM"
	MsUnlock()
	
	RecLock("SXB",.T.)
	SXB->XB_ALIAS 	:= _cAlias
	SXB->XB_TIPO 	:= "6"
	SXB->XB_SEQ 	:= "01"
	SXB->XB_COLUNA 	:= ""
	SXB->XB_CONTEM	:= "!Empty(C5_LIBEROK).AND.Empty(C5_NOTA).AND. Empty(C5_BLQ) .AND. C5_XTIPO == '1' "
	MsUnlock()
	
Endif*/

Return Nil





User Function STreMAIL(_cPedido)
    
Local aArea		:= GetArea()
Local aCB7Area	:= CB7->(GetArea())
Local _cStaCb7	:= '' 
Local _cOrdCb7	:= '' 

DbSelectArea('CB7')
CB7->(DbSetorder(2))  
If CB7->(DbSeek(xFilial('CB7')+_cPedido))

	While CB7->(!Eof()) .And. xFilial("CB7")+_cPedido = CB7->(CB7_FILIAL+CB7_PEDIDO)
		If !Empty(Alltrim(CB7->CB7_ORDSEP))
		 _cStaCb7:=CB7->CB7_STATUS 
		 _cOrdCb7:=CB7->CB7_ORDSEP 
		EndIf
			CB7->(dbskip())
		Enddo  
		If !Empty(Alltrim(_cStaCb7))
		U_STRECMAIL(_cStaCb7,_cPedido,_cOrdCb7)		 
		EndIf
		

Else

	U_STRECMAIL('XX',_cPedido,_cOrdCb7)

EndIf

RestArea(aCB7Area)
RestArea(aArea)


Return()
                



/*====================================================================================\
|Programa  | STRECMAIL        | Autor | GIOVANI.ZAGO             | Data | 27/03/2013  |
|=====================================================================================|
|Descrição | STRECMAIL                                                                |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STRECMAIL                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*------------------------------------------------------------------* 
User Function STRECMAIL(_cStaCb7,_cPedido,_cOrdCb7)
//Static Function  StLibFinMail(_cObs,_cMot,_cName,_cDat,_cHora,_cEmail)
*------------------------------------------------------------------*

Local aArea 	:= GetArea()
Local _cFrom   := "protheus@steck.com.br"   //Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
Local _cAssunto:= 'Recepção - Cliente Retira ('+_cPedido+')'
Local cFuncSent:= "STRECMAIL"
Local _aMsg    := {}
Local i        := 0
Local cArq     := ""
Local cMsg     := ""
Local _nLin
Local _cCopia  := " recepcao.mrocha@steck.com.br""
Local cAttach  := ''
Local _cMot    := _cEmail  := " "  
       

//vanessa.aparecida@steck.com.br ; fernanda.galli@steck.com.br

 If   _cStaCb7 = '4'    // embalagem finalizada manda email para o faturamento 
_cEmail  := "vanessa.aparecida@steck.com.br ; fernanda.galli@steck.com.br"
_cMot:= 'Cliente Encontra-se na Steck - Pedido Aguarda Faturamento'   
 ElseIf _cStaCb7 = 'XX' //sem ordem de separação manda email para o fabio 
_cEmail  := "simone.mara@steck.com.br;jefferson.puglia@steck.com.br; leandro.nobre@steck.com.br" 
_cMot:= 'Cliente Encontra-se na Steck - Pedido Aguarda Separação' 
_cOrdCb7:='Sem Ordem de Separação'  
 ElseIf val(_cStaCb7) <  4 //em separação manda email para o fabio 
_cEmail  :="simone.mara@steck.com.br;jefferson.puglia@steck.com.br; leandro.nobre@steck.com.br" 
_cMot:= 'Cliente Encontra-se na Steck - Pedido Aguarda Processo de Separação'   
 ElseIf val(_cStaCb7) >  4 //ja faturado
_cEmail  := "recepcao.mrocha@steck.com.br" //recepção
_cMot:= 'Cliente Encontra-se na Steck - Pedido Já Faturado' 
EndIf

If ( Type("l410Auto") == "U" .OR. !l410Auto )  


	   
	Aadd( _aMsg , { "Pedido: "              , _cPedido } )
	Aadd( _aMsg , { "Ordem de Separação: "  , _cOrdCb7 } )
	Aadd( _aMsg , { "Status: "    	     	, _cMot  } )
	Aadd( _aMsg , { "Data: "    	        , dtoc(date()) } )
	Aadd( _aMsg , { "Hora: "    		    , time() } )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do cabecalho do email                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do texto/detalhe do email                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nLin := 1 to Len(_aMsg)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		cMsg += '</TR>'
	Next
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do rodape do email                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
	//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
	//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
	cMsg += '</body>'
	cMsg += '</html>'
	
	
	If !(   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach) )
		MsgInfo("Email não Enviado..!!!!")
		
	EndIf
EndIf
RestArea(aArea)
Return()

          

