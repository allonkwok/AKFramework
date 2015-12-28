package com.allonkwok.air.framework.util
{	
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextRenderer;
	
	import starling.display.DisplayObject;

	/**
	 * UI工具箱
	 * */
	public class UiUtil
	{

		/**
		 * 获取TextFormat对象
		 * @param	$font	字体
		 * @param	$size	字号
		 * @param	$color	字体颜色
		 * @param	$bold	是否粗体
		 * @param	$italic	是否斜体
		 * @param	$align	对其方式，默认left
		 * @return	TextFormat
		 * */
		public static function getTextFormat($font:String, $size:int, $color:uint=0x000000, $bold:Boolean=false, $italic:Boolean=false, $align="left"):TextFormat{
			var format:TextFormat = new TextFormat;
			if($font && $font!="")
				format.font = $font;
			if($size>0)
				format.size = $size;
			
			format.color = $color;
			format.bold = $bold;
			format.italic = $italic;
			format.align = $align;
			
			return format;
		}
		
		/**
		 * 获取Button对象
		 * @param	$label	按钮文字
		 * @param	$x	横坐标
		 * @param	$y	纵坐标
		 * @param	$width	宽
		 * @param	$height	高
		 * @param	$defaultSkin	默认皮肤
		 * @param	$downSkin	按下的皮肤
		 * @param	$font	字体
		 * @param	$color	字体颜色
		 * @param	$size	字号
		 * @return	Button
		 * */
		public static function getButton($label:String="", $x=null, $y=null, $width=null, $height=null, $defaultSkin:DisplayObject=null, $downSkin:DisplayObject=null, $font:String="", $color=null, $size=null):Button{
			var btn:Button = new Button;
			if($x) btn.x = $x;
			if($y) btn.y = $y;
			if($width) btn.width = $width;
			if($height) btn.height = $height;
			btn.defaultSkin = $defaultSkin;
			btn.downSkin = $downSkin;
			btn.upSkin = $defaultSkin;
			btn.label = $label;
			btn.defaultLabelProperties.textFormat = getTextFormat($font, $size, $color);
			return btn;
		}
		
		/**
		 * 获取TextFieldTextRenderer对象
		 * @param	$text	文字
		 * @param	$x	横坐标
		 * @param	$y	纵坐标
		 * @param	$width	宽
		 * @param	$height	高
		 * @param	$font	字体
		 * @param	$size	字号
		 * @param	$color	字体颜色
		 * @param	$bold	是否粗体
		 * @param	$italic	是否斜体
		 * @param	$isHtml	是否支持Html
		 * @param	$style	样式表
		 * @param	$align	对其方式，默认left
		 * @return	TextFieldTextRenderer
		 * */
		public static function getTextField($text:String="", $x=null, $y=null, $width=null, $height=null, $font=null, $size=null, $color=null, $bold:Boolean=false, $italic:Boolean=false, $isHtml:Boolean=false, $style:StyleSheet=null, $align:String="left"):TextFieldTextRenderer{
			var txt:TextFieldTextRenderer = new TextFieldTextRenderer;
			txt.text = $text;
			txt.wordWrap = true;
			if($x) txt.x = $x;
			if($y) txt.y = $y;
			if($width) txt.width = $width;
			if($height) txt.height = $height;
			if($isHtml) txt.isHTML = $isHtml;
			if($style)
				txt.styleSheet = $style;
			else
				txt.textFormat = getTextFormat($font, $size, $color, $bold, $italic, $align);
			
			return txt;
		}
		
		/**
		 * 获取输入框
		 * @param	$skin	背景图片
		 * @param	$x		x座标
		 * @param	$y		y坐标
		 * @param	$width	宽
		 * @param	$height	高
		 * @param	$font	字体
		 * @param	$size	字体大小
		 * @param	$color	输入文字颜色
		 * @param	$prompt	提示信息
		 * @param	$maxChars	最大输入字数
		 * @param	$isPassword	是否为密码框
		 * @return TextInput
		 * */
		public static function getTextInput($skin:DisplayObject, $x=null, $y=null, $width=null, $height=null, $font:String=null, $size=null, $color=null, $prompt:String="", $maxChars:int=15, $isPassword:Boolean=false):TextInput{
			var txt:TextInput = new TextInput;
			txt.backgroundSkin = $skin;
			if($x) txt.x = $x;
			if($y) txt.y = $y;
			if($width) txt.width = $width;
			if($height) txt.height = $height;
			txt.prompt = $prompt;
			txt.maxChars = $maxChars;
			txt.promptProperties.textFormat = new TextFormat($font, $size, 0xcccccc);
			txt.textEditorProperties.fontSize = $size;
			if($skin){
				txt.paddingLeft = 25;
				txt.paddingTop = 15;
				txt.paddingBottom= 15;
			}
			txt.displayAsPassword = $isPassword;
			return txt;
		}
		
	}
}