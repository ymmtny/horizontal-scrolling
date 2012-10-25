-- SCROLL NAV
-- by John Polacek @ 2011
--
-- Based on ScrollView sample from AnscaMobile
--
-- Version: 1.0
--
-- Git: https://github.com/johnpolacek/Video-Gallery
-- Blog: http://johnpolacek.com
-- Twitter: @johnpolacek

-- modified by ymmt 2012.10 
-- make it as a class

local scrollNav = {}
local scrollNav_mt = {__index = scrollNav}  

-- set values for width and height of the screen
local screenW, screenH = display.contentWidth, display.contentHeight
local viewableScreenW, viewableScreenH = display.viewableContentWidth, display.viewableContentHeight
local screenOffsetW = display.contentWidth - display.viewableContentWidth
local screenOffsetH = display.contentHeight - display.viewableContentHeight

function scrollNav.new(params)

  local newScrollNav = {}

  -- setup a group to be the scrolling screen
  local scrollNavGroup = display.newGroup()

  -- Add transparent background to the scroll view for a full screen hit area
  local scrollBackground = display.newRect(0, 0, display.contentWidth, display.contentHeight)
  scrollBackground:setFillColor(255, 255, 255, 0)
  scrollNavGroup:insert(scrollBackground)

  scrollNavGroup.left = params.left or 0
  scrollNavGroup.right = params.right or 0

  scrollNavGroup.topMargin  = params.tm or 40
  scrollNavGroup.leftMargin = params.lm or 40
  scrollNavGroup.bottomMargin = 0
  scrollNavGroup.contentMatrix    = {}
  scrollNavGroup.prevTime = 0

  newScrollNav.spacing    = params.sp or 30
  newScrollNav.xPos       = scrollNavGroup.leftMargin
  
  scrollNavGroup.x = scrollNavGroup.left

  -- setup the touch listener 
  scrollNavGroup:addEventListener("touch", scrollNavGroup)

  ------------------------------------------------------------
  -- RETURN SCROLLNAV OBJECT

  newScrollNav.scrollNav        = scrollNavGroup
  newScrollNav.scrollBackground = scrollBackground
  
  ------------------------------------------------------------
  -- EVENT HANDLERS

  function scrollNavGroup:touch(event) 

    function showContent(content)
    --  print("showContent")
      if content ~= nil then
        content()
      else 
    --    print "no content"  
      end
    end

    function trackVelocity(event)   
      local timePassed = event.time - self.prevTime
      self.prevTime = self.prevTime + timePassed
      if self.prevX and timePassed > 0 then 
        self.velocity = (self.x - self.prevX) / timePassed 
     --  print (self.x.." ".." "..self.prevX.." "..timePassed.." "..self.velocity)
      end
      self.prevX = self.x
    end     

    function getContent(touchX)
      buttonIndex = 0
      for index, value in ipairs(self.contentMatrix) do
        local leftX = self.contentMatrix[index].leftBound + self.x
        local rightX = self.contentMatrix[index].rightBound + self.x
        if (touchX > leftX and touchX < rightX) then
          buttonIndex = index
        end
      end
      if (buttonIndex > 0) then
        showContent(self.contentMatrix[buttonIndex].content)
      end
    end

    local phase = event.phase      

    if(phase == "began") then
     -- print ("------began--------")
      self.startPos = event.x
      self.prevPos = event.x                                       
      self.delta, self.velocity = 0, 0
      if self.tween then transition.cancel(self.tween) end

      Runtime:removeEventListener("enterFrame", self) 
      Runtime:removeEventListener("enterFrame", trackVelocity) 

      self.prevTime = 0
      self.prevX = 0

      transition.to(self.scrollBar,  { time=200, alpha=1 })                 

      -- Start tracking velocity
      Runtime:addEventListener("enterFrame", trackVelocity)

      -- Subsequent touch events will target button even if they are outside the contentBounds of button
      display.getCurrentStage():setFocus(self)
      self.isFocus = true

    elseif(self.isFocus) then
      if(phase == "moved") then     
      --print ("------moved--------")

      local rightLimit = screenW - self.width - self.right
        self.moved = true
        self.delta = event.x - self.prevPos
        self.prevPos = event.x
        if (self.x > self.left or self.x < rightLimit) then 
              self.x  = self.x + self.delta/2
        --      print ("##"..self.x)
        else
              self.x = self.x + self.delta   
       --       print ("$$"..self.x)
        end
        self:moveScrollBar()
      elseif(phase == "ended" or phase == "cancelled") then 
    --  print ("------eneded--------")

        local dragDistance = event.x - self.startPos
        self.lastTime = event.time

        Runtime:addEventListener("enterFrame", self)         
        Runtime:removeEventListener("enterFrame", trackVelocity)

        -- Allow touch events to be sent normally to the objects they "hit"
        display.getCurrentStage():setFocus(nil)
        self.isFocus = false

        -- check if touch instance is a drag or a touch to open 
        if (dragDistance < 10 and dragDistance > -10 and event.y > self.topMargin and event.y < self.bottomMargin) then
          getContent(event.x)
        else
          --print "###############"  
        end
      end
    end
    return true
  end

  function scrollNavGroup:enterFrame(event)   
    local friction = 0.9
    local timePassed = event.time - self.lastTime
    self.lastTime = self.lastTime + timePassed       
    --turn off scrolling if velocity is near zero
    if math.abs(self.velocity) < .01 then
      self.velocity = 0
      Runtime:removeEventListener("enterFrame", self)          
      transition.to(self.scrollBar,  { time=400, alpha=0 })    
    else
      if self.velocity > 0 then
        self.x = self.x + 0.1
      else
        self.x = self.x - 0.1 
      end                    
    end       
    self.velocity = self.velocity * friction
    --print("enterFrame "..self.x.." "..self.velocity .. " "..timePassed)

    self.x = math.floor(self.x + self.velocity * timePassed)
    --print ("%%"..self.x)
    
    local leftLimit = self.left 
    local rightLimit = screenW - self.width
    
    if (self.x > leftLimit) then
     -- print ("leftLimit:"..leftLimit)
      self.velocity = 0
      Runtime:removeEventListener("enterFrame", self)          
      self.tween = transition.to(self, { time=400, x=leftLimit, transition=easing.outQuad})
      transition.to(self.scrollBar,  { time=400, alpha=0 })                 
    elseif (self.x < rightLimit and rightLimit < 0) then
  --    print("rightLimit < 0:"..rightLimit) 
      self.velocity = 0
      Runtime:removeEventListener("enterFrame", self)          
      self.tween = transition.to(self, { time=400, x=rightLimit, transition=easing.outQuad})
      transition.to(self.scrollBar,  { time=400, alpha=0 })                 
    elseif (self.x < rightLimit) then 
   --   print("rightLimit:"..rightLimit) 
      self.velocity = 0
      Runtime:removeEventListener("enterFrame", self)          
      self.tween = transition.to(self, { time=400, x=leftLimit, transition=easing.outQuad})        
      transition.to(self.scrollBar,  { time=400, alpha=0 })                 
    end 

    self:moveScrollBar()
              
    return true
  end

  ------------------------------------------------------------
  -- CLASS FUNCTIONS
  function scrollNavGroup:moveScrollBar()
    if self.scrollBar then            
      local scrollBar = self.scrollBar
      scrollBar.x = -self.x * self.xRatio + scrollBar.width * 0.5 + self.left
      if scrollBar.x <  5 + self.left + scrollBar.width * 0.5 then
        scrollBar.x = 5 + self.left + scrollBar.width * 0.5
      end
      if scrollBar.x > screenW - self.right  - 5 - scrollBar.width * 0.5 then
        scrollBar.x = screenW - self.right - 5 - scrollBar.width * 0.5
      end
    end
  end

  function scrollNavGroup:addScrollBar(scrollbarY, r, g, b, a)
    if self.scrollBar then self.scrollBar:removeSelf() end

    local scrollColorR = r or 122
    local scrollColorG = g or 122
    local scrollColorB = b or 122
    local scrollColorA = a or 120

    local viewPortW = screenW - self.left - self.right 
    local scrollW = viewPortW * self.width / (self.width * 2 - viewPortW)   
    local scrollBar = display.newRoundedRect(0, self.height + 6, scrollW, 5, 2)
    scrollBar:setFillColor(scrollColorR, scrollColorG, scrollColorB, scrollColorA)

    local xRatio = scrollW / self.width
    self.xRatio = xRatio    

    scrollBar.x = scrollBar.width * 0.5 + self.left
    scrollBar.y = scrollbarY or viewableScreenH - 10

    self.scrollBar = scrollBar

    transition.to(scrollBar,  {time=400, alpha=0})      
  end

  function scrollNavGroup:removeScrollBar()
    if self.scrollBar then 
      self.scrollBar:removeSelf() 
      self.scrollBar = nil
    end
  end

  function scrollNavGroup:cleanUp()
    Runtime:removeEventListener("enterFrame", trackVelocity)
    Runtime:removeEventListener("touch", self)
    Runtime:removeEventListener("enterFrame", self) 
    self:removeScrollBar()
  end

  return setmetatable(newScrollNav, scrollNav_mt)
end

function scrollNav:insertButton(button, c)

  local topMargin = self.scrollNav.topMargin
  local leftMargin = self.scrollNav.leftMargin
  local spacing = self.spacing
  local xPos = self.xPos
  -- print(self.scrollNav)
  -- for k,v in pairs(self.scrollNav) do
  --   print (k, v)
  -- end
  button.x = xPos + (button.width / 2)
  button.y = (button.height / 2) + topMargin
  self.scrollNav.bottomMargin = topMargin + button.height
  self.xPos = button.x + spacing + (button.width / 2)
  local buttonL = button.x - (button.width / 2)
  local buttonR = button.x + (button.width / 2)
  local t = {leftBound = buttonL, rightBound = buttonR, content = c}
  table.insert(self.scrollNav.contentMatrix, t)
  self.scrollNav:insert(button)
  self.scrollBackground.width = buttonR + spacing
  self.scrollBackground.x = self.scrollBackground.width / 2
end

return scrollNav