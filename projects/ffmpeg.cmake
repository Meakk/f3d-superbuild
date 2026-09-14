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

set(ffmpeg_extra_args "")
if (WIN32)
  set(ffmpeg_extra_args --cc=cl --toolchain=msvc)
elseif (APPLE)
  set(ffmpeg_extra_args --cc=clang --install-name-dir=@rpath)
endif ()

superbuild_add_project(ffmpeg
  BUILD_SHARED_LIBS_INDEPENDENT
  DEPENDS pkgconf openh264
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
      --enable-libopenh264
      --enable-encoder=libopenh264
      --pkg-config=${superbuild_pkgconf}
      ${ffmpeg_extra_args}
      ${ffmpeg_shared_args}
      --extra-cflags=${superbuild_c_flags}
      --extra-ldflags=${superbuild_ld_flags}
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install
  BUILD_IN_SOURCE 1)
