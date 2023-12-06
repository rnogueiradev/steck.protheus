#INCLUDE "RWMAKE.CH"
#INCLUDE "topconn.CH" 
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATMI001  บAutor  ณRicardo Posman      บ Data ณ  27/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera arquivo TXT.                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FATMI010()
                             

PRIVATE cPerg := "FTMI10"

ValidPerg()

If Pergunte(cPerg)
	Processa({|| FATMI1a() },"Aguarde! Selecionando Registros...",,.T.)
EndIf

Return
       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATMI1a   บAutor  ณRicardo Posman      บ Data ณ  27/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FATMI1a()
Local dData := DTOC(dDatabase)
Local variavel := ""  
Local _Tipo1 := ""
Local _Tipo2 := " "
Local nReg := 0
Local Arq  := "SD1"+STRTRAN(TIME(),":","")+DTOS(dDataBase) + ".TXT"
Local Path := "\EXPORTACAO\" + Arq   
//Local Path := "C:\IMPORT\" + Arq
Private nHdl    := fCreate(Path)    


//BUSCA OS DADOS DA NOTA 
// cQuery+= " AND F4_ESTOQUE = 'S'" Retirado em 06/01 a pedido da Simone        

cQuery:= "SELECT  'SD1' "			
cQuery+= ", SB1.B1_COD, SB1.B1_TIPO , SB1.B1_UM, SB1.B1_GRUPO, SB1.B1_DESC, D1_SEQCALC "	
cQuery+= ", D1_COD,D1_DTDIGIT, D1_TES, D1_CF, D1_NUMSEQ, D1_DOC, D1_SERIE, D1_QUANT, D1_UM, D1_LOCAL , D1_FORNECE "		
cQuery+= ", D1_NUMSEQ, D1_VUNIT,D1_TOTAL,D1_PEDIDO, D1_ITEMPC,D1_SERIE "
cQuery+= ", D1_LOJA, D1_TIPO, D1_CUSTO, D1_LOTECTL"
cQuery+= " FROM "+ RetSqlName("SB1") + " SB1"
cQuery+= ", " + RetSqlName("SD1") + " SD1"
cQuery+= ", " + RetSqlName("SF4") + " SF4"
cQuery+= " WHERE"
cQuery+= " SB1.B1_COD = D1_COD"
cQuery+= " AND D1_FILIAL = '" + xFilial("SD1") + "'"
cQuery+= " AND F4_FILIAL = '" + xFilial("SF4") + "'"
cQuery+= " AND SD1.D1_TES = F4_CODIGO"
cQuery+= " AND D1_EMISSAO >= '" + DTOS(mv_par01) + "'"
cQuery+= " AND D1_EMISSAO <= '" + DTOS(mv_par02) + "'"
cQuery+= " AND D1_LOCAL <> '98'"   
IF mv_par03 = 1
cQuery+= " AND D1_EXPORT  = ' ' "   
ENDIF										
cQuery+= " AND SB1.D_E_L_E_T_<>'*'"
cQuery+= " AND SD1.D_E_L_E_T_<>'*'"
cQuery+= " AND SF4.D_E_L_E_T_<>'*'"
cQuery+= " ORDER BY D1_EMISSAO "

MEMOWRITE("kardex.SQL",cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TTB", .T., .F.)
Count To nRecCount


If nRecCount > 0
	
	ProcRegua(nRecCount)
	
	dbSelectArea("TTB")
	dbGoTop()
	
	While !EOF()
		IncProc()

		nReg++
		cPos01	:= TTB->D1_NUMSEQ
		cPos02	:= TTB->D1_COD 
		cPos03	:= TTB->D1_UM
		cPos04	:= TTB->D1_DTDIGIT
		cPos05	:= StrTran(StrTran(Transform(TTB->D1_QUANT,"@E 99999999.99" ),",",".")," ","0")
		cPos06	:= StrTran(StrTran(Transform(TTB->D1_VUNIT,"@E 99999999999.99" ),",",".")," ","0")
		cPos07	:= StrTran(StrTran(Transform(TTB->D1_TOTAL,"@E 99999999999.99" ),",",".")," ","0")
		cPos08	:= TTB->D1_PEDIDO
		cPos09	:= TTB->D1_ITEMPC
		cPos10	:= TTB->D1_FORNECE
		cPos11	:= TTB->D1_LOJA
		cPos12	:= TTB->D1_DOC
		cPos13	:= TTB->D1_TIPO
		cPos14	:= TTB->D1_SERIE
		cPos15	:= TTB->D1_LOTECTL
		cPos16	:= StrTran(StrTran(Transform(TTB->D1_CUSTO,"@E 99999999999.99" ),",",".")," ","0")
		cPos17	:= SM0->M0_CODIGO+SM0->M0_CODFIL
		cPos18	:= TTB->D1_LOCAL
		IF mv_par03 = 1
		cPos19	:= "E"
		ELSE 
		cPos19	:= "R"  
		ENDIF


		cPos01	:= cPos01 + Space(06 - Len(cPos01))
		cPos02	:= cPos02 + Space(15 - Len(cPos02))
		cPos03	:= cPos03 + Space(02 - Len(cPos03))
		cPos04	:= cPos04 + Space(08 - Len(cPos04))
		cPos05	:= cPos05 + Space(11 - Len(cPos05))
		cPos06	:= cPos06 + Space(14 - Len(cPos06))
		cPos07	:= cPos07 + Space(14 - Len(cPos07))
		cPos08	:= cPos08 + Space(06 - Len(cPos08))
		cPos09	:= cPos09 + Space(04 - Len(cPos09))
		cPos10	:= cPos10 + Space(06 - Len(cPos10))
		cPos11	:= cPos11 + Space(02 - Len(cPos11))
		cPos12	:= cPos12 + Space(09 - Len(cPos12))
		cPos13	:= cPos13 + Space(01 - Len(cPos13))
		cPos14	:= cPos14 + Space(03 - Len(cPos14))
		cPos15	:= cPos15 + Space(10 - Len(cPos15))
		cPos16	:= cPos16 + Space(14 - Len(cPos16))
		cPos17	:= cPos17 + Space(04 - Len(cPos17))
		cPos18	:= cPos18 + Space(02 - Len(cPos18))
		cPos19	:= cPos19 + Space(01 - Len(cPos19))

		
		variavel := cPos01 + cPos02 + cPos03 +cPos04 +cPos05 +cPos06 +cPos07 +cPos08 +cPos09 +cPos10
		variavel += cPos11 + cPos12 + cPos13 +cPos14 +cPos15 +cPos16 +cPos17 +cPos18 +cPos19
		variavel += (CHR(13)+CHR(10))
		
		Set Century OFF   
		
		DBSELECTAREA("SD1")
		DBSETORDER(4)
			dbSeek(xFilial("SD1")+TTB->D1_NUMSEQ)
			RecLock("SD1",.f.)
			SD1->D1_EXPORT := "E"
			MsUnlock('SD1')
		
		If fWrite(nHdl,variavel,Len(variavel)) != Len(variavel) //Gravacao do arquivo
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo !!","Atencao!")
				Quit
			Endif
		Endif
		dbSelectArea("TTB")
		dbSkip()
	End
	TTB->(dbCloseArea())
	
	MsgAlert("Arquivo  '" + Path + "'  Gerado com Sucesso! ","Aten็ใo")
	fClose(nHdl)
	U_FATMI1b()	
Else
	TTB->(dbCloseArea())
	MsgAlert("Arquivo nใo foi gerado!","Aten็ใo")
	fClose(nHdl)
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATMI1b   บAutor  ณRicardo Posman      บ Data ณ  27/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FATMI1b()
Local dData := DTOC(dDatabase)
Local variavel := ""
Local nReg := 0
Local Arq  := "SD2" + STRTRAN(TIME(),":","")+DTOS(dDataBase) + ".TXT"
Local Path := "\EXPORTACAO\" + Arq
Private nHdl    := fCreate(Path)

//BUSCA OS DADOS DA NOTA
// cQuery+= " AND F4_ESTOQUE = 'S'"  Retirado em 06/01 a pedido da Simone        


cQuery:= "SELECT  'SD2' "			
cQuery+= ", SB1.B1_COD, SB1.B1_TIPO , SB1.B1_UM, SB1.B1_GRUPO, SB1.B1_DESC "		
cQuery+= ", D2_SEQCALC, D2_COD,D2_EMISSAO, D2_TES, D2_CF, D2_NUMSEQ, D2_DOC, D2_UM, D2_LOCAL, D2_CLIENTE, D2_LOJA, D2_TIPO "	
cQuery+= ", D2_PRCVEN, D2_QUANT, D2_TOTAL, D2_PEDIDO, D2_ITEMPV, D2_SERIE, D2_CUSTO1, D2_LOTECTL "
cQuery+= " FROM "+ RetSqlName("SB1") + " SB1"
cQuery+= ", " + RetSqlName("SD2") + " SD2"
cQuery+= ", " + RetSqlName("SF4") + " SF4"
cQuery+= " WHERE"
cQuery+= " SB1.B1_COD = D2_COD"
cQuery+= " AND D2_FILIAL = '" + xFilial("SD2") + "'"
cQuery+= " AND F4_FILIAL = '" + xFilial("SF4") + "'"
cQuery+= " AND SD2.D2_TES = F4_CODIGO"
cQuery+= " AND D2_TIPO = 'D'" 
cQuery+= " AND D2_TIPO = 'B'"   
cQuery+= " AND D2_EMISSAO >= '" + DTOS(mv_par01) + "'"
cQuery+= " AND D2_EMISSAO <= '" + DTOS(mv_par02) + "'"
cQuery+= " AND D2_LOCAL <> '98'"   
IF mv_par03 = 1
cQuery+= " AND D2_EXPORT  = ' ' "   
ENDIF										
cQuery+= " AND SB1.D_E_L_E_T_<>'*'"
cQuery+= " AND SD2.D_E_L_E_T_<>'*'"
cQuery+= " AND SF4.D_E_L_E_T_<>'*'"
cQuery+= " ORDER BY D2_EMISSAO "

MEMOWRITE("KARDEX2.SQL",cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TTC", .F., .T.)
Count To nRecCount


If nRecCount > 0
	
	ProcRegua(nRecCount)
	
	dbSelectArea("TTC")
	dbGoTop()
	
	While !EOF()
		IncProc()
                    
		nReg++
		cPos01	:= TTC->D2_NUMSEQ
		cPos02	:= TTC->D2_COD 
		cPos03	:= TTC->D2_UM
		cPos04	:= TTC->D2_EMISSAO
		cPos05	:= StrTran(StrTran(Transform(TTC->D2_QUANT, "@E 99999999.99" ),",",".")," ","0")
		cPos06	:= StrTran(StrTran(Transform(TTC->D2_PRCVEN,"@E 99999999999.99" ),",",".")," ","0")
		cPos07	:= StrTran(StrTran(Transform(TTC->D2_TOTAL, "@E 99999999999.99" ),",",".")," ","0")
		cPos08	:= TTC->D2_PEDIDO
		cPos09	:= "00"+TTC->D2_ITEMPV
		cPos10	:= TTC->D2_CLIENTE
		cPos11	:= TTC->D2_LOJA
		cPos12	:= TTC->D2_DOC
		cPos13	:= TTC->D2_TIPO
		cPos14	:= TTC->D2_SERIE
		cPos15	:= TTC->D2_LOTECTL
		cPos16	:= StrTran(StrTran(Transform(TTC->D2_CUSTO1,"@E 99999999999.99" ),",",".")," ","0")
		cPos17	:= SM0->M0_CODIGO+SM0->M0_CODFIL
		cPos18	:= TTC->D2_LOCAL
		IF mv_par03 = 1
		cPos19	:= "E"
		ELSE 
		cPos19	:= "R"  
		ENDIF

		cPos01	:= cPos01 + Space(06 - Len(cPos01))
		cPos02	:= cPos02 + Space(15 - Len(cPos02))
		cPos03	:= cPos03 + Space(02 - Len(cPos03))
		cPos04	:= cPos04 + Space(08 - Len(cPos04))
		cPos05	:= cPos05 + Space(11 - Len(cPos05))
		cPos06	:= cPos06 + Space(14 - Len(cPos06))
		cPos07	:= cPos07 + Space(14 - Len(cPos07))
		cPos08	:= cPos08 + Space(06 - Len(cPos08))
		cPos09	:= cPos09 + Space(04 - Len(cPos09))
		cPos10	:= cPos10 + Space(06 - Len(cPos10))
		cPos11	:= cPos11 + Space(02 - Len(cPos11))
		cPos12	:= cPos12 + Space(09 - Len(cPos12))
		cPos13	:= cPos13 + Space(01 - Len(cPos13))
		cPos14	:= cPos14 + Space(03 - Len(cPos14))
		cPos15	:= cPos15 + Space(10 - Len(cPos15))
		cPos16	:= cPos16 + Space(14 - Len(cPos16))
		cPos17	:= cPos17 + Space(04 - Len(cPos17))
		cPos18	:= cPos18 + Space(02 - Len(cPos18))
		cPos19	:= cPos19 + Space(01 - Len(cPos19))
 
		
		variavel := cPos01 + cPos02 + cPos03 +cPos04 +cPos05 +cPos06 +cPos07 +cPos08 +cPos09 +cPos10
		variavel += cPos11 + cPos12 + cPos13 +cPos14 +cPos15 +cPos16 +cPos17 +cPos18 +cPos19
		variavel += (CHR(13)+CHR(10))
		
		DBSELECTAREA("SD2")
		DBSETORDER(4)
			dbSeek(xFilial("SD2")+TTC->D2_NUMSEQ)
			RecLock("SD2",.f.)
			SD2->D2_EXPORT := "E"
			MsUnlock('SD2')		
		Set Century OFF

		If fWrite(nHdl,variavel,Len(variavel)) != Len(variavel) //Gravacao do arquivo
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo !!","Atencao!")
				Quit
			Endif
		Endif
		dbSelectArea("TTC")
		dbSkip()
	End
	TTC->(dbCloseArea())
	
	MsgAlert("Arquivo  '" + Path + "'  Gerado com Sucesso! ","Aten็ใo")
	fClose(nHdl)
	
Else
	TTC->(dbCloseArea())
	MsgAlert("Arquivo nใo foi gerado!","Aten็ใo")
	fClose(nHdl)
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณMicrosiga           บ Data ณ  27/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria as perguntas no SX1                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function ValidPerg()
Local cKey := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}
/*
PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar     ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02  ,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
*/


PutSx1(cPerg,"01"   ,"Da Emissao?         ",""                    ,""                    ,"mv_ch1","D"   ,08      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par01",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
PutSx1(cPerg,"02"   ,"At้ a Emissao?      ",""                    ,""                    ,"mv_ch2","D"   ,08      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par02",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
PutSx1(cPerg,"03"   ,"Normal ou Reproc?   ",""                    ,""                    ,"mv_ch3","N"   ,01      ,0       ,0      , "C",""    ,""	 ,""         ,""   ,"mv_par03","NORMAL"   ,""      ,""      ,"N"   ,"REPROC",""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")


cKey     := "P."+Alltrim(cPerg)+"01."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Digite a Data de Inicio a Ser considerada.")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P."+Alltrim(cPerg)+"02."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Digite a Data Final a ser considerada..")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)        

cKey     := "P."+Alltrim(cPerg)+"03."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Digite a Data Final a ser considerada..")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
Return
