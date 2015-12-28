package com.allonkwok.air.framework.view
{
	/**
	 * View接口
	 * */
	public interface IView
	{
		/**清理页面
		 * @return void
		 * */
		function clean():void;
		
		/**
		 * 更新内容
		 * @param	$data	需要更新的数据
		 * @return void
		 * */
		function update($data:Object=null):void;
		
		/**
		 * 销毁页面
		 * @return	void
		 * */
		function dispose():void;
	}
}