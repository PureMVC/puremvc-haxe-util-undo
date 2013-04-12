/*
 PureMVC haXe Utility - Undo Port by Zjnue Brzavi <zjnue.brzavi@puremvc.org>
 Copyright (c) 2008 Dragos Dascalita <dragos.dascalita@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.haxe.utilities.undo.model;
	
import org.puremvc.haxe.interfaces.IProxy;
import org.puremvc.haxe.patterns.proxy.Proxy;
import org.puremvc.haxe.utilities.undo.interfaces.IUndoableCommand;

/**
 * The model that keeps track of the commands.
 * It provides methods to get the next or the previous command from the history.
 *
 * <p>In order to record a command into the history, you must set the type of its notification
 * to [UndoableCommandTypeEnum.RECORDABLE_COMMAND]</p>
 */
#if haxe3
class CommandsHistoryProxy extends Proxy implements IProxy
#else
class CommandsHistoryProxy extends Proxy, implements IProxy
#end
{
	/**
	 * The name of the proxy.
	 */
	public static inline var NAME : String = "CommandsHistoryProxy";
	
	/**
	 * The name of the notification that informs mediator that UNDO button can be enabled
	 */
	public static inline var UNDO_ENABLED : String = "undoEnabled";
	
	/**
	 * Notification name that informs mediators that UNDO button can be disabled, 
	 * since the undo stack is empty
	 */
	public static inline var UNDO_DISABLED : String = "undoDisabled";
	
	/**
	 * Notification name that should inform mediator that REDO button can be enabled
	 */
	public static inline var REDO_ENABLED : String = "redoEnabled";
	
	/**
	 * Notification name to inform mediator that the REDO button should be disabled
	 * since it doesn't have any redo actions in the stack.
	 */
	public static inline var REDO_DISABLED : String = "redoDisabled";
	
	public static inline var COMMAND_HISTORY_UPDATED : String = "commandHistoryUpdated";
	
	public function new( ?data : Dynamic ) : Void
	{
		super( NAME, data );
		undoStack = new Array();
		redoStack = new Array();
	}
	
	public var undoStack : Array<IUndoableCommand>;
	public var redoStack : Array<IUndoableCommand>;
	
	/**
	 * Returns the UNDO command.
	 *
	 * <p>Returns the latest command within the undo commands stack</p>
	 */
	public function getPrevious() : IUndoableCommand
	{
		if( undoStack.length > 0 )
		{
			var cmd = cast( undoStack.pop(), IUndoableCommand );
			redoStack.push( cmd );
			
			sendNotification( REDO_ENABLED );
			if( undoStack.length == 0 )
				sendNotification( UNDO_DISABLED );
				
			return cmd;
		}
		return null;
	}
		
	/**
	 * Indicates if there is an undo command into the history
	 */
	function getCanUndo() : Bool
	{
		return get_canUndo();
	}
	
	function get_canUndo() : Bool
	{
		return undoStack.length > 0;
	}
	
	#if haxe3
	public var canUndo( get, null ) : Bool;
	#else
	public var canUndo( get_canUndo, null ) : Bool;
	#end

	/**
	 * Returns the REDO command 
	 */
	public function getNext() : IUndoableCommand
	{
		if( redoStack.length > 0 )
		{
			var cmd = cast( redoStack.pop(), IUndoableCommand );
			undoStack.push( cmd );
			
			sendNotification( UNDO_ENABLED );
			if( redoStack.length == 0 )
				sendNotification( REDO_DISABLED );
				
			return cmd;
		}
		return null;
	}
		
	/**
	 * Indicates if there is a redo command in the history
	 */
	function getCanRedo() : Bool
	{
		return get_canRedo();
	}
	
	function get_canRedo() : Bool
	{
		return redoStack.length > 0;
	}
	
	#if haxe3
	public var canRedo( get, null ) : Bool;
	#else
	public var canRedo( get_canRedo, null ) : Bool;
	#end
	
	/**
	 * Saves a command into the history.
	 *
	 * <p>UndoableCommandBase calls this method to save its instance into the history, if the 
	 * type of the notification is [UndoableCommandTypeEnum.RECORDABLE_COMMAND]</p>
	 */
	public function putCommand( cmd : IUndoableCommand ) : Void
	{
		redoStack = new Array();
		
		undoStack.push( cmd );
		//send notification to inform listeners that REDO is now disabled
		// usually you can use this to disable the REDO button
		sendNotification( REDO_DISABLED );
		
		// send notification to inform listeners that it is at least one command in the UNDO stack
		//usually you listen to this notification to enable de UNDO button
		sendNotification( UNDO_ENABLED );
		
		//send notification that a new command has been added to history
		sendNotification( COMMAND_HISTORY_UPDATED, cmd ); 
	}
	
}
