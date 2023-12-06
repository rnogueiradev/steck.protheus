#include 'FWMVCDEF.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#Define CR chr(13)+chr(10)

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½?ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  STZ49    ï¿½Autor  ï¿½Giovani Zago    ï¿½ Data ï¿½  16/08/19    	  ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½?ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ 		Controle de Avaliaï¿½ï¿½o					              ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½?ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ AP                                                         ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½?ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/
User Function STZ49()

	Local aArea1    := GetArea()
	
	Local aArea2    := Z49->(GetArea())
	Local _cAlias1  := "Z49"
	Local _cFiltro  := " "
	Local _cQuery1	:= " "
	Private cTitle  := "Controle de Avalição"
	Private cChaveAux := ""
	Private _cGrp   := ' '
	Private _cCID   := "MODZ49"
	Private _cSSID  := "STZ49"
	Private aRotina := MenuDef(_cSSID)
	Private oBrowse
	Private _UsrRh  := GetMv('ST_STZ49',,'001013#001039')


	oBrowse := FWMBrowse():New()

	oBrowse:SetAlias(_cAlias1)


	If !__cUserId $ _UsrRh
	
		Z49->(dbSetFilter({|| (  Z49->Z49_USER = __cUserId ) },' Z49->Z49_USER = __cUserId '))

	EndIf

	oBrowse:SetWalkThru(.F.)
	oBrowse:SetAmbiente(.F.)
	oBrowse:SetUseFilter(.T.)
	oBrowse:SetDescription(cTitle)

	oBrowse:SetFilterDefault( _cFiltro )

	oBrowse:AddLegend("Z49_STATUS=='1'" ,"GREEN"   ,"Incluido")
	oBrowse:AddLegend("Z49_STATUS=='2'" ,"YELLOW"  ,"Aguardando Aprovaï¿½ï¿½o")
	oBrowse:AddLegend("Z49_STATUS=='3'" ,"RED"     ,"Aguardando RH")
	oBrowse:AddLegend("Z49_STATUS=='4'" ,"BLACK"   ,"Encerrado")
	oBrowse:AddLegend("Z49_STATUS=='5'" ,"PINK"    ,"Cancelado")
	oBrowse:DisableDetails()

	oBrowse:Activate()

	RestArea(aArea2)
	RestArea(aArea1)

Return

Static Function MenuDef(_cSSID)

	Local _cProgram := ALLTRIM(UPPER(funname()))
	Local aRotina   := {}

	If !Empty(_cProgram)
		//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½?
		//ï¿½Opï¿½ï¿½es padrï¿½es do MVC
		// 1 para Pesquisar
		// 2 para Visualizar
		// 3 para Incluir
		// 4 para Alterar
		// 5 para Excluir
		// 6 para Imprimir
		// 7 para Copiar
		// 8 Opï¿½ï¿½es Customizadas
		//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
		ADD OPTION aRotina TITLE "Pesquisar"    	ACTION "PESQBRW"       	OPERATION 1  ACCESS 0
		ADD OPTION aRotina TITLE "Visualizar"   	ACTION "VIEWDEF.STZ49" 	OPERATION 2  ACCESS 0
		ADD OPTION aRotina TITLE "Incluir"      	ACTION "VIEWDEF.STZ49" 	OPERATION 3  ACCESS 0
		ADD OPTION aRotina TITLE "Alterar"      	ACTION "VIEWDEF.STZ49" 	OPERATION 4  ACCESS 0
		ADD OPTION aRotina TITLE "Aprovar"  		ACTION "U_STAPZ49()" 	OPERATION 8  ACCESS 0  
		ADD OPTION aRotina TITLE "Anexo"  	    	ACTION "U_ANEX02(.T.)" 	OPERATION 8  ACCESS 0  
		ADD OPTION aRotina TITLE "Gerar Planilha"  	ACTION "U_ImpExcel()" 	OPERATION 8  ACCESS 0   // Valdemir Rabelo 28/11/2019
		ADD OPTION aRotina TITLE "Cancelar"  		ACTION "U_Z49CAN()" 	OPERATION 8  ACCESS 0   
		//ADD OPTION aRotina TITLE "Excluir"      ACTION "VIEWDEF.STZ49" OPERATION 5  ACCESS 0 
	Endif
Return aRotina


Static Function ModelDef()

	Local oStruCabec := FWFormStruct(1, "Z49")// Construï¿½ï¿½o de estrutura de dados
	Local oModel
	Local _cTitulo   := cTitle
	Local _cCabec    := cTitle

	oModel := MPFormModel():New(_cCID  , /*bPreValidacao*/ ,  { | oModel | VldTOK( oModel ) }  ,  { | oModel | GrvTOK( oModel ) }  , /*bCancel*/ )
	oModel:AddFields("CABECALHO", /*cOwner*/, oStruCabec)

	oModel:SetPrimaryKey({})
	oModel:SetDescription(_cTitulo)
	oModel:GetModel("CABECALHO"):SetDescription(_cCabec)
	oModel:SetActivate( {|oMod| IniPad(oMod)} )

	oModel:SetVldActivate ( { |oMod| VldAcess( oMod ) } )

Return oModel


Static Function ViewDef()

	Local oStruCabec := FWFormStruct(2, "Z49")
	Local oModel     := FWLoadModel(_cSSID)
	Local oView

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField("VIEW_CABEC", oStruCabec, "CABECALHO")

	oView:CreateHorizontalBox("SUPERIOR", 100)

	oView:SetOwnerView("VIEW_CABEC", "SUPERIOR")

	oView:SetCloseOnOk({||.T.})

	oView:EnableTitleView("VIEW_CABEC")


Return oView



Static Function IniPad(oModel)

	Local lIni := .T.

Return lIni


Static Function VldAcess(oModel)

	Local lAcess    := .T.




Return (lAcess)


Static Function VldTOK( oModel )

	Local lVld      := .T.
	Local nOp 		:= oModel:GetOperation()



Return lVld


Static Function GrvTOK( oModel )

	Local nOp         := oModel:GetOperation()
	Local lGrv        := .T. 

	FWFormCommit( oModel )

	Reclock("Z49",.F.)
	If nOp == MODEL_OPERATION_INSERT //Cï¿½pia tambï¿½m ï¿½ reconhecida como inserï¿½ï¿½o
		Z49->Z49_LOG:= 'Inserido por: '+__cuserid+ '-'+ cUserName+CR+ dtoc(date())+' - '+ time()+CR+CR + Alltrim(Z49->Z49_LOG) 
	Else
		Z49->Z49_LOG:= 'Alterado por: '+__cuserid+ '-'+ cUserName+CR+ dtoc(date())+' - '+ time()+CR+CR + Alltrim(Z49->Z49_LOG)
	EndIf	 

	Z49->(MsUnLock())
	Z49->( DbCommit())



Return lGrv




User Function ANEX02(_lT)

	//Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Â¿
	//Â³DeclaraÃ§Ã£o das Variï¿½veis
	//Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?
	Local aArea       := GetArea()
	Local aArea1      := Z49->(GetArea())

	Local n           := 0
	Local lSaida      := .f.
	Local nOpcao      := 0
	Local oDxlg
	Local _cAne01     := ''
	Local _cAne02     := ''
	Local _cAne03     := ''
	Local _cAne04     := ''
	Local _cAne05     := ''
	Local _nLin       := 000
	Local cSolicit	  := 	Z49->Z49_COD

	Private _cPath      := GetSrvProfString("RootPath","")
	Private _cStartPath := "\arquivos\"
	Private _cEmp       := 'Controle Avalicacao\'
	Private _cFil       := ' '//""+Z49->Z49_XFIL+"\"
	Private _cNUm       := ""+cSolicit+"\"
	Private _cServerDir   := ''
	Default _lT := .f.
	If !_lT
		If Inclui
			MsgInfo("Anexo so pode ser incluido apos a Gravaï¿½ï¿½o...!!!!")
			Return()
		EndIf
	EndIf
	//Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Â¿
	//Â³ CriaÃ§Ã£o das pastas para salvar os anexos das SolicitaÃ§Ãµes de Compras no Servidor
	//Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?
	_cServerDir += (_cStartPath)
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	_cServerDir += _cEmp
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	_cServerDir += _cFil
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	_cServerDir += _cNUm
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	If ExistDir(_cServerDir)

		If Len(Directory(_cServerDir+Strzero(1,6)+".mzp")) = 1
			_cAne01 := Strzero(1,6)+".mzp"
		Else
			_cAne01 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(2,6)+".mzp")) = 1
			_cAne02 := Strzero(2,6)+".mzp"
		Else
			_cAne02 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(3,6)+".mzp")) = 1
			_cAne03 := Strzero(3,6)+".mzp"
		Else
			_cAne03 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(4,6)+".mzp")) = 1
			_cAne04 := Strzero(4,6)+".mzp"
		Else
			_cAne04 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(5,6)+".mzp")) = 1
			_cAne05 := Strzero(5,6)+".mzp"
		Else
			_cAne05 := space(90)
		Endif

		DbSelectArea("Z49")
		Z49->(DbSetOrder(1))//Z49_FILIAL+Z49_COD+Z49_ITEM
		If Z49->(DbSeek(xFilial("Z49")+cSolicit))

			cNameSolic := USRRETNAME(Z49->Z49_USER)

			Do While !lSaida
				nOpcao := 0

				Define msDialog oDxlg Title "Selecione os Anexos " From 10,10 TO 450,600 Pixel
				_nLin := 005
				@ _nLin,010 say "Filial" COLOR CLR_BLACK  Of oDxlg Pixel
				@ _nLin,040 get xFilial("Z49") when .f. size 050,08  Of oDxlg Pixel

				//@ _nLin,110 say "Data SC" COLOR CLR_BLACK   Of oDxlg Pixel
				//@ _nLin,140 get  dDtEmiss  when .f. size 090,08  Of oDxlg Pixel

				_nLin := _nLin + 10
				@ _nLin,010 say "Nï¿½ Controle" COLOR CLR_BLACK    Of oDxlg Pixel
				@ _nLin,040 get cSolicit  when .f. size 050,08  Of oDxlg Pixel

				@ _nLin,110 say "Solicitante" COLOR CLR_BLACK   Of oDxlg Pixel
				@ _nLin,140 get  cNameSolic  when .f. size 090,08  Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 01"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne01     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne01:=SaveAnexo(1,_cAne01,cSolicit)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne01:=DelAnexo (1,_cAne01,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne01:=OpenAnexo(1,_cAne01,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 02"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne02     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne02:=SaveAnexo(2,_cAne02,cSolicit)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne02:=DelAnexo (2,_cAne02,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne02:=OpenAnexo(2,_cAne02,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 03"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne03     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne03:=SaveAnexo(3,_cAne03,cSolicit)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne03:=DelAnexo (3,_cAne03,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne03:=OpenAnexo(3,_cAne03,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 04"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne04     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne04:=SaveAnexo(4,_cAne04,cSolicit)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne04:=DelAnexo (4,_cAne04,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne04:=OpenAnexo(4,_cAne04,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 05"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne05     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne05:=SaveAnexo(5,_cAne05,cSolicit)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne05:=DelAnexo (5,_cAne05,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne05:=OpenAnexo(5,_cAne05,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20

				DEFINE SBUTTON FROM _nLin,130 TYPE 1 ACTION (lSaida:=.T.,nOpcao:=1,oDxlg:End()) ENABLE OF oDxlg
				//DEFINE SBUTTON FROM 200,160 TYPE 2 ACTION (lSaida:=.T.,nOpcao:=2,oDxlg:End()) ENABLE OF oDxlg

				Activate dialog oDxlg centered

			EndDo

		EndIf

	Endif

	RestArea(aArea1)
	RestArea(aArea)

Return()



Static Function SaveAnexo(_nSave,_cFile,cSolicit)

	Local _cSave := ''
	Local _lRet     := .T.
	Local _cLocArq  := ''
	Local _cDir     := ''
	Local _cArq     := ''
	Local cExtensao := ''
	Local nTamOrig  := ''
	Local nMB       := 1024
	Local nTamMax   := 5
	Local cMascara  := "Todos os arquivos"
	Local cTitulo   := "Escolha o arquivo"
	Local nMascpad  := 0
	Local cDirini   := "c:\"
	Local lSalvar   := .T. /*.F. = Salva || .T. = Abre*/
	Local lArvore   := .F. /*.T. = apresenta o ï¿½rvore do servidor || .F. = nÃ£o apresenta*/
	Local _cMsgSave := ""
	Local aArea1    := GetArea()
	Local aArea2    := Z49->(GetArea())



	_cLocArq  := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar,, lArvore)

	If !(Empty(_cLocArq))
		nTamOrig := Directory(_cLocArq)[1,2]
		If (nTamOrig/nMB) > (nMB*nTamMax)
			Aviso("Tamanho do Arquivo Superior ao Permitido"; //01 - cTitulo - TÃ­tulo da janela
			,"O Arquivo '"+_cArq+"' tem que ter tamanho mï¿½ximo de "+cValtoChar(nTamMax)+"MB."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"Anexo nï¿½o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
			,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automï¿½tica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
			,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
			,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
			)
			Return
		EndIf

		If Len(Directory(_cServerDir+Strzero(_nSave,6)+".mzp")) = 1
			_lRet := MsgYesNo("Jï¿½ existe um arquivo anexado."+ Chr(10) + Chr(13) +" Deseja sobrepor o arquivo existente ???","Atenï¿½ï¿½o")
		Endif

		If _lRet

			_cLocArq  := Alltrim(_cLocArq)
			_cDir     := SUBSTR(_cLocArq, 1                      ,RAT( "\"   , _cLocArq ))
			_cArq     := SUBSTR(_cLocArq, RAT( "\"   , _cLocArq ),Len(_cLocArq))
			_cArq     := StrTran(_cArq,"\","")
			cExtensao := SUBSTR(_cLocArq,Rat(".",_cLocArq),Len(_cLocArq))

			If At(".",cExtensao) == 1

				_cSave := Strzero(_nSave,6)

				//Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã??Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Â¿
				//Â³ Copio o arquivo original da mï¿½quina do usuï¿½rio para o servidor
				//Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?
				lSucess   := __CopyFile(_cLocArq,_cServerDir+_cSave+cExtensao)

				If lSucess

					//Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Â¿
					//Â³ Realizo a compactaÃ§Ã£o do arquivo para a extensÃ£o .mzp
					//Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?
					MsCompress((_cServerDir+_cSave+cExtensao),(_cServerDir+_cSave+".mzp"))

					//Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Â¿
					//Â³ Apago o arquivo original do servidor
					//Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?
					Ferase( _cServerDir+_cSave+cExtensao)
					Aviso("Anexar Arquivo"; //01 - cTitulo - TÃ­tulo da janela
					,"O Arquivo '"+_cArq+"' foi anexado com sucesso.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
					,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automï¿½tica
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
					,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
					,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
					)
					_cSave += ".mzp"
					_cMsgSave += "===================================" +CHR(13)+CHR(10)
					_cMsgSave += "Documento "+Alltrim(_cArq)+" anexado com sucesso por: " +CHR(13)+CHR(10)
					_cMsgSave += "Usuï¿½rio: "+cUserName+CHR(13)+CHR(10)
					_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
					dbSelectArea("Z49")
					Z49->(dbGoTop())
					While Z49->(!EOF()) .And. cSolicit = Z49->Z49_COD .And. Z49->Z49_FILIAL = xfilial("Z49")
						RecLock("Z49", .F.)
						Z49->Z49_LOG    :=  _cMsgSave   + CHR(13)+ CHR(10) + Z49->Z49_LOG
						Z49->(MsUnlock())
						Z49->( dbSkip() )
					End
				Else
					_cSave := ''
					Aviso("Problema ao Anexar Arquivo"; //01 - cTitulo - TÃ­tulo da janela
					,"O Arquivo '"+_cArq+"' nï¿½o foi anexado."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Favor verificar com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
					,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automï¿½tica
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
					,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
					,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
					)
				EndIf
			Else
				Aviso("Problema com ExtensÃ£o do Anexo"; //01 - cTitulo - TÃ­tulo da janela
				,"A Extensï¿½o "+cExtensao+" ï¿½ invï¿½lida para anexar junto a Solicitaï¿½ï¿½o de Compras."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Anexo nï¿½o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
				,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automï¿½tica
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
				,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
				,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
				)
			Endif
		Else
			_cSave := _cFile
		Endif

	Else
		_cSave := _cFile
		Aviso("Anexar Arquivo"; //01 - cTitulo - TÃ­tulo da janela
		,"Nenhum Arquivo foi selecionado para ser anexado.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automï¿½tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
		,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
		)
	Endif

	RestArea(aArea2)
	RestArea(aArea1)

Return(_cSave)

Static Function DelAnexo(_nDel,_cFile,cSolicit)

	Local _cDelete := ''
	Local _lRet    := .T.
	Local _cMsgDel := ""
	Local aArea1   := GetArea()
	Local aArea2   := Z49->(GetArea())

	If Len(Directory(_cServerDir+_cFile)) = 1
		_lRet := MsgYesNo("Deseja deletar o Arquivo ??? "+ Chr(10) + Chr(13) +" Uma vez confirmada essa aï¿½ï¿½o o arquivo nï¿½o ficarï¿½ mais disponï¿½ï¿½vel para consulta.","Atenï¿½ï¿½o")
	Else
		_lRet := .F.
		Aviso("Deletar Anexo"; //01 - cTitulo - TÃ­tulo da janela
		,"Nï¿½o existe nenhum Arquivo para ser deletado."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"Anexo nï¿½o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automï¿½tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
		,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
		)
	Endif

	If _lRet
		Ferase( _cServerDir+_cFile)
		_cDelete := ''
		_cMsgDel += "===================================" +CHR(13)+CHR(10)
		_cMsgDel += "Documento "+Alltrim(_cFile)+" deletado com sucesso por: " +CHR(13)+CHR(10)
		_cMsgDel += "Usuï¿½rio: "+cUserName+CHR(13)+CHR(10)
		_cMsgDel += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
		dbSelectArea("Z49")
		Z49->(dbGoTop())
		While Z49->(!EOF()) .And. cSolicit = Z49->Z49_COD .And. Z49->Z49_FILIAL = xfilial("Z49")
			RecLock("Z49", .F.)
			Z49->Z49_LOG   :=  _cMsgDel   + CHR(13)+ CHR(10) + Z49->Z49_LOG
			Z49->(MsUnlock())
			Z49->( dbSkip() )
		End
	Else
		_cDelete := _cFile
	Endif

	RestArea(aArea2)
	RestArea(aArea1)

Return (_cDelete)

Static Function OpenAnexo(_nOpen,_cFile,cSolicit)

	Local _cOpen      := ''
	Local cZipFile    := ''
	Local _cSaveArq   := "C:\ARQUIVOS_PROTHEUS\"
	Local _cLocalDir  := ''
	Local _cStartPath := "arquivos\"
	Local _cStartPath1 := "Controle Avalicacao\"
	Local _lUnzip     := .T.

	//Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Â¿
	//Â³ CriaÃ§Ã£o das pastas para salvar os anexos das SolicitaÃ§Ãµes de Compras na mï¿½quina Local do usuï¿½rio
	//Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?
	_cLocalDir += (_cSaveArq)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += (_cStartPath)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif


	_cLocalDir += (_cStartPath1)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += _cNUm+"\"
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	If ExistDir(_cLocalDir)
		_cOpen   := Strzero(_nOpen,6)+".mzp"
		cZipFile := _cServerDir+_cOpen
		If Len(Directory(cZipFile)) = 1
			CpyS2T  ( cZipFile , _cLocalDir, .T. )
			_lUnzip := MsDecomp( _cLocalDir+_cOpen , _cLocalDir )
			If _lUnzip
				Ferase  ( _cLocalDir+_cOpen)
				ShellExecute("open", _cLocalDir, "", "", 1)
			Else
				Aviso("Erro para Descompactar Anexo"; //01 - cTitulo - TÃ­tulo da janela
				,"Houve erro para Descompactar o Anexo."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
				,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automï¿½tica
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
				,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
				,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
				)
			Endif
		Else
			_cOpen  := _cFile
			Aviso("Anexo invï¿½lido"; //01 - cTitulo - TÃ­tulo da janela
			,"NÃ£o existe nenhum anexo no Protheus para ser aberto."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"AÃ§Ã£o nÃ£o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
			,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automï¿½tica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
			,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
			,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
			)
		Endif
	Else
		Aviso("Erro ao Salvar Anexo"; //01 - cTitulo - TÃ­tulo da janela
		,"Houve erro ao Salvar o Anexo."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automï¿½tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
		,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
		)
	Endif

Return (_cOpen)



User Function STAPZ49()
	Local _cMsgSave	:= ' '
	Local _cPara 	:= ' '
	Local _cCop 	:= ' '
	Local _UserPerm := GetMv('ST_Z4901',,'000000/000645/001177')	// Permissï¿½o para Aprovaï¿½ï¿½es
	Local _MailGes  := GetMv('ST_Z4902',,'')     		// Gestor
	Local _UserEng  := GetMv('ST_Z4903',,'001177')  	// Usuario
	Local _MailRH   := GetMv('ST_Z4904',,'001177')    	// RH


	If Z49->Z49_STATUS = '1' 
		If Z49->Z49_USER = __cUserId
			If	MsgYesNo("Deseja enviar para Aprovaï¿½ï¿½o do Gestor ?")
				_cMsgSave += "===================================" +CR
				_cMsgSave += "Enviado Para Aprovaï¿½ï¿½o do Gestor. " +CR
				_cMsgSave += "Usuï¿½rio: "+cUserName+CR
				_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR


				_cPara:=  _MailGes
				_cCop :=  UsrRetMail(Z49->Z49_USER)


				STWF48("Fluxo de Avaliaï¿½ï¿½o: "+Z49->Z49_COD+", Enviado para Aprovaï¿½ï¿½o do Gestor.",_cPara,_cCop)
				RecLock("Z49", .F.)
				Z49->Z49_LOG    :=  _cMsgSave + CR + Z49->Z49_LOG
				Z49->Z49_STATUS := '2' 
				Z49->(MsUnlock())
				Z49->(DbCommit())

			EndIf
		Else
			MsgInfo('Apenas o Usuario: '+Alltrim(USRRETNAME(Z49->Z49_USER))+' , pode enviar para a Aprovaï¿½ï¿½o do Gestor')
		EndIf

	ElseIf Z49->Z49_STATUS = '2'

		If __cuserid $ _UserPerm  

			If	MsgYesNo("Deseja Aprovar e enviar para RH?")
				_cMsgSave += "===================================" +CR
				_cMsgSave += "Aprovado e enviado para RH. " +CR
				_cMsgSave += "Usuï¿½rio: "+cUserName+CR
				_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

				_cCop :=  UsrRetMail(Z49->Z49_USER)+' ; '+UsrRetMail(__cuserid)
				_cPara:= _MailRH

				STWF48("Fluxo de Avalicaï¿½ï¿½o: "+Z49->Z49_COD+", Aprovado e Enviado para RH.",_cPara,_cCop)
				RecLock("Z49", .F.)
				Z49->Z49_APROV  := __cuserid
				Z49->Z49_DTAPRO := dDatabase
				Z49->Z49_TIMEAP := TIME()				 
				Z49->Z49_LOG    :=  _cMsgSave + CR + Z49->Z49_LOG
				Z49->Z49_STATUS := '3'
				Z49->(MsUnlock())
				Z49->(DbCommit())


			EndIf
		Else
			MsgInfo('Apenas Gestores podem Aprovar a Avaliaï¿½ï¿½o....!!!!')
		EndIf

	ElseIf Z49->Z49_STATUS = '3'

		If !(__cUserId $ _UserEng)
			MsgInfo("Voce nao ï¿½ o aprovador !!!!!!!")
		Else


			If	MsgYesNo("Deseja Encerrar a avaliaï¿½ï¿½o ?")
				_cMsgSave += "===================================" +CR
				_cMsgSave += "Avalicaï¿½ï¿½o Encerrada. " +CR
				_cMsgSave += "Usuï¿½rio: "+cUserName+CR
				_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

				_cCop := UsrRetMail(__cuserid)
				_cPara:= UsrRetMail(Z49->Z49_USER)

				STWF48("Fluxo: "+Z49->Z49_COD+", Encerramento.",_cPara,_cCop)

				RecLock("Z49", .F.)
				Z49->Z49_LOG    :=   _cMsgSave + CR + Z49->Z49_LOG
				Z49->Z49_STATUS := '4'
				Z49->Z49_RHAPR  := __cuserid
				Z49->Z49_RHDT   := dDatabase
				Z49->Z49_RHHORA := TIME()
				Z49->(MsUnlock())
				Z49->(DbCommit())


			EndIf
		Endif
	EndIf

	Return


	*------------------------------------------------------------------*
Static Function STWF48(_cAssunto,_cEmail,_cCopia )
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local cFuncSent:= "STWF49"
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
	Local _aMsg    :={}

	Aadd( _aMsg , { "Numero: "          , Z49->Z49_COD } )
	Aadd( _aMsg , { "Nome: "    		, Z49->Z49_NOME } )
	//Aadd( _aMsg , { "Unicom: "    		, Z49->Z49_UNICOM } )
	//Aadd( _aMsg , { "Obra: "    		, Z49->Z49_OBRA } )
	Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
	Aadd( _aMsg , { "Hora: "    		, time() } )
	Aadd( _aMsg , { "Usuario: "    		, Alltrim(USRRETNAME(Z49->Z49_USER)) } ) 

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½?
		//ï¿½ Definicao do cabecalho do email                                             ï¿½
		//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½?
		//ï¿½ Definicao do texto/detalhe do email                                         ï¿½
		//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf


			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

		Next

		//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½?
		//ï¿½ Definicao do rodape do email                                                ï¿½
		//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)


	EndIf
	RestArea(aArea)
Return()

User Function Z49CAN()
	Local _cMsgSave	:= ' '
	Local _UserPerm  := GetMv('ST_Z4901',,'000000/000645/')
	Local _MailGes  := GetMv('ST_Z4902',,'FILIPE.NASCIMENTO@STECK.COM.BR') + "; bruno.galvao@steck.com.br"

	If __cuserid $ _UserPerm  

		If	MsgYesNo("Deseja Cancelar a Avalicaï¿½ï¿½o ?")
			_cMsgSave += "===================================" +CR
			_cMsgSave += "Avaliaï¿½ï¿½o Cancelada. " +CR
			_cMsgSave += "Usuï¿½rio: "+cUserName+CR
			_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

			_cCop := UsrRetMail(__cuserid)
			_cPara:= UsrRetMail(Z49->Z49_USER)

			STWF48("Fluxo de Avaliaï¿½ï¿½o: "+Z49->Z49_COD+", Cancelamento.",_cPara,_cCop)

			RecLock("Z49", .F.)
			Z49->Z49_LOG    :=   _cMsgSave + CR + Z49->Z49_LOG
			Z49->Z49_STATUS := '5'
			Z49->(MsUnlock())
			Z49->(DbCommit())


		EndIf
	Else
		MsgInfo('Apenas Gestores podem Cancelar a CI....!!!!')
	EndIf



	Return()

	/*/{Protheus.doc} ImpExcel
	Rotina Chamada da geraï¿½ï¿½o da Avaliaï¿½ï¿½o
	@author Valdemir Rabelo
	@since 28/11/2019
	*/ 
	User Function ImpExcel()
	FWMsgRun(,{|| u_stexpaval()},"Informativo","Gerando planilha, aguarde.")

	Return