---------------------------------------------------------------------------------
--	Project: 	Useful Lua-Classes for GIZMO X-Plane
--	Developer:	Daniel Mandlez 
--	Date:		2014
--	FileBlock:	Class Door
---------------------------------------------------------------------------------

-- If you don't like to use the custom sliders for doors
-- ==> make your own doors controlled by the frame rate


-- CLASS -- Door ----------------------------------------------------------------
---------------------------------------------------------------------------------

Door = {}									-- Creating Table for Class methods

Door.new = function(DataRef, travelTime, initPos)	-- Constructor (STRING, FLOAT, FLOAT)

	local self = {}
	
	self.DR_Door = DateRef					-- Pointer to DataRef
	
	self.lock = false						-- Interlock for set new position
	self.cmd_pos = initPos or 0.0			-- Initial Position Command
	self.act_pos = initPos or 0.0			-- Initial Position Actual
	
	dref.setFloat(DataRef, initPos)			-- Set DataRef to Initial Position
	
	self.TravelTime = travelTime			-- Time in seconds for Movement from 0.0 to 1.0
	
	self.opening = false					-- Travel open flag
	self.closing = false					-- Travel close flag
	
	
	-- Set Position Command
	self.set_cmdPos = function(pos, lock)	-- FLOAT, BOOL
		self.lock = lock or false
		if lock == false then
			self.cmdPos = pos
		end
	end

	-- Movement: Has to be called at function MAIN to run EVERY FRAME
	-- ONLY call once per frame!!!
	-- DataRef for Door animation will be written if position changes only
	self.move = function(FPS, power)
		if power == true then						-- check is power avail for door movement
			local temp_pos
			if math.floor(self.cmd_pos*10000) == math.floor(self.act_pos*10000) then
				self.opening = false
				self.closing = false
				
			elseif self.cmd_pos > self.act_pos then	-- move open
				temp_pos = self.act_pos + 1/(FPS * self.TravelTime)
				self.opening = true
				self.closing = false
				if temp_pos > self.cmd_pos then		-- Value overshooting check
					self.act_pos = self.cmd_pos
				else
					self.act_pos = temp_pos
				end
				dref.setFloat(DataRef, initPos)		-- Set Door Dataref to new Position
				
			elseif self.cmd_pos < self.act_pos then	-- move close
				temp_pos = self.act_pos - 1/(FPS * self.TravelTime)
				self.opening = false
				self.closing = true
				if temp_pos < self.cmd_pos then		-- Value overshooting check
					self.act_pos = self.cmd_pos
				else
					self.act_pos = temp_pos
				end
				dref.setFloat(DataRef, initPos)		-- Set Door Dataref to new Position
			end
		end
	end
	
	-- Get Command Position
	self.get_cmdPos = function() 		-- FLOAT
		return self.cmd_pos
	end
	
	-- Get Actual Position
	self.get_actPos = function() 		-- FLOAT
		return self.act_pos
	end
	
	-- Get Travel TRUE/FALSE
	self.get_traveling = function()		-- BOOL
		return self.opening or self.closing 
	end
	
	-- Get opening TRUE/FALSE
	self.get_opening = function()		-- BOOL
		return self.opening
	end
	
	-- Get closing TRUE/FALSE
	self.get_closing = function()		-- BOOL
		return self.closing
	end
	
	return self		-- returns all methods to object!!! 
end
---------------------------------------------------------------------------------



-- HOW TO USE -------------------------------------------------------------------
---------------------------------------------------------------------------------


-- Create custom DataRef for Door animation
DR_Door_FwdL = dref.newFloat("yourairplane/Doors/FwdLeft")
DR_Door_APU = dref.newFloat("yourairplane/Doors/APU")

-- Create Objects
FwdLeft_Door = Door.new(DR_Door_FwdL, 5.0, 1.0)	-- Create Forward Left Door: 5.0 seconds travel time, Initial Position 1.0 (open) 
APU_Door = Door.new(DR_Door_APU, 10.0, 0.0)		-- Create APU Door:	10.0 seconds travel time, Initial Position 0.0 (close)

-- OPTIONAL: you can create the DataRef direct on object create 
--[[
	FwdLeft_Door = Door.new(dref.newFloat("yourairplane/Doors/FwdLeft"), 5.0, 1.0)
	APU_Door = Door.new(dref.newFloat("yourairplane/Doors/APU"), 10.0, 0.0)
	-- The pointer to the DataRef is now NOT Global and is only available in the object!!
]]--

function main()

	FPS = gfx.getFPS()				-- Pick-Up FrameRate
	
	FwdLeft_Door.move(FPS, true) 	-- Moves Door if it is not in Command Position (frame rate, power) will actually move
	APU_Door.move(FPS, false)	   	-- Moves Door if it is not in Command Position (frame rate, power) will actually not move because no power
									-- Power: If the Door is using electric, hydraulic or pneumatic power you can tell the function if it is avail
									-- true => door will move, false => door will not move 
	foo()	

end

function foo()

	FwdLeft_Door.set_cmdPos(0.0, false)		-- Set Command Position 0.0 for Forward Left Door
	APU_Door.set_cmdPos(1.0, true)			-- Set Command Position 1.0 for APU Door ==> Value won't be taken because of interlock == true 

	Status_APU_Door_Traveling = APU_Door.get_traveling()	-- get travel Status(true/false) for Display or Panel Indication
	
end
---------------------------------------------------------------------------------
