#Include "PROTHEUS.CH"
#Include "HBUTTON.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE ENTER CHAR(13) + CHAR(10)

//--------------------------------------------------------------
/*/Protheus.doc Job para tansferência automática das OPS 
Description
author: Jackson Santos
return xRet Return Description
author  -
since
/*/
//--------------------------------------------------------------

User Function JOBTRFOP(lJobExec,cOpProc)


	Private nqtdExec   := 0	
	Private _lok       := .F.	

	Default lJobExec :=".T."
	Default cOpProc  := ""
	If IsBlind() .Or. &(lJobExec)
		cNewEmp := "03"
		cNewFil := "01"
		Reset Environment
		RpcSetType( 3 )
		RpcSetEnv( cNewEmp, cNewFil,,,"PCP")
	EndIf
	CONOUT("JOBTRFOP-Mominitoramento de Transferência(s)-INICIO da Analise e Transferência(s), possíveis, pendentes. Hora:" + Time() + " Data: " + DTOC(DDATABASE) )
	//Processar atualização do job
	ProcessaJob(cOpProc)
	
	CONOUT("JOBTRFOP-Mominitoramento de Transferência(s)-INICIO da Analise e Transferência(s), possíveis, pendentes. Hora:" + Time() + " Data: " + DTOC(DDATABASE) )

	If IsBlind() .Or. &(lJobExec)
		Reset Environment
	EndIf
Return



Static Function ProcessaJob(cOpProc)
	Local cQuery:= ""
	Local aItensTrf := {}

	If select("QRY2") > 0
		QRY2->(dbClosearea())
	Endif
	//UDBP12."
	cQuery := "SELECT ZA0_CODOP OP,ZA0_PRODOP,ZA0_CODIGO,R_E_C_N_O_ RECZA0 "
	cQuery += ENTER +  " FROM " + RetSqlName("ZA0") + " ZA0 "
	cQuery += ENTER +  " WHERE ZA0.D_E_L_E_T_ <> '*' AND ZA0.ZA0_FILIAL = '" + xFilial("ZA0") + "'" 
	cQuery += ENTER +  " AND ZA0_STATMV = '1' "
	
	
   TCQUERY cQuery NEW ALIAS "QRY2"
	//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY2",.T.,.T.)
	CONOUT("JOBTRFOP-Mominitoramento de Transferência(s)-Selecionados dados para processamento. Hora:" + Time() + " Data: " + DTOC(DDATABASE) )

	If QRY2->(!eof())
		
		While QRY2->(!eof())
			
			Aadd(aItensTrf,{QRY2->OP,QRY2->ZA0_PRODOP,QRY2->ZA0_CODIGO,QRY2->RECZA0})
			//Endif
			QRY2->(DbSkip())
		EndDo
	EndIF
	If !Empty(cOpProc)
		Aadd(aItensTrf,{cOpProc,"",""})
	EndIf
	QRY2->(dbCloseArea())

	//Processa transf
	IF Len(aItensTrf) > 0
		CONOUT("JOBTRFOP-Mominitoramento de Transferência(s)-Iniciando transferencias possiveis. Hora:" + Time() + " Data: " + DTOC(DDATABASE) )
		ProcTransf(aItensTrf)
		CONOUT("JOBTRFOP-Mominitoramento de Transferência(s)-Finalizando transferencias possiveis. Hora:" + Time() + " Data: " + DTOC(DDATABASE) )
	EndIF
Return

Static Function ProcTransf(aItensTrf)
Local lRet := .T.
Default aItensTrf := {}
Local cOrdSep       := ""
Local cPedido   := ""
Local cOrdProd  := ""
Local cOperador    := ""

Local nk 		:= 0 
Local aOpsExec  := {}
Local cQuery    := ""



//Fazer o tratamento do Array para transferir apenas 1 vez a OP.
For nK:=1 To Len(aItensTrf)	
	cQuery := " SELECT CB7_FILIAL,CB7_ORDSEP,CB7_OP "
	cQuery += " FROM "+ RetSqlName("CB7") + " CB7 " 
	cQuery += " WHERE CB7.D_E_L_E_T_ <> '*' " 
	cQuery += " AND CB7.CB7_FILIAL  ='" + xFilial("CB7") + "'" 
	cQuery += " AND CB7.CB7_OP = '" + aItensTrf[nK][1] + "' "

	If Select("QRY1") > 0
		QRY1->(dbCloseArea())
	EndIf
	TCQUERY cQuery NEW ALIAS "QRY1"
	IF QRY1->(!EOF())
		cQrySD4 := " SELECT D4_FILIAL,D4_OP,D4_QUANT,D4_DATA,D4_LOCAL FROM " + RetSqlName("SD4") + " WHERE D_E_L_E_T_ <> '*' " 
		cQrySD4 += " AND D4_FILIAL = '" +  xFilial("CB7") + "'  AND D4_OP = '" + Alltrim(aItensTrf[nK][1]) + "' AND D4_LOCAL = '01' "
		cQrySD4 += " AND D4_QUANT > 0 "
		If Select("TBSD4") > 0
			TBSD4->(dbCloseArea())
		Endif
		TCQUERY cQrySD4 NEW ALIAS "TBSD4"

		iF TBSD4->(!EOF())
			AaDd(aOpsExec,{QRY1->CB7_FILIAL,QRY1->CB7_ORDSEP}) 
		else
			//Atualiza o status das transferências pois já foi realizada anteriormente - de outra forma.
			U_STKGLGOP(aItensTrf[nK][3],Alltrim(aItensTrf[nK][1]),aItensTrf[nK][2],__cUserID,+SubStr(cUsuario, 7, 15),DDataBase,Time(),Funname(),;
							"","OS." + QRY1->CB7_ORDSEP + "->Transferência Realizada anteriormente Com Sucesso, nao há mais dados a serem  transferidos." ,"2",DDataBase,Time(),Funname(),aItensTrf[Nk][4])
		EndIf

		If Select("TBSD4") > 0
			TBSD4->(dbCloseArea())
		Endif
	else
		//Atualiza o status das transferências pois já foi realizada anteriormente - de outra forma.
		U_STKGLGOP(aItensTrf[nK][3],Alltrim(aItensTrf[nK][1]),aItensTrf[nK][2],__cUserID,+SubStr(cUsuario, 7, 15),DDataBase,Time(),Funname(),;
						"","OS." + QRY1->CB7_ORDSEP + "->Ordem de separacao nao localizada para o movimento." ,"2",DDataBase,Time(),Funname(),aItensTrf[Nk][4])
	EndIf
	If Select("QRY1") > 0
		QRY1->(dbCloseArea())
	EndIf	
Next nK

//Inicia as Transferências
If Len(aOpsExec) >0
	For nk:=1 To Len(aOpsExec)
		CB7->(DbSetOrder(1))
		If CB7->(DbSeek( aOpsExec[nK][1]+ aOpsExec[nK][2]))//Pesquisa a Ordem de separação
			cOrdSep     := CB7->CB7_ORDSEP
			cPedido 	:= CB7->CB7_PEDIDO 
			cOrdProd    := CB7->CB7_OP 
			cOperador 	:= CB7->CB7_CODOPE //operador estoque

			CB8->(OrdSetFocus(1))
			If CB8->(Dbseek(CB7->CB7_FILIAL + cOrdSep ))
				//Posiciona na CB8 e processa a rotina de transferência do coletor.
				
				CONOUT("JOBTRFOP-Mominitoramento de Transferência(s)-INICIO Transferncia OP: " + cOrdProd + " Ordem Sepracao:" + cOrdSep + ". Hora:" + Time() + " Data: " + DTOC(DDATABASE) )
	
				U_STTranArm(cPedido,cOrdProd,cOperador,.F./*Tela*/)	
				
				CONOUT("JOBTRFOP-Mominitoramento de Transferência(s)-FIM Transferncia OP: " + cOrdProd + " Ordem Sepracao:" + cOrdSep + ". Hora:" + Time() + " Data: " + DTOC(DDATABASE) )
	
			Endif			
		EndIf
	Next nK
Endif 

Return lRet


