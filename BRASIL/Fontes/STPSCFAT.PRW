#include 'Protheus.ch' 
#include 'RwMake.ch'
#DEFINE CR    chr(13)+chr(10)
/*====================================================================================\
|Programa  | STPSCFAT         | Autor | GIOVANI.ZAGO             | Data | 25/03/2013  |
|=====================================================================================|
|Descrição |  STPSCFAT     avalia valor de 0,01 na virada de orçamento para pedido    |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPSCFAT                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STPSCFAT(_cOper)
	*-----------------------------*
	Local _lRet 		:= .T.
	Local _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Local _nPosTotItem  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_VLRITEM" ,"C6_VALOR"  	)   })
	Local _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_PRODUTO" ,"C6_PRODUTO"  	)   })
	Local _nPosTabe     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XTABELA" ,"C6_PRODUTO"  	)   })
	Local _nPosQtdVen	:= aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_QUANT"	,"C6_QTDVEN"   	)   })
	Local i
	Local cProdBLQ	    	:= GetMv("FS_PRODBLQ",.F.,"1020")
	Local _lRetProd 		:= .T.
	Local _lListRet 		:= .T.
	Local _lAlca		    := .T.
	Local _lRetStella	    := .T.
	Local _lRetTransp	    := .T.
	Local _lRetObs  	    := .T.
	Local _lRetEnt  	    := .T.
	Local _lRetCle  	    := .T.
	Local _cGrpStella	  	:= GetMv("ST_QUANV01",,'105')
	Local _cProBlq 			:= ' '
	Local _lPromo       	:= GetMv("ST_PROMOMA",,.F.)
	Local _lRetCity  	    := .T.
	Local _cCity	  	    :=	' '
	Local cSolicit	  		:= 	M->UA_NUM
	Local _lRetTnt  	    := .T.


	Private _cPath      := GetSrvProfString("RootPath","")
	Private _cStartPath := "\arquivos\ORCAMENTOANEXOS\"
	Private _cEmp       := ""+cEmpAnt+"\"
	Private _cFil       := ""+cFILaNT+"\"
	Private _cNUm       := ""+cSolicit+"\"
	Private _cServerDir := ''
	
	If IsInCallStack("U_STCRM08A") //Campo M->UA_TRANSP não está vindo
		M->UA_TRANSP := SUA->UA_TRANSP
	EndIf
	
	If  _cOper= '1'
		For i:=1 To Len(Acols)
			If aCols[i][_nPosTotItem] = 0.01
				_lRet := .F.
			EndIf
			//Giovani Zago tratamento para ajuste de tabela de preço 19/07/13
			If !Empty(alltrim(aCols[i][_nPosTabe] ))
				_lListRet := .F.
			EndIf
			//_________________________________________________________________________________
			
			If alltrim(aCols[i][_nPosProd]) $ alltrim(cProdBLQ)
				_lRetProd:=.F.
				_lRet := .F.
			EndIf
			
			
			DbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			If		SB1->(DbSeek(xFilial("SB1")+aCols[i,_nPosProd] ))
				If   SB1->B1_MSBLQL  = '1'
					_cProBlq :=_cProBlq+' - '+SB1->B1_COD
				EndIf
				If Alltrim(SB1->B1_GRUPO) $ _cGrpStella  .And. SUBSTR(M->UA_XSTELLA,1,1) = '1'
					_nStella:= U_STSBFSTELLA (SB1->B1_COD, SUBSTR(M->UA_XSTELLA,1,1) )
					If aCols[i,_nPosQtdVen]  > _nStella
						_lRetStella := .F.
					EndIf
				EndIf
				_nStella:=0
				If SB1->B1_XR01  = '1'
					Dbselectarea('SB2')
					SB2->(DbSetOrder(1))
					If	SB2->(DbSeek(xfilial("SB2") + SB1->B1_COD +'03'))
						
						_nStella:= 	SB2->B2_QATU - (U_STResSDC(SB2->B2_COD) + u_STSldPV(SB2->B2_COD,cFilAnt))-SB2->B2_QACLASS
						
						If aCols[i,_nPosQtdVen]  > _nStella
							_lRetObs:= .F.
							MsgInfo("Quantidade Indisponivel....."+CR+"Saldo: "+cValtochar(_nStella))
							AutoGrLog("Quantidade Indisponivel do produto "+AllTrim(SB1->B1_COD)+CR+"Saldo: "+cValtochar(_nStella))
						EndIf
					Else
						_lRetObs:= .F.
						MsgInfo("Quantidade Indisponivel....."+CR+"Saldo: "+cValtochar(_nStella))
						AutoGrLog("Quantidade Indisponivel do produto "+AllTrim(SB1->B1_COD)+CR+"Saldo: "+cValtochar(_nStella))
						
					EndIf
				EndIf
				
				
			EndIf
			
		Next i
		_lAlca := U_STZZIBOK()//Giovani Zago Alçada Comercial  18/12/13
		
		If Empty(Alltrim(M->UA_TRANSP))
			_lRetTransp:=.f.
		EndIf
		
		If !(Empty(Alltrim(M->UA_ENDENT))) .And. Empty(Alltrim(M->UA_XCODMUN))
			_lRetEnt:= .f.
		EndIf
		
		
		DbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		If		SA1->(DbSeek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA ))
			If  Alltrim(M->UA_CEPE) = Alltrim(SA1->A1_CEP)
				_lRetCle:= .f.
			EndIf
		EndIf
		//gIOVANI ZAGO  CHAMADO 1735
		If  GetMv("ST_TRSTE",,.F.) .And. M->UA_XTIPOPV = '2'//entrega
			DbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			If		SA1->(DbSeek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA ))
				If !(Empty(Alltrim(M->UA_XCODMUN)))
					_cCity := M->UA_XCODMUN
				Else
					_cCity := SA1->A1_COD_MUN
				EndIf
				If SA1->A1_EST = "SP"
					_lRetCity := U_STSPCITY( M->UA_TRANSP , _cCity )
				EndIf
			EndIf
		EndIf
		
		/* Removido por Valdemir Ticket: 20210811015405
		If  M->UA_XTIPOPV = '1' .And. M->UA_TRANSP = '000163'
			_lRet :=	.F.
			MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!! "+CR+CR+"TNT nao pode ser Tipo Retira...!! ")
		EndIf
		*/
	EndIf
	
	
		If  Empty(Alltrim(M->UA_VEND))
			_lRet :=	.F.
			MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!! "+CR+CR+"Vendedor 1 Vazio, falar com Vanderlei...!!!!! ")
		EndIf
	 
	
	If !_lRetCle
		MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!! "+CR+CR+"Cep de Entrega Igual ao Cep de Faturamento...!! ")
	EndIf
	
	
	
	If !_lRetEnt
		MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!! "+CR+CR+"Preencha o Codigo do Municipio de Entrega ")
	EndIf
	
	
	If !_lRet
		MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!! "+CR+CR+"Existem Itens Com Valor de R$ 0,01 ")
	EndIf
	
	If !_lRetProd
		MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!! "+CR+CR+"Existem Produto de Consulta ")
	EndIf
	
	If !_lListRet
		MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!! "+CR+CR+"Atualize Os Itens")
		_lRet := .F.
	EndIf
	
	If IsInCallSteck("U_STFSVE46") .and. _cOper <> '2'
		_lRet := .F.
		MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!!  ")
	EndIf
	
	If !_lAlca
		_lRet := .F.
		MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!!  "+CR+CR+"Bloqueado Por Alçada de Desconto")
	EndIf
	
	If !_lRetStella
		_lRet := .F.
		MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!!  "+CR+CR+"Linha STELLA com Saldo Indisponivel")
	EndIf
	
	If !_lRetTransp
		_lRet := .F.
		MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!!  "+CR+CR+"Transportadora em Branco!!!")
	EndIf
	
	If !Empty(Alltrim(_cProBlq))
		_lRet := .F.
		MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!!  "+CR+CR+"Produtos Bloqueados "+_cProBlq+" !!!!!!!")
	EndIf
	
	
	If !_lRetObs
		_lRet := .F.
		MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!!  "+CR+CR+"Itens sem saldo(RR/O)!!!")
	EndIf
	//Giovani Zago 30/10/14
	If    _lRet  .And. _lPromo
		_lRet :=	U_STPROMOMAR()
	EndIf
	If    _lRet  .And. !(_lRetCity)
		_lRet :=	.F.
	EndIf
	If  _cOper= '1'
		_cServerDir += (_cStartPath)
		If MakeDir (_cServerDir) == 0
			MakeDir(_cServerDir)
		Endif

		_cServerDir += _cEmp
		If MakeDir (_cServerDir) == 0
			MakeDir(_cServerDir)
		Endif

		_cServerDir += _cFil
		If MakeDir (_cServerDir) == 0
			MakeDir(_cServerDir)
		Endif

		_cServerDir += _cNUm
		If MakeDir (_cServerDir) == 0
			MakeDir(_cServerDir)
		Endif
		If GetMv("ST_PSCFAT",,.t.) .And. !IsBlind() .And. !AllTrim(cUserName)=="tir"
			If ExistDir(_cServerDir)
				If  Altera
					If !(Len(Directory(_cServerDir+Strzero(1,6)+".mzp")) = 1)
						MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!!  "+CR+CR+"Falta anexo de Confirmação de Pedido!!!")
						U_PVSTANEX(.T.)
					EndIf
					If !(Len(Directory(_cServerDir+Strzero(1,6)+".mzp")) = 1)
						_lRet := .F.
						MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!!  "+CR+CR+"Falta anexo de Confirmação de Pedido!!!")
					EndIf
				ElseIf Inclui
					U_XPVSTANEX(.T.)
					If !(Len(Directory(_cServerDir+Strzero(1,6)+".mzp")) = 1)
						_lRet := .F.
						MsgInfo("Atenção Orçamento não Pode ser Convertido em Pedido !!!!!  "+CR+CR+"Falta anexo de Confirmação de Pedido!!!")
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
Return(_lRet)


