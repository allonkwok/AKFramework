package com.allonkwok.air.framework.util{

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * 图像编码转换器，静态类
	 * 
	 * */
	public class BitmapEncoder {
		
		/**
		 * 将BitmapData转化为ByteArray
		 * @param	$data	位图数据
		 * @return	ByteArray
		 * */
		public static function encodeToByteArray($data:BitmapData):ByteArray{
			if($data == null){
				throw new Error("$data参数不能为空!");
			}
			var bytes:ByteArray = $data.getPixels($data.rect);
			bytes.writeShort($data.width);
			bytes.writeShort($data.height);
			bytes.writeBoolean($data.transparent);
			//bytes.compress();
			return bytes;
		}
		
		/**
		 * 将BitmapData转化为Base64字符串
		 * @param	$data	位图数据
		 * @return	Base64
		 * */
		public static function encodeToBase64($data:BitmapData):String{
			return Base64.encodeFromByteArray(encodeToByteArray($data));
		}
		
		/**
		 * 将ByteArray转换为BitmapData
		 * @param	$bytes	字节码
		 * @return	ByteArray
		 * */
		public static function decodeFromByteArray($bytes:ByteArray):BitmapData{
			if($bytes == null){
				throw new Error("$bytes参数不能为空!");
			}
			//$bytes.uncompress();
			if($bytes.length < 6){
				throw new Error("$bytes参数为无效值!");
			}
			
			trace("===============================================");
			
			trace("$bytes.position:"+$bytes.position);
			trace("$bytes.length:"+$bytes.length);
			trace("$bytes.bytesAvailable:"+$bytes.bytesAvailable);
			
			$bytes.position = $bytes.length - 1;
			
			var transparent:Boolean = $bytes.readBoolean();
			trace("transparent:"+transparent);
			
			$bytes.position = $bytes.length - 3;
			var height:int = $bytes.readShort();
			
			trace("height:"+height);
			$bytes.position = $bytes.length - 5;
			
			var width:int = $bytes.readShort();
			trace("width:"+width);
			
			$bytes.position = 0;
			
			trace("===============================================");
			trace("$bytes.position:"+$bytes.position);
			trace("$bytes.length:"+$bytes.length);
			trace("$bytes.bytesAvailable:"+$bytes.bytesAvailable);
			
			//var datas:ByteArray = new ByteArray();			
			//$bytes.readBytes(datas, 0, $bytes.bytesAvailable);
			
			var bmd:BitmapData = new BitmapData(1024, 1024, transparent, 0);
			bmd.setPixels(new Rectangle(0, 0, 1024, 1024), $bytes);
			
			return bmd;
		}
		
		/**
		 * 将Base64字符串转化为BitmapData
		 * @param	$data	Base64字符串
		 * @return	BitmapData
		 * */
		public static function decodeFromBase64($data:String):BitmapData{			
			return decodeFromByteArray(Base64.decodeToByteArray($data));
		}		
		
		/**
		 * 构造函数，被执行后将抛出错误
		 * */
		public function BitmapEncoder() {
			throw new Error("BitmapEncoder是静态类，不能实例化！");
		}
		
	}
	
}
