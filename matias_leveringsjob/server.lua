-- Server Script
local config = require("config")

RegisterNetEvent('matias:giveItem', function(itemName, amount)
    local source = source
    local success = exports.ox_inventory:AddItem(source, itemName, amount)

    if success then
        print(('Player [%s] modtog %d x %s'):format(source, amount, itemName))
    else
        print(('Player [%s] kunne ikke modtage item: %s'):format(source, itemName))
    end
end)
