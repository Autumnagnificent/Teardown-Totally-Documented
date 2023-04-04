function matchTag(text, tag) {
	return text.match(`<${tag}([^>]*)>(.*?)</${tag}>`);
}

const argRegex = /<span class='[^']+name'>([^<]+)<\/span> <span class='argtype'>\(([^<]+)\)<\/span> &ndash; (.*?)<br\/>/g;
function parseArgs(paragraph) {
	return [...paragraph.matchAll(argRegex)].map(([_, name, type, desc]) => {
		const optional = type.indexOf(', optional');
		return {
			name,
			desc,
			optional: optional > -1,
			type: optional > -1 ? type.substring(0, optional) : type
		};
	});
}

function parseExample(paragraph) {
	const m = paragraph.match(/<pre class='example'>([\s\S]*?)<\/pre>/m);
	return m && m[1].trim();
}

function extractTables(description) {
	const tables = {};
	const newDescription = [];
	let newDescritionPosition = 0;

	for (const match of description.matchAll(/<table[^>]*>([\s\S]*?)<table\/>/gm)) {
		newDescription.push(description.substring(newDescritionPosition, match.index));
		newDescritionPosition = match.index + match[0].length;
		const table = [];
		for (const [_, row] of match[1].matchAll(/<tr>(.*?)<\/tr>/g)) {
			table.push([...row.matchAll(/<td[^>]*>(.*?)<\/td>/g)].map(([_, column]) => column.replace(/&nbsp;/gm, '').trim()));
		}
		const name = table[0][0];
		newDescription.push(`\${table:${name}}`);
		table.splice(0, 1);
		tables[name] = table;
	}

	newDescription.push(description.substring(newDescritionPosition));

	return {
		description: newDescription.join(''),
		tables,
	}
}

function parseFunction(text) {
	const funcNameMatch = matchTag(text, 'h3');
	if (!funcNameMatch) return;
	const paragraphs = text.split('<p>');
	let rawDescription = paragraphs[3].trim();
	if (paragraphs.length > 5) {
		rawDescription += '\n\n' + paragraphs[4].trim();
	}
	const {description, tables} = extractTables(rawDescription);
	
	return {
		name: funcNameMatch[2],
		arguments: parseArgs(paragraphs[1]),
		returns: parseArgs(paragraphs[2]),
		example: parseExample(paragraphs[paragraphs.length - 1]),
		description,
		tables,
	}
}


async function scrapeAPI(url) {
	const sections = [];
	const functions = [];

	for (const part of await fetch(url).then(data => data.text()).then(text => text.split("<hr/>"))) {
		const category = matchTag(part, 'h2');
		if (category) {
			//console.log('categ', category[2]);
			continue;
		}
		const func = parseFunction(part);
		if (func) {
			functions.push(func);
		}
	}
}

scrapeAPI("https://teardowngame.com/modding/api.html");