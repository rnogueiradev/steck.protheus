#INCLUDE  "rwmake.ch"
#INCLUDE  "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPICO06  บ Autor ณ Cristiano Pereira   บ Data ณ 12/07/04    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณEmitir relatorio para conferencia do PIS/COFINS  por data deบฑฑ
ฑฑบ          ณemissao                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracao ณ                                                            บฑฑ
ฑฑบCristiano ณ 29/03/10 - Nao considerar pre-nota na emissao desse relato-บฑฑ
ฑฑบ          ณ            rio                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function STPICO06()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cString
Private cPerg  := "DUFI02"+space(04) /* aumentando para 10 posicoes - Kelle */
/* Removido - 18/05/2023 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
DbSelectArea("SX1")

If ! DbSeek(cPerg+"01",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Da Data "
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 08
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_DEF01   := ""
EndIf

If ! DbSeek(cPerg+"02",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Ate Data "
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 08
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par02"
	SX1->X1_DEF01   := ""
EndIf


If ! DbSeek(cPerg+"03",.t.)
	Reclock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Notas de   ?"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 1
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 1
	SX1->X1_GSC     := "C"
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_DEF01   := "Entrada  "
	SX1->X1_DEF02   := "Saida    "
	MsUnlock()
Endif


If ! DbSeek(cPerg+"04",.t.)
	Reclock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Tes de   ?"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 3
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 1
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par04"
	SX1->X1_F3      := "SF4"
	MsUnlock()
Endif


If ! DbSeek(cPerg+"05",.t.)
	Reclock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Tes ate  ?"
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 3
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 1
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par05"
	SX1->X1_F3      := "SF4"
	MsUnlock()
Endif


If ! DbSeek(cPerg+"06",.t.)
	Reclock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Cfop de  ?"
	SX1->X1_VARIAVL := "mv_ch6"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 5
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 1
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par06"
	MsUnlock()
Endif


If ! DbSeek(cPerg+"07",.t.)
	Reclock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "07"
	SX1->X1_PERGUNT := "Cfop ate  ?"
	SX1->X1_VARIAVL := "mv_ch7"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 5
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 1
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par07"
	MsUnlock()
Endif

If ! DbSeek(cPerg+"08",.t.)
	Reclock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "08"
	SX1->X1_PERGUNT := "Tipo Relatorio   ?"
	SX1->X1_VARIAVL := "mv_ch8"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 1
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 1
	SX1->X1_GSC     := "C"
	SX1->X1_VAR01   := "mv_par08"
	SX1->X1_DEF01   := "Analitico"
	SX1->X1_DEF02   := "Sintetico"
	MsUnlock()
Endif
                       

If ! DbSeek(cPerg+"09",.t.)
	Reclock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "09"
	SX1->X1_PERGUNT := "Aliq Pis de ?"
	SX1->X1_VARIAVL := "mv_ch9"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 5
	SX1->X1_DECIMAL := 2
	SX1->X1_PRESEL  := 1
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par09"
	MsUnlock()
Endif
                                

If ! DbSeek(cPerg+"10",.t.)
	Reclock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "10"
	SX1->X1_PERGUNT := "Aliq Pis ate?"
	SX1->X1_VARIAVL := "mv_cha"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 5
	SX1->X1_DECIMAL := 2
	SX1->X1_PRESEL  := 1
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par10"
	MsUnlock()
Endif                           


If ! DbSeek(cPerg+"11",.t.)
	Reclock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "11"
	SX1->X1_PERGUNT := "Aliq Cofins de?"
	SX1->X1_VARIAVL := "mv_chb"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 5
	SX1->X1_DECIMAL := 2
	SX1->X1_PRESEL  := 1
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par11"
	MsUnlock()
Endif                           


If ! DbSeek(cPerg+"12",.t.)
	Reclock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "12"
	SX1->X1_PERGUNT := "Aliq Cofins ate?"
	SX1->X1_VARIAVL := "mv_chc"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 5
	SX1->X1_DECIMAL := 2
	SX1->X1_PRESEL  := 1
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par12"
	MsUnlock()
Endif                           
*/

// Solicita paramentros para impressao do relatorio
If !Pergunte(cPerg,.T.)
	Return
Else
	Processa( {|| STPICO06A()} ,"Selecionando Producao..................." )
Endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออหออออออออออออออออออออออออออออหออออออออออออออออออออปฑฑ
ฑฑบFuno    ณ STPICO06Aบ Autor ณ Cristiano Pereira  บ Data ณ  12/07/04   บฑฑ
ฑฑฬอออออออออออออออออออออสออออออออออออออออออออออออออออสออออออออออออออออออออนฑฑ
ฑฑบDescrio ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function  STPICO06A

Local nTamLin, cLin, cCpo

// Fecha arquivo temporario
If Select("TSF1") > 0
	DbSelectArea("TSF1")
	dbclosearea()
Endif

// Fecha arquivo temporario
If Select("TSD1") > 0
	DbSelectArea("TSD1")
	dbclosearea()
Endif



// NOTAS DE ENTRADA  Analitica
If MV_PAR03 ==1 .and. MV_PAR08 = 1
	
	// Selecionar notas fiscais de entrada
	cQrySF1 := " SELECT F1_FILIAL,F1_DTDIGIT,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_TIPO,F1_VALBRUT "
	cQrySF1 += " FROM "+RETSQLNAME("SF1")+" SF1"
	cQrySF1 += " WHERE F1_FILIAL = '"+ xFilial("SF1")+"' AND "
	cQrySF1 += " F1_DTDIGIT     >='"+Dtos(MV_PAR01)+ "'  AND "
	cQrySF1 += " F1_DTDIGIT     <='"+Dtos(MV_PAR02)+ "'  AND "
	cQrySF1 += " F1_STATUS      = 'A'                    AND "
	cQrySF1 +=  "SF1.D_E_L_E_T_ = ' '       "
	cQrySF1 += " ORDER BY F1_DTDIGIT,F1_DOC "
	TCQUERY cQrySF1 NEW ALIAS "TSF1"
	TCSETFIELD("TSF1","F1_DTDIGIT" ,"D",8,0)
Endif

If MV_PAR03 ==2 .and. MV_PAR08 = 1

	// Selecionar notas fiscais de saida analitica
	cQrySF1 := " SELECT F2_FILIAL,F2_EMISSAO,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_TIPO,F2_VALBRUT "
	cQrySF1 += " FROM "+RETSQLNAME("SF2")+" SF2 "
	cQrySF1 += " WHERE F2_FILIAL = '"+ xFilial("SF2")+"' AND "
	cQrySF1 += " F2_EMISSAO     >='"+Dtos(MV_PAR01)+ "'  AND "
	cQrySF1 += " F2_EMISSAO     <='"+Dtos(MV_PAR02)+ "'   "
	cQrySF1 += " ORDER BY F2_EMISSAO,F2_DOC"
	TCQUERY cQrySF1 NEW ALIAS "TSF1"
	TCSETFIELD("TSF1","F2_EMISSAO" ,"D",8,0)
	
Endif


// NOTAS DE ENTRADA  sintetica
If MV_PAR03 == 1 .and. MV_PAR08 = 2

	// Selecionar notas fiscais de entrada
	cQrySD1 := " SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_ALQIMP6,D1_ALQIMP5,D1_VALIMP5,D1_VALIMP6,D1_BASIMP5,D1_TES,D1_CF,D1_TOTAL,D1_VALIPI,D1_DESPESA,D1_VALICM "
	cQrySD1 += " FROM   "+RETSQLNAME('SD1')+ " SD1 "
	cQrySD1 += " WHERE D1_FILIAL = '"+xFilial("SD1")+"' AND "
	cQrySD1 += " D1_DTDIGIT     >='"+Dtos(MV_PAR01)+ "'  AND "
	cQrySD1 += " D1_DTDIGIT     <='"+Dtos(MV_PAR02)+ "'  AND "
	cQrySD1 += " D1_TES         >='"+MV_PAR04+ "'  AND "
	cQrySD1 += " D1_TES         <='"+MV_PAR05+ "'  AND "
	cQrySD1 += " D1_CF          >='"+MV_PAR06+ "'  AND "
	cQrySD1 += " D1_CF          <='"+MV_PAR07+ "'  AND "
	cQrySD1 += " D1_VALIMP5     > 0                AND "
	cQrySD1 += " CAST(D1_ALQIMP6 AS NUMERIC(5,2))  >="+STR(MV_PAR09)+"   AND "
	cQrySD1 += " CAST(D1_ALQIMP6 AS NUMERIC(5,2))  <="+STR(MV_PAR10)+"   AND "
	cQrySD1 += " CAST(D1_ALQIMP5 AS NUMERIC(5,2))  >="+STR(MV_PAR11)+"   AND "
	cQrySD1 += " CAST(D1_ALQIMP5 AS NUMERIC(5,2))  <="+STR(MV_PAR12)+"    AND "
    cQrySD1 += " D1_CF          <> Space(05)       AND "
	cQrySD1 += " SD1.D_E_L_E_T_ = ' '      "
	cQrySD1 += " ORDER BY D1_CF "
	TCQUERY cQrySD1 NEW ALIAS "TSD1"
	TCSETFIELD("TSD1","D1_DTDIGIT " ,"D",8,0)
	
Endif


// NOTAS DE SAIDAS  sintetica
If MV_PAR03 == 2 .and. MV_PAR08 = 2

	// Selecionar notas fiscais de entrada
	cQrySD1 := " SELECT D2_FILIAL,D2_ALQIMP6,D2_ALQIMP5,D2_VALIMP5,D2_VALIMP6,D2_BASIMP5,D2_TES,D2_CF,D2_TOTAL,D2_VALIPI,D2_ICMSRET "
	cQrySD1 += " FROM   "+RETSQLNAME('SD2')+ " SD2 "
	cQrySD1 += " WHERE D2_FILIAL = '"+ xFilial("SD2")+"' AND "
	cQrySD1 += " D2_EMISSAO     >='"+Dtos(MV_PAR01)+ "'  AND "
	cQrySD1 += " D2_EMISSAO     <='"+Dtos(MV_PAR02)+ "'  AND "
	cQrySD1 += " D2_TES         >='"+MV_PAR04+ "'  AND "
	cQrySD1 += " D2_TES         <='"+MV_PAR05+ "'  AND "
	cQrySD1 += " D2_CF          >='"+MV_PAR06+ "'  AND "
	cQrySD1 += " D2_CF          <='"+MV_PAR07+ "'  AND "
	cQrySD1 += " D2_VALIMP5     > 0                AND "
	cQrySD1 += " CAST(D2_ALQIMP6 AS NUMERIC(5,2))  >="+STR(MV_PAR09)+"   AND "
	cQrySD1 += " CAST(D2_ALQIMP6 AS NUMERIC(5,2))  <="+STR(MV_PAR10)+"   AND "
	cQrySD1 += " CAST(D2_ALQIMP5 AS NUMERIC(5,2))  >="+STR(MV_PAR11)+"   AND "
	cQrySD1 += " CAST(D2_ALQIMP5 AS NUMERIC(5,2))  <="+STR(MV_PAR12)+"    AND "
	cQrySD1 += " SD2.D_E_L_E_T_ = ' '      "
	cQrySD1 += " ORDER BY D2_CF "
	TCQUERY cQrySD1 NEW ALIAS "TSD1"
	
Endif





// Emite relatorio do arquivo temporario
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บ Autor ณ Cristiano Pereira  บ Data ณ  06/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ                                                            บฑฑ
ฑฑบ          ณ Especifico STECK                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cDesc1     := "Este programa tem como objetivo imprimir relatorio  "
Private cDesc2     := "para conferencia do PIS/COFINS                      "
Private cDesc3     := "                "
Private cPict      := ""
Private nLin       := 66

// Nota de entrada/saida
If MV_PAR03 = 1
	Private titulo     := "NOTA DE ENTRADA"
	Private Cabec1     := "  DATA       NOTA      CLIENTE/FORNECEDOR                                  CFOP   VALOR BRUTO         BASE         ALQ.PIS    VALOR PIS     ALQ.COFINS   VALOR COFINS"
	Private Cabec2     :=  " "
	Private tamanho    := "G"
Else
	Private titulo     := "NOTA DE ENTRADA"
	Private Cabec1     := "  DATA       NOTA      CLIENTE/FORNECEDOR                                  CFOP   VALOR BRUTO         BASE         ALQ.PIS    VALOR PIS     ALQ.COFINS   VALOR COFINS"
	Private Cabec2     :=""
	Private tamanho    := "G"
Endif

Private imprime    := .T.
Private CbTxt      := ""
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private limite     := 80
Private nomeprog   := "DURFIS02"
Private nTipo      := 15
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "DUFI02"+space(04) /* aumentando para 10 posicoes - Kelle */
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "DURFIS02"
Private cString    := "SF1"


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If MV_PAR03= 1
	titulo       := "PIS/COFINS - NOTAS FISCAIS DE ENTRADA:  " + Dtoc(MV_PAR01)+" A " + Dtoc(MV_PAR02)
Else
	titulo       := "PIS/COFINS - NOTAS FISCAIS DE SAIDA  :  " + Dtoc(MV_PAR01)+" A " + Dtoc(MV_PAR02)
Endif

Pergunte(cPerg,.F.)


SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| STPICO06B(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return


// 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPICO06B บ Autor ณ Cristiano Pereira  บ Data ณ  06/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณEmite relatorio do arquivo temporario                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico STECK                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function STPICO06B(Cabec1,Cabec2,Titulo,nLin)

_tTotEnt := 0       // Total Pedidos


// Nota de entrada
_nTotalPIs := 0
_nTotalCof := 0
_nTotalBru := 0
_nTotalBas := 0

// Nota fiscal de entrada analitica
If MV_PAR03 == 1  .and. MV_PAR08 == 1
   
   DbSelectArea("TSF1")
   _nRec := 0
   DbEval({|| _nRec++  })
   SetRegua(_nRec)
   DbSelectArea("TSF1")
   Dbgotop()
	
	While !Eof()
		
		IncRegua()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		_nDiaPIs := 0
		_nDiaCof := 0
		_nDiaBru := 0
		_nDiaBas := 0
		
		_dEmissao:= TSF1->F1_DTDIGIT
		
		Do While _dEmissao == TSF1->F1_DTDIGIT  .and. !eof()
			
			// Cabecalho
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			IncRegua()
			
			// Localiza fornecedor
			DbSelectArea("SD1")
			_nAlqPis  := 0
			_nAlqCof  := 0
			_nValIMP5 := 0
			_nValIMP6 := 0
			_nBasIMP5 := 0
			_nCF      := " "
			_nVal1124 := 0
			
			// Fecha arquivo temporario
			If Select("TSD1") > 0
				DbSelectArea("TSD1")
				dbclosearea()
			Endif
			
			// Selecionar notas fiscais de entrada
			cQrySD1 := " SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_ALQIMP6,D1_ALQIMP5,D1_VALIMP5,D1_VALIMP6,D1_BASIMP5,D1_TES,D1_CF,D1_TOTAL "
			cQrySD1 += "  FROM   "+RETSQLNAME('SD1')
			cQrySD1 += " WHERE D1_FILIAL = '"+xFilial("SD1")+"' AND "
			cQrySD1 += " D1_DOC     =  '"+TSF1->F1_DOC+"'       AND "
			cQrySD1 += " D1_SERIE   =  '"+TSF1->F1_SERIE+"'     AND "
			cQrySD1 += " D1_FORNECE =  '"+TSF1->F1_FORNECE+"'   AND "
			cQrySD1 += " D1_LOJA    =  '"+TSF1->F1_LOJA+"'      AND "
	        cQrySD1 += " CAST(D1_ALQIMP6 AS NUMERIC(5,2))  >="+STR(MV_PAR09)+"   AND "
	        cQrySD1 += " CAST(D1_ALQIMP6 AS NUMERIC(5,2))  <="+STR(MV_PAR10)+"   AND "
	        cQrySD1 += " CAST(D1_ALQIMP5 AS NUMERIC(5,2))  >="+STR(MV_PAR11)+"   AND "
	        cQrySD1 += " CAST(D1_ALQIMP5 AS NUMERIC(5,2))  <="+STR(MV_PAR12)+"    AND "
			cQrySD1 += " D_E_L_E_T_ = ' ' "
			cQrySD1 += " ORDER BY D1_DTDIGIT,D1_DOC,D1_ALQIMP5 "
			TCQUERY cQrySD1 NEW ALIAS "TSD1"
			TCSETFIELD("TSD1","D1_DTDIGIT " ,"D",8,0)
			
			_cAvanca := "S"
			
			While TSD1->D1_DOC+TSD1->D1_SERIE+TSD1->D1_FORNECE+TSD1->D1_LOJA  == TSF1->F1_DOC+TSF1->F1_SERIE+TSF1->F1_FORNECE+TSF1->F1_LOJA  .and. !Eof()
				
				_cAliq    := TSD1->D1_ALQIMP5
				_nAlqPis  := 0
				_nAlqCof  := 0
				_nValIMP5 := 0
				_nValIMP6 := 0
				_nBasIMP5 := 0
				_nCF      := Substr(TSD1->D1_CF,1,4)
				_nVal1124 := 0
				_cTes     := Space(03)
				
				While  TSD1->D1_DOC+TSD1->D1_SERIE+TSD1->D1_FORNECE+TSD1->D1_LOJA  == TSF1->F1_DOC+TSF1->F1_SERIE+TSF1->F1_FORNECE+TSF1->F1_LOJA .and. _cAliq == TSD1->D1_ALQIMP5 .and. _nCF == Substr(TSD1->D1_CF,1,4)  .and.  !Eof()
					
					
					// Filtro por TES
					If TSD1->D1_TES < MV_PAR04 .or. TSD1->D1_TES > MV_PAR05
						DbSkip()
						Loop
					Endif
					
					// Filtro por CFOP
					If TSD1->D1_CF < MV_PAR06 .or. TSD1->D1_CF > MV_PAR07
						DbSkip()
						Loop
					Endif
					
					if nLin > 60
				       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				       nLin := 8
			        Endif
	
					_nAlqPis  := TSD1->D1_ALQIMP6
					_nAlqCof  := TSD1->D1_ALQIMP5
					_nValIMP5 += TSD1->D1_VALIMP5
					_nValIMP6 += TSD1->D1_VALIMP6                     
					_nBasIMP5 += TSD1->D1_BASIMP5
					_cTes := TSD1->D1_TES    
					// Se considera PIS/COFINS
					DbSelectArea("SF4")
					If DbSeek(xfilial("SF4") +TSD1->D1_TES,.T.) .AND. SF4->F4_PISCOF == "3"
						_nCF := Substr(TSD1->D1_CF,1,4)
					Endif
					
					If _nCF $ "1124/1125"
						_nVal1124 += TSD1->D1_TOTAL
					EndIf
					
					If Substr(_nCF,1,1) == "3"
						_nVal1124 += TSD1->D1_TOTAL
					EndIf
					
					If Substr(_nCF,1,1) == "3" .and. TSD1->D1_TES == '444'
						_nVal1124 := 0
					EndIf
					
					DbSelectArea("TSD1")
					DbSkip()
					
				Enddo
				
				If _nBasIMP5 > 0
					
					// Localiza FORNECEDOR
					_cNOME := Space(40)
					If !TSF1->F1_TIPO $"B/D"
						DbSelectArea("SA2")
						DbSeek(xfilial("SA2")+TSF1->F1_FORNECE+TSF1->F1_LOJA,.T.)
						_cNOME := SA2->A2_NOME
					Else
						DbSelectArea("SA1")
						DbSeek(xfilial("SA1")+TSF1->F1_FORNECE+TSF1->F1_LOJA,.T.)
						_cNOME := SA1->A1_NOME
					Endif
					
					@ nLin,001 PSAY TSF1->F1_DTDIGIT
					@ nLin,012 PSAY TSF1->F1_DOC
					@ nLin,024 PSAY ALLTRIM(TSF1->F1_FORNECE)+"-"+TSF1->F1_LOJA
					@ nLin,034 PSAY _cNOME
					@ nLin,076 PSAY _nCF
					@ nLin,082 PSAY IIF(_nVal1124 > 0,_nVal1124,TSF1->F1_VALBRUT) PICTURE "@E 999,999,999.99"
					@ nLin,099 PSAY _nBasIMP5            PICTURE "@E 999,999,999.99"
					@ nLin,117 PSAY _nAlqPis             PICTURE "@E 999.99"
					@ nLin,126 PSAY _nValIMP6            PICTURE "@E 9,999,999.99"
					@ nLin,143 PSAY _nAlqCof             PICTURE "@E 999.99"
					@ nLin,154 PSAY _nValIMP5            PICTURE "@E 99,999,999.99"
					
					_nDiaPIs := _nDiaPis + _nValIMP6
					_nDiaCof := _nDiaCof + _nValIMP5
				    _nDiaBas := _nDiaBas + _nBasIMP5
				
					If _nCF $ "1124 /1125 "
					   _nDiaBru := _nDiaBru + _nVal1124
					ElseIf Substr(_nCF,1,1) == "3"	.and. _cTes <> '444'
					   _nDiaBru := _nDiaBru + _nVal1124
					ElseIf Substr(_nCF,1,1) == "3"	.and. _cTes == '444'
					   _nDiaBru := _nDiaBru + TSF1->F1_VALBRUT
					Else
					   _nDiaBru := _nDiaBru + TSF1->F1_VALBRUT
					Endif
					
					_nTotalPIs := _nTotalPis + _nValIMP6
					_nTotalCof := _nTotalCof + _nValIMP5
					
					If _nCF $ "1124 /1125 "
						_nTotalBru := _nTotalBru + _nVal1124
					ElseIf Substr(_nCF,1,1) == "3"	.and. _cTes <> '444'
						_nTotalBru := _nTotalBru + _nVal1124
					ElseIf Substr(_nCF,1,1) == "3"	.and. _cTes == '444'
						_nTotalBru := _nTotalBru + TSF1->F1_VALBRUT
					Else
					    _nTotalBru := _nTotalBru + TSF1->F1_VALBRUT
					Endif
					    
					_nTotalBas := _nTotalBas + _nBasIMP5
					
					nLin := nLin + 1
					
				Endif
				
			Enddo
			
			DbSelectArea("TSF1")
			dbSkip()
			
		Enddo
		
		nLin := nLin + 1
		
		@ nLin,001 PSAY "Total  Dia: " +Dtoc(_dEmissao)
		@ nLin,082 PSAY _nDiaBru  PICTURE "@E 999,999,999.99"
		@ nLin,099 PSAY _nDiaBas  PICTURE "@E 999,999,999.99"
		@ nLin,126 PSAY _nDiaPis  PICTURE "@E 99,999,999.99"
		@ nLin,154 PSAY _nDiaCof  PICTURE "@E 99,999,999.99"
		nLin := nLin + 2
		
	Enddo
	
	@ nLin,001 PSAY "Total Geral "
	@ nLin,082 PSAY _nTotalBru  PICTURE "@E 999,999,999.99"
	@ nLin,099 PSAY _nTotalBas  PICTURE "@E 999,999,999.99"
	@ nLin,126 PSAY _nTotalPis  PICTURE "@E 99,999,999.99"
	@ nLin,154 PSAY _nTotalCof  PICTURE "@E 99,999,999.99"

    DbSelectArea("TSF1")
    dbclosearea()
	
Endif


//------------------------------------------------------------------------------------------------------------------------------------------------------------
// Nota de saida analitica
If MV_PAR03 == 2 .and. MV_PAR08 == 1

   DbSelectArea("TSF1")
   _nRec := 0
   DbEval({|| _nRec++  })
   SetRegua(_nRec)
   DbSelectArea("TSF1")
   Dbgotop()
   While !Eof()
		
		IncRegua()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		_nDiaPIs := 0
		_nDiaCof := 0
		_nDiaBru := 0
		_nDiaBas := 0
		
		_dEmissao:= TSF1->F2_EMISSAO
		
		Do While _dEmissao == TSF1->F2_EMISSAO  .and. !eof()
			
			// Cabecalho
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			IncRegua()
			
			// Localiza fornecedor
			DbSelectArea("SD2")
			DbSetOrder(03)
			_nAlqPis  := 0
			_nAlqCof  := 0
			_nValIMP5 := 0
			_nValIMP6 := 0
			_nBasIMP5 := 0
			_nCF      := " "
			
			If DbSeek(xfilial("SD2")+TSF1->F2_DOC+TSF1->F2_SERIE+TSF1->F2_CLIENTE+TSF1->F2_LOJA,.T.)
				
				While SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == xFilial("SD2")+TSF1->F2_DOC+TSF1->F2_SERIE+TSF1->F2_CLIENTE+TSF1->F2_LOJA
					
					// Filtro por tes
					If SD2->D2_TES < MV_PAR04 .or. SD2->D2_TES > MV_PAR05
						DbSkip()
						Loop
					Endif
					
					// Filtro por CFOP
					If SD2->D2_CF < MV_PAR06 .or. SD2->D2_CF > MV_PAR07
						DbSkip()
						Loop
					Endif
					
					If SD2->D2_ALQIMP6 < MV_PAR09 .Or. SD2->D2_ALQIMP6 > MV_PAR10
				     	DbSkip()
						Loop
					Endif 
					
					If SD2->D2_ALQIMP5 < MV_PAR11 .Or. SD2->D2_ALQIMP5 > MV_PAR12
				     	DbSkip()
						Loop
					Endif
					
					_nAlqPis  := SD2->D2_ALQIMP6
					_nAlqCof  := SD2->D2_ALQIMP5
					_nValIMP5 += SD2->D2_VALIMP5
					_nValIMP6 += SD2->D2_VALIMP6
					_nBasIMP5 += SD2->D2_BASIMP5
					
					DbSelectArea("SF4")
					If DbSeek(xfilial("SF4") +SD2->D2_TES,.T.) .AND. SF4->F4_PISCOF == "3"
						_nCF     := Substr(SD2->D2_CF,1,4)
					Endif
					DbSelectArea("SD2")
					DbsKIP()
				Enddo
			Endif
			
			If !_nBasIMP5 > 0
				DbSelectArea("TSF1")
				dbSkip()
				Loop
			EndIF
			
			// Localiza cliente
			_cNOME := Space(40)
			If !TSF1->F2_TIPO $ 'D/B'
				DbSelectArea("SA1")
				DbSeek(xfilial("SA1")+TSF1->F2_CLIENTE+TSF1->F2_LOJA,.T.)
				_cNOME := SA1->A1_NOME
			Else
				DbSelectArea("SA2")
				DbSeek(xfilial("SA2")+TSF1->F2_CLIENTE+TSF1->F2_LOJA,.T.)
				_cNOME := SA2->A2_NOME
			Endif
			
			@ nLin,001 PSAY TSF1->F2_EMISSAO
			@ nLin,012 PSAY TSF1->F2_DOC
			@ nLin,024 PSAY ALLTRIM(TSF1->F2_CLIENTE)+"-"+TSF1->F2_LOJA
			@ nLin,034 PSAY _cNOME
			@ nLin,076 PSAY _nCF
			@ nLin,082 PSAY TSF1->F2_VALBRUT     PICTURE "@E 999,999,999.99"
			@ nLin,099 PSAY _nBasIMP5            PICTURE "@E 999,999,999.99"
			@ nLin,117 PSAY _nAlqPis             PICTURE "@E 999.99"
			@ nLin,126 PSAY _nValIMP6            PICTURE "@E 9,999,999.99"
			@ nLin,143 PSAY _nAlqCof             PICTURE "@E 999.99"
			@ nLin,154 PSAY _nValIMP5            PICTURE "@E 99,999,999.99"
			
			_nDiaPIs := _nDiaPis + _nValIMP6
			_nDiaCof := _nDiaCof + _nValIMP5
			_nDiaBru := _nDiaBru + TSF1->F2_VALBRUT
			_nDiaBas := _nDiaBas + _nBasIMP5
			
			_nTotalPIs := _nTotalPis + _nValIMP6
			_nTotalCof := _nTotalCof + _nValIMP5
			_nTotalBru := _nTotalBru + TSF1->F2_VALBRUT
			_nTotalBas := _nTotalBas + _nBasIMP5
			
			
			DbSelectArea("TSF1")
			dbSkip()
			
			
			nLin := nLin + 1
			
		Enddo
		
		@ nLin,001 PSAY "Total  Dia :" +Dtoc(_dEmissao)
		@ nLin,082 PSAY _nDiaBru  PICTURE "@E 999,999,999.99"
		@ nLin,099 PSAY _nDiaBas  PICTURE "@E 999,999,999.99"
		@ nLin,126 PSAY _nDiaPis  PICTURE "@E 9,999,999.99"
		@ nLin,154 PSAY _nDiaCof  PICTURE "@E 99,999,999.99"
		nLin := nLin + 2
		
	Enddo
	
	@ nLin,001 PSAY "Total Geral "
	@ nLin,082 PSAY _nTotalBru  PICTURE "@E 999,999,999.99"
	@ nLin,099 PSAY _nTotalBas    PICTURE "@E 999,999,999.99"
	@ nLin,126 PSAY _nTotalPis  PICTURE "@E 9,999,999.99"
	@ nLin,154 PSAY _nTotalCof  PICTURE "@E 99,999,999.99"
	
	DbSelectArea("TSF1")
    dbclosearea()

	
Endif


//------------------------------------------------------------------------------------------------------------------

// Nota fiscal de entrada SINTETICA
If MV_PAR03 == 1  .and. MV_PAR08 == 2
	
    DbSelectArea("TSD1")
   _nRec := 0
   DbEval({|| _nRec++  })
   SetRegua(_nRec)
   DbSelectArea("TSD1")
   Dbgotop()

	While !Eof()
		
		IncRegua()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		_nDiaPIs := 0
		_nDiaCof := 0
		_nDiaBru := 0
		_nDiaBas := 0
		
		
		_nAlqPis  := 0
		_nAlqCof  := 0
		_nValIMP5 := 0
		_nValIMP6 := 0
		_nBasIMP5 := 0
		_nVal1124 := 0
		_nDespesa := 0
		_nVALICM  := 0
		
		_cCF:= TSD1->D1_CF
		
		Do While  _cCF == TSD1->D1_CF  .and. !eof()
			
			// Cabecalho
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			IncRegua()
			
			
			_nAlqPis  := TSD1->D1_ALQIMP6
			_nAlqCof  := TSD1->D1_ALQIMP5
			_nValIMP5 += TSD1->D1_VALIMP5
			_nValIMP6 += TSD1->D1_VALIMP6
			_nBasIMP5 += TSD1->D1_BASIMP5
			_nDespesa += TSD1->D1_DESPESA
			_nVALICM  += TSD1->D1_VALICM
			
			If _cCF $ "1124/1125"
			   _nVal1124 += TSD1->D1_TOTAL
			ElseIf Substr(_cCF,1,1) == "3" .AND. TSD1->D1_TES <> '444'
				_nVal1124 += TSD1->D1_TOTAL                           
			ElseIf Substr(_cCF,1,1) == "3" .AND. TSD1->D1_TES == '444'
				_nVal1124 += TSD1->D1_TOTAL + TSD1->D1_VALIMP5 + TSD1->D1_VALIMP6 + TSD1->D1_VALICM +  TSD1->D1_DESPESA                         
			Else
			    _nVal1124 += TSD1->D1_TOTAL +  TSD1->D1_VALIPI
	        Endif
	        		
			DbSelectArea("TSD1")
			DbsKIP()
			
		Enddo
		
		@ nLin,076 PSAY _cCF
		@ nLin,082 PSAY _nVal1124     PICTURE "@E 999,999,999.99"
		@ nLin,099 PSAY _nBasIMP5     PICTURE "@E 999,999,999.99"
		@ nLin,126 PSAY _nValIMP6     PICTURE "@E 99,999,999.99"
		@ nLin,154 PSAY _nValIMP5     PICTURE "@E 99,999,999.99"
		
		
		_nTotalPIs := _nTotalPis + _nValIMP6
		_nTotalCof := _nTotalCof + _nValIMP5
		_nTotalBru := _nTotalBru + _nVal1124
		_nTotalBas := _nTotalBas + _nBasIMP5
		
		nLin := nLin + 1
		
	Enddo
	
	@ nLin,001 PSAY "Total Geral "
	@ nLin,082 PSAY _nTotalBru  PICTURE "@E 999,999,999.99"
	@ nLin,099 PSAY _nTotalBas  PICTURE "@E 999,999,999.99"
	@ nLin,126 PSAY _nTotalPis  PICTURE "@E 99,999,999.99"
	@ nLin,154 PSAY _nTotalCof  PICTURE "@E 99,999,999.99"

	DbSelectArea("TSD1")
    dbclosearea()

	
Endif



// Nota SAIDA de entrada SINTETICA
If MV_PAR03 == 2  .and. MV_PAR08 == 2
	
    DbSelectArea("TSD1")
   _nRec := 0
   DbEval({|| _nRec++  })
   SetRegua(_nRec)
   DbSelectArea("TSD1")
   Dbgotop()

	While !Eof()
		
		IncRegua()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		_nDiaPIs := 0
		_nDiaCof := 0
		_nDiaBru := 0
		_nDiaBas := 0
		
		
		_nAlqPis  := 0
		_nAlqCof  := 0
		_nValIMP5 := 0
		_nValIMP6 := 0
		_nBasIMP5 := 0
		_nVal1124 := 0                          
			
		
		_cCF:= TSD1->D2_CF
		
		Do While  _cCF == TSD1->D2_CF  .and. !Eof()
			
			// Cabecalho
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			IncRegua()
			
			
			_nAlqPis  := TSD1->D2_ALQIMP6
			_nAlqCof  := TSD1->D2_ALQIMP5
			_nValIMP5 += TSD1->D2_VALIMP5
			_nValIMP6 += TSD1->D2_VALIMP6
			_nBasIMP5 += TSD1->D2_BASIMP5
			_nVal1124 += TSD1->D2_TOTAL + TSD1->D2_VALIPI + TSD1->D2_ICMSRET
			
			DbSelectArea("TSD1")
			DbsKIP()
			
		Enddo
		
		@ nLin,076 PSAY _cCF
		@ nLin,082 PSAY _nVal1124     PICTURE "@E 999,999,999.99"
		@ nLin,099 PSAY _nBasIMP5     PICTURE "@E 999,999,999.99"
		@ nLin,126 PSAY _nValIMP6     PICTURE "@E 99,999,999.99"
		@ nLin,154 PSAY _nValIMP5     PICTURE "@E 99,999,999.99"
		
		
		_nTotalPIs := _nTotalPis + _nValIMP6
		_nTotalCof := _nTotalCof + _nValIMP5
		_nTotalBru := _nTotalBru + _nVal1124
		_nTotalBas := _nTotalBas + _nBasIMP5
		
		nLin := nLin + 1
		
	Enddo
	
	@ nLin,001 PSAY "Total Geral "
	@ nLin,082 PSAY _nTotalBru  PICTURE "@E 999,999,999.99"
	@ nLin,099 PSAY _nTotalBas  PICTURE "@E 999,999,999.99"
	@ nLin,126 PSAY _nTotalPis  PICTURE "@E 99,999,999.99"
	@ nLin,154 PSAY _nTotalCof  PICTURE "@E 99,999,999.99"

	DbSelectArea("TSD1")
    dbclosearea()

	
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

//  DATA       NOTA      CLIENTE/FORNECEDOR                                  CFOP   VALOR BRUTO         BASE         ALQ.PIS    VALOR PIS     ALQ.COFINS   VALOR COFINS
//99/99/99   99999-999   999999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  9999  999,999,999.99   999,999,999.99    999.99   9,999,999.99     999.99     9,999,999.99
//1          12          24        34                                        76    82               99                117      126              143        154
