#include 'Protheus.ch'
#include 'RwMake.ch'
#DEFINE CR    chr(13)+chr(10)
/*====================================================================================\
|Programa  | MA261LIN          | Autor | GIOVANI.ZAGO             | Data | 10/12/2013 |
|=====================================================================================|
|Descrição | MA261LIN                                                                 |
|          | Valida linha a linha da transferencia modelo2.  					      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MA261LIN                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
//Alterações realizadas:
//FR - 16/09/2022 - Flávia Rocha - Sigamat Consultoria - Ticket #20220712013778
//Readequação da trava para transferir pelo armazém 95, só permitir se o usuário for 
//da área Qualidade
//======================================================================================//
*-----------------------------*
User Function MA261LIN()
	*-----------------------------*
	
	Local _aArea  		:= GetArea()
	Local _lRet   		:= .F.
	Local _cUser  		:= GetMv("ST_MA261LI",,"000000")
	Local _nPosObs      := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_XOBS"})
	Local _aGrupos := {}
	Local lRetransf := (IsInCallStack("U_STKMNTP") .Or. IsInCallStack("U_JOBTRFOP")) 
	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos	:= PswRet()
	EndIf
	
	If __cUserId $ _cUser .or. (__cUserId $ GetMv("ST_QUAMOD2"))		
		 /*validações PARA Usuarios da Qualidade. Mantido em linha para exibir a mesagem de orietanção*/
		If Acols[n,1] <> Acols[n,6] .and. !Acols[n,len(aheader)+1]
			If	MsgYesNo("Produto Origem Diferente de Produto Destino "+CR+CR+". Confirma a Diferença?")
				_lRet:= .T.
			Else
				Return(_lRet)
			Endif			
		ElseIf !IsTelNet() .And. aCols[n,9] $ "95#97#98" .And. Empty(aCols[n,_nPosObs]) .And. !Acols[n,len(aheader)+1] //Armazens da qualidade - Chamado 000471 - Renato Nogueira - 05/05/2014
			MsgInfo("Favor Preencher o Campo de Observação Por Se Tratar de Armazém da Qualidade")
			Return(_lRet)
		Else 
			_lRet:= .t.	 
		EndIf	
	Else
	 /*validações sobre armazem da Qualidade. Mantido em linha para exibir a mesagem de orietanção*/
		If Acols[n,1] <> Acols[n,6] .and. !Acols[n,len(aheader)+1]
			MsgInfo("Produto Origem NÃO pode ser diferente de Produto Destino")
			Return(_lRet)
	  	ElseIf aCols[n,9]$"95#97"
			//valida o armazém destino (se o usuário não é da Qualidade, não pode transferir para 95)
			MsgAlert("Atenção, Armazém Destino 95/97 e Usuário NÃO é da Qualidade, Verifique!")
			Return(_lRet)		
		ElseIf  aCols[n,4] $ "95#97#"
			//valida o armazém origem se for 97 e usuário não for da Qualidade, não permite
			MsgAlert("Atenção, Armazém de Origem 95/97 e Usuário NÃO é da Qualidade, Verifique!")
			Return(_lRet)		 				
		ElseIf AllTrim(aCols[n,5])=="RET QUALIDADE" 
			MsgAlert("Atenção, Endereço de Origem RET QUALIDADE e Usuário Não é da Qualidade, Verifique!")
			Return(_lRet)	
		ElseIf  AllTrim(aCols[n,5])=="REJEITADO"   // Jefferson 20191022000017
			MsgAlert("Atenção, Endereço de Origem REJEITADO QUALIDADE e Usuário NÃO é da Qualidade, Verifique!")	
			Return(_lRet)
		else
			_lRet := .t.
		endif			
	Endif

	If cEmpAnt=="03" .And. !IsBlind()
		If aCols[n,4]=="90" .And. aCols[n,9] $ "01#03" .And. !Empty(aCols[n,10]) .And. ! (__cUserId $ GetMv("ST_USRARM9"))
			MsgAlert("Atenção, Armazém de Origem 90 e Endereço de Destino Preenchido, Verifique!")
			Return(_lRet)
		ElseIf aCols[n,4] $ "01#03" .And. IIF(lRetransf,.F.,!(_aGrupos[1][10][1] $ GetMv("ST_GRPLOGI")))				
			MsgAlert("Atenção, Armazém de Origem 01 e 03 e Usuário não é da Logística, Verifique!")
			Return(_lRet)
		else
			_lRet:= .T.
		endIf
	EndIf

	If _lRet
		_lRet := StVlSldB2()
	EndIf
	
	Restarea(_aArea)
	
Return(_lRet)

Static Function StVlSldB2()
	
	Local _lRet := .T.
	Local _nX := 0
	Local _nQuant := 0
	Local _nPosCod := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_COD"})
	Local _nPosLoc := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCAL"})
	Local _nPosQtd := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_QUANT"})
	Local _cCod := ""
	Local _cLocal := ""
	
	If  _nPosCod > 0 .And. _nPosLoc > 0 .And. _nPosQtd > 0 .And. Len(aCols)>0
		_cCod := aCols[n,_nPosCod]
		_cLocal := aCols[n,_nPosLoc]
		_nQuant := 0
		
		For _nX := 1 to Len(aCols)
			If _cCod = aCols[_nX,_nPosCod] .And. _cLocal = aCols[_nX,_nPosLoc]
				_nQuant += aCols[_nX,_nPosQtd]
			EndIf
		Next
		
		DbSelectArea("SB2")
		SB2->(DbSetOrder(1))
		If SB2->(DbSeek(xFilial("SB2")+_cCod+_cLocal))
			If SB2->(B2_QATU-B2_QACLASS) < _nQuant
				MsgAlert("Amazem "+_cLocal+" não possui saldo, favor contactar "+IIF(cEmpAnt="03","Adadiel",IIF(cFilAnt$"01|04","Ulisses","Cleber"))+"(SB2)!!!")
				lRet := .F.
			EndIf
		EndIf
	EndIf
	
Return(_lRet)
