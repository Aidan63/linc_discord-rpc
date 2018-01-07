#pragma once
#ifdef _WIN32
    #pragma comment(lib, "advapi32")
#endif

#include <hxcpp.h>
#include "../lib/discord-rpc/include/discord-rpc.h"

namespace linc
{
    namespace discord_rpc
    {
        extern void init(const char* _clientID, const char* _steamAppID,
            void (*_onReady)(),
            void (*_onDisconnected)(int errorCode, const char* message),
            void (*_onError)(int errorCode, const char* message),
            void (*_onJoin)(const char* joinSecret),
            void (*_onSpectate)(const char* spectateSecret),
            void (*_onRequest)(const DiscordJoinRequest* request));
        extern void process();
        extern void update_presence(
            const char* _state, const char* _details,
            int64_t _startTimestamp, int64_t _endTimestamp,
            const char* _largeImageKey, const char* _largeImageText,
            const char* _smallImageKey, const char* _smallImageText,
            const char* _partyID, int _partySize, int _partyMax, const char* _matchSecret, const char* _joinSecret, const char* _spectateSecret,
            int8_t _instance);
        extern void respond(const char* _userID, int _reply);
        extern void shutdown();
    }
}
