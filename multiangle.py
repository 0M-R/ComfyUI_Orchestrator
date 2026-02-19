import os
import json
import random
import requests
import copy

PORT = 8188
SERVER = f"http://127.0.0.1:{PORT}/prompt"

MODEL_FOLDER = "model/2"
PROMPTS_FOLDER = "prompts/multiangle"
OUTPUT_FOLDER = "output/multiangle"
WORKFLOW_FILE = "workflows/multiangle.json"

print("Loading workflow from:", WORKFLOW_FILE)

MODE = "all"   # "all" or "one"

#  CHANGE THESE NODE IDS
IMAGE_NODE_ID = "81"
PROMPT_NODE_ID = "108"
SEED_NODE_ID = "105"          # your KSampler node
SAVE_NODE_ID = "9"          # your SaveImage node


with open(WORKFLOW_FILE, "r") as f:
    workflow = json.load(f)

os.makedirs(OUTPUT_FOLDER, exist_ok=True)

models = sorted([
    f for f in os.listdir(MODEL_FOLDER)
    if f.lower().endswith((".png", ".jpg", ".jpeg"))
])

prompts = sorted([
    f for f in os.listdir(PROMPTS_FOLDER)
    if f.endswith(".txt")
])


def generate(model_img, prompt_file):

    seed = random.randint(1, 999999999)

    model_path = os.path.join(MODEL_FOLDER, model_img)
    prompt_path = os.path.join(PROMPTS_FOLDER, prompt_file)

    with open(prompt_path, "r") as f:
        prompt_text = f.read().strip()

    filename = f"{os.path.splitext(model_img)[0]}_{os.path.splitext(prompt_file)[0]}"

    wf = copy.deepcopy(workflow)

    # Inject image
    wf[IMAGE_NODE_ID]["inputs"]["image"] = model_path

    # Inject prompt
    wf[PROMPT_NODE_ID]["inputs"]["text"] = prompt_text

    # Inject seed
    wf[SEED_NODE_ID]["inputs"]["noise_seed"] = seed

    # Inject output name
    wf[SAVE_NODE_ID]["inputs"]["filename_prefix"] = os.path.join(OUTPUT_FOLDER, filename)

    payload = {
        "prompt": wf,
        "client_id": "multiangle_generator"
    }

    response = requests.post(SERVER, json=payload)
    print("Queued:", filename, "|", response.text)


if MODE == "one":
    for m, p in zip(models, prompts):
        generate(m, p)
else:
    for m in models:
        for p in prompts:
            generate(m, p)

print("Done.")
