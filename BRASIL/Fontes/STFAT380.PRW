#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT380        | Autor | RENATO.OLIVEIRA           | Data | 17/02/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT380()

	Local oBrowse
	Private aRotina := MenuDef()

	DbSelectArea("SZN")
	SZN->(DbSetOrder(1))

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SZN")                        // Alias da tabela utilizada
	oBrowse:SetDescription("Cadastro cep x zona")      	   // Descrição do browse
	oBrowse:SetUseCursor(.F.)
	oBrowse:Activate()

Return



/*/{Protheus.doc} MenuDef
@name MenuDef
@type Static Function
@desc monta menu principal
@author Renato Nogueira
@since 12/09/2016
/*/
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  							ACTION "AxPesqui"        	OPERATION 1  ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE "Visualizar" 							ACTION "VIEWDEF.STFAT380" 	OPERATION 2  ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Alterar"    							ACTION "VIEWDEF.STFAT380" 	OPERATION 4  ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    							ACTION "VIEWDEF.STFAT380"	OPERATION 5  ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Incluir"    							ACTION "VIEWDEF.STFAT380"	OPERATION 3  ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Importar"    							ACTION "U_STFAT381"	OPERATION 10  ACCESS 0 //"Incluir"

Return aRotina

/*/{Protheus.doc} ModelDef
@name ModelDef
@type Static Function
@desc monta model do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ModelDef()

	Local oModel
	Local oStr1:= FWFormStruct(1,'SZN')
	Local _aRel	:= {}
	Local _aRel1	:= {}

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})

	oModel:SetDescription('Main')

	oModel:addFields('FIELD1',,oStr1,)
	oModel:SetPrimaryKey({})
	oModel:getModel('FIELD1'):SetDescription('Zonas')

Return oModel

/*/{Protheus.doc} ViewDef
@name ViewDef
@type Static Function
@desc montar view do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ViewDef()

	Local oView  := NIL
	Local oStr1  := FWFormStruct(2, 'SZN' )
	Local oModel := FWLoadModel("STFAT380")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM1' , oStr1,'FIELD1' )

	oView:CreateHorizontalBox( 'BOXFORM1', 100)

	oView:SetOwnerView('FORM1','BOXFORM1')

	oView:EnableTitleView('FORM1','Cabeçalho')

	oView:EnableControlBar(.T.)

	oView:SetCloseOnOk({|| .T.})

Return oView

/*/{Protheus.doc} VLDALT
@name VLDALT
@type Static Function
@desc validar alteração do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDALT(oModel)

	Local _lRet				:= .T.
	Local nOp         		:= oModel:GetOperation()
	Local oCampo            := oModel:GetModel( 'MOD03XFORM' ) 


Return(_lRet)

/*/{Protheus.doc} TUDOOK
@name TUDOOK
@type Static Function
@desc validar tudo ok do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function TUDOOK(oModel)

	Local _lRet			:= .T.

Return(_lRet)

/*/{Protheus.doc} VLDLIN
@name VLDLIN
@type Static Function
@desc validar troca de linha do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDLIN(oModel,nLine)

	Local _lRet	:= .T.

Return(_lRet)

/*/{Protheus.doc} GrvTOK
@name GrvTOK
@type Static Function
@desc realiZP gravação dos dados
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GrvTOK( oModel )

	Local lGrv				:= .T.
	Local nOp        		:= oModel:GetOperation()

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

Return lGrv

/*/{Protheus.doc} STFAT381
@name STFAT381
@type User Function
@desc importar rotas
@author Renato Nogueira
@since 12/09/2016
/*/

User Function STFAT381()

	MsgAlert("ATENÇÃO, a primeira coluna do arquivo deve ser a ROTA e a segunda o CEP, cuidado!")

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*| ","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)
		MsgStop("O arquivo " +cArquivo + " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return
	EndIf

	oProcess := MsNewProcess():New( { || PROCESSA() } , "Processando" , "Processando, por favor aguarde ..." , .F. )
	oProcess:Activate()

	MsgAlert("Atualização finalizada, obrigado!")

Return()

/*====================================================================================\
|Programa  | PROCESSA        | Autor | RENATO.OLIVEIRA           | Data | 18/02/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function PROCESSA()

	Local aCampos  := {}
	Local aDados   := {}
	Local lPrim    := .T.
	Local lSaida   := .T. 
	Local _aProcs  := {}
	Local nX
	Local _nY
	Local _nX
	Local nY
	Local aSize	   := MsAdvSize(.F.)
	Local	oWindow,;
	oFontWin,;
	aHead				:= {},;
	bOk 				:= {||(	lSaida:=.f., lConfirma:=.T.,oWindow:End()) },;
	bCancel 	    	:= {||(	lSaida:=.f.,oWindow:End()) },;
	aButtons	    	:= {},;
	oGet
	Local aHeader		:= {}
	Local aCols		:= {}
	Local _cDtOrig := DDATABASE
	Private lMsErroAuto := .F.

	oProcess:SetRegua1(FT_FLASTREC())

	FT_FUSE(cArquivo)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()                     // faça enquanto não for fim do arquivo

		oProcess:IncRegua1("Lendo o arquivo")

		cLinha := FT_FREADLN()           // lendo a linha

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	oProcess:SetRegua1(Len(aDados))

	For _nY:=1 To Len(aDados)

		oProcess:IncRegua1("Atualizando rotas")

		If !SZN->(DbSeek(xFilial("SZN")+aDados[_nY][02]))
			SZN->(RecLock("SZN",.T.))
		Else
			SZN->(RecLock("SZN",.F.))
		EndIf

		SZN->ZN_CEP 	:= AllTrim(aDados[_nY][02])
		SZN->ZN_ROTA 	:= AllTrim(aDados[_nY][01])

		SZN->(MsUnLock())

	Next

Return()

/*/{Protheus.doc} VldCPO02
description
Rotina para atualizar os novos campos
Ticket: 20200922007696
@type function
@version  
@author Valdemir Jose
@since 08/01/2021
@param pCampo, param_type, param_description
@return return_type, return_description
/*/
User Function VldCPO02(pCampo)
	Local lRET  := .T.

	if     (pCampo == "ZN_CODCLI")
	    lRET := ExistCpo("SA1", M->(&pCampo), 1)                                                                                                
		M->ZN_NOMCLI := POSICIONE("SA1",1,XFILIAL('SA1')+M->(&pCampo),"A1_NOME")
	elseif (pCampo == "ZN_CODTRAN")
		lRET := ExistCpo("SA4", M->(&pCampo), 1) 
		M->ZN_NOMTRAN := POSICIONE("SA4",1,XFILIAL('SA4')+M->(&pCampo),"A4_NOME")
		M->ZN_LOJA := ""
	elseif (pCampo == "ZN_CEP")
		M->ZN_LOJA := ""
	endif 

Return lRET

/*/{Protheus.doc} VLDCPO03
description
Rotina que fará a validação dos campos, conforme regra
Ticket: 20200922007696
@type function
@version  
@author Valdemir Jose
@since 08/01/2021
@param pCampo, param_type, param_description
@return return_type, return_description
/*/
User Function VLDCPO03(pCampo)
	Local lRET   := .T.

	if ("ZN_CEP"==ALLTRIM(pCampo))
	   lRET := (Empty(alltrim(M->ZN_CODCLI)) .and. Empty(M->ZN_LOJA) .AND. Empty(alltrim(M->ZN_CODTRAN)))
	   if lRET
	      M->ZN_LOJA := " " 
	   Endif 
	elseif ("ZN_CODCLI"==ALLTRIM(pCampo))
	   lRET := (Empty(alltrim(M->ZN_CEP)) .AND. Empty(alltrim(M->ZN_CODTRAN)))
	elseif ("ZN_CODTRAN"==ALLTRIM(pCampo))
	   lRET := (Empty(alltrim(M->ZN_CEP)) .AND. Empty(alltrim(M->ZN_CODCLI)))
	   if lRET
	      M->ZN_LOJA := " " 
	   Endif 
	endif 

Return lRET	
