import unittest

from TMKA271TESTCASE import TMKA271

suite = unittest.TestSuite()

suite.addTest(TMKA271('test_TMKA271_001'))

runner = unittest.TextTestRunner(verbosity=2)
runner.run(suite)