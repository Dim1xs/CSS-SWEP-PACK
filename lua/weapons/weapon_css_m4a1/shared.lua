--//SWEP CREATED BY DIM1XS

SWEP.printname				= "M4A1 CSS"
SWEP.viewmodel 			    = "models/weapons/v_rif_m4a1.mdl"
SWEP.viewmodelfov           =  65
SWEP.playermodel			= "models/weapons/w_rif_m4a1.mdl"
SWEP.anim_prefix			= "python"
SWEP.bucket					= 2
SWEP.bucket_position		= 2

SWEP.clip_size				= 30
SWEP.clip2_size				= -1
SWEP.default_clip			= 30
SWEP.default_clip2			= -1
SWEP.primary_ammo			= "SMG1"
SWEP.secondary_ammo			= "None"

SWEP.weight					= 7
SWEP.item_flags				= 0

SWEP.damage					= 30

SWEP.SoundData				=
{
	empty					= "Weapon_Pistol.Empty",
	single_shot				= "addons/css/m4a1shoot.mp3"
}

SWEP.showusagehint			= 1
SWEP.autoswitchto			= 1
SWEP.autoswitchfrom			= 1
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
end

function SWEP:Precache()
	 self:PrecacheSound("addons/css/m4a1sil-1.mp3")
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
			self.m_flNextPrimaryAttack = 0.2;
		end

		return;
	end

	self:WeaponSound( 1 );
	pPlayer:DoMuzzleFlash();

	self:SendWeaponAnim( 180 );
	pPlayer:SetAnimation( 5 );
	ToHL2MPPlayer(pPlayer):DoAnimationEvent( 0 );

	self.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.1;
	self.m_flNextSecondaryAttack = gpGlobals.curtime() + 0.100;

	self.m_iClip1 = self.m_iClip1 - 1;

	local vecSrc		= pPlayer:Weapon_ShootPosition();
	local vecAiming		= pPlayer:GetAutoaimVector( 0.08715574274766 );


	-- vecSrc - position of fire, vecAiming - Directory where is shooting, bullet spread, distance, Ammo Type
	local info = FireBulletsInfo_t(1, vecSrc, vecAiming, vec3_origin,4096, self.m_iPrimaryAmmoType);
	info.m_flDamage = 30;
	info.m_pAttacker = pPlayer;
	info.m_iPlayerDamage = 14
	

	-- Fire the bullets, and force the first shot to be perfectly accuracy
	pPlayer:FireBullets( info );

	--Disorient the player
	local angles = pPlayer:GetLocalAngles();

	angles.x = angles.x + random.RandomInt( -1, 1 );
	angles.y = angles.y + random.RandomInt( -1, 1 );
	angles.z = 0;

if not _CLIENT then
	pPlayer:SnapEyeAngles( angles );
end

	pPlayer:ViewPunch( QAngle( -0.5, random.RandomFloat( -1, 1 ), 0 ) );

	if ( self.m_iClip1 == 0 and pPlayer:GetAmmoCount( self.m_iPrimaryAmmoType ) <= 0 ) then
		-- HEV suit - indicate out of ammo condition
		pPlayer:SetSuitUpdate( "!HEV_AMO0", 0, 0 );
	end
end

function SWEP:Initialize()
    self.m_bZoom = false
end

function SWEP:SecondaryAttack()
	self.m_nBody = 1
    self:SendWeaponAnim( 210 ); -- 210 is ACT_VM_ATTACH_SILENCER
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
	return 171;
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