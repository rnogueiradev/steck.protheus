#Include "TopConn.ch" 
#INCLUDE "protheus.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณ Funo   ณ ACTOP001 ณ Autor ณ RVG                   ณ Data ณ 07/04/13 ณฑฑ
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
User Function ACTOP001(_lauto)
Public _lauto

IF _lAuto == NIL
	_lAuto := .f.
ENDIF

if !_lAuto
	cPerg   := "AAGP050001"
	
	_fCriaSx1()
	
	if pergunte(cPerg,.t.)
		
		Processa({|| AGLOP001A() },"Processando...")
	ENDIF
	
ELSE
	MV_PAR01:=MV_PAR02:=date()
	MV_PAR03 := "           "
	MV_PAR04 := "ZZZZZZZZZZZ"
	AGLLOP001A()
Endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAGLLOP001AบAutor  ณ RVG                   ณ Data ณ 07/04/13 ณฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function AGLOP001A

cQuery    := ""
cQuery    += " SELECT   *"
cQuery    += " FROM     "+RETSQLNAME('SD3')
cQuery    += " WHERE    "+RETSQLNAME('SD3')+".D_E_L_E_T_ <> '*'"
cQuery    += " AND      D3_FILIAL 		=  '"+XFILIAL('SD3')+"'"
cQuery    += " AND      D3_OP 			<> '"+SPACE(LEN(SD3->D3_OP))+"'"
cQuery    += " AND      D3_ESTORNO  	<> 'S' "
cQuery    += " AND      D3_CF			= 'PR0' "
cQuery    += " AND      D3_EMISSAO  	BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
cQuery    += " AND      D3_OP 		  	BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
cQuery    += " ORDER BY D3_OP,D3_COD,D3_NUMSEQ"

TCQUERY cQuery NEW ALIAS "TRB"

TCSETFIELD("TRB","D3_CUSTO1"  ,"N",14,2)
TCSETFIELD("TRB","D3_EMISSAO" ,"D", 8,0)

DbSelectArea("TRB")
_nRec := 0
DbEval({|| _nRec++  })

dbgotop()

if !_lAuto
	procregua(_nRec)
endif

_ctexto  := ''
_cerros  := ''

DO WHILE !EOF()
	
	
	DbSelectArea("TRB")
	
	_cNumseq 	:= d3_numseq
	_nprod 		:= _nperda := 0
	_Cop 		:= d3_op
	_dEmissao 	:= d3_emissao
	_ctexto 	+= "ORDEM DE PRODUCAO "+ _Cop +CHR(13)+CHR(10)
	_cDoc 		:= d3_doc
	_cCod 		:= d3_cod
	_nrec 		:= trb->R_E_C_N_O_
	
	
	_nprod+=(D3_QUANT)
	
	dbselectarea("SC2")
	dbsetorder(1)
	dbseek(xfilial("SC2")+_Cop)
	
	nPercOp:=(_nProd)/SC2->C2_QUANT
	reclock("SC2",.F.)
	_CRF := C2_DATRF
	IF C2_EMISSAO > C2_DATRF .or. empty(C2_EMISSAO)
		C2_EMISSAO := C2_DATRF
	ENDIF
	C2_DATRF := CTOD("  /  /  ")
	MSUNLOCK()
	
	Baixa_mps()
	
	dbselectarea("SC2")
	reclock("SC2",.F.)
	C2_DATRF := _CRF
	MSUNLOCK()
	
	DbSelectArea("TRB")
	_ctexto += REPLICATE("-",70)+CHR(13)+CHR(10)
	dbskip()
		

ENDDO

_ctime:=substr(time(),1,2)+substr(time(),4,2)+substr(time(),7,2)
_cfile := GetSrvProfString("StartPath","")+"\OP"+_ctime
MemoWrit(_cfile+".LOG", _cTexto)
MemoWrit(_cfile+".ERR", _cErros)

DbselectArea("TRB")
DbCloseArea("TRB")

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAGLOP001  บ Autor ณ RVG                ณ Data ณ 07/04/13    ณฑฑ
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


Local _nn:= 0
Local _cErros := ' '
Local 	aLotespOrig := {}  
Local 	cAliasOld 	:= Alias()
Local 	lOk 		:= .T.
Local 	cTpMvEst 	:= ""
Local 	_cTpMvEst 	:= "501"
Local 	aSd3 		:= {}
Local 	aLotespOrig := {}  
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.                
Private _cLocProd := "90"//getmv("MV_LOCPROC")

aTamSX3:=TamSX3("D3_QUANT")
nDecSD3:=aTamSX3[2]
aTamSX3:=TamSX3("D4_QTDEORI")
nDecSD4:=aTamSX3[2]


dbSelectArea("SDC")
dbSetOrder(2)
dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial("SD4")+_cOp)

While !EOF() .And. D4_FILIAL+D4_OP==xFilial("SD4")+_cOp
	
	_CareaSd4 :=getarea()
	
	dbselectarea("SD3")
	dbsetorder(1)
	dbseek(xfilial("SD3")+_cOp+SD4->D4_COD)
	
	_nqtd_jbx := 0
	
	DO WHILE !EOF() .AND. _cOp+SD3->D3_COD == _cOp+SD4->D4_COD  
		
		IF D3_ESTORNO  # 'S'  .AND. 	_cNumseq == SD3->d3_numseq

			IF D3_TM > "500"
				_nqtd_jbx += D3_QUANT
			ELSE
				_nqtd_jbx -= D3_QUANT
			ENDIF
		ENDIF
		DBSKIP()
		
	ENDDO
	
	if round(_nqtd_jbx,2) < round(SD4->D4_QTDEORI,2)
	
		aLotespOrig := {}
	
	    _nquantabx := (SD4->D4_QTDEORI )-_nqtd_jbx
			
		If Localiza(SD4->D4_COD)
			
			Dbselectarea("SBF")
			dbsetorder(2)
			DBSEEK(XFILIAL("SBF")+SD4->D4_COD+_cLocProd,.T.)
			
			DO WHILE SD4->D4_COD+_cLocProd == BF_PRODUTO+_cLocProd  .AND. !EOF()
				IF BF_QUANT >= _nquantabx
					aLotespOrig := {{SD4->D4_LOTECTL,SD4->D4_NUMLOTE,BF_LOCALIZ,_nquantabx}}
					_nquantabx := 0
					exit
				ELSE
					aLotespOrig := {{SD4->D4_LOTECTL,SD4->D4_NUMLOTE,BF_LOCALIZ,(BF_QUANT)}}
					_nquantabx -= (BF_QUANT)
				ENDIF
				DbSkip()
			EndDo
			
			if _nquantabx > 0
				_cErros += SD4->D4_op+" - "+SD4->D4_COD +" - "+TRANSFORM(SD4->D4_QTDEORI*nPercOp,"@e 9999,999.999999")+" - SEM SALDO EM ENDERECOS" +CHR(13)+CHR(10)
				aLotespOrig := {}
			endif
                       
		else
			Dbselectarea("SB2")
			DBSEEK(XFILIAL("SB2")+SD4->D4_COD+SD4->D4_LOCAL,.T.)
			aLotespOrig := {{SD4->D4_LOTECTL,SD4->D4_NUMLOTE,"",_nquantabx}}
		endif
		
		dbSelectArea("SD4")
		restarea(_CareaSd4)
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1") + SD4->D4_COD )
		
		for _nn := 1 to len(aLotespOrig)
			
			aSd3 		:= {}
			
			IF aLotespOrig[_nn,4] # 0
				
				aAdd(aSd3, {"D3_FILIAL" 	, XFILIAL('SD3') , NIL})
				aAdd(aSd3, {"D3_TM" 		, _cTpMvEst		 , NIL})
				aAdd(aSd3, {"D3_COD"		, SD4->D4_COD	 , NIL})
				aAdd(aSd3, {"D3_OP" 		, _cOp			 , NIL})
				
				aAdd(aSd3, {"D3_UM"     , SB1->B1_UM, NIL})
				aAdd(aSd3, {"D3_QUANT"  , aLotespOrig[_nn,4], NIL})
				
				aAdd(aSd3, {"D3_LOCAL"  , _cLocProd 		, NIL})
				aAdd(aSd3, {"D3_EMISSAO", _dEmissao 		, NIL})
				aAdd(aSd3, {"D3_USUARIO", CUSERNAME 		, NIL})
				aAdd(aSd3, {"D3_DOC"    , _cDoc     		, Nil})
				aAdd(aSd3, {"D3_NUMSEQ" , _cNumseq    		, Nil})
				aAdd(aSd3, {"D3_TRT"    , SD4->D4_TRT 		, Nil})				
				
				aAdd(aSd3, {"D3_LOCALIZ", aLotespOrig[_nn,3], NIL})
				
				DbSelectArea("SD3")
				DbSetOrder(1)

				lMsErroAuto := .F.
				lOk := .T.
				MSExecAuto({|x| MATA240(x)}, aSd3)
				                                                      
				If lMsErroAuto
		            mostraerro()
					lOk := .F.
				ENDIF
				
				IF lOk
				    RECLOCK("SD3",.F.)
				    D3_USUARIO := "ACERTA_OP"
				    MSUNLOCK()
				    
					_ctexto += SD4->D4_COD +" - "+TRANSFORM(aLotespOrig[_nn,4],"@e 9999,999.999999")+" - OK "+CHR(13)+CHR(10)
					
				ELSE
					_ctexto += SD4->D4_COD +" - "+TRANSFORM(aLotespOrig[_nn,4],"@e 9999,999.999999")+" - ERROR - NAO BAIXADO" +CHR(13)+CHR(10)
					_cErros += SD4->D4_op+" - "+SD4->D4_COD +" - "+ TRANSFORM(aLotespOrig[_nn,4],"@e 9999,999.999999")+" - CADASTROS" + CHR(13)+ CHR(10)
				ENDIF
				
			ENDIF
			
		next _nn
		
		dbSelectArea("SD4")
	endif
	restarea(_CareaSd4)
	dbSkip()
	
End


return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAGLOP001  บ Autor ณ RVG                ณ Data ณ 07/04/13    ณฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fCriaSx1()
/* Removido 11/05/23 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
DBSELECTAREA("SX1")

If ! DbSeek(cPerg+"01",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Data de"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par01"
	MsUnLock()
Endif

If ! DbSeek(cPerg+"02",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Data ate"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par02"
	MsUnLock()
Endif

If ! DbSeek(cPerg+"03",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "OP de"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 13
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_F3      := "SC2"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par03"
	MsUnLock()
Endif

If ! DbSeek(cPerg+"04",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "OP de"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 13
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_F3      := "SC2"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par04"
	MsUnLock()
Endif
*/

Return

