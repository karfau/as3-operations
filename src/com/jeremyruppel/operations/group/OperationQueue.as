//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2011 AKQA
// 
////////////////////////////////////////////////////////////////////////////////

package com.jeremyruppel.operations.group
{
	import com.jeremyruppel.operations.base.OperationBase;
	import com.jeremyruppel.operations.core.IOperationGroup;
	import com.jeremyruppel.operations.core.IOperation;

	/**
	 * Class.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Jeremy Ruppel
	 * @since  13.01.2011
	 */
	public class OperationQueue extends OperationBase implements IOperationGroup
	{
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 * @constructor
		 */
		public function OperationQueue( skipFailed : Boolean = false )
		{
			this.skipFailed = skipFailed;
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		/**
		 * @private
		 */
		private var operations : Array = new Array( );
		
		/**
		 * @private
		 */
		private var skipFailed : Boolean;
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 * @param operation IOperation
		 * @return IOperationGroup 
		 */
		public function add( operation : IOperation ) : IOperationGroup
		{
			operations.push( operation );
			
			return this;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		/**
		 * @param payload *
		 * @private
		 */
		protected function onOperationSucceeded( payload : * ) : void
		{
			proceed( );
		}
		
		/**
		 * @param payload *
		 * @private
		 */
		protected function onOperationFailed( payload : * ) : void
		{
			if( skipFailed )
			{
				onOperationSucceeded( payload );
			}
			else
			{
				if( failed.numListeners )
				{
					_failed.dispatch( );
				}
				
				release( );
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function begin( ) : void
		{
			proceed( );
		}
		
		/**
		 * @private
		 */
		protected function proceed( ) : void
		{
			if( operations.length )
			{
				var operation : IOperation = operations.shift( );
				
				operation.succeeded.add( onOperationSucceeded );

				operation.failed.add( onOperationFailed );

				operation.call( );
			}
			else
			{
				if( succeeded.numListeners )
				{
					_succeeded.dispatch( );
				}
			}
		}
	}

}