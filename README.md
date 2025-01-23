# Fix for SDR Games while running in HDR mode

- Most content is using 2.2 Curve
- Windows uses SRGB instead, which causes raised black levels
- Windows Desktop rendered in HDR also seems too hazy/light

- Does not work well with AutoHDR, because it apparently uses a higher paperwhite value

- Optimized for windows SDR HDR setting of 30 (200 nits)

What does the script do?
- Try to track 2.2 curve
- Auto disable itself for HDR native games (static list, manually defined in hdr_games.json)

Alternative to this program is installing ReShade with lilium HDR shaders, and enable SDR TRC Fix, per game.

Convert to EXE with ahk2exe

HotKeys:

- shift+esc: 80 nits
- alt+shift 1, 2: 120, 200 nits (default)
- alt+delete: 480 nits
- alt+shift delete - turn off

Games
- b1 = black myth wukong; has no native HDR, but with some hacks it does (RenoDX: https://discord.com/channels/1161035767917850784/1280201526685470811/1280201528161861673)


Credits
- https://github.com/thqby/ahk2_lib/blob/master/JSON.ahk
- https://github.com/dylanraga/win11hdr-srgb-to-gamma2.2-icm
- https://github.com/dylanraga/win11hdr-srgb-to-gamma2.2-icm/issues/7
