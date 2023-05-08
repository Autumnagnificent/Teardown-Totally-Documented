# Documentation Data

This folder is meant as a repository for function, category, and table definitions both official and unofficial. Official information ([Like the scripting API](https://teardowngame.com/modding/api.html)) is retrieved from the relevant pages when updated and may be modified in this repo on the appropriate branch (see below).

The end goal is for it to exist as a structured pool of information for community members who wish to contribute knowledge and projects that aim to render this knowledge in some fashion (wiki pages, IDE extensions, ...).

## Updating Official Information

In order to keep up with the official modding resources, this repository contains the tools and procedures to retrieve this information. Resolving conflicts arising from divergences between community modifications and official edits should be handled in the typical git-fashion:

Automated retrieving tools should have their changes commited to the `official` branch. **Do not commit manual edits to this branch!** When the `official` branch gets updated, it should be merged into the `main` branch either locally by a maintainer or by creating a Pull Request. The following graph depicts this process over multiple updates:

```mermaid
gitGraph
	commit id: "..."
	branch "official"
	checkout "official"
	commit id: "Update A" type: HIGHLIGHT
	checkout main
	merge "official" id: "Merge A" tag: "1.0.0"
	commit id: "Edit A"
	checkout "official"
	commit id: "Update B" type: HIGHLIGHT
	checkout main
	merge "official" id: "Merge B" tag: "1.1.0"
	commit id: "Edit B"
	commit id: "Edit C"
	checkout "official"
	commit id: "Update C" type: HIGHLIGHT
	checkout main
	merge "official" id: "Merge C" tag: "1.2.0"
```

Conflict resolution should be considered carefully, we don't want to ignore official updates, but community-contributed knowledge should certainly not be deleted if it is still relevant.