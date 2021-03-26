package discord_rpc;

import cpp.Callable;
import cpp.Function;
import cpp.ConstCharStar;
import cpp.RawConstPointer;
import cpp.ConstPointer;

// PUBLIC FACING CLASS

class DiscordRpc
{
    /**
     *  Called once Discord has connected and is ready to start.
     */
    public static var onReady : Void->Void;

    /**
     *  Called when discord has disconnected the program.
     *  Int is the error code, String is the error message.
     */
    public static var onDisconnected : Int->String->Void;

    /**
     *  Called when an error occured.
     *  Int is the error code, String is the error message.
     */
    public static var onError : Int->String->Void;

    /**
     *  Called when the user has joined a game through discord.
     *  String is the join secret.
     */
    public static var onJoin : String->Void;

    /**
     *  Called when the user has spectated a game through discord.
     *  String is the spectate secret.
     */
    public static var onSpectate : String->Void;

    /**
     *  Called when the user has recieved a join request.
     *  JoinRequest contains the userID, username, and avatar of the user.
     */
    public static var onRequest : JoinRequest->Void;

    /**
     *  Attempts to connect to discord and initialize itself.
     *  @param _options - Anonymouse structure containin the start options.
     */
    public static function start(_options : DiscordStartOptions)
    {
        onReady        = _options.onReady;
        onDisconnected = _options.onDisconnected;
        onError        = _options.onError;
        onJoin         = _options.onJoin;
        onSpectate     = _options.onSpectate;
        onRequest      = _options.onRequest;
        DiscordRpcExterns.init(_options.clientID, _options.steamAppID);
    }

    /**
     *  Call this to process any callbacks.
     */
    public static function process()
    {
        DiscordRpcExterns.process();
    }

    /**
     *  Respond to a join request.
     *  @param _userID - The userID of the user who requested to join.
     *  @param _response - The reply to the request.
     */
    public static function respond(_userID : String, _response : Reply)
    {
        DiscordRpcExterns.respond(_userID, _response);
    }

    /**
     *  Set the rich presence for discord.
     *  @param _options - All of the rich presence options.
     */
    public static function presence(_options : DiscordPresenceOptions)
    {
        DiscordRpcExterns.setPresence(
            _options.state, _options.details,
            _options.startTimestamp, _options.endTimestamp,
            _options.largeImageKey, _options.largeImageText,
            _options.smallImageKey, _options.smallImageText,
            _options.partyID, _options.partySize, _options.partyMax,
            _options.matchSecret, _options.joinSecret, _options.spectateSecret,
            _options.instance);
    }

    /**
     *  Stops rich presence content from showing.
     */
    public static function shutdown()
    {
        DiscordRpcExterns.shutdown();
    }
}

// INTERNAL EXTERNS

@:keep
@:include('linc_discord_rpc.h')
#if !display
@:build(linc.Linc.touch())
@:build(linc.Linc.xml('discord_rpc'))
#end
private extern class DiscordRpcExterns
{
    @:native('linc::discord_rpc::init')
    private static function _init(_clientID : String, _steamAppID : String, _onReady : VoidCallback, _onDisconnected : ErrorCallback, _onError : ErrorCallback, _onJoin : SecretCallback, _onSpectate : SecretCallback, _onRequest : RequestCallback) : Void;
    static inline function init(_clientID : String, ?_steamAppID : String) : Void
    {
        _init(_clientID, _steamAppID,
            Function.fromStaticFunction(_onReady),
            Function.fromStaticFunction(_onDisconnected),
            Function.fromStaticFunction(_onError),
            Function.fromStaticFunction(_onJoin),
            Function.fromStaticFunction(_onSpectate),
            Function.fromStaticFunction(_onRequest));
    }

    @:native('linc::discord_rpc::process')
    static function process() : Void;

    @:native('linc::discord_rpc::respond')
    static function respond(_userID : String, _reply : Int) : Void;

    @:native('linc::discord_rpc::update_presence')
    static function setPresence(
        _state : String, _details : String,
        _startTimestamp : cpp.Int64, _endTimestamp : cpp.Int64,
        _largeImageKey : String, _largeImageText : String,
        _smallImageKey : String, _smallImageText : String,
        _partyID : String, _partySize : Int, _partyMax : Int,
        _matchSecret : String, _joinSecret : String, _spectateSecret : String,
        _instance : cpp.Int8
    ) : Void;

    @:native('linc::discord_rpc::shutdown')
    static function shutdown() : Void;

    private static inline function _onReady() : Void
        if (DiscordRpc.onReady != null) DiscordRpc.onReady();
    private static inline function _onDisconnected(_errorCode : Int, _message : ConstCharStar) : Void
        if (DiscordRpc.onDisconnected != null) DiscordRpc.onDisconnected(_errorCode, _message);
    private static inline function _onError(_errorCode : Int, _message : ConstCharStar) : Void
        if (DiscordRpc.onError != null) DiscordRpc.onError(_errorCode, _message);
    private static inline function _onJoin(_secret : ConstCharStar) : Void
        if (DiscordRpc.onJoin != null) DiscordRpc.onJoin(_secret);
    private static inline function _onSpectate(_secret : ConstCharStar) : Void
        if (DiscordRpc.onSpectate != null) DiscordRpc.onSpectate(_secret);
    private static inline function _onRequest(_data : RawConstPointer<JoinRequest>) : Void {
        var star : cpp.Star<JoinRequest> = cast _data;
        if (DiscordRpc.onRequest != null) DiscordRpc.onRequest(star);
    }
}

// TYPEDEFS AND STUFF

@:include('linc_discord_rpc.h')
@:native('DiscordJoinRequest')
@:structAccess
@:unreflective
extern class JoinRequest
{
    public var userId : String;
    public var username : String;
    public var discriminator : String;
    public var avatar : String;
}

typedef VoidCallback    = Callable<Void->Void>;
typedef ErrorCallback   = Callable<Int->ConstCharStar->Void>;
typedef SecretCallback  = Callable<ConstCharStar->Void>;
typedef RequestCallback = Callable<RawConstPointer<JoinRequest>->Void>;

typedef DiscordStartOptions = {
    var clientID : String;
    @:optional var steamAppID : String;
    @:optional var onReady        : Void->Void;
    @:optional var onDisconnected : Int->String->Void;
    @:optional var onError        : Int->String->Void;
    @:optional var onJoin         : String->Void;
    @:optional var onSpectate     : String->Void;
    @:optional var onRequest      : JoinRequest->Void;
}

typedef DiscordPresenceOptions = {
    @:optional var state   : String;
    @:optional var details : String;
    @:optional var startTimestamp : Int;
    @:optional var endTimestamp   : Int;
    @:optional var largeImageKey  : String;
    @:optional var largeImageText : String;
    @:optional var smallImageKey  : String;
    @:optional var smallImageText : String;
    @:optional var partyID   : String;
    @:optional var partySize : Int;
    @:optional var partyMax  : Int;
    @:optional var matchSecret    : String;
    @:optional var spectateSecret : String;
    @:optional var joinSecret     : String;
    @:optional var instance : Int;
}

@:enum abstract Reply(Int) from Int to Int {
    var No = 0;
    var Yes = 1;
    var ignore = 2;
}
