---------------------------------------------------------------------------------
--	Project: 	Useful Lua-Classes for X-Plane GIZMO
--	Developer:	Daniel Mandlez
--	Date:		2014
--	FileBlock:	Class Electric Battery
---------------------------------------------------------------------------------


-- This is just a rough Idea how a battery can work, and it's not finished!!
-- Take the Idea if you like, modify on your own choice!


Battery = {}

Battery.new = function(voltage, minvoltage, maxCap, initCap, maxamp, id)	-- nominal Voltage, minimum Voltage, Capacity, Capacity on XP start, max Amperes, Source ID
	
	local self = {}
	
	self.SourceID = id	-- Each Power Source should have another id, to know for the BUSes where they are actually connected
	
	self.nominalVoltage = voltage	-- [V]
	self.minVoltage = minvoltage	-- [V]
	self.maxCap = maxCap			-- [Ah]
	self.actCap = initCap			-- [Ah]
	self.maxAmp = maxamp			-- [A]
	self.actAmp = 0					-- [A]

	
	local Vdecr = 10
	-- Calculate initial voltage
	self.actVoltage = self.nominalVoltage * ( self.actCap / self.maxCap )^(1/Vdecr) 		-- [V]
	
	self.BatteryON = false
	
	-- Set Battery ON/OFF, if Battery is OFF, it is not possible to recive Power, but it is possible to charge! 
	self.setBatON = function(batON)
		if batON == true or batON == 1 then
			self.BatteryON = true
		else 
			self.BatteryON = false
		end
	end
	-- Get BatterON Status
	self.getBatON = function()
		return self.BatteryON
	end
	
	
	-- Charge Battery via Battery Charger; MUST RUN EVERY FRAME
	self.Charge = function(amp)
		if self.actCap < self.maxCap then
			-- increase actual Capacity if amps transfered from Battery Charger
			self.actCap = self.actCap + amp * 1/(3600 * FPS)	-- [Ah]
		end
	end
	
	
	-- Consume Cap and decrese actual Battery Capacity; MUST RUN EVERY FRAME
	self.setUsedAmps = function(amp)	--[A]
		self.actAmp = amp
		if self.actCap > 0 and self.BatteryON == true then
			-- Calculate Battery Voltage based on the actual Capacity
			self.actVoltage = self.nominalVoltage * ( self.actCap / self.maxCap )^(1/Vdecr) --[V]
			-- decrese Capacaty if you consume Power from the Battery
			self.actCap = self.actCap - amp * 1/(3600 * FPS)	-- [Ah]
			
			return self.Voltage
		else
			return 0.0	-- if Battery empty or OFF return 0 Volt
		end
	end
	
	
	-- Get actual Battery Voltage
	self.getVoltage = function()
		if self.BatteryON == true then
			return self.actVoltage		-- [V]
		else
			return 0
		end
	end
	
	-- Get Ratio of actual Amperes to max transferable Amperes
	self.getActLoad = function()
		return math.floor(self.actAmp/self.maxAmp * 100)
	end
	
	-- Get actual consumed Amps
	self.getActAmps = function()
		return self.actAmp
	end

	-- Get Source ID for BUSes to now where to pull the AMPs 
	self.getID = function()
		return self.SourceID
	end
	
	return self
end