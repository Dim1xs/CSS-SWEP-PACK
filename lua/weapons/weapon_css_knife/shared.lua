--/SWEP CREATED BY DIM1XS

SWEP.Name = "[CSS] Knife"

SWEP.PrintName				= "Knife"
SWEP.ViewModel				= "models/weapons/v_knife_t.mdl"
SWEP.WorldModel			= "models/weapons/w_knife_t.mdl"
SWEP.ViewModelFOV           =  65
SWEP.anim_prefix			= "python"
SWEP.Slot				= 1
SWEP.SlotPos		= 0
SWEP.DrawAmmo = false

SWEP.Primary =
{
	ClipSize = 1,
	DefaultClip = 1,
	Automatic = true,
	Ammo = "Pistol"
}

SWEP.Weight					= 7
SWEP.item_flags				= 0

SWEP.damage					= 25

SWEP.SoundData				=
{
	empty					= "Weapon_Pistol.Empty",
	single_shot				= "addons/css/knife_slash.mp3"
}

SWEP.showusagehint			= 0
SWEP.AutoSwitchTo			= 1
SWEP.AutoSwitchFrom			= 1
SWEP.BuiltRightHanded		= 0
SWEP.AllowFlipping			= 0
SWEP.MeleeWeapon			= 0

-- TODO; implement Activity enum library!!
SWEP.m_acttable				=
{
	{ 1048, 977, false },
	{ 1049, 979, false },

	{ 1058, 978, false },
	{ 1061, 980, false },

	{ 1073, 981, false },
	{ 1077, 981, false },

	{ 1090, 982, false },
	{ 1093, 982, false },

	{ 1064, 983, false },
};

function SWEP:Initialize()
	self.m_bReloadsSingly	= false;
	self.m_bFiresUnderwater	= false;
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
			self.m_flNextPrimaryAttack = 0.1;
		end

		return;
	end

	self:WeaponSound( 1 );
	pPlayer:DoMuzzleFlash();

	self:SendWeaponAnim( 190 );
	pPlayer:SetAnimation( 5 );
	ToHL2MPPlayer(pPlayer):DoAnimationEvent( 0 );

	self.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.36;
	self.m_flNextSecondaryAttack = gpGlobals.curtime() + 0.75;

--	self.m_iClip1 = self.m_iClip1 - 1;

	local vecSrc		= pPlayer:Weapon_ShootPosition();
	local vecAiming		= pPlayer:GetAutoaimVector( 0.08715574274766 );


	-- vecSrc - position of fire, vecAiming - Directory where is shooting, bullet spread, distance, Ammo Type
	local info = FireBulletsInfo_t(1, vecSrc, vecAiming, vec3_origin,48, self.m_iPrimaryAmmoType);
	info.m_flDamage = 25;
	info.m_pAttacker = pPlayer;
	info.m_iPlayerDamage = 25
	

	-- Fire the bullets, and force the first shot to be perfectly accuracy
	pPlayer:FireBullets( info );
	
	info.flDistance = 128

	--Disorient the player
	local angles = pPlayer:GetLocalAngles();

	angles.x = angles.x + random.RandomInt( -1, 1 );
	angles.y = angles.y + random.RandomInt( -1, 1 );
	angles.z = 0;

if not _CLIENT then
	--pPlayer:SnapEyeAngles( angles );
end

	--pPlayer:ViewPunch( QAngle( 0, random.RandomFloat( -0, -0 ), 0 ) );

	if ( self.m_iClip1 == 0 and pPlayer:GetAmmoCount( self.m_iPrimaryAmmoType ) <= 0 ) then
		-- HEV suit - indicate out of ammo condition
		pPlayer:SetSuitUpdate( "!HEV_AMO0", 0, 0 );
	end
end

function SWEP:SecondaryAttack()
	self:SendWeaponAnim( 63 );
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
end

function SWEP:ItemPostFrame()
end

function SWEP:ItemBusyFrame()
end

function SWEP:DoImpactEffect()
end
--/SWEP CREATED BY DIM1XS