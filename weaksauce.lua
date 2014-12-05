-- weaksauce is a metronome.

weaksauce = {
	name = "metronome", -- track name
	tempo = 124, 
	source = nil, -- audio source. this is a string. (ie "bgm/bgm01.ogg")
	nudge = 0,  -- time in seconds before the first beat of the track.
	bar = 1, -- 4/4 bar position. (ie whole step.)
	half = 1,
	quarter = 1,
	eighth = 1,

	-- tracks
	track = {
		sequence = "empty",
		sequencefile = "",
		paused = false
	}
}

function weaksauce:create() -- for inheritance. USE:  newvar = weaksauce:create()
	local  new_inst = {}
	setmetatable( new_inst, self )
	self.__index = self
	return new_inst
end

function weaksauce:load( name, tempo, source, nudge, track )
	self.name = name
	self.tempo = tempo
	self.source = love.audio.newSource(source)
	self.nudge = nudge
	self.track:load(track or "trk/default.csv")
end

function weaksauce:draw() -- should be placed last in love.draw()
	-- PRINT EDITOR MODE INTERFACE
	love.graphics.setColor(10, 10, 10, 220)
	love.graphics.rectangle("fill",0,0,1920, 320)
	love.graphics.setColor(10, 10, 10, 240)
	love.graphics.rectangle("fill",0,1030,1920, 50)
	love.graphics.setColor(252, 57, 57, 255)
	love.graphics.rectangle("fill",920, 70,920, 2)

	--print track info
	love.graphics.setColor( 105 , 205, 155 )
	love.graphics.printf(self.name, 10, 5, 100, "left", 0, 1, 1)
	love.graphics.print(self.timer or 0, 10, 20)
	love.graphics.printf("bar: " .. self.bar, 10, 40, 50, "left", 0, 1, 1)
	love.graphics.printf("1/2: " .. self.half, 10, 60, 50, "left", 0, 1, 1)
	love.graphics.printf("1/4: " .. self.quarter, 10, 80, 50, "left", 0, 1, 1)
	love.graphics.printf("1/8: " .. self.eighth, 10, 100, 100, "left", 0, 1, 1)
	love.graphics.printf("1/8c: " .. self.eighth_count, 10, 120, 100, "left", 0, 1, 1)

	-- print grid
	self.track:print((self.eighth_count_pres * 8)) -- x8 because 1/8th x 8 = 1 = 1 bar.
	-- print bottom text
	love.graphics.printf("Editor Mode", 10, 1050, 1910, "left" )

	love.graphics.setColor(255,255,255)
end


function weaksauce:update()
	self.timer = self.source:tell() - self.nudge --self.timer defined. (minus nudge for accuracy)

	-- Metronome
	self.eighth_count  = math.floor( self.timer / (self:tempoToMs(self.tempo)/2) + 1 )
	self.eighth_count_pres = ( self.timer / (self:tempoToMs(self.tempo)/2) + 1 ) --more precise eighth count
	if self.eighth_count % 8 == 0 then
		self.eighth = 8		
	else
		self.eighth  = self.eighth_count % 8
	end
	self.quarter = math.ceil(self.eighth / 2)
	self.half    = math.ceil(self.quarter / 2)
	self.bar     = math.ceil(self.eighth_count / 8)
	-- end.


	-- Edit Mode Commands
	if( love.keyboard.isDown("pause") ) then
		self:pause()
	end
	if( love.keyboard.isDown("0") ) then
		self:start()
	end
end


function weaksauce:start()
	self.source:play()
end

function weaksauce:pause()
	self.source:pause()
end

function weaksauce:tempoToMs( tempo ) -- converts tempo to ms (1/4 notes)
	return (60000 / tempo) * .001 
end



-- -- -- Weaksauce Tracks -- -- --


function weaksauce.track:load(sequencepath_)
	self.sequencefile = love.filesystem.newFile(sequencepath_)
	self.sequencefile:open("w")

	self.sequence = {}
	local c = 1

	for line in self.sequencefile:lines() do
		self.sequence[c] = {}
		self.sequence[c] = self:parseCSVLine(line)
		c = c + 1
	end

end

function weaksauce.track:print(position)
	for x, value in pairs(self.sequence[1]) do -- x and y are relative to the table position itself. not the cell.
			for y, values in pairs(self.sequence)  do
				draw_y = (100 + (35 * (y - 1))) - (position * 4.3755) -- FIX THIS SHIT
				if y == 1 then -- draw track title.
					love.graphics.printf( self.sequence[y][x] or "NO TITLE", 950 + (120 * (x - 1)), 5, 900, "left", 0, 1, 1)
		
				elseif draw_y < 280 and draw_y > 37 then
					if self.sequence[y][x] == "" then
						love.graphics.printf( "--", 952 + (120 * (x - 1)), draw_y, 900, "left", 0, 1, 1)
					else
						love.graphics.printf( self.sequence[y][x] or "--", 952 + (120 * (x - 1)), draw_y, 900, "left", 0, 1, 1)
					end
				end
			end
		end
end


function weaksauce.track:parseCSVLine(line, sep)
	local res = {}
	local pos = 1
	sep = sep or ',' 
	
	while true do
		local c = string.sub(line, pos, pos)
		
		if c == "" then break end -- "" is end of line
		
		if c == '"' then --quoted value
			local txt = ""
			
			repeat --preserves quotes within file line.
				local startp,
					  endp = string.find( line, '^%b""', pos )
				txt = txt .. string.sub( line, startp + 1, endp - 1 )
				pos = endp + 1
				c = string.sub( line, pos, pos )
				if c == '"' then txt = txt .. '"' end
			until c ~= '"'

			table.insert(res,txt)
			assert( c == sep or c == "" )
			pos = pos + 1
		else
			local startp, endp= string.find( line, sep, pos )
			if( startp ) then
				table.insert( res, string.sub(line, pos, startp - 1) )
				pos = endp + 1
			else
				table.insert( res, string.sub(line, pos) )
				break
			end
		end
	end

	return res
end

function weaksauce.track:updateCSVFile()
	-- parse array to csv format.
	for x, value in pairs(self.sequence[1]) do
		
	end

	-- save and load csv file
end