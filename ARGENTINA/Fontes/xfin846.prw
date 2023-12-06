#INCLUDE "FWMVCDEF.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FINA846.CH"

Static aValores
Static lFWCodFil := .T.
STATIC lMod2	:= .T.
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FINA846   �Autor  �Bruno Sobieski      � Data �  10/27/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de manuten��o de recibos- Substitue a FINA087A e a   ���
���          �FINA088                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
//Roberto Gonz�lez *  01/03/17 * Se a�aden filtros en la anulacion para 
//							   * borrar solamente los propios registros.
//Raul Ortiz M     *  13/12/17 * Se modifica el parametro utilizado para Asientos Online en la anulaci�n - Argentina
//Jos� Gonz�lez    *  Se agrega Tratamiento para validar que la rutina FINA846 y FINA847 no se ejecuten en modelo I
//Ra�l Ortiz M     *  05/01/18  * Creacion del Punto de Entrada FIN846DEL. - DMICNS-772 - Argentina
//Oscar G.		   *  02/04/19  * Se inicializa variable cCadastro. - DMINA-5677 - Argentina
*/

User FUNCTION FINA846(aCab,aDoc,aForma,nOper)

Local cFiltro := ""                            
Local l846BRW := ExistBlock("846BRW")
Local lRet := .T.
Local oModel
Local nCFil := 0
Local nCSer := 0
Local nCRec := 0

Private oBrowse
Private lRotAuto := .F.
Private cTxtRotAut := ""
Private xCabRec 
Private xDocRec 
Private xFormaRec 
Private xOperacao
Private cCadastro := OemToAnsi(STR0001) //'Recibos'

DEFAULT aCab := Nil
DEFAULT aDoc := Nil
DEFAULT aForma := Nil
DEFAULT nOper := Nil

/*
* Verifica��o do processo que est� configurado para ser utilizado no M�dulo Financeiro (Argentina)
*/
If lMod2
	If !FinModProc()
		Return()
	EndIf
EndIf


If aCab <> Nil .And. aDoc <> Nil .And. aForma <> Nil .And. nOper <> Nil
	lRotAuto := .T.
	xCabRec := aCab
	xDocRec := aDoc
	xFormaRec := aForma
	xOperacao := nOper
ElseIf aCab <> Nil .And. nOper <> Nil
	lRotAuto := .T.
	xCabRec := aCab
	xOperacao := nOper
EndIf

// Instanciamento da Classe de Browse
If !lRotAuto .And. pergunte('FIN87A',.T.)
	oBrowse := FWMBrowse():New()
	// Defini��o da tabela do Browse
	oBrowse:SetAlias('FJT')
	// Defini��o da legenda
	oBrowse:AddLegend( "FJT_CANCEL=='1'", "RED"  , STR0002 )//"Cancelado"
	oBrowse:AddLegend( "FJT_VERATU=='0'", "BLACK" , STR0003+" "+STR0004 )//"Vers�o"+"Inativa"
	oBrowse:AddLegend( "FJT_VERATU=='1'", "GREEN" , STR0003+" "+STR0005 )//"Vers�o"+"Ativa"
	// Titulo da Browse
	oBrowse:SetDescription(cCadastro)
	// Opcionalmente pode ser desligado a exibi��o dos detalhes
	//oBrowse:DisableDetails()

	Setkey(VK_F12,{|| pergunte('FIN87A',.T.)})
	If l846BRW
		cFiltro := ExecBlock("846BRW", .F., .F.)
		If !Empty(cFiltro)
			oBrowse:SetFilterDefault(cFiltro)
		EndIf	
	EndIf

	// Ativa��o da Classe
	oBrowse:Activate()
ElseIf lRotAuto 
	pergunte('FIN87A',.F.)
	Help(" ",1,"ROTAUTO",If(xOperacao == 3,STR0048,STR0050),STR0049,1,0) 
	lMsErroAuto := .F.

	If xOperacao == 3

		If !Fina840(,,,xCabRec,xDocRec,xFormaRec,xOperacao)	
			lRet := .F.
			lMsErroAuto := .T.
		EndIf	
	
	ElseIf xOperacao == 5
		
		nCFil := Ascan(xCabRec,{|x| AllTrim(x[1]) == "FJT_FILIAL"})
		nCSer := Ascan(xCabRec,{|x| AllTrim(x[1]) == "FJT_SERIE"})
		nCRec := Ascan(xCabRec,{|x| AllTrim(x[1]) == "FJT_RECIBO"})
		dbSelectArea('FJT')
		DbSetOrder(1)
		If !FJT->(DbSeek(Padr(xCabRec[nCFil,2],TAMSX3(xCabRec[nCFil,1])[1]) + Padr(xCabRec[nCSer,2],TAMSX3(xCabRec[nCSer,1])[1]) + Padr(xCabRec[nCRec,2],TAMSX3(xCabRec[nCRec,1])[1])))
			lRet := .F.
			lMsErroAuto := .T.
			cTxtRotAut += STR0051 //" N�o foi poss�vel encontrar o registro. "
		EndIf
		If lRet
			oModel := FWLoadModel('FINA846')
	 		oModel:SetOperation(xOperacao) 
	 		oModel:Activate()
	 		If !F846TudoOk(oModel)
	 			lRet := .F.
				lMsErroAuto := .T.
	 		Else
		 		If !FINA846GRV(oModel)
		 			lRet := .F.
					lMsErroAuto := .T.
				Else
					If FJT->(DbSeek(Padr(xCabRec[nCFil,2],TAMSX3(xCabRec[nCFil,1])[1]) + Padr(xCabRec[nCSer,2],TAMSX3(xCabRec[nCSer,1])[1]) + Padr(xCabRec[nCRec,2],TAMSX3(xCabRec[nCRec,1])[1])))
		 				MsgAlert(STR0052+ xCabRec[nCRec,2] + "  .")    //" Foi cancelado o recibo n�mero : " 
		 			Else 
		 				MsgAlert(STR0053+ xCabRec[nCRec,2] + "  .")  // " Foi exclu�do o recibo n�mero :  "
		 			EndIf
		 		EndIf
		 	EndIF
		EndIf
		
	EndIf
	
	If lMsErroAuto  
		AutoGrLog(cTxtRotAut)
	Else
		Ferase(NomeAutoLog())
	EndIf
Endif
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   �Autor  �Bruno Sobieski      � Data �  10/27/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Definicao dos menus                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MenuDef()
Local aRotina := {}
//ADD OPTION aRotina Title 'Buscar por Cheque' Action 'F846PesqCH(oBrowse)' OPERATION 2 ACCESS 0
ADD OPTION aRotina Title STR0006 Action 'VIEWDEF.FINA846' OPERATION 2 ACCESS 0 //'Visualizar'
ADD OPTION aRotina Title STR0007 Action 'FINA840()' OPERATION 3 ACCESS 0 //'Incluir'
ADD OPTION aRotina Title STR0009 Action 'F846Alt(1)' OPERATION 4 ACCESS 0 //'Manut. por Recibo'
If (cPaisLoc <> "RUS")
	ADD OPTION aRotina Title STR0010 Action 'F846Alt(2)' OPERATION 4 ACCESS 0 //'Manut. por Cheques'
Endif
ADD OPTION aRotina Title STR0011+"/"+STR0012 Action 'VIEWDEF.FINA846' OPERATION 5 ACCESS 0 //'Anular/Excluir'
ADD OPTION aRotina Title STR0013 Action 'IIf(ExistBlock("F486PRT"),ExecBlock("F486PRT",.f.,.f.),FINR087())' OPERATION 8 ACCESS 0 //VERIFICAR COMO CHAMAR PARA QUE IMPRIMA O RECIBO POSICIONADO // 'Imprimir'
If (cPaisLoc $ "RUS")
	ADD OPTION aRotina TITLE STR0055 ACTION 'F846Leg'	OPERATION 7 ACCESS 0 //"Legenda"
	ADD OPTION aRotina Title STR0054 Action 'CTBC662' OPERATION 13 ACCESS 0 //"Tracker Cont�bil"
Endif

If ExistBlock("F846ROT")	
	aRotina := ExecBlock("F846ROT",.F.,.F.,{aRotina})
EndIf
	
Return aRotina
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ModelDef  �Autor  �Bruno Sobieski      � Data �  10/27/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Definicao do modelo de dados                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruFJT := FWFormStruct( 1, 'FJT' )
Local oStruSEL1:= FWFormStruct( 1, 'SEL' )
Local oStruSEL2:= FWFormStruct( 1, 'SEL' )
Local oStruSEL3:= FWFormStruct( 1, 'SEL' )
Local oStruSEL4:= FWFormStruct( 1, 'SEL' )
Local oStruSFE := FWFormStruct( 1, 'SFE' )
Local oModel // Modelo de dados que ser� constru�do
// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New('FINA846', /*bPreValidacao*/ ,{ |oModel| F846TudoOk( oModel ) },{|oModel| FINA846GRV(oModel)} )

// Adiciona ao modelo um componente de formul�rio
oModel:AddFields( 'FJTMASTER', /*cOwner*/, oStruFJT)
// Adiciona ao modelo um componente de formul�rio
oModel:AddGrid( 'SELGRID1','FJTMASTER', oStruSEL1, , , ,  , {|oGrid,lCopia| F846FillData(oGrid,lCopia,1)})
oModel:AddGrid( 'SELGRID2','FJTMASTER', oStruSEL2, , , ,  , {|oGrid,lCopia| F846FillData(oGrid,lCopia,2)})
oModel:AddGrid( 'SELGRID3','FJTMASTER', oStruSEL3, , , ,  , {|oGrid,lCopia| F846FillData(oGrid,lCopia,3)})
oModel:AddGrid( 'SELGRID4','FJTMASTER', oStruSEL4, , , ,  , {|oGrid,lCopia| F846FillData(oGrid,lCopia,4)})
oModel:AddGrid( 'SFEGRID', 'SELGRID4' , oStruSFE, , , ,  ,  )

//Os campos nunca devem ser edit�veis, e isso � protegido pela propria MVC,
//por�m quando � usada a op��o ALTERAR para a anula��o � necess�rio garantir que n�o sejam editados
oStruFJT:SetProperty(  '*' , MODEL_FIELD_NOUPD, .T.)            
oStruFJT:SetProperty(  'FJT_CANCEL' , MODEL_FIELD_NOUPD, .F.)            
oStruFJT:SetProperty(  'FJT_CANCEL' , MODEL_FIELD_INIT, {|| '1' })
oStruSEL1:SetProperty( '*' , MODEL_FIELD_NOUPD, .T.)
oStruSEL2:SetProperty( '*' , MODEL_FIELD_NOUPD, .T.)
oStruSEL3:SetProperty( '*' , MODEL_FIELD_NOUPD, .T.)
oStruSEL4:SetProperty( '*' , MODEL_FIELD_NOUPD, .T.)
oStruSFE:SetProperty(  '*' , MODEL_FIELD_NOUPD, .T.)

// Faz relacionamento entre os componentes do model
oModel:SetRelation( 'SELGRID1', { { 'EL_FILIAL', 'xFilial( "SEL" )' },{ 'EL_SERIE', 'FJT_SERIE' } , { 'EL_RECIBO' , 'FJT_RECIBO' },{ 'EL_VERSAO', 'FJT_VERSAO' } }, SEL->( IndexKey( 1 ) ) )
oModel:SetRelation( 'SELGRID2', { { 'EL_FILIAL', 'xFilial( "SEL" )' },{ 'EL_SERIE', 'FJT_SERIE' } , { 'EL_RECIBO' , 'FJT_RECIBO' },{ 'EL_VERSAO', 'FJT_VERSAO' } }, SEL->( IndexKey( 1 ) ) )
oModel:SetRelation( 'SELGRID3', { { 'EL_FILIAL', 'xFilial( "SEL" )' },{ 'EL_SERIE', 'FJT_SERIE' } , { 'EL_RECIBO' , 'FJT_RECIBO' },{ 'EL_VERSAO', 'FJT_VERSAO' } }, SEL->( IndexKey( 1 ) ) )
oModel:SetRelation( 'SELGRID4', { { 'EL_FILIAL', 'xFilial( "SEL" )' },{ 'EL_SERIE', 'FJT_SERIE' } , { 'EL_RECIBO' , 'FJT_RECIBO' },{ 'EL_VERSAO', 'FJT_VERSAO' } }, SEL->( IndexKey( 1 ) ) )
oModel:SetRelation( 'SFEGRID' , { { 'FE_FILIAL', 'xFilial( "SFE" )' },{ 'FE_RECIBO','EL_RECIBO' } , { 'FE_NROCERT', 'EL_NUMERO'  }}, SFE->( IndexKey( 6 ) ) )

oModel:SetVldActivate( {|oModel| F846PreVld(oModel:GetOperation()) } )

//Componente em fase de desenvolvimento em outubro de 2013. Quando pronto substituira o F486FillData()
//oModel:GetModel( 'SELGRID1' ):SetLoadFilter( { { 'EL_TIPODOC', "{'TB','RA','RG','RB','RI','RS'}", MVC_LOADFILTER_IS_NOT_CONTAINED } } )
//oModel:GetModel( 'SELGRID2' ):SetLoadFilter( { { 'EL_TIPODOC', "{'TB'}", MVC_LOADFILTER_IS_CONTAINED } } )
//oModel:GetModel( 'SELGRID3' ):SetLoadFilter( { { 'EL_TIPODOC', "{'RA'}", MVC_LOADFILTER_IS_CONTAINED } } )
//oModel:GetModel( 'SELGRID4' ):SetLoadFilter( { { 'EL_TIPODOC', "{'RG','RB','RI','RS'}", MVC_LOADFILTER_IS_CONTAINED } } )

// Adiciona a descri��o do Modelo de Dados
oModel:SetDescription( STR0008 ) //'Recibo'
// Adiciona a descri��o do Componente do Modelo de Dados
oModel:GetModel( 'FJTMASTER' ):SetDescription( STR0014 ) //"Cabe�alho"
oModel:GetModel( 'SELGRID1' ):SetDescription( STR0015 )  //"Valores Recebidos'
oModel:GetModel( 'SELGRID2' ):SetDescription( STR0016 )  //'Cancelamentos'
oModel:GetModel( 'SELGRID3' ):SetDescription( STR0017 )  //Cr�ditos Gerados
oModel:GetModel( 'SELGRID4' ):SetDescription( STR0018 )  //Reten��es                
//� necess�rio ter a tabela SFE no modelo, pois caso conrario a exclus�o n�o podera ser confirmada pois h� regra
//de dependencias entre as tabelas nos dicionarios
oModel:GetModel( 'SFEGRID'  ):SetDescription( STR0019+" "+STR0018 ) //'Detalhe Reten��es'

//oModel:GetModel( 'FJTMASTER' ):SetOnlyView ( Eval( oModel:GetOperation()}) )

// Retorna o Modelo de dados
Return oModel
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ViewDef   �Autor  �Bruno Sobieski      � Data �  10/27/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Definicao do view                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ViewDef()
// Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado
Local oModel := FWLoadModel( 'FINA846' )
// Cria a estrutura a ser usada na View
Local oStruFJT	:= FWFormStruct( 2, 'FJT' )
Local oStruSEL1:= FWFormStruct( 2, 'SEL',{|cCampo| F846Stru( cCampo,1 )} )
Local oStruSEL2:= FWFormStruct( 2, 'SEL',{|cCampo| F846Stru( cCampo,2 )} )
Local oStruSEL3:= FWFormStruct( 2, 'SEL',{|cCampo| F846Stru( cCampo,3 )} )
Local oStruSEL4:= FWFormStruct( 2, 'SEL',{|cCampo| F846Stru( cCampo,4 )} )
//Local oStruSFE	:= FWFormStruct( 2, 'SFE',{|cCampo| F846Stru( cCampo,4 )} )
Local oView
Local lReten := cPaisLoc $ 'URU|BOL|PTG|ANG|PER|ARG'

// Cria o objeto de View
oView := FWFormView():New()
// Define qual Modelo de dados ser� utilizado
oView:SetModel( oModel )
// Adiciona no nosso View um controle do tipo formul�rio
// (antiga Enchoice)
oView:AddField( 'VIEW_FJT' , oStruFJT, 'FJTMASTER' )
oView:AddGrid ( 'VIEW_SEL1', oStruSEL1, 'SELGRID1' )
oView:AddGrid ( 'VIEW_SEL2', oStruSEL2, 'SELGRID2' )
oView:AddGrid ( 'VIEW_SEL3', oStruSEL3, 'SELGRID3' )
Iif(lReten,oView:AddGrid ( 'VIEW_SEL4', oStruSEL4, 'SELGRID4' ),)
//oView:AddGrid ( 'VIEW_SFE' , oStruSFE , 'SFEGRID' )

//Os campos nunca devem ser edit�veis, e isso � protegido pela propria MVC,
//por�m quando � usada a op��o ALTERAR para a anula��o � necess�rio garantir que n�o sejam editados
oStruFJT:SetProperty( '*'  , MVC_VIEW_CANCHANGE,.F.)
oStruSEL1:SetProperty( '*' , MVC_VIEW_CANCHANGE,.F.)
oStruSEL2:SetProperty( '*' , MVC_VIEW_CANCHANGE,.F.)
oStruSEL3:SetProperty( '*' , MVC_VIEW_CANCHANGE,.F.)
Iif(lReten,oStruSEL4:SetProperty( '*' , MVC_VIEW_CANCHANGE,.F.),)
//oStruSFE:SetProperty( '*' , MVC_VIEW_CANCHANGE,.F.)

// Criar um "box" horizontal para receber algum elemento da view
// Cria um "box" horizontal para receber cada elemento da view
oView:CreateHorizontalBox( 'SUPERIOR'	, 40 )
oView:CreateHorizontalBox( 'INFERIOR'	, 60 )
oView:CreateFolder( 'PASTAS','INFERIOR')
oView:AddSheet( 'PASTAS', 'ABA01', STR0015 ) //"Valores Recebidos"
oView:AddSheet( 'PASTAS', 'ABA02', STR0016 ) //"Cancelamentos"
oView:AddSheet( 'PASTAS', 'ABA03', STR0017 ) //"Cr�ditos Gerados"
Iif(lReten,oView:AddSheet( 'PASTAS', 'ABA04', STR0018 ),) //"Reten��es"

oView:CreateHorizontalBox( 'BOXABA01', 100,,, "PASTAS", "ABA01" )
oView:CreateHorizontalBox( 'BOXABA02', 100,,, "PASTAS", "ABA02" )
oView:CreateHorizontalBox( 'BOXABA03', 100,,, "PASTAS", "ABA03" )
Iif(lReten,oView:CreateHorizontalBox( 'BOXABA04', 100,,, "PASTAS", "ABA04" ),)
//oView:CreateHorizontalBox( 'BOXABA0401', 50,,, "PASTAS", "ABA04" )
//oView:CreateHorizontalBox( 'BOXABA0402', 50,,, "PASTAS", "ABA04" )

// Relaciona o identificador (ID) da View com o "box" para exibi��o
// Adiciona no nosso View um controle do tipo formul�rio (antiga Enchoice)
oView:SetOwnerView( 'VIEW_FJT', 'SUPERIOR' )

oView:SetOwnerView( 'VIEW_SEL1', 'BOXABA01' )
oView:SetOwnerView( 'VIEW_SEL2', 'BOXABA02' )
oView:SetOwnerView( 'VIEW_SEL3', 'BOXABA03' )
Iif(lReten,oView:SetOwnerView( 'VIEW_SEL4', 'BOXABA04' ),)
//oView:SetOwnerView( 'VIEW_SFE' , 'BOXABA0402' )

//oView:EnableTitleView('VIEW_FJT')
oView:EnableTitleView('VIEW_SEL1',STR0020) //"Valores recebidos como forma de pagamento"
oView:EnableTitleView('VIEW_SEL2',STR0021) //"Documentos pagos e cr�ditos compensados"
oView:EnableTitleView('VIEW_SEL3',STR0022) //"Documentos de cr�dito que foram gerados com o saldo que n�o foi aplicado"
Iif(lReten,oView:EnableTitleView('VIEW_SEL4',STR0023),) //"Certificados de reten��es de impostos recebidos"
//oView:EnableTitleView('VIEW_SFE' ,'Detalles de los certificados de retenci�n')
// Retorna o objeto de View criado
Return oView
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F846Stru  �Autor  �Bruno Sobieski      � Data �  10/27/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Define os campos que serao mostrados em cada pasta          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F846Stru( cCampo,nFolder )
Local lRet := .T.
Local aCposNo	:=	{}
Local aCposNoUsr
Local nX
cCampo	:=	Alltrim(cCampo)

aCposNo	:=	{'EL_FILIAL','EL_RECIBO','EL_CLIORIG','EL_LOJORIG', 'EL_NATUREZ', 'EL_TIPODOC','EL_LA', 'EL_CANCEL','EL_DTDIGIT','EL_PREREC','EL_COBRAD',;
 'EL_RECPROV','EL_CLIENTE', 'EL_LOJA', 'EL_SERIE', 'EL_EMISREC','EL_RETGAN','EL_VERSAO'}
Do Case
	Case nFolder == 1
		AAdd(aCposNo,"EL_JUROS")
		AAdd(aCposNo,"EL_MULTA")
	Case nFolder == 2
		AAdd(aCposNo,"EL_TPCRED")
		AAdd(aCposNo,"EL_BANCO")
		AAdd(aCposNo,"EL_AGENCIA")
		AAdd(aCposNo,"EL_CONTA")
		AAdd(aCposNo,"EL_BCOCHQ")
		AAdd(aCposNo,"EL_AGECHQ")
		AAdd(aCposNo,"EL_CTACHQ")
		AAdd(aCposNo,"EL_OBSBCO")
		AAdd(aCposNo,"EL_ENDOSSA")
		AAdd(aCposNo,"EL_ACREBAN")
		AAdd(aCposNo,"EL_TERCEIR")
		AAdd(aCposNo,"EL_DTDIGIT")
		AAdd(aCposNo,"EL_EMISREC")
		AAdd(aCposNo,"EL_POSTAL")
		AAdd(aCposNo,"EL_TRANSIT")
		AAdd(aCposNo,"EL_TIPODOC")
		AAdd(aCposNo,"EL_CGC")
	Case nFolder == 3
		AAdd(aCposNo,"EL_JUROS")
		AAdd(aCposNo,"EL_MULTA")
		AAdd(aCposNo,"EL_EMISREC")
		AAdd(aCposNo,"EL_TPCRED")
		AAdd(aCposNo,"EL_BANCO")
		AAdd(aCposNo,"EL_AGENCIA")
		AAdd(aCposNo,"EL_CONTA")
		AAdd(aCposNo,"EL_BCOCHQ")
		AAdd(aCposNo,"EL_AGECHQ")
		AAdd(aCposNo,"EL_CTACHQ")
		AAdd(aCposNo,"EL_OBSBCO")
		AAdd(aCposNo,"EL_ENDOSSA")
		AAdd(aCposNo,"EL_ACREBAN")
		AAdd(aCposNo,"EL_TERCEIR")
		AAdd(aCposNo,"EL_DTDIGIT")
		AAdd(aCposNo,"EL_EMISREC")
		AAdd(aCposNo,"EL_POSTAL")
		AAdd(aCposNo,"EL_TRANSIT")
		AAdd(aCposNo,"EL_TIPODOC")
		AAdd(aCposNo,"EL_CGC")
	Case nFolder == 4
		AAdd(aCposNo,"EL_JUROS")
		AAdd(aCposNo,"EL_MULTA")
		AAdd(aCposNo,"EL_EMISREC")
		AAdd(aCposNo,"EL_TPCRED")
		AAdd(aCposNo,"EL_BANCO")
		AAdd(aCposNo,"EL_AGENCIA")
		AAdd(aCposNo,"EL_CONTA")
		AAdd(aCposNo,"EL_BCOCHQ")
		AAdd(aCposNo,"EL_AGECHQ")
		AAdd(aCposNo,"EL_CTACHQ")
		AAdd(aCposNo,"EL_OBSBCO")
		AAdd(aCposNo,"EL_ENDOSSA")
		AAdd(aCposNo,"EL_ACREBAN")
		AAdd(aCposNo,"EL_TERCEIR")
		AAdd(aCposNo,"EL_DTDIGIT")
		AAdd(aCposNo,"EL_EMISREC")
		AAdd(aCposNo,"EL_POSTAL")
		AAdd(aCposNo,"EL_TRANSIT")
		AAdd(aCposNo,"EL_CGC")
EndCase
If ExistBlock('F486CPOS')
	aCposNoUsr	:=	ExecBlock('F486CPOS',.f.,.f.,{aCposNo,nFolder})
	If ValType(aCposNoUsr ) == "A"
		For nX:= 1 to Len(aCposNoUsr)
			aadd(aCposNo,aCposNoUsr[nX])
		Next
	Endif
Endif

lRet := aSCAN(aCposNo,{|x| cCampo==x}) == 0
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F846FillData �Autor  �Bruno Sobieski   � Data �  10/27/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Carrega os dados em cada pasta de acordo com a natureza de  ���
���          �cada um.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F846FillData(oGrid,lCopia,nPasta)
Local aRet := {}
Local aRet2	:=	{}
Local nX        

aRet2  := FormLoadGrid(oGrid,lCopia)
For nX:= 1 TO Len(aRet2)
	SEL->(MsGoto(aRet2[nX,1]))
	Do Case
		Case nPasta == 1 .And. !(Alltrim(SEL->EL_TIPODOC) $'TB/RA/RG/RB/RI/RS/RM')
			aadd(aRet,aClone(aRet2[nX]))
		Case nPasta == 2 .And. (Alltrim(SEL->EL_TIPODOC) =='TB')
			aadd(aRet,aClone(aRet2[nX]) )
		Case nPasta == 3 .And. (Alltrim(SEL->EL_TIPODOC) =='RA')
			aadd(aRet,aClone(aRet2[nX])  )
		Case nPasta == 4 .And. (Alltrim(SEL->EL_TIPODOC) $'RG/RB/RI/RS/RM')
			aadd(aRet,aClone(aRet2[nX]))
	EndCase
Next
Return aRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F846TudoOk    �Autor  �Bruno Sobieski  � Data �  10/27/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de tudoOk. Valida o formulario na confirmacao.       ���
���          �Usar somente a funcao HELP para mostrar mensagens, pois �   ���
���          �a �nica preparada para funcionar no modelo MVC !!!!         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F846TudoOk( oModel )
Local lRet := .T.
Local nOperation 	:= oModel:GetOperation()
Local lIsRotAuto	:=	.F.
Local lAutomato		:= IsBlind()
Local lExclui 		:= .T.
If nOperation == MODEL_OPERATION_DELETE
	If FJT->FJT_VERATU <> '1' 
		lRet	:=	.F.	
		Help(" ",1,"HELP",STR0024,STR0025,1,0) //"Atenci�n","Esta opera��o s� pode ser executada com a ultima vers�o do recibo"
	Endif	
	//Quando a rotina � automatica nao pode mostrar a tela. 
	If lRet .And. !lIsRotAuto
		If FJT->FJT_CANCEL == '1'
			If !lRotAuto
				If (Aviso(STR0024+": "+STR0026,STR0027+chr(13)+chr(10)+STR0028,{STR0029,STR0030}) <> 1) // "Aten��o: "+"Excluss�o","Todas as vers�es deste recibo ser�o excluidas definitivamente dos registros do sistema."+chr(13)+chr(10)+'Confirma � exclus�o?',{'Sim','N�o'})
	            	lRet	:=	.F.
					Help("" ,1, 'Help',STR0031,STR0032, 1, 0 ) //"FA088 - Exclus�o abortada","Opera��o cancelada pelo usuario"			
				Endif
			EndIF
		Else
		  IF !lAutomato
			If !lRotAuto
				Aviso(STR0024+": "+STR0033,STR0034+chr(13)+chr(10)+STR0035,{'Ok'}) //'Aten��o: "+"Cancelamento","Todas as vers�es deste recibo ser�o canceladas","Para excluir definitivamente chamar novamente esta rotina despois de confirmar o cancelamento"
			EndIf
		  Endif
		Endif
	Endif
	If lRet .And. !Fa088VldCa(FJT->FJT_RECIBO,.F.,FJT->FJT_SERIE) //validacao para o peru  
		Help(" ",1,"HELP",STR0036,STR0037,1,0) //"FA088 - RETEN��O APURADA","Ja existe uma apura��o de IGV posterior � data deste recibo. Se ainda n�o foi apresentada, exclua e tente novamente."
		lRet	:=	.F.	
	Endif	
	If lRet
		If !DtMovFin(FJT->FJT_DTDIGI,,"2")					//menor que MV_DATAFIM
			Help ( " ", 1, "DTMOVFIN")
			lRet	:=	.F.
		Else 
			DbSelectArea('SEL')
			DbSetorder(8)
			DbSeek(xFilial()+FJT->FJT_SERIE+FJT->FJT_RECIBO) ///TROCAR REVISA POR VERSAO
			WHILE lRet .And. !Eof() .And. xFilial()+FJT->FJT_SERIE+FJT->FJT_RECIBO+FJT->FJT_VERSAO == EL_FILIAL+EL_SERIE+EL_RECIBO+EL_VERSAO
				If !(SubsTR(EL_TIPODOC,1,2)$"TB|RI|RG|RB|RS|RM")
					SE1->(DbSetOrder(2))
					If SE1->(DbSeek(xFilial("SE1")+SEL->EL_CLIENTE+SEL->EL_LOJA+SEL->EL_PREFIXO+SEL->EL_NUMERO+SEL->EL_PARCELA+SEL->EL_TIPO) )
						//Verifica se teve alguma baixa
						lExclui:=Fa846Pex()
						If SE1->E1_SALDO <> SE1->E1_VALOR .and. !lExclui
							lRet	:=	.F.
							If Subs(EL_TIPODOC,1,2)<>'RA'
								Help( ,, 'Help',, I18N(STR0038,{SEL->EL_PREFIXO+"/"+SEL->EL_NUMERO}), 1, 0 ) //"O documento #1[EL_PREFIXO/EL_NUMERO]# recebido por esta opera��o sofreu cancelamento(s)"
							Else
								Help( ,, 'Help',, I18N(STR0039,{SEL->EL_PREFIXO+"/"+SEL->EL_NUMERO}), 1, 0 ) //"O documento de cr�dito #1[EL_PREFIXO/EL_NUMERO]# gerado por esta opera��o sofreu cancelamento(s)"							
							Endif
							//Verifica se ainda esta em carteira (nao � necess�rio verificar para os titulos de credito gerados)
						ElseIf (Subs(EL_TIPODOC,1,2)<>'RA' .And.!SE1->E1_SITUACA $ "0 ") .and. !lExclui
							//Este cPaisLoc � por causa do tratamento de carteira de cheques, inicialmente implementado s� para Argentina,
							//neste tratamento os cheques podem ter diferentes status, caso nao seja argentina simplesmente avisa que nao esta em carteira
							If cPaisLoc <> 'ARG' .Or. RTRIM(EL_TIPODOC) <> "CH"
								lRet	:=	.F.
								Help( ,, 'Help',, I18N(STR0040,{SEL->EL_PREFIXO+"/"+SEL->EL_NUMERO}), 1, 0 ) //"O documento #1[EL_PREFIXO/EL_NUMERO]# gerado por esta opera��o sofreo altera��es (cobrado,transferido, etc.)"
								//Para os cheques da Argentina verifica o status
							Else
								nRet:=FA088CkSEF(EL_BCOCHQ,EL_AGECHQ,EL_CTACHQ,EL_PREFIXO,EL_NUMERO) //verifica se existe historico ou foi usado na OP
								If nRet == 0 //U
									lRet:=.F.
									Help(" ",1,"HELP",STR0041,STR0042,1,0) //"FA088 - RECIBO LIQUIDADO","Este recibo n�o pode ser cancelado ou excluido."
								Else //N
									lRet:=.F.
									Help(" ",1,"HELP",STR0043,STR0044,1,0) //"FA088 - CHEQUE EM CARTEIRA","Este recibo possui cheque em carteira no Controle de Cheques."
								Endif
							Endif 
						Endif
					Endif
				Endif
				//�����������������������������������������������������Ŀ
				//�Verificar se o documento foi ajustado por diferencia �
				//�de cambio com data posterio a OP                     �
				//�������������������������������������������������������
				If cPaisLoc $ "ARG|URU"
					SIX->(DbSetOrder(1))
					If SIX->(DbSeek('SFR'))
						DbSelectArea('SFR')
						DbSetOrder(1)
						DbSeek(xFilial()+"1"+SEL->EL_CLIENTE+SEL->EL_LOJA+SEL->EL_PREFIXO+SEL->EL_NUMERO+SEL->EL_PARCELA+SEL->EL_TIPO+Dtos(SEL->EL_DTDIGIT),.T.)
						If FR_FILIAL==xFilial() .And.	FR_CHAVOR==SEL->EL_CLIENTE+SEL->EL_LOJA+SEL->EL_PREFIXO+SEL->EL_NUMERO+SEL->EL_PARCELA+SEL->EL_TIPO .And. ;
							SFR->FR_CARTEI=="1" .And. SEL->EL_DTDIGIT <= SFR->FR_DATADI
							Help(" ",1,"HELP",STR0045,I18N(STR0046,{SEL->EL_PREFIXO+"/"+SEL->EL_NUMERO}),1,0) //"FA088 - DIF DE CAMBIO","O cancelamento do documento #1[prefixo/documento]# j� foi corregido por diferen�a de cambio."
							lRet:=.F.
						Endif
						DbSelectArea('SEL')
					Endif
				Endif
				DbSElectArea('SEL')
				dBSkip()
			EndDo
		Endif
	Endif
Endif

If nOperation == MODEL_OPERATION_DELETE

	If !CtbValiDt(,dDataBASE,,,,{"FIN002"},)
		Return
	EndIf
endif


Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fina846Vlr    �Autor  �Bruno Sobieski   � Data �  10/27/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao usada como inicializo padrao dos campos de valores   ���
���          �totais do recibo                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fina846Vlr(nOpcao)
Local nComp	:=	0
Local nTB	:=	0
Local nTR	:=	0
Local nTRa	:=	0
Local nRet	:=	0
Local nDecs := MsDecimais(1)
If aValores <> Nil .And. aValores[1] == FJT->(FJT_FILIAL+FJT_SERIE+FJT_RECIBO+FJT_VERSAO)
	nRet	:=	aValores[2][nOpcao]
Else
	DbSelectArea('SEL')
	DbSetorder(8)
	DbSeek(xFilial()+FJT->FJT_SERIE+FJT->FJT_RECIBO) ///TROCAR REVISA POR VERSAO
	Do While xFilial()==EL_FILIAL .And. EL_RECIBO==FJT->FJT_RECIBO .And. EL_SERIE == FJT->FJT_SERIE
		If EL_VERSAO == FJT->FJT_VERSAO
			If Subs(EL_TIPODOC,1,2)=="TB"
				If EL_TIPO $ MVRECANT+"/"+MV_CRNEG
					nComp	+= EL_VLMOED1
				Else
					nTB	+= EL_VLMOED1
				Endif
			ElseIf   Subs(EL_TIPODOC,1,2)$"RI|RG|RB|RS|RM"
				nTR	+= EL_VLMOED1
			ElseIf Subs(EL_TIPODOC,1,2)=="RA"
				nTRa	+=	EL_VLMOED1
			Endif
		Endif
		DbSkip()
	Enddo
	aValores	:=	{FJT->(FJT_FILIAL+FJT_SERIE+FJT_RECIBO+FJT_VERSAO),{Round(nTB-nTR-nComp+nTRa,nDecs),Round(nTB,nDecs),Round(nTRa,nDecs),Round(nTR,nDecs)}}
	nRet	:=	aValores[2][nOpcao]
Endif
Return nRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fina846grv    �Autor  �Bruno Sobieski   � Data �  10/27/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao qua faz a gravacao do formulario                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FINA846GRV(oModel)
Local cAlias		:= ""
Local cKeyImp		:= ""
Local cArquivo	:= ""
Local nHdlPrv		:= 0
Local nTotalLanc	:= 0
Local cLoteCom	:= ""
Local nLinha		:= 2
Local cPadrao		:= ""
Local lLanctOk	:= .F.
Local lLancPad70:= .F.
Local aFlagCTB	:= {}
Local lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
Local nOrdSE5		:= 0 //Usada para posicionar no indice E5_FILIAL+E5_PROCTRA
Local aTitRec		:= {}
Local aChaveCH	:= {}
Local aChaveRet := {}
Local nChaveCH	:= 0
Local cFilSEF		:= ""
Local cFilFRF		:= ""
Local cChaveCH	:= ""
Local nRegSM0 	:= SM0->(RecNo())
Local nRegAnt		:= SM0->(RecNo())
Local nOperation := oModel:GetOperation()
Local lDigita  	
Local lAglutina	
Local aDiario :={}                                           
Local cSerie	:=	""
Local cRecibo	:=	""
Local lSELComp := .F.
Local aPE846Del := {}
Local lDel      := .F.
Local aAreaSEL := {}

Pergunte('FIN87A',.F.)
Private lGeraLanc	:= If( MV_PAR03==1,.T.,.F.)  // Lanctos. On-Line
lDigita  	:= If( mv_par01==1,.T.,.F.)  // Mostra Lanctos.
lAglutina	:= If( mv_par02==1,.T.,.F.)  // Aglutina Lanctos.

nRegSM0 := SM0->(Recno())
SA1->(DbSetOrder(1))

If nOperation == MODEL_OPERATION_DELETE
	//��������������������������������������������������������������������Ŀ
	//� Punto de Entrada para validar anulaciones/borrados                 �
	//����������������������������������������������������������������������
	If ExistBlock('FIN846DEL')
		aPE846Del := ExecBlock("FIN846DEL", .F., .F., {FJT->FJT_RECIBO, FJT->FJT_SERIE, FJT->FJT_CANCEL, oModel})
		If ValType(aPE846Del) == "A" .And. Len(aPE846Del) == 4 
			If ValType(aPE846Del[1]) == "L"
				If !aPE846Del[1]
					oModel:SetErrorMessage('FINA846', '', 'FINA846', '', aPE846Del[2], aPE846Del[3], aPE846Del[4])    
					Return .F.
				EndIf
			Else
				lDel := .T.
			EndIf
		Else
			lDel := .T.
		EndIf
		If lDel
			oModel:SetErrorMessage('FINA846', '','FINA846', '', "FIN846DEL", OemToAnsi(STR0057), OemToAnsi(STR0058))
			Return .F.
		EndIf
	Endif
	//+--------------------------------------------------------------------------------+
	//�Chequeo que no se puedan cancelar recibos cuyos cheques no estan en Cartera     �
	//+--------------------------------------------------------------------------------+
	If FJT->FJT_CANCEL <> '1'
		// Posiciona Cliente - Sergio Camurca
		SA1->(DbSeek(xFilial("SA1")+FJT->FJT_CLIENT+FJT->FJT_LOJA))
		While SM0->(!Eof()) .And. SM0->M0_CODIGO == cEmpAnt .And. !lSELComp
			cFilAnt  := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
			nRegAnt	 := SM0->(RecNo())
			aChaveCH := {}
			DbSelectArea("SEL")
			DbSetOrder(8)
			DbSeek(FwxFilial("SEL")+FJT->FJT_SERIE+FJT->FJT_RECIBO)
			aAreaSEL := SEL->(GetArea())
			Do While FwxFilial("SEL")==EL_FILIAL.AND.FJT_RECIBO==EL_RECIBO .AND. FJT->FJT_SERIE==EL_SERIE .And. EL_FILIAL == FJT->FJT_FILIAL
				If FJT->FJT_VERSAO == SEL->EL_VERSAO
					If !(Subs(EL_TIPODOC,1,2) $ "RG|RI|RB|RS|RM")
						
						SM0->(dbGoTo(nRegSM0))
						cFilAnt := SM0->M0_CODFIL
						F088AtuaSE1(FJT->FJT_SERIE,FJT->FJT_RECIBO)
						SM0->(dbGoTo(nRegAnt))
						cFilAnt := SM0->M0_CODFIL
						
					Endif
					If cPaisLoc == "ARG" 
      					CancDif() 
					Endif
					If cPaisLoc == "COS"
						aAdd(aTitRec,SEL->(FwxFilial("SE1")+EL_PREFIXO+EL_NUMERO+EL_PARCELA+EL_TIPO))
					EndIf
					IF !Empty(SEL->EL_COBRAD) .and. !(Alltrim(SEL->EL_TIPODOC) $"TB|RA")
						fa088Comis(FJT->FJT_SERIE,FJT->FJT_RECIBO)
					EndIf
					If ALLTRIM(SEL->EL_TIPODOC) == "CH"
						Aadd(aChaveRet,{SEL->EL_BCOCHQ,SEL->EL_AGECHQ,SEL->EL_CTACHQ,SEL->EL_PREFIXO,SEL->EL_NUMERO})
					Endif
				Endif
				RecLock("SEL",.F.)
				Replace EL_CANCEL With .T.
				MsUnLock()
				SEL->(DbSkip())
				lSELComp := IIF(POSICIONE("SX2",1,"SEL","X2_MODO")=="C",.T.,.F.)
			EndDo
			F088DelSE5(FJT->FJT_SERIE,FJT->FJT_RECIBO)
			F088DelRet(aTitRec, FJT->FJT_SERIE, FJT->FJT_RECIBO, FJT->FJT_CLIENT, FJT->FJT_LOJA)  // Borra todos los documentos relativos a Retenciones.
			RestArea(aAreaSEL)
			F088DelNCC(FJT->FJT_SERIE,FJT->FJT_RECIBO,FJT->FJT_VERSAO,SEL->EL_PARCELA)  // excluir as NCCs geradas a partir do recibo excluido
			SM0->(DbSkip())
		End
		//+--------------------------------------------------------------+
		//� Genera asiento contable.                                     �
		//+--------------------------------------------------------------+
		SM0->(dbGoTo(nRegSM0))
		cFilAnt := SM0->M0_CODFIL

		If lGeraLanc // .and. !__TTSInUse
			
			//+--------------------------------------------------------------+
			//� Posiciona numero do Lote para Lancamentos do Financeiro      �
			//+--------------------------------------------------------------+
			dbSelectArea("SX5")
			dbSeek(xFilial()+"09FIN")
			cLoteCom:=IIF(Found(),Trim(X5_DESCRI),"FIN")
			//nHdlPrv:=HeadProva(cLoteCom,"FINA088",Subs(cUsuario,7,6),@cArquivo)
			nHdlPrv := HeadProva( cLoteCom,;
			"FINA088",;
			Substr( cUsuario, 7, 6 ),;
			@cArquivo )
			
			If nHdlPrv <= 0
				Help(" ",1,"A100NOPROV")
			EndIf
		EndIf
		If nHdlPrv > 0 .and. lGeraLanc //.and. !__TTSInUse
			SEL->(DbSetOrder(8))
			SEL->(DbSeek(xFilial("SEL")+FJT->FJT_SERIE+FJT->FJT_RECIBO,.F.))
			Do while !SEL->(EOF()) .And. SEL->EL_RECIBO==FJT_RECIBO .And. SEL->EL_SERIE == FJT->FJT_SERIE
				If UsaSeqCor()
					aDiario := {{"SEL",SEL->(recno()),SEL->EL_DIACTB,"EL_NODIA","EL_DIACTB"}}
				endif
				
				Do Case 
					Case SEL->EL_TIPODOC == "TB" .And. SEL->EL_TIPO $ MV_CRNEG+"/"+MVRECANT .And. VerPadrao("5BV")   //Titulo de Credito
						lLancPad70 := .T. 
						cPadrao := "5BV" 
					Case SEL->EL_TIPODOC == "TB" .And. !(SEL->EL_TIPO $ MV_CRNEG+"/"+MVRECANT) .And. VerPadrao("5BX") // Titulo de Debito
						lLancPad70 := .T.
						cPadrao := "5BX"			
					Case SEL->EL_TIPODOC == "RA" .And. VerPadrao("5BW")
						lLancPad70 := .T. 
						cPadrao := "5BW"
					Case SEL->EL_TIPODOC == "CH" .And. VerPadrao("5BY")
						lLancPad70 := .T.  
						cPadrao := "5BY"
					Case SEL->EL_TIPODOC == "DC" .And. VerPadrao("5BZ")
						lLancPad70 := .T.
						cPadrao := "5BZ"
					Case SEL->EL_TIPODOC == "EF" .And. VerPadrao("5C2")
						lLancPad70 := .T. 
						cPadrao := "5C2"
					Case SEL->EL_TIPODOC == "TF" .And. VerPadrao("5C1")
						lLancPad70 := .T.
						cPadrao := "5C1"
					Case SEL->EL_TIPODOC $ "RS/RL/RB/RI/RG/RR" .And. VerPadrao("5C3")
						lLancPad70 := .T.
						cPadrao := "5C3"
					Otherwise
						lLancPad70 := VerPadrao("576")
						cPadrao := "576"   
				EndCase				
				 
				If lLancPad70
					SA6->(DbsetOrder(1))
					SA6->(DbSeek(xFilial("SA6")+SEL->EL_BANCO+SEL->EL_AGENCIA+SEL->EL_CONTA,.F.))
					SE1->(DbsetOrder(2))
					SE1->(DbSeek(xFilial("SE1")+SEL->EL_CLIORIG+SEL->EL_LOJORIG+SEL->EL_PREFIXO+SEL->EL_NUMERO+SEL->EL_PARCELA+SEL->EL_TIPO,.F.))
					If SEL->EL_LA=="S"
						Do Case
							Case ( Alltrim(SEL->EL_TIPO) == Alltrim(GetSESnew("NCC")) )
								cAlias := "SF1"
							Case ( Alltrim(SEL->EL_TIPO) == Alltrim(GetSESnew("NDE")) )
								cAlias := "SF1"
							Otherwise
								cAlias := "SF2"
						EndCase
						cKeyImp := 	xFilial(cAlias)	+;
						SE1->E1_NUM		+;
						SE1->E1_PREFIXO	+;
						SE1->E1_CLIENTE	+;
						SE1->E1_LOJA
						If ( cAlias == "SF1" )
							cKeyImp += SE1->E1_TIPO
						Endif
						Posicione(cAlias,1,cKeyImp,"F"+SubStr(cAlias,3,1)+"_VALIMP1")
						If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
							aAdd( aFlagCTB, {"EL_LA", "C", "SEL", SEL->( Recno() ), 0, 0, 0} )
						Else
							RecLock("SEL",.F.)
							Replace EL_LA With "C"
							MsUnLock()
						Endif
						
						nTotalLanc := nTotalLanc + DetProva( 	nHdlPrv,;
						cPadrao,;
						"FINA088",;
						cLoteCom,;
						nLinha,;
						/*lExecuta*/,;
						/*cCriterio*/,;
						/*lRateio*/,;
						/*cChaveBusca*/,;
						/*aCT5*/,;
						/*lPosiciona*/,;
						@aFlagCTB,;
						/*aTabRecOri*/,;
						/*aDadosProva*/ )
					Endif
					
				Endif
				
				SEL->(DbSkip())
			ENDDO
			If lLancPad70
				IF cPaisLoc == "PER"
					nOrderSE5:=SE5->(IndexOrd())
					SE5->(dBSetOrder(8))
					IF SE5->(DbSeek(xFilial("SE5")+FJT->FJT_RECIBO+FJT->FJT_SERIE))
						Do While (xFilial("SE5")==SE5->E5_FILIAL .And. FJT->FJT_RECIBO==SE5->E5_ORDREC .And. FJT->FJT_SERIE == SE5->E5_SERREC)
							If !(SE5->E5_TIPODOC $ "BA/JR/MT/OG/DC") .And. SE5->E5_TIPO!="CH"
								nRecOldE5:=SE5->(Recno())
								nProcITF:=SE5->E5_PROCTRA
								nOrdSE5 := SE5ProcInd()
								SE5->(DbSetOrder(nOrdSE5))
								IF SE5->(DBSeek(xFilial("SE5")+nProcITF))
									While !SE5->(Eof()) .And. SE5->E5_PROCTRA == nProcITF
										If lFindITF .And. FinProcITF( SE5->( Recno() ),2 )
											FinProcITF( SE5->( Recno() ),5,, .F.,{ nHdlPrv, "573", "", "FINA089", cLotecom } , @aFlagCTB )
										EndIf
										SE5->(DBSkip())
									Enddo
								Endif
								SE5->(dBSetOrder(8))
								SE5->(DbGoTo(nRecOldE5))
							ENDIF
							SE5->(DBSkip())
						ENDDO
					ENDIF
					SE5->(DbSetOrder(nOrderSE5))
				ENDIF
				//+-----------------------------------------------------+
				//� Envia para Lancamento Contabil, se gerado arquivo   �
				//+-----------------------------------------------------+
				RodaProva(  nHdlPrv,;
				nTotalLanc)
				//+-----------------------------------------------------+
				//� Envia para Lancamento Contabil, se gerado arquivo   �
				//+-----------------------------------------------------+
				lLanctOk := cA100Incl( cArquivo,;
				nHdlPrv,;
				3,;
				cLoteCom,;
				lDigita,;
				lAglutina,;
				/*cOnLine*/,;
				/*dData*/,;
				/*dReproc*/,;
				@aFlagCTB,;
				/*aDadosProva*/,;
				aDiario )
				aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento
				
				If !lLanctOk
					SEL->(DbSeek(xFilial("SEL")+FJT->FJT_SERIE+FJT->FJT_RECIBO))
					Do while FJT->FJT_RECIBO==SEL->EL_RECIBO .AND. FJT->FJT_SERIE==SEL->EL_SERIE .AND. SEL->(!EOF())
						RecLock("SEL",.F.)
						Replace SEL->EL_LA With "S"
						MsUnLock()
						SEL->(DbSkip())
					Enddo
				EndIf
			Endif
		Endif
		cSerie	:=	FJT->FJT_SERIE
		cRecibo	:=	FJT->FJT_RECIBO
		FJT->(DbSetOrder(1))
		FJT->(DbSeek(xFilial()+cSerie+cRecibo))
		While !FJT->(Eof()) .And. xFilial("FJT")+cSerie+cRecibo == FJT->(FJT_FILIAL+FJT_SERIE+FJT_RECIBO)
			RecLock('FJT',.F.)
			FJT_CANCEL	:=	'1'
			MsUnLock()                                                                               
			FJT->(dBsKIP())
		EndDo	
		/*
		Atualiza os arquivos de controle de cheques recebidos*/
		If !Empty(aChaveRet)
			cFilSEF := xFilial("SEF")
			cFilFRF := xFilial("FRF")
			For nChaveCH := 1 To Len(aChaveRet)
				/*
				apaga os registros do historico */
				If FRF->(dbSeek(cFilFRF + aChaveRet[nChaveCH,1] + aChaveRet[nChaveCH,2] + aChaveRet[nChaveCH,3] + aChaveRet[nChaveCH,4] + aChaveRet[nChaveCH,5]))
					While !FRF->(Eof()) .And. FRF->FRF_FILIAL == cFilFRF .And. FRF->FRF_BANCO == aChaveRet[nChaveCH,1]  .And. FRF->FRF_AGENCIA == aChaveRet[nChaveCH,2] ;
						.And. FRF->FRF_CONTA == aChaveRet[nChaveCH,3]  .And. FRF->FRF_PREFIX == aChaveRet[nChaveCH,4] .And. FRF->FRF_NUM == aChaveRet[nChaveCH,5]
						RecLock("FRF",.F.)
						FRF->(DbDelete())
						FRF->(MsUnLock())
						FRF->(dbSkip())
					EndDo
				Endif
				/*
				apaga o registro do cheque */
				cChaveCH := cFilSEF + aChaveRet[nChaveCH,1] + aChaveRet[nChaveCH,2] + aChaveRet[nChaveCH,3] + aChaveRet[nChaveCH,5]
				If SEF->(DbSeek(cChaveCH))
					While !SEF->(Eof())  .And. SEF->EF_FILIAL == cFilSEF .And. SEF->EF_BANCO == aChaveRet[nChaveCH,1] .And. SEF->EF_AGENCIA == aChaveRet[nChaveCH,2] ; 
						  .And. SEF->EF_CONTA == aChaveRet[nChaveCH,3] .And. SEF->EF_NUM == aChaveRet[nChaveCH,5] 
						If  SEF->EF_PREFIXO == aChaveRet[nChaveCH,4]
							RecLock("SEF",.F.)
							SEF->(DbDelete())
							SEF->(MsUnLock())
						Endif
					SEF->(dbSkip())
					EndDo
				Endif
			Next
		Endif
		/**/
		If cPaisLoc == "PER"
			If !(lLancPad) .OR. nHdlPrv <= 0
				nOrderSE5:=SE5->(IndexOrd())
				SE5->(dBSetOrder(8))
				IF SE5->(DbSeek(xFilial("SE5")+FJT->FJT_RECIBO+FJT->FJT_SERIE))
					Do While (xFilial("SE5")==SE5->E5_FILIAL .And. FJT->FJT_RECIBO==SE5->E5_ORDREC .And. FJT->FJT_SERIE == SE5->E5_SERREC)
						If !(SE5->E5_TIPODOC $ "BA/JR/MT/OG/DC") .And. SE5->E5_TIPO!="CH"
							nRecOldE5:=SE5->(Recno())
							nProcITF:=SE5->E5_PROCTRA
							nOrdSE5 := SE5ProcInd()
							SE5->(DbSetOrder(nOrdSE5))
							IF SE5->(DBSeek(xFilial("SE5")+nProcITF))
								While !SE5->(Eof()) .and. SE5->E5_PROCTRA == nProcITF
									If lFindITF .And. FinProcITF( SE5->( Recno() ),2 )
										FinProcITF( SE5->( Recno() ),5,, .F.)
									EndIf
									SE5->(DBSkip())
								Enddo
							Endif
							SE5->(dBSetOrder(8))
							SE5->(DbGoTo(nRecOldE5))
						EndIf
						SE5->(DBSkip())
					ENDDO
				ENDIF
				SE5->(DbSetOrder(nOrderSE5))
			ENDIF
		Endif
	Else
		f088NumPend(FJT->FJT_SERIE,FJT->FJT_RECIBO)
		dbSelectArea("SEL")
		DbSeek(xFilial("SEL")+FJT->FJT_SERIE+FJT->FJT_RECIBO)
		Do While xFilial("SEL")==SEL->EL_FILIAL .AND. FJT->FJT_RECIBO==SEL->EL_RECIBO .AND. FJT->FJT_SERIE==SEL->EL_SERIE
			RecLock("SEL",.F.)
			dbDelete()
			MsUnLock()
			SEL->(dbSkip())
		EndDo
		cSerie	:=	FJT->FJT_SERIE
		cRecibo	:=	FJT->FJT_RECIBO
		FJT->(DbSetOrder(1))
		FJT->(DbSeek(xFilial()+cSerie+cRecibo))
		While !FJT->(Eof()) .And. xFilial('FJT')+cSerie+cRecibo == FJT->(FJT_FILIAL+FJT_SERIE+FJT_RECIBO)
			RecLock('FJT',.F.)
			DbDelete()
			MsUnLock()
			FJT->(dBsKIP())
		EndDo	
	Endif
Endif


DbSelectArea("SEL")
DbSetOrder(1)
Return .T.
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F846Alt       �Autor  �Bruno Sobieski   � Data �  10/27/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para manutencao do recibo. Usa a FINA841.            ���
���Desc.     �deve ser planejado para converter a FINA841 para MVC puro  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function F846Alt(nOpcao)
Local lRet	:=	.T.
Pergunte("FIN87A",.F.)
Private lGeraLanc	:= If( MV_PAR01==1,.T.,.F.)  // Lanctos. On-Line
Private lDigita	:= If( mv_par02==1,.T.,.F.)
Private lAglutina	:= If( mv_par03==1,.T.,.F.)
If F846PreVld(4)
	If nOpcao == 1
		Fina841(FJT->FJT_RECIBO,FJT->FJT_SERIE)
	Else
		Fina841(Nil)
	Endif	
Else
	lRet	:=	.F.
Endif
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F846PreVld    �Autor  �Bruno Sobieski   � Data �  10/27/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para validar que seja excluido o alterado unicamente ���
���Desc.     �a ultima revisao                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F846PreVld(nOperation)
Local lRet := .T. 
Local aArea   	:= GetArea()
Local aChaveCH := {}
Local cChaveCH := ""

If (nOperation == MODEL_OPERATION_DELETE .Or. nOperation == MODEL_OPERATION_UPDATE) .And. FJT->FJT_VERATU <> '1'
	lRet := .F.
	Help(" ",1,"HELP",STR0024,STR0025,1,0) //"Aten��o","Esta opera��o s� pode ser executada com a ultima vers�o do recibo"
Endif  
if lRet    
	DbSelectArea("SEL")
	DbSetOrder(8)
	If DbSeek(FwxFilial("SEL")+FJT->FJT_SERIE+FJT->FJT_RECIBO)
		Aadd(aChaveCH,{SEL->EL_BCOCHQ,SEL->EL_AGECHQ,SEL->EL_CTACHQ,SEL->EL_PREFIXO,SEL->EL_NUMERO})
    Endif
	If Len(aChaveCH)>0
		cChaveCH := xFilial("SEF") + aChaveCH[1,1] + aChaveCH[1,2] + aChaveCH[1,3] + aChaveCH[1,5]
	EndIf
	If SEF->(DbSeek(cChaveCH))
		If nOperation == 5   
			If cPaisLoc != 'ARG' .AND. SEF->EF_STATUS # '01' // Ativo
				Help(" ",1,"HELP",STR0041,STR0042,1,0)//"FA088 - RECIBO LIQUIDADO"//"Este recibo n�o pode ser cancelado ou excluido."
				lRet:=.F.
			ElseIf cPaisLoc == 'ARG'
				If !Fa846Pex() // Verifica se � possivel anular o recibo de acordo com o status do cheque
					Help(" ",1,"HELP","","",1,0)//"Cancelamento n�o permitido"//"Favor consultar o status do cheque na rotina 'FINA096 - Cheques Recebidos'"
					lRet:=.F.
				Endif  
			Endif 
		Endif	
	Endif	
Endif	
RestArea(aArea)
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F846PesqCH    �Autor  �Bruno Sobieski   � Data �  10/27/12  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para pesquisar um recibo de acordo com o cheque      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F846PesqCH(oBrowse) 
Local cQryRecibo	:=	""
Local lRet	:=	.F.
Local cAlsRecibo := GetNextAlias()

If Pergunte('FINA841',.T.)
	cQryRecibo := "SELECT "
	cQryRecibo += " SEL.EL_RECIBO, SEL.EL_SERIE "
	cQryRecibo += " FROM " + RetSqlName("SEL") + " SEL "
	cQryRecibo += " WHERE "
	cQryRecibo += " SEL.EL_NUMERO = '" + MV_PAR01 + "' AND "
	cQryRecibo += " SEL.EL_BCOCHQ = '" + MV_PAR02 + "' AND "
	cQryRecibo += " SEL.EL_AGECHQ = '" + MV_PAR03 + "' AND "
	cQryRecibo += " SEL.EL_CTACHQ = '" + MV_PAR04 + "' AND "
	cQryRecibo += " SEL.EL_TIPODOC = 'CH' AND "
	
	cQryRecibo += RetSqlCond("SEL") 
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryRecibo),cAlsRecibo,.T.,.T.)
	If (cAlsRecibo)->(!Eof())
		FJT->(DbSetOrder(1))
		FJT->(DbSeek(xFilial()+(cAlsRecibo)->EL_SERIE+(cAlsRecibo)->EL_RECIBO))	
		oBrowse:GoTo (FJT->(Recno()),.T.)
		lRet	:=	.T.
	Else
		MsgAlert(STR0047) //"Cheque n�o encontrado"
	EndIf
	(cAlsRecibo)->(DbCloseArea())
Endif
Return lRet

/*
Autor: Nikitenko Artem
date:  11/09/17
Desc.: legend colour
*/

Static Function F846Leg(nReg)
Local uRetorno := .T.
Local aLegenda := {}
	
aLegenda := {	{"BR_VERDE"		,alltrim(STR0056)},;//paid
				{"BR_VERMELHO"	,alltrim(STR0002)}}	//Canceled
	
If nReg == Nil
	uRetorno := {}
	aAdd(uRetorno,{"!Empty(FJK_DTANLI) .And. Empty(FJK_DTCANC) .And. Empty(FJK_ORDPAG)"	, aLegenda[1][1]}) //paid
	aAdd(uRetorno,{"!Empty(FJK_DTCANC)"													, aLegenda[2][1]}) //Canceled
Else
	BrwLegenda(alltrim(STR0055), ' ', aLegenda) //Legend
EndIf
	
Return(uRetorno)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CancDif   �Autor  �Alexander Leite	     � Data �  10/27/12  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para cancelar diferen�a cambiaria   				    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CancDif()

Local aAreaSE1 := SE1->(GetArea())
			
DbSelectArea('SE1')
SE1->(DbSetOrder(1))
	If SE1->(MsSeek(xFilial("SE1")+SEL->EL_PREFIXO+SEL->EL_NUMERO+SEL->EL_PARCELA+SEL->EL_TIPO))
		DbSelectArea("SFR")
		SFR->(DbSetOrder(1))
			If SFR->(MsSeek(xFilial("SFR")+ "1" +PADR(SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO,len(SFR->FR_CHAVDE))))
				SE1->(DbSetOrder(2))
					If SE1->(MsSeek(xFilial("SE1") + SFR->FR_CHAVDE))
						Fa074Canc(.T.)
					Endif
			Endif
	Endif
	RestArea(aAreaSE1)	
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa846Pex    �Autor  �Rafael Antunes   � Data �  27/01/2020  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para valida��o do cancelamento do recibo             ���
��			  de acordo com o status do cheque                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fa846Pex()

Local aAreaSEF := SEF->(GetArea())
Local lRet := .F.
Local aArea := GetArea()

DbSelectArea('SEF')
SEF->(DbSetorder(9)) //EF_FILIAL+EF_BANCO+EF_AGENCIA+EF_CONTA+EF_TITULO
SEF->(DbSeek(xFilial("SEF")+SEL->EL_BCOCHQ + SEL->EL_AGECHQ + SEL->EL_CTACHQ + SEL->EL_RECIBO))                                                                                                                

If cPaisLoc == "ARG" .AND. (SEF->EF_TIPO == 'CH ' .AND. SEF->EF_STATUS $ '01|05') 
	lRet := .T.
Endif 

SEF->(RestArea(aAreaSEF))
RestArea(aArea)

Return lRet
