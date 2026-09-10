if (NOT BUILD_SHARED_LIBS_ffmpeg STREQUAL "<same>")
  set(ffmpeg_build_shared ${BUILD_SHARED_LIBS_ffmpeg})
else ()
  set(ffmpeg_build_shared ${BUILD_SHARED_LIBS})
endif ()

if (ffmpeg_build_shared)
  set(ffmpeg_shared_args --enable-shared --disable-static)
else ()
  set(ffmpeg_shared_args --disable-shared --enable-static)
endif ()

set(ffmpeg_c_flags "${superbuild_c_flags}")
set(ffmpeg_toolchain "")
if (WIN32)
  set(ffmpeg_cc "cl")
  set(ffmpeg_toolchain "--toolchain=msvc")
elseif (APPLE)
  set(ffmpeg_cc "clang")
else ()
  set(ffmpeg_cc "gcc")
endif ()
if (APPLE AND CMAKE_OSX_SYSROOT)
  string(APPEND ffmpeg_c_flags " --sysroot=${CMAKE_OSX_SYSROOT}")
endif ()
set(ffmpeg_ld_flags "${superbuild_ld_flags}")
if (APPLE AND CMAKE_OSX_DEPLOYMENT_TARGET)
  string(APPEND ffmpeg_ld_flags " -isysroot ${CMAKE_OSX_SYSROOT} -mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET}")
endif ()
if (UNIX AND NOT APPLE)
  string(APPEND ffmpeg_ld_flags " -Wl,-rpath,<INSTALL_DIR>/lib")
endif ()

superbuild_add_project(ffmpeg
  BUILD_SHARED_LIBS_INDEPENDENT
  DEPENDS pkgconf # openh264
  LICENSE_FILES
    LICENSE.md
    COPYING.LGPLv2.1
  SPDX_LICENSE_IDENTIFIER
    LGPL-2.1-or-later
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) the FFmpeg developers"
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --disable-all
      --disable-autodetect
      --disable-x86asm
      --enable-avcodec
      --enable-avutil
      # --enable-libopenh264
      # --enable-encoder=libopenh264
      --pkg-config=${superbuild_pkgconf}
      --cc=${ffmpeg_cc}
      ${ffmpeg_toolchain}
      ${ffmpeg_shared_args}
      --extra-cflags=${ffmpeg_c_flags}
      --extra-ldflags=${ffmpeg_ld_flags}
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install
  BUILD_IN_SOURCE 1)
