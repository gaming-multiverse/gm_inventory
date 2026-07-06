local MANIFEST_URL = 'https://raw.githubusercontent.com/gaming-multiverse/gm_versions/refs/heads/main/versions.json'

local resourceName = GetCurrentResourceName()
local localVersion = GetResourceMetadata(resourceName, 'version', 0)

local function parseVersion(v)
    local parts = {}
    for num in tostring(v):gmatch('%d+') do
        parts[#parts + 1] = tonumber(num)
    end
    return parts
end

local function isNewer(remote, current)
    local r, c = parseVersion(remote), parseVersion(current)
    local n = math.max(#r, #c)
    for i = 1, n do
        local a, b = r[i] or 0, c[i] or 0
        if a ~= b then return a > b end
    end
    return false
end

local function printUrls(entry)
    if type(entry.urls) ~= 'table' then return end
    for _, link in ipairs(entry.urls) do
        if type(link) == 'string' and link ~= '' then
            print(('^3[%s]^7   %s'):format(resourceName, link))
        elseif type(link) == 'table' and link.url and link.url ~= '' then
            if link.title and link.title ~= '' then
                print(('^3[%s]^7   %s: %s'):format(resourceName, link.title, link.url))
            else
                print(('^3[%s]^7   %s'):format(resourceName, link.url))
            end
        end
    end
end

local function checkVersion()
    -- Startup banner — always, so the load is visible with its version.
    print(('^2[%s]^7 version ^5%s^7'):format(resourceName, localVersion or 'unknown'))

    if not localVersion then return end
    if type(MANIFEST_URL) ~= 'string' or MANIFEST_URL == ''
        or MANIFEST_URL == 'REPLACE_WITH_MANIFEST_URL' then
        return
    end

    PerformHttpRequest(MANIFEST_URL, function(status, body)
        if status ~= 200 or not body or body == '' then return end

        local ok, manifest = pcall(json.decode, body)
        if not ok or type(manifest) ~= 'table' then return end

        local entry = manifest[resourceName]
        if type(entry) ~= 'table' or not entry.version then return end

        if isNewer(entry.version, localVersion) then
            print(('^3[%s] update available: ^1%s^3 -> ^2%s^7')
                :format(resourceName, localVersion, entry.version))
            if entry.description and entry.description ~= '' then
                print(('^3[%s]^7   %s'):format(resourceName, entry.description))
            end
        else
            print(('^2[%s] up to date^7 (^5%s^7)'):format(resourceName, localVersion))
        end
        printUrls(entry)
    end, 'GET', '', { ['Content-Type'] = 'application/json' })
end

CreateThread(checkVersion)