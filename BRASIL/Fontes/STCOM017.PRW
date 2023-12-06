#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCOM017 บAutor  ณJoao Rinaldi        บ Data ณ  14/12/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo desenvolvida para que os aprovadores possam analisarบฑฑ
ฑฑบ          ณ as solicita็๕es de compras                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STCOM017()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDeclara็ใo das Variแveis
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local _cAlias1  := "SC1"
	Local _cFiltro  := ""
	Local _cUser    := ""
	Private cTitle  := "Anแlise de Solicita็ใo de Compras"
	Private cMarca  := ''
	Private _cCID   := "MARK017"
	Private _cSSID  := "STCOM017"
	Private aRotina := MenuDef(_cSSID)
	Private oMark


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValida็ใo de acesso a rotina do aprovador principal e/ou substituto
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cUser := U_STCOM021()
	If Empty(_cUser) //Ajustado a logico do aprovador chamado 004436 Robson Mazzarotto
		Return
	elseif len(_cUser) = 12
		_cUser := Substr(_cUser,1,6)
		_cFiltro := "C1_ZAPROV = '"+_cUser+"' .AND. C1_TPOP <> 'P' " //Chamado 007386 - Everson Santana - 22/08/18
	Elseif len(_cUser) = 6
		if _cUser == __cUserId
			_cUser := Substr(_cUser,1,6)
			_cFiltro := "C1_ZAPROV == '"+_cUser+"' .AND. C1_TPOP <> 'P' " //Chamado 007386 - Everson Santana - 22/08/18
		else
			//_cUser := ""
			_cFiltro := "C1_ZAPROV == '"+_cUser+"' .AND. C1_TPOP <> 'P' " //Chamado 007386 - Everson Santana - 22/08/18
		endif
	Endif

	If MsgYesNo("Deseja Filtrar as Solicita็๕es em Aberto ?")
		_cFiltro += " .And. (C1_ZSTATUS = '1' .Or.C1_ZSTATUS = '2')"
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณConstru็ใo bแsica de um Browse
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark  := FWMarkBrowse():New()
	cMarca := oMark:Mark()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefini็ใo da tabela que serแ exibida na Browse utilizando o m้todo SetAlias
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark:SetAlias(_cAlias1)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefini็ใo da utiliza็ใo de Mark Browse na constru็ใo da tela
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark:SetFieldMark("C1_ZMARKBR")
	//oMark:SetMark(cMarca,_cAlias1,"C1_ZMARKBR")
	oMark:SetAfterMark({||U_STCOM018(1)})
	oMark:SetSemaphore(.f.)
	oMark:SetAllMark({|| U_STCOM018(2)})//SetAllMark nใo funciona quando a classe SetSemaphore estiver ativa
	oMark:SetWalkThru(.F.)
	oMark:SetAmbiente(.F.)
	oMark:SetUseFilter(.T.)

	//oMark:SetParam({|| RecarSel()})
	//oMark:SetBackColor(000250154)
	//oMark:SetClrAlterRow(135206235)
	//oMark:SetForeColor(255255255)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefini็ใo do tํtulo que serแ exibido como m้todo SetDescription
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark:SetDescription(cTitle)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefini็ใo do filtro ao browse
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark:SetFilterDefault( _cFiltro )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefini็ใo das legendas do browse
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark:AddLegend("C1_ZSTATUS==' '" ,"YELLOW"          ,"Sem Aprova็ใo")
	oMark:AddLegend("C1_ZSTATUS=='1'" ,"WARNING"         ,"Pendente de Aprova็ใo")
	oMark:AddLegend("C1_ZSTATUS=='2'" ,"OK"           ,"Analisado pelo Gestor")
	oMark:AddLegend("C1_ZSTATUS=='3'.Or. C1_ZSTATUS=='6'" ,"GREEN"           ,"Aprovado pelo Gestor")
	oMark:AddLegend("C1_ZSTATUS=='4'" ,"RED"          ,"Rejeitado pelo Gestor")
	oMark:AddLegend("C1_ZSTATUS=='5'" ,"BLACK" ,"Rejeitada por Compras")


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDesliga a exibi็ใo dos detalhes
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark:DisableDetails()
	//Indica o Code-Block executado no clique do header da coluna de marca/desmarca
	//oBrowse:bAllMark := { || MCFG6Invert(oBrowse:Mark(),lMarcar := !lMarcar ), oBrowse:Refresh(.T.)  }

	//   oMark:bAllMark := { || MCFG6Invert(oMark:Mark(),lMarcar := !lMarcar ), oMark:Refresh(.T.)  }


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtiva็ใo da classe
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oMark:Activate()

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
		ADD OPTION aRotina TITLE "Sel.Tudo"      ACTION "U_STCOM018(2)"   OPERATION 8  ACCESS 0
		ADD OPTION aRotina TITLE "Pesquisar"    ACTION "PESQBRW"         OPERATION 1  ACCESS 0
		ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.STCOM017" OPERATION 2  ACCESS 0
		ADD OPTION aRotina TITLE "Aprovar"      ACTION "U_STCOM018(3)"   OPERATION 8  ACCESS 0
		ADD OPTION aRotina TITLE "Rejeitar"     ACTION "U_STCOM018(4)"   OPERATION 8  ACCESS 0
		ADD OPTION aRotina TITLE "Anexo"     	ACTION "U_STCOM016(SC1->C1_NUM)"   OPERATION 8  ACCESS 0

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

	Local oStruCabec := FWFormStruct(1, "SC1")// Constru็ใo de estrutura de dados
	Local oStruItens := FWFormStruct(1, "SC1")// Constru็ใo de estrutura de dados
	Local oModel
	Local _cTitulo   := "Anแlise de Solicita็ใo de Compras"
	Local _cCabec    := "Solicita็ใo de Compras"
	Local _cItens    := "Itens da Solicita็ใo de Compras"
	Local _aRel      := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria o objeto do Modelo de Dados
	//ณ Irie usar uma fun็ใo VldTOK que serแ acionada quando eu clicar no botใo "Confirmar"
	//ณ Irie usar uma fun็ใo GrvTOK que serแ acionada ap๓s a confirma็ใo do botใo "Confirmar"
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oModel := MPFormModel():New(_cCID)//  , /*bPreValidacao*/ ,  { | oModel | VldTOK( oModel ) }  ,  { | oModel | GrvTOK( oModel ) }  , /*bCancel*/ )
	//        MPFORMMODEL():New(<cID>  ,  <bPre >          , <bPost >                          , <bCommit >                        , <bCancel >)

	oStruCabec:AddField( "C1_SOLICIT",RetTitle("C1_SOLICIT"),"C1_SOLICIT",TamSx3("C1_SOLICIT")[3],TamSx3("C1_SOLICIT")[1],TamSx3("C1_SOLICIT")[2],       ,      ,        ,         ,      ,     ,       ,         ,  )
	oStruCabec:AddField( "C1_FILENT" ,RetTitle("C1_FILENT") ,"C1_FILENT" ,TamSx3("C1_FILENT")[3] ,TamSx3("C1_FILENT")[2] ,TamSx3("C1_FILENT")[2] ,       ,      ,        ,         ,      ,     ,       ,         ,  )
	//oStruCabec:AddField( cTitulo   , cTooltip             , cIdField   , cTipo                 ,nTamanho               ,nDecimal               , bValid, bWhen, aValues, lObrigat, bInit, lKey, lNoUpd, lVirtual, cValid)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Abaixo irei iniciar o campo X5_TABELA com o conteudo da sub-tabela
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//oStruCabec:SetProperty('X5_TABELA' , MODEL_FIELD_INIT,{||'21'} )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Abaixo irei bloquear/liberar os campos para edi็ใo
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//oStruCabec:SetProperty('X5_TABELA' , MODEL_FIELD_WHEN,{||.F. })

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
	aAdd(_aRel, {'C1_FILIAL' , 'C1_FILIAL'} )
	aAdd(_aRel, {'C1_NUM'    , 'C1_NUM'} )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fazendo o relacionamento entre os compomentes do model
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oModel:SetRelation('ITENS', _aRel, SC1->(IndexKey(1))) //IndexKey -> quero a ordena็ใo e depois filtrado
	//oModel:SetRelation('ITENS', _aRel, 'ZI_FILIAL+ZI_ITEM') //IndexKey -> quero a ordena็ใo e depois filtrado

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fazendo a valida็ใo para nใo permitir linha duplicada
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//oModel:GetModel('ITENS'):SetUniqueLine({"ZI_CC"})  //Nใo repetir informa็๕es ou combina็๕es {"CAMPO1","CAMPO2","CAMPOX"}
	//oModel:GetModel("ITENS"):SetDelAllLine(.T.)
	//oModel:SetOptional("ITENS",.T. )

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

	Local oStruCabec := FWFormStruct(2, "SC1")
	Local oStruItens := FWFormStruct(2, "SC1")
	Local oModel     := FWLoadModel(_cSSID)
	Local oView

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria o objeto de View
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oView:= FWFormView():New()
	oView:SetModel(oModel)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Remove os campos que nใo irใo aparecer
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oStruCabec:RemoveField("C1_ITEM")
	oStruCabec:RemoveField("C1_PRODUTO")
	oStruCabec:RemoveField("C1_UM")
	oStruCabec:RemoveField("C1_QUANT")
	oStruCabec:RemoveField("C1_SEGUM")
	oStruCabec:RemoveField("C1_MOTIVO")
	oStruCabec:RemoveField("C1_COMPSTK")
	oStruCabec:RemoveField("C1_QTSEGUM")
	oStruCabec:RemoveField("C1_DATPRF")
	oStruCabec:RemoveField("C1_LOCAL")
	oStruCabec:RemoveField("C1_OBS")
	oStruCabec:RemoveField("C1_OP")
	oStruCabec:RemoveField("C1_CC")
	oStruCabec:RemoveField("C1_CONTA")
	oStruCabec:RemoveField("C1_ITEMCTA")
	oStruCabec:RemoveField("C1_DESCRI")
	oStruCabec:RemoveField("C1_FORNECE")
	oStruCabec:RemoveField("C1_LOJA")
	oStruCabec:RemoveField("C1_IMPORT")
	//oStruCabec:RemoveField("C1_CODCOMP")
	oStruCabec:RemoveField("C1_CLASS")
	oStruCabec:RemoveField("C1_CLVL")
	oStruCabec:RemoveField("C1_PROJETO")
	oStruCabec:RemoveField("C1_SEQMRP")
	oStruCabec:RemoveField("C1_RESIDUO")
	oStruCabec:RemoveField("C1_QTDORIG")
	oStruCabec:RemoveField("C1_PRECO")
	oStruCabec:RemoveField("C1_TOTAL")
	oStruCabec:RemoveField("C1_PROJET")
	oStruCabec:RemoveField("C1_REVISA")
	oStruCabec:RemoveField("C1_TAREFA")
	oStruCabec:RemoveField("C1_TRT")
	oStruCabec:RemoveField("C1_ITEMGRD")
	oStruCabec:RemoveField("C1_GRADE")
	oStruCabec:RemoveField("C1_FABRICA")
	oStruCabec:RemoveField("C1_LOJFABR")
	oStruCabec:RemoveField("C1_FLAGGCT")
	oStruCabec:RemoveField("C1_ESTOQUE")
	oStruCabec:RemoveField("C1_PROGRAM")
	oStruCabec:RemoveField("C1_TPSC")
	oStruCabec:RemoveField("C1_MODAL")
	oStruCabec:RemoveField("C1_TPMOD")
	oStruCabec:RemoveField("C1_CODED")
	oStruCabec:RemoveField("C1_NUMPR")
	oStruCabec:RemoveField("C1_ORCAM")
	oStruCabec:RemoveField("C1_RATEIO")
	//oStruCabec:RemoveField("C1_XEMAIL")
	oStruCabec:RemoveField("C1_XPRC")
	oStruCabec:RemoveField("C1_XVLCOTU")
	oStruCabec:RemoveField("C1_XTOTCOT")
	oStruCabec:RemoveField("C1_ZAPROV")
	oStruCabec:RemoveField("C1_ZNOMEAP")
	oStruCabec:RemoveField("C1_ZSTATUS")
	oStruCabec:RemoveField("C1_ZMARKBR")
	oStruCabec:RemoveField("C1_XULTPRE")
	oStruCabec:RemoveField("C1_XTULTPR")

	oStruItens:RemoveField("C1_XTOTSC")

	oStruCabec:AddField( "C1_FILIAL" ,"01"    ,RetTitle("C1_FILIAL") ,RetTitle("C1_FILIAL") ,     ,TamSx3("C1_FILIAL")[3] ,        ,         ,        ,.F.        ,        ,       ,             ,             ,         ,         ,         ,.F.)
	oStruCabec:AddField( "C1_EMISSAO","03"    ,RetTitle("C1_EMISSAO"),RetTitle("C1_EMISSAO"),     ,TamSx3("C1_EMISSAO")[3],        ,         ,        ,.F.        ,        ,       ,             ,             ,         ,         ,         ,.F.)
	oStruCabec:AddField( "C1_SOLICIT","04"    ,RetTitle("C1_SOLICIT"),RetTitle("C1_SOLICIT"),     ,TamSx3("C1_SOLICIT")[3],        ,         ,        ,.F.        ,        ,       ,             ,             ,         ,         ,         ,.F.)
	oStruCabec:AddField( "C1_UNIDREQ","05"    ,RetTitle("C1_UNIDREQ"),RetTitle("C1_UNIDREQ"),     ,TamSx3("C1_UNIDREQ")[3],        ,         ,        ,.F.        ,        ,       ,             ,             ,         ,         ,         ,.F.)
	oStruCabec:AddField( "C1_FILENT" ,"06"    ,RetTitle("C1_FILENT") ,RetTitle("C1_FILENT") ,     ,TamSx3("C1_FILENT")[3] ,        ,         ,        ,.F.        ,        ,       ,             ,             ,         ,         ,         ,.F.)
	//oStruCabec:AddField(cIdField   ,cOrdem  ,cTitulo               ,cDescric              ,aHelp,cType                  ,cPicture, bPictVar, cLookUp, lCanChange, cFolder, cGroup, aComboValues, nMaxLenCombo, cIniBrow, lVirtual, cPictVar, lInsertLine )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Adicionando os campos do cabe็alho e o grid dos itens
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oView:AddField("VIEW_CABEC", oStruCabec, "CABECALHO")
	oView:AddGrid ("VIEW_ITENS", oStruItens, "ITENS")

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Criar um "box" horizontal para receber algum elemento da view e Setando o dimensionamento de tamanho
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oView:CreateHorizontalBox("SUPERIOR", 25)
	oView:CreateHorizontalBox("INFERIOR", 75)

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
	Local lIni :=.T.

	If nOp == MODEL_OPERATION_INSERT //C๓pia tamb้m ้ reconhecida como inser็ใo

		//oModel:SetValue("ITENS", "ZI_ITEM" , '001')

	EndIf

Return lIni

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldAcess     บAutor  ณJoao Rinaldi    บ Data ณ  10/12/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ A fun็ใo Acess define as permiss๕es de acesso a rotina     บฑฑ
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
Static Function VldAcess(oModel)

	Local lAcess   :=.T.
	Local _cGrp    := '000000/000209/000122/000091/000112/000015/000139'
	Local _aGrupos := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida็ใo de Grupo de Usuแrio para acesso aos bot๕es da rotina
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos  := PswRet()
	Endif

	DbSelectArea("SZH")
	SZH->(DbSetOrder(1)) //ZH_FILIAL+ZH_APROVP
	SZH->(DbGoTop())
	If !SZH->(DbSeek(xFilial("SZH")+AllTrim(__cUserId))) .And. !(AllTrim(SZH->ZH_APROVS)==AllTrim(__cUserId))

		//If !(_aGrupos[1][10][1] $ _cGrp)
		Help( ,, 'Help',, "Usuแrio sem permissใo para a rotina de "+cTitle+".";
			+CHR(10)+CHR(13)+;
			"A็ใo nใo permitida.";
			+CHR(10)+CHR(13)+;
			"Favor Verificar.",;
			1, 0 )
		lAcess :=.F.
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

	Local lVld        :=.T.

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

	Local lGrv        :=.T.

Return lGrv

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCOM018     บAutor  ณJoao Rinaldi    บ Data ณ  10/12/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ A fun็ใo STCOM018 ้ utilizada para realizar as marca็๕es   บฑฑ
ฑฑบ          ณ no Browse. Op็๕es de _nFlag:                               บฑฑ
ฑฑบ          ณ 1) Marca็ใo Item a Item                                    บฑฑ
ฑฑบ          ณ 2) Marca็ใo de todos os Itens                              บฑฑ
ฑฑบ          ณ 3) Aprova Itens Analisados                                 บฑฑ
ฑฑบ          ณ 4) Rejeita Itens Analisados                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STCOM010.prw                                               บฑฑ
ฑฑบNome      ณ Cadastro de Aprovadores de Solicita็ใo de Compras          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STCOM018(_nFlag,aAprova,cObsRep)

	Local aArea      := GetArea()
	Local aArea1     := SC1->(GetArea())
	Local aArea2     := SX5->(GetArea())
	Local _nMark     := 0
	Local _nDesMark  := 0
	Local cTexto1    := ''
	Local cTexto2    := ''
	Local _cMsg      := ''
	Local _aItens    := {}
	Local _nOpc      := 5
	Local _cNumSC    := ''
	Local _cSolic    := ''
	Local _aMotRej   := {}
	Local _cTabRej   := 'Z6'
	Local _cItem     := ''
	Local lSaida     :=.F.
	Local cGetMotivo := Space(TamSx3("C1_OBS")[1]+TamSx3("C1_OBS")[2])
	Local nOpcao     := 0
	//>>Chamado 006121 - Everson Santana
	Local _aSC1		:= {}
	Local n			:= 0
	Local _nX 		:= 0
	Default aAprova := {}
	Default cObsRep := ""
	//<<Chamado 006121 - Everson Santana
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ 1) Marca็ใo Item a Item
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _nFlag == 1
		If SC1->C1_ZSTATUS == '1'
			_cStatus := 'Analisado Pelo Gestor'
			_cMsg += "===================================" +CHR(13)+CHR(10)
			_cMsg += "Item de Solicita็ใo de Compra com Status '"+_cStatus+"' por: " +CHR(13)+CHR(10)
			_cMsg += "Usuแrio: "+cUserName+CHR(13)+CHR(10)
			_cMsg += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
			RecLock("SC1",.F.)
			SC1->C1_ZSTATUS := '2'
			SC1->C1_ZLOG    := SC1->C1_ZLOG + CHR(13)+ CHR(10) + _cMsg
			SC1->(MsUnlock())
		ElseIf SC1->C1_ZSTATUS == '2'
			_cStatus := 'Pendente de Aprova็ใo'
			_cMsg += "===================================" +CHR(13)+CHR(10)
			_cMsg += "Item de Solicita็ใo de Compra com Status '"+_cStatus+"' por: " +CHR(13)+CHR(10)
			_cMsg += "Usuแrio: "+cUserName+CHR(13)+CHR(10)
			_cMsg += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
			RecLock("SC1",.F.)
			SC1->C1_ZSTATUS := '1'
			SC1->C1_ZLOG    := SC1->C1_ZLOG + CHR(13)+ CHR(10) + _cMsg
			SC1->(MsUnlock())
		Else
			ApMsgInfo("Itens de Solicita็๕es Aprovadas ou Rejeitadas nใo podem mais serem manipuladas.";
				+CHR(10)+CHR(13)+;
				"A็ใo nใo permitida.",;
				"Aten็ใo." )
			RecLock("SC1",.F.)
			SC1->C1_ZMARKBR := '  '
			SC1->(MsUnlock())
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ 2) Marca็ใo de todos os Itens
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	ElseIf _nFlag == 2
		oMark:GoTop()
		dbSelectArea("SC1")
		SC1->(dbGoTop())
		While SC1->(!Eof())
			If SC1->C1_ZSTATUS == '2'
				_cStatus := 'Pendente de Aprova็ใo'
				_cMsg += "===================================" +CHR(13)+CHR(10)
				_cMsg += "Item de Solicita็ใo de Compra com Status '"+_cStatus+"' por: " +CHR(13)+CHR(10)
				_cMsg += "Usuแrio: "+cUserName+CHR(13)+CHR(10)
				_cMsg += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
				_nDesMark ++
				RecLock("SC1",.F.)
				SC1->C1_ZSTATUS := '1'
				SC1->C1_ZMARKBR := '  '
				SC1->C1_ZLOG    := SC1->C1_ZLOG + CHR(13)+ CHR(10) + _cMsg
				SC1->(MsUnlock())
			ElseIf SC1->C1_ZSTATUS == '1'
				_cStatus := 'Analisado Pelo Gestor'
				_cMsg += "===================================" +CHR(13)+CHR(10)
				_cMsg += "Item de Solicita็ใo de Compra com Status '"+_cStatus+"' por: " +CHR(13)+CHR(10)
				_cMsg += "Usuแrio: "+cUserName+CHR(13)+CHR(10)
				_cMsg += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
				_nMark ++
				RecLock("SC1",.F.)
				SC1->C1_ZSTATUS := '2'
				SC1->C1_ZMARKBR := oMark:Mark()
				SC1->C1_ZLOG    := SC1->C1_ZLOG + CHR(13)+ CHR(10) + _cMsg
				SC1->(MsUnlock())
			EndIf
			_cStatus := ''
			_cMsg    := ''
			SC1->(dbSkip())
		EndDo
		ApMsgInfo("Processamento finalizado com sucesso.";
			+CHR(10)+CHR(13)+;
			"Registros Analisados: " + cValtoChar(_nMark);
			+CHR(10)+CHR(13)+;
			"Registros Pendentes: " + cValtoChar(_nDesMark),;
			"Resumo do Processamento" )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ 3) Aprova Itens Analisados
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	ElseIf _nFlag == 3

		If FWIsInCallStack("U_ZAPVSC1P")

			dbSelectArea("SC1")
			SC1->(DbSetOrder(1))
			SC1->(dbGoTop())

			For _nX:=1 To Len(aAprova)

				SC1->(DbGoTo(Val(aAprova[_nX][1])))
				_cNum := SC1->C1_NUM
				While SC1->(!Eof()) .And. SC1->C1_NUM==_cNum

					//If SC1->C1_ZSTATUS == '2' retirado pois nใo tem a analise previa igual no ERP
					_cStatus := 'Aprovado Pelo Gestor'
					_cMsg := ""
					_cMsg += "===================================" +CHR(13)+CHR(10)
					_cMsg += "Item de Solicita็ใo de Compra com Status '"+_cStatus+"' por: " +CHR(13)+CHR(10)
					_cMsg += "Usuแrio: "+cUserName+CHR(13)+CHR(10)
					_cMsg += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
					RecLock("SC1",.F.)
					SC1->C1_ZSTATUS := '3'
					//>>Chamado 006694
					SC1->C1_ZDTAPRO := DDATABASE
					SC1->C1_ZHRAPRO := TIME()
					//<<
					SC1->C1_ZLOG    := SC1->C1_ZLOG + CHR(13)+ CHR(10) + _cMsg
					SC1->(MsUnlock())

					//>>Chamado 006121 - Everson Santana
					If !AScan( _aSC1, {|x| x[1] == SC1->C1_NUM}  )
						aadd(_aSC1,{SC1->C1_NUM, Alltrim(SC1->C1_XEMAIL)+' ; '+usrretmail(SC1->C1_USER)})
					EndIF
					//<<Chamado 006121 - Everson Santana
					//Endif
					_cStatus := ''
					_cMsg    := ''

					SC1->(DbSkip())
				EndDo

			Next

			//>> Chamado 006121 - Everson Santana
			For n:= 1 To Len(_aSC1)
				_cEmail := Alltrim(_aSC1[n][02])//SC1->C1_XEMAIL
				_cCopia := ""
				_cAssunto := 'Aprova็ใo de Solicita็ใo de Compra('+_aSC1[n][01]+')'
				cMsg := 'A solicita็ใo de compras ('+SC1->C1_NUM+') foi aprovada pelo Gestor'
				cAttach := ""
				U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

			Next

		Else

			oMark:GoTop()
			dbSelectArea("SC1")
			SC1->(dbGoTop())
			While SC1->(!Eof())
				If SC1->C1_ZSTATUS == '2'
					_nMark ++
				Endif
				SC1->( dbSkip() )
			End
			If (_nMark > 0)
				If _nMark == 1
					cTexto1 := "Existe apenas" + cValtoChar(_nMark) + " Item Analisado."
					cTexto2 := "Apenas " + cValtoChar(_nMark) + " Item continua com Status de Analisado."
				Else
					cTexto1 := "Existem " + cValtoChar(_nMark) + " Itens Analisados."
					cTexto2 := "Os " + cValtoChar(_nMark) + " Itens continuam com Status de Analisado."
				Endif
				If ApMsgYesNo(cTexto1;
						+CHR(10)+CHR(13)+;
						"Deseja Confirmar a Aprova็ใo?",;
						"Aprova็ใo")
					oMark:GoTop()
					dbSelectArea("SC1")
					SC1->(dbGoTop())
					While SC1->(!Eof())
						If SC1->C1_ZSTATUS == '2'
							_cStatus := 'Aprovado Pelo Gestor'
							_cMsg += "===================================" +CHR(13)+CHR(10)
							_cMsg += "Item de Solicita็ใo de Compra com Status '"+_cStatus+"' por: " +CHR(13)+CHR(10)
							_cMsg += "Usuแrio: "+cUserName+CHR(13)+CHR(10)
							_cMsg += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
							RecLock("SC1",.F.)
							SC1->C1_ZSTATUS := '3'
							//>>Chamado 006694
							SC1->C1_ZDTAPRO := DDATABASE
							SC1->C1_ZHRAPRO := TIME()
							//<<
							SC1->C1_ZLOG    := SC1->C1_ZLOG + CHR(13)+ CHR(10) + _cMsg
							SC1->(MsUnlock())

							//>>Chamado 006121 - Everson Santana
							If !AScan( _aSC1, {|x| x[1] == SC1->C1_NUM}  )
								aadd(_aSC1,{SC1->C1_NUM, Alltrim(SC1->C1_XEMAIL)+' ; '+usrretmail(SC1->C1_USER)})
							EndIF
							//<<Chamado 006121 - Everson Santana
						Endif
						_cStatus := ''
						_cMsg    := ''

						SC1->( dbSkip() )

					End

					//>> Chamado 006121 - Everson Santana
					For n:= 1 To Len(_aSC1)
						_cEmail := Alltrim(_aSC1[n][02])//SC1->C1_XEMAIL
						_cCopia := ""
						_cAssunto := 'Aprova็ใo de Solicita็ใo de Compra('+_aSC1[n][01]+')'
						cMsg := 'A solicita็ใo de compras ('+SC1->C1_NUM+') foi aprovada pelo Gestor'
						cAttach := ""
						U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

					Next
					//<< Chamado 006121 - Everson Santana
				Else
					ApMsgInfo(cTexto2,;
						"Aprova็ใo")
				Endif
			Else
				ApMsgInfo("Nใo existem itens a serem aprovados.",;
					"Aprova็ใo")
			Endif

		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ 4) Rejeita Itens Analisados
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	ElseIf _nFlag == 4

		If FWIsInCallStack("U_ZAPVSC1P") //Vindo via aprovador

			dbSelectArea("SC1")
			SC1->(DbSetOrder(1))
			SC1->(dbGoTop())

			For _nX:=1 To Len(aAprova)

				SC1->(DbGoTo(Val(aAprova[_nX][1])))

				If SC1->(Eof())
					Exit
				EndIf

				_cNum := SC1->C1_NUM
				Begin Transaction 
					While SC1->(!Eof()) .And. SC1->C1_NUM==_cNum

							//If SC1->C1_ZSTATUS == '2'

								_cStatus := 'Rejeitado Pelo Gestor'
								_cMsg := ""
								_cMsg += "===================================" +CHR(13)+CHR(10)
								_cMsg += "Item de Solicita็ใo de Compra com Status '"+_cStatus+"' por: " +CHR(13)+CHR(10)
								_cMsg += "Usuแrio: "+cUserName+CHR(13)+CHR(10)
								_cMsg += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
								_cMsg += "Observa็ใo: "+cObsRep+CHR(13)+CHR(10)
								_cMsg += "Motivo de Rejei็ใo: "+"000012" +CHR(13)+CHR(10)
								RecLock("SC1",.F.)
								SC1->C1_OBS     := Alltrim(SC1->C1_OBS) + " | " + Alltrim(cObsRep)
								SC1->C1_ZSTATUS := '4'
								SC1->C1_ZLOG    := SC1->C1_ZLOG + CHR(13)+ CHR(10) + _cMsg
								SC1->C1_ZMOTREJ := "000012"
								SC1->C1_QUJE    := SC1->C1_QUANT
								SC1->(MsUnlock())

								// Acrescentado atualizado do SB2 abaixo referente ao chamado 005150 - Robson Mazzarotto
								dbSelectArea("SB2")
								dbSetOrder(1)
								dbGoTop()
								if dbSeek(xFilial("SB2")+SC1->C1_PRODUTO+SC1->C1_LOCAL)
									RecLock("SB2",.F.)
									SB2->B2_SALPEDI  := SB2->B2_SALPEDI - SC1->C1_QUANT
									SB2->(MsUnlock())
								Endif

								_cZMot:= ' '
								DbSelectArea("SX5")
								SX5->(dbSetOrder(1))
								SX5->(dbSeek(xFilial("SX5") + 'Z6'))
								Do While SX5->(!EOF()).and. xFilial("SX5") = SX5->X5_FILIAL .And. SX5->X5_TABELA  = _cTabRej
									If SX5->X5_CHAVE  = SC1->C1_ZMOTREJ
										_cZMot:= ALLTRIM(SX5->X5_CHAVE)+' - '+ALLTRIM(SX5->X5_DESCRI)
									EndIf
									SX5->(DbSkip())
								EndDo

								//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
								//ณ Envio de e-mail por Solicita็ใo de Compras
								//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
								_cNumSC := SC1->C1_NUM
								_cSolic := SC1->C1_USER
								aAdd(_aItens,{ (SC1->C1_ITEM),;
									(SC1->C1_PRODUTO),;
									(SC1->C1_DESCRI),;
									(SC1->C1_UM),;
									(SC1->C1_QUANT),;
									(SC1->C1_MOTIVO),;
									Posicione("CTT",1,xFilial("CTT")+(SC1->C1_CC),"CTT_DESC01"),;
									(SC1->C1_OBS),;
									_cZMot})
								
								U_STCOM020(cusername,dtoc(date()),time(),_aItens,_cNumSC,_nOpc,__cUserId,_cSolic)
								
								_aItens := {}

							//Endif

						SC1->(DbSkip())
					EndDo
				End Transaction
			Next

		Else

			oMark:GoTop()
			dbSelectArea("SC1")
			SC1->(dbGoTop())
			While SC1->(!Eof())
				If SC1->C1_ZSTATUS == '2'
					_nMark ++
				Endif
				SC1->( dbSkip() )
			End
			If (_nMark > 0)
				If _nMark == 1
					cTexto1 := "Existe apenas" + cValtoChar(_nMark) + " Item Analisado."
					cTexto2 := "Apenas " + cValtoChar(_nMark) + " Item continua com Status de Analisado."
				Else
					cTexto1 := "Existem " + cValtoChar(_nMark) + " Itens Analisados."
					cTexto2 := "Os " + cValtoChar(_nMark) + " Itens continuam com Status de Analisado."
				Endif
				If ApMsgYesNo(cTexto1;
						+CHR(10)+CHR(13)+;
						"Deseja Confirmar a Rejei็ใo?",;
						"Rejei็ใo")

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Tela para que seja selecionado o motivo e texto livre para detalhar a Rejei็ใo
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					aAdd(_aMotRej,' ')
					DbSelectArea("SX5")
					SX5->(dbSetOrder(1))
					SX5->(dbSeek(xFilial("SX5") + _cTabRej))
					Do While SX5->(!EOF()).and. xFilial("SX5") = SX5->X5_FILIAL .And. SX5->X5_TABELA  = _cTabRej
						If SX5->X5_CHAVE >= '000501' .And. SX5->X5_CHAVE <= '000999'
							AADD(_aMotRej,ALLTRIM(SX5->X5_CHAVE)+' - '+ALLTRIM(SX5->X5_DESCRI))
						EndIf
						SX5->(DbSkip())
					EndDo
					If Len(_aMotRej) > 1
						Do While !lSaida

							Define msDialog oDxlg Title "Informar Motivo da Rejei็ใo" From 10,10 TO 250,400 Pixel

							@ 020,010 say "Observa็ใo da Rejei็ใo:" COLOR CLR_HBLUE  Of oDxlg Pixel
							@ 030,010 get cGetMotivo  size 165,08  Of oDxlg Pixel

							@ 050,010 Say "Motivo da Rejei็ใo:"   COLOR CLR_HBLUE  Of oDxlg Pixel
							@ 060,010 COMBOBOX _cItem ITEMS _aMotRej SIZE 165,08 Of oDxlg Pixel

							@ 090,085 Button "OK"    Size 28,12 Action Eval({||IF(!empty(alltrim(_cItem)),(lSaida:=.T.,oDxlg:End()),msgInfo("Motivo da Rejei็ใo nใo preenchido","Aten็ใo"))}) OF oDxlg Pixel

							Activate Dialog oDxlg Centered

						EndDo
					Else
						ApMsgInfo("O Departamento de Compras nใo cadastrou os Motivos de Rejei็ใo."+ Chr(10) + Chr(13) +;
							CHR(10)+CHR(13)+;
							"Os Itens analisados nใo serใo rejeitados.",;
							"Rejei็ใo")
						Return
					Endif
					oMark:GoTop()
					dbSelectArea("SC1")
					SC1->(dbGoTop())
					Begin Transaction 
						While SC1->(!Eof())
							If SC1->C1_ZSTATUS == '2'
								_cStatus := 'Rejeitado Pelo Gestor'
								_cMsg += "===================================" +CHR(13)+CHR(10)
								_cMsg += "Item de Solicita็ใo de Compra com Status '"+_cStatus+"' por: " +CHR(13)+CHR(10)
								_cMsg += "Usuแrio: "+cUserName+CHR(13)+CHR(10)
								_cMsg += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
								_cMsg += "Observa็ใo: "+cGetMotivo+CHR(13)+CHR(10)
								_cMsg += "Motivo de Rejei็ใo: "+_cItem +CHR(13)+CHR(10)
								RecLock("SC1",.F.)
								SC1->C1_OBS     := Alltrim(SC1->C1_OBS) + " | " + Alltrim(cGetMotivo)
								SC1->C1_ZSTATUS := '4'
								SC1->C1_ZLOG    := SC1->C1_ZLOG + CHR(13)+ CHR(10) + _cMsg
								SC1->C1_ZMOTREJ := Substr(_cItem,1,6)
								SC1->C1_QUJE    := SC1->C1_QUANT
								SC1->(MsUnlock())
								// Acrescentado atualizado do SB2 abaixo referente ao chamado 005150 - Robson Mazzarotto
								dbSelectArea("SB2")
								dbSetOrder(1)
								dbGoTop()
								if dbSeek(xFilial("SB2")+SC1->C1_PRODUTO+SC1->C1_LOCAL)
									RecLock("SB2",.F.)
									SB2->B2_SALPEDI  := SB2->B2_SALPEDI - SC1->C1_QUANT
									SB2->(MsUnlock())
								Endif

								_cZMot:= ' '
								DbSelectArea("SX5")
								SX5->(dbSetOrder(1))
								SX5->(dbSeek(xFilial("SX5") + 'Z6'))
								Do While SX5->(!EOF()).and. xFilial("SX5") = SX5->X5_FILIAL .And. SX5->X5_TABELA  = _cTabRej
									If SX5->X5_CHAVE  = SC1->C1_ZMOTREJ
										_cZMot:= ALLTRIM(SX5->X5_CHAVE)+' - '+ALLTRIM(SX5->X5_DESCRI)
									EndIf
									SX5->(DbSkip())
								EndDo

								//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
								//ณ Envio de e-mail por Solicita็ใo de Compras
								//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
								If _nMark == 1
									_cNumSC := SC1->C1_NUM
									_cSolic := SC1->C1_USER
									aAdd(_aItens,{ (SC1->C1_ITEM),;
										(SC1->C1_PRODUTO),;
										(SC1->C1_DESCRI),;
										(SC1->C1_UM),;
										(SC1->C1_QUANT),;
										(SC1->C1_MOTIVO),;
										Posicione("CTT",1,xFilial("CTT")+(SC1->C1_CC),"CTT_DESC01"),;
										(SC1->C1_OBS),;
										_cZMot})
									Processa({||U_STCOM020(cusername,dtoc(date()),time(),_aItens,_cNumSC,_nOpc,__cUserId,_cSolic),"Enviando E-mail." })
									_aItens := {}
								Else
									If Empty(_cNumSC)
										_cNumSC := SC1->C1_NUM
									Endif

									If (_cNumSC == SC1->C1_NUM)
										_cSolic := SC1->C1_USER

										aAdd(_aItens,{ (SC1->C1_ITEM),;
											(SC1->C1_PRODUTO),;
											(SC1->C1_DESCRI),;
											(SC1->C1_UM),;
											(SC1->C1_QUANT),;
											(SC1->C1_MOTIVO),;
											Posicione("CTT",1,xFilial("CTT")+(SC1->C1_CC),"CTT_DESC01"),;
											(SC1->C1_OBS),;
											_cZMot })
									Else
										Processa({||U_STCOM020(cusername,dtoc(date()),time(),_aItens,_cNumSC,_nOpc,__cUserId,_cSolic),"Enviando E-mail." })
										_aItens := {}
										_cNumSC := SC1->C1_NUM
										_cSolic := SC1->C1_USER
										aAdd(_aItens,{ (SC1->C1_ITEM),;
											(SC1->C1_PRODUTO),;
											(SC1->C1_DESCRI),;
											(SC1->C1_UM),;
											(SC1->C1_QUANT),;
											(SC1->C1_MOTIVO),;
											Posicione("CTT",1,xFilial("CTT")+(SC1->C1_CC),"CTT_DESC01"),;
											(SC1->C1_OBS),;
											_cZMot })
									Endif
								Endif
							Endif
							SC1->( dbSkip() )
							_cStatus := ''
							_cMsg    := ''
						End
					End Transaction
					If Len(_aItens) > 0
						Processa({||U_STCOM020(cusername,dtoc(date()),time(),_aItens,_cNumSC,_nOpc,__cUserId,_cSolic),"Enviando E-mail." })
					Endif
				Else
					ApMsgInfo(cTexto2,;
						"Rejei็ใo")
				Endif
			Else
				ApMsgInfo("Nใo existem itens a serem rejeitados.",;
					"Rejei็ใo")
			Endif

		EndIf

	Endif

	RestArea(aArea2)
	RestArea(aArea1)
	RestArea(aArea)

	If !IsBlind()
		oMark:Refresh()
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ XULTPRC  บAutor  ณRichard N. Cabral   บ Data ณ  02/03/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo desenvolvida para calcular o valor total da         บฑฑ
ฑฑบ          ณ solicitaao pelo ultimo preco de comptas                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 005830 - Tela de aprovacao de SC trazer ultimo preco compraบฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function XULTPRC()

	Local nRet		:= 0
	Local cSC		:= SC1->C1_NUM
	Local cQuery	:= ""

	cQuery += " SELECT B1_UPRC, C1_QUANT FROM " + RetSqlName("SC1") + " SC1 "
	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = C1_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE C1_FILIAL = '" + xFilial("SC1") + "' "
	cQuery += " AND C1_NUM = '" + cSC + "' "
	cQuery += " AND SC1.D_E_L_E_T_ = ' ' "

	TCQUERY cQuery NEW ALIAS "TMPSC1"

	TMPSC1->(DbGotop())

	Do While ! TMPSC1->(Eof())
		nRet += ( B1_UPRC * C1_QUANT )
		TMPSC1->(DbSkip())
	EndDo

	dbSelectArea("TMPSC1")
	dbCloseArea()

Return(nRet)
