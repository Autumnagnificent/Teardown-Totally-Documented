-- TODO: doc

-- This should be the mod path to THIS FILE
local FILENAME = "MOD/shape_utils.lua"

if ClearKey then -- <script>
	local function voxscript( parameters )
		local size = ""
		local shapedata = ""
		local palettedata = ""
		if parameters.palette then
			local palette = {}
			for i = 1, #parameters.palette do
				local p = parameters.palette[i]
				palette[i] = string.format( "%d/%s/%d/%d/%d/%f/%f/%f/%f/%f", p.index, p.material or "none", math.floor( p.r * 255 ),
				                            math.floor( p.g * 255 ), math.floor( p.b * 255 ),
				                            p.a and p.a > 0 and p.a < 1 and 0.5 or 1, p.reflect, p.shiny, p.metal, p.emissive )
			end
			palettedata = string.format( "palette=\"%s\"", table.concat( palette, " " ) )
		end
		if parameters.shape then
			local content = {}
			for i = 1, #parameters.shape do
				local index = parameters.shape[i]
				content[i] = string.char( math.floor( index / 16 ) + 65, index % 16 + 65 )
			end
			shapedata = string.format( "shape=\"%s\"", table.concat( content, "" ) )
		end
		if parameters.size then
			size = string.format( "size=\"%d %d %d\"", unpack( parameters.size ) )
		end
		return string.format( "<voxscript file=\"%s\"><parameters %s %s %s/></voxscript>", FILENAME, size, shapedata,
		                      palettedata )
	end

	function CreatePalette( entries )
		local palettexml = voxscript { palette = entries }
		return Spawn( palettexml, Transform(), true, false )[1]
	end

	function SetShapePaletteContent( shape, entries )
		local palette = CreatePalette( entries )
		CopyShapePalette( palette, shape )
		Delete( palette )
	end

	function SetShapesPaletteContent( shapes, entries )
		local palette = CreatePalette( entries )
		for i = 1, #shapes do
			CopyShapePalette( palette, shapes[i] )
		end
		Delete( palette )
	end

	function GetShapePaletteContent( shape )
		local forward = GetShapePalette( shape )
		local reverse = {}
		for i = 1, #forward do
			local mat, r, g, b, a, re, sh, me, em = GetShapeMaterial( shape, forward[i] )
			local t = {
				index = forward[i],
				material = mat,
				r = r,
				g = g,
				b = b,
				a = a,
				reflect = re,
				shiny = sh,
				metal = me,
				emissive = em,
			}
			forward[i] = t
			reverse[t.index] = t
		end
		return forward, reverse
	end

	function GetShapesPaletteContent( shapes )
		local forward = {}
		local reverse = {}
		for i = 1, #shapes do
			local shape = shapes[i]
			local usedpalette = GetShapePalette( shape )
			for j = 1, #usedpalette do
				if not reverse[usedpalette[j]] then
					local material, r, g, b, a, re, sh, me, em = GetShapeMaterial( shape, usedpalette[j] )
					local t = {
						index = usedpalette[j],
						material = material,
						r = r,
						g = g,
						b = b,
						a = a,
						reflect = re,
						shiny = sh,
						metal = me,
						emissive = em,
					}
					forward[#forward + 1] = t
					reverse[usedpalette[j]] = t
				end
			end
		end
		return forward, reverse
	end

	function CreateShapeFromContent( content, x2, y2, z2 )
		if not x2 then
			content, x2, y2, z2 = unpack( content )
		end
		local newdataxml = voxscript { shape = content, size = { x2, y2, z2 } }
		local newdata = Spawn( newdataxml, Transform(), true, false )[1]
		SetBrush( "cube", 1, content[1] )
		DrawShapeBox( newdata, 0, 0, 0, 0, 0, 0 )
		SetBrush( "cube", 1, content[#content] )
		DrawShapeBox( newdata, x2 - 1, y2 - 1, z2 - 1, x2 - 1, y2 - 1, z2 - 1 )
		return newdata
	end

	function SetShapeContent( shape, content )
		local x2, y2, z2 = GetShapeSize( shape )
		if type( content[1] ) == "table" then
			content, x2, y2, z2 = unpack( content )
		end
		local newdata = CreateShapeFromContent( content, x2, y2, z2 )
		CopyShapeContent( newdata, shape )
		Delete( newdata )
	end

	function GetShapeContent( shape )
		local content = {}
		local x2, y2, z2 = GetShapeSize( shape )
		for x = 0, x2 - 1 do
			for y = 0, y2 - 1 do
				for z = 0, z2 - 1 do
					local _, _, _, _, _, index = GetShapeMaterialAtIndex( shape, x, y, z )
					content[#content + 1] = index
				end
			end
		end
		return content, x2, y2, z2
	end

	function CarveShape( shape, carver, offset )
		-- TODO: batch carving?
		if type( carver ) == "number" then
			carver = { GetShapeContent( carver ), GetShapeSize( carver ) }
		end
		local oP, oR = Vec( 0, 0, 0 ), Vec( 0, 0, 0 )
		if offset then
			if offset.pos then
				oP = offset.pos
				oR = Vec( GetQuatEuler( offset.rot ) )
			else
				oP = offset
			end
		end
		local original = GetShapeContent( shape )
		local positive = voxscript { shape = original, size = { GetShapeSize( shape ) } }
		local negative = type( carver ) == "string" and string.format( [[<vox file="%s"/>]], carver ) or
			                 voxscript { shape = carver[1], size = { select( 2, unpack( carver ) ) } }
		local xml = string.format( [[
			<body dynamic="true">
				%s
				<group pos="%f %f %f" rot="%f %f %f">
					%s
				</group>
			</body>
		]], positive, oP[1], oP[2], oP[3], oR[1], oR[2], oR[3], negative )
		local body, resultShape, negativeShape = unpack( Spawn( xml, Transform(), false, false ) )
		CopyShapeContent( resultShape, shape )
		SetShapeLocalTransform( shape, TransformToParentTransform( GetShapeLocalTransform( shape ),
		                                                           GetShapeWorldTransform( resultShape ) ) )
		Delete( body )
		Delete( resultShape )
		Delete( negativeShape )
		return shape
	end
else -- <voxscript>
	local sx, sy, sz = GetInt( "size", 1, 1, 1 )
	local shapedata = GetString( "shape" )
	local palettedata = GetString( "palette" )

	local function getbyte( str, offset )
		local a, b = string.byte( str, offset, offset + 1 )
		return (a - 65) * 16 + b - 65
	end

	function init()
		if palettedata and palettedata ~= "" then
			local colors = {}
			for index, m, r, g, b, a, re, sh, me, em in palettedata:gmatch(
				                                            "(%d+)/(%w+)/(%d+)/(%d+)/(%d+)/([%d.]+)/([%d.]+)/([%d.]+)/([%d.]+)/([%d.]+)" ) do
				colors[tonumber( index )] = {
					m,
					tonumber( r ) / 255,
					tonumber( g ) / 255,
					tonumber( b ) / 255,
					tonumber( a ),
					tonumber( re ),
					tonumber( sh ),
					tonumber( me ),
					tonumber( em ),
				}
			end
			for i = 1, 255 do
				if colors[i] then
					CreateMaterial( unpack( colors[i] ) )
				else
					CreateMaterial( "none" ) -- gaps in the palette can't be left out
				end
			end
			if not shapedata or shapedata == "" then
				Vox( 0, 0, 0, 0, 0, 0 )
				for index in pairs( colors ) do
					Material( index )
					Box( index - 1, 0, 0, index, 1, 1 )
				end
			end
		end
		if shapedata and shapedata ~= "" then
			Vox( 0, 0, 0, 0, 0, 0 )
			for i = 0, #shapedata / 2 - 1 do
				local index = getbyte( shapedata, i * 2 + 1 )
				if index > 0 then
					Material( index )
					local x, y, z = math.floor( i / sy / sz ) % sx, math.floor( i / sz ) % sy, i % sz
					Box( x, y, z, x + 1, y + 1, z + 1 )
				end
			end
			Material( 1 ) -- ensure the shape size is as requested
			Box( 0, 0, 0, 1, 1, 1 )
			Box( sx - 1, sy - 1, sz - 1, sx, sy, sz )
		end
	end
end
