#include 'Protheus.ch'
#include 'RwMake.ch'
#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | STCONTAINER      | Autor | GIOVANI.ZAGO             | Data | 29/07/2014  |
|=====================================================================================|
|Descrição |  STCONTAINER  quebra container ped.Exportação                            |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPESQESTRU                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STCONTAINER()   //  u_STCONTAINER()
*-----------------------------*
//-- Dimensoes padroes
Local aSize     := MsAdvSize(, .F., 400)
Local aInfo 	:= {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
Local aObjects 	:= {{100, 100,.T.,.T. }}
Local aPosObj 	:= MsObjSize( aInfo, aObjects,.T. )
Local nStyle 	:= GD_INSERT+GD_DELETE+GD_UPDATE
Local nOpca		:= 0
Local acpos		:= {"XX_QTDD2","XX_COD"}
Local aButtons	:= {}
If !IsInCallSteck("U_STFTA001")
	aAdd(aButtons,{"PMSSETAUP"  	,{|| CarrEstru()}		,"Carrega Estrutura"		,"Carrega Estrutura"})
EndIf
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= 'conta'+cHora+ cMinutos+cSegundos
Private cCadastro := "Fatura Exportação"
Private oDlg
Private oLbx
Private aVetor     	:= {}
Private oLbx
Private aVetor     	:= {}
Private oLbx2
Private aVetor2     := {}
Private oOk	   		:= LoadBitmap( GetResources(), "LBOK" )
Private oNo	   		:= LoadBitmap( GetResources(), "LBNO" )

Private _cPesq	   		:= Space(15)
Private _oPesq
Private _cVetor	   		:= ''
Define FONT oFontN  NAME "Arial"
Define FONT oFontB  NAME "Arial" BOLD
Private oFontN  	:= TFont():New("Arial",9,25,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFontB 	    := TFont():New("Arial",9,50,.T.,.T.,5,.T.,5,.T.,.F.)
Private oGetPv
Private _cPv        := Space(6)


aadd(aVetor,{.f.,' ',' ',' ',' '})
aadd(aVetor2,{.f.,' ',' ',' ',' '})
Define MSDialog oDlg Title cCadastro From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel


@ 005,005  SAY 'Pedido'		SIZE 40,10 PIXEL OF  oDlg
@ 005,045  MSGet oGetPv Var _cPv   SIZE 50,10  PIXEL OF  oDlg  F3 'SC5' Picture '@!'  VALID ( Empty(alltrim(_cPv)) .Or. (EXISTCPO("SC5",_cPv),EmbArray()) )


@ 020,005 listbox oLbx fields header " ", "Embarque",'Qtd.Pallets','O.S.'  size  aPosObj[1,4]/2 , aPosObj[1,3]/2  pixel of oDlg on dbLclick(edlista())

oLbx:SetArray( aVetor )

oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
aVetor[oLbx:nAt,2],;
aVetor[oLbx:nAt,3],;
aVetor[oLbx:nAt,4];
}}

@ aPosObj[1,3]/2+40,005 listbox oLbx2 fields header " ", "Embarque",'Pallets','O.S.'  size  aPosObj[1,4]/2 , aPosObj[1,3]/2-40  pixel of oDlg on dbLclick(xEdLista())

oLbx2:SetArray( aVetor2 )

oLbx2:bLine := {|| {Iif(	aVetor2[oLbx2:nAt,1],oOk,oNo),;
aVetor2[oLbx2:nAt,2],;
aVetor2[oLbx2:nAt,3],;
aVetor2[oLbx2:nAt,4];
}}



ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End() },{||oDlg:End()},,aButtons)

// se a opcao for encerrar executa a rotina.
If nOpca == 1
	
EndIf

Return

/*====================================================================================\
|Programa  | EmbArray         | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | EmbArray                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function EmbArray()
*-----------------------------*
Local _nRet 	 := 0
Local cQuery     := ' '
Local lMark      := .F.
Local _cSoma     := ' '

cQuery += " SELECT *
cQuery += "  FROM "+RetSqlName("ZZA")+" ZZA "
cQuery += " WHERE ZZA.D_E_L_E_T_ = ' '
cQuery += " AND ZZA.ZZA_FILIAL =  '"+xFilial("ZZA")+"'
cQuery += " AND ZZA.ZZA_PEDFAT = '"+_cPv+"'

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
dbSelectArea(cAliasLif)
aVetor:={}
If  Select(cAliasLif) > 0
	(cAliasLif)->(dbgotop())
	
	While !(cAliasLif)->(Eof())
		If !(Alltrim((cAliasLif)->ZZA_PREEMB) $ _cSoma)
			_cSoma:= _cSoma+'/'+	(cAliasLif)->ZZA_PREEMB
			aadd(aVetor ,{ lMark ,; //01
			Alltrim((cAliasLif)->ZZA_PREEMB) ,;	//02   item
			999	 						 ,;	//03   produto
			Alltrim((cAliasLif)->ZZA_ORDSEP)	 ,;	//04   descrição
			' '	})
		EndIf
		(cAliasLif)->(dbSkip())
	End
	
	
EndIf
If Len(aVetor) = 0
	aadd(aVetor,{.f.,' ',' ',' ',' '})
EndIf
oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
aVetor[oLbx:nAt,2],;
aVetor[oLbx:nAt,3],;
aVetor[oLbx:nAt,4] ;
}}
oLbx:Refresh()
oDlg:Refresh()
Return()

/*====================================================================================\
|Programa  | EdLista          | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
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
Static Function EdLista(_cEdit)
*-----------------------------*
Local b  		:= 0
Local lMark    	:= .F.
Local _cSoma  	:= ' '

aVetor[oLbx:nAt,1]	:= !aVetor[oLbx:nAt,1]
aVetor2:={}
for b:= 1 to Len(aVetor)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		If aVetor[b,1]
			While !(cAliasLif)->(Eof())
				If !(Alltrim((cAliasLif)->ZZA_PREEMB)+Alltrim((cAliasLif)->ZZA_PALLET) $ _cSoma)
					_cSoma:= _cSoma+'/'+Alltrim((cAliasLif)->ZZA_PREEMB)+Alltrim((cAliasLif)->ZZA_PALLET)
					aadd(aVetor2 ,{ lMark ,; //01
					Alltrim((cAliasLif)->ZZA_PREEMB) ,;	//02   item
					Alltrim((cAliasLif)->ZZA_PALLET) ,;	//03   produto
					Alltrim((cAliasLif)->ZZA_ORDSEP) ,;	//04   descrição
					' '	})
				EndIf
				(cAliasLif)->(dbSkip())
			End
			
		EndIf
	EndIf
	
next b
If Len(aVetor2) = 0
	aadd(aVetor2,{.f.,' ',' ',' ',' '})
EndIf
oLbx2:SetArray( aVetor2 )
oLbx2:bLine := {|| {Iif(	aVetor2[oLbx2:nAt,1],oOk,oNo),;
aVetor2[oLbx2:nAt,2],;
aVetor2[oLbx2:nAt,3],;
aVetor2[oLbx2:nAt,4] ;
}}

oLbx2:Refresh()
oLbx:Refresh()
oDlg:Refresh()
Return (.T.)

 
               
/*====================================================================================\
|Programa  | EdLista          | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
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
Static Function xEdLista(_cEdit)
*-----------------------------*
Local b  		:= 0
Local lMark    	:= .F.
Local _cSoma  	:= ' '

aVetor2[oLbx2:nAt,1]	:= !aVetor2[oLbx2:nAt,1]

oLbx2:Refresh()
oLbx:Refresh()
oDlg:Refresh()
Return (.T.)

 
               