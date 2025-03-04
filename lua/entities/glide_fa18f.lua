-- Example car class
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_plane"
ENT.PrintName = "F/A-18F Superhornet"

ENT.Spawnable = false

ENT.GlideCategory = "Planes"
ENT.ChassisModel = "models/lfs_merydian/jets/f18f/f18f.mdl"
ENT.MaxChassisHealth = 500

ENT.PropOffset = Vector( 114, 0, 3 )

DEFINE_BASECLASS( "base_glide_plane" )

function ENT:SetupDataTables()
    BaseClass.SetupDataTables( self )

    self:NetworkVar( "Bool", "FiringGun" )
    self:NetworkVar( "Float", "LandingGearExtend" )
end

if CLIENT then
    ENT.CameraOffset = Vector( -600, 0, 150 )

    ENT.WeaponInfo = {
        { name = "#glide.weapons.cannon", icon = "glide/icons/bullets.png" },
        { name = "#glide.weapons.homing_missiles", icon = "glide/icons/rocket.png" },
    }

    ENT.CrosshairInfo = {
        { iconType = "dot", traceOrigin = Vector( 256, 0, 21.5 ) },
        { iconType = "square", traceOrigin = Vector( -58, 0, -9.2 ) },
    }

    ENT.ExhaustPositions = {
        { offset = Vector( -250, 20, 0 ), angle = Angle( 270, 0, 0 ), scale = 0.7 },
        { offset = Vector( -250, -20, 0 ), angle = Angle( 270, 0, 0 ), scale = 0.7 }
    }

    ENT.StrobeLights = {

    }

    ENT.EngineFireOffsets = {
        { offset = Vector( -250, 20, 25 ), angle = Angle( 270, 0, 0 ), scale = 0.7 },
        { offset = Vector( -250, -20, 25 ), angle = Angle( 270, 0, 0 ), scale = 0.7 }
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

        self.rudderLBone = self:LookupBone( "rudder_l" )
        self.rudderRBone = self:LookupBone( "rudder_r" )
        self.elevatorBone = self:LookupBone( "elevator" )
        self.aileronRBone = self:LookupBone( "aileron_r" )
        self.aileronLBone = self:LookupBone( "aileron_l" )

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
        ang[1] = aileron * -25
        ang[3] = 0

        self:ManipulateBoneAngles( self.aileronRBone, ang )

        ang[2] = 0
        ang[1] = aileron * -25
        ang[3] = 0

        self:ManipulateBoneAngles( self.aileronLBone, ang )

        self:AnimateLandingGear()
    end

    ENT.SMLG = 0
    ENT.SMCG = 2
    function ENT:AnimateLandingGear()
        -- AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        self.SMLG = self.SMLG and self.SMLG + ( ( 1 - self:GetLandingGearExtend() ) - self.SMLG ) * FrameTime() * 8
        self.SMCG = self.SMCG and self.SMCG + ( 1 * self:GetLandingGearExtend() - self.SMCG ) * FrameTime() * 15
        local SMLG = self.SMLG

        local gExp = SMLG ^ 5
        local gExp3 = self.SMCG ^ 0.3
        local gExp4 = self.SMCG ^ 0.4

        ang[1] = -40 * self.SMLG
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 13, ang )

        ang[1] = -55 * SMLG
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 14, ang )
        self:ManipulateBoneAngles( 15, ang )

        ang[1] = 92 * gExp4
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 16, ang )

        ang[1] = 97 * gExp4
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 17, ang )

        ang[1] = 100 * gExp4
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 18, ang )

        ang[1] = -83 * gExp4
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 19, ang )

        ang[1] = -90 * SMLG
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 1, ang )

        ang[1] = -60 * gExp
        ang[2] = 70 * gExp
        ang[3] = 0

        self:ManipulateBoneAngles( 2, ang )

        ang[1] = 0
        ang[2] = 20 * gExp
        ang[3] = 0

        self:ManipulateBoneAngles( 3, ang )

        ang[1] = 90 * SMLG
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 7, ang )

        ang[1] = 0
        ang[2] = 60 * gExp
        ang[3] = 70 * gExp

        self:ManipulateBoneAngles( 8, ang )

        ang[1] = 0
        ang[2] = -20 * gExp
        ang[3] = 0

        self:ManipulateBoneAngles( 9, ang )

        ang[1] = 0
        ang[2] = -55 * SMLG
        ang[3] = 0

        self:ManipulateBoneAngles( 21, ang )

        ang[1] = 0
        ang[2] = 55 * SMLG
        ang[3] = 0

        self:ManipulateBoneAngles( 22, ang )

        ang[1] = -23 * gExp3
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 23, ang )

        ang[1] = 23 * gExp3
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 24, ang )

        ang[1] = 91 * gExp3
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 4, ang )

        ang[1] = 87 * gExp3
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 5, ang )

        ang[1] = -85 * gExp3
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 6, ang )

        ang[1] = -91 * gExp3
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 10, ang )

        ang[1] = -87 * gExp3
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 11, ang )

        ang[1] = 88 * gExp3
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( 12, ang )
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
                    local vOffset = self:LocalToWorld( Vector( -255, 16 * i, 4.7 ) )
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
        self:SetBodygroup( 7, 1 )
    end

    function ENT:OnTurnOff()
        BaseClass.OnTurnOff( self )
        self:SetBodygroup( 7, 0 )
    end
end

if SERVER then
    ENT.ChassisMass = 1500
    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.CollisionDamageMultiplier = 5

    ENT.ExplosionGibs = {
        "models/lfs_merydian/jets/f18f/f18f.mdl"
    }

    ENT.HasLandingGear = true
    ENT.ReverseTorque = 2000
    ENT.SteerConeMaxSpeed = 900

    ENT.PlaneParams = {
        liftAngularDrag = Vector( -30, -60, -100 ), -- (Roll, pitch, yaw)
        maxSpeed = 2000,
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
    ENT.BulletOffset = Vector( 256, 0, 21.5 )

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( 142, 0, 9.5 ), Angle( 0, -90, 9 ), Vector( 125, 86, -45 ), true )

        -- Update default wheel params

        -- Front
        self:CreateWheel( Vector( 150, 0, -6 ), {
            steerMultiplier = 1,
            suspensionLength = 38,
            springStrength = 1500,
            springDamper = 6000,
            brakePower = 2000,
            sideTractionMultiplier = 250,
        } )

        self:CreateWheel( Vector( -85, -55, -10 ), {
            suspensionLength = 38,
            springStrength = 1500,
            springDamper = 6000,
            brakePower = 2000,
            sideTractionMultiplier = 250,
        } ) -- Rear left

        self:CreateWheel( Vector( -85, 55, -10 ), {
            suspensionLength = 38,
            springStrength = 1500,
            springDamper = 6000,
            brakePower = 2000,
            sideTractionMultiplier = 250,
        } ) -- Rear right

        self:ChangeWheelRadius( 15 )

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
                ang = self:GetAngles(),
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

            local pos = self:LocalToWorld( Vector( -58, 83 * self.Mirror, -9.2 ) )
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

sound.Add( {
    name = "M61A1_LOOP",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 90,
    sound = "lfs_custom/f18_hornet/m61_loop.wav"
} )

sound.Add( {
    name = "M61A1_LASTSHOT",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 90,
    sound = "lfs_custom/f18_hornet/m61_lastshot.wav"
} )