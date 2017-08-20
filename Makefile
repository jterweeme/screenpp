#
# Makefile template for screen 
#
# See machine dependant config.h for more configuration options.
#

srcdir = .
VERSION = 4.6.1
SCREEN = screen-$(VERSION)
DEFS = -DHAVE_CONFIG_H -D_GNU_SOURCE
CC = g++
CPP=$(CC) -E
AWK = mawk
SHELL=/bin/sh

CFILES=	screen.c ansi.c fileio.c mark.c misc.c resize.c socket.c \
	search.c tty.c term.c window.c utmp.c loadav.c putenv.c help.c \
	termcap.c input.c attacher.c pty.c process.c display.c comm.c \
	kmapdef.c acls.c braille.c braille_tsi.c logfile.c layer.c \
	sched.c teln.c nethack.c encoding.c canvas.c layout.c viewport.c \
	list_display.c list_generic.c list_window.c
OFILES=	screen.o ansi.o fileio.o mark.o misc.o resize.o socket.o \
	search.o tty.o term.o window.o utmp.o loadav.o putenv.o help.o \
	termcap.o input.o attacher.o pty.o process.o display.o comm.o \
	kmapdef.o acls.o braille.o braille_tsi.o logfile.o layer.o \
	list_generic.o list_display.o list_window.o \
	sched.o teln.o nethack.o encoding.o canvas.o layout.o viewport.o

all: screen

clean:
	rm -vf *.o screen

rebuild: clean all

screen: $(OFILES)
	$(CC) -o $@ $(OFILES) -ltermcap -lcrypt

.c.o:
	$(CC) -O2 -c $(DEFS) $<
	
term.h: term.c term.sh
	AWK=$(AWK) srcdir=$(srcdir) sh $(srcdir)/term.sh

kmapdef.c: term.h

tty.c:	tty.sh 
	sh $(srcdir)/tty.sh tty.c

comm.h: comm.c comm.sh config.h
	AWK=$(AWK) CC="$(CC)" srcdir=${srcdir} sh $(srcdir)/comm.sh

osdef.h: osdef.sh config.h osdef.h.in
	CPP="$(CPP)" srcdir=${srcdir} sh $(srcdir)/osdef.sh

tags TAGS: $(CFILES)
	-ctags    *.sh $(CFILES) *.h
	-etags    *.sh $(CFILES) *.h

lint:
	lint -I. $(CFILES)

config:
	rm -f config.cache
	sh ./configure

.version:
	@rev=`sed < $(srcdir)/patchlevel.h -n -e '/#define REV/s/#define REV  *//p'`; \
	vers=`sed < $(srcdir)/patchlevel.h -n -e '/#define VERS/s/#define VERS  *//p'`; \
	pat=`sed < $(srcdir)/patchlevel.h -n -e '/#define PATCHLEVEL/s/#define PATCHLEVEL  *//p'`; \
	if [ "$${rev}.$${vers}.$${pat}" != "$(VERSION)" ]; then \
	echo "This distribution is screen-$${rev}.$${vers}.$${pat}, but"; \
	echo "the Makefile is from $(VERSION). Please update!"; exit 1; fi

screen.o: layout.h viewport.h canvas.h screen.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h braille.h patchlevel.h logfile.h extern.h
ansi.o: layout.h viewport.h canvas.h ansi.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h braille.h extern.h logfile.h
fileio.o: layout.h viewport.h canvas.h fileio.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
mark.o: layout.h viewport.h canvas.h mark.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h mark.h extern.h
misc.o: layout.h viewport.h canvas.h misc.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
resize.o: layout.h viewport.h canvas.h resize.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
socket.o: layout.h viewport.h canvas.h socket.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
search.o: layout.h viewport.h canvas.h search.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h mark.h extern.h
tty.o: layout.h viewport.h canvas.h tty.c config.h screen.h os.h osdef.h ansi.h acls.h comm.h \
 layer.h term.h image.h display.h window.h extern.h
term.o: layout.h viewport.h canvas.h term.c term.h
window.o: layout.h viewport.h canvas.h window.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h logfile.h
utmp.o: layout.h viewport.h canvas.h utmp.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
loadav.o: layout.h viewport.h canvas.h loadav.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
putenv.o: layout.h viewport.h canvas.h putenv.c config.h
help.o: layout.h viewport.h canvas.h help.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h list_generic.h
termcap.o: layout.h viewport.h canvas.h termcap.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
input.o: layout.h viewport.h canvas.h input.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
attacher.o: layout.h viewport.h canvas.h attacher.c config.h screen.h os.h osdef.h ansi.h \
 acls.h comm.h layer.h term.h image.h display.h window.h extern.h
pty.o: layout.h viewport.h canvas.h pty.c config.h screen.h os.h osdef.h ansi.h acls.h comm.h \
 layer.h term.h image.h display.h window.h extern.h
process.o: layout.h viewport.h canvas.h process.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h logfile.h
display.o: layout.h viewport.h canvas.h display.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h braille.h
canvas.o: layout.h viewport.h canvas.h canvas.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h braille.h
comm.o: layout.h viewport.h canvas.h comm.c config.h acls.h comm.h
kmapdef.o: layout.h viewport.h canvas.h kmapdef.c config.h
acls.o: layout.h viewport.h canvas.h acls.c config.h screen.h os.h osdef.h ansi.h acls.h comm.h \
 layer.h term.h image.h display.h window.h extern.h
braille.o: layout.h viewport.h canvas.h braille.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h braille.h
braille_tsi.o: layout.h viewport.h canvas.h braille_tsi.c config.h screen.h os.h osdef.h ansi.h \
 acls.h comm.h layer.h term.h image.h display.h window.h extern.h braille.h
logfile.o: layout.h viewport.h canvas.h logfile.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h logfile.h
layer.o: layout.h viewport.h canvas.h layer.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
sched.o: layout.h viewport.h canvas.h sched.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h logfile.h
teln.o: layout.h viewport.h canvas.h teln.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
nethack.o: layout.h viewport.h canvas.h nethack.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
encoding.o: layout.h viewport.h canvas.h encoding.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h
layout.o: layout.h viewport.h canvas.h layout.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h braille.h
viewport.o: layout.h viewport.h canvas.h viewport.c config.h screen.h os.h osdef.h ansi.h acls.h \
 comm.h layer.h term.h image.h display.h window.h extern.h braille.h
list_generic.o: list_generic.h list_generic.c layer.h screen.h osdef.h
list_display.o: list_generic.h list_display.c layer.h screen.h osdef.h
list_window.o: list_generic.h list_window.c window.h layer.h screen.h osdef.h comm.h

