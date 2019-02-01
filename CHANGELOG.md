# Changelog

## 1.1.0 (dev)
* Added the ability to disable or enable the SelectionBox overlay when hovering over a part.
* Material and Setting tab frame will no longer show the scrollbar if all the items are already shown without needing to scroll.
* Fixed a bug when plugins get reloaded, Part to terrain would stay active and made a second SelectionBox.
* Various changes on update checker & notice:
  * Checker: In case Roblox servers go down, the plugin will no longer throw an HTTP error.
  * Made the font size slightly smaller.
  * Now shows what version is the latest.
* Various changes on Settings tab:
  * Added a description for each setting item when hovered over.
  * Smaller list layout padding (3px -> 1px)
  * Changed color style

## 1.0.0 - January 10, 2019  (current)
*This is being compared to the last update (3.1) on Part to Terrain Classic.*
* Now the plugin uses ModuleScripts rather than one whole script to do everything. 
* Completely redesigned UI to use Studio widgets rather than ScreenGuis.
* UI has a Light and Dark mode based off of Studio's current selected theme.
* Added a "Check for updates" setting.
  * If checked, it will show a note on the top of the UI alerting you of an update if the plugin is not update to date.
  * If unchecked, it will show nothing when out of date.
* All settings will now be saved and will use the same value when relaunching Studio.
* Selection Box will now glow green or red depending if it is able to be converted the part selected or not.
