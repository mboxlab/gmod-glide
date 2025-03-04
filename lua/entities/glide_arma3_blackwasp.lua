-- Example car class
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_plane"
ENT.PrintName = "F/A-181 Black Wasp"

ENT.GlideCategory = "Planes"
ENT.ChassisModel = "models/glide/reshed/plane/blackwasp/glide_reshed_armed_blackwasp.mdl"
ENT.MaxChassisHealth = 500

ENT.PropOffset = Vector( 114, 0, 3 )

DEFINE_BASECLASS( "base_glide_plane" )

function ENT:GetSpawnColor()
    return Color(255, 255, 255, 255)
end


function ENT:SetupDataTables()
    BaseClass.SetupDataTables( self )
	self:NetworkVar( "Bool", "FiringGun" )

end

if CLIENT then
    ENT.CameraOffset = Vector( -600, 0, 200 )
	-- Custom weapon logic

    ENT.WeaponInfo = {
        { name = "AP Cannon", icon = "glide/icons/bullets.png" },
        { name = "#glide.weapons.homing_missiles", icon = "glide/icons/rocket.png" },
    }

    ENT.CrosshairInfo = {
        { iconType = "dot", traceOrigin = Vector( 0, 0, -18.5 ) },
        { iconType = "square", traceOrigin = Vector( 0, 0, -19 ) },
    }
	
    ENT.MissileOffsets = {
        Vector( 28.52,108,16.24),
		Vector( 28.52,-108,16.24),
    }
	
	  ENT.BulletAngles = {
        Angle( 0, 0.8, 0 ),
    }

    ENT.ExhaustPositions = {
        Vector( -240.38,14.26,52.56 ),
		Vector( -240.38,-14.26,52.56 ),
    }


    ENT.EngineFireOffsets = {
         Vector( -240.38,14.26,52.56 ),
		Vector( -240.38,-14.26,52.56 ),
    }

    ENT.StartSoundPath = "glide/aircraft/start_4.wav"
    ENT.DistantSoundPath = "glide/aircraft/jet_stream.wav"
    ENT.PropSoundPath = ""

    ENT.EngineSoundPath = "glide/aircraft/engine_luxor.wav"
    ENT.EngineSoundLevel = 90
    ENT.EngineSoundVolume = 0.45
    ENT.EngineSoundMinPitch = 103
    ENT.EngineSoundMaxPitch = 132

    ENT.ExhaustSoundPath = "glide/aircraft/distant_laser.wav"
    ENT.ExhaustSoundLevel = 90
    ENT.ExhaustSoundVolume = 0.5
    ENT.ExhaustSoundMinPitch = 55
    ENT.ExhaustSoundMaxPitch = 60

    ENT.ThrustSound = "glide/aircraft/thrust.wav"

    function ENT:OnActivateMisc()
        BaseClass.OnActivateMisc( self )


        self.rudderBone = self:LookupBone( "rudder_l" )
		self.rudderBone = self:LookupBone( "rudder_r" )
        self.elevatorRBone = self:LookupBone( "elevator_r" )
        self.elevatorLBone = self:LookupBone( "elevator_l" )
        self.aileronRBone = self:LookupBone( "flap_right" )
        self.aileronLBone = self:LookupBone( "flap_left" )

    end

    local FrameTime = FrameTime
    local ang = Angle()

    function ENT:OnUpdateAnimations()
        if not self.rudderBone then return end

        ang[1] = 0
        ang[2] = self:GetRudder() * -5
        ang[3] = 0

        self:ManipulateBoneAngles( self.rudderBone, ang )

        ang[1] = 0
        ang[2] = self:GetElevator() * 20
        ang[3] = 0

        self:ManipulateBoneAngles( self.elevatorRBone, ang )

        ang[1] = 0
        ang[2] = 0
        ang[3] = self:GetElevator() * -20

        self:ManipulateBoneAngles( self.elevatorLBone, ang )

        local aileron = self:GetAileron()

        ang[1] = 0
        ang[2] = 0
        ang[3] = aileron * 15

        self:ManipulateBoneAngles( self.aileronRBone, ang )

        ang[3] = -ang[3]

        self:ManipulateBoneAngles( self.aileronLBone, ang )


    end
	 function ENT:OnUpdateSounds()
        BaseClass.OnUpdateSounds( self )

        local sounds = self.sounds

        if self:GetFiringGun() then
            if not sounds.gunFire then
                local gunFire = self:CreateLoopingSound( "gunFire", "glide/weapons/turret_hunt_loop.wav", 95, self )
                gunFire:PlayEx( 1.0, 100 )
            end

        elseif sounds.gunFire then
            sounds.gunFire:Stop()
            sounds.gunFire = nil
        end
    
end

end

if SERVER then

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 0, 0, 0 ) ) -- Change the center of mass here
    end
    ENT.ChassisMass = 1500
    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.CollisionDamageMultiplier = 5

    ENT.ExplosionGibs = {
    }

    ENT.HasLandingGear = true
    ENT.ReverseTorque = 2000
    ENT.SteerConeMaxSpeed = 900

    ENT.PlaneParams = {
        liftAngularDrag = Vector( -30, -60, -100 ), -- (Roll, pitch, yaw)
        maxSpeed = 2500,
        liftSpeed = 1800,
        engineForce = 750,

        pitchForce = 4500,
        yawForce = 3500,
        rollForce = 2500
    }

    ENT.WeaponSlots = {
        { maxAmmo = 0, fireRate = 0.02, replenishDelay = 0, ammoType = "explosive_cannon" },
        { maxAmmo = 2, fireRate = 1.0, replenishDelay = 10, ammoType = "missile", lockOn = true },
    }
	
	ENT.BulletOffset = Vector( 214.43,0,65.47 )

    -- Custom weapon logic

    ENT.MissileOffsets = {
        Vector( 50, 122, -24 ),
        Vector( 50, -122, -24 )
    }

    function ENT:CreateFeatures()
	
        self:CreateSeat( Vector( 110, 0, 50 ), Angle( 0, 270, 10 ), Vector( -160, 120, 0 ), true )

        -- Update default wheel params
       --[[local wheelParams = {
            suspensionLength = 5000000,
        }

        -- Front
        self:CreateWheel( Vector( 104,1.6,10 ), {
            steerMultiplier = 1
        } )

        self:CreateWheel( Vector( -110.14,42.11,10 ) ) -- Rear left
        self:CreateWheel( Vector( -110.14,-42.11,10) ) -- Rear right

        self:ChangeWheelRadius( 5 )

        for _, w in ipairs( self.wheels ) do
            Glide.HideEntity( w, true )
        end--]]
		
		 local wheelParams = {
            suspensionLength = 10,
            springStrength = 1500,
            springDamper = 6000,
            brakePower = 2000,
            sideTractionMultiplier = 250
        }

        -- Front
        wheelParams.steerMultiplier = 1
        self:CreateWheel( Vector( 103.1,0,6.3 ), wheelParams )

        -- Rear
        wheelParams.steerMultiplier = 0
        self:CreateWheel( Vector( -110.14,-42.11,10 ), wheelParams ) -- left
        self:CreateWheel( Vector( -110.14,42.11,10 ), wheelParams ) -- right

        self:ChangeWheelRadius( 10 )

        for _, w in ipairs( self.wheels ) do
            Glide.HideEntity( w, true )
        end
		self.missileIndex = 0
     end
	 
	 
	 function ENT:OnWeaponFire( weapon )
    local attacker = self:GetSeatDriver( 1 )

    if weapon.ammoType == "explosive_cannon" then
        self:SetFiringGun( true )

        self:FireBullet( {
            pos = self:LocalToWorld( self.BulletOffset ),
            ang = self:GetAngles(),
			damage = 90,
            attacker = attacker,
            isExplosive = false,
            length = 12000
        } )
    else
        self.missileIndex = self.missileIndex + 1

        if self.missileIndex > #self.MissileOffsets then
            self.missileIndex = 1
        end

        local target

        -- Only make the missile follow the target when
        -- using the homing missiles and with a "hard" lock-on
        if weapon.lockOn and self:GetLockOnState() == 2 then
            target = self:GetLockOnTarget()
        end

        local pos = self:LocalToWorld( self.MissileOffsets[self.missileIndex] )
        self:FireMissile( pos, self:GetAngles(), attacker, target )
    end
end

function ENT:OnWeaponStop()
    self:SetFiringGun( false )
end
	 
	 
end 