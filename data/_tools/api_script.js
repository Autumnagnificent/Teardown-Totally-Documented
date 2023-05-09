const URL = "https://teardowngame.com/modding/api.html";
const OUT = "../script";

const tableRenames = {
	["Alignment"]: "UiAlignment",
	["Function"]: "Callbacks",
	["Key"]: "RegistryRoots",
	["Layer"]: "QueryLayer",
	["Logical input"]: "InputLogical",
	["Physical input"]: "InputPhysical",
	["State"]: "PathState",
};
const tableRenamesRegex = /\$\{table:([^}]+)\}/g;
const tableRenamesFunc = (_, name) => `\${table:${tableRenames[name] ?? name}}`;

async function format(data) {
	const files = {};

	for (const cat of data.categories) {
		for (const [name, table] of Object.entries(cat.tables)) {
			files[`table.${tableRenames[name] ?? name}`] = table;
		}
		delete cat.tables;

		cat.description = cat.description.replaceAll(tableRenamesRegex, tableRenamesFunc).split("\n");

		files[`category.${cat.name}`] = cat;
	}

	for (const func of data.functions) {
		for (const [name, table] of Object.entries(func.tables)) {
			files[`table.${tableRenames[name] ?? name}`] = table;
		}
		delete func.tables;

		func.description = func.description.replaceAll(tableRenamesRegex, tableRenamesFunc).split("\n");
		func.examples = func.examples.map(ex => ex.replaceAll(tableRenamesRegex, tableRenamesFunc).split("\n"));

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
