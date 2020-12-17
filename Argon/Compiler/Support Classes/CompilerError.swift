//
//  CompilerError.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public indirect enum CompilerError:Error,Equatable
    {
    case unknownError
    case invalidCharacter(Swift.Character)
    case invalidSymbolCharacter(Swift.Character)
    case packageNameExpected
    case leftBraceExpected
    case rightBraceExpected
    case leftParExpected
    case rightParExpected
    case leftBrocketExpected
    case rightBrocketExpected
    case leftBracketExpected
    case rightBracketExpected
    case packageLevelKeywordExpected
    case packageDeclarationExpected
    case genericTypeNameExpected
    case gluonExpected
    case classReferenceExpected
    case classNameExpected
    case integerNumberExpected
    case duplicateClassDefinition(String)
    case slotExpected
    case slotNameExpected
    case virtualSlotMustDefineReadBlock(String)
    case newValueNameExpected
    case assignExpected
    case slotRequiresInitialValueOrTypeClass
    case virtualSlotReaderMustReturnValue
    case enumerationNameExpected
    case stopPrefixExpectedOnEnumerationCaseName
    case enumerationCaseNameExpected
    case referenceComponentExpected
    case expressionExpected
    case undefinedValue(String)
    case tagExpectedInTupleDeclaration
    case tagExpectedInClosureWithClause
    case tagExpectedBeforeParameterArgument
    case identifierExpected
    case rightBracketExpectedAfterSubscript
    case variableMustContainExecutable
    case enumerationCaseExpected
    case nameComponentExpected
    case enumerationExpected
    case invalidArrayIndexType
    case commaExpected
    case aliasExpected
    case asExpected
    case aliasNameExpected
    case literalValueExpected
    case dictionaryExpected
    case listExpected
    case setExpected
    case methodNameExpected
    case multiMethodNeedsDefinitionBeforeInstance(String)
    case hashStringExpected
    case withExpected
    case signalParameterNameExpected
    case inductionVariableNameExpected
    case inExpected
    case whileExpectedAtEndOfDoStatement
    case variableNameExpected
    case variableRequiresInitialValueOrTypeClass
    case tagExpectedInParameter
    case typeNameExpected
    case slotKeywordExpected
    case readOnlySlotRequiresInitialValue
    case couldNotLoadSource(String)
    case slotReadOnlyConflictsWithVirtual
    case internalInconsistencyError
    case directoryDoesNotExist(String)
    case resolveElementCountMustBeEven
    case virtualSlotCanNotHaveInitialValue
    case readExpected
    case writeExpected
    case symbolNotFound(String)
    case moduleExpected
    case moduleElementDeclarationExpected
    case keywordExpected
    case notImplemented
    case doubleLeftBraceExpected
    case fromExpected
    case toExpected
    case byExpected
    case colonExpected
    case whileExpected
    case macroTextExpected
    case classLiteralExpected
    case stringLiteralOrVariableExpected
    case dateComponentSeparatorExpected
    case timeComponentSeparatorExpected
    }
