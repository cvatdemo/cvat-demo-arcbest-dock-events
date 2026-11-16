# CVAT auto-annotation function: a small open detector (torchvision Faster R-CNN, COCO weights)
# that boxes people. It stands in for your own model: replace the model below with yours, return
# boxes with your label names, and the same command uploads them to CVAT.
#
# Run it with: scripts/auto_annotate.sh
import PIL.Image
import torch
from torchvision.models.detection import FasterRCNN_MobileNet_V3_Large_FPN_Weights, fasterrcnn_mobilenet_v3_large_fpn

import cvat_sdk.auto_annotation as cvataa

_weights = FasterRCNN_MobileNet_V3_Large_FPN_Weights.DEFAULT
_model = fasterrcnn_mobilenet_v3_large_fpn(weights=_weights).eval()
_transforms = _weights.transforms()
_PERSON = _weights.meta["categories"].index("person")

# The label name must match a label in the CVAT project.
spec = cvataa.DetectionFunctionSpec(labels=[cvataa.label_spec("Person", 0)])


def detect(context: cvataa.DetectionFunctionContext, image: PIL.Image.Image):
    threshold = 0.5 if context.conf_threshold is None else context.conf_threshold
    with torch.no_grad():
        result = _model([_transforms(image.convert("RGB"))])[0]
    return [
        cvataa.rectangle(0, [float(v) for v in box])
        for box, label, score in zip(result["boxes"], result["labels"], result["scores"])
        if int(label) == _PERSON and float(score) >= threshold
    ]
