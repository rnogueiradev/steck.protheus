#INCLUDE "PROTHEUS.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    RSTFAT02   º Autor ³ Giovani.Zago       º Data ³  16/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ relatorio de pedido aptos a faturar                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RSTFAT02()

Local cString 			:= "SC5"
Local cDesc1         	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "dos Pedidos Bloqueados Por Valor Minimo"
Local cDesc3         	:= ""
Local cPict         	:= ""
Local titulo       		:= "Pedidos Bloqueados (Vlr. Minimo)"
Local nLin         		:= 70
//                                    1         2         3         4         5         6         7         8         9         0         1         2         3         4         6         7         8         9
//                          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       		:= "Filial  Pedido  Cond.Pagamento        Dt.Emissão  Cli. - Loja  Razão Social                    Total Ped.  Valor       Parcelas  Vlr. Parcelas  Vendedor                  Tipo"
Local Cabec2      		:= "======= ======  ==============        ==========  ===========  ==============================  ==========  ==========  ========  =============  ========================  ======="
Local imprime      		:= .T.
Local aOrd 				:= {} 
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
Private cbtxt     		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "RFAT02"
Private cPerg       	:= "RFAT02"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos


AjustaSX1(cPerg)
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

Local _aResult  :={}
Local _nOrdem  	:= 0
Local cPAR11    := " "
Local cRotina   :=" "
Local cPAR14    :=" "
Local nCont     := 0


StQuery()
SetRegua(FCOUNT())
dbSelectArea(cAliasLif)
(cAliasLif)->(dbgotop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		IncRegua( "Analisando Pedido: "+(cAliasLif)->PEDIDO  )
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		If 	(cAliasLif)->STATUSS = 'BLOQUEADO'
			nLin := nLin + 1
			@nLIN,000 PSAY 	(cAliasLif)->FILIAL  //2
			@nLIN,008 PSAY 	(cAliasLif)->PEDIDO      //6
			@nLIN,016 PSAY 	(cAliasLif)->CONDPAG+' - '+substr(alltrim((cAliasLif)->DESCR),1,15)  //8
			@nLIN,038 PSAY  Stod((cAliasLif)->EMISSAO)     //40
			@nLIN,050 PSAY 	(cAliasLif)->CLIENTE+' - '+(cAliasLif)->LOJA  //3
			@nLIN,063 PSAY 	substr(alltrim((cAliasLif)->NOME),1,30) 	 //6
			@nLIN,095 PSAY 	(cAliasLif)->TOTALPED Picture "@E 999,999.99"	 //40
			@nLIN,107 PSAY 	(cAliasLif)->VALOR	Picture "@E 999,999.99" //2
			@nLIN,119 PSAY 	(cAliasLif)->PARCELA Picture "@E 99"	 //1
			@nLIN,128 PSAY 	(cAliasLif)->VALOR_PARCELA Picture "@E 999,999,999.99"	 //40  
			@nLIN,144 PSAY 	(cAliasLif)->VEND+' - '+substr(ALLTRIM((cAliasLif)->NOMEV),1,15)
		    @nLIN,180 PSAY iif(ALLTRIM((cAliasLif)->TIPO)='1','TOTAL','PARCIAL')
		EndIf
		(cAliasLif)->(dbskip())
		
	End
	
	
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
Aadd(_aRegistros,{cPerg, "03", "Do Pedido :","Do Pedido :","Do Pedido :"   			   			,"mv_ch3","C",6,0,0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","SC5",""})
Aadd(_aRegistros,{cPerg, "04", "Ate o Pedido :","Ate o Pedido :","Ate o Pedido :"	   			,"mv_ch4","C",6,0,0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","","SC5",""})
Aadd(_aRegistros,{cPerg, "05", "Da Cond. Pag. :","Da Cond. Pag. :"   ,"Da Cond. Pag. :" 		,"mv_ch5","C",3,0,0,"G","","mv_par05" ,"","","","","","","","","","","","","","","","","","","","","","","","","SE4_01",""})
Aadd(_aRegistros,{cPerg, "06", "Ate Cond. Pag. :"   ,"Ate Cond. Pag. :"   ,"Ate Cond. Pag. :"   ,"mv_ch6","C",3,0,0,"G","","mv_par06" ,"","","","","","","","","","","","","","","","","","","","","","","","","SE4_01",""})

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


cQuery := "  SELECT               
cQuery += ' SC5.C5_XTIPF "TIPO",
cQuery += ' SA3.A3_NREDUZ "NOMEV",
cQuery += ' SC5.C5_VEND2 "VEND",
cQuery += ' SC5.C5_FILIAL "FILIAL",
cQuery += '  SC5.C5_NUM "PEDIDO",
cQuery += '  SC5.C5_CONDPAG "CONDPAG",
cQuery += ' SE4.E4_DESCRI "DESCR",
cQuery += ' SC5.C5_EMISSAO "EMISSAO",
cQuery += '  SC5.C5_CLIENTE "CLIENTE",
cQuery += '  SC5.C5_LOJACLI "LOJA",
cQuery += ' SA1.A1_NREDUZ "NOME",
cQuery += '  SUM(RED.TOTAP) "TOTALPED",
cQuery += '  SUM(TC6.C6_PRCVEN*TA2.QUANT) "VALOR",
cQuery += '  CASE WHEN SE4.PARCELA = 0 THEN 1 ELSE SE4.PARCELA END "PARCELA",
cQuery += ' ROUND(SUM(TC6.C6_PRCVEN*TA2.QUANT)/ CASE WHEN SE4.PARCELA = 0 THEN 1 ELSE SE4.PARCELA END,2) "VALOR_PARCELA",
cQuery += "  CASE WHEN SUM(TC6.C6_PRCVEN*TA2.QUANT)/ CASE WHEN SE4.PARCELA = 0 THEN 1 ELSE SE4.PARCELA END < "+cvaltochar(_nGetCond)+" THEN 'BLOQUEADO' ELSE 'LIBERADO' END
cQuery += '  "STATUSS"
cQuery += " FROM  SC5010 SC5
cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC6")+" SC6 "
cQuery += " WHERE  SC6.D_E_L_E_T_ = ' '    )TC6
cQuery += "  ON  TC6.C6_FILIAL =  '01'
cQuery += " AND TC6.C6_NUM = SC5.C5_NUM
cQuery += '  INNER JOIN (SElect SUM(PA2_QUANT) "QUANT",PA2_DOC,PA2_FILRES ,PA2_FILIAL
cQuery += "  FROM "+RetSqlName("PA2")+" PA2 "
cQuery += " WHERE   PA2.D_E_L_E_T_ = ' '
cQuery += " AND PA2_FILIAL     = '  '
cQuery += " and PA2_FILRES   = '01'
cQuery += "  group by PA2_DOC,PA2_FILRES ,PA2_FILIAL )TA2
cQuery += " on TA2.PA2_DOC = TC6.C6_NUM||TC6.C6_ITEM
cQuery += " INNER JOIN (SELECT REGEXP_COUNT(E4_COND,',',1,'i')+1
cQuery += '  "PARCELA" ,
cQuery += "  E4_CODIGO, E4_DESCRI,D_E_L_E_T_   FROM "+RetSqlName("SE4")+") SE4 "
cQuery += " ON SE4.E4_CODIGO = SC5.C5_CONDPAG
cQuery += " AND SE4.D_E_L_E_T_ = ' '
cQuery += " INNER JOIN (SELECT * from "+RetSqlName("SA1")+") SA1 "
cQuery += " ON  SA1.D_E_L_E_T_ = ' '
cQuery += " AND  SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE
cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI 
cQuery += " INNER JOIN (SELECT * from "+RetSqlName("SA3")+") SA3 "
cQuery += " ON  SA3.D_E_L_E_T_ = ' '
cQuery += " AND SA3.A3_FILIAL = '"+xFilial("SA3")+"'"
cQuery += " AND SA3.A3_COD = SC5.C5_VEND2
cQuery += ' INNER JOIN (SELECT SUM(C6_VALOR) "TOTAP", C6_NUM,C6_FILIAL,D_E_L_E_T_
cQuery += "  from "+RetSqlName("SC6")
cQuery += " GROUP BY C6_NUM,C6_FILIAL,D_E_L_E_T_) RED
cQuery += "  ON  RED.D_E_L_E_T_ = ' '
cQuery += " AND  RED.C6_FILIAL =  '"+xFilial("SC6")+"'"
cQuery += " AND RED.C6_NUM = SC5.C5_NUM
cQuery += " WHERE SC5.C5_FILIAL =  '"+xFilial("SC5")+"'"  
cQuery += " AND SC5.C5_XBLQFMI = 'S'    
cQuery += " AND SC5.C5_EMISSAO        BETWEEN   '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
cQuery += " AND SC5.C5_NUM            BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
cQuery += " AND SC5.C5_CONDPAG        BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuery += " AND SC5.D_E_L_E_T_ <> '*'
cQuery += " GROUP BY SC5.C5_XTIPF,SA3.A3_NREDUZ,SC5.C5_VEND2,SC5.C5_FILIAL ,
cQuery += "  SC5.C5_NUM ,
cQuery += "  SC5.C5_CONDPAG ,
cQuery += " SE4.E4_DESCRI ,
cQuery += " SC5.C5_EMISSAO ,
cQuery += "  SC5.C5_CLIENTE ,
cQuery += "  SC5.C5_LOJACLI ,
cQuery += " SA1.A1_NREDUZ ,
cQuery += " SE4.PARCELA
cQuery += " ORDER BY SC5.C5_NUM

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
