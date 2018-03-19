# System-wide registries parsing tool

import sys
from abc import abstractmethod, ABCMeta
import yaml
import pytoml
import argparse
import json
import logging
import logging.handlers
import os

def log_warning(conf_file):
    test = os.environ.get("TEST", 0)
    if test == 0:
        log = logging.getLogger(__name__)
        log.setLevel(logging.DEBUG)
        handler = logging.handlers.SysLogHandler(address = '/dev/log')
        formatter = logging.Formatter('%(module)s.%(funcName)s: %(message)s')
        handler.setFormatter(formatter)
        log.addHandler(handler)
        log.warning("{} is in YAML format and should be in TOML format. Back this file up and then "
                    "use /usr/libexec/registries_migrator -o /etc/containers/registries.conf to "
                    "convert it to TOML.".format(conf_file))

map_output = {
    "registries.search": "--add-registry",
    "registries.insecure":  "--insecure-registry",
    "registries.block": "--block-registry"
}


def write_file(filename, data):
    dir_path = os.path.dirname(filename)
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)
    with open(filename,"w") as f:
        f.write(data)


def normalize_registry(registry):
    registry["registries"] = [x.rstrip("/") for x in registry["registries"]]
    return registry


def to_dict(secure, insecure, block):
    secure = normalize_registry(secure)
    insecure = normalize_registry(insecure)
    block = normalize_registry(block)
    return {
        "registries.search": {"registries": secure["registries"]},
        "registries.insecure": {"registries": insecure["registries"]},
        "registries.block": {"registries": block["registries"]}
}


def do_output(output, args):
    if args.output:
        if args.variable:
            output = "{}=\"".format(args.variable) + output + "\""
        write_file(args.output, output)
    else:
        sys.stdout.write("{}\n".format(output))


def to_string(config):
    out_str = ""
    for i in map_output:
        for registry in config[i]['registries']:
            out_str += "{} {} ".format(map_output[i], registry)
    return out_str


class Conf(object): #pylint: disable=metaclass-assignment
    # Mark the class as abstract
    __metaclass__ = ABCMeta

    @abstractmethod
    def load(registries_conf_file):
        pass

    @abstractmethod
    def get_registries(self, conf_file):
        pass


class LoadError(Exception):
    pass


class loadYAML(Conf):
    @staticmethod
    def load(registries_conf_file):
        with open(registries_conf_file, 'r') as stream:
            return yaml.load(stream)

    @classmethod
    def get_registries(cls, conf_file):
        config = cls.load(conf_file)
        _registries = []
        _insecure = []
        _block = []
        if config is not None:
            _registries = [] if "registries" not in config else config["registries"]
            _insecure= [] if "insecure_registries" not in config else config['insecure_registries']
            _block = [] if "block_registries" not in config else config['block_registries']
        log_warning(conf_file)
        return to_dict({"registries": _registries}, {"registries": _insecure}, {"registries": _block})


class loadTOML(Conf):
    @staticmethod
    def load(registries_conf_file):
        with open(registries_conf_file, 'rb') as stream:
            return pytoml.load(stream)

    @classmethod
    def get_registries(cls, conf_file):
        config = cls.load(conf_file)
        reg = config.get('registries', None)
        if reg:
            _registries = {"registries": []} if 'search' not in reg else reg['search']
            _insecure = {"registries": []} if 'insecure' not in reg else reg['insecure']
            _block = {"registries":[]} if "block" not in reg else reg['block']
        else:
            _registries = config.get("registries.search", {"registries": []})
            _insecure = config.get("registries.insecure", {"registries": []})
            _block = config.get("registries.block", {"registries": []})
        return to_dict(_registries, _insecure, _block)



def load_config(registries_conf_file):
    try:
        registries = loadTOML.get_registries(registries_conf_file)
    except (pytoml.TomlError, KeyError):
        try:
            registries = loadYAML.get_registries(registries_conf_file)
        except yaml.YAMLError:
            sys.stderr.write("Unable to load and parse {}\n.".format(registries_conf_file))
            sys.exit(1)

    return registries


def registries():
    parser = argparse.ArgumentParser(description="Parse global registries configuration file")
    parser.add_argument("-i", "--input", help="Specify an input file", default="/etc/containers/registries.conf")
    parser.add_argument("-j", "--json", help="Output in JSON format", action="store_true")
    parser.add_argument("-o", "--output", help="Specify an output file")
    parser.add_argument("-V", "--variable", help="Specify a variable assignment")
    args = parser.parse_args()

    if args.variable and not args.output:
        sys.stderr.write("You must use --output with -V")
        sys.exit(1)

    registries_config = load_config(args.input)
    output = json.dumps(registries_config) if args.json else to_string(registries_config)


    do_output(output, args)

if __name__ == '__main__':
    registries()
