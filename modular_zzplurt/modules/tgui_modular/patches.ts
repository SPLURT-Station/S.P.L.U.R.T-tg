import path from 'node:path';
import { createRequire } from 'node:module';

import type ts from 'typescript';

const IMPORT_STATEMENT = /^\s*import(?:\s|["{*])/;
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
  | AstWrapFunctionComponentPatchOperation;

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
  const firstNonImportIndex = findFirstNonImportIndex(source);

  if (firstNonImportIndex === 0) {
    return `${importText}${source}`;
  }

  return `${source.slice(0, firstNonImportIndex)}${importText}${source.slice(
    firstNonImportIndex,
  )}`;
}

function findFirstNonImportIndex(source: string) {
  let index = 0;
  let sawImport = false;

  while (index < source.length) {
    const lineEnd = source.indexOf('\n', index);
    const nextLineIndex = lineEnd === -1 ? source.length : lineEnd + 1;
    const line = source.slice(index, nextLineIndex);

    if (IMPORT_STATEMENT.test(line)) {
      sawImport = true;
    } else if (line.trim() === '') {
      if (sawImport) {
        return index;
      }
    } else {
      return index;
    }

    index = nextLineIndex;
  }

  return index;
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
