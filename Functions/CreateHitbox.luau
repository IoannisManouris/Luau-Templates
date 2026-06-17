local hitbox_connections = {}

local function CreateHitbox(character: Model, properties: any, triggers: any?)
    local hrp = character.HumanoidRootPart

    local hitbox = Instance.new("Part", character)
    hitbox.Transparency = properties["Transparency"] or 1
    hitbox.CanCollide = false
    hitbox.Anchored = false
    hitbox.Massless = true
    hitbox.Size = properties["Size"] or Vector3.new(1, 1, 1)

    local weld = Instance.new("WeldConstraint", hitbox)
    weld.Part0 = hitbox
    weld.Part1 = hrp
    
    hitbox.CFrame = properties["CFrame"] or hrp.CFrame
    
    if triggers ~= nil then
        hitbox_connections[hitbox] = {}
        
        if triggers["Touched"] ~= nil then
            hitbox_connections[hitbox]["Touched"] = hitbox.Touched:Connect(triggers["Touched"])
        end
        
        if triggers["TouchEnded"] ~= nil then
            hitbox_connections[hitbox]["TouchEnded"] = hitbox.TouchEnded:Connect(triggers["TouchEnded"])
        end
        
        hitbox.Destroying:Once(function()
            for key, connection in hitbox_connections[hitbox] do
                hitbox_connections[hitbox][key]:Disconnect()
                hitbox_connections[hitbox][key] = nil
            end
            hitbox_connections[hitbox] = nil
        end)
    end
    
    return hitbox
end
