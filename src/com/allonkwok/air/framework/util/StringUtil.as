// StringUtil.as
// Tuesday, October 8, 2008
// Copyright © 2007, 2008, 8DWorld, Inc. All rights reserved
package com.allonkwok.air.framework.util
{
	/**
	 * 文本工具类，静态类
	 * */
	public class StringUtil 
	{
		/**
		 * 构造函数，被执行后将抛出错误
		 * */
		public function StringUtil()
		{
			throw new Error("StringUtil是静态类，不能实例化！");
		}
		
		/**
		 * 裁剪文本前后的空格，包括tab及换行
		 * @param	str	要裁剪的文本
		 * @param	char	被裁剪的字符
		 * @return	String
		 * */
		static public function trim(str:String, char:String = ' '):String
		{
			var rex:RegExp = /(\t|\n|\r)/gi;
			return trimBack(trimFront(str, char), char).replace(rex,'');
		}
		
		/**
		 * 裁剪文本前面的空格
		 * @param	str	要裁剪的文本
		 * @param	char	被裁剪的字符
		 * @return	String
		 * */
		static public function trimFront(str:String, char:String):String 
		{
			char = stringToCharacter(char);
			if (str.charAt(0) == char) 
			{
				str = trimFront(str.substring(1), char);
			}
			return str;
		}
		
		/**
		 * 裁剪文本后面的空格
		 * @param	str	要裁剪的文本
		 * @param	char	被裁剪的字符
		 * @return	String
		 * */
		static public function trimBack(str:String, char:String):String 
		{
			char = stringToCharacter(char);
			if (str.charAt(str.length - 1) == char) 
			{
				str = trimBack(str.substring(0, str.length - 1), char);
			}
			return str;
		}
		
		/**
		 * 清除文本中的所有空格
		 * @param	str	文本
		 * @return	String
		 * */
		static public function removeSpace(str:String):String
		{
			var ret:String = "";
			var len:int = str.length;
			for (var i:int = 0; i<len; i++)
			{
				var char:String = str.charAt(i);
				if (char != " ")
				{
					ret += char;
				}
			}
			return ret;
		}
		
		/**
		 * 将文本转化为字符
		 * @param	str	文本
		 * @return	String
		 * */
		static public function stringToCharacter(str:String):String 
		{
			if (str.length == 1) {
				return str;
			}
			return str.slice(0, 1);
		}
		
		static private function getParameter(format:String,para:*):String
		{
			format = format.toLocaleLowerCase () ;
			if(format=="%s")
			{
				return para.toString() ;
			}
			else if(format=="%d")
			{
				return String(int(para)) ;
			}
			return "" ;
		}
		
		static private function formatStrByPara(string:String,paras:Array):String
		{
			var char:String = "" ;
			var formatString:String="" ;
			var bFindFlagString:Boolean = false ;
			var newString:String = "" ;
			var paraIndex:int = 0 ;
			for(var i:int=0;i<string.length;i++)
			{
				char = string.charAt(i) ;
				
				if(!bFindFlagString&&char=="%")
				{
					formatString = char ;
					bFindFlagString = true ;
				}
				else if(bFindFlagString)
				{
					formatString+=char ;
					newString+=getParameter(formatString,paras[paraIndex]) ;
					paraIndex++ ;
					bFindFlagString = false ;
				}
				else
				{
					newString+=char ;
				}
			}
			return newString ;
		}
		
		/**
		 * 格式化文本
		 * @param	str	文本
		 * @param	para	格式类型，可变参数
		 * @return	String
		 * */
		static public function formatStr(string:String,...para):String
		{
			var paraAry:Array = para ;
			return formatStrByPara(string,paraAry) ;
		}
		
		/**
		 * 格式化文本
		 * @param	str	文本
		 * @param	args	格式类型，可变参数
		 * @return	String
		 * */
		static public function format(str:String, ...args):String{
			for(var i:int = 0; i<args.length; i++){
				str = str.replace(new RegExp("\\{" + i + "\\}", "gm"), args[i]);
			}
			return str;
		}
		
		/**
		 * 日期数字转化为1st,2nd,3rd,4th等
		 * @param	n	日期
		 * @return	String
		 * */
		static public function toSequence(n:int):String{
			var str:String = "";
			switch(n){
				case 1:{
					str = "st"
					break;
				}
				case 2:{
					str = "nd";
					break;
				}
				case 3:{
					str = "rd";
					break;
				}
				default:{
					str = "th";
					break;
				}
			}
			return n+str;
		}
		
		/**
		 * 在数字前添加0，以保持位数一致，入将1变为001
		 * @param	v	要转化的数字
		 * @param	len	位数
		 * @return	String
		 * */
		static public function leadingZero(v:int, len:int):String
		{
			if (v < 0 || String(v).length >= len)
				return String(v);
			var tail:String = String(v);	
			var nZeros:int = len - tail.length;
			var head:String = "";
			for (var i:int=0; i<nZeros; i++)
				head += "0";
			return head + tail;
		}
		
		/**字符串过滤
		 * @param	s	要过滤的字符串
		 * @return	String
		 * */
		static public function filter(s:String):String
		{
			var tmp:String = s;
			while(tmp.match(/[\.\,\?\!\;:\"\(\)]/))
				tmp = tmp.replace(/[\.\,\?\!\;:\"\(\)]/g, " ");
			tmp = tmp.replace(/(\S)\s+(\S)/g, "$1 $2");
			return StringUtil.trim(tmp);
		}
		
		/**
		 * 词语或句子的编辑距离(两个字串之间，由一个转成另一个所需的最少编辑操作次数)
		 * @param	source	源词的集合
		 * @param	target	目标词的集合
		 * @return	Array
		 * */
		public static function LevenshteinDistance(source:Array, target:Array):Array 
		{
			var states:Array = new Array();			
			var i:int;
			var j:int;
			
			// Step 1
			// 1. Return easy cases
			// 2. Setup the matrix
			var n:int = source.length;
			var m:int = target.length;
			if (n == 0) 
			{
				return states;
			}
			if (m == 0) 
			{
				for (i=0; i<n; i++)
					states[n] = 1;
				return states;
			}
			
			for (i=0; i<n; i++)
				states[i] = 0;
			
			
			// Step 2
			// Set the initial value on the boundary of the matrix
			var matrix:Array = new Array;  //int[n+1, m+1];
			for (i=0; i<=n; i++)
			{
				matrix[i] = new Array;
				matrix[i][0] = i;
				if (i == 0)
				{
					for (j=0; j<=m; j++)
						matrix[i][j] = j;
				}
			}
			
			// Step 3
			
			for (i = 1; i <= n; i++) 
			{
				
				var s_i:String = source[i-1];
				
				// Step 4
				
				for (j = 1; j <= m; j++) 
				{
					
					var t_j:String = target[j-1];
					
					// Step 5
					
					var cost:int;
					if (s_i.toUpperCase() == t_j.toUpperCase()) 
					{
						cost = 0;
					}
					else 
					{
						cost = 1;
					}
					
					// Step 6
					
					var above:int = matrix[i-1][j];
					var left:int  = matrix[i][j-1];
					var diag:int  = matrix[i-1][j-1];
					var cell:int  = min( above + 1, min(left + 1, diag + cost));
					
					// Step 6A: Cover transposition, in addition to deletion,
					// insertion and substitution. This step is taken from:
					// Berghel, Hal ; Roach, David : "An Extension of Ukkonen's 
					// Enhanced Dynamic Programming ASM Algorithm"
					// (http://www.acm.org/~hlb/publications/asm/asm.html)
					
					if (i>2 && j>2) 
					{
						var trans:int = matrix[i-2][j-2] + 1;
						if ((source[i-2] as String).toUpperCase() != t_j.toUpperCase()) 
							trans++;
						
						if (s_i.toUpperCase() != (target[j-2] as String).toUpperCase()) 
							trans++;
						
						if (cell>trans) 
							cell=trans;
					}
					
					matrix[i][j] = cell;
				}
			}
			
			// Step 7 back trace
			i=n;
			j=m;
			
			var SUB:int = 0;
			var DEL:int = 1;
			var INS:int = 2;
			
			var choice:int = SUB;
			while(i>0 && j>0)
			{
				var mdist:int = min(matrix[i - 1][j], min(matrix[i][j - 1], matrix[i - 1][j - 1]));
				
				if (mdist == matrix[i-1][j-1])
				{
					choice = SUB;
					if (i>=2 && j>=2 && matrix[i-1][j-1] != matrix[i-2][j-2])
					{
						if (matrix[i-1][j-1] == matrix[i][j-1] && matrix[i-1][j-2] == matrix[i][j-1])
							choice = INS;
						else if (matrix[i-1][j-1] == matrix[i-1][j] && matrix[i-2][j-1] == matrix[i-1][j])
							choice = DEL;
					}
				}
				else if (mdist == matrix[i-1][j])
				{
					choice = DEL;
					if (j>=2 && matrix[i-1][j] == matrix[i][j-1] && matrix[i-1][j-2] == matrix[i][j-1])
						choice = INS;
				}
				else
					choice = INS;
				
				switch (choice) 
				{
					case SUB: 
						if (mdist != matrix[i][j])
						{
							states[i-1] = 1;    // wrong, cost = 1
						}
						else
						{
							states[i-1] = 0;
						}
						i--;
						j--;
						break;
					case DEL:
						states[i-1] = 1;
						i--;
						break;
					case INS:
						j--;
						break;
				}
			}
			if (i!=0)
			{
				states[i-1] = 1;
				i--;
			}
			
			return states;
		}
		
		/**
		 * 比较两个数字，取最小那个
		 * @param	a	数字
		 * @param	b	数字
		 * @return	int
		 * */
		public static function min(a:int, b:int):int
		{
			return (a <= b ? a : b);
		}
	}
}