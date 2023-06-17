# Brutalist Mono

This has been forked from [Brutalist Mono](https://github.com/BRUTALISM/Brutalist) to have it recognized correctly as a fixed width font by macOS.

Brutalist Mono is a fork of [DejaVu Sans Mono v2.37](https://github.com/dejavu-fonts/dejavu-fonts) which itself is a fork of [Bitstream Vera Sans Mono v1.10](https://web.archive.org/web/20210314185159/https://www.gnome.org/fonts/).

![brutalist](images/brutalist.jpg)

Comparison to DejaVu Sans Mono:

![brutalist](images/brutalist_vs_dejavu.gif)

## Changes from DejaVu Sans Mono

v2.2:

* Fix spacing so the font is recognized by macOS as a monospace font.

v2.1:

* `,`, `.`, `;`, `:`, `!`, `?` – use rounded dots and commas (adapted from Hack)
* `*` – use Menlo variant
* `l` – clean up bottom curve a little bit

v2.0:

* `C` – slightly rounder shape
* `G` – more even upper terminal
* `S` – more even terminals
* `c` – more even terminals
* `l` – more pedantic bottom
* `r` – wider right terminal
* `s` – more even terminals
* `9` – more even lower terminal
* `g` – more even lower terminal
* `J` – clean up lower terminal
* `~` – blatantly stolen from Hack
* `t` – make bottom curved the same as `l`
* `j` – make bottom curved the same as `l`
* `[` – make wider, match `lparen`'s width
* `]` – make wider, match `rparen`'s width
* `5` – more even bottom terminal, add back the "spike" in the middle
* `y` – curved bottom terminal
* `$` – more even terminals

v1.2:

* `l` – drop foot below the baseline
* `C` – flatter terminals
* `G` – flatter top terminal
* `J` – flatter bottom terminal
* `S` – flatter terminals
* `a` – flatter top terminal
* `c` – flatter terminals
* `e` – flatter bottom terminal
* `g` – flatter bottom terminal
* `r` – flatter top terminal
* `s` – flatter terminals
* `2` – flatter top terminal
* `3` – flatter terminals
* `5` – flatter bottom terminal and mid stroke
* `6` – flatter top terminal
* `9` – flatter bottom terminal
* `$` – flatter terminals

v1.1:

* `l` – increase upper arm and recenter
* `i` and `j` – increase dot sizes, making them square

v1.0:

* `r` – offset to the left
* `_` – increase height, reduce width
* `-` (minus) – make wider
* `0` – slashed instead of dotted

## Building

Short version:

* Edit the .sdf files with FontForge (if you want to mod)
* `make`
* observe the `build` folder

See: [long version](BUILDING.md).

## License

Same as DejaVu fonts, see [LICENSE](LICENSE).
