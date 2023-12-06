#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103AFN  �Autor  �Vitor Merguizo      � Data �  08/22/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para c�lculo do codigo de ativo           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103AFN()

Local cBase      := U_STATF01() // Codigo personalizado
Local cItem      := "0001" // Numero item personalizado	
Local aRet       := {}
Local aProjeto   := Paramixb[1] //Dados do projeto
Local cAtuaATF   := Paramixb[2] //Atualiza ativo:  "S"-Sim / "N"-Nao
Local cDesItATF  := Paramixb[3] //Desmembra itens ativo:  "1"-Sim / "2"-Nao
Local lTipoDes   := Paramixb[4] //".F." Desmembra itens / ".T." Desmembra codigo base

aRet := {cBase, cItem}

Return(aRet)