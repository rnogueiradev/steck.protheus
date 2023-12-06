#INCLUDE "RWMAKE.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA103OPC  ºAutor  ³Microsiga           º Data ³  12/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PCMCMA01()
_careap := getarea()
dbselectarea("SM0")
_carea := getarea()
DBGOTOP()
_cordem := "  "
_afiliais := {}

DO WHILE  !EOF() // .AND. SM0->M0_CODIGO == "01" .and.
	aadd(_afiliais,{SM0->M0_CODIGO,SM0->M0_CODFIL,Trim(SM0->M0_NOME)+'/'+Trim(SM0->M0_FILIAL),SM0->M0_CGC})
	DBSKIP()
ENDDO

restarea(_carea)

nat 	:= 1
_cNota 	:= space(9)

@ 83 ,184 To 353,600 Dialog oDlg Title OemToAnsi("Notas de Transferencia")

@ 5,05 Say "NF Origem" Size 65,10 PIXEL
@ 5,70 GET _cNota SIZE 30,10 PICTURE "@!" PIXEL

@ 15,05 Say "Filial de Origem" Size 65,10 PIXEL

_atit_cab1:= 	{"Cod.Empresa","Cod.filial","Empresa\Filial"}
_atam_cab1:= 	{10,10,105}
oListBox2 := TWBrowse():New( 023,5,197,59,,_atit_cab1,_atam_cab1,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox2:SetArray(_afiliais)
oListBox2:bLine := { || _afiliais[oListBox2:nAT]}

@ 090,095 BmpButton Type 1  ACTION ( MsgRun("Aguarde carregando NF " + _cNota,"Aguarde",{ ||CarregaNF() }), oDlg:End() )
@ 090,145 BmpButton Type 2 Action Close(oDlg)

Activate Dialog oDlg

RestArea(_careap)

Dbselectarea("SF1")
Dbsetorder(1)
Dbseek(xFilial("SF1")+_cNota)

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CarregaNf ºAutor  ³Everaldo Gallo         º Data ³  22/09/04º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Carga dos dados da Nota Fiscal selecionada                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CarregaNf


Local aAreaBKP   := GetArea()
Local aSF1       := {}
Local aSD1       := {}
Local nRecnoSM0  := SM0->(RecNo())
Local cPedCom	 := ""
Local cTes		 := ""
Local cEmpBKP	 := SM0->M0_CODIGO
Local cFilBKP	 := SM0->M0_CODFIL
Local aItens     := {}
Local aDestino	 := {"",""}
Local cCNPJOri   := AllTrim(_afiliais[oListBox2:nAT,4])
Local cErros     := ""
Local x			 := 0

//Busca o codigo da filial do cliente de destino

dbSelectArea("SA2")
SA2->(dbSetOrder(3))
SA2->(dbSeek(xFilial("SA2")+cCNPJOri))

//Avalia se houve itens de transferencia
cQuery    := ""
cQuery    += " SELECT   * "
cQuery    += " FROM     SF2"+_afiliais[oListBox2:nAT,1]+"0 SF2, SD2"+_afiliais[oListBox2:nAT,1]+"0 SD2"
cQuery    += " WHERE    F2_DOC      = '"+_cNota+"'"
cQuery    += " AND      F2_FILIAL   = '"+_afiliais[oListBox2:nAT,2]+"'"
cQuery    += " AND      F2_FILIAL   =  D2_FILIAL "
cQuery    += " AND      F2_DOC      =  D2_DOC    "
cQuery    += " AND      F2_SERIE    =  D2_SERIE  "
cQuery    += "          AND SF2.D_E_L_E_T_ <> '*' "
cQuery    += "          AND SD2.D_E_L_E_T_ <> '*' "

TCQUERY cQuery NEW ALIAS "TRB"
TcSetField('TRB'  ,'F2_EMISSAO' 	,'D',08,0)
TcSetField('TRB'  ,'D2_QUANT' 		,'N',18,4)
TcSetField('TRB'  ,'D2_PRCVEN' 		,'N',18,4)
TcSetField('TRB'  ,'D2_TOTAL' 		,'N',18,4)

DbSelectArea("TRB")
_nRec := 0
DbEval({|| _nRec++  })

If _nRec == 0
	MsgStop("Nota nao encontrada na filial de Destino !!!")
Else
	
	//Identifica o Fornecedor para Pedido de Compra
	dbSelectArea("SA2")
	SA2->(dbSetOrder(3))
	If !SA2->(dbSeek(xFilial("SA2")+cCNPJOri  ))
		MsgStop("Filial de Origem Nao encontrada como Fornecedor nesta filial !!!")		
		Return
	EndIf
	
	DbSelectArea("TRB")
	DbGotop()                
	
	While TRB->(!Eof())
		
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+TRB->D2_COD))
		
		aItens := {}
		
		AAdd(aItens,{"D1_DOC"  	    ,TRB->F2_DOC									,NIL})
		AAdd(aItens,{"D1_ITEM" 	    ,StrZero(Len(aSD1)+1,TAMSX3("D1_ITEM")[1])		,NIL})
		AAdd(aItens,{"D1_COD" 		,TRB->D2_COD									,NIL})
		AAdd(aItens,{"D1_UM" 		,SB1->B1_UM										,NIL})
		AAdd(aItens,{"D1_QUANT" 	,TRB->D2_QUANT									,NIL})
		AAdd(aItens,{"D1_VUNIT" 	,TRB->D2_PRCVEN									,NIL})
		AAdd(aItens,{"D1_TOTAL" 	,TRB->D2_TOTAL									,NIL})
		AAdd(aItens,{"D1_FORNECE" 	,SA2->A2_COD									,NIL})
		AAdd(aItens,{"D1_LOJA"		,SA2->A2_LOJA									,NIL})
		
		AAdd(aSD1,aItens)
		
		TRB->(dbSkip())
		
	EndDo
	
	If Len(aSD1) > 0
	
		DbSelectArea("TRB")
		DbGotop()                
	  
		aSF1 := {	{"F1_TIPO"		,"N"		 		,NIL},;
		{"F1_FORMUL"	,"N"				,NIL},;
		{"F1_DOC"		,TRB->F2_DOC		,NIL},;
		{"F1_SERIE"		,TRB->F2_SERIE		,NIL},;
		{"F1_EMISSAO"	,TRB->F2_EMISSAO	,NIL},;
		{"F1_FORNECE"	,SA2->A2_COD   		,NIL},;
		{"F1_LOJA"	    ,SA2->A2_LOJA  		,NIL},;
		{"F1_ESPECIE"	,"SPED"    			,NIL},;
		{"F1_FILIAL" 	,XFILIAL("SF1")		,NIL},;
		{"CTIPO"     	,"N" 				,NIL} }
		
		//Gera a NF de Entrada
		lMsErroAuto := .F.
		
		MSExecAuto({|x,y,z| MATA140(x,y,z)},aSF1,aSD1,3)
		
		If lMsErroAuto
			MostraErro()
 		Else
			MsgAlert("Pre-Nota gerada com sucesso!")
		EndIf
	Else
	    MsgAlert("Itens de NF nao encontrados")
	EndIf
	
EndIf
DbSelectarea("TRB")
DbCloseArea("TRB")

RestArea(aAreaBKP)

Return

