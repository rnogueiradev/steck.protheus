#Include 'Protheus.ch'

User Function IMPSG1SGG()

// Função criada apenas para importar as estruturas para pre estruturas que nao existem.
// Chamado 004557

Local aArea := GetArea()

dbSelectArea("SG1")
dbSetOrder(1)
dbGoTop()

while !eof()

dbSelectArea("SGG")
dbSetOrder(1)
dbGoTop()

if !dbSeek(SG1->G1_FILIAL+SG1->G1_COD+SG1->G1_COMP+SG1->G1_TRT)

RecLock("SGG",.T.)
SGG->GG_FILIAL	:= SG1->G1_FILIAL
SGG->GG_COD     := SG1->G1_COD
SGG->GG_COMP    := SG1->G1_COMP
SGG->GG_TRT     := SG1->G1_TRT
SGG->GG_QUANT   := SG1->G1_QUANT
SGG->GG_PERDA   := SG1->G1_PERDA
SGG->GG_INI     := SG1->G1_INI
SGG->GG_FIM     := SG1->G1_FIM
SGG->GG_OBSERV  := SG1->G1_OBSERV
SGG->GG_FIXVAR  := SG1->G1_FIXVAR
SGG->GG_GROPC   := SG1->G1_GROPC
SGG->GG_OPC     := SG1->G1_OPC
SGG->GG_NIV     := SG1->G1_NIV
SGG->GG_NIVINV  := SG1->G1_NIVINV
SGG->GG_POTENCI := SG1->G1_POTENCI
SGG->GG_OK      := SG1->G1_OK
SGG->GG_REVINI  := SG1->G1_REVINI
SGG->GG_REVFIM  := SG1->G1_REVFIM
SGG->GG_TIPVEC  := SG1->G1_TIPVEC
SGG->GG_VECTOR  := SG1->G1_VECTOR
SGG->GG_ZREVIS  := SG1->G1_ZREVIS
SGG->GG_ZDTREVI := SG1->G1_ZDTREVI

MsUnlock()

Endif

dbSelectArea("SG1")
dbSkip()
Enddo

MSGALERT("Fim")

RestArea(aArea)

Return

