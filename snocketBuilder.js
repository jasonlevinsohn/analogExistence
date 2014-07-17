var Snockets = require('snockets'),
    cheerio  = require('cheerio'),
    fs       = require('fs'),
    grunt    = require('grunt'),
    scriptList,
    compiledAssets;

module.exports = snocketBuilder = ({
    build: function (paths, srcHtml, destHtml) {

        var srcFolder = 'src/';
        console.log('\nCompiling Assets...');

        snockets = new Snockets();
        var compiledAssets = snockets.getCompiledChain(paths, {async: false});
        scriptList = buildAssets(compiledAssets);
        chipchip(scriptList);
        grunt.log.ok("Asset Loading into " + destHtml + " Complete");

        function buildAssets(chain) {
            var assetList = [];
            var assetString,
                origName,
                cleanedName = "";

            for (var i = 0; i < chain.length - 1; i++) {
                // Remove the source folder path
                origName = chain[i].filename;

                cleanedName = origName.substring(origName.indexOf(srcFolder) + srcFolder.length);
                console.log(cleanedName);
                assetString = '<script type="text/javascript" src="' + cleanedName + '"></script>\n';
                assetList.push(assetString);
            }
            return assetList;
        }

        function chipchip(scripts) {
            $ = cheerio.load(fs.readFileSync(srcHtml));
            for (var i = 0; i < scripts.length; i++) {
                $('body').append(scripts[i]);
            }

            // If the build directory doesn't exist, we
            // need to create it.
            // NOTE: We should make this dynamic later.
            if (!fs.existsSync('build/')) {
                fs.mkdirSync('build/');
            }
            fs.writeFileSync(destHtml, $('html'));
        }
    },
        
}); 






