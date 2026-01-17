const fs = require('fs');
const path = require('path');

module.exports = {
  onInit: async ({ utils }) => {
    console.log('Local Plugin: Running onInit to clean up environment for UI plugin compatibility.');
    const flutterDir = path.join(process.env.HOME, 'flutter');
    
    if (fs.existsSync(flutterDir)) {
      console.log(`Local Plugin: Flutter directory exists at ${flutterDir}. Removing it to prevent "already exists" error in UI plugin...`);
      try {
        fs.rmSync(flutterDir, { recursive: true, force: true });
        console.log('Local Plugin: Flutter directory removed successfully.');
      } catch (e) {
        console.error('Local Plugin: Failed to remove Flutter directory:', e);
        utils.build.failBuild('Failed to clean up Flutter directory');
      }
    } else {
      console.log('Local Plugin: Flutter directory does not exist. Safe to proceed.');
    }
  },
  onPreBuild: async ({ utils }) => {
    console.log('Local Plugin: onPreBuild check.');
    // The actual installation will happen via the UI plugin (which runs after) or the build script.
    // This local plugin primarily exists to ensure the environment is clean in onInit.
  }
};
