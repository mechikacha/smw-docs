-- Sample script for Bizhawk.

byte = bizstring.hex
u8 = mainmemory.read_u8
s8 = mainmemory.read_s8
w8 = mainmemory.write_u8
u16 = mainmemory.read_u16_le
s16 = mainmemory.read_s16_le
w16 = mainmemory.write_u16_le
u24 = mainmemory.read_u24_le
s24 = mainmemory.read_s24_le
w24 = mainmemory.write_u32_le

WRAM = {
  TRUE_FRAME      = 0x0013,
  EFFECTIVE_FRAME = 0x0014,
  GAMEMODE        = 0x0100,
  TRANSLEVEL      = 0x13BF,

  ITEMBOX         = 0x0DC2,

  PLAYER_XPOS     = 0x0094,
  PLAYER_YPOS     = 0x0096,
  PLAYER_XSUB     = 0x13DA,
  PLAYER_YSUB     = 0x13DC,

  PLAYER_SPDX     = 0x007B,

  PAUSEFLAG       = 0x13D4,
  RNG_OUTPUT      = 0x148D,
}

-- Draw information on screen
function DisplayGameInfo()
  -- GUI Settings
  local FONT_PIXEL = "gens"
  local InfoXpos   = 0
  local InfoYpos   = 10
  local LineHeight
  local LineCount

  -- Change line height for font
  if FONT_PIXEL == "fceux" then
    LineHeight = 9
  else
    LineHeight = 7
  end

  gui.defaultPixelFont(FONT_PIXEL)
  -- Draw Text
  gui.pixelText(InfoXpos, InfoYpos + 0 * LineHeight, "RNG:" .. byte(u8(WRAM.RNG_OUTPUT)) .. byte(u8(WRAM.RNG_OUTPUT + 1)))
  gui.pixelText(InfoXpos, InfoYpos + 1 * LineHeight,
    "PlayerX:" .. u8(WRAM.PLAYER_XPOS) .. "." .. byte(u8(WRAM.PLAYER_XSUB)))
  gui.pixelText(InfoXpos, InfoYpos + 2 * LineHeight,
    "PlayerY:" .. u8(WRAM.PLAYER_YPOS) .. "." .. byte(u8(WRAM.PLAYER_YSUB)))
  gui.pixelText(InfoXpos, InfoYpos + 3 * LineHeight, "TRUEFRAME:" .. u8(WRAM.TRUE_FRAME))
  gui.pixelText(InfoXpos, InfoYpos + 4 * LineHeight, "EFFECTIVE:" .. u8(WRAM.EFFECTIVE_FRAME))
  -- gui.pixelText(InfoXpos, InfoYpos + 5 * LineHeight)
  gui.pixelText(InfoXpos, InfoYpos + 6 * LineHeight, "Speed:" .. s8(WRAM.PLAYER_SPDX))
end

-- Main loop
while true do
  DisplayGameInfo()
  emu.frameadvance()
end
