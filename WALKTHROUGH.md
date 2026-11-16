# Walkthrough: ArcBest demo on open-source CVAT

A self-guided tour of the same flow you saw in the demo, on your own machine. Open `clickthrough.html` next to this file to see each screen as it looked in CVAT Online.

Each step is marked **Free** (works in open-source CVAT) or **CVAT Online** (a paid feature, shown in the click-through only). Run `bash start.sh` first (or `bash scripts/setup.sh` and `bash scripts/restore.sh`); the links below are printed by `restore.sh` and saved in `demo/local-urls.txt`.

## c. Automatic annotation

1. **A batch of 150 images** (Free). There are 150 frames here, split into jobs so several people can work at the same time. This is illustrative public warehouse footage, not your data; your own clip is the real test, which is why we would ask you for one.
2. **Task actions** (Free). You asked about ML-assisted labeling. Before anyone draws a box, a model takes the first pass over the whole batch of frames. People then correct, they don't start from blank video.
3. **Choose a model** (CVAT Online). First we choose which model takes the first pass over the video.
   - On open source: not available. See this screen in `clickthrough.html`.
4. **Models you can use** (CVAT Online). Any model plugs in and shows here. Your own, one from Hugging Face, or Roboflow. We won't debate a specific model; the point is the first pass is automatic.
   - On open source: not available. See this screen in `clickthrough.html`.
5. **Automatic annotation** (CVAT Online). Pick a model and map what it knows to your labels. CVAT lines up the names it shares with your labels, so person maps to person and truck to truck on their own. This is a generic model, so it finds person and truck but it has never seen a forklift or a pallet. That gap is the point: it is an honest first pass, and the quality score will expose exactly what it missed. Your own freight model plugs in the same way once you have one. One click and every frame in the batch gets a first pass.
   - On open source: this dialog needs models deployed with Nuclio, a separate setup. The simpler route is `scripts/auto_annotate.sh`, which runs a model on your machine and uploads its boxes.
6. **The job the model labeled** (Free). Here it is in the job list. Let's open it and see what the generic model did, and did not, catch.
7. **Model pre-labels** (Free). The model has already made its first pass across these frames. It boxes people, but it leaves the forklifts and pallets untouched, because it was never trained on them. That gap is exactly what people fill in, and what the quality check measures.
   - Try it: open the `model_job` link. Press F and D to move between images.

## d. Human in the loop

8. **Filter by who made it** (Free). People fix what the generic model missed and add the forklift and pallet tracks and the activity states. A reviewer can show only what the model drew, or only what a person drew, and correct from there. Every label keeps track of who made it, so you can always see what was checked.
   - Try it: in the job, click Filters, Add rule, pick Source.
9. **Back to the batch** (Free). The question is who does the correcting.
10. **Add annotators** (CVAT Online). Quality comes from three parts working together. The model takes the first pass, CVAT's vetted annotators correct and validate it through Outsource Labeling, and your own team has the final say on anything uncertain. They all work to the same labels and the same quality rules, in the same project.
   - On open source: not included. CVAT's annotators are a CVAT Online service.

## e. Quality you can measure

11. **The answer key** (Free). It is a small set of frames, 20 here, labeled carefully once. Every job is scored against it automatically, whoever drew the labels, a model, our annotators or your team. Quality is measured, not assumed, so a mislogged event is caught before it reaches you.
   - Try it: open the `answer_key` link.
12. **Back to the batch** (Free). Back to the batch, to the job the model labeled.
13. **The model's job again** (Free). It still has only the generic model's labels in it, people but no forklifts or pallets. Let's pretend an annotator calls it done.
14. **Finish the job** (Free). The annotator clicks Finish the job.
15. **Confirm finishing** (Free). because finishing hands the job over as completed work.
16. **The job bounces** (CVAT Online). It checked the job against the answer key before accepting it, and it names what is missing, the forklifts and pallets the generic model never found. The work goes back to the annotator, not on to you. A mislogged or incomplete batch never becomes training data. A low score here is the system working.
   - On open source: the job completes without the check. Run `scripts/quality_report.sh` afterwards to get the same scores.
17. **Back to the batch** (Free). Every job has a score, not just this one.
18. **Quality control** (CVAT Online). This is where you, or we, check quality at any time.
   - On open source: not available. See this screen in `clickthrough.html`.
19. **A score for every job** (CVAT Online). Every job gets a score against the answer key. The generic model scores low here, which is exactly the point: you see how far it is from your standard before you rely on it. A low score is the system working, not a failure. On your own footage, with your own model, this is the number a pilot measures.
   - On open source: run `scripts/quality_report.sh` for the same per-job scores in the terminal. The score screens in the browser are CVAT Online.
20. **Your quality rules** (CVAT Online). These are the rules. Moving objects must be found 95 percent of the time, because a missed object is a missed event. The activity state and scene tag must be 90 percent right, because that is the event itself and a wrong state logs the wrong event. Boxes overall must be 80 percent right so tracks line up frame to frame. You set these, and every job is held to them.
   - On open source: the rules are loaded from `demo/quality.json` by `scripts/restore.sh` and used by the report. The requirements screen itself is CVAT Online.
21. **Export for training** (Free). Once a batch passes, the checked, event-labeled video exports in your training format. Your team, or a training partner, trains on it. This answers where CVAT fits in your training workflows: it builds and proves the data, then stops at export on purpose. You keep control of training and deployment, with no lock-in. If you plug your own model in later for the first pass, the answer key keeps checking every batch whichever model drew it.
   - Try it: on the task page: Actions, Export task dataset.

---

The photos are a public dataset, not your data: Forklift Object Detection dataset (421 images, forklift and person), exported from images.cv via Roboflow Public and mirrored on Hugging Face at keremberke/forklift-object-detection. Licensed CC BY 4.0 (https://creativecommons.org/licenses/by/4.0/). Changes: merged the train and valid splits, subset to 150 images, converted to CVAT rectangle format, and added an illustrative dock_activity scene tag by rule.. Details in `LICENSES.md`.

