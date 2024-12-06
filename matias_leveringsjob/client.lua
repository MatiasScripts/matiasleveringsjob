-- Klient Script

Citizen.CreateThread(function()
    local config = Config
    local lastSpawnTime = 0
    local cooldownTime = config.CooldownTime
    local deliveryZoneRadius = config.DeliveryZoneRadius
    local spawnedVehicle = nil
    local deliveryBlip = nil
    local deliveryZoneCreated = false
    local randomDeliveryZone = nil

    function GetRandomDeliveryZone()
        local randomIndex = math.random(1, #config.DeliveryZones)
        return config.DeliveryZones[randomIndex]
    end

    RegisterNetEvent('matias:spawnVehicle', function()
        local currentTime = GetGameTimer()
        if currentTime - lastSpawnTime < cooldownTime then
            local remainingTime = math.ceil((cooldownTime - (currentTime - lastSpawnTime)) / 1000)
            TriggerEvent('ox_lib:notify', { type = 'error', description = 'Du kan først spawne en bil igen om ' .. remainingTime .. ' sekunder.' })
            return
        end

        lastSpawnTime = currentTime
        local model = `speedo`
        local coords = config.VehicleSpawnCoords
        local heading = config.VehicleHeading

        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end

        local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
        SetEntityAlpha(vehicle, 0, false)

        Citizen.CreateThread(function()
            local alpha = 0
            while alpha < 255 do
                Citizen.Wait(10)
                alpha = alpha + 5
                SetEntityAlpha(vehicle, alpha, false)
            end
        end)

        SetEntityAsMissionEntity(vehicle, true, true)
        SetModelAsNoLongerNeeded(model)
        spawnedVehicle = vehicle

        randomDeliveryZone = GetRandomDeliveryZone()
        SetNewWaypoint(randomDeliveryZone.x, randomDeliveryZone.y)

        deliveryBlip = AddBlipForCoord(randomDeliveryZone.x, randomDeliveryZone.y, randomDeliveryZone.z)
        SetBlipSprite(deliveryBlip, 478)
        SetBlipColour(deliveryBlip, 2)
        SetBlipScale(deliveryBlip, 1.0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Afleveringssted")
        EndTextCommandSetBlipName(deliveryBlip)

        RegisterNetEvent('deliverVehicle', function()
            if deliveryBlip then
                RemoveBlip(deliveryBlip)
                deliveryBlip = nil
            end
        end)

        TriggerEvent('ox_lib:notify', { type = 'success', description = 'Kør til afleveringsstedet, men pas på politiet, bilen er stjålet!' })

        if not deliveryZoneCreated then
            CreateDeliveryZone()
            deliveryZoneCreated = true
        end
    end)

    function CreateDeliveryZone()
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)

                if deliveryBlip then
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, randomDeliveryZone.x, randomDeliveryZone.y, randomDeliveryZone.z)

                    DrawMarker(27, randomDeliveryZone.x, randomDeliveryZone.y, randomDeliveryZone.z - 1, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 7, 73, 227, 100, false, true, 2, false, false, false, false)

                    if distance < deliveryZoneRadius then
                        SetTextScale(0.5, 0.5)
                        SetTextFont(4)
                        SetTextProportional(false)
                        SetTextColour(255, 255, 255, 255)
                        SetTextEntry("STRING")
                        AddTextComponentString("Tryk ~b~[E]~w~ for at aflevere bilen.")
                        DrawText(0.8, 0.5)

                        if IsControlJustPressed(0, 38) then
                            DeliverVehicle()
                        end
                    else
                        ClearAllHelpMessages()
                    end
                else
                    ClearAllHelpMessages()
                end
            end
        end)
    end

    function DeliverVehicle()
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if DoesEntityExist(vehicle) and vehicle == spawnedVehicle then
            Citizen.CreateThread(function()
                local alpha = 255
                while alpha > 0 do
                    Citizen.Wait(10)
                    alpha = alpha - 5
                    SetEntityAlpha(vehicle, alpha, false)
                end

                DeleteEntity(vehicle)
            end)

            TriggerServerEvent('matias:giveItem', 'money', config.RewardAmount)
            TriggerEvent('ox_lib:notify', { type = 'success', description = 'Godt arbejde!' })
            TriggerEvent('deliverVehicle')
        else
            TriggerEvent('ox_lib:notify', { type = 'error', description = 'Vi godtager ikke denne bil!' })
        end
    end

    exports.ox_target:addSphereZone({
        coords = config.NPCSpawnCoords,
        radius = 2.0,
        debug = false,
        options = {
            {
                name = 'spawnVehicle',
                event = 'matias:spawnVehicle',
                icon = 'fa-solid fa-car',
                label = 'Spawn en bil',
            },
        },
    })

    Citizen.CreateThread(function()
        local model = config.NPCModel
        local coords = config.NPCSpawnCoords
        local heading = 269.0945
    
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
    
        -- Spawne NPC'en
        local npc = CreatePed(4, model, coords.x, coords.y, coords.z, heading, false, true)
        
        SetEntityAsMissionEntity(npc, true, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        SetPedFleeAttributes(npc, 0, false)
        SetPedCombatAttributes(npc, 46, true)
        SetPedCanRagdoll(npc, false)
    
        SetPedCombatAbility(npc, 0)
        SetPedCombatRange(npc, 0)
        SetPedCombatMovement(npc, 0)
    
        SetEntityCanBeDamaged(npc, false)
    
        SetEntityCollision(npc, true, true) 
    
        SetEntityCoordsNoOffset(npc, coords.x, coords.y, coords.z, true, true, true)
    
        TaskStandStill(npc, -1)
        ClearPedTasksImmediately(npc)
    end)
    
end)
