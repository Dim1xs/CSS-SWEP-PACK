--//SWEP CREATED BY DIM1XS

SWEP.Name = "[CSS] M3 SUPER90"

SWEP.PrintName				= "M3 SUPER90"
SWEP.ViewModel				= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"
SWEP.ViewModelFOV           = 70
SWEP.anim_prefix			= "shotgun"
SWEP.Slot				= 3
SWEP.SlotPos		= 0

SWEP.ViewKick = 7

SWEP.Primary = 
{
	ClipSize = 7,
	DefaultClip = 7,
	Automatic = false,
	Ammo = "Buckshot"
}
	

SWEP.Weight					= 7
SWEP.item_flags				= 0

SWEP.damage					= 45

SWEP.SoundData				=
{
	empty=			"Weapon_Shotgun.Empty",
	reload=			"addons/m3_insertshell.wav",
	special1 =			"",
		single_shot=		"addons/weapons/m3/m3-1.wav",
		double_shot=		"addons/m3-1.wav",
		-- NPC WEAPON SOUNDS
		reload_npc=		"Weapon_Shotgun.NPC_Reload",
		single_shot_npc=	"Weapon_Shotgun.NPC_Single",
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
	{ ACT_RANGE_ATTACK1,				ACT_RANGE_ATTACK_SHOTGUN,				true },
	{ ACT_RELOAD,						ACT_RELOAD_SHOTGUN,						true },
	{ ACT_IDLE,				        	ACT_IDLE_SMG1,							true },
	{ ACT_IDLE_ANGRY,					ACT_IDLE_ANGRY_SHOTGUN,					true },
	{ ACT_WALK,					    	ACT_WALK_RIFLE,							true },
	
	{ ACT_HL2MP_IDLE,					ACT_HL2MP_IDLE_SHOTGUN,					false },
	{ ACT_HL2MP_RUN,					ACT_HL2MP_RUN_SHOTGUN,					false },
	{ ACT_HL2MP_IDLE_CROUCH,			ACT_HL2MP_IDLE_CROUCH_SHOTGUN,			false },
	{ ACT_HL2MP_WALK_CROUCH,			ACT_HL2MP_WALK_CROUCH_SHOTGUN,			false },
	{ ACT_HL2MP_GESTURE_RANGE_ATTACK,	ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,	false },
	{ ACT_HL2MP_GESTURE_RELOAD,			ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,		false },
	{ ACT_HL2MP_JUMP,					ACT_HL2MP_JUMP_SHOTGUN,					false },
	{ ACT_RANGE_ATTACK1,				ACT_RANGE_ATTACK_SHOTGUN,				false },
    { ACT_MP_STAND_IDLE,				ACT_HL2MP_IDLE_SHOTGUN,					false },
	{ ACT_MP_CROUCH_IDLE,				ACT_HL2MP_IDLE_CROUCH_SHOTGUN,			false },

	{ ACT_MP_RUN,						ACT_HL2MP_RUN_SHOTGUN,					false },
	{ ACT_MP_CROUCHWALK,				ACT_HL2MP_WALK_CROUCH_SHOTGUN,			false },

	{ ACT_MP_ATTACK_STAND_PRIMARYFIRE,	ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,	false },
	{ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE,	ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,	false },

	{ ACT_MP_RELOAD_STAND,				ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,		false },
	{ ACT_MP_RELOAD_CROUCH,				ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,		false },

	{ ACT_MP_JUMP,						ACT_HL2MP_JUMP_SHOTGUN,					false },

};

function SWEP:Initialize()
	self.m_bReloadsSingly	=  true;
	self.m_bFiresUnderwater	= false;
	self.m_bNeedPump = false;
	self.m_bInReload = false;
	function self.Pump() --Make Pump Animation like original shotgun
			local pPlayer = self:GetOwner();

	if ( pOwner == NULL ) then
		return
	end
	
	
	self:WeaponSound( 11 ); -- Special1 Sound

	-- Finish reload animation
	self:SendWeaponAnim( 268 );
	end
	
	
end

function SWEP:Precache()
end

	local MAX_TRACE_LENGTH = 1.732050807569 * (2*16384);
function SWEP:PrimaryAttack()
	-- Only the player fires this way so we can cast
	local pPlayer = self:GetOwner();

	if ( ToBaseEntity( pPlayer ) == NULL ) then
		return;
	end

	-- Check if we have ammo in clip else reload if we dont have ammo then dont reload 
	if ( self.m_iClip1 <= 0 ) then
			self:WeaponSound( 0 );
			self.m_flNextPrimaryAttack = 0.15;
	

		return;
	end

	self:WeaponSound( 1 );
	pPlayer:DoMuzzleFlash();

	self:SendWeaponAnim( 180 );
	pPlayer:SetAnimation( 5 );
	ToHL2Player(pPlayer):DoAnimationEvent( 0 );


	self.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.76;
	self.m_flNextSecondaryAttack = gpGlobals.curtime() + 0.76;
	local vecSrc		= pPlayer:Weapon_ShootPosition();
	local vecAiming		= pPlayer:GetAutoaimVector( 0.08715574274766 );

	-- vecSrc - position of fire, vecAiming - Directory where is shooting, Vector - bullet spread, number - distance, self.m_iPrimaryAmmoType - Ammo Type 
	local info = FireBulletsInfo_t(7, vecSrc, vecAiming, Vector( 0.08716, 0.08716, 0.08716 ),8096, self.m_iPrimaryAmmoType)
	info.m_flDamage = 3;
	info.m_pAttacker = pPlayer;	-- Who shoots?
	info.m_iPlayerDamage = 3; -- Damage of single bullet
	pPlayer:FireBullets( info ); -- Fire!!!
	
	
	self.m_iClip1 = self.m_iClip1 - 1;
	if(self.m_iClip1) then
		self.m_bNeedPump = true
	end

	local viewkick = QAngle()
	viewkick.x = -(self.ViewKick * 0.30)--//SLIDE LIMIT
	viewkick.y = random.RandomFloat(2 + self.ViewKick, -2 + -self.ViewKick) * 0.18 --//VERTICAL LIMIT
	viewkick.z = 0

	pPlayer:ViewPunch( viewkick )-- Some Recoil
	if ( self.m_iClip1 == 0 and pPlayer:GetAmmoCount( self.m_iPrimaryAmmoType ) <= 0 ) then
		-- HEV suit - indicate out of ammo condition
		pPlayer:SetSuitUpdate( "!HEV_AMO0", 0, 0 );
	end
end

function SWEP:SecondaryAttack()
	--//SWEP CREATED BY DIM1XS
end

function SWEP:Reload()

	local pOwner = self:GetOwner();

	if ( ToBaseEntity( pOwner ) == NULL ) then
		return;
	end

	if (pOwner:GetAmmoCount(self.m_iPrimaryAmmoType) <=0) then
		return false;
	end

	if ( pOwner:GetAmmoCount( self.m_iPrimaryAmmoType ) > 0 ) then
	
		if ( self:Clip1() < self:GetMaxClip1() ) then 
		
			self:WeaponSound( 6 );
		ToHL2Player(self:GetOwner()):DoAnimationEvent( 3 );
			self.m_iClip1 = self.m_iClip1 + 1;
			pOwner:RemoveAmmo( 1, self.m_iPrimaryAmmoType );
		end
	end

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
--[=====[ 

-- This does not works properly as in c++ code :skull:
	local pOwner = self:GetOwner();

	if ( ToBaseEntity( pOwner ) == NULL ) then
		return;
	end

	if  self.m_bInReload then
		-- If I'm primary firing and have one round stop reloading and fire
		if (((pOwner.m_nButtons/1)%2 >= 1 ) and (m_iClip1 >=1)) then 
		
			self.m_bInReload		= false;
			self.m_bNeedPump		= false;
		end
		-- If I'm secondary firing and have one round stop reloading and fire
		else if (((pOwner.m_nButtons/2048)%2 >= 1 ) and (self.m_iClip1 >=2)) then
			m_bInReload		= false;
			m_bNeedPump		= false;
		
		else if (self.m_flNextPrimaryAttack <= gpGlobals:curtime()) then 
		
			-- If out of ammo end reload
			if (pOwner:GetAmmoCount(self.m_iPrimaryAmmoType) <=0) then
				self:FinishReload();
				return;
			end
			-- If clip not full reload again
			if (self.m_iClip1 < self:GetMaxClip1()) then
				self:Reload();
				return;
			
			-- Clip full, stop reloading
			else
				return;
			end
		end
	end
	end
--]=====]
	if ( (self.m_bNeedPump == true) and (self.m_flNextPrimaryAttack <= (gpGlobals:curtime() - 0.2)) ) then
	
		self.Pump();
	
	end

end

function SWEP:ItemBusyFrame()
end

function SWEP:DoImpactEffect()
end
--//SWEP CREATED BY DIM1XS