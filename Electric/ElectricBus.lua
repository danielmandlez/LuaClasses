---------------------------------------------------------------------------------
--	Project: 	Useful Lua-Classes for X-Plane GIZMO
--	Developer:	Daniel Mandlez
--	Date:		2014
--	FileBlock:	Class Electric BUS
---------------------------------------------------------------------------------


-- This is just a rough Idea how a electric BUS can work, and it's not finished!!
-- Take the Idea if you like, modify on your own choice!


ElectricBus = {}

ElectricBus.new = function(voltage, freq, maxamp, id)	-- Nominal Voltage, nominal Frequency, maximal transferable Current, BUS ID

	local self = {}

	self.BusID = id	-- Each BUS should have another id, to know for the BUSes where they are actually connected
	

	self.nominalVoltage = voltage	-- [V]
	self.actVoltage = 0				-- [V]
	self.maxAmp = maxamp			-- [A]
	self.actAmp = 0					-- [A]
	
	self.nominalFreq = freq			-- [Hz]
	self.actFreq = 0				-- [Hz]
	
	self.SourceID = 0	-- This ID references to the Battery or TRU or Generator where it is connected
	
	-- Set Bus Voltage from Electrical Source
	self.setVoltage = function(volt, id)
		self.actVoltage = volt
		self.SourceID = id	-- ID to Address the Source where to pull the current
	end
	
	-- Get actual Bus Voltage for Consumer information
	self.getVoltage = function()
		return self.actVoltage
	end 
	
	-- Set Amperes are used by all Consumers 
	self.setUsedAmps = function(amp)
		self.actAmp = amp or 0.0
	end
	self.getActAmps = function()
		return self.actAmp
	end
	
	
	-- Send actual used Amps to Electrical Source
	self.Consume = function()
		return self.actAmp
	end
	
	
	-- Set actual Bus Frequency
	self.setFreq = function(freq)
		self.actFreq = freq
	end
	
	-- Get actual Bus Frequency
	self.getFreq = function(freq)
		return self.actFreq
	end
	
	-- GET Source ID, to know where the BUS is actualy Connected, for example: Battery or TRU 
	self.getSourceID = function()
		return self.SourceID
	end
	
	-- GET BUS ID, you can use that if one consumer is possible to connect on more buses to know where the consumer is actualy connected
	self.getBusID = function()
		return self.BusID
	end
	
	return self
end