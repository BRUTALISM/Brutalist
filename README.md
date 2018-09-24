# Brutalist Mono

Brutalist Mono is a very simple modification on top of DejaVu Sans Mono (yes, _another one_), making it more suitable for coding. The changes are very nitpicky and you can probably just move along.

## Changes from DejaVu Sans Mono

v1.0:

* lowercase `r` – offset to the left
* underscore – increase height, reduce width
* minus sign – make wider
* zero – slashed instead of dotted

v1.1:

* lowercase `l` – increase upper arm and recenter
* lowercase `i` and `j` – increase dot sizes, making them square

Next release:

* lowercase `l` – drop foot below the baseline
* uppercase `C` – flatter terminals
* uppercase `G` – flatter top terminal
* uppercase `J` – flatter bottom terminal
* lowercase `a` – flatter top terminal
* lowercase `c` – flatter terminals
* lowercase `e` – flatter bottom terminal
* lowercase `g` – flatter bottom terminal
* lowercase `r` – flatter top terminal

## Motivation

Another DejaVu Sans Mono / Bitstream Vera Mono clone? Yes. But this one is opinionated:

1. I don't care about "readability on small font sizes". Make your font larger and/or get a decent monitor. It's the 21st century.
2. I don't care about font hinting. Modern monitors are high-DPI.
3. I don't care about `O0`, `lI1|`, or any of that crap. It's good enough. See point #1.

If any of this bothers you, try [Hack](https://github.com/source-foundry/Hack). It's awesome.

### Why not Hack?

Hack is great, but has way too many unnecessary modifications on top of the baseline DejaVu Sans Mono. To name a few:

* the parentheses are unnecessarily spread out in earlier versions, and too rounded in newer ones
* the `1` has an awkward downward facing arm
* contributing is complicated if you're only using plain old FontForge (I don't want to shell out EUR 250 for Glyphs.app)
* [alt-hack](https://github.com/source-foundry/alt-hack) is great but I ended up just using it to revert most mods back to the original DejaVu style, so I figured why bother?

### Why not Menlo?

* the uppercase `N` is hideously wide (once you see it, you can not unsee it)
* punctuation is unnecessarily exaggerated
* there are [many weird tweaks](http://leancrew.com/all-this/2009/10/the-compleat-menlovera-sans-comparison/) done to it (relative to its parent Bitstream Vera Sans Mono) to make it render better on ancient Mac OS versions with low-DPI monitors, which disqualifies it immediately (see point #1 in "Motivation" above)

### Why not DejaVu Sans Mono?

This typeface is almost perfect for programming, except:

* the underscore is ridiculously thin, making it visually odd when reading `THINGS_WITH_MANY_UNDERSCORES` and esoteric C/C++ identifiers with `__multiple__underscores__`
* the lowercase `r` is offset a bit to the right (Hack has got this right – once you see it, you can not unsee it)
* the `-` glyph is ridiculously narrow

## Building

Short version:

* Edit the .sdf files with FontForge
* `make`

This will probably fail, so: [long version](BUILDING.md).

## Contributing

If you really convince me.

## License

Same as DejaVu fonts, see [LICENSE](LICENSE).