localPath = scriptPath()
dofile(localPath.."ffbe_common.lua")

function checkBattle()
    exploreBattle("4354.png", "11047.png")
end

-- Main Loop
while true do
    -- Wander
    click(Location(200, 640))
    checkBattle()
    click(Location(400, 500))
    checkBattle()
    click(Location(600, 640))
    checkBattle()
    click(Location(400, 740))
    checkBattle()
end