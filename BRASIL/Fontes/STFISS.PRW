#include "Protheus.ch"
#include "RwMake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#DEFINE CR    chr(13)+chr(10)

User Function STFISS01()
	
	Conout("iniciando STFISS01")
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '05'
	U_xSTFISS()
	Reset Environment
	Conout("Finalizado STFISS01")

Return()

User Function STFISS11()
	
	Conout("iniciando STFISS11")
	PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'
	U_xSTFISS()
	Reset Environment
	Conout("Finalizado STFISS11")

Return()

User Function STFISS03()
	
	Conout("iniciando STFISS03")
	PREPARE ENVIRONMENT EMPRESA '03' FILIAL '01'
	U_xSTFISS()
	Reset Environment
	Conout("Finalizado STFISS03")

Return()

User Function xSTFISS(_nRecPV)
	
	Private _nOpcao 	:= 3
	//Private _xAlias 	:= GetArea()
	Private aFields 	:= {}
	Private aCols   	:= {}
	Private	aHeader     := {}
	Private aCpoEnch	:= {}
	Private aTam  		:= {}
	Private _cStPed  	:= ' '
	Private h 			:= 1
	Private aNoEnch		:= {"C5_NUM","C5_CLIENTE"}
	Private _cCodAut  	:= GetMv("ST_CODFIS",,'000000')
	Private aCpoEnch	:= {}
	Private aPos	  	:= {010,000,115,460}
	Private aButtons 	:= {}
	Private nOpcA		:= 0
	Private oOk	   		:= LoadBitmap( GetResources(), "LBOK" )
	Private oNo	   		:= LoadBitmap( GetResources(), "LBNO" )
	Private oChk
	Private lRetorno    := .F.
	Private lChk	 	:= .F.
	Private aVetor	 	:= {}
	Private oLbx
	Private lInverte 	:= .F.
	Private nContLin 	:= 0
	Private lLote    	:= .F.
	Private oDlg
	Private _cnum    	:= ' '
	//Private cAliasLif   := GetNextAlias()
	Private aSize    	:= MsAdvSize(.F.)
	Private lMark   	:=  .F.
	Private aVetor 		:= {}
	Private lSaida  	:= .F.
	Private cPerg       := 'TELFIS'
	Private cTime       := time()
	Private cHora       := SUBSTR(cTime, 1, 2)
	Private cMinutos    := SUBSTR(cTime, 4, 2)
	Private cSegundos   := SUBSTR(cTime, 7, 2)
	Private cAliasLif   := "TE"+cHora+ cMinutos+cSegundos
	Private oGetDad                                                   //inserido Jefferson dia 181213
	Public n := 1
	Default _nRecPV := 0
	
	
	xSTQUERY(_nRecPV)
	xCompMemory()
	
	//If len(aVetor) > 0
	xSTxGRV()// envia email
	
	//EndIf
	
	(cAliasLif)->(dbCloseArea())
	
	
	
	Msunlockall()
	
	DBCloseArea()
Return ()

/*====================================================================================\
|Programa  | STQUERY          | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |   Executa select mediante os parametros                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STQUERY                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function xSTQUERY(_nRecPV)
	*-----------------------------*
	Local cQuery     := ''
	Default _nRecPV  := 0
	
	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	
	cQuery := " SELECT   " + CRLF
	cQuery += " DISTINCT SC5.C5_NUM   " + CRLF
	cQuery += " FROM "+RetSqlName('SC5')+" SC5 " + CRLF
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName('SA1')+" )SA1 " + CRLF
	cQuery += " ON SA1.A1_COD = SC5.C5_CLIENTE    " + CRLF
	cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI  " + CRLF
	cQuery += " AND SA1.D_E_L_E_T_ = ' '     " + CRLF
	cQuery += " AND SA1.A1_EST BETWEEN ' ' AND 'zzzzzzz'" + CRLF
	cQuery += " AND SA1.A1_GRPTRIB BETWEEN ' ' AND 'zzzzzzz'" + CRLF
	cQuery += " AND SA1.A1_FILIAL ='"+xFilial("SA1")+"'" + CRLF
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName('SC6')+" )SC6 " + CRLF
	cQuery += " ON   SC6.C6_NUM = SC5.C5_NUM   " + CRLF
	cQuery += " AND  SC6.C6_ITEM BETWEEN ' ' AND 'zzzzzzz'" + CRLF
	cQuery += " AND  SC6.D_E_L_E_T_ = ' '     " + CRLF
	cQuery += " AND SC6.C6_FILIAL ='"+xFilial("SC6")+"'" + CRLF
	cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0  " + CRLF
	cQuery += " AND SC6.C6_TES BETWEEN ' ' AND 'zzzzzzz'" + CRLF
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName('SB1')+" )SB1 " + CRLF
	cQuery += " ON SB1.B1_COD = SC6.C6_PRODUTO   " + CRLF
	cQuery += " AND SB1.D_E_L_E_T_ = ' '     " + CRLF
	cQuery += " AND SB1.B1_GRUPO BETWEEN ' ' AND 'zzzzzzz' " + CRLF
	cQuery += " AND SB1.B1_FILIAL ='"+xFilial("SB1")+"' " + CRLF
	cQuery += " WHERE SC5.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND SC5.C5_EMISSAO  BETWEEN ' ' AND 'zzzzzzz'" + CRLF
	cQuery += " AND SC5.C5_NOTA      NOT LIKE '%XXX%'   " + CRLF
	cQuery += " AND SC5.C5_CLIENTE   BETWEEN ' ' AND 'zzzzzzz'" + CRLF
	cQuery += " AND SC5.C5_LOJACLI  BETWEEN ' ' AND 'zzzzzzz'" + CRLF
	cQuery += " AND SC5.C5_FILIAL ='"+xFilial("SC5")+"' " + CRLF
	cQuery += " AND SC5.C5_TIPO<>'D' "  + CRLF
	cQuery += " AND SC5.C5_TIPOCLI<>'X'
	//cQuery += " AND SC5.C5_XUNICON <>  ' '
	cQuery += " AND SC5.C5_NUM  BETWEEN '      ' AND 'ZZZZZZZZZ'" + CRLF
	If _nRecPV <> 0
	   cQuery += " AND SC5.R_E_C_N_O_ = "+cValToChar(_nRecPV)+" " + CRLF
	EndIf
	//cQuery += " AND SC5.C5_NUM IN ('010238')
	//cQuery += " GROUP BY SC5.C5_NUM  "
	cQuery += " ORDER BY SC5.C5_NUM  "
	
	//cQuery := ChangeQuery(cQuery)
	cQuery := ChangeQuery(cQuery)
	
	DbCommitAll()
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif,.T.,.T.)
	
	
Return()


/*====================================================================================\
|Programa  | CompMemory       | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |    crio o aheader, acols, regtomemory                                    |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | CompMemory                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function xCompMemory()
	*-----------------------------*
	Local _ni:= 0
	
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbGoTop())
	//ProcRegua(RecCount()) // Numero de registros a processar
	
	While !(cAliasLif)->(Eof())
		
		//IncProc()
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+(cAliasLif)->C5_NUM))
			RegToMemory('SC5',.F.,.F.)
			_cStPed :=(cAliasLif)->C5_NUM
			
			_cnum  :=_cStPed
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria aHeader e aCols da GetDados                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nUsado:=0
			
			
			//				  1-Campo      , 2-Tipo, 3-Tam	, 4-Dec	, 5-Titulo		            	, 6-Validacao  											, 7-ComboBox
			aTam := TamSX3 ("C6_PRODUTO")
			AAdd( aFields, { 'C6_PRODUTO'  , 'C'	, aTam[1]	, 0		, 'PRODUTO'			   		, " "													, ''				  					} )
			aTam := TamSX3 ('C6_DESCRI')
			AAdd( aFields, { 'C6_DESCRI'   , 'C'	, aTam[1]	, 0		, 'DESCRIÇÃO'		   		, " "													, ''				  					} )
			aTam := TamSX3 ('C6_ITEM')
			AAdd( aFields, { 'C6_ITEM' 	   , 'C'	, aTam[1]	, 0		, 'ITEM	 '  		   		, " "													, ''				  					} )
			aTam := TamSX3 ('C6_OPER')
			AAdd( aFields, { 'TPOPER'	   , 'C'	, aTam[1]   , 0		, 'Tp.Oper.	 ' 				, " "				   									, ''				   					} )
			aTam := TamSX3 ('C6_TES')
			AAdd( aFields, { 'TES_NOVA'	   , 'C'	, aTam[1]   , 0		, 'TES	 ' 			   		, " "				   									, ''				   					} )
			aTam := TamSX3 ("C6_CF")
			AAdd( aFields, { 'CFOP_NOVA'   , 'C'	, aTam[1]   , 0		, 'Cod. Fiscal'		   		, " "	  							   					, ''  									} )
			aTam := TamSX3 ("C6_CLASFIS")
			AAdd( aFields, { 'CLASSI_NOVA' , 'C'	, aTam[1]   , 0		, 'Sit. Trib.'				, " "	  							   					, ''  									} )
			aTam := TamSX3 ('C6_TES')
			AAdd( aFields, { 'TES'	       , 'C'	, aTam[1]   , 0		, 'TES Atualizado' 			, " "				   									, ''				   					} )
			aTam := TamSX3 ("C6_CF")
			AAdd( aFields, { 'CFOP' 	   , 'C'	, aTam[1]   , 0		, 'Cod. Fiscal Atualizado'	, " "	  							   					, ''  									} )
			aTam := TamSX3 ("C6_CLASFIS")
			AAdd( aFields, { 'CLASSI' 	   , 'C'	, aTam[1]   , 0		, 'Sit. Trib. Atualizado'	, " "	  							   					, ''  									} )
			AAdd( aFields, { 'RECNO' 	   , 'N'	, 20   		, 0		, 'RECNO'   				, " "	  							   					, ''  									} )
			aTam := TamSX3 ('C6_QTDVEN')
			AAdd( aFields, { 'C6_QTDVEN'  , 'N'	, aTam[1]	, 2		, 'C6_QTDVEN'			   		, " "													, ''				  					} )
			aTam := TamSX3 ('C6_QTDENT')
			AAdd( aFields, { 'C6_QTDENT'  , 'N'	, aTam[1]	, 2		, 'C6_QTDENT'			   		, " "													, ''				  					} )
			
			
			aHeader := {}	// Monta Cabecalho do aHeader. A ordem dos elementos devem obedecer a sequencia da estrutura dos campos logo acima. aFields[0,6]
			// 	01-Titulo  			        , 02-Campo		, 03-Picture, 04-Tamanho	, 05-Decimal, 06-Valid		, 07-Usado	, 08-Tipo		, 09-F3		, 10-Contexto	, 11-ComboBox	, 12-Relacao	, 13-When		  , 14-Visual	, 15-Valid Usuario
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''   			  , 'V'		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''  			  , 'V'		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, '' 			  , 'V'		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, ''		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , 'V'		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, '@!'		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			h++
			aAdd( aHeader, {	aFields[h,5]+Space(20)	, aFields[h,1]	, ''		, aFields[h,3]	, 0			, aFields[h,6]	, ''		, aFields[h,2]	, ''		, 'R'			, aFields[h,7]	, ''			, ''			  , ''		, ''				} )
			
			
			nUsado:=len(aHeader)
			aCols:={}
			dbSelectArea("SC6")
			dbSetOrder(1)
			dbSeek(xFilial()+_cStPed)
			While !eof().and.C6_NUM==_cStPed
				AADD(aCols,Array(nUsado+1))
				For _ni:=1 to nUsado
					If aHeader[_ni,2] = 'TES'
						aCols[Len(aCols),_ni]:=SC6->C6_TES
					ElseIf aHeader[_ni,2] = 'CFOP'
						aCols[Len(aCols),_ni]:=SC6->C6_CF
					ElseIf aHeader[_ni,2] = 'TPOPER'
						aCols[Len(aCols),_ni]:=SC6->C6_OPER
					ElseIf aHeader[_ni,2] = 'CLASSI'
						aCols[Len(aCols),_ni]:=SC6->C6_CLASFIS
					ElseIf aHeader[_ni,2] = 'CFOP_NOVA'
						aCols[Len(aCols),_ni]:=SC6->C6_CF
					ElseIf aHeader[_ni,2] = 'TPOPER_NOVA'
						aCols[Len(aCols),_ni]:=SC6->C6_OPER
					ElseIf aHeader[_ni,2] = 'CLASSI_NOVA'
						aCols[Len(aCols),_ni]:=SC6->C6_CLASFIS
					ElseIf aHeader[_ni,2] = 'RECNO'
						aCols[Len(aCols),_ni]:=SC6->(RECNO())
					Else
						aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
					EndIf
				Next _ni
				aCols[Len(aCols),nUsado+1]:=.F.
				dbSkip()
			End
		EndIF
		
		If Len(aCols) > 0
			xTESSTT(aCols[1,4]) //passo o tipo de operação  aCols[1,4]
		EndIf
		(cAliasLif)->(dbSkip())
	End
	
	
	
	
Return()
/*====================================================================================\
|Programa  | TESSTT           | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |  Chamo a rotina de tes inteligente para avaliar a tes o cfop e a sit.trib|
|          |  Carrego o array   aVetor                                                |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | TESSTT                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function xTESSTT(_cOper)
	*-----------------------------*
	Local _lRet   		:= .F.
	Local _nOld   		:= n
	Local i   		:= 0
	Local _nPosOper     := aScan(aHeader, { |x| Alltrim(x[2]) == 'TPOPER'        })
	Local _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_PRODUTO'    })
	Local _nPosITEM     := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_ITEM'    })
	Local _nPosTES      := aScan(aHeader, { |x| Alltrim(x[2]) == 'TES'           })
	Local _nPosClas     := aScan(aHeader, { |x| Alltrim(x[2]) == 'CLASSI'        })
	Local _nPosCFO      := aScan(aHeader, { |x| Alltrim(x[2]) == 'CFOP'    		 })
	Local _nPoWTES      := aScan(aHeader, { |x| Alltrim(x[2]) == 'TES_NOVA'      })
	Local _nPoWClas     := aScan(aHeader, { |x| Alltrim(x[2]) == 'CLASSI_NOVA'   })
	Local _nPoWCFO      := aScan(aHeader, { |x| Alltrim(x[2]) == 'CFOP_NOVA'     })
	Local _nPoRECN      := aScan(aHeader, { |x| Alltrim(x[2]) == 'RECNO'         })
	Local _nPosQTD     := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_QTDVEN'    })
	Local _nPosENT     := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_QTDENT'    })
	
	For i:=1 To Len(Acols)
		n:=i
		//	aCols[i,_nPosOper]:= _cOper
		If aCols[i][_nPosQTD] > aCols[i][_nPosENT]
			u_STTESINTELIGENTE()
			
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			If SB1->(DbSeek(xFilial("SB1")+aCols[i][_nPosProd]))
				
				DbSelectArea("SA1")
				SA1->(dbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1")+ SC5->C5_CLIENTE	 + SC5->C5_LOJACLI	 ))
				
				dbSelectArea("SF4")
				SF4->(dbsetOrder(1))
				If	SF4->(DbSeek(xFilial("SF4")+ aCols[i,_nPosTES]))
					aCols[i][_nPosClas]:=SB1->B1_ORIGEM+SF4->F4_SITTRIB
				EndIf
				
				If ((aCols[i][_nPosClas] <> aCols[i][_nPoWClas]) .or. (aCols[i][_nPoWCFO] <> aCols[i][_nPosCFO]) .or. (aCols[i][_nPosTES] <> aCols[i][_nPoWTES]) .and.   !Empty(Alltrim(aCols[i][_nPoSTES])))
					
					aadd(aVetor ,{ lMark ,; //01
					SC5->C5_CLIENTE		 ,;	//02   Cod. Cliente
					SC5->C5_LOJACLI		 ,;	//03   Loja Cliente
					SA1->A1_EST			 ,;	//04   ESTADO
					SC5->C5_NUM			 ,;	//05   Pedido
					aCols[i][_nPosProd]  ,;	//06   PRODUTO
					aCols[i][_nPosITEM]  ,;	//07   ITEM
					aCols[i][_nPoWTES]   ,;	//08   Tes do pedido
					aCols[i][_nPoSTES]   ,;	//09   Tes Atualizada
					aCols[i][_nPoWCFO]   ,;	//10   Cfop Do Pedido
					aCols[i][_nPoSCFO]   ,;	//11   Cfop Atualizada
					aCols[i][_nPoWClas]  ,;	//12   Class. Do Pedido
					aCols[i][_nPoSClas]  ,;	//13   Class. Atualizada
					aCols[i][_nPoRECN]   ,; //14   Recno do Item SC6
					SA1->A1_GRPTRIB  	 ,;	//15   GRUPO CLIENTE
					SB1->B1_GRUPO		  ; //16   GRP PRODUTO
					})
					
					_lRet   := .T.
				EndIf
				
			EndIf
			
		EndIf
	Next i
	
	n:= _nOld
	
	
	
Return  (_lRet)



/*====================================================================================\
|Programa  | STxGRV           | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STxGRV                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function xSTxGRV()
	*-----------------------------*
	Local i
	Local _lRet     := .F.
	Local _aResul   := {}
	Local _aIMPOSTO := {}
	Local nValSTUnt := 0
	aadd(_aResul,{'PEDIDO','ITEM'})
	For i:=1 To Len(aVetor)
		
		DbSelectArea("SC6")
		SC6->(DbGoTop())
		SC6->(DbGoTo(aVetor[i,14]))

		If 	SC6->(recno()) = aVetor[i,14]
		    _aIMPOSTO := gIcmUnt(SC6->C6_VALOR,SC6->C6_PRODUTO,SC6->C6_QTDVEN,aVetor[i,9])   // Valdemir Rabelo 11/03/2022 Chamado: 20220303004953
			if Len(_aIMPOSTO) > 0
			   nValSTUnt := _aIMPOSTO[5]
			endif 
			aadd(_aResul,{SC6->C6_NUM,SC6->C6_ITEM})
			SC6->(RecLock("SC6",.F.))
			SC6->C6_TES      := aVetor[i,9]
			SC6->C6_CF       := aVetor[i,11]
			SC6->C6_CLASFIS  := aVetor[i,13]
			SC6->C6_ZVALIST  := nValSTUnt
			SC6->(Msunlock("SC6"))
			SC6->(DbCommit())
		EndIF
		
		
		
	Next i
	If len (_aResul) > 1
		Maildiv(_aResul)
	EndIF
Return  ()



/*====================================================================================\
|Programa  | MailPrev         | Autor | GIOVANI.ZAGO             | Data | 27/03/2013  |
|=====================================================================================|
|Descrição | MailPrev                                                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MailPrev                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*------------------------------------------------------------------*
Static Function  Maildiv(_aResul)
	*------------------------------------------------------------------*
	
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Divergencia Fiscal em Pedido'
	Local cFuncSent:= "Maildiv"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ' '
	Local cAttach  := ''
	Local _cEmail  :=  ' '
	
	_cEmail  := AllTrim(GetMv("STFISS0101",,"bruna.cordeiro@steck.com.br;vanessa.fantinatti@se.com;vanessa.fantinatti@se.com"))
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		
		_aMsg    := _aResul
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'
		
		
		If !(   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach) )
			MsgInfo("Email não Enviado..!!!!")
		EndIf
	EndIf
	RestArea(aArea)
Return()



/*/{Protheus.doc} gIcmUnt()
Retorno Impostos Conforme Parametros
@type function
@version  12.1.27
@author Valdemir Rabelo
@since 11/03/2022
@param _nValor, variant, Valor Total Item
@param _cProduto, variant, Codigo Produto
@param _nQuant, variant, Quantidade Item
@param _cTesA, variant, TES
@return variant, Array
/*/
Static Function gIcmUnt(_nValor,_cProduto,_nQuant,_cTesA)
	Local nAliqICM   := 0
	Local nValICms   := 0
	Local nAliqIPI   := 0
	Local nValIPI    := 0
	Local nValICMSST := 0
	Local nValPis    := 0
	Local nValCof    := 0
	Local nValCmp    := 0
	Local nValDif    := 0
	Local nValLiq    := 0
	Local aRET       := {}
	Local aAreaT     := GetArea()

	default _cProduto := SuperGetMv("ST_PRDUNIC",,"SUNICOM")
	default _nQuant   := 1

	DbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(dbseek(xfilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	C5_TIPOCLI := SA1->A1_TIPO
	_cTipoCli  := SA1->A1_TIPO
	_cTipoCF   := 'C'
	_nIcms     := SA1->A1_CONTRIB
	_cEst      := SA1->A1_EST

	MaFisSave()
	MaFisEnd()
	MaFisIni(SA1->A1_COD,;	// 1-Codigo Cliente/Fornecedor
	SA1->A1_LOJA ,;			// 2-Loja do Cliente/Fornecedor
	"C",;					// 3-C:Cliente , F:Fornecedor
	"N",;					// 4-Tipo da NF
	SA1->A1_TIPO,;			// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")                                                               // 10-Nome da rotina que esta utilizando a funcao

	MaFisAdd(_cProduto,;                                               // 1-Codigo do Produto ( Obrigatorio )
	_cTesA,;                                                            // 2-Codigo do TES ( Opcional )
	_nQuant,;                                                          // 3-Quantidade ( Obrigatorio )
	_nValor,;                                                         // 4-Preco Unitario ( Obrigatorio )
	0,;                														 // 5-Valor do Desconto ( Opcional )
	,;                                                                       // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                       // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                       // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                      // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                      // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                      // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                      // 12-Valor do Frete Autonomo ( Opcional )
	_nValor,;														 // 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                      // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                      // 15-RecNo do SB1
	0)                                                                       // 16-RecNo do SF4

	nAliqICM 	:= (MaFisRet(1,'IT_ALIQICM',5,2)  )    //Aliquota do ICMS
	nValICms	:= (MaFisRet(1,'IT_VALICM',14,2)  )    //Valor do ICMS

	nAliqIPI 	:= (MaFisRet(1,"IT_ALIQIPI",5,2)  )    //Aliqutota do IPI
	nValIPI 	:= (MaFisRet(1,"IT_VALIPI",14,2)  )    //Valor do IPI

	nValICMSST 	:= (MaFisRet(1,'IT_VALSOL',14,2)  )    //Valor do ICMS-ST

	nValPis		:= (MaFisRet(1,"IT_VALPS2",14,2)  )    //Valor do PIS
	nValCof		:= (MaFisRet(1,"IT_VALCF2",14,2)  )    //Valor do COFINS

	//DIFAL
	nValCmp 	:= noround(MaFisRet(1,"IT_VALCMP",14,2)  )
	nValDif 	:= noround(MaFisRet(1,"IT_DIFAL",14,2)  )

	mafisend()

	nValLiq := round(_nValor-(nValICms  + nValPis + nValCof + nValCmp + nValDif),2)

	aRET := {nAliqICM,nValICms,nAliqIPI,nValIPI,nValICMSST,nValPis,nValCof,nValCmp,nValDif,nValLiq}

	RestArea( aAreaT )

Return(aRET)
