from registries import loadYAML
import pytoml
import argparse
import sys


def _migrate(registries_conf_file):
    sys.stdout.write(pytoml.dumps(loadYAML.get_registries(registries_conf_file)))


def migrate():
    parser = argparse.ArgumentParser(description="Migrate registries.conf from YAML to TOML")
    parser.add_argument("-i", "--input", help="Specify an input file", default="/etc/containers/registries.conf")
    args = parser.parse_args()
    _migrate(args.input)


if __name__ == '__main__':
    migrate()

