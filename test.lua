local screenWidth, screenHeight = application:getDeviceWidth(), application:getDeviceHeight()
local FilteredTexture
do
  local _parent_0 = Texture
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, path, options)
      return _parent_0.__init(self, path, true, options)
    end,
    __base = _base_0,
    __name = "FilteredTexture",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  FilteredTexture = _class_0
end
local GiderosLogo
do
  local _parent_0 = Bitmap
  local _base_0 = {
    fitWidth = function(self)
      return self:setScale(screenWidth / self:getWidth())
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self)
      local texture = FilteredTexture("assets/image.png")
      _parent_0.__init(self, texture)
      self:setAnchorPoint(0.5, 0.5)
      self:setPosition(screenWidth / 2, screenHeight / 2)
      return self:fitWidth()
    end,
    __base = _base_0,
    __name = "GiderosLogo",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  GiderosLogo = _class_0
end
local logo = GiderosLogo()
stage:addChild(logo)
return stage:addEventListener(Event.ENTER_FRAME, function(e)
  return logo:setAlpha(math.abs(math.sin(os.clock() * 2)))
end)
