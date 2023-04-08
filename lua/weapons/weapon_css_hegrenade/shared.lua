

SWEP.printname				= "HE Grenade CSS"
SWEP.viewmodel				= "models/weapons/v_eq_fraggrenade.mdl"
SWEP.playermodel			= "models/weapons/w_eq_fraggrenade.mdl"
SWEP.viewmodelfov           =  65
SWEP.anim_prefix			= "python"
SWEP.bucket					= 0
SWEP.bucket_position		= 2

SWEP.clip_size				= 100
SWEP.clip2_size				= 50
SWEP.default_clip			= -1
SWEP.default_clip2			= -1
SWEP.primary_ammo			= "None"
SWEP.secondary_ammo			= "None"

SWEP.weight					= 7
SWEP.item_flags				= 0

SWEP.damage					= 75

SWEP.SoundData				=
{
	empty					= "Weapon_Pistol.Empty",
	single_shot				= "addons/css/pinpull.mp3"
}

SWEP.showusagehint			= 0
SWEP.autoswitchto			= 1
SWEP.autoswitchfrom			= 1
SWEP.BuiltRightHanded		= 0
SWEP.AllowFlipping			= 1
SWEP.MeleeWeapon			= 0

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
	self.PrecacheSound("addons/css/pinpull.mp3")
end

function SWEP:Precache()
end

function SWEP:PrimaryAttack()
	local pPlayer = self:GetOwner();

	if ( pPlayer == NULL) then
		return;
	end

	self:WeaponSound( 1 );
	pPlayer:DoMuzzleFlash();

	self:SendWeaponAnim( 180 );
	pPlayer:SetAnimation( 5 );
	ToHL2Player(pPlayer):DoAnimationEvent( 0 );

	self.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.01;
	self.m_flNextSecondaryAttack = gpGlobals.curtime() + 0.1;

	-- self.m_iClip1 = self.m_iClip1 - 1;

	local vecSrc		= pPlayer:Weapon_ShootPosition();
	local vecAiming		= pPlayer:GetAutoaimVector( 0.08715574274766 );

	local forward = Vector()
	local right = Vector()
	local up = Vector()
	
	pPlayer:EyeVectors(forward,right,up)

	local ent = ToCPhysicsProp(CreateEntityByName("prop_hegrenade_css"))
	if ent ~= NULL or ent ~= nil then
		ent:SetLocalOrigin(vecSrc + forward * 16)
		ent.m_nSkin = 1;
		ent:Spawn()		
		local phys = ent:VPhysicsGetObject()
		if phys ~= nil then
			phys:SetVelocity(forward * 748,forward * 748)
		end

		
	end

	
	local angles = pPlayer:GetLocalAngles();

	angles.x = angles.x + random.RandomInt( -1, 1 );
	angles.y = angles.y + random.RandomInt( -1, 1 );
	angles.z = 0;

if not _CLIENT then
	-- pPlayer:SnapEyeAngles( angles );
	if(self ~= nil or self ~= NULL) then
		pPlayer:HideViewModels();
		--pPlayer:RemovePlayerItem(self)
		--pPlayer:Weapon_Detach(self)
		--self:DestroyItem()
		UTIL.Remove(self) -- this actually works lmao these above were crashing game

	end
end

	--pPlayer:ViewPunch( QAngle( -2, random.RandomFloat( -0.1, 0.4 ), 0 ) );

	--if ( self.m_iClip1 == 0 and pPlayer:GetAmmoCount( self.m_iPrimaryAmmoType ) <= 0 ) then
		-- HEV suit - indicate out of ammo condition
	--	pPlayer:SetSuitUpdate( "!HEV_AMO0", 0, 0 );
	--end
end

function SWEP:SecondaryAttack()
	local pOwner = self:GetOwner();

	self.m_flNextSecondaryAttack = gpGlobals.curtime() + 1;
	if ( ToBaseEntity( pOwner ) == NULL ) then
		return;
	end
	local pPlayer = ToBasePlayer( pOwner )
	if ( pPlayer == NULL ) then
		return;
	end

	self:WeaponSound( 0 );
	local vecSrc		= pPlayer:Weapon_ShootPosition();
	local vecAiming		= pPlayer:GetAutoaimVector( 0.08715574274766 );

	local forward = Vector()
	local right = Vector()
	local up = Vector()
	
	pPlayer:EyeVectors(forward,right,up)

	local ent = ToCPhysicsProp(CreateEntityByName("prop_hegrenade_css"))
	if ent ~= NULL or ent ~= nil then
		ent:SetLocalOrigin(vecSrc + forward * 16)
		ent.m_nSkin = 1;
		ent:Spawn()		
		local phys = ent:VPhysicsGetObject()
		if phys ~= nil then
			phys:SetVelocity(forward * 256,forward * 256)
		end

		pPlayer:HideViewModels();
		UTIL.Remove(self)

    end
	
end

function SWEP:Reload()
	local fRet = self:DefaultReload( self:GetMaxClip1(), self:GetMaxClip2(), 182 );
	if ( fRet ) then
--		self:WeaponSound( 6 );
		ToHL2Player(self:GetOwner()):DoAnimationEvent( 3 );
	end
	return fRet;
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
