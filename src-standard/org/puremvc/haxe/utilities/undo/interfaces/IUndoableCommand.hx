/*
 PureMVC haXe Utility - Undo Port by Zjnue Brzavi <zjnue.brzavi@puremvc.org>
 Copyright (c) 2008 Dragos Dascalita <dragos.dascalita@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.haxe.utilities.undo.interfaces;

import org.puremvc.haxe.interfaces.ICommand;
import org.puremvc.haxe.interfaces.INotification;
import org.puremvc.haxe.interfaces.INotifier;

interface IUndoableCommand implements ICommand, implements INotifier
{
	function getNote() : INotification;
	function undo() : Void;
	function redo() : Void;
	function executeCommand() : Void;
}
