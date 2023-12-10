--/SWEP CREATED BY DIM1XS

--//DONT TOUCH IT!
VECTOR_CONE_1DEGREES   =     Vector( 0.00873, 0.00873, 0.00873 )
VECTOR_CONE_2DEGREES   =     Vector( 0.01745, 0.01745, 0.01745 )
VECTOR_CONE_3DEGREES   =     Vector( 0.02618, 0.02618, 0.02618 )
VECTOR_CONE_4DEGREES   =     Vector( 0.03490, 0.03490, 0.03490 )
VECTOR_CONE_5DEGREES   =     Vector( 0.04362, 0.04362, 0.04362 )
VECTOR_CONE_6DEGREES   =     Vector( 0.05234, 0.05234, 0.05234 )
VECTOR_CONE_7DEGREES   =     Vector( 0.06105, 0.06105, 0.06105 )
VECTOR_CONE_8DEGREES   =     Vector( 0.06976, 0.06976, 0.06976 )
VECTOR_CONE_9DEGREES   =     Vector( 0.07846, 0.07846, 0.07846 )
VECTOR_CONE_10DEGREES  =     Vector( 0.08716, 0.08716, 0.08716 )
VECTOR_CONE_15DEGREES  =     Vector( 0.13053, 0.13053, 0.13053 )
VECTOR_CONE_20DEGREES  =     Vector( 0.17365, 0.17365, 0.17365 )

SWEP.Name = "[CSS] AUG"

SWEP.PrintName				= "AUG"
SWEP.ViewModel 			    = "models/weapons/v_rif_aug.mdl"
SWEP.ViewModelFOV           =  65
SWEP.WorldModel			= "models/weapons/w_rif_aug.mdl"
SWEP.anim_prefix			= "python"
SWEP.Slot				= 2
SWEP.SlotPos		= 0

SWEP.ViewKick = 6.7

SWEP.Primary = 
{
	ClipSize = 30,
	DefaultClip = 30,
	Automatic = true,
	Ammo = "SMG1"
}

SWEP.Weight					= 7
SWEP.item_flags				= 0

SWEP.damage					= 28

SWEP.SoundData				=
{
	empty					= "Weapon_Pistol.Empty",
	single_shot				= "addons/css/aug-1.mp3"
}

SWEP.showusagehint			= 1
SWEP.AutoSwitchTo			= 1
SWEP.AutoSwitchFrom			= 1
SWEP.BuiltRightHanded		= 0
SWEP.AllowFlipping			= 1
SWEP.MeleeWeapon			= 0

-- TODO; implement Activity enum library!!
SWEP.m_acttable				=
{
	{ ACT_RANGE_ATTACK1,			ACT_RANGE_ATTACK_AR2,					true },
	{ ACT_RELOAD,					ACT_RELOAD_SMG1,						true },
	{ ACT_IDLE,				        ACT_IDLE_SMG1,							true },
	{ ACT_IDLE_ANGRY,				ACT_IDLE_ANGRY_SMG1,					true },
	{ ACT_WALK,					    ACT_WALK_RIFLE,							true },
	
	{ ACT_HL2MP_IDLE,					ACT_HL2MP_IDLE_AR2,					false },
	{ ACT_HL2MP_RUN,					ACT_HL2MP_RUN_AR2,					false },
	{ ACT_HL2MP_IDLE_CROUCH,			ACT_HL2MP_IDLE_CROUCH_AR2,			false },
	{ ACT_HL2MP_WALK_CROUCH,			ACT_HL2MP_WALK_CROUCH_AR2,			false },
	{ ACT_HL2MP_GESTURE_RANGE_ATTACK,	ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,	false },
	{ ACT_HL2MP_GESTURE_RELOAD,			ACT_HL2MP_GESTURE_RELOAD_AR2,		false },
	{ ACT_HL2MP_JUMP,					ACT_HL2MP_JUMP_AR2,					false },
	{ ACT_RANGE_ATTACK1,				ACT_RANGE_ATTACK_AR2,				false },
    { ACT_MP_STAND_IDLE,				ACT_HL2MP_IDLE_AR2,					false },
	{ ACT_MP_CROUCH_IDLE,				ACT_HL2MP_IDLE_CROUCH_AR2,			false },

	{ ACT_MP_RUN,						ACT_HL2MP_RUN_AR2,					false },
	{ ACT_MP_CROUCHWALK,				ACT_HL2MP_WALK_CROUCH_AR2,			false },

	{ ACT_MP_ATTACK_STAND_PRIMARYFIRE,	ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,	false },
	{ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE,	ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,	false },

	{ ACT_MP_RELOAD_STAND,				ACT_HL2MP_GESTURE_RELOAD_AR2,		false },
	{ ACT_MP_RELOAD_CROUCH,				ACT_HL2MP_GESTURE_RELOAD_AR2,		false },

	{ ACT_MP_JUMP,						ACT_HL2MP_JUMP_AR2,					false },

};

function SWEP:Initialize()
	self.m_bReloadsSingly	= false;
	self.m_bFiresUnderwater	= false;
	self.isZoomed = false;
end

function SWEP:Precache()
end

function SWEP:PrimaryAttack()
	-- Only the player fires this way so we can cast
	local pPlayer = self:GetOwner();

	if ( ToBaseEntity( pPlayer ) == NULL ) then
		return;
	end

	if ( self.m_iClip1 <= 0 ) then
		if ( not self.m_bFireOnEmpty ) then
			self:Reload();
		else
			self:WeaponSound( 0 );
			self.m_flNextPrimaryAttack = 0.3;
		end

		return;
	end

	self:WeaponSound( 1 );
	pPlayer:DoMuzzleFlash();

	self:SendWeaponAnim( 180 );
	pPlayer:SetAnimation( 5 );
	ToHL2MPPlayer(pPlayer):DoAnimationEvent( 0 );

	if ( self.isZoomed == false) then
		self.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.09;
	else
		if (self.isZoomed == true) then
			self.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.17;
		else
			self.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.09;
		end
	end
	self.m_flNextSecondaryAttack = gpGlobals.curtime() + 1;

	self.m_iClip1 = self.m_iClip1 - 1;

	local vecSrc		= pPlayer:Weapon_ShootPosition();
	local vecAiming		= pPlayer:GetAutoaimVector( 0.08715574274766 );


	-- vecSrc - position of fire, vecAiming - Directory where is shooting, bullet spread, distance, Ammo Type
	local info = FireBulletsInfo_t(1, vecSrc, vecAiming, VECTOR_CONE_1DEGREES,4096, self.m_iPrimaryAmmoType);
	info.m_flDamage = 28;
	info.m_iPlayerDamage = 14;
	info.m_pAttacker = pPlayer;

	-- Fire the bullets, and force the first shot to be perfectly accuracy
	pPlayer:FireBullets( info );

	local viewkick = QAngle()
	viewkick.x = -(self.ViewKick * 0.30)--//SLIDE LIMIT
	viewkick.y = random.RandomFloat(2 + self.ViewKick, -2 + -self.ViewKick) * 0.18 --//VERTICAL LIMIT
	viewkick.z = 0

	pPlayer:ViewPunch( viewkick )

	if ( self.m_iClip1 == 0 and pPlayer:GetAmmoCount( self.m_iPrimaryAmmoType ) <= 0 ) then
		-- HEV suit - indicate out of ammo condition
		pPlayer:SetSuitUpdate( "!HEV_AMO0", 0, 0 );
	end
end

function SWEP:SecondaryAttack()
	local pPlayer = self:GetOwner();

	if ( ToBaseEntity( pPlayer ) == NULL ) then
		return;
	end

	if self.isZoomed == false then 
        pPlayer:SetFOV(self,30,0.2)
        self.isZoomed = true;
        self.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.17;
    else
        pPlayer:SetFOV(self,0,0.2)
        self.isZoomed = false;
        self.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.09;
    end

    self.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.09;
		self.m_flNextSecondaryAttack = gpGlobals.curtime() + 0.80;
--/SWEP CREATED BY DIM1XS
end

function SWEP:Reload()
	--local fRet = self:DefaultReload( self:GetMaxClip1(), self:GetMaxClip2(), 182 );
	--f ( fRet ) then
--		self:WeaponSound( 6 );
		ToHL2MPPlayer(self:GetOwner()):DoAnimationEvent( 3 );
	--end
	return self:DefaultReload( self:GetMaxClip1(), self:GetMaxClip2(), 182 );
end

function SWEP:Think()
end

function SWEP:CanHolster()
end

function SWEP:Deploy()
end

function SWEP:GetDrawActivity()
	return 171;
end

function SWEP:Holster( pSwitchingTo )
	local pPlayer = ToHL2Player(self:GetOwner())
    if ( pPlayer == nil ) then
      return;
    end
    pPlayer:SetFOV(self,0,0)
end

function SWEP:ItemPostFrame()
end

function SWEP:ItemBusyFrame()
end

function SWEP:DoImpactEffect()
end
--/SWEP CREATED BY DIM1XS