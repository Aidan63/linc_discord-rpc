#pragma once

#include <hxcpp.h>
#include "../lib/discord-rpc/include/discord-rpc.h"

namespace linc
{
    namespace discord_rpc
    {
        typedef ::cpp::Function <void(void)> VoidCallback;
        typedef ::cpp::Function <void(int, const char*)> ErrorCallback;
        typedef ::cpp::Function <void(const char*)> SecretCallback;
        typedef ::cpp::Function <void(const DiscordJoinRequest*)> JoinRequestCallback;

        extern void init(const char* _clientID, const char* _steamAppID, VoidCallback, ErrorCallback, ErrorCallback, SecretCallback, SecretCallback, JoinRequestCallback);
        extern void process();
        extern void update_presence(const char*, const char*, int64_t, int64_t, const char*, const char*, const char*, const char*, const char*, int, int, const char*, const char*, const char*, int8_t);
        extern void respond(const char* _userID, int _reply);
        extern void shutdown();
    }
}
