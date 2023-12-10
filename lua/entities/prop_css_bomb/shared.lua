
ENT.Type = "CPhysicsProp"
ENT.Name = "[CSS] Bomb"

function ENT:Initialize()
	if ( not _CLIENT ) then
		self.m_nSkin = 1;
		local EntModel = "models/weapons/w_c4_planted.mdl"
		local allowPrecache = self.IsPrecacheAllowed();
		self.SetAllowPrecache( true );
		self.PrecacheModel( EntModel  );
		self:SetModel( EntModel )
		self.SetAllowPrecache( allowPrecache );
		self.PrecacheSound("addons/weapons/c4/c4_explode1.wav")
		self.PrecacheSound("addons/weapons/c4/c4_plant.wav")
		self.PrecacheSound("addons/weapons/c4/c4_beep5.wav")
		self.PrecacheSound("addons/weapons/c4/c4_beep1.wav")
		self.GoingExplode = gpGlobals.curtime() + 40;
		self.SoundExplode = gpGlobals.curtime() + 38;
		self.NextBeep = gpGlobals.curtime() + 1
		self:SetMoveType( 0 )
		self:EmitSound("addons/weapons/c4/c4_plant.wav")
		
		function self.Explode() 
			self:EmitSound("addons/weapons/c4/c4_explode1.wav")
			print("Explosion!")
			local ent = CreateEntityByName("env_explosion")
			if ent ~= nil then
			ent:SetLocalOrigin(self:GetLocalOrigin())
			ent:KeyValue("iMagnitude", "999");
			ent:KeyValue("iRadiusOverride", "200")
			ent:Spawn();
			ent:AcceptInput("explode",NULL,NULL,0);
			end
			self:Remove()
		end
	end
	
end

function ENT:Use(pActivator, pCaller,useType,value)
end

function ENT:StartTouch( pEntity )
end

function ENT:Touch( pEntity )
end

function ENT:EndTouch( pEntity )
end

function ENT:VPhysicsUpdate( pPhysics )
	
end

function ENT:Think()
	if self.GoingExplode < gpGlobals.curtime() then
		self:Explode()
	end
	
	if self.SoundExplode < gpGlobals.curtime() then
		self:EmitSound("addons/weapons/c4/c4_beep5.wav")
	end	

	if self.NextBeep < gpGlobals.curtime() then
		self.NextBeep = gpGlobals.curtime() + 1
		self:EmitSound("addons/weapons/c4/c4_beep1.wav")
	end
end


