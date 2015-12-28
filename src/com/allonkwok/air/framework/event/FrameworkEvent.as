package com.allonkwok.air.framework.event
{
	import flash.events.Event;
	
	/**
	 * 框架事件
	 */
	public class FrameworkEvent extends Event
	{
		/**初始化完成*/
		public static const INIT_COMPLETE:String = "initComplete";
		
		/**事件数据*/
		public var data:Object = null;

		/**构造函数
		 * @param	$type	事件类型
		 * @param	$data	事件数据
		 * @param	$bubbles	是否冒泡
		 * @param	$cancelable	是否可取消
		 */
		public function FrameworkEvent($type:String, $data:Object = null, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			this.data = $data;
		}
		
		/**重写clone函数*/
		override public function clone():Event{
			return new FrameworkEvent(type, data, bubbles, cancelable);
		}
	}
}