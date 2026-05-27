## Norms & Conventions
For a development tool, especially a highly customizable one like Emacs, being stupid & simple is a virtue.

Focus on the study and development rather than tweaking tools endlessly. If the tools that other excellent developers use cannot work for you, that's either health issues or a mindset difference still not familiar to you.

Improve health, and learn the mindset, do not endlessly tweak the tools.

- Minimal - Keep it simple and stupid
  - Learn basic features before adding third-party packages.
  - Find and use built-in features unless a third-party package outperforms.
    - For the third-party package's improved version of the built-in features, not for its extensions, which adds extra maintenance, unless it's stable.
    - If a tool such as Emacs requires complex, additional packages or configuration to accomplish a task, the tool is mostly not suitable for the task.
    - Or you haven't found the particular way of how the tool does this kind of task. Do it in the Emacs way instead of relying on extra packages.

- Do not use loop for configuration
  - Use a function that encapsulates the action and apply the function on each setting.
  - This eases maintenance when edge-cases emerge.

- Git
  - The `main` branch is for daily use and acts as an experimental branch to test out new settings & packages.
  - The `work` branch stays always usable and stable. So when `main` breaks, Emacs can still be properly loaded from `work`.

## News
2026-05-25: The old `main` history has been preserved in the `main-archived_1` to allow the new configuration.
