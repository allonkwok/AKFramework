package com.allonkwok.air.framework.controller
{
	import com.allonkwok.air.framework.event.Messager;
	import com.allonkwok.air.framework.model.ModelBase;

	/**
	 * Controller基类
	 * */
	public class ControllerBase implements IController
	{
		/**model（数据模型）*/
		public var model;
		
		/**messager（信使）*/
		public var messager:Messager;
		
		/**
		 * 构造函数
		 * @param	$model	数据模型
		 * */
		public function ControllerBase($model:ModelBase)
		{
			model = $model;
			messager = Messager.getInstance();
		}
		
		/**
		 * 销毁
		 * */
		public function dispose():void
		{
		}
	}
}