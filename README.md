# TSENSE8490

Single-technology IP library.

- doc/     : user documentation
- dependencies/ : sub-cells and blocks
- release/v.1.0.0 : immutable versioned deliveries


# Self-tought Mixed-Signal On-Chip Temperature Sensor

Welcome 👋

In this repository I host all design-files for my self-tought mixed-signal on-chip temperature sensor.


## Layout

![floorplan|400](TSENSE8490-main/layout/klayout/img/floorplan.svg)

|                |                  |
| ----------------| ------------------|
| **Category**   | Mixed-Signal SoC |
| **Technology** | IHP SG13CMOS5L   |
| **Top Cell**   | `TSENSE8490`     |
| **Die Size**   | 1.0 mm × 1.0 mm  |
| **License**    | Apache-2.0       |

### Current Starved RO

![current_starved_ro|400](TSENSE8490-main/layout/klayout/img/current_starved_ro.png)


## Sims


### Transient

![full|400](TSENSE8490-main/testbenches/tran/xschem/octs-full-tb.svg)


### Corners

Mismatch, 25C

![mm25c|400](TSENSE8490-main/testbenches/corners/xschem/mm25c.svg)

Mismatch, T-sweep

![mmtsweep|400](TSENSE8490-main/testbenches/corners/xschem/mmtsweep.svg)


## Tools

I am using the all-in-one docker container [IIC-OSIC-TOOLS](https://github.com/iic-jku/iic-osic-tools) and [IHPs PDK](https://github.com/IHP-GmbH/IHP-Open-PDK) with the [SG13CMOS5L](https://github.com/IHP-GmbH/ihp-sg13cmos5l) process node - which is nativly included in IIC-OSIC-TOOLS as of tag [2026.04](https://github.com/iic-jku/IIC-OSIC-TOOLS/releases/tag/2026.04).


### Pre-Flight Configuration

First, make and cd into a project dir ``~/chipdesignstuff/``:
```shell
mkdir -p ~/chipdesignstuff && cd ~/chipdesignstuff
```

Clone [IIC-OSIC-TOOLS](https://github.com/iic-jku/iic-osic-tools) and this repository:
```shell
git clone https://github.com/iic-jku/IIC-OSIC-TOOLS.git
git clone https://gitlab.com/opdkstuff/IHP__TSENSE8490.git
```

Make some environment variables stick and apply on login:

> [!Note]
> If not already done, make fish source env variables defined in ``profile.fish`` and ``environment.fish``:
> ```bash
> echo 'source $__fish_config_dir/profile.fish' >> "$__fish_config_dir/profile.fish"
> ```

```bash
echo 'export DESIGNS="$HOME/chipdesignstuff/IHP__TSENSE8490"' >> "$__fish_config_dir/profile.fish"
echo 'export PDK=ihp-sg13cmos5l' >> "$__fish_config_dir/profile.fish"
echo 'export PDKPATH=$PDK_ROOT/$PDK' >> "$__fish_config_dir/profile.fish"
echo 'export STD_CELL_LIBRARY=sg13cmos5l_stdcell' >> "$__fish_config_dir/profile.fish"
echo 'export KLAYOUT_PATH="$PDKPATH/libs.tech/klayout:$PDKPATH/libs.tech/klayout/tech"' >> "$__fish_config_dir/profile.fish"
```

💫 Now start the container as instructed with the env variable ``DESIGNS`` pointing to the project repository.


### Ngspice Specifics

Copy the PDKs ``.spiceinit`` file to the ``$DESIGNS`` dir and append some customizations:

```bash
cp $PDK_ROOT/$PDK/libs.tech/ngspice/.spiceinit $DESIGNS/.spiceinit
echo "setcs sourcepath = (  $sourcepath $DESIGNS )" >> $SPICE_USERINIT_FILE
```

Make Ngspice load it by setting the env variable:

```bash
echo "export SPICE_USERINIT_DIR=$DESIGNS" >> "$__fish_config_dir/profile.fish"
```


### External Python Scripts

I am using a customized version of [qnzy/ngrun](https://github.com/qnzy/ngrun.git).
My customizations include:

- Moved ``temp_dir`` to the netlists base dir.
- Added timestamp to the temp dir name.
- Added some extra info to the terminal (elapsed time per run, etc.).
- Some visual adjustments to the terminal output.
- Put output ``*.csv`` file inside ``temp_dir``.
- Make ``ngspice`` put a ``run.log`` next to the spice files inside ``temp_dir``.
- Make ``ngspice`` put the ``*.raw`` files next to the spice files inside ``temp_dir``.

The module [ngspice_raw_read.py](./ngspice_raw_read.py) reads ngspice binary files and stores the data in a Pandas data frame for ez manipulation.


## Digital

See [TSENSE8490-main/schematic/xschem/digital/div16/README.md](TSENSE8490-main/schematic/xschem/digital/div16/README.md).


## QOL

> [!note]
> I am running an Arch-based Distro. The following are **quality of live** configurations I've made and are not stricktly necessary.

I am starting an stopping the tools **a lot**. So, for a little more convenience, here are some extra configurations to make life easier.

In order to comfortably start the container from the Start Menu, create a ``.desktop`` entry at ``$HOME/.local/share/applications/chipdesignstuff.desktop`` with the following content:

```
[Desktop Entry]
Categories=Science;Education
Comment=Starts IIC-OSIC Tools docker container containing PDKs like IHPs SG13G2 or Skywaters SKY130 alongside many design tools and simulators like NGspice, Xschem, KLayout.
Exec=bash -c '$HOME/chipdesignstuff/iic-osic-tools/start_x.sh'
GenericName=pdk
Icon=preferences-desktop
Keywords=pdk;docker;asic;chipdesign
Name=OpenPDK Docker Container
NoDisplay=false
Path=
PrefersNonDefaultGPU=false
StartupNotify=true
Terminal=true
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=
```

---


# License

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
```