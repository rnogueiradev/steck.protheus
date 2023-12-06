from tir import Webapp
import unittest


class CTBA500(unittest.TestCase):

    @classmethod
    def setUpClass(inst):

        inst.oHelper = Webapp()
        inst.oHelper.Setup("SIGACTB", "01/01/2019", "T1", "D MG 01", "34")
        inst.oHelper.Program("CTBA500")


#####################################################
##       importar estrutura, visão gerencial
#####################################################
    def test_CTBA500_CT001(self):
        
        #Tela de Contabilizacao de Arquivos TXT
        self.oHelper.SetButton("Param.")
        #Tela de parâmetros
        self.oHelper.SetValue("Mostra Lançamentos ?", "Sim")
        self.oHelper.SetValue("Aglutina Lancamento ?","Nao")
        self.oHelper.SetValue("Arquivo Importado ?           ",       "\\baseline\\ctba5001.txt")
        self.oHelper.SetValue("Nº do Lote Inicial ?          ",       "0612")
        self.oHelper.SetValue("Quebra Linha em Doc ?         ",       "Nao")
        self.oHelper.SetValue("Tam linha (bytes) ?           ",       "512")
        self.oHelper.SetValue("Considera Filial ?"            ,       "Nao")
        self.oHelper.SetValue("Processa Arquivo ?"            ,       "Rotina")
        self.oHelper.SetButton("OK")
        #Fim tela de parâmetros

        #self.oHelper.WaitShow("Contabilizacao de Arquivos TXT")
        self.oHelper.SetButton("Ok")

        #tela de confirmaação
        self.oHelper.WaitShow("TOTVS")
        self.oHelper.SetButton("Sim") 

        #Tela de contabilização
        self.oHelper.SetButton("Salvar") 


        self.oHelper.AssertTrue()

    




        #####################################################
##       importar estrutura, visão gerencial
#####################################################
                         
    def test_CTBA500_CT002(self):
        self.oHelper.Program("CTBA500")
       
        
        #Tela de Contabilizacao de Arquivos TXT
        self.oHelper.SetButton("Param.")
        #Tela de parâmetros
        self.oHelper.SetValue("Mostra Lançamentos ?", "Sim")
        self.oHelper.SetValue("Aglutina Lancamento ?","Sim")
        self.oHelper.SetValue("Arquivo Importado ?           ",       "\\baseline\\ctba5002.txt")
        self.oHelper.SetValue("Nº do Lote Inicial ?          ",       "0613")
        self.oHelper.SetValue("Quebra Linha em Doc ?         ",       "Nao")
        self.oHelper.SetValue("Tam linha (bytes) ?           ",       "76")
        self.oHelper.SetValue("Considera Filial ?"            ,       "Nao")
        self.oHelper.SetValue("Processa Arquivo ?"            ,       "Rotina")
        self.oHelper.SetButton("OK")
        #Fim tela de parâmetros

        #self.oHelper.WaitShow("Contabilizacao de Arquivos TXT")
        self.oHelper.SetButton("Ok")

        #tela de confirmaação
        self.oHelper.WaitShow("TOTVS")
        self.oHelper.SetButton("Sim") 

        #Tela de contabilização
        self.oHelper.SetButton("Salvar") 


        self.oHelper.AssertTrue()


    @classmethod
    def tearDownClass(inst):
        inst.oHelper.TearDown()


if __name__ == '__main__':
    unittest.main()