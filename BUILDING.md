Building
--------

### Prerequisites

To build these fonts, you will need:

* [FontForge][1], installable on Debian through the `fontforge` package:

  ~~~shell
  sudo apt-get install software-properties-common
  sudo add-apt-repository ppa:fontforge/fontforge
  sudo apt-get update
  sudo apt-get install fontforge
  ~~~

  macOS users can install using [Homebrew][2]:

  ~~~shell
  brew install fontforge
  ~~~

  Fedora users should run the following command as root:

  ~~~shell
  yum install fontforge
  ~~~

  See FontForge's [installation docs][3] for more info.


* [Perl][4], with the [`Font::TTF`][5] and [`IO::String`][6] modules
  installed:

  ~~~shell
  cpan Font::TTF IO::String
  ~~~

  Debian users can install this with the `libfont-ttf-perl` package.

  macOS users may need to install as root if they encounter
  permission problems.


* GNU-compatible [Make][7], installable through Debian package `make`.

  macOS users who have installed XCode's CLI utils should already
  have `make` available.


### Generating TrueType files

To generate all fonts:

~~~console
$ make
~~~

[1]: https://fontforge.github.io/en-US/
[2]: https://brew.sh/
[3]: http://designwithfontforge.com/en-US/Installing_Fontforge.html
[4]: https://www.perl.org/
[5]: https://metacpan.org/release/Font-TTF/
[6]: https://metacpan.org/pod/IO::String
[7]: http://www.gnu.org/software/make/manual/make.html
[8]: https://wiki.freedesktop.org/www/Software/fontconfig/
