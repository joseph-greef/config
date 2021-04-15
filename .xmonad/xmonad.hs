import XMonad

import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns
import XMonad.Layout.HintedGrid
import XMonad.Layout.Mosaic
import XMonad.Util.EZConfig
import qualified XMonad.StackSet as W
import XMonad.Actions.GroupNavigation
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.SwapWorkspaces

-- Make multi float by default so all the little windows go above it and don't
-- screw with tiling. Downside: need to manually tile the first window
myManageHook = composeAll
    [ className =? "Multi" --> doFloat
    ]
    
-- some layouts I like
mylayoutHook = ThreeCol 2 (3/100) (1/4) ||| 
               tabbedBottom shrinkText def |||
               Tall 1 (3/100) (1/2) 
        
-- set up my customizations
main=do
    xmonad $ ewmh defaultConfig
        { 
            terminal    = "/home/jgreef/.cargo/bin/alacritty"
            , layoutHook = mylayoutHook
            , logHook = historyHook
            , manageHook = myManageHook 
            , modMask = mod1Mask
            , workspaces = myWorkspaces
            , borderWidth = 0
        } `additionalKeys` myAdditionalKeys

-- I never use the workspace names so 1-22 suffices for me
myWorkspaces = ["1","2","3","4","5","6","7","8","9"] ++ (map snd myExtraWorkspaces)
allWorkspaces = zip myWorkspaces ([xK_1 .. xK_9] ++ [xK_0] ++ [xK_F1 .. xK_F12])

myWorkspaceKeys = [xK_F1 .. xK_F12]
myExtraWorkspaces = [(xK_0, "10"),(xK_F1, "11"),(xK_F2, "12"),(xK_F3, "13"),(xK_F4, "14"),(xK_F5, "15"),(xK_F6, "16"),(xK_F7, "17"),(xK_F8, "18"),(xK_F9, "19"),(xK_F10, "20"),(xK_F11, "21"),(xK_F12, "22")]

-- set up changing to extra workspaces and moving windows to them
myAdditionalKeys = 
      [ -- ... some more keys ...
      ] ++ [
        ((mod1Mask, key), (windows $ W.greedyView ws))
        | (key,ws) <- myExtraWorkspaces
      ] ++ [
        ((mod1Mask .|. shiftMask, key), (windows $ W.shift ws))
        | (key,ws) <- myExtraWorkspaces
      ] ++ [
        ((mod1Mask .|. mod4Mask, k), windows $ swapWithCurrent i)
            | (i, k) <- allWorkspaces
      ]
