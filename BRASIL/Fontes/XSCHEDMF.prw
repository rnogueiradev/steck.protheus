#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"
#Define CR chr(13)+chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSELMANIF	บAutor  ณRenato Nogueira     บ Data ณ  03/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte utilizado para selecionar as chaves que serใo feitas  บฑฑ
ฑฑบ          ณa manifesta็ใo 											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function XSCHEDMF()
	
	Local nY			:= 0
	Local nX			:= 0
	Local lSaida   		:= .T.
	Local aSize	   		:= MsAdvSize(.F.)
	Local aCampoEdit	:= {}
	Local lConfirma		:= .F.
	Local cQuery 		:= ""
	Local cAlias 		:= "QRYTEMP"
	Local nColMani		:= 0
	Local aArea			:= {}
	Local aAreaSM0		:= {}
	Local _nPosChave	:= 0
	Local	oWindow,;
		oFontWin,;
		aHead				:= {},;
		bOk 				:= {||(	lSaida:=.f., lConfirma:=.T.,oWindow:End()) },;
		bCancel 	    	:= {||(	lSaida:=.f.,oWindow:End()) },;
		aButtons	    	:= {},;
		oGet
	Local aHeader		:= {}
	Local aCols	 		:= {}
	Local cQry := " "
	
	RpcSetType( 3 )
	RpcSetEnv("01","04",,,"FAT")
	
	
	cQry := " UPDATE SB2010 SET B2_RESERVA = 0 WHERE B2_RESERVA <> 0 "
	TcSQLExec(cQry)
	conout("upd sb2")
	cQry := " UPDATE SB2030 SET B2_RESERVA = 0 WHERE B2_RESERVA <> 0 "
	TcSQLExec(cQry)
	
	cQry := " UPDATE SB2010 SET  B2_QEMP = 0 WHERE B2_QEMP <> 0 "
	TcSQLExec(cQry)
	
	cQry := " UPDATE SB2030 SET  B2_QEMP = 0 WHERE B2_QEMP <> 0 "
	TcSQLExec(cQry)
	
	
	cQry := " UPDATE SC6030 SET C6_LOCAL  = '15' WHERE C6_OPER = '15' AND C6_LOCAL <> '15'
	TcSQLExec(cQry)
	//conout("sql sb2")
	
	cCnpj	:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")
Return()//desabilitado giovani zago	09/06/17
If !U_XCNPJAUT(cCnpj)
	MsgAlert("Aten็ใo, este CNPJ nใo estแ autorizado para utilizar a rotina")
Return()
EndIf
/*
MsgAlert("Esta ้ uma versใo de teste e irแ expirar no dia 15/06/2015")
If date()>CTOD("15/06/2015")
	MsgAlert("Aten็ใo, o tempo de uso da funcionalidade expirou, entre em contato com o Administrador!")
Return()
EndIf
*/
DbSelectArea("SX3")
SX3->(DbGoTop())
SX3->(DbSetOrder(1))
SX3->(DbSeek("SZ9"))

//Monta cabe็alho
Aadd(aHeader,{"Status"		 , "COR"		  , "@BMP"				,    1   ,      0 ,.T.			,       ,""     ,""     ,"R"		,""			  ,            "",            .F.,            "V",            "",            "",            "",            ""})
Aadd(aHeader,{"Manifesta็ใo" , "Z9_MANIF" 	  , "@!" 				,    1   ,      0 ,"U_VLDSTAT()",   	,"C" 	,""		,"R"		,"1=Confirma็ใo da opera็ใo;2=Desconhecimento da opera็ใo;3=Opera็ใo nใo realizada;4=Ci๊ncia da opera็ใo;5=Nใo processar"})

While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="SZ9"
	
	If !AllTrim(SX3->X3_CAMPO)$"Z9_STATUS#Z9_XML#Z9_DOC#Z9_SERIE"
		
		Aadd(aHeader,{SX3->X3_TITULO  ,SX3->X3_CAMPO  ,SX3->X3_PICTURE  ,SX3->X3_TAMANHO  ,SX3->X3_DECIMAL  ,""        ,     ,SX3->X3_TIPO  ,SX3->X3_CONTEXT})
		
	EndIf
	//            																						  allwaystrue usado                                ,cbox
	SX3->(DbSkip())
	
EndDo

nColMani	:= aScan(aHeader,{|x| Trim(x[2])=="Z9_MANIF"})
_nPosChave	:= aScan(aHeader,{|x| Trim(x[2])=="Z9_CHAVE"})

aCampoEdit := {"Z9_MANIF"}

aAreaSM0	:= GetArea("SM0")
aArea		:= GetArea()

//Abrir threads por empresa da fun็ใo conslote
DbSelectArea("SM0")
SM0->(DbSetOrder(1))
SM0->(DbGoTop())

While SM0->(!Eof())
	
	If !U_XCNPJAUT(SM0->M0_CGC)
		MsgAlert("Aten็ใo, o CNPJ: "+SM0->M0_CGC+" nใo estแ autorizado para utilizar a rotina")
		SM0->(DbSkip())
	EndIf
	
	If  (SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="01") .Or.;
			(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="02") .Or.;
			(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="03") .Or.;
			(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="04") .Or.;
			(SM0->M0_CODIGO=="03" .And. SM0->M0_CODFIL=="01")
		If SM0->M0_CODIGO == '01' //AllTrim(SM0->M0_CGC)=="05890658000482"  //Coloquei s๓ a empresa 01/04, depois ้ s๓ tirar isso e rodar de novo
			StartJob("U_CONSLOTE",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL,_nPosChave)
			StartJob("U_CONSNFE",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL,_nPosChave)
			
		EndIf
	EndIf
	
	SM0->(DbSkip())
	
EndDo

RestArea(aArea)
RestArea(aAreaSM0)

Reset Environment

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSELMANIF	บAutor  ณRenato Nogueira     บ Data ณ  03/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte utilizado para selecionar as chaves que serใo feitas  บฑฑ
ฑฑบ          ณa manifesta็ใo 											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AMXSCHEDMF()
	
	Local nY			:= 0
	Local nX			:= 0
	Local lSaida   		:= .T.
	Local aSize	   		:= MsAdvSize(.F.)
	Local aCampoEdit	:= {}
	Local lConfirma		:= .F.
	Local cQuery 		:= ""
	Local cAlias 		:= "QRYTEMP"
	Local nColMani		:= 0
	Local aArea			:= {}
	Local aAreaSM0		:= {}
	Local _nPosChave	:= 0
	Local	oWindow,;
		oFontWin,;
		aHead				:= {},;
		bOk 				:= {||(	lSaida:=.f., lConfirma:=.T.,oWindow:End()) },;
		bCancel 	    	:= {||(	lSaida:=.f.,oWindow:End()) },;
		aButtons	    	:= {},;
		oGet
	Local aHeader		:= {}
	Local aCols	 		:= {}
Return()//desabilitado giovani zago	09/06/17
RpcSetType( 3 )
RpcSetEnv("01","04",,,"FAT")

//Pergunte("XSCHEDMF", .F.)

cCnpj	:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")

If !U_XCNPJAUT(cCnpj)
	MsgAlert("Aten็ใo, este CNPJ nใo estแ autorizado para utilizar a rotina")
Return()
EndIf
/*
MsgAlert("Esta ้ uma versใo de teste e irแ expirar no dia 15/06/2015")
If date()>CTOD("15/06/2015")
	MsgAlert("Aten็ใo, o tempo de uso da funcionalidade expirou, entre em contato com o Administrador!")
Return()
EndIf
*/
DbSelectArea("SX3")
SX3->(DbGoTop())
SX3->(DbSetOrder(1))
SX3->(DbSeek("SZ9"))

//Monta cabe็alho
Aadd(aHeader,{"Status"		 , "COR"		  , "@BMP"				,    1   ,      0 ,.T.			,       ,""     ,""     ,"R"		,""			  ,            "",            .F.,            "V",            "",            "",            "",            ""})
Aadd(aHeader,{"Manifesta็ใo" , "Z9_MANIF" 	  , "@!" 				,    1   ,      0 ,"U_VLDSTAT()",   	,"C" 	,""		,"R"		,"1=Confirma็ใo da opera็ใo;2=Desconhecimento da opera็ใo;3=Opera็ใo nใo realizada;4=Ci๊ncia da opera็ใo;5=Nใo processar"})

While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="SZ9"
	
	If !AllTrim(SX3->X3_CAMPO)$"Z9_STATUS#Z9_XML#Z9_DOC#Z9_SERIE"
		
		Aadd(aHeader,{SX3->X3_TITULO  ,SX3->X3_CAMPO  ,SX3->X3_PICTURE  ,SX3->X3_TAMANHO  ,SX3->X3_DECIMAL  ,""        ,     ,SX3->X3_TIPO  ,SX3->X3_CONTEXT})
		
	EndIf
	//            																						  allwaystrue usado                                ,cbox
	SX3->(DbSkip())
	
EndDo

nColMani	:= aScan(aHeader,{|x| Trim(x[2])=="Z9_MANIF"})
_nPosChave	:= aScan(aHeader,{|x| Trim(x[2])=="Z9_CHAVE"})

aCampoEdit := {"Z9_MANIF"}

aAreaSM0	:= GetArea("SM0")
aArea		:= GetArea()

//Abrir threads por empresa da fun็ใo conslote
DbSelectArea("SM0")
SM0->(DbSetOrder(1))
SM0->(DbGoTop())

While SM0->(!Eof())
	
	If !U_XCNPJAUT(SM0->M0_CGC)
		MsgAlert("Aten็ใo, o CNPJ: "+SM0->M0_CGC+" nใo estแ autorizado para utilizar a rotina")
		SM0->(DbSkip())
	EndIf
	
	If  (SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="01") .Or.;
			(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="02") .Or.;
			(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="03") .Or.;
			(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="04") .Or.;
			(SM0->M0_CODIGO=="03" .And. SM0->M0_CODFIL=="01")
		If SM0->M0_CODIGO == '03' //AllTrim(SM0->M0_CGC)=="05890658000482"  //Coloquei s๓ a empresa 01/04, depois ้ s๓ tirar isso e rodar de novo
			StartJob("U_CONSLOTE",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL,_nPosChave)
			StartJob("U_CONSNFE",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL,_nPosChave)
		EndIf
	EndIf
	
	SM0->(DbSkip())
	
EndDo

RestArea(aArea)
RestArea(aAreaSM0)

Reset Environment

Return()

User Function XMLX6()
	

	RpcSetType( 3 )
	RpcSetEnv("01","04",,,"FAT")
	
	
	
	DbSelectArea("SM0")
	SM0->(DbSetOrder(1))
	SM0->(DbGoTop())
	
	While SM0->(!Eof())
		
		
		If  (SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="01") .Or.;
				(SM0->M0_CODIGO=="03" .And. SM0->M0_CODFIL=="01")
			
			
			StartJob("U_XMLX601",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL)
			
		EndIf
		
		SM0->(DbSkip())
		
	EndDo
Return()

User Function XMLX601(_cEm,_cFil)
	
	
	RpcSetType( 3 )
	RpcSetEnv(_cEm,_cFil,,,"FAT")
	
	
	DbSelectArea("SX6")
	SX6->(DbGoTop())
	SX6->(DbSetOrder(1))
	//	If SX6->(DbSeek(_cFil+"ST_NSU"))
	
	While SX6->(!Eof())
		If AllTrim(SX6->X6_VAR)=="ST_NSUNFEW" 
			/* Removido\Ajustado - Nใo executa mais RecLock na X6. Cria็ใo/altera็ใo de dados deve ser feita apenas pelo m๓dulo Configurador ou pela rotina de atualiza็ใo de versใo.
			SX6->(RecLock("SX6",.F.))
			SX6->X6_CONTEUD	:= "000000000000001"
			SX6->(MsUnLock())*/
		EndIf
		If  AllTrim(SX6->X6_VAR)=="ST_NSUCTE"
			/* Removido\Ajustado - Nใo executa mais RecLock na X5. Cria็ใo/altera็ใo de dados deve ser feita apenas pelo m๓dulo Configurador ou pela rotina de atualiza็ใo de versใo.
			SX6->(RecLock("SX6",.F.))
			If _cEm = '01'
			SX6->X6_CONTEUD	:= "000000000295723"
			Else
			SX6->X6_CONTEUD	:= "000000000015806"
			EndIf
			SX6->(MsUnLock())*/
			 
		EndIf
		
		 
		SX6->(DbSkip())
		
	EndDo
	
	//EndIf
	
	
Return()






*---------------------------*
User Function ZZJDUPLIC()
	*---------------------------*
	Local _aArea	  := GetArea()
	Local cAliasLif   := 'ZZJDUPLIC'
	Local cQuery      := ' '
	Local _nQtdDisp   := 0
	Local _cProdx     := ' '
	Local cQry 		  := ' '
	Private cAliasSc6 := ' '
	
	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")
	
	cQuery:= "	select DISTINCT ZZJ_NUM,ZZJ.ZZJ_OP from zzj010 ZZJ WHERE ZZJ.D_E_L_E_T_ = ' ' AND EXISTS (select * from zzj010 TZJ WHERE TZJ.D_E_L_E_T_ = ' ' AND TZJ.ZZJ_NUM = ZZJ.ZZJ_NUM AND TZJ.R_E_C_N_O_ <> ZZJ.R_E_C_N_O_ )
	
	cQuery := ChangeQuery(cQuery)
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		While !(cAliasLif)->(Eof())
			_nQtdDisp++
			(cAliasLif)->(dbSkip())
		End
		
	EndIf
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	If _nQtdDisp > 0
		//passo 2
		cQry := " 	UPDATE ZZJ010 SET ZZJ_NUM = '999999' WHERE ZZJ_NUM IN( select DISTINCT ZZJ.ZZJ_NUM from zzj010 ZZJ WHERE ZZJ.D_E_L_E_T_ = ' ' AND EXISTS (select * from zzj010 TZJ WHERE TZJ.D_E_L_E_T_ = ' ' AND TZJ.ZZJ_NUM = ZZJ.ZZJ_NUM and TZJ.r_e_c_n_o_ <>  ZZJ.r_e_c_n_o_ ) )
		TcSQLExec(cQry)
		
		
		//passo 3
		cQry := " UPDATE SC6010  TC6 SET C6_ZENTRE2 = ' ', C6_XEMAIL = ' ', C6_XPREV = ' ' WHERE  TC6.R_E_C_N_O_ IN( SELECT SC6.R_E_C_N_O_ FROM SC6010 SC6 WHERE C6_XPREV <> ' ' AND SC6.D_E_L_E_T_ = ' '  AND NOT EXISTS(SELECT * FROM ZZJ010 ZZJ WHERE ZZJ.D_E_L_E_T_ = ' ' AND ZZJ_NUM = C6_XPREV))
		TcSQLExec(cQry)
		
		
		
		u_ZZJAJUS()
	EndIf
Return()








