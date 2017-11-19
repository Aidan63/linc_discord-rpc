# Haxe Discord RPC Native Externs

Haxe/hxcpp @:native bindings for [discord-rpc](https://github.com/discordapp/discord-rpc)

![example rpc](https://raw.githubusercontent.com/Aidan63/haxe-discord_rpc-externs/master/discord_rpc_example.png)

---
This library only works with the Haxe cpp target.

---

## Install
`haxelib git discord_rpc https://github.com/Aidan63/haxe-discord_rpc-externs`

### Windows
Ensure the dll found in the appropriate discord-rpc lib folder is placed in the same directory as the executable. Right now I'm having some issues getting the static linking to work on windows so the DLL is needed.

### Linux
No extra steps needed.

### OSX
I'm also having trouble getting static linking (or using the dylib) to work on OSX. I hope to have this working soon!

## Example Usage
See test/cli for a smalle program usage. Ensure discord is open and it has detected the Test application (you might need to manually add it) and you should see the rich presence in discord.

Remember to look at the [discord RPC docs](https://discordapp.com/developers/docs/topics/rich-presence) for all of the presence options at your disposal.