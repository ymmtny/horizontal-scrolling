-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

-- Load content
  local function bluePageBtn ()
    print("bluePage")
    storyboard.gotoScene( "bluePage", "fade", 500 )
  end

  -- Scroll Nav spacing/margins
  local spacing = 100
  local leftMargin = 50
  local topMargin = 100
  local scrollbarY = 480

  local content = {}


  content[1] = { thumb = "ball_blue.png", asset = bluePageBtn}
  content[2] = { thumb = "ball_black.png", asset = bluePageBtn}
  content[3] = { thumb = "ball_green.png", asset = bluePageBtn}
  content[4] = { thumb = "ball_orange.png", asset = bluePageBtn}
  content[5] = { thumb = "ball_pink.png", asset = bluePageBtn}
  content[6] = { thumb = "ball_purple.png", asset = bluePageBtn}
  content[7] = { thumb = "ball_red.png", asset = bluePageBtn}
  content[8] = { thumb = "ball_yellow.png", asset = bluePageBtn}
-- content[9] = { thumb = "ball_white.png", asset = bluePageBtn}
 
  
  --import the scrollNav class
  local scrollNav = require("scrollNav")
  local scrollNav001
  -- Setup a scrollable content gfinseroup

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--     unless storyboard.removeScene() is called.
-- 
--------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
  local group = self.view
  -- VIDEO GALLERY
  -- by John Polacek @ 2011
  --
  -- Version: 1.0
  --
  -- Git: https://github.com/johnpolacek/Video-Gallery
  -- Blog: http://johnpolacek.com
  -- Twitter: @johnpolacek

  scrollNav001 = scrollNav.new({left=0, right=0, tm=topMargin, lm=leftMargin, sp=spacing})
  -- Iterate through content and add to scrollNav
  for index=1, #content do
      local thumb = display.newImage(content[index].thumb)
      thumb:scale(3,3)
      scrollNav001:insertButton(thumb, content[index].asset)
  end
  -- Add the scrollbar to the scrollNav
  scrollNav001.scrollNav:addScrollBar(scrollbarY)
  -- all display objects must be inserted into group
  group:insert( scrollNav001.scrollNav )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local group = self.view
  scrollNav001.scrollNav.prevTime = 0 
  -- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
  
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
  local group = self.view
  
  -- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
  
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
  local group = self.view

end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene