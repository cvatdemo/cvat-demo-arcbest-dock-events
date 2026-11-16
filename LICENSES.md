# Licenses and credit

## Photos and labels

Forklift Object Detection dataset (421 images, forklift and person), exported from images.cv via Roboflow Public and mirrored on Hugging Face at keremberke/forklift-object-detection. Licensed CC BY 4.0 (https://creativecommons.org/licenses/by/4.0/). Changes: merged the train and valid splits, subset to 150 images, converted to CVAT rectangle format, and added an illustrative dock_activity scene tag by rule..

- Source: Forklift Object Detection (keremberke mirror on Hugging Face; original on Roboflow Public, exported from images.cv) (https://huggingface.co/datasets/keremberke/forklift-object-detection)
- License: CC BY 4.0
- Changes made for this demo: a subset of 150 photos; labels converted to CVAT format; an
  image-level tag added by rule on the answer-key photos.

- Real-world forklift and warehouse imagery with two annotated classes: forklift and person. These cover two of the five spec labels.
- The dataset has no pallet, truck, or freight_item boxes, so those three spec labels have no answer-key (ground-truth) examples here. They stay in the spec for live annotation only, and the quality recall requirement on freight_item and truck cannot be scored against this data.
- The freight_item activity attribute (moving/stopped/loading/unloading) and the dock_activity scene tag are illustrative defaults on a still-image dataset, not real temporal labels. The demo narrative (video tracking and event logging) is told over these frames.
- The dock_activity tag is derived from the boxes by rule (see tag_rules): a forklift present in the frame is treated as active freight handling (scene=loading), otherwise idle. This is a stand-in to show the tag mechanic, not a measured scene classification.
- All 20 answer-key frames contain a forklift, so every GT frame is tagged scene=loading; there are no idle examples in the answer key, so the tag-accuracy requirement is only lightly exercised here.

## Model

- `model/person_det_func.py` uses torchvision's Faster R-CNN MobileNetV3 detector with COCO
  weights. torchvision is BSD 3-Clause licensed. It is downloaded only if you run
  `scripts/auto_annotate.sh`.
- The pre-labels in the backup were made in CVAT Online with its built-in model YOLO v7 (onnx-wongkinyiu-yolov7). YOLO v7 (WongKinYiu/yolov7) is GPL-3.0 licensed. GPL-3.0 is a copyleft license to review before any production use; the demo first pass is generic and illustrative only. The `scripts/auto_annotate.sh` stand-in in `model/` does not use YOLO v7: it uses torchvision (BSD 3-Clause), so you can swap in your own model without inheriting a copyleft license.

## CVAT

CVAT is open source under the MIT License: https://github.com/cvat-ai/cvat. `scripts/setup.sh`
downloads it at tag `v2.82.0`. CVAT Online features shown in `clickthrough.html` are not part
of the open-source release.
