package com.allonkwok.air.framework.util
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import com.allonkwok.air.framework.event.FileEvent;
	import com.allonkwok.air.framework.event.Messager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipErrorEvent;
	import deng.fzip.FZipFile;

	/**
	 * 文件类
	 * */
	public class FileUtil
	{

		/**
		 * 获取文件的字节码
		 * @param	$url	文件地址
		 * @return	ByteArray
		 * */
		public static function getByteArray($url:String):ByteArray{
			
			var file:File = new File($url);
			var bytes:ByteArray = new ByteArray();
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			stream.readBytes(bytes, 0, stream.bytesAvailable);
			stream.close();
			//bytes.compress();
			return bytes;
		}
		
		/**
		 * 获取图片文件的BitmapData，只支持jpg和png
		 * @param	$url	文件地址
		 * @return	BitmapData
		 * */
		public static function getBitmapData($url:String):BitmapData{
						
			var bytes:ByteArray = getByteArray($url);
			var bmd:BitmapData = BitmapEncoder.decodeFromByteArray(bytes);
						
			/*
			//var bytes:ByteArray = loader.data;
			var isFinish:Boolean;
			var bmd:BitmapData = new BitmapData(1024,2048);
			var loader:Loader = new Loader();
			loader.loadBytes(bytes);
			loader.addEventListener(Event.COMPLETE, function(){
				isFinish = true;
				bmd.draw(loader);
				trace(bmd);
			});
			while(!isFinish){
				trace("while !loader.content");
			}
			*/
			//var bmd:BitmapData = Bitmap(loader.content).bitmapData;
			
			return bmd;
		}
		
		/**
		 * 获取图片文件
		 * @param	$url	文件地址
		 * @return	Bitmap
		 * */
		public static function getBitmap($url:String):Bitmap{
			
			var bmd:BitmapData = getBitmapData($url);
			var bmp:Bitmap = new Bitmap(bmd, "auto", true);
			
			return bmp;
		}
		
		/**
		 * 获取文件中的字符串
		 * @param	$url	文件地址
		 * @return	String
		 * */
		public static function getString($url:String):String{
			var bytes:ByteArray = getByteArray($url);
			//bytes.uncompress();
			var str:String = bytes.readUTFBytes(bytes.bytesAvailable);
			//trace("str:"+str);
			return str;
		}
		
		/**
		 * 获取XML文件
		 * @param	$url	文件地址
		 * @return	XML
		 * */
		public static function getXml($url:String):XML{
			var str:String = getString($url);
			var xml:XML = XML(str);
			return xml;
		}
		
		/**
		 * 加压压缩包
		 * @param	$url	压缩包地址
		 * */
		public static function unzip($url:String):void{
			var zip:FZip=new FZip;
			zip.load(new URLRequest($url));
			
			zip.addEventListener(FZipErrorEvent.PARSE_ERROR, function(){
				
				trace("FZipErrorEvent.PARSE_ERROR");
				Messager.getInstance().dispatchEvent(new FileEvent(FileEvent.PARSE_ERROR));
				
			});
			
			zip.addEventListener(flash.events.Event.COMPLETE, function(e:flash.events.Event)
			{
				try{
					var fc:int=zip.getFileCount();
					for (var i:int=0; i < fc; i++)
					{
						var zipfile:FZipFile=zip.getFileAt(i);
						var bytes:ByteArray=zipfile.content;
						var file:File=new File($url.substr(0, $url.length - 4) + "/" + zipfile.filename);
						trace("extract file.url:", file.url);
						var fs:FileStream=new FileStream;
						fs.open(file, FileMode.WRITE);
						fs.writeBytes(bytes, 0, bytes.length);
						fs.close();
					}
					zip.close();
				}
				catch(e){
					
				}
				file = new File($url);
				file.deleteFile();
				
				Messager.getInstance().dispatchEvent(new FileEvent(FileEvent.UNZIP_COMPLETE));
				trace("complete!");
				
			});			
		}
		
	}
}