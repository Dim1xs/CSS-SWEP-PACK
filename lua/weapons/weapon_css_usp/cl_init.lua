
include( "shared.lua" )

function SWEP:DrawLargeWeaponBox( bSelected, xpos, ypos, boxWide, boxTall, selectedColor, alpha, number )
end

function SWEP:DrawModel( flags )
	return ACT_VM_DRAW_SILENCED
end

function SWEP:MuzzleFlash( pos1, angles, type, firstPerson )
end
