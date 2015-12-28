package com.allonkwok.air.framework.util
{
	import flash.net.SharedObject;
	/**
	 * Cookie类
	 * @author Slimming.Chi
	 * 
	 */	
	public class Cookie
	{
		private var _so:SharedObject;
		
		private var _name:String;
		private var _path:String;
		private var _data:Object;
		
		/**
		 * 构造函数
		 * @param name Cookie的名称
		 * @param path 可选, 存取路径
		 */
		public function Cookie($name:String, $path:String=null){
			this._name = $name;
			this._path = $path;
			_so = SharedObject.getLocal($name, $path);
			_data = _so.data;
		}
		
		/**
		 * 设置值
		 * @param $key 键
		 * @param $value 值
		 */
		public function setValue($key:String, $value:Object):void{
			_data[$key] = $value;
			_so.flush();
		}
		
		/**
		 * 获取值
		 * @param $key 键
		 * @return Object
		 */
		public function getValue($key:String):Object{
			return _data[$key];
		}
				
		/**
		 * 清空Cookie
		 */
		public function clear():void{
			_so.clear();
		}
		
	}
}