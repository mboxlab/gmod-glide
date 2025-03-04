-- Example car class
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_plane"
ENT.PrintName = "SU-35 Flanker-E"

ENT.GlideCategory = "Planes"
ENT.ChassisModel = "models/lfs_merydian/jets/su35/su35.mdl"
ENT.MaxChassisHealth = 500

ENT.PropOffset = Vector( 114, 0, 3 )

DEFINE_BASECLASS( "base_glide_plane" )

function ENT:SetupDataTables()
    BaseClass.SetupDataTables( self )

    self:NetworkVar( "Bool", "FiringGun" )
    self:NetworkVar( "Float", "LandingGearExtend" )
end

if CLIENT then
    ENT.CameraOffset = Vector( -600, 0, 190 )

    ENT.WeaponInfo = {
        { name = "#glide.weapons.cannon", icon = "glide/icons/bullets.png" },
        { name = "#glide.weapons.homing_missiles", icon = "glide/icons/rocket.png" },
    }

    ENT.CrosshairInfo = {
        { iconType = "dot", traceOrigin = Vector( 256, 0, 21.5 ) },
        { iconType = "square", traceOrigin = Vector( -58, 0, -16.1 ) },
    }

    ENT.ExhaustPositions = {
        { offset = Vector( -280, 38.8, -3.5 ), angle = Angle( 270, 0, 0 ), scale = 0.7 },
        { offset = Vector( -280, -38.8, -3.5 ), angle = Angle( 270, 0, 0 ), scale = 0.7 }
    }

    ENT.StrobeLights = {

    }

    ENT.EngineFireOffsets = {
        { offset = Vector( -280, 38.8, -3.5 ), angle = Angle( 270, 0, 0 ), scale = 0.7 },
        { offset = Vector( -280, -38.8, -3.5 ), angle = Angle( 270, 0, 0 ), scale = 0.7 }
    }

    ENT.StartSoundPath = "glide/aircraft/start_4.wav"
    ENT.DistantSoundPath = "JET_ENGINE_DIST"
    ENT.PropSoundPath = ""

    ENT.EngineSoundPath = "JET_ENGINE_RPM4"
    ENT.EngineSoundLevel = 90
    ENT.EngineSoundVolume = 0.45
    ENT.EngineSoundMinPitch = 103
    ENT.EngineSoundMaxPitch = 132

    ENT.ExhaustSoundPath = "glide/aircraft/distant_laser.wav"
    ENT.ExhaustSoundLevel = 90
    ENT.ExhaustSoundVolume = 0.5
    ENT.ExhaustSoundMinPitch = 55
    ENT.ExhaustSoundMaxPitch = 60

    ENT.ThrustSound = "glide/aircraft/thrust_b11.wav"

    function ENT:OnActivateMisc()
        BaseClass.OnActivateMisc( self )

        self.rudderLBone = self:LookupBone( "rudder_left" )
        self.rudderRBone = self:LookupBone( "rudder_right" )
        self.elevatorBone = self:LookupBone( "elevator" )
        self.aileronRBone = self:LookupBone( "aileron_right" )
        self.aileronLBone = self:LookupBone( "aileron_left" )

        self.propSpin = 0
    end

    local FrameTime = FrameTime
    local ang = Angle()

    function ENT:OnUpdateAnimations()
        if not self.elevatorBone then return end

        ang[1] = 0
        ang[2] = 0
        ang[3] = self:GetElevator() * -25

        self:ManipulateBoneAngles( self.elevatorBone, ang )

        ang[1] = self:GetRudder() * 20
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( self.rudderLBone, ang )

        ang[1] = self:GetRudder() * 20
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( self.rudderRBone, ang )

        local aileron = self:GetAileron()

        ang[2] = 0
        ang[1] = aileron * 25
        ang[3] = 0

        self:ManipulateBoneAngles( self.aileronRBone, ang )

        ang[2] = 0
        ang[1] = aileron * -25
        ang[3] = 0

        self:ManipulateBoneAngles( self.aileronLBone, ang )

        self:AnimateLandingGear()
    end

    ENT.SMRG = 0
    function ENT:AnimateLandingGear()
        -- AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        self.SMRG = self.SMRG + ( self:GetLandingGearExtend() - self.SMRG ) * FrameTime() * 8
        local SMRG = self.SMRG

        local gExp = SMRG ^ 9

        ang[1] = 0
        ang[2] = -25 * gExp
        ang[3] = 0

        self:ManipulateBoneAngles( 6, ang )

        ang[1] = 0
        ang[2] = -64 * gExp
        ang[3] = 0

        self:ManipulateBoneAngles( 7, ang )

        ang[1] = 90 * gExp
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 8, ang )

        ang[1] = -85 * SMRG
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 9, ang )
        self:ManipulateBoneAngles( 10, ang )

        ang[1] = 0
        ang[2] = -25 * gExp
        ang[3] = 0

        self:ManipulateBoneAngles( 11, ang )

        ang[1] = 0
        ang[2] = -64 * gExp
        ang[3] = 0

        self:ManipulateBoneAngles( 12, ang )

        ang[1] = -90 * gExp
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 13, ang )

        ang[1] = 85 * SMRG
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 14, ang )
        self:ManipulateBoneAngles( 15, ang )

        ang[1] = -30 * gExp
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 16, ang )

        ang[1] = -68.7 * gExp
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 17, ang )

        ang[1] = -18 * gExp
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 18, ang )

        ang[1] = -98 * SMRG
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 19, ang )
    end

    function ENT:OnUpdateSounds()
        BaseClass.OnUpdateSounds( self )

        local sounds = self.sounds

        if self:GetFiringGun() then
            if not sounds.gunFire then
                local gunFire = self:CreateLoopingSound( "gunFire", "M61A1_LOOP", 95, self )
                gunFire:PlayEx( 1.0, 100 )
            end

        elseif sounds.gunFire then
            sounds.gunFire:Stop()
            sounds.gunFire = nil

            self:EmitSound( "M61A1_LASTSHOT", 95, 100, 1.0 )
        end
    end

    ENT.nextEFX = 0
    function ENT:OnUpdateParticles()
        if self:GetPower() <= 0 then return end

        if self.nextEFX < CurTime() then
            self.nextEFX = CurTime() + 0.01

            local emitter = ParticleEmitter( self:GetPos(), false )

            if emitter then
                for i = -1, 1, 2 do
                    local vOffset = self:LocalToWorld( Vector( -255, 38.8 * i, -3.5 ) )
                    local vNormal = -self:GetForward()

                    vOffset = vOffset + vNormal * 5

                    local particle = emitter:Add( "effects/muzzleflash1", vOffset )
                    if not particle then return end

                    particle:SetVelocity( vNormal * math.Rand( 500, 1000 ) + self:GetVelocity() )
                    particle:SetLifeTime( 0 )
                    particle:SetDieTime( 0.13 )
                    particle:SetStartAlpha( 255 )
                    particle:SetEndAlpha( 0 )
                    particle:SetStartSize( math.Rand( 13, 25 ) )
                    particle:SetEndSize( math.Rand( 0, 4)  )
                    particle:SetRoll( math.Rand( -1,1 ) * 100 )

                    particle:SetColor( 230, 130, 250 )
                end

                emitter:Finish()
            end
        end
    end

    function ENT:OnTurnOn()
        BaseClass.OnTurnOn( self )
        self:SetBodygroup( 1, 1 )
    end

    function ENT:OnTurnOff()
        BaseClass.OnTurnOff( self )
        self:SetBodygroup( 1, 0 )
    end
end

if SERVER then
    ENT.ChassisMass = 1500
    ENT.SpawnPositionOffset = Vector( 0, 0, 80 )
    ENT.CollisionDamageMultiplier = 5

    ENT.ExplosionGibs = {
        "models/lfs_merydian/jets/su35/su35.mdl"
    }

    ENT.HasLandingGear = true
    ENT.ReverseTorque = 2000
    ENT.SteerConeMaxSpeed = 900

    ENT.PlaneParams = {
        liftAngularDrag = Vector( -30, -60, -100 ), -- (Roll, pitch, yaw)
        maxSpeed = 2800,
        liftSpeed = 1800,
        engineForce = 250,

        pitchForce = 4000,
        yawForce = 3500,
        rollForce = 5000
    }

    ENT.WeaponSlots = {
        { maxAmmo = 0, fireRate = 0.035, replenishDelay = 0, ammoType = "explosive_cannon" },
        { maxAmmo = 0, fireRate = 1.0, replenishDelay = 0, ammoType = "missile", lockOn = true },
    }

    -- Custom weapon logic
    ENT.BulletOffset = Vector( 128, -30.4, 27.6 )

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( 187, 0, 19 ), Angle( 0, -90, 7 ), Vector( 123, 100, -45 ), true )

        -- Front
        self:CreateWheel( Vector( 97, 0, -1 ), {
            steerMultiplier = 1,
            suspensionLength = 38,
            springStrength = 1500,
            springDamper = 6000,
            brakePower = 2000,
            sideTractionMultiplier = 250,
        } )

        self:CreateWheel( Vector( -105, 80, -8 ), {
            suspensionLength = 38,
            springStrength = 1500,
            springDamper = 6000,
            brakePower = 2000,
            sideTractionMultiplier = 250,
        } ) -- Rear left
        self:CreateWheel( Vector( -105, -80, -8 ), {
            suspensionLength = 38,
            springStrength = 1500,
            springDamper = 6000,
            brakePower = 2000,
            sideTractionMultiplier = 250,
        } ) -- Rear right

        self:ChangeWheelRadius( 18.5 )

        for _, w in ipairs( self.wheels ) do
            Glide.HideEntity( w, true )
        end

        self:GetPhysicsObject():SetInertia( Vector( 7329.1, 11794.3, 13878.1 ) )
    end

    ENT.Mirror = 1

    function ENT:OnWeaponFire( weapon )
        local attacker = self:GetSeatDriver( 1 )

        if weapon.ammoType == "explosive_cannon" then
            self:SetFiringGun( true )

            self:FireBullet( {
                pos = self:LocalToWorld( self.BulletOffset ),
                ang = self:LocalToWorldAngles( Angle( 0, 0.2, 0 ) ),
                attacker = attacker,
                damage = 30,
                spread = 0.001
            } )
        else
            local target

            -- Only make the missile follow the target when
            -- using the homing missiles and with a "hard" lock-on
            if weapon.lockOn and self:GetLockOnState() == 2 then
                target = self:GetLockOnTarget()
            end

            local pos = self:LocalToWorld( Vector( -58, 110 * self.Mirror, -16.1 ) )
            self:FireMissile( pos, self:GetAngles(), attacker, target )

            self.Mirror = -self.Mirror
        end
    end

    function ENT:OnWeaponStop()
        self:SetFiringGun( false )
    end

    function ENT:LandingGearThink( ... )
        BaseClass.LandingGearThink( self, ... )

        -- holy SHIT i was convinced this would be very messy
        self:SetLandingGearExtend( self.landingGearExtend )
    end

    function ENT:GetSpawnColor()
        return Color( 255, 255, 255 )
    end
end