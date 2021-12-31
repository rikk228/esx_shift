--[[
local Config = {}

Config.jobs = {
    'police',
    'ambulance'
}

Config.grade = {
    {4, 3}
}
]]

RegisterServerEvent('esx_shift:startShift')
RegisterServerEvent('esx_shift:endShift')
RegisterServerEvent('esx_shift:showAllShifts')
RegisterServerEvent('esx_shift:allMineShifts')
RegisterServerEvent('esx_shift:deleteShift')


AddEventHandler('esx_shift:startShift', function(playerData)
    
    local identifier = playerData.identifier

    local date = os.date('%Y-%m-%d %H:%M:%S')
    MySQL.Async.execute("insert into esx_shifts (identifier, start, end, job, changable) values ('" .. identifier .. "', '" ..  date .. "', '-', '" .. playerData.job.name .. "', 'true')")

end)

AddEventHandler('esx_shift:endShift', function(playerData)
    
    local identifier = playerData.identifier

    local date = os.date('%Y-%m-%d %H:%M:%S')
    MySQL.Async.execute("update esx_shifts set end = '".. date .."', changable = 'false' where identifier = '".. identifier .."' and changable = 'true'"  )

end)

AddEventHandler('esx_shift:showAllShifts', function(playerId, playerData)
    
    local identifier = playerData.identifier

    local playerGrade = playerData.job.grade
    local playerJob = playerData.job.name

    TriggerClientEvent('esx_shift:showAllShifts_client', playerId, json.encode({}))

    for i in pairs(Config.jobs) do
        if Config.jobs[i] == playerJob then
            for j in pairs(Config.grade[i]) do
                if playerGrade == Config.grade[i][j] then
                    MySQL.Async.fetchAll('select * from esx_shifts where job = @job ', { ['@job'] = playerData.job.name}, function(result)
                        for x in pairs(result) do
                            MySQL.Async.fetchAll('select firstname, lastname from users where identifier = @id ', { ['@id'] = identifier}, function(name)
                                result[x].fullname = '' .. name[1].firstname .. ' ' .. name[1].lastname .. ''
                                if x == #result then
                                    TriggerClientEvent('esx_shift:showAllShifts_client', playerId, json.encode(result))
                                end
                            end)
                            
                        end
                        
                    end)
                    
                end
            end
        end
    end
    
end)

AddEventHandler('esx_shift:allMineShifts', function(playerId, playerData)
    
    local identifier = playerData.identifier
    MySQL.Async.fetchAll('select * from esx_shifts where identifier = @identifier and job = @job ', { ['@identifier'] = identifier, ['@job'] = playerData.job.name}, function(result)
        result = json.encode(result)
        TriggerClientEvent('esx_shift:allMineShifts_client', playerId, result)
    end)

end)

AddEventHandler('esx_shift:deleteShift', function(playerId, data)
    MySQL.Async.execute("delete from esx_shifts where id = '" .. data.id .. "'")

end)

