# Boolean Expression Optimizer & Circuit Simulator Pro

**Updated project README — 24 October 2026**

This repository contains a Gradio application for simplifying Boolean expressions and comparing the original and simplified logic.

## Features

- Supports variables `A` through `F`.
- Supports `&` (AND), `|` (OR), `~` (NOT), parentheses, and constants `0` and `1`.
- Simplifies Boolean expressions and checks equivalence using the truth table.
- Displays truth tables for up to six variables.
- Displays Karnaugh maps for up to four variables, with group markers where applicable and the simplified expression.
- Shows original and optimized logic-circuit diagrams with labeled input signals and output `F`.
- Creates an output comparison waveform based on truth-table rows. This is not a timed VCD waveform.
- Generates Verilog modules and an exhaustive testbench.
- Runs Verilog simulation through Icarus Verilog when `iverilog` and `vvp` are installed.

## Files in the repository root

Make sure these files are at the top level of the GitHub repository, not inside another nested folder:

- `app.py` — application source code.
- `requirements.txt` — Python packages.
- `Dockerfile` — Docker build instructions; installs Icarus Verilog.
- `render.yaml` — Render service configuration.
- `.gitignore` — files Git should ignore.
- `.dockerignore` — files Docker should leave out of the build context.
- `README.md` — project instructions (rename this downloaded file to `README.md` if replacing the repository README).

## Test the app locally

Python 3.12 is recommended.

```bash
pip install -r requirements.txt
python app.py
```

Open the local URL printed in the terminal. To test Verilog simulation locally, install Icarus Verilog so both `iverilog` and `vvp` are available on your PATH.

## Deploy on Render

1. Push the files above to the `main` branch of a new GitHub repository.
2. In Render, choose **New + → Web Service**, then connect that repository.
3. Select **Docker** as the runtime.
4. Keep **Root Directory** blank.
5. Set **Docker Build Context Directory** to `.` and **Dockerfile Path** to `./Dockerfile`.
6. Leave **Docker Command** and **Pre-Deploy Command** blank so Render uses the Dockerfile defaults.
7. Choose the Free compute plan if you do not want a paid service, then create the service.
8. Check the build logs. The deployed service must be built from the repository's Dockerfile for Icarus Verilog to be installed in the image.

Do not add a placeholder environment variable such as `NAME_OF_VARIABLE`. The app does not require that variable by default.

## Expressions to test

| Input expression | Expected simplified result |
|---|---|
| `(A & B) | (A & ~B)` | `A` |
| `(A | B) & (B | C) & (B | ~C)` | `B` |
| `A & 0` | `False` (constant zero) |
| `A | ~A` | `True` (constant one) |

## Troubleshooting

- **Indentation or syntax error:** use the complete `app.py` from this project rather than copying only a function from an older version.
- **Icarus Verilog not installed:** verify Render is using Docker and building from the root `./Dockerfile`. If a different runtime or Dockerfile is configured, the simulation tools may be absent.
- **K-map message for more than four variables:** this is an intentional display limit; truth-table verification still supports up to six variables.
- **Diagram labels or wires appear wrong:** confirm the `app.py` deployed by Render is the latest committed version, and check the build/deploy logs after the commit finishes.
- **After uploading updates:** wait until Render finishes deploying, then refresh the app page before testing.

## Notes

The waveform plots the original and optimized output across truth-table input combinations. It does not represent simulation time or a VCD timing trace. Boolean equivalence is checked independently through all truth-table input combinations.
