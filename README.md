# Basic text RP script for FiveM

Visibility distances can be set in the **shared.lua** file.

### Screenshots

[![](https://i.imgur.com/2Gk1BNF.png)](https://i.imgur.com/2Gk1BNF.png)
[![](https://i.imgur.com/08mfFEN.png)](https://i.imgur.com/08mfFEN.png)

### Dependencies

- ESX Legacy

### Commands:

_Plain writing appears in the chat as speech._

OOC toggle key: B _can be adjusted in the game settings_

- /s [msg] -- Shout player
- /c [msg] -- Whisper player
- /me [msg] -- Visible actions
- /do [msg] -- Invisible actions, events

### Exports

##### Server Side

```lua
sendLocalMeMessage(player, message)
```

```lua
sendLocalDoAction(player, message)
```
