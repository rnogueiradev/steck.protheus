#INCLUDE "PROTHEUS.CH"
#include 'FWMVCDEF.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCOM010     บAutor  ณJoao Rinaldi    บ Data ณ  10/12/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Aprovadores de Solicita็ใo de Compras          บฑฑ
ฑฑบ          ณ Tela desenvolvida em MVC Modelo 3                          บฑฑ
ฑฑบ          ณ Obrigat๓rio o uso de 2 tabelas                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบFun็๕es   ณ ModelDef: Cont้m a regra de negocio                        บฑฑ
ฑฑบ          ณ ViewDef: Cont้m a interface                                บฑฑ
ฑฑบ          ณ MenuDef: Op็๕es do menu (aRotina)                          บฑฑ
ฑฑบ          ณ IniPad: Inicializador Padrใo                               บฑฑ
ฑฑบ          ณ VldAcess: Valida็ใo de Acesso                              บฑฑ
ฑฑบ          ณ VldTOK: Valida็ใo na Confirma็ใo                           บฑฑ
ฑฑบ          ณ GrvTOK: Valida็ใo ap๓s a Confirma็ใo                       บฑฑ
ฑฑบ          ณ StQuery1: Query 1 do relat๓rio                             บฑฑ
ฑฑบ          ณ STCOM011: Sequ๊ncial do Item                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STCOM010()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDeclara็ใo das Variแveis
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local _cAlias1  := "SZH"
	Local _aGrupos := {}
	Private _cGrp   := GetMv("STCOM0101",,'000000/000209/000122/000091/000226/000112/000202/000162/000129/000123/000168/') // Adicionado o grupo 000226 conforme chamado 005157 - Robson Mazzarotto
	Private cTitle  := "Aprovadores Solicita็ใo de Compras"
	Private _cCID   := "MOD3010"
	Private _cSSID  := "STCOM010"
	Private _UsFree := GetMV("ST_COM010",,"000000/000527")       
	Private aRotina := MenuDef(_cSSID)
	Private oBrowse
	Private oItens

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValida็ใo de acesso a rotina
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	/*
	PswOrder(1)
	If PswSeek(__cUserId,.T.)
	_aGrupos  := PswRet()
	Endif

	If !(_aGrupos[1][10][1] $ _cGrp)
	Help( ,, 'Help',, "Usuแrio sem permissใo para a rotina de "+cTitle+".";
	+CHR(10)+CHR(13)+;
	"A็ใo nใo permitida.";
	+CHR(10)+CHR(13)+;
	"Favor Verificar.",;
	1, 0 )
	Return
	EndIf
	*/

	DbSelectArea("SZH")
	SZH->(DbGoTop())
	SZH->(DbSetOrder(1))
	If   SZH->(DbSeek(xFilial("SZH")+__cUserId)) .And. !(__cUserId $ _UsFree)
		SZH->(dbSetFilter({|| SZH->ZH_APROVP = __cUserId }," SZH->ZH_APROVP = __cUserId "))
	ElseIf !(__cUserId $ _UsFree)
		MsgInfo("Usuario Sem Acesso....!!!!")
		Return()
	EndIf




	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณConstru็ใo bแsica de um Browse
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oBrowse := FWMBrowse():New()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefini็ใo da tabela que serแ exibida na Browse utilizando o m้todo SetAlias
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oBrowse:SetAlias(_cAlias1)

	oBrowse:SetWalkThru(.F.)
	oBrowse:SetAmbiente(.F.)
	oBrowse:SetUseFilter(.T.)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefini็ใo do tํtulo que serแ exibido como m้todo SetDescription
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oBrowse:SetDescription(cTitle)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefini็ใo do filtro ao browse
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//oBrowse:SetFilterDefault( "X5_TABELA == '21'" )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefini็ใo das legendas do browse
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oBrowse:AddLegend("!EMPTY(ZH_APROVP).And. Empty(ZH_DTFIMAP)"                                    ,"RED" ,"Bloqueado")
	oBrowse:AddLegend("!EMPTY(ZH_APROVP) .And. ZH_DTFIMAP < dDatabase"                              ,"BLUE"  ,"Inativo")
	oBrowse:AddLegend("!EMPTY(ZH_APROVP).And. ZH_DTFIMAP >= dDatabase .And. ZH_DTFIMAS < dDatabase" ,"GREEN"  ,"Ativo")
	oBrowse:AddLegend("!EMPTY(ZH_APROVS).And. ZH_DTFIMAS >= dDatabase .And. ZH_DTFIMAP >= dDatabase","BLACK" ,"Substituto")

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDesliga a exibi็ใo dos detalhes
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oBrowse:DisableDetails()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtiva็ใo da classe
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oBrowse:Activate()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MenuDef      บAutor  ณJoao Rinaldi    บ Data ณ  10/12/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ A fun็ใo MenuDef define as op็๕es (Menu) que estarใo       บฑฑ
ฑฑบ          ณ disponํveis ao usuแrio                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STCOM010.prw                                               บฑฑ
ฑฑบNome      ณ Cadastro de Aprovadores de Solicita็ใo de Compras          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MenuDef(_cSSID)

	Local _cProgram := ALLTRIM(UPPER(funname()))
	Local aRotina   := {}

	If !Empty(_cProgram)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณOp็๕es padr๕es do MVC
		// 1 para Pesquisar
		// 2 para Visualizar
		// 3 para Incluir
		// 4 para Alterar
		// 5 para Excluir
		// 6 para Imprimir
		// 7 para Copiar
		// 8 Op็๕es Customizadas
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	__cUserId $ _UsFree
		ADD OPTION aRotina TITLE "Pesquisar"    ACTION "PESQBRW"         OPERATION 1  ACCESS 0
		ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.STCOM010" OPERATION 2  ACCESS 0
		ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.STCOM010" OPERATION 3  ACCESS 0
		ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.STCOM010" OPERATION 4  ACCESS 0
		ADD OPTION aRotina TITLE "Excluir"      ACTION "VIEWDEF.STCOM010" OPERATION 5  ACCESS 0
	Else	
		ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.STCOM010" OPERATION 4  ACCESS 0
	EndIf	
	 

	Endif
Return aRotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ModelDef     บAutor  ณJoao Rinaldi    บ Data ณ  10/12/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ A fun็ใo ModelDef define a regra de neg๓cios propriamente  บฑฑ
ฑฑบ          ณ dita onde sใo definidas:                                   บฑฑ
ฑฑบ          ณ 1) Todas as entidades (tabelas) que farใo parte do modelo  บฑฑ
ฑฑบ          ณ de dados (Model)                                           บฑฑ
ฑฑบ          ณ 2) Regras de depend๊ncia entre as entidades                บฑฑ
ฑฑบ          ณ 3) Valida็๕es (de campos e aplica็ใo)                      บฑฑ
ฑฑบ          ณ 4) Persist๊ncia dos dados (grava็ใo)                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STCOM010.prw                                               บฑฑ
ฑฑบNome      ณ Cadastro de Aprovadores de Solicita็ใo de Compras          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ModelDef()

	Local oStruCabec := FWFormStruct(1, "SZH")// Constru็ใo de estrutura de dados
	Local oStruItens := FWFormStruct(1, "SZI")// Constru็ใo de estrutura de dados
	Local oModel
	Local _cTitulo   := "Aprovadores Solicita็ใo de Compras"
	Local _cCabec    := "Dados do Aprovador"
	Local _cItens    := "Rela็ใo de Centro de Custo"
	Local _aRel      := {}
	Local aAux1      := CreateTrigger(1)
	Local aAux2      := CreateTrigger(2)
	Local aAux3      := CreateTrigger(3)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Executo os gatilhos sem a utiliza็ใo do arquivo SX7.
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oStruCabec:AddTrigger( ;
	aAux1[1] , ;// [01] Id do campo de origem
	aAux1[2] , ;// [02] Id do campo de destino
	aAux1[3] , ;// [03] Bloco de codigo de valida็ใo da execu็ใo do gatilho
	aAux1[4] )  // [04] Bloco de codigo de execu็ใo do gatilho

	oStruCabec:AddTrigger( ;
	aAux2[1] , ;// [01] Id do campo de origem
	aAux2[2] , ;// [02] Id do campo de destino
	aAux2[3] , ;// [03] Bloco de codigo de valida็ใo da execu็ใo do gatilho
	aAux2[4] )  // [04] Bloco de codigo de execu็ใo do gatilho

	oStruItens:AddTrigger( ;
	aAux3[1] , ;// [01] Id do campo de origem
	aAux3[2] , ;// [02] Id do campo de destino
	aAux3[3] , ;// [03] Bloco de codigo de valida็ใo da execu็ใo do gatilho
	aAux3[4] )  // [04] Bloco de codigo de execu็ใo do gatilho

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria o objeto do Modelo de Dados
	//ณ Irie usar uma fun็ใo VldTOK que serแ acionada quando eu clicar no botใo "Confirmar"
	//ณ Irie usar uma fun็ใo GrvTOK que serแ acionada ap๓s a confirma็ใo do botใo "Confirmar"
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oModel := MPFormModel():New(_cCID  , /*bPreValidacao*/ ,  { | oModel | VldTOK( oModel ) }  ,  { | oModel | GrvTOK( oModel ) }  , /*bCancel*/ )
	//        MPFORMMODEL():New(<cID>  ,  <bPre >          , <bPost >                          , <bCommit >                        , <bCancel >)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Abaixo irei iniciar o campo X5_TABELA com o conteudo da sub-tabela
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//oStruCabec:SetProperty('X5_TABELA' , MODEL_FIELD_INIT,{||'21'} )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Abaixo irei bloquear/liberar os campos para edi็ใo
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//oStruCabec:SetProperty('X5_TABELA' , MODEL_FIELD_WHEN,{|| .F. })

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Podemos usar as fun็๕es INCLUI ou ALTERA Ou usar a propriedade GetOperation que captura a opera็ใo que estแ sendo executada
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//oStruCabec:SetProperty('X5_CHAVE'  , MODEL_FIELD_WHEN,{|| INCLUI })
	//oStruCabec:SetProperty("X5_CHAVE"  , MODEL_FIELD_WHEN,{|oModel| oModel:GetOperation()== 3 })

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Adiciona ao modelo uma estrutura de formulแrio de edi็ใo por campo
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oModel:AddFields("CABECALHO", /*cOwner*/, oStruCabec)
	oModel:AddGrid("ITENS","CABECALHO", oStruItens)//,{|oX,Line,Acao| U_STEMBLINOK(oX,Line,Acao)},/**/,/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fazendo o relacionamento entre o Cabe็alho e Item
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(_aRel, {'ZI_FILIAL' , 'ZH_FILIAL'} )
	aAdd(_aRel, {'ZI_APROVP' , 'ZH_APROVP'} )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fazendo o relacionamento entre os compomentes do model
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oModel:SetRelation('ITENS', _aRel, SZI->(IndexKey(2))) //IndexKey -> quero a ordena็ใo e depois filtrado
	//oModel:SetRelation('ITENS', _aRel, 'ZI_FILIAL+ZI_ITEM') //IndexKey -> quero a ordena็ใo e depois filtrado

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fazendo a valida็ใo para nใo permitir linha duplicada
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oModel:GetModel('ITENS'):SetUniqueLine({"ZI_CC"})  //Nใo repetir informa็๕es ou combina็๕es {"CAMPO1","CAMPO2","CAMPOX"}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define a chave primaria utilizada pelo modelo
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oModel:SetPrimaryKey({})
	//oModel:SetPrimaryKey({"ZI_CC"})

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Adiciona a descricao do Componente do Modelo de Dados
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oModel:SetDescription(_cTitulo)
	oModel:GetModel("CABECALHO"):SetDescription(_cCabec)
	oModel:GetModel("ITENS"):SetDescription(_cItens)
	oItens := oModel:GetModel("ITENS")
	oItens:lUseCols := .T.

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida็ใo para inicializador padrใo
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oModel:SetActivate( {|oMod| IniPad(oMod)} )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida็ใo da ativa็ใo do modelo
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oModel:SetVldActivate ( { |oMod| VldAcess( oMod ) } )

Return oModel

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ViewDef      บAutor  ณJoao Rinaldi    บ Data ณ  10/12/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ A fun็ใo ViewDef define como o serแ a interface e portanto บฑฑ
ฑฑบ          ณ como o usuแrio interage com o modelo de dados (Model)      บฑฑ
ฑฑบ          ณ recebendo os dados informados pelo usuแrio, fornecendo     บฑฑ
ฑฑบ          ณ ao modelo de dados (definido na ModelDef) e apresentando   บฑฑ
ฑฑบ          ณ o resultado.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STCOM010.prw                                               บฑฑ
ฑฑบNome      ณ Cadastro de Aprovadores de Solicita็ใo de Compras          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ViewDef()

	Local oStruCabec := FWFormStruct(2, "SZH")
	Local oStruItens := FWFormStruct(2, "SZI")
	Local oModel     := FWLoadModel(_cSSID)
	Local oView

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria o objeto de View
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oView := FWFormView():New()
	oView:SetModel(oModel)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Remove os campos que nใo irใo aparecer
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oStruCabec:RemoveField("ZH_FILIAL")
	oStruItens:RemoveField("ZI_FILIAL")
	oStruItens:RemoveField("ZI_APROVP")

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Adicionando os campos do cabe็alho e o grid dos itens
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oView:AddField("VIEW_CABEC", oStruCabec, "CABECALHO")
	oView:AddGrid ("VIEW_ITENS", oStruItens, "ITENS")

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Criar um "box" horizontal para receber algum elemento da view e Setando o dimensionamento de tamanho
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oView:CreateHorizontalBox("SUPERIOR", 40)
	oView:CreateHorizontalBox("INFERIOR", 60)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Amarrando a view com as box
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oView:SetOwnerView("VIEW_CABEC", "SUPERIOR")
	oView:SetOwnerView("VIEW_ITENS", "INFERIOR")

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ For็a o fechamento da janela na confirma็ใo
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oView:SetCloseOnOk({||.T.})

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Habilitando tํtulo
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oView:EnableTitleView("VIEW_CABEC")
	oView:EnableTitleView("VIEW_ITENS")

Return oView

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IniPad       บAutor  ณJoao Rinaldi    บ Data ณ  10/12/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ A fun็ใo IniPad define os campos e conte๚dos a serem       บฑฑ
ฑฑบ          ณ exibidos como Inicializador Padrใo                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STCOM010.prw                                               บฑฑ
ฑฑบNome      ณ Cadastro de Aprovadores de Solicita็ใo de Compras          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IniPad(oModel)

	Local nOp  := oModel:GetOperation()
	Local lIni := .T.

	If nOp == MODEL_OPERATION_INSERT //C๓pia tamb้m ้ reconhecida como inser็ใo

		oModel:SetValue("ITENS", "ZI_ITEM" , '001')

	EndIf

Return lIni

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldAcess     บAutor  ณJoao Rinaldi    บ Data ณ  10/12/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ A fun็ใo VldAcess define as permiss๕es de acesso aos bot๕esบฑฑ
ฑฑบ          ณ da rotina                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STCOM010.prw                                               บฑฑ
ฑฑบNome      ณ Cadastro de Aprovadores de Solicita็ใo de Compras          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldAcess(oModel)

	Local lAcess    := .T.
	//Local _cGrp    := '000000/000209/000122/000091'
	Local _aGrupos := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida็ใo de Grupo de Usuแrio para acesso aos bot๕es da rotina
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos  := PswRet()
	Endif

	If !(_aGrupos[1][10][1] $ _cGrp)
		Help( ,, 'Help',, "Usuแrio sem permissใo para a rotina de "+cTitle+".";
		+CHR(10)+CHR(13)+;
		"A็ใo nใo permitida.";
		+CHR(10)+CHR(13)+;
		"Favor Verificar.",;
		1, 0 )
		lAcess := .F.
	EndIf

Return (lAcess)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldTOK       บAutor  ณJoao Rinaldi    บ Data ณ  10/12/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ A fun็ใo VldTOK ้ acionada no botใo Confirmar e valida     บฑฑ
ฑฑบ          ณ se as informa็๕es digitadas estใo corretas                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STCOM010.prw                                               บฑฑ
ฑฑบNome      ณ Cadastro de Aprovadores de Solicita็ใo de Compras          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldTOK( oModel )

	Local nOp         := oModel:GetOperation()
	Local oModelCabec := oModel:GetModel( "CABECALHO" )
	Local cAPROVP     := oModelCabec:GetValue('ZH_APROVP')
	Local cDTINIAP    := oModelCabec:GetValue('ZH_DTINIAP')
	Local cDTFIMAP    := oModelCabec:GetValue('ZH_DTFIMAP')
	Local cAPROVS     := oModelCabec:GetValue('ZH_APROVS')
	Local cDTINIAS    := oModelCabec:GetValue('ZH_DTINIAS')
	Local cDTFIMAS    := oModelCabec:GetValue('ZH_DTFIMAS')
	Local cLog        := oModelCabec:GetValue('ZH_LOG')
	Local oModelItens := oModel:GetModel( "ITENS" )
	Local _cCC        := ''
	Local lVld        := .T.
	Local _lAltCabec  := .F.
	Local _lAltItens  := .F.
	Local _cMsgCabec  := ''
	Local _cMsgItens  := ''
	Local _cSx3       := ''
	Local _nI
	Local _nJ
	Local _nK
	Local _cStatus    := ''

	If nOp==5
		Return(.T.)
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida็ใo no preenchimento dos campos do Cabe็alho
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Empty(cAPROVP)
		Help( ,, 'Help',, "O C๓digo do "+Alltrim((RetTitle("ZH_APROVP")))+" precisa ser preenchido.";
		+CHR(10)+CHR(13)+;
		"O Cadastro nใo serแ efetivado.";
		+CHR(10)+CHR(13)+;
		"Favor Verificar.",;
		1, 0 )
		lVld := .F.

	ElseIf (cDTINIAP) > (cDTFIMAP)
		Help( ,, 'Help',, "A Data "+Alltrim((RetTitle("ZH_DTINIAP")))+" nใo pode ser maior do que a Data "+Alltrim((RetTitle("ZH_DTFIMAP")))+".";
		+CHR(10)+CHR(13)+;
		"O Cadastro nใo serแ efetivado.";
		+CHR(10)+CHR(13)+;
		"Favor Verificar.",;
		1, 0 )
		lVld := .F.

	ElseIf (!Empty(cDTINIAP) .And. Empty(cDTFIMAP)) .Or.	(Empty(cDTINIAP) .And. !Empty(cDTFIMAP))
		Help( ,, 'Help',, "As Datas "+Alltrim((RetTitle("ZH_DTINIAP")))+" e "+Alltrim((RetTitle("ZH_DTFIMAP")))+" precisam ser preenchidas.";
		+CHR(10)+CHR(13)+;
		"O Cadastro nใo serแ efetivado.";
		+CHR(10)+CHR(13)+;
		"Favor Verificar.",;
		1, 0 )
		lVld := .F.

	ElseIf (cDTINIAS) > (cDTFIMAS)
		Help( ,, 'Help',, "A Data "+Alltrim((RetTitle("ZH_DTINIAS")))+" nใo pode ser maior do que a Data "+Alltrim((RetTitle("ZH_DTFIMAS")))+".";
		+CHR(10)+CHR(13)+;
		"O Cadastro nใo serแ efetivado.";
		+CHR(10)+CHR(13)+;
		"Favor Verificar.",;
		1, 0 )
		lVld := .F.

	ElseIf (!Empty(cDTINIAS) .And. Empty(cDTFIMAS)) .Or.	(Empty(cDTINIAS) .And. !Empty(cDTFIMAS))
		Help( ,, 'Help',, "As Datas "+Alltrim((RetTitle("ZH_DTINIAS")))+" e "+Alltrim((RetTitle("ZH_DTFIMAS")))+" precisam ser preenchidas.";
		+CHR(10)+CHR(13)+;
		"O Cadastro nใo serแ efetivado.";
		+CHR(10)+CHR(13)+;
		"Favor Verificar.",;
		1, 0 )
		lVld := .F.

	ElseIf (cAPROVP) = (cAPROVS)
		Help( ,, 'Help',, "O C๓digo do  "+Alltrim((RetTitle("ZH_APROVP")))+" nใo pode ser o mesmo que o c๓digo do "+Alltrim((RetTitle("ZH_APROVS")))+" .";
		+CHR(10)+CHR(13)+;
		"O Cadastro nใo serแ efetivado.";
		+CHR(10)+CHR(13)+;
		"Favor Verificar.",;
		1, 0 )
		lVld := .F.

	ElseIf !(Empty(cAPROVS)) .And. (Empty(cDTINIAS) .And. Empty(cDTFIMAS))
		Help( ,, 'Help',, "O C๓digo do "+Alltrim((RetTitle("ZH_APROVS")))+" foi preenchido por้m as Datas "+Alltrim((RetTitle("ZH_DTINIAS")))+" e "+Alltrim((RetTitle("ZH_DTFIMAS")))+" nใo foram preenchidas.";
		+CHR(10)+CHR(13)+;
		"O Cadastro nใo serแ efetivado.";
		+CHR(10)+CHR(13)+;
		"Favor Verificar.",;
		1, 0 )
		lVld := .F.

	ElseIf !Empty(cAPROVP) .And. INCLUI
		DbSelectArea("SZH")
		SZH->(DbSetOrder(1))//ZH_FILIAL+ZH_APROVP
		SZH->(DbGoTop())
		If DbSeek(xFilial("SZH")+cAPROVP)
			Help( ,, 'Help',, "O C๓digo do "+Alltrim((RetTitle("ZH_APROVP")))+" jแ estแ cadastrado.";
			+CHR(10)+CHR(13)+;
			"Favor alterar o cadastro existente.";
			+CHR(10)+CHR(13)+;
			"O Cadastro nใo serแ efetivado.";
			+CHR(10)+CHR(13)+;
			"Favor Verificar.",;
			1, 0 )
			lVld := .F.
		Endif
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida็ใo no preenchimento dos campos dos Itens
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lVld
		For _nK := 1 To oModelItens:Length()
			oModelItens:GoLine( _nK )
			_cCC := oModelItens:GetValue('ZI_CC')
			If !(oModelItens:IsDeleted())
				If !(STQUERY1(_cCC,cAPROVP))
					Help( ,, 'Help',, "O C๓digo do "+Alltrim((RetTitle("ZI_CC")))+" '"+Alltrim(_cCC)+"' jแ estแ cadastrado para outro "+Alltrim((RetTitle("ZH_APROVP")))+".";
					+CHR(10)+CHR(13)+;
					"O Cadastro nใo serแ efetivado.";
					+CHR(10)+CHR(13)+;
					"Favor Verificar.",;
					1, 0 )
					lVld := .F.
					Exit
				Endif
			Endif
		Next _nK
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza็ใo dos valores do Cabe็alho
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lVld .And. cValtochar(nOp) $ '3/4'
		/*
		If cStatus <> '3'
		If !Empty(cAPROVS)
		oModel:SetValue( 'CABECALHO', 'ZH_STATUS', '4' )
		ElseIf Empty(cDTINIAP) .And. Empty(cDTFIMAP)
		oModel:SetValue( 'CABECALHO', 'ZH_STATUS', '1' )
		ElseIf !Empty(cDTINIAP) .And. !Empty(cDTFIMAP)
		oModel:SetValue( 'CABECALHO', 'ZH_STATUS', '2' )
		Endif
		Endif
		*/
		If (Empty(cAPROVS)) .And. (!Empty(cDTINIAS) .And. !Empty(cDTFIMAS))
			oModel:SetValue( 'CABECALHO', 'ZH_DTINIAS', cTod('  /  /    ') )
			oModel:SetValue( 'CABECALHO', 'ZH_DTFIMAS', cTod('  /  /    ') )
		Endif
	Endif

	If !Empty(cAPROVP)
		oModel:SetValue('CABECALHO','ZH_NOMEAP'     ,FwFldGet('ZH_APROVP'))
		//oModel:SetValue('CABECALHO',     ,FwFldGet('PH1_USER') )
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Anแlise das altera็๕es realizadas no Cabe็alho e nos itens para atualiza็ใo do campo ZH_LOG
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lVld
		_cMsgCabec	+= "==================================="+CHR(13) +CHR(10)
		_cMsgCabec	+= "Altera็๕es realizadas no Cabe็alho (Aprovador):"+CHR(13) +CHR(10)
		_cMsgCabec	+= "Usuแrio: "+cUserName+CHR(13) +CHR(10)
		_cMsgCabec	+= "Alterado em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13) +CHR(10)
		_cMsgCabec	+= "Campo | Descri็ใo | Anterior | Novo "+CHR(13) +CHR(10)

		DbSelectArea("SX3")
		SX3->(DbGoTop())
		SX3->(DbSetOrder(1))
		SX3->(DbSeek("SZH"))
		While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="SZH"
			If !((SX3->X3_CONTEXT) == 'V')
				_cSx3 := oModelCabec:GetValue((SX3->X3_CAMPO))
				If !((_cSx3) == &("SZH->"+SX3->X3_CAMPO))
					_cMsgCabec		+= SX3->X3_CAMPO + " | " + Alltrim(RetTitle(SX3->X3_CAMPO)) + " | "
					DO CASE
						CASE AllTrim(SX3->X3_TIPO)=="C"
						_cMsgCabec		+= &("SZH->"+SX3->X3_CAMPO)+" | "+(_cSx3)+CHR(13)+CHR(10)
						CASE AllTrim(SX3->X3_TIPO)=="N"
						_cMsgCabec		+= CVALTOCHAR(&("SZH->"+SX3->X3_CAMPO))+" | "+CVALTOCHAR(_cSx3)+CHR(13)+CHR(10)
						CASE AllTrim(SX3->X3_TIPO)=="D"
						_cMsgCabec		+= DTOC(&("SZH->"+SX3->X3_CAMPO))+" | "+DTOC(_cSx3)+CHR(13)+CHR(10)
					ENDCASE
					_lAltCabec	:= .T.
				EndIf
			Endif
			SX3->(DbSkip())
		EndDo

		_cMsgItens	+= "==================================="+CHR(13) +CHR(10)
		_cMsgItens	+= "Altera็๕es realizadas nos Itens (Centro de Custo):"+CHR(13) +CHR(10)
		_cMsgItens	+= "Usuแrio: "+cUserName+CHR(13) +CHR(10)
		_cMsgItens	+= "Alterado em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13) +CHR(10)
		_cMsgItens	+= "Campo | Descri็ใo | Status | Anterior | Novo "+CHR(13) +CHR(10)

		For _nI := 1 To oModelItens:Length()
			oModelItens:GoLine( _nI )

			SZI->(DbGoto(oModelItens:GetdataID(_nI)))//Recno

			DbSelectArea("SX3")
			SX3->(DbGoTop())
			SX3->(DbSetOrder(1))
			SX3->(DbSeek("SZI"))

			While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="SZI"
				If !((SX3->X3_CONTEXT) == 'V')
					_cSx3 := oModelItens:GetValue((SX3->X3_CAMPO))
					For _nJ := 1 to Len(oModelItens:Aheader)
						If (Alltrim(oModelItens:aHeader[_nJ][2]) == Alltrim(SX3->X3_CAMPO))
							If  !((oModelItens:aCols[_nI][_nJ])  ==  &("SZI->"+SX3->X3_CAMPO)) .Or. (oModelItens:aCols[_nI][len(oModelItens:aCols[_nI])])//Conte๚do
								DO CASE
									CASE (oModelItens:GetdataID(_nI)) = 0
									_cStatus := "Novo Registro: "
									CASE (oModelItens:aCols[_nI][len(oModelItens:aCols[_nI])])
									_cStatus := "Registro Deletado: "
									CASE !((oModelItens:aCols[_nI][_nJ])  ==  &("SZI->"+SX3->X3_CAMPO))
									CASE !((oItens:aDataModel[oItens:nLine,1,1,_nJ])  ==  &("SZI->"+SX3->X3_CAMPO))
									_cStatus := "Registro Alterado: "
								ENDCASE
								_cMsgItens		+= SX3->X3_CAMPO + " | " + Alltrim(RetTitle(SX3->X3_CAMPO)) + " | "
								DO CASE
									CASE AllTrim(SX3->X3_TIPO )=="C"
									_cMsgItens		+= _cStatus +" | "+ &("SZI->"+SX3->X3_CAMPO)+" | "+(_cSx3)+CHR(13)+CHR(10)
									CASE AllTrim(SX3->X3_TIPO )=="N"
									_cMsgItens		+= _cStatus +" | "+ CVALTOCHAR(&("SZI->"+SX3->X3_CAMPO))+" | "+CVALTOCHAR(_cSx3)+CHR(13)+CHR(10)
									CASE AllTrim(SX3->X3_TIPO )=="D"
									_cMsgItens		+= _cStatus +" | "+ DTOC(&("SZI->"+SX3->X3_CAMPO))+" | "+DTOC(_cSx3)+CHR(13)+CHR(10)
								ENDCASE
								_lAltItens := .T.
							EndIf
						Endif
					Next _nJ
				Endif
				SX3->(DbSkip())
			EndDo
		Next _nI

		If !(_lAltCabec)
			_cMsgCabec := ''
		Endif

		If !(_lAltItens)
			_cMsgItens := ''
		Endif

		If _lAltCabec .Or. _lAltItens
			oModel:SetValue( 'CABECALHO', 'ZH_LOG', cLog +CHR(13)+CHR(10)+ _cMsgCabec + _cMsgItens )
		EndIf
	Endif

Return lVld

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GrvTOK       บAutor  ณJoao Rinaldi    บ Data ณ  10/12/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ A fun็ใo GrvTOK ้ acionada ap๓s a confirma็ใo do botใo     บฑฑ
ฑฑบ          ณ Confirmar                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STCOM010.prw                                               บฑฑ
ฑฑบNome      ณ Cadastro de Aprovadores de Solicita็ใo de Compras          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GrvTOK( oModel )

	Local lGrv        := .T.
	FWFormCommit( oModel )

Return lGrv

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STQUERY1     บAutor  ณJoao Rinaldi    บ Data ณ  10/12/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ A fun็ใo STQUERY1 ้ acionada pela fun็ใo VldTOK            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STCOM010.prw                                               บฑฑ
ฑฑบNome      ณ Cadastro de Aprovadores de Solicita็ใo de Compras          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function STQUERY1(_cCC,cAPROVP)

	Local cPerg      := "STQUERY1"
	Local cTime      := Time()
	Local cHora      := SUBSTR(cTime, 1, 2)
	Local cMinutos   := SUBSTR(cTime, 4, 2)
	Local cSegundos  := SUBSTR(cTime, 7, 2)
	Local cAliasLif  := cPerg+cHora+cMinutos+cSegundos
	Local cAlias1    := cAliasLif
	Local cQuery1    := ' '
	Local lQuery     := .T.

	cQuery1 := " SELECT
	cQuery1 += " DISTINCT
	cQuery1 += " ZI_CC         AS A1_CC
	cQuery1 += " ,COUNT(ZI_CC) AS A2_QTDE
	cQuery1 += " FROM "+RetSqlName("SZI")+" SZI

	cQuery1 += " WHERE SZI.D_E_L_E_T_ = ' '
	cQuery1 += " AND ZI_FILIAL  = '"+xFilial("SZI")+"'
	cQuery1 += " AND ZI_CC      = '"+_cCC+"'
	cQuery1 += " AND ZI_APROVP <> '"+cAPROVP+"'

	cQuery1 += " GROUP BY ZI_CC
	cQuery1 += " ORDER BY ZI_CC

	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)

	DbSelectArea(cAlias1)
	(cAlias1)->(DbGoTop())
	If  Select(cAlias1) > 0
		If !(Empty((cAlias1)->A2_QTDE))
			lQuery := .F.
		Endif
	Endif

Return lQuery

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCOM011     บAutor  ณJoao Rinaldi    บ Data ณ  10/12/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ A fun็ใo STCOM011 ้ acionada pelo campo X3_RELACAO do campoบฑฑ
ฑฑบ          ณ ZI_ITEM para gerar o sequ๊ncial do item                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STCOM010.prw                                               บฑฑ
ฑฑบNome      ณ Cadastro de Aprovadores de Solicita็ใo de Compras          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STCOM011()

	Local _cItem	:= "000"
	Local _nItem	:= aScan(oItens:aHeader,{|w| AllTrim(w[2])=="ZI_ITEM"})

	If n >= 1
		_cItem	:= oItens:aCols[n,_nItem]
	Endif

	_cItem	:= Soma1(_cItem,3)

Return(_cItem)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CreateTriggerบAutor  ณJoao Rinaldi    บ Data ณ  20/01/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ A fun็ใo CreateTrigger executa os gatilhos sem a           บฑฑ
ฑฑบ          ณ utiliza็ใo do arquivo SX7.                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STCOM010.prw                                               บฑฑ
ฑฑบNome      ณ Cadastro de Aprovadores de Solicita็ใo de Compras          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CreateTrigger(_nTrigger)

	Local aAux := {}

	If _nTrigger == 1
		aAux := FwStruTrigger(;
		"ZH_APROVP" ,;            // Campo Dominio
		"ZH_NOMEAP" ,;               // Campo de Contradominio
		"UsrRetName(M->ZH_APROVP)",; // Regra de Preenchimento
		.F. ,;                       // Se posicionara ou nao antes da execucao do gatilhos
		"" ,;                        // Alias da tabela a ser posicionada
		0 ,;                         // Ordem da tabela a ser posicionada
		"" ,;                        // Chave de busca da tabela a ser posicionada
		NIL ,;                       // Condicao para execucao do gatilho
		"01" )                       // Sequencia do gatilho (usado para identificacao no caso de erro)

	ElseIf _nTrigger == 2
		aAux :=   FwStruTrigger(;
		"ZH_APROVS" ,;            // Campo Dominio
		"ZH_NOMEAPS" ,;              // Campo de Contradominio
		"UsrRetName(M->ZH_APROVS)",; // Regra de Preenchimento
		.F. ,;                       // Se posicionara ou nao antes da execucao do gatilhos
		"" ,;                        // Alias da tabela a ser posicionada
		0 ,;                         // Ordem da tabela a ser posicionada
		"" ,;                        // Chave de busca da tabela a ser posicionada
		NIL ,;                       // Condicao para execucao do gatilho
		"02" )                       // Sequencia do gatilho (usado para identificacao no caso de erro)

	ElseIf _nTrigger == 3
		aAux :=   FwStruTrigger(;
		"ZI_CC",;                // Campo Dominio
		"ZI_DESCCC",;                // Campo de Contradominio
		"CTT->CTT_DESC01",;          // Regra de Preenchimento
		.T. ,;                       // Se posicionara ou nao antes da execucao do gatilhos
		"CTT",;                      // Alias da tabela a ser posicionada
		1 ,;                         // Ordem da tabela a ser posicionada
		'xFilial("CTT")+M->ZI_CC' ,; // Chave de busca da tabela a ser posicionada
		NIL ,;                       // Condicao para execucao do gatilho
		"03" )                       // Sequencia do gatilho (usado para identificacao no caso de erro)

	Endif

Return aAux
