#INCLUDE "PROTHEUS.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    RSTFAT03   º Autor ³ Giovani.Zago       º Data ³  16/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ relatorio de VALOR LIQUIDO POR GRUPO                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RSTFAT03()

	Local cString 			:= "SC5"
	Local cDesc1         	:= "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         	:= "dos Valores Liquidos Por Grupo"
	Local cDesc3         	:= ""
	Local cPict         	:= ""
	Local titulo       		:= "Valor Liquido"
	Local nLin         		:= 70
	//                                    1         2         3         4         5         6         7         8         9         0         1         2         3         4         6         7         8         9
	//                          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	Local imprime      		:= .T.
	Local aOrd 				:= {}
	Private _cDat     		:= Month2Str( dDataBase  )
	Private _cDat1    		:= Month2Str(MonthSum(dDataBase,1))
	Private _cDat2    		:= Month2Str(MonthSum(dDataBase,2))
	Private _cDat3    		:= Month2Str(MonthSum(dDataBase,3))
	Private _cDat4    := Month2Str(MonthSum(dDataBase,4))
	Private _cDat5    := Month2Str(MonthSum(dDataBase,5))
	Private _cDat6    := Month2Str(MonthSum(dDataBase,6))
	Private _cDat7    := Month2Str(MonthSum(dDataBase,7))
	Private _cDat8    := Month2Str(MonthSum(dDataBase,8))
	//                          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	Private Cabec1       		:= "GRUPO   DESCRIÇÃO                                         DISPONIVEL          REJEITADOS          ANALISE             TOTAL                TOTAL_"+_cDat1+"              TOTAL_"+_cDat2+"              TOTAL_"+_cDat3
	Private Cabec2      		:= "======= ================================================  =================== =================== =================== ==================== ==================== ==================== ===================="
	Private _nGetCond       :=  GetMv("ST_VALMIN",,400)
	Private lEnd         	:= .F.
	Private lAbortPrint  	:= .F.
	Private CbTxt        	:= ""
	Private limite          := 70
	Private tamanho         := "G"
	Private nomeprog        := "COMISS"
	Private nTipo           := 18
	Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cbcont     		:= 00
	Private CONTFL     		:= 01
	Private m_pag      		:= 01
	Private wnrel      		:= "RFAT03"
	Private cPerg       	:= "RFAT03"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos

	cbtxt     		:= Space(10)


	AjustaSX1(cPerg)
	If  msgyesno("Relatorio em Excel ?")

		u_RSTFAT24()
		Return()
	EndIf
	If Pergunte(cPerg,.t.)

		wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

		If nLastKey == 27
			Return
		Endif

		SetDefault(aReturn,cString)

		If nLastKey == 27
			Return
		Endif

		nTipo := If(aReturn[4]==1,15,18)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	Endif
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    RunReport  º Autor ³ Giovani.Zago       º Data ³  16/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ relatorio de pedido aptos a faturar                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local _aResult  :={{0,0,0,0,0,0,0,0}}
	Local _nToVal  := 0
	StQuery()


	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			If nLin > 55
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif

			nLin := nLin + 1

			@nLIN,000 PSAY 	(cAliasLif)->GRUPO //2
			@nLIN,008 PSAY 	(cAliasLif)->DESCRICAO      //6
			_nToVal:=(cAliasLif)->TOTAL-(cAliasLif)->REJEITADOS-(cAliasLif)->ANALISE-(cAliasLif)->TOTAL5-(cAliasLif)->TOTAL1-(cAliasLif)->TOTAL2-(cAliasLif)->TOTAL3-(cAliasLif)->MES

			@nLIN,058 PSAY  _nToVal Picture "@E 99,999,999.99"	 //40
			@nLIN,078 PSAY 	(cAliasLif)->REJEITADOS	Picture "@E 99,999,999.99" //2
			@nLIN,098 PSAY 	(cAliasLif)->ANALISE Picture "@E 99,999,999.99"	 //1
			@nLIN,118 PSAY 	(cAliasLif)->TOTAL Picture "@E 99,999,999.99"	 //40

			@nLIN,138 PSAY 	(cAliasLif)->TOTAL1 Picture "@E 99,999,999.99"
			@nLIN,158 PSAY 	(cAliasLif)->TOTAL2 Picture "@E 99,999,999.99"
			@nLIN,178 PSAY 	(cAliasLif)->TOTAL3 Picture "@E 99,999,999.99"



			_aResult[1,01]+=     _nToVal
			_aResult[1,02]+=	(cAliasLif)->REJEITADOS
			_aResult[1,03]+=	(cAliasLif)->ANALISE
			_aResult[1,04]+=	(cAliasLif)->TOTAL
			_aResult[1,05]+=	(cAliasLif)->TOTAL1
			_aResult[1,06]+=	(cAliasLif)->TOTAL2
			_aResult[1,07]+=	(cAliasLif)->TOTAL3
			_aResult[1,08]+=	(cAliasLif)->TOTAL1+(cAliasLif)->TOTAL2+(cAliasLif)->TOTAL3

			(cAliasLif)->(dbskip())

		End

		nLin := nLin + 1
		@nLIN,001 PSAY 	replicate('_',250)
		nLin := nLin + 2

		@nLIN,058 PSAY 	"DISPONIVEL"
		@nLIN,078 PSAY 	"REJEITADOS"
		@nLIN,098 PSAY 	"ANALISE"
		@nLIN,118 PSAY 	"TOTAL"
		@nLIN,138 PSAY 	"TOTAL_"+_cDat1
		@nLIN,158 PSAY 	"TOTAL_"+_cDat2
		@nLIN,178 PSAY 	"TOTAL_"+_cDat3
		@nLIN,198 PSAY 	"TOTAL_Programado

		nLin := nLin + 1


		nLin := nLin + 2
		@nLIN,008 	PSAY 	"TOTAIS:"
		@nLIN,058 	PSAY 	_aResult[1,01] Picture "@E 99,999,999.99"	 //40
		@nLIN,078 	PSAY 	_aResult[1,02] Picture "@E 99,999,999.99" 	//2
		@nLIN,098 	PSAY 	_aResult[1,03] Picture "@E 99,999,999.99" 	 //1
		@nLIN,118 	PSAY 	_aResult[1,04] Picture "@E 99,999,999.99"	 //40
		@nLIN,138 	PSAY 	_aResult[1,05] Picture "@E 99,999,999.99"
		@nLIN,158 	PSAY 	_aResult[1,06] Picture "@E 99,999,999.99"
		@nLIN,178 	PSAY 	_aResult[1,07] Picture "@E 99,999,999.99"
		@nLIN,198 	PSAY 	_aResult[1,08] Picture "@E 99,999,999.99"
		nLin := nLin + 1
		@nLIN,001 PSAY 	replicate('_',250)





	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SET DEVICE TO SCREEN

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return


Static Function AjustaSX1(cPerg)

	Local _aArea	  := GetArea()
	Local _aRegistros := {}
	Local i			  := 0
	Local j           := 0

	cPerg := PADR(cPerg, Len(SX1->X1_GRUPO)," " )
	Aadd(_aRegistros,{cPerg, "01", "Da Data:" ,"Da Data: ?" ,"Da Data: ?" 				   			,"mv_ch1","D",8,0,0,"G","","mv_par01" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(_aRegistros,{cPerg, "02", "Ate Data:" ,"Ate Data: ?" ,"Ate Data: ?" 			   			,"mv_ch2","D",8,0,0,"G","","mv_par02" ,"","","","","","","","","","","","","","","","","","","","","","","","","",""})

	dbSelectArea("SX1")
	_nCols := FCount()

	For i:=1 to Len(_aRegistros)

		aSize(_aRegistros[i],_nCols)

		If !dbSeek(_aRegistros[i,1]+_aRegistros[i,2])

			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,if(_aRegistros[i,j]=Nil, "",_aRegistros[i,j] ))
			Next j

			MsUnlock()

		EndIf
	Next i

	RestArea(_aArea)

Return(NIL)





Static Function StQuery()

	Local cQuery     := ' '
	cQuery := " SELECT
	cQuery += ' SB1.B1_GRUPO      "GRUPO",
	cQuery += ' SUBSTR(SBM.BM_DESC,1,30)       "DESCRICAO",

	cQuery += "    SUM(round( (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)    ,2)         )
	cQuery += ' "TOTAL",

	cQuery += "    SUM(round(CASE WHEN  (SC5.C5_XATE = '30' AND C5_XMATE = ' ' OR    SC5.C5_XATE = '31' AND C5_XMATE = ' ') OR  (SC5.C5_XATE = '30' AND C5_XMATE = '11' OR    SC5.C5_XATE = '31' AND C5_XMATE = '11')
	cQuery += "  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "MES",

	cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE  <> '"+_cDat+"' And SC5.C5_XMATE  <> ' ' THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL4",

	cQuery += ' NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(TC9.QUANT),2)),0) "REJEITADOS",
	cQuery += ' NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(BC9.QUANT),2)),0) "ANALISE",
	/*
	cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat1+"' THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL1",

	cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat2+"' THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL2",

	cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat3+"' THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL3"

	cQuery += "  ,SUM(round(CASE WHEN  SC5.C5_XMATE||SC5.C5_XAANO in ('"+_cDat4+substr(dtos(date()),1,4)+"','"+_cDat5+substr(dtos(date()),1,4)+"','"+_cDat6+substr(dtos(date()),1,4)+"','"+_cDat7+substr(dtos(date()),1,4)+"' ) THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL5"

	*/

	//cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat1+"' 
	If _cDat = '12'
		cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat1+"'
	Else
		cQuery += "   SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat1+"' 
	EndIf
	cQuery += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL1",

	//cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat2+"' 
	If _cDat = '11'
		cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE))=   '" + substr(dtos(date() +360),1,4)+_cDat2+"'
	ElseIf _cDat = '12'
		cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat2+"'
	Else
		cQuery += "   SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat2+"' 
	EndIf
	cQuery += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL2",

	//cQuery += "  SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat3+"' 
	If _cDat = '10'
		cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat3+"'
	ElseIf _cDat = '11'
		cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat3+"'
	ElseIf _cDat = '12'
		cQuery += "   SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) =   '" + substr(dtos(date() +360),1,4)+_cDat3+"'
	Else
		cQuery += "   SUM(round(CASE WHEN  SC5.C5_XMATE = '"+_cDat3+"' 
	EndIf
	cQuery += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL3",


	If _cDat = '09'
		cQuery += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '"+ substr(dtos(date() +360),1,4)+"01'
	ElseIf _cDat = '10'
		cQuery += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '"+ substr(dtos(date() +360),1,4)+"02'
	ElseIf _cDat = '11'
		cQuery += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '"+ substr(dtos(date() +360),1,4)+"03'
	ElseIf _cDat = '12'
		cQuery += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '"+ substr(dtos(date() +360),1,4)+"04'
	Else
		cQuery += "  SUM(round(CASE WHEN   TRIM(TRIM(SC5.C5_XAANO)||TRIM(SC5.C5_XMATE)) >=   '" + substr(dtos(date()),1,4)+_cDat4+"'
	EndIf
	cQuery += "  	  THEN  (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)  else 0 end ,2)         )
	cQuery += ' "TOTAL5"



	cQuery += " FROM SC5010 SC5
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC6")+" )SC6 "
	cQuery += " ON SC6.D_E_L_E_T_   = ' '
	cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0
	cQuery += " AND SC5.C5_NUM      = SC6.C6_NUM
	cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
	cQuery += " AND SC6.C6_BLQ <> 'R'
	cQuery += ' LEFT JOIN(SELECT SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM, SUM(SC9.C9_QTDLIB) "QUANT",SC9.C9_BLCRED
	cQuery += " FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += " WHERE   SC9.D_E_L_E_T_ = ' '
	cQuery += " GROUP BY SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM,SC9.C9_BLCRED)TC9
	cQuery += " ON  TC9.C9_PEDIDO = SC6.C6_NUM
	cQuery += " AND  TC9.C9_ITEM   = SC6.C6_ITEM
	cQuery += " AND TC9.C9_FILIAL = SC6.C6_FILIAL
	cQuery += " AND TC9.C9_BLCRED = '09'

	cQuery += ' LEFT JOIN(SELECT SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM, SUM(SC9.C9_QTDLIB) "QUANT",SC9.C9_BLCRED
	cQuery += " FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += " WHERE   SC9.D_E_L_E_T_ = ' '
	cQuery += " GROUP BY SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM,SC9.C9_BLCRED)BC9
	cQuery += " ON  BC9.C9_PEDIDO = SC6.C6_NUM
	cQuery += " AND  BC9.C9_ITEM   = SC6.C6_ITEM
	cQuery += " AND BC9.C9_FILIAL = SC6.C6_FILIAL
	cQuery += " AND (BC9.C9_BLCRED = '04' or BC9.C9_BLCRED = '01')
	cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
	cQuery += " ON SB1.D_E_L_E_T_   = ' '
	cQuery += " AND SB1.B1_COD    = SC6.C6_PRODUTO
	cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SBM")+" )SBM "
	cQuery += " ON SBM.D_E_L_E_T_   = ' '
	cQuery += " AND SBM.BM_GRUPO    = SB1.B1_GRUPO
	cQuery += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
	cQuery += " ON SA1.D_E_L_E_T_   = ' '
	cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE
	cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SA3")+" )SA3 "
	cQuery += " ON SA3.D_E_L_E_T_   = ' '
	cQuery += " AND SA3.A3_COD = SC5.C5_VEND2
	cQuery += " AND SA3.A3_FILIAL = '"+xFilial("SA3")+"'"
	cQuery += " LEFT JOIN (SELECT *FROM "+RetSqlName("PC1")+" )PC1 "
	cQuery += " ON C6_NUM = PC1.PC1_PEDREP
	cQuery += " AND PC1.D_E_L_E_T_ = ' '
	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
	cQuery += " ON SC6.C6_TES = SF4.F4_CODIGO
	cQuery += " AND SF4.D_E_L_E_T_ = ' '
	//cQuery += " AND SF4.F4_DUPLIC = 'S'
	//	cQuery += " AND SF4.F4_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND SC6.C6_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')

	cQuery += " WHERE  SC5.D_E_L_E_T_   = ' '
	cQuery += " AND SC5.C5_EMISSAO  BETWEEN   '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
	cQuery += " AND SC5.C5_FILIAL  = '"+xFilial("SC5")+"'"
	cQuery += " AND SC5.C5_NOTA NOT LIKE '%XXX%'
	cQuery += " AND SC5.C5_TIPO = 'N'
	cQuery += " AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " AND SA1.A1_GRPVEN <> 'SC'
	cQuery += " AND SA1.A1_EST    <> 'EX'
	cQuery += " AND SBM.BM_XAGRUP <> ' '
	cQuery += " AND PC1.PC1_PEDREP IS NULL

	cQuery += " GROUP BY SB1.B1_GRUPO ,SBM.BM_DESC

	cQuery += " ORDER  BY SB1.B1_GRUPO


	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
