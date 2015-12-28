package com.allonkwok.air.framework.event
{
	import flash.events.Event;
	
	/**
	 * 文件包下载事件
	 */
	public class FileEvent extends Event
	{
		/**解析错误*/
		public static const PARSE_ERROR:String = "parseError";
		
		/**解压完成*/
		public static const UNZIP_COMPLETE:String = "unzipComplete";
		
		/**事件数据*/
		public var data:Object = null;

		/**构造函数
		 * @param	$type	事件类型
		 * @param	$data	事件数据
		 * @param	$bubbles	是否冒泡
		 * @param	$cancelable	是否可取消
		 */
		public function FileEvent($type:String, $data:Object = null, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			this.data = $data;
		}
		
		/**
		 * 重写clone函数
		 * */
		override public function clone():Event{
			return new FileEvent(type, data, bubbles, cancelable);
		}
	}
}