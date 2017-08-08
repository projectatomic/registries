import unittest
from registries import loadYAML, loadTOML, load_config


class TestYAMLLoadFunctions(unittest.TestCase):

    def test_load_yaml(self):
        answer = {'block_registries': ['registry4'], 'insecure_registries': ['registry3'], 'registries': ['registry1', 'registry2']}
        foo = load_config("registries.yaml")
        self.assertEqual(foo, answer)

    def test_load_yaml_no_secure(self):
        answer = {'block_registries': ['registry4'], 'insecure_registries': ['registry3'], 'registries': []}
        foo = load_config("registries.yaml.no_secure")
        self.assertEqual(foo, answer)

    def test_load_yaml_no_insecure(self):
        answer = {'block_registries': ['registry4'], 'insecure_registries': [], 'registries': ['registry1', 'registry2']}
        foo = load_config("registries.yaml.no_insecure")
        self.assertEqual(foo, answer)

    def test_load_yaml_no_block(self):
        answer = {'block_registries': [], 'insecure_registries': ['registry3'], 'registries': ['registry1', 'registry2']}
        foo = load_config("registries.yaml.no_block")
        self.assertEqual(foo, answer)

    def blank(self):
        foo = load_config("blank")
        self.assertEqual(foo, "")

if __name__ == '__main__':
    unittest.main()