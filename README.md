# Brutalist Mono

Brutalist Mono is a very simple modification on top of DejaVu Sans Mono, making it more suitable for coding. The changes are very nitpicky and you can probably just move along.

## Motivation

Another DejaVu Sans Mono / Bitstream Vera Mono clone? Yes. But this one is opinionated:

1. I don't care about "readability on small font sizes". Make your font larger and/or get a decent monitor. It's the 21st century.
2. I don't care about font hinting. Modern monitors are high-DPI. If you care about font hinting, try some other DejaVu mod.
3. I don't care about `O0`, `lI1|`, or any of that crap. It's good enough. See point #1.

If any of this bothers you, try [Hack](https://github.com/source-foundry/Hack). It's awesome.

### Why not Hack?

Hack is great, but has way too many unnecessary modifications on top of the baseline DejaVu Sans Mono:

* the parentheses are unnecessarily spread out in earlier versions, and just too rounded in newer ones
* the `1` has an awkward downward facing arm
* contributing is hard if you're only using plain old FontForge (I don't want to shell out EUR 250 for Glyphs.app)
* [alt-hack](https://github.com/source-foundry/alt-hack) is great but I ended up just using it to revert most mods back to the original DejaVu style, so I figured why bother

### Why not Menlo?

* the uppercase `N` is hideously wide (once you see it, you can not unsee it)
* punctuation is unnecessarily exaggerated
* there are [many weird tweaks](http://leancrew.com/all-this/2009/10/the-compleat-menlovera-sans-comparison/) done to it (relative to DejaVu) to make it render better on ancient Mac OS versions with low-DPI monitors, which disqualifies it immediately (see point #1 in "Motivation" above)

### Why not DejaVu Sans Mono?

This typeface is almost perfect for programming, except:

* the underscore is ridiculously thin, making it visually odd when reading `THINGS_WITH_MANY_UNDERSCORES` et al.
* the lowercase `r` is offset a bit to the right (Hack has this right – once you see it, you can not unsee it)
* the `-` glyph is ridiculously narrow

## Changes from DejaVu Sans Mono

TODO

## Building

Short version:

* Edit the .sdf files with FontForge
* `make`

This will probably fail, so: [long version](BUILDING.md).

## Contributing

If you really convince me.

## License

Same as DejaVu fonts, see [LICENSE](LICENSE).