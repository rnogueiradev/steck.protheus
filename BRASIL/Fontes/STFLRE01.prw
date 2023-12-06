#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFLRE01  บAutor  ณMicrosiga           บ Data ณ  10/19/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressใo de Etiquetas modelo Schneider                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFLRE01()

Ajusta()

If !Pergunte("STFLR01",.T.)
	Return
EndIf

If Empty(mv_par01) .Or. Empty(mv_par02) .Or. Empty(mv_par03)
	MsgAlert("Aten็ใo, todos os parโmetros sใo de preenchimento obrigat๓rio.")
	Return
Else
	If ApMsgYesNo("Confirma a Impressใo de Etiquetas (S/N)?")
		Processa({||STFLR01A(),"Imprimindo ..."})
	Endif
EndIf

MsgAlert("Impressใo Finalizada")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFLR01A  บAutor  ณMicrosiga           บ Data ณ  10/19/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo Auxiliar para impressใo                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STFLR01A()

Local ctamG:= "050,048" 
Local ctamM:= "036,034" 
Local ctamP:= "022,018" 
Local ctamx:= "016,012" 
Local cPorta:="LPT1"
Local ccxmet

DbSelectArea("SB5")
DbSetOrder(1)
If !DbSeek( xFilial("SB5") + mv_par01 )
	MsgAlert("Produto nใo Cadastrado na Tabela de Complementos.")
	Return
EndIf

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek( xFilial("SB1") + mv_par01 )

If !CB5SETIMP("000005",IsTelNet())
	MsgAlert("Falha na comunicacao com a impressora.")
	Return(Nil)
EndIf    

If Alltrim(SB1->B1_COD)$"NSYECC128300/NSYECC325150P/NSYECC33200P/NSYECC43200P/NSYECC44200P/NSYECC53200P/NSYECC54200P/NSYECC55200P/NSYECC55250P/NSYECC64200P/NSYECC65200P/NSYECC65250P/NSYECC66200P/NSYECC66250P"
ccxmet:="cxmet1"
ElseIf Alltrim(SB1->B1_COD)$"NSYECC75250P/NSYECC85250P/NSYECC86200P/NSYECC86250P/NSYECC106250P/NSYECC108250P/NSYECC128250P/NSYECC128300P"
ccxmet:="cxmet2"
Endif 

MSCBINFOETI("Etiqueta 1","MODELO 1")
MSCBLOADGRF("cxmet2.GRF")
MSCBLOADGRF("cxmet1.GRF")
MSCBLOADGRF("rohs.GRF")  
MSCBLOADGRF("ce.GRF")

MSCBBEGIN(mv_par03,1)
MSCBSAY(005,004,SB5->B5_COD														,"N","0",ctamG)
MSCBSAY(115,004,"x1"															,"N","0",ctamG)
MSCBLineH(005,011,130,1.5,"B")
MSCBSAY(015,012,"Caixa Metalica de Sobrepor ECC"								,"N","0",ctamP)
MSCBSAY(082,012,"Made in Brazil"												,"N","0",ctamP)
MSCBGrafic(124,011,"rohs",.T.) //coluna, altura, imagem
MSCBLineH(081,015,130,1.5,"B")
MSCBSAY(015,016,"Armario Metalico Mural ECC"									,"N","0",ctamP)
MSCBSAY(088,016,mv_par04+" "+mv_par02										,"N","0",ctamx)
MSCBLineH(081,019,130,1.5,"B")
MSCBSAY(015,020,"Stell Wall Mounting Enclosure ECC"								,"N","0",ctamP)
MSCBGrafic(122,020,"ce",.T.)
MSCBLineH(081,023,120,1.5,"B")
MSCBSAY(015,024,"Porta Reversivel e Furos de Fixacao"							,"N","0",ctamP)
MSCBSAY(080,024,Subs(SB1->B1_CODBAR,7,6)										,"N","0",ctamP)
MSCBSAY(015,028,"Placa Montagem RAL 2004"										,"N","0",ctamP)
MSCBGrafic(082,028,ccxmet,.T.)
MSCBLineH(015,031,075,1.5,"B")
MSCBSAY(015,032,"Easy CC"														,"N","0",ctamM)
MSCBSAY(015,038,"Caixa RAL 7032"												,"N","0",ctamP)
MSCBSAY(015,042,cValToChar(SB5->B5_COMPR)+"x"+cValToChar(SB5->B5_ESPESS)+"x"+cValToChar(SB5->B5_LARG)+" IP54 IK10"	,"N","0",ctamM)
MSCBLineH(015,048,075,1.5,"B")
MSCBSAYBAR(020,050,Alltrim(SB1->B1_CODBAR)										,"N","MB04",14,.F.,.T.,.F.,,,)
MSCBLineH(005,072,130,1.5,"B")
MSCBSAYBAR(008,094,Alltrim(SB5->B5_COD)+"="+mv_par02+"="+"01"+"="+cEmpAnt,"N","MB07",25,.T.,.T.,.F.,"B",2,1) 
//MSCBSAYBAR(008,094,MSCB128B()+Alltrim(SB5->B5_COD)+"="+mv_par02+"="+"01"+"="+cEmpAnt+MSCB128B(),"N","MB07",25,.T.,.T.,.F.,"B",2,1) 

MSCBEND()

MSCBCLOSEPRINTER()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STRETSEM บAutor  ณMicrosiga           บ Data ณ  10/19/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o Ano e Semana                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบParametrosณ Expd1 - Data a ser convertida                              บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบRetorno   ณ ExpC1 - Ano / Semana - AAAASS                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STRETSEM(dData)

Local cRet
Local dAno
Local nDIA

dAno := CTOD([01/01/]+SUBS(DTOC(dData),7))
nDIA := DOW(dAno)

cRet := Str(INT(((dData-dANO+nDIA-1)/7)+1),2)

cRet := "20"+SUBS(DTOC(dData),7,2)+cRet

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusta    บAutor  ณMicrosiga           บ Data ณ  10/19/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza็ใo do SX1                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Produto ?                     ","Produto ?                     ","Product ?                     ","mv_ch1","C",15,0,0,"G",""                    ,"mv_par01","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","SB5","S","",""})
Aadd(aPergs,{"OS ?                          ","OS ?                          ","SO ?                          ","mv_ch2","C",8 ,0,0,"G",""                    ,"mv_par02","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Quantidade de Impressใo ?     ","Cantidad de Impresion ?       ","Number of Copys ?             ","mv_ch3","N",3 ,0,0,"G",""                    ,"mv_par03","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Ano+M๊s ?                          ","Ano+M๊s ?                          ","Ano+M๊s ?                          ","mv_ch4","C",6 ,0,0,"G",""                    ,"mv_par04","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})

//AjustaSx1("STFLR01",aPergs)

Return