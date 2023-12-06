#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFLRE04  ºAutor  ³Renato Nogueira     º Data ³  24/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressão de etiquetas linha residencial                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STFLRE04()

	Ajusta()

	If !Pergunte("STFLR04",.T.)
		Return
	EndIf

	If Empty(mv_par01) .Or. Empty(mv_par02) .Or. Empty(mv_par03)
		MsgAlert("Atenção, todos os parâmetros são de preenchimento obrigatório.")
		Return
	Else
		If ApMsgYesNo("Confirma a Impressão de Etiquetas (S/N)?")
			Processa({||STFLR04A(),"Imprimindo ..."})
		Endif
	EndIf

	MsgAlert("Impressão Finalizada")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFLR04A  ºAutor  ³Microsiga           º Data ³  10/19/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função Auxiliar para impressão                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function STFLR04A()

	Local ctamG:= "030,034" 
	Local ctamM:= "022,018"  
	Local ctamP:= "016,014" 
	Local ctamx:= "016,012" 
	Local cPorta:="LPT1"
	Local ccxmet
	Local nLinH	:= 9
	Local nLinV := 0
	Local aEmp			:= BuscaEmp(cEmpAnt)
	Local cM0_CGC		:= aEmp[3]
	Local cImg
	Local _lSeg			:= .F. 

	If SubStr(cM0_CGC,1,8)=="05890658" //SP Sempre Guararema
		cM0_CGC := "05890658000563"
	EndIf

	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek( xFilial("SB1") + mv_par01 )

	If !SB1->(Eof())

		If !CB5SETIMP("000005",IsTelNet())
			MsgAlert("Falha na comunicacao com a impressora.")
			Return(Nil)
		EndIf    

		MSCBINFOETI("Etiqueta 1","MODELO 1")

		If Alltrim(SB1->B1_COD) $ "868010#868011#868020#868021#868030#868031#868040#868080#868081#868082#868083"
			MSCBLOADGRF("868010.GRF")
			cImg	:= "868010" 
		ElseIf Alltrim(SB1->B1_COD) $ "868050"
			MSCBLOADGRF("868050.GRF")
			cImg	:= "868050" 
		ElseIf Alltrim(SB1->B1_COD) $ "868051"
			MSCBLOADGRF("868051.GRF")
			cImg	:= "868051" 
		ElseIf Alltrim(SB1->B1_COD) $ "868070#SO868070"
			MSCBLOADGRF("868070.GRF")
			cImg	:= "868070"
		ElseIf Alltrim(SB1->B1_COD) $ "868071#SO868071"
			MSCBLOADGRF("868071.GRF")
			cImg	:= "868071"  
		ElseIf Alltrim(SB1->B1_COD) $ "868072#SO868072"
			MSCBLOADGRF("868072.GRF")
			cImg	:= "868072"  
		ElseIf Alltrim(SB1->B1_COD) $ "868073#SO868073"
			MSCBLOADGRF("868073.GRF")
			cImg	:= "868073"  
		ElseIf Alltrim(SB1->B1_COD) $ "868074#SO868074"
			MSCBLOADGRF("868074.GRF")
			cImg	:= "868074"  
		ElseIf Alltrim(SB1->B1_COD) $ "868090#SO868090#SO878090"
			MSCBLOADGRF("868090.GRF")
			cImg	:= "868090"  
		ElseIf Alltrim(SB1->B1_COD) $ "868091#SO868091#SO878091"
			MSCBLOADGRF("868091.GRF")
			cImg	:= "868091"  
		ElseIf Alltrim(SB1->B1_COD) $ "868092#SO868092#SO878092"
			MSCBLOADGRF("868092.GRF")
			cImg	:= "868092"  
		ElseIf Alltrim(SB1->B1_COD) $ "868093#868094#868095#SO868095#SO868093#SO868094#SO878093#SO878094#SO878095"
			MSCBLOADGRF("868095.GRF")
			cImg	:= "868095"  
		ElseIf Alltrim(SB1->B1_COD) $ "868096#SO868096#SO878096"
			MSCBLOADGRF("868096.GRF")
			cImg	:= "868096"  
		ElseIf Alltrim(SB1->B1_COD) $ "869596"
			MSCBLOADGRF("869596.GRF")
			cImg	:= "869596" 		
		ElseIf Alltrim(SB1->B1_COD) $ "868097"
			MSCBLOADGRF("868097.GRF")
			cImg	:= "868097" 	
		ElseIf Alltrim(SB1->B1_COD) $ "869010"
			MSCBLOADGRF("869010.GRF")
			cImg	:= "869010"  
		ElseIf Alltrim(SB1->B1_COD) $ "869011"
			MSCBLOADGRF("869011.GRF")
			cImg	:= "869011"  
		ElseIf Alltrim(SB1->B1_COD) $ "869012"
			MSCBLOADGRF("869012.GRF")
			cImg	:= "869012"  
		ElseIf Alltrim(SB1->B1_COD) $ "869013"
			MSCBLOADGRF("869013.GRF")
			cImg	:= "869013"  
		ElseIf Alltrim(SB1->B1_COD) $ "869014"
			MSCBLOADGRF("869014.GRF")
			cImg	:= "869014"  
		ElseIf Alltrim(SB1->B1_COD) $ "869015"
			MSCBLOADGRF("869015.GRF")
			cImg	:= "869015"  
		ElseIf Alltrim(SB1->B1_COD) $ "869016"
			MSCBLOADGRF("869016.GRF")
			cImg	:= "869016"  
		ElseIf Alltrim(SB1->B1_COD) $ "869017"
			MSCBLOADGRF("869017.GRF")
			cImg	:= "869017"  
		ElseIf Alltrim(SB1->B1_COD) $ "869018"
			MSCBLOADGRF("869018.GRF")
			cImg	:= "869018"  
		ElseIf Alltrim(SB1->B1_COD) $ "869019"
			MSCBLOADGRF("869019.GRF")
			cImg	:= "869019"  
		ElseIf Alltrim(SB1->B1_COD) $ "869020"
			MSCBLOADGRF("869020.GRF")
			cImg	:= "869020"  
		ElseIf Alltrim(SB1->B1_COD) $ "869070"
			MSCBLOADGRF("869070.GRF")
			cImg	:= "869070"  
		ElseIf Alltrim(SB1->B1_COD) $ "869072"
			MSCBLOADGRF("869072.GRF")
			cImg	:= "869072"  
		ElseIf Alltrim(SB1->B1_COD) $ "869160#869161"
			MSCBLOADGRF("869161.GRF")
			cImg	:= "869161"  
		ElseIf Alltrim(SB1->B1_COD) $ "869171"
			MSCBLOADGRF("869171.GRF")
			cImg	:= "869171"  
		ElseIf Alltrim(SB1->B1_COD) $ "869110#869111#869120#869121#869130#869131#869140#869180#869181#869182#869183"
			MSCBLOADGRF("869183.GRF")                                                                               
			cImg	:= "869183"  
		ElseIf Alltrim(SB1->B1_COD) $ "869191"
			MSCBLOADGRF("869191.GRF")
			cImg	:= "869191"  
		ElseIf Alltrim(SB1->B1_COD) $ "869192"
			MSCBLOADGRF("869192.GRF")
			cImg	:= "869192"  
		ElseIf Alltrim(SB1->B1_COD) $ "869193#869194#869195"
			MSCBLOADGRF("869195.GRF")
			cImg	:= "869195"  
		ElseIf Alltrim(SB1->B1_COD) $ "869210#869211#869220#869221"
			MSCBLOADGRF("869221.GRF")                              
			cImg	:= "869221"  
		ElseIf Alltrim(SB1->B1_COD) $ "869260#869261"
			MSCBLOADGRF("869260.GRF")                
			cImg	:= "869260"  
		ElseIf Alltrim(SB1->B1_COD) $ "869270"
			MSCBLOADGRF("869270.GRF")
			cImg	:= "869270"  
		ElseIf Alltrim(SB1->B1_COD) $ "869310#869312#869320"
			MSCBLOADGRF("869320.GRF")
			cImg	:= "869320"  
		ElseIf Alltrim(SB1->B1_COD) $ "869316#869317#869326#869327"
			MSCBLOADGRF("869327.GRF")
			cImg	:= "869327"  
		ElseIf Alltrim(SB1->B1_COD) $ "869360#869361"
			MSCBLOADGRF("869361.GRF")
			cImg	:= "869361"  
		ElseIf Alltrim(SB1->B1_COD) $ "869370"
			MSCBLOADGRF("869370.GRF")
			cImg	:= "869370"  
		ElseIf Alltrim(SB1->B1_COD) $ "869393#869394"
			MSCBLOADGRF("869394.GRF")
			cImg	:= "869394"  
		ElseIf Alltrim(SB1->B1_COD) $ "869473"
			MSCBLOADGRF("869473.GRF")
			cImg	:= "869473"  
		ElseIf Alltrim(SB1->B1_COD) $ "869510#869512#869520#869521"
			MSCBLOADGRF("869521.GRF")
			_lSeg	:= .T.
			cImg	:= "869521"  
		ElseIf Alltrim(SB1->B1_COD) $ "869516#869517#869526#869527"
			MSCBLOADGRF("869527.GRF")
			cImg	:= "869527"  
		ElseIf Alltrim(SB1->B1_COD) $ "869570"
			MSCBLOADGRF("869570.GRF")
			cImg	:= "869570"  
		ElseIf Alltrim(SB1->B1_COD) $ "869672"
			MSCBLOADGRF("869672.GRF")
			cImg	:= "869672"
		ElseIf Alltrim(SB1->B1_COD) $ "869772"
			MSCBLOADGRF("869772.GRF")
			cImg	:= "869772"  
		ElseIf Alltrim(SB1->B1_COD) $ "869872"
			MSCBLOADGRF("869872.GRF")
			cImg	:= "869872"  
		ElseIf Alltrim(SB1->B1_COD) $ "869974"
			MSCBLOADGRF("869974.GRF")
			cImg	:= "869974"  
		ElseIf Alltrim(SB1->B1_COD) $ "868060#868060VM#868061#868061VM#SO868061#SO868060#SO868060VM#SO868061VM#SO878060#SO878061"
			MSCBLOADGRF("868061VM.GRF")
			cImg	:= "868061VM"  
		ElseIf Alltrim(SB1->B1_COD) $ "868098#868099"
			MSCBLOADGRF("gar.GRF")
			cImg	:= "gar"  
		ElseIf Alltrim(SB1->B1_COD) $ "868103#SO868103#SO878103"
			MSCBLOADGRF("868103.GRF")
			cImg	:= "868103" 
		ElseIf Alltrim(SB1->B1_COD) $ "SO869198"
			MSCBLOADGRF("SO869198.GRF")
			cImg	:= "SO869198" 
		ElseIf Alltrim(SB1->B1_COD) $ "SO868097#SO878097"
			MSCBLOADGRF("SO868097.GRF")
			cImg	:= "SO868097" 	
		ElseIf Alltrim(SB1->B1_COD) $ "SO868010#SO868020#SO868030#SO868031#SO868040#SO868080#SO868082#SO878010#SO878020#SO878030#SO878031#SO878040#SO878080#SO878082"
			MSCBLOADGRF("SO868010.GRF")
			cImg	:= "SO868010" 
		ElseIf Alltrim(SB1->B1_COD) $ "SO869010#SO879010#SO889010#SO899010"
			MSCBLOADGRF("SO869010.GRF")
			cImg	:= "SO869010" 
		ElseIf Alltrim(SB1->B1_COD) $ "SO869011#SO879011#SO889011#SO899011"
			MSCBLOADGRF("SO869011.GRF")
			cImg	:= "SO869011" 
		ElseIf Alltrim(SB1->B1_COD) $ "SO869012#SO899012#SO889012#SO879012"
			MSCBLOADGRF("SO869012.GRF")
			cImg	:= "SO869012" 
		ElseIf Alltrim(SB1->B1_COD) $ "SO869013#SO879013#SO889013#SO899013"
			MSCBLOADGRF("SO869013.GRF")
			cImg	:= "SO869013" 	
		ElseIf Alltrim(SB1->B1_COD) $ "SO869014#SO879014#SO889014#SO899014"
			MSCBLOADGRF("SO869014.GRF")
			cImg	:= "SO869014" 
		ElseIf Alltrim(SB1->B1_COD) $ "SO869015#SO879015#SO889015#SO899015"
			MSCBLOADGRF("SO869015.GRF")
			cImg	:= "SO869015" 
		ElseIf Alltrim(SB1->B1_COD) $ "SO869016#SO879016#SO889016#SO899016"
			MSCBLOADGRF("SO869016.GRF")
			cImg	:= "SO869016"
		ElseIf Alltrim(SB1->B1_COD) $ "SO869017#SO879017#SO889017#SO899017"
			MSCBLOADGRF("SO869017.GRF")
			cImg	:= "SO869017" 	
		ElseIf Alltrim(SB1->B1_COD) $ "SO869018#SO879018#SO889018#SO899018"
			MSCBLOADGRF("SO869018.GRF")
			cImg	:= "SO869018" 
		ElseIf Alltrim(SB1->B1_COD) $ "SO869019#SO879019#SO889019#SO899019"
			MSCBLOADGRF("SO869019.GRF")
			cImg	:= "SO869019" 
		ElseIf Alltrim(SB1->B1_COD) $ "SO869020#SO879020#SO889020#SO899020"
			MSCBLOADGRF("SO869020.GRF")
			cImg	:= "SO869020" 
		ElseIf Alltrim(SB1->B1_COD) $ "SO869210#SO869220"
			MSCBLOADGRF("SO869210.GRF")
			cImg	:= "SO869210" 		
		ElseIf Alltrim(SB1->B1_COD) $ "SO869110#SO869120#SO869130#SO869180"
			MSCBLOADGRF("SO869110.GRF")
			cImg	:= "SO869110" 	
		ElseIf Alltrim(SB1->B1_COD) $ "SO869160#SO869161"
			MSCBLOADGRF("SO869160.GRF")
			cImg	:= "SO869160" 	
		ElseIf Alltrim(SB1->B1_COD) $ "SO869192"
			MSCBLOADGRF("SO869192.GRF")
			cImg	:= "SO869192" 	
		ElseIf Alltrim(SB1->B1_COD) $ "SO869191"
			MSCBLOADGRF("SO869191.GRF")
			cImg	:= "SO869191" 	
		ElseIf Alltrim(SB1->B1_COD) $ "SO869199"
			MSCBLOADGRF("SO869199.GRF")
			cImg	:= "SO869199" 	
		ElseIf Alltrim(SB1->B1_COD) $ "SO869193#SO869194#SO869195"
			MSCBLOADGRF("SO869193.GRF")
			cImg	:= "SO869193"
		ElseIf Alltrim(SB1->B1_COD) $ "SO869260#SO869261"
			MSCBLOADGRF("SO869260.GRF")
			cImg	:= "SO869260" 	
		ElseIf Alltrim(SB1->B1_COD) $ "SO869310#SO869312#SO869320"
			MSCBLOADGRF("SO869310.GRF")
			cImg	:= "SO869310" 	
		ElseIf Alltrim(SB1->B1_COD) $ "SO869316#SO869317"
			MSCBLOADGRF("SO869316.GRF")
			cImg	:= "SO869316" 	
		ElseIf Alltrim(SB1->B1_COD) $ "SO869360#SO869361"
			MSCBLOADGRF("SO869360.GRF")
			cImg	:= "SO869360" 	
		ElseIf Alltrim(SB1->B1_COD) $ "SO869510"
			MSCBLOADGRF("SO869510.GRF")
			cImg	:= "SO869510" 	
		ElseIf Alltrim(SB1->B1_COD) $ "SO869516"
			MSCBLOADGRF("SO869516.GRF")
			cImg	:= "SO869516" 	
		ElseIf Alltrim(SB1->B1_COD) $ "SO869596"
			MSCBLOADGRF("SO869596.GRF")
			cImg	:= "SO869596" 		
		EndIf

		MSCBloadGrf("steck01.GRF")
		MSCBloadGrf("tuv.GRF")
		MSCBloadGrf("seg.GRF")
		MSCBloadGrf("CRC.GRF")
		MSCBloadGrf("IMC7.GRF")
		MSCBloadGrf("CEN.GRF")
		MSCBloadGrf("BV.GRF")
		MSCBloadGrf("BV2.GRF")

		MSCBBEGIN(mv_par02,1)
		MSCBGrafic(04,08,"steck01",.T.) 
		MSCBSAY(nLinH+10,nLinV+22,"CNPJ " + Transform(cM0_CGC, "@R 99.999.999/9999-99")	,"B","0","021,018",.t.) // 30
		MSCBSAY(025,004,SB1->B1_DESC													,"N","0",ctamG) //coluna,linha
		//MSCBLineV(021,004,130,1.5,"B")
		MSCBSAY(025,014,"REF:"+SB1->B1_COD												,"N","0",ctamG)
		MSCBSAY(025,019,mv_par04														,"N","0",ctamG)
		MSCBSAY(025,024,"Conteudo: "													,"N","0",ctamM)
		MSCBSAY(038,025,mv_par03														,"N","0",ctamG)
		MSCBSAY(027,027,"Peca(s) "														,"N","0",ctamM)
		If !Empty(cImg)
			MSCBGrafic(100,012,cImg,.T.) //coluna, altura, imagem
		EndIf

		If SB1->B1_XGRFBV=="2" .And. SB1->B1_XGRFCEN=="2" .And. SB1->B1_XGRFIMC=="1" .And. SB1->B1_XGRFUC=="2"
			MSCBGrafic(065,015,"IMC7")
		EndIf
		If SB1->B1_XGRFBV=="1" .And. SB1->B1_XGRFCEN=="2" .And. SB1->B1_XGRFIMC=="2" .And. SB1->B1_XGRFUC=="2"
			MSCBGrafic(065,015,"BV2")
		EndIf
		If SB1->B1_XGRFBV=="2" .And. SB1->B1_XGRFCEN=="2" .And. SB1->B1_XGRFIMC=="2" .And. SB1->B1_XGRFUC=="1"
			MSCBGrafic(065,012,"seg",.T.) //coluna, altura, imagem
			MSCBGrafic(065,015,"tuv",.T.) //coluna, altura, imagem
		EndIf

		MSCBSAY(025,032,"FABRICADO NO BRASIL"											,"N","0",ctamP)
		MSCBSAY(025,035,"STECK INDUSTRIA ELETRICA LTDA."								,"N","0",ctamP)
		MSCBSAYBAR(029,040,Alltrim(SB1->B1_CODBAR)										,"N","MB04",14,.F.,.T.,.F.,,,)
		MSCBSAYBAR(018,065,Alltrim(SB1->B1_COD)+"="+Alltrim(mv_par04)+"="+Alltrim(CVALTOCHAR(mv_par03))+"="+Alltrim(cEmpAnt)    ,"N","MB07",14,.T.,.T.,.F.,"B",2,1) 

		MSCBEND()

		MSCBCLOSEPRINTER()

	Else

		MsgAlert("Produto não encontrado!")

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ajusta    ºAutor  ³Microsiga           º Data ³  10/19/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualização do SX1                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Ajusta()

	Local aPergs 	:= {}

	Aadd(aPergs,{"Produto ?                     ","Produto ?                     ","Product ?                     ","mv_ch1","C",15,0,0,"G",""                    ,"mv_par01","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","SB5","S","",""})
	Aadd(aPergs,{"Quantidade de Impressão ?     ","Cantidad de Impresion ?       ","Number of Copys ?             ","mv_ch2","N",3 ,0,0,"G",""                    ,"mv_par02","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Conteúdo ?     ","Conteúdo ?       ","Conteúdo ?          								      ","mv_ch3","C",3 ,0,0,"G",""                    ,"mv_par03","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Lote ?         ","Lote ?     		  ","Lote ?          								      ","mv_ch4","C",11 ,0,0,"G",""                    ,"mv_par04","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})

	//AjustaSx1("STFLR04",aPergs)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BuscaEmp  ºAutor  ³Microsiga           º Data ³  10/19/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ 					                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function BuscaEmp(cEmpresa)

	Local nRecnoSM0 := SM0->(Recno()) 
	Local aEmp	:= {'','',''}

	If SM0->(DbSeek(cEmpresa))
		aEmp := {SM0->M0_NOME,SM0->M0_ENDCOB,SM0->M0_CGC} 
	EndIf  

	SM0->(DbGoto(nRecnoSM0))

Return aClone(aEmp)  
