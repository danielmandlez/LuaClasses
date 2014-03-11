---------------------------------------------------------------------------------
--	Project: 	Useful Lua-Classes for X-Plane GIZMO
--	Developer:	Daniel Mandlez
--	Date:		2014
--	FileBlock:	Class Electric Transformer Rectifier Unit (TRU) AC/DC
---------------------------------------------------------------------------------


-- This is just a rough Idea how a TRU can work, and it's not finished!!
-- Take the Idea if you like, modify on your own choice!

-- Many Planes have AC Generators. You need to produce DC Power and this happen with TRUs


TRU = {}

TRU.new = function(ACvolt, DCvolt, freq, ACmaxamp, DCmaxamp, id)	-- nominal AC Voltage, nominal DC Voltage, nominal Frequency, max AC Amperes, max DC Amperes, Source ID

	local self = {}
	
	self.SurceID = id	-- Each Power Source should have another id, to know for the BUSes where they are actually connected
	
	-- AC
	self.ACnominalVolt = ACvolt
	self.ACactVolt = 0
	self.minVoltage = 70	-- is temporary set fix here
	self.ACmaxAmp = ACmaxamp
	self.ACactAmp = 0
	self.nominalFreq = freq
	self.actFreq = 0
	
	-- DC
	self.DCnominalVolt = DCvolt
	self.DCactVolt = 0
	self.DCmaxAmp = DCmaxamp
	self.DCactAmp = 0

	
	self.ON = false
	
	
	-- Set actual Input from connected AC Bus
	self.setAC = function (volt, freq)
		self.ACactVolt = volt
		self.ACactFreq = freq
	end
	
	-- Send actual used Amps to Electrical Source -- MUST BE AC-BUS!!
	self.Consume = function()
		
		if self.ACactVolt > 0.0 then	-- Check against DIV by 0
			-- Rough Transforming ratio without any reductions
			self.ACactAmp = self.DCactAmp * self.DCactVolt / self.ACactVolt
		end
		return self.ACactAmp
	end
	
	-- Same as Consume, you can use to have same Methode names for example on the indication Display
	self.getActAmps = function()
		return self.ACactAmp
	end
	
	-- Set Amperes are used by all Consumers -- MUST BE DC-BUS
	self.setUsedAmps = function(amp)
		self.DCactAmp = amp
	end
	
	-- Get actual TRU Voltage
	self.getDCVoltage = function()
		local volt
		
		if self.ON == true and self.ACactVolt > self.minVoltage then
			-- Rough transforming ratio
			volt = self.DCnominalVolt * self.ACactVolt / self.ACnominalVolt
		else
			volt = 0.0	-- If AC Voltage goes below 
		end
		self.DCactVolt = volt
		return volt
	end

	-- Get TRU Voltage when it's turned OFF
	self.getOFFDCVoltage = function()
		local volt
		
		if self.ACactVolt > self.minVoltage then
			-- Rough transforming ratio
			volt = self.DCnominalVolt * self.ACactVolt / self.ACnominalVolt
		else
			volt = 0.0
		end
		return volt
	end


	-- Set TRU ON/OFF
	self.setON = function(val)
		if val == 1 or val == true then
			self.ON = true
		else
			self.ON = false
		end
	end

	-- Get TRU ON, true if ON
	self.getON = function()
		return self.ON
	end	
	
	-- GET TRU OFF, returns true if OFF, used for the Button Indication
	self.getOFF = function()
		return not self.ON
	end
	

	-- Get Source ID for BUSes to now where to pull the AMPs 
	self.getID = function()
		return self.SourceID
	end
	
	return self
end