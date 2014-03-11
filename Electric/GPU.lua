---------------------------------------------------------------------------------
--	Project: 	Useful Lua-Classes for X-Plane GIZMO
--	Developer:	Daniel Mandlez
--	Date:		2014
--	FileBlock:	Class GPU
---------------------------------------------------------------------------------


-- This is just a rough Idea how a GPU can work, and it's not finished!!
-- Take the Idea if you like, modify on your own choice!

-- This Object should only used once, otherwise you need to delete the DataRef!


GPU = {}

GPU.new = function(acvolt, freq, dcvolt, id)

	local self = {}
	
	self.SourceID = id	-- Each Power Source should have another id, to know for the BUSes where they are actually connected
	
	self.ON = false
	self.ACVolt = acvolt
	self.DCVolt = dcvolt
	self.Freq = freq
	self.Connected = false
	
		
	DR_GPU = dref.getDataRef("sim/cockpit/electrical/gpu_on")
	
	
	-- External Part of the GPU
	-- Let Grund Crew connect the GPU
	self.Connect = function(val)
		if val == 1 or val == true then
			self.Connected = true
			dref.setInt(DR_GPU, 1)
		else
			self.Connected = false
			dref.setInt(DR_GPU, 0)
		end 
	end
	
	
	
	-- Plane Internal Part
	-- Connect the GPU with Push Button to you External Power BUS
	self.setON = function(val)
		if val == 1 or val == true then
			self.ON = true
		else
			self.ON = false
		end
	end

	-- GET ON, true if ON
	self.getON = function()
		return self.ON
	end

	-- GET OFF, true if OFF, for Button Indication
	self.getOFF = function()
		return not self.ON
	end
	
	-- GET AVAIL, true if connected to the plane, do not mean that is already used
	self.getAvail = function()
		return self.Connected
	end
	
	-- GET AVAIL, for Button Indication is true if connected, but changes to false if you set it to ON by Pushbutton 
	self.getAvailIndication = function()
		if self.Connected == true and self.ON == false then
			return true
		else
			return false
		end
	end	
	
	
	self.getACVoltage = function()
		if self.Connected == true and self.ON == true then
			return self.ACVolt
		else
			return 0.0
		end
	end
	
	self.getDCVoltage = function()
		if self.Connected == true and self.ON == true then
			return self.DCVolt
		else
			return 0.0
		end
	end
	
	self.getFreq = function()
		if self.Connected == true and self.ON == true then
			return self.Freq
		else
			return 0.0
		end
	end
	
	self.getConnectionACVoltage = function()
		if self.Connected == true then
			return self.ACVolt
		else
			return 0.0
		end
	end
	
	self.getConnectionDCVoltage = function()
		if self.Connected == true then
			return self.DCVolt
		else
			return 0.0
		end
	end
	
	self.getConnectionFreq = function()
		if self.Connected == true then
			return self.Freq
		else
			return 0.0
		end
	end
	
	-- Get Source ID for BUSes to now where to pull the AMPs 	
	self.getID = function()
		return self.SourceID
	end
		
	return self
end