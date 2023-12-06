#Include "Protheus.ch"
#Include "ApWizard.ch"

/* Exemplo de teste para ser executado por ponto de entrada
User Function Tst10WZ()
	U_ACDIWZ(1,{'090504001','UNI','1     ','1 '})
Return
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณSTFSCE12  บAutor  ณMicrosiga           บ Data ณ  02/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta para o LOTEX                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFSCE12(nOrigem,aParIni)
Local oWizard
Local oPanel
Local nTam

Local oOrigem
Local aOrigem := {}

Local aparLT	:=	{	{1,"Lote",Space(10),"","","PA0FSW",If(aParIni==NIL,".T.",".F."),60,.F.} }
Local aRetLT   :=	{Space(10)}

Local aparNF	:=	{	{1,"Nota Fiscal"		,Space(9),"","" ,"CBW"	,If(aParIni==NIL,".T.",".F."),0,.F.},;
							{1,"Serie"				,Space(3) ,"","",			,If(aParIni==NIL,".T.",".F."),0,.F.},;
					  		{1,"Fornecedor"		,Space(6) ,"","","SA2"	,If(aParIni==NIL,".T.",".F."),0,.F.},;
							{1,"Loja"				,Space(2) ,"","",			,If(aParIni==NIL,".T.",".F."),0,.F.}}
Local aRetNF	:= {Space(9),Space(3),Space(6),Space(2)}

Local aParOP	:=	{	{1,"OP"				,Space(13),"","","SC2"	,If(aParIni==NIL,".T.",".F."),0,.F.}}
Local aRetOP   :=	{Space(13)}
                                                
Local aParROP	:=	{	{1,"Req. de OP"	,Space(13),"","","SC2"	,If(aParIni==NIL,".T.",".F."),0,.F.}}
Local aRetROP  :=	{Space(13)}

Local aParPR	:=	{	{1,"Pedido"			,Space(6),"","","SC5"	,If(aParIni==NIL,".T.",".F."),0,.F.}}
Local aRetPR   :=	{Space(6)}

Local aParVol	:=	{	{1,"Volume"			,Space(10),"","",""	,If(aParIni==NIL,".T.",".F."),0,.F.}}
Local aRetVol  :=	{Space(10)}                                 

Local aParam 	:= {} 
Local aRetPE	:= {}

Local nx:= 1

Private oLbx
Private cCondSF1 := ' 1234567890'  // variavel utilizada na consulta sxb CBW, favor nao remover esta linha
Private aLbx:={{Space(15),Space(10),Space(03),Space(20),Space(08)}}
Private cOpcSel:=""  // variavel disponivel para infomar a opcao de origem selecionada

DEFAULT nOrigem := 1

aParam:={	{"Lote"								,aParLT,aRetLT		,{|| 	AWzVLT()}}	,;
				{"Nota Fiscal de Entrada"		,aParNF,aRetNF		,{|| 	AWzVNFE()}}	,;
				{"Ordem de Producao"				,aParOP,aRetOP		,{|| 	AWzVOP()}}	,;
				{"Req. Ordem de Producao"		,aParROP,aRetROP	,{|| 	AWzVROP()}}	,;
				{"Pedido"							,aParPR,aRetPR		,{|| 	AWzVPED()}} ,; 
				{"Volume"							,aParVol,aRetVol	,{|| 	AWzVVol()}}}

// carrega parametros vindo da funcao pai
If aParIni <> NIL
	For nX := 1 to len(aParIni)
		nTam := len( aParam[nOrigem,3,nX ] )
		aParam[nOrigem,3,nX ] := Padr(aParIni[nX],nTam )
	Next             
EndIf 

For nx:= 1 to len(aParam)
	aadd(aOrigem,aParam[nX,1])
Next

DEFINE WIZARD oWizard TITLE "Consulta de Lotes Especํficos" ;
       HEADER "Consulta dos Lotes Especํficos" ;
       MESSAGE "";
       TEXT "Esta rotina tem por objetivo realizar a consulta dos lotes especํficos Steck" ;
       NEXT {|| .T.} ;
		 FINISH {|| .T. } ;
       PANEL

   // Primeira etapa
   CREATE PANEL oWizard ;
          HEADER "Informe a origem das informa็๕es para consulta" ;
          MESSAGE "" ;
          BACK {|| .T. } ;
 	       NEXT {|| nc:= 0,aeval(aParam,{|| &("oP"+str(++nc,1)):Hide()} ),&("oP"+str(nOrigem,1)+":Show()"),cOpcSel:= aParam[nOrigem,1],A12WZIniPar(nOrigem,aParIni,aParam) ,.T. } ;
          FINISH {|| .F. } ;
          PANEL
   
   oPanel := oWizard:GetPanel(2)  
   
   oOrigem := TRadMenu():New(30,10,aOrigem,BSetGet(nOrigem),oPanel,,,,,,,,100,8,,,,.T.)
   If aParIni <> NIL
	   oOrigem:Disable()
	EndIf	   
   
   // Segunda etapa
   CREATE PANEL oWizard ;
          HEADER "Preencha as solicita็๕es abaixo para a sele็ใo" ;
          MESSAGE "" ;
          BACK {|| .T. } ;
          NEXT {|| Eval(aParam[nOrigem,4]) } ;
          FINISH {|| .F. } ;
          PANEL                                  

   oPanel := oWizard:GetPanel(3)
	For nx:= 1 to len(aParam)
  		&("oP"+str(nx,1)) := TPanel():New( 028, 072, ,oPanel, , , , , , 120, 20, .F.,.T. )
  		&("oP"+str(nx,1)):align:= CONTROL_ALIGN_ALLCLIENT       
		ParamBox(aParam[nX,2],"Parโmetros...",aParam[nX,3],,,,,,&("oP"+str(nx,1)))
		&("oP"+str(nx,1)):Hide()
	Next

   CREATE PANEL oWizard ;
          HEADER "Consulta - Lotes utilizados" ;
          MESSAGE "" ;
          BACK {|| .T. } ;
          FINISH {|| .T. } ;
          PANEL
   oPanel := oWizard:GetPanel(4)
   ListBoxMar(oPanel)

ACTIVATE WIZARD oWizard CENTERED
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณA12WZIniParบAutor  ณMicrosiga          บ Data ณ  02/03/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInicializador dos parametros para a consulta                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function A12WZIniPar(nOrigem, aParIni,aParam)
Local nX
If aParIni <> NIL
	For nx:= 1 to len(aParIni)
		&( "MV_PAR" + StrZero( nX, 2, 0 ) ) := aParIni[ nX ]
	Next
EndIf
         
For nx:= 1 to len(aParam[nOrigem,3])
	&( "MV_PAR" + StrZero( nX, 2, 0 ) ) := aParam[nOrigem,3,nX ]
Next                       

Return .t.                                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณAWzVNFE    บAutor  ณMicrosiga          บ Data ณ  02/03/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega o ListBox Nota Fiscal para apresentar a consulta    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AWzVNFE()
Local cTipDoc	:= "SD1"
Local	cNota 	:= Padr(MV_PAR01,9)
Local	cSerie	:= Padr(MV_PAR02,3)
Local	cForn 	:= Padr(MV_PAR03,6)
Local cLoja 	:= Padr(MV_PAR04,2)

If Empty(cNota+cSerie+cForn+cLoja)
  	MsgAlert(" Necessario informar a nota e o fornecedor. ")
 	Return .F.
EndIf
SF1->(DbSetOrder(1))
If ! SF1->(DbSeek(xFilial('SF1')+cNota+cSerie+cForn+cLoja))
  	MsgAlert(" Nota fiscal nใo encontrada. ")
  	Return .F.
EndIf       

aLbx:={}
PA0->(DbSetOrder(2))
PA0->(dbSeek(xFilial('PA0')+cTipDoc+cNota+cSerie+cForn+cLoja)	)
While PA0->(!EOF()  .and. PA0_FILIAL+PA0_TIPDOC+PA0_DOC == xFilial('PA0')+cTipDoc+cNota+cSerie+cForn+cLoja)
   adLbx(aLbx)
	PA0->(dbSkip()	)
End     
oLbx:SetArray( aLbx )
oLbx:bLine := {|| {aLbx[oLbx:nAt,1],aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5]}}
oLbx:Refresh()
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณAWzVLT     บAutor  ณMicrosiga          บ Data ณ  02/03/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega o ListBox Lote para apresentar a consulta           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AWzVLT()
Local cTipDoc	:= "PA0"
Local cLote		:= Padr(MV_PAR01,10)

If Empty(cLote)
  	MsgAlert(" Necessario informar o Lote. ")
 	Return .F.
EndIf

aLbx:={}
PA0->(DbSetOrder(3))
PA0->(dbSeek(xFilial('PA0')+cLote)	)
While PA0->(!EOF() .and. PA0_FILIAL+PA0_LOTEX == xFilial('PA0')+cLote)
	adLbx(aLbx)
	PA0->(dbSkip()	)
End     
oLbx:SetArray( aLbx )
oLbx:bLine := {|| {aLbx[oLbx:nAt,1],aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5]}}
oLbx:Refresh()
Return .t.
                     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณAWzVROP    บAutor  ณMicrosiga          บ Data ณ  02/03/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega o ListBox Req. OP para apresentar a consulta        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AWzVROP()
Local cTipDoc	:= "SD4"
Local	cOp		:= Padr(MV_PAR01,13) 

If Empty(cOP)
  	MsgAlert(" Necessario informar o codigo do ordem de produ็ใo. ")
  	Return .F.
EndIf

SC2->(DbSetOrder(1))
If !SC2->(DbSeek(xFilial('SC2')+cOP))
  	MsgAlert(" Ordem de Produ็ใo nใo encontrado. ")
 	Return .F.
EndIf                 

//-- Tirar duvida com Sandro a respeito do Indice a ser criado PA0 - Requisicao de Ordem de Producao
aLbx:={}
PA0->(DbSetOrder(2))
PA0->(dbSeek(xFilial('PA0')+cTipDoc+cOp))
While PA0->(!EOF() .AND. PA0_FILIAL+PA0_TIPDOC+Left(PA0_DOC,13) == xFilial('PA0')+cTipDoc+cOp)
	adLbx(aLbx)
	PA0->(dbSkip()	)
End     
oLbx:SetArray( aLbx )
oLbx:bLine := {|| {aLbx[oLbx:nAt,1],aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5]}}
oLbx:Refresh()
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณAWzVOP     บAutor  ณMicrosiga          บ Data ณ  02/03/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega o ListBox Ordem Producao para apresentar a consulta บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AWzVOP()
Local cTipDoc	:= "SC2"
Local	cOp		:= Padr(MV_PAR01,13) 

If Empty(cOP)
  	MsgAlert(" Necessario informar o codigo do ordem de produ็ใo. ")
  	Return .F.
EndIf

SC2->(DbSetOrder(1))
If ! SC2->(DbSeek(xFilial('SC2')+cOP))
  	MsgAlert(" Ordem de Produ็ใo nใo encontrado. ")
 	Return .F.
EndIf                 

aLbx:={}
PA0->(DbSetOrder(2))
PA0->(dbSeek(xFilial('PA0')+cTipDoc+cOp))
While PA0->(!EOF() .and. PA0_FILIAL+PA0_TIPDOC+Left(PA0_DOC,13) == xFilial('PA0')+cTipDoc+cOp)
	adLbx(aLbx)
	PA0->(dbSkip()	)
End     
oLbx:SetArray( aLbx )
oLbx:bLine := {|| {aLbx[oLbx:nAt,1],aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5]}}
oLbx:Refresh()
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณAWzVPED    บAutor  ณMicrosiga          บ Data ณ  02/03/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega o ListBox para apresentar a consulta                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AWzVPED()
Local cTipDoc	:= "SC5"
Local	cPedido	:= Padr(MV_PAR01,6)

If Empty(cPedido)
  	MsgAlert(" Necessario informar o Pedido. ")
  	Return .F.
EndIf
                                   
//-- Tirar duvida com Sandro a respeito do Indice a ser criado PA0 - Pedido
SC5->(DbSetOrder(1))
If ! SC5->(DbSeek(xFilial('SC5')+cPedido))
  	MsgAlert(" Pedido nao encontrado. ")
 	Return .F.
EndIf                 

aLbx:={}
PA0->(DbSetOrder(2))
PA0->(dbSeek(xFilial('PA0')+cTipDoc+cPedido))
While PA0->(!EOF() .and. PA0_FILIAL+PA0_TIPDOC+Left(PA0->PA0_DOC,6) == xFilial('PA0')+cTipDoc+cPedido)
	adLbx(aLbx)
	PA0->(dbSkip()	)
End     
oLbx:SetArray( aLbx )
oLbx:bLine := {|| {aLbx[oLbx:nAt,1],aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5]}}
oLbx:Refresh()
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณAWzVVol    บAutor  ณMicrosiga          บ Data ณ  02/03/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega o ListBox com os volumes                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AWzVVol()
Local cTipDoc	:= "CB9"
Local	cVolume		:= Padr(MV_PAR01,10) 

If Empty(cVolume)
  	MsgAlert(" Necessario informar o codigo do volume. ")
  	Return .F.
EndIf

CB6->(DbSetOrder(1))
If ! CB6->(DbSeek(xFilial('CB6')+cVolume))
  	MsgAlert(" Volume nใo encontrado. ")
 	Return .F.
EndIf                 

//-- Tirar duvida com Sandro a respeito do Indice a ser criado PA0 - Requisicao de Ordem de Producao
aLbx:={}
PA0->(DbSetOrder(2))
PA0->(dbSeek(xFilial('PA0')+cTipDoc+cVolume))
While PA0->(!EOF() .AND. PA0_FILIAL+PA0_TIPDOC+Left(PA0_DOC,10) == xFilial('PA0')+cTipDoc+cVolume)
	adLbx(aLbx)
	PA0->(dbSkip()	)
End     
oLbx:SetArray( aLbx )
oLbx:bLine := {|| {aLbx[oLbx:nAt,1],aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5]}}
oLbx:Refresh()
Return .t.


Static Function AdLbx(aLbx)
Local aAux := Array(5)                      

aAux[1] := PA0->PA0_LOTEX
aAux[2] := PA0->PA0_PROD  
aAux[3] := Transform(PA0->PA0_QTDE,PesqPict("PA0","PA0_QTDE"))                                                                
If PA0->PA0_TIPDOC == "SD1"
	aAux[4] :="N.Fiscal Entrada:"+Stuff(Left(PA0->PA0_DOC,12),10,0,"-")+" Fornec: "+Stuff(Subs(PA0->PA0_DOC,13),7,0,"-")
ElseIf PA0->PA0_TIPDOC == "SC2" 
	aAux[4] :="Produ็ใo OP:"+Alltrim(PA0->PA0_DOC)
ElseIf PA0->PA0_TIPDOC == "SD4" 
	aAux[4] :="Requisi็ใo OP:"+Alltrim(PA0->PA0_DOC)
ElseIf PA0->PA0_TIPDOC == "SC5"
	aAux[4] :="Pedido:"+Alltrim(PA0->PA0_DOC)+ " Ordem Separa็ใo:"+PA0->PA0_ORDSEP 
ElseIf PA0->PA0_TIPDOC == "CB9"
	aAux[4] :="Volume:"+Alltrim(PA0->PA0_DOC)+ " Ord.Sep:"+PA0->PA0_ORDSEP 
EndIf  
aAux[5] := PA0->PA0_DTSEP
aadd(aLbx,aclone(aAux))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณListBoxMar บAutor  ณMicrosiga          บ Data ณ  02/03/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMontagem da tela principal do ListBox                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ListBoxMar(oDlg)
Local oChk1
Local oChk2
Local lChk1 := .F.
Local lChk2 := .F.                                             
Local oP
Local cCabec:="Lote       Produto         Qtde. Referencia Obs                                                Data Movimento"

@ 10,10 LISTBOX oLbx FIELDS HEADER "Lote","Produto","Qdte. Refer๊ncia","Observa็ใo","Data Movimento"  SIZE 230,095 OF oDlg PIXEL

oLbx:SetArray( aLbx )
oLbx:bLine := {|| {aLbx[oLbx:nAt,1],aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5]}}
oLbx:align:= CONTROL_ALIGN_ALLCLIENT

oP := TPanel():New( 028, 072, ,oDlg, , , , , , 120, 20, .F.,.T. )
oP:align:= CONTROL_ALIGN_BOTTOM

@ 5,010  BUTTON "Imprimir"	 SIZE 55,11 ACTION ImpLoteX(cCabec,aLbx) OF oP PIXEL

Return        
        

Static Function ImpLoteX(cCabec,aDados)
Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
Local cDesc3		:= "na tela anterior"
Local cPict			:= ""
Local titulo		:= "Listagem de Lote Especifico"
Local nLin			:= 80
Local Cabec1		:= cCabec
Local Cabec2		:= ""
Local imprime		:= .T.
Local aOrd			:= {}
Private lEnd		:= .F.
Private lAbortPrint	:= .F.
Private limite		:= 180
Private tamanho	:= "M"
Private nTipo		:= 18
Private aReturn	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey	:= 0
Private cbtxt		:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag		:= 01
Private wnrel		:= "STFSCE12"
Private cString 	:= ""

wnrel := SetPrint(cString,wnrel,"FSCE12",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,aDados) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  10/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,aDados)
Local nI

For nI:=1 to len(aDados)
	
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
	
   If nLin > 65
      Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
      nLin := 08
   Endif

	@ nLin ,000 PSAY aDados[nI,1]
	@ nLin ,011 PSAY aDados[nI,2]
	@ nLin ,029 PSAY aDados[nI,3]
	@ nLin ,044 PSAY aDados[nI,4]
	@ nLin ,095 PSAY aDados[nI,5]

   nLin := nLin + 1
Next


SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
