<div align="center">
  <img src="https://user-images.githubusercontent.com/14226603/50402248-1828e200-0763-11e9-9b84-7e34f0bd8ef2.png">

  [![](https://github.com/mkargus/PartToTerrain/workflows/CI/badge.svg?event=push)](https://github.com/mkargus/PartToTerrain/actions)
  [![](https://img.shields.io/github/release/mkargus/PartToTerrain.svg?style=flat-square)](https://github.com/mkargus/PartToTerrain/releases)
  [![](https://img.shields.io/github/license/mkargus/PartToTerrain.svg?style=flat-square)](LICENSE.txt)
</div>

Part to Terrain is a Roblox plugin that allows users to convert parts into terrain.

## Tools used
The plugin uses some third-party tools while developing:
- [Roact](https://github.com/Roblox/Roact) - Declarative UI library inspired by Facebook's React
- [BasicState](https://github.com/csqrl/BasicState) - Key-value based state management library
- [Rojo](https://github.com/rojo-rbx/rojo) - Syncs scripts into Roblox Studio.
- [Selene](https://github.com/Kampfkarren/selene) - Syntax checking and linter
- [Wally](https://github.com/UpliftGames/wally) - Package manager for Roblox projects

## Building the plugin
1. Make sure you have installed Git, Wally, and Rojo in order to build the plugin.

2. Clone the repo:
```
git clone https://github.com/mkargus/PartToTerrain.git
```
3. Inside the project's root folder, you'll need to install the packages used for the plugin via Wally:
```
wally install
```

4. To compile the plugin without the test scripts, run Rojo with this command:
```
rojo build --output PartToTerrain.rbxmx
```

## Credits
* [TigerCaptain](https://roblox.com/users/19053090/profile) - Original concept
* [CloneTrooper1019](https://roblox.com/users/2032622/profile) - Helped with the original plugin
* [Valletta](https://twitter.com/valletta__) - Created the logo for this plugin
