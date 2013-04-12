/*
 PureMVC haXe Utility - Undo Port by Zjnue Brzavi <zjnue.brzavi@puremvc.org>
 Copyright (c) 2008 Dragos Dascalita <dragos.dascalita@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.haxe.utilities.undo.interfaces;

import org.puremvc.haxe.interfaces.ICommand;
import org.puremvc.haxe.interfaces.INotification;
import org.puremvc.haxe.interfaces.INotifier;

#if haxe3
interface IUndoableCommand extends ICommand extends INotifier
#else
interface IUndoableCommand implements ICommand, implements INotifier
#end
{
	function getNote() : INotification;
	function undo() : Void;
	function redo() : Void;
	function executeCommand() : Void;
}
