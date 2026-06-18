#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd


class Ngraw:
    def __init__(self, filename, pv=False):
        """
        filename: relative path to raw file
        pv: True: print vector names and types on initialization
        """
        self.filename = filename
        self.pv = pv
        self.names, self.types, self.vectors = self.read_ngspice_binary_raw(self.filename)
        self.df = pd.DataFrame(self.vectors)

        if self.pv:
            print("Available vectors:")
            print(f"  {'NAMES':20s} TYPES")
            print("")
            for n, t in zip(self.names, self.types):
                print(f"  {n:20s} {t}")

    def read_ngspice_binary_raw(self, filename):
        with open(filename, "rb") as f:
            nvars = None
            npoints = None
            names = []
            types = []
            flags = []

            while True:
                line = f.readline()
                if not line:
                    raise RuntimeError("No Binary: section found")

                s = line.decode("latin1").strip()

                if s.lower().startswith("flags:"):
                    flags = s.split(":", 1)[1].split()

                elif s.lower().startswith("no. variables:"):
                    nvars = int(s.split(":", 1)[1])

                elif s.lower().startswith("no. points:"):
                    npoints = int(s.split(":", 1)[1])

                elif s.lower().startswith("variables:"):
                    for _ in range(nvars):
                        parts = f.readline().decode("latin1").split()
                        names.append(parts[1])
                        types.append(parts[2])

                elif s.lower().startswith("binary:"):
                    break

            is_complex = "complex" in flags

            if is_complex:
                raw = np.fromfile(f, dtype=np.float64, count=npoints * nvars * 2)
                raw = raw.reshape((npoints, nvars, 2))
                data = raw[:, :, 0] + 1j * raw[:, :, 1]
            else:
                raw = np.fromfile(f, dtype=np.float64, count=npoints * nvars)
                data = raw.reshape((npoints, nvars))

            vectors = {name: data[:, i] for i, name in enumerate(names)}

            return names, types, vectors