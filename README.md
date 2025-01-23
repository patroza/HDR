# Fix for SDR Games while running in HDR mode

- Most content is using 2.2 Curve
- Windows uses SRGB instead, which causes raised black levels
- Windows Desktop rendered in HDR also seems too hazy/light

What does the script do?
- Try to track 2.2 curve
- Auto disable itself for HDR native games (static list, manually defined in hdr_games.json)

Alternative to this program is installing ReShade with lilium HDR shaders, and enable SDR TRC Fix, per game.

Games
- b1 = black myth wukong; has no native HDR, but with some hacks it does.
