--- === GridCraft.Examples ===
---
--- Contains paths to all the examples in the documentation site,
--- but only works from the git checkout -- not from the installed spoon.

local M = {}

--- GridCraft.Examples.reporoot
--- Constant
--- The path to the example in the repository root
M.reporoot = hs.spoons.resourcePath("example.lua.txt")

return M
