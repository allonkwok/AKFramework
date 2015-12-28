package com.allonkwok.air.framework.model
{
	import flash.utils.ByteArray;

	/**实体基类*/
	public class EntityBase implements IEntity
	{
		/**构造函数*/
		public function EntityBase()
		{
		}
		
		/**将实体转换为Object
		 * @return	Object
		 * */
		public function toObject():Object{
			
			var bytes:ByteArray = new ByteArray;
			bytes.writeObject(this);
			bytes.position=0;
			return bytes.readObject();
			
		}
	}
}