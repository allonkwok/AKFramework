package com.allonkwok.air.framework.util
{
	import com.allonkwok.air.framework.Framework;
	
	import flash.geom.Rectangle;
	
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.textures.Texture;

	/**
	 * 材质工具类
	 * */
	public class TextureUtil
	{
		/**
		 * 获取色块
		 * @param	$width	宽
		 * @param	$height	高
		 * @param	$color	颜色
		 * @return	Quad
		 * */
		public static function getQuad($width:Number, $height:Number, $color:uint):Quad{
			return new Quad($width, $height, $color);
		}
		
		/**
		 * 根据材质名称获取材质
		 * @param $atlas	材质集
		 * @param $name 材质名称
		 * @return Texture
		 */
		public static function getTexture($name:String):Texture{
			return Framework.assetManager.getTexture($name);
		}
		
		/**
		 * 根据材质名称获取图像
		 * @param $atlas	材质集
		 * @param $name 材质名称
		 * @return Image
		 */
		public static function getImage($name:String):Image
		{
			return new Image(getTexture($name));
		}
		
		/**
		 * 根据材质名称获取3宫格图像
		 * @param $atlas	材质集
		 * @param $name 材质名称
		 * @param $region1 1宫长度
		 * @param $region2 2宫长度
		 * @param $direction 横竖方向
		 * @return Scale3Image
		 */
		public static function getScale3Image($name:String, $region1:Number, $region2:Number, $direction:String):Scale3Image
		{
			return new Scale3Image(new Scale3Textures(getTexture($name), $region1, $region2, $direction));
		}
		
		/**
		 * 根据材质名称获取9宫格图像
		 * @param $atlas	材质集
		 * @param $name 材质名称
		 * @param $rect 宫格区域
		 * @return Scale9Image
		 */
		public static function getScale9Image($name:String, $rect:Rectangle):Scale9Image
		{
			return new Scale9Image(new Scale9Textures(getTexture($name), $rect));
		}
		
		/**
		 * 获取包含边框的方形色块
		 * @param	$width	宽
		 * @param	$height	高
		 * @param	$color	色块颜色
		 * @param	$borderColor	边框颜色
		 * @param	$thickness	边框粗细
		 * @param	$hasLeft	是否有左边框
		 * @param	$hasTop	是否有订边框
		 * @param	$hasRight	是否有右边框
		 * @param	$hasBottom	是否有底边框
		 * @return	QuadBatch
		 * */
		public static function getRectangleWithBorder($width:int, $height:int, $color:int=0xFFFFFF, $borderColor:int=0x000000, $thickness:int=1, $hasLeft:Boolean=true, $hasTop:Boolean=true, $hasRight:Boolean=true, $hasBottom:Boolean=true):QuadBatch {
			var result : QuadBatch = new QuadBatch();
			
			var center : Quad = new Quad($width, $height, $color);
			
			if($hasLeft)
				var left : Quad = new Quad($thickness, $height, $borderColor);
			
			if($hasRight)
				var right : Quad = new Quad($thickness, $height, $borderColor);
			
			if($hasTop)
				var top : Quad = new Quad($width, $thickness, $borderColor);
			
			if($hasBottom)
				var down : Quad = new Quad($width, $thickness, $borderColor);
			
			right.x = $width - $thickness;
			down.y = $height - $thickness;
			
			result.addQuad(center);
			
			if($hasLeft)
				result.addQuad(left);
			
			if($hasTop)
				result.addQuad(top);
			
			if($hasRight)
				result.addQuad(right);
			
			if($hasBottom)
				result.addQuad(down);	
			
			return result;
		}
	}
}