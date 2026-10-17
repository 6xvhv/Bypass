-- Bypass Premium loader. Public on GitHub; the premium scripts themselves are
-- only served by the Bypass Hub bot's server, to a valid key.
--
--   _G.Key = "BYP-XXXX-XXXX-XXXX"
--   _G.Script = "basketball"
--   loadstring(game:HttpGet("https://raw.githubusercontent.com/6xvhv/Bypass/refs/heads/main/premium.lua"))()

local HOST = "https://bypass-keys.fluffy-kyano.workers.dev"

local HttpService = game:GetService("HttpService")

local function notify(text)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Bypass Premium", Text = text, Duration = 6 })
	end)
	warn("[Bypass Premium] " .. text)
end

local key = tostring(_G.Key or ""):gsub("%s", "")
local slug = tostring(_G.Script or "")
if key == "" then return notify("Set your key first:  _G.Key = \"BYP-...\"") end
if slug == "" then return notify("Set the script first:  _G.Script = \"...\"") end

local hwid
pcall(function() hwid = gethwid and gethwid() end)
if not hwid then
	pcall(function() hwid = game:GetService("RbxAnalyticsService"):GetClientId() end)
end

local url = ("%s/premium/%s?k=%s&hwid=%s"):format(HOST, HttpService:UrlEncode(slug), HttpService:UrlEncode(key), HttpService:UrlEncode(tostring(hwid or "")))
local ok, src = pcall(function() return game:HttpGet(url) end)
if not ok or type(src) ~= "string" or src == "" then
	return notify("Couldn't reach the Bypass server. Try again in a minute.")
end

local reason = src:match('^error%("Bypass: (.-)"%)')
if reason then return notify(reason) end

local fn, err = loadstring(src)
if not fn then return notify("Script failed to load: " .. tostring(err)) end
fn()
