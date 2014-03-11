---------------------------------------------------------------------------------
--	Project: 	Useful Lua-Classes for X-Plane GIZMO
--	Developer:	Daniel Mandlez
--	Date:		2014
--	FileBlock:	Class Auto X-Tie
---------------------------------------------------------------------------------


-- This is just a simple connector


AutoXTie = {}

AutoXTie.new = function()

	local self = {}
	
	self.ON = false
	
	-- SET ON/OFF
	self.setON = function(val)
		if val == 1 or val == true then
			self.ON = true
		else
			self.ON = false
		end
	end

	-- GET ON, returns true if ON, used for BUS Logic
	self.getON = function()
		return self.ON
	end

	-- GET OFF, returns true if OFF, used for the Button Indication
	self.getOFF = function()
		return not self.ON
	end

	return self
end