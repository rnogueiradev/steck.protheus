#Include 'Protheus.ch'

User Function IMPSB2SBF()

// Função criada apenas para atualizar as datas de inventario.
// Chamado 006450

Local aArea := GetArea()

dbSelectArea("SB2")
dbSetOrder(1)
dbGoTop()

while !eof()

if SB2->B2_LOCAL = "03"

dbSelectArea("SBF")
dbSetOrder(2)
dbGoTop()

if dbSeek(SB2->B2_FILIAL+SB2->B2_COD+SB2->B2_LOCAL)

RecLock("SBF",.F.)
SBF->BF_DINVENT := SB2->B2_DINVENT
MsUnlock()

Endif

ENDIF

dbSelectArea("SB2")
dbSkip()
Enddo

MSGALERT("Fim")

RestArea(aArea)

Return

