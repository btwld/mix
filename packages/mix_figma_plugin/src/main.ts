import { createPluginController, isUiToSandboxMessage } from './controller';

figma.showUI(__html__, { height: 640, themeColors: true, width: 420 });

const controller = createPluginController(figma, (message) => {
  figma.ui.postMessage(message);
});

figma.ui.onmessage = (message) => {
  if (isUiToSandboxMessage(message)) void controller.handleMessage(message);
};

figma.ui.postMessage({ type: 'plugin-ready' });
