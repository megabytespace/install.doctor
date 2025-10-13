-- Defeat copy / paste blockers (Source: https://www.hammerspoon.org/go/)
hs.hotkey.bind({"cmd", "alt"}, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)
