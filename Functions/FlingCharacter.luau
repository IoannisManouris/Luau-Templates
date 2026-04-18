local function FlingCharacter(character: Model)
	pcall(function()
		local hrp = character:WaitForChild("HumanoidRootPart", 5)
		local direction = hrp.CFrame.UpVector * 300

		local humanoid = character:WaitForChild("Humanoid", 5)

		hrp.Anchored = false
		humanoid.PlatformStand = false

		local body_velocity = Instance.new("BodyVelocity", hrp)
		body_velocity.P = 1250
		body_velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		body_velocity.Velocity = direction
		Debris:AddItem(body_velocity, 0.25)

		local angular_velocity = Instance.new("AngularVelocity", hrp)
		angular_velocity.MaxTorque = 10000
		angular_velocity.ReactionTorqueEnabled = false

		local attachment0 = AttachmentCreator(hrp, CFrame.new(0, 0, 0))
		local attachment1 = AttachmentCreator(hrp, CFrame.new(0, 0, 0))

		Debris:AddItem(attachment0, 0.25)
		Debris:AddItem(attachment1, 0.25)

		angular_velocity.Attachment0 = attachment0
		angular_velocity.Attachment1 = attachment1
		angular_velocity.AngularVelocity = Vector3.new(
			math.random(-10, 10),
			math.random(-10, 10),
			math.random(-10, 10)
		)

		Debris:AddItem(angular_velocity, 0.25)

		humanoid.Health = 0
	end)
end