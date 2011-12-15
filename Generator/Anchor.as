package Generator
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Anchor extends MovieClip
	{
		public var PointA:MovieClip;
		public var PointB:MovieClip;
		public var Center:MovieClip;
		public var Line:MovieClip;
		
		private var DraggingPoint:MovieClip;
		private var OtherPoint:MovieClip;
		
		public function Anchor(_StartX:int, _StartY:int)
		{
			Line = new MovieClip();
			Line.graphics.lineStyle(4, 0x99FF00);
			Line.graphics.moveTo(_StartX, _StartY);
			Line.graphics.lineTo(_StartX, _StartY + 100);
			addChild(Line);
			
			PointA = new MovieClip();
			PointA.name = "PointA";
			PointA.graphics.beginFill(0xFFFFFF);
			PointA.graphics.drawCircle(0, 0, 6);
			PointA.graphics.endFill();
			PointA.x = _StartX;
			PointA.y = _StartY;
			addChild(PointA);
			
			PointB = new MovieClip();
			PointB.name = "PointB";
			PointB.graphics.beginFill(0xFFFFFF);
			PointB.graphics.drawCircle(0, 0, 6);
			PointB.graphics.endFill();
			PointB.x = _StartX;
			PointB.y = _StartY + 100;			
			addChild(PointB);
			
			Center = new MovieClip();
			Center.graphics.beginFill(0x999999);
			Center.graphics.drawCircle(0, 0, 6);
			Center.graphics.endFill();
			Center.x = _StartX;
			Center.y = _StartY + 50;			
			addChild(Center);
			
			PointA.addEventListener(MouseEvent.MOUSE_DOWN, StartMove);
			PointA.addEventListener(MouseEvent.MOUSE_UP, StopMove);
			PointB.addEventListener(MouseEvent.MOUSE_DOWN, StartMove);
			PointB.addEventListener(MouseEvent.MOUSE_UP, StopMove);
			Center.addEventListener(MouseEvent.MOUSE_DOWN, StartDrag);
			Center.addEventListener(MouseEvent.MOUSE_UP, StopDrag);
			Line.addEventListener(MouseEvent.MOUSE_DOWN, StartDrag);
			Line.addEventListener(MouseEvent.MOUSE_UP, StopDrag);
		}
		
		public function StartDrag(e:MouseEvent):void
		{
			this.addEventListener(Event.ENTER_FRAME, RefreshLine);
			this.startDrag();
		}
		
		public function StopDrag(e:MouseEvent):void
		{
			this.removeEventListener(Event.ENTER_FRAME, RefreshLine);
			this.stopDrag();
			
			var XDifference:int = 150 > this.x ? (150 - this.x) * -1 : this.x - 150;
			var YDifference:int = 150 > this.y ? (150 - this.y) * -1 : this.y - 150;
			
			this.x = 150;
			this.y = 150;
			
			PointA.x += XDifference;
			PointA.y += YDifference;
			PointB.x += XDifference;
			PointB.y += YDifference;
			Center.x += XDifference;
			Center.y += YDifference;

			RefreshLine(null)
		}
		
		public function StartMove(e:MouseEvent):void
		{
			var AnchorPoint:MovieClip = MovieClip(e.target);
			AnchorPoint.addEventListener(Event.ENTER_FRAME, RotateAndDrag);
			DraggingPoint = AnchorPoint;
			OtherPoint = DraggingPoint.name == "PointA" ? PointB : PointA;
			AnchorPoint.startDrag();
		};
		
		public function StopMove(e:MouseEvent):void
		{
			var AnchorPoint:MovieClip = MovieClip(e.target);
			AnchorPoint.removeEventListener(Event.ENTER_FRAME, RotateAndDrag);
			AnchorPoint.stopDrag();
			
			DraggingPoint = null;
			OtherPoint = null;
		}
		
		public function RotateAndDrag(e:Event):void
		{
			var Radius:Number = GetRadius();
			var Angle:Number = GetAngle();
			OtherPoint.x = Math.cos(Angle) * Radius + Center.x;
			OtherPoint.y = Math.sin(Angle) * Radius + Center.y;
			RefreshLine(null);
		}
		
		public function RefreshLine(e:Event):void
		{
			Line.graphics.clear();
			Line.graphics.lineStyle(4, 0x99FF00);
			Line.graphics.moveTo(PointA.x, PointA.y);
			Line.graphics.lineTo(PointB.x, PointB.y);
			Globals.Path.Draw();
		}
		
		private function GetRadius():Number
		{
			var SideA:Number = Math.abs(DraggingPoint.x - Center.x);
			var SideB:Number = Math.abs(DraggingPoint.y - Center.y);
			
			return Math.sqrt(Math.pow(SideA, 2) + Math.pow(SideB ,2));
		}
		
		private function GetAngle():Number
		{
			var SideA:Number = Math.abs(DraggingPoint.x - Center.x);
			var SideB:Number = Math.abs(DraggingPoint.y - Center.y);
			var Angle:Number;

			Angle = Math.atan(SideA / SideB) * (180 / Math.PI);
			
			if(DraggingPoint.y >= Center.y && DraggingPoint.x >= Center.x)
				Angle = 180 - Angle;
			else if (DraggingPoint.y >= Center.y && DraggingPoint.x <= Center.x)
				Angle = 180 + Angle;
			else if(DraggingPoint.y <= Center.y && DraggingPoint.x <= Center.x)
				Angle = 360 - Angle;
			
			if(Angle <= 0)
				Angle = 0;
				
				Angle += 90;
			 
			return Angle * (Math.PI / 180);
		}
	}
}