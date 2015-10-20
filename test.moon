screenWidth, screenHeight = application\getDeviceWidth!, application\getDeviceHeight!

-- Example class for texture with filtering enabled by default
class FilteredTexture extends Texture
	new: (path, options) =>
		super path, true, options

-- Custom bitmap example
class GiderosLogo extends Bitmap
	new: =>
		texture = FilteredTexture "assets/image.png"
		super texture

		-- Center image
		@setAnchorPoint 0.5, 0.5
		@setPosition screenWidth / 2, screenHeight / 2
		@fitWidth!
	
	fitWidth: =>
		@setScale screenWidth / @getWidth!

logo = GiderosLogo!
		
stage\addChild logo
stage\addEventListener Event.ENTER_FRAME, 
	(e) ->
		logo\setAlpha math.abs math.sin os.clock! * 2