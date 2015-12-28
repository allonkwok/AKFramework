package com.allonkwok.air.framework.util
{

	/**
	 * 打印输出对象为文本信息
	 * @param	$obj	对象
	 * */
	public function print($obj:Object):void{
				
		if(typeof($obj)=="object"){
			
			var o = $obj;
			
			for(var k in o){
				
				var v = o[k];
				
				//trace(Framework.symbol + "" + k + " : " + v);
				
				if(typeof(v)=="object")
				{
					//Framework.symbol += "----";
					print(v);
				}
				
			}
			
		}else{
			
			//trace($obj);
			
		}
		
	}
	
}