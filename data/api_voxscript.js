const URL = "https://teardowngame.com/modding/voxscript.html";
const OUT = "voxscript";

async function format(data) {
	for (const cat of data.categories) {
		cat.description = cat.description.split("\n");
	}

	for (const func of data.functions) {
		func.description = func.description.split("\n");
		func.example = func.example.split("\n");
	}

	return data;
}

//==========================//

const { scrapeAPI, outputData } = require("./scraper");
const path = require("path");

scrapeAPI(URL)
	.then(format)
	.then(data => outputData(path.join(__dirname, OUT), data));
