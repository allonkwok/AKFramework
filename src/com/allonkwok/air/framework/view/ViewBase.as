package com.allonkwok.air.framework.view
{
	import com.allonkwok.air.framework.Framework;
	import com.allonkwok.air.framework.controller.ControllerBase;
	import com.allonkwok.air.framework.event.Messager;
	import com.allonkwok.air.framework.model.ModelBase;
	import com.allonkwok.air.framework.util.TextureUtil;
	
	import flash.text.TextFormat;
	
	import feathers.controls.Header;
	import feathers.controls.Screen;
	
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	
	/**视图基类*/
	public class ViewBase extends Screen implements IView
	{
		/**背景图片*/
		public var bg:Quad;
		/**页头*/
		public var header:Header;
		/**次级页头*/
		public var subHeader:Header;
		/**数据模型*/
		public var model;
		/**控制器*/
		public var controller;
		/**信使*/
		public var messager:Messager;
		
		/**
		 * 构造函数
		 * @param	$model	数据模型
		 * @param	$controller	控制器
		 * */
		public function ViewBase($model:ModelBase, $controller:ControllerBase)
		{
			super();
			
			model = $model;
			controller = $controller;
			
			messager = Messager.getInstance();
			
			this.scaleX = this.scaleY = Framework.scale;
			
			bg = TextureUtil.getQuad(Framework.baseWidth, Framework.enabledHeight/Framework.scale, Framework.colors["background"]);
			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			addChild(bg);
		}
		
		/**
		 * 设置页面头部
		 * @param	$title	标题
		 * @param	$color	颜色
		 * @param	$format	文本格式
		 * @param	$leftItem	左显示元素
		 * @param	$rightItem	右显示元素
		 * @param	$leftCallback	左元素点击事件回调函数
		 * @param	$rightCallback	右元素点击事件回调函数
		 * */
		public function setHeader($title:String="", $color:uint=0x1ABB9B, $format:TextFormat=null, $leftItem:DisplayObject=null, $rightItem:DisplayObject=null, $leftCallback:Function=null, $rightCallback:Function=null):void{
			header = createHeader($title, $color, 88, $format, $leftItem, $rightItem, $leftCallback, $rightCallback);
			if(!header.parent){
				addChild(header);
			}
		}
		
		/**
		 * 次级头部
		 * @param	$title	标题
		 * @param	$color	颜色
		 * @param	$format	文本格式
		 * @param	$leftItem	左边显示元素
		 * @param	$rightItem	右边显示元素
		 * @param	$leftCallback	左元素点击事件回调函数
		 * @param	$rightCallback	右元素点击事件回调函数
		 * */
		public function setSubHeader($title:String="", $color:uint=0x1ABB9B, $format:TextFormat=null, $leftItem:DisplayObject=null, $rightItem:DisplayObject=null, $leftCallback:Function=null, $rightCallback:Function=null):void{
			subHeader = createHeader($title, $color, 44, $format, $leftItem, $rightItem, $leftCallback, $rightCallback);
			if(!subHeader.parent){
				subHeader.y = 88;
				addChild(subHeader);
			}
		}
		
		private function createHeader($title:String="", $color:uint=0x1ABB9B, $height:int=0, $format:TextFormat=null, $leftItem:DisplayObject=null, $rightItem:DisplayObject=null, $leftCallback:Function=null, $rightCallback:Function=null):Header{
			var tmpHeader:Header = new Header;
			tmpHeader.backgroundSkin = TextureUtil.getQuad(Framework.baseWidth, $height, $color);
			tmpHeader.backgroundSkin.blendMode = BlendMode.NONE;
			tmpHeader.backgroundSkin.touchable = false;
			if($title!=""){
				tmpHeader.title = $title;
			}
			if($format)
				tmpHeader.titleProperties.textFormat = $format;
			if($leftItem){
				tmpHeader.leftItems = new <DisplayObject>[$leftItem];
			}
			if($rightItem){
				tmpHeader.rightItems = new <DisplayObject>[$rightItem];
			}
			if($leftItem && $leftCallback){
				$leftItem.addEventListener(Event.TRIGGERED, $leftCallback);
			}
			if($rightItem && $rightCallback){
				$rightItem.addEventListener(Event.TRIGGERED, $rightCallback);
			}
			return tmpHeader;
		}
		
		/**
		 * 更新页面数据
		 * @param	$data	要更新的数据
		 * */
		public function update($data:Object=null):void{
			
		}
		
		/**
		 * 清除页面数据
		 * */
		public function clean():void{
			
		}
		
		/**
		 * 销毁
		 * */
		override public function dispose():void{
			bg.dispose();
			header.dispose();
			subHeader.dispose();
			super.dispose();
		}
	}
}