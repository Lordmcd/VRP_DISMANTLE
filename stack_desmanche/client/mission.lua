local Proxy = module('vrp', 'lib/Proxy')
local Tunnel = module('vrp', 'lib/Tunnel')
local vRP = Proxy.getInterface('vRP')

dismantleStatus = 0
local blipsDismantleCarAlert = false
HasEnteredInVehicle = 0

CreateThread(function()
	while true do
		Wait(0)
        local ped = PlayerPedId()
        local pedMissionCds = GetEntityCoords(ped)
        local distanceMission = #(pedMissionCds - missionCoords)
        isPedNearDismantleBlipCoords =  false
        if distanceMission < 10 then
            isPedNearDismantleBlipCoords = true
            DrawMarker(29, missionCoords.x, missionCoords.y, missionCoords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 255, false, false, 2, true, nil, false)
        end

        if not isPedNearDismantleBlipCoords then 
            Wait(1000)
        end
	end
end)

CreateThread(function()
    while true do
        Wait(0)
        local isDismantleInProcess = false
        if dismantleStatus > 0 then 
            isDismantleInProcess = true
            if IsControlJustPressed(0,168) then
                TriggerEvent('Notify','aviso','Desmanche Cancelado!')
                cancelDismantleProcess()
            end
        end
        if not isDismantleInProcess then 
            Wait(1000)
        end    
    end

end)

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pedCds = GetEntityCoords(ped)
        local distanceMission = #(pedCds - missionCoords)
        if IsControlJustPressed(0, 38) and distanceMission < 2 and dismantleStatus == 0 then
            -- Randomicidade de spawn
            randomIndexCoors = math.random(#dismantlePickUpVehicleCoords)
            randomCoord = dismantlePickUpVehicleCoords[randomIndexCoors]
            TriggerServerEvent('STACK_DESMANCHE:ALERTSOUND')
            CreateDismantleCarBlip(randomCoord) 
            

            -- Randomicidade de veiculo
            randomIndexVehicle = math.random(#dismantleVehicles)
            randomVehicle = dismantleVehicles[randomIndexVehicle]
            vehicleMissionHash = GetHashKey(randomVehicle)
            RequestModel(vehicleMissionHash)
            while not HasModelLoaded(vehicleMissionHash) do
                Wait(0)
            end
            vechicleToDismantle = nil
            vechicleToDismantle = CreateVehicle(vehicleMissionHash, randomCoord.x, randomCoord.y, randomCoord.z, randomCoord.h, true, true)
            TriggerEvent('Notify','sucesso','Localizaçao do veiculo marcado no GPS!')
            dismantleStatus = 1
            
        end
        if not isPedNearDismantleBlipCoords then 
            Wait(1000)
        end
        
    end

end)

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if  IsVehicleModel(GetVehiclePedIsUsing(ped),GetHashKey(randomVehicle)) and HasEnteredInVehicle == 0 and IsPedInAnyVehicle(ped, false) then
            local randomIndexPlace = math.random(#dismantlePlaceCoords)
            randomDismantlePlaceCoords = dismantlePlaceCoords[randomIndexPlace]
            CreateDismantlePlaceBlip(randomDismantlePlaceCoords)
            TriggerEvent('Notify','sucesso','Destino marcado no GPS 90s!')
            TriggerServerEvent('STACK_DESMANCHE:ALERTSOUND')
            dismatleStart(vechicleToDismantle, randomDismantlePlaceCoords)
            RemoveBlip(blipsDismantleCarAlert)
            generateBlipOnGround = 1
            HasEnteredInVehicle = 1
        end
    end

end)

RegisterNetEvent('STACK_DESMANCHE:REMOVEPLACEALERT', function()
    RemoveBlip(blipsDismantleLocalAlert)
end)


function CreateDismantleCarBlip(randomCoord)
	blipsDismantleCarAlert = AddBlipForCoord(randomCoord.x,randomCoord.y,randomCoord.z)
	SetBlipSprite(blipsDismantleCarAlert,227)
	SetBlipColour(blipsDismantleCarAlert,2)
	SetBlipScale(blipsDismantleCarAlert,0.8)
	SetBlipAsShortRange(blipsDismantleCarAlert,false)
	SetBlipRoute(blipsDismantleCarAlert,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Localização do Veiculo")
	EndTextCommandSetBlipName(blipsDismantleCarAlert)
end


function CreateDismantlePlaceBlip(randomCoord)
	blipsDismantleLocalAlert = AddBlipForCoord(randomCoord.x,randomCoord.y,randomCoord.z)
	SetBlipSprite(blipsDismantleLocalAlert,50)
	SetBlipColour(blipsDismantleLocalAlert,1)
	SetBlipScale(blipsDismantleLocalAlert,0.8)
	SetBlipAsShortRange(blipsDismantleLocalAlert,false)
	SetBlipRoute(blipsDismantleLocalAlert,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Localização do Veiculo")
	EndTextCommandSetBlipName(blipsDismantleLocalAlert)
end

function cancelDismantleProcess()
    SetEntityAsMissionEntity(vechicleToDismantle, true, true )
    DeleteVehicle(vechicleToDismantle)
    dismantleStatus = 0
    generateBlipOnGround = 0
    resetDismantleMissionValues()
    RemoveBlip(blipsDismantleLocalAlert)
    RemoveBlip(blipsDismantleCarAlert)
    HasEnteredInVehicle = 0

end
