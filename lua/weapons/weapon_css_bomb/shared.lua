--/SWEP CREATED BY DIM1XS

SWEP.Name = "[CSS] C4"

SWEP.PrintName				= "С4"
SWEP.ViewModel				= "models/weapons/v_c4.mdl"
SWEP.WorldModel				= "models/weapons/w_c4.mdl"
SWEP.ViewModelFOV           =  65
SWEP.anim_prefix			= "python"
SWEP.Slot					= 0
SWEP.SlotPos				= 0
SWEP.DrawAmmo = false

SWEP.Primary = 
{
	ClipSize = 1,
	DefaultClip = 1,
	Automatic = false,
	Ammo = "Pistol"
}

SWEP.Weight					= 7
SWEP.item_flags				= 0

SWEP.damage					= 0

SWEP.SoundData				=
{
	empty					= "Weapon_Pistol.Empty",
	single_shot				= "addons/css/pinpull.mp3"
}

SWEP.showusagehint			= 0
SWEP.AutoSwitchTo			= 1
SWEP.AutoSwitchFrom			= 1
SWEP.BuiltRightHanded		= 0
SWEP.AllowFlipping			= 0
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
	self.Delay = 0
end

function SWEP:Precache()
end

function SWEP:PrimaryAttack()
	local pPlayer = self:GetOwner();

	if ( pPlayer == NULL) then
		return;
	end

	self:WeaponSound( 1 );
	self:SendWeaponAnim( 180 );
	pPlayer:SetAnimation( 5 );
	ToHL2Player(pPlayer):DoAnimationEvent( 0 );

	self.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.01;
	self.m_flNextSecondaryAttack = gpGlobals.curtime() + 0.1;
	self.Delay = gpGlobals.curtime() + 4

	-- self.m_iClip1 = self.m_iClip1 - 1;

	---------------------------------------
	local vecSrc = pPlayer:Weapon_ShootPosition()
	local vecAim = pPlayer:GetAutoaimVector(0.08715574274766)
	local vecEye = pPlayer:EyePosition();

	local vForward = Vector()
	local vRight = Vector()
	local vUp = Vector()
	pPlayer:EyeVectors(vForward,nil,nil);

	local tr = trace_t()
	UTIL.TraceLine( vecEye, vecEye + vForward * 20, MASK_SHOT_HULL, pPlayer, 0, tr );

	if not (_CLIENT) then
		local ent = CreateEntityByName("prop_css_bomb")
		if ent ~= NULL or ent ~= nil then
			ent:SetLocalOrigin(tr.endpos)
			ent.m_nSkin = 1;
			ent:Spawn()		
		end
	end

	if not _CLIENT then
		if(self ~= nil or self ~= NULL) then
		pPlayer:HideViewModels();
		UTIL.Remove(self)
	end
end

	--pPlayer:ViewPunch( QAngle( -2, random.RandomFloat( -0.1, 0.4 ), 0 ) );

	--if ( self.m_iClip1 == 0 and pPlayer:GetAmmoCount( self.m_iPrimaryAmmoType ) <= 0 ) then
		-- HEV suit - indicate out of ammo condition
	--	pPlayer:SetSuitUpdate( "!HEV_AMO0", 0, 0 );
	--end
end

function SWEP:SecondaryAttack()
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
--/SWEP CREATED BY DIM1XS