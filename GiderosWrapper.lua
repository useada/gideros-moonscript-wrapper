local ENABLE_INFO_PRINT = false
local p = print
local print
print = function(...)
  if ENABLE_INFO_PRINT then
    return p(...)
  end
end
local giderosClassesTree = {
  ["Object"] = {
    ["Accelerometer"] = { },
    ["AlertDialog"] = {
      ["TextInputDialog"] = { }
    },
    ["Application"] = { },
    ["Event"] = { },
    ["FontBase"] = {
      ["Font"] = { },
      ["TTFont"] = { }
    },
    ["Geolocation"] = { },
    ["Gyroscope"] = { },
    ["KeyCode"] = { },
    ["Matrix"] = { },
    ["EventDispatcher"] = {
      ["Sprite"] = {
        ["Bitmap"] = { },
        ["Mesh"] = { },
        ["MovieClip"] = { },
        ["Shape"] = { },
        ["Stage"] = { },
        ["TextField"] = { },
        ["TileMap"] = { }
      }
    },
    ["TextureBase"] = {
      ["RenderTarget"] = { },
      ["Texture"] = { },
      ["TexturePack"] = { }
    },
    ["TextureRegion"] = { },
    ["Timer"] = { },
    ["Shader"] = { },
    ["Sound"] = { },
    ["SoundChannel"] = { },
    ["UrlLoader"] = { }
  }
}
local giderosClassesMethods = { }
local giderosClassesConstants = { }
local processGiderosClassMethods
processGiderosClassMethods = function(className)
  if not giderosClassesMethods[className] then
    giderosClassesMethods[className] = { }
  end
  if not giderosClassesConstants[className] then
    giderosClassesConstants[className] = { }
  end
  for key, value in pairs(_G[className]) do
    if type(value) == "function" then
      if key ~= "new" and not string.find(key, "__") then
        table.insert(giderosClassesMethods[className], key)
      end
    elseif type(value) ~= "table" then
      table.insert(giderosClassesConstants[className], {
        key,
        value
      })
    end
  end
end
local pushParentMethodsToClass
pushParentMethodsToClass = function(parentName, className)
  if not giderosClassesMethods[parentName] then
    return 
  end
  if not giderosClassesMethods[className] then
    return 
  end
  for i, methodName in ipairs(giderosClassesMethods[parentName]) do
    table.insert(giderosClassesMethods[className], methodName)
  end
end
local processGiderosClassesTree
processGiderosClassesTree = function(node, parentName)
  for className, children in pairs(node) do
    processGiderosClassMethods(className)
    if parentName then
      pushParentMethodsToClass(parentName, className)
    end
    processGiderosClassesTree(children, className)
  end
end
processGiderosClassesTree(giderosClassesTree)
local replaceMoonWithGiderosObjects
replaceMoonWithGiderosObjects = function(...)
  local args = {
    ...
  }
  for i, arg in ipairs(args) do
    if type(arg) == "table" and arg._giderosObject then
      print("Wrapper object replaced at argument " .. tostring(i))
      args[i] = arg._giderosObject
    end
  end
  return unpack(args)
end
for className, methods in pairs(giderosClassesMethods) do
  local giderosClass = _G[className]
  _G["_Gideros" .. className] = giderosClass
  do
    local _base_0 = { }
    _base_0.__index = _base_0
    local _class_0 = setmetatable({
      __init = function(self, ...)
        print("GiderosWrapper create => " .. tostring(className))
        self._giderosObject = giderosClass.new(replaceMoonWithGiderosObjects(...))
        for i, methodName in ipairs(methods) do
          self[methodName] = function(self, ...)
            print("GiderosWrapper call => " .. tostring(methodName))
            return self._giderosObject[methodName](self._giderosObject, replaceMoonWithGiderosObjects(...))
          end
        end
      end,
      __base = _base_0,
      __name = className
    }, {
      __index = _base_0,
      __call = function(cls, ...)
        local _self_0 = setmetatable({}, _base_0)
        cls.__init(_self_0, ...)
        return _self_0
      end
    })
    _base_0.__class = _class_0
    _G[className] = _class_0
  end
  if giderosClassesConstants[className] then
    for i, constantInfo in ipairs(giderosClassesConstants[className]) do
      _G[className][constantInfo[1]] = constantInfo[2]
    end
  end
end
local _giderosStage = stage
local ProxyStage
do
  local _base_0 = { }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      for i, methodName in ipairs(giderosClassesMethods["Stage"]) do
        self[methodName] = function(self, ...)
          return _giderosStage[methodName](_giderosStage, replaceMoonWithGiderosObjects(...))
        end
      end
    end,
    __base = _base_0,
    __name = "ProxyStage"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ProxyStage = _class_0
end
local _giderosApplication = application
local ProxyApplication
do
  local _base_0 = { }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      for i, methodName in ipairs(giderosClassesMethods["Application"]) do
        self[methodName] = function(self, ...)
          return _giderosApplication[methodName](_giderosApplication, replaceMoonWithGiderosObjects(...))
        end
      end
    end,
    __base = _base_0,
    __name = "ProxyApplication"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ProxyApplication = _class_0
end
application = ProxyApplication()
stage = ProxyStage()
