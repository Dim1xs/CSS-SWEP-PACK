--//SWEP CREATED BY DIM1XS

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

SWEP.Name = "[CSS] USP"

SWEP.PrintName				= "USP"
SWEP.ViewModel				= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp.mdl"
SWEP.ViewModelFOV           =  65
SWEP.anim_prefix			= "python"
SWEP.Slot				= 1
SWEP.SlotPos		= 0

SWEP.ViewKick = 0.5
SWEP.Penalty = 0.2
SWEP.Spread = random.RandomFloat(0.00873,0.05234)

SWEP.Primary = 
{
	ClipSize = 12,
	DefaultClip = 12,
	Automatic = false,
	Ammo = "Pistol"
}

SWEP.Weight					= 7
SWEP.item_flags				= 0

SWEP.damage					= 20

SWEP.SoundData				=
{
	empty					= "Weapon_Pistol.Empty",
	single_shot				= "addons/css/usp-1.mp3"
}

SWEP.showusagehint			= 0
SWEP.AutoSwitchTo			= 1
SWEP.AutoSwitchFrom			= 1
SWEP.BuiltRightHanded		= 0
SWEP.AllowFlipping			= 1
SWEP.MeleeWeapon			= 0

-- TODO; implement Activity enum library!!
SWEP.m_acttable				=
{

	{ ACT_RANGE_ATTACK1,			ACT_RANGE_ATTACK_PISTOL,						true },
	{ ACT_RELOAD,					ACT_RELOAD_PISTOL,								true },
	{ ACT_IDLE,				        ACT_IDLE_PISTOL,								true },
	{ ACT_IDLE_ANGRY,				ACT_IDLE_ANGRY_PISTOL,							true },
	{ ACT_WALK,					    ACT_WALK_PISTOL,								true },


	{ ACT_HL2MP_IDLE,					ACT_HL2MP_IDLE_PISTOL,						false },
	{ ACT_HL2MP_RUN,					ACT_HL2MP_RUN_PISTOL,						false },
	{ ACT_HL2MP_IDLE_CROUCH,			ACT_HL2MP_IDLE_CROUCH_PISTOL,				false },
	{ ACT_HL2MP_WALK_CROUCH,			ACT_HL2MP_WALK_CROUCH_PISTOL,				false },
	{ ACT_HL2MP_GESTURE_RANGE_ATTACK,	ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,		false },
	{ ACT_HL2MP_GESTURE_RELOAD,			ACT_HL2MP_GESTURE_RELOAD_PISTOL,			false },
	{ ACT_HL2MP_JUMP,					ACT_HL2MP_JUMP_PISTOL,						false },
	{ ACT_RANGE_ATTACK1,				ACT_RANGE_ATTACK_PISTOL,					false },
    { ACT_MP_STAND_IDLE,				ACT_HL2MP_IDLE_PISTOL,						false },
	{ ACT_MP_CROUCH_IDLE,				ACT_HL2MP_IDLE_CROUCH_PISTOL,				false },

	{ ACT_MP_RUN,						ACT_HL2MP_RUN_PISTOL,						false },
	{ ACT_MP_CROUCHWALK,				ACT_HL2MP_WALK_CROUCH_PISTOL,				false },

	{ ACT_MP_ATTACK_STAND_PRIMARYFIRE,	ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,		false },
	{ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE,	ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,		false },

	{ ACT_MP_RELOAD_STAND,				ACT_HL2MP_GESTURE_RELOAD_PISTOL,			false },
	{ ACT_MP_RELOAD_CROUCH,				ACT_HL2MP_GESTURE_RELOAD_PISTOL,			false },

	{ ACT_MP_JUMP,						ACT_HL2MP_JUMP_PISTOL,						false },
};

function SWEP:Initialize()
	self.m_bReloadsSingly	= false;
	self.m_bFiresUnderwater	= false;
	self.m_bSilencerOn = false;
	self.SoundDelay = 0 
	self.IsSilenced = false
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
			self.m_flNextPrimaryAttack = 0.15;
		end

		return;
	end

	if (self.IsSilenced == true) then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SILENCED)
		if (self.SoundDelay < gpGlobals.curtime()) then
			self:EmitSound("addons/weapons/usp/usp1.wav")
			self.SoundDelay = gpGlobals.curtime() + 0.18;
		end 
	else
		if not (self.IsSilenced == true) then
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self:WeaponSound( 1 );
		else
			return
		end
	end
	pPlayer:DoMuzzleFlash();

	self:SendWeaponAnim( 180 );
	pPlayer:SetAnimation( 5 );
	ToHL2MPPlayer(pPlayer):DoAnimationEvent( 0 );

	self.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.18;
	self.m_flNextSecondaryAttack = gpGlobals.curtime() + 0.75;

	self.m_iClip1 = self.m_iClip1 - 1;

	local vecSrc		= pPlayer:Weapon_ShootPosition();
	local vecAiming		= pPlayer:GetAutoaimVector( 0.08715574274766 );


	-- vecSrc - position of fire, vecAiming - Directory where is shooting, bullet spread, distance, Ammo Type
	local info = FireBulletsInfo_t(1, vecSrc, vecAiming, Vector(self.Spread,self.Spread,self.Spread),8096, self.m_iPrimaryAmmoType);
	info.m_flDamage = 22;
	info.m_pAttacker = pPlayer;
	info.m_iPlayerDamage = 22

	-- Fire the bullets, and force the first shot to be perfectly accuracy
	pPlayer:FireBullets( info );

	local viewkick = QAngle()
	viewkick.x = -(self.ViewKick * (self.Penalty + 1)) + random.RandomFloat( -0.25, -0.5 )
	viewkick.y = (viewkick.x * 0.15) + random.RandomFloat( -.6, .6 )
	viewkick.z = 0

	pPlayer:ViewPunch( viewkick );

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

	self.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.10;
	self.m_flNextSecondaryAttack = gpGlobals.curtime() + 1.8;

	if (self.IsSilenced == false) then
		self.IsSilenced = true
		self:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
	else
		if (self.IsSilenced == true) then
			self.IsSilenced = false
			self:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
		else
			return
		end
	end
    --//SWEP CREATED BY DIM1XS
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
 if self.m_bSilencerOn == true then
        return ACT_VM_DRAW_SILENCED;
    end

    if self.m_bSilencerOn == false then
        return ACT_VM_DRAW;
    end
end

function SWEP:Holster( pSwitchingTo )
end

function SWEP:ItemPostFrame()
end

function SWEP:ItemBusyFrame()
end

function SWEP:DoImpactEffect()
end


--//SWEP CREATED BY DIM1XS
