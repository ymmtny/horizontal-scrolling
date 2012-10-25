-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require "widget"


-- forward declarations and other locals
local playBtn

local function onPlayBtnRelease()
  
  -- go to level1.lua scene
  storyboard.gotoScene( "menu", "fade", 500 )
  
  return true -- indicates successful touch
end

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--     unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
  local group = self.view
  local background = display.newRect(0,0, screenW, screenH)
  background:setFillColor(0, 0, 0xff)

 local spacing = 50
  local leftMargin = 50
  local topMargin = 100
  local scrollbarY = 480
   
   
  -- Load content
  local bluePage = function ()
    storyboard.gotoScene( "bluePage", "fade", 500 )
  end
  -- Scroll Nav spacing/margins
  local spacing = 100
  local leftMargin = 50
  local topMargin = 100
  local scrollbarY = 680

  local content = {}
  content[1] = { thumb = "ball_blue.png", asset = bluePageBtn}
  content[2] = { thumb = "ball_black.png", asset = bluePageBtn}
  content[3] = { thumb = "ball_green.png", asset = bluePageBtn}
  content[4] = { thumb = "ball_orange.png", asset = bluePageBtn}
  content[5] = { thumb = "ball_pink.png", asset = bluePageBtn}
  content[6] = { thumb = "ball_purple.png", asset = bluePageBtn}
  content[7] = { thumb = "ball_red.png", asset = bluePageBtn}
  content[8] = { thumb = "ball_yellow.png", asset = bluePageBtn}
  --content[9] = { thumb = "ball_white.png", asset = bluePageBtn} 
  --import the scrollNav class
  local scrollNav = require("scrollNav")
  -- Setup a scrollable content gfinseroup
  local scrollNav002 = scrollNav.new({left=0, right=0, tm=topMargin, lm=leftMargin, sp=spacing})
  -- Iterate through content and add to scrollNav
  for index=1, #content do
      local thumb = display.newImage(content[index].thumb)
      thumb:scale(3,3)
      scrollNav002:insertButton(thumb, content[index].asset)
  end
  scrollNav002.scrollNav.y = 200
  -- Add the scrollbar to the scrollNav
  scrollNav002.scrollNav:addScrollBar(scrollbarY)


  -- all display objects must be inserted into group
  group:insert( scrollNav002.scrollNav )
-- create a widget button (which will loads level1.lua on release)
  playBtn = widget.newButton{
    label="Back",
    labelColor = { default={255}, over={128} },
    default="button.png",
    over="button-over.png",
    width=154, height=40,
    onRelease = onPlayBtnRelease  -- event listener function
  }
  playBtn:setReferencePoint( display.CenterReferencePoint )
  playBtn.x = display.contentWidth*0.5
  playBtn.y = display.contentHeight - 125
  

  -- all display objects must be inserted into group
  group:insert( background )
  group:insert( scrollNav002.scrollNav )
  group:insert( playBtn )

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local group = self.view
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
  local group = self.view  
  
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