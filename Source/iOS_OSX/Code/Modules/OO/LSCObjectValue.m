//
//  LSCObjectValue.m
//  LuaScriptCore
//
//  Created by 冯鸿杰 on 16/10/19.
//  Copyright © 2016年 vimfung. All rights reserved.
//

#import "LSCObjectValue.h"
#import "LSCValue_Private.h"
#import "LSCContext_Private.h"
#import "LSCObjectClass_Private.h"
#import "lauxlib.h"

@implementation LSCObjectValue

- (void)pushWithContext:(LSCContext *)context
{
    lua_State *state = context.state;
    BOOL hasProcess = NO;
    if (self.valueType == LSCValueTypeObject)
    {
        id obj = [self toObject];
        if ([obj isKindOfClass:[LSCObjectClass class]])
        {
            void **ref = [LSCObjectClass _findLuaRef:obj];
            if (ref != NULL)
            {
                //直接原指针返回并不等于原始变量，因此需要重新绑定元表
                lua_pushlightuserdata(state, ref);
                luaL_getmetatable(state, [[obj class] moduleName].UTF8String);
                if (lua_istable(state, -1))
                {
                    lua_setmetatable(state, -2);
                }
            }
            else
            {
                lua_pushnil(state);
            }
            
            hasProcess = YES;
        }
    }
    
    if (!hasProcess)
    {
        [super pushWithContext:context];
    }
    
}

@end