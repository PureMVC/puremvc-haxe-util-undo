/*
 PureMVC haXe Utility - Undo Port by Zjnue Brzavi <zjnue.brzavi@puremvc.org>
 Copyright (c) 2008 Dragos Dascalita <dragos.dascalita@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.haxe.utilities.undo.controller;

import org.puremvc.haxe.interfaces.ICommand;
import org.puremvc.haxe.interfaces.INotification;
import org.puremvc.haxe.interfaces.INotifier;
import org.puremvc.haxe.utilities.undo.interfaces.IUndoableCommand;
import org.puremvc.haxe.utilities.undo.model.CommandsHistoryProxy;
import org.puremvc.haxe.utilities.undo.enums.UndoableCommandTypeEnum;

/**
 * UndoableMacroCommandBase gives you the posibility to create
 * a chain of simple commands instead of a single command.
 */
class UndoableMacroCommandBase extends UndoableCommandBase, implements INotifier, implements ICommand, implements IUndoableCommand
{
	private var subCommands: List<Class<ICommand>>;

	public function new() : Void
	{
		super();
		subCommands = new List();
		initializeMacroCommand();
	}
		
	/**
	 * Method to be overriden in the superclass 
	 */
	private function initializeMacroCommand() : Void
	{
		trace("'initializeMacroCommand' not implemented");
	}
		
	/**
	 * Adds a subcommand to the chain of the commands 
	 */
	private function addSubCommand( commandClassRef : Class<ICommand> ) : Void
	{
		subCommands.add( commandClassRef );
	}
		
	override public function execute( note : INotification ) : Void
	{
		setNote( note );
		
		executeCommand();
		
		if( note.getType() == UndoableCommandTypeEnum.RECORDABLE_COMMAND )
		{
			var historyProxy = cast( facade.retrieveProxy( CommandsHistoryProxy.NAME ), CommandsHistoryProxy );
			historyProxy.putCommand( this );
		}
	}

	override public function executeCommand() : Void
	{
		// don't record the sub commands
		var noteType : String = getNote().getType();
		
		// DO NOT RECORD THE SUBCOMMANDS INTO THE HISTORY
		getNote().setType( UndoableCommandTypeEnum.NON_RECORDABLE_COMMAND );
		
		for( subCommand in subCommands )	
		{
			var commandClassRef : Class<ICommand> = subCommand;
			var commandInstance : ICommand = Type.createInstance( commandClassRef, [] );
			commandInstance.execute( getNote() );
		}
		
		// SET BACK THE ORIGINAL TYPE OF THE NOTE
		getNote().setType( noteType );
	}
	
}
