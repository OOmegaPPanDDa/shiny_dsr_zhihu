var zhihu = require('zhihu');
var topicID = process.argv[2];

zhihu.Topic.getTopicByID(topicID).then(function(result){
	console.log(result)
});