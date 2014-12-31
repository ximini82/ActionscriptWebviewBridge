package net.app.impact.lib.webview
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.LocationChangeEvent;
	import flash.media.StageWebView;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	
	import mx.charts.chartClasses.InstanceCache;

	public class WebViewBridge extends EventDispatcher
	{
		public static const isIPHONE : Boolean = Capabilities.os.indexOf( 'iPhone' ) != -1 ? true : false;
		﻿public static const isANDROID : Boolean = Capabilities.version.indexOf( 'AND' ) != -1 ? true : false;
		﻿public static const isDESKTOP : Boolean = ( !isIPHONE && !isANDROID );
		public static const SENDING_PROTOCOL : String = isIPHONE ?  "about:":"bridge:";
		
		public static const JSREADYEVENT:String = "jsReady";
		
		public var controller:*;
		public var webview:StageWebView;
		private var bridgeReady:Boolean;
		
		public function WebViewBridge(webview:StageWebView, controller:*)
		{
			this.controller = controller;
			this.webview = webview;
			this.webview.addEventListener(LocationChangeEvent.LOCATION_CHANGING,locationChanging);
		}
		
		public function locationChanging(evt:LocationChangeEvent):void
		{
			var currLocation : String = unescape( (evt as LocationChangeEvent).location );
			
			switch( true )
			{
				// javascript calls actionscript
				case currLocation.indexOf( SENDING_PROTOCOL + '[Object]' ) != -1:
					
					parseCallBack( currLocation.split( SENDING_PROTOCOL + '[Object]' )[1] );
				break;
				case currLocation.indexOf( SENDING_PROTOCOL + '[String]' ) != -1:
					
					var arr:Array = evt.location.split("?");
					var vars:URLVariables = new URLVariables(arr[1]);
					
					//if the first JSREADYEVENT is called
					if( !bridgeReady && vars.value == JSREADYEVENT 	)
					{
						bridgeReady = true;
						dispatchEvent( new Event(JSREADYEVENT));
						break;
					}
					
					
					controller[vars.value]();
					
				break;
				case currLocation.indexOf( SENDING_PROTOCOL + '[Raw]' ) != -1:
					var arr:Array = evt.location.split("?");
					var vars:URLVariables = new URLVariables(arr[1]);
					
					if(vars.value)
						
						controller[vars.method](vars.value);
					
					else
						
						controller[vars.method]();
					
				default:
				break;
			}
			evt.preventDefault();
		} 
		
		
		public function call(functionName:String, ... arguments):void
		﻿{
			if(!bridgeReady) throw new Error("Bridge isn't ready. Wait for JSREADYEVENT ");
			
			﻿  ﻿  ﻿ var  _serializeObject:Object  = {};  
			﻿  ﻿  ﻿  _serializeObject['method'] = functionName;
			﻿  ﻿  ﻿  _serializeObject['vars'] = arguments;
			﻿  ﻿  ﻿  _serializeObject['hasVars'] = arguments.length > 0 ;
			﻿  ﻿  ﻿  this.webview.loadURL("javascript:ASB.referedCall	('"+Base64.encodeString( JSON.stringify( _serializeObject ) ) +"')");
		﻿ }
		
		
		public function callRaw(functionName:String, argument:String):void
		﻿{
			if(!bridgeReady) throw new Error("Bridge isn't ready. Wait for JSREADYEVENT ");
			
			﻿  ﻿  ﻿  this.webview.loadURL("javascript:"+functionName+"('"+argument+"')");
		﻿ }
		
		
		internal function parseCallBack( base64String:String ):void
		﻿  ﻿  {
			﻿  ﻿  ﻿  var _serializeObject = JSON.parse( Base64.decode( base64String ).toString() );
			﻿  ﻿  ﻿ // trace( '_serializeObject =>'+_serializeObject['method']);
			﻿  ﻿  ﻿ var _callBackFunction :Function  = controller[ _serializeObject['method'] ];
			﻿  ﻿  ﻿  var returnValue:* = null;
			
			﻿  ﻿  ﻿  if( _serializeObject['vars'].length!=0 )
			﻿  ﻿  ﻿  {
				
						var ar:Array = new Array();
						
							for (var c:String in _serializeObject.vars)
							{
								ar.push(_serializeObject.vars[c]);
							}
						
					
					﻿  ﻿  ﻿returnValue = _callBackFunction.apply(null, ar );
			﻿  ﻿  ﻿  }
			﻿  ﻿  ﻿  else
			﻿  ﻿  ﻿  {
				﻿  ﻿  ﻿  ﻿  returnValue = _callBackFunction();
			﻿  ﻿  ﻿  }
			﻿  ﻿  ﻿  
		﻿  ﻿  }﻿  
		
		
		
		
	
		
		
		
		
	}
}