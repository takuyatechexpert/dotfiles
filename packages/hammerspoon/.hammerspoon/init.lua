hs.hotkey.bind({"alt"}, "space", function()
    local app = hs.application.get("WezTerm")
    if app then
        if not app:mainWindow() then
            app:selectMenuItem({"WezTerm", "New OS window"})
        elseif app:isFrontmost() then
            app:hide()
        else
            app:activate()
        end
    else
        hs.application.launchOrFocus("WezTerm")
    end
end)
