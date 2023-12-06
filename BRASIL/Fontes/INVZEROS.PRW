#include "Rwmake.ch" 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บAutor  ณMicrosiga           บ Data ณ  05/03/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function InvZero

PRIVATE cperg := "ACTSB20000"
PRIVATE _nDoc := 1
_fCriaSx1()


IF pergunte(cperg,.t.)
	IF Msgyesno("Deseja criar lanctos zerados de Estoques !!!!")
		Processa({|| acertos() },"Processando...")
	ENDIF
ENDIF




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAcertos   บAutor  ณEveraldo Gallo      บ Data ณ  03/05/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function Acertos


dbselectarea("SB2")
procregua(reccount())
DBSEEK(XFILIAL("SB2")+MV_PAR01,.T.)

DO WHILE B2_COD <= MV_PAR02 .AND. !EOF()
	
	incproc()
	
	IF B2_LOCAL >= MV_PAR05 .AND. B2_LOCAL <= MV_PAR06
		
		DBSELECTAREA("SB1")
		DBSEEK(XFILIAL("SB1")+SB2->B2_COD)
		
		IF !EOF() .AND. B1_TIPO >= MV_PAR03 .AND. B1_TIPO <= MV_PAR04
			IF B1_LOCALIZ = "S"  // ZERA POR ENDERECO - BF
				DBSELECTAREA("SBF")
				DBSETORDER(2)
				DBSEEK(XFILIAL("SBF")+SB2->B2_COD+SB2->B2_LOCAL)
				DO WHILE SB2->B2_COD == BF_PRODUTO .AND. SB2->B2_LOCAL == BF_LOCAL .AND. !EOF()
					IF SBF->BF_QUANT # 0
						SB7->(dbSetOrder(1))
						If !SB7->(dbSeek(xFilial("SB7")+DTOS(DDATABASE)+SBF->BF_PRODUTO+SBF->BF_LOCAL+SBF->BF_LOCALIZ+SBF->BF_NUMSERI+SBF->BF_LOTECTL+SBF->BF_NUMLOTE))
							DBSELECTAREA("SB7")
							RECLOCK("SB7",.T.)
							REPLACE B7_FILIAL     WITH XFILIAL("SB7")
							REPLACE B7_COD        WITH SBF->BF_PRODUTO
							REPLACE B7_LOCAL      WITH SBF->BF_LOCAL
							REPLACE B7_LOCALIZ    WITH SBF->BF_LOCALIZ
							REPLACE B7_LOTECTL    WITH SBF->BF_LOTECTL
							REPLACE B7_NUMLOTE    WITH SBF->BF_NUMLOTE
							REPLACE B7_NUMSERI    WITH SBF->BF_NUMSERI
							REPLACE B7_QUANT      WITH 0
							REPLACE B7_DATA       WITH DDATABASE
							REPLACE B7_DOC        WITH mv_par07
							REPLACE B7_TIPO    	  WITH SB1->B1_TIPO
				
							MSUNLOCK()
				        ENDIF
						_ndoc++
						
					ENDIF 
					
					DBSELECTAREA("SBF")
					DBSKIP()
					
				ENDDO
				
			ELSEIF B1_RASTRO $ "LS" // ZERA POR LOTE - B8
				DBSELECTAREA("SB8")
				DBSETORDER(1)
				DBSEEK(XFILIAL("SB8")+SB2->B2_COD+SB2->B2_LOCAL)
				DO WHILE SB2->B2_COD == B8_PRODUTO .AND. SB2->B2_LOCAL == B8_LOCAL .AND. !EOF()
					IF SB8->B8_SALDO # 0
						SB7->(dbSetOrder(1))
						If !SB7->(dbSeek(xFilial("SB7")+DTOS(DDATABASE)+SB8->B8_PRODUTO+SB8->B8_LOCAL+SPACE(LEN(SB7->B7_LOCALIZ))+SPACE(LEN(SB7->B7_NUMSERI))+SB8->B8_LOTECTL+SB8->B8_NUMLOTE))
							DBSELECTAREA("SB7")
							RECLOCK("SB7",.T.)
							REPLACE B7_FILIAL     WITH XFILIAL("SB7")
							REPLACE B7_COD        WITH SB8->B8_PRODUTO
							REPLACE B7_LOCAL      WITH SB8->B8_LOCAL
							REPLACE B7_LOTECTL    WITH SB8->B8_LOTECTL
							REPLACE B7_NUMLOTE    WITH SB8->B8_NUMLOTE
							REPLACE B7_DTVALID 	  WITH SB8->B8_DTVALID
							REPLACE B7_QUANT      WITH 0
							REPLACE B7_DATA       WITH DDATABASE
							REPLACE B7_DOC        WITH mv_par07
							REPLACE B7_TIPO    	  WITH SB1->B1_TIPO
							MSUNLOCK()
					   
					    ENDIF
					   
						_ndoc++
				
					ENDIF
					DBSELECTAREA("SB8")
					DBSKIP()
				ENDDO
				
			ELSE  // ZERA PELO B2
				DBSELECTAREA("SB7")
				RECLOCK("SB7",.T.)
				REPLACE B7_FILIAL     WITH XFILIAL("SB7")
				REPLACE B7_COD        WITH SB2->B2_COD
				REPLACE B7_LOCAL      WITH SB2->B2_LOCAL
				REPLACE B7_QUANT      WITH 0
				REPLACE B7_DATA       WITH DDATABASE
				REPLACE B7_DOC        WITH mv_par07
				REPLACE B7_TIPO    	  WITH SB1->B1_TIPO
				MSUNLOCK()
				_ndoc++
			ENDIF
		ENDIF
	ENDIF
	DBSELECTAREA("SB2")
	DBSKIP()
ENDDO


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fCriaSx1 บAutor  ณMicrosiga           บ Data ณ  03/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCriacao das perguntas                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fCriaSx1()

DbSelectArea("SX1")
DbSetOrder(1)

If ! DbSeek(cPerg+"01",.t.)
	/* Removido 11/05/23 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
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
	*/
EndIf

If ! DbSeek(cPerg+"02",.t.)
	/* Removido 11/05/23 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
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
	*/
EndIf

If ! DbSeek(cPerg+"03",.t.)
	/* Removido 11/05/23 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
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
	*/
EndIf

If ! DbSeek(cPerg+"04",.t.)
	/* Removido 11/05/23 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
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
	*/
EndIf

If ! DbSeek(cPerg+"05",.t.)
	/* Removido 11/05/23 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Local de "
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par05"
	SX1->X1_DEF01   := ""
	MsUnLock()
	*/
EndIf


If ! DbSeek(cPerg+"06",.t.)
	/* Removido 11/05/23 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Local ate "
	SX1->X1_VARIAVL := "mv_ch6"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par06"
	SX1->X1_DEF01   := ""
	MsUnLock()
	*/
EndIf

If ! DbSeek(cPerg+"07",.t.)
	/* Removido 11/05/23 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "07"
	SX1->X1_PERGUNT := "documento"
	SX1->X1_VARIAVL := "mv_ch7"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 6
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par07"
	SX1->X1_DEF01   := ""
	MsUnLock()
	*/
EndIf

Return
