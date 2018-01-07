//hxcpp include should be first
#include <hxcpp.h>
#include "linc_discord_rpc.h"

namespace linc
{
    namespace discord_rpc
    {
        void init(const char* _clientID, const char* _steamAppID,
            void (*_onReady)(),
            void (*_onDisconnected)(int errorCode, const char* message),
            void (*_onError)(int errorCode, const char* message),
            void (*_onJoin)(const char* joinSecret),
            void (*_onSpectate)(const char* spectateSecret),
            void (*_onRequest)(const DiscordJoinRequest* request))
        {
            DiscordEventHandlers handlers;
            memset(&handlers, 0, sizeof(handlers));
            handlers.ready        = _onReady;
            handlers.errored      = _onError;
            handlers.disconnected = _onDisconnected;
            handlers.joinGame     = _onJoin;
            handlers.spectateGame = _onSpectate;
            handlers.joinRequest  = _onRequest;
            Discord_Initialize(_clientID, &handlers, 1, _steamAppID);
        }

        void process()
        {
            #ifdef DISCORD_DISABLE_IO_THREAD
                Discord_UpdateConnection();
            #endif
            Discord_RunCallbacks();
        }

        void update_presence(
            const char* _state, const char* _details,
            int64_t _startTimestamp, int64_t _endTimestamp,
            const char* _largeImageKey, const char* _largeImageText,
            const char* _smallImageKey, const char* _smallImageText,
            const char* _partyID, int _partySize, int _partyMax, const char* _matchSecret, const char* _joinSecret, const char* _spectateSecret,
            int8_t _instance)
        {
            DiscordRichPresence discordPresence;
            memset(&discordPresence, 0, sizeof(discordPresence));
            discordPresence.state   = _state;
            discordPresence.details = _details;
            discordPresence.startTimestamp = _startTimestamp;
            discordPresence.endTimestamp   = _endTimestamp;
            discordPresence.largeImageKey  = _largeImageKey;
            discordPresence.largeImageText = _largeImageText;
            discordPresence.smallImageKey  = _smallImageKey;
            discordPresence.smallImageText = _smallImageText;
            discordPresence.partyId   = _partyID;
            discordPresence.partySize = _partySize;
            discordPresence.partyMax  = _partyMax;
            discordPresence.matchSecret    = _matchSecret;
            discordPresence.joinSecret     = _joinSecret;
            discordPresence.spectateSecret = _spectateSecret;
            discordPresence.instance = _instance;
            Discord_UpdatePresence(&discordPresence);
        }

        void respond(const char* _userID, int _reply)
        {
            Discord_Respond(_userID, _reply);
        }

        void shutdown()
        {
            Discord_Shutdown();
        }
    }
}
