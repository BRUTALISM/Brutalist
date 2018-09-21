.PHONY: all check munge full sans lgc ttf full-ttf sans-ttf lgc-ttf status dist src-dist full-dist sans-dist lgc-dist norm check-harder pre-patch clean

# Release version
VERSION = 1.0
# Snapshot version
SNAPSHOT =
# Initial source directory, assumed read-only
SRCDIR  = src
# Directory where temporary files live
TMPDIR  = tmp
# Directory where final files are created
BUILDDIR  = build
# Directory where final archives are created
DISTDIR = dist

# Release layout
FONTCONFDIR = fontconfig
DOCDIR = .
SCRIPTSDIR = scripts
TTFDIR = ttf
RESOURCEDIR = resources

ifeq "$(SNAPSHOT)" ""
ARCHIVEVER = $(VERSION)
else
ARCHIVEVER = $(VERSION)-$(SNAPSHOT)
endif

SRCARCHIVE  = brutalist-fonts-$(ARCHIVEVER)
FULLARCHIVE = brutalist-fonts-ttf-$(ARCHIVEVER)
SANSARCHIVE = brutalist-ttf-$(ARCHIVEVER)
LGCARCHIVE  = brutalist-lgc-fonts-ttf-$(ARCHIVEVER)

ARCHIVEEXT = .zip .tar.bz2
SUMEXT     = .zip.md5 .tar.bz2.md5 .tar.bz2.sha512

OLDSTATUS   = $(DOCDIR)/status.txt
BLOCKS      = $(RESOURCEDIR)/Blocks.txt
UNICODEDATA = $(RESOURCEDIR)/UnicodeData.txt
FC-LANG     = $(RESOURCEDIR)/fc-lang

GENERATE    = $(SCRIPTSDIR)/generate.pe
TTPOSTPROC  = $(SCRIPTSDIR)/ttpostproc.pl
LGC         = $(SCRIPTSDIR)/lgc.pe
UNICOVER    = $(SCRIPTSDIR)/unicover.pl
LANGCOVER   = $(SCRIPTSDIR)/langcover.pl
STATUS	    = $(SCRIPTSDIR)/status.pl
PROBLEMS    = $(SCRIPTSDIR)/problems.pl
NORMALIZE   = $(SCRIPTSDIR)/sfdnormalize.pl
NARROW      = $(SCRIPTSDIR)/narrow.pe

SRC      := $(wildcard $(SRCDIR)/*.sfd)
SFDFILES := $(patsubst $(SRCDIR)/%, %, $(SRC))
FULLSFD  := $(patsubst $(SRCDIR)/%.sfd, $(TMPDIR)/%.sfd, $(SRC))
NORMSFD  := $(patsubst %, %.norm, $(FULLSFD))
MATSHSFD := $(wildcard $(SRCDIR)/*Math*.sfd)
LGCSRC   := $(filter-out $(MATSHSFD),$(SRC))
LGCSFD   := $(patsubst $(SRCDIR)/Brutalist%.sfd, $(TMPDIR)/BrutalistLGC%.sfd, $(LGCSRC))
FULLTTF  := $(patsubst $(TMPDIR)/%.sfd, $(BUILDDIR)/%.ttf, $(FULLSFD))
LGCTTF   := $(patsubst $(TMPDIR)/%.sfd, $(BUILDDIR)/%.ttf, $(LGCSFD))

FONTCONF     := $(wildcard $(FONTCONFDIR)/*.conf)
FONTCONFLGC  := $(wildcard $(FONTCONFDIR)/*lgc*.conf)
FONTCONFFULL := $(filter-out $(FONTCONFLGC), $(FONTCONF))

STATICDOC := $(addprefix $(DOCDIR)/, AUTHORS LICENSE NEWS README.md)
STATICSRCDOC := $(addprefix $(DOCDIR)/, BUILDING.md)
GENDOCFULL = unicover.txt langcover.txt status.txt
GENDOCSANS = unicover-sans.txt langcover-sans.txt
GENDOCLGC  = unicover-lgc.txt langcover-lgc.txt

all : full sans lgc

$(TMPDIR)/%.sfd: $(SRCDIR)/%.sfd
	@echo "[1] $< => $@"
	install -d $(dir $@)
	sed "s@\(Version:\? \)\(0\.[0-9]\+\.[0-9]\+\|[1-9][0-9]*\.[0-9]\+\)@\1$(VERSION)@" $< > $@
	touch -r $< $@

$(TMPDIR)/BrutalistLGCMathTeXGyre.sfd: $(TMPDIR)/BrutalistMathTeXGyre.sfd
	@echo "[2] skipping $<"

$(TMPDIR)/BrutalistLGC%.sfd: $(TMPDIR)/Brutalist%.sfd
	@echo "[2] $< => $@"
	sed -e 's,FontName: Brutalist,FontName: BrutalistLGC,'\
	    -e 's,FullName: Brutalist,FullName: Brutalist LGC,'\
	    -e 's,FamilyName: Brutalist,FamilyName: Brutalist LGC,'\
	    -e 's,"Brutalist \(\(Sans\|Serif\)*\( Condensed\| Mono\)*\( Bold\)*\( Oblique\|Italic\)*\)","Brutalist LGC \1",g' < $< > $@
	@echo "Stripping unwanted glyphs from $@"
	$(LGC) $@
	touch -r $< $@

$(BUILDDIR)/BrutalistLGCMathTeXGyre.ttf: $(TMPDIR)/BrutalistLGCMathTeXGyre.sfd
	@echo "[3] skipping $<"

$(BUILDDIR)/%.ttf: $(TMPDIR)/%.sfd
	@echo "[3] $< => $@"
	install -d $(dir $@)
	$(GENERATE) $<
	mv $<.ttf $@
	$(TTPOSTPROC) $@
	$(RM) $@~
	touch -r $< $@

$(BUILDDIR)/status.txt: $(FULLSFD)
	@echo "[4] => $@"
	install -d $(dir $@)
	$(STATUS) $(VERSION) $(OLDSTATUS) $(FULLSFD) > $@

$(BUILDDIR)/unicover.txt: $(patsubst %, $(TMPDIR)/%.sfd, Brutalist BrutalistSerif BrutalistMono)
	@echo "[5] => $@"
	install -d $(dir $@)
	$(UNICOVER) $(UNICODEDATA) $(BLOCKS) \
	            $(TMPDIR)/Brutalist.sfd "Sans" \
	            $(TMPDIR)/BrutalistSerif.sfd "Serif" \
	            $(TMPDIR)/BrutalistMono.sfd "Sans Mono" > $@

$(BUILDDIR)/unicover-sans.txt: $(TMPDIR)/Brutalist.sfd
	@echo "[5] => $@"
	install -d $(dir $@)
	$(UNICOVER) $(UNICODEDATA) $(BLOCKS) \
	            $(TMPDIR)/Brutalist.sfd "Sans" > $@

$(BUILDDIR)/unicover-lgc.txt: $(patsubst %, $(TMPDIR)/%.sfd, BrutalistLGCSans BrutalistLGCSerif BrutalistLGCSansMono)
	@echo "[5] => $@"
	install -d $(dir $@)
	$(UNICOVER) $(UNICODEDATA) $(BLOCKS) \
	            $(TMPDIR)/BrutalistLGCSans.sfd "Sans" \
	            $(TMPDIR)/BrutalistLGCSerif.sfd "Serif" \
	            $(TMPDIR)/BrutalistLGCSansMono.sfd "Sans Mono" > $@

$(BUILDDIR)/langcover.txt: $(patsubst %, $(TMPDIR)/%.sfd, Brutalist BrutalistSerif BrutalistMono)
	@echo "[6] => $@"
	install -d $(dir $@)
ifeq "$(FC-LANG)" ""
	touch $@
else
	$(LANGCOVER) $(FC-LANG) \
	             $(TMPDIR)/Brutalist.sfd "Sans" \
	             $(TMPDIR)/BrutalistSerif.sfd "Serif" \
	             $(TMPDIR)/BrutalistMono.sfd "Sans Mono" > $@
endif

$(BUILDDIR)/langcover-sans.txt: $(TMPDIR)/Brutalist.sfd
	@echo "[6] => $@"
	install -d $(dir $@)
ifeq "$(FC-LANG)" ""
	touch $@
else
	$(LANGCOVER) $(FC-LANG) \
	             $(TMPDIR)/Brutalist.sfd "Sans" > $@
endif

$(BUILDDIR)/langcover-lgc.txt: $(patsubst %, $(TMPDIR)/%.sfd, BrutalistLGCSans BrutalistLGCSerif BrutalistLGCSansMono)
	@echo "[6] => $@"
	install -d $(dir $@)
ifeq "$(FC-LANG)" ""
	touch $@
else
	$(LANGCOVER) $(FC-LANG) \
	             $(TMPDIR)/BrutalistLGCSans.sfd "Sans" \
	             $(TMPDIR)/BrutalistLGCSerif.sfd "Serif" \
	             $(TMPDIR)/BrutalistLGCSansMono.sfd "Sans Mono" > $@
endif

$(BUILDDIR)/Makefile: Makefile
	@echo "[7] => $@"
	install -d $(dir $@)
	sed -e "s+^VERSION\([[:space:]]*\)=\(.*\)+VERSION = $(VERSION)+g"\
	    -e "s+^SNAPSHOT\([[:space:]]*\)=\(.*\)+SNAPSHOT = $(SNAPSHOT)+g" < $< > $@
	touch -r $< $@

$(TMPDIR)/$(SRCARCHIVE): $(addprefix $(BUILDDIR)/, $(GENDOCFULL) Makefile) $(FULLSFD)
	@echo "[8] => $@"
	install -d -m 0755 $@/$(SCRIPTSDIR)
	install -d -m 0755 $@/$(SRCDIR)
	install -d -m 0755 $@/$(FONTCONFDIR)
	install -d -m 0755 $@/$(DOCDIR)
	install -p -m 0644 $(BUILDDIR)/Makefile $@
	install -p -m 0755 $(GENERATE) $(TTPOSTPROC) $(LGC) $(NORMALIZE) \
	                   $(UNICOVER) $(LANGCOVER) $(STATUS) $(PROBLEMS) \
	                   $@/$(SCRIPTSDIR)
	install -p -m 0644 $(FULLSFD) $@/$(SRCDIR)
	install -p -m 0644 $(FONTCONF) $@/$(FONTCONFDIR)
	install -p -m 0644 $(addprefix $(BUILDDIR)/, $(GENDOCFULL)) \
	                   $(STATICDOC) $(STATICSRCDOC) $@/$(DOCDIR)

$(TMPDIR)/$(FULLARCHIVE): full
	@echo "[8] => $@"
	install -d -m 0755 $@/$(TTFDIR)
	install -d -m 0755 $@/$(FONTCONFDIR)
	install -d -m 0755 $@/$(DOCDIR)
	install -p -m 0644 $(FULLTTF) $@/$(TTFDIR)
	install -p -m 0644 $(FONTCONFFULL) $@/$(FONTCONFDIR)
	install -p -m 0644 $(addprefix $(BUILDDIR)/, $(GENDOCFULL)) \
	                   $(STATICDOC) $@/$(DOCDIR)

$(TMPDIR)/$(SANSARCHIVE): sans
	@echo "[8] => $@"
	install -d -m 0755 $@/$(TTFDIR)
	install -d -m 0755 $@/$(DOCDIR)
	install -p -m 0644 $(BUILDDIR)/Brutalist.ttf $@/$(TTFDIR)
	install -p -m 0644 $(addprefix $(BUILDDIR)/, $(GENDOCSANS)) \
	                   $(STATICDOC) $@/$(DOCDIR)

$(TMPDIR)/$(LGCARCHIVE): lgc
	@echo "[8] => $@"
	install -d -m 0755 $@/$(TTFDIR)
	install -d -m 0755 $@/$(FONTCONFDIR)
	install -d -m 0755 $@/$(DOCDIR)
	install -p -m 0644 $(LGCTTF) $@/$(TTFDIR)
	install -p -m 0644 $(FONTCONFLGC) $@/$(FONTCONFDIR)
	install -p -m 0644 $(addprefix $(BUILDDIR)/, $(GENDOCLGC)) \
	                   $(STATICDOC) $@/$(DOCDIR)

$(DISTDIR)/%.zip: $(TMPDIR)/%
	@echo "[9] => $@"
	install -d $(dir $@)
	(cd $(TMPDIR); zip -rv $(abspath $@) $(notdir $<))

$(DISTDIR)/%.tar.bz2: $(TMPDIR)/%
	@echo "[9] => $@"
	install -d $(dir $@)
	(cd $(TMPDIR); tar cjvf $(abspath $@) $(notdir $<))

%.md5: %
	@echo "[10] => $@"
	(cd $(dir $<); md5sum -b $(notdir $<) > $(abspath $@))

%.sha512: %
	@echo "[10] => $@"
	(cd $(dir $<); sha512sum -b $(notdir $<) > $(abspath $@))

%.sfd.norm: %.sfd
	@echo "[11] $< => $@"
	$(NORMALIZE) $<
	touch -r $< $@

check : $(NORMSFD)
	for sfd in $^ ; do \
	echo "[12] Checking $$sfd" ;\
	$(PROBLEMS)  $$sfd ;\
	done

munge: $(NORMSFD)
	for sfd in $(SFDFILES) ; do \
	echo "[13] $(TMPDIR)/$$sfd.norm => $(SRCDIR)/$$sfd" ;\
	cp $(TMPDIR)/$$sfd.norm $(SRCDIR)/$$sfd ;\
	done

full : $(FULLTTF) $(addprefix $(BUILDDIR)/, $(GENDOCFULL))

sans : $(addprefix $(BUILDDIR)/, Brutalist.ttf $(GENDOCSANS))

lgc : $(LGCTTF) $(addprefix $(BUILDDIR)/, $(GENDOCLGC))

ttf : full-ttf sans-ttf lgc-ttf

full-ttf : $(FULLTTF)

sans-ttf: $(BUILDDIR)/Brutalist.ttf

lgc-ttf : $(LGCTTF)

status : $(addprefix $(BUILDDIR)/, $(GENDOCFULL))

dist : src-dist full-dist sans-dist lgc-dist

src-dist :  $(addprefix $(DISTDIR)/$(SRCARCHIVE),  $(ARCHIVEEXT) $(SUMEXT))

full-dist : $(addprefix $(DISTDIR)/$(FULLARCHIVE), $(ARCHIVEEXT) $(SUMEXT))

sans-dist : $(addprefix $(DISTDIR)/$(SANSARCHIVE), $(ARCHIVEEXT) $(SUMEXT))

lgc-dist :  $(addprefix $(DISTDIR)/$(LGCARCHIVE),  $(ARCHIVEEXT) $(SUMEXT))

norm : $(NORMSFD)

check-harder : clean check

pre-patch : munge clean

clean :
	$(RM) -r $(TMPDIR) $(BUILDDIR) $(DISTDIR)

condensed: $(NORMSFD)
	$(NARROW) 90 $(TMPDIR)/Brutalist.sfd.norm
	$(NARROW) 90 $(TMPDIR)/Brutalist-Bold.sfd.norm
	$(NARROW) 90 $(TMPDIR)/Brutalist-Oblique.sfd.norm
	$(NARROW) 90 $(TMPDIR)/Brutalist-BoldOblique.sfd.norm
	$(NARROW) 90 $(TMPDIR)/BrutalistSerif.sfd.norm
	$(NARROW) 90 $(TMPDIR)/BrutalistSerif-Bold.sfd.norm
	$(NARROW) 90 $(TMPDIR)/BrutalistSerif-Italic.sfd.norm
	$(NARROW) 90 $(TMPDIR)/BrutalistSerif-BoldItalic.sfd.norm
	$(NORMALIZE) $(TMPDIR)/Brutalist.sfd.norm.narrow
	$(NORMALIZE) $(TMPDIR)/Brutalist-Bold.sfd.norm.narrow
	$(NORMALIZE) $(TMPDIR)/Brutalist-Oblique.sfd.norm.narrow
	$(NORMALIZE) $(TMPDIR)/Brutalist-BoldOblique.sfd.norm.narrow
	$(NORMALIZE) $(TMPDIR)/BrutalistSerif.sfd.norm.narrow
	$(NORMALIZE) $(TMPDIR)/BrutalistSerif-Bold.sfd.norm.narrow
	$(NORMALIZE) $(TMPDIR)/BrutalistSerif-Italic.sfd.norm.narrow
	$(NORMALIZE) $(TMPDIR)/BrutalistSerif-BoldItalic.sfd.norm.narrow
	cp $(TMPDIR)/Brutalist.sfd.norm.narrow.norm $(TMPDIR)/BrutalistCondensed.sfd.norm
	cp $(TMPDIR)/Brutalist-Bold.sfd.norm.narrow.norm $(TMPDIR)/BrutalistCondensed-Bold.sfd.norm
	cp $(TMPDIR)/Brutalist-Oblique.sfd.norm.narrow.norm $(TMPDIR)/BrutalistCondensed-Oblique.sfd.norm
	cp $(TMPDIR)/Brutalist-BoldOblique.sfd.norm.narrow.norm $(TMPDIR)/BrutalistCondensed-BoldOblique.sfd.norm
	cp $(TMPDIR)/BrutalistSerif.sfd.norm.narrow.norm $(TMPDIR)/BrutalistSerifCondensed.sfd.norm
	cp $(TMPDIR)/BrutalistSerif-Bold.sfd.norm.narrow.norm $(TMPDIR)/BrutalistSerifCondensed-Bold.sfd.norm
	cp $(TMPDIR)/BrutalistSerif-Italic.sfd.norm.narrow.norm $(TMPDIR)/BrutalistSerifCondensed-Italic.sfd.norm
	cp $(TMPDIR)/BrutalistSerif-BoldItalic.sfd.norm.narrow.norm $(TMPDIR)/BrutalistSerifCondensed-BoldItalic.sfd.norm
