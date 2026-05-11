import path from 'node:path';

import rspack, { type Configuration } from '@rspack/core';

import { createModularTguiPlugins } from '../modular_zzplurt/modules/tgui_modular';
import oldConfig, { createStats } from './rspack.config';

export const config = {
  ...oldConfig,
  devtool: 'cheap-module-source-map',
  devServer: {
    hot: true,
  },
  mode: 'development',
  output: {
    ...oldConfig.output,
    path: path.resolve(import.meta.dirname, './public/.tmp'),
  },
  plugins: [
    ...createModularTguiPlugins(path.resolve(import.meta.dirname)),
    new rspack.CssExtractRspackPlugin({
      chunkFilename: '[name].bundle.css',
      filename: '[name].bundle.css',
    }),
    new rspack.EnvironmentPlugin({
      NODE_ENV: 'development',
    }),
    new rspack.HotModuleReplacementPlugin(),
  ],
  stats: createStats(false),
} satisfies Configuration;
