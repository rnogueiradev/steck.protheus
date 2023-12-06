//Bibliotecas
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'FWMVCDEF.CH'

//Variáveis Estáticas
Static cTitulo := "Painel Faturamento x Avarias/Desvio Transportadoras"

/*/{Protheus.doc} STPNTNT
@author Eduardo Matias
@since 18/02/2019
@version 1.0
@return Nil, Função não tem retorno
@example
u_STPNTNT()
@obs Não se pode executar função MVC dentro do fórmulas
/*/

User Function STPNTNT()

	Local aArea   := GetArea()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("Z29")
	oBrowse:SetDescription(cTitulo)
	oBrowse:AddLegend( "Z29->Z29_STATUS == '1'", "RED"			,"Aguardando interação logística" )
	oBrowse:AddLegend( "Z29->Z29_STATUS == '2'", "YELLOW"		,"Em analise pela logística" )
	oBrowse:AddLegend( "Z29->Z29_STATUS == '3'", "BLUE"			,"Liberado para analise financeiro" )
	oBrowse:AddLegend( "Z29->Z29_STATUS == '4'", "PINK"			,"Em analise financeiro" )
	oBrowse:AddLegend( "Z29->Z29_STATUS == '5'", "GREEN"		,"Processo finalizado" )
	oBrowse:SetMenuDef('STPNTNT')
	oBrowse:Activate()

	RestArea(aArea)
Return Nil

Static Function MenuDef()
	Private aRotina := {}

	ADD OPTION aRotina	TITLE 'Visualizar'	ACTION 'VIEWDEF.STPNTNT'										OPERATION		MODEL_OPERATION_VIEW		ACCESS 0 //OPERATION 1
	ADD OPTION aRotina	TITLE 'Legenda'	ACTION 'Z29LEG'														OPERATION		6													ACCESS 0 //OPERATION X
	ADD OPTION aRotina	TITLE 'Alterar'		ACTION 'VIEWDEF.STPNTNT' 									OPERATION		MODEL_OPERATION_UPDATE	ACCESS 0 //OPERATION 4

Return aRotina

Static Function ModelDef()

	Local oModel := Nil
	Local oStZ29 := FWFormStruct(1, "Z29")

	oModel := MPFormModel():New("STPNTNTM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
	oModel:AddFields("FORMZ29",/*cOwner*/,oStZ29)
	//Setando a chave primária da rotina
	//oModel:SetPrimaryKey({'Z29_FILIAL','BM_GRUPO'})
	oModel:SetPrimaryKey({})
	oModel:SetDescription(cTitulo)
	oModel:GetModel("FORMZ29"):SetDescription(cTitulo)

Return oModel

Static Function ViewDef()

	Local oModel := FWLoadModel("STPNTNT")
	Local oStZ29 := FWFormStruct(2, "Z29") 
	Local oView := Nil

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:addUserButton("Incluir Anexo","Incluir Anexo"	,{||IncAnexo("1",oView)})
	oView:addUserButton("Baixar Anexo","Baixar Anexo"	,{||IncAnexo("2",oView)})
	oView:AddField("VIEW_Z29", oStZ29, "FORMZ29")
	oView:CreateHorizontalBox("TELA",100)
	oView:EnableTitleView('VIEW_Z29', 'Dados do Grupo de Produtos' )  
	oView:SetCloseOnOk({||.T.})
	oView:SetOwnerView("VIEW_Z29","TELA")

Return oView

Static Function IncAnexo(cOpc,oView)

	Local cToFile		:=	""
	Local cAquivo		:= ""
	Local cDirArq		:= SuperGetMv("STPNTNT1",.F.,"\ARQTRANSP\")
	Local nCont

	If cOpc = "1"
		cToFile := cGetFile( "PDF|*.pdf|JPEG|*.jpg", "Escolha o arquivo", 0, "C:\", .T., GETF_LOCALHARD, .F.)

		If !Empty(cToFile)

			For nCont := Len(cToFile) To 0 Step -1

				If SubStr(cToFile,nCont,1) = "\"
					cAquivo := AllTrim(SubStr(cToFile,nCont+1,Len(cToFile)))
					Exit
				EndIf

			Next nCont

			If CpyT2S( cToFile , cDirArq )
				RecLock("Z29",.F.)
				Z29->Z29_ANEXO	:=	cDirArq+cAquivo
				Z29->(MsUnLock())
			Else
				MsgStop('Falha na operação 2 : FError '+str(ferror(),4))
			EndIf
		EndIf
	Else

		cToFile := cGetFile("Arquivos  (*.*)  | *.*  "," ",1,"C:\",.T.,GETF_LOCALHARD+GETF_RETDIRECTORY ,.F.,.T.)

		If !Empty(cToFile)

			For nCont := Len(Z29->Z29_ANEXO) To 0 Step -1
				If SubStr(Z29->Z29_ANEXO,nCont,1) = "\"
					cAquivo := AllTrim(SubStr(Z29->Z29_ANEXO,nCont+1,Len(Z29->Z29_ANEXO)))
					Exit
				EndIf
			Next nCont

			If CpyS2T( Z29->Z29_ANEXO, cToFile )
				ShellExecute("OPEN", cToFile+cAquivo, "", "", 1)
			Else
				MsgStop('Falha na operação 2 : FError '+str(ferror(),4))
			EndIf
		EndIf
	EndIf

Return()

User Function Z29LEG()
	Local aLegenda := {}

	AADD(aLegenda,{"BR_VERMELHO"	,"Aguardando interação logística"					})
	AADD(aLegenda,{"BR_AMARELO"	,"Em analise pela logística"	})
	AADD(aLegenda,{"BR_AZUL"			,"Liberado para analise financeiro"	})
	AADD(aLegenda,{"BR_ROSA"			,"Em analise financeiro"	})
	AADD(aLegenda,{"BR_VERDE"			,"Processo finalizado"	})

	BrwLegenda("Status", "Procedencia", aLegenda)
Return

/*FUNÇÃO UTILIZADA NO CAMPO WHEN*/
User Function Z29WHEN(cVldCpo)

	Local lRet := .F.

	//1=Aguardando Analise Log.;2=Em Analise Log;3=Lib p/ Analise Fin;4=Em Analise Fin;5=Processo Finalizado
	Do Case
		Case cVldCpo='1' .And. Z29_STATUS $ "1|2"
		lRet := .T.
		Case cVldCpo='2' .And. Z29_STATUS $ "3|4"
		lRet := .T.
	EndCase

Return(lRet)