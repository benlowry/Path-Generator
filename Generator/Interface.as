package Generator
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.geom.Point;
	
	public class Interface extends MovieClip
	{
		public function Interface()
		{
			var Anchor1:Anchor = new Anchor(-50, 100);
			Anchor1.name = "Anchor1";
			Anchor1.x = 150;
			Anchor1.y = 150;
			addChild(Anchor1);
						
			var Anchor2:Anchor = new Anchor(600, 100);
			Anchor2.name = "Anchor2";
			Anchor2.x = 150;
			Anchor2.y = 150;
			addChild(Anchor2);
			
			var Path:MotionPath = new MotionPath();
			Path.name = "Path";
			Path.x = 150;
			Path.y = 150;
			Path.addEventListener(MouseEvent.MOUSE_DOWN, AddPath);
			addChild(Path);
			
			setChildIndex(Path, 0);
			
			Globals.Anchors.push(Anchor1);
			Globals.Anchors.push(Anchor2);
			Globals.Path = Path;
			Globals.Path.Draw();
			
			GenerateButton.addEventListener(MouseEvent.MOUSE_DOWN, ASOutput);
			CloseButton.addEventListener(MouseEvent.MOUSE_DOWN, ASClose);
			CloseButton.visible = false;
			Code.visible = false;
		}
		
		private function AddPath(e:MouseEvent)
		{
			var MouseX:int = e.target.mouseX;
			var MouseY:int = e.target.mouseY;
			
			var NewAnchor:Anchor = new Anchor(MouseX, MouseY - 50);
			NewAnchor.name = "Anchor" + (Globals.Anchors.length + 1);
			NewAnchor.x = 150;
			NewAnchor.y = 150;
			addChild(NewAnchor);
			setChildIndex(NewAnchor, 0);

			var ClosestLeft:int = -1;
			var InsertAfter:int = 0;
			
			for(var i:int=0; i<Globals.Anchors.length; i++)
			{
				if(Globals.Anchors[i].Center.x > ClosestLeft && Globals.Anchors[i].Center.x < NewAnchor.Center.x)
				{
					ClosestLeft = Globals.Anchors[i].Center.x;
					InsertAfter = i;
				}
			}

			Globals.Anchors.splice(InsertAfter + 1,0, NewAnchor);
		}
		
		private function ASOutput(e:MouseEvent):void
		{
			var NumPoints:int = Globals.Data.length;
			Code.visible = true;
			Code.CodeOutput.text = "";
			Code.CodeOutput.text = "public static var Path:Array = new Array(" + NumPoints + ");\n";
			CloseButton.visible = true;
			
			for(var i:Number=Globals.Data.length - 1; i >-1; i--)
			{			
				var point:Point = Globals.Data[i] as Point;
				Code.CodeOutput.text += "Path[" + (NumPoints - i - 1) + "] = { x: " + (Math.round(point.x * 100) / 100) + ", y: " + (Math.round(point.y * 100) / 100) + " };\n";
			}
		}
		
		private function ASClose(e:MouseEvent):void
		{
			Code.visible = false;
			CloseButton.visible = false;
		}
	}
}