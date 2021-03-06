dnl   configure.ac - Autoconf script for building configure
dnl
dnl   Copyright (C) 2001 Krzysztof Nikiel
dnl   Copyright (C) 2001-2003 Atari800 development team (see DOC/CREDITS)
dnl
dnl   This file is part of the Atari800 emulator project which emulates
dnl   the Atari 400, 800, 800XL, 130XE, and 5200 8-bit computers.
dnl
dnl   Atari800 is free software; you can redistribute it and/or modify
dnl   it under the terms of the GNU General Public License as published by
dnl   the Free Software Foundation; either version 2 of the License, or
dnl   (at your option) any later version.
dnl
dnl   Atari800 is distributed in the hope that it will be useful,
dnl   but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl   GNU General Public License for more details.
dnl
dnl   You should have received a copy of the GNU General Public License
dnl   along with Atari800; if not, write to the Free Software
dnl   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

AC_PREREQ(2.57)
AC_INIT(Atari800, 1.3.2, pstehlik@sophics.cz)
AC_CONFIG_SRCDIR(atari.c)
AC_CONFIG_HEADER(config.h)



dnl Set a8_target
case "$target" in
  basic | curses | ncurses | svgalib | dosvga | falcon | sdl | windx | x11)
        a8_target="$target"
        ;;
  shm | motif | xview | xview-shm)
        a8_target="x11-$target"
        ;;
  *)
        a8_target="UNKNOWN"
        ;;
esac
if [[ "$a8_target" == "UNKNOWN" ]]; then
    echo
    echo "Usage: configure --target=<target> <other options>"
    echo
    echo "The '--target' option is required.  Use '--help' to see other available"
    echo "options, including Atari800 specific '--enable' options.  Possible values"
    echo "for the '--target' option are:"
    echo "    basic"
    echo "    (n)curses"
    echo "    dosvga           (DOS only)"
    echo "    falcon           (Atari Falcon systems only)"
    echo "    svgalib          (Linux system with SVGALib library)"
    echo "    sdl              (System with Simple Direct Media Layer library)"
    echo "    windx            (Windows with DirectX only)"
    echo "    x11              (Standard X11)"
    echo "    (x11-)motif      (Motif on X11)"
    echo "    (x11-)shm        (Standard X11 with shared memory extensions)"
    echo "    (x11-)xview      (XView on X11)"
    echo "    (x11-)xview-shm  (XView on X11, with shared memory extensions)"
    echo
    exit 1;
fi

dnl Set a8_host
AC_CANONICAL_HOST
case $host_os in
  i386-pc-os2-emx)
        a8_host="os/2"
        ;;
  cygwin)
        a8_host="win"
        AC_DEFINE(BACK_SLASH,,[define to use back slash])
        AC_DEFINE(DOS_DRIVES,,[define to enable dos style drives support])
        if [[ "$a8_target" = "windx" ]]; then
                CC="gcc -mno-cygwin"
                echo
                echo "Using CC=\"$CC\" to disable cygwin library...";
                echo
        fi
        ;;
  mingw32)
        a8_host="win"
        AC_DEFINE(BACK_SLASH,,[define to use back slash])
        AC_DEFINE(DOS_DRIVES,,[define to enable dos style drives support])
        ;;
  msdosdjgpp)
        a8_host="dos"
        AC_DEFINE(BACK_SLASH,,[define to use back slash])
        AC_DEFINE(DEFAULT_CFG_NAME,"atari800.cfg",[alternate config filename due to 8+3 fs limit])
        AC_DEFINE(DOS_DRIVES,,[define to enable dos style drives support])
        AC_DEFINE(SYSTEM_WIDE_CFG_FILE,"c:\\atari800.cfg",[alternate system-wide config file for non-Unix OS])
        ;;
  linux | linux-gnu)
        a8_host="linux"
        ;;
  mint)
        a8_host="falcon"
        AC_DEFINE(BACK_SLASH,,[define to use back slash])
        AC_DEFINE(DEFAULT_CFG_NAME,"atari800.cfg",[alternate config filename due to 8+3 fs limit])
        AC_DEFINE(DOS_DRIVES,,[define to enable dos style drives support])
        AC_DEFINE(SYSTEM_WIDE_CFG_FILE,"c:\\atari800.cfg",[alternate system-wide config file for non-Unix OS])
        AC_DEFINE(USE_CLOCK,,[define to use clock() instead of gettimeofday()])
        ;;
  *unix*)
        a8_host="unix"
        ;;
  *)
        a8_host="$host_os"
        ;;
esac

dnl Set CFLAGS
if [[ "X_$CFLAGS" == "X_" ]]; then
    CFLAGS="-O2 -Wall"
fi

dnl Set LDFLAGS
if [[ "X_$LDFLAGS" == "X_" ]]; then
    LDFLAGS="-s"
fi



dnl Checks for programs.
AC_PROG_CC
AC_PROG_INSTALL



dnl Checks for header files.
AC_PATH_X
AC_HEADER_DIRENT
AC_HEADER_STDC
AC_CHECK_HEADERS([OS.h arpa/inet.h fcntl.h limits.h netdb.h netinet/in.h stdlib.h string.h strings.h sys/ioctl.h sys/socket.h sys/time.h unistd.h])



dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE
AC_TYPE_SIZE_T
AC_HEADER_TIME
AC_STRUCT_TM
AC_C_VOLATILE


dnl Checks for libraries.
if [[ "$a8_host" != "os2-emx" ]]; then
AC_CHECK_LIB(z,gzopen,,AC_MSG_ERROR("z compression library not found!"))
AC_DEFUN(A8_NEED_LIB,AC_CHECK_LIB($1,main,,AC_MSG_ERROR("$1 library not found!")))
fi

dnl set OBJS depending on target (and host)

dnl OBJS is not an AC "precious" variable but is used in the Makefile, so
dnl it must be explicitly AC_SUBST'ed at the end of this file.
OBJS=
if [[ "$a8_host" == "win" ]]; then
        A8_NEED_LIB(gdi32)
        A8_NEED_LIB(winmm)
        OBJS="win32/atari.ro"
else
if [[ "$a8_host" != "os2-emx" ]]; then
        A8_NEED_LIB(m)
        fi
fi
case "$a8_target" in
    basic)
        AC_DEFINE(BASIC,,[Text mode only])
        OBJS="atari_basic.o"
        ;;
    dosvga)
        if [[ "$a8_host" != "dos" ]]; then
            AC_MSG_ERROR("the dosvga target is only valid on a DOS system!")
        fi
        AC_DEFINE(DOSVGA,,[DOS vga])
        AC_DEFINE(SUPPORTS_ATARI_CONFIGURE,,[Additional config file options])
        OBJS="dos/atari_vga.o dos/vga_gfx.o dos/vga_asm.o"
        ;;
    curses)
        AC_DEFINE(USE_CURSES,,[System with Curses library])
        A8_NEED_LIB(curses)
        OBJS="atari_curses.o"
        ;;
    falcon)
        AC_DEFINE(FALCON,,[Atari Falcon system])
        A8_NEED_LIB(gem)
        OBJS="atari_falcon.o falcon/c2p_uni.o falcon/c2p_unid.o falcon/videl.o falcon/ikbd.o"
        ;;
    ncurses)
        AC_DEFINE(USE_NCURSES,,[System with Ncurses library])
        A8_NEED_LIB(ncurses)
        OBJS="atari_curses.o"
        ;;
    sdl)
        AC_DEFINE(SDL,,[System with SDL library])
        AC_DEFINE(SUPPORTS_ATARI_CONFIGURE,,[Additional config file options])
        AC_DEFINE(SUPPORTS_ATARI_CONFIGSAVE,,[Save additional config file options])
        sdlcheck="X_`sdl-config --cflags`"
        if [[ "$sdlcheck" != "X_" ]]; then
            CFLAGS="$CFLAGS `sdl-config --cflags`"
            LIBS="$LIBS `sdl-config --libs`"
            OBJS="atari_sdl.o"
        else
            AC_MSG_ERROR("No output from sdl-config!  Is sdl-config installed?")
        fi
        ;;
    svgalib)
        AC_DEFINE(SVGALIB,,[Linux with SVGALib])
        A8_NEED_LIB(vga)
        OBJS="atari_svgalib.o"
        ;;
    windx)
        AC_DEFINE(DIRECTX,,[Windows with DirectX])
        A8_NEED_LIB(ddraw)
        A8_NEED_LIB(dinput)
        A8_NEED_LIB(dsound)
        A8_NEED_LIB(dxguid)
        A8_NEED_LIB(ws2_32)
        OBJS="win32/atari_win32.o win32/screen.o win32/main.o win32/keyboard.o win32/atari.ro"
        ;;
    x11*)
        AC_PATH_X
        AC_DEFINE(X11,,[Standard X11])
        if [[ "X_$x_includes" != "X_" ]]; then
            CFLAGS="$CFLAGS -I$x_includes"
        fi
        if [[ "X_$x_libraries" != "X_" ]]; then
            LDFLAGS="$LDFLAGS -L$x_libraries"
        fi
        A8_NEED_LIB(X11)
        case "$a8_target" in
            *-shm)
                AC_DEFINE(SHM,,[X11 with shared memory extensions])
                A8_NEED_LIB(Xext)
                ;;
        esac
        case "$a8_target" in
            x11-xview*)
                AC_DEFINE(XVIEW,,[X11 with XView])
                A8_NEED_LIB(xview)
                A8_NEED_LIB(olgx)
                ;;
            x11-motif)
                AC_DEFINE(MOTIF,,[X11 with Motif])
                A8_NEED_LIB(Xm)
                A8_NEED_LIB(Xt)
                A8_NEED_LIB(gen)
                A8_NEED_LIB(socket)
                ;;
        esac
        OBJS="atari_x11.o"
        ;;
esac
dnl All future references to OBJS should ADD to it, not (re)define it.


dnl Checks for library functions.
AC_FUNC_CLOSEDIR_VOID
AC_PROG_GCC_TRADITIONAL
AC_FUNC_MALLOC
AC_FUNC_SELECT_ARGTYPES
AC_TYPE_SIGNAL
AC_FUNC_STAT
AC_FUNC_VPRINTF
AC_CHECK_FUNCS([atexit floor getcwd gethostbyaddr gethostbyname gettimeofday inet_ntoa memset mkdir modf rmdir select socket strcasecmp strchr strdup strerror strrchr strstr strtol mkstemp])



dnl Check for validity of unaligned long accesses.
AC_CACHE_CHECK([for unaligned long access validity], ac_cv_unaligned_long_ok,
[AC_TRY_RUN([
#include <stdlib.h>
#include <signal.h>
#include <setjmp.h>
jmp_buf jmpbuf;
void bus_err()
{
    longjmp(jmpbuf, 1);
}
int main(void)
{
#ifndef SIGBUS
    return 0;
#else
    long l[2];

    if (setjmp(jmpbuf) == 0) {
        signal(SIGBUS, bus_err);
        *((long *) ((char *) l + 1)) = 1;
        signal(SIGBUS, SIG_DFL);
        return 0;
    }else{
        signal(SIGBUS, SIG_DFL);
        return 1;
    }
#endif
}], ac_cv_unaligned_long_ok=yes, ac_cv_unaligned_long_ok=no, ac_cv_unaligned_long_ok=no)])
if [[ "$ac_cv_unaligned_long_ok" = "yes" ]]; then
    AC_DEFINE(UNALIGNED_LONG_OK,,[define if unaligned long access is ok])
fi



dnl Miscellaneous checks.
AC_CHECK_SIZEOF(long,4)
AC_C_BIGENDIAN



dnl ****************
dnl ATARI800 OPTIONS
dnl ****************

dnl The A8_OPTION macro automates the calling of AC_ARG_ENABLE, AC_HELP_STRING and AC_DEFINE.
dnl         $1    = the name of the feature, what follows "--enable-".
dnl         $2    = "yes" or "no", determines if feature defaults to being active or not.
dnl         $3    = The right side of the help line.
dnl                 The left side is always "--enable-$1".
dnl         $4    = The symbol name which goes to config.h, the C #define symbol.
dnl                 A symbol called "WANT_$4" is defined for use in this configure.ac.
dnl         $5    = The help string which shows up in config.h for the $3 symbol.
AC_DEFUN([A8_OPTION],[
    AC_ARG_ENABLE($1,AC_HELP_STRING(--enable-$1,$3),WANT_$4=$enableval,WANT_$4=$2)
    if [[ "$WANT_$4" = "yes" ]]; then
        AC_DEFINE($4,,$5)
    fi
])

A8_OPTION(crashmenu,yes,
          [Use a crash menu after a CIM instruction (default=ON)],
          CRASH_MENU,[define to activate crash menu after CIM instruction]
         )

A8_OPTION(monitorbreak,yes,
          [Allow the BREAK command in the monitor (slows CPU a bit) (default=ON)],
          MONITOR_BREAK,[define to activate BREAK command in monitor]
         )

A8_OPTION(monitorhints,yes,
          [Provide hints in the disassembler (human-readable address labels) (default=ON)],
          MONITOR_HINTS,[define to activate hints in disassembler]
         )

A8_OPTION(monitorasm,yes,
          [Provide an assembler in the monitor (default=ON)],
          MONITOR_ASSEMBLER,[define to activate assembler in monitor]
         )

A8_OPTION(cycleexact,yes,
          [Allow color changes inside a scanline (default=ON)],
          CYCLE_EXACT,[define to allow color changes inside a scanline]
         )

A8_OPTION(newcycleexact,yes,
          [Use the new cycle-exact scanline routines (default=ON)],
          NEW_CYCLE_EXACT,[define to allow new cycle-exact scanline routines]
         )

dnl sound support section
A8_OPTION(sound,yes,
          [Use sound support (default=ON)],
          SOUND,[define to activate sound support]
         )
if [[ "$WANT_SOUND" = "yes" ]]; then
    if [[ "$a8_target" != sdl ]]; then
        case "$a8_host" in
            dos)
                OBJS="$OBJS dos/sound_dos.o dos/dos_sb.o"
                ;;
            win)
                OBJS="$OBJS win32/sound.o"
                ;;
            falcon)
                OBJS="$OBJS sound_falcon.o falcon/sound_dma.o"
                ;;
            *)
                OBJS="$OBJS sound.o"
        esac
    fi

    A8_OPTION(interpolatesound,yes,
              [Use sound interpolation (default=ON)],
              INTERPOLATE_SOUND,[define to allow sound interpolation]
             )

    A8_OPTION(stereosound,yes,
              [Use stereo sound (default=ON)],
              STEREO_SOUND,[define to allow stereo sound]
             )

    A8_OPTION(volonlysound,yes,
              [Use volume only sound (digitized sound effects) (default=ON)],
              VOL_ONLY_SOUND,[define to allow stereo sound]
             )
    if [[ "$WANT_VOL_ONLY_SOUND" = "yes" ]]; then
        A8_OPTION(consolesound,yes,
                  [Use console sound (keyboard clicks) (default=ON)],
                  CONSOLE_SOUND,[define to allow console sound (keyboard clicks)]
                 )
        A8_OPTION(seriosound,no,
                  [Use serial in/out sound (default=OFF)],
                  SERIO_SOUND,[define to allow serial in/out sound]
                 )
    else
        WANT_CONSOLE_SOUND="no"
        WANT_SERIO_SOUND="no"
    fi

    A8_OPTION(clipsound,no,
              [Use sound clipping (default=OFF)],
              CLIP_SOUND,[define to allow sound clipping]
             )
else
    WANT_INTERPOLATE_SOUND="no"
    WANT_STEREO_SOUND="no"
    WANT_VOL_ONLY_SOUND="no"
    WANT_CONSOLE_SOUND="no"
    WANT_SERIO_SOUND="no"
    WANT_CLIP_SOUND="no"
fi

A8_OPTION(snailmeter,no,
          [Show how much the emulator is slower than the original (default=OFF)],
          SNAILMETER,[define to use snailmeter]
         )

A8_OPTION(pagedattrib,no,
          [Use page-based attribute array (default=OFF)],
          PAGED_ATTRIB,[define to use page-based attribute array]
         )

A8_OPTION(bufferedlog,no,
          [Use buffered debug output (until the graphics mode switches back to text mode) (default=OFF)],
          BUFFERED_LOG,[define to use buffered debug output]
         )

A8_OPTION(diskled,no,
          [Show disk LED emulation on screen display (default=OFF)],
          SHOW_DISK_LED,[define to show disk LED emulation on screen display]
         )
if [[ "$WANT_SHOW_DISK_LED" = "yes" ]]; then
    OBJS="$OBJS diskled.o"
fi

A8_OPTION(veryslow,no,
          [Use very slow computer support (disables generating screen completely) (default=OFF)],
          VERY_SLOW,[define to use very slow computer support]
         )

if [[ "$a8_host" = "falcon" -a "$a8_target" = "falcon" ]]; then
    A8_OPTION(falconcpuasm,no,
              [Use m68k assembler CPU core for Falcon target (default=OFF)],
              FALCON_CPUASM,[define to use m68k assembler CPU core for Falcon target]
             )
    if [[ "$WANT_FALCON_CPUASM" = "yes" ]]; then
        OBJS="$OBJS cpu_m68k.o"
    fi
fi

if [[ "$a8_host" = "linux" ]]; then
    case "$a8_target" in
        svgalib | x11*)
            A8_OPTION(linuxjoystick,no,
                      [Use LINUX joystick (linux svgalib/x11 targets only) (default=OFF)],
                      LINUX_JOYSTICK,[define to use LINUX joystick]
                      )
    esac
fi

if [[ "$a8_target" = "svgalib" ]]; then
    A8_OPTION(svgaspeedup,no,
              [Drawing every 1/50 sec only 1/refresh of screen (svgalib target only) (default=OFF)],
              SVGA_SPEEDUP,[define for drawing every 1/50 sec only 1/refresh of screen]
             )
    A8_OPTION(svgajoymouse,no,
              [Using Toshiba Joystick Mouse support (svgalib target only) (default=OFF)],
              SVGA_JOYMOUSE,[define to use Toshiba Joystick Mouse support]
             )
fi

if [[ "$a8_target" = "svgalib" -o "$a8_target" = "windx" ]]; then
    A8_OPTION(cursorblock,no,
              [Using cursor/ctrl keys for keyboard joystick (svgalib target only) (default=OFF)],
              USE_CURSORBLOCK,[define using cursor/ctrl keys for keyboard joystick]
             )
fi
if [[ "$a8_host" = "linux" -o "$a8_host" = "unix" ]]; then
    A8_OPTION(riodevice,yes,
              [Use the R: networking device (Linux/Unix only) (default=ON)],
              R_IO_DEVICE,[define to use R: device]
             )
    if [[ "$WANT_R_IO_DEVICE" = "yes" ]]; then
        OBJS="$OBJS rdevice.o"
    fi
fi



dnl Wrapup:  export OBJS and write Makefile
AC_SUBST(OBJS)
AC_CONFIG_FILES(Makefile)
AC_OUTPUT



dnl Print results of configure's work
echo "-------------------------------------------------------"
echo "                 CONFIGURATION RESULTS:"
echo "-------------------------------------------------------"
echo "Host OS...............................: $a8_host"
echo "Target ...............................: $a8_target"
echo
echo "Using the crash menu?.................: $WANT_CRASH_MENU"
echo "Using monitor breaks?.................: $WANT_MONITOR_BREAK"
echo "Using monitor hints?..................: $WANT_MONITOR_HINTS"
echo "Using the monitor assembler?..........: $WANT_MONITOR_ASSEMBLER"
echo "Using cycle exact?....................: $WANT_CYCLE_EXACT"
echo "Using the new cycle exact code?.......: $WANT_NEW_CYCLE_EXACT"
echo "Using sound?..........................: $WANT_SOUND"
if [[ "$WANT_SOUND" = "yes" ]]; then
    echo "    Using sound interpolation?........: $WANT_INTERPOLATE_SOUND"
    echo "    Using stereo sound?...............: $WANT_STEREO_SOUND"
    echo "    Using volume only sound?..........: $WANT_VOL_ONLY_SOUND"
    if [[ "$WANT_VOL_ONLY_SOUND" = "yes" ]]; then
        echo "        Using console sound?..........: $WANT_CONSOLE_SOUND"
        echo "        Using serial I/O sound?.......: $WANT_SERIO_SOUND"
    else
        echo "        (Volume only sound sub-options disabled)"
    fi
    echo "    Using sound clipping?.............: $WANT_CLIP_SOUND"
else
    echo "    (Sound sub-options disabled)"
fi
echo "Using the snailmeter?.................: $WANT_SNAILMETER"
echo "Using the paged attribute array?......: $WANT_PAGED_ATTRIB"
echo "Using the buffered log?...............: $WANT_BUFFERED_LOG"
echo "Using the disk LED emulation?.........: $WANT_SHOW_DISK_LED"
echo "Using the very slow computer support?.: $WANT_VERY_SLOW"
if [[ "$a8_target" = "falcon" ]]; then
    echo "Using M68K assembler CPU core?........: $WANT_FALCON_CPUASM"
fi
if [[ "$a8_host" = "linux" ]]; then
    case "$a8_target" in
        svgalib | x11*)
            echo "Using Linux joystick?.................: $WANT_LINUX_JOYSTICK"
    esac
fi
if [[ "$a8_target" = "svgalib" ]]; then
    echo "Using SVGA speedups?..................: $WANT_SVGA_SPEEDUP"
    echo "Using Toshiba Joystick mouse?.........: $WANT_SVGA_JOYMOUSE"
fi
if [[ "$a8_target" = "svgalib" -o "$a8_target" = "windx" ]]; then
    echo "Using cursor/ctrl keys?...............: $WANT_USE_CURSORBLOCK"
fi
if [[ "$a8_host" = "linux" -o "$a8_host" = "unix" ]]; then
    echo "Using R: device?......................: $WANT_R_IO_DEVICE"
fi

echo
echo "Main build variables:"
echo "    CC......: \"$CC\""
echo "    CFLAGS..: \"$CFLAGS\""
echo "    LDFLAGS.: \"$LDFLAGS\""
echo "    OBJS....: \"$OBJS\""
echo "    LIBS....: \"$LIBS\""
echo "-------------------------------------------------------"
echo
echo "Now run MAKE."
echo
