import json

with open("workflows/multiangle.json") as f:
    wf = json.load(f)

for k, v in wf.items():
    if v.get("class_type") == "KSampler":
        print("KSampler ID:", k)
