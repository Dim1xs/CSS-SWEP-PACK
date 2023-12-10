SWEP.Name = "[CSS] -Smoke Grenade"

SWEP.PrintName				= "Smoke Grenade"
SWEP.ViewModel				= "models/weapons/v_eq_smokegrenade.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_smokegrenade.mdl"
SWEP.ViewModelFOV           =  65
SWEP.anim_prefix			= "python"
SWEP.Slot				= 0
SWEP.SlotPos		= 0
SWEP.DrawAmmo = false
SWEP.Spawnable = true

SWEP.Primary = {
	ClipSize = 1,
	DefaultClip = 1,
	Automatic = false,
	Ammo = "None"
}



SWEP.Weight					= 7
SWEP.item_flags				= 0

SWEP.damage					= 75

SWEP.SoundData				=
{
	empty					= "Weapon_Pistol.Empty",
	single_shot				= "addons/weapons/pinpull.wav"
}

SWEP.showusagehint			= 0
SWEP.AutoSwitchTo			= 1
SWEP.AutoSwitchFrom			= 1
SWEP.BuiltRightHanded		= 0
SWEP.AllowFlipping			= 1
SWEP.MeleeWeapon			= 0

SWEP.m_acttable				=
{

	{ ACT_RANGE_ATTACK1,			ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE,						true },
	{ ACT_RELOAD,					ACT_HL2MP_GESTURE_RELOAD_MELEE,								true },
	{ ACT_IDLE,				        ACT_IDLE_MELEE,								true },
	{ ACT_IDLE_ANGRY,				ACT_IDLE_ANGRY_MELEE,							true },
	{ ACT_WALK,					    ACT_MP_WALK_MELEE,								true },


	{ ACT_HL2MP_IDLE,					ACT_HL2MP_IDLE_MELEE,						false },
	{ ACT_HL2MP_RUN,					ACT_HL2MP_RUN_MELEE,						false },
	{ ACT_HL2MP_IDLE_CROUCH,			ACT_HL2MP_IDLE_CROUCH_MELEE,				false },
	{ ACT_HL2MP_WALK_CROUCH,			ACT_HL2MP_WALK_CROUCH_MELEE,				false },
	{ ACT_HL2MP_GESTURE_RANGE_ATTACK,	ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE,		false },
	{ ACT_HL2MP_GESTURE_RELOAD,			ACT_HL2MP_GESTURE_RELOAD_MELEE,			false },
	{ ACT_HL2MP_JUMP,					ACT_HL2MP_JUMP_MELEE,						false },
	{ ACT_RANGE_ATTACK1,				ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE,					false },
    { ACT_MP_STAND_IDLE,				ACT_HL2MP_IDLE_MELEE,						false },
	{ ACT_MP_CROUCH_IDLE,				ACT_HL2MP_IDLE_CROUCH_MELEE,				false },

	{ ACT_MP_RUN,						ACT_HL2MP_RUN_MELEE,						false },
	{ ACT_MP_CROUCHWALK,				ACT_HL2MP_WALK_CROUCH_MELEE,				false },

	{ ACT_MP_ATTACK_STAND_PRIMARYFIRE,	ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE,		false },
	{ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE,	ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,		false },

	{ ACT_MP_RELOAD_STAND,				ACT_HL2MP_GESTURE_RELOAD_PISTOL,			false },
	{ ACT_MP_RELOAD_CROUCH,				ACT_HL2MP_GESTURE_RELOAD_PISTOL,			false },

	{ ACT_MP_JUMP,						ACT_HL2MP_JUMP_PISTOL,						false },
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

	self:SendWeaponAnim( 180 );
	pPlayer:SetAnimation( 5 );
	ToHL2Player(pPlayer):DoAnimationEvent( 0 );

	self.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.01;
	self.m_flNextSecondaryAttack = gpGlobals.curtime() + 0.1;


	local vecSrc		= pPlayer:Weapon_ShootPosition();
	local vecAiming		= pPlayer:GetAutoaimVector( 0.08715574274766 );

	local forward = Vector()
	local right = Vector()
	local up = Vector()
	
	pPlayer:EyeVectors(forward,right,up)

	if not _CLIENT then
		local ent = CreateEntityByName("prop_css_smokegrenade")
		if ent ~= NULL or ent ~= nil then
			ent:SetLocalOrigin(vecSrc + forward * 16)
			ent.m_nSkin = 1;
			ent:Spawn()		
			local phys = ent:VPhysicsGetObject()
			if phys ~= nil then
				phys:SetVelocity(forward * 748,forward * 748)
			end
		end
	end


if not _CLIENT then
	if(self ~= nil or self ~= NULL) then
		pPlayer:HideViewModels();
		UTIL.Remove(self)
	end
end
end

function SWEP:SecondaryAttack()
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


	local vecSrc		= pPlayer:Weapon_ShootPosition();
	local vecAiming		= pPlayer:GetAutoaimVector( 0.08715574274766 );

	local forward = Vector()
	local right = Vector()
	local up = Vector()
	
	pPlayer:EyeVectors(forward,right,up)

	if not _CLIENT then
		local ent = CreateEntityByName("prop_css_smokegrenade")
		if ent ~= NULL or ent ~= nil then
			ent:SetLocalOrigin(vecSrc + forward * 16)
			ent.m_nSkin = 1;
			ent:Spawn()		
			local phys = ent:VPhysicsGetObject()
			if phys ~= nil then
				phys:SetVelocity(forward * 348,forward * 348)
			end
		end
	end


if not _CLIENT then
	if(self ~= nil or self ~= NULL) then
		pPlayer:HideViewModels();
		UTIL.Remove(self)
	end
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
