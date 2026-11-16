# ArcBest CVAT demo: instructions for Claude

You are helping someone run a CVAT demo on their own machine. This folder is self-contained.
Read `README.md` first. Work from this folder. Explain each step in plain words as you go.

## Goal

1. Open-source CVAT v2.82.0 running at http://localhost:8080.
2. The demo project "ArcBest | Dock Events Demo" restored, with its quality rules.
3. A quality report printed.
4. The person walked through `WALKTHROUGH.md`, one beat at a time.

## Steps

1. Check prerequisites: `docker info` works (Docker Desktop is running), `git --version`, `curl`,
   Python 3.10 or newer. On Windows this must run inside WSL 2 with Docker Desktop's WSL
   integration on. Run scripts as `bash scripts/<name>.sh` so file permissions do not matter. If one is missing, tell the person what to install and stop.
2. Run `bash scripts/setup.sh` (or `bash start.sh`, which runs steps 2 to 4 in one go). The first run downloads CVAT's images and can take 5 to 15 minutes.
   Run it in the background and wait. It is safe to run again.
3. Run `bash scripts/restore.sh`. It prints the links and saves them to `demo/local-urls.txt`.
4. Run `bash scripts/quality_report.sh` and show the person the scores. Low scores are expected: the
   first-pass model only finds people, and the report shows exactly that gap.
5. Tell the person to sign in at http://localhost:8080 as `demo`, with the password from the file
   `.demo-credentials`. Do not print the password in chat; point them to the file.
6. Walk through `WALKTHROUGH.md` with them. Use the links in `demo/local-urls.txt`.
7. Only if they ask to run a model: `bash scripts/auto_annotate.sh`. It downloads PyTorch, about 300 MB, and
   replaces the first-pass boxes in the task.
   The answer key is never touched. `model/person_det_func.py` explains how to swap in their own model.

## Rules

- Steps marked **CVAT Online** in `WALKTHROUGH.md` do not exist in open source. Do not try to
  build or imitate them. Point to that screen in `clickthrough.html` and say it is a paid feature.
- Do not change CVAT's source in `docker/cvat`.
- Do not delete data without asking. `scripts/stop.sh --delete` removes everything in this CVAT.
- This CVAT is for evaluation on one machine. It is not hardened for the internet.
- The photos are a public dataset, not the person's own data. See `LICENSES.md`.

## If something fails

- Server not up: `docker ps`, then `docker logs cvat_server --tail 50`.
- "Server Error (500)" right after the first start: CVAT is still loading. Wait a minute and run
  the same script again.
- Restore fails: `docker logs cvat_worker_import --tail 50`.
- Report fails or says jobs are not checkable: run `scripts/restore.sh` again; it re-applies the
  answer key state and the quality rules.
- Clean restart: `scripts/stop.sh --delete`, `scripts/setup.sh`, `scripts/restore.sh`.
