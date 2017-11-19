
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

        DiscordRpc.shutdown();
    }

    static function onReady()
    {
        DiscordRpc.presence({
            details : 'Haxe Discord RPC Test App',
            state   : 'DiscordRPC library accessable using hxcpp @:native externs',
            largeImageKey  : 'logo_haxe',
            largeImageText : 'Haxe'
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
}
