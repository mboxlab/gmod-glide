AddCSLuaFile()

if not Glide then return end

ENT.GlideCategory = "Helicopters"
ENT.Type = "anim"
ENT.Base = "glide_gtav_armed_heli"
ENT.PrintName = "Mi-48 Kajman"
DEFINE_BASECLASS("glide_gtav_armed_heli")

-- Common Vehicle Settings
ENT.MaxChassisHealth = 3500
ENT.MainRotorOffset = Vector(28.74,0.53,163.17)
ENT.TailRotorOffset = Vector(28.74,0.53,200)

function ENT:GetSpawnColor()
    return Color(255, 255, 255, 255)
end

-- Client-side camera offset logic, integrated into shared file
if CLIENT then


    -- Set camera offsets for pilot and gunner
    ENT.CameraOffset = Vector(-500, 0, 150)  -- Default offset for pilot
    ENT.CameraAngleOffset = Angle(6, 0, 0)  -- Default angle offset for pilot

    -- Gunner camera offset (example)
    local gunnerCameraOffset = Vector(180, 0, 30)  -- Customize based on your needs
    local gunnerCameraAngleOffset = Angle(10, 0, 0)  -- Customize based on your needs

    -- Modify GetFirstPersonOffset for gunner seats
    function ENT:GetFirstPersonOffset(seatIndex, localEyePos)
        if seatIndex == 2 then  -- Gunner seat (assuming index 2)
            -- Set custom camera offset for the gunner
            return gunnerCameraOffset
        else  -- Pilot seat (index 1)
            -- Keep the default first-person offset for the pilot
            return localEyePos  -- No change for pilot
        end
    end

    -- Modify GetCameraType for the gunner
    function ENT:GetCameraType(seatIndex)
        if seatIndex == 2 then  -- Gunner seat
            return Glide.CAMERA_TYPE.HELICOPTER  -- Set camera type for gunner view
        else  -- Pilot seat
            return Glide.CAMERA_TYPE.HELICOPTER  -- Default camera type for pilot
        end
    end

    -- Adjust the angle offset for the gunner
    function ENT:GetCameraAngleOffset(seatIndex)
        if seatIndex == 2 then  -- Gunner seat
            return gunnerCameraAngleOffset  -- Custom angle for gunner
        else  -- Pilot seat
            return self.CameraAngleOffset  -- Default angle for pilot
        end
    end

    -- Exhaust and engine fire offsets
    ENT.ExhaustPositions = {
        Vector(72.83,43.76,108.49),
        Vector(72.83,-43.76,108.49)
    }

    ENT.EngineFireOffsets = {
        { offset = Vector(72.83,43.76,108.49), angle = Angle(300, 0, 0) },
	 { offset = Vector(72.83,-43.76,108.49), angle = Angle(300, 0, 0) },
    }

    -- Sound paths for helicopter
    ENT.StartSoundPath = "glide/helicopters/start_2.wav"
    ENT.DistantSoundPath = "glide/helicopters/distant_loop_1.wav"
    ENT.TailSoundPath = "glide/helicopters/tail_rotor_2.wav"
    ENT.JetSoundPath = "glide/helicopters/jet_1.wav"
    ENT.JetSoundLevel = 65
    ENT.JetSoundVolume = 0.15

    -- Rotor sound sets
    ENT.BassSoundSet = "Glide.HeavyRotor.Bass"
    ENT.MidSoundSet = "Glide.HeavyRotor.Mid"
    ENT.HighSoundSet = "Glide.HeavyRotor.High"
    ENT.BassSoundVol = 1.0
    ENT.MidSoundVol = 0.85
    ENT.HighSoundVol = 0.4

    ENT.WeaponInfo = {
        { name = "#glide.weapons.homing_missiles", icon = "glide/icons/rocket.png" },
        { name = "#glide.weapons.barrage_missiles", icon = "glide/icons/rocket.png" }
    }

    ENT.CrosshairInfo = {
        { iconType = "square", traceOrigin = Vector( 0, 0, -15 ) },
        { iconType = "square", traceOrigin = Vector( 0, 0, -15 ) }
    }
end

if SERVER then

    function ENT:UpdateCrosshairPosition()
        if self.isUsingTurret then
            self.crosshair.origin = Glide.GetCameraAimPos()
        else
            BaseClass.UpdateCrosshairPosition( self )
        end
    end


   ENT.HelicopterParams = {
        pushUpForce = 220,
        pitchForce = 400,
        yawForce = 800,
        rollForce = 400,
        maxPitch = 60, 
		maxSpeed = 1200,
    }


 function ENT:Repair()
        self:SetChassisHealth( self.MaxChassisHealth )
        self:SetEngineHealth( 1.0 )
        self:SetOutOfControl( false )

        if not IsValid( self.mainRotor ) then
            self.mainRotor = self:CreateRotor( self.MainRotorOffset, self.MainRotorRadius, self.MainRotorModel, self.MainRotorFastModel )
        end

        if not IsValid( self.tailRotor ) then
            self.tailRotor = self:CreateRotor( self.TailRotorOffset, self.MainRotorRadius, self.MainRotorModel, self.MainRotorFastModel )
            self.tailRotor.maxSpinSpeed = -2000
        end

        for _, rotor in ipairs( self.rotors ) do
            if IsValid( rotor ) then
                rotor:Repair()
                rotor:SetSpinAxis( 2 )
                rotor:SetSpinAngle( math.random( 0, 180 ) )
            end
        end
    end


  ENT.WeaponSlots = {
        { maxAmmo = 8, fireRate = 0.5, replenishDelay = 15, ammoType = "missile", lockOn = true },
		{ maxAmmo = 16, fireRate = 0.15, replenishDelay = 12, ammoType = "barrage" }
    }

    ENT.MissileOffsets = {
        Vector( 35.29,-63.45,56.58 ),
        Vector( 35.29,63.45,56.58 )
    }
    ENT.HasLandingGear = false
    -- Helicopter setup and turret creation
    ENT.ChassisMass = 900
    ENT.ChassisModel = "models/glide/reshed/heli/kajman/glide_reshed_armed_kajman.mdl"
    ENT.MainRotorRadius = 340
    ENT.TailRotorRadius = 75
    ENT.MainRotorModel = "models/glide/reshed/heli/kajman/glide_reshed_armed_kajman_rotor.mdl"
    ENT.MainRotorFastModel = "models/glide/reshed/heli/kajman/glide_reshed_armed_kajman_rotor.mdl"

    ENT.TailRotorModel = "models/glide/reshed/heli/kajman/glide_reshed_armed_kajman_rotor.mdl"
    ENT.TailRotorFastModel = "models/glide/reshed/heli/kajman/glide_reshed_armed_kajman_rotor.mdl"
    ENT.ExplosionGibs = {
    } 

    -- Create and setup the turret
    -- Add this function in the shared section of the vehicle script
    -- Modify the CreateFeatures method to set up explosive bullets
    function ENT:CreateFeatures()
	
	 self:CreateWheel( Vector( 77.76,36.92,11.28 ), {
            model = "models/glide/reshed/heli/kajman/glide_reshed_armed_kajman_wheel.mdl",
            modelScale = Vector( 0.8, 0.2, 0.8 ),
        } )

        -- Front right
        self:CreateWheel( Vector( 77.76,-36.92,11.28 ), {
            model = "models/glide/reshed/heli/kajman/glide_reshed_armed_kajman_wheel.mdl",
            modelScale = Vector( 0.8, 0.2, 0.8 ),
        } )

        -- Rear
        self:CreateWheel( Vector( -71.67,8.43,7.06 ), {
            model = "models/glide/reshed/heli/kajman/glide_reshed_armed_kajman_wheel.mdl",
            modelScale = Vector( 0.8, 0.2, 0.8 ),
        } )
		     self:CreateWheel( Vector( -71.67,-8.43,7.06 ), {
            model = "models/glide/reshed/heli/kajman/glide_reshed_armed_kajman_wheel.mdl",
            modelScale = Vector( 0.8, 0.2, 0.8 ),
        } )
	
		self.missileIndex = 0
        -- Ensure BulletOffset is defined before usage
        self:CreateSeat(Vector(105,0,85), nil, Vector(105,150,85), true)
        self:CreateSeat(Vector(150,0,70), nil, Vector(150,150,70), true)
		self:CreateSeat( Vector( -15,10,33 ), Angle( 0,0, 0 ), Vector( 40.45,120.83,28.38 ), true )
		self:CreateSeat( Vector( 4,10,33 ), Angle( 0,0, 0 ), Vector( 40.45,120.83,28.38 ), true )
		self:CreateSeat( Vector( 24,10,33 ), Angle( 0,0, 0 ), Vector( 40.45,120.83,28.38 ), true )
	    self:CreateSeat( Vector( 43.5,10,33 ), Angle( 0,0, 0 ), Vector( 40.45,120.83,28.38 ), true )
		--
		self:CreateSeat( Vector( -15,-10,33 ), Angle( 0,180, 0 ), Vector( 40.45,-120.83,28.38 ), true )
		self:CreateSeat( Vector( 4,-10,33 ), Angle( 0,180, 0 ), Vector( 40.45,-120.83,28.38 ), true )
		self:CreateSeat( Vector( 24,-10,33 ), Angle( 0,180, 0 ), Vector( 40.45,-120.83,28.38 ), true )
	    self:CreateSeat( Vector( 43.5,-10,33 ), Angle( 0,180, 0 ), Vector( 40.45,-120.83,28.38 ), true )

        self.wheelParams.suspensionLength = 5



        for _, w in ipairs( self.wheels ) do
            w:SetNoDraw( false )
            w.brake = 0.5
        end
        -- Tail rotor is "contained" on this helicopter model, so disable the trace
        self.tailRotor.enableTrace = false

        --Create Turret and set up properties
        self.turret = Glide.CreateTurret(self, Vector(190, 0, 35), Angle())
        self.turret:SetModel("models/glide/reshed/heli/kajman/glide_reshed_armed_kajman_turret.mdl")
        self.turret:SetBodyModel("models/glide/reshed/heli/kajman/glide_reshed_armed_kajman_cannon.mdl", Vector(0, 0, 0))
        self.turret:SetMinPitch(-10)
        self.turret:SetMaxPitch(90)
        self.turret:SetMinYaw(-80)
        self.turret:SetMaxYaw(80)
        self.turret:SetFireDelay(60/550)
        self.turret:SetBulletOffset(Vector(60, 0, 0))
        self.turret:SetColor(self:GetColor())
        self.turret:GetGunBody():SetColor(self:GetColor())

        -- Attach firing logic to turret's update loop
        self:HookTurretFiringLogic(self.turret)
    end

    function ENT:HookTurretFiringLogic(turret)
        function turret:Think()
            local parent = self:GetParent()
            local body = self:GetGunBody()
            local t = CurTime()

            if IsValid(parent) and IsValid(body) then
                self:UpdateTurret(parent, body, t)
            end

            self:NextThink(t)
            return true
        end

        function turret:UpdateTurret(parent, body, t)
            local user = self:GetGunUser()

            -- Only let the server and the current user's client to run the logic below.
            if not SERVER and not (CLIENT and LocalPlayer() == user) then return end

            if IsValid(user) then
                self:SetIsFiring(user:KeyDown(1)) -- IN_ATTACK

                local fromPos = body:GetPos() + body:GetUp() * self:GetBulletOffset()[3]
                local aimPos = SERVER and user:GlideGetAimPos() or Glide.GetCameraAimPos()
                local dir = aimPos - fromPos
                dir:Normalize()

                local ang = parent:WorldToLocalAngles(dir:Angle())

                ang[1] = math.Clamp(ang[1], self:GetMinPitch(), self:GetMaxPitch())

                local minYaw, maxYaw = self:GetMinYaw(), self:GetMaxYaw()

                if minYaw ~= -1 and maxYaw ~= -1 then
                    ang[2] = math.Clamp(ang[2], minYaw, maxYaw)
                end

                ang[3] = 0

                body:SetLocalAngles(ang)

                if SERVER then
                    self:SetLastBodyAngle(ang)
                end

                if CLIENT then
                    self.predictedBodyAngle = ang
                    self.nextPunch = self.nextPunch or 0

                    if self:GetIsFiring() and t > self.nextPunch then
                        self.nextPunch = t + 0.1
                        Glide.Camera:ViewPunch(-0.03, math.Rand(-0.02, 0.02), 0)
                    end
                end
            end

            self.nextFire = self.nextFire or 0

            local isFiring = self:GetIsFiring()

            if isFiring and t > self.nextFire then
                local pos = body:LocalToWorld(self:GetBulletOffset())
                local ang = body:GetAngles()

                self.nextFire = t + self:GetFireDelay()

                -- Fire Explosive Bullet directly here
                local params = {
                    pos = pos,
                    ang = ang,
                    attacker = user,
                    inflictor = self,
                    spread = 0.3,
                    isExplosive = true,  -- Ensuring the bullet is explosive
                    damage = 25,  -- Adjust the damage as needed
                    explosionRadius = 100  -- Adjust the explosion radius as needed
                }

                Glide.FireBullet(params)

                -- Shell ejection effect
                local eff = EffectData()
                eff:SetOrigin(pos - ang:Forward() * 30)
                eff:SetEntity(self)
                eff:SetMagnitude(1)
                eff:SetRadius(5)
                eff:SetScale(0.2)
                eff:SetAngles(self:GetRight():Angle())
                util.Effect("RifleShellEject", eff)
            end
        end
    end


    function ENT:CreateSmallerExplosion(inflictor, attacker, origin, radius, damage, normal, explosionType)
        if not IsValid(inflictor) then return end

        if not IsValid(attacker) then
            attacker = inflictor
        end

        -- Deal damage
        util.BlastDamage(inflictor, attacker, origin, radius, damage)

        -- Let nearby players handle sounds and effects client side
        local targets, count = Glide.GetNearbyPlayers(origin, Glide.MAX_EXPLOSION_DISTANCE)

        -- Always let the attacker see/hear it too, if they are a player
        if attacker:IsPlayer() then
            count = count + 1
            targets[count] = attacker
        end

        if count == 0 then return end

        Glide.StartCommand(Glide.CMD_CREATE_EXPLOSION, true)
        net.WriteVector(origin)
        net.WriteVector(normal)
        net.WriteUInt(explosionType, 2)
        net.Send(targets)

        util.ScreenShake(origin, 5, 0.5, 1.0, 1500, true)

        -- Add the smaller explosion effect
        local effect = EffectData()
        effect:SetOrigin(origin)
        effect:SetNormal(normal)
        effect:SetRadius(radius)
        effect:SetScale(0.5)  -- Adjust this value to make the explosion effect smaller
        effect:SetMagnitude(damage)
        util.Effect("HelicopterMegaBomb", effect)  -- Change "HelicopterMegaBomb" to your desired effect name
    end

    -- The Think method to handle turret logic and seat assignments
    function ENT:Think()
        BaseClass.Think(self)

        -- Update the turret user
        self.turret:UpdateUser(self:GetSeatDriver(2))

        return true
    end
end
 