local function CreateHitbox(character: Model, properties: any, trigger: any?)
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
    
    if trigger ~= nil then
        hitbox_connections[hitbox] = hitbox.Touched:Connect(trigger)
        
        hitbox.Destroying:Once(function()
            hitbox_connections[hitbox]:Disconnect()
            hitbox_connections[hitbox] = nil
        end)
    end
    
    return hitbox
end
