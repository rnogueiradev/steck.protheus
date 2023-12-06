#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RSTFAT31	ºAutor  ³Renato Nogueira     º Data ³  12/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio utilizado para listar os enderecos dos romaneios  º±±
±±º          ³									    				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT31()

	Local oReport

	U_StPutSx1("RSTFAT31", "01","Romaneio de?" 		,"mv_par01","mv_ch1","C",10,0,"G")
	U_StPutSx1("RSTFAT31", "02","Romaneio ate?"		,"mv_par02","mv_ch2","C",10,0,"G")
	U_StPutSx1("RSTFAT31", "03","Consolida(S/N)?" 	,"mv_par03","mv_ch3","C",01,0,"G")
	U_StPutSx1("RSTFAT31", "04","Endereço?" 		,"mv_par04","mv_ch4","C",01,0,"C","","","","S=Sim","N=Nao","T=Todos")

	oReport		:= ReportDef()
	oReport		:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New("RSTFAT31","RELATÓRIO DE END POR ROMANEIO","RSTFAT31",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório endereços por romaneio.")

	Pergunte("RSTFAT31",.F.)

	oSection := TRSection():New(oReport,"ROMANEIO",{"PD2"})

	TRCell():New(oSection,"FILIAL" 		,"PD2","FILIAL"      								,"@!",2)
	TRCell():New(oSection,"ROMAN" 		,"PD2","ROMANEIO"			 			   	    	,"@!",10)
	TRCell():New(oSection,"NFS" 		,"PD2","NOTA FISCAL"		 			   	    	,"@!",9)
	TRCell():New(oSection,"OS" 			,"PD2","OS"					 			   	    	,"@!",6)
	TRCell():New(oSection,"END" 		,"PD2","ENDERECO"			 			   	    	,"@!",6)
	TRCell():New(oSection,"QTDVOL" 		,"PD2","QTDE VOL"			 			   	    	,"@E",5)
	TRCell():New(oSection,"TPVOL" 		,"PD2","TIPO VOL"			 			   	    	,"@!",6)
	TRCell():New(oSection,"DTFIMS" 		,"PD2","Data Final Embalagem"			   	    	,"@!",10)
	TRCell():New(oSection,"HRFIMS" 		,"PD2","Hora Final Embalagem"			   	    	,"@!",10)
	TRCell():New(oSection,"REGIAO" 		,"PD2","Regiao"							   	    	,"@!",20)
	TRCell():New(oSection,"CEP" 		,"PD2","Cep"							   	    	,"@!",20)

	oSection:SetHeaderSection(.T.)
	oSection:Setnofilter("PD2")

Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"
	Local aDados[99]
	Local _aDados	:= {}

	oSection:Cell("FILIAL")  	:SetBlock( { || aDados[1] } )
	oSection:Cell("ROMAN")   	:SetBlock( { || aDados[2] } )
	oSection:Cell("NFS")  		:SetBlock( { || aDados[3] } )
	oSection:Cell("OS")  		:SetBlock( { || aDados[4] } )
	oSection:Cell("END")  		:SetBlock( { || aDados[5] } )
	oSection:Cell("QTDVOL")		:SetBlock( { || aDados[6] } )
	oSection:Cell("TPVOL") 		:SetBlock( { || aDados[7] } )
	oSection:Cell("DTFIMS") 	:SetBlock( { || aDados[8] } )
	oSection:Cell("HRFIMS") 	:SetBlock( { || aDados[9] } )
	oSection:Cell("REGIAO") 	:SetBlock( { || aDados[10] } )
	oSection:Cell("CEP") 		:SetBlock( { || aDados[11] } )

	oReport:SetTitle("Lista endereço por romaneio")// Titulo do relatório

	cQuery := " SELECT * FROM (

	If AllTrim(MV_PAR03)=="S"
		cQuery += " SELECT FILIAL, ROMANEIO, NFS, SERIES, ORDSEP, ENDEREC, DTHRFIMS,  SUM(QUANTIDADE) QUANTIDADE FROM ( "
	EndIf

	cQuery += " SELECT DISTINCT PD2_FILIAL FILIAL, PD2_CODROM ROMANEIO, PD2_NFS NFS, PD2_SERIES SERIES, C9_ORDSEP ORDSEP,

	If AllTrim(MV_PAR03)=="S"
		cQuery += " (SELECT MAX(Z5_ENDEREC) FROM " +RetSqlName("SZ5")+ " WHERE D_E_L_E_T_=' ' AND Z5_FILIAL=C9_FILIAL AND C9_ORDSEP=Z5_ORDSEP) ENDEREC, "
	Else
		cQuery += " Z5_ENDEREC ENDEREC, "
	EndIf

	cQuery += " Z5_DTEMISS, "
	cQuery += " (SELECT SUBSTR(CB3_DESCRI,1,6) FROM " +RetSqlName("CB3")+ " CB3 WHERE CB3.D_E_L_E_T_=' ' AND CB6_TIPVOL=CB3_CODEMB AND CB6_FILIAL=CB3_FILIAL) TIPOVOL, "
	cQuery += " (SELECT COUNT(CB6_TIPVOL) FROM " +RetSqlName("CB6")+ " CB61 WHERE CB6.D_E_L_E_T_=' ' AND CB6.CB6_FILIAL=CB61.CB6_FILIAL AND CB6.CB6_XORDSE=CB61.CB6_XORDSE "
	cQuery += " AND CB6.CB6_PEDIDO=CB61.CB6_PEDIDO  AND CB6.CB6_TIPVOL=CB61.CB6_TIPVOL) QUANTIDADE, "
	cQuery += " (SELECT MAX(CB6_XDTFIN || CB6_XHFIN || ':00') FROM CB6010 CB6EM WHERE CB6EM.D_E_L_E_T_ = ' 'AND CB6EM.CB6_PEDIDO = CB6.CB6_PEDIDO AND CB6EM.CB6_FILIAL = CB6.CB6_FILIAL AND CB6EM.CB6_XORDSE = CB6.CB6_XORDSE) DTHRFIMS "
	cQuery += " FROM " +RetSqlName("SC9")+ " C9 "
	cQuery += " LEFT JOIN " +RetSqlName("PD2")+ " PD2 "
	cQuery += " ON PD2_FILIAL=C9_FILIAL AND PD2_NFS=C9_NFISCAL AND PD2_SERIES=C9_SERIENF AND PD2_CLIENT=C9_CLIENTE AND PD2_LOJCLI=C9_LOJA "
	cQuery += " LEFT JOIN " +RetSqlName("SZ5")+ " Z5 "
	cQuery += " ON C9_FILIAL=Z5_FILIAL AND C9_ORDSEP=Z5_ORDSEP AND Z5.D_E_L_E_T_=' ' "
	cQuery += " LEFT JOIN " +RetSqlName("CB6")+ " CB6 "
	cQuery += " ON CB6_FILIAL=PD2_FILIAL AND CB6_PEDIDO=C9_PEDIDO AND CB6_XORDSE=C9_ORDSEP "
	cQuery += " WHERE CB6.D_E_L_E_T_=' ' AND PD2.D_E_L_E_T_=' ' AND C9.D_E_L_E_T_=' ' AND PD2_CODROM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "

	/*
	>> Chamado 007224 - Everson Santana - 18.04.18 - Retirei a validação de aglutinação de todos os endereços da OS
	If !(AllTrim(MV_PAR03)=="S")
	cQuery += " AND (Z5.Z5_ENDEREC = (SELECT Z5_ENDEREC FROM " +RetSqlName("SZ5")+ " SZ52 WHERE R_E_C_N_O_ = "
	cQuery += " (SELECT MAX(R_E_C_N_O_) FROM " +RetSqlName("SZ5")+ " Z51 WHERE Z51.D_E_L_E_T_=' ' AND Z51.Z5_FILIAL=PD2_FILIAL AND Z51.Z5_ORDSEP=C9_ORDSEP)) OR Z5.Z5_ENDEREC IS NULL)"
	EndIf
	<< Chamado 007224 - Everson Santana - 18.04.18 
	*/

	//cQuery += " ORDER BY PD2_FILIAL, PD2_CODROM, PD2_NFS, C9_ORDSEP, Z5_DTEMISS, Z5_ENDEREC " //Chamado 007224 - Everson Santana - 18.04.18
	cQuery += " ORDER BY PD2_FILIAL, PD2_CODROM, PD2_NFS, C9_ORDSEP, Z5_DTEMISS DESC "

	If AllTrim(MV_PAR03)=="S"
		cQuery += " ) GROUP BY FILIAL, ROMANEIO, NFS, SERIES,ORDSEP, ENDEREC,DTHRFIMS "
	EndIf

	cQuery += " ) XXX
	cQuery += " WHERE FILIAL<>' '

	//Chamado 007306 - inclusão de parâmetro
	Do Case
		Case MV_PAR04==1
		cQuery += " AND ENDEREC LIKE '%FROTA%'
		//cQuery += " AND (SELECT COUNT(*) FROM "+RetSqlName("SZ5")+" Z5 WHERE Z5.D_E_L_E_T_=' '
		//cQuery += " AND Z5_FILIAL=FILIAL AND Z5_ORDSEP=ORDSEP AND Z5_ENDEREC LIKE '%FROTA%')>0
		Case MV_PAR04==2
		//cQuery += " AND ENDEREC NOT LIKE '%FROTA%'
		cQuery += " AND (SELECT COUNT(*) FROM "+RetSqlName("SZ5")+" Z5 WHERE Z5.D_E_L_E_T_=' '
		cQuery += " AND Z5_FILIAL=FILIAL AND Z5_ORDSEP=ORDSEP AND Z5_ENDEREC LIKE '%FROTA%')=0
	EndCase

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	//MemoWrite( "C:\Temp\QRY_RSTFAT31.txt", cQuery )

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	oReport:SetMeter(0)
	aFill(aDados,nil)
	oSection:Init()

	While !(cAlias)->(Eof())

		aDados[1]	:= (cAlias)->FILIAL
		aDados[2]	:= (cAlias)->ROMANEIO
		aDados[3]	:= (cAlias)->NFS
		aDados[4]	:= (cAlias)->ORDSEP
		aDados[5]	:= (cAlias)->ENDEREC
		aDados[6]	:= (cAlias)->QUANTIDADE
		If AllTrim(MV_PAR03)=="S"
			aDados[7]	:= ""
		Else
			aDados[7]	:= (cAlias)->TIPOVOL
		EndIf

		aDados[8]	:= 	StoD(Substr((cAlias)->DTHRFIMS,01,08))
		aDados[9]	:= 	Substr((cAlias)->DTHRFIMS,09,08)

		aDados[10]   := U_StCepReg((cAlias)->NFS,(cAlias)->SERIES)
        aDados[11]   := U_StCepReg((cAlias)->NFS,(cAlias)->SERIES,'1')

		oSection:PrintLine()
		aFill(aDados,nil)

		(cAlias)->(DbSkip())

	EndDo

	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())

Return oReport