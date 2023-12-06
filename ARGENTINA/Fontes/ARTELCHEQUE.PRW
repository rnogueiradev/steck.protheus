#INCLUDE "FINA840.ch"
#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | ARTELCHEQUE        | Autor | GIOVANI.ZAGO           | Data | 28/01/2013  |
|=====================================================================================|
|Descrição |   ARTELCHEQUE  	                                  					  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ARTELCHEQUE                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------* 
User Function ARTELCHEQUE(xaC,xaCpos,xnRecs)
*-----------------------------* 
	Private oEdit1,oEdit2,oEdit3,oEdit4,oEdit5,oEdit6,oEdit7,oEdit8,oEdit9
	Private _lRet		:= .f.
	Private cLeitura 	:= Space(60)
	Private cBanco 		:= Space(3)
	Private cAgencia 	:= Space(5)
	Private cCodigo 	:= Space(4)
	Private cNumero 	:= Space(15)
	Private cConta 		:= Space(12)
	Private dVenc 		:= ddatabase
	Private dEmis 		:= ddatabase
	Private nValor 		:= 0
	Private aC 			:= {}
	Private aCpos 		:= xaCpos
	Private nRecs 		:= xnRecs
	Private _oDlg
	Private INCLUI   := .F.
	
	Default aC:= {}
	
 
	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Cadastro de Cheque.") FROM C(130),C(343) TO C(549),C(621) PIXEL
	
	/*
	259 - banco
	031 -agencia
	1653 - codigo postal
	00747760 -numero cheque
	008816711009 - conta
*/


	@ C(008),C(009) Say "Leitura:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(013),C(010) MsGet oEdit1 Var cLeitura Size C(65),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60" VALID CHQ(cLeitura)  //Action(cBanco:= substr(cLeitura,2,3))
	
	@ C(028),C(009) Say "Banco:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(033),C(010) MsGet oEdit2 Var cBanco Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
	
	@ C(048),C(009) Say "Agencia:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(053),C(010) MsGet oEdit3 Var cAgencia Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
	
	@ C(068),C(009) Say "Codigo Postal:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(073),C(010) MsGet oEdit4 Var cCodigo Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
	
	@ C(088),C(009) Say "Numero:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(093),C(010) MsGet oEdit5 Var cNumero Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
	
	@ C(108),C(009) Say "Conta:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(113),C(010) MsGet oEdit6 Var cConta Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
	
	@ C(128),C(009) Say "Emissão:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(133),C(010) MsGet oEdit7 Var dEmis Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	
	@ C(148),C(009) Say "Vencimento:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(153),C(010) MsGet oEdit8 Var dVenc Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	
	@ C(168),C(009) Say "Valor:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(173),C(010) MsGet oEdit9 Var nValor Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@e 999,999.99"
	
	@ C(190),C(50) Button OemtoAnsi("Gravar") Size C(037),C(012) PIXEL OF _oDlg	Action Eval( { || Gravar() }  )
	@ C(190),C(85) Button OemtoAnsi("Anular") Size C(037),C(012) PIXEL OF _oDlg	Action(_oDlg:End())


	ACTIVATE MSDIALOG _oDlg CENTERED
	 
 
Return(aC)


Static Function chq(cLeitura)
	If Len(cLeitura) = 33
		cLeitura	:= substr(cLeitura,2,31)
	EndIf
	cBanco		:= substr(cLeitura,2,3)
	cAgencia 	:= substr(cLeitura,5,3)+'  '
	cCodigo 	:= substr(cLeitura,8,4)
	cNumero 	:= substr(cLeitura,12,8)
	cConta 		:= substr(cLeitura,20,11)
	 

Return(.t.)

Static Function GRAVAR()
	Local nX	:= 0
	Local nCols := 0 
	Local nA:=0
	
	If Len(aC) = 0
		aC := Array(1,Len(aCpos)+nRecs)
	Else
		Aadd(aC ,Array( Len(aCpos)+nRecs))
		 
	EndIf
		 
		
	SX3->(DBSetOrder(2))
	For nA:=1 to Len(aCpos)
		If SX3->(DbSeek(Alltrim(aCpos[nA]))) 	 .And. Alltrim(aCpos[nA]) $ "EL_NUMERO"
			aC[Len(aC)][nA]   := cNumero
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA]))) .And. Alltrim(aCpos[nA]) $ "EL_VALOR"
			aC[Len(aC)][nA]   := nValor
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA]))) .And. Alltrim(aCpos[nA]) $ "EL_EMISSAO"
			aC[Len(aC)][nA]   := dEmis
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA]))) .And. Alltrim(aCpos[nA]) $ "EL_DTVCTO"
			aC[Len(aC)][nA]   := dVenc
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA]))) .And. Alltrim(aCpos[nA]) $ "EL_BCOCHQ"
			aC[Len(aC)][nA]   := cBanco
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA]))) .And. Alltrim(aCpos[nA]) $ "EL_AGECHQ"
			aC[Len(aC)][nA]   := cAgencia
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA]))) .And. Alltrim(aCpos[nA]) $ "EL_POSTAL"
			aC[Len(aC)][nA]   := cCodigo
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA]))) .And. Alltrim(aCpos[nA]) $ "EL_CTACHQ"
			aC[Len(aC)][nA]   := cConta
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA]))) .And. Alltrim(aCpos[nA]) $ "EL_BANCO"
			aC[Len(aC)][nA]   := 'CAR'
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA]))) .And. Alltrim(aCpos[nA]) $ "EL_AGENCIA"
			aC[Len(aC)][nA]   := '002  '
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA]))) .And. Alltrim(aCpos[nA]) $ "EL_CONTA"
			aC[Len(aC)][nA]   := '002       '
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA]))) .And. Alltrim(aCpos[nA]) $ "EL_TIPO"
			aC[Len(aC)][nA]   := 'PGR'
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA]))) .And. Alltrim(aCpos[nA]) $ "EL_TIPODOC"
			aC[Len(aC)][nA]   := 'CH'
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA]))) .And. Alltrim(aCpos[nA]) $ "EL_PREFIXO"
			aC[Len(aC)][nA]   := 'PGR'
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA])))
			aC[Len(aC)][nA]   := CriaVar(Alltrim(aCpos[nA]),.F.)
		Else
			aC[Len(aC)][nA]   := &(Alltrim(aCpos[nA]))
		Endif
	Next
	aC[Len(aC)][Len(aC[1])]:=.F.
	
 
	cLeitura 	:= Space(60)
	cBanco 		:= Space(3)
	cAgencia 	:= Space(5)
	cCodigo 	:= Space(4)
	cNumero 	:= Space(8)
	cConta 		:= Space(12)
	dVenc 		:= ddatabase
	dEmis 		:= ddatabase
	nValor 		:= 0
 
Return(.T.)



*-----------------------------* 
User Function CHQTEL()
*-----------------------------* 
	Private oEdit1,oEdit2,oEdit3,oEdit4,oEdit5,oEdit6,oEdit7,oEdit8,oEdit9
	Private _lRet		:= .f.
	Private cLeitura 	:= Space(60)
	Private cBanco 		:= Space(3)
	Private cAgencia 	:= Space(5)
	Private cCodigo 	:= Space(4)
	Private cNumero 	:= Space(15)
	Private cConta 		:= Space(12)
	Private dVenc 		:= ddatabase
	Private dEmis 		:= ddatabase
	Private nValor 		:= 0
	Private aC 			:= {}
	Private aCpos 		:= AHEADER
	Private nRecs 		:= 1
	Private _oDlg
	Private INCLUI   := .F.
	
	Default aC:= {}
	
 
	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Cadastro de Cheque.") FROM C(130),C(343) TO C(549),C(621) PIXEL
	
	/*
	259 - banco
	031 -agencia
	1653 - codigo postal
	00747760 -numero cheque
	008816711009 - conta
*/


	@ C(008),C(009) Say "Leitura:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(013),C(010) MsGet oEdit1 Var cLeitura Size C(65),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60" VALID lCHQ(cLeitura)  //Action(cBanco:= substr(cLeitura,2,3))
	
	@ C(028),C(009) Say "Banco:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(033),C(010) MsGet oEdit2 Var cBanco Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
	
	@ C(048),C(009) Say "Agencia:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(053),C(010) MsGet oEdit3 Var cAgencia Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
	
	@ C(068),C(009) Say "Codigo Postal:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(073),C(010) MsGet oEdit4 Var cCodigo Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
	
	@ C(088),C(009) Say "Numero:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(093),C(010) MsGet oEdit5 Var cNumero Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
	
	@ C(108),C(009) Say "Conta:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(113),C(010) MsGet oEdit6 Var cConta Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
	
	@ C(128),C(009) Say "Emissão:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(133),C(010) MsGet oEdit7 Var dEmis Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	
	@ C(148),C(009) Say "Vencimento:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(153),C(010) MsGet oEdit8 Var dVenc Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	
	@ C(168),C(009) Say "Valor:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(173),C(010) MsGet oEdit9 Var nValor Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@e 999,999.99"
	
	@ C(190),C(50) Button OemtoAnsi("Gravar") Size C(037),C(012) PIXEL OF _oDlg	Action Eval( { || LGravar() }  )
	@ C(190),C(85) Button OemtoAnsi("Anular") Size C(037),C(012) PIXEL OF _oDlg	Action(_oDlg:End())


	ACTIVATE MSDIALOG _oDlg CENTERED
	 
 aCOLS:= ac
Return(.F.)


Static Function lchq(cLeitura)
	If Len(cLeitura) = 33
		cLeitura	:= substr(cLeitura,2,31)
	EndIf
	cBanco		:= substr(cLeitura,2,3)
	cAgencia 	:= substr(cLeitura,5,3)+'  '
	cCodigo 	:= substr(cLeitura,8,4)
	cNumero 	:= substr(cLeitura,12,8)
	cConta 		:= substr(cLeitura,20,11)
	 

Return(.t.)

Static Function LGRAVAR()
	Local nX	:= 0
	Local nCols := 0 
	Local nA	:= 0
	
	If Len(aC) = 0
		aC := Array(1,Len(aCpos))
	Else
		Aadd(aC ,Array( Len(aCpos)))		 
	EndIf
	 
		
	SX3->(DBSetOrder(2))
	For nA:=1 to Len(aCpos)
		If SX3->(DbSeek(Alltrim(aCpos[nA,2]))) 	 .And. Alltrim(aCpos[nA,2]) $ "EL_NUMERO"
			aC[Len(aC)][nA]   := cNumero
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA,2]))) .And. Alltrim(aCpos[nA,2]) $ "EL_VALOR"
			aC[Len(aC)][nA,2]   := nValor
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA,2]))) .And. Alltrim(aCpos[nA,2]) $ "EL_EMISSAO"
			aC[Len(aC)][nA,2]   := dEmis
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA,2]))) .And. Alltrim(aCpos[nA,2]) $ "EL_DTVCTO"
			aC[Len(aC)][nA,2]   := dVenc
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA,2]))) .And. Alltrim(aCpos[nA,2]) $ "EL_BCOCHQ"
			aC[Len(aC)][nA,2]   := cBanco
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA,2]))) .And. Alltrim(aCpos[nA,2]) $ "EL_AGECHQ"
			aC[Len(aC)][nA,2]   := cAgencia
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA,2]))) .And. Alltrim(aCpos[nA,2]) $ "EL_POSTAL"
			aC[Len(aC)][nA,2]   := cCodigo
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA,2]))) .And. Alltrim(aCpos[nA,2]) $ "EL_CTACHQ"
			aC[Len(aC)][nA,2]   := cConta
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA,2]))) .And. Alltrim(aCpos[nA,2]) $ "EL_BANCO"
			aC[Len(aC)][nA,2]   := '259'
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA,2]))) .And. Alltrim(aCpos[nA,2]) $ "EL_AGENCIA"
			aC[Len(aC)][nA,2]   := '029  '
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA,2]))) .And. Alltrim(aCpos[nA,2]) $ "EL_CONTA"
			aC[Len(aC)][nA,2]   := '0604794100     '
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA,2]))) .And. Alltrim(aCpos[nA,2]) $ "EL_TIPO"
			aC[Len(aC)][nA,2]   := 'PGR'
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA,2]))) .And. Alltrim(aCpos[nA,2]) $ "EL_TIPODOC"
			aC[Len(aC)][nA,2]   := 'CH'
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA,2]))) .And. Alltrim(aCpos[nA,2]) $ "EL_PREFIXO"
			aC[Len(aC)][nA,2]   := 'PGR'
		ElseIf SX3->(DbSeek(Alltrim(aCpos[nA,2])))
			aC[Len(aC)][nA,2]   := CriaVar(Alltrim(aCpos[nA,2]),.F.)
		Else
			aC[Len(aC)][nA,2]   := &(Alltrim(aCpos[nA,2]))
		Endif
	Next
	aC[Len(aC)][Len(aC[1])]:=.F.
	
 
	cLeitura 	:= Space(60)
	cBanco 		:= Space(3)
	cAgencia 	:= Space(5)
	cCodigo 	:= Space(4)
	cNumero 	:= Space(8)
	cConta 		:= Space(12)
	dVenc 		:= ddatabase
	dEmis 		:= ddatabase
	nValor 		:= 0
 
Return(.T.)


 