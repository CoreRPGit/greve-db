-- Config
local passengerDriveBy = true
local driverDriveBy = false

-- State
local notifiedBlockedDriver = false

local function isDriver(ped, vehicle)
    return vehicle and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped
end

local function updateDriveBy()
    local ped = cache.ped
    local vehicle = cache.vehicle

    local canShoot = true

    if vehicle and vehicle ~= 0 then
        if isDriver(ped, vehicle) then
            canShoot = driverDriveBy
        else
            canShoot = passengerDriveBy
        end
    end

    -- Driveby state
    if LocalPlayer.state.driveBy ~= canShoot then
        LocalPlayer.state:set('driveBy', canShoot, true)
    end

    SetPlayerCanDoDriveBy(cache.playerId, canShoot)

    if vehicle and vehicle ~= 0 and isDriver(ped, vehicle) and not driverDriveBy then
        TriggerEvent('ox_inventory:disarm', true)
        notifiedBlockedDriver = false
    end
end

lib.onCache('vehicle', updateDriveBy)
lib.onCache('seat', updateDriveBy)

AddStateBagChangeHandler('driveBy', nil, function(bagName, _, value)
    if value == nil then return end

    local player = GetPlayerFromStateBagName(bagName)
    if player ~= PlayerId() then return end

    SetPlayerCanDoDriveBy(cache.playerId, value)
end)

AddEventHandler('ox_inventory:currentWeapon', function(weapon)
    if not weapon then return end

    local ped = cache.ped
    local vehicle = cache.vehicle

    if vehicle and vehicle ~= 0 and isDriver(ped, vehicle) and not driverDriveBy then
        TriggerEvent('ox_inventory:disarm', true)

        if not notifiedBlockedDriver then
            lib.notify({
                title = 'Drive-by',
                description = 'Du kan ikke utstyre våpen som sjåfør i kjøretøy',
                type = 'error'
            })
            notifiedBlockedDriver = true
        end
    else
        notifiedBlockedDriver = false
    end
end)

CreateThread(function()
    Wait(500)
    updateDriveBy()
end)