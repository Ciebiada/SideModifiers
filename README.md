# SideModifiers.spoon

Unfortunately Hammerspoon doesn't distinguish between left or right versions of modifier keys (<kbd>control</kbd>, <kbd>option</kbd>, <kbd>shift</kbd> and <kbd>command</kbd>)

This spoon "fixes" that. It monkey patches the `bind` function and let's you use modifiers with "left" and "right" prefixes.

## usage
- Make sure you load this spoon before binding keys
- use <kbd>left_shift</kbd>, <kbd>left_control</kbd>, <kbd>left_option</kbd>, <kbd>left_command</kbd> and <kbd>right_shift</kbd>, <kbd>right_control</kbd>, <kbd>right_option</kbd>, <kbd>right_command</kbd>

## example
```lua
hs.hotkey.bind({"left_option"}, "p", function()
  hs.reload()
end)
```
