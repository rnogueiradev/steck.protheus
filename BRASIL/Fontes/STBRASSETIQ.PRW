#include "Protheus.ch"
#include "RwMake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#DEFINE CR    chr(13)+chr(10)

/*====================================================================================\
|Programa  | STBRASSETIQ    | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descrição | Gera P.V. de Transferencia entre Steck 01 para Steck 02 de acordo com o  |
|          | parametros de endereços							                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STBRASSETIQ                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function STBRASSETIQ()
*---------------------------------------------------*
Private cPerg       := 'TRANSIBL'
Private cTime       := Time()
Private cHora       := SUBSTR(cTime, 1, 2)
Private cMinutos    := SUBSTR(cTime, 4, 2)
Private cSegundos   := SUBSTR(cTime, 7, 2)
Private cAliasLif   := cPerg+cHora+ cMinutos+cSegundos
Private cAliasPed   := cPerg+cHora+ cMinutos+cSegundos
Private cAliasSal   := cPerg+cHora+ cMinutos+cSegundos
Private aSize    	:= MsAdvSize(.F.)
Private lMark   	:=  .F.
Private aVetor 		:= {}
Private aSbfLoc		:= {}
Private lSaida  	:= .F.
Private aCpoEnch	:= {}
Private nOpcA		:= 0
Private oOk	   		:= LoadBitmap( GetResources(), "LBOK" )
Private oNo	   		:= LoadBitmap( GetResources(), "LBNO" )
Private oChk
Private lRetorno    := .F.
Private lChk	 	:= .F.
Private aVetor	 	:= {}
Private oLbx
Private oLbxz
Private lInverte 	:= .F.
Private nContLin 	:= 0
Private lLote    	:= .F.
Private oDlg
Private oDlgx
Private oList
Private _nQtd   	:= 0
Private  _nMeta 	:= 0
Private oVlrSelec
Private nVlrSelec 	:= 0
Private oMarcAll
Private lMarcAll    	:= .T.
Private oMarked	 := LoadBitmap(GetResources(),'LBOK')
Private oNoMarked:= LoadBitmap(GetResources(),'LBNO')
Private oMeta
Private oPesc
Private aTam     := {}
Private cPesc    := ''
Private _cSerIbl := IIF(CFILANT='01','001','001')
Private bFiltraBrw
Private AFILBRW    := {}
Private _cEndeStxx  := 'Endereços(SBF): '
Private _xCodTran       := GetMv("ST_TRANBRA",,'000012')
aTam   := TamSX3("F2_DOC")
cPesc  := space(aTam[1])
cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
aFilBrw		:=	{'SF2',cCondicao}


Processa({|| 	STQUERY()},'Selecionando Notas')

Processa({|| 	CompMemory()},'Compondo Notas')

If len(aVetor) > 0
	MonTaSlec()    // monta a tela
Else
	MsgInfo("Não Existe Notas Disponiveis !!!!!")
EndIf

Return()

/*====================================================================================\
|Programa  | STQUERY          | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |   Executa select mediante os parametros                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STQUERY                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function STQUERY()
*-----------------------------*
Local cQuery     := ''

DbSelectArea("SF2")
SBF->(DbSetOrder(1))


cQuery := " SELECT
cQuery += " F2_DOC,
cQuery += " F2_SERIE,
cQuery += "  SUBSTR( F2_EMISSAO,7,2)||'/'|| SUBSTR( F2_EMISSAO,5,2)||'/'|| SUBSTR( F2_EMISSAO,1,4) 
cQuery += ' "F2_EMISSAO" ,  F2_XCODROM  ,
cQuery += " F2_VOLUME1
cQuery += " FROM "+RetSqlName('SF2')+" SF2 "
cQuery += " WHERE D_E_L_E_T_ = ' '
cQuery += " AND F2_TRANSP =  '"+_xCodTran+"'
cQuery += " AND F2_EMISSAO >= '20130901'
cQuery += " AND F2_XCODROM <> ' '
cQuery += " ORDER BY F2_DOC DESC




cQuery := ChangeQuery(cQuery)

DbCommitAll()
If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif,.T.,.T.)


Return()


/*====================================================================================\
|Programa  | CompMemory       | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |    crio o avetor                                                         |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | CompMemory                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function CompMemory()
*-----------------------------*

dbSelectArea(cAliasLif)
(cAliasLif)->(dbGoTop())
ProcRegua(RecCount()) // Numero de registros a processar

While !(cAliasLif)->(Eof())
	_nQtd++
	IncProc()
	aadd(aVetor ,{ lMark ,; //01
	(cAliasLif)->F2_DOC		 ,;	//02   DOC
	(cAliasLif)->F2_SERIE		 ,;	//03   SERIE
	(cAliasLif)->F2_EMISSAO		 ,;	//04   EMISSAO
	(cAliasLif)->F2_VOLUME1		 ,;	//05   VOLUME
	(cAliasLif)->F2_XCODROM		 ,;	//06   ROMANEIO  	 
	})
	
	(cAliasLif)->(dbSkip())
End


Return()

/*====================================================================================\
|Programa  | MonTaSlec        | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MonTaSlec                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function MonTaSlec()
*-----------------------------*

Local aButtons := {{"LBTIK",{|| PedStx()} ,"Gerar Etiqueta"}}

Do While !lSaida
	nOpcao := 0
	
	Define msDialog odlg title "Etiqueta" From 0,0 To aSize[6]-15,aSize[5]-15  PIXEL OF oMainWnd //from 178,181 to 590,1100 pixel
	
	cLinOk    :="AllwaysTrue()"
	cTudoOk   :="AllwaysTrue()"//'STxGRV()'
	aCpoEnchoice:={'NOUSER'}
	aAltEnchoice := {}
	
	Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
	bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
	Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0
	
	@ 010,010 say "Quantidade( Notas ):"   Of odlg Pixel
	@ 010,080 msget  _nQtd picture "@E 999,999" when .f. size 55,013  Of odlg Pixel
	@ 025,010 say "Selecionados:"   Of odlg Pixel
	@ 025,080 msget  oVlrSelec Var _nMeta picture "@E 999,999" when .f. size 55,013 	 Of odlg Pixel
	
	@ 025,200 say "Pesquisar:"   Of odlg Pixel
	@ 025,240 msget  oPesc Var cPesc   when .t. size 35,013   valid (fpesc(cPesc))	 Of odlg Pixel
	
	//Cria a listbox
	@ 060,000 listbox oLbx fields header " ", "Nota",'Serie',"Emissao",'Volume','Romaneio','.'  size  aSize[3]-05,255 of oDlg pixel on dbLclick(edlista(oLbx:nat,oVlrSelec))
	
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
	aVetor[oLbx:nAt,2],;
	aVetor[oLbx:nAt,3],;
	aVetor[oLbx:nAt,4],;
	aVetor[oLbx:nAt,5],;
	aVetor[oLbx:nAt,6],;
	' '	}}
	
	//	@ aSize[4]-28 ,005 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg on CLICK(aEval(aVetor,{|x| x[1]:=lChk}),fMarca(),oLbx:Refresh())
	
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||nOpca:=1,lSaida:=.t.,oDlg:End()}	,{|| nOpca := 0,lSaida:=.t.,oDlg:End()},,aButtons)
	
End
If nOpca =1
	//	If MSGYESNO("Deseja Gerar o Pedido de Transferencia Com os Endereços Selecionados ?")
	//	Processa({|| 	GeraPed()},'Gerando Pedido .......')
	//	EndIf
EndIf
Return()


/*====================================================================================\
|Programa  | fMarca           | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | fMarca                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function PedStx()
*-----------------------------*

If MSGYESNO("Deseja Gerar Etiquetas das Notas Selecionadas ?")
	Processa({|| 	GeraPed()},'Gerando Etiqueta .......')
EndIf

STQUERY()
aVetor:= {}
_nQtd := 0
_nMeta:= 0
Processa({|| 	CompMemory()},'Atualizando Notas.....')



oVlrSelec:Refresh()
oLbx:Refresh()
oDlg:Refresh()
oDlg:End()

Return()


/*====================================================================================\
|Programa  | fMarca           | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | fMarca                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function fMarca()
*-----------------------------*
local b

_nMeta:=0

for b:= 1 to Len(aVetor)
	
	If aVetor[oLbx:nAt,1]
		_nMeta++
	EndIf
	
next b

oVlrSelec:Refresh()
oLbx:Refresh()
oDlg:Refresh()

Return( .t. )


/*====================================================================================\
|Programa  | fpesc            | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | fpesc                                                                    |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function fpesc(_cXPesc)
*-----------------------------*
local b
Local _lRex := .f.

If !(Empty(Alltrim(_cXPesc)))
	for b:= 1 to Len(aVetor)
		
		If UPPER(ALLTRIM(aVetor[b,2]))   =  UPPER(ALLTRIM(_cXPesc) )
			_lRex:= .T.
		EndIf
		
	next b
	
Else
	_lRex:= .T.
EndIf
If _lRex .And. !(Empty(Alltrim(_cXPesc)))
	oLbx:nAt:= aScan(aVetor, {|x| Upper(AllTrim(x[2])) == UPPER(Alltrim(_cXPesc))})
EndIf
oLbx:Refresh()
oDlg:Refresh()
opesc:Refresh()
Return( _lRex )

/*====================================================================================\
|Programa  | EdLista          | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | EdLista                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function EdLista()
*-----------------------------*
Local b

_nMeta:=0
aVetor[oLbx:nAt,1]	:= !aVetor[oLbx:nAt,1]

for b:= 1 to Len(aVetor)
	
	If aVetor[b,1]
		_nMeta++
	EndIf
	
next b

oVlrSelec:Refresh()
oLbx:Refresh()
oDlg:Refresh()
Return ()
/*====================================================================================\
|Programa  | GeraPed          | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |   msexecauto                                                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | GeraPed                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function GeraPed( )
*-----------------------------*
Local b

For b:= 1 To Len(aVetor)
	
	If aVetor[b,1]
		
		u_STETIQBRAS(aVetor[b,2],aVetor[b,3])
		
	EndIf
	
Next b


Return ()
