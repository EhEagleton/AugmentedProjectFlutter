const fs = require('fs');
const path = require('path');

module.exports = {
  onPreBuild: async ({ utils }) => {
    console.log('Local Plugin: Running onPreBuild to clean up environment before Flutter installation.');
    const flutterDir = path.join(process.env.HOME, 'flutter');

    if (fs.existsSync(flutterDir)) {
      console.log(`Local Plugin: Flutter directory exists at ${flutterDir}. Removing it to ensure clean installation...`);
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
  }
};
