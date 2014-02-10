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

Door.new = function(travelTime, initPos)	-- Constructor

	local self = {}

	self.lock = false						-- Interlock for set new position
	self.cmd_pos = initPos or 0.0			-- Initial Position Command
	self.act_pos = initPos or 0.0			-- Initial Position Actual
	
	self.TravelTime = travelTime			-- Time in seconds for Movement from 0.0 to 1.0
	
	self.opening = false					-- Travel open flag
	self.closing = false					-- Travel close flag
	
	
	-- Set Position Command
	self.set_cmdPos = function(pos, lock)
		self.lock = lock or false
		if lock == false then
			self.cmdPos = pos
		end
	end

	-- Movement: Has to be called at function MAIN to run EVERY FRAME
	-- ONLY call once per frame, to return the position at another Program point use .get_actPos()
	self.move = function(FPS, power)
		if power == true then	
			local temp_pos
			if math.floor(self.cmd_pos*10000) == math.floor(self.act_pos*10000) then
				self.opening = false
				self.closing = false
			elseif self.cmd_pos > self.act_pos then
				temp_pos = self.act_pos + 1/(FPS * self.TravelTime)
				self.opening = true
				self.closing = false
				if temp_pos > self.cmd_pos then
					self.act_pos = self.cmd_pos
				else
					self.act_pos = temp_pos
				end
			elseif self.cmd_pos < self.act_pos then
				temp_pos = self.act_pos - 1/(FPS * self.TravelTime)
				self.opening = false
				self.closing = true
				if temp_pos < self.cmd_pos then
					self.act_pos = self.cmd_pos
				else
					self.act_pos = temp_pos
				end
			end
		end
		return self.act_pos
	end
	
	-- Get Actual Position
	self.get_actPos = function()
		return self.act_pos
	end
	
	-- Get Traveling TRUE/FALSE
	self.get_traveling = function()
		return self.opening or self.closing 
	end
	
	-- Get opening TRUE/FALSE
	self.get_opening = function()
		return self.opening
	end
	
	-- Get closing TRUE/FALSE
	self.get_closing = function()
		return self.closing
	end
	
	return self
end
---------------------------------------------------------------------------------



-- HOW TO USE -------------------------------------------------------------------
---------------------------------------------------------------------------------

-- Create Objects
FwdLeft_Door = Door.new(5.0, 1.0)	-- Create Forward Left Door: 5.0 seconds travel time, Initial Position 1.0 (open) 
APU_Door = Door.new(10.0, 0.0)		-- Create APU Door:	10.0 seconds travel time, Initial Position 0.0 (close)

-- Create custom DataRef for Door animation
DR_Door_FwdL = dref.newFloat("yourairplane/Doors/FwdLeft")
DR_Door_APU = dref.newFloat("yourairplane/Doors/APU")

function main()

	FPS = gfx.getFPS()	-- Pickup FrameRate
	
	dref.setFloat(DR_Door_FwdL,  FwdLeft_Door.move(FPS, true) )	-- Moves Door if it is not in Command Position (frame rate, power) and write it to DataRef
	dref.setFloat(DR_Door_APU,  APU_Door.move(FPS, false)	   )	-- Moves Door if it is not in Command Position (frame rate, power) and write it to DataRef
									-- Power: If the Door is using electric, hydraulic or pneumatic power you can tell the function if it is avail
									-- true => door will move, false => door will not move 
	
	foo()	

end

function foo()

	FwdLeft_Door.set_cmdPos(0.0, false)		-- Set Command Position 0.0 for Forward Left Door
	APU_Door.set_cmdPos(1.0, false)			-- Set Command Position 1.0 for APU Door

	Status_APU_Door_Traveling = APU_Door.get_traveling()	-- get is traveling for Status Display or Panel Indication
	
end
---------------------------------------------------------------------------------
