drive.Register("drive_mapeditor", {
	Init = function(self)
		self.CameraDist 	= 4
		self.CameraDistVel 	= 0.1
	end,
	CalcView =  function(self, view)
		local idealdist = math.max( 10, self.Entity:BoundingRadius() ) * self.CameraDist
		self:CalcView_ThirdPerson(view, idealdist, 2, {self.Entity})
		view.angles.roll = 0
	end,
	SetupControls = function(self, cmd)		
		self.CameraDistVel = self.CameraDistVel + cmd:GetMouseWheel() * -0.5

		self.CameraDist = self.CameraDist + self.CameraDistVel * FrameTime()
		self.CameraDist = math.Clamp(self.CameraDist, 2, 20)
		self.CameraDistVel = math.Approach(self.CameraDistVel, 0, self.CameraDistVel * FrameTime() * 2)
	end,
	StartMove =  function(self, mv, cmd)
		self.Player:SetObserverMode(OBS_MODE_IN_EYE)
		
		mv:SetOrigin(self.Entity:GetNetworkOrigin())
		mv:SetVelocity(self.Entity:GetAbsVelocity())
		mv:SetMoveAngles(mv:GetAngles())

		local entity_angle = mv:GetAngles()
		entity_angle.roll = self.Entity:GetAngles().roll

		if (mv:KeyDown(IN_ATTACK2) || mv:KeyReleased(IN_ATTACK2)) then
			--entity_angle = self.Entity:GetAngles()
		end

		if (mv:KeyReleased(IN_ATTACK2)) then
			--self.Player:SetEyeAngles(self.Entity:GetAngles())
		end

		mv:SetAngles(entity_angle)
	end,
	Move = function(self, mv)
		local speed = 0.0005 * FrameTime()
		if (mv:KeyDown(IN_SPEED)) then speed = 0.005 * FrameTime() end

		local ang = mv:GetMoveAngles()
		local pos = mv:GetOrigin()
		local vel = mv:GetVelocity()

		ang.roll = 0

		vel = vel + ang:Forward()	* mv:GetForwardSpeed()	* speed
		vel = vel + ang:Right()		* mv:GetSideSpeed()		* speed
		vel = vel + ang:Up()		* mv:GetUpSpeed()		* speed

		if (math.abs(mv:GetForwardSpeed()) + math.abs(mv:GetSideSpeed()) + math.abs(mv:GetUpSpeed()) < 0.1) then
			vel = vel * 0.90
		else
			vel = vel * 0.99
		end

		pos = pos + vel
		
		mv:SetVelocity(vel)
		mv:SetOrigin(pos)
	end,
	FinishMove =  function(self, mv)
		self.Entity:SetNetworkOrigin(mv:GetOrigin())
		self.Entity:SetAbsVelocity(mv:GetVelocity())
		self.Entity:SetAngles(mv:GetAngles())

		if (SERVER && IsValid(self.Entity:GetPhysicsObject())) then
			self.Entity:GetPhysicsObject():EnableMotion(true)
			self.Entity:GetPhysicsObject():SetPos(mv:GetOrigin())
			self.Entity:GetPhysicsObject():Wake()
			self.Entity:GetPhysicsObject():EnableMotion(false)
		end
	end
}, "drive_base")