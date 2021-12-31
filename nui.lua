--[[
local Config = {}

Config.jobs = {
    'police',
    'ambulance'
}
]]

local display = false
ESX = nil
local PlayerData = {}

print(Config)

function loadPlayerData()
    ESX = nil
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    end)
end


RegisterCommand("shift", function(source, args)
    loadPlayerData()
    Citizen.Wait(0)
    local playerJob = ESX.PlayerData.job.name
    for n in pairs(Config.jobs) do
        Citizen.Wait(0)
        if playerJob == Config.jobs[n] then
            startAnim()
            Citizen.Wait(500)
            SetDisplay(true)
            return
        end 
    end
    chat('Your company doesn\'t use the shift register, so no pemission are grant', {255, 0, 0})
    
end)

RegisterCommand("shift:stop_ui", function(source, args)
    SetDisplay(false)
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
    Citizen.Wait(500)
    stopAnim()
end)

RegisterNUICallback("startShift", function(data)
    loadPlayerData()
    Citizen.Wait(0)
    local playerJob = ESX.PlayerData.job.name
    for n in pairs(Config.jobs) do
        Citizen.Wait(0)
        if playerJob == Config.jobs[n] then
            TriggerServerEvent('esx_shift:startShift', ESX.PlayerData)
        end 
    end
end)

RegisterNUICallback("endShift", function(data)
    loadPlayerData()
    Citizen.Wait(0)
    local playerJob = ESX.PlayerData.job.name
    for n in pairs(Config.jobs) do
        Citizen.Wait(0)
        if playerJob == Config.jobs[n] then
            TriggerServerEvent('esx_shift:endShift', ESX.PlayerData)
        end 
    end
end)

RegisterNUICallback("allMineShifts", function(data)
    loadPlayerData()
    Citizen.Wait(0)
    local playerJob = ESX.PlayerData.job.name
    for n in pairs(Config.jobs) do
        Citizen.Wait(0)
        if playerJob == Config.jobs[n] then
            TriggerServerEvent('esx_shift:allMineShifts', GetPlayerServerId(PlayerId()),ESX.PlayerData)
        end 
    end
end)

RegisterNUICallback("showAllShifts", function(data)
    loadPlayerData()
    Citizen.Wait(0)
    local playerJob = ESX.PlayerData.job.name
    for n in pairs(Config.jobs) do
        Citizen.Wait(0)
        if playerJob == Config.jobs[n] then
            TriggerServerEvent('esx_shift:showAllShifts', GetPlayerServerId(PlayerId()),ESX.PlayerData)
        end 
    end
end)

RegisterNUICallback("deleteShift", function(data)
    TriggerServerEvent('esx_shift:deleteShift', GetPlayerServerId(PlayerId()), data)
end)

RegisterNetEvent('esx_shift:allMineShifts_client')
AddEventHandler('esx_shift:allMineShifts_client', function(result)
    SendNUIMessage({
        type = "displayAllMineShift",
        shifts = result,
    })
end)

RegisterNetEvent('esx_shift:showAllShifts_client')
AddEventHandler('esx_shift:showAllShifts_client', function(result)
    SendNUIMessage({
        type = "showAllShifts",
        shifts = result,
    })
end)

function SetDisplay(bool)
    Citizen.Wait(0)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[ 
            inputGroup -- integer , 
	        control --integer , 
            disable -- boolean 
        ]]
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

function chat(str, color)
    TriggerEvent(
        'chat:addMessage',
        {
            color = color,
            multiline = true,
            args = {str}
        }
    )
end

function startAnim()
	Citizen.CreateThread(function()
	  RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
	  while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
	    Citizen.Wait(0)
	  end
		attachObject()
		TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
	end)
end

function attachObject()
	tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
	AttachEntityToEntity(tab, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
end

function stopAnim()
	StopAnimTask(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
	DeleteEntity(tab)
end

