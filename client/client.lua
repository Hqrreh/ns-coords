local QBCore = exports['qb-core']:GetCoreObject()
local creationLaser = false

RegisterCommand('coords', function()
    ToggleCreationLaser()
end)

function ToggleCreationLaser()
    creationLaser = not creationLaser

    if creationLaser then
        CreateThread(function()
            while creationLaser do
                local hit, coords = DrawLaser('PRESS ~g~E~w~ TO COPY VECTOR3\nPRESS ~g~G~w~ TO COPY TABLE COORDS\nPRESS ~g~X~w~ TO COPY ["coords"]', {r = 2, g = 241, b = 181, a = 200})


                if IsControlJustReleased(0, 38) then
                    creationLaser = false
                    if hit then
                        local message = {
                            type = "copyCoordsVector",
                            x = coords.x,
                            y = coords.y,
                            z = coords.z
                        }
                        SendNuiMessage(json.encode(message))
                    else
                        QBCore.Functions.Notify('ERROR', "error")
                    end
                elseif IsControlJustReleased(0, 47) then
                    creationLaser = false
                    if hit then
                        local message = {
                            type = "copyCoordsTable",
                            x = coords.x,
                            y = coords.y,
                            z = coords.z
                        }
                        SendNuiMessage(json.encode(message))
                    else
                        QBCore.Functions.Notify('ERROR', "error")
                    end
                elseif IsControlJustReleased(0, 73) then
                    creationLaser = false
                    if hit then
                        local message = {
                            type = "copyCoordsCoords2",
                            x = coords.x,
                            y = coords.y,
                            z = coords.z
                        }
                        SendNuiMessage(json.encode(message))
                    else
                        QBCore.Functions.Notify('ERROR', "error")
                    end
                end
                Wait(0)
            end
        end)
    end
end


function DrawLaser(message, color)
    local hit, coords = RayCastGamePlayCamera(20.0)
    Draw2DText(message, 4, {255, 255, 255}, 0.4, 0.43, 0.888 + 0.025)

    if hit then
        local position = GetEntityCoords(PlayerPedId())
        DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
        DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, color.r, color.g, color.b, color.a, false, true, 2, nil, nil, false)
    end

    return hit, coords
end

function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local _, hit, endCoords, _, _ = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return hit == 1, endCoords
end

function Draw2DText(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end