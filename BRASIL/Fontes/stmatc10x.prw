#INCLUDE "MATC010X.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"

Static __lMC010DES := ExistBlock('MC010DES')
Static lInt        := SCO->(FieldPos("CO_INTPV") > 0 .And. FieldPos("CO_INTPUB") > 0 )
Static lSB1Ok //variavel utilizada para que a verifica  o da tabela seja feita uma unica vez no processo.

/*                                                                         
    DATA     BOPS  Prograd. ALTERACAO                                                                                                                   
   22.12.98 MELHOR Bruno    Modificacao do array de retorno do MC010Form()   
                            (aumento do string da descricao do produto).     
   30.04.99 21387A Fernando Montar corretamente o aArray quando o PDV for    
                            do tipo PLANILHA.                                
   02.07.99 18443A Fernando  Utilizar a Picture de Valores correta.          
   22/07/99 22152A CesarVal Passar mv_par07 (QtdBas) p/ Mc010Forma().        
                            Somente Quando de (MATR430).                     
   30/08/99 21448A CesarVal Fazer a inversao do calculo do Valor             
                            Unitario com o maximo de casas decimais.         
                            Somente Quando de (MATR430).                     
   13/10/99 22282A CesarVal Novo Lay-Out com Celula Percentual com 4         
                            Digitos e Formula com 100 Caracteres.            
   02/01/00   2082 CesarVal Inclusao do P.E. MC010ADD P/ Inserir Elementos   
                            Na Estrutura do Produto.                         
   23/08/00   5742 Iuspa    Var lConsNeg Considera/nao quant neg estrutura   
   Descri  o   PLANO DE MELHORIA CONTINUA                    MATC010X.PRX    
   ITEM PMC    Responsavel                Data         BOPS                  
         01   Marcos V. Ferreira         03/08/2006   00000100434            
         02   Flavio Luiz Vicco          26/04/2006   00000097637            
         03                                                                  
         04                                                                  
         05   Marcos V. Ferreira         03/08/2006   00000100434            
         06   Nereu Humberto Junior      14/08/2006   00000098126            
         07   Nereu Humberto Junior      14/08/2006   00000098126            
         08                                                                  
         09                                                                  
         10   Flavio Luiz Vicco          26/04/2006   00000097637            
    Fun  o     MontStru   Autor   Ary Medeiros            Data   19/10/93    
    Descri  o  Monta um array com a estrutura do produto                     
    Sintaxe    MontStru(ExpC1,ExpN1,ExpN2,ExpC2,ExpC3,ExpL1,ExpL2,ExpC4)     
   Parametros  ExpC1 = Codigo do produto a ser explodido                     
               ExpN1 = Quantidade base a ser explodida                       
               ExpN2 = Contador de niveis da estrutura                       
               ExpC2 = String com os opcionais default do produto pai        
               ExpC3 =                                                       
               ExpL1 =                                                       
               ExpL2 = Exibir mensagem de processamento                      
               ExpC4 = Revisao passada pelo MATR430                          
    Uso        MATC010                                                       
*/
Static Function MontStru(cProduto,nQuant,nNivel,cOpcionais,cRevisao,lSomouComp,lMostra,cRevExt,_lCustoStd)
	Local nReg,nQuantItem, lAcesso := .T.,cRoteiro:=""
	Local lRel        :=If(cProg$"R430A420",.T.,.F.)
	Local aArea       :=GetArea()
	Local aAreaSG2    :=SG2->(GetArea())
	Local aAreaSB1    :=SB1->(GetArea())
	Local aAreaSH1    :=SH1->(GetArea())
	Local lOkExec     :=ExistBlock("MC010PR")
	Local nRetorno    :=0
	Local nPosOri     :=0,nPosOriInv:=0
	Local lPassaComp  :=.F.
	Local cWhile      :=IF(mv_par09==1,"G1_FILIAL+G1_COD","GG_FILIAL+GG_COD")
	Local cAliasWhile :=IF(mv_par09==1,"SG1","SGG")
	Local cAliasComp  :=""
	Local cAliasCod   :=""
	Local cAliasTRT   :=""
	Local cAliasNivInv:=""
	Local cProdMod    :=""
	Local lMc010Est   :=ExistBlock("MC010EST")
	Local lRetPE      := .T.
	Local lFilSG2     := .F.
	Local nTmpMAO     := 0
	Local lVConsNeg   := Type("lConsNeg") == "L"
	Static nI := 0

	PRIVATE cTipoTemp	:=SuperGetMV("MV_TPHR")

	DEFAULT lMostra := .T.
	DEFAULT cRevExt := ""
	//Default _lCustoStd := .F.

	lAcesso   :=IIf(Subs(cAcesso,39,1) != "S",.F.,.T.) // Forma  o de pre os todos n veis
	cRevisao  :=IIf(cRevisao==NIL,"",IIF((cProdPai == cProduto),cRevisao,""))
	cOpcionais:=IIf(cOpcionais==NIL,"",cOpcionais)

	//                               
	//  - Messagem de Processamento -  
	//                                 
	If lMostra
		nI := (nI+1) % 4
		MsProcTxt(STR0013+Replicate(".",nI+1))
		ProcessMessage()
	EndIf

	//                                                         
	//  Posiciona no produto desejado                            
	//                                                           
	dbSelectArea(cAliasWhile)
	dbSeek(xFilial(cAliasWhile)+cProduto)

	//                                                 
	//  Verifica se o produto MOD deve ser considerado   
	//  do roteiro de operacoes.                         
	//                                                   
	If mv_par05 == 2 .Or. mv_par05 == 3
		dbSelectArea("SB1")
		dbSetOrder(1)
		If MsSeek(xFilial("SB1")+cProduto)
			If !Empty(mv_par06)
				cRoteiro:=mv_par06
			ElseIf !Empty(SB1->B1_OPERPAD)
				cRoteiro:=SB1->B1_OPERPAD
			EndIf
			dbSelectArea("SG2")
			dbSetOrder(1)
			MsSeek(xFilial("SG2")+cProduto+If(Empty(cRoteiro),"01",cRoteiro))
			While !Eof() .And.	xFilial("SG2")+cProduto+If(Empty(cRoteiro),"01",cRoteiro) == G2_FILIAL+G2_PRODUTO+G2_CODIGO
				If (ExistBlock('MCFILSG2'))
					lFilSG2 := ExecBlock("MCFILSG2",.F.,.F.,)
					If Valtype(lRetPE) == "L" .And. !lFilSG2
						dbSkip()
						Loop
					EndIf
				EndIf
				dbSelectArea("SH1")
				dbSetorder(1)
				If MsSeek(xFilial("SH1")+SG2->G2_RECURSO)
					// Calcula Tempo de Dura  o baseado no Tipo de Operacao
					If SG2->G2_TPOPER $ " 1"
						// Valdemir Rabelo 13/05/2020
						if (cEmpAnt=="03") .and. (!EMPTY(SG2->G2_TPALOCF)) .and. SG2->G2_OPERAC=='10'
						   nTmpMAO :=  (SG2->G2_TEMPAD / SG2->G2_LOTEPAD) 
						endif					
						nTemp := Round((nQuant * ( If(mv_par07 == 3,A690HoraCt(SG2->G2_SETUP) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ), 0) + IIf( SG2->G2_TEMPAD == 0, 1,A690HoraCt(SG2->G2_TEMPAD)) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ))+If(mv_par07 == 2, A690HoraCt(SG2->G2_SETUP), 0) ),5)					
						If SH1->H1_MAOOBRA # 0
							nTemp :=Round( nTemp / SH1->H1_MAOOBRA,5)
						EndIf
					
					ElseIf SG2->G2_TPOPER == "4"
						nQuantAloc:=nQuant % IIf(SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD)
						nQuantAloc:=Int(nQuant)+If(nQuantAloc>0,IIf(SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD)-nQuantAloc,0)
						nTemp := Round(nQuantAloc * ( IIf( SG2->G2_TEMPAD == 0, 1,A690HoraCt(SG2->G2_TEMPAD)) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ) ),5)
						If SH1->H1_MAOOBRA # 0
							nTemp :=Round( nTemp / SH1->H1_MAOOBRA,5)
						EndIf
					ElseIf SG2->G2_TPOPER == "2" .Or. SG2->G2_TPOPER == "3"
						nTemp := IIf( SG2->G2_TEMPAD == 0 , 1 ,A690HoraCt(SG2->G2_TEMPAD) )
					EndIf
					cProdMod:=APrModRec(SH1->H1_CODIGO)
					// Valdemir Rabelo 13/05/2020
					if (cEmpAnt=="03") .and. ("120108" $ cProdMod) .and. (nTmpMAO > 0)
						nTemp := nTmpMAO
					endif 
					
					nTemp:=nTemp*If(Empty(SG2->G2_MAOOBRA),1,SG2->G2_MAOOBRA)
					
					//                                                  
					//  Posiciona no produto da Mao de Obra.              
					//                                                    
					//cProdMod:=APrModRec(SH1->H1_CODIGO)
					SB1->(dbSetOrder(1))
					If SB1->(MsSeek(xFilial("SB1")+cProdMod))

						_cStd := ""

						If IsInCallStack("u_STMATR430") .Or. IsInCallStack("MATC010")  //MATR430
							If IsInCallStack("u_STMATR430") //MATR430
								_cStd := UPPER(aPar[12])
							Else
								_cStd := "N"
							EndIf
							If _cStd=="S"
								If SB1->B1_TIPO=="MO"
									DbSelectArea("SZO")
									SZO->(DbSetOrder(1))
									SZO->(DbGoTop())
									SZO->(DbSeek(xFilial("SZO")+SB1->B1_CC))
									While SZO->(!Eof()) .And. AllTrim(SZO->ZO_CC)==AllTrim(SB1->B1_CC)

										If SB1->(DbSeek(xFilial("SB1")+SZO->ZO_PROD))

											AddArray(nTemp,nNivel,.F.,lAcesso,SG2->G2_OPERAC)
											AAdd(aInv,{		SB1->B1_COD,PADL(99,3,"0"),;
											nTemp,SZO->ZO_VALOR,0,	"0",Len(aInv)+1,lAcesso})
											aArray[Len(aArray)][8]:=.T.
											aInv[Len(aInv),6]:= "1"								
											if Len(aArray[Len(aArray)]) >= 16
												aArray[Len(aArray)][16] := SZO->(Recno())
												aArray[Len(aArray)][18] := cProdMod
											Endif
											
											if Len(aArray[Len(aArray)]) == 15
												// FMT - CONSULTORIA
												Aadd(aArray[Len(aArray)] , SZO->(Recno()))    // 16
												Aadd(aArray[Len(aArray)], '')				// 17
												Aadd(aArray[Len(aArray)], cProdMod)			// 18
											Endif		

										EndIf

										SZO->(DbSkip())
									EndDo

								Else
									// Inclui componente no array
									AddArray(nTemp,nNivel,.F.,lAcesso,SG2->G2_OPERAC)
									AAdd(aInv,{	SB1->B1_COD,PADL(99,3,"0"),;
									nTemp,STQualCusto(SB1->B1_COD),0,	"0",Len(aInv)+1,lAcesso})
									aArray[Len(aArray)][8]:=.T.
									aInv[Len(aInv),6]:= "1"
								EndIf
							Else
								// Inclui componente no array
								AddArray(nTemp,nNivel,.F.,lAcesso,SG2->G2_OPERAC)
								AAdd(aInv,{	SB1->B1_COD,PADL(99,3,"0"),;
								nTemp,STQualCusto(SB1->B1_COD),0,	"0",Len(aInv)+1,lAcesso})
								aArray[Len(aArray)][8]:=.T.
								aInv[Len(aInv),6]:= "1"
							EndIf
						Else
							AddArray(nTemp,nNivel,.F.,lAcesso,SG2->G2_OPERAC)
							AAdd(aInv,{	SB1->B1_COD,PADL(99,3,"0"),;
							nTemp,STQualCusto(SB1->B1_COD),0,	"0",Len(aInv)+1,lAcesso})
							aArray[Len(aArray)][8]:=.T.
							aInv[Len(aInv),6]:= "1"
						EndIf

					EndIf
				EndIf
				nTmpMAO := 0
				dbSelectArea("SG2")
				dbSkip()
			End
		EndIf
		RestArea(aAreaSG2)
		RestArea(aAreaSB1)
		RestArea(aAreaSH1)
	EndIf

	If (cAliasWhile)->(Eof())
		aArray[1][8] := .T.
	Else

		dbSelectArea(cAliasWhile)

		While !Eof() .And. &(cWhile) == xFilial(cAliasWhile)+cProduto
			cAliasComp  :=If(mv_par09==1,SG1->G1_COMP,SGG->GG_COMP)
			cAliasCod   :=If(mv_par09==1,SG1->G1_COD,SGG->GG_COD)
			cAliasTRT   :=If(mv_par09==1,SG1->G1_TRT,SGG->GG_TRT)
			cAliasNivInv:=If(mv_par09==1,SG1->G1_NIVINV,SGG->GG_NIVINV)

			//                                                         
			//  Funcao que devolve a quantidade utilizada do componente  
			//                                                           
			nQuantItem := ExplEstr(nQuant,NIL,cOpcionais,cRevisao,NIL,mv_par09==2,.F.)
			If lVConsNeg .And. (!lConsNeg) .and. QtdComp(nQuantItem,.T.) < QtdComp(0)
				dbSelectArea(cAliasWhile)
				dbSkip()
				Loop
			EndIf

			//                                                 
			//  Verifica se o produto MOD deve ser considerado   
			//                                                   
			If mv_par05 == 2 .And. IsProdMod(cAliasComp)
				dbSelectArea(cAliasWhile)
				dbSkip()
				Loop
			EndIf

			 
			//  Executa ponto de Entrada para filtrar componentes da estrutura  
			   
			If lMc010Est
				lRetPE := ExecBlock("MC010EST",.F.,.F.,{cAliasWhile,cAliasCod,cAliasComp})
				If Valtype(lRetPE) == "L" .And. !lRetPE
					dbSelectArea(cAliasWhile)
					dbSkip()
					Loop
				Endif
			Endif

			//                                        
			//  Posiciona SB1                           
			//                                          
			dbSelectArea("SB1")
			MsSeek(xFilial("SB1")+cAliasComp)

			dbSelectArea(cAliasWhile)

			//                                        
			//  Executa P.E.                            
			//                                          
			If lOkExec .And. (QtdComp(nQuantItem,.T.) == QtdComp(0))
				nRetorno:=ExecBlock("MC010PR",.F.,.F.,{cAliasCod,cAliasComp,cAliasTRT,nQuant,Recno()})
				If Valtype(nRetorno) == "N"
					nQuantItem:=nRetorno
				EndIf
			EndIf

			If (QtdComp(nQuantItem,.T.) != QtdComp(0))
				dbSelectArea(cAliasWhile)
				nReg := Recno()

				If RetFldProd(SB1->B1_COD,"B1_FANTASM") $ " N" .Or. (RetFldProd(SB1->B1_COD,"B1_FANTASM") == "S" .And. mv_par08 == 1) // Projeto Implementeacao de campos MRP e FANTASM no SBZ
					lSomouComp:=.T.
					AddArray(nQuantItem,nNivel,.F.,lAcesso,NIL)
					AAdd(aInv,{cAliasComp,;
					PADL(cAliasNivInv,3,"0"),;
					nQuantItem,;
					STQualCusto(cAliasComp),;
					0,;
					"0",;
					Len(aInv)+1,;
					lAcesso			})
				EndIf

				//                                                 
				//  Verifica se o filho tem estrutura                
				//                                                   
				MsSeek(xFilial(cAliasWhile)+cAliasComp) // SG1 ou SGG
				If Eof()
					aArray[Len(aArray)][8]:= .T.
					aInv[Len(aInv),6]	   := "1"
				Else
					nPosOri:=Len(aArray)
					nPosOriInv:=Len(aArray)
					lPassaComp:=.F.
					MontStru(cAliasComp,nQuantItem,nNivel+1,cOpcionais,If(lRel,If(Empty(cRevExt),SB1->B1_REVATU,cRevExt),If(Empty(mv_par04),SB1->B1_REVATU,mv_par04)),@lPassaComp,lMostra,cRevExt,_lCustoStd)
					If !lPassaComp
						aArray[nPosOri][8]:= .T.
						aInv[nPosOriInv,6]:= "1"
					EndIf
				EndIf
				MsGoTo(nReg)
			EndIf
			dbSkip()
		EndDo
	EndIf

	RestArea(aArea)
Return

/*
    Fun  o     AddArray   Autor   Jorge Queiroz           Data   19/06/92    
    Descri  o  Adiciona um elemento ao Array                                 
    Sintaxe    AddArray(ExpN1,ExpN2,ExpL1)                                   
   Parametros  ExpN1 = Quantidade da estrutura                               
               ExpN2 = Nivel do item                                         
               ExpL1 = Inicializa elemento 8 do aArray (aArray[n][8])        
    Uso        MATC010                                                       
*/
/*
Function AddArray(nQuantItem,nNivel,lAltera,lAcesso,cOperac)
	Local cNivEstr
	Local cAliasTRT   :=If(mv_par09==1,SG1->G1_TRT,SGG->GG_TRT)
	Local cAliasFixVar:=If(mv_par09==1,SG1->G1_FIXVAR,SGG->GG_FIXVAR)
	Local cDescProd   :=SB1->B1_DESC

	Default cOperac     := ""
	Default __lMC010DES := .F.

	If __lMC010DES
		cDescProd := ExecBlock('MC010DES',.F.,.F.,{SB1->B1_COD})
		If ValType(cDescProd) <> "C"
			cDescProd := SB1->B1_DESC
		EndIf
	EndIf

	// Verifica o Nivel de Estrutura
	If Empty(mv_par11) .Or. (mv_par11==0)
		mv_par11 := 999
	EndIf

	lAcesso :=If((lAcesso == NIL),.T.,lAcesso)
	cNivEstr:=Space(IIf(nNivel<=5,nNivel-1,4))+LTRIM(STR(nNivel,2))
	dbSelectArea(If(mv_par09==1,"SG1","SGG"))
	If nNivel <= mv_par11
		AAdd(aArray, { Len(aArray)+1,;						//1
		cNivEstr+Space(6-Len(cNivEstr)),;   //2
		SubStr(cDescProd,1,38),;				//3
		SB1->B1_COD,;						//4
		nQuantItem,;							//5
		0,;									//6
		0,;									//7
		lAltera,;							//8
		SB1->B1_TIPO,;						//9
		.F.,;								//10
		cAliasTRT,;							//11
		lAcesso,cAliasFixVar,cOperac})		//recno szo
	EndIf

	// Projeto Precificacao
	// incluir os novos campos mesmo que seja leitura direto do arquivo Standard.pdv
	If lInt
		aSize(aArray[Len(aArray)],15)
		aArray[Len(aArray)][15] := { Space(Len(SCO->CO_INTPV)), Space(Len(SCO->CO_INTPUB)) }
	EndIf

	aSize(aArray[Len(aArray)],16)
	aArray[Len(aArray)][16] := 0 //Recno szo

	aSize(aArray[Len(aArray)],17)
	aArray[Len(aArray)][17] := 0 //Recno szo

	aSize(aArray[Len(aArray)],18)
	aArray[Len(aArray)][18] := ""

Return Nil
*/

/*
    Fun  o     QualCusto  Autor   Eveli Morasco           Data   19/06/92    
    Descri  o  Devolve o custo selecionado para consulta                     
    Sintaxe    ExpN1 := QualCusto(ExpC1)                                     
   Parametros  ExpN1 = Custo do estoque devolvido pela funcao                
               ExpC1 = Codigo do produto a considerar                        
    Uso        MATC010                                                       
*/
Static Function STQualCusto(cProduto,_nRecno,_nLin)
	Static lBlockCus := NIL
	Static lValICMS  := NIL

	Local nCustoPad,cAliasAnt := Alias(),nIcm,nIpi
	Local nCustoBack:=0

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()

	Local _nCusOri := 0
	Local _nX	   := 0

	Default _nRecno := 0
	Default _nLin	:= 0

	  
	//  Funcao utilizada para verificar a ultima versao dos fontes       
	//  SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   
	//  cliente, assim verificando a necessidade de uma atualizacao     
	//  nestes fontes. NAO REMOVER !!!							         
	    
	If !(FindFunction("SIGACUS_V")	.And. SIGACUS_V() >= 20050512)
		Final(STR0014 + " SIGACUS.PRW !!!")  // "Atualizar SIGACUS.PRW !!!"
	EndIf
	If !(FindFunction("SIGACUSA_V")	.And. SIGACUSA_V() >= 20050512)
		Final(STR0014 + " SIGACUSA.PRX !!!") // "Atualizar SIGACUSA.PRW !!!"
	EndIf
	If !(FindFunction("SIGACUSB_V")	.And. SIGACUSB_V() >= 20050512)
		Final(STR0014 + " SIGACUSB.PRX !!!") // "Atualizar SIGACUSB.PRW !!!"
	EndIf

	lBlockCus := If(lBlockCus == NIL,ExistBlock("MC010CUS"),lBlockcus)
	lValICMS  := If(lValICMS == NIL,GetNewPar("MV_UPRCICM",.T.),lValICMS)

	If nQualCusto == 1 .Or. nQualCusto == 7
		dbSelectArea("SB1")
		MsSeek(xFilial("SB1")+cProduto)
		If nQualCusto == 1
			If RetFldProd(SB1->B1_COD,"B1_MCUSTD") $"2345"
				SM2->(dbSetOrder(1))
				SM2->(dbSeek(dDataBase, .T.))
				If !SM2->(Found())
					SM2->(dbSkip(-1))
				EndIf
				nCustoPad := RetFldProd(SB1->B1_COD,"B1_CUSTD") * &("SM2->M2_MOEDA"+RetFldProd(SB1->B1_COD,"B1_MCUSTD"))
			Else
				nCustoPad := RetFldProd(SB1->B1_COD,"B1_CUSTD")
			EndIf
		Else
			nCustoPad := RetFldProd(SB1->B1_COD,"B1_UPRC")
			nIcm := 0
			nIpi := 0
			dbSelectArea("SF4")
			DbSetOrder(1) 			// FILIAL + CODIGO
			MsSeek(xFilial("SF4")+RetFldProd(SB1->B1_COD,"B1_TE"))
			 
			//  Calcula o valor do ICM a ser retirado do custo do material    			 
			If F4_ICM <> "N"
				If F4_CREDICM == "S"
					nIcm := nCustoPad * Iif(SB1->B1_FORAEST=="S",.12,(SB1->B1_PICM/100))
				EndIf
				nIcm:=If(lValICMS,NoRound(If(F4_BASEICM>0,F4_BASEICM/100,1)*nIcm,2),If(F4_BASEICM>0,F4_BASEICM/100,1)*nIcm)
			EndIf
			 
			//  Calcula o valor do IPI a ser somado ao custo do material      			 
			If F4_IPI <> "N"
				If F4_CREDIPI == "N"
					nIpi := nCustoPad * (SB1->B1_IPI/100)
				ElseIf F4_IPI == "R"
					nIpi -= nCustoPad * (SB1->B1_IPI/100)
				ElseIf F4_BASEIPI>0
					nIpi := nCustoPad * (SB1->B1_IPI/100)
				EndIf
				nIpi := If(F4_BASEIPI>0,F4_BASEIPI/100,1)*nIpi
			EndIf
			nCustoPad := nCustoPad - nIcm + nIpi
		EndIf
	Else
		dbSelectArea("SB1")
		DbSetOrder(1) // FILIAL + CODIGO
		MsSeek(xFilial("SB1")+cProduto)
		dbSelectArea("SB2")
		DbSetOrder(1) // FILIAL + CODIGO + LOCAL
		MsSeek(xFilial("SB2")+cProduto+RetFldProd(SB1->B1_COD,"B1_LOCPAD"))
		If nQualCusto     == 2
			//nCustoPad := B2_CM1
			if B2_CMFIM1 > 0			// Valdemir Rabelo 24/06/2020 Adicionado else para B2_CM?
				nCustoPad := B2_CMFIM1
			else 
				nCustoPad := B2_CM1
			endif 
		ElseIf nQualCusto == 3
		   if B2_CMFIM2 > 0
			nCustoPad := B2_CMFIM2
		   else 
		   	  nCustoPad := B2_CM2
		   endif 
		ElseIf nQualCusto == 4
		   if B2_CMFIM3 > 0
			nCustoPad := B2_CMFIM3
		   else 
		    nCustoPad := B2_CM3
		   endif 
		ElseIf nQualCusto == 5
		   if B2_CMFIM4 > 0
			nCustoPad := B2_CMFIM4
		   else 
		    nCustoPad := B2_CM4
		   endif  
		ElseIf nQualCusto == 6
		   if B2_CMFIM5 > 0
			nCustoPad := B2_CMFIM5
		   else 
		   	nCustoPad := B2_CM5
		   endif 
		EndIf
	EndIf

	// Executa P.E. para alterar custo
	If lBlockCus
		nCustoBack:= ExecBlock("MC010CUS",.F.,.F.,{cProduto,nCustoPad})
		If ValType(nCustoBack) == "N"
			nCustoPad:=nCustoBack
		EndIf
	EndIf

	dbSelectArea(cAliasAnt)

	If IsInCallStack("U_STMATR430") .Or. IsInCallStack("MATC010")
		If IsInCallStack("U_STMATR430")
			_cStd := UPPER(aPar[12])
		Else
			_cStd := "N"
		EndIf
	
		If _cStd=="S"

			_aArea := GetArea()

			If _nRecno>0

				DbSelectArea("SZO")
				SZO->(DbGoTop())
				SZO->(DbGoTo(_nRecno))

				If SZO->(!Eof())
					nCustoPad := SZO->ZO_VALOR
				EndIf

			EndIf

			_nCusOri := nCustoPad

			if (aLLTRIM(SB1->B1_COD) $ '8621765')
               _lTmp := .T.
			Endif 
			
			//Se for materia prima, pegar o custo do ultimo fechamento
			//If AllTrim(SB1->B1_TIPO)=="MP"
			If SB1->B1_CLAPROD=="C" .Or. SB1->B1_CLAPROD=="I"

				DbSelectArea("SB2")
				SB2->(DbSetOrder(1))
				SB2->(DbGoTop())
				If SB2->(DbSeek(xFilial("SB2")+SB1->(B1_COD+B1_LOCPAD)))
					nCustoPad := SB2->B2_CMFIM1
				EndIf

			EndIf
			If SB1->B1_CLAPROD=="F"     // ---------------- Valdemir Rabelo 03/08/2020 -------------
				//Olhar se   fabricado em manaus e pegar o custo la
				_cQuery1 := " SELECT B1_COD, B1_CLAPROD, B2_CMFIM1
				_cQuery1 += " FROM SB1030 B1
				_cQuery1 += " LEFT JOIN SB2030 B2
				_cQuery1 += " ON B2_FILIAL='01' AND B2_COD=B1_COD AND B2_LOCAL=B1_LOCPAD
				_cQuery1 += " WHERE B1.D_E_L_E_T_=' ' AND B2.D_E_L_E_T_=' '
				_cQuery1 += " AND B1_COD='"+SB1->B1_COD+"' AND B1_CLAPROD='F'

				If !Empty(Select(_cAlias1))
					DbSelectArea(_cAlias1)
					(_cAlias1)->(dbCloseArea())
				Endif

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

				dbSelectArea(_cAlias1)
				(_cAlias1)->(dbGoTop())

				If (_cAlias1)->(!Eof())
					nCustoPad := (_cAlias1)->B2_CMFIM1
				EndIf
			Endif 
			// ------------------------------------------
			If AllTrim(SB1->B1_COD)=="MOD120121" .And. SB1->B1_TIPO=="MO" .And. _nLin>0

				_cProdAnt := ""
				_cProdAnt := AllTrim(aArray[_nLin-1][4])
				_cProdAnt := _cProdAnt+"SERV"

				_cQuery1 := " SELECT ZW_VALOR
				_cQuery1 += " FROM "+RetSqlName("SZW")+" ZW
				_cQuery1 += " WHERE ZW.D_E_L_E_T_=' ' AND ZW_PROD='"+_cProdAnt+"'

				If !Empty(Select(_cAlias1))
					DbSelectArea(_cAlias1)
					(_cAlias1)->(dbCloseArea())
				Endif

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

				dbSelectArea(_cAlias1)
				(_cAlias1)->(dbGoTop())

				If (_cAlias1)->(!Eof())
					nCustoPad := (_cAlias1)->ZW_VALOR
				EndIf

			EndIf

			DbSelectArea("SZX")
			SZX->(DbSetOrder(1))
			SZX->(DbGoTop())
			If SZX->(DbSeek(xFilial("SZX")+SB1->B1_COD))
				nCustoPad := SZX->ZX_VALOR
			EndIf

			If IsInCallStack("U_STMATR430")    // MATR430
				If !(_nCusOri==nCustoPad)
					AADD(_aCusOri,{SB1->B1_COD,_nCusOri})
				EndIf
			EndIf

			If !Empty(Select(_cAlias1))
				DbSelectArea(_cAlias1)
				(_cAlias1)->(dbCloseArea())
			Endif

			RestArea(_aArea)

		EndIf
	EndIf

Return nCustoPad

/*                                   
   Fun  o     CalcUltNiv  Autor   Eveli Morasco           Data   26/06/92                                                                           
   Descri  o   Calcula o ultimo nivel do array                                                                                                       
   Sintaxe     ExpN1 := CalcUltNiv()                                                                                                               
   Parametros  ExpN1 = Ultimo nivel utilizado no array                                                                                             
    Uso        MATC010                                                                                                                                 
*/
/*    Removido por não existir customização e será buscado do padrão
Function CalcUltNiv
	Local nUltNivel := 1,nX
	For nX := 1 To Len(aArray)
		If Val(aArray[nX][2]) > nUltNivel
			nUltNivel := Val(aArray[nX][2])
		EndIf
	Next nX
Return nUltNivel
*/

/*                                                                     
   Fun  o      CalcTot    Autor   Jorge Queiroz           Data                                                                                 
   Descri  o   Calcula o custo total do produto e percentuais                                                             
   Sintaxe     CalcTot(ExpN1,ExpN2,ExpA2,ExpN3)                                                                     
   Parametros  ExpN1 = Elemento do array em que inicia a parte de totais     
               ExpN2 = Ultimo nivel encontrado na estrutura                  
               ExpA2 = Array de formulas da planilha                         
               ExpN3 = Forca o custo 8 no recalculo da planilha              
               ExpN4 = Numero da opcao selecionada. Se neste campo estiver   
                       o valor 99 , significa que esta funcao foi chamada    
                       pela rotina de impressao da planilha (MATR430) ,se    
                       estiver o valor 98 ,significa que foi chamada pela    
                       rotina de atualizacao de precos (MATA420)                                                                  
    Uso        MATC010                                                                                                                             
*/
Static Function CalcTot(nMatPrima,nUltNivel,aFormulas,nQc,nOpcx)
	Local aTot[nUltNivel],nX,nY,cNivEstr,nCusto
	Local aCampos:={	{"B1_CUSTD",TamSX3("B1_CUSTD")[2]},;
	{"B2_CM1"  ,TamSX3("B2_CM1"  )[2]},;
	{"B2_CM2"  ,TamSX3("B2_CM2"  )[2]},;
	{"B2_CM3"  ,TamSX3("B2_CM3"  )[2]},;
	{"B2_CM4"  ,TamSX3("B2_CM4"  )[2]},;
	{"B2_CM5"  ,TamSX3("B2_CM5"  )[2]},;
	{"B1_UPRC" ,TamSX3("B1_UPRC" )[2]},;
	{"B1_CUSTD",TamSX3("B1_CUSTD")[2]}}
	If nQc == NIL
		nQc := nQualCusto
	EndIf
	If nOpcx == NIL
		nOpcx := 0
	EndIf

	//                                                               
	//  Inclui pergunta no SX1                                         
	//MTC010SX1()
	 
	//  Aciona perguntas                                                
	Pergunte("MTC010",.F.)
	 
	//  Forca utilizacao da estrutura caso nao tenha SGG                
	If MC010SX2("SGG") == .F.
		mv_par09:=1
	EndIf
	        
	//  Calcula Custos totalizando niveis                                      
	AFILL(aTot,0)
	cNivEstr := aArray[nMatPrima-2][2]
	For nX := nMatPrima-2 To 1 Step -1
		If cNivEstr == aArray[nX][2]
			If nQc != 8 
				nCusto := STQualCusto(aArray[nX][4], iif(Len(aArray[nX]) >= 16,aArray[nX][16],0) ,nX)
				aArray[nX][6] := aArray[nX][5] * nCusto
			EndIf
			 
			//  Este vetor (aAuxCusto) deve ser declarado somente no MATR430  
			If nOpcx==99
				aAuxCusto[nx] := aArray[nx][6]
			EndIf
			//                                                          
			//  Arredonda de acordo com o custo selecionado:              
			//  1 = STANDARD  2 = MEDIO      3 = MOEDA2      4 = MOEDA3   
			//  5 = MOEDA4    6 = MOEDA5     7 = ULTPRECO    8 = PLANILHA 
			//                                                            
			If mv_par02 == 1
				aArray[nx][6]:=Round(aArray[nX][6],aCampos[nQualCusto,2])
			Else
				aArray[nx][6]:=NoRound(aArray[nX][6],aCampos[nQualCusto,2])
			EndIf
			For nY := 1 To Val(cNivEstr)
				aTot[nY] := aTot[nY] + aArray[nX][6]
			Next nY
		Else
			If Val(cNivEstr) > Val(aArray[nX][2])
				aArray[nX][6] := aTot[Val(cNivEstr)]
				For nY := Val(cNivEstr) To Len(aTot)
					aTot[nY] := 0
				Next nY
				cNivEstr := aArray[nX][2]
				 
				//  Este vetor (aAuxCusto) deve ser declarado somente no MATR430  
				If nOpcx==99
					aAuxCusto[nx] := aArray[nx][6]
				EndIf
			Else
				cNivEstr := aArray[nX][2]
				For nY := Val(cNivEstr) To Len(aTot)
					aTot[nY] := 0
				Next nY
				If nQc != 8
					nCusto := STQualCusto(aArray[nX][4],0,nX)
					aArray[nX][6] := aArray[nX][5] * nCusto
				EndIf
				 
				//  Este vetor (aAuxCusto) deve ser declarado somente no MATR430  
				If nOpcx==99
					aAuxCusto[nx] := aArray[nx][6]
				EndIf
				//                                                          
				//  Arredonda de acordo com o custo selecionado:              
				//  1 = STANDARD  2 = MEDIO      3 = MOEDA2      4 = MOEDA3   
				//  5 = MOEDA4 	  6 = MOEDA5	 7 = ULTPRECO	 8 = PLANILHA 
				//                                                            
				If mv_par02 == 1
					aArray[nx][6]:=Round(aArray[nX][6],aCampos[nQualCusto,2])
				Else
					aArray[nx][6]:=NoRound(aArray[nX][6],aCampos[nQualCusto,2])
				EndIf
				For nY := 1 To Val(cNivEstr)
					aTot[nY] := aTot[nY] + aArray[nX][6]
				Next nY
			EndIf
		EndIf
	Next nX

	//                                                          
	//  Envia para funcao que recalcula os totais da planilha     
	//                                                            
	RecalcTot(nMatPrima)

	CalcForm(aFormulas,nMatPrima)

Return     // Adicionado por não terem fechado - Valdemir Rabelo 28/05/2020	

/*                                                      
    Funcoes para interpretacao das formulas construidas para a rotina      
	de calculo de preco.                                                                                                                         
    Fun  o      CalcForm   Autor   Eveli Morasco           Data   24/06/92                                                       
    Descri  o   Executa as formulas desta planilha                                                                                                
    Sintaxe     CalcForm(ExpA1,ExpN1)                                                                                                                    
    Parametros  ExpA1 = Array contendo as formulas                            
               ExpN1 = Elemento que comeca as linhas de totais                                                                  
    Uso        MATC010                                                       
*/
Static Function CalcForm(aFormulas,nMatPrima)
	Local cFormula,nIni,nFim,nPulo,nLinha
	Local nX := 0
	// Projeto Precificacao
	// necessario proteger a execucao da macro
	Local bBlock:=ErrorBlock()
	Local bErro := ErrorBlock( { |e| Erro(e) } )

	If lDirecao
		nIni  := nMatPrima+nQtdTotais+1
		nFim  := Len(aArray)-1
		nPulo := 1
	Else
		nIni  := Len(aArray)-1
		nFim  := nMatPrima+nQtdTotais+1
		nPulo := -1
	EndIf

	//                                                          
	//  Posiciona SB1 no 1. elemento do array, ou seja, o Pai     
	//                                                            
	DbSelectArea("SB1")
	MsSeek(xFilial("SB1")+aArray[1][4])

	// Projeto Precificacao
	// necessario proteger a execucao da macro
	BEGIN SEQUENCE

		For nX := nFim To nIni Step nPulo*-1
			cFormula := aFormulas[nX-nMatPrima-nQtdTotais,1]
			If Len(aArray[nX]) >= 15 .And. aArray[nX][15][2] == "2" .And. C010GetVLine(nX) != Nil
				aArray[nX][6] := C010GetVLine(nX)
			Else
				If     "ERRO" $ cFormula
					aArray[nX][6] := 0
				ElseIf "SE"   $ cFormula
					aArray[nX][6] := SE(cFormula)
				ElseIf "SOMA" $ cFormula
					aArray[nX][6] := SOMA(cFormula)
				ElseIf "#"    $ cFormula
					aArray[nX][6] := CALCULO(cFormula)
				ElseIf "FORMULA" $ cFormula
					aArray[nX][6] := &(cFormula)
				ElseIf "ITPRC" $ cFormula
					aArray[nX][6] := MATA317Cnt(SB1->B1_COD,Substr(cFormula,At("ITPRC",cFormula)+7, Len(SAV->AV_CODPRC) ))
				Else
					aArray[nX][6] := &(cFormula)
				EndIf
			EndIf
			aArray[nx][6] := MC010VCpo(aArray[nx][6])
			If !Empty(Substr(aFormulas[nX-nMatPrima-nQtdTotais,2],2,5))
				nLinha:=Val(Substr(aFormulas[nX-nMatPrima-nQtdTotais,2],2,5))
				If nLinha > 0
					aArray[nX][7] := (aArray[nX][6] / aArray[nLinha,6]) * 100
				EndIf
			EndIf
		Next nX
		For nX := nIni To nFim Step nPulo
			cFormula := aFormulas[nX-nMatPrima-nQtdTotais,1]
			If Len(aArray[nX]) >= 15 .And. aArray[nX][15][2] == "2" .And. C010GetVLine(nX) != Nil
				aArray[nX][6] := C010GetVLine(nX)
			Else
				If     "ERRO" $ cFormula
					aArray[nX][6] := 0
				ElseIf "SE"   $ cFormula
					aArray[nX][6] := SE(cFormula)
				ElseIf "SOMA" $ cFormula
					aArray[nX][6] := SOMA(cFormula)
				ElseIf "#"    $ cFormula
					aArray[nX][6] := CALCULO(cFormula)
				ElseIf "FORMULA" $ cFormula
					aArray[nX][6] := &(cFormula)
				ElseIf "ITPRC" $ cFormula
					aArray[nX][6] := MATA317Cnt(SB1->B1_COD,Substr(cFormula,At("ITPRC",cFormula)+7, Len(SAV->AV_CODPRC) ) )
				Else
					aArray[nX][6] := &(cFormula)
				EndIf
			EndIf
			aArray[nx][6] := MC010VCpo(aArray[nx][6])
			If !Empty(Substr(aFormulas[nX-nMatPrima-nQtdTotais,2],2,5))
				nLinha:=Val(Substr(aFormulas[nX-nMatPrima-nQtdTotais,2],2,5))
				If nLinha > 0
					aArray[nX][7] := (aArray[nX][6] / aArray[nLinha,6]) * 100
				EndIf
			EndIf
		Next nX

		// Projeto Precificacao
		// necessario proteger a execucao da macro
	END SEQUENCE

	ErrorBlock(bBlock)

Return

/*                                                                      
   Fun  o      Se         Autor   Jorge Queiroz           Data   24/06/92                                                                               
   Descri  o   Interpreta a funcao SE. Esta funcao e' igual ao IIF                                                                                      
   Sintaxe     ExpN1 := Se(ExpC1)                                                                                                                       
   Parametros  ExpN1 = Resultado da operacao devolvido pela funcao           
               ExpC1 = Formula a ser interpretada                                                                                                       
    Uso        Generico                                                                                                                                
*/
Static Function Se(cFormula)
	Local nIni,nRet,bBlock:=ErrorBlock(),bErro := errorBlock( { |e| Erro(e) } )

	// Substitui o nome da funcao                                    
	cFormula:=AllTrim(cFormula)
	While ("SE" $ cFormula)
		nIni     := At("SE",cFormula)
		cFormula := SubStr(cFormula,1,nIni-1)+"IF"+SubStr(cFormula,nIni+2,Len(cFormula))
	EndDo

	// Substitui o elemento # da formula por elemento de array      
	cFormula := Substitui(cFormula)

	BEGIN SEQUENCE
		nRet := &cFormula
	END SEQUENCE

	If nRet == NIL
		nRet := 999999999999999999
	EndIf
	ErrorBlock(bBlock)
Return nRet

/*
   Fun  o      Soma       Autor   Jorge Queiroz           Data   24/06/92                                                                               
   Descri  o   Interpreta a funcao SOMA. Esta funcao soma os elementos       
               que estiverem no intervalo passado como parametro.                                                                                       
   Sintaxe     ExpN1 := Soma(ExpC1)                                                                                                                     
   Parametros  ExpN1 = Resultado da operacao devolvido pela funcao           
               ExpC1 = Formula a ser interpretada                                                                                                      
    Uso        Generico                                                      
*/
Static Function Soma(cFormula)
	Local nX,nEleIni,nEleFim,nIni,nFim,nRet:=0
	Local bBlock:=ErrorBlock(),bErro := errorBlock( { |e| Erro(e) } )

	cFormula:=AllTrim(cFormula)

	// Substitui o elemento # da formula por elemento de array      
	cFormula := Substitui(cFormula)

	// Localiza o 1o e o ultimo elemento do array que sera' somado  
	BEGIN SEQUENCE
		nEleIni := At("[",cFormula)+1
		nEleFim := At("]",cFormula)
		nIni := Subs(cFormula,nEleIni,nEleFim-nEleIni)
		nEleIni := Rat("[",SubStr(cFormula,1,Len(cFormula)-4))+1
		nEleFim := Rat("]",SubStr(cFormula,1,Len(cFormula)-4))
		nFim := Subs(cFormula,nEleIni,nEleFim-nEleIni)
		For nX := Val(nIni) To Val(nFim)
			nRet += aArray[nX][6]
		Next nX
	END SEQUENCE
	ErrorBlock(bBlock)
Return nRet

/*                                                             
   Fun  o      Calculo    Autor   Jorge Queiroz           Data   24/06/92                                                                               
   Descri  o   Interpreta a funcao CALCULO. Esta funcao executa diretamen-   
               te seu conteudo , somente operacoes de + - * /.                                                                                          
   Sintaxe     ExpN1 := Calculo(ExpC1)                                                                                                                  
   Parametros  ExpN1 = Resultado da operacao devolvido pela funcao           
               ExpC1 = Formula a ser interpretada                                                                                                       
    Uso        Generico                                                                                                                                                                                                        
*/
Static Function Calculo(cFormula)
	Local nRet
	Local bBlock:=ErrorBlock(),bErro := errorBlock( { |e| Erro(e) } )

	// Substitui o elemento # da formula por elemento de array      
	cFormula := Substitui(cFormula)

	BEGIN SEQUENCE
		nRet := &cFormula
	END SEQUENCE

	If nRet == NIL
		nRet := 999999999999999999
	EndIf
	ErrorBlock(bBlock)
Return nRet

/*                                                                    
   Fun  o      Substitui  Autor   Jorge Queiroz           Data   24/06/92                                                                             
   Descri  o   Substitui os elementos da formula por elementos do array                                                                                 
   Sintaxe     ExpC1 := Substitui(ExpC2)                                                                                                                
   Parametros  ExpC1 = Formula devolvida pela funcao (ja' substituida)       
               ExpC2 = Formula a ser substituida.                                                                                                       
    Uso        Generico                                                      
*/
/*  Não existe parte customizada, podendo ser utilizada rotina do padrão - Valdemir Rabelo 28/05/2020
Function Substitui(cFormula)
	Local nFim,nIni,cNum
	While ("#" $ cFormula)
		nFim := nIni := AT("#",cFormula)+1
		While (IsDigit(SubStr(cFormula,nFim,1)))
			nFim++
		EndDo
		cNum := SubStr(cFormula,nIni,nFim-nIni)
		cNum := "aArray["+cNum+"][6]"
		nIni--
		cFormula:=SubStr(cFormula,1,nIni-1)+cNum+SubStr(cFormula,nFim,Len(cFormula))
	EndDo
Return cFormula
*/

/*
   Fun  o     AcertaForm  Autor   Eveli Morasco           Data   30/06/92                                                                             
   Descri  o   Acerta as formulas qdo insere ou deleta uma linha do array                                                                               
   Sintaxe     ExpC1 := AcertaForm(ExpC2,ExpN1,ExpN2)                                                                                                   
   Parametros  ExpC1 = Formula devolvida pela funcao (ja' acertada)          
               ExpC2 = Formula a ser acertada                                
               ExpN1 = Sera' sempre 1 para inserir e -1 para deletar         
               ExpN2 = Numero do elemento deletado no aArray                                                                                            
    Uso        Generico                                                      
*/
/*			 Não existe parte customizada, podendo ser utilizada rotina do padrão - Valdemir Rabelo 28/05/2020
Function AcertaForm(cFormula,nQtd,n)
	Local nFim,nIni,cNum,nX,cNumAnt
	For nX := 1 To Len(Trim(cFormula))
		If SubStr(cFormula,nX,1) == "#"
			nFim := nIni := nX+1
			While (IsDigit(SubStr(cFormula,nFim,1)))
				nFim++
			EndDo
			If n == Val(SubStr(cFormula,nIni,nFim-nIni)) .And. nQtd == -1
				cFormula := SubStr(cFormula,1,nIni-1)+"ERRO"+SubStr(cFormula,nFim)
				Loop
			ElseIf n <= Val(SubStr(cFormula,nIni,nFim-nIni))
				cNumAnt:= SubStr(cFormula,nIni,nFim-nIni)
				cNum := AllTrim(Str(Val(SubStr(cFormula,nIni,nFim-nIni))+nQtd,5))
				cFormula:=SubStr(cFormula,1,nIni-1)+cNum+SubStr(cFormula,nFim)
				//Acerta o Tamanho do cFormula
				If Len(cNumAnt) > Len(cNum)
					cFormula := cFormula + Space(Len(cNumAnt)-Len(cNum))
				EndIf
			EndIf
		EndIf
	Next nX
Return cFormula
*/


Static Function MC010VCpo(nConta)
	If ValType(nConta) # "N"
		// Projeto Precificacao
		// Nao funcionava quando utilizaca itens de precificacao
		//	nConta := 0
		nConta := Val(nConta)
	EndIf
Return(nConta)

/*                                                                                                                                                                                                                                     
   Fun  o      RecalcTot  Autor   Eveli Morasco           Data   08/04/93                                                                               
   Descri  o   Recalcula as linhas de totais da planilha                                                                                                
   Sintaxe     RecalcTot(ExpN1)                                                                                                                         
   Parametros  ExpN1 = Elemento do array em que inicia a parte de totais                                                                                
    Uso        MATC010                                                                                                                                
*/
Static Function RecalcTot(nMatPrima)
	Local nX,nY

	//                                                    
	//  Zera as linhas de totais                            
	//                                                      
	For nX := 0 To (nQtdTotais-1)
		aArray[nMatPrima+nX][6] := 0
	Next nX

	//                                                    
	//  Calcula novamente os totais                         
	//                                                      
	dbSelectArea("SB1")
	For nX := 1 To (nMatPrima-1)
		aArray[nX][7] := (aArray[nX][6] / aArray[1][6]) * 100
		If MT010ExecF(aArray[nX][4], aArray[nX][8])
			For nY := 0 To (nQtdTotais-1)
				MsSeek(xFilial("SB1")+aArray[nX][4])
				If CondTot(aTotais[nY+1])
					aArray[nMatPrima+nY][6] := aArray[nMatPrima+nY][6] + aArray[nX][6]
				EndIf
			Next nY
		EndIf
	Next nX
	For nX := 0 To (nQtdTotais-1)
		aArray[nMatPrima+nX][7] := Min((aArray[nMatPrima+nX][6] / aArray[1][6]) * 100,100)
	Next nX
Return Nil


/*                                                                           
   Fun  o      CondTot    Autor   Eveli Morasco           Data   08/04/93                                                                               
   Descri  o   Interpreta as condicoes das linhas de totais                                                                                             
   Sintaxe     ExpL1 := CondTot(ExpC1)                                                                                                                  
   Parametros  ExpL1 = Resultado da interpretacao da condicao (.T. ou .F.)   
               ExpC1 = Formula a ser interpretada                                                                                                       
    Uso        MATC010                                                                                                                                 
*/
/*	    Não existe parte customizada, podendo ser utilizada rotina do padrão - Valdemir Rabelo 28/05/2020
Function CondTot(cFormula)
	Local nIni,lRet,bBlock:=ErrorBlock(),bErro := errorBlock( { |e| Erro(e) } )

	*                                                              
	*  Substitui o nome da funcao                                    
	*                                                                
	cFormula:=AllTrim(cFormula)
	While ("SE" $ cFormula)
		nIni     := At("SE",cFormula)
		cFormula := SubStr(cFormula,1,nIni-1)+"IF"+SubStr(cFormula,nIni+2,Len(cFormula))
	EndDo
	BEGIN SEQUENCE
		lRet := &(cFormula)
	END SEQUENCE

	If lRet == NIL .Or. ValType(lRet) != "L"
		lRet := .F.
	EndIf
	ErrorBlock(bBlock)
Return lRet
*/


/*                                                                                                                                                                                                                                     
   Fun  o      Erro       Autor   Jorge Queiroz           Data   24/06/92                                                                               
   Descri  o   Mostra o help quando alguma formula nao estiver OK                                                                                 
*/
/*	  Não existe parte customizada, podendo ser utilizada rotina do padrão - Valdemir Rabelo 28/05/2020
Static Function Erro(e)
	If e:gencode > 0
		If lExibeHelp
			Tone(3000,1)
			Help(" ",1,"FORMUL")
		EndIf
		Break
	EndIf

*/	

/*                                                      
   Fun  o     MC010Forma  Autor   Eveli Morasco           Data   22/06/92                                                                               
   Descri  o   Mostra toda estrutura de um item selecionado com todos seus   
               custos , permitindo simulacoes diversas                                                                                                  
   Sintaxe     MC010Forma(ExpC1,ExpN1,ExpN2,ExpN3,ExpN4,ExpL1,ExpC2)                                                                                    
   Parametros  ExpC1 = Alias do arquivo                                      
               ExpN1 = Numero do registro                                    
               ExpN2 = Numero da opcao selecionada. Se neste campo estiver   
                       o valor 99 , significa que esta funcao foi chamada    
                       pela rotina de impressao da planilha (MATR430) ,se    
                       estiver o valor 98 ,significa que foi chamada pela    
                       rotina de atualizacao de precos (MATA420)             
               ExpN3 = Quantidade Basica (Somente ExpN2 == 99)               
               ExpN4 =                                                       
               ExpL1 = Exibir mensagem de processamento                      
               ExpC2 = Revisao passada pelo MATR430		                                                                                                
    Uso        MATC010                                                                                                                           
*/
User Function STMC010Forma(cAlias,nReg,nOpcx,nQtdBas,nTipo,lMostra,cRevExt,_lCustoStd)

	Local nSavRec,cPictQuant,nX,cArq:=Trim(cArqMemo)+".PDV", cPictVal, cOpc
	Local nUltNivel,cProduto,nMatPrima,nQuant := nNivel := 1
	Local nTamReg:=143,nHdl1,nTamArq,nRegs,cBuffer,cLayout,nIni,nFim,nY,nDif,aFormulas:={}
	Local cTitulo,aPreco, nTamDif
	Local xIdent, xNivel, xDesc, xCod, xQuant, xCusto, xPart, xAlt, xTipo, xDigit, xSz
	Local nOrder:=IndexOrd()
	Local cNivInv
	Local nTamFormula
	Local i := 0
	Local nQuantPe := 1
	Local aMC010Alt := {}
	Local cCarac := ""
	Local _nX := 0

	PRIVATE aInv:={} 		//Array usado para calculo do custo de reposicao
	PRIVATE nOldCusto:=nQualcusto
	PRIVATE cProdPai:=""

	DEFAULT nTipo   := 1
	DEFAULT lMostra := .T.
	DEFAULT cRevExt := ""

	Default _lCustoStd := .F.
	
	// Funcao utilizada para verificar a ultima versao do fonte		
	// SIGACUSB.PRX aplicado no rpo do cliente, assim verificando		
	// a necessidade de uma atualizacao neste fonte. NAO REMOVER !!!	
	If !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20090204)
		Final(STR0015)		//"Atualizar SIGACUSB.PRX !!!"
	EndIf

	SB1->(dbSetOrder(1))	// Ordem correta para montar a estrutura
	aArray := {}
	aHeader:={}
	aTotais:={}

	If nQualcusto == 8
		cArqMemo := "STANDARD"
		cArq := Trim(cArqMemo)+".PDV"
		nQualCusto := 1
	EndIf

	If nOpcx >= 90
		// Esta variavel devera' ficar com .F. quando esta funcao for cha-
		// mada de um programa que nao seja a propria consulta. Ela inibi-
		// ra' as mensagens de help.                                      
		lExibeHelp := .F.
		lConsNeg := If(nOpcx = 98 .or. Type("lConsNeg") # "L", .T., lConsNeg)
	Else
		lConsNeg := mv_par03 = 1
	EndIf

	// Verifica se existe algum dado no arquivo                     
	dbSelectArea( cAlias )
	If RecCount() == 0
		Return .T.
	EndIf

	If cAlias <> "SB1"
		dbSelectArea("SB1")
	Endif
	 
	// Verifica se esta' na filial correta                          
	 
	SX2->( Dbseek("SB1"))
	If SX2->X2_MODO <> "C" .and. cFilAnt != SB1->B1_FILIAL
		Help(" ",1,"A000FI")
		Return .T.
	EndIf

	 
	//  Tenta abrir o arquivo de memorias de calculo                    
	   
	nHdl1 := FOpen(cArq,FO_READWRITE+FO_SHARED)
	If nHdl1 < 0
		Help(" ",1,"MC010FORMU")
		Return .T.
	EndIf

	   
	//  Pega a primeira posicao do arquivo que identifica o NOVO Lay-Out  
	     
	FSeek(nHdl1,0,0)
	cLayout := Space(1)
	Fread(nHdl1,@cLayout,1)

	If .Not. (cLayout == "P")
		If .Not. (cLayout == "N")
			nHdl1 := MC010Conv(nHdl1, cArq)
			If nHdl1 < 0
				Return .F.
			EndIf
		EndIf

		FSeek(nHdl1,0,0)
		cBuffer := Space(3)
		Fread(nHdl1,@cBuffer,3)
		cLayout := Left(cBuffer,1)
		If Val(Right(cBuffer,1)) < 8  // So' ha' conversao para layout "P" caso nao seja arq. binario
			nHdl1 := MC010ConvP(nHdl1, cArq)
			If nHdl1 < 0
				Return .F.
			EndIf
		EndIf
	EndIf

	 
	//  Pega o tamanho do arquivo e o numero de registros               
	   
	nTamArq := Fseek(nHdl1,0,2)
	nRegs   := Int((nTamArq-5)/nTamReg)

	        
	//  Pega a segunda posicao do arquivo que identifica a direcao do calculo  
	          
	Fseek(nHdl1,0,0)
	cBuffer := Space(2)
	Fread(nHdl1,@cBuffer,2)
	lDirecao := .T.
	If Subst(cBuffer,2,1) == "1"
		lDirecao := .F.
	EndIf

	        
	//  Pega a terceira posicao do arquivo que identifica o custo selecionado  
	          
	cBuffer := Space(1)
	Fread(nHdl1,@cBuffer,1)
	nQualCusto := Val(cBuffer)
	If nQualCusto < 1 .Or. nQualCusto > 8
		nQualCusto := 1
	EndIf

	       
	//  Pega a 4a e a 5a posicao do arquivo se a planilha possuir ateh 99     
	//  linhas de totais. Se possuir 100 ou mais linhas de Totais, obtem-se a 
	//  4a, 5a e 6a posicoes                                                  
	         
	cBuffer := Space(8)
	Fread(nHdl1,@cBuffer,8)
	Fseek(nHdl1,0) // Reposicionamento do cursor do arquivo
	Fseek(nHdl1,3)

	cCarac := SubStr(cBuffer,8,8)

	// Se o ultimo caracter da selecao eh uma letra, significa que a planilha
	// contem menos de 100 linhas Totais
	If !(cCarac $ "0123456789")
		cBuffer := Space(2)
		Fread(nHdl1,@cBuffer,2)
	Else
		// Se o ultimo caracter nao for uma letra, significa que a planilha contem
		// 100 ou mais linhas Totais. Assim, eh preciso fazer a leitura de 3 digitos
		cBuffer := Space(3)
		Fread(nHdl1,@cBuffer,3)
	EndIf

	nQtdTotais := Val(cBuffer)

	 
	//  Inicializa o nome do custo                                    
	 
	If nQualCusto     == 1
		cCusto := "STANDARD"
	ElseIf nQualCusto == 2
		cCusto := "MEDIO "+MV_MOEDA1
	ElseIf nQualCusto == 3
		cCusto := "MEDIO "+MV_MOEDA2
	ElseIf nQualCusto == 4
		cCusto := "MEDIO "+MV_MOEDA3
	ElseIf nQualCusto == 5
		cCusto := "MEDIO "+MV_MOEDA4
	ElseIf nQualCusto == 6
		cCusto := "MEDIO "+MV_MOEDA5
	ElseIf nQualCusto == 7
		cCusto := "ULT PRECO"
	ElseIf nQualCusto == 8
		cCusto := "PLANILHA"
	EndIf

	 
	//  Recupera a tela de formacao de precos                         
	 

	cTitulo := STR0001+cArqMemo+STR0002+cCusto+" "		//" Planilha "###" - Custo "
	nSavRec := RecNo()
	If nQualCusto < 8
		//                                                             
		//  Recuperacao padrao de arquivos                               
		//                                                               
		cProduto  := SB1->B1_COD
		cProdPai  := SB1->B1_COD

		//                                                             
		//  Trabalha com a Quantidade Basica do mv_par07 (MATR430)       
		//                                                               
		If nOpcx==99 .Or. nTipo == 2
			nQuant := nQtdBas
		EndIf
		//                                                             
		//  Ponto de Entrada para manipular a quantidade basica          
		//                                                               
		If (ExistBlock('MC010QTD'))
			nQuantPe := ExecBlock('MC010QTD',.F.,.F.,{SB1->B1_COD})
			If ValType(nQuantPe) == "N"
				nQuant := nQuantPe
			Endif
		Endif

		 
		//  Adiciona o primeiro elemento da estrutura , ou seja , o Pai   
		 
		AddArray(nQuant,nNivel,.F.,.T.,NIL)
		AAdd(aInv,{SB1->B1_COD,"100",1,0,0,"0",Len(aInv)+1})
		If mv_par12 == 1
			cOpc := SeleOpc(4,"MATC010",SB1->B1_COD,,,,,,nQuant,dDataBase,If(Empty(mv_par04),SB1->B1_REVATU,mv_par04),mv_par09==2)
		Else
			cOpc := RetFldProd(SB1->B1_COD,"B1_OPC")
		EndIf

		If lMostra
			MsAguarde( {|lEnd| MontStru(cProduto,nQuant,nNivel+1,cOpc,If(nOpcx==99,If(Empty(cRevExt),SB1->B1_REVATU,cRevExt),If(Empty(mv_par04),SB1->B1_REVATU,mv_par04))) }, ;
			STR0012, STR0013, .F. )
		Else
			MontStru(cProduto,nQuant,nNivel+1,cOpc,If(nOpcx==99,If(Empty(cRevExt),SB1->B1_REVATU,cRevExt),If(Empty(mv_par04),SB1->B1_REVATU,mv_par04)),,lMostra,cRevExt,_lCustoStd)
		EndIf

		 
		//  Validacao utilizada para nao permitir B1_TIPO = 'SE', porque  
		//  'SE' e uma palavra reservada utilizada nas formulas.		  
		 
		For nX:= 1 to Len(aArray)
			If aArray[nX,9] $ "SE"
				Aviso("MATC010",STR0010+STR0011,{"Ok"})
				aArray := {}
				Return (aArray)
			EndIf
		Next nX

		//                                                          
		//  ExecBlock Para Inserir Elementos na Estrutura - MC010Add  
		//  Retorno: 1 - Nivel (C/6)                                  
		//           2 - Codigo (C/6)                                 
		//           3 - Descricao (C/50)                             
		//           4 - Quantidade (N)                               
		//           5 - Tipo do Produto (C/2)                        
		//           6 - G1_TRT - Sequencia (C/3)                     
		//           7 - "F"ixo ou "V"ariavel                         
		//                                                            
		If (ExistBlock('MC010ADD'))
			aMC010Add := ExecBlock('MC010ADD',.F.,.F.,cProduto)
			If ValType(aMC010Add) == "A" .And. (Len(aMC010Add)>0)
				For nX := 1 To Len(aMC010Add)
					AAdd(aArray, { Len(aArray)+1,;
					aMC010Add[nX][1],;						// 1 - Nivel
					SubStr(aMC010Add[nX][3],1,38),;	 	// 3 - B1_DESC
					aMC010Add[nX][2],;						// 2 - B1_COD
					aMC010Add[nX][4],;						// 4 - Quantidade
					0,;
					0,;
					.T.,;
					aMC010Add[nX][5],;						// 5 - B1_TIPO
					.F.,;
					aMC010Add[nX][6],;						// 6 - G1_TRT
					IIF(Subs(cAcesso,39,1) != "S",.F.,.T.),;
					aMC010Add[nX][7]})						// 7 - G1_FIXVAR
				Next
			EndIf
		EndIf
		// Ponto de entrada para permitir altera  o na estrutura do produto atrav s do array aArray
		If (ExistBlock('MC010ALT'))
			aMC010Alt := ExecBlock ('MC010ALT',.F.,.F.,{aArray})
			If ValType(aMC010Alt) == "A"
				aArray := aClone(aMC010Alt)
			EndIf
		EndIf

		 
		//  Este vetor (aAuxCusto) deve ser declarado somente no MATR430  
		 
		If nOpcx==99
			aAuxCusto := Array(Len(aArray))
			AFill(aAuxCusto, 0)
		EndIf

		cPictQuant := x3Picture(If(mv_par09==1,"G1_QUANT","GG_QUANT"))
		If Subs(cPictQuant,1,1) == "@"
			cPictQuant := Subs(cPictQuant,1,1)+""+Subs(cPictQuant,2,Len(cPictQuant))
		Else
			cPictQuant := "@E "+cPictQuant
		EndIf

		If nQualCusto     == 2
			cPictVal := x3Picture('B2_CM1')
		ElseIf nQualCusto == 3
			cPictVal := x3Picture('B2_CM2')
		ElseIf nQualCusto == 4
			cPictVal := x3Picture('B2_CM3')
		ElseIf nQualCusto == 5
			cPictVal := x3Picture('B2_CM4')
		ElseIf nQualCusto == 6
			cPictVal := x3Picture('B2_CM5')
		ElseIf nQualCusto == 7
			cPictVal := x3Picture('B1_UPRC')
		Else
			cPictVal := x3Picture('B1_CUSTD')
		EndIf

		If Subs(cPictVal,1,1) == "@"
			cPictVal := Subs(cPictVal,1,1)+""+Subs(cPictVal,2,Len(cPictVal))
		Else
			cPictVal := "@E "+cPictVal
		EndIf
		AAdd(aHeader,{STR0003	   , "99999"})			//"Cel"
		AAdd(aHeader,{STR0004	   , "@9" })			//"Niv"
		AAdd(aHeader,{STR0005	   , "@X" })			//"Descri  o"
		AAdd(aHeader,{STR0006	   , "@!" })			//"Codigo"
		AAdd(aHeader,{STR0007	   , cPictQuant }) 		//"Quantd"
		AAdd(aHeader,{STR0008		, cPictVal })		//"Valor Total"
		AAdd(aHeader,{STR0009      , "@E 999.99" })		//"%Part"

		AAdd(aArray,{   (Len(aArray)+1),;
		"------",;
		Replicate("-",30),;
		Replicate("-",Len(SB1->B1_COD)),;
		0,0,0,.F.,"  ",.F.," ",.T.," " } )

		 
		//  Define a primeira linha com formulas                          
		 
		nMatPrima := Len(aArray)+1

		For nX := 1 To nQtdTotais
			cBuffer := Space(nTamReg)
			Fread(nHdl1,@cBuffer,nTamReg)
			AAdd(aTotais,SubStr(cBuffer,36,100))
			AAdd(aArray, { Len(aArray)+1,;								//[01]
			"------",;										//[02]
			SubStr(cBuffer,6,30),;						//[03]
			Replicate(".",Len(SB1->B1_COD)),;		//[04]
			0,;												//[05]
			0,;												//[06]
			0,;												//[07]
			.F.,;												//[08]
			"MP",;											//[09]
			.F.,;												//[10]
			" ",;												//[11]
			.T.,;												//[12]
			" ",;												//[13]
			" " } )											//[14]

			// Projeto Precificacao
			// incluir os novos campos mesmo que seja leitura direto do arquivo Standard.pdv
			If lInt
				aSize(aArray[Len(aArray)],15)
				aArray[Len(aArray)][15] := { Space(Len(SCO->CO_INTPV)), Space(Len(SCO->CO_INTPUB)) }
			EndIf

		Next nX

		AAdd(aArray,{  Len(aArray)+1,;								// [01]
		"------",;										// [02]
		Replicate("-",30),;							// [03]
		Replicate("-",Len(SB1->B1_COD)),;		// [04]
		0,;												// [05]
		0,;												// [06]
		0,;												// [07]
		.F.,;												// [08]
		"  ",;											// [09]
		.F.,;												// [10]
		" ",;												// [11]
		.T.,;												// [12]
		" ",;												// [13]
		" " } )											// [14]

		 
		//  Le as formulas do arquivo (PDV)                               
		 
		nQtdFormula := nRegs-nQtdTotais
		For nX := 1 To nQtdFormula
			cBuffer := Space(nTamReg)
			Fread(nHdl1,@cBuffer,nTamReg)
			If nDif == NIL
				nDif := nMatPrima - (Val(SubStr(cBuffer,1,5)) - (nQtdTotais+1))
			EndIf
			AAdd(aFormulas,{SubStr(cBuffer,36,100),Substr(cBuffer,136,6)})
			If AT("#",aFormulas[nX,1]) > 0
				nTamFormula := Len(aFormulas[nX,1])
				For nY := 1 To Len(aFormulas[nX,1])
					If SubStr(aFormulas[nX,1],nY,1) == "#"
						nFim := nIni := nY+1
						While (IsDigit(SubStr(aFormulas[nX,1],nFim,1)))
							nFim++
						EndDo
						cNum := AllTrim(Str(Val(SubStr(aFormulas[nX,1],nIni,nFim-nIni))+nDif,5))
						aFormulas[nX,1]:=SubStr(aFormulas[nX,1],1,nIni-1)+cNum+SubStr(aFormulas[nX,1],nFim)
						//Ajusta Tamanho do Campo para 100 posicoes.
						If Len(aFormulas[nX,1]) < 100
							nTamDif := 100 - len(aFormulas[nX,1])
							aFormulas[nX,1] := aFormulas[nX,1] + Space(nTamDif)
						ElseIf Len(aFormulas[nX,1]) > 100
							aFormulas[nX,1] := Substr(aFormulas[nX,1],1,100)
						EndIf
					EndIf
				Next nY
			EndIf
			If AT("#",aFormulas[nX,2]) > 0
				nTamFormula := Len(aFormulas[nX,2])
				For nY := 1 To Len(Trim(aFormulas[nX,2]))
					If SubStr(aFormulas[nX,2],nY,1) == "#"
						nFim := nIni := nY+1
						While (IsDigit(SubStr(aFormulas[nX,2],nFim,1)))
							nFim++
						EndDo
						cNum := AllTrim(Str(Val(SubStr(aFormulas[nX,2],nIni,nFim-nIni))+nDif,5))
						aFormulas[nX,2]:=SubStr(aFormulas[nX,2],1,nIni-1)+cNum+SubStr(aFormulas[nX,2],nFim)
						aFormulas[nx,2]:=aFormulas[nx,2]+Space(6-Len(aFormulas[nx,2]))
						//Ajusta Tamanho do Campo para 6 posicoes.
						If Len(aFormulas[nX,2]) < 6
							nTamDif := 6 - len(aFormulas[nX,2])
							aFormulas[nX,2] := aFormulas[nX,2] + Space(nTamDif)
						ElseIf Len(aFormulas[nX,2]) > 6
							aFormulas[nX,2] := Substr(aFormulas[nX,2],1,6)
						EndIf
					EndIf
				Next nY
			EndIf
			AAdd(aArray, { Len(aArray)+1,;								//[01]
			"------",;										//[02]
			SubStr(cBuffer,6,30),;						//[03]
			Replicate(".",Len(SB1->B1_COD)),;		//[04]
			0,;												//[05]
			0,;												//[06]
			0,;												//[07]
			.T.,;												//[08]
			"  ",;											//[09]
			.F.,;												//[10]
			" ",;												//[11]
			.T.,;												//[12]
			" ",;												//[13]
			" " } )											//[14]

			// Projeto Precificacao
			// incluir os novos campos mesmo que seja leitura direto do arquivo Standard.pdv
			If lInt
				aSize(aArray[Len(aArray)],15)
				aArray[Len(aArray)][15] := { Posicione("SX3",2,"CO_INTPV","X3_RELACAO"), Posicione("SX3",2,"CO_INTPUB","X3_RELACAO") }
			EndIf

		Next nX

		//FClose(nHdl1)

		AAdd(aArray, { Len(aArray)+1,;								// [01]
		"------",;										// [02]
		Replicate("-",30),;							// [03]
		Replicate("-",Len(SB1->B1_COD)),;		// [04]
		0,;												// [05]
		0,;												// [06]
		0,;												// [07]
		.F.,;												// [08]
		"  ",;			  								// [09]
		.F.,;				  								// [10]
		" ",;				  								// [11]
		.T.,;				 								// [12]
		" ",;												// [13]
		" " } )											// [14]

	Else
		//                                                  
		//  Recuperacao de Arquivos tipo PLANILHA             
		//                                                    
		cBuffer := Space(2)
		FRead(nHdl1,@cBuffer,2)
		nLen := Bin2I(cBuffer)

		//                                                  
		//  Montagem do array aArray                          
		//                                                    
		For i:= 1 To nLen
			cBuffer := Space(2)
			FRead(nHdl1,@cBuffer,2)
			xIdent := Bin2I(cBuffer)
			xNivel := Space(6)
			FRead(nHdl1,@xNivel,6)

			cBuffer := Space(2)
			FRead(nHdl1,@cBuffer,2)
			xSz := Bin2I(cBuffer)
			xDesc := Space(xSz)
			FRead(nHdl1,@xDesc,xSz)

			cBuffer := Space(2)
			FRead(nHdl1,@cBuffer,2)
			xSz := Bin2I(cBuffer)
			xCod := Space(xSz)
			FRead(nHdl1,@xCod,xSz)

			cBuffer := Space(2)
			FRead(nHdl1,@cBuffer,2)
			xSz := Bin2I(cBuffer)

			cBuffer := Space(xSz)
			FRead(nHdl1,@cBuffer,xSz)
			xQuant := Val(cBuffer)

			cBuffer := Space(2)
			FRead(nHdl1,@cBuffer,2)
			xSz := Bin2I(cBuffer)
			cBuffer := Space(xSz)
			FRead(nHdl1,@cBuffer,xSz)
			xCusto := Val(cBuffer)
			cBuffer := Space(2)
			FRead(nHdl1,@cBuffer,2)
			xSz := Bin2I(cBuffer)
			cBuffer := Space(xSz)
			FRead(nHdl1,@cBuffer,xSz)
			xPart := Val(cBuffer)
			cBuffer := Space(1)
			FRead(nHdl1,@cBuffer,1)
			xAlt := if(cBuffer=="T",.T.,.F.)
			cBuffer := Space(2)
			FRead(nHdl1,@cBuffer,2)
			xSz := Bin2I(cBuffer)
			xTipo := Space(xSz)
			FRead(nHdl1,@xTipo,xSz)
			cBuffer := Space(1)
			FRead(nHdl1,@cBuffer,1)
			xDigit := if(cBuffer=="T",.T.,.F.)
			AAdd(aArray,{xIdent,xNivel,xDesc,xCod,xQuant,xCusto,xPart,xAlt,xTipo,xDigit,criavar(If(mv_par09==1,"G1_TRT","GG_TRT")), (Subs(cAcesso,39,1)=='S'), CriaVar(If(mv_par09==1,"G1_FIXVAR","GG_FIXVAR"))})
			If xNivel != Replicate("-",Len(xNivel))
				cNivInv:=StrZero(101-Val(Alltrim(xNivel)),3,0)
				AAdd(aInv,{xCod,cNivInv,xQuant,xCusto,0,"0",Len(aInv)+1})
			EndIf
		Next
		cBuffer := Space(2)
		FRead(nHdl1,@cBuffer,2)
		nMatPrima := Bin2I(cBuffer)

		//                                                  
		//  Monta o array aTotais                             
		//                                                    
		cBuffer := Space(2)
		FRead(nHdl1,@cBuffer,2)
		nLen := Bin2I(cBuffer)
		For i:= 1 To nLen
			cBuffer := Space(100)
			FRead(nHdl1,@cBuffer,100)
			AAdd(aTotais,cBuffer)
		Next
		//                                                  
		//  Monta o array aFormulas                           
		//                                                    
		cBuffer := Space(2)
		FRead(nHdl1,@cBuffer,2)
		nLen        := Bin2I(cBuffer)
		nQtdFormula := nLen
		For i:= 1 To nLen
			cBuffer := Space(If(cLayout=="P",106,105))
			FRead(nHdl1,@cBuffer,If(cLayout=="P",106,105))
			If cLayout=="P"
				AAdd(aFormulas,{Left(cBuffer,100), Right(cBuffer,6)})
			Else
				AAdd(aFormulas,{Left(cBuffer,100), Right(cBuffer,5)+" "})
			EndIf
		Next

		//                                                  
		//  Montagem do array aHeader                         
		//                                                    
		cPictQuant := x3Picture(If(mv_par09==1,"G1_QUANT","GG_QUANT"))
		If Subs(cPictQuant,1,1) == "@"
			cPictQuant := Subs(cPictQuant,1,1)+""+Subs(cPictQuant,2,Len(cPictQuant))
		Else
			cPictQuant := "@E "+cPictQuant
		EndIf

		If nQualCusto     == 2
			cPictVal := x3Picture('B2_CM1')
		ElseIf nQualCusto == 3
			cPictVal := x3Picture('B2_CM2')
		ElseIf nQualCusto == 4
			cPictVal := x3Picture('B2_CM3')
		ElseIf nQualCusto == 5
			cPictVal := x3Picture('B2_CM4')
		ElseIf nQualCusto == 6
			cPictVal := x3Picture('B2_CM5')
		ElseIf nQualCusto == 7
			cPictVal := x3Picture('B1_UPRC')
		Else
			cPictVal := x3Picture('B1_CUSTD')
		EndIf

		If Subs(cPictVal,1,1) == "@"
			cPictVal := Subs(cPictVal,1,1)+""+Subs(cPictVal,2,Len(cPictVal))
		Else
			cPictVal := "@E "+cPictVal
		EndIf

		AAdd(aHeader,{STR0003	, "99999"	})		//"Cel"
		AAdd(aHeader,{STR0004	, "@9" })			//"Niv"
		AAdd(aHeader,{STR0005	, "@X" })			//"Descri  o"
		AAdd(aHeader,{STR0006	, "@!" })			//"Codigo"
		AAdd(aHeader,{STR0007	, cPictQuant })		//"Quantd"
		AAdd(aHeader,{STR0008	, cPictVal })		//"Valor Total"
		AAdd(aHeader,{STR0009	, "@E 999.99" })	//"%Part"

		 
		//  Este vetor (aAuxCusto) deve ser declarado somente no MATR430  
		 
		If nOpcx==99
			aAuxCusto := Array(Len(aArray))
			AFill(aAuxCusto, 0)
		EndIf

	EndIf

	FClose(nHdl1)
	/*
	For _nX:=1 To Len(aArray)

	If !("-" $ aArray[_nX][2])
	If aArray[_nX][16]>0

	DbSelectArea("SZO")
	SZO->(DbGoTop())
	SZO->(DbGoTo(aArray[_nX][16]))

	If SZO->(!Eof())
	aAuxCusto[_nX] := SZO->ZO_VALOR
	EndIf

	EndIf
	EndIf

	Next
	*/
	
	nUltNivel := CalcUltNiv()
	CalcTot(nMatPrima,nUltNivel,aFormulas,, nOpcx)
	RecalcTot(nMatPrima)
	CalcForm(aFormulas,nMatPrima)

	If ISINCALLSTACK("MATC010")
		_aDados := array(3)
		_aDados[2] := aArray
		aArray2 := aClone(_aDados)
		aArray := U_STCUSSTD(_aDados,aArray2)
		aArray := aArray[2] 
		nTipo := 2
	EndIf

	If nOpcx < 90 .Or. nTipo == 2
		Browplanw(nMatPrima,@aFormulas,nTipo)
	EndIf

	If nOpcx == 99
		aPreco := {cCusto,aArray,nMatPrima}
		Return (aPreco)
	ElseIf nOpcx == 98
		Return aArray
	EndIf
	dbSelectArea(cAlias)
	dbSetOrder(nOrder)
	dbGoTo(nSavRec)

Return 

/*                                                                           
   Fun  o     MC010Nivel  Autor  Rodrigo de A. Sartorio   Data   25/06/96                                                                               
   Descri  o   Acerta valores na estrutura do custo de reposicao.                                                                                       
    Uso        MATC010                                                                                                                                 
*/
/*	
Function MC010Nivel()
	Local nDecimal:=2
	Local cAlias  :=Alias()
	Local cCampo  :="B1_CUSTD"
	Local nVal    :=0
	Local i       :=0

	 
	//  Verifica qual custo                                           
	 
	If nQualCusto     == 1
		cCampo := "B1_CUSTD"
	ElseIf nQualCusto == 2
		cCampo := "B2_CM1"
	ElseIf nQualCusto == 3
		cCampo := "B2_CM2"
	ElseIf nQualCusto == 4
		cCampo := "B2_CM3"
	ElseIf nQualCusto == 5
		cCampo := "B2_CM4"
	ElseIf nQualCusto == 6
		cCampo := "B2_CM5"
	ElseIf nQualCusto == 7
		cCampo := "B1_UPRC"
	EndIf

	dbSelectArea("SX3")
	dbSetOrder(2)
	If MsSeek(cCampo)
		nDecimal:=X3_DECIMAL
	EndIf
	dbSetOrder(1)
	dbSelectArea(cAlias)

	ASort(aInv,,,{|x,y| x[2]+x[6] < y[2]+y[6] })
	For i:=1 to Len(aInv)
		If i == 1
			aInv[i,5]	:= Round(aInv[i,3] * aInv[i,4],nDecimal)
			nVal      	:= Round(aInv[i,3] * aInv[i,4],nDecimal)
		Else
			If aInv[i,2] > aInv[i-1,2]
				aInv[i,5]	:= Round(aInv[i,3] * nVal,nDecimal)
				nVal		:= Round(aInv[i,3] * nVal,nDecimal)
			Else
				aInv[i,5]	:= Round(aInv[i,3] * aInv[i,4],nDecimal)
				nVal		+= Round(aInv[i,3] * aInv[i,4],nDecimal)
			EndIf
		EndIf
	Next i
	ASort(aInv,,,{|x,y| x[7] < y[7]})
Return NIL
*/

/*                                                                           
   Fun  o     MC010Conv   Autor  Cesar Eduardo Valadao  Data   29/09/1999                                                                            
   Descri  o   Converte o Arquivo .PDV da Planilha p/ Lay-Out 'N'                                                                                       
    Uso        MATC010                                                                                                                                  
*/
Static Function MC010Conv(nHandle, cFilePDV)
	Local i, j, nOldHandle, nNewHandle, cArqBak, cArq:=CriaTrab("",.F.), cBuffer,;
	nTamArq, nRegs, nSize
	FClose(nHandle)
	cArqBak := Left(cFilePDV, At(".", cFilePDV))+"OLD"
	nOldHandle := FOpen(cFilePDV, FO_READ+FO_EXCLUSIVE)
	If nOldHandle < 0
		Help(" ",1,"ABREEXCL")
		Return(-1)
	EndIf
	nNewHandle := FCreate(cArq, 0)
	If nNewHandle < 0
		Help(" ",1,"ABREEXCL")
		Return(-1)
	EndIf

	cBuffer := Space(2)
	FSeek(nOldHandle, 0, 0)
	FRead(nOldHandle,@cBuffer,2)
	nQualCusto := Val(Right(cBuffer,1))
	If nQualCusto < 1 .Or. nQualCusto > 8
		nQualCusto := 1
	EndIf

	If nQualCusto < 8
		nTamArq := FSeek(nOldHandle,0,2)
		nRegs   := Int((nTamArq-4)/84)

		cBuffer := Space(83)
		FSeek(nOldHandle, 0, 0)
		FRead(nOldHandle,@cBuffer, 83)
		FSeek(nNewHandle, 0, 2)
		FWrite(nNewHandle, "N"+cBuffer+Space(55), 139)

		cBuffer := Space(5)
		FRead(nOldHandle,@cBuffer, 5)
		FSeek(nNewHandle, 0, 2)
		FWrite(nNewHandle, Left(cBuffer,3)+"  "+Chr(13)+Chr(10), 7)

		For i := 1 To nRegs-1
			cBuffer := Space(79)
			FRead(nOldHandle,@cBuffer, 79)
			FSeek(nNewHandle, 0, 2)
			FWrite(nNewHandle, cBuffer+Space(55), 134)

			cBuffer := Space(5)
			FRead(nOldHandle,@cBuffer, 5)
			FSeek(nNewHandle, 0, 2)
			FWrite(nNewHandle, Left(cBuffer,3)+"  "+Chr(13)+Chr(10), 7)
		Next
	Else
		cBuffer := Space(6)
		FSeek(nOldHandle, 0, 0)
		FRead(nOldHandle,@cBuffer, 6)
		nRegs := Bin2I(Right(cBuffer,2))
		FSeek(nNewHandle, 0, 2)
		FWrite(nNewHandle, "N"+cBuffer, 7)

		For i := 1 To nRegs
			cBuffer := Space(8)
			FRead(nOldHandle,@cBuffer, 8)
			FSeek(nNewHandle, 0, 2)
			FWrite(nNewHandle, cBuffer, 8)

			For j := 1 To 6
				cBuffer := Space(2)
				FRead(nOldHandle,@cBuffer, 2)
				nSize := Bin2I(cBuffer)+If(j>=5, 1, 0)
				FSeek(nNewHandle, 0, 2)
				FWrite(nNewHandle, cBuffer, 2)

				cBuffer := Space(nSize)
				FRead(nOldHandle,@cBuffer, nSize)
				FSeek(nNewHandle, 0, 2)
				FWrite(nNewHandle, cBuffer, nSize)
			Next
		Next

		cBuffer := Space(4)
		FRead(nOldHandle,@cBuffer, 4)
		nRegs := Bin2I(Right(cBuffer,2))
		FSeek(nNewHandle, 0, 2)
		FWrite(nNewHandle, cBuffer, 4)
		For i := 1 To nRegs
			cBuffer := Space(45)
			FRead(nOldHandle,@cBuffer, 45)
			FSeek(nNewHandle, 0, 2)
			FWrite(nNewHandle, cBuffer+Space(55), 100)
		Next

		cBuffer := Space(2)
		FRead(nOldHandle,@cBuffer, 2)
		nRegs := Bin2I(cBuffer)
		FSeek(nNewHandle, 0, 2)
		FWrite(nNewHandle, cBuffer, 2)
		For i := 1 To nRegs
			cBuffer := Space(48)
			FRead(nOldHandle,@cBuffer, 48)
			FSeek(nNewHandle, 0, 2)
			FWrite(nNewHandle, Left(cBuffer,45)+Space(55)+Right(cBuffer,3)+"  ", 105)
		Next
	EndIf

	FClose(nNewHandle)
	FClose(nOldHandle)

	If File(cArqBak)
		While FErase(cArqBak) == -1 ; End
	EndIf
	While FRename(cFilePDV, cArqBak) == -1 ; End
	While FRename(cArq, cFilePDV) == -1 ; End
	FErase(cArq)

	nNewHandle := FOpen(cFilePDV, FO_READWRITE+FO_SHARED)
	If nNewHandle < 0
		Help(" ",1,"MC010FORMU")
		Return(-1)
	EndIf

Return(nNewHandle)

/*                                                                           
   Fun  o     MC010ConvP  Autor  Ricardo Berti          Data   15/02/2007                                                                               
   Descri  o   Converte o Arquivo .PDV da Planilha p/ novo Lay-Out 'P'                                                                                  
    Uso        MATC010                                                                                                                           
*/
Static Function MC010ConvP(nHandle, cFilePDV)
	Local i, nOldHandle, nNewHandle, cArqBak, cArq:=CriaTrab("",.F.), cBuffer, nTamArq, nRegs
	FClose(nHandle)
	cArqBak := Left(cFilePDV, At(".", cFilePDV))+"OLD"
	nOldHandle := FOpen(cFilePDV, FO_READ+FO_EXCLUSIVE)
	If nOldHandle < 0
		Help(" ",1,"ABREEXCL")
		Return(-1)
	EndIf
	nNewHandle := FCreate(cArq, 0)
	If nNewHandle < 0
		Help(" ",1,"ABREEXCL")
		Return(-1)
	EndIf

	cBuffer := Space(5)
	FSeek(nOldHandle, 0, 0)
	FRead(nOldHandle,@cBuffer,2)
	nQualCusto := Val(Subs(cBuffer,2,1))
	If nQualCusto < 1 .Or. nQualCusto > 8
		nQualCusto := 1
	EndIf

	nTamArq := FSeek(nOldHandle,0,2)
	nRegs   := Int((nTamArq-5)/141)

	cBuffer := Space(146)   // 1o.registro tinha 144, passa para 146
	FSeek(nOldHandle, 0, 0)
	FRead(nOldHandle,@cBuffer, 146)

	FSeek(nNewHandle, 0, 2)
	FWrite(nNewHandle, "P"+Subs(cBuffer,2,4)+"0"+Subs(cBuffer,6,140)+Chr(13)+Chr(10) , 148)

	For i := 1 To nRegs-1
		// reg. antigo tinha 139, passa para 141
		cBuffer := Space(141)
		FRead(nOldHandle,@cBuffer, 141)
		FSeek(nNewHandle, 0, 2)
		FWrite(nNewHandle, "0"+Left(cBuffer,139)+" "+Chr(13)+Chr(10), 143)
	Next

	FClose(nNewHandle)
	FClose(nOldHandle)

	If File(cArqBak)
		While FErase(cArqBak) == -1 ; End
	EndIf
	While FRename(cFilePDV, cArqBak) == -1 ; End
	While FRename(cArq, cFilePDV) == -1 ; End
	FErase(cArq)

	nNewHandle := FOpen(cFilePDV, FO_READWRITE+FO_SHARED)
	If nNewHandle < 0
		Help(" ",1,"MC010FORMU")
		Return(-1)
	EndIf

Return(nNewHandle)

/*                                                                           
   Fun  o     MC010Grava  Autor  Cesar Eduardo Valadao  Data   29/09/1999                                                                               
   Descri  o   Grava o Arquivo .PDV da Planilha                                                                                                         
    Uso        MATC010                                                                                                                       
*/
/*
Function MC010Grava(cArq, cArqAnt, nMatPrima, aFormulas)

	Local nx := 0
	Local i  := 0

	If File(cArq)
		cArqBak := Trim(cArqAnt)+".#PD"
		If File(cArqBak)
			While FErase(cArqBak) == -1 ; End
		EndIf
		While FRename(cArq,cArqBak) == -1 ; End
	EndIf
	//                                                    
	//  Grava a primeira posicao do arquivo que identIfica  
	//  o NOVO lay-out e a segunda a direcao do calculo     
	//                                                      
	If lDirecao
		cBuffer := "P0"
	Else
		cBuffer := "P1"
	EndIf
	nHdl := MSFCREATE(cArq,0)
	FSeek(nHdl,0,2)
	FWrite(nHdl,cBuffer,2)

	//                                                    
	//  Grava a terceira posicao do arquivo que identIfica  
	//  o custo selecionado                                 
	//                                                      
	cBuffer := Str(nQualCusto,1)
	FSeek(nHdl,0,2)
	FWrite(nHdl,cBuffer,1)

	//                                                    
	//  Se tiver menos de 100 linhas de Totais, grava a 4a  
	//  e 5a posicoes, apenas.                              
	//  Se tiver mais de 100 linhas de Totais, grava a 4a,  
	//  5a e 6a posicoes.                                   
	//                                                      
	If nQtdTotais < 100
		cBuffer := StrZero(nQtdTotais,2)
		FSeek(nHdl,0,2)
		FWrite(nHdl,cBuffer,2)
	Else
		cBuffer := StrZero(nQtdTotais,3)
		FSeek(nHdl,0,2)
		FWrite(nHdl,cBuffer,3)
	EndIf

	If nQualCusto < 8
		//                                                    
		//  Grava as condicoes das linhas de totais	            
		//                                                      
		For nX := 0 To (Len(aTotais)-1)
			cBuffer :=  StrZero(nMatPrima+nX,5)+;
			PadR(aArray[nMatPrima+nX][3],30)+;
			PadR(aTotais[nX+1],100)+;
			Space(6)+Chr(13)+Chr(10)
			IIf (nQtdTotais < 100, FSeek(nHdl,0,2), FSeek(nHdl,0,3)) // posiciona de acordo com a quantidade de linhas Totais
			FWrite(nHdl,cBuffer,143)
		Next nX
		//                                                    
		//  Grava o restante das formulas no arquivo (PDV)      
		//                                                      
		For nX := 1 To Len(aFormulas)
			cBuffer :=  StrZero(nMatPrima+nQtdTotais+nX,5)+;
			PadR(aArray[nMatPrima+nQtdTotais+nX][3],30)+;
			PadR(aFormulas[nX,1],100)+;
			aFormulas[nx,2]+Chr(13)+Chr(10)
			FSeek(nHdl,0,2)
			FWrite(nHdl,cBuffer,143)
		Next nX
	Else
		//                                                  
		//  Gravacao de Arquivos tipo PLANILHA 	              
		//                                                    
		FWrite(nHdl,I2Bin(Len(aArray)),2)
		For i:= 1 to Len(aArray)
			FWrite(nHdl,I2Bin(aArray[i,1]),2)
			FWrite(nHdl,aArray[i,2],6)
			FWrite(nHdl,I2Bin(Len(aArray[i,3])),2)
			FWrite(nHdl,aArray[i,3],Len(aArray[i,3]))
			FWrite(nHdl,I2Bin(Len(aArray[i,4])),2)
			FWrite(nHdl,aArray[i,4],Len(aArray[i,4]))
			cVal := Str(aArray[i,5])
			FWrite(nHdl,I2Bin(Len(cVal)),2)
			FWrite(nHdl,cVal,Len(cVal))
			cVal := Str(aArray[i,6])
			FWrite(nHdl,I2Bin(Len(cVal)),2)
			FWrite(nHdl,cVal,Len(cVal))
			cVal := Str(aArray[i,7])
			FWrite(nHdl,I2Bin(Len(cVal)),2)
			FWrite(nHdl,cVal,Len(cVal))
			FWrite(nHdl,If(aArray[i,8],"T","F"),1)
			FWrite(nHdl,I2Bin(Len(aArray[i,9])),2)
			FWrite(nHdl,aArray[i,9],Len(aArray[i,9]))
			FWrite(nHdl,If(aArray[i,10],"T","F"),1)
		Next i
		FWrite(nHdl,I2Bin(nMatPrima),2)
		FWrite(nHdl,I2Bin(Len(aTotais)),2)
		For i:= 1 to Len(aTotais)
			FWrite(nHdl,aTotais[i],100)
		Next i
		FWrite(nHdl,I2Bin(Len(aFormulas)),2)
		For i:= 1 to Len(aFormulas)
			FWrite(nHdl,aFormulas[i,1],100)
			FWrite(nHdl,aFormulas[i,2],6)
		Next i
	EndIf

	   
	//  MC010ARR - Ponto de Entrada utilizado para passar o aArray com   |
	//|            as informacoes da planilha apos a gravacao.           |
	//|                                                                  |
	//| aArray[nX,01] --> Numero da Linha                                |
	//| aArray[nX,02] --> Nivel                                          |
	//| aArray[nX,03] --> B1_DESC                                        |
	//| aArray[nX,04] --> B1_COD                                         |
	//| aArray[nX,05] --> Quantidade do Item                             |
	//| aArray[nX,06] --> Custo do Item                                  |
	//| aArray[nX,07] --> Participacao (%)                               |
	//| aArray[nX,08] --> Reservado                                      |
	//| aArray[nX,09] --> B1_TIPO                                        |
	//| aArray[nX,10] --> Reservado                                      |
	//| aArray[nX,11] --> G1_TRT                                         |
	//| aArray[nX,12] --> Reservado                                      |
	//| aArray[nX,13] --> G1_FIXVAR                                      |
	     
	If ExistBlock("MC010ARR")
		ExecBlock("MC010ARR",.F.,.F.,{aArray,cArq})
	EndIf

	cArqMemo := cArqAnt
	FClose(nHdl)
Return(NIL)
*/
/*                                                                          
   Programa   MT010ExecF Autor   Fernando J Siquini    Data    03/03/04                                                                                 
   Desc.      Verifica se deve executar a Formula para o Componente da       
              Estrutura                                                                                                                                 
   Retorno     Logico onde .T. executa formula e .F. nao executa                                                                                        
   Uso         MATC010X                                                                                                                                                                                                           
*/
Static Function MT010ExecF(cCod, lExecuta)

	Local aAreaAnt   := {}
	Local aAreaSB1   := {}
	Local lRet       := lExecuta
	Local lRetPE     := .F.

	Static lMT010FO    := Nil

	If lMT010FO == Nil
		lMT010FO := ExistBlock('MT010FO')
	EndIf

	If lMT010FO
		aAreaAnt := GetArea()
		aAreaSB1 := SB1->(GetArea())
		If SB1->(MSSeek(xFilial('SB1')+cCod, .F.))
			               
			// Ponto de Entrada MT010FO                                                       
			// Parametros passados:                                                           
			// PARAMIXB[1] = Codigo do produto (jah estah posicionado no SB1 correspondente)  
			// Parametro Recebido:                                                            
			// Logico = Executa (.T.) ou Nao Executa (.F.) a Formula                          
			// ou                                                                             
			// Nil    = A definicao da execucao eh feita pelo sistema                         
			                 
			lRet := If(	ValType(lRetPE:=ExecBlock('MT010FO', .F., .F., {cCod}))	=='L', lRetPE, lRet)
		EndIf
		RestArea(aAreaSB1)
		RestArea(aAreaAnt)
	EndIf

Return lRet

/*  
   Fun  o     MC010Form2  Autor   Turibio Miranda         Data   10/09/10      
   Descri  o   Mostra toda estrutura de um item selecionado com todos seus   
               custos , permitindo simulacoes diversas                        
   Sintaxe     MC010Form2(ExpC1,ExpN1,ExpN2,ExpN3,ExpN4,ExpL1,ExpC2)          
   Parametros  ExpC1 = Alias do arquivo                                      
               ExpN1 = Numero do registro                                    
               ExpN2 = Numero da opcao selecionada. Se neste campo estiver   
                       o valor 99 , significa que esta funcao foi chamada    
                       pela rotina de impressao da planilha (MATR430) ,se    
                       estiver o valor 98 ,significa que foi chamada pela    
                       rotina de atualizacao de precos (MATA420)             
               ExpN3 = Quantidade Basica (Somente ExpN2 == 99)               
               ExpN4 =                                                       
               ExpL1 = Exibir mensagem de processamento                      
               ExpC2 = Revisao passada pelo MATR430		                                                                                              
    Uso        MATC010                                                                                                                                   
*/
/*
Static Function MC010Form2(cAlias,nReg,nOpcx,nQtdBas,nTipo,lMostra,cRevExt,lPesqR,cCodP,cCodR)
	Local nSavRec,cPictQuant,nX,cArq          := Trim(cArqMemo), cPictVal, cOpc
	Local nUltNivel,cProduto,nMatPrima,nQuant := nNivel := 1
	Local nTamReg                             := 143,nHdl1,nTamArq,nRegs,cBuffer,cLayout,nIni,nFim,nY,nDif,aFormulas:={}
	Local cTitulo,aPreco, nTamDif
	Local xIdent, xNivel, xDesc, xCod, xQuant, xCusto, xPart, xAlt, xTipo, xDigit, xSz
	Local nOrder                              := IndexOrd()
	Local cNivInv, cQuery, cAliasTRB
	Local nTamFormula
	Local i                                   := 0
	Local nQuantPe                            := 1
	Local aMC010Alt                           := {}
	Local lPesqRev                            := If(Type("lPesqRev") == "L"	, lPesqRev	,If(ValType(lPesqR) == "L" , lPesqR	, .F.))
	Local cCodplan                            := If(Type("cCodPlan") == "C"	, cCodPlan	,If(ValType(cCodP)  == "C" , cCodP	, "" ))
	Local cCodRev                             := If(Type("cCodRev") == "C"	, cCodRev	,If(ValType(cCodR)  == "C" , cCodR	, "" ))
	Local cTCGetDB                            := TCGetDB()

	PRIVATE aInv      := {} //Array usado para calculo do custo de reposicao
	PRIVATE nOldCusto := nQualcusto
	PRIVATE cProdPai  := ""
	Private aAuxCusto := array(1)
	Private _aCusOri  := {}

	DEFAULT nTipo     := 1
	DEFAULT lMostra   := .T.
	DEFAULT cRevExt   := ""

	//  Funcao utilizada para verificar a ultima versao do fonte		 
	//  SIGACUSB.PRX aplicado no rpo do cliente, assim verificando		|
	//  a necessidade de uma atualizacao neste fonte. NAO REMOVER !!!	 
	    
	If !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20090204)
		Final(STR0015)	//"Atualizar SIGACUSB.PRX !!!"
	EndIf

	dbSetOrder(1)	// Ordem correta para montar a estrutura
	aArray := {}
	aHeader:={}
	aTotais:={}
	nSavRec := RecNo()
	If nQualcusto == 8
		cArqMemo := "STANDARD"
		cArq := Trim(cArqMemo)+".PDV"
		nQualCusto := 1
	EndIf

	If nOpcx >= 90
		 
		//  Esta variavel devera' ficar com .F. quando esta funcao for cha- 
		//  mada de um programa que nao seja a propria consulta. Ela inibi- 
		//  ra' as mensagens de help.                                       
		   
		lExibeHelp := .F.
		lConsNeg := If(nOpcx = 98 .or. Type("lConsNeg") # "L", .T., lConsNeg)
	Else
		lConsNeg := mv_par03 = 1
	EndIf

	 
	//  Verifica se existe algum dado no arquivo                      
	 
	dbSelectArea( cAlias )
	If RecCount() == 0
		Return .T.
	EndIf

	If cAlias <> "SB1"
		dbSelectArea("SB1")
	Endif
	 
	//  Verifica se esta' na filial correta                           
	 
	// Projeto Precificacao
	// Verifica se a filial est  correta somente se a tabela nao for compartilhada

	If lSB1Ok == nil
		If SX2->( Dbseek("SB1"))
			lSB1Ok:= SX2->X2_MODO <> "C" .and. cFilAnt != SB1->B1_FILIAL
		EndIf
	EndIf

	If lSB1Ok
		Help(" ",1,"A000FI")
		Return .T.
	EndIf

	//                                                               
	//  Consulta se deve buscar a revis o pelo nome.
	  
	If lPesqRev .And. (Empty(cCodPlan) .Or. Empty(cCodRev))
		cCodPlan	:= ""
		cCodRev	:= ""
		GetPlanRev(cArqMemo,@cCodPlan,@cCodRev)
		If Empty(cCodPlan) .Or. Empty(cCodRev)
			lPesqRev := .F.
		EndIf
	EndIf

	//                                                               
	//  Consulta se o produto possui arquivo de revisoes para sugerir  
	// 	a ultima revisao utilizada									   
	  
	#IFDEFTOP
	cAliasTRB := GetNextAlias()
	cQuery:="SELECT CO_CODIGO, CO_REVISAO, CO_NOME, CO_TPCUSTO FROM "+RetSqlName("SCO")+" "+(cAliasTRB)+" "
	cQuery+="WHERE CO_FILIAL='"+xFilial("SCO")+"'  AND D_E_L_E_T_<>'*'"
	If lPesqRev
		cQuery+= " AND CO_CODIGO ='"+cCodPlan+"'"
		cQuery+= " AND CO_REVISAO ='"+cCodRev+"'"
	EndIf
	cQuery+= "Order By CO_CODIGO Desc, CO_REVISAO Desc "
	If cTCGetDB=="DB2"
		cQuery += " FOR READ ONLY"
	EndIf
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasTRB),.F.,.T.)
	#ELSE
	cAliasTRB := "SCO"
	cQuery := '(CO_FILIAL=="' +xFilial("SCO") +'")'
	If lPesqRev
		cQuery += ' .And. (CO_CODIGO == "' + cCodPlan +'") .And. (CO_REVISAO == "'+cCodRev+'")'
	EndIf
	IndRegua("SCO",cAliasTRB,"CO_FILIAL+CO_CODIGO+CO_REVISAO",,cQuery,"")
	dbSelectArea(cAliasTRB)
	(cAliasTRB)->(dbGoBottom())
	#ENDIF
	lPesqRev:= .F.
	If  (cAliasTRB)->(!Eof())
		cCodPlan:= (cAliasTRB)->CO_CODIGO
		cCodRev := (cAliasTRB)->CO_REVISAO
		cArqMemo:= Alltrim((cAliasTRB)->CO_NOME)
		 
		//  Pega o Custo utilizado na ultima revisao da planilha		  
		 
		nQualCusto := (cAliasTRB)->CO_TPCUSTO
		(cAliasTRB)->(DbCloseArea())
	Else
		(cAliasTRB)->(DbCloseArea())
		cArqMemo:= "STANDARD"
		DbSelectArea("SB1")
		If lMostra
			MC010Forma("SB1",nSavRec,2)
		EndIf
		Return .T.
	EndIf
	 
	//  Pega o tamanho do arquivo e o numero de registros               
	   
	#IFDEF TOP
	cAliasTRB := GetNextAlias()
	cQuery:="SELECT Count (CO_TPLINHA) As Recs FROM "+RetSqlName("SCO")+" "+(cAliasTRB)+" "
	cQuery+="WHERE CO_FILIAL='"+xFilial("SCO")+"'  AND D_E_L_E_T_<>'*'"
	cQuery+= " AND CO_CODIGO ='"+cCodPlan+"'"
	cQuery+= " AND CO_REVISAO ='"+cCodRev+"'"
	If cTCGetDB=="DB2"
		cQuery += " FOR READ ONLY"
	EndIf
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasTRB),.F.,.T.)
	nRegs:= (cAliasTRB)->RECS
	#ELSE
	cAliasTRB := "SCO"
	cQuery := '(CO_FILIAL=="' +xFilial("SCO") +'") .And. (CO_CODIGO == "'+cCodPlan+'") .And. '
	cQuery += '(CO_REVISAO == "' + cCodRev +'")'
	IndRegua("SCO",cAliasTRB,"CO_FILIAL+CO_CODIGO+CO_REVISAO",,cQuery,"")
	dbSelectArea(cAliasTRB)
	While (cAliasTRB)->(!Eof())
		nRegs ++
		(cAliasTRB)->(dbSkip())
	EndDo
	#ENDIF
	(cAliasTRB)->(DbCloseArea())

	If nQualCusto < 1 .Or. nQualCusto > 8
		nQualCusto := 1
	EndIf

	       
	//  Varre a revisao da planilhaidentificar quantas linhas de totais 	  
	// existem na planilha  											      
	         
	#IFDEF TOP
	cAliasTRB := GetNextAlias()
	cQuery:="SELECT Count (CO_TPLINHA) As Recs FROM "+RetSqlName("SCO")+" "+(cAliasTRB)+" "
	cQuery+="WHERE CO_FILIAL='"+xFilial("SCO")+"'  AND D_E_L_E_T_<>'*'"
	cQuery+= " AND CO_CODIGO ='"+cCodPlan+"'"
	cQuery+= " AND CO_REVISAO ='"+cCodRev+"'"
	cQuery+= " AND CO_TPLINHA ='T'"
	If cTCGetDB=="DB2"
		cQuery += " FOR READ ONLY"
	EndIf
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasTRB),.F.,.T.)
	nQtdTotais := (cAliasTRB)->RECS
	#ELSE
	nQtdTotais := 0
	cAliasTRB := "SCO"
	cQuery := '(CO_FILIAL=="' +xFilial("SCO") +'") .And. (CO_CODIGO == "'+cCodPlan+'") .And. '
	cQuery += '(CO_REVISAO == "' + cCodRev +'") .And. (CO_TPLINHA == "T")'
	IndRegua("SCO",cAliasTRB,"CO_FILIAL+CO_CODIGO+CO_REVISAO",,cQuery,"")
	dbSelectArea(cAliasTRB)
	While (cAliasTRB)->(!Eof())
		nQtdTotais ++
		(cAliasTRB)->(dbSkip())
	EndDo
	#ENDIF
	(cAliasTRB)->(DbCloseArea())

	 
	//  Inicializa o nome do custo                                    
	 
	If nQualCusto     == 1
		cCusto := "STANDARD"
	ElseIf nQualCusto == 2
		cCusto := "MEDIO "+MV_MOEDA1
	ElseIf nQualCusto == 3
		cCusto := "MEDIO "+MV_MOEDA2
	ElseIf nQualCusto == 4
		cCusto := "MEDIO "+MV_MOEDA3
	ElseIf nQualCusto == 5
		cCusto := "MEDIO "+MV_MOEDA4
	ElseIf nQualCusto == 6
		cCusto := "MEDIO "+MV_MOEDA5
	ElseIf nQualCusto == 7
		cCusto := "ULT PRECO"
	ElseIf nQualCusto == 8
		cCusto := "PLANILHA"
	EndIf
	 
	//  Recupera a tela de formacao de precos                         
	 
	cTitulo := STR0001+Alltrim(cArqMemo)+STR0002+cCusto+" "		//" Planilha "###" - Custo "
	nSavRec := RecNo()
	//                                                             
	//  Recuperacao padrao de arquivos                               
	//                                                               
	cProduto  := SB1->B1_COD
	cProdPai  := SB1->B1_COD

	//                                                             
	//  Trabalha com a Quantidade Basica do mv_par07 (MATR430)       
	//                                                               
	If nOpcx==99 .Or. nTipo == 2
		nQuant := nQtdBas
	EndIf
	//                                                             
	//  Ponto de Entrada para manipular a quantidade basica          
	//                                                               
	If (ExistBlock('MC010QTD'))
		nQuantPe := ExecBlock('MC010QTD',.F.,.F.,{SB1->B1_COD})
		If ValType(nQuantPe) == "N"
			nQuant := nQuantPe
		Endif
	Endif

	 
	//  Adiciona o primeiro elemento da estrutura , ou seja , o Pai   
	 
	AddArray(nQuant,nNivel,.F.,.T.,NIL)
	AAdd(aInv,{SB1->B1_COD,"100",1,0,0,"0",Len(aInv)+1})
	If mv_par12 == 1
		cOpc := SeleOpc(4,"MATC010",SB1->B1_COD,,,,,,nQuant,dDataBase,If(Empty(mv_par04),SB1->B1_REVATU,mv_par04),mv_par09==2)
	Else
		cOpc := RetFldProd(SB1->B1_COD,"B1_OPC")
	EndIf
	If lMostra
		MsAguarde( {|lEnd| MontStru(cProduto,nQuant,nNivel+1,cOpc,If(nOpcx==99,If(Empty(cRevExt),SB1->B1_REVATU,cRevExt),If(Empty(mv_par04),SB1->B1_REVATU,mv_par04))) }, ;
		STR0012, STR0013, .F. )
	Else
		MontStru(cProduto,nQuant,nNivel+1,cOpc,If(nOpcx==99,If(Empty(cRevExt),SB1->B1_REVATU,cRevExt),If(Empty(mv_par04),SB1->B1_REVATU,mv_par04)),,lMostra,cRevExt)
	EndIf

	 
	//  Validacao utilizada para nao permitir B1_TIPO = 'SE', porque  
	//  'SE' e uma palavra reservada utilizada nas formulas.		  
	 
	For nX:= 1 to Len(aArray)
		If aArray[nX,9] $ "SE"
			Aviso("MATC010",STR0010+STR0011,{"Ok"})
			Return (.F.)
		EndIf
	Next nX

	//                                                          
	//  ExecBlock Para Inserir Elementos na Estrutura - MC010Add  
	//  Retorno: 1 - Nivel (C/6)                                  
	//           2 - Codigo (C/6)                                 
	//           3 - Descricao (C/50)                             
	//           4 - Quantidade (N)                               
	//           5 - Tipo do Produto (C/2)                        
	//           6 - G1_TRT - Sequencia (C/3)                     
	//           7 - "F"ixo ou "V"ariavel                         
	//                                                            
	If (ExistBlock('MC010ADD'))
		aMC010Add := ExecBlock('MC010ADD',.F.,.F.,cProduto)
		If ValType(aMC010Add) == "A" .And. (Len(aMC010Add)>0)
			For nX := 1 To Len(aMC010Add)
				AAdd(aArray, { Len(aArray)+1,;
				aMC010Add[nX][1],;						// 1 - Nivel
				SubStr(aMC010Add[nX][3],1,38),;	 	// 3 - B1_DESC
				aMC010Add[nX][2],;						// 2 - B1_COD
				aMC010Add[nX][4],;						// 4 - Quantidade
				0,;
				0,;
				.T.,;
				aMC010Add[nX][5],;						// 5 - B1_TIPO
				.F.,;
				aMC010Add[nX][6],;						// 6 - G1_TRT
				IIF(Subs(cAcesso,39,1) != "S",.F.,.T.),;
				aMC010Add[nX][7]})						// 7 - G1_FIXVAR
			Next
		EndIf
	EndIf

	If (ExistBlock('MC010ALT'))
		aMC010Alt := ExecBlock ('MC010ALT',.F.,.F.,{aArray})
		If ValType(aMC010Alt) == "A"
			aArray := aClone(aMC010Alt)
		EndIf
	EndIf

	 
	//  Este vetor (aAuxCusto) deve ser declarado somente no MATR430  
	 
	If nOpcx==99
		aAuxCusto := Array(Len(aArray))
		AFill(aAuxCusto, 0)
	EndIf

	cPictQuant := x3Picture(If(mv_par09==1,"G1_QUANT","GG_QUANT"))
	If Subs(cPictQuant,1,1) == "@"
		cPictQuant := Subs(cPictQuant,1,1)+""+Subs(cPictQuant,2,Len(cPictQuant))
	Else
		cPictQuant := "@E "+cPictQuant
	EndIf

	If nQualCusto     == 2
		cPictVal := x3Picture('B2_CM1')
	ElseIf nQualCusto == 3
		cPictVal := x3Picture('B2_CM2')
	ElseIf nQualCusto == 4
		cPictVal := x3Picture('B2_CM3')
	ElseIf nQualCusto == 5
		cPictVal := x3Picture('B2_CM4')
	ElseIf nQualCusto == 6
		cPictVal := x3Picture('B2_CM5')
	ElseIf nQualCusto == 7
		cPictVal := x3Picture('B1_UPRC')
	Else
		cPictVal := x3Picture('B1_CUSTD')
	EndIf

	If Subs(cPictVal,1,1) == "@"
		cPictVal := Subs(cPictVal,1,1)+""+Subs(cPictVal,2,Len(cPictVal))
	Else
		cPictVal := "@E "+cPictVal
	EndIf
	AAdd(aHeader,{STR0003	   , "99999"})			//"Cel"
	AAdd(aHeader,{STR0004	   , "@9" })			//"Niv"
	AAdd(aHeader,{STR0005	   , "@X" })			//"Descri  o"
	AAdd(aHeader,{STR0006	   , "@!" })			//"Codigo"
	AAdd(aHeader,{STR0007	   , cPictQuant }) 		//"Quantd"
	AAdd(aHeader,{STR0008		, cPictVal })		//"Valor Total"
	AAdd(aHeader,{STR0009      , "@E 999.99" })		//"%Part"

	AAdd(aArray,{   (Len(aArray)+1),;
	"------",;
	Replicate("-",30),;
	Replicate("-",Len(SB1->B1_COD)),;
	0,0,0,.F.,"  ",.F.," ",.T.," " } )

	 
	//  Define a primeira linha com formulas                          
	 
	nMatPrima  := Len(aArray)+1
	 
	//  Determina o total de linhas de formula utilizadas             
	 
	#IFDEF TOP
	cAliasTRB := GetNextAlias()
	cQuery:="SELECT Count (CO_TPLINHA) As Recs FROM "+RetSqlName("SCO")+" "+(cAliasTRB)+" "
	cQuery+="WHERE CO_FILIAL='"+xFilial("SCO")+"'  AND D_E_L_E_T_<>'*'"
	cQuery+= " AND CO_CODIGO ='"+cCodPlan+"'"
	cQuery+= " AND CO_REVISAO ='"+cCodRev+"'"
	cQuery+= " AND CO_TPLINHA ='F'"
	If cTCGetDB=="DB2"
		cQuery += " FOR READ ONLY"
	EndIf
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasTRB),.F.,.T.)
	nQtdFormula:=(cAliasTRB)->RECS
	#ELSE
	nQtdFormula := 0
	cAliasTRB := "SCO"
	cQuery := '(CO_FILIAL=="' +xFilial("SCO") +'").And.(CO_CODIGO == "'+cCodPlan+'").And.'
	cQuery += '(CO_REVISAO == "' + cCodRev +'") .And. (CO_TPLINHA == "F")'
	IndRegua("SCO",cAliasTRB,"CO_FILIAL+CO_CODIGO+CO_REVISAO",,cQuery,"")
	dbSelectArea(cAliasTRB)
	While (cAliasTRB)->(!Eof())
		nQtdFormula++
		(cAliasTRB)->(dbSkip())
	EndDo
	#ENDIF
	(cAliasTRB)->(DbCloseArea())
	//                                                               
	//  Seleciona os totais da revisao da planilha posicionada	       
	  
	#IFDEF TOP
		cAliasTRB := GetNextAlias()
		cQuery:= " SELECT CO_FORMULA, CO_DESC"
		If lInt
			cQuery += ",CO_INTPV, CO_INTPUB"
		EndIf
		cQuery+= " FROM "+RetSqlName("SCO")+" "+(cAliasTRB)+" "
		cQuery+= " WHERE CO_FILIAL='"+xFilial("SCO")+"'  AND D_E_L_E_T_<>'*'"
		cQuery+= " AND CO_CODIGO ='"+cCodPlan+"'"
		cQuery+= " AND CO_REVISAO ='"+cCodRev+"'"
		cQuery+= " AND CO_TPLINHA ='T'"
		If cTCGetDB=="DB2"
			cQuery += " FOR READ ONLY"
		EndIf
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasTRB),.F.,.T.)
	#ELSE
		cAliasTRB := "SCO"
		cQuery := '(CO_FILIAL=="' +xFilial("SCO") +'").And.(CO_CODIGO == "'+cCodPlan+'").And.'
		cQuery += '(CO_REVISAO == "' + cCodRev +'") .And. (CO_TPLINHA == "T")'
		IndRegua("SCO",cAliasTRB,"CO_FILIAL+CO_CODIGO+CO_REVISAO",,cQuery,"")
		dbSelectArea(cAliasTRB)
	#ENDIF

	While (cAliasTRB)->(!Eof())
		AAdd(aTotais,(cAliasTRB)->CO_FORMULA )
		AAdd(aArray, { Len(aArray)+1,"------",;
		(cAliasTRB)->CO_DESC,;//GO_DESC
		Replicate(".",Len(SB1->B1_COD)),0,0,0,.F.,"MP",.F.," ",.T.," " } )
		If lInt
			aSize(aArray[Len(aArray)],15)
			aArray[Len(aArray)][15] := { (cAliasTRB)->CO_INTPV, (cAliasTRB)->CO_INTPUB }
		EndIf
		(cAliasTRB)->(DbSkip())
	EndDo

	AAdd(aArray,{  Len(aArray)+1,;
	"------",;
	Replicate("-",30),;
	Replicate("-",Len(SB1->B1_COD)),;
	0,0,0,.F.,"  ",.F.," ",.T.," " } )
	(cAliasTRB)->(DbCloseArea())
	 
	//  Le as formulas da revisao da planilha                         
	 
	#IFDEF TOP
		cAliasTRB := GetNextAlias()
		cQuery:= " SELECT CO_LINHA, CO_FORMULA, CO_DESC, CO_CELPERC"
		If lInt
			cQuery += ",CO_INTPV, CO_INTPUB"
		EndIf
		cQuery+= " FROM "+RetSqlName("SCO")+" "+(cAliasTRB)+" "
		cQuery+= " WHERE CO_FILIAL='"+xFilial("SCO")+"'  AND D_E_L_E_T_<>'*'"
		cQuery+= " AND CO_CODIGO ='"+cCodPlan+"'"
		cQuery+= " AND CO_REVISAO ='"+cCodRev+"'"
		cQuery+= " AND CO_TPLINHA ='F'"
		If cTCGetDB=="DB2"
			cQuery += " FOR READ ONLY"
		EndIf
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasTRB),.F.,.T.)
	#ELSE
		cAliasTRB := "SCO"
		cQuery := '(CO_FILIAL=="' +xFilial("SCO") +'").And.(CO_CODIGO == "'+cCodPlan+'").And.'
		cQuery += '(CO_REVISAO == "' + cCodRev +'") .And. (CO_TPLINHA == "F")'
		IndRegua("SCO",cAliasTRB,"CO_FILIAL+CO_CODIGO+CO_REVISAO",,cQuery,"")
		dbSelectArea(cAliasTRB)
	#ENDIF
	nX:= 1
	While (cAliasTRB)->(!Eof())
		If nDif == NIL
			nDif := nMatPrima - (Val((cAliasTRB)->CO_LINHA) - (nQtdTotais))
		EndIf
		AAdd(aFormulas,{(cAliasTRB)->CO_FORMULA,(cAliasTRB)->CO_CELPERC})
		If !Empty(aFormulas[nX,1])
			nTamFormula := Len(aFormulas[nX,1])
			For nY := 1 To Len(aFormulas[nX,1])
				If SubStr(aFormulas[nX,1],nY,1) == "#"
					nFim := nIni := nY+1
					While (IsDigit(SubStr(aFormulas[nX,1],nFim,1)))
						nFim++
					EndDo
					cNum := AllTrim(Str(Val(SubStr(aFormulas[nX,1],nIni,nFim-nIni))+nDif,5))
					aFormulas[nX,1]:=SubStr(aFormulas[nX,1],1,nIni-1)+cNum+SubStr(aFormulas[nX,1],nFim)
					//Ajusta Tamanho do Campo para 100 posicoes.
					If Len(aFormulas[nX,1]) < 100
						nTamDif := 100 - len(aFormulas[nX,1])
						aFormulas[nX,1] := aFormulas[nX,1] + Space(nTamDif)
					ElseIf Len(aFormulas[nX,1]) > 100
						aFormulas[nX,1] := Substr(aFormulas[nX,1],1,100)
					EndIf
				EndIf
			Next nY
		EndIf
		If !Empty(aFormulas[nX,2])
			nTamFormula := Len(aFormulas[nX,2])
			For nY := 1 To Len(Trim(aFormulas[nX,2]))
				If SubStr(aFormulas[nX,2],nY,1) == "#"
					nFim := nIni := nY+1
					While (IsDigit(SubStr(aFormulas[nX,2],nFim,1)))
						nFim++
					EndDo
					cNum := AllTrim(Str(Val(SubStr(aFormulas[nX,2],nIni,nFim-nIni))+nDif,5))
					aFormulas[nX,2]:=SubStr(aFormulas[nX,2],1,nIni-1)+cNum+SubStr(aFormulas[nX,2],nFim)
					aFormulas[nx,2]:=aFormulas[nx,2]+Space(6-Len(aFormulas[nx,2]))
					//Ajusta Tamanho do Campo para 6 posicoes.
					If Len(aFormulas[nX,2]) < 6
						nTamDif := 6 - len(aFormulas[nX,2])
						aFormulas[nX,2] := aFormulas[nX,2] + Space(nTamDif)
					ElseIf Len(aFormulas[nX,2]) > 6
						aFormulas[nX,2] := Substr(aFormulas[nX,2],1,6)
					EndIf
				EndIf
			Next nY
		EndIf
		AAdd(aArray, { Len(aArray)+1,"------",;
		(cAliasTRB)->CO_DESC,;
		Replicate(".",Len(SB1->B1_COD)),0,0,0,.T.,"  ",.F.," ",.T.," " } )

		If lInt
			aSize(aArray[Len(aArray)],15)
			aArray[Len(aArray)][15] := { (cAliasTRB)->CO_INTPV, (cAliasTRB)->CO_INTPUB }
		EndIf

		nX++
		(cAliasTRB)->(DbSkip())
	EndDo

	(cAliasTRB)->(DbCloseArea())

	AAdd(aArray, { Len(aArray)+1,;
	"------",;
	Replicate("-",30),;
	Replicate("-",Len(SB1->B1_COD)),;
	0,0,0,.F.,"  ",.F.," ",.T.," " } )

	nUltNivel := CalcUltNiv()
	CalcTot(nMatPrima,nUltNivel,aFormulas,, nOpcx)
	RecalcTot(nMatPrima)
	CalcForm(aFormulas,nMatPrima)
	
	If nOpcx < 90 .Or. nTipo == 2
		Browplanw(nMatPrima,@aFormulas,nTipo)
	EndIf

	If nOpcx == 99
		aPreco := {cCusto,aArray,nMatPrima}
		Return (aPreco)
	ElseIf nOpcx == 98
		Return aArray
	EndIf
	dbSelectArea(cAlias)
	dbSetOrder(nOrder)
	dbGoTo(nSavRec)

   *** Sem finalização de Return, porém não está sendo utilizado Valdemir Rabelo 28/05/2020
*/	

/*                                                                           
   Fun  o     MC010Rev    Autor  Turibio Miranda	    Data   15/09/2000                                                                               
   Descri  o   Grava revisao da planilha de formacao de precos                                                                                          
    Uso        MATC010                                                                                                                               
*/
/*
Function MC010Rev(cArq, cArqAnt, nMatPrima, aFormulas)

	Local nx  	:= 0
	Local nCel	:= nMatPrima-1

	//                                              
	//  Grava estrutura calculada na planilha         
	//                                                
	For nX := 1 To Len(aArray)
		If aArray[nX][2]$"------"
			Exit
		EndIf
		RecLock("SCO",.T.)
		SCO->CO_FILIAL := xFilial("SCO")
		SCO->CO_CODIGO := cCodPlan
		SCO->CO_REVISAO:= cCodRev
		SCO->CO_NOME   := cArqAnt
		SCO->CO_LINHA  := StrZero(nX,5)
		SCO->CO_PRODUTO:= aArray[nX][4]
		SCO->CO_DESC   := PadR(aArray[nX][3],30)
		SCO->CO_NIVEL  := Alltrim(aArray[nX][2])
		SCO->CO_QUANT  := aArray[nX][5]
		SCO->CO_VALOR  := Iif(ValType(aArray[nX][6])=="N",aArray[nX][6],0)
		SCO->CO_PORCENT:= aArray[nX][7]
		SCO->CO_TIPO   := aArray[nX][9]
		SCO->CO_TPCUSTO:= nQualCusto
		SCO->CO_TPLINHA:= "E"
		SCO->CO_DATA   := Date()
		SCO->CO_DATBASE:= dDataBase
		If lInt .And. Len(aArray[nX]) >= 15 .And. ValType(aArray[nX][15]) == "A"
			SCO->CO_INTPV  := aArray[nX][15][1]
			SCO->CO_INTPUB := aArray[nX][15][2]
		ElseIf lInt
			SCO->CO_INTPV  := "0"
			SCO->CO_INTPUB := "0"
		EndIf
		MsUnLock("SCO")
	Next nX
	//                                              
	//  Grava as condicoes das linhas de totais       
	//                                                
	For nX := 1 To Len(aTotais)
		RecLock("SCO",.T.)
		SCO->CO_FILIAL := xFilial("SCO")
		SCO->CO_CODIGO := cCodPlan
		SCO->CO_REVISAO:= cCodRev
		SCO->CO_NOME   := cArqAnt
		SCO->CO_LINHA  := StrZero(nCel+nX,5)
		SCO->CO_DESC   := PadR(aArray[nCel+nX][3],30)
		SCO->CO_VALOR  :=  Iif(ValType(aArray[nCel+nX,6])=="N",aArray[nCel+nX,6],0)
		SCO->CO_PERCFOR:= aArray[nCel+nX,7]
		SCO->CO_FORMULA:= aTotais[nX]
		SCO->CO_TPCUSTO:= nQualCusto
		SCO->CO_TPLINHA:= "T"
		SCO->CO_DATA   := Date()
		SCO->CO_DATBASE:= dDataBase
		If lInt .And. Len(aArray[nCel+nX]) >= 15 .And. ValType(aArray[nCel+nX][15]) == "A"
			SCO->CO_INTPV  := aArray[nCel+nX][15][1]
			SCO->CO_INTPUB := aArray[nCel+nX][15][2]
		ElseIf lInt
			SCO->CO_INTPV  := "0"
			SCO->CO_INTPUB := "0"
		EndIf
		MsUnLock("SCO")
	Next nX
	//                                              
	//  Grava o restante das formulas na tabela	      
	//                                                
	For nX := 1 To Len(aFormulas)
		RecLock("SCO",.T.)
		SCO->CO_FILIAL  := xFilial("SCO")
		SCO->CO_CODIGO  := cCodPlan
		SCO->CO_REVISAO := cCodRev
		SCO->CO_NOME    := cArqAnt
		SCO->CO_LINHA	:= StrZero(nCel+nQtdTotais+nX,5)
		SCO->CO_DESC	:= PadR(aArray[nMatPrima+nQtdTotais+nX][3],30)
		SCO->CO_VALOR   :=Iif(ValType(aArray[nMatPrima+nQtdTotais+nX,6])=="N",aArray[nMatPrima+nQtdTotais+nX,6],0)
		SCO->CO_PERCFOR := aArray[nMatPrima+nQtdTotais+nX,7]
		SCO->CO_FORMULA	:= PadR(aFormulas[nX,1],100)
		SCO->CO_CELPERC	:= aFormulas[nx,2]
		SCO->CO_TPCUSTO := nQualCusto
		SCO->CO_TPLINHA := "F"
		SCO->CO_DATA    := Date()
		SCO->CO_DATBASE := dDataBase
		If lInt .And. Len(aArray[nMatPrima+nQtdTotais+nX]) >= 15 .And. ValType(aArray[nMatPrima+nQtdTotais+nX][15]) == "A"
			SCO->CO_INTPV  := aArray[nMatPrima+nQtdTotais+nX][15][1]
			SCO->CO_INTPUB := aArray[nMatPrima+nQtdTotais+nX][15][2]
		ElseIf lInt
			SCO->CO_INTPV  := "0"
			SCO->CO_INTPUB := "0"
		EndIf
		MsUnLock("SCO")
	Next nX

	   
	//  MC010ARR - Ponto de Entrada utilizado para passar o aArray com   |
	//|            as informacoes da planilha apos a gravacao.           |
	//|                                                                  |
	//| aArray[nX,01] --> Numero da Linha                                |
	//| aArray[nX,02] --> Nivel                                          |
	//| aArray[nX,03] --> B1_DESC                                        |
	//| aArray[nX,04] --> B1_COD                                         |
	//| aArray[nX,05] --> Quantidade do Item                             |
	//| aArray[nX,06] --> Custo do Item                                  |
	//| aArray[nX,07] --> Participacao (%)                               |
	//| aArray[nX,08] --> Reservado                                      |
	//| aArray[nX,09] --> B1_TIPO                                        |
	//| aArray[nX,10] --> Reservado                                      |
	//| aArray[nX,11] --> G1_TRT                                         |
	//| aArray[nX,12] --> Reservado                                      |
	//| aArray[nX,13] --> G1_FIXVAR                                      |
	     
	If ExistBlock("MC010ARR")
		ExecBlock("MC010ARR",.F.,.F.,{aArray,cArq})
	EndIf

Return(Nil)
*/

/*
   Programa   C010SetVLine Autor    Daniel Leme        Data    03/18/11      
   Desc.       Atribui um valor constante   uma linha da Planilha de         
               Forma  o de Pre os                                            
   Uso         MATC010                                                                                                                             
*/
/*
Function C010SetVLine( nLine, nValue )
	Local nPos := 0

	Static aValues

	If aValues == Nil
		aValues := {}
	EndIf

	If (nPos := aScan( aValues, { |x| x[1] == nLine } ) ) ==  0
		aAdd( aValues, { nLine, nValue } )
	Else
		aValues[nPos][2] := nValue
	EndIf

Return Nil
*/
/*
   Programa   C010ClrVLine Autor    Daniel Leme        Data    03/18/11      
   Desc.       Limpa a area de constantes de linhas da Planilha de           
               Forma  o de Pre os                                            
   Uso         MATC010                                                                                                                                
*/
/*
Function C010ClrVLine()

	aValues := {}

Return Nil
*/

/*
   Programa   C010GetVLine Autor    Daniel Leme        Data    03/18/11      
   Desc.       Retorna um valor atribuido   uma linha da Planilha de         
               Forma  o de Pre os                                            
   Uso         MATC010                                                                                                                                
*/
Static Function C010GetVLine( nLine )
	Local uRet
	Local nPos := 0

	If aValues != Nil
		If (nPos := aScan( aValues, { |x| x[1] == nLine } ) ) !=  0
			uRet := aValues[nPos][2]
		EndIf
	EndIf

Return uRet

/*
   Programa   GetPlanRev  Autor    Daniel Leme         Data    03/18/11      
   Desc.       Busca a  ltima revis o de um dado arquivo.                    
   Uso         MATC010                                                                                                                               
*/
Static Function GetPlanRev(cArqMemo,cCodPlan,cCodRev)
	Local aArea			:= GetArea()
	Local cAliasTRB 	:= ""
	Local cQuery		:= ""

	Default cCodPlan		:= ""
	Default cCodRev		:= ""

	#IFDEF TOP
		cAliasTRB := GetNextAlias()
		cQuery:= "SELECT CO_CODIGO, CO_REVISAO, CO_NOME FROM "+RetSqlName("SCO")+" "+(cAliasTRB)+" "
		cQuery+= " WHERE CO_FILIAL='"+xFilial("SCO")+"'  AND D_E_L_E_T_<>'*'"
		cQuery+= "       AND CO_NOME ='"+cArqMemo+"'"
		cQuery+= "Order By CO_CODIGO Desc, CO_REVISAO Desc "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasTRB),.F.,.T.)
	#ELSE
		cAliasTRB := CriaTrab(,.F.)
		cQuery := '(CO_FILIAL=="' +xFilial("SCO") +'")'
		cQuery += '.And. (CO_NOME == "' + cArqMemo +'")'
		IndRegua("SCO",cAliasTRB,"CO_FILIAL+CO_PRODUTO+CO_NOME",,cQuery,"")
		dbSelectArea(cAliasTRB)
	#ENDIF
	If (cAliasTRB)->(!Eof())
		cCodPlan:= (cAliasTRB)->CO_CODIGO
		cCodRev := (cAliasTRB)->CO_REVISAO
	EndIf
	(cAliasTRB)->(DbCloseArea())

	RestArea( aArea )

Return Nil

