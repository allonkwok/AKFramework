package com.allonkwok.air.framework.util
{
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 数组工具类
	 * */
	public class VectorUtil{
		/**
		 * 删除指定位置的元素
		 * @param i	指定位置的值
		 * @param vector	源数据集
		 * @return Vector
		 * */
		public static function deleteAt(i:uint,vector:Vector):Vector{
			var result:Vector = new Vector;
			result = vector;
			result.splice(i,1);
			return result;
		}

		/**
		 * 删除指定元素
		 * @param element	要删除的元素
		 * @param vector	源数据集
		 * @return Vector
		 * */
		public static function deleteElement(element:Object,vector:Vector):Vector{
			var result:Vector=new Vector;
			for(var i:uint=0;i<vector.length;i++){
				if(vector[i]==element){
					vector.splice(i,1);
				}
			}
			result=vector;
			return result;
		}

		/**
		 * 添加元素到指定位置
		 * @param element	要添加的元素
		 * @param i	指定位置的值
		 * @param vector	源数据集
		 * @return Vector
		 * */
		public static function insertAt(element:Object,i:uint,vector:Vector):Vector{
			var result:Vector=new Vector;
			result=vector;
			result.splice(i,0,element);            
			return result;
		}
		
		/**
		 * 比较两组数据集是否相等
		 * @param vector1	第一组数据集
		 * @param vecotr2	第二组数据集
		 * @return	Boolean
		 * */
		public static function isEqual(vecotr1:Vector, vector2:Vector):Boolean{
			if(vecotr1.length!=vector2.length)return false;
			for(var i:uint=0;i<vecotr1.length;i++){
				if(getQualifiedClassName(vecotr1[i])!=getQualifiedClassName(vector2[i]))return false;
				if(vecotr1[i]!=vector2[i])return false;
			}
			return true;
		}
		
		/**
		 * 克隆数据集
		 * @param vector	源数据集
		 * @return Vector
		 * */
		public static function clone(vector:Vector):Vector{
			return vector.slice();
		}
		
		/**
		 * 在指定范围内生成一组随机数
		 * @param range	数量
		 * @param max	最大值
		 * @return Vector
		 * */
		public static function getRandomVector(range:Number, max:Number):Vector{
			var tempVector:Vector = new Vector;
			while(tempVector.length<range){
				var tempNum:Number = random(max);
				if(!objectIsInList(tempNum,tempVector)){
					tempVector.push(tempNum);
				}
			}
			return tempVector;
		}
		
		/**
		 * 检查元素是否在数据集里
		 * @param o	元素
		 * @param vector	源数据集
		 * @return	Boolean
		 * */
		public static function objectIsInList(o:Object, vector:Vector):Boolean{
			return (vector.indexOf(o)!=-1);
		}
		
		/**
		 * 在指定范围内生成一组序列数
		 * @param min	最小数
		 * @param max	最大数
		 * @return Vector
		 * */
		public static function getSequence(min:int,max:int):Vector{
			var result:Vector = new Vector;
			for (var i:int=min; i<=max; i++) {
				result.push(i);
			}
			return result;
		}
		
		/**
		 * 打算数据集顺序
		 * @param vector 源数据集
		 * @return Vector
		 * */
		public static function shuffle(vector:Vector):Vector{
			var cf:Function = function():int{
				var r:Number = Math.random() - 0.5;
				if(r < 0){
					return -1;
				}else{
					return 1;
				}
			}    
			var result:Vector = VectorUtil.clone(vector);
			result.sort(cf);
			return result;
		}
		
		private static function random(n:Number):Number{
			return Math.random() * n;
		}
	}
}