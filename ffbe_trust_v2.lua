Settings:setCompareDimension(true, 800)
Settings:setScriptDimension(true, 800)
similarValue = 0.9
waitingTime = 3 -- second
t = 0
regAuto = Region(0, 1183, 200, 97)

function checkConnection()
    local reg = Region(50, 445, 703, 434)
    while true do
        if reg:exists(Pattern("connection_error.png"):similar(similarValue), 2) then
            reg:existsClick(Pattern("ok.png"):similar(similarValue), 2)
        else
            break
        end
    end
end

function checkCrash()
    local regDesktop = Region(23, 123, 757, 422)
    if regDesktop:exists(Pattern("ffbe_icon.png"):similar(similarValue), waitingTime) then
        click(regDesktop:getLastMatch())
        
        local reg = Region(208, 957, 384, 70)
        while true do
            if reg:exists(Pattern("tap_to_start.png"):similar(similarValue), waitingTime) then
                click(reg:getLastMatch())
                return true
            end
        end
    end
end

-- For the achievement of Item-Used
function trophyItem()
    local dst = {Location(69, 809), Location(69, 950), Location(69, 1100), Location(472, 809), Location(472, 950)}
    local src = {Location(337, 809), Location(337, 950), Location(337, 1100), Location(751, 809), Location(751, 950)}
    for i, m in ipairs(src) do
        swipe(src[i], dst[i])
        sleep(0.5)
        -- choose the 1st item (should be Potion)
        click(dst[1])
        sleep(0.5)
        -- apply on the 1st unit
        click(dst[1])
        sleep(0.5)
    end
    -- Click AUTO twice
    click(Location(97,1234))
    sleep(0.5)
    click(Location(97,1234))
    -- Wait until REPEAT is click-able, then click REPEAT
    -- It will repeat until 10 potions is running out and then start normal attack
    while true do
        if exists(Pattern("repeat.png"):similar(similarValue), 1) then
            click(getLastMatch())
            sleep(0.5)
        else
            break
        end
    end
end

function battle()
    -- Choose the first companion
    if exists(Pattern("select_companion.png"):similar(similarValue), 5) then
        click(Location(385, 485))
    end

    -- Click Start
    if exists(Pattern("depart.png"):similar(similarValue), waitingTime) then
        existsClick(Pattern("depart.png"):similar(similarValue), waitingTime)
    end

    local count = 0
    -- Click Auto after battle started
    while true do
        if regAuto:exists(Pattern("auto.png"):similar(similarValue), waitingTime) then
            sleep(0.5)
            trophyItem()
            break
        end
    
        count = count + 1
      
        if count >= 20 then
            checkConnection()
            if checkCrash() then
                -- jump out of this function so that it can restart to loop
                return
            end
        end
    end

    count = 0
    -- Wait until battle ended
    while true do
        if regAuto:exists(Pattern("auto.png"):similar(similarValue), 1) then
            click(regAuto:getLastMatch())
        end
        checkConnection()
	if exists(Pattern("rank_up.png"):similar(similarValue), waitingTime) then
            click(Location(375, 275))
            click(Location(375, 275))
        end
        if exists(Pattern("next.png"):similar(similarValue), waitingTime) then
            existsClick(Pattern("next.png"):similar(similarValue), 1)
	    break
        end
        
        count = count + 1
        
        if count >= 20 then
            checkConnection()
            if checkCrash() then
                -- jump out of this function so that it can restart to loop
                return
            end
        end
    end

    -- Click once to proceed
    if exists(Pattern("results.png"):similar(similarValue), waitingTime) then
        click(Location(375, 275))
        sleep(0.5)
        click(Location(375, 275))
        sleep(0.5)
        click(Location(375, 275))
    end
	
    count = 0
    -- Check items obtained
    if exists(Pattern("results_items.png"):similar(similarValue), 5) then
        click(Location(375, 275))
	while true do
	    if exists(Pattern("next_1.png"):similar(similarValue), waitingTime) then
                existsClick(Pattern("next_1.png"):similar(similarValue), waitingTime)
                break
	    end

            count = count + 1
        
            if count >= 20 then
                checkConnection()
                if checkCrash() then
                    -- jump out of this function so that it can restart to loop
                    return
                end
            end
	end
    end
	
    -- Check daily quest completed
    if exists(Pattern("daily_quest_completed.png"):similar(similarValue), 2) then
        existsClick(Pattern("close.png"):similar(similarValue), waitingTime)
    end
	
    -- Ignore friend request
    if exists(Pattern("dont_request.png"):similar(similarValue), 2) then
        existsClick(Pattern("dont_request.png"):similar(similarValue), waitingTime)
    end
	
    checkConnection()
    
    count = 0
    while true do
        if exists(Pattern("earth_shrine_entrance.png"):similar(similarValue), 1) then
            break
        end
        count = count + 1
        
        if count >= 20 then
            checkConnection()
            if checkCrash() then
                -- jump out of this function so that it can restart to loop
                return
            end
        end
    end
end

t = Timer()

-- Start Looping
while true do
    -- Enter Earth Shrine - Entrance
    existsClick(Pattern("earth_shrine_entrance.png"):similar(similarValue), waitingTime)
 
    -- Check if material capacity reached
    if exists(Pattern("capacity_reached.png"):similar(similarValue), 2) then
        scriptExit("背包滿了")
    end
 
    local regTest = Region(93, 420, 621, 130)
    -- Check if the energy is sufficient
    if regTest:exists(Pattern("insufficient_energy.png"):similar(similarValue), 1) then
        existsClick(Pattern("cancel_refill.png"):similar(similarValue), waitingTime)

        -- wait for 1 energy recovery
        sleep(150)
    else
        existsClick(Pattern("next_2.png"):similar(similarValue), waitingTime)
        
        battle()
    end
    
    if (t:check() > 6900) then
        scriptExit("1小時55分，自動停止")
    end
end
