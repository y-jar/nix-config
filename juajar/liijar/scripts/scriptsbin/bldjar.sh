#!/bin/bash

# Define the directory structure, Add any more if deemed needed :)
dirs=(
	"art-jar/art-glaze-mound-bin"
	"art-jar/book-jar"
	"art-jar/not-mine-glaze-jar"
	"cask-jar/mound-cask-jar"
	"doc-jar/par-jar"
	"doc-jar/writing-jar"
	"doc-jar/notes-jar"
	"key-bin"
	"music-jar"
	"rot-jar"
	"pic-jar/ascii-art-bin"
	"pic-jar/gifs-bin"
	"pic-jar/img-mound-jar"
	"pic-jar/pfp-bin"
	"pic-jar/scrtakes-jar/scr-mound-bin"
	"pic-jar/wall-bin"
	"school-jar"
	"s-jar/config-jar"
	"s-jar/p-jar"
	"s-jar/vaults-jar"
	"vid-jar/important-media-jar"
	"vid-jar/meme-mound-bin"
	"vid-jar/sub-10mb-bin"
	"vid-jar/vid-glaze-bin"
	"vid-jar/vid-mound-bin"
)

echo "Creating System Registry structure..."

for dir in "${dirs[@]}"; do
	mkdir -p "$dir"
done

# Create the System Registry Key key-糸.txt
echo "Writing key-糸.txt..."

cat <<'EOF' >key-bin/key-糸.txt
================================================================================
                              THE SYSTEM REGISTRY
================================================================================
ROOT RULE:
- Major theme/category directories must end in [-Jar].
- When making new filenames: must be all lowercase with '-' as a space. If
	environment doesnt allow, Camelcase or other forms to fit the criteria.
		-NOTE: This also applies to 漢字 in filenames.

-- PRIMARY TAGS [STORAGE] ------------------------------------------------------
-Jar    | つぼ       | Main Theme / Root Container
-Bin    | びん       | Folder of resources/assets
-Cask   | くら       | Archived / Compressed / Old versions
-Coffer | からばこ   | Sensitive / Private Folder
[+NEW]  | [かな]     | [DESCRIPTION]

-- PROCESS TAGS [WORKFLOW] -----------------------------------------------------
-Loom   | はた       | Active Project / Workspace Folder (Folder / Large host file)
-Kiln   | かま/窯    | Work in Progress (File-Folder)
-Glaze  | おわり     | Final / Exported / Ready to use (File-Folder)
-Ito    | いと/糸    | Single Resource / Component (File)
-Fold   | おる「折る | Data Manipulation / a Component that is meant to be changed (File)
[+NEW]  | [かな]     | [DESCRIPTION]

-- KNOWLEDGE & TRACKING --------------------------------------------------------
-Key    | かぎ       | Rules / Syntax / Guides / How-to
-Trace  | あと       | Logs / Progress Tracking / Daily Notes
-Seal   | いん       | Sensitive / Protected (File)
[+NEW]  | [かな]     | [DESCRIPTION]

-- THE OVERFLOW ----------------------------------------------------------------
-Sherd  | かけら     | Flawed / Broken but kept for reference
-Mound  | つか       | Unsorted / Dump / To-be-filed
[+NEW]  | [かな]     | [DESCRIPTION]

--------------------------------------------------------------------------------
[ SYSTEM LOGIC ]
1. LOOM & JAR: A [-Loom] can live inside a [-Jar] and the other way too.
2. RAW TO FINISHED: [-Ito] is used in a [-Kiln] to make a [-Glaze].
3. RULES & LOGS: Use [-Key] for "Rules" and [-Trace] for "History."
================================================================================
EOF

# create the Quick Reference Tags, tags-糸.txt
echo "Writing tags-糸.txt..."

cat <<'EOF' >key-bin/tags-糸.txt
========================================
         QUICK REFERENCE TAGS
========================================
-Jar    | つぼ      : Root
-Key    | かぎ      : Rules
-Trace  | あと      : Logs
[+NEW]  | [かな]    : [DESC]
----------------------------------------
-Loom   | はた      : Project
-Kiln   | かま      : WIP
-Glaze  | おわり    : Done
-Fold   | おる, 折る: Data Manipulation
[+NEW]  | [かな]    : [DESC]
----------------------------------------
-Bin    | びん      : FolderRes
-Ito    | いと      : FileRes
----------------------------------------
-Cask   | くら      : Archive
-Coffer | からばこ  : PrivateFolder
-Seal   | いん      : PrivateFile
-Sherd  | かけら    : Flawed
-Mound  | つか      : Unsorted
[+NEW]  | [かな]    : [DESC]
========================================
EOF

echo "Deployment complete. The Registry is set."
