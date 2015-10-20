# Gideros MoonScript Wrapper

A simple script that makes it possible to access and inherit [Gideros](giderosmobile.com) classes from your [MoonScript](moonscript.org) code.

## Installation
1. Add [GiderosWrapper.lua](https://github.com/dcr30/Gideros-MoonScript/blob/master/GiderosWrapper.lua) to your project.
2. Make sure it's executed first.

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
