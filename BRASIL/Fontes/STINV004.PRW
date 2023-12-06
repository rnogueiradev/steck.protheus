#Include "TopConn.ch"
#INCLUDE "protheus.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณ Funo   ณ STINV004 ณ Autor ณ EVERALDO GALLO        ณ Data ณ 24/10/13 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤณฑฑ
ฑฑณ Descrioณ acertos de apontamentos de producao                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ     													  	  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ BOPS ณ  Motivo da Alteracao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STINV004

Local aCampos := {	{ "BF_PRODUTO"		,"C",15,00 },;
					{ "BF_QUANT" 		,"N",14,02 },;
					{ "BF_LOCAL" 		,"C",2 },;
					{ "BF_LOCALIZ"		,"C",10,00 },;
					{ "DESCRICAO"		,"C",40,00 }}
                      
Private cCadastro := "Inventแrio Local 50"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta um aRotina proprio                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private aRotina := { 	{"Processa"    ,"u_zera50" ,0,4} }

Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "TRB"

cQuery    := ""
cQuery    += " SELECT   * "
cQuery    += " FROM     "+RETSQLNAME('SBF')
cQuery    += " WHERE    "+RETSQLNAME('SBF')+".D_E_L_E_T_ <> '*'"
cQuery    += " AND      BF_FILIAL 		=  '"+XFILIAL('SBF')+"'"
cQuery    += " AND      BF_QUANT		>  0 "
cQuery    += " AND      BF_LOCAL		= '50' "
cQuery    += " ORDER BY BF_PRODUTO "

TCQUERY cQuery NEW ALIAS "TRB"

TCSETFIELD("TRB","BF_QUANT"  ,"N",14,2)




cIndxKEY := "BF_PRODUTO"
cArqTrab:=CriaTrab(aCampos,.t.)
dbUseArea(.t.,"topconn",cArqTrab,"TRBX",.F.,.F.) //Alterado 18/05/23 - adicionado o driver "TOPCONN"
cFileTRB := CriaTrab( nil,.F. ) 
IndRegua( "TRBX",cArqTrab,cIndxKEY,,,"Organizando Arquivo...")                      
 
DBSELECTAREA("TRB")
dbgotop()

DO WHILE !eof()

   DBSELECTAREA("SB1")
   DBSEEK(XFILIAL("SB1")+TRB->BF_PRODUTO)
   IF EOF()       
      	_cDesc := "Nao Encontrado"
   Else
		_cDesc := substr(b1_Desc,1,40)
   Endif

   DBSELECTAREA("TRBX")
   
   reclock("TRBX",.t.)
   BF_PRODUTO 	:= TRB->BF_PRODUTO
   BF_QUANT 	:= TRB->BF_QUANT
   BF_LOCALIZ   := TRB->BF_LOCALIZ    
   BF_LOCAL   	:= TRB->BF_LOCAL
   DESCRICAO	:= _cDesc
   MSUNLOCK()   
   DBSELECTAREA("TRB")
   
   DBSKIP()
EndDo
DbSelectArea("TRBX")
dbgotop()



 
DbSelectArea("TRB")
_nRec := 0
DbEval({|| _nRec++  })

dbgotop()


dbSelectArea("TRBX")

_aCampos	:= 		{ 	{"Produto"	   			, 	"BF_PRODUTO"			, 	'C',15,00, "@!"	},;
						{"Descricao"   			, 	"DESCRICAO"				, 	'C',40,00, "@!"},;
						{"Endereco"   			, 	"BF_LOCALIZ"			, 	'C',10,00, "@!"},;
						{"Quantidade" 	  		, 	"BF_QUANT"	 			, 	'N',15,02, "@e 999,999,999.99"}}

dbSelectArea("TRBX")
mBrowse( 6,1,22,75,"TRBX",_aCampos )

DbselectArea("TRBX")
DbCloseArea()

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTINV001  บAutor  ณMicrosiga           บ Data ณ  10/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function zera50
 

_ctexto  := ''
_cerros  := ''


DO WHILE !EOF()

	Processa({|| Baixa_mps()  },"Gerando Movimentos ")
		
	Baixa_mps()
		
	DbSelectArea("TRB")
	_ctexto += REPLICATE("-",70)+CHR(13)+CHR(10)
	
ENDDO

_ctime:=substr(time(),1,2)+substr(time(),4,2)+substr(time(),7,2)
_cfile := GetSrvProfString("StartPath","")+"\OP"+_ctime
MemoWrit(_cfile+".LOG", _cTexto)
MemoWrit(_cfile+".ERR", _cErros)

DbselectArea("TRB")
DbCloseArea()

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAGLOP001  บAutor  ณMicrosiga           บ Data ณ  07/12/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Baixa_mps()


Local 	cAliasOld 	:= Alias()
Local 	lOk 		:= .T.
Local 	cTpMvEst 	:= ""
Local 	_cTpMvEst 	:= "850"
Local 	aSd3 		:= {}
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.



aTamSX3:=TamSX3("D3_QUANT")
nDecSD3:=aTamSX3[2]
aTamSX3:=TamSX3("D4_QTDEORI")
nDecSD4:=aTamSX3[2]


  
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1") + TRB->BF_PRODUTO )
		 
			aSd3 		:= {}
			 
				aAdd(aSd3, {"D3_FILIAL" 	, XFILIAL('SD3') , NIL})
				aAdd(aSd3, {"D3_TM" 		, _cTpMvEst		 , NIL})
				aAdd(aSd3, {"D3_COD"		, TRB->BF_PRODUTO , NIL})
 				
				aAdd(aSd3, {"D3_UM"     	, SB1->B1_UM, NIL})
				aAdd(aSd3, {"D3_QUANT"  	, TRB->BF_QUANT, NIL})
				
				aAdd(aSd3, {"D3_LOCAL"  	, TRB->BF_LOCAL 	, NIL})
				aAdd(aSd3, {"D3_EMISSAO"	, DDATABASE		, NIL})
				aAdd(aSd3, {"D3_USUARIO"	, CUSERNAME 		, NIL})
				aAdd(aSd3, {"D3_DOC"    	, "IV"+SUBSTR(DTOS(DDATABASE),1,6)     		, Nil})
  				
				aAdd(aSd3, {"D3_LOCALIZ"	, TRB->BF_LOCALIZ, NIL})
 				
				DbSelectArea("SD3")
				DbSetOrder(1)

				lMsErroAuto := .F.
				lOk := .T.
				MSExecAuto({|x| MATA240(x)}, aSd3)
				                                                      
				If lMsErroAuto
					MostraErro()

 					lOk := .F.
				ENDIF
				
				IF lOk           
				    
					_ctexto += TRB->BF_PRODUTO +" - "+TRANSFORM(TRB->BF_QUANT,"@e 9999,999.999999")+" - OK "+CHR(13)+CHR(10)
					
				ELSE
					_ctexto += TRB->BF_PRODUTO +" - "+TRANSFORM(TRB->BF_QUANT,"@e 9999,999.999999")+" - ERROR - NAO BAIXADO" +CHR(13)+CHR(10)
					_cErros += TRB->BF_PRODUTO +" - "+TRANSFORM(TRB->BF_QUANT,"@e 9999,999.999999")+" - CADASTROS" +CHR(13)+CHR(10)
				ENDIF
				
			 

		dbSelectArea("TRB")


 	dbSkip()
	 

return

