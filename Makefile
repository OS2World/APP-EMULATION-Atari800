CC = gcc
RC = windres

DEFS = -DHAVE_CONFIG_H
LIBS = -lX11 
TARGET = atari800.exe

#gcc -O2 -fno-strength-reduce -D__ST_MT_ERRNO__ -Zmtd -Zsysv-signals -Zomf -g
#-ID:/XFree86/include   -DX_LOCALE -DX_WCHAR   -DFUNCPROTO=15 -DNARROWPROTO


CFLAGS = -O2 -Id:\xfree86\include -D__ST_MT_ERRNO__ -Zmtd -Zsysv-signals -DX_LOCALE -DX_WCHAR   -DFUNCPROTO=15 -DNARROWPROTO
LDFLAGS = -s -Zmt -Zcrtdll -Zsysv-signals -Zbin-files -Ld:\xfree86\lib

INSTALL = y:/unixos2/bin/install.exe
INSTALL_PROGRAM = ${INSTALL} -s
INSTALL_DATA = ${INSTALL} -m 644

BIN_DIR = /usr/local/bin
MAN_DIR = /usr/local/share/man/man1
DOC_DIR = /usr/local/share/doc/atari800

DESTDIR =

OBJS = \
	atari.o \
	cpu.o \
	monitor.o \
	sio.o \
	devices.o \
	antic.o \
	gtia.o \
	pokey.o \
	pia.o \
	pbi.o \
	cartridge.o \
	rtime.o \
	prompts.o \
	rt-config.o \
	ui.o \
	ui_basic.o \
	binload.o \
	list.o \
	ataripcx.o \
	log.o \
	compfile.o \
	memory.o \
	statesav.o \
	colours.o \
	pokeysnd.o \
	mzpokeysnd.o \
	remez.o \
	sndsave.o \
	cassette.o \
	input.o \
	cycle_map.o \
	atari_x11.o diskled.o



all: $(TARGET)

%.o: %.c
	$(CC) -c -o $@ $(DEFS) -I. $(CFLAGS) $<

%.ro: %.rc
	$(RC) --define WIN32 --define __MINGW32__ --include-dir . $< $@

%.o: %.cpp
	$(CC) -c -o $@ $(DEFS) -I. $(CFLAGS) $<

%.o: %.asm
	cd $(<D); xgen -L1 $(@F) $(<F)
	cd $(<D); gst2gcc gcc $(@F)

$(TARGET): $(OBJS)
	$(CC) -o $@ $(LDFLAGS) $(OBJS) $(LIBS)

dep:
	@if ! makedepend -Y $(DEFS) -I. ${OBJS:.o=.c} 2>/dev/null; \
	then echo warning: makedepend failed; fi

clean:
	rm -f *.o $(TARGET) core *.bak *~

distclean: clean
	-rm -f Makefile configure config.log config.status config.h
	-rm -rf autom4te.cache

install: $(TARGET) installdirs
	$(INSTALL_PROGRAM) $(TARGET) ${DESTDIR}${BIN_DIR}/$(TARGET)
	$(INSTALL_DATA) atari800.man ${DESTDIR}${MAN_DIR}/atari800.1
# install also the documentation
	$(INSTALL_DATA) ../COPYING     ${DESTDIR}${DOC_DIR}/COPYING
	$(INSTALL_DATA) ../README.1ST  ${DESTDIR}${DOC_DIR}/README.1ST
	$(INSTALL_DATA) ../DOC/README  ${DESTDIR}${DOC_DIR}/README
	$(INSTALL_DATA) ../DOC/INSTALL ${DESTDIR}${DOC_DIR}/INSTALL
	$(INSTALL_DATA) ../DOC/USAGE   ${DESTDIR}${DOC_DIR}/USAGE
	$(INSTALL_DATA) ../DOC/NEWS    ${DESTDIR}${DOC_DIR}/NEWS

install-svgalib: install
	chown root.root ${DESTDIR}${BIN_DIR}/$(TARGET)
	chmod 4755 ${DESTDIR}${BIN_DIR}/$(TARGET)

readme.html: $(TARGET)
	./$(TARGET) -help </dev/null | ../util/usage2html.pl \
		../DOC/readme.html.in ../DOC/USAGE ./atari.h > $@

doc: readme.html

installdirs:
	mkdir -p $(DESTDIR)$(BIN_DIR) $(DESTDIR)$(MAN_DIR) $(DESTDIR)$(DOC_DIR)
