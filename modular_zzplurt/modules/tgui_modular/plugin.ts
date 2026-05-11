import fs from 'node:fs';
import path from 'node:path';

import type { Compiler, RspackPluginInstance } from '@rspack/core';

import { overrides, patches } from './manifest';
import {
  applyPatchOperations,
  generatedPathForTarget,
  type ModularTguiPatch,
} from './patches';

const PLUGIN_NAME = 'ModularTguiOverlayPlugin';
const RESOLVE_EXTENSIONS = ['.tsx', '.ts', '.js', '.jsx'];
const INDEX_FILENAMES = RESOLVE_EXTENSIONS.map((extension) => `index${extension}`);

export type ModularTguiOverride = {
  /**
   * Path to the upstream tgui file, relative to the tgui/ directory.
   */
  target: string;

  /**
   * Path to the replacement file, relative to this module directory.
   */
  replacement: string;
};

type ResolvedOverride = {
  target: string;
  replacement: string;
};

type ResolvedPatch = {
  target: string;
  targetPath: string;
  generatedPath: string;
  patch: ModularTguiPatch;
};

class ModularTguiOverlayPlugin implements RspackPluginInstance {
  private readonly overridesByTarget: Map<string, string>;
  private readonly patches: ResolvedPatch[];
  private readonly tguiRoot: string;

  constructor(tguiRoot: string, overrides: ResolvedOverride[], patches: ResolvedPatch[]) {
    this.tguiRoot = tguiRoot;
    this.overridesByTarget = new Map(
      overrides.map((override) => [override.target, override.replacement]),
    );
    this.patches = patches;

    for (const patch of patches) {
      this.overridesByTarget.set(patch.target, patch.generatedPath);
    }
  }

  apply(compiler: Compiler) {
    const emitPatchedSources = () => this.emitPatchedSources();

    compiler.hooks.beforeRun.tap(PLUGIN_NAME, emitPatchedSources);
    compiler.hooks.watchRun.tap(PLUGIN_NAME, emitPatchedSources);

    compiler.hooks.normalModuleFactory.tap(PLUGIN_NAME, (normalModuleFactory) => {
      normalModuleFactory.hooks.beforeResolve.tap(PLUGIN_NAME, (resolveData) => {
        const replacement = this.findReplacement(
          resolveData.context,
          resolveData.request,
        );

        if (replacement) {
          resolveData.request = replacement;
        }
      });
    });
  }

  private emitPatchedSources() {
    for (const resolvedPatch of this.patches) {
      const source = fs.readFileSync(resolvedPatch.targetPath, 'utf8');
      const patchedSource = applyPatchOperations(
        source,
        resolvedPatch.patch.operations,
        resolvedPatch.patch.target,
      );

      fs.mkdirSync(path.dirname(resolvedPatch.generatedPath), { recursive: true });
      fs.writeFileSync(resolvedPatch.generatedPath, patchedSource);
    }
  }

  private findReplacement(context: string, request: string) {
    return findOverrideReplacement(
      context,
      request,
      this.overridesByTarget,
      this.tguiRoot,
    );
  }
}

export function findOverrideReplacement(
  context: string,
  request: string,
  overridesByTarget: Map<string, string>,
  tguiRoot?: string,
) {
  const requestPath = resolveRequestPath(context, request, tguiRoot);

  if (!requestPath) {
    return undefined;
  }

  for (const candidate of getResolutionCandidates(requestPath)) {
    const replacement = overridesByTarget.get(normalizePath(candidate));
    if (replacement) {
      return replacement;
    }
  }

  return undefined;
}

function resolveRequestPath(context: string, request: string, tguiRoot?: string) {
  if (request.startsWith('.')) {
    return path.resolve(context, request);
  }

  if (path.isAbsolute(request)) {
    return request;
  }

  if (tguiRoot) {
    const aliasPath = resolveTguiAliasRequest(tguiRoot, request);
    if (aliasPath) {
      return aliasPath;
    }
  }

  return null;
}

function resolveTguiAliasRequest(tguiRoot: string, request: string) {
  const aliases = [
    ['tgui-dev-server', 'packages/tgui-dev-server'],
    ['tgui-panel', 'packages/tgui-panel'],
    ['tgui-say', 'packages/tgui-say'],
    ['tgui', 'packages/tgui'],
  ] as const;

  for (const [alias, target] of aliases) {
    if (request === alias || request.startsWith(`${alias}/`)) {
      const rest = request === alias ? '' : request.slice(alias.length + 1);
      return path.resolve(tguiRoot, target, rest);
    }
  }

  return undefined;
}

export function createModularTguiPlugins(tguiRoot = path.resolve()) {
  const moduleRoot = path.resolve(import.meta.dirname);
  const resolvedOverrides = resolveOverrides(tguiRoot, moduleRoot, overrides);
  const resolvedPatches = resolvePatches(tguiRoot, moduleRoot, patches);

  if (resolvedOverrides.length === 0 && resolvedPatches.length === 0) {
    return [];
  }

  return [new ModularTguiOverlayPlugin(tguiRoot, resolvedOverrides, resolvedPatches)];
}

function resolveOverrides(
  tguiRoot: string,
  moduleRoot: string,
  overrideList: ModularTguiOverride[],
) {
  return overrideList.map((override) => {
    const target = path.resolve(tguiRoot, override.target);
    const replacement = path.resolve(moduleRoot, override.replacement);

    validateFile(target, `Override target '${override.target}'`);
    validateFile(replacement, `Override replacement '${override.replacement}'`);

    return {
      target: normalizePath(target),
      replacement,
    };
  });
}

function resolvePatches(
  tguiRoot: string,
  moduleRoot: string,
  patchList: ModularTguiPatch[],
) {
  const generatedRoot = path.resolve(moduleRoot, '.generated');

  return patchList.map((patch) => {
    const targetPath = path.resolve(tguiRoot, patch.target);
    const generatedPath = generatedPathForTarget(generatedRoot, patch.target);

    validateFile(targetPath, `Patch target '${patch.target}'`);

    return {
      target: normalizePath(targetPath),
      targetPath,
      generatedPath,
      patch,
    };
  });
}

function validateFile(filePath: string, label: string) {
  if (!fs.existsSync(filePath)) {
    throw new Error(`${PLUGIN_NAME}: ${label} does not exist: ${filePath}`);
  }
}

function getResolutionCandidates(requestPath: string) {
  const extension = path.extname(requestPath);

  if (extension) {
    return [requestPath];
  }

  return [
    ...RESOLVE_EXTENSIONS.map((extension) => `${requestPath}${extension}`),
    ...INDEX_FILENAMES.map((filename) => path.join(requestPath, filename)),
  ];
}

function normalizePath(filePath: string) {
  return path.normalize(filePath);
}
