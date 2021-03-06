local E, L, V, P, G = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local AB = E:GetModule('ActionBars');

local function FixExtraActionCD(cd)
	local start, duration = GetActionCooldown(cd:GetParent().action)
	E.OnSetCooldown(cd, start, duration, 0, 0)
end

--CHANGES:Lanrutcon:Removed WoD Stuff
function AB:Extra_SetAlpha()
	local alpha = E.db.actionbar.extraActionButton.alpha
	for i=1, ExtraActionBarFrame:GetNumChildren() do
		local button = _G["ExtraActionButton"..i]
		if button then
			button:SetAlpha(alpha)
		end
	end
end

--CHANGES:Lanrutcon:Removed WoD related stuff
function AB:SetupExtraButton()
	local holder = CreateFrame('Frame', nil, E.UIParent)
	holder:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, 150)
	holder:Size(ExtraActionBarFrame:GetSize())
	
	

	ExtraActionBarFrame:SetParent(holder)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint('CENTER', holder, 'CENTER')
	ExtraActionBarFrame.ignoreFramePositionManager  = true

	
	for i=1, ExtraActionBarFrame:GetNumChildren() do
		local button = _G["ExtraActionButton"..i]
		if button then
			button.noResize = true;
			button.pushed = true
			button.checked = true
			print(button:GetName());
			--self:StyleButton(button, true)	--CHANGES:Lanrutcon:CHECKOUT LATER WHAT'S GOING ON.
			button:SetTemplate()
			
			_G["ExtraActionButton"..i..'Icon']:SetDrawLayer('ARTWORK')
			local tex = button:CreateTexture(nil, 'OVERLAY')
			tex:SetTexture(0.9, 0.8, 0.1, 0.3)
			tex:SetInside()
			button:SetCheckedTexture(tex)
			
			if(button.cooldown and E.private.cooldown.enable) then
				E:RegisterCooldown(button.cooldown)
				button.cooldown:HookScript("OnShow", FixExtraActionCD)
			end
		end
	end
	

	if HasExtraActionBar() then
		ExtraActionBarFrame:Show();
	end
	
	AB:Extra_SetAlpha()
	E:CreateMover(holder, 'BossButton', L["Boss Button"], nil, nil, nil, 'ALL,ACTIONBARS');
end

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    else
      print(formatting .. tostring(v))
    end
  end
end