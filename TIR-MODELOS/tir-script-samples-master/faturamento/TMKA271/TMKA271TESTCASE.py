from tir import Webapp
import unittest

class TMKA271(unittest.TestCase):

	@classmethod
	def setUpClass(inst):
		inst.oHelper = Webapp()
		inst.oHelper.Setup('sigamdi','19/06/2023','11','01','13')
		#inst.oHelper.Program('MATA030')
		inst.oHelper.SetLateralMenu("Atualizações > Televendas > Call Steck")
	
	def test_TMKA271_001(self):

		self.oHelper.SetButton('Confirmar')
		self.oHelper.SetButton("Incluir")
		self.oHelper.SetButton('OK')

		Filial = "01"
		Orcamento = self.oHelper.GetValue("UA_NUM")
		cValor = "27,65"

		self.oHelper.SetValue("UA_CLIENTE","000224")
		self.oHelper.SetValue("UA_CODCONT","001508")
		self.oHelper.SetValue("UA_XCONDPG","501")
		self.oHelper.SetValue("UA_TPFRETE","C")
		self.oHelper.SetValue("UA_TRANSP","004064")
		self.oHelper.SetValue("UA_XTIPFAT","2")
		self.oHelper.SetValue("UA_XORDEM",".")
		
		self.oHelper.SetValue("UB_PRODUTO", "N3076", grid=True)
		self.oHelper.SetValue("UB_QUANT", "1,00", grid=True)
		self.oHelper.SetValue("% Desconto", "1,00", grid=True)

		self.oHelper.LoadGrid()

		self.oHelper.SetButton("Salvar")

		self.oHelper.SetValue("Motivo: ","TESTE DE DESCONTO UTILIZANDO O TIR")
		self.oHelper.SetButton("Ok")
		
		self.oHelper.SetButton("Fechar")
		self.oHelper.SetButton("Cancelar")
		self.oHelper.SetButton("Cancelar")
		self.oHelper.SetButton("Sim")

		self.oHelper.SearchBrowse(Filial+Orcamento, key=1, index=True)
		self.oHelper.SetButton('Visualizar')
		self.oHelper.CheckResult("UB_VRUNIT", cValor , grid=True, line=1)  
		self.oHelper.LoadGrid()
		self.oHelper.SetButton('Cancelar')

		self.oHelper.AssertTrue()

	@classmethod
	def tearDownClass(inst):
		inst.oHelper.TearDown()

if __name__ == '__main__':
	unittest.main()