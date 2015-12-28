package com.allonkwok.air.framework.data
{
	import com.allonkwok.air.framework.Framework;
	import com.allonkwok.air.framework.model.IEntity;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	
	import avmplus.getQualifiedClassName;

	
	/**
	 * 数据操作类
	 * */
	public class DataAccess
	{
		
		/**
		 * 构造函数
		 * */
		public function DataAccess()
		{
		}
		
		/**
		 * 执行SQL语句
		 * @param	$sql	SQL语句
		 * @param	$db	数据库文件地址
		 * @return SQLResult
		 * */
		public function execute($sql:String, $db:File=null):SQLResult{
			var result:SQLResult;
			trace($sql);
			var db:File;
			if($db)
			{
				db = $db;
			}
			else
			{
				db = Framework.storeDir.resolvePath(Framework.db);
			}
			var conn:SQLConnection=new SQLConnection;
			conn.open(db);
			
			var stmt:SQLStatement=new SQLStatement;
			stmt.sqlConnection=conn;
			stmt.text=$sql;
			stmt.execute();
			
			result=stmt.getResult();
			
			conn.close();
			
			return result;
		}
		
		/**
		 * 根据model获取Insert语句
		 * @param	$entity	实体对象
		 * @return	String
		 * */
		public function getInsertSql($entity:IEntity):String
		{
			var table:String = getTableName($entity);
			
			var obj:Object = $entity.toObject();
			
			var sql:String="INSERT INTO " + table + " (";
			for (var k in obj)
			{
				if (obj[k] != null && obj[k] != undefined && obj[k] != -1 && typeof(obj[k])!="function")
				{
					sql+=k + ",";
				}
			}
			sql=sql.substr(0, sql.length - 1);
			sql+=") values (";
			for (var k in obj)
			{
				if (obj[k] != null && obj[k] != undefined && obj[k] != -1 && typeof(obj[k])!="function")
				{
					if (typeof(obj[k]) == "string")
					{
						sql+="\"" + obj[k] + "\",";
					}
					else
					{
						sql+=obj[k] + ",";
					}
				}
			}
			sql=sql.substr(0, sql.length - 1);
			sql+=")";
			return sql;
		}
		
		/**
		 * 根据model获取Update语句，只关联已赋值字段
		 * @param	$entity	实体对象
		 * @return	String
		 * */
		public function getUpdateSql($entity:IEntity):String
		{
			var table:String=getTableName($entity);
			
			var obj:Object = $entity.toObject();
			
			var sql:String="UPDATE " + table + " SET ";
			for (var k in obj)
			{
				if (obj[k] != null && obj[k] != undefined && obj[k] != -1 && typeof(obj[k])!="function")
				{
					if (typeof(obj[k]) == "string")
					{
						sql+=k + "=\"" + obj[k] + "\",";
					}
					else
					{
						sql+=k + "=" + obj[k] + ",";
					}
				}
			}
			sql=sql.substr(0, sql.length - 1);
			return sql;
		}
		
		private static function getTableName($model:IEntity):String
		{
			var modelClassName:String = getQualifiedClassName($model).split("::")[1];
			
			var result:String = "";
			
			var letters:Array = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
			
			var arr:Array = modelClassName.split("");
			
			for(var i:int=0, m:int=arr.length; i<m; i++){
				
				var isUpper:Boolean;
				
				for(var j:int=0, n:int=letters.length; j<n; j++){
					
					if(arr[i]==letters[j]){
						
						isUpper = true;
						var s:String;
						if(i==0){
							s = arr[i].toLowerCase();
						}else{
							s = "_"+arr[i].toLowerCase();
						}
						result = result.concat(s);
						
						break;
						
					}else{
						
						isUpper = false;
						
					}
					
				}
				
				if(!isUpper){
					result = result.concat(arr[i]);
				}
				
			}	
			return result;			
		}
		
	}
}