#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"

/*/{Protheus.doc} STCHND05
description
Rotina para efetuar o cadastro de itens para 
Etiqueta Schneider
@type function
@version  
@author Valdemir Jose
@since 29/04/2021
@return return_type, return_description
/*/
USER FUNCTION STCHND05()
	Local oMBrowse
    Local oDlg        := Nil
    Private cCadastro := "Itens Schneider"
    Private INCLUI    := .f.

    oSize := FwDefSize():New(.F.)

    oSize:AddObject( "CABECALHO",(oSize:aWindSize[4]),(oSize:aWindSize[3]) , .F., .F. ) // Não dimensionavel
    oSize:aMargins 	:= { 3, 3, 3, 3  } 	// Espaco ao lado dos objetos 0, entre eles 3		
    oSize:lProp 		:= .F. 			// Proporcional             
    oSize:Process() 	   				// Dispara os calculos  

    DEFINE MSDIALOG oDlg TITLE OemToAnsi( cCadastro ) ;
    From oSize:aWindSize[1],oSize:aWindSize[2] TO (oSize:aWindSize[3]),(oSize:aWindSize[4] ) OF oMainWnd ;
    PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )	

    // Cria o conteiner onde serão colocados os paineis
    oTela		:= FWFormContainer():New( oDlg )
    cIdCab	  	:= oTela:CREATEVERTICALBOX( 100 )
    oTela:Activate( oDlg, .F. )

    //Cria os paineis onde serao colocados os browses
    oPanelUp  	:= oTela:GeTPanel( cIdCab )
    Define Font oFont Name 'Courier New' Size 0, -12

    oBrowse:= FWBrowse():New()
    oBrowse:SetOwner(oPanelUp)
    oBrowse:SetDataTable(.T.)
    oBrowse:SetAlias("SZ7")
    oBrowse:SetDescription(cCadastro)

    oBrowse:SetColumns( GetColumns() )

    oBrowse:DisableReport()
    oBrowse:SetUseFilter()  // Habilita a utilização do Filtro de registros
    oBrowse:SetLocate()     // Habilita a Localização de registros
    oBrowse:SetSeek()       // Habilita a Pesquisa de registros
    oBrowse:SetDBFFilter()
    oBrowse:Activate()    

    // // relaciona os paineis aos componentes
    oBar := FWButtonBar():New()
    oBar:Init( oPanelUp , 25 , 25 , CONTROL_ALIGN_TOP , .T. )

    oBar:AddBtnImage( "ADICIONAR_001.PNG" 		,'Incluir Agenda'   ,{|| Schneider(3) } ,, .T., CONTROL_ALIGN_LEFT )
    oBar:AddBtnImage( "ALTERA.PNG"        		,'Alterar Agenda'   ,{|| Schneider(4) } ,, .T., CONTROL_ALIGN_LEFT )
    oBar:AddBtnImage( "BMPVISUAL.PNG" 		    ,'Visualizar Agenda',{|| Schneider(1) } ,, .T., CONTROL_ALIGN_LEFT )

    ACTIVATE MSDIALOG oDlg CENTERED 

RETURN


/*/{Protheus.doc} MenuDef
description
Rotina que irá criar o menu, tendo como retorno a estrutura
@type function
@version  
@author Valdemir Jose
@since 29/04/2021
@return aRotina - Estrutura
			[n,1] Nome a aparecer no cabecalho
			[n,2] Nome da Rotina associada
			[n,3] Reservado
			[n,4] Tipo de Transação a ser efetuada:
				1 - Pesquisa e Posiciona em um Banco de Dados
				2 - Simplesmente Mostra os Campos
				3 - Inclui registros no Bancos de Dados
				4 - Altera o registro corrente
				5 - Remove o registro corrente do Banco de Dados
				6 - Alteração sem inclusão de registros
				7 - Cópia
				8 - Imprimir
			[n,5] Nivel de acesso
			[n,6] Habilita Menu Funcional
/*/
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PesqBrw"          OPERATION 1 ACCESS 0 DISABLE MENU
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.STCHND05" OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.STCHND05" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.STCHND05" OPERATION 4 ACCESS 143
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.STCHND05" OPERATION 5 ACCESS 144
//ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.STCHND05" OPERATION 8 ACCESS 0

Return aRotina

/*/{Protheus.doc} Modeldef
description
Rotina monta modelo de dados do cadastro Schneider
@type function
@version  
@author Valdemir Jose
@since 29/04/2021
@return return_type, return_description
/*/
Static Function Modeldef()

	Local oStructSA1 := Nil
	Local oModel     := Nil

	//-----------------------------------------
	//Monta o modelo do formulário
	//-----------------------------------------
	oModel:= MPFormModel():New("STCHND05",/*Pre-Validacao*/, {|| FWFormCanDel(oModel)}/*Pos-Validacao*/, /*Commit*/,/*Cancel*/)
	oModel:AddFields("STCHND05_Z85", Nil , FWFormStruct(1,"SZ7"),/*Pre-Validacao*/,/*Pos-Validacao*/,/*Carga*/)

Return(oModel)


/*/{Protheus.doc} ViewDef
description
Rotina Visualizador de dados do Cadastro Schneider
@type function
@version  
@author Valdemir Jose
@since 29/04/2021
@return return_type, return_description
/*/
Static Function ViewDef()
	Local oView
	Local oModel := FWLoadModel("STCHND05")

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField( "STCHND05_Z85" , FWFormStruct(2,"SZ7"))
	oView:CreateHorizontalBox("ALL",100)
	oView:SetOwnerView("STCHND05_Z85","ALL")
	oView:EnableControlBar(.T.)

Return oView



Static Function Schneider(nOpc)
    
    INCLUI := (nOPC==3)
    
    if (nOPC==1)
        AxVisual("SZ7",Recno(),2)
    elseif nOPC==3
       AxInclui("SZ7", 0, 3)
    elseif nOPC==4
       AxAltera("SZ7", Recno(), 4)
    endif 

Return


/*/{Protheus.doc} GetColumns
description
Rotina que controla colunas
@type function
@version  
@author Valdemir Jose
@since 17/03/2021
@return return_type, return_description
/*/
Static Function GetColumns()

Local aArea	:= GetArea()
Local cCampo	:= ""
Local aCampos	:= {}
Local aColumns	:= {}
Local nX		:= 0
Local nLinha	:= 0
Local cIniBrw	:= ""
Local aCpoQry	:= {}
Local cAlias    := "SZ7"

// Ticket: 20210210002232 - Adicionado os ultimos 3 campos Descrição

aCampos := {'Z7_COD', ; 
			'Z7_EAN13', ; 
			'Z7_1EAN14', ; 	
			'Z7_Q1EAN14', ; 	
			'Z7_2EAN14',; 	
			'Z7_Q2EAN14',; 	
			'Z7_3EAN14',; 	
			'Z7_3EAN14',; 	
			'Z7_Q3EAN14',;
			'Z7_DESCRI1',;
			'Z7_DESCRI2',;
			'Z7_DESCRI3';
			}
			
DbSelectArea("SX3")
DbSetOrder(2)//X3_CAMPO 

/*
AAdd(aColumns,FWBrwColumn():New())
nLinha := Len(aColumns)
aColumns[nLinha]:SetData(&(  "{ || getStatus(ZS3->ZS3_STATUS) } "))
aColumns[nLinha]:SetTitle("")
aColumns[nLinha]:SetType("C")
aColumns[nLinha]:SetPicture("@BMP")
aColumns[nLinha]:SetSize(1)
aColumns[nLinha]:SetDecimal(0)
aColumns[nLinha]:SetDoubleClick({|| LegendBrw() })
aColumns[nLinha]:SetImage(.T.)
*/

For nX := 1 To Len(aCampos)
	If SX3->(DbSeek(AllTrim(aCampos[nX])))
		If (X3USO(SX3->X3_USADO) .AND. SX3->X3_BROWSE == "S" .AND. SX3->X3_TIPO <> "M") .OR. SX3->X3_CAMPO = "ZS3_FILIAL"
			AAdd(aColumns,FWBrwColumn():New())
			nLinha	:= Len(aColumns)
			cCampo 	:= AllTrim(SX3->X3_CAMPO)
			cIniBrw := AllTrim(SX3->X3_INIBRW)
			aColumns[nLinha]:SetType(SX3->X3_TIPO)
			If SX3->X3_CONTEXT <> "V"
				aAdd(aCpoQry,cCampo)
				If SX3->X3_TIPO = "D"
					aColumns[nLinha]:SetData( &("{|| "  + "('"+cAlias+"')->" + cCampo + " }") )
				ElseIf !Empty(X3CBox())
					aColumns[nLinha]:SetData( &("{|| X3Combo('" +  cCampo + "',('"+cAlias+"')->" + cCampo + ") }") )
				Else
					aColumns[nLinha]:SetData( &("{|| " + "('"+cAlias+"')->" + cCampo + " }") )
				EndIf
			Else
				aColumns[nLinha]:SetData( &("{|| U_MLRetBrw(" + "'"+cIniBrw+"','"+cAlias+"'" + ") }") )
			EndIf
			aColumns[nLinha]:SetTitle(X3Titulo())
			aColumns[nLinha]:SetSize(SX3->X3_TAMANHO)
			aColumns[nLinha]:SetDecimal(SX3->X3_DECIMAL)

		EndIf

	EndIf
Next nX

RestArea(aArea)

Return(aColumns)

