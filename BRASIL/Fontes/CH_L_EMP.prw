#Include "Totvs.ch"

/*/{Protheus.doc} CH_L_EMP
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
CAMPOS PARA RETORNO DA QUERY
SIGLA
NOME
CNPJ
FANTASIA
INSCRICAOESTADUAL
ENDERECO
BAIRRO
NUMERO
COMPLEMENTO
CEP
CIDADE
ESTADO
FONE
*/

User Function CH_L_EMP(nParamDias)

Local aSM0  := {}
Local cAlias:= "SM0"
/*
Local cAlias:= GetNextAlias()

BeginSql Alias cAlias

SELECT  SM0.*
FROM    SYS_COMPANY SM0
WHERE   SM0.D_E_L_E_T_  = ''

EndSql
*/

(cAlias)->(dbGoTop())
While !(cAlias)->(Eof())

 //   if (Alltrim(SM0->M0_CODIGO)+Alltrim(SM0->M0_CODFIL) == "010202")

        aAdd(aSM0,{ Alltrim(SM0->M0_CODIGO)+Alltrim(SM0->M0_CODFIL),;
                    SM0->M0_NOMECOM,;
                    SM0->M0_CGC,;
                    Alltrim(SM0->M0_NOME)+' '+Alltrim(SM0->M0_FILIAL),;
                    SM0->M0_INSC,;
                    SM0->M0_ENDCOB,;
                    SM0->M0_BAIRCOB,;
                    SM0->M0_COMPCOB,;
                    SM0->M0_CEPCOB,;
                    SM0->M0_CIDCOB,;
                    SM0->M0_ESTCOB,;
                    SM0->M0_TEL})

  //  endif
    
    //passa o registro
    (cAlias)->(dbSkip())

EndDo

//(cAlias)->(dbCloseArea())

Return aSM0
