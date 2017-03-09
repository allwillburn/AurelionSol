local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "AurelionSol" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/AurelionSol/master/AurelionSol.lua', SCRIPT_PATH .. 'AurelionSol.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/AurelionSol/master/AurelionSol.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local AurelionSolMenu = Menu("AurelionSol", "AurelionSol")

AurelionSolMenu:SubMenu("Combo", "Combo")

AurelionSolMenu.Combo:Boolean("Q", "Use Q in combo", true)
AurelionSolMenu.Combo:Boolean("W", "Use W in combo", true)
AurelionSolMenu.Combo:Boolean("E", "Use E in combo", true)
AurelionSolMenu.Combo:Boolean("R", "Use R in combo", true)
AurelionSolMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
AurelionSolMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
AurelionSolMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
AurelionSolMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
AurelionSolMenu.Combo:Boolean("RHydra", "Use RHydra", true)
AurelionSolMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
AurelionSolMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
AurelionSolMenu.Combo:Boolean("Randuins", "Use Randuins", true)


AurelionSolMenu:SubMenu("AutoMode", "AutoMode")
AurelionSolMenu.AutoMode:Boolean("Level", "Auto level spells", false)
AurelionSolMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
AurelionSolMenu.AutoMode:Boolean("Q", "Auto Q", false)
AurelionSolMenu.AutoMode:Boolean("W", "Auto W", false)
AurelionSolMenu.AutoMode:Boolean("E", "Auto E", false)
AurelionSolMenu.AutoMode:Boolean("R", "Auto R", false)

AurelionSolMenu:SubMenu("LaneClear", "LaneClear")
AurelionSolMenu.LaneClear:Boolean("Q", "Use Q", true)
AurelionSolMenu.LaneClear:Boolean("W", "Use W", true)
AurelionSolMenu.LaneClear:Boolean("E", "Use E", true)
AurelionSolMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
AurelionSolMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

AurelionSolMenu:SubMenu("Harass", "Harass")
AurelionSolMenu.Harass:Boolean("Q", "Use Q", true)
AurelionSolMenu.Harass:Boolean("W", "Use W", true)

AurelionSolMenu:SubMenu("KillSteal", "KillSteal")
AurelionSolMenu.KillSteal:Boolean("Q", "KS w Q", true)
AurelionSolMenu.KillSteal:Boolean("E", "KS w E", true)

AurelionSolMenu:SubMenu("AutoIgnite", "AutoIgnite")
AurelionSolMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

AurelionSolMenu:SubMenu("Drawings", "Drawings")
AurelionSolMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

AurelionSolMenu:SubMenu("SkinChanger", "SkinChanger")
AurelionSolMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
AurelionSolMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if AurelionSolMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if AurelionSolMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 650) then
				if target ~= nil then 
                                      CastSkillShot(_Q, target)
                                end
            end

            if AurelionSolMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 700) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if AurelionSolMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if AurelionSolMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if AurelionSolMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if AurelionSolMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if AurelionSolMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 3000) then
			 CastSpell(_E)
	    end

            if AurelionSolMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 650) then
		     if target ~= nil then 
                         CastSkillShot(_Q, target)
                     end
            end

            if AurelionSolMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if AurelionSolMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if AurelionSolMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if AurelionSolMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 700) then
			CastSpell(_W)
	    end
	    
	    
            if AurelionSolMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 1300) and (EnemiesAround(myHeroPos(), 1300) >= AurelionSolMenu.Combo.RX:Value()) then
			CastSkillShot(_R, target)
            end

          end

        function Qorb()
  local target = GetCurrentTarget()
  if target ~= nil and qCasting then
    local pos = myHero - (Vector(target) - myHero):normalized() * 700
    if GetDistance(myHero, target) >= 307.5 then
      MoveToXYZ(GetOrigin(target))
    elseif GetDistance(myHero, target) <= 700 then
      MoveToXYZ(pos)
    end
  end
end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 650) and AurelionSolMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastSkillShot(_Q, target)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 187) and AurelionSolMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSpell(_E)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if AurelionSolMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 650) then
	        	CastSkillShot(_Q, closeminion)
                end

                if AurelionSolMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 700) then
	        	CastSpell(_W)
	        end

                if AurelionSolMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 3000) then
	        	CastSpell(_E)
	        end

                if AurelionSolMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if AurelionSolMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if AurelionSolMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 650) then
		      CastSkillShot(_Q, target)
          end
        end 
        if AurelionSolMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 700) then
	  	      CastSpell(_W)
          end
        end
        if AurelionSolMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 3000) then
		      CastSpell(_E)
	  end
        end
        if AurelionSolMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 700) then
		      CastSpell(_R)
	  end
        end
                
	--AUTO GHOST
	if AurelionSolMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if AurelionSolMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 700, 0, 200, GoS.Red)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        if unit.isMe and spell.name:lower():find("AurelionSolempowertwo") then 
		Mix:ResetAA()	
	end        

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if AurelionSolMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>AurelionSol</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





