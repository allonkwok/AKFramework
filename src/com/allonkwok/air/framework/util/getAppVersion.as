package com.allonkwok.air.framework.util
{
	import flash.desktop.NativeApplication;

	/**
	 * 获取应用版本号
	 * @return	String
	 * */
	public function getAppVersion():String{

		var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
		var ns:Namespace = appXML.namespace();
		var versionNumber:String = appXML.ns::versionNumber;

		return versionNumber;
		
	}
}