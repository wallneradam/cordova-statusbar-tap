var exec = require('cordova/exec');
var StatusbarTap = function() {
    exec(null, null, 'StatusbarTap', 'initListener', []);
};
module.exports = new StatusbarTap();
