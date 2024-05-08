local Proxy = module('vrp', 'lib/Proxy')
local Tunnel = module('vrp', 'lib/Tunnel')
local vRP = Proxy.getInterface('vRP')


function dismatleStart(vechicleToDismantle, randomDismantlePlaceCoords)
    local ped = PlayerPedId()
    CreateThread(function()
        while dismantleStatus == 1 do
            Wait(0)
            local pedCds = GetEntityCoords(ped)
            local distanceDismantle = #(pedCds - randomDismantlePlaceCoords)
            if IsControlJustPressed(0, 38) and distanceDismantle < 10 and dismantleStatus == 1 then
                if IsPedInAnyVehicle(ped, false) then
                    TriggerEvent('Notify','aviso','Nao é possivel iniciar o desmanche dentro de um veiculo!')  
                else
                    vehicleDismantleVerify = vRP.getNearestVehicle(7)
                    if vehicleDismantleVerify then
                        if vehicleDismantleVerify == vechicleToDismantle then
                            FreezeEntityPosition(vechicleToDismantle, true)
                            for i= 0, 7 do
                                TriggerEvent('STACK_DESMANCHE:REMOVEPLACEALERT')
                                HasEnteredInVehicle = 0
                                SetVehicleDoorOpen(vechicleToDismantle, i, false, true)
                                Wait(250)
                            end
                            dismantleStatus = 2
                            TriggerEvent('Notify','sucesso','Iniciando o Desmanche!') 
                            dismatleDoor1(vechicleToDismantle, randomDismantlePlaceCoords)
                        else 
                            TriggerEvent('Notify','aviso','Esse nao é o veiculo solicitado!')
                        end
                    else 
                        TriggerEvent('Notify','aviso','Nenhum veiculo por perto!')
                    end
                end
            end
            
        end
    
    end)
end

function dismatleDoor1(vechicleToDismantle, randomDismantlePlaceCoords)
    local ped = PlayerPedId()
    Porta1 = GetEntityBoneIndexByName(vechicleToDismantle, 'door_dside_f' )
    porta1Cds = GetEntityBonePosition_2(vechicleToDismantle, Porta1)

    CreateThread(function()
        while dismantleStatus == 2 do
            Wait(0)
                
            local pedCds = GetEntityCoords(ped)
            local distanceDismantle = #(pedCds - randomDismantlePlaceCoords)
            if dismantleStatus == 2 and distanceDismantle < 10 then
                DrawText3D(porta1Cds.x, porta1Cds.y, porta1Cds.z, '~g~[E]~w~ Desmanchar porta')
            end
            if IsControlJustPressed(0, 38) and dismantleStatus ==  2 and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), porta1Cds.x, porta1Cds.y, porta1Cds.z, true ) < 1.2 and distanceDismantle < 10 then
                if vehicleDismantleVerify then
                    if vehicleDismantleVerify == vechicleToDismantle then
                        startCutPiece(0, 'Porta')
                        dismantleStatus = 3
                        dismatleDoor3(vechicleToDismantle, randomDismantlePlaceCoords)
                    end
                end
                   
            end
        end
    end)
end

function dismatleDoor2(vechicleToDismantle, randomDismantlePlaceCoords)
    local ped = PlayerPedId()
    local Porta2 = GetEntityBoneIndexByName(vechicleToDismantle, 'door_pside_f' )
    local porta2Cds = GetEntityBonePosition_2(vechicleToDismantle, Porta2)
    
    CreateThread(function()
        while dismantleStatus == 4 do
            Wait(0)
            
            local pedCds = GetEntityCoords(ped)
            local distanceDismantle = #(pedCds - randomDismantlePlaceCoords)
            if dismantleStatus == 4 and distanceDismantle < 10 then 
                DrawText3D(porta2Cds.x, porta2Cds.y, porta2Cds.z, '~g~[E]~w~ Desmanchar porta')
            end
            if IsControlJustPressed(0, 38) and dismantleStatus ==  4 and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), porta2Cds.x, porta2Cds.y, porta2Cds.z, true ) < 1.2 then 
                startCutPiece(1, 'Porta')
                dismantleStatus = 5
                dismatleDoor4(vechicleToDismantle, randomDismantlePlaceCoords)
                
            end 
        end
    
    end)
    
end

function dismatleDoor3(vechicleToDismantle, randomDismantlePlaceCoords)
    local ped = PlayerPedId()
    local Porta3 = GetEntityBoneIndexByName(vechicleToDismantle, 'door_dside_r' )
    local porta3Cds = GetEntityBonePosition_2(vechicleToDismantle, Porta3)
    CreateThread(function()
        while dismantleStatus == 3 do 
            Wait(0)
            local pedCds = GetEntityCoords(ped)
            local distanceDismantle = #(pedCds - randomDismantlePlaceCoords)
            if dismantleStatus == 3 and distanceDismantle < 10 then 
                DrawText3D(porta3Cds.x, porta3Cds.y, porta3Cds.z, '~g~[E]~w~ Desmanchar porta')
            end
            if IsControlJustPressed(0, 38) and dismantleStatus ==  3 and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), porta3Cds.x, porta3Cds.y, porta3Cds.z, true ) < 1.2 then 
                startCutPiece(2, 'Porta')
                dismantleStatus = 4
                dismatleDoor2(vechicleToDismantle, randomDismantlePlaceCoords)
                
            end 
        end
    
    end)
    
end


function dismatleDoor4(vechicleToDismantle, randomDismantlePlaceCoords)
    local ped = PlayerPedId()
    local Porta4 = GetEntityBoneIndexByName(vechicleToDismantle, 'door_pside_r' )
    local porta4Cds = GetEntityBonePosition_2(vechicleToDismantle, Porta4)
     
    CreateThread(function()
        while dismantleStatus == 5 do 
            Wait(0)
            local pedCds = GetEntityCoords(ped)
            local distanceDismantle = #(pedCds - randomDismantlePlaceCoords)
            if dismantleStatus ==  5 and distanceDismantle < 10 then 
                DrawText3D(porta4Cds.x, porta4Cds.y, porta4Cds.z, '~g~[E]~w~ Desmanchar porta')
            end
            if IsControlJustPressed(0, 38) and dismantleStatus ==  5 and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), porta4Cds.x, porta4Cds.y, porta4Cds.z, true ) < 1.2 then 
                startCutPiece(3, 'Porta')
                dismantleStatus = 6
                dismatleHood(vechicleToDismantle, randomDismantlePlaceCoords)
                
                
            end 
        end
    
    end)
end

function dismatleHood(vechicleToDismantle, randomDismantlePlaceCoords)
    local ped = PlayerPedId()
    local Capo = GetEntityBoneIndexByName(vechicleToDismantle, 'bonnet' )
    local capoCds = GetEntityBonePosition_2(vechicleToDismantle, Capo)
     
    CreateThread(function()
        while dismantleStatus == 6 do 
            Wait(0)
            local pedCds = GetEntityCoords(ped)
            local distanceDismantle = #(pedCds - randomDismantlePlaceCoords)
            if dismantleStatus ==  6 and distanceDismantle < 10 then 
                DrawText3D(capoCds.x, capoCds.y, capoCds.z, '~g~[E]~w~ Desmanchar Capo')
            end
            if IsControlJustPressed(0, 38) and dismantleStatus ==  6 and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), capoCds.x, capoCds.y, capoCds.z, true ) < 2.0 then 
                startCutPiece(4, 'Capo')
                dismantleStatus = 7
                dismatleTrunk(vechicleToDismantle, randomDismantlePlaceCoords)
            end 
        end
    
    end)
end


function dismatleTrunk(vechicleToDismantle, randomDismantlePlaceCoords)
    local ped = PlayerPedId()
    local Malas = GetEntityBoneIndexByName(vechicleToDismantle, 'boot' )
    local malasCds = GetEntityBonePosition_2(vechicleToDismantle, Malas)
     
    CreateThread(function() 
        while dismantleStatus == 7 do 
            Wait(0)
            local pedCds = GetEntityCoords(ped)
            local distanceDismantle = #(pedCds - randomDismantlePlaceCoords)
            if dismantleStatus ==  7 and distanceDismantle < 10 then 
                DrawText3D(malasCds.x, malasCds.y, malasCds.z, '~g~[E]~w~ Desmanchar Porta Malas')
            end
            if IsControlJustPressed(0, 38) and dismantleStatus ==  7 and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), malasCds.x, malasCds.y, malasCds.z, true ) < 2.0 then 
                startCutPiece(5, 'Porta Malas')
                dismantleStatus = 8
                dismatleBody(vechicleToDismantle, randomDismantlePlaceCoords)
            end 
        end
    
    end)
    
end


function dismatleBody(vechicleToDismantle, randomDismantlePlaceCoords)
    local ped = PlayerPedId()
    distanceDismantle = nil
    chassiCds = nil
    local chassiCds = GetEntityCoords(vechicleToDismantle)
    CreateThread(function()
        while dismantleStatus == 8 do 
            Wait(0)
            local pedCds = GetEntityCoords(ped)
            local distanceDismantle = #(pedCds - randomDismantlePlaceCoords)
            if dismantleStatus == 8 and distanceDismantle < 10 then 
                DrawText3D(chassiCds.x, chassiCds.y, chassiCds.z, '~g~[E]~w~ Desmanchar Chassi')
            end
            if IsControlJustPressed(0, 38) and dismantleStatus ==  8 and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), chassiCds.x, chassiCds.y, chassiCds.z, true ) < 2.0 then 
                endDismantleProcess()
                
            end 
        end
    
    end)
    
end

function resetDismantleMissionValues()
    vechicleToDismantle = nil
    randomDismantlePlaceCoords = nil
end


function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.39, 0.39)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 235)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 270
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.04, 0, 0, 0, 145)
end

function startCutPiece(pieceToCutIndex, pieceDismantled)
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_WELDING', -1, true)
    Wait(5000)
    ClearPedTasks(ped)
    SetVehicleDoorBroken(vechicleToDismantle, pieceToCutIndex, true)
    TriggerEvent('Notify','sucesso', pieceDismantled .. ' Desmanchado!') 
    TriggerServerEvent('STACK_DESMANCHE:PAYMENT')

end

function endDismantleProcess()
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_WELDING', -1, true)
    Wait(5000)
    ClearPedTasks(ped)
    TriggerEvent('Notify','sucesso','Desmanche Finalizado!') 
    TriggerServerEvent('STACK_DESMANCHE:PAYMENT')
    Wait(10000)
    SetEntityAsMissionEntity(vechicleToDismantle, true, true )
    DeleteVehicle(vechicleToDismantle)
    TriggerServerEvent('STACK_DESMANCHE:RESETVALUES')
    dismantleStatus = 0
    generateBlipOnGround = 0
    resetDismantleMissionValues()
end

CreateThread(function()
    local ped = PlayerPedId()
	while activeBlipOnGround do
		Wait(0)
        isPedNearDismantleBlipOnGroundCoords = false
        if generateBlipOnGround == 1 then
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), randomDismantlePlaceCoords.x, randomDismantlePlaceCoords.y, randomDismantlePlaceCoords.z, true ) < 10.0 then
                isPedNearDismantleBlipOnGroundCoords = true
                DrawMarker(27, randomDismantlePlaceCoords.x, randomDismantlePlaceCoords.y, randomDismantlePlaceCoords.z  - 0.9, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 4.0, 4.0, 4.0, 255, 0, 0, 255, false, false, 2, true, nil, false)
            end
        end
        if not isPedNearDismantleBlipOnGroundCoords then
            Wait(1000)
        end
	end
end)