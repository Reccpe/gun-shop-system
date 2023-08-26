surface.CreateFont( "font31", {
	font = "Tahoma", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 45,
	weight = 400,
} )

surface.CreateFont( "fontMarket", {
	font = "Tahoma", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 15,
	weight = 400,
} )

include("shared.lua")

local scrw,scrh = ScrW(),ScrH()
local X, Y = -124, -466
local W, H = 389, 126 
local tabanca = Material("materials/tabanca.png", "noclamp")
local para = Material("materials/para.png")
local ak47 = Material("materials/ak47.png")

function ENT:Draw()
    self:DrawModel()

    local Ang = self:GetAngles()
    local Pos = self:GetPos()
    
    // TOP PANEL
    if self:GetPos():Distance(LocalPlayer():GetPos()) > 4000 then return end

    Ang:RotateAroundAxis(Ang:Forward(),90)
    Ang:RotateAroundAxis(Ang:Right(),-90)

    cam.Start3D2D(Pos,Ang,0.39)
        draw.RoundedBox(50,-390,-410,380,45,Color(255,0,0))
        surface.SetMaterial(tabanca)
        surface.SetDrawColor(211,211,211)
        surface.DrawTexturedRect(-360,-412,45,45)
        draw.SimpleText("Silah Marketi", "font31",-180,-390,Color(211,211,211),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    cam.End3D2D()

end 

net.Receive("vgui_menu_open", function()
    if ( IsValid ( SILAHMENU )) then
        SILAHMENU:SetVisible( true )
        return 
    end

    SILAHMENU = vgui.Create("DFrame")
    SILAHMENU:SetDraggable( false )
    SILAHMENU:SetSize(scrw * .30,scrh * .8)
    SILAHMENU:SetSizable( false )
    SILAHMENU:MakePopup()
    SILAHMENU:Center()
    SILAHMENU:SetTitle("")
    SILAHMENU.Paint = function(self,w,h)
        surface.SetDrawColor(32,32,32)
        surface.DrawRect(0,0,w,h)
    end 

    local scrollPaneli = vgui.Create("DScrollPanel",SILAHMENU)
    scrollPaneli:Dock(FILL)

    local frameW = SILAHMENU:GetWide()
    local frameH = SILAHMENU:GetTall()
    local yspace = frameH * .01
    for k,itemData in pairs(SILAHMARKET.Items) do
        local itemPaneli = vgui.Create("DPanel",scrollPaneli)
        itemPaneli:DockMargin(0,0,0,20,yspace)
        itemPaneli:Dock(TOP)
        itemPaneli:SetTall(frameH * .087)
        itemPaneli.Paint = function(self,w,h)
            surface.SetDrawColor(64,64,64)
            surface.DrawRect(0,0,w,h)
            surface.SetMaterial( ak47 )
            surface.DrawTexturedRect(15,-40,130,150)
            draw.SimpleText(itemData.name,"fontMarket",w * .3, h * .03)
            draw.SimpleText(DarkRP.formatMoney(itemData.price),"fontMarket",w * .33,h * .6,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
        local marginBosluk = frameW * .029
        local satinAlButton = vgui.Create("DButton", itemPaneli)
        satinAlButton:Dock(RIGHT)
        satinAlButton:SetWide(130)
        satinAlButton:DockMargin(0,marginBosluk,marginBosluk,marginBosluk)
        satinAlButton:SetText("")
        satinAlButton.Paint = function(self,w,h)
            surface.SetDrawColor(56,107,22)
            surface.DrawRect(0,0,w,h)
            draw.SimpleText("Satın al","fontMarket",42,15,color_white)
        end
        satinAlButton.DoClick = function()
            net.Start("satin_alim")
            net.WriteInt(k,32)
            net.SendToServer()
        end
    end
end)