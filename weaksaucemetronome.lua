-- Weaksauce is a metronome.

weaksauce = {} -- Create Table

function weaksauce.load()
	-- Info
	weaksauce.name = "metronome"
	weaksauce.bpm = 0 -- set tempo
	weaksauce.nudge = 0 -- nudge before tempo count

	weaksauce.bar = 1
	weaksauce.half = 1
	weaksauce.quarter = 1
	weaksauce.eighth = 1
end

function weaksauce.draw()
	love.graphics.setColor( 105 , 205, 155 )
	love.graphics.printf( weaksauce.name, 20, 20, 20, "left" )
	love.graphics.printf( weaksauce.bar, 20, 40, 20, "left" )
	love.graphics.printf( weaksauce.half, 20, 60, 20, "left" )
	love.graphics.printf( weaksauce.quarter, 20, 80, 20, "left" )
	love.graphics.printf( weaksauce.eighth, 20, 100, 20, "left" )
	love.graphics.setColor( 255, 255, 255 )
	-- body
end

function weaksauce.update(timer)
	-- make a chage <3
end