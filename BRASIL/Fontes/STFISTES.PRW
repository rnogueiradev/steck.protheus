#include "Protheus.ch"
#include "RwMake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#DEFINE CR    chr(13)+chr(10)

/*====================================================================================\
|Programa  | STPEDFIS         | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição | STPEDFIS                                                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPEDFIS                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STFISTES()
	*-----------------------------*
	
	
	Private _nOpcao 	:= 3
	//Private _xAlias 	:= GetArea()
	Private aFields 	:= {}
	Private aCols   	:= {}
	Private	aHeader     := {}
	Private aCpoEnch	:= {}
	Private aTam  		:= {}
	Private _cStPed  	:= ' '
	Private h 			:=1
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
	
	
	If __cuserid $ _cCodAut
		AjustaSX1(cPerg)           // Verifica perguntas. Se nao existe INCLUI.
		
		
		If Pergunte(cPerg,.T.)     // Solicita parametros
			
			Processa({|| 	STQUERY()},'Selecionando Registros')
			//	STQUERY()
			Processa({|| 	CompMemory()},'Validando Regras Fiscais')
			
			If len(aVetor) > 0
				MonTaSlec()// monta a tela
			Else
				MsgInfo("Não Existe Dirgências Fiscais !!!!!")
			EndIf
			
			(cAliasLif)->(dbCloseArea())
			
		EndIf
	Else
		msginfo('Usuario sem Acesso')
	EndIf
	//RestArea(_xAlias)
	Msunlockall()
	//	DBCloseAll ( )
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
Static Function STQUERY()
	*-----------------------------*
	Local cQuery     := ''
	
	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	
	cQuery := " SELECT   "
	cQuery += " DISTINCT SC5.C5_NUM   "
	cQuery += " FROM "+RetSqlName('SC5')+" SC5 "
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName('SA1')+" )SA1 "
	cQuery += " ON SA1.A1_COD = SC5.C5_CLIENTE    "
	cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI  "
	cQuery += " AND SA1.D_E_L_E_T_ = ' '     "
	cQuery += " AND SA1.A1_EST BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'"
	cQuery += " AND SA1.A1_GRPTRIB BETWEEN '"+MV_PAR17+"' AND '"+MV_PAR18+"'"
	cQuery += " AND SA1.A1_FILIAL ='"+xFilial("SA1")+"'"
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName('SC6')+" )SC6 "
	cQuery += " ON   SC6.C6_NUM = SC5.C5_NUM   "
	cQuery += " AND  SC6.C6_ITEM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
	cQuery += " AND  SC6.D_E_L_E_T_ = ' '     "
	cQuery += " AND SC6.C6_FILIAL ='"+xFilial("SC6")+"'"
	cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0  "
	cQuery += " AND SC6.C6_TES BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"'"
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName('SB1')+" )SB1 "
	cQuery += " ON SB1.B1_COD = SC6.C6_PRODUTO   "
	cQuery += " AND SB1.D_E_L_E_T_ = ' '     "
	cQuery += " AND SB1.B1_GRUPO BETWEEN '"+MV_PAR15+"' AND '"+MV_PAR16+"'"
	cQuery += " AND SB1.B1_FILIAL ='"+xFilial("SB1")+"'"
	cQuery += " WHERE SC5.D_E_L_E_T_ = ' '
	cQuery += " AND SC5.C5_EMISSAO  BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
	cQuery += " AND SC5.C5_NOTA      NOT LIKE '%XXX%'   "
	cQuery += " AND SC5.C5_CLIENTE   BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
	cQuery += " AND SC5.C5_LOJACLI  BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
	cQuery += " AND SC5.C5_FILIAL ='"+xFilial("SC5")+"'"
	cQuery += " AND SC5.C5_TIPO<>'D'
	//cQuery += " AND SC5.C5_XUNICON <>  ' '
	cQuery += " AND SC5.C5_NUM  BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
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
Static Function CompMemory()
	*-----------------------------*
	Local _ni:= 0
	
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbGoTop())
	ProcRegua(RecCount()) // Numero de registros a processar
	
	While !(cAliasLif)->(Eof())
		
		IncProc()
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
		
		If Len(aCols)>0
			TESSTT(aCols[1,4]) //passo o tipo de operação  aCols[1,4]
		EndIf
		(cAliasLif)->(dbSkip())
	End
	
	If Len(aCols) = 0
		
		MsgInfo("Não Existe Registros !!!!!!!"+CR+CR+"Verifique os Parametros")
	EndIF
	
	
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
Static Function TESSTT(_cOper)
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
				
				If( aCols[i][_nPosClas] <> aCols[i][_nPoWClas] .or. aCols[i][_nPoWCFO] <> aCols[i][_nPosCFO] .or. aCols[i][_nPosTES] <> aCols[i][_nPoWTES]   ) .and.   !Empty(Alltrim(aCols[i][_nPoSTES]))
					
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

Static Function MonTaSlec()
	
	Do While !lSaida
		nOpcao := 0
		
		Define msDialog odlg title "TESTE" From 0,0 To aSize[6]-15,aSize[5]-15  PIXEL OF oMainWnd //from 178,181 to 590,1100 pixel
		
		cLinOk    :="AllwaysTrue()"
		cTudoOk   :="AllwaysTrue()"//'STxGRV()'
		aCpoEnchoice:={'NOUSER','C5_NUM','C5_CLIENTE','C5_LOJACLI','C5_TIPOCLI','C5_ZCONSUM'}
		aAltEnchoice := {}
		
		Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
			bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
		Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0
		
		
		//Cria a listbox
		@ 000,000 listbox oLbx fields header " ", "CLIENTE",'LOJA',"ESTADO", "PEDIDO","PRODUTO","ITEM", "TES ","TES ATUAL", "CFOP ","CFOP ATUAL", "CLASSI", "CLASSI ATUAL","GRP.CLIENTE","GRP.PROD."  size  aSize[3]-05,aSize[4]-29 of oDlg pixel on dbLclick(u_edlista(oLbx:nat))//iif(u_edlista(oLbx:nat),oDlg:End() ,oDlg:End() ))
		
		oLbx:SetArray( aVetor )
		oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
			aVetor[oLbx:nAt,2],;
			aVetor[oLbx:nAt,3],;
			aVetor[oLbx:nAt,4],;
			aVetor[oLbx:nAt,5],;
			aVetor[oLbx:nAt,6],;
			aVetor[oLbx:nAt,7],;
			aVetor[oLbx:nAt,8],;
			aVetor[oLbx:nAt,9],;
			aVetor[oLbx:nAt,10],;
			aVetor[oLbx:nAt,11],;
			aVetor[oLbx:nAt,12],;
			aVetor[oLbx:nAt,13],;
			aVetor[oLbx:nAt,15],;
			aVetor[oLbx:nAt,16];
			}}
		
		@ aSize[4]-28 ,005 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg ;
			ON CLICK(aEval(aVetor,{|x| x[1]:=lChk}),oLbx:Refresh())
		
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||nOpca:=1,lSaida:=.t.,oDlg:End()},{|| nOpca := 0,lSaida:=.t.,oDlg:End()})
		
	End
	If nOpca =1
		STxGRV()
	EndIf
Return()

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
Static Function STxGRV()
	*-----------------------------*
	Local i
	Local _lRet   := .F.
	
	
	If MsgYesNo('Confirma Atualização dos Itens Marcados ?')
		For i:=1 To Len(aVetor)
			If	aVetor	[i,1]
				DbSelectArea("SC6")
				SC6->(DbGoTop())
				SC6->(DbGoTo(aVetor[i,14]))
				If 	SC6->(recno()) = aVetor[i,14]
					SC6->(RecLock("SC6",.F.))
					SC6->C6_TES      := aVetor[i,9]
					SC6->C6_CF       := aVetor[i,11]
					SC6->C6_CLASFIS  := aVetor[i,13]
					SC6->(Msunlock("SC6"))
					SC6->(DbCommit())
				EndIF
			EndIF
		Next i
		MsgInfo('Atualização Realizada Com Sucesso..!!!!!!!!')
	EndIF
	
Return  ()

/*====================================================================================\
|Programa  | EdLista          | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | EdLista                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function EdLista(nPos)
	*-----------------------------*
	
	aVetor[oLbx:nAt,1]	:= !aVetor[oLbx:nAt,1]
	oLbx:Refresh()
	
Return (.t.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³VALIDPERG ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg)
	Local i := 0
	Local j := 0
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	
	cPerg := PADR(cPerg, Len(SX1->X1_GRUPO)," " )
	aRegs:={}
	//------------ Grupo/Ordem/Pergunta/PERGING/PERGESP/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3
	AADD(aRegs,{cPerg,"01","Data de    ?","","","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Data até   ?","","","mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Pedido de  ?","","","mv_ch3","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	AADD(aRegs,{cPerg,"04","Pedido até ?","","","mv_ch4","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	AADD(aRegs,{cPerg,"05","Item de    ?","","","mv_ch5","C",02,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","Item até   ?","","","mv_ch6","C",02,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Cliente de  ?","","","mv_ch7","C",06,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
	AADD(aRegs,{cPerg,"08","Cliente até ?","","","mv_ch8","C",06,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
	AADD(aRegs,{cPerg,"09","Loja de    ?","","","mv_ch9","C",02,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"10","Loja até   ?","","","mv_cha","C",02,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"11","Estado(Cliente) de   ?","","","mv_chb","C",02,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"12","Estado(Cliente) até  ?","","","mv_chc","C",02,0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"13","TES de  ?","","","mv_chd","C",03,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","","SF4"})
	AADD(aRegs,{cPerg,"14","TES até ?","","","mv_che","C",03,0,0,"G","","MV_PAR14","","","","","","","","","","","","","","","","","","","","","","","","","SF4"})
	AADD(aRegs,{cPerg,"15","Grp. Produto de?","","","mv_chf","C",03,0,0,"G","","MV_PAR15","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
	AADD(aRegs,{cPerg,"16","Grp. Produto até?","","","mv_chg","C",03,0,0,"G","","MV_PAR16","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
	AADD(aRegs,{cPerg,"17","Grp. Trib. (Cliente) de?","","","mv_chh","C",03,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"18","Grp. Trib. (Cliente) até?","","","mv_chi","C",03,0,0,"G","","MV_PAR18","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(_sAlias)
Return

//****************************************************************
//****************************************************************
//****************************************************************
//****************************************************************
//****************************************************************
//****************************************************************
