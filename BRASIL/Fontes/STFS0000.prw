#include 'protheus.ch'


Static __UPTKEY:= "FST"
Static dfcArqlog		:= 'UpdatePrj.Log'
Static aChkStru 		:= {}
Static aIndNew  		:= {}
Static aNewSX2  		:= {}
Static nHdlLog  		:= NIL
Static cTxtIgnora 	:= ""
Static __cEmpFil		:= ""  

User Function STFS0000()
Local 	oSay,oListEmp,oChk, oApresenta,oMemo,oGroup1
Local 	cApresent
Local		nBrowse
Local		alInverte[9]
Local	 	lGerarLog	:=	.T.
Local		lPermParar 	:=	.F.
Local		lApagaBkp 	:=	.F.
Local 	aListEmp 	:=	{}
Local 	aPages		:= {"dicionario","tabelas"} //###
Local 	aTitulo		:= {"&Dicionarios","&Tabelas"} //###
Private  dfcCaminho	:='\FSTUPT\'
Private  cProj:=""
Set delete on

cArqEmp := "SigaMat.Emp"
Private cEmpAnt :=""
__cInterNet := Nil
OpenSm0()
dbSelectArea("SM0")

If ! MsLogin()
   Return .f.
EndIf    


RpcSetType(3)
RpcSetEnv(Left(__cEmpFil,2),Substr(__cEmpFil,4,2),,,,,)

If ! ChkExc(.t.)
  	Return .F.
EndIf      

SM0->(DbSeek(Left(__cEmpFil,2)+Substr(__cEmpFil,4,2)))
__cEmpFil	:= SM0->M0_CODIGO+'/'+SM0->M0_CODFIL+' - '+SM0->M0_NOME+' / '+SM0->M0_FILIAL
                   
//Declaracao de variaveis Privadas
Private 	cTitulo 		:= "Projeto Fabrica "+__UPTKEY //
Private 	cAcao	  		:= "Compatibilizador de Dados do Projeto "+__UPTKEY
Private	cLstTarefas	:= ""
Private	cMmResumo	:= ""
Private 	nTela 		:= 0
Private	lMostraDif	:= .T.
Private  nAtualSxs 	:= 0,nAtualStru := 0
Private  aMarca[10]
Private 	aNoSIX 		:= {}
Private 	aNoSX1 		:= {}
Private 	aNoSX2 		:= {}
Private 	aNoSX3 		:= {}
Private 	aNoSX5 		:= {}
Private 	aNoSX6 		:= {}
Private 	aNoSX7 		:= {}
Private 	aNoSXA 		:= {}
Private 	aNoSXB 		:= {}
Private 	aTabelas		:=	{{.T.,"A","",""}}
Private 	oOk 			:= LoadBitmap( GetResources(), "LBOK" )
Private 	oNo 			:= LoadBitmap( GetResources(), "LBNO" )
Private 	oBmp,oLstTarefas,oPanel,oPanel0,oPanel1,oPanel2,oPanel3,oPanel4,oPanel5
Private	oDlgUpd,oTitulo,oAcao,oBtnVoltar,oBtnAvancar,oBtnCancelar,oMtSxs,oMtStru
Private	oAtuSxs,oAtuStru1,oAtuStru2,oAtuStru3,oAtuStru4,oMmResumo,oFolder,oTabelas
Private  oSix,oSx1,oSxs,oSx3,oSx5,oSx6,oSx7,oSxa,oSxb
Private  oAtuAmb



//Renomeia arquivo de Log se ja existir
If File(dfcArqlog)
	FRename(dfcArqLog,Left(dfcArqLog,Len(dfcArqLog)-4)+DtoS(Date())+Right(Time(),2)+".Log")
EndIf

//Checa a existencia dos dicionarios para update
If ! File(dfcCaminho+"SIN"+__UPTKEY+GetDbExtension()) .or.  	! File(dfcCaminho+"SX1"+__UPTKEY+GetDbExtension()) .or.;
	! File(dfcCaminho+"SX2"+__UPTKEY+GetDbExtension()) .or. 	! File(dfcCaminho+"SX3"+__UPTKEY+GetDbExtension()) .or.;
	! File(dfcCaminho+"SX5"+__UPTKEY+GetDbExtension()) .or. 	! File(dfcCaminho+"SX6"+__UPTKEY+GetDbExtension()) .or.;
	! File(dfcCaminho+"SX7"+__UPTKEY+GetDbExtension()) .or.  	! File(dfcCaminho+"SXA"+__UPTKEY+GetDbExtension()) .or.;
	! File(dfcCaminho+"SXB"+__UPTKEY+GetDbExtension())
		IW_MsgBox('Arquivo de update nao encontrado. Em'+chr(13)+ ; //
					 dfcCaminho+'S??'+__UPTKEY+'.DBF',"Update") //###
		IW_MsgBox("Favor atualizar os arquivos para updade","Update") //###
		Return
EndIf

	MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SIN'+__UPTKEY, "ACDIX",.F.,.T.)
	MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SX1'+__UPTKEY, "ACDX1",.F.,.T.)
	MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SX2'+__UPTKEY, "ACDX2",.F.,.T.)
	MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SX3'+__UPTKEY, "ACDX3",.F.,.T.)
	MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SX5'+__UPTKEY, "ACDX5",.F.,.T.)
	MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SX6'+__UPTKEY, "ACDX6",.F.,.T.)
	MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SX7'+__UPTKEY, "ACDX7",.F.,.T.)
	MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SXA'+__UPTKEY, "ACDXA",.F.,.T.)
	MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SXB'+__UPTKEY, "ACDXB",.F.,.T.)


cApresent		:= "Este programa tem como objetivo compatibilizar "	+chr(13)+ 			; 
						"os dicionários e tabelas do Projeto. Para " +chr(13)+        ; 
						"continuar a execução é necessário sair de todos "	+chr(13)+        ; 
						"os módulos do Protheus. "						+chr(13)+chr(13)+;
						"Também é necessário fazer uma cópia de segurança " 	+chr(13)+        ;
						" do diretório de dicionários (SYSTEM) e da " 	+chr(13)+			; 
						"base de dados (DATA). "								+chr(13)+			; 
						"Verifique se existe espaço suficiente em disco. "	+chr(13)+chr(13)+; 
						"Clique em Cancelar para sair do atualizador, ou "  +chr(13)+			; 
						"em Avançar para continuar o programa. " 

aFill(alInverte, .F.)
aFill(aMarca, GetMark())

//Definindo os campos a serem visualizados
aCpoBro1			:= {	{ "OK"     		,, "Mark"     	,"@!"},;
							{ "ACAO"   		,, ""   			,"@!"},;
							{ "Indice"   	,, "Indice"   	,"@!"},; //
							{ "Ordem"   	,, "Ordem"   	,"@!"},;							 //
             				{ "Chave"  		,, "Chave"    	,"@!"},; //
							{ "NickName"    ,, "NickName" 	,"@!"}} //
aCpoBro2			:= {	{ "OK"     		,, "Mark"     	,"@!"},;
							{ "ACAO"   		,, ""   			,"@!"},;
							{ "Grupo"    	,, "Grupo"    	,"@!"},; //
							{ "Ordem"   	,, "Ordem"    	,"@!"},; //
							{ "PERGUNT"   	,, "Pergunta" 	,"@!"}} //
aCpoBro3			:= {	{ "OK"     		,, "Mark"     	,"@!"},;
							{ "ACAO"   		,, ""   			,"@!"},;
							{ "Tabela"   	,, "Tabela"   	,"@!"},; //
             				{ "DESC"   		,, "Descricao"	,"@!"}} //
aCpoBro4			:= {	{ "OK"     		,, "Mark"     	,"@!"},;
							{ "ACAO"   		,, ""   			,"@!"},;
							{ "Campo"    	,, "Campo"    	,"@!"},; //
							{ "Titulo"    	,, "Titulo"   	,"@!"},; //
             				{ "Tipo"       	,, "Tipo"     	,"@!"},; //
							{ "Tamanho"   	,, "Tamanho"  	,"@!"},; //
							{ "Decimal"   	,, "Decimal"  	,	 }} //
aCpoBro5			:= {	{ "OK"     		,, "Mark"     	,"@!"},;
							{ "ACAO"   		,, ""   			,"@!"},;
							{ "Tabela"   	,, "Tabela"   	,"@!"},; //
             				{ "Chave"   	,, "Chave"    	,"@!"},; //
             				{ "DESCRI"  	,, "Descricao"	,"@!"}} //
aCpoBro6			:= {	{ "OK"     		,, "Mark"     	,"@!"},;
							{ "ACAO"   		,, ""   		,"@!"},;
							{ "PAR"      	,, "Parametro"	,"@!"},; //
							{ "Tipo"      	,, "Tipo"     	,"@!"},; //
             				{ "DESCRIC"   	,, "Descricao"	,"@!"}} //
aCpoBro7			:= {	{ "OK"     		,, "Mark"     	,"@!"},;
	 						{ "ACAO"   		,, ""   			,"@!"},;
							{ "Campo"    	,, "Campo"    	,"@!"},; //
             				{ "Sequencia"	,, "Sequencia"		,"@!"},; //
							{ "Regra"		,, "Regra" 		,"@!"},; //
							{ "CDOMIN"		,, "C. Dominio","@!"},; //
							{ "Alias"		,, "Alias"		,"@!"},; //
							{ "Chave"		,, "Chave"		,"@!"}} //

aCpoBro8			:= {	{ "OK"     		,, "Mark"     	,"@!"},;
							{ "ACAO"   		,, ""   			,"@!"},;
							{ "Alias"    	,, "Alias"    	,"@!"},; //
							{ "Ordem"     	,, "Ordem"    	,"@!"},; //
             				{ "DESCRIC"   	,, "Descricao"	,"@!"}} //
aCpoBro9			:= {	{ "OK"     		,, "Mark"     	,"@!"},;
							{ "ACAO"   		,, ""   			,"@!"},;
							{ "Alias"    	,, "Alias"    	,"@!"},; //
             				{ "Tipo"   		,, "Tipo"     	,"@!"},; //
             				{ "SEQ"    		,, "Sequencia"	,"@!"},; //
             				{ "Coluna" 		,, "Coluna"   	,"@!"},; //
             				{ "CONTEM" 		,, "Conteudo" 	,"@!"}} //

//Cria os arquivos temporarios
MtStruTmp()

DEFINE DIALOG oDlgUpd TITLE 'Update Projeto Fabrica '+__UPTKEY+' - Atualizador de Dados' FROM 0, 0 TO 22, 75 SIZE 550, 350  /* OF <oWnd> */    pixel //
	//----- Objetos Generios -----------------------------------------------------------
	@000,000 BITMAP 	oBmp RESNAME "ProjetoAP" OF oDlgUpd SIZE 095, oDlgUpd:nBottom NOBORDER WHEN .F. PIXEL //
	@005,070 SAY oTitulo 	VAR cTitulo 	OF oDlgUpd  FONT (TFont():New('Arial',0,-13,.T.,.T.))PIXEL
	@015,070 SAY oAcao	 	VAR cAcao	 	OF oDlgUpd PIXEL
	@155,080 BUTTON oBtnVoltar  	PROMPT '<< &Voltar' 	SIZE 60, 14 ACTION AtuTela(1) 	OF oDlgUpd PIXEL //
	@155,140 BUTTON oBtnAvancar 	PROMPT '&Avancar >>' SIZE 60, 14 ACTION AtuTela(2) 	OF oDlgUpd PIXEL //
  	@155,210 BUTTON oBtnCancelar 	PROMPT '&Cancelar' 	SIZE 60, 14 ACTION FimAcdUpd(	; //
  				IIf(oBtnCancelar:cCaption=='&Fechar',.T.,.F.)) 	OF oDlgUpd PIXEL //

	//--------- Tela Inicial------------------------------------------------------------
   oPanel := TPanel():New( 028, 072, ,oDlgUpd, , , , , , 200, 120, .F.,.T. )
	@ 002,005 SAY oApresenta VAR "Bem-Vindo" OF oPanel FONT (TFont():New('Arial',0,-13,.T.,.T.))PIXEL //
	@ 015,005 GET oMemo	VAR cApresent OF oPanel MEMO PIXEL SIZE 180,100 FONT (TFont():New('Verdana',,-12,.T.))   NO BORDER
	oMemo:lReadOnly	:= .T.

	//--------- Tela 00 ----------------------------------------------------------------
   oPanel0 := TPanel():New( 028, 072, ,oDlgUpd, , , , , , 200, 120, .F.,.T. )
	@ 040,005 SAY oAtuAmb VAR "Criando Ambiente..." OF oPanel0 FONT (TFont():New('Arial',0,-12,.T.,.T.))PIXEL //
	@ 020,005 METER oAmbiente	VAR nAtualSxs  TOTAL 1000 	SIZE 190, 15	OF oPanel0 UPDATE PIXEL

	//--------- Tela 01-----------------------------------------------------------------
   oPanel1 := TPanel():New( 028, 000, ,oDlgUpd, , , , , , 275, 120, .T.,.T. )
   @ 000,001 SAY oSay VAR "Tabelas:" 				OF oPanel1 PIXEL //
   @ 000,133 SAY oSay VAR "Campos:" 				OF oPanel1 PIXEL //
  	//SX3
  	oSx3 	:= MsSelect():New("_Sx3Tmp","OK","",aCpoBro4,@alInverte[4],@aMarca[4],{008,133,120,275},,,oPanel1)
  	oSx3:oBrowse:Refresh()
  	@ 008,001 LISTBOX oTabelas	FIELDS HEADER " ", "","Tabela","Descricao" SIZE 126, 110 PIXEL OF oPanel1  ; //###
			 	ON DBLCLICK(aTabelas[oTabelas:nAt,1]:= !aTabelas[oTabelas:nAt,1],UpDispCpo(aTabelas[oTabelas:nAt,1],aMarca[10],aTabelas[oTabelas:nAt,2]))
	oTabelas:SetArray(aTabelas)
	oTabelas:bChange 	:= {||AtuCpoLst(aTabelas[oTabelas:nAt,3])}
	oTabelas:bLine 	:= {|| {Iif(aTabelas[oTabelas:nAt,1],oOK,oNo),aTabelas[oTabelas:nAt,2],aTabelas[oTabelas:nAt,3],aTabelas[oTabelas:nAt,4]} }
	oTabelas:Refresh()
	//--------- Tela 02-----------------------------------------------------------------
   oPanel2 := TPanel():New( 028, 000, ,oDlgUpd, , , , , , 275, 120, .T.,.T. )
   @ 000,001 SAY oSay VAR "Dicionarios:" 			OF oPanel2 PIXEL //
   @ 000,133 SAY oSay VAR "Campos:" 				OF oPanel2 PIXEL //
  	//Six
  	oSix	:= MsSelect():New("_SixTmp","OK","",aCpoBro1,@alInverte[1],@aMarca[1],{008,133,120,275},,,oPanel2)
  	oSix:oBrowse:lVisibleControl:= .f.
  	oSix:oBrowse:Refresh()
  	//Sx1
  	oSx1	:= MsSelect():New("_Sx1Tmp","OK","",aCpoBro2,@alInverte[2],@aMarca[2],{008,133,120,275},,,oPanel2)
  	oSx1:oBrowse:lVisibleControl:= .f.
  	oSx1:oBrowse:Refresh()
  	//Sx5
  	oSx5 	:= MsSelect():New("_Sx5Tmp","OK","",aCpoBro5,@alInverte[5],@aMarca[5],{008,133,120,275},,,oPanel2)
  	oSx5:oBrowse:lVisibleControl:= .f.
  	oSx5:oBrowse:Refresh()
  	//Sx6
  	oSx6 	:= MsSelect():New("_Sx6Tmp","OK","",aCpoBro6,@alInverte[6],@aMarca[6],{008,133,120,275},,,oPanel2)
  	oSx6:oBrowse:lVisibleControl:= .f.
  	oSx6:oBrowse:Refresh()
  	//Sx7
  	oSx7 	:= MsSelect():New("_Sx7Tmp","OK","",aCpoBro7,@alInverte[7],@aMarca[7],{008,133,120,275},,,oPanel2)
  	oSx7:oBrowse:lVisibleControl:= .f.
  	oSx7:oBrowse:Refresh()
   //Sxa
  	oSxa 	:= MsSelect():New("_SxaTmp","OK","",aCpoBro8,@alInverte[8],@aMarca[8],{008,133,120,275},,,oPanel2)
  	oSxa:oBrowse:lVisibleControl:= .f.
  	oSxa:oBrowse:Refresh()
  	//Sxb
  	oSxb 	:= MsSelect():New("_SxbTmp","OK","",aCpoBro9,@alInverte[9],@aMarca[9],{008,133,120,275},,,oPanel2)
  	oSxb:oBrowse:lVisibleControl:= .f.
  	oSxb:oBrowse:Refresh()
   //DICIONARIOS - Sxs
  	oSxs			:= MsSelect():New("_SxsTmp","OK","",aCpoBro3,@alInverte[3],@aMarca[3],{008,001,120,128},,,oPanel2)
  	oSxs:bMark 	:= {||SxsUpDispCpo(aMarca[3],alInverte[3],_SxsTmp->TABELA,&("o"+_SxsTmp->TABELA)) }
  	oSxs:oBrowse:bChange	:= {|| IIf(!Empty(_SxsTmp->TABELA),(AtuCpoSxs(&("o"+_SxsTmp->TABELA)), &("o"+_SxsTmp->TABELA):oBrowse:Refresh()),.T.) }
  	oSxs:oBrowse:Refresh()

	//--------- Tela 03-----------------------------------------------------------------
   oPanel3 := TPanel():New( 028, 072, ,oDlgUpd, , , , , , 195, 120, .F.,.T. )
	@ 000,000 GET oLstTarefas	VAR cLstTarefas OF oPanel3 MEMO PIXEL 	SIZE 195,120 ;
					FONT (TFont():New('Courier New',,-11,.T.)) HSCROLL READONLY

	//--------- Tela 04-----------------------------------------------------------------
   oPanel4 := TPanel():New( 028, 072, ,oDlgUpd, , , , , , 195, 120, .F.,.T. )
   @ 010,000 SAY oSay 		VAR "Atualizacao dos Dicionarios de Dados:"	OF oPanel4 PIXEL ; //
   				FONT (TFont():New('Arial',0,-11,.T.,.T.))
   @ 050,000 SAY oSay 		VAR "Atualizacao da Estrutura de Dados:"		OF oPanel4 PIXEL ; //
   				FONT (TFont():New('Arial',0,-11,.T.,.T.))
   @ 037,000 SAY oAtuSxs   		VAR Space(40)		OF oPanel4 PIXEL
   @ 077,000 SAY oAtuStru1 		VAR Space(40)		OF oPanel4 PIXEL
   @ 087,000 SAY oAtuStru2 		VAR Space(40)		OF oPanel4 PIXEL
   @ 097,000 SAY oAtuStru3 		VAR Space(40)		OF oPanel4 PIXEL
	@ 020,000 METER oMtSxs	VAR nAtualSxs  TOTAL 1000 	SIZE 190, 15	OF oPanel4 UPDATE PIXEL
	@ 060,000 METER oMtStru	VAR nAtualStru TOTAL 1000 	SIZE 190, 15	OF oPanel4 UPDATE PIXEL

	//--------- Tela 05-----------------------------------------------------------------
   oPanel5 := TPanel():New( 028, 000, ,oDlgUpd, , , , , , 275, 120, .F.,.T. )
	@ 000,000 GET oMmResumo	VAR cMmResumo OF oPanel5 MEMO PIXEL SIZE 275,120 FONT (TFont():New('Courier New',,-11,.T.))
	oMmResumo:lReadOnly	:= .T.
ACTIVATE DIALOG oDlgUpd   CENTER 	ON INIT AtuTela(0)

Return


//--------------------------
Static Function AtuTela(nAcao)
Local nI, nTotReg
Local cRegNoGrv,cAliasTmp,cAux
Local aStruTmp		:= {}

	If nAcao == 1			//Voltar
		nTela--
	ElseIf nAcao == 2		//Avancar
		nTela++
	EndIf

	If nTela < 0
		nTela := 0
	ElseIf nTela > 5
		nTela	:= 5
	EndIf

   //Ajusta Coordenadas dos Objetos de informacao
   oTitulo:nLeft 					:= 120
   oAcao:nLeft						:= 120

   //Ativar Objetos dos Bmps
   oBmp:lVisibleControl 		:= .T.       

	//Desativa todos os objetos
	oPanel:lVisibleControl 		:= .F.
   oPanel0:lVisibleControl 	:= .F.
   oPanel1:lVisibleControl 	:= .F.
   oPanel2:lVisibleControl 	:= .F.
   oPanel3:lVisibleControl 	:= .F.
   oPanel4:lVisibleControl 	:= .F.
   oPanel5:lVisibleControl 	:= .F.
	oBtnVoltar:lReadOnly 		:= .F.

	If nTela == 0
		cTitulo						:= "Update Projeto Fabrica "+__UPTKEY
		cAcao							:= "Compatibilizador de Dados do Projeto" //
		oPanel:lVisibleControl 	:= .T.
		oBtnVoltar:lReadOnly 	:= .T.
	ElseIf nTela == 1
		If lMostraDif       
			cTitulo						:= "Configuracoes" //
			cAcao							:= "Criando Divergencias" //
			oPanel0:lVisibleControl := .T.
			oTitulo:Refresh()
			oAcao:Refresh()
		
			//Monta a Diferenca das tabelas/campos
			MontaDif()
			If _SxsTmp->(RecCount()) == 0 .AND. _Sx2Tmp->(RecCount()) == 0
				IW_MSGBOX("Nao existem diferencas nos dados para realizar Update","Atencao") //###
				FimAcdUpd(.t.)
				Return
			EndIf

			_Sx2Tmp->(DbGotop())
			_SxsTmp->(DbGotop())
			lMostraDif := .F.
	 	EndIf
	 	If !  _Sx2Tmp->(RecCount()) == 0
			cTitulo						:= "Configurações" //
			cAcao							:= "Configurações de execução do Update" //
		 	oTitulo:nLeft				:= 2
	   	oAcao:nLeft					:= 2
			oPanel0:lVisibleControl := .F.
			oPanel1:lVisibleControl := .T.
		   oBmp:lVisibleControl 	:= .F.
		Else     
		   nTela := 2	
		EndIf
	
	EndIf   
	If nTela == 2 
	   If  ! _SxsTmp->(RecCount()) == 0
			cTitulo						:= "Configurações" //
			cAcao							:= "Configurações de execução do Update" //
		 	oTitulo:nLeft				:= 2
	   	oAcao:nLeft					:= 2
			oPanel2:lVisibleControl := .T.
		   oBmp:lVisibleControl 	:= .F.
	  	   oBtnVoltar:lReadOnly 	:= .T.
	
	  	   //Elimina os indices se exitirem dos campos q. foram desmarcados
	  	   DbSelectArea("_Sx3Tmp")
	  	   _Sx3Tmp->(DbClearFilter())
	  	   _Sx3Tmp->(DbGotop())
	  	   While !_Sx3Tmp->(Eof())
	  	   	If Empty(_Sx3Tmp->OK)
	  	   		_SixTmp->(DbGotop())
	  	   		While !_SixTmp->(Eof())
	  	   			If _Sx3Tmp->CAMPO $ _SixTmp->CHAVE
							RecLock("_SixTmp",.F.)
						   	_SixTmp->OK	:= ""
		   				MsUnLock()
	  	   			EndIf
	  	   			_SixTmp->(DbSkip())
	  	   		EndDo
	  	   	EndIf
	  	   	_Sx3Tmp->(DbSkip())
	  	   EndDo
	  	   _SixTmp->(DbGotop())
			
			_SxsTmp->(DbGotop())
	  	   //Atualiza Objeto
		   If _SxsTmp->(RecCount()) > 0 .AND. !Empty(_SxsTmp->TABELA)
		   	oSix:oBrowse:Refresh()
		   	&("o"+_SxsTmp->TABELA):oBrowse:lVisibleControl := .T.
		   EndIf     
		  
	     	oSxs:oBrowse:Refresh()
	   Else
	      nTela:=3  	
	   EndIf  	
   EndIf
	If nTela == 3
		cTitulo						:= "Tarefas" //
		cAcao							:= "Lista das tarefas a serem executadas" //
		cLstTarefas					:= "Empresa Analisada:"		      		  	+ chr(13)+chr(10) //
		cLstTarefas					+= Space(3)+__cEmpFil							+ chr(13)+chr(13)+chr(10)
		cLstTarefas					+=	"Lista de Tarefas:"							+ chr(13)+chr(10)+ chr(13)+chr(10) //
		cLstTarefas					+=	Space(3)+"- Verificar Integridade"		+ chr(13)+chr(10) //
		cLstTarefas					+=	Space(3)+"- Fazer Backup"					+ chr(13)+chr(10) //
      
      //Lista de Dicionarios
		aNoSIX 		:= {}
		aNoSX1 		:= {}
		aNoSX2 		:= {}
		aNoSX3 		:= {}
		aNoSX5 		:= {}
		aNoSX6 		:= {}
		aNoSX7 		:= {}
		aNoSXA 		:= {}
		aNoSXB 		:= {}
      cAux			:= ""
      cRegNoGrv	:= ""

		_SxsTmp->(DbGotop())
		While ! _SxsTmp->(Eof())
			If !Empty(_SxsTmp->OK)
				cLstTarefas += Space(3)+"- Atualizacao do " + _SxsTMP->TABELA + chr(13)+chr(10) //
				cAliasTmp	:= "_"+_SxsTMP->TABELA+"Tmp"
				&(cAliasTmp)->(DbGotop())
				While ! &(cAliasTmp)->(EOF())
					aStruTmp		:= &(cAliasTmp)->(DbStruct())
					If Empty(&('"'+cAliasTmp+'"')->OK)
						cRegNoGrv	+= _SxsTMP->TABELA + " : "+chr(13)+chr(10)
						For nI:=1 To Len(aStruTmp)
							If aStruTmp[nI,1]<>"OK" .AND. aStruTmp[nI,1]<>"ACAO"
								If aStruTmp[nI,2]=="C"
									cAux			+= &(cAliasTmp+"->"+aStruTmp[nI,1])
									cRegNoGrv	+= Space(6)+"- "+&(cAliasTmp+"->"+aStruTmp[nI,1])
								Else
									cAux			+= Str(&(cAliasTmp+"->"+aStruTmp[nI,1]))
									cRegNoGrv	+= Space(6)+"- "+Str(&(cAliasTmp+"->"+aStruTmp[nI,1]))
								EndIf
							EndIf
						Next
						If !Empty(cAux)
							Aadd(&("aNo"+_SxsTMP->TABELA),{cAux})
							cAux	:= ""
						EndIf
						cRegNoGrv	+= chr(13)+chr(10)
					EndIf
					&(cAliasTmp)->(DbSkip())
				EndDo
			EndIf
			_SxsTmp->(DbSkip())
		EndDo
      //Lista de Tabelas/Campos
      DbSelectArea("_Sx3Tmp")
      _Sx3Tmp->(DbClearFilter())
		_Sx2Tmp->(DbGotop())
		While ! _Sx2Tmp->(Eof())
			If Empty(_Sx2Tmp->OK)
				Aadd(aNoSx2,{_Sx2Tmp->TABELA})
			EndIf
			cLstTarefas += Space(3)+"- Atualizacao do " + _Sx2TMP->TABELA + chr(13)+chr(10) //
			nTotReg		:= 0
			_Sx3Tmp->(DbSeek(_Sx2TMP->TABELA))
			While ! _Sx3Tmp->(EOF()) .AND. _Sx3Tmp->ALIAS==_Sx2TMP->TABELA
				If Empty(_Sx3Tmp->OK)
					Aadd(aNoSx3,{_Sx3Tmp->ALIAS+_SX3Tmp->CAMPO})
					cRegNoGrv	+= _Sx3Tmp->ALIAS + " : " + _SX3Tmp->CAMPO + " - Acao: "+ ; //
										IIf(_SX3Tmp->ACAO=="A","Alteracao","Inclusao") + chr(13)+chr(10) //###
				Else
					cLstTarefas += Space(6)+"- "+ _Sx3Tmp->ALIAS + " : " + _SX3Tmp->CAMPO+ " - Acao: "+ ; //
										IIf(_SX3Tmp->ACAO=="A","Alteracao","Inclusao") + chr(13)+chr(10) //###
					nTotReg++
				EndIf
				_Sx3Tmp->(DbSkip())
			EndDo
			cLstTarefas += Space(6)+"- Quantidade de colunas: " + AllTrim(Str(nTotReg)) + chr(13)+chr(10) //
			_Sx2Tmp->(DbSkip())
		EndDo

		If !Empty(cRegNoGrv)
			cLstTarefas += Replicate("-",50)+Chr(13)+Chr(10)+Chr(13)+Chr(10)
			cLstTarefas += "Tabelas/Registros que nao serao atualizados" +Chr(13)+Chr(10) //
			cLstTarefas	+= cRegNoGrv
		EndIf

		oPanel3:lVisibleControl 	:= .T.

	ElseIf nTela == 4
		If MsgYesNo('O Update sera executado conforme as configuracoes realizadas. O Update '		+chr(13)+ ; //
						'podera sofrer interferencias do meio (Queda de energia, sistema operacional'		+chr(13)+ ; //
						'entre outros), tenha certeza que os backups ja foram feitos corretamente '		+chr(13)+ ; //
						'antes desta operacao.'																				+chr(13)+chr(13)	+ ; //
						'Deseja continuar a execucao do Update?','Update') 
			cTitulo						:= "Execução" //
			cAcao							:= "Execução do Update" //
			oPanel4:lVisibleControl := .T.
			oTitulo:Refresh()
			oAcao:Refresh()

			//Gera arquivo com o script das tarefas
			GeraScript(cLstTarefas)

         //Analisando a estrutura dos dicionarios
			AnalisaSXs()                           

			//Alterando a estrutura das tabelas
			ChkStru()          
			
			If Len(aNewSX2) > 0
			   Info("")
			   Info(Replicate("-",70))
			   Info("Novas tabelas criadas, verificar as configuracoes personalizadas destas tabelas.") //
			   For nI := 1 to Len(aNewSX2)
			      Info("Tabela: "+aNewSX2[nI]) //
			   Next
			   aNewSX2 := {}
			   Info(Replicate("-",70))
			EndIf
			If !Empty(cTxtIgnora)
			   Info("")
			   Info(Replicate("-",70))
			   Info("EFETUAR ESTAS ALTERACOES NO DICIONARIO DE DADOS") //
			   Info(cTxtIgnora)
			   cTxtIgnora := ""
			   Info(Replicate("-",70))
			EndIf
			Info('Update Finalizado') //
			//ChkExc(.f.)
			
			
			nTela := 5
		Else
			FimAcdUpd()
			Return
		EndIf
	EndIf
	//Tela de finalizacao (SUCESSO/ERRO)
	If nTela == 5
	 	oTitulo:nLeft				:= 2
   	oAcao:nLeft					:= 2
		oPanel4:lVisibleControl := .F.
		oPanel5:lVisibleControl := .T.
		oBtnVoltar:lReadOnly 	:= .T.
		oBtnAvancar:lReadOnly	:= .T.
		oBtnCancelar:cCaption	:= "&Fechar" //
		cMmResumo					:= AutoGRLog("",.T.)
		oMmResumo:Refresh()
		cTitulo						:= "Update Finalizado" //
		cAcao							:= "Lista das tarefas executadas pelo update" //
		IW_MSGBOX('Atualizador concluido com sucesso.','ATENCAO') //###
	EndIf

	oTitulo:Refresh()
	oAcao:Refresh()
Return

//Finaliza ACDUPDATE
Static Function FimAcdUpd(lFinal)
Default lFinal := .F.
	If lFinal
   		IW_MSGBOX("Update de projeto Finalizado",'Update de projeto Finalizado') 
	Else
		IW_MSGBOX('Update cancelado pelo operador!','Update Cancelado') //###
	EndIf

   _SxsTmp->(DbCloseArea())
   _SixTmp->(DbCloseArea())
   _Sx1Tmp->(DbCloseArea())
   _Sx3Tmp->(DbCloseArea())
   _Sx5Tmp->(DbCloseArea())
	_Sx6Tmp->(DbCloseArea())
	_Sx7Tmp->(DbCloseArea())
	_SxaTmp->(DbCloseArea())
	_SxbTmp->(DbCloseArea())

   If Select("_Sx2Tmp") > 0
   	_Sx2Tmp->(DbCloseArea())
   EndIf

	oDlgUpd:End()
Return


Static Function GeraScript(cScript)
Local cArqTsk	:= "Upt.tsk"
Local nHdlTsk 

If File(cArqTsk)
	FRename(cArqTsk,Left(cArqTsk,Len(cArqTsk)-4)+DtoS(Date())+Right(Time(),2)+".tsk")
EndIf         

nHdlTsk  :=	FCreate(cArqTsk,0)
If nHdlTsk == -1
	Return
EndIf

FSeek(nHdlTsk,0,2)
FWrite(nHdlTsk,cScript)
FClose(nHdlTsk)
Return



Static Function SxsUpDispCpo(cMarca,lInverte,cAlias,oGrid)
Local cFieldMarca := "OK"
Local lMarca 		:= IsMark(cFieldMarca,cMarca,lInverte)
Local cTabela		:= "_"+Trim(cAlias)+"Tmp"
Local nI
	If Empty(cAlias)
		Return
	EndIf

	If !lMostraDif
		&(cTabela)->(DbGotop())
		While !&(cTabela)->(EOF())
			RecLock(cTabela,.F.)
				If lMarca
   				&('"'+cTabela+'"')->OK 		:=  cMarca
   			Else
   				&('"'+cTabela+'"')->OK    	:=  ""
   			EndIf
   		MsUnLock()
   		&(cTabela)->(DbSkip())
  		EndDo
  		&(cTabela)->(DbGotop())
		oGrid:oBrowse:Refresh()
	EndIf
Return


Static Function UpDispCpo(lMarca,cMarca,cAlias)
	If Empty(cAlias)
		Return
	EndIf

	If !lMostraDif
  		_Sx3Tmp->(DbGotop())
  		While ! _Sx3Tmp->(EOF())
  			RecLock("_Sx3Tmp",.F.)
				If lMarca
   				_Sx3Tmp->OK 	:=  cMarca
   			Else
   				_Sx3Tmp->OK   	:=  ""
   			EndIf
   		MsUnLock()
  		 	_Sx3Tmp->(DbSkip())
   	EndDo
   	_Sx3Tmp->(DbGotop())
   	oSx3:oBrowse:Refresh()
	EndIf
Return


Static Function AtuCpoLst(cAlias)
Local nI
	If Empty(cAlias)
		Return
	EndIf

	If !lMostraDif
		Set Filter To &("_Sx3Tmp->Alias=='"+cAlias+"'")
		_Sx3Tmp->(DbGotop())
		oSx3:oBrowse:Refresh()
	EndIf
	oTabelas:Refresh()
Return

Static Function AtuCpoSxs(oObjeto)
Local nI
	If Empty(_SXSTMP->TABELA)
		Return
	EndIf

	If !lMostraDif
		oSix:oBrowse:lVisibleControl		:= .F.
		oSx1:oBrowse:lVisibleControl		:= .F.
		oSx5:oBrowse:lVisibleControl		:= .F.
		oSx6:oBrowse:lVisibleControl		:= .F.
		oSx7:oBrowse:lVisibleControl		:= .F.
		oSxa:oBrowse:lVisibleControl		:= .F.
		oSxb:oBrowse:lVisibleControl		:= .F.
		oObjeto:oBrowse:lVisibleControl	:= .T.
		oSxs:oBrowse:lVisibleControl		:= .T.
		&("'_"+_SXSTMP->TABELA+"Tmp'")->(DbGotop())
		oObjeto:oBrowse:Refresh()
	EndIf

Return


//Monta Estrutura dos arquivos temporarios
Static Function MtStruTmp()
Local cArq 
Local aStru	  := {}
Local oTable

   //Criar Temporario - DICIONARIOS ()
	aStru	:= {}
	cArq 	:= ""
	AADD(aStru,{"OK"   		,"C",  2,0})
	AADD(aStru,{"ACAO"		,"C",  1,0})
	AADD(aStru,{"TABELA"   	,"C",  3,0})
	AADD(aStru,{"DESC"     	,"C", 30,0})
	//cArq := Criatrab(aStru,.T.)				//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("_SxsTmp") //adicionado\Ajustado
	oTable:SetFields(aStru)					    //adicionado\Ajustado
	oTable:Create()								//adicionado\Ajustado
	cArq := oTable:GetRealName()				//adicionado\Ajustado
	DbUseArea(.t.,"TOPCONN",cArq,"_SxsTmp")

   //Criar Temporario - TABELAS (SX2)
	aStru:= {}
	cArq := ""
	AADD(aStru,{"OK"   		,"C",  2,0})
	AADD(aStru,{"ACAO"		,"C",  1,0})
	AADD(aStru,{"TABELA"   	,"C",  3,0})
	AADD(aStru,{"DESC"     	,"C", 30,0})
	//cArq :=	Criatrab(aStru,.T.)				//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("_Sx2Tmp") //adicionado\Ajustado
	oTable:SetFields(aStru)					    //adicionado\Ajustado
	oTable:Create()								//adicionado\Ajustado
	cArq := oTable:GetRealName()				//adicionado\Ajustado
	DbUseArea(.t.,"TOPCONN",cArq,"_Sx2Tmp")
	IndRegua("_Sx2Tmp",cArq,"TABELA",,,"Gerando Indice Temporario...") //

   //Criar Temporario - CAMPOS (SX3)
	aStru:=	{}
	cArq := ""
	AADD(aStru,{"OK"    	,"C",  2,0})
	AADD(aStru,{"ACAO"		,"C",  1,0})
	AADD(aStru,{"ALIAS"  	,"C",  3,0})
	AADD(aStru,{"CAMPO"    	,"C", 10,0})
	AADD(aStru,{"TITULO"  	,"C", 12,0})
	AADD(aStru,{"TIPO"  	,"C",  1,0})
	AADD(aStru,{"TAMANHO"  	,"N",  3,0})
	AADD(aStru,{"DECIMAL"  	,"N",  1,0})
	//cArq := Criatrab(aStru,.T.)				//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("_Sx3Tmp") //adicionado\Ajustado
	oTable:SetFields(aStru)					    //adicionado\Ajustado
	oTable:Create()								//adicionado\Ajustado
	cArq := oTable:GetRealName()				//adicionado\Ajustado
	DbUseArea(.t.,"TOPCONN",cArq,"_Sx3Tmp")
	IndRegua("_Sx3Tmp",cArq,"ALIAS+CAMPO",,,"Gerando Indice Temporario...") //

   //Criar Temporario - INDICE (SIX)
	aStru:=	{}
	cArq := ""
	AADD(aStru,{"OK"    	,"C",  	2,0})
	AADD(aStru,{"ACAO"		,"C",	1,0})
	AADD(aStru,{"INDICE"  	,"C",  	3,0})
	AADD(aStru,{"ORDEM"  	,"C",   1,0})
	AADD(aStru,{"CHAVE"    	,"C", 160,0})
	AADD(aStru,{"NICKNAME" 	,"C",  10,0})
	//cArq := Criatrab(aStru,.T.)				//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("_SixTmp") //adicionado\Ajustado
	oTable:SetFields(aStru)					    //adicionado\Ajustado
	oTable:Create()								//adicionado\Ajustado
	cArq := oTable:GetRealName()				//adicionado\Ajustado
	DbUseArea(.t.,"TOPCONN",cArq,"_SixTmp")

   //Criar Temporario - PERGUNTAS (SX1)
	aStru:=	{}
	cArq := ""
	AADD(aStru,{"OK"    	,"C",  2,0})
	AADD(aStru,{"ACAO"		,"C",  1,0})
	AADD(aStru,{"ORDEM"   	,"C",  2,0})
	AADD(aStru,{"GRUPO"   	,"C",  6,0})
	AADD(aStru,{"PERGUNT"  	,"C", 30,0})
	//cArq := Criatrab(aStru,.T.)				//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("_Sx1Tmp") //adicionado\Ajustado
	oTable:SetFields(aStru)					    //adicionado\Ajustado
	oTable:Create()								//adicionado\Ajustado
	cArq := oTable:GetRealName()				//adicionado\Ajustado
	DbUseArea(.t.,"TOPCONN",cArq,"_Sx1Tmp")

   //Criar Temporario - TABELAS(SX5)
	aStru:=	{}
	cArq := ""
	AADD(aStru,{"OK"    	,"C",  2,0})
	AADD(aStru,{"ACAO"		,"C",  1,0})
	AADD(aStru,{"TABELA"  	,"C",  2,0})
	AADD(aStru,{"CHAVE"    	,"C",  6,0})
	AADD(aStru,{"DESCRI"  	,"C", 55,0})
	//cArq := Criatrab(aStru,.T.)				//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("_Sx5Tmp") //adicionado\Ajustado
	oTable:SetFields(aStru)					    //adicionado\Ajustado
	oTable:Create()								//adicionado\Ajustado
	cArq := oTable:GetRealName()				//adicionado\Ajustado
	DbUseArea(.t.,"TOPCONN",cArq,"_Sx5Tmp")

   //Criar Temporario - PARAMETROS(SX6)
	aStru:=	{}
	cArq := ""
	AADD(aStru,{"OK"    	,"C",  2,0})
	AADD(aStru,{"ACAO"		,"C",  1,0})
	AADD(aStru,{"PAR" 	 	,"C", 10,0})
	AADD(aStru,{"TIPO"    	,"C",  1,0})
	AADD(aStru,{"DESCRIC"  	,"C", 50,0})
	//cArq := Criatrab(aStru,.T.)				//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("_Sx6Tmp") //adicionado\Ajustado
	oTable:SetFields(aStru)					    //adicionado\Ajustado
	oTable:Create()								//adicionado\Ajustado
	cArq := oTable:GetRealName()				//adicionado\Ajustado
	DbUseArea(.t.,"TOPCONN",cArq,"_Sx6Tmp")

   //Criar Temporario - GATILHOS(SX7)
	aStru:=	{}
	cArq := ""
	AADD(aStru,{"OK"    	,"C",  2,0})
	AADD(aStru,{"ACAO"		,"C",  1,0})
	AADD(aStru,{"CAMPO"	 	,"C", 10,0})
	AADD(aStru,{"SEQUENCIA"	,"C",  3,0})  
	AADD(aStru,{"REGRA"		,"C",100,0})
	AADD(aStru,{"CDOMIN"	,"C", 10,0})		
	AADD(aStru,{"ALIAS"		,"C",  3,0})
	AADD(aStru,{"CHAVE"		,"C",100,0})		
	//cArq := Criatrab(aStru,.T.)				//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("_Sx7Tmp") //adicionado\Ajustado
	oTable:SetFields(aStru)					    //adicionado\Ajustado
	oTable:Create()								//adicionado\Ajustado
	cArq := oTable:GetRealName()				//adicionado\Ajustado
	DbUseArea(.t.,"TOPCONN",cArq,"_Sx7Tmp")

   //Criar Temporario - (SXA)
	aStru:=	{}
	cArq := ""
	AADD(aStru,{"OK"    	,"C",	2,0})
	AADD(aStru,{"ACAO"		,"C",	1,0})
	AADD(aStru,{"ALIAS"	 	,"C",	3,0})
	AADD(aStru,{"ORDEM"    	,"C",	1,0})
	AADD(aStru,{"DESCRIC"  	,"C",  30,0})
	//cArq := Criatrab(aStru,.T.)				//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("_SxaTmp") //adicionado\Ajustado
	oTable:SetFields(aStru)					    //adicionado\Ajustado
	oTable:Create()								//adicionado\Ajustado
	cArq := oTable:GetRealName()				//adicionado\Ajustado
	DbUseArea(.t.,"TOPCONN",cArq,"_SxaTmp")

   //Criar Temporario - (SXB)
	aStru:=	{}
	cArq := ""
	AADD(aStru,{"OK"    	,"C",	2,0})
	AADD(aStru,{"ACAO"		,"C",	1,0})
	AADD(aStru,{"ALIAS"	 	,"C",	3,0})
	AADD(aStru,{"TIPO"     	,"C",	1,0})
	AADD(aStru,{"SEQ"      	,"C",	2,0})
	AADD(aStru,{"COLUNA"	,"C",	3,0})
	AADD(aStru,{"CONTEM"	,"C", 250,0})	
	//cArq := Criatrab(aStru,.T.)				//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("_SxbTmp") //adicionado\Ajustado
	oTable:SetFields(aStru)					    //adicionado\Ajustado
	oTable:Create()								//adicionado\Ajustado
	cArq := oTable:GetRealName()				//adicionado\Ajustado
	DbUseArea(.t.,"TOPCONN",cArq,"_SxbTmp")
Return


//Montar diferencas
Static Function MontaDif()        
Local nPos
Local lAltera,lPula, lGrava 	:= .T.
Local	aStruDB := {}            
Local lchkIntegridade :=.f.
Local cOrdem

	nAtualSxs 			:= 0
	oAmbiente:nTotal 	:= 8

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Analise de dicionarios de dados             		³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//SINDEX-----------------------------------------------
   oAtuAmb:cCaption	:= 'Analisando diferencas dos Indices...' //
   oAtuAmb:Refresh()
	oAmbiente:Set(++nAtualSxs)
	SysRefresh()

  	DbSelectArea("SIX")
	SIX->(DbSetOrder(1))  	
	lGrava := .f.
	ACDIX->(DbGotop())

	While ! ACDIX->(EOF())              
	   If Empty(ACDIX->NICKNAME)
	   	If ! SIX->(DbSeek(ACDIX->(INDICE+ORDEM))) 
	   		lAltera:= .F.   //inclui
			Else         
				If SIX->PROPRI <> 'U' // nao pode altera indice que nap seja de usuario
		   		ACDIX->(DbSkip())
		   		Loop
			   EndIf				  
			   If ACDIX->CHAVE == SIX->CHAVE
		   		ACDIX->(DbSkip())
		   		Loop
				EndIf			   
				lAltera:= .T.				   		
		   EndIf	           
		   cOrdem := ACDIX->ORDEM
	   Else 
	   	If ! SIX->(FindSix(ACDIX->INDICE,ACDIX->NICKNAME))
	   	   lAltera:= .F.   //inclui
	      Else                       
				If SIX->PROPRI <> 'U' // nao pode altera indice que nap seja de usuario
		   		ACDIX->(DbSkip())
		   		Loop
			   EndIf				
			   If ACDIX->CHAVE == SIX->CHAVE
		   		ACDIX->(DbSkip())
		   		Loop
				EndIf			   
				lAltera:= .T.				   		
	      EndIf
	      cOrdem := "?"
	   EndIf
	   
		_SixTmp->(RecLock("_SixTmp",.T.))
  		_SixTmp->OK      	:=  aMarca[1]
  		_SixTmp->ACAO		:=	 If(lAltera,"A","I")
  		_SixTmp->INDICE 	:=  ACDIX->INDICE
  		_SixTmp->ORDEM 	:=  cOrdem		
 		_SixTmp->CHAVE	 	:=  ACDIX->CHAVE 
  		_SixTmp->NICKNAME	:=  ACDIX->NICKNAME	 		
		_SixTmp->(MsunLock())
		lGrava := .t.
		ACDIX->(DbSkip())
		
	EndDo
	If lGrava // grava cabecalho
		RecLock("_SxsTmp",.T.)
     		_SxsTmp->OK      	:=  aMarca[3]
     		_SxsTmp->ACAO		:=	 "A"
	  		_SxsTmp->TABELA  	:=  "SIX"
	  		_SxsTmp->DESC	 	:=  "Dicionario de Indice" //
	   MsUnlock()
	EndIf
	_SixTmp->(DbGotop())
	ACDIX->(DbCloseArea())


	//SX1-------------------------------------------------
	oAtuAmb:cCaption	:= 'Analisando diferencas das Perguntas...' //
   oAtuAmb:Refresh()	
	oAmbiente:Set(++nAtualSxs)
	SysRefresh()

  	DbSelectArea("SX1")
  	DbSetOrder(1)

  	lGrava 	:= .f.
	ACDX1->(DbGotop())
	While ! ACDX1->(EOF())
	   lPula:= .t.  
	   lAltera:= .f.	   
		If SX1->(DbSeek(ACDX1->(X1_GRUPO+X1_ORDEM)))
		   If ! SX1->(X1_GRUPO+X1_ORDEM+X1_TIPO+X1_VARIAVL+STR(X1_TAMANHO,2)+STR(X1_DECIMAL,1)+;
		   				X1_DEF01+X1_DEF02+X1_DEF03+X1_DEF04+X1_DEF05) ==  	;
		   	  ACDX1->(X1_GRUPO+X1_ORDEM+X1_TIPO+X1_VARIAVL+STR(X1_TAMANHO,2)+STR(X1_DECIMAL,1)+;
		   	  			X1_DEF01+X1_DEF02+X1_DEF03+X1_DEF04+X1_DEF05) 
  				lPula  := .f.
				lGrava :=.t.
				lAltera := .T.
	   	EndIf
		Else
			lAltera:= .F.
			lPula  := .f.
			lGrava :=.t.
		EndIf
      If ! lPula
			RecLock("_Sx1Tmp",.T.)
	   	_Sx1Tmp->OK      	:=  aMarca[2]
	   	_Sx1Tmp->ACAO		:=	 IIf(lAltera,"A","I")
	   	_Sx1Tmp->GRUPO 	:=  ACDX1->X1_GRUPO
	   	_Sx1Tmp->ORDEM 	:=  ACDX1->X1_ORDEM
	   	_Sx1Tmp->PERGUNT 	:=  ACDX1->X1_PERGUNT
			MsunLock()
      EndIf
		ACDX1->(DbSkip())
	EndDo
	If lGrava
		RecLock("_SxsTmp",.T.)
    		_SxsTmp->OK      	:=  aMarca[3]
      	_SxsTmp->ACAO    	:=  "A"
        	_SxsTmp->TABELA  	:=  "SX1"
        	_SxsTmp->DESC	 	:=  "Dicionario de Perguntas" //
		MsUnlock()
	EndIf
	_Sx1Tmp->(DbGotop())
	ACDX1->(DbCloseArea())
	
	
	//SX5 -------------------------------------------------
	oAtuAmb:cCaption	:= 'Analisando diferencas das Tabelas...' //
   oAtuAmb:Refresh()
	oAmbiente:Set(++nAtualSxs)
	SysRefresh()
	
  	DbSelectArea("SX5")
  	DbSetOrder(1)
  	lGrava 	:= .f.
	ACDX5->(DbGotop())
	While ! ACDX5->(EOF())
		If ! SX5->(DbSeek(ACDX5->(xFilial("SX5")+X5_TABELA+X5_CHAVE)))
			RecLock("_Sx5Tmp",.T.)
		   	_Sx5Tmp->OK      	:=  aMarca[5]
	   		_Sx5Tmp->ACAO		:=  "I"
	   		_Sx5Tmp->TABELA 	:=  ACDX5->X5_TABELA
	   		_Sx5Tmp->CHAVE 	:=  ACDX5->X5_CHAVE
	   		_Sx5Tmp->DESCRI	:=	 ACDX5->X5_DESCRI
			MsunLock()
         lGrava:= .t.
		EndIf
		ACDX5->(DbSkip())
	EndDo
	If lGrava
		RecLock("_SxsTmp",.T.)
     		_SxsTmp->OK      	:=  aMarca[3]
     		_SxsTmp->ACAO		:=	 "A"
     		_SxsTmp->TABELA  	:=  "SX5"
     		_SxsTmp->DESC	 	:=  "Dicionario de Tabelas" //
	   MsUnlock()
	EndIf

	_Sx5Tmp->(DbGotop())
	ACDX5->(DbCloseArea())

	//SX6 -------------------------------------------------
	oAtuAmb:cCaption	:= 'Analisando diferencas dos Parametros...' //
   oAtuAmb:Refresh()
	oAmbiente:Set(++nAtualSxs)
	SysRefresh()

  	DbSelectArea("SX6")
  	DbSetOrder(1)
  	lGrava := .f.
	ACDX6->(DbGotop())
	While ! ACDX6->(EOF())
		If ! SX6->(DbSeek(ACDX6->(xFilial("SX6")+X6_VAR))) 
			RecLock("_Sx6Tmp",.T.)
	     		_Sx6Tmp->OK      	:=  aMarca[6]
	     		_Sx6Tmp->ACAO		:=	 "I"
	     		_Sx6Tmp->PAR    	:=  ACDX6->X6_VAR
	     		_Sx6Tmp->TIPO  	:=  ACDX6->X6_TIPO
	     		_Sx6Tmp->DESCRIC	:=  ACDX6->X6_DESCRIC
		   MsunLock()
			lGrava := .t.
      EndIf
		ACDX6->(DbSkip())
	EndDo
	If lGrava
		RecLock("_SxsTmp",.T.)
      	_SxsTmp->OK      	:=  aMarca[3]
        	_SxsTmp->TABELA  	:=  "SX6"
        	_SxsTmp->ACAO		:=	 "A"
        	_SxsTmp->DESC	 	:=  "Parametros do sistema" //
	   MsUnlock()
	EndIf
	_Sx6Tmp->(DbGotop())
	ACDX6->(DbCloseArea())

	//SX7 -------------------------------------------------
	oAtuAmb:cCaption	:= 'Analisando diferencas dos Gatilhos...' //
   oAtuAmb:Refresh()
	oAmbiente:Set(++nAtualSxs)
	SysRefresh()

  	DbSelectArea("SX7")
  	DbSetOrder(1)
  	lGrava := .f.
	ACDX7->(DbGotop())
	While ! ACDX7->(EOF())
		If ! (SX7->(DbSeek(ACDX7->(X7_CAMPO+X7_SEQUENCIA))).AND. SX7->(X7_REGRA+X7_CDOMIN+X7_ALIAS+X7_CHAVE)==ACDX7->(X7_REGRA+X7_CDOMIN+X7_ALIAS+X7_CHAVE))
			RecLock("_Sx7Tmp",.T.)
  			_Sx7Tmp->OK      	:= aMarca[7]
  			_Sx7Tmp->ACAO		:= "I"
  	  		_Sx7Tmp->CAMPO  	:= ACDX7->X7_CAMPO  
  	  		_Sx7Tmp->REGRA		:= ACDX7->X7_REGRA
  	  		_Sx7Tmp->CDOMIN	:= ACDX7->X7_CDOMIN
  	  		_Sx7Tmp->ALIAS		:= ACDX7->X7_ALIAS
  	  		_Sx7Tmp->CHAVE		:= ACDX7->X7_CHAVE
	   	MsunLock()                          
	   	lGrava:= .t.
	   EndIf	
		ACDX7->(DbSkip())
	EndDo
	If lGrava
		RecLock("_SxsTmp",.T.)
     		_SxsTmp->OK      	:= aMarca[3]
     		_SxsTmp->ACAO		:=	"A"
     		_SxsTmp->TABELA  	:= "SX7"
     		_SxsTmp->DESC	 	:= "Gatilhos do sistema" //
	   MsUnlock()
	EndIf

	_Sx7Tmp->(DbGotop())
	ACDX7->(DbCloseArea())

	//SXA -------------------------------------------------
	oAtuAmb:cCaption	:= 'Analisando diferencas do SXA...' //
   oAtuAmb:Refresh()
	oAmbiente:Set(++nAtualSxs)
	SysRefresh()

  	DbSelectArea("SXA")
  	DbSetOrder(1)
  	lGrava := .f.
	ACDXA->(DbGotop())
	While ! ACDXA->(EOF())
		If ! SXA->(DbSeek(ACDXA->(XA_ALIAS+XA_ORDEM)))
			RecLock("_SxaTmp",.T.)
	     		_SxaTmp->OK      	:=  aMarca[8]
	     		_SxaTmp->ACAO		:=	 "I"
	     		_SxaTmp->ALIAS  	:=  ACDXA->XA_ALIAS
	     		_SxaTmp->ORDEM  	:=  ACDXA->XA_ORDEM
				_SxaTmp->DESCRIC	:=  ACDXA->XA_DESCRIC
		   MsunLock()
		   lGrava := .t.
	   EndIf
		ACDXA->(DbSkip())
	EndDo
	If lGrava
		RecLock("_SxsTmp",.T.)
     		_SxsTmp->OK      	:= aMarca[3]
     		_SxsTmp->ACAO		:= "A"
     		_SxsTmp->TABELA  	:= "SXA"
     		_SxsTmp->DESC	 	:= "SXA"
	   MsUnlock()
	EndIf
	_SxaTmp->(DbGotop())
	ACDXA->(DbCloseArea())

	//SXB -------------------------------------------------
	oAtuAmb:cCaption	:= 'Analisando diferencas do SXB...' //
   oAtuAmb:Refresh()
	oAmbiente:Set(++nAtualSxs)
	SysRefresh()

   DbSelectArea("SXB")
  	DbSetOrder(1)
  	lGrava := .f.

	ACDXB->(DbGotop())
	While ! ACDXB->(EOF())
		If  !(SXB->(DbSeek(ACDXB->(XB_ALIAS+XB_TIPO+XB_SEQ+XB_COLUNA))) .AND. SXB->XB_CONTEM==ACDXB->XB_CONTEM)		
			RecLock("_SxbTmp",.T.)
     		_SxbTmp->OK      	:= aMarca[9]
     		_SxbTmp->ACAO		:=	"I"
     		_SxbTmp->ALIAS  	:= ACDXB->XB_ALIAS
     		_SxbTmp->TIPO   	:= ACDXB->XB_TIPO
			_SxbTmp->SEQ      := ACDXB->XB_SEQ
			_SxbTmp->COLUNA   := ACDXB->XB_COLUNA
			_SxbTmp->CONTEM	:= ACDXB->XB_CONTEM
		   MsunLock()
		   lGrava:= .t.
      EndIF
		ACDXB->(DbSkip())
	EndDo
	If lGrava
		RecLock("_SxsTmp",.T.)
    		_SxsTmp->OK      	:= aMarca[9]
     		_SxsTmp->ACAO		:=	"A"
     		_SxsTmp->TABELA  	:= "SXB"
    		_SxsTmp->DESC	 	:= "SXB"
 	  MsUnlock()
	EndIf

	_SxbTmp->(DbGotop())
	ACDXB->(DbCloseArea())
   

  	//TABELAS E CAMPOS (SX2/SX3)
	aTabelas				:= {}
	oAtuAmb:cCaption	:= 'Analisando diferencas das Tabelas/Campos...' //
   oAtuAmb:Refresh()  	
	oAmbiente:Set(++nAtualSxs)
	SysRefresh()

  	cArq := CriaTrab(nil,.F.)
  	IndRegua("ACDX2",cArq,"X2_CHAVE",,,"Gerando Indice Temporario para SX2...") //

	DbSelectArea("SX3")
	DbSetOrder(2)
  	lGrava := .T.
	ACDX3->(DbGotop())
	While ! ACDX3->(EOF())
	   lAltera := .F.
		If  SX3->(DbSeek(ACDX3->X3_CAMPO))
			If SX3->X3_PROPRI=="U"
				ACDX3->(DbSkip())
				Loop		
			EndIF	
			If SX3->X3_CONTEXT=="V"
				ACDX3->(DbSkip())
				Loop		
			EndIF	            
			
         If lchkIntegridade
				DbSelectArea(ACDX3->X3_ARQUIVO)	 
				aStruDB := 	&('"'+ACDX3->X3_ARQUIVO+'"')->(DbStruct())
				If ascan(aStruDB,{|x| AllTrim(x[1]) == Alltrim(ACDX3->X3_CAMPO) .and. ;
				                   x[2] == ACDX3->X3_TIPO .and.;
				                   x[3] >= ACDX3->X3_TAMANHO .and.; 
				                   x[4] >= ACDX3->X3_DECIMAL}) > 0
					ACDX3->(DbSkip())
					Loop		                
				EndIf			                   
			Else   
		  		If SX3->X3_TIPO 		== ACDX3->X3_TIPO 	.AND.;
		  		   SX3->X3_TAMANHO 	>= ACDX3->X3_TAMANHO	.AND.;
		  		   SX3->X3_DECIMAL 	>= ACDX3->X3_DECIMAL	.AND.;
					SX3->X3_PICTURE 	== ACDX3->X3_PICTURE	.AND.;
					SX3->X3_VALID		== ACDX3->X3_VALID	.AND.;
					Alltrim(SX3->X3_WHEN)== AllTrim(ACDX3->X3_WHEN)
						ACDX3->(DbSkip())
						Loop
				EndIf
			EndIf	
		   lAltera := .t.
		EndIf
		If !_Sx2Tmp->(DbSeek(ACDX3->X3_ARQUIVO)) 
			RecLock("_Sx2Tmp",.T.)
      		_Sx2Tmp->OK      	:= aMarca[10]
      		_Sx2Tmp->ACAO		:= "A"
        		_Sx2Tmp->TABELA  	:= ACDX3->X3_ARQUIVO
        		If SX2->(DbSeek(ACDX3->X3_ARQUIVO))
        			_Sx2Tmp->DESC	:= SX2->X2_NOME
        		Else
        			ACDX2->(DbSeek(ACDX3->X3_ARQUIVO))
        			_Sx2Tmp->DESC	:= ACDX2->X2_NOME
        		EndIf
		   MsunLock()
		   Aadd(aTabelas,{.T.,"A",_Sx2Tmp->TABELA,_Sx2Tmp->DESC})
		EndIf
		
		RecLock("_Sx3Tmp",.T.)
  			_Sx3Tmp->OK      	:= aMarca[4]
  			_Sx3Tmp->ACAO		:=	IIf(lAltera,"A","I")
     		_Sx3Tmp->ALIAS  	:= ACDX3->X3_ARQUIVO
     		_Sx3Tmp->CAMPO	 	:= ACDX3->X3_CAMPO
     		_Sx3Tmp->TITULO	:= ACDX3->X3_TITULO
     		_Sx3Tmp->TIPO	 	:= ACDX3->X3_TIPO
     		_Sx3Tmp->TAMANHO	:= ACDX3->X3_TAMANHO
     		_Sx3Tmp->DECIMAL	:= ACDX3->X3_DECIMAL
	   MsunLock()
		
		ACDX3->(DbSkip())
	EndDo

	If Len(aTabelas) > 0
	   _Sx2Tmp->(DbGoTop())
	   DbSelectArea("_Sx3Tmp")
		Set Filter To &("_Sx3Tmp->Alias=='"+_Sx2Tmp->Tabela+"'")
	   _Sx3Tmp->(DbGotop())
	EndIf
 	oTabelas:SetArray(aTabelas)
	oTabelas:bChange 	:= {||AtuCpoLst(aTabelas[oTabelas:nAt,3])}
	oTabelas:bLine 	:= {|| {Iif(aTabelas[oTabelas:nAt,1],oOK,oNo),aTabelas[oTabelas:nAt,2],aTabelas[oTabelas:nAt,3],aTabelas[oTabelas:nAt,4]} }

	oSx3:oBrowse:Refresh()
	oTabelas:Refresh()


Return




Static Function AcdUptDic(cAlias,aStru,cOp)
Local aKey
Local nOrdem
Local aCampos 		:= {}
Local bBlock
Local nCpoAlias 	:= 0
DEFAULT cOp 		:= "I"

If cAlias == "SIX"
   aKey      := {1,2}
   nOrdem    := 1
   bBlock    := {|x,y| x[1]+x[2] < y[1]+y[2] }
   nCpoAlias := 1
   aCampos := RetStru("SIX")
ElseIf cAlias == "SX1"
   aKey   := {1,2}
   nOrdem := 1
   bBlock := {|x,y| x[1]+x[2] < y[1]+y[2] }
   aCampos := RetStru("SX1")
ElseIf cAlias == "SX2"
   aKey   := {1}
   nOrdem := 1
   bBlock := {|x,y| x[1] < y[1] }
   nCpoAlias := 1
   aCampos := RetStru("SX2")
ElseIf cAlias == "SX3"
   aKey   := {3}
   nOrdem := 2
   bBlock := {|x,y| x[1]+x[2] < y[1]+y[2] }
   nCpoAlias := 1
   aCampos := RetStru("SX3")
ElseIf cAlias == "SX5"
   aKey   := {1,2,3}
   nOrdem := 1
   bBlock := {|x,y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3] }
   aCampos := RetStru("SX5")
ElseIf cAlias == "SX6"
   aKey   := {1,2}
   nOrdem := 1
   bBlock := {|x,y| x[1]+x[2] < y[1]+y[2] }
   aCampos := RetStru("SX6")
ElseIf cAlias == "SX7"
   aKey   := {1,2}
   nOrdem := 1
   bBlock := {|x,y| x[1]+x[2] < y[1]+y[2] }
   aCampos := RetStru("SX7")
ElseIf cAlias == "SXA"
   aKey   := {1,2}
   nOrdem := 1
   bBlock := {|x,y| x[1]+x[2] < y[1]+y[2] }
   aCampos := RetStru("SXA")
ElseIf cAlias == "SXB"
   aKey   := {1,2,3,4}
   nOrdem := 1
   bBlock := {|x,y| x[1]+x[2]+x[3]+x[4] < y[1]+y[2]+y[3]+y[4] }
   aCampos := RetStru("SXB")
EndIf
aSort(aStru,,,bBlock)

GrvDic(cAlias,nOrdem,aKey,aStru,aCampos,cOp,nCpoAlias)
Return .t.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Checa a integridade de dados os dicionarios. 	³
//³AnalisaSXs foi compatibilizado para windows.   	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function AnalisaSXs() 
Local cX2_Path	:= ""
Local nLoc		:= 0
Local aStruSIX := {}
Local aStruSX1 := {}
Local aStruSX2 := {}
Local aStruSX3 := {}
Local aStruSX5 := {}
Local aStruSX6 := {}
Local aStruSX7 := {}
Local aStruSXA := {}
Local aStruSXB := {}

nAtualSxs 		:= 0
oMtSxs:nTotal 	:= 9
oMtSxs:Set(++nAtualSxs)
SysRefresh()
oAtuSxs:cCaption := 'Analisando SIX ...' //
oAtuSxs:Refresh()
MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SIN'+__UPTKEY, "ACDIX",.F.,.T.)
ACDIX->(DbGoTop())
While ! ACDIX->(Eof())
	nLoc := aScan(aNoSIX,{|x| AllTrim(x[1]) == AllTrim(ACDIX->(INDICE+ORDEM+CHAVE))})
	If nLoc = 0
	   aStruSIX:={}
   	  ACDIX->(aadd(aStruSIX,{INDICE,ORDEM,CHAVE,DESCRICAO,DESCSPA,DESCENG,PROPRI,F3,NICKNAME}))
      AcdUptDic("SIX",aStruSIX,"I")
	EndIf
   ACDIX->(DbSkip())
End
ACDIX->(DbCloseArea())

oAtuSxs:cCaption := 'Analisando SX1 ...' //
oAtuSxs:Refresh()
oMtSxs:Set(++nAtualSxs)
SysRefresh()
MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SX1'+__UPTKEY, "ACDX1",.F.,.T.)
ACDX1->(DbGoTop())
While ! ACDX1->(Eof())
	nLoc := aScan(aNoSX1,{|x|	x[1] == ACDX1->(X1_GRUPO+X1_ORDEM+X1_PERGUNT)})
	If nLoc = 0
	   aStruSX1:={}
	   ACDX1->(aadd(aStruSX1,{X1_GRUPO,X1_ORDEM,X1_PERGUNT,X1_PERSPA,X1_PERENG,X1_VARIAVL,X1_TIPO,X1_TAMANHO,X1_DECIMAL,;
	     		X1_PRESEL,	X1_GSC,X1_VALID,X1_VAR01,X1_DEF01,X1_DEFSPA1,X1_DEFENG1,X1_CNT01,;
	   		X1_VAR02,X1_DEF02,X1_DEFSPA2,X1_DEFENG2,X1_CNT02,;
				X1_VAR03,X1_DEF03,X1_DEFSPA3,X1_DEFENG3,X1_CNT03,;
				X1_VAR04,X1_DEF04,X1_DEFSPA4,X1_DEFENG4,X1_CNT04,;
	   		X1_VAR05,X1_DEF05,X1_DEFSPA5,X1_DEFENG5,X1_CNT05,X1_F3,X1_PYME,X1_GRPSXG}) )
	   AcdUptDic("SX1",aStruSX1,"I")
	EndIf
   ACDX1->(DbSkip())
End
ACDX1->(DbCloseArea())

oAtuSxs:cCaption := 'Analisando SX2 ...' //
oAtuSxs:Refresh()
oMtSxs:Set(++nAtualSxs)
SysRefresh()   

//Verifica qual eh o X2_PATH do cliente
SX2->(DbSetOrder(1))
If SX2->(DbSeek('SB1'))
	cX2_Path := SX2->X2_PATH
EndIf

MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SX2'+__UPTKEY, "ACDX2",.F.,.T.)
ACDX2->(DbGoTop())
While ! ACDX2->(Eof())
	nLoc := aScan(aNoSX2,{|x|	x[1] == ACDX2->(X2_CHAVE)})
	If nLoc = 0
	   aStruSX2	:=	{}
		ACDX2->(aadd(aStruSX2,{X2_CHAVE,If(Empty(cX2_Path),X2_PATH,cX2_Path),X2_CHAVE+Left(__cEmpFil,2)+"0", ;
										X2_NOME,	X2_NOMESPA,X2_NOMEENG,X2_DELET,X2_MODO,X2_TTS,X2_ROTINA}))
	   AcdUptDic("SX2",aStruSX2,"I")
	EndIf
   ACDX2->(DbSkip())
End
ACDX2->(DbCloseArea())

oAtuSxs:cCaption := 'Analisando SX3 ...' //
oAtuSxs:Refresh()
oMtSxs:Set(++nAtualSxs)
SysRefresh()
MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SX3'+__UPTKEY, "ACDX3",.F.,.T.)
ACDX3->(DbGoTop())
While ! ACDX3->(Eof())
	SX3->(DbSetOrder(2))
	If SX3->(DbSeek(ACDX3->X3_CAMPO)) .AND. (SX3->X3_TAMANHO > ACDX3->X3_TAMANHO .OR. SX3->X3_DECIMAL > ACDX3->X3_DECIMAL)
		Info("O tamanho (X3_TAMANHO ou X3_DECIMAL) do campo "+ACDX3->X3_CAMPO+" do dicionario Sx3 original e maior que o do update.") //###
		ACDX3->(DbSkip())
		Loop	
	EndIf
	nLoc := aScan(aNoSX3,{|x|	x[1] == ACDX3->(X3_ARQUIVO+X3_CAMPO)})
	If nLoc = 0
	   aStruSX3	:=	{}
		ACDX3->(aadd(aStruSX3,{X3_ARQUIVO,X3_ORDEM,X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL,X3_TITULO,X3_TITSPA,X3_TITENG,;
		X3_DESCRIC,X3_DESCSPA,X3_DESCENG,X3_PICTURE,X3_VALID,X3_USADO,X3_RELACAO,X3_F3,X3_NIVEL,X3_RESERV,X3_CHECK,X3_TRIGGER,;
		X3_PROPRI,X3_BROWSE,X3_VISUAL,X3_CONTEXT,X3_OBRIGAT,X3_VLDUSER,X3_CBOX,X3_CBOXSPA,X3_CBOXENG,X3_PICTVAR,X3_WHEN,;
		X3_INIBRW,X3_GRPSXG,X3_FOLDER}) )
	   AcdUptDic("SX3",aStruSX3,"I")
	EndIf
   ACDX3->(DbSkip())
End
ACDX3->(DbCloseArea())

oAtuSxs:cCaption := 'Analisando SX5 ...' //
oAtuSxs:Refresh()
oMtSxs:Set(++nAtualSxs)
SysRefresh()
MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SX5'+__UPTKEY, "ACDX5",.F.,.T.)
ACDX5->(DbGoTop())
While ! ACDX5->(Eof())
	nLoc := aScan(aNoSX5,{|x|	x[1] == ACDX5->(X5_TABELA+X5_CHAVE+X5_DESCRI)})
	If nLoc = 0
	   aStruSX5:={}
		ACDX5->(aadd(aStruSX5,{X5_FILIAL,X5_TABELA,X5_CHAVE,X5_DESCRI,X5_DESCSPA,X5_DESCENG}))
	   AcdUptDic("SX5",aStruSX5,"I")
   EndIf
   ACDX5->(DbSkip())
End
ACDX5->(DbCloseArea())

oAtuSxs:cCaption := 'Analisando SX6 ...' //
oAtuSxs:Refresh()
oMtSxs:Set(++nAtualSxs)
SysRefresh()
MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SX6'+__UPTKEY, "ACDX6",.F.,.T.)
ACDX6->(DbGoTop())
While ! ACDX6->(Eof())
	nLoc := aScan(aNoSX6,{|x|	x[1] == ACDX6->(X6_VAR+X6_TIPO+X6_DESCRIC)})
	If nLoc = 0
	   aStruSX6:={}
		ACDX6->(aadd(aStruSX6,{X6_FIL,X6_VAR,X6_TIPO,X6_DESCRIC,X6_DSCSPA,X6_DSCENG,	X6_DESC1,X6_DSCSPA1,X6_DSCENG1,X6_DESC2,X6_DSCSPA2,X6_DSCENG2,X6_CONTEUD,X6_CONTSPA,X6_CONTENG}))
	   AcdUptDic("SX6",aStruSX6,"I")
	EndIf
   ACDX6->(DbSkip())
End
ACDX6->(DbCloseArea())

oAtuSxs:cCaption := 'Analisando SX7 ...' //
oAtuSxs:Refresh()
oMtSxs:Set(++nAtualSxs)
SysRefresh()
MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SX7'+__UPTKEY, "ACDX7",.F.,.T.)
ACDX7->(DbGoTop())
While ! ACDX7->(Eof())
	nLoc := aScan(aNoSX7,{|x|	x[1] == ACDX7->(X7_CAMPO+X7_SEQUENC+X7_REGRA+X7_CDOMIN+X7_ALIAS+X7_CHAVE)})
	If nLoc = 0
	   aStruSX7:={}
		ACDX7->(aadd(aStruSX7,{X7_CAMPO,X7_SEQUENC,X7_REGRA,X7_CDOMIN,X7_TIPO,X7_SEEK,X7_ALIAS,X7_ORDEM,X7_CHAVE,X7_PROPRI,X7_CONDIC}))
	   AcdUptDic("SX7",aStruSX7,"I")
	 EndIf
   ACDX7->(DbSkip())
End
ACDX7->(DbCloseArea())

oAtuSxs:cCaption := 'Analisando SXA ...' //
oAtuSxs:Refresh()
oMtSxs:Set(++nAtualSxs)
SysRefresh()
MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SXA'+__UPTKEY, "ACDXA",.F.,.T.)
ACDXA->(DbGoTop())
While ! ACDXA->(Eof())
	nLoc := aScan(aNoSXA,{|x|	x[1] == ACDXA->(XA_ALIAS,XA_ORDEM,XA_DESCRIC)})
	If nLoc = 0
	   aStruSXA:={}
		ACDXA->(aadd(aStruSXA,{XA_ALIAS,XA_ORDEM,XA_DESCRIC,XA_DESCSPA,XA_DESCENG,XA_PROPRI}))
	   AcdUptDic("SXA",aStruSXA,"I")
	EndIf
   ACDXA->(DbSkip())
End
ACDXA->(DbCloseArea())

oAtuSxs:cCaption := 'Analisando SXB ...' //
oAtuSxs:Refresh()
oMtSxs:Set(++nAtualSxs)
SysRefresh()
MsOpenDbf( .T. ,__LocalDriver,dfcCaminho+'SXB'+__UPTKEY, "ACDXB",.F.,.T.)
ACDXB->(DbGoTop())
While ! ACDXB->(Eof())
	nLoc := aScan(aNoSXB,{|x|	x[1] == ACDXB->(XB_ALIAS+XB_TIPO+XB_SEQ+XB_COLUNA+XB_CONTEM)})
	If nLoc = 0
	   aStruSXB:={}
		ACDXB->(aadd(aStruSXB,{XB_ALIAS,XB_TIPO,XB_SEQ,XB_COLUNA,XB_DESCRI,XB_DESCSPA,XB_DESCENG,XB_CONTEM}))
	   AcdUptDic("SXB",aStruSXB,"I")
	EndIf
   ACDXB->(DbSkip())
End
ACDXB->(DbCloseArea())


oAtuSxs:cCaption := 'Analise dos dicinarios Finalizada.' //
oAtuSxs:Refresh()
Return .t.


Static Function RetStru(cAlias)
Local aCampos := {}
If cAlias == "SIX"
   aadd(aCampos,{"INDICE","1"})
   aadd(aCampos,{"ORDEM","1"})
   aadd(aCampos,{"CHAVE","1"})
   aadd(aCampos,{"DESCRICAO","1"})
   aadd(aCampos,{"DESCSPA","1"})
   aadd(aCampos,{"DESCENG","1"})
   aadd(aCampos,{"PROPRI","1"})
   aadd(aCampos,{"F3","1"})
   aadd(aCampos,{"NICKNAME","1"})
ElseIf cAlias == "SX1"
   aadd(aCampos,{"X1_GRUPO","1"})
   aadd(aCampos,{"X1_ORDEM","1"})
   aadd(aCampos,{"X1_PERGUNT","1"})
   aadd(aCampos,{"X1_PERSPA","1"})
   aadd(aCampos,{"X1_PERENG","1"})
   aadd(aCampos,{"X1_VARIAVL","1"})
   aadd(aCampos,{"X1_TIPO","1"})
   aadd(aCampos,{"X1_TAMANHO","1"})
   aadd(aCampos,{"X1_DECIMAL","1"})
   aadd(aCampos,{"X1_PRESEL","2"})
   aadd(aCampos,{"X1_GSC","1"})
   aadd(aCampos,{"X1_VALID","1"})
   aadd(aCampos,{"X1_VAR01","1"})
   aadd(aCampos,{"X1_DEF01","1"})
   aadd(aCampos,{"X1_DEFSPA1","1"})
   aadd(aCampos,{"X1_DEFENG1","1"})
   aadd(aCampos,{"X1_CNT01","2"})
   aadd(aCampos,{"X1_VAR02","1"})
   aadd(aCampos,{"X1_DEF02","1"})
   aadd(aCampos,{"X1_DEFSPA2","1"})
   aadd(aCampos,{"X1_DEFENG2","1"})
   aadd(aCampos,{"X1_CNT02","2"})
   aadd(aCampos,{"X1_VAR03","1"})
   aadd(aCampos,{"X1_DEF03","1"})
   aadd(aCampos,{"X1_DEFSPA3","1"})
   aadd(aCampos,{"X1_DEFENG3","1"})
   aadd(aCampos,{"X1_CNT03","2"})
   aadd(aCampos,{"X1_VAR04","1"})
   aadd(aCampos,{"X1_DEF04","1"})
   aadd(aCampos,{"X1_DEFSPA4","1"})
   aadd(aCampos,{"X1_DEFENG4","1"})
   aadd(aCampos,{"X1_CNT04","2"})
   aadd(aCampos,{"X1_VAR05","1"})
   aadd(aCampos,{"X1_DEF05","1"})
   aadd(aCampos,{"X1_DEFSPA5","1"})
   aadd(aCampos,{"X1_DEFENG5","1"})
   aadd(aCampos,{"X1_CNT05","2"})
   aadd(aCampos,{"X1_F3","1"})
   aadd(aCampos,{"X1_GRPSXG","1"})
ElseIf cAlias == "SX2"
   aadd(aCampos,{"X2_CHAVE","1"})
   aadd(aCampos,{"X2_PATH","2"})
   aadd(aCampos,{"X2_ARQUIVO","2"})
   aadd(aCampos,{"X2_NOME","1"})
   aadd(aCampos,{"X2_NOMESPA","1"})
   aadd(aCampos,{"X2_NOMEENG","1"})
   aadd(aCampos,{"X2_DELET","2"})
   aadd(aCampos,{"X2_MODO","2"})
   aadd(aCampos,{"X2_TTS","2"})
   aadd(aCampos,{"X2_ROTINA","2"})
ElseIf cAlias == "SX3"
   aadd(aCampos,{"X3_ARQUIVO","2"})
   aadd(aCampos,{"X3_ORDEM","2"})
   aadd(aCampos,{"X3_CAMPO","1"})
   aadd(aCampos,{"X3_TIPO","1"})
   aadd(aCampos,{"X3_TAMANHO","1"})
   aadd(aCampos,{"X3_DECIMAL","1"})
   aadd(aCampos,{"X3_TITULO","1"})
   aadd(aCampos,{"X3_TITSPA","1"})
   aadd(aCampos,{"X3_TITENG","1"})
   aadd(aCampos,{"X3_DESCRIC","1"})
   aadd(aCampos,{"X3_DESCSPA","1"})
   aadd(aCampos,{"X3_DESCENG","1"})
   aadd(aCampos,{"X3_PICTURE","1"})
   aadd(aCampos,{"X3_VALID","1"})
   aadd(aCampos,{"X3_USADO","1"})
   aadd(aCampos,{"X3_RELACAO","1"})
   aadd(aCampos,{"X3_F3","1"})
   aadd(aCampos,{"X3_NIVEL","1"})
   aadd(aCampos,{"X3_RESERV","1"})
   aadd(aCampos,{"X3_CHECK","1"})
   aadd(aCampos,{"X3_TRIGGER","1"})
   aadd(aCampos,{"X3_PROPRI","1"})
   aadd(aCampos,{"X3_BROWSE","1"})
   aadd(aCampos,{"X3_VISUAL","1"})
   aadd(aCampos,{"X3_CONTEXT","1"})
   aadd(aCampos,{"X3_OBRIGAT","1"})
   aadd(aCampos,{"X3_VLDUSER","2"})
   aadd(aCampos,{"X3_CBOX","1"})
   aadd(aCampos,{"X3_CBOXSPA","1"})
   aadd(aCampos,{"X3_CBOXENG","1"})
   aadd(aCampos,{"X3_PICTVAR","1"})
   aadd(aCampos,{"X3_WHEN","1"})
   aadd(aCampos,{"X3_INIBRW","1"})
   aadd(aCampos,{"X3_GRPSXG","1"})
   aadd(aCampos,{"X3_FOLDER","1"})
ElseIf cAlias == "SX5"
   aadd(aCampos,{"X5_FILIAL","1"})
   aadd(aCampos,{"X5_TABELA","1"})
   aadd(aCampos,{"X5_CHAVE","1"})
   aadd(aCampos,{"X5_DESCRI","1"})
   aadd(aCampos,{"X5_DESCSPA","1"})
   aadd(aCampos,{"X5_DESCENG","1"})
ElseIf cAlias == "SX6"
   aadd(aCampos,{"X6_FIL","1"})
   aadd(aCampos,{"X6_VAR","1"})
   aadd(aCampos,{"X6_TIPO","1"})
   aadd(aCampos,{"X6_DESCRIC","1"})
   aadd(aCampos,{"X6_DSCSPA","1"})
   aadd(aCampos,{"X6_DSCENG","1"})
   aadd(aCampos,{"X6_DESC1","1"})
   aadd(aCampos,{"X6_DSCSPA1","1"})
   aadd(aCampos,{"X6_DSCENG1","1"})
   aadd(aCampos,{"X6_DESC2","1"})
   aadd(aCampos,{"X6_DSCSPA2","1"})
   aadd(aCampos,{"X6_DSCENG2","1"})
   aadd(aCampos,{"X6_CONTEUD","2"})
   aadd(aCampos,{"X6_CONTSPA","2"})
   aadd(aCampos,{"X6_CONTENG","2"})
   aadd(aCampos,{"X6_PROPRI","1"})			// -- By Erike dia 16/06/2004
ElseIf cAlias == "SX7"
   aadd(aCampos,{"X7_CAMPO","1"})
   aadd(aCampos,{"X7_SEQUENC","1"})
   aadd(aCampos,{"X7_REGRA","1"})
   aadd(aCampos,{"X7_CDOMIN","1"})
   aadd(aCampos,{"X7_TIPO","1"})
   aadd(aCampos,{"X7_SEEK","1"})
   aadd(aCampos,{"X7_ALIAS","1"})
   aadd(aCampos,{"X7_ORDEM","1"})
   aadd(aCampos,{"X7_CHAVE","1"})
   aadd(aCampos,{"X7_PROPRI","1"})
   aadd(aCampos,{"X7_CONDIC","1"})
ElseIf cAlias == "SXA"
   aadd(aCampos,{"XA_ALIAS","1"})
   aadd(aCampos,{"XA_ORDEM","1"})
   aadd(aCampos,{"XA_DESCRIC","1"})
   aadd(aCampos,{"XA_DESCSPA","1"})
   aadd(aCampos,{"XA_DESCENG","1"})
   aadd(aCampos,{"XA_PROPRI","1"})
ElseIf cAlias == "SXB"
   aadd(aCampos,{"XB_ALIAS","1"})
   aadd(aCampos,{"XB_TIPO","1"})
   aadd(aCampos,{"XB_SEQ","1"})
   aadd(aCampos,{"XB_COLUNA","1"})
   aadd(aCampos,{"XB_DESCRI","1"})
   aadd(aCampos,{"XB_DESCSPA","1"})
   aadd(aCampos,{"XB_DESCENG","1"})
   aadd(aCampos,{"XB_CONTEM","1"})
EndIf
Return aCampos


Static Function CbTrim(uCar)
If ValType(uCar) == "C"
   Return AllTrim(uCar)
EndIf
Return uCar


Static Function Info(cMensagem)
DEFAULT cMensagem := ''
AutoGRLog(cMensagem)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³AutoGrLog ³ Autor ³ Sandro 		   			³ Data ³ 12/03/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava o Log com a descricao do HELP.							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe		  ³ AutoGrLog [ cExpr ] )																																	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parƒmetros³ ExpC1 - Texto a ser gravado no arquivo.						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AutoGRLog(cLogErro,lRetVal)
Local cBuffer		:= Space(1000000)
Default	lRetVal 	:= .F.

If nHdlLog == NIL
	If (nHdlLog := FCreate(dfcArqlog,0)) == -1
		Return
	EndIf
Else
	If (nHdlLog := FOpen(dfcArqlog,2)) == -1
		Return
	EndIf
EndIf

If lRetVal
	 FREAD(nHdlLog, @cBuffer, 1000000)
	 Return cBuffer
Else
	FSeek(nHdlLog,0,2)
	FWrite(nHdlLog,cLogErro+chr(13)+chr(10))
	FClose(nHdlLog)
EndIf
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ GrvDic   ³ Autor ³ Eduardo Motta         ³ Data ³ 03/12/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Efetua manutencao em arquivos do SXs e SINDEX              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACDUPTDATE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GrvDic(cAlias,nOrdem,aKey,aStru,aCampos,cOp,nCpoAlias)
Local nI,nJ,nPos
Local cKey
Local cDesKey
Local lNew
Local cTipCpo
Local cSvCampo
Local cSvTipo
Local nSvTam
Local nSvDec
Local cSvChav
Local cMensagem
Local uValAnt
Local lGrava
Local cPosSix
Local nRegSix
Local cNewOrdem
DbSelectArea(cAlias)
DbSetOrder(nOrdem)
For nI := 1 to Len(aStru)
   cKey    := ""
   cDesKey := Replicate("-",70)+Chr(13)+Chr(10)+"Implementacao(oes):"+Chr(13)+Chr(10) //
   For nJ := 1 To Len(aKey)
      cKey+=PadR(aStru[nI,aKey[nJ]],Len(&(aCampos[aKey[nJ],1])))
      cDesKey+=aCampos[aKey[nJ],1]+" => "+aStru[nI,aKey[nJ]]+Chr(13)+Chr(10)
   Next
   If cAlias == "SIX"
      If Right(cKey,1) =="?"
      	FindSix(Left(cKey,3),aStru[nI,9])
      Else
      	DbSeek(cKey)
      Endif
   Else
   	DbSeek(cKey)
	EndIf
	   
   If cAlias == "SX3"
      cSvCampo := SX3->X3_CAMPO
      cSvTipo  := SX3->X3_TIPO
      nSvTam   := SX3->X3_TAMANHO
      nSvDec   := SX3->X3_DECIMAL
   ElseIf cAlias == "SIX"
      cSvChav  := SIX->CHAVE
   EndIf
   If Eof() .and. cOp # "E"
      If cAlias =="SIX"
	      cNewOrdem := SIX->(RetUltOrdem(Left(cKey,3)))
	  	EndIf
      RecLock(cAlias,.T.)
      lNew := .T.
   ElseIf !Eof()
      RecLock(cAlias,.F.)
      If cAlias =="SIX"
	      cNewOrdem := SIX->ORDEM
	   EndIf   
      lNew := .F.
   EndIf
   lGrava := .T.
   If cOp == "E"
      If ! eof()
	      DbDelete()
	   EndIf
   ElseIf !Eof()
      For nJ := 1 to Len(aCampos)
         nPos := FieldPos(aCampos[nJ,1])
         cTipCpo := aCampos[nJ,2]
         If nPos # 0
  	         uValAnt := FieldGet(nPos)
            cMensagem := ""
            If cTipCpo == "1" // sempre grava
   	     		If Right(AllTrim(PadR(aCampos[nJ,1],10)),6) =="PROPRI"
		         	FieldPut(nPos,"U")
		         	Loop
      	       EndIf

               If ! CbTrim(uValAnt) == CbTrim(aStru[nI,nJ])
                  If lNew
                     cMensagem := "Incluido: " //
                     cMensagem += PadR(aCampos[nJ,1],10)+" => "
                  Else
                     cMensagem := "Alterado: " //
                     cMensagem += PadR(aCampos[nJ,1],10)+Chr(13)+Chr(10)
                     cMensagem += Space(11)+" DE   => "+cValToChar(uValAnt)+Chr(13)+Chr(10) //
                     cMensagem += Space(11)+" PARA => " //
                  EndIf
                  cMensagem += cValToChar(aStru[nI,nJ])
                  If lGrava .and. aStru[nI,nJ] # NIL
                     If cAlias == "SIX" .and. nJ==2 .and. Right(cKey,1) =="?"
                     	FieldPut(nPos,cNewOrdem)
                     Else
                    		FieldPut(nPos,aStru[nI,nJ])
                    	EndIf	
                  EndIf
               EndIf
            ElseIf cTipCpo == "2" // somente na inclusao
         		If Right(AllTrim(PadR(aCampos[nJ,1],10)),6) =="PROPRI"
		         	FieldPut(nPos,"U")
		         	Loop
      	      EndIf
               If lNew
                  If ! CbTrim(uValAnt) == CbTrim(aStru[nI,nJ])
                     If lGrava .and. aStru[nI,nJ] # NIL
                        FieldPut(nPos,aStru[nI,nJ])
                     EndIf
                     cMensagem := "Incluido: " //
                     cMensagem += PadR(aCampos[nJ,1],10)+" => "+cValToChar(aStru[nI,nJ])
                  EndIf
               EndIf
            ElseIf cTipCpo == "3"  // nao grava nunca
            EndIf
            If !Empty(cMensagem)
               If !Empty(cDesKey)
                  If lGrava
                     Info(cDesKey)
                  Else
                     cTxtIgnora+=cDesKey+Chr(13)+Chr(10)
                  EndIf
                  cDesKey := ""
               EndIf
               If lGrava
                  Info(cMensagem)
               Else
                  cTxtIgnora+=cMensagem+Chr(13)+Chr(10)
               EndIf
            EndIf
         EndIf
      Next
   EndIf
   If cAlias == "SX3" .and. !Eof()
      If SX3->X3_CONTEXT # "V" .and. ;
      (! cSvCampo ==SX3->X3_CAMPO .or.;
       ! cSvTipo == SX3->X3_TIPO  .or.;
       ! nSvTam == SX3->X3_TAMANHO .or.;
       ! nSvDec == SX3->X3_DECIMAL .or.;
       lNew  .or. cOp == "E")
         nPos := aScan(aChkStru,{|x|x==SX3->X3_ARQUIVO})
         If nPos == 0
   	        aadd(aChkStru,SX3->X3_ARQUIVO)
         EndIf
      EndIf
   ElseIf cAlias == "SIX" .and. !Eof()
      If ! cSvChav == SIX->CHAVE
         nPos := aScan(aIndNew,{|x|x==SIX->INDICE})
         If nPos == 0
            aadd(aIndNew,SIX->INDICE)
         EndIf
      EndIf
   ElseIf cAlias == "SX2" .and. !Eof()
      If lNew
         aadd(aNewSX2,SX2->X2_CHAVE)
      EndIf
   EndIf
   If ! eof()
	   MsUnlock()
	EndIf
Next
Return .T.



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ ChkStru  ³ Autor ³ Eduardo Motta         ³ Data ³ 03/12/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Atualiza estrutura de dados de acordo com o dicionario     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACD                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ChkStru()
Local cNome 	:= Space(20)
Local aFiles 	:= {}
Local cArquivo
Local aStruSX3 := {}
Local lJ
Local nG

cNome := Trim(cNome)
If !GetFiles(aFiles)
   Return
EndIf
For nG := 1 to Len(aIndNew)
   SX2->(DbSetOrder(1))
   SX2->(DbSeek(aIndNew[nG]))
	If ! __cRDD == "TOPCONN"
      Info('Excluindo o arquivo de indice '+AllTrim(SX2->X2_PATH)+AllTrim(SX2->X2_ARQUIVO)+RetIndExt())
      FErase(AllTrim(SX2->X2_PATH)+AllTrim(SX2->X2_ARQUIVO)+RetIndExt())  
	Else                                                                                                 
      Info('Excluindo os arquivos de indices  da tabela '+AllTrim(SX2->X2_ARQUIVO))
		TCInternal(69,AllTrim(SX2->X2_ARQUIVO))      
   EndIF
Next

//Atualiza o Objeto Meter
nAtualStru 		:=	0
oMtStru:nTotal	:=	Len(aFiles)

lj:= .f.
For nG := 1 to Len(aFiles)
   cArquivo := aFiles[nG,1]
   If ! Upper(SubStr(cArquivo,1,3))$"SIN/SX1/SX2/SX3/SX4/SX5/SX6/SX7/SX8/SX9/SXA/SXB/SXC/SXD/SXE/SXF/SXG"
		If __cRDD == "TOPCONN"
		   cArquivo := Alltrim(cArquivo)
		Else
	      cArquivo := aFiles[nG,2]
		EndIf

		oAtuStru1:cCaption	:=	'Analizando '+aFiles[nG,1]
		oAtuStru2:cCaption	:=	''
		oAtuStru3:cCaption	:=	''
      oAtuStru1:Refresh()
      oAtuStru2:Refresh()
      oAtuStru3:Refresh()
  		oMtStru:Set(++nAtualStru)
	   SysRefresh()

      aStruSx3:={}
      IF Diferente(cArquivo,@aStruSx3,aFiles[nG,3])
         lj:= .t.
     		If ! __cRDD == "TOPCONN"
		      If File(Left(aFiles[nG,2],Len(aFiles[nG,2])-4)+RetIndExt())
   	         Info('Excluindo o arquivo de indice '+Left(aFiles[nG,2],Len(aFiles[nG,2])-4)+RetIndExt())
	   		   FErase(Left(aFiles[nG,2],Len(aFiles[nG,2])-4)+RetIndExt())
   		   EndIf
		   EndIf
         Ajusta(cArquivo,aStruSx3)
      EndIf
   EndIf
Next
If lj
  Info(Repl('-',70))
  Info('Para cada arquivo ajustado foi criado uma copia de seguranca ?????BKP')
  Info('Exemplo: SA1010.DBF ->SA101BKP')
Endif
Info('Fim ')
Info("Atualizador concluido com sucesso.") //

oAtuStru1:cCaption	:=	''
oAtuStru2:cCaption	:=	''
oAtuStru3:cCaption	:=	''
oAtuStru1:Refresh()
oAtuStru2:Refresh()
oAtuStru3:Refresh()
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ Diferente³ Autor ³ Eduardo Motta         ³ Data ³ 03/12/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Verifica se a estrutura da tabela esta diferente do SX3    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ChkStru                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Diferente(cArquivo,aStruSx3,cAlias)
Local aStru :={}
Local lDif := .f.
Local nI
Local nLoc
Local nQtdeDB
Local nQtdeSX

Info(Repl('-',70))
Info('Analisando a necessidade de ajuste do arquivo '+cArquivo)
DbSelectArea('SX3')
DbSetOrder(1)
IF ! DbSeek(cAlias)
   Return .f.
EndIf

If Select(SX3->X3_ARQUIVO) > 0
   DbSelectArea(SX3->X3_ARQUIVO)
   DbCloseArea()
EndIf

If __cRDD == "TOPCONN"
   If ! TCCanOpen(cArquivo)
      Return .F.
   EndIf
Else
   If !File(cArquivo)
      Return .F.
   EndIf
EndIf
dbUseArea(.t.,__cRDD,cArquivo,'ARQ1')
If NetErr()
   Info("Falha na abertura da tabela "+cArquivo) //
   Return .F.
EndIf
aStru := ARQ1->(DbStruct())
nQtdeDB:= Fcount()
ARQ1->(dbCloseArea())

DbSelectArea('SX3')
nQtdeSx := 0
While ! Eof() .and. SX3->X3_ARQUIVO == cAlias
	nLoc := aScan(aNoSX3,{|x|	x[1] == (X3_ARQUIVO+X3_CAMPO)})  //by Erike
   IF X3_CONTEXT <>'V' .AND. nLoc == 0
     aadd(aStruSX3,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
     nQtdeSx++
   Endif
   DbSkip()
End
If nQtdeSX # nQtdeDB
   Return .T.
EndIf
For nI := 1 to Len(aStruSX3)
   nLoc = 0
   nLoc := aScan(aStru,{|x|alltrim(x[1]) == alltrim(aStruSX3[nI,1])})
   If nLoc # 0
      If aStruSX3[nI,2] # aStru[nLoc,2] .or.;
         (aStruSX3[nI,3] # aStru[nLoc,3] .and. aStruSX3[nI,2]<>'M') .or.;
         (aStruSX3[nI,4] # aStru[nLoc,4] .and. aStruSX3[nI,2]=='N')
         lDif := .t.
      EndIf
   Else
      lDif := .T.
   EndIf
Next
Return lDif

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ Ajusta   ³ Autor ³ Eduardo Motta         ³ Data ³ 03/12/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Ajusta tabela deixando a estrutura conforme definido no SX3³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ChkStru                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ajusta(cArquivo,aStruSX3)
Local nPos    		:=0
Local cCaminho		:=''
Local cNomeArq		:=''
Local cNomeAlias	:=''    
Local cArqTemp		:=''
Local cExt			:=''

If (__cRDD=="DBFCDX") .or. (__cRDD=="DBFCDXAX")
	cExt := ".dbf"
ElseIf (__cRDD=="CTREECDX")
   cExt := ".dtc"
EndIf

//Descubrir o cCaminho,cNomeArq e cNomeAlias
nPos 		:= RAT('\',cArquivo)
cCaminho := Left(cArquivo,nPos)
cNomeArq := cArquivo
While .t.
   nPos := RAT('\',cNomeArq)
   If Empty(nPos)
      exit
   EndIf
   cNomeArq:=Subs(cNomeArq,nPos+1)
End
nPos := AT('.',cNomeArq)
If ! Empty(nPos)
   cNomeArq:=Subs(cNomeArq,1,nPos-1)
EndIf
      
cNomeAlias := Left(cNomeArq,5)+"BKP"
		
If __cRDD == "TOPCONN"
   MSErase(cNomeAlias,,__cRDD)
   cArqTemp := cNomeAlias
   cArquivo := cNomeArq
Else                                
   cArqTemp	:= cCaminho+cNomeAlias	
   cArquivo	:= RetArq(__cRDD,cArquivo,.t.)                        		   
   MSErase(cCaminho+cNomeAlias+cExt,,__cRDD)
   If File(cCaminho+cNomeAlias+".fpt")
      FErase(cCaminho+cNomeAlias+".fpt")
   EndIf
EndIf

      
Info(' - Criando backup de '+cArquivo+' para '+cArqTemp)
oAtuStru2:cCaption	:=	'Criando backup de '+cArquivo+ ' para '+cArqTemp
oAtuStru2:Refresh()
	   
		
If __cRDD == "TOPCONN" .or. __cRDD == "BTVCDX"
   MSRename(cArquivo,cArqTemp+GetDBExtension())
Else
   __CopyFile(cArquivo,cArqTemp+cExt)
   FERASE(cArquivo)
EndIf
       
           
oAtuStru3:cCaption	:='Excluindo o arquivo '+cArquivo+' ...'
oAtuStru3:Refresh()

Info(' - Excluindo o arquivo '+cArquivo)

//ATUALIZANDO TABELAS
Info(' - Criando o arquivo oficial com a nova estrutura ->'+cArquivo)
MSCreate(cArquivo,aStruSX3,__cRDD)		
						
While .T.
   If MsOpEndbf( .T.,__cRDD, cArquivo, "CurArqAtu",.F., .F.,.T. )
      Exit
   EndIf  
   Sleep(10)
EndDo

Info(' - Transferindo o '+cArqTemp+cExt+' para ->'+cArquivo)
oAtuStru3:cCaption	:='Transferindo dados: '+cArqTemp+cExt+' p/ '+cArquivo + ' ...'
oAtuStru3:Refresh()
		 
DbSelectArea("CurArqAtu")	 	
MSAppEnd(cArquivo,cArqTemp+cExt)
CurArqAtu->(DbCloseArea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ GetFiles ³ Autor ³ Eduardo Motta         ³ Data ³ 03/12/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Busca nome das tabelas no SX2.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ChkStru                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetFiles(aFiles)
Local nI

DbSelectArea("SX2")
DbSetOrder(1)
SX2->(DbClearFilter())
For nI := 1 to len(aChkStru)
   DbSeek(aChkStru[nI])
   cFile := AllTrim(X2_PATH)+RetArq(__cRDD,AllTrim(X2_ARQUIVO),.t.)
   AADD(aFiles,{X2_ARQUIVO,cFile,X2_CHAVE})
Next

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ChkExc    ³ Autor ³ Sandro    	  	 	     ³Data  ³ 06/12/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Abre SM0 em modo exclusivo           						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ AutoGrLog [ cExpr ] )																																	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parƒmetros³                                          				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ChkExc(lmodo)
static cEmpresa
If ! lModo
   SM0->(dbCloseArea())
	OpenSM0(cEmpresa)
	CheckAut(cEmpresa)
   Return .f.
EndIf
dbSelectArea("SM0")
cEmpresa:= SM0->M0_CODIGO
SM0->(dbCloseArea())
MsOpenDbf( .T. ,__LocalDriver,"SIGAMAT.EMP", "SM0",.F.,.T.)
While !Used()
	MsOpenDbf( .T. ,__LocalDriver,"SIGAMAT.EMP", "SM0",.F.,.T.)
	If Used()
		Exit
	EndIf
   If ! MsgYesNo("Arquivo de Empresas esta sendo usado. Feche todos os Modulos do Siga e"+chr(13)+; //
               "tecle ok para continuar?","Atualizacao") //###
		DbCloseAll()
		Return .f.
	EndIf
EndDo

If !File("SIGAMAT.IND")
	INDEX ON M0_CODIGO+M0_CODFIL TO SIGAMAT.IND
Else
	DbSetIndex("SIGAMAT.IND")
EndIf

Return .t.

Static Function MsLogin()
Local oBmp, oDlgLogin,oCbxEmp,  oBtnOk, oBtnCancel, oFont 
Local cUserName		:= Padr("Administrador",25) //"Administrador"
Local cSenha		:= Space(20)
Local cEmpAtu			:= ""
Local lOk				:= .F.
Local aCbxEmp			:= {}
Local oProj
Local aDir                   

cProj:=""	

oFont := TFont():New('Arial',, -11, .T., .T.)

SM0->(DbGotop())
While ! SM0->(Eof())
	Aadd(aCbxEmp,SM0->M0_CODIGO+'/'+SM0->M0_CODFIL+' - '+SM0->M0_NOME+' / '+SM0->M0_FILIAL)
	SM0->(DbSkip())
EndDo

DEFINE MSDIALOG oDlgLogin FROM  0,0 TO 220,380  Pixel TITLE OemToAnsi("Login ")
	oDlgLogin:lEscClose := .F.
	@ 000,000 BITMAP oBmp RESNAME "LOGIN" oF oDlgLogin SIZE 95,oDlgLogin:nBottom  NOBORDER WHEN .F. PIXEL
	@ 010,050 Say "Selecione a Empresa:" PIXEL of oDlgLogin  FONT oFont //
	@ 018,050 MSCOMBOBOX oCbxEmp VAR cEmpAtu ITEMS aCbxEmp SIZE 130,10 OF oDlgLogin PIXEL
	TButton():New( 090,100,"&Ok", oDlgLogin, {||  lOk := .T.  ,__cEmpFil :=Left(cEmpAtu,5),oDlgLogin:End() 	},38, 14,,, .F., .t., .F.,, .F.,,, .F. ) //
	TButton():New( 090,140,"&Cancelar", oDlgLogin, {|| lOk := .F. , oDlgLogin:End() }, 38, 14,,, .F., .t., .F.,, .F.,,, .F. ) //
ACTIVATE MSDIALOG oDlgLogin CENTERED
Return lOk


Static Function FindSix(cIndice,cNickName)
DbSeek(cIndice)
While ! Eof() .and. cIndice == INDICE
   If cNickName == NICKNAME
   	Return .t.
   EndIf
	DbSkip()
End	    
DbGoBottom()
DbSkip()
Return .f.

Static Function RetUltOrdem(cIndice)
Local cOrdem := "0" 
DbSeek(cIndice)
While ! Eof() .and. cIndice == INDICE
	cOrdem :=ORDEM
	DbSkip()
End	
Return Soma1(cOrdem,1)
