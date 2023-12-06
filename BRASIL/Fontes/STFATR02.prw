#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STFATR02   บ Autor ณ Vitor Merguizo	 บ Data ณ  30/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Capta็ใo Diaria p/ Supervisor                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function STFATR02()

	Local oReport
	Local aArea		:= GetArea()
	Private aSuper 	:= {}

	If !( __cUserId $ Getmv("ST_FATR02",,"000000/000645/000294/"))

		MsgInfo("Usuario sem acesso, solicite libera็ใo a Tereza Mello...!!!")
		Return()

	EndIf

	Ajusta()

	If Pergunte("STFATR02",.T.)

		//Obtem Dados do Supervisor
		DbSelectArea("SA3")
		DbSetOrder(1)
		SA3->(DbGoTop())
		While SA3->(!Eof())
			If Subs(SA3->A3_COD,1,1) = "S" .And. AllTrim(SA3->A3_ZBLOQ)=="2" // .And. SA3->A3_BLQ <> 'S'  //Criar campo para Bloquear Supervisor
				AADD(aSuper,{SA3->A3_COD,SA3->A3_NREDUZ,StCalcMet(SA3->A3_COD)})
			EndIf
			SA3->(dbSkip())
		EndDo

		While Len(aSuper) < 8
			AADD(aSuper,{"","",0})
		EndDo

		oReport 	:= ReportDef()
		oReport		:PrintDialog()
	EndIf

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณMicrosiga           บ Data ณ  03/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Definicao do layout do Relatorio                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef()

	Local oReport
	Local oSection1,oSection2,oSection3

	oReport := TReport():New("STFATR02","Relatorio de Captacao Diaria p/ Supervisor","STFATR02",{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir o Resumo de Captacao Diaria p/ Supervisor conforme parametros.")

	oReport:SetLandscape()
	pergunte("STFATR02",.F.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Variaveis utilizadas para parametros						  ณ
	//ณ mv_par01			// Mes							 		  ณ
	//ณ mv_par02			// Ano									  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	oSection1 := TRSection():New(oReport,"Metas",{"SA3"},)
	TRCell():New(oSection1,"DESC"		,,"                             .",,001,.F.,)
	TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)
	TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)
	TRCell():New(oSection1,"SUP01"		,,IIF(!Empty(aSuper[1][2]),Upper(Alltrim(aSuper[1][2])),"Superv. 1"),"@E 99,999,999",018,.F.,)
	TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)
	TRCell():New(oSection1,"SUP02"		,,IIF(!Empty(aSuper[2][2]),Upper(Alltrim(aSuper[2][2])),"Superv. 2"),"@E 99,999,999",018,.F.,)
	TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)
	TRCell():New(oSection1,"SUP03"		,,IIF(!Empty(aSuper[3][2]),Upper(Alltrim(aSuper[3][2])),"Superv. 3"),"@E 99,999,999",018,.F.,)
	TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)
	TRCell():New(oSection1,"SUP04"		,,IIF(!Empty(aSuper[4][2]),Upper(Alltrim(aSuper[4][2])),"Superv. 4"),"@E 99,999,999",018,.F.,)
	TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)
	TRCell():New(oSection1,"SUP05"		,,IIF(!Empty(aSuper[5][2]),Upper(Alltrim(aSuper[5][2])),"Superv. 5"),"@E 99,999,999",018,.F.,)
	TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)
	TRCell():New(oSection1,"SUP06"		,,IIF(!Empty(aSuper[6][2]),Upper(Alltrim(aSuper[6][2])),"Superv. 6"),"@E 99,999,999",018,.F.,)
	TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)
	TRCell():New(oSection1,"SUP07"		,,IIF(!Empty(aSuper[7][2]),Upper(Alltrim(aSuper[7][2])),"Superv. 7"),"@E 99,999,999",018,.F.,)
	TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)
	TRCell():New(oSection1,"SUP08"		,,IIF(!Empty(aSuper[8][2]),Upper(Alltrim(aSuper[8][2])),"Superv. 8"),"@E 99,999,999",018,.F.,)
	TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)
	TRCell():New(oSection1,"SUP09"		,,IIF(!Empty(aSuper[9][2]),Upper(Alltrim(aSuper[9][2])),"Superv. 9"),"@E 99,999,999",018,.F.,)
	TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)
	TRCell():New(oSection1,"SUP10"		,,IIF(!Empty(aSuper[10][2]),Upper(Alltrim(aSuper[10][2])),"Superv. 10"),"@E 99,999,999",018,.F.,)
	TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)

	TRCell():New(oSection1,"SUP11"		,,IIF(!Empty(aSuper[11][2]),Upper(Alltrim(aSuper[11][2])),"Superv. 11"),"@E 99,999,999",018,.F.,)
	TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)
	TRCell():New(oSection1,"SUP12"		,,IIF(!Empty(aSuper[12][2]),Upper(Alltrim(aSuper[12][2])),"Superv. 12"),"@E 99,999,999",018,.F.,)
	TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)

	TRCell():New(oSection1,"TOTAL"		,,"Total"		,"@E 99,999,999",018,.F.,)
	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("SA3")

	oSection1:Cell("SUP01"):SetHeaderAlign("RIGHT")
	oSection1:Cell("SUP02"):SetHeaderAlign("RIGHT")
	oSection1:Cell("SUP03"):SetHeaderAlign("RIGHT")
	oSection1:Cell("SUP04"):SetHeaderAlign("RIGHT")
	oSection1:Cell("SUP05"):SetHeaderAlign("RIGHT")
	oSection1:Cell("SUP06"):SetHeaderAlign("RIGHT")
	oSection1:Cell("SUP07"):SetHeaderAlign("RIGHT")
	oSection1:Cell("SUP08"):SetHeaderAlign("RIGHT")
	oSection1:Cell("SUP09"):SetHeaderAlign("RIGHT")
	oSection1:Cell("SUP10"):SetHeaderAlign("RIGHT")
	oSection1:Cell("SUP11"):SetHeaderAlign("RIGHT")
	oSection1:Cell("SUP12"):SetHeaderAlign("RIGHT")
	oSection1:Cell("TOTAL"):SetHeaderAlign("RIGHT")

	oSection2 := TRSection():New(oReport,"Captacao",{"SC6"},)
	TRCell():New(oSection2,"DIA"		,,"Dia"			,,006,.F.,)
	TRCell():New(oSection2,"CAPT"		,,"Capt.Dia"	,"@E 999,999,999",012,.F.,)
	TRCell():New(oSection2,"ACUM"		,,"Acumulado"	,"@E 999,999,999",012,.F.,)
	TRCell():New(oSection2,"AC01"		,,"% Ac.1"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"OB01"		,,"% Obj.1"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"AC02"		,,"% Ac.2"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"OB02"		,,"% Obj.2"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"AC03"		,,"% Ac.3"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"OB03"		,,"% Obj.3"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"AC04"		,,"% Ac.4"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"OB04"		,,"% Obj.4"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"AC05"		,,"% Ac.5"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"OB05"		,,"% Obj.5"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"AC06"		,,"% Ac.6"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"OB06"		,,"% Obj.6"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"AC07"		,,"% Ac.7"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"OB07"		,,"% Obj.7"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"AC08"		,,"% Ac.8"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"OB08"		,,"% Obj.8"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"AC09"		,,"% Ac.9"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"OB09"		,,"% Obj.9"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"AC10"		,,"% Ac.10"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"OB10"		,,"% Obj.10"	,"@E 999.99",009,.F.,)

	TRCell():New(oSection2,"AC11"		,,"% Ac.11"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"OB11"		,,"% Obj.11"	,"@E 999.99",009,.F.,)

	TRCell():New(oSection2,"AC12"		,,"% Ac.12"		,"@E 999.99",009,.F.,)
	TRCell():New(oSection2,"OB12"		,,"% Obj.12"	,"@E 999.99",009,.F.,)

	TRCell():New(oSection2,"OBJG"		,,"% Obj.Ger."	,"@E 999.99",009,.F.,)
	oSection2:SetHeaderSection(.T.)
	oSection2:Setnofilter("SC6")

	oSection3 := TRSection():New(oReport,"Programados",{"SC6"},)
	TRCell():New(oSection3,"MES"		,,"Mes/Ano"		,,020,.F.,)
	TRCell():New(oSection3,"ACUM"		,,"Acum. Ind."	,"@E 999,999",024,.F.,)
	oSection3:SetHeaderSection(.T.)
	oSection3:Setnofilter("SC6")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณReportPrintณ Autor ณMicrosiga		          ณ Data ณ12.05.12 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri็ใo ณA funcao estatica ReportDef devera ser criada para todos os  ณฑฑ
ฑฑณ          ณrelatorios que poderao ser agendados pelo usuario.           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpO1: Objeto Report do Relat๓rio                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao efetuada                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                             ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportPrint(oReport)

	Local cTitulo		:= OemToAnsi("Captacao Diaria p/ Supervisor")
	Local cAlias1		:= "QRY1SC6"
	Local cQuery1		:= ""
	Local nRecSM0		:= SM0->(Recno())
	Local _i			:= 0
	Local nCont			:= 0
	Local nPos			:= 0
	Local nValor		:= 0
	Local nMeta			:= aSuper[1][3]+aSuper[2][3]+aSuper[3][3]+aSuper[4][3]+aSuper[5][3]+aSuper[6][3]+aSuper[7][3]+aSuper[8][3]+aSuper[9][3]+aSuper[10][3]+aSuper[11][3]+aSuper[12][3]
	Local aEmpresa		:= {}
	Local aCapt			:= {}
	Local aDados1[99]
	Local aDados2[99]
	Local aDados3[2]
	Local oSection1  := oReport:Section(1)
	Local oSection2  := oReport:Section(2)
	Local oSection3  := oReport:Section(3)
	Local aEmpQry  := {}
	Local _n

	oSection1:Cell("DESC" )		:SetBlock( { || aDados1[1] })
	oSection1:Cell("SUP01")		:SetBlock( { || aDados1[2] })
	oSection1:Cell("SUP02")		:SetBlock( { || aDados1[3] })
	oSection1:Cell("SUP03")		:SetBlock( { || aDados1[4] })
	oSection1:Cell("SUP04")		:SetBlock( { || aDados1[5] })
	oSection1:Cell("SUP05")		:SetBlock( { || aDados1[6] })
	oSection1:Cell("SUP06")		:SetBlock( { || aDados1[7] })
	oSection1:Cell("SUP07")		:SetBlock( { || aDados1[8] })
	oSection1:Cell("SUP08")		:SetBlock( { || aDados1[9] })
	oSection1:Cell("SUP09")		:SetBlock( { || aDados1[10] })
	oSection1:Cell("SUP10")		:SetBlock( { || aDados1[12] })

	oSection1:Cell("SUP11")		:SetBlock( { || aDados1[13] })
	oSection1:Cell("SUP12")		:SetBlock( { || aDados1[14] })

	oSection1:Cell("TOTAL")		:SetBlock( { || aDados1[11] })

	oSection2:Cell("DIA"  )		:SetBlock( { || aDados2[1] })
	oSection2:Cell("CAPT" )		:SetBlock( { || aDados2[2] })
	oSection2:Cell("ACUM" )		:SetBlock( { || aDados2[3] })
	oSection2:Cell("AC01" )		:SetBlock( { || aDados2[4] })
	oSection2:Cell("OB01" )		:SetBlock( { || aDados2[5] })
	oSection2:Cell("AC02" )		:SetBlock( { || aDados2[6] })
	oSection2:Cell("OB02" )		:SetBlock( { || aDados2[7] })
	oSection2:Cell("AC03" )		:SetBlock( { || aDados2[8] })
	oSection2:Cell("OB03" )		:SetBlock( { || aDados2[9] })
	oSection2:Cell("AC04" )		:SetBlock( { || aDados2[10] })
	oSection2:Cell("OB04" )		:SetBlock( { || aDados2[11] })
	oSection2:Cell("AC05" )		:SetBlock( { || aDados2[12] })
	oSection2:Cell("OB05" )		:SetBlock( { || aDados2[13] })
	oSection2:Cell("AC06" )		:SetBlock( { || aDados2[14] })
	oSection2:Cell("OB06" )		:SetBlock( { || aDados2[15] })
	oSection2:Cell("AC07" )		:SetBlock( { || aDados2[16] })
	oSection2:Cell("OB07" )		:SetBlock( { || aDados2[17] })
	oSection2:Cell("AC08" )		:SetBlock( { || aDados2[18] })
	oSection2:Cell("OB08" )		:SetBlock( { || aDados2[19] })
	oSection2:Cell("AC09" )		:SetBlock( { || aDados2[20] })
	oSection2:Cell("OB09" )		:SetBlock( { || aDados2[21] })
	oSection2:Cell("AC10" )		:SetBlock( { || aDados2[23] })
	oSection2:Cell("OB10" )		:SetBlock( { || aDados2[24] })

	oSection2:Cell("AC11" )		:SetBlock( { || aDados2[25] })
	oSection2:Cell("OB11" )		:SetBlock( { || aDados2[26] })
	oSection2:Cell("AC12" )		:SetBlock( { || aDados2[27] })
	oSection2:Cell("OB12" )		:SetBlock( { || aDados2[28] })

	oSection2:Cell("OBJG" )		:SetBlock( { || aDados2[22] })

	oSection3:Cell("MES"  )		:SetBlock( { || aDados3[1] })
	oSection3:Cell("ACUM" )		:SetBlock( { || aDados3[2] })
	/*
	//Obtem Empresas
	DbSelectArea("SM0")
	DbSetOrder(1)
	SM0->(DbGoTop())
	While SM0->(!Eof())
	nPos := aScan(aEmpresa,{ |x| x = SM0->M0_CODIGO } )
	If nPos = 0 .And. SM0->M0_CODIGO $ ('01/02/03/04')
	AADD(aEmpresa,SM0->M0_CODIGO)
	EndIf
	nPos := 0
	SM0->(dbSkip())
	EndDo
	SM0->(Dbgoto(nRecSM0))
	*/

	aEmpQry := MarkFile()

	For _n := 1 to Len(aEmpQry)
		If aEmpQry[_n][1]
			AADD(aEmpresa,aEmpQry[_n][2])
		EndIf
	Next _n

	If Len(aEmpresa)==0
		MsgAlert("Aten็ใo, nenhuma empresa foi selecionada!")
		Return
	EndIf

	//Monta Query para Extrair dados de Capta็ใo
	cQuery1 := " SELECT C5_DIA,A3_SUPER,SUM(C6_VALOR) C6_VALOR FROM ("
	For _i := 1 to Len(aEmpresa)
		If _i > 1
			cQuery1 += " UNION ALL"
		EndIf
		cQuery1 += " SELECT SUBSTR(C5_EMISSAO,7,2) C5_DIA,A3_SUPER,"
		If aEmpresa[_i]="01"
			cQuery1 += " SUM(CASE WHEN C6_BLQ = 'R' AND C6_ZVALLIQ > 0 THEN C6_ZVALLIQ/C6_QTDVEN*C6_QTDENT WHEN C6_ZVALLIQ > 0 THEN C6_ZVALLIQ WHEN C6_BLQ = 'R' THEN C6_VALOR/C6_QTDVEN*C6_QTDENT ELSE C6_VALOR END) C6_VALOR " // Alterar apos criacao do campo em outras empresas
		Else
			cQuery1 += " SUM(CASE WHEN C6_BLQ = 'R' THEN C6_VALOR/C6_QTDVEN*C6_QTDENT ELSE C6_VALOR END) C6_VALOR "
		EndIf
		cQuery1 += " FROM SC5"+aEmpresa[_i]+"0 SC5 "
		cQuery1 += " INNER JOIN SC6"+aEmpresa[_i]+"0 SC6 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA AND SC6.D_E_L_E_T_ = ' '
		cQuery1 += " LEFT JOIN SA3"+aEmpresa[_i]+"0 SA3 ON A3_FILIAL = '"+xFilial("SA3")+"' AND C5_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = '' "
		cQuery1 += " LEFT JOIN SA1"+aEmpresa[_i]+"0 SA1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
		cQuery1 += " LEFT JOIN SF4"+aEmpresa[_i]+"0 SF4 ON F4_FILIAL = '"+xFilial("SF4")+"' AND C6_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "
		cQuery1 += " LEFT JOIN SB1"+aEmpresa[_i]+"0 SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
		cQuery1 += " LEFT JOIN SBM010 SBM ON BM_FILIAL = '"+xFilial("SBM")+"' AND B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ' ' "

		If aEmpresa[_i]="01"
			cQuery1 += " LEFT JOIN PC1"+aEmpresa[_i]+"0 PC1 ON C6_NUM=PC1_PEDREP AND PC1.D_E_L_E_T_ = ' ' "
		EndIf

		cQuery1 += " WHERE "
		cQuery1 += " SUBSTR(C5_EMISSAO,1,6) = '"+StrZero(mv_par02,4,0)+StrZero(mv_par01,2,0)+"' AND "
		cQuery1 += " C5_TIPO = 'N' AND "
		cQuery1 += " A1_GRPVEN NOT IN ('ST','SC') AND "
		cQuery1 += " A1_EST <> 'EX' AND "
		cQuery1 += " F4_DUPLIC = 'S' AND "
		cQuery1 += " A1_COD NOT IN ('033467','019886','012047','033833' ) AND
		cQuery1 += " C6_CF IN ('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') AND
		cQuery1 += " C5_ZOPERAD<>' ' AND

		If aEmpresa[_i]="01"
			cQuery1 += " PC1_PEDREP IS NULL AND
		EndIf

		cQuery1 += " SC5.D_E_L_E_T_ = ' ' "
		//Giovani Zago 10/10/2013 projeto ibl separa por filial
		//cQuery1 += " AND SC5.C5_FILIAL = '"+xFilial("SC5")+"'"
		//******************************************************
		cQuery1 += " GROUP BY SUBSTR(C5_EMISSAO,7,2),A3_SUPER "
	Next _i
	cQuery1 += " )SC GROUP BY C5_DIA,A3_SUPER "
	cQuery1 += " ORDER BY 1,2 "

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fecha Alias se estiver em Uso ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta Area de Trabalho executando a Query ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery1),cAlias1,.T.,.T.)

	TCSetField(cAlias1,"C6_VALOR","N",TamSx3("C6_VALOR")[1],TamSx3("C6_VALOR")[2])

	oReport:SetTitle(cTitulo)

	dbeval({||nCont++})

	oReport:SetMeter(nCont)

	aFill(aDados1,nil)
	oSection1:Init()

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	//Atualiza Array com dados de Capta็ใo
	While (cAlias1)->(!Eof())
		oReport:IncMeter()

		nValor	:= (cAlias1)->C6_VALOR
		nPos	:= aScan(aCapt,{ |x| x[1] = (cAlias1)->C5_DIA } )

		If nPos > 0
			aCapt[nPos][02] += nValor
			If (cAlias1)->A3_SUPER = aSuper[1][1]
				aCapt[nPos][04] += nValor
			ElseIf (cAlias1)->A3_SUPER = aSuper[2][1]
				aCapt[nPos][08] += nValor
			ElseIf (cAlias1)->A3_SUPER = aSuper[3][1]
				aCapt[nPos][12] += nValor
			ElseIf (cAlias1)->A3_SUPER = aSuper[4][1]
				aCapt[nPos][16] += nValor
			ElseIf (cAlias1)->A3_SUPER = aSuper[5][1]
				aCapt[nPos][20] += nValor
			ElseIf (cAlias1)->A3_SUPER = aSuper[6][1]
				aCapt[nPos][24] += nValor
			ElseIf (cAlias1)->A3_SUPER = aSuper[7][1]
				aCapt[nPos][28] += nValor
			ElseIf (cAlias1)->A3_SUPER = aSuper[8][1]
				aCapt[nPos][32] += nValor
			ElseIf (cAlias1)->A3_SUPER = aSuper[9][1]
				aCapt[nPos][36] += nValor
			ElseIf (cAlias1)->A3_SUPER = aSuper[10][1]
				aCapt[nPos][40] += nValor
			ElseIf (cAlias1)->A3_SUPER = aSuper[11][1]
				aCapt[nPos][44] += nValor
			ElseIf (cAlias1)->A3_SUPER = aSuper[12][1]
				aCapt[nPos][48] += nValor
			EndIf
		Else
			AADD(aCapt,{;
			(cAlias1)->C5_DIA,nValor,0,;//3
			IIf((cAlias1)->A3_SUPER=aSuper[1][1],nValor,0),0,0,0,;//7
			IIf((cAlias1)->A3_SUPER=aSuper[2][1],nValor,0),0,0,0,;//11
			IIf((cAlias1)->A3_SUPER=aSuper[3][1],nValor,0),0,0,0,;//15
			IIf((cAlias1)->A3_SUPER=aSuper[4][1],nValor,0),0,0,0,;//19
			IIf((cAlias1)->A3_SUPER=aSuper[5][1],nValor,0),0,0,0,;//23
			IIf((cAlias1)->A3_SUPER=aSuper[6][1],nValor,0),0,0,0,;//27
			IIf((cAlias1)->A3_SUPER=aSuper[7][1],nValor,0),0,0,0,;//31
			IIf((cAlias1)->A3_SUPER=aSuper[8][1],nValor,0),0,0,0,;//35
			IIf((cAlias1)->A3_SUPER=aSuper[9][1],nValor,0),0,0,0,;//39
			IIf((cAlias1)->A3_SUPER=aSuper[10][1],nValor,0),0,0,0,;//43
			IIf((cAlias1)->A3_SUPER=aSuper[11][1],nValor,0),0,0,0,;//47
			IIf((cAlias1)->A3_SUPER=aSuper[12][1],nValor,0),0,0,0,;//51
			0})//52
		EndIf
		(cAlias1)->(dbSkip())
	EndDo

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fecha Alias se estiver em Uso ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	//Atualiza Array com Totalizadores
	For _i := 1 To Len(aCapt)
		If _i = 1
			aCapt[_i][03] := aCapt[_i][02]
			aCapt[_i][05] := aCapt[_i][04]
			aCapt[_i][09] := aCapt[_i][08]
			aCapt[_i][13] := aCapt[_i][12]
			aCapt[_i][17] := aCapt[_i][16]
			aCapt[_i][21] := aCapt[_i][20]
			aCapt[_i][25] := aCapt[_i][24]
			aCapt[_i][29] := aCapt[_i][28]
			aCapt[_i][33] := aCapt[_i][32]
			aCapt[_i][37] := aCapt[_i][36]
			aCapt[_i][38] := aCapt[_i][40]
			aCapt[_i][42] := aCapt[_i][44]
			aCapt[_i][43] := aCapt[_i][48]
		Else
			aCapt[_i][03] := aCapt[_i][02]+aCapt[(_i-1)][03]
			aCapt[_i][05] := aCapt[_i][04]+aCapt[(_i-1)][05]
			aCapt[_i][09] := aCapt[_i][08]+aCapt[(_i-1)][09]
			aCapt[_i][13] := aCapt[_i][12]+aCapt[(_i-1)][13]
			aCapt[_i][17] := aCapt[_i][16]+aCapt[(_i-1)][17]
			aCapt[_i][21] := aCapt[_i][20]+aCapt[(_i-1)][21]
			aCapt[_i][25] := aCapt[_i][24]+aCapt[(_i-1)][25]
			aCapt[_i][29] := aCapt[_i][28]+aCapt[(_i-1)][29]
			aCapt[_i][33] := aCapt[_i][32]+aCapt[(_i-1)][33]
			aCapt[_i][37] := aCapt[_i][36]+aCapt[(_i-1)][37]
			aCapt[_i][41] := aCapt[_i][40]+aCapt[(_i-1)][41]
			aCapt[_i][45] := aCapt[_i][44]+aCapt[(_i-1)][45]
			aCapt[_i][49] := aCapt[_i][48]+aCapt[(_i-1)][49]
		EndIf
	Next _i

	//Atualiza Array com %Acum.
	For _i := 1 To Len(aCapt)
		If aCapt[_i][03] > 0
			aCapt[_i][06] := aCapt[_i][05]/aCapt[_i][03]*100
			aCapt[_i][10] := aCapt[_i][09]/aCapt[_i][03]*100
			aCapt[_i][14] := aCapt[_i][13]/aCapt[_i][03]*100
			aCapt[_i][18] := aCapt[_i][17]/aCapt[_i][03]*100
			aCapt[_i][22] := aCapt[_i][21]/aCapt[_i][03]*100
			aCapt[_i][26] := aCapt[_i][25]/aCapt[_i][03]*100
			aCapt[_i][30] := aCapt[_i][29]/aCapt[_i][03]*100
			aCapt[_i][34] := aCapt[_i][33]/aCapt[_i][03]*100
			aCapt[_i][38] := aCapt[_i][37]/aCapt[_i][03]*100
			aCapt[_i][42] := aCapt[_i][41]/aCapt[_i][03]*100
			aCapt[_i][46] := aCapt[_i][45]/aCapt[_i][03]*100
			aCapt[_i][50] := aCapt[_i][49]/aCapt[_i][03]*100
		EndIf
	Next _i

	//Atualiza Array com %Obj.
	For _i := 1 To Len(aCapt)
		If aSuper[1][3] > 0
			aCapt[_i][07] := aCapt[_i][05]/aSuper[1][3]*100
		EndIf
		If aSuper[2][3] > 0
			aCapt[_i][11] := aCapt[_i][09]/aSuper[2][3]*100
		EndIf
		If aSuper[3][3] > 0
			aCapt[_i][15] := aCapt[_i][13]/aSuper[3][3]*100
		EndIf
		If aSuper[4][3] > 0
			aCapt[_i][19] := aCapt[_i][17]/aSuper[4][3]*100
		EndIf
		If aSuper[5][3] > 0
			aCapt[_i][23] := aCapt[_i][21]/aSuper[5][3]*100
		EndIf
		If aSuper[6][3] > 0
			aCapt[_i][27] := aCapt[_i][25]/aSuper[6][3]*100
		EndIf
		If aSuper[7][3] > 0
			aCapt[_i][31] := aCapt[_i][29]/aSuper[7][3]*100
		EndIf
		If aSuper[8][3] > 0
			aCapt[_i][35] := aCapt[_i][33]/aSuper[8][3]*100
		EndIf
		If aSuper[9][3] > 0
			aCapt[_i][39] := aCapt[_i][37]/aSuper[9][3]*100
		EndIf
		If aSuper[10][3] > 0
			aCapt[_i][43] := aCapt[_i][41]/aSuper[10][3]*100
		EndIf
		If aSuper[11][3] > 0
			aCapt[_i][47] := aCapt[_i][45]/aSuper[11][3]*100
		EndIf
		If aSuper[12][3] > 0
			aCapt[_i][51] := aCapt[_i][49]/aSuper[12][3]*100
		EndIf
		If nMeta > 0
			aCapt[_i][52] := aCapt[_i][03]/nMeta*100
		EndIf
	Next _i

	//Imprime os dados de Metas
	aFill(aDados1,nil)
	oSection1:Init()

	aDados1[1] := "Meta"
	aDados1[2] := aSuper[1][3]
	aDados1[3] := aSuper[2][3]
	aDados1[4] := aSuper[3][3]
	aDados1[5] := aSuper[4][3]
	aDados1[6] := aSuper[5][3]
	aDados1[7] := aSuper[6][3]
	aDados1[8] := aSuper[7][3]
	aDados1[9] := aSuper[8][3]
	aDados1[10] := aSuper[9][3]
	aDados1[12] := aSuper[10][3]
	aDados1[13] := aSuper[11][3]
	aDados1[14] := aSuper[12][3]
	aDados1[11] := nMeta

	oSection1:PrintLine()
	aFill(aDados1,nil)

	oReport:SkipLine()
	oSection1:Finish()

	//Imprime Capta็ใo
	aFill(aDados2,nil)
	oSection2:Init()

	For _i := 1 To Len(aCapt)

		aDados2[01] := aCapt[_i][01]
		aDados2[02] := aCapt[_i][02]
		aDados2[03] := aCapt[_i][03]
		aDados2[04] := aCapt[_i][06]
		aDados2[05] := aCapt[_i][07]
		aDados2[06] := aCapt[_i][10]
		aDados2[07] := aCapt[_i][11]
		aDados2[08] := aCapt[_i][14]
		aDados2[09] := aCapt[_i][15]
		aDados2[10] := aCapt[_i][18]
		aDados2[11] := aCapt[_i][19]
		aDados2[12] := aCapt[_i][22]
		aDados2[13] := aCapt[_i][23]
		aDados2[14] := aCapt[_i][26]
		aDados2[15] := aCapt[_i][27]
		aDados2[16] := aCapt[_i][30]
		aDados2[17] := aCapt[_i][31]
		aDados2[18] := aCapt[_i][34]
		aDados2[19] := aCapt[_i][35]
		aDados2[20] := aCapt[_i][38]
		aDados2[21] := aCapt[_i][39]

		aDados2[23] := aCapt[_i][42] // Coluna V
		aDados2[24] := aCapt[_i][43] // Coluna W

		aDados2[25] := aCapt[_i][46] // Coluna V
		aDados2[26] := aCapt[_i][47] // Coluna W

		aDados2[27] := aCapt[_i][50] // Coluna V
		aDados2[28] := aCapt[_i][51] // Coluna W

		aDados2[22] := aCapt[_i][43] // Total Coluna X

		oSection2:PrintLine()
		aFill(aDados2,nil)

	Next _i

	oReport:SkipLine()
	oSection2:Finish()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusta    บAutor  ณMicrosiga           บ Data ณ  03/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Insere novas perguntas na tabela SX1 a Ajusta o Picture    บฑฑ
ฑฑบ          ณ dos valores no SX3                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ajusta()

	Local aPergs 	:= {}

	Aadd(aPergs,{"Mes ?                          ","Mes ?                         ","Mes ?                         ","mv_ch1","N",2,0,0,"G","NaoVazio().and.MV_PAR01<=12","mv_par01","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Ano ?             	         ","Ano ?             	          ","Ano ?                         ","mv_ch2","N",4,0,0,"G","NaoVazio().and.MV_PAR02<=2100.and.MV_PAR02>2000","mv_par02","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})

	//AjustaSx1("STFATR02",aPergs)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusta    บAutor  ณMicrosiga           บ Data ณ  03/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Insere novas perguntas na tabela SX1 a Ajusta o Picture    บฑฑ
ฑฑบ          ณ dos valores no SX3                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function StCalcMet(cCodVen)

	Local nRet		:= 0
	Local cQuery	:= ""
	Local cAlias	:= "QRYMET"

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	cQuery	:= "SELECT SUM(ZZD_VALOR) ZZD_VALOR "
	cQuery	+= "FROM "+RetSqlName("ZZD")+" ZZD "
	cQuery	+= "INNER JOIN "+RetSqlName("SA3")+" SA3 ON A3_FILIAL = '"+xFilial("SA3")+"' AND A3_COD = ZZD_VEND AND SA3.D_E_L_E_T_ = ' ' "
	cQuery	+= "WHERE "
	cQuery	+= "ZZD_FILIAL = '"+xFilial("ZZD")+"' AND  "
	cQuery	+= "A3_SUPER = '"+cCodVen+"' AND "
	cQuery	+= "ZZD_MES = '"+StrZero(mv_par01,2,0)+"' AND "
	cQuery	+= "ZZD_ANO = '"+StrZero(mv_par02,4,0)+"' AND "
	cQuery	+= "ZZD.D_E_L_E_T_ = ' ' "

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)

	dbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

	While (cAlias)->(!Eof())
		nRet := (cAlias)->ZZD_VALOR
		(cAlias)->(DbSkip())
	End

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

Return(nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MARKFILE บAutor  ณ Vitor Merguizo     บ Data ณ  08/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo auxiliar para sele็ใo de Arquivos                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MarkFile()

	Local aArea		:= SM0->(GetArea())
	Local aChaveArq := {}
	Local lSelecao	:= .T.
	Local cTitulo 	:= "Sele็ใo de Empresas para Gera็ใo de Relatorio: "
	Local cEmpresa	:= ""
	Local bCondicao := {|| .T.}

	// Variแveis utilizadas na sele็ใo de categorias
	Local oChkQual,lQual,oQual,cVarQ

	// Carrega bitmaps
	Local oOk := LoadBitmap( GetResources(), "LBOK")
	Local oNo := LoadBitmap( GetResources(), "LBNO")

	// Variแveis utilizadas para lista de filiais
	Local nx := 0
	Local nAchou := 0

	DbSelectArea("SM0")
	DbSetOrder(1)
	SM0->(DbGoTop())

	While SM0->(!Eof())
		If SM0->M0_CODIGO <> cEmpresa .And. SM0->M0_CODIGO $ "01#03" //Nใo Carrega a EMpresa 06
			//+--------------------------------------------------------------------+
			//| aChaveArq - Contem os arquivos que serใo exibidos para sele็ใo |
			//+--------------------------------------------------------------------+
			AADD(aChaveArq,{.F.,SM0->M0_CODIGO,SM0->M0_NOMECOM})
		EndIf
		cEmpresa := SM0->M0_CODIGO
		SM0->(dbSkip())
	EndDo

	If Empty(aChaveArq)
		ApMsgAlert("Nao foi possivel Localizar Empresas.")
		RestArea(aArea)
		Return aChaveArq
	EndIf

	RestArea(aArea)

	//+--------------------------------------------------------------------+
	//| Monta tela para sele็ใo dos arquivos contidos no diret๓rio |
	//+--------------------------------------------------------------------+
	DEFINE MSDIALOG oDlg TITLE cTitulo STYLE DS_MODALFRAME From 145,0 To 445,628 OF oMainWnd PIXEL
	oDlg:lEscClose := .F.
	@ 05,15 TO 125,300 OF oDlg PIXEL
	@ 15,20 CHECKBOX oChkQual VAR lQual PROMPT "Inverte Sele็ใo" SIZE 50, 10 OF oDlg PIXEL;
	ON CLICK (AEval(aChaveArq, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual:Refresh(.F.))
	@ 30,20 LISTBOX oQual VAR cVarQ Fields HEADER "","Codigo","Nome" SIZE;
	273,090 ON DBLCLICK (aChaveArq:=Troca(oQual:nAt,aChaveArq),oQual:Refresh()) NoScroll OF oDlg PIXEL
	oQual:SetArray(aChaveArq)
	oQual:bLine := { || {If(aChaveArq[oQual:nAt,1],oOk,oNo),aChaveArq[oQual:nAt,2],aChaveArq[oQual:nAt,3]}}
	DEFINE SBUTTON FROM 134,240 TYPE 1 ACTION IIF(MarcaOk(aChaveArq),(lSelecao := .T., oDlg:End(),.T.),.F.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 134,270 TYPE 2 ACTION (lSelecao := .F., oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED

RETURN aChaveArq

//Fun็ใo auxiliar: TROCA()
Static Function Troca(nIt,aArray)
	aArray[nIt,1] := !aArray[nIt,1]
Return aArray

//Fun็ใo auxiliar: MARCAOK()
Static Function MarcaOk(aArray)
	Local lRet:=.F.
	Local nx:=0
	// Checa marca็๕es efetuadas
	For nx:=1 To Len(aArray)
		If aArray[nx,1]
			lRet:=.T.
		EndIf
	Next
	// Checa se existe algum item marcado na confirma็ใo
	If !lRet
		MsgAlert("Nใo existem Empresas marcadas")
	EndIf
Return lRet
