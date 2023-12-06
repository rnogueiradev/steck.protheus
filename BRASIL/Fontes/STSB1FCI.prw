#include 'PROTHEUS.CH'
#include 'TOPCONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTSB1FCI	บAutor  ณRenato Nogueira     บ Data ณ  16/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte utilizado para atualizar a SB1 conforme informa็๕es   บฑฑ
ฑฑบ          ณda tabela CFD (FCI)				  	 				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum 										              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STSB1FCI()

Local cQuery   		:= ""
Local cAlias   		:= "QRYTEMP"
Local nY			:= 0
Local nX			:= 0
Local lSaida   		:= .T.
Local aSize	   		:= MsAdvSize(.F.)
Local aCampoEdit	:= {}
Local lConfirma		:= .F.
Private	oWindow,;
oFontWin,;
aHead				:= {},;
bOk 				:= {||(	lSaida:=.f., lConfirma:=.T.,oWindow:End()) },;
bCancel 	    	:= {||(	lSaida:=.f.,oWindow:End()) },;
aButtons	    	:= {},;
oGet
Private aHeader		:= {}
Private aCols		:= {}

Aadd(aHeader,{"Confirma"		,"CONFIRMA"		 ,"@!",1 ,0,"",,"C","","R","S=Sim;N=Nใo"})
Aadd(aHeader,{"C๓digo"  		,"CODIGO"  		 ,"@!",15,0,"",,"C","","R",})
Aadd(aHeader,{"Origem fci"  	,"FCI_ORIG"  	 ,"@!",1,0,"",,"C","","R",})
Aadd(aHeader,{"Origem atual"	,"B1_ORIG"   	 ,"@!",1,0,"",,"C","","R",})
Aadd(aHeader,{"NCM"				,"NCM" 	 		 ,"@!",8,0,"",,"C","","R",})

aCampoEdit := {"CONFIRMA"}

cQuery := " SELECT CFD_COD ,MAX(CFD_ORIGEM) AS CFD_ORIGEM ,MAX(B1_ORIGEM) AS B1_ORIGEM, MIN(STATUS) AS STATUS1 ,MAX(B1_POSIPI) AS B1_POSIPI "
cQuery += " FROM ( "
cQuery += " SELECT CFD.CFD_COD,CFD.CFD_ORIGEM,B1_ORIGEM,'1' STATUS, B1_POSIPI FROM UDBP12.CFD010 CFD "
cQuery += " INNER JOIN (SELECT CFD_COD,MAX(R_E_C_N_O_)REC FROM UDBP12.CFD010 WHERE D_E_L_E_T_= ' '  "
cQuery += " GROUP BY CFD_COD)CF ON CF.CFD_COD = CFD.CFD_COD AND CF.REC =CFD.R_E_C_N_O_  "
cQuery += " INNER JOIN UDBP12.SB1010 SB1 ON B1_FILIAL = ' ' AND B1_COD = CFD.CFD_COD AND SB1.D_E_L_E_T_= ' ' "
cQuery += " UNION ALL "
cQuery += " SELECT B1_COD, ' ' , B1_ORIGEM, CASE WHEN SG1.G1_COD IS NULL AND SG12.G1_COD IS NULL THEN '2' "
cQuery += " WHEN SG12.G1_COD IS NULL THEN '3' ELSE '4' END, B1_POSIPI "
cQuery += " FROM UDBP12.SB1010 SB1 "
cQuery += " LEFT JOIN UDBP12.SG1010 SG1 ON SG1.G1_FILIAL <> ' ' AND SG1.G1_COD = B1_COD AND SG1.D_E_L_E_T_= ' ' "
cQuery += " LEFT JOIN UDBP12.SG1030 SG12 ON SG12.G1_FILIAL <> ' ' AND SG12.G1_COD = B1_COD AND SG12.D_E_L_E_T_= ' ' "
cQuery += " WHERE B1_FILIAL = ' ' AND B1_ORIGEM IN ('3','5','8') AND B1_GRUPO <> '999' AND B1_MSBLQL <> '1' AND SB1.D_E_L_E_T_= ' '  ) XXX "
cQuery += " HAVING MAX(CFD_ORIGEM)<>MAX(B1_ORIGEM) AND MAX(CFD_ORIGEM)<>' ' "
cQuery += " GROUP BY CFD_COD "

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

Processa( {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)},"Aguarde...","Carregando tabela temporแria...",.T.)

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())

While (cAlias)->(!Eof())
	
	AADD(aCols,Array(Len(aHeader)+1))
	
	For nY := 1 To Len(aHeader)
		
		DO CASE
			
			CASE AllTrim(aHeader[nY][2]) =  "CONFIRMA"
				aCols[Len(aCols)][nY] := "S"
			CASE AllTrim(aHeader[nY][2]) =  "CODIGO"
				aCols[Len(aCols)][nY] := (cAlias)->CFD_COD
			CASE AllTrim(aHeader[nY][2]) =  "FCI_ORIG"
				aCols[Len(aCols)][nY] := (cAlias)->CFD_ORIGEM
			CASE AllTrim(aHeader[nY][2]) =  "B1_ORIG"
				aCols[Len(aCols)][nY] := (cAlias)->B1_ORIGEM
			CASE AllTrim(aHeader[nY][2]) =  "NCM"
				aCols[Len(aCols)][nY] := (cAlias)->B1_POSIPI
				
		ENDCASE
		
	Next
	
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	
	(cAlias)->(DbSkip())
EndDo

While lSaida
	
	DEFINE MSDIALOG oWindow FROM 0,0 TO aSize[6],aSize[5]/*500,1200*/ TITLE Alltrim(OemToAnsi('Ajuste de origem')) Pixel //430,531
	
	oGet	:= MsNewGetDados():New( 0,  0,  270,650, GD_UPDATE ,"AllWaysTrue()","AllWaysTrue()",,aCampoEdit,,Len(aCols),,, ,oWindow, aHeader, aCols )
	MsNewGetDados():SetEditLine (.T.)
	
	ACTIVATE MSDIALOG oWindow CENTERED ON INIT EnchoiceBar(oWindow,bOk,bCancel,,aButtons)
	
End

aCols:= aClone(oGet:aCols)

If lConfirma .And. MsgYesNo('Confirma as altera็๕es no cadastro de produto?')
	
	Processa( {|| U_STSB1ACI(aCols)}, "Aguarde...","Executando altera็๕es...", .T. )
	
	MsgInfo("Processamento finalizado")
	
EndIf

aCols:= aClone(oGet:aCols)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTSB1FCI	บAutor  ณRenato Nogueira     บ Data ณ  16/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte utilizado para atualizar a SB1 conforme informa็๕es   บฑฑ
ฑฑบ          ณda tabela CFD (FCI)				  	 				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum 										              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STSB1ACI()

Local nX	:= 0

For nX:=1 To Len(aCols)
	
	If AllTrim(aCols[nX][1])=="S"
		
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())
		
		If SB1->(DbSeek(xFilial("SB1")+aCols[nX][2]))
			
			DbSelectArea("SZ4")
			SZ4->(DbSetOrder(1))
			SZ4->(DbGoTop())
			SZ4->(DbSeek(xFilial("SZ4")+SB1->B1_XGATCL))
			
			SB1->(RecLock("SB1",.F.))
			SB1->B1_ORIGEM	:= aCols[nX][3]
			
			IF SZ4->(!Eof())
				SB1->B1_GRTRIB 	:= IIF(aCols[nX][3]$"0/5",SZ4->Z4_GRTRIB,IIF(aCols[nX][3]$"1/3/8",SZ4->Z4_GRTRIB1,""))
			EndIf
			
			SB1->(MsUnLock())
			
		EndIf
		
	EndIf
	
Next

Return()
