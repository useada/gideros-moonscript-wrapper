ENABLE_INFO_PRINT = false

p = print
print = (...) -> p ... if ENABLE_INFO_PRINT 

giderosClassesTree = {
	"Object": {
		"Accelerometer": {},
		"AlertDialog": {
			"TextInputDialog": {}
		},
		"Application": {},
		"Event": {},

		"FontBase": {
			"Font": {},
			"TTFont": {},
		},

		"Geolocation": {},
		"Gyroscope": {},
		"KeyCode": {},
		"Matrix": {},

		"EventDispatcher": {
			"Sprite": {
				"Bitmap": {}, 
				"Mesh": {},
				"MovieClip": {},
				"Shape": {},
				"Stage": {}, 
				"TextField": {},
				"TileMap": {}
			}
		},

		"TextureBase": {
			"RenderTarget": {},
			"Texture": {},
			"TexturePack": {}
		},
		"TextureRegion": {},

		"Timer": {},

		"Shader": {},
		"Sound": {},
		"SoundChannel": {},

		"UrlLoader": {},
	}
}

-- List of methods names for each Gideros class
giderosClassesMethods = {}
giderosClassesConstants = {}

-- Get all proper methods names from Gideros class with given name
processGiderosClassMethods = (className) ->
	giderosClassesMethods[className] = {} if not giderosClassesMethods[className]
	giderosClassesConstants[className] = {} if not giderosClassesConstants[className]
	for key, value in pairs _G[className]
		if type(value) == "function" 
			if key ~= "new" and not string.find(key, "__")
				table.insert giderosClassesMethods[className], key
		elseif type(value) ~= "table"
			table.insert giderosClassesConstants[className], {key, value}

-- Copy methods names from one class to another class
pushParentMethodsToClass = (parentName, className) ->
	return if not giderosClassesMethods[parentName]
	return if not giderosClassesMethods[className]
	for i, methodName in ipairs giderosClassesMethods[parentName]
		table.insert giderosClassesMethods[className], methodName

-- Process giderosClassesTree
processGiderosClassesTree = (node, parentName) ->

	for className, children in pairs node
		processGiderosClassMethods className
		if parentName
			pushParentMethodsToClass parentName, className
		processGiderosClassesTree children, className

-- Process tree starting with rood node
processGiderosClassesTree giderosClassesTree

replaceMoonWithGiderosObjects = (...) ->
	args = {...}
	for i, arg in ipairs args 
		if type(arg) == "table" and arg._giderosObject
			print "Wrapper object replaced at argument #{i}"
			args[i] = arg._giderosObject
	return unpack args

-- Convert all Gideros classes to MoonScript classes
for className, methods in pairs giderosClassesMethods
	giderosClass = _G[className]
	_G["_Gideros" .. className] = giderosClass
	_G[className] = class
		new: (...) =>
			print "GiderosWrapper create => #{className}"

			@_giderosObject = giderosClass.new replaceMoonWithGiderosObjects ...

			for i, methodName in ipairs methods
				self[methodName] = (...) =>
					print "GiderosWrapper call => #{methodName}"
					@_giderosObject[methodName] @_giderosObject, replaceMoonWithGiderosObjects ...
	if giderosClassesConstants[className]
		for i, constantInfo in ipairs giderosClassesConstants[className]
			_G[className][constantInfo[1]] = constantInfo[2]

-- Setup proxy stage
_giderosStage = stage
ProxyStage = class
	new: =>
		for i, methodName in ipairs giderosClassesMethods["Stage"]
			self[methodName] = (...) =>
				_giderosStage[methodName] _giderosStage, replaceMoonWithGiderosObjects ...

-- Setup proxy application
_giderosApplication = application
ProxyApplication = class
	new: =>
		for i, methodName in ipairs giderosClassesMethods["Application"]
			self[methodName] = (...) =>
				_giderosApplication[methodName] _giderosApplication, replaceMoonWithGiderosObjects ...

export application
export stage
application = ProxyApplication!
stage = ProxyStage!