EXECUTABLE = HelloLua
DEBUG = 1

COCOS_ROOT = ../../../..
INCLUDES =  -I../ -I../Classes -I$(COCOS_ROOT)/CocosDenshion/include \
    -I$(COCOS_ROOT)/scripting/lua/lua \
    -I$(COCOS_ROOT)/scripting/lua/tolua \
    -I$(COCOS_ROOT)/scripting/lua/cocos2dx_support \
    -I$(COCOS_ROOT)/extensions \

SOURCES = main.cpp ../Classes/AppDelegate.cpp\
			../Classes/cocos2d_ext_tolua.cpp\
			../Classes/platform/ComNative.cpp\
            ../Classes/socket/auxiliar.c\
            ../Classes/socket/except.c\
            ../Classes/socket/inet.c\
            ../Classes/socket/luasocket_buffer.c\
            ../Classes/socket/luasocket.c\
            ../Classes/socket/luasocket_io.c\
            ../Classes/socket/mime.c\
            ../Classes/socket/options.c\
            ../Classes/socket/select.c\
            ../Classes/socket/serial.c\
            ../Classes/socket/socket_scripts.c\
            ../Classes/socket/tcp.c\
            ../Classes/socket/timeout.c\
            ../Classes/socket/udp.c\
            ../Classes/socket/unix.c\
            ../Classes/socket/usocket.c\
            ../Classes/lua_extensions.c\
            ../Classes/lpack/lpack.c\
            ../Classes/sqlite3.c\
            ../Classes/lsqlite3/lsqlite3.c\




SHAREDLIBS += -lcocos2d -lcocosdenshion -llua -lextension
COCOS_LIBS = $(LIB_DIR)/libcocos2d.so $(LIB_DIR)/libcocosdenshion.so $(LIB_DIR)/liblua.so

include $(COCOS_ROOT)/cocos2dx/proj.linux/cocos2dx.mk

LIBS += -ldl

$(TARGET): $(OBJECTS) $(STATICLIBS) $(COCOS_LIBS) $(CORE_MAKEFILE_LIST)
	@mkdir -p $(@D)
	$(LOG_LINK)$(CXX) $(CXXFLAGS) $(OBJECTS) -o $@ $(SHAREDLIBS) $(STATICLIBS) $(LIBS)


$(OBJ_DIR)/%.o: ../%.c $(CORE_MAKEFILE_LIST)
	@mkdir -p $(@D)
	$(LOG_CXX)$(CC) $(CXXFLAGS) $(INCLUDES) $(DEFINES) $(VISIBILITY) -c $< -o $@

$(OBJ_DIR)/%.o: %.c $(CORE_MAKEFILE_LIST)
	@mkdir -p $(@D)
	$(LOG_CXX)$(CC) $(CXXFLAGS) $(INCLUDES) $(DEFINES) $(VISIBILITY) -c $< -o $@

$(OBJ_DIR)/%.o: ../%.cpp $(CORE_MAKEFILE_LIST)
	@mkdir -p $(@D)
	$(LOG_CXX)$(CXX) $(CXXFLAGS) $(INCLUDES) $(DEFINES) $(VISIBILITY) -c $< -o $@

$(OBJ_DIR)/%.o: %.cpp $(CORE_MAKEFILE_LIST)
	@mkdir -p $(@D)
	$(LOG_CXX)$(CXX) $(CXXFLAGS) $(INCLUDES) $(DEFINES) $(VISIBILITY) -c $< -o $@

