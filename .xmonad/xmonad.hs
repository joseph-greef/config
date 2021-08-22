import XMonad

import XMonad.Actions.GroupNavigation
import XMonad.Actions.SpawnOn
import XMonad.Actions.SwapWorkspaces
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders
import XMonad.Layout.ThreeColumns
import XMonad.Util.EZConfig

import qualified XMonad.StackSet as W

myTerminal = "/home/llamanaru/.cargo/bin/alacritty"

myLayoutHook = ThreeCol 2 (3/100) (1/4) |||
               tabbedBottom shrinkText def |||
               Tall 1 (3/100) (1/2)

myStartupHook = do
    spawnOn "1" myTerminal
    spawnOn "1" myTerminal
    spawnOn "1" myTerminal
    spawnOn "1" myTerminal
    spawnOn "6:chromium" "chromium"
    spawnOn "9:pavu" "pavucontrol"
    spawnOn "3:firefox" "firefox"
    spawnOn "3:firefox" "gnome-terminal -e title_clock"

myExtraWorkspaces = ["10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22"]
myExtraWorkspaceKeys = [xK_0] ++ [xK_F1 .. xK_F12]

myWorkspaces = ["1","2","3:firefox","4","5","6:chromium","7:steam","8:discord","9:pavu"] ++ myExtraWorkspaces
myWorkspaceKeys = [xK_1 .. xK_9]

myAdditionalKeys =
    [
        ((mod1Mask, key), (windows $ W.greedyView ws))
        | (key,ws) <- (zip myExtraWorkspaceKeys myExtraWorkspaces)
    ] ++ [
        ((mod1Mask .|. shiftMask, key), (windows $ W.shift ws))
        | (key,ws) <- (zip myExtraWorkspaceKeys myExtraWorkspaces)
    ] ++ [
        ((mod1Mask .|. mod4Mask, key), windows $ swapWithCurrent ws)
        | (key, ws) <- (zip (myWorkspaceKeys ++ myExtraWorkspaceKeys) (myWorkspaces ++ myExtraWorkspaces))
    ]

main=do
    xmonad $ ewmh defaultConfig
        {
            borderWidth = 0
            , layoutHook = myLayoutHook
            , logHook = historyHook
            , manageHook = manageSpawn <+> manageHook def
            , modMask = mod1Mask
            , startupHook = myStartupHook
            , terminal    = myTerminal
            , workspaces = myWorkspaces
        } `additionalKeys` myAdditionalKeys

