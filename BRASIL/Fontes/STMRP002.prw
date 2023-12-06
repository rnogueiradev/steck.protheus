#include "rwmake.ch"
#include "Font.ch"
#include "Protheus.ch"
#INCLUDE "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTMRP002  บAutor  ณ RVG Solucoes       บ Data ณ  01/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function STMRP002() //u_STMRP002()
	
	Local _nCount
	Local oReport
	
	Private cPerg := 'STMRP0020A'
	Private dIniciox
	
	Private cCadastro := OemToAnsi("Programa de MRP")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Ajusta o grupo de Perguntas                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_fCriaSx1()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Variaveis utilizadas para parametros                         ณ
	//ณ mv_par01             // Produto de                           ณ
	//ณ mv_par02             // Produto ate                          ณ
	//ณ mv_par03             // Grupo de                             ณ
	//ณ mv_par04             // Grupo ate                            ณ
	//ณ mv_par05             // Tipo de                              ณ
	//ณ mv_par06             // Tipo ate                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	Pergunte(cPerg,.F.)
	
	oReport:= ReportDef()
	oReport:PrintDialog()
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ ReportDefณAutor  ณAlexandre Inacio Lemes ณData  ณ02/06/2006ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Lista os itens que atingiram o ponto de pedido.            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ nExp01: nReg = Registro posicionado do SC3 apartir Browse  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ oExpO1: Objeto do relatorio                                ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ReportDef()
	
	Local oReport
	Local oSection1
	Local oCell
	Local oBreak
	Local cAlias := "TRB"
	Private cTitulo := "Relatorio MRP STECK"
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCriacao do componente de impressao                                      ณ
	//ณ                                                                        ณ
	//ณTReport():New                                                           ณ
	//ณExpC1 : Nome do relatorio                                               ณ
	//ณExpC2 : Titulo                                                          ณ
	//ณExpC3 : Pergunte                                                        ณ
	//ณExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ณ
	//ณExpC5 : Descricao                                                       ณ
	//ณ                                                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oReport := TReport():New("STMPR002",cTitulo,cPerg,{|oReport| ReportPrint(oReport,'SB1')},cTitulo) //"Emite uma relacao com os itens em estoque que atingiram o Ponto de Pedido ,sugerindo a quantidade a comprar."
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 10
	
	oReport:SetTotalInLine(.F.)
	oReport:SetTotalText(  "TOTAL GERAL  " )
	oReport:SetLandscape()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCriacao da secao utilizada pelo relatorio                               ณ
	//ณ                                                                        ณ
	//ณTRSection():New                                                         ณ
	//ณExpO1 : Objeto TReport que a secao pertence                             ณ
	//ณExpC2 : Descricao da se็ao                                              ณ
	//ณExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ณ
	//ณ        sera considerada como principal para a se็ใo.                   ณ
	//ณExpA4 : Array com as Ordens do relat๓rio                                ณ
	//ณExpL5 : Carrega campos do SX3 como celulas                              ณ
	//ณ        Default : False                                                 ณ
	//ณExpL6 : Carrega ordens do Sindex                                        ณ
	//ณ        Default : False                                                 ณ
	//ณ                                                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCriacao da celulas da secao do relatorio                                ณ
	//ณ                                                                        ณ
	//ณTRCell():New                                                            ณ
	//ณExpO1 : Objeto TSection que a secao pertence                            ณ
	//ณExpC2 : Nome da celula do relat๓rio. O SX3 serแ consultado              ณ
	//ณExpC3 : Nome da tabela de referencia da celula                          ณ
	//ณExpC4 : Titulo da celula                                                ณ
	//ณ        Default : X3Titulo()                                            ณ
	//ณExpC5 : Picture                                                         ณ
	//ณ        Default : X3_PICTURE                                            ณ
	//ณExpC6 : Tamanho                                                         ณ
	//ณ        Default : X3_TAMANHO                                            ณ
	//ณExpL7 : Informe se o tamanho esta em pixel                              ณ
	//ณ        Default : False                                                 ณ
	//ณExpB8 : Bloco de c๓digo para impressao.                                 ณ
	//ณ        Default : ExpC2                                                 ณ
	//ณ                                                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oSection1:= TRSection():New(oReport,"Produtos",{"SB1","SB2","SG1"},/*aOrdem*/) // "Produtos"
	oSection1:SetHeaderPage()
	
	TRCell():New(oSection1,"PRODUTO"   		,"TRB","Produto" 	     ,'@!'								,15		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"DESCRI"    		,"TRB","Descricao" 	     ,'@!'								,35		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"GRUPO"		 	,"TRB","Grupo" 			 ,'@!'								,5		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"DESC_GRUP"		,"TRB","Descricao Grupo" ,'@!'							    ,25		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"ORIGEM"  	    ,"TRB","Orgiem" 		 ,'@!'								,15		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"EST_SEG" 	    ,"TRB","Est. Segur." 	 ,'@e 9999,999.99'					,15		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"CUSTO" 		    ,"TRB","Custo unit." 	 ,'@e 9999,999.99'					,15		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"ABC" 		    ,"TRB","ABC" 			 ,'@!'								,3		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"FMR" 		    ,"TRB","FMR" 			 ,'@!'								,3		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"COD_FOR"        ,"TRB","Fornecedor" 	 ,'@!'								,8		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"FORNECE" 		,"TRB","Nome" 			 ,'@!'								,30		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	
	TRCell():New(oSection1,"DATA_MRP" 		,"TRB","Data M.R.P." 	 ,'@!'								,10		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"DATA_NEC" 		,"TRB","Necessidade" 	 ,'@!'								,10		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	
	TRCell():New(oSection1,"SALDO" 		    ,"TRB","Saldo Anterior"	 ,'@e 9999,999,999'					,15		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"ENTRADA" 	    ,"TRB","Entrada" 		 ,'@e 9999,999,999'					,15		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"SAIDA" 		    ,"TRB","Saida" 			 ,'@e 9999,999,999'					,15		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"SAID_ESTR"	    ,"TRB","Saida Estr"		 ,'@e 9999,999,999'					,15		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"NECESSID" 	    ,"TRB","Necessidade" 	 ,'@e 9999,999,999'					,15		    ,/*lPixel*/,/*{|| code-block de impressao }*/)
	
	
Return(oReport)






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณReportPrintณ Autor ณFrancisco Junior    ณ Data ณ 16.11.10   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Funcao de Impressao                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณBMSR1015                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ReportPrint(oReport)
	Local oSection1	:= oReport:Section(1)
	Local cQuery
	Local cAlias
	Local oBreak, oBreak1
	
	Pergunte(cPerg,.F.)
	
	//MsgRun("Processando Arquivos Ultimo MRP! Aguarde!",,{|| Monta_MRP() } )
	MsgRun("Processando Arquivos Ultimo MRP! Aguarde!",,{|| MTAMRPNEW() } )
	
	oReport:Init()
	
	oSection1:Init()
	
	
	DbSelectArea("TRB")
	
	oReport:SetMeter(RecCount())
	
	DbGoTop()
	
	Do While !eof()
		
		IF MV_PAR07 == 1 .OR. (MV_PAR07 == 2  .AND. SALDO+ENTRADA+SAIDA+SAID_ESTR+SALDO_FIN+NECESSID  <> 0 )
			oSection1:PrintLine()
		Endif
		
		oReport:IncMeter()
		DbselectArea('TRB')
		TRB->(DbSkip())
		
	EndDo
	
	TRB->(DbCloseArea())
	oSection1:Finish()
	
	//Dbselectarea("SHA")
	//DbClosearea("SHA")
	
	//Dbselectarea("SH5")
	//DbClosearea("SH5")
	
	//oReport:Finish()
	
Return( oReport )




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTMRP002  บAutor  ณMicrosiga           บ Data ณ  08/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function Monta_MRP()
	Local _nCount := 0
	//OpenMrp()// Abre os Arquivos
	
	//dbSelectArea("SX2")
	//dbSeek("SH")
	
	//_aDiretorio := Directory(cPath:=AllTrim(X2_PATH)+'\'+AllTrim(cFilAnt)+'\SH5*.*')
	
	//IF LEN(_aDiretorio) > 0
		
	//	_xData := _aDiretorio[1,3]
		
	//ELSE
		
	//	_xData := ddatabase
		
	//ENDIF
	
	DbselectArea('CZI')
	aStruct := {}
	cNomeArq:= CriaTrab("",.F.)
	cIndex  := cNomeArq
	AAdd( aStruct, {"PRODUTO"	,"C", 15, 0} )
	AAdd( aStruct, {"DESCRI"	,"C", 40, 0} )
	AAdd( aStruct, {"GRUPO"		,"C", 4 , 0} )
	AAdd( aStruct, {"TIPO"		,"C", 2 , 0} )
	AAdd( aStruct, {"DESC_GRUP" ,"C",20 , 0} )
	AAdd( aStruct, {"ORIGEM"	,"C",15 , 0} )
	AAdd( aStruct, {"EST_SEG"	,"N",14 , 4} )
	AAdd( aStruct, {"CUSTO"		,"N",14 , 4} )
	AAdd( aStruct, {"ABC"		,"C", 2 , 0} )
	AAdd( aStruct, {"FMR"		,"C", 2 , 0} )
	AAdd( aStruct, {"COD_FOR"	,"C", 8 , 0} )
	AAdd( aStruct, {"FORNECE"	,"C",20 , 0} )
	AAdd( aStruct, {"DATA_MRP"	,"D", 8 , 0} )
	AAdd( aStruct, {"DATA_NEC"	,"D", 8 , 0} )
	AAdd( aStruct, {"SALDO"		,"N",14 , 4} )
	AAdd( aStruct, {"ENTRADA"	,"N",14 , 4} )
	AAdd( aStruct, {"SAIDA"		,"N",14 , 4} )
	AAdd( aStruct, {"SAID_ESTR" ,"N",14 , 4} )
	AAdd( aStruct, {"SALDO_FIN"	,"N",14 , 4} )
	AAdd( aStruct, {"NECESSID"	,"N",14 , 4} )
	dbCreate( cNomeArq, aStruct, "TOPCONN" )   // adicionado o driver TOPCONN \Ajustado
	USE &cNomeArq	Alias Trb  NEW VIA TOPCONN // adicionado o driver TOPCONN \Ajustado
	dbSelectArea("TRB")
	IndRegua("TRB",cIndex,"PRODUTO+DTOS(DATA_NEC)",,, "Selecionando Registros..." )
	dbSetIndex( cNomeArq +OrdBagExt())
	_cCampo := ""
	
	_aPeriodos :={}
	_aPols     :={}
	nTipo :=  1
	//aPeriodos :=
	//aDatas := _calcPER(1)
	_nData := 1
	
	Pergunte(cPerg,.F.)
	
	/*
	Dbselectarea("SHA")
	aHA_Struct := SHA->(dbStruct())
	
	For _nCount :=1 to len(aHA_Struct)
		IF "HA_PER"  $ aHA_Struct[_nCount,1]
			_cCampo+= ALLTRIM(aHA_Struct[_nCount,1])+"+"
			aadd(_aPeriodos,{ALLTRIM(aHA_Struct[_nCount,1]),aDatas[_nData]},{})
			_nData++
		endif
		
	Next _nCount
	*/
	
	
	
	_cCampo+="0"
	
	Dbselectarea("CZI")
	dbGotop()
	//Dbseek("6")
	
	Do While !eof()
		
		DbselectArea('SB1')
		DBSETORDER(1)
		Dbseek(xfilial("SB1")+CZI->CZI_PROD)
		
		DbselectArea('SA2')
		DBSETORDER(1)
		Dbseek(xfilial("SA2")+SB1->B1_PROC+SB1->B1_LOJPROC)
		
		IF SB1->B1_COD     >= MV_PAR01 .AND. SB1->B1_COD <= MV_PAR02 .AND. ;
				SB1->B1_TIPO    >= MV_PAR03 .AND. SB1->B1_TIPO    <= MV_PAR04 .AND. ;
				SB1->B1_GRUPO   >= MV_PAR05 .AND. SB1->B1_GRUPO   <= MV_PAR06
			
			_aPolS:={}
			
			For _nCount :=1 to len(_aPeriodos)
				
				AADD(_aPolS ,{ 0,0,0,0,0,0,dtoc(_aPeriodos[_nCount,2])  })
				
			Next _nCount
			
			
			Dbselectarea("SHA")
			Do While !eof() .AND. SHA->HA_Produto == SB1->B1_COD
				
				
				For _nCount :=1 to len(_aPeriodos)
					
					_aPolS[_nCount,VAL(SHA->ha_tipo)] +=  SHA->(&(_aPeriodos[_nCount,1]))
					
				Next _nCount
				
				Dbselectarea("SHA")
				Dbskip()
				
			Enddo
			
			
			For _nCount := 1 to len(_aPolS)
				
				dbSelectArea("TRB")
				Reclock("TRB",.T.)
				Replace PRODUTO    With SB1->B1_COD
				Replace DESCRI     With SB1->B1_DESC
				Replace GRUPO      With SB1->B1_GRUPO
				Replace TIPO       With SB1->B1_TIPO
				Replace DESC_GRUP  With Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_DESC")
				Replace ORIGEM     With SB1->B1_CLAPROD
				Replace EST_SEG    With SB1->B1_ESTSEG
				Replace CUSTO	   With SB1->B1_UPRC
				Replace	ABC        With SB1->B1_XABC
				Replace	FMR        With SB1->B1_XFMR
				Replace	COD_FOR    With SB1->B1_PROC+SB1->B1_LOJPROC
				Replace	FORNECE    With SA2->A2_NREDUZ
				Replace	DATA_MRP   With  _xData
				
				Replace	DATA_NEC   With ctod(_ApolS[_nCount,7] )
				Replace	SALDO      With _ApolS[_nCount,1]
				Replace	ENTRADA    With _ApolS[_nCount,2]
				Replace	SAIDA      With _ApolS[_nCount,3]
				Replace	SAID_ESTR  With _ApolS[_nCount,4]
				Replace	SALDO_FIN  With _ApolS[_nCount,5]
				Replace	NECESSID   With _ApolS[_nCount,6]
				Msunlock()
				
			Next _nCount
			
		Else
			
			
			Dbselectarea("SHA")
			Dbskip()
			
		Endif
		
		Dbselectarea("SHA")
		
	Enddo
	
Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณABRESC    บAutor  ณMicrosiga           บ Data ณ  04/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function OpenMrp()
	
	Local lRet 		:= .T.
	Local cDrive 	:= "CTREECDX"
	Local cExt		:= ".cdx"
	Local cPath		:= ""
	Local cArqSH5	:= ""
	Local cArqSHA	:= ""
	Local cNameIdx	:= ""
	LOCAL aArea     := GetArea()
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria semaforo para controle de exclusividade da operacao     ณ
	//ณ Somente na chamada em job nao testa essa exclusividade       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	dbSelectArea("SX2")
	dbSeek("SH")
	
	cPath:=AllTrim(X2_PATH)+'\'+AllTrim(cFilAnt)+'\'
	
	If EXISTDIR(cPath)
		//-- Define o nome do arquivo SH5
		cArqSH5 := REtArq(cDrive,cPath+"SH5"+Substr(cNumEmp,1,2)+"0",.t.)
		
		//-- Define o nome do arquivo SHA
		cArqSHA := REtArq(cDrive,cPath+"SHA"+Substr(cNumEmp,1,2)+"0",.t.)
	Else
		MakeDir(cPath)
		If EXISTDIR(cPath)
			//-- Define o nome do arquivo SH5
			cArqSH5 := REtArq(cDrive,cPath+"SH5"+Substr(cNumEmp,1,2)+"0",.t.)
			
			//-- Define o nome do arquivo SHA
			cArqSHA := REtArq(cDrive,cPath+"SHA"+Substr(cNumEmp,1,2)+"0",.t.)
		EndIf
	EndIf
	
	
	//-- Abre o arquivo SH5
	If MSFile(cArqSH5,,cDrive)
		dbUseArea( .T. ,cDrive,cArqSH5, "SH5", .T. , .F. )
		
		
		cNameIdx := FileNoExt(cArqSH5)
		
		//-- Checa a existencia do indice permanente para tabela SH5, e cria se nao existir
		
		dbClearIndex()
		dbSetIndex( cNameIdx+cExt )
		
		//-- Abre tabelas em modo compartilhado
		If MSFile(cArqSHA,,cDrive)
			dbUseArea( .T.,cDrive, cArqSHA, "SHA", .T., .F. )
			
			cNameIdx := FileNoExt(cArqSHA)
			
			//-- Checa a existencia do indice permanente para tabela SHA, e cria se nao existir
			dbClearIndex()
			dbSetIndex( cNameIdx+cExt )
			
		Endif
		
	Endif
	
Return ( lRet )





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณABRESC    บAutor  ณMicrosiga           บ Data ณ  04/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _calcPER(nTipo)
	Local i, dInicio
	Local aRet:={}
	Local nPosAno, nTamAno, cForAno
	Local lConsSabDom:=Nil
	Pergunte("MTA712",.F.)
	lConsSabDom:=mv_par12 == 1
	If __SetCentury()
		nPosAno := 1
		nTamAno := 4
		cForAno := "ddmmyyyy"
	Else
		nPosAno := 3
		nTamAno := 2
		cForAno := "ddmmyy"
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Adiciona registro em array totalizador utilizado no TREE  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SH5")
	dbSetOrder(1)
	dbGotop()
	While !Eof()
		// Recupera parametrizacao gravada no ultimo processamento
		// A T E N C A O
		// Quando utilizado o processamento por periodos variaveis o sistema monta o array com
		// os periodos de maneira desordenada, por causa do indice do arquivo SH5
		// O array aRet ้ corrigido logo abaixo
		If H5_ALIAS == "PAR"
			nTipo       := H5_RECNO
			dInicio     := H5_DATAORI
			dInicioX    := H5_DATAORI
			nPeriodos   := H5_QUANT
			If nTipo == 7
				AADD(aRet,DTOS(CTOD(Alltrim(H5_OPC))))
			EndIf
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ NUMERO DO MRP                                                ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			c711NumMRP:=H5_NUMMRP
		EndIf
		dbSkip()
	End
	
	//Somente para nTipo==7 (Periodos Diversos) re-ordena aRet
	//pois como o H5_OPC esta gravado a data como caracter ex:(09/10/05)
	//o arquivo esta indexado incorretamente (diferente de 20051009)
	If !Empty(aRet)
		ASort(aRet)
		For i:=1 To Len(aRet)
			aRet[i] := CTOD(Substr(aRet[i],7,2)+"/"+Substr(aRet[i],5,2)+"/"+Substr(aRet[i],1,4) )
		Next i
	EndIf
	
	If (nTipo == 2)                         // Semanal
		While Dow(dInicio)!=2
			dInicio--
		EndDo
	ElseIf (nTipo == 3) .or. (nTipo=4)      // Quinzenal ou Mensal
		dInicio:= CtoD("01"+Substr(Dtoc(dInicio),3),cForAno)
	ElseIf (nTipo == 5)                     // Trimestral
		If Month(dInicio) < 4
			dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7),cForAno)
		ElseIf (Month(dInicio) >= 4) .and. (Month(dInicio) < 7)
			dInicio := CtoD("01/04/"+Substr(DtoC(dInicio),7),cForAno)
		ElseIf (Month(dInicio) >= 7) .and. (Month(dInicio) < 10)
			dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7),cForAno)
		ElseIf (Month(dInicio) >=10)
			dInicio := CtoD("01/10/"+Substr(DtoC(dInicio),7),cForAno)
		EndIf
	ElseIf (nTipo == 6)                     // Semestral
		If Month(dInicio) <= 6
			dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7),cForAno)
		Else
			dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7),cForAno)
		EndIf
	EndIf
	If nTipo != 7
		For i := 1 to nPeriodos
			AADD(aRet,dInicio)
			If nTipo == 1
				dInicio ++
				While !lConsSabDom .And. ( DOW(dInicio) == 1 .or. DOW(dInicio) == 7 )
					dInicio++
				EndDo
			ElseIf nTipo == 2
				dInicio+=7
			ElseIf nTipo == 3
				dInicio := CtoD(If(Substr(DtoC(dInicio),1,2)="01","15"+Substr(DtoC(dInicio),3),;
					"01/"+If(Month(dInicio)+1<=12,StrZero(Month(dInicio)+1,2)+"/"+;
					SubStr(DtoC(dInicio),7),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno))),cForAno)
			ElseIf nTipo == 4
				dInicio := CtoD("01/"+If(Month(dInicio)+1<=12,StrZero(Month(dInicio)+1,2)+;
					"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
			ElseIf nTipo == 5
				dInicio := CtoD("01/"+If(Month(dInicio)+3<=12,StrZero(Month(dInicio)+3,2)+;
					"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
			ElseIf nTipo == 6
				dInicio := CtoD("01/"+If(Month(dInicio)+6<=12,StrZero(Month(dInicio)+6,2)+;
					"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
			EndIf
		Next i
	EndIf
Return aRet








/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fCriaSx1 บAutor  ณEVERALDO SILGA GALLOบ Data ณ  29/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Criacao das perguntas                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fCriaSx1()
	
	/* Removido - 18/05/2023 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
	DbSelectArea("SX1")
	DbSetOrder(1)
	
	If ! DbSeek(cPerg+"01",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "01"
		SX1->X1_PERGUNT := "Do Produto"
		SX1->X1_VARIAVL := "mv_ch1"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 15
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par01"
		SX1->X1_DEF01   := ""
		SX1->X1_F3		 := "SB1"
		MsUnLock()
	EndIf
	
	If ! DbSeek(cPerg+"02",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "02"
		SX1->X1_PERGUNT := "Ate Produto"
		SX1->X1_VARIAVL := "mv_ch2"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 15
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par02"
		SX1->X1_DEF01   := ""
		SX1->X1_F3		 := "SB1"
		MsUnLock()
	EndIf
	
	If ! DbSeek(cPerg+"03",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "03"
		SX1->X1_PERGUNT := "Tipo de"
		SX1->X1_VARIAVL := "mv_ch3"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 2
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par03"
		SX1->X1_DEF01   := ""
		MsUnLock()
	EndIf
	
	If ! DbSeek(cPerg+"04",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "04"
		SX1->X1_PERGUNT := "Tipo ate"
		SX1->X1_VARIAVL := "mv_ch4"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 2
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par04"
		SX1->X1_DEF01   := ""
		MsUnLock()
	EndIf
	
	If ! DbSeek(cPerg+"05",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "05"
		SX1->X1_PERGUNT := "Grupo de "
		SX1->X1_VARIAVL := "mv_ch5"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 4
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par05"
		SX1->X1_DEF01   := ""
		SX1->X1_F3		 := "SBM"
		MsUnLock()
	EndIf
	
	
	If ! DbSeek(cPerg+"06",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "06"
		SX1->X1_PERGUNT := "Grupo ate "
		SX1->X1_VARIAVL := "mv_ch6"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 4
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par06"
		SX1->X1_DEF01   := ""
		SX1->X1_F3		 := "SBM"
		MsUnLock()
	EndIf
	
	If ! DbSeek(cPerg+"07",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "07"
		SX1->X1_PERGUNT := "Lista Zerados?"
		SX1->X1_VARIAVL := "mv_ch7"
		SX1->X1_TIPO    := "N"
		SX1->X1_TAMANHO := 1
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "C"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par07"
		SX1->X1_DEF01   := "Sim"
		SX1->X1_DEF02   := "Nao"
		MsUnLock()
	EndIf
	
	*/
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTMRP002  บAutor  ณMicrosiga           บ Data ณ  08/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function MTAMRPNEW()
	//Local _nCount := 0
	Local _cQuery     	:= ""
	Local dInicio		:= dDataBase
	Local nTipo 		:= 4
	Local _dDt	 
	Local _n			:= 0	
	Local i  
	Private aPeriodos	:= {}
	PRIVATE aOpcoes[2][7]
	
		//Verifica os dados para montar/visualizar arquivos do MRP
	For i:= 1 to 7
		If aOpcoes[1][i] = "x"
			nTipo := i
		EndIf
	Next i
	
	//aOpcoes := 6
	//aOpcoes := 12 - Month(dDataBase) + 1
	 
	// Calcular a quantidade de periodos selecionada pelo usuario no calculo MRP
	 
	_cQuery := "SELECT MAX(CZK_PERMRP) AS NPER FROM " + RetSqlName("CZK") + " CZK"
	_cQuery += " WHERE CZK.D_E_L_E_T_ = ' '"
	_cQuery += " AND CZK_FILIAL = '" + xFilial("CZK") + "'"
	  	
	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())
	 
	aOpcoes := Val(QRY->NPER)
	QRY->(DbClosearea())	 
	
	_calcPERn(.T.,nTipo,dInicio,aPeriodos,aOpcoes)//(lVisualiza,nTipo,dInicio,aPeriodos,aOpcoes)
	
	aStruct := {}
	cNomeArq:= CriaTrab("",.F.)
	cIndex  := cNomeArq
	AAdd( aStruct, {"PRODUTO"	,"C", 15, 0} )
	AAdd( aStruct, {"DESCRI"	,"C", 40, 0} )
	AAdd( aStruct, {"GRUPO"		,"C", 4 , 0} )
	AAdd( aStruct, {"TIPO"		,"C", 2 , 0} )
	AAdd( aStruct, {"DESC_GRUP" ,"C",20 , 0} )
	AAdd( aStruct, {"ORIGEM"	,"C",15 , 0} )
	AAdd( aStruct, {"EST_SEG"	,"N",14 , 4} )
	AAdd( aStruct, {"CUSTO"		,"N",14 , 4} )
	AAdd( aStruct, {"ABC"		,"C", 2 , 0} )
	AAdd( aStruct, {"FMR"		,"C", 2 , 0} )
	AAdd( aStruct, {"COD_FOR"	,"C", 8 , 0} )
	AAdd( aStruct, {"FORNECE"	,"C",20 , 0} )
	AAdd( aStruct, {"DATA_MRP"	,"D", 8 , 0} )
	AAdd( aStruct, {"DATA_NEC"	,"D", 8 , 0} )
	AAdd( aStruct, {"SALDO"		,"N",14 , 4} )
	AAdd( aStruct, {"ENTRADA"	,"N",14 , 4} )
	AAdd( aStruct, {"SAIDA"		,"N",14 , 4} )
	AAdd( aStruct, {"SAID_ESTR" ,"N",14 , 4} )
	AAdd( aStruct, {"SALDO_FIN"	,"N",14 , 4} )
	AAdd( aStruct, {"NECESSID"	,"N",14 , 4} )
	dbCreate( cNomeArq, aStruct, "TOPCONN" )	// adicionado o driver TOPCONN \Ajustado
	USE &cNomeArq	Alias Trb  NEW VIA TOPCONN	// adicionado o driver TOPCONN \Ajustado
	dbSelectArea("TRB")
	IndRegua("TRB",cIndex,"PRODUTO+DTOS(DATA_NEC)",,, "Selecionando Registros..." )
	dbSetIndex( cNomeArq +OrdBagExt())
	
	_cQuery := ""
	_cQuery += "    SELECT CZK.CZK_PERMRP,B1_COD,B1_DESC,B1_GRUPO, B1_TIPO,B1_CLAPROD,B1_ESTSEG,B1_UPRC,B1_XABC,B1_XFMR,B1_PROC,B1_LOJPROC, CZK.CZK_QTSLES, CZK.CZK_QTENTR, CZK.CZK_QTSAID, CZK.CZK_QTSEST, CZK.CZK_QTSALD,CZK.CZK_QTNECE "
	_cQuery += "       FROM " + RetSqlName("CZJ")+" CZJ "
	_cQuery += "	INNER JOIN  " + RetSqlName("CZK") +" CZK " 
	_cQuery += "	ON CZK.CZK_RGCZJ = CZJ.R_E_C_N_O_ "
	_cQuery += "	AND CZK.D_E_L_E_T_ = ' ' "
	_cQuery += " 	LEFT JOIN " + RetSqlName("SB1") + " B1"
	_cQuery += " 	ON B1.B1_COD = CZJ.CZJ_PROD "
	_cQuery += " 	AND B1.D_E_L_E_T_ = ' ' "
	_cQuery += "        WHERE CZJ.CZJ_FILIAL   = '"+xFilial("CZJ")+"'  "
	_cQuery += "             AND CZK.CZK_FILIAL   = '"+xFilial("CZK")+"' "
	_cQuery += "             AND CZJ.R_E_C_N_O_   = CZK.CZK_RGCZJ  "
	_cQuery += " 			 AND CZJ.CZJ_PROD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQuery += "			 AND B1.B1_TIPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery += "			 AND B1.B1_GRUPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "				
	_cQuery += "             AND (CZK.CZK_QTNECE <> 0  "
	_cQuery += "             OR  CZK.CZK_QTSAID <> 0  "
	_cQuery += "             OR  CZK.CZK_QTSALD <> 0  "
	_cQuery += "             OR  CZK.CZK_QTSEST <> 0  "
	_cQuery += "             OR  CZK.CZK_QTENTR <> 0  "
	_cQuery += "             OR  CZK.CZK_QTSLES <> 0)"
	_cQuery += "            ORDER BY CZJ.CZJ_PROD,  "
	_cQuery += "                     CZJ.CZJ_OPCORD,  "
	_cQuery += "                     CZJ.CZJ_NRRV,  "
	_cQuery += "                     CZK.CZK_PERMRP "
	
	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"
	
	Dbselectarea("QRY")
	dbGotop()
	
	Do While !eof()
		
			For _n := 1 to Len(aPeriodos)
			
			If Alltrim(aPeriodos[_n][02]) == Alltrim(QRY->CZK_PERMRP)
			
			_dDt := aPeriodos[_n][01]
			
			EndIf
			
			Next
				dbSelectArea("TRB")
				Reclock("TRB",.T.)
				Replace PRODUTO    With QRY->B1_COD
				Replace DESCRI     With QRY->B1_DESC
				Replace GRUPO      With QRY->B1_GRUPO
				Replace TIPO       With QRY->B1_TIPO
				Replace DESC_GRUP  With Posicione("SBM",1,xFilial("SBM")+QRY->B1_GRUPO,"BM_DESC")
				Replace ORIGEM     With QRY->B1_CLAPROD
				Replace EST_SEG    With QRY->B1_ESTSEG
				Replace CUSTO	   With QRY->B1_UPRC
				Replace	ABC        With QRY->B1_XABC
				Replace	FMR        With QRY->B1_XFMR
				Replace	COD_FOR    With QRY->B1_PROC+QRY->B1_LOJPROC
				Replace	FORNECE    With Posicione("SA2",1,xFilial("SA2")+QRY->B1_PROC,"A2_NREDUZ")
				Replace	DATA_MRP   With  dInicio
				
				Replace	DATA_NEC   With _dDt
				Replace	SALDO      With QRY->CZK_QTSLES
				Replace	ENTRADA    With QRY->CZK_QTENTR
				Replace	SAIDA      With QRY->CZK_QTSAID
				Replace	SAID_ESTR  With QRY->CZK_QTSEST
				Replace	SALDO_FIN  With QRY->CZK_QTSALD
				Replace	NECESSID   With QRY->CZK_QTNECE
				Msunlock()

		Dbselectarea("QRY")
		DbSkip()
		
	Enddo
	
Return

/*------------------------------------------------------------------------//
//Programa:	A712AtuPeriodo
//Autor:		Ricardo Prandi     
//Data:		18/09/2013
//Descricao:	Funcao responsavel pela atualizacao de periodos e cria็ใo 
//            da aPeriodos
//Parametros:	ExpL1 : Indica se o MRP sera executado em modo visualizacao
//				ExpN1 : Indica o tipo de periodo escolhido pelo operador
//				ExpD1 : Data de inicio dos periodos 
//				ExpA1 : Array com os periodos que serao retornados por refer
//				ExpA2 : Array com parametros (opcoes)
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function _calcPERn(lVisualiza,nTipo,dInicio,aPeriodos,aOpcoes)
Local cForAno 	:= ""
Local nPosAno 	:= 0
Local nTamAno 	:= 0 
Local i 			:= 0
Local nY2T			:= If(__SetCentury(),2,0)

DEFAULT lVisualiza := .F.

If __SetCentury()
	nPosAno := 1
	nTamAno := 4
	cForAno := "ddmmyyyy"
Else
	nPosAno := 3
	nTamAno := 2
	cForAno := "ddmmyy"
Endif

//Monta a data de inicio de acordo com os parametros                   
If (nTipo == 2)                         // Semanal
	While Dow(dInicio)!=2
		dInicio--
	end
ElseIf (nTipo == 3) .or. (nTipo == 4)   // Quinzenal ou Mensal
	dInicio:= CtoD("01/"+Substr(DtoS(dInicio),5,2)+Substr(DtoC(dInicio),6,3+nY2T),cForAno)
ElseIf (nTipo == 5)                     // Trimestral
	If Month(dInicio) < 4
		dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	ElseIf (Month(dInicio) >= 4) .and. (Month(dInicio) < 7)
		dInicio := CtoD("01/04/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	ElseIf (Month(dInicio) >= 7) .and. (Month(dInicio) < 10)
		dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	ElseIf (Month(dInicio) >=10)
		dInicio := CtoD("01/10/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	EndIf
ElseIf (nTipo == 6)                     // Semestral
	If Month(dInicio) <= 6
		dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	Else
		dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	EndIf
EndIf

//Monta as datas de acordo com os parametros                   
If nTipo != 7
	For i := 1 to aOpcoes//[2][1]
		//dInicio := A712NextUtil(dInicio,aPergs711)
		AADD(aPeriodos,{ dInicio,(StrZero(i,3))})
		If nTipo == 1
			dInicio ++
		ElseIf nTipo == 2
			dInicio += 7
		ElseIf nTipo == 3
			dInicio := StoD(If(Substr(DtoS(dInicio),7,2)<"15",Substr(DtoS(dInicio),1,6)+"15",;
			                If(Month(dInicio)+1<=12,Str(Year(dInicio),4)+StrZero(Month(dInicio)+1,2)+"01",;
			                Str(Year(dInicio)+1,4)+"0101")),cForAno)
		ElseIf nTipo == 4
			dInicio := CtoD("01/"+If(Month(dInicio)+1<=12,StrZero(Month(dInicio)+1,2)+;
			                "/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		ElseIf nTipo == 5
			dInicio := CtoD("01/"+If(Month(dInicio)+3<=12,StrZero(Month(dInicio)+3,2)+;
			                "/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		ElseIf nTipo == 6
			dInicio := CtoD("01/"+If(Month(dInicio)+6<=12,StrZero(Month(dInicio)+6,2)+;
			                "/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		EndIf
	Next i
ElseIf nTipo == 7
	//Seleciona periodos variaveis se nao for visualizacao
	If !lVisualiza
		A712Diver()
	EndIf
	For i:=1 to Len(aDiversos)
		AADD(aPeriodos, StoD(DtoS(CtoD(aDiversos[i])),cForAno) )
	Next
Endif

Return (aPeriodos)
