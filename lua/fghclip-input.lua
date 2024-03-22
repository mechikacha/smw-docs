while true do
	local infoposx = 0
	local infoposy = 0
	local space = 7

	-- Compatibility of the memory read/write functions
	local byte = bizstring.hex
	local u8 = mainmemory.read_u8
	local s8 = mainmemory.read_s8
	local w8 = mainmemory.write_u8
	local u16 = mainmemory.read_u16_le
	local s16 = mainmemory.read_s16_le
	local w16 = mainmemory.write_u16_le
	local u24 = mainmemory.read_u24_le
	local s24 = mainmemory.read_s24_le
	local w24 = mainmemory.write_u32_le

	local emuframe = emu.framecount()

	WRAM = {
		real_frame = 0x0013,
		eff_frame = 0x0014,
		gamemode = 0x0100,
		translevel = 0x13BF,

		itembox = 0x0DC2,

		playerXpos = 0x0094,
		playerYpos = 0x0096,
		playerXsub = 0x13DA,
		playerYsub = 0x13DC,

		pauseflag = 0x13d4,
	}

	-- general ram
	local real_frame = u8(WRAM.real_frame)
	local gamemode = u8(WRAM.gamemode)
	local translevel = u8(WRAM.translevel)

	-- position
	local playerXpos = s16(WRAM.playerXpos)
	local playerXsub = string.format("%03d", u8(WRAM.playerXsub))
	local playerYpos = s16(WRAM.playerYpos)
	local playerYsub = string.format("%03d", u8(WRAM.playerYsub))

	-- item box
	local itembox = u8(WRAM.itembox)

	-- pause flag
	local pauseflag = u8(WRAM.pauseflag)

	-- fghclip variables
	local AfterLastJump
	local setupReserveXpos = 397
	local setupPauseXpos = 551
	local jumpdelay = 49
	local pauseframe = 0
	local pausedelay = 80
	local jumpframe

	LASTJUMPXPOS = {
		455,
		454,
		453,
		452,
	}

	function FGHClipMain()
		if translevel == 64 then
			EmuStateCheck()
			FGHClipReserveItem()
	end

	
	function FGHClipReserveItem()
		if playerXpos == setupReserveXpos then
			joypad.set({ Right = true, X = 1, Select = 1 }, 1)
			-- set current "emuframe" to reserveframe 	
			reserveframe = emuframe
			console.writeline("ReserveItem: " .. reserveframe)
			jumpframe = emuframe + jumpdelay
		end
	end

	function fghinput()
		if unpauseflag == false then
			joypad.set({ Right = 1, X = 1 }, 1)

			if playerXpos == setupReserveXpos then
				reserveframe = emuframe -- get current emu.framecount
				console.writeline("reserveframe:" .. reserveframe)
				joypad.set({ Right = 1, X = 1, Select = 1 }, 1)
			end

			if reserveframe ~= nil then
				jumpframe = reserveframe + jumpdelay

				if emuframe == jumpframe then
					console.writeline("jumpdelay:" .. jumpdelay)
					console.writeline("jumpframe:" .. jumpframe)
					joypad.set({ Right = 1, X = 1, A = 1 }, 1)
				end
			end

			if playerXpos == setupPauseXpos then
				if pauseflag == 0 then
					pauseframe = emuframe
					unpauseframe = pauseframe + pausedelay
					joypad.set({ Right = 1, X = 1, Start = 1 }, 1)
					console.writeline("game is pausing.")
					console.writeline("pauseframe:" .. pauseframe)
					console.writeline("pausedelay:" .. pausedelay)
					console.writeline("unpauseframe:" .. unpauseframe)
				else
					if pauseframe >= 0 then
						if emuframe == unpauseframe then
							unpauseflag = 1
							joypad.set({ Left = 1, X = 1, Start = 1 }, 1)
						end
					end
				end
			end
		elseif playerXpos == 455 then
			lastjump = 1
			joypad.set({ Left = 1, X = 1, A = 1 }, 1)
		elseif playerXpos == 454 then
			lastjump = 1
			joypad.set({ Left = 1, X = 1, A = 1 }, 1)
		elseif playerXpos == 453 then
			lastjump = 1
			joypad.set({ Left = 1, X = 1, A = 1 }, 1)
		elseif playerXpos == 452 then
			lastjump = 1
			joypad.set({ Left = 1, X = 1, A = 1 }, 1)
		elseif lastjump == 1 then
			joypad.set({ Left = 1, X = 1, A = 1 }, 1)
		else
			joypad.set({ Left = 1, X = 1 }, 1)
		end
	end

	-- draw text
	gui.pixelText(0, 0 * space, "gamemode:" .. byte(gamemode))
	gui.pixelText(0, space, emu.framecount())
	gui.pixelText(0, 2 * space, emu.lagcount(), "red")
	gui.pixelText(0, 3 * space, "real_frame:" .. real_frame)
	gui.pixelText(infoposx, infoposy + 5 * space, "xpos:" .. playerXpos .. "." .. playerXsub)
	gui.pixelText(infoposx, infoposy + 6 * space, "ypos:" .. playerYpos .. "." .. playerYsub)
	gui.pixelText(infoposx, infoposy + 7 * space, "box:" .. itembox)
	--gui.pixelText(infoposx,infoposy + 9*space, "rboxframe:" .. reserveframe)
	--gui.pixelText(infoposx,infoposy + 10*space, "spinframe:" .. jumpframe)
	--gui.pixelText(infoposx,infoposy + 11*space, "spindelay:" .. jumpdelay)
	gui.pixelText(infoposx, infoposy + 13 * space, "reserveXpos:" .. pauseframe)
	gui.pixelText(infoposx, infoposy + 14 * space, "pauseXpos:" .. pausedelay)

	if translevel == 65 then
		joypad.set({ X = 1 }, 1)
		if gamemode == 20 then
			-- fghinput()
			FGHClipReserveItem()
		end
	else
		unpauseflag = 0
		lastjump = 0
	end

	emu.frameadvance()
end
