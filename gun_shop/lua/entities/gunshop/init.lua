AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/props_industrial/warehouse_shelf001.mdl")
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
       phys:Wake() 
    end
end 

util.AddNetworkString("vgui_menu_open")

function ENT:Use(activator,caller)
    if ( IsValid ( caller )) then
        if ( activator:IsPlayer() ) then
            net.Start("vgui_menu_open")
            net.Send( caller )
        end
    end
end 

util.AddNetworkString("satin_alim")

net.Receive("satin_alim", function(len,ply)
    
    local id = net.ReadInt(32)
    local itemData = SILAHMARKET.Items[id]
    if not itemData then return end

    local canAfford = ply:canAfford(itemData.price)
    if not canAfford then
           ply:ChatPrint("[-] Senin bunu ödeyecek kadar paran yok")
       return 
    end
    
    ply:addMoney(-itemData.price)
    ply:Give(itemData.id)
    ply:ChatPrint("[+] Satın alım başarıyla gerçekleştirildi hayırlı olsun !")
end)

