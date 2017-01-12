var zhihu = require('zhihu');
var topicID = process.argv[2];

zhihu.Topic.getTopicByID(topicID, process.argv[3]).then(function(result){
	for(i=0;i<20;i++)
	{
	  	if(result.questions[i])
	  	{
	  		console.log(result.questions[i].url);
		}
	}
});