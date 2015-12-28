package com.allonkwok.air.framework.util
{
	/**
	 * 时间戳
	 * @return	int
	 * */
	public function getTimestamp():int{
		var date:Date = new Date;
		var time:Number = date.time;
		var t:int = time/1000;		
		return t;
	}
}