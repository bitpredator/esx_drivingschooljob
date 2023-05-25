ESX = nil
ESX = exports["es_extended"]:getSharedObject()

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'driving', Config.MaxInService)
end

-- TriggerEvent('esx_phone:registerNumber', 'driving', _U('alert_driving'), true, true)
TriggerEvent('esx_society:registerSociety', 'driving', 'Driving', 'society_driving', 'society_driving', 'society_driving', {type = 'public'})

RegisterServerEvent('esx_drivingschooljob:getStockItem')
AddEventHandler('esx_drivingschooljob:getStockItem', function(itemName, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_driving', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_removed') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_drivingschooljob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_driving', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_drivingschooljob:putStockItems')
AddEventHandler('esx_drivingschooljob:putStockItems', function(itemName, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_driving', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

  end)

end)

--ESX.RegisterServerCallback('esx_drivingschooljob:putStockItems', function(source, cb)

--  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_policestock', function(inventory)
--    cb(inventory.items)
--  end)

--end)

ESX.RegisterServerCallback('esx_drivingschooljob:getPlayerInventory', function(source, cb)
  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)

RegisterNetEvent('esx_drivingschooljob:addLicense')
AddEventHandler('esx_drivingschooljob:addLicense', function(type)
	local _source = source

	TriggerEvent('esx_license:addLicense', _source, type, function()
		TriggerEvent('esx_license:getLicenses', _source, function(licenses)
			TriggerClientEvent('esx_drivingschooljob:loadLicenses', _source, licenses)
		end)
	end)
end)

RegisterNetEvent('esx_drivingschooljob:pay')
AddEventHandler('esx_drivingschooljob:pay', function(price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeMoney(price)
	TriggerClientEvent('esx:showNotification', _source, _U('you_paid', ESX.Math.GroupDigits(price)))
end)