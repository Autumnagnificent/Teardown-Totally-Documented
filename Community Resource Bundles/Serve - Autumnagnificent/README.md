A utility to subsitute `require` in Teardown.
Make sure to place the `_` file at the root of the mod, this is the best way to guarantee that the mod id is found.
Used like:
```lua
Player = Serve_File 'script/player_controller.lua'
```