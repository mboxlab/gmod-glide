AddCSLuaFile()

if not Glide then return end

ENT.GlideCategory = "Helicopters"

ENT.Type = "anim"
ENT.Base = "glide_gtav_armed_heli"
ENT.PrintName = "PO-30 Orca Armed"

ENT.MainRotorOffset = Vector( 16.3,0,115 )
ENT.TailRotorOffset = Vector( -242.55,-0,65 )


function ENT:GetCameraType(seatIndex)
    -- Pilot seat (first seat)
    if seatIndex == 1 then 
        return Glide.CAMERA_TYPE.AIRCRAFT
    end
    
    -- All other seats are turret positions
    return Glide.CAMERA_TYPE.TURRET
end


function ENT:GetSpawnColor()
    return Color(255, 255, 255, 255)
end

if CLIENT then
    ENT.CameraOffset = Vector( -550, 0, 150 )
	
	  ENT.WeaponInfo = {
        { name = "#glide.weapons.mgs", icon = "glide/icons/bullets.png" },
        { name = "#glide.weapons.missiles", icon = "glide/icons/rocket.png" }
    }
	
	    ENT.CrosshairInfo = {
        { iconType = "dot" },
        { iconType = "square" },
    }

    ENT.ExhaustPositions = {
        Vector( -101.1,0.22,51.32 )
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( -101.1,0.22,51.32 ), angle = Angle( 0, 0, 0 ) }
    }

    ENT.StartSoundPath = "glide/helicopters/start_2.wav"
    ENT.DistantSoundPath = "glide/helicopters/distant_loop_1.wav"
    ENT.TailSoundPath = "glide/helicopters/tail_rotor_2.wav"

    ENT.JetSoundPath = "glide/helicopters/jet_1.wav"
    ENT.JetSoundLevel = 65
    ENT.JetSoundVolume = 0.15

    ENT.BassSoundSet = "Glide.HeavyRotor.Bass"
    ENT.MidSoundSet = "Glide.HeavyRotor.Mid"
    ENT.HighSoundSet = "Glide.HeavyRotor.High"

    ENT.BassSoundVol = 1.0
    ENT.MidSoundVol = 0.7
    ENT.HighSoundVol = 0.4

    function ENT:AllowFirstPersonMuffledSound( seatIndex )
    end
end

if SERVER then

 ENT.WeaponSlots = {
        { maxAmmo = 0, fireRate = 0.03, replenishDelay = 0 },
        { maxAmmo = 2, fireRate = 2, replenishDelay = 2, ammoType = "missile" }
    }

 ENT.BulletOffsets = {
        Vector(9.25,-56.62,15.95),
		}
    ENT.MissileOffsets = {
        Vector( 18,57.3,15.78),
    }
	
	  ENT.BulletAngles = {
        Angle( 0, 0.8, 0 ),
    }


        function ENT:CreateFeatures()
            self:CreateSeat( Vector(90,15,20 ), nil, Vector( 50, 100, 0 ), true ) 
            self:CreateSeat( Vector(90,-15,20 ), nil, Vector( 50, 100, 0 ), true )
            self:CreateSeat( Vector( 60,-18,29 ), Angle( 0,90, 0 ), Vector( 50, -100, 0 ), true )
            self:CreateSeat( Vector( 60,0,29 ), Angle( 0,90, 0 ), Vector( 50, -100, 0 ), true )
            self:CreateSeat( Vector( 60,18,29 ), Angle( 0,90, 0 ), Vector( 50, -100, 0 ), true )
            self:CreateSeat( Vector( 15,5,29 ), Angle( 0,0, 0 ), Vector( 50, -100, 0 ), true )
            self:CreateSeat( Vector( 15,-5,29 ), Angle( 0,180, 0 ), Vector( 50, -100, 0 ), true )
            self:CreateSeat( Vector( -15,-18,29 ), Angle( 0,-90, 0 ), Vector( 50, -100, 0 ), true )
            self:CreateSeat( Vector( -15,0,29 ), Angle( 0,-90, 0 ), Vector( 50, -100, 0 ), true )
            self:CreateSeat( Vector( -15,18,29 ), Angle( 0,-90, 0 ), Vector( 50, -100, 0 ), true )
           -- Front left
            self:CreateWheel( Vector( 61.11,36.53,10 ), {
                model = "models/glide/reshed/heli/orca/glide_reshed_wheel_orca.mdl",
                modelScale = Vector( 0.8, 0.2, 0.8 ),
            } )
    
            -- Front right
            self:CreateWheel( Vector( 61.11,-36.53,10 ), {
                model = "models/glide/reshed/heli/orca/glide_reshed_wheel_orca.mdl",
                modelScale = Vector( 0.8, 0.2, 0.8 ),
            } )
    
            -- Rear
            self:CreateWheel( Vector( -98.51,4.18,10 ), {
                model = "models/glide/reshed/heli/orca/glide_reshed_wheel_orca.mdl",
                modelScale = Vector( 0.8, 0.2, 0.8 ),
            } )
                 self:CreateWheel( Vector( -98.51,-4.18,10 ), {
                model = "models/glide/reshed/heli/orca/glide_reshed_wheel_orca.mdl",
                modelScale = Vector( 0.8, 0.2, 0.8 ),
            } )
            
        end
    end
    
    
        ENT.ChassisMass = 500
        ENT.ChassisModel = "models/glide/reshed/heli/orca/glide_reshed_armed_orca.mdl"
    
        ENT.MainRotorRadius = 183
        ENT.TailRotorRadius = 37
    
        ENT.MainRotorModel = "models/glide/reshed/heli/orca/glide_reshed_maintorque_backtorque.mdl"
        ENT.MainRotorFastModel = "models/glide/reshed/heli/orca/glide_reshed_maintorque_backtorque.mdl"
    
        ENT.TailRotorModel = "models/glide/reshed/heli/orca/glide_reshed_orcabacktorque.mdl"
        ENT.TailRotorFastModel = "models/glide/reshed/heli/orca/glide_reshed_orcabacktorque.mdl"
    
        ENT.ExplosionGibs = {
        }
    
        ENT.AngularDrag = Vector( -12, -15, -15 )
    
        ENT.HelicopterParams = {
            pushUpForce = 350,
            pitchForce = 700,
            yawForce = 900,
            rollForce = 500,
            uprightForce = 700
        }
    
