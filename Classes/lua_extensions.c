#include "lua_extensions.h"

#if __cplusplus
extern "C" {
#endif

#include "socket/luasocket.h"
#include "socket/mime.h"
#include "socket/socket_scripts.h"

#include "lpack/lpack.h"

#include "lsqlite3/lsqlite3.h"

static luaL_Reg luax_exts[] = {
    {"lsqlite3", luaopen_lsqlite3},
    {"pack", luaopen_pack},
    {"socket.core", luaopen_socket_core},
    {"mime.core", luaopen_mime_core},
    {NULL, NULL},
};

void luaopen_lua_extensions(lua_State *L) {
    luaL_Reg *lib = luax_exts;
    lua_getglobal(L, "package");
    lua_getfield(L, -1, "preload");
    for(; lib->func; lib++) {
        lua_pushcfunction(L, lib->func);
        lua_setfield(L, -2, lib->name);
    }
    lua_pop(L, 2);
    //luaopen_socket_scripts(L);
}

#if __cplusplus
}
#endif
