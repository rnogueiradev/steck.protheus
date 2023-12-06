#INCLUDE "PROTHEUS.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    RSTFAT07   º Autor ³ Giovani.Zago       º Data ³  20/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Faturamento por Vendedor Interno                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RSTFAT07()

Local cString 			:= "SF2"
Local cDesc1         	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= " Faturamento por Vendedor Interno"
Local cDesc3         	:= ""
Local cPict         	:= ""
Local titulo       		:= "Faturamento por Vendedor Interno"
Local nLin         		:= 70
//                                    1         2         3         4         5         6         7         8         9         0         1         2         3         4         6         7         8         9
//                          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       		:= "Codigo  Nome                                       Valor Atual        Valor Carteira
Local Cabec2      		:= "======= ========================================== ================== ====================="
Local imprime      		:= .T.
Local aOrd 				:= {}
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
Private wnrel      		:= "RFAT07"
Private cPerg       	:= "RFAT07"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos

cbtxt     		:= Space(10)


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
Local _aResult  :={{0,0}}
Local _nXCon    := 0

StQuery()


SetRegua(FCOUNT())

dbSelectArea(cAliasLif)
(cAliasLif)->(dbgotop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		IncRegua( "Analisando Vendedor: "+SUBSTR(ALLTRIM((cAliasLif)->NOME),1,20) )
		
		If nLin > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		nLin := nLin + 1
		@nLIN,000 PSAY 	(cAliasLif)->CODIGO
		@nLIN,008 PSAY 	SUBSTR(ALLTRIM((cAliasLif)->NOME),1,40)
		@nLIN,051 PSAY  (cAliasLif)->ATUAL Picture "@E 99,999,999.99"
		@nLIN,070 PSAY (cAliasLif)->CARTEIRA Picture "@E 99,999,999.99"
	
		
		
		_aResult[1,01]+= (cAliasLif)->ATUAL
		_aResult[1,02]+= (cAliasLif)->CARTEIRA

		
		  _nXCon++
		(cAliasLif)->(dbskip())
		
	End
	
	nLin := nLin + 1
	@nLIN,001 PSAY 	replicate('_',250)
	nLin := nLin + 2
	
	@nLIN,051 PSAY 	"VALOR ATUAL"
	@nLIN,070 PSAY 	"VALOR CARTEIRA"
 //	@nLIN,178 PSAY 	"FALTA"
   //	@nLIN,118 PSAY 	"TOTAL"
	
	nLin := nLin + 1
	
	
	nLin := nLin + 2
	@nLIN,008 PSAY 	"TOTAIS:"
	@nLIN,051 PSAY 	_aResult[1,01] Picture "@E 99,999,999.99"	 //40
	@nLIN,070 PSAY 	_aResult[1,02] Picture "@E 99,999,999.99" //2

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
Aadd(_aRegistros,{cPerg, "03", "Do Vendedor:" ,"Do Vendedor: ?" ,"Do Vendedor: ?" 			   	,"mv_ch3","C",6,0,0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
Aadd(_aRegistros,{cPerg, "04", "Ate Vendedor:" ,"Ate Vendedor: ?" ,"Ate Vendedor: ?" 			,"mv_ch4","C",6,0,0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
Aadd(_aRegistros,{cPerg, "05", "Ordenar Por  :","Ordenar Por  :","Ordenar Por   :"              ,"mv_ch5","C",10,0,3,"C","","mv_par05","Vendedor","Vendedor","Vendedor","","","Valor Atual","Valor Atual","Valor Atual","","","","","","","","",""})

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
Local aAreaSM0   := SM0->(GETAREA())
Local cQuery     := ' '
Local cEmpresas  := ''
SetRegua(4)

	dbSelectArea("SM0")
	SM0->(dbGotop())
	While !SM0->(Eof())
		If Empty(SM0->M0_CGC)
			SM0->(dbSkip())
			Loop
		EndIf
        If len(cEmpresas)>1
			cEmpresas += "','"
		EndIf
		cEmpresas += AllTrim(SM0->M0_CGC)
		SM0->(dbSkip())
	End
	
	RestArea(aAreaSM0)

IncRegua(   )

IncRegua(   )


cQuery := " SELECT 
cQuery += " SA3.A3_COD 
cQuery += ' "CODIGO",
cQuery += " SA3.A3_NOME 
cQuery += ' "NOME",
cQuery += " SUM(CASE WHEN SF2.F2_VEND1 <> SF2.F2_VEND2 THEN SF2.F2_VALBRUT -SF2.F2_VALICM-SF2.F2_VALIMP5-SF2.F2_VALIMP6 ELSE 0 END) 
cQuery += ' "ATUAL",
cQuery += " SUM(CASE WHEN SA3.A3_COD = SF2.F2_VEND1  THEN SF2.F2_VALBRUT -SF2.F2_VALICM-SF2.F2_VALIMP5-SF2.F2_VALIMP6 ELSE 0 END)   "// giovani zago 13/01/2014
cQuery += ' "CARTEIRA"
cQuery += " FROM "+RetSqlName("SF2")+" SF2 "  

cQuery += " INNER JOIN(SELECT * FROM SA1010) SA1
cQuery += " ON SA1.D_E_L_E_T_   = ' '
cQuery += " AND SA1.A1_COD = SF2.F2_CLIENTE
cQuery += " AND SA1.A1_LOJA = SF2.F2_LOJA
cQuery += " AND SA1.A1_FILIAL = ' ' 
cQuery += " AND SA1.A1_CGC NOT IN  ('" + cEmpresas + "')


cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA3")+" )SA3 "
cQuery += " ON SA3.A3_FILIAL = '"+xFilial("SA3")+"'"
cQuery += " AND SA3.D_E_L_E_T_ = ' ' 
cQuery += " AND (SA3.A3_COD = SF2.F2_VEND1
cQuery += " OR   SA3.A3_COD = SF2.F2_VEND2)
cQuery += " AND SA3.A3_TPVEND = 'I'
cQuery += " WHERE F2_EMISSAO BETWEEN '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "
cQuery += " AND SF2.D_E_L_E_T_ = ' ' 
cQuery += " AND (SF2.F2_VEND1 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
cQuery += " OR SF2.F2_VEND2 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' )" 
//cQuery += " AND SF2.F2_FILIAL = '"+xFilial("SF2")+"'"  

cQuery += " AND EXISTS ( SELECT * FROM "+RetSqlName("SD2")+" SD2 "
cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
cQuery += " ON  SD2.D2_TES = SF4.F4_CODIGO 
cQuery += " AND SF4.D_E_L_E_T_ = ' '  
//cQuery += " AND SF4.F4_DUPLIC = 'S'
//cQuery += " AND SF4.F4_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
		
cQuery += " WHERE SD2.D2_DOC = SF2.F2_DOC
cQuery += " AND SD2.D2_SERIE = SF2.F2_SERIE
cQuery += " AND SD2.D_E_L_E_T_ = ' ' 
cQuery += " AND SD2.D2_FILIAL = SF2.F2_FILIAL )


cQuery += " GROUP BY SA3.A3_COD ,
cQuery += " SA3.A3_NOME 

If MV_PAR05 = 1
	cQuery += " Order by SA3.A3_COD "
ElseIf MV_PAR05 = 2
	cQuery += ' ORDER BY "ATUAL"
EndIf

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

IncRegua()

 
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

 

IncRegua()
Return()
