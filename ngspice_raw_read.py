#!/usr/bin/env python3

from pathlib import Path

import numpy as np
import pandas as pd


class Ngraw:
    def __init__(self, filename, pv=False):
        """
        filename: relative path to ngspice raw file
        pv: True: print vector names and types on initialization
        """
        self.filename = Path(filename)
        self.pv = pv

        self.names, self.types, self.data = self.read_ngspice_binary_raw()

        # Save stuff to DataFrame and keep column order as found in the raw file.
        self.df = pd.DataFrame(self.data, columns=self.names)

        if self.pv:
            self.print_vectors()


    def print_vectors(self):
        """
        Print available vector names and types.
        """
        print("Available vectors:")
        print(f"  {'NAMES':20s} TYPES\n")

        for name, vector_type in zip(self.names, self.types):
            print(f"  {name:20s} {vector_type}")


    def read_ngspice_binary_raw(self):
        """
        Read an ngspice binary raw file into names, types and a NumPy array.
        """
        with open(self.filename, "rb") as f:
            nvars = None
            npoints = None
            names = []
            types = []
            flags = []

            # Read text header until the binary data section begins.
            while True:
                line = f.readline()

                if not line:
                    raise RuntimeError("No 'Binary:' section found")

                s = line.decode("latin1").strip()
                lower = s.lower()

                if lower.startswith("flags:"):
                    flags = s.split(":", 1)[1].split()

                elif lower.startswith("no. variables:"):
                    nvars = int(s.split(":", 1)[1])

                elif lower.startswith("no. points:"):
                    npoints = int(s.split(":", 1)[1])

                elif lower.startswith("variables:"):
                    if nvars is None:
                        raise RuntimeError("'Variables:' found before 'No. Variables:'")

                    # Variable lines usually contain: index, name, type.
                    for _ in range(nvars):
                        parts = f.readline().decode("latin1").split()

                        if len(parts) < 3:
                            raise RuntimeError(f"Malformed variable line: {parts}")

                        names.append(parts[1])
                        types.append(parts[2])

                elif lower.startswith("binary:"):
                    break

            if nvars is None:
                raise RuntimeError("Missing 'No. Variables:' header")

            if npoints is None:
                raise RuntimeError("Missing 'No. Points:' header")

            is_complex = "complex" in flags

            # ngspice stores binary raw data as float64 values.
            values_per_sample = 2 if is_complex else 1
            expected_count = npoints * nvars * values_per_sample

            raw = np.fromfile(f, dtype=np.float64, count=expected_count)

            if raw.size != expected_count:
                raise RuntimeError(
                    f"Truncated binary data: expected {expected_count} float64 values, "
                    f"got {raw.size}"
                )

            if is_complex:
                # Complex values are stored as real/imaginary float64 pairs.
                raw = raw.reshape((npoints, nvars, 2))
                data = raw[:, :, 0] + 1j * raw[:, :, 1]
            else:
                data = raw.reshape((npoints, nvars))

            return names, types, data
