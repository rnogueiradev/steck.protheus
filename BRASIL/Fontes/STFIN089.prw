#Include "Protheus.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STFIN089() �Autor  � Cristiano Pereira� Data �  28/01/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para atualiza��o da opera��o 89 - financeira          ��
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STFIN089()

    Local aSays		:= {}
    Local aButtons	:= {}

    Private cCadastro 	:= OemToAnsi("Opera��o 89 - financeira")
    Private aHeader 	:= {}
    Private aCols		:= {}
    Private cTabela		:= ""
    Private oGetDados1
    Private nOpcao 		:= 0


    AAdd(aSays,"Este programa tem como objetivo atualizar os t�tulos")
    AAdd(aSays,"gerados pelas notas fiscais opera��o 89.")



    AAdd(aButtons,{ 1,.T.,{|| FechaBatch(),nOpcao := 1 } } )
    AAdd(aButtons,{ 2,.T.,{|| FechaBatch() } } )

    FormBatch(cCadastro,aSays,aButtons)

    If nOpcao == 1
        // Funcao para buscar os produtos de acordo com o parametro selecionado
        MsgRun("Aguarde, realizando atualiza��o dos t�tulos de cobran�a","Aguarde",{ || _fGera89() })

    EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_fGera89 �Autor  �Cristiano Pereira   � Data �  11/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gerando update na base de dados                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _fGera89()

    Local _cQryE1   := ""


    _cQryE1 :=  " MERGE INTO "+RetSqlName("SE1")+" T1 USING (  "
    _cQryE1 +=  " SELECT SD2.D2_FILIAL  AS FIL,               "
    _cQryE1 +=  "        SD2.D2_CLIENTE AS CLI,               "
    _cQryE1 +=  "        SD2.D2_LOJA    AS LOJA,              "
    _cQryE1 +=  "         SD2.D2_DOC     AS NF,               "
    _cQryE1  +=  "        SD2.D2_SERIE   AS SERIE,             "
    _cQryE1 +=  "       SE1.R_E_C_N_O_ AS RECNOE1             "
    _cQryE1 +=  " FROM "+RetSQlName("SD2")+" SD2,"+RetSqlName("SE1")+" SE1 "
    _cQryE1 +=  " WHERE SD2.D_E_L_E_T_ <> '*'                         AND  "
    _cQryE1 +=  "        SD2.D2_TES IN ('886','887','888','889','890') AND "
    _cQryE1 +=  "        SD2.D2_FILIAL    = SE1.E1_FILIAL              AND "
    _cQryE1 +=  "       SD2.D2_DOC       = SE1.E1_NUM                 AND  "
    _cQryE1 +=  "       SD2.D2_CLIENTE   = SE1.E1_CLIENTE             AND  "
    _cQryE1 +=  "       SD2.D2_LOJA      = SE1.E1_LOJA                AND  "
    _cQryE1 +=  "       SE1.D_E_L_E_T_ <> '*'                         AND  "
    _cQryE1  +=   "      SD2.D2_SERIE     = SE1.E1_PREFIXO                 "

    _cQryE1 +=  " GROUP BY SD2.D2_FILIAL,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.D2_DOC,SD2.D2_SERIE,SE1.R_E_C_N_O_ "


    _cQryE1 +=  " )T2 ON (T1.R_E_C_N_O_ = TO_NUMBER(RTRIM(T2.RECNOE1)) ) "
    _cQryE1 +=  " WHEN MATCHED THEN "
    _cQryE1 +=  " UPDATE SET T1.E1_X89 = 'S' "

    If TcSqlExec( _cQryE1 )<0
	MsgStop("TCSQLError() " + TCSQLError())
Else
	MsgInfo("Atualiza��o Finalizada!")
EndIf

Return
