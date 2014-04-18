#include "cocos2d.h"
#include "AppDelegate.h"
#include "SimpleAudioEngine.h"
#include "script_support/CCScriptSupport.h"
#include "CCLuaEngine.h"
#include "cocos2d_ext_tolua.h"

#include "lua_extensions.h"



USING_NS_CC;
using namespace CocosDenshion;
using namespace std;

AppDelegate::AppDelegate()
{
    // fixed me
    //_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF|_CRTDBG_LEAK_CHECK_DF);
}

AppDelegate::~AppDelegate()
{
    // end simple audio engine here, or it may crashed on win32
    SimpleAudioEngine::sharedEngine()->end();
    //CCScriptEngineManager::purgeSharedManager();
}
bool AppDelegate::applicationDidFinishLaunching()
{
    // initialize director
    CCDirector *pDirector = CCDirector::sharedDirector();
    pDirector->setOpenGLView(CCEGLView::sharedOpenGLView());
	CCSize winSize = pDirector->getVisibleSize();
	CCEGLView::sharedOpenGLView()->setDesignResolutionSize(winSize.width, winSize.height, kResolutionNoBorder);

    // turn on display FPS
    pDirector->setDisplayStats(false);

    // set FPS. the default value is 1.0/60 if you don't call this
    pDirector->setAnimationInterval(1.0 / 60);

    // register lua engine
    CCLuaEngine* pEngine = CCLuaEngine::defaultEngine();
    lua_State *state = pEngine->getLuaStack()->getLuaState();
    tolua_MyExt_open(state);
    luaopen_lua_extensions(state);
    //LuaScript 首先在cache 中寻找
    //接着在资源包里面寻找
	//pEngine->addSearchPath(CCFileUtils::sharedFileUtils()->getWritablePath().c_str());
    //文件没有在resource 根目录
    //pEngine->addSearchPath("LuaScript");

    CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);

    //根据config.ini 配置UserDefault 
	CCLog("hello wangguo");
    /*
	//searchPath 都在一个位置设置


    */
    const char *s = CCFileUtils::sharedFileUtils()->getWritablePath().c_str();
    CCLog("save Path is %s", s);
	CCFileUtils::sharedFileUtils()->addSearchPath(s);
    CCFileUtils::sharedFileUtils()->addSearchPath("LuaScript");
    CCFileUtils::sharedFileUtils()->addSearchPath("lualib");
    CCFileUtils::sharedFileUtils()->addSearchPath("res2");

    
	//UpdateScene 中更新脚本
    //if(def->getStringForKey("update") != "0")
	//    updateFiles();

    CCLog("finish update read main.lua");
    std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("main.lua");
    pEngine->executeScriptFile(path.c_str());
    return true;
}
//更新脚本
//更新图片

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    CCDirector::sharedDirector()->stopAnimation();
    SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    CCDirector::sharedDirector()->startAnimation();
    SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
}
