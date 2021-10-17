<div align="center">
  <img src="https://user-images.githubusercontent.com/14226603/50402248-1828e200-0763-11e9-9b84-7e34f0bd8ef2.png">

  [![](https://github.com/mkargus/PartToTerrain/workflows/Lint/badge.svg?event=push)](https://github.com/mkargus/PartToTerrain/actions)
  [![](https://img.shields.io/github/release/mkargus/PartToTerrain.svg?style=flat-square)](https://github.com/mkargus/PartToTerrain/releases)
  [![](https://img.shields.io/github/license/mkargus/PartToTerrain.svg?style=flat-square)](LICENSE.txt)
</div>

Part to Terrain is a Roblox plugin that allows users to convert parts into terrain.

## Tools used
The plugin uses some third-party tools while developing:
- [Roact](https://github.com/Roblox/Roact) - Declarative UI library inspired by Facebook's React
- [BasicState](https://github.com/ClockworkSquirrel/BasicState) - Key-value based state management library
- [Rojo](https://github.com/rojo-rbx/rojo) (0.6.x+) - Syncs scripts into Roblox Studio.
- [Selene](https://github.com/Kampfkarren/selene) - Syntax checking and linter

## Building the plugin
This plugin is built using [Rojo](https://rojo.space/docs/0.5.x/guide/installation).

Clone the repo:
```
git clone https://github.com/mkargus/PartToTerrain.git <ProjectName>
```

**If you're using the VSCode extension:**

Click on `Start Rojo` on the lower right to start the server.

or

Open the command panel (`Ctrl+Shift+P`) and run `Rojo: Start Server`.

**If you're not using the VScode extension:**

Go to the root directory of the repo
```
cd <ProjectName>
```

To start Rojo:
```
rojo serve
```

## Credits
* [TigerCaptain](https://roblox.com/users/19053090/profile) - Original concept
* [CloneTrooper1019](https://roblox.com/users/2032622/profile) - Original function to draw terrain for wedges
* [Valletta](https://twitter.com/valletta__) - Created the logo for this plugin
