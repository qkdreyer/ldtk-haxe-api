class Main {
	var gt : test.GameTest;
	var mini : test.Mini;

	public function new() {
		gt = new test.GameTest(#if hl hxd.Res.gameTest.entry.getText() #end);
		// trace(gt.all_levels.Level0.l_Objects.all_Mob[0]);

		// mini = new test.Mini();
		// var l = p.all_levels.Level0.l_Objects;
		// var e = l.all_Mob[0];
		// trace(e);
		// var v = switch e.f_loot {
		// 	case Food: "f";
		// 	case Gold: "g";
		// 	case Ammo: "a";
		// }
		// trace(v);

		tilesetRender();
		intGridRender();
		hotReloadTest();
	}

	function tilesetRender() {
		#if hl
		var l = p.all_levels.Level0.l_Bg;
		var atlas = hxd.Res.atlas.gif87a.toTile();
		for(cx in 0...l.cWid)
		for(cy in 0...l.cHei) {
			if( !l.hasTileAt(cx,cy) )
				continue;

			var t = l.tileset.getH2dTile(atlas, l.getTileIdAt(cx,cy));
			var b = new h2d.Bitmap(t, BootHl.ME.s2d);
			b.x = cx*l.gridSize;
			b.y = cy*l.gridSize;
		}
		#end
	}

	function intGridRender() {
		var l = gt.all_levels.Level0.l_Collisions;

		#if hl
		var off = 500;
		// Bg
		var g = new h2d.Graphics(BootHl.ME.s2d);
		g.beginFill(0xffffff);
		g.drawRect(off,0, l.cWid*l.gridSize, l.cHei*l.gridSize);

		// Layer render
		for(cx in 0...l.cWid)
		for(cy in 0...l.cHei) {
			if( !l.hasValue(cx,cy) )
				continue;

			var c = l.getColorInt(cx,cy);
			g.beginFill(c);
			g.drawRect(off+cx*l.gridSize, cy*l.gridSize, l.gridSize, l.gridSize);
		}
		#end
	}

	function hotReloadTest() {
		#if hl
		hxd.Res.gameTest.watch( function() {
			// File changed
			trace("reloaded!");
			BootHl.ME.s2d.removeChildren();
			p.parseJson( hxd.Res.gameTest.entry.getText() );
			intGridRender();
			tilesetRender();
		});
		#end
	}
}

