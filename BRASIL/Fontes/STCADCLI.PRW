#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STCADCLI         | Autor | GIOVANI.ZAGO             | Data | 21/02/2013  |
|=====================================================================================|
|Descrição |   STCADCLI      Filtro por Vendedor	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STCADCLI                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STCADCLI()
*-----------------------------*

Local _cCod         := __cuserid
Private aRotina     := {}
Private cCadastro   := ''
Private cAlias      := 'SA1'
Private _cUserCli   := GetMV("ST_CADCLI",,'000000')//Parametro com o codigo protheus com acesso a inclusao e alteração de clientes.
Public _cXCodVen361 := ''

If _cCod $ _cUserCli
	mata030()
Else
	
	DbSelectArea('SA1')
	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+_cCod))
		If SA3->A3_TPVEND <> 'I'  
		_cXCodVen361:= SA3->A3_COD
			SA1->(dbSetFilter({|| SA1->A1_VEND == _cXCodVen361},"SA1->A1_VEND == _cXCodVen361"))
		EndIf
	EndIf
	aRotina	:= { {"Pesquisar"  , "AxPesqui" ,0,1},;
				 {"Visualizar" , "U_ST01CADCLI" ,0,2}}
	cCadastro	:= "Cadastro de Cliente"
	
	
	obrowseX := GetmBrowse()
	mBrowse(6,1,22,75,cAlias)
SA1->(DbClearFilter())	
EndIf
Return ()


/*====================================================================================\
|Programa  | ST01CADCLI       | Autor | GIOVANI.ZAGO             | Data | 21/02/2013  |
|=====================================================================================|
|Descrição |   ST01CADCLI      Filtro por Vendedor	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ST01CADCLI                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function ST01CADCLI()

A030Visual(cAlias,SA1->(Recno()),2)

Return (.T.)