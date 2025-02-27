package ldtk;

enum NeighbourDir {
	North;
	South;
	West;
	East;
}

class Level {
	public var uid : Int;
	public var identifier : String;
	public var pxWid : Int;
	public var pxHei : Int;
	public var worldX : Int;
	public var worldY : Int;
	public var bgColor : UInt;
	public var allUntypedLayers(default,null) : Array<Layer>;
	public var neighbours : Array<{ levelUid:Int, dir: NeighbourDir }>; // TODO resolve level instance

	public function new(project:ldtk.Project, json:ldtk.Json.LevelJson) {
		uid = json.uid;
		identifier = json.identifier;
		pxWid = json.pxWid;
		pxHei = json.pxHei;
		worldX = json.worldX;
		worldY = json.worldY;
		bgColor = Project.hexToInt(json.__bgColor);
		neighbours = [];
		allUntypedLayers = [];
		for(json in json.layerInstances)
			allUntypedLayers.push( _instanciateLayer(json) );

		if( json.__neighbours!=null )
			for(n in json.__neighbours)
				neighbours.push({
					levelUid: n.levelUid,
					dir: switch n.dir {
						case "n": North;
						case "s": South;
						case "w": West;
						case "e": East;
						case _: trace("WARNING: unknown neighbour level dir: "+n.dir); North;
					},
				});
	}

	function _instanciateLayer(json:ldtk.Json.LayerInstanceJson) : ldtk.Layer {
		return null; // overriden by Macros.hx
	}
}
