return {
	"David-Kunz/gen.nvim",
	opts = {
		model = "phi3.5", -- Default for logic and writing
		display_mode = "float",
		show_prompt = true,
		show_model = true,
		no_auto_close = false,
		debug = false,
	},
	keys = {
		{ "<leader>]", ":Gen<CR>", mode = { "n", "v" }, desc = "Llama/Gen" },
	},
	config = function(_, opts)
		local gen = require("gen")
		gen.setup(opts)

		---------------------------------------------------------------------------
		-- TECHNICAL SPECIALISTS (Coding & Linux)
		---------------------------------------------------------------------------
		gen.prompts["Fix_Code"] = {
			prompt = "Fix the following code. Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
			replace = true,
			extract = "```$filetype\n(.-)```",
			model = "deepseek-coder:6.7b",
		}

		gen.prompts["Linux_Expert"] = {
			prompt = "You are an Arch Linux expert. Explain this or provide a command for:\n$text",
			model = "qwen2.5:7b",
		}

		---------------------------------------------------------------------------
		-- WRITING & UTILITY PROMPTS (The ones you liked from the video)
		---------------------------------------------------------------------------
		gen.prompts["Elaborate_Text"] = {
			prompt = "Elaborate the following text, making it more detailed and professional:\n$text",
			replace = true,
		}

		gen.prompts["Enhance_Grammar_Spelling"] = {
			prompt = "Modify the following text to improve grammar and spelling, maintaining the original tone:\n$text",
			replace = true,
		}

		gen.prompts["Deep_Reasoning"] = {
			prompt = "Carefully think through this problem and provide a detailed solution:\n$text",
			model = "deepseek-r1:7b", -- Use the reasoning model
			replace = false,
		}

		gen.prompts["Make_Concise"] = {
			prompt = "Modify the following text to make it as simple and concise as possible:\n$text",
			replace = true,
		}

		gen.prompts["Make_List"] = {
			prompt = "Render the following text as a markdown list:\n$text",
			replace = true,
		}

		gen.prompts["Make_Summary"] = {
			prompt = "Summarize the following text in a few brief sentences:\n$text",
			replace = false, -- This will display in a window rather than replacing your text
		}
	end,
}
