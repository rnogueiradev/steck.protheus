#include 'Protheus.ch' 
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STFAT15          | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descri��o |  STFAT15    Libera��o de regra                                           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STGAP04                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*-----------------------------*
User Function STFAT15()
*-----------------------------*
Local aArea          := GetArea()
Local aCores2        := {{" C5_ZBLOQ = '1' " 	, "BR_VERMELHO"	}}	// Cancelado

//---------------------------------------------------------------------------------------//
//FR - 18/10/2022 - TICKET #20221018019345 - Altera��o - Melhoria na al�ada de descontos
//no browse da tela de libera�ao de pedidos, inibir a exibi��o dos pedidos bloqueados
//por desconto, porque ser�o liberados em tela espec�fica para liberar desconto
//---------------------------------------------------------------------------------------//
Local cFiltro        := ""  //" C5_FILIAL = '"+xFilial("SC5")+"' AND C5_ZBLOQ = '1' ""
Local bFiltraBrw := {}		//FR - 18/10/2022 - Fl�via Rocha - Sigamat Consultoria
Local aIndexSC5  := {}		//FR - 18/10/2022 - Fl�via Rocha - Sigamat Consultoria

Private cCadastro	 := "Pedidos Bloqueados"
Private aRotina      := {}
Private cAliasAuto   := "" // Alias para identificar qual sera a rotina de atendimento para entrada automatica
Private aAutoCab     := {} // Campos de Cabecalho utilizados na rotina automatica
Private aAutoItens   := {} // Campos dos Itens utilizados na rotina automatica
Private aColtrfexc   := {}
Private aRatCTBPC    := {}

aRotina	:= {	{"Pesquisar" 	,"AxPesqui"		,0,1 },;
{ "Liberar"                     ,"A410Altera"     ,0,4,20,NIL}}  
DbSelectArea("SC5")
SC5->(dbOrderNickName("NICKSC58"))

//SC5->(dbSetFilter({||SC5->C5_ZBLOQ = '1'}," SC5->C5_ZBLOQ = '1' "))


//---------------------------------------------------------------------------------------//
//FR - 18/10/2022 - TICKET #20221018019345 - Altera��o - Melhoria na al�ada de descontos
//no browse da tela de libera�ao de pedidos, inibir a exibi��o dos pedidos bloqueados
//por desconto, porque ser�o liberados em tela espec�fica para liberar desconto
//---------------------------------------------------------------------------------------//
cFiltro := "C5_FILIAL = '"+xFilial("SC5")+"' .AND. C5_ZBLOQ = '1' .AND. !('DESC' $ C5_ZMOTBLO) "
bFiltraBrw := { || FilBrowse("SC5" , @aIndexSC5 , @cFiltro )}
	
If !Empty(cFiltro)
    Eval(bFiltraBrw)
Endif
//FR - 18/10/2022 - Fl�via Rocha - Sigamat Consultoria 

mBrowse( 7, 4,20,74,"SC5",,,,,,aCores2)
//SC5->(DbClearFilter())

//FR - 18/10/2022 - Fl�via Rocha - Sigamat Consultoria 
If !Empty(cFiltro)
	EndFilBrw("SC5" ,aIndexSC5)
Endif 
//FR - 18/10/2022 - Fl�via Rocha - Sigamat Consultoria 

Restarea(aArea)
Return()

User Function STFAT15X()
*-----------------------------*
Local aArea          := GetArea()
Local aCores2        := {{" C5_ZBLOQ = '1' " 	, "BR_VERMELHO"	}}	// Cancelado
Local cFiltro        := " C5_FILIAL = '"+xFilial("SC5")+"' AND C5_ZBLOQ = '1' AND C5_XVENDA='N' ""
Private cCadastro	 := "Pedidos Bloqueados"
Private aRotina      := {}
Private cAliasAuto   := "" // Alias para identificar qual sera a rotina de atendimento para entrada automatica
Private aAutoCab     := {} // Campos de Cabecalho utilizados na rotina automatica
Private aAutoItens   := {} // Campos dos Itens utilizados na rotina automatica
Private aColtrfexc   := {}

aRotina	:= {	{"Pesquisar" 	,"AxPesqui"		,0,1 },;
{ "Liberar"              ,           "A410Altera"     ,0,4,20,NIL}}  
DbSelectArea("SC5")
SC5->(dbOrderNickName("NICKSC58"))

SC5->(dbSetFilter({||SC5->C5_ZBLOQ = '1' .And. SC5->C5_XVENDA = 'N'}," SC5->C5_ZBLOQ = '1' .And. SC5->C5_XVENDA = 'N' "))

mBrowse( 7, 4,20,74,"SC5",,,,,,aCores2)
SC5->(DbClearFilter())
Restarea(aArea)
Return()

	