
#ifndef __CC_EXTENSION_CCNATIVE_H_
#define __CC_EXTENSION_CCNATIVE_H_

#include "cocos2d_ext_const.h"
#include "cocos2d.h"
using namespace cocos2d;

void setScriptTouchPriority(CCLayer *lay, int pri);
std::string getFileData(const char *fname);
//只停止动作不要停止 更新
void pauseAction(CCNode *n);
void setTextureRect(CCSprite *, CCRect, bool, CCSize);
void enableShadow(CCLabelTTF *, CCSize , float, float, bool, int r, int g, int b);
void setFontFillColor(CCLabelTTF *, ccColor3B, bool);
#endif // __CC_EXTENSION_CCNATIVE_H_
