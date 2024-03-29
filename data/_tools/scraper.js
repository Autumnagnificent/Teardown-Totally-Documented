const { writeFile, readFile, appendFile } = require("fs/promises");
const path = require("path");

function matchTag(text, tag) {
	return text.match(`<${tag}([^>]*)>(.*?)</${tag}>`);
}

const escMap = {
	["amp"]: "&",
	["lt"]: "<",
	["gt"]: ">",
	["nbsp"]: " ",
	["quot"]: '"',
};
function decodeEntities(str) {
	return str.replace(/&([^;]{1,4});/g, (match, code) => escMap[code] ?? match);
}

const argRegex =
	/<span class='[^']+name'>([^<]+)<\/span> <span class='argtype'>\(([^<]+)\)<\/span> &ndash; (.*?)<br\/>/g;
function parseArgs(paragraph) {
	return [...paragraph.matchAll(argRegex)].map(([_, name, type, desc]) => {
		const optional = type.indexOf(", optional");
		return {
			name,
			desc: decodeEntities(desc),
			optional: optional > -1,
			type: optional > -1 ? type.substring(0, optional) : type,
		};
	});
}

function parseExample(paragraph) {
	const m = paragraph.match(/<pre class='example'>([\s\S]*?)<\/pre>/m);
	return m && decodeEntities(m[1]).trim();
}

function translateHTML(text) {
	return text.replace(/<a href=["']([^"']*)["']>([^<]*)<\/a>/, (_, link, text) => `[${text}](${link})`);
}

function extractTables(textInput) {
	const tablesPart = {};
	const textResult = [];
	let pos = 0;

	for (const match of textInput.matchAll(/<table[^>]*>([\s\S]*?)<\/?table\/?>/gm)) {
		textResult.push(decodeEntities(textInput.substring(pos, match.index)));
		pos = match.index + match[0].length;
		const table = [];
		for (const [_, row] of match[1].matchAll(/<tr>(.*?)<\/tr>/g)) {
			table.push([...row.matchAll(/<td[^>]*>(.*?)<\/td>/g)].map(([_, column]) => decodeEntities(column).trim()));
		}
		const name = table[0][0];
		textResult.push(`\${table:${name}}`);
		table.splice(0, 1);
		tablesPart[name] = table;
	}

	textResult.push(decodeEntities(textInput.substring(pos)));

	return {
		textPart: translateHTML(textResult.join("")).trim(),
		tablesPart,
	};
}

function parseFunction(text) {
	const name = matchTag(text, "h3");
	if (!name) return;
	const paragraphs = text.split("<p>");
	let rawDescription = paragraphs[3].trim();
	if (paragraphs.length > 5) {
		rawDescription += "\n\n" + paragraphs[4].trim();
	}
	const { textPart, tablesPart } = extractTables(rawDescription);

	return {
		name: name[2],
		arguments: parseArgs(paragraphs[1]),
		returns: parseArgs(paragraphs[2]),
		examples: [parseExample(paragraphs[paragraphs.length - 1])].filter(ex => ex),
		description: textPart,
		tables: tablesPart,
	};
}

function parseCategory(text) {
	const name = matchTag(text, "h2");
	if (!name) return;
	let tables = {};
	const description = [];
	const functions = [];
	for (const part of text.split("<p>").slice(1)) {
		if (part.match(/^\W*<a href='#/)) {
			for (const [_, name] of part.matchAll(/<a href='#([^']*)'/g)) {
				functions.push(name);
			}
		} else {
			const { textPart, tablesPart } = extractTables(part);
			tables = { ...tables, ...tablesPart };
			if (textPart !== "") {
				description.push(textPart);
			}
		}
	}
	return {
		name: name[2],
		description: description.join("\n\n"),
		tables,
		functions,
	};
}

async function scrapeAPI(url) {
	const data = await fetch(url).then(data => data.text());
	const version = data.match(/<h1>.*?\(([\d\.]+)[^\)]*\)<\/h1>/)[1];
	const categories = [];
	const functions = [];

	for (const part of data.split("<hr/>")) {
		const category = parseCategory(part);
		if (category) {
			category.functions.sort();
			categories.push(category);
			continue;
		}
		const func = parseFunction(part);
		if (func) {
			functions.push(func);
		}
	}

	return {
		version,
		categories,
		functions,
	};
}

function formatDescription(description, options) {
	const words = description.split(/\s+/);
	let currentLine = "";
	let formattedDescription = "";

	for (const word of words) {
		if (currentLine.length + word.length + 1 <= (options?.printWidth ?? 80)) {
			currentLine += (currentLine ? " " : "") + word;
		} else {
			formattedDescription += (formattedDescription ? "\n" : "") + currentLine;
			currentLine = word;
		}
	}

	if (currentLine) {
		formattedDescription += (formattedDescription ? "\n" : "") + currentLine;
	}

	return formattedDescription;
}

async function outputData(root, version, files) {
	const localVersion = (await readFile(path.join(root, "version")).catch(() => "")).toString();
	if (localVersion === version) {
		console.log("Up to date");
		process.exit(1);
	}
	if (process.env.GITHUB_OUTPUT) {
		await appendFile(process.env.GITHUB_OUTPUT, `version=${version}`);
	}

	await writeFile(path.join(root, "version"), version);

	for (const [name, data] of Object.entries(files)) {
		const fileName = path.join(root, `${name.replace(/[\x00-\x20\x80-\x9f\/?<>\\:*|"]/g, "-")}.json`);
		await writeFile(fileName, JSON.stringify(data, null, 2));
	}
}

exports.scrapeAPI = scrapeAPI;
exports.formatDescription = formatDescription;
exports.outputData = outputData;
