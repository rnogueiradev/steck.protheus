#include "Totvs.ch"
#Include "Protheus.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "RwMake.ch"
#Include "TbiConn.ch"
#Include "TopConn.ch"

#Define cIDMODEL "Z54MASTER"
#Define cViewID "VIEW_Z54"

Static cUsuaFis       := ""
Static cUsuaCOM       := ""
Static cUsuGCOM       := ""

 /*/{Protheus.doc} STCADSA2()
    (long_description)
    Controle de Cadastro de Fornecedores
    @type  Function
    @author user
    Valdemir Rabelo - SigaMat
    @since date
    23/10/2019
    @example
	u_STCADSA2()
/*/
User Function STCADSA2()
	Local cFilterDefault := ""
	Private cCadastro 	 := "Controle Cadastro Fornecedores"
	Private oBrowse
	Private cTitApr 	 := ""
	Private lAprov       := .F.

	cUsuaFis       := SuperGetMV("ST_CADAPRF",.F.,"001180")     			  // Usuario Fiscal - 
	cUsuaCOM       := SuperGetMV("ST_CADAPRC",.F.,"001181")     	          // Usuario Compras
	cUsuGCOM       := SuperGetMV("ST_CADAPRG",.F.,"001177")     	  		  // Usuario Gerente Compras

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("Z54")					// Alias da tabela utilizada
	oBrowse:SetMenuDef("STCADSA2")			// Nome do fonte onde esta a funÁ„o MenuDef
	oBrowse:SetDescription(cCadastro)   	// DescriÁ„o do browse
	IF (__cUserID $ cUsuaFis)
		oBrowse:SetFilterDefault("Z54->Z54_STATUS == '2'")
		cTitApr 	 := "Aprovador - Fiscal"
	ElseIf (__cUserID $ cUsuaCOM)
		oBrowse:SetFilterDefault("Z54->Z54_STATUS == '3'")
		cTitApr 	 := "Aprovador - Compras"
	ElseIf (__cUserID $ cUsuGCOM)
		oBrowse:SetFilterDefault("Z54->Z54_STATUS == '4'")
		cTitApr 	 := "Aprovador - Gerente Compras"
	Endif
	
	//--------------------------------------------------------
	// Adiciona legenda no Browse
	//--------------------------------------------------------
	oBrowse:AddLegend("Z54_STATUS=='1'", "GREEN",	"Aguardando envio Fiscal")
	oBrowse:AddLegend("Z54_STATUS=='2'", "BLUE",	"Aguardando aprovaÁ„o fiscal")
	oBrowse:AddLegend("Z54_STATUS=='3'", "YELLOW", 	"Aguardando aprovaÁ„o compras")
	oBrowse:AddLegend("Z54_STATUS=='4'", "ORANGE", 	"Aguardando aprovaÁ„o supervisor de compras")
	oBrowse:AddLegend("Z54_STATUS=='6'", "Black", 	"Reprovado Fiscal")
	oBrowse:AddLegend("Z54_STATUS=='7'", "BROWN", 	"Reprovado Compras")
	oBrowse:AddLegend("Z54_STATUS=='5'", "RED", 	"CÛdigo Gerado")

	oBrowse:SetUseCursor(.T.)
	oBrowse:Activate()

Return .T.



//-------------------------------------------------------------------
// Montar o menu Funcional
//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina 		 := {}
	
	lAprov 		 := ((__cUserID $ cUsuaFis) .or. (__cUserID $ cUsuaCOM) .or. (__cUserID $ cUsuGCOM))
    
	ADD OPTION aRotina TITLE "Pesquisar"  	ACTION 'PesqBrw' 			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	ACTION "VIEWDEF.STCADSA2" 	OPERATION 3 ACCESS 0
	IF lAprov
		ADD OPTION aRotina TITLE "Aprovar/Reprovar" ACTION "u_STCADAPROV()" 	OPERATION 2 ACCESS 0     // VIEWDEF.STCADSA2
		
	else
		ADD OPTION aRotina TITLE "Alterar"    	ACTION "VIEWDEF.STCADSA2" 	OPERATION 4 ACCESS 0
		ADD OPTION aRotina TITLE "Excluir"    	ACTION "VIEWDEF.STCADSA2" 	OPERATION 5 ACCESS 0
		ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.STCADSA2"	OPERATION 2 ACCESS 0
	endif
	ADD OPTION aRotina TITLE "Anexar DOC" 	ACTION "u_CadSA2Doc()"		OPERATION 2 ACCESS 0			// Valdemir Rabelo 12/12/2019
	ADD OPTION aRotina TITLE "Legenda"			ACTION "u_CADA2LEG()"		OPERATION 2 ACCESS 0
	//ADD OPTION aRotina TITLE "Copiar" 		ACTION "VIEWDEF.STCADSA2" 	OPERATION 9 ACCESS 0	

Return aRotina


//-------------------------------------------------------------------
// Montando a tela
//-------------------------------------------------------------------
Static Function ViewDef()
	Local oView
	Local oModel 		:= FwLoadModel("STCADSA2")
	Local bAvalCampo 	:= {|cCampo| AllTrim(cCampo)+"|" $ "Z54_CONTRO|Z54_NOME|Z54_LOJA|"}
	Local oStr1		    := FWFormStruct(2, 'Z54')
	Local nOperation    := oModel:GetOperation()
	Local cAprovador    := SuperGetMV("ST_APVCOMP",.f.,"001181")
	
	// Cria o objeto de View
	oView := FWFormView():New()

	oView:Refresh()
	
	// Define qual o Modelo de dados ser· utilizado
	oView:SetModel(oModel)
	
	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField(cViewID , oStr1, cIDMODEL )

    //Remove os campos que n„o ir„o aparecer	
	//oStr1:RemoveField( 'Z54_CONTRO' )
	
	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'PAI', 100)
	
	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView(cViewID,'PAI')
	oView:EnableTitleView(cViewID , 'Principal' )
	oView:SetViewProperty(cViewID , 'SETCOLUMNSEPARATOR', {10})
	
	//Criando grupos
	oStr1:AddGroup( 'GRUPO01', ''				, '', 1 )
	oStr1:AddGroup( 'GRUPO02', 'Banco'	        , '', 2 )
	oStr1:AddGroup( 'GRUPO03', 'Outros'			, '', 3 )
	
	// Colocando alguns campos por agrupamentos'
	oStr1:SetProperty( 'Z54_CONTRO'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_NOME'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_NREDUZ'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_LOJA'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_TIPO'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_INSCR' 	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_CGC'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_END'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_NR_END'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_BAIRRO'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_CEP'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_MUN'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_COD_MU' , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_EST'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_DDD'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_TEL'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStr1:SetProperty( 'Z54_CONTAT' , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )

	oStr1:SetProperty( 'Z54_BANCO' 	, MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStr1:SetProperty( 'Z54_AGENCI'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStr1:SetProperty( 'Z54_X_DVAG'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStr1:SetProperty( 'Z54_NUMCON'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStr1:SetProperty( 'Z54_X_DVCT'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStr1:SetProperty( 'Z54_PAGALT'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStr1:SetProperty( 'Z54_PGALTE'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
		
	oStr1:SetProperty( 'Z54_EMAIL'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	oStr1:SetProperty( 'Z54_CODPAI'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	oStr1:SetProperty( 'Z54_CONTA'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	oStr1:SetProperty( 'Z54_XSOLIC'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	oStr1:SetProperty( 'Z54_XDEPTO'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	oStr1:SetProperty( 'Z54_APRFIS'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	oStr1:SetProperty( 'Z54_APRCOM'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	oStr1:SetProperty( 'Z54_APRGCM'	, MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )

	if  lAprov	// Verifico se È aprovador
		//Criando um bot„o
		oView:AddUserButton( 'Aprovar',  'CLIPS', {|oView| ViewAprov(oView, "A"), oView:oModel:lModify:=.F., oView:lModify:=.F., oView:ButtonCancelAction(),.f. } )   // fechar tela apÛs confirmar (oView:oModel:lModify:=.F., oView:lModify:=.F., oView:ButtonCancelAction(),.f.) 
		oView:AddUserButton( 'Reprovar', 'CLIPS', {|oView| ViewAprov(oView, "R"), oView:oModel:lModify:=.F., oView:lModify:=.F., oView:ButtonCancelAction(),.F. } )
	Endif

	//ForÁa o fechamento da janela na confirmaÁ„o
	oView:SetCloseOnOk( {|| .T.} )
	
Return oView


//-------------------------------------------------------------------
// Montando Modelo de Dados
//-------------------------------------------------------------------
Static Function ModelDef()
	Local oModel
	Local oStr1     := FWFormStruct( 1, 'Z54', /*bAvalCampo*/,/*lViewUsado*/ ) // ConstruÁ„o de uma estrutura de dados
	Local bCancel   := {|oModel| xClosed(oModel) }
	Local bPreValid := { |oModel| GetTela( oModel ) }

	if Empty(cTitApr)
	   cTitApr := cCadastro
	Endif
	
	//Cria o objeto do Modelo de Dados
   //funÁ„o GRVCADSA2 que ser· acionada quando eu clicar no bot„o "Confirmar"
	oModel := MPFormModel():New(cIDMODEL, /*bPreValid*/, { | oModel | GRVCADSA2( oModel ) } , /*{ | oMdl | fEXPMVC1C( oMdl ) }*/ ,bCancel )
	oModel:SetDescription(cTitApr)

	// Adiciona ao modelo uma estrutura de formul·rio de ediÁ„o por campo
	oModel:AddFields(cIDMODEL, /*cOwner*/, oStr1, /*bPreValid*/, /*bPosValid*/, /*bLoad*/)

	//iniciar o campo o conteudo da sub-tabela
	oStr1:SetProperty('Z54_CONTRO' , MODEL_FIELD_INIT, {|| if(INCLUI, GetPrxNum(oModel), NIL)} )
	oStr1:SetProperty('Z54_XDEPTO' , MODEL_FIELD_INIT, {|| GetInic(oModel) } )

    //bloquear/liberar os campos para ediÁ„o
	oStr1:SetProperty('Z54_CONTRO' , MODEL_FIELD_WHEN,{|| .F. })
	oStr1:SetProperty('Z54_PGALTE' , MODEL_FIELD_WHEN,{|| VldAltWhen( oModel )})
	oStr1:SetProperty('Z54_CGC'    , MODEL_FIELD_WHEN,{|| VldCGCWhen( oModel )})
	oStr1:SetProperty('Z54_XSOLIC' , MODEL_FIELD_WHEN,{|| .F. })
	oStr1:SetProperty('Z54_XDEPTO' , MODEL_FIELD_WHEN,{|| .F. })
	oStr1:SetProperty('Z54_APRFIS' , MODEL_FIELD_WHEN,{|| .F. })
	oStr1:SetProperty('Z54_APRCOM' , MODEL_FIELD_WHEN,{|| .F. })
	oStr1:SetProperty('Z54_APRGCM' , MODEL_FIELD_WHEN,{|| .F. })

	
	// Adiciona a STCADSA2 do Componente do Modelo de Dados
	oModel:getModel(cIDMODEL):SetDescription(cCadastro)
	
	//Define a chave primaria utilizada pelo modelo
	oModel:SetPrimaryKey({'Z54_FILIAL','Z54_CONTROLE' })
		
Return oModel

User Function GetVldTela()
	Local oModel	:= FwLoadModel("STCADSA2")
	Local oModelZ54 
	Local nOperat   
	Local cCNPJ     
	Local cINSCEST  
	Local cTIPO     
	Local cMsg      := ""
	Local cLoja     := ""
	Local cEstado   := ""
	Local lRET 		:= .T.
	Local _cMSG     := ""

	oModel:Activate()

	oModelZ54 := oModel:getModel( 'Z54MASTER' )
	nOperat   := oModel:GetOperation()
	cCNPJ     := M->Z54_CGC
	cNOME     := M->Z54_NOME
	cINSCEST  := M->Z54_INSCR	//oModelZ54:GetValue("Z54_INSCR")
	cTIPO     := M->Z54_TIPO	//oModelZ54:GetValue("Z54_TIPO")
	cEstado   := M->Z54_EST

	if cTIPO != "X"
	   if cTIPO=="F"    
	      aAreaSA2 := GetArea()
		  dbSelectArea("SA2")
		  dbSetOrder(3)
	      lRET := (!dbSeek(xFilial("SA2")+cCNPJ))
		  if !lRET
			 cMsg := "O fornecedor "+alltrim(cNOME)+", CPF: "+cCNPJ+",  j· se encontra cadastrado"+CRLF+;
					 "com o cÛdigo: "+SA2->A2_COD+". Cadastro n„o permitido."+CRLF
			 Help( ,, 'Help',, cMsg, 1, 0 )
		  endif
		  RestArea( aAreaSA2 )
	   elseif cTIPO=="J"
			dbSelectArea("SA2")
			dbSetOrder(3)	   
	   		// Verifico a base do CNPJ se ja est· sendo usado
			cCNPJ := Left(M->Z54_CGC,8)
			lRET := (!dbSeek(xFilial("SA2")+cCNPJ))
			if !lRET
			   _cMSG     := "A base do CNPJ: "+cCNPJ+", <B> J· foi utilizada "+CRLF+;
					         " no fornecedor </b><font color='red'>"+SA2->A2_COD+"- "+ALLTRIM(SA2->A2_NOME)+"</b> .</font>  "
			   lRET := MsgYesNo(_cMSG, "AtenÁ„o!")
			   if !lRET
			       return .F.
			   endif
			endif

			cCNPJ := M->Z54_CGC
			_cMSG     := "O fornecedor "+alltrim(cNOME)+", CNPJ: "+cCNPJ+", <font color='red'> J· se "+CRLF+;
							"encontra cadastrado com o cÛdigo: <b>"+SA2->A2_COD+"</b> .</font> Caso voce esteja  "+CRLF+;
							"<b> cadastrando uma nova loja </b> para o Fornecedor <b>continue com a operaÁ„o </b>"

			If !GETCNPJ(cCNPJ, cINSCEST,'V')
				cLoja := GETCNPJ(cCNPJ, '','R')
				if (!Empty(cLoja)) .and. (cLoja !='01')
					
					lRET := MsgYesNo(_cMSG,"AtenÁ„o!")
				    if lRET
						M->Z54_LOJA   := cLoja
						M->Z54_NOME   := SA2->A2_NOME
						M->Z54_NREDUZ := SA2->A2_NREDUZ
					endif				   
				else
				  M->Z54_LOJA   := "01"
				Endif
			Else
				cMsg := "O fornecedor "+alltrim(cNOME)+", CNPJ: "+cCNPJ+", INSC.EST.: "+cINSCEST+" CNPJ e INSC.ESTADUAL encontra cadastrado"+CRLF+;
						"com o cÛdigo: "+SA2->A2_COD+". Cadastro n„o permitido."+CRLF
				Help( ,, 'Help',, cMsg, 1, 0 )
				lRET := .F.
			Endif
	   endif
	Endif

Return lRET


Static Function GetCNPJ(pCNPJ, pINSCEST, pTipo)
	Local cQry       := ''
	Local lRET
	Local aAreaSA2   := GetArea()
	Default pINSCEST := ""

	if pTipo=="R"
		lRET := "  "
	else
	    lRET := .f.
	endif

	dbSelectArea("SA2")
	dbSetOrder(3)
	if dbSeek(xFilial("SA2")+pCNPJ)
		While !Eof() .and. SA2->A2_CGC==pCNPJ
		    if pTipo=="V"
				if pINSCEST==SA2->A2_INSCR
				   lRET := .T.
				   Exit			   
				Endif
			elseif pTipo=="R"
				if lRET < SA2->A2_LOJA
				   lRET := SA2->A2_LOJA
				endif
			Endif
			dbSkip()
		EndDo
		if pTipo=="R"
			lRET := soma1(lRET)
		Endif
	Endif
	/*
	if pTipo=="V"
		//pINSCEST := iif(alltrim(pINSCEST)=="ISENTO","",pINSCEST)
	endif


	cQry := "SELECT A2_LOJA, A2_CGC, R_E_C_N_O_ REG " + CRLF
	cQry += "FROM " + RETSQLNAME("SA2") + " SA2 " + CRLF
	cQry += "WHERE SA2.D_E_L_E_T_ = ' ' " + CRLF
	cQry += " AND A2_CGC='"+pCNPJ+"' " + CRLF
	if pTipo=="V"
		cQry += " AND A2_INSCR='"+pINSCEST+"' " + CRLF
	Endif
	cQry += "ORDER BY A2_CGC, a2_loja DESC" + CRLF
	IF Select("TCGC") > 0
	   TCGC->( dbCloseArea() )
	Endif
	tcQuery cQry New Alias "TCGC"

	If TCGC->( !EOF() )
	   if TCGC->REG > 0
	      SA2->( dbGoto(TCGC->REG) )
	   endif
	   if pTipo=="R"
	   	  lRET := SOMA1(TCGC->LOJA)
	   else
	      lRET := (!Empty(TCGC->LOJA))
	   endif
	ELSE
		if pTipo=="R"
			lRET := "01"
		else
			lRET := .T.
		endif	   
	Endif

	IF Select("TCGC") > 0
	   TCGC->( dbCloseArea() )
	Endif
*/
	RestArea( aAreaSA2 )

Return lRET

//-------------------------------------------------------------------
// Gera o prÛximo numero de controle
//-------------------------------------------------------------------
Static Function GetPrxNum(oModel)
	Local oModelZ54 := oModel:GetModel( cIDMODEL )
	Local cPrxNum   := GetSXENum("Z54","Z54_CONTRO")
	Local cRET      := cPrxNum
	Local aAreaPrx  := GetArea()

	dbSelectArea('Z54')
	dbSetOrder(1)

	While dbSeek(xFilial('Z54')+cPrxNum)
	    cPrxNum := Soma1(cPrxNum)
	EndDo

	cRET := cPrxNum
	RestArea( aAreaPrx )
	RollbackSx8()

Return cRET


//-------------------------------------------------------------------
// Montar o inicializador padr„o
//-------------------------------------------------------------------
Static Function GetInic(oModel)
	Local oModelZ54 := oModel:GetModel( cIDMODEL )
	Local cRET 		:= cUserName
	Local aUsr 		:= FWSFALLUSERS()
	Local _cDEPTO   := ""

	nPos := aScan(aUsr, {|x| x[3]==cRET }) 
    if (nPos > 0)
        cRET := aUsr[nPos][6] 		
    endif	

Return cRET



//-------------------------------------------------------------------
// Salva registro
// Input: Model
// Retorno: Se erros foram gerados ou n„o
//-------------------------------------------------------------------
Static Function GRVCADSA2( oModel )
	Local lRet      := .T.
	Local oModelZ54 := oModel:GetModel( cIDMODEL )   
	Local oModView  := oModelZ54:GetModel(cViewID )
	Local nOpc      := oModel:GetOperation()
	Local aArea     := GetArea()
	Local lEnviaE   := .F.
	Local cMsgEmail := ""
	Local lNovo     := .F.

	//Capturar o conteudo dos campos
	Local cChave	:= oModelZ54:GetValue('Z54_CONTRO')
	Local cStatus	:= oModelZ54:GetValue('Z54_STATUS')
	Local cSolic    := oModelZ54:GetValue('Z54_XSOLIC')
	Local nxOpc     := 0
	Local cEmail    := ""

	dbSelectArea("Z54")
	dbSetOrder(1)
	
	Begin Transaction
		
		if ((nOpc == 3) .or. (nOpc == 4)) //.and. !lAprov
			if (Empty(cStatus) .or.cStatus=='1') .or. (nOpc == 4)
				nxOpc := Aviso("AtenÁ„o!", "Grava os dados e Envia WF ao Fiscal?", {"SÛ Gravar", "Gravar e Enviar","Cancelar"}, 3, "")
				If nxOpc == 3
				   xClosed(oModelZ54)
				   Return
				Elseif nxOPC == 2
				   lEnviaE := .T.
				EndIf
			Endif
			if (!lEnviaE)
			   _cStatus := '1'
			else
			   _cStatus := '2'
			   cEmail := GetEmail(cUsuaFis)
			endif
			oModelZ54:SetValue('Z54_STATUS', _cStatus)						
			FWFormCommit( oModel )

		Elseif nOPC == 5
		   if cStatus == '5'
		      LjMsgRun("Exclus„o Negada. Registro j· criado na tabela de fornecedores","AtenÁ„o!", {|| Sleep(4000)})
			  Return
		   Else
			if MsgNoYes("Deseja realmente excluir o registro?", "AtenÁ„o!")
				RecLock("Z54", .F.)
				dbDelete()
				MsUnlock()
			endif
		   Endif
		Endif
		
		if !lRet
			DisarmTransaction()
		Endif
		
	End Transaction

	if lEnviaE
	   EnvMail(cEmail, nxOpc, cChave, _cStatus)
	Endif
	
	RestArea(aArea)
	
	FwModelActive( oModel, .T. )
	
Return lRet

//-------------------------------------------------------------------
// Pressionado bot„o Cancelar
// Input: Model
// Retorno: Aplica o Rollback para voltar a numeraÁ„o sequencial
//-------------------------------------------------------------------
Static Function xClosed(oModel)
	Local nOperation := oModel:GetOperation()
	Local lRet := .T.

	IF nOperation == 3
		RollbackSx8()
	Endif

Return .T.


//-------------------------------------------------------------------
// Faz liberaÁ„o ou blqueio do campo Tipo de Pagto.
// Input: Model
// Retorno: LÛgico
//-------------------------------------------------------------------
Static Function VldAltWhen(oModel)
	Local lRET := .t.
	Local oModWhen := oModel:GetModel( cIDMODEL )
	
	lRET := (oModWhen:GetValue("Z54_PAGALT")=="S")
	
Return lRET


//-------------------------------------------------------------------
// Faz liberaÁ„o ou blqueio do campo Tipo de Fornecedor
// Input: Model
// Retorno: LÛgico
//-------------------------------------------------------------------
Static Function VldCGCWhen(oModel)
	Local lRET := .t.
	Local oModWhen := oModel:GetModel( cIDMODEL )
	
	lRET := (UPPER(oModWhen:GetValue("Z54_TIPO")) != "X")
	
Return lRET


//-------------------------------------------------------------------
// Busca e-mail conforme par‚metro passado
// Input: Model
// Retorno: String
//-------------------------------------------------------------------
Static Function GetEmail(cUsuMail)
	Local aGrpMail := Separa(cUsuMail,"/",.F.)
	Local nX   := 0
	Local cRET := ""
	Local cCodTMP := ""

	if VldUsu(cUsuMail)
	   PswOrder(2)
		if PswSeek( cUsuMail, .T. )
			cCodTMP := PswID()
		endif
	   cRET := UsrRetMail( cCodTMP ) 
	else
		For nX := 1 to Len(aGrpMail)
			if nX > 1
			cRET += ","
			Endif
			cRET += UsrRetMail(aGrpMail[nX])
		Next
	Endif

Return cRET


//-------------------------------------------------------------------
// Valida Usu·rio. Verifica se foi passado usu·rio 
// Input: Model
// Retorno: LÛgico
//-------------------------------------------------------------------
Static Function Vldusu(pcUsuMail)
	Local lRET := .F.
	Local aVld := Separa("A/a/E/e/I/i/O/o/U/u",'/')
	Local nX   := 0

	For nX := 1 to Len(aVld)
		if !lRET
		   lRET := (At(aVld[nX], pcUsuMail) > 0)
		Endif
	Next

Return lRET


//-------------------------------------------------------------------
// Monta e envia e-mail conforme status do registro
// Input: Model
// Retorno: nil
//-------------------------------------------------------------------
Static Function EnvMail(cEmail, nxOpc, cChave, _cStatus)
	Local aArea     := Getarea()
	Local _aMsg     := {}
	Local cMsgSt    := ""
	Local cMsg      := ""
	Local cCC       := ""
	Local _cAssunto := ""
	Local cSubject  := "solicitaÁ„o Analise ( Fornecedores )"
	Local _nLin

	IF 		_cStatus=='2'
		cMsgSt := "PENDENTE DE APROVA«√O - FISCAL"
	ELSEIF 	_cStatus=='3'
		cMsgSt := "PENDENTE DE APROVA«√O - COMPRAS"
	ELSEIF 	_cStatus=='4'
		cMsgSt := "PENDENTE DE APROVA«√O - GERENTE"
	ELSEIF 	_cStatus=='5'
		cMsgSt := "CODIGO GERADO"
	ELSEIF 	_cStatus=='6'
		cMsgSt := "REPROVADO SETOR FISCAL"
	ELSEIF 	_cStatus=='7'
		cMsgSt := "REPROVADO SETOR COMPRAS"
	ENDIF

	_cAssunto := cMsgSt

	dbSelectArea("Z54")
	dbSetOrder(1)
	if dbSeek(xFilial("Z54")+cChave)
	   Aadd( _aMsg , { "Numero Controle: " , cValtoChar(Z54->Z54_CONTRO) } )
	   Aadd( _aMsg , { "Nome Fornecedor: " , cValtoChar(Z54->Z54_NOME) } )
	   Aadd( _aMsg , { "CNPJ: " , cValtoChar(Z54->Z54_CGC) } )
	   Aadd( _aMsg , { "STATUS: " , cMsgSt } )
	Endif

	//A Definicao do cabecalho do email                                             
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	//A Definicao do texto/detalhe do email                                         
	For _nLin := 1 to Len(_aMsg)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf

		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

	Next

	//A Definicao do rodape do email                                               
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1"></td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'
	
	RestArea( aArea )

	U_STMAILTES(cEmail, cCC, cSubject, cMsg,{},"")

Return

//-------------------------------------------------------------------
// Gera registro na SA2
// Input: Model
// Retorno: LÛgico
//-------------------------------------------------------------------
Static Function GeraCod(cChave)
	Local aRegis		:= {}
	Local aArea         := GetArea()
	Local cCodFor       := ""
	Local cArqErro      := "Err_STCADSA2_"+DTOS(dDatabase)+"_"+strtran(Time(),":","")+".log"
	Local lRET          := .T.
	Local oModSA2       := nil
	Local oSA2Mod       := nil
	Private lMsErroAuto := .F.

	dbSelectArea('Z54')
	dbSetOrder(1)
	if dbSeek(XFilial("Z54")+cChave)

		cCodFor := GetSxeNum("SA2","A2_COD")
		ConfirmSx8()

		//Pegando o modelo de dados, setando a operaÁ„o de inclus„o
		oModSA2 := FWLoadModel("MATA020")
		oModSA2:SetOperation(3)
		oModSA2:Activate()		

		//Pegando o model dos campos da SA2
		oSA2Mod:= oModSA2:getModel("SA2MASTER")    			 // MATA020_SA2
		oSA2Mod:setValue("A2_COD",       cCodFor           ) // Codigo 
		oSA2Mod:setValue("A2_LOJA",      Z54->Z54_LOJA     ) // Loja
		oSA2Mod:setValue("A2_NOME",      Z54->Z54_NOME     ) // Nome             
		oSA2Mod:setValue("A2_NREDUZ",    Z54->Z54_NREDUZ   ) // Nome reduz. 
		oSA2Mod:setValue("A2_END",       Z54->Z54_END	   ) // Endereco
		oSA2Mod:setValue("A2_BAIRRO",    Z54->Z54_Bairro   ) // Bairro
		oSA2Mod:setValue("A2_TIPO",      Z54->Z54_TIPO 	   ) // Tipo 
		oSA2Mod:setValue("A2_EST",       Z54->Z54_EST      ) // Estado
		oSA2Mod:setValue("A2_CONTATO",	 Z54->Z54_CONTAT   ) // Contato              
		oSA2Mod:setValue("A2_MUN",       Z54->Z54_MUN      ) // Municipio
		oSA2Mod:setValue("A2_CODPAIS",   Z54->Z54_CODPAI   ) // CODIGO PAIS
		oSA2Mod:setValue("A2_CEP",       Z54->Z54_CEP      ) // CEP
		oSA2Mod:setValue("A2_XSOLIC",	 Z54->Z54_XSOLIC   ) // Solicitante
		oSA2Mod:setValue("A2_CGC",       Z54->Z54_CGC      ) // CNPJ/CPF            
		oSA2Mod:setValue("A2_INSCR",  	 Z54->Z54_INSCR    ) // InscriÁ„o Estadual
		oSA2Mod:setValue("A2_XDEPTO",	 Z54->Z54_XDEPTO   ) // Departamento
		oSA2Mod:setValue("A2_EMAIL",     Z54->Z54_EMail    ) // E-Mail
		oSA2Mod:setValue("A2_DDD",       Z54->Z54_DDD      ) // DDD            
		oSA2Mod:setValue("A2_TEL",       Z54->Z54_Tel      ) // Fone 
		oSA2Mod:setValue("A2_BANCO",	 Z54->Z54_BANCO    ) // Banco
		oSA2Mod:setValue("A2_AGENCIA",	 Z54->Z54_AGENCI   ) // Agencia
		oSA2Mod:setValue("A2_X_DVAGE",	 Z54->Z54_X_DVAG   ) // Dig Agencia
		oSA2Mod:setValue("A2_NUMCON",	 Z54->Z54_NUMCON   ) // Numero Conta
		oSA2Mod:setValue("A2_X_DVCTA",	 Z54->Z54_X_DVCT   ) // Dig Conta
		oSA2Mod:setValue("A2_CONTA",	 Z54->Z54_CONTA	   ) // Conta Cont·bil
		oSA2Mod:setValue("A2_MSBLQL",    "2"   			   ) // Bloqueado

		//Se conseguir validar as informaÁıes
		lRET := oModSA2:VldData()

		IF lRET	
			//Tenta realizar o Commit
			lRET := oModSA2:CommitData()			
		EndIf
		
		//Se n„o deu certo a inclus„o, mostra a mensagem de erro
		If ! lRET
			//Busca o Erro do Modelo de Dados
			aErro := oModSA2:GetErrorMessage()
			
			//Monta o Texto que ser· mostrado na tela
			AutoGrLog("Id do formul·rio de origem:"  + ' [' + AllToChar(aErro[01]) + ']')
			AutoGrLog("Id do campo de origem: "      + ' [' + AllToChar(aErro[02]) + ']')
			AutoGrLog("Id do formul·rio de erro: "   + ' [' + AllToChar(aErro[03]) + ']')
			AutoGrLog("Id do campo de erro: "        + ' [' + AllToChar(aErro[04]) + ']')
			AutoGrLog("Id do erro: "                 + ' [' + AllToChar(aErro[05]) + ']')
			AutoGrLog("Mensagem do erro: "           + ' [' + AllToChar(aErro[06]) + ']')
			AutoGrLog("Mensagem da soluÁ„o: "        + ' [' + AllToChar(aErro[07]) + ']')
			AutoGrLog("Valor atribuÌdo: "            + ' [' + AllToChar(aErro[08]) + ']')
			AutoGrLog("Valor anterior: "             + ' [' + AllToChar(aErro[09]) + ']')
			
			//Mostra a mensagem de Erro
			MostraErro()
		EndIf
		
		//Desativa o modelo de dados
		oModSA2:DeActivate()		

	Endif

	RestArea( aArea )

Return lRET


//-------------------------------------------------------------------
// Abre tela de Aprovador
// Input: Model
// Retorno: Nil
//-------------------------------------------------------------------
User Function STCADAPROV()
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,"Fechar"},{.F.,"Reprovar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
	Local nRsult   := 0
	
	nRsult := FWExecView('Aprovar Fornecedores','STCADSA2', MODEL_OPERATION_VIEW, , { || .T. }, , ,aButtons )

Return

//-------------------------------------------------------------------
// Rotina que far· a aprovaÁ„o ou reprovaÁ„o
// Input: Model
// Retorno: nil
//-------------------------------------------------------------------
Static Function ViewAprov(oModel, cApr)
	Local oModelZ54 := oModel:GetModel( cIDMODEL )
	Local cChave	:= oModelZ54:GetValue('Z54_CONTRO')
	Local _cStatus  := oModelZ54:GetValue("Z54_STATUS")
	Local cSolic    := oModelZ54:GetValue("Z54_XSOLIC")
	Local lEnvMail  := .F.

	Begin Transaction

	dbSelectArea("Z54")
	dbSetOrder(1)
	dbSeek(xFilial("Z54")+cChave)

	if cApr=="A"
	   nxOpc := 1
	Else
	   nxOpc := 2
	Endif

	// Atualiza Status
	RecLock("Z54", .F.)
	if _cStatus=='2'
		if nxOpc==1
			_cStatus := '3'				// Fiscal
			cEmail := GetEmail(cUsuaCom)
		else
			_cStatus := '6'
			cEmail  := GetEmail(cSolic) 
		endif
		lEnvMail  		:= .T.
		Z54->Z54_APRFIS :=  cUSERNAME

	elseif _cStatus=='3'
		if nxOpc==1
			_cStatus := '4'
			cEmail   := GetEmail(cUsuGCOM)
		else
			_cStatus := '7'
			cEmail  := GetEmail(cSolic)
		endif
		lEnvMail  		:= .T.	
		Z54->Z54_APRCOM := cUSERNAME
	elseif _cStatus=='4'
		if nxOpc==1
			_cStatus := '5'
			cEmail   := GetEmail(cSolic)
		else
			_cStatus := '7'
			cEmail  := GetEmail(cSolic)
		endif
		lEnvMail  		:= .T.	
		Z54->Z54_APRGCM := cUSERNAME
	Endif
	Z54->Z54_STATUS := _cStatus
	MsUnlock()

	if _cStatus=='5'
	    LjMsgRun("Gerando cÛdigo para o fornecedor. Aguarde...","AtenÁ„o!",{|| lEnvMail := GeraCod(cChave) })
		if !lEnvMail
		      DisarmTransaction()
 		Endif
	Endif

	End Transaction

	if lEnvMail
	   EnvMail(cEmail, nxOpc, cChave, _cStatus)
	endif

	oModel:ButtonCancelAction()
	oModel:SetCloseOnOk( {|| .t.})
	
Return

//-------------------------------------------------------------------
// Cria a legenda para tela
// Input: Model
// Retorno: nil
//-------------------------------------------------------------------
User Function CADA2LEG()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",    "Aguardando envio Fiscal"  })
    AADD(aLegenda,{"BR_AZUL",     "Aguardando aprovaÁ„o fiscal"})
    AADD(aLegenda,{"BR_AMARELO",  "Aguardando aprovaÁ„o compras"})
    AADD(aLegenda,{"BR_LARANJA",  "Aguardando aprovaÁ„o supervisor de compras"})
    AADD(aLegenda,{"BR_PRETO",    "Reprovado Fiscal"})
    AADD(aLegenda,{"BR_MARROM",   "Reprovado Compras"})
    AADD(aLegenda,{"BR_VERMELHO", "CÛdigo Gerado"})
     
    BrwLegenda("Regra das Cores", "Fornecedores", aLegenda)

Return


//-------------------------------------------------------------------
// Ponto de Entrada para controlar campos, conforme necessidade
// Input: Model
// Retorno: lÛgico
//-------------------------------------------------------------------
User Function Z54MASTER()
	Local aArea			:= GetArea()
	Local aParam 		:= PARAMIXB
	Local lRET          := .T.
	Local nOper         := 0
	Local cMsg          := ""

	If aParam <> NIl

		oObj       := aParam[1]
    	cIdPonto   := aParam[2]
       	cIdModel   := aParam[3]

       	If cIdPonto == "MODELVLDACTIVE"
		   nOper := oObj:nOperation
		   
		   if nOper == 4
			  if (Z54->Z54_STATUS =="4") 
				 cMsg := 'Registro n„o pode ser alterado, pois est· aguardando aprovaÁ„o.'
			  elseif (Z54->Z54_STATUS =="5") 
				 cMsg := 'Registro n„o pode ser alterado, pois o cÛdigo j· foi gerado.'
			  Endif
			  if (Z54->Z54_STATUS $ "4/5")
				 Help( ,, 'Help',, cMsg, 1, 0 )
				 lRET := .F.
			  Endif
		   Elseif nOper == 5
				IF (Z54->Z54_STATUS $ "2/3/4")
					cMsg :="Registro n„o pode ser excluÌdo, aguardando aprovaÁ„o."
				ElseIF (Z54->Z54_STATUS $ "5") 
				   cMsg := "Registro n„o pode ser excluÌdo, pois o cÛdigo j· foi gerado"
				Endif
				IF (Z54->Z54_STATUS $ "2/3/4/5") 
					Help( ,, 'Help',, cMsg, 1, 0 )
					lRet := .F.
				Endif
		   Endif
		   
		ElseIf cIdPonto == 'MODELPOS'

        ElseIf cIdPonto == "MODELCOMMITTTS"

            If nOper == 4

            EndIf


		ElseIf cIdPonto == "MODELCOMMITNTTS"

			If nOper == 3 .Or. nOper == 4 // Inclusao ou Alteracao

			EndIf

        EndIf

	EndIf

	RestArea( aArea )

Return lRET


User Function CadSA2Doc()
	STANEX(.T.)
Return .T.


Static Function STANEX(_lT)

	Local aArea       := GetArea()
	Local aArea1      := Z54->(GetArea())

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
	Local cSolicit	  := 	Z54->Z54_CONTRO

	Private _cPath      := GetSrvProfString("RootPath","")
	Private _cStartPath := "\arquivos\FORNECEDORES\"
	Private _cEmp       := ""+cEmpAnt+"\"
	Private _cFil       := ""
	Private _cNUm       := ""+Z54->Z54_CONTRO+"\"
	Private _cServerDir   := ''
	Default _lT := .f.
	If !_lT
		If Inclui
			MsgInfo("Anexo so pode ser incluido apos a GravaÁ„o do Fornecedor...!!!!")
			Return()
		EndIf
	EndIf

	//CriaÁ„o das pastas para salvar os anexos das SolicitaÁıes do Fornecedor no Servidor
	_cServerDir += (_cStartPath)
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	_cServerDir += _cEmp
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	if !Empty(_cFil)
		_cServerDir += _cFil
		If MakeDir (_cServerDir) == 0
			MakeDir(_cServerDir)
		Endif
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

		DbSelectArea("Z54")
		Z54->(DbSetOrder(1))
		If Z54->(DbSeek(xFilial("Z54")+cSolicit))
			dDtEmiss   := Z54->Z54_CONTRO
			cNameSolic := Z54->Z54_XSOLIC  
			cForneced  := Z54->Z54_NOME
			cCNPJ      := Z54->Z54_CGC

			Do While !lSaida
				nOpcao := 0

				Define msDialog oDxlg Title "Selecione os Anexos " From 10,10 TO 450,600 Pixel
				_nLin := 005
				@ _nLin,010 say "N∫ SC" COLOR CLR_BLACK    Of oDxlg Pixel
				@ _nLin,040 get cSolicit  when .f. size 050,08  Of oDxlg Pixel

				@ _nLin,110 say "Solicitante" COLOR CLR_BLACK   Of oDxlg Pixel
				@ _nLin,140 get  cNameSolic  when .f. size 090,08  Of oDxlg Pixel


				_nLin += 013
				@ _nLin,010 say "Fornecedor" COLOR CLR_BLACK    Of oDxlg Pixel
				@ _nLin,040 get cForneced  when .f. size 050,08  Of oDxlg Pixel


				@ _nLin,110 say "CNPJ" COLOR CLR_BLACK   Of oDxlg Pixel
				@ _nLin,140 get  cCNPJ  when .f. size 090,08  Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 01"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne01     when .f.   size 165,08  Of oDxlg Pixel
				if (cUserName == alltrim(Z54->Z54_XSOLIC)) 
				   @ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne01:=SaveAnexo(1,_cAne01,cSolicit)) Of oDxlg Pixel
				Endif
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne01:=DelAnexo (1,_cAne01,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne01:=OpenAnexo(1,_cAne01,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 02"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne02     when .f.   size 165,08  Of oDxlg Pixel
				if (cUserName == alltrim(Z54->Z54_XSOLIC))
				   @ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne02:=SaveAnexo(2,_cAne02,cSolicit)) Of oDxlg Pixel
				Endif
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne02:=DelAnexo (2,_cAne02,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne02:=OpenAnexo(2,_cAne02,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 03"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne03     when .f.   size 165,08  Of oDxlg Pixel
				if (cUserName == alltrim(Z54->Z54_XSOLIC))
				   @ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne03:=SaveAnexo(3,_cAne03,cSolicit)) Of oDxlg Pixel
				Endif
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne03:=DelAnexo (3,_cAne03,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne03:=OpenAnexo(3,_cAne03,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 04"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne04     when .f.   size 165,08  Of oDxlg Pixel
				if (cUserName == alltrim(Z54->Z54_XSOLIC))
				   @ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne04:=SaveAnexo(4,_cAne04,cSolicit)) Of oDxlg Pixel
				Endif
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne04:=DelAnexo (4,_cAne04,cSolicit)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne04:=OpenAnexo(4,_cAne04,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 05"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne05     when .f.   size 165,08  Of oDxlg Pixel
				if (cUserName == alltrim(Z54->Z54_XSOLIC))
					@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne05:=SaveAnexo(5,_cAne05,cSolicit)) Of oDxlg Pixel
				Endif
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


 /*/{Protheus.doc} SaveAnexo
    (long_description)
    Salva anexo referente ao registro selecionado
    @type  Function
    @author user
    Valdemir Rabelo - SigaMat
    @since date
    13/12/2019
    @example
/*/
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
	Local lArvore   := .F. /*.T. = apresenta o ·rvore do servidor || .F. = n„o apresenta*/
	Local _cMsgSave := ""
	Local aArea1    := GetArea()
	Local aArea2    := Z54->(GetArea())

	//Local nOpcoes   := GETF_LOCALHARD
	// Op√ß√µes permitidas
	//GETF_NOCHANGEDIR    // Impede que o diretorio definido seja mudado
	//GETF_LOCALFLOPPY    // Mostra arquivos do drive de Disquete
	//GETF_LOCALHARD      // Mostra arquivos dos Drives locais como HD e CD/DVD
	//GETF_NETWORKDRIVE   // Mostra pastas compartilhadas da rede
	//GETF_RETDIRECTORY   // Retorna apenas o diret√≥rio e n„o o nome do arquivo

	_cLocArq  := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar,, lArvore)

	If !(Empty(_cLocArq))
		nTamOrig := Directory(_cLocArq)[1,2]
		If (nTamOrig/nMB) > (nMB*nTamMax)
			Aviso("Tamanho do Arquivo Superior ao Permitido"; //01 - cTitulo - T√≠tulo da janela
			,"O Arquivo '"+_cArq+"' tem que ter tamanho m·ximo de "+cValtoChar(nTamMax)+"MB."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"AÁ„o n„o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as op√ß√µes dos bot√µes.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri√ß√£o (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op√ß√£o padr√£o usada pela rotina autom·tica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi√ß√£o do campo memo
			,;                               //09 - nTimer - Tempo para exibi√ß√£o da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op√ß√£o padr√£o apresentada na mensagem.
			)
			Return
		EndIf

		If Len(Directory(_cServerDir+Strzero(_nSave,6)+".mzp")) = 1
			_lRet := MsgYesNo("J· existe um arquivo anexado."+ Chr(10) + Chr(13) +" Deseja sobrepor o arquivo existente ???","AtenÁ„o")
		Endif

		If _lRet

			_cLocArq  := Alltrim(_cLocArq)
			_cDir     := SUBSTR(_cLocArq, 1                      ,RAT( "\"   , _cLocArq ))
			_cArq     := SUBSTR(_cLocArq, RAT( "\"   , _cLocArq ),Len(_cLocArq))
			_cArq     := StrTran(_cArq,"\","")
			cExtensao := SUBSTR(_cLocArq,Rat(".",_cLocArq),Len(_cLocArq))

			If At(".",cExtensao) == 1

				_cSave := Strzero(_nSave,6)

				// Copio o arquivo original da m·quina do usu·rio para o servidor
				lSucess   := __CopyFile(_cLocArq,_cServerDir+_cSave+cExtensao)

				If lSucess

					// Realizo a compactAÁ„o do arquivo para a Extens„o .mzp
					MsCompress((_cServerDir+_cSave+cExtensao),(_cServerDir+_cSave+".mzp"))

					// Apago o arquivo original do servidor
					Ferase( _cServerDir+_cSave+cExtensao)
					Aviso("Anexar Arquivo"; //01 - cTitulo - T√≠tulo da janela
					,"O Arquivo '"+_cArq+"' foi anexado com sucesso.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as op√ß√µes dos bot√µes.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descri√ß√£o (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Op√ß√£o padr√£o usada pela rotina autom·tica
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edi√ß√£o do campo memo
					,;                               //09 - nTimer - Tempo para exibi√ß√£o da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Op√ß√£o padr√£o apresentada na mensagem.
					)
				Else
					_cSave := ''
					Aviso("Problema ao Anexar Arquivo"; //01 - cTitulo - T√≠tulo da janela
					,"O Arquivo '"+_cArq+"' n„o foi anexado."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Favor verificar com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as op√ß√µes dos bot√µes.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descri√ß√£o (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Op√ß√£o padr√£o usada pela rotina autom·tica
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edi√ß√£o do campo memo
					,;                               //09 - nTimer - Tempo para exibi√ß√£o da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Op√ß√£o padr√£o apresentada na mensagem.
					)
				EndIf
			Else
				Aviso("Problema com Extens„o do Anexo"; //01 - cTitulo - T√≠tulo da janela
				,"A Extens„o "+cExtensao+" È inv·lida para anexar junto a solicitaÁ„o de Compras."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"AÁ„o n„o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as op√ß√µes dos bot√µes.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descri√ß√£o (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Op√ß√£o padr√£o usada pela rotina autom·tica
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edi√ß√£o do campo memo
				,;                               //09 - nTimer - Tempo para exibi√ß√£o da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Op√ß√£o padr√£o apresentada na mensagem.
				)
			Endif
		Else
			_cSave := _cFile
		Endif

	Else
		_cSave := _cFile
		Aviso("Anexar Arquivo"; //01 - cTitulo - T√≠tulo da janela
		,"Nenhum Arquivo foi selecionado para ser anexado.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op√ß√µes dos bot√µes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri√ß√£o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op√ß√£o padr√£o usada pela rotina autom·tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi√ß√£o do campo memo
		,;                               //09 - nTimer - Tempo para exibi√ß√£o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op√ß√£o padr√£o apresentada na mensagem.
		)
	Endif

	RestArea(aArea2)
	RestArea(aArea1)

Return(_cSave)



 /*/{Protheus.doc} SaveAnexo
    (long_description)
    Deleta anexo referente ao registro selecionado
    @type  Function
    @author user
    Valdemir Rabelo - SigaMat
    @since date
    16/12/2019
    @example
/*/
Static Function DelAnexo(_nDel,_cFile,cSolicit)

	Local _cDelete := ''
	Local _lRet    := .T.
	Local _cMsgDel := ""
	Local aArea1   := GetArea()
	Local aArea2   := Z54->(GetArea())

	If Len(Directory(_cServerDir+_cFile)) = 1
		_lRet := MsgYesNo("Deseja deletar o Arquivo ??? "+ Chr(10) + Chr(13) +" Uma vez confirmada essa AÁ„o o arquivo n„o ficar· mais dispon√≠vel para consulta.","AtenÁ„o")
	Else
		_lRet := .F.
		Aviso("Deletar Anexo"; //01 - cTitulo - T√≠tulo da janela
		,"n„o existe nenhum Arquivo para ser deletado."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"AÁ„o n„o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op√ß√µes dos bot√µes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri√ß√£o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op√ß√£o padr√£o usada pela rotina autom·tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi√ß√£o do campo memo
		,;                               //09 - nTimer - Tempo para exibi√ß√£o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op√ß√£o padr√£o apresentada na mensagem.
		)
	Endif

	If _lRet
		Ferase( _cServerDir+_cFile)
	Else
		_cDelete := _cFile
	Endif

	RestArea(aArea2)
	RestArea(aArea1)

Return (_cDelete)



 /*/{Protheus.doc} OpenAnexo
    (long_description)
    Abre anexo referente ao registro selecionado
    @type  Function
    @author user
    Valdemir Rabelo - SigaMat
    @since date
    13/12/2019
    @example
/*/
Static Function OpenAnexo(_nOpen,_cFile,cSolicit)

	Local _cOpen      := ''
	Local cZipFile    := ''
	Local _cSaveArq   := "C:\ARQUIVOS_PROTHEUS\"
	Local _cLocalDir  := ''
	Local _cStartPath := "arquivos\"
	Local _cStartPath1 := "FORNECEDORES\"
	Local _lUnzip     := .T.

	//CriAÁ„o das pastas para salvar os anexos das Solicita√ß√µes de Compras na m·quina Local do usu·rio
	_cLocalDir += (_cSaveArq)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += (_cStartPath)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

/*
	_cLocalDir += (_cStartPath1)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif
*/
	_cLocalDir += _cEmp
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += _cFil+"\"
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += _cNUm
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
				Aviso("Erro para Descompactar Anexo"; //01 - cTitulo - T√≠tulo da janela
				,"Houve erro para Descompactar o Anexo."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as op√ß√µes dos bot√µes.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descri√ß√£o (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Op√ß√£o padr√£o usada pela rotina autom·tica
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edi√ß√£o do campo memo
				,;                               //09 - nTimer - Tempo para exibi√ß√£o da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Op√ß√£o padr√£o apresentada na mensagem.
				)
			Endif
		Else
			_cOpen  := _cFile
			Aviso("Anexo inv·lido"; //01 - cTitulo - T√≠tulo da janela
			,"n„o existe nenhum anexo no Protheus para ser aberto."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"AÁ„o n„o permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as op√ß√µes dos bot√µes.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri√ß√£o (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op√ß√£o padr√£o usada pela rotina autom·tica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi√ß√£o do campo memo
			,;                               //09 - nTimer - Tempo para exibi√ß√£o da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op√ß√£o padr√£o apresentada na mensagem.
			)
		Endif
	Else
		Aviso("Erro ao Salvar Anexo"; //01 - cTitulo - T√≠tulo da janela
		,"Houve erro ao Salvar o Anexo."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op√ß√µes dos bot√µes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri√ß√£o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op√ß√£o padr√£o usada pela rotina autom·tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi√ß√£o do campo memo
		,;                               //09 - nTimer - Tempo para exibi√ß√£o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op√ß√£o padr√£o apresentada na mensagem.
		)
	Endif

Return (_cOpen)
