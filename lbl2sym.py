#!/usr/local/bin/python3
import sys


def convert_maps(labels_filename, sym_filename):
    labels_file = open(labels_filename, "r")
    label_lines = labels_file.readlines()

    labels = {}
    
    for line in label_lines:
        parts = line.split()
        label = parts[2][1:]
        addr = parts[1][2:].lower()
        if not label.startswith("__"):
            labels[label] = addr

    sym_file = open(sym_filename, "w")
    for label, addr in labels.items():
        sym_file.write(label + "        " + addr + "        (R )\n")


if __name__ == "__main__":
    convert_maps(sys.argv[1], sys.argv[2])
