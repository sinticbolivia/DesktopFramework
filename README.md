# DesktopFramework
A vala framework to build desktop applications.

# Requirements

- gmodule-2.0
- mysqlclient or libmariadb
- sqlite3
- libpq
- gee-0.8
- gio-2.0
- posix
- libxml-2.0
- json-glib-1.0
- libsoup-3.0 or libsoup-2.4

# MACOS Environment variables

ICU_PATH=/usr/local/Cellar/icu4c/74.2/lib/pkgconfig
LIBPQ_PATH=/usr/local/Cellar/libpq/16.2_1/lib/pkgconfig
export PKG_CONFIG_PATH=$LIBPQ_PATH:$ICU_PATH

# Compilation for Make

make

# Compilation for Meson (recommended)

meson setup build --buildtype=release
cd build
meson compile


# Common issues

If you have issues compiling with mysqlclient library, maybe you need to create a symbolic link like this


```
cd vapi
ln -s /usr/local/share/vala-0.56/vapi/mysql.vapi mysqlclient.vapi
```
