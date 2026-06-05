return {
	"David-Kunz/gen.nvim",
	opts = {
		model = "qwen2.5-coder:3b", -- Fast default
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

				local curr_mode = vim.api.nvim_get_mode().mode
				local is_visual = curr_mode:find("[vV]") or curr_mode:find("\22")

				local display_list = {}
				for _, name in ipairs(prompts) do
					local p = gen.prompts[name]
					local model = p.model or "qwen2.5-coder:3b"
					local raw_prompt = type(p.prompt) == "string" and p.prompt or "Custom logic..."
					local clean_prompt = raw_prompt:gsub("\n", " "):gsub("%$text", "..."):gsub("%s+", " "):sub(1, 100)
					table.insert(display_list, string.format("%-20s │ %-16s │ %s", name, model, clean_prompt))
				end

				require("fzf-lua").fzf_exec(display_list, {
					actions = {
						["default"] = function(selected)
							if selected and selected[1] then
								local prompt_name = selected[1]:match("^(%S+)")
								local range = is_visual and "'<,'>" or ""
								vim.schedule(function()
									vim.cmd(range .. "Gen " .. prompt_name)
								end)
							end
						end,
					},
					winopts = { height = 0.6, width = 0.9, title = " AI Workstation ", title_pos = "center" },
					previewer = false,
					fzf_opts = { ["--delimiter"] = "│", ["--nth"] = "1" },
				})
			end,
			desc = "AI Search",
			mode = { "n", "v" },
		},
	},
	config = function(_, opts)
		local gen = require("gen")
		gen.prompts = {} -- Wipe defaults
		gen.setup(opts)

		-----------------------------------------------------------------------
		-- HEAVY LOGIC (7b / 8b / e4b)
		-----------------------------------------------------------------------
		gen.prompts["Big_Brain"] = {
			prompt = "Analyze deeply and provide expert solution:\n$text",
			model = "gemma4:e4b",
		}

		gen.prompts["Caveman_Learn"] = {
			prompt = [=[
Terse. Technical substance stay. Fluff die. Q&A learning evaluator.
Rules: User writes BOTH Question and Answer. Goal: Active learning.
Watchdogs: Atomic Check (Q too broad?), No Hedging (Punish "maybe"), Precision (Judge concept), Pinpoint (Quote wrong part), Socratic Redirect (Ask question, don't give answer).

[GROUND TRUTH: DO NOT READ]
<exact_correct_answer: ultra_intensity>
[/GROUND TRUTH]

[LOGIC]
{A:q_atomic; B:form_clean; C:concept_correct; D:term_correct} | A && B && C;;$intent=evaluate_learning;;$state=[hot|blocked];;$gap=[none|term_only|concept|<description>]
[/LOGIC]

[ASM]
MOV R0, "<q_flaws>"; MOV R1, "<a_form_flaws>"; MOV R2, "<concept_gap>"; MOV R3, "<term_gap>"; MOV R4, "<good_analogy>"; MOV R5, "<socratic_redirect>"; MOV R6, "<model_answer_ultra>"; MOV R7, "<socratic_probes>"
[/ASM]

[ANS]
Output ONLY the verdict. If fail: Q-Check, Form, Good, Logic (quote error), Socratic Redirect. If term gap: Correct concept + teach term. If match: Correct + Ground Truth (Ultra) + Socratic probes.
Text: $text
]=],
			model = "qwen2.5-coder:7b",
		}

		gen.prompts["Duck_Socratic"] = {
			prompt = "Socratic Rubber Duck. DO NOT give answer. Ask 2-3 deep questions:\n$text",
			model = "deepseek-r1:8b",
		}

		gen.prompts["Unit_Tests"] = {
			prompt = "Write comprehensive unit tests:\n$text",
			model = "qwen2.5-coder:7b",
		}

		gen.prompts["Refactor_Code"] = {
			prompt = "Refactor for idiomatic flow. Explain changes briefly:\n$text",
			model = "qwen2.5-coder:7b",
			replace = true,
		}

		-----------------------------------------------------------------------
		-- MID-SPEED (3b)
		-----------------------------------------------------------------------
		gen.prompts["Suggest_Names"] = {
			prompt = "Give 5 descriptive variable/function names. List only:\n$text",
			model = "qwen2.5-coder:3b",
		}

		gen.prompts["Pseudocode"] = {
			prompt = "Convert to high-level logic steps. No syntax:\n$text",
			model = "qwen2.5-coder:3b",
			replace = true,
		}

		-----------------------------------------------------------------------
		-- FAST UTILS (llama3.2)
		-----------------------------------------------------------------------
		gen.prompts["Atomic_Refine"] = {
			prompt = [=[
Role: Refine questions into atomic form. Match user's technical level.
Strict Sequence: Always output [LOGIC], then [ANS].
Rules:
1. Recall Target First: Extract anchor from 'questions'.
2. Minimum Questions: N in -> N out. Split only if 2+ recall targets.
3. Complexity Ceiling: Mirror user's domain terms. No analogies.
4. Hint, Don't Reveal: Trigger recall of 'answers'. Do not restate them.
5. Self-Contained: Append domain context (e.g., "in C", "in React").

[LOGIC]
{A:raw; B:questions; C:answers; D:complexity} | (A && B && C) => Refine(D);;$intent=atomize_to_user_level;;$recall_target=[extracted];;$state=[hot];;$mode=full
[/LOGIC]

[ANS]
- [Atomic Question]
[/ANS]
Input: $text
]=],
			model = "llama3.2:latest",
		}

		gen.prompts["Search_Oracle"] = {
			prompt = [=[
Role: Parse intent. Know answer internally. Never reveal. Output queries that lead user there.
Linguistic Rules: Fragments. No articles/filler. Abbrev. Strip conjunctions.
Output:
<logic>
{A=prop1,B=prop2,...} [C-formula];;$intent=[goal];;$anti_goal=[!goal];;$vars=[entities];;$state=[current];;$unknowns=[what must be found]
</logic>
<queries>
[n]. "[query string]" → [what this finds] :: resolves($prop)
Rules: Keyword-dense. Cover core, variations, edge cases, inversions. Never write answer.
</queries>
Input: $text
]=],
			model = "llama3.2:latest",
		}

		gen.prompts["Task_Architect"] = {
			prompt = [=[
Act as Taskwarrior architect. Convert brain dump into atomic, actionable tasks.
Rules:
1. Each task must be atomic (smallest possible unit).
2. Output ONLY 'task add project:<name> <description>' commands.
3. Infer project names from context.
4. No conversational filler or explanations.
Dump: $text
]=],
			model = "llama3.2:latest",
		}

		gen.prompts["Quick_Fix"] = {
			prompt = "Fix grammar and spelling only. Output ONLY result:\n$text",
			replace = true,
			model = "llama3.2:latest",
		}

		gen.prompts["Git_Commit"] = {
			prompt = "Write concise git commit message. Output ONLY message:\n$text",
			model = "llama3.2:latest",
		}

		gen.prompts["Bullet_Points"] = {
			prompt = "Turn into clean markdown bullet points:\n$text",
			model = "llama3.2:latest",
		}

		-----------------------------------------------------------------------
		-- SPECIALIZED
		-----------------------------------------------------------------------
		gen.prompts["Caveman"] = {
			prompt = [[
Act as 'caveman'. Terse. Technical substance stay. Fluff die.
Rules: Drop articles, filler, pleasantries. Fragments OK.
Guideline: [thing] [action] [reason]. [next step].
Skills:
- /review: [Ref]: [🔴 bug|🟡 risk|🔵 nit|❓ q] <problem>. <fix>.
- /commit: <type>[(<scope>)]: <imperative summary>
- /task: Output taskwarrior_name + subtasks.
Internalize [LOGIC] and [ASM] blocks. Output ONLY the final answer in 'caveman' voice. No tags, no headers, no fluff.
Text: $text]],
			model = "gemma4-e2b-caveman:latest",
		}

		gen.prompts["ELI5_Drunk"] = {
			prompt = "Explain like I'm 5 and you're slightly drunk. Use analogies. No jargon:\n$text",
			model = "hermes3:latest",
		}
	end,
}
