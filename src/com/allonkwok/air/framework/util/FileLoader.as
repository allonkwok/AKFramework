package com.allonkwok.air.framework.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.utils.ByteArray;

	
	/**
	 * 文件断点续传下载类
	 */
	public class FileLoader extends EventDispatcher
	{
		private var _srcUrl:String;
		private var _destUrl:String;
		private var _range:uint = 0;
		private var _fileSize:Number = 0;
		private var _start:uint = 0;
		private var _end:uint = 0;
		private var _file:File;
		private var _loader:URLLoader;
		private var _isOpen:Boolean;
		
		/**
		 * 构造函数
		 * @param	$srcUrl	源文件的地址
		 * @param	$destUrl	文件保存的地址
		 * @param	$range	每次夹在的文件长度，默认每次请求50K
		 */
		public function FileLoader($srcUrl:String, $destUrl:String, $range:uint=51200){
			_srcUrl = $srcUrl;
			_destUrl = $destUrl;
			_range = $range;
			_file = new File(_destUrl);
		}
		
		/**
		 * 开始下载
		 * */
		public function start():void{
			getFileSize();
		}
		
		/**
		 * 停止下载
		 * */
		public function stop():void{
			_loader.removeEventListener(Event.COMPLETE, onSegmentComplete);
			//if(_isOpen){
			//	_loader.close();
			//}
			_loader = null;
		}
		
		/**
		 * 源地址
		 * */
		public function get srcUrl():String{
			return _srcUrl;
		}
		
		/**
		 * 目标地址
		 * */
		public function get destUrl():String{
			return _destUrl;
		}
		
		private function getFileSize():void{
			
			_isOpen = false;
			
			var request:URLRequest = new URLRequest(_srcUrl);
			_loader = new URLLoader;
			_loader.load(request);
			_loader.addEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			_loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpResponseStatus);
			_loader.addEventListener(Event.OPEN, onOpen);
		}
		
		private function onIoError($e:IOErrorEvent):void{
			dispatchEvent($e);
		}
		
		private function onLoaderProgress($e:ProgressEvent):void{
			var loader:URLLoader = $e.target as URLLoader;
			loader.removeEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
			_fileSize = loader.bytesTotal; 
			trace("_fileSize:"+_fileSize);
			loader.close();
			loader = null;
			download();
		}
		
		private function download():void{
			trace("download()");
			
			_isOpen = false;
			
			var stream:FileStream=new FileStream();
			
			//如果文件是存在的，就说明下载过，需要计算从哪个点开始下载
			if (_file.exists)
			{ 
				stream.open(_file, FileMode.READ);
				_start = stream.bytesAvailable;
				stream.close();
				_file.cancel();
			}
			
			//确定下载的区间范围，比如0-10000
			if (_start + _range > _fileSize)
			{ 
				_end = _fileSize;
			}
			else
			{
				_end = _start + _range;
			}
			
			//注意这里很关键，我们在请求的Header里包含对Range的描述，这样服务器会返回文件的某个部分
			var header:URLRequestHeader = new URLRequestHeader("Range", "bytes=" + _start + "-" + _end);
			var request:URLRequest = new URLRequest(_srcUrl);
			request.requestHeaders.push(header);
			_loader = new URLLoader;
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.load(request);
			_loader.addEventListener(Event.COMPLETE, onSegmentComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			_loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpResponseStatus);
			_loader.addEventListener(Event.OPEN, onOpen);
		}
		
		private function onHttpStatus($e:HTTPStatusEvent):void{
			//trace("onHttpStatus $e:", $e);
			dispatchEvent($e);
		}
		
		private function onHttpResponseStatus($e:HTTPStatusEvent):void{
			//trace("onHttpResponseStatus $e:", $e);
			dispatchEvent($e);
		}
		
		private function onOpen($e:Event):void{
			_isOpen = true;
		}
		
		private function onSegmentComplete($e:Event):void{
			trace("onSegmentComplete($e:Event)");
			var loader:URLLoader = $e.target as URLLoader;
			var bytes:ByteArray = loader.data;
			loader.removeEventListener(Event.COMPLETE, onSegmentComplete);
			loader.close();
			loader = null;
			
			_file.cancel();
			
			var stream:FileStream = new FileStream;
			stream.open(_file, FileMode.UPDATE);
			stream.position = stream.bytesAvailable;
			stream.writeBytes(bytes, 0, bytes.length);
			stream.close();
			
			_file.cancel();
			
			
			var progress:int = _end / _fileSize * 100;
			
			trace("_end:"+_end, "_fileSize:"+_fileSize, "progress:"+progress);
			
			if(progress<100){
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _end, _fileSize));
				download();
			}else{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
	}
}