#ifndef __NET_H__
#define __NET_H__
class Net : public CCObject {
public:
    static Net *getInstance();
    void start();
    virtual void update(float dt);
};
#endif
