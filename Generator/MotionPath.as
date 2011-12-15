package Generator
{
	import flash.display.MovieClip;
	import flash.geom.Point;//
	
	public class MotionPath extends MovieClip
	{
		public var Line:MovieClip;
		
		public function MotionPath() 
		{ 
			Line = new MovieClip();
			Line.x = 0;
			Line.y = 0;
			addChild(Line);		
		}
		
		public function Draw()
		{
			Globals.Data = new Array();			
			Line.graphics.clear();
			Line.graphics.lineStyle(4, 0xFFCC33);
			Line.graphics.moveTo(Globals.Anchors[0].Center.x, Globals.Anchors[0].Center.y);
			
			for(var i=0; i<=Globals.Anchors.length - 2; i++)
			{
				var Anchor1:Anchor = Globals.Anchors[i];
				var Anchor2:Anchor = Globals.Anchors[i + 1];
				
				for(var j:Number=0; j<=1; j+=1/550) 
				{
					var XPosition:Number = Math.pow(j ,3) * (Anchor2.Center.x + 3 * (Anchor1.PointB.x - Anchor2.PointA.x) - Anchor1.Center.x) + 3 * Math.pow(j, 2) * (Anchor1.Center.x - 2 * Anchor1.PointB.x + Anchor2.PointA.x) + 3 * j * (Anchor1.PointB.x - Anchor1.Center.x) + Anchor1.Center.x;
					var YPosition:Number = Math.pow(j, 3) * (Anchor2.Center.y + 3 * (Anchor1.PointB.y - Anchor2.PointA.y) - Anchor1.Center.y) + 3 * Math.pow(j, 2) * (Anchor1.Center.y - 2 * Anchor1.PointB.y + Anchor2.PointA.y) + 3 * j * (Anchor1.PointB.y - Anchor1.Center.y) + Anchor1.Center.y;
					Line.graphics.lineTo(XPosition, YPosition);
						
					if(XPosition > -50 && YPosition > -50 && YPosition < 450)
					{						
						Globals.Data.push(new Point(XPosition, YPosition));
					}
				} 
				
				Line.graphics.lineTo(Anchor2.Center.x, Anchor2.Center.y);
				Globals.Data.push(new Point(Anchor2.Center.x,Anchor2.Center.y));
			}
		}
	}
}