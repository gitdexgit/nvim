return {
	"David-Kunz/gen.nvim",
	-- ... (opts remain the same)
	opts = {
		model = "phi4-mini:3.8b",
		display_mode = "float",
		show_prompt = true,
		show_model = true,
		no_auto_close = false,
		debug = false,
	},
	keys = {
		{
			"<leader>gg",
			function()
				local gen = require("gen")
				local prompts = vim.tbl_keys(gen.prompts)
				table.sort(prompts)

				local display_list = {}
				for _, name in ipairs(prompts) do
					local p = gen.prompts[name]
					local model = p.model or "phi4-mini:3.8b"

					local raw_prompt = type(p.prompt) == "string" and p.prompt or "Custom logic..."

					local clean_prompt = raw_prompt:gsub("\n", " ")
						:gsub("%$text", "...")
						:gsub("%s+", " ")
						:sub(1, 150)

					table.insert(display_list, string.format("%-20s │ %-16s │ %s", name, model, clean_prompt))
				end

				require("fzf-lua").fzf_exec(display_list, {
					actions = {
						["default"] = function(selected)
							if selected and selected[1] then
								local prompt_name = selected[1]:match("^(%S+)")
								vim.schedule(function()
									vim.cmd("Gen " .. prompt_name)
								end)
							end
						end,
					},
					winopts = {
						height = 0.6,
						width = 0.9,
						row = 0.4,
						title = " AI Workstation ",
						title_pos = "center"
					},
					previewer = false,
					fzf_opts = {
						["--delimiter"] = "│",
						["--nth"] = "1",
					},
				})
			end,
			desc = "AI Search",
			mode = { "n", "v" },
		},
		-- FAST ACCESS KEYS (Commented out)
		-- { "<leader>gd", ":Gen Duck_Socratic<CR>", mode = { "n", "v" }, desc = "Duck Debug" },
		-- { "<leader>ga", ":Gen Arch_Expert<CR>",  mode = { "n", "v" }, desc = "Arch Wiki" },
		-- { "<leader>ge", ":Gen Quick_Fix<CR>",   mode = { "v" },       desc = "Quick Fix" },
		-- { "<leader>gl", ":Gen ELI5_Drunk<CR>",  mode = { "n", "v" }, desc = "Explain Simply" },
	},
	config = function(_, opts)
		local gen = require("gen")
		gen.setup(opts)

		-----------------------------------------------------------------------
		-- THE "DUCK" (SOCRATIC DEBUGGING)
		-----------------------------------------------------------------------
		gen.prompts["Duck_Socratic"] = {
			prompt = "You are a Socratic Rubber Duck. I am explaining my code/problem to you.\n"
				.. "1. DO NOT give me the answer.\n"
				.. "2. DO NOT provide fixed code.\n"
				.. "3. Analyze my 'mumbo jumbo' and ask 2-3 targeted, deep questions that force me to realize the flaw myself.\n"
				.. "Focus on edge cases, state management, or logic flow. Text:\n$text",
			model = "deepseek-r1:7b",
		}

		-----------------------------------------------------------------------
		-- TEXT & UTILITY (New Prompt Added Here!)
		-----------------------------------------------------------------------
		gen.prompts["ELI5_Drunk"] = {
			prompt = "Explain this concept or code to me as if I'm a 5-year-old or a very tired, slightly drunk person at a bar. "
                .. "Use zero technical jargon. Use simple real-world analogies (like pizza, LEGOs, or cars). "
                .. "Be conversational, funny, and make it impossible to misunderstand. Text:\n$text",
			model = "phi4-mini:3.8b",
		}

		gen.prompts["Explain_This"] = {
			prompt = "Explain this technical concept or code block like I'm a junior dev. Be concise:\n$text",
			model = "phi4-mini:3.8b",
		}

		gen.prompts["Quick_Fix"] = {
			prompt = "Fix grammar and spelling only. Output ONLY the result:\n$text",
			replace = true,
			model = "qwen2.5:1.5b",
		}

		gen.prompts["Rephrase"] = {
			prompt = "Rewrite this to be clearer and more professional while keeping the same meaning:\n$text",
			replace = true,
			model = "gemma2:latest",
		}

		gen.prompts["Bullet_Points"] = {
			prompt = "Turn this text/code into a clean markdown bulleted list of key points:\n$text",
			replace = true,
			model = "llama3.2:1b",
		}

		-----------------------------------------------------------------------
		-- CODING & REFACTORING
		-----------------------------------------------------------------------
		gen.prompts["Refactor_Code"] = {
			prompt = "Refactor the following code to be more idiomatic, efficient, and readable. Maintain the same functionality. Explain briefly what you changed:\n$text",
			model = "qwen2.5-coder:7b",
			replace = true,
		}

		gen.prompts["Unit_Tests"] = {
			prompt = "Write comprehensive unit tests for the following code snippet using a standard testing framework appropriate for the language:\n$text",
			model = "qwen2.5-coder:7b",
		}

		gen.prompts["Suggest_Names"] = {
			prompt = "Give me 5 high-quality, descriptive variable or function names based on this logic/context. Just a list:\n$text",
			model = "qwen2.5:0.5b",
		}

		gen.prompts["Pseudocode"] = {
			prompt = "Convert this code into high-level logic steps (pseudocode). No syntax, just logic:\n$text",
			replace = true,
			model = "qwen2.5-coder:3b",
		}

		-----------------------------------------------------------------------
		-- SYSTEM & WORKFLOW
		-----------------------------------------------------------------------
		gen.prompts["Arch_Expert"] = {
			prompt = "You are an Arch Linux expert. Give a concise command or config fix for:\n$text",
			model = "qwen3.5:4b",
		}

		gen.prompts["Shell_Helper"] = {
			prompt = "Convert the following natural language request into a precise Arch Linux terminal command. Output ONLY the command:\n$text",
			model = "qwen3.5:4b",
		}

		gen.prompts["Git_Commit"] = {
			prompt = "Review the following diff and write a concise git commit message in conventional commits format (e.g., 'feat: ...' or 'fix: ...'). Output ONLY the message:\n$text",
			model = "qwen2.5:1.5b",
		}
	end,
}
