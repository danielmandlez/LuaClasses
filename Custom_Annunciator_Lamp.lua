---------------------------------------------------------------------------------
--	Project: 	Useful Lua-Classes for X-Plane GIZMO 
--	Developer:	Daniel Mandlez 
--	Date:		2014
--	FileBlock:	Custom Annunciator Lamp
---------------------------------------------------------------------------------

-- Make your custom Annunciator Lamp 
-- 	Simple Lamp 0 to 1	for 2D/3D Panels 
-- 	Controlable Lamp 0.0 to 1.0 for 3D Panels only ==> control brightness
--  
--  Power avail Flag for both Variants, if power false lamp output switch/stay to 0
--  Power avail Flag can be Boolean or Integer both works


-- CLASS -- Annunciator Lamp: Simple 0 to 1 -------------------------------------
---------------------------------------------------------------------------------

AnnunciatorLamp_INT = {}					-- Creating Table for Class methods

AnnunciatorLamp_INT.new = function(DataRef)	-- Constructor (STRING)

	local self = {}
	
	self.DR_Door = DateRef					-- Pointer to DataRef, has to be an INTEGER DataRef
	
	self.act_val = 0						-- Initial Actual Value
	self.last_val = 0						-- Last Value
	
	dref.setInt(DataRef, 0)					-- Set DataRef 0
	
	
	-- Set Lamp with an Integer Value 0 or 1, or Boolean false or true for the Lamp
	self.set = function(val, power)			-- Bool/Integer, Bool/Integer optional
		local lamp
		power = power or true				-- if no value for power is present it will be true
		
		if power == true or power == 1 then
			if val == true or val == 1 then
				self.act_val = 1
			else
				self.act_val = 0
			end
		else 
			self.act_val = 0
		end
		
		if self.act_val ~= self.last_val then
			dref.setInt(DataRef, self.act_val)
		end
		self.last_val = self.act_val
	end
	
	return self		-- returns all methods to object!!! 
end
---------------------------------------------------------------------------------


-- CLASS -- Annunciator Lamp: Brightness control 0.0 to 1.0 ---------------------
---------------------------------------------------------------------------------

AnnunciatorLamp_FLOAT = {}					-- Creating Table for Class methods

AnnunciatorLamp_FLOAT.new = function(DataRef)	-- Constructor (STRING)

	local self = {}
	
	self.DR_Lamp = DataRef					-- Pointer to DataRef, has to be an INTEGER DataRef
	
	self.act_val = 0.0						-- Initial Actual Value
	self.last_val = 0.0						-- Last Value
	
	dref.setFloat(DR_Lamp, self.act_val)	-- Set DataRef 0.0
	
	-- Set Lamp with an Int Value 0 or 1 for the Lamp with Lamp brightness 0.0 to 1.0
	self.set = function(val, brightness, power)			-- Bool/Integer, Float, Bool/Integer optinal
		local lamp
		power = power or true				-- if no value for power is present it will be true
		-- Check Brightness value 
		if brightness < 0.0 then brightness = 0.0 end
		if brightness > 1.0 then brightness = 1.0 end
		
		if power == true or power == 1 then
			if val == true or val == 1 then
				self.act_val = 1 * brightness
			else
				self.act_val = 0
			end
		else 
			self.act_val = 0
		end
		
		if self.act_val ~= self.last_val then
			dref.setFloat(DR_Lamp, self.act_val)
		end
		self.last_val = self.act_val
	end
	
	return self		-- returns all methods to object!!! 
end
---------------------------------------------------------------------------------


-- HOW TO USE -------------------------------------------------------------------
---------------------------------------------------------------------------------


-- Create custom DataRef for Lamp
DR_YourLamp1 = dref.newInt("yourairplane/Annunciator/YourLamp1")
DR_YourLamp2 = dref.newFloat("yourairplane/Annunciator/YourLamp2")

-- Create Objects
YourLamp1 = AnnunciatorLamp_INT.new(DR_YourLamp1)	-- Create a simple Lamp
YourLamp2 = AnnunciatorLamp_FLOAT.new(DR_YourLamp1)	-- Create a Brightness control Lamp

	-- OPTIONAL: you can create the DataRef direct on object create 
	YourLamp1 = AnnunciatorLamp_INT.new( dref.newInt("yourairplane/Annunciator/YourLamp1") )	-- create a simple lamp and custom DataRef
	YourLamp2 = AnnunciatorLamp_FLOAT.new( dref.newFloat("yourairplane/Annunciator/YourLamp2") )	-- create a brightness controlled lamp and custom DataRef
	-- The pointer to the DataRef is now NOT Global and is only available in the object!!
	
function yourFunction()

	-- For Integer Lamp, Boolean or Integer Values allowed
		YourLamp1.set(1, 1)			
		-- or
		YourLamp1.set(true, true)
		-- or
		YourLamp1.set(1)		-- if don't set a value for power it will be true!
		
	
	-- For Float Lamp (with Brightness control)
		YourLamp1.set(1, 0.8, 1)	-- Set with Brightness factor 0.8
	
end
---------------------------------------------------------------------------------
