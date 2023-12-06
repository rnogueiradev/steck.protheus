#INCLUDE "Topconn.ch"
#Include "rwmake.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPCPRL003  บAutor  ณEveraldo Gallo      บ Data ณ  03/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function pcprl003
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Variaveis obrigatorias dos programas de relatorio            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	LOCAL Tamanho  := "M"
	lOCAL titulo   := "Projecao de Necessidades "
	LOCAL cDesc1   := "Este programa emite a relao de estrutura de um determinado produto"
	LOCAL cDesc2   := "selecionado pelo usu rio. Esta relao no demonstra custos. Caso o"
	LOCAL cDesc3   := "produto use opcionais, ser  listada a estrutura com os opcionais padro."
	LOCAL cString  := "SG1"
	LOCAL wnrel	   := "PCPRL003"
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Variaveis tipo Private padrao de todos os relatorios         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PRIVATE aReturn := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }		//
	PRIVATE nLastKey:= 0
	PRIVATE cPerg := "PCPR030001"
	PRIVATE _cSoma := ""
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica as perguntas selecionadas                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Variaveis utilizadas para parametros ณ
	//ณ mv_par01   // Produto de             ณ
	//ณ mv_par02   // Produto ate            ณ
	//ณ mv_par03   // Tipo de                ณ
	//ณ mv_par04   // Tipo ate               ณ
	//ณ mv_par05   // Grupo de               ณ
	//ณ mv_par06   // Grupo ate              ณ
	//ณ mv_par07   // Semana Base            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	_fCriaSx1()
	
	Pergunte(cPerg,.F.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Envia controle para a funcao SETPRINT                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
	
	If nLastKey = 27
		Set Filter to
		Return
	EndIf
	
	SetDefault(aReturn,cString)
	
	If nLastKey = 27
		Set Filter to
		Return
	EndIf
	
	_cQuery := " SELECT B1_COD,B1_DESC,B1_TIPO,B1_UM,B1_GRUPO,B1_QE
	_cQuery += " FROM " +  	RETSQLNAME("SB1")
	_cQuery += " WHERE "+ 	RETSQLNAME("SB1") + ".D_E_L_E_T_ <> '*'  AND "
	_cQuery += " 				B1_FILIAL = '" + XFILIAL("SB1") +"'  AND "
	_cQuery += " B1_COD    BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
	_cQuery += " B1_GRUPO  BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND"
	_cQuery += " B1_TIPO   BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
	_cQuery += " B1_MSBLQL  != '1' "
	if mv_par09 = 1
		_cQuery += " AND B1_IMPORT = 'S' "
	elseif mv_par09 = 2
		_cQuery += " AND B1_IMPORT != 'S' "
	endif
	_cQuery += " ORDER BY B1_COD"
	
	_cQuery := ChangeQuery(_cQuery)
	
	TcQuery _cQuery New Alias "QR1"
	
	DbSelectArea("QR1")
	DbGoTop()
	_nRec := 0
	DbEval({|| _nRec++  })
	
	DbSelectArea("QR1")
	
	DbGoTop()
	
	
	if reccount() == 0
		RptStatus({|lEnd| R03IMP(@lEnd,wnRel,titulo,Tamanho)},titulo)
	else
		MsgStop("Segundo seus parametros, nao foi possivel localizar dados !!!! Verifique !!!")
	endif
	
Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ R003IMP  ณ Autor ณ Everaldo Gallo        ณ Data ณ 03/07/08 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Chamada do Relatorio                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ PCPRL003			                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function R03IMP(lEnd,WnRel,titulo,Tamanho)
	
	LOCAL cRodaTxt 	:= "ESTRUTURA(S)"
	LOCAL nCntImpr 	:= 0
	LOCAL nTipo    	:= 0
	LOCAL cProduto 	:=""
	LOCAL nNivel    := 1
	LOCAL cPictQuant	:=""
	LOCAL cPictPerda	:=""
	LOCAL nX			:=0
	LOCAL nPosCnt		:=0
	LOCAL nPosOld		:=0
	LOCAL _cArea
	LOCAL _ni := 0
	PRIVATE li 			:= 80
	PRIVATE m_pag 		:= 1
	PRIVATE aESTRUTURA	:= {}
	PRIVATE _aColunas 	:= {50,60,70,80,90,100,110,120}
	
	PRIVATE _aTotais    := {0,0,0,0,0,0,0,0}
	PRIVATE _nQuant := 0
	PRIVATE _nValor := 0
	
	PRIVATE _aCompras	:= {}
	PRIVATE _aSolCompras	:= {}
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta o Cabecalho de acordo com o tipo de emissao            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู        9999,999 9999,999 9999,999 9999,999 9999,999 9999,999 9999,999 9999,999
	cabec1 := "COMPONENTE                                     QT SEM. MM   SEM. XX   SEM. XX   SEM. XX   MES XX    MES XX    MES XX    MES XX"
	cabec2 := " APLICACAO      CLINTE       EST.PROD.ACAB     ES --------  --------  -------   --------  --------  --------  --------  --------"
	// 0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
	// 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	//    999,999,999 999,999,999 999,999,999 999,999,999 9999
	
	nTipo  := IIF(aReturn[4]==1,15,18)
	
	
	SetRegua(_nRec)
	
	DbSelectArea("QR1")
	
	_aTab_Estrut := {}
	
	_ddtbase:=U__CALC_DTSEM(MV_PAR07,2)
	_aDatas := {}
	cabec1  := "COMPONENTE                                     QT "
	cabec2  := " APLICACAO      CLINTE       EST.PROD.ACAB     ES "
	_nsem 	:= val(substr(mv_par07,1,2))-1
	_cmonth := month(_ddtbase)
	
	_dDtini := _ddtbase
	
	FOR _ni := 1 to 4  //proximas 4 semanas
		cabec1 += "SEM." + strzero(_nsem+_ni,2) + "    "
		_cSSAA := strzero(((_nsem+_ni) * 100) + val(substr(mv_par07,3,2)), 4)
		_nFimSemana := U__CALC_DTSEM(_cSSAA,2)
		_cTextoSemana := substr(dtos(_nFimSemana - 6), 7, 2) + "-" + substr(dtos(_nFimSemana), 7, 2) + "/" + substr(dtos(_nFimSemana), 5, 2)
		cabec2 += _cTextoSemana + "  "
		aadd(_aDatas,_ddtbase)
		_ddtbase+=7
		if _cmonth # month(_ddtbase)
			//	cabec1 += "SEM." + strzero(_nsem+_ni+1,2) + "    "
			//	aadd(_aDatas,lastday(_ddtbase-7))
			//	exit
		endif
	next _ni
	
	
	FOR _ni := 1 to 8-len(_aDatas)  // proximos 4 meses
		_ddtbase := lastday(_ddtbase)
		cabec1 += "MES " + STRZERO(MONTH(_ddtbase),2) + "    "
		cabec2 += "--------  "
		aadd(_aDatas,_ddtbase)
		_ddtbase+=1
	next _ni
	
	_dDtFim := _aDatas[len(_aDatas)]
	
	
	Do while !eof()
		
		aESTRUTURA	:= {}
		
		DbSelectArea("QR1")
		_carea := getarea()
		
		Monta_uso(qr1->b1_cod,1,0)
		
		DbSelectArea("QR1")
		_nRec2 := 0
		
		_aVendas  := {}
		
		_cTexto := ""
		
		if len(aEstrutura) > 0
			
			_cTexto :="("
			
			For _ni:=1 TO LEN(aestrutura)
				_cTexto+="'"+aestrutura[_ni,1]+"',"
				Aadd(_aVendas, {0,0,0,0,0,0,0,0} )
			Next _ni
			
			
			_cTexto:=substr(_cTexto,1,len(_cTexto)-1)+")"
			
			/*/
			cQuery := "SELECT C4_FILIAL "
			cQuery += "FROM "
			cQuery += RetSQLName("SC4")+" SC4 "
			cQuery += "WHERE "
			if mv_par08 = 1
				cQuery +=	"C4_FILIAL='"+xFilial("SC4")+"' AND "
			ENDIF
			cQuery += "C4_DATA BETWEEN '"  +DToS(_dDtIni)+"' AND '"+DToS(_dDtFim)+"' AND "
			//	cQuery += "C4_DATA  >= '" +DToS(dDataBase)+"' AND "
			cQuery += "C4_PRODUTO IN "+ _cTexto+" AND "
			cQuery += "C4_LOCAL BETWEEN '" + MV_PAR10 + "' AND '" + MV_PAR11 + "' AND "
			cQuery += "SC4.D_E_L_E_T_=' ' "
			cQuery += "ORDER BY C4_PRODUTO,C4_DATA"
			
			cQuery := ChangeQuery(cQuery)
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TZERO",.T.,.T.)
			
			DbSelectArea("TZERO")
			DbGoTop()
			
			DbEval({|| _nRec2++  })
			
			DbSelectArea("TZERO")
			DbCloseArea("TZERO")
			/*/
		Endif
		
		DbSelectArea("QR1")
		
		
		IF LEN(aESTRUTURA) # 0 //.AND. _nRec2 > 0
			
			If li > 55
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
			EndIf
			
			@ LI, 0 PSAY qr1->b1_cod + "-"+ QR1->B1_DESC
			
			li++
			
			IMPR_SC7(WnRel,titulo,Tamanho)
			
			li++
			_aTotais    := {0,0,0,0,0,0,0,0}
			
			@ LI, 1 PSAY "Previsao de Vendas"
			
			LI++
			
			IMPR_VDAS(WnRel,titulo,Tamanho)
			
			@ LI, 0 PSAY replicate("=",130)
			
			LI+=2
			
		ENDIF
		
		dbselectarea("QR1")
		restarea(_carea)
		incregua()
		dbskip()
		
	enddo
	
	dbSelectArea("QR1")
	dbCloseArea("QR1")
	
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	If aReturn[5] = 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	EndIf
	
	MS_FLUSH()
	
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fCriaSx1 บAutor  ณEVERALDO SILGA GALLOบ Data ณ  19/12/05   บฑฑ
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
/* Removido 11/05/23 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
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
		SX1->X1_PERGUNT := "Semana Base (SSAA)"
		SX1->X1_VARIAVL := "mv_ch7"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 4
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par07"
		SX1->X1_DEF01   := ""
		SX1->X1_F3		 := ""
		MsUnLock()
	EndIf
	
	
	If ! DbSeek(cPerg+"08",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "08"
		SX1->X1_PERGUNT := "Considera Filiais"
		SX1->X1_VARIAVL := "mv_ch8"
		SX1->X1_TIPO    := "N"
		SX1->X1_TAMANHO := 1
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "C"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par08"
		SX1->X1_DEF01   := "So a Corrente"
		SX1->X1_DEF02   := "Todas Filiais"
		SX1->X1_F3		 := ""
		MsUnLock()
	EndIf
	
	If ! DbSeek(cPerg+"09",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "09"
		SX1->X1_PERGUNT := "Origem "
		SX1->X1_VARIAVL := "mv_ch9"
		SX1->X1_TIPO    := "N"
		SX1->X1_TAMANHO := 1
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "C"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par09"
		SX1->X1_DEF01   := "Importados "
		SX1->X1_DEF02   := "Nacionais "
		SX1->X1_DEF03	 :="Todos"
		MsUnLock()
	EndIf
	
	If ! DbSeek(cPerg+"10",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "10"
		SX1->X1_PERGUNT := "Armazem de "
		SX1->X1_VARIAVL := "mv_cha"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 2
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par10"
		SX1->X1_DEF01   := ""
		SX1->X1_F3		 := ""
		MsUnLock()
	EndIf
	
	
	If ! DbSeek(cPerg+"11",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "11"
		SX1->X1_PERGUNT := "Armazem ate "
		SX1->X1_VARIAVL := "mv_chb"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 2
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par11"
		SX1->X1_DEF01   := ""
		SX1->X1_F3		 := ""
		MsUnLock()
	EndIf
	
	If ! DbSeek(cPerg+"12",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "12"
		SX1->X1_PERGUNT := "Lead Time "
		SX1->X1_VARIAVL := "mv_chc"
		SX1->X1_TIPO    := "N"
		SX1->X1_TAMANHO := 1
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "C"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par12"
		SX1->X1_DEF01   := "Nenhum "
		SX1->X1_DEF02   := "Total "
		SX1->X1_DEF03	 :="So do PA"
		MsUnLock()
	EndIf
	
	If ! DbSeek(cPerg+"13",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "13"
		SX1->X1_PERGUNT := "Abate Saldo PA "
		SX1->X1_VARIAVL := "mv_chc"
		SX1->X1_TIPO    := "N"
		SX1->X1_TAMANHO := 1
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "C"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par13"
		SX1->X1_DEF01   := "Sim "
		SX1->X1_DEF02   := "Nao "
		
		MsUnLock()
	EndIf
	*/
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMonta_uso บAutor  ณMicrosiga           บ Data ณ  07/03/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function Monta_uso( _cCodigo,_nFator , _nLeadTime)
	
	Local _asavArea, _nrec
	Local _xCodigo 		:= _cCodigo
	Local _xFator  		:= _nfator
	Local _xLeadTime 	:= _nLeadTime
	
	Dbselectarea("SG1")
	DBSETORDER(2)
	DBSEEK(xfilial("SG1")+_xCodigo)
	
	_asavArea := getarea()
	
	do while !eof() .and. _xCodigo == G1_COMP
		
		_nrec:= recno()
		
		if SG1->g1_fim >= _dDtini
			
			_nLeadAtual := Posicione("SB1",1,XFILIAL("SB1")+SG1->G1_COD,"B1_PE")
			
			DBSELECTAREA("SC4")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SC4")+SG1->G1_COD)
			
			IF !EOF()
				_nPos := aScan(aEstrutura ,{|x| Alltrim(Upper(x[1])) == Alltrim(Upper(SG1->G1_COD)) })
				IF _nPos == 0
					AADD(AESTRUTURA, { SG1->G1_COD , SG1->G1_QUANT*_xFator*(1+(SG1->G1_PERDA/100)) , " ",if(mv_par12 = 1,0,if(mv_par12 = 2,_xLeadTime+_nLeadAtual,_nLeadAtual)) } )
				ELSE
					AESTRUTURA[_nPos,2] +=  SG1->G1_QUANT*_xFator*(1+(SG1->G1_PERDA/100))
				ENDIF
			ENDIF
			
			dbselectarea("SG1")
			dbseek(xfilial("SG1")+SG1->G1_COD )
			
			IF !EOF()
				dbgoto(_nrec)
				
				Monta_uso( SG1->G1_COD , SG1->G1_QUANT*_xFator*(1+(SG1->G1_PERDA/100)) , _xLeadTime+_nLeadAtual )
				
			ENDIF
			restarea(_asavArea)
			dbgoto(_nrec)
		endif
		
		restarea(_asavArea)
		dbgoto(_nrec)
		DBSKIP()
		
	enddo
	
RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpr_sc7  บAutor  ณMicrosiga           บ Data ณ  14/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Impr_sc7(WnRel,titulo,Tamanho)
	
	Local	_nQuantCQ := 0
	Local	_nQuantNC := 0
	Local nLoop := 0
	Local a:= 0
	Local _nCols := 0
	Local _nlins := 0  
	
	aStruSC1 := SC1->( dbStruct() )
	
	cQuery := "SELECT * "
	cQuery += "FROM "
	cQuery += RetSQLName("SC1")+" SC1 "
	cQuery += "WHERE "
	if mv_par08 = 1
		cQuery += "C1_FILIAL='"+xFilial("SC1")+"' AND "
	ENDIF
	cQuery += "C1_DATPRF < '"  +DToS(_ddtbase)+"' AND "
	cQuery += "C1_QUJE < C1_QUANT  AND "
	cQuery += "C1_RESIDUO 	<> 'S' AND "
	cQuery += "C1_PRODUTO = '" + qr1->b1_cod + "' AND "
	cQuery += "C1_TPOP   <> 'P' AND "
	cQuery += "SC1.D_E_L_E_T_=' '"
	cQuery += "ORDER BY C1_PRODUTO,C1_DATPRF"
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSC1",.T.,.T.)
	
	For nLoop := 1 To Len( aStruSC1 )
		If aStruSC1[ nLoop, 2 ] <> "C" .And. !Empty( TSC1->( FieldPos( aStruSC1[ nLoop, 1 ] ) ) )
			TcSetField("TSC1",aStruSC1[ nLoop, 1 ],aStruSC1[ nLoop, 2 ],aStruSC1[ nLoop, 3 ],aStruSC1[ nLoop, 4 ] )
		EndIf
	Next nLoop
	
	dbSelectArea("TSC1")
	dbGoTop()
	
	_aSolCompras := {{0,0,0,0,0,0,0,0}}
	
	Dbselectarea("TSC1")
	Do while !eof()
		
		for a:=1 to len(_aDatas)
			if tsc1->C1_datprf <= _aDatas[A]
				_nCount := a
				exit
			endif
		next a
		_aSolCompras[1,_nCount] += (C1_QUANT-C1_QUJE)
		
		//   _aTotais[1,_nCount] += (C7_QUANT-C7_QUJE)
		//   _aTotais[2,_nCount] += ((C7_QUANT-C7_QUJE)*C7_PRECO)
		DbSkip()
		
	Enddo
	
	Dbselectarea("TSC1")
	DbClosearea("TSC1")
	
	aStruSC7 := SC7->( dbStruct() )
	
	cQuery := "SELECT * "
	cQuery += "FROM "
	cQuery += RetSQLName("SC7")+" SC7 "
	cQuery += "WHERE "
	if mv_par08 = 1
		cQuery += "C7_FILIAL='"+xFilial("SC7")+"' AND "
	ENDIF
	cQuery += "C7_DATPRF < '"  +DToS(_ddtbase)+"' AND "
	cQuery += "C7_QUJE < C7_QUANT  AND "
	cQuery += "C7_RESIDUO 	<> 'S' AND "
	cQuery += "C7_PRODUTO = '" + qr1->b1_cod + "' AND "
	cQuery += "SC7.D_E_L_E_T_=' '"
	cQuery += "ORDER BY C7_PRODUTO,C7_DATPRF"
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSC7",.T.,.T.)
	
	For nLoop := 1 To Len( aStruSC7 )
		If aStruSC7[ nLoop, 2 ] <> "C" .And. !Empty( TSC7->( FieldPos( aStruSC7[ nLoop, 1 ] ) ) )
			TcSetField("TSC7",aStruSC7[ nLoop, 1 ],aStruSC7[ nLoop, 2 ],aStruSC7[ nLoop, 3 ],aStruSC7[ nLoop, 4 ] )
		EndIf
	Next nLoop
	
	dbSelectArea("TSC7")
	dbGoTop()
	
	_aCompras := {{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0}}
	
	Dbselectarea("TSC7")
	Do while !eof()
		
		for a:=1 to len(_aDatas)
			if tsc7->C7_datprf <= _aDatas[A]
				_nCount := a
				exit
			endif
		next a
		_aCompras[1,_nCount] += (C7_QUANT-C7_QUJE)
		_aCompras[2,_nCount] += ((C7_QUANT-C7_QUJE)*C7_PRECO)
		
		//   _aTotais[1,_nCount] += (C7_QUANT-C7_QUJE)
		//   _aTotais[2,_nCount] += ((C7_QUANT-C7_QUJE)*C7_PRECO)
		DbSkip()
		
	Enddo
	
	Dbselectarea("SB2")
	Dbsetorder(1)
	dbseek(xfilial("SB2")+qr1->b1_cod+getmv("MV_CQ") )
	_nQuantCQ := IF(SB2->B2_QATU>=0,SB2->B2_QATU,0)
	
	// Eduardo Alberti Em 05-Apr-2011
	// Soma Saldo Do Produto No Almoxarifado NC
	_aArSB2	:= SB2->(GetArea())
	Dbselectarea("SB2")
	Dbsetorder(1)
	dbseek(xfilial("SB2")+qr1->b1_cod+ "NC")
	_nQuantNC := IF(SB2->B2_QATU>=0,SB2->B2_QATU,0)
	RestArea(_aArSB2)
	// Fim - Eduardo Alberti Em 05-Apr-2011
	// Fim Programas
	
	_cQuest := "SELECT sum(B2_QATU) AS QUANT,SUM(B2_VATU1) AS VALOR FROM "+RETSQLNAME('SB2')+" WHERE B2_COD = '"+qr1->b1_cod+"'  AND D_E_L_E_T_ = '' AND B2_LOCAL BETWEEN '" +MV_PAR10+ "' AND  '" +MV_PAR11 + "' "
	if mv_par08 == 1
		_cQuest += " AND B2_FILIAL = '" +XFILIAL("SB2")+ "'"
	endif
	_cQuest := ChangeQuery(_cQuest)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuest),"TSB2",.T.,.T.)
	
	Dbselectarea("TSB2")
	_nQuant := TSB2->QUANT
	_nValor := TSB2->VALOR
	DBCLOSEAREA("TSB2")
	
	For _nLins := 1 to len(_Acompras)
		if _nLins == 1
			@ li,3 psay "Qtde em Estoque  " + transform(_nQuant,"@E 999,999.99")
			@ li,32 psay "Ped.Compra Qtd."
		else
			@ li,3 psay "Valor em Estoque " + transform(_nValor,"@E 999,999.99")
			@ li,32 psay "Ped.Compra Valor"
		endif
		For _nCols := 1 to len(_aColunas)
			@ li,_aColunas[_nCols] PSAY _aCompras[_nlins,_nCols] PICTURE "@E 9999,999"
		Next _nCols
		li++
	Next _nlins
	@ li,3 psay "Qtde no CQ        "+ transform(_nQuantCQ,"@E 999,999.99")
	
	@ li,32 psay "Qtde S.Compra"
	For _nCols := 1 to len(_aColunas)
		@ li,_aColunas[_nCols] PSAY _aSolCompras[1,_nCols] PICTURE "@E 9999,999"
	Next _nCols
	li++
	
	// Eduardo Alberti Em 05-Apr-2011
	// Imprime Saldo Do Produto No Almoxarifado NC
	@ li,3 psay "Qtde no NC        "+ transform(_nQuantNC,"@E 999,999.99")
	li++
	// Fim - Eduardo Alberti Em 05-Apr-2011
	
	dbSelectArea("TSC7")
	dbCloseArea("TSC7")
	
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPCPRL003  บAutor  ณMicrosiga           บ Data ณ  07/14/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Impr_Vdas(WnRel,titulo,Tamanho)
	
	Local _lPed 	:= .t.
	Local _dDtIni 	:= CtoD("")
	Local _dDtFim	:= CtoD("")
	Local _cProduto
	Local nLoop := 0
	Local a:= 0
	Local _nCols := 0
	Local _nlins := 0  
	aStruSC4 := SC4->( dbStruct() )
	
	cQuery := "SELECT * "
	cQuery += "FROM "
	cQuery += RetSQLName("SC4")+" SC4 "
	cQuery += "WHERE "
	if mv_par08 = 1
		cQuery +=	"C4_FILIAL='"+xFilial("SC4")+"' AND "
	ENDIF
	cQuery += "C4_DATA < '"  +DToS(_ddtbase)+"' AND "
	cQuery += "C4_PRODUTO IN "+ _cTexto+" AND "
	cQuery += "C4_LOCAL BETWEEN '" + MV_PAR10 + "' AND '" + MV_PAR11 + "' AND "
	cQuery += "SC4.D_E_L_E_T_=' ' " /*AND C4_IMPORT <> 'S' "*/
	cQuery += "ORDER BY C4_PRODUTO,C4_DATA"
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSC4",.T.,.T.)
	
	For nLoop := 1 To Len( aStruSC4 )
		If aStruSC4[ nLoop, 2 ] <> "C" .And. !Empty( TSC4->( FieldPos( aStruSC4[ nLoop, 1 ] ) ) )
			TcSetField("TSC4",aStruSC4[ nLoop, 1 ],aStruSC4[ nLoop, 2 ],aStruSC4[ nLoop, 3 ],aStruSC4[ nLoop, 4 ] )
		EndIf
	Next nLoop
	
	dbSelectArea("TSC4")
	dbGoTop()
	
	_aTotais := {0,0,0,0,0,0,0,0}
	
	Do while !eof()
		
		_nLinha   	:= aScan(aEstrutura ,{|x| Alltrim(Upper(x[1])) == Alltrim(Upper(TSC4->C4_PRODUTO)) })
		_nCount 	:= 0
		
		for a:=1 to len(_aDatas)
			if tsc4->C4_data-aEstrutura[_nlinha,4] <= _aDatas[A]
				_nCount := a
				exit
			endif
		next a
		
		aEstrutura[_nLinha,3] := " "
		
		_aVendas[_nLinha,_nCount] += (C4_QUANT * aEstrutura[_nLinha,2])
		
		_aTotais[_nCount] += (C4_QUANT * aEstrutura[_nLinha,2])
		
		// ROTINA 001 RETIRADA DESTE PONTO
		
		DbSkip()
		
	Enddo
	dbSelectArea("TSC4")
	dbCloseArea("TSC4")
	
	aStruSC6 := SC6->( dbStruct() )
	
	cQuery := "SELECT * "
	cQuery += "FROM "
	cQuery += RetSQLName("SC6")+" SC6 "
	cQuery += "WHERE "
	if mv_par08 = 1
		cQuery +=	"C6_FILIAL='"+xFilial("SC6")+"' AND "
	ENDIF
	cQuery += "C6_ENTRE1 < '"  +DToS(_ddtbase)+"' AND "
	cQuery += "C6_PRODUTO IN "+ _cTexto+" AND "
	cQuery += "C6_LOCAL BETWEEN '" + MV_PAR10 + "' AND '" + MV_PAR11 + "' AND "
	cQuery += "SC6.D_E_L_E_T_=' ' AND C6_BLQ <> 'R' "
	cQuery += "ORDER BY C6_PRODUTO,C6_ENTRE1"
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSC6",.T.,.T.)
	
	For nLoop := 1 To Len( aStruSC6 )
		If aStruSC6[ nLoop, 2 ] <> "C" .And. !Empty( TSC6->( FieldPos( aStruSC6[ nLoop, 1 ] ) ) )
			TcSetField("TSC6",aStruSC6[ nLoop, 1 ],aStruSC6[ nLoop, 2 ],aStruSC6[ nLoop, 3 ],aStruSC6[ nLoop, 4 ] )
		EndIf
	Next nLoop
	
	dbSelectArea("TSC6")
	dbGoTop()
	
	Do while !eof()
		
		_nLinha   	:= aScan(aEstrutura ,{|x| Alltrim(Upper(x[1])) == Alltrim(Upper(TSC6->C6_PRODUTO)) })
		_nCount 		:= 0
		
		for a:=1 to len(_aDatas)
			if tsc6->C6_ENTRE1-aEstrutura[_nlinha,4] <= _aDatas[A]
				_nCount := a
				exit
			endif
		next a
		
		_aVendas[_nLinha,_nCount] 	+= ((C6_QTDVEN-C6_QTDENT) * aEstrutura[_nLinha,2])
		
		_aTotais[_nCount] 			+= ((C6_QTDVEN-C6_QTDENT) * aEstrutura[_nLinha,2])
		
		DbSkip()
		
	Enddo
	
	dbSelectArea("TSC6")
	dbCloseArea("TSC6")
	
	
	/// Listando tabela de vendas de onde o produto ้ usado
	
	For _nLins := 1 to len(aestrutura)
		
		If li > 55
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
			@ LI, 0 PSAY qr1->b1_cod + "-"+ QR1->B1_DESC
			li++
		EndIf
		
		dbSelectArea("SA7")
		dbSetOrder(1)
		dbSeek(xFilial("SA7")+qr1->b1_cod)
		IF !EOF()
			_cCodCli := SA7->A7_DESCCLI
		ELSE
			_cCodCli := ""
		ENDIF
		
		_cQuest := "SELECT sum(B2_QATU) AS QUANT,SUM(B2_VATU1) AS VALOR FROM "+RETSQLNAME('SB2')+" WHERE B2_COD = '"+SUBSTR(aestrutura[_nLins,1],1,15)+"'  AND D_E_L_E_T_ = '' AND B2_LOCAL BETWEEN '" +MV_PAR10+ "' AND  '" +MV_PAR11 + "' "
		if mv_par08 == 1
			_cQuest += " AND B2_FILIAL = '" +XFILIAL("SB2")+ "'"
		endif
		_cQuest := ChangeQuery(_cQuest)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuest),"TSB2",.T.,.T.)
		Dbselectarea("TSB2")
		_nQuant_abate := TSB2->QUANT * aestrutura[_nLins,2]
		
		_nQuant_filho := TSB2->QUANT
		DBCLOSEAREA("TSB2")
		
		if mv_par13 = 1
			For _nCols := 1 to len(_aColunas)
				if _aVendas[_nlins,_nCols] > 0 .and. _nQuant_abate > 0
					if _aVendas[_nlins,_nCols] > _nQuant_abate
						_aVendas[_nlins,_nCols] -=  _nQuant_abate
						_aTotais[_nCols] -= _nQuant_abate
						_nQuant_abate := 0
						
					else
						_nQuant_abate -= _aVendas[_nlins,_nCols]
						_aTotais[_nCols] -= _aVendas[_nlins,_nCols]
						_aVendas[_nlins,_nCols] :=0
					endif
				endif
				
			Next _nCols
			
		endif
		
		if _aVendas[_nlins,1]+_aVendas[_nlins,2]+_aVendas[_nlins,3]+_aVendas[_nlins,4]+_aVendas[_nlins,5]+_aVendas[_nlins,6]+_aVendas[_nlins,7]+_aVendas[_nlins,8] # 0
			
			
			@ li,1  PSAY SUBSTR(aestrutura[_nLins,1],1,15)
			@ li,16 PSAY SUBSTR(aEstrutura[_nLins,3],1,12) //SUBSTR(_cCodCli,1,15)
			@ li,29 PSAY _nQuant_filho  PICTURE "@E 9999,999" //SUBSTR(aEstrutura[_nLins,3],1,11)
			@ li,43 PSAY aestrutura[_nLins,2] PICTURE "@E 99.9999"
			For _nCols := 1 to len(_aColunas)
				@ li,_aColunas[_nCols] PSAY _aVendas[_nlins,_nCols] PICTURE "@E 9999,999"
			Next _nCols
			li++
		endif
	Next _nlins
	
	_aAcumulados := {0,0,0,0,0,0,0,0}
	_aSaldos_est := {0,0,0,0,0,0,0,0}
	_aSaldos_Prj := {0,0,0,0,0,0,0,0}
	_nTotal := 0
	_nTot_Est := _nQuant
	_nTot_Prj := _nQuant
	li++
	@ li,3  PSAY "Total"
	For a:=1 to len(_aTotais)
		@ li,_aColunas[a] PSAY _aTotais[a] PICTURE "@E 9999,999"
		_nTotal+=_aTotais[a]
		_nTot_Est-=(_aTotais[a])
		_nTot_Prj+=(_aCompras[1,a]-_aTotais[a])
		_aAcumulados[a]:=_nTotal
		_aSaldos_Prj[a]:=_nTot_Prj
		_aSaldos_est[a]:=_nTot_est
	next a
	li++
	@ li,3  PSAY "Acumulado"
	For a:=1 to len(_aAcumulados)
		@ li,_aColunas[a] PSAY _aAcumulados[a] PICTURE "@E 9999,999"
	next a
	li++
	@ LI, 0 PSAY replicate("-",130)
	LI++
	@ li,3  PSAY "Saldo Real"
	For a:=1 to len(_aSaldos_est)
		@ li,_aColunas[a] PSAY _aSaldos_est[a] PICTURE "@E 9999,999"
	next a
	LI++
	@ li,3  PSAY "Saldo Projetado"
	For a:=1 to len(_aSaldos_prj)
		@ li,_aColunas[a] PSAY _aSaldos_prj[a] PICTURE "@E 9999,999"
	next a
	LI++
	@ li,3  PSAY "Projetado + SC"
	_nSCAcum := 0
	For a:=1 to len(_aSaldos_prj)
		@ li,_aColunas[a] PSAY (_aSaldos_prj[a]+_aSolCompras[1,a]) + _nSCAcum PICTURE "@E 9999,999"
		_nSCAcum += _aSolCompras[1,a]
	next a
	LI++
	
	
return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ _fVendas ณ Autor ณ Eduardo Alberti       ณ Data ณ02/Feb/10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Determina Quantidade Nos Saldos De Pedidos De Vendas.      ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fVendas(_cPrdVen,_dDtIni,_dDtFim)
	
	Local _aArea	:= GetArea()
	Local _aArSC6	:= SC6->(GetArea())
	Local cAlias 	:= GetNextAlias()
	Local _nTotal	:= 0
	
	DbSelectArea("SC6")
	
	_nTamCpo	:= TamSX3("C6_QTDVEN")[1]
	_nDecCpo	:= TamSX3("C6_QTDVEN")[2]
	_cDataIni	:= DtoS(_dDtIni)
	_cDataFim	:= DtoS(_dDtFim)
	
	BeginSql Alias cAlias
		
		//COLUMN D1_QUANT AS DATE
		COLUMN TOTAL AS NUMERIC(_nTamCpo,_nDecCpo)
		
		SELECT  Sum(C6_QTDVEN - C6_QTDENT) AS TOTAL
		FROM    %Table:SC6% SC6
		WHERE   SC6.C6_FILIAL 	= 	%xFilial:SC6%
		AND     SC6.C6_PRODUTO 	= 	%Exp:_cPrdVen%
		AND     SC6.C6_QTDVEN 	> 	SC6.C6_QTDENT
		AND		SC6.C6_ENTRE1	>=	%Exp:_cDataIni%
		AND		SC6.C6_ENTRE1	<=	%Exp:_cDataFim%
		AND     SC6.C6_BLQ 		<>	'R'
		AND		SC6.%NotDel%
		
		/*
		SELECT D1_LOTECTL,D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_EMISSAO,D1_ITEM,D1_QUANT,D1_UM
		FROM %Table:SD1% SD1
		WHERE
		SD1.D1_FILIAL 	= %xFilial:SD1% AND
		SD1.D1_COD   	= %Exp:_cCod% AND
		SD1.D1_LOTECTL	= %Exp:_cLote% AND
		SD1.%NotDel%
		ORDER BY %Exp:_cOrder%
		*/
		
	EndSql
	
	_nTotal := (cAlias)->TOTAL
	DbSelectArea(cAlias)
	DbCloseArea()
	
	RestArea(_aArSC6)
	RestArea(_aArea)
	
Return(_nTotal)



/*/ ROTINA 001
// Complementa Arrays De Vendas e Totais Com Pedidos De Vendas
//If _lPed
If TSC4->C4_PRODUTO <> _cProduto
	
	//_lPed := .f.
	_cProduto := TSC4->C4_PRODUTO
	
	For _i := 1 To Len(_aDatas)
		
		If _i <= 4
			_dDtIni := (_aDatas[_i] -7) - aEstrutura[_nlinha,4]
			_dDtFim := (_aDatas[_i]) - aEstrutura[_nlinha,4]
		Else
			_dDtIni := (FirstDay(_aDatas[_i])) - aEstrutura[_nlinha,4]
			_dDtFim := (_aDatas[_i] - aEstrutura[_nlinha,4])
		EndIf
		
		// Busca Saldos Contidos No SC6
		_nQtdVen := _fVendas(TSC4->C4_PRODUTO,_dDtIni,_dDtFim)
		
		_aVendas[_nLinha,_nCount] := (_nQtdVen * aEstrutura[_nLinha,2])
		
		IF _nQtdVen <> 0
			_aVendas[_nLinha,_nCount] := (_nQtdVen * aEstrutura[_nLinha,2])
			_aTotais[_nCount] -= _aTotais[_nCount]
			_aTotais[_nCount] += (_nQtdVen * aEstrutura[_nLinha,2])
			
		ENDIF
		
	Next _i
	
	
	
	
EndIf

FIM DA ROTINA 001
/*/


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_CALC_DTSEMบAutor  ณMicrosiga           บ Data ณ  05/13/08   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ _xsemana:= semana do ano a saber (MMAA)                     บฑฑ
ฑฑบ          ณ _ntipo  := tipo 1=primeiro dia  e 2=ultimo dia              บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                          บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


USER FUNCTION _CALC_DTSEM(_xsemana,_ntipo)
	
	_dPridSem := ctod("01/01/"+substr(_xsemana,3,2))+ (8- (dow( ctod("01/01/"+ substr(_xsemana,3,2) ) ) ) ) // CALCULA PRIMEIRO DIA DA 2 SEMANA DO ANO
	if _ntipo == 1
		_DdIA  	  := if( substr(_xsemana,1,2) = "01" ,ctod("01/01/"+ substr(_xsemana,3,2)), _dPridSem + ((VAL(substr(_xsemana,1,2))-2) * 7 ) ) // DEVOLE A SEMANA DO ANO no tipo caracter de 2
	else
		_DdIA  	  := if( substr(_xsemana,1,2) = "01" ,_dPridSem-1 , _dPridSem + ((VAL(substr(_xsemana,1,2))-2) * 7 ))+6 // DEVOLE A SEMANA DO ANO no tipo caracter de 2
	endif
return(_DdIA )

