/**
*
*  IOS Alert for ios 4
*
**/
var ADBCONST = {
		checker:{
			 iphone: navigator.userAgent.match(/(iPhone|iPod|iPad)/) === null ? false:true,
			 android: navigator.userAgent.match(/Android/) === null ? false: navigator.platform.match(/Linux/) == null ? false:true
			 }

};
var ASB = {
		stage:null
		,
		_isClosing:null
		,
		checker:{
			 iphone: navigator.userAgent.match(/(iPhone|iPod|iPad)/) === null ? false:true,
			 android: navigator.userAgent.match(/Android/) === null ? false: navigator.platform.match(/Linux/) == null ? false:true
			 }
		,  
		sendingProtocol : ADBCONST.checker.iphone ? 'about:':'bridge:'
		,
		READYEVENT : "jsReady"
		,
		dispatchReady : function ()
		{
			this.sendString(this.READYEVENT);
		}
		
		,
		
		console : function (message)
		{
			this.call('console',message);
		}
		,
		
		send : function (obj) {
		     var jsondata = btoa( JSON.stringify( obj )) ; 
		    window.location.href = ( this.sendingProtocol+'[Object]'+jsondata);
		 }
		,
		sendString : function (text) {
			window.location.href = ( 
					this.sendingProtocol+'[String]'+
					"?value=" + encodeURIComponent(text));
		}
		,
		sendraw : function (method, value)
		{
			window.location.href = ( 
					this.sendingProtocol+'[Raw]'+
					"?method=" + (method)+"&value="+value);
		}
		,
		call : function ()
		{
			
			   var meth =  arguments[0];
			   var ar = new Array();
				for(var key = 1; key < arguments.length; key++) {
					
					ar.push ( arguments[key] );
				}
			var obj = {
					method: meth,
					vars : ar
			};
			this.send(obj);
		}
		,
		callObjectVars : function (method, vars)
		{
			var obj = {
					method:method,
					vars : vars
			};
			this.send(obj);
		}
		,
		parse : function (jsonArgs) { 
			var _serializeObject = JSON.parse( atob( jsonArgs ) );
			return _serializeObject;
		}
		,
		referedCall : function (jsonArgs)
		{
			
			var obj = this.parse(jsonArgs);
			$('#list').html(JSON.stringify( obj ) );
			if(obj.hasVars)
			{
				var ar = new Array();
				for(var key in obj.vars) {
					ar.push ( obj.vars[key] );
				}
				targetFunction = window[ obj.method ];
				targetFunction.apply (null,ar);
				//makeArray.apply( gasGuzzler, [ 'one', 'two' ] ); 
			}
			else
			{
				  targetFunction = window[ obj.method ];
				  targetFunction.apply(null);
			}
		}
	
		
	
		
		
		
		
};