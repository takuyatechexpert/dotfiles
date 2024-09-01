-- アクティブなアプリケーションの情報を取得して表示する関数
local function logActiveAppInfo()
  local app = hs.application.frontmostApplication()
  if app then
      local appName = app:name()
      local bundleID = app:bundleID()
      print("Active App Name: " .. appName)
      print("Active App Bundle ID: " .. bundleID)
      hs.alert.show("App Name: " .. appName .. "\nBundle ID: " .. bundleID)
  else
      print("No active application")
  end
end

-- Hammerspoonの設定をリロードするショートカットキーを設定
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
  hs.reload()
end)

-- Hammerspoonのコンソールにメッセージを表示
hs.alert.show("Hammerspoon Config Loaded!!")

-- ホットキーでアクティブなアプリケーションの情報を表示
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "I", logActiveAppInfo)

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

-- -- window up
-- hs.hotkey.bind({"alt", "ctrl"}, "H", function()
--     local win = hs.window.focusedWindow()
--     local f = win:frame()
--     local screen = win:screen()
--     local max = screen:frame()

--     f.x = max.x
--     f.y = max.y
--     f.w = max.w / 2
--     f.h = max.h
--     win:setFrame(f)
--   end)
-- window left
-- window left
hs.hotkey.bind({"alt", "ctrl"}, "H", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  if f.x == max.x and f.w == max.w / 2 then
      win:moveOneScreenWest()
  else
      f.x = max.x
      f.y = max.y
      f.w = max.w / 2
      f.h = max.h
      win:setFrame(f)
  end
end)

-- window right
hs.hotkey.bind({"alt", "ctrl"}, "L", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  if f.x == max.x + (max.w / 2) and f.w == max.w / 2 then
      win:moveOneScreenEast()
  else
      f.x = max.x + (max.w / 2)
      f.y = max.y
      f.w = max.w / 2
      f.h = max.h
      win:setFrame(f)
  end
end)

-- window top
hs.hotkey.bind({"alt", "ctrl"}, "K", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  if f.y == max.y and f.h == max.h / 2 then
      win:moveOneScreenNorth()
  else
      f.x = max.x
      f.y = max.y
      f.w = max.w
      f.h = max.h / 2
      win:setFrame(f)
  end
end)

-- window bottom
hs.hotkey.bind({"alt", "ctrl"}, "J", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  if f.y == max.y + (max.h / 2) and f.h == max.h / 2 then
      win:moveOneScreenSouth()
  else
      f.x = max.x
      f.y = max.y + (max.h / 2)
      f.w = max.w
      f.h = max.h / 2
      win:setFrame(f)
  end
end)

-- window full screen
hs.hotkey.bind({"alt", "ctrl"}, "return", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end)

-- window upper right
hs.hotkey.bind({"alt", "ctrl"}, "U", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h / 2
  win:setFrame(f)
end)

-- window upper left
hs.hotkey.bind({"alt", "ctrl"}, "Y", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h / 2
  win:setFrame(f)
end)

-- window lower left
hs.hotkey.bind({"alt", "ctrl"}, "N", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y + (max.h / 2)
  f.w = max.w / 2
  f.h = max.h / 2
  win:setFrame(f)
end)

-- window lower right
hs.hotkey.bind({"alt", "ctrl"}, "M", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y + (max.h / 2)
  f.w = max.w / 2
  f.h = max.h / 2
  win:setFrame(f)
end)

-- MINAGINE Timestamp を起動またはアクティブにするホットキー
hs.hotkey.bind({"alt", "cmd"}, "M", function()
  local app = hs.application.get("MINAGINE Timestamp")
  if app then
    -- アプリケーションが既に起動している場合は終了する
    app:kill()
    hs.alert.show("MINAGINE Timestamp Shutdown")
  else
    -- アプリケーションが起動していない場合は起動する
    hs.application.launchOrFocus("MINAGINE Timestamp")
    hs.alert.show("MINAGINE Timestamp Set Up")
  end
end)

-- AWS IIC 設定フォーム
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "A", function()
  -- プロファイル名の入力フォームを表示
  local profileButton, profileName = hs.dialog.textPrompt("プロファイル名の入力", "プロファイル名を入力してください（未入力の場合は 'default' が使用されます）", "", "OK", "キャンセル")

  if profileButton == "OK" then
      -- プロファイル名が空の場合は 'default' を使用
      if profileName == "" then
          profileName = "default"
      end

      -- AWSプロファイル情報の入力フォームを表示
      local button, profileData = hs.dialog.textPrompt("AWSプロファイル入力", "以下の形式でプロファイル情報を貼り付けてください:\n[default]\naws_access_key_id=xxxxxxxxxx\naws_secret_access_key=xxxxxxx\naws_session_token=xxxxxxxxxxxxx（省略可能）", "", "OK", "キャンセル")

      if button == "OK" then
          -- WezTermをアクティブにする
          hs.application.launchOrFocus("WezTerm")
          hs.timer.doAfter(0.5, function()  -- 少し待ってから新しいタブを開く
              -- 新しいタブを開くためにCmd+Tを送信
              hs.eventtap.keyStroke({"cmd"}, "t")

              hs.timer.doAfter(1.0, function()  -- 1秒待ってからスクリプトを実行
                  -- `update_aws_credentials.sh` スクリプトのパスをクリップボードにコピー
                  hs.pasteboard.setContents("~/projects/update_aws_credentials.sh")
                  hs.eventtap.keyStroke({"cmd"}, "v")
                  hs.eventtap.keyStroke({}, "return")

                  -- プロファイル名を貼り付ける
                  hs.timer.doAfter(0.5, function()
                      -- プロファイル名をクリップボードにコピー
                      hs.pasteboard.setContents(profileName)
                      hs.eventtap.keyStroke({"cmd"}, "v")
                      hs.eventtap.keyStroke({}, "return")

                      -- プロファイルデータの値を抽出して貼り付ける
                      local aws_access_key_id = profileData:match("aws_access_key_id=(%S+)")
                      local aws_secret_access_key = profileData:match("aws_secret_access_key=(%S+)")
                      local aws_session_token = profileData:match("aws_session_token=(%S+)")

                      -- aws_access_key_idを貼り付けてEnter
                      if aws_access_key_id then
                          hs.timer.doAfter(0.5, function()
                              hs.pasteboard.setContents(aws_access_key_id)
                              hs.eventtap.keyStroke({"cmd"}, "v")
                              hs.eventtap.keyStroke({}, "return")
                          end)
                      end

                      -- aws_secret_access_keyを貼り付けてEnter
                      if aws_secret_access_key then
                          hs.timer.doAfter(1.0, function()
                              hs.pasteboard.setContents(aws_secret_access_key)
                              hs.eventtap.keyStroke({"cmd"}, "v")
                              hs.eventtap.keyStroke({}, "return")
                          end)
                      end

                      -- aws_session_tokenを貼り付けてEnter
                      if aws_session_token then
                          hs.timer.doAfter(1.5, function()
                              hs.pasteboard.setContents(aws_session_token)
                              hs.eventtap.keyStroke({"cmd"}, "v")
                              hs.eventtap.keyStroke({}, "return")
                          end)
                      end
                  end)
              end)
          end)
      else
          hs.alert.show("操作がキャンセルされました")
      end
  else
      hs.alert.show("操作がキャンセルされました")
  end
end)