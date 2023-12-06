#Include "Protheus.Ch" //
#Include "rwmake.Ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWMBROWSE.CH"
#INCLUDE 'TBICONN.CH'



#DEFINE D_TITULO 'Log Movimentação OP'
#DEFINE D_ROTINA 'STKLGOP'

//-------------------------------------------------------------------
/*/{Protheus.doc} STKLGOP
Rotina para logar movimentação da ordem de produção-descida para o 90 e 
ajustes de empenho das op's.

@author Jackson Santos - Totvs
@since 11/02/2023
@version P12
/*/
//-------------------------------------------------------------------
User Function STKLGOP()
Private oBrowse
Private cTabCad :="ZA0"
oBrowse := FWMBrowse():New()
oBrowse:SetAlias(cTabCad)
oBrowse:SetDescription(D_TITULO)
oBrowse:AddLegend( "ZA0_STATMV=='1'", "GREEN", "Iniciado"      )
oBrowse:AddLegend( "ZA0_STATMV=='2'", "RED"  , "Finalizado" )
oBrowse:AddLegend( "ZA0_STATMV=='3'", "BLUE"  ,"Aju.Empenho" )
//oBrowse:SetFilterDefault( "ZA0_TIPO=='1'" )
//oBrowse:SetFilterDefault( "Empty(ZA0_DTAFAL)" )
oBrowse:DisableDetails()
//oBrowse:SetCacheView( .F. )

oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.'+D_ROTINA OPERATION 2 ACCESS 0
//ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.'+D_ROTINA OPERATION 3 ACCESS 0
//ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.'+D_ROTINA OPERATION 4 ACCESS 0
//ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.'+D_ROTINA OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.'+D_ROTINA OPERATION 8 ACCESS 0
//ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.'+D_ROTINA OPERATION 9 ACCESS 0

Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZA0 := FWFormStruct( 1, cTabCad, /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel

// Cria o objeto do Modelo de Dados
//oModel := MPFormModel():New( D_ROTINA + 'MODEL', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
oModel := MPFormModel():New(D_ROTINA + 'MODEL', /*bPreValidacao*/, /*{ |oMdl| VALIDPOS( oMdl )}*/, /* {|oMdl| GrvModel(oMdl) }*/ /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'ZA0MASTER', /*cOwner*/, oStruZA0, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

oModel:SetPrimaryKey({'ZA0_FILIAL', 'ZA0_CODIGO'}) 

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( D_TITULO )

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'ZA0MASTER' ):SetDescription( 'Log' )

// Liga a validação da ativacao do Modelo de Dados
//oModel:SetVldActivate( { |oModel| COMP011ACT( oModel ) } )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oModel   := FWLoadModel( D_ROTINA )
// Cria a estrutura a ser usada na View
Local oStruZA0 := FWFormStruct( 2, cTabCad )
//Local oStruZA0 := FWFormStruct( 2, 'ZA0', { |cCampo| COMP11STRU(cCampo) } )
Local oView



// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField( 'VIEW_ZA0', oStruZA0, 'ZA0MASTER' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'TELA' , 100 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_ZA0', 'TELA' )

//oView:SetViewAction( 'BUTTONOK'    , { |o| Help(,,'HELP',,'Ação de Confirmar ' + o:ClassName(),1,0) } )
//oView:SetViewAction( 'BUTTONCANCEL', { |o| Help(,,'HELP',,'Ação de Cancelar '  + o:ClassName(),1,0) } )
Return oView


Static Function VALIDPOS( oModel )
Local lRet       := .T.
Local aArea      := GetArea()
Local aAreaZA0   := ZA0->( GetArea() )
Local nOperation := oModel:GetOperation()
Local oModelZA0  := oModel:GetModel( 'ZA0MASTER' )
Local aSaveLines := FWSaveRows()
Local cMensErro := ""
Local aSolucao := {}

/*
If nOperation == MODEL_OPERATION_INSERT .Or. nOperation == MODEL_OPERATION_UPDATE
	cCabecErro := "Validação Eventos"
    cMensErro := "Erro no Cadstro"
    aSolucao := {"Verifiqeu o erro"}
    
    If !Empty(Alltrim(cMensErro)) 
		Help("",1, "Cadri-Validação", NIL, cMensErro, 4,5, NIL, NIL, NIL, NIL, NIL, aSolucao)
		lRet := .F.
	EndIf
elseIf nOperation == MODEL_OPERATION_DELETE .AND. lRet
	cCabecErro := "Validação Eventos"
    cMensErro := "Erro no Cadstro"
    aSolucao := {"Verifiqeu o erro"}
    
    If !Empty(Alltrim(cMensErro)) 
		Help("",1, "Cadri-Validação", NIL, cMensErro, 4,5, NIL, NIL, NIL, NIL, NIL, aSolucao)
		lRet := .F.
	EndIf
EndIf
*/
FWRestRows( aSaveLines )


RestArea( aAreaZA0 )
RestArea( aArea )

Return lRet


Static  Function  GrvModel(oModel)
Local lRet := .t.

FWFormCommit( oModel )
confirmsx8()

Return lRet


//Função para gravar o Log nas rotinas que 
/*

*/
User Function STKGLGOP(cCodMov,cCodOp,cCodProd,cCodUsr,cNomeUsr,dDataMov,cHoraMov,cRotinOri,cDetAntes,cDetDepois,cStatusMov,dDatFimMv,cHorFimMv,cRotFimMv,nRecnoreg)
Local aRet := {.T.,""}
Local cTabRot := "ZA0"
Local lAchouMov := .F.
Local lLockGrv  := .T.
Local cNumLog   := ""
Local lContinua := .T.
Default cCodMov     := ""
Default cCodOp		:= "" 
Default cCodProd	:= ""
Default cCodUsr 	:= "" 
Default cNomeUsr	:= "" 
Default cRotinOri	:= ""
Default cDetAntes	:= ""
Default cDetDepois	:= ""
Default dDataMov	:= DDataBase
Default cHoraMov	:= Time()
Default cStatusMov	:= "3"
Default dDatFimMv   := CTOD("  /  /  ") 
DeFault cHorFimMv   := ""
Default cRotFimMv   := ""
Default nRecnoreg   := 0

DbSelectArea(cTabRot)
If Empty(Alltrim(cCodMov))
	(cTabRot)->(DbSetOrder(1))
	iF nRecnoreg > 0 
		(cTabRot)->(DbGoTo(nRecnoreg)) 
		If (cTabRot)->(Recno()) == nRecnoreg
			lAchouMov := .T.
			lLockGrv  := .F. //Alteração
		EndIf
	Else
		If (cTabRot)->(DbSeek(xFilial(cTabRot) + cCodOp ))
			lAchouMov := .T.
			lLockGrv  := .F. //Alteração
		else
			lAchouMov := .F.
			lLockGrv  := .T. //Gravação	
		Endif
	EndiF
else
	iF nRecnoreg > 0 
		(cTabRot)->(DbGoTo(nRecnoreg)) 
		If (cTabRot)->(Recno()) == nRecnoreg
			lAchouMov := .T.
			lLockGrv  := .F. //Alteração
		EndIf
	else
		(cTabRot)->(DbSetOrder(2))
		If (cTabRot)->(DbSeek(xFilial(cTabRot) + cCodMov ))
			lAchouMov := .T.
			lLockGrv  := .F. //Alteração
		else
			lAchouMov := .F.
			lLockGrv  := .T. //Gravação	
		Endif
	EndIf
Endif

//Se for para gravar um log novo, anlisar se a nuemração escolhida já exisete.
If lLockGrv
	(cTabRot)->(DbSetOrder(2))
	While lContinua
		cNumLog := GetSxeNum(cTabRot,"ZA0_CODIGO") 
		If (cTabRot)->(DbSeek(xFilial(cTabRot) + cNumLog )) 
			confirmsx8()
		else
			lContinua := .F.				
		EndIf
	End
	confirmsx8()
EndIF
If Reclock(cTabRot,lLockGrv)	
	If lLockGrv		
		(cTabRot)->ZA0_FILIAL := xFilial(cTabRot)	
		(cTabRot)->ZA0_CODIGO := cNumLog
		(cTabRot)->ZA0_CODOP  := cCodOp
		(cTabRot)->ZA0_PRODOP := cCodProd
		(cTabRot)->ZA0_USRMOV := cNomeUsr
		(cTabRot)->ZA0_CODUSR := cCodUsr
		(cTabRot)->ZA0_DATMOV := dDataMov
		(cTabRot)->ZA0_HORMOV := cHoraMov
		(cTabRot)->ZA0_ROTORI := cRotinOri
		If !Empty(Alltrim(cDetAntes))
			(cTabRot)->ZA0_DETANT := cDetAntes
		Endif
	EndIf
	If !Empty(Alltrim(cDetDepois))
		(cTabRot)->ZA0_DETDEP := cDetDepois
	Endif
	(cTabRot)->ZA0_STATMV := cStatusMov
	(cTabRot)->ZA0_DATFIM := dDatFimMv
	(cTabRot)->ZA0_HORFIM := cHorFimMv
	(cTabRot)->ZA0_ROTFIM := cRotFimMv
	(cTabRot)->(MSUNLOCK())
	
	aRet[1] := .T.
	aRet[2] := (cTabRot)->ZA0_CODIGO
else
	aRet[1] := .F.
	aRet[2] := ""
EndIf

Return aRet
