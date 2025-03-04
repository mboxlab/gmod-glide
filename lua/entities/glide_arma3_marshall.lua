AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.PrintName = "AMV-7 Marshall"
ENT.GlideCategory = "Ground"
ENT.ChassisModel = "models/glide/reshed/tanks/glide_reshed_armed_marshall.mdl"
ENT.MaxChassisHealth = 2580
ENT.LastWeaponSwitch = 0
ENT.WeaponSwitchDelay = 0.5  

function ENT:GetSpawnColor()
    return Color(255, 255, 255, 255)
end



DEFINE_BASECLASS("base_glide_car")

-- Turret configuration
ENT.TurretConfig = {
    minPitch = -40,
    maxPitch = 20,
    minYaw = -360,
    maxYaw = 360,
    turnSpeed = 100,  -- Degrees per second
    weapons = {
        [1] = {  -- Main cannon (HE)
            name = "HE Cannon",
            fireRate = 60/120,  -- 120 rounds per minute
            damage = 100,
            explosionRadius = 200,
            sound = "weapons/30mm/fire.wav",
            tracer = true,
            spread = Vector(0, 0, 0),
            muzzleOffset = Vector(0,0,0)  -- Forward along cannon
        },
        [2] = {  -- SMG
            name = "Coaxial MG",
            fireRate = 60/550,  -- 550 rounds per minute
            damage = 25,
            sound = "glide/weapons/insurgent_shoot_3.wav",
            tracer = true,
            spread = Vector(0.02, 0.02, 0),
            muzzleOffset = Vector(80, 0, -5)  -- Slightly below main cannon
        }
    }
}

function ENT:SetupDataTables()
    BaseClass.SetupDataTables(self)
    
    -- Turret angles
    self:NetworkVar("Float", "TurretPitch")
    self:NetworkVar("Float", "TurretYaw")
    self:NetworkVar("Bool", "IsFiring")
    self:NetworkVar("Int", "WeaponIndex", { KeyName = "weaponindex" })
    
    if SERVER then
        self:SetTurretPitch(0)
        self:SetTurretYaw(0)
        self:SetIsFiring(false)
        self:SetWeaponIndex(1)  -- Default to HE
    end
end

function ENT:GetCurrentWeapon()
    return self.TurretConfig.weapons[self:GetWeaponIndex() or 1]
end

if SERVER then
    ENT.SpawnPositionOffset = Vector(0, 0,50)
    ENT.ChassisMass = 2500
    ENT.LastFireTime = 0

    function ENT:CreateFeatures()
        -- Create seats and wheels...
        -- [Previous wheel and seat code remains the same]
        self:SetBrakePower( 3800 )
        self:SetDifferentialRatio( 3.3 )
        self:SetPowerDistribution( -0.4 )

        self:SetMaxSteerAngle( 30 )
        self:SetSteerConeMaxSpeed( 1100 )

        self:SetSuspensionLength( 5 )
        self:SetSpringStrength( 4000 )
        self:SetSpringDamper( 2500 )

        self:SetForwardTractionMax( 3000 )
        self:SetSideTractionMin( 1000 )
        -- Driver seat (Gunner)
        self:CreateSeat(Vector(-2, 21.5, 9), Angle(0, 270, -5), Vector(40, 100, 0), true)

        -- Wheels
        self:CreateWheel(Vector(130,62,15), {
            model = "models/glide/reshed/tanks/glide_reshed_wheel2_marshall.mdl",
            modelAngle = Angle(0, 0, 0),
            modelScale = Vector(1.1, 0.5, 1.1),
            steerMultiplier = 1
        })

        self:CreateWheel(Vector(130,-62,15), {
            model = "models/glide/reshed/tanks/glide_reshed_wheel2_marshall.mdl",
            modelAngle = Angle(0, 0, 0),
            modelScale = Vector(1.1, 0.5, 1.1),
            steerMultiplier = 1
        })

        self:CreateWheel(Vector(-120,62,15), {
            model = "models/glide/reshed/tanks/glide_reshed_wheel2_marshall.mdl",
            modelAngle = Angle(0, 0, 0),
            modelScale = Vector(1.1, 0.5, 1.1),
            
        })

        self:CreateWheel(Vector(-120,-62,15), {
            model = "models/glide/reshed/tanks/glide_reshed_wheel2_marshall.mdl",
            modelAngle = Angle(0, 0, 0),
            modelScale = Vector(1.1, 0.5, 1.1),
            

        })



        self:CreateWheel(Vector(60,62,15), {
            model = "models/glide/reshed/tanks/glide_reshed_wheel2_marshall.mdl",
            modelAngle = Angle(0, 0, 0),
            modelScale = Vector(1.1, 0.5, 1.1),
            steerMultiplier = 1
        })


        self:CreateWheel(Vector(60,-62,15), {
            model = "models/glide/reshed/tanks/glide_reshed_wheel2_marshall.mdl",
            modelAngle = Angle(0, 0, 0),
            modelScale = Vector(1.1, 0.5, 1.1),
            steerMultiplier = 1
        })



        self:CreateWheel(Vector(-35,62,15), {
            model = "models/glide/reshed/tanks/glide_reshed_wheel2_marshall.mdl",
            modelAngle = Angle(0, 0, 0),
            modelScale = Vector(1.1, 0.5, 1.1),
            
        })

        self:CreateWheel(Vector(-25,-62,15), {
            model = "models/glide/reshed/tanks/glide_reshed_wheel2_marshall.mdl",
            modelAngle = Angle(0, 0, 0),
            modelScale = Vector(1.1, 0.5, 1.1),
            
        })

        self:ChangeWheelRadius(30)
    end

    function ENT:FireWeapon(driver, weaponData, muzzlePos, muzzleAng)
        if weaponData.name == "HE Cannon" then
            local bullet = {
                Attacker = driver,
                Damage = 0,  -- No impact damage
                Force = 1,
                Distance = 15000,
                Dir = muzzleAng:Forward(),
                Src = muzzlePos,
                Spread = weaponData.spread,
                TracerName = weaponData.tracer and "Tracer" or nil,
                Callback = function(att, tr, dmg)
                    if SERVER and tr.Hit then
                        local explosion = ents.Create("env_explosion")
                        explosion:SetPos(tr.HitPos)
                        explosion:SetOwner(driver)
                        explosion:Spawn()
                        explosion:SetKeyValue("iMagnitude", weaponData.damage)
                        explosion:SetKeyValue("iRadiusOverride", weaponData.explosionRadius)
                        explosion:Fire("Explode", 0, 0)
                    end
                end
            }
            self:FireBullets(bullet)
        else  -- SMG
            local bullet = {
                Attacker = driver,
                Damage = weaponData.damage,
                Force = 1,
                Distance = 15000,
                Dir = muzzleAng:Forward(),
                Src = muzzlePos,
                Spread = weaponData.spread,
                TracerName = weaponData.tracer and "Tracer" or nil
            }
            self:FireBullets(bullet)
        end
    end

    function ENT:GetMuzzlePosition()
        local weaponData = self:GetCurrentWeapon()
        local cannonBone = self:LookupBone("cannon")
        local muzzlePos, muzzleAng

        if cannonBone then
            local matrix = self:GetBoneMatrix(cannonBone)
            if matrix then
                muzzleAng = matrix:GetAngles()
                muzzlePos = matrix:GetTranslation()

                -- Apply offset relative to cannon's orientation
                local offset = weaponData.muzzleOffset
                muzzlePos = muzzlePos + muzzleAng:Forward() * offset.x
                muzzlePos = muzzlePos + muzzleAng:Right() * offset.y
                muzzlePos = muzzlePos + muzzleAng:Up() * offset.z

                -- Adjust angle to match turret direction
                local pitch = self:GetTurretPitch()
                local yaw = self:GetTurretYaw()
                muzzleAng = self:LocalToWorldAngles(Angle(pitch, yaw, 0))
            end
        end

        if not muzzlePos then
            muzzlePos = self:GetPos() + Vector(0, 0, 90)
            muzzleAng = self:GetAngles()
        end

        return muzzlePos, muzzleAng
    end

    function ENT:Think()
        BaseClass.Think(self)
        
        local driver = self:GetSeatDriver(1)
        if not IsValid(driver) then return true end
        
        -- Weapon switching
   -- Weapon switching
if driver:KeyPressed(IN_WALK) then
    if CurTime() >= self.LastWeaponSwitch + self.WeaponSwitchDelay then
        local newWeapon = self:GetWeaponIndex() == 1 and 2 or 1
        self:SetWeaponIndex(newWeapon)
        
        local weaponName = self.TurretConfig.weapons[newWeapon].name
        -- Only send message to the driver
        driver:ChatPrint(string.format("[Marshall] Switched to %s", weaponName))
        
        self.LastWeaponSwitch = CurTime()
    end
end
    
        local function NormalizeAngle(angle)
            while angle > 180 do angle = angle - 360 end
            while angle < -180 do angle = angle + 360 end
            return angle
        end
    
        -- Get aim position
        local aimPos = driver:GlideGetAimPos()
        local turretPos = self:LocalToWorld(Vector(0, 0, 90))
        local aimDir = (aimPos - turretPos):GetNormalized()
        
        -- Convert to local angles
        local targetAng = self:WorldToLocalAngles(aimDir:Angle())
        
        -- Clamp to limits
        targetAng.p = math.Clamp(targetAng.p, self.TurretConfig.minPitch, self.TurretConfig.maxPitch)
        
        -- Normalize the yaw angles and find shortest path
        local targetYaw = NormalizeAngle(targetAng.y)
        local currentYaw = NormalizeAngle(self:GetTurretYaw())
        local deltaYaw = NormalizeAngle(targetYaw - currentYaw)
        
        -- Smooth movement
        local dt = FrameTime()
        local maxMove = self.TurretConfig.turnSpeed * dt
        
        local currentPitch = self:GetTurretPitch()
        
        currentPitch = math.Approach(currentPitch, targetAng.p, maxMove)
        currentYaw = currentYaw + math.Clamp(deltaYaw, -maxMove, maxMove)
        
        self:SetTurretPitch(currentPitch)
        self:SetTurretYaw(currentYaw)
        
        -- Handle firing
        self:SetIsFiring(driver:KeyDown(IN_ATTACK))
        
        if self:GetIsFiring() then
            local weaponData = self:GetCurrentWeapon()
            if CurTime() >= self.LastFireTime + weaponData.fireRate then
                self.LastFireTime = CurTime()
                
                -- Get muzzle position with correct orientation
                local muzzlePos, muzzleAng = self:GetMuzzlePosition()
    
                -- Fire the weapon
                self:FireWeapon(driver, weaponData, muzzlePos, muzzleAng)
                
                -- Effects
                local eff = EffectData()
                eff:SetOrigin(muzzlePos)
                eff:SetAngles(muzzleAng)
                eff:SetEntity(self)
                eff:SetScale(1)
                -- Sound
                self:EmitSound(weaponData.sound, 75, 100, 1, CHAN_WEAPON)
            end
        end
    
        return true
    end
end

if CLIENT then
    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "rhino" )
        stream.offset = Vector( -30, 0, 0 )
    end

    
    local crosshairColor = {
        [true] = Color(255, 255, 255, 255),
        [false] = Color(150, 150, 150, 100)
    }

    function ENT:OnLocalPlayerEnter(seatIndex)
        self.isUsingTurret = false
        
        if seatIndex == 1 then
            self.isUsingTurret = true
            -- Print weapon switch instructions
            chat.AddText(Color(255, 255, 0), "[Marshall] ", Color(255, 255, 255), "Press ALT to switch weapons")
        else
            BaseClass.OnLocalPlayerEnter(self, seatIndex)
        end
    end

    function ENT:OnLocalPlayerExit()
        self.isUsingTurret = false
        BaseClass.OnLocalPlayerExit(self)
    end

    function ENT:DrawVehicleHUD(screenW, screenH)
        BaseClass.DrawVehicleHUD(self, screenW, screenH)

        if self.isUsingTurret then
            -- Using Glide's tank crosshair system
            Glide.DrawWeaponCrosshair(
                screenW * 0.5, 
                screenH * 0.5, 
                "glide/aim_tank.png", 
                0.14, 
                crosshairColor[true]
            )
        end
    end
    
        function ENT:DrawVehicleHUD(screenW, screenH)
            BaseClass.DrawVehicleHUD(self, screenW, screenH)
    
            if self.isUsingTurret then
                -- Using Glide's tank crosshair system
                Glide.DrawWeaponCrosshair(
                    screenW * 0.5, 
                    screenH * 0.5, 
                    "glide/aim_tank.png", 
                    0.14, 
                    crosshairColor[true] -- You can implement GetIsAimingAtTarget() if you want the color to change
                )
            end
        end
    end

    ENT.CameraOffset = Vector( -350, 0, 150 )
        function ENT:GetFirstPersonOffset(seatIndex, localEyePos)
            if seatIndex == 1 then
                local bone = self:LookupBone("turret_base")
                if bone then
                    local bonePos, boneAng = self:GetBonePosition(bone)
                    -- Convert the bone position to local coordinates relative to the entity
                    local localPos = self:WorldToLocal(bonePos)
                    return localPos + Vector(0, 0, 90) -- Add a small vertical offset for better view
                end
                return Vector(0, 0, 0) -- Fallback if bone isn't found
            end
        end
    
    

    ENT.Headlights = {
        { offset = Vector(238.83,-59.03,61.35), color = color_white, angles = Angle(0, 0, 0) },
        { offset = Vector(238.83,59.03,61.35), color = color_white, angles = Angle(0, 0, 0) }
    }

    ENT.ExhaustOffsets = {
        { pos = Vector(-65, 40, 7) },
        { pos = Vector(-65, -40, 7) }
    }

    ENT.LightSprites = {
        { type = "brake", offset = Vector(-193.59,69.48,66.52), dir = Vector(-1, 0, 0) },
        { type = "brake", offset = Vector(-193.59,-69.48,66.52), dir = Vector(-1, 0, 0) },
        { type = "reverse", offset = Vector(-193.59,69.48,66.52), dir = Vector(-1, 0, 0) },
        { type = "reverse", offset = Vector(-193.59,-69.48,66.52), dir = Vector(-1, 0, 0) },
        { type = "headlight", offset = Vector(-193.59,69.48,66.52), dir = Vector(1, 0, 0), color = color_white },
        { type = "headlight", offset = Vector(-193.59,-69.48,66.52), dir = Vector(1, 0, 0), color = color_white }
    }

    function ENT:OnActivateMisc()
        -- Initialize headlights
        self.headlights = {}
        
        -- Get turret bones
        self.turretBaseBone = self:LookupBone("turret_base")
        self.turretWeaponBone = self:LookupBone("cannon")
        
       
    end

    function ENT:OnUpdateAnimations()
        BaseClass.OnUpdateAnimations(self)

        -- Update turret bones
        if self.turretBaseBone and self.turretWeaponBone then
            -- Base rotation (Yaw)
            local baseAng = Angle(self:GetTurretYaw(), 0, 0)
            self:ManipulateBoneAngles(self.turretBaseBone, baseAng)

            -- Weapon rotation (Pitch)
            local weaponAng = Angle(0, 0, self:GetTurretPitch())
            self:ManipulateBoneAngles(self.turretWeaponBone, weaponAng)

            -- Camera shake when firing
            if self:GetIsFiring() and self.isUsingTurret then
                local punch = math.Rand(-0.3, 0.3)
                if IsValid(Glide.Camera) then
                    Glide.Camera:ViewPunch(-0.03, punch, 0)
                end
            end
        end
    end

    function ENT:GetCameraType(seatIndex)
        return seatIndex == 1 and 1 or 0  -- Turret or Car camera
    end

    -- Clean up sounds when removed
    function ENT:OnRemove()
        if self.FireSound then
            self.FireSound:Stop()
        end
        BaseClass.OnRemove(self)
    end
