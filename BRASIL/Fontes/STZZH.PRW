#include 'Protheus.ch' 
#include 'RwMake.ch'

Static oColOK   := LoadBitmap(,'LBOK')  
Static oColNO   := LoadBitmap(,'LBNO')

           
/*====================================================================================\
|Programa  | STZZH          | Autor | GIOVANI.ZAGO               | Data | 27/11/2013  |
|=====================================================================================|
|Descrição | Cria mBrowse 											                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STZZH                                                                    |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function STZZH()
*---------------------------------------------------*
	Private cCadastro := 'Aprovadores'
	Private cString   := 'ZZH'
	Private aRotina	  := MenuDef()
	Private _cuser    := GetMv("ST_ZZH",,"000000")+"000000"
	If !(__cuserid $ _cuser)
		MsgInfo("usuario Sem Acesso...!!!")
		Return()
	EndIf

	(cString)->(DbSetOrder(1))

	mBrowse( 6,1,22,75,cString)

//RetIndex(cString)

Return NIL


/*====================================================================================\
|Programa  | MenuDef        | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
|=====================================================================================|
|Descrição | Opçoes do Menu											                  |
|          | 													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MenuDef                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
Static Function MenuDef()
*---------------------------------------------------*

	PRIVATE aRotina	 := {	{ "Pesquisar" ,"AxPesqui"    ,0 ,1 ,0 ,.F.},;  //"Pesquisar"
	{ "Visualizar"  ,"axVisual" 		,0 ,2 ,0 ,Nil},;  //"Visualizar"
	{ "Incluir" 	,"U_STZZHMENU(3)" 	,0 ,3 ,0 ,Nil},;  //"Incluir"
	{ "Alterar" 	,"U_STZZHMENU(4)" 	,0 ,4 ,0 ,Nil},;  //"Alterar"
	{ "Excluir" 	,"U_STZZHMENU(5)" 	,0 ,5 ,0 ,Nil}}  //"Excluir"
//{ "Copiar" ,"u_SZ3080Manut" ,0 ,6 ,0 ,Nil} }  //"Copiar"


Return(aRotina)

User Function STZZHMENU(_nOp)
	Local _nRet:= 0
	
	If _nOp = 3
		_nRet:= AxInclui("ZZH",ZZH->(Recno()),_nOp,,,,,,,,  )
		If _nRet = 1
			RecLock("ZZH",.F.)
			ZZH->ZZH_LOG := ZZH->ZZH_LOG +  "Incluido: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)+;
				"Aprovador:     "+ ZZH->ZZH_USER 								+ chr(13) + chr(10)+;
				"Nome:          "+ ZZH->ZZH_NOME 								+ chr(13) + chr(10)+;
				"Minimo:        "+ Transform(ZZH->ZZH_MIN,' @R 999.99 '  ) 	+ chr(13) + chr(10)+;
				"Maximo:        "+ Transform(ZZH->ZZH_MAX,' @R 999.99 '  ) 	+ chr(13) + chr(10)+;
				"Departamento:  "+ IIF(ZZH->ZZH_DEPAR = '1',"1-Supervisao", IIF(ZZH->ZZH_DEPAR = '2',"2-Coordenacao",  IIF(ZZH->ZZH_DEPAR = '3',"3-Gerencia", "4-Diretoria"))) + chr(13) + chr(10)+;
				"Data De:       "+ DTOC(ZZH->ZZH_DTDE)							+ chr(13) + chr(10)+;
				"Data Ate:      "+ DTOC(ZZH->ZZH_DTATE)							+ chr(13) + chr(10)+;
				"Limite Tempo.: "+ Transform(ZZH->ZZH_LIMITE,' @R 999.99 ') + chr(13) + chr(10)
			Msunlock()
		EndIf
	ElseIf _nOp = 4
		_nRet:= AxAltera("ZZH",ZZH->(Recno()),_nOp,,,,,,,,  )
		If _nRet = 1
			RecLock("ZZH",.F.)
			ZZH->ZZH_LOG := ZZH->ZZH_LOG +  "Alterado: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)+;
				"Aprovador:     "+ ZZH->ZZH_USER 								+ chr(13) + chr(10)+;
				"Nome:          "+ ZZH->ZZH_NOME 								+ chr(13) + chr(10)+;
				"Minimo:        "+ Transform(ZZH->ZZH_MIN,' @R 999.99 '  ) 	+ chr(13) + chr(10)+;
				"Maximo:        "+ Transform(ZZH->ZZH_MAX,' @R 999.99 '  ) 	+ chr(13) + chr(10)+;
				"Departamento:  "+ IIF(ZZH->ZZH_DEPAR = '1',"1-Supervisao", IIF(ZZH->ZZH_DEPAR = '2',"2-Coordenacao",  IIF(ZZH->ZZH_DEPAR = '3',"3-Gerencia", "4-Diretoria"))) + chr(13) + chr(10)+;
				"Data De:       "+ DTOC(ZZH->ZZH_DTDE)							+ chr(13) + chr(10)+;
				"Data Ate:      "+ DTOC(ZZH->ZZH_DTATE)							+ chr(13) + chr(10)+;
				"Limite Tempo.: "+ Transform(ZZH->ZZH_LIMITE,' @R 999.99 ') + chr(13) + chr(10)
			Msunlock()
		EndIf
	ElseIf _nOp = 5
		RecLock("ZZH",.F.)
		ZZH->ZZH_LOG := ZZH->ZZH_LOG +  "Excluido: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)+;
			"Aprovador:     "+ ZZH->ZZH_USER 								+ chr(13) + chr(10)+;
			"Nome:          "+ ZZH->ZZH_NOME 								+ chr(13) + chr(10)+;
			"Minimo:        "+ Transform(ZZH->ZZH_MIN,' @R 999.99 '  ) 	+ chr(13) + chr(10)+;
			"Maximo:        "+ Transform(ZZH->ZZH_MAX,' @R 999.99 '  ) 	+ chr(13) + chr(10)+;
			"Departamento:  "+ IIF(ZZH->ZZH_DEPAR = '1',"1-Supervisao", IIF(ZZH->ZZH_DEPAR = '2',"2-Coordenacao",  IIF(ZZH->ZZH_DEPAR = '3',"3-Gerencia", "4-Diretoria"))) + chr(13) + chr(10)+;
			"Data De:       "+ DTOC(ZZH->ZZH_DTDE)							+ chr(13) + chr(10)+;
			"Data Ate:      "+ DTOC(ZZH->ZZH_DTATE)							+ chr(13) + chr(10)+;
			"Limite Tempo.: "+ Transform(ZZH->ZZH_LIMITE,' @R 999.99 ') + chr(13) + chr(10)
			
		Msunlock()
		_nRet:= AxDeleta("ZZH",ZZH->(Recno()),_nOp,,,,,,,,  )
		If _nRet = 1
			RecLock("ZZH",.F.)
			ZZH->ZZH_LOG := ZZH->ZZH_LOG +  "Excluido: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)+;
				"Aprovador:     "+ ZZH->ZZH_USER 								+ chr(13) + chr(10)+;
				"Nome:          "+ ZZH->ZZH_NOME 								+ chr(13) + chr(10)+;
				"Minimo:        "+ Transform(ZZH->ZZH_MIN,' @R 999.99 '  ) 	+ chr(13) + chr(10)+;
				"Maximo:        "+ Transform(ZZH->ZZH_MAX,' @R 999.99 '  ) 	+ chr(13) + chr(10)+;
				"Departamento:  "+ IIF(ZZH->ZZH_DEPAR = '1',"1-Supervisao", IIF(ZZH->ZZH_DEPAR = '2',"2-Coordenacao",  IIF(ZZH->ZZH_DEPAR = '3',"3-Gerencia", "4-Diretoria"))) + chr(13) + chr(10)+;
				"Data De:       "+ DTOC(ZZH->ZZH_DTDE)							+ chr(13) + chr(10)+;
				"Data Ate:      "+ DTOC(ZZH->ZZH_DTATE)							+ chr(13) + chr(10)+;
				"Limite Tempo.: "+ Transform(ZZH->ZZH_LIMITE,' @R 999.99 ') + chr(13) + chr(10)
			Msunlock()
		EndIf
	EndIf
 
Return()
		
		


User Function GRPF3(nOpc)

    Local aCombo   :={} 
    Local cCampo   :='A1_GRPVEN'
    Local aSeg     :={}
    Local nAtual   :=0
    Local cRet     :=""
    Local lOk	   := .T.
	Local cSele    := ""
	
	
	IF IsInCallStack("U_STFAT540")
	   cSele    := SPACE(100)
	ELSE    
       cSele    := M->ZZH_GRPVEN
	ENDIF
	
	//RpcClearEnv()
	//RpcSetType(3)
	//RpcSetEnv("01","17001")

    DBSELECTAREA('SA1')
    
    //aCombo := RetSX3Box(GetSX3Cache(cCampo, "X3_CBOX"),,,1)
	//For nAtual := 1 To Len(aCombo)
    //    aAdd(aSeg,{.F.,aCombo[nAtual][2],aCombo[nAtual][3]})		
	//Next

    ACY->(DBGOTOP())
	WHILE ! ACY->(EOF())
       IF ALLTRIM(ACY->ACY_GRPVEN) $ cSele 
	      aAdd(aSeg,{.T.,ACY->ACY_GRPVEN,ACY->ACY_DESCRI})		
	   ELSE 
	      aAdd(aSeg,{.F.,ACY->ACY_GRPVEN,ACY->ACY_DESCRI})		
	   ENDIF  
       ACY->(DBSKIP())
	ENDDO    

    If nOpc == 1
            lTela := COLFILTELA(@aSeg)
            If lTela
                For nI := 1 To Len(aSeg)
                    If aSeg[nI,1]
                        If Empty(cRet)
                            cRet := ALLTRIM(aSeg[nI,2])
                        Else
                            cRet += ";"+ALLTRIM(aSeg[nI,2])
                        Endif
                    Endif
                Next nI
            Endif

            If !Empty(cRet)
                aAux := Separa(cRet,";")
                cRet := ""
                For nI := 1 To Len(aAux)
                    //If nI <= 14
                        If Empty(cRet)
                            cRet := "'"+ALLTRIM(aAux[nI])+"'"
                        Else
                            cRet += "," + "'"+ALLTRIM(aAux[nI])+"'"
                        Endif
                    //Endif
                Next nI
                IF ! IsInCallStack("U_STFAT540")
                   M->ZZH_GRPVEN := cRet
                ELSE 
				   aparam[9,3]:=cRet				   
				ENDIF   
            Endif
        Elseif nOpc == 2
            IF ! IsInCallStack("U_STFAT540")
			   cRet := M->ZZH_GRPVEN
			ELSE 
			   cRet:=aparam[9,3]
			ENDIF   
        Endif

Return Iif(nOpc==1,lOk,cRet)


//Tela para selecionar os segmentos 

Static Function COLFILTELA(aInfo)

Local aHdr	   := {"","Codigo","Descrição"}
Local lOk      :=.T.

DEFINE MSDIALOG oDlgFil FROM 00,00 TO 290,490 PIXEL TITLE "Selecionar Regiao de Vendas"

    oListBox := TWBrowse():New(03,03,250,125,,aHdr,,oDlgFil,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
    oListBox:SetArray(aInfo)
    oListBox:bLine := { ||{ Iif(aInfo[oListBox:nAT][1],oColOK,oColNo),aInfo[oListBox:nAT][2],aInfo[oListBox:nAT][3]}}
    oListBox:bLDblClick := { || SetDpClick(3,aInfo,3,oListBox)}
	oListBox:bHeaderClick := {|| SetDpClick(4,aInfo,4,oListBox)}
    
	@ 130,05 BUTTON oConf Prompt "Confirma" SIZE 45 ,10   FONT oDlgFil:oFont ACTION (lOk:=.T.,aInfo := aClone(oListBox:aArray),oDlgFil:End())  OF oDlgFil PIXEL //'Confirma'
    @ 130,55 BUTTON oCanc Prompt "Cancela" SIZE 45 ,10   FONT oDlgFil:oFont ACTION (lOk:=.F.,oDlgFil:End())  OF oDlgFil PIXEL //'Cancela'
       
ACTIVATE MSDIALOG oDlgFil CENTERED

Return lOk

Static Function SetDpClick(nOpc,aArquivo,nCombo,oBrowse) 

Local nI		:= 0

Default nOpc := 5

If nOpc == 1 .Or. nOpc == 3 //Click linha
	aArquivo[oBrowse:nAt,1] := !aArquivo[oBrowse:nAt,1]
	If nOpc == 1
		If aArquivo[oBrowse:nAt,1] .And. Alltrim(aArquivo[oBrowse:nAt,8]) == 'COM042'
			aArquivo[oBrowse:nAt,1] := ColChanFil(@aArquivo,@oBrowse)
		Endif
	Endif
Elseif nOpc == 2 .Or. nOpc == 4//Click Header
	For nI := 1 To Len(aArquivo)
		aArquivo[nI,1] := !aArquivo[nI,1]
		If nOpc == 2
			If aArquivo[nI,1] .And. Alltrim(aArquivo[nI,8]) == 'COM042'
				aArquivo[nI,1] := ColChanFil(@aArquivo,@oBrowse)
			Endif
		Endif
	Next nI
Endif


If nOpc == 3 .Or. nOpc == 4
	oBrowse:SetArray(aArquivo)
	oBrowse:bLine := {|| {If(aArquivo[oBrowse:nAT,1],oColOK,oColNo),aArquivo[oBrowse:nAt,02],aArquivo[oBrowse:nAt,03]}}
	oBrowse:Refresh()
Endif

Return

		