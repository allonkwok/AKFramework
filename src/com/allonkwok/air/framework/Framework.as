package com.allonkwok.air.framework
{
	import com.allonkwok.air.framework.event.FrameworkEvent;
	import com.allonkwok.air.framework.event.Messager;
	import com.allonkwok.air.framework.util.FileUtil;
	import com.allonkwok.air.framework.view.ViewBase;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Screen;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.AssetManager;

	/**框架主类*/
	public class Framework
	{
		/**框架版本号*/
		public static const VERSION:String = "1.0.0";
		
		/**基准宽度*/
		public static var baseWidth:int;
		
		/**基础高度*/
		public static var baseHeight:int;
		
		/**数据库路径*/
		public static var db:String;
		
		/**存储目录*/
		public static var storeDir:File;
				
		/**字体列表*/
		public static var fonts:Dictionary;
		
		/**字号*/
		public static var sizes:Dictionary;
		
		/**颜色*/
		public static var colors:Dictionary;
		
		/**样式*/
		public static var style:StyleSheet;
		
		/**可用宽度*/
		public static var enabledWidth:int;
		
		/**可用高度*/
		public static var enabledHeight:int;
		
		/**调整高度*/
		public static var offsetHeight:int;
		
		/**状态栏高度*/
		public static var statusBarHeight:int;
		
		/**缩放比例*/
		public static var scale:Number;
		
		/**缩放后的可用高度*/
		public static var scaledEnabledHeight:int;
		
		/**是否Air*/
		public static var isAir:Boolean;
		
		/**是否iOS*/
		public static var isIOS:Boolean;
		
		/**是否新的iOS*/
		public static var isNewIOS:Boolean;
		
		/**是否Android*/
		public static var isAndroid:Boolean;
		
		/**上上页*/
		public static var earlyId:String;
		
		/**上一页*/
		public static var previousId:String;
		
		/**当前页*/
		public static var currentId:String;

		/**资源管理器*/
		public static var assetManager:AssetManager;
				
		private static var _starling:Starling;
				
		private static var _atlases:Vector.<Object>;
		
		private static var _viewIds:Vector.<String>;
		
		private static var _navigator:ScreenNavigator;
		
		private static var _viewData:Object;
		
		private static var _viewPort:Rectangle;
		
		private static var _xmlUrl:String;
		
		private static var _xml:XML;
		
		private static var _isDebug:Boolean;
		
		private static var _debugTxt:TextField;
		
		private static var _handleLostContext:Boolean;
		
		private static var _isInitComplete:Boolean;
										
		/**
		 * 初始化
		 * @param	$stage	flash舞台
		 * @param	$startClass		Starling入口类
		 * @param	$xmlUrl	配置文件地址
		 * @param	$handleLostContext	是否处理丢失上下文
		 * @param	$detectActiveState	是否检测舞台激活状态
		 * @return	void
		 * */
		public static function init($stage:Stage, $startClass:Class, $xmlUrl:String=null, $handleLostContext:Boolean=false, $detectActiveState:Boolean=false, $isDebug:Boolean=false):void
		{
			$stage.align = StageAlign.TOP_LEFT;
			$stage.scaleMode = StageScaleMode.NO_SCALE;
			
			NativeApplication.nativeApplication.systemIdleMode=SystemIdleMode.KEEP_AWAKE;
			
			if($detectActiveState)
			{
				NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, onActivate);
				NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, onDeactivate);
			}
			
			_handleLostContext = $handleLostContext;
			_viewIds = new Vector.<String>;
			
			_xmlUrl = $xmlUrl;
			if(_xmlUrl){
				var url:String = File.applicationDirectory.resolvePath($xmlUrl).url;
				_xml = FileUtil.getXml(url);
			}
			
			_isDebug = $isDebug;
			
			trace("Capabilities.manufacturer:", Capabilities.manufacturer);
			trace("Capabilities.os:", Capabilities.os);
			
			isIOS = Capabilities.manufacturer.indexOf("iOS") > -1;
			isAndroid = Capabilities.manufacturer.indexOf("Android") > -1;
			isAir = Capabilities.manufacturer.indexOf("Windows") > -1;
			isNewIOS = Capabilities.os.indexOf("iPhone")>-1 && (Capabilities.os.indexOf("7")>-1 || Capabilities.os.indexOf("8")>-1 || Capabilities.os.indexOf("9")>-1);
			
			initStarling($stage, $startClass);
		}
		
		private static function initStarling($stage:Stage, $startClass:Class):void{
			
			trace("stageWidth:"+$stage.stageWidth, "stageHeight:"+$stage.stageHeight);
			trace("fullScreenWidth:"+$stage.fullScreenWidth, "fullScreenHeight:"+$stage.fullScreenHeight);
			trace("screenResolutionX:"+Capabilities.screenResolutionX, "screenResolutionY:"+Capabilities.screenResolutionY);
			trace("Capabilities.screenDPI:"+Capabilities.screenDPI);
			trace("Screen.mainScreen.visibleBounds:"+Screen.mainScreen.visibleBounds);
			
			var b:Rectangle = Screen.mainScreen.visibleBounds;
			var w:int = b.width;
			var h:int = b.height;
			
			if(_xml)
			{
				baseWidth = _xml.baseWidth;
				baseHeight = _xml.baseHeight;
			}
			else
			{
				baseWidth = 640;
				baseHeight = 960;
			}
			
			offsetHeight = h - baseHeight;
			
			enabledWidth = w;
			enabledHeight = h;
			
			statusBarHeight = Capabilities.screenResolutionY - enabledHeight;
			
			scale = enabledWidth/baseWidth;
			
			trace("enabledWidth:"+enabledWidth);
			trace("enabledHeight:"+enabledHeight);
			trace("offsetHeight:"+offsetHeight);
			trace("statusBarHeight:"+statusBarHeight);
			trace("scale:"+scale);
			
			if (!isAir)
			{
				if(isNewIOS)
				{
					_viewPort = new Rectangle(0, statusBarHeight, enabledWidth, enabledHeight);
				}
				else
				{
					_viewPort = new Rectangle(0, 0, enabledWidth, enabledHeight);
				}
			}
			else
			{
				
				enabledWidth = $stage.fullScreenWidth;
				enabledHeight = $stage.fullScreenHeight - 20;
				
				scale = enabledWidth/baseWidth;
				
				statusBarHeight = 20;
				
				_viewPort=new Rectangle(0, 0, enabledWidth, enabledHeight);
			}
			
			scaledEnabledHeight = enabledHeight/scale;
			
			trace("Starling.VERSION:", Starling.VERSION);
			
			Starling.multitouchEnabled = false;
			Starling.handleLostContext = _handleLostContext;
			_starling = new Starling($startClass, $stage, _viewPort);
			_starling.simulateMultitouch = false;
			_starling.enableErrorChecking = false;
			_starling.addEventListener(starling.events.Event.CONTEXT3D_CREATE, function(){
				trace("CONTEXT3D_CREATE");
			});
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, function(){
				trace("ROOT_CREATED");
				if(!_isInitComplete)
				{
					_isInitComplete = true;
					if(_xmlUrl)
					{
						initConfig();
					}
					else
					{
						Messager.getInstance().dispatchEvent(new FrameworkEvent(FrameworkEvent.INIT_COMPLETE));
					}
				}
			});
			/*
			_starling.addEventListener(starling.events.Event.FATAL_ERROR, function(){
				trace("FATAL_ERROR");
			});
			*/
			_starling.start();
			
			if(_isDebug)
			{
				_debugTxt = new TextField;
				_debugTxt.mouseEnabled = false;
				//_debugTxt.border = true;
				_debugTxt.width = enabledWidth;
				_debugTxt.height = enabledHeight;
				_debugTxt.wordWrap = true;
				_debugTxt.multiline = true;
				//_debugTxt.autoSize = TextFieldAutoSize.LEFT;
				$stage.addChild(_debugTxt);
				$stage.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
				$stage.doubleClickEnabled = true;
			}
			
		}
				
		private static function onDeactivate($e:flash.events.Event):void
		{
			trace("onDeactivate");
			if(_starling && _starling.isStarted){
				trace("_starling.stop()");
				_starling.stop();
			}
		}
		
		private static function onActivate($e:flash.events.Event):void
		{
			trace("onActivate");
			if(_starling && !_starling.isStarted){
				trace("_starling.start()");
				//trace("NativeApplication.nativeApplication.activate()");
				//NativeApplication.nativeApplication.activate();
				//_starling.dispatchEventWith(starling.events.Event.CONTEXT3D_CREATE);
				_starling.start();
			}
		}
		
		private static function initConfig():void{

			assetManager = new AssetManager();
			//assetManager = new AssetManager(1,true);
			
			var i:int, j:int, n:int, obj:Object, text:String, k:String, v:Object;
						
			if(_xml.useBitmapFont=="false"){
				FeathersControl.defaultTextRendererFactory=function()
				{
					return new TextFieldTextRenderer();
				};
			}
						
						
			if(_xml.storeDir=="storage")
				storeDir = File.applicationStorageDirectory;
			else if(_xml.storeDir=="cache")
				storeDir = File.cacheDirectory;
			else if(_xml.storeDir=="documents")
				storeDir = File.documentsDirectory;
						
			var file:File = storeDir.resolvePath("resource/");
			if(!file.exists){
				file.createDirectory();
				file.preventBackup = true;
			}
			var file2:File = storeDir.resolvePath("record/");
			if(!file2.exists){
				file2.createDirectory();
				file2.preventBackup = true;
			}
			
			for(i=0, n=_xml.db.item.length(); i<n; i++)
			{
				db = _xml.db.item[i].@url;
				var isDbExist:Boolean = storeDir.resolvePath(db).exists;
				if (!isDbExist)
				{
					var dataSrc:File = File.applicationDirectory.resolvePath(db);
					var dataDes:File = storeDir.resolvePath(db);
					dataSrc.copyTo(dataDes, true);
				}				
			}			
			
			_atlases = new Vector.<Object>;
			
			for(i=0, n=_xml.atlas.item.length(); i<n; i++)
			{
				assetManager.enqueue(File.applicationDirectory.resolvePath(_xml.atlas.item[i].@xmlUrl));
				assetManager.enqueue(File.applicationDirectory.resolvePath(_xml.atlas.item[i].@imgUrl));
			}
			
			fonts = new Dictionary;
			for(i=0, n=_xml.font.item.length(); i<n; i++){
				k = _xml.font.item[i].@type;
				v = _xml.font.item[i].@name;
				fonts[k] = v;
			}
			
			sizes = new Dictionary;
			for(i=0, n=_xml.size.item.length(); i<n; i++){
				k = _xml.size.item[i].@name;
				v = _xml.size.item[i].@value;
				sizes[k] = v;
			}
			
			colors = new Dictionary;
			for(i=0, n=_xml.color.item.length(); i<n; i++){
				k = _xml.color.item[i].@name;
				v = _xml.color.item[i].@value;
				colors[k] = uint(v);
			}
			
			text = _xml.style;
			style = new StyleSheet();
			style.parseCSS(text);
			if(isIOS){
				style.setStyle(".font", {fontFamily:fonts["iOS"]});
			}else if(isAndroid){
				style.setStyle(".font", {fontFamily:fonts["Android"]});
			}else if(isAir){
				style.setStyle(".font", {fontFamily:""});
			}
			
			if(assetManager.numQueuedAssets>0){
				assetManager.loadQueue(function(ratio:Number):void
				{
					trace("Loading assets, progress:", ratio);
					
					// -> When the ratio equals '1', we are finished.
					if (ratio == 1.0){
						
						setNavigator();
						
						Messager.getInstance().dispatchEvent(new FrameworkEvent(FrameworkEvent.INIT_COMPLETE));
						
					}
				});
			}
			else
			{
				Messager.getInstance().dispatchEvent(new FrameworkEvent(FrameworkEvent.INIT_COMPLETE));
			}
			
		}
				
		private static function setNavigator():void{
			_navigator = _starling.root as ScreenNavigator;
			_navigator.addEventListener(FeathersEventType.TRANSITION_COMPLETE, onTransitionComplete);			
		}
		
		/**
		 * 显示运行状态
		 * @return void
		 * */
		public static function showState():void{
			_starling.showStatsAt("right", "bottom");
		}
		
		/**跳转页面
		 * @param	$targetId	要跳转到的页面
		 * @param	$data	页面所需的数据，默认为null
		 * @return	void
		 * */
		public static function showScreen($targetId:String, $data:Object=null):void{
			
			currentId = $targetId;
			
			_viewData = $data;
			
			_navigator.showScreen(currentId);
			
			trace("_viewIds:", _viewIds);
			
			if(_viewIds.length>0){
				previousId = _viewIds[_viewIds.length-1];
			}
			
			if(_viewIds.length>2)
			{
				earlyId = _viewIds[_viewIds.length-3];
			}
			
			if(_viewIds.indexOf(currentId)!=-1)
			{
				var idx:int = _viewIds.indexOf(currentId);
				_viewIds.splice(idx, 1);
			}
			_viewIds.push(currentId);
		}
		
		private static function onTransitionComplete($e:starling.events.Event):void{
			
			trace("currentId:"+currentId, "previousId:"+previousId);
			
			var targetItem:ScreenNavigatorItem = _navigator.getScreen(currentId);
			var targetScreen:ViewBase = targetItem.screen as ViewBase;
			targetScreen.update(_viewData);
			
			if(previousId){
				var currentItem:ScreenNavigatorItem = _navigator.getScreen(previousId);
				var currentScreen:ViewBase = currentItem.screen as ViewBase;
				currentScreen.clean();
			}
			
		}
		
		private static function onDoubleClick($e:MouseEvent):void{
			clear();
		}
				
		/**
		 * 输出调试信息
		 * @param	$str	要输出的信息
		 * @param	$isHtml	是否支持HTML
		 * @return	void
		 * */
		public static function debug($str:String, $isHtml:Boolean=true):void
		{
			if(_isDebug){
				
				if($isHtml)
				{
					_debugTxt.htmlText += $str + "<br/>";
				}
				else
				{
					_debugTxt.text += $str + "\n";
				}
				
			}
		}
		
		/**清除调试信息*/
		public static function clear():void
		{
			if(_isDebug)
			_debugTxt.text="";
		}
		
	}
}