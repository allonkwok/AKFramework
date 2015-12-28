package com.allonkwok.air.framework.data
{
	import com.allonkwok.air.framework.model.IEntity;

	/**数据接口*/
	public interface IData
	{
		/**添加
		 * @param	$entity	实体
		 * @return	int
		 * */
		function add($entity:IEntity):int;
		
		/**更新
		 * @param	$entity	实体
		 * @return	int
		 * */
		function update($entity:IEntity):int;
		
		/**
		 * 删除
		 * @param	@id	编号
		 * @return	int
		 */
		function del($id:int):int;
		
		/**
		 * 获取单个数据实体对象
		 * @param	...$args	自定义参数
		 * @return	Object
		 * */
		function getSingle(...$args):Object;
		
		/**
		 * 获取数据实体对象列表
		 * @param	...$args	自定义参数
		 * @return	Array
		 * */
		function getList(...$args):Array;
	}
}