/*
 PureMVC haXe Utility - Undo Port by Zjnue Brzavi <zjnue.brzavi@puremvc.org>
 Copyright (c) 2008 Dragos Dascalita <dragos.dascalita@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.haxe.multicore.utilities.undo.controller;

import org.puremvc.haxe.multicore.interfaces.ICommand;
import org.puremvc.haxe.multicore.interfaces.INotification;
import org.puremvc.haxe.multicore.patterns.command.SimpleCommand;
import org.puremvc.haxe.multicore.utilities.undo.interfaces.IUndoableCommand;
import org.puremvc.haxe.multicore.utilities.undo.model.CommandsHistoryProxy;
import org.puremvc.haxe.multicore.utilities.undo.enums.UndoableCommandTypeEnum;

/**
 * The base class for any undoable command.
 * Any other classes that needs to be undo/redo enabled must extend it.
 */
#if haxe3
class UndoableCommandBase extends SimpleCommand implements IUndoableCommand
#else
class UndoableCommandBase extends SimpleCommand, implements IUndoableCommand
#end
{
	/**
	 * Holds a reference to note parameter, recieved from the [execute] method. 
	 */
	var _note : INotification;
	var undoCmdClass : Class<ICommand>;
		
	/**
	 * Saves the command into the CommandHistoryProxy class 
	 * ( if [note.getType() == UndoableCommandEnum.RECORDABLE_COMMAND] )
	 * and calls the [executeCommand] method.
	 */
	override public function execute( note : INotification ) : Void
	{
		_note = note;
			
		executeCommand();
		
		if( note.getType() == UndoableCommandTypeEnum.RECORDABLE_COMMAND )
		{
			var historyProxy = cast( facade.retrieveProxy( CommandsHistoryProxy.NAME ), CommandsHistoryProxy );
			historyProxy.putCommand( this );
		}
		
	}
		
	/**
	 * Registers the undo command 
	 */
	public function registerUndoCommand( cmdClass : Class<ICommand> ) : Void
	{
		undoCmdClass = cmdClass;
	} 
		
	/**
	 * Returns the notification sent to this command 
	 */
	public function getNote() : INotification
	{
		return _note;
	}
		
	/**
	 * Sets the value for the nore 
	 */
	public function setNote( value : INotification ) : Void
	{
		_note = value;
	}
		
	/**
	 * This method must be overriden in the super class.
	 * Place here the code for the command to execute. 
	 */
	public function executeCommand() : Void
	{
		throw "The undoable command does not have 'executeCommand' method implemented.";
	}
		
	/**
	 * Calls [executeCommand] 
	 */
	public function redo() : Void
	{
		executeCommand();
	}
	
	/**
	 * Calls the undo command setting its note type to 
	 * [UndoableCommandTypeEnum.NON_RECORDABLE_COMMAND] so that it won't get recorded into the history
	 * since it is already in the history.
	 *
	 * <p>The type of the notification is used as a flag, 
	 * indicating wheather to save the command into the history, or not.
	 * The undo command, should not be recorded into the history, 
	 * and its notification type is set to [UndoableCommandEnum.NON_RECORDABLE_COMMAND]</p> 
	 **/
	public function undo() : Void
	{
		if( undoCmdClass == null )
			throw "Undo command not set. Could not undo. Use 'registerUndoCommand' to register an undo command";
		
		var oldType : String = _note.getType();
		_note.setType( UndoableCommandTypeEnum.NON_RECORDABLE_COMMAND );
		
		try
		{
			var commandInstance : ICommand = Type.createInstance( undoCmdClass, [] );
			commandInstance.initializeNotifier( multitonKey );
			commandInstance.execute( _note );
		}
		catch( e : Dynamic )
		{
			trace( "Undo command failed : " + Std.string(e) );
		}
		
		_note.setType( oldType );
	}
		
	/**
	 * Returns a display name for the undoable command.
	 * 
	 * <p>By default, the name of the command is the name of the notification. // of the class.
	 * You must override this method whenever you want to set a different name.</p>
	 */
	public function getCommandName() : String
	{
		return getNote().getName();
	}
	
}
