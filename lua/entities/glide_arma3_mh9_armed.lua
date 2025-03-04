AddCSLuaFile()

if not Glide then return end

ENT.GlideCategory = "Helicopters"

ENT.Type = "anim"
ENT.Base = "glide_gtav_armed_heli" 
ENT.PrintName = "AH-9 'Pawnee'"

ENT.MainRotorOffset = Vector( -22.26,0,95 )
ENT.TailRotorOffset = Vector( -198,2.46,75 )


function ENT:GetSpawnColor()
    return Color(255, 255, 255, 255)
end

if CLIENT then
    ENT.CameraOffset = Vector( -550, 0, 150 )
	
	  ENT.WeaponInfo = {
        { name = "#glide.weapons.mgs", icon = "glide/icons/bullets.png" },
        { name = "#glide.weapons.barrage_missiles", icon = "glide/icons/rocket.png" }
    }
	
	    ENT.CrosshairInfo = {
        { iconType = "dot" },
        { iconType = "square" },
        { iconType = "square" }
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

    ENT.BassSoundSet = "Glide.MilitaryRotor.Bass"
    ENT.MidSoundSet = "Glide.MilitaryRotor.Mid"
    ENT.HighSoundSet = "Glide.MilitaryRotor.High"

    ENT.BassSoundVol = 1.0
    ENT.MidSoundVol = 0.7
    ENT.HighSoundVol = 0.4

    function ENT:AllowFirstPersonMuffledSound( seatIndex )
        return seatIndex < 3
    end
end

if SERVER then


    ENT.WeaponSlots = {
        { maxAmmo = 0, fireRate = 0.03, replenishDelay = 0 },
        { maxAmmo = 12, fireRate = 0.2, replenishDelay = 15, ammoType = "barrage" }
    }
	
	    ENT.BulletOffsets = {
        Vector(0.92,-35.54,32.07),
        Vector(0.92,35.54,32.07)
    }

  

    ENT.MissileOffsets = {
        Vector( 10,-54.43,29.9),
        Vector( 10,54.43,29.9),
    }
	
	  ENT.BulletAngles = {
        Angle( 0, 0.8, 0 ),
        Angle( 0, -0.8, 0 )
    }

    ENT.ChassisMass = 500
    ENT.ChassisModel = "models/glide/reshed/heli/mh9/glide_reshed_armed_mh9hummingbird.mdl"

    ENT.MainRotorRadius = 183
    ENT.TailRotorRadius = 37

    ENT.MainRotorModel = "models/glide/reshed/heli/mh9/glide_reshed_mh9torquemain.mdl"
    ENT.MainRotorFastModel = "models/glide/reshed/heli/mh9/glide_reshed_mh9torquemain.mdl"

    ENT.TailRotorModel = "models/glide/reshed/heli/mh9/glide_reshed_mh9torqueback.mdl"
    ENT.TailRotorFastModel = "models/glide/reshed/heli/mh9/glide_reshed_mh9torqueback.mdl"

    ENT.ExplosionGibs = {
    }

    ENT.AngularDrag = Vector( -12, -15, -15 )

    ENT.HelicopterParams = {
        pushUpForce = 500,
        pitchForce = 900,
        yawForce = 1200,
        rollForce = 800,
        uprightForce = 900
    }

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( 8,12,40 ), nil, Vector( 50, 100, 0 ), true )
        self:CreateSeat( Vector( 8,-12,40 ), nil, Vector( 50, -100, 0 ), true )
    end
end

