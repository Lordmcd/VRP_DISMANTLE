local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
local Tools = module('vrp','lib/Tools')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')



RegisterNetEvent('STACK_DESMANCHE:PAYMENT', function()
    local user_id = vRP.getUserId(source)
    vRP.giveInventoryItem(user_id, paymentDismantleItem,math.random(paymentDismantleValorMin, paymentDismantleValorMax))
      
end)

RegisterNetEvent('STACK_DESMANCHE:ALERTSOUND', function()
    vRPclient._playSound(source,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
end)





