# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

The Ziggy Vite example is an example app built on Ziggy, with its UI built by Vite. It is a copy of the Ziggy template, renamed. It takes Ziggy from a version tag of Ziggy's repository on GitHub and holds no Ziggy source.

"The UI", "the backend" and "the native app" mean what [Ziggy's glossary](https://github.com/ashleydavis/ziggy/blob/main/docs/glossary.md) says. Use those terms.

- `ui/`: the UI. `ui/src/lib` holds its plain functions and `ui/src/test` their unit tests.
- `backend/`: the app's Zig code. `backend/src/app.zig` declares the app with `ziggy.core.App`: each message name with its handler, each task type with its handler, and the menu, UI files and UI query it gives Ziggy's core. The handlers are in `backend/src/lib`. `backend/src/test` holds its unit tests.
- `native/<platform>/`: the native app for each platform.
- `scripts/`: the scripts that build, run, package and set up the app, with the shell libraries they share (`scripts/lib`).
- `smoke-tests/`: the smoke tests, with a library for each platform.

## Platforms

The app is developed on Linux and delivered and tested on Linux, Windows, macOS, Android and iOS. Every test must work on each platform it runs on. On Windows the scripts run under Git Bash.

## Ziggy

- Ziggy's code lives in its own repository, https://github.com/ashleydavis/ziggy. This repository pins it to a version tag in `build.zig.zon` (the `ziggy` dependency), `package.json` (`ziggy-ui`), the Xcode projects in `native/macos` and `native/ios` and `native/android/app/build.gradle`, all to the same tag. A move to a new version of Ziggy changes every one of them together.
- Never edit Ziggy's code from this repository. If a change needs one in Ziggy, stop and say what and why.

## Rules

- When writing plans, do not add any steps for "Human Verification" or "Human Testing". Plans you write should be tested automatically by unit tests and smoke tests. No human will be testing your work.
- YOU ARE RESPONSIBLE FOR THE CODE IN THIS REPO. IT DOESN'T MATTER "IF IT WAS ALREADY LIKE THAT": YOU ARE EXPECTED TO FIX IT.
- IF YOU DON'T KNOW WHO WROTE THE CODE, IT MEANS YOU (CLAUDE) WROTE THE CODE.
- IT IS ALWAYS YOUR RESPONSIBILITY TO FIX COMPILE ERRORS AND FAILING TESTS. NEVER USE THE "PREEXISTING" EXCUSE.
- ANY addition of "test only" scaffolding to the app code must be approved by the human first, or not added at all. That means anything shipped in the app that exists solely to let tests set up or inspect state: seeding functions, injection points, test-only commands, events or globals. The test hooks are compiled in only by the `test-hooks` build option, which the `package` scripts never set, and scenario `8-release-has-no-hooks` checks the release build has none. If a test needs state, set it up from outside the app (write the file, place the data on disk).
- NEVER WRITE A WORKAROUND, A FAKE, A MOCK, A STUB OR A HAND-WRITTEN "REPLACEMENT" FOR A THIRD-PARTY SDK OR LIBRARY UNLESS THE HUMAN HAS SPECIFICALLY APPROVED THAT EXACT THING FIRST, IN THE MESSAGE YOU ARE ACTING ON. Approval must be explicit and asked for in advance. Silence is not approval. An earlier approval for one thing is not approval for another and is not a standing permission. If you are unsure whether something counts, it counts: stop and ask. This bans reimplementing a vendor SDK, hand-writing a wire protocol or response parsing that a maintained library already does and aliasing a real package to your own substitute at build time.
- If the real library will not work in an environment, STOP AND ASK THE HUMAN. Do not fill the gap yourself. Say what does not work and what the options are, and wait for an answer. A shim that makes a build succeed while quietly reimplementing the library is worse than a build that fails.
- The same applies to tests: do not make a test pass by faking the thing under test, skipping it or running it only when an environment variable that is normally unset is set. A test that reports success without asserting anything is worse than no test. If a test needs real infrastructure, provision it or tell the human it cannot be done.
- NEVER WRITE A FAKE TEST. A fake test is any test that cannot fail when the thing it names is broken. This includes: a test written against a UI, channel, element id, function or file that you have not verified exists; a test whose assertions you invented from what you imagined the code does rather than read from the code; a test that skips by default so its body has never executed; and a test you have never watched run. If you cannot run a test you have written, say so in that message and say that it is unverified. Do not report it as passing.
- RUN EVERY TEST YOU WRITE, AND WATCH IT FAIL FIRST. Break the thing it covers, or assert the wrong value, and confirm the test goes red before you accept it.
- DO NOT DELETE A FAILING TEST. GET IT WORKING. This covers every way of making a failure go away without understanding it: removing the file, commenting the body out, marking it skipped, loosening the assertion until it cannot fail or catching the error and passing anyway. If a test will not run, the runner or the import is what needs fixing. Deleting a test whose subject no longer exists is fine. If you believe a test should go for any other reason, stop and say which test and why, and wait for an answer.
- REMOVING, TRIMMING, LOOSENING, SKIPPING OR WORKING AROUND A TEST TO STOP IT FAILING IS CHEATING AND IS NEVER ALLOWED. That covers deleting the failing assertion and keeping the rest, widening what an assertion accepts, adding a wait or retry so a race passes and ignoring an error line in a check. A failing test is a bug in the code or in the test: find the cause and fix it.
- NEVER LIE ABOUT WHAT YOU HAVE DONE OR VERIFIED. Do not say a thing works, passes, is tested, is verified or is complete unless you ran it and read the result in this session. Do not describe an intention as an outcome. Do not present a skipped test, a compile that merely succeeded or a code reading as evidence that behaviour is correct. If you are inferring rather than observing, say so, and say what you did not check.
- NEVER SHIP A STUB THAT PRETENDS TO WORK. If you cannot implement something now, make it throw (or return an error, in Zig) with a message naming what is missing. Never leave a no-op in a code path that a caller will treat as success.
- ALL FAILURES MUST BE NOISY. Never write a path that discards an error, drops data or returns a success value when the work did not happen. A missing capability fails and names itself. Prefer a loud crash over a quiet wrong answer, always.
- WORKAROUNDS ARE NOT ACCEPTABLE. Fix the cause. Do not change an input, an expected value or a check so that a failure goes away without finding out why it happened: converting a Windows path's backslashes to slashes, loosening an assertion, adding a retry, a wait or a platform special case. If the cause is outside the machine (a network that dropped, a remote service that was down), tell the human and wait.
- YOU FIND A BUG, YOU FIX IT. A test that failed once and passed the next time is a bug: a race, a fixed timeout that load can exceed or a resource it does not own. Find the cause and fix the cause.
  - "It passed on the retry", "it fails only under load", "it is unrelated to my change" and "it was already like that" are not results.
  - Do not write a bug down instead of dealing with it: no registry, known-issues list, doc section or TODO comment naming a test that sometimes fails.
  - The only failures outside your reach are outside the machine: a network that dropped, a disk that filled or failed, a remote service that was down. The code should expect those and fail loudly, saying what happened. Everything else is yours: if you cannot find the cause yet, say what you have ruled out and what you will look at next.
- NEVER USE EM DASHES.
- Never use memory.
- All Claude configuration goes in this repository only, not in the home directory.
- Slash commands go in `.claude/commands/`, as a markdown file per command, grouped in a subdirectory where there is more than one of a kind. A request for a "skill" means one of these. Do not create a `.claude/skills/` directory or a `SKILL.md`. A command file has frontmatter carrying `description` and nothing else, then the prompt as ordinary markdown with a heading and steps. The `description` says what the command does, not when to trigger it.
- Never write `mise exec --` in docs, READMEs, comments or script help text. It is only for commands Claude runs itself.
- Never say "you are right", "you're right" or any other agreement as a way to open a reply. Say what was wrong and what you will do about it. Never tell the human untested code can be committed now and tested later: say it is untested, and say what would test it.
- Never stash code unless asked.
- Never use `cd` to change directories permanently. Use it only inside a single command.
- Never invoke shell scripts directly (for example `bash scripts/build-linux.sh`). Use the `bun run` script from `package.json` (for example `bun run build:linux`).
- HIGH PRIORITY: `rm -r` is banned, in every form and every flag combination that includes it (`-r`, `-R`, `--recursive`, `-rf`, `-fr`), unless the human asks for that exact deletion in the message you are acting on. This covers commands you run, commands you ask the human to run and any `rm -r` you write into a script, a test or a runner. If you believe something has to be removed recursively, stop and say what and why. Removing a single file by name is fine.
- The `run:<platform>` commands build the app before launching it, so the running app is always built from current source. Never blame a change that does not show up on a stale build. Find the real cause.
- Never say something was "intentionally done" unless the human explicitly asked for that exact behaviour. State what the code does and own the mistake.
- Something you previously wrote in a plan is not something the human approved. Never give "it was in the plan" as the reason for a change. "What is the reason for X?" means "Why was that change necessary?".
- Plans are transient. Never reference a plan from anything that stays: documentation, a slash command, code, comments, a commit message or another doc. If a plan contains something worth keeping, copy the content itself into the thing that needs it.
- When the human asks for an ETA, give one at once, as a time range with what it depends on. Never refuse, argue or ask a question first.
- When the human asks you to record a note or a todo, never change their writing or distort it in any way.
- Keep this file terse. State the rule and stop: no lists of examples, no worked illustrations.

## Tests running beside each other

- NEVER WAIT FOR ANOTHER RUN'S TESTS TO FINISH BEFORE RUNNING YOUR OWN. Start the run you need when you need it. Do not watch for other runs, poll for them or treat another checkout's activity as a reason to hold off.
- EVERY TEST MUST SURVIVE RUNNING BESIDE ANOTHER COPY OF ITSELF AND BESIDE EVERY OTHER SUITE, INCLUDING ONES STARTED FROM ANOTHER CHECKOUT OF THIS APP, OF ZIGGY OR OF ANY OTHER PROJECT ON THE MACHINE. A test that only works when it is the only thing running is broken.
  - Nothing may claim a machine-wide resource by a fixed name: no hardcoded port, no fixed path under `/tmp` or anywhere else, no fixed lock path and no fixed device. Allocate a free port, and give each test a temporary directory of its own rather than naming one yourself.
  - NEVER kill a process by matching its command line. `pkill -f`, `pkill`, `killall` and anything else that selects by name will kill the identical process belonging to another checkout's run. Kill the pids you started and their descendants.
  - Interference is not flakiness and must never be dismissed as it. A suite that passes alone and fails in company contends on something shared: find it and remove it.

## Android emulators

- `run:android` and the Android smoke tests (`test:smoke:and`) use the devices named in `ZIGGY_ANDROID_DEVICES` (adb serials, space separated), else any attached emulator or device, whichever project started it. A run claims each device under Ziggy's per-device lock (`ziggy_android_device_lock_path` in `scripts/android-common.sh`), so two Ziggy runs never install over each other.
- Never assume whether an emulator is attached. Run `adb devices` at the point you need the answer, never from a reading taken earlier: the human starts and stops emulators without saying so. If the check disagrees with what you expected, the check is right.
- Never start, stop, restart or repair an emulator, never create or remove a tap or a bridge and never run sudo. If an emulator is broken, report it and leave it.

## Git

- HIGH PRIORITY: Never commit, stage, push, revert or perform any other dangerous or hard-to-reverse Git operation (including `git add`, `git commit`, `git push`, `git reset`, `git restore`, `git checkout` of changes, `git rebase`, `git merge`, force-push and branch creation or deletion) without an explicit direction to do so in that message. An earlier instruction is a one-time direction: it does not authorise repeating the operation after later edits. When in doubt, leave the Git state alone and ask.
- Expect the human to stage things. They often `git add` your work as they review it and commit whenever they choose, so the staging area and the working tree change under you without warning. That is never a mystery to investigate. Use `git status` and `git diff HEAD` (or `git diff --cached`) rather than a bare `git diff`, which shows nothing for staged work. Never "tidy it up" by unstaging, resetting or checking out.
- Never bypass git hooks: no `--no-verify`, no `-n` on a commit, no change to `core.hooksPath`.
- When creating a new worktree, never use `EnterWorktree` with a `name` parameter. Instead: (1) run `git branch --show-current` to get the current branch, (2) run `git worktree add -b <new-branch> .claude/worktrees/<name> <current-branch>`, (3) then use `EnterWorktree` with the `path` parameter to enter it.

## Languages and scripts

- THIS REPOSITORY USES TYPESCRIPT, ZIG AND SHELL SCRIPT. NOTHING ELSE. The UI is TypeScript. The backend and the Linux and Windows native apps are Zig. The scripts are shell. Swift (the macOS and iOS native apps) and Java (the Android native app) are an exception, because those platforms require them, and are no licence to add more native code than the platform forces. `python3`, perl, Ruby, Go and friends are banned outright, including as an undeclared dependency. The pinned tools are in `mise.toml`.
- A SHELL SCRIPT CONTAINS SHELL. Do not embed another language inside one, in any form: not `python3 -c "..."`, not `bun -e "..."`, not `node -e`, not a heredoc feeding an interpreter, not an awk program doing the work of a script. This holds however short the snippet is.
- When a shell script needs something that looks beyond shell, find the shell answer first: `stat`, `cmp`, `uuidgen`, `od`, `jq`. Assume there is one until you have tried it and watched it fail. Only when there is no shell answer does it become a TypeScript helper: a `.ts` file under `scripts/`, with a comment block saying what it is for and a documented argument list. See `scripts/ios-device.ts`.
- Shell scripts always use a `.sh` extension.
- EVERY NEW SCRIPT COMES WITH A MARKDOWN FILE BESIDE IT, named after the script, covering what it is for, how it is invoked and what each argument means. Keep it current.
- DO NOT WRITE TESTS FOR SHELL SCRIPTS, and do not create `*.test.sh` files. Shell here is the test harness itself, and what proves it works is running the real suite it drives. If you believe a piece of shell cannot be trusted without a test, stop and ask.
- TEST MARKER FILES ARE BANNED. Do not add a file whose only job is to tag a test directory so a runner treats that test differently. If a runner needs to know something about a test, it must read it from the test itself or work it out at the time.
- NEVER WRITE A SCRIPT, A FILE OR A HELPER OF ANY KIND TO WORK AROUND A LIMIT OF YOUR OWN HARNESS (a command timeout, a refused command, a killed background job). Run the command directly. If it cannot finish inside your limit, say so in one line and give the human the command, then wait.

## Mobile environment

- The local iOS development environment is fixed: macOS 12.7.6 and Xcode 14.2. Never bump a tool or framework version that would require a newer Xcode or macOS. When mobile code needs a newer API, prefer an availability guard or a compatible approach. If a version bump seems unavoidable, stop and ask first.

## Code style

- **Types**: interfaces with PascalCase, explicit return types.
- **Interface names always start with `I`**, without exception, including ones that describe plain data and ones that describe a function.
- **Naming**: camelCase for variables and methods, PascalCase for classes and interfaces.
- **Imports**: named imports for functions, default imports for modules.
- **Functions**: named functions for top-level methods, arrow functions for callbacks.
- **Async**: use async/await.
- **Formatting**: 4-space indentation, braces on the same line as control statements.
- **Comments**: line comments with `//` preceded by a blank line, method docs above the function, using `//`.
- All global symbols (functions, types, interfaces, classes, constants) must have a `//` comment block above them explaining their intent.
- All fields in interfaces, classes and structs must have a `//` comment explaining their purpose.
- Never use single-character variable names, including arrow function parameters. Use long descriptive identifiers.
- Do not introduce a constant that is used once. A value used in one place goes inline at that place, unless the literal does not explain itself and the name is what says why that value.
- Avoid single line if statements. All if statements have braces around the body.
- Never put multiple statements on one line.
- Never write an object literal on one line. Open the brace, put each property and each spread on its own line ending in a comma and close the brace on its own line. The only exception is an empty `{}`.
- Put `else` and `catch` blocks on a new line.
- UI unit tests go in `ui/src/test` and the backend's in `backend/src/test`.
- Use `test(` not `it(` in Jest test files.
- Logic in the UI worth testing goes in a plain function under `ui/src/lib` with a unit test. Do not extract trivial logic only to gain a test.
- Do not invent a new file to "get a test on it". When logic belongs to something that already exists, put it there. When it belongs nowhere and is small enough to read in one go, leave it where it is with a comment saying why. The test that exercises the feature covers it.
- Avoid the `any` type in normal code, although it is ok sometimes in test code.
- Never use anonymous object types inline (for example `Promise<{ foo: number }>`). Define a named interface instead.
- Never use the IIFE async generator pattern. Extract to a named `async function*` instead.
- Never use `ReturnType<typeof ...>`. Use the type directly.
- Never use the `unknown` type. Use the type directly.
- Do not add a global variable (a module-level mutable variable, a Zig top-level or struct-level `var` or a `threadlocal`) unless the human explicitly asks for it. Pass the value down from whoever owns it instead.

## Restrictions

- TypeScript code should always compile (`bun run compile`) and the Zig code should always build (`bun run compile:zig`) after making changes.
- All tests should pass after making changes.
- Prefer to minimize the size of code changes.
- Prefer not to update test code unless needed.
- Add new tests for new code. Every function that is new, that you edit or that the human asks you about should have unit tests.
- Backward compatibility is not required.
- Use imports instead of requires.
- All imports should be at the top of the file and not inside any functions.
- Don't use dynamic imports.
- Don't add exception handling unless asked for.
- Don't use default or optional parameter values unless specifically asked to.
- Never reformat or rewrite entire files. Only edit the specific lines that need to change.

## Writing

- No serial comma. Write "Linux, Windows and macOS", never "Linux, Windows, and macOS". Where a list reads ambiguously without it, rephrase the sentence.
- Never use em dashes. Use a period, comma, colon or parentheses instead.
- Never write "by hand". Say what the reader does instead, or what it is done without: "without the command", "yourself", "from the Actions tab".
