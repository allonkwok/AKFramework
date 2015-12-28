package com.allonkwok.air.framework.data
{
	import com.allonkwok.air.framework.model.IEntity;
	import com.allonkwok.air.framework.util.ObjectPool;
	
	/**数据基类*/
	public class DataBase implements IData
	{
		/**数据操作对象*/
		public var dataAccess:DataAccess;
		
		/**
		 * 构造函数
		 * */
		public function DataBase()
		{
			dataAccess = ObjectPool.getObject(DataAccess);
		}
		
		/**添加
		 * @param	$entity	实体
		 * @return	int
		 * */
		public function add($entity:IEntity):int{
			return 0;
		}
		
		/**更新
		 * @param	$entity	实体
		 * @return	int
		 * */
		public function update($entity:IEntity):int{
			return 0;
		}
		
		/**
		 * 删除
		 * @param	@id	编号
		 * @return	int
		 */
		public function del($id:int):int{
			return 0;
		}
		
		/**
		 * 获取单个数据实体对象
		 * @param	...$args	自定义参数
		 * @return	Object
		 * */
		public function getSingle(...$args):Object{
			return {};
		}
		
		/**
		 * 获取数据实体对象列表
		 * @param	...$args	自定义参数
		 * @return	Array
		 * */
		public function getList(...$args):Array{
			return [];
		}
		
		/**
		 * 销毁
		 * */
		public function dispose():void{
			dataAccess = null;
		}
		
	}
}