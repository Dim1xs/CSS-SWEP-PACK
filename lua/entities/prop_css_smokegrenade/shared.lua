
ENT.Type = "CPhysicsProp"
ENT.Name = "[CSS] Smoke Grenade"

function ENT:Initialize()
	if ( not _CLIENT ) then
		self.m_nSkin = 1;
		local EntModel = "models/weapons/w_eq_smokegrenade.mdl"
		local allowPrecache = self.IsPrecacheAllowed();
		self.SetAllowPrecache( true );
		self.PrecacheModel( EntModel  );
		self:SetModel( EntModel )
		self.SetAllowPrecache( allowPrecache );
		self.PrecacheSound("addons/weapons/smokegrenade/sg_explode.wav")
		--self.PrecacheSound("addons/weapons/c4/c4_plant.wav")
		self.GoingExplode = gpGlobals.curtime() + 4.048;
		self:SetMoveType( 0 )
		--self:EmitSound("addons/weapons/c4/c4_plant.wav")
		
		function self.Explode() 
			self:EmitSound("addons/weapons/smokegrenade/sg_explode.wav")
			self:VPhysicsInitNormal( 0, 0, false );
			print("Explosion!")
			local ent = CreateEntityByName("env_smoketrail")
			if ent ~= nil then
			ent:SetLocalOrigin(self:GetLocalOrigin())
			--ent:KeyValue("iMagnitude", "80");
			ent:KeyValue("smokesprite","sprites/whitepuff.spr")
			ent:KeyValue("firesprite","sprites/firetrail.spr")
			ent:KeyValue("spawnradius","105")
			ent:KeyValue("endsize","175")
			ent:KeyValue("startcolor","225 225 225")
			ent:KeyValue("endcolor","255 255 255")
			ent:KeyValue("lifetime","20")
			ent:KeyValue("emittime", "20")
			ent:KeyValue("spawnrate","20")
			ent:KeyValue("opacity","0.85")
			--ent:KeyValue("iRadiusOverride", "75")
			ent:Spawn();
			ent:AcceptInput("explode",NULL,NULL,100);
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
	
end

