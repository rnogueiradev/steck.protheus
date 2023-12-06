#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |STFLRE06  บAutor  ณJoใo Victor         บ Data ณ  12/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Impressใo de Etiquetas Texto Livre                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFLRE06()

	Private cPerg 		:= "STFLR06"
	Private _cPerg01     := "Texto Linha 1: ?"
	Private _cPerg02     := "Texto Linha 2: ?"
	Private _cPerg03     := "Texto Linha 3: ?"
	Private _cPerg04     := "Impressora: ?"
	Private _cPerg05     := "Quantidade de Impressใo: ?"
	Private _nTam        := 30
	Private _nTam04      := TamSX3("CB5_CODIGO")[1]
	Private _nTam05      := 03
	Private aHelp1       := {}
	Private aHelp2       := {}
	Private aHelp3       := {}
	Aadd(aHelp1, "Informe o Texto a ser impresso          " )
	Aadd(aHelp2, "Informe a Impressora                    " )
	Aadd(aHelp3, "Informe a Quantidade a ser impressa     " )
	//-------cGrupo,cOrdem,cPergunt      ,cPergSpa      ,cPergEng      ,cVar        ,cTipo ,nTamanho ,nDecimal,nPreSel,cGSC,cValid,cF3     ,cGrpSXG,cPyme,cVar01        ,cDef01            ,cDefSpa1,cDefEng1,cCnt01                ,cDef02             ,cDefSpa2	,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04                ,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
	//tSx1(cPerg   ,"01"  ,"Filial ?"    ,"Filial ?"    ,"Filial ?"    ,"mv_ch1"    ,"C"   ,02       ,0       ,0      ,"G" ,""    ,"SM0"   ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,""                    ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,_aHelp  ,_aHelp  ,_aHelp  ,"")
	PutSx1(cPerg   ,"01"  ,_cPerg01      ,_cPerg01      ,_cPerg01      ,"mv_ch1"    ,"C"   ,_nTam    ,0       ,0      ,"G" ,""    ,""      ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,Space(_nTam)          ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp1  ,aHelp1  ,aHelp1)
	PutSx1(cPerg   ,"02"  ,_cPerg02      ,_cPerg02      ,_cPerg02      ,"mv_ch2"    ,"C"   ,_nTam    ,0       ,0      ,"G" ,""    ,""      ,""     ,"S"  ,"mv_par02"    ,""                ,""      ,""      ,Space(_nTam)          ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp1  ,aHelp1  ,aHelp1)
	PutSx1(cPerg   ,"03"  ,_cPerg03      ,_cPerg03      ,_cPerg03      ,"mv_ch3"    ,"C"   ,_nTam    ,0       ,0      ,"G" ,""    ,""      ,""     ,"S"  ,"mv_par03"    ,""                ,""      ,""      ,Space(_nTam)          ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp1  ,aHelp1  ,aHelp1)
	PutSx1(cPerg   ,"04"  ,_cPerg04      ,_cPerg04      ,_cPerg04      ,"mv_ch4"    ,"C"   ,_nTam04  ,0       ,0      ,"G" ,""    ,"CB5"   ,""     ,"S"  ,"mv_par04"    ,""                ,""      ,""      ,Space(_nTam04)        ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp2  ,aHelp2  ,aHelp2)
	PutSx1(cPerg   ,"05"  ,_cPerg05      ,_cPerg05      ,_cPerg05      ,"mv_ch5"    ,"N"   ,_nTam05  ,0       ,0      ,"G" ,""    ,""      ,""     ,"S"  ,"mv_par05"    ,""                ,""      ,""      ,'1'                   ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,aHelp3  ,aHelp3  ,aHelp3)
	
	If !Pergunte("STFLR06",.T.)
		Return
	EndIf

	DbSelectArea("CB5")
	CB5->(DbGoTop())
	CB5->(DbSetOrder(1))
	If !DbSeek( xFilial("CB5") + MV_PAR04)
		MSGALERT("O C๓digo de Impressora informado no Parโmetro '"+_cPerg04+"' ้ invแlido ...!!!"+ Chr(10) + Chr(13) +;
			Chr(10) + Chr(13) +;
			"Favor verificar o parโmetro...!!!"+ Chr(10) + Chr(13)+;
			Chr(10) + Chr(13) +;
			"A Etiqueta nใo serแ impressa...!!!"+ Chr(10) + Chr(13),;
			"Impressora Invแlida")
		Return
	Endif

	If (Empty(MV_PAR04) .Or. Empty(MV_PAR05))
		MSGALERT("Os Parโmetros '"+_cPerg04+"' e '"+_cPerg05+"' sใo de preenchimento obrigat๓rio ...!!!"+ Chr(10) + Chr(13) +;
			Chr(10) + Chr(13) +;
			"Favor verificar os parโmetros...!!!"+ Chr(10) + Chr(13)+;
			Chr(10) + Chr(13) +;
			"A Etiqueta nใo serแ impressa...!!!"+ Chr(10) + Chr(13),;
			"Parโmetros nใo Preenchidos")
		Return
	ElseIf !(MV_PAR05) >= 0
		MSGALERT("O Parโmetro de '"+_cPerg05+"' nใo permite quantidade inferior a Zero (0) ...!!!"+ Chr(10) + Chr(13) +;
			Chr(10) + Chr(13) +;
			"Favor informar uma quantidade superior a Zero (0) ...!!!"+ Chr(10) + Chr(13)+;
			Chr(10) + Chr(13) +;
			"A Etiqueta nใo serแ impressa ...!!!"+ Chr(10) + Chr(13),;
			"Parโmetro Invแlido")
		Return
	Else
		If ApMsgYesNo("Confirma a Impressใo de Etiquetas ?")
			Processa({||STFLR06A(),"Imprimindo ..."})
		Endif
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |STFLR06A  บAutor  ณJoใo Victor         บ Data ณ  12/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Impressใo de Etiquetas Texto Livre                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STFLR06A()

	Local ctamG       := "150,055"

	If !CB5SETIMP(MV_PAR04,IsTelNet())
		MsgAlert("Falha na comunicacao com a impressora.")
		Return(Nil)
	EndIf

	MSCBINFOETI("Etiqueta 1","MODELO 1")

	nLin	:= 5
	nCol	:= 10
		
	MSCBBEGIN(MV_PAR05,1)
	MSCBLineH(010-nCol,008-nLin,130,1.5,"B")
	MSCBSAY(015-nCol,010-nLin,Upper(MV_PAR01)  ,"N","0",ctamG,,,,.T.,.T.)
	MSCBLineH(010-nCol,026-nLin,130,1.5,"B")
	MSCBSAY(015-nCol,030-nLin,Upper(MV_PAR02)  ,"N","0",ctamG)
	MSCBLineH(010-nCol,046-nLin,130,1.5,"B")
	MSCBSAY(015-nCol,050-nLin,Upper(MV_PAR03)  ,"N","0",ctamG)
	MSCBLineH(010-nCol,066-nLin,130,1.5,"B")
		
	MSCBEND()
	MSCBCLOSEPRINTER()
	
	MsgAlert("Impressใo Finalizada")

Return
