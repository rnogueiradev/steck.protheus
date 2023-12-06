#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFATR08   บAutor  ณRichard N Cabral    บ Data ณ  16/03/18   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio Variaveis de Comissoes - RH                       บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Caso seja necessario alterar as regras deste relatorio	   บฑฑ
ฑฑ			   Por favo alterar tambem no RSTFAT21.prw e RSTFAT18.prw      บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFATR08()		//U_STFATR08()

	Local   oReport
	Private cPerg 			:= "STFATR08"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= GetNextAlias()
	Private cAliasSA3   	:= GetNextAlias()
	Private cPergTit 		:= cPerg+cHora+ cMinutos+cSegundos ///cAliasLif
	Private aDevol			:= {}
	Private aGrProd			:= {}
	Private aTabPerc		:= {}
	Private aVend			:= {}
	Private aVendMeta		:= {}
	Private _aCompany 		:= {}
	Private _aEquipe		:= {}
	Private _aPeso			:= {}
	Private _aFamilia		:= {}
	Private nPosVend		:= 0

	U_STPutSx1( cPerg, "01","M๊s/Ano:","MV_PAR01","mv_ch1","C",06,0,"G","U_GP04MAno(MV_PAR01)","","@R 99/9999")

	Pergunte(cPerg,.F.)

	oReport	:= ReportDef()
	oReport:PrintDialog()

Return

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณReportDef  บAutor  ณRichard N Cabral    บ Data ณ  16/03/18   บฑฑ
	ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Relatorio Variaveis de Comissoes - RH                       บฑฑ
	ฑฑบ          ณ                                                             บฑฑ
	ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                          บฑฑ
	ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	*-----------------------------*
Static Function ReportDef()
	*-----------------------------*
	Local oReport
	Local oSection2
	Local oSection3
	Local oSection4
	Local oSection5
	Local oSection6
	Local oSection7
	Local oSection8
	Local oSection9
	Local oSection10
	Local oSection11
	Local oSection12
	Local _nTam := 0
	//Local oSection13

	oReport := TReport():New(cPergTit,"Sales Incentive Plan - SIP",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir o relat๓rio SIP")

	oReport:nfontbody:=8
	oReport:cfontbody:="Courier New"

	oSection1 := TRSection():New(oReport,"SIP Vendedores",{cAliasLif})

	TRCell():New(oSection1,"COORDENADOR"				,,"Coordenador"				,"@!"					,06+_nTam,.F.,)
	TRCell():New(oSection1,"NOMECOORD"					,,"Nome Coordenador"		,"@!"					,30+_nTam,.F.,)
	TRCell():New(oSection1,"VENDEDOR"					,,"Vendedor"				,"@!"					,06+_nTam,.F.,)
	TRCell():New(oSection1,"MATRICUL"					,,"Matricula"				,"@!"					,06+_nTam,.F.,)
	TRCell():New(oSection1,"NOME"						,,"Nome Vendedor"			,"@!"					,30+_nTam,.F.,)
	TRCell():New(oSection1,"METAFATACM"					,,"Meta Acumulada"			,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection1,"REALFATACM"					,,"Realizado Acumulado"		,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection1,"PERCOMPANY"					,,"Company (%)"				,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection1,"PEREQUIPE"					,,"Equipe (%)"				,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection1,"PERCORE"					,,"Core (%)"				,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection1,"PERLANC"					,,"Lan็amento (%)"			,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection1,"PERATING"					,,"Atingimento (%)"			,"@E 999,999,999.99"	,20+_nTam,.F.,)

	oSection2 := TRSection():New(oReport,"SIP Internos",{cAliasLif})
	TRCell():New(oSection2,"INCOORDENADOR"				,,"Coordenador"				,"@!"					,06+_nTam,.F.,)
	TRCell():New(oSection2,"INNOMECOORD"				,,"Nome Coordenador"		,"@!"					,30+_nTam,.F.,)
	TRCell():New(oSection2,"INVENDEDOR"					,,"Vendedor"				,"@!"					,06+_nTam,.F.,)
	TRCell():New(oSection2,"INMATRICUL"					,,"Matricula"				,"@!"					,06+_nTam,.F.,)
	TRCell():New(oSection2,"INNOME"						,,"Nome Vendedor"			,"@!"					,30+_nTam,.F.,)
	TRCell():New(oSection2,"INMETAFATACM"				,,"Meta Acumulada"			,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection2,"INREALFATACM"				,,"Realizado Acumulado"		,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection2,"INPERCOMPANY"				,,"Company (%)"				,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection2,"INPEREQUIPE"				,,"Equipe (%)"				,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection2,"INPERCORE"					,,"Core (%)"				,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection2,"INPERLANC"					,,"Lan็amento (%)"			,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection2,"INPERATING"					,,"Atingimento (%)"			,"@E 999,999,999.99"	,20+_nTam,.F.,)

	oSection3 := TRSection():New(oReport,"SIP Managers",{cAliasLif})
	TRCell():New(oSection3,"MACOORDENADOR"				,,"Coordenador"				,"@!"					,06+_nTam,.F.,)
	TRCell():New(oSection3,"MANOMECOORD"				,,"Nome Coordenador"		,"@!"					,30+_nTam,.F.,)
	TRCell():New(oSection3,"MAMETAFATACM"				,,"Meta Acumulada"			,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection3,"MAREALFATACM"				,,"Realizado Acumulado"		,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection3,"MAPERCOMPANY"				,,"Company (%)"				,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection3,"MAPEREQUIPE"				,,"Equipe (%)"				,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection3,"MAPERCORE"					,,"Core (%)"				,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection3,"MAPERLANC"					,,"Lan็amento (%)"			,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection3,"MAPERATING"					,,"Atingimento (%)"			,"@E 999,999,999.99"	,20+_nTam,.F.,)

	oSection4 := TRSection():New(oReport,"Meta Vendedores",{cAliasLif})
	TRCell():New(oSection4,"MVCOORDENADOR"				,,"Coordenador"				,"@!"					,06+_nTam,.F.,)
	TRCell():New(oSection4,"MVNOMECOORD"				,,"Nome Coordenador"		,"@!"					,30+_nTam,.F.,)
	TRCell():New(oSection4,"MVVENDECOR"					,,"Vendedor"				,"@!"					,06+_nTam,.F.,)
	TRCell():New(oSection4,"MVNOME"						,,"Nome Vendedor"			,"@!"					,30+_nTam,.F.,)
	TRCell():New(oSection4,"MVJAN"						,,"Janeiro"					,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection4,"MVFEV"						,,"Fevereiro"				,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection4,"MVMAC"						,,"Mar็o"					,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection4,"MVABR"						,,"Abril"					,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection4,"MVMAI"						,,"Maio"					,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection4,"MVJUN"						,,"Junho"					,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection4,"MVJUL"						,,"Julho"					,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection4,"MVAGO"						,,"Agosto"					,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection4,"MVSET"						,,"Setembro"				,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection4,"MVOUT"						,,"Outubro"					,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection4,"MVNOV"						,,"Novembro"				,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection4,"MVDEZ"						,,"Dezembro"				,"@E 999,999,999.99"	,20+_nTam,.F.,)

	oSection5 := TRSection():New(oReport,"Company",{cAliasLif})
	TRCell():New(oSection5,"FATBRASIL"					,,"Faturamento Brasil "			,"@E 999,999,999.99"	,20+_nTam,.F.,)
	TRCell():New(oSection5,"OJTBRASIL"					,,"Objetivo Brasil "			,"@E 999,999,999.99"	,20+_nTam,.F.,)

	oSection6 := TRSection():New(oReport,"Coordenadores",{cAliasLif})
	TRCell():New(oSection6,"EPQCOOR"					,,"Coordenador"					,"@!				"	,07+_nTam,.F.,)
	TRCell():New(oSection6,"EPQNOME"					,,"Nome do Coordenador"			,"@!				"	,30+_nTam,.F.,)
	TRCell():New(oSection6,"EPQNUCL"					,,"Nucleo"						,"@!				"	,15+_nTam,.F.,)
	TRCell():New(oSection6,"EPQREAL"					,,"Realizado"					,"@E 999,999,999.99	"	,20+_nTam,.F.,)
	TRCell():New(oSection6,"EPQMETA"					,,"Meta"						,"@E 999,999,999.99	"	,20+_nTam,.F.,)

	oSection7 := TRSection():New(oReport,"Vendedores",{cAliasLif})
	TRCell():New(oSection7,"VENCODI"					,,"Vendedor"						,"@!"					,07+_nTam,.F.,)
	TRCell():New(oSection7,"VENNOME"					,,"Nome do Vendedor"				,"@!"					,30+_nTam,.F.,)
	TRCell():New(oSection7,"VENCOOR"					,,"Coordenador"						,"@!"					,07+_nTam,.F.,)
	TRCell():New(oSection7,"VENNCOO"					,,"Nome do Coordenador"				,"@!"					,30+_nTam,.F.,)

	oSection8 := TRSection():New(oReport,"Internos",{cAliasLif})
	TRCell():New(oSection8,"VENINCODI"					,,"Vendedor"						,"@!"					,07+_nTam,.F.,)
	TRCell():New(oSection8,"VENINNOME"					,,"Nome do Vendedor"				,"@!"					,30+_nTam,.F.,)
	TRCell():New(oSection8,"VENINCOOR"					,,"Coordenador"						,"@!"					,07+_nTam,.F.,)
	TRCell():New(oSection8,"VENINNCOO"					,,"Nome do Coordenador"				,"@!"					,30+_nTam,.F.,)

	oSection9 := TRSection():New(oReport,"Familias",{cAliasLif})
	TRCell():New(oSection9,"FAMAGRU"					,,"Agrupamento"						,"@!"					,20+_nTam,.F.,)
	TRCell():New(oSection9,"FAMCLAS"					,,"Classe"							,"@!"					,20+_nTam,.F.,)

	oSection10 := TRSection():New(oReport,"Grupos de Produtos",{cAliasLif})
	TRCell():New(oSection10,"GRPGRUPO"					,,"Grupo"							,"@!"					,20+_nTam,.F.,)
	TRCell():New(oSection10,"GRPDESC"					,,"Descri็ใo do Grupo"				,"@!"					,20+_nTam,.F.,)
	TRCell():New(oSection10,"GRPAGRU"					,,"Agrupamento"						,"@!"					,20+_nTam,.F.,)
	TRCell():New(oSection10,"GRPCLAS"					,,"Classe"							,"@!"					,20+_nTam,.F.,)

	oSection11 := TRSection():New(oReport,"Mix",{cAliasLif})
	TRCell():New(oSection11,"MIX"						,,"Verificar Necessidade"			,"@!"					,20+_nTam,.F.,)

	oSection12 := TRSection():New(oReport,"Pesos",{cAliasLif})
	TRCell():New(oSection12,"PESCLAS"					,,"Classe"							,"@!"					,20+_nTam,.F.,)
	TRCell():New(oSection12,"PESDESC"					,,"Descri็ใo"						,"@!"					,20+_nTam,.F.,)
	TRCell():New(oSection12,"PESCOM"					,,"% Company"						,"@E 999.99"			,20+_nTam,.F.,)
	TRCell():New(oSection12,"PESFIL"					,,"% Filial"						,"@E 999.99"			,20+_nTam,.F.,)
	TRCell():New(oSection12,"PESCOR"					,,"% Core"							,"@E 999.99"			,20+_nTam,.F.,)
	TRCell():New(oSection12,"PESLAN"					,,"% Lan็amento"					,"@E 999.99"			,20+_nTam,.F.,)
	TRCell():New(oSection12,"PESTOT"					,,"% Total"							,"@E 999.99"			,20+_nTam,.F.,)

Return oReport
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณReportPrintบAutor  ณRichard N Cabral    บ Data ณ  16/03/18   บฑฑ
	ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Relatorio Variaveis de Comissoes - RH                       บฑฑ
	ฑฑบ          ณ                                                             บฑฑ
	ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                          บฑฑ
	ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	*------------------------------------*
Static Function ReportPrint(oReport)
	*------------------------------------*

	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local oSection3 := oReport:Section(3)
	Local oSection4 := oReport:Section(4)
	Local oSection5 := oReport:Section(5)
	Local oSection6 := oReport:Section(6)
	Local oSection7 := oReport:Section(7)
	Local oSection8 := oReport:Section(8)
	Local oSection9 := oReport:Section(9)
	Local oSection10 := oReport:Section(10)
//	Local oSection11 := oReport:Section(11)
	Local oSection12 := oReport:Section(12)
	Local nX		:= 0
	Local aDados[99]
	Local aDados1[99]
	Local aDados2[99]
	Local aDados3[99]
	Local aDados4[99]
	Local aDados5[02]
	Local aDados6[99]
	Local aDados7[05]
	Local aDados8[05]
	Local aDados9[03]
	Local aDados10[05]
	Local aDados11[99]
	Local aDados12[08]
	Local aDados13[99]

	Local nVend		:= 0
	Local _nX 		:= 0
	Local nColVal	:= Len(aGrProd) * 4 + 19
	Local nFatur	:= 0
	//Local nGrupProd := 0

	oSection1:Cell("COORDENADOR")  	:SetBlock( { || aDados[05] } )	//01
	oSection1:Cell("NOMECOORD")  	:SetBlock( { || aDados[06] } )	//01
	oSection1:Cell("VENDEDOR")  	:SetBlock( { || aDados[02] } )	//02
	oSection1:Cell("MATRICUL")  	:SetBlock( { || aDados[03] } )	//03
	oSection1:Cell("NOME")      	:SetBlock( { || aDados[04] } )	//04
	oSection1:Cell("METAFATACM")	:SetBlock( { || aDados[07] } )	//05
	oSection1:Cell("REALFATACM")	:SetBlock( { || aDados[08] } )	//06
	oSection1:Cell("PERCOMPANY")	:SetBlock( { || aDados[09] } )	//07
	oSection1:Cell("PEREQUIPE")		:SetBlock( { || aDados[10] } )	//08
	oSection1:Cell("PERCORE")		:SetBlock( { || aDados[11] } )	//09
	oSection1:Cell("PERLANC")		:SetBlock( { || aDados[12] } )	//10
	oSection1:Cell("PERATING")		:SetBlock( { || aDados[13] } )	//11

	oSection2:Cell("INCOORDENADOR") :SetBlock( { || aDados2[05] } )	//01
	oSection2:Cell("INNOMECOORD")  	:SetBlock( { || aDados2[06] } )	//01
	oSection2:Cell("INVENDEDOR")  	:SetBlock( { || aDados2[02] } )	//02
	oSection2:Cell("INMATRICUL")  	:SetBlock( { || aDados2[03] } )	//03
	oSection2:Cell("INNOME")      	:SetBlock( { || aDados2[04] } )	//04
	oSection2:Cell("INMETAFATACM")	:SetBlock( { || aDados2[18] } )	//05
	oSection2:Cell("INREALFATACM")	:SetBlock( { || aDados2[19] } )	//06
	oSection2:Cell("INPERCOMPANY")	:SetBlock( { || aDados2[09] } )	//07
	oSection2:Cell("INPEREQUIPE")	:SetBlock( { || aDados2[10] } )	//08
	oSection2:Cell("INPERCORE")		:SetBlock( { || aDados2[11] } )	//09
	oSection2:Cell("INPERLANC")		:SetBlock( { || aDados2[12] } )	//10
	oSection2:Cell("INPERATING")	:SetBlock( { || aDados2[13] } )	//11

	oSection3:Cell("MACOORDENADOR") :SetBlock( { || aDados3[01] } )	//01
	oSection3:Cell("MANOMECOORD")  	:SetBlock( { || aDados3[02] } )	//02
	oSection3:Cell("MAMETAFATACM")	:SetBlock( { || aDados3[03] } )	//03
	oSection3:Cell("MAREALFATACM")	:SetBlock( { || aDados3[04] } )	//04
	oSection3:Cell("MAPERCOMPANY")	:SetBlock( { || aDados3[05] } )	//05
	oSection3:Cell("MAPEREQUIPE")	:SetBlock( { || aDados3[06] } )	//06
	oSection3:Cell("MAPERCORE")		:SetBlock( { || aDados3[07] } )	//07
	oSection3:Cell("MAPERLANC")		:SetBlock( { || aDados3[08] } )	//08
	oSection3:Cell("MAPERATING")	:SetBlock( { || aDados3[09] } )	//09

	oSection4:Cell("MVCOORDENADOR")	:SetBlock( { || aDados4[01] } )	//09
	oSection4:Cell("MVNOMECOORD")	:SetBlock( { || aDados4[02] } )	//09
	oSection4:Cell("MVVENDECOR")	:SetBlock( { || aDados4[03] } )	//09
	oSection4:Cell("MVNOME")	:SetBlock( { || aDados4[04] } )	//09
	oSection4:Cell("MVJAN")	:SetBlock( { || aDados4[05] } )	//09
	oSection4:Cell("MVFEV")	:SetBlock( { || aDados4[06] } )	//09
	oSection4:Cell("MVMAC")	:SetBlock( { || aDados4[07] } )	//09
	oSection4:Cell("MVABR")	:SetBlock( { || aDados4[08] } )	//09
	oSection4:Cell("MVMAI")	:SetBlock( { || aDados4[09] } )	//09
	oSection4:Cell("MVJUN")	:SetBlock( { || aDados4[10] } )	//09
	oSection4:Cell("MVJUL")	:SetBlock( { || aDados4[11] } )	//09
	oSection4:Cell("MVAGO")	:SetBlock( { || aDados4[12] } )	//09
	oSection4:Cell("MVSET")	:SetBlock( { || aDados4[13] } )	//09
	oSection4:Cell("MVOUT")	:SetBlock( { || aDados4[14] } )	//09
	oSection4:Cell("MVNOV")	:SetBlock( { || aDados4[15] } )	//09
	oSection4:Cell("MVDEZ")	:SetBlock( { || aDados4[16] } )	//09

	oSection5:Cell("FATBRASIL"):SetBlock( { || _aCompany[02][02] } ) //Realizado Acumulado
	oSection5:Cell("OJTBRASIL"):SetBlock( { || _aCompany[01][02] } ) //Meta Acumulada

	oSection6:Cell("EPQCOOR"):SetBlock( { || aDados6[01] } ) //Coordenador
	oSection6:Cell("EPQNOME"):SetBlock( { || aDados6[02] } ) //Nome do Coordenador
	oSection6:Cell("EPQNUCL"):SetBlock( { || aDados6[03] } ) //Nucleo
	oSection6:Cell("EPQREAL"):SetBlock( { || aDados6[04] } ) //Nucleo
	oSection6:Cell("EPQMETA"):SetBlock( { || aDados6[05] } ) //Meta

	oSection7:Cell("VENCODI"):SetBlock( { || aDados7[01] } ) //Coordenador
	oSection7:Cell("VENNOME"):SetBlock( { || aDados7[02] } ) //Nome do Coordenador
	oSection7:Cell("VENCOOR"):SetBlock( { || aDados7[03] } ) //Nucleo
	oSection7:Cell("VENNCOO"):SetBlock( { || aDados7[04] } ) //Nucleo

	oSection8:Cell("VENINCODI"):SetBlock( { || aDados8[01] } ) //Coordenador
	oSection8:Cell("VENINNOME"):SetBlock( { || aDados8[02] } ) //Nome do Coordenador
	oSection8:Cell("VENINCOOR"):SetBlock( { || aDados8[03] } ) //Nucleo
	oSection8:Cell("VENINNCOO"):SetBlock( { || aDados8[04] } ) //Nucleo

	oSection9:Cell("FAMAGRU"):SetBlock( { || aDados9[01] } ) //Agrupamento
	oSection9:Cell("FAMCLAS"):SetBlock( { || aDados9[02] } ) //Classe

	oSection10:Cell("GRPGRUPO"):SetBlock( { || aDados10[01] } ) //Grupo
	oSection10:Cell("GRPDESC"):SetBlock( { || aDados10[02] } ) //Desc Grupo
	oSection10:Cell("GRPAGRU"):SetBlock( { || aDados10[03] } ) //Agrupamento
	oSection10:Cell("GRPCLAS"):SetBlock( { || aDados10[04] } ) //Classe

	oSection12:Cell("PESCLAS"):SetBlock( { || aDados12[01] } ) //Classe
	oSection12:Cell("PESDESC"):SetBlock( { || aDados12[02] } ) //Descri็ใo
	oSection12:Cell("PESCOM"):SetBlock( { || aDados12[03] } ) //Company
	oSection12:Cell("PESFIL"):SetBlock( { || aDados12[04] } ) //Filial
	oSection12:Cell("PESCOR"):SetBlock( { || aDados12[05] } ) //Core
	oSection12:Cell("PESLAN"):SetBlock( { || aDados12[06] } ) //Lan็amento
	oSection12:Cell("PESTOT"):SetBlock( { || aDados12[07] } ) //Total

	oReport:SetTitle("Sales Incentive Plan - SIP")

	oReport:SetMeter(0)

	aFill(aDados,nil)
	aFill(aDados1,nil)
	aFill(aDados2,nil)
	aFill(aDados3,nil)
	aFill(aDados5,nil)
	aFill(aDados6,nil)
	aFill(aDados7,nil)
	aFill(aDados8,nil)
	aFill(aDados9,nil)
	aFill(aDados10,nil)
	aFill(aDados11,nil)
	aFill(aDados12,nil)
	aFill(aDados13,nil)

	Processa({|| StQuery() },"Compondo Relatorio")

	aVend := {}
	nFatur	:= 0
	cVendBase := ""

		/* _aPeso
		01 - Classe
		02 - Descricao
		03 - Company
		04 - Filial
		05 - Core
		06 - Lancamentos 
		*/			
	aAdd(_aPeso,{"A",""			, 0, 0, 0, 0})
	aAdd(_aPeso,{"C",""			, 0, 0, 0, 0})
	aAdd(_aPeso,{"E","Externo"	,15,15,40,30})
	aAdd(_aPeso,{"I","Interno"	,25,25,25,25})
	aAdd(_aPeso,{"R","Repres"	,15,15,40,30})
	aAdd(_aPeso,{"S","Suporte"	,25,25,25,25})
	aAdd(_aPeso,{"X","CCC"		,50, 0,25,25})
	aAdd(_aPeso,{" ",""			, 0, 0, 0, 0})

	aAdd(_aCompany,{"OBJ_BRASIL",0})
	aAdd(_aCompany,{"FAT_BRASIL",0})

	_Qry := " "
	_Qry += " SELECT * FROM "+RetSqlName("SA3")+" SA3 "
	_Qry += " WHERE  A3_SUPER <> ' ' "
	_Qry += " AND D_E_L_E_T_ = ' ' "

	If Select(cAliasSA3) > 0
		(cAliasSA3)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,_Qry),cAliasSA3)

	DbSelectArea(cAliasSA3)
	(cAliasSA3)->(DbGoTop())

	While !EOF()

		//nPosVend := aScan(aVend,{|x| x[2] = SA3->A3_COD})

		cVendBase := (cAliasSA3)->A3_COD
		cCodSuper	:= Posicione("SA3",1,xFilial("SA3")+cVendBase,"A3_SUPER")
		cNonSuper	:= Posicione("SA3",1,xFilial("SA3")+cCodSuper,"A3_NOME")

		//If Empty(nPosVend)
		aAdd(aVend,{"",(cAliasSA3)->A3_COD,"","",cCodSuper,cNonSuper,Array(nColVal)})
		nPosVend := Len(aVend)
		For nX := 7 to Len(aVend[nPosVend,7])
			aVend[nPosVend,7,nX] := 0
		Next nX
		//EndIf

		nPosSuper := aScan(_aEquipe,{|x| x[1] = (cAliasSA3)->A3_SUPER})
			/*_aEquipe
			01 - Coordenador
			02 - Meta do Coordenador 
			03 - Realizado Coordenador
			04 - Meta Core
			05 - Realizado Core 		
			06 - Meta Lcto
			07 - Realizado Lcto
			*/
		If nPosSuper = 0
			aAdd(_aEquipe,{(cAliasSA3)->A3_SUPER,0,0,0,0,0,0})
		EndIf

		DbSelectArea(cAliasSA3)
		DbSkip()

	End

		/* _aFamilia
		01 - Familia
		02 - Meta	
		03 - Realizado
		04 - Classe
		*/

	aAdd(_aFamilia,{"N/A"					 	,"N/A"})
	aAdd(_aFamilia,{"ACESSORIOS PARA QUADROS"	,"CORE"})
	aAdd(_aFamilia,{"BOTOEIRAS"				 	,"CORE"})
	aAdd(_aFamilia,{"CENTROS DE DISTRIBUICAO"	,"CORE"})
	aAdd(_aFamilia,{"CHAVES"				 	,"CORE"})
	aAdd(_aFamilia,{"CONECTORES"			 	,"CORE"})
	aAdd(_aFamilia,{"CONTATORES E ACESSORIOS"	,"CORE"})
	aAdd(_aFamilia,{"DISJUNTOR MOTOR"			,"CORE"})
	aAdd(_aFamilia,{"FDA"				 		,"CORE"})
	aAdd(_aFamilia,{"FDB"				 		,"CORE"})
	aAdd(_aFamilia,{"FIM DE CURSO"				,"CORE"})
	aAdd(_aFamilia,{"MCCB & ACB"				,"CORE"})
	aAdd(_aFamilia,{"MISCELLANEOUS"				,"CORE"})
	aAdd(_aFamilia,{"PLUGS E TOMADAS"			,"CORE"})
	aAdd(_aFamilia,{"RELES TERMICOS"			,"CORE"})
	aAdd(_aFamilia,{"UNICOM"				 	,"CORE"})
	aAdd(_aFamilia,{"UNIVERSAL ENCLOSURES"		,"CORE"})
	aAdd(_aFamilia,{"CMS"				 		,"LCTO"})
	aAdd(_aFamilia,{"FITECK"				 	,"LCTO"})
	aAdd(_aFamilia,{"PILHAS E BATERIAS"			,"LCTO"})
	aAdd(_aFamilia,{"SMARTECK"				 	,"LCTO"})
	aAdd(_aFamilia,{"WDI"				 		,"LCTO"})

		/*aVend
		01 - Segmento
		02 - Codigo do Vendedor
		03 - Matricula do Vendedor
		04 - Nome do Vendedor
		05 - Codigo do Superior
		06 - Nome do Superior
		07 - Segundo Nivel
		0701 - Nil
		0702 - Nil
		0703 - Nil
		0704 - NIl
		0705 - Nil
		0706 - Nil
		0707 - Total Meta
		0708 - Total Realizado
		0709 - Company(%) 
		0710 - Equipe(%) 
		0711 - Core(%) 
		0712 - Lan็amento(%) 
		0713 - Atingimento
		0714 - Total Meta Core
		0715 - Total Realizado Core 
		0716 - Total Meta Lcto
		0717 - Total Realizado Lcto
		*/

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While (cAliasLif)->(!Eof())

			nPosVend := aScan(aVend,{|x| x[2] = (cAliasLif)->VENDEDOR})
			/*
			cVendBase := (cAliasLif)->VENDEDOR
			cCodSuper	:= Posicione("SA3",1,xFilial("SA3")+cVendBase,"A3_SUPER")
			cNonSuper	:= Posicione("SA3",1,xFilial("SA3")+cCodSuper,"A3_NOME")

			If Empty(nPosVend)
				aAdd(aVend,{"",(cAliasLif)->VENDEDOR,"","",cCodSuper,cNonSuper,Array(nColVal)})
				nPosVend := Len(aVend)
				For nX := 7 to Len(aVend[nPosVend,7])
					aVend[nPosVend,7,nX] := 0
				Next nX
			EndIf
			*/
			/*
			If (cAliasLif)->VENDEDOR = "I08604"

				ntst := 0

			EndIf
			*/

			IF nPosVend > 0
				aVend[nPosVend,7,08] 	+= (cAliasLif)->REALIZADO
				_aCompany[02,02] 		+= (cAliasLif)->REALIZADO

				nPosFamilia := aScan(_aFamilia,{|x| x[1] = Alltrim((cAliasLif)->AGRUPAMENTO)})
				If nPosFamilia > 0
					If _aFamilia[nPosFamilia][02] $ "CORE"
						aVend[nPosVend,7,15] 	+= (cAliasLif)->REALIZADO
					ElseIf _aFamilia[nPosFamilia][02] $ "LCTO"
						aVend[nPosVend,7,17] 	+= (cAliasLif)->REALIZADO
					EndIf
				EndIf

				nPosSuper := aScan(_aEquipe,{|x| x[1] = aVend[nPosVend,5]})
				If nPosSuper > 0
					_aEquipe[nPosSuper,03] += (cAliasLif)->REALIZADO
					nPosFamilia := aScan(_aFamilia,{|x| x[1] = Alltrim((cAliasLif)->AGRUPAMENTO)})
					If nPosFamilia > 0
						If _aFamilia[nPosFamilia][02] $ "CORE"
							_aEquipe[nPosSuper,05] 	+= (cAliasLif)->REALIZADO
						ElseIf _aFamilia[nPosFamilia][02] $ "LCTO"
							_aEquipe[nPosSuper,07]	+= (cAliasLif)->REALIZADO
						EndIf
					EndIf
				EndIf
			EndIf
			(cAliasLif)->(dbskip())
		End

		(cAliasLif)->(dbCloseArea())

		For nVend := 1 to Len(aVend)
			ApuraMeta(aVend[nVend,2])
		Next

		SA3->(DbSetOrder(1))
		For nVend := 1 to Len(aVend)
			SA3->(DbSeek(xFilial("SA3")+aVend[nVend,2]))

			aVend[nVend,1] :=  SA3->A3_XSEGVEN
			aVend[nVend,2] :=  SA3->A3_COD
			aVend[nVend,3] :=  SA3->A3_NUMRA
			aVend[nVend,4] :=  SA3->A3_NOME

			nPosPerc := aScan(_aPeso,{|x| x[1] = SubStr(aVend[nVend,2],1,1)})

			If nPosPerc > 0
				aVend[nVend,7,09] := Round((_aCompany[02,02]/_aCompany[01,02]*_aPeso[nPosPerc][03]),2 ) //Company(%)
			EndIf

			nPosSuper := aScan(_aEquipe,{|x| x[1] = aVend[nVend,5]})

			If nPosSuper > 0
				aVend[nVend,7,10] := Round((_aEquipe[nPosSuper,03]/_aEquipe[nPosSuper,02]*_aPeso[nPosPerc][04]),2 ) //Equipe(%)
				aVend[nVend,7,18] := _aEquipe[nPosSuper][02] //Meta
				aVend[nVend,7,19] := _aEquipe[nPosSuper][03] //Realizado
			EndIf
			/*
			If aVend[nVend,2] = "I08606"

				ntst := 0

			EndIf
			*/
			If SubString(aVend[nVend,02],1,1) = "I" .AND. aVend[nVend,07,08] = 0
				aVend[nVend,7,11] := Round((_aEquipe[nPosSuper,05]/_aEquipe[nPosSuper,04]*_aPeso[nPosPerc][05]),2 )  //Core(%)
				aVend[nVend,7,12] := Round((_aEquipe[nPosSuper,07]/_aEquipe[nPosSuper,06]*_aPeso[nPosPerc][06]),2 )  //Lan็amento(%)
			Else
				aVend[nVend,7,11] := Round((aVend[nVend,7,15]/aVend[nVend,7,14]*_aPeso[nPosPerc][05]),2 ) //Core(%)
				aVend[nVend,7,12] := Round((aVend[nVend,7,17]/aVend[nVend,7,16]*_aPeso[nPosPerc][06]),2 ) //Lan็amento(%)
			Endif

			aVend[nVend,7,13] := Round((aVend[nVend,7,09]+aVend[nVend,7,10]+aVend[nVend,7,11]+aVend[nVend,7,12]),2) // Atingimento

		Next nVend

		aSort(aVend,,,{ |x,y| x[1] + x[4] < y[1] + y[4] })

		For nVend := 1 to Len(aVend)

			//>> SIP - Vendedores
			If SubString(aVend[nVend,02],1,1) $ "E#I" .AND. aVend[nVend,07,08] > 0
				For nX := 1 to Len(aVend[nVend,7])
					aDados[nX]	:=  If(nX <= 6, aVend[nVend,nX],If(aVend[nVend,7,nX]<0,0,aVend[nVend,7,nX]))
				Next nX

				oSection1:Init()
				oSection1:PrintLine()
				oSection1:Finish()

				aFill(aDados,nil)
			EndIf
			//<< SIP - Vendedores

			//>> SIP - Internos
			If SubString(aVend[nVend,02],1,1) = "I" .AND. aVend[nVend,07,08] = 0

				For nX := 1 to Len(aVend[nVend,7])
					aDados2[nX]	:=  If(nX <= 6, aVend[nVend,nX],If(aVend[nVend,7,nX]<0,0,aVend[nVend,7,nX]))
				Next nX

				oSection2:Init()
				oSection2:PrintLine()
				oSection2:Finish()

				aFill(aDados2,nil)

			EndIf
			//<< SIP - Internos

			//>> 8-Vendedores
			aDados7[01] :=  aVend[nVend,02]  //SA3->A3_COD	// Cod Vendedor
			aDados7[02]	:=	aVend[nVend,04]  //SA3->A3_NOME// Nome do Vendedor
			aDados7[03]	:=	aVend[nVend,05]  //SA3->A3_SUPER// Coordenador
			aDados7[04]	:=	aVend[nVend,06]  // Nome do Coordenador

			oSection7:Init()
			oSection7:PrintLine()
			oSection7:Finish()

			aFill(aDados7,nil)

			//<< 8-Vendedores

			//>> 9-Internos
			If SubString(aVend[nVend,02],1,1) = "I"

				aDados8[01] :=  aVend[nVend,02]  //SA3->A3_COD	// Cod Vendedor
				aDados8[02]	:=	aVend[nVend,04]  //SA3->A3_NOME// Nome do Vendedor
				aDados8[03]	:=	aVend[nVend,05]  //SA3->A3_SUPER// Coordenador
				aDados8[04]	:=	aVend[nVend,06]  // Nome do Coordenador

				oSection8:Init()
				oSection8:PrintLine()
				oSection8:Finish()

				aFill(aDados8,nil)

			EndIf

			//<< 9-Internos

		Next nVend

		//>> SIP - Managers
		aSort(_aEquipe,,,{ |x,y| x[1] < y[1] })

		For _nX := 1 to Len(_aEquipe)

			aDados3[01]	:= _aEquipe[_nX][01] //Coordenador
			aDados3[02]	:= Posicione("SA3",1,xFilial("SA3")+_aEquipe[_nX][01],"A3_NOME")  //Nome do Coordenador
			aDados3[03]	:= _aEquipe[_nX][02] //Meta
			aDados3[04]	:= _aEquipe[_nX][03] //Realizado

			If _aEquipe[_nX][01] = 'A00003'
				aDados3[05] := Round((_aCompany[02,02]/_aCompany[01,02]*_aPeso[04][03]),2 ) //Company(%)
				aDados3[06] := Round((_aEquipe[_nX][03]/_aEquipe[_nX][03]*_aPeso[04][04]),2 ) //Equipe(%)
				aDados3[07]  := Round( (_aEquipe[_nX][05]/_aEquipe[_nX][04]*_aPeso[04][05]),2 ) //Core(%)
				aDados3[08] := Round((_aEquipe[_nX][07]/_aEquipe[_nX][06]*_aPeso[04][06]),2 ) //Lan็amento(%)
			Else
				aDados3[05] := Round((_aCompany[02,02]/_aCompany[01,02]*_aPeso[03][03]),2 ) //Company(%)
				aDados3[06] := Round((_aEquipe[_nX][03]/_aEquipe[_nX][03]*_aPeso[03][04]),2 ) //Equipe(%)
				aDados3[07]  := Round( (_aEquipe[_nX][05]/_aEquipe[_nX][04]*_aPeso[03][05]),2 ) //Core(%)
				aDados3[08] := Round((_aEquipe[_nX][07]/_aEquipe[_nX][06]*_aPeso[03][06]),2 ) //Lan็amento(%)
			EndIf

			aDados3[09] := Round((aDados3[05]+aDados3[06]+aDados3[07]+aDados3[08]),2) // Atingimento

			oSection3:Init()
			oSection3:PrintLine()
			oSection3:Finish()

			aFill(aDados3,nil)

		Next _nX
		//<< SIP - Managers

		oSection5:Init()
		oSection5:PrintLine()
		oSection5:Finish()

		//>> 7-Coordenadores
		aSort(_aEquipe,,,{ |x,y| x[1] < y[1] })

		For _nX := 1 to Len(_aEquipe)

			aDados6[01]	:=  _aEquipe[_nX][01] //Coordenador
			aDados6[02]	:=  Posicione("SA3",1,xFilial("SA3")+_aEquipe[_nX][01],"A3_NOME")
			aDados6[03]	:=  ""//_aEquipe[nEquipe][01] //Nucleo
			aDados6[04]	:=  _aEquipe[_nX][03] //Realizado
			aDados6[05]	:=  _aEquipe[_nX][02] //Meta

			oSection6:Init()
			oSection6:PrintLine()
			oSection6:Finish()

			aFill(aDados6,nil)

		Next _nX
		//<< 7-Coordenadores
		//>> 10-Familias
		For _nX := 1 to Len(_aFamilia)

			aDados9[01]	:=	_aFamilia[_nX,01]  //Agrupamento
			aDados9[02]	:=	_aFamilia[_nX,02]  //Classe

			oSection9:Init()
			oSection9:PrintLine()
			oSection9:Finish()

			aFill(aDados9,nil)

		Next _nX
		//<< 10-Familias

		//>> 11-Grupos de Produtos
		DbSelectArea("SBM")
		DbSetOrder(1)
		DbGotop()

		While !EOF()

			aDados10[01]:= SBM->BM_GRUPO  		//Grupo
			aDados10[02]:= SBM->BM_DESC  	//Desc Grupo
			aDados10[03]:= "" 					//Agrupamento
			aDados10[04]:= "" 					//Classe

			oSection10:Init()
			oSection10:PrintLine()
			oSection10:Finish()

			aFill(aDados10,nil)

			DbSelectArea("SBM")
			DbSkip()

		End
		//<< 11-Grupos de Produtos

	EndIf
	//>> 13-Pesos
	For _nX := 1 to Len(_aPeso)

		aDados12[01]:=	_aPeso[_nx][01]	//Classe
		aDados12[02]:=	_aPeso[_nx][02] //Descri็ใo
		aDados12[03]:=	_aPeso[_nx][03] //Company
		aDados12[04]:=	_aPeso[_nx][04] //Filial
		aDados12[05]:=	_aPeso[_nx][05] //Core
		aDados12[06]:=	_aPeso[_nx][06] //Lan็amento
		aDados12[07]:=	0 //_aPeso[_nx][07] //Total

		oSection12:Init()
		oSection12:PrintLine()
		oSection12:Finish()

		aFill(aDados12,nil)

	Next _nX
	//<< 13-Pesos
	//>>5-Meta Vendedores
	MetVdAno(aDados4,oSection4)
	//<< 5-Meta Vendedores

	oReport:SkipLine()

Return oReport

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออปฑฑ
	ฑฑบPrograma  ณStQuery   บAutor  ณRichard N Cabral    บ Data ณ  28/11/17    บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
	ฑฑบDesc.     ณ Relatorio Variaveis de Comissoes - RH                       บฑฑ
	ฑฑบ          ณ                                                             บฑฑ
	ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                          บฑฑ
	ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	*-----------------------------*
Static Function StQuery()
	*-----------------------------*

	Local cQuery := ' '
	Local cDtIni := Substr(MV_PAR01,3,4)+"01"
	Local cDtFim := Substr(MV_PAR01,3,4)+Substr(MV_PAR01,1,2) //DtoS(LastDay(StoD(cDtIni)))

	cQuery := "	SELECT TMP.VENDEDOR, TMP.AGRUPAMENTO, SUM(TMP.LIQUIDO_NET) REALIZADO FROM (
	cQuery += " 	SELECT SA3.A3_COD AS VENDEDOR,
	//cQuery += "		SD2.D2_TOTAL - SD2.D2_VALICM - SD2.D2_VALIMP5 - SD2.D2_VALIMP6 - D2_DIFAL - D2_ICMSCOM AS LIQUIDO_NET,
	cQuery += "		(SD2.D2_TOTAL - SD2.D2_VALICM - SD2.D2_VALIMP5 - SD2.D2_VALIMP6 - D2_DIFAL - D2_ICMSCOM)/100*(100-Nvl(BONUS.PH6_PERC,0))   AS LIQUIDO_NET,
	cQuery += "		Sd2.R_E_C_N_O_ RECNO,
	cQuery += "       Nvl(BM_GRUPO, 'S/G')            AS GRUPO,
	cQuery += "   Nvl(Trim(TX5.X5_DESCRI), 'N/A') AS AGRUPAMENTO
	cQuery += "	FROM   SD2110 SD2
	cQuery += "		INNER JOIN(SELECT *
	cQuery += "					FROM   SA1110)SA1
	cQuery += "				ON SA1.D_E_L_E_T_ = ' '
	cQuery += "					AND A1_COD = D2_CLIENTE
	cQuery += "					AND A1_LOJA = D2_LOJA
	cQuery += "					AND SA1.A1_GRPVEN <> 'ST'
	cQuery += "					AND SA1.A1_GRPVEN <> 'SC'
	cQuery += "					AND SA1.A1_EST <> 'EX'
	cQuery += "		INNER JOIN(SELECT *
	cQuery += "					FROM   SF2110)SF2
	cQuery += "				ON SF2.D_E_L_E_T_ = ' '
	cQuery += "					AND F2_DOC = D2_DOC
	cQuery += "					AND F2_SERIE = D2_SERIE
	cQuery += "					AND F2_FILIAL = D2_FILIAL
	cQuery += "		INNER JOIN(SELECT *
	cQuery += "					FROM   SB1110)SB1
	cQuery += "				ON SB1.D_E_L_E_T_ = ' '
	cQuery += "					AND SB1.B1_COD = D2_COD
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   UDBP12.SB1030)TB1
	cQuery += "				ON TB1.D_E_L_E_T_ = ' '
	cQuery += "					AND TB1.B1_COD = D2_COD
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   SBM110)SBM
	cQuery += "				ON SBM.D_E_L_E_T_ = ' '
	cQuery += "					AND BM_GRUPO = SB1.B1_GRUPO
	cQuery += "					AND SBM.BM_XAGRUP <> ' '
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   SA3110)SA3
	cQuery += "				ON SA3.D_E_L_E_T_ = ' '
	cQuery += "					AND SA3.A3_COD = F2_VEND1
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   SA3110)TA3
	cQuery += "				ON TA3.D_E_L_E_T_ = ' '
	cQuery += "					AND TA3.A3_COD = SA3.A3_SUPER
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   SX5110)SX5
	cQuery += "				ON SX5.X5_TABELA = 'A2'
	cQuery += "					AND SX5.X5_CHAVE = SA1.A1_REGIAO
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   SX5110)TX5
	cQuery += "				ON Trim(TX5.X5_TABELA) = 'ZZ'
	cQuery += "					AND Trim(TX5.X5_CHAVE) = Trim(SBM.BM_XAGRUP)

	cQuery += "           LEFT JOIN (
	cQuery += "                      SELECT * FROM PH5110 PH5
	cQuery += "                        INNER JOIN PH6110 PH6
	cQuery += "                            ON PH6.PH6_FILIAL = PH5.PH5_FILIAL
	cQuery += "                                AND PH6.PH6_NUM = PH5.PH5_NUM
	cQuery += "                                AND PH6.PH6_ANO = '"+Substr(MV_PAR01,3,4)+"'
	cQuery += "                                AND Ph6.D_E_L_E_T_ = ' '
	cQuery += "                        AND PH5.D_E_L_E_T_ = ' '
	cQuery += "                     ) BONUS
	cQuery += "                     ON BONUS.PH5_CLIENT = D2_CLIENTE

	cQuery += "	WHERE  SD2.D_E_L_E_T_ = ' '
	cQuery += "		AND SD2.D2_CF IN( '5101', '5102', '5109', '5116','5117', '5118', '5119', '5122','5123', '5401', '5403', '5501','5502', '6101', '6102', '6107','6108', '6109', '6110', '6111','6114', '6116', '6117', '6118','6119', '6122', '6123', '6401','6403', '6501', '6502' )
	cQuery += "		AND Substr(D2_EMISSAO, 1, 6) BETWEEN '"+cDtIni+"' AND '"+cDtFim+"'

	cQuery += "	UNION

	cQuery += "	SELECT SA3.A3_COD                      AS VENDEDOR,
	//cQuery += "		SD2.D2_TOTAL - SD2.D2_VALICM - SD2.D2_VALIMP5 - SD2.D2_VALIMP6 - D2_DIFAL - D2_ICMSCOM AS LIQUIDO_NET,
	cQuery += "		(SD2.D2_TOTAL - SD2.D2_VALICM - SD2.D2_VALIMP5 - SD2.D2_VALIMP6 - D2_DIFAL - D2_ICMSCOM)/100*(100-Nvl(BONUS.PH6_PERC,0))   AS LIQUIDO_NET,
	cQuery += "		Sd2.R_E_C_N_O_ RECNO,
	cQuery += "       Nvl(BM_GRUPO, 'S/G')            AS GRUPO,
	cQuery += "   Nvl(Trim(TX5.X5_DESCRI), 'N/A') AS AGRUPAMENTO
	cQuery += "	FROM   UDBP12.SD2030 SD2
	cQuery += "		INNER JOIN(SELECT *
	cQuery += "					FROM   UDBP12.SA1030) SA1
	cQuery += "				ON SA1.D_E_L_E_T_ = ' '
	cQuery += "					AND A1_COD = D2_CLIENTE
	cQuery += "					AND A1_LOJA = D2_LOJA
	cQuery += "					AND SA1.A1_GRPVEN <> 'ST'
	cQuery += "					AND SA1.A1_GRPVEN <> 'SC'
	cQuery += "					AND SA1.A1_EST <> 'EX'
	cQuery += "		INNER JOIN(SELECT *
	cQuery += "					FROM   UDBP12.SF2030)SF2
	cQuery += "				ON SF2.D_E_L_E_T_ = ' '
	cQuery += "					AND F2_DOC = D2_DOC
	cQuery += "					AND F2_SERIE = D2_SERIE
	cQuery += "					AND F2_FILIAL = D2_FILIAL
	cQuery += "		INNER JOIN(SELECT *
	cQuery += "					FROM   SB1110)SB1
	cQuery += "				ON SB1.D_E_L_E_T_ = ' '
	cQuery += "					AND SB1.B1_COD = D2_COD
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   UDBP12.SB1030)TB1
	cQuery += "				ON TB1.D_E_L_E_T_ = ' '
	cQuery += "					AND TB1.B1_COD = D2_COD
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   SBM110)SBM
	cQuery += "				ON SBM.D_E_L_E_T_ = ' '
	cQuery += "					AND BM_GRUPO = SB1.B1_GRUPO
	cQuery += "					AND SBM.BM_XAGRUP <> ' '
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   UDBP12.SA3030)SA3
	cQuery += "				ON SA3.D_E_L_E_T_ = ' '
	cQuery += "					AND SA3.A3_COD = F2_VEND1
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   UDBP12.SA3030)TA3
	cQuery += "				ON TA3.D_E_L_E_T_ = ' '
	cQuery += "					AND TA3.A3_COD = SA3.A3_SUPER
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   UDBP12.SX5030)SX5
	cQuery += "				ON SX5.X5_TABELA = 'A2'
	cQuery += "					AND SX5.X5_CHAVE = SA1.A1_REGIAO
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   SX5110)TX5
	cQuery += "				ON Trim(TX5.X5_TABELA) = 'ZZ'
	cQuery += "					AND Trim(TX5.X5_CHAVE) = Trim(SBM.BM_XAGRUP)

	cQuery += "           LEFT JOIN (
	cQuery += "                      SELECT * FROM PH5110 PH5
	cQuery += "                        INNER JOIN PH6110 PH6
	cQuery += "                            ON PH6.PH6_FILIAL = PH5.PH5_FILIAL
	cQuery += "                                AND PH6.PH6_NUM = PH5.PH5_NUM
	cQuery += "                                AND PH6.PH6_ANO = '"+Substr(MV_PAR01,3,4)+"'
	cQuery += "                                AND Ph6.D_E_L_E_T_ = ' '
	cQuery += "                        AND PH5.D_E_L_E_T_ = ' '
	cQuery += "                     ) BONUS
	cQuery += "                     ON BONUS.PH5_CLIENT = D2_CLIENTE

	cQuery += "	WHERE  SD2.D_E_L_E_T_ = ' '
	cQuery += "		AND SD2.D2_CF IN( '5101', '5102', '5109', '5116','5117', '5118', '5119', '5122','5123', '5401', '5403', '5501','5502', '6101', '6102', '6107','6108', '6109', '6110', '6111','6114', '6116', '6117', '6118','6119', '6122', '6123', '6401','6403', '6501', '6502' )
	cQuery += "		AND Substr(D2_EMISSAO, 1, 6) BETWEEN '"+cDtIni+"' AND '"+cDtFim+"'
	cQuery += "		AND D2_FILIAL = '01'

	cQuery += "	UNION

	cQuery += "	SELECT SA3.A3_COD                      AS VENDEDOR,
	cQuery += "			( D1_TOTAL - SD1.D1_VALIMP5 - SD1.D1_VALIMP6 - SD1.D1_VALICM - D1_DIFAL ) * - 1 AS LIQUIDO_NET,
	cQuery += "			SD1.R_E_C_N_O_ RECNO,
	cQuery += "		       Nvl(BM_GRUPO, 'S/G')            AS GRUPO,
	cQuery += "		   Nvl(Trim(TX5.X5_DESCRI), 'N/A') AS AGRUPAMENTO
	cQuery += "	FROM   SD1110 SD1
	cQuery += "		INNER JOIN(SELECT *
	cQuery += "					FROM   SA1110)SA1
	cQuery += "				ON SA1.D_E_L_E_T_ = ' '
	cQuery += "					AND SA1.A1_COD = SD1.D1_FORNECE
	cQuery += "					AND SA1.A1_LOJA = SD1.D1_LOJA
	cQuery += "					AND SA1.A1_FILIAL = '  '
	cQuery += "		INNER JOIN(SELECT *
	cQuery += "					FROM   SF2110)SF2
	cQuery += "				ON SF2.D_E_L_E_T_ = ' '
	cQuery += "					AND SF2.F2_DOC = D1_NFORI
	cQuery += "					AND SF2.F2_SERIE = D1_SERIORI
	cQuery += "					AND SF2.F2_FILIAL = SD1.D1_FILIAL
	cQuery += "		INNER JOIN(SELECT *
	cQuery += "					FROM   SB1110)SB1
	cQuery += "				ON SB1.D_E_L_E_T_ = ' '
	cQuery += "					AND SB1.B1_COD = D1_COD
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   UDBP12.SB1030)TB1
	cQuery += "				ON TB1.D_E_L_E_T_ = ' '
	cQuery += "					AND TB1.B1_COD = D1_COD
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   SBM110)SBM
	cQuery += "				ON SBM.D_E_L_E_T_ = ' '
	cQuery += "					AND BM_GRUPO = SB1.B1_GRUPO
	cQuery += "					AND SBM.BM_XAGRUP <> ' '
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   SA3110)SA3
	cQuery += "				ON SA3.D_E_L_E_T_ = ' '
	cQuery += "					AND SA3.A3_COD = F2_VEND1
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   SA3110)TA3
	cQuery += "				ON TA3.D_E_L_E_T_ = ' '
	cQuery += "					AND TA3.A3_COD = SA3.A3_SUPER
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   SX5110)SX5
	cQuery += "				ON SX5.X5_TABELA = 'A2'
	cQuery += "					AND SX5.X5_CHAVE = SA1.A1_REGIAO
	cQuery += "		LEFT JOIN(SELECT *
	cQuery += "					FROM   SX5110)TX5
	cQuery += "				ON Trim(TX5.X5_TABELA) = 'ZZ'
	cQuery += "					AND Trim(TX5.X5_CHAVE) = Trim(SBM.BM_XAGRUP)
	cQuery += "	WHERE  SD1.D_E_L_E_T_ = ' '
	cQuery += "		AND SD1.D1_CF IN ( '1201', '1202', '1410', '1411','2201', '2202', '2410', '2411','2203', '1918', '2918', '2204' )
	cQuery += "		AND Substr(SD1.D1_DTDIGIT, 1, 6) BETWEEN '"+cDtIni+"' AND '"+cDtFim+"'
	cQuery += "		AND SD1.D1_TIPO = 'D'

	cQuery += "	UNION

	cQuery += "	SELECT SA3.A3_COD                      AS VENDEDOR,
	cQuery += "		( D1_TOTAL - SD1.D1_VALIMP5 - SD1.D1_VALIMP6 - SD1.D1_VALICM - D1_DIFAL ) * - 1 AS LIQUIDO_NET,
	cQuery += "		SD1.R_E_C_N_O_ RECNO,
	cQuery += "       Nvl(BM_GRUPO, 'S/G')            AS GRUPO,
	cQuery += "   Nvl(Trim(TX5.X5_DESCRI), 'N/A') AS AGRUPAMENTO
	cQuery += "	FROM   UDBP12.SD1030 SD1
	cQuery += "	INNER JOIN(SELECT *
	cQuery += "				FROM   UDBP12.SA1030)SA1
	cQuery += "			ON SA1.D_E_L_E_T_ = ' '
	cQuery += "				AND SA1.A1_COD = SD1.D1_FORNECE
	cQuery += "				AND SA1.A1_LOJA = SD1.D1_LOJA
	cQuery += "				AND SA1.A1_FILIAL = '  '
	cQuery += "	INNER JOIN(SELECT *
	cQuery += "				FROM   UDBP12.SF2030)SF2
	cQuery += "			ON SF2.D_E_L_E_T_ = ' '
	cQuery += "				AND SF2.F2_DOC = D1_NFORI
	cQuery += "				AND SF2.F2_SERIE = D1_SERIORI
	cQuery += "				AND SF2.F2_FILIAL = SD1.D1_FILIAL
	cQuery += "	INNER JOIN(SELECT *
	cQuery += "				FROM   SB1110)SB1
	cQuery += "			ON SB1.D_E_L_E_T_ = ' '
	cQuery += "				AND SB1.B1_COD = D1_COD
	cQuery += "	LEFT JOIN(SELECT *
	cQuery += "				FROM   UDBP12.SB1030)TB1
	cQuery += "			ON TB1.D_E_L_E_T_ = ' '
	cQuery += "				AND TB1.B1_COD = D1_COD
	cQuery += "	LEFT JOIN(SELECT *
	cQuery += "				FROM   SBM110)SBM
	cQuery += "			ON SBM.D_E_L_E_T_ = ' '
	cQuery += "				AND BM_GRUPO = SB1.B1_GRUPO
	cQuery += "				AND SBM.BM_XAGRUP <> ' '
	cQuery += "	LEFT JOIN(SELECT *
	cQuery += "				FROM   SA3110)SA3
	cQuery += "			ON SA3.D_E_L_E_T_ = ' '
	cQuery += "				AND SA3.A3_COD = F2_VEND1
	cQuery += "	LEFT JOIN(SELECT *
	cQuery += "				FROM   SA3110)TA3
	cQuery += "			ON TA3.D_E_L_E_T_ = ' '
	cQuery += "				AND TA3.A3_COD = SA3.A3_SUPER
	cQuery += "	LEFT JOIN(SELECT *
	cQuery += "				FROM   SX5110)SX5
	cQuery += "			ON SX5.X5_TABELA = 'A2'
	cQuery += "				AND SX5.X5_CHAVE = SA1.A1_REGIAO
	cQuery += "	LEFT JOIN(SELECT *
	cQuery += "				FROM   SX5110)TX5
	cQuery += "			ON Trim(TX5.X5_TABELA) = 'ZZ'
	cQuery += "				AND Trim(TX5.X5_CHAVE) = Trim(SBM.BM_XAGRUP)
	cQuery += "	WHERE  SD1.D_E_L_E_T_ = ' '
	cQuery += "	AND SD1.D1_CF IN ( '1201', '1202', '1410', '1411','2201', '2202', '2410', '2411','2203', '1918', '2918', '2204' )
	cQuery += "	AND SD1.D1_FILIAL = '01'
	cQuery += "	AND Substr(SD1.D1_DTDIGIT, 1, 6) BETWEEN '"+cDtIni+"' AND '"+cDtFim+"'
	cQuery += "	AND SD1.D1_TIPO = 'D'
	cQuery += "	) TMP
	//cQuery += " WHERE TMP.VENDEDOR = 'I08608'
	cQuery += "	GROUP BY TMP.VENDEDOR,TMP.AGRUPAMENTO

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

Static Function ApuraMeta(cVendMeta)

	Local _cQry		:= ""
	Local cDtIni	:= Substr(MV_PAR01,3,4)+"01"
	Local cDtFim	:= DtoS(LastDay(StoD(Substr(MV_PAR01,3,4)+Substr(MV_PAR01,1,2)+"01"))) //DtoS(LastDay(StoD(cDtIni)))

	_cQry := " SELECT TMP.AGRUPAMENTO,
	_cQry += "    SUM(ZZD_VALOR) META
	_cQry += " FROM   (SELECT Nvl(BM_GRUPO, 'S/G')            AS GRUPO,
	_cQry += "            Nvl(Trim(TX5.X5_DESCRI), 'N/A') AS AGRUPAMENTO,
	_cQry += "            ZZD_VALOR
	_cQry += "     FROM   ZZD110 ZZD
	_cQry += "            LEFT JOIN(SELECT *
	_cQry += "                      FROM   SBM110)SBM
	_cQry += "                   ON SBM.D_E_L_E_T_ = ' '
	_cQry += "                      AND BM_GRUPO = ZZD.ZZD_GRUPO
	_cQry += "                      AND SBM.BM_XAGRUP <> ' '
	_cQry += "            LEFT JOIN(SELECT *
	_cQry += "                      FROM   SX5110)TX5
	_cQry += "                   ON Trim(TX5.X5_TABELA) = 'ZZ'
	_cQry += "                      AND Trim(TX5.X5_CHAVE) = Trim(SBM.BM_XAGRUP)
	_cQry += "     WHERE  ZZD_MES BETWEEN '"+ Substr(cDtIni,5,2)+"' AND '"+Substr(cDtFim,5,2)+"'
	_cQry += "            AND ZZD_ANO = '"+Substr(cDtFim,1,4)+"'
	_cQry += "            AND ZZD_VEND = '"+cVendMeta+"'
	_cQry += "            AND ZZD.D_E_L_E_T_ = ' ')TMP
	_cQry += " GROUP  BY TMP.AGRUPAMENTO

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQry),"TRB")

	IF cVendMeta = 	"E00413"
		aqui := 0
	ENDIF
	nPosVen := aScan(aVend,{|x| x[2] = cVendMeta })
	While !("TRB")->(Eof())	

		nPosFamilia := aScan(_aFamilia,{|x| x[1] = Alltrim(TRB->AGRUPAMENTO)})
		If nPosFamilia > 0
			If _aFamilia[nPosFamilia][02] $ "CORE"
				aVend[nPosVen,7,14] 	+= TRB->META
			ElseIf _aFamilia[nPosFamilia][02] $ "LCTO"
				aVend[nPosVen,7,16] 	+= TRB->META
			EndIf
		EndIf

		If nPosVen > 0
				aVend[nPosVen,7,7] += TRB->META
				_aCompany[01,02] += TRB->META

				nPosSuper := aScan(_aEquipe,{|x| x[1] = aVend[nPosVen,5]})
				If nPosSuper > 0
					_aEquipe[nPosSuper,02] += TRB->META
					nPosFamilia := aScan(_aFamilia,{|x| x[1] = Alltrim(TRB->AGRUPAMENTO)})
					If nPosFamilia > 0
						If _aFamilia[nPosFamilia][02] $ "CORE"
							_aEquipe[nPosSuper,04] 	+= TRB->META
						ElseIf _aFamilia[nPosFamilia][02] $ "LCTO"
							_aEquipe[nPosSuper,06]	+= TRB->META
						EndIf
					EndIf

				EndIf
		EndIf
		("TRB")->(DbSkip())

	End

Return

Static Function MetVdAno(aDados4,oSection4)

	Local _cQry		:= ""

	_cQry += " SELECT * FROM (
	_cQry += " SELECT ZZD_VEND,ZZD_MES, nvl(SUM(ZZD_VALOR),0) ZZD_VALOR FROM "+RetSqlName("ZZD")
	_cQry += " WHERE ZZD_ANO = '"+Substr(MV_PAR01,3,4)+"'
	_cQry += " AND D_E_L_E_T_ = ' '
	_cQry += " GROUP BY ZZD_VEND,ZZD_MES
	_cQry += " )
	_cQry += " PIVOT( Sum(nvl(ZZD_VALOR,0)) FOR ZZD_MES IN('01' AS JANEIRO,'02' AS FEVEREIRO,'03' AS MARCO,'04' AS ABRIL,'05' AS MAIO,'06' AS JUNHO,'07' AS JULHO,'08' AS AGOSTO,'09' AS SETEMBRO ,'10' AS OUTUBRO,'11' AS NOVEMBRO,'12' AS DEZEMBRO ) )
	_cQry += "ORDER BY ZZD_VEND

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQry),"TRB")

	While !EOF()

		aDados4[01]:=	Posicione("SA3",1,xFilial("SA3")+TRB->ZZD_VEND,"A3_SUPER")
		aDados4[02]:=	Posicione("SA3",1,xFilial("SA3")+aDados4[01],"A3_NOME")
		aDados4[03]:=	TRB->ZZD_VEND
		aDados4[04]:=	Posicione("SA3",1,xFilial("SA3")+TRB->ZZD_VEND,"A3_NOME")
		aDados4[05]:=	TRB->JANEIRO
		aDados4[06]:=	TRB->FEVEREIRO
		aDados4[07]:=	TRB->MARCO
		aDados4[08]:=	TRB->ABRIL
		aDados4[09]:=	TRB->MAIO
		aDados4[10]:=	TRB->JUNHO
		aDados4[11]:=	TRB->JULHO
		aDados4[12]:=	TRB->AGOSTO
		aDados4[13]:=	TRB->SETEMBRO
		aDados4[14]:=	TRB->OUTUBRO
		aDados4[15]:=	TRB->NOVEMBRO
		aDados4[16]:=	TRB->DEZEMBRO

		oSection4:Init()
		oSection4:PrintLine()
		oSection4:Finish()

		aFill(aDados4,nil)

		("TRB")->(DbSkip())

	End

Return