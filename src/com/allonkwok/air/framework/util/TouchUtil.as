package com.allonkwok.air.framework.util
{
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 触摸工具类
	 * */
	public class TouchUtil
	{
		private static var _beganPoint:Point;
		private static var _endedPoint:Point;
		
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		
		/**
		 * 判断是否是点击操作
		 * @param	$e	点击事件
		 * @return	Boolean
		 * */
		public static function isClick($e:TouchEvent):Boolean
		{
			var target:DisplayObject = $e.currentTarget as DisplayObject;
			var touchBegan:Touch=$e.getTouch(target, TouchPhase.BEGAN);
			if (touchBegan)
				_beganPoint=touchBegan.getLocation(target);
			
			var touchEnded:Touch=$e.getTouch(target, TouchPhase.ENDED);
			if (touchEnded)
				_endedPoint=touchEnded.getLocation(target);
			
			var distance:int=-1;
			if (_beganPoint && _endedPoint)
				distance=Point.distance(_beganPoint, _endedPoint);
			
			if (touchEnded)
			{
				_beganPoint=null;
				_endedPoint=null;
			}
			
			var result:Boolean=distance != -1 && distance < 20;
			return result;
		}
		
		
		/**
		 * 获取滑动方向
		 * @param	$e	点击事件，返回方向，包括 left, right, up, down
		 * @return	String
		 * */
		public static function getSwipeDirection($e:TouchEvent):String
		{
			var direction:String;
			
			var target:DisplayObject = $e.currentTarget as DisplayObject;
			
			var touchBegan:Touch=$e.getTouch(target, TouchPhase.BEGAN);
			if (touchBegan)
				_beganPoint=touchBegan.getLocation(target);
			
			var touchEnded:Touch=$e.getTouch(target, TouchPhase.ENDED);
			if (touchEnded)
				_endedPoint=touchEnded.getLocation(target);

			if (_beganPoint && _endedPoint)
			{
				var distance:int = Point.distance(_beganPoint, _endedPoint);
				
				if(distance>20)
				{
					var xDist:int = _beganPoint.x - _endedPoint.x;
					var yDist:int = _endedPoint.y - _endedPoint.y;
					
					if(Math.abs(xDist) > Math.abs(yDist))
					{
						if(xDist>0)
						{
							direction = "left";
						}
						else
						{
							direction = "right";					
						}
					}
					else
					{
						if(yDist>0)
						{
							direction = "up";
						}
						else
						{
							direction = "down";
						}
					}
				}
			}
			
			if (touchEnded)
			{
				_beganPoint=null;
				_endedPoint=null;
			}
			
			return direction;
		}
	}
}