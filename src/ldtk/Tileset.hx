package ldtk;

class Tileset {
	public var identifier : String;

	/**
		Path to the atlas image file, relative to the Project file
	**/
	public var relPath : String;

	public var tileGridSize : Int;
	var pxWid : Int;
	var pxHei : Int;
	var cWid(get,never) : Int; inline function get_cWid() return Math.ceil(pxWid/tileGridSize);


	public function new(json:ldtk.Json.TilesetDefJson) {
		identifier = json.identifier;
		tileGridSize = json.tileGridSize;
		relPath = json.relPath;
		pxWid = json.pxWid;
		pxHei = json.pxHei;
	}

	/**
		Get X pixel coordinate (in atlas image) from a specified tile ID
	**/
	public inline function getAtlasX(tileId:Int) {
		return ( tileId - Std.int( tileId / cWid ) * cWid ) * tileGridSize;
	}

	/**
		Get Y pixel coordinate (in atlas image) from a specified tile ID
	**/
	public inline function getAtlasY(tileId:Int) {
		return Std.int( tileId / cWid ) * tileGridSize;
	}

	#if( sys && deepnightLibs )
	/**
		Read the atlas image haxe.io.Bytes from the disk
	**/
	public function loadAtlasBytes(project:ldtk.Project) : Null<haxe.io.Bytes> {
		try {
			var filePath = dn.FilePath.fromFile(relPath);
			var path = filePath.hasDriveLetter() ? filePath : dn.FilePath.fromFile(project.projectDir+"/"+relPath);
			var fi = sys.io.File.read(path.full,true);
			return fi.readAll();
		}
		catch(e:Dynamic) {
			return null;
		}
	}
	#end


	#if( !macro && heaps )

	/**
		Read the atlas h2d.Tile directly from the file
	**/
	#if( sys && deepnightLibs )
	public function loadAtlasTileFromDisk(project:ldtk.Project) : Null<h2d.Tile> {
		var bytes = loadAtlasBytes(project);
		var tile = dn.ImageDecoder.decodeTile(bytes);
		return tile;
	}
	#end

	/**
		Get a h2d.Tile from a Tile ID.

		"flipBits" can be: 0=no flip, 1=flipX, 2=flipY, 3=bothXY
	**/
	public inline function getHeapsTile(atlasTile:h2d.Tile, tileId:Int, flipBits:Int=0) : Null<h2d.Tile> {
		if( tileId<0 )
			return null;
		else {
			var t = atlasTile.sub( getAtlasX(tileId), getAtlasY(tileId), tileGridSize, tileGridSize );
			return switch flipBits {
				case 0: t;
				case 1: t.flipX(); t.setCenterRatio(0,0); t;
				case 2: t.flipY(); t.setCenterRatio(0,0); t;
				case 3: t.flipX(); t.flipY(); t.setCenterRatio(0,0); t;
				case _: throw "Unsupported flipBits value";
			};
		}
	}

	/**
		Get a h2d.Tile from a Auto-Layer tile.
	**/
	public inline function getAutoLayerHeapsTile(atlasTile:h2d.Tile, autoLayerTile:ldtk.Layer_AutoLayer.AutoTile) : Null<h2d.Tile> {
		if( autoLayerTile.tileId<0 )
			return null;
		else
			return getHeapsTile(atlasTile, autoLayerTile.tileId, autoLayerTile.flips);
	}
	#end

}
