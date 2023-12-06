#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
	"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
	"    border-top-width: 3px; "+;
	"    border-left-width: 3px; "+;
	"    border-right-width: 3px; "+;
	"    border-bottom-width: 3px }"+;
	"QPushButton:pressed {	color: #FFFFFF; "+;
	"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
	"    border-top-width: 3px; "+;
	"    border-left-width: 3px; "+;
	"    border-right-width: 3px; "+;
	"    border-bottom-width: 3px }"



/*/{Protheus.doc} STAGNDPD
    description
    Rotina Manutenção de Agenda Portal
    @type function
    @version  
    @author Valdemir Jose
    @since 07/07/2021 
    @return return_type, return_description
    u_STAGNDPD
/*/
User Function STAGNDPD()
	Local oDlg        := Nil
	Local cImageAtu   := ""
	Local nAltura     := 0
	Local nLargura    := 0
	Local cUsrGer     := GetMV("ST_AGNDUSR",.F.,'000366,001375')     // Carla lodetti
	Local cFiltro     := " ZS3_FILIAL='"+XFILIAL("ZS3")+"' .AND. Alltrim(ZS3_USUARI)=='"+Alltrim(cUserName)+"' .or. u_GETVND(ZS3->ZS3_PEDIDO, .T.)"
	Private cCadastro := "Manutenção de Agendamento Portal"
	Private INCLUI    := .f.
	Private aSeek     := {}
	Private aFiltro   := {}

	dbSelectArea("ZS3")

	if !(__cUSERID $ cUsrGer)
		ZS3->( dbSetFilter( {|| cFiltro}, cFiltro) )
	endif 

	// Define as Colunas
	aColunas := {}

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
	//cIdGrid  	:= oTela:CREATEVERTICALBOX( 40 )

	oTela:Activate( oDlg, .F. )

	//Cria os paineis onde serao colocados os browses
	oPanelUp  	:= oTela:GeTPanel( cIdCab )
	//oPanelDown	:= oTela:GeTPanel( cIdGrid )

	Define Font oFont Name 'Courier New' Size 0, -12

	oBrowse := FWMBrowse():New()
	oBrowse:SetOwner(oPanelUp)
	oBrowse:SetAlias("ZS3")		// Indica o Alias da tabela utilizada no Browse
	oBrowse:SetWalkThru(.F.)
	oBrowse:SetUseFilter(.F.)

/*
    *** Removido por apresentar problemas na pesquisa ***   Problemas no Objeto
	oBrowse:= FWBrowse():New()
	oBrowse:SetOwner(oPanelUp)
	oBrowse:SetDataTable(.T.)
	oBrowse:SetAlias("ZS3")
	oBrowse:SetDescription(cCadastro)
*/
	//--------------------------------------------------------
	// Adiciona legenda no Browse
	//--------------------------------------------------------
	ADD LEGEND DATA "ZS3->ZS3_STATUS==' ' .and. Empty(ZS3->ZS3_NOTAFI)"  COLOR "PINK"       TITLE "Pendente de Faturamento"	OF oBrowse
	ADD LEGEND DATA "ZS3->ZS3_STATUS==' ' .and. !Empty(ZS3->ZS3_ENVIWF)" COLOR "GREEN"      TITLE "Pendente Agendamento WF enviado"	OF oBrowse
	ADD LEGEND DATA "ZS3->ZS3_STATUS==' ' .and. Empty(ZS3->ZS3_ENVIWF)"  COLOR "YELLOW" 	TITLE "Pendente Agendamento WF Não Enviado, Aguarde."	OF oBrowse
	ADD LEGEND DATA "ZS3->ZS3_STATUS=='A'" COLOR "BLUE"		TITLE "Agendamento Realizado"	OF oBrowse
	ADD LEGEND DATA "ZS3->ZS3_STATUS=='R'" COLOR "RED" 		TITLE "Retirada Concluída"      OF oBrowse
/*
	//oBrowse:SetCacheView(.T.) //-- Desabilita Cache da View, pois gera colunas dinamicamente

	oBrowse:SetColumns( GetColumns() )

	oBrowse:SetDBFFilter()
	//oBrowse:SetFilterDefault( "" )
	oBrowse:SetLocate()             // Habilita a Localização de registros
	oBrowse:SetSeek()      // Habilita a Pesquisa de registros
	oBrowse:DisableReport()
	//oBrowse:DisableConfig()
	//oBrowse:SetFieldFilter(aFiltro)   // problemas não assumiu o dicinário informado.
	oBrowse:SetUseFilter()            // Habilita a utilização do Filtro de registros
	// Define ação na troca de linha (Change)
	//oBrowse:SetChange({|oBrowse| ChangePict(oBrowse) })

	*/

	oBrowse:Activate()

	// // relaciona os paineis aos componentes
	oBar := FWButtonBar():New()
	oBar:Init( oPanelUp , 25 , 25 , CONTROL_ALIGN_TOP , .T. )

	//oBar:AddBtnImage( "ADICIONAR_001.PNG" 		,'Incluir Agenda'   ,{|| STAGND01(3) } ,, .T., CONTROL_ALIGN_LEFT )
	//oBar:AddBtnImage( "ALTERA.PNG"        		,'Alterar Agenda'   ,{|| STAGND01(4) } ,, .T., CONTROL_ALIGN_LEFT )
	oBar:AddBtnImage( "BMPVISUAL.PNG" 		    ,'Visualizar Agenda',{|| STAGND01(1) } ,, .T., CONTROL_ALIGN_LEFT )
	//oBar:AddBtnImage( "EXCLUIR.PNG"       		,'Excluir Agenda'   ,{|| STAGND01(5) } ,, .T., CONTROL_ALIGN_LEFT )

	oBar:AddBtnImage( "BAIXATIT.PNG"       		,'Reenvia WF'       ,{|| ReenviWF(oBrowse)  } ,, .T., CONTROL_ALIGN_LEFT )
	oBar:AddBtnImage( "PMSCOLOR.PNG"       		,'Legenda'          ,{|| LegendBrw() } ,, .T., CONTROL_ALIGN_LEFT )
	oBar:AddBtnImage( "FINAL.PNG"        		,'Sair'             ,{|| oDlg:End()} ,{|| .T.}, .T., CONTROL_ALIGN_LEFT )

	ACTIVATE MSDIALOG oDlg CENTERED

Return



/*/{Protheus.doc} GetColumns
description
Rotina que controla colunas
@type function
@version  
@author Valdemir Jose
@since 07/07/2021
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
	Local cAlias    := "ZS3"

	aFiltro := {}
	aCampos := {'ZS3_CODIGO', ;
            'ZS3_ENVIWF',;
			'ZS3_HRENV',;
			'ZS3_TIPORT', ; 	
			'ZS3_PEDIDO', ; 
			'ZS3_CLIENT',;	
			'ZS3_RAZAOS', ;
			'ZS3_DATA',;
			'ZS3_HORA',;
			'ZS3_NOTAFI',; 
			'ZS3_DTNFIS',;
			'ZS3_HRNFIS',;
			'ZS3_DATAGE',; 	
			'ZS3_HORAGE',; 	
			'ZS3_MOTORI',; 	
			'ZS3_CPF',;
			'ZS3_VEICUL',;
			'ZS3_PLACA',;
			'ZS3_NVENDE';
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
					// monta pesquisa
					if (AllTrim(aCampos[nX]) $ "ZS3_CODIGO/ZS3_PEDIDO/ZS3_PLACA/ZS3_NOTAFI/ZS3_CPF")
					   	Aadd(aSeek  , {X3Titulo(), {{"",SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_TAMANHO, 5, SX3->X3_CAMPO}} } )
						//Montar filtro de pesquisa de determinados campos
						Aadd(aFiltro, {SX3->X3_CAMPO, X3Titulo(), SX3->X3_TIPO, SX3->X3_TAMANHO, 5, PesqPict(SX3->X3_ARQUIVO, SX3->X3_CAMPO, )})
					endif
				Else
					aColumns[nLinha]:SetData( &("{|| "+cIniBrw+" }") )
				EndIf
				aColumns[nLinha]:SetTitle(X3Titulo())
				aColumns[nLinha]:SetSize(SX3->X3_TAMANHO)
				aColumns[nLinha]:SetDecimal(SX3->X3_DECIMAL)

			EndIf
            
		EndIf
	Next nX

	RestArea(aArea)

Return(aColumns)


Static Function ChangePict( oBrowse )

	Local cAlias    := ""
	Local cImage    := ""
	Local nPos      := 0

	Default oBrowse := Nil

	If ValType(oBrowse) == "O" //.And. ValType(__oImagem) == "O" .And. Valtype(__aIMGZebra) == "A"


		cAlias := oBrowse:GetAlias()

		//oTScrollBox:Reset()
		oBrowse:Refresh(,.F.,.F.)

	EndIf

Return( oBrowse )


/*/{Protheus.doc} STAGND01
description
Rotina que controla os dados de inclusão/Alteração/Visualiza
@type function
@version  
@author Valdemir Jose
@since 07/07/2021
@param nOPC, numeric, param_description
@return return_type, return_description
/*/
Static Function STAGND01(nOPC)
	INCLUI := (nOPC==3)
	if (nOPC==1)
		AxVisual("ZS3",Recno(),2)
	elseif nOPC==3
		AxInclui("ZS3", 0, 3)
	elseif nOPC==4
		AxAltera("ZS3", Recno(), 4)
	endif

Return

/*/{Protheus.doc} LegendBrw
description
Rotina para apresentar legenda
@type function
@version  
@author Valdemir Jose
@since 07/07/2021
@return return_type, return_description
/*/
Static Function LegendBrw()
	Local aLegenda := {	;
		{ "BR_PINK",      "Pendente de Faturamento"},;
		{ "BR_AMARELO"	, "Pendente Agendamento WF Não Enviado, Aguarde."},;
		{ "BR_VERDE"	, "Pendente Agendamento WF enviado"},;
		{ "BR_AZUL"		, "Agendamento Realizado"},;
        { "BR_VERMELHO"	, "Retirada Concluída"};
        }

	BrwLegenda( "", "Status", aLegenda )

Return .T.


Static Function BaixaAGN()
	Local aBaix := GetArea()
	Local cMsg  := ""

	if  (ZS3->ZS3_STATUS=='R')
		FWMsgRun(,{|| Sleep(3000)},'Informativo','Protocolo: '+ZS3->ZS3_CODIGO+' Pedido: '+ZS3->ZS3_PEDIDO+' já retirado.')
		Return
	elseif (ZS3->ZS3_STATUS=='P') .or. Empty(ZS3->ZS3_STATUS)
		FWMsgRun(,{|| Sleep(3000)},'Informativo','Protocolo: '+ZS3->ZS3_CODIGO+' Pedido: '+ZS3->ZS3_PEDIDO+' não pode baixar, pois não foi feito agendamento.')
		Return
	endif

	cCod  := ZS3->ZS3_CODIGO
	cData := DTOC(ZS3->ZS3_DATAGE)
	cHora := ZS3->ZS3_HORAGE
	cPedi := ZS3->ZS3_PEDIDO

	cMsg := "<B>Deseja realmente efetuar a baixa do agendamento?</B>"+ CRLF + ""
	cMsg += "Protocolo: <FONT COLOR=RED>" + cCod + "</FONT>"+ CRLF + ""
	cMsg += "Pedido: <FONT COLOR=RED>" + cPedi + "</FONT>"  + CRLF + ""
	cMsg += "Data Agendamento: <FONT COLOR=RED>" + cData + "</FONT>" + CRLF + ""
	cMsg += "Hora Agendamento: <FONT COLOR=RED>" + cHora + "</FONT>"

	if apMsgYesNo(cMsg,'Atenção!')
		RECLOCK("ZS3",.F.)
		ZS3->ZS3_STATUS := 'R'
		MSUnlock()
	endif

	RestArea( aBaix )

Return


/*/{Protheus.doc} getStatus
description
Rotina que apesenta o Status
@type function
@version  
@author Valdemir Jose
@since 18/03/2021
@param pSTATUS, param_type, param_description
@return return_type, return_description
/*/
Static Function getStatus(pSTATUS)
	Local oRET := nil
	Local oVerde := LoadBitmap( GetResources(), "BR_VERDE" )
	Local oVerme := LoadBitmap( GetResources(), "BR_VERMELHO" )
	Local oAzul  := LoadBitmap( GetResources(), "BR_AZUL" )

	if pSTATUS == "R"        // R= Retirado
		oRET := LoadBitmap( GetResources(), "BR_VERMELHO" )
	elseif pSTATUS == "A"    // A= Agendado
		oRET := LoadBitmap( GetResources(), "BR_AZUL" )
	else                     // vazio ou P= Pendente
        if Empty(ZS3->ZS3_NOTAFI)
		    oRET := LoadBitmap( GetResources(), "BR_ROSA" )
        else 
           oRET := LoadBitmap( GetResources(), "BR_VERDE" )
        endif 
	endif

Return oRET

/*/{Protheus.doc} ReenviWF
description
Rotina para Reenviar WF de Agendamento
@type function
@version  
@author Valdemir Jose
@since 07/07/2021
@return variant, return_description
/*/
Static Function ReenviWF(oBrowse)
	Local aAreZS3  := GetArea()
	Local aArquivo := {}
	Local cEmlCli  := ""
    Local nRec     := ZS3->( RECNO() )

    dbSelectArea("SF2")
    dbSetOrder(1)

    dbSelectArea("SC5")
    dbSetOrder(1)

    if ZS3->ZS3_STATUS == "R" 
		FWMsgRun(,{|| Sleep(3000)},,"WF não será enviado. Retirada já Concluída")
		Return
    Endif 

    if ZS3->ZS3_STATUS == "A" 
		FWMsgRun(,{|| Sleep(3000)},,"WF não será enviado. Retirada já foi Agendado")
		Return
    Endif 

    if Empty(ZS3->ZS3_PEDIDO)
		FWMsgRun(,{|| Sleep(3000)},,"O campo Pedido não pode estar em branco")
		Return
    Endif 

    if !dbSeek(xFilial("SC5")+ZS3->ZS3_PEDIDO)
		FWMsgRun(,{|| Sleep(3000)},,"Pedido: "+ZS3->ZS3_PEDIDO+' Não Encontrado (SC5)')
		Return
    endif 

    if Empty(ZS3->ZS3_NOTAFI)
		FWMsgRun(,{|| Sleep(3000)},,"O campo Nota Fiscal não pode estar em branco")
		Return
    Endif 

	if SF2->( !dbSeek(xFilial("SF2")+ZS3->ZS3_NOTAFI+'001') )
		FWMsgRun(,{|| Sleep(3000)},,"Nota Fiscal: "+ZS3->ZS3_NOTAFI+' Não Encontrada (SF2)')
		Return
	endif

	IF SC5->( FIELDPOS('C5_XEMAILR') > 0)
		IF !Empty(SC5->C5_XEMAILR)
			cEmlCli := ALLTRIM(SC5->C5_XEMAILR)

			if !Empty(cEmlCli)
			   // Ticket: 20210727013853 - Valdemir Rabelo 16/08/2021
			   cEmlCli := FWInputBox("Informe o(s) e-mail(s) para envio do WF", cEmlCli)
			   if Empty(cEmlCli)
			      FWMsgRun(,{|| Sleep(3000)},"Informe","E-mail não pode ser em branco")
				  Return
			   Endif 
				
				If File("\arquivos\xml_nfe\"+cEmpAnt+"\"+SF2->F2_CHVNFE+".pdf") .And.;
						File("\arquivos\xml_nfe\"+cEmpAnt+"\"+SF2->F2_CHVNFE+".xml")
					aAdd(aArquivo, SF2->F2_CHVNFE+".pdf")
					aAdd(aArquivo, SF2->F2_CHVNFE+".xml")
					//StaticCall (APIAGEPD, EnviaWF, cEmlCli, 'ZS3',,{} ,aArquivo, "\arquivos\xml_nfe\"+cEmpAnt+"\")
					u_EnviaWF(cEmlCli, 'ZS3',,{} ,aArquivo, "\arquivos\xml_nfe\"+cEmpAnt+"\")
					
					RecLock("ZS3",.f.)
					ZS3->ZS3_ENVIWF := dDatabase
					ZS3->( MsUnlock() )
                    ZS3->( dbGoBottom() )
                    ZS3->( dbGotop() )
                    ZS3->( dbGoto(nRec) )
                    oBrowse:Refresh()
                   FWMsgRun(,{|| Sleep(3000)},"Informativo","WF Reenviado com sucesso!")
				Else 
                   FWMsgRun(,{|| Sleep(3000)},"Informativo","Arquivo: "+SF2->F2_CHVNFE+".xml não encontrado.")
                endif
				aArquivo := {}
			endif

		ENDIF
	ENDIF

	RestArea( aAreZS3 )

Return


User Function GETVND(pPEDIDO, lUsuario)
	Local aAreaV := GetArea()
	Local cRET   
	Default lUsuario := .F.

	IF lUsuario
	   cRET := .f.
	ENDIF 
	
	dbSelectArea("SA3")
	dbSetOrder(1)
	dbSelectArea("SC5")
	dbSetOrder(1)
	if dbSeek(xFilial("SC5")+pPEDIDO)
	   if SA3->( dbSeek(xFilial("SA3")+SC5->C5_VEND1) )
	      if !lUsuario
	      	 cRET := SA3->A3_NOME
		  else 
		     cRET := (ALLTRIM(__cUSERID) == ALLTRIM(SA3->A3_CODUSR))
			 if !cRET 
				if SA3->( dbSeek(xFilial("SA3")+SC5->C5_VEND2) )
					cRET := (ALLTRIM(__cUSERID) == ALLTRIM(SA3->A3_CODUSR))
				endif 
			 Endif 
		  endif 
	   Else  
			if SA3->( dbSeek(xFilial("SA3")+SC5->C5_VEND2) )
				if !lUsuario
					cRET := SA3->A3_NOME
				else 
				   cRET := (ALLTRIM(__cUSERID) == ALLTRIM(SA3->A3_CODUSR))
					if !cRET 
						if SA3->( dbSeek(xFilial("SA3")+SC5->C5_VEND1) )
							cRET := (ALLTRIM(__cUSERID) == ALLTRIM(SA3->A3_CODUSR))
						endif 
					Endif 
				endif 
			Endif
	   Endif 

	Endif 

	RestArea( aAreaV )

Return cRET 


/*/{Protheus.doc} SC5PosCl
description
Rotina para posicionar e retornar o cliente do pedido
Ticket: 20210727013853
@type function
@version  
@author Valdemir Jose
@since 16/08/2021
@param pPedido, variant, param_description
@return variant, return_description
/*/
User Function SC5PosCl(pPedido)
	Local cNomCli  := ""
	Local aAreaSC5 := GetArea()

	dbSelectArea("SC5")
	dbSetOrder(1)
	if dbSeek(xFilial("SC5")+pPedido)
       cNomCli := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENT+SC5->C5_LOJACLI,"A1_NOME")
	endif 

	RestArea( aAreaSC5 )

Return cNomCli





User Function STAGE001()
	Local oMBrowse


oMBrowse:SetExecuteDef(2)		// Elemento do aRotina executado no duplo clique
oMBrowse:Activate()	

Return 
