
import discord_rpc.DiscordRpc;

class Test
{       
    static function main()
    {
        DiscordRpc.start({
            clientID : "378534231036395521",
            onReady  : onReady,
            onError  : onError,
            onDisconnected : onDisconnected
        });

        while (true)
        {
            DiscordRpc.process();
        }
    }

    static function onReady()
    {
        DiscordRpc.presence({
            state   : 'default',
            details : 'Test details',
            largeImageKey  : 'large_test', largeImageText : 'Large image text',
            smallImageKey  : 'small_test', smallImageText : 'Small image text',
            startTimestamp : cast Date.now().getTime(), endTimestamp : cast Date.now().getTime() + 200,
            matchSecret : 'matchSecret', joinSecret : 'joinSecret', spectateSecret : 'spectateSecret',
            partyID : 'fake_id', partySize : 1, partyMax : 5 
        });
    }

    static function onError(_code : Int, _message : String)
    {
        trace('Error! $_code : $_message');
    }

    static function onDisconnected(_code : Int, _message : String)
    {
        trace('Disconnected! $_code : $_message');
    }

    static function onRequest(_request : JoinRequest)
    {
        //trace('Join Request got', _request.userId, _request.username, _request.avatar);
    }
}
