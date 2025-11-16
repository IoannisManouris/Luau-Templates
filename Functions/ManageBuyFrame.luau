local function ManageBuyFrame(frame)	
	local buy_button = nil
	local category = ""
	
	local item_name = frame.Name
	if marketplace:GetGamepassId(item_name) ~= nil then
		category = "Gamepass"
		buy_button = frame:WaitForChild("BuyButton")
		local owned_label = frame:WaitForChild("OwnedLabel")

		local owns_gamepass = marketplace:UserOwnsGamepass(item_name)

		buy_button.Visible = not owns_gamepass
		owned_label.Visible = owns_gamepass

		if not owns_gamepass then
			local click_connection = nil
			click_connection = buy_button.MouseButton1Click:Connect(function()
				marketplace:PromptGamepass(item_name)
			end)

			local gamepass_connection = nil
			gamepass_connection = gamepasses:WaitForChild(item_name):GetPropertyChangedSignal("Value"):Once(function()
				owns_gamepass = marketplace:UserOwnsGamepass(item_name)
				buy_button.Visible = not owns_gamepass
				owned_label.Visible = owns_gamepass
				
				if click_connection ~= nil then
					click_connection:Disconnect()
					click_connection = nil
				end
				
				if gamepass_connection ~= nil then
					gamepass_connection:Disconnect()
					gamepass_connection = nil
				end
			end)
		end
	elseif marketplace:GetProductId(item_name) ~= nil then
		category = "Product"
		buy_button = frame:WaitForChild("BuyButton")
		buy_button.MouseButton1Click:Connect(function()
			marketplace:PromptProduct(item_name)
		end)
	else
		return
	end
	
	task.delay(5, function()
		local price = nil
		if category == "Gamepass" then
			price = marketplace:GetGamepassPrice(item_name)
		else
			price = marketplace:GetProductPrice(item_name)
		end
		if price == nil then return end
		buy_button:WaitForChild("PriceLabel").Text = tostring(price)
	end)
end