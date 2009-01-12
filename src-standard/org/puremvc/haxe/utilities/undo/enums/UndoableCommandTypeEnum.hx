/*
 PureMVC haXe Utility - Undo Port by Zjnue Brzavi <zjnue.brzavi@puremvc.org>
 Copyright (c) 2008 Dragos Dascalita <dragos.dascalita@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */

package org.puremvc.haxe.utilities.undo.enums;

/**
 * The possible types of undoable commands:
 * 1. RecordableCommand - will save the command into the commands history
 * 2. NonRecordableCommand - will not save the comand into the history
 * 
 * When building an IUndoableCommand,  set note.type = one of these options
 */
class UndoableCommandTypeEnum
{
	public static inline var RECORDABLE_COMMAND : String = "RecordableCommand";
	public static inline var NON_RECORDABLE_COMMAND : String = "NonRecordableCommand";
}
