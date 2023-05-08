const URL = "https://teardowngame.com/modding/voxscript.html";
const OUT = "voxscript";

async function format(data) {
	const files = {};

	for (const cat of data.categories) {
		for (const [name, table] of Object.entries(cat.tables)) {
			files[`table.${tableRenames[name] ?? name}`] = table;
		}
		delete cat.tables;

		cat.description = cat.description.split("\n");

		files[`category.${cat.name}`] = cat;
	}

	for (const func of data.functions) {
		for (const [name, table] of Object.entries(func.tables)) {
			files[`table.${tableRenames[name] ?? name}`] = table;
		}
		delete func.tables;

		func.description = func.description.split("\n");
		func.examples = func.examples.map(ex => ex.split("\n"));

		files[`function.${func.name}`] = func;
	}

	return [data.version, files];
}

//==========================//

const { scrapeAPI, outputData } = require("./scraper");
const path = require("path");

scrapeAPI(URL)
	.then(format)
	.then(([version, data]) => outputData(path.join(__dirname, OUT), version, data));
