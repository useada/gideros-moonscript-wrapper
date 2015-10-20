# Gideros MoonScript Wrapper

A simple script that makes possible to correctly access and inherit Gideros classes from MoonScript code.

## Code example

```MoonScript
class MyBitmap extends Bitmap
	new: =>
		texture = Texture "assets/image.png"
		super texture

		-- Center image
		@setAnchorPoint 0.5, 0.5

image = MyBitmap!		
stage\addChild image
```