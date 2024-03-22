-- Sample script for Bizhawk

-- typedef
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


-- RAM address table
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

  PLAYER_XSPD     = 0x007B,
  PLAYER_YSPD     = 0x007D,
  PLAYER_PMETER   = 0x13E4,

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

  -- Change line height for font
  if FONT_PIXEL == "fceux" then
    LineHeight = 9
  else
    LineHeight = 7
  end

  function DrawPixelText(LineCount, string)
    gui.pixelText(InfoXpos, InfoYpos + (LineCount - 1) * LineHeight, string)
  end

  gui.defaultPixelFont(FONT_PIXEL)

  DrawPixelText(1, "TRUE_F:" .. u8(WRAM.TRUE_FRAME))
  DrawPixelText(2, "EFF_F:" .. u8(WRAM.EFFECTIVE_FRAME))
  DrawPixelText(3, "RAND:" .. u8(WRAM.RNG_OUTPUT))

  DrawPixelText(5, "SPD:" .. s8(WRAM.PLAYER_XSPD))
  DrawPixelText(6, "P-METER:" .. u8(WRAM.PLAYER_PMETER))
  DrawPixelText(8, "XPOS:" .. u16(WRAM.PLAYER_XPOS) .. "." .. byte(u8(WRAM.PLAYER_XSUB)))
  DrawPixelText(9, "YPOS:" .. u16(WRAM.PLAYER_YPOS) .. "." .. byte(u8(WRAM.PLAYER_YSUB)))
end

-- Main loop
while true do
  DisplayGameInfo()
  emu.frameadvance()
end
