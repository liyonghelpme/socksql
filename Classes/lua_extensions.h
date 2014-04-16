#ifndef __LUA_EXT__
#define __LUA_EXT__

#if __cplusplus
extern "C" {
#endif
#include "lauxlib.h"
void luaopen_lua_extensions(lua_State *L);
#if __cplusplus
}
#endif

#endif
