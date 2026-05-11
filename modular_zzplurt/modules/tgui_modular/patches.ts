import path from 'node:path';
import { createRequire } from 'node:module';

import type ts from 'typescript';

const require = createRequire(import.meta.url);

export type PatchPosition = 'before' | 'after';

export type AnchorPatchOperation = {
	kind: 'insert';
	anchor: string;
	position: PatchPosition;
	content: string;
	expectedOccurrences?: number;
};

export type ReplacePatchOperation = {
	kind: 'replace';
	anchor: string;
	content: string;
	expectedOccurrences?: number;
};

export type EdgePatchOperation = {
	kind: 'prepend' | 'append';
	content: string;
};

export type AddImportPatchOperation = {
	kind: 'add-import';
	content: string;
};

export type AddTypeMemberPatchOperation = {
	kind: 'add-type-member';
	typeName: string;
	content: string;
};

export type AddArrayItemPatchOperation = {
	kind: 'add-array-item';
	anchor: string;
	content: string;
};

export type AddObjectEntryPatchOperation = {
	kind: 'add-object-entry';
	anchor: string;
	content: string;
};

export type WrapFunctionComponentPatchOperation = {
	kind: 'wrap-function-component';
	exportName: string;
	innerName: string;
	wrapper: string;
};

export type AstAddImportPatchOperation = {
	kind: 'ast-add-import';
	module: string;
	imports: string[];
	typeOnly?: boolean;
};

export type AstAddTypeMemberPatchOperation = {
	kind: 'ast-add-type-member';
	typeName: string;
	content: string;
};

export type AstAddArrayItemPatchOperation = {
	kind: 'ast-add-array-item';
	variableName: string;
	content: string;
};

export type AstAddObjectEntryPatchOperation = {
	kind: 'ast-add-object-entry';
	variableName: string;
	content: string;
};

export type AstWrapFunctionComponentPatchOperation = {
	kind: 'ast-wrap-function-component';
	exportName: string;
	innerName: string;
	wrapper: string;
};

export type AstRemoveImportSpecifierPatchOperation = {
	kind: 'ast-remove-import-specifier';
	module: string;
	imports: string[];
};

export type AstRemoveTypeMemberPatchOperation = {
	kind: 'ast-remove-type-member';
	typeName: string;
	members: string[];
};

export type AstAddEnumMemberPatchOperation = {
	kind: 'ast-add-enum-member';
	enumName: string;
	content: string;
};

export type AstRemoveEnumMemberPatchOperation = {
	kind: 'ast-remove-enum-member';
	enumName: string;
	memberName: string;
};

export type AstAddSwitchCasePatchOperation = {
	kind: 'ast-add-switch-case';
	switchExpression: string;
	afterCase: string;
	content: string;
};

export type AstRemoveSwitchCasePatchOperation = {
	kind: 'ast-remove-switch-case';
	switchExpression: string;
	caseExpression: string;
};

export type AstReplaceVariableInitializerPatchOperation = {
	kind: 'ast-replace-variable-initializer';
	variableName: string;
	content: string;
};

export type ModularTguiPatchOperation =
	| AnchorPatchOperation
	| ReplacePatchOperation
	| EdgePatchOperation
	| AddImportPatchOperation
	| AddTypeMemberPatchOperation
	| AddArrayItemPatchOperation
	| AddObjectEntryPatchOperation
	| WrapFunctionComponentPatchOperation
	| AstAddImportPatchOperation
	| AstAddTypeMemberPatchOperation
	| AstAddArrayItemPatchOperation
	| AstAddObjectEntryPatchOperation
	| AstWrapFunctionComponentPatchOperation
	| AstRemoveImportSpecifierPatchOperation
	| AstRemoveTypeMemberPatchOperation
	| AstAddEnumMemberPatchOperation
	| AstRemoveEnumMemberPatchOperation
	| AstAddSwitchCasePatchOperation
	| AstRemoveSwitchCasePatchOperation
	| AstReplaceVariableInitializerPatchOperation;

export type ModularTguiPatch = {
	/**
	 * Path to the upstream tgui file, relative to the tgui/ directory.
	 */
	target: string;

	/**
	 * Ordered operations to apply to the target source.
	 */
	operations: ModularTguiPatchOperation[];
};

export function applyPatchOperations(
	source: string,
	operations: ModularTguiPatchOperation[],
	target = '(unknown)',
) {
	return operations.reduce(
		(currentSource, operation) => applyPatchOperation(currentSource, operation, target),
		source,
	);
}

function applyPatchOperation(
	source: string,
	operation: ModularTguiPatchOperation,
	target: string,
) {
	switch (operation.kind) {
		case 'insert':
			return insertAtAnchor(
				source,
				operation.anchor,
				operation.content,
				operation.position,
				operation.expectedOccurrences ?? 1,
				target,
			);

		case 'replace':
			return replaceAnchor(
				source,
				operation.anchor,
				operation.content,
				operation.expectedOccurrences ?? 1,
				target,
			);

		case 'prepend':
			return `${ensureTrailingNewline(operation.content)}${source}`;

		case 'append':
			return `${ensureTrailingNewline(source)}${operation.content}`;

		case 'add-import':
			return addImport(source, operation.content);

		case 'add-type-member':
			return addTypeMember(source, operation.typeName, operation.content, target);

		case 'add-array-item':
			return addDelimitedEntry(source, operation.anchor, '[', ']', operation.content, target);

		case 'add-object-entry':
			return addDelimitedEntry(source, operation.anchor, '{', '}', operation.content, target);

		case 'wrap-function-component':
			return wrapFunctionComponent(
				source,
				operation.exportName,
				operation.innerName,
				operation.wrapper,
				target,
			);

		case 'ast-add-import':
			return astAddImport(source, operation, target);

		case 'ast-add-type-member':
			return astAddTypeMember(source, operation.typeName, operation.content, target);

		case 'ast-add-array-item':
			return astAddVariableEntry(
				source,
				operation.variableName,
				operation.content,
				'array',
				target,
			);

		case 'ast-add-object-entry':
			return astAddVariableEntry(
				source,
				operation.variableName,
				operation.content,
				'object',
				target,
			);

		case 'ast-wrap-function-component':
			return astWrapFunctionComponent(
				source,
				operation.exportName,
				operation.innerName,
				operation.wrapper,
				target,
			);

		case 'ast-remove-import-specifier':
			return astRemoveImportSpecifiers(source, operation.module, operation.imports, target);

		case 'ast-remove-type-member':
			return astRemoveTypeMembers(source, operation.typeName, operation.members, target);

		case 'ast-add-enum-member':
			return astAddEnumMember(source, operation.enumName, operation.content, target);

		case 'ast-remove-enum-member':
			return astRemoveEnumMember(source, operation.enumName, operation.memberName, target);

		case 'ast-add-switch-case':
			return astAddSwitchCase(
				source,
				operation.switchExpression,
				operation.afterCase,
				operation.content,
				target,
			);

		case 'ast-remove-switch-case':
			return astRemoveSwitchCase(
				source,
				operation.switchExpression,
				operation.caseExpression,
				target,
			);

		case 'ast-replace-variable-initializer':
			return astReplaceVariableInitializer(
				source,
				operation.variableName,
				operation.content,
				target,
			);
	}
}

function astAddImport(
	source: string,
	operation: AstAddImportPatchOperation,
	target: string,
) {
	const sourceFile = createSourceFile(source, target);
	const existingImport = sourceFile.statements.find((statement): statement is ts.ImportDeclaration => {
		const syntax = getTypeScript();
		return (
			syntax.isImportDeclaration(statement) &&
			!!statement.importClause?.isTypeOnly === !!operation.typeOnly &&
			syntax.isStringLiteral(statement.moduleSpecifier) &&
			statement.moduleSpecifier.text === operation.module
		);
	});

	if (existingImport?.importClause?.namedBindings) {
		const syntax = getTypeScript();
		const namedBindings = existingImport.importClause.namedBindings;

		if (syntax.isNamedImports(namedBindings)) {
			const existingNames = new Set(
				namedBindings.elements.map((element) => element.name.text),
			);
			const newImports = operation.imports.filter((name) => !existingNames.has(name));

			if (newImports.length === 0) {
				return source;
			}

			const closeBrace = source.lastIndexOf('}', namedBindings.end);
			return insertBeforeIndex(source, closeBrace, `  ${newImports.join(', ')},`);
		}
	}

	const importKind = operation.typeOnly ? 'import type' : 'import';
	return addImport(
		source,
		`${importKind} { ${operation.imports.join(', ')} } from '${operation.module}';`,
	);
}

function astRemoveImportSpecifiers(
	source: string,
	moduleName: string,
	imports: string[],
	target: string,
) {
	const syntax = getTypeScript();
	const sourceFile = createSourceFile(source, target);
	const importDeclaration = sourceFile.statements.find((statement): statement is ts.ImportDeclaration => {
		return (
			syntax.isImportDeclaration(statement) &&
			syntax.isStringLiteral(statement.moduleSpecifier) &&
			statement.moduleSpecifier.text === moduleName &&
			!!statement.importClause?.namedBindings &&
			syntax.isNamedImports(statement.importClause.namedBindings)
		);
	});

	if (!importDeclaration?.importClause?.namedBindings) {
		throw new Error(
			`Modular tgui AST patch failed for ${target}: import from '${moduleName}' not found`,
		);
	}

	const namedBindings = importDeclaration.importClause.namedBindings as ts.NamedImports;
	const removalSet = new Set(imports);
	const remainingImports = namedBindings.elements
		.filter((element) => !removalSet.has(element.name.text))
		.map((element) => element.getText(sourceFile));

	if (remainingImports.length === namedBindings.elements.length) {
		throw new Error(
			`Modular tgui AST patch failed for ${target}: none of ${imports.join(', ')} found in '${moduleName}' import`,
		);
	}

	if (remainingImports.length === 0) {
		return removeWholeLineRange(source, importDeclaration.getStart(sourceFile), importDeclaration.end);
	}

	const openBrace = source.indexOf('{', importDeclaration.getStart(sourceFile));
	const closeBrace = source.indexOf('}', openBrace);
	const replacement =
		remainingImports.length === 1
			? `{ ${remainingImports[0]} }`
			: `{\n${remainingImports.map((name) => `\t${name},`).join('\n')}\n}`;

	return `${source.slice(0, openBrace)}${replacement}${source.slice(closeBrace + 1)}`;
}

function astAddTypeMember(
	source: string,
	typeName: string,
	content: string,
	target: string,
) {
	const syntax = getTypeScript();
	const sourceFile = createSourceFile(source, target);
	const declaration = sourceFile.statements.find((statement) => {
		if (syntax.isInterfaceDeclaration(statement)) {
			return statement.name.text === typeName;
		}

		return (
			syntax.isTypeAliasDeclaration(statement) &&
			statement.name.text === typeName &&
			syntax.isTypeLiteralNode(statement.type)
		);
	});

	if (!declaration) {
		throw new Error(`Modular tgui AST patch failed for ${target}: type '${typeName}' not found`);
	}

	const members =
		syntax.isInterfaceDeclaration(declaration) ? declaration.members : declaration.type.members;
	const closeIndex = source.lastIndexOf('}', declaration.end);
	const indent = members.length > 0 ? getLineIndent(source, members[0].getStart(sourceFile)) : 0;

	return insertBeforeClosingLine(source, closeIndex, indentContent(content, indent));
}

function astRemoveTypeMembers(
	source: string,
	typeName: string,
	members: string[],
	target: string,
) {
	const syntax = getTypeScript();
	const sourceFile = createSourceFile(source, target);
	const declaration = sourceFile.statements.find((statement) => {
		if (syntax.isInterfaceDeclaration(statement)) {
			return statement.name.text === typeName;
		}

		return (
			syntax.isTypeAliasDeclaration(statement) &&
			statement.name.text === typeName &&
			syntax.isTypeLiteralNode(statement.type)
		);
	});

	if (!declaration) {
		throw new Error(`Modular tgui AST patch failed for ${target}: type '${typeName}' not found`);
	}

	const typeMembers =
		syntax.isInterfaceDeclaration(declaration) ? declaration.members : declaration.type.members;
	const removalSet = new Set(members);
	const matchingMembers = typeMembers.filter((member) => {
		const name = getPropertyNameText(member.name);
		return name ? removalSet.has(name) : false;
	});

	if (matchingMembers.length !== members.length) {
		throw new Error(
			`Modular tgui AST patch failed for ${target}: expected type member(s) ${members.join(', ')} in '${typeName}'`,
		);
	}

	return removeNodesByLine(source, matchingMembers, sourceFile);
}

function astAddVariableEntry(
	source: string,
	variableName: string,
	content: string,
	expectedInitializer: 'array' | 'object',
	target: string,
) {
	const syntax = getTypeScript();
	const sourceFile = createSourceFile(source, target);
	const declaration = findVariableDeclaration(sourceFile, variableName);

	if (!declaration?.initializer) {
		throw new Error(
			`Modular tgui AST patch failed for ${target}: variable '${variableName}' not found`,
		);
	}

	const initializer = declaration.initializer;
	const initializerMatches =
		expectedInitializer === 'array'
			? syntax.isArrayLiteralExpression(initializer)
			: syntax.isObjectLiteralExpression(initializer);

	if (!initializerMatches) {
		throw new Error(
			`Modular tgui AST patch failed for ${target}: variable '${variableName}' is not an ${expectedInitializer}`,
		);
	}

	const closeDelimiter = expectedInitializer === 'array' ? ']' : '}';
	const closeIndex = source.lastIndexOf(closeDelimiter, initializer.end);
	const elements =
		expectedInitializer === 'array'
			? (initializer as ts.ArrayLiteralExpression).elements
			: (initializer as ts.ObjectLiteralExpression).properties;
	const indent = elements.length > 0 ? getLineIndent(source, elements[0].getStart(sourceFile)) : 0;

	return insertBeforeClosingLine(source, closeIndex, indentContent(content, indent));
}

function astReplaceVariableInitializer(
	source: string,
	variableName: string,
	content: string,
	target: string,
) {
	const sourceFile = createSourceFile(source, target);
	const declaration = findVariableDeclaration(sourceFile, variableName);

	if (!declaration?.initializer) {
		throw new Error(
			`Modular tgui AST patch failed for ${target}: variable '${variableName}' not found`,
		);
	}

	return replaceRange(
		source,
		declaration.initializer.getStart(sourceFile),
		declaration.initializer.end,
		content,
	);
}

function astAddEnumMember(
	source: string,
	enumName: string,
	content: string,
	target: string,
) {
	const syntax = getTypeScript();
	const sourceFile = createSourceFile(source, target);
	const declaration = findEnumDeclaration(sourceFile, enumName);

	if (!declaration) {
		throw new Error(`Modular tgui AST patch failed for ${target}: enum '${enumName}' not found`);
	}

	const closeIndex = source.lastIndexOf('}', declaration.end);
	const indent =
		declaration.members.length > 0
			? getLineIndent(source, declaration.members[0].getStart(sourceFile))
			: getLineIndent(source, closeIndex) + 1;

	return insertBeforeClosingLine(source, closeIndex, indentContent(content, indent));
}

function astRemoveEnumMember(
	source: string,
	enumName: string,
	memberName: string,
	target: string,
) {
	const syntax = getTypeScript();
	const sourceFile = createSourceFile(source, target);
	const declaration = findEnumDeclaration(sourceFile, enumName);

	if (!declaration) {
		throw new Error(`Modular tgui AST patch failed for ${target}: enum '${enumName}' not found`);
	}

	const member = declaration.members.find((enumMember) => enumMember.name.getText(sourceFile) === memberName);

	if (!member) {
		throw new Error(
			`Modular tgui AST patch failed for ${target}: enum member '${memberName}' not found in '${enumName}'`,
		);
	}

	return removeWholeLineRange(source, member.getStart(sourceFile), member.end);
}

function astAddSwitchCase(
	source: string,
	switchExpression: string,
	afterCase: string,
	content: string,
	target: string,
) {
	const sourceFile = createSourceFile(source, target);
	const switchStatement = findSwitchStatement(sourceFile, switchExpression);

	if (!switchStatement) {
		throw new Error(
			`Modular tgui AST patch failed for ${target}: switch '${switchExpression}' not found`,
		);
	}

	const clause = switchStatement.caseBlock.clauses.find((caseClause) => {
		const syntax = getTypeScript();
		return syntax.isCaseClause(caseClause) && caseClause.expression.getText(sourceFile) === afterCase;
	});

	if (!clause) {
		throw new Error(
			`Modular tgui AST patch failed for ${target}: case '${afterCase}' not found in switch '${switchExpression}'`,
		);
	}

	return insertBeforeIndex(source, clause.end, content);
}

function astRemoveSwitchCase(
	source: string,
	switchExpression: string,
	caseExpression: string,
	target: string,
) {
	const sourceFile = createSourceFile(source, target);
	const switchStatement = findSwitchStatement(sourceFile, switchExpression);

	if (!switchStatement) {
		throw new Error(
			`Modular tgui AST patch failed for ${target}: switch '${switchExpression}' not found`,
		);
	}

	const clause = switchStatement.caseBlock.clauses.find((caseClause) => {
		const syntax = getTypeScript();
		return syntax.isCaseClause(caseClause) && caseClause.expression.getText(sourceFile) === caseExpression;
	});

	if (!clause) {
		throw new Error(
			`Modular tgui AST patch failed for ${target}: case '${caseExpression}' not found in switch '${switchExpression}'`,
		);
	}

	return removeWholeLineRange(source, clause.getStart(sourceFile), clause.end);
}

function astWrapFunctionComponent(
	source: string,
	exportName: string,
	innerName: string,
	wrapper: string,
	target: string,
) {
	const sourceFile = createSourceFile(source, target);
	const declaration = sourceFile.statements.find((statement): statement is ts.FunctionDeclaration => {
		const syntax = getTypeScript();
		return syntax.isFunctionDeclaration(statement) && statement.name?.text === exportName;
	});

	if (!declaration?.name) {
		throw new Error(
			`Modular tgui AST patch failed for ${target}: function '${exportName}' not found`,
		);
	}

	const exportModifier = declaration.modifiers?.find((modifier) => {
		const syntax = getTypeScript();
		return modifier.kind === syntax.SyntaxKind.ExportKeyword;
	});
	const exportStart = exportModifier?.getStart(sourceFile);
	const sourceWithoutExport =
		exportStart === undefined
			? source
			: `${source.slice(0, exportStart)}${source.slice(exportModifier.end).replace(/^\s*/, '')}`;
	const nameStart = declaration.name.getStart(sourceFile);
	const nameOffset = exportStart === undefined ? nameStart : nameStart - (declaration.name.getStart(sourceFile) - exportStart);

	const renamedSource = replaceFirstIdentifierAfter(
		sourceWithoutExport,
		exportName,
		innerName,
		exportStart ?? nameOffset,
	);

	return `${ensureTrailingNewline(renamedSource)}${wrapper}`;
}

function findVariableDeclaration(sourceFile: ts.SourceFile, variableName: string) {
	const syntax = getTypeScript();
	let found: ts.VariableDeclaration | undefined;

	function visit(node: ts.Node) {
		if (
			syntax.isVariableDeclaration(node) &&
			syntax.isIdentifier(node.name) &&
			node.name.text === variableName
		) {
			found = node;
			return;
		}

		syntax.forEachChild(node, visit);
	}

	visit(sourceFile);
	return found;
}

function findSwitchStatement(sourceFile: ts.SourceFile, switchExpression: string) {
	const syntax = getTypeScript();
	let found: ts.SwitchStatement | undefined;

	function visit(node: ts.Node) {
		if (
			syntax.isSwitchStatement(node) &&
			node.expression.getText(sourceFile) === switchExpression
		) {
			found = node;
			return;
		}

		syntax.forEachChild(node, visit);
	}

	visit(sourceFile);
	return found;
}

function findEnumDeclaration(sourceFile: ts.SourceFile, enumName: string) {
	const syntax = getTypeScript();
	let found: ts.EnumDeclaration | undefined;

	function visit(node: ts.Node) {
		if (syntax.isEnumDeclaration(node) && node.name.text === enumName) {
			found = node;
			return;
		}

		syntax.forEachChild(node, visit);
	}

	visit(sourceFile);
	return found;
}

function getPropertyNameText(name: ts.PropertyName | undefined) {
	const syntax = getTypeScript();

	if (!name) {
		return undefined;
	}

	if (syntax.isIdentifier(name) || syntax.isStringLiteral(name) || syntax.isNumericLiteral(name)) {
		return name.text;
	}

	return undefined;
}

function createSourceFile(source: string, target: string) {
	const syntax = getTypeScript();
	const scriptKind = target.endsWith('.tsx') ? syntax.ScriptKind.TSX : syntax.ScriptKind.TS;

	return syntax.createSourceFile(target, source, syntax.ScriptTarget.Latest, true, scriptKind);
}

function replaceFirstIdentifierAfter(
	source: string,
	oldName: string,
	newName: string,
	startIndex: number,
) {
	const index = source.indexOf(oldName, Math.max(0, startIndex));

	if (index === -1) {
		return source;
	}

	return `${source.slice(0, index)}${newName}${source.slice(index + oldName.length)}`;
}

let cachedTypeScript: typeof ts | undefined;

function getTypeScript() {
	cachedTypeScript ??= loadTypeScript();
	return cachedTypeScript;
}

function loadTypeScript(): typeof ts {
	const candidates = [
		'typescript',
		path.resolve(process.cwd(), 'node_modules/typescript'),
		path.resolve(import.meta.dirname, '../../../tgui/node_modules/typescript'),
	];

	for (const candidate of candidates) {
		try {
			return require(candidate) as typeof ts;
		} catch {
			continue;
		}
	}

	throw new Error(
		'Modular tgui AST patches require the tgui TypeScript dependency to be installed',
	);
}

function addImport(source: string, content: string) {
	const importText = ensureTrailingNewline(content);
	const firstNonImportIndex = findImportInsertionIndex(source);

	if (firstNonImportIndex === 0) {
		return `${importText}${source}`;
	}

	const prefix = source[firstNonImportIndex - 1] === '\n' ? '' : '\n';

	return `${source.slice(0, firstNonImportIndex)}${prefix}${importText}${source.slice(
		firstNonImportIndex,
	)}`;
}

function findImportInsertionIndex(source: string) {
	const sourceFile = createSourceFile(source, '(imports)');
	const syntax = getTypeScript();
	const lastImport = [...sourceFile.statements]
		.reverse()
		.find((statement) => syntax.isImportDeclaration(statement));

	if (lastImport) {
		const lineEnd = source.indexOf('\n', lastImport.end);
		return lineEnd === -1 ? source.length : lineEnd + 1;
	}

	return 0;
}

function addTypeMember(
	source: string,
	typeName: string,
	content: string,
	target: string,
) {
	const declaration = findTypeDeclaration(source, typeName, target);
	const closeIndex = findMatchingDelimiter(source, declaration.openIndex, '{', '}', target);

	return insertBeforeIndex(source, closeIndex, indentContent(content, declaration.indent + 2));
}

function findTypeDeclaration(source: string, typeName: string, target: string) {
	const typeExpression = new RegExp(
		`(^|\\n)(?<indent>\\s*)export\\s+(type|interface)\\s+${escapeRegExp(typeName)}\\b[^\\n{=]*(=\\s*)?{`,
	);
	const match = typeExpression.exec(source);

	if (!match?.groups) {
		throw new Error(`Modular tgui patch failed for ${target}: type '${typeName}' not found`);
	}

	const openIndex = source.indexOf('{', match.index);
	return {
		indent: match.groups.indent.length,
		openIndex,
	};
}

function addDelimitedEntry(
	source: string,
	anchor: string,
	openDelimiter: string,
	closeDelimiter: string,
	content: string,
	target: string,
) {
	const anchorIndex = findSingleAnchor(source, anchor, 1, target);
	const openIndex = source.indexOf(openDelimiter, anchorIndex);

	if (openIndex === -1) {
		throw new Error(
			`Modular tgui patch failed for ${target}: '${anchor}' has no '${openDelimiter}' block`,
		);
	}

	const closeIndex = findMatchingDelimiter(
		source,
		openIndex,
		openDelimiter,
		closeDelimiter,
		target,
	);
	const indent = getLineIndent(source, closeIndex);

	return insertBeforeIndex(source, closeIndex, indentContent(content, indent + 2));
}

function wrapFunctionComponent(
	source: string,
	exportName: string,
	innerName: string,
	wrapper: string,
	target: string,
) {
	const declaration = `export function ${exportName}`;
	const index = findSingleAnchor(source, declaration, 1, target);
	const renamedSource = `${source.slice(0, index)}function ${innerName}${source.slice(
		index + declaration.length,
	)}`;

	return `${ensureTrailingNewline(renamedSource)}${wrapper}`;
}

function insertAtAnchor(
	source: string,
	anchor: string,
	content: string,
	position: PatchPosition,
	expectedOccurrences: number,
	target: string,
) {
	const index = findSingleAnchor(source, anchor, expectedOccurrences, target);
	const insertIndex = position === 'before' ? index : index + anchor.length;

	return `${source.slice(0, insertIndex)}${content}${source.slice(insertIndex)}`;
}

function replaceAnchor(
	source: string,
	anchor: string,
	content: string,
	expectedOccurrences: number,
	target: string,
) {
	const index = findSingleAnchor(source, anchor, expectedOccurrences, target);

	return `${source.slice(0, index)}${content}${source.slice(index + anchor.length)}`;
}

function replaceRange(source: string, start: number, end: number, content: string) {
	return `${source.slice(0, start)}${content}${source.slice(end)}`;
}

function findSingleAnchor(
	source: string,
	anchor: string,
	expectedOccurrences: number,
	target: string,
) {
	const count = countOccurrences(source, anchor);

	if (count !== expectedOccurrences) {
		throw new Error(
			`Modular tgui patch failed for ${target}: expected ${expectedOccurrences} occurrence(s) of '${anchor}', found ${count}`,
		);
	}

	return source.indexOf(anchor);
}

function countOccurrences(source: string, anchor: string) {
	let count = 0;
	let index = source.indexOf(anchor);

	while (index !== -1) {
		count++;
		index = source.indexOf(anchor, index + anchor.length);
	}

	return count;
}

function insertBeforeIndex(source: string, index: number, content: string) {
	const prefix = source[index - 1] === '\n' ? '' : '\n';
	const suffix = content.endsWith('\n') ? '' : '\n';

	return `${source.slice(0, index)}${prefix}${content.trimEnd()}${suffix}${source.slice(index)}`;
}

function insertBeforeClosingLine(source: string, closeIndex: number, content: string) {
	const lineStart = source.lastIndexOf('\n', closeIndex) + 1;

	return insertBeforeIndex(source, lineStart, content);
}

function removeNodesByLine(source: string, nodes: ts.Node[], sourceFile: ts.SourceFile) {
	return [...nodes]
		.sort((left, right) => right.getStart(sourceFile) - left.getStart(sourceFile))
		.reduce(
			(currentSource, node) =>
				removeWholeLineRange(currentSource, node.getStart(sourceFile), node.end),
			source,
		);
}

function removeWholeLineRange(source: string, start: number, end: number) {
	const lineStart = source.lastIndexOf('\n', start) + 1;
	const nextLineStart = source.indexOf('\n', end);
	const lineEnd = nextLineStart === -1 ? source.length : nextLineStart + 1;

	return `${source.slice(0, lineStart)}${source.slice(lineEnd)}`;
}

function findMatchingDelimiter(
	source: string,
	openIndex: number,
	openDelimiter: string,
	closeDelimiter: string,
	target: string,
) {
	let depth = 0;

	for (let index = openIndex; index < source.length; index++) {
		const char = source[index];

		if (char === openDelimiter) {
			depth++;
		} else if (char === closeDelimiter) {
			depth--;

			if (depth === 0) {
				return index;
			}
		}
	}

	throw new Error(
		`Modular tgui patch failed for ${target}: no matching '${closeDelimiter}' found`,
	);
}

function getLineIndent(source: string, index: number) {
	const lineStart = source.lastIndexOf('\n', index) + 1;
	const line = source.slice(lineStart, index);
	const match = /^(\s*)/.exec(line);

	return match?.[1].length ?? 0;
}

function indentContent(content: string, spaces: number) {
	const indentation = ' '.repeat(spaces);

	return content
		.trim()
		.split('\n')
		.map((line) => `${indentation}${line}`)
		.join('\n');
}

function ensureTrailingNewline(content: string) {
	return content.endsWith('\n') ? content : `${content}\n`;
}

function escapeRegExp(value: string) {
	return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

export function generatedPathForTarget(generatedRoot: string, target: string) {
	return path.join(generatedRoot, target);
}
