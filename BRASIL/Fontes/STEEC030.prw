#INCLUDE "RWMAKE.CH"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*====================================================================================\
|Programa  | STEEC030        | Autor | Renan Rosário             | Data | 04/06/2019  |
|=====================================================================================|
|Descrição | Relatorio EEC   				                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
User Function STEEC030()
	
Local aArea 	  := GetArea()
Local oPar        := NIL
Local oDesc		  := NIL
Local oCodigo	  := NIL
Local oPeso		  := NIL
Local oGrpPar	  := NIL
Local lRet 		  := .F.
Local aCombo   := {"Volume","Pallet"}

Private cCombo
Private cCodigo   := Space(20)      

DEFINE MSDIALOG oPar TITLE "Impressão de Etiquetas em Impressora Zebra TencnoRed" FROM 000, 000  TO 190, 420 PIXEL STYLE DS_MODALFRAME
	
@ 005, 005 GROUP oGrpPar TO 090, 205 PROMPT "Informe o Número de Embarque a ser Impressa" OF oPar PIXEL

@ 015, 015 SAY oDesc PROMPT "Embarque:"  SIZE 030, 010  OF oPar PIXEL
@ 015, 060 MSGET oCodigo VAR cCodigo PICTURE "@!" F3 'EEC' SIZE 060, 010  OF oPar PIXEL  
@ 035, 015 SAY oDesc PROMPT "Tipo Etiqueta:"  SIZE 040, 010  OF oPar PIXEL
@ 035, 060 ComboBox cCombo Items aCombo Size 052,010 PIXEL OF oPar  

  
@ 014, 135 BMPBUTTON TYPE 01 ACTION lRet	:= ETIQTELA(cCodigo, cCombo) 
@ 029, 135 BMPBUTTON TYPE 02 ACTION Close(oPar) 

oPar:lEscClose:=.F.

ACTIVATE MSDIALOG oPar CENTERED 

Return

/*====================================================================================\
|Programa  | ETIQTELA        | Autor | Renan Rosário             | Data | 04/06/2019  |
|=====================================================================================|
|Descrição | Etiquetas EEC   				                                          |
|          | Imprime a Etiqueta em Zebra                                              |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
Static Function ETIQTELA(cCodigo, cCombo)
                       	
Local cPorta		:="LPT1"
Local nX        	:= 0
Local nZ			:= 0
Local nQtdVl		:= 0
Local nPeso			:= 0
Local nPack			:= 0
Local _cProd_		:= ""
Local nTOT			:= 0
Local cLocImp 		:= "000013" //Enviar para impressora TNT

Private aEtique   	:= {}
Private aEtiOut   	:= {}
Private __cFil		:= ""
Private __VOLUME	:= ""
Private __cPROD		:= ""
Private __cPEDIFA	:= ""

ETIQARRY( cCodigo, @aEtique, @aEtiOut )

//cLocImp 		:= "000006"

	If !CB5SetImp (cLocImp)
	
	CBAlert ("Local de Impressão " +cLocImp+ " não Existe !!!", "Atenção")
	Return
	
	EndIf

	If Len(aEtique) > 0

		If cCombo == 'Volume'
	
			nOpcao := getSelecao()        // Ticket: 20200722004553 - Valdemir Rabelo 11/08/2021
			if nOpcao==0
				FWMsgRun(,{|| Sleep(3000)},"Informativo","Não foi selecionado itens para impressão.")
				Return
			endif

			nPack  := Len(aEtique)		
			
			aSort(aEtique,,,{|x,y| x[5]<y[5]})
	
			For nX := 1 to Len(aEtique)

				if aEtique[nX][11]			// Ticket: 20200722004553 - Valdemir Rabelo 11/08/2021
				
					//MSCBPRINTER("Z4M",cPorta,,120,.F.,,,,,,.T.)
					MSCBINFOETI("Etiqueta TECNORED","MODELO TECNORED")
					MSCBBEGIN(1,1)
					
					//Box Canto superior Esquerdo
					MSCBBOX(70,10,100,70,1)
					MSCBLineH(70,39,100,1)
					MSCBLineV(090,10,70)
					MSCBLineV(081,10,70)
					MSCBLineV(070,10,70)
				
					MSCBSAY(92,12,"Supplier Name","R","R","4",.T.)
					//MSCBSAY(92,41,aEtique[nX][7],"R","R","4",.T.)
					MSCBSAY(94,41,"Steck Industria","R","R","4",.T.)
					MSCBSAY(90,41,"Eletrica Ltda","R","R","4",.T.)
					
					MSCBSAY(85,12,"Purchase Order","R","R","4",.T.)
					MSCBSAY(82,12,"Number","R","R","4",.T.)
					
					MSCBSAY(86,41,SubStr(aEtique[nX][8],1,15),"R","R","4",.T.)
					MSCBSAY(82,41,SubStr(aEtique[nX][8],16,15),"R","R","4",.T.)
					
					MSCBSAY(76,12,"Delivery Receipt","R","R","4",.T.)                
					MSCBSAY(73,12,"Number","R","R","4",.T.)
					MSCBSAY(75.5,41,aEtique[nX][6],"R","R","4",.T.)
					
					//Box Canto superior Direito
					MSCBBOX(70,85,100,145,2)
					MSCBLineH(70,115,100,2)
					MSCBLineV(090,85,145)
					MSCBLineV(081,85,145)
					MSCBLineV(070,85,145)
					
					nPos	:= aScan(aEtiOut,{|x| AllTrim(x[1]) == AllTrim (aEtique[nX][4])})
					
					If  AllTrim (aEtique[nX][4]) <> _cProd_
				
						//nPack 		:= 1
						_cProd_		:= AllTrim (aEtique[nX][4])
						
					Else
			
						//nPack 		+= 1
						//_cProd_		:= AllTrim (aEtique[nX][4])
					
					EndIf
					
					MSCBSAY(92,86,"Package Number","R","R","4,4",.T.)
					//MSCBSAY(92,123, ALLTRIM (STR (nPack)) + " Out Of " + ALLTRIM (STR (aEtiOut [nPos][2])),"R","R","4,4",.T.)
					//MSCBSAY(92,123, ALLTRIM (STR (aEtiOut [nPos][2])) + " Out Of " + ALLTRIM (STR (nPack)),"R","R","4,4",.T.)
					
					MSCBSAY(92,123, cValToChar(Val(SubStr(aEtique[nX][5],7,4))) + " Out Of " + ALLTRIM (STR (nPack)),"R","R","4,4",.T.)
					
					nPeso := PESOVOL(aEtique[nX][1], aEtique[nX][5])
					
					MSCBSAY(85,87,"Package Weight","R","R","4,4",.T.)
					MSCBSAY(85,126, Transform(nPeso,"@E 99,999,999.99") ,"R","R","4,4",.T.)

					MSCBSAY(76,86,"Dispatch Date","R","R","4",.T.)
					MSCBSAY(76,123,DTOC (aEtique[nX][9]),"R","R","4",.T.)		     
					
					//Informações do Produto Cliente
					MSCBSAY(50,65,Alltrim(Posicione("SA7", 1, xFilial("SA7") + AllTrim (aEtique[nX][7])+ AllTrim (aEtique[nX][10]) + AllTrim (aEtique[nX][4]), "A7_CODCLI"))	,"R","R","070,070")
					MSCBSAY(40,22,Alltrim(Posicione("SA7", 1, xFilial("SA7") + AllTrim (aEtique[nX][7])+ AllTrim (aEtique[nX][10]) + AllTrim (aEtique[nX][4]), "A7_DESCCLI"))	,"R","R","050,050",.T.)
					MSCBSAYBAR(25,63,Alltrim(Posicione("SA7", 1, xFilial("SA7") + AllTrim (aEtique[nX][7])+ AllTrim (aEtique[nX][10]) + AllTrim (aEtique[nX][4]), "A7_CODCLI")),'R','MB07',10,.F.,.F.,,,2,2) //Codigo Produto Cliente em Barras
					
					//Box Inferior Central
					MSCBBOX(05,30,20,125,2)
					MSCBLineH(05,90,20,2)
					
					nQtdVl := QUANTVOL(aEtique[nX][1], aEtique[nX][5])
					
					MSCBSAY(14,39.5,"Total Quantity of The","R","R","4",.T.)
					MSCBSAY(08,37,"product in the packaging","R","R","4",.T.)  
					MSCBSAY(10,102, ALLTRIM (STR (nQtdVl)),"R","R","050,050",.T.)
					MSCBEND()

				endif
			Next nX
	    	     
		ElseIf cCombo == 'Pallet'
	
			For nZ := 1 to Len(aEtiOut)
			 
			 //MSCBPRINTER("Z4M",cPorta,,120,.F.,,,,,,.T.)
		     MSCBINFOETI("Etiqueta TECNORED","MODELO TECNORED")
		     MSCBBEGIN(1,1)
		     
		     //Box Canto superior Esquerdo
		     MSCBBOX(70,10,100,70,1)
		     MSCBLineH(70,39,100,1)
		     MSCBLineV(090,10,70)
		     MSCBLineV(081,10,70)
		     MSCBLineV(070,10,70)
		     		
		     MSCBSAY(92,12,"Supplier Name","R","R","4",.T.)
		     //MSCBSAY(92,41,aEtiOut[nZ][3],"R","R","4",.T.)
		     MSCBSAY(94,41,"Steck Industria","R","R","4",.T.)
		     MSCBSAY(90,41,"Eletrica Ltda","R","R","4",.T.)
		     
		     MSCBSAY(85,12,"Purchase Order","R","R","4",.T.)
		     MSCBSAY(82,12,"Number","R","R","4",.T.)
		     
		     MSCBSAY(86,41,SubStr(aEtiOut[nZ][6],1,15),"R","R","4",.T.)
		     MSCBSAY(82,41,SubStr(aEtiOut[nZ][6],16,15),"R","R","4",.T.)
		     
		     MSCBSAY(76,12,"Delivery Receipt","R","R","4",.T.)                
		     MSCBSAY(73,12,"Number","R","R","4",.T.)
		     MSCBSAY(75.5,41,aEtiOut[nZ][4],"R","R","4",.T.)
		     
		     MSCBSAY(65,12,"Dispatch Date","R","R","4",.T.)
		     MSCBSAY(65,41,DTOC (aEtiOut[nZ][5]),"R","R","4",.T.)
		    
		    //Informações do Produto Cliente
		     MSCBSAY(50,63,Alltrim(Posicione("SA7", 1, xFilial("SA7") + AllTrim (aEtiOut[nZ][3])+ AllTrim (aEtiOut[nZ][7]) + AllTrim (aEtiOut[nZ][1]), "A7_CODCLI"))	,"R","R","100,100")
			 MSCBSAY(40,22,Alltrim(Posicione("SA7", 1, xFilial("SA7") + AllTrim (aEtiOut[nZ][3])+ AllTrim (aEtiOut[nZ][7]) + AllTrim (aEtiOut[nZ][1]), "A7_DESCCLI"))	,"R","R","070,070",.T.)
		
			//Box Inferior Central
			 MSCBBOX(05,30,35,125,2)
		     MSCBLineH(05,90,35,2)
		     MSCBLineV(20,30,125)
		     
		     nTOT	:= TOTVOL (aEtiOut[nZ][9], aEtiOut[nZ][1], aEtiOut[nZ][8])
		     
		     MSCBSAY(28,40,"Total Quantity of The","R","R","4",.T.)
		     MSCBSAY(22.5,39,"product in the Pallet","R","R","4",.T.)  
		     MSCBSAY(24,100, ALLTRIM (STR (nTOT)),"R","R","050,050",.T.)
		     
		     MSCBSAY(14,40,"Total Quantity of The","R","R","4",.T.)
		     MSCBSAY(08.5,39,"Packages in the Pallet","R","R","4",.T.)  
		     MSCBSAY(10,102, ALLTRIM (STR (aEtiOut[nZ][2])),"R","R","050,050",.T.)
		     
		     MSCBEND()
		 
			Next nZ
		
		EndIf

	ElseIf Len(aEtique) == 0
	
	MsgAlert("Não Existe embalagem para este embarque.", "Atenção!!!") 
	
	EndIf

	IF !EMPTY(aEtique)

	MSCBCLOSEPRINTER()

	ENDIF

Return

/*/{Protheus.doc} getSelecao
description
Rotina para seleção de registros para impressão
Ticket: 20200722004553 
@type function
@version  
@author Valdemir Jose
@since 11/08/2021
@return variant, return_description
/*/
Static Function getSelecao()
	Local nRet    := 0
	Local bOk     :={|| nRet:=1, __oDlg:End()} //botao de ok
	Local bCancel :={|| nRet:=0, __oDlg:End()} //botao de cancelamento
	Local __oDlg
	Local lChk    := .F.
	Private oOk   := LoadBitmap( GetResources(), "LBOK" )
	Private oNo   := LoadBitmap( GetResources(), "LBNO" )
	Private oChk

	@ 001,001 TO 400,700 DIALOG __oDlg TITLE OemToAnsi("Selecione as Etiquetas")
	@ 035,001 listbox oLbx fields header " ", "Filial",'Processo',"Ped.de Venda",'Produto','Volume','Sequen. Ref.','Cod. Import.','Ref.Import.','Dt.Processo', 'Loja Import.' size  350,150 of __oDlg pixel on dbLclick( aEtique[oLbx:nAt,11] := !aEtique[oLbx:nAt,11],  oLbx:Refresh() )
	@ 188,002 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF __oDlg on CLICK(aEval(aEtique,{|x| x[11]:=lChk}), oLbx:Refresh())

	oLbx:SetArray( aEtique )
	oLbx:bLine := {|| {Iif(	aEtique[oLbx:nAt,11],oOk,oNo),;
		aEtique[oLbx:nAt,01],;
		aEtique[oLbx:nAt,02],;
		aEtique[oLbx:nAt,03],;
		aEtique[oLbx:nAt,04],;
		aEtique[oLbx:nAt,05],;
		aEtique[oLbx:nAt,06],;
		aEtique[oLbx:nAt,07],;
		aEtique[oLbx:nAt,08],;
		aEtique[oLbx:nAt,09],;
		aEtique[oLbx:nAt,10];
		}}
    nTrue := 0
	Activate MsDialog __oDlg On Init (EnchoiceBar(__oDlg,bOk,bCancel,,)) Centered VALID vldSelec()

Return nRet



/*====================================================================================\
|Programa  | ETIQARRY        | Autor | Renan Rosário             | Data | 04/06/2019  |
|=====================================================================================|
|Descrição | Etiquetas EEC   				                                          |
|          | Array das informacoes que serao impressas na etiqueta                    |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
Static Function ETIQARRY(cCodigo, aEtique, aEtiOut)

Local cQuery	:= ""
Local __cAlias  := GetNextAlias()
Local nY		:= 0
Local nTota		:= 1
Local cProd		:= ""
Local _nPos		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando dados com Query       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := " SELECT DISTINCT ZZA.ZZA_FILIAL FILIAL, ZZA.ZZA_PREEMB PREEMB, ZZA.ZZA_PEDFAT PEDFAT, " +CRLF 
cQuery += " CB9.CB9_PROD PROD, CB9.CB9_VOLUME VOLUME, EE7.EE7_XSEQUE XSEQUE, EE7.EE7_REFIMP REFIMP," +CRLF 
cQuery += " EE7.EE7_IMPORT IMPORT, EE7.EE7_IMLOJA IMLOJA ,EEC.EEC_DTPROC DTPROC" +CRLF

cQuery += " FROM "+RetSqlName("ZZA")+"  ZZA" +CRLF

cQuery += " INNER JOIN "+RetSqlName("EEC")+" EEC ON" +CRLF
cQuery += " EEC.D_E_L_E_T_ <> '*'" +CRLF
cQuery += " AND EEC.EEC_FILIAL = '"+xFilial("EEC")+"'" +CRLF
cQuery += " AND  EEC.EEC_PREEMB = ZZA.ZZA_PREEMB" +CRLF 

cQuery += " INNER JOIN "+RetSqlName("EE7")+" EE7 ON" +CRLF 
cQuery += " EE7.D_E_L_E_T_ <> '*'
cQuery += " AND EE7.EE7_FILIAL = '"+xFilial("EE7")+"'" +CRLF
cQuery += " AND EE7.EE7_PEDIDO = ZZA.ZZA_PEDIDO" +CRLF

cQuery += " INNER JOIN "+RetSqlName("CB9")+" CB9 ON" +CRLF
cQuery += " CB9.D_E_L_E_T_ <> '*'" +CRLF
cQuery += " AND CB9.CB9_FILIAL = '"+xFilial("CB9")+"'" +CRLF
cQuery += " AND CB9.CB9_PEDIDO = ZZA.ZZA_PEDFAT" +CRLF
cQuery += " AND CB9.CB9_ORDSEP = ZZA.ZZA_ORDSEP" +CRLF
cQuery += " AND CB9.CB9_VOLUME <> ' '" +CRLF

cQuery += " WHERE ZZA.D_E_L_E_T_ <> '*'" +CRLF
cQuery += " AND ZZA.ZZA_FILIAL = '"+xFilial("ZZA")+"'" +CRLF
cQuery += " AND ZZA.ZZA_PREEMB = '"+cCodigo+"'" +CRLF

cQuery += " ORDER BY CB9_PROD, CB9_VOLUME" +CRLF

cQuery := CHANGEQUERY(cQuery)	

dbUseArea(.T., 'TOPCONN', TcGenQry( ,, cQuery) ,__cAlias, .T., .F.)
                                                               
DBSelectArea((__cAlias)) //ABRE O ARQUIVO TEMPORARIO
(__cAlias)->(DbGoTop())  // ALINHA NO PRIMEIRO REGISTRO

	While (__cAlias)->(!EOF())

        aAdd(aEtique,{  (__cAlias)->FILIAL,;
        				(__cAlias)->PREEMB,;     				
        				(__cAlias)->PEDFAT,;
        				(__cAlias)->PROD  ,;
        				(__cAlias)->VOLUME,;
        				(__cAlias)->XSEQUE,;
        				(__cAlias)->IMPORT,;
        				(__cAlias)->REFIMP,;
        				STOD((__cAlias)->DTPROC),;
        				(__cAlias)->IMLOJA,;
						.F.})

		(__cAlias)->(dbSkip()) //PULA PARA O PROXIMO REGISTRO DO ARQUIVO TEMPORARIO   
			
	EndDo

	For nY := 1 to Len(aEtique)
	
	_nPos	:= aScan(aEtiOut,{|x| AllTrim(x[1]) == AllTrim (aEtique[nY][4])})
	
		If _nPos == 0//aEtique[nY][4] <> cProd .AND. !Empty (cProd)
	
        aAdd(aEtiOut,{  aEtique[nY][4],;        // Produto
        				nTota,;                 // Sequencial (Contador)
        				aEtique[nY][7],;        // Import
        				aEtique[nY][6],;        // XSEQUE
        				aEtique[nY][9],;        // DTPROC
        				aEtique[nY][8],;        // REFIMP
        				aEtique[nY][10],;       // IMLOJA
        				aEtique[nY][3],;        // PEDFAT
        				aEtique[nY][1],;        // FILIAL        
						.f.})                   // SELEÇÃO
		ElseIf _nPos > 0
      
      aEtiOut[_nPos][2] += 1
      
		EndIf
          
	Next nY

(__cAlias)->(DbCloseArea())
dbCloseArea()
	
Return

/*====================================================================================\
|Programa  | QUANTVOL        | Autor | Renan Rosário             | Data | 04/06/2019  |
|=====================================================================================|
|Descrição | Etiquetas  				                                          |
|          | Quantidade do Volume da Embalagem                                        |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
Static Function QUANTVOL( __cFil, __VOLUME )

Local cQuery		:= ""
Local __cAlias2  	:= GetNextAlias()
Local nCout			:= 0

Default __cFil		:= ""
Default __VOLUME	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando dados com Query       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := " SELECT * FROM "+RetSqlName("CB9")+"" +CRLF
cQuery += " WHERE D_E_L_E_T_ <> '*'" +CRLF
cQuery += " AND CB9_FILIAL = '"+__cFil+"'" +CRLF
cQuery += " AND CB9_VOLUME = '"+__VOLUME+"'" +CRLF
cQuery += " ORDER BY CB9_PROD, CB9_VOLUME" +CRLF

cQuery := CHANGEQUERY(cQuery)	

/*ARQTQT := GetNextAlias()

	If Select(ARQTQT) >0

	dbSelectArea(ARQTQT)
    dbCloseArea()
    
	EndIf*/

dbUseArea(.T., 'TOPCONN', TcGenQry( ,, cQuery) ,__cAlias2, .T., .F.)
                                                               
DBSelectArea((__cAlias2)) //ABRE O ARQUIVO TEMPORARIO
(__cAlias2)->(DbGoTop())  // ALINHA NO PRIMEIRO REGISTRO

	While (__cAlias2)->(!EOF())

	nCout	+= (__cAlias2)->CB9_QTEEMB  
	
	(__cAlias2)->(dbSkip()) //PULA PARA O PROXIMO REGISTRO DO ARQUIVO TEMPORARIO
	   	
	EndDo

(__cAlias2)->(DbCloseArea())
dbCloseArea()
    
Return (nCout)

/*====================================================================================\
|Programa  | PESOVOL        | Autor | Renan Rosário             | Data | 04/06/2019   |
|=====================================================================================|
|Descrição | Etiquetas  				                                          |
|          | Peso do Volume da Embalagem                                        |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
Static Function PESOVOL( __cFil, __VOLUME )

Local cQuery		:= ""
Local __cAlias3  	:= GetNextAlias()
Local nCout			:= 0

Default __cFil		:= ""
Default __VOLUME	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando dados com Query       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := " SELECT * FROM "+RetSqlName("CB6")+"" +CRLF
cQuery += " WHERE D_E_L_E_T_ <> '*'" +CRLF
cQuery += " AND CB6_FILIAL = '"+__cFil+"'" +CRLF
cQuery += " AND CB6_VOLUME = '"+__VOLUME+"'" +CRLF
cQuery += " ORDER BY CB6_VOLUME" +CRLF

cQuery := CHANGEQUERY(cQuery)	

/*ARQTVL := GetNextAlias()

	If Select(ARQTVL) >0

	dbSelectArea(ARQTVL)
    dbCloseArea()
    
	EndIf*/

dbUseArea(.T., 'TOPCONN', TcGenQry( ,, cQuery) ,__cAlias3, .T., .F.)
                                                               
DBSelectArea((__cAlias3)) //ABRE O ARQUIVO TEMPORARIO
(__cAlias3)->(DbGoTop())  // ALINHA NO PRIMEIRO REGISTRO

	While (__cAlias3)->(!EOF())

	nCout	+= (__cAlias3)->CB6_XPESO
	
	(__cAlias3)->(dbSkip()) //PULA PARA O PROXIMO REGISTRO DO ARQUIVO TEMPORARIO
	   	
	EndDo

(__cAlias3)->(DbCloseArea())
dbCloseArea()

Return (nCout)

/*====================================================================================\
|Programa  | PESOVOL        | Autor | Renan Rosário             | Data | 04/06/2019   |
|=====================================================================================|
|Descrição | Etiquetas  				                                          |
|          | Peso do Volume da Embalagem                                        |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
Static Function TOTVOL ( __cFil, __cPROD, __cPEDIFA  )

Local nTotal		:= 0
Local cQuery		:= ""
Local __cAlias4  	:= GetNextAlias()

Default __cFil		:= ""
Default __VOLUME	:= ""
Default __cPROD		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando dados com Query       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := " SELECT * FROM "+RetSqlName("CB9")+"" +CRLF
cQuery += " WHERE D_E_L_E_T_ <> '*'" +CRLF
cQuery += " AND CB9_FILIAL = '"+__cFil+"'" +CRLF
cQuery += " AND CB9_PEDIDO = '"+__cPEDIFA+"'" +CRLF
cQuery += " AND CB9_PROD   = '"+__cPROD+"'" +CRLF
cQuery += " ORDER BY CB9_PROD" +CRLF

cQuery := CHANGEQUERY(cQuery)

dbUseArea(.T., 'TOPCONN', TcGenQry( ,, cQuery) ,__cAlias4, .T., .F.)
                                                               
DBSelectArea((__cAlias4)) //ABRE O ARQUIVO TEMPORARIO
(__cAlias4)->(DbGoTop())  // ALINHA NO PRIMEIRO REGISTRO

	While (__cAlias4)->(!EOF())

	nTotal	+= (__cAlias4)->CB9_QTESEP
	
	(__cAlias4)->(dbSkip()) //PULA PARA O PROXIMO REGISTRO DO ARQUIVO TEMPORARIO
	   	
	EndDo

(__cAlias4)->(DbCloseArea())
dbCloseArea()

Return (nTotal)


/*/{Protheus.doc} vldSelec
description
Rotina que fará a validação da seleção
@type function
@version  
@author Valdemir Jose
@since 11/08/2021
@return variant, return_description
/*/
Static Function vldSelec()
	Local lRET := .t. 
	Local nSel := 0

	aEval(aEtique, {|X| if(X[11], nSel++, nil) })
	lRet := (nSel > 0)

	if !lRet
       FWMsgRun(,{|| Sleep(3000)},"Informativo","Não foi selecionado nenhum registro")
	endif 

Return lRET
