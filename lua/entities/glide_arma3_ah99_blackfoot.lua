AddCSLuaFile()

if not Glide then return end

ENT.GlideCategory = "Helicopters"
ENT.Type = "anim"
ENT.Base = "glide_gtav_armed_heli"
ENT.PrintName = "AH-99 Blackfoot"
DEFINE_BASECLASS("glide_gtav_armed_heli")

-- Common Vehicle Settings
ENT.MaxChassisHealth = 1500
ENT.MainRotorOffset = Vector(46.78, 0, 110)
ENT.TailRotorOffset = Vector(-196.06, 5, 52.73)

function ENT:GetSpawnColor()
    return Color(255, 255, 255, 255)
end

-- Client-side camera offset logic, integrated into shared file
if CLIENT then
    -- Set camera offsets for pilot and gunner
    ENT.CameraOffset = Vector(-350, 0, 150)  -- Default offset for pilot
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
        Vector(0, 40, 65),
        Vector(0, -40, 65)
    }

    ENT.EngineFireOffsets = {
        { offset = Vector(0, 0, 102), angle = Angle(300, 0, 0) }
    }

    -- Sound paths for helicopter
    ENT.StartSoundPath = "glide/helicopters/start_2.wav"
    ENT.DistantSoundPath = "glide/helicopters/distant_loop_1.wav"
    ENT.TailSoundPath = "glide/helicopters/tail_rotor_2.wav"
    ENT.JetSoundPath = "glide/helicopters/jet_1.wav"
    ENT.JetSoundLevel = 65
    ENT.JetSoundVolume = 0.15

    -- Rotor sound sets
    ENT.BassSoundSet = "Glide.HunterRotor.Bass"
    ENT.MidSoundSet = "Glide.HunterRotor.Mid"
    ENT.HighSoundSet = "Glide.HunterRotor.High"
    ENT.BassSoundVol = 1.0
    ENT.MidSoundVol = 0.85
    ENT.HighSoundVol = 0.4

    ENT.WeaponInfo = {
        { name = "#glide.weapons.homing_missiles", icon = "glide/icons/rocket.png" },
    }

    ENT.CrosshairInfo = {
        { iconType = "square", traceOrigin = Vector( 0, 0, -15 ) },
    }

    ENT.CrosshairInfo = {
        { iconType = "square" }
    }
end

if SERVER then

  ENT.WeaponSlots = {
        { maxAmmo = 0, fireRate = 1.0, replenishDelay = 0, ammoType = "missile", lockOn = true },
    }

    ENT.MissileOffsets = {
        Vector( 102.8,39.97,28.79 ),
        Vector( 102.8,-39.97,28.79 )
    }
    ENT.HasLandingGear = true
    -- Helicopter setup and turret creation
    ENT.ChassisMass = 700
    ENT.ChassisModel = "models/glide/reshed/heli/blackfoot/glide_reshed_armed_blackfoot.mdl"
    ENT.HasLandingGear = true
    ENT.MainRotorRadius = 340
    ENT.TailRotorRadius = 75
    ENT.MainRotorModel = "models/glide/reshed/heli/blackfoot/glide_reshed_armed_blackfoot_main.mdl"
    ENT.MainRotorFastModel = "models/glide/reshed/heli/blackfoot/glide_reshed_armed_blackfoot_main.mdl"

    ENT.TailRotorModel = "models/glide/reshed/heli/blackfoot/glide_reshed_armed_blackfoot_back.mdl"
    ENT.TailRotorFastModel = "models/glide/reshed/heli/blackfoot/glide_reshed_armed_blackfoot_back.mdl"
    ENT.ExplosionGibs = {
    } 

    -- Create and setup the turret
    -- Add this function in the shared section of the vehicle script
    -- Modify the CreateFeatures method to set up explosive bullets
    function ENT:CreateFeatures()
  for _, w in ipairs( self.wheels ) do
            Glide.HideEntity( w, true )
        end
		self.missileIndex = 0
        -- Ensure BulletOffset is defined before usage
        self:CreateSeat(Vector(90,0,50), nil, Vector(100,50,70), true)
        self:CreateSeat(Vector(150,0,40), nil, Vector(100,50,70), true)

        self.wheelParams.suspensionLength = 5

        self:CreateWheel( Vector( 91.68,41.21,8 ) )
        self:CreateWheel( Vector( 91.68,-41.21,8 ) )
        self:CreateWheel( Vector( -163.4,-2.62,8 ) )
        self:ChangeWheelRadius( 8 )


        for _, w in ipairs( self.wheels ) do
            w:SetNoDraw( true )
            w.brake = 0.5
        end
        -- Tail rotor is "contained" on this helicopter model, so disable the trace
        self.tailRotor.enableTrace = false

        -- Create Turret and set up properties
        self.turret = Glide.CreateTurret(self, Vector(190, 0, 19), Angle())
        self.turret:SetModel("models/glide/reshed/heli/blackfoot/glide_reshed_armed_blackfoot_turet.mdl")
        self.turret:SetBodyModel("models/glide/reshed/heli/blackfoot/glide_reshed_armed_blackfoot_cannon.mdl", Vector(0, 0, 0))
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
 