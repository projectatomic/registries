from registries.registries import loadYAML
import pytoml
import argparse
import sys


def _migrate(registries_conf_file, output_file):
    toml = pytoml.dumps(loadYAML.get_registries(registries_conf_file))
    if output_file:
        with open(output_file,"w") as f:
            f.write(toml)
    else:
        print(toml)


def migrate():
    parser = argparse.ArgumentParser(description="Migrate registries.conf from YAML to TOML")
    parser.add_argument("-i", "--input", help="Specify an input file", default="/etc/containers/registries.conf")
    parser.add_argument("-o", "--output", help="Specify an output file")
    args = parser.parse_args()
    _migrate(args.input, args.output)


if __name__ == '__main__':
    migrate()

