Settings:setCompareDimension(true, 800)
Settings:setScriptDimension(true, 800)
similarValue = 0.9
waitingTime = 3 -- second

reg1 = Region(146, 375, 34, 20)
reg2 = Region(541, 375, 34, 20)
reg3 = Region(146, 600, 34, 20)
reg4 = Region(541, 600, 34, 20)
reg5 = Region(146, 824, 34, 20)
reg6 = Region(541, 824, 34, 20)
regList = {reg1, reg2, reg3, reg4, reg5, reg6}
regAuto = Region(0, 1183, 200, 97)

function cure(target)
    -- Click "Magic"
    existsClick(Pattern("magic.png"):similar(similarValue), waitingTime)
    -- Choose the 1st unit as the healer
    click(Location(146, 376))
    -- Search for "Curaja" and click
    if exists(Pattern("curaja.png"):similar(0.8), 1.5) then
        click(getLastMatch())
    else
        if exists(Pattern("cura.png"):similar(0.8), 1.5) then
            click(getLastMatch())
        else
            scriptExit("沒有超療傷或中療傷，治療失敗")
        end
    end
    
    -- Click on target
    click(Location(target.x, target.y))
    
    -- Click on Back
    existsClick(Pattern("backFromMenu.png"):similar(similarValue), waitingTime)
    
    -- Click on Back
    existsClick(Pattern("backFromMenu.png"):similar(similarValue), waitingTime)
    
    -- Click on Back
    existsClick(Pattern("backFromMenu.png"):similar(similarValue), waitingTime)

    -- Should return to menu page now
end


function poisona(target)
    -- Click "Magic"
    existsClick(Pattern("magic.png"):similar(similarValue), waitingTime)
    -- Choose the 1st unit as the healer
    click(Location(146, 376))
    -- Search for "poisona" and click
    if exists(Pattern("poisona.png"):similar(0.8), 1.5) then
        click(getLastMatch())
    else
        if exists(Pattern("esuna.png"):similar(0.8), 1.5) then
            click(getLastMatch())
        else
            scriptExit("沒有解毒或治療異常，解毒失敗")
        end
    end
    
    -- Click on target
    click(Location(target.x, target.y))
    
    -- Click on Back
    existsClick(Pattern("backFromMenu.png"):similar(similarValue), waitingTime)
    
    -- Click on Back
    existsClick(Pattern("backFromMenu.png"):similar(similarValue), waitingTime)
    
    -- Click on Back
    existsClick(Pattern("backFromMenu.png"):similar(similarValue), waitingTime)

    -- Should return to menu page now
end

function exploreBattle(zone1, zone2, ...)
    -- Check if enemies appear
    if regAuto:exists(Pattern("auto.png"):similar(similarValue), 0.5) then
        regEnemy = Region(0, 132, 446, 545)
        -- Check if any dangerous enemy appears
        for i, v in ipairs(arg) do
            if regEnemy:exists(Pattern(v):similar(0.7), 1) then
                click(regEnemy:getLastMatch())
            end
        end

        -- Click AUTO
        click(Location(100, 1231))
    
        -- Wait until battle ended
        while true do
            if exists(Pattern("results_explore.png"):similar(similarValue), waitingTime) then
                sleep(2)
                click(Location(375, 275))
                break
            end
        end
        
        -- Check if finished
        if exists(Pattern("menu.png"):similar(similarValue), 2) then
            existsClick(Pattern("menu.png"):similar(similarValue), waitingTime)
            reg = Region(8, 1002, 251, 73)
            if reg:exists(Pattern(zone1):similar(similarValue), 1) then 
                scriptExit("ZONE1完成！前進ZONE2吧！")
            end
            if reg:exists(Pattern(zone2):similar(similarValue), 1) then
                scriptExit("ZONE2完成！打王前記得踩點！")
            end
            
            -- Check if anyone is in danger
            for i, m in ipairs(regList) do
                if m:exists(Pattern("hp.png"):similar(similarValue), 0.5) then               
                    -- Cure if anyone's HP is lower than 30%
                    -- Ignore if anyone is dead
                    r1, g1, b1 = getColor(Location(m.x + 7, m.y + 25));
                    r2, g2, b2 = getColor(Location(m.x + 87, m.y + 25));
                    if g1 ~= 0 and g2 < 100 then
                        cure(m)
                    end
                    -- Poisona if poisoned
                    regStatus = Region(m.x - 127, m.y - 86, 60, 30)
                    if regStatus:exists(Pattern("poisoned.png"):similar(similarValue), 0.5) then
                        poisona(m)
                    end
                end
            end
            existsClick(Pattern("backFromMenu.png"):similar(similarValue), waitingTime)
        end
    end
end