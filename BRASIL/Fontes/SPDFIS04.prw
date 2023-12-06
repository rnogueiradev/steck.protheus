#include "rwmake.ch"
#include "Topconn.ch"
#include "protheus.ch"

User Function SPDFIS04()
	Local cFil := ParamIXB[1] // Filial
	Local cTipoMov := ParamIXB[2] // Tipo Movimento (entrada ou saída)
	Local cSerie := ParamIXB[3] // Série
	Local cNumDoc := ParamIXB[4] // Nota Fiscal
	Local cClieFor := ParamIXB[5] // Cliente/Fornecedor
	Local cLoja := ParamIXB[6] // Loja
	Local cItem := ParamIXB[7] // Item
	Local cCodProd := ParamIXB[8] // Código do Produto
	Local cDescri := ""
	Local cAliasQry := ""
	Local lC170    := SuperGetMv("ST_LC170",,.F.) //utiliza descrição produto registro C170 // Emerson Holanda 14/09/23

	If lC170
		If cTipoMov == "E"
			// Busca informação do documento SD1
			cAliasQry := GetNextAlias()
			BeginSql alias cAliasQry
		SELECT SD1.D1_XDESC2
          FROM %table:SD1% SD1
          WHERE SD1.D1_FILIAL = %exp:cFil%
            AND SD1.D1_DOC = %exp:cNumDoc%
            AND SD1.D1_SERIE = %exp:cSerie%
            AND SD1.D1_FORNECE = %exp:cClieFor%
            AND SD1.D1_LOJA = %exp:cLoja%
            AND SD1.D1_COD = %exp:cCodProd%
            AND SD1.D1_ITEM = %exp:cItem%
            AND SD1.%notDel%
			%noparser%
			EndSql

			If !(cAliasQry)->(Eof())
				cDescri := (cAliasQry)->D1_XDESC2
			EndIf
			(cAliasQry)->(dbCloseArea())

		EndIf
	EndIf
	If Empty(cDescri)
		cDescri :=  Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_DESC")//Emerson Holanda 14/09/23
	EndIf

Return cDescri
