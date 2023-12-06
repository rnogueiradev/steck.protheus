#Include "Protheus.ch"
#Include "FWMvcDef.CH"
#include "topconn.ch"
#Define CR chr(13)+ chr(10)

/*/{Protheus.doc} STAV360

Cadastros de Usuarios FEEDBACK 360

@type function
@author Everson Santana
@since 12/03/19
@version Protheus 12 - Gestão de Pessoal

@history , ,

/*/

User Function STAV3602()

	Private oBrowse := FwMBrowse():New()				//Variavel de Browse

	DbSelectArea("Z32")
	Z32->(DbSetOrder(1))

	If __cUserId $ GetMv('STSTAV3602',,'000915')//Ticket 20211217026944
	
	Z32->(dbSetFilter({|| Z32->Z32_SUPUSR = __cUserId .OR. Z32->Z32_SUPUSR = "001256" },'Z32->Z32_SUPUSR = __cUserId .OR. Z32->Z32_SUPUSR = "001256"' ))
	
	Else
	
	Z32->(dbSetFilter({|| Z32->Z32_SUPUSR = __cUserId },'Z32->Z32_SUPUSR = __cUserId' ))

	EndIf
	
	//Alias do Browse
	oBrowse:SetAlias('Z32')

	//Descrição da Parte Superior Esquerda do Browse
	oBrowse:SetDescripton("Avaliado")

	//Habilita os Botões Ambiente e WalkThru
	//oBrowse:SetAmbiente(.T.)
	//oBrowse:SetWalkThru(.T.)

	//Desabilita os Detalhes da parte inferior do Browse
	//oBrowse:DisableDetails()

	//Legendas do Browse
	oBrowse:AddLegend( "Empty(Z32_STATUS)"	, "GREEN"	, "WF Não enviado"  )
	oBrowse:AddLegend( "Z32_STATUS = 'S'"	, "RED"  	, "WF Enviado" )
	oBrowse:AddLegend( "Z32_STATUS = 'R' "	, "ORANGE" , "WF Reenviado" ) 

	//Ativa o Browse
	oBrowse:Activate()

Return

Static Function MenuDef()

	Local aMenu :=	{}
	Private _UserRh := GetMv('ST_STAV360',,'000000/000308/000210')

	ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       		OPERATION 1 ACCESS 0
	ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.STAV3602'	OPERATION 2 ACCESS 0
	ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.STAV3602' 	OPERATION 4 ACCESS 0
	ADD OPTION aMenu TITLE 'Enviar WF'  ACTION 'U_STAV3612C' 			OPERATION 4 ACCESS 0

	If __cUserId $ _UserRh
		ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.STAV3602' 	OPERATION 3 ACCESS 0
	EndIf

Return(aMenu)

Static Function ModelDef()

	Local oStruct1	:=	FWFormStruct(1,'Z32',{|X|ALLTRIM(X)$"Z32_XEMP,Z32_XFILIA,Z32_ANO,Z32_MAT,Z32_NOME,Z32_USER"} ) //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
	Local oStruct2	:=	FWFormStruct(1,'Z33') //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
	Local oModel
	Local bLinePre := { |oModelGrid, nLine, cAction, cField| STAV3602a(oModelGrid, nLine, cAction, cField) }
	Local bPosVal1 := { |oModel| STAV3612b( oModel ) }
	Local _lValRh 	:= .F.
	Private _UserRh := GetMv('ST_STAV360',,'000000/000308/000210')

	//Instancia do Objeto de Modelo de Dados Ponto de entrada
	oModel:=MpFormModel():New('PEAV3602',/*Pre-Validacao*/,bPosVal1 /*Pos-Validacao*/,,/*Commit*/,/*Cancel*/)

	If __cUserId $ _UserRh
		_lValRh := .T.
	EndIf

	oStruct1:setProperty('Z32_ANO'	,MODEL_FIELD_WHEN,{|| _lValRh})
	oStruct1:setProperty('Z32_MAT'	,MODEL_FIELD_WHEN,{|| _lValRh})
	oStruct1:setProperty('Z32_NOME'	,MODEL_FIELD_WHEN,{|| _lValRh})
	oStruct1:setProperty('Z32_USER'	,MODEL_FIELD_WHEN,{|| _lValRh})

	oStruct2:setProperty('Z33_MAT'	,MODEL_FIELD_WHEN,{|| .F.})
	//Adiciona um modelo de Formulario de Cadastro Similar à Enchoice ou Msmget
	oModel:AddFields('M_Z32', /*cOwner*/, oStruct1, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	//Adiciona um Modelo de Grid similar à MsNewGetDados, BrGetDb
	oModel:AddGrid( 'M_Z33', 'M_Z32', oStruct2,  bLinePre , /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

	oModel:GetModel( 'M_Z33' ):SetUniqueLine( { 'Z33_MATAVA','Z33_USRAVA' } )

	// Faz relaciomaneto entre os compomentes do model

	oModel:SetRelation( 'M_Z33', { 	{ 'Z33_FILIAL'	, 'xFilial( "Z33")' },;
	{ 'Z33_ANO' 	, 'Z32_ANO'  },;
	{ 'Z33_MAT' 	, 'Z32_MAT'  },;
	{ 'Z33_XEMPFU' 	, 'Z32_XEMP'},;
	{ 'Z33_XFILFU' 	, 'Z32_XFILIA'} ,;
	{ 'Z33_USER' 	, 'Z32_USER'} ,;
	{ 'Z33_NOMFU' 	, 'Z32_NOME'}},;
	'Z33_ANO+Z33_MAT+Z33_XEMP+Z33_XFILIA' )

	//Liga o controle de não repetição de Linha
	oModel:GetModel( 'M_Z32' ):SetPrimaryKey( { 'Z32_FILIAL','Z32_ANO','Z32_MAT' } )

	//Adiciona Descricao do Modelo de Dados
	oModel:SetDescription( 'Participantes' )

	//Adiciona Descricao dos Componentes do Modelo de Dados
	oModel:GetModel( 'M_Z32' ):SetDescription( 'Avalidado' )
	oModel:GetModel( 'M_Z33' ):SetDescription( 'Participantes' )

Return(oModel)

Static Function ViewDef()

	Local oStruct1	:=	FWFormStruct(2,'Z32',{|X|ALLTRIM(X)$"Z32_XEMP,Z32_XFILIA,Z32_ANO,Z32_MAT,Z32_NOME,Z32_USER"} ) //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
	Local oStruct2	:=	FWFormStruct(2,'Z33',{|X|ALLTRIM(X)$"Z33_LEGEND,Z33_ITEM,Z33_MATAVA,Z33_XEMP,Z33_XFILIA,Z33_NOME,Z33_USRAVA,Z33_STATUS"}) //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
	Local oModel	:=	FwLoadModel('STAV3602')	//Retorna o Objeto do Modelo de Dados
	Local oView		:=	FwFormView():New()      //Instancia do Objeto de Visualização

	//Define o Preenchimento da Janela
	oView:CreateHorizontalBox( 'ID_HBOX_SUPERIOR',20)
	oView:CreateHorizontalBox( 'ID_HBOX_INFERIOR',80)

	//Define o Modelo sobre qual a Visualizacao sera utilizada
	oView:SetModel(oModel)

	//Vincula o Objeto visual de Cadastro com o modelo
	oView:AddField('V_Z32'  , oStruct1 ,'M_Z32' )

	//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
	oView:AddGrid(  'V_Z33', oStruct2, 'M_Z33')

	oView:AddIncrementField( 'V_Z33', 'Z33_ITEM' )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'V_Z32' , 'ID_HBOX_SUPERIOR' 	)
	oView:SetOwnerView( 'V_Z33' , 'ID_HBOX_INFERIOR' 		)

Return(oView)

Static Function STAV3602a( oModelGrid, nLinha, cAcao, cCampo )

	Local lRet := .T.
	Local oModel := oModelGrid:GetModel()
	Local nOperation := oModel:GetOperation()

	If cAcao == "CANSETVALUE"
		If oModelGrid:GetValue("Z33_STATUS") == "1"
			lRet := .F.
			Help( ,, 'Help',, 'Este Avaliador não poderá ser alterado..' +;
			CRLF +CRLF + 'Avalição já realizada! ', 1, 0 )
		EndIf
	EndIf

	// Valida se pode ou não apagar uma linha do Grid
	If cAcao == 'DELETE' .AND. nOperation == MODEL_OPERATION_UPDATE

		If oModelGrid:GetValue("Z33_STATUS") == "1"
			lRet := .F.
			Help( ,, 'Help',, 'Este Avaliador não poderá ser deletado..' +;
			CRLF +CRLF + 'Avalição já realizada! ', 1, 0 )
		EndIF

	EndIf

Return lRet

Static Function STAV3612b(oModel)

	Local lRet := .T.
	Local oModel := oModel:GetModel( 'M_Z33' )
	Local nOperation := oModel:GetOperation()
	Local nLinhas 	:= 0
	Local nI := 0

	nLinhas := oModel:Length( .T. )

	If nOperation = 3 .OR. nOperation = 4

		//If __cUserId <> '000591' //Solicitação da Camile.
		 If __cUserId <> '001256' //Solicitação da Camile.
			If nLinhas < 3 //Solicitação do Giovani.

				lRet := .F.
				Help( ,, 'Help',, 'Quantidade minima esperada é 3..' +;
				CRLF +CRLF + 'Por favor complete o quadro! ', 1, 0 )
			ElseIf nLinhas > 10
				lRet := .F.
				Help( ,, 'Help',, 'Quantidade maxima esperada é 10..' +;
				CRLF +CRLF + 'Por favor verifique! ', 1, 0 )

			EndIF

		EndIf

	EndIf

	If nOperation = 5

		For nI := 1 to nLinhas

			oModel:GoLine( nI )

			If oModel:GetValue("Z33_STATUS") == "1"
				lRet := .F.
				Help( ,, 'Help',, 'Este participante não poderá ser excluido..' +;
				CRLF +CRLF + 'Avalição já realizada! ', 1, 0 )
			EndIf

		Next nI

	EndIf

Return lRet

User Function STAV3612C()

	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'WF FEEDBACK 360'
	Local cFuncSent		:= "STAV3612C"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local _aAttach  	:= {}
	Local _cEmaSup 		:= ""
	Local _nCam    		:= 0
	Local _cCaminho		:= "\arquivos\AV360\"
	Local _cEmail  		:= ""//'everson.santana@steck.com.br'
	Local _cCopia  		:= ""
	Local _cQry 		:= ""
	Local _cQry1	 	:= ""
	Local _cQry2	 	:= ""
	Local _cQry3	 	:= ""

	aadd( _aAttach  ,"AV360.gif")

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If Select("TRC") > 0
			TRC->(DbCloseArea())
		Endif

		_cQry1 := " "
		_cQry1 += " SELECT * FROM "+RetSqlName("Z33")+" Z33"
		_cQry1 += " WHERE Z33_ANO = '"+Z32->Z32_ANO+"' "
		_cQry1 += " AND Z33_MAT = '"+Z32->Z32_MAT+"' " 
		_cQry1 += " AND Z33_XEMPFU = '"+Z32->Z32_XEMP+"' " 
		_cQry1 += " AND Z33_XFILFU = '"+Z32->Z32_XFILIA+"' " 
		_cQry1 += " AND Z33_USER = '"+Z32->Z32_USER+"' "
		_cQry1 += " AND D_E_L_E_T_ = ' ' "

		TcQuery _cQry1 New Alias "TRC"

		DbSelectArea("TRC")
		DbGotop()

		While !EOF()  

			cMsg := ''
			cMsg +=	' <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//PT">  ' 
			cMsg += ' <html>	' 
			cMsg += ' <head> ' 
			cMsg += ' <meta content="text/html"; charset="utf-8"> ' 
			cMsg += ' <title>FEEDBACK 360°</title> ' 
			cMsg += ' </head> ' 
			cMsg += ' <body> ' 
			cMsg += ' <table class="table table-hover table-responsive table-bordered"> ' 
			cMsg += ' <tbody> ' 
			cMsg += '   <tr> ' 
			cMsg += '     <td colspan="9" align="left" height="19" width="100%"> ' 
			cMsg += '       <font face="Verdana, Arial, Helvetica, sans-serif" size="2"> ' 
			cMsg += '         <strong> ' 
			cMsg += '           <p><img src="arquivosAV360AV360.gif" alt="Smiley face" align="middle" height="250" width="750" ></p> ' 
			cMsg += '			<p><h2>Olá, '+ Alltrim(TRC->Z33_NOME) +'</h2></p> 
			cMsg += '           <p> '
			cMsg += '           	<span style="font-size: 10pt;">Você foi indicado para contribuir com o desenvolvimento do(a) colaborador(a) 	                       
			cMsg += '       		</span><font style = "font-size: 12pt;font-style: italic">'+Alltrim(TRC->Z33_NOMFU)+'.</font>' '
			cMsg += '       	</p> ' 
			cMsg += '           <p> '
			cMsg += '           	<span style="font-size: 10pt;">Desta forma você irá fornecer feedback ao avaliado de forma que possa contribuir para o crescimento profissional, pois servirá de base para que ele possa preencher seu plano de desenvolvimento individual.'                    
			cMsg += '       		</span> '
			cMsg += '       	</p> ' 
			cMsg += '           <p> '
			cMsg += '				<font style = "font-size: 12pt;font-style: italic; color: #f22222">Importante:</font> ' 
			cMsg += '           	<span style="font-size: 10pt;">O avaliado terá acesso direto as suas respostas e poderá conversar pessoalmente com você caso tenha alguma dúvida sobre o feedback recebido. '                    
			cMsg += '       		</span> '
			cMsg += '       	</p> '
			cMsg += '           <p> '
			cMsg += '				<font style = "font-size: 12pt;font-style: italic; color: #f22222">O prazo para o preenchimento do feedback será do dia 04/11/2020 até o dia 20/12/2020, portanto se programe e não deixe de participar!</font> '                     
			cMsg += '       	</p> '
			cMsg += '           <p> '
			cMsg += '         <span style="font-size: 10pt;">Segue caminho para o preenchimento: '      
			cMsg += '       </span> '
			cMsg += '     </p> ' 		
			cMsg += '     <p> '
			cMsg += '         <span style="font-size: 10pt;">Protheus>Ambiente 07 > FEEDBACK 360º> Avaliar  '
			cMsg += '        </span> '
			cMsg += '     </p> '            
			cMsg += '     <p> '
			cMsg += '          <span style="font-size: 10pt;">Atenciosamente., ' 
			cMsg += '        </span> '
			cMsg += '     </p> '
			cMsg += '     <p> '
			cMsg += '          <span style="font-size: 10pt;">Recursos Humanos' 
			cMsg += '        </span> '
			cMsg += '     </p> '                                      
			cMsg += '         </strong> ' 
			cMsg += '       </font> ' 
			cMsg += '     </td> ' 
			cMsg += '   </tr> ' 
			cMsg += ' </tbody> ' 
			cMsg += ' </table> '  
			cMsg += ' </br> ' 
			cMsg += ' <br/> ' 
			cMsg += ' <br/> ' 
			cMsg += ' <br/> ' 
			cMsg += ' </body> ' 
			cMsg += ' </html> '

			If Select("TRD") > 0
				TRD->(DbCloseArea())
			Endif

			_cQry := " "
			_cQry += " SELECT * FROM ( "	
			_cQry += " SELECT RA_XEMP EMP, RA_FILIAL FILIAL, RA_MAT MATRICULA,RA_NOME NOME,RA_XUSRCFG USR_PROTHEUS, RA_EMAIL EMAIL FROM SRA010 WHERE RA_DEMISSA = ' '  AND D_E_L_E_T_ = ' ' " 
			_cQry += " UNION " 
			_cQry += " SELECT RA_XEMP EMP, RA_FILIAL FILIAL, RA_MAT MATRICULA,RA_NOME NOME,RA_XUSRCFG USR_PROTHEUS, RA_EMAIL EMAIL FROM SRA030 WHERE RA_DEMISSA = ' ' AND D_E_L_E_T_ = ' ' " 
			_cQry += " UNION " 
			_cQry += " SELECT RA_XEMP EMP, RA_FILIAL FILIAL, RA_MAT MATRICULA,RA_NOME NOME,RA_XUSRCFG USR_PROTHEUS, RA_EMAIL EMAIL FROM SRA070 WHERE RA_DEMISSA = ' ' AND D_E_L_E_T_ = ' ') TMP "
			_cQry += " WHERE TMP.EMP = '"+TRC->Z33_XEMP+"' "
			_cQry += " AND TMP.FILIAL = '"+TRC->Z33_XFILIA+"' "
			_cQry += " AND TMP.MATRICULA = '"+TRC->Z33_MATAVA+"' "

			TcQuery _cQry New Alias "TRD"

			_cEmail := TRD->EMAIL

			If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
				U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho,'   ')
			EndIf

			If Select("TRA") > 0
				TRA->(DbCloseArea())
			Endif

			_cQry2 := " "
			If Empty(Z32->Z32_STATUS) 
				_cQry2 += " UPDATE "+RetSqlName("Z32")+" SET Z32_STATUS = 'S' "
			Else
				_cQry2 += " UPDATE "+RetSqlName("Z32")+" SET Z32_STATUS = 'R' "
			EndIf
			_cQry2 += " WHERE Z32_ANO = '"+TRC->Z33_ANO+"'   "
			_cQry2 += " AND Z32_MAT = '"+TRC->Z33_MAT+"'   "
			_cQry2 += " AND Z32_XEMP = '"+TRC->Z33_XEMPFU+"'"  
			_cQry2 += " AND Z32_XFILIA = '"+TRC->Z33_XFILFU+"'"  
			_cQry2 += " AND Z32_USER = '"+TRC->Z33_USER+"'"  
			_cQry2 +="  AND D_E_L_E_T_ = ' '"

			TCSqlExec(_cQry2)

			If Select("TRB") > 0
				TRB->(DbCloseArea())
			Endif

			_cQry3 := " "
			_cQry3 += " UPDATE "+RetSqlName("Z33")+" SET Z33_DTENVI = '"+ Dtos(Date()) +"',Z33_HRENVI = '"+ SubStr(StrTran(Time(),":",""),1,4) +"' "
			_cQry3 += " WHERE Z33_ANO = '"+TRC->Z33_ANO+"'   "
			_cQry3 += " AND Z33_MAT = '"+TRC->Z33_MAT+"'   "
			_cQry3 += " AND Z33_XEMPFU = '"+TRC->Z33_XEMPFU+"'"  
			_cQry3 += " AND Z33_XFILFU = '"+TRC->Z33_XFILFU+"'"  
			_cQry3 += " AND Z33_USER = '"+TRC->Z33_USER+"'" 
			_cQry3 += " AND Z33_MATAVA = '"+TRC->Z33_MATAVA+"' "
			_cQry3 += " AND Z33_XEMP = '"+TRC->Z33_XEMP+"' "
			_cQry3 += " AND Z33_XFILIA = '"+TRC->Z33_XFILIA+"' "
			_cQry3 +="  AND D_E_L_E_T_ = ' '"

			TCSqlExec(_cQry3)

			DbSelectArea("TRC")
			DbSkip()

		End

	EndIf

Return
