package led;

class Layer_Tiles extends led.Layer {
	var tiles : Map<Int,Int>;

	public function new(json) {
		super(json);
		tiles = new Map();
		for(t in json.gridTiles)
			tiles.set(t.coordId, t.v);
	}

	/**
		Return the tile ID at coords, or -1 if there is none.
	**/
	public inline function getTileIdAt(cx:Int,cy:Int) : Int {
		return isCoordValid(cx,cy) && tiles.exists(getCoordId(cx,cy))
			? tiles.get( getCoordId(cx,cy) )
			: -1;
	}
}
