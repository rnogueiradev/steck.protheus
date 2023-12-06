#INCLUDE "PROTHEUS.CH"
#INCLUDE "MATRAR1.CH"
/*/                                                                                                          
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                       
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                            
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MATRAR1   ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 12.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³SubDiario de IVA Compras.                                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Paraguai                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³22/10/2013³ ANTONIO TREJO ³ THIMZY: Agreger el campo A2_AFIP (Tipo Doc)³±±
±±³          ³               ³ y modificar la etiqueta de A2_CGC.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ARFIS001()

Local cPerg		:= "MTRAR1"

Private oReport
Private cPict	:= "@E 999999,999.99"
Private cPictNF	:= "@R 9999-999999999"
Private nTam	:= 13
Private nTamNF	:= 18

Private dEntrada	:= Ctod("")
Private cTipo		:= ""
Private cSerie		:= ""
Private cNFiscal	:= ""
Private cRazSoc		:= ""
Private cCNPJ		:= ""
Private cAFIP		:= ""

//Totalizador
Private nTNETO		:= 0
Private nTIVARG		:= 0
Private nTIVASERV	:= 0
Private nTIVABSCAP	:= 0
Private nTIVARE		:= 0
Private nTPERCIVA	:= 0
Private nTPERCIIBB	:= 0
Private nTPERCGAN	:= 0
Private nTRETIVA	:= 0
Private nTRETIIBB	:= 0
Private nTEXENTO	:= 0
Private nTTOTAL		:= 0
Private NTIVARNI    := 0

If FindFunction("TRepInUse") .And. TRepInUse()
  	AjustaSX1()
	Pergunte(cPerg,.F.)
	oReport:=ReportDef()
	oReport:PrintDialog()
Else
	xMatrAr1R3()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 12.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatorio                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oSecao1, oSecao2
Local cReport	:= "MATRAR1"
Local cPerg    	:= "MTRAR1"
Local cTitulo	:= OemToAnsi("Emissao do Livro Fiscal de Compras")	//"Emissao do Livro Fiscal de Compras"
Local cDesc		:= OemToAnsi("Este programa tem como objetivo imprimir o Livro Fiscal de Compras.")	//"Este programa tem como objetivo imprimir o Livro Fiscal de Compras."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New(cReport,cTitulo,cPerg,{|oReport| ReportPrint(oReport)},cDesc)
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)
oReport:PageTotalInLine(.F.)
Pergunte(oReport:uParam,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSecao1:=TRSection():New(oReport,OemToAnsi(STR0064),{"SF3"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oSecao1:SetPageBreak(.T.)
TRCell():New(oSecao1,"F3_ENTRADA","SF3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"F3_ESPECIE","SF3",OemToAnsi(STR0038),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"F3_SERIE","",OemToAnsi(STR0067),/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"F3_NFISCAL","SF3",/*Titulo*/,cPictNF,nTamNF,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"A2_NOME",,OemToAnsi(STR0039),/*Picture*/,18,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSecao1,"A2_AFIP",,/*Titulo*/,/*Picture*/,8,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oSecao1,"A2_CGC",,/*Titulo*/,/*Picture*/,14,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"NETO","",OemToAnsi(STR0040),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"IVARG","",OemToAnsi(STR0041),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"IVARNI","",OemToAnsi(STR0042),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"IVASERV","",OemToAnsi(STR0043),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"IVABSCAP","",OemToAnsi(STR0044),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"IVARE","",OemToAnsi(STR0045),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"PERCIVA","",OemToAnsi(STR0046),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"PERCIIBB","",OemToAnsi(STR0047),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"PERCGAN","",OemToAnsi(STR0048),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"RETIVA","",OemToAnsi(STR0049),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"RETIIBB","",OemToAnsi(STR0050),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"EXENTO","",OemToAnsi(STR0051),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"TOTAL","",OemToAnsi(STR0052),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)

oSecao1:Cell("IVARG"):SetHeaderAlign("RIGHT")
oSecao1:Cell("IVARNI"):SetHeaderAlign("RIGHT")
oSecao1:Cell("IVASERV"):SetHeaderAlign("RIGHT")
oSecao1:Cell("IVABSCAP"):SetHeaderAlign("RIGHT")
oSecao1:Cell("IVARE"):SetHeaderAlign("RIGHT")
oSecao1:Cell("PERCIVA"):SetHeaderAlign("RIGHT")
oSecao1:Cell("PERCIIBB"):SetHeaderAlign("RIGHT")
oSecao1:Cell("PERCGAN"):SetHeaderAlign("RIGHT")
oSecao1:Cell("RETIVA"):SetHeaderAlign("RIGHT")
oSecao1:Cell("RETIIBB"):SetHeaderAlign("RIGHT")
oSecao1:Cell("EXENTO"):SetHeaderAlign("RIGHT")
oSecao1:Cell("TOTAL"):SetHeaderAlign("RIGHT")                                                


//Totalizador
oSecao2:=TRSection():New(oReport,OemToAnsi(STR0065),{"SF3"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oSecao2:SetHeaderSection(.F.)
oSecao2:SetNoFilter("SF3")
oSecao2:SetEdit(.F.)
TRCell():New(oSecao2,"F3_ENTRADA","SF3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"F3_ESPECIE","SF3",OemToAnsi(STR0038),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"F3_SERIE","SF3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"F3_NFISCAL","SF3",/*Titulo*/,cPictNF,nTamNF,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"A2_NOME",,OemToAnsi(STR0039),/*Picture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"A2_AFIP",,"Tipo Doc",/*Picture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"A2_CGC",,/*Titulo*/,/*Picture*/,14,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TNETO","",OemToAnsi(STR0040),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TIVARG","",OemToAnsi(STR0041),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TIVARNI","",OemToAnsi(STR0042),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TIVASERV","",OemToAnsi(STR0043),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TIVABSCAP","",OemToAnsi(STR0044),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TIVARE","",OemToAnsi(STR0045),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TPERCIVA","",OemToAnsi(STR0046),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TPERCIIBB","",OemToAnsi(STR0047),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TPERCGAN","",OemToAnsi(STR0048),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TRETIVA","",OemToAnsi(STR0049),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TRETIIBB","",OemToAnsi(STR0050),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TEXENTO","",OemToAnsi(STR0051),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TTOTAL","",OemToAnsi(STR0052),cPict,nTam,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 12.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                            ³±±
±±³          ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local lRelease4		:= .T.
Local cCondicao		:= ""
Local cAliasSF3		:= "SF3"
Local cCabec		:= ""
Local nSigno		:= 0
Local nTipo			:= 0
Local nQ			:= 0
Local cNotaAnt  	:= ""
Local nCont 		:= 1
Local nValImp  		:= 0
Local nValMerc 		:= 0
Local nValBrut 		:= 0   
Local dEntAnt 		:= Ctod("")
Local lImpTDia 		:= .F.
Local nMoeda 		:= 0
Local nTaxa 		:= 0
Local nDecs 		:= 0
Local dDigita 		:= Ctod("//")
Local nLinha		:= 0
Local nNETO			:= 0
Local nIVARG		:= 0
Local nIVARNI		:= 0
Local nIVASERV		:= 0
Local nIVABSCAP		:= 0
Local nIVARE		:= 0
Local nPERCIVA		:= 0
Local nPERCIIBB		:= 0
Local nPERCGAN		:= 0
Local nRETIVA		:= 0
Local nRETIIBB		:= 0
Local nEXENTO		:= 0
Local nTOTAL		:= 0
Local nLastRec		:= 0

// VARIAVEIS UTILIZADAS NO RESUMO
Private lTipos 		:= SX5->(dbSeek(xFilial("SX5")+"SF"))
Private aTipos   	:= {}
Private aTotCFis    := {}
Private aProvincia  := {}
Private lProvincia  := SX5->(dbSeek(xFilial("SX5")+"12"))
Private aTotProv  	:= {}
Private aProduto    := {}
Private lProduto    := SX5->(dbSeek(xFilial("SX5")+"02"))
Private aTotTpProd	:= {}

// VARIAVEIS COM OS SUB TOTAIS DOS CAMPOS DE IMPOSTOS, SEPARADOS POR TIPO DE DOCUMENTO
// nF=FATURA  nD=NOTA DE DEBITO   nC=NOTA DE CREDITO
Private nFVALMERC :=0, nDVALMERC 	:=0, nCVALMERC	:=0
Private nFValImp1 :=0, nDValImp1	:=0, nCValImp1	:=0
Private nFValImp2 :=0, nDValImp2	:=0, nCValImp2	:=0
Private nFValImp3 :=0, nDValImp3	:=0, nCValImp3	:=0
Private nFValImp7 :=0, nDValImp7	:=0, nCValImp7	:=0
Private nFValImp8 :=0, nDValImp8	:=0, nCValImp8	:=0
Private nFValImp4 :=0, nDValImp4	:=0, nCValImp4	:=0
Private nFValImp5 :=0, nDValImp5	:=0, nCValImp5	:=0
Private nFValImp9 :=0, nDValImp9	:=0, nCValImp9	:=0
Private nFRetIVA  :=0, nDRetIVA		:=0, nCRetIVA	:=0
Private nFRetIBB  :=0, nDRetIBB		:=0, nCRetIBB	:=0
Private nFExento  :=0, nDExento		:=0, nCExento	:=0
Private nFImpTotal:=0, nDImpTotal	:=0, nCImpTotal	:=0

// VARIAVEIS COM OS TOTAIS DOS CAMPOS DE IMPOSTOS, SEPARADOS POR TIPO DE DOCUMENTO
// nTF=FATURA  nTD=NOTA DE DEBITO   nTC=NOTA DE CREDITO
Private nTFVALMERC :=0, nTDVALMERC :=0, nTCVALMERC	:=0
Private nTFValImp1 :=0, nTDValImp1 :=0, nTCValImp1	:=0
Private nTFValImp2 :=0, nTDValImp2 :=0, nTCValImp2	:=0
Private nTFValImp3 :=0, nTDValImp3 :=0, nTCValImp3	:=0
Private nTFValImp7 :=0, nTDValImp7 :=0, nTCValImp7	:=0
Private nTFValImp8 :=0, nTDValImp8 :=0, nTCValImp8	:=0
Private nTFValImp4 :=0, nTDValImp4 :=0, nTCValImp4	:=0
Private nTFValImp5 :=0, nTDValImp5 :=0, nTCValImp5	:=0
Private nTFValImp9 :=0, nTDValImp9 :=0, nTCValImp9	:=0
Private nTFRetIVA  :=0, nTDRetIVA  :=0, nTCRetIVA	:=0
Private nTFRetIBB  :=0, nTDRetIBB  :=0, nTCRetIBB	:=0
Private nTFExento  :=0, nTDExento  :=0, nTCExento	:=0
Private nTFImpTotal:=0, nTDImpTotal:=0, nTCImpTotal	:=0

If lTipos   // Verifica se existe a Tabela SF(Tabela de Agentes Fiscais) no SX5 e monta o array com todas as chaves desse grupo.
	SX5->(dbSeek(xFilial("SX5")+"SF"))
	While !SX5->(Eof()) .And. SX5->X5_TABELA == "SF"
		Aadd(aTipos,{SX5->X5_CHAVE,Alltrim(x5DESCri())})
		SX5->(dbSkip())
	Enddo
	Aadd(aTipos,{"  ",OemToAnsi(STR0006)}) //"Tipo no Reg."
	For nQ	:=	1 To Len(aTipos)
		Aadd(aTotCFis,{0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00})
	Next
Endif

If lProvincia  // Verifica se existe a Tabela 12(Tabela de Zonas Fiscais) no SX5 e monta o array com todas as chaves desse grupo.
	SX5->(dbSeek(xFilial("SX5")+"12"))
	While !SX5->(Eof()) .And. SX5->X5_TABELA == "12"
		Aadd(aProvincia,{SX5->X5_CHAVE,Alltrim(x5DESCri())})
		SX5->(dbSkip())
	Enddo
	For nQ	:=	1 To Len(aProvincia)
		Aadd(aTotProv,{0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00})
	Next
Endif

If lProduto  // Verifica se existe a Tabela 02(Tabela de Tipos de Materiais) no SX5 e monta o array com todas as chaves desse grupo.
	SX5->(dbSeek(xFilial("SX5")+"02"))
	While !SX5->(Eof()) .And. SX5->X5_TABELA == "02"
		Aadd(aProduto,{SX5->X5_CHAVE,Alltrim(x5DESCri())})
		SX5->(dbSkip())
	Enddo
	For nQ	:=	1 To Len(aProduto)
		Aadd(aTotTPProd,{0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00})
	Next
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Desabilita as celulas da Secao 2                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CellDisable()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 1 - Detalhe                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):Cell("F3_ENTRADA"):SetBlock({|| dEntrada})
oReport:Section(1):Cell("F3_ESPECIE"):SetBlock({|| cTipo})
oReport:Section(1):Cell("F3_SERIE"):SetBlock({|| cSerie})
oReport:Section(1):Cell("F3_NFISCAL"):SetBlock({|| cNFiscal})
oReport:Section(1):Cell("A2_NOME"):SetBlock({|| cRazSoc})
oReport:Section(1):Cell("A2_AFIP"):SetBlock({|| cAfip})
oReport:Section(1):Cell("A2_CGC"):SetBlock({|| cCNPJ})
oReport:Section(1):Cell("NETO"):SetBlock({|| nNETO})
oReport:Section(1):Cell("IVARG"):SetBlock({|| nIVARG})
oReport:Section(1):Cell("IVARNI"):SetBlock({|| nIVARNI})
oReport:Section(1):Cell("IVASERV"):SetBlock({|| nIVASERV})
oReport:Section(1):Cell("IVABSCAP"):SetBlock({|| nIVABSCAP})
oReport:Section(1):Cell("IVARE"):SetBlock({|| nIVARE})
oReport:Section(1):Cell("PERCIVA"):SetBlock({|| nPERCIVA})
oReport:Section(1):Cell("PERCIIBB"):SetBlock({|| nPERCIIBB})
oReport:Section(1):Cell("PERCGAN"):SetBlock({|| nPERCGAN})
oReport:Section(1):Cell("RETIVA"):SetBlock({|| nRETIVA})
oReport:Section(1):Cell("RETIIBB"):SetBlock({|| nRETIIBB})
oReport:Section(1):Cell("EXENTO"):SetBlock({|| nEXENTO})
oReport:Section(1):Cell("TOTAL"):SetBlock({|| nTOTAL})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 2 - Totalizador                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(2):Cell("F3_ENTRADA"):SetBlock({|| dEntrada})
oReport:Section(2):Cell("F3_ESPECIE"):SetBlock({|| cTipo})
oReport:Section(2):Cell("F3_SERIE"):SetBlock({|| cSerie})
oReport:Section(2):Cell("F3_NFISCAL"):SetBlock({|| cNFiscal})
oReport:Section(2):Cell("A2_NOME"):SetBlock({|| cRazSoc})  
oReport:Section(1):Cell("A2_AFIP"):SetBlock({|| cAfip})
oReport:Section(2):Cell("A2_CGC"):SetBlock({|| cCNPJ})
oReport:Section(2):Cell("TNETO"):SetBlock({|| nTNETO})
oReport:Section(2):Cell("TIVARG"):SetBlock({|| nTIVARG})
oReport:Section(2):Cell("TIVASERV"):SetBlock({|| nTIVASERV})
oReport:Section(2):Cell("TIVABSCAP"):SetBlock({|| nTIVABSCAP})
oReport:Section(2):Cell("TIVARE"):SetBlock({|| nTIVARE})
oReport:Section(2):Cell("TPERCIVA"):SetBlock({|| nTPERCIVA})
oReport:Section(2):Cell("TPERCIIBB"):SetBlock({|| nTPERCIIBB})
oReport:Section(2):Cell("TPERCGAN"):SetBlock({|| nTPERCGAN})
oReport:Section(2):Cell("TRETIVA"):SetBlock({|| nTRETIVA})
oReport:Section(2):Cell("TRETIIBB"):SetBlock({|| nTRETIIBB})
oReport:Section(2):Cell("TEXENTO"):SetBlock({|| nTEXENTO})
oReport:Section(2):Cell("TTOTAL"):SetBlock({|| nTTOTAL})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Altera o titulo para impressao                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCabec := OemToAnsi(STR0035)+" - "+OemToAnsi(STR0036)+DtoC(mv_par01)+OemToAnsi(STR0037)+Dtoc(mv_par02)
oReport:SetTitle(cCabec)
oReport:SetPageNumber(MV_PAR07)
oReport:SetOnPageNumber({|| If(oReport:Page() > MV_PAR08,oReport:SetPageNumber(MV_PAR09),"")})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatorio                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF3")
dbSetOrder(1)

#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)

	cCondicao := "%"
	cCondicao += "F3_ESPECIE IN ('NF','NDP','NCP') "
	If mv_par03 == 1
		cCondicao += "AND F3_DTCANC = ' ' "		//Ativos
	ElseIf mv_par03 == 2
		cCondicao += "AND F3_DTCANC <> ' ' "	//Cancelados
	EndIf
	cCondicao += "%"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):BeginQuery()	
	
	cAliasSF3 := GetNextAlias()

	BeginSql Alias cAliasSF3
		SELECT SF3.*
		FROM %table:SF3% SF3
		WHERE F3_FILIAL = %Exp:mv_par05% AND 
			F3_ENTRADA	>=	%Exp:mv_par01% AND 
			F3_ENTRADA	<=	%Exp:mv_par02% AND 
			F3_TIPOMOV	= 'C' AND
			%Exp:cCondicao% AND
			SF3.%NotDel% 
		ORDER BY %Order:SF3%
	EndSql 

	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
		
#ELSE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeAdvplExpr(oReport:uParam)

	cCondicao := "F3_FILIAL == '"+mv_par05+"' .And. "
	cCondicao += "Dtos(F3_ENTRADA) >= '"+Dtos(mv_par01)+"' .And. "
	cCondicao += "Dtos(F3_ENTRADA) <= '"+Dtos(mv_par02)+"' .And. "

	If mv_par03 == 1		//Ativos
		cCondicao += "Empty(F3_DTCANC) .And. "
	ElseIf mv_par03 == 2	//Cancelados
		cCondicao += "!Empty(F3_DTCANC) .And. "
	EndIf

	cCondicao += "F3_TIPOMOV == 'C' .And. Alltrim(F3_ESPECIE) $ 'NF|NDP|NCP'"

	oReport:Section(1):SetFilter(cCondicao,IndexKey())
	
#ENDIF		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatorio                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea((cAliasSF3))
dbGoTop()
nLastRec := (cAliasSF3)->(LastRec())
oReport:SetMeter(nLastRec)
oReport:Section(1):Init()
                                                       
While !Eof()
	
	oReport:IncMeter()
	
	SA2->( dbSetOrder(1) )
	If SA2->( dbSeek( xFilial("SA2")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA ) )
		cRazSoc	:= SA2->A2_NOME
		cCNPJ	:= SA2->A2_CGC 
		cAFIP   := Iif(Empty(SA2->A2_AFIP),"80",STRZERO(VAL(SA2->A2_AFIP),2))        
	Else
		cRazSoc	:= ""
		cCNPJ	:= ""    
		cAFIP   := ""
	Endif
	
	If Alltrim((cAliasSF3)->F3_ESPECIE) == "NCP"
		nSigno	:=-1
	Else
		nSigno	:= 1
	Endif
	
	If ( (cAliasSF3)->F3_ENTRADA <> dEntAnt )
		If mv_par04 == 1 .And. nCont > 1
			RaR1TotDia(lRelease4)  //Imprime o sub total do dia
		EndIf
		dEntrada	:= (cAliasSF3)->F3_ENTRADA
		dEntAnt		:= (cAliasSF3)->F3_ENTRADA
		oReport:SkipLine()
		oReport:Section(1):Cell("F3_ENTRADA"):Show()
	Else
		oReport:Section(1):Cell("F3_ENTRADA"):Hide()
	EndIf
	nCont ++
	
	If (cAliasSF3)->F3_TIPO+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA # cNotaAnt
		cTipo		:= (cAliasSF3)->F3_ESPECIE
		cSerie		:= (cAliasSF3)->F3_SERIE
		cNFiscal	:= (cAliasSF3)->F3_NFISCAL
		oReport:Section(1):Cell("F3_ESPECIE"):Show()
		oReport:Section(1):Cell("F3_SERIE"):Show()
		oReport:Section(1):Cell("F3_NFISCAL"):Show()
	Else
		oReport:Section(1):Cell("F3_ESPECIE"):Hide()
		oReport:Section(1):Cell("F3_SERIE"):Hide()
		oReport:Section(1):Cell("F3_NFISCAL"):Hide()
	Endif
	
	//Verifica se a NF foi Anulada/Cancelada
	If !Empty((cAliasSF3)->F3_DTCANC)
		cRazSoc		:= OemToAnsi(STR0059)   //"C A N C E L A D A"
		nNETO		:= 0
		nIVARG		:= 0
	    nIVARNI		:= 0
		nIVASERV	:= 0
		nIVABSCAP	:= 0
		nIVARE		:= 0
		nPERCIVA	:= 0
		nPERCIIBB	:= 0
		nPERCGAN	:= 0
		nRETIVA 	:= 0
		nRETIIBB 	:= 0
		nEXENTO		:= 0
		nTOTAL		:= 0
		oReport:Section(1):PrintLine()		//Imprime a linha		
	Else
		If ( Alltrim((cAliasSF3)->F3_ESPECIE)=="NCP" )
			SF2->( dbSetOrder(1) )
			If SF2->( dbSeek( xFilial("SF2")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA ) )
				nMoeda	:= SF2->F2_MOEDA
				nTaxa 	:= SF2->F2_TXMOEDA
				nDecs 	:= MsDecimais(nMoeda)
				dDigita	:= SF2->F2_EMISSAO
			Endif
		Else
			SF1->( dbSetOrder(1) )
			If SF1->( dbSeek( xFilial("SF1")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA ) )
				nMoeda	:= SF1->F1_MOEDA
				nTaxa 	:= SF1->F1_TXMOEDA
				nDecs 	:= MsDecimais(nMoeda)
				dDigita	:= SF1->F1_DTDIGIT
			Endif
		EndIf

		nValMerc 	:= (cAliasSF3)->F3_VALMERC - (cAliasSF3)->F3_EXENTAS
		nValBrut 	:= (cAliasSF3)->F3_VALCONT
	
		nNETO		:= (nValMerc * nSigno)
		nIVARG		:= ((cAliasSF3)->F3_VALIMP1 * nSigno)
		nIVARNI		:= ((cAliasSF3)->F3_VALIMP2 * nSigno)
		nIVASERV	:= ((cAliasSF3)->F3_VALIMP3 * nSigno)
		nIVABSCAP	:= ((cAliasSF3)->F3_VALIMP7 * nSigno)
		nIVARE		:= ((cAliasSF3)->F3_VALIMP8 * nSigno)
		nPERCIVA	:= ((cAliasSF3)->F3_VALIMP4 * nSigno)
		nPERCIIBB	:= (((cAliasSF3)->F3_VALIMP5 + (cAliasSF3)->F3_VALIMP6) * nSigno)
		nPERCGAN	:= ((cAliasSF3)->F3_VALIMP9 * nSigno)

		// Verifica se existem Retencoes para IVA e INGRESSOS BRUTOS
		SFE->( dbSetOrder(4) )
		IF SFE->( dbSeek( xFilial("SFE")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+"I" ) )
			nRETIVA := SFE->FE_RETENC
		Else
			nRETIVA := 0
		EndIf
		
		SFE->( dbSetOrder(4) )
		IF SFE->( dbSeek( xFilial("SFE")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+"B" ) )
			nRETIIBB := SFE->FE_RETENC
		Else
			nRETIIBB := 0
		EndIf
		
		nEXENTO	:= ((cAliasSF3)->F3_EXENTAS * nSigno)
		nTOTAL	:= (nValBrut * nSigno)
		
		oReport:Section(1):PrintLine()		//Imprime a linha
		
		If ( Alltrim((cAliasSF3)->F3_ESPECIE) == "NCP" ) //Acumula valores referente a Notas de Credito
			nCValMerc		+= (nValMerc				 * nSigno)
			nTCVALMERC      += (nValMerc				 * nSigno)
			nCValImp1       += ((cAliasSF3)->F3_VALIMP1  * nSigno)
			nTCValImp1      += ((cAliasSF3)->F3_VALIMP1  * nSigno)
			nCValImp2       += ((cAliasSF3)->F3_VALIMP2  * nSigno)
			nTCValImp2      += ((cAliasSF3)->F3_VALIMP2  * nSigno)
			nCValImp3       += ((cAliasSF3)->F3_VALIMP3  * nSigno)
			nTCValImp3      += ((cAliasSF3)->F3_VALIMP3  * nSigno)
			nCValImp7       += ((cAliasSF3)->F3_VALIMP7  * nSigno)
			nTCValImp7      += ((cAliasSF3)->F3_VALIMP7  * nSigno)
			nCValImp8       += ((cAliasSF3)->F3_VALIMP8  * nSigno)
			nTCValImp8      += ((cAliasSF3)->F3_VALIMP8  * nSigno)
			nCValImp4       += ((cAliasSF3)->F3_VALIMP4  * nSigno)
			nTCValImp4    	+= ((cAliasSF3)->F3_VALIMP4  * nSigno)
			nCValImp5       += (((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6)*nSigno)
			nTCValImp5      += (((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6)*nSigno)
			nCValImp9       += ((cAliasSF3)->F3_VALIMP9  * nSigno)
			nTCValImp9      += ((cAliasSF3)->F3_VALIMP9  * nSigno)
			nCRetIva        += nRetIVA
			nTCRetIVA	    += nRetIVA
			nCRetIBB        += nRetIIBB
			nTCRetIBB       += nRetIIBB
			nCExento  		+= ((cAliasSF3)->F3_EXENTAS  * nSigno)
			nTCExento  		+= ((cAliasSF3)->F3_EXENTAS  * nSigno)
			nCImpTotal      += (nValBrut                 * nSigno)
			nTCImpTotal     += (nValBrut				 * nSigno)

		ElseIf ( Alltrim((cAliasSF3)->F3_ESPECIE) == "NDP" ) //Acumula  valores referente a Notas de Debito
			nDValMerc		+= (nValMerc				 * nSigno)
			nTDVALMERC      += (nValMerc				 * nSigno)
			nDValImp1       += ((cAliasSF3)->F3_VALIMP1  * nSigno)
			nTDValImp1      += ((cAliasSF3)->F3_VALIMP1  * nSigno)
			nDValImp2       += ((cAliasSF3)->F3_VALIMP2  * nSigno)
			nTDValImp2      += ((cAliasSF3)->F3_VALIMP2  * nSigno)
			nDValImp3       += ((cAliasSF3)->F3_VALIMP3  * nSigno)
			nTDValImp3      += ((cAliasSF3)->F3_VALIMP3  * nSigno)
			nDValImp7       += ((cAliasSF3)->F3_VALIMP7  * nSigno)
			nTDValImp7      += ((cAliasSF3)->F3_VALIMP7  * nSigno)
			nDValImp8       += ((cAliasSF3)->F3_VALIMP8  * nSigno)
			nTDValImp8      += ((cAliasSF3)->F3_VALIMP8  * nSigno)
			nDValImp4       += ((cAliasSF3)->F3_VALIMP4  * nSigno)
			nTDValImp4    	+= ((cAliasSF3)->F3_VALIMP4  * nSigno)
			nDValImp5       += (((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6)*nSigno)
			nTDValImp5      += (((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6)*nSigno)
			nDValImp9       += ((cAliasSF3)->F3_VALIMP9  * nSigno)
			nTDValImp9      += ((cAliasSF3)->F3_VALIMP9  * nSigno)
			nDRetIVA        += nRetIVA
			nTDRetIVA	    += nRetIVA
			nDRetIBB        += nRetIIBB
			nTDRetIBB       += nRetIIBB
			nDExento        += ((cAliasSF3)->F3_EXENTAS  * nSigno)
			nTDExento       += ((cAliasSF3)->F3_EXENTAS  * nSigno)
			nDImpTotal      += (nValBrut				 * nSigno)
			nTDImpTotal     += (nValBrut				 * nSigno)

		Else //Acumula valores referente a Notas Fiscais/Fatura
			nFValMerc    	+= (nValMerc				 * nSigno)
			nTFVALMERC 		+= (nValMerc				 * nSigno)
			nFValImp1       += ((cAliasSF3)->F3_VALIMP1  * nSigno)
			nTFValImp1      += ((cAliasSF3)->F3_VALIMP1  * nSigno)
			nFValImp2       += ((cAliasSF3)->F3_VALIMP2  * nSigno)
			nTFValImp2      += ((cAliasSF3)->F3_VALIMP2  * nSigno)
			nFValImp3       += ((cAliasSF3)->F3_VALIMP3  * nSigno)
			nTFValImp3      += ((cAliasSF3)->F3_VALIMP3  * nSigno)
			nFValImp7       += ((cAliasSF3)->F3_VALIMP7  * nSigno)
			nTFValImp7      += ((cAliasSF3)->F3_VALIMP7  * nSigno)
			nFValImp8       += ((cAliasSF3)->F3_VALIMP8  * nSigno)
			nTFValImp8      += ((cAliasSF3)->F3_VALIMP8  * nSigno)
			nFValImp4       += ((cAliasSF3)->F3_VALIMP4  * nSigno)
			nTFValImp4    	+= ((cAliasSF3)->F3_VALIMP4  * nSigno)
			nFValImp5       += (((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6)*nSigno)
			nTFValImp5      += (((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6)*nSigno)
			nFValImp9       += ((cAliasSF3)->F3_VALIMP9  * nSigno)
			nTFValImp9      += ((cAliasSF3)->F3_VALIMP9  * nSigno)
			nFRetIVA        += nRetIVA
			nTFRetIVA	    += nRetIVA
			nFRetIBB        += nRetIIBB
			nTFRetIBB       += nRetIIBB
			nFExento  		+= ((cAliasSF3)->F3_EXENTAS	 * nSigno)
			nTFExento  		+= ((cAliasSF3)->F3_EXENTAS	 * nSigno)
			nFImpTotal      += (nValBrut * nSigno)
			nTFImpTotal     += (nValBrut * nSigno)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄp
		//³Busca y discrimina por tipo de cliente (Si esta cargada la tabla de tipos en el SX5).³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄp
		If lTipos       // Monta o resumo por Condicao Fiscal(Tipo de Proveedor)
			nTipo := aScan( aTipos,{|X| Alltrim(x[1])==Alltrim(SA2->A2_TIPO)} )
			If nTipo == 0
				aTotCFis[Len(aTotCFis)][1]:=	aTotCFis[Len(aTotCFis)][1] + (nSigno *nValMerc)
				aTotCFis[Len(aTotCFis)][2]:=	aTotCFis[Len(aTotCFis)][2] + (nSigno *(cAliasSF3)->F3_VALIMP1)
				aTotCFis[Len(aTotCFis)][3]:=	aTotCFis[Len(aTotCFis)][3] + (nSigno *(cAliasSF3)->F3_VALIMP2)
				aTotCFis[Len(aTotCFis)][4]:=	aTotCFis[Len(aTotCFis)][4] + (nSigno *(cAliasSF3)->F3_VALIMP3)
				aTotCFis[Len(aTotCFis)][5]:=	aTotCFis[Len(aTotCFis)][5] + (nSigno *(cAliasSF3)->F3_VALIMP7)
				aTotCFis[Len(aTotCFis)][6]:=	aTotCFis[Len(aTotCFis)][6] + (nSigno *(cAliasSF3)->F3_VALIMP8)
				aTotCFis[Len(aTotCFis)][7]:=	aTotCFis[Len(aTotCFis)][7] + (nSigno *(cAliasSF3)->F3_VALIMP4)
				aTotCFis[Len(aTotCFis)][8]:=	aTotCFis[Len(aTotCFis)][8] + (nSigno *((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6))
				aTotCFis[Len(aTotCFis)][9]:=	aTotCFis[Len(aTotCFis)][9] + (nSigno *(cAliasSF3)->F3_VALIMP9)
				aTotCFis[Len(aTotCFis)][10]:=	aTotCFis[Len(aTotCFis)][10]+ (nSigno *nRetIVA)
				aTotCFis[Len(aTotCFis)][11]:=	aTotCFis[Len(aTotCFis)][11]+ (nSigno *nRetIIBB)
				aTotCFis[Len(aTotCFis)][12]:=	aTotCFis[Len(aTotCFis)][12]+ (nSigno *(cAliasSF3)->F3_EXENTAS)
				aTotCFis[Len(aTotCFis)][13]:=	aTotCFis[Len(aTotCFis)][13]+ (nSigno *nValBrut)
			Else
				aTotCFis[nTipo][1]:=	aTotCFis[nTipo][1] + (nSigno *nValMerc)
				aTotCFis[nTipo][2]:=	aTotCFis[nTipo][2] + (nSigno *(cAliasSF3)->F3_VALIMP1)
				aTotCFis[nTipo][3]:=	aTotCFis[nTipo][3] + (nSigno *(cAliasSF3)->F3_VALIMP2)
				aTotCFis[nTipo][4]:=	aTotCFis[nTipo][4] + (nSigno *(cAliasSF3)->F3_VALIMP3)
				aTotCFis[nTipo][5]:=	aTotCFis[nTipo][5] + (nSigno *(cAliasSF3)->F3_VALIMP7)
				aTotCFis[nTipo][6]:=	aTotCFis[nTipo][6] + (nSigno *(cAliasSF3)->F3_VALIMP8)
				aTotCFis[nTipo][7]:=	aTotCFis[nTipo][7] + (nSigno *(cAliasSF3)->F3_VALIMP4)
				aTotCFis[nTipo][8]:=	aTotCFis[nTipo][8] + (nSigno *((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6))
				aTotCFis[nTipo][9]:=	aTotCFis[nTipo][9] + (nSigno *(cAliasSF3)->F3_VALIMP9)   
				aTotCFis[nTipo][10]:=	aTotCFis[nTipo][10]+ (nSigno *nRetIVA)
				aTotCFis[nTipo][11]:=	aTotCFis[nTipo][11]+ (nSigno *nRetIIBB)
				aTotCFis[nTipo][12]:=	aTotCFis[nTipo][12] +(nSigno *(cAliasSF3)->F3_EXENTAS)
				aTotCFis[nTipo][13]:=	aTotCFis[nTipo][13]+ (nSigno *nValBrut)
			Endif
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄp
		//³Busca y discrimina por Provincia (Si esta cargada la tabla de Provincia en el SX5).  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄp
		If lProvincia       // Monta o resumo por Provincia (UF do Proveedor )
			nTipo := aScan( aProvincia,{|X| alltrim(x[1])==Alltrim(SA2->A2_EST)} )
			If nTipo == 0
				aTotProv[Len(aTotProv)][1]:=	aTotProv[Len(aTotProv)][1] + (nSigno *nValMerc)
				aTotProv[Len(aTotProv)][2]:=	aTotProv[Len(aTotProv)][2] + (nSigno *(cAliasSF3)->F3_VALIMP1)
				aTotProv[Len(aTotProv)][3]:=	aTotProv[Len(aTotProv)][3] + (nSigno *(cAliasSF3)->F3_VALIMP2)
				aTotProv[Len(aTotProv)][4]:=	aTotProv[Len(aTotProv)][4] + (nSigno *(cAliasSF3)->F3_VALIMP3)
				aTotProv[Len(aTotProv)][5]:=	aTotProv[Len(aTotProv)][5] + (nSigno *(cAliasSF3)->F3_VALIMP7)
				aTotProv[Len(aTotProv)][6]:=	aTotProv[Len(aTotProv)][6] + (nSigno *(cAliasSF3)->F3_VALIMP8)
				aTotProv[Len(aTotProv)][7]:=	aTotProv[Len(aTotProv)][7] + (nSigno *(cAliasSF3)->F3_VALIMP4)
				aTotProv[Len(aTotProv)][8]:=	aTotProv[Len(aTotProv)][8] + (nSigno *((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6))
				aTotProv[Len(aTotProv)][9]:=	aTotProv[Len(aTotProv)][9] + (nSigno *(cAliasSF3)->F3_VALIMP9)   
				aTotProv[Len(aTotProv)][10]:=	aTotProv[Len(aTotProv)][10]+ (nSigno *nRetIVA)
				aTotProv[Len(aTotProv)][11]:=	aTotProv[Len(aTotProv)][11]+ (nSigno *nRetIIBB)
				aTotProv[Len(aTotProv)][12]:=	aTotProv[Len(aTotProv)][12]+ (nSigno*(cAliasSF3)->F3_EXENTAS)
				aTotProv[Len(aTotProv)][13]:=	aTotProv[Len(aTotProv)][13]+ (nSigno *nValBrut)
			Else
				aTotProv[nTipo][1]:=	aTotProv[nTipo][1] + (nSigno *nValMerc)
				aTotProv[nTipo][2]:=	aTotProv[nTipo][2] + (nSigno *(cAliasSF3)->F3_VALIMP1)
				aTotProv[nTipo][3]:=	aTotProv[nTipo][3] + (nSigno *(cAliasSF3)->F3_VALIMP2)
				aTotProv[nTipo][4]:=	aTotProv[nTipo][4] + (nSigno *(cAliasSF3)->F3_VALIMP3)
				aTotProv[nTipo][5]:=	aTotProv[nTipo][5] + (nSigno *(cAliasSF3)->F3_VALIMP7)
				aTotProv[nTipo][6]:=	aTotProv[nTipo][6] + (nSigno *(cAliasSF3)->F3_VALIMP8)
				aTotProv[nTipo][7]:=	aTotProv[nTipo][7] + (nSigno *(cAliasSF3)->F3_VALIMP4)
				aTotProv[nTipo][8]:=	aTotProv[nTipo][8] + (nSigno *((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6))
				aTotProv[nTipo][9]:=	aTotProv[nTipo][9] + (nSigno *(cAliasSF3)->F3_VALIMP9)   
				aTotProv[nTipo][10]:=	aTotProv[nTipo][10]+ (nSigno *nRetIVA)
				aTotProv[nTipo][11]:=	aTotProv[nTipo][11]+ (nSigno *nRetIIBB)
				aTotProv[nTipo][12]:=	aTotProv[nTipo][12] +(nSigno *(cAliasSF3)->F3_EXENTAS)
				aTotProv[nTipo][13]:=	aTotProv[nTipo][13]+ (nSigno *nValBrut)
			Endif
		Endif
		
		If cNotaAnt <> (cAliasSF3)->F3_TIPO+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA
			If lProduto
				If Alltrim((cAliasSF3)->F3_ESPECIE) == "NCP"
					SD2->( dbSetOrder(3) )
					SD2->( dbSeek( xFilial("SD2")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA) )
					While !Eof() .And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA ==;
						xFilial("SD2")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA
						
						nTipo	:= aScan( aProduto,{|X| alltrim(x[1])==Alltrim(SD2->D2_TP)} )
						nValImp := SD2->D2_VALIMP1 + SD2->D2_VALIMP2 + SD2->D2_VALIMP3 + SD2->D2_VALIMP7 + SD2->D2_VALIMP8 + SD2->D2_VALIMP4 + SD2->D2_VALIMP5 + SD2->D2_VALIMP6 + SD2->D2_VALIMP9
						nValBrut:= SD2->D2_TOTAL+SD2->D2_VALFRE+SD2->D2_SEGURO+SD2->D2_DESPESA
						nValBrut:= nSigno * (nValBrut + nValImp)
						
						If nTipo == 0
							aTotTPProd[Len(aTotTPProd)][1]	:= aTotTPProd[Len(aTotTPProd)][1] + (nSigno *xMoeda(SD2->D2_TOTAL,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][2]	:= aTotTPProd[Len(aTotTPProd)][2] + (nSigno *xMoeda(SD2->D2_VALIMP1,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][3]	:= aTotTPProd[Len(aTotTPProd)][3] + (nSigno *xMoeda(SD2->D2_VALIMP2,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][4]	:= aTotTPProd[Len(aTotTPProd)][4] + (nSigno *xMoeda(SD2->D2_VALIMP3,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][5]	:= aTotTPProd[Len(aTotTPProd)][5] + (nSigno *xMoeda(SD2->D2_VALIMP7,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][6]	:= aTotTPProd[Len(aTotTPProd)][6] + (nSigno *xMoeda(SD2->D2_VALIMP8,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][7]	:= aTotTPProd[Len(aTotTPProd)][7] + (nSigno *xMoeda(SD2->D2_VALIMP4,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][8]	:= aTotTPProd[Len(aTotTPProd)][8] + (nSigno *xMoeda((SD2->D2_VALIMP5+SD2->D2_VALIMP6),nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][9]	:= aTotTPProd[Len(aTotTPProd)][9] + (nSigno *xMoeda(SD2->D2_VALIMP9,nMoeda,1,dDigita,nDecs+1,nTaxa))
						    aTotTPPROD[Len(aTotTPPROD)][10]:= aTotTPProd[Len(aTotTPProd)][10]+ (nSigno *nRetIVA)
							aTotTPProd[Len(aTotTPProd)][11]:= aTotTPProd[Len(aTotTPProd)][11]+ (nSigno *nRetIIBB)
							aTotTPProd[Len(aTotTPProd)][13]:= aTotTPProd[Len(aTotTPProd)][13]+ xMoeda(nValBrut,nMoeda,1,dDigita,nDecs+1,nTaxa)
						Else
							aTotTPProd[nTipo][1]:=	aTotTPProd[nTipo][1] + (nSigno *xMoeda(SD2->D2_TOTAL,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][2]:=	aTotTPProd[nTipo][2] + (nSigno *xMoeda(SD2->D2_VALIMP1,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][3]:=	aTotTPProd[nTipo][3] + (nSigno *xMoeda(SD2->D2_VALIMP2,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][4]:=	aTotTPProd[nTipo][4] + (nSigno *xMoeda(SD2->D2_VALIMP3,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][5]:=	aTotTPProd[nTipo][5] + (nSigno *xMoeda(SD2->D2_VALIMP7,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][6]:=	aTotTPProd[nTipo][6] + (nSigno *xMoeda(SD2->D2_VALIMP8,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][7]:=	aTotTPProd[nTipo][7] + (nSigno *xMoeda(SD2->D2_VALIMP4,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][8]:=	aTotTPProd[nTipo][8] + (nSigno *xMoeda((SD2->D2_VALIMP5+SD2->D2_VALIMP6),nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][9]:=	aTotTPProd[nTipo][9] + (nSigno *xMoeda(SD2->D2_VALIMP9,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][10]:=	aTotTPProd[nTipo][10]+ (nSigno *nRetIVA)
							aTotTPProd[nTipo][11]:=	aTotTPProd[nTipo][11]+ (nSigno *nRetIIBB)
							aTotTPProd[nTipo][13]:=	aTotTPProd[nTipo][13]+ xMoeda(nValBrut,nMoeda,1,dDigita,nDecs+1,nTaxa)
						Endif
						SD2->(dbSkip())
					Enddo
				Else
					SD1->( dbSetOrder(1) )
					SD1->( dbSeek( xFilial("SD1")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA) )
					While !Eof() .And. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA ==;
						xFilial("SD1")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA
						
						nTipo 	:= AScan( aProduto,{|X| alltrim(x[1])==Alltrim(SD1->D1_TP)} )
						nValImp := SD1->D1_VALIMP1+SD1->D1_VALIMP2+SD1->D1_VALIMP3+SD1->D1_VALIMP7+SD1->D1_VALIMP8+SD1->D1_VALIMP4+SD1->D1_VALIMP5+SD1->D1_VALIMP6+SD1->D1_VALIMP9
						nValBrut:= SD1->D1_TOTAL+SD1->D1_VALFRE+SD1->D1_SEGURO+SD1->D1_DESPESA
						nValBrut:= nSigno * (nValBrut + nValImp)
						
						If nTipo == 0
							aTotTPProd[Len(aTotTPProd)][1]:=	aTotTPProd[Len(aTotTPProd)][1] + (nSigno *xMoeda(SD1->D1_TOTAL,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][2]:=	aTotTPProd[Len(aTotTPProd)][2] + (nSigno *xMoeda(SD1->D1_VALIMP1,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][3]:=	aTotTPProd[Len(aTotTPProd)][3] + (nSigno *xMoeda(SD1->D1_VALIMP2,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][4]:=	aTotTPProd[Len(aTotTPProd)][4] + (nSigno *xMoeda(SD1->D1_VALIMP3,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][5]:=	aTotTPProd[Len(aTotTPProd)][5] + (nSigno *xMoeda(SD1->D1_VALIMP7,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][6]:=	aTotTPProd[Len(aTotTPProd)][6] + (nSigno *xMoeda(SD1->D1_VALIMP8,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][7]:=	aTotTPProd[Len(aTotTPProd)][7] + (nSigno *xMoeda(SD1->D1_VALIMP4,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][8]:=	aTotTPProd[Len(aTotTPProd)][8] + (nSigno *xMoeda((SD1->D1_VALIMP5+SD1->D1_VALIMP6),nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][9]:=	aTotTPProd[Len(aTotTPProd)][9] + (nSigno *xMoeda(SD1->D1_VALIMP9,nMoeda,1,dDigita,nDecs+1,nTaxa))
						    aTotTPPROD[Len(aTotTPPROD)][10]:=	aTotTPProd[Len(aTotTPProd)][10]+ (nSigno *nRetIVA)
							aTotTPProd[Len(aTotTPProd)][11]:=	aTotTPProd[Len(aTotTPProd)][11]+ (nSigno *nRetIIBB)
							aTotTPProd[Len(aTotTPProd)][13]:=	aTotTPProd[Len(aTotTPProd)][13]+ xMoeda(nValBrut,nMoeda,1,SD1->D1_DTDIGIT,nDecs+1,nTaxa)
						Else
							aTotTPProd[nTipo][1]:=	aTotTPProd[nTipo][1] + (nSigno *xMoeda(SD1->D1_TOTAL,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][2]:=	aTotTPProd[nTipo][2] + (nSigno *xMoeda(SD1->D1_VALIMP1,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][3]:=	aTotTPProd[nTipo][3] + (nSigno *xMoeda(SD1->D1_VALIMP2,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][4]:=	aTotTPProd[nTipo][4] + (nSigno *xMoeda(SD1->D1_VALIMP3,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][5]:=	aTotTPProd[nTipo][5] + (nSigno *xMoeda(SD1->D1_VALIMP7,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][6]:=	aTotTPProd[nTipo][6] + (nSigno *xMoeda(SD1->D1_VALIMP8,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][7]:=	aTotTPProd[nTipo][7] + (nSigno *xMoeda(SD1->D1_VALIMP4,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][8]:=	aTotTPProd[nTipo][8] + (nSigno *xMoeda((SD1->D1_VALIMP5+SD1->D1_VALIMP6),nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][9]:=	aTotTPProd[nTipo][9] + (nSigno *xMoeda(SD1->D1_VALIMP9,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][10]:=	aTotTPProd[nTipo][10]+ (nSigno *nRetIVA)
							aTotTPProd[nTipo][11]:=	aTotTPProd[nTipo][11]+ (nSigno *nRetIIBB)
							aTotTPProd[nTipo][13]:=	aTotTPProd[nTipo][13]+ xMoeda(nValBrut,nMoeda,1,dDigita,nDecs+1,nTaxa)
						Endif
						SD1->(dbSkip())
					Enddo
				EndIf
			EndIf
		EndIf
		cNotaAnt := (cAliasSF3)->F3_TIPO+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA
	EndIf
	lImpTDia := .F.  //Flag de controle do quebra por dia
	(cAliasSF3)->(dbSkip())
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dispara a funcao para impressao dos Totalizadores.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( mv_par04 == 1 .And. !lImpTDia )
	RaR1TotDia(lRelease4)   // Imprime o sub total do dia
EndIf

RaR1TotPg(lRelease4)   // Imprime o Sub Total Impresso

If mv_par06 == 1
	RaR1Resumo(lRelease4)  // Imprime o resumo do relatorio
EndIf

oReport:Section(1):Finish()	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³MATRAR1R3 ºAutor  ³Gilson da Silva     º Data ³  06/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ SubDiario de IVA Compras. 	                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Livros Fiscais                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xMATRAR1R3()

Local nQ
Local cPerg       	:= "MTRAR1"
Local cString     	:= "SF3"

Private CbTxt		:=""
Private CbCont		:=""
Private aTipos   	:= {}
Private lTipos      := SX5->(DBSEEK(xFilial("SX5")+"SF"))
Private aTotCFis    := {}
Private aProvincia  := {}
Private lProvincia  := SX5->(DBSEEK(xFilial("SX5")+"12"))
Private aTotProv  	:= {}
Private aProduto    := {}
Private lProduto    := SX5->(DBSEEK(xFilial("SX5")+"02"))
Private aTotTpProd	:= {}
Private tamanho   	:= "G"
Private limite    	:= 220
Private titulo    	:= PADC(OemToAnsi(STR0001),74) //"Emisión del Subdiario de IVA"
Private cDesc1    	:= PADC(OemToAnsi(STR0002),74) //"Se solicitaran la fecha inicial y la fecha final para la emisión"
Private cDesc2    	:= PADC(OemToAnsi(STR0003),74) //"de los libros de IVA Compras"
Private cDesc3    	:= ""
Private aReturn   	:= { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1,"",1 } //"Especial"###"Administracion"
Private lContinua 	:= .T.
Private wnrel     	:= "MATRAR1"
Private cPictVals 	:= "@E 999,999,999.99"
Private cPictImp  	:= "@E 999,999.99"    
Private nLastKey	:=	0
Private dDtIni, dDtFim
Private nImpGravados,nNoGravados,nIvaNoInscri
Private nPagina,cRazaoSoc,cCGC,nLin
Private nPagIni		:= 0
Private nSigno,nTipo,aMeses
PRIVATE cEmpresa,cInscr,cCuit,cTitulo,_nMes,nCnt1
PRIVATE nd,nLinRoda1,nLinRoda2,nLinRoda3,nLinRoda4,nLinRoda5
PRIVATE nLinRoda1b,nLinRoda2b,nLinRoda3b,nLinIni,aDriver,nOpc, CFILTERUSER
Private cIndexSf3 , dDataEnt

If lTipos   // Verifica se existe a Tabela SF(Tabela de Agentes Fiscais) no SX5 e monta o array com todas as chaves desse grupo.
	SX5->(DBSEEK(xFilial("SX5")+"SF"))
	While !SX5->(EOF()).And.SX5->X5_TABELA=="SF"
		Aadd(aTipos,{SX5->X5_CHAVE,Alltrim(x5DESCri())})
		SX5->(DbSkip())
	Enddo
	Aadd(aTipos,{"  ",OemToAnsi(STR0006)}) //"Tipo no Reg."
	For nQ	:=	1 To len(aTipos)
		Aadd(aTotCFis,{0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00})
	Next
Endif

If lProvincia  // Verifica se existe a Tabela 12(Tabela de Zonas Fiscais) no SX5 e monta o array com todas as chaves desse grupo.
	SX5->(DBSEEK(xFilial("SX5")+"12"))
	While !SX5->(EOF()).And.SX5->X5_TABELA=="12"
		Aadd(aProvincia,{SX5->X5_CHAVE,Alltrim(x5DESCri())})
		SX5->(DbSkip())
	Enddo
	For nQ	:=	1 To len(aProvincia)
		Aadd(aTotProv,{0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00})
	Next
Endif

If lProduto  // Verifica se existe a Tabela 02(Tabela de Tipos de Materiais) no SX5 e monta o array com todas as chaves desse grupo.
	SX5->(DBSEEK(xFilial("SX5")+"02"))
	While !SX5->(EOF()).And.SX5->X5_TABELA=="02"
		Aadd(aProduto,{SX5->X5_CHAVE,Alltrim(x5DESCri())})
		SX5->(DbSkip())
	Enddo
	For nQ	:=	1 To len(aProduto)
		Aadd(aTotTPProd,{0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00})
	Next
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as perguntas selecionadas   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis utilizadas para parametros    ³
//³mv_par01             // Fecha desde     ³
//³mv_par02             // Fecha hasta     ³
//³mv_par03             // Incluir         ³
//³mv_par04             // Estilo          ³
//³mv_par05             // Sucursales      ³
//³mv_par06             // Resumen         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
AjustaSX1()
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)

dDtIni := Dtos(mv_par01)
dDtFim := Dtos(mv_par02)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

cFilterUser:=aReturn[7]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica Posicao do Formulario na Impressora³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
VerImp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do Processamento do Relatorio. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF WINDOWS
	RptStatus({|| RptDetail()})
#ENDIF

dbSelectArea("SF3")
dbClearFil()
RetIndex( "SF3" )
#IFNDEF TOP
	FErase(cIndexSf3+OrdBagExt())
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RptDetail ºAutor  ³Gilson da Silva     º Data ³  06/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao da linha detalhe do relatorio			          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Livros Fiscais                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RptDetail()

Local nIndex
Local nQ
Local cNotaAnt  := ""
Local cChave
Local cFiltro
Local nCont := 1
Local nValImp  := 0
Local nValMerc := 0
Local nValBrut := 0   
Local nQtLinCab:= 0       
Local nQtLinRes:= 0       
Local nRetIVA  := 0
Local nRetIBB  := 0 

// VARIAVEIS COM OS SUB TOTAIS DOS CAMPOS DE IMPOSTOS, SEPARADOS POR TIPO DE DOCUMENTO
// nF=FATURA  nD=NOTA DE DEBITO   nC=NOTA DE CREDITO
Private nFVALMERC :=0, nDVALMERC :=0, nCVALMERC:=0
Private nFValImp1 :=0, nDValImp1 :=0, nCValImp1:=0
Private nFValImp2 :=0, nDValImp2 :=0, nCValImp2:=0
Private nFValImp3 :=0, nDValImp3 :=0, nCValImp3:=0
Private nFValImp7 :=0, nDValImp7 :=0, nCValImp7:=0
Private nFValImp8 :=0, nDValImp8 :=0, nCValImp8:=0
Private nFValImp4 :=0, nDValImp4 :=0, nCValImp4:=0
Private nFValImp5 :=0, nDValImp5 :=0, nCValImp5:=0
Private nFValImp9 :=0, nDValImp9 :=0, nCValImp9:=0
Private nFRetIVA  :=0,  nDRetIVA :=0,  nCRetIVA:=0
Private nFRetIBB  :=0,  nDRetIBB :=0,  nCRetIBB:=0
Private nFExento  :=0,  nDExento :=0,  nCExento:=0
Private nFImpTotal:=0, nDImpTotal:=0, nCImpTotal:=0

// VARIAVEIS COM OS TOTAIS DOS CAMPOS DE IMPOSTOS, SEPARADOS POR TIPO DE DOCUMENTO
// nTF=FATURA  nTD=NOTA DE DEBITO   nTC=NOTA DE CREDITO
Private nTFVALMERC :=0, nTDVALMERC :=0, nTCVALMERC:=0
Private nTFValImp1 :=0, nTDValImp1 :=0, nTCValImp1:=0
Private nTFValImp2 :=0, nTDValImp2 :=0, nTCValImp2:=0
Private nTFValImp3 :=0, nTDValImp3 :=0, nTCValImp3:=0
Private nTFValImp7 :=0, nTDValImp7 :=0, nTCValImp7:=0
Private nTFValImp8 :=0, nTDValImp8 :=0, nTCValImp8:=0
Private nTFValImp4 :=0, nTDValImp4 :=0, nTCValImp4:=0
Private nTFValImp5 :=0, nTDValImp5 :=0, nTCValImp5:=0
Private nTFValImp9 :=0, nTDValImp9 :=0, nTCValImp9:=0
Private nTFRetIVA  :=0, nTDRetIVA  :=0, nTCRetIVA:=0
Private nTFRetIBB  :=0, nTDRetIBB  :=0, nTCRetIBB:=0
Private nTFExento  :=0, nTDExento  :=0, nTCExento:=0
Private nTFImpTotal:=0, nTDImpTotal:=0, nTCImpTotal:=0

Private dEntAnt , cAliasSF3  , lImpTDia := .F.
Private nMoeda := 0, nTaxa := 0, nDecs := 0, dDigita := Ctod("//")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Prepara o SF3 para extracao dos dados  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF3")
#IFNDEF TOP
	cAliasSF3:="SF3"
	cFiltro:="F3_FILIAL=='"+mv_par05+"'.AND.DTOS(F3_ENTRADA)>='"+dDtIni+"'.AND.DTOS(F3_ENTRADA)<='"+dDtFim+"'"
	If mv_par03 == 1
		cFiltro :=cFiltro + ".AND. EMPTY(F3_DTCANC)"
	ElseIf mv_par03 == 2
		cFiltro := cFiltro+ ".AND. !EMPTY(F3_DTCANC)"
	EndIf
	cFiltro := cFiltro + ".And. F3_TIPOMOV == 'C' .And. Alltrim(F3_ESPECIE) $ 'NF|NDP|NCP'" //Movimentaçöes de Compras
	cChave:="F3_FILIAL+DTOS(F3_ENTRADA)+F3_SERIE+F3_NFISCAL+F3_CFO"
	cIndexSf3 := CriaTrab(NIL,.F.)
	IndRegua("SF3",cIndexSf3,cChave,,cFiltro,OemToAnsi(STR0007)) //"Filtrando registros..."
	nIndex	:=	Retindex("SF3")
	dbSelectArea("SF3")
	dbSetIndex(cIndexSf3+OrdBagExt())
	DbSetOrder(nIndex+1)
#ELSE
	cAliasSF3:="SF3TMP"
	If Select((cAliasSF3))<>0
		DbSelectArea((cAliasSF3))
		DbCloseArea()
	Endif
	cQuery:="SELECT * FROM "+RetSqlName("SF3")+" "+(cAliasSF3)+" "
	cQuery+="WHERE F3_FILIAL='"+mv_par05+"'  AND D_E_L_E_T_<>'*'"
	cQuery+= " AND F3_ENTRADA >='"+dDtIni+"'"
	cQuery+= " AND F3_ENTRADA<='"+dDtFim+"'"
	If mv_par03 == 1
		cQuery+= " AND F3_DTCANC = ' '"
	ElseIf mv_par03 == 2
		cQuery+= " AND F3_DTCANC <> ' '"
	EndIf
	cQuery += "AND F3_TIPOMOV = 'C'  AND  F3_ESPECIE IN('NF','NDP','NCP')" //Movimentaçöes de Compras
	cQuery += " ORDER BY F3_ENTRADA,F3_SERIE,F3_NFISCAL,F3_CFO"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasSF3),.F.,.T.)
#ENDIF

DbSelectArea(cAliasSF3)
DbGoTop()
nLin    := 60
nPagina := MV_PAR07-1
nPagIni	:= MV_PAR07

If mv_par06 == 1  
	nQtLinRes := 9 // Qtde Linhas usadas qdo Imprime o resumo. 
EndIf	

SetRegua(LastRec())
#IFNDEF TOP
	dEntAnt:= CTOD("") 
#ELSE                  
	dEntAnt:= ""
#ENDIF
While !Eof()
	IncRegua()
	IF lAbortPrint
		@ 00,01 PSAY OemToAnsi(STR0008) //"** CANCELADO PELO OPERADOR **"
		lContinua := .F.
		Exit
	Endif                      

	If (cAliasSF3)->F3_ENTRADA<>dEntAnt
		nQtLinCab := nQtLinRes + 4  // Qtde Linhas usadas qdo Imprimir o cabeçalho. 
	EndIf
			
	If nLin + nQtLinCab > 55
   		If nPagina >= nPagIni
			If (cAliasSF3)->F3_ENTRADA<>dEntAnt
				RaR1TotDia()   // Imprime o sub total por dia
				dEntAnt := (cAliasSF3)->F3_ENTRADA
			EndIf
			RaR1TotPg()  // Imprime o Sub total Impresso
			RAR1Cab()   //Imprime o Cabecalho do relatorio
			RaR1TotPg()  // Imprime o Sub Total Impresso
			#IFNDEF TOP
				@ nLin, 001 PSAY (cAliasSF3)->F3_ENTRADA
			#ELSE                  
				@ nLin, 001 PSAY CTOD((cAliasSF3)->(SUBSTR(F3_ENTRADA,7,2)+"/"+SUBSTR(F3_ENTRADA,5,2)+"/"+SUBSTR(F3_ENTRADA,3,2)))
			#ENDIF
			nLin	:= nLin+1
		Else
			RAR1Cab()   //Imprime o Cabecalho do relatorio
			#IFNDEF TOP
				@ nLin, 001 PSAY (cAliasSF3)->F3_ENTRADA
			#ELSE                  
				@ nLin, 001 PSAY CTOD((cAliasSF3)->(SUBSTR(F3_ENTRADA,7,2)+"/"+SUBSTR(F3_ENTRADA,5,2)+"/"+SUBSTR(F3_ENTRADA,3,2)))
			#ENDIF         
			dEntAnt	:= (cAliasSF3)->F3_ENTRADA
			nLin	:= nLin+1
		EndIf
	EndIf
	
	//+--------------------------------------------------------------+
	//¦ Considera filtro do usuario                                  ¦
	//+--------------------------------------------------------------+
	If !Empty(cFilterUser).and.!(&cFilterUser)
		(cAliasSF3)->(dbSkip())
		Loop
	Endif
	
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek( xFilial("SA2")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA ) )
	cRazaoSoc := SA2->A2_NOME
	cCgc	  := SA2->A2_CGC
	
	If Alltrim((cAliasSF3)->F3_ESPECIE)=="NCP"
		nSigno	:=-1
	Else
		nSigno	:= 1
	Endif
	
	If ( (cAliasSF3)->F3_ENTRADA<>dEntAnt )
		If mv_par04 == 1 .And. nCont > 1
			RaR1TotDia()  //Imprime o sub total do dia
		EndIf
		nLin := nLin+1            
		#IFNDEF TOP
			@ nLin, 001 PSAY (cAliasSF3)->F3_ENTRADA
		#ELSE                  
			@ nLin, 001 PSAY CTOD((cAliasSF3)->(SUBSTR(F3_ENTRADA,7,2)+"/"+SUBSTR(F3_ENTRADA,5,2)+"/"+SUBSTR(F3_ENTRADA,3,2)))
		#ENDIF
		dEntAnt	:= (cAliasSF3)->F3_ENTRADA
		nLin	:= nLin+1
	EndIf
	nCont ++
	
	If (cAliasSF3)->F3_TIPO+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA # cNotaAnt
		@ nLin,001 PSAY (cAliasSF3)->F3_ESPECIE
		@ nLin,007 PSAY (cAliasSF3)->F3_SERIE
		@ nLin,013 PSAY (cAliasSF3)->F3_NFISCAL					Picture "@R 9999-99999999"
	ENDIF
	
	//Verifica se a NF foi Anulada/Cancelada
	If !Empty((cAliasSF3)->F3_DTCANC)
		@ nLin,029 PSAY OemToAnsi(STR0032)   //"A N U L A D A"
	Else
		@ nLin,029 PSAY Subs(cRazaoSoc,1,20)        	Picture "@!"
		@ nLin,051 PSAY cCgc					    	Picture "@R 99-99999999-9"
		
//		cNotaAnt	:= (cAliasSF3)->F3_TIPO+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA
		
		If ( Alltrim((cAliasSF3)->F3_ESPECIE)=="NCP" )
			SF2->( dbSetOrder(1) )
			SF2->( dbSeek( xFilial("SF2")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA ) )
			nMoeda:= SF2->F2_MOEDA
			nTaxa := SF2->F2_TXMOEDA
			nDecs := MsDecimais(nMoeda)
			dDigita := SF2->F2_EMISSAO
		Else
			SF1->( dbSetOrder(1) )
			SF1->( dbSeek( xFilial("SF1")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA ) )
			nMoeda:= SF1->F1_MOEDA
			nTaxa := SF1->F1_TXMOEDA
			nDecs := MsDecimais(nMoeda)
			dDigita := SF1->F1_DTDIGIT
		EndIf

		nValMerc := (cAliasSF3)->F3_VALMERC - (cAliasSF3)->F3_EXENTAS
		nValBrut := (cAliasSF3)->F3_VALCONT
		
		@ nLin,064 PSAY (nValMerc  * nSigno)  			     		Picture cPictVals
		@ nLin,079 PSAY ((cAliasSF3)->F3_VALIMP1  * nSigno)			Picture cPictImp
		@ nLin,090 PSAY ((cAliasSF3)->F3_VALIMP2  * nSigno)			Picture cPictImp
		@ nLin,101 PSAY ((cAliasSF3)->F3_VALIMP3  * nSigno)			Picture cPictImp
		@ nLin,112 PSAY ((cAliasSF3)->F3_VALIMP7  * nSigno)			Picture cPictImp
		@ nLin,123 PSAY ((cAliasSF3)->F3_VALIMP8  * nSigno)			Picture cPictImp
		@ nLin,134 PSAY ((cAliasSF3)->F3_VALIMP4  * nSigno)			Picture cPictImp
		@ nLin,145 PSAY (((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6)*nSigno)	Picture cPictImp
		@ nLin,156 PSAY ((cAliasSF3)->F3_VALIMP9  * nSigno)			Picture cPictImp 

		// Verifica se existem Retencoes para IVA e INGRESSOS BRUTOS
		SFE->( dbSetOrder(4) )
		IF SFE->( dbSeek( xFilial("SFE")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+"I" ) )
			nRetIVA := SFE->FE_RETENC
		Else
			nRetIVA := 0
		EndIf
		
		SFE->( dbSetOrder(4) )
		IF SFE->( dbSeek( xFilial("SFE")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+"B" ) )
			nRetIBB := SFE->FE_RETENC
		Else
			nRetIBB := 0
		EndIf
		
		@ nLin,167 PSAY nRetIVA										Picture cPictImp
		@ nLin,178 PSAY nRetIBB										Picture cPictImp
		@ nLin,190 PSAY ((cAliasSF3)->F3_EXENTAS  * nSigno)         Picture cPictVals
		@ nLin,207 PSAY (nValBrut  * nSigno)						Picture cPictVals
		
		If ( Alltrim((cAliasSF3)->F3_ESPECIE)=="NCP" ) //Acumula valores referente a Notas de Credito
			nCValMerc		+= (nValMerc				 * nSigno)
			nTCVALMERC      += (nValMerc				 * nSigno)
			nCValImp1       += ((cAliasSF3)->F3_VALIMP1  * nSigno)
			nTCValImp1      += ((cAliasSF3)->F3_VALIMP1  * nSigno)
			nCValImp2       += ((cAliasSF3)->F3_VALIMP2  * nSigno)
			nTCValImp2      += ((cAliasSF3)->F3_VALIMP2  * nSigno)
			nCValImp3       += ((cAliasSF3)->F3_VALIMP3  * nSigno)
			nTCValImp3      += ((cAliasSF3)->F3_VALIMP3  * nSigno)
			nCValImp7       += ((cAliasSF3)->F3_VALIMP7  * nSigno)
			nTCValImp7      += ((cAliasSF3)->F3_VALIMP7  * nSigno)
			nCValImp8       += ((cAliasSF3)->F3_VALIMP8  * nSigno)
			nTCValImp8      += ((cAliasSF3)->F3_VALIMP8  * nSigno)
			nCValImp4       += ((cAliasSF3)->F3_VALIMP4  * nSigno)
			nTCValImp4    	+= ((cAliasSF3)->F3_VALIMP4  * nSigno)
			nCValImp5       += (((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6)*nSigno)
			nTCValImp5      += (((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6)*nSigno)
			nCValImp9       += ((cAliasSF3)->F3_VALIMP9  * nSigno)
			nTCValImp9      += ((cAliasSF3)->F3_VALIMP9  * nSigno)
			nCRetIva        += nRetIVA
			nTCRetIVA	    += nRetIVA
			nCRetIBB        += nRetIBB
			nTCRetIBB       += nRetIBB
			nCExento  		+= ((cAliasSF3)->F3_EXENTAS  * nSigno)
			nTCExento  		+= ((cAliasSF3)->F3_EXENTAS  * nSigno)
			nCImpTotal      += (nValBrut                 * nSigno)
			nTCImpTotal     += (nValBrut				 * nSigno)
		ElseIf ( Alltrim((cAliasSF3)->F3_ESPECIE) == "NDP" ) //Acumula  valores referente a Notas de Debito
			nDValMerc		+= (nValMerc				 * nSigno)
			nTDVALMERC      += (nValMerc				 * nSigno)
			nDValImp1       += ((cAliasSF3)->F3_VALIMP1  * nSigno)
			nTDValImp1      += ((cAliasSF3)->F3_VALIMP1  * nSigno)
			nDValImp2       += ((cAliasSF3)->F3_VALIMP2  * nSigno)
			nTDValImp2      += ((cAliasSF3)->F3_VALIMP2  * nSigno)
			nDValImp3       += ((cAliasSF3)->F3_VALIMP3  * nSigno)
			nTDValImp3      += ((cAliasSF3)->F3_VALIMP3  * nSigno)
			nDValImp7       += ((cAliasSF3)->F3_VALIMP7  * nSigno)
			nTDValImp7      += ((cAliasSF3)->F3_VALIMP7  * nSigno)
			nDValImp8       += ((cAliasSF3)->F3_VALIMP8  * nSigno)
			nTDValImp8      += ((cAliasSF3)->F3_VALIMP8  * nSigno)
			nDValImp4       += ((cAliasSF3)->F3_VALIMP4  * nSigno)
			nTDValImp4    	+= ((cAliasSF3)->F3_VALIMP4  * nSigno)
			nDValImp5       += (((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6)*nSigno)
			nTDValImp5      += (((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6)*nSigno)
			nDValImp9       += ((cAliasSF3)->F3_VALIMP9  * nSigno)
			nTDValImp9      += ((cAliasSF3)->F3_VALIMP9  * nSigno)
			nDRetIVA        += nRetIVA
			nTDRetIVA	    += nRetIVA
			nDRetIBB        += nRetIBB
			nTDRetIBB       += nRetIBB
			nDExento        += ((cAliasSF3)->F3_EXENTAS  * nSigno)
			nTDExento       += ((cAliasSF3)->F3_EXENTAS  * nSigno)
			nDImpTotal      += (nValBrut				 * nSigno)
			nTDImpTotal     += (nValBrut				 * nSigno)
		Else //Acumula valores referente a Notas Fiscais/Fatura
			nFValMerc    	+= (nValMerc				 * nSigno)
			nTFVALMERC 		+= (nValMerc				 * nSigno)
			nFValImp1       += ((cAliasSF3)->F3_VALIMP1  * nSigno)
			nTFValImp1      += ((cAliasSF3)->F3_VALIMP1  * nSigno)
			nFValImp2       += ((cAliasSF3)->F3_VALIMP2  * nSigno)
			nTFValImp2      += ((cAliasSF3)->F3_VALIMP2  * nSigno)
			nFValImp3       += ((cAliasSF3)->F3_VALIMP3  * nSigno)
			nTFValImp3      += ((cAliasSF3)->F3_VALIMP3  * nSigno)
			nFValImp7       += ((cAliasSF3)->F3_VALIMP7  * nSigno)
			nTFValImp7      += ((cAliasSF3)->F3_VALIMP7  * nSigno)
			nFValImp8       += ((cAliasSF3)->F3_VALIMP8  * nSigno)
			nTFValImp8      += ((cAliasSF3)->F3_VALIMP8  * nSigno)
			nFValImp4       += ((cAliasSF3)->F3_VALIMP4  * nSigno)
			nTFValImp4    	+= ((cAliasSF3)->F3_VALIMP4  * nSigno)
			nFValImp5       += (((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6)*nSigno)
			nTFValImp5      += (((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6)*nSigno)
			nFValImp9       += ((cAliasSF3)->F3_VALIMP9  * nSigno)
			nTFValImp9      += ((cAliasSF3)->F3_VALIMP9  * nSigno)
			nFRetIVA        += nRetIVA
			nTFRetIVA	    += nRetIVA
			nFRetIBB        += nRetIBB
			nTFRetIBB       += nRetIBB
			nFExento  		+= ((cAliasSF3)->F3_EXENTAS	* nSigno)
			nTFExento  		+= ((cAliasSF3)->F3_EXENTAS	* nSigno)
			nFImpTotal      += (nValBrut			    * nSigno)
			nTFImpTotal     += (nValBrut			    * nSigno)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄp
		//³Busca y discrimina por tipo de cliente (Si esta cargada la tabla de tipos en el SX5).³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄp
		If lTipos       // Monta o resumo por Condicao Fiscal(Tipo de Proveedor)
			nTipo := AScan( aTipos,{|X| alltrim(x[1])==Alltrim(SA2->A2_TIPO) })
			If nTipo == 0
				aTotCFis[Len(aTotCFis)][1]:=	aTotCFis[Len(aTotCFis)][1] + (nSigno *nValMerc)
				aTotCFis[Len(aTotCFis)][2]:=	aTotCFis[Len(aTotCFis)][2] + (nSigno *(cAliasSF3)->F3_VALIMP1)
				aTotCFis[Len(aTotCFis)][3]:=	aTotCFis[Len(aTotCFis)][3] + (nSigno *(cAliasSF3)->F3_VALIMP2)
				aTotCFis[Len(aTotCFis)][4]:=	aTotCFis[Len(aTotCFis)][4] + (nSigno *(cAliasSF3)->F3_VALIMP3)
				aTotCFis[Len(aTotCFis)][5]:=	aTotCFis[Len(aTotCFis)][5] + (nSigno *(cAliasSF3)->F3_VALIMP7)
				aTotCFis[Len(aTotCFis)][6]:=	aTotCFis[Len(aTotCFis)][6] + (nSigno *(cAliasSF3)->F3_VALIMP8)
				aTotCFis[Len(aTotCFis)][7]:=	aTotCFis[Len(aTotCFis)][7] + (nSigno *(cAliasSF3)->F3_VALIMP4)
				aTotCFis[Len(aTotCFis)][8]:=	aTotCFis[Len(aTotCFis)][8] + (nSigno *((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6))
				aTotCFis[Len(aTotCFis)][9]:=	aTotCFis[Len(aTotCFis)][9] + (nSigno *(cAliasSF3)->F3_VALIMP9)
				aTotCFis[Len(aTotCFis)][10]:=	aTotCFis[Len(aTotCFis)][10]+ (nSigno *nRetIVA)
				aTotCFis[Len(aTotCFis)][11]:=	aTotCFis[Len(aTotCFis)][11]+ (nSigno *nRetIBB)
				aTotCFis[Len(aTotCFis)][12]:=	aTotCFis[Len(aTotCFis)][12]+ (nSigno *(cAliasSF3)->F3_EXENTAS)
				aTotCFis[Len(aTotCFis)][13]:=	aTotCFis[Len(aTotCFis)][13]+ (nSigno *nValBrut)
			Else
				aTotCFis[nTipo][1]:=	aTotCFis[nTipo][1] + (nSigno *nValMerc)
				aTotCFis[nTipo][2]:=	aTotCFis[nTipo][2] + (nSigno *(cAliasSF3)->F3_VALIMP1)
				aTotCFis[nTipo][3]:=	aTotCFis[nTipo][3] + (nSigno *(cAliasSF3)->F3_VALIMP2)
				aTotCFis[nTipo][4]:=	aTotCFis[nTipo][4] + (nSigno *(cAliasSF3)->F3_VALIMP3)
				aTotCFis[nTipo][5]:=	aTotCFis[nTipo][5] + (nSigno *(cAliasSF3)->F3_VALIMP7)
				aTotCFis[nTipo][6]:=	aTotCFis[nTipo][6] + (nSigno *(cAliasSF3)->F3_VALIMP8)
				aTotCFis[nTipo][7]:=	aTotCFis[nTipo][7] + (nSigno *(cAliasSF3)->F3_VALIMP4)
				aTotCFis[nTipo][8]:=	aTotCFis[nTipo][8] + (nSigno *((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6))
				aTotCFis[nTipo][9]:=	aTotCFis[nTipo][9] + (nSigno *(cAliasSF3)->F3_VALIMP9)   
				aTotCFis[nTipo][10]:=	aTotCFis[nTipo][10]+ (nSigno *nRetIVA)
				aTotCFis[nTipo][11]:=	aTotCFis[nTipo][11]+ (nSigno *nRetIBB)
				aTotCFis[nTipo][12]:=	aTotCFis[nTipo][12] +(nSigno *(cAliasSF3)->F3_EXENTAS)
				aTotCFis[nTipo][13]:=	aTotCFis[nTipo][13]+ (nSigno *nValBrut)
			Endif
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄp
		//³Busca y discrimina por Provincia (Si esta cargada la tabla de Provincia en el SX5).  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄp
		If lProvincia       // Monta o resumo por Provincia (UF do Proveedor )
			nTipo := AScan( aProvincia,{|X| alltrim(x[1])==Alltrim(SA2->A2_EST) })
			If nTipo == 0
				aTotProv[Len(aTotProv)][1]:=	aTotProv[Len(aTotProv)][1] + (nSigno *nValMerc)
				aTotProv[Len(aTotProv)][2]:=	aTotProv[Len(aTotProv)][2] + (nSigno *(cAliasSF3)->F3_VALIMP1)
				aTotProv[Len(aTotProv)][3]:=	aTotProv[Len(aTotProv)][3] + (nSigno *(cAliasSF3)->F3_VALIMP2)
				aTotProv[Len(aTotProv)][4]:=	aTotProv[Len(aTotProv)][4] + (nSigno *(cAliasSF3)->F3_VALIMP3)
				aTotProv[Len(aTotProv)][5]:=	aTotProv[Len(aTotProv)][5] + (nSigno *(cAliasSF3)->F3_VALIMP7)
				aTotProv[Len(aTotProv)][6]:=	aTotProv[Len(aTotProv)][6] + (nSigno *(cAliasSF3)->F3_VALIMP8)
				aTotProv[Len(aTotProv)][7]:=	aTotProv[Len(aTotProv)][7] + (nSigno *(cAliasSF3)->F3_VALIMP4)
				aTotProv[Len(aTotProv)][8]:=	aTotProv[Len(aTotProv)][8] + (nSigno *((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6))
				aTotProv[Len(aTotProv)][9]:=	aTotProv[Len(aTotProv)][9] + (nSigno *(cAliasSF3)->F3_VALIMP9)   
				aTotProv[Len(aTotProv)][10]:=	aTotProv[Len(aTotProv)][10]+ (nSigno *nRetIVA)
				aTotProv[Len(aTotProv)][11]:=	aTotProv[Len(aTotProv)][11]+ (nSigno *nRetIBB)
				aTotProv[Len(aTotProv)][12]:=	aTotProv[Len(aTotProv)][12]+ (nSigno*(cAliasSF3)->F3_EXENTAS)
				aTotProv[Len(aTotProv)][13]:=	aTotProv[Len(aTotProv)][13]+ (nSigno *nValBrut)
			Else
				aTotProv[nTipo][1]:=	aTotProv[nTipo][1] + (nSigno *nValMerc)
				aTotProv[nTipo][2]:=	aTotProv[nTipo][2] + (nSigno *(cAliasSF3)->F3_VALIMP1)
				aTotProv[nTipo][3]:=	aTotProv[nTipo][3] + (nSigno *(cAliasSF3)->F3_VALIMP2)
				aTotProv[nTipo][4]:=	aTotProv[nTipo][4] + (nSigno *(cAliasSF3)->F3_VALIMP3)
				aTotProv[nTipo][5]:=	aTotProv[nTipo][5] + (nSigno *(cAliasSF3)->F3_VALIMP7)
				aTotProv[nTipo][6]:=	aTotProv[nTipo][6] + (nSigno *(cAliasSF3)->F3_VALIMP8)
				aTotProv[nTipo][7]:=	aTotProv[nTipo][7] + (nSigno *(cAliasSF3)->F3_VALIMP4)
				aTotProv[nTipo][8]:=	aTotProv[nTipo][8] + (nSigno *((cAliasSF3)->F3_VALIMP5+(cAliasSF3)->F3_VALIMP6))
				aTotProv[nTipo][9]:=	aTotProv[nTipo][9] + (nSigno *(cAliasSF3)->F3_VALIMP9)   
				aTotProv[nTipo][10]:=	aTotProv[nTipo][10]+ (nSigno *nRetIVA)
				aTotProv[nTipo][11]:=	aTotProv[nTipo][11]+ (nSigno *nRetIBB)
				aTotProv[nTipo][12]:=	aTotProv[nTipo][12] +(nSigno *(cAliasSF3)->F3_EXENTAS)
				aTotProv[nTipo][13]:=	aTotProv[nTipo][13]+ (nSigno *nValBrut)
			Endif
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄp
		//³Busca y discrimina por Tipo de Produto (Si esta cargada la tabla de Tipo Materiales en el SX5).  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄp
		If Alltrim((cAliasSF3)->F3_ESPECIE) =="NCP"
			cChave := xFilial("SD2")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA
		Else
			cChave := xFilial("SD1")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA
		EndIf
		
		If (cAliasSF3)->F3_TIPO+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA # cNotaAnt
			If lProduto
				If Alltrim((cAliasSF3)->F3_ESPECIE) =="NCP"
					SD2->( dbSetOrder(3) )
					SD2->( dbSeek( xFilial("SD2")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA) )
					While !Eof() .And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA ==;
						xFilial("SD2")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA
						
						nTipo := AScan( aProduto,{|X| alltrim(x[1])==Alltrim(SD2->D2_TP) })
						nValImp := SD2->D2_VALIMP1+SD2->D2_VALIMP2+SD2->D2_VALIMP3+SD2->D2_VALIMP7+;
						SD2->D2_VALIMP8+SD2->D2_VALIMP4+SD2->D2_VALIMP5+SD2->D2_VALIMP6+SD2->D2_VALIMP9
						nValBrut:= SD2->D2_TOTAL+SD2->D2_VALFRE+SD2->D2_SEGURO+SD2->D2_DESPESA
						nValBrut := nSigno * (nValBrut + nValImp)
						If nTipo == 0
							aTotTPProd[Len(aTotTPProd)][1]:=	aTotTPProd[Len(aTotTPProd)][1] + (nSigno *xMoeda(SD2->D2_TOTAL,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][2]:=	aTotTPProd[Len(aTotTPProd)][2] + (nSigno *xMoeda(SD2->D2_VALIMP1,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][3]:=	aTotTPProd[Len(aTotTPProd)][3] + (nSigno *xMoeda(SD2->D2_VALIMP2,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][4]:=	aTotTPProd[Len(aTotTPProd)][4] + (nSigno *xMoeda(SD2->D2_VALIMP3,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][5]:=	aTotTPProd[Len(aTotTPProd)][5] + (nSigno *xMoeda(SD2->D2_VALIMP7,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][6]:=	aTotTPProd[Len(aTotTPProd)][6] + (nSigno *xMoeda(SD2->D2_VALIMP8,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][7]:=	aTotTPProd[Len(aTotTPProd)][7] + (nSigno *xMoeda(SD2->D2_VALIMP4,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][8]:=	aTotTPProd[Len(aTotTPProd)][8] + (nSigno *xMoeda((SD2->D2_VALIMP5+SD2->D2_VALIMP6),nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][9]:=	aTotTPProd[Len(aTotTPProd)][9] + (nSigno *xMoeda(SD2->D2_VALIMP9,nMoeda,1,dDigita,nDecs+1,nTaxa))
						    aTotTPPROD[Len(aTotTPPROD)][10]:=	aTotTPProd[Len(aTotTPProd)][10]+ (nSigno *nRetIVA)
							aTotTPProd[Len(aTotTPProd)][11]:=	aTotTPProd[Len(aTotTPProd)][11]+ (nSigno *nRetIBB)
							aTotTPProd[Len(aTotTPProd)][13]:=	aTotTPProd[Len(aTotTPProd)][13]+ xMoeda(nValBrut,nMoeda,1,dDigita,nDecs+1,nTaxa)
						Else
							aTotTPProd[nTipo][1]:=	aTotTPProd[nTipo][1] + (nSigno *xMoeda(SD2->D2_TOTAL,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][2]:=	aTotTPProd[nTipo][2] + (nSigno *xMoeda(SD2->D2_VALIMP1,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][3]:=	aTotTPProd[nTipo][3] + (nSigno *xMoeda(SD2->D2_VALIMP2,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][4]:=	aTotTPProd[nTipo][4] + (nSigno *xMoeda(SD2->D2_VALIMP3,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][5]:=	aTotTPProd[nTipo][5] + (nSigno *xMoeda(SD2->D2_VALIMP7,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][6]:=	aTotTPProd[nTipo][6] + (nSigno *xMoeda(SD2->D2_VALIMP8,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][7]:=	aTotTPProd[nTipo][7] + (nSigno *xMoeda(SD2->D2_VALIMP4,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][8]:=	aTotTPProd[nTipo][8] + (nSigno *xMoeda((SD2->D2_VALIMP5+SD2->D2_VALIMP6),nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][9]:=	aTotTPProd[nTipo][9] + (nSigno *xMoeda(SD2->D2_VALIMP9,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][10]:=	aTotTPProd[nTipo][10]+ (nSigno *nRetIVA)
							aTotTPProd[nTipo][11]:=	aTotTPProd[nTipo][11]+ (nSigno *nRetIBB)
							aTotTPProd[nTipo][13]:=	aTotTPProd[nTipo][13]+ xMoeda(nValBrut,nMoeda,1,dDigita,nDecs+1,nTaxa)
						Endif
						SD2->(DbSkip())
					End
				Else
					SD1->( dbSetOrder(1) )
					SD1->( dbSeek( xFilial("SD1")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA) )
					While !Eof() .And. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA ==;
						xFilial("SD1")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA
						
						nTipo := AScan( aProduto,{|X| alltrim(x[1])==Alltrim(SD1->D1_TP) })
						nValImp := SD1->D1_VALIMP1+SD1->D1_VALIMP2+SD1->D1_VALIMP3+SD1->D1_VALIMP7+;
						SD1->D1_VALIMP8+SD1->D1_VALIMP4+SD1->D1_VALIMP5+SD1->D1_VALIMP6+SD1->D1_VALIMP9
						nValBrut:= SD1->D1_TOTAL+SD1->D1_VALFRE+SD1->D1_SEGURO+SD1->D1_DESPESA
						nValBrut := nSigno * (nValBrut + nValImp)
						If nTipo == 0
							aTotTPProd[Len(aTotTPProd)][1]:=	aTotTPProd[Len(aTotTPProd)][1] + (nSigno *xMoeda(SD1->D1_TOTAL,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][2]:=	aTotTPProd[Len(aTotTPProd)][2] + (nSigno *xMoeda(SD1->D1_VALIMP1,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][3]:=	aTotTPProd[Len(aTotTPProd)][3] + (nSigno *xMoeda(SD1->D1_VALIMP2,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][4]:=	aTotTPProd[Len(aTotTPProd)][4] + (nSigno *xMoeda(SD1->D1_VALIMP3,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][5]:=	aTotTPProd[Len(aTotTPProd)][5] + (nSigno *xMoeda(SD1->D1_VALIMP7,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][6]:=	aTotTPProd[Len(aTotTPProd)][6] + (nSigno *xMoeda(SD1->D1_VALIMP8,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][7]:=	aTotTPProd[Len(aTotTPProd)][7] + (nSigno *xMoeda(SD1->D1_VALIMP4,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][8]:=	aTotTPProd[Len(aTotTPProd)][8] + (nSigno *xMoeda((SD1->D1_VALIMP5+SD1->D1_VALIMP6),nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[Len(aTotTPProd)][9]:=	aTotTPProd[Len(aTotTPProd)][9] + (nSigno *xMoeda(SD1->D1_VALIMP9,nMoeda,1,dDigita,nDecs+1,nTaxa))
						    aTotTPPROD[Len(aTotTPPROD)][10]:=	aTotTPProd[Len(aTotTPProd)][10]+ (nSigno *nRetIVA)
							aTotTPProd[Len(aTotTPProd)][11]:=	aTotTPProd[Len(aTotTPProd)][11]+ (nSigno *nRetIBB)
							aTotTPProd[Len(aTotTPProd)][13]:=	aTotTPProd[Len(aTotTPProd)][13]+ xMoeda(nValBrut,nMoeda,1,SD1->D1_DTDIGIT,nDecs+1,nTaxa)
						Else
							aTotTPProd[nTipo][1]:=	aTotTPProd[nTipo][1] + (nSigno *xMoeda(SD1->D1_TOTAL,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][2]:=	aTotTPProd[nTipo][2] + (nSigno *xMoeda(SD1->D1_VALIMP1,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][3]:=	aTotTPProd[nTipo][3] + (nSigno *xMoeda(SD1->D1_VALIMP2,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][4]:=	aTotTPProd[nTipo][4] + (nSigno *xMoeda(SD1->D1_VALIMP3,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][5]:=	aTotTPProd[nTipo][5] + (nSigno *xMoeda(SD1->D1_VALIMP7,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][6]:=	aTotTPProd[nTipo][6] + (nSigno *xMoeda(SD1->D1_VALIMP8,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][7]:=	aTotTPProd[nTipo][7] + (nSigno *xMoeda(SD1->D1_VALIMP4,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][8]:=	aTotTPProd[nTipo][8] + (nSigno *xMoeda((SD1->D1_VALIMP5+SD1->D1_VALIMP6),nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][9]:=	aTotTPProd[nTipo][9] + (nSigno *xMoeda(SD1->D1_VALIMP9,nMoeda,1,dDigita,nDecs+1,nTaxa))
							aTotTPProd[nTipo][10]:=	aTotTPProd[nTipo][10]+ (nSigno *nRetIVA)
							aTotTPProd[nTipo][11]:=	aTotTPProd[nTipo][11]+ (nSigno *nRetIBB)
							aTotTPProd[nTipo][13]:=	aTotTPProd[nTipo][13]+ xMoeda(nValBrut,nMoeda,1,dDigita,nDecs+1,nTaxa)
						Endif
						SD1->(DbSkip())
					End
				EndIf
			EndIf
		EndIf
		cNotaAnt	:= (cAliasSF3)->F3_TIPO+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA
	EndIf
	nLin := nLin + 1
	(cAliasSF3)->(dbSkip())
	lImpTDia := .F.  //Flag de controle de quebra por dia
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dispara a funcao para impressao dos Totalizadores.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( mv_par04 == 1 .And. !lImpTDia )
	RaR1TotDia()   // Imprime o sub total do dia
EndIf

RaR1TotPg()   // Imprime o Sub Total Impresso

If mv_par06 == 1
	RaR1Resumo()  // Imprime o resumo do relatorio
EndIf

Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RAR1Cab   ºAutor  ³Gilson da Silva     º Data ³  06/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cabecalho do Libro de IVA ( Compras ).			          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Livros Fiscais                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RAR1Cab()

Local aDriver	:=	ReadDriver()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis utilizadas no cabecalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo    := OemToAnsi(STR0009) //"LIBRO DE  I.V.A. "
cTitulo    := cTitulo + OemToAnsi(STR0010) //"C O M P R A S"
cTitulo    := cTitulo + OemToAnsi(STR0026) //" - Desde : "
cTitulo    := cTitulo + DTOC(mv_par01)
cTitulo    := cTitulo + OemToAnsi(STR0027) //"   Hasta : "
cTitulo    := cTitulo + DTOC(mv_par02)
cEmpresa   := SM0->M0_NOMECOM
cInscr     := InscrEst()
cCUIT	   := TRANSFORM(SM0->M0_CGC,"@R 99-99.999.999-9")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabecalho para o Relatorio.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPagina := nPagina + 1
If nPagina > MV_PAR08
	nPagina := MV_PAR09
	nPagIni := MV_PAR09
endif

@ 00,000 PSAY &(aDriver[5])
@ 02,000 PSAY OemToAnsi(STR0011) //"Empresa: "
@ 02,020 PSAY cEmpresa
@ 03,000 PSAY OemToAnsi(STR0012) //"Pagina Nro.: "
@ 03,014 PSAY StrZero(nPagina,6)
@ 05,000 PSAY cTitulo
@ 07,000 PSAY OemToAnsi(STR0013)  //"Tipo  Serie  Comprobante     Razon Social          C.U.I.T.       Neto Gravado  I VA R.G.   IVA. R.N.I IVA SERVIC. IVA BS.CAP.     IVA R.E.  PERCEP.IVA PERCEP.IIBB PERCEP.GAN.  RET. IVA.   RET. IIBB     EXENTO       TOTAL"
nLin := 08      
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RAR1TotDiaºAutor  ³Gilson da Silva   º Data ³  06/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rodape do Libro de IVA Compras .  	              		º±±
±±º          ³                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Livros Fiscais                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RaR1TotDia(lRelease4)

Local nLinha 	:= 0

Default lRelease4 := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dispara a funcao para impressao do Total do dia.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lImpTDia	:= .T.  //Flag para controlar se imprimiu a quebra por dia

If lRelease4

	nTNETO		:= nFValMerc
	nTIVARG		:= nFValImp1
	nTIVASERV	:= nFValImp3
	nTIVABSCAP	:= nFValImp7
	nTIVARE		:= nFValImp8
	nTPERCIVA	:= nFValImp4
	nTPERCIIBB	:= nFValImp5
	nTPERCGAN	:= nFValImp9
	nTRETIVA	:= nFRetIVA
	nTRETIIBB	:= nFRetIBB
	nTEXENTO	:= nFExento
	nTTOTAL		:= nFImpTotal
	
	If (nTNETO+nTIVARG+nTIVARNI+nTIVASERV+nTIVABSCAP+nTIVARE+nTPERCIVA+nTPERCIIBB+nTPERCGAN+nTRETIVA+nTRETIIBB+nTEXENTO+nTTOTAL) <> 0
		oReport:SkipLine()
		nLinha := oReport:nRow		
		oReport:PrintText(Space(10)+OemToAnsi("Sub Total Facturas           : ")+OemToAnsi("Sub Total Facturas           : "),nLinha)	//"Sub Total Facturas           : "
	
		oReport:Section(2):Cell("F3_ENTRADA"):Hide()
		oReport:Section(2):Cell("F3_ESPECIE"):Hide()
		oReport:Section(2):Cell("F3_SERIE"):Hide()
		oReport:Section(2):Cell("F3_NFISCAL"):Hide()
		oReport:Section(2):Cell("A2_NOME"):Hide()
		oReport:Section(2):Cell("A2_CGC"):Hide()

		oReport:Section(2):Init()
		oReport:Section(2):PrintLine()
		oReport:Section(2):Finish()
	Endif

	nTNETO		:= nDValMerc
	nTIVARG		:= nDValImp1
	nTIVASERV	:= nDValImp3
	nTIVABSCAP	:= nDValImp7
	nTIVARE		:= nDValImp8
	nTPERCIVA	:= nDValImp4
	nTPERCIIBB	:= nDValImp5
	nTPERCGAN	:= nDValImp9
	nTRETIVA	:= nDRetIVA
	nTRETIIBB	:= nDRetIBB
	nTEXENTO	:= nDExento
	nTTOTAL		:= nDImpTotal

	If (nTNETO+nTIVARG+nTIVARNI+nTIVASERV+nTIVABSCAP+nTIVARE+nTPERCIVA+nTPERCIIBB+nTPERCGAN+nTRETIVA+nTRETIIBB+nTEXENTO+nTTOTAL) <> 0
		oReport:SkipLine()
		nLinha := oReport:nRow		
		oReport:PrintText(Space(10)+OemToAnsi("Sub Total Notas de Debito    : "),nLinha)	//"Sub Total Notas de Debito    : "

		oReport:Section(2):Init()
		oReport:Section(2):PrintLine()
		oReport:Section(2):Finish()
	Endif

	nTNETO		:= nCValMerc
	nTIVARG		:= nCValImp1
	nTIVASERV	:= nCValImp3
	nTIVABSCAP	:= nCValImp7
	nTIVARE		:= nCValImp8
	nTPERCIVA	:= nCValImp4
	nTPERCIIBB	:= nCValImp5
	nTPERCGAN	:= nCValImp9
	nTRETIVA	:= nCRetIVA
	nTRETIIBB	:= nCRetIBB
	nTEXENTO	:= nCExento
	nTTOTAL		:= nCImpTotal

	If (nTNETO+nTIVARG+nTIVARNI+nTIVASERV+nTIVABSCAP+nTIVARE+nTPERCIVA+nTPERCIIBB+nTPERCGAN+nTRETIVA+nTRETIIBB+nTEXENTO+nTTOTAL) <> 0
		oReport:SkipLine()
		nLinha := oReport:nRow		
		oReport:PrintText(Space(10)+OemToAnsi("Sub Total Notas de Credito   : "),nLinha)	//"Sub Total Notas de Credito   : "

		oReport:Section(2):Init()
		oReport:Section(2):PrintLine()
		oReport:Section(2):Finish()
	Endif
	
Else

	nLin := nLin + 1
	@ nLin,001 PSAY OemToAnsi(STR0028)+OemToAnsi(STR0016) //"Sub Total Facturas           : "
	@ nLin,064 PSAY nFValMerc	      	Picture cPictVals
	@ nLin,079 PSAY nFValImp1			Picture cPictImp
	@ nLin,090 PSAY nFValImp2			Picture cPictImp
	@ nLin,101 PSAY nFValImp3			Picture cPictImp
	@ nLin,112 PSAY nFValImp7			Picture cPictImp
	@ nLin,123 PSAY nFValImp8			Picture cPictImp
	@ nLin,134 PSAY nFValImp4			Picture cPictImp
	@ nLin,145 PSAY nFValImp5           Picture cPictImp
	@ nLin,156 PSAY nFValImp9			Picture cPictImp
	@ nLin,167 PSAY nFRetIVA			Picture cPictImp
	@ nLin,178 PSAY nFRetIBB			Picture cPictImp
	@ nLin,190 PSAY nFExento			Picture cPictVals
	@ nLin,207 PSAY nFImpTotal			Picture cPictVals
	
	nLin := nLin +1
	@ nLin,001 PSAY OemToAnsi(STR0028)+OemToAnsi(STR0018) //"Sub Total Notas de Debito    : "
	@ nLin,064 PSAY nDValMerc	      	Picture cPictVals
	@ nLin,079 PSAY nDValImp1			Picture cPictImp
	@ nLin,090 PSAY nDValImp2			Picture cPictImp
	@ nLin,101 PSAY nDValImp3			Picture cPictImp
	@ nLin,112 PSAY nDValImp7			Picture cPictImp
	@ nLin,123 PSAY nDValImp8			Picture cPictImp
	@ nLin,134 PSAY nDValImp4			Picture cPictImp
	@ nLin,145 PSAY nDValImp5           Picture cPictImp
	@ nLin,156 PSAY nDValImp9			Picture cPictImp
	@ nLin,167 PSAY nDRetIVA			Picture cPictImp
	@ nLin,178 PSAY nDRetIBB			Picture cPictImp
	@ nLin,190 PSAY nDExento			Picture cPictVals
	@ nLin,207 PSAY nDImpTotal			Picture cPictVals
	
	nLin := nLin +1
	@ nLin,001 PSAY OemToAnsi(STR0028)+OemToAnsi(STR0017) //"Sub Total Notas de Credito   : "
	@ nLin,064 PSAY nCValMerc	      	Picture cPictVals
	@ nLin,079 PSAY nCValImp1			Picture cPictImp
	@ nLin,090 PSAY nCValImp2			Picture cPictImp
	@ nLin,101 PSAY nCValImp3			Picture cPictImp
	@ nLin,112 PSAY nCValImp7			Picture cPictImp
	@ nLin,123 PSAY nCValImp8			Picture cPictImp
	@ nLin,134 PSAY nCValImp4			Picture cPictImp
	@ nLin,145 PSAY nCValImp5           Picture cPictImp
	@ nLin,156 PSAY nCValImp9			Picture cPictImp
	@ nLin,167 PSAY nCRetIVA			Picture cPictImp
	@ nLin,178 PSAY nCRetIBB			Picture cPictImp
	@ nLin,190 PSAY nCExento			Picture cPictVals
	@ nLin,207 PSAY nCImpTotal			Picture cPictVals
	nLin := nLin +1

Endif

// zera as variaveis de sub totais
nFVALMERC :=0
nDVALMERC :=0
nCVALMERC :=0

nFValImp1 :=0
nDValImp1 :=0
nCValImp1 :=0

nFValImp2 :=0
nDValImp2 :=0
nCValImp2 :=0

nFValImp3 :=0
nDValImp3 :=0
nCValImp3 :=0

nFValImp7 :=0
nDValImp7 :=0
nCValImp7 :=0

nFValImp8 :=0
nDValImp8 :=0
nCValImp8 :=0

nFValImp4 :=0
nDValImp4 :=0
nCValImp4 :=0

nFValImp5 :=0
nDValImp5 :=0
nCValImp5 :=0

nFValImp9 :=0
nDValImp9 :=0
nCValImp9 :=0

nFRetIVA  :=0
nDRetIVA  :=0
nCRetIVA  :=0

nFRetIBB  :=0
nDRetIBB  :=0
nCRetIBB  :=0

nFExento  :=0
nDExento  :=0
nCExento  :=0

nFImpTotal:=0
nDImpTotal:=0
nCImpTotal:=0

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RaR1TotPg   ºAutor  ³Gilson da Silva   º Data ³  06/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Totaliza pagina do Libro de IVA ( Compras  ).              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Livros Fiscais                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RaR1TotPg(lRelease4)

Local nLinha := 0

Default lRelease4 := .F.

If lRelease4

	nTNETO		:= nTFValMerc
	nTIVARG		:= nTFValImp1
	nTIVASERV	:= nTFValImp3
	nTIVABSCAP	:= nTFValImp7
	nTIVARE		:= nTFValImp8
	nTPERCIVA	:= nTFValImp4
	nTPERCIIBB	:= nTFValImp5
	nTPERCGAN	:= nTFValImp9
	nTRETIVA	:= nTFRetIVA
	nTRETIIBB	:= nTFRetIBB
	nTEXENTO	:= ntFExento
	nTTOTAL		:= nTFImpTotal

	If (nTNETO+nTIVARG+nTIVARNI+nTIVASERV+nTIVABSCAP+nTIVARE+nTPERCIVA+nTPERCIIBB+nTPERCGAN+nTRETIVA+nTRETIIBB+nTEXENTO+nTTOTAL) <> 0
		oReport:SkipLine()
		nLinha := oReport:nRow		
		oReport:PrintText(Space(20)+OemToAnsi("Totales por Tipo Tipo de Documento :"),nLinha) 			//"Totales por Tipo Tipo de Documento :"
	
		oReport:SkipLine()
		nLinha := oReport:nRow		
		oReport:PrintText(Space(30)+OemToAnsi("Total Facturas           : "),nLinha)	//"Total Facturas           : "
	
		oReport:Section(2):Cell("F3_ENTRADA"):Hide()
		oReport:Section(2):Cell("F3_ESPECIE"):Hide()
		oReport:Section(2):Cell("F3_SERIE"):Hide()
		oReport:Section(2):Cell("F3_NFISCAL"):Hide()
		oReport:Section(2):Cell("A2_NOME"):Hide()
		oReport:Section(2):Cell("A2_CGC"):Hide()
	
		oReport:Section(2):Init()
		oReport:Section(2):PrintLine()
		oReport:Section(2):Finish()
	Endif

	nTNETO		:= nTDValMerc
	nTIVASERV	:= nTDValImp3
	nTIVABSCAP	:= nTDValImp7
	nTIVARE		:= nTDValImp8
	nTPERCIVA	:= nTDValImp4
	nTPERCIIBB	:= nTDValImp5
	nTPERCGAN	:= nTDValImp9
	nTRETIVA	:= nTDRetIVA
	nTRETIIBB	:= nTDRetIBB
	nTEXENTO	:= nTDExento
	nTTOTAL		:= nTDImpTotal

	If (nTNETO+nTIVARG+nTIVARNI+nTIVASERV+nTIVABSCAP+nTIVARE+nTPERCIVA+nTPERCIIBB+nTPERCGAN+nTRETIVA+nTRETIIBB+nTEXENTO+nTTOTAL) <> 0
		oReport:SkipLine()
		nLinha := oReport:nRow		
		oReport:PrintText(Space(30)+OemToAnsi("Total Notas de Debito    : "),nLinha)	//"Total Notas de Debito    : "

		oReport:Section(2):Init()
		oReport:Section(2):PrintLine()
		oReport:Section(2):Finish()
	Endif
	
	nTNETO		:= nTCValMerc
	nTIVARG		:= nTCValImp1
	nTIVASERV	:= nTCValImp3
	nTIVABSCAP	:= nTCValImp7
	nTIVARE		:= nTCValImp8
	nTPERCIVA	:= nTCValImp4
	nTPERCIIBB	:= nTCValImp5
	nTPERCGAN	:= nTCValImp9
	nTRETIVA	:= nTCRetIVA
	nTRETIIBB	:= nTCRetIBB
	nTEXENTO	:= nTCExento
	nTTOTAL		:= nTCImpTotal

	If (nTNETO+nTIVARG+nTIVARNI+nTIVASERV+nTIVABSCAP+nTIVARE+nTPERCIVA+nTPERCIIBB+nTPERCGAN+nTRETIVA+nTRETIIBB+nTEXENTO+nTTOTAL) <> 0
		oReport:SkipLine()
		nLinha := oReport:nRow		
		oReport:PrintText(Space(30)+OemToAnsi("Total Notas de Credito   : "),nLinha)	//"Total Notas de Credito   : "

		oReport:Section(2):Init()
		oReport:Section(2):PrintLine()
		oReport:Section(2):Finish()
	Endif
		
	nTNETO		:= (nTFValMerc+nTDValMerc+nTCValMerc)
	nTIVARG		:= (nTFValImp1+nTDValImp1+nTCValImp1)
	nTIVASERV	:= (nTFValImp3+nTDValImp3+nTCValImp3)
	nTIVABSCAP	:= (nTFValImp7+nTDValImp7+nTCValImp7)
	nTIVARE		:= (nTFValImp8+nTDValImp8+nTCValImp8)
	nTPERCIVA	:= (nTFValImp4+nTDValImp4+nTCValImp4)
	nTPERCIIBB	:= (nTFValImp5+nTDValImp5+nTCValImp5)
	nTPERCGAN	:= (nTFValImp9+nTDValImp9+nTCValImp9)
	nTRETIVA	:= (nTFRetIVA+nTDRetIVA+nTCRetIVA)
	nTRETIIBB	:= (nTFRetIBB+nTDRetIBB+nTCRetIBB)
	nTEXENTO	:= (nTFExento+nTDExento+nTCExento)
	nTTOTAL		:= (nTFImpTotal+nTDImpTotal+nTCImpTotal)

	If (nTNETO+nTIVARG+nTIVARNI+nTIVASERV+nTIVABSCAP+nTIVARE+nTPERCIVA+nTPERCIIBB+nTPERCGAN+nTRETIVA+nTRETIIBB+nTEXENTO+nTTOTAL) <> 0
		oReport:SkipLine(2)
		nLinha := oReport:nRow		
		oReport:PrintText(Space(20)+OemToAnsi("Totales Generales :"),nLinha)	//"Totales Generales :"
		oReport:SkipLine()
		nLinha := oReport:nRow		
		oReport:PrintText(Space(30)+OemToAnsi("Total General :"),nLinha)	//"Total General :"

		oReport:Section(2):Init()
		oReport:Section(2):PrintLine()
		oReport:Section(2):Finish()
	Endif
		
Else

	nLin := nLin + 1
	@ nLin,015 PSAY OemToAnsi(STR0019) // "Totales por Tipo Tipo de Documento :"
	nLin := nLin + 1
	@ nLin,030 PSAY OemToAnsi(STR0016) //"Total Facturas           : "
	@ nLin,064 PSAY nTFValMerc	      	Picture cPictVals
	@ nLin,079 PSAY nTFValImp1			Picture cPictImp
	@ nLin,090 PSAY nTFValImp2			Picture cPictImp
	@ nLin,101 PSAY nTFValImp3			Picture cPictImp
	@ nLin,112 PSAY nTFValImp7			Picture cPictImp
	@ nLin,123 PSAY nTFValImp8			Picture cPictImp
	@ nLin,134 PSAY nTFValImp4			Picture cPictImp
	@ nLin,145 PSAY nTFValImp5          Picture cPictImp
	@ nLin,156 PSAY nTFValImp9			Picture cPictImp
	@ nLin,167 PSAY nTFRetIVA   		Picture cPictImp
	@ nLin,178 PSAY nTFRetIBB			Picture cPictImp
	@ nLin,190 PSAY ntFExento			Picture cPictVals
	@ nLin,207 PSAY nTFImpTotal			Picture cPictVals
	
	nLin := nLin +1
	@ nLin,030 PSAY OemToAnsi(STR0018) //"Total Notas de Debito    : "
	@ nLin,064 PSAY nTDValMerc	      	Picture cPictVals
	@ nLin,079 PSAY nTDValImp1			Picture cPictImp
	@ nLin,090 PSAY nTDValImp2			Picture cPictImp
	@ nLin,101 PSAY nTDValImp3			Picture cPictImp
	@ nLin,112 PSAY nTDValImp7			Picture cPictImp
	@ nLin,123 PSAY nTDValImp8			Picture cPictImp
	@ nLin,134 PSAY nTDValImp4			Picture cPictImp
	@ nLin,145 PSAY nTDValImp5          Picture cPictImp
	@ nLin,156 PSAY nTDValImp9			Picture cPictImp
	@ nLin,167 PSAY nTDRetIVA			Picture cPictImp
	@ nLin,178 PSAY nTDRetIBB			Picture cPictImp
	@ nLin,190 PSAY nTDExento			Picture cPictVals
	@ nLin,207 PSAY nTDImpTotal			Picture cPictVals
	
	nLin := nLin +1
	@ nLin,030 PSAY OemToAnsi(STR0017) //"Total Notas de Credito   : "
	@ nLin,064 PSAY nTCValMerc	      	Picture cPictVals
	@ nLin,079 PSAY nTCValImp1			Picture cPictImp
	@ nLin,090 PSAY nTCValImp2			Picture cPictImp
	@ nLin,101 PSAY nTCValImp3			Picture cPictImp
	@ nLin,112 PSAY nTCValImp7			Picture cPictImp
	@ nLin,123 PSAY nTCValImp8			Picture cPictImp
	@ nLin,134 PSAY nTCValImp4			Picture cPictImp
	@ nLin,145 PSAY nTCValImp5          Picture cPictImp
	@ nLin,156 PSAY nTCValImp9			Picture cPictImp
	@ nLin,167 PSAY nTCRetIVA			Picture cPictImp
	@ nLin,178 PSAY nTCRetIBB			Picture cPictImp
	@ nLin,190 PSAY nTCExento			Picture cPictVals
	@ nLin,207 PSAY nTCImpTotal			Picture cPictVals
	
	nLin := nLin + 2
	@ nLin,015 PSAY OemToAnsi(STR0014) //"Totales Generales :"
	nLin := nLin +1
	@ nLin,030 PSAY OemToAnsi(STR0029) //"Total General :"
	@ nLin,064 PSAY (nTFValMerc+nTDValMerc+nTCValMerc)	      	Picture cPictVals
	@ nLin,079 PSAY (nTFValImp1+nTDValImp1+nTCValImp1)			Picture cPictImp
	@ nLin,090 PSAY (nTFValImp2+nTDValImp2+nTCValImp2)			Picture cPictImp
	@ nLin,101 PSAY (nTFValImp3+nTDValImp3+nTCValImp3)			Picture cPictImp
	@ nLin,112 PSAY (nTFValImp7+nTDValImp7+nTCValImp7)			Picture cPictImp
	@ nLin,123 PSAY (nTFValImp8+nTDValImp8+nTCValImp8)			Picture cPictImp
	@ nLin,134 PSAY (nTFValImp4+nTDValImp4+nTCValImp4)			Picture cPictImp
	@ nLin,145 PSAY (nTFValImp5+nTDValImp5+nTCValImp5)          Picture cPictImp
	@ nLin,156 PSAY (nTFValImp9+nTDValImp9+nTCValImp9)			Picture cPictImp
	@ nLin,167 PSAY (nTFRetIVA+nTDRetIVA+nTCRetIVA)	  			Picture cPictImp
	@ nLin,178 PSAY (nTFRetIBB+nTDRetIBB+nTCRetIBB)	  			Picture cPictImp
	@ nLin,190 PSAY (nTFExento+nTDExento+nTCExento)	   			Picture cPictVals
	@ nLin,207 PSAY (nTFImpTotal+nTDImpTotal+nTCImpTotal)		Picture cPictVals
	nLin := nLin +1

Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RaR1Resumo  ºAutor  ³Gilson da Silva   º Data ³  06/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rodape do Libro de IVA ( Compras  ). 		              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Livros Fiscais                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RaR1Resumo(lRelease4)

Local nQtLinRes	:= 0
Local nX     	:= 0 
Local nD      	:= 0
Local nLinha	:= 0

Default lRelease4 := .F.

If lRelease4

	// TOTALES POR CONDICION FISCAL  
	If lTipos
		nCnt1 := 1
		For nD:=1 To Len(aTotCFis)
			If aTotCFis[nD][1]<>0.00 .Or. aTotCFis[nD][2]<>0.00 .Or. aTotCFis[nD][3] <> 0.00 .Or.;
				aTotCFis[nD][4] <> 0.00 .Or. aTotCFis[nD][5]<>0.00 .Or. aTotCFis[nD][6] <> 0.00 .Or.;
				aTotCFis[nD][7] <> 0.00 .Or. aTotCFis[nD][8]<>0.00 .Or. aTotCFis[nD][9] <> 0.00 .Or.;
				aTotCFis[nD][10] <> 0.00 .Or. aTotCFis[nD][11]<>0.00 .Or. aTotCFis[nD][12] <> 0.00 .Or.;
				aTotCFis[nD][13] <> 0.00

				If nCnt1 == 1
					oReport:SkipLine(2)
					nLinha := oReport:nRow		
					oReport:PrintText(Space(20)+"Totales por Condicion Fiscal ",nLinha)	//"Totales por Condicion Fiscal "
				Endif
				nCnt1++
				
				oReport:SkipLine()
				nLinha := oReport:nRow		
				oReport:PrintText(Space(30)+aTipos[nD][2],nLinha)

				oReport:Section(2):Cell("F3_ENTRADA"):Hide()
				oReport:Section(2):Cell("F3_ESPECIE"):Hide()
				oReport:Section(2):Cell("F3_SERIE"):Hide()
				oReport:Section(2):Cell("F3_NFISCAL"):Hide()
				oReport:Section(2):Cell("A2_NOME"):Hide()
				oReport:Section(2):Cell("A2_CGC"):Hide()
			
				nTNETO		:= aTotCFis[nD][1]
				nTIVARG		:= aTotCFis[nD][2]
				nTIVASERV	:= aTotCFis[nD][4]
				nTIVABSCAP	:= aTotCFis[nD][5]
				nTIVARE		:= aTotCFis[nD][6]
				nTPERCIVA	:= aTotCFis[nD][7]
				nTPERCIIBB	:= aTotCFis[nD][8]
				nTPERCGAN	:= aTotCFis[nD][9]
				nTRETIVA	:= aTotCFis[nD][10]
				nTRETIIBB	:= aTotCFis[nD][11]
				nTEXENTO	:= aTotCFis[nD][12]
				nTTOTAL		:= aTotCFis[nD][13]
			
				oReport:Section(2):Init()
				oReport:Section(2):PrintLine()
				oReport:Section(2):Finish()
				oReport:SkipLine()				
			Endif
		Next
	Endif
	
	// TOTALES POR ZONA FISCAL
	If lProvincia
		nCnt1 := 1
		For nD:=1 To Len(aTotProv)
			If aTotProv[nD][1]<>0.00 .Or. aTotProv[nD][2]<>0.00 .Or. aTotProv[nD][3] <> 0.00 .Or.;
				aTotProv[nD][4] <> 0.00 .Or. aTotProv[nD][5]<>0.00 .Or. aTotProv[nD][6] <> 0.00 .Or.;
				aTotProv[nD][7] <> 0.00 .Or. aTotProv[nD][8]<>0.00 .Or. aTotProv[nD][9] <> 0.00 .Or.;
				aTotProv[nD][10] <> 0.00 .Or. aTotProv[nD][11]<>0.00 .Or. aTotProv[nD][12] <> 0.00 .Or.;
				aTotProv[nD][13] <> 0.00

				If nCnt1 == 1
					oReport:SkipLine()
					nLinha := oReport:nRow		
					oReport:PrintText(Space(20)+"Totales por Zona Fiscal ",nLinha)	//"Totales por Zona Fiscal "
				Endif
				nCnt1++
				
				oReport:SkipLine()
				nLinha := oReport:nRow		
				oReport:PrintText(Space(30)+aProvincia[nD][2],nLinha)
				
				oReport:Section(2):Cell("F3_ENTRADA"):Hide()
				oReport:Section(2):Cell("F3_ESPECIE"):Hide()
				oReport:Section(2):Cell("F3_SERIE"):Hide()
				oReport:Section(2):Cell("F3_NFISCAL"):Hide()
				oReport:Section(2):Cell("A2_NOME"):Hide()
				oReport:Section(2):Cell("A2_CGC"):Hide()
			
				nTNETO		:= aTotProv[nD][1]
				nTIVARG		:= aTotProv[nD][2]
				nTIVASERV	:= aTotProv[nD][4]
				nTIVABSCAP	:= aTotProv[nD][5]
				nTIVARE		:= aTotProv[nD][6]
				nTPERCIVA	:= aTotProv[nD][7]
				nTPERCIIBB	:= aTotProv[nD][8]
				nTPERCGAN	:= aTotProv[nD][9]
				nTRETIVA	:= aTotProv[nD][10]
				nTRETIIBB	:= aTotProv[nD][11]
				nTEXENTO	:= aTotProv[nD][12]
				nTTOTAL		:= aTotProv[nD][13]
			
				oReport:Section(2):Init()
				oReport:Section(2):PrintLine()
				oReport:Section(2):Finish()
				oReport:SkipLine()				
			Endif
		Next
	Endif
	
	// TOTALES POR TIPO DE PRODUTO  
	If lProduto
		nCnt1 := 1
		For nD:=1 To Len(aTotTpProd)
			If aTotTpProd[nD][1]<>0.00 .Or. aTotTpProd[nD][2]<>0.00 .Or. aTotTpProd[nD][3] <> 0.00 .Or.;
				aTotTpProd[nD][4] <> 0.00 .Or. aTotTpProd[nD][5]<>0.00 .Or. aTotTpProd[nD][6] <> 0.00 .Or.;
				aTotTpProd[nD][7] <> 0.00 .Or. aTotTpProd[nD][8]<>0.00 .Or. aTotTpProd[nD][9] <> 0.00 .Or.;
				aTotTpProd[nD][10] <> 0.00 .Or. aTotTpProd[nD][11]<>0.00 .Or. aTotTpProd[nD][12] <> 0.00 .Or.;
				aTotTpProd[nD][13] <> 0.00

				If nCnt1 == 1
					oReport:SkipLine()
					nLinha := oReport:nRow		
					oReport:PrintText(Space(20)+OemToAnsi("Totales por Tipo de Producto "),nLinha)	//"Totales por Tipo de Producto "
				Endif
				nCnt1++
				
				oReport:SkipLine()
				nLinha := oReport:nRow		
				oReport:PrintText(Space(30)+aProduto[nD][2],nLinha)

				oReport:Section(2):Cell("F3_ENTRADA"):Hide()
				oReport:Section(2):Cell("F3_ESPECIE"):Hide()
				oReport:Section(2):Cell("F3_SERIE"):Hide()
				oReport:Section(2):Cell("F3_NFISCAL"):Hide()
				oReport:Section(2):Cell("A2_NOME"):Hide()
				oReport:Section(2):Cell("A2_CGC"):Hide()
			
				nTNETO		:= aTotTpProd[nD][1]
				nTIVARG		:= aTotTpProd[nD][2]
				nTIVASERV	:= aTotTpProd[nD][4]
				nTIVABSCAP	:= aTotTpProd[nD][5]
				nTIVARE		:= aTotTpProd[nD][6]
				nTPERCIVA	:= aTotTpProd[nD][7]
				nTPERCIIBB	:= aTotTpProd[nD][8]
				nTPERCGAN	:= aTotTpProd[nD][9]
				nTRETIVA	:= aTotTpProd[nD][10]
				nTRETIIBB	:= aTotTpProd[nD][11]
				nTEXENTO	:= aTotTpProd[nD][12]
				nTTOTAL		:= aTotTpProd[nD][13]
			
				oReport:Section(2):Init()
				oReport:Section(2):PrintLine()
				oReport:Section(2):Finish()
				oReport:SkipLine()				
			Endif
		Next
	Endif

Else

	nCnt1 :=	1    
	For nX:=1 To Len(aTotCFis)
		If aTotCFis[nx,1] <> 0
			nQtLinRes ++
		EndIf
	Next nX
	nQtLinRes := nQtLinRes+nLin
	If nQtLinRes > 55
		RAR1Cab()  //Imprime o Cabecalho do relatorio       
		nQtLinRes := 0
	EndIf
	If lTipos
		For nD:=	1 to len(aTotCFis)
			If aTotCFis[nD][1]<>0.00 .Or. aTotCFis[nD][2]<>0.00 .Or. aTotCFis[nD][3] <> 0.00 .Or.;
				aTotCFis[nD][4] <> 0.00 .Or. aTotCFis[nD][5]<>0.00 .Or. aTotCFis[nD][6] <> 0.00 .Or.;
				aTotCFis[nD][7] <> 0.00 .Or. aTotCFis[nD][8]<>0.00 .Or. aTotCFis[nD][9] <> 0.00 .Or.;
				aTotCFis[nD][10] <> 0.00 .Or. aTotCFis[nD][11]<>0.00 .Or. aTotCFis[nD][12] <> 0.00 .Or.;
				aTotCFis[nD][13] <> 0.00
				If nCnt1==1
					nLin := nLin +1
					@nLin , 015 PSAY OemToAnsi(STR0015)  //"Totales por Condicion Fiscal "
					nLin := nLin +1
				Endif
				nCnt1 ++
				@nLin   , 030 PSAY aTipos[nD][2]
				@nLin	, 064 PSAY Trans(aTotCFis[nD][1],cPictVals)
				@nLin	, 079 PSAY Trans(aTotCFis[nD][2],cPictImp)
				@nLin	, 090 PSAY Trans(aTotCFis[nD][3],cPictImp)
				@nLin	, 101 PSAY Trans(aTotCFis[nD][4],cPictImp)
				@nLin	, 112 PSAY Trans(aTotCFis[nD][5],cPictImp)
				@nLin	, 123 PSAY Trans(aTotCFis[nD][6],cPictImp)
				@nLin	, 134 PSAY Trans(aTotCFis[nD][7],cPictImp)
				@nLin	, 145 PSAY Trans(aTotCFis[nD][8],cPictImp)
				@nLin	, 156 PSAY Trans(aTotCFis[nD][9],cPictImp)
				@nLin	, 167 PSAY Trans(aTotCFis[nD][10],cPictImp)
				@nLin	, 178 PSAY Trans(aTotCFis[nD][11],cPictImp)
				@nLin   , 190 PSAY Trans(aTotCFis[nD][12],cPictVals)
				@nLin	, 207 PSAY Trans(aTotCFis[nD][13],cPictVals)
				nLin := nLin +1
			Endif
		Next
	Endif
	
	// TOTALES POR ZONA FISCAL
	nQtLinRes := 2
	For nX:=1 To Len(aTotProv)
		If aTotProv[nx,1] <> 0
			nQtLinRes ++
		EndIf
	Next nX
	nQtLinRes := nQtLinRes+nLin
	If nQtLinRes > 55
		RAR1Cab()  //Imprime o Cabecalho do relatorio
		nQtLinRes := 0
	EndIf
	nCnt1 :=	1
	If lProvincia
		For nD:=	1 to len(aTotProv)
			If aTotProv[nD][1]<>0.00 .Or. aTotProv[nD][2]<>0.00 .Or. aTotProv[nD][3] <> 0.00 .Or.;
				aTotProv[nD][4] <> 0.00 .Or. aTotProv[nD][5]<>0.00 .Or. aTotProv[nD][6] <> 0.00 .Or.;
				aTotProv[nD][7] <> 0.00 .Or. aTotProv[nD][8]<>0.00 .Or. aTotProv[nD][9] <> 0.00 .Or.;
				aTotProv[nD][10] <> 0.00 .Or. aTotProv[nD][11]<>0.00 .Or. aTotProv[nD][12] <> 0.00 .Or.;
				aTotProv[nD][13] <> 0.00
				If nCnt1==1
					nLin := nLin +1
					@nLin , 015 PSAY OemToAnsi(STR0030)  //"Totales por Zona Fiscal "
					nLin := nLin +1
				Endif
				nCnt1 ++
				@nLin   , 030 PSAY aProvincia [nD][2]
				@nLin	, 064 PSAY Trans(aTotProv[nD][1],cPictVals)
				@nLin	, 079 PSAY Trans(aTotProv[nD][2],cPictImp)
				@nLin	, 090 PSAY Trans(aTotProv[nD][3],cPictImp)
				@nLin	, 101 PSAY Trans(aTotProv[nD][4],cPictImp)
				@nLin	, 112 PSAY Trans(aTotProv[nD][5],cPictImp)
				@nLin	, 123 PSAY Trans(aTotProv[nD][6],cPictImp)
				@nLin	, 134 PSAY Trans(aTotProv[nD][7],cPictImp)
				@nLin	, 145 PSAY Trans(aTotProv[nD][8],cPictImp)
				@nLin	, 156 PSAY Trans(aTotProv[nD][9],cPictImp)
				@nLin	, 167 PSAY Trans(aTotProv[nD][10],cPictImp)
				@nLin	, 178 PSAY Trans(aTotProv[nD][11],cPictImp)
				@nLin   , 190 PSAY Trans(aTotProv[nD][12],cPictVals)
				@nLin	, 207 PSAY Trans(aTotProv[nD][13],cPictVals)
				nLin := nLin +1
			Endif
		Next
	Endif
	
	// TOTALES POR TIPO DE PRODUTO  
	nQtLinRes := 2
	For nX:=1 To Len(aTotTpProd)
		If aTotTpProd[nx,1] <> 0
			nQtLinRes ++
		EndIf
	Next nX
	nQtLinRes := nQtLinRes+nLin
	If nQtLinRes > 55
		RAR1Cab()  //Imprime o Cabecalho do relatorio
	EndIf
	nCnt1 :=	1
	If lProduto
		For nD:=	1 to len(aTotTpProd)
			If aTotTpProd[nD][1]<>0.00 .Or. aTotTpProd[nD][2]<>0.00 .Or. aTotTpProd[nD][3] <> 0.00 .Or.;
				aTotTpProd[nD][4] <> 0.00 .Or. aTotTpProd[nD][5]<>0.00 .Or. aTotTpProd[nD][6] <> 0.00 .Or.;
				aTotTpProd[nD][7] <> 0.00 .Or. aTotTpProd[nD][8]<>0.00 .Or. aTotTpProd[nD][9] <> 0.00 .Or.;
				aTotTpProd[nD][10] <> 0.00 .Or. aTotTpProd[nD][11]<>0.00 .Or. aTotTpProd[nD][12] <> 0.00 .Or.;
				aTotTpProd[nD][13] <> 0.00
				If nCnt1==1
					nLin := nLin +1
					@nLin , 015 PSAY OemToAnsi(STR0031)  //"Totales por Tipo de Producto "
					nLin := nLin +1
				Endif
				nCnt1 ++
				@nLin   , 030 PSAY aProduto[nD][2]
				@nLin	, 064 PSAY Trans(aTotTpProd[nD][1],cPictVals)
				@nLin	, 079 PSAY Trans(aTotTpProd[nD][2],cPictImp)
				@nLin	, 090 PSAY Trans(aTotTpProd[nD][3],cPictImp)
				@nLin	, 101 PSAY Trans(aTotTpProd[nD][4],cPictImp)
				@nLin	, 112 PSAY Trans(aTotTpProd[nD][5],cPictImp)
				@nLin	, 123 PSAY Trans(aTotTpProd[nD][6],cPictImp)
				@nLin	, 134 PSAY Trans(aTotTpProd[nD][7],cPictImp)
				@nLin	, 145 PSAY Trans(aTotTpProd[nD][8],cPictImp)
				@nLin	, 156 PSAY Trans(aTotTpProd[nD][9],cPictImp)
				@nLin	, 167 PSAY Trans(aTotTpProd[nD][10],cPictImp)
				@nLin	, 178 PSAY Trans(aTotTpProd[nD][11],cPictImp)
				@nLin   , 190 PSAY Trans(aTotTpProd[nD][12],cPictVals)
				@nLin	, 207 PSAY Trans(aTotTpProd[nD][13],cPictVals)
				nLin := nLin +1
			Endif
		Next
	Endif

Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ VerImp   ºAutor  ³Gilson da Silva     º Data ³  06/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica posicionamento de papel na Impressora             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Livros Fiscais                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VerImp()

nLin:= 0                // Contador de Linhas
nLinIni:=0
aDriver:=ReadDriver()
If aReturn[5]==2
	nOpc       := 1
	#IFNDEF WINDOWS
		cCor       := "B/BG"
	#ENDIF
	While .T.
		
		SetPrc(0,0)
		dbCommitAll()
		
		@ 00   ,000	PSAY aDriver[5]
		@ nLin ,000 PSAY " "
		@ nLin ,004 PSAY "*"
		@ nLin ,022 PSAY "."
		
		#IFNDEF WINDOWS
			Set Device to Screen
			DrawAdvWindow(OemToAnsi(STR0020),10,25,14,56) //" Formulario "
			SetColor(cCor)
			@ 12,27 Say OemToAnsi(STR0021) //"Formulario esta posicionado?"
			nOpc:=Menuh({OemToAnsi(STR0022),OemToAnsi(STR0023),OemToAnsi(STR0024)},14,26,"b/w,w+/n,r/w","SNC","",1) //"Si"###"NO"###"Cancela la impresión"
			Set Device to Print
		#ELSE
			IF MsgYesNo(OemToAnsi(STR0021)) //"Fomulario esta posicionado ? "
				nOpc := 1
			ElseIF MsgYesNo(OemToAnsi(STR0025)) //"Tenta Novamente ? "
				nOpc := 2
			Else
				nOpc := 3
			Endif
		#ENDIF
		
		Do Case
			Case nOpc==1
				lContinua := .T.
				Exit
			Case nOpc==2
				Loop
			Case nOpc==3
				lContinua := .F.
				Return
		EndCase
	End
Endif
Return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ AjustaSX1º Autor ³ Gilson da Silva   º Data ³  29.01.04    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Criacao de Perguntas no SX1                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATRAR1                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AjustaSX1()

Local aHelp	:= {}

Aadd(aHelp,{{"Informe a Data Inicial"		},	{"Enter the Initial Date    "           	},{"Indique la Fecha Inicial    "  			}})	
Aadd(aHelp,{{"Informe a Data Final"	    	},	{"Enter the Final Date    "             	},{"Indique la Fecha Final    "  			}})	
Aadd(aHelp,{{"Selecione o Tipo do Titulo" 	},	{"Enter the Bill Typee    "             	},{"Seleccione el Tipo del Titulo" 			}})	
Aadd(aHelp,{{"Informe o Formto do Relatorio"},	{"Enter the Report Format  "             	},{"Indique el Formato del Informe" 		}})	
Aadd(aHelp,{{"Selecione a Filial"        	},	{"Enter the Branch   "                  	},{"Elija la Sucursal"          			}})	
Aadd(aHelp,{{"Deseja imprimir o Resumo"		},	{"Would you like to printer the Summary"   	},{"Desea que se imprima lo Resumen"		}})	
Aadd(aHelp,{{"Pagina inicial"       		},	{"Pagina inicial "                   	    },{"Pagina inicial " 			 			}})	
Aadd(aHelp,{{"Pagina Final"       	    	},	{"Pagina Final"                   	        },{"Pagina Final"    			 			}})	
Aadd(aHelp,{{"Pagina oa reiniciar"     		},	{"Pagina oa reiniciar"                      },{"Pagina oa reiniciar"		 			}})	

PutSx1("MTRAR1","01","Data Inicial ?","¿Fecha Inicial ?", "Initial Date ?","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","",;
       "","","","","","","","","","","","",aHelp[1,1],aHelp[1,2],aHelp[1,3])
  
PutSx1("MTRAR1","02","Data Final  ?","¿Fecha Final ?", "Final Date  ?","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","",;
       "","","","","","","","","","","","S",aHelp[2,1],aHelp[2,2],aHelp[2,3])

PutSx1("MTRAR1","03","Incluir  ?","¿Incluir ?", "Include ?","mv_ch3","N",1,0,1,"C","","","","","mv_par03","Ativos","Activos","Actives","",;
       "Anulados","Anulados","Anull","Todos","Todos","All","","","","","","",aHelp[3,1],aHelp[3,2],aHelp[3,3])     
       
PutSx1("MTRAR1","04","Estilo   ?","¿Estilo  ?", "Style  ?","mv_ch4","N",1,0,1,"C","","","","","mv_par04","Analitico","Analitico","Detailed","",;
       "Resumido","Resumido","Summarized","","","","","","","","","",aHelp[4,1],aHelp[4,2],aHelp[4,3])     

PutSx1("MTRAR1","05","Filial   ?","¿Sucursale ?", "Branch  ?","mv_ch5","C",2,0,0,"G","","SM0","","","mv_par05","","","","",;
       "","","","","","","","","","","SM0","",aHelp[5,1],aHelp[5,2],aHelp[5,3])     

PutSx1("MTRAR1","06","Resumo   ?","¿Resumen ?", "Resumen ?","mv_ch6","N",1,0,1,"C","","","","","mv_par06","Imprimir","Imprimir","Printer","",;
       "Nao Imprimir","No Imprimir","Not Printer","","","","","","","","","",aHelp[6,1],aHelp[6,2],aHelp[6,3])         

PutSx1("MTRAR1","07","Pagina Inicial ?","Pagina Inicial ?","Pagina Inicial ?","mv_ch7","N",6,0,0,"G","","","","","mv_par07","","","","1",;
       "","","","","","","","","","","","",aHelp[7,1],aHelp[7,2],aHelp[7,3])
    
PutSx1("MTRAR1","08","Pagina Final ?","Pagina Final ?","Pagina Final ?","mv_ch8","N",6,0,0,"G","ValPagF","","","","mv_par08","","","","3",;
       "","","","","","","","","","","","",aHelp[8,1],aHelp[8,2],aHelp[8,3])                                             
    
PutSx1("MTRAR1","09","Pagina ao reiniciar ?","Pagina ao reiniciar ?", "Pagina ao reiniciar ?","mv_ch9","N",6,0,0,"G","ValPagR","","","","mv_par09","","","","1",;
       "","","","","","","","","","","","",aHelp[9,1],aHelp[9,2],aHelp[9,3])       
RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CellDisable³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 24.10.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Esta funcao verifica se ha celulas desabilitadas na secao 1, ³±±
±±³          ³e se caso houver, desabilita as respectivas celulas da       ³±±
±±³          ³secao 2.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CellDisable()

Local nX		:= 0
Local aSecao1 	:= {"NETO" ,"IVARG" ,"IVARNI" ,"IVASERV" ,"IVABSCAP" ,"IVARE" ,"PERCIVA" ,"PERCIIBB" ,"PERCGAN" ,"RETIVA" ,"RETIIBB" ,"EXENTO" ,"TOTAL" }
Local aSecao2 	:= {"TNETO","TIVARG","TIVARNI","TIVASERV","TIVABSCAP","TIVARE","TPERCIVA","TPERCIIBB","TPERCGAN","TRETIVA","TRETIIBB","TEXENTO","TTOTAL"}

For nX := 1 To Len(aSecao1)
	If !(oReport:Section(1):Cell(aSecao1[nX]):Enabled())
		oReport:Section(2):Cell(aSecao2[nX]):Disable()
	Endif
Next

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ValPagF   ºAutor  ³Natalia Antonuci    º Data ³  01/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ 			Esta Funcao envia uma mensagem de alerta          º±±
±±º          ³    "Pagina final devera ser maior que a pagina inicial"    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Livros Fiscais                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValPagF()
Local lRet := .T.

If MV_PAR08 < MV_PAR07
	MsgAlert("Pagina final devera ser maior que a pagina inicial")
	lRet := .F.
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ValPagR   ºAutor  ³Natalia Antonuci    º Data ³  01/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ 			Esta Funcao envia uma mensagem de alerta          º±±
±±º          ³  "Pagina final devera ser maior que a pagina ao reiniciar" º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Livros Fiscais                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValPagR()
Local lRet := .T.

If MV_PAR09 > MV_PAR08
	MsgAlert("Pagina final devera ser maior que a pagina ao reiniciar")
	lRet := .F.
Endif
Return(lRet)