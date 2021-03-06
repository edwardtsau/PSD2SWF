package game.core.resource
{
	/**
	 *@author Kramer(QQ:21524742)
	 */	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import game.core.pool.ObjectPoolManager;
	import game.core.resource.constant.ResourcePriority;
	import game.core.resource.events.ResourceEvent;
	import game.core.resource.item.BinaryItem;
	import game.core.resource.item.ILoadable;
	import game.core.resource.item.ImageItem;
	import game.core.resource.item.LinkageItem;
	import game.core.resource.item.SoundItem;
	import game.core.resource.item.SwfItem;
	import game.core.resource.item.XmlItem;
	

	public class ResourceManager
	{
		private static var _objectPoolManager:ObjectPoolManager;
		
		public function ResourceManager(blocker:Blocker)
		{
		}
		
		initialize();
		
		private static function initialize():void
		{
			_objectPoolManager = ObjectPoolManager.getInstance();
		}
		
		public static function loadXml(url:String, 
									   completeHandler:Function,
									   priority:int = ResourcePriority.LOW,
									   errHandler:Function = null, 
									   startHandler:Function = null, 
									   progressHandler:Function = null):void 
		{
			var xmlItem:XmlItem = _objectPoolManager.getObject(XmlItem) as XmlItem;
			addItemToLoadingQueue(xmlItem, url, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		public static function loadSwf(url:String, 
									   completeHandler:Function, 
									   priority:int = ResourcePriority.LOW,
									   errHandler:Function = null, 
									   startHandler:Function = null, 
									   progressHandler:Function = null,
									   applicationDomain:ApplicationDomain = null):void
		{
			var loaderContext:LoaderContext = new LoaderContext(false, applicationDomain);
			var swfItem:SwfItem = _objectPoolManager.getObject(SwfItem) as SwfItem;
			swfItem.loaderContext = loaderContext;
			addItemToLoadingQueue(swfItem, url, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		public static function loadLinkage(url:String, 
										   completeHandler:Function, 
										   priority:int = ResourcePriority.LOW,
										   errHandler:Function = null, 
										   startHandler:Function = null, 
										   progressHandler:Function = null):void
		{
			var linkageItem:LinkageItem = _objectPoolManager.getObject(LinkageItem) as LinkageItem;
			addItemToLoadingQueue(linkageItem, url, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		public static function loadImage(url:String, 
										 completeHandler:Function, 
										 priority:int = ResourcePriority.LOW,
										 errHandler:Function = null, 
										 startHandler:Function = null, 
										 progressHandler:Function = null):void
		{
			var imageItem:ImageItem = _objectPoolManager.getObject(ImageItem) as ImageItem;
			addItemToLoadingQueue(imageItem, url, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		public static function loadBinary(url:String, 
										  completeHandler:Function, 
										  priority:int = ResourcePriority.LOW,
										  errHandler:Function = null, 
										  startHandler:Function = null, 
										  progressHandler:Function = null):void
		{
			var binaryItem:BinaryItem = _objectPoolManager.getObject(BinaryItem) as BinaryItem;
			addItemToLoadingQueue(binaryItem, url, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		private static function addItemToLoadingQueue(item:ILoadable,
													  url:String,
													  completeHandler:Function, 
													  errHandler:Function = null, 
													  startHandler:Function = null, 
													  progressHandler:Function = null,
													  priority:int = ResourcePriority.LOW):void
		{
			item.url = url;
			item.startHandler = startHandler;
			item.progressHandler = progressHandler;
			item.completeHandler = completeHandler;
			item.errorHandler = errHandler;
			item.priority = priority;
			LoadingManager.addItem(item);
		}
		
		public static function loadSound(url:String, 
										 completeHandler:Function, 
										 priority:int = ResourcePriority.LOW,
										 errHandler:Function = null, 
										 startHandler:Function = null, 
										 progressHandler:Function = null):Sound
		{
			var soundItem:SoundItem = new SoundItem();
			addItemToLoadingQueue(soundItem, url, completeHandler, startHandler, progressHandler, errHandler, priority);
			return soundItem.content() as Sound;
		}
		
		public static function cancel(url:String, completeHandler:Function):void
		{
			LoadingManager.cancel(url, completeHandler);
		}
		
		public static function cancelAll():void
		{
			LoadingManager.cancelAll();
		}
	}
}

class Blocker{}